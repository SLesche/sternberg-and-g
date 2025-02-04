%%% preprocessing general script
clear all

% nSubjects = 6; % specify number of subjects

%specify paths
PATH_MAIN = 'C:\Users\Sven\Documents\projects\research\promotion_mental_speed\sternberg-and-g\Christoph\raw_data_eeg\mzp_1';
PATH_RAW_DATA =  'C:\Users\Sven\Documents\projects\research\promotion_mental_speed\sternberg-and-g\Christoph\raw_data_eeg\mzp_1\raw_data\';

addpath('C:\Users\Sven\Documents\projects\research\promotion_mental_speed\decision-or-response-analysis\functions')

raw_data_ids = getIdsFromFolder(PATH_RAW_DATA, '\.vhdr$', '(\d+)\.vhdr$');

autoclean_ids = getIdsFromFolder(fullfile(PATH_MAIN,'autocleaned'), '\d+_autocleaned_response\.fdt$', '^(\d+)_auto');

subject_ids = setdiff(raw_data_ids, autoclean_ids);
subject_ids = subject_ids(subject_ids < 152);
%ATTENTION This code creates folders that are needed for the script
%create all folders

mkdir(fullfile(PATH_MAIN, 'RT/'));
%loop through filter settings and create a folde for each
mkdir(fullfile(PATH_MAIN,'autocleaned'))
mkdir(fullfile(PATH_MAIN, 'icweights'))
mkdir(fullfile(PATH_MAIN, 'icset'))
mkdir(fullfile(PATH_MAIN, 'erp'))
mkdir(fullfile(PATH_MAIN, 'preprostats'))

PATH_PREPROSTATS = fullfile(PATH_MAIN, 'preprostats');

