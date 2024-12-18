function [expinfo] = getMarkers(expinfo,isPractice)
% This is a function that specifies EEG Markers for the experiment and
% saves them into the expinfo object, so that Markers can be accessed
% during the Experiment without any further computational load.

%% Specify Block Markers for Experiment

    Marker.MatlabStart = 119;
    Marker.PracStart = 211;
    Marker.PracEnd = 212;
    Marker.ExpStart = 18;
    Marker.ExpEnd = 19;

%% Specify Stimulus Markers within each trial
% Markers for different Screens
if isPractice == 1
Marker.Fixation = zeros(2,1);
Marker.ISI = zeros(2,1);
Marker.Stimulus = zeros(2,1);

Marker.CorrResp_left = 0;
Marker.CorrResp_right = 0;
Marker.IncorrResp = 0;  
Marker.IncorrResp_left = 0;
Marker.IncorrResp_right = 0;

Marker.Block = zeros(expinfo.Block,2);
Marker.ITI = 0;
Marker.Miss = 0;    
else    

Marker.Fixation = zeros(2,1);
Marker.ISI = zeros(2,1);
Marker.Stimulus = zeros(2,1);

for i = expinfo.Priming
    Marker.Fixation(i) = 30+(i); % 31 = NoPrim, 32 = Priming
    Marker.ISI(i) = 40+(i);
    Marker.Stimulus(i) = 50+(i);
end

Marker.CorrResp_left = 150;
Marker.CorrResp_right = 160;
Marker.IncorrResp = 251;
Marker.IncorrResp_left = 250;
Marker.IncorrResp_right = 255;

Marker.Block = zeros(expinfo.Block,2);
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

