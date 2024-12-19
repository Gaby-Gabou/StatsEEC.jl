"""
nyquist(res, txt, legend, mc, mode)

Plot the Nyquist plot of the impedance.
res is the impedance to plot.
txt is the label of the plot.
legend is a boolean to display the legend or not.
mc is the color of the plot.
mode is the mode of the plot, "scat" for scatter plot and else for line plot.
"""
function nyquist(res, txt="fig", legend=true, mc=:blue, mode="scat")
    if mode=="scat"
        scatter(real(res),-imag(res), label=txt, legend=legend, mc=mc)
    else
        plot(real(res),-imag(res), label=txt, legend=legend, lc=mc, ls=:dashdot, lw=5)
    end
end

"""
nyquist!(res, txt, legend, mc, mode)

Plot the Nyquist plot of the impedance and add to another plot.
res is the impedance to plot.
txt is the label of the plot.
legend is a boolean to display the legend or not.
mc is the color of the plot.
mode is the mode of the plot, "scat" for scatter plot and else for line plot.
"""
function nyquist!(res, txt="fig", legend=true, mc=:black, mode="scat")
    if mode=="scat"
        scatter!(real(res),-imag(res), label=txt, legend=legend, mc=mc)
    else
        plot!(real(res),-imag(res), label=txt, legend=legend, lc=mc)
    end
end

"""
PlotEstimatedImpedance(Circ, Mes, Freq)
Takes a circuit, the measurements and the frequencies.
Plot the Nyquist plot of the measured impedance.
Plot also the Nyquist plot of the simulated impedance of the circuit, with the parameters of the circuit sampled from the posterior distribution obtained after the bayesian inference.
"""
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