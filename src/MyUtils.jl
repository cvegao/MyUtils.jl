module MyUtils

using Distributions, StaticArrays

export ste, rand!, parseSMatrix, findall2, getShannon

function rand!(A::Array, distribution::Distribution)
    for i in eachindex(A)
        @inbounds A[i] = rand(distribution);
    end
    nothing
end

function rand!(A::Array, distribution::Array{T} where {T<:Distribution})
    for i in eachindex(A)
        @inbounds A[i] = rand(distribution[i]);
    end
    nothing
end

function parseSMatrix(A::Array)::SMatrix
    return SMatrix{size(A)..., eltype(A)}(A)
end

"""
Written by @jbrea [https://discourse.julialang.org/t/findall-slow/30247/5]
"""
function findall2(f, a::Union{AbstractVector, Array{T, N}}) where {T, N}
    j = 1;
    b = Vector{Int}(undef, length(a));
    @inbounds for i in eachindex(a)
        @inbounds if f(a[i])
            b[j] = i;
            j += 1;
        end
    end
    resize!(b, j-1);
    sizehint!(b, length(b));
    return b
end

# Standard error
function ste(x)
    if mean(x) > 0.0
        return std(x) / sqrt(mean(x)) 
    else
        return 0.0
    end
end

# Shannon index
function getShannon(B)
    N = sum(B)
    p = B[B.>1e-12] ./ N
    return -sum(p .* log.(p))
end
end