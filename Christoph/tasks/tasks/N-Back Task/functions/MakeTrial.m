
% This function generates a trial list from the specified Trial
% configurations in the expinfo. Alternatively, we can specify the Trial
% configurations here if there is more complex things to do...

function [Trial] = MakeTrial(expinfo, isPractice, expBlock)
%% specify Trial configurations

if expBlock ==1
    expinfo.Trial2Cond = 48;
else
    expinfo.Trial2Cond = 12;
end

if expBlock ==1 % Block 1 
    StimOrders = perms(1:4);
    length(StimOrders);
    TargetStim = StimOrders(mod(expinfo.subject,length(StimOrders))+1,:);
    expinfo.CurrentTargetStim = TargetStim(1,1);
    
    TrialConfigurations = [];
    trial = 1;
    for i = 1:expinfo.Trial2Cond
        for Matches = 1:length(expinfo.Match)
            TrialConfigurations(trial,1) = 0;
            TrialConfigurations(trial,2) = expinfo.Match(Matches);
            trial = trial + 1;
        end
    end
    
    NonTargetStim = StimOrders(mod(expinfo.subject,length(StimOrders))+1,:);
    expinfo.CurrentNonTargetStim = NonTargetStim(1,2);
    trial = 1;
    for j = 1: length(TrialConfigurations)
        if TrialConfigurations(trial,2) == 1
            TrialConfigurations(trial,1) = expinfo.CurrentTargetStim;
        else
            TrialConfigurations(trial,1) = expinfo.CurrentNonTargetStim;
        end
        trial = trial + 1;
    end
    
elseif expBlock ==2 % Block 2 
    
    TrialConfigurations = [];
    Digit = randsample(expinfo.Digits,1);
    TrialConfigurations(1,1) = Digit;
    TrialConfigurations(1,2) = 0;
    trial = 2;
    for i = 1:expinfo.Trial2Cond
        for Stimulus = 1:length(expinfo.Digits)
            for Matches = 1:length(expinfo.Match)
                TrialConfigurations(trial,1) = expinfo.Digits(Stimulus);
                TrialConfigurations(trial,2) = expinfo.Match(Matches);
                trial = trial + 1;
            end
        end
    end
    
elseif expBlock ==3 % Block 3 
    
    TrialConfigurations = [];
    Digit1 = randsample(expinfo.Digits,1);
    TrialConfigurations(1,1) = Digit1;
    TrialConfigurations(1,2) = 0;
    Digit2 = randsample(expinfo.Digits,1);
    TrialConfigurations(2,1) = Digit2;
    TrialConfigurations(2,2) = 0;
    trial = 3;
    for i = 1:expinfo.Trial2Cond
        for Stimulus = 1:length(expinfo.Digits)
            for Matches = 1:length(expinfo.Match)
                TrialConfigurations(trial,1) = expinfo.Digits(Stimulus);
                TrialConfigurations(trial,2) = expinfo.Match(Matches);
                trial = trial + 1;
            end
        end
    end
end
%% Resort Trial Configurations
% Delete Variables that are no longer needed
clearvars trial
trialsSelected = 0;
maxIter = 1000; % Specify maximum number of allowed iterations

if  isPractice == 1
    nTrials = expinfo.nPracTrials;
else
    nTrials = expinfo.nExpTrials;
end

