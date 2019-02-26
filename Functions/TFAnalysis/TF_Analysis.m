function varargout = TF_Analysis(varargin)
% TF_ANALYSIS MATLAB code for TF_Analysis.fig
%      TF_ANALYSIS, by itself, creates a new TF_ANALYSIS or raises the existing
%      singleton*.
%
%      H = TF_ANALYSIS returns the handle to a new TF_ANALYSIS or the handle to
%      the existing singleton*.
%
%      TF_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TF_ANALYSIS.M with the given input arguments.
%
%      TF_ANALYSIS('Property','Value',...) creates a new TF_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TF_Analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TF_Analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TF_Analysis

% Last Modified by GUIDE v2.5 19-Feb-2019 16:37:35

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TF_Analysis_OpeningFcn, ...
    'gui_OutputFcn',  @TF_Analysis_OutputFcn, ...
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


% --- Executes just before TF_Analysis is made visible.
function TF_Analysis_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TF_Analysis (see VARARGIN)

% Choose default command line output for TF_Analysis
handles.output = hObject;

handles.dir = varargin{1}.dir;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TF_Analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = TF_Analysis_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function chan_Callback(hObject, eventdata, handles)
try
    chan = str2double(handles.chan.String);
catch
    warndlg('Invalid channel selection')
    return
end
computeTF_Callback(hObject, eventdata, handles)
% hObject    handle to chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chan as text
%        str2double(get(hObject,'String')) returns contents of chan as a double


% --- Executes during object creation, after setting all properties.
function chan_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function trial_Callback(hObject, eventdata, handles)
try
    trial = str2double(handles.trial.String);
catch
    warndlg('Invalid channel selection')
    return
end
computeTF_Callback(hObject, eventdata, handles)
% hObject    handle to chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of chan as text
%        str2double(get(hObject,'String')) returns contents of chan as a double


% --- Executes during object creation, after setting all properties.
function trial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to chan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function XLim_Callback(hObject, eventdata, handles)
computeTF_Callback(hObject, eventdata, handles)
% hObject    handle to XLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XLim as text
%        str2double(get(hObject,'String')) returns contents of XLim as a double


% --- Executes during object creation, after setting all properties.
function XLim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function YLim_Callback(hObject, eventdata, handles)
computeTF_Callback(hObject, eventdata, handles)
% hObject    handle to YLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YLim as text
%        str2double(get(hObject,'String')) returns contents of YLim as a double


% --- Executes during object creation, after setting all properties.
function YLim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function ZLim_Callback(hObject, eventdata, handles)
computeTF_Callback(hObject, eventdata, handles)
% hObject    handle to ZLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of ZLim as text
%        str2double(get(hObject,'String')) returns contents of ZLim as a double


% --- Executes during object creation, after setting all properties.
function ZLim_CreateFcn(hObject, eventdata, handles)
% hObject    handle to ZLim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function toi_Callback(hObject, eventdata, handles)
averagePower_Callback(hObject, eventdata, handles)
% hObject    handle to toi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of toi as text
%        str2double(get(hObject,'String')) returns contents of toi as a double


% --- Executes during object creation, after setting all properties.
function toi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to toi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function foi_Callback(hObject, eventdata, handles)
averagePower_Callback(hObject, eventdata, handles)
% hObject    handle to foi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of foi as text
%        str2double(get(hObject,'String')) returns contents of foi as a double


% --- Executes during object creation, after setting all properties.
function foi_CreateFcn(hObject, eventdata, handles)
% hObject    handle to foi (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --------------------------------------------------------------------
function Load_Callback(hObject, eventdata, handles)
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


% --- Executes on button press in computeTF.
function computeTF_Callback(hObject, eventdata, handles)
% hObject    handle to computeTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'tf')
    handles = rmfield(handles,'tf');
end

try
data = handles.data;
Fs = 256;

fprintf('---------------------------- \n')
fprintf('data dimensions: %d - %d - %d \nFs: %d\n', size(data), Fs);


% check whether channel selection is valid
chan = str2double(handles.chan.String);
if chan < 0 || chan > size(data,2)
    warndlg('Invalid channel number')
    return
end
% number of channels
numchans = size(data,2);

% check whether trial selection is valid
trial = str2double(handles.trial.String);
if trial < 0 || trial > size(data,3)
    warndlg('Invalid trial number')
    return
