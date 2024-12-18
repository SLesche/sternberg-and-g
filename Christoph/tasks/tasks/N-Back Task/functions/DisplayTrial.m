% This function displays one trial of a Simon Task

function Trial = DisplayTrial(expinfo, Trial, expBlock ,expTrial, isPractice)
%% Trial Procedure
if expTrial == 1
WaitSecs(1); 

Trial(expTrial).time_fixation = TextCenteredOnPos(expinfo,'+',expinfo.centerX,expinfo.centerY,expinfo.Colors.gray,[],Trial(expTrial).FixMarker);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_fixation,Trial(expTrial).FIX);
%WaitSecs(0.05);
%io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
end

if expTrial == 1
Trial(expTrial).time_ISI1 = clearScreen(expinfo,next_flip,Trial(expTrial).ISIMarker);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_ISI1,Trial(expTrial).ISI);
%WaitSecs(0.05);
%io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
else
Trial(expTrial).time_ISI1 = clearScreen(expinfo,[],Trial(expTrial).ISIMarker);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_ISI1,Trial(expTrial).ISI);
%WaitSecs(0.05);  
%io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
end

if expBlock == 1 || expBlock == 2 &&  expTrial > 1 || expBlock == 3 &&  expTrial > 2
    % display Probe Stimulus
    Trial(expTrial).time_probe = TextCenteredOnPos(expinfo,Trial(expTrial).Stimuli,expinfo.centerX,expinfo.centerY, expinfo.Colors.gray, next_flip,Trial(expTrial).StimMarker);
    Trial = getresponse(expinfo, Trial, expBlock, expTrial, Trial(expTrial).time_probe);
%    io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
else 
    Trial(expTrial).time_probe = TextCenteredOnPos(expinfo,Trial(expTrial).Stimuli,expinfo.centerX,expinfo.centerY, expinfo.Colors.gray, next_flip,Trial(expTrial).StimMarker);
    next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_probe,expinfo.MinTarget);
%    io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
end

if expBlock == 1 || expBlock == 2 &&  expTrial > 1 || expBlock == 3 &&  expTrial > 2
    if expinfo.LongRT == 1
        if Trial(expTrial).RT < expinfo.MinTarget
            WaitSecs(expinfo.MinTarget-Trial(expTrial).RT);
            clearScreen(expinfo);
        else
            clearScreen(expinfo);
        end
    end
end

if isPractice == 1 % Show feedback in practice trials
    if expBlock == 1 || expBlock == 2 &&  expTrial > 1 || expBlock == 3 &&  expTrial > 2
        if Trial(expTrial).ACC == 1
            timestamp_FB = TextCenteredOnPos(expinfo,'RICHTIG',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.green);
        elseif Trial(expTrial).ACC == 0
            timestamp_FB = TextCenteredOnPos(expinfo,'FALSCH',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.red);
        elseif Trial(expTrial).ACC == -2
            timestamp_FB = TextCenteredOnPos(expinfo,'ZU LANGSAM',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.gray);
        elseif Trial(expTrial).ACC == -3
            timestamp_FB = TextCenteredOnPos(expinfo,'UNERLAUBTE TASTE',0.5*expinfo.maxX,0.5*expinfo.maxY,expinfo.Colors.red);
        end
        next_flip = getAccurateFlip(expinfo.window,timestamp_FB,expinfo.FeedbackDuration);
    end
end

%% Recording Data
if isPractice == 1
    fid = fopen(expinfo.pracFile, 'a');
else
    fid = fopen(expinfo.expFile, 'a');
end
if expBlock == 1
    % % Print general information into data file
     fprintf (fid, '%1d %1d %1d %1d %16s %1d ', expinfo.subject, expinfo.session ,Trial(expTrial).Block, Trial(expTrial).TrialNum, Trial(expTrial).TaskDescription, Trial(expTrial).NBackSteps);
    % % Print trial specification into data file
     fprintf (fid, '%1d %1d %1d %1s %1d %7s ', Trial(expTrial).Target, Trial(expTrial).NonTarget, Trial(expTrial).Digits, Trial(expTrial).Stimuli, Trial(expTrial).Match, Trial(expTrial).MatchDescription);
    % % Print stimuli and variable timings for ISI & ITI in data dile
     fprintf (fid, '%1.4f ', Trial(expTrial).ISI);
    % % Print response information into data file
     fprintf (fid, '%1d %1.4f %1s %1s ', Trial(expTrial).ACC, Trial(expTrial).RT, Trial(expTrial).response, Trial(expTrial).CorResp);
    % % Print new Line after each Trial
    fprintf (fid, '\n');
    fclose (fid);
else
    % % Print general information into data file
     fprintf (fid, '%1d %1d %1d %1d %16s %1d ', expinfo.subject, expinfo.session ,Trial(expTrial).Block, Trial(expTrial).TrialNum, Trial(expTrial).TaskDescription, Trial(expTrial).NBackSteps);
    % % Print trial specification into data file
     fprintf (fid, '%1d %1s %1d %7s ', Trial(expTrial).Digits, Trial(expTrial).Stimuli, Trial(expTrial).Match, Trial(expTrial).MatchDescription);
    % % Print stimuli and variable timings for ISI & ITI in data dile
     fprintf (fid, '%1.4f ', Trial(expTrial).ISI);
    % % Print response information into data file
     fprintf (fid, '%1d %1.4f %1s %1s ', Trial(expTrial).ACC, Trial(expTrial).RT, Trial(expTrial).response, Trial(expTrial).CorResp);
    % % Print new Line after each Trial
    fprintf (fid, '\n');
    fclose (fid);
end
% Flip again after ITI is over
Trial(expTrial).time_ITI2 = clearScreen(expinfo,next_flip);
end
%% End of Function
