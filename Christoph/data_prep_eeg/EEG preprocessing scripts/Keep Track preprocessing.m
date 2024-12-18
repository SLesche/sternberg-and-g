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
y = 1;
z = 1;

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
    
    
    
    if i == 6 ||  i == 85 || i == 88 || i == 97
        datafile = ['Keine_Aufzeichnung'];
    elseif i == 43
        datafile = ['Exp23_00' num2str(i) '_3.vhdr'];
    elseif i == 50
        datafile = ['Exp23_00' num2str(i) '_22.vhdr'];
    elseif i == 52
        datafile = ['Exp23_00' num2str(i) '_21.vhdr'];
    elseif i == 63
        datafile = ['Exp23_00' num2str(i) '_22.vhdr'];
    elseif i == 73
        datafile = ['Exp23_00' num2str(i) '_2_2.vhdr'];
    elseif i == 80
        datafile = ['Exp23_00' num2str(i) '_2_2.vhdr'];
    elseif i == 119
        datafile = ['Exp23_0' num2str(i) '_2_2.vhdr'];
    elseif i == 138
        datafile = ['Exp23_0' num2str(i) '_21.vhdr'];
   elseif  i == 24 || i == 47 ||  i == 57 || i == 94  
        datafile = ['Ground_Ref_Vertauscht'];
    elseif i == 4 || i == 34 || i == 103
        datafile = ['Abbruch'];   
    end
   
  
    if isfile([PATH_RAW_DATA datafile]) == 1

 %% Load coded data

% match the EEG data with the bahavioral data
if i ~= 119
    if i == 3 || i == 111 ||i == 139 ||i == 140
        load([PATH_BEHAV 'KeepTrackTaskKeepTrackTask_Trials_S' num2str(i) '_Ses2_Block1']);
        
    else
        load([PATH_BEHAV 'KeepTrackTaskKeepTrackTask_Trials_S' num2str(i) '_Ses1_Block1']);
    end
end

Trial1 = ExpTrials;
ExpTrials =[];
if i == 3 ||i == 111 ||i == 119 ||i == 139 ||i == 140
    load([PATH_BEHAV 'KeepTrackTaskKeepTrackTask_Trials_S' num2str(i) '_Ses2_Block2']);
else
    load([PATH_BEHAV 'KeepTrackTaskKeepTrackTask_Trials_S' num2str(i) '_Ses1_Block2']);
end

Trial2 = ExpTrials;
ExpTrials =[];

Trials = [Trial1 Trial2];

CategoryPos = [];

for m = 1:length(Trials)
    CategoryPos(m).Trial = m;
    CategoryPos(m).CategoryInPos = Trials(m).CategoryPos; 
    CategoryPos(m).CategoryInPos_flip = fliplr(CategoryPos(m).CategoryInPos);
    CategoryPos(m).UpdatingCategories = [Trials(m).Category Trials(m).OtherStimCategories];
    for n = 1:length(Trials(m).CategoryPos)
        if ismember(Trials(m).CategoryPos(n),CategoryPos(m).UpdatingCategories)
            if n < 5
                CategoryPos(m).Relevant(n) = 2;
            else
                CategoryPos(m).Relevant(n) = 4;
            end
        else
            if n < 5
                CategoryPos(m).Relevant(n) = 1;
            else
                CategoryPos(m).Relevant(n) = 3;
            end
        end
    end
    CategoryPos(m).Updating = Trials(m).Updating;
    CategoryPos(m).Relevant_flip = fliplr(CategoryPos(m).Relevant); 
end

