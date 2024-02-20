function varargout = EEG_recorder(varargin)
% EEG_RECORDER MATLAB code for EEG_recorder.fig
%      EEG_RECORDER, by itself, creates a new EEG_RECORDER or raises the existing
%      singleton*.
%
%      H = EEG_RECORDER returns the handle to a new EEG_RECORDER or the handle to
%      the existing singleton*.
%
%      EEG_RECORDER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in EEG_RECORDER.M with the given input arguments.
%
%      EEG_RECORDER('Property','Value',...) creates a new EEG_RECORDER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before EEG_recorder_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to EEG_recorder_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help EEG_recorder

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @EEG_recorder_OpeningFcn, ...
    'gui_OutputFcn',  @EEG_recorder_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

function EEG_recorder_OpeningFcn(hObject, eventdata, handles, varargin)
fprintf('powering up...\n')
% Enable 'start' button, disable 'stop' and 'clear' button
set(handles.start_recording, 'Enable','on');
set(handles.stop_recording, 'Enable','off');
set(handles.clear, 'Enable','off');
for i = 1:length(handles.TTL_panel.Children)
    set(handles.TTL_panel.Children(i),'Enable','on')
end
handles.dir.main = cd; % save path to main directory
if ~(exist([cd filesep 'Backup'],'dir')==7) % create 'Backup' directory if necessary
    mkdir('Backup')
    fprintf('created Backup directory\n')
end
if ~(exist([cd filesep 'Data'],'dir')==7) % create 'Data' directory if necessary
    mkdir('Data');
    fprintf('created Data directory\n')
end
% add subdirectories
handles.dir.backup      = [handles.dir.main filesep 'Backup'];
handles.dir.data        = [handles.dir.main filesep 'Data'];
handles.dir.functions   = [handles.dir.main filesep 'Functions'];
handles.dir.help        = [handles.dir.main filesep 'Help_files'];
addpath(handles.dir.backup, genpath(handles.dir.data), genpath(handles.dir.functions), genpath(handles.dir.help));

handles.plotColors = [    ...
    0      0.4470 0.7410; ...
    0.8500 0.3250 0.0980; ...
    0.9290 0.6940 0.1250; ...
    0.4940 0.1840 0.5560; ...
    0.4660 0.6740 0.1880; ...
    0.3010 0.7450 0.9330; ...
    0.6350 0.0780 0.1840; ...
    1      0      1       ...    
    ];

handles.output = hObject;
guidata(hObject, handles);

function varargout = EEG_recorder_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

% set screen to maximized at startup
handles.figure1.WindowState = 'Maximized'; % maximize screen

% % Check which matlab version is running.
% % Give a warning that recording for the g.tec setup is only possible with
% % matlab version 2015 or earlier.
% if strcmp(computer, 'PCWIN64')
%     opts.WindowStyle = 'modal';
%     opts.Interpreter = 'tex';
%     bitWarning = sprintf([...
%         'You are running a 64-bit version of MATLAB.\n' ...
%         'Recording is currently only available in 32-bit MATLAB (2015).\n' ...
%         'Data analysis tools are available in both versions.'...
%         ]);
%     warndlg(['\fontsize{20}' bitWarning],'Matlab version',opts);
%     fprintf(['\nWARNING:\n' bitWarning '\n']);
%     set(handles.start_recording, 'Enable','off');
%     fprintf('Welcome to the EEG recorder!\n')
% end

% Check whether the correct matlab version is used.
% some functions only work from 2021a onwards
v = version('-release');
v = str2double(v(1:4));
if v<2021
    opts.WindowStyle = 'modal';
    opts.Interpreter = 'tex';
    bitWarning = sprintf([...
        'You are running an older version of MATLAB.\n' ...
        'Please update to matlab 2021a or later.\n'
        ]);
    warndlg(['\fontsize{20}' bitWarning],'Matlab version',opts);
    fprintf(['\nWARNING:\n' bitWarning '\n']);
    set(handles.start_recording, 'Enable','off');
    fprintf('Welcome to the EEG recorder!\n')
end

% Check if the signal processing toolbox is installed (required for the
% cutting tool and  time frequency analysis) and give a warning when this
% is not the case.
if exist('bandpass','file') ~= 2 %~license('checkout','Signal_Toolbox')
    opts.WindowStyle = 'modal';
    opts.Interpreter = 'tex';
    toolboxWarning = sprintf([...
        'The signal processing toolbox is not installed.\n' ...
        'This is required for some analysis tools so make sure to install it.\n' ...
        'This can be done in Matlab under the ''HOME'' tab:\n' ...
        '- Click on ''Add-Ons''\n- Click on ''Get Add-Ons'' .'...
        ]);
    warndlg(['\fontsize{20}' toolboxWarning],'Matlab version',opts);
    fprintf(['\nWARNING:\n' toolboxWarning '\n']);
