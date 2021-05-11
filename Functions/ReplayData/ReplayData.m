function varargout = ReplayData(varargin)
% REPLAYDATA MATLAB code for ReplayData.fig
%      REPLAYDATA, by itself, creates a new REPLAYDATA or raises the existing
%      singleton*.
%
%      H = REPLAYDATA returns the handle to a new REPLAYDATA or the handle to
%      the existing singleton*.
%
%      REPLAYDATA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in REPLAYDATA.M with the given input arguments.
%
%      REPLAYDATA('Property','Value',...) creates a new REPLAYDATA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ReplayData_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ReplayData_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ReplayData

% Last Modified by GUIDE v2.5 28-Apr-2021 13:20:57

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ReplayData_OpeningFcn, ...
                   'gui_OutputFcn',  @ReplayData_OutputFcn, ...
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


% --- Executes just before ReplayData is made visible.
function ReplayData_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ReplayData (see VARARGIN)

% Choose default command line output for ReplayData
handles.output = hObject;
if isempty(varargin)
    warndlg('Unable to open this tool directly, open it from the EEG_recorder main function')
    handles.closeFigure = true;
else
    handles.dir = varargin{1}.dir;
end
% add plotcolors subdirectories, all markers are red!
handles.plotColors = [    ...
    0      0.4470 0.7410; ...
    0.8500 0.3250 0.0980; ...
    0.9290 0.6940 0.1250; ...
    0.4940 0.1840 0.5560; ...
    0.4660 0.6740 0.1880; ...
    0.3010 0.7450 0.9330; ...
    0.6350 0.0780 0.1840; ...
    1      0      1;      ... 
    1      0      0;      ...
    1      0      0;      ...
    1      0      0;      ...
    1      0      0;      ...
    1      0      0;      ...
    1      0      0;      ...
    ];



% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ReplayData wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ReplayData_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --------------------------------------------------------------------
function load_file_Callback(hObject, eventdata, handles)
global filename; 
global replay_data;
global available_channels;
[filename, data] = EEGLoadData(handles);
if any(filename)
    handles.data = data;
    handles.filename= filename;
    replay_data = data;
    
    if size(data,3) > 1
        warndlg('You are trying to load 3D data, the EEG_recorder is not able to display this.')
    else
        set(handles.filename_txt,'string',filename);
    set(handles.filesize_txt,'string',num2str(size(handles.data)));
    available_channels = size(data,2);
    end
end

% reduce valus of marker channels from 5V to 25 microV to pit them into the same plotting range as the EEG channels 
 replay_data(:,9:available_channels) = replay_data(:,9:available_channels)/200000;
 
 for a = 1:available_channels
     Max_value(a) = max(replay_data(:,a));
 end

 size(data);
 size(replay_data);

if available_channels >8
for closechannels = available_channels+1:14
    if closechannels == 9
        set(handles.ch9_on, 'Enable','off');
    end
    if closechannels == 10
        set(handles.ch10_on, 'Enable','off');
    end
    if closechannels == 11
        set(handles.ch11_on, 'Enable','off');
    end
    if closechannels == 12
        set(handles.ch12_on, 'Enable','off');
    end
    if closechannels == 13
        set(handles.ch13_on, 'Enable','off');
    end
    if closechannels == 14
        set(handles.ch14_on, 'Enable','off');
    end
end    
end

% Speeds2select = [1,2,4,8,16]
% set(handles.plot_speed,'String',Speeds2select); %Update the list in plot_speed.

 guidata(hObject,handles);





% --- Executes on button press in start_replay.
function start_replay_Callback(hObject, eventdata, handles)
global replay_data;
global samples2plot;
global channel2plot;
global num_chan;
global addchannel;
global data; data = [];
global available_channels
global a
global stop_replay
global continue_replay
global pause_replay
global plot_speed
global plot_selected_frequencies
global minfreq
global maxfreq
global last_sample2plot
global FFT_length_samples
global plot_powerspectrum
global plot_neurofeedback


plot_selected_frequencies = 0;

