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
TaskName = 'KeepTrackTask';

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

% load markers
isPractice = 0;
expBlock = 0;
expinfo = getMarkers(expinfo, isPractice, expBlock);
%% General Instructions

% io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.MatlabStart);
% WaitSecs(0.1);
% io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

% This is a loop running through the general instruction slides allowing to
% move back and forth within these slides. As soon as the last slide is
% finished you cannot move back.
InstSlide = 1; % Start with the first slide
while InstSlide <= expinfo.InstStopBlock1 % Loop until last slide of general instruction
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
    if InstSlide == 1 && expinfo.session ~= 1
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

%% PracticeBlock Block 1
if expinfo.showPractice == 1
    isPractice = 1; % Local variable specifying that we are running practice trials
expBlock = 1;
expinfo = getMarkers(expinfo, isPractice, expBlock);
    
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.PracStart);
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
    
    % Usually an additional instruction slide is displayed before the practice
    % trials
    
    PracOneCat=[expinfo.InstFolder 'PracOneCat.jpg'];
    ima=imread(PracOneCat, 'jpg');
    dImageWait(expinfo,ima);
    
    
    % Show PracticeTrials
    PracticeTrials = MakeTrial(expinfo, isPractice,expBlock);
    for pracTrial = 1:expinfo.nPracTrials % Loop through the practice trials
        PracticeTrials = DisplayTrial(expinfo, PracticeTrials, pracTrial, expBlock, isPractice);
    end
    
    
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.PracEnd);
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
    
    PracEnd=[expinfo.InstFolder 'PracEnd.jpg'];
    ima=imread(PracEnd, 'jpg');
    dImageWait(expinfo,ima);
end    

%% ExpBlock 1
isPractice = 0; % Local variable specifying that we are running practice trials
expBlock = 1;
expinfo = getMarkers(expinfo, isPractice, expBlock);

% io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.ExpStart);
% WaitSecs(0.1);
% io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

% Similarly like before the practice trials, there usually is one
% instruction slide before the experimental trials start.
ExpStartOneCat=[expinfo.InstFolder 'ExpStartOneCat.jpg'];
ima=imread(ExpStartOneCat, 'jpg');
dImageWait(expinfo,ima);

%Show Shifting Trials

% Generate a TrialList for the experimental trials
% ExpTrials = MakeTrial(expinfo,isPractice, PracBlock); % function that sets up the trial
    ExpTrials = MakeTrial(expinfo,isPractice , expBlock);
        
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.Block(1,1));
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
    
  for expTrial = 1:expinfo.nExpTrials % Loop durch alle Experimental-Trials
