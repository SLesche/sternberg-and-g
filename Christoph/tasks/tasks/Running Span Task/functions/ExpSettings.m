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
expinfo.InstStopBlock1 = 4;
expinfo.InstStopBlock2 = 2;

%% Timing - fixed in all trials
expinfo.MinFixduration = 0.4; % Duration of the fixation cross at the beginning of a trial
expinfo.Fixjitter = 0.2; % Jitter for the fixation cross duration

expinfo.MinISIduration = 0.4; % Minimum duration of the Inter-Stimulus Interval (ISI)
expinfo.ISIjitter = 0.2; % ISI Jitter 

expinfo.MinTarget = 1; % Minimum presentation timeof the target
expinfo.MaxRT = 3; % Maximum allowed reaction time during a trail

expinfo.MinCueDuration = 0.8; % Minimum duration of cue presentaion 
expinfo.Cuejitter = 0.4; % Jitter for the cue duration

expinfo.MinITIduration = 1; % Minimum duration of the Inter-Trial Interval (ITI)
expinfo.ITIjitter = 0.5; % ITI Jitter

expinfo.EncodingTime = 1; % Encoding time

expinfo.FeedbackDuration = 1; % Feedback duration

%% Specify Stimuli to be shown
expinfo.Digits = 1:4;
expinfo.letters = {'C' 'F' 'H' 'K' 'M' 'P' 'R' 'T' 'W' 'Z'};
expinfo.Match = [0 1]; % 0 = NoMatch, 1 = Match
expinfo.SetSize1 = 0;
expinfo.SetSize2 = [1 2 3]; 
expinfo.Stimuli = 1:10; 

% Should the cue (fixation cross) be colored (1 yes 0 no)
expinfo.ColorOnFix = 1; 

% 1 for presentation until response time or minimum 1 second; 0 for presentation until 250 ms are reaced 
expinfo.LongRT = 1; 

%% Specify Response Keys used in the experiment
expinfo.LeftKey = 'd';
expinfo.RightKey = 'l';
expinfo.AbortKey = 'F12';
expinfo.RespKeys = {'d' 'l'};
expinfo.ResponseMapping = [1 2];

%% Defining trials to be conducted
% Specify how many trials should be conducted
expinfo.nPracTrials = 10;%
expinfo.nExpTrials = 120;% 
expinfo.Block = 2;
expinfo.Trial2Cond1 = 1;
expinfo.Trial2Cond2 = 3;

%% definition of colors in the HSL colorspace
expinfo.Colors.green =  [0 178 30];
expinfo.Colors.red = [255 25 32];
expinfo.Colors.gray =  [140 140 140];
expinfo.Colors.bgColor = [0 0 0];
expinfo.Colors.blue = [25 50 255];
expinfo.Colors.yellow = [255 255 25];
expinfo.Colors.orange = [255 150 25];
expinfo.Colors.turquois = [0 255 255];
expinfo.Colors.pink = [255  25 255];


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

expinfo.pracFile = [expinfo.DataFolder,expinfo.taskName,'N-Back-Task_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),pracFile];
expinfo.expFile  = [expinfo.DataFolder,expinfo.taskName,'N-Back-Task_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),expFile];
end 
%% End of Function
