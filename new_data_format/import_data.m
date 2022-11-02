function data = import_data()
% this function takes a plain matrix and converts it to the new Fieldtrip
% like format by running the user through a few questions


%% actual code, temporarily commented for quick testing
% [filename, filepath]= uigetfile();
% if ~filename
%     disp('No file selected')
%     return
% end
% load([filepath filename], 'data');
load 2022_inwerken_taak1_.mat
old_data = data;
clear data

% check if the input data is a plain matrix
if ~ismatrix(old_data)
    warndlg('The selected file does not contain a simple matrix and therefore can not be imported', 'Wrong data type')
    return
end


dlgtitle = 'Provide information on your data';
dlgpromt = { ...
    'what is the sampling rate of the data?'; ...
    'What are the names of the channels?'; ...
    'what do the rows represent?'; ...
    'What do the columns represent?' ...
    };

if size(old_data,3)>1
    dlgpromt{end+1} = 'What does the tird dimension represent?';
end



formats = struct('type', {}, 'style', {}, 'items', {}, 'format', {}, 'limits', {}, 'size', {});

formats(1,1).type   = 'edit';
formats(1,1).format = 'integer';
formats(1,1).style  = 'edit';
formats(1,1).size   = [100 20];

formats(2,1).type   = 'edit';
formats(2,1).format = 'text';
formats(2,1).style  = 'edit';
formats(2,1).size   = [600 20];

formats(3,1).type   = 'list';
formats(3,1).format = 'text';
formats(3,1).style  = 'popupmenu';
formats(3,1).items  = {'samples', 'channels'};

formats(4,1).type  = 'list';
formats(4,1).format = 'text';
formats(4,1).style  = 'popupmenu';
formats(4,1).items  = {'samples', 'channels'};

if size(old_data,3)>1
    formats(5,1).type  = 'list';
    formats(5,1).format = 'text';
    formats(5,1).style  = 'popupmenu';
    formats(5,1).items  = {trials', 'conditions'};
end

defaultAnswers = {256;'';'samples';'channels'};

opts = inputsdlg(dlgpromt, dlgtitle, formats, defaultAnswers);

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
data.dims = convertCharsToStrings({opts{3}{1}, opts{4}{1}});

% check if the data dimensions are different
if strcmp(opts{3}{:}, opts{4}{:})
    warndlg('The dimensions of the data can not be the same.')
    return
elseif strcmp(opts{3}{:}, 'samples') && strcmp(opts{4}{:},'channels')
    % use the data as it is
    data.trial = old_data';
elseif strcmp(opts{3}{:}, 'channels') && strcmp(opts{4}{:},'samples')
    % transpose the data to match the new format
    data.trial = old_data;
else
    % this should not be able to happen
    warndlg('Hmm something strange happened.')
end
nrofchannels    = size(data.trial(:,:,1),1);
nrofsamples     = size(data.trial(:,:,1),2);

% check if the channel labes are chars
if isempty(opts{2})
    defaultLabels = convertCharsToStrings(strsplit(sprintf('channel_%d ', 1:nrofchannels)));
    defaultLabels(end) = [];
    data.label = defaultLabels';
elseif length(strsplit(opts{2})) < nrofchannels
    givenLabels = convertCharsToStrings(strsplit(opts{2}));
    defaultLabels = convertCharsToStrings(strsplit(sprintf('channel_%d ', 1:nrofchannels)));
    defaultLabels(end) = [];
    data.label = defaultLabels';
    for ichan = 1:length(givenLabels)
        data.label(ichan) = givenLabels(ichan);
    end
end

data.time       = (0:nrofsamples-1) / data.fsample;
data.sampleinfo = [1 nrofsamples];

% function end
end
