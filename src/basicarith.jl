import Base: +, -, *, /, inv, sqrt

for (T,F) in DoubleFloats
  @eval begin
  
    function maxmag(xy::$T, z::$F)
      x, z = two_maxmag(hi(xy), z)
      # x, y = two_maxmag(x, y)
      y, z = two_maxmag(lo(xy), z)
      (x, y, z)
    end

    function maxmag(z::$F, xy::$T)
      x, z = two_maxmag(hi(xy), z)
      # x, y = two_maxmag(x, y)
      y, z = two_maxmag(lo(xy), z)
      (x, y, z)
    end

    @inline function Base.:(+)(x::$T, y::$F)
        $T(two_hilo_sum(maxmag(x, y)))
    end  

    @inline function Base.:(+)(y::$F, x::$T)
        $T(two_hilo_sum(maxmag(x, y)))
    end  

    function Base.:(+)(x::$T, y::A) where {A<:IntsFloats}
        (+)(x, convert($F, y))
    end
  
    function Base.:(+)(y::A, x::$T) where {A<:IntsFloats}
      (+)(x, convert($F, y))
    end
  
    @inline function Base.:(-)(x::$T, y::$F)
      $T(two_hilo_sum(maxmag(x, -y)))
    end  

    @inline function Base.:(-)(y::$F, x::$T)
        $T(two_hilo_sum(maxmag(-x, y)))
    end  

    function Base.:(-)(x::$T, y::A) where {A<:IntsFloats}
        (-)(x, convert($F, y))
    end

    function Base.:(-)(y::A, x::$T) where {A<:IntsFloats}
        (+)(-x, convert($F, y))
    end

    @inline function Base.:(*)(x::$T, y::$F)
        $T((hi(x) * y, lo(x) * y))
    end  

    @inline function Base.:(*)(y::$F, x::$T)
        $T((hi(x) * y, lo(x) * y))
    end  

    @inline function Base.:(*)(x::$T, y::A) where {A<:IntsFloats}
        (*)(x, convert($F, y))
    end

    @inline function Base.:(*)(y::A, x::$T) where {A<:IntsFloats}
        (*)(x, convert($F, y))
    end

    # Algorithm 6 from Tight and rigourous error bounds. relative error < 3u²
    function Base.:(+)(x::$T, y::$T)
        (isinf(hi(x)) || isinf(hi(y))) && return $T((hi(x) + hi(y), nan($F)))
        high, low = two_sum(hi(x), hi(y))
        thi, tlo = two_sum(lo(x), lo(y))
        c = low + thi
        high, low = two_hilo_sum(high, c)
        c = tlo + low
        high, low = two_hilo_sum(high, c)
        $T((high, low))
    end
    
    # Algorithm 6 from Tight and rigourous error bounds. relative error < 3u²
    # reworked for subtraction
    function Base.:(-)(x::$T, y::$T)
      (isinf(hi(x)) || isinf(hi(y))) && return $T((hi(x) + hi(y), nan($F)))
      high, low = two_diff(hi(x), hi(y))
      thi, tlo = two_diff(lo(x), lo(y))
      c = low + thi
      high, low = two_hilo_sum(high, c)
      c = tlo + low
      high, low = two_hilo_sum(high, c)
      $T((high, low))
    end
  
    # Algorithm 12 from Tight and rigourous error bounds.  relative error <= 5u²
    function Base.:(*)(x::$T, y::$T)
      (isinf(hi(x)) || isinf(hi(y))) && return $T((hi(x) * hi(y), nan($F)))
      high, low = two_prod(hi(x), hi(y))
      t = lo(x) * lo(y)
      t = fma(hi(x), lo(y), t)
      t = fma(lo(x), hi(y), t)
      t = low + t
      high, low = two_hilo_sum(high, t)
      return $T((high, low))
    end

    function Base.:(/)(x::$T, y::$T)
      isinf(hi(x)) && return $T((hi(x) / hi(y), nan($F)))
      high = hi(x) / hi(y)
      uhigh, ulow = two_prod(high, hi(y))
      low = ((((hi(x) - uhigh) - ulow) + lo(x)) - high*lo(y)) / hi(y)
      high, low = two_hilo_sum(high, low)
      return $T((high, low))
    end

    function recip(y::$T)
      high = 1 / hi(y)
      uhigh, ulow = two_prod(high, hi(y))
      low = ((((1 - uhigh) - ulow)) - high*lo(y)) / hi(y)
      high, low = two_hilo_sum(high, low)
      return $T((high, low))
    end

    function Base.sqrt(x::$T)
        high = hi(x)
        (!isfinite(high) || iszero(high)) && return x
        signbit(high) && Base.Math.throw_complex_domainerror(:sqrt, high)
        
        s = sqrt(high)
        d = fma(-s, s, high) # high=s*s+d,  same order of magnitude as lo(x), so we can add alo safely below:
        d += lo(x)           #  ahi+alo = s*s+d = s*s*(1+d/(s*s))   ==> sqrt(ahi+alo) = s*sqrt(1+d/s2) approx= s*(1+d/(2s2)) = s + d/(2*s) 
        d = d / (2s)
        $T(s, d)
    end
  
  end
end
