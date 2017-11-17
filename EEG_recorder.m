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

% Last Modified by Eva van Poppel v4.2 08-April-2015 10:49:36

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
handles.output = hObject;
guidata(hObject, handles);
set(handles.start_recording, 'Enable','on');
set(handles.stop_recording, 'Enable','off');
set(handles.clear, 'Enable','off');
curdir = cd;
if ~(exist('Backup','dir')==7)
    mkdir('Backup')
end
addpath([curdir filesep 'Backup']);
if ~(exist('Data','dir')==7)
    mkdir('Data');
    addpath([curdir filesep 'Data']);
end
addpath(genpath([curdir filesep 'Functions']));

function varargout = EEG_recorder_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
fprintf('powering up...\n')
set(gcf, 'units','normalized','outerposition',[0 0.03 1 .97]); % maximize screen
fprintf('Welcome to the EEG recorder!\n')

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
    %     delete(ai)
    %     clear ai
end

if save_disk == 1 || save_diskmem == 1
    if exist(FileName,'file')==2
        data = daqread(FileName);
    else
        fprintf('no data to backup')
    end
end
disp(['Recorded ' num2str(length(data)/256) ' seconds of data'])
disp(['Recording ended at: '  datestr(now)])
disp('---------------------------------Stop--------------------------------------')
set(handles.start_recording,'Enable','on');
set(handles.dur_aq,'Enable','on');
% data = getdata(ai);
% if (~isempty(daqfind))
%     stop(daqfind)
% end
% delete(ai)
% clear ai

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
set(handles.start_recording, 'Enable','off')
set(handles.clear, 'Enable','off')
set(handles.stop_recording,'Enable','on')
set(handles.dur_aq,'Enable','off');
global dur_aq
global Fs
global num_chan
global data; data = [];
global chan_d
global fft_l
global preview
global ai
global manualstop
global ch9_on; global ch10_on; global ch11_on;
global ch12_on; global ch13_on; global ch14_on;
global ch15_on; global ch16_on;
% global ch12_out;global ch12_out_on
% global ch13_out;global ch13_out_on
% global ch14_out;global ch14_out_on
% global ch15_out;global ch15_out_on
global channel_1
global channel_2
global channel_3
global channel_4
global channel_5
global channel_6
global channel_7
global channel_8

ai = daqfind;
if ~isempty(ai)
    stop(ai)
end

if get(handles.channel_1, 'Value') == get(handles.channel_1, 'Max')
    channel_1 = 1;
else
    channel_1 = 0;
end
if get(handles.channel_2, 'Value') == get(handles.channel_2, 'Max')
    channel_2 = 1;
else
    channel_2 = 0;
end
if get(handles.channel_3, 'Value') == get(handles.channel_3, 'Max')
    channel_3 = 1;
else
    channel_3 = 0;
end
if get(handles.channel_4, 'Value') == get(handles.channel_4, 'Max')
    channel_4 = 1;
else
    channel_4 = 0;
end
if get(handles.channel_5, 'Value') == get(handles.channel_5, 'Max')
    channel_5 = 1;
else
    channel_5 = 0;
end
if get(handles.channel_6, 'Value') == get(handles.channel_6, 'Max')
    channel_6 = 1;
else
    channel_6 = 0;
end
if get(handles.channel_7, 'Value') == get(handles.channel_7, 'Max')
    channel_7 = 1;
else
    channel_7 = 0;
end
if get(handles.channel_8, 'Value') == get(handles.channel_8, 'Max')
    channel_8 = 1;
else
    channel_8 = 0;
end
if get(handles.ch9_on, 'Value') == get(handles.ch9_on, 'Max')
    ch9_on = 1;
else
    ch9_on = 0;
end
if get(handles.ch10_on, 'Value') == get(handles.ch10_on, 'Max')
    ch10_on = 1;
else
    ch10_on = 0;
end
if get(handles.ch12_on, 'Value') == get(handles.ch12_on, 'Max')
    ch12_on = 1;
else
    ch12_on = 0;
