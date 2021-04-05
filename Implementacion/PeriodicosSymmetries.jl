module PeriodicosSymmetries
using SymPy
using PyCall
using LaTeXStrings
using Roots
using LinearAlgebra
#using Plots
#=
using ForwardDiff
using SymPy
using PyCall
using PyPlot
using SymPy
=#
# export PeriodicosS
# export periodicoSimX
# export periodicoSimY
# export substitutionMap
# export composition
# export PeriodicosSNewton
#=
export composition
export puntoperiodicoY
export puntoperiodicoX
export puntoperiodicoS
=#
export composition
export pruebaperiodicos
export periodicosN
export Buscaperiodo
export iterar


#include("period_sim1.jl")
include("ppsimetrias.jl")

end
