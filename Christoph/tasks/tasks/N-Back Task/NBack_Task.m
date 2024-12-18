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
TaskName = 'N-Back-Task';

% Definde variables to be specified when the experiment starts.
vars = {'sub','ses','prac','test'};
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
while InstSlide <= expinfo.InstStop0Back % Loop until last slide of general instruction
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



%% Block 1 N-0 Back 
%Practice
if expinfo.showPractice == 1
    isPractice = 1;
    expBlock = 1;
    expinfo = getMarkers(expinfo, isPractice, expBlock);
    expinfo = WriteDataFile(expinfo, expBlock);
    
         expinfo.nPracTrials = 20;
         expinfo.nExpTrials = 96 ;
    
    PracticeTrials = MakeTrial(expinfo, isPractice, expBlock);
    
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.PracStart);
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
    
    Prac0Back=[expinfo.InstFolder 'Prac0Back.jpg'];
    ima=imread(Prac0Back, 'jpg');
    dImageWait(expinfo,ima);
    
    if PracticeTrials(1).Target == 1 % S
        TargetS=[expinfo.InstFolder 'TargetS.jpg'];
        ima=imread(TargetS, 'jpg');
        dImageWait(expinfo,ima);
    elseif PracticeTrials(1).Target == 2 % H
        TargetH=[expinfo.InstFolder 'TargetH.jpg'];
        ima=imread(TargetH, 'jpg');
        dImageWait(expinfo,ima);
    elseif PracticeTrials(1).Target == 3 % C
        TargetC=[expinfo.InstFolder 'TargetC.jpg'];
        ima=imread(TargetC, 'jpg');
        dImageWait(expinfo,ima);
    elseif PracticeTrials(1).Target == 4 % F
        TargetF=[expinfo.InstFolder 'TargetF.jpg'];
        ima=imread(TargetF, 'jpg');
        dImageWait(expinfo,ima);
    end
    
    
    for pracTrial = 1:expinfo.nPracTrials
        PracticeTrials = DisplayTrial(expinfo, PracticeTrials, expBlock,  pracTrial, isPractice);
    end
    
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.PracEnd);
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
    
    PracEnd=[expinfo.InstFolder 'PracEnd.jpg'];
    ima=imread(PracEnd, 'jpg');
    dImageWait(expinfo,ima);
end

%Experiment

isPractice = 0;
expBlock = 1;
expinfo = getMarkers(expinfo, isPractice, expBlock);
expinfo = WriteDataFile(expinfo, expBlock);
expinfo.nExpTrials = 96 ;
        
ExpTrials = MakeTrial(expinfo,isPractice , expBlock);

%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.ExpStart);
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

ExpStart0Back=[expinfo.InstFolder 'ExpStart0Back.jpg'];
ima=imread(ExpStart0Back, 'jpg');
dImageWait(expinfo,ima);

if ExpTrials(1).Target == 1 %S
    TargetS=[expinfo.InstFolder 'TargetS.jpg'];
    ima=imread(TargetS, 'jpg');
    dImageWait(expinfo,ima);
elseif ExpTrials(1).Target == 2 %H
    TargetH=[expinfo.InstFolder 'TargetH.jpg'];
    ima=imread(TargetH, 'jpg');
    dImageWait(expinfo,ima);
elseif ExpTrials(1).Target == 3 %C
    TargetC=[expinfo.InstFolder 'TargetC.jpg'];
    ima=imread(TargetC, 'jpg');
    dImageWait(expinfo,ima);
elseif ExpTrials(1).Target == 4 %F
    TargetF=[expinfo.InstFolder 'TargetF.jpg'];
    ima=imread(TargetF, 'jpg');
    dImageWait(expinfo,ima);
end

%   io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.Block(1,1));
%   WaitSecs(0.1);
%   io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

for expTrial = 1:expinfo.nExpTrials
    ExpTrials = DisplayTrial(expinfo, ExpTrials, expBlock ,expTrial, isPractice);
end

%   io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.Block(1,2));
%   WaitSecs(0.1);
%   io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

BackUp_PracTrial = [expinfo.DataFolder,'Backup\',expinfo.taskName,'N-BackTask_PracTrials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
BackUp_Trial     = [expinfo.DataFolder,'Backup\',expinfo.taskName,'N-BackTask_Trials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
save(BackUp_Trial,'ExpTrials');
if expinfo.showPractice == 1
    save(BackUp_PracTrial,'PracticeTrials');
end
BackUp_ExpInfo   = [expinfo.DataFolder,'Backup\',expinfo.taskName,'N-BackTask_ExpInfo_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
save(BackUp_ExpInfo,'expinfo');

ExpEnd0Back=[expinfo.InstFolder 'ExpEnd0Back.jpg'];
ima=imread(ExpEnd0Back, 'jpg');
dImageWait(expinfo,ima);


%% Block 2, N-1 Back
InstSlide = 1; % Start with the first slide
while InstSlide <= expinfo.InstStop1Back % Loop until last slide of general instruction
    % Paste the FileName for the Instrcution Slide depending on the current
    % slide to be displayed
    Instruction=[expinfo.InstFolder 'Slide1Back' num2str(InstSlide) expinfo.InstExtension];
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


%Practice
if expinfo.showPractice == 1
    isPractice = 1;
    expBlock = 2;
    expinfo = getMarkers(expinfo, isPractice, expBlock);
    expinfo = WriteDataFile(expinfo, expBlock);
    
   
       expinfo.nPracTrials = 31;
        expinfo.nExpTrials = 97;
    
    PracticeTrials = MakeTrial(expinfo, isPractice, expBlock);
    
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.PracStart);
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
    
    Prac1Back=[expinfo.InstFolder 'Prac1Back.jpg'];
    ima=imread(Prac1Back, 'jpg');
    dImageWait(expinfo,ima);
    
    for pracTrial = 1:expinfo.nPracTrials
        PracticeTrials = DisplayTrial(expinfo, PracticeTrials, expBlock,  pracTrial, isPractice);
    end
    
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.PracEnd);
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
    
    PracEnd=[expinfo.InstFolder 'PracEnd.jpg'];
    ima=imread(PracEnd, 'jpg');
    dImageWait(expinfo,ima);
end

%Experiment

isPractice = 0;
expBlock = 2;
expinfo = getMarkers(expinfo, isPractice, expBlock);
expinfo = WriteDataFile(expinfo, expBlock);
expinfo.nExpTrials = 97;
    
ExpTrials = MakeTrial(expinfo,isPractice , expBlock);


ExpStart1Back=[expinfo.InstFolder 'ExpStart1Back.jpg'];
ima=imread(ExpStart1Back, 'jpg');
dImageWait(expinfo,ima);

%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.Block(1,1));
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

