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
expinfo.InstStopBlock1 = 7;
expinfo.InstStopBlock2 = 3;

%% Timing - fixed in all trials
expinfo.MinFixduration = 0.4; % Duration of the fixation cross at the beginning of a trial
expinfo.Fixjitter = 0.2;

expinfo.MinISIduration = 0.4; % Minimum duration of the Inter-Stimulus Interval (ISI)
expinfo.ISIjitter = 0.2; % ISI Jitter = Interval in which the ISI is allowed to vary

expinfo.MinTarget = 1;  % Minimum duration of target presentation time 
expinfo.MaxRT = 3; % Maximum allowed reaction time during a trial


expinfo.MinITIduration =1; % Minimum duration of the Inter-Trial Interval (ITI)
expinfo.ITIjitter =0.5; % ITI Jitter

expinfo.MinCueDuration = 0.8; % Minimum duration of the cue presentation 
expinfo.Cuejitter = 0.4; % cue jitter

expinfo.FeedbackDuration = 1;  % Duration of the Feedback

expinfo.EncodingTime = 1;

expinfo.EncodingTimeRelevantMemory = 2; % encoding time for the slide that indicates the relevant category 

%% Experimental Manipulations
% expinfo.LocationCon = {'congruent' 'incongruent'};
% expinfo.LocConFactor = 1:length(expinfo.LocationCon);
% 
% expinfo.CueCondition = {'valid' 'invalid'};
% expinfo.CueCondFactor = 1:length(expinfo.CueCondition);

%% Specify Stimuli to be shown
expinfo.Category = 1:4;
expinfo.Stim2Category = 1:6; 
expinfo.SetSize = 7;
expinfo.Match = 0:1; % 0 = NoMatch, 1 = Match
expinfo.Updating = 0:1; % 0 = NoUpdating, 1 = Updating
expinfo.Letters = {'B' 'C' 'D' 'F' 'G' 'H'};

expinfo.ColorOnFix = 0; % 1 Farbe auf Fixationskreuz; 0 = Farbe auf Stimulus
expinfo.LongRT = 1; % 1 = Präsentation bis RT oder min 1 Sec; 0 = Präsentation 250 ms

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
expinfo.nPracTrials = 10; %10;
expinfo.nExpTrials = 96; %96;
expinfo.Block = 2;

% Specify how many Trials in each cell of the experimental design should be
% conducted
expinfo.Trial2Cond = 1;

%% definition of colors in the HSL colorspace

expinfo.Colors.green = [0 178 30];
expinfo.Colors.red = [255 25 32];
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
expinfo.DataFolder      = 'DataFiles/';

%% datafiles and messages
pracFile = 'prac.txt'; % extension for the practice trial data
expFile  = 'exp.txt';  % extension fot the expreimental trial data

% Adjusting the file-names to a different name for each subject

expinfo.pracFile = [expinfo.DataFolder,expinfo.taskName,'KeepTrackTask_',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),pracFile];
expinfo.expFile  = [expinfo.DataFolder,expinfo.taskName,'KeepTrackTask_',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),expFile];
end 
%% End of Function
