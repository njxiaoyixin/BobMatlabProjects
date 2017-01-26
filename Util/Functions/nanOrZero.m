function out = nanOrZero(input)
    if isnan(input)
        out = 0;
    else
        out = input;
    end
end