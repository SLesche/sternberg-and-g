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

%% Stimuli information for Global Local Task
[xCenter, yCenter] = RectCenter(expinfo.rect);
expinfo.yTargetPos = yCenter;
expinfo.xTargetPos = xCenter;
expinfo.globalRadius = 100;
expinfo.localSize = 15;
expinfo.nStim2Side = 7;
expinfo.nStimuliCircle = 16;
expinfo.Stimuli = 1:12; 

%% Specify Stimulus and Text properties (Size, Position, etc.)
expinfo.stimulussize = 40; % in Pixel bzw. Point


%% Secify number of general instruction slides
expinfo.InstStop = 6;

%% Timing - fixed in all trials
expinfo.Fix_Duration = 0.4; % Duration of the fixation cross at the beginning of a trial
expinfo.Fix_jitter = 0.2; 

expinfo.MinISIduration = 0.4; % Minimum duration of the Inter-Stimulus Interval (ISI)
expinfo.ISIjitter = 0.2; % ISI Jitter = Interval in which the ISI is allowed to vary

expinfo.MinTarget = 1;  % Minimum duration of target presentation time 
expinfo.MaxRT = 3; % Maximum allowed reaction time during a trial


expinfo.MinITIduration =1; % Minimum duration of the Inter-Trial Interval (ITI)
expinfo.ITIjitter =0.5; % ITI Jitter

expinfo.FeedbackDuration = 1; % Duration of the Feedback

%% Initiate Input Output settings for Markers
% expinfo.ioObj = io64;
% expinfo.IOstatus = io64(expinfo.ioObj);
% expinfo.PortAddress = hex2dec('E010');
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port

%% Specify Stimuli to be shown

expinfo.Task = [1 2]; % 1 Global, 2 Local
expinfo.Shifting = [0 1]; % 0 repeat, 1 shift

expinfo.ColorOnFix = 1; % 0 = no, 1 yes
expinfo.LongRT = 1; % 1 yes 0 no


%% Specify Response Keys used in the experiment
expinfo.LeftKey = 'd'; 
expinfo.RightKey = 'l';
expinfo.AbortKey = 'F12';
expinfo.RespKeys = {'w' 'r' 'i' 'p'}; % W = Quadrat, R = Kreuz, I = Kreis, P = Dreieck
expinfo.ResponseMapping = [1 2 3 4];

% Example: Balance response mapping across participants
% if mod(expinfo.subject,2) == 0
%     expinfo.ResponseMapping = [1 2];
%     else
%     expinfo.ResponseMapping = [2 1];
% end

%% Defining trials to be conducted
% Specify how many trials should be conducted

expinfo.nPracTrials = 10;
expinfo.nExpTrials = 384;
expinfo.Block = 1;

% Specify how many Trials in each cell of the experimental design should be
% conducted
expinfo.Trial2Cond = 8;

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
expinfo.pracFile = [expinfo.DataFolder,expinfo.taskName,'GlobalLocal_Task_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),pracFile];
expinfo.expFile  = [expinfo.DataFolder,expinfo.taskName,'GlobalLocal_Task_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),expFile];

end 
%% End of Function

