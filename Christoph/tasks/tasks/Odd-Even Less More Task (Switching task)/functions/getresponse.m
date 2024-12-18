% This function waits for a response and saves the
function Trial = getresponse(expinfo, Trial, expTrial, start)
% Start iternal MATLAB stop-clock
tic

% If timestamp for onset latency is not provided read out current system
% time. Attention this is just a work around and leads to biased reaction
% times
if ~exist('start','var')
    start = GetSecs;
end

% Initialise the response variables
Trial(expTrial).response = 0;
Trial(expTrial).ACC = -9;
Trial(expTrial).RT = -9;

% clear Buffer of Keyboard
while toc < 0.1; KbCheck;  end
% io64(expinfo.ioObj, expinfo.PortAddress, 0); % Stop Writing to Output Port

% read out keyboard until valid key is pressed or maximal allowed response
% time is reached
ScreenCleared = 0;
while toc < expinfo.MaxRT
    % clear screen once after 0.250 ms
    if expinfo.LongRT ~= 1
        if toc >= 0.250 && ScreenCleared == 0
            clearScreen(expinfo);
            ScreenCleared = 1;
        end
    end
    % Read keyboard
    [keyIsDown,timeSecs,keyCode] = KbCheck;
    
    if keyIsDown
        % get pressed Key
        pressedKey = KbName(keyCode);
                % Abbruch des Experiments
        if  strcmp(pressedKey,expinfo.AbortKey)
            closeexp(expinfo.window);
        end  
        % is it a vlaid key 
        
        if strlength(pressedKey) ~= 1
            response = -9;
            break
        elseif length(pressedKey) > 1
            response = -9;
            break
        else
            if any(strcmp(pressedKey,expinfo.RespKeys))
                
                response = 1;
                if strcmp(pressedKey,Trial(expTrial).CorResp)
                    if  Trial(expTrial).CorResp == 'd'
                       % io64(expinfo.ioObj, expinfo.PortAddress,expinfo.Marker.CorrResp_D);
                    else
                       % io64(expinfo.ioObj, expinfo.PortAddress,expinfo.Marker.CorrResp_L);
                    end
                else
                    if strcmp(pressedKey,'d')
                       % io64(expinfo.ioObj, expinfo.PortAddress,expinfo.Marker.IncorrResp_D);
                    else
                      %  io64(expinfo.ioObj, expinfo.PortAddress,expinfo.Marker.IncorrResp_L);
                    end
                end
                break;
            end            
        end        
    else
        response = 0;
    end    
end
Trial(expTrial).keyPressed = timeSecs;

if response == 1 % if a valid key was presses
    Trial(expTrial).RT = timeSecs - start; % compute teaction time
    
    % Test whether the correct response was given
    if strcmp(pressedKey,Trial(expTrial).CorResp)
        Trial(expTrial).ACC = 1;
    else
        Trial(expTrial).ACC = 0;
    end
    
    Trial(expTrial).response = pressedKey;
elseif  response == 0  % If no valid key was pressed -> Miss
    Trial(expTrial).RT = expinfo.MaxRT;
    Trial(expTrial).ACC = -2;
    Trial(expTrial).response = 'miss';
    io64(expinfo.ioObj, expinfo.PortAddress, expinfo.Marker.Miss);
else % if no response was given 
    Trial(expTrial).RT = expinfo.MaxRT;
    Trial(expTrial).ACC = -3;
    Trial(expTrial).response = 'wrongKey';    
   io64(expinfo.ioObj, expinfo.PortAddress,expinfo.Marker.IncorrResp);
end

while KbCheck; end % clear buffer
FlushEvents('keyDown');

%% End of Function