for expTrial = 1:expinfo.nExpTrials
    ExpTrials = DisplayTrial(expinfo, ExpTrials, expBlock ,expTrial, isPractice);
end

%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.Block(1,2));
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

BackUp_PracTrial = [expinfo.DataFolder,'Backup\',expinfo.taskName,'N-BackTask_PracTrials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
BackUp_Trial     = [expinfo.DataFolder,'Backup\',expinfo.taskName,'N-BackTask_Trials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
save(BackUp_Trial,'ExpTrials');
if expinfo.showPractice == 1
    save(BackUp_PracTrial,'PracticeTrials');
end
BackUp_ExpInfo   = [expinfo.DataFolder,'Backup\',expinfo.taskName,'N-BackTask_ExpInfo_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
save(BackUp_ExpInfo,'expinfo');

ExpEnd1Back=[expinfo.InstFolder 'ExpEnd1Back.jpg'];
ima=imread(ExpEnd1Back, 'jpg');
dImageWait(expinfo,ima);

%% Block 3 , N-2 Back
InstSlide = 1; % Start with the first slide
while InstSlide <= expinfo.InstStop2Back % Loop until last slide of general instruction
    % Paste the FileName for the Instrcution Slide depending on the current
    % slide to be displayed
    Instruction=[expinfo.InstFolder 'Slide2Back' num2str(InstSlide) expinfo.InstExtension];
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


%Practice
if expinfo.showPractice == 1
    isPractice = 1;
    expBlock = 3;
    expinfo = getMarkers(expinfo, isPractice, expBlock);
    expinfo = WriteDataFile(expinfo, expBlock);
    

         expinfo.nPracTrials = 32;
         expinfo.nExpTrials = 98;
    
    PracticeTrials = MakeTrial(expinfo, isPractice, expBlock);
    
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.PracStart);
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
    
    Prac2Back=[expinfo.InstFolder 'Prac2Back.jpg'];
    ima=imread(Prac2Back, 'jpg');
    dImageWait(expinfo,ima);
    
    for pracTrial = 1:expinfo.nPracTrials
        PracticeTrials = DisplayTrial(expinfo, PracticeTrials, expBlock,  pracTrial, isPractice);
    end
    
%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.PracEnd);
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port
    
    PracEnd=[expinfo.InstFolder 'PracEnd.jpg'];
    ima=imread(PracEnd, 'jpg');
    dImageWait(expinfo,ima);
end

%Experiment

isPractice = 0;
expBlock = 3;
expinfo = getMarkers(expinfo, isPractice, expBlock);
expinfo = WriteDataFile(expinfo, expBlock);
expinfo.nExpTrials = 98;
             
ExpTrials = MakeTrial(expinfo,isPractice , expBlock);


ExpStart2Back=[expinfo.InstFolder 'ExpStart2Back.jpg'];
ima=imread(ExpStart2Back, 'jpg');
dImageWait(expinfo,ima);

%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.Block(1,1));
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

for expTrial = 1:expinfo.nExpTrials
    ExpTrials = DisplayTrial(expinfo, ExpTrials, expBlock ,expTrial, isPractice);
end

%     io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.Block(1,2));
%     WaitSecs(0.1);
%     io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

BackUp_PracTrial = [expinfo.DataFolder,'Backup\',expinfo.taskName,'N-BackTask_PracTrials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
BackUp_Trial     = [expinfo.DataFolder,'Backup\',expinfo.taskName,'N-BackTask_Trials_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
save(BackUp_Trial,'ExpTrials');
if expinfo.showPractice == 1
    save(BackUp_PracTrial,'PracticeTrials');
end
BackUp_ExpInfo   = [expinfo.DataFolder,'Backup\',expinfo.taskName,'N-BackTask_ExpInfo_S',num2str(expinfo.subject),'_Ses',num2str(expinfo.session),'_Block',num2str(expBlock)];
save(BackUp_ExpInfo,'expinfo');

%% End Experiment

% Display one final slide telling the participant that the experiment is
% finished.

ExpEnd2Back=[expinfo.InstFolder 'ExpEnd2Back.jpg'];
ima=imread(ExpEnd2Back, 'jpg');
dImageWait(expinfo,ima);

% io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.ExpEnd);
% WaitSecs(0.1);
% io64(expinfo.ioObj, expinfo.PortAddress,0);% Stop Writing to Output Port

Priority(0); % Reset priority to low level
closeexp(expinfo.window); % Close the experiment

%% End of Script
