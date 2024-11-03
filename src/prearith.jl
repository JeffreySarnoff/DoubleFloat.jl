import Base: -, signbit, sign, abs, copysign, flipsign, frexp, ldexp,
             exponent, significand

for T in DoubleSyms
  @eval begin

    @inline Base.signbit(x::$T) = signbit(hi(x))

    @inline Base.sign(x::$T) = sign(hi(x))

    """
        negate(x)
    
    negate the value of x
    """
    @inline negate(x::$T) = $T((-hi(x), -lo(x)))

    @inline (-)(x::$T) = $T((-hi(x), -lo(x)))

    @inline function Base.abs(x::$T)
        (!signbit(x) && return x) || $T(map(-, hilo(x)))
    end

    """
        negabs(x)
    
    negate the absolute value of x
    """
    @inline function negabs(x::$T)
        (signbit(x) && return x) || $T(map(-, hilo(x)))
    end

    @inline Base.exponent(x::$T) = (exponent(hi(x)), exponent(lo(x)))

    @inline Base.significand(x::$T) = (significand(hi(x)), significand(lo(x)))

    @inline signs(x::$T) = (sign(hi(x)), sign(lo(x)))
  end
end

@inline Base.frexp(x::F) where {F<:AbstractDoubleFloat} = (Base.frexp(x.hi), Base.frexp(x.lo))

@inline Base.ldexp(hilo::Tuple{Tuple{F, Int}, Tuple{F, Int}}) where {F<:AbstractFloat} = Double(ldexp(hilo[1][1], hilo[1][2]), ldexp(hilo[2][1], hilo[2][2]))

@inline function Base.copysign(x::F, y::T) where {F<:AbstractDoubleFloat, T<:AbstractDoubleFloat}
    signbit(x) === signbit(y) ? x : negate(x)
end
@inline function Base.copysign(x::F, y::T) where {F<:AbstractDoubleFloat, T<:Union{AbstractFloat, Signed}}
    signbit(x) === signbit(y) ? x : negate(x)
end
@inline function Base.copysign(x::F, y::T) where {F<:Union{AbstractFloat, Signed}, T<:AbstractDoubleFloat}
    signbit(x) === signbit(y) ? x : negate(x)
end

@inline function Base.flipsign(x::F, y::T) where {F<:AbstractDoubleFloat, T<:AbstractDoubleFloat}
    signbit(y) ? negate(x) : x
end
@inline function Base.flipsign(x::F, y::T) where {F<:AbstractDoubleFloat, T<:Union{AbstractFloat, Signed}}
    signbit(y) ? negate(x) : x
end
@inline function Base.flipsign(x::F, y::T) where {F<:Union{AbstractFloat, Signed}, T<:AbstractDoubleFloat}
    signbit(y) ? negate(x) : x
end
