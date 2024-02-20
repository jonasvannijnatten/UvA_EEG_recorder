function varargout = trial_browser(varargin)
% TRIAL_BROWSER MATLAB code for trial_browser.fig
%      TRIAL_BROWSER, by itself, creates a new TRIAL_BROWSER or raises the existing
%      singleton*.
%
%      H = TRIAL_BROWSER returns the handle to a new TRIAL_BROWSER or the handle to
%      the existing singleton*.
%
%      TRIAL_BROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRIAL_BROWSER.M with the given input arguments.
%
%      TRIAL_BROWSER('Property','Value',...) creates a new TRIAL_BROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before trial_browser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to trial_browser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help trial_browser

% Last Modified by GUIDE v2.5 09-Mar-2017 11:11:18

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @trial_browser_OpeningFcn, ...
    'gui_OutputFcn',  @trial_browser_OutputFcn, ...
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


% --- Executes just before trial_browser is made visible.
function trial_browser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to trial_browser (see VARARGIN)
global erp_data;
global browse_data; % browse_data = .... (copy from ERP tool)
global corrected_data;
global filename;
global channelnr;
global labels;
global trialcounter;
global totalnroftrials;
global onset;
global xlimit;
global browse_ymax;
global browse_ymin;
global ylimit;
global nrofsamples;
global samplingrate;
global samples;
global time;
global browse_raw;
global browse_corrected;
global ERP_mean
global ERP_SD
global EEG
% global erp_std;
if browse_raw
    browse_data = erp_data;
elseif browse_corrected
    browse_data = corrected_data;
end
trialcounter = 1;
totalnroftrials = size(browse_data,3);
nrofsamples = size(browse_data,1);
samplingrate = EEG.fsample;
set(handles.trial_indicator, 'String', [num2str(trialcounter) ' / ' num2str(totalnroftrials)]);
set(handles.filename,'string',filename);
set(handles.channel_display,'string',num2str(channelnr));
samples = 1:nrofsamples;
samples = samples-onset;
time = samples/samplingrate*1000;
hold(handles.axes1,'on')

SD_range = str2double(get(handles.SD_range, 'String'));
% for itrial = 1:totalnroftrials
%     plot(handles.axes1,time,browse_data(:,channelnr,itrial),'b')
% end

ERP_SD = zeros(nrofsamples,1);
for isample = 1: size(browse_data,1)
    ERP_SD(isample) = std(browse_data(isample,channelnr,:));
end
ERP_mean = mean(browse_data(:,channelnr,:),3);

plot(handles.axes1,time, ERP_mean + SD_range*ERP_SD, ':r')
plot(handles.axes1,time, ERP_mean - SD_range*ERP_SD, ':r')
plot(handles.axes1,time, ERP_mean,'r', 'LineWidth', 1)
plot(handles.axes1,time, browse_data(:,channelnr,trialcounter),'b', 'LineWidth', 1)

labeling = {'SD', 'SD','Mean','Current trial'};
legend(labeling, 'Location','Best')

onset = onset/samplingrate;
browse_ymax = max(max(browse_data(:,channelnr,:)));
browse_ymin = min(min(browse_data(:,channelnr,:)));
set(handles.axes1, 'Xlim', [min(time) max(time)]) % set Xlim to exactly fit the time axis.
set(handles.axes1, 'Ylim', [min(browse_ymin) max(browse_ymax)])
xlimit = get(gca,'xlim');  %Get x range
hold on
plot(handles.axes1,[xlimit(1) xlimit(2)],[0 0],'k')
ylimit = get(gca,'ylim');  %Get y range
hold on
plot(handles.axes1,[0 0], [ylimit(1) ylimit(2)], 'k')

% set(handles.axes1, 'Xlabel', 'samples/seconds')
% set(handles.axes1, 'Ylabel', 'microV')
xlabel('Time (ms)')
ylabel('Amplitude (�V)')
channellabels = EEG.channelLabels;
labels = channellabels(channelnr);
% legend(labels);
hold off;
hold(handles.axes1,'off')
% Choose default command line output for trial_browser
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);


