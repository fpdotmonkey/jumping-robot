

gravity = 9.81;
airDensity = 1.225;

numberOfElements = 50;

youngsModulus = 131e9;
springDensity = 1500;

hingeMass = .020;

numberOfSprings = 4;
springWidth = .0047752;
springThickness = .0004826;

dragCoefficient = 1.4;
dragMassPerArea = .0103;  % CF reinforced epoxy, .77mm thick

numberOfRobots = 5;
specificDrags = logspace(-2, 2, numberOfRobots)';
uncompressedLength = 0.25;
compressedLength = .23 * uncompressedLength;
payloadMass = 0.000;

jumpPerformances = zeros(length(specificDrags), 1);
dragAreas = zeros(length(specificDrags), 1);

[ ~, energyOneSpring ] = jumperDeflection(numberOfElements, youngsModulus, ...
                                          springWidth, springThickness, ...
                                          uncompressedLength, ...
                                          compressedLength, ...
                                          numberOfSprings);

totalEnergy = numberOfSprings * energyOneSpring;

springMass = numberOfSprings * uncompressedLength * springWidth * ...
    springThickness * springDensity;

totalMass = payloadMass + hingeMass + springMass;

syms DRAG_AREA

%fprintf(['Specific Drag\tJP\tRadius\tSpringLength, m\tPayload Mass\n']);
for i = 1:length(specificDrags)
    
    
    potentialSolution = ...
        solve([specificDrags(i) == ...
               2 * (dragCoefficient * airDensity * DRAG_AREA * ...
                    (payloadMass + DRAG_AREA * dragMassPerArea + ...
                     .5*(springMass + hingeMass)) * totalEnergy) / ...
               ((payloadMass + DRAG_AREA * dragMassPerArea + ...
                 springMass + hingeMass)^3 * gravity), ...
               DRAG_AREA > 0], ...
              DRAG_AREA);
    
    if (length(potentialSolution) > 0)
        dragAreas(i) = real(double(potentialSolution));
        jumpPerformances(i) = 2 / specificDrags(i) * log(1 + .5* ...
                                                     specificDrags(i));
        
        %        fprintf('%6.3f\t%1.3f\t%2.2f\t%1.3f\t\t%1.3f\n', ... 
        %        specificDrags(i), jumpPerformances(i), ...
        %        100 * sqrt(dragAreas(i) / pi), ...
        %        uncompressedLength, ...
        %        payloadMass);
    end
    

    % dragAreas(i) = specificDrags(i) * gravity * totalMass^5 / ...
    %    (2 * totalEnergy^2 * (payloadMass + .5 * (springMass + hingeMass))^2 ...
    %     * airDensity);
    

end
dragRadii = 100 * sqrt(dragAreas / pi);

designTable = table(specificDrags, jumpPerformances, dragAreas, dragRadii, ...
                    'VariableNames', {'SpecificDrag', 'JumpPerformance', ...
                                      'DragArea', 'DragRadius'});

designTable.Properties.Description = ...
    sprintf( ...
        'Design table for %.1f x %.1f x %.1f mm spring and payload mass of %.3f', ...
        1000*uncompressedLength, 1000*springWidth, 1000*springThickness, ...
        payloadMass);

designTable.Properties.VariableUnits = {'', '', 'm^2', 'cm'};

display(designTable);
