%% Name of the experiment %%
% It is good practice to give a short desctiption of your experiment

clear all; % Start the experiment with empty workspace
clc; % Clear command window

% Create Folder for BackUp Files if it does not exist
if ~exist('DataFiles', 'dir')
    mkdir DataFiles
end

% Add folders to MATLAB to access functions, instruction slides, and
% location for data backup
addpath('functions', 'Instructions', 'DataFiles');   
%% Enter Subject & Session ID + further Info if needed %%
% Define a task name
TaskName = 'Shifting Task - Number Letter Task';


% Definde variables to be specified when the experiment starts.
vars = {'sub','ses','prac'};
% The following variables can be specified:
    % Subject ID = 'sub'
    % Session Number = 'ses'
    % Test Run = 'test'
    % Instruction Language = 'lang'
    % Run practive = 'prac'
    % Subject's Age = 'age'
    % Subject's Gender = 'gender'
    % Subject's Sex = 'sex'

% Run provideInfo function. This opens up a dialoge box asking for the
% specified information. For all other variables default values are used.
expinfo = provideInfo(TaskName,vars); 
clearvars TaskName vars % clean up workspace

%% Allgemeine Einstellungen & Start von PTB %%
% Setting a seed for randomization ensures that you can reproduce
% randomized variables for each subject and session id.
expinfo.mySeed = 100 * expinfo.subject+ expinfo.session;
rng(expinfo.mySeed);

% Check wether PTB is installed
% checkPTB(); % no longer necessary because implemented in the startPTB function

% Open PTB windown
expinfo = startPTB(expinfo,expinfo.testExp); 

% Read in Exp Settings. This is only to keep your wrapper code tidy and
% structured. All Settings for the Experiment should be specified in this
% funtion. Rarely you will perform complex programming in this function.
% Rather you will define variables or experimental factors, etc.
expinfo = ExpSettings(expinfo); 

% Set priority for PTB processes to ensure best possible timing
topPriorityLevel = MaxPriority(expinfo.window);
Priority(topPriorityLevel);

isPractice = 0; % Local variable specifying that we are running practice trials
expinfo = getMarkers(expinfo,isPractice); 

%% General Instructions

% This is a loop running through the general instruction slides allowing to
% move back and forth within these slides. As soon as the last slide is
% finished you cannot move back.

% io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.MatlabStart);
% WaitSecs(0.1);
% io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

InstSlide = 1; % Start with the first slide
while InstSlide <= expinfo.InstStop % Loop until last slide of general instruction
    % Paste the FileName for the Instrcution Slide depending on the current
    % slide to be displayed
    Instruction=[expinfo.InstFolder 'Slide' num2str(InstSlide) expinfo.InstExtension];
    ima=imread(Instruction); % Read in the File
    
    % Put the File on the PTB window
    InstScreen = Screen('MakeTexture',expinfo.window,ima);
    Screen('DrawTexture', expinfo.window, InstScreen); % draw the scene
    Screen('Flip', expinfo.window);
    WaitSecs(0.3);
    
    % Wait for a key press of the right or left key to navigate back an
    % forth within the instructions
    if InstSlide == 1
        [ForwardBackward] = BackOrNext(expinfo,1);
    else
        [ForwardBackward] = BackOrNext(expinfo,0);
    end
    InstSlide = InstSlide + ForwardBackward;
end

% clean up no longer relevant variables after the instrction to keep the
% workspace tidy
clearvars Instruction ima InstSlide
clearScreen(expinfo);
WaitSecs(0.1);

%% PracticeBlock
% for t = expinfo.TaskProc
% end
if expinfo.showPractice == 1
    isPractice = 1; % Local variable specifying that we are running practice trials
    expinfo = getMarkers(expinfo,isPractice); 