%%
            EEG =  pop_loadbv(PATH_RAW_DATA, datafile, [], []);
            EEG.eog_chans = [33 34];
            EEG.eog_chans_n = length(EEG.eog_chans);
          
        % Define stimulus events
        impevents = {'S 51', 'S 52', 'S 53', 'S 54', 'S 55', 'S 56', 'S 57', 'S 58'}; % grade Marker ==> Updating Cond. 
        correvents = {'S150' 'S160'};
        setevents = {'S 61', 'S 62', 'S 63', 'S 64', 'S 65', 'S 66', 'S 67', 'S 68'};
        
        seteventsBL1 = {'S 61', 'S 62', 'S 63', 'S 64'};
        seteventsBL2 = {'S 65', 'S 66', 'S 67', 'S 68'};
              
        % Remove irrelevant tasks
        for j = 1:length(EEG.event)
            if strcmp(EEG.event(j).type, 'S 24')
                idxStart = j;
            elseif strcmp(EEG.event(j).type, 'S 25')
                idxEnd = j;
            end
        end
            
        if i == 50
            for m = 1:4
           EEG.event(3139) = [];     
            end
        end
        
        if i == 50 || i == 63  || i == 73
            idxEnd = length(EEG.event);
        end
        
 
        if i == 119
            idxStart = 1;
        end
        
        EEG = pop_select(EEG,'time', [EEG.event(idxStart).latency/1000  EEG.event(idxEnd).latency/1000]); % remove data
       
         
        % Find indices
        stimidx = find(ismember({EEG.event.type}, impevents));
        errors = {'S250' 'S255', 'S251'};
          errorindx = find(ismember({EEG.event.type}, errors));
