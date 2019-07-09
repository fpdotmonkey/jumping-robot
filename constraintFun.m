function [c, ceq] = constraintFun(q, dL, Lcomp)
    posX = sum(dL*cos(cumsum(q)));
    posY = sum(dL*sin(cumsum(q)));
    cX = posX;
    cY = posY - Lcomp;
    c = [];
    ceq = [cX; cY];
end