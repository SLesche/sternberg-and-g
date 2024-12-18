clear all
clc
eeglab

%%

PATH_MAIN = 'C:/Fill/In/Your/Path/Sternberg/';

PATH_RAW_DATA = ['C:/Fill/In/Your/Path/EEG data/'];

PATH_ICWEIGHTS = [PATH_MAIN, 'icweights/'];
PATH_AUTOCLEANED = [PATH_MAIN, 'autocleaned/'];
PATH_ADJUSTOUT = [PATH_MAIN, 'adjust_log/']; 
PATH_CHANREJECT = [PATH_MAIN, 'badchannels/']; 
PATH_EPOCHREJECT = [PATH_MAIN, 'badepochs/']; 
PATH_BADICS = [PATH_MAIN, 'badics/']; 

PATH_ERP = [PATH_MAIN, 'ERP/']; 
PATH_LIST = ['C:/Fill/In/Your/Path/Bin Lists/'];

%%

nSubjects = 151;
NotExistingFile = [];
ACCOutliers = [];
z = 1;
y = 1;

%%

for i = 1 : nSubjects
    subject = num2str(i);
   
    if i < 10
        datafile = ['Exp23_000' num2str(i) '_2.vhdr'];
    elseif i >= 10 && i < 100
        datafile = ['Exp23_00' num2str(i) '_2.vhdr'];
    elseif i >= 100
        datafile = ['Exp23_0' num2str(i) '_2.vhdr'];
    end
     
    if i == 43
        datafile = ['Exp23_00' num2str(i) '_3.vhdr'];
    elseif i == 6
        datafile = ['Exp23_000' num2str(i) '_2_3.vhdr'];
    elseif i == 50
        datafile = ['Exp23_00' num2str(i) '_222.vhdr'];
    elseif i == 52
        datafile = ['Exp23_00' num2str(i) '_21.vhdr'];
    elseif i == 56
        datafile = ['Keine_Aufzeichnung'];
    elseif i == 63
        datafile = ['Exp23_00' num2str(i) '_23.vhdr'];
    elseif i == 73
        datafile = ['Keine_Aufzeichnung'];
    elseif i == 80
        datafile = ['Exp23_00' num2str(i) '_2_2.vhdr'];
    elseif i == 135
        datafile = ['Exp23_0' num2str(i) '_2_Posner.vhdr'];
    elseif i == 138
        datafile = ['Exp23_0' num2str(i) '_21.vhdr'];
    elseif  i == 24 || i == 47 ||  i == 57 || i == 94   
        datafile = ['Ground_Ref_Vertauscht'];
    elseif i == 4 || i == 34 || i == 103
        datafile = ['Abbruch'];
    end
        
    if isfile([PATH_RAW_DATA datafile]) == 1

 %% Load coded data
            EEG =  pop_loadbv(PATH_RAW_DATA, datafile, [], []);           
            EEG.eog_chans = [33 34];
            EEG.eog_chans_n = length(EEG.eog_chans);
          
        % Define stimulus events
        impevents = {'S 51', 'S 52', 'S 53'}; %!!!!!!!!!!
        correvents = {'S150' 'S160'};
        
        
            % Remove irrelevant tasks
            for j = 1:length(EEG.event)
                if strcmp(EEG.event(j).type, 'S 20')
                    idxStart = j;
                elseif strcmp(EEG.event(j).type, 'S201')
                    idxEnd = j;
                end
            end
            
            if i == 80
              idxEnd = length(EEG.event); 
            end
        
         EEG = pop_select(EEG,'time', [EEG.event(idxStart).latency/1000  EEG.event(idxEnd).latency/1000]); % remove data
        
        % Find indices
        stimidx = find(ismember({EEG.event.type}, impevents));
        
        % Rename stim marker
        rt = [];
        
        for e = 1 : length(stimidx)
            if ismember(EEG.event(stimidx(e)+1).type, correvents) && ... 
                    (EEG.event(stimidx(e)+1).latency - EEG.event(stimidx(e)).latency >= 150) 
        
                % Condition of current trial
                if strcmp(EEG.event(stimidx(e)).type,'S 51')
                    EEG.event(stimidx(e)).Condition = 'PhysId';
                elseif strcmp(EEG.event(stimidx(e)).type,'S 52')
                    EEG.event(stimidx(e)).Condition = 'NameId';
                elseif strcmp(EEG.event(stimidx(e)).type,'S 53')
                    EEG.event(stimidx(e)).Condition = 'NoId';
                end
                
                if strcmp(EEG.event(stimidx(e)+1).type,'S150')
                    EEG.event(stimidx(e)).AnswerKey = 'CorrResp_D';
                elseif strcmp(EEG.event(stimidx(e)+1).type,'S160')
                    EEG.event(stimidx(e)).AnswerKey = 'CorrResp_L';
                end
                
                EEG.event(stimidx(e)).type = 'stim';
                EEG.event(stimidx(e)).RT = EEG.event(stimidx(e)+1).latency - EEG.event(stimidx(e)).latency; 
            end
        end
 
        
 %% Add further varaibles for intra-ind. outlier detection 
