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
handles.dir.main = cd; % save path to main directory
if ~(exist([cd filesep 'Backup'],'dir')==7) % create 'Backup' directory if necessary
    mkdir('Backup')
    fprintf('created Backup directory\n')
end
if ~(exist([cd filesep 'Data'],'dir')==7) % create 'Backup' directory if necessary
    mkdir('Data');
    fprintf('created Data directory\n')
end
% add subdirectories
handles.dir.backup   = [handles.dir.main filesep 'Backup'];
handles.dir.data     = [handles.dir.main filesep 'Data'];
handles.dir.functions = [handles.dir.main filesep 'Functions'];
addpath(handles.dir.backup, genpath(handles.dir.data), genpath(handles.dir.functions));

handles.output = hObject;
guidata(hObject, handles);

function varargout = EEG_recorder_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
set(gcf, 'units','normalized','outerposition',[0 0 1 1]); % maximize screen
if strcmp(computer, 'PCWIN64')
    bitwarning = sprintf([...
        'You are running a 64-bit version of MATLAB.\n' ...
        'Recording is currently only available in 32-bit MATLAB.\n' ...
        'Data analysis tools are available in both versions.\n'...
        ]);
    warndlg(bitwarning);
    fprintf(['\nWARNING:\n' bitwarning '\n']);
    set(handles.start_recording, 'Enable','off');
    fprintf('Welcome to the EEG recorder!\n')
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

if save_disk == 1 || save_diskmem == 1
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
pause(.1);
global dur_aq
global Fs
global num_chan
global data; data = [];
global chan_space
global fft_l
global preview
global ai
global manualstop

mainDir = handles.dir.main;

handles.wb = waitbar(0);
try
    waitbar(.1,handles.wb,'terminate any running recordings');
    ai = daqfind;
    if ~isempty(ai)
        stop(ai)
    end
    
    waitbar(.2,handles.wb,'setting viewing parameters');
    for ichan = 1:8
        eval(['chan' num2str(ichan) ' = get(handles.channel_' num2str(ichan) ', ''Value'');'])
    end
    for ichan = [9 10 12 13 14 15]
        eval(['chan' num2str(ichan) ' = get(handles.ch' num2str(ichan) '_on , ''Value'');'])
    end
  
    fprintf('setting viewing parameters\n')
    dur_aq      = str2double(get(handles.dur_aq,'String'));
    Fs          = str2double(get(handles.Fs_vak,'String'));
    % chan_space      = str2double(get(handles.chan_space,'String'));
    fft_l       = str2double(get(handles.fft_ll,'String'));
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
    global FileName
    if (get(handles.save_disk, 'Value') == get(handles.save_disk, 'Max'))
        save_disk           = 1;
        ai.LoggingMode      = 'Disk';
        ai.LogToDiskMode    = 'Index';
        ai.LogFileName      = [handles.dir.main '\Backup\backup_' datestr(now,'ddmmyyyy_HHMM')];
    else
        save_disk = 0;
    end
    global save_diskmem
    if (get(handles.save_diskmem, 'Value') == get(handles.save_diskmem, 'Max'))
        save_diskmem        = 1;
        ai.LoggingMode      = 'Disk&Memory';
        ai.LogToDiskMode    = 'Index';
        ai.LogFileName      = [handles.dir.main '\Backup\backup_' datestr(now,'ddmmyyyy_HHMM')];
    else
        save_diskmem = 0;
    end
    
    %% add channels to recording object
    % always record the eight EEG channels
    addchannel(ai,1:8);
    num_chan = 8;
    
    % check which DIO channels are activated
    for ichan = [9 10 12 13 14 15]
        if eval(['chan' num2str(ichan) ]) == 1; addchannel(ai,ichan);  num_chan = num_chan+1; end
    end
      
    analog_channels_on = [chan1 chan2 chan3 chan4...
        chan5 chan6 chan7 chan8];
    digital_channels_on = [chan9 chan10 chan12 chan13 chan14 chan15];
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
    data = zeros(preview,num_chan_plot);
    data(1:tempSample,:) = tempData;
    digicounter  = 0;
    chan_space = str2double(get(handles.chan_space,'String'))/1000;
    a = linspace(-chan_space,chan_space,num_chan_plot);
    b=sort(a,'descend');
    
    %% plot live signal
    for ichan=1:num_chan_plot
        if channel_selection(ichan)<9
            plot(handles.axes1,tempTime,data(:,channel_selection(ichan))+b(ichan),'b'); hold(handles.axes1,'on')
        else
            digicounter = digicounter + 1;
            plot(handles.axes1,tempTime,data(:,(8+digicounter))./100000+b(ichan),'r'); hold(handles.axes1,'on')
        end
    end
    grid(handles.axes1,'on');
    drawnow; hold(handles.axes1,'off');
    xlim([min(tempTime) max(tempTime)]);
    
    
    %% plot power spectrum
    minfreq = str2double(get(handles.minfreq, 'String'));
    maxfreq = str2double(get(handles.maxfreq, 'String'));
    
    data    = peekdata(ai,fft_l);
    fft_selection = length(find(channels_on(1:8)));
    plot_counter = 0;
    for ichan = 1:8
        if eval(['chan' num2str(ichan)])
            L       = length(data(:,ichan));
            NFFT    = 2^nextpow2(L);
            Yo      = fft(data(:,ichan)-mean(data(:,ichan)),NFFT)/NFFT;
            fo      = Fs/2*linspace(0,1,NFFT/2+1);
            spectraldata = 2*abs(Yo(1:NFFT/2+1));
            freqindex1 = find(fo>=minfreq,1);
            freqindex2 = find(fo>=maxfreq,1);
            plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(fft_selection-plot_counter)/10,'r'),hold(handles.axes2,'on')
            plot_counter = plot_counter + 1;
        end
    end
    
    drawnow; hold(handles.axes2,'off');
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

