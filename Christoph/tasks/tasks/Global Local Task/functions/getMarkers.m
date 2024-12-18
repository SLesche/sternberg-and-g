function [expinfo] = getMarkers(expinfo, isPractice)
% This is a function that specifies EEG Markers for the experiment and
% saves them into the expinfo object, so that Markers can be accessed
% during the Experiment without any further computational load.

%% Specify Block Markers for Experiment

Marker.MatlabStart = 117;
Marker.PracStart = 211;
Marker.PracEnd = 212;
Marker.ExpStart = 14;
Marker.ExpEnd = 15;


%% Specify Stimulus Markers within each trial
% Markers for different Screens
if isPractice == 1
    Marker.Fixation = zeros(2,2);
    Marker.ISI = zeros(2,2);
    Marker.Target = zeros(2,2);
    Marker.ITI = 0;
    Marker.Miss = 0;
    Marker.CorrResp_left = 0;
    Marker.CorrResp_right = 0;
    Marker.IncorrResp = 0;  
    Marker.IncorrResp_left = 0;
    Marker.IncorrResp_right = 0;
    Marker.Block = zeros(expinfo.Block,2);
else
    Marker.Fixation = zeros(2,2);
    Marker.ISI = zeros(2,2);
    Marker.Target = zeros(2,2);
    
    for i = expinfo.Task % 1 Global 2 Local
        for j = expinfo.Shifting % 0 Repeat 1 Shifting
            Marker.Fixation(i,j+1) = 31+(i-1)*2+j;
            Marker.ISI(i,j+1) = 41+(i-1)*2+j;
            Marker.Target(i,j+1) = 51+(i-1)*2+j;
        end
    end
    Marker.ITI = 90;
    Marker.Miss = 222;
    
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
end
%% Write Markers into expinfo object
expinfo.Marker = Marker;
end

