using StatsEEC
using Test
using CSV,DataFrames

StatsEEC.BestCircuit("C:/Users/gab78/Downloads/Data/OER_10min.csv", 5)

donnee=CSV.read("C:/Users/gab78/Downloads/Data/OER_10min.csv", DataFrame,header=false)
Mes=donnee.Column1 .+ donnee.Column2 .* im
Freq=donnee.Column3

Circ=StatsEEC.GenerateCircuit(Mes, Freq, 3)

BI=StatsEEC.BayesianInference(Mes, Freq, Circ)

Best=StatsEEC.EvaluateCircuit(BI)

StatsEEC.PlotEstimatedImpedance(Best, Mes, Freq)


@testset "StatsEEC.jl" begin
    donnee=CSV.read("C:/Users/gab78/Downloads/Data/OER_10min.csv", DataFrame,header=false)
    Mes=donnee.Column1 .+ donnee.Column2 .* im
    Freq=donnee.Column3

    Circ=StatsEEC.GenerateCircuit(Mes, Freq, 3)

    BI=StatsEEC.BayesianInference(Mes, Freq, Circ)

    Best=StatsEEC.EvaluateCircuit(BI)

    StatsEEC.PlotEstimatedImpedance(Best, Mes, Freq)

    StatsEEC.BestCircuit("C:/Users/gab78/Downloads/Data/OER_10min.csv", 5)
end