end
if get(handles.ch13_on, 'Value') == get(handles.ch13_on, 'Max')
    ch13_on = 1;
else
    ch13_on = 0;
end
if get(handles.ch14_on, 'Value') == get(handles.ch14_on, 'Max')
    ch14_on = 1;
else
    ch14_on = 0;
end
if get(handles.ch15_on, 'Value') == get(handles.ch15_on, 'Max')
    ch15_on = 1;
else
    ch15_on = 0;
end
fprintf('getting recording settings \n')
dur_aq      = str2double(get(handles.dur_aq,'String'));
Fs          = str2double(get(handles.Fs_vak,'String'));
chan_d      = str2double(get(handles.chan_d,'String'));
fft_l       = str2double(get(handles.fft_ll,'String'));
preview     = str2double(get(handles.prev_t,'String'));
manualstop  = 0;


% global ana_only_on
% if (get(handles.ana_only_on,'Value') == get(handles.ana_only_on,'Max'))
%     ana_only_on =1;
% else
%     ana_only_on =0;
% end



global save_SD_on
if (get(handles.save_SD_on,'Value') == get(handles.save_SD_on,'Max'))
    save_SD_on =1;
else
    save_SD_on =0;
end
fprintf('connecting to recording device \n')
daqinfo = daqhwinfo('gmlplusdaq');
if isempty(daqinfo.InstalledBoardIds)
    errordlg(sprintf(['Unable to connect to the recording device. Make sure that:\n' ...
    '- the device is plugged in \n- the device is turned on\n' ... 
    '- the device is ready (green light blinking)\n- the drivers are installed correctly']))
    set(handles.start_recording, 'Enable','on');
    set(handles.stop_recording, 'Enable','off');
    set(handles.clear, 'Enable','off');
    return
end
comport = str2double(daqinfo.InstalledBoardIds{1});

ai = analoginput('gmlplusdaq',comport);

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
    ai.LogFileName      = [curdir '\backup\backup' datestr(now,'yyyymmddTHHMM')];
else
    save_disk = 0;
end
global save_diskmem
if (get(handles.save_diskmem, 'Value') == get(handles.save_diskmem, 'Max'))
    save_diskmem        = 1;
    ai.LoggingMode      = 'Disk&Memory';
    ai.LogToDiskMode    = 'Index';
    ai.LogFileName      = [curdir '\backup\backup' datestr(now,'yyyymmddTHHMM')];
else
    save_diskmem = 0;
end
addchannel(ai,1:8);
% if ana_only_on == 1
% num_chan = 8;
% else
num_chan = 8;
if ch9_on == 1
    addchannel(ai,9);
    num_chan = num_chan+1;
end
if ch10_on == 1
    addchannel(ai,10);
    num_chan = num_chan+1;
end
if ch11_on == 1
    addchannel(ai,11);
    num_chan = num_chan+1;
end
if ch12_on == 1
    addchannel(ai,12);
    num_chan = num_chan+1;
    %         if ch12_out_on == 1
    %             set(ai,'DIO1direction','Out');
    %             eval(ch12_out)
    %         else
    %             set(ai,'DIO1direction','In');
    %         end
end
if ch13_on == 1
    addchannel(ai,13);
    num_chan = num_chan+1;
    %         if ch13_out_on == 1
    %             set(ai,'DIO2direction','Out');
    %             eval(ch13_out)
    %         else
    %             set(ai,'DIO2direction','In');
    %         end
end
if ch14_on == 1
    addchannel(ai,14);
    num_chan = num_chan+1;
    %         if ch14_out_on == 1
    %             set(ai,'DIO3direction','Out');
    %             eval(ch14_out)
    %         else
    %             set(ai,'DIO3direction','In');
    %         end
end
if ch15_on == 1
    addchannel(ai,15);
    num_chan = num_chan+1;
    %         if ch15_out_on == 1
    %             set(ai,'DIO4direction','Out');
    %             eval(ch15_out)
    %         else
    %             set(ai,'DIO4direction','In');
    %         end
