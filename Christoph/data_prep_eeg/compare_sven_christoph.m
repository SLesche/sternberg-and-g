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
PATH_ERP_CHRISTOPH                = fullfile(PATH_MAIN, '\erp\original/');

list_erps_sven = dir(fullfile(PATH_ERP_AV, '**', '*_erp.erp'));
list_erps_christoph = dir(fullfile(PATH_ERP_CHRISTOPH, '**', '*.erp'));

arr_sven = {};
for i = 1:length(list_erps_sven)
    arr_sven{i} = fullfile(list_erps_sven(i).name);
end

[ERP_sven ALLERP_sven] = pop_loaderp('filename', arr_sven, 'filepath', PATH_ERP_AV);

GA_sven =  pop_gaverager( ...
            ALLERP_sven, 'DQ_flag', 0, 'Erpsets', 1:length(ALLERP_sven),...
            'ExcludeNullBin', 'on', 'SEM', 'on');

arr_christoph = {};
for i = 1:length(list_erps_christoph)
    arr_christoph{i} = fullfile(list_erps_christoph(i).name);
end

[ERP_christoph ALLERP_christoph] = pop_loaderp('filename', arr_christoph, 'filepath', PATH_ERP_CHRISTOPH);

GA_christoph =  pop_gaverager( ...
            ALLERP_christoph, 'DQ_flag', 0, 'Erpsets', 1:length(ALLERP_christoph),...
            'ExcludeNullBin', 'on', 'SEM', 'on');

% Extract numbers from the filename
numValues = zeros(1, length(ALLERP_sven)); % Preallocate for speed
for i = 1:length(ALLERP_sven)
    numStr = regexp(ALLERP_sven(i).filename, '\d+', 'match'); % Extract number as a string
    numValues(i) = str2double(numStr{1}); % Convert to number
    ALLERP_sven(i).subject = str2double(numStr{1});
end

% Extract numbers from the filename
numValues = zeros(1, length(ALLERP_christoph)); % Preallocate for speed
for i = 1:length(ALLERP_christoph)
    numStr = regexp(ALLERP_christoph(i).filename, '\d+', 'match'); % Extract number as a string
    numValues(i) = str2double(numStr{1}); % Convert to number
    ALLERP_christoph(i).subject = str2double(numStr{1});
end

%% GA
plot(GA_christoph.times, GA_christoph.bindata(11, :, 1));
hold on
plot(GA_sven.times, GA_sven.bindata(11, :, 2))
hold off

%%
subject_nr = 11;
plot(GA_christoph.times, ALLERP_christoph(find([ALLERP_christoph.subject] == subject_nr)).bindata(11, :, 1));
hold on
plot(GA_sven.times, ALLERP_sven(find([ALLERP_sven.subject] == subject_nr)).bindata(11, :, 2));
hold off