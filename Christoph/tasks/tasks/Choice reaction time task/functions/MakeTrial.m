% This function generates a trial list from the specified Trial
% configurations in the expinfo. Alternatively, we can specify the Trial
% configurations here if there is more complex things to do...

function [Trial] = MakeTrial(expinfo, isPractice, PracBlock, expBlock)


%% Resort Trial Configurations

v = [1 1];
DiagonalMatrix = diag(v);
TrialConfigurations =  repmat(DiagonalMatrix,expinfo.Trial2Cond,1);

%%
if isPractice == 1 
    nTrials = expinfo.nPracTrials;
else
    nTrials = expinfo.nExpTrials;
end

%%
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
                if  SampleMatrix(RandRow,1)~= TrialMatrix (trial-1, 1) || SampleMatrix(RandRow,1)~= TrialMatrix (trial-2, 1)  || SampleMatrix(RandRow,1)~= TrialMatrix (trial-3, 1)
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
    Trial(trial).ProbeLeft = TrialMatrix(trial,1);
    Trial(trial).ProbeRight = TrialMatrix(trial,2);
    
    if TrialMatrix(trial,1) == 1
        Trial(trial).ProbeSideWord = 'left';
        Trial(trial).ProbeSide = 1; % 1 = links , 2 = rechts
    elseif TrialMatrix(trial,2) == 1
        Trial(trial).ProbeSideWord = 'right';
        Trial(trial).ProbeSide = 2; % 1 = links , 2 = rechts,
    end
    
    Trial(trial).FIX = expinfo.Fix_Duration+rand(1)*expinfo.Fix_jitter;
    Trial(trial).ISI = expinfo.MinISIduration+rand(1)*expinfo.ISIjitter;
    Trial(trial).ITI = expinfo.MinITIduration+rand(1)*expinfo.ITIjitter;
   

    Trial(trial).FixMarker = expinfo.Marker.Fixation(Trial(trial).ProbeSide);
    Trial(trial).ProbeStimMaker = expinfo.Marker.Target(Trial(trial).ProbeSide);  
    Trial(trial).ITIMarker = expinfo.Marker.ITI(Trial(trial).ProbeSide);  

    if Trial(trial).ProbeSide == 1
        Trial(trial).CorResp = 'd';
    else
        Trial(trial).CorResp = 'l';
    end


    if  isPractice == 1 
        Trial(trial).TaskDescription = 'ChoiceRTPractice';
    else
        Trial(trial).TaskDescription = 'ChoiceRTTask';
    end
end
 

% Now we have a MATLAB Structure with as many fields as trials and the
% different variables contain all relevant information of the trials.
end
%% End of Function

