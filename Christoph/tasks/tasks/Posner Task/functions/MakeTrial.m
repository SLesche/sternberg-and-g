% This function generates a trial list from the specified Trial
% configurations in the expinfo. Alternatively, we can specify the Trial
% configurations here if there is more complex things to do...

function [Trial] = MakeTrial(expinfo, isPractice, expBlock)

%% Resort Trial Configurations
TrialConfigurations1 = [];
trial = 1;

for LettersLeft = 1:length(expinfo.LettersLeft)
    for Conditions = 1:length(expinfo.Conditions)
        TrialConfigurations1(trial,1) = expinfo.LettersLeft(LettersLeft);
        TrialConfigurations1(trial,2) = expinfo.Conditions(Conditions);
        trial = trial + 1;
    end
end

if expinfo.Task  == 0 % Create the PI condition twice
    k = 31;
    for i = 1:length(TrialConfigurations1) 
        if TrialConfigurations1(i,2)== 1
            TrialConfigurations1(k,:) = TrialConfigurations1(i,:);
            k = k + 1;
        end
    end
else  % Create the condition, which is not NI or PI  twice
    k = 31;
    for i = 1:length(TrialConfigurations1)
        if TrialConfigurations1(i,2)== 3
            TrialConfigurations1(k,:) = TrialConfigurations1(i,:);
            k = k + 1;
        end
    end
end

TrialConfigurations = [];
for i = 1: expinfo.Trial2Cond
TrialConfigurations = [ TrialConfigurations; TrialConfigurations1]; 
end

% create further varaible, depending on the task and conditions (PI, NI, both)

 for i = 1:length(TrialConfigurations) 
     if expinfo.Task == 0 %  PI
        if TrialConfigurations(i,2)== 1 
            TrialConfigurations(i,3) = 1;
        else
          TrialConfigurations(i,3) = 2;   
        end
     else % NI
        if TrialConfigurations(i,2)== 1 || TrialConfigurations(i,2)== 2 
            TrialConfigurations(i,3) = 1;
        else
          TrialConfigurations(i,3) = 2;   
        end
     end
 end


%% Resortieren der Trials
if isPractice == 1 
    nTrials = expinfo.nPracTrials;
else
    nTrials = expinfo.nExpTrials;
end

clearvars trial 
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
                        if SampleMatrix(RandRow,3)~= TrialMatrix (trial-1, 3) || SampleMatrix(RandRow,3)~= TrialMatrix (trial-2, 3) || SampleMatrix(RandRow,3)~= TrialMatrix (trial-3, 3)
                            MatchTest = 1;
                        else
                            MatchTest = 0;
                        end
                        if SampleMatrix(RandRow,1)~= TrialMatrix (trial-1, 1) || SampleMatrix(RandRow,1)~= TrialMatrix (trial-2, 1) || SampleMatrix(RandRow,1)~= TrialMatrix (trial-3, 1)
                            LeftTest = 1;
                        else
                            LeftTest = 0;
                        end
                        if MatchTest == 1 && LeftTest == 1
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
    
%% Random selection of letters if the left and right are not physical or namely identical 

test = 0;
MaxIter = 1000;
iter = 1;
while test == 0
    Sample = randsample(expinfo.LettersRight,10);
    if Sample(1) ~= 1 && Sample(6) ~= 1 && Sample(1) ~= 6 && Sample(6) ~= 6
        Test1 = 1;
    else
        Test1 = 0;
    end
    if Sample(2) ~= 2  && Sample(7) ~= 2 && Sample(2) ~= 7 && Sample(7) ~= 7
        Test2 = 1;
    else
        Test2 = 0;
    end
    if  Sample(3) ~= 3  && Sample(8) ~= 3 && Sample(3) ~= 8 && Sample(8) ~= 8
        Test3 = 1;
    else
        Test3 = 0;
    end
    if Sample(4) ~= 4  && Sample(9) ~= 4 && Sample(4) ~= 9 && Sample(9) ~= 9
        Test4 = 1;
    else
        Test4 = 0;
    end
    if  Sample(5) ~= 5  && Sample(10) ~= 5 && Sample(5) ~= 10 && Sample(10) ~= 10
        Test5 = 1;
    else
        Test5 = 0;
    end
    
    if Test1 == 1 && Test2 == 1 && Test3 == 1 && Test4 == 1 && Test5 == 1
        test = 1;
    else
        test = 0;
    end
    iter = iter+1;
    
    if iter > MaxIter
        break
    end    
end

   
%% make the trail object
for trial = 1:nTrials
    if isPractice == 1
        Trial(trial).Block = 0;
    else
        Trial(trial).Block = expBlock;
    end
    
    Trial(trial).TrialNum = trial;
    Trial(trial).NumLetterLeft = TrialMatrix(trial,1);
    
    Trial(trial).NumCondition = TrialMatrix(trial,2);
    if  Trial(trial).NumCondition == 1
        Trial(trial).Condition = 'PI';
    elseif Trial(trial).NumCondition == 2
        Trial(trial).Condition = 'NI';
    elseif Trial(trial).NumCondition == 3
        Trial(trial).Condition = 'Dif';
    end
    
    Trial(trial).TaskConditions = TrialMatrix(trial,3);
    
    Trial(trial).Task = expinfo.Task;
    if Trial(trial).Task == 0
        Trial(trial).TaskDescription = 'PhysicalIdentity';
    else
        Trial(trial).TaskDescription = 'NameIdentity';
    end
   
    Trial(trial).LetterLeft = expinfo.LetterStrings{TrialMatrix(trial,1)};  
    
    if TrialMatrix(trial,2) == 1
        Trial(trial).NumLetterRight = TrialMatrix(trial,1);
    elseif TrialMatrix(trial,2) == 2
        if TrialMatrix(trial,1) <= 5
            Trial(trial).NumLetterRight = TrialMatrix(trial,1)+5;
        else
            Trial(trial).NumLetterRight = TrialMatrix(trial,1)-5;
        end
    elseif TrialMatrix(trial,2) == 3
     Trial(trial).NumLetterRight = Sample(TrialMatrix(trial,1));   
    end
    Trial(trial).LetterRight = expinfo.LetterStrings{Trial(trial).NumLetterRight}; 
    
    Trial(trial).ProbeStim = [Trial(trial).LetterLeft Trial(trial).LetterRight];
      
    Trial(trial).FIX = expinfo.Fix_Duration+rand(1)*expinfo.Fix_jitter;
    Trial(trial).ITI = expinfo.MinITIduration+rand(1)*expinfo.ITIjitter;
    
    Trial(trial).FixMarker = expinfo.Marker.Fixation(Trial(trial).NumCondition,1);
    Trial(trial).ProbeStimMaker = expinfo.Marker.Target(Trial(trial).NumCondition,1);

    if Trial(trial).TaskConditions == 1 
        Trial(trial).CorResp = 'l';
    else
        Trial(trial).CorResp = 'd';
    end

    if  isPractice == 1 && expinfo.Task == 0
        Trial(trial).TaskDescription = 'PracPosnerPI';
    elseif isPractice == 1 && expinfo.Task == 1
        Trial(trial).TaskDescription = 'PracPosnerNI';
    elseif isPractice == 0 && expinfo.Task == 0
        Trial(trial).TaskDescription = 'ExpPosnerPI';
    elseif isPractice == 0 && expinfo.Task == 1
        Trial(trial).TaskDescription = 'ExpPosnerNI';
    end
end
 
% Now we have a MATLAB Structure with as many fields as trials and the
% different variables contain all relevant information of the trials.
end
%% End of Function