end
if ch16_on == 1
    addchannel(ai,16);
    num_chan = num_chan+1;
end
% end
analog_channels_on = [channel_1 channel_2 channel_3 channel_4...
    channel_5 channel_6 channel_7 channel_8];
digital_channels_on = [ch9_on ch10_on ch12_on ch13_on ch14_on ch15_on ch16_on];
num_dig_chan = length(find(digital_channels_on));

channels_on = [analog_channels_on digital_channels_on];

channel_selection = find(channels_on);
num_chan_plot = length(channel_selection);

fprintf('nr of channels: %d \n', num2str(num_chan));
set(ai,'SamplesPerTrigger',dur_aq*Fs);
global a
chan_d = chan_d / 10000;
a = linspace(-chan_d,chan_d,num_chan_plot);

for k = 1:num_chan_plot
    plot(handles.axes1,zeros(preview,1)+a(k),'b'); hold(handles.axes1,'on')
end
hold(handles.axes1,'off')

disp('---------------------------------Start-------------------------------------')
fprintf(['Recording started at: \n' datestr(now)])
start(ai)

while ai.SamplesAcquired <= preview && manualstop == 0
    %Wait for samples
end
ai.SamplesAcquired;
while ai.SamplesAcquired < dur_aq * Fs  && manualstop == 0
    data = peekdata(ai,preview);
    [k1 k2] = size(data);
    %         b = wrev(a);
    digicounter  = 0;
    b=sort(a,'descend');
    for k=1:num_chan_plot
        if channel_selection(k)<9
            plot(handles.axes1,data(:,channel_selection(k))+b(k),'b'); hold(handles.axes1,'on')
        else
            digicounter = digicounter + 1;
            plot(handles.axes1,data(:,(8+digicounter))./100000+b(k),'r'); hold(handles.axes1,'on')
        end
        %         set(handles.axes1, 'Ylim', [min(b)-0.001  max(b)+.001])
    end
    grid(handles.axes1,'on')
    drawnow; hold(handles.axes1,'off')
    %     end
    
    minfreq = str2double(get(handles.minfreq, 'String'));
    maxfreq = str2double(get(handles.maxfreq, 'String'));
    
    data    = peekdata(ai,fft_l);
    fft_selection = length(find(channels_on(1:8)));
    plot_counter = 0;
    for ichan = 1:8
        if eval(['channel_' num2str(ichan)])
            L       = length(data(:,ichan));
            NFFT    = 2^nextpow2(L);
            Yo      = fft(data(:,ichan)-mean(data(:,ichan)),NFFT)/L;
            fo      = Fs/2*linspace(0,1,NFFT/2+1);
            spectraldata = 2*abs(Yo(1:NFFT/2+1));
            freqindex1 = find(fo>=minfreq,1);
            freqindex2 = find(fo>=maxfreq,1);
            plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(fft_selection-plot_counter)/10,'r'),hold(handles.axes2,'on')
            plot_counter = plot_counter + 1;
        end
    end
    
