clear all
clc
eeglab

%%
PATH_MAIN = 'C:/enter/your/path/to/the/folders/';

PATH_RAW_DATA = 'C:/enter/your/path/to/the/raw/data/';

PATH_ICWEIGHTS = [PATH_MAIN, 'icweights/'];
PATH_AUTOCLEANED = [PATH_MAIN, 'autocleaned/'];
PATH_ADJUSTOUT = [PATH_MAIN, 'adjust_log/']; 
PATH_CHANREJECT = [PATH_MAIN, 'badchannels/']; 
PATH_EPOCHREJECT = [PATH_MAIN, 'badepochs/']; 
PATH_BADICS = [PATH_MAIN, 'badics/']; 

PATH_ERP = [PATH_MAIN, 'ERP/']; 
PATH_LIST = 'C:/enter/your/path/to/the/bin list/';

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
 elseif  i == 24 || i == 47 ||  i == 57 || i == 94   % MZP 2
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
        impevents = {'S 53', 'S 54', 'S 55', 'S 56', 'S 57', 'S 58', ...
           'S153', 'S154', 'S155', 'S156', 'S157', 'S158' };
        correvents = {'S230' 'S240'};
        setevents = {'S 63', 'S 64', 'S 65', 'S 66', 'S 67', 'S 68',...
            'S163', 'S164', 'S165', 'S166', 'S167', 'S168'};
        
        seteventsBL1 = {'S 63', 'S 64', 'S 65', 'S 66', 'S 67', 'S 68'};
        seteventsBL2 = {'S163', 'S164', 'S165', 'S166', 'S167', 'S168'};
        
        % Remove irrelevant tasks
        for j = 1:length(EEG.event)
            if strcmp(EEG.event(j).type, 'S 22')
                idxStart = j;
            elseif strcmp(EEG.event(j).type, 'S 23')
                idxEnd = j;
            end
        end
        
        if i == 85
            idxEnd = 3612;
            idxStart = 5;
        end
        
        
        if i == 144
            idxEnd = 1566;
            idxStart = 4;
        end

                 
        EEG = pop_select(EEG,'time', [EEG.event(idxStart).latency/1000 EEG.event(idxEnd).latency/1000]); % remove data
 
     
        
        % Find indices
        stimidx = find(ismember({EEG.event.type}, impevents));
        
         % Rename stim marker  
         
         for e = 1: length(EEG.event)
             if ismember(EEG.event(e).type,setevents)
                 if ismember(EEG.event(e).type,seteventsBL1)
                     EEG.event(e).MemSetSize = 3;
                 else
                     EEG.event(e).MemSetSize = 5;
                 end
             end
         end

