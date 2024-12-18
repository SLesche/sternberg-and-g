% This function generates a trial list from the specified Trial
% configurations in the expinfo. Alternatively, we can specify the Trial
% configurations here if there is more complex things to do...

function [Trial] = MakeTrial(expinfo, isPractice, expBlock)
%% specify Trial configurations
trial = 1;
TrialConfigurations = [];
for i = 1:expinfo.Trial2Cond
    for Category = 1:length(expinfo.Category)
        for Stim2Category = 1:length(expinfo.Stim2Category)
            for Updating = 1:length(expinfo.Updating)
                for Match = 1:length(expinfo.Match)
                    TrialConfigurations(trial,1) = expinfo.Category(Category);
                    TrialConfigurations(trial,2) = expinfo.Stim2Category(Stim2Category);
                    TrialConfigurations(trial,3) = expinfo.Updating(Updating);
                    TrialConfigurations(trial,4) = expinfo.Match(Match);
                    trial = trial + 1;
                end
            end
        end
    end
end

% Delete Variables that are no longer needed
clearvars trial 

if  isPractice == 1
    nTrials = expinfo.nPracTrials;
else
    nTrials = expinfo.nExpTrials;
end
    trialsSelected = 0;
    maxIter = 1000; % Specify maximum number of allowed iterations
    while trialsSelected ~= nTrials
        trialsSelected = 0;
        TrialMatrix = zeros(nTrials,size(TrialConfigurations,2));
        SampleMatrix = TrialConfigurations;
        for trial = 1:nTrials
            test = 0;
            iter = 0;
            while test == 0
                RandRow = randsample(size(SampleMatrix,1),1);
                if trial < 4
                    test = 1;
                else
                    if SampleMatrix(RandRow,1)~= TrialMatrix (trial-1, 1) || SampleMatrix(RandRow,1)~= TrialMatrix (trial-2, 1) || SampleMatrix(RandRow,1)~= TrialMatrix (trial-3, 1)
                        CategoryTest = 1;
                    else
                        DistCategoryTest  = 0;
                    end
                    if SampleMatrix(RandRow,3)~= TrialMatrix (trial-1, 3) || SampleMatrix(RandRow,3)~= TrialMatrix (trial-2, 3) || SampleMatrix(RandRow,3)~= TrialMatrix (trial-3, 3)
                        UpdatingTest = 1;
                    else
                        UpdatingTest  = 0;
                    end
                    if SampleMatrix(RandRow,4)~= TrialMatrix (trial-1, 4) || SampleMatrix(RandRow,4)~= TrialMatrix (trial-2, 4) || SampleMatrix(RandRow,4)~= TrialMatrix (trial-3, 4)
                        MatchTest = 1;
                    else
                        MatchTest = 0;
                    end
                    if CategoryTest && UpdatingTest && MatchTest == 1
                        test = 1;
                    else
                        test = 0;
                    end
                end
                iter = iter + 1;
                if iter > maxIter
                    break
                end
            end
            
            if test == 1
                TrialMatrix(trial,:) = SampleMatrix(RandRow,:);
                SampleMatrix(RandRow,:) = [];
                trialsSelected = trialsSelected + 1;
            else
                break
            end
        end
    end
