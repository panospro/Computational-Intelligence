function dv = dv_calculate(pos)
    if pos(1) <= 5
        offset = 0;
    elseif pos(1) <= 6
        offset = 1;
    elseif pos(1) <= 7
        offset = 2;
    else
        offset = 3;
    end
    dv = pos(2) - offset;

    dv = max(0, min(dv, 1));
end
