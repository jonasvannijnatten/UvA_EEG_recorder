function data = import_data()
% this function takes a plain matrix and converts it to the new Fieldtrip
% like format by running the user through a few questions


%% actual code, temporarily commented for quick testing
[filename, filepath]= uigetfile();
if ~filename
    disp('No file selected')
    return
end
load([filepath filename], 'data');
% load('2022_inwerken_taak1_.mat','data');
old_data = data;
clear data

% check if the input data is a plain matrix
if ~isnumeric(old_data)
    warndlg('The selected file does not contain a simple matrix and therefore can not be imported', 'Wrong data type')
    return
end


dlgtitle = 'Provide information on your data';
dlgpromt = { ...
    'What is the sampling rate of the data (Hz)?'; ...
    sprintf(['What are the names of the channels? (optional)\n'... 
    'For example use 10-20 electrode locations as channel names.']); ...
    sprintf(['What are the signal types of the channels? \n' ...
    'The default (when left empty) tries to detect "Marker" channels and labels everything else "EEG"\n'...
    'Choose any of the following options: EEG/EOG/EMG/ECG/GRS/Marker']); ...
    'What do the rows represent?'; ...
    'What do the columns represent?' ...
    };

if size(old_data,3)>1
    dlgpromt{end+1} = 'What does the tird dimension represent?';
end

inputBoxHeight = 26;

formats = struct('type', {}, 'style', {}, 'items', {}, 'format', {}, 'limits', {}, 'size', {});
% sampling rate
formats(1,1).type   = 'edit';
formats(1,1).format = 'integer';
formats(1,1).style  = 'edit';
formats(1,1).size   = [100 inputBoxHeight];
% formats(1,1).labelloc = 'topleft';
defaultAnswers      =  {256};

% channel names (optional)
formats(2,1).type   = 'edit';
formats(2,1).format = 'text';
formats(2,1).style  = 'edit';
formats(2,1).size   = [600 inputBoxHeight];
formats(2,1).labelloc = 'topleft';
defaultAnswers = [defaultAnswers; {''}];

% channel types (optional)
formats(3,1).type   = 'edit';
formats(3,1).format = 'text';
formats(3,1).style  = 'edit';
formats(3,1).size   = [600 inputBoxHeight];
formats(3,1).labelloc = 'topleft';
defaultAnswers = [defaultAnswers; {''}];

% representation of rows
formats(4,1).type   = 'list';
formats(4,1).format = 'text';
formats(4,1).style  = 'popupmenu';
formats(4,1).items  = {'samples', 'channels'};
% formats(4,1).labelloc = 'topleft';
defaultAnswers = [defaultAnswers; {'samples'}];

% representation of columns
formats(5,1).type  = 'list';
formats(5,1).format = 'text';
formats(5,1).style  = 'popupmenu';
formats(5,1).items  = {'samples', 'channels'};
% formats(5,1).labelloc = 'topleft';
defaultAnswers = [defaultAnswers; {'channels'}];

% if applicable, representation of 3rd dimension
if size(old_data,3)>1
    formats(6,1).type  = 'list';
    formats(6,1).format = 'text';
    formats(6,1).style  = 'popupmenu';
    formats(6,1).items  = {'trials', 'subjects','conditions'};
%     formats(6,1).labelloc = 'topleft';
    defaultAnswers = [defaultAnswers; {'trials'}];
end

% defaultAnswers = {256;'';'';'samples';'channels'};

Options.FontSize = 16;
Options.Resize = 'on';
Options.Sep     = 10;

opts = inputsdlg(dlgpromt, dlgtitle, formats, defaultAnswers, Options);

%% input checks

% check if the sampling rate is a positive integer
if isempty(opts{1})
    errordlg('please provide a sampling rate.')
elseif ~isnumeric(opts{1}) || isnan(opts{1})
    errordlg('please provide a numeric value for the sampling rate.')
elseif opts{1} <= 0 || mod(opts{1},1)~=0
    errordlg('please provide a positiver integer as sampling rate value.')
else
    data.fsample = opts{1};
end

% save the data dimensions
if length(opts) == 5
    data.dims = convertCharsToStrings({ opts{4}{1}, opts{5}{1} });
elseif length(opts) == 6
    data.dims = convertCharsToStrings({ opts{4}{1}, opts{5}{1}, opts{6}{1} });
end

% check if the data dimensions are different
if strcmp(opts{4}{:}, opts{5}{:})
    errordlg('The dimensions of the data can not be the same.')
elseif strcmp(opts{4}{:}, 'samples') && strcmp(opts{5}{:},'channels')
    % use the data as it is
    data.trial = permute(old_data,[2 1 3]);
elseif strcmp(opts{4}{:}, 'channels') && strcmp(opts{5}{:},'samples')
    % transpose the data to match the new format
    data.trial = old_data;
else
    % this should not be able to happen
    warndlg('Hmm something strange happened.')
end
% store the nr of channels and samples into separate variables for further
% tools
nrofchannels    = size(data.trial(:,:,1),1);
nrofsamples     = size(data.trial(:,:,1),2);

%% Add channel labels
% Default the channels are only numbered.
% If channel labels are provided these are overwritten.
% It is possible to label only a subset of channels.
data.channelLabels= compose("Chan%02i",1:nrofchannels);
if ~isempty(opts{2})
    givenLabels = convertCharsToStrings(strsplit(opts{2}));
    for ichan = 1:length(givenLabels)
        data.channelLabels(ichan) = givenLabels(ichan);
    end
end

%% Add channel types
% Default the import tool labels everything EEG, except channels that
% contain purely zeros or contain changes of more than 4 Volts.
data.channelTypes = repelem("EEG",nrofchannels);
if ~isempty(opts{3})
    givenTypes = convertCharsToStrings(strsplit(opts{3}));
    for ichan = 1:length(givenTypes)
        data.channelTypes(ichan) = givenTypes(ichan);
    end
end

if find(strcmp(data.dims,"channels")) == 1
    for ichan = 1:nrofchannels
        if max(diff(old_data(ichan,:,1)))>4
            data.channelTypes(ichan) = "Marker";
        end
    end
elseif find(strcmp(data.dims,"channels")) == 2
    for ichan = 1:nrofchannels
        if max(diff(old_data(:,ichan,1)))>4 || ~any(old_data(:,ichan,1))
            data.channelTypes(ichan) = "Marker";
        end
    end
end


% store first and last sample nr of the trial
data.sampleinfo = [1 nrofsamples];

% convert sample numbers to time points
data.time       = (0:nrofsamples-1) / data.fsample;

% add importdate to history
data.history = sprintf(['Data imported at ' char(datetime("now")) '\n\n' ]);

% function end
end