%%        
         % Add the Updating steps  
         
         for e = 1: length(EEG.event)
             if ismember(EEG.event(e).type,setevents)
                 if ismember(EEG.event(e).type,seteventsBL1)
                     EEG.event(e).UpdatingSteps = 1;
                 else
                     EEG.event(e).UpdatingSteps = 3;
                 end
             end
         end
        
 % add information   
         
        x1 = [1:7];
        x1 = fliplr(x1); 
        f = 1;
        for e = 1 : length(stimidx)
            if ismember(EEG.event(stimidx(e)+1).type, correvents) && ... 
                    (EEG.event(stimidx(e)+1).latency - EEG.event(stimidx(e)).latency >= 150)
      
                % Condition of current trial
                if strcmp(EEG.event(stimidx(e)).type,'S 51') ||  strcmp(EEG.event(stimidx(e)).type,'S 53')
                    if strcmp(EEG.event(stimidx(e)).type,'S 51')
                        EEG.event(stimidx(e)).Condition = 'MemSet1_NoUp_NoMatch';
                        EEG.event(stimidx(e)).MatchCond = 0;
                        EEG.event(stimidx(e)).Updating = 0;
                        for n = 1:length(Trials(e).CategoryPos)
                    %        EEG.event(stimidx(e)-(2*n)).type = 'stim';
                            EEG.event(stimidx(e)-(2*n)).type_stim = CategoryPos(e).Relevant_flip(n);
                            if EEG.event(stimidx(e)-(2*n)).type_stim == 1
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim  == 2
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_relevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 3
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 4
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_relevant';
                            end
                            EEG.event(stimidx(e)-(2*n)).UpdatingCategories = CategoryPos(e).UpdatingCategories;
                            EEG.event(stimidx(e)-(2*n)).Category = CategoryPos(e).CategoryInPos_flip(n);
                     %       EEG.event(stimidx(e)-(2*n)).trial = f;
                            EEG.event(stimidx(e)-(2*n)).SetPos = x1(n);
                            EEG.event(stimidx(e)-(2*n)).Updating = 0;
                            EEG.event(stimidx(e)-(2*n)).UpdatingSteps = 1;
                        end
                    else
                        EEG.event(stimidx(e)).Condition = 'MemSet1_NoUp_Match';
                        EEG.event(stimidx(e)).MatchCond = 1;
                        EEG.event(stimidx(e)).Updating = 0;
                        for n = 1:length(Trials(e).CategoryPos)
                    %        EEG.event(stimidx(e)-(2*n)).type = 'stim';
                            EEG.event(stimidx(e)-(2*n)).type_stim = CategoryPos(e).Relevant_flip(n);
                            if EEG.event(stimidx(e)-(2*n)).type_stim == 1
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim  == 2
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_relevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 3
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 4
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_relevant';
                            end
                            EEG.event(stimidx(e)-(2*n)).UpdatingCategories = CategoryPos(e).UpdatingCategories;
                            EEG.event(stimidx(e)-(2*n)).Category = CategoryPos(e).CategoryInPos_flip(n);
                      %      EEG.event(stimidx(e)-(2*n)).trial = f;
                            EEG.event(stimidx(e)-(2*n)).SetPos = x1(n);
                            EEG.event(stimidx(e)-(2*n)).Updating = 0;
                            EEG.event(stimidx(e)-(2*n)).UpdatingSteps = 1;
                        end
                    end
                    EEG.event(stimidx(e)).Cond_Factor = 1;
            elseif strcmp(EEG.event(stimidx(e)).type,'S 52') ||  strcmp(EEG.event(stimidx(e)).type,'S 54')
                    if strcmp(EEG.event(stimidx(e)).type,'S 52')
                        EEG.event(stimidx(e)).Condition = 'MemSet1_Up_NoMatch';
                        EEG.event(stimidx(e)).MatchCond = 0;
                        EEG.event(stimidx(e)).Updating = 1;
                        for n = 1:length(Trials(e).CategoryPos)
                            EEG.event(stimidx(e)-(2*n)).type = 'stim';
                            EEG.event(stimidx(e)-(2*n)).type_stim = CategoryPos(e).Relevant_flip(n);
                            if EEG.event(stimidx(e)-(2*n)).type_stim == 1
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim  == 2
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_relevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 3
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 4
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_relevant';
                            end
                            EEG.event(stimidx(e)-(2*n)).UpdatingCategories = CategoryPos(e).UpdatingCategories;
                            EEG.event(stimidx(e)-(2*n)).Category = CategoryPos(e).CategoryInPos_flip(n);
                            EEG.event(stimidx(e)-(2*n)).trial = f;
                            EEG.event(stimidx(e)-(2*n)).SetPos = x1(n);
                            EEG.event(stimidx(e)-(2*n)).Updating = 1;
                            EEG.event(stimidx(e)-(2*n)).UpdatingSteps = 1;
                        end
                        f = f +1;
                    else
                        EEG.event(stimidx(e)).Condition = 'MemSet1_Up_Match';
                        EEG.event(stimidx(e)).MatchCond = 1;
                        EEG.event(stimidx(e)).Updating = 1;
                        for n = 1:length(Trials(e).CategoryPos)
                            EEG.event(stimidx(e)-(2*n)).type = 'stim';
                            EEG.event(stimidx(e)-(2*n)).type_stim = CategoryPos(e).Relevant_flip(n);
                            if EEG.event(stimidx(e)-(2*n)).type_stim == 1
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim  == 2
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_relevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 3
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 4
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_relevant';
                            end
                            EEG.event(stimidx(e)-(2*n)).UpdatingCategories = CategoryPos(e).UpdatingCategories;
                            EEG.event(stimidx(e)-(2*n)).Category = CategoryPos(e).CategoryInPos_flip(n);
                            EEG.event(stimidx(e)-(2*n)).trial = f;
                            EEG.event(stimidx(e)-(2*n)).SetPos = x1(n);
                            EEG.event(stimidx(e)-(2*n)).Updating = 1;
                            EEG.event(stimidx(e)-(2*n)).UpdatingSteps = 1;
                        end
                        f = f +1;
                    end
                    EEG.event(stimidx(e)).Cond_Factor = 2;
                elseif strcmp(EEG.event(stimidx(e)).type,'S 55') ||  strcmp(EEG.event(stimidx(e)).type,'S 57')
                    if strcmp(EEG.event(stimidx(e)).type,'S 55')
                        EEG.event(stimidx(e)).Condition = 'MemSet3_NoUp_NoMatch';
                        EEG.event(stimidx(e)).MatchCond = 0;
                        EEG.event(stimidx(e)).Updating = 0;
                        for n = 1:length(Trials(e).CategoryPos)
                        %    EEG.event(stimidx(e)-(2*n)).type = 'stim';
                            EEG.event(stimidx(e)-(2*n)).type_stim = CategoryPos(e).Relevant_flip(n);
                            if EEG.event(stimidx(e)-(2*n)).type_stim == 1
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim  == 2
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_relevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 3
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 4
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_relevant';
                            end
                            EEG.event(stimidx(e)-(2*n)).UpdatingCategories = CategoryPos(e).UpdatingCategories;
                            EEG.event(stimidx(e)-(2*n)).Category = CategoryPos(e).CategoryInPos_flip(n);
                       %     EEG.event(stimidx(e)-(2*n)).trial = f;
                            EEG.event(stimidx(e)-(2*n)).SetPos = x1(n);
                            EEG.event(stimidx(e)-(2*n)).Updating = 0;
                            EEG.event(stimidx(e)-(2*n)).UpdatingSteps = 3;
                        end
                    else
                        EEG.event(stimidx(e)).Condition = 'MemSet3_NoUp_Match';
                        EEG.event(stimidx(e)).MatchCond = 1;
                        EEG.event(stimidx(e)).Updating = 0;
                        for n = 1:length(Trials(e).CategoryPos)
                       %     EEG.event(stimidx(e)-(2*n)).type = 'stim';
                            EEG.event(stimidx(e)-(2*n)).type_stim = CategoryPos(e).Relevant_flip(n);
                            if EEG.event(stimidx(e)-(2*n)).type_stim == 1
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim  == 2
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_relevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 3
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 4
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_relevant';
                            end
                            EEG.event(stimidx(e)-(2*n)).UpdatingCategories = CategoryPos(e).UpdatingCategories;
                            EEG.event(stimidx(e)-(2*n)).Category = CategoryPos(e).CategoryInPos_flip(n);
                    %        EEG.event(stimidx(e)-(2*n)).trial = f;
                            EEG.event(stimidx(e)-(2*n)).SetPos = x1(n);
                            EEG.event(stimidx(e)-(2*n)).Updating = 0;
                            EEG.event(stimidx(e)-(2*n)).UpdatingSteps = 3;
                        end
                   end
                   EEG.event(stimidx(e)).Cond_Factor = 3;
                elseif strcmp(EEG.event(stimidx(e)).type,'S 56') ||  strcmp(EEG.event(stimidx(e)).type,'S 58')
                    if strcmp(EEG.event(stimidx(e)).type,'S 56')
                        EEG.event(stimidx(e)).Condition = 'MemSet3_Up_NoMatch';
                        EEG.event(stimidx(e)).MatchCond = 0;
                        EEG.event(stimidx(e)).Updating = 1;
                        for n = 1:length(Trials(e).CategoryPos)
                            EEG.event(stimidx(e)-(2*n)).type = 'stim';
                            EEG.event(stimidx(e)-(2*n)).type_stim = CategoryPos(e).Relevant_flip(n);
                            if EEG.event(stimidx(e)-(2*n)).type_stim == 1
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim  == 2
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_relevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 3
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 4
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_relevant';
                            end
                            EEG.event(stimidx(e)-(2*n)).UpdatingCategories = CategoryPos(e).UpdatingCategories;
                            EEG.event(stimidx(e)-(2*n)).Category = CategoryPos(e).CategoryInPos_flip(n);
                            EEG.event(stimidx(e)-(2*n)).trial = f;
                            EEG.event(stimidx(e)-(2*n)).SetPos = x1(n);
                            EEG.event(stimidx(e)-(2*n)).Updating = 1;
                            EEG.event(stimidx(e)-(2*n)).UpdatingSteps = 3;
                        end
                        f = f +1;
                    else
                        EEG.event(stimidx(e)).Condition = 'MemSet3_Up_Match';
                        EEG.event(stimidx(e)).MatchCond = 1;
                        EEG.event(stimidx(e)).Updating = 1;
                        for n = 1:length(Trials(e).CategoryPos)
                            EEG.event(stimidx(e)-(2*n)).type = 'stim';
                            EEG.event(stimidx(e)-(2*n)).type_stim = CategoryPos(e).Relevant_flip(n);
                            if EEG.event(stimidx(e)-(2*n)).type_stim == 1
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim  == 2
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'MemSet_relevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 3
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_irrelevant';
                            elseif EEG.event(stimidx(e)-(2*n)).type_stim == 4
                                EEG.event(stimidx(e)-(2*n)).type_descr = 'UpdSet_relevant';
                            end
                            EEG.event(stimidx(e)-(2*n)).UpdatingCategories = CategoryPos(e).UpdatingCategories;
                            EEG.event(stimidx(e)-(2*n)).Category = CategoryPos(e).CategoryInPos_flip(n);
                            EEG.event(stimidx(e)-(2*n)).trial = f;
                            EEG.event(stimidx(e)-(2*n)).SetPos = x1(n);
                            EEG.event(stimidx(e)-(2*n)).Updating = 1;
                            EEG.event(stimidx(e)-(2*n)).UpdatingSteps = 3;
                        end
                        f = f +1;
                    end
                    EEG.event(stimidx(e)).Cond_Factor = 4;
                end   
                if strcmp(EEG.event(stimidx(e)+1).type,'S150')
                    EEG.event(stimidx(e)).AnswerKey = 'CorrResp_left';
                elseif strcmp(EEG.event(stimidx(e)+1).type,'S160')
                    EEG.event(stimidx(e)).AnswerKey = 'CorrResp_right';
                end 
                EEG.event(stimidx(e)).RT = EEG.event(stimidx(e)+1).latency - EEG.event(stimidx(e)).latency; 
            end
        end
               