f = 1;
for e = 1 : length(stimidx)
       if ismember(EEG.event(stimidx(e)+1).type, correvents)  && ...
            (EEG.event(stimidx(e)+1).latency - EEG.event(stimidx(e)).latency >= 150)
        if strcmp(EEG.event(stimidx(e)).type,'S 53') ||  strcmp(EEG.event(stimidx(e)).type,'S 54')
            if strcmp(EEG.event(stimidx(e)).type,'S 53')
                EEG.event(stimidx(e)).Condition = 'RS_MemSet3_Up_NoMatch_1Distr';
                EEG.event(stimidx(e)).MemSetSize = 3;
                EEG.event(stimidx(e)).MatchCond = 1;
                EEG.event(stimidx(e)).DistrCond = 1;
                EEG.event(stimidx(e)).trial = f;
                EEG.event(stimidx(e)).UpdatingSteps = 1;
                EEG.event(stimidx(e)-2).type = 'stim';
                EEG.event(stimidx(e)-2).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-2).UpdatingPos = 1;
                EEG.event(stimidx(e)-2).trial = f;
                EEG.event(stimidx(e)-2).UpdatingSteps = 1;
                EEG.event(stimidx(e)-4).type = 'stim';
                EEG.event(stimidx(e)-4).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-4).MemPos = 3;
                EEG.event(stimidx(e)-4).trial = f;
                EEG.event(stimidx(e)-4).UpdatingSteps = 1;
                EEG.event(stimidx(e)-6).type = 'stim';
                EEG.event(stimidx(e)-6).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-6).MemPos = 2;
                EEG.event(stimidx(e)-6).trial = f;
                EEG.event(stimidx(e)-6).UpdatingSteps = 1;
                EEG.event(stimidx(e)-8).type = 'stim';
                EEG.event(stimidx(e)-8).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-8).MemPos = 1;
                EEG.event(stimidx(e)-8).trial = f;
                EEG.event(stimidx(e)-8).UpdatingSteps = 1;
            elseif strcmp(EEG.event(stimidx(e)).type,'S 54')
                EEG.event(stimidx(e)).Condition = 'RS_MemSet3_Up_Match_1Distr';
                EEG.event(stimidx(e)).MemSetSize = 3;
                EEG.event(stimidx(e)).MatchCond = 2;
                EEG.event(stimidx(e)).DistrCond = 1;
                EEG.event(stimidx(e)).trial = f;
                EEG.event(stimidx(e)).UpdatingSteps = 1;
                EEG.event(stimidx(e)-2).type = 'stim';
                EEG.event(stimidx(e)-2).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-2).UpdatingPos = 1;
                EEG.event(stimidx(e)-2).trial = f;
                EEG.event(stimidx(e)-2).UpdatingSteps = 1;
                EEG.event(stimidx(e)-4).type = 'stim';
                EEG.event(stimidx(e)-4).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-4).MemPos = 3;
                EEG.event(stimidx(e)-4).trial = f;
                EEG.event(stimidx(e)-4).UpdatingSteps = 1;
                EEG.event(stimidx(e)-6).type = 'stim';
                EEG.event(stimidx(e)-6).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-6).MemPos = 2;
                EEG.event(stimidx(e)-6).trial = f;
                EEG.event(stimidx(e)-6).UpdatingSteps = 1;
                EEG.event(stimidx(e)-8).type = 'stim';
                EEG.event(stimidx(e)-8).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-8).MemPos = 1;
                EEG.event(stimidx(e)-8).trial = f;
                EEG.event(stimidx(e)-8).UpdatingSteps = 1;
            end
            EEG.event(stimidx(e)).Cond_Factor = 1;
        elseif strcmp(EEG.event(stimidx(e)).type,'S 55') || strcmp(EEG.event(stimidx(e)).type,'S 56')
            if  strcmp(EEG.event(stimidx(e)).type,'S 55')
                EEG.event(stimidx(e)).Condition = 'RS_MemSet3_Up_NoMatch_2Distr';
                EEG.event(stimidx(e)).MemSetSize = 3;
                EEG.event(stimidx(e)).MatchCond = 1;
                EEG.event(stimidx(e)).DistrCond = 2;
                EEG.event(stimidx(e)).trial = f;
                EEG.event(stimidx(e)).UpdatingSteps = 2;
                EEG.event(stimidx(e)-2).type = 'stim';
                EEG.event(stimidx(e)-2).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-2).UpdatingPos = 2;
                EEG.event(stimidx(e)-2).trial = f;
                EEG.event(stimidx(e)-2).UpdatingSteps = 2;
                EEG.event(stimidx(e)-4).type = 'stim';
                EEG.event(stimidx(e)-4).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-4).UpdatingPos = 1;
                EEG.event(stimidx(e)-4).trial = f;
                EEG.event(stimidx(e)-4).UpdatingSteps = 2;
                EEG.event(stimidx(e)-6).type = 'stim';
                EEG.event(stimidx(e)-6).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-6).MemPos = 3;
                EEG.event(stimidx(e)-6).trial = f;
                EEG.event(stimidx(e)-6).UpdatingSteps = 2;
                EEG.event(stimidx(e)-8).type = 'stim';
                EEG.event(stimidx(e)-8).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-8).MemPos = 2;
                EEG.event(stimidx(e)-8).trial = f;
                EEG.event(stimidx(e)-8).UpdatingSteps = 2;
                EEG.event(stimidx(e)-10).type = 'stim';
                EEG.event(stimidx(e)-10).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-10).MemPos = 1;
                EEG.event(stimidx(e)-10).trial = f;
                EEG.event(stimidx(e)-10).UpdatingSteps = 2;
            elseif strcmp(EEG.event(stimidx(e)).type,'S 56')
                EEG.event(stimidx(e)).Condition = 'RS_MemSet3_Up_Match_2Distr';
                EEG.event(stimidx(e)).MemSetSize = 3;
                EEG.event(stimidx(e)).MatchCond = 2;
                EEG.event(stimidx(e)).DistrCond = 2;
                EEG.event(stimidx(e)).trial = f;
                EEG.event(stimidx(e)).UpdatingSteps = 2;
                EEG.event(stimidx(e)-2).type = 'stim';
                EEG.event(stimidx(e)-2).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-2).UpdatingPos = 2;
                EEG.event(stimidx(e)-2).trial = f;
                EEG.event(stimidx(e)-2).UpdatingSteps = 2;
                EEG.event(stimidx(e)-4).type = 'stim';
                EEG.event(stimidx(e)-4).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-4).UpdatingPos = 1;
                EEG.event(stimidx(e)-4).trial = f;
                EEG.event(stimidx(e)-4).UpdatingSteps = 2;
                EEG.event(stimidx(e)-6).type = 'stim';
                EEG.event(stimidx(e)-6).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-6).MemPos = 3;
                EEG.event(stimidx(e)-6).trial = f;
                EEG.event(stimidx(e)-6).UpdatingSteps = 2;
                EEG.event(stimidx(e)-8).type = 'stim';
                EEG.event(stimidx(e)-8).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-8).MemPos = 2;
                EEG.event(stimidx(e)-8).trial = f;
                EEG.event(stimidx(e)-8).UpdatingSteps = 2;
                EEG.event(stimidx(e)-10).type = 'stim';
                EEG.event(stimidx(e)-10).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-10).MemPos = 1;
                EEG.event(stimidx(e)-10).trial = f;
                EEG.event(stimidx(e)-10).UpdatingSteps = 2;
            end
            EEG.event(stimidx(e)).Cond_Factor = 2;
        elseif  strcmp(EEG.event(stimidx(e)).type,'S 57') || strcmp(EEG.event(stimidx(e)).type,'S 58')
            if  strcmp(EEG.event(stimidx(e)).type,'S 57')
                EEG.event(stimidx(e)).Condition = 'RS_MemSet3_Up_NoMatch_3Distr';
                EEG.event(stimidx(e)).MemSetSize = 3;
                EEG.event(stimidx(e)).MatchCond = 1;
                EEG.event(stimidx(e)).DistrCond = 3;
                EEG.event(stimidx(e)).trial = f;
                EEG.event(stimidx(e)).UpdatingSteps = 3;
                EEG.event(stimidx(e)-2).type = 'stim';
                EEG.event(stimidx(e)-2).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-2).UpdatingPos = 3;
                EEG.event(stimidx(e)-2).trial = f;
                EEG.event(stimidx(e)-2).UpdatingSteps = 3;
                EEG.event(stimidx(e)-4).type = 'stim';
                EEG.event(stimidx(e)-4).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-4).UpdatingPos = 2;
                EEG.event(stimidx(e)-4).trial = f;
                EEG.event(stimidx(e)-4).UpdatingSteps = 3;
                EEG.event(stimidx(e)-6).type = 'stim';
                EEG.event(stimidx(e)-6).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-6).UpdatingPos = 1;
                EEG.event(stimidx(e)-6).trial = f;
                EEG.event(stimidx(e)-6).UpdatingSteps = 3;
                EEG.event(stimidx(e)-8).type = 'stim';
                EEG.event(stimidx(e)-8).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-8).MemPos = 3;
                EEG.event(stimidx(e)-8).trial = f;
                EEG.event(stimidx(e)-8).UpdatingSteps = 3;
                EEG.event(stimidx(e)-10).type = 'stim';
                EEG.event(stimidx(e)-10).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-10).MemPos = 2;
                EEG.event(stimidx(e)-10).trial = f;
                EEG.event(stimidx(e)-10).UpdatingSteps = 3;
                EEG.event(stimidx(e)-12).type = 'stim';
                EEG.event(stimidx(e)-12).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-12).MemPos = 1;
                EEG.event(stimidx(e)-12).trial = f;
                EEG.event(stimidx(e)-12).UpdatingSteps = 3;
            elseif strcmp(EEG.event(stimidx(e)).type,'S 58')
                EEG.event(stimidx(e)).Condition = 'RS_MemSet3_Up_Match_3Distr';
                EEG.event(stimidx(e)).MemSetSize = 3;
                EEG.event(stimidx(e)).MatchCond = 2;
                EEG.event(stimidx(e)).DistrCond = 3;
                EEG.event(stimidx(e)).trial = f;
                EEG.event(stimidx(e)).UpdatingSteps = 3;
                EEG.event(stimidx(e)-2).type = 'stim';
                EEG.event(stimidx(e)-2).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-2).UpdatingPos = 3;
                EEG.event(stimidx(e)-2).trial = f;
                EEG.event(stimidx(e)-2).UpdatingSteps = 3;
                EEG.event(stimidx(e)-4).type = 'stim';
                EEG.event(stimidx(e)-4).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-4).UpdatingPos = 2;
                EEG.event(stimidx(e)-4).trial = f;
                EEG.event(stimidx(e)-4).UpdatingSteps = 3;
                EEG.event(stimidx(e)-6).type = 'stim';
                EEG.event(stimidx(e)-6).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-6).UpdatingPos = 1;
                EEG.event(stimidx(e)-6).trial = f;
                EEG.event(stimidx(e)-6).UpdatingSteps = 3;
                EEG.event(stimidx(e)-8).type = 'stim';
                EEG.event(stimidx(e)-8).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-8).MemPos = 3;
                EEG.event(stimidx(e)-8).trial = f;
                EEG.event(stimidx(e)-8).UpdatingSteps = 3;
                EEG.event(stimidx(e)-10).type = 'stim';
                EEG.event(stimidx(e)-10).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-10).MemPos = 2;
                EEG.event(stimidx(e)-10).trial = f;
                EEG.event(stimidx(e)-10).UpdatingSteps = 3;
                EEG.event(stimidx(e)-12).type = 'stim';
                EEG.event(stimidx(e)-12).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-12).MemPos = 1;
                EEG.event(stimidx(e)-12).trial = f;
                EEG.event(stimidx(e)-12).UpdatingSteps = 3;
            end
            EEG.event(stimidx(e)).Cond_Factor = 3;
        elseif strcmp(EEG.event(stimidx(e)).type,'S153') ||  strcmp(EEG.event(stimidx(e)).type,'S154')
            if strcmp(EEG.event(stimidx(e)).type,'S153')
                EEG.event(stimidx(e)).Condition = 'RS_MemSet5_Up_NoMatch_1Distr';
                EEG.event(stimidx(e)).MemSetSize = 5;
                EEG.event(stimidx(e)).MatchCond = 1;
                EEG.event(stimidx(e)).DistrCond = 1;
                EEG.event(stimidx(e)).trial = f;
                EEG.event(stimidx(e)).UpdatingSteps = 1;
                EEG.event(stimidx(e)-2).type = 'stim';
                EEG.event(stimidx(e)-2).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-2).UpdatingPos = 1;
                EEG.event(stimidx(e)-2).trial = f;
                EEG.event(stimidx(e)-2).UpdatingSteps = 1;
                EEG.event(stimidx(e)-4).type = 'stim';
                EEG.event(stimidx(e)-4).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-4).MemPos = 5;
                EEG.event(stimidx(e)-4).trial = f;
                EEG.event(stimidx(e)-4).UpdatingSteps = 1;
                EEG.event(stimidx(e)-6).type = 'stim';
                EEG.event(stimidx(e)-6).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-6).MemPos = 4;
                EEG.event(stimidx(e)-6).trial = f;
                EEG.event(stimidx(e)-6).UpdatingSteps = 1;
                EEG.event(stimidx(e)-8).type = 'stim';
                EEG.event(stimidx(e)-8).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-8).MemPos = 3;
                EEG.event(stimidx(e)-8).trial = f;
                EEG.event(stimidx(e)-8).UpdatingSteps = 1;
                EEG.event(stimidx(e)-10).type = 'stim';
                EEG.event(stimidx(e)-10).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-10).MemPos = 2;
                EEG.event(stimidx(e)-10).trial = f;
                EEG.event(stimidx(e)-10).UpdatingSteps = 1;
                EEG.event(stimidx(e)-12).type = 'stim';
                EEG.event(stimidx(e)-12).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-12).MemPos = 1;
                EEG.event(stimidx(e)-12).trial = f;
                EEG.event(stimidx(e)-12).UpdatingSteps = 1;
            elseif strcmp(EEG.event(stimidx(e)).type,'S154')
                EEG.event(stimidx(e)).Condition = 'RS_MemSet5_Up_Match_1Distr';
                EEG.event(stimidx(e)).MemSetSize = 5;
                EEG.event(stimidx(e)).MatchCond = 2;
                EEG.event(stimidx(e)).DistrCond = 1;
                EEG.event(stimidx(e)).trial = f;
                EEG.event(stimidx(e)).UpdatingSteps = 1;
                EEG.event(stimidx(e)-2).type = 'stim';
                EEG.event(stimidx(e)-2).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-2).UpdatingPos = 1;
                EEG.event(stimidx(e)-2).trial = f;
                EEG.event(stimidx(e)-2).UpdatingSteps = 1;
                EEG.event(stimidx(e)-4).type = 'stim';
                EEG.event(stimidx(e)-4).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-4).MemPos = 5;
                EEG.event(stimidx(e)-4).trial = f;
                EEG.event(stimidx(e)-4).UpdatingSteps = 1;
                EEG.event(stimidx(e)-6).type = 'stim';
                EEG.event(stimidx(e)-6).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-6).MemPos = 4;
                EEG.event(stimidx(e)-6).trial = f;
                EEG.event(stimidx(e)-6).UpdatingSteps = 1;
                EEG.event(stimidx(e)-8).type = 'stim';
                EEG.event(stimidx(e)-8).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-8).MemPos = 3;
                EEG.event(stimidx(e)-8).trial = f;
                EEG.event(stimidx(e)-8).UpdatingSteps = 1;
                EEG.event(stimidx(e)-10).type = 'stim';
                EEG.event(stimidx(e)-10).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-10).MemPos = 2;
                EEG.event(stimidx(e)-10).trial = f;
                EEG.event(stimidx(e)-10).UpdatingSteps = 1;
                EEG.event(stimidx(e)-12).type = 'stim';
                EEG.event(stimidx(e)-12).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-12).MemPos = 1;
                EEG.event(stimidx(e)-12).trial = f;
                EEG.event(stimidx(e)-12).UpdatingSteps = 1;
            end
            EEG.event(stimidx(e)).Cond_Factor = 4;
        elseif strcmp(EEG.event(stimidx(e)).type,'S155') || strcmp(EEG.event(stimidx(e)).type,'S156')
            if  strcmp(EEG.event(stimidx(e)).type,'S155')
                EEG.event(stimidx(e)).Condition = 'RS_MemSet5_Up_NoMatch_2Distr';
                EEG.event(stimidx(e)).MemSetSize = 5;
                EEG.event(stimidx(e)).MatchCond = 1;
                EEG.event(stimidx(e)).DistrCond = 2;
                EEG.event(stimidx(e)).trial = f;
                EEG.event(stimidx(e)).UpdatingSteps = 2;
                EEG.event(stimidx(e)-2).type = 'stim';
                EEG.event(stimidx(e)-2).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-2).UpdatingPos = 2;
                EEG.event(stimidx(e)-2).trial = f;
                EEG.event(stimidx(e)-2).UpdatingSteps = 2;
                EEG.event(stimidx(e)-4).type = 'stim';
                EEG.event(stimidx(e)-4).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-4).UpdatingPos = 1;
                EEG.event(stimidx(e)-4).trial = f;
                EEG.event(stimidx(e)-4).UpdatingSteps = 2;
                EEG.event(stimidx(e)-6).type = 'stim';
                EEG.event(stimidx(e)-6).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-6).MemPos = 5;
                EEG.event(stimidx(e)-6).trial = f;
                EEG.event(stimidx(e)-6).UpdatingSteps = 2;
                EEG.event(stimidx(e)-8).type = 'stim';
                EEG.event(stimidx(e)-8).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-8).MemPos = 4;
                EEG.event(stimidx(e)-8).trial = f;
                EEG.event(stimidx(e)-8).UpdatingSteps = 2;
                EEG.event(stimidx(e)-10).type = 'stim';
                EEG.event(stimidx(e)-10).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-10).MemPos = 3;
                EEG.event(stimidx(e)-10).trial = f;
                EEG.event(stimidx(e)-10).UpdatingSteps = 2;
                EEG.event(stimidx(e)-12).type = 'stim';
                EEG.event(stimidx(e)-12).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-12).MemPos = 2;
                EEG.event(stimidx(e)-12).trial = f;
                EEG.event(stimidx(e)-12).UpdatingSteps = 2;
                EEG.event(stimidx(e)-14).type = 'stim';
                EEG.event(stimidx(e)-14).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-14).MemPos = 1;
                EEG.event(stimidx(e)-14).trial = f;
                EEG.event(stimidx(e)-14).UpdatingSteps = 2;
            elseif strcmp(EEG.event(stimidx(e)).type,'S156')
                EEG.event(stimidx(e)).Condition = 'RS_MemSet5_Up_Match_2Distr';
                EEG.event(stimidx(e)).MemSetSize = 5;
                EEG.event(stimidx(e)).MatchCond = 2;
                EEG.event(stimidx(e)).DistrCond = 2;
                EEG.event(stimidx(e)).trial = f;
                EEG.event(stimidx(e)).UpdatingSteps = 2;
                EEG.event(stimidx(e)-2).type = 'stim';
                EEG.event(stimidx(e)-2).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-2).UpdatingPos = 2;
                EEG.event(stimidx(e)-2).trial = f;
                EEG.event(stimidx(e)-2).UpdatingSteps = 2;
                EEG.event(stimidx(e)-4).type = 'stim';
                EEG.event(stimidx(e)-4).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-4).UpdatingPos = 1;
                EEG.event(stimidx(e)-4).trial = f;
                EEG.event(stimidx(e)-4).UpdatingSteps = 2;
                EEG.event(stimidx(e)-6).type = 'stim';
                EEG.event(stimidx(e)-6).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-6).MemPos = 5;
                EEG.event(stimidx(e)-6).trial = f;
                EEG.event(stimidx(e)-6).UpdatingSteps = 2;
                EEG.event(stimidx(e)-8).type = 'stim';
                EEG.event(stimidx(e)-8).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-8).MemPos = 4;
                EEG.event(stimidx(e)-8).trial = f;
                EEG.event(stimidx(e)-8).UpdatingSteps = 2;
                EEG.event(stimidx(e)-10).type = 'stim';
                EEG.event(stimidx(e)-10).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-10).MemPos = 3;
                EEG.event(stimidx(e)-10).trial = f;
                EEG.event(stimidx(e)-10).UpdatingSteps = 2;
                EEG.event(stimidx(e)-12).type = 'stim';
                EEG.event(stimidx(e)-12).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-12).MemPos = 2;
                EEG.event(stimidx(e)-12).trial = f;
                EEG.event(stimidx(e)-12).UpdatingSteps = 2;
                EEG.event(stimidx(e)-14).type = 'stim';
                EEG.event(stimidx(e)-14).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-14).MemPos = 1;
                EEG.event(stimidx(e)-14).trial = f;
                EEG.event(stimidx(e)-14).UpdatingSteps = 2;
            end
            EEG.event(stimidx(e)).Cond_Factor = 5;
        elseif  strcmp(EEG.event(stimidx(e)).type,'S157') || strcmp(EEG.event(stimidx(e)).type,'S158')
            if  strcmp(EEG.event(stimidx(e)).type,'S157')
                EEG.event(stimidx(e)).Condition = 'RS_MemSet5_Up_NoMatch_3Distr';
                EEG.event(stimidx(e)).MemSetSize = 5;
                EEG.event(stimidx(e)).MatchCond = 1;
                EEG.event(stimidx(e)).DistrCond = 3;
                EEG.event(stimidx(e)).trial = f;
                EEG.event(stimidx(e)).UpdatingSteps = 3;
                EEG.event(stimidx(e)-2).type = 'stim';
                EEG.event(stimidx(e)-2).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-2).UpdatingPos = 3;
                EEG.event(stimidx(e)-2).trial = f;
                EEG.event(stimidx(e)-2).UpdatingSteps = 3;
                EEG.event(stimidx(e)-4).type = 'stim';
                EEG.event(stimidx(e)-4).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-4).UpdatingPos = 2;
                EEG.event(stimidx(e)-4).trial = f;
                EEG.event(stimidx(e)-4).UpdatingSteps = 3;
                EEG.event(stimidx(e)-6).type = 'stim';
                EEG.event(stimidx(e)-6).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-6).UpdatingPos = 1;
                EEG.event(stimidx(e)-6).trial = f;
                EEG.event(stimidx(e)-6).UpdatingSteps = 3;
                EEG.event(stimidx(e)-8).type = 'stim';
                EEG.event(stimidx(e)-8).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-8).MemPos = 5;
                EEG.event(stimidx(e)-8).trial = f;
                EEG.event(stimidx(e)-8).UpdatingSteps = 3;
                EEG.event(stimidx(e)-10).type = 'stim';
                EEG.event(stimidx(e)-10).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-10).MemPos = 4;
                EEG.event(stimidx(e)-10).trial = f;
                EEG.event(stimidx(e)-10).UpdatingSteps = 3;
                EEG.event(stimidx(e)-12).type = 'stim';
                EEG.event(stimidx(e)-12).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-12).MemPos = 3;
                EEG.event(stimidx(e)-12).trial = f;
                EEG.event(stimidx(e)-12).UpdatingSteps = 3;
                EEG.event(stimidx(e)-14).type = 'stim';
                EEG.event(stimidx(e)-14).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-14).MemPos = 2;
                EEG.event(stimidx(e)-14).trial = f;
                EEG.event(stimidx(e)-14).UpdatingSteps = 3;
                EEG.event(stimidx(e)-16).type = 'stim';
                EEG.event(stimidx(e)-16).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-16).MemPos = 1;
                EEG.event(stimidx(e)-16).trial = f;
                EEG.event(stimidx(e)-16).UpdatingSteps = 3;
            elseif strcmp(EEG.event(stimidx(e)).type,'S158')
                EEG.event(stimidx(e)).Condition = 'RS_MemSet5_Up_Match_3Distr';
                EEG.event(stimidx(e)).MemSetSize = 5;
                EEG.event(stimidx(e)).MatchCond = 2;
                EEG.event(stimidx(e)).DistrCond = 3;
                EEG.event(stimidx(e)).trial = f;
                EEG.event(stimidx(e)).UpdatingSteps = 3;
                EEG.event(stimidx(e)-2).type = 'stim';
                EEG.event(stimidx(e)-2).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-2).UpdatingPos = 3;
                EEG.event(stimidx(e)-2).trial = f;
                EEG.event(stimidx(e)-2).UpdatingSteps = 3;
                EEG.event(stimidx(e)-4).type = 'stim';
                EEG.event(stimidx(e)-4).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-4).UpdatingPos = 2;
                EEG.event(stimidx(e)-4).trial = f;
                EEG.event(stimidx(e)-4).UpdatingSteps = 3;
                EEG.event(stimidx(e)-6).type = 'stim';
                EEG.event(stimidx(e)-6).type_descr = 'upd_stim';
                EEG.event(stimidx(e)-6).UpdatingPos = 1;
                EEG.event(stimidx(e)-6).trial = f;
                EEG.event(stimidx(e)-6).UpdatingSteps = 3;
                EEG.event(stimidx(e)-8).type = 'stim';
                EEG.event(stimidx(e)-8).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-8).MemPos = 5;
                EEG.event(stimidx(e)-8).trial = f;
                EEG.event(stimidx(e)-8).UpdatingSteps = 3;
                EEG.event(stimidx(e)-10).type = 'stim';
                EEG.event(stimidx(e)-10).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-10).MemPos = 4;
                EEG.event(stimidx(e)-10).trial = f;
                EEG.event(stimidx(e)-10).UpdatingSteps = 3;
                EEG.event(stimidx(e)-12).type = 'stim';
                EEG.event(stimidx(e)-12).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-12).MemPos = 3;
                EEG.event(stimidx(e)-12).trial = f;
                EEG.event(stimidx(e)-12).UpdatingSteps = 3;
                EEG.event(stimidx(e)-14).type = 'stim';
                EEG.event(stimidx(e)-14).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-14).MemPos = 2;
                EEG.event(stimidx(e)-14).trial = f;
                EEG.event(stimidx(e)-14).UpdatingSteps = 3;
                EEG.event(stimidx(e)-16).type = 'stim';
                EEG.event(stimidx(e)-16).type_descr = 'mem_stim';
                EEG.event(stimidx(e)-16).MemPos = 1;
                EEG.event(stimidx(e)-16).trial = f;
                EEG.event(stimidx(e)-16).UpdatingSteps = 3;
            end
            EEG.event(stimidx(e)).Cond_Factor = 6;
        end
        if strcmp(EEG.event(stimidx(e)+1).type,'S230')
            EEG.event(stimidx(e)).AnswerKey = 'CorrResp_left';
        elseif strcmp(EEG.event(stimidx(e)+1).type,'S240')
            EEG.event(stimidx(e)).AnswerKey = 'CorrResp_right';
        end
        EEG.event(stimidx(e)).RT = EEG.event(stimidx(e)+1).latency - EEG.event(stimidx(e)).latency;
        f = f + 1;
    end