parfor isubject = 1:length(subject_ids)

    subject = num2str(subject_ids(isubject));
    
    subject_nr = subject_ids(isubject);

    datafile = '';
    % define name of datafile dynamically
    if subject_nr < 10
        datafile = ['Exp23_000' num2str(subject_nr) '.vhdr'];
    elseif subject_nr >= 10 && subject_nr < 100
        datafile = ['Exp23_00' num2str(subject_nr) '.vhdr'];
    elseif subject_nr >= 100
        datafile = ['Exp23_0' num2str(subject_nr) '.vhdr'];
    end

    if subject_nr == 116
            datafile = ['Exp23_00' num2str(subject_nr) '.vhdr'];
    elseif  subject_nr == 138 || subject_nr == 125 
        datafile = ['Ground_Ref_Vertauscht'];
    elseif subject_nr == 4 || subject_nr == 34 || subject_nr == 103
        datafile = ['Abbruch'];   
    end

    if isfile([PATH_RAW_DATA datafile]) == 1

        % Load coded data
        EEG =  pop_loadbv(PATH_RAW_DATA, datafile, [], []);

        % remove any time periods outside the relevant experimental blocks
         if subject_nr == 27
            time_intervals = [
                EEG.event(find(ismember({EEG.event.type}, 'S 16'), 1, 'last')).latency/1000  EEG.event(find(ismember({EEG.event.type}, 'S117'), 1, 'last')).latency/1000;
            ];
         else
            time_intervals = [
                EEG.event(find(ismember({EEG.event.type}, 'S 16'), 1, 'last')).latency/1000  EEG.event(find(ismember({EEG.event.type}, 'S111'), 1, 'last')).latency/1000;
            ];
         end
        

        time_intervals_sorted = sort(time_intervals,1);
        % EEG = assignConditionFactors(EEG, time_intervals_sorted);

        EEG = pop_select(EEG, 'time', time_intervals_sorted);
        %{
        % remove data between breaks within expermintal blocks
        num_break_start = length(find(ismember({EEG.event.type}, 'S  3')));%get number of markers that were recorded
        
        breakStart = 1;
        breakEnd = length(EEG.event);

        for b = 1:num_break_start
            for j = 1:length(EEG.event)
                if strcmp(EEG.event(j).type, 'S  3')
                    breakStart = j;
                elseif strcmp(EEG.event(j).type, 'S  4')
                    breakEnd  = j;
                end
            end
            if breakEnd == breakStart+1
                EEG = pop_select(EEG,'notime', [EEG.event(breakStart).latency/1000  EEG.event(breakEnd).latency/1000]); % remove data
                EEG.event(breakStart).type = 'break_start';
            elseif breakEnd == breakStart+2
                EEG = pop_select(EEG,'notime', [EEG.event(breakStart).latency/1000  EEG.event(breakEnd).latency/1000]); % remove data
                EEG.event(breakStart).type = 'break_start';
            else
                EEG = pop_select(EEG,'notime', [EEG.event(breakStart).latency/1000  EEG.event(breakStart+1).latency/1000]); % remove data
                EEG.event(breakStart).type = 'break_start';
            end
        end
        %}

        preprostats = struct();

        %save number of epochs as sanity check
        preprostats.EEG_num_epochs = length(EEG.event);


        % Save original channel locations
        EEG.chanlocs_original = EEG.chanlocs;

        idLabelKeys = [
            "S 31", "fix";
            "S 32", "fix";
            "S 41", "isi_nomatch";
            "S 42", "isi_match";
            "S 61", "memset_nomatch";
            "S 62", "memset_match";
            "S 71", "cue_nomatch";
            "S 72", "cue_match";
            "S 51", "probe_nomatch";
            "S 52", "probe_match";
            "S 90", "iti";
            "S222", "no_response";
            "S150", "resp_correct_d";
            "S160", "resp_correct_l";
            "S250", "resp_incorrect_d";
            "S255", "resp_incorrect_l";
            "S251", "resp_other_key"
            ];

        EEG = processEEGEvents(EEG, idLabelKeys);

        EEG = oddEvenSplitByLabel(EEG);

        EEG = assignTrialNumbers(EEG, 'fix', {'iti'});

        incorrect_labels = {'resp_incorrect_d', 'resp_incorrect_l', 'resp_other_key', 'no_response'};

        EEG = flagIncorrectTrials(EEG, incorrect_labels);

        include_labels = {
            'resp_correct_d', 'resp_correct_l',
            % 'resp_probe_correct', 'resp_memset_correct'
            };

        for ievent = 1:length(EEG.event)
            if EEG.event(ievent).Trial == -1
                EEG.event(ievent).include_trial = 0;
            end

            if ~ismember(EEG.event(ievent).label, include_labels)
                EEG.event(ievent).include_trial = 0;
            end
        end

        % Epoch Data
        for ievent = 1:length(EEG.event)
            if EEG.event(ievent).include_trial == 1
                EEG.event(ievent).type = 'include';
            else
                EEG.event(ievent).type = 'exclude';
            end
        end
 
        preprostats=[];
        preprostats.subject = subject;

        %create path variables for respective task
        PATH_AUTOCLEANED = fullfile(PATH_MAIN, 'autocleaned/');
        PATH_ICWEIGHTS = fullfile(PATH_MAIN, 'icweights/');
        PATH_ICSET = fullfile(PATH_MAIN, 'icset/');

        % Create a copy for ICA
        ICA = EEG;

        % Resample
        EEG = pop_resample(EEG, 500);
        ICA = pop_resample(ICA, 200);

        % zero-phase Hamming window FIR-filter
        EEG = pop_eegfiltnew(EEG, 'locutoff',0.1, 'hicutoff', 70, 'plotfreqz',0);
        ICA = pop_eegfiltnew(EEG, 'locutoff',1, 'hicutoff', 70, 'plotfreqz',0);

        % remove line noise
        EEG = pop_cleanline(EEG, 'bandwidth',2,'chanlist',[1:34] ,'computepower',1,'linefreqs',50,'newversion',0,'normSpectrum',0,'p',0.01,'pad',2,'plotfigures',0,'scanforlines',0,'sigtype','Channels','taperbandwidth',2,'tau',100,'verb',1,'winsize',4,'winstep',1);
        ICA = pop_cleanline(ICA, 'bandwidth',2,'chanlist',[1:34] ,'computepower',1,'linefreqs',50,'newversion',0,'normSpectrum',0,'p',0.01,'pad',2,'plotfigures',0,'scanforlines',0,'sigtype','Channels','taperbandwidth',2,'tau',100,'verb',1,'winsize',4,'winstep',1);

        % bad channel detection
        % set criteria
        crit_z = 3.29; % Tabachnik & Fiedell, 2007 p. 73: Outlier detection criteria
        [~, indelec1_EEG] = pop_rejchan(EEG, 'elec',[1:32,EEG.nbchan] ,'threshold',crit_z,'norm','on','measure','prob');%we look for probability
        [~, indelec2_EEG] = pop_rejchan(EEG, 'elec',[1:32,EEG.nbchan] ,'threshold',crit_z,'norm','on','measure','kurt');%we look for kurtosis
        [~, indelec3_EEG] = pop_rejchan(EEG, 'elec',[1:32,EEG.nbchan] ,'threshold',crit_z,'norm','on','measure','spec','freqrange',[1 125] );	%we look for frequency spectra


        [~, indelec1_ICA] = pop_rejchan(ICA, 'elec',[1:32,EEG.nbchan] ,'threshold',crit_z,'norm','on','measure','prob');%we look for probability
        [~, indelec2_ICA] = pop_rejchan(ICA, 'elec',[1:32,EEG.nbchan] ,'threshold',crit_z,'norm','on','measure','kurt');%we look for kurtosis
        [~, indelec3_ICA] = pop_rejchan(ICA, 'elec',[1:32,EEG.nbchan] ,'threshold',crit_z,'norm','on','measure','spec','freqrange',[1 125] );	%we look for frequency spectra

        % check whether a channel is bad in multiple criteria
        index_EEG=sort(unique([indelec1_EEG,indelec2_EEG,indelec3_EEG])); %index is the bad channel array

        % check whether a channel is bad in multiple criteria
        index_ICA=sort(unique([indelec1_ICA,indelec2_ICA,indelec3_ICA])); %index is the bad channel array

        if ismember(33, index_EEG)
            index_EEG(index_EEG == 33) = [];
        end
        if ismember(34, index_EEG)
            index_EEG(index_EEG == 34) = [];
        end
        if ismember(33, index_ICA)
            index_ICA(index_ICA == 33) = [];
        end
        if ismember(34, index_ICA)
            index_ICA(index_ICA == 34) = [];
        end

        % save number of rejected channels
        preprostats.nbchanrej_ICA=length(index_ICA);
        preprostats.nbchanrej_EEG=length(index_EEG);

        Channelrej = cellstr(num2str(reshape(index_EEG, [1,length(index_EEG)])));%first column = rejected chans EEG
        Channelrej(1,2) = cellstr(num2str(reshape(index_ICA, [1,length(index_ICA)])));%first column = rejected chans ICA

        %interpolate rejected channels
        EEG = pop_interp(EEG, index_EEG, 'spherical');
        ICA = pop_interp(ICA,  index_ICA, 'spherical');

        %save correct channel location
        EEG.chanlocs = EEG.chanlocs_original;

        % re-reference data
        EEG = pop_chanedit(EEG, 'append',EEG.nbchan,'changefield',{EEG.nbchan+1 'labels' 'Cz'},'changefield',{EEG.nbchan+1 'sph_theta' '0'},'changefield',{EEG.nbchan+1 'sph_phi' '90'},'changefield',{EEG.nbchan+1 'sph_radius' '85'},'convert',{'sph2all'});
        EEG = pop_chanedit(EEG, 'setref',{'1:34' 'Cz'});

        ICA = pop_chanedit(ICA, 'append',ICA.nbchan,'changefield',{ICA.nbchan+1 'labels' 'Cz'},'changefield',{ICA.nbchan+1 'sph_theta' '0'},'changefield',{ICA.nbchan+1 'sph_phi' '90'},'changefield',{ICA.nbchan+1 'sph_radius' '85'},'convert',{'sph2all'});
        ICA = pop_chanedit(ICA, 'setref',{'1:34' 'Cz'});

        % compute average reference to keep reference channel in data
        EEG = pop_reref( EEG, [],'exclude',[33 34],'refloc',struct('labels',{'Cz'},'sph_radius',{85},'sph_theta',{0},'sph_phi',{90},'theta',{0},'radius',{0},'X',{5.2047e-15},'Y',{0},'Z',{85},'type',{''},'ref',{'Cz'},'urchan',{[]},'datachan',{0},'sph_theta_besa',{0},'sph_phi_besa',{90}));
        ICA = pop_reref( ICA, [],'exclude',[33 34],'refloc',struct('labels',{'Cz'},'sph_radius',{85},'sph_theta',{0},'sph_phi',{90},'theta',{0},'radius',{0},'X',{5.2047e-15},'Y',{0},'Z',{85},'type',{''},'ref',{'Cz'},'urchan',{[]},'datachan',{0},'sph_theta_besa',{0},'sph_phi_besa',{90}));

        % check data rank
        dataRank = sum(eig(cov(double(ICA.data'))) > 1E-6); % 1E-6 follows pop_runica() line 531, changed from 1E-7.

        EEG = pop_selectevent( EEG, 'type',{'include'},'deleteevents','on');
        ICA = pop_selectevent( ICA, 'type',{'include'},'deleteevents','on');

        EEG = pop_epoch(EEG, {'include'}, [-1.2, 1.0], 'epochinfo', 'yes');
        ICA = pop_epoch(ICA, {'include'}, [-1, 1], 'epochinfo', 'yes');

        % save information on rejected data epochs
        preprostats.EEG_epoch_total = EEG.event(end).epoch;
        preprostats.ICA_epoch_total = ICA.event(end).epoch;

        % Automated detection and removal of bad epochs
        EEG.segs_original_n = size(EEG.data, 3);
        [EEG, rejsegs] = pop_autorej(EEG, 'nogui', 'on', 'threshold', 1000, 'startprob', 5, 'maxrej', 5, 'eegplot', 'off');
        EEG.segs_rejected = length(rejsegs);

        ICA.segs_original_n = size(ICA.data, 3);
        [ICA, rejsegs] = pop_autorej(ICA, 'nogui', 'on', 'threshold', 1000, 'startprob', 5, 'maxrej', 5, 'eegplot', 'off');
        ICA.segs_rejected = length(rejsegs);

        % List of unique labels and conditions in the EEG.event
        uniqueLabels = unique({EEG.event.label});  % Get all unique event labels
        
        % Loop through each label and each condition
        for ilabel = 1:length(uniqueLabels)
            % Get the label and condition combination
            label = uniqueLabels{ilabel};
            
            % Count the number of occurrences of this label-condition combination
            count = length(find(ismember({EEG.event.label}, label)));
            
            % Store the count in the preprostats structure dynamically
            fieldName = sprintf('EEG_epoch_%s', label);
            preprostats.(fieldName) = count;
        end

        %save ICA data set
        ICA = pop_saveset(ICA, 'filename', [subject '_ic_set_response.set'], 'filepath', PATH_ICSET, 'check', 'on', 'savemode', 'twofiles');

        %run ICA
        ICA = pop_runica(ICA, 'extended', 1, 'interupt', 'on', 'pca', dataRank);
        ICA = pop_saveset(ICA, 'filename', [subject '_weights_response.set'], 'filepath', PATH_ICWEIGHTS, 'check', 'on', 'savemode', 'twofiles');

        % Run IClabel
        ICA = iclabel(ICA, 'default');
        ICA.ICout_IClabel = find(ICA.etc.ic_classification.ICLabel.classifications(:, 1) < 0.5);

        % Copy IC weights to highpass filtered data (at 0.1 Hz)
        EEG.icachansind = ICA.icachansind;
        EEG.icaweights =ICA.icaweights;
        EEG.icasphere = ICA.icasphere;
        EEG.icawinv =  ICA.icawinv;
        EEG.ICout_IClabel = ICA.ICout_IClabel;

        % compute IC activation matrix
        EEG = eeg_checkset(EEG, 'ica');

        % Remove components
        EEG = pop_subcomp(EEG, EEG.ICout_IClabel);
        preprostats.icout = length(EEG.ICout_IClabel);

        %remove baseline
        %EEG = pop_rmbase(EEG, [-200 0]); 

        %save cleaned EEG data set
        EEG = pop_saveset(EEG, 'filename', [subject '_autocleaned_response.set'], 'filepath', PATH_AUTOCLEANED, 'check', 'on', 'savemode', 'twofiles');

        % write stats
        preprostats_table = struct2table(preprostats);
        writetable(preprostats_table, [PATH_PREPROSTATS '\preprostats_response_' subject '.csv'])
        writecell(Channelrej(:,:), [PATH_PREPROSTATS '\channels_rej_response_' subject '.xlsx']);

    end
end


