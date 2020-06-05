%% dtcPlotFeatureSpace1D
% Function file provided by the lab files. This function was modified to
% support the same color scheme used in the report and the remaining
% figures.

function l = dtcPlotFeatureSpace1D(fvect,lvect, sty)

if ~isrow(fvect)
    error('fvect must be a row vector');
end

%% Find unique labels
u = unique(lvect);

%% Plot
%hf = figure;
hf = gcf;

hold on;

% Generate a color map
cmap = hsv(size(u,2));

for i=1:size(u,2)
    f = fvect(:,lvect==u(i));
    [p,xi] = ksdensity(f);
    l = plot(xi,p);
    set(l,'Color',sty{i});
    set(l,'LineWidth', 1.2);
    legends{i} = ['Class ' num2str(u(i))];
end
%legend(legends);
xlabel('Feature value');
ylabel('PDF');
hold off
grid on