else
    fprintf('Signal Processing Toolbox detected\n')
end

function find_lega_Callback(hObject, eventdata, handles)
global ai
disp('display information related to hardware')
daqhardwareinfo = daqhwinfo;
disp('list of installed hardware adaptors on machine')
daqinstalledadaptors = daqhardwareinfo.InstalledAdaptors;
disp('To register adator type : daqregister(,adaptorname,)')
daqregister('gmlplusdaq')
daqinfo = daqhwinfo('gmlplusdaq');
comport = str2double(daqinfo.InstalledBoardIds{1});
disp('out = daqhwinfo(ai,{MinSampleRate,MaxSampleRate})')
ai = analoginput('gmlplusdaq',comport);
out = daqhwinfo(ai,{'MinSampleRate','MaxSampleRate'});
rates = propinfo(ai,'SampleRate');
rates.ConstraintValue

delete(ai)
clear ai

function stop_recording_Callback(hObject, eventdata, handles)
% global ai
% global data
global manualstop
global FileName
global data
global save_disk
global save_diskmem
manualstop = 1;
disp('Manually stopped')
ai = daqfind;
if ~isempty(ai)
    stop(ai)
    disp('Acquisition object cleared')
    disp(['Recorded ' num2str(length(data)/256) ' seconds of data'])
    disp(['Recording ended at: '  datestr(now)])
    disp('---------------------------------Stop--------------------------------------')
    pause(.1);
end

if save_disk == 1 | save_diskmem == 1
    if exist(FileName,'file')==2
        data = daqread(FileName);
    else
        fprintf('no data to backup\n')
    end
end
set(handles.start_recording, 'Enable', 'off');
pause(.1);
set(handles.stop_recording, 'Enable', 'off');
set(handles.dur_aq,'Enable','on');
set(handles.clear,'Enable','on');

function dur_aq_Callback(hObject, eventdata, handles)
global dur_aq
dur_aq = str2double(get(hObject,'String'));
return
function dur_aq_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function Fs_vak_Callback(hObject, eventdata, handles)
global Fs
Fs = str2double(get(hObject,'String'));
return
function Fs_vak_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function start_recording_Callback(hObject, eventdata, handles)
fprintf('\n')
set(handles.start_recording, 'Enable','off')
set(handles.clear, 'Enable','off')
set(handles.dur_aq,'Enable','off');
for i = 1:length(handles.TTL_panel.Children)
    set(handles.TTL_panel.Children(i),'Enable','off')
end
pause(.1);
global dur_aq
global Fs
global num_chan
global data; data = [];
global fft_l
global preview
global ai
global manualstop
global plot_spectogram
global plot_neurofeedback

mainDir = handles.dir.main;

plotColors = handles.plotColors;
[0 0.4470 0.7410 ;0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; 0.4940 0.1840 0.5560; ...
    0.4660 0.6740 0.1880; 0.3010 0.7450 0.9330; 0.6350 0.0780 0.1840; 1 0 1];

handles.wb = waitbar(0);
try
    waitbar(.1,handles.wb,'terminate any running recordings');
    ai = daqfind;
    if ~isempty(ai)
        stop(ai)
    end
    
    waitbar(.2,handles.wb,'setting viewing parameters');