chan_space = str2double(get(handles.chan_space, 'String'))/1000;
a = linspace(-chan_space,chan_space,num_chan);
b=sort(a,'descend');
for k=1:nrofchans
    if k<9
        plot(handles.axes1,data(:,k)+b(k),'b'); hold(handles.axes1,'on')
    else
        plot(handles.axes1,data(:,k)./10000+b(k),'r'); hold(handles.axes1,'on')
    end
end
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
    plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(ichan)/10,'r'),hold(handles.axes2,'on')
    plot_counter = plot_counter + 1;
end

grid(handles.axes1,'on')
drawnow; hold(handles.axes2,'off');
set(handles.start_recording, 'Enable','on')
if manualstop == 0
    delete(ai)
    clear ai
    disp('Acquisition object cleared')
    disp(['Recording ended at: '  datestr(now)])
    disp(['Recorded ' num2str(length(data)/256) ' seconds of data'])
    disp('---------------------------------Stop--------------------------------------')
    set(handles.stop_recording, 'Enable','off')
    set(handles.start_recording, 'Enable','on')
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

function chan_space_Callback(hObject, eventdata, handles)
global chan_space
chan_space = str2double(get(hObject,'String'));
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
% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
% global data
global dur_aq
dur_aq = str2double(get(handles.dur_aq,'String'));
global Fs
Fs = str2double(get(handles.Fs_vak,'String'));
global chan_space
chan_space = str2double(get(handles.chan_space,'String'))/10000;
global fft_l
fft_l = str2double(get(handles.fft_l,'String'));
global preview
preview = str2double(get(handles.prev_t,'String'));
cd(handles.dir.data)
[filename, pathname] = uigetfile({'*.mat';},'Select file');
cd(handles.dir.main)
if any(filename)
    load([pathname filename]);
    handles.data = data;
    if size(data,3) > 1
        warndlg('You are trying to load 3D data, the EEG_recorder is not able to display this.')
    else
        [~, nrofchans] = size(data);
        a = linspace(-chan_space,chan_space,nrofchans);
        
        for ichan=1:nrofchans
            b=sort(a,'descend');
            if ichan<9
                plot(handles.axes1,data(:,ichan)+b(ichan),'b'); hold(handles.axes1,'on')
            else
                plot(handles.axes1,data(:,ichan)./10000+b(ichan),'r'); hold(handles.axes1,'on')
            end
        end
        grid(handles.axes1,'on')
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
            plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)-a(ichan)/10,'r'),hold(handles.axes2,'on')
        end
        
        drawnow; hold(handles.axes2,'off');
        set(handles.clear, 'Enable','on');
    end
    
end
guidata(hObject, handles);

% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
global data;
cd(handles.dir.data);
uisave({'data'},'Name');
cd(handles.dir.main);
% --------------------------------------------------------------------
function tools_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
web('Help EEG recorder.htm', '-helpbrowser')
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
function Data_plotter_Callback(hObject, eventdata, handles)
Data_plotter(handles)
% --------------------------------------------------------------------
function Event_cutter_Callback(hObject, eventdata, handles)
Event_cutter(handles)

function prev_t_Callback(hObject, eventdata, handles)
global preview
preview = str2double(get(hObject,'String'));
return

function prev_t_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function filter_Callback(hObject, eventdata, handles)
filters(handles)

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
