% This function generates a trial list from the specified Trial
% configurations in the expinfo. Alternatively, we can specify the Trial
% configurations here if there is more complex things to do...

function [Trial] = MakeTrial(expinfo, isPractice, PracBlock, expBlock)
%% specify Trial configurations

% Specify the number of trials to be drawn
if isPractice == 1 && PracBlock == 3
    nTrials = (expinfo.nPracTrials)*2;
elseif isPractice == 1 && PracBlock ~= 3
    nTrials = expinfo.nPracTrials;
else
    nTrials = expinfo.nExpTrials;
end

% Create Matrix with all possible TrialConfigurations according to the
% predefined information of the task
if PracBlock == 1 || PracBlock == 2
    n = 1;
else
    n = [1 2];
end
if PracBlock == 1 || PracBlock == 2
    m = 1;
else
    m = [1 2];
end

TrialConfigurations = [];
trial = 1;
for i = 1:expinfo.Trial2Cond
    for Numbers = 1:length(expinfo.Numbers)
        for Task = 1:length(n)
            for Shifting = 1: length(m)
                TrialConfigurations(trial,1) = expinfo.Numbers(Numbers);
                if isPractice == 1 && PracBlock == 1
                    TrialConfigurations(trial,2) = 1;
                elseif isPractice == 1 && PracBlock == 2
                    TrialConfigurations(trial,2) = 2;
                else
                    TrialConfigurations(trial,2) = expinfo.Task(Task);
                end
                
                if isPractice == 1 && PracBlock == 1
                    TrialConfigurations(trial,3) = 0;
                elseif isPractice == 1 && PracBlock == 2
                    TrialConfigurations(trial,3) = 0;
                else
                    TrialConfigurations(trial,3) = expinfo.Shifting(Shifting);
                end
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
    while trialsSelected ~= nTrials
        trialsSelected = 0;
        TrialMatrix = zeros(nTrials,size(TrialConfigurations,2));
        SampleMatrix = TrialConfigurations;
        
        for trial = 1:nTrials
            test = 0;
            iter = 0;
            while test == 0
                RandRow = randsample(size(SampleMatrix,1),1);
                if isPractice == 1 && PracBlock == 1
                    if trial == 1
                        if SampleMatrix(RandRow,2) == 1 && SampleMatrix(RandRow,3) == 0
                            test = 1;
                        end                        
                    else
                        if SampleMatrix(RandRow,2) == 1 && SampleMatrix(RandRow,3) == 0
                            PracTest = 1;
                        else
                            PracTest = 0;
                        end
                        if SampleMatrix(RandRow,1) ~= TrialMatrix(trial-1,1)
                            StimTest = 1;
                        else
                            StimTest = 0;
                        end
                        if PracTest == 1 && StimTest == 1
                            test = 1;
                        else
                            test = 0;
                        end
                    end
                elseif isPractice == 1 && PracBlock == 2
                    if trial == 1
                        if SampleMatrix(RandRow,2) == 2 && SampleMatrix(RandRow,3) == 0
                            test = 1;
                        end
                    else
                        if SampleMatrix(RandRow,2) == 2 && SampleMatrix(RandRow,3) == 0
                            PracTest = 1;
                        else
                            PracTest = 0;
                        end
                        if SampleMatrix(RandRow,1) ~= TrialMatrix(trial-1,1)
                            StimTest = 1;
                        else
                            StimTest = 0;
                        end
                        if PracTest == 1 && StimTest == 1
                            test = 1;
                        else
                            test = 0;
                        end
                    end                    
                else
                    if trial == 1
                        if SampleMatrix(RandRow,3) == 0
                            test = 1;
                        end                                                                     
                    elseif trial > 1 && trial < 4
                        if SampleMatrix(RandRow,1) ~= TrialMatrix(trial-1,1)
                            StimTest = 1;
                        else
                            StimTest = 0;
                        end
                        if SampleMatrix(RandRow,3) == 0 && SampleMatrix(RandRow,2) == TrialMatrix(trial-1,2)
                            ShiftTest = 1;
                        elseif SampleMatrix(RandRow,3) == 1 && SampleMatrix(RandRow,2) ~= TrialMatrix(trial-1,2)
                            ShiftTest = 1;
                        else
                            ShiftTest = 0;
                        end                        
                        if ShiftTest == 1 && StimTest == 1
                            test = 1;
                        else
                            test = 0;
                        end
                    else                        
                        if SampleMatrix(RandRow,1) ~= TrialMatrix(trial-1,1)
                            StimTest = 1;
                        else
                            StimTest = 0;
                        end
                        if SampleMatrix(RandRow,3) == 0 && SampleMatrix(RandRow,2) == TrialMatrix(trial-1,2)
                            ShiftTest = 1;
                        elseif SampleMatrix(RandRow,3) == 1 && SampleMatrix(RandRow,2) ~= TrialMatrix(trial-1,2)
                            ShiftTest = 1;
                        else
                            ShiftTest = 0;
                        end
                        
                        if SampleMatrix(RandRow,2)~= TrialMatrix(trial-1,2) || SampleMatrix(RandRow,2)~= TrialMatrix(trial-2,2) || SampleMatrix(RandRow,2)~= TrialMatrix (trial-3,2)
                            TaskTest = 1;
                        else
                            TaskTest = 0;
                        end
                        
                        
                        if SampleMatrix(RandRow,3)~= TrialMatrix(trial-1,3) || SampleMatrix(RandRow,3)~= TrialMatrix(trial-2,3) || SampleMatrix(RandRow,3)~= TrialMatrix (trial-3,3)
                            ShiftTest2 = 1;
                        else
                            ShiftTest2 = 0;
                        end
                        
                        if StimTest == 1 && TaskTest == 1 && ShiftTest == 1 && ShiftTest2 == 1
                            test = 1;
                        else
                            test = 0;
                        end
                    end
                end
                % Count Iterations & break if no trial meets conditions after
                % maxIter
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

