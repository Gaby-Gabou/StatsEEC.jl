"""
MSE(Mes,SimMes)
Takes the measured impedance and the simulated impedance and return the mean squared error.
"""
function MSE(Mes,SimMes)
    return sum((abs.(Mes .- SimMes)).^2)/length(Mes)
end

"""
R2(Mes,SimMes)
Takes the measured impedance and the simulated impedance and return the R².
"""
function R2(Mes,SimMes)
    return 1-( sum((abs.(Mes .- SimMes)).^2) / sum((abs.(Mes .- mean(Mes))).^2) )
end

"""
BayesianInference(Mes, Freq, Circuits)
Perform a Bayesian inference on the circuits. The function uses the Turing package to perform the inference.
The function takes the measurements of the impedance, the frequencies and the circuits to infer.
The function returns a vector of dictionnaries containing differnts values and information that describes the circuit.
"""
function BayesianInference(Mes, Freq, Circuits)
    @info "Begining of the Bayesian inferance"
    @model function circuit(parameters, Mes, Freq, circ, y)
        param=Vector(undef,length(parameters))
        for i in 1:length(parameters)
            if 'n' in string(keys(parameters)[i])
                param[i]~Uniform(0,1)
            else
                param[i]~(LogNormal(2.5,1.7)*parameters[i])
            end
        end
        y=abs.(Mes .- simulateimpedance_noiseless(circuitfunction(circ),param,Freq))
        error_term~truncated(Normal(0,1),lower=0.)
        y.~truncated.(Normal.(0,error_term),lower=0.)
    end

    res=[]

    for i in 1:length(Circuits)
        @info "Begining of the n° $i"
        SimMes=simulateimpedance_noiseless(circuitfunction(Circuits[i].circuitstring),Circuits[i].Parameters,Freq)

        model=circuit(Circuits[i].Parameters, Mes, Freq, Circuits[i].circuitstring, abs.(Mes .- SimMes))
        chain=sample(model,NUTS(1000,0.8),10000)

        llh=DynamicPPL.pointwise_loglikelihoods(model, chain)
        #llh_mat=reduce(hcat,values(llh))
        #llh_arr=reshape(llh_mat, 1, length(llh_mat))

        llh_mat = reduce(hcat, [vcat(collect(values(llh))[j]...) for j in 1:length(values(llh))])
        llh_arr = reshape(llh_mat, 1, length(chain), size(llh_mat)[2:end]...)

        ForWAIC=ArviZ.from_mcmcchains(chain,log_likelihood=llh_arr,library="Turing")

        push!(res,(MSE=MSE(Mes,SimMes),R2=R2(Mes,SimMes),rhat=rhat(chain),waic=waic(ForWAIC),chain=chain, Mes=Mes, SimMes=SimMes, Circuit=Circuits[i]))
    end
    return res
end