end
fprintf('settings used for time-frequency analysis: \n');
% window = str2double(get(handles.window,'String'));
window = 256; % move settings to GUI
fprintf('FFT window-size = %i samples \n', window);
% noverlap = str2double(get(handles.noverlap,'String'));
nrsamples = size(data,1);
if nrsamples  < 1280
    noverlap = window-1;
elseif nrsamples >= 1280 && nrsamples < 7680
    noverlap = 192;    
else
    noverlap = 128; % move settings to GUI
end
fprintf('FFT window step = %i samples\n', window-noverlap);
% nfft = str2double(get(handles.nfft,'String'));
nfft = 1024; % move settings to GUI
nfft = pow2(nextpow2(nfft));
fprintf('NFFT = %i\n', nfft);
% filter = str2double(get(handles.filter,'String'));
filter = 5; % move settings to GUI
if mod(filter,2)==0
    filterwarn = sprintf('2D filter size has to be an odd number. Filter size is changed from %i to %i',filter,filter+1);
    warndlg(filterwarn);
    filter = filter+1;
end
fprintf('2D filter = %i \n', filter);

% check whether onset sample is valid
onset_sample = str2double(handles.onset.String);
if ~(isnumeric(onset_sample) && (mod(onset_sample,1)==0))
    if isnumeric(onset_sample) && ~(mod(onset_sample,1)==0)
        warndlg('The provided onset sample is not an integer. No baseline correction will be applied')
        onset_sample = 0;
    elseif ~isnumeric(onset_sample)
        warndlg('The provided onset sample is not number. No baseline correction will be applied')
        onset_sample = 0;
    elseif isempty(onset_sample)
        warndlg('The provided onset sample is empty. No baseline correction will be applied')
        onset_sample = 0;
    elseif onset_sample > size(data,1)
        warndlg('The provided onset sample exceeds the samples in the dataset')
    else
        warndlg('The provided onset sample is unidentified. No baseline correction will be applied')
        onset_sample = 0;
    end
end

% get frequency range to plot
% ylimits = str2num(get(handles.YLim, 'String'));
[~, sys] = memory;
ramusage = round((sys.PhysicalMemory.Total - sys.PhysicalMemory.Available )/ sys.PhysicalMemory.Total * 100,2);
%% calculate time frequency representation
wb = waitbar(0, 'Running fourier analysis');

numtrials = size(data,3);

% hard-coded setting whether to analyse all channels at once or one at a
% time
allchans = 0;
if allchans == 1
    chans = 1:numchans;
    totaltrials = numtrials*numchans;
else
    chans = chan;
    totaltrials = numtrials;
end

count = 0;
% powermatrix = [];
for ichan = chans
    for itrial=1:numtrials
        count = count+1;
        waitbar(count/totaltrials,wb, { ...
            ['Running fourier analysis  (RAM usage: ' num2str(ramusage) '%)']; ...
            ['channel: ' num2str(ichan) ', trial: ' num2str(count) ' / ' num2str(numtrials)]; ...
            })
        [~,F,T,P] = spectrogram(data(:,ichan,itrial),window,noverlap,nfft,Fs);
        %mp = min(P);
        tf(:,:,ichan,itrial)=cfilter2(log10(abs(P)),filter); % original code
        %     tf=cfilter2((abs(P)),filter);
%         powermatrix = cat(5,powermatrix,tf);

        %% monitor RAM usage       
        [~, sys] = memory;
        ramusage = round((sys.PhysicalMemory.Total - sys.PhysicalMemory.Available )/ sys.PhysicalMemory.Total * 100,2);
        if ramusage > 95 % quit the proces if RAM is overloading
            warndlg({ ...
                'The time-frequency analysis is aborted because the computer is running out of working memory.';...
                'Try one or more of the following options to reduce working memory load:';...
                '1. Free up working memory by closing other applications';...
                '2. Adjust the analysis parameters to reduce temporal or spectral resolution'; ...
                '3. Run analyse on shorter time-windows'; ...
                '4. Use a computer with more working memory'; ...
                },'RAM overload')
            clearvars('T','F','P','tf')
            break
        end
    end
    % reset trial counter for each channel
    count = 0;
end

%% determine baseline samples
if any(str2num(get(handles.bsl, 'String')))
    bsl = str2num(get(handles.bsl, 'String'));
    if numel(bsl) > 1 % in case of two values, use this sample range
        bslT = T>bsl(1)/Fs & T < bsl(2)/Fs;
    else % in case of a single value, use sample 1 till bsl
        bsl = [1 bsl];
        bslT = T<bsl(2)/Fs;
    end