f = 1;
for e = 1:length(EEG.event)
    if e > 1
        if strcmp(EEG.event(e).type,correvents(1)) && isempty(EEG.event(e-1).RT) == 0 || ...
                strcmp(EEG.event(e).type,correvents(2)) && isempty(EEG.event(e-1).RT) == 0
            if EEG.event(e-1).Updating == 1
                EEG.event_resp(f) = EEG.event(e-1);
                EEG.event_resp(f).trial = f;
                f = f + 1;
            end
        end
    end
end

%%
% intraindividual outlier analysis 
a = 0;
for m = 1: length(EEG.event)
    if strcmp(EEG.event(m).type,'S 72') || strcmp(EEG.event(m).type,'S 74') || strcmp(EEG.event(m).type,'S 76') || strcmp(EEG.event(m).type,'S 78') 
a = a + 1;
    end
end

c =(length(EEG.event_resp)/a)*100;

if c < 70 || a < 70
ACCOutliers(y) = i;
y = y + 1;
end
       Cond_Factor = 2; 
        RT1 =[];
        RT2 =[];
        RT3 =[];

           a = 1;
           b = 1;
           c = 1;

        for m = 1: length(EEG.event_resp)
            if  EEG.event_resp(m).Cond_Factor == 2
                RT1(a) = EEG.event_resp(m).RT;
                a = a + 1;
            elseif  EEG.event_resp(m).Cond_Factor == 4
                RT2(b) = EEG.event_resp(m).RT;
                b = b + 1;    
            end
            RT3(c) = EEG.event_resp(m).RT;
            c = c + 1;
        end
 