%     if channel_1
%         L       = length(data(:,1));
%         NFFT    = 2^nextpow2(L);
%         Yo      = fft(data(:,1),NFFT)/L;
%         fo      = Fs/2*linspace(0,1,NFFT/2+1);
%         spectraldata = 2*abs(Yo(1:NFFT/2+1));
%         freqindex1 = find(fo>=minfreq,1);
%         freqindex2 = find(fo>=maxfreq,1);
%         plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(fft_selection-plot_counter)/10,'r'),hold(handles.axes2,'on')
%         plot_counter = plot_counter + 1;
%     end
%     if channel_2
%         L       = length(data(:,2));
%         NFFT    = 2^nextpow2(L);
%         Yo      = fft(data(:,2),NFFT)/L;
%         fo      = Fs/2*linspace(0,1,NFFT/2+1);
%         spectraldata = 2*abs(Yo(1:NFFT/2+1));
%         freqindex1 = find(fo>=minfreq,1);
%         freqindex2 = find(fo>=maxfreq,1);
%         plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(fft_selection-plot_counter)/10,'r'); hold(handles.axes2,'on')
%         plot_counter = plot_counter + 1;
%     end
%     if channel_3
%         L=length(data(:,3));
%         NFFT = 2^nextpow2(L);
%         Yo = fft(data(:,3),NFFT)/L;
%         fo = Fs/2*linspace(0,1,NFFT/2+1);
%         spectraldata = 2*abs(Yo(1:NFFT/2+1));
%         freqindex1 = find(fo>=minfreq,1);
%         freqindex2 = find(fo>=maxfreq,1);
%         plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(fft_selection-plot_counter)/10,'r'); hold(handles.axes2,'on')
%         plot_counter = plot_counter + 1;
%     end
%     if channel_4
%         L=length(data(:,4));
%         NFFT = 2^nextpow2(L);
%         Yo = fft(data(:,4),NFFT)/L;
%         fo = Fs/2*linspace(0,1,NFFT/2+1);
%         spectraldata = 2*abs(Yo(1:NFFT/2+1));
%         freqindex1 = find(fo>=minfreq,1);
%         freqindex2 = find(fo>=maxfreq,1);
%         plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(fft_selection-plot_counter)/10,'r'); hold(handles.axes2,'on')
%         plot_counter = plot_counter + 1;
%     end
%     if channel_5
%         L=length(data(:,5));
%         NFFT = 2^nextpow2(L);
%         Yo = fft(data(:,5),NFFT)/L;
%         fo = Fs/2*linspace(0,1,NFFT/2+1);
%         spectraldata = 2*abs(Yo(1:NFFT/2+1));
%         freqindex1 = find(fo>=minfreq,1);
%         freqindex2 = find(fo>=maxfreq,1);
%         plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(fft_selection-plot_counter)/10,'r');hold(handles.axes2,'on')
%         plot_counter = plot_counter + 1;
%     end
%     if channel_6
%         L=length(data(:,6));
%         NFFT = 2^nextpow2(L);
%         Yo = fft(data(:,6),NFFT)/L;
%         fo = Fs/2*linspace(0,1,NFFT/2+1);
%         spectraldata = 2*abs(Yo(1:NFFT/2+1));
%         freqindex1 = find(fo>=minfreq,1);
%         freqindex2 = find(fo>=maxfreq,1);
%         plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(fft_selection-plot_counter)/10,'r'); hold(handles.axes2,'on')
%         plot_counter = plot_counter + 1;
%     end
%     if channel_7
%         L=length(data(:,7));
%         NFFT = 2^nextpow2(L);
%         Yo = fft(data(:,7),NFFT)/L;
%         fo = Fs/2*linspace(0,1,NFFT/2+1);
%         spectraldata = 2*abs(Yo(1:NFFT/2+1));
%         freqindex1 = find(fo>=minfreq,1);
%         freqindex2 = find(fo>=maxfreq,1);
%         plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(fft_selection-plot_counter)/10,'r'); hold(handles.axes2,'on')
%         plot_counter = plot_counter + 1;
%     end
%     if channel_8
%         L=length(data(:,8));
%         NFFT = 2^nextpow2(L);
%         Yo = fft(data(:,8),NFFT)/L;
%         fo = Fs/2*linspace(0,1,NFFT/2+1);
%         spectraldata = 2*abs(Yo(1:NFFT/2+1));
%         freqindex1 = find(fo>=minfreq,1);
%         freqindex2 = find(fo>=maxfreq,1);
%         plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(fft_selection-plot_counter)/10,'r'); hold(handles.axes2,'on')
%     end
    drawnow; hold(handles.axes2,'off')
end

if manualstop == 0
    stop(ai);
end
% alltimers = timerfindall;
% stop(alltimers(:));
disp(['Recorded ' num2str(ai.SamplesAcquired/Fs) ' seconds of data'])

if save_mem || save_diskmem
    data = getdata(ai, ai.SamplesAcquired);