%     for ichan = 1:8
%         eval(['chan' num2str(ichan) ' = get(handles.channel_' num2str(ichan) ', ''Value'');'])
%     end
%     for ichan = [9 10 12 13 14 15]
%         eval(['chan' num2str(ichan) ' = get(handles.ch' num2str(ichan) '_on , ''Value'');'])
%     end
    
    fprintf('setting viewing parameters\n')
    dur_aq      = str2double(get(handles.dur_aq,'String'));
    Fs          = 256;
    % chan_space      = str2double(get(handles.chan_space,'String'));
    fft_l = str2double(get(handles.fft_ll,'String'));
    preview     = str2double(get(handles.prev_t,'String'));
    manualstop  = 0;
    
    global save_SD_on
    if (get(handles.save_SD_on,'Value') == get(handles.save_SD_on,'Max'))
        save_SD_on =1;
    else
        save_SD_on =0;
    end
    
    waitbar(.3,handles.wb,'searching for recording device');
    
    fprintf('searching for recording device \n')
    %% connect to MOBIlab
    % see if a mobilab was connected before
    % if so, use the same device
    % else search for connected devices
    if ~isfield(handles, 'daqinfo') || isempty(handles.daqinfo.InstalledBoardIds)
        try
            daqreset;
            handles.daqinfo = getDaqDevice('gmlplusdaq');
            if isempty(handles.daqinfo.InstalledBoardIds)
                fprintf('device initialization failed\n')
                set(handles.start_recording, 'Enable','on');
                set(handles.stop_recording, 'Enable','off');
                set(handles.clear, 'Enable','off');
                close(handles.wb);
                return
            end
        catch ME
            close(handles.wb);
            errordlg('Some unexpected error occured while connecting to the MOBIlab. See MATLAB command window for more information.')
            rethrow(ME);
        end
    else
        fprintf('Using same device as last time\n');
    end
    guidata(hObject, handles)
    waitbar(.5,handles.wb,'connected to recording device');
    fprintf('established connection with %s on comport %s \n', handles.daqinfo.BoardNames{1}, handles.daqinfo.InstalledBoardIds{1})
    
    waitbar(.6,handles.wb,'creating data acquisition object');
    %% create recording object
    try
        ai = analoginput(handles.daqinfo.AdaptorName,handles.daqinfo.comport);
    catch ME
        close(handles.wb);
        errordlg('Some unexpected error occured while connecting to the MOBIlab. See MATLAB command window for more information.')
        rethrow(ME);
    end
    
    %% Set recording parameters
    waitbar(.7,handles.wb,'setting recording parameters');
    if save_SD_on == 1
        set(ai,'SDCard', 'Enable');
    else
        set(ai,'SDCard', 'Disable');
    end
    global save_mem
    if (get(handles.save_mem, 'Value') == get(handles.save_mem, 'Max'))
        save_mem = 1;
    else
        save_mem = 0;
    end
    global save_disk
    FileName = [handles.dir.main '\Backup\backup_' datestr(now,'ddmmyyyy_HHMM')];
    if (get(handles.save_disk, 'Value') == get(handles.save_disk, 'Max'))
        save_disk           = 1;
        ai.LoggingMode      = 'Disk';
        ai.LogToDiskMode    = 'Index';
        ai.LogFileName      = FileName;
    else
        save_disk = 0;
    end
    global save_diskmem
    if (get(handles.save_diskmem, 'Value') == get(handles.save_diskmem, 'Max'))
        save_diskmem        = 1;
        ai.LoggingMode      = 'Disk&Memory';
        ai.LogToDiskMode    = 'Index';
        ai.LogFileName      = FileName;
    else
        save_diskmem = 0;
    end
    
    %% add channels to recording object
    % always record the eight EEG channels
    addchannel(ai,1:8);
    num_chan = 8;
    channelLabels = {'chan1','chan2','chan3','chan4','chan5','chan6','chan7','chan8','DIO1','DIO2','DIO3','DIO4','DIO5','DIO6'};
%     legend(handles.axes1,channelLabels, 'Location','SouthEast');
    
    extraChan = 0;
    
    % check which DIO channels are activated
    num_TTLs = 0;
    for ichan = 9:14
        if ichan == 11
            extraChan = 1;
        end
        if eval(['get(handles.ch' num2str(ichan) '_on, ''Value'')']) == 1;
            addchannel(ai,ichan+extraChan);
            num_chan = num_chan+1;
            num_TTLs = num_TTLs + 1;
        end
    end
    
    analog_channels_on = [handles.channel_1.Value, handles.channel_2.Value, handles.channel_3.Value, handles.channel_4.Value, ...
        handles.channel_5.Value, handles.channel_6.Value, handles.channel_7.Value, handles.channel_8.Value];
    digital_channels_on = [ ...
        handles.ch9_on.Value, ...
        handles.ch10_on.Value, ...
        handles.ch11_on.Value, ...
        handles.ch12_on.Value, ...
        handles.ch13_on.Value, ...
        handles.ch14_on.Value, ...
        ];
    
    num_dig_chan = length(find(digital_channels_on));    
    channels_on = [analog_channels_on digital_channels_on];    
    channel_selection = find(channels_on);
    num_chan_plot = length(channel_selection);
    
    fprintf('nr of channels: %d \n', num_chan);
    
    set(ai,'SamplesPerTrigger',dur_aq*Fs);
    global a
    
