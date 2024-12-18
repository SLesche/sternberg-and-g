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
expinfo.InstStop = 4;

%% Timing - fixed in all trials
% Duration of the fixation cross at the beginning of a trial
expinfo.MinFixduration = 0.4;

% Jitter for the fixation cross duration
expinfo.Fixjitter = 0.2;

% Minimum duration of the Inter-Stimulus Interval (ISI)
expinfo.MinISIduration = 0.4;

% ISI Jitter = Interval in which the ISI is allowed to vary
expinfo.ISIjitter = 0.2;

% Minimum duration of targets presentation
expinfo.MinTarget = 1;

% Maximum allowed reaction time during a trail
expinfo.MaxRT = 3;

% Minimum duration of the Inter-Trial Interval (ITI)
expinfo.MinITIduration = 1;

% ITI Jitter 
expinfo.ITIjitter = 0.5;

% Feedback duration 
expinfo.FeedbackDuration = 1;

%% Specify Stimuli to be shown
expinfo.PositionsTarget = [1:4]; % from left to right
expinfo.PositionsDistractor = [1:4];
expinfo.Priming = [1 2]; % 1 = Non Priming; 2 = Priming
expinfo.Trial2Cond = 2;

expinfo.ColorOnFix = 0; % 1 colored fixation cross; 0 = non-colored fixation cross
expinfo.LongRT = 1; % 1 = Presentation until response time (RT) or minimum 1 second; 0 = Presentation for 250 ms

%% Specify Response Keys used in the experiment
expinfo.LeftKey = 'd';
expinfo.RightKey = 'l';
expinfo.AbortKey = 'F12';
expinfo.RespKeys = {'s' 'f' 'h' 'k'};
expinfo.ResponseMapping = [1 2 3 4];

% Example: Balance response mapping across participants
% if mod(expinfo.subject,2) == 0
%     expinfo.ResponseMapping = [1 2];
%     else
%     expinfo.ResponseMapping = [2 1];
% end

%% Defining trials to be conducted
% Specify how many trials should be conducted
expinfo.nPracTrials = 20;
expinfo.nExpTrials = 192;
expinfo.Block = 1;

%% Rectangle positions

expinfo.XRectCenterPos1 = expinfo.centerX - 106.5;
expinfo.XRectCenterPos2 = expinfo.centerX - 35.5;
expinfo.XRectCenterPos3 = expinfo.centerX + 35.5;
expinfo.XRectCenterPos4 = expinfo.centerX + 106.5;
expinfo.YRectCenterPos = expinfo.centerY + 25;

expinfo.RectSize = [0 0 35.5 2];

expinfo.Rect1 = CenterRectOnPoint(expinfo.RectSize,expinfo.XRectCenterPos1,expinfo.YRectCenterPos);
expinfo.Rect2 = CenterRectOnPoint(expinfo.RectSize,expinfo.XRectCenterPos2,expinfo.YRectCenterPos);
expinfo.Rect3 = CenterRectOnPoint(expinfo.RectSize,expinfo.XRectCenterPos3,expinfo.YRectCenterPos);
expinfo.Rect4 = CenterRectOnPoint(expinfo.RectSize,expinfo.XRectCenterPos4,expinfo.YRectCenterPos);

    
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

expinfo.pracFile = [expinfo.DataFolder,expinfo.taskName,'SternbergTask_',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),pracFile];
expinfo.expFile  = [expinfo.DataFolder,expinfo.taskName,'SternbergTask_',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),expFile];
end 
%% End of Function
