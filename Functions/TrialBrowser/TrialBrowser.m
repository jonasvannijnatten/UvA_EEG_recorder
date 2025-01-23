function varargout = TrialBrowser(varargin)
% TRIALBROWSER MATLAB code for TrialBrowser.fig
%      TRIALBROWSER, by itself, creates a new TRIALBROWSER or raises the existing
%      singleton*.
%
%      H = TRIALBROWSER returns the handle to a new TRIALBROWSER or the handle to
%      the existing singleton*.
%
%      TRIALBROWSER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TRIALBROWSER.M with the given input arguments.
%
%      TRIALBROWSER('Property','Value',...) creates a new TRIALBROWSER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TrialBrowser_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TrialBrowser_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TrialBrowser

% Last Modified by GUIDE v2.5 27-Jan-2022 15:19:14

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @TrialBrowser_OpeningFcn, ...
    'gui_OutputFcn',  @TrialBrowser_OutputFcn, ...
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

% --- Executes just before TrialBrowser is made visible.
function TrialBrowser_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TrialBrowser (see VARARGIN)

handles.output = hObject;
if isempty(varargin)
    warndlg('Unable to open this tool directly, open it from the EEG_recorder main function')
    handles.closeFigure = true;
else
    handles.dir = varargin{1}.dir;
end

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes TrialBrowser wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function Load_Callback(hObject, eventdata, handles)
[filename, EEG] = EEGLoadData('time');
if any(filename) % check is any file was selected
    handles.filename.String = ['filename: ' filename]; % display filename
    data = EEG.data;
    handles.samples = size(data,1);
    handles.nrofchannels = size(data,2);
    handles.totalnroftrials = size(data,3);
    handles.trialcounter = 1;
    handles.channelcounter = 1;
    handles.trial.String = num2str(handles.trialcounter);
    handles.chan.String = num2str(handles.channelcounter);
    cla(handles.trialPlot);
    cla(handles.extraPlot);
    handles.data = data;
    handles.EEG = EEG;
    handles.filesize.String = sprintf('file size: %i - %i - %i',handles.samples,handles.nrofchannels,handles.totalnroftrials); % display filesize
    [handles.tf.T, handles.tf.F, handles.tf.data] = trial_TF_analysis(hObject, handles);
    plotData(hObject, handles);
end

guidata(hObject,handles)


% --- Outputs from this function are returned to the command line.
function varargout = TrialBrowser_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in next_trial.
function next_trial_Callback(hObject, eventdata, handles)
if handles.trialcounter == handles.totalnroftrials
    handles.trialcounter = 1;
else
    handles.trialcounter = handles.trialcounter + 1;
end
plotData(hObject, handles);
guidata(hObject,handles)

% --- Executes on button press in previous_trial.
function previous_trial_Callback(hObject, eventdata, handles)
if handles.trialcounter == 1
    handles.trialcounter = handles.totalnroftrials;
else
    handles.trialcounter = handles.trialcounter - 1;
end
plotData(hObject, handles);
guidata(hObject,handles)

% --- Executes on button press in next_chan.
function next_chan_Callback(hObject, eventdata, handles)
if handles.channelcounter == handles.nrofchannels
    handles.channelcounter = 1;
else
    handles.channelcounter = handles.channelcounter + 1;
end
[handles.tf.T, handles.tf.F, handles.tf.data] = trial_TF_analysis(hObject, handles);
plotData(hObject, handles);
guidata(hObject,handles)

% --- Executes on button press in previous_chan.
function previous_chan_Callback(hObject, eventdata, handles)
if handles.channelcounter == 1
    handles.channelcounter = handles.nrofchannels;
else
    handles.channelcounter = handles.channelcounter - 1;
end
[handles.tf.T, handles.tf.F, handles.tf.data] = trial_TF_analysis(hObject, handles);
plotData(hObject, handles);
guidata(hObject,handles)

function SD_range_Callback(hObject, eventdata, handles)
plotData(hObject, handles)

function SD_range_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function plotData(hObject, handles)
handles.trial_indicator.String = [num2str(handles.trialcounter) ' / ' num2str(handles.totalnroftrials)];
handles.channel_indicator.String = [num2str(handles.channelcounter) ' / ' num2str(handles.nrofchannels)];

time = handles.EEG.time;
data = handles.data *1e6;
cla(handles.trialPlot);
if handles.plotStats.Value
    trialMean = mean(data(:,handles.channelcounter,:),3);
    trialSD = std(data(:,handles.channelcounter,:), [], 3)*str2double(handles.SD_range.String);
    plot(handles.trialPlot, time, trialMean, 'r');
    hold(handles.trialPlot, 'on');
    plot(handles.trialPlot, time, trialMean+trialSD, 'r:');
    plot(handles.trialPlot, time, trialMean-trialSD, 'r:');
end
hold(handles.trialPlot, 'on');
plot(handles.trialPlot, time, data(:,handles.channelcounter, handles.trialcounter), 'b');
axis(handles.trialPlot, 'tight')
xlabel(handles.trialPlot,'Time (seconds)')
ylabel(handles.trialPlot,'Amplitude (\muV)')

T = handles.tf.T;
F = handles.tf.F;
tf = handles.tf.data;

surf(handles.extraPlot,T,F,tf(:,:,handles.trialcounter),'EdgeColor','none');
colormap(handles.extraPlot,jet(30)); % set colormap
view(handles.extraPlot,0,90); % set view from xy-axis angle
axis(handles.extraPlot,'xy');
axis(handles.extraPlot,'tight');
handles.extraPlot.XLim = handles.trialPlot.XLim;
xlabel(handles.extraPlot, 'Time (seconds)')
ylabel(handles.extraPlot, 'Frequency (Hz)')

