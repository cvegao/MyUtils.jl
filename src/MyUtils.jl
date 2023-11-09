module MyUtils

using Distributions, StaticArrays

export rand!, parseSMatrix, findall2

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
function findall2(f, a::Union{AbstractVector, Array{T, N}, SArray}) where {T, N}
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
end