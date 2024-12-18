% This function generates a trial list from the specified Trial
% configurations in the expinfo. Alternatively, we can specify the Trial
% configurations here if there is more complex things to do...

function [Trial] = MakeTrial(expinfo, isPractice, expBlock)


%% Resort Trial Configurations


% Specify the number of trials to be drawn
if isPractice == 1 
    nTrials = expinfo.nPracTrials;
else
    nTrials = expinfo.nExpTrials;
end

% Create Matrix with all possible TrialConfigurations according to the
% predefined information of the task

  
TrialConfigurations1 = [];
trial = 1;
for i = 1:expinfo.Trial2Cond
    for Congruency = 1:length(expinfo.Congruency)
        for Color = 1: length(expinfo.Color)
                TrialConfigurations1(trial,1) = expinfo.Color(Color);
                TrialConfigurations1(trial,2) = expinfo.Congruency(Congruency);
                trial = trial + 1;
        end
    end
end

m = 0; % counter
for i = 1:(length(expinfo.Color)-1)
    for k = 1: length(TrialConfigurations1)
        TrialConfigurations(m+1,1) = TrialConfigurations1(k,1);
        TrialConfigurations(m+1,2) = TrialConfigurations1(k,2);
      if TrialConfigurations1(k,2) == 1
         TrialConfigurations(m+1,3) = TrialConfigurations1(k,1);
      else
         TrialConfigurations(m+1,3) = i;
      end
      m = m+1;
    end
end

for i = 1: length(TrialConfigurations)
    if TrialConfigurations(i,1) == TrialConfigurations(i,3) && TrialConfigurations(i,2) == 2
        TrialConfigurations(i,3) = 4;
    end
end


%% Delete Variables that are no longer needed
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
            if trial == 1
                test = 1;
            elseif trial > 1 && trial < 4
                if SampleMatrix(RandRow,1) ~= TrialMatrix(trial-1,1) % The same word should not repeat
                    ColorTest = 1;
                else
                    ColorTest = 0;
                end
                if SampleMatrix(RandRow,3) ~= TrialMatrix(trial-1,3) % The same word should not repeat
                    WordTest = 1;
                else
                    WordTest = 0;
                end
                if ColorTest == 1 && WordTest == 1
                    test = 1;
                else
                    test = 0;
                end

            else
                if SampleMatrix(RandRow,2) ~= TrialMatrix(trial-1,2) || SampleMatrix(RandRow,2) ~= TrialMatrix(trial-2,2) || SampleMatrix(RandRow,2) ~= TrialMatrix(trial-3,2)
                    CongruencyTest = 1; % Conditions may not repeat more than three times
                else
                    CongruencyTest = 0;
                end

                if SampleMatrix(RandRow,1) ~= TrialMatrix(trial-1,1) % The same color should not repeat
                    ColorTest = 1;
                else
                    ColorTest = 0;
                end

                if SampleMatrix(RandRow,3) ~= TrialMatrix(trial-1,3) % The same word should not repeat
                    WordTest = 1;
                else
                    WordTest = 0;
                end

                if ColorTest == 1 && WordTest == 1 && CongruencyTest == 1
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
        Trial(trial).Block = 0;
    else
        Trial(trial).Block = expBlock;
    end
    Trial(trial).TrialNum = trial;
    Trial(trial).CongruencyNum = TrialMatrix(trial,2);
    Trial(trial).Congruency = expinfo.CongruencyString{TrialMatrix(trial,2)};
    Trial(trial).ColorNum = TrialMatrix(trial,1);
    Trial(trial).WordNum = TrialMatrix(trial,3);
    Trial(trial).Color = expinfo.WordsString{TrialMatrix(trial,1)};
    Trial(trial).Word = expinfo.WordsString{TrialMatrix(trial,3)};
    
    if Trial(trial).ColorNum == 1
        Trial(trial).ProbeStimColor = expinfo.Colors.red;
    elseif Trial(trial).ColorNum == 2
        Trial(trial).ProbeStimColor = expinfo.Colors.yellow;
    elseif Trial(trial).ColorNum == 3
       Trial(trial).ProbeStimColor = expinfo.Colors.green;
    elseif Trial(trial).ColorNum == 4
        Trial(trial).ProbeStimColor = expinfo.Colors.blue;
    end
    
    Trial(trial).FixMarker = expinfo.Marker.Fixation(Trial(trial).CongruencyNum);
    Trial(trial).ISIMarker = expinfo.Marker.ISI(Trial(trial).CongruencyNum);
    Trial(trial).ProbeStimMaker = expinfo.Marker.Target(Trial(trial).CongruencyNum);
    
    Trial(trial).FIX = expinfo.Fix_Duration+rand(1)*expinfo.Fix_jitter;
    Trial(trial).ISI = expinfo.MinISIduration+rand(1)*expinfo.ISIjitter;
    Trial(trial).ITI = expinfo.MinITIduration+rand(1)*expinfo.ITIjitter;
    
    Trial(trial).CorResp = expinfo.RespKeys{expinfo.RespMapping(Trial(trial).ColorNum)}; 
    
    if  isPractice == 1 
        Trial(trial).TaskDescription = 'PracStroop';
    else
        Trial(trial).TaskDescription = 'ExpStroop';
    end
end
 
% Now we have a MATLAB Structure with as many fields as trials and the
% different variables contain all relevant information of the trials.
end
%% End of Function

