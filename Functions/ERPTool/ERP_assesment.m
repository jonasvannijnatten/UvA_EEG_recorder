function varargout = ERP_assesment(varargin)
% ERP_ASSESMENT MATLAB code for ERP_assesment.fig
%      ERP_ASSESMENT, by itself, creates a new ERP_ASSESMENT or raises the existing
%      singleton*.
%
%      H = ERP_ASSESMENT returns the handle to a new ERP_ASSESMENT or the handle to
%      the existing singleton*.
%
%      ERP_ASSESMENT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ERP_ASSESMENT.M with the given input arguments.
%
%      ERP_ASSESMENT('Property','Value',...) creates a new ERP_ASSESMENT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before ERP_assesment_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to ERP_assesment_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help ERP_assesment

% Last Modified by GUIDE v2.5 11-Jun-2013 10:35:45

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @ERP_assesment_OpeningFcn, ...
                   'gui_OutputFcn',  @ERP_assesment_OutputFcn, ...
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


% --- Executes just before ERP_assesment is made visible.
function ERP_assesment_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to ERP_assesment (see VARARGIN)
global erp_data;
global assesment_data; % assesment_data = .... (copy from ERP tool)
% global corrected_data;
global filename;
global channelnr;
global labels;
global subjectcounter;
global totalnrofsubjects;
global onset;
global xlimit;
global ylimit;
global nrofsamples;
global samplingrate;
global samples;
global time;
global EEG;
% global browse_raw;
% global browse_corrected;
% global erp_std;
% if browse_raw
%     browse_data = erp_data;
% elseif browse_corrected
%     browse_data = corrected_data;
% end
assesment_data = erp_data;
subjectcounter = 1;
totalnrofsubjects = size(assesment_data,3);
nrofsamples = size(assesment_data,1);
samplingrate = EEG.fsample;
set(handles.subject_indicator, 'String', [num2str(subjectcounter) ' / ' num2str(totalnrofsubjects)]);
set(handles.filename,'string',filename);
set(handles.channel_display,'string',num2str(channelnr));
samples = 1:nrofsamples;
samples = samples-onset;
time = samples/samplingrate*1000;
plot(handles.axes1,time, assesment_data(:,channelnr,subjectcounter))
hold(handles.axes1,'on')
onset = onset/samplingrate;
set(handles.axes1, 'Xlim', [min(time) max(time)])
xlimit = get(gca,'xlim');  %Get x range 
hold on
plot(handles.axes1,[xlimit(1) xlimit(2)],[0 0],'k')
ylimit = get(gca,'ylim');  %Get x range 
hold on
plot(handles.axes1,[0 0], [ylimit(1) ylimit(2)], 'k')

% set(handles.axes1, 'Xlabel', 'samples/seconds')
% set(handles.axes1, 'Ylabel', 'microV')
xlabel('Time (ms)')
ylabel('Amplitude (microvolts)')
channellabels = EEG.channelLabels;
labels = channellabels(channelnr);
legend(labels);
hold off;
hold(handles.axes1,'off')
% Choose default command line output for ERP_assesment
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes ERP_assesment wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = ERP_assesment_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in next.
function next_Callback(hObject, eventdata, handles)
global assesment_data;
global subjectcounter;
global channelnr;
global labels;
global totalnrofsubjects;
global onset;
global xlimit;
global ylimit;
global samplingrate;
global time;
if subjectcounter == totalnrofsubjects
    subjectcounter = 1;
else
    subjectcounter = subjectcounter + 1;
