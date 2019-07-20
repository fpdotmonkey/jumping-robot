dragCoefficients = 1;

specificDrags = logspace(-1, 5);

jumpPerformances = zeros(length(specificDrags), ...
                         length(dragCoefficients));

for i = 1:length(dragCoefficients)
    jumpPerformances(:, i) = ...
        (2 ./ (dragCoefficients(i) * specificDrags) .* ...
        log(1 + .5 * dragCoefficients(i) * specificDrags))';
end

figure(1);
clf;
semilogx(specificDrags, jumpPerformances);
xlabel('Specifc Drag')
ylabel('Jump Performance')
