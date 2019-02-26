function [filename, data] = EEGLoadData(handles, acceptTF)
% [filename, data] = EEGLoadData(handles, acceptTF)
% This function takes the general GUI handles as input, and optionally an
% argument indicating whether the calling function or tool accepts time
% frequency data. The function returns the name of the loaded file and the
% data. The data can either be time-series EEG data in the form of a matrix
% or time-frequecy data in the form of a struct with the fields 'data','T'
% and 'F'. See the TF-analysis tool for more information on time frequency
% data.

if nargin == 1 % by default don't accept time frequency data
    acceptTF = 0;
end
% look for data in the 'Data' directory, select a file and return to the
% main directory
cd(handles.dir.data);
[filename, pathname] = uigetfile({'*.mat';},'Select a 2D array');
cd(handles.dir.main);
% if a file was selected, check which data format (time-series vs.
% time-frequency)
if any(filename)
    load([pathname filename]);
    fprintf('file loaded: %s%s\n', pathname, filename)
    if exist('data','var') && isnumeric(data)
        fprintf('time series loaded \n')
    elseif isstruct(data) && acceptTF==1
        fprintf('time-frequency data loaded\n')
    elseif isstruct(data) && acceptTF==0
        fprintf('Loaded file is time-frequency data. Unapropriate for current analyis tool. \n')
        errordlg('You are trying to load a time-frequency data file. This is an unapropriate format for this tool \n')
    else
        errordlg('you tried to load an unsupported data format')
    end
else
    data = [];
end

end % function end