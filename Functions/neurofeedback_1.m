function varargout = neurofeedback_1(varargin)
% NEUROFEEDBACK_1 MATLAB code for neurofeedback_1.fig
%      NEUROFEEDBACK_1, by itself, creates a new NEUROFEEDBACK_1 or raises the existing
%      singleton*.
%
%      H = NEUROFEEDBACK_1 returns the handle to a new NEUROFEEDBACK_1 or the handle to
%      the existing singleton*.
%
%      NEUROFEEDBACK_1('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in NEUROFEEDBACK_1.M with the given input arguments.
%
%      NEUROFEEDBACK_1('Property','Value',...) creates a new NEUROFEEDBACK_1 or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before neurofeedback_1_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to neurofeedback_1_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help neurofeedback_1

% Last Modified by GUIDE v2.5 20-May-2013 20:01:11

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @neurofeedback_1_OpeningFcn, ...
                   'gui_OutputFcn',  @neurofeedback_1_OutputFcn, ...
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


% --- Executes just before neurofeedback_1 is made visible.
function neurofeedback_1_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to neurofeedback_1 (see VARARGIN)

% Choose default command line output for neurofeedback_1
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes neurofeedback_1 wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = neurofeedback_1_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in freq_selection.
function freq_selection_Callback(hObject, eventdata, handles)
% hObject    handle to freq_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns freq_selection contents as cell array
%        contents{get(hObject,'Value')} returns selected item from freq_selection


% --- Executes during object creation, after setting all properties.
function freq_selection_CreateFcn(hObject, eventdata, handles)
% hObject    handle to freq_selection (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function lo_bound_Callback(hObject, eventdata, handles)
% hObject    handle to lo_bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lo_bound as text
%        str2double(get(hObject,'String')) returns contents of lo_bound as a double


% --- Executes during object creation, after setting all properties.
function lo_bound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lo_bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function up_bound_Callback(hObject, eventdata, handles)
% hObject    handle to up_bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of up_bound as text
%        str2double(get(hObject,'String')) returns contents of up_bound as a double


% --- Executes during object creation, after setting all properties.
function up_bound_CreateFcn(hObject, eventdata, handles)
% hObject    handle to up_bound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function fb_duration_Callback(hObject, eventdata, handles)
% hObject    handle to fb_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fb_duration as text
%        str2double(get(hObject,'String')) returns contents of fb_duration as a double


% --- Executes during object creation, after setting all properties.
function fb_duration_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fb_duration (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in fb_start.
function fb_start_Callback(hObject, eventdata, handles)
% hObject    handle to fb_start (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear data

daqinfo = daqhwinfo('gmlplusdaq');
comport = str2double(daqinfo.InstalledBoardIds{1});
ai = analoginput('gmlplusdaq',comport);
addchannel(ai,1:8);
% num_chan = 8;

fb_duration = str2double(get(handles.fb_duration, 'String'));
Fs = 256;
set(ai,'SamplesPerTrigger',fb_duration*Fs);

screenid = max(Screen('Screens'));
[window rect] = Screen('OpenWindow', screenid, [0 0 0]);
tekstgrootte = 18;
Screen('TextFont', window, 'Arial');
Screen('TextSize', window, tekstgrootte);
Screen('TextStyle', window, 1); % 0=normal, 1=bold, 2=italic, 4=underlined, 8=outline
Screen('FillRect', window, [0 0 0]);
Screen('DrawLine')

Screen('Flip', window);



start(ai)

fb_window = str2double(get(handles.fb_window,'String'));

while ai.SamplesAcquired <= fb_window
    %Wait for samples
end
ai.SamplesAcquired



while ai.SamplesAcquired < fb_duration * Fs
    data = peekdata(ai,fb_window);
    
    %% !!!! here only channel 1 is used !! %%
    L=length(data(:,1));
    %% 
    
    NFFT = 2^nextpow2(L);
    Yo = fft(data(:,1),NFFT)/L;
%     fo = Fs/2*linspace(0,1,NFFT/2+1);
    freq_power = 2*abs(Yo(1:NFFT/2+1));
    
end


function fb_window_Callback(hObject, eventdata, handles)
% hObject    handle to fb_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of fb_window as text
%        str2double(get(hObject,'String')) returns contents of fb_window as a double


% --- Executes during object creation, after setting all properties.
function fb_window_CreateFcn(hObject, eventdata, handles)
% hObject    handle to fb_window (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
