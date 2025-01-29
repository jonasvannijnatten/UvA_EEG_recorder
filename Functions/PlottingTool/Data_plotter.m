function varargout = Data_plotter(varargin)
% DATA_PLOTTER MATLAB code for Data_plotter.fig
%      DATA_PLOTTER, by itself, creates a new DATA_PLOTTER or raises the existing
%      singleton*.
%
%      H = DATA_PLOTTER returns the handle to a new DATA_PLOTTER or the handle to
%      the existing singleton*.
%
%      DATA_PLOTTER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in DATA_PLOTTER.M with the given input arguments.
%
%      DATA_PLOTTER('Property','Value',...) creates a new DATA_PLOTTER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Data_plotter_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Data_plotter_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Data_plotter

% Last Modified by GUIDE v2.5 20-Dec-2018 15:05:47

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Data_plotter_OpeningFcn, ...
    'gui_OutputFcn',  @Data_plotter_OutputFcn, ...
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


% --- Executes just before Data_plotter is made visible.
function Data_plotter_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Data_plotter (see VARARGIN)

% Choose default command line output for Data_plotter
handles.output = hObject;
if isempty(varargin)
    warndlg('Unable to open this tool directly, open it from the EEG_recorder main function')
    handles.closeFigure = true;
else
    handles.dir = varargin{1}.dir;
end
% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Data_plotter wait for user response (see UIRESUME)
% uiwait(handles.figure1);
function varargout = Data_plotter_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject)

% --- Outputs from this function are returned to the command line.
function varargout = Data_plotter_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
if (isfield(handles,'closeFigure') && handles.closeFigure)
      Data_plotter_CloseRequestFcn(hObject, eventdata, handles)
end

function chan2plot_Callback(hObject, eventdata, handles)
return
function chan2plot_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plot_Callback(hObject, eventdata, handles)
x_ax = get(handles.x_ax,'String'); % get x limits
y_ax = get(handles.y_ax,'String'); % get y limits
strp = get(handles.chan2plot,'String'); % get selection to plot
Fsp = handles.Fs; % get sampling rate
onset = str2double(get(handles.onset, 'String')); % get stim-onset sample
if isempty(onset)
    onset = 0;
end
if (get(handles.row_on,'Value') == get(handles.row_on,'Max'))
    row_on = 1;
else
    row_on = 0;
end
if (get(handles.Collumns_on,'Value') == get(handles.Collumns_on,'Max'))
    Collumns_on = 1;
else
    Collumns_on = 0;
end


nr_of_cols = size(handles.data,2);
% get the dimensions to plot as separate lines
dimension = [eval(strp)];
% loop over the selected dimensions
for Idx = 1:length(dimension)
    if Collumns_on == 1
        % depending on the data domain, use appropriate axis labels
        if strcmp(handles.EEG.domain, "time")
            time = handles.EEG.time;
            plot(time,handles.data(:,dimension(Idx)));hold on %plot signal in microvolts
            xlabel('Time (s)')
        elseif strcmp(handles.EEG.domain, "frequency")
            frequency = handles.EEG.frequency;
            plot(frequency, handles.data(:,dimension(Idx))); hold on
            xlabel('Frequency (Hz)')
            if isfield(handles.EEG, 'powerUnit')
                ylabel(handles.EEG.powerUnit)
            else
                ylabel('Power (dB)')
            end
        end
    elseif row_on == 1
        plot((1:nr_of_cols)./Fsp,handles.data(dimension(Idx),:));hold on %plot signal in microvolts
    end
end

% Use user defined limits (if any)
if ~isempty(x_ax)
    xlim(str2num(x_ax));
else
    % otherwise get min and max values of data in selected dimension
    if strcmp(handles.EEG.domain, "time")
        xlim([min(time) max(time)])
    elseif strcmp(handles.EEG.domain, "frequency")
        xlim([min(frequency) max(frequency)])
    end
end
if ~isempty(y_ax)
    ylim((str2num(y_ax))); % set Ylim in uVolts
end


if strcmp(handles.EEG.domain, 'frequency')
    ylabel('Power (dB)')

    % TO-DO: use unit of power as calculated in TF analysis tool.
    % Need to double check whether it is exported correctly in that tool.
    % ylabel(handles.EEG.powerUnit)
else
    ylabel('EEG Amplitude (microvolts)')
    % add zero line
    xlimit = get(gca, 'xlim');
    ylimit = get(gca, 'ylim');
    hold on
    plot([xlimit(1) xlimit(2)],[0 0],'k')
    plot([0 0], [ylimit(1) ylimit(2)], 'k')
end

% add legend with arbitraty entries
% best to update to info to be added to the EEG struct
labels = {'data 1','data 2','data 3','data 4','data 5',...
    'data 6','data 7','data 8','data 9','data 10','data 11','data 12','data 13','data 14'};
labeling = labels(dimension);
legend(labeling,'Location','NorthEastOutside');
hold off
title(handles.filename,'Interpreter','none')

% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
[filename, EEG] = EEGLoadData(["time","frequency"]);
if any(filename)
    handles.EEG = EEG;
    handles.data = EEG.data;
    handles.Fs = EEG.fsample;
    handles.filename= filename;
    set(handles.filename_txt,'string',filename);
    set(handles.filesize_txt,'string',num2str(size(handles.data)));
end
 guidata(hObject,handles);
% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
web('Plotter_help.html', '-helpbrowser')

function row_on_Callback(hObject, eventdata, handles)

function Collumns_on_Callback(hObject, eventdata, handles)

function x_ax_Callback(hObject, eventdata, handles)
global x_ax
x_ax = str2double(get(hObject,'String')); return

function x_ax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function y_ax_Callback(hObject, eventdata, handles)
global y_ax
y_ax = str2double(get(hObject,'String'));return
function y_ax_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function onset_Callback(hObject, eventdata, handles)
% hObject    handle to onset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of onset as text
%        str2double(get(hObject,'String')) returns contents of onset as a double

function onset_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
