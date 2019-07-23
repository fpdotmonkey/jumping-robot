jumpPerformanceVsSpecificDrag;
hold on;
clear jumpPerformances;
getJumperDesign;
for i = 1:length(jumpPerformances)
    plot(specificDrags(i), jumpPerformances(i), 'ro');
end

hold off;
