function [ xCoordinates, yCoordinates ] = jumperShape(numberOfElements, ...
                                                  uncompressedLength, ...
                                                  deflection)

dLength = uncompressedLength / numberOfElements;

xCoordinates = [0; cumsum(dLength * cos(cumsum(deflection')))];
yCoordinates = [0; cumsum(dLength * sin(cumsum(deflection')))];

end
