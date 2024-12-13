module StatsEEC

export GenerateCircuit, BayesianInference, EvaluateCircuit, PlotEstimatedImpedance, BestCircuit
using Plots
using StatsPlots
using Distributions
using EquivalentCircuits
using Turing
using CSV
using DataFrames
using MCMCChains
using StatsBase
using ArviZ
using HypothesisTests

include("GenerateCircuit.jl")
include("BayesianInference.jl")
include("EvaluateCircuit.jl")
include("PlotResults.jl")
include("BestCircuit.jl")


end