plotColors = handles.plotColors;
[0 0.4470 0.7410 ;0.8500 0.3250 0.0980; 0.9290 0.6940 0.1250; 0.4940 0.1840 0.5560; ...
    0.4660 0.6740 0.1880; 0.3010 0.7450 0.9330; 0.6350 0.0780 0.1840; 1 0 1; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0; 1 0 0];

% fft_l = str2double(get(handles.fft_ll,'String'));
%     preview     = str2double(get(handles.prev_t,'String'));
 stop_replay = 0;
 continue_replay = 0;
 pause_replay = 0; 

% adding channel labels
channelLabels = {'chan1','chan2','chan3','chan4','chan5','chan6','chan7','chan8','Marker1','Marker2','Marker3','Marker4','Marker5','Marker6'};


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

% get default settings
plot_powerspectrum = handles.plot_powerspectrum.Value;
plot_neurofeedback = handles.plot_neurofeedback.Value;
samples2plot = str2double(get(handles.samples2plot,'String'))*256;

%reset some default settings
set(handles.stop_replay, 'String','Stop Replay');
set(handles.feedback2user,'visible','off');


Fs = 256; % sample frequency:256Hz
N = length(replay_data);
number_of_sections =int16(N/samples2plot)-1;

% the number of sections to plot
section_block_number = 0;

% the number of samples in each plotting step
sample_block_number = 0;

%inbouwen variabele plotsnelheid, voor elk van de 1024 samples of bv voor
%128 samples ineens.
samples2plot_eachstep = samples2plot/plot_speed;


for section_number = 1:number_of_sections
    
    if stop_replay == 1
        set(handles.feedback2user,'visible','on','String','Replay has stopped');
        
        break
    end
    
    if pause_replay == 1
        set(handles.feedback2user,'visible','on','String','Replay Paused');
        uiwait
    end
    
    if section_number == number_of_sections
        set(handles.feedback2user,'visible','on','String','End of File is reached');
    end
    
    % calculate samples to time for x-axis
    tempTime = (section_block_number*samples2plot+1:samples2plot+(samples2plot*section_block_number))/256;
    
    % initially set every value for the plot to zero
    data = zeros(samples2plot,available_channels);
    
    for current_sample = 1:samples2plot_eachstep
        
        %% get latest data to plot
        % get the proportion of the preview time
        tempSample = mod((current_sample*plot_speed)-1, samples2plot)+1;
        
        % get most recent data to plot
        data(1:tempSample,:) = replay_data(sample_block_number*samples2plot+1:tempSample+(samples2plot*sample_block_number),:);
        
        % to be used in FFT plot
        last_sample2plot = tempSample+(samples2plot*sample_block_number);
        
        chan_space = str2double(get(handles.chan_space,'String'))/1000;
        a = linspace(-chan_space,chan_space,num_chan_plot);
        b = sort(a,'descend');
        
        %% plot live signal
        for ichan=1:num_chan_plot
            
            if channel_selection(ichan)< 15
                plot(handles.axes1,tempTime,data(:,channel_selection(ichan))+b(ichan), 'Color', plotColors(channel_selection(ichan),:));
                hold(handles.axes1,'on');
            end
        end
        grid(handles.axes1,'on');
        drawnow;
        hold(handles.axes1,'off');
        xlim([min(tempTime) max(tempTime)]);
        
        if plot_selected_frequencies == 0 & last_sample2plot>FFT_length_samples
            
            if plot_powerspectrum == 1
                
                %% plot power spectrum
                minfreq = str2double(get(handles.minfreq, 'String'));
                maxfreq = str2double(get(handles.maxfreq, 'String'));
                
                %Start axis 2 plot
                fft_selection = sum(analog_channels_on);
                plot_counter = 0;
                for ichan=1:num_chan_plot
                    if analog_channels_on(ichan)
                        
                        L       = FFT_length_samples;
                        NFFT    = 2^nextpow2(L);
                        Yo      = fft((replay_data(last_sample2plot-FFT_length_samples:last_sample2plot,channel_selection(ichan))-mean(data(:,channel_selection(ichan)))),NFFT)/NFFT;
                        fo      = Fs/2*linspace(0,1,NFFT/2+1);
                        spectraldata = 2*abs(Yo(1:NFFT/2+1));
                        freqindex1 = find(fo>=minfreq,1);
                        freqindex2 = find(fo>=maxfreq,1);
                        plot(handles.axes2,fo(freqindex1:freqindex2),spectraldata(freqindex1:freqindex2)+a(fft_selection-plot_counter)/10, 'Color', plotColors(ichan,:)); hold(handles.axes2,'on')
                        plot_counter = plot_counter + 1;
                    end
                end
                
                drawnow; hold(handles.axes2,'off');
            end %plot power spectrum
            
            if plot_neurofeedback == 1
                
                feedback_channel = str2num(handles.feedback_channel.String);
                freq_range1 = str2num(handles.freq_range1.String);
                freq_range2 = str2num(handles.freq_range2.String);
                freq_range3 = str2num(handles.freq_range3.String);
                freq_range4 = str2num(handles.freq_range4.String);
                
                %Start axis 2 plot
                
                for ichan=feedback_channel
                    if analog_channels_on(ichan)
                        L       = FFT_length_samples;
                        NFFT    = 2^nextpow2(L);
                        Yo      = fft((replay_data(last_sample2plot-FFT_length_samples:last_sample2plot,channel_selection(ichan))-mean(data(:,channel_selection(ichan)))),NFFT)/NFFT;
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
                        ylim([0 0.000005]);
                        
                    end
                end
                
                drawnow; hold(handles.axes2,'off');
                
                
            end % plot neurofeedback
            
        end
        % END axis_2 plot
        
        
    end
    section_block_number = section_block_number+1;
    sample_block_number = sample_block_number+1;
    
