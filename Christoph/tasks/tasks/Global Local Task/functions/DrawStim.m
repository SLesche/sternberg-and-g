
function [timestamp_flip] = DrawStim(expinfo, Trial, expTrial, when, Marker)


%% Text Size
expinfo.FontSize = Screen(expinfo.window,'TextSize',20); % Hier wird die Größe von x und o von 40 auf 20 Pixel geändert, da sich diese sonst überlappen

if Trial(expTrial).Shape == 1
    globalshape = 'cross';
    localshape = 'square';
elseif Trial(expTrial).Shape == 2
    globalshape = 'cross';
    localshape = 'triangle';
elseif Trial(expTrial).Shape == 3
    globalshape = 'cross';
    localshape = 'circle';
elseif Trial(expTrial).Shape == 4
    globalshape = 'circle';
    localshape = 'square';
elseif Trial(expTrial).Shape == 5
    globalshape = 'circle';
    localshape = 'triangle';
elseif Trial(expTrial).Shape == 6
    globalshape = 'circle';
    localshape = 'cross';
elseif Trial(expTrial).Shape == 7
    globalshape = 'triangle';
    localshape = 'circle';
elseif Trial(expTrial).Shape == 8
    globalshape = 'triangle';
    localshape = 'cross';
elseif Trial(expTrial).Shape == 9
    globalshape = 'triangle';
    localshape = 'square';
elseif Trial(expTrial).Shape == 10
    globalshape = 'square';
    localshape = 'cross';
elseif Trial(expTrial).Shape == 11
    globalshape = 'square';
    localshape = 'circle';
elseif Trial(expTrial).Shape == 12
    globalshape = 'square';
    localshape = 'triangle';
end
%%

if strcmp(globalshape,'square') || strcmp(globalshape,'cross')
    anglesDeg = linspace(0, 360, 4 + 1)+45;
elseif strcmp(globalshape,'circle')
    anglesDeg = linspace(0, 360, expinfo.nStimuliCircle + 1);
elseif strcmp(globalshape,'triangle')
   anglesDeg = linspace(0, 360, 16 + 1) +45; 
end
anglesRad = anglesDeg*(pi/180);

%%
if strcmp(globalshape,'square')
    yPosVector = sin(anglesRad) .* expinfo.globalRadius;
    xPosVector = cos(anglesRad) .* expinfo.globalRadius;
    
    ytopLine = linspace(yPosVector(1),yPosVector(2),expinfo.nStim2Side);
    yrightLine = linspace(yPosVector(2),yPosVector(3),expinfo.nStim2Side);
    yrightLine = yrightLine(2:expinfo.nStim2Side-1);
    ybottomLine = linspace(yPosVector(3),yPosVector(4),expinfo.nStim2Side);
    yleftLine = linspace(yPosVector(4),yPosVector(5),expinfo.nStim2Side);
    yleftLine = yleftLine(2:expinfo.nStim2Side-1);
    
    xtopLine = linspace(xPosVector(1),xPosVector(2),expinfo.nStim2Side);
    xrightLine = linspace(xPosVector(2),xPosVector(3),expinfo.nStim2Side);
    xrightLine = xrightLine(2:expinfo.nStim2Side-1);
    xbottomLine = linspace(xPosVector(3),xPosVector(4),expinfo.nStim2Side);
    xleftLine = linspace(xPosVector(4),xPosVector(5),expinfo.nStim2Side);
    xleftLine = xleftLine(2:expinfo.nStim2Side-1);
    
    xPosVector = [xtopLine xrightLine xbottomLine xleftLine];
    yPosVector = [ytopLine yrightLine ybottomLine yleftLine];
elseif strcmp(globalshape,'cross')
    yPosVector = sin(anglesRad) .* expinfo.globalRadius;
    xPosVector = cos(anglesRad) .* expinfo.globalRadius;
    
    yLine1 = linspace(yPosVector(1),yPosVector(3),expinfo.nStim2Side);
    yLine2 = linspace(yPosVector(2),yPosVector(4),expinfo.nStim2Side);
    yLine2(round((expinfo.nStim2Side)/2)) = [];
    
    xLine1 = linspace(xPosVector(1),xPosVector(3),expinfo.nStim2Side);
    xLine2 = linspace(xPosVector(2),xPosVector(4),expinfo.nStim2Side);
    xLine2(round((expinfo.nStim2Side)/2)) = [];
    
    xPosVector = [xLine1 xLine2];
    yPosVector = [yLine1 yLine2];
