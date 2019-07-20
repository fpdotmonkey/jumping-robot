% Optimization to find the bow curvature and energy. The jumping height is
% calculated from that using a defined payload.
densityAir = 1.225;  % kg/m^3
gravity = 9.81;  % m/s^2

%% To change
% Mechanism values
payloadMass = 0.255; % kg
hingeMass = 0.02;  % kg
dragArea = (2*0.0254)^2 * pi/4;  % m^2
dragCoefficient = 1.5;

% Bow Dimensions
uncompressedLength = 1;  % m
compressedLength = 0.23;  % m
springWidth = 0.220*0.0254;  % m
springThickness = 0.092*0.0254;  % m
numberOfSprings = 4;


%% Other Simulation Values
numberOfElements = 50;
numberOfElements = 2*ceil(numberOfElements/2);
youngsModulus = 131e9;  % Pa
density = 1500;  % kg/m^3
                 %dLength = uncompressedLength / numberOfElements;  % m


massOneSpring = density * springWidth * springThickness * uncompressedLength;
totalMass = payloadMass + hingeMass + numberOfSprings * ...
    massOneSpring;
efficiency = jumperEfficiency(hingeMass, numberOfSprings, ...
                             massOneSpring, payloadMass);


%% Solve for angles
[ deflection, energyOneSpring ] = ...
    jumperDeflection(numberOfElements, youngsModulus, ...
                     springWidth, springThickness, ...
                     uncompressedLength, compressedLength, numberOfSprings);
totalEnergy = numberOfSprings * energyOneSpring;

% Shape
[ xCoordinate, yCoordinate ] = jumperShape(numberOfElements, ...
                                           uncompressedLength, ...
                                           deflection);

%% Stress & Force
stress = jumperStress(numberOfElements, youngsModulus, ...
                      springWidth, springThickness, ...
                      uncompressedLength, deflection);
force = energyOneSpring / (1e-6 + uncompressedLength - compressedLength);


%% Plot of shape
% Deflection
f = figure;
clf;
axis([ -0.6*uncompressedLength, 0.6*uncompressedLength, ...
       -0.1*uncompressedLength, 1.1*uncompressedLength ]);
grid on; hold on;
title(sprintf('Deflection (Total Energy: %.3f J)', energyOneSpring));
plot(xCoordinate, yCoordinate, 'ok');
surface([ xCoordinate, xCoordinate ], ...
        [ yCoordinate, yCoordinate ], ...
        [ stress, stress ], ...
        'facecol', 'no', 'Linewidth', 5, 'edgecol', 'interp');
c = colorbar;
xlabel('x (m)');
ylabel('y (m)');
c.Label.String = 'Stress (Pa)';

%% Jumping Height

[ initialVelocity, noDragHeight, dragHeight ] = ...
    jumperJumpHeight(gravity, densityAir, dragCoefficient, ...
                     dragArea, efficiency, ...
                     totalEnergy, totalMass);

IDnumber = totalMass * gravity / (densityAir * dragArea * initialVelocity^2);
performanceRatio = dragHeight / noDragHeight;

%% Stats
energyDensity = energyOneSpring / massOneSpring;
fprintf('\n-------------------------------\n');
fprintf('Bow Properties (One)\n');
fprintf('-------------------------------\n');
fprintf('Energy\t\t%6.1f J\n', energyOneSpring(end));
fprintf('Carbon Mass\t%6.1f g\n', massOneSpring*1000);
fprintf('Energy Density\t%6.0f J/kg\n', energyDensity(end));
fprintf('Maximum Stress\t%6.2f GPa\n', 1e-9*max(stress(:, end)));
fprintf('Tip Force\t%6.2f N\n', force(end));
fprintf('\n-------------------------------\n');
fprintf('Jump Performance\n');
fprintf('-------------------------------\n');
fprintf('Total Mass\t%6.1f g\n', 1000*totalMass);
fprintf('Total Force\t%6.2f N\n', force(end) * numberOfSprings);
fprintf('Total Energy\t%6.1f J\n', totalEnergy);
fprintf('Efficiency\t%6.2f\n', efficiency);
fprintf('No drag height\t%6.1f m\n', noDragHeight);
fprintf('Drag height\t%6.1f m\n', dragHeight);
fprintf('ID Number\t%6.1f\n', IDnumber);
fprintf('Performance\t%6.1f\n', performanceRatio);
