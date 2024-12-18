% This function clears the buffer and closes the currnetly running
% experiment

function closeexp(window)

ShowCursor(1);  % Show cursor again
ListenChar();    % Enable listening to the keyboard
Screen(window,'Close'); % Close window

% Clear buffer for saved evetns
while KbCheck; end
FlushEvents('keyDown');

% End of Function

