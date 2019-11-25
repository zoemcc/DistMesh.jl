module DistMesh

using GeometryBasics,
      LinearAlgebra,
      Statistics,
      TetGen

# permutations to decompose tets to edges and tris
const tetpairs = ((1,2),(1,3),(1,4),(2,3),(2,4),(3,4))
const tettriangles = ((1,2,3),(1,2,4),(2,3,4),(1,3,4))

abstract type AbstractDistMeshAlgorithm end

"""
    DistMeshSetup

    iso (default: 0): Value of which to extract the iso surface, inside negative
    deltat (default: 0.1): the fraction of edge displacement to apply each iteration
"""
struct DistMeshSetup{T} <: AbstractDistMeshAlgorithm
    iso::T
    deltat::T
    ttol::T
    ptol::T
    nonlinear::Bool
    distribution::Symbol # intial point distribution
end

function DistMeshSetup(;iso=0,
                        ptol=.001,
                        deltat=0.05,
                        ttol=0.02,
                        nonlinear=false,
                        distribution=:regular)
    T = promote_type(typeof(iso),typeof(ptol),typeof(deltat), typeof(ttol))
    DistMeshSetup{T}(iso,
                     deltat,
                     ttol,
                     ptol,
                     nonlinear,
                     distribution)
end

"""
    DistMeshQuality

    iso (default: 0): Value of which to extract the iso surface, inside negative
    deltat (default: 0.1): the fraction of edge displacement to apply each iteration
"""
struct DistMeshQuality{T} <: AbstractDistMeshAlgorithm
    iso::T
    deltat::T
    minimum::T
    distribution::Symbol # intial point distribution
end

function DistMeshQuality(;iso=0,
                        ptol=.001,
                        deltat=0.05,
                        ttol=0.02,
                        distribution=:regular)
    T = promote_type(typeof(iso),typeof(ptol),typeof(deltat), typeof(ttol))
    DistMeshQuality{T}(iso,
                     deltat,
                     ttol,
                     ptol,
                     distribution)
end

"""
    DistMeshStatistics

        Statistics about the convergence between iterations
"""
struct DistMeshStatistics{T}
    maxmove::Vector{T} # max point move in an iteration
    maxdp::Vector{T} # max displacmeent induced by an edge
    average_qual::Vector{T}
    median_qual::Vector{T}
    minimum_qual::Vector{T}
    maximum_qual::Vector{T}
    retriangulations::Vector{Int} # Iteration num where retriangulation occured
end

DistMeshStatistics() = DistMeshStatistics{Float64}([],[],[],[],[],[],[])

"""
Uniform edge length function.
"""
struct HUniform end

include("diff.jl")
include("pointdistribution.jl")
include("distmeshnd.jl")
include("tetgen.jl")
include("quality.jl")
include("decompositions.jl")

#export distmeshsurface
export distmesh, DistMeshSetup, DistMeshStatistics, HUniform

end # module
