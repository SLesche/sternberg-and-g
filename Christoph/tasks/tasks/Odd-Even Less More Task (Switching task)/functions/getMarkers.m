function [expinfo] = getMarkers(expinfo, isPractice)
% This is a function that specifies EEG Markers for the experiment and
% saves them into the expinfo object, so that Markers can be accessed
% during the Experiment without any further computational load.

%% Specify Block Markers for Experiment

    Marker.MatlabStart = 113;
    Marker.PracStart = 211;
    Marker.PracEnd = 212;
    Marker.ExpStart = 6;
    Marker.ExpEnd = 7;

if isPractice == 1    
    % Specify Stimulus Markers within each trial
    % Markers for different Screens
    Marker.Fixation = zeros(2,2);
    Marker.ISI = zeros(2,2);
    Marker.Target = zeros(2,2);
    
    
    Marker.CorrResp_D = 0;
    Marker.CorrResp_L = 0;
    Marker.IncorrResp = 0;
    Marker.IncorrResp_D = 0;
    Marker.IncorrResp_L = 0;
    
    Marker.Block = zeros(expinfo.Block,2);
    
    Marker.ITI = 0;
    
    Marker.Miss = 0;
else
    % Specify Stimulus Markers within each trial
    % Markers for different Screens
    Marker.Fixation = zeros(2,2);
    Marker.ISI = zeros(2,2);
    Marker.Target = zeros(2,2);
    
    for i = expinfo.Task
        for j = expinfo.Shifting       
            Marker.Fixation(i,j+1) = 31+(i-1)*2+j;
            Marker.ISI(i,j+1) = 41+(i-1)*2+j;
            Marker.Target(i,j+1) = 51+(i-1)*2+j;
        end
    end
    
    Marker.CorrResp_D = 150;
    Marker.CorrResp_L = 160;
    Marker.IncorrResp = 251;
    Marker.IncorrResp_D = 250;
    Marker.IncorrResp_L = 255;
    
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

