function [timestamp_flip] = DrawStim(expinfo, Trial, expTrial,Pos_MemSet,counter, when, Marker)
if counter == 0 
    if  Trial(expTrial).CategoryPos(Pos_MemSet) == 1 % Figures
        
        if Trial(expTrial).StimPos(Pos_MemSet) == 1 % arrow 
            PointList = zeros(7,2);
            PointList(1,1) = expinfo.centerX + 40*(1/2);
            PointList(1,2) = expinfo.centerY - 40*(1/5);
            PointList(2,1) = expinfo.centerX + 40*(1/2);
            PointList(2,2) = expinfo.centerY - 40*(1/2);
            PointList(3,1) = expinfo.centerX + 40;
            PointList(3,2) = expinfo.centerY;
            PointList(4,1) = expinfo.centerX + 40*(1/2);
            PointList(4,2) = expinfo.centerY + 40*(1/2);
            PointList(5,1) = expinfo.centerX + 40*(1/2);
            PointList(5,2) = expinfo.centerY + 40*(1/5);
            PointList(6,1) = expinfo.centerX - 40;
            PointList(6,2) = expinfo.centerY + 40*(1/5);
            PointList(7,1) = expinfo.centerX - 40;
            PointList(7,2) = expinfo.centerY - 40*(1/5);
            Screen('FramePoly',expinfo.window, expinfo.Colors.gray, PointList)
            
        elseif Trial(expTrial).StimPos(Pos_MemSet) == 2 % triangle
            PointListTri = zeros(3,2);
            PointListTri(1,1) = expinfo.centerX -40;
            PointListTri(1,2) = expinfo.centerY +40;
            PointListTri(2,1) = expinfo.centerX;
            PointListTri(2,2) = expinfo.centerY -40;
            PointListTri(3,1) = expinfo.centerX +40;
            PointListTri(3,2) = expinfo.centerY +40;
            Screen('FramePoly',expinfo.window, expinfo.Colors.gray, PointListTri)
            
        elseif Trial(expTrial).StimPos(Pos_MemSet) == 3 % diamond
            PointListRect = zeros(4,2);
            PointListRect(1,1)= expinfo.centerX;
            PointListRect(1,2)= expinfo.centerY - 40;
            PointListRect(2,1)= expinfo.centerX + 40;
            PointListRect(2,2)= expinfo.centerY;
            PointListRect(3,1)= expinfo.centerX;
            PointListRect(3,2)= expinfo.centerY + 40;
            PointListRect(4,1)= expinfo.centerX - 40 ;
            PointListRect(4,2)= expinfo.centerY;
            Screen('FramePoly',expinfo.window, expinfo.Colors.gray, PointListRect)
            
        elseif Trial(expTrial).StimPos(Pos_MemSet) == 4 % circle
            PointListCircle = zeros(1,4);
            PointListCircle(1,1)= expinfo.centerX -40;
            PointListCircle(2,1)= expinfo.centerY - 40;
            PointListCircle(3,1)= expinfo.centerX +40;
            PointListCircle(4,1)= expinfo.centerY + 40;
            
            Screen('FrameOval',expinfo.window, expinfo.Colors.gray, PointListCircle)
            
        elseif  Trial(expTrial).StimPos(Pos_MemSet) == 5 % pentagon
            PointListPenta = zeros(5,2);
            PointListPenta(1,1)= expinfo.centerX;
            PointListPenta(1,2)= expinfo.centerY - 61.5;
            PointListPenta(2,1)= expinfo.centerX + 64.5;
            PointListPenta(2,2)= expinfo.centerY -14.17;
            PointListPenta(3,1)= expinfo.centerX +40;
            PointListPenta(3,2)= expinfo.centerY + 61.5;
            PointListPenta(4,1)= expinfo.centerX - 40 ;
            PointListPenta(4,2)= expinfo.centerY +61.5;
            PointListPenta(5,1)= expinfo.centerX - 64.5 ;
            PointListPenta(5,2)= expinfo.centerY- 14.17;
            Screen('FramePoly',expinfo.window, expinfo.Colors.gray, PointListPenta)
            
        elseif  Trial(expTrial).StimPos(Pos_MemSet) == 6 % star
            PointListStar = zeros(10,2);
            PointListStar(1,1)= expinfo.centerX;
            PointListStar(1,2)= expinfo.centerY - 61.5;
            PointListStar(2,1)= expinfo.centerX + 15.28;
            PointListStar(2,2)= expinfo.centerY -14.17;
            PointListStar(3,1)= expinfo.centerX + 64.5;
            PointListStar(3,2)= expinfo.centerY -14.17;
            PointListStar(4,1)= expinfo.centerX + 24.74 ;
            PointListStar(4,2)= expinfo.centerY + 14.38;
            PointListStar(5,1)= expinfo.centerX +40;
            PointListStar(5,2)=  expinfo.centerY + 61.5;
            PointListStar(6,1)= expinfo.centerX;
            PointListStar(6,2)= expinfo.centerY + 32.35;
            PointListStar(7,1)= expinfo.centerX - 40;
            PointListStar(7,2)= expinfo.centerY +61.5;
            PointListStar(8,1)= expinfo.centerX -24.74;
            PointListStar(8,2)= expinfo.centerY +14.38;
            PointListStar(9,1)= expinfo.centerX - 64.5;
            PointListStar(9,2)= expinfo.centerY- 14.17;
            PointListStar(10,1)= expinfo.centerX - 15.28 ;
            PointListStar(10,2)= expinfo.centerY - 14.17;
            Screen('FramePoly',expinfo.window, expinfo.Colors.gray, PointListStar)
            
        end
        
    elseif Trial(expTrial).CategoryPos(Pos_MemSet) == 2 % colores
        PointListRect = zeros(4,1);
        PointListRect(1,1)= expinfo.centerX - 40;
        PointListRect(2,1)= expinfo.centerY - 40;
        PointListRect(3,1)= expinfo.centerX + 40;
        PointListRect(4,1)= expinfo.centerY + 40;
        
        if Trial(expTrial).StimPos(Pos_MemSet) == 1
            Screen('FillRect',expinfo.window, expinfo.Colors.green, PointListRect)
        elseif Trial(expTrial).StimPos(Pos_MemSet) == 2
            Screen('FillRect',expinfo.window, expinfo.Colors.red, PointListRect)
        elseif Trial(expTrial).StimPos(Pos_MemSet) == 3
            Screen('FillRect',expinfo.window, expinfo.Colors.yellow, PointListRect)
        elseif Trial(expTrial).StimPos(Pos_MemSet) == 4
            Screen('FillRect',expinfo.window, expinfo.Colors.blue, PointListRect)
        elseif Trial(expTrial).StimPos(Pos_MemSet) == 5
            Screen('FillRect',expinfo.window, expinfo.Colors.turquois, PointListRect)
        elseif Trial(expTrial).StimPos(Pos_MemSet) == 6
            Screen('FillRect',expinfo.window, expinfo.Colors.pink, PointListRect)
        end
    end