while trialsSelected ~= nTrials
    trialsSelected = 0;
    TrialMatrix = zeros(nTrials,size(TrialConfigurations,2));
    SampleMatrix = TrialConfigurations;
    
    if expBlock == 1 % Block 1
        for trial = 1:nTrials
            test = 0;
            iter = 0;
            while test == 0
                RandRow = randsample(size(SampleMatrix,1),1);
                if trial < 4
                    test =1;
                else
                    if SampleMatrix(RandRow,2)~= TrialMatrix (trial-1, 2) || SampleMatrix(RandRow,2)~= TrialMatrix (trial-2, 2) || SampleMatrix(RandRow,2)~= TrialMatrix (trial-3, 2)
                        test = 1;
                    else
                        test =0;
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
        
    elseif expBlock == 2 % Block 2
        TrialMatrix(1,:) = SampleMatrix(1,:);
        SampleMatrix(1,:) = [];
        trialsSelected = 1;
        for trial = 2:nTrials
            test = 0;
            iter = 0;
            while test == 0
                toss = rand;
                RandRow = randsample(size(SampleMatrix,1),1);
                if  isPractice == 0
                    if trial < 49
                        if toss <.70
                            go = 0;
                            while go == 0
                                if SampleMatrix(RandRow,2) == 2
                                    RandRow = randsample(size(SampleMatrix,1),1);
                                else
                                    go = 1;
                                end
                            end
                        end
                    end
                end
                if  trial < 4
                    if  SampleMatrix(RandRow,2) == 1 && SampleMatrix(RandRow,1)== TrialMatrix (trial-1, 1) || SampleMatrix(RandRow,2) == 2 && SampleMatrix(RandRow,1) ~= TrialMatrix (trial-1, 1)
                        test = 1;
                    else
                        test = 0;
                    end
                    
                else
                    if  SampleMatrix(RandRow,2) == 1 && SampleMatrix(RandRow,1)== TrialMatrix (trial-1, 1)  || SampleMatrix(RandRow,2) == 2 && SampleMatrix(RandRow,1) ~= TrialMatrix (trial-1, 1)
                        NBacktest = 1;
                    else
                        NBacktest = 0;
                    end
                    
                    if SampleMatrix(RandRow,2)~= TrialMatrix (trial-1, 2) || SampleMatrix(RandRow,2)~= TrialMatrix (trial-2, 2)  || SampleMatrix(RandRow,2)~= TrialMatrix (trial-3, 2)
                        Matchtest = 1;
                    else
                        Matchtest = 0;
                    end
                    
                    if SampleMatrix(RandRow,1)~= TrialMatrix (trial-1, 1) || SampleMatrix(RandRow,1)~= TrialMatrix (trial-2, 1) || SampleMatrix(RandRow,1)~= TrialMatrix (trial-3, 1)
                        Itemtest = 1;
                    else
                        Itemtest = 0;
                    end
                    
                    if NBacktest == 1 && Matchtest == 1 &&  Itemtest == 1
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
        
    elseif expBlock == 3 % Block 3 
        TrialMatrix(1,:) = SampleMatrix(1,:);
        TrialMatrix(2,:) = SampleMatrix(2,:);
        SampleMatrix(1,:) = [];
        SampleMatrix(1,:) = [];
        trialsSelected = 2;
        for trial = 3 :nTrials
            test = 0;
            iter = 0;
            while test == 0
                toss = rand;
                RandRow = randsample(size(SampleMatrix,1),1);
                if  isPractice == 0
                    if trial < 49
                        if toss <.70
                            go = 0;
                            while go == 0
                                if SampleMatrix(RandRow,2) == 2
                                    RandRow = randsample(size(SampleMatrix,1),1);
                                else
                                    go = 1;
                                end
                            end
                        end
                    end
                end
                if  trial < 4
                    if  SampleMatrix(RandRow,2) == 1 && SampleMatrix(RandRow,1)== TrialMatrix (trial-2, 1) || SampleMatrix(RandRow,2) == 2 && SampleMatrix(RandRow,1) ~= TrialMatrix (trial-2, 1)
                        test = 1;
                    else
                        test = 0;
                    end
                    
                else
                    if  SampleMatrix(RandRow,2) == 1 && SampleMatrix(RandRow,1)== TrialMatrix (trial-2, 1)  || SampleMatrix(RandRow,2) == 2 && SampleMatrix(RandRow,1) ~= TrialMatrix (trial-2, 1)
                        NBacktest = 1;
                    else
                        NBacktest = 0;
                    end
                    
                    if SampleMatrix(RandRow,2)~= TrialMatrix (trial-1, 2) || SampleMatrix(RandRow,2)~= TrialMatrix (trial-2, 2)  || SampleMatrix(RandRow,2)~= TrialMatrix (trial-3, 2)
                        Matchtest = 1;
                    else
                        Matchtest = 0;
                    end
                    
                    if SampleMatrix(RandRow,1)~= TrialMatrix (trial-1, 1) || SampleMatrix(RandRow,1)~= TrialMatrix (trial-2, 1) || SampleMatrix(RandRow,1)~= TrialMatrix (trial-3, 1)
                        Itemtest = 1;
                    else
                        Itemtest = 0;
                    end
                    
                    if NBacktest == 1 && Matchtest == 1  &&  Itemtest == 1
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
end

%% Specify all information for each trial
for trial = 1:nTrials
    if isPractice == 1
        Trial(trial).Block = expBlock*10+expBlock;
    else
        Trial(trial).Block = expBlock;
    end
    Trial(trial).TrialNum = trial;
    if expBlock == 1 
        Trial(trial).Target = expinfo.CurrentTargetStim;
        Trial(trial).NonTarget = expinfo.CurrentNonTargetStim;
    end
    
    if Trial(trial).Block == 1 || Trial(trial).Block == 11
        Trial(trial).NBackSteps = 0;
    elseif Trial(trial).Block == 2 || Trial(trial).Block == 22
        Trial(trial).NBackSteps = 1;
    else
        Trial(trial).NBackSteps = 3;
    end
    
    Trial(trial).Digits = TrialMatrix(trial,1);
    Trial(trial).Stimuli = expinfo.Letters{TrialMatrix(trial,1)};
    Trial(trial).Match = TrialMatrix(trial,2);
    
    if TrialMatrix(trial,2)~= 1 
        Trial(trial).MatchDescription = 'NoMatch';
    else
        Trial(trial).MatchDescription = 'Match';
    end
  
    if trial == 1
        Trial(trial).FIX = expinfo.MinFixduration;
    else
        Trial(trial).FIX = 0;
    end
    
   Trial(trial).ISI = expinfo.MinISIduration+(rand(1)*expinfo.ISIjitter);
    
    if Trial(trial).Match == 1 
        Trial(trial).CorResp = 'l';
    else
        Trial(trial).CorResp = 'd';
    end
    
if trial == 1 
   Trial(trial).FixMarker = expinfo.Marker.Fixation ;
else
   Trial(trial).FixMarker = expinfo.Marker.Zero; 
end
    
if  expBlock == 2 && trial == 1 || expBlock == 3 && trial < 3 
    Trial(trial).ISIMarker = expinfo.Marker.Zero;
    Trial(trial).StimMarker = expinfo.Marker.Zero;   
else
    Trial(trial).ISIMarker = expinfo.Marker.ISI(Trial(trial).Match);
    Trial(trial).StimMarker = expinfo.Marker.Stimulus(Trial(trial).Match);
end


if isPractice == 1
    Trial(trial).TaskDescription = ['PracN-Back_',num2str(Trial(trial).NBackSteps),'Back'];
else
    Trial(trial).TaskDescription = ['ExpN-Back_',num2str(Trial(trial).NBackSteps),'Back'];
end

if  expBlock == 2 && trial == 1 || expBlock == 3 && trial < 3 
    Trial(trial).ACC = -5;
    Trial(trial).RT = -5;  
    Trial(trial).response = -5;  
end

% Now we have a MATLAB Structure with as many fields as trials and the
% different variables contain all relevant information of the trials.
end
%% End of Function