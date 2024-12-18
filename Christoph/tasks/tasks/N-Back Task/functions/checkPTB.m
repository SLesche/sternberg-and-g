% Check wether PTB is installed and save PTB infos to the expinfo object

function checkPTB

ptbInfo = PsychtoolboxVersion;  %if ptb not installed, error will be trapped
if ischar(ptbInfo)
    PTBversion = str2double(ptbInfo(1)); 
end

ptb3 = (PTBversion >= 3);
end
%% End of Function
