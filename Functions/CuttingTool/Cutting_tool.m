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
set(get(handles.markerPanelSerial, 'Children'), 'Enable', 'on')
set(get(handles.markerPanelTTL, 'Children'), 'Enable', 'off')
set(get(handles.timePanel, 'Children'), 'Enable', 'off')
set(get(handles.manualPanel, 'Children'), 'Enable', 'off')

handles.output = hObject;
% handles.dir = varargin{1}.dir;
guidata(hObject, handles);

function varargout = Cutting_tool_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;


% --------------------------------------------------------------------
function Load_Callback(hObject, eventdata, handles)
[filename, EEG] = EEGLoadData('time');
if any(filename) % check is any file was selected
    handles.filename.String = ['filename: ' filename]; % display filename
    handles.trial.String = '1';
    handles.chan.String = '1';
    % if it is a matrix (regular EEG data) save data to handles
    handles.EEG = EEG;
    [d1, d2, d3] = size(EEG.data);  % determine the data dimensions
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
web('Event_cutter_help.html', '-helpbrowser')


function cuttingMethod_Callback(hObject, eventdata, handles)
if handles.cuttingMethod.Value == 1
    
    set(get(handles.markerPanelSerial, 'Children'), 'Enable', 'on')
    handles.markerPanelTTL.ShadowColor = 'k';
    handles.markerPanelTTL.BorderWidth = 2;
    
    set(get(handles.markerPanelTTL, 'Children'), 'Enable', 'off')
    handles.markerPanelSerial.ShadowColor = [.7 .7 .7];
    handles.markerPanelSerial.BorderWidth = 1;

    set(get(handles.timePanel, 'Children'), 'Enable', 'off')
    handles.timePanel.ShadowColor = [.7 .7 .7];
    handles.timePanel.BorderWidth = 1;

    set(get(handles.manualPanel, 'Children'), 'Enable', 'off')
    handles.manualPanel.ShadowColor = [.7 .7 .7];
    handles.manualPanel.BorderWidth = 1;

elseif handles.cuttingMethod.Value == 2

    set(get(handles.markerPanelSerial, 'Children'), 'Enable', 'off')
    handles.markerPanelSerial.ShadowColor = 'k';
    handles.markerPanelSerial.BorderWidth = 2;

    set(get(handles.markerPanelTTL, 'Children'), 'Enable', 'on')
    handles.markerPanelTTL.ShadowColor = [.7 .7 .7];
    handles.markerPanelTTL.BorderWidth = 1;

    set(get(handles.timePanel, 'Children'), 'Enable', 'off')
    handles.timePanel.ShadowColor = [.7 .7 .7];
    handles.timePanel.BorderWidth = 1;

    set(get(handles.manualPanel, 'Children'), 'Enable', 'off')
    handles.manualPanelTTL.ShadowColor = [.7 .7 .7];
    handles.manualPanel.BorderWidth = 1;

elseif handles.cuttingMethod.Value == 3

    set(get(handles.markerPanelSerial, 'Children'), 'Enable', 'off')
    handles.markerPanelSerial.ShadowColor = [.7 .7 .7];
    handles.markerPanelSerial.BorderWidth = 1;

    set(get(handles.markerPanelTTL, 'Children'), 'Enable', 'off')
    handles.markerPanelTTL.ShadowColor = [.7 .7 .7];
    handles.markerPanelTTL.BorderWidth = 1;

    set(get(handles.timePanel, 'Children'), 'Enable', 'on')
    handles.timePanel.ShadowColor = 'k';
    handles.timePanel.BorderWidth = 2;

    set(get(handles.manualPanel, 'Children'), 'Enable', 'off')
    handles.manualPanel.ShadowColor = [.7 .7 .7];
    handles.manualPanel.BorderWidth = 1;

