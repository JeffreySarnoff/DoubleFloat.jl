import Base: -, signbit, sign, abs, copysign, flipsign, frexp, ldexp,
             exponent, significand, eps, 
             typemax, typemin, floatmax, floatmin, 
             nextfloat, prevfloat

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

for (T,F) in DoubleFloats
  @eval begin
    nan(::Type{$F}) = $F(NaN)
    inf(::Type{$F}) = $F(Inf)
    posinf(::Type{$F}) = $F(Inf)
    neginf(::Type{$F}) = $F(-Inf)

    nan(::Type{$T}) = $T(($F(NaN), $F(NaN)))
    inf(::Type{$T}) = $T(($F(Inf), $F(NaN)))
    posinf(::Type{$T}) = $T(($F(Inf), $F(NaN)))
    neginf(::Type{$T}) = $T(($F(-Inf), $F(NaN)))
    
    ulp(x::$F) = significand(x) !== -one($F) ? eps(x) : eps(x)/2
    posulp(x::$F) = significand(x) !== -one($F) ? eps(x) : eps(x)/2
    negulp(x::$F) = significand(x) !== one($F) ? -eps(x) : -eps(x)/2
    
    ulp(::Type{$F}) = eps(one($F))
    posulp(::Type{$F}) = eps(one($F))
    negulp(::Type{$F}) = -eps(one($F))
    
    function Base.Math.eps(x::$T)
        return !iszero(lo(x)) ? eps(lo(x)) : eps(posulp(hi(x)))
    end
    
    function ulp(x::$T)
        return !iszero(lo(x)) ? posulp(lo(x)) : posulp(posulp(hi(x)))
    end
    
    Base.Math.eps(::Type{$T}) = $T((eps(posulp(one($F))), zero($F)))
    ulp(::Type{$T}) = $T((posulp(poslulp(one($F)))), zero($F))
    
    Base.floatmax(::Type{$T}) = $T((floatmax($F), eps(floatmax($F))/(2+1/$F(2)^(precision($F)-2))))
    Base.floatmin(::Type{$T}) = $T((1/floatmax($F), zero($F)))
    Base.typemax(::Type{$T}) = $T(($F(Inf), $F(NaN)))
    Base.typemin(::Type{$T}) = $T(($F(-Inf), $F(NaN)))

    function Base.nextfloat(x::$T)
        (isnan(x) || isposinf(x)) && return x
        x === floatmax($T) && return posinf($T)
        xhi, xlo = hilo(x)
        if iszero(xlo)
          $T(xhi, ulp(ulp(xhi)))
        else
          $T(xhi, nextfloat(xlo))
        end
    end
  
    function Base.nextfloat(x::$T, n::Integer)
        (isnan(x) || isposinf(x)) && return x
        x === floatmax($T) && return posinf($T)
        xhi, xlo = hilo(x)
        if !iszero(xlo)
            $T(xhi, n*ulp(xlo))
        else
            $T(xhi, n*upl(ulp(xhi)))
        end
    end
  
    function Base.prevfloat(x::$T)
        (isnan(x) || isneginf(x)) && return x
        x === floatmin($T) && return zero($T)
        x === -floatmax($T) && return neginf($%)
        xhi, xlo = hilo(x)
        if iszero(xlo)
            $T(xhi, -ulp(ulp(xhi)))
        else
            $T(xhi, prevfloat(xlo))
        end
    end
  
    function Base.prevfloat(x::$T, n::Integer)
      (isnan(x) || isneginf(x)) && return x
      x === -floatmax($T) && return neginf($%)
      xhi, xlo = hilo(x)
      if !iszero(xlo)
          $T(xhi, -n * ulp(xlo))
      else
          $T(xhi, -n * ulp(ulp(xhi)))
      end
    end

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

for (T,F) in DoubleFloats
  @eval begin

    function ipart(x::$T)
       mfhi, mflo = map(modf, hilo(x))
       $T(two_hilo_sum(mfhi[2], mflo[2]))
    end
        
    function fpart(x::$T)
      mfhi, mflo = map(modf, hilo(x))
      $T(two_hilo_sum(mfhi[1], mflo[1]))
   end

   function Base.Math.modf(x::$T)
      (fpart(x), ipart(x))
   end

   function fmod(fpartipart::Tuple{$T, $T})
      $T(two_hilo_sum(fpartipart[2]..., fpartipart[1]...))
   end
  end
end

Base.Math.eps(::Type{AbstractFloat}) = eps(Float64) # svd seems to need this

function mul_by_two(x::T) where {T<:Doubles}
    T(2 .* hilo(x))
end

function mul_by_half(x::T) where {T<:Doubles}
    T(eltype(T)(0.5) .* hilo(x))
end