elseif save_disk
    data = daqread(FileName);
end

% if ana_only_on == 1
%     plot(handles.axes1,data(:,1)+a(8),'b'); hold(handles.axes1,'on')
%     plot(handles.axes1,data(:,2)+a(7),'b'); hold(handles.axes1,'on')
%     plot(handles.axes1,data(:,3)+a(6),'b'); hold(handles.axes1,'on')
%     plot(handles.axes1,data(:,4)+a(5),'b'); hold(handles.axes1,'on')
%     plot(handles.axes1,data(:,5)+a(4),'b'); hold(handles.axes1,'on')
%     plot(handles.axes1,data(:,6)+a(3),'b'); hold(handles.axes1,'on')
%     plot(handles.axes1,data(:,7)+a(2),'b'); hold(handles.axes1,'on')
%     plot(handles.axes1,data(:,8)+a(1),'b'); hold(handles.axes1,'on')
%     hold(handles.axes1,'off')
% else
[k1 k2] = size(data);
%         b = wrev(a);

a = linspace(-chan_d,chan_d,num_chan);
b=sort(a,'descend');
for k=1:k2
    if k<9
        plot(handles.axes1,data(:,k)+b(k),'b'); hold(handles.axes1,'on')
    else
        plot(handles.axes1,data(:,k)./10000+b(k),'r'); hold(handles.axes1,'on')
    end
end
grid(handles.axes1,'on')
drawnow; hold(handles.axes1,'off')
% end

disp('Plotting data')

L=length(data(:,1));
NFFT = 2^nextpow2(L);
Yo = fft(data(:,1),NFFT)/L;
fo = Fs/2*linspace(0,1,NFFT/2+1);
plot(handles.axes2,fo,2*abs(Yo(1:NFFT/2+1))+a(8)/10,'r'),hold(handles.axes2,'on')

L=length(data(:,2));
NFFT = 2^nextpow2(L);
Yo = fft(data(:,2),NFFT)/L;
fo = Fs/2*linspace(0,1,NFFT/2+1);
plot(handles.axes2,fo,2*abs(Yo(1:NFFT/2+1))+a(7)/10,'r'); hold(handles.axes2,'on')

L=length(data(:,3));
NFFT = 2^nextpow2(L);
Yo = fft(data(:,3),NFFT)/L;
fo = Fs/2*linspace(0,1,NFFT/2+1);
plot(handles.axes2,fo,2*abs(Yo(1:NFFT/2+1))+a(6)/10,'r'); hold(handles.axes2,'on')

L=length(data(:,4));
NFFT = 2^nextpow2(L);
Yo = fft(data(:,4),NFFT)/L;
fo = Fs/2*linspace(0,1,NFFT/2+1);
plot(handles.axes2,fo,2*abs(Yo(1:NFFT/2+1))+a(5)/10,'r'); hold(handles.axes2,'on')

L=length(data(:,5));
NFFT = 2^nextpow2(L);
Yo = fft(data(:,5),NFFT)/L;
fo = Fs/2*linspace(0,1,NFFT/2+1);
plot(handles.axes2,fo,2*abs(Yo(1:NFFT/2+1))+a(4)/10,'r');hold(handles.axes2,'on')

L=length(data(:,6));
NFFT = 2^nextpow2(L);
Yo = fft(data(:,6),NFFT)/L;
fo = Fs/2*linspace(0,1,NFFT/2+1);
plot(handles.axes2,fo,2*abs(Yo(1:NFFT/2+1))+a(3)/10,'r'); hold(handles.axes2,'on')

L=length(data(:,7));
NFFT = 2^nextpow2(L);
Yo = fft(data(:,7),NFFT)/L;
fo = Fs/2*linspace(0,1,NFFT/2+1);
plot(handles.axes2,fo,2*abs(Yo(1:NFFT/2+1))+a(2)/10,'r'); hold(handles.axes2,'on')

