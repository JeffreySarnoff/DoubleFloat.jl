import Base: iszero, isone, isinteger, iseven, isodd, isnan, isinf

for (T,F) in DoubleFloats
  @eval begin
    Base.iszero(x::$T) = iszero(hi(x)) && iszero(lo(x))
    Base.isone(x::$T) = isone(hi(x)) && iszero(lo(x))
    istwo(x::$T) = (hi(x) === F(2.0)) && iszero(lo(x))
    isnegone(x::$T) = (hi(x) === F(-1.0)) && iszero(lo(x))
    isnegtwo(x::$T) = (hi(x) === F(-2.0)) && iszero(lo(x))
    Base.isnan(x::$T) = isnan(hi(x))
    Base.isinf(x::$T) = isinf(hi(x))
    isposinf(x::$T) = isinf(hi(x)) && hi(x) > 0
    isneginf(x::$T) = isinf(hi(x)) && hi(x) < 0
    Base.isinteger(x::$T) = isinteger(hi(x)) && isinteger(lo(x))
    Base.iseven(x::$T) = iseven(hi(x)) && iseven(lo(x))
    Base.isodd(x::$T) = (isodd(hi(x)) && iszero(lo(x))) || (isodd(lo(x)))
  end
end

    