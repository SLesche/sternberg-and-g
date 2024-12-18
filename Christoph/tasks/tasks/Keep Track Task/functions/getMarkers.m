function [expinfo] = getMarkers(expinfo, isPractice, expBlock)
% This is a function that specifies EEG Markers for the experiment and
% saves them into the expinfo object, so that Markers can be accessed
% during the Experiment without any further computational load.

%% Specify Block Markers for Experiment

    Marker.MatlabStart = 122;
    Marker.PracStart = 211;
    Marker.PracEnd = 212;
    Marker.ExpStart = 24;
    Marker.ExpEnd = 25;

if isPractice == 1    
    % Specify Stimulus Markers within each trial
    % Markers for different Screens
    Marker.Fixation1 = zeros(2,2);
    Marker.Fixation2 = zeros(2,2);
    Marker.ReminderCategories = zeros(2,2);
    Marker.ISI = zeros(2,2);
    Marker.MemSet = zeros(2,2);
    Marker.Cue = zeros(2,2);
    Marker.Target = zeros(2,2);
    
    
    Marker.CorrResp_D = 0;
    Marker.CorrResp_L = 0;
    Marker.IncorrResp = 0;
    Marker.IncorrResp_D = 0;
    Marker.IncorrResp_L = 0;
    
    Marker.Block = zeros(1,2);
    
    Marker.ITI = 0;
    
    Marker.Miss = 0;
else
    % Specify Stimulus Markers within each trial
    % Markers for different Screens
    Marker.Fixation1 = zeros(2,2);
    Marker.Fixation2 = zeros(2,2);
    Marker.ReminderCategories = zeros(2,2);
    Marker.ISI = zeros(2,2);
    Marker.MemSet = zeros(2,2);
    Marker.Cue = zeros(2,2);
    Marker.Target = zeros(2,2);

   % Aufteilung nach Updating Ja/Nein und Match Ja Nein und Block = Memory Set ähnlich wie bei N-Back  und nach
% relevanten und nicht relevanten Stimuli im Set 
if expBlock == 1
    for i = expinfo.Match
        for j = expinfo.Updating
            Marker.Fixation1(i+1,j+1) = 31+(i)*2+j;
            Marker.Fixation2(i+1,j+1) = 131+(i)*2+j;
            Marker.ReminderCategories(i+1,j+1) = 81+(i)*2+j;
            Marker.ISI(i+1,j+1) = 41+(i)*2+j;
            Marker.MemSet(i+1,j+1) = 61+(i)*2+j;
            Marker.Cue(i+1,j+1) = 71+(i)*2+j;
            Marker.Target(i+1,j+1) = 51+(i)*2+j;
        end
    end
elseif expBlock == 2
    for i = expinfo.Match
        for j = expinfo.Updating
            Marker.Fixation1(i+1,j+1) = 35+(i)*2+j;
            Marker.Fixation2(i+1,j+1) = 135+(i)*2+j;
            Marker.ReminderCategories(i+1,j+1) = 85+(i)*2+j;
            Marker.ISI(i+1,j+1) = 45+(i)*2+j;
            Marker.MemSet(i+1,j+1) = 65+(i)*2+j;
            Marker.Cue(i+1,j+1) = 75+(i)*2+j;
            Marker.Target(i+1,j+1) = 55+(i)*2+j;
        end
    end
end
    
    Marker.CorrResp_D = 150;
    Marker.CorrResp_L = 160;
    Marker.IncorrResp = 251;
    Marker.IncorrResp_D = 250;
    Marker.IncorrResp_L = 255;
    
Marker.Block = zeros(1,2);
Marker.Block(1,1) = 100 + expBlock;
Marker.Block(1,2) = 200 + expBlock;
    
    Marker.ITI = 90;
    
    Marker.Miss = 222;
end
%% Write Markers into expinfo object
expinfo.Marker = Marker;
end