end
set(handles.subject_indicator, 'String', [num2str(subjectcounter) ' / ' num2str(totalnrofsubjects)]);
hold(handles.axes1,'off')
plot(gca,time, assesment_data(:,channelnr,subjectcounter))
hold(handles.axes1,'on')
% onset = onset/samplingrate;
set(handles.axes1, 'Xlim', [min(time) max(time)])
xlimit = get(gca,'xlim');  %Get x range 
hold on
plot(handles.axes1,[xlimit(1) xlimit(2)],[0 0],'k')
ylimit = get(gca,'ylim');  %Get x range 
hold on
plot(handles.axes1,[0 0], [ylimit(1) ylimit(2)], 'k')
legend(labels);
xlabel('Time (ms)')
ylabel('Amplitude (µV)')
hold off;
hold(handles.axes1,'off')
% hObject    handle to next (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in previous.
function previous_Callback(hObject, eventdata, handles)
global assesment_data;
global subjectcounter;
global channelnr;
global labels;
global totalnrofsubjects;
global onset;
global xlimit;
global ylimit;
global samplingrate;
global time;

if subjectcounter == 1
    subjectcounter = totalnrofsubjects;
else
    subjectcounter = subjectcounter - 1;
end
set(handles.subject_indicator, 'String', [num2str(subjectcounter) ' / ' num2str(totalnrofsubjects)]);
hold(handles.axes1,'off')
plot(gca,time, assesment_data(:,channelnr,subjectcounter))
hold(handles.axes1,'on')
% onset = onset/samplingrate;
set(handles.axes1, 'Xlim', [min(time) max(time)])
xlimit = get(gca,'xlim');  %Get x range 
hold on
plot(handles.axes1,[xlimit(1) xlimit(2)],[0 0],'k')
ylimit = get(gca,'ylim');  %Get x range 
hold on
plot(handles.axes1,[0 0], [ylimit(1) ylimit(2)], 'k')
legend(labels)
xlabel('Time (ms)')
ylabel('Amplitude (µV)')
hold off;
hold(handles.axes1,'off')

% hObject    handle to previous (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function lower_limit_Callback(hObject, eventdata, handles)
global lower_limit;
% if isdouble(get(handles.lower_limit, 'Value'))
    lower_limit = get(handles.lower_limit, 'Value');
% else
%     lower_limit = 0;
% end

% hObject    handle to lower_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of lower_limit as text
%        str2double(get(hObject,'String')) returns contents of lower_limit as a double


% --- Executes during object creation, after setting all properties.
function lower_limit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to lower_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function upper_limit_Callback(hObject, eventdata, handles)
global upper_limit
upper_limit = get(handles.upper_limit, 'Value');
% axes1; hold on;
% hObject    handle to upper_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of upper_limit as text
%        str2double(get(hObject,'String')) returns contents of upper_limit as a double


% --- Executes during object creation, after setting all properties.
function upper_limit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to upper_limit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in lower_plus.
function lower_plus_Callback(hObject, eventdata, handles)
global lower_limit;
lower_limit = lower_limit + 1;
set(handles.lower_limit, 'String', lower_limit);
% hObject    handle to lower_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in lower_min.
function lower_min_Callback(hObject, eventdata, handles)
global lower_limit;
lower_limit = lower_limit - 1;
set(handles.lower_limit, 'String', lower_limit);
% hObject    handle to lower_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in upper_min.
function upper_min_Callback(hObject, eventdata, handles)
global upper_limit;
upper_limit = upper_limit - 1;
set(handles.upper_limit, 'String', upper_limit);
% hObject    handle to upper_min (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in upper_plus.
function upper_plus_Callback(hObject, eventdata, handles)
global upper_limit;
upper_limit = upper_limit + 1;
set(handles.upper_limit, 'String', upper_limit);
% hObject    handle to upper_plus (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in assesment.
function assesment_Callback(hObject, eventdata, handles)
% hObject    handle to assesment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% temp = str2double(get(handles.lower_limit, 'String'))
global lower_limit;
global upper_limit;
global onset;
global assesment_data;
global channelnr;
global subjectcounter;
global samplingrate;
global time;
global labels;
% global lower_limit;
% global upper_limit;
if isnumeric(str2double(get(handles.lower_limit, 'String')))
    lower_limit = str2double(get(handles.lower_limit, 'String'));
else
    errordlg('enter a lower limit')    
end
if isnumeric(str2double(get(handles.upper_limit, 'String')))
    upper_limit = str2double(get(handles.upper_limit, 'String'));
else
    errordlg('enter a lower limit')
end
hold(handles.axes1,'off')
plot(gca,time, assesment_data(:,channelnr,subjectcounter))
hold(handles.axes1,'on')
% onset = onset/samplingrate;
temp = get(handles.axes1);
set(handles.axes1, 'Xlim', [min(time) max(time)])
xlimit = get(gca,'xlim');  %Get x range 
ylimit = get(gca,'ylim');  %Get x range 
hold on
plot(handles.axes1,[xlimit(1) xlimit(2)],[0 0],'k')
plot(handles.axes1,[0 0], [ylimit(1) ylimit(2)], 'k')

plot(handles.axes1, [lower_limit lower_limit], [ylimit(1) ylimit(2)], 'r')
plot(handles.axes1, [upper_limit upper_limit], [ylimit(1) ylimit(2)], 'r')

legend(labels);
xlabel('Time (ms)')
ylabel('Amplitude(microvolts)')
hold off;
hold(handles.axes1,'off')

% for assesment calculate time(ms) to sample nr
lo_limit =  round((lower_limit/1000+onset)*samplingrate);
up_limit =  round((upper_limit/1000+onset)*samplingrate);

max_y = max(assesment_data(lo_limit:up_limit,channelnr,subjectcounter));
max_x = find(assesment_data(lo_limit:up_limit,channelnr,subjectcounter) == max_y)+lo_limit-1;
max_x_time = (max_x/samplingrate-onset)*1000;
set(handles.xmax, 'String', num2str(max_x_time));
set(handles.ymax, 'String', num2str(max_y));
min_y = min(assesment_data(lo_limit:up_limit,channelnr,subjectcounter));
min_x = find(assesment_data(lo_limit:up_limit,channelnr,subjectcounter) == min_y)+lo_limit-1;
min_x_time = (min_x/samplingrate-onset)*1000;
set(handles.xmin, 'String', num2str(min_x_time));
set(handles.ymin, 'String', num2str(min_y));
hold on
plot(handles.axes1, max_x_time, max_y, '*r')
plot(handles.axes1, min_x_time, min_y, '*r')

average_y = mean(assesment_data(lo_limit:up_limit,channelnr,subjectcounter));
set(handles.average_amplitude, 'String', num2str(average_y))
% component_min = min(assesment_data(lo_limit:up_limit,channelnr,subjectcounter))*1000000;

pos_y   = max(assesment_data(lo_limit:up_limit,channelnr,subjectcounter),0);
pos_auc = trapz(1:length(pos_y),pos_y);
neg_y   = min(assesment_data(lo_limit:up_limit,channelnr,subjectcounter),0);
neg_auc = trapz(1:length(neg_y),neg_y);
set(handles.pos_auc, 'String', num2str(pos_auc));
set(handles.neg_auc, 'String', num2str(neg_auc));


% --------------------------------------------------------------------
function Help_assesment_Callback(hObject, eventdata, handles)
web('Help_assesment.htm', '-helpbrowser')
% hObject    handle to Help_assesment (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
