% This function generates a trial list from the specified Trial
% configurations in the expinfo. Alternatively, we can specify the Trial
% configurations here if there is more complex things to do...

function [Trial] = MakeTrial(expinfo, isPractice, expBlock)
%% specify Trial configurations

TrialMatrix = [];
for j = 1:4

TrialConfigurations = [];
 trial = 1;
for i = 1:expinfo.Trial2Cond
    for PositionsTarget = 1:length(expinfo.PositionsTarget)
        for PositionsDistractor = 1: length(expinfo.PositionsDistractor)
            for  Priming = 1: length(expinfo.Priming)
                TrialConfigurations(trial,1) = expinfo.PositionsTarget(PositionsTarget);
                TrialConfigurations(trial,2) = expinfo.PositionsDistractor(PositionsDistractor);
                TrialConfigurations(trial,3) = expinfo.Priming (Priming);
                trial = trial + 1;
            end
        end
    end
end
 for i =length(TrialConfigurations):-1:1
   if TrialConfigurations(i,1) == TrialConfigurations(i,2)
      TrialConfigurations(i,:) = [];
   end
 end
 
%% Resort Trial Configurations
% Delete Variables that are no longer needed
clearvars trial
trialsSelected = 0;
maxIter = 1000; % Specify maximum number of allowed iterations
if isPractice == 1
    nTrials = expinfo.nPracTrials;
else
    nTrials = expinfo.nExpTrials/4;
end

while trialsSelected ~= nTrials
    trialsSelected = 0;
    TrialMatrix1 = zeros(nTrials,size(TrialConfigurations,2));
    SampleMatrix = TrialConfigurations;
    
    for trial = 1:nTrials
        test = 0;
        iter = 0;
        while test == 0
            RandRow = randsample(size(SampleMatrix,1),1);
            if trial == 1
                if  SampleMatrix(RandRow,3) == 1
                    test1 = 1;
                else
                    test1 = 0;
                end
                
                if j == 1 || j == 2 && SampleMatrix(RandRow,1) ~= TrialMatrix(length(TrialMatrix),2) || j == 3 && SampleMatrix(RandRow,1) ~= TrialMatrix(length(TrialMatrix),2) || j == 4 && SampleMatrix(RandRow,1) ~= TrialMatrix(length(TrialMatrix),2)
                    test2 = 1;
                else
                    test2 = 0;
                end
                
                if test1 == 1 && test2 == 1
                    test = 1;
                else
                    test = 0;
                end
                
            elseif  trial > 1 && trial < 4
                if  SampleMatrix(RandRow,3) == 2 && SampleMatrix(RandRow,1)== TrialMatrix1 (trial-1, 2) || SampleMatrix(RandRow,3) == 1 && SampleMatrix(RandRow,1) ~= TrialMatrix1 (trial-1, 2)
                    test = 1;
                else
                    test = 0;
                end
                
            else
                if  SampleMatrix(RandRow,3) == 2 && SampleMatrix(RandRow,1)== TrialMatrix1 (trial-1, 2)  || SampleMatrix(RandRow,3) == 1 && SampleMatrix(RandRow,1) ~= TrialMatrix1 (trial-1, 2)
                    PrimingTest = 1;
                else
                    PrimingTest = 0;
                end
                
                if SampleMatrix(RandRow,1)~= TrialMatrix1 (trial-1, 1)  || SampleMatrix(RandRow,1)~= TrialMatrix1 (trial-2, 1)  || SampleMatrix(RandRow,1)~= TrialMatrix1 (trial-3, 1)
                    TargetTest = 1;
                else
                    TargetTest = 0;
                end
                
                if SampleMatrix(RandRow,2)~= TrialMatrix1 (trial-1, 2) || SampleMatrix(RandRow,2)~= TrialMatrix1 (trial-2, 2)  || SampleMatrix(RandRow,2)~= TrialMatrix1 (trial-3, 2)
                    DistractorTest = 1;
                else
                    DistractorTest = 0;
                end
                
                if SampleMatrix(RandRow,3)~= TrialMatrix1 (trial-1, 3) || SampleMatrix(RandRow,3)~= TrialMatrix1 (trial-2, 3) || SampleMatrix(RandRow,3)~= TrialMatrix1 (trial-3, 3)
                    ConditionTest = 1;
                else
                    ConditionTest = 0;
                end
                
                if PrimingTest == 1 && TargetTest == 1 && DistractorTest == 1  && ConditionTest == 1
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
            TrialMatrix1(trial,:) = SampleMatrix(RandRow,:);
            SampleMatrix(RandRow,:) = [];
            trialsSelected = trialsSelected + 1;
        else
            break
        end
    end
    
