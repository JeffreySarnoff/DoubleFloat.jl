module DoubleFloat

export AbstractDoubleFloat, Double,
       Double128, Double64, Double32, Double16,
       hilo, hi, lo,
       Float128,
       negate, negabs, 
       exponent, significand, signs,
       iszero, isone, istwo, isnegone, isnegtwo, isnan, isinf, isposinf, isneginf,
       nan, inf, posinf, neginf,
       typemax, typemin, floatmax, floatmin,
       eps, ulp, nextfloat, prevfloat,
       ipart, fpart, modf, fmod,
       recip, sqrt,
       # linear alogebra
       dot, norm, normalize, inv, det

using Quadmath, ErrorfreeArithmetic, LinearAlgebra, GenericLinearAlgebra
using ErrorfreeArithmetic: two_maxmag, three_maxmag, four_maxmag
import ErrorfreeArithmetic: two_sqrt, two_recip, two_sum, two_diff, two_prod, two_div
                            
abstract type AbstractDoubleFloat <: AbstractFloat end

const Floats  = Union{Float128, Float64, Float32, Float16}
const Ints = Union{Int64, Int32, Int16, Int128}
const IntsFloats = Union{Float64, Float32, Float16, Float128, Int64, Int32, Int16, Int128}

include("types.jl")

const DoubleSyms   = (:Double128, :Double64, :Double32, :Double16)
const FloatSyms    = (:Float128, :Float64, :Float32, :Float16)
const IntSyms      = (:Int128, :Int64, :Int32, :Int16)
const DoubleFloats = ((:Double128, :Float128), (:Double64, :Float64),
                      (:Double32, :Float32), (:Double16, :Float16))

const Doubles = Union{Double128, Double64, Double32, Double16}
                      
include("predicates.jl")
include("compare.jl")
include("convert.jl")
include("prearith.jl")
include("rounding.jl")
include("basicarith.jl")
include("logexp.jl")

end  # DoubleFloat

