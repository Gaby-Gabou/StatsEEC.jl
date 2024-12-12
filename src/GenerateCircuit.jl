function GenerateCircuit(Mes, Freq, NBCirc=10)
    @info "Generating Circuits"
    Circuits=[]
    for i in 1:NBCirc
        res=try
            circuit_evolution(Mes,Freq,population_size=300, generations=10, terminals="RCP", head=8)
        catch
            @info "Error in iteration $i"
            continue
        end
        if (typeof(res)!=Nothing)
            push!(Circuits, res)
        end
    end
    @info "Circuits generated"
    return Circuits
end