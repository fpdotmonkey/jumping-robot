dragCoefficients = 1;

specificDrags = logspace(-1, 2);

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
xlabel(['Specifc Drag = $2\frac{\rm dragCoefficient \cdot airDensity \cdot dragArea ' ...
        '\cdot initialVelocity^2}{\rm totalMass \cdot gravity}$'], 'interpreter', 'latex')
ylabel(['Jump Performance = $\frac{2}{\rm specificDrag}\log\left[1+\' ...
        'frac{1}{2} \cdot \rm specificDrag\right]$'], 'interpreter', 'latex')
