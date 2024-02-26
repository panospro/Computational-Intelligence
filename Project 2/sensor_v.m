function dv = sensor_v( pos )
    % maybe refactor that to 1-pos(2) or something like that
    if pos( 1 ) <= 5
        
        dv = pos( 2 );
        
    elseif pos( 1 ) <= 6
        
        dv = pos( 2 ) - 1;
        
    elseif pos( 1 ) <= 7
        
        dv = pos( 2 ) - 2;
        
    else
        
        dv = pos( 2 ) - 3;
        
    end
    
    % Saturate output
    if ( dv > 1 ) 
        
        dv = 1;
        
    end
       
end