catch ME
    delete(handles.wb)
    errordlg('Initialization failed! see command window for more information.')
    set(handles.stop_recording,'Enable','on')
    rethrow(ME)
end

try
    waitbar(.8,handles.wb,'ready to start recording');
    fprintf('---------------------------------Start-------------------------------------\n')
    fprintf('Recording started at: %s \n', datestr(now))
    start(ai)
    waitbar(.8,handles.wb,'recording started. Getting data to plot');
    pause(.1);
    set(handles.stop_recording,'Enable','on')
    delete(handles.wb);
catch ME
    delete(handles.wb);
    errordlg('Gathering preview data failed. See command window for more information.');
    rethrow(ME);
end
ai.SamplesAcquired;
while ai.SamplesAcquired < dur_aq * Fs  && manualstop == 0
    %% get latest data to plot
    samps = ai.SamplesAcquired;  % how many samples are acquired in total
    
    % get the proportion of the preview time
    tempSample = mod(samps-1, preview)+1;
    
    % calculate samples to time for x-axis
    tempTime = (samps-tempSample+1:samps-tempSample+preview)/256 ;
    
    % get most recent data to plot
    tempData = peekdata(ai,tempSample);
    
    %% get plotting setting
    data = zeros(preview,8+num_dig_chan);
    data(1:tempSample,:) = tempData;
    digicounter  = 0;
    analog_channels_on = [handles.channel_1.Value, handles.channel_2.Value, handles.channel_3.Value, handles.channel_4.Value, ...
        handles.channel_5.Value, handles.channel_6.Value, handles.channel_7.Value, handles.channel_8.Value];
    channels_on = [analog_channels_on digital_channels_on];
    channel_selection = find(channels_on);
    num_chan_plot = length(channel_selection);
    chan_space = str2double(get(handles.chan_space,'String'))/1000;
    a = linspace(-chan_space,chan_space,num_chan_plot);
    b = sort(a,'descend');
    % get default settings
    plot_spectogram = handles.spectogram.Value;
    plot_neurofeedback = handles.neurofeedback.Value;
    
    %% plot live signal
    for ichan=1:num_chan_plot
        if channel_selection(ichan)< 9
            plot(handles.axes1,tempTime,data(:,channel_selection(ichan))+b(ichan), 'Color', plotColors(channel_selection(ichan),:)); hold(handles.axes1,'on')
        else
            digicounter = digicounter + 1;
            plot(handles.axes1,tempTime,data(:,(8+digicounter))./100000+b(ichan),'k'); hold(handles.axes1,'on')
        end
    end
    grid(handles.axes1,'on');
    drawnow; hold(handles.axes1,'off');
    xlim([min(tempTime) max(tempTime)]);
    
    
    if plot_spectogram == 1;
    %% plot power spectrum
    minfreq = str2double(get(handles.minfreq, 'String'));
    maxfreq = str2double(get(handles.maxfreq, 'String'));
    
    data    = peekdata(ai,fft_l);
    fft_selection = sum(analog_channels_on);
    plot_counter = 0;
    for ichan = 1:8
        if analog_channels_on(ichan)
            L       = length(data(:,ichan));
            NFFT    = 2^nextpow2(L);
            Yo      = fft(data(:,ichan)-mean(data(:,ichan)),NFFT)/NFFT;
            fo      = Fs/2*linspace(0,1,NFFT/2+1);
            spectraldata = 2*abs(Yo(1:NFFT/2+1));
            freqindex1 = find(fo>=minfreq,1);
            freqindex2 = find(fo>=maxfreq,1);
            plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(fft_selection-plot_counter)/10, 'Color', plotColors(ichan,:)); hold(handles.axes2,'on')
            plot_counter = plot_counter + 1;
        end
    end
    
    drawnow; hold(handles.axes2,'off');
     
    end
    
    if plot_neurofeedback == 1 %start plot neurofeedback
       
        feedback_channel = str2num(handles.feedback_channel.String);
        freq_range1 = str2num(handles.freq_range1.String);
        freq_range2 = str2num(handles.freq_range2.String);
        freq_range3 = str2num(handles.freq_range3.String);
        freq_range4 = str2num(handles.freq_range4.String);
        
        for ichan=feedback_channel
                if analog_channels_on(ichan)
                    L       = length(data(:,ichan));
                    NFFT    = 2^nextpow2(L);
                    Yo      = fft(data(:,ichan)-mean(data(:,ichan)),NFFT)/NFFT;
                    fo      = Fs/2*linspace(0,1,NFFT/2+1);
         
                    selection_range1 = find(fo>freq_range1(1) & fo<freq_range1(2));
                    power_range1= mean(2*abs(Yo(selection_range1)));
                    selection_range2 = find(fo>freq_range2(1) & fo<freq_range2(2));
                    power_range2= mean(2*abs(Yo(selection_range2)));
                    selection_range3 = find(fo>freq_range3(1) & fo<freq_range3(2));
                    power_range3= mean(2*abs(Yo(selection_range3)));
                    selection_range4 = find(fo>freq_range4(1) & fo<freq_range4(2));
                    power_range4= mean(2*abs(Yo(selection_range4)));
                
                    %x = [Range1 Range2 Range3 Range4];
                   
                    name = {'Range 1';'Range 2';'Range 3';'Range 4'};
                    feedback_plot = [power_range1 power_range2 power_range3 power_range4];
                    bar(handles.axes2,feedback_plot);
                    set(handles.axes2,'xticklabel',name);
                    %ylim([0 0.000005]);

                end
            end
    
            drawnow; hold(handles.axes2,'off')
        
        
        
    end %plot neurofeedback
    
