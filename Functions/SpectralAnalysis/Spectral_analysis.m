function varargout = Spectral_analysis(varargin)
% SPECTRAL_ANALYSIS MATLAB code for Spectral_analysis.fig
%      SPECTRAL_ANALYSIS, by itself, creates a new SPECTRAL_ANALYSIS or raises the existing
%      singleton*.
%
%      H = SPECTRAL_ANALYSIS returns the handle to a new SPECTRAL_ANALYSIS or the handle to
%      the existing singleton*.
%
%      SPECTRAL_ANALYSIS('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in SPECTRAL_ANALYSIS.M with the given input arguments.
%
%      SPECTRAL_ANALYSIS('Property','Value',...) creates a new SPECTRAL_ANALYSIS or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Spectral_analysis_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Spectral_analysis_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Spectral_analysis

% Last Modified by GUIDE v2.5 13-Mar-2018 14:45:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @Spectral_analysis_OpeningFcn, ...
    'gui_OutputFcn',  @Spectral_analysis_OutputFcn, ...
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


% --- Executes just before Spectral_analysis is made visible.
function Spectral_analysis_OpeningFcn(hObject, eventdata, handles, varargin)
handles.output = hObject;
handles.dir = varargin{1}.dir;
guidata(hObject, handles);

% UIWAIT makes Spectral_analysis wait for user response (see UIRESUME)
% uiwait(handles.figure1);

function varargout = Spectral_analysis_OutputFcn(hObject, eventdata, handles)
varargout{1} = handles.output;
function pushbutton1_Callback(hObject, eventdata, handles)
global time;
global y; global dur; global fs; global colm; global colms
global data2;
y = data2;
fs = str2double(get(handles.fs,'String'));
colm = get(handles.colm,'String');
colms = eval(colm);
test3 = length(colms);
labels = [];
plotColor = {'b','g','r','c','m','y','k','-b'};
figure;
dur = length(y(:,colms(1)))/fs;
time = [0:dur/length(y(:,colms(1))):dur]';
time = time(1:length(y(:,colms(1))),1);
for k = 1:test3
    labels = [labels; ['data ' num2str(colms(k))]];
    subplot(2,1,1)
    c = cell2mat(plotColor(k));
    plot(time,y(:,colms(k)),c);hold on;
end
xlabel('time (s)')
ylabel('Amplitude (V)')
title('EEG in time domain')
legend(labels);
hold off;
[l m] = size(y);
m = length(y(:,colms(1)));
n = pow2(nextpow2(m));
for k = 1:test3
    subplot(2,1,2)
    dfty1 = fft(y(:,colms(k))-mean(y(:,colms(k))),n);
    f = (0:n-1)*(fs/n);
    p = dfty1.*conj(dfty1)/n;
    c = cell2mat(plotColor(k));
    plot(f(1:floor(n/2)),p(1:floor(n/2)),c);hold on;
end
hold off;
xlabel('Frequency (Hz)')
ylabel('Single sided amplitude spectrum (V)')
title('{EEG in frequency domain}')
legend(labels);

function colm_Callback(hObject, eventdata, handles)
global colm
colm = str2double(get(hObject,'String')); return

function colm_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function fs_Callback(hObject, eventdata, handles)
global fs
fs = str2double(get(hObject,'String'));
return
function fs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
% --------------------------------------------------------------------
function load_Callback(hObject, eventdata, handles)
global filenameq;global data2
curdir = cd;
cd([curdir filesep 'Data']);
[filenameq, pathname] = ...
    uigetfile({'*.mat';},'Select a 2D array');
cd(curdir);
if any(filenameq)
    set(handles.f_name,'string',filenameq);
    load([pathname filenameq]);
    data2 = data;
    [str1] = size(data2);
    str = num2str(str1);
    set(handles.f_size,'string',str);
    clear data;
end
% --------------------------------------------------------------------
function help_Callback(hObject, eventdata, handles)
web('Spectral_help.htm', '-helpbrowser')
function Fs_Callback(hObject, eventdata, handles)
global Fs
Fs = str2double(get(hObject,'String'));
return
function Fs_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function window_Callback(hObject, eventdata, handles)
global window
window = str2double(get(hObject,'String'));
return
function window_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function noverlap_Callback(hObject, eventdata, handles)
global noverlap
noverlap = str2double(get(hObject,'String')); return
function noverlap_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function nfft_Callback(hObject, eventdata, handles)
global nfft
nfft = str2double(get(hObject,'String')); return
function nfft_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function filter_Callback(hObject, eventdata, handles)
global filter
filter = str2double(get(hObject,'String')); return

function filter_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function chan_Callback(hObject, eventdata, handles)
global chan
chan = get(hObject,'String'); return
function chan_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

%jim edit: code for new gui stuff

% --- Executes during object creation, after setting all properties.
function setymin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setymin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    
end

% --- Executes during object creation, after setting all properties.
function setymax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to setymax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
    
end
%%%%%%%%%%%%%%%%%%%%%
function setymin_Callback(hObject, eventdata, handles)
global value_y_min
value_y_min = str2double(get(hObject,'String')); return




function setymax_Callback(hObject, eventdata, handles)
global value_y_max
value_y_max = str2double(get(hObject,'String')); return

%%%%%%%%%%%%%%%%%



function plot_spec_Callback(hObject, eventdata, handles)
global chan;global filter;global nfft;global noverlap;global window;global Fs
global data2; y = data2;global a;a=[]; global b;b=[]; global cmi; cmi=[];global cma;cma=[]; global value_y_min; global value_y_max
chan = get(handles.chan,'String');
chan = eval(chan);
fprintf('---------------------------- \n')
fprintf('settings used for time-frequency analysis: \n');
window = str2double(get(handles.window,'String'));
fprintf('sliding window-size = %i \n', window);
noverlap = str2double(get(handles.noverlap,'String'));
fprintf('sliding step in samples = %i \n', noverlap);
nfft = str2double(get(handles.nfft,'String'));
nfft = pow2(nextpow2(nfft));
fprintf('NFFT = %i\n', nfft);
filter = str2double(get(handles.filter,'String'));
if mod(filter,2)==0
    filterwarn = sprintf('2D filter size has to be an odd number. Filter size is changed from %i to %i',filter,filter+1);
    warndlg(filterwarn);
    filter = filter+1;
end
fprintf('2D filter = %i \n', filter);
Fs = str2double(get(handles.fs,'String'));
test = length(chan);
h2 = figure;
onset_sample = eval(get(handles.onset_sample, 'String'));
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
    else
        warndlg('The provided onset sample is unidentified. No baseline correction will be applied')
        onset_sample = 0;
    end
end
value_y_min = str2double(get(handles.setymin,'String'));

value_y_max = str2double(get(handles.setymax,'String'));
if size(y,3) == 1
    for k = 1:test
        [S,F,T,P] = spectrogram(y(:,chan(k)),window,noverlap,nfft,Fs);
        mp = min(P);
        F = value_y_min:value_y_max; %jim edit: from the frequencies take only the ones you are interested in
        q=cfilter2(log10(abs(P)),filter);
        ax(k) = subplot(test,1,k);
        Fselect = F> value_y_min & F < value_y_max;
        if onset_sample
            fprintf('The first %i samples, or %d seconds, are used as baseline period \n', onset_sample, onset_sample/Fs)
            T = T-(onset_sample/Fs);
            bslT = T<0;
            bslP = mean(q(:,bslT,:),2);
            q = bsxfun(@minus, q, bslP);
        end
        surf(T,F(Fselect),q(Fselect,:),'EdgeColor','none'); %jim edit: adjust q for the new frequencies
        axis xy; axis tight; colormap(jet(30));view(0,90);
        xlabel('Time (s)');
        ylabel('Frequency (Hz)');
        
        colorbar();
        linkaxes(ax,'xy')
        [a b] = caxis;
        if isempty(cmi)==1
            cmi = a;
        else
            if a<cmi
                cmi = a;
            end
        end
        if isempty(cma)==1
            cma = b;
        else
            if b>cma
                cma = b;
            end
        end
        if k ==1
            title('{\bf Spectrogram of selected channels with optimized colormap/subplot}')
        end
    end
    
    
elseif size(y,3)>1
    powermatrix = [];
    for k = 1:test
        for itrial=1:size(y,3)
            [S,F,T,P] = spectrogram(y(:,chan(k),itrial),window,noverlap,nfft,Fs);
            mp = min(P);
            q=cfilter2(log10(abs(P)),filter);
            powermatrix = cat(3,powermatrix,q);
        end
        q = mean(powermatrix,3);
        ax(k) = subplot(test,1,k);
        Fselect = F> value_y_min & F < value_y_max;
        if onset_sample
            fprintf('The first %i samples, or %d seconds, are used as baseline period \n', onset_sample, onset_sample/Fs)
            T = T-(onset_sample/Fs);
            bslT = T<0;
            bslP = mean(q(:,bslT,:),2);
            q = bsxfun(@minus, q, bslP);
        end
        surf(T,F(Fselect),q(Fselect,:),'EdgeColor','none'); %jim edit: adjust q for the new frequencies
        %         caxis([cmi cma]);
        axis xy; axis tight; colormap(jet(30));view(0,90);
        xlabel('Time (s)');
        ylabel('Frequency (Hz)');        
        ylim([value_y_min value_y_max])
        colorbar();
        linkaxes(ax,'xy')
        [a b] = caxis;
    end
    if isempty(cmi)==1
        cmi = a;
    else
        if a<cmi
            cmi = a;
        end
    end
    if isempty(cma)==1
        cma = b;
    else
        if b>cma
            cma = b;
        end
    end
    caxis([cmi cma])
    
%     h3 = figure;
%     for k = 1:test
%         [S,F,T,P] = spectrogram(y(:,chan(k)),window,noverlap,nfft,Fs);
%         mp = min(P);
%         q=cfilter2(log10(abs(P)),filter);
%         ax(k) = subplot(test,1,k);
%         surf(T,F,q,'EdgeColor','none');
%         caxis([cmi cma])
%         axis xy; axis tight; colormap(jet(30));view(0,90);
%         ylim([value_y_min value_y_max]) %jimedit Set y axis for plots
%         xlabel('Time (s)');
%         ylabel('Frequency (Hz)');
%         colorbar();
%         linkaxes(ax,'xy')
%         [a b] = caxis;
%         
%         if k ==1
%             title('{\bf Spectrogram of selected channels with same colormap in each subplot}')
%         end
%     end
end
clear a; clear b; clear cmi; clear cma;
fprintf('---------------------------- \n')

function plot_fft_Callback(hObject, eventdata, handles)
global fs; global chanfft; global data2;
y = data2;
fs = str2double(get(handles.fs,'String'));
chanfft = get(handles.chanfft,'String');
chanfft = eval(chanfft);
test2 = length(chanfft);
if size(y,3) == 1
    h5 = figure;
    dur = length(y(:,chanfft(1)))/fs;
    time = [0:dur/length(y(:,chanfft(1))):dur]';
    time = time(1:length(y(:,chanfft(1))),1);
    for k = 1:test2
        ax(k) = subplot(test2,2,(2*k)-1);
        plot(time,y(:,chanfft(k)),'b')
        ylabel('Amplitude (V)')
        linkaxes(ax,'x')
        legend(['channel ' num2str(k) ]);
        if k==1; title('EEG signal in the time domain'); end
    end
    
    xlabel('time (s)')
    % h5 = figure;
    m = length(y(:,chanfft(1)));
    n = nextpow2(m)
    for k = 1:test2
        ax2(k) = subplot(test2,2,(2*k));
        dfty1 = fft(y(:,chanfft(k))-mean(y(:,chanfft(k))),n);
        f = (0:n-1)*(fs/n);
        p = dfty1.*conj(dfty1)/n;
        plot(f(1:floor(n/2)),p(1:floor(n/2)),'b')
        ylabel('FFT (V)')
        linkaxes(ax2,'x')
        legend(['channel ' num2str(k) ]);
        if k==1; title('EEG signal in the frequency domain'); end
    end
    xlabel('Frequency (Hz)')
    
    %% For a dataset with multiple trials in the 3rd dimension
elseif size(y,3)>1
    h5 = figure;
    labels = [];
    dur = length(y(:,chanfft(1)))/fs;
    time = [0:dur/length(y(:,chanfft(1))):dur]';
    time = time(1:length(y(:,chanfft(1))),1);
    %     for k = 1:test2
    %         for itrial = 1:size(y,3)
    %             ax(k) = subplot(test2,2,(2*k)-1);
    %             plot(time,y(:,chanfft(k)),'b')
    %             ylabel('Amplitude (V)')
    %             linkaxes(ax,'x')
    %             labels = [labels; num2str(k)];
    %         end
    %         legend(labels);
    %         if k==1; title('EEG signal in the time domain'); end
    %     end
    
    %     xlabel('time (s)')
    % h5 = figure;
    m = length(y(:,chanfft(1)));
    %     n = pow2(nextpow2(m));
    n = m;
    f = (0:n-1)*(fs/n);
    f = f(1:floor(n/2));
    powermatrix = [];
    for k = 1:test2
        for itrial = 1:size(y,3)
            subplot(2,test2,k);
            hold on;
            dfty1 = fft(y(:,chanfft(k),itrial)-mean(y(:,chanfft(k),itrial)),n);
            p = (dfty1.*conj(dfty1))/n;
            p = p(1:floor(n/2));
            plot(f,p);
            powermatrix(:,k,itrial) = p;
        end
        axis tight
        title(['channel ' num2str(chanfft(k))]);
    end
    
    ylabel('FFT (V)')
    %     linkaxes(ax2,'x')
    xlabel('Frequency (Hz)')
    for k = 1:test2
        subplot(2,test2,k+test2)
        plot(f,mean(powermatrix(:,k,:),3))
        %         semilogy(f(2:end),mean(powermatrix(2:end,k,:),3))
        axis tight
    end
end


function chanfft_Callback(hObject, eventdata, handles)
global chanfft
chanfft = str2double(get(hObject,'String')); return

function chanfft_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function onset_sample_Callback(hObject, eventdata, handles)
% hObject    handle to onset_sample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of onset_sample as text
%        str2double(get(hObject,'String')) returns contents of onset_sample as a double


% --- Executes during object creation, after setting all properties.
function onset_sample_CreateFcn(hObject, eventdata, handles)
% hObject    handle to onset_sample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
