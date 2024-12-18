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

%% Secify number of general instruction slides
expinfo.InstStop = 4;

%% Timing - fixed in all trials
% Duration of the fixation cross at the beginning of a trial
expinfo.Fix_Duration = 0.4; 

% Jitter for the fixation cross duration
expinfo.Fix_jitter = 0.2;

% Minimum duration of the Inter-Stimulus Interval (ISI)
expinfo.MinISIduration = 0.4; 

% ISI Jitter 
expinfo.ISIjitter = 0.2; 

% Minimum duration of target presentation 
expinfo.MinTarget = 1;

% Maximum allowed reaction time during a trail
expinfo.MaxRT = 3; 

% Minimum duration of the Inter-Trial Interval (ITI)
expinfo.MinITIduration = 0.1; 

% ITI Jitter 
expinfo.ITIjitter = 0.5; 

% Feedback duration 
expinfo.FeedbackDuration = 1;

%% Specify Stimuli to be shown
expinfo.Congruency = 1:2; %(1,2)   1 congruent 2 incongruent
expinfo.Color = 1:4;
expinfo.Words = 1:4; 
expinfo.WordsString ={'rot', 'gelb', 'grün', 'blau'};
expinfo.CongruencyString ={'congruent', 'incongruent'};

expinfo.ColorOnFix = 0; % 1 for color on fixation cross; 0 for color on stimulus
expinfo.LongRT = 1; % Choose 1 for presentation until RT or minimum 1 second; 0 for presentation for 250 ms


%% Specify Response Keys used in the experiment
expinfo.LeftKey = 'd';
expinfo.RightKey = 'l';
expinfo.AbortKey = 'F12';
expinfo.RespKeys = {'y' 'c' 'b' 'm'};
expinfo.RespMapping = [1 2 3 4];

%% Defining trials to be conducted
% Specify how many trials should be conducted

expinfo.nPracTrials = 20;
expinfo.nExpTrials = 192;
expinfo.Block = 1;

% Specify how many Trials in each cell of the experimental design should be
% conducted
expinfo.Trial2Cond = 8;


%% definition of colors in the HSL colorspace
expinfo.Colors.green = [0 178 30];
expinfo.Colors.red = [255 25 32];
expinfo.Colors.blue = [25 50 255];
expinfo.Colors.yellow = [255 255 25];
expinfo.Colors.gray = [140 140 140];
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
expinfo.pracFile = [expinfo.DataFolder,expinfo.taskName,'Stroop_Task_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),pracFile];
expinfo.expFile  = [expinfo.DataFolder,expinfo.taskName,'Stroop_Task_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),expFile];

%% End of Function
