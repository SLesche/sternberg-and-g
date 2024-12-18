function [expinfo] = getMarkers(expinfo, isPractice)
% This is a function that specifies EEG Markers for the experiment and
% saves them into the expinfo object, so that Markers can be accessed
% during the Experiment without any further computational load.

%% Specify Block Markers for Experiment

    Marker.MatlabStart = 118;
    Marker.PracStart = 211;
    Marker.PracEnd = 212;
    Marker.ExpStart = 16;
    Marker.ExpEnd = 17;

%% Specify Stimulus Markers within each trial
% Markers for different Screens
if isPractice == 1
Marker.Fixation = zeros(2,1);
Marker.MemSet = zeros(2,1);
Marker.ISI = zeros(2,1);
Marker.Cue = zeros(2,1);
Marker.Digits = zeros(2,1);

Marker.CorrResp_D = 0;
Marker.CorrResp_L = 0;
Marker.IncorrResp = 0;
Marker.IncorrResp_D = 0;
Marker.IncorrResp_L = 0;

Marker.Block = zeros(expinfo.Block,2);
Marker.ITI = 0;
Marker.Miss = 0;
else
Marker.Fixation = zeros(2,1);
Marker.MemSet = zeros(2,1);
Marker.ISI = zeros(2,1);
Marker.Cue = zeros(2,1);
Marker.Digits = zeros(2,1);


for i = expinfo.Match % 0 = NoMatch, 1 = Match
    Marker.Fixation(i+1) = 31+(i); 
    Marker.MemSet(i+1) = 61+(i);
    Marker.ISI(i+1) = 41+(i);
    Marker.Cue (i+1) = 71+(i);
    Marker.Digits(i+1) = 51+(i);
end

Marker.CorrResp_D = 150;
Marker.CorrResp_L = 160;
Marker.IncorrResp = 251;
Marker.IncorrResp_D = 250;
Marker.IncorrResp_L = 255;

Marker.Block = zeros(1,2);
for i = 1:expinfo.Block
    Marker.Block(i,1) = 100 + i;
    Marker.Block(i,2) = 200 + i ;
end
Marker.ITI = 90;
Marker.Miss = 222;
end
%% Write Markers into expinfo object
expinfo.Marker = Marker;
end

