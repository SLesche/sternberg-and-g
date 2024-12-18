% This function displays one trial of a Simon Task

function Trial = DisplayTrial(expinfo, Trial, expTrial, isPractice)
%% Trial Procedure
if expTrial == 1
    WaitSecs(1); % Pre-hac timing so that experimental trials do not start right away
end
counter = 1;
% display Fixation Cross
Trial(expTrial).time_fixation = TextCenteredOnPos(expinfo,'+',expinfo.centerX,expinfo.centerY,expinfo.Colors.gray,[],Trial(expTrial).FixMarker, counter);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_fixation,Trial(expTrial).FIX);
% WaitSecs(0.05);
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port

Trial(expTrial).time_ISI1 = clearScreen(expinfo,next_flip,Trial(expTrial).ISIMarker);
% next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_ISI1,Trial(expTrial).ISI);
% WaitSecs(0.05);
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port

% display Probe Stimulus
Screen('FillRect', expinfo.window, expinfo.Colors.gray, expinfo.Rect1); 
Screen('FillRect', expinfo.window, expinfo.Colors.gray, expinfo.Rect2); 
Screen('FillRect', expinfo.window, expinfo.Colors.gray, expinfo.Rect3); 
Screen('FillRect', expinfo.window, expinfo.Colors.gray, expinfo.Rect4); 
counter = 0;
TextCenteredOnPos(expinfo,'O',Trial(expTrial).XTarget,expinfo.centerY,expinfo.Colors.gray, [],[], counter);
counter = 1;
Trial(expTrial).time_probe = TextCenteredOnPos(expinfo,'X',Trial(expTrial).XDistractor,expinfo.centerY,expinfo.Colors.gray, next_flip,Trial(expTrial).StimulusMaker, counter);
Trial = getresponse(expinfo, Trial, expTrial, Trial(expTrial).time_probe);
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port

if expinfo.LongRT == 1
    if Trial(expTrial).RT < expinfo.MinTarget
        WaitSecs(expinfo.MinTarget-Trial(expTrial).RT);
        clearScreen(expinfo);
    else
        clearScreen(expinfo);
    end
end

if isPractice == 1 % Show feedback in practice trials
    if Trial(expTrial).ACC == 1
        timestamp_FB = TextCenteredOnPos(expinfo,'RICHTIG',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.green,[],[], counter);
    elseif Trial(expTrial).ACC == 0
        timestamp_FB = TextCenteredOnPos(expinfo,'FALSCH',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.red,[],[], counter);
    elseif Trial(expTrial).ACC == -2
        timestamp_FB = TextCenteredOnPos(expinfo,'ZU LANGSAM',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.gray,[],[], counter);
    elseif Trial(expTrial).ACC == -3
        timestamp_FB = TextCenteredOnPos(expinfo,'UNERLAUBTE TASTE',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.red,[],[],counter);
    end
    next_flip = getAccurateFlip(expinfo.window,timestamp_FB,expinfo.FeedbackDuration);
end

% Clear Screen for ITI
Trial(expTrial).time_ITI1 = clearScreen(expinfo,next_flip,expinfo.Marker.ITI);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_ITI1,Trial(expTrial).ITI);
% WaitSecs(0.05);
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port

%% Recording Data
if isPractice == 1
    fid = fopen(expinfo.pracFile, 'a');
else
    fid = fopen(expinfo.expFile, 'a');
end

% % Print general information into data file
 fprintf (fid, '%1d %1d %1d %1d %19s ', expinfo.subject, expinfo.session ,Trial(expTrial).Block, Trial(expTrial).TrialNum, Trial(expTrial).TaskDescription);
% % Print trial specification into data file
 fprintf (fid, '%1d %9s %1d %1d ', Trial(expTrial).Condition, Trial(expTrial).ConditionDescr, Trial(expTrial).PositionTarget, Trial(expTrial).PositionDistractor);
% % Print stimuli and variable timings for ISI & ITI in data dile
 fprintf (fid, '%1.4f %1.4f %1.4f ', Trial(expTrial).FIX, Trial(expTrial).ISI, Trial(expTrial).ITI);
% % Print response information into data file
 fprintf (fid, '%1d %1.4f %1s %1s ', Trial(expTrial).ACC, Trial(expTrial).RT, Trial(expTrial).response, Trial(expTrial).CorResp);
% % Print new Line after each Trial
fprintf (fid, '\n');
fclose (fid);

% Flip again after ITI is over
Trial(expTrial).time_ITI2 = clearScreen(expinfo,next_flip);
end

%% End of Function
