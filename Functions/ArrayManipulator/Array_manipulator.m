function varargout = Array_manipulator(varargin)
% ARRAY_MANIPULATOR MATLAB code for Array_manipulator.fig
%      ARRAY_MANIPULATOR, by itself, creates a new ARRAY_MANIPULATOR or raises the existing
%      singleton*.
%
%      H = ARRAY_MANIPULATOR returns the handle to a new ARRAY_MANIPULATOR or the handle to
%      the existing singleton*.
%
%      ARRAY_MANIPULATOR('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in ARRAY_MANIPULATOR.M with the given input arguments.
%
%      ARRAY_MANIPULATOR('Property','Value',...) creates a new ARRAY_MANIPULATOR or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Array_manipulator_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Array_manipulator_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Array_manipulator

% Last Modified by GUIDE v2.5 12-Jun-2013 16:09:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Array_manipulator_OpeningFcn, ...
    'gui_OutputFcn',  @Array_manipulator_OutputFcn, ...
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

function Array_manipulator_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
guidata(hObject, handles);

function varargout = Array_manipulator_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;

function col_b_Callback(hObject, eventdata, handles)
global col_b
col_b = str2double(get(hObject,'String'));

function col_b_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function col_e_Callback(hObject, eventdata, handles)
global col_e
col_e = str2double(get(hObject,'String'));

function col_e_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function row_b_Callback(hObject, eventdata, handles)
global row_b
row_b = str2double(get(hObject,'String'));

function row_b_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function row_e_Callback(hObject, eventdata, handles)
global row_e
row_e = str2double(get(hObject,'String'));

function row_e_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function third_b_Callback(hObject, eventdata, handles)
global third_b
third_b = str2double(get(hObject,'String'));

function third_b_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function third_e_Callback(hObject, eventdata, handles)
global third_e
third_e = str2double(get(hObject,'String'));

function third_e_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function av_dim_1_Callback(hObject, eventdata, handles)
global av_dim_1
if (get(handles.av_dim_1,'Value') == get(handles.av_dim_1,'Max'))
    av_dim_1 = 1;
else
    av_dim_1 = 0;
end

function av_dim_2_Callback(hObject, eventdata, handles)
global av_dim_2
if (get(handles.av_dim_2,'Value') == get(handles.av_dim_2,'Max'))
    av_dim_2 = 1;
else
    av_dim_2 = 0;
end

function av_dim_3_Callback(hObject, eventdata, handles)
global av_dim_3
if (get(handles.av_dim_3,'Value') == get(handles.av_dim_3,'Max'))
    av_dim_3 = 1;
else
    av_dim_3 = 0;
end

function trial_dim_1_Callback(hObject, eventdata, handles)
global trial_dim_1
if (get(handles.trial_dim_1,'Value') == get(handles.trial_dim_1,'Max'))
    trial_dim_1 = 1;
else
    trial_dim_1 = 0;
end

function trial_dim_2_Callback(hObject, eventdata, handles)
global trial_dim_2
if (get(handles.trial_dim_2,'Value') == get(handles.trial_dim_2,'Max'))
    trial_dim_2 = 1;
else
    trial_dim_2 = 0;
end

function trial_dim_3_Callback(hObject, eventdata, handles)
global trial_dim_3
if (get(handles.trial_dim_3,'Value') == get(handles.trial_dim_3,'Max'))
    trial_dim_3 = 1;
else
    trial_dim_3 = 0;
end

function trial_selection_Callback(hObject, eventdata, handles)
global array_data; % global trial_dim_1; global trial_dim_2; global trial_dim_3;
selection = str2num(get(handles.selection_list,'String'));
trialnrs = max(selection);
[a b c] = size(array_data);
if get(handles.keep, 'Value')
    if get(handles.trial_dim_1, 'Value') == get(handles.trial_dim_1, 'Max')
        if trialnrs > a
            errordlg('the selection list is bigger than the number of trials');
        else
            array_data = array_data(selection,:,:);
        end
    elseif get(handles.trial_dim_2, 'Value') == get(handles.trial_dim_2, 'Max')
        if trialnrs > b
            errordlg('the selection list is bigger than the number of trials');
        else
            array_data = array_data(:,selection,:);
        end
    elseif get(handles.trial_dim_3, 'Value') == get(handles.trial_dim_3, 'Max')
        if trialnrs > c
            errordlg('the selection list is bigger than the number of trials');
        else
            array_data = array_data(:,:,selection);
        end
    end
elseif get(handles.discard, 'Value')
    if get(handles.trial_dim_1, 'Value') == get(handles.trial_dim_1, 'Max')
        if trialnrs > a
            errordlg('the selection list is bigger than the number of trials');
        else
            alltrials = 1:a;
            selection = setdiff(alltrials, selection);
            array_data = array_data(selection,:,:);
        end
    elseif get(handles.trial_dim_2, 'Value') == get(handles.trial_dim_2, 'Max')
        if trialnrs > b
            errordlg('the selection list is bigger than the number of trials');
        else
            alltrials = 1:b;
            selection = setdiff(alltrials, selection);
            array_data = array_data(:,selection,:);
        end
    elseif get(handles.trial_dim_3, 'Value') == get(handles.trial_dim_3, 'Max')
        if trialnrs > c
            errordlg('the selection list is bigger than the number of trials');
        else
            alltrials = 1:c;
            selection = setdiff(alltrials, selection);
            array_data = array_data(:,:,selection);
        end
    end
end
[str1] = size(array_data);
if length(str1) == 3
    str = [num2str(str1(1)) ' - ' num2str(str1(2)) ' - ' num2str(str1(3))];
elseif length(str1) <= 3
    str = [num2str(str1(1)) ' - ' num2str(str1(2))];
end
set(handles.file_size,'string',str);

function resiz_Callback(hObject, eventdata, handles)
global array_data
global col_b; global col_e;global row_b; global row_e; global third_e;global third_b;global filename
if isempty(col_b)==1
    errordlg('PLease fill out all data fields','Error');
elseif isempty(col_e)==1
    errordlg('PLease fill out all data fields','Error');
elseif isempty(row_b)==1
    errordlg('PLease fill out all data fields','Error');
elseif isempty(row_e)==1
    errordlg('PLease fill out all data fields','Error');
elseif isempty(third_b)==1
    errordlg('PLease fill out all data fields','Error');
elseif isempty(filename)==1
    errordlg('No file to resize loaded','File error');
else
    col_b = str2double(get(handles.col_b,'String'));
    col_e = str2double(get(handles.col_e,'String'));
    row_b = str2double(get(handles.row_b,'String'));
    row_e = str2double(get(handles.row_e,'String'));
    third_e = str2double(get(handles.third_e,'String'));
    third_b = str2double(get(handles.third_b,'String'));
    array_data = array_data(col_b:col_e,row_b:row_e, third_b:third_e);
end
[str1] = size(array_data);
if length(str1) == 3
    str = [num2str(str1(1)) ' - ' num2str(str1(2)) ' - ' num2str(str1(3))];
elseif length(str1) <= 3
    str = [num2str(str1(1)) ' - ' num2str(str1(2))];
end
set(handles.file_size,'string',str);

function conca_Callback(hObject, eventdata, handles)
global con_row; global col_dim; global thrid_dim;global array_data
if (get(handles.con_row,'Value') == get(handles.con_row,'Max'))
    con_row =1;
else
    con_row=0;
end
if (get(handles.col_dim,'Value') == get(handles.col_dim,'Max'))
    col_dim =1;
else
    col_dim =0;
end
if (get(handles.thrid_dim,'Value') == get(handles.thrid_dim,'Max'))
    thrid_dim =1;
else
    thrid_dim =0;
end
[filename2, pathname] = ...
    uigetfile({'*.mat';},'Select an array');
load(filename2); data6 = data;
[a b c] = size(data6);
[d e f] = size(array_data);
if con_row ==1
    if b~=e || c~=f % a ~= d;
        errordlg('Row dimensions dont agree','Dimension error');
    else
        array_data = cat(1,array_data,data6);
    end
end
if col_dim ==1
    if a~=d || c ~= f % e ~= b;
        errordlg('Collumn dimensions dont agree','Dimension error');
    else
        array_data = cat(2,array_data,data6);
    end
end
if thrid_dim ==1
    if a ~= d || b ~= e % f ~= c ;
        errordlg('Third dimensions dont agree','Dimension error');
    else
        array_data = cat(3,array_data,data6);
    end
end
[str1] = size(array_data);
if length(str1) == 3
    str = [num2str(str1(1)) ' - ' num2str(str1(2)) ' - ' num2str(str1(3))];
elseif length(str1) <= 3
    str = [num2str(str1(1)) ' - ' num2str(str1(2))];
end
set(handles.file_size,'string',str);

function con_row_Callback(hObject, eventdata, handles)
global con_row;
if (get(hObject,'Value') == get(hObject,'Max'))
    con_row =1;
else
    con_row =0;
end
return

function col_dim_Callback(hObject, eventdata, handles)
global col_dim
if (get(hObject,'Value') == get(hObject,'Max'))
    col_dim =1;
else
    col_dim =0;
end
return

function thrid_dim_Callback(hObject, eventdata, handles)
global thrid_dim
if (get(hObject,'Value') == get(hObject,'Max'))
    thrid_dim =1;
else
    thrid_dim =0;
end
return


function Transp_Callback(hObject, eventdata, handles)
global array_data; global col_row;global col_third;global row_thrid
if (get(handles.col_row,'Value') == get(handles.col_row,'Max'))
    col_row =1;
else
    col_row =0;
end
if (get(handles.col_third,'Value') == get(handles.col_third,'Max'))
    col_third =1;
else
    col_third =0;
end
if (get(handles.row_thrid,'Value') == get(handles.row_thrid,'Max'))
    row_thrid =1;
else
    row_thrid =0;
end
if col_row == 1
    array_data = permute(array_data,[2 1 3]);
end

if col_third == 1
    array_data = permute(array_data,[3 2 1]);
end

if row_thrid == 1
    array_data = permute(array_data,[1 3 2]);
end
[str1] = size(array_data);
if length(str1) == 3
    str = [num2str(str1(1)) ' - ' num2str(str1(2)) ' - ' num2str(str1(3))];
elseif length(str1) <= 3
    str = [num2str(str1(1)) ' - ' num2str(str1(2))];
end
set(handles.file_size,'string',str);

function average_data_Callback(hObject, eventdata, handles)
global array_data; global av_dim_1; global av_dim_2; global av_dim_3;
if (get(handles.av_dim_1,'Value') == get(handles.av_dim_1,'Max'))
    av_dim_1 = 1;
else
    av_dim_1 = 0;
end
if (get(handles.av_dim_2,'Value') == get(handles.av_dim_2,'Max'))
    av_dim_2 = 1;
else
    av_dim_2 = 0;
end
if (get(handles.av_dim_3,'Value') == get(handles.av_dim_3,'Max'))
    av_dim_3 = 1;
else
    av_dim_3 = 0;
end
[a b c] = size(array_data);
if av_dim_1 == 1 && a >= 1
    array_data = mean(array_data,1);
elseif av_dim_1 && (isempty(a) || a == 1)
    errordlg('there is no first dimension to average');
end
if av_dim_2 == 1 && b >= 1
    array_data = mean(array_data,2);
elseif av_dim_2 && (isempty(b) || b == 1)
    errordlg('there is no second dimension to average');
end
if (av_dim_3 == 1) && (c > 1 )
    array_data = mean(array_data,3);
elseif av_dim_3 && (isempty(c) || c == 1)
    errordlg('there is no third dimension to average');
end
[str1] = size(array_data);
if length(str1) == 3
    str = [num2str(str1(1)) ' - ' num2str(str1(2)) ' - ' num2str(str1(3))];
elseif length(str1) <= 3
    str = [num2str(str1(1)) ' - ' num2str(str1(2))];
end
set(handles.file_size,'string',str);


% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
global filename;global array_data;
curdir = cd;
cd([curdir filesep 'data']);
[filename, pathname] = ...
    uigetfile({'*.mat';},'Select an array');
cd(curdir);
if any(filename)
    load([pathname filename]);
    array_data = data;
    [str1] = size(array_data);
    if length(str1) == 3
        str = [num2str(str1(1)) ' - ' num2str(str1(2)) ' - ' num2str(str1(3))];
    elseif length(str1) <= 3
        str = [num2str(str1(1)) ' - ' num2str(str1(2))];
    end
    set(handles.file_name,'string',filename);
    set(handles.file_size,'string',str);
end

% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
global array_data
data = array_data;
curdir = cd;
cd([curdir filesep 'data']);
uisave({'data'},'Name');
cd(curdir);
clear data;
clear -global array_data
% clear filename; clear data; clear data4;
% str = ' ';
% set(handles.file_name,'string',str);
% set(handles.file_size,'string',str);

function col_row_Callback(hObject, eventdata, handles)
global col_row
if (get(hObject,'Value') == get(hObject,'Max'))
    col_row =1;
else
    col_row =0;
end
return
function col_third_Callback(hObject, eventdata, handles)
global col_third
if (get(hObject,'Value') == get(hObject,'Max'))
    col_third =1;
else
    col_third =0;
end
return
function row_thrid_Callback(hObject, eventdata, handles)
global row_thrid
if (get(hObject,'Value') == get(hObject,'Max'))
    row_thrid =1;
else
    row_thrid =0;
end
return


% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
web('Help_Array_manipulator.htm', '-helpbrowser')


% --- Executes during object creation, after setting all properties.
function selection_list_CreateFcn(hObject, eventdata, handles)
% hObject    handle to selection_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function selection_list_Callback(hObject, eventdata, handles)
global selection_list;
selection_list = str2num(get(handles.selection_list, 'String'));
% hObject    handle to selection_list (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of selection_list as text
%        str2double(get(hObject,'String')) returns contents of selection_list as a double


% --------------------------------------------------------------------
function Untitled_1_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Untitled_2_Callback(hObject, eventdata, handles)


% --------------------------------------------------------------------
function Syllabus_Callback(hObject, eventdata, handles)
web('Syllabus.htm', '-helpbrowser')