elseif handles.cuttingMethod.Value == 4

    set(get(handles.markerPanelSerial, 'Children'), 'Enable', 'off')
    handles.markerPanelSerial.ShadowColor = [.7 .7 .7];
    handles.markerPanelSerial.BorderWidth = 1;

    set(get(handles.markerPanelTTL, 'Children'), 'Enable', 'off')
    handles.markerPanelTTL.ShadowColor = [.7 .7 .7];
    handles.markerPanelTTL.BorderWidth = 1;

    set(get(handles.timePanel, 'Children'), 'Enable', 'off')
    handles.timePanel.ShadowColor = [.7 .7 .7];
    handles.timePanel.BorderWidth = 1;

    set(get(handles.manualPanel, 'Children'), 'Enable', 'on')
    handles.manualPanel.ShadowColor = 'k';
    handles.manualPanel.BorderWidth = 2;
end


%%%%%%%%%%%%%%%%%%%%%%%%
%%% Preview function %%%
%%%%%%%%%%%%%%%%%%%%%%%%
function handles = Preview_Callback(hObject, eventdata, handles)
if ~isfield(handles, 'EEG')
    warndlg('No data available.')
    return
end
EEG = handles.EEG;

ax1 = handles.axes1;
Ylimits = ax1.YLim;

sampleWarning = {'No samples available';'You are trying to cut samples outside of your dataset.';'Adjust your settings.'};
% cuttingMethods:
% 1 = marker based cuts Serial
% 2 = marker based cuts TTL
% 3 = time based cuts
% 4 = manual selection (to be implemented)

if handles.cuttingMethod.Value == 1  
    %% Cut based on serial markerss
    markerChannel = find(EEG.channelTypes=="Marker");
    preMarker = str2double(handles.beginSerial.String);
    postMarker = str2double(handles.endSerial.String);
    if any(isnan([markerChannel preMarker postMarker]))
        opts.Interpreter = 'tex';
        opts.WindowStyle = 'modal';
        warndlg('\fontsize{16} Please fill in the cutting parameters.', 'No Settings found', opts)
        return
    end
%     markers = find(ismember(EEG.data(:,markerChannel), str2double(strsplit(handles.marker_nrs.String))));
    [pks, locs] = findpeaks(EEG.data(:,markerChannel));
    markers = locs(ismember(pks, str2double(strsplit(handles.marker_nrs.String))));
    nrofevents = length(markers);
    if nrofevents == 0
        warndlg('No markers detected within this channel. Make sure to select a Marker channel containing event markers and provide correct marker numbers', 'No events detected.','non-modal')
        return
    end
    for imark = 1:nrofevents
        if markers(imark)-preMarker < 0
            errordlg(sampleWarning)
            return
        elseif markers(imark) + postMarker > size(EEG.data,1)
            errordlg(sampleWarning)
            return
        end
    end
    segmentStart = (markers-preMarker); %/ EEG.fsample;
    segmentEnd = (markers + postMarker); %/ EEG.fsample;


    elseif handles.cuttingMethod.Value == 2
    %% cut based on TTL markers
    % check cutting parameters
    selectedChan = str2double(handles.col_nr.String);
    preMarker = str2double(handles.beg.String);
    postMarker = str2double(handles.eind.String);
    if any(isnan([selectedChan preMarker postMarker]))
        opts.Interpreter = 'tex';
        opts.WindowStyle = 'modal';
        warndlg('\fontsize{16}Please select the right method and fill in the cutting parameters.', 'No Settings found', opts)
        return
    end
    if handles.on_offset.Value == 1
        markers = find(round(diff(EEG.data(:,selectedChan)))==5 );
    elseif handles.on_offset.Value == 2
        markers = find(round(diff(EEG.data(:,selectedChan)))==-5);  
    end
    nrofevents = length(markers);
    if nrofevents == 0
        warndlg('No markers detected within this channel. Make sure to select a Marker channel containing event markers', 'No events detected.','non-modal')
        return
    end
    hold(handles.axes1, 'on')
    for imark = 1:nrofevents
        if markers(imark)-preMarker < 0
            errordlg(sampleWarning)
        elseif markers(imark) + postMarker > size(EEG.data,1)
            errordlg(sampleWarning)
        end
    end
    segmentStart = (markers-preMarker);
    segmentEnd = (markers + postMarker);