elseif strcmp(globalshape,'circle')
    yPosVector = sin(anglesRad) .* expinfo.globalRadius;
    xPosVector = cos(anglesRad) .* expinfo.globalRadius;
    
    xPosVector(expinfo.nStimuliCircle + 1) = [];
    yPosVector(expinfo.nStimuliCircle + 1) = [];
elseif  strcmp(globalshape,'triangle')
    yPosVector = sin(anglesRad) .* expinfo.globalRadius;
    xPosVector = cos(anglesRad) .* expinfo.globalRadius;
    
    ybottomLine = linspace(yPosVector(8),yPosVector(14),expinfo.nStim2Side);
    yleftLine = linspace(yPosVector(14),yPosVector(3),expinfo.nStim2Side);
    yleftLine(expinfo.nStim2Side) = [];
    yleftLine(1) = [];
    yrightLine = linspace(yPosVector(3),yPosVector(8),expinfo.nStim2Side);
    yrightLine(expinfo.nStim2Side)  = [];

    xbottomLine = linspace(xPosVector(8),xPosVector(14),expinfo.nStim2Side);
    xleftLine = linspace(xPosVector(14),xPosVector(3),expinfo.nStim2Side);
    xleftLine(expinfo.nStim2Side) = [];
    xleftLine(1) = [];
    xrightLine = linspace(xPosVector(3),xPosVector(8),expinfo.nStim2Side);
    xrightLine(expinfo.nStim2Side) = [];
 
    xPosVector = [xbottomLine xleftLine xrightLine];
    yPosVector = [ybottomLine yleftLine yrightLine];
    xPosVector = xPosVector*(-1);
    yPosVector = yPosVector*(-1);
end

xPosVector = xPosVector + expinfo.xTargetPos;
yPosVector = yPosVector + expinfo.yTargetPos;

%%
if strcmp(globalshape,'circle') && strcmp(localshape,'cross')
    for i = 1:expinfo.nStimuliCircle
        textbounds = Screen('TextBounds', expinfo.window, 'X');
        posX = xPosVector(i) - textbounds(3)/2;
        posY = yPosVector(i) - textbounds(4)/2;
        Screen('DrawText', expinfo.window,'X', posX, posY, Trial(expTrial).ProbeStimColor);
    end
elseif strcmp(globalshape,'cross') && strcmp(localshape,'circle')
    for i = 1:(2*expinfo.nStim2Side - 1)
        textbounds = Screen('TextBounds', expinfo.window, 'O');
        posX = xPosVector(i) - textbounds(3)/2;
        posY = yPosVector(i) - textbounds(4)/2;
        Screen('DrawText', expinfo.window,'O', posX, posY, Trial(expTrial).ProbeStimColor);
    end
elseif strcmp(globalshape,'cross') && strcmp(localshape,'square')
    for i = 1:(2*expinfo.nStim2Side - 1)
         posX = xPosVector(i);
         posY = yPosVector(i);
         RectSize = [(posX-7.5) (posY-7.5) (posX+7.5) (posY+7.5)];
         Screen('FrameRect', expinfo.window,Trial(expTrial).ProbeStimColor, RectSize);
    end
elseif strcmp(globalshape,'cross') && strcmp(localshape,'triangle')
    for i = 1:(2*expinfo.nStim2Side - 1)
    posX = xPosVector(i);
    posY = yPosVector(i);
    PointList = zeros(3,2);
    PointList(1,1) = posX - 7.5;
    PointList(1,2) = posY + 7.5;
    PointList(2,1) = posX;
    PointList(2,2) = posY - 7.5;
    PointList(3,1) = posX + 7.5;
    PointList(3,2) = posY + 7.5;
    Screen('FramePoly',expinfo.window, Trial(expTrial).ProbeStimColor, PointList)
    end