%%    
for trial = 1:nTrials
    if isPractice == 1 
        Trial(trial).Block = expBlock*10+1;
    else
        Trial(trial).Block = expBlock;
    end
   
    if Trial(trial).Block == 11 || Trial(trial).Block == 1
      Trial(trial).MemSetSize = 1;
    else
      Trial(trial).MemSetSize = 3;
    end
    
    Trial(trial).TrialNum = trial;
    Trial(trial).Category = TrialMatrix(trial,1);
        if  Trial(trial).Category == 1
        Trial(trial).RelevantCategory = 'Figuren';
    elseif Trial(trial).Category == 2
        Trial(trial).RelevantCategory = 'Farben';
    elseif Trial(trial).Category == 3
        Trial(trial).RelevantCategory = 'Buchstaben';
    elseif Trial(trial).Category == 4
        Trial(trial).RelevantCategory = 'Zahlen';
        end    
        
    Trial(trial).StimInCategory = TrialMatrix(trial,2);
    
    if Trial(trial).Category == 1
        if Trial(trial).StimInCategory == 1
            Trial(trial).RelevantStim = 'Pfeil';
        elseif Trial(trial).StimInCategory == 2
            Trial(trial).RelevantStim = 'Dreieck';
        elseif Trial(trial).StimInCategory == 3
            Trial(trial).RelevantStim = 'Raute';
        elseif Trial(trial).StimInCategory == 4
            Trial(trial).RelevantStim = 'Kreis';
        elseif Trial(trial).StimInCategory == 5
            Trial(trial).RelevantStim = 'Fünfeck';
        elseif Trial(trial).StimInCategory == 6
            Trial(trial).RelevantStim = 'Stern' ;
        end
    elseif Trial(trial).Category == 2
        if Trial(trial).StimInCategory == 1
            Trial(trial).RelevantStim = 'grün';
        elseif Trial(trial).StimInCategory == 2
            Trial(trial).RelevantStim = 'rot';
        elseif Trial(trial).StimInCategory == 3
            Trial(trial).RelevantStim = 'gelb';
        elseif Trial(trial).StimInCategory == 4
            Trial(trial).RelevantStim = 'blau';
        elseif Trial(trial).StimInCategory == 5
            Trial(trial).RelevantStim = 'türkis';
        elseif Trial(trial).StimInCategory == 6
            Trial(trial).RelevantStim = 'pink' ;
        end        
    elseif Trial(trial).Category == 3
        if Trial(trial).StimInCategory == 1
            Trial(trial).RelevantStim = expinfo.Letters(1);
        elseif Trial(trial).StimInCategory == 2
            Trial(trial).RelevantStim = expinfo.Letters(2);
        elseif Trial(trial).StimInCategory == 3
            Trial(trial).RelevantStim = expinfo.Letters(3);
        elseif Trial(trial).StimInCategory == 4
            Trial(trial).RelevantStim = expinfo.Letters(4);
        elseif Trial(trial).StimInCategory == 5
            Trial(trial).RelevantStim = expinfo.Letters(5);
        elseif Trial(trial).StimInCategory == 6
            Trial(trial).RelevantStim =expinfo.Letters(6) ;
        end
    elseif Trial(trial).Category == 4
        if Trial(trial).StimInCategory == 1
            Trial(trial).RelevantStim = 1;
        elseif Trial(trial).StimInCategory == 2
            Trial(trial).RelevantStim = 2;
        elseif Trial(trial).StimInCategory == 3
            Trial(trial).RelevantStim = 3;
        elseif Trial(trial).StimInCategory == 4
            Trial(trial).RelevantStim = 4;
        elseif Trial(trial).StimInCategory == 5
            Trial(trial).RelevantStim = 5;
        elseif Trial(trial).StimInCategory == 6
            Trial(trial).RelevantStim = 6;
        end
    end
    
    if Trial(trial).Category ~= 4
    Trial(trial).RelevantStim = char(Trial(trial).RelevantStim);
    end
    
    Trial(trial).Updating = TrialMatrix(trial,3); % 0 = NoUpdating, 1 = Updating
    
    if TrialMatrix(trial,3)== 0
        Trial(trial).UpdatingDescription = 'NoUpdating';
    else
        Trial(trial).UpdatingDescription = 'Updating';
    end
    Trial(trial).Match = TrialMatrix(trial,4);  % 0 = NoMatch, 1 = Match

    if TrialMatrix(trial,4)== 0
        Trial(trial).MatchDescription = 'NoMatch';
    else
        Trial(trial).MatchDescription = 'Match';
    end
    
 % Position in the sequence at which the relevant stimulus appears
    if trial == 1 
        Trial(trial).Position = randsample(expinfo.Category,1);
    else
       NotSet = expinfo.Category;
       NotSet(Trial(trial-1).Position) = [];
       Trial(trial).Position = randsample(NotSet,1);
    end    
         % relevant category
    if Trial(trial).MemSetSize == 3
        OtherStimCategories = expinfo.Category(expinfo.Category ~= TrialMatrix(trial,1));
        Trial(trial).OtherStimCategories = randsample(OtherStimCategories,Trial(trial).MemSetSize-1);
    else
        Trial(trial).OtherStimCategories = [];
    end
    Trial(trial).MemCategories = [Trial(trial).Category Trial(trial).OtherStimCategories];

    if Trial(trial).MemSetSize == 1
        if Trial(trial).MemCategories == 1
            Trial(trial).WordMemCategory = 'Figuren';
        elseif Trial(trial).MemCategories == 2
            Trial(trial).WordMemCategory = 'Farben';
        elseif Trial(trial).MemCategories == 3
            Trial(trial).WordMemCategory = 'Buchstaben';
        elseif Trial(trial).MemCategories == 4
            Trial(trial).WordMemCategory = 'Zahlen';
        end
    else
        Sum1 = sum(Trial(trial).MemCategories);
        if Sum1 == 6
            Trial(trial).WordMemCategory  = {'Figuren' 'Farben' 'Buchstaben'};
        elseif  Sum1 == 7
            Trial(trial).WordMemCategory = {'Figuren' 'Farben' 'Zahlen'};
        elseif  Sum1 == 8
            Trial(trial).WordMemCategory = {'Figuren' 'Buchstaben' 'Zahlen'};
        elseif  Sum1 == 9
            Trial(trial).WordMemCategory = {'Farben' 'Buchstaben' 'Zahlen'};
        end
    end
    
     Trial(trial).WordMemCategory = string( Trial(trial).WordMemCategory);
    
    % category, which has not been updated
    if Trial(trial).Updating == 0
        Trial(trial).NoUpdatingCategory = Trial(trial).Category;
    else
        NotUpdating = expinfo.Category(expinfo.Category~= TrialMatrix(trial,1));
        Trial(trial).NoUpdatingCategory = randsample(NotUpdating,1);
    end
    
    if Trial(trial).NoUpdatingCategory == 1
       Trial(trial).NoUpdatingCategoryWord = 'Figuren';
    elseif Trial(trial).NoUpdatingCategory == 2
       Trial(trial).NoUpdatingCategoryWord = 'Farben';
    elseif Trial(trial).NoUpdatingCategory == 3
       Trial(trial).NoUpdatingCategoryWord = 'Buchstaben';
    else
       Trial(trial).NoUpdatingCategoryWord = 'Zahlen'; 
    end
        
    Trial(trial).UpdatingCategorys = expinfo.Category(expinfo.Category~= Trial(trial).NoUpdatingCategory);
     
   UpdatingCategorys = randsample(Trial(trial).UpdatingCategorys,length(expinfo.Category)-1);  
  
   k = 1;
   CategoryPos = [];
  % StimPos = [];
   for i = 1:length(expinfo.Category)
       if Trial(trial).Position == i
           CategoryPos =[CategoryPos Trial(trial).Category];
     %      StimPos =[StimPos Trial(trial).StimInCategory];
       else
           if Trial(trial).Updating == 1 && UpdatingCategorys(k) == Trial(trial).Category
               CategoryPos = [CategoryPos Trial(trial).NoUpdatingCategory];
    %           StimPos =[StimPos 99];  
           else
               CategoryPos = [CategoryPos UpdatingCategorys(k)];
   %            StimPos =[StimPos 99];
           end
           k = k+1;
       end
   end
   
   Trial(trial).CategoryPos = CategoryPos;
  % Trial(trial).StimPos = StimPos;
   
   UpdatingCategorys1 = randsample(Trial(trial).UpdatingCategorys,length(expinfo.Category)-1);
   Trial(trial).CategoryPos = [Trial(trial).CategoryPos UpdatingCategorys1];

