% This function displays one trial of a Simon Task

function Trial = DisplayTrial(expinfo, Trial, expTrial,expBlock, isPractice)
%% Trial Procedure
if expTrial == 1
    WaitSecs(1); % Pre-hac timing so that experimental trials do not start right away
end

% display Fixation Cross
Trial(expTrial).time_fixation1 = TextCenteredOnPos(expinfo,'+',expinfo.centerX,expinfo.centerY,expinfo.Colors.gray,[],Trial(expTrial).FixMarker1);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_fixation1,Trial(expTrial).FIX1);
% WaitSecs(0.05);
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port

if expBlock == 1
    oneormore = 0;
    Trial(expTrial).time_remind = TextCenteredOnPosReminder(expinfo, char(Trial(expTrial).WordMemCategory),expinfo.centerX,expinfo.centerY, expinfo.Colors.gray, oneormore, [] ,next_flip,Trial(expTrial).ReminderMarker);
    next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_remind,expinfo.EncodingTimeRelevantMemory);
%     WaitSecs(0.05);
%     io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
else
    oneormore = 1;
    counter1 = 0;
    TextCenteredOnPosReminder(expinfo, char(Trial(expTrial).WordMemCategory(1)),expinfo.centerX,expinfo.centerY - 60, expinfo.Colors.gray, oneormore,counter1 ,[],[]);
    TextCenteredOnPosReminder(expinfo, char(Trial(expTrial).WordMemCategory(2)),expinfo.centerX,expinfo.centerY, expinfo.Colors.gray, oneormore,counter1 ,[],[]);
    counter1 = 1;
    Trial(expTrial).time_remind = TextCenteredOnPosReminder(expinfo, char(Trial(expTrial).WordMemCategory(3)),expinfo.centerX,expinfo.centerY + 60, expinfo.Colors.gray, oneormore,counter1 , next_flip,Trial(expTrial).ReminderMarker);
    next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_remind,expinfo.EncodingTimeRelevantMemory);
%     WaitSecs(0.05);
%     io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
end

% display Fixation Cross
Trial(expTrial).time_fixation2 = TextCenteredOnPos(expinfo,'+',expinfo.centerX,expinfo.centerY,expinfo.Colors.gray,next_flip ,Trial(expTrial).FixMarker2);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_fixation2,Trial(expTrial).FIX2);
% WaitSecs(0.05);
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
 

% Present MemorySet
for Pos_MemSet = 1:expinfo.SetSize
    
Trial(expTrial).time_ISI1 = clearScreen(expinfo,next_flip,Trial(expTrial).ISIMarker);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_ISI1,Trial(expTrial).ISI(Pos_MemSet));
% WaitSecs(0.05);
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port

counter = 0;

    if Trial(expTrial).CategoryPos(Pos_MemSet) == 1 || Trial(expTrial).CategoryPos(Pos_MemSet) == 2
        Trial(expTrial).time_memstim = DrawStim(expinfo,Trial,expTrial,Pos_MemSet,counter,next_flip,Trial(expTrial).MemSetMarker);
        next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_memstim,expinfo.EncodingTime);
%         WaitSecs(0.05);
%         io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
    elseif Trial(expTrial).CategoryPos(Pos_MemSet) == 3
        Trial(expTrial).time_memstim = TextCenteredOnPos(expinfo, char(expinfo.Letters((Trial(expTrial).StimPos(Pos_MemSet)))),expinfo.centerX,expinfo.centerY, expinfo.Colors.gray, next_flip,Trial(expTrial).MemSetMarker);
        next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_memstim,expinfo.EncodingTime);
%         WaitSecs(0.05);
%         io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
    else 
        Trial(expTrial).time_memstim = TextCenteredOnPos(expinfo, num2str(Trial(expTrial).StimPos(Pos_MemSet)),expinfo.centerX,expinfo.centerY, expinfo.Colors.gray, next_flip,Trial(expTrial).MemSetMarker);
        next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_memstim,expinfo.EncodingTime);
%         WaitSecs(0.05); 
%         io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
    end

end

% display Cue
Trial(expTrial).time_Cue = TextCenteredOnPos(expinfo,'?', expinfo.centerX, expinfo.centerY, expinfo.Colors.gray, next_flip, Trial(expTrial).CueMarker);
next_flip = getAccurateFlip(expinfo.window,Trial(expTrial).time_Cue,Trial(expTrial).CueDuration);
% WaitSecs(0.05);
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port

%% % display Probe Stimulus
counter = 1;

if Trial(expTrial).Category == 1 || Trial(expTrial).Category == 2
    Trial(expTrial).time_probe = DrawStim(expinfo,Trial,expTrial,[],counter,next_flip,Trial(expTrial).TargetMarker);
    Trial = getresponse(expinfo, Trial, expTrial, Trial(expTrial).time_probe);
