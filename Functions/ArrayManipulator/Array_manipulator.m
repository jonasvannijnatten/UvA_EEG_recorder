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
% check which data type is loaded
if isfield(handles,'tf')
  data = handles.tf.data;
elseif isfield(handles,'data')
  data = handles.data;
else
  errordlg('some went wrong, somehow no correct data type has been recognized')
  return
end

% determine selection to keep / discard
selection = str2num(get(handles.selection_list,'String'));
% determine largest element index of  selection
trialnrs = max(selection);
% detemine data size
[a, b, c] = size(data);

% determine in which dimension the selection is made
if get(handles.trial_dim_1, 'Value') == get(handles.trial_dim_1, 'Max')
      dim = 1;
elseif get(handles.trial_dim_2, 'Value') == get(handles.trial_dim_2, 'Max')
      dim = 2;
elseif get(handles.trial_dim_3, 'Value') == get(handles.trial_dim_3, 'Max')
      dim = 3;
end

% check if the selection exceeds the data size    
if trialnrs > size(data,dim)
    errordlg('the selection list exceeds the size of the data set');
end

% determine whether selection is kept or discarded
% when discarded inverse the selection
if get(handles.discard, 'Value')
    alltrials = 1:size(data,dim);
    selection = setdiff(alltrials, selection);
end

% apply selection
if dim == 1
    data = data(selection,:,:);
    disp(['Selection kept in the 1st dimension: ' num2str(selection)])
    handles.EEG.history = [handles.EEG.history sprintf('Selection of data kept in 1st dimension: %s at %s\n\n',num2str(selection), datetime)];
elseif dim == 2
    data = data(:,selection,:);
    disp(['Selection kept in the 2nd dimension: ' num2str(selection)])
    handles.EEG.history = [handles.EEG.history sprintf('Selection of data kept in 2nd dimension: %s at %s\n\n',num2str(selection), datetime)];
elseif dim == 3
    data = data(:,:,selection);
    disp(['Selection kept in the 3rd dimension: ' num2str(selection)])
    handles.EEG.history = [handles.EEG.history sprintf('Selection of data kept in 3rd dimension: %s at %s\n\n',num2str(selection), datetime)];
end


% save concatenated data to handles
if isfield(handles,'data')
    handles.data = data;
elseif isfield(handles,'tf')
    handles.tf.data = data;
end

[d1, d2, d3] = size(data); % determine the data dimensions
handles.filesize.String = sprintf('%i - %i - %i',d1,d2,d3); % display filesize

guidata(hObject,handles)

function resiz_Callback(hObject, eventdata, handles)
global col_b; global col_e;global row_b; global row_e; global third_e;global third_b;
filename = handles.filename;
if isfield(handles,'tf')
    array_data = handles.tf.data;
else
    array_data = handles.data;
end

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
    array_data = array_data(col_b:col_e, row_b:row_e, third_b:third_e);
    handles.EEG.history = [handles.EEG.history sprintf('Data resized to rows %d-%d, columns %d-%d and 3rd dimension %d-%d at %s\n\n',col_b,col_e,row_b,row_e,third_b,third_e, datetime)];
end
[str1] = size(array_data);
if length(str1) == 3
    str = [num2str(str1(1)) ' - ' num2str(str1(2)) ' - ' num2str(str1(3))];
elseif length(str1) <= 3
    str = [num2str(str1(1)) ' - ' num2str(str1(2))];
end
set(handles.filesize,'string',str);
if isfield(handles,'tf')
    handles.tf.data = array_data;
else
    handles.data = array_data;
end

guidata(hObject,handles)

function conca_Callback(hObject, eventdata, handles)
[addFilename, addEEG] = EEGLoadData('any');
%addData = addEEG.data;
if any(addFilename) % check is any file was selected
    % check if originally loaded file and added file are the same format
    if isfield(handles,'data') && strcmp(addEEG.domain, 'tf')
        errordlg('Cannot combine EEG data with time-frequency data')
        return
    elseif isfield(handles,'tf') && strcmp(addEEG.domain, 'time')
        errordlg('Cannot combine time-frequency data with EEG data')
        return
    end
    % if both files are time-frequency data, check if the time and
    % frequency axes match. If not, check the analysis settings.
    if isfield(handles,'tf') && strcmp(addEEG.domain, 'tf')
        addData.data = addEEG.data;
        addData.T = addEEG.time;
        addData.F = addEEG.frequency;
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
    elseif isfield(handles,'data') && strcmp(addEEG.domain, 'time')
        addData = addEEG.data;
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
fprintf('added: %s along dimension %i\n', addFilename, concatDim)

% save concatenated data to handles
if isfield(handles,'data')
    handles.data = data;
elseif isfield(handles,'tf')
    handles.tf.data = data;
end

[d1, d2, d3] = size(data); % determine the data dimensions
handles.filesize.String = sprintf('%i - %i - %i',d1,d2,d3); % display filesize

