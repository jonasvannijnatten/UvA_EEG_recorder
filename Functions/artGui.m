function varargout = artGui(varargin)
% ARTGUI MATLAB code for artGui.fig
%      ARTGUI, by itself, creates a new ARTGUI or raises the existing
%      singleton*.
%
%      H = ARTGUI returns the handle to a new ARTGUI or the handle to
%      the existing singleton*.
%
%      ARTGUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARTGUI.M with the given input arguments.
%
%      ARTGUI('Property','Value',...) creates a new ARTGUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before artGui_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to artGui_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help artGui

% Last Modified by GUIDE v2.5 21-May-2021 13:35:29

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @artGui_OpeningFcn, ...
                   'gui_OutputFcn',  @artGui_OutputFcn, ...
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


% --- Executes just before artGui is made visible.
function artGui_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to artGui (see VARARGIN)

% Choose default command line output for artGui
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes artGui wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = artGui_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in load_file.
function load_file_Callback(hObject, eventdata, handles)
% hObject    handle to load_file (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global filename
global art_data

curdir = cd;
[filename, pathname] = ...
    uigetfile({'*.mat';},'Select a recording file');
if any(filename)
    load(filename);
    art_data = data;  % drops data in the art_data array
end
    
set(handles.file_loaded,'string',filename)
set(handles.data_size_old, 'string', num2str(size(art_data)))
set(handles.data_size_clean, 'string', '')
set(handles.data_size_art, 'string', '')


function EEG_channels_Callback(hObject, eventdata, handles)
% hObject    handle to EEG_channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of EEG_channels as text
%        str2double(get(hObject,'String')) returns contents of EEG_channels as a double

global number_EEG_channels

%--- select the number of active EEG channels
number_EEG_channels = str2double(get(handles.EEG_channels, 'string'));

% --- Executes during object creation, after setting all properties.
function EEG_channels_CreateFcn(hObject, eventdata, handles)
% hObject    handle to EEG_channels (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function art_limit_Callback(hObject, eventdata, handles)
% hObject    handle to art_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of art_limit as text
%        str2double(get(hObject,'String')) returns contents of art_limit as a double
global art_limit

% Select the limit for artefacts in microvolts
art_limit = str2double(get(handles.art_limit, 'string'));


% --- Executes during object creation, after setting all properties.
function art_limit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to art_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in detect_art.
function detect_art_Callback(hObject, eventdata, handles)
% hObject    handle to detect_art (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global art_data
global number_EEG_channels
global art_limit
global filename

% Generate error message if either number of channels or artefact limit is
% not filled in
if isempty(art_limit)
    errordlg('Please enter a limit for detecting artefacts')
elseif isempty(number_EEG_channels)
    errordlg('Please enter the number of active EEG channels')
else
    % Get data of active EEG channels
    art_data_EEG = art_data(:, 1:number_EEG_channels, :);

    % Get number of samples, channels and trials
    [~, channels, trials] = size(art_data_EEG);

    % Create vectors for storing trials with artefact
    trials_art = [];

    % Loop over EEG channels
    for channel_nr = 1:channels

        % Loop over trials
        for trial_nr = 1:trials

            % Get data of current channel and trial and convert to microvolts
            trial_data_mV = art_data_EEG(:, channel_nr, trial_nr) * 1000000;

            % Check if trial contains data bigger than 100 mV (artefact)
            if (any(trial_data_mV > abs(art_limit)) || any(trial_data_mV < -abs(art_limit))) && ~ismember(trial_nr, trials_art)
                % Add trial number to list of trials with artefact
                trials_art = [trials_art, trial_nr];
            end
        end
    end

    % Put the numbers of trials with artefacts in right order
    trials_art_sorted = sort(trials_art);
    
    % Get indices of clean trials
    trials_clean = 1:trials;
    trials_clean(trials_art_sorted) = [];

    % Get artefact trials and save
    data = art_data(:, :, trials_art_sorted);
    set(handles.data_size_art, 'string', num2str(size(data)))
    filename_art = [filename, '_art'];
    curdir = cd;
    cd([curdir filesep]);
    uisave({'data'},filename_art);
    cd(curdir);

    clear data

    % Get clean trials and save
    data = art_data(:, :, trials_clean);
    set(handles.data_size_clean, 'string', num2str(size(data)))
    filename_clean = [filename, '_clean'];
    curdir = cd;
    cd([curdir filesep]);
    uisave({'data'},filename_clean);
    cd(curdir);
    
%     clear -global number_EEG_channels;
%     clear -global art_limit;
    clear -global art_data;
end