L=length(data(:,8));
NFFT = 2^nextpow2(L);
Yo = fft(data(:,8),NFFT)/L;
fo = Fs/2*linspace(0,1,NFFT/2+1);
plot(handles.axes2,fo,2*abs(Yo(1:NFFT/2+1))+a(1)/10,'r'); hold(handles.axes2,'on')

grid(handles.axes1,'on')
drawnow; hold(handles.axes2,'off')
set(handles.start_recording, 'Enable','on')
if manualstop == 0
    delete(ai)
    clear ai
    disp('Acquisition object cleared')
    disp(['Recording ended at: '  datestr(now)])
    disp('---------------------------------Stop--------------------------------------')
    set(handles.start_recording, 'Enable','on')
    set(handles.Clear, 'Enable','on')
end

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

function chan_d_Callback(hObject, eventdata, handles)
global chan_d
chan_d = str2double(get(hObject,'String'));
return

function chan_d_CreateFcn(hObject, eventdata, handles)
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
global data
global dur_aq
dur_aq = str2double(get(handles.dur_aq,'String'));
global Fs
Fs = str2double(get(handles.Fs_vak,'String'));
global num_chan
global chan_d
chan_d = str2double(get(handles.chan_d,'String'))/10000;
global fft_l
fft_l = str2double(get(handles.fft_l,'String'));
global preview
preview = str2double(get(handles.prev_t,'String'));
% global ana_only_on
% if (get(handles.ana_only_on,'Value') == get(handles.ana_only_on,'Max'))
%     ana_only_on =1;
% else
%     ana_only_on =0;
% end
[data, pathname] = ...
    uigetfile({'*.mat';},'Select a 2D array');