% Determine which stimulus comes at which position (except for the relevant stimulus) 
      NotProbe = expinfo.Stim2Category(expinfo.Stim2Category ~= TrialMatrix(trial,2));   
   StimPos = [];
   for i = 1: expinfo.SetSize
       if i <= 4
           StimPos = [StimPos randsample(NotProbe,1)];
       else
           if Trial(trial).CategoryPos(i) ==  Trial(trial).CategoryPos(1)
              NotProbe1 = NotProbe(NotProbe ~=  StimPos(1));
              StimPos = [StimPos randsample(NotProbe1,1)];
               
           elseif Trial(trial).CategoryPos(i) ==  Trial(trial).CategoryPos(2)
                NotProbe1 = NotProbe(NotProbe ~=  StimPos(2));
              StimPos = [StimPos randsample(NotProbe1,1)];
               
           elseif Trial(trial).CategoryPos(i) ==  Trial(trial).CategoryPos(3)
                NotProbe1 = NotProbe(NotProbe ~=  StimPos(3));
              StimPos = [StimPos randsample(NotProbe1,1)];
               
           elseif Trial(trial).CategoryPos(i) ==  Trial(trial).CategoryPos(4)
                NotProbe1 = NotProbe(NotProbe ~=  StimPos(4));
              StimPos = [StimPos randsample(NotProbe1,1)];
           else
               StimPos = [StimPos randsample(NotProbe,1)];
           end
       end     
   end
   
% Insert the relevant stimulus
   if Trial(trial).Updating == 1 && Trial(trial).Match == 0
       StimPos(Trial(trial).Position) = Trial(trial).StimInCategory;
   elseif Trial(trial).Updating == 0 && Trial(trial).Match == 1
       StimPos(Trial(trial).Position) = Trial(trial).StimInCategory;
   elseif Trial(trial).Updating == 1 && Trial(trial).Match == 1
       for i = 5: expinfo.SetSize
           if Trial(trial).CategoryPos(i) == Trial(trial).Category
               StimPos(i) = Trial(trial).StimInCategory;
           end
       end
   else
       StimPos = StimPos;
   end
 Trial(trial).StimPos = StimPos;

