function velocity = velocityFunction(mass_payload, drag_area, ...
                                     gravity, airDensity, dragCoefficient, ...
                                     totalEnergy, dragMassPerArea, ...
                                     massHinge, massOneSpring, ...
                                     numberOfSprings)

efficiency = jumperEfficiency(massHinge, numberOfSprings, ...
                              massOneSpring, mass_payload);

[ velocity, ~, ~ ] = jumperJumpHeight(gravity, airDensity, dragCoefficient, ...
                                      drag_area, efficiency, ...
                                      totalEnergy, mass_payload + ...
                                      dragMassPerArea * drag_area + ...
                                      massHinge + ...
                                      numberOfSprings * massOneSpring);

end
