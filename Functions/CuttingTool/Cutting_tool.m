function varargout = Cutting_tool(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Cutting_tool_OpeningFcn, ...
    'gui_OutputFcn',  @Cutting_tool_OutputFcn, ...
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

function Cutting_tool_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.dir = varargin{1}.dir;
guidata(hObject, handles);

function varargout = Cutting_tool_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Load_Callback(hObject, eventdata, handles)
[filename, data] = EEGLoadData(handles, 0);
if any(filename) % check is any file was selected
    handles.filename.String = ['filename: ' filename]; % display filename
    handles.trial.String = '1';
    handles.chan.String = '1';
    % if it is a matrix (regular EEG data) save data to handles
    handles.data = data;
    [d1, d2, d3] = size(data);  % determine the data dimensions
    cla(handles.axes1);
    handles.filesize.String = sprintf('original file size: %i - %i - %i',d1,d2,d3); % display filesize
    handles.file_size_new.String = '';
    handles.chan.String = 1;
    handles.trial.String = 1;
    plotData(handles);
end

guidata(hObject,handles)

% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
web('Event_cutter_help.htm', '-helpbrowser')


function cuttingMethod_Callback(hObject, eventdata, handles)
if handles.cuttingMethod.Value == 1
    handles.markerPanel.ShadowColor = 'k';
    handles.timePanel.ShadowColor = [.7 .7 .7];
    handles.manualPanel.ShadowColor = [.7 .7 .7];
elseif handles.cuttingMethod.Value == 2
    handles.markerPanel.ShadowColor = [.7 .7 .7];
    handles.timePanel.ShadowColor = 'k';
    handles.manualPanel.ShadowColor = [.7 .7 .7];
elseif handles.cuttingMethod.Value == 3
    handles.markerPanel.ShadowColor = [.7 .7 .7];
    handles.timePanel.ShadowColor = [.7 .7 .7];
    handles.manualPanel.ShadowColor = 'k';
end



function handles = Preview_Callback(hObject, eventdata, handles)
if ~isfield(handles, 'data')
    warndlg('No data available.')
    return
end
ax1 = handles.axes1;
Ylimits = ax1.YLim;
Fs = 256;

data = handles.data;

sampleWarning = {'No samples available';'You are trying to cut samples outside of your dataset.';'Adjust your settings.'};
% cuttingMethods:
% 1 = marker based cuts
% 2 = time based cuts
% 3 = manual selection (to be implemented)
if handles.cuttingMethod.Value == 1
    % check cutting parameters
    selectedChan = str2double(handles.col_nr.String);
    preOnset = str2double(handles.beg.String);
    postOnset = str2double(handles.eind.String);
    if any(isnan([selectedChan preOnset postOnset]))
        opts.Interpreter = 'tex';
        opts.WindowStyle = 'modal';
        warndlg('\fontsize{16} Please fill in the cutting parameters.', 'No Settings found', opts)
        return
    end
    markerOnsets = find(diff(data(:,selectedChan))>4);
    nrofevents = length(markerOnsets);
    hold(handles.axes1, 'on')
    for imark = 1:nrofevents
        if markerOnsets(imark)-preOnset < 0
            errordlg(sampleWarning)
        elseif markerOnsets(imark) + postOnset > size(data,1)
            errordlg(sampleWarning)
        end
    end
    segmentStart = (markerOnsets-preOnset) / Fs;
    segmentEnd = (markerOnsets + postOnset) / Fs;

elseif handles.cuttingMethod.Value == 2
    firstEvent = str2double(handles.event_t.String);
    periodEvent = str2double(handles.per.String);
    nrofevents = str2double(handles.num_cuts.String);
    preOnset = str2double(handles.t_bev.String);
    postOnset = str2double(handles.t_aft.String);

    if any(isnan([firstEvent periodEvent nrofevents preOnset postOnset]))
        opts.Interpreter = 'tex';
        opts.WindowStyle = 'modal';
        warndlg('\fontsize{16} Please fill in the cutting parameters.', 'No Settings found', opts)
        return
    end

    segmentStart = [ [firstEvent firstEvent + (periodEvent * (1:(nrofevents-1)))] - preOnset ]';
    segmentEnd   = [ [firstEvent firstEvent + (periodEvent * (1:(nrofevents-1)))] + postOnset ]';

    if any(segmentStart < 0)
        errordlg(sampleWarning)
    elseif any(segmentEnd > size(data,1))
        errordlg(sampleWarning)
    end

elseif handles.cuttingMethod.Value == 3
    if ~isfield(handles, 'windowEdges')
        opts.Interpreter = 'tex';
        opts.WindowStyle = 'modal';
        warndlg('\fontsize{16} Please select a time window first.', 'No Settings found', opts)
        return
    end
    nrofevents = 1;
    segmentStart = handles.windowEdges(1);
    segmentEnd = handles.windowEdges(2);
end
cla(ax1)
if ~isempty(segmentStart)
    handles.windowEdges = reshape([segmentStart segmentEnd]', 1, []);
    handles.windowEdges = [segmentStart segmentEnd];

    p = patch([segmentStart segmentStart segmentEnd segmentEnd]', ...
        repmat([Ylimits(1) Ylimits(2) Ylimits(2) Ylimits(1)]',[1 nrofevents ]), 'b');
    p.FaceAlpha = .2;
end
plotData(handles)
guidata(hObject,handles)

function cut_Callback(hObject, eventdata, handles)
if ~isfield(handles, 'data')
    warndlg('No data available.')
    return
end
handles = Preview_Callback(hObject, eventdata, handles);
data = handles.data;
if ~isfield(handles, 'windowEdges')
    opts.Interpreter = 'tex';
    opts.WindowStyle = 'modal';
    warndlg('\fontsize{16} Please fill in the cutting parameters.', 'No Settings found', opts)
    return
end
windowEdges = ceil(handles.windowEdges * 256);
nrofcuts = size(windowEdges,1);

cuts = zeros(windowEdges(1,2)-windowEdges(1,1), size(data,2), nrofcuts);
% cuttingMethods:
% 1 = marker based cuts
% 2 = time based cuts
% 3 = manual selection
% if handles.cuttingMethod.Value == 1 || handles.cuttingMethod.Value == 2
for icut = 1:nrofcuts
    cut = data(windowEdges(icut,1):(windowEdges(icut,2)-1),:);
    cuts(:,:,icut) = cut;
end

% elseif handles.cuttingMethod.Value == 3
%     opts.WindowStyle = 'modal';
%     opts.Interpreter = 'tex';
%     warndlg('\fontsize{15} This method is not implemented yet :(' , 'Method unavailable' , opts)
% end
handles.file_size_new.String = sprintf('new file size: %d - %d - %d', size(data,[1 2 3]));

% save the cut data
data = cuts;
EEGSaveData(data);
handles = rmfield(handles, 'windowEdges');
guidata(hObject,handles)


function plotData(handles)
Fs = 256;
data = handles.data;

[nrofsamples, nrofchans] = size(data);
a = linspace(0,1,nrofchans);
b = sort(a,'descend');
t = (1:nrofsamples)/Fs;
hold(handles.axes1, 'on')
for ichan=1:nrofchans
    if ichan<9
        plot(handles.axes1,t,data(:,ichan)*100+b(ichan)); hold(handles.axes1,'on')
    else
        plot(handles.axes1,t,data(:,ichan)./250+b(ichan),'k'); hold(handles.axes1,'on')
    end
end
grid(handles.axes1,'on')
handles.axes1.XLabel.String = 'times (s)';
axis(handles.axes1, 'tight')

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%% Standard Create & Callback functions %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function row_nr_Callback(hObject, eventdata, handles)

function row_nr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function col_nr_Callback(hObject, eventdata, handles)

function col_nr_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function beg_Callback(hObject, eventdata, handles)

function beg_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function eind_Callback(hObject, eventdata, handles)

function eind_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function t_bev_Callback(hObject, eventdata, handles)

function t_bev_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function event_t_Callback(hObject, eventdata, handles)

function event_t_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function t_aft_Callback(hObject, eventdata, handles)

function t_aft_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function per_Callback(hObject, eventdata, handles)

function per_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function num_cuts_Callback(hObject, eventdata, handles)

function num_cuts_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function cuttingMethod_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in selectManual.
function handles = selectManual_Callback(hObject, eventdata, handles)
handles.axes1;
[selection,~] = ginput(2);
handles.windowEdges = selection';
guidata(hObject,handles)
Preview_Callback(hObject, eventdata, handles)

