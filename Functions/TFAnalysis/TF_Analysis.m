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

% Last Modified by GUIDE v2.5 18-Oct-2019 19:54:30

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

% Update handles structure
guidata(hObject, handles);

function varargout = TF_Analysis_CloseRequestFcn(hObject, eventdata, handles)
delete(hObject)

% --- Outputs from this function are returned to the command line.
function varargout = TF_Analysis_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
if (isfield(handles,'closeFigure') && handles.closeFigure)
      TF_Analysis_CloseRequestFcn(hObject, eventdata, handles)
end

% --- Executes on button press in computeTF.
function computeTF_Callback(hObject, eventdata, handles)
% hObject    handle to computeTF (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if isfield(handles,'tf')
    handles = rmfield(handles,'tf');
end
if isfield(handles, 'indexH')
    handles = rmfield(handles, 'indexH');
end
if ~isfield(handles, 'data')
    warndlg('No EEG data loaded to run time-frequency analysis on.')
    return
end

cla(handles.powSpec)
cla(handles.tpPlot)

try
    data = handles.data;
    Fs = handles.EEG.fsample;
    
    fprintf('---------------------------- \nRUNNING TIME-FREQUENCY ANALYSYS\n')
    fprintf('data dimensions: %d - %d - %d \nFs: %d samples/second\n', size(data,1), size(data,2), size(data,3), Fs);
    
    
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
    window = handles.EEG.fsample; % move settings to GUI
    fprintf('FFT window-size = %i samples \n', window);    
    fprintf('FFT window-shape = Hamming \n');
    % noverlap = str2double(get(handles.noverlap,'String'));
    nrsamples = size(data,1);
    if Fs >= 1000
        if nrsamples  < 2*Fs    
            noverlap = window-1;
        elseif nrsamples >= 1*Fs && nrsamples < 2*Fs
            noverlap = 0.5*Fs;
        else
            noverlap = .1*Fs;
        end
    elseif Fs < 1000
        if nrsamples  < 5*Fs
            noverlap = window-1;
        elseif nrsamples >= 5*Fs && nrsamples < 30*Fs
            noverlap = .75*Fs;
        else
            noverlap = 0.5*Fs;
        end
    end
%     original method of determining noverlap
%     if nrsamples  < 1280
%         noverlap = window-1;
%     elseif nrsamples >= 1280 && nrsamples < 7680
%         noverlap = 192;
%     else
%         noverlap = 128; % move settings to GUI
%     end

    fprintf('FFT window step = %i samples\n', window-noverlap);
    % nfft = str2double(get(handles.nfft,'String'));
    nfft = Fs*4; % move settings to GUI
    nfft = pow2(nextpow2(nfft));
    fprintf('NFFT = %i samples\n', nfft);
    % filter = str2double(get(handles.filter,'String'));
    filter = 5; % move settings to GUI
    if mod(filter,2)==0
        filterwarn = sprintf('2D filter size has to be an odd number. Filter size is changed from %i to %i',filter,filter+1);
        warndlg(filterwarn);
        filter = filter+1;
    end
    fprintf('2D filter size = %i sampels \n', filter);
    
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
        chans = chan;
        totaltrials = numtrials;
    end    

    count = 0;
    % powermatrix = [];
    for ichan = chans
        % Save channel number(s)
        if allchans == 1
            handles.channelLabel(ichan) = handles.EEG.channelLabels(ichan);
            handles.channelTypes(ichan) = handles.EEG.channelTypes(ichan);
        else
            handles.channelLabel = handles.EEG.channelLabels(ichan);
            handles.channelTypes = handles.EEG.channelTypes(ichan);
        end
        for itrial=1:numtrials
            count = count+1;
            waitbar(count/totaltrials,wb, { ...
                ['Running fourier analysis  (RAM usage: ' ramusage '%)']; ...
                ['channel: ' num2str(ichan) ', trial: ' num2str(count) ' / ' num2str(numtrials)]; ...
                })
            [~,F,T,P] = spectrogram(data(:,ichan,itrial),window,noverlap,nfft,Fs);
            %mp = min(P);
            tf(:,:,itrial)=cfilter2(log10(abs(P)),filter); % original code
            %     tf=cfilter2((abs(P)),filter);
            %         powermatrix = cat(5,powermatrix,tf);
            
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
    
    %% baseline correction  
%     handles.bslmethod.Value = 5;
    % apply correction
    if handles.bslmethod.Value == 2
        % normalize data to prevent extreme values in the resulting TF
        tf = (tf - min(tf(:))) / (max(tf(:)) - min(tf(:)));
        % calculate power during baseline
        bslP = mean(tf(:,bslT,:),2);
        % relative baseline correction: power / baseline power
%         tf = bsxfun(@ldivide, tf, bslP);
        tf = bsxfun(@rdivide, tf, bslP);
        fprintf('Relative baseline correction applied per frequency (power/baseline)\n')
        handles.history.base = sprintf('Relative baseline correction per frequency (power/baseline) applied at %s\n\n', datetime);
        
    elseif handles.bslmethod.Value == 4
        % calculate power during baseline
        bslP = mean(tf(:,bslT,:),2);
        % absolute baseline correction: power - baseline power
        tf = bsxfun(@minus,tf,bslP);
        fprintf('Absolute baseline correction applied per frequency (power-baseline)\n')
        handles.history.base = sprintf('Absolute baseline correction per frequency (power-baseline) applied at %s\n\n', datetime);
        
    elseif handles.bslmethod.Value == 3
        % normalized power       
        % make sure all values are positive for correct normalization
        tf = tf + abs(min(tf(:)));
        % power normalization: power / average power
        tf = bsxfun(@rdivide,tf,mean(tf,1));
        %     tf = bsxfun(@times,sum(tf,1),bsxfun(@rdivide,tf,sum(tf,1)));
        fprintf('Power normalized per time point(power/average power)\n')
        handles.history.base = sprintf('Normalized power baseline correction per time point (power/average power) applied at %s\n\n', datetime);
        
    elseif handles.bslmethod.Value == 5
        % make sure all values are positive for correct normalization
        tf = tf + abs(min(tf(:)));
        % calculate power during baseline
        bslP = mean(tf(:,bslT,:),2);
        % relative baseline correction: 10*log10(power/baseline power)
        tf = 10*log10(bsxfun(@ldivide, tf, bslP));
        fprintf('Decibel baseline correction applied per frequency 10*log10(power/baseline power)\n')
        handles.history.base = sprintf('Decibel baseline correction per frequency 10*log10(power/baseline power) applied at %s\n\n', datetime);
        
    elseif handles.bslmethod.Value == 1
        fprintf('no baseline correction has been applied\n')
    else
        warndlg('huh?\n')
    end
    % rereference the X-axis to the event onset
    T = T-(onset_sample/Fs);

    % reduce data size from 4 to 3 dimensions
    % 3rd dimension (channel) is always 1 after TF computation
    tf = squeeze(tf);
    
    [d1, d2, d3] = size(tf);
    handles.filesizeTF.String = sprintf('TF file size: %i - %i - %i',d1,d2,d3); % display filesize
    
    %% store variables to handles
    handles.tf.data = tf;
    handles.tf.F    = F;
    handles.tf.T    = T;
    handles.history.TF = sprintf('TF analysis applied at %s\n\n', datetime);
    guidata(hObject, handles);

    
    
    % close waitbar
    close(wb)
    
    % plot the results
    plotTF(hObject, handles)
    
    % calculate average power for the time- and freq of interest
%     averagePower_Callback(hObject, eventdata, handles)
    
    fprintf('---------------------------- \n')
catch ME
    if exist('wb','var') && ishandle(wb)
        close(wb)
    end
    errordlg('Some unexpected error occured, see matlab Command Window for more information','Unexpected error')
    ME.rethrow
end


function plotTF(hObject, handles)
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
surf(handles.tfPlot,T,F(Fselect),tf(Fselect,:,trial),'EdgeColor','none');
colormap(handles.tfPlot,jet(30)); % set colormap
view(handles.tfPlot,0,90); % set view from xy-axis angle
axis(handles.tfPlot,'xy');
axis(handles.tfPlot,'tight');

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
ztitle = 'Power';
ylabel(cb, ztitle);

% set z limits
if any(get(handles.ZLim, 'String')) && numel(str2num(get(handles.ZLim, 'String')))>1
    caxis(handles.tfPlot, str2num(get(handles.ZLim, 'String')));
    cb.Limits = str2num(get(handles.ZLim, 'String'));
end



% --- Executes on button press in computeAverage.
function computeAverage_Callback(hObject, eventdata, handles)
if ~isfield(handles, 'tf')
    warndlg('No time frequency data found. Run time-frequency analysis first.')
    return
end
handles.tf.data = mean(handles.tf.data,3);
handles.trial.String = num2str(1); % reset trial number to 1
[d1, d2, d3] = size(handles.tf.data);
handles.filesizeTF.String = sprintf('TF file size: %i - %i - %i',d1,d2,d3); % display filesize

% Store averaging in history
handles.history.average = sprintf('Data averaged over trial/subjects at %s\n\n', datetime);

% remove third dim from EEG struct
handles.EEG.dims(3) = [];

guidata(hObject,handles);
plotTF(hObject, handles)
averagePower_Callback(hObject, eventdata, handles)



% hObject    handle to computeAverage (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function addFrame(hObject, handles)
% get time and frequency range
foi = str2num(handles.foi.String);
toi = str2num(handles.toi.String);

if isfield(handles,'indexH') && ishandle(handles.indexH)
    % reset frame to TF plot to indicate time-frequency range of interest
    handles.indexH.XData = [toi(1),toi(2),toi(2),toi(1),toi(1)];
    handles.indexH.YData = [foi(1),foi(1),foi(2),foi(2),foi(1)];
    
    % reset lines to powerspectrum to indicate frequency band of interest
     handles.powSpecLines = line(...
        [foi(1) foi(1) nan foi(2) foi(2)], ...
        [handles.powSpec.YLim(1) handles.powSpec.YLim(2) nan handles.powSpec.YLim(1) handles.powSpec.YLim(2)], ...
        'Parent', handles.powSpec,...
        'Color','k', ...
        'LineStyle','--' ...
        );
    
    % reset lines to time-power plot to indicate time window of interest
        handles.tpPlotLines = line( ...
        [toi(1) toi(1) nan toi(2) toi(2)], ...
        [handles.tpPlot.YLim(1) handles.tpPlot.YLim(2) nan handles.tpPlot.YLim(1) handles.tpPlot.YLim(2)], ...
        'Parent', handles.tpPlot,...
        'Color','k', ...
        'LineStyle','--' ...
        );
    
else
    % add frame to TF plot to indicate time-frequency range of interest
    hold(handles.tfPlot, 'on');
    handles.indexH = plot3(...
        [toi(1),toi(2),toi(2),toi(1),toi(1)], ...
        [foi(1),foi(1),foi(2),foi(2),foi(1)], ...
        repmat(max(handles.tfPlot.ZLim),[1 5]), ...
        'Parent',handles.tfPlot, ...
        'Color','k', ...
        'LineStyle','--' ...
        );
    hold(handles.tfPlot, 'off');
    
    % add lines to powerspectrum to indicate frequency band of interest
    handles.powSpecLines = line(...
        [foi(1) foi(1) nan foi(2) foi(2)], ...
        [handles.powSpec.YLim(1) handles.powSpec.YLim(2) nan handles.powSpec.YLim(1) handles.powSpec.YLim(2)], ...
        'Parent', handles.powSpec,...
        'Color','k', ...
        'LineStyle','--' ...
        );

    % add lines to time-power plot to indicate time window of interest  
    handles.tpPlotLines = line( ...
        [toi(1) toi(1) nan toi(2) toi(2)], ...
        [handles.tpPlot.YLim(1) handles.tpPlot.YLim(2) nan handles.tpPlot.YLim(1) handles.tpPlot.YLim(2)], ...
        'Parent', handles.tpPlot,...
        'Color','k', ...
        'LineStyle','--' ...
        );

end
% repmat(max(max(handles.tfPlot.Children.ZData)),[1 5]) ;

guidata(hObject, handles)


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
if ~isfield(handles, 'tf') && isfield(handles, 'data')
    computeTF_Callback(hObject, eventdata, handles)
elseif isfield(handles, 'tf')
    plotTF(hObject, handles)
end
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
hObject.TooltipString = sprintf('Set the range of the X-axis (time range) \n Set to 0 for automatic scaling \nOtherwise, provide the min and max value');


function YLim_Callback(hObject, eventdata, handles)
if ~isfield(handles, 'tf') && isfield(handles, 'data')
    computeTF_Callback(hObject, eventdata, handles)
elseif isfield(handles, 'tf')
    plotTF(hObject, handles)
end
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
hObject.TooltipString = sprintf('Set the range of the Y-axis (frequency range) \n Set to 0 for automatic scaling \nOtherwise, provide the min and max value');


function ZLim_Callback(hObject, eventdata, handles)
if ~isfield(handles, 'tf') && isfield(handles, 'data')
    computeTF_Callback(hObject, eventdata, handles)
elseif isfield(handles, 'tf')
    plotTF(hObject, handles)
end
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
hObject.TooltipString = sprintf('Set the range of the Z-axis (color scale) \n Set to 0 for automatic scaling \nOtherwise, provide the min and max value');


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
hObject.TooltipString = sprintf('The time-window of interest over which to average the power. \n Provide the starting point and end point in seconds. \n For example: 0 1 .');


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

hObject.TooltipString = sprintf('The frequency band of interest over which to average the power. \n Provide the lower and upper frequency of the frequency band. \n For example: 8 12');

% --------------------------------------------------------------------
function Load_Callback(hObject, eventdata, handles)
[filename, EEG] = EEGLoadData(["time","tf"]);
if any(filename) % check is any file was selected
    handles.EEG = EEG;
    handles.filename.String = ['filename: ' filename]; % display filename
    handles.trial.String = '1';
    handles.chan.String = '1';
    % if domain is time or frequency, data is a matrix (regular EEG data) -> save data to handles
    if strcmp(EEG.domain, 'time') || strcmp(EEG.domain, 'frequency')
        data = EEG.data;
        handles.data = data;
        [d1, d2, d3] = size(data);  % determine the data dimensions
        if ~isempty(num2str(find(EEG.time==0)))
            handles.onset.String = num2str(find(EEG.time==0));
        end
        % remove any old time frequency data set
        if isfield(handles,'tf'); handles = rmfield(handles,'tf'); end
        cla(handles.tfPlot); cla(handles.powSpec); cla(handles.tpPlot);
        handles.bsl.String = ' ';
        handles.filesize.String = sprintf('file size: %i - %i - %i',d1,d2,d3); % display filesize
        handles.filesizeTF.String = ' ';
    % if dmoain is tf, data is a struct (time-frequency data) -> save data to handles
    elseif strcmp(EEG.domain, 'tf')
        data.data = EEG.data;
        data.T = EEG.time;
        data.F = EEG.frequency;
        handles.tf = data;
        [d1, d2, d3] = size(data.data); % determine the data dimensions
        % remove any old data set
        if isfield(handles,'data'); handles = rmfield(handles,'data'); end
        plotTF(hObject, handles)
%         averagePower_Callback(hObject, eventdata, handles)
        handles.filesizeTF.String = sprintf('TF filesize: %i - %i - %i',d1,d2,d3); % display filesize
        handles.filesize.String = ' ';
    end
    handles.chan.String = 1;
    handles.trial.String = 1;
end

guidata(hObject,handles)








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
hObject.TooltipString = sprintf('Provide the sample number of the stimulus/response onset /n This sample number will be set to T=0');


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
hObject.TooltipString = sprintf(['This determines what is taken as the baseline period: \n ' ...
    'When left empty, the whole recording / trial is taken as baseline. \n ' ...
    'When a single sample number is provided, the period until this sample is taken as baseline. \n' ...
    'When two sample numbers are provided, the period between these samples is taken as baseline. '...
    ]);


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
if isfield(handles,'data')
    if chan == 1
        chan = size(handles.data,2);
    else
        chan = chan-1;
    end
    handles.chan.String = num2str(chan);
    computeTF_Callback(hObject, eventdata, handles)
elseif isfield(handles,'tf')
    warndlg('this only applies to time-series data, but does not work for TF data')
end
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

if isfield(handles,'data')
    if chan == size(handles.data,2)
        chan = 1;
    else
        chan = chan+1;
    end
    handles.chan.String = num2str(chan);
    computeTF_Callback(hObject, eventdata, handles)
elseif isfield(handles,'tf')
    warndlg('this only applies to time-series data, but does not work for TF data')
end

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
if isfield(handles,'data') && ~isfield(handles,'tf')
    if trial == 1
        trial = size(handles.data,3);
    else
        trial = trial-1;
    end
    handles.trial.String = num2str(trial);
    computeTF_Callback(hObject, eventdata, handles)
elseif isfield(handles,'tf')
    if trial == 1
        trial = size(handles.tf.data,3);
    else
        trial = trial-1;
    end
    handles.trial.String = num2str(trial);
    plotTF(hObject, handles)
    averagePower_Callback(hObject, eventdata, handles)
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
if isfield(handles,'data') && ~isfield(handles,'tf')
    if trial == size(handles.data,3)
        trial = 1;
    else
        trial = trial+1;
    end
elseif isfield(handles,'tf')
    if trial == size(handles.tf.data,3)
        trial = 1;
    else
        trial = trial+1;
    end
end
handles.trial.String = num2str(trial);
if isfield(handles,'tf')
    plotTF(hObject, handles)
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
%% to-do add inputcheck whether nr of values == 2
powspec = handles.powSpec;
toi = str2num(handles.toi.String);
Tselect = T>toi(1) & T<toi(2);
ylimits = str2num(handles.YLim.String);
Fselect = F>ylimits(1) & F<ylimits(2);
plot(powspec,F(Fselect),mean(tf(Fselect,Tselect,trial),2))

axis(powspec, 'tight');
powspec.XLabel.String = 'Frequency (Hz)';
powspec.YLabel.String = 'Power';
powspec.Title.String = ['Power during ' num2str(toi(1)) 's to ' num2str(toi(2)) 's'];

%% power vs over time plot
tpPlot = handles.tpPlot;
foi = str2num(handles.foi.String);
Fselect = F>foi(1) & F<foi(2);
plot(tpPlot, T,mean(tf(Fselect,:,trial),1));
axis(tpPlot, 'tight');
tpPlot.XLabel.String = 'Time (s)';
tpPlot.YLabel.String = 'Power';
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
selection = tf(Fselect,Tselect,trial);
handles.meanPower.String = num2str(mean(selection(:)));

% add frames to plots to indicate time & frequency ranges of interest
addFrame(hObject, handles)


% hObject    handle to averagePower (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



% --------------------------------------------------------------------
function Save_Callback(hObject, eventdata, handles)
if isfield(handles, 'tf')
    EEG = handles.EEG;
    
    % History needs to be stored
    % Store tf data and change related information in struct
    EEG.data = handles.tf.data;
    EEG.dims = ["frequencies", "times"];
    EEG.domain = "tf";
    EEG.time = handles.tf.T;
    EEG.frequency = handles.tf.F;
    
    % Store analyzed channel label and type
    EEG.channelLabels = handles.channelLabel;
    EEG.channelTypes = handles.channelTypes;
    
    % Update history depending on whether TF analysis, baseline correction and averaging was applied
    % History is updated here to make it flexible while user is still using the tool
    if isfield(handles.history, 'TF') && isfield(handles.history, 'base') && isfield(handles.history, 'average')
        EEG.history = EEG.history + sprintf("\n\n") + handles.history.base + handles.history.TF +handles.history.average;
    elseif isfield(handles.history, 'TF') && isfield(handles.history, 'base')
        EEG.history = EEG.history + sprintf("\n\n") + handles.history.base + handles.history.TF;
    elseif isfield(handles.history, 'TF') && isfield(handles.history, 'average')
        EEG.history = EEG.history + sprintf("\n\n") + handles.history.TF + handles.history.average;
    elseif isfield(handles.history, 'TF')
        EEG.history = EEG.history + sprintf("\n\n") + handles.history.TF;
    end
    
    % Save EEG data struct
    EEGSaveData(EEG,'tf');
else
    warndlg('There is no time-frequency data to save.')
end
% hObject    handle to Save (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on selection change in bslmethod.
function bslmethod_Callback(hObject, eventdata, handles)
% hObject    handle to bslmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns bslmethod contents as cell array
%        contents{get(hObject,'Value')} returns selected item from bslmethod


% --- Executes during object creation, after setting all properties.
function bslmethod_CreateFcn(hObject, eventdata, handles)
% hObject    handle to bslmethod (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
hObject.TooltipString = sprintf('Choose a baseline correction method. See the help file for more information');


% --- Executes during object creation, after setting all properties.
function powSpec_CreateFcn(hObject, eventdata, handles)


% Hint: place code in OpeningFcn to populate powSpec


% --------------------------------------------------------------------
function Help_Callback(hObject, eventdata, handles)
% hObject    handle to Help (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
web('TF_Analysis_help.html', '-helpbrowser')


% --- Executes on button press in Export_tpPlot_fig.
function Export_tpPlot_fig_Callback(hObject, eventdata, handles)
tpFig = figure;
copyobj(handles.tpPlot, tpFig);


% --- Executes on button press in Export_tpPlot_data.
function Export_tpPlot_data_Callback(hObject, eventdata, handles)
data = handles.tpPlot.Children(2).YData';
EEG = handles.EEG;

% Store power over time data
EEG.data = data;
EEG.dims = "times";
EEG.time = handles.tf.T;
EEG.frequency = handles.tf.F;

% Store analyzed channel label and type
EEG.channelLabels = handles.channelLabel;
EEG.channelTypes = handles.channelTypes;

% Update history depending on whether TF analysis, baseline correction and averaging was applied
% History is updated here to make it flexible while user is still using the tool
if isfield(handles.history, 'TF') && isfield(handles.history, 'base') && isfield(handles.history, 'average')
    EEG.history = [EEG.history handles.history.base handles.history.TF handles.history.average];
elseif isfield(handles.history, 'TF') && isfield(handles.history, 'base')
    EEG.history = [EEG.history handles.history.base handles.history.TF];
elseif isfield(handles.history, 'TF') && isfield(handles.history, 'average')
    EEG.history = [EEG.history handles.history.TF handles.history.average];
elseif isfield(handles.history, 'TF')
    EEG.history = [EEG.history handles.history.TF];
end

% Save EEG data struct
EEGSaveData(EEG, 'TimePowerData');

% --- Executes on button press in Export_powSpec_fig.
function Export_powSpec_fig_Callback(hObject, eventdata, handles)
powSpecFig = figure;
copyobj(handles.powSpec, powSpecFig);


% --- Executes on button press in Export_powSpec_data.
function Export_powSpec_data_Callback(hObject, eventdata, handles)
EEG = handles.EEG;

% Store power spectrum data
% get time range of interest
tois = str2double(strsplit(handles.toi.String));
% average power over that time range
Tselect = handles.tf.T>tois(1) & handles.tf.T<tois(2);
EEG.data = mean(handles.tf.data(:,Tselect),2);

% update data information in the struct
EEG.dims = "frequencies";
EEG.domain = "frequency";
EEG.frequency = handles.tf.F;
% remove the time information from the struct.
EEG = rmfield(EEG,'time');

% Store analyzed channel label and type
EEG.channelLabels = handles.channelLabel;
EEG.channelTypes = handles.channelTypes;

% Update history depending on whether TF analysis, baseline correction and averaging was applied
% History is updated here to make it flexible while user is still using the tool
if isfield(handles.history, 'TF') && isfield(handles.history, 'base') && isfield(handles.history, 'average')
    EEG.history = [EEG.history handles.history.base handles.history.TF handles.history.average];
elseif isfield(handles.history, 'TF') && isfield(handles.history, 'base')
    EEG.history = [EEG.history handles.history.base handles.history.TF];
elseif isfield(handles.history, 'TF') && isfield(handles.history, 'average')
    EEG.history = [EEG.history handles.history.TF handles.history.average];
elseif isfield(handles.history, 'TF')
    EEG.history = [EEG.history handles.history.TF];
end

% Save EEG data struct
EEGSaveData(EEG, 'PowerSpectrum');


% --- Executes on button press in Export_TF_fig.
function Export_TF_fig_Callback(hObject, eventdata, handles)
TFFig = figure;
h = copyobj(handles.tfPlot, TFFig);
cb = colorbar('eastoutside');
ylabel(cb, 'power');

function zz = cfilter2( yy,nn )
% 2D filter of yy, convolutes with nn x nn smoother nn must be uneven
% Detailed explanation goes here
if nn==1
    zz=yy;
    return
end
if rem(nn,2)==0
   errordlg('You must filter with an uneven width, no action taken','Error','modal'); 
   zz=yy;
   return
end
B=ones(nn,nn); 
B=B*0.5;
mm=1+floor(nn/2);
if nn>3
  B(mm-1:mm+1,mm-1:mm+1)=0.75;
end
if nn>1
  B(mm,mm)=1;
end
summat=sum(sum(B));
B=B/summat;
zz=yy; kk=size(yy);
for ii=1:mm-1
    a=zz(:,1); b=zz(:,end); zz=[a zz b];
    c=zz(1,:); d=zz(end,:); zz=[c; zz; d];
end
zz=conv2(zz,B);
zz=zz((mm+mm-1):(mm+mm+kk(1)-2),(mm+mm-1):(mm+mm+kk(2)-2));
