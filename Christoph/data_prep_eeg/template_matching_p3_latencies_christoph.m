clear all

% Setting paths
% Get the directory of the currently executing script
[filepath, ~, ~] = fileparts(mfilename('fullpath'));

% Set the current directory to that directory
cd(filepath);
addpath("C:\Users\Sven\Documents\projects\research\template_matching\template-matching\functions") % add template matching functions
addpath("C:\Users\Sven\Documents\projects\research\template_matching\template-matching\app") % add app functions

% =================================== extract ERP ===================================
% define paths 
PATH_MAIN = 'C:\Users\Sven\Documents\projects\research\promotion_mental_speed\sternberg-and-g\Christoph\raw_data_eeg\mzp_1';
% 
% PATH_AUTOCLEANED        = 'E:\Exp26\preprocessed_data_average_WM\MZP 1\autocleaned\';
% PATH_ERP_AV                = fullfile(PATH_MAIN, 'AV\t1/');
% PATH_ERP_SL                = fullfile(PATH_MAIN, 'SL\t1/');
% 
PATH_ERP_AV                = fullfile(PATH_MAIN, '\erp\original/');

%list_erps = dir(fullfile(PATH_ERP_AV, '**', '*erp_response*.erp'));
list_erps = dir(fullfile(PATH_ERP_AV, '**', '*.erp'));

arr = {};
for i = 1:length(list_erps)
    arr{i} = fullfile(list_erps(i).name);
end

[ERP ALLERP] = pop_loaderp('filename', arr, 'filepath', PATH_ERP_AV);

GA =  pop_gaverager( ...
            ALLERP, 'DQ_flag', 0, 'Erpsets', 1:length(ALLERP),...
            'ExcludeNullBin', 'on', 'SEM', 'on');

times = GA.times;
plot(times, GA.bindata(11, :, 1))

erp_data = zeros([length(ALLERP) size(GA.bindata)]);

for isubject = 1:length(ALLERP)
    erp_data(isubject, :, :, :) = ALLERP(isubject).bindata;
end

[n_subjects, n_chans, n_times, n_bins] = size(erp_data);

% Convert to cell array with conditionsXn_subject entries 
component_names = ["p3_sternberg_christoph"];
n_components = length(component_names);
electrodes = [11]; % We only have one electrode saved in example data
polarity = ["positive"];
windows = {[200 800]};

% For fitting
possible_approaches = ["minsq"];
possible_weights = ["get_normalized_weights"];
possible_normalization = ["none"];
possible_penalty = ["exponential_penalty"];
possible_derivative = [0];

% This combines all possible approaches
% If you only want one specific approach, only create one row of the comb table:
% comb = cell2table({"minsq", "get_normalized_weights", "none", "none", 0, "p3_flanker", "positive", [11], [200 650]}}

comb = combinations(possible_approaches, possible_weights, ...
    possible_penalty, possible_normalization, possible_derivative, ...
    component_names, polarity, electrodes, windows ...
    );

% add peak/area with no weights/normalization/penalty
comb(end+1, :) = {"peak", "none", "none", "none", 0, component_names(1), polarity(1), electrodes, windows};
comb(end+1, :) = {"area", "none", "none", "none", 0,  component_names(1), polarity(1), electrodes, windows};
comb(end+1, :) = {"liesefeldarea", "none", "none", "none", 0,  component_names(1), polarity(1), electrodes, windows};

column_names = {'approach', 'weight', 'penalty', 'normalization', 'use_derivative', 'component_name', 'polarity', 'electrodes', 'window'};
comb.Properties.VariableNames = column_names;

% If you can use the Parallel Computing Toolbox
results_mat = run_template_matching(erp_data, times, comb, 1); % Run the third (3) method saved in comb. You can run any 
% results_mat = run_template_matching_serial(erp_data, time_vec, comb, 3); % Much slower!

results = zeros(size(results_mat, 1) * size(results_mat, 2), 2 + size(results_mat, 3));
for ibin = 1:size(results_mat, 2)
    for isubject = 1:size(results_mat, 1)
        results(isubject + size(results_mat, 1) * (ibin - 1) , 1) = ibin;
        results(isubject + size(results_mat, 1) * (ibin - 1) , 2) = isubject;
        results(isubject + size(results_mat, 1) * (ibin - 1) , 3:7) = squeeze(results_mat(isubject, ibin, :));
    end
end
writematrix(squeeze(results), "stims_p3_automatic_odd_even_christoph.csv")

% The results matrix will consist of 5 columns and n_subjects rows
% the columns will be: a_param, b_param, latency, fit_cor, fit_dist

%{
liesefeld_latencies = zeros( length(ALLERP), 1);
subject_order = strings(length(ALLERP), 1);
for isubject = 1:length(ALLERP)
    subject_order(isubject) = convertCharsToStrings(ALLERP(isubject).filename);
    liesefeld_latencies(isubject, 1) = approx_area_latency(times, erp_data(isubject, 11, :, 2), [250 600], polarity, 0.5, true);
end

writematrix(subject_order, "subject_order_christoph.csv")
% Initialize the review app
review_app

raw_data_ids = getIdsFromFolder(PATH_ERP_AV, '*erp_response*.erp', '^(\d+)_');
%}
