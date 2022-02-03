function [saved] = EEGSaveData(handles, data, addition)

% TO-DO: add input arg to whether to clear data after saving or not

% check whether the calling function added a suggested filename addition
if nargin == 2
    addition = '_';    
elseif nargin == 3
    addition = ['_' addition];
end
% create new filename combining loaded file + addition
newname = [handles.filename.String(1:end-4) addition];

% select file path and name to save
cd(handles.dir.data);
[filename,pathname] = uiputfile('*','Save data',newname);
cd(handles.dir.main);

% if location is selected, save data
if any(filename)
    save([pathname filename], 'data');
    fprintf('file saved: %s%s\n', pathname, filename)
    saved = 1;
else
    saved = 0;
    fprintf('saving data canceled')
end