end

if manualstop == 0
    stop(ai);
end

if save_mem || save_diskmem
    data = getdata(ai, ai.SamplesAcquired);
elseif save_disk
    data = daqread(ai.LogFileName);
end

[~, nrofchans] = size(data);
chan_space = chan_space_Callback([],[],handles);
a = linspace(-chan_space,chan_space,num_chan);
b=sort(a,'descend');
for k=1:nrofchans
    if k<9
        plot(handles.axes1,data(:,k)+b(k),'Color', plotColors(k,:)); hold(handles.axes1,'on')
    else
        plot(handles.axes1,data(:,k)./5000+b(k),'k'); hold(handles.axes1,'on')
    end
end
legend(handles.axes1, channelLabels(channel_selection));
grid(handles.axes1,'on')
drawnow; hold(handles.axes1,'off');
% end
a = linspace(-chan_space,chan_space,8);
disp('Plotting data')
plot_counter = 0;
for ichan = 1:8
    L=length(data(:,ichan));
    NFFT = 2^nextpow2(L);
    Yo = fft(data(:,ichan)-mean(data(:,ichan)),NFFT)/NFFT;
    fo = Fs/2*linspace(0,1,NFFT/2+1);
    spectraldata = 2*abs(Yo(1:NFFT/2+1));
    freqindex1 = find(fo>=minfreq,1);
    freqindex2 = find(fo>=maxfreq,1);
    plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+b(ichan)/10, 'Color', plotColors(ichan,:)),hold(handles.axes2,'on')
    plot_counter = plot_counter + 1;
end

grid(handles.axes1,'on')
drawnow; hold(handles.axes2,'off');
set(handles.start_recording, 'Enable','on')
        for i = 1:length(handles.TTL_panel.Children)
            set(handles.TTL_panel.Children(i),'Enable','on')
        end
if manualstop == 0
    delete(ai)
    clear ai
    disp('Acquisition object cleared')
    disp(['Recording ended at: '  datestr(now)])
    disp(['Recorded ' num2str(length(data)/256) ' seconds of data'])
    disp('---------------------------------Stop--------------------------------------')
    set(handles.stop_recording, 'Enable','off')
    set(handles.start_recording, 'Enable','on')
    for i = 1:length(handles.TTL_panel.Children)
        set(handles.TTL_panel.Children(i),'Enable','on')
    end
    set(handles.clear, 'Enable','on')
end
handles.data = data;
guidata(hObject, handles);

function set_dio_Callback(hObject, eventdata, handles)
Config_dio

function inspect_filter_Callback(hObject, eventdata, handles)
global nbr;global ai;
nbr = 16;
daqinfo = daqhwinfo('gmlplusdaq');
comport = str2double(daqinfo.InstalledBoardIds{1});
ai = analoginput('gmlplusdaq',comport); addchannel(ai,1:nbr);
for k=1:nbr
    get(ai.Channel(nbr))
end
delete(ai)
clear ai

function chan_space = chan_space_Callback(hObject, eventdata, handles)
chan_space = str2double(get(handles.chan_space, 'String'))/1000;
return

function chan_space_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function fft_ll_Callback(hObject, eventdata, handles)
global fft_l
fft_l = str2double(get(hObject,'String'));
return

