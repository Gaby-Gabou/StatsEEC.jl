using StatsEEC
using Test
using CSV, DataFrames

@testset "StatsEEC.jl" begin
    #test each function 
    donnee=CSV.read("example_measurements.csv", DataFrame,header=false)
    Mes=donnee.Column1 .+ donnee.Column2 .* im
    Freq=donnee.Column3
    @test length(Mes)==length(Freq)

    Circ=StatsEEC.GenerateCircuit(Mes, Freq, 3)
    @test length(Circ)<=3

    BI=StatsEEC.BayesianInference(Mes, Freq, Circ)
    @test length(BI)==length(Circ)
    for i in 1:length(BI)
        @test length(BI[i])==8
    end

    Best=StatsEEC.EvaluateCircuit(BI)
    @test length(Best)==8

    StatsEEC.PlotEstimatedImpedance(Best, Mes, Freq)

    #test the function BestCircuit who is a combination of the previous functions
    StatsEEC.BestCircuit("example_measurements.csv", 5)
end
