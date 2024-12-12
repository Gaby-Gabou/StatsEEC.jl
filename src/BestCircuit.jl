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