function fft_ll_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function Test_mode_on_Callback(hObject, eventdata, handles)
global Test_mode_on
if (get(hObject,'Value') == get(hObject,'Max'))
    Test_mode_on =1;
else
    Test_mode_on =0;
end
return

function save_SD_on_Callback(hObject, eventdata, handles)
global save_SD_on
if (get(hObject,'Value') == get(hObject,'Max'))
    save_SD_on =1;
else
    save_SD_on =0;
end
return

function clear_Callback(hObject, eventdata, handles)
global ai
global data
data = [];
clear data
delete(ai)
clear ai
cla(handles.axes1,'reset')
cla(handles.axes2,'reset')
set(handles.start_recording, 'Enable','on')
for i = 1:length(handles.TTL_panel.Children)
    set(handles.TTL_panel.Children(i), 'Enable','on')
end

% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
Fs = 256;
chan_space = chan_space_Callback([],[],handles);
plotColors = handles.plotColors;

cd(handles.dir.data)
[filename, pathname] = uigetfile({'*.mat';},'Select file');
cd(handles.dir.main)
if any(filename)
    load([pathname filename]);
    handles.data = data;
    if size(data,3) > 1
        warndlg('You are trying to load 3D data, the EEG_recorder is not able to display this.')
    else
        [nrofsamples, nrofchans] = size(data);
        a = linspace(-chan_space,chan_space,nrofchans);
        t = (1:nrofsamples)/Fs;
        for ichan=1:nrofchans
            b=sort(a,'descend');
            if ichan<9
                plot(handles.axes1,t,data(:,ichan)+b(ichan), 'Color', plotColors(ichan,:)); hold(handles.axes1,'on')
            else
                plot(handles.axes1,t,data(:,ichan)./10000+b(ichan),'k'); hold(handles.axes1,'on')
            end
        end
        grid(handles.axes1,'on')
        handles.axes1.XLabel.String = 'times (s)';
        drawnow; hold(handles.axes1)
        % end
        
        minfreq = str2double(get(handles.minfreq, 'String'));
        maxfreq = str2double(get(handles.maxfreq, 'String'));
        
        for ichan = 1:8
            L       = length(data(:,ichan));
            NFFT    = 2^nextpow2(L);
            Yo      = fft(data(:,ichan)-mean(data(:,ichan)),NFFT)/NFFT;
            fo      = Fs/2*linspace(0,1,NFFT/2+1);
            spectraldata = 2*abs(Yo(1:NFFT/2+1));
            freqindex1 = find(fo>=minfreq,1);
            freqindex2 = find(fo>=maxfreq,1);
            plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)-a(ichan)/10,'Color',plotColors(ichan,:)),hold(handles.axes2,'on')
        end
        
        drawnow; hold(handles.axes2,'off');
        set(handles.clear, 'Enable','on');
        for i = 1:length(handles.TTL_panel.Children)
            set(handles.TTL_panel.Children(i),'Enable','on')
        end
    end
    
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
data = handles.data;
cd(handles.dir.data);
uisave({'data'},'Name');
cd(handles.dir.main);
% --------------------------------------------------------------------
function tools_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
web('Help EEG recorder.html', '-helpbrowser')
% --------------------------------------------------------------------
function about_Callback(hObject, eventdata, handles)
web('About EEG recorder.htm', '-helpbrowser')
% --------------------------------------------------------------------
function Array_manipulator_Callback(hObject, eventdata, handles)
Array_manipulator(handles)
% --------------------------------------------------------------------
function Spectral_analysis_Callback(hObject, eventdata, handles)
Spectral_analysis(handles)
% --------------------------------------------------------------------
function ERP_tool_Callback(hObject, eventdata, handles)
ERP_tool(handles)
% --------------------------------------------------------------------
function Data_plotter_Callback(hObject, eventdata, handles)
Data_plotter(handles)
% --------------------------------------------------------------------
function Event_cutter_Callback(hObject, eventdata, handles)
Event_cutter(handles)
% --------------------------------------------------------------------
function TrialBrowser_Callback(hObject, eventdata, handles)
TrialBrowser(handles)
% --------------------------------------------------------------------

function prev_t_Callback(hObject, eventdata, handles)
global preview
preview = str2double(get(hObject,'String'));
return

