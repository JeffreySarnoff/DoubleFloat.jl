import Base.Math.round

for (T, F) in DoubleFloats
  @eval begin
    
    function Base.round(x::$T, ::RoundingMode{:ToZero}; digits::Nothing, sigdigits::Nothing, base::Nothing)
       if signbit(x)
           lo(x) <= zero($F) ? $T((hi(x), zero($F))) : $T((nextfloat(hi(x)), zero($F)))
       else
           lo(x) >= zero($F) ? $T((hi(x), zero($F))) : $T((prevfloat(hi(x)), zero($F)))
       end      
    end

    function Base.round(x::$T, ::RoundingMode{:FromZero}; digits::Nothing, sigdigits::Nothing, base::Nothing)
        if !signbit(x)
            lo(x) <= zero($F) ? $T((hi(x), zero($F))) : $T((nextfloat(hi(x)), zero($F)))
        else
            lo(x) >= zero($F) ? $T((hi(x), zero($F))) : $T((prevfloat(hi(x)), zero($F)))
        end      
     end
 
    function Base.round(x::$T, ::RoundingMode{:Up}; digits::Nothing, sigdigits::Nothing, base::Nothing)
       lo(x) <= zero($F) && return $T(hi(x), zero($F))
       $T(nextfloat(hi(x)), zero($F))
    end

    function Base.round(x::$T, ::RoundingMode{:Down}; digits::Nothing, sigdigits::Nothing, base::Nothing)
        lo(x) >= zero($F) && return $T(hi(x), zero($F))
        $T(prevfloat(hi(x)), zero($F))
     end
 
     function Base.round(x::$T, ::RoundingMode{:Nearest}; digits::Nothing, sigdigits::Nothing, base::Nothing)
        x      
     end
  end
end

