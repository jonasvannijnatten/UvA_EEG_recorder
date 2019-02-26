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

% Last Modified by GUIDE v2.5 26-Feb-2019 15:48:47

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
handles.dir = varargin{1}.dir;
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
set(handles.filesize,'string',str);

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
set(handles.filesize,'string',str);

function conca_Callback(hObject, eventdata, handles)
[addFilename, addData] = EEGLoadData(handles, 1);
if any(addFilename) % check is any file was selected
    % check if originally loaded file and added file are the same format
    if isfield(handles,'data') && isstruct(addData)
        errordlg('Cannot combine EEG data with time-frequency data')
        return
    elseif isfield(handles,'tf') && isnumeric(addData)
        errordlg('Cannot combine time-frequency data with EEG data')
        return
    end
    % if both files are time-frequency data, check if the time and
    % frequency axes match. If not, check the analysis settings.
    if isfield(handles,'tf') && isstruct(addData)
        if any(size(handles.tf.T) ~= size(addData.T)) || sum(~any(handles.tf.T == addData.T))
            errordlg(['Trying to combine two time-frequency data sets' ...
                'but the time axes do not match.'])
            return
        end
        if any(size(handles.tf.F) ~= size(addData.F)) || sum(~any(handles.tf.F == addData.F))
            errordlg(['Trying to combine two time-frequency data sets' ...
                'but the frequency axes do not match.'])
            return
        end
    end
end
% determine along which dimension to concatenate the data sets
if (get(handles.con_row,'Value') == get(handles.con_row,'Max'))
    concatDim = 1;
elseif (get(handles.col_dim,'Value') == get(handles.col_dim,'Max'))
    concatDim = 2;
elseif (get(handles.thrid_dim,'Value') == get(handles.thrid_dim,'Max'))
    concatDim = 3;
end

% get data dimensions of the original file
if isfield(handles,'data')
    originalData = handles.data;
elseif isfield(handles,'tf')
    originalData = handles.tf.data;
end
[a, b, c] = size(originalData);

% get data dimensions of the new file
if isstruct(addData)
    addData = addData.data;
end
[d, e, f] = size(addData);
% check if the other dimensions sizes match, if so, combine data sets
if concatDim == 1
    if b ~= e || c~=f % check if 2nd & 3rd dimension are equal
        errordlg('2nd or 3rd dimensions dont agree','Dimension mismatch error');
        return
    else
        data = cat(1,originalData,addData);
    end
elseif concatDim == 2
    if a~=d || c ~= f % check if 1st & 3rd dimension are equal
        errordlg('1st or 3rd dimensions dont agree','Dimension mismatch error');
        return
    else
        data = cat(2,originalData,addData);
    end
elseif concatDim == 3
    if a ~= d || b ~= e % check if 1st & 2nd dimension are equal
        errordlg('1st or 2nd dimensions dont agree','Dimension mismatch error');
        return
    else
        data = cat(3,originalData,addData);
    end
end
fprintf('%s added along dimension %i\n', handles.filename.String, concatDim)

% save concatenated data to handles
if isfield(handles,'data')
    handles.data = data;
elseif isfield(handles,'tf')
    handles.tf.data = data;
end

[d1, d2, d3] = size(data); % determine the data dimensions
handles.filesize.String = sprintf('%i - %i - %i',d1,d2,d3); % display filesize

guidata(hObject,handles)


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
if isfield(handles,'tf')
    errordlg('This function is not applicable to time frequency data')
    return
end

if (get(handles.col_row,'Value') == get(handles.col_row,'Max'))
    handles.data = permute(handles.data,[2 1 3]);
    fprintf('transposed rows and columns\n')
elseif (get(handles.col_third,'Value') == get(handles.col_third,'Max'))
    handles.data = permute(handles.data,[3 2 1]);
    fprintf('transposed columns and third dimension\n')
elseif (get(handles.row_thrid,'Value') == get(handles.row_thrid,'Max'))
    handles.data = permute(handles.data,[1 3 2]);
    fprintf('transposed rows and third dimension\n')
end

[d1, d2, d3] = size(handles.data); % determine the data dimensions
handles.filesize.String = sprintf('%i - %i - %i',d1,d2,d3); % display filesize

guidata(hObject,handles)

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
set(handles.filesize,'string',str);


% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
[filename, data] = EEGLoadData(handles, 1);
if any(filename) % check is any file was selected
    handles.filename.String = ['filename: ' filename]; % display filename
    
    % if it is a matrix (regular EEG data) save data to handles
    if isnumeric(data)
        handles.data = data;
        [d1, d2, d3] = size(data);  % determine the data dimensions   
        % remove any old time frequency data set
        if isfield(handles,'tf'); handles = rmfield(handles,'tf'); end
        
        % if it is a struct (time-frequency data) save data to handles
    elseif isstruct(data)
        handles.tf = data;
        [d1, d2, d3] = size(data.data); % determine the data dimensions
        % remove any old data set
        if isfield(handles,'data'); handles = rmfield(handles,'data'); end
        
    end
    handles.filesize.String = sprintf('%i - %i - %i',d1,d2,d3); % display filesize
else % if no file was selected, clear data and display 'No data'
    handles.filename.String = 'No data';
    handles.filesize.String = ' ';
    handles.data = [];
end

guidata(hObject,handles)

% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
global array_data
data = array_data;
curdir = cd;
cd([curdir filesep 'Data']);
uisave({'data'},'Name');
cd(curdir);
clear data;
clear -global array_data
% clear filename; clear data; clear data4;
% str = ' ';
% set(handles.filename,'string',str);
% set(handles.filesize,'string',str);

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


% --- Executes when uipanel5 is resized.
function uipanel5_SizeChangedFcn(hObject, eventdata, handles)
% hObject    handle to uipanel5 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
