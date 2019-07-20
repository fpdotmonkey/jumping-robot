function [nonlinearInequalities, nonlinearEqualities] ...
        = constraintFun(deflection, dLength, totalLength)
    
    posX = sum(dLength * cos(cumsum(deflection)));
    posY = sum(dLength * sin(cumsum(deflection)));
    
    cX = posX;
    cY = posY - totalLength;
    nonlinearInequalities = [];
    nonlinearEqualities = [ cX; cY ];
end