end

f = 1;
for e = 1:length(EEG.event)
    if e > 1
        if strcmp(EEG.event(e).type,correvents(1)) && isempty(EEG.event(e-1).RT) == 0 || ...
                strcmp(EEG.event(e).type,correvents(2)) && isempty(EEG.event(e-1).RT) == 0
            EEG.event_resp(f) = EEG.event(e-1);
            f = f + 1;
        end
    end
end

%%
% intraindividuelle Ausreiﬂeranalyse
a = 0;
for m = 1: length(EEG.event)
    if ismember(EEG.event(m).type,impevents)   
a = a + 1;
    end
end

c =(length(EEG.event_resp)/a)*100;

if c < 70 || a < 90
ACCOutliers(y) = i;
y = y + 1;
end


       Cond_Factor = 6; 
        RT1 =[];
        RT2 =[];
        RT3 =[];
        RT4 =[];
        RT5 =[];
        RT6 =[];
        RT7 =[];

           a = 1;
           b = 1;
           c = 1;
           d = 1;
           e = 1;
           f = 1;
           g = 1;
           
           for m = 1: length(EEG.event_resp)
               if  EEG.event_resp(m).Cond_Factor == 1
                   RT1(a) = EEG.event_resp(m).RT;
                   a = a + 1;
               elseif  EEG.event_resp(m).Cond_Factor == 2
                   RT2(b) = EEG.event_resp(m).RT;
                   b = b + 1;
               elseif  EEG.event_resp(m).Cond_Factor == 3
                   RT3(c) = EEG.event_resp(m).RT;
                   c = c + 1;
               elseif  EEG.event_resp(m).Cond_Factor == 4
                   RT4(d) = EEG.event_resp(m).RT;
                   d = d + 1;
               elseif  EEG.event_resp(m).Cond_Factor == 5
                   RT5(e) = EEG.event_resp(m).RT;
                   e = e + 1;
               elseif EEG.event_resp(m).Cond_Factor == 6
                   RT6(f) = EEG.event_resp(m).RT;
                   f = f + 1;
               end
               RT7(g) = EEG.event_resp(m).RT;
               g = g + 1;
           end



