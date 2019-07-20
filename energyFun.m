function energy = energyFun(deflection, stiffness)
    energy = 0;
    for i = 2:length(deflection)
        energy = energy + 0.5*stiffness * deflection(i)^2;
    end
end
