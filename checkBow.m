clear; close all; clc;

% Optimization to find the bow curvature and energy. The jumping height is
% calculated from that using a defined payload.
rhoAir = 1.225;  % kg/m^3
g = 9.81;  % m/s^2

%% To change
% Mechanism values
payloadMass = 0.255; % kg
hingeMass = 0.02;  % kg (Total Mass for 2 hinges)
frontalArea = (2*0.0254)^2*pi/4;  % m^2
cD = 1.5;  % Drag coefficient

% Bow Dimensions
L = 1;  % m (Uncompressed length)
finalLength = 0.23;  % m (Compressed length)
baseB = 0.220*0.0254;  % m (Width of the carbon)
baseH = 0.092*0.0254;  % m (Thickness of the carbon)
numberOfSprings = 8;  % Number of bows


%% Other Simulation Values
nElements = 50;  % Discretization of the bow
nElements = 2*ceil(nElements/2);
E = 131e9;  % Pa (Young's Modulus)
density = 1500;  % kg/m^3
dL = L/nElements;  % m (Length of each element)
vectorL = (0:dL:L)';
b = baseB*ones(nElements,1);
h = baseH*ones(nElements,1);
I = b.*h.^3/12;  % m ^4 (Inertia)
k = E*I/dL;  % Torsional stiffness of each element

massOneSpring = sum(density*b.*h*dL);  % Mass of one bow
totalMass = payloadMass + numberOfSprings*massOneSpring + hingeMass;
efficiency = (payloadMass + 0.5*numberOfSprings*massOneSpring + 0.5*hingeMass)/totalMass;

bendingMoment = zeros(nElements+1, 1);
stress = zeros(nElements+1, 1);

%% Solve for angles
q0 = pi/(nElements+1)*ones(1,nElements);
[q, energyOneSpring] = fmincon(@(q)energyFun(q,k), q0, [],[],[],[],[],[],@(q)constraintFun(q,dL,finalLength));
totalEnergy = numberOfSprings*energyOneSpring;

% Shape
posX = [0;cumsum(dL*cos(cumsum(q')))];
posY = [0;cumsum(dL*sin(cumsum(q')))];

%% Stress & Force
bendingMoment(1:nElements) = E*I.*q'/dL;
bendingMoment(1) = 0;
stress(1:nElements) = bendingMoment(1:nElements).*h./(2*I)/1e9;  % GPa
force = energyOneSpring/(L+1e-6-finalLength);


%% Plot of shape
% Deflection
f = figure;
axis([-0.6*L, 0.6*L, -0.1*L, 1.1*L]);
grid on; hold on;
title(sprintf('Deflection (Total Energy: %.3f J)',energyOneSpring));
plot(posX, posY, 'ok');
surface([posX,posX], [posY,posY], [stress,stress], ...
    'facecol', 'no', 'Linewidth', 5, 'edgecol', 'interp');
c = colorbar;
xlabel('x (m)');
ylabel('y (m)');

%% Jumping Height
initialVelocity = sqrt(2*efficiency*totalEnergy/totalMass);  % m/s
noLossHeight = 0.5*initialVelocity^2/g;
IDnumber = totalMass*g / (rhoAir*frontalArea*initialVelocity^2);
maxHeight = totalMass./(cD.*frontalArea*rhoAir).* ...
        log(1+cD.*frontalArea*rhoAir.*initialVelocity.^2./(2*totalMass*g));

performanceRatio = maxHeight/noLossHeight;

%% Stats
clc;
energyDensity = energyOneSpring/massOneSpring;
fprintf('-------------------------------\n');
fprintf('       Bow Properties (One)\n');
fprintf('-------------------------------\n');
fprintf('           Energy: %6.1f J\n', energyOneSpring(end));
fprintf('      Carbon Mass: %6.1f g\n', massOneSpring*1000);
fprintf('   Energy Density: %6.0f J/kg\n', energyDensity(end));
fprintf('   Maximum Stress: %6.2f GPa\n', max(stress(:,end)));
fprintf('        Tip Force: %6.2f N\n', force(end));
fprintf('-------------------------------\n');
fprintf('        Jump Performance\n');
fprintf('-------------------------------\n');
fprintf('       Total Mass: %6.1f g\n', totalMass*1000);
fprintf('      Total Force: %6.2f N\n', force(end)*numberOfSprings);
fprintf('     Total Energy: %6.1f J\n', totalEnergy);
fprintf('       Efficiency: %6.2f\n', efficiency);
fprintf('   No Loss Height: %6.1f m\n', noLossHeight);
fprintf('      Real Height: %6.1f m\n', maxHeight);
fprintf('        ID Number: %6.1f\n', IDnumber);
fprintf('Performance Ratio: %6.1f\n', performanceRatio);
