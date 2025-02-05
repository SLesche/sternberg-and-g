% =================================== extract ERP ===================================
clear all

% define paths 
PATH_MAIN = 'C:\Users\Sven\Documents\projects\research\promotion_mental_speed\sternberg-and-g\Christoph\raw_data_eeg\mzp_1';
% 
% PATH_AUTOCLEANED        = 'E:\Exp26\preprocessed_data_average_WM\MZP 1\autocleaned\';
% PATH_ERP_AV                = fullfile(PATH_MAIN, 'AV\t1/');
% PATH_ERP_SL                = fullfile(PATH_MAIN, 'SL\t1/');
% 
PATH_ERP_AV                = fullfile(PATH_MAIN, '\erp\AV/');

list_erps = dir(fullfile(PATH_ERP_AV, '**', '*erp_response*.erp'));
%list_erps = dir(fullfile(PATH_ERP_AV, '**', '*_erp.erp'));

arr = {};
for i = 1:length(list_erps)
    arr{i} = fullfile(list_erps(i).name);
end

[ERP ALLERP] = pop_loaderp('filename', arr, 'filepath', PATH_ERP_AV);

GA =  pop_gaverager( ...
            ALLERP, 'DQ_flag', 0, 'Erpsets', 1:length(ALLERP),...
            'ExcludeNullBin', 'on', 'SEM', 'on');

%% Plot grand averages
electrode = 11;

plot(GA.times, GA.bindata(electrode, :, 1), 'Color', "#D95319",'LineWidth', 1.5, 'LineStyle', '--') 
hold on

% Reverse Y-axis direction
set(gca, 'YDir', 'reverse')

% Set X and Y axis properties
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
set(gca, 'TickDir', 'in')
ax.XRuler.TickLabelGapOffset = -30;
% Adjust tick label font size
ax.FontSize = 12; % Adjust font size for both x and y axis tick labels

% Adjust labels position and font size
Ylm = ylim;
Xlm = xlim;
Xlb = 0.90 * Xlm(2);
Ylb = 0.90 * Ylm(1);
xlabel('ms', 'Position', [Xlb 0.75], 'FontSize', 14) % Increased font size
ylabel('µV', 'Position', [-100 Ylb], 'FontSize', 14) % Increased font size

hold off

%% Plot individual ERPs
subject_nr = 47;
bin = 6;

plot(ALLERP(subject_nr).times, ALLERP(subject_nr).bindata(11, :, bin), 'Color', "#0072BD",'LineWidth', 1.5) % 1d
% Reverse Y-axis direction
set(gca, 'YDir', 'reverse')

% Set X and Y axis properties
ax = gca;
ax.XAxisLocation = 'origin';
ax.YAxisLocation = 'origin';
set(gca, 'TickDir', 'in')
ax.XRuler.TickLabelGapOffset = -20;

% Adjust labels position
Ylm = ylim;
Xlm = xlim;
Xlb = 0.90 * Xlm(2);
Ylb = 0.90 * Ylm(1);
xlabel('ms', 'Position', [Xlb 0.75]);
ylabel('µV', 'Position', [-100 Ylb]);