function nyquist(res, txt="fig", legend=true, mc=:blue, mode="scat")
    if mode=="scat"
        scatter(real(res),-imag(res), label=txt, legend=legend, mc=mc)
    else
        plot(real(res),-imag(res), label=txt, legend=legend, lc=mc, ls=:dashdot, lw=5)
    end
end

function nyquist!(res, txt="fig", legend=true, mc=:black, mode="scat")
    if mode=="scat"
        scatter!(real(res),-imag(res), label=txt, legend=legend, mc=mc)
    else
        plot!(real(res),-imag(res), label=txt, legend=legend, lc=mc)
    end
end

function PlotEstimatedImpedance(Circ, Mes, Freq)
    P=plot()
    for i in 1:100
        param=[]
        for j in 1:(Circ[3].nrows-1)
            push!(param,sample(Circ[5][:,Symbol("param[$j]"),:1]))
        end
        plot!(P,nyquist!(simulateimpedance_noiseless(circuitfunction(Circ[8].circuitstring),param, Freq),"",false,:grey, "lines"))
    end
    plot!(P,nyquist!(Mes,"Measured", false, :blue))
    display(P)
end