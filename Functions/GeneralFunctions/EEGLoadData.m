function [filename, data] = EEGLoadData(mainDir)
cd([mainDir filesep 'Data']);
[filename, pathname] = uigetfile({'*.mat';},'Select a 2D array');
cd(mainDir);
if any(filename)
    load([pathname filename]);
else
    data = [];
end

end % function end