log_RT1 = log(RT1);
log_RT2 = log(RT2);
log_RT3 = log(RT3);

        z_RT1 = zscore(log_RT1);
        z_RT2 = zscore(log_RT2);
        z_RT3 = zscore(log_RT3);

        a = 1;
        b = 1;
        c = 1;          

for m = 1: length(EEG.event_resp)    
    if  EEG.event_resp(m).Cond_Factor == 2
        EEG.event_resp(m).z_RT_cond = z_RT1(a);
        a = a + 1;
    elseif  EEG.event_resp(m).Cond_Factor == 4
        EEG.event_resp(m).z_RT_cond = z_RT2(b);
        b = b + 1;
    end    
end

for m = 1: length(EEG.event_resp)    
        EEG.event_resp(m).z_RT = z_RT3(c);
        c = c + 1; 
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
% re-number the trials
         
for e = 1:length(EEG.event_resp)
    EEG.event_resp(e).trial = e;
end

a = 1;
b = 1;
for e = 1: length(EEG.event)
    if strcmp(EEG.event(e).type,'stim')
        EEG.event(e).trial = a;
        b = b + 1;
    end
    
    if b == 8
        b = 1;
        a = a + 1;
    end
end

%%
% Odd/Even split  
         
         for m = 1: length(EEG.event)
             if  isempty(EEG.event(m).trial) == 0
                 if rem( EEG.event(m).trial , 2) == 0
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
        
        csvwrite([PATH_CHANREJECT 'BadChannels_EEG_' num2str(i) '_Keep_Track_Mem.csv' ],  rejected_channels)
        
        % Bad channel detection ICA on base of filltering
        [ICA, i3] = pop_rejchan(ICA, 'elec', [1 : (ICA.nbchan-ICA.eog_chans_n)], 'threshold', 10, 'norm', 'on', 'measure', 'kurt');
        [ICA, i4] = pop_rejchan(ICA, 'elec', [1 : (ICA.nbchan-ICA.eog_chans_n)], 'threshold', 5, 'norm', 'on', 'measure', 'prob');
        rejected_channels = horzcat(i3, i4);
        ICA.rejected_channels = horzcat(i3, i4);
        ICA.chans_rejected_n = length(horzcat(i3, i4));
        
        csvwrite([PATH_CHANREJECT 'BadChannels_ICA_' num2str(i) '_Keep_Track_Mem.csv' ],  rejected_channels)
             
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
        
        csvwrite([PATH_EPOCHREJECT 'BadSegmentsEEG_' num2str(i) '_Keep_Track_Mem.csv' ],  rejected_segments_EEG)
        csvwrite([PATH_EPOCHREJECT 'BadSegmentsICA_' num2str(i) '_Keep_Track_Mem.csv' ],  rejected_segments_ICA)

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
        EEG = pop_saveset(EEG, 'filename', [num2str(subject) '_Keep_Track_Mem_icdata.set'], 'filepath', PATH_ICWEIGHTS, 'check', 'on', 'savemode', 'twofiles');
         
        % Run IClabel
        ICA = iclabel(ICA, 'default');
        ICA.ICout_IClabel = find(ICA.etc.ic_classification.ICLabel.classifications(:, 1) < 0.5);
        EEG.ICout_IClabel = ICA.ICout_IClabel;
        rejected_ICs = length(EEG.ICout_IClabel);
        EEG.n_rejected_ICs  =  rejected_ICs;
        
        % Remove bad components detected IC lable
       EEG = pop_subcomp(EEG, EEG.ICout_IClabel, 0);
       csvwrite([PATH_BADICS 'BadICs_' num2str(i) '_Keep_Track_Mem.csv' ],  EEG.ICout_IClabel)
        
        %  Automatically reject epochs after running ICA
        EEG_segs_after_n = size(EEG.data, 3);
       [EEG, segs_rej] = pop_autorej(EEG, 'nogui', 'on', 'threshold', 1000, 'startprob', 5, 'maxrej', 5);
       
        EEG.segs_rejected_after_ica = length(segs_rej); 
        EEG.segs_rejected_overall_percentage = (EEG.segs_rejected_before_ica + EEG.segs_rejected_after_ica);
        
        csvwrite([PATH_EPOCHREJECT 'BadSegmentsEEG_after_' num2str(i) '_Keep_Track_Mem.csv' ],  segs_rej)

        % Save autocleaned data
        EEG = pop_saveset(EEG, 'filename', [num2str(subject) '_cleaned_Keep_Track_Mem.set'], 'filepath', PATH_AUTOCLEANED, 'check', 'on', 'savemode', 'twofiles');
        
    else
        NotExistingFile(z) = i;
        z = z + 1;
    end
