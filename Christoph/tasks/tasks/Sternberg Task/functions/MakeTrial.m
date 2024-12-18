% This function generates a trial list from the specified Trial
% configurations in the expinfo. Alternatively, we can specify the Trial
% configurations here if there is more complex things to do...

function [Trial] = MakeTrial(expinfo, isPractice)
%% specify Trial configurations


% Specify the number of trials to be drawn
if  isPractice == 1
    nTrials = expinfo.nPracTrials;
else
    nTrials = expinfo.nExpTrials;
end

% Create Matrix with all possible TrialConfigurations according to the
% predefined information of the task
TrialConfigurations = [];
trial = 1;
for i = 1:expinfo.Trial2Cond
    for Probes = 1:length(expinfo.Digits)
        for Matches = 1:length(expinfo.Match)
            for SetSizes = 1:length(expinfo.SetSizes)
                for Positions = 1:expinfo.SetSizes(SetSizes)
                    TrialConfigurations(trial,1) = expinfo.Digits(Probes);
                    TrialConfigurations(trial,2) = expinfo.Match(Matches);
                    TrialConfigurations(trial,3) = expinfo.SetSizes(SetSizes);
                    TrialConfigurations(trial,4) = Positions;
                    trial = trial + 1;
                end
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
            if trial == 1
                test = 1;
            elseif trial < 4
             % Check that the same probe is never repeated consecutively
                if SampleMatrix(RandRow,1) ~= TrialMatrix(trial-1,1)
                    ProbeTest = 1;
                else
                    ProbeTest = 0;
                end
                
          % Depending on the individual conditions, recode the test variabl
                if ProbeTest == 1
                    test = 1;
                else
                    test = 0;
                end
            else
       % Check that the same probe is never repeated consecutively
                if SampleMatrix(RandRow,1) ~= TrialMatrix(trial-1,1)
                    ProbeTest = 1;
                else
                    ProbeTest = 0;
                end
                
         % Check if the same response is not required more than 3 times in a row
                if SampleMatrix(RandRow,2)~= TrialMatrix (trial-1, 2) || SampleMatrix(RandRow,2)~= TrialMatrix (trial-2, 2) || SampleMatrix(RandRow,2)~= TrialMatrix (trial-3, 2) % hier müsste doch eine andere Spalte hin?
                    RespTest = 1;
                else
                    RespTest = 0;
                end
                
    % Check that the probe is not repeated in the same position 3 times in a row
              
                if SampleMatrix(RandRow,4)~= TrialMatrix (trial-1, 4) || SampleMatrix(RandRow,4)~= TrialMatrix (trial-2, 4) || SampleMatrix(RandRow,4)~= TrialMatrix (trial-3, 4)
                    PositionTest = 1;
                else
                    PositionTest = 0;
                end
                
                % Depending on the individual conditions, recode the test variable
                if ProbeTest == 1 && RespTest == 1 && PositionTest == 1
                    test = 1;
                else
                    test = 0;
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
%     if isPractice == 1
%         Trial(trial).Block = 0;
%     else
%         Trial(trial).Block = expBlock;
%     end
    
if isPractice == 1
    Trial(trial).Block = 0;
else
    if trial <= (round(1/2*expinfo.nExpTrials))
        Trial(trial).Block = 1;
    else
        Trial(trial).Block = 2;
    end
end
    
    Trial(trial).TrialNum = trial;
    Trial(trial).Digits = TrialMatrix(trial,1);
    Trial(trial).Match = TrialMatrix(trial,2);
    Trial(trial).SetSizes = TrialMatrix(trial,3);
    Trial(trial).Positions = TrialMatrix(trial,4);

    
    if TrialMatrix(trial,2)== 0
        Trial(trial).MatchDescribtion = 'NoMatch';
    else
        Trial(trial).MatchDescribtion = 'Match';
    end
    
   % Determining the numbers shown in the Memory Set
    NotProbeDigits = expinfo.Digits(expinfo.Digits ~= TrialMatrix(trial,1));
    MemorySet = randsample(NotProbeDigits,TrialMatrix(trial,3));
    
    if TrialMatrix(trial,2)==1
        MemorySet(Trial(trial).Positions)= Trial(trial).Digits;
    end
    
    Trial(trial).MemSet=MemorySet;
    
    Trial(trial).FIX = expinfo.MinFixduration + (rand(1)*expinfo.Fixjitter);
    Min_ISI = repmat(expinfo.MinISIduration,1,TrialMatrix(trial,3));
    Jitter = rand(1,TrialMatrix(trial,3));
    Trial(trial).ISI = Min_ISI+(Jitter*expinfo.ISIjitter);
    Trial(trial).CueDuration = expinfo.MinCueDuration + (rand(1)*expinfo.Cuejitter); % Time of "?"
    Trial(trial).ITI = expinfo.MinITIduration + (rand(1)*expinfo.ITIjitter);
    
    if Trial(trial).Match == 1 
        Trial(trial).CorResp = 'l';
    else
        Trial(trial).CorResp = 'd';
    end
     
    Trial(trial).FixMarker = expinfo.Marker.Fixation(Trial(trial).Match+1);
    Trial(trial).ISIMarker = expinfo.Marker.ISI(Trial(trial).Match+1);
    Trial(trial).ProbeStimMaker = expinfo.Marker.Digits(Trial(trial).Match+1);
    Trial(trial).MemStimMaker = expinfo.Marker.MemSet(Trial(trial).Match+1);
    Trial(trial).CueMarker = expinfo.Marker.Cue(Trial(trial).Match+1);
    

    if isPractice == 1
    Trial(trial).TaskDescription = 'PracSternberg';
    else
    Trial(trial).TaskDescription = 'ExpSternberg';
    end
end

end
%% End of Function

