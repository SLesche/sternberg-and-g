function [expinfo] = getMarkers(expinfo, isPractice, expBlock)
% This is a function that specifies EEG Markers for the experiment and
% saves them into the expinfo object, so that Markers can be accessed
% during the Experiment without any further computational load.

%% Specify Block Markers for Experiment

    Marker.MatlabStart = 121;
    Marker.PracStart = 211;
    Marker.PracEnd = 212;
    Marker.ExpStart = 22;
    Marker.ExpEnd = 23;

%% Specify Stimulus Markers within each trial
% Markers for different Screens
if isPractice == 1
Marker.Fixation = zeros(2,1);
Marker.MemSet = zeros(2,1);
Marker.ISI = zeros(2,1);
Marker.Cue = zeros(2,1);
Marker.ProbeStim = zeros(2,1);

Marker.CorrResp_D = 0;
Marker.CorrResp_L = 0;
Marker.IncorrResp = 0;
Marker.IncorrResp_D = 0;
Marker.IncorrResp_L = 0;

Marker.Block = zeros(1,2);
Marker.ITI = 0;
Marker.Miss = 0;
else
Marker.Fixation = zeros(2,1);
Marker.MemSet = zeros(2,1);
Marker.ISI = zeros(2,1);
Marker.Cue = zeros(2,1);
Marker.Digits = zeros(2,1);

if expBlock == 1
    for i = expinfo.Match
        Marker.Fixation(i+1) = 31+(i);
        Marker.ISI(i+1) = 41+(i);
        Marker.MemSet(i+1) = 61+(i);
        Marker.Cue (i+1) = 71+(i);
        Marker.ProbeStim(i+1) = 51+(i);
        Marker.ITI = 90;
    end
elseif expBlock == 2
    for i = expinfo.Match
        Marker.Fixation(i+1) = 131+(i);
        Marker.ISI(i+1) = 141+(i);
        Marker.MemSet(i+1) = 161+(i);
        Marker.Cue (i+1) = 171+(i);
        Marker.ProbeStim(i+1) = 151+(i);
        Marker.ITI = 190;
    end
end

Marker.CorrResp_D = 230;
Marker.CorrResp_L = 240;
Marker.IncorrResp = 251;
Marker.IncorrResp_D = 250;
Marker.IncorrResp_L = 255;

Marker.Block = zeros(1,2);
Marker.Block(1,1) = 100 + expBlock;
Marker.Block(1,2) = 200 + expBlock;

Marker.Miss = 222;
end
%% Write Markers into expinfo object
expinfo.Marker = Marker;
end

