clear; close all; clc;
g = 9.81;
rhoAir = 1.225;  % kg/m^3


% Dummy Data
dummyPayload = [0.0236;0.0236;0.0299;0.0362;0.0425;0.0488;0.0551;0.0614];
dummyHeight = [13.9;13.6;13.4;12.9;12.6;11.6;11.0;11.0];


payloadMass = linspace(0, 0.1, 100)';
% payloadScaling = [0;3.6875];


% Fixed
carbonEnergyDensity = 1200;  % J/kg
batteryMass = 0.0001;  % kg
frontalArea = (1.5*0.0254).^2*pi/4;  % m^2
carbonMass = 0.0064;  % kg
cD = 1.3;  % Drag coefficient


%% Efficiency
totalMass = batteryMass + carbonMass + payloadMass;
movingMass = 0.5*carbonMass + payloadMass + batteryMass;
efficiency = movingMass./totalMass;


%% Jumping Height
energy = carbonMass*carbonEnergyDensity;
initialVelocity = sqrt(2*efficiency.*energy./totalMass);  % m/s
noLossHeight = 0.5*initialVelocity.^2/g;
maxHeight = totalMass./(cD.*frontalArea*rhoAir).* ...
        log(1+cD.*frontalArea*rhoAir.*initialVelocity.^2./(2*totalMass*g));
PR = maxHeight./noLossHeight;


%% Heights
height0 = energy./(carbonMass*g)*ones(size(payloadMass));
height1 = energy./(carbonMass + batteryMass)/g*ones(size(payloadMass));
height2 = energy./(totalMass*g);
height3 = efficiency.*height2;
height4 = PR.*height3;

%% Plot
figure;
area(payloadMass*1000, height0, 'FaceColor', [0.2, 0.2, 0.2]);
hold on;
area(payloadMass*1000, height1, 'FaceColor', [0.4, 0.4, 0.4]);
area(payloadMass*1000, height2, 'FaceColor', [0.6, 0.6, 0.6]);
area(payloadMass*1000, height3, 'FaceColor', [0.8, 0.8, 0.8]);
area(payloadMass*1000, height4, 'FaceColor', [1, 1, 1]);
ylabel('Height (m)');
xlabel('Payload (g)');
legend('Structure', 'Payload', 'Efficiency', 'Drag', 'Jump');

%% Print
maxHeightJump = max(height4);
bestPayload = payloadMass(find(height4 >= maxHeightJump,1 , 'first'));
fprintf('--------------------\n');
fprintf(' Carbon Mass: %4.1f g\n', carbonMass*1000);
fprintf('Battery Mass: %4.1f g\n', batteryMass*1000);
fprintf('--------------------\n');
fprintf('  Max Height: %4.1f m\n', maxHeightJump);
fprintf('Best Payload: %4.1f g\n', bestPayload*1000);
fprintf('--------------------\n');
% 
% % Computed
% payloadEnergyDensity = carbonEnergyDensity./payloadScaling;
% totalEnergyDensity = 1./(1/carbonEnergyDensity + 1/batteryEnergyDensity + 1./payloadEnergyDensity);
% movingEnergyDensity = 1./(1/(2*carbonEnergyDensity) + 1/batteryEnergyDensity + 1./payloadEnergyDensity);
% efficiency = totalEnergyDensity./movingEnergyDensity;
% 
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % Jumping Height
% totalMass = carbonMass*carbonEnergyDensity./totalEnergyDensity;
% initialVelocity = sqrt(2*efficiency.*totalEnergyDensity);  % m/s
% noLossHeight = 0.5*initialVelocity.^2/g;
% maxHeight = totalMass./(cD.*frontalArea*rhoAir).* ...
%         log(1+cD.*frontalArea*rhoAir.*initialVelocity.^2./(2*totalMass*g));
% PR = maxHeight./noLossHeight;
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% % Heights
% height0 = ones(size(payloadScaling));
% height1 = ones(size(payloadScaling))/(1/carbonEnergyDensity + 1/batteryEnergyDensity)/carbonEnergyDensity;
% height2 = totalEnergyDensity/carbonEnergyDensity;
% height3 = efficiency.*height2;
% height4 = PR.*height3;
% 
% % Plot
% figure;
% area(payloadScaling*carbonMass*1000, height0*carbonEnergyDensity/g, 'FaceColor', [0.2, 0.2, 0.2]);
% hold on;
% area(payloadScaling*carbonMass*1000, height1*carbonEnergyDensity/g, 'FaceColor', [0.4, 0.4, 0.4]);
% area(payloadScaling*carbonMass*1000, height2*carbonEnergyDensity/g, 'FaceColor', [0.6, 0.6, 0.6]);
% area(payloadScaling*carbonMass*1000, height3*carbonEnergyDensity/g, 'FaceColor', [0.8, 0.8, 0.8]);
% area(payloadScaling*carbonMass*1000, height4*carbonEnergyDensity/g, 'FaceColor', [1, 1, 1]);
% plot(dummyPayload*1000, dummyHeight, '.k', 'MarkerSize', 10);
% ylabel('Ratio hg/E_D');
% % line([23.1, 23.1], [0, 140], 'Color', 'k', 'LineWidth', 2);
% xlabel('Payload/CarbonMass');