%% Cut based on time periods
elseif handles.cuttingMethod.Value == 3
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
    elseif any(segmentEnd > size(EEG.data,1))
        errordlg(sampleWarning)
    end

%% Cut based on manual selection
elseif handles.cuttingMethod.Value == 4
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

    p = patch(([segmentStart segmentStart segmentEnd segmentEnd]./EEG.fsample)', ...
        repmat([Ylimits(1) Ylimits(2) Ylimits(2) Ylimits(1)]',[1 nrofevents ]), 'b');
    p.FaceAlpha = .2;
end
plotData(handles)
guidata(hObject,handles)

%%%%%%%%%%%%%%%%%%%%
%%% Cut function %%%
%%%%%%%%%%%%%%%%%%%%
function cut_Callback(hObject, eventdata, handles)
if ~isfield(handles, 'EEG')
    warndlg('No data available.')
    return
end
handles = Preview_Callback(hObject, eventdata, handles);
EEG = handles.EEG;
if ~isfield(handles, 'windowEdges')
    opts.Interpreter = 'tex';
    opts.WindowStyle = 'modal';
    warndlg('\fontsize{16} Please fill in the cutting parameters.', 'No Settings found', opts)
    return
end
windowEdges = handles.windowEdges;
% if handles.cuttingMethod.Value==4
%     windowEdges = windowEdges .* EEG.fsample;
% end
nrofcuts = size(windowEdges,1);
if nrofcuts == 0
    warndlg('No events detected within this channel. Make sure to select a Marker channel containing event Markers', 'No events detected.')
    return
end

cuts = zeros(windowEdges(1,2)-windowEdges(1,1)+1, size(EEG.data,2), nrofcuts);
% cuttingMethods:
% 1 = marker based cuts
% 2 = time based cuts
% 3 = manual selection
% if handles.cuttingMethod.Value == 1 || handles.cuttingMethod.Value == 2
for icut = 1:nrofcuts
    cut = EEG.data(windowEdges(icut,1):(windowEdges(icut,2)),:);
    cuts(:,:,icut) = cut;
end

% elseif handles.cuttingMethod.Value == 3
%     opts.WindowStyle = 'modal';
%     opts.Interpreter = 'tex';
%     warndlg('\fontsize{15} This method is not implemented yet :(' , 'Method unavailable' , opts)
% end

% save the cut data
EEG.data = cuts;

handles.file_size_new.String = sprintf('new file size: %d - %d - %d', size(EEG.data,[1 2 3]));


% add third dimension label
if size(EEG.data,3)>1
    EEG.dims = [EEG.dims "trials"];
end

% % save original time fields
% this would need to be saved per trial; really necessary??
% EEG.urtime = EEG.time;


%% TO DO
% add time per trial
% add sampleinfo per trial
% add history --> do this in the cut_Callback
%% For now, update time and samppleinfo the same for all trials

% update time field
cuttingMethod = handles.cuttingMethod.Value;

if cuttingMethod == 1
        % Serial based cuts
    EEG.time = (((1:length(cut))-1) - str2double(handles.beginSerial.String)) ./ EEG.fsample;
    addition = sprintf(["\n\n"  +...
        "Cutting tool - %s \n" +...
        "Data was cut using Serial marker(s): %s.\n" +...
        "Cutting %s samples before marker onset and %s samples after marker onset" ...
        ],datetime, handles.marker_nrs.String, handles.beginSerial.String, handles.endSerial.String);
    EEG.history = EEG.history + addition; 
    %% to-do: add cutting parameters
   
elseif cuttingMethod == 2
 % TTL based cuts
    EEG.time = (((1:length(cut))-1) - str2double(handles.beg)) ./ EEG.fsample;
    EEG.history = EEG.history  + sprintf("\n\nData was cut based on TTLs markers\n\n") ; 
    %% to-do: add cutting parameters
%% to-do elseif cuttingMethod == 3

elseif handles.cuttingMethod.Value == 4
    % Manual cuts
    EEG.time = ((1:length(cut))-1) ./ EEG.fsample;
end


% update sample info
EEG.sampleinfo = [1 length(cut)];

EEGSaveData(EEG,'cut');
handles = rmfield(handles, 'windowEdges');
guidata(hObject,handles)


function plotData(handles)

EEG = handles.EEG;

[nrofsamples, nrofchans] = size(EEG.data);
a = linspace(0,1,nrofchans);
b = sort(a,'descend');
hold(handles.axes1, 'on')
% for ichan=1:nrofchans
%     if ichan<9
%         plot(handles.axes1,t,EEG.data(:,ichan)*100+b(ichan)); hold(handles.axes1,'on')
%     else
%         plot(handles.axes1,t,EEG.data(:,ichan)./250+b(ichan),'k'); hold(handles.axes1,'on')
%     end
% end

%
for ichan=1:nrofchans
    % plot physiological channels
    if ismember(EEG.channelTypes(ichan), ["EEG" "EMG" "ECG" "EOG"])
        plot(handles.axes1,EEG.time,EEG.data(:,ichan)+b(ichan)); hold(handles.axes1,'on')
    elseif strcmp(EEG.channelTypes(ichan), "Marker")
        % plot markers channels
        if ~any(~ismember(unique(round(EEG.data(:,ichan)))', [0 5])) % see if all values are 0 or 5
            % plot TTL markers
            plot(handles.axes1,EEG.time,EEG.data(:,ichan)*10+b(ichan),'k'); hold(handles.axes1,'on')
        else 
            stemSize = 0.9 * max(max(EEG.data(:,1:end-1)));
            % plot serial markers as 
%             stem(EEG.time,(EEG.data(:,ichan)>0)/resiseFactor)
            stem(EEG.time(EEG.data(:,ichan)>0),ones(1,sum(EEG.data(:,ichan)>0))*stemSize);
            % add marker values as text 
            [markerValues, markerLocs] = findpeaks(EEG.data(:,ichan));
            text(EEG.time(markerLocs), repmat(stemSize*1.1, [1,length(markerValues)]), num2str(markerValues))
        end        
    end
end
%
plots = cell2table([get(handles.axes1.Children,'Type')]);

% add legend to plot
% in case the preview contains the cuts, add those to the legend
if any(strcmp(plots.Var1,'patch'))
    legend(['cuts' EEG.channelLabels], 'Location', 'eastoutside')
elseif length(handles.axes1.Children) == length(EEG.channelLabels)
    legend([EEG.channelLabels], 'Location', 'eastoutside')
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
handles.windowEdges = round(selection'*handles.EEG.fsample);
guidata(hObject,handles)
Preview_Callback(hObject, eventdata, handles)



% --- Executes on selection change in on_offset.
function on_offset_Callback(hObject, eventdata, handles)
% hObject    handle to on_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns on_offset contents as cell array
%        contents{get(hObject,'Value')} returns selected item from on_offset


% --- Executes during object creation, after setting all properties.
function on_offset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to on_offset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function marker_nrs_Callback(hObject, eventdata, handles)
% hObject    handle to marker_nrs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of marker_nrs as text
%        str2double(get(hObject,'String')) returns contents of marker_nrs as a double


% --- Executes during object creation, after setting all properties.
function marker_nrs_CreateFcn(hObject, eventdata, handles)
% hObject    handle to marker_nrs (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function beginSerial_Callback(hObject, eventdata, handles)
% hObject    handle to beginSerial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of beginSerial as text
%        str2double(get(hObject,'String')) returns contents of beginSerial as a double


% --- Executes during object creation, after setting all properties.
function beginSerial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to beginSerial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function endSerial_Callback(hObject, eventdata, handles)
% hObject    handle to endSerial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of endSerial as text
%        str2double(get(hObject,'String')) returns contents of endSerial as a double


% --- Executes during object creation, after setting all properties.
function endSerial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to endSerial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
