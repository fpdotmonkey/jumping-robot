function stress = jumperStress(numberOfElements, youngsModulus, ...
                               springWidth, springThickness, ...
                               uncompressedLength, deflection)

dLength = uncompressedLength / numberOfElements;

bendingMoment = zeros(numberOfElements + 1, 1);
stress = zeros(numberOfElements + 1, 1);

secondMomentOfArea = springWidth * springThickness^3 / 12;  % m^4

bendingMoment(1:numberOfElements) = ...
    youngsModulus * secondMomentOfArea * deflection' / dLength;
bendingMoment(1) = 0;

stress(1:numberOfElements) = ...
    bendingMoment(1:numberOfElements) * springThickness / ...
    (2*secondMomentOfArea);  % Pa

end