% Determine the probe
 Trial(trial).Probe = Trial(trial).StimInCategory;
  
       if Trial(trial).Category == 1
        if Trial(trial).Probe == 1
            Trial(trial).ProbeDescr = 'Pfeil';
        elseif Trial(trial).Probe == 2
            Trial(trial).ProbeDescr = 'Dreieck';
        elseif Trial(trial).Probe == 3
            Trial(trial).ProbeDescr = 'Raute';
        elseif Trial(trial).Probe == 4
            Trial(trial).ProbeDescr = 'Kreis';
        elseif Trial(trial).Probe == 5
            Trial(trial).ProbeDescr = 'Fünfeck';
        elseif Trial(trial).Probe == 6
            Trial(trial).ProbeDescr = 'Stern' ;
        end
    elseif Trial(trial).Category == 2
        if Trial(trial).Probe == 1
            Trial(trial).ProbeDescr = 'grün';
        elseif Trial(trial).Probe == 2
            Trial(trial).ProbeDescr = 'rot';
        elseif Trial(trial).Probe == 3
            Trial(trial).ProbeDescr = 'gelb';
        elseif Trial(trial).Probe == 4
            Trial(trial).ProbeDescr = 'blau';
        elseif Trial(trial).Probe == 5
            Trial(trial).ProbeDescr = 'türkis';
        elseif Trial(trial).Probe == 6
            Trial(trial).ProbeDescr = 'pink' ;
        end        
    elseif Trial(trial).Category == 3
        if Trial(trial).Probe == 1
            Trial(trial).ProbeDescr = expinfo.Letters(1);
        elseif Trial(trial).Probe == 2
            Trial(trial).ProbeDescr = expinfo.Letters(2);
        elseif Trial(trial).Probe == 3
            Trial(trial).ProbeDescr = expinfo.Letters(3);
        elseif Trial(trial).Probe == 4
            Trial(trial).ProbeDescr = expinfo.Letters(4);
        elseif Trial(trial).Probe == 5
            Trial(trial).ProbeDescr = expinfo.Letters(5);
        elseif Trial(trial).Probe == 6
            Trial(trial).ProbeDescr =expinfo.Letters(6) ;
        end
    elseif Trial(trial).Category == 4
        if Trial(trial).Probe == 1
            Trial(trial).ProbeDescr = 1;
        elseif Trial(trial).Probe == 2
            Trial(trial).ProbeDescr = 2;
        elseif Trial(trial).Probe == 3
            Trial(trial).ProbeDescr = 3;
        elseif Trial(trial).Probe == 4
            Trial(trial).ProbeDescr = 4;
        elseif Trial(trial).Probe == 5
            Trial(trial).ProbeDescr = 5;
        elseif Trial(trial).Probe == 6
            Trial(trial).ProbeDescr = 6;
        end
       end
    
       if Trial(trial).Category ~= 4
       Trial(trial).ProbeDescr = char(Trial(trial).ProbeDescr);
       end
% Erstellen der Präsentationszeiten     
    Trial(trial).FIX1 = expinfo.MinFixduration + (rand(1)*expinfo.Fixjitter);
    Trial(trial).FIX2 = expinfo.MinFixduration + (rand(1)*expinfo.Fixjitter);
    Min_ISI = repmat(expinfo.MinISIduration,1,expinfo.SetSize);
    Jitter = rand(1,expinfo.SetSize);
    Trial(trial).ISI = Min_ISI+(Jitter*expinfo.ISIjitter);
    Trial(trial).CueDuration = expinfo.MinCueDuration + (rand(1)*expinfo.Cuejitter); % Time of "?"
    Trial(trial).ITI = expinfo.MinITIduration + (rand(1)*expinfo.ITIjitter);
    
    if Trial(trial).Match == 1 
        Trial(trial).CorResp = 'l';
    else
        Trial(trial).CorResp = 'd';
    end
    
% Marker for the EEG

    Trial(trial).FixMarker1 = expinfo.Marker.Fixation1(Trial(trial).Match+1,Trial(trial).Updating+1); 
    Trial(trial).FixMarker2 = expinfo.Marker.Fixation2(Trial(trial).Match+1,Trial(trial).Updating+1); 
    Trial(trial).ReminderMarker = expinfo.Marker.ReminderCategories(Trial(trial).Match+1,Trial(trial).Updating+1); 
    Trial(trial).ISIMarker = expinfo.Marker.ISI(Trial(trial).Match+1,Trial(trial).Updating+1); 
    Trial(trial).MemSetMarker = expinfo.Marker.MemSet(Trial(trial).Match+1,Trial(trial).Updating+1);   
    Trial(trial).CueMarker = expinfo.Marker.Cue(Trial(trial).Match+1,Trial(trial).Updating+1); 
    Trial(trial).TargetMarker = expinfo.Marker.Target(Trial(trial).Match+1,Trial(trial).Updating+1);

if isPractice == 1
    Trial(trial).TaskDescription = 'PracKeepTrackTask';
else
    Trial(trial).TaskDescription = 'ExpKeepTrackTask';
end
end
%% End of Function

