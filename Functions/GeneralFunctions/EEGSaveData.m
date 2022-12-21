function [saved, filename] = EEGSaveData(EEG, addition)
% [saved, filename] = EEGSaveData(EEG, addition)
% Saves the EEG data set with the user provided file path and file name.
% The addition input is a string wich will be appended to the filename of
% the currently loaded EEG data file to indicate which processing step has
% been applied
% saved - Logical indicating whether the data has been succesfully saved
% filename - returns the new filename as a string

% check whether the calling function added a suggested filename addition
if nargin == 1
    addition = '_';    
elseif nargin == 2
    addition = ['_' addition];
end

% create new filename combining loaded file + addition
if ~isempty(EEG.filename)
    newname = [cd filesep 'Data' filesep EEG.filename addition];
else
    newname = [cd filesep 'Data' filesep ];
end

% select file path and name to save
[filename, pathname] = uiputfile({'*.*'},'Save data',newname);

% if location is selected, save data
if any(filename)
    EEG.filename = filename;
    save([pathname filename], 'EEG');
    fprintf('file saved: %s%s\n', pathname, filename)
    saved = 1;
    % otherwise return 0
else
    saved = 0;
    fprintf('saving data canceled\n')
end