a = 0;
b = 0;
for m = 1: length(EEG.event)
    if strcmp(EEG.event(m).type,'S 90') 
a = a + 1;
    end
   if strcmp(EEG.event(m).type,'stim')
b = b + 1;
   end
end

c =(b/a)*100;

if c < 70 || a < 50
ACCOutliers(y) = i;
y = y + 1;
end

        RT1 =[];
           a = 1;
        
           for m = 1: length(EEG.event)
               if strcmp(EEG.event(m).type,'stim')
                   RT1(a) = EEG.event(m).RT;
                   a = a + 1;
               end
           end

        log_RT1 = log(RT1);
        z_log_RT1 = zscore(log_RT1);
        a = 1;

for m = 1: length(EEG.event)    
    if strcmp(EEG.event(m).type,'stim') 
        EEG.event(m).z_RT = z_log_RT1(a);
        a = a + 1;
    end    
end
               
 a = 1;
 b = 1;
 RT2 = [];
 for m =length(EEG.event):-1:1
     if strcmp(EEG.event(m).type,'stim')
         if EEG.event(m).z_RT > 3 || EEG.event(m).z_RT < -3
             EEG.event(m) = [];
             a = a + 1;
         else
             RT2(b) = EEG.event(m).RT;
             b = b +1;
         end
     end
 end
        
    EEG.intraindividuel_outlier = a;
         counter6 = 0;
         
         for m = 1: length(EEG.event)
             if strcmp(EEG.event(m).type,'stim') 
              counter6 = counter6 + 1;
                 if rem(counter6, 2) == 0
                     EEG.event(m).Odd_Even = 2;
                 else
                     EEG.event(m).Odd_Even = 1;
                 end
             end        
         end
        
        
