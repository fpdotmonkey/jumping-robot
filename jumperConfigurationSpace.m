clear all;
gravity = 9.81;
airDensity = 1.225;

numberOfElements = 50;

youngsModulus = 131e9;
springDensity = 1500;

massHinge = .020;

numberOfSprings = 4;
springWidth = .0047752;
springThickness = .0004826;

dragCoefficient = 1.4;
dragMassPerArea = 1.0969;  % CF reinforced epoxy, .77mm thick

desiredSpecificDrags = logspace(-2, 2, 5);

SPRING_LENGTH = 0.15:0.05:1.00;
DRAG_RADIUS = 0.00:0.01:0.200;
MASS_PAYLOAD = 0.000;

[ DR, SL ] = meshgrid(DRAG_RADIUS, SPRING_LENGTH);

for i = 1:length(DR(:, 1))
    for j = 1:length(SL(1, :))
        dragArea = pi * DR(i, j)^2;
        massDrag = dragArea * dragMassPerArea;
        massSpring = springDensity * numberOfSprings * SL(i, j) ...
            * springWidth * springThickness;
        totalMass = MASS_PAYLOAD + massHinge + massSpring + ...
            massDrag;
        compressedSpringLength = 0.23 * SL(i, j);
        
        [ ~, energyPerSpring ] = jumperDeflection(numberOfElements, ...
                                                  youngsModulus, ...
                                                  springWidth, ...
                                                  springThickness, ...
                                                  SL(i, j), ...
                                                  compressedSpringLength, ...
                                                  numberOfSprings);
        
        efficiency = jumperEfficiency(massHinge, ...
                                      numberOfSprings, ...
                                      massSpring / numberOfSprings, ...
                                      MASS_PAYLOAD);

        [ velocity(i, j), ~, ~ ] = jumperJumpHeight(gravity, ...
                                                    airDensity, ...
                                                    dragCoefficient, ...
                                                    dragArea, ...
                                                    efficiency, ...
                                                    numberOfSprings * ...
                                                     energyPerSpring, ...
                                                    totalMass);

        specificDrag(i, j) = ...
            (dragCoefficient * airDensity * dragArea * velocity(i, j)^2) ...
            / (totalMass * gravity);

    end
end

csvwrite('~/projects/Jumping Robots/velocity.csv', velocity)
csvwrite('~/projects/Jumping Robots/specificDrag.csv', specificDrag)
