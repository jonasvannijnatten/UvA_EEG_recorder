function trials_art_sorted = artefactDetection(filename_load, number_of_channels, art_limit)
% ARTEFACTDETECTION checks EEG data for artefacts and either removes or
% keeps EEG trials with artefacts.
% Usage: artefactDetection(filename_load, number_of_channels, condition,
% art_limit, filename_out)
% Input arguments:
% filename_load: name of EEG data file to check for artefacts
% number_of_channels: number of active EEG channels
% condition: 'artefact' for output file containing only artefact trials,
% 'clean' for output file containing only clean trials.
% art_limit: limit in microvolts above which signal is considered an
% artefact
% filename_out: name of output file

% Error checks
% if ~(strcmp(condition, 'clean') || strcmp(condition, 'artefact'))
%     error('Invalid condition. Enter either clean or artefact')
% end

% Load data
data_file = load(filename_load);

data_EEG = data_file.data;

% Get data of active EEG channels
data_EEG_channels = data_EEG(:, 1:number_of_channels, :);

% Get number of samples, channels and trials
[~, channels, trials] = size(data_EEG_channels);

% Create vectors for storing clean trials and trials with artefact
trials_art = [];

% Loop over channels
for channel_nr = 1:channels
    
    % Loop over trials
    for trial_nr = 1:trials
        
        % Get data of current channel and trial and convert to microvolts
        trial_data_mV = data_EEG_channels(:, channel_nr, trial_nr) * 1000000;
        
        % Check if trial contains data bigger than 100 mV (artefact)
        if (any(trial_data_mV > art_limit) || any(trial_data_mV < -art_limit)) && ~ismember(trial_nr, trials_art)
            % Add trial number to list of trials with artefact
            trials_art = [trials_art, trial_nr];
        end
    end
end

% Put the numbers of trials with artefacts in right order
trials_art_sorted = sort(trials_art);

% % If user wants clean trials, remove trials with artefact from data
% if strcmp(condition, 'clean')
%     data(:, :, trials_art_sorted) = [];
% % If user wants artefact trials, get data of trials with artefacts
% elseif strcmp(condition, 'artefact')
%     data = data(:, :, trials_art_sorted);
% end

trials_clean = 1:trials;
trials_clean(trials_art_sorted) = [];

data = data_EEG(:, :, trials_art_sorted);
filename_art = [filename_load, '_art'];
% save(filename_art, 'data')
curdir = cd;
cd([curdir filesep]);
uisave({'data'},filename_art);
cd(curdir);

clear data

data = data_EEG(:, :, trials_clean);
filename_clean = [filename_load, '_clean'];
% save('test_clean', 'data')
curdir = cd;
cd([curdir filesep]);
uisave({'data'},filename_clean);
cd(curdir);

% save(filename_clean, 'data')