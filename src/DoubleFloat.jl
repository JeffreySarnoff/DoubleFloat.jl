module DoubleFloat

export Double128, Double64, Double32, Double16

using Quadmath, ErrorfreeArithmetic

include("types.jl")
include("prearith.jl")

end  # DoubleFloat

