% This is a generic functions that shows a predefined image (ima) and waits
% for a key press. As soon as any key on the keyboard is pressed, the
% screen is cleared.

function dImageWait(expinfo, ima)
    InstScreen = Screen('MakeTexture',expinfo.window,ima);
    Screen('DrawTexture', expinfo.window, InstScreen); % draw the scene
    Screen('Flip', expinfo.window);
    
    while KbCheck; end      %clear keyboard queue
    KbWait;                 %wait for any key
    clearScreen(expinfo);
end

%% End of Function