log_RT1 = log(RT1);
log_RT2 = log(RT2);
log_RT3 = log(RT3);
log_RT4 = log(RT4);
log_RT5 = log(RT5);
log_RT6 = log(RT6);
log_RT7 = log(RT7);

        z_RT1 = zscore(log_RT1);
        z_RT2 = zscore(log_RT2);
        z_RT3 = zscore(log_RT3);
        z_RT4 = zscore(log_RT4);
        z_RT5 = zscore(log_RT5);
        z_RT6 = zscore(log_RT6);
        z_RT7 = zscore(log_RT7);
        
        a = 1;
        b = 1;
        c = 1;          
        d = 1;
        e = 1;
        f = 1;
        g = 1;

for m = 1: length(EEG.event_resp)    
    if  EEG.event_resp(m).Cond_Factor == 1
        EEG.event_resp(m).z_RT_cond = z_RT1(a);
        a = a + 1;
    elseif  EEG.event_resp(m).Cond_Factor == 2
        EEG.event_resp(m).z_RT_cond = z_RT2(b);
        b = b + 1;
    elseif  EEG.event_resp(m).Cond_Factor == 3
        EEG.event_resp(m).z_RT_cond = z_RT3(c);
        c = c + 1;
    elseif  EEG.event_resp(m).Cond_Factor == 4
        EEG.event_resp(m).z_RT_cond = z_RT4(d);
        d = d + 1;
    elseif  EEG.event_resp(m).Cond_Factor == 5
        EEG.event_resp(m).z_RT_cond = z_RT5(e);
        e = e + 1;
    elseif  EEG.event_resp(m).Cond_Factor == 6
        EEG.event_resp(m).z_RT_cond = z_RT6(f);
        f = f + 1;
    end    
