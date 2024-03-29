function energy = jumperEnergy(uncompressedLength, ...
                               compressedLength, ...
                               springWidth, ...
                               springThickness, ...
                               numberOfSprings, ...
                               numberOfElements, ...
                               youngsModulus)

[ ~, energy ] = jumperDeflection(uncompressedLength, ...
                                 compressedLength, ...
                                 springWidth, ...
                                 springThickness, ...
                                 numberOfSprings, ...
                                 numberOfElements, ...
                                 youngsModulus);

end
