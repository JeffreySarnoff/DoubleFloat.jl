import Base: signbit, abs, copysign, flipsign, frexp, ldexp

for (Struct, Fn, T) in ((:DF128, :Double128, :Float128), 
                        (:DF64,  :Double64, :Float64), 
                        (:DF32,  :Double32, :Float32), 
                        (:DF16,  :Double16, :Float16))
  @eval begin
    negabs(x::$T) = -abs(x)
    
    Base.signbit(x::$Struct) = signbit(hi(x))
    Base.abs(x::$Struct) = !signbit(hi(x)) ? x : $Struct(-hi(x), -lo(x))
    negabs(x::$Struct) = signbit(hi(x)) ? x : $Struct(-hi(x), -lo(x))
    
    Base.copysign(x::$Struct, y::$T) = signbit(hi(x)) === signbit(y) ? x : $Struct(-hi(x), -lo(x))
    Base.copysign(x::$Struct, y::$Struct) = signbit(hi(x)) === signbit(hi(y)) ? x : $Struct(-hi(x), -lo(x))
    
    Base.flipsign(x::$Struct, y::$T) = signbit(y) ? $Struct(-hi(x), -lo(x)) : x
    Base.flipsign(x::$Struct, y::$Struct) = signbit(hi(y)) ? $Struct(-hi(x), -lo(x)) : x
  end

  @eval begin
    Base.frexp(x::$Struct) = (frexp(hi(x)), frexp(lo(x)))
    Base.ldexp(x::NTuple{2,$T}, y::NTuple{2,$T}) = (ldexp(x...), ldexp(y...))
    Base.ldexp(x::NTuple{2, NTuple{2,$T}}) = (ldexp(x[1]...), ldexp(x[2]...))
  end

end