end
  TrialMatrix = [TrialMatrix;TrialMatrix1];
   
end


%% Specify all information for each trial

if isPractice == 0
    nTrials = expinfo.nExpTrials;
end

for trial = 1:nTrials
    
    if isPractice == 1
        Trial(trial).Block = 0;
    else
        Trial(trial).Block = expBlock;
    end
    
    Trial(trial).TrialNum = trial;
    Trial(trial).PositionTarget = TrialMatrix(trial,1);
    Trial(trial).PositionDistractor = TrialMatrix(trial,2);
    Trial(trial).Condition = TrialMatrix(trial,3);

    if  TrialMatrix(trial,1) == 1
         Trial(trial).XTarget = expinfo.centerX - 106.5;
    elseif TrialMatrix(trial,1) == 2
         Trial(trial).XTarget = expinfo.centerX - 35.5;
    elseif TrialMatrix(trial,1) == 3
         Trial(trial).XTarget = expinfo.centerX + 35.5;
    elseif TrialMatrix(trial,1) == 4
         Trial(trial).XTarget = expinfo.centerX + 106.5;
    end
    
        if  TrialMatrix(trial,2) == 1
         Trial(trial).XDistractor = expinfo.centerX - 106.5;
    elseif TrialMatrix(trial,2) == 2
         Trial(trial).XDistractor = expinfo.centerX - 35.5;
    elseif TrialMatrix(trial,2) == 3
         Trial(trial).XDistractor = expinfo.centerX + 35.5;
    elseif TrialMatrix(trial,2) == 4
         Trial(trial).XDistractor = expinfo.centerX + 106.5;
    end
    
    if TrialMatrix(trial,3)== 1
        Trial(trial).ConditionDescr = 'NoPriming';
    else
        Trial(trial).ConditionDescr = 'Priming';
    end
           
   Trial(trial).FIX = expinfo.MinFixduration + (rand(1)*expinfo.Fixjitter);
   Trial(trial).ISI = expinfo.MinISIduration + (rand(1)*expinfo.ISIjitter);
   Trial(trial).ITI = expinfo.MinITIduration + (rand(1)*expinfo.ITIjitter);
    
    if Trial(trial).PositionTarget == 1 
        Trial(trial).CorResp = 's';
    elseif Trial(trial).PositionTarget == 2 
        Trial(trial).CorResp = 'f';
    elseif Trial(trial).PositionTarget == 3 
        Trial(trial).CorResp = 'h';
    elseif Trial(trial).PositionTarget == 4 
        Trial(trial).CorResp = 'k';
    end
    
    Trial(trial).FixMarker = expinfo.Marker.Fixation(Trial(trial).Condition);
    Trial(trial).ISIMarker = expinfo.Marker.ISI(Trial(trial).Condition);
    Trial(trial).StimulusMaker = expinfo.Marker.Stimulus(Trial(trial).Condition);    

    if isPractice == 1
    Trial(trial).TaskDescription = 'PracNegativePriming';
    else
    Trial(trial).TaskDescription = 'ExpNegativePriming';
    end
end

% Now we have a MATLAB Structure with as many fields as trials and the
% different variables contain all relevant information of the trials.
end
%% End of Function