end

for m = 1: length(EEG.event_resp)    
        EEG.event_resp(m).z_RT = z_RT7(g);
        g = g + 1; 
end

outlier_trial = [];
h = 1;
for m = 1: length(EEG.event_resp)    
    if  EEG.event_resp(m).z_RT > 3 || EEG.event_resp(m).z_RT < -3 
        outlier_trial(h) = EEG.event_resp(m).trial;
        h = h + 1; 
    end
end


        for m =length(EEG.event):-1:1
           if ismember(EEG.event(m).trial,outlier_trial)
                EEG.event(m) = [];
           end
        end
        
        for m =length(EEG.event_resp):-1:1
            if ismember(EEG.event_resp(m).trial,outlier_trial)
                EEG.event_resp(m) = [];
            end
        end
        
        
    EEG.intraindividuel_outlier = length(outlier_trial);
       
%%
% Renumber the trails 
         
for e = 1:length(EEG.event_resp)
    EEG.event_resp(e).trial = e;
end

a = 0;
for m = 1: length(EEG.event)
    if strcmp(EEG.event(m).type,'stim')
        if isempty(EEG.event(m-2).trial) == 0
            EEG.event(m).trial = a;
        else
            a = a + 1;
            EEG.event(m).trial = a;
        end
    end
    if  isempty(EEG.event(m).Condition) == 0
        EEG.event(m).trial = a;
    end
