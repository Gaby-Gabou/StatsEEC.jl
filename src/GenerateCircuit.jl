"""
GenerateCircuit(Mes, Freq, NBCirc=10)

Generate circuits using the function circuit_evolution from the EquivalentCircuits package.
Mes are the measurements of the impedance and Freq the frequencies.
The function is called NBCirc times. 
The circuits are stored in a vector.
Sometimes the function circuit_evolution can't find a solution, in this case the function pass to the next iteration.
"""
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