else % for the probe
    if  Trial(expTrial).Category == 1 % figures
        
        if Trial(expTrial).Probe == 1 % arrow  
            PointList = zeros(7,2);
            PointList(1,1) = expinfo.centerX + 40*(1/2);
            PointList(1,2) = expinfo.centerY - 40*(1/5);
            PointList(2,1) = expinfo.centerX + 40*(1/2);
            PointList(2,2) = expinfo.centerY - 40*(1/2);
            PointList(3,1) = expinfo.centerX + 40;
            PointList(3,2) = expinfo.centerY;
            PointList(4,1) = expinfo.centerX + 40*(1/2);
            PointList(4,2) = expinfo.centerY + 40*(1/2);
            PointList(5,1) = expinfo.centerX + 40*(1/2);
            PointList(5,2) = expinfo.centerY + 40*(1/5);
            PointList(6,1) = expinfo.centerX - 40;
            PointList(6,2) = expinfo.centerY + 40*(1/5);
            PointList(7,1) = expinfo.centerX - 40;
            PointList(7,2) = expinfo.centerY - 40*(1/5);
            Screen('FramePoly',expinfo.window, expinfo.Colors.gray, PointList)
            
        elseif Trial(expTrial).Probe == 2 % triangle
            PointListTri = zeros(3,2);
            PointListTri(1,1) = expinfo.centerX -40;
            PointListTri(1,2) = expinfo.centerY +40;
            PointListTri(2,1) = expinfo.centerX;
            PointListTri(2,2) = expinfo.centerY -40;
            PointListTri(3,1) = expinfo.centerX +40;
            PointListTri(3,2) = expinfo.centerY +40;
            Screen('FramePoly',expinfo.window, expinfo.Colors.gray, PointListTri)
            
        elseif Trial(expTrial).Probe == 3 % diamond
            PointListRect = zeros(4,2);
            PointListRect(1,1)= expinfo.centerX;
            PointListRect(1,2)= expinfo.centerY - 40;
            PointListRect(2,1)= expinfo.centerX + 40;
            PointListRect(2,2)= expinfo.centerY;
            PointListRect(3,1)= expinfo.centerX;
            PointListRect(3,2)= expinfo.centerY + 40;
            PointListRect(4,1)= expinfo.centerX - 40 ;
            PointListRect(4,2)= expinfo.centerY;
            Screen('FramePoly',expinfo.window, expinfo.Colors.gray, PointListRect)
            
        elseif Trial(expTrial).Probe == 4 % circle
            PointListCircle = zeros(1,4);
            PointListCircle(1,1)= expinfo.centerX -40;
            PointListCircle(2,1)= expinfo.centerY - 40;
            PointListCircle(3,1)= expinfo.centerX +40;
            PointListCircle(4,1)= expinfo.centerY + 40;
            
            Screen('FrameOval',expinfo.window, expinfo.Colors.gray, PointListCircle)
            
        elseif  Trial(expTrial).Probe == 5 % pentagon
            PointListPenta = zeros(5,2);
            PointListPenta(1,1)= expinfo.centerX;
            PointListPenta(1,2)= expinfo.centerY - 61.5;
            PointListPenta(2,1)= expinfo.centerX + 64.5;
            PointListPenta(2,2)= expinfo.centerY -14.17;
            PointListPenta(3,1)= expinfo.centerX +40;
            PointListPenta(3,2)= expinfo.centerY + 61.5;
            PointListPenta(4,1)= expinfo.centerX - 40 ;
            PointListPenta(4,2)= expinfo.centerY +61.5;
            PointListPenta(5,1)= expinfo.centerX - 64.5 ;
            PointListPenta(5,2)= expinfo.centerY- 14.17;
            Screen('FramePoly',expinfo.window, expinfo.Colors.gray, PointListPenta)
            
        elseif  Trial(expTrial).Probe == 6 % star
            PointListStar = zeros(10,2);
            PointListStar(1,1)= expinfo.centerX;
            PointListStar(1,2)= expinfo.centerY - 61.5;
            PointListStar(2,1)= expinfo.centerX + 15.28;
            PointListStar(2,2)= expinfo.centerY -14.17;
            PointListStar(3,1)= expinfo.centerX + 64.5;
            PointListStar(3,2)= expinfo.centerY -14.17;
            PointListStar(4,1)= expinfo.centerX + 24.74 ;
            PointListStar(4,2)= expinfo.centerY + 14.38;
            PointListStar(5,1)= expinfo.centerX +40;
            PointListStar(5,2)=  expinfo.centerY + 61.5;
            PointListStar(6,1)= expinfo.centerX;
            PointListStar(6,2)= expinfo.centerY + 32.35;
            PointListStar(7,1)= expinfo.centerX - 40;
            PointListStar(7,2)= expinfo.centerY +61.5;
            PointListStar(8,1)= expinfo.centerX -24.74;
            PointListStar(8,2)= expinfo.centerY +14.38;
            PointListStar(9,1)= expinfo.centerX - 64.5;
            PointListStar(9,2)= expinfo.centerY- 14.17;
            PointListStar(10,1)= expinfo.centerX - 15.28 ;
            PointListStar(10,2)= expinfo.centerY - 14.17;
            Screen('FramePoly',expinfo.window, expinfo.Colors.gray, PointListStar)
        end
        
    elseif Trial(expTrial).Category == 2 % colors
        PointListRect = zeros(4,1);
        PointListRect(1,1)= expinfo.centerX - 40;
        PointListRect(2,1)= expinfo.centerY - 40;
        PointListRect(3,1)= expinfo.centerX + 40;
        PointListRect(4,1)= expinfo.centerY + 40;
        
        if Trial(expTrial).Probe == 1
            Screen('FillRect',expinfo.window, expinfo.Colors.green, PointListRect)
        elseif Trial(expTrial).Probe == 2
            Screen('FillRect',expinfo.window, expinfo.Colors.red, PointListRect)
        elseif Trial(expTrial).Probe == 3
            Screen('FillRect',expinfo.window, expinfo.Colors.yellow, PointListRect)
        elseif Trial(expTrial).Probe == 4
            Screen('FillRect',expinfo.window, expinfo.Colors.blue, PointListRect)
        elseif Trial(expTrial).Probe == 5
            Screen('FillRect',expinfo.window, expinfo.Colors.turquois, PointListRect)
        elseif Trial(expTrial).Probe == 6
            Screen('FillRect',expinfo.window, expinfo.Colors.pink, PointListRect)
        end
    end
end

Screen('DrawingFinished', expinfo.window);

%% Flip stimuli to screen
% Flip Screen
if ~exist('when','var') || isempty(when)
    % Flip expinfo.expinfo.window immediately
    timestamp_flip = Screen('Flip',expinfo.window);
  %  io64(expinfo.ioObj, expinfo.PortAddress, Marker);
else
    % Flip synced to timestamp entered
    timestamp_flip = Screen('Flip',expinfo.window,when);
  %  io64(expinfo.ioObj, expinfo.PortAddress, Marker);
end

end