elseif strcmp(globalshape,'circle') && strcmp(localshape,'square')
    for i = 1:expinfo.nStimuliCircle
         posX = xPosVector(i);
         posY = yPosVector(i);
         RectSize = [(posX-7.5) (posY-7.5) (posX+7.5) (posY+7.5)];
         Screen('FrameRect', expinfo.window,Trial(expTrial).ProbeStimColor, RectSize);
    end
elseif strcmp(globalshape,'circle') && strcmp(localshape,'triangle')
    for i =  1:expinfo.nStimuliCircle
    posX = xPosVector(i);
    posY = yPosVector(i);
    PointList = zeros(3,2);
    PointList(1,1) = posX - 7.5;
    PointList(1,2) = posY + 7.5;
    PointList(2,1) = posX;
    PointList(2,2) = posY - 7.5;
    PointList(3,1) = posX + 7.5;
    PointList(3,2) = posY + 7.5;
    Screen('FramePoly',expinfo.window, Trial(expTrial).ProbeStimColor, PointList)
    end
elseif strcmp(globalshape,'triangle') && strcmp(localshape,'circle')
    for i = 1:(3*expinfo.nStim2Side - 3)
        textbounds = Screen('TextBounds', expinfo.window, 'O');
        posX = xPosVector(i) - textbounds(3)/2;
        posY = yPosVector(i) - textbounds(4)/2;
        Screen('DrawText', expinfo.window,'O', posX, posY, Trial(expTrial).ProbeStimColor);
    end
elseif strcmp(globalshape,'triangle') && strcmp(localshape,'cross')
    for i = 1:(3*expinfo.nStim2Side - 3)
        textbounds = Screen('TextBounds', expinfo.window, 'X');
        posX = xPosVector(i) - textbounds(3)/2;
        posY = yPosVector(i) - textbounds(4)/2;
        Screen('DrawText', expinfo.window,'X', posX, posY, Trial(expTrial).ProbeStimColor);
    end
elseif strcmp(globalshape,'triangle') && strcmp(localshape,'square')
    for i = 1:(3*expinfo.nStim2Side - 3)
         posX = xPosVector(i);
         posY = yPosVector(i);
         RectSize = [(posX-7.5) (posY-7.5) (posX+7.5) (posY+7.5)];
         Screen('FrameRect', expinfo.window,Trial(expTrial).ProbeStimColor, RectSize);
    end
elseif strcmp(globalshape,'square') && strcmp(localshape,'circle')
    for i = 1:(4*expinfo.nStim2Side - 4)
        textbounds = Screen('TextBounds', expinfo.window, 'O');
        posX = xPosVector(i) - textbounds(3)/2;
        posY = yPosVector(i) - textbounds(4)/2;
        Screen('DrawText', expinfo.window,'O', posX, posY, Trial(expTrial).ProbeStimColor);
    end
elseif strcmp(globalshape,'square') && strcmp(localshape,'cross')
    for i = 1:(4*expinfo.nStim2Side - 4)
        textbounds = Screen('TextBounds', expinfo.window, 'X');
        posX = xPosVector(i) - textbounds(3)/2;
        posY = yPosVector(i) - textbounds(4)/2;
        Screen('DrawText', expinfo.window,'X', posX, posY, Trial(expTrial).ProbeStimColor);
    end
elseif strcmp(globalshape,'square') && strcmp(localshape,'triangle')
    for i = 1:(4*expinfo.nStim2Side - 4)
    posX = xPosVector(i);
    posY = yPosVector(i);
    PointList = zeros(3,2);
    PointList(1,1) = posX - 7.5;
    PointList(1,2) = posY + 7.5;
    PointList(2,1) = posX;
    PointList(2,2) = posY - 7.5;
    PointList(3,1) = posX + 7.5;
    PointList(3,2) = posY + 7.5;
    Screen('FramePoly',expinfo.window, Trial(expTrial).ProbeStimColor, PointList)
    end
end

%% Flip stimuli to screen
% Flip Screen
if ~exist('when','var') || isempty(when)
    % Flip expinfo.window immediately
    timestamp_flip = Screen('Flip',expinfo.window);
  %  io64(expinfo.ioObj, expinfo.PortAddress, Marker);
else
    % Flip synced to timestamp entered
    timestamp_flip = Screen('Flip',expinfo.window,when);
   % io64(expinfo.ioObj, expinfo.PortAddress, Marker);
end
end