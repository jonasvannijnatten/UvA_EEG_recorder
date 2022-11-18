function [saved] = EEGSaveData(data, addition)

% TO-DO: add input arg to whether to clear data after saving or not

% check whether the calling function added a suggested filename addition
if nargin == 1
    addition = '_';    
elseif nargin == 2
    addition = ['_' addition];
end

% create new filename combining loaded file + addition
if isfield(data,'filename')
    newname = [cd filesep 'Data' filesep data.filename.String(1:end-4) addition];
else
    newname = [cd filesep 'Data' filesep ];
end

% select file path and name to save
[filename, pathname] = uiputfile({'*.*'},'Save data',newname);

% if location is selected, save data
if any(filename)
    save([pathname filename], 'data');
    fprintf('file saved: %s%s\n', pathname, filename)
    saved = 1;
    % otherwise return 0
else
    saved = 0;
    fprintf('saving data canceled')
end