if (pathname) ~= 0
    load(data);
    if size(data,3) > 1
        warndlg('You are trying to load cut data (3D). The EEG_recorder is not able to display this')
    else
        
        % global num_chan;
        global a
        [k1 k2] = size(data);
        a = linspace(-chan_d,chan_d,k2);
        
        % % if ana_only_on == 1
        %     plot(handles.axes1,data(:,1)+a(8),'b'); hold(handles.axes1,'on')
        %     plot(handles.axes1,data(:,2)+a(7),'b'); hold(handles.axes1,'on')
        %
        %     plot(handles.axes1,data(:,3)+a(6),'b'); hold(handles.axes1,'on')
        %     plot(handles.axes1,data(:,4)+a(5),'b'); hold(handles.axes1,'on')
        %
        %     plot(handles.axes1,data(:,5)+a(4),'b'); hold(handles.axes1,'on')
        %     plot(handles.axes1,data(:,6)+a(3),'b'); hold(handles.axes1,'on')
        %
        %     plot(handles.axes1,data(:,7)+a(2),'b'); hold(handles.axes1,'on')
        %     plot(handles.axes1,data(:,8)+a(1),'b'); hold(handles.axes1,'on')
        %     hold(handles.axes1,'off')
        % else
        for k=1:k2
            %             b = wrev(a);%wavelet function
            b=sort(a,'descend');
            if k<9
                plot(handles.axes1,data(:,k)+b(k),'b'); hold(handles.axes1,'on')
            else
                plot(handles.axes1,data(:,k)./10000+b(k),'r'); hold(handles.axes1,'on')
            end
        end
        grid(handles.axes1,'on')
        drawnow; hold(handles.axes1)
        % end
        
        minfreq = str2double(get(handles.minfreq, 'String'));
        maxfreq = str2double(get(handles.maxfreq, 'String'));
        
        %     data    = peekdata(ai,fft_l);
        L       = length(data(:,1));
        NFFT    = 2^nextpow2(L);
        Yo      = fft(data(:,1),NFFT)/L;
        fo      = Fs/2*linspace(0,1,NFFT/2+1);
        spectraldata = 2*abs(Yo(1:NFFT/2+1));
        freqindex1 = find(fo>=minfreq,1);
        freqindex2 = find(fo>=maxfreq,1);
        plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(8)/10,'r'),hold(handles.axes2,'on')
        
        L       = length(data(:,2));
        NFFT    = 2^nextpow2(L);
        Yo      = fft(data(:,2),NFFT)/L;
        fo      = Fs/2*linspace(0,1,NFFT/2+1);
        spectraldata = 2*abs(Yo(1:NFFT/2+1));
        freqindex1 = find(fo>=minfreq,1);
        freqindex2 = find(fo>=maxfreq,1);
        plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(7)/10,'r'); hold(handles.axes2,'on')
        
        L=length(data(:,3));
        NFFT = 2^nextpow2(L);
        Yo = fft(data(:,3),NFFT)/L;
        fo = Fs/2*linspace(0,1,NFFT/2+1);
        spectraldata = 2*abs(Yo(1:NFFT/2+1));
        freqindex1 = find(fo>=minfreq,1);
        freqindex2 = find(fo>=maxfreq,1);
        plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(6)/10,'r'); hold(handles.axes2,'on')
        
        L=length(data(:,4));
        NFFT = 2^nextpow2(L);
        Yo = fft(data(:,4),NFFT)/L;
        fo = Fs/2*linspace(0,1,NFFT/2+1);
        spectraldata = 2*abs(Yo(1:NFFT/2+1));
        freqindex1 = find(fo>=minfreq,1);
        freqindex2 = find(fo>=maxfreq,1);
        plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(5)/10,'r'); hold(handles.axes2,'on')
        
        L=length(data(:,5));
        NFFT = 2^nextpow2(L);
        Yo = fft(data(:,5),NFFT)/L;
        fo = Fs/2*linspace(0,1,NFFT/2+1);
        spectraldata = 2*abs(Yo(1:NFFT/2+1));
        freqindex1 = find(fo>=minfreq,1);
        freqindex2 = find(fo>=maxfreq,1);
        plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(4)/10,'r');hold(handles.axes2,'on')
        
        L=length(data(:,6));
        NFFT = 2^nextpow2(L);
        Yo = fft(data(:,6),NFFT)/L;
        fo = Fs/2*linspace(0,1,NFFT/2+1);
        spectraldata = 2*abs(Yo(1:NFFT/2+1));
        freqindex1 = find(fo>=minfreq,1);
        freqindex2 = find(fo>=maxfreq,1);
        plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(3)/10,'r'); hold(handles.axes2,'on')
        
        L=length(data(:,7));
        NFFT = 2^nextpow2(L);
        Yo = fft(data(:,7),NFFT)/L;
        fo = Fs/2*linspace(0,1,NFFT/2+1);
        spectraldata = 2*abs(Yo(1:NFFT/2+1));
        freqindex1 = find(fo>=minfreq,1);
        freqindex2 = find(fo>=maxfreq,1);
        plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(2)/10,'r'); hold(handles.axes2,'on')
        
        L=length(data(:,8));
        NFFT = 2^nextpow2(L);
        Yo = fft(data(:,8),NFFT)/L;
        fo = Fs/2*linspace(0,1,NFFT/2+1);
        spectraldata = 2*abs(Yo(1:NFFT/2+1));
        freqindex1 = find(fo>=minfreq,1);
        freqindex2 = find(fo>=maxfreq,1);
        plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(1)/10,'r'); hold(handles.axes2,'on')
        drawnow; hold(handles.axes2,'off')
    end
    
end

% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
global data;
% [k1 k2] = size(data);
curdir = cd;
cd([curdir filesep 'data']);
uisave({'data'},'Name');
cd(curdir);
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
Array_manipulator
% --------------------------------------------------------------------
function Spectral_analysis_Callback(hObject, eventdata, handles)
Spectral_analysis
% --------------------------------------------------------------------
function ERP_tool_Callback(hObject, eventdata, handles)
ERP_tool
function Data_plotter_Callback(hObject, eventdata, handles)
Data_plotter
% --------------------------------------------------------------------
function Event_cutter_Callback(hObject, eventdata, handles)
Event_cutter
function get_serial_Callback(hObject, eventdata, handles)
global ai
daqinfo = daqhwinfo('gmlplusdaq');
comport = str2double(daqinfo.InstalledBoardIds{1});
ai = analoginput('gmlplusdaq',comport);
str = get(ai,'DeviceSerial');
msgbox(str)
delete(ai)
clear ai
function prev_t_Callback(hObject, eventdata, handles)
global preview
preview = str2double(get(hObject,'String'));
return
function prev_t_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function ana_only_on_Callback(hObject, eventdata, handles)
global ana_only_on
if (get(hObject,'Value') == get(hObject,'Max'))
    ana_only_on =1;