end
csvwrite([PATH_MAIN 'Not_existing_files_Keep_Track_Mem.csv' ],  NotExistingFile)
save([PATH_MAIN 'Interindividuell_ACC_outliers_Keep_Track_Mem.mat' ],  'ACCOutliers')


%% ERP 

    p = 1;
    r = 0;
    NotExistingFile_ERP = [];
    nSubjects = 151;

       ACC_Out = load([PATH_MAIN 'Interindividuell_ACC_outliers_Keep_Track_Mem.mat']);
    
        for i=1:nSubjects
            % Load data
            subject = num2str(i);
            datafile = [num2str(i) '_cleaned_Keep_Track_Mem.set'];
             
            if isfile([PATH_AUTOCLEANED datafile]) == 1  && ~ismember(i, ACC_Out.ACCOutliers)
                EEG = pop_loadset('filename', [subject '_cleaned_Keep_Track_Mem.set'], 'filepath', PATH_AUTOCLEANED, 'loadmode', 'all');

                % Recode event types for ERPlab
                for j = 1:length(EEG.event)
                    if strcmp(EEG.event(j).type, 'stim')
                        if EEG.event(j).type_stim == 2 && EEG.event(j).UpdatingSteps == 1 && EEG.event(j).Category == 1
                            EEG.event(j).type = 11;
                        elseif  EEG.event(j).type_stim == 2 && EEG.event(j).UpdatingSteps == 1 && EEG.event(j).Category == 2
                            EEG.event(j).type = 12;
                        elseif  EEG.event(j).type_stim == 2 && EEG.event(j).UpdatingSteps == 1 && EEG.event(j).Category == 3
                           EEG.event(j).type = 13;
                        elseif  EEG.event(j).type_stim == 2 && EEG.event(j).UpdatingSteps == 1 && EEG.event(j).Category == 4
                           EEG.event(j).type = 14;
                        elseif EEG.event(j).type_stim == 4 && EEG.event(j).UpdatingSteps == 1 && EEG.event(j).Category == 1
                            EEG.event(j).type = 21;
                        elseif  EEG.event(j).type_stim == 4 && EEG.event(j).UpdatingSteps == 1 && EEG.event(j).Category == 2
                            EEG.event(j).type = 22;
                        elseif  EEG.event(j).type_stim == 4 && EEG.event(j).UpdatingSteps == 1 && EEG.event(j).Category == 3
                           EEG.event(j).type = 23;
                        elseif  EEG.event(j).type_stim == 4 && EEG.event(j).UpdatingSteps == 1 && EEG.event(j).Category == 4
                           EEG.event(j).type = 24;
                        elseif EEG.event(j).type_stim == 2 && EEG.event(j).UpdatingSteps == 3 && EEG.event(j).Category == 1
                            EEG.event(j).type = 31;
                        elseif  EEG.event(j).type_stim == 2 && EEG.event(j).UpdatingSteps == 3 && EEG.event(j).Category == 2
                            EEG.event(j).type = 32;
                        elseif  EEG.event(j).type_stim == 2 && EEG.event(j).UpdatingSteps == 3 && EEG.event(j).Category == 3
                           EEG.event(j).type = 33;
                        elseif  EEG.event(j).type_stim == 2 && EEG.event(j).UpdatingSteps == 3 && EEG.event(j).Category == 4
                           EEG.event(j).type = 34;
                        elseif EEG.event(j).type_stim == 4 && EEG.event(j).UpdatingSteps == 3 && EEG.event(j).Category == 1
                            EEG.event(j).type = 41;
                        elseif  EEG.event(j).type_stim == 4 && EEG.event(j).UpdatingSteps == 3 && EEG.event(j).Category == 2
                            EEG.event(j).type = 42;
                        elseif  EEG.event(j).type_stim == 4 && EEG.event(j).UpdatingSteps == 3 && EEG.event(j).Category == 3
                           EEG.event(j).type = 43;
                        elseif  EEG.event(j).type_stim == 4 && EEG.event(j).UpdatingSteps == 3 && EEG.event(j).Category == 4
                           EEG.event(j).type = 44;   
                        end
                    end
                end
                
                for j = 1:length(EEG.event)
                    if strcmp(EEG.event(j).type, 'stim')
                        EEG.event(j).Odd_Even = [];
                    end
                end
                
               %odd even split for reliability
                for j = 1:length(EEG.event)
                    if isempty(EEG.event(j).Odd_Even) == 0
                        if EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 11
                            EEG.event(j).type = 101;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 12
                            EEG.event(j).type = 102;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 13
                            EEG.event(j).type = 103;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 14
                            EEG.event(j).type = 104;
                        elseif EEG.event(j).Odd_Even  == 1 &&  EEG.event(j).type == 21
                            EEG.event(j).type = 201;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 22
                            EEG.event(j).type = 202;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 23
                            EEG.event(j).type = 203;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 24
                            EEG.event(j).type = 204;
                        elseif EEG.event(j).Odd_Even  == 1 &&  EEG.event(j).type == 31
                            EEG.event(j).type = 301;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 32
                            EEG.event(j).type = 302;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 33
                            EEG.event(j).type = 303;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 34
                            EEG.event(j).type = 304;
                        elseif EEG.event(j).Odd_Even  == 1 &&  EEG.event(j).type == 41
                            EEG.event(j).type = 401;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 42
                            EEG.event(j).type = 402;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 43
                            EEG.event(j).type = 403;
                        elseif  EEG.event(j).Odd_Even == 1 &&  EEG.event(j).type == 44
                            EEG.event(j).type = 404;
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
                a4 = 0;
                b4 = 0;
                c4 = 0;
                d4 = 0;
                e4 = 0;
                f4 = 0;
                g4 = 0;
                h4 = 0;
                
                for t = 1:length(EEG.event)
                    if isempty(EEG.event(t).Odd_Even) == 0
                        if  EEG.event(t).type == 11
                            a1 = a1 + 1;
                        elseif   EEG.event(t).type == 101
                            b1 = b1 + 1;
                        elseif   EEG.event(t).type == 12
                            c1 = c1 + 1;
                        elseif   EEG.event(t).type == 102
                            d1 = d1 + 1;
                        elseif  EEG.event(t).type == 13
                            e1 = e1 + 1;
                        elseif   EEG.event(t).type == 103
                            f1 = f1 + 1;
                        elseif   EEG.event(t).type == 14
                            g1 = g1 + 1;
                        elseif   EEG.event(t).type == 104
                            h1 = h1 + 1;
                        elseif  EEG.event(t).type == 21
                            a2 = a2 + 1;
                        elseif   EEG.event(t).type == 201
                            b2 = b2 + 1;
                        elseif   EEG.event(t).type == 22
                            c2 = c2 + 1;
                        elseif   EEG.event(t).type == 202
                            d2 = d2 + 1;
                        elseif  EEG.event(t).type == 23
                            e2 = e2 + 1;
                        elseif   EEG.event(t).type == 203
                            f2 = f2 + 1;
                        elseif   EEG.event(t).type == 24
                            g2 = g2 + 1;
                        elseif   EEG.event(t).type == 204
                            h2 = h2 + 1;
                        elseif  EEG.event(t).type == 31
                            a3 = a3 + 1;
                        elseif   EEG.event(t).type == 301
                            b3 = b3 + 1;
                        elseif   EEG.event(t).type == 32
                            c3 = c3 + 1;
                        elseif   EEG.event(t).type == 302
                            d3 = d3 + 1;
                        elseif  EEG.event(t).type == 33
                            e3 = e3 + 1;
                        elseif   EEG.event(t).type == 303
                            f3 = f3 + 1;
                        elseif   EEG.event(t).type == 34
                            g3 = g3 + 1;
                        elseif   EEG.event(t).type == 304
                            h3 = h3 + 1;
                        elseif  EEG.event(t).type == 41
                            a4 = a4 + 1;
                        elseif   EEG.event(t).type == 401
                            b4 = b4 + 1;
                        elseif   EEG.event(t).type == 42
                            c4 = c4 + 1;
                        elseif   EEG.event(t).type == 402
                            d4 = d4 + 1;
                        elseif  EEG.event(t).type == 43
                            e4 = e4 + 1;
                        elseif   EEG.event(t).type == 403
                            f4 = f4 + 1;
                        elseif   EEG.event(t).type == 44
                            g4 = g4 + 1;
                        elseif   EEG.event(t).type == 404
                            h4 = h4 + 1;
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
                count_trials(r,26) = a4;
                count_trials(r,27) = b4;
                count_trials(r,28) = c4;
                count_trials(r,29) = d4;
                count_trials(r,30) = e4;
                count_trials(r,31) = f4;
                count_trials(r,32) = g4;
                count_trials(r,33) = h4;
                
                % Remove response markers
                EEG = eeg_checkset(EEG, 'eventconsistency');
                
                % Recreate continuous EEG
                EEG = pop_epoch2continuous(EEG,'Warning','off');
                
                % Create EventList for ERPLab
                EEG  = pop_creabasiceventlist(EEG , 'AlphanumericCleaning', 'on', 'BoundaryNumeric', { -99 }, 'BoundaryString', { 'boundary' } );
                
                % Create Bins for different conditions
                EEG  = pop_binlister(EEG , 'BDF', [PATH_LIST '\bin_list_Exp23_Keep_Track_Mem.txt'], 'IndexEL',  1, 'SendEL2', 'Workspace&EEG', 'UpdateEEG', 'on', 'Voutput', 'EEG' );
                EEG.setname = ['Keep_Track_Mem_' num2str(i) '_bin'];
                
                % Epoch data
                EEG = pop_epochbin( EEG , [-200.0  1000.0],  [ -200 0]);
                EEG.setname = ['Keep_Track_Mem_' num2str(i) '_bin_epoch'];
                
                % Compute ERPs for the different bins
                ERP = pop_averager( EEG , 'Criterion', 'all', 'ExcludeBoundary', 'off', 'SEM', 'on' );
                ERP.erpname = ['Keep_Track_Mem_' num2str(i) '_bin_average'];

                % Save ERP set to
                ERP = pop_savemyerp(ERP, 'erpname', ERP.erpname, 'filename', ['Keep_Track_Mem_' num2str(i) '.erp'], 'filepath', PATH_ERP);
            else
                NotExistingFile_ERP(p) = i;
                p = p + 1;
            end   
        end
        csvwrite([PATH_MAIN 'Keep_Track_Mem_count_trials_in_bnis.csv'], count_trials)
