function f = energyFun(q, k)
    f = 0;
    for i = 2:length(q)
        f = f + 0.5*k(i)*q(i)^2;
    end
end