%% Specify all information for each trial
for trial = 1:nTrials
    if isPractice == 1
        Trial(trial).Block = 0;
    else
        Trial(trial).Block = expBlock;
    end
    Trial(trial).TrialNum = trial;
    Trial(trial).Shifting = TrialMatrix(trial,3);
    Trial(trial).Task = TrialMatrix(trial,2);
    Trial(trial).ProbeStim = TrialMatrix(trial,1);
    Trial(trial).Task = TrialMatrix(trial,2);
    
    if Trial(trial).Task == 1
        Trial(trial).ProbeStimColor = expinfo.Colors.red;
    elseif Trial(trial).Task == 2
        Trial(trial).ProbeStimColor = expinfo.Colors.green;
    end
    
    if Trial(trial).Task == 1 && expinfo.ColorOnFix == 1
        Trial(trial).FixColor = expinfo.Colors.red;
    elseif Trial(trial).Task == 2 && expinfo.ColorOnFix == 1
        Trial(trial).FixColor = expinfo.Colors.green;
    else
        Trial(trial).FixColor = expinfo.Colors.gray;
    end
    
    Trial(trial).FixMarker = expinfo.Marker.Fixation(Trial(trial).Task,Trial(trial).Shifting+1);
    Trial(trial).ISIMarker = expinfo.Marker.ISI(Trial(trial).Task,Trial(trial).Shifting+1);
    Trial(trial).ProbeStimMaker = expinfo.Marker.Target(Trial(trial).Task,Trial(trial).Shifting+1);
    
    Trial(trial).FIX = expinfo.Fix_Duration+rand(1)*expinfo.Fix_jitter;
    Trial(trial).ISI = expinfo.MinISIduration+rand(1)*expinfo.ISIjitter;
    Trial(trial).ITI = expinfo.MinITIduration+rand(1)*expinfo.ITIjitter;
    
 
    if Trial(trial).Task == 1 && Trial(trial).ProbeStim > 5 || Trial(trial).Task == 2 && mod(Trial(trial).ProbeStim,2)== 0
        Trial(trial).CorResp = 'l';
    else
        Trial(trial).CorResp = 'd';
    end
    
    
    if  isPractice == 1 && PracBlock == 1
        Trial(trial).TaskDescription = 'PracTaskPureLM';
    elseif isPractice == 1 && PracBlock == 2
        Trial(trial).TaskDescription = 'PracTaskPureOE';
    elseif isPractice == 1 && PracBlock == 3
        Trial(trial).TaskDescription = 'PracShifting';
    else
        Trial(trial).TaskDescription = 'ExpShifting';
    end
end

% Now we have a MATLAB Structure with as many fields as trials and the
% different variables contain all relevant information of the trials.
end
%% End of Function