else
    ana_only_on =0;
end

function softscop_Callback(hObject, eventdata, handles)
global ai
daqinfo = daqhwinfo('gmlplusdaq');
comport = str2double(daqinfo.InstalledBoardIds{1});
global Test_mode_on
if (get(handles.Test_mode_on,'Value') == get(handles.Test_mode_on,'Max'))
    Test_mode_on =1;
else
    Test_mode_on =0;
end
ai = analoginput('gmlplusdaq',comport);
if Test_mode_on == 1
    set(ai,'Testmode','Enable');
else
    set(ai,'Testmode','Disable');
end
addchannel (ai,1:16)
start(ai)
softscope(ai);
% --------------------------------------------------------------------
function filter_Callback(hObject, eventdata, handles)
filters

function Syllabus_Callback(hObject, eventdata, handles)
web('Syllabus.htm', '-helpbrowser')


% --------------------------------------------------------------------
% function Syllabus_Callback(hObject, eventdata, handles)
% hObject    handle to Syllabus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function maxfreq_Callback(hObject, eventdata, handles)
% hObject    handle to maxfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of maxfreq as text
%        str2double(get(hObject,'String')) returns contents of maxfreq as a double


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



function minfreq_Callback(hObject, eventdata, handles)
% hObject    handle to minfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of minfreq as text
%        str2double(get(hObject,'String')) returns contents of minfreq as a double


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


% --- Executes on button press in channel_1.
function channel_1_Callback(hObject, eventdata, handles)
% hObject    handle to channel_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of channel_1


% --- Executes on button press in channel_2.
function channel_2_Callback(hObject, eventdata, handles)
% hObject    handle to channel_2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of channel_2


% --- Executes on button press in channel_3.
function channel_3_Callback(hObject, eventdata, handles)
% hObject    handle to channel_3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of channel_3


% --- Executes on button press in channel_4.
function channel_4_Callback(hObject, eventdata, handles)
% hObject    handle to channel_4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of channel_4


% --- Executes on button press in channel_5.
function channel_5_Callback(hObject, eventdata, handles)
% hObject    handle to channel_5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of channel_5


% --- Executes on button press in channel_6.
function channel_6_Callback(hObject, eventdata, handles)
% hObject    handle to channel_6 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of channel_6


% --- Executes on button press in channel_7.
function channel_7_Callback(hObject, eventdata, handles)
% hObject    handle to channel_7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of channel_7


% --- Executes on button press in channel_8.
function channel_8_Callback(hObject, eventdata, handles)
% hObject    handle to channel_8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of channel_8


% --- Executes on button press in ch9_on.
function ch9_on_Callback(hObject, eventdata, handles)
% hObject    handle to ch9_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch9_on


% --- Executes on button press in ch10_on.
function ch10_on_Callback(hObject, eventdata, handles)
% hObject    handle to ch10_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch10_on


% --- Executes on button press in ch12_on.
function ch12_on_Callback(hObject, eventdata, handles)
% hObject    handle to ch12_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch12_on


% --- Executes on button press in ch13_on.
function ch13_on_Callback(hObject, eventdata, handles)
% hObject    handle to ch13_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch13_on


% --- Executes on button press in ch14_on.
function ch14_on_Callback(hObject, eventdata, handles)
% hObject    handle to ch14_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch14_on


% --- Executes on button press in ch15_on.
function ch15_on_Callback(hObject, eventdata, handles)
% hObject    handle to ch15_on (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of ch15_on
