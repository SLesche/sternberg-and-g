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
%expinfo.ioObj = io64;
%expinfo.IOstatus = io64(expinfo.ioObj);
%expinfo.PortAddress = hex2dec('E010');
%io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port

%% Specify Stimulus and Text properties (Size, Position, etc.)
expinfo.stimulussize = 40; % in Pixel bzw. Point

%% Secify number of general instruction slides
expinfo.InstStop = 4;

%% Timing - fixed in all trials
expinfo.MinFixduration = 1; % Duration of the fixation cross at the beginning of a trial
expinfo.Fixjitter = 0.5;

expinfo.MinISIduration = 0.4; % Minimum duration of the Inter-Stimulus-Interval (ISI)
expinfo.ISIjitter = 0.6; % ISI Jitter = Interval in which the ISI is allowed to vary

expinfo.MinTarget = 1;
expinfo.MaxRT = 3; % Maximum allowed response time for a trail

expinfo.MinITIduration = 1; % Minimum duration of the Inter-Trial-Interval (ITI)
expinfo.ITIjitter = 0.5; % ITI Jitter

expinfo.MinCueDuration = 1.8 ; % Minimum duration of cue presentaion 
expinfo.Cuejitter = 0.4; 

expinfo.FeedbackDuration = 1;

expinfo.EncodingTime = 1;

%% Specify Stimuli to be shown
expinfo.Digits = 0:9;
expinfo.SetSizes = 5;
expinfo.Match = 0:1; % 0 = NoMatch, 1 = Match

expinfo.ColorOnFix = 0; % 1 for color on fixation cross; 0 for color on stimulus
expinfo.LongRT = 1; % Choose 1 for presentation until RT or minimum 1 second; 0 for presentation for 250 ms

%% Specify Response Keys used in the experiment
expinfo.LeftKey = 'd';
expinfo.RightKey = 'l';
expinfo.AbortKey = 'F12';
expinfo.RespKeys = {'d' 'l'};
expinfo.ResponseMapping = [1 2];

% Example: Balance response mapping across participants
% if mod(expinfo.subject,2) == 0
%     expinfo.ResponseMapping = [1 2];
%     else
%     expinfo.ResponseMapping = [2 1];
% end

%% Defining trials to be conducted
% Specify how many trials should be conducted
expinfo.nPracTrials = 2;%20;
expinfo.nExpTrials = 4;%100;
expinfo.Block = 1;

% Specify how many Trials in each cell of the experimental design should be
% conducted
expinfo.Trial2Cond = 2;


%% definition of colors in the HSL colorspace
expinfo.Colors.green =  [0 178 30];
expinfo.Colors.red = [255 25 32];
expinfo.Colors.gray =  [140 140 140];
expinfo.Colors.bgColor = [0 0 0];

%% Fonts
expinfo.Fonts.textFont  = expinfo.Fonts.sansSerifFont;

%% Specify Instruction folder
expinfo.InstFolder      = 'Instructions/';
expinfo.InstExtension   = '.JPG';
expinfo.DataFolder      = 'DataFiles/';

%% datafiles and messages
pracFile = 'prac.txt'; % extension for the practice trial data
expFile  = 'exp.txt';  % extension fot the expreimental trial data

% Adjusting the file-names to a different name for each subject

expinfo.pracFile = [expinfo.DataFolder,expinfo.taskName,'SternbergTask_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),pracFile];
expinfo.expFile  = [expinfo.DataFolder,expinfo.taskName,'SternbergTask_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),expFile];
end 
%% End of Function

