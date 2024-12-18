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

  
TrialConfigurations = [];
trial = 1;
for i = 1:expinfo.Trial2Cond
    for Congruency = 1:length(expinfo.Congruency)
        for Arrow = 1: length(expinfo.Arrow)
                TrialConfigurations(trial,1) = expinfo.Congruency(Congruency);
                TrialConfigurations(trial,2) = expinfo.Arrow(Arrow);
                trial = trial + 1;
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
            if trial == 1
                test = 1;
            
            elseif trial < 4 && trial > 1
                ArrowTest = 1;
                if SampleMatrix(RandRow,1) ~= TrialMatrix(trial-1,1) 
                    FlankerTest = 1;
                else
                    FlankerTest = 0;
                end
                if ArrowTest == 1 && FlankerTest == 1
                    test = 1;
                else
                    test = 0;
                end
            else
                if SampleMatrix(RandRow,1) ~= TrialMatrix(trial-1,1) || SampleMatrix(RandRow,1) ~= TrialMatrix(trial-2,1) 
                    FlankerTest = 1;
                else
                    FlankerTest  = 0;
                end
                if  SampleMatrix(RandRow,2) ~= TrialMatrix(trial-1,2) || SampleMatrix(RandRow,2) ~= TrialMatrix(trial-2,2) || SampleMatrix(RandRow,2) ~= TrialMatrix(trial-3,2)
                    ArrowTest = 1;
                else
                    ArrowTest = 0;
                end
                
                if ArrowTest == 1 && FlankerTest  == 1
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

%% Trial Liste fertigstellen

for trial = 1:nTrials
    if isPractice == 1
        Trial(trial).Block = 0;
    else
        Trial(trial).Block = expBlock;
    end
    
    Trial(trial).TrialNum = trial;
    Trial(trial).CongruencyNum = TrialMatrix(trial,1);
    Trial(trial).Congruency = expinfo.CongruencyString{TrialMatrix(trial,1)};
    Trial(trial).Arrow = TrialMatrix(trial,2);
    Trial(trial).ArrowDirection = expinfo.ArrowString{Trial(trial).Arrow};

    
    if strcmp(Trial(trial).Congruency,'congruent')
        if Trial(trial).Arrow == 1
            Trial(trial).Flanker = 1;
        else
            Trial(trial).Flanker = 2;
        end
    elseif strcmp(Trial(trial).Congruency,'incongruent')
        if Trial(trial).Arrow == 1
            Trial(trial).Flanker = 2;
        else
            Trial(trial).Flanker = 1;
        end
    else
        Trial(trial).Flanker = 3;
    end
 
 Trial(trial).FlankerDirection = expinfo.FlankerString{Trial(trial).Flanker};

    
    if  isPractice == 1
        Trial(trial).FixMarker = 0;
        Trial(trial).ISIMarker = 0;
        Trial(trial).ProbeStimMaker = 0;
        Trial(trial).ITIMarker = 0;
    else
        Trial(trial).FixMarker = expinfo.Marker.Fixation(Trial(trial).CongruencyNum);
        Trial(trial).ISIMarker = expinfo.Marker.ISI(Trial(trial).CongruencyNum);
        Trial(trial).ProbeStimMaker = expinfo.Marker.Target(Trial(trial).CongruencyNum);
        Trial(trial).ITIMarker = expinfo.Marker.ITI(Trial(trial).CongruencyNum);
    end
 
     Trial(trial).FIX = expinfo.Fix_Duration+rand(1)*expinfo.Fix_jitter;
     Trial(trial).ISI = expinfo.MinISIduration+rand(1)*expinfo.ISIjitter;
     Trial(trial).ITI = expinfo.MinITIduration+rand(1)*expinfo.ITIjitter;
     
    Trial(trial).CorResp = expinfo.RespKeys{expinfo.ResponseMapping(Trial(trial).Arrow)};
    
    if  isPractice == 1 
        Trial(trial).TaskDescription = 'PracFlanker';
    else
        Trial(trial).TaskDescription = 'ExpFlanker';
    end
end
 
end
%% End of Function

