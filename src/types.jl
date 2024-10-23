for (Struct, Fn, T) in ((:DF128, :Double128, :Float128), 
                        (:DF64,  :Double64, :Float64), 
                        (:DF32,  :Double32, :Float32), 
                        (:DF16,  :Double16, :Float16))
  @eval begin

    struct $Struct <: AbstractFloat
      hilo::NTuple{2,$T}
    end
    
    hi(x::$Struct) = x.hilo[1]
    lo(x::$Struct) = x.hilo[2]
    hilo(x::$Struct) = x.hilo

    function $Fn(a::$T, b::$T)
        $Struct(two_sum(a, b))
    end

    function $Fn(ab::NTuple{2, $T})
        $Struct(two_hilo_sum(ab[1], ab[2]))
    end

  end
end
