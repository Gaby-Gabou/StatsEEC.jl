"""
EvaluateCircuit(Finalres)
Takes a vector of dictionnaries in input.
The function evaluates the circuits and returns the best circuit.
The evaluation is based on the R2, the rhat test, the shape of the prosterior distribution by the JarqueBeera test and the waic criteria.
"""

function EvaluateCircuit(Finalres)
    @info "Evaluation of the circuits"
    n=length(Finalres)
    pen=zeros(Int, n)

    for i in 1:n
        if Finalres[i][2]<0.99
            pen[i]+=1
        end

        for j in 1:(Finalres[i][3].nrows-1)
            if Finalres[i][3][Symbol("param[$j]")].nt[2][1]>1.05
                pen[i]+=1
            end
            #reshdi=hdi(Vector(get_params(Finalres[i][5]).param[j][:,1]))
            if pvalue(JarqueBeraTest(Vector(get_params(Finalres[i][5]).param[j][:,1])))<0.05 #|| (reshdi[2]/reshdi[1])>10
                pen[i]+=1
            end
        end
    end

    min=findmin(pen)
    Best=Finalres[min[2]]

    for i in 1:n
        if Finalres[i][4].estimates[1]<Best[4].estimates[1] && pen[i]==min[1]
            Best=Finalres[i]
        end
    end
    return Best
end