%    io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
elseif Trial(expTrial).Category == 3
    Trial(expTrial).time_probe = TextCenteredOnPos(expinfo, char(expinfo.Letters((Trial(expTrial).Probe))),expinfo.centerX,expinfo.centerY, expinfo.Colors.gray, next_flip,Trial(expTrial).TargetMarker);
    Trial = getresponse(expinfo, Trial, expTrial, Trial(expTrial).time_probe);
%    io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
else
    Trial(expTrial).time_probe = TextCenteredOnPos(expinfo, num2str(Trial(expTrial).Probe),expinfo.centerX,expinfo.centerY, expinfo.Colors.gray, next_flip,Trial(expTrial).TargetMarker);
    Trial = getresponse(expinfo, Trial, expTrial, Trial(expTrial).time_probe);
%    io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port
end
%%

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
fprintf (fid, '%1d %1d %1d %1d %16s ', expinfo.subject, expinfo.session ,Trial(expTrial).Block, Trial(expTrial).TrialNum, Trial(expTrial).TaskDescription);
% % Print trial specification into data file
fprintf (fid, '%1d %1d %10s %1d ', Trial(expTrial).MemSetSize, Trial(expTrial).Category, Trial(expTrial).RelevantCategory, Trial(expTrial).StimInCategory);

if Trial(expTrial).Category == 4
    fprintf (fid, '%7d ',Trial(expTrial).RelevantStim);
else
    fprintf (fid, '%7s ',Trial(expTrial).RelevantStim);
end

fprintf (fid, '%1d %10s %1d %7s %1d ', Trial(expTrial).Updating, Trial(expTrial).UpdatingDescription, Trial(expTrial).Match, Trial(expTrial).MatchDescription, Trial(expTrial).Position);

if Trial(expTrial).MemSetSize == 1
    fprintf (fid, '%1d %1d ' , 0, 0);
    fprintf (fid, '%1d %1d %1d %10s %10s %10s ', Trial(expTrial).MemCategories, 0, 0, Trial(expTrial).WordMemCategory, 'empty', 'empty');
else
    fprintf (fid, '%1d %1d ' , Trial(expTrial).OtherStimCategories(1), Trial(expTrial).OtherStimCategories(2));
    fprintf (fid, '%1d %1d %1d %10s %10s %10s ',  Trial(expTrial).MemCategories(1), Trial(expTrial).MemCategories(2), Trial(expTrial).MemCategories(3), Trial(expTrial).WordMemCategory(1), Trial(expTrial).WordMemCategory(2), Trial(expTrial).WordMemCategory(3));
end

fprintf (fid, '%1d %10s %1d %1d %1d ', Trial(expTrial).NoUpdatingCategory, Trial(expTrial).NoUpdatingCategoryWord, Trial(expTrial).UpdatingCategorys(1), Trial(expTrial).UpdatingCategorys(2),  Trial(expTrial).UpdatingCategorys(3));
fprintf (fid, '%1d %1d %1d %1d %1d %1d %1d ',  Trial(expTrial).CategoryPos(1), Trial(expTrial).CategoryPos(2), Trial(expTrial).CategoryPos(3), Trial(expTrial).CategoryPos(4), Trial(expTrial).CategoryPos(5), Trial(expTrial).CategoryPos(6), Trial(expTrial).CategoryPos(7));
fprintf (fid, '%1d %1d %1d %1d %1d %1d %1d %1d ',  Trial(expTrial).StimPos(1), Trial(expTrial).StimPos(2), Trial(expTrial).StimPos(3), Trial(expTrial).StimPos(4), Trial(expTrial).StimPos(5), Trial(expTrial).StimPos(6), Trial(expTrial).StimPos(7), Trial(expTrial).Probe);

if Trial(expTrial).Category == 4
    fprintf (fid, '%7d ',Trial(expTrial).ProbeDescr);
else
    fprintf (fid, '%7s ',Trial(expTrial).ProbeDescr);
end

% % Print stimuli and variable timings for ISI & ITI in data dile
fprintf (fid, '%1.4f %1.4f %1.4f %1.4f ', Trial(expTrial).FIX1, Trial(expTrial).FIX2, Trial(expTrial).CueDuration, Trial(expTrial).ITI);
fprintf (fid, '%1.4f %1.4f %1.4f %1.4f %1.4f %1.4f %1.4f ', Trial(expTrial).ISI(1), Trial(expTrial).ISI(2), Trial(expTrial).ISI(3), Trial(expTrial).ISI(4), Trial(expTrial).ISI(5), Trial(expTrial).ISI(6), Trial(expTrial).ISI(7));

% % Print response information into data file
fprintf (fid, '%1d %1.4f %1s %1s ', Trial(expTrial).ACC, Trial(expTrial).RT, Trial(expTrial).response, Trial(expTrial).CorResp);

% % Print new Line after each Trial
fprintf (fid, '\n');
fclose (fid);

% Flip again after ITI is over
Trial(expTrial).time_ITI2 = clearScreen(expinfo,next_flip);
end
%% End of Function
