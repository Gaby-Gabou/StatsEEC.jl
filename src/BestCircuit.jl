"""
BestCircuit(path::String, nb)
Takes a CSV file and the number of circuits to generate.
Return the best circuit.
It is using the functions of the other files to generate the circuits, get different informations about them, evaluate them and plot the best.
"""
function BestCircuit(path::String, nb=10)
    donnee=CSV.read(path, DataFrame,header=false)
    Mes=donnee.Column1 .+ donnee.Column2 .* im
    Freq=donnee.Column3

    Circuits=GenerateCircuit(Mes, Freq, nb)

    BI=BayesianInference(Mes, Freq, Circuits)

    Best=EvaluateCircuit(BI)

    @info "Best Circuit : $Best"
    
    PlotEstimatedImpedance(Best, Mes, Freq)
end