
% This function generates a trial list from the specified Trial
% configurations in the expinfo. Alternatively, we can specify the Trial
% configurations here if there is more complex things to do...

function [Trial] = MakeTrial(expinfo, isPractice, expBlock)

if expBlock == 1
expinfo.Updating = 3; % n 
else 
expinfo.Updating = 5;
end

TrialConfigurations1 = [];
trial = 1;

for i = 1:expinfo.Trial2Cond2
    for SetsizeDistractors = 1:length(expinfo.SetSize1)
        for UpdatingSteps = 1:length(expinfo.Updating)
            for Stimuli = 1:length(expinfo.Stimuli)
                for Match = 1:length(expinfo.Match)
                    TrialConfigurations1(trial,1) = expinfo.SetSize1(SetsizeDistractors);
                    TrialConfigurations1(trial,2) = expinfo.Updating(UpdatingSteps);
                    TrialConfigurations1(trial,3) = expinfo.Stimuli(Stimuli);
                    TrialConfigurations1(trial,4) = expinfo.Match(Match);
                    trial = trial + 1;
                end
            end
        end
    end
end

TrialConfigurations2 = [];
trial = 1;

for i = 1:expinfo.Trial2Cond1
    for SetsizeDistractors = 1:length(expinfo.SetSize2)
        for UpdatingSteps = 1:length(expinfo.Updating)
            for Stimuli = 1:length(expinfo.Stimuli)
                for Match = 1:length(expinfo.Match)
                    TrialConfigurations2(trial,1) = expinfo.SetSize2(SetsizeDistractors);
                    TrialConfigurations2(trial,2) = expinfo.Updating(UpdatingSteps);
                    TrialConfigurations2(trial,3) = expinfo.Stimuli(Stimuli);
                    TrialConfigurations2(trial,4) = expinfo.Match(Match);
                    trial = trial + 1;
                end
            end
        end
    end
end

