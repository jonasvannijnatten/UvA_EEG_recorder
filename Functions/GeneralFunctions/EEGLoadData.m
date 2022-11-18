function [filename, data] = EEGLoadData(acceptedDataTypes)
% This function lets you select a .mat file containing EEG data and returns
% both the filename and the data struct.
%
% The input argument 'acceptedDataTypes' specifies which data types are
% accepted. Input options are:
% - 'time' for time series data
% - 'frequency' for power spectrum data
% - 'tf' for time-frequency data

if nargin==0
    acceptedDataTypes='any';
end

% look for data in the 'Data' directory, select a file and return to the
% main directory
[filename, pathname] = uigetfile({'*.mat'},'Select an EEG data file.',[cd '/Data']);
% if a file was selected, check which data format (time-series vs.
% time-frequency)
if ~any(filename)
    filename = [];
    data = [];
    return
end
load([pathname filename],'data');
fprintf('file loaded: %s%s\n', pathname, filename)

%% Input check
if ~exist('data','var') || ~isstruct(data)
    errordlg(['Selected file does not contain the right type of data.' ...
        'See the manual which data is accepted.'])
end

%% identify file type which is loaded
% check which dimensions are present in the data (samples, time,
% frequency, time-frequency), and which data types are accepted by the
% calling tool.
% if any data is accepted, do nothing
if ~strcmp(acceptedDataTypes, 'any')
    % check if data is in time domain
    if strcmp(acceptedDataTypes,'time') && strcmp(data.domain, 'time')
        fprintf('time series data loaded \n')
        % check if data is in frequency domain
    elseif strcmp(acceptedDataTypes,'frequency') && strcmp(data.domain, 'frequency')
        fprintf('frequemcy data loaded \n')
        % check if data is in time-frequency domain
    elseif strcmp(acceptedDataTypes,'tf') && strcmp(data.domain, 'tf')
        fprintf('time-frequemcy data loaded \n')
        % in any other case
    else
        msg = sprintf(['You selected data of the type %s.\n ' ...
            'This tool only accepts data of type %s.'], ...
            data.domain, acceptedDataTypes);
        errordlg(msg, 'Wrong data type selected.')
    end
else
    filename = [];
    data = [];
end

end % function end