function efficiency = jumperEfficiency(hingeMass, numberOfSprings, ...
                                      massOneSpring, payloadMass)

totalMass = hingeMass + payloadMass + numberOfSprings * massOneSpring;

efficiency = ...
    (payloadMass + 0.5*numberOfSprings * massOneSpring + 0.5 * hingeMass) / ...
    totalMass;

end
