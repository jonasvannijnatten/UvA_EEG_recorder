function varargout = filterbank(varargin)
% FILTERBANK MATLAB code for filterbank.fig
%      FILTERBANK, by itself, creates a new FILTERBANK or raises the existing
%      singleton*.
%
%      H = FILTERBANK returns the handle to a new FILTERBANK or the handle to
%      the existing singleton*.
%
%      FILTERBANK('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTERBANK.M with the given input arguments.
%
%      FILTERBANK('Property','Value',...) creates a new FILTERBANK or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filterbank_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filterbank_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help filterbank

% Last Modified by GUIDE v2.5 03-Dec-2012 23:09:46

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filterbank_OpeningFcn, ...
                   'gui_OutputFcn',  @filterbank_OutputFcn, ...
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


% --- Executes just before filterbank is made visible.
function filterbank_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to filterbank (see VARARGIN)

% Choose default command line output for filterbank
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes filterbank wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = filterbank_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;



function l1_Callback(hObject, eventdata, handles)
global l1
l1 = str2double(get(hObject,'String')); return

function l1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function h1_Callback(hObject, eventdata, handles)
global h1
h1 = str2double(get(hObject,'String')); return

function h1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function filterbank_Callback(hObject, eventdata, handles)
global l1; global h1;
global datas; global Fs;
global EEG;
global energy;
global stop_on; global pass_on; global plot_on;
Fs = EEG.fsample;
l1 = str2double(get(handles.l1,'String'));
h1 = str2double(get(handles.h1,'String'));
if (get(handles.stop_on,'Value') == get(handles.stop_on,'Max'))
    stop_on =1;
else    
    stop_on=0;
end
if (get(handles.pass_on,'Value') == get(handles.pass_on,'Max'))
    pass_on =1;
else    
    pass_on=0;
end
if (get(handles.plot_on,'Value') == get(handles.plot_on,'Max'))
    plot_on =1;
else    
    plot_on=0;
end
[a b c] = size(datas);

% Find non-marker channels
noMarkerChannels = find(EEG.channelTypes~="Marker");

if c>1
   errordlg('This function only exepts vectors or 2D arrays','File Error');
else
        lb = l1/2; hb = h1/2;
                
    for k = 1:length(noMarkerChannels)
        NFFT = 2^nextpow2(a); % Next power of 2 from length of y
        Y = fft(datas(:,k),NFFT)/a;
        f = Fs/2*linspace(0,1,NFFT/2+1);
        Ylb_1 = round(2*lb*length(Y)/Fs)+1;
        Ylb_2 = length(Y)-round(2*lb*length(Y)/Fs)+1;
        Yhb_1 = round(2*hb*length(Y)/Fs)+1;
        Yhb_2 = length(Y)-round(2*hb*length(Y)/Fs)+1;
            if stop_on == 1
                Y(Ylb_1:Yhb_1)=0;
                Y(Yhb_2:Ylb_2)=0;
            end
            if pass_on == 1
                % Filter below lb
                Y(1:Ylb_1)=0;
                Y(Ylb_2:length(Y))=0;
                % Filter above hb
                Y(Yhb_1:length(Y)/2)=0;
                Y(length(Y)/2:Yhb_2)=0;
            end
            fY = ifft(Y);
            fY = fY(1:length(datas));
            t = 1:length(fY);
                if plot_on == 1
                    figure
                    subplot(2,1,1)
                    plot(t./Fs,datas(:,k))
                    title('Origenal signal f(t)')
                    subplot(2,1,2)
                    plot(t./Fs,fY)
                    title('Filtered signal f(t)')
                    
                    figure
                    subplot(2,1,1)
                    [a b c] = size(datas);
                    NFFT = 2^nextpow2(a); % Next power of 2 from length of y
                    Y = fft(datas(:,k),NFFT)/a;
                    f = Fs/2*linspace(0,1,NFFT/2+1);
                    plot(f,2*abs(Y(1:NFFT/2+1))) 
                    title('Origenal signal F(t)')
                    subplot(2,1,2)
                    [a b c] = size(fY);
                    NFFT = 2^nextpow2(a); % Next power of 2 from length of y
                    Y2 = fft(fY,NFFT)/a;
                    f = Fs/2*linspace(0,1,NFFT/2+1);
                    plot(f,2*abs(Y2(1:NFFT/2+1))) 
                    title('Filtered signal F(t)')
                end
                  energy(k)=var(fY);
                  datas(:,k)= fY;
    end
end

% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
global filename;global datas; global EEG;
[filename, EEG] = EEGLoadData('time');
 set(handles.fi_name,'string',filename);
 datas = EEG.data;
 [str1] = size(datas);
 str = num2str(str1);
set(handles.fi_size,'string',str);
clear data

function save_Callback(hObject, eventdata, handles)
global datas;
global EEG;
EEG.data = datas;
EEGSaveData(EEG, 'filter');
clear filename; clear EEG; clear datas;
str = ' ';
set(handles.fi_name,'string',str);
set(handles.fi_size,'string',str);

% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
web('Spectral_help.htm', '-helpbrowser')

function pass_on_Callback(hObject, eventdata, handles)
global pass_on
if (get(hObject,'Value') == get(hObject,'Max'))
    pass_on =1;
else    
    pass_on =0;
end

function stop_on_Callback(hObject, eventdata, handles)
global stop_on
if (get(hObject,'Value') == get(hObject,'Max'))
    cstop_on =1;
else    
    stop_on =0;
end

function plot_on_Callback(hObject, eventdata, handles)
global plot_on
if (get(hObject,'Value') == get(hObject,'Max'))
    plot_on =1;
else    
    plot_on =0;
end

% Hint: get(hObject,'Value') returns toggle state of plot_on