%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.PracStart);
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
     
    % Usually an additional instruction slide is displayed before the practice
    % trials
    PracLM1=[expinfo.InstFolder 'PracLM1.jpg'];
    ima=imread(PracLM1, 'jpg');
    dImageWait(expinfo,ima);
    
    PracLM2=[expinfo.InstFolder 'PracLM2.jpg'];
    ima=imread(PracLM2, 'jpg');
    dImageWait(expinfo,ima);
    
    
    % Show PracticeTrials
    PracBlock = 1;
    PracticeTrials = MakeTrial(expinfo, isPractice, PracBlock);
    for pracTrial = 1:expinfo.nPracTrials % Loop through the practice trials
        PracticeTrials = DisplayTrial(expinfo, PracticeTrials, pracTrial, isPractice);
    end
     PracVK1=[expinfo.InstFolder 'PracVK1.jpg'];
    ima=imread(PracVK1, 'jpg');
    dImageWait(expinfo,ima);
    
    PracVK2=[expinfo.InstFolder 'PracVK2.jpg'];
    ima=imread(PracVK2, 'jpg');
    dImageWait(expinfo,ima);
    % Show PracticeTrials
    PracBlock = 2;
    PracticeTrials = MakeTrial(expinfo, isPractice, PracBlock);
    for pracTrial = 1:expinfo.nPracTrials % Loop through the practice trials
        PracticeTrials = DisplayTrial(expinfo, PracticeTrials, pracTrial, isPractice);
    end
    
    PracSH1=[expinfo.InstFolder 'PracSH1.jpg'];
    ima=imread(PracSH1, 'jpg');
    dImageWait(expinfo,ima);
    
    PracSH2=[expinfo.InstFolder 'PracSH2.jpg'];
    ima=imread(PracSH2, 'jpg');
    dImageWait(expinfo,ima);
    
    PracSH3=[expinfo.InstFolder 'PracSH3.jpg'];
    ima=imread(PracSH3, 'jpg');
    dImageWait(expinfo,ima);
    
    PracBlock = 3;
    PracticeTrials = MakeTrial(expinfo, isPractice, PracBlock);
     for pracTrial = 1:((expinfo.nPracTrials)*2) % Loop through the practice trials
        PracticeTrials = DisplayTrial(expinfo, PracticeTrials, pracTrial, isPractice);
     end
     
    PracSH4=[expinfo.InstFolder 'PracSH4.jpg'];
    ima=imread(PracSH4, 'jpg');
    dImageWait(expinfo,ima);
   
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.PracEnd);
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
end

%% ExpBlock
isPractice = 0; % Local variable specifying that we are running practice trials
expinfo = getMarkers(expinfo,isPractice); 

% io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.ExpStart);
% WaitSecs(0.1);
% io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

% Similarly like before the practice trials, there usually is one
% instruction slide before the experimental trials start.
ExpStart=[expinfo.InstFolder 'Exp1.jpg'];
ima=imread(ExpStart, 'jpg');
dImageWait(expinfo,ima);
    
%Show Shifting Trials
 PracBlock = 0; 
%% Experimental Trial Durchlauf wenn jede Bedingung einmal realisiert wird (256 Trials) und der eine Durchlauf in drei Bl�cke geteilt wird 
 expBlock = 1;
 ExpTrials = MakeTrial(expinfo, isPractice, PracBlock, expBlock);
 for expTrial = 1:expinfo.nExpTrials % Loop durch alle Experimental-Trials
%      if expTrial == 1
%          io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.Block(expBlock,1));
%          WaitSecs(0.1);
%          io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
%      end
     
     ExpTrials = DisplayTrial(expinfo, ExpTrials, expTrial, isPractice);
 end
 BackUp_Trial     = [expinfo.DataFolder,'Backup\',expinfo.taskName,'NumLet_Trials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];   
 save(BackUp_Trial,'ExpTrials');           
 
%  io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.Block(expBlock,2));
%  WaitSecs(0.1);
%  io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
         

%% save all information: i.e. the trial objects, and the expinfo structure.
% This ensures that all information used within the experiment can be
% accsessed later
BackUp_PracTrial = [expinfo.DataFolder,'Backup\',expinfo.taskName,'NumLet_PracTrials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session)];

BackUp_ExpInfo   = [expinfo.DataFolder,'Backup\',expinfo.taskName,'NumLet_ExpInfo_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session)];
if expinfo.showPractice == 1
save(BackUp_PracTrial,'PracticeTrials');
end
save(BackUp_ExpInfo,'expinfo');

%% End Experiment

% Display one final slide telling the participant that the experiment is
% finished.
EndExp=[expinfo.InstFolder 'EndExp.jpg'];
ima=imread(EndExp, 'jpg');
dImageWait(expinfo,ima);

% io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.ExpEnd);
% WaitSecs(0.1);
% io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

Priority(0); % Reset priority to low level
closeexp(expinfo.window); % Close the experiment

%% End of Script