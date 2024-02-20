% First script to start the transistion in data format for EEG recorder
%
% The aim is to follow the data structure of EEGlab or Fieldtrip

% [filename, filepath]= uigetfile();
% load([filepath filename]);
load('2022_inwerken_taak1_.mat')
old_data = data;
clear data
% plot(old_data(:,1:2))
% hold on
% plot(old_data(:,9:14)/1e5)
% data = import_data(old_data);

data = import_data(old_data);

%% try fieldtrip functions
run('C:/Users/Jonas/Documents/MATLAB/fieldtrip-master/ft_defaults.m')

%% try fieldtrip trial definition

ft_definetrial


%% ft artifact rejection
 cfg.method     = 'summary';
 cfg.channel    = {'EEG1';'EEG2'};
 cfg.trials     = 'all';
 clean_data     = ft_rejectvisual(cfg, data);
 