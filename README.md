# StatsEEC.jl

<!--[![Build Status](https://github.com/Gaby_Gabou/StatsEEC.jl/actions/workflows/CI.yml/badge.svg?branch=master)](https://github.com/Gaby_Gabou/StatsEEC.jl/actions/workflows/CI.yml?query=branch%3Amaster)
[![Build Status](https://app.travis-ci.com/Gaby_Gabou/StatsEEC.jl.svg?branch=master)](https://app.travis-ci.com/Gaby_Gabou/StatsEEC.jl)
[![Build Status](https://ci.appveyor.com/api/projects/status/github/Gaby_Gabou/StatsEEC.jl?svg=true)](https://ci.appveyor.com/project/Gaby_Gabou/StatsEEC-jl)
[![Coverage](https://coveralls.io/repos/github/Gaby_Gabou/StatsEEC.jl/badge.svg?branch=master)](https://coveralls.io/github/Gaby_Gabou/StatsEEC.jl?branch=master)-->

This package is usefull to get the best equivalent electrical circuit based on measurements. The idea is to generate a bunch of circuit with the [EquivalentCircuit.jl](https://github.com/MaximeVH/EquivalentCircuits.jl) package. Once the circuits generated, we use the [Turing.jl](https://github.com/TuringLang/Turing.jl) package to applied bayesian inference on the paramters of the circuits and we also calculate different informations. After getting all of the informations, we check them and inflict penalities to those which don't respect some criteria. The best circuit is then returned. Then we can choose to plot the simulated impedance based on the best circuit.

## Installation

For now, the only way to install it is directly via the github link.
```julia
    using Pkg
     Pkg.add(url="https://github.com/Gaby-Gabou/StatsEEC.jl")
```

## How to use it
### With one function

You can use a function that, giving path of the CSV file and eventually the number of circuits generated, return the Best one.
The data in the CSV file have to be in a particular order, starting with the real part, then the imaginary part and finally the frequencies. You can see the structure needed in the example_measurements.csv file.

`BestCircuit(path, nb)`
- `path` : the path of the CSV file
- `nb` : the number of circuits generated

```julia
    using StatsEEC

    BestCircuit("example_measurements.csv",20)
```
### Step by Step

If you prefer, you can use all the function present in the BestCircuit function.

`GeneratCircuit(Mes, Freq, NBCirc)`
- `Mes` : the measurements of the impedance
- `Freq` : the frenquecies
- `NBCirc` : the number of circuits wanted

`BayesianInferance(Mes, Freq, Circuits)`
- `Mes` : the measurements of the impedance
- `Freq` : the frenquecies
- `Circuits` : a vector of circuits of EquivalentCircuit type

`EvaluateCircuit(Finalres)`
- `Finalres` : a vector of arrays. Each array contain different informations about a circuit

`PlotEstimatedImpedance(Circ, Mes, Freq)`
- `Circ` : An array conatining different infromations about a circuit
- `Mes` : the measurements of the impedance
- `Freq` : the frenquecies

```julia
    using StatsEEC, CSV, DataFrames

    donnee=CSV.read(path, DataFrame,header=false)
    Mes=donnee.Column1 .+ donnee.Column2 .* im
    Freq=donnee.Column3

    Circuits=GenerateCircuit(Mes, Freq, nb)

    BI=BayesianInference(Mes, Freq, Circuits)

    Best=EvaluateCircuit(BI)

    @info "Best Circuit : $Best"
    
    PlotEstimatedImpedance(Best, Mes, Freq)
```