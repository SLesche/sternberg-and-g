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

%% Specify Stimulus and Text properties (Size, Position, etc.)
expinfo.stimulussize = 40; % in Pixel bzw. Point

%% Secify number of general instruction slides
expinfo.InstStop = 5;

%% Timing - fixed in all trials
% Duration of the fixation cross at the beginning of a trial
expinfo.Fix_Duration = 0.4; 

% Jitter for the fixation 
expinfo.Fix_jitter = 0.2;

% Minimum duration of the Inter-Stimulus Interval (ISI)
expinfo.MinISIduration = 0.4; 

% ISI Jitter 
expinfo.ISIjitter = 0.2; 

% Minimum time of target presentation  
expinfo.MinTarget = 1;

% Maximum allowed reaction time during a trail
expinfo.MaxRT = 3; 

% Minimum duration of the Inter-Trial Interval (ITI)
expinfo.MinITIduration = 1; 

% ITI Jitter 
expinfo.ITIjitter = 0.5; 

% Feedback duration 
expinfo.FeedbackDuration = 1;

%% Initiate Input Output settings for Markers
% expinfo.ioObj = io64;
% expinfo.IOstatus = io64(expinfo.ioObj);
% expinfo.PortAddress = hex2dec('E010');
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port

%% Specify Stimuli to be shown
expinfo.Numbers = [1:4,6:9];
expinfo.LettersStrings = {'A', 'E', 'I', 'U', 'G', 'K', 'M', 'R'};
expinfo.Vowels = {'A', 'E', 'I', 'U'};
expinfo.Consonants = {'G', 'K', 'M', 'R'};
expinfo.Letters = 1:8;


expinfo.Numcol = 'red';
expinfo.Letcol = 'green';
expinfo.NeutralCol = 'grey';

expinfo.Task = [1 2]; % 1 = Numbers, 2 = Letters
expinfo.Shifting = [0 1]; % 0 = Repeat , 1 = Shift

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

% Example: Balance response mapping across participants
% if mod(expinfo.subject,2) == 0
%     expinfo.ResponseMapping = [1 2];
%     else
%     expinfo.ResponseMapping = [2 1];
% end

%% Defining trials to be conducted
% Specify how many trials should be conducted


expinfo.nPracTrials = 10;
expinfo.nExpTrials = 256; 
expinfo.Block = 1;

% Specify how many Trials in each cell of the experimental design should be
% conducted
expinfo.Trial2Cond = 1; 


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

expinfo.pracFile = [expinfo.DataFolder,expinfo.taskName,'Shifting_NumLet_Task_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),pracFile];
expinfo.expFile  = [expinfo.DataFolder,expinfo.taskName,'Shifting_NumLer_Task_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),expFile];
end
%% End of Function