end


% --- Executes on button press in channel_1.
function status = channel_1_Callback(hObject, eventdata, handles)
status = handles.channel_1.Value;

% --- Executes on button press in channel_2.
function status = channel_2_Callback(hObject, eventdata, handles)
status = handles.channel_2.Value;

% --- Executes on button press in channel_3.
function status = channel_3_Callback(hObject, eventdata, handles)
status = handles.channel_3.Value;

% --- Executes on button press in channel_4.
function status = channel_4_Callback(hObject, eventdata, handles)
status = handles.channel_4.Value;

% --- Executes on button press in channel_5.
function status = channel_5_Callback(hObject, eventdata, handles)
status = handles.channel_5.Value;

% --- Executes on button press in channel_6.
function status = channel_6_Callback(hObject, eventdata, handles)
status = handles.channel_6.Value;

% --- Executes on button press in channel_7.
function status = channel_7_Callback(hObject, eventdata, handles)
status = handles.channel_7.Value;

% --- Executes on button press in channel_8.
function status = channel_8_Callback(hObject, eventdata, handles)
status = handles.channel_8.Value;

% --- Executes on button press in ch9_on.
function status = ch9_on_Callback(hObject, eventdata, handles)
status = handles.ch9_on.Value;

% --- Executes on button press in ch10_on.
function status = ch10_on_Callback(hObject, eventdata, handles)
status = handles.ch10_on.Value;

% --- Executes on button press in ch11_on.
function status = ch11_on_Callback(hObject, eventdata, handles)
status = handles.ch11_on.Value;

% --- Executes on button press in ch12_on.
function status = ch12_on_Callback(hObject, eventdata, handles)
status = handles.ch12_on.Value;

% --- Executes on button press in ch13_on.
function status = ch13_on_Callback(hObject, eventdata, handles)
status = handles.ch13_on.Value;

% --- Executes on button press in ch14_on.
function status = ch14_on_Callback(hObject, eventdata, handles)
status = handles.ch14_on.Value;

function chan_space_Callback(hObject, eventdata, handles)
chan_space = str2double(get(handles.chan_space, 'String'))/1000;
return

% --- Executes during object creation, after setting all properties.
function chan_space_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on selection change in plot_speed.
function plot_speed_Callback(hObject, eventdata, handles)
global plot_speed
%global contents
%contents = str2double(get(hObject,'String'))
if handles.plot_speed.Value == 2
    plot_speed = 2;