function prev_t_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function filter_Callback(hObject, eventdata, handles)
vers = version('-release');
vers = str2double(vers(1:4));
if vers <= 2015
    opts.WindowStyle = 'non-modal'; 
    opts.Interpreter = 'tex';
    msg = 'A newer version of this function is avalaibe in Matlab 2016a or later';
    warndlg(['\fontsize{18}' msg],'Update available in newer Matlab version',opts)  
    fprintf([msg '\n'])
    filters(handles)
    
elseif vers > 2015
    Filter_tool
end


function Syllabus_Callback(hObject, eventdata, handles)
web('Syllabus.htm', '-helpbrowser')


% --- Executes during object creation, after setting all properties.
function maxfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to maxfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes during object creation, after setting all properties.
function minfreq_CreateFcn(hObject, eventdata, handles)
% hObject    handle to minfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --------------------------------------------------------------------
function File_Callback(hObject, eventdata, handles)
% hObject    handle to File (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Info_Callback(hObject, eventdata, handles)
% hObject    handle to Info (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function TF_analysis_Callback(hObject, eventdata, handles)
TF_Analysis(handles)
% hObject    handle to TF_analysis (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function recover_data_Callback(hObject, eventdata, handles)
% hObject    handle to recover_data (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
cd(handles.dir.backup);
[filename, pathname] = uigetfile({'*.daq';},'Select a 2D array');
cd(handles.dir.main);

plotColors = handles.plotColors;
try
    if any(filename)
        Fs = 256;
        data=daqread([pathname filename]);
        handles.data = data;
        [a,b] = size(data);
        fprintf('backup file recoverd: \n\t%s%s\nthe file consists of:\n\t%d samples, or %.2f seconds of data\n\t%d channels\n', pathname, filename, a,a/Fs,b)
        
        [nrofsamples, nrofchans] = size(data);
        chan_space = chan_space_Callback([],[],handles);
        a = linspace(chan_space,-chan_space,nrofchans);
        b = sort(a, 'descend');
        t = (1:nrofsamples)/Fs;
        for ichan=1:nrofchans
            if ichan<9
                plot(handles.axes1,t,data(:,ichan)+b(ichan),'Color',plotColors(ichan,:)); hold(handles.axes1,'on')
            else
                plot(handles.axes1,t,data(:,ichan)./10000+b(ichan),'k'); hold(handles.axes1,'on')
            end
        end
        grid(handles.axes1,'on')
        handles.axes1.XLabel.String = 'times (s)';
        drawnow; hold(handles.axes1)
        % end
        
        minfreq = str2double(get(handles.minfreq, 'String'));
        maxfreq = str2double(get(handles.maxfreq, 'String'));
        
        for ichan = 1:8
            L       = length(data(:,ichan));
            NFFT    = 2^nextpow2(L);
            Yo      = fft(data(:,ichan)-mean(data(:,ichan)),NFFT)/NFFT;
            fo      = Fs/2*linspace(0,1,NFFT/2+1);
            spectraldata = 2*abs(Yo(1:NFFT/2+1));
            freqindex1 = find(fo>=minfreq,1);
            freqindex2 = find(fo>=maxfreq,1);
            plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+b(ichan)/10,'Color', plotColors(ichan,:)),hold(handles.axes2,'on')
        end
        
        drawnow; hold(handles.axes2,'off');
        set(handles.clear, 'Enable','on');
    end
    guidata(hObject, handles);
catch ME
    errordlg('Some unexpected error occurred. Unable to recover the backup data.');
    rethrow(ME);
end



function channel_1_CreateFcn(hObject, eventdata, handles)

function status = channel_1_Callback(hObject, eventdata, handles)
status = handles.channel_1.Value;
function status = channel_2_Callback(hObject, eventdata, handles)
status = handles.channel_2.Value;
function status = channel_3_Callback(hObject, eventdata, handles)
status = handles.channel_3.Value;
function status = channel_4_Callback(hObject, eventdata, handles)
status = handles.channel_4.Value;
function status = channel_5_Callback(hObject, eventdata, handles)
status = handles.channel_5.Value;
function status = channel_6_Callback(hObject, eventdata, handles)
status = handles.channel_6.Value;
function status = channel_7_Callback(hObject, eventdata, handles)
status = handles.channel_7.Value;
function status = channel_8_Callback(hObject, eventdata, handles)
status = handles.channel_8.Value;

function status = ch9_on_Callback(hObject, eventdata, handles)
status = handles.ch9_on.Value;
function status = ch10_on_Callback(hObject, eventdata, handles)
status = handles.ch10_on.Value;
function status = ch11_on_Callback(hObject, eventdata, handles)
status = handles.ch11_on.Value;
function status = ch12_on_Callback(hObject, eventdata, handles)
status = handles.ch12_on.Value;
function status = ch13_on_Callback(hObject, eventdata, handles)
status = handles.ch13_on.Value;
function status = ch14_on_Callback(hObject, eventdata, handles)
status = handles.ch14_on.Value;


function ch9_on_CreateFcn(hObject, eventdata, handles)

function ch10_on_CreateFcn(hObject, eventdata, handles)

function ch11_on_CreateFcn(hObject, eventdata, handles)

function ch12_on_CreateFcn(hObject, eventdata, handles)

function ch13_on_CreateFcn(hObject, eventdata, handles)

function ch14_on_CreateFcn(hObject, eventdata, handles)

function TTL1_Callback(hObject, eventdata, handles)

function TTL2_Callback(hObject, eventdata, handles)

function TTL3_Callback(hObject, eventdata, handles)

function TTL4_Callback(hObject, eventdata, handles)

function TTL5_Callback(hObject, eventdata, handles)

function TTL6_Callback(hObject, eventdata, handles)

function maxfreq_Callback(hObject, eventdata, handles)

function minfreq_Callback(hObject, eventdata, handles)

function axes1_CreateFcn(hObject, eventdata, handles)
hObject.Title.String = 'Recorded Signal';
hObject.Title.FontSize = 14;
hObject.Title.FontWeight = 'bold';
hObject.XLim = [0 4];
hObject.XTick = 0:.5:4;
hObject.XLabel.String = 'time (s)';
hObject.YTick = [];
hObject.YLabel.String = 'Voltage';

function axes2_CreateFcn(hObject, eventdata, handles)
hObject.Title.String = 'Powerspectrum (FFT)';
hObject.Title.FontSize = 14;
hObject.Title.FontWeight = 'bold';
hObject.XLim = [.1 128];
hObject.XLabel.String = 'Frequency (Hz)';
hObject.YTick = [];
hObject.YLabel.String = 'Power';



% --------------------------------------------------------------------
function ECG_Tool_Callback(hObject, eventdata, handles)
ECG_Tool(handles)

function ReplayData_Callback(hObject, eventdata, handles)
ReplayData(handles)

function artGui_Callback(hObject, eventdata, handles)
artGui(handles)

function Cutting_tool_Callback(hObject, eventdata, handles)
Cutting_tool(handles)
%%% When new version is implemented %%%
% vers = version('-release');
% vers = str2double(vers(1:4));
% if vers <= 2015
%     opts.WindowStyle = 'non-modal'; 
%     opts.Interpreter = 'tex';
%     msg = '\fontsize{18} A newer version of this function is avalaibe in Matlab version 2016a or later';
%     warndlg(msg,'Latest vesrion unavailable in this Matlab version',opts)  
%     Cutting_tool(handles)
% elseif vers > 2015
%     Cutting_tool_App
% end


function Import_data_Callback(hObject, eventdata, handles)
vers = version('-release');
vers = str2double(vers(1:4));
if vers <= 2015
    opts.WindowStyle = 'non-modal'; 
    opts.Interpreter = 'tex';
    msg = 'This function is only avalaibe in Matlab version 2016a or later';
    warndlg(['\fontsize{18}' msg],'Function unavailable in this Matlab version',opts)  
    fprintf([msg '\n'])
    return
elseif vers > 2015
    Import_tool
end

% --- Executes on button press in spectogram.
function spectogram_Callback(hObject, eventdata, handles)
global plot_spectogram
plot_spectogram = get(hObject,'Value');

% --- Executes on button press in neurofeedback.
function neurofeedback_Callback(hObject, eventdata, handles)
global plot_neurofeedback
plot_neurofeedback = get(hObject,'Value');

function freq_range1_Callback(hObject, eventdata, handles)
% hObject    handle to freq_range1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function freq_range1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq_range1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function freq_range2_Callback(hObject, eventdata, handles)
% hObject    handle to freq_range2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function freq_range2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq_range2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function freq_range3_Callback(hObject, eventdata, handles)
% hObject    handle to freq_range3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function freq_range3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq_range3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function freq_range4_Callback(hObject, eventdata, handles)
% hObject    handle to freq_range4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function freq_range4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq_range4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function feedback_channel_Callback(hObject, eventdata, handles)
% hObject    handle to feedback_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function feedback_channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to feedback_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