end

%%
% Odd/Even Split  

a = 1;
b = 1;
c = 1;
d = 1;
e = 1;
f = 1;
r = 0;

for m = 1: length(EEG.event)
    if isempty(EEG.event(m).MemSetSize) == 0
        if EEG.event(m).MemSetSize == 3
            if EEG.event(m).UpdatingSteps == 1
                EEG.event(m).Counter = a;
                r = r + 1;
                if r == (EEG.event(m).MemSetSize+EEG.event(m).UpdatingSteps+1)
                    r = 0;
                    a = a + 1;
                end
            elseif EEG.event(m).UpdatingSteps == 2
                EEG.event(m).Counter = b;
                r = r + 1;
                if r == (EEG.event(m).MemSetSize+EEG.event(m).UpdatingSteps+1)
                    r = 0;
                    b = b + 1;
                end
            elseif EEG.event(m).UpdatingSteps == 3
                EEG.event(m).Counter = c;
                r = r + 1;
                if r == (EEG.event(m).MemSetSize+EEG.event(m).UpdatingSteps+1)
                    r = 0;
                    c = c + 1;
                end
            end
        else
            if EEG.event(m).UpdatingSteps == 1
                EEG.event(m).Counter = d;
                r = r + 1;
                if r == (EEG.event(m).MemSetSize+EEG.event(m).UpdatingSteps+1)
                    r = 0;
                    d = d + 1;
                end
            elseif EEG.event(m).UpdatingSteps == 2
                EEG.event(m).Counter = e;
                r = r + 1;
                if r == (EEG.event(m).MemSetSize+EEG.event(m).UpdatingSteps+1)
                    r = 0;
                    e = e + 1;
                end
            elseif EEG.event(m).UpdatingSteps == 3
                EEG.event(m).Counter = f;
                r = r + 1;
                if r == (EEG.event(m).MemSetSize+EEG.event(m).UpdatingSteps+1)
                    r = 0;
                    f = f + 1;
                end
            end
        end
    end