if str2num(handles.YLim.String)==0
    ylim auto
else
    handles.extraPlot.YLim = str2num(handles.YLim.String);
end

cb = colorbar(handles.extraPlot);
ztitle = 'Power (^{10}log(\muV^2)';
ylabel(cb, ztitle);


guidata(hObject,handles)


function [T, F, tf] = trial_TF_analysis(hObject, handles)

try
    data = handles.data;
    Fs = handles.EEG.fsample;

    fprintf('---------------------------- \nRUNNING TIME-FREQUENCY ANALYSYS\n')
    fprintf('data dimensions: %d - %d - %d \nFs: %d samples/second\n', size(data,1), size(data,2), size(data,3), Fs);

    % number of channels
    numchans = size(data,2);

    % determine nr of samples in the segment
    nrsamples = size(data,1);
    
    % check whether channel selection is valid
    chan = str2double(handles.channelcounter);
    if chan < 0 || chan > numchans
        warndlg('Invalid channel number')
        return
    end

    % check whether trial selection is valid
    trial = str2double(handles.trialcounter);
    if trial < 0 || trial > size(data,3)
        warndlg('Invalid trial number')
        return
    end
    fprintf('settings used for time-frequency analysis: \n');
    % window = str2double(get(handles.window,'String'));
    window = handles.EEG.fsample; % move settings to GUI
    fprintf('FFT window-size = %i samples \n', window);
    fprintf('FFT window-shape = Hamming \n');

    % when the sampling rate is equal to or greater than 1000Hz
    if Fs >= 1000

        % For windows of less then 2 seconds
        if nrsamples  < 2*Fs
            noverlap = window-1;
            smoothing = 7;

            % For windows between 1 and 2 seconds
        elseif nrsamples >= 1*Fs && nrsamples <= 2*Fs
            noverlap = 0.5*Fs;
            smoothing = 11;

            % For windows of 2 seconds and more
        else
            noverlap = .1*Fs;
            smoothing = 15;
        end

        % when the sampling rate is less than 1000Hz
    elseif Fs < 1000

        % For windows less than 5 seconds
        if nrsamples  < 5*Fs
            noverlap = window-1;
            smoothing = 3;

            % for windows between 5 and 30 seconds
        elseif nrsamples >= 5*Fs && nrsamples <= 30*Fs
            noverlap = .75*Fs;
            smoothing = 5;

            % for windows of 30 seconds and more
        else
            noverlap = 0.5*Fs;
            smoothing = 7;
        end
    end
    fprintf('FFT window step = %i samples\n', window-noverlap);

    if mod(smoothing,2)==0
        filterwarn = sprintf('2D filter size has to be an odd number. Filter size is changed from %i to %i',smoothing,smoothing+1);
        warndlg(filterwarn);
        smoothing = smoothing+1;
    end
    fprintf('2D filter size = %i sampels \n', smoothing);


    %% determine the NFFT
    % this can be increased to increase spectral resolution
    if Fs <= 1000
        nfft = 1024;
    else
        nfft = pow2(nextpow2(Fs));
    end
    fprintf('NFFT = %i samples\n', nfft);

    % monitor RAM usage
    if ispc
        [~, sys] = memory;
        ramusage = num2str(round((sys.PhysicalMemory.Total - sys.PhysicalMemory.Available )/ sys.PhysicalMemory.Total * 100,2));
    else
        ramusage = 'unknown';
    end

    % check whether onset sample is valid
    onset_sample = 1;


    % get frequency range to plot
    % ylimits = str2num(get(handles.YLim, 'String'));
    if ispc
        [~, sys] = memory;
        ramusage = num2str(round((sys.PhysicalMemory.Total - sys.PhysicalMemory.Available )/ sys.PhysicalMemory.Total * 100,2));
    else
        ramusage = 'unknown';
    end

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
        chans = handles.channelcounter;
        totaltrials = numtrials;
    end

    count = 0;
    % powermatrix = [];
    for ichan = chans
        for itrial=1:numtrials
            count = count+1;
            waitbar(count/totaltrials,wb, { ...
                ['Running fourier analysis  (RAM usage: ' ramusage '%)']; ...
                ['channel: ' num2str(ichan) ', trial: ' num2str(count) ' / ' num2str(numtrials)]; ...
                })
            % de-mean the data to prevent edge artefacts in case no
            % band-pass or high-pass filter is applied.
            trial_data = data(:,ichan,itrial) - mean(data(:,ichan,itrial));
            % calculate the TF transform
            [~,F,T,P] = spectrogram(trial_data,window,noverlap,nfft,Fs);
            % power to dB
            tf(:,:,itrial)=10*log10(abs(P));
            % apply temporal smoothing
            tf(:,:,itrial)=cfilter2(tf(:,:,itrial),smoothing);

            %% monitor RAM usage
            if ispc
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
                ramusage = num2str(ramusage);
            else
                ramusage = 'unknown';
            end
        end
        % reset trial counter for each channel
        count = 0;
    end

    % rereference the X-axis to the event onset
    T = T+min(handles.EEG.time);

    %     %% store variables to handles
    handles.tf.data = tf;
    handles.tf.F    = F;
    handles.tf.T    = T;
    guidata(hObject, handles);

    % close waitbar
    close(wb)

    fprintf('---------------------------- \n')
catch ME
    if exist('wb','var') && ishandle(wb)
        close(wb)
    end
    errordlg('Some unexpected error occured, see matlab Command Window for more information','Unexpected error')
    ME.rethrow
end
guidata(hObject,handles)



function plotStats_Callback(hObject, eventdata, handles)
plotData(hObject, handles)


function YLim_Callback(hObject, eventdata, handles)
plotData(hObject, handles)


function YLim_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
