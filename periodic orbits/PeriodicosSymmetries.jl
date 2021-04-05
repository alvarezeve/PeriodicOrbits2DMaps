module PeriodicosSymmetries

using PyCall
using LaTeXStrings
using Roots
using Plots

export PeriodicosS
export periodicoSimX
export periodicoSimY
export substitutionMap
export composition

include("period_sim.jl")

end
