import Base: +, -, *, /

for Struct in (:Double128, :Double64, :Double32, :Double16) 

 @eval begin

    function Base.:(+)(x::$Struct, y::$Struct)
        $Struct(two_sum(x, y))
    end

    function Base.:(-)(x::$Struct, y::$Struct)
        $Struct(two_diff(x, y))
    end

    function Base.:(*)(x::$Struct, y::$Struct)
        $Struct(two_prod(x, y))
    end

    function Base.:(/)(x::$Struct, y::$Struct)
      $Struct(two_divide(x, y))
    end

    function two_sum(x::$Struct, y::$Struct)    
        xhi, xlo = hilo(x)
        yhi, ylo = hilo(y)
        two_hilo_sum(max2min_abs(xhi, xlo, yhi, ylo)...)
    end
    
    function two_diff(x::$Struct, y::$Struct)    
      xhi, xlo = hilo(x)
      yhi, ylo = hilo(y)
      two_hilo_diff(max2min_abs(xhi, xlo, yhi, ylo)...)
    end

    function two_prod(x::$Struct, y::$Struct)    
      xhi, xlo = hilo(x)
      yhi, ylo = hilo(y)
      hihi, hilo = two_prod(xhi, yhi)
      lo = (xhi * ylo + xlo* yhi) + hilo
      $Struct((hihi, lo))
    end

    function two_divide(x::$Struct, y::$Struct)    
      xhi, xlo = hilo(x)
      yhi, ylo = hilo(y)
      hihi, hilo = two_div(xhi, yhi)
      lo = ((((xhi - hihi) - hilo) + xlo) - hihi*ylo) / yhi
      $Struct(hihi, lo)
    end

  end
end