else % in case no baseline samples are provided, average over all samples
    bsl = [1 size(data,1)];
    bslT = T<bsl(2)/Fs;
end
fprintf('Baseline in samples: %i : %i\n', bsl(1), bsl(2))
fprintf('Baseline in seconds: %4.2f : %4.2f \n', bsl(1)/Fs, bsl(2)/Fs)


%% apply baseline correction
bslP = mean(tf(:,bslT,chan,:),2);
tf = bsxfun(@rdivide, tf(:,:,chan,:), bslP);
fprintf('Relative baseline correction applied per frequency (power/baseline)\n')

% rereference the X-axis to the event onset
T = T-(onset_sample/Fs);

%% store variables to handles
handles.tf.data   = tf;
handles.tf.F    = F;
handles.tf.T    = T;
guidata(hObject, handles);

% close waitbar
close(wb)

% calculate average power for the time- and freq of interest
averagePower_Callback(hObject, eventdata, handles)

% plot the results
plotTF(hObject, eventdata, handles)
fprintf('---------------------------- \n')
catch ME
    if exist('wb','var') && ishandle(wb)
        close(wb)
    end
    errordlg('Some unexpected error occured, see matlab Command Window for more information','Unexpected error')
    ME.rethrow
end

function plotTF(hObject, eventdata, handles)
if isfield(handles,'tf')
    tf  = handles.tf.data;
    T   = handles.tf.T;
    F   = handles.tf.F;
else
    warndlg('There is no time-frequency data to plot. Compute time-frequency data first')
    return
end
chan = str2double(handles.chan.String);
trial = str2double(handles.trial.String);
ylimits = str2num(handles.YLim.String);
Fselect = F> ylimits(1) & F < ylimits(2);
%% plot results    
% surf(handles.tfPlot,T,F(Fselect),mean(tf(Fselect,:,:),3),'EdgeColor','none');
surf(handles.tfPlot,T,F(Fselect),tf(Fselect,:,1,trial),'EdgeColor','none');
colormap(handles.tfPlot,jet(30)); % set colormap
view(handles.tfPlot,0,90); % set view from xy-axis angle
axis(handles.tfPlot,'xy'); 
axis(handles.tfPlot,'tight'); 

foi = str2num(handles.foi.String);
toi = str2num(handles.toi.String);

handles.tfPlot;
% hold on
% lines(toi(1),toi(2),foi(1),foi(2))
% rectangle('Position',[toi(1),foi(1),diff(toi),diff(foi)],'LineStyle','--','LineWidth',2,'EdgeColor','k')

% add axes labels 
xlabel(handles.tfPlot,'Time (s)');
ylabel(handles.tfPlot,'Frequency (Hz)');

% set y limits
if str2num(handles.XLim.String)==0
    xlim auto
else
    handles.tfPlot.XLim = str2num(handles.XLim.String);  
end

% set y limits
if str2num(handles.YLim.String)==0
    ylim auto
else
    handles.tfPlot.YLim = str2num(handles.YLim.String);
end


% add colorbar and Z-axis label
cb = colorbar(handles.tfPlot);
ztitle = 'power/baseline';
ylabel(cb, ztitle);

% set z limits
if any(get(handles.ZLim, 'String')) && numel(str2num(get(handles.ZLim, 'String')))>1
    caxis(handles.tfPlot, str2num(get(handles.ZLim, 'String')));
    cb.Limits = str2num(get(handles.ZLim, 'String'));
end






function onset_Callback(hObject, eventdata, handles)
computeTF_Callback(hObject, eventdata, handles)
% hObject    handle to onset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of onset as text
%        str2double(get(hObject,'String')) returns contents of onset as a double


