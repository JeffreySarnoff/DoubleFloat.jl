import Base: eltype

for (S,T) in ((:Double128, :Float128), (:Double64, :Float64),
              (:Double32, :Float32), (:Double16, :Float16))
  @eval begin
    struct $S <: AbstractDoubleFloat
        hilo::NTuple{2,$T}
    end

    @inline function $S(a::$T, b::$T)
        $S(two_sum(a, b))
    end

    @inline function Double(a::$T, b::$T)
        $S(two_sum(a, b))
    end

    @inline function $S(a::$T, b::AbstractFloat)
      $S(two_sum(a, $T(b)))
    end

    @inline function $S(a::AbstractFloat, b::$T)
      $S(two_sum($T(a), b))
    end

    @inline hilo(x::$S) = x.hilo
    @inline hi(x::$S) = (x.hilo)[1]
    @inline lo(x::$S) = (x.hilo)[2]

    Base.eltype(::Type{$S}) = $T
    Base.eltype(x::$S) = $T   
  end
end

function Double128(x::F) where {F<:Floats}
    Double128((Float128(x), zero(Float128)))
end

function Double64(x::Float128)
     hi = Float64(x)
     lo = Float64(x-hi)
     Double64((hi, lo))
end

function Double32(x::Float128)
    hi = Float32(x)
    lo = Float32(x-hi)
    Double32((hi, lo))
end

function Double32(x::Float64)
    hi = Float32(x)
    lo = Float32(x-hi)
    Double32((hi, lo))
end

function Double16(x::Float64)
    hi = Float16(x)
    lo = Float16(x-hi)
    Double16((hi, lo))
end

function Double16(x::Float32)
    hi = Float16(x)
    lo = Float16(x-hi)
    Double16((hi, lo))
end
