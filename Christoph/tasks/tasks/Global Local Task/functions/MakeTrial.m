% This function generates a trial list from the specified Trial
% configurations in the expinfo. Alternatively, we can specify the Trial
% configurations here if there is more complex things to do...

function [Trial] = MakeTrial(expinfo, isPractice, PracBlock, expBlock)


%% Resort Trial Configurations

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
    for Stimuli = 1:length(expinfo.Stimuli)
        for Task = 1:length(n)
            for Shifting = 1: length(m)
                TrialConfigurations(trial,1) = expinfo.Stimuli(Stimuli);
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

%% %% Specify all information for each trial
for trial = 1:nTrials
    if isPractice == 1
        Trial(trial).Block = 0;
    else
        Trial(trial).Block = expBlock;
    end
    Trial(trial).TrialNum = trial;
    Trial(trial).Shifting = TrialMatrix(trial,3);
    Trial(trial).Shape = TrialMatrix(trial,1);
    Trial(trial).Task = TrialMatrix(trial,2);
  
if Trial(trial).Shape == 1
    Trial(trial).ShapeNameGlobal = 'cross';
    Trial(trial).ShapeNameLocal= 'square';
elseif Trial(trial).Shape == 2
    Trial(trial).ShapeNameGlobal = 'cross';
    Trial(trial).ShapeNameLocal = 'triangle';
elseif Trial(trial).Shape == 3
    Trial(trial).ShapeNameGlobal = 'cross';
    Trial(trial).ShapeNameLocal = 'circle';
elseif Trial(trial).Shape == 4
    Trial(trial).ShapeNameGlobal = 'circle';
    Trial(trial).ShapeNameLocal = 'square';
elseif Trial(trial).Shape == 5
    Trial(trial).ShapeNameGlobal = 'circle';
    Trial(trial).ShapeNameLocal = 'triangle';
elseif Trial(trial).Shape == 6
    Trial(trial).ShapeNameGlobal = 'circle';
    Trial(trial).ShapeNameLocal = 'cross';
elseif Trial(trial).Shape == 7
    Trial(trial).ShapeNameGlobal = 'triangle';
    Trial(trial).ShapeNameLocal = 'circle';
elseif Trial(trial).Shape == 8
    Trial(trial).ShapeNameGlobal = 'triangle';
    Trial(trial).ShapeNameLocal = 'cross';
elseif Trial(trial).Shape == 9
    Trial(trial).ShapeNameGlobal = 'triangle';
    Trial(trial).ShapeNameLocal = 'square';
elseif Trial(trial).Shape == 10
    Trial(trial).ShapeNameGlobal = 'square';
    Trial(trial).ShapeNameLocal = 'cross';
elseif Trial(trial).Shape == 11
    Trial(trial).ShapeNameGlobal = 'square';
    Trial(trial).ShapeNameLocal = 'circle';
elseif Trial(trial).Shape == 12
    Trial(trial).ShapeNameGlobal = 'square';
    Trial(trial).ShapeNameLocal = 'triangle';
end    
  
    Trial(trial).FIX = expinfo.Fix_Duration+rand(1)*expinfo.Fix_jitter;
    Trial(trial).ISI = expinfo.MinISIduration+rand(1)*expinfo.ISIjitter;
    Trial(trial).ITI = expinfo.MinITIduration+rand(1)*expinfo.ITIjitter;
    
    Trial(trial).FixMarker = expinfo.Marker.Fixation(Trial(trial).Task,Trial(trial).Shifting+1);
    Trial(trial).ISIMarker = expinfo.Marker.ISI(Trial(trial).Task,Trial(trial).Shifting+1);
    Trial(trial).ProbeStimMaker = expinfo.Marker.Target(Trial(trial).Task,Trial(trial).Shifting+1);

    
    if Trial(trial).Task == 1 
        Trial(trial).ProbeStimColor = expinfo.Colors.red;
    else
        Trial(trial).ProbeStimColor = expinfo.Colors.green;
    end
    
    if Trial(trial).Task == 1 && expinfo.ColorOnFix == 1
        Trial(trial).FixColor = expinfo.Colors.red;
    elseif Trial(trial).Task == 2 && expinfo.ColorOnFix == 1
        Trial(trial).FixColor = expinfo.Colors.green;
    else
        Trial(trial).FixColor = expinfo.Colors.gray;
    end
    
    if Trial(trial).Task == 1
        Trial(trial).TaskNaming = 'Global';
    else
        Trial(trial).TaskNaming = 'Local';
    end
    
    
    if Trial(trial).Task == 1 && strcmp('square',Trial(trial).ShapeNameGlobal) || Trial(trial).Task == 2 && strcmp('square',Trial(trial).ShapeNameLocal)
        Trial(trial).CorResp = 'w'; %square
    elseif Trial(trial).Task == 1 && strcmp('cross',Trial(trial).ShapeNameGlobal) || Trial(trial).Task == 2 && strcmp('cross',Trial(trial).ShapeNameLocal)
        Trial(trial).CorResp = 'r'; %cross
    elseif Trial(trial).Task == 1 && strcmp('circle',Trial(trial).ShapeNameGlobal) || Trial(trial).Task == 2 && strcmp('circle',Trial(trial).ShapeNameLocal)
        Trial(trial).CorResp = 'i'; %circle
    elseif Trial(trial).Task == 1 && strcmp('triangle',Trial(trial).ShapeNameGlobal) || Trial(trial).Task == 2 && strcmp('triangle',Trial(trial).ShapeNameLocal)
        Trial(trial).CorResp = 'p'; %triangle
    end


    if  isPractice == 1 && PracBlock == 1
        Trial(trial).TaskDescription = 'PracPureGlobal';
    elseif isPractice == 1 && PracBlock == 2
        Trial(trial).TaskDescription = 'PracPureLocal';
    elseif isPractice == 1 && PracBlock == 3
        Trial(trial).TaskDescription = 'PracShiftingGL';
    else
        Trial(trial).TaskDescription = 'ExpShiftingGL';
    end
end
 
% Now we have a MATLAB Structure with as many fields as trials and the
% different variables contain all relevant information of the trials.
end
%% End of Function

