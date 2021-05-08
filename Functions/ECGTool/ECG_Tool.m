function varargout = ECG_Tool(varargin)
% ECG_TOOL MATLAB code for ECG_Tool.fig
%   **********************************************************************
%   *      Build by Antonius B. Mulder                                   *
%   *      Psychobiology                                                 *
%   *      UvA, Amsterdam, The Netherlands                               *
%   *      a.b.mulder@uva.nl                                             *
%   **********************************************************************
%
%   - The user is free to use the software at his/her own risk within his/her
%   resident laboratory.
%   - Tonny Mulder accepts no responsibility for any malfunctions and potential errors in the code.


%      ECG_TOOL, by itself, creates a new ECG_TOOL or raises the existing
%      singleton*.
%      ECG_TOOL does things 
%
%      H = ECG_TOOL returns the handle to a new ECG_TOOL or the handle to
%      the existing singleton*.
%
%      ECG_TOOL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ECG_TOOL.M with the given input arguments.
%
%      ECG_TOOL('Property','Value',...) creates a new ECG_TOOL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ECG_Tool_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ECG_Tool_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ECG_Tool

% Last Modified by GUIDE v2.5 03-May-2020 15:43:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ECG_Tool_OpeningFcn, ...
                   'gui_OutputFcn',  @ECG_Tool_OutputFcn, ...
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


% --- Executes just before ECG_Tool is made visible.
function ECG_Tool_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ECG_Tool (see VARARGIN)

% Choose default command line output for ECG_Tool
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ECG_Tool wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ECG_Tool_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in pushbutton1.
function pushbutton1_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--- Loading the datafile and resets the parameters

global filename
global ecg_data
global ECG_Channel2plot
global Max_xvalue
global Max_xvalue_current
global Min_xvalue
global reset_threshold
global max_heartbeat_freq
global notch
global reselect
global rethreshold
curdir = cd;
[filename, pathname] = ...
    uigetfile({'*.mat';},'Select a recording file');
if any(filename)
    load(filename);
    ecg_data = data;  % drops data in the ecg_data array
    if size(ecg_data,3) > 1   %check if the file is 2D
        warndlg('You are trying to load 3D data, the EEG_recorder is not able to display this.')
    else
        [Max_xvalue,No_channels] = size(ecg_data);   %get the size of the data file
        Max_xvalue_current = Max_xvalue;
        Min_xvalue = 1;
    end
end

%--- reset a number of variables
notch = 0;
max_heartbeat_freq = 200;
reselect = 0;
rethreshold = 0;
reset_threshold = 0;
cla                                         % clear all existing graphs

%--- set all parameters that need to be set
set(handles.loaded_file,'string',filename)
set(handles.available_channels,'string',No_channels)
set(handles.max_interbeat_interval,'string',max_heartbeat_freq)
set(handles.apply_notch_filter,'Value',0)
set(handles.MinX_value,'string',Min_xvalue)
set(handles.MaxX_Value,'string',Max_xvalue_current)

cd(curdir);



function ecg_channel_Callback(hObject, eventdata, handles)
% hObject    handle to ecg_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ecg_channel as text
%        str2double(get(hObject,'String')) returns contents of ecg_channel as a double

%--- This function gets the channel to plot from the selected data file

global ECG_Channel2plot

%--- select the channel to be analyzed
ECG_Channel2plot = str2double(get(handles.ecg_channel, 'string')); %




