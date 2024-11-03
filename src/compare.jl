import Base: ==, !=, >=, >, <=, <

for (T,F) in DoubleFloats
  @eval begin

     Base.:(==)(x::$T, y::$F) = hi(x) === y && iszero(lo(x))
     Base.:(!=)(x::$T, y::$F) = hi(x) !== y || !iszero(lo(x))
     Base.:(<)(x::$T, y::$F) = hi(x) < y || (hi(x) === y) && (lo(x) < 0)
     Base.:(>)(x::$T, y::$F) = hi(x) > y || (hi(x) === y) && (lo(x) > 0)
     Base.:(<=)(x::$T, y::$F) = hi(x) < y || (hi(x) === y) && (lo(x) <= 0)
     Base.:(>=)(x::$T, y::$F) = hi(x) > y || (hi(x) === y) && (lo(x) >= 0)
     
     Base.:(==)(y::$F, x::$T) = y === hi(x) && iszero(lo(x))
     Base.:(!=)(y::$F, x::$T) = y !== hi(x) || !iszero(lo(x))
     Base.:(<)(y::$F, x::$T) = hi(x) > y || (hi(x) === y) && (lo(x) > 0)
     Base.:(>)(y::$F, x::$T) = hi(x) < y || (hi(x) === y) && (lo(x) < 0)
     Base.:(<=)(y::$F, x::$T) = hi(x) > y || (hi(x) === y) && (lo(x) >= 0)
     Base.:(>=)(y::$F, x::$T) = hi(x) < y || (hi(x) === y) && (lo(x) <= 0)
     
     Base.:(==)(x::$T, y::$T) = hi(x) === hi(y) && lo(x) === lo(y)
     Base.:(!=)(x::$T, y::$T) = hi(x) !== hi(y) || lo(x) !== lo(y)
     Base.:(<)(x::$T, y::$T) = hi(x) < hi(y) || (hi(x) === hi(y)) && (lo(x) < lo(y))
     Base.:(>)(x::$T, y::$T) = hi(x) > hi(y) || (hi(x) === hi(y)) && (lo(x) > lo(y))
     Base.:(<=)(x::$T, y::$T) = hi(x) < hi(y) || (hi(x) === hi(y)) && (lo(x) <= lo(y))
     Base.:(>=)(x::$T, y::$T) = hi(x) > hi(y) || (hi(x) === hi(y)) && (lo(x) >= lo(y))
  
  end
end
