function D = vpi(rangeMin, rangeMax)
    if rangeMax < rangeMin
        sampleFun = @() replab.domain.inexistent('Cannot sample from empty range');
    elseif rangeMin == rangeMax
        sampleFun = @() rangeMin;
    else
        rangeMin = vpi(rangeMin);
        rangeMax = vpi(rangeMax);
        sampleFun = @() rangeMin + randint(rangeMax - rangeMin);
    end
    desc = sprintf('Integers (vpi) between %s and %s', strtrim(num2str(rangeMin)), strtrim(num2str(rangeMax)));
    D = replab.DomainFun(desc, @isequal, sampleFun);
end