elseif handles.plot_speed.Value == 3
    plot_speed = 4;
elseif handles.plot_speed.Value == 4
    plot_speed = 8;
elseif handles.plot_speed.Value == 5
    plot_speed = 16;
elseif handles.plot_speed.Value == 6
    plot_speed = 32;
elseif handles.plot_speed.Value == 7
    plot_speed = 64;
else
   plot_speed = 16;
end




% --- Executes during object creation, after setting all properties.
function plot_speed_CreateFcn(hObject, eventdata, handles)
global plot_speed
plot_speed = 16; 
% hObject    handle to plot_speed (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
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



function maxfreq_Callback(hObject, eventdata, handles)
% hObject    handle to maxfreq (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object creation, after setting all properties.
function maxfreq_CreateFcn(hObject, eventdata, handles)
% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function FFT_length_Callback(hObject, eventdata, handles)
global FFT_length_samples
FFT_length = str2double(get(handles.FFT_length, 'String'));
FFT_length_samples = FFT_length*256;


% --- Executes during object creation, after setting all properties.
function FFT_length_CreateFcn(hObject, eventdata, handles)
global FFT_length_samples
FFT_length_samples = 512; 

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
global pause_replay
pause_replay = get(hObject,'Value');
set(handles.pause, 'Enable','off','BackgroundColor', 'white');
set(handles.continue_replay, 'Enable','on','BackgroundColor', 'green');



% --- Executes on button press in continue_replay.
function continue_replay_Callback(hObject, eventdata, handles)
global continue_replay
global pause_replay
continue_replay = get(hObject,'Value');
if pause_replay == 1
    uiresume
    pause_replay = 0;
end
set(handles.continue_replay, 'Enable','off', 'BackgroundColor', 'white');
set(handles.pause, 'Enable','on','BackgroundColor', '1 0.68 0.21');
set(handles.feedback2user,'visible','off');

% --- Executes on button press in stop_replay.
function stop_replay_Callback(hObject, eventdata, handles)
global stop_replay
stop_replay = get(hObject,'Value');
set(handles.stop_replay, 'String','Replay Stopped');



function samples2plot_Callback(hObject, eventdata, handles)
global samples2plot
samples2plot = str2double(get(handles.samples2plot, 'String'))*256;


% --- Executes during object creation, after setting all properties.
function samples2plot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_powerspectrum.
function plot_powerspectrum_Callback(hObject, eventdata, handles)
global plot_powerspectrum
plot_powerspectrum = handles.plot_powerspectrum.Value;
% hObject    handle to plot_powerspectrum (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_powerspectrum

% --- Executes on button press in plot_neurofeedback.
function plot_neurofeedback_Callback(hObject, eventdata, handles)
global plot_neurofeedback
plot_neurofeedback = handles.plot_neurofeedback.Value;
% hObject    handle to plot_neurofeedback (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of plot_neurofeedback



function freq_range1_Callback(hObject, eventdata, handles)
% hObject    handle to freq_range1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of freq_range1 as text
%        str2double(get(hObject,'String')) returns contents of freq_range1 as a double


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

% Hints: get(hObject,'String') returns contents of freq_range2 as text
%        str2double(get(hObject,'String')) returns contents of freq_range2 as a double


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

% Hints: get(hObject,'String') returns contents of freq_range3 as text
%        str2double(get(hObject,'String')) returns contents of freq_range3 as a double


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

% Hints: get(hObject,'String') returns contents of freq_range4 as text
%        str2double(get(hObject,'String')) returns contents of freq_range4 as a double


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

% Hints: get(hObject,'String') returns contents of feedback_channel as text
%        str2double(get(hObject,'String')) returns contents of feedback_channel as a double


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

function feedback2user_Callback(hObject, eventdata, handles)
% hObject    handle to feedback_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of feedback_channel as text
%        str2double(get(hObject,'String')) returns contents of feedback_channel as a double


% --- Executes during object creation, after setting all properties.
function feedback2user_CreateFcn(hObject, eventdata, handles)
% hObject    handle to feedback_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


