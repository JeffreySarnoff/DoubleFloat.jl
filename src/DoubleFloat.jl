module DoubleFloat

export AbstractDoubleFloat, Double,
       Double128, Double64, Double32, Double16,
       hilo, hi, lo,
       Float128,
       negate, negabs, 
       exponent, significand, signs

using Quadmath, ErrorfreeArithmetic
using ErrorfreeArithmetic: maxmin_abs, max2min_abs

abstract type AbstractDoubleFloat <: AbstractFloat end

const DoubleSyms   = (:Double128, :Double64, :Double32, :Double16)
const FloatSyms    = (:Float128, :Float64, :Float32, :Float16)
const DoubleFloats = ((:Double128, :Float128), (:Double64, :Float64),
                      (:Double32, :Float32), (:Double16, :Float16))

include("types.jl")
include("prearith.jl")
include("basicarith.jl")

end  # DoubleFloat