% Story manipulation in history
handles.EEG.history = [handles.EEG.history sprintf('Data of file %s and %s concatenated at %s\n\n', handles.EEG.filename, addEEG.filename, datetime)];

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
EEG = handles.EEG;
if isfield(handles,'tf')
    errordlg('This function is not applicable to time frequency data')
    return
end
%Create third dimension in EEG.dims
if length(EEG.dims) == 2
    EEG.dims = [EEG.dims "trials"];
end
if (get(handles.col_row,'Value') == get(handles.col_row,'Max'))
    handles.data = permute(handles.data,[2 1 3]);
    EEG.dims([2 1]) = EEG.dims([1 2]); %transpose dimension
    fprintf('transposed rows and columns\n')
    EEG.history = [EEG.history sprintf('Rows and columns transposed at %s\n\n', datetime)];
elseif (get(handles.col_third,'Value') == get(handles.col_third,'Max'))
    handles.data = permute(handles.data,[3 2 1]);
    EEG.dims([3 1]) = EEG.dims([1 3]); %transpose dimension
    fprintf('transposed columns and third dimension\n')
    EEG.history = [EEG.history sprintf('Columns and 3rd dimension transposed at %s\n\n', datetime)];
elseif (get(handles.row_thrid,'Value') == get(handles.row_thrid,'Max'))
    handles.data = permute(handles.data,[1 3 2]);
    EEG.dims([3 2]) = EEG.dims([2 3]); %transpose dimension
    fprintf('transposed rows and third dimension\n')
    EEG.history = [EEG.history sprintf('Rows and 3rd dimension transposed at %s\n\n', datetime)];
end

handles.EEG = EEG;
[d1, d2, d3] = size(handles.data); % determine the data dimensions
handles.filesize.String = sprintf('%i - %i - %i',d1,d2,d3); % display filesize

guidata(hObject,handles)

function average_data_Callback(hObject, eventdata, handles)
% check which data type is loaded
if isfield(handles,'tf')
  data = handles.tf.data;
elseif isfield(handles,'data')
  data = handles.data;
else
  errordlg('some went wrong, somehow no correct data type has been recognized')
  return
end
  
% average data in selected dimensions
if (get(handles.av_dim_1,'Value') == get(handles.av_dim_1,'Max'))
  data = mean(data,1);
  disp('averaged over 1st dimension')
  handles.EEG.history = [handles.EEG.history sprintf('Averaged over 1st dimension at %s\n\n', datetime)];
elseif (get(handles.av_dim_2,'Value') == get(handles.av_dim_2,'Max'))
  data = mean(data,2);
  disp('averaged over 2nd dimension')
  handles.EEG.history = [handles.EEG.history sprintf('Averaged over 2nd dimension at %s\n\n', datetime)];
elseif (get(handles.av_dim_3,'Value') == get(handles.av_dim_3,'Max'))
  data = mean(data,3);
  disp('averaged over 3rd dimension')
  handles.EEG.history = [handles.EEG.history sprintf('Averaged over 3rd dimension at %s\n\n', datetime)];
else
    errordlg('oops, something went wrong')
end

% determine and display new data size
[d1, d2, d3] = size(data); 
handles.filesize.String = sprintf('%i - %i - %i',d1,d2,d3); 

% return data to handles
if isfield(handles,'tf')
  handles.tf.data = data;
elseif isfield(handles,'data')
  handles.data = data;
end


guidata(hObject,handles)


% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
[filename, EEG] = EEGLoadData('any');
if any(filename) % check is any file was selected
    handles.EEG = EEG;
    handles.filename.String = ['filename: ' filename]; % display filename
    % if domain is time or frequency, data is a matrix (regular EEG data) -> save data to handles
    if strcmp(EEG.domain, 'time') || strcmp(EEG.domain, 'frequency')
        data = EEG.data;
        handles.data = data;
        [d1, d2, d3] = size(data);  % determine the data dimensions   
        % remove any old time frequency data set
        if isfield(handles,'tf'); handles = rmfield(handles,'tf'); end
        
    % if domain is tf, data is a struct (time-frequency data) -> save data to handles
    elseif strcmp(EEG.domain, 'tf')
        data.data = EEG.data;
        data.T = EEG.time;
        data.F = EEG.frequency;
        handles.tf = data;
        [d1, d2, d3] = size(data.data); % determine the data dimensions
        % remove any old data set
        if isfield(handles,'data'); handles = rmfield(handles,'data'); end
        
    end
    handles.filesize.String = sprintf('%i - %i - %i',d1,d2,d3); % display filesize
end

guidata(hObject,handles)

% --------------------------------------------------------------------
function save_Callback(hObject, eventdata, handles)
EEG = handles.EEG;
if isfield(handles, 'tf')
    EEG.data = handles.tf.data;
    EEG.time = handles.tf.T;
    EEG.frequency = handles.tf.F;
elseif isfield(handles,'data')
    EEG.data = handles.data;
else
    warndlg('No data to save')
end
EEGSaveData(EEG, 'dims');

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