end
   
         for m = 1: length(EEG.event)
             if isempty(EEG.event(m).Counter) == 0
                 if rem( EEG.event(m).Counter , 2) == 0
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
        
        csvwrite([PATH_CHANREJECT 'BadChannels_EEG_' num2str(i) '_Running_Span_Mem.csv' ],  rejected_channels)
        
        
        % Bad channel detection ICA on base of filltering
        [ICA, i3] = pop_rejchan(ICA, 'elec', [1 : (ICA.nbchan-ICA.eog_chans_n)], 'threshold', 10, 'norm', 'on', 'measure', 'kurt');
        [ICA, i4] = pop_rejchan(ICA, 'elec', [1 : (ICA.nbchan-ICA.eog_chans_n)], 'threshold', 5, 'norm', 'on', 'measure', 'prob');
        rejected_channels = horzcat(i3, i4);
        ICA.rejected_channels = horzcat(i3, i4);
        ICA.chans_rejected_n = length(horzcat(i3, i4));
        
        csvwrite([PATH_CHANREJECT 'BadChannels_ICA_' num2str(i) '_Running_Span_Mem.csv' ],  rejected_channels)
             
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
        
        csvwrite([PATH_EPOCHREJECT 'BadSegmentsEEG_' num2str(i) '_Running_Span_Mem.csv' ],  rejected_segments_EEG)
        csvwrite([PATH_EPOCHREJECT 'BadSegmentsICA_' num2str(i) '_Running_Span_Mem.csv' ],  rejected_segments_ICA)

        
        % Check if length of remaining data exceeds 30 minutes
        if ceil(size(EEG.data, 3) * 1.2) >= 1800 %1.2 = Sekunden/Epoche
            
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
        EEG = pop_saveset(EEG, 'filename', [num2str(subject) '_Running_Span_Mem_icdata.set'], 'filepath', PATH_ICWEIGHTS, 'check', 'on', 'savemode', 'twofiles');
         
        
        % Run IClabel
        ICA = iclabel(ICA, 'default');
        ICA.ICout_IClabel = find(ICA.etc.ic_classification.ICLabel.classifications(:, 1) < 0.5);
        EEG.ICout_IClabel = ICA.ICout_IClabel;
        rejected_ICs = length(EEG.ICout_IClabel);
        EEG.n_rejected_ICs  =  rejected_ICs;
        
        
        % Remove bad components detected IC lable
       
       EEG = pop_subcomp(EEG, EEG.ICout_IClabel, 0);
       csvwrite([PATH_BADICS 'BadICs_' num2str(i) '_Running_Span_Mem.csv' ],  EEG.ICout_IClabel)
        
 
        %  Automatically reject epochs after running ICA
        EEG_segs_after_n = size(EEG.data, 3);
       [EEG, segs_rej] = pop_autorej(EEG, 'nogui', 'on', 'threshold', 1000, 'startprob', 5, 'maxrej', 5);
       
        EEG.segs_rejected_after_ica = length(segs_rej); 
        EEG.segs_rejected_overall_percentage = (EEG.segs_rejected_before_ica + EEG.segs_rejected_after_ica);
        
        csvwrite([PATH_EPOCHREJECT 'BadSegmentsEEG_after_' num2str(i) '_Running_Span_Mem.csv' ],  segs_rej)
              
        % Save autocleaned data
        EEG = pop_saveset(EEG, 'filename', [num2str(subject) '_cleaned_Running_Span_Mem.set'], 'filepath', PATH_AUTOCLEANED, 'check', 'on', 'savemode', 'twofiles');
        
    else
        NotExistingFile(z) = i;
        z = z + 1;
    end
end
csvwrite([PATH_MAIN 'Not_existing_files_Running_Span_Mem.csv' ],  NotExistingFile)
save([PATH_MAIN 'Interindividuell_ACC_outliers_Running_Span_Mem.mat' ],  'ACCOutliers')



