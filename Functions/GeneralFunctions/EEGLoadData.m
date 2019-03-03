function [filename, data] = EEGLoadData(handles)
cd(handles.dir.data);
[filename, pathname] = uigetfile({'*.mat';},'Select a 2D array');
cd(handles.dir.main);
if any(filename)
    load([pathname filename]);
    fprintf('file loaded: %s%s\n', pathname, filename)
else
    data = [];
end

end % function end