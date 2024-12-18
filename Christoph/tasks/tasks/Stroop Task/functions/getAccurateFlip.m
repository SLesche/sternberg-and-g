% This function computes accurate timestamps for the next flip. This
% ensures accuracte timing for your experiment.

function [when_flip] = getAccurateFlip(window,vbl,wait)

ifi = Screen('GetFlipInterval', window);
waitframes = round(wait/ifi);
when_flip = vbl + (waitframes - 0.1) * ifi;

end

%% End of Function
