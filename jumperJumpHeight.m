function [ initialVelocity, noDragHeight, dragHeight ] = ...
    jumperJumpHeight(gravity, densityAir, dragCoefficient, ...
                     dragArea, efficiency, ...
                     totalEnergy, totalMass)

initialVelocity = sqrt(2*efficiency * totalEnergy / totalMass);  % m/s
noDragHeight = 0.5*initialVelocity^2 / gravity;
dragHeight = totalMass / (dragCoefficient * dragArea * densityAir) .* ...
    log(1 + dragCoefficient * dragArea * densityAir .* ...
        initialVelocity.^2 / (2*totalMass * gravity));

end
