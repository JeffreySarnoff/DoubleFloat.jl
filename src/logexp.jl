import Base.Math: log, log2, log1p, log10, exp, exp2, expm1, exp10

"""
    expmax(Type{T})

the largest value x where !isinf(exp(x))
"""

expmax(::Type{Float128}) = log(prevfloat(Float128(Inf), 7000))
expmax(::Type{Float64}) = log(prevfloat(Float64(Inf)))
expmax(::Type{Float32}) = log(prevfloat(Float32(Inf)))
expmax(::Type{Float16}) = log(prevfloat(Float16(Inf)))

expmax(::Type{Double128}) = Double128((expmax(Float128), zero(Float128)))
expmax(::Type{Double64}) = Double64((expmax(Float64), zero(Float64)))
expmax(::Type{Double32}) = Double32((expmax(Float32), zero(Float32)))
expmax(::Type{Double16}) = Double16((expmax(Float16), zero(Float16)))

"""
    exp1(Type{T})

the value of exp(one(T))
"""

exp1(::Type{BigFloat}) = exp(one(BigFloat))
exp1(::Type{Float128}) = exp(one(Float128))
exp1(::Type{Float64}) = exp(one(Float64))
exp1(::Type{Float32}) = exp(one(Float32))
exp1(::Type{Float16}) = exp(one(Float16))

exp1(::Type{Double128}) = Double128((exp1(BigFloat)))
exp1(::Type{Double64}) = Double64(exp1(Float128))
exp1(::Type{Double32}) = Double32(exp1(Float64))
exp1(::Type{Double16}) = Double16(exp1(Float64))

for T in DoubleSyms
  @eval begin
    
    Base.Math.exp(x::$T) = $T(exp(hi(x)), exp(lo(x)) )
    # safe_log, complex for -vals, Base.Math.log(x::$T) = $T(log(hi(x), log(lo(x)) ))
    
 
    function Base.Math.log(x::$T)
        (isnan(x) || (isinf(x) && !signbit(x))) && return x
        iszero(x) && return neginf($T)
        y = $T((log(hi(x)), zero(eltype($T))))
        z = exp(y)
        adj = (z - x) / (z + x)
        adj = mul_by_two(adj)
        y - adj
    end


  end
end