% --- Executes during object creation, after setting all properties.
function ecg_channel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ecg_channel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in plot_ecg.
function plot_ecg_Callback(hObject, eventdata, handles)
% hObject    handle to plot_ecg (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%--- This function plots the selected channel of the selected data file and
%--- with or without the notch filter
%--- and sets some values

global ECG_Channel2plot
global ecg_data
global Max_xvalue
global Max_xvalue_current
global Min_xvalue
global selection_made
global selection2remove
global ecg_data_notch
global notch

selection_made = 0;
selection2remove = 0;

xlim([Min_xvalue Max_xvalue_current]); % limits the plot to min and max x bounderies
if notch == 0
    xlim([Min_xvalue Max_xvalue_current]); % limits the plot to min and max x bounderies
    plot(handles.axes1,ecg_data(:,ECG_Channel2plot),'b'); hold(handles.axes1,'on'); % plots the original file
    hold on
    grid(handles.axes1,'on');
    title('Original ECG recording');
    xlabel('samples'); 
    ylabel('Voltage(V)');
else
    xlim([Min_xvalue Max_xvalue_current]); % limits the plot to min and max x bounderies
    plot(handles.axes1,ecg_data_notch(:,ECG_Channel2plot),'b'); hold(handles.axes1,'on') % plots the file after applying the notch filter (48-52 Hz)
    hold on
    grid(handles.axes1,'on');
    title('ECG recording, notch filtered');
    xlabel('samples'); 
    ylabel('Voltage(V)');
end
drawnow; hold(handles.axes1);

% --- Executes on button press in r_waves_detection.
% --- After setting a threshold and optional selections of the data, the
% --- peaks above threshold are detected
function r_waves_detection_Callback(hObject, eventdata, handles)
% hObject    handle to r_waves_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- After setting a threshold and optional selections of the data, the
% --- peaks above threshold are detected.

global filename
global ecg_data
global ECG_Channel2plot
global threshold_level
global max_heartbeat_freq
global Max_xvalue
global Max_xvalue_current
global Min_xvalue
global reset_threshold
global locations_Rwave
global Remove_xStart
global Remove_xFinish
global Keep_xStart
global Keep_xFinish
global selection_made
global selection2remove
global notch
global ecg_data_notch
global Min_Manual_xvalue
global MinX_Man_set
global Max_Manual_xvalue
global MaxX_Man_set

% Sets variables MinX_Man_set and MaxX_Man_set to zero if no value was
% manually filled in
if isempty(MinX_Man_set)
    MinX_Man_set = 0;
end

if isempty(MaxX_Man_set)
    MaxX_Man_set = 0;
end

%%Detect R waves
min_sample_interval = (256/(max_heartbeat_freq/60)); % sets the minimum distance (in samples) before a new peak is detected, default = 200 bpm

if notch == 1
    ecg_data = ecg_data_notch; %write notched datafile to working datafile
else
    ecg_data = ecg_data;
end

if selection_made == 1 %--- if selection is made (a range), find the remaining peaks with current threshold
    [values_Rwave,locations_Rwave_selection] = findpeaks(ecg_data(Keep_xStart:Keep_xFinish,ECG_Channel2plot),'MinPeakHeight',threshold_level,'MinPeakDistance',min_sample_interval);
    locations_Rwave = locations_Rwave_selection + Keep_xStart;
end

if selection2remove == 1 %--- if selection is made (cut the end), find the remaining peaks with current threshold
    [values_Rwave,locations_Rwave_selection] = findpeaks(ecg_data(Min_xvalue:Remove_xStart,ECG_Channel2plot),'MinPeakHeight',threshold_level,'MinPeakDistance',min_sample_interval);
    locations_Rwave = locations_Rwave_selection; 
end

if MinX_Man_set == 1 && MaxX_Man_set == 1 %--- if manual selection is made, find the remaining peaks with current threshold
    [values_Rwave,locations_Rwave_selection] = findpeaks(ecg_data(Min_Manual_xvalue:Max_Manual_xvalue,ECG_Channel2plot),'MinPeakHeight',threshold_level,'MinPeakDistance',min_sample_interval);
    locations_Rwave = locations_Rwave_selection + Min_Manual_xvalue;
end

if (selection_made == 0 && selection2remove == 0 && MinX_Man_set == 0 && MaxX_Man_set == 0) %--- if no selection is made, find all peaks with current threshold
    [values_Rwave,locations_Rwave] = findpeaks(ecg_data(:,ECG_Channel2plot),'MinPeakHeight',threshold_level,'MinPeakDistance',min_sample_interval);
end

%if reset_threshold == 0 %--- the first plot with bounderies and selected peaks
    cla
    plot(handles.axes1,ecg_data(:,ECG_Channel2plot),'b');
    grid(handles.axes1,'on');
    title('ECG recording');
    xlabel('samples'); 
    ylabel('Voltage(V)');
    hold on
    xlim([Min_xvalue Max_xvalue_current]);
    
    %--- plot the markers for the selected peaks
    plot(locations_Rwave,values_Rwave,'rv', 'MarkerFaceColor', 'r');
    hold on
    xlim([Min_xvalue Max_xvalue_current]);
    
    %--- plot the horizontal threshold
    y = threshold_level;
    plot(handles.axes1,[Min_xvalue,Max_xvalue_current],[y,y],'r');
    hold on
    
    %--- plot the start and stop x values of the selected data range
    if selection_made == 1 
        ylimits = ylim; % current y-axis limits
        plot(handles.axes1,[Keep_xStart,Keep_xStart],[ylimits(1) ylimits(2)],'r');
        hold on
        plot(handles.axes1,[Keep_xFinish,Keep_xFinish],[ylimits(1) ylimits(2)],'r');
    elseif MinX_Man_set == 1 && MaxX_Man_set == 1
        ylimits = ylim; % current y-axis limits
        plot(handles.axes1,[Min_Manual_xvalue,Min_Manual_xvalue],[ylimits(1) ylimits(2)],'r');
        hold on
        plot(handles.axes1,[Max_Manual_xvalue,Max_Manual_xvalue],[ylimits(1) ylimits(2)],'r');
    elseif selection2remove == 1
        ylimits = ylim; % current y-axis limits
        plot(handles.axes1,[Remove_xStart,Remove_xStart],[ylimits(1) ylimits(2)],'r');
        hold on
    else %--- updates the plot after each selection
        cla
        xlim([Min_xvalue Max_xvalue_current]);
        plot(handles.axes1,ecg_data(:,ECG_Channel2plot),'b');
        grid(handles.axes1,'on');
        title('ECG recording');
        xlabel('samples'); 
        ylabel('Voltage(V)');
        hold on
        plot(locations_Rwave,values_Rwave,'rv', 'MarkerFaceColor', 'r');
        hold on
        xlim([Min_xvalue Max_xvalue_current]);
        y = threshold_level;
        plot(handles.axes1,[Min_xvalue,Max_xvalue_current],[y,y],'r');
        hold on
    end
%end

%--- gets the setting for the minimum interbeat interval in bpm
function max_interbeat_interval_Callback(hObject, eventdata, handles)
% hObject    handle to max_interbeat_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of max_interbeat_interval as text
%        str2double(get(hObject,'String')) returns contents of max_interbeat_interval as a double
global max_heartbeat_freq
max_heartbeat_freq = str2double(get(handles.max_interbeat_interval, 'string'));



% --- Executes during object creation, after setting all properties.
function max_interbeat_interval_CreateFcn(hObject, eventdata, handles)
% hObject    handle to max_interbeat_interval (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--- Executes on button press and deliveres horizontal threshold.
function peak_threshold_initiate_Callback(hObject, eventdata, handles)
% hObject    handle to peak_threshold_initiate (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global threshold_level
global reset_threshold
global rethreshold
global Min_xvalue
global Max_xvalue_current
uiwait(msgbox('Select a threshold level by puting the crosshair on the desired Y value'))

Previous_threshold_level = threshold_level; %--- to seperate current and previous threshold 

%--- When threshold is reset, the existing threshold in plot turns to blue
if rethreshold == 1
    y = threshold_level;
    hold on
    plot(handles.axes1,[Min_xvalue,Max_xvalue_current],[y,y],'b');
    hold on
end

%--- this is where the actual threshold level is selected
a = zeros(1,2);
[~,a] = ginput(1); %--- only 1 click is available

threshold_level = a(1); %--- get the threshold level

%--- the first time the threshold is plotted
if reset_threshold == 0 && rethreshold == 0
    y = threshold_level;
    hold on
    plot(handles.axes1,[Min_xvalue,Max_xvalue_current],[y,y],'r');
    hold on
    reset_threshold = 1;
    rethreshold = 1;
    
%--- if a threshold exists, a new one is plotted    
elseif reset_threshold == 1 && rethreshold == 1
    y = threshold_level;
    hold on
    plot(handles.axes1,[Min_xvalue,Max_xvalue_current],[y,y],'r');
    hold on
    reset_threshold = 1;
end
 
%--- gets the start x value for the replot
function MinX_value_Callback(hObject, eventdata, handles)
% hObject    handle to MinX_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MinX_value as text
%        str2double(get(hObject,'String')) returns contents of MinX_value as a double
global Min_xvalue
Min_xvalue = str2double(get(handles.MinX_value, 'string'));


% --- Executes during object creation, after setting all properties.
function MinX_value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinX_value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--- gets the end x value for the replot
function MaxX_Value_Callback(hObject, eventdata, handles)
% hObject    handle to MaxX_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of MaxX_Value as text
%        str2double(get(hObject,'String')) returns contents of MaxX_Value as a double
global Max_xvalue
global Max_xvalue_current

%--- gets the parameter settings and if set to maximum the data is
%--- displayed until its end
result = get(handles.MaxX_Value, 'string');
compare = strcmp(result,'max');
if compare == 1
    Max_xvalue_current = Max_xvalue; %--- plots to the end of the file
else
    Max_xvalue_current = str2double(get(handles.MaxX_Value, 'string')); %--- plots until selected x value
end


% --- Executes during object creation, after setting all properties.
function MaxX_Value_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxX_Value (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


%--- Saves the x values of the selected peaks to Excel file ; Executes on button press in save2file.
function save2file_Callback(hObject, eventdata, handles)
% hObject    handle to save2file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filename
global locations_Rwave

documentname = [filename(1:end-4),'_HB']; %--- takes the sellected filename and cuts of the .mat extention
xlswrite(documentname,locations_Rwave); %--- Writes the xvalues of the selected peaks


% --- clips selected peaks from end of file; Executes on button press in curtail_detection.
function curtail_detection_Callback(hObject, eventdata, handles)
% hObject    handle to curtail_detection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Remove_xStart
global selection2remove
global selection_made
global MinX_Man_set
global MaxX_Man_set

if (selection2remove == 1 || selection_made == 1)
    uiwait(msgbox('First reset your selection'))
else

uiwait(msgbox('Select the starting point of the data to be excluded'))


%--- this is where the actual cut in the file is made
a = zeros(1,2);
[a,~] = ginput(1);

Remove_xStart = a(1); %-- the last x value that is taken into account

%setting the new bounderies for the analysis
    ylimits = ylim; % current y-axis limits
    hold on
    plot(handles.axes1,[Remove_xStart,Remove_xStart],[ylimits(1) ylimits(2)],'r');
    hold on
    
selection2remove = 1;
end


% --- A selection of the data to analyse is made; Executes on button press in keep_selection.
function keep_selection_Callback(hObject, eventdata, handles)
% hObject    handle to keep_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Keep_xStart
global Keep_xFinish
global selection_made
global selection2remove
global MinX_Man_set
global MaxX_Man_set

if (selection2remove == 1 || selection_made == 1)
    uiwait(msgbox('First reset the selection'))
else
    uiwait(msgbox('Select a start and finish point of your selection'))

    %--- this is where the actual new selection is made
    a = zeros(1,2);
    [a,~] = ginput(2);

    Keep_xStart = a(1);
    Keep_xFinish = a(2);
    
    %setting the new bounderies for the analysis
    ylimits = ylim; % current y-axis limits
    hold on
    plot(handles.axes1,[Keep_xStart,Keep_xStart],[ylimits(1) ylimits(2)],'r');
    hold on
    plot(handles.axes1,[Keep_xFinish,Keep_xFinish],[ylimits(1) ylimits(2)],'r');
    hold on
    
    selection_made = 1;
end


% Sets the start sample number for the analysis
function MinX_ManSelect_Callback(hObject, eventdata, handles)
% hObject    handle to MinX_ManSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Min_Manual_xvalue
global MinX_Man_set
global selection2remove
global selection_made
global MaxX_Man_set

if (selection2remove == 1 || selection_made == 1)
    uiwait(msgbox('First reset the selection'))
else
    Min_Manual_xvalue = str2double(get(handles.MinX_ManSelect, 'string'));

    %setting the new bounderies for the analysis
    ylimits = ylim; % current y-axis limits
    hold on
    plot(handles.axes1,[Min_Manual_xvalue,Min_Manual_xvalue],[ylimits(1) ylimits(2)],'r');
    hold on
       
    MinX_Man_set = 1;
end

% Hints: get(hObject,'String') returns contents of MinX_ManSelect as text
%        str2double(get(hObject,'String')) returns contents of MinX_ManSelect as a double


% --- Executes during object creation, after setting all properties.
function MinX_ManSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MinX_ManSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% Sets the stop sample number for the analysis
function MaxX_ManSelect_Callback(hObject, eventdata, handles)
% hObject    handle to MaxX_ManSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global Max_Manual_xvalue
global MaxX_Man_set
global selection2remove
global selection_made
global MinX_Man_set

if (selection2remove == 1 || selection_made == 1)
    uiwait(msgbox('First reset the selection'))
else
    Max_Manual_xvalue = str2double(get(handles.MaxX_ManSelect, 'string'));
    
    %setting the new bounderies for the analysis
    ylimits = ylim; % current y-axis limits
    hold on
    plot(handles.axes1,[Max_Manual_xvalue,Max_Manual_xvalue],[ylimits(1) ylimits(2)],'r');
    hold on
       
    MaxX_Man_set = 1;
end
% Hints: get(hObject,'String') returns contents of MaxX_ManSelect as text
%        str2double(get(hObject,'String')) returns contents of MaxX_ManSelect as a double


% --- Executes during object creation, after setting all properties.
function MaxX_ManSelect_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MaxX_ManSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



% --- Executes on button press in reset_selection.
function reset_selection_Callback(hObject, eventdata, handles)
% hObject    handle to reset_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global selection_made
global selection2remove
global Keep_xStart
global Keep_xFinish
global Remove_xStart
global Min_Manual_xvalue
global Max_Manual_xvalue
global MaxX_Man_set
global MinX_Man_set

if selection_made == 1

    %--- stores the current values as the previous values
    Previous_Keep_xStart = Keep_xStart;
    Previous_Keep_xFinish = Keep_xFinish;

    %--- plots the thresholds to be replaced in blue 
    ylimits = ylim; % current y-axis limits
    hold on
    plot(handles.axes1,[Previous_Keep_xStart,Previous_Keep_xStart],[ylimits(1) ylimits(2)],'b');
    hold on
    plot(handles.axes1,[Previous_Keep_xFinish,Previous_Keep_xFinish],[ylimits(1) ylimits(2)],'b');
    hold on
end

if selection2remove == 1
%--- stores the current values as the previous values
    Previous_Remove_xStart = Remove_xStart;

%plots the selected cut section to be replaced in blue
    ylimits = ylim; % current y-axis limits
    hold on
    plot(handles.axes1,[Previous_Remove_xStart,Previous_Remove_xStart],[ylimits(1) ylimits(2)],'b');
    hold on  
end

if MinX_Man_set == 1
    %--- stores the current values as the previous values
    Previous_Min_Manual_xvalue = Min_Manual_xvalue;
        
    %setting the new bounderies for the analysis
    ylimits = ylim; % current y-axis limits
    plot(handles.axes1,[Previous_Min_Manual_xvalue,Previous_Min_Manual_xvalue],[ylimits(1) ylimits(2)],'b');
    hold on
    
end

if MaxX_Man_set == 1
    %--- stores the current values as the previous values
    Previous_Max_Manual_xvalue = Max_Manual_xvalue;
    
    %setting the new bounderies for the analysis
    ylimits = ylim; % current y-axis limits
    plot(handles.axes1,[Previous_Max_Manual_xvalue,Previous_Max_Manual_xvalue],[ylimits(1) ylimits(2)],'b');
    hold on
end

selection2remove = 0;
selection_made = 0;
MinX_Man_set = 0;
MaxX_Man_set = 0;


% --- Executes on button press in apply_notch_filter.
function apply_notch_filter_Callback(hObject, eventdata, handles)
% hObject    handle to apply_notch_filter (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global ecg_data
global notch
global ecg_data_notch
if get(handles.apply_notch_filter,'Value')== 1
    Fs = 256;
d = designfilt('bandstopiir','FilterOrder',2, ...
               'HalfPowerFrequency1',48,'HalfPowerFrequency2',52, ...
               'DesignMethod','butter','SampleRate',Fs);
ecg_data_notch = filtfilt(d,ecg_data);
notch = 1;
else
    notch = 0;
end


% figure
% plot(t,ecg_data,t,ecg_data_notch)
% ylabel 'Voltage (V)', xlabel 'Time (s)'
% title 'Open-Loop Voltage', legend('Unfiltered','Filtered')




% --- Executes on button press in checkbox2.
function checkbox2_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox2



function edit8_Callback(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit8 as text
%        str2double(get(hObject,'String')) returns contents of edit8 as a double


% --- Executes during object creation, after setting all properties.
function edit8_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit8 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in reset_all.
function reset_all_Callback(hObject, eventdata, handles)
% hObject    handle to reset_all (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global reset_all
selection_made = 1;