%       if expTrial == (round(1/2*expinfo.nExpTrials))
%           Pause1=[expinfo.InstFolder 'Pause1.jpg'];
%           ima=imread(Pause1, 'jpg');
%           dImageWait(expinfo,ima);
%           
%           Pause2OneCat=[expinfo.InstFolder  'Pause2OneCat.jpg'];
%           ima=imread(Pause2OneCat, 'jpg');
%           dImageWait(expinfo,ima);
%       end
      ExpTrials = DisplayTrial(expinfo, ExpTrials, expTrial, expBlock, isPractice);
  end
       
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.Block(1,2));
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
       
    BackUp_Trial     = [expinfo.DataFolder,'Backup\',expinfo.taskName,'KeepTrackTask_Trials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
    save(BackUp_Trial,'ExpTrials');
    BackUp_PracTrial = [expinfo.DataFolder,'Backup\',expinfo.taskName,'KeepTrackTask_PracTrials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
    if expinfo.showPractice == 1
        save(BackUp_PracTrial,'PracticeTrials');
    end
    BackUp_ExpInfo   = [expinfo.DataFolder,'Backup\',expinfo.taskName,'KeepTrackTask_ExpInfo_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
    save(BackUp_ExpInfo,'expinfo');
    
     BlockEndOneCat=[expinfo.InstFolder  'BlockEndOneCat.jpg'];
     ima=imread(BlockEndOneCat, 'jpg');
     dImageWait(expinfo,ima);

%% PracticeBlock Block 2

          Pause1=[expinfo.InstFolder 'Pause1.jpg'];
          ima=imread(Pause1, 'jpg');
          dImageWait(expinfo,ima);

InstSlide = 1; % Start with the first slide
while InstSlide <= expinfo.InstStopBlock2 % Loop until last slide of general instruction
    % Paste the FileName for the Instrcution Slide depending on the current
    % slide to be displayed
    Instruction=[expinfo.InstFolder 'Slide2Block' num2str(InstSlide) expinfo.InstExtension];
    ima=imread(Instruction); % Read in the File
    
    % Put the File on the PTB window
    InstScreen = Screen('MakeTexture',expinfo.window,ima);
    Screen('DrawTexture', expinfo.window, InstScreen); % draw the scene
    Screen('Flip', expinfo.window);
    WaitSecs(0.3);
    
    % Wait for a key press of the right or left key to navigate back an
    % forth within the instructions
    if InstSlide == 1 && expinfo.session ~= 1
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

if expinfo.showPractice == 1
    isPractice = 1; % Local variable specifying that we are running practice trials
expBlock = 2;
expinfo = getMarkers(expinfo, isPractice, expBlock);
    
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.PracStart);
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
    
    % Usually an additional instruction slide is displayed before the practice
    % trials
    PracThreeCat=[expinfo.InstFolder 'PracThreeCat.jpg'];
    ima=imread(PracThreeCat, 'jpg');
    dImageWait(expinfo,ima);
    
    % Show PracticeTrials

    PracticeTrials = MakeTrial(expinfo, isPractice,expBlock);
    for pracTrial = 1:expinfo.nPracTrials % Loop through the practice trials
        PracticeTrials = DisplayTrial(expinfo, PracticeTrials, pracTrial,expBlock, isPractice);
    end
    
    
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.PracEnd);
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
    
    PracEnd=[expinfo.InstFolder 'PracEnd.jpg'];
    ima=imread(PracEnd, 'jpg');
    dImageWait(expinfo,ima);
end    

%% ExpBlock 2

isPractice = 0; % Local variable specifying that we are running practice trials
expBlock = 2;
expinfo = getMarkers(expinfo, isPractice, expBlock);

% Similarly like before the practice trials, there usually is one
% instruction slide before the experimental trials start.
ExpStartThreeCat=[expinfo.InstFolder 'ExpStartThreeCat.jpg'];
ima=imread(ExpStartThreeCat, 'jpg');
dImageWait(expinfo,ima);

%Show Shifting Trials

% Generate a TrialList for the experimental trials
ExpTrials = MakeTrial(expinfo,isPractice , expBlock);
        
    
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.Block(1,1));
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
    
    for expTrial = 1:expinfo.nExpTrials % Loop durch alle Experimental-Trials
%         if expTrial == (round(1/2*expinfo.nExpTrials))
%             Pause1=[expinfo.InstFolder 'Pause1.jpg'];
%             ima=imread(Pause1, 'jpg');
%             dImageWait(expinfo,ima);
%             
%             Pause2ThreeCat=[expinfo.InstFolder  'Pause2ThreeCat.jpg'];
%             ima=imread(Pause2ThreeCat, 'jpg');
%             dImageWait(expinfo,ima);
%         end
        ExpTrials = DisplayTrial(expinfo, ExpTrials, expTrial,expBlock, isPractice);
    end
       
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.Block(1,2));
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
    
    
    BackUp_Trial     = [expinfo.DataFolder,'Backup\',expinfo.taskName,'KeepTrackTask_Trials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
    save(BackUp_Trial,'ExpTrials');
    BackUp_PracTrial = [expinfo.DataFolder,'Backup\',expinfo.taskName,'KeepTrackTask_PracTrials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
    BackUp_ExpInfo   = [expinfo.DataFolder,'Backup\',expinfo.taskName,'KeepTrackTask_ExpInfo_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];   
    if expinfo.showPractice == 1
        save(BackUp_PracTrial,'PracticeTrials');
    end
    save(BackUp_ExpInfo,'expinfo');

%% End Experiment

% Display one final slide telling the participant that the experiment is
% finished.

ExpEnd=[expinfo.InstFolder 'ExpEnd.jpg'];
ima=imread(ExpEnd, 'jpg');
dImageWait(expinfo,ima);

% io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.ExpEnd);
% WaitSecs(0.1);
% io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

Priority(0); % Reset priority to low level
closeexp(expinfo.window); % Close the experiment

%% End of Script
