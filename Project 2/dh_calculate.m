function dh = dh_calculate( pos )
    if pos(2) <= 1
        dh = 5 - pos(1);
    elseif pos(2) <= 2
        dh = 6 - pos(1);
    elseif pos(2) <= 3
        dh = 7 - pos(1);
    else
        dh = 1;
    end

    dh = max(0, min(dh, 1));
end
