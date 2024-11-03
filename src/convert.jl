import Base: convert, promote_rule

for T in DoubleSyms
    for F in FloatSyms
        @eval begin

            if sizeof($F) < sizeof(eltype($T))
                Base.convert(::Type{$F}, x::$T) = convert($F, hi(x))
            else
                Base.convert(::Type{$F}, x::$T) = sum(map($F, hilo(x)))
            end

            function Base.convert(::Type{$T}, x::$F)
                hi = convert(eltype($F), x)
                lo = convert(eltype($F), x - hi)
                $T((hi, lo))
            end 
        end
    end
end

Base.convert(::Type{T}, x::T) where {T<:Doubles} = x

function Base.convert(::Type{<:Doubles}, x::T) where {T<:Doubles}
    high = eltype(T)(hi(x))
    low  = eltype(T)(lo(x))
    T(high, low)
end

function Base.convert(::Type{T}, x::Double128) where {T<:Doubles}
    high = convert(eltype(T), hi(x))
    xlow = x - high
    low  = convert(eltype(T), xlow)
    T(high, low)
end

function Base.convert(::Type{T}, x::BigFloat) where {T<:Doubles}
    high = convert(eltype(T), x)
    xlow = x - high
    low  = convert(eltype(T), xlow)
    T(high, low)
end

Base.convert(::Type{T}, x::BigInt) where {T<:Doubles} = convert(T, convert(BigFloat, x))

Base.convert(::Type{BigFloat}, x::T) where {T<:Doubles} = sum(map(BigFloat, hilo(x)))

BigFloat(x::T) where {T<:Doubles} = convert(BigFloat, x)
Float128(x::T) where {T<:Doubles} = convert(Float128, x)
Float64(x::T) where {T<:Doubles} = convert(Float64, x)
Float32(x::T) where {T<:Doubles} = convert(Float32, x)
Float16(x::T) where {T<:Doubles} = convert(Float16, x)

for T in DoubleSyms
    for I in IntSyms
        @eval begin
            function Base.convert(::Type{$I}, x::$T)
                !isinteger(x) && throw(InexactError("cannot convert $x to an integer."))
                high = $I(hi(x)) 
                low = $I(lo(x))
                high + low
            end

            function Base.convert(::Type{$T}, x::$I)
                high = eltype($T)(x)
                low = eltype($T)(x - high)
                $T((high, low))
            end

        end
    end
end

Int128(x::T) where {T<:Doubles} = convert(Int128, x)
Int64(x::T) where {T<:Doubles} = convert(Int64, x)
Int32(x::T) where {T<:Doubles} = convert(Int32, x)
Int16(x::T) where {T<:Doubles} = convert(Int16, x)

Double128(x::I) where {I<:Integer} = convert(Double128, x)
Double64(x::I) where {I<:Integer} = convert(Double64, x)
Double32(x::I) where {I<:Integer} = convert(Double32, x)
Double16(x::I) where {I<:Integer} = convert(Double16, x)

Double128(x::Double128) = x
Double64(x::Double64) = x
Double32(x::Double32) = x
Double16(x::Double16) = x

function Base.convert(::Type{T}, x::Bool) where {T<:Doubles}
    T((eltype(T)(x), zero(eltype(T))))
end

Double128(x::BigFloat) = convert(Double128, x)
Double64(x::BigFloat) = convert(Double64, x)
Double32(x::BigFloat) = convert(Double32, x)
Double16(x::BigFloat) = convert(Double16, x)

function Base.convert(::Type{Bool}, x::T) where {T<:Doubles}
    convert(Bool, hi(x))
end

Base.promote_rule(::Type{Double128}, ::Type{T}) where {T<:Union{Double64, Double32, Double16}} = Double128
Base.promote_rule(::Type{Double64}, ::Type{T}) where {T<:Union{Double32, Double16}} = Double64
Base.promote_rule(::Type{Double32}, ::Type{Double16}) = Double32

Base.promote_rule(::Type{I}, ::Type{T}) where {I<:Integer, T<:Doubles} = T
Base.promote_rule(::Type{F}, ::Type{T}) where {F<:Floats, T<:Doubles} = T


