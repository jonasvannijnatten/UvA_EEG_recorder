function varargout = Event_cutter(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Event_cutter_OpeningFcn, ...
                   'gui_OutputFcn',  @Event_cutter_OutputFcn, ...
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
function Event_cutter_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.dir = varargin{1}.dir;
guidata(hObject, handles);
function varargout = Event_cutter_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;
function row_nr_Callback(hObject, eventdata, handles)
global row_nr
row_nr = str2double(get(hObject,'String'));
function row_nr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function col_nr_Callback(hObject, eventdata, handles)
global col_nr
col_nr = str2double(get(hObject,'String'));
function col_nr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% function gr_dan_Callback(hObject, eventdata, handles)
% global gr_dan
% gr_dan = str2double(get(hObject,'String'));
% function gr_dan_CreateFcn(hObject, eventdata, handles)
% if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
%     set(hObject,'BackgroundColor','white');
% end
function beg_Callback(hObject, eventdata, handles)
global beg
beg = str2double(get(hObject,'String'));
function beg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function eind_Callback(hObject, eventdata, handles)
global eind
eind = str2double(get(hObject,'String'));
function eind_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cut_Callback(hObject, eventdata, handles)
global cut_sections;cut_sections=[];global data9
global col_nr;
global gr_dan;
global beg;global eind;
col_nr = str2double(get(handles.col_nr,'String'));
% gr_dan = str2double(get(handles.gr_dan,'String'));
beg = str2double(get(handles.beg,'String'));
eind = str2double(get(handles.eind,'String'));

gr_dan = 4; % hoogte van TTLs, kan aangepast worden
for i = 2:length(data9)
    if diff(data9(i-1:i,col_nr)) >= gr_dan
        sec = data9(i-beg:i+eind,:);
        if isempty(cut_sections )==1
            cut_sections  = sec;
        else
            cut_sections  = cat(3,cut_sections,sec);
        end
    end
end

data = cut_sections;
curdir = cd;
cd([curdir filesep 'Data']);
uisave({'data'},'Name');
cd(curdir);
% cut_sections = [];
[str1] = size(data);
str = num2str(str1);
set(handles.file_size_new,'string',str);

clear data9; clear data; clear cut_sections;
str = ' ';
set(handles.load_name,'string',' ' );


% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
global filename; global data9
curdir = cd;
cd([curdir filesep 'data']);
[filename, pathname] = ...
    uigetfile({'*.mat';},'Select a 2D array');
cd(curdir);
if ~isempty(filename)
    load([pathname filename]);
    data9 = data;
    [a b c] = size(data9);
    if c>1
        errordlg('This function only accepts 2D input','Dimension error');
        clear data;
        set(handles.file_size_old,'string',' ');
        set(handles.file_size_new,'string',' ');
        set(handles.load_name,'string',' ');
    end
    set(handles.load_name,'string',filename)
    [str1] = size(data9);
    str = num2str(str1);
    set(handles.file_size_old,'string',str);
    set(handles.file_size_new,'string',' ');
end

% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
web('Event_cutter_help.html', '-helpbrowser')
function t_bev_Callback(hObject, eventdata, handles)
global t_bev
t_bev = str2double(get(hObject,'String')); return
function t_bev_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function event_t_Callback(hObject, eventdata, handles)
global event_t
event_t = str2double(get(hObject,'String')); return
function event_t_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function t_aft_Callback(hObject, eventdata, handles)
global t_aft
t_aft = str2double(get(hObject,'String')); return
function t_aft_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function per_Callback(hObject, eventdata, handles)
global per
per = str2double(get(hObject,'String')); return
function per_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function num_cuts_Callback(hObject, eventdata, handles)
global num_cuts
num_cuts = str2double(get(hObject,'String')); return
function num_cuts_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function cut_at_t_Callback(hObject, eventdata, handles)
global t_bev;global t_aft;global per;global num_cuts;
global event_t; global data9; global cuts;cuts=[];
t_bev = round(256*str2double(get(handles.t_bev,'String')));
t_aft = round(256*str2double(get(handles.t_aft,'String')));
per = round(256*str2double(get(handles.per,'String')));
num_cuts = str2double(get(handles.num_cuts,'String'));
event_t = round(256*str2double(get(handles.event_t,'String')));
t1 = event_t-t_bev;
t2= event_t+t_aft;
for k = 1:num_cuts
        ht1 = t1+((k-1)*per);
        ht2 = t2+((k-1)*per);
        cut = data9(ht1:ht2,:);
        if isempty(cuts)
            cuts = cut;
        else
            cuts = cat(3,cuts,cut);
        end
end
data = cuts;
uisave({'data'},'Name');
clear data9; clear data; clear cuts;clear cut;
str = ' ';
set(handles.load_name,'string',str);

[str1] = size(data9);
str = num2str(str1);
set(handles.file_size_new,'string',str);
