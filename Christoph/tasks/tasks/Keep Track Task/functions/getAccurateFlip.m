% This function computes accurate timestamps for the next flip. This
% ensures accuracte timing for your experiment.

function [when_flip] = getAccurateFlip(window,lastflip,when_nextflip)

ifi = Screen('GetFlipInterval', window);
waitframes = round(when_nextflip/ifi);
when_flip = lastflip + (waitframes - 0.1) * ifi;

end

%% End of Function