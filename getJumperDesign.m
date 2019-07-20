

gravity = 9.81;
airDensity = 1.225;

numberOfElements = 50;

youngsModulus = 131e9;

hingeMass = .020;

numberOfSprings = 4;
springWidth = .0056;
springThickness = .0023;

dragCoefficient = 1.5;

numberOfRobots = 10;
specificDrags = logspace(-1, 3, numberOfRobots);
springLength = .1;
payloadMass = .255;

[ ~, energyOneSpring ] = jumperDeflection(numberOfElements, youngsModulus, ...
                                          springWidth, springThickness, ...
                                          uncompressedLength, ...
                                          compressedLength, ...
                                          numberOfSprings);

totalEnergy = numberOfSprings * energyOneSpring;

springMass = numberOfSprings * springLength * springWidth * springThickness;

totalMass = payloadMass + hingeMass + springMass;

fprintf('Specific Drag\tJumpPerformance\tDrag Area\tSpring Length\tPayload Mass\n');
for i = 1:length(specificDrags)
    jumpPerformances(i) = 2 / specificDrags(i) * log(1 + .5*specificDrags(i));

    dragAreas(i) = specificDrags(i) * gravity * totalMass^5 / ...
        (2 * totalEnergy^2 * (payloadMass + .5 * (springMass + hingeMass))^2 ...
         * airDensity);
    
    fprintf('%6.6f\t%1.3f\t\t%2.5f\t\t%1.3f\t\t%1.3f\n', specificDrags(i), jumpPerformances(i), ...
            dragAreas(i), springLength, payloadMass);
end


