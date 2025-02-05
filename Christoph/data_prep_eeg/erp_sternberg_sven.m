% =================================== extract ERP ===================================
clear all

% define paths 
addpath('C:\Users\Sven\Documents\projects\research\promotion_mental_speed\decision-or-response-analysis\functions')
PATH_MAIN = 'C:\Users\Sven\Documents\projects\research\promotion_mental_speed\sternberg-and-g\Christoph\raw_data_eeg\mzp_1';
% 
% PATH_AUTOCLEANED        = 'E:\Exp26\preprocessed_data_average_WM\MZP 1\autocleaned\';
% PATH_ERP_AV                = fullfile(PATH_MAIN, 'AV\t1/');
% PATH_ERP_SL                = fullfile(PATH_MAIN, 'SL\t1/');
% 
PATH_AUTOCLEANED           = fullfile(PATH_MAIN,'\autocleaned/');
PATH_ERP_AV                = fullfile(PATH_MAIN, '\erp\AV/');
PATH_ERP_SL                = fullfile(PATH_MAIN, '\erp\SL/');

mkdir(PATH_ERP_SL)
mkdir(PATH_ERP_AV)

%subject_ids = getIdsFromFolder(PATH_AUTOCLEANED,  'autocleaned_response\.fdt$', '(\d+)_autocleaned_response\.fdt$');
subject_ids = getIdsFromFolder(PATH_AUTOCLEANED,  'autocleaned\.fdt$', '(\d+)_autocleaned\.fdt$');

%subject_ids = 901;
% Create a map for ID to label
label_number_map = [
    "resp_correct_d", 31;
    "resp_correct_l", 32;
    "probe_nomatch", 22;
    "probe_match", 21;
    "memset_nomatch", 12;
    "memset_match", 11;
];
label_number_map = containers.Map(label_number_map(:, 1), label_number_map(:, 2));

parfor isubject = 1:length(subject_ids)
    % Load data
    subject = num2str(subject_ids(isubject));

    datafile = '';
    
    %datafile = [subject '_autocleaned_response.set'];
    datafile = [subject '_autocleaned.set'];
    
    if isfile([PATH_AUTOCLEANED datafile]) == 1
        
        EEG = pop_loadset('filename', datafile, 'filepath', PATH_AUTOCLEANED, 'loadmode', 'all');
        EEG = pop_select(EEG, 'nochannel', [33, 34]);
        
        %Filter ERP
        %lowpass filter might impact latency of peaks
        EEG = pop_eegfiltnew(EEG,'hicutoff', 8, 'plotfreqz',0);

        for ievent = 1:length(EEG.event)
            odd_even = EEG.event(ievent).Odd_Even;
            label = EEG.event(ievent).label;
        
            % Check if the label exists in the map
            if isKey(label_number_map, label)
                label_number = str2double(label_number_map(label));
                EEG.event(ievent).type = odd_even * 1000 + label_number;
            else
                % Set type to 99 if label is not present in the map
                EEG.event(ievent).type = 99;
            end
        end
        
        % Remove response markers
        EEG = eeg_checkset(EEG, 'eventconsistency');
        
        % Recreate continuous EEG
        EEG = pop_epoch2continuous(EEG,'Warning','off');
        
        % Create EventList for ERPLab
        EEG  = pop_creabasiceventlist(EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } );
        
        % Create Bins for different conditions       
        EEG  = pop_binlister(EEG , 'BDF', [PATH_MAIN '\binlister_stims.txt'], 'IndexEL',  1, 'SendEL2', 'Workspace&EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
        %EEG  = pop_binlister(EEG , 'BDF', [PATH_MAIN '\binlister_response.txt'], 'IndexEL',  1, 'SendEL2', 'Workspace&EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
        EEG.setname = 'bin';
        
        % Epoch data      
        EEG = pop_epochbin( EEG , [-200.0  1000.0],  [ -200 0]);
        %EEG = pop_epochbin( EEG , [-1200.0  1000.0],  [ -1200 -800]);
        EEG.setname =' bin_epoch';
        
        % perform CSD on copy of data set 
        %EEG_csd = EEG;
        %EEG_csd = csd_transform(EEG_csd, 'chanlocs.ced');

        % Compute ERPs for the different bins
        ERP = pop_averager( EEG , 'Criterion', 'all', 'ExcludeBoundary', 'off', 'SEM', 'on' );
        ERP.erpname = [subject '_bin_average'];
        
        % Save ERP set to
        ERP = pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [num2str(subject_ids(isubject)) '_erp.erp'], 'filepath', PATH_ERP_AV);
        %ERP = pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', [num2str(subject_ids(isubject)) '_erp_response.erp'], 'filepath', PATH_ERP_AV);

        % Compute ERPs for the CSDs
        %ERP_csd = pop_averager( EEG_csd , 'Criterion', 'all', 'ExcludeBoundary', 'off', 'SEM', 'on' );
        %ERP_csd.erpname = [subject '_bin_average'];
        %ERP_csd = pop_savemyerp(ERP_csd, 'erpname', ERP_csd.erpname, 'filename', [num2str(i) '_erp.erp'], 'filepath', PATH_ERP_SL);

    end
end