%% ERP 

    p = 1;
    r = 0;
    NotExistingFile_ERP = [];
    nSubjects = 151;
    count_trials = [];
    
    load([PATH_MAIN 'Interindividuell_ACC_outliers_Running_Span_Mem.mat'])
    
        for i=1:nSubjects
            % Load data
            subject = num2str(i);
            datafile = [num2str(i) '_cleaned_Running_Span_Mem.set'];
            
            
            if isfile([PATH_AUTOCLEANED datafile]) == 1 && ismember(i,ACCOutliers)  ~= 1
                EEG = pop_loadset('filename', [subject '_cleaned_Running_Span_Mem.set'], 'filepath', PATH_AUTOCLEANED, 'loadmode', 'all');
                
                % Recode event types for ERPlab
                for j = 1:length(EEG.event)
                    if strcmp(EEG.event(j).type, 'stim') && 
                        if strcmp(EEG.event(j).type_descr, 'mem_stim') && EEG.event(j).MemSetSize == 3 && ...
                                EEG.event(j).UpdatingSteps == 1
                            EEG.event(j).type = 13;
                        elseif strcmp(EEG.event(j).type_descr, 'upd_stim') && EEG.event(j).MemSetSize == 3 && ...
                                EEG.event(j).UpdatingSteps == 1
                            EEG.event(j).type = 14;
                        elseif strcmp(EEG.event(j).type_descr, 'mem_stim') && EEG.event(j).MemSetSize == 5 && ...
                                EEG.event(j).UpdatingSteps == 1
                            EEG.event(j).type = 15;
                        elseif strcmp(EEG.event(j).type_descr, 'upd_stim') && EEG.event(j).MemSetSize == 5 && ...
                                EEG.event(j).UpdatingSteps == 1
                            EEG.event(j).type = 16;         
                        elseif strcmp(EEG.event(j).type_descr, 'mem_stim') && EEG.event(j).MemSetSize == 3 && ...
                                EEG.event(j).UpdatingSteps == 2
                            EEG.event(j).type = 23;
                        elseif strcmp(EEG.event(j).type_descr, 'upd_stim') && EEG.event(j).MemSetSize == 3 && ...
                                EEG.event(j).UpdatingSteps == 2
                            EEG.event(j).type = 24;                               
                        elseif strcmp(EEG.event(j).type_descr, 'mem_stim') && EEG.event(j).MemSetSize == 5 && ...
                                EEG.event(j).UpdatingSteps == 2
                            EEG.event(j).type = 25;
                        elseif strcmp(EEG.event(j).type_descr, 'upd_stim') && EEG.event(j).MemSetSize == 5 && ...
                                EEG.event(j).UpdatingSteps == 2
                            EEG.event(j).type = 26;  
                        elseif strcmp(EEG.event(j).type_descr, 'mem_stim') && EEG.event(j).MemSetSize == 3 && ...
                                EEG.event(j).UpdatingSteps == 3
                            EEG.event(j).type = 33;
                        elseif strcmp(EEG.event(j).type_descr, 'upd_stim') && EEG.event(j).MemSetSize == 3 && ...
                                EEG.event(j).UpdatingSteps == 3
                            EEG.event(j).type = 34;                               
                        elseif strcmp(EEG.event(j).type_descr, 'mem_stim') && EEG.event(j).MemSetSize == 5 && ...
                                EEG.event(j).UpdatingSteps == 3
                            EEG.event(j).type = 35;
                        elseif strcmp(EEG.event(j).type_descr, 'upd_stim') && EEG.event(j).MemSetSize == 5 && ...
                                EEG.event(j).UpdatingSteps == 3
                            EEG.event(j).type = 36;  
                        end
                    end
                end
                
               %odd even split for reliability
                for j = 1:length(EEG.event)
                    if isempty(EEG.event(j).Odd_Even) == 0
                        if EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 13
                            EEG.event(j).type = 130;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 14
                            EEG.event(j).type = 140;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 15
                            EEG.event(j).type = 150;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 16
                            EEG.event(j).type = 160;
                        elseif EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 23
                            EEG.event(j).type = 230;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 24
                            EEG.event(j).type = 240;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 25
                            EEG.event(j).type = 250;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 26
                            EEG.event(j).type = 260;
                        elseif EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 33
                            EEG.event(j).type = 330;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 34
                            EEG.event(j).type = 340;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 35
                            EEG.event(j).type = 350;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 36
                            EEG.event(j).type = 360;
                        else
                            EEG.event(j).type = EEG.event(j).type;
                        end
                    end
                end
                
                a1 = 0;
                b1 = 0;
                c1 = 0;
                d1 = 0;
                e1 = 0;
                f1 = 0;
                g1 = 0;
                h1 = 0;
                a2 = 0;
                b2 = 0;
                c2 = 0;
                d2 = 0;
                e2 = 0;
                f2 = 0;
                g2 = 0;
                h2 = 0;
                a3 = 0;
                b3 = 0;
                c3 = 0;
                d3 = 0;
                e3 = 0;
                f3 = 0;
                g3 = 0;
                h3 = 0;
                
                for t = 1:length(EEG.event)
                    if isempty(EEG.event(t).Odd_Even) == 0
                        if  EEG.event(t).type == 13
                            a1 = a1 + 1;
                        elseif   EEG.event(t).type == 130
                            b1 = b1 + 1;
                        elseif   EEG.event(t).type == 14
                            c1 = c1 + 1;
                        elseif   EEG.event(t).type == 140
                            d1 = d1 + 1;
                        elseif  EEG.event(t).type == 15
                            e1 = e1 + 1;
                        elseif   EEG.event(t).type == 150
                            f1 = f1 + 1;
                        elseif   EEG.event(t).type == 16
                            g1 = g1 + 1;
                        elseif   EEG.event(t).type == 160
                            h1 = h1 + 1;
                        elseif  EEG.event(t).type == 23
                            a2 = a2 + 1;
                        elseif   EEG.event(t).type == 230
                            b2 = b2 + 1;
                        elseif   EEG.event(t).type == 24
                            c2 = c2 + 1;
                        elseif   EEG.event(t).type == 240
                            d2 = d2 + 1;
                        elseif  EEG.event(t).type == 25
                            e2 = e2 + 1;
                        elseif   EEG.event(t).type == 250
                            f2 = f2 + 1;
                        elseif   EEG.event(t).type == 26
                            g2 = g2 + 1;
                        elseif   EEG.event(t).type == 260
                            h2 = h2 + 1;
                        elseif  EEG.event(t).type == 33
                            a3 = a3 + 1;
                        elseif   EEG.event(t).type == 330
                            b3 = b3 + 1;
                        elseif   EEG.event(t).type == 34
                            c3 = c3 + 1;
                        elseif   EEG.event(t).type == 340
                            d3 = d3 + 1;
                        elseif  EEG.event(t).type == 35
                            e3 = e3 + 1;
                        elseif   EEG.event(t).type == 350
                            f3 = f3 + 1;
                        elseif   EEG.event(t).type == 36
                            g3 = g3 + 1;
                        elseif   EEG.event(t).type == 360
                            h3 = h3 + 1;
                        end
                    end
                end
                               
                r = r + 1;
                count_trials(r,1) = i; 
                count_trials(r,2) = a1;
                count_trials(r,3) = b1;
                count_trials(r,4) = c1;
                count_trials(r,5) = d1;
                count_trials(r,6) = e1;
                count_trials(r,7) = f1;
                count_trials(r,8) = g1;
                count_trials(r,9) = h1;
                count_trials(r,10) = a2;
                count_trials(r,11) = b2;
                count_trials(r,12) = c2;
                count_trials(r,13) = d2;
                count_trials(r,14) = e2;
                count_trials(r,15) = f2;
                count_trials(r,16) = g2;
                count_trials(r,17) = h2;
                count_trials(r,18) = a3;
                count_trials(r,19) = b3;
                count_trials(r,20) = c3;
                count_trials(r,21) = d3;
                count_trials(r,22) = e3;
                count_trials(r,23) = f3;
                count_trials(r,24) = g3;
                count_trials(r,25) = h3;
                
                % Remove response markers
                EEG = eeg_checkset(EEG, 'eventconsistency');
                
                % Recreate continuous EEG
                EEG = pop_epoch2continuous(EEG,'Warning','off');
                
                % Create EventList for ERPLab
                EEG  = pop_creabasiceventlist(EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } );
                
                % Create Bins for different conditions
                EEG  = pop_binlister(EEG , 'BDF', [PATH_LIST '\bin_list_Exp23_Run_Span_Mem.txt'], 'IndexEL',  1, 'SendEL2', 'Workspace&EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
                EEG.setname = ['Running_Span_Mem_' num2str(i) '_bin'];
                
                % Epoch data
                EEG = pop_epochbin( EEG , [-200.0  1000.0],  [ -200 0]);
                EEG.setname = ['Running_Span_Mem_' num2str(i) '_bin_epoch'];
                
                % Compute ERPs for the different bins
                ERP = pop_averager( EEG , 'Criterion', 'all', 'ExcludeBoundary', 'off', 'SEM', 'on' );
                ERP.erpname = ['Running_Span_Mem_' num2str(i) '_bin_average'];
                
                % Save ERP set to
                ERP = pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', ['Running_Span_Mem_' num2str(i) '.erp'], 'filepath', PATH_ERP);
            else
                NotExistingFile_ERP(p) = i;
                p = p + 1;
            end   
        end

             csvwrite([PATH_MAIN 'Running_Span_Mem_count_trials_in_bnis.csv'], count_trials)
