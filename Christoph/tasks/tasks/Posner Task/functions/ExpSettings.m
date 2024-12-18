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
expinfo.InstStop = 4;

%% Timing - fixed in all trials
expinfo.Fix_Duration = 1;  % Duration of the fixation cross at the beginning of a trial
expinfo.Fix_jitter = 0.5; % fixation cross jitter 

expinfo.MinTarget = 1; % Minimum duration of target presentation time 
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

expinfo.Task = 1; % 0 = PhysicalIdentity; 1 = NameIdentity  

expinfo.LettersRight = [1:10]; % A B F H Q a b f h q 
expinfo.LettersLeft = [1:10];  % A B F H Q a b f h q 
expinfo.LetterStrings = {'A', 'B', 'F', 'H', 'Q', 'a', 'b', 'f', 'h', 'q'};
expinfo.Conditions = 1:3; % 1 = Physical Identical, 2 = Name Identical, 3 = Both

expinfo.ColorOnFix = 0;
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

expinfo.nPracTrials = 20;
expinfo.nExpTrials = 120;
expinfo.Block = 1;

% Specify how many Trials in each cell of the experimental design should be
% conducted
expinfo.Trial2Cond = 3;


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
if expinfo.Task == 0
expinfo.pracFile = [expinfo.DataFolder,expinfo.taskName,'Posner_TaskPI_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),pracFile];
expinfo.expFile  = [expinfo.DataFolder,expinfo.taskName,'Posner_TaskPI_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),expFile];
else
expinfo.pracFile = [expinfo.DataFolder,expinfo.taskName,'Posner_TaskNI_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),pracFile];
expinfo.expFile  = [expinfo.DataFolder,expinfo.taskName,'Posner_TaskNI_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),expFile];
end

end 
%% End of Function

