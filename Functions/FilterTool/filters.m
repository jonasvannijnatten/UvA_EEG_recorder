function varargout = filters(varargin)
% FILTERS MATLAB code for filters.fig
%      FILTERS, by itself, creates a new FILTERS or raises the existing
%      singleton*.
%
%      H = FILTERS returns the handle to a new FILTERS or the handle to
%      the existing singleton*.
%
%      FILTERS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in FILTERS.M with the given input arguments.
%
%      FILTERS('Property','Value',...) creates a new FILTERS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before filters_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to filters_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help filters

% Last Modified by GUIDE v2.5 24-Feb-2014 20:22:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @filters_OpeningFcn, ...
                   'gui_OutputFcn',  @filters_OutputFcn, ...
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

function filters_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;

guidata(hObject, handles);
% UIWAIT makes filters wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function varargout = filters_OutputFcn(hObject, eventdata, handles) 
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
global filter_data; 
global Fs; Fs = 256;
global power;
global stop_on; global pass_on; global plot_on;
l1 = str2double(get(handles.l1,'String'));
h1 = str2double(get(handles.h1,'String'));
if (get(handles.stop_on,'Value') == get(handles.stop_on,'Max'))
    stop_on = 1;
else    
    stop_on = 0;
end
if (get(handles.pass_on,'Value') == get(handles.pass_on,'Max'))
    pass_on = 1;
else    
    pass_on = 0;
end
if (get(handles.plot_on,'Value') == get(handles.plot_on,'Max'))
    plot_on = 1;
else    
    plot_on = 0;
end
[a b c] = size(filter_data);

if (get(handles.eight_chan, 'Value') == get(handles.eight_chan, 'Max')) && b>8
    b = 8;
    % If data contains digital input channels (triggers) only apply filter to analog input,
    % Jonas
end

if c>1
   errordlg('This function only accepts vectors or 2D arrays','File Error');
else
    lb = l1/2; hb = h1/2;
    for k = 1:b
        NFFT = 2^nextpow2(a); % Next power of 2 from length of y
        Y = fft(filter_data(:,k),NFFT)/a;
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
                Y(1:Ylb_1)=0;
                Y(Ylb_2:length(Y))=0;
                Y(Yhb_1:length(Y)/2)=0;
                Y(length(Y)/2:Yhb_2)=0;
            end
            fY = ifft(Y)*a; % Jonas edit: added '*a' in order to maintain signal scale
            fY = fY(1:length(filter_data));
            t = 1:length(fY);
                if plot_on == 1
                    max_y1 = max(filter_data(:,k));
                    min_y1 = min(filter_data(:,k));
                    max_y2 = max(fY);
                    min_y2 = min(fY);
                    max_y = max([max_y1 max_y2]);
                    min_y = min([min_y1 min_y2]);
                    figure
                    subplot(2,1,1)
                    plot(t./Fs,filter_data(:,k))
                    title('Original signal f(t)')
                    ylim([min_y max_y]);
                    subplot(2,1,2)
                    plot(t./Fs,fY)
                    title('Filtered signal f(t)')
                    ylim([min_y max_y]);
                    suptitle(['Time domain  channel/trial: ' num2str(k)])
                    
                    figure
                    subplot(2,1,1)
                    [a b c] = size(filter_data);
                    NFFT = 2^nextpow2(a);
                    Y = fft(filter_data(:,k),NFFT)/a;
                    f = Fs/2*linspace(0,1,NFFT/2+1);
                    plot(f,2*abs(Y(1:NFFT/2+1))) 
                    title('Original signal F(t)')
                    subplot(2,1,2)
                    [a b c] = size(fY);
                    NFFT = 2^nextpow2(a);
                    Y2 = fft(fY,NFFT)/a;
                    f = Fs/2*linspace(0,1,NFFT/2+1);
                    plot(f,2*abs(Y2(1:NFFT/2+1))) 
                    title('Filtered signal F(t)')
                    suptitle(['Frequency domain  channel/trial: ' num2str(k)])
                end
                Y2 = fft(fY,NFFT)/a;
                selection = find(f>l1 & f<h1);
                power(k)= mean(2*abs(Y2(selection)));
                filter_data(:,k)= fY;
    end
end
msgbox('Data filtered')

% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
global filename;
global filter_data
curdir = cd;
cd([curdir filesep 'data']);
[filename, pathname] = ...
    uigetfile({'*.mat';},'Select a 2D array');
if any(filename)
    set(handles.fi_name,'string',filename);
    load([pathname filename]);
    filter_data = data;
    [str1] = size(filter_data);
    str = num2str(str1);
    set(handles.fi_size,'string',str);
    clear data
end
cd(curdir);

function save_Callback(hObject, eventdata, handles)
global filter_data;
global power;
data = filter_data;
curdir = cd;
cd([curdir filesep 'data']);
uisave({'data'},'Name');
cd(curdir);
clear filename; clear data; clear filter_data;
str = ' ';
set(handles.fi_name,'string',str);
set(handles.fi_size,'string',str);
curdir = cd;
cd([curdir filesep 'data']);
uisave({'power'},'Power');
cd(curdir);
clear power;

% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
web('Help_Filter.htm', '-helpbrowser')

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
    stop_on =1;
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