TrialConfigurations = [TrialConfigurations1;TrialConfigurations2];

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
                        DistractorTest = 1;
                    else
                        DistractorTest  = 0;
                    end
                    if SampleMatrix(RandRow,3)~= TrialMatrix (trial-1, 3) || SampleMatrix(RandRow,3)~= TrialMatrix (trial-2, 3) || SampleMatrix(RandRow,3)~= TrialMatrix (trial-3, 3)
                        StimTest = 1;
                    else
                        StimTest  = 0;
                    end
                    if SampleMatrix(RandRow,4)~= TrialMatrix (trial-1, 4) || SampleMatrix(RandRow,4)~= TrialMatrix (trial-2, 4) || SampleMatrix(RandRow,4)~= TrialMatrix (trial-3, 4)
                        MatchTest = 1;
                    else
                        MatchTest = 0;
                    end
                    if MatchTest == 1 && StimTest  == 1 && DistractorTest == 1
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
    Trial(trial).DistractorsM = TrialMatrix(trial,1);
    Trial(trial).TargetSizeN = TrialMatrix(trial,2);
    Trial(trial).SetSize = TrialMatrix(trial,1) + TrialMatrix(trial,2);
    Trial(trial).Target = TrialMatrix(trial,3);
    Trial(trial).Match = TrialMatrix(trial,4); % 1 = Match, 2 = No Match
    Trial(trial).TargetStimuli = expinfo.letters(TrialMatrix(trial,3));
    Trial(trial).TargetStimuli1 = char(Trial(trial).TargetStimuli);
   
    if TrialMatrix(trial,4)~= 1 
        Trial(trial).MatchDescription = 'NoMatch';
    else
        Trial(trial).MatchDescription = 'Match';
    end
    
    NotProbeDigits = expinfo.Stimuli(expinfo.Stimuli ~= TrialMatrix(trial,3));
    MemorySet = randsample(NotProbeDigits,(TrialMatrix(trial,1)+TrialMatrix(trial,2)));
    
    if TrialMatrix(trial,4)==1
        Trial(trial).TargetPos = (randsample(TrialMatrix(trial,2),1)+ TrialMatrix(trial,1));
        MemorySet(Trial(trial).TargetPos)= Trial(trial).Target;
    end
    
    if Trial(trial).Match == 0
      Trial(trial).TargetPos = 0;   
    end
    
    Trial(trial).MemSet = MemorySet;
    Trial(trial).MemSetLetters = expinfo.letters(MemorySet);
    Trial(trial).MemSetLetters1 = char(Trial(trial).MemSetLetters);
    
    Trial(trial).FIX = expinfo.MinFixduration +(rand(1)*expinfo.Fixjitter);
    Min_ISI = repmat(expinfo.MinISIduration,1,(TrialMatrix(trial,2)+ TrialMatrix(trial,1)));
    Jitter = rand(1,(TrialMatrix(trial,2)+ TrialMatrix(trial,1)));
    Trial(trial).ISI = Min_ISI+(Jitter*expinfo.ISIjitter);
    Trial(trial).CueDuration = expinfo.MinCueDuration + (rand(1)*expinfo.Cuejitter); % Time of "?"
    Trial(trial).ITI = expinfo.MinITIduration + (rand(1)*expinfo.ITIjitter);
    
    if Trial(trial).Match == 1 
        Trial(trial).CorResp = 'l';
    else
        Trial(trial).CorResp = 'd';
    end

    
    if isPractice == 1
        Trial(trial).FixMarker = 0;
        Trial(trial).ISIMarker = 0;
        Trial(trial).MemSetMarker = 0;
        Trial(trial).ProbeStimMaker = 0;
        Trial(trial).CueMarker = 0;
    else
        if Trial(trial).DistractorsM == 0
            Trial(trial).FixMarker = expinfo.Marker.Fixation(Trial(trial).Match+1) ;
            Trial(trial).ISIMarker = expinfo.Marker.ISI(Trial(trial).Match+1);
            Trial(trial).MemSetMarker = expinfo.Marker.MemSet(Trial(trial).Match+1);
            Trial(trial).ProbeStimMaker = expinfo.Marker.ProbeStim(Trial(trial).Match+1);
            Trial(trial).CueMarker = expinfo.Marker.Cue(Trial(trial).Match+1);
        elseif Trial(trial).DistractorsM == 1
            Trial(trial).FixMarker = expinfo.Marker.Fixation(Trial(trial).Match+1)+2 ;
            Trial(trial).ISIMarker = expinfo.Marker.ISI(Trial(trial).Match+1)+2;
            Trial(trial).MemSetMarker = expinfo.Marker.MemSet(Trial(trial).Match+1)+2;
            Trial(trial).ProbeStimMaker = expinfo.Marker.ProbeStim(Trial(trial).Match+1)+2;
            Trial(trial).CueMarker = expinfo.Marker.Cue(Trial(trial).Match+1)+2;
        elseif Trial(trial).DistractorsM == 2
            Trial(trial).FixMarker = expinfo.Marker.Fixation(Trial(trial).Match+1)+4 ;
            Trial(trial).ISIMarker = expinfo.Marker.ISI(Trial(trial).Match+1)+4;
            Trial(trial).MemSetMarker = expinfo.Marker.MemSet(Trial(trial).Match+1)+4;
            Trial(trial).ProbeStimMaker = expinfo.Marker.ProbeStim(Trial(trial).Match+1)+4;
            Trial(trial).CueMarker = expinfo.Marker.Cue(Trial(trial).Match+1)+4;
        elseif Trial(trial).DistractorsM == 3
            Trial(trial).FixMarker = expinfo.Marker.Fixation(Trial(trial).Match+1)+6 ;
            Trial(trial).ISIMarker = expinfo.Marker.ISI(Trial(trial).Match+1)+6;
            Trial(trial).MemSetMarker = expinfo.Marker.MemSet(Trial(trial).Match+1)+6;
            Trial(trial).ProbeStimMaker = expinfo.Marker.ProbeStim(Trial(trial).Match+1)+6;
            Trial(trial).CueMarker = expinfo.Marker.Cue(Trial(trial).Match+1)+6;
        end
    end


if isPractice == 1
    Trial(trial).TaskDescription = ['PracRunningSpan','_Size_',num2str(TrialMatrix(trial,2))];
else
    Trial(trial).TaskDescription = ['ExpRunningSpan','_Size_',num2str(TrialMatrix(trial,2))];
end
end  
%% End of Function