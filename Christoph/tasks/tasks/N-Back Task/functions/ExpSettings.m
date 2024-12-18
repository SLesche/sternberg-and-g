% This function loads all settings for the experiment

function expinfo = ExpSettings(expinfo)
%% Get Date an time for this session
expinfo.DateTime = datetime('now');

expinfo.DateTime.Format = 'dd-MMM-yyyy';
expinfo.Date = cellstr(expinfo.DateTime);
expinfo.Date = expinfo.Date{1};

expinfo.DateTime.Format = 'hh:mm:ss';
expinfo.Time = cellstr(expinfo.DateTime);
expinfo.Time = expinfo.Time{1};

%% Initiate Input Output settings for Markers
% expinfo.ioObj = io64;
% expinfo.IOstatus = io64(expinfo.ioObj);
% expinfo.PortAddress = hex2dec('E010');
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port

%% Specify Stimulus and Text properties (Size, Position, etc.)
expinfo.stimulussize = 40; % in Pixel bzw. Point

%% Secify number of general instruction slides
expinfo.InstStop0Back = 4;
expinfo.InstStop1Back = 4;
expinfo.InstStop2Back = 4;

%% Timing - fixed in all trials
expinfo.MinFixduration = 0.5; % Duration of the fixation cross at the beginning of a trial
expinfo.Fixjitter = 0; % Jitter for the fixation cross duration

expinfo.MinISIduration = 0.4; % Minimum duration of the Inter-Stimulus Interval (ISI)
expinfo.ISIjitter = 0.2; % ISI Jitter 

expinfo.MinTarget = 1.5; % Minimum duration of target presentation 
expinfo.MaxRT = 1.5; % Maximum duration of target presentation 

expinfo.MinITIduration =0.0; % % Minimum duration of the Inter-Trial Interval (ITI)
expinfo.ITIjitter =0.0; %ITI Jitter

expinfo.FeedbackDuration = 0.5; % Feedback duration 
%% Experimental Manipulations

%% Specify Stimuli to be shown
expinfo.Digits = 1:4;
expinfo.Letters = {'S' 'H' 'C' 'F'};
expinfo.Match = 1:2; % 2 = NoMatch, 1 = Match

expinfo.ColorOnFix = 0; % 1 for color on fixation cross; 0 for color on stimulus
expinfo.LongRT = 1; % Choose 1 for presentation until RT or minimum 1 second; 0 for presentation for 250 ms

%% Specify Response Keys used in the experiment
expinfo.LeftKey = 'd';
expinfo.RightKey = 'l';
expinfo.AbortKey = 'F12';
expinfo.RespKeys = {'d' 'l'};
expinfo.ResponseMapping = [1 2];

%% Defining trials to be conducted
% Specify how many trials should be conducted
expinfo.Block = 3;

%% definition of colors in the HSL colorspace
expinfo.Colors.green =  [25 255 25];
expinfo.Colors.red = [255 25 25];
expinfo.Colors.gray =  [140 140 140];
expinfo.Colors.blue = [25 50 255];
expinfo.Colors.yellow = [255 255 25];
expinfo.Colors.orange = [255 150 25];
expinfo.Colors.turquois = [0 255 255];
expinfo.Colors.pink = [255  25 255];
expinfo.Colors.bgColor = [0 0 0];

%% Fonts
expinfo.Fonts.textFont  = expinfo.Fonts.sansSerifFont;

%% Specify Instruction folder
expinfo.InstFolder      = 'Instructions/';
expinfo.InstExtension   = '.JPG';

end 
%% End of Function