% --- Executes during object creation, after setting all properties.
function onset_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onset (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function bsl_Callback(hObject, eventdata, handles)
computeTF_Callback(hObject, eventdata, handles)
% hObject    handle to bsl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of bsl as text
%        str2double(get(hObject,'String')) returns contents of bsl as a double


% --- Executes during object creation, after setting all properties.
function bsl_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bsl (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function meanPower_Callback(hObject, eventdata, handles)
% hObject    handle to meanPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of meanPower as text
%        str2double(get(hObject,'String')) returns contents of meanPower as a double


% --- Executes during object creation, after setting all properties.
function meanPower_CreateFcn(hObject, eventdata, handles)
% hObject    handle to meanPower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in prevChan.
function prevChan_Callback(hObject, eventdata, handles)
try
    chan = str2double(handles.chan.String);
catch
    warndlg('Invalid channel selection')
    return
end
if chan == 1
    chan = size(handles.data,2);
else
    chan = chan-1;
end
handles.chan.String = num2str(chan);
computeTF_Callback(hObject, eventdata, handles)
% hObject    handle to prevChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in nextChan.
function nextChan_Callback(hObject, eventdata, handles)
try
    chan = str2double(handles.chan.String);
catch
    warndlg('Invalid channel selection')
    return
end
if chan == size(handles.data,2)
    chan = 1;
else
    chan = chan+1;
end
handles.chan.String = num2str(chan);
computeTF_Callback(hObject, eventdata, handles)
% hObject    handle to nextChan (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on button press in prevTrial.
function prevTrial_Callback(hObject, eventdata, handles)
try
    trial = str2double(handles.trial.String);
catch
    warndlg('Invalid channel selection')
    return
end
if trial == 1
    trial = size(handles.tf.data,4);
else
    trial = trial-1;
end
handles.trial.String = num2str(trial);
if isfield(handles,'tf')
    plotTF(hObject, eventdata, handles)
    averagePower_Callback(hObject, eventdata, handles)
else
    computeTF_Callback(hObject, eventdata, handles)
end
% hObject    handle to prevTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in nextTrial.
function nextTrial_Callback(hObject, eventdata, handles)
try
    trial = str2double(handles.trial.String);
catch
    warndlg('Invalid channel selection')
    return
end
if trial == size(handles.tf.data,4)
    trial = 1;
else
    trial = trial+1;
end
handles.trial.String = num2str(trial);
if isfield(handles,'tf')
    plotTF(hObject, eventdata, handles)
    averagePower_Callback(hObject, eventdata, handles)
else
    computeTF_Callback(hObject, eventdata, handles)
end
% hObject    handle to nextTrial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in averagePower.
function averagePower_Callback(hObject, eventdata, handles)
tf = handles.tf.data;
T = handles.tf.T;
F = handles.tf.F;

chan  = str2double(handles.chan.String);
trial = str2double(handles.trial.String); 

% plot powerspectrum
powspec = handles.powSpec;
toi = str2num(handles.toi.String);
Tselect = T>toi(1) & T<toi(2);
ylimits = str2num(handles.YLim.String);
Fselect = F>ylimits(1) & F<ylimits(2);
plot(powspec,F(Fselect),mean(tf(Fselect,Tselect,1,trial),2))
axis(powspec, 'tight');
powspec.XLabel.String = 'Frequency (Hz)';
powspec.YLabel.String = 'Power / baseline';
powspec.Title.String = ['Power during ' num2str(toi(1)) 's to ' num2str(toi(2)) 's'];




%% power vs over time plot
tpPlot = handles.tpPlot;
foi = str2num(handles.foi.String);
Fselect = F>foi(1) & F<foi(2);
plot(tpPlot, T,mean(tf(Fselect,:,1,trial),1));
axis(tpPlot, 'tight');
tpPlot.XLabel.String = 'Time (s)';
tpPlot.YLabel.String = 'Relative power';
tpPlot.Title.String = ['Power in ' num2str(foi(1)) 'Hz to ' num2str(foi(2)) 'Hz band'];
% set y limits
if str2num(handles.XLim.String)==0
    xlim auto
else
    handles.tpPlot.XLim = str2num(handles.XLim.String);  
end
%% average power within time and frequency of interest
tois = str2num(handles.toi.String);
foi = str2num(handles.foi.String);
Tselect = T>tois(1) & T<tois(2);
Fselect = F>foi(1) & F<foi(2);
selection = tf(Fselect,Tselect,1,trial);
handles.meanPower.String = num2str(mean(selection(:)));

% hObject    handle to averagePower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in computeAverage.
function computeAverage_Callback(hObject, eventdata, handles)
if ~isfield(handles, 'tf')
    warndlg('No time frequency data found. Compute TF first.')
    return
end
handles.tf.data = mean(handles.tf.data,4);
handles.trial.String = num2str(1); % reset trial number to 1
guidata(hObject,handles);
plotTF(hObject, eventdata, handles)
averagePower_Callback(hObject, eventdata, handles)

% hObject    handle to computeAverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
if isfield(handles, 'tf')
    EEGSaveData(handles, handles.tf);
else
    warndlg('There is no time-frequency data to save.')
end
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