% UIWAIT makes trial_browser wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = trial_browser_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
global browse_data;
global trialcounter;
global channelnr;
% global labels;
global totalnroftrials;
% global onset;
global xlimit;
global ylimit;
global browse_ymax;
global browse_ymin;
% global samplingrate;
global time;
global ERP_mean
global ERP_SD
if trialcounter == totalnroftrials
    trialcounter = 1;
else
    trialcounter = trialcounter + 1;
end
set(handles.trial_indicator, 'String', [num2str(trialcounter) ' / ' num2str(totalnroftrials)]);
SD_range = str2double(get(handles.SD_range, 'String'));
hold(handles.axes1,'off')
plot(handles.axes1,time, ERP_mean + SD_range*ERP_SD, ':r')
hold(handles.axes1,'on')
plot(handles.axes1,time, ERP_mean - SD_range*ERP_SD, ':r')
plot(handles.axes1,time, ERP_mean,'r', 'LineWidth', 1)
plot(handles.axes1,time, browse_data(:,channelnr,trialcounter),'b', 'LineWidth', 1)
hold(handles.axes1,'on')
% onset = onset/samplingrate;
set(handles.axes1, 'Xlim', [min(time) max(time)])
set(handles.axes1, 'Ylim', [min(browse_ymin) max(browse_ymax)])
xlimit = get(gca,'xlim');  %Get x range
hold on

plot(handles.axes1,[xlimit(1) xlimit(2)],[0 0],'k')
ylimit = get(gca,'ylim');  %Get x range
hold on
plot(handles.axes1,[0 0], [ylimit(1) ylimit(2)], 'k')
labeling = {'SD', 'SD','Mean','Current trial'};
legend(labeling, 'Location','Best')
xlabel('Time (ms)')
ylabel('Amplitude (�V)')
hold off;
hold(handles.axes1,'off')
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in previous.
function previous_Callback(hObject, eventdata, handles)
global browse_data;
global trialcounter;
global channelnr;
% global labels;
global totalnroftrials;
% global onset;
global xlimit;
global ylimit;
global browse_ymax;
global browse_ymin;
% global samplingrate;
global time;
global ERP_mean
global ERP_SD
if trialcounter == 1
    trialcounter = totalnroftrials;
else
    trialcounter = trialcounter - 1;
end
set(handles.trial_indicator, 'String', [num2str(trialcounter) ' / ' num2str(totalnroftrials)]);
SD_range = str2double(get(handles.SD_range, 'String'));
hold(handles.axes1,'off')
plot(handles.axes1,time, ERP_mean + SD_range*ERP_SD, ':r')
hold(handles.axes1,'on')
plot(handles.axes1,time, ERP_mean - SD_range*ERP_SD, ':r')
plot(handles.axes1,time, ERP_mean,'r', 'LineWidth', 1)
plot(handles.axes1,time, browse_data(:,channelnr,trialcounter),'b', 'LineWidth', 1)
hold(handles.axes1,'on')
% onset = onset/samplingrate;
set(handles.axes1, 'Xlim', [min(time) max(time)])
set(handles.axes1, 'Ylim', [min(browse_ymin) max(browse_ymax)])
xlimit = get(gca,'xlim');  %Get x range
hold on
plot(handles.axes1,[xlimit(1) xlimit(2)],[0 0],'k')
ylimit = get(gca,'ylim');  %Get x range
hold on
plot(handles.axes1,[0 0], [ylimit(1) ylimit(2)], 'k')
labeling = {'SD', 'SD','Mean','Current trial'};
legend(labeling, 'Location','Best')
xlabel('Time (ms)')
ylabel('Amplitude (�V)')
hold off;
hold(handles.axes1,'off')

% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function SD_range_Callback(hObject, eventdata, handles)
% hObject    handle to SD_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SD_range as text
%        str2double(get(hObject,'String')) returns contents of SD_range as a double


% --- Executes during object creation, after setting all properties.
function SD_range_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SD_range (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)
% hObject    handle to Untitled_1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
