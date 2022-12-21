function [filename, EEG] = EEGLoadData(acceptedDataTypes)
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
    EEG = [];
    return
end
load([pathname filename],'EEG');
fprintf('file loaded: %s%s\n', pathname, filename)

%% Input check
if ~exist('EEG','var') || ~isstruct(EEG)
    msg = ['Selected file does not contain the right type of data.' ...
        'See the manual which data is accepted.'];
    errordlg(msg)
    disp(msg)
end

%% identify file type which is loaded
% check which dimensions are present in the data (samples, time,
% frequency, time-frequency), and which data types are accepted by the
% calling tool.
% if any data is accepted, do nothing
if any(strcmp(acceptedDataTypes, 'any'))
    fprintf('%s data loaded\n', EEG.domain)
    % check if data type mathces the accepted data types
elseif any(strcmp(EEG.domain, acceptedDataTypes))
    dataType = acceptedDataTypes(strcmp(acceptedDataTypes,EEG.domain));
    fprintf("%s data loaded\n", dataType)
    % in any other case
else
    msg = sprintf(['You selected data of the type %s.\n' ...
        'This tool only accepts data of type "%s."\n'], ...
        EEG.domain, join(acceptedDataTypes));
    fprintf(msg)
    filename = [];
    EEG = [];
    errordlg(msg, 'Wrong data type selected.')
end


end % function end