%%  preprocess EEG data  
         chanlocs_orginal = EEG.chanlocs;   
         
         ICA = EEG;
        
       % Resample
         ICA = pop_resample(ICA, 200);
        
        % Bandpass filter data (ERPlab toolbox function)
        EEG = pop_basicfilter(EEG, [1 : EEG.nbchan], 'Cutoff', [0.1, 30], 'Design', 'butter', 'Filter', 'bandpass', 'Order', 2, 'RemoveDC', 'on', 'Boundary', 'boundary');
        ICA = pop_basicfilter(ICA, [1 : EEG.nbchan], 'Cutoff', [1, 30], 'Design', 'butter', 'Filter', 'bandpass', 'Order', 2, 'RemoveDC', 'on', 'Boundary', 'boundary');
        

        % Bad channel detection EEG  on base of filltering
        [EEG, i1] = pop_rejchan(EEG, 'elec', [1 : (EEG.nbchan-EEG.eog_chans_n)], 'threshold', 10, 'norm', 'on', 'measure', 'kurt');
        [EEG, i2] = pop_rejchan(EEG, 'elec', [1 : (EEG.nbchan-EEG.eog_chans_n)], 'threshold', 5, 'norm', 'on', 'measure', 'prob');
        rejected_channels = horzcat(i1, i2);
        EEG.rejected_channels = horzcat(i1, i2);
        EEG.chans_rejected_n = length(horzcat(i1, i2));
        
        csvwrite([PATH_CHANREJECT 'BadChannels_EEG_' num2str(i) '_Posner.csv' ],  rejected_channels)
        
        % Bad channel detection ICA on base of filltering
        [ICA, i3] = pop_rejchan(ICA, 'elec', [1 : (ICA.nbchan-ICA.eog_chans_n)], 'threshold', 10, 'norm', 'on', 'measure', 'kurt');
        [ICA, i4] = pop_rejchan(ICA, 'elec', [1 : (ICA.nbchan-ICA.eog_chans_n)], 'threshold', 5, 'norm', 'on', 'measure', 'prob');
        rejected_channels = horzcat(i3, i4);
        ICA.rejected_channels = horzcat(i3, i4);
        ICA.chans_rejected_n = length(horzcat(i3, i4));
        
        csvwrite([PATH_CHANREJECT 'BadChannels_ICA_' num2str(i) '_Posner.csv' ],  rejected_channels)
             
       % Interpolate data channels
        EEG = pop_interp(EEG, chanlocs_orginal, 'spherical');
        ICA = pop_interp(ICA, chanlocs_orginal, 'spherical');
        
        % re-reference data
       
        EEG = pop_chanedit(EEG, 'append',EEG.nbchan,'changefield',{EEG.nbchan+1 'labels' 'Cz'},'changefield',{EEG.nbchan+1 'sph_theta' '0'},'changefield',{EEG.nbchan+1 'sph_phi' '90'},'changefield',{EEG.nbchan+1 'sph_radius' '85'},'convert',{'sph2all'});
        EEG = pop_chanedit(EEG, 'setref',{'1:34' 'Cz'});
                
        ICA = pop_chanedit(ICA, 'append',ICA.nbchan,'changefield',{ICA.nbchan+1 'labels' 'Cz'},'changefield',{ICA.nbchan+1 'sph_theta' '0'},'changefield',{ICA.nbchan+1 'sph_phi' '90'},'changefield',{ICA.nbchan+1 'sph_radius' '85'},'convert',{'sph2all'});
        ICA = pop_chanedit(ICA, 'setref',{'1:34' 'Cz'});
                
        %average reference
        EEG = pop_reref( EEG, [],'exclude',EEG.eog_chans,'refloc',struct('labels',{'Cz'},'sph_radius',{85},'sph_theta',{0},'sph_phi',{90},'theta',{0},'radius',{0},'X',{5.2047e-15},'Y',{0},'Z',{85},'type',{''},'ref',{'Cz'},'urchan',{[]},'datachan',{0},'sph_theta_besa',{0},'sph_phi_besa',{90}));
        ICA = pop_reref( ICA, [],'exclude',EEG.eog_chans,'refloc',struct('labels',{'Cz'},'sph_radius',{85},'sph_theta',{0},'sph_phi',{90},'theta',{0},'radius',{0},'X',{5.2047e-15},'Y',{0},'Z',{85},'type',{''},'ref',{'Cz'},'urchan',{[]},'datachan',{0},'sph_theta_besa',{0},'sph_phi_besa',{90}));
                  
        % check data rank
        dataRank = sum(eig(cov(double(ICA.data'))) > 1E-6); % 1E-6 follows pop_runica(), changed from 1E-7.
        
        % Epoch both datasets 
        EEG = pop_epoch(EEG, {'stim'}, [-0.2, 1.0], 'newname', [subject '_stimseg'], 'epochinfo', 'yes');
        ICA = pop_epoch(ICA, {'stim'}, [-0.2, 1.0], 'newname', [subject '_stimseg'], 'epochinfo', 'yes');
        
        % Detect artifacted epochs EEG
        
        EEG_segs_orginal_n = size(EEG.data, 3);
        thresh = 1000;
        prob = 5;
        maxr = 5;
        [EEG, rejected_segments_EEG] = pop_autorej(EEG, 'nogui', 'on', 'threshold',thresh, 'startprob', prob, 'maxrej', maxr, 'eegplot','off');
        EEG.segs_rejected_before_ica = length(rejected_segments_EEG);
        
        % Detect artifacted epochs ICA
        
        ICA_segs_orginal_n = size(ICA.data, 3);
        thresh = 1000;
        prob = 5;
        maxr = 5;
        [ICA, rejected_segments_ICA] = pop_autorej(ICA, 'nogui', 'on', 'threshold',thresh, 'startprob', prob, 'maxrej', maxr, 'eegplot','off');
        
        csvwrite([PATH_EPOCHREJECT 'BadSegmentsEEG_' num2str(i) '_Posner.csv' ],  rejected_segments_EEG)
        csvwrite([PATH_EPOCHREJECT 'BadSegmentsICA_' num2str(i) '_Posner.csv' ],  rejected_segments_ICA)
       
        % Check if length of remaining data exceeds 30 minutes
        if ceil(size(EEG.data, 3) * 1.2) >= 1800 %1.2 = seconds/epoch
            % Selecting a random sample of epochs with 30 minutes length
            ICA = pop_select(ICA, 'trial', randsample(1 : size(ICA.data, 3), ceil(1800 / 1.2)));
        end
        
        %% Run ICA on ICA dataset
        ICA = pop_runica(ICA, 'extended', 1, 'interupt', 'on', 'pca', dataRank);  
        ICA.icaact = reshape((ICA.icaweights*ICA.icasphere)*ICA.data(ICA.icachansind,:),[dataRank size(ICA.data,2) size(ICA.data,3)]);
        
        
        % Copy IC weights to highpass filtered data (at 0.1 Hz)
        EEG.icachansind = ICA.icachansind;
        EEG.icaweights =ICA.icaweights;
        EEG.icasphere = ICA.icasphere;
        EEG.icawinv =  ICA.icawinv;
        EEG.icaact = ICA.icaact;
        
        % Save data with ic weights
        EEG = pop_saveset(EEG, 'filename', [num2str(subject) '_Posner_icdata.set'], 'filepath', PATH_ICWEIGHTS, 'check', 'on', 'savemode', 'twofiles');
         
        % Run IClabel
        ICA = iclabel(ICA, 'default');
        ICA.ICout_IClabel = find(ICA.etc.ic_classification.ICLabel.classifications(:, 1) < 0.5);
        EEG.ICout_IClabel = ICA.ICout_IClabel;
        rejected_ICs = length(EEG.ICout_IClabel);
        EEG.n_rejected_ICs  =  rejected_ICs;
        
        
        % Remove bad components detected IC lable
       EEG = pop_subcomp(EEG, EEG.ICout_IClabel, 0);
       csvwrite([PATH_BADICS 'BadICs_' num2str(i) '_Posner.csv' ],  EEG.ICout_IClabel)
    
        %  Automatically reject epochs after running ICA
        EEG_segs_after_n = size(EEG.data, 3);
       [EEG, segs_rej] = pop_autorej(EEG, 'nogui', 'on', 'threshold', 1000, 'startprob', 5, 'maxrej', 5);
       
        EEG.segs_rejected_after_ica = length(segs_rej); 
        EEG.segs_rejected_overall_percentage = (EEG.segs_rejected_before_ica + EEG.segs_rejected_after_ica);
        
        csvwrite([PATH_EPOCHREJECT 'BadSegmentsEEG_after_' num2str(i) '_Posner.csv' ],  segs_rej)

        % Save autocleaned data
        EEG = pop_saveset(EEG, 'filename', [num2str(subject) '_cleaned_Posner.set'], 'filepath', PATH_AUTOCLEANED, 'check', 'on', 'savemode', 'twofiles');
        
    else
        NotExistingFile(z) = i;
        z = z + 1;
    end
end
csvwrite([PATH_MAIN 'Not_existing_files_Posner.csv' ],  NotExistingFile)
save([PATH_MAIN 'Interindividuell_ACC_outliers_Posner.mat' ],  'ACCOutliers')

%% ERP 

    p = 1;
    r = 0;
    NotExistingFile_ERP = [];
    nSubjects = 151;
    count_trials = [];
    
       ACC_Out = load([PATH_MAIN 'Interindividuell_ACC_outliers_Posner.mat']);
    
        for i=1:nSubjects
            % Load data
            subject = num2str(i);
            datafile = [num2str(i) '_cleaned_Posner.set'];
              
            if isfile([PATH_AUTOCLEANED datafile]) == 1  && ~ismember(i, ACC_Out.ACCOutliers)
                EEG = pop_loadset('filename', [subject '_cleaned_Posner.set'], 'filepath', PATH_AUTOCLEANED, 'loadmode', 'all');
             
            % Recode event types for ERPlab
                for j = 1:length(EEG.event)
                    if strcmp(EEG.event(j).type, 'stim')
                        EEG.event(j).type = 1;
                    end
                end    
                
              %odd even split for reliability
                for j = 1:length(EEG.event)
                    if isempty(EEG.event(j).Odd_Even) == 0
                        if EEG.event(j).Odd_Even == 2 &&  EEG.event(j).type == 1
                            EEG.event(j).type = 11;
                        end
                    end
                end
                
                a = 0;
                b = 0;
                
                for t = 1:length(EEG.event)
                    if isempty(EEG.event(t).Odd_Even) == 0
                        if  EEG.event(t).type == 1
                            a = a + 1;
                        elseif   EEG.event(t).type == 11
                            b = b + 1;
                        end
                    end
                end
                
                r = r + 1;
                count_trials(r,1) = i; 
                count_trials(r,2) = a;
                count_trials(r,3) = b;
                
                % Remove response markers
                EEG = eeg_checkset(EEG, 'eventconsistency');
                
                % Recreate continuous EEG
                EEG = pop_epoch2continuous(EEG,'Warning','off');
                
                % Create EventList for ERPLab
                EEG  = pop_creabasiceventlist(EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } );
                
                % Create Bins for different conditions
                EEG  = pop_binlister(EEG , 'BDF', [PATH_LIST '\bin_list_Exp23_speed_tasks.txt'], 'IndexEL',  1, 'SendEL2', 'Workspace&EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
                EEG.setname = ['Posner_' num2str(i) '_bin'];
                
                % Epoch data
                EEG = pop_epochbin( EEG , [-200.0  1000.0],  [ -200 0]);
                EEG.setname = ['Posner_' num2str(i) '_bin_epoch'];
                
                % Compute ERPs for the different bins
                ERP = pop_averager( EEG , 'Criterion', 'all', 'ExcludeBoundary', 'off', 'SEM', 'on' );
                ERP.erpname = ['Posner_' num2str(i) '_bin_average'];
                
                % Save ERP set to
                ERP = pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', ['Posner_' num2str(i) '.erp'], 'filepath', PATH_ERP);
            else
                NotExistingFile_ERP(p) = i;
                p = p + 1;
            end   
        end

        csvwrite([PATH_MAIN 'Posner_count_trials_in_bnis.csv'], count_trials)
        
