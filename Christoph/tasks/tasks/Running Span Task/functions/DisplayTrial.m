% This function displays one trial of a Simon Task

function Trial = DisplayTrial(expinfo, Trial, expBlock ,expTrial, isPractice)
%% Trial Procedure
if expTrial == 1
WaitSecs(1); 
end

Trial(expTrial).time_fixation = TextCenteredOnPos(expinfo,'+',expinfo.centerX,expinfo.centerY,expinfo.Colors.gray,[],Trial(expTrial).FixMarker);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_fixation,Trial(expTrial).FIX);
% WaitSecs(0.05);
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port


for MemSet = 1 : Trial(expTrial).SetSize
    Trial(expTrial).time_ISI1 = clearScreen(expinfo,next_flip,Trial(expTrial).ISIMarker);
    next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_ISI1,Trial(expTrial).ISI(MemSet));
%     WaitSecs(0.05);
%     io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
    
    
    Trial(expTrial).time_Encoding = TextCenteredOnPos(expinfo,char(Trial(expTrial).MemSetLetters(MemSet)),expinfo.centerX,expinfo.centerY, expinfo.Colors.gray, next_flip,Trial(expTrial).MemSetMarker);
    next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_Encoding,expinfo.EncodingTime);
%     WaitSecs(0.05);
%     io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port    
end

% display Cue
Trial(expTrial).time_Cue = TextCenteredOnPos(expinfo,'?', expinfo.centerX, expinfo.centerY, expinfo.Colors.gray, next_flip, Trial(expTrial).CueMarker);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_Cue,Trial(expTrial).CueDuration);
% WaitSecs(0.05);
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port

% display Probe Stimulus
Trial(expTrial).time_probe = TextCenteredOnPos(expinfo,char(Trial(expTrial).TargetStimuli),expinfo.centerX,expinfo.centerY, expinfo.Colors.gray, next_flip,Trial(expTrial).ProbeStimMaker);
% Trial = getresponse(expinfo, Trial, expTrial, Trial(expTrial).time_probe);
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
 fprintf (fid, '%1d %1d %1d %1d %22s ', expinfo.subject, expinfo.session ,Trial(expTrial).Block, Trial(expTrial).TrialNum, Trial(expTrial).TaskDescription);
% % Print trial specification into data file
 fprintf (fid, '%1d %1d %1d %1d %1s ', Trial(expTrial).DistractorsM, Trial(expTrial).TargetSizeN, Trial(expTrial).SetSize, Trial(expTrial).Target, Trial(expTrial).TargetStimuli1);
% % Print trial specification into data file
 fprintf (fid, '%1d %1d %7s ', Trial(expTrial).TargetPos, Trial(expTrial).Match, Trial(expTrial).MatchDescription);
% % Print stimuli and variable timings for ISI & ITI in data dile
 fprintf (fid, '%1.4f %1.4f %1.4f ', Trial(expTrial).FIX, Trial(expTrial).CueDuration, Trial(expTrial).ITI);
 if Trial(expTrial).SetSize == 3
     fprintf (fid, '%1.4f %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f ', Trial(expTrial).ISI(1), Trial(expTrial).ISI(2), Trial(expTrial).ISI(3), 0.0000, 0.0000, 0.0000, 0.0000, 0.0000);
     fprintf (fid, '%1d %1d %1d %1d% 1d %1d %1d %1d ', Trial(expTrial).MemSet(1), Trial(expTrial).MemSet(2), Trial(expTrial).MemSet(3), 0, 0, 0, 0, 0);
     fprintf (fid, '%1s %1s %1s %1s %1s %1s %1s %1s ', Trial(expTrial).MemSetLetters1(1),  Trial(expTrial).MemSetLetters1(2),  Trial(expTrial).MemSetLetters1(3), '/', '/', '/', '/', '/');
 elseif Trial(expTrial).SetSize == 4
     fprintf (fid, '%1.4f %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f ', Trial(expTrial).ISI(1), Trial(expTrial).ISI(2), Trial(expTrial).ISI(3), Trial(expTrial).ISI(4), 0.0000, 0.0000, 0.0000, 0.000);
     fprintf (fid, '%1d %1d %1d %1d% 1d %1d %1d %1d ', Trial(expTrial).MemSet(1), Trial(expTrial).MemSet(2), Trial(expTrial).MemSet(3), Trial(expTrial).MemSet(4), 0, 0, 0, 0);
     fprintf (fid, '%1s %1s %1s %1s %1s %1s %1s %1s ', Trial(expTrial).MemSetLetters1(1),  Trial(expTrial).MemSetLetters1(2),  Trial(expTrial).MemSetLetters1(3),  Trial(expTrial).MemSetLetters1(4), '/', '/', '/', '/');
 elseif Trial(expTrial).SetSize == 5
     fprintf (fid, '%1.4f %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f ', Trial(expTrial).ISI(1), Trial(expTrial).ISI(2), Trial(expTrial).ISI(3), Trial(expTrial).ISI(4), Trial(expTrial).ISI(5), 0.0000, 0.0000, 0.000);
     fprintf (fid, '%1d %1d %1d %1d% 1d %1d %1d %1d ', Trial(expTrial).MemSet(1), Trial(expTrial).MemSet(2), Trial(expTrial).MemSet(3), Trial(expTrial).MemSet(4), Trial(expTrial).MemSet(5), 0, 0, 0);
     fprintf (fid, '%1s %1s %1s %1s %1s %1s %1s %1s ', Trial(expTrial).MemSetLetters1(1),  Trial(expTrial).MemSetLetters1(2),  Trial(expTrial).MemSetLetters1(3),  Trial(expTrial).MemSetLetters1(4),  Trial(expTrial).MemSetLetters1(5), '/', '/', '/');
 elseif Trial(expTrial).SetSize == 6
     fprintf (fid, '%1.4f %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f ', Trial(expTrial).ISI(1), Trial(expTrial).ISI(2), Trial(expTrial).ISI(3), Trial(expTrial).ISI(4), Trial(expTrial).ISI(5), Trial(expTrial).ISI(6), 0.0000, 0.000);
     fprintf (fid, '%1d %1d %1d %1d% 1d %1d %1d %1d ', Trial(expTrial).MemSet(1), Trial(expTrial).MemSet(2), Trial(expTrial).MemSet(3), Trial(expTrial).MemSet(4), Trial(expTrial).MemSet(5), Trial(expTrial).MemSet(6), 0, 0);
     fprintf (fid, '%1s %1s %1s %1s %1s %1s %1s %1s ', Trial(expTrial).MemSetLetters1(1),  Trial(expTrial).MemSetLetters1(2),  Trial(expTrial).MemSetLetters1(3),  Trial(expTrial).MemSetLetters1(4),  Trial(expTrial).MemSetLetters1(5),  Trial(expTrial).MemSetLetters1(6), '/', '/');
 elseif Trial(expTrial).SetSize == 7
     fprintf (fid, '%1.4f %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f ', Trial(expTrial).ISI(1), Trial(expTrial).ISI(2), Trial(expTrial).ISI(3), Trial(expTrial).ISI(4), Trial(expTrial).ISI(5), Trial(expTrial).ISI(6), Trial(expTrial).ISI(7), 0.000);
     fprintf (fid, '%1d %1d %1d %1d% 1d %1d %1d %1d ', Trial(expTrial).MemSet(1), Trial(expTrial).MemSet(2), Trial(expTrial).MemSet(3), Trial(expTrial).MemSet(4), Trial(expTrial).MemSet(5), Trial(expTrial).MemSet(6), Trial(expTrial).MemSet(7), 0);
     fprintf (fid, '%1s %1s %1s %1s %1s %1s %1s %1s ', Trial(expTrial).MemSetLetters1(1),  Trial(expTrial).MemSetLetters1(2),  Trial(expTrial).MemSetLetters1(3),  Trial(expTrial).MemSetLetters1(4),  Trial(expTrial).MemSetLetters1(5),  Trial(expTrial).MemSetLetters1(6),  Trial(expTrial).MemSetLetters1(7), '/');
 elseif Trial(expTrial).SetSize == 8
     fprintf (fid, '%1.4f %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f ', Trial(expTrial).ISI(1), Trial(expTrial).ISI(2), Trial(expTrial).ISI(3), Trial(expTrial).ISI(4), Trial(expTrial).ISI(5), Trial(expTrial).ISI(6), Trial(expTrial).ISI(7), Trial(expTrial).ISI(8));
     fprintf (fid, '%1d %1d %1d %1d% 1d %1d %1d %1d ', Trial(expTrial).MemSet(1), Trial(expTrial).MemSet(2), Trial(expTrial).MemSet(3), Trial(expTrial).MemSet(4), Trial(expTrial).MemSet(5), Trial(expTrial).MemSet(6), Trial(expTrial).MemSet(7), Trial(expTrial).MemSet(8));
     fprintf (fid, '%1s %1s %1s %1s %1s %1s %1s %1s ', Trial(expTrial).MemSetLetters1(1),  Trial(expTrial).MemSetLetters1(2),  Trial(expTrial).MemSetLetters1(3),  Trial(expTrial).MemSetLetters1(4),  Trial(expTrial).MemSetLetters1(5),  Trial(expTrial).MemSetLetters1(6),  Trial(expTrial).MemSetLetters1(7),  Trial(expTrial).MemSetLetters1(8));
 end
% % Print response information into data file
 fprintf (fid, '%1d %1.4f %1s %1s ', Trial(expTrial).ACC, Trial(expTrial).RT, Trial(expTrial).response, Trial(expTrial).CorResp);
% % Print new Line after each Trial
fprintf (fid, '\n');
fclose (fid);

% Flip again after ITI is over
Trial(expTrial).time_ITI2 = clearScreen(expinfo,next_flip);
end

%% End of Function
