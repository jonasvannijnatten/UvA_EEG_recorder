Fs = 256;                    % Sampling frequency
% T = 1/Fs;                     % Sample time
% L = 1000;                     % Length of signal
t = linspace(0,4,10*256);                % Time vector
% % Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
x = 0.7*sin(50*(2*pi*t)) + sin(120*(2*pi*t)); 
y = x + 2*randn(size(t));  % Sinusoids plus noise
y = y';

% global data; 
% y = data(:,3);
% t = [1:length(data)];

figure
% plot(Fs*t(1:50),y(1:50))
t = 1:length(y);
[a b c] = size(y);
plot(t/Fs,y)
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('time (milliseconds)')
NFFT = 2^nextpow2(a); % Next power of 2 from length of y
Y = fft(y,NFFT)/a;
f = Fs/2*linspace(0,1,NFFT/2+1);


% Plot single-sided amplitude spectrum.
figure
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

figure
f = Fs/2*linspace(0,1,NFFT);
plot(f,abs(Y(1:NFFT))) 
title('Full, unshifted Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')



whos
% scaling and filtering 50 Hz

% 1/2*length(Y) : 1/2*Fs;
% (f*1/2*length(Y))/1/2*Fs : f;
% fr*length(Y)/Fs



% Y(2*Fs) : 128
% 512 :128
% 50*(2*Fs)/(Fs/2) : 50
% fijftig = 
%  test = round(50*(2*Fs)/(Fs/2))
% Y(test+1)=0;
% % en
% Y(4*Fs-test+1)=0;



% bandpass filter
% lb hb (low band hygh band

lb = 46.5/2; hb = 49.5/2;
% Ylb_1 = lb*(2*Fs)/(Fs/2)+1
%               fr*length(Y)/Fs
Ylb_1 = round(2*lb*length(Y)/Fs)+1
% and
% Ylb_2 = 4*Fs-(lb*(2*Fs)/Fs/2+1)
Ylb_2 = length(Y)-round(2*lb*length(Y)/Fs)+1


% Yhb_1 = hb*(2*Fs)/(Fs/2)+1
Yhb_1 = round(2*hb*length(Y)/Fs)+1
% and
% Yhb_2 = 4*Fs-hb*(2*Fs)/Fs/2+1
Yhb_2 = length(Y)-round(2*hb*length(Y)/Fs)+1


% % band pass filter
% % Filter below lb
% Y(1:Ylb_1)=0;
% Y(Ylb_2:length(Y))=0;
% 
% % Filter above hb
% Y(Yhb_1:length(Y)/2)=0;
% Y(length(Y)/2:Yhb_2)=0;

% Stopband
Y(Ylb_1:Yhb_1)=0;
Y(Yhb_2:Ylb_2)=0;



figure
plot(f,abs(Y(1:NFFT))) 
title('Filtered Full, unshifted Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')


% now perform the Ifft
figure
fY = ifft(Y);
t = 1:length(fY);
whos
plot(t./Fs,fY,'r'); 
% plot(t./Fs,y,'b'); hold off
title('Filtered ifft y(t)')

figure
subplot(2,1,1)
fY = fY(1:length(y));
t = 1:length(fY);
plot(t./Fs,fY,'r');
subplot(2,1,2)
plot(t./Fs,y,'b')
title('Filtered ifft y(t)')
whos

%make an fft again as a controle
[a b c] = size(fY)
NFFT = 2^nextpow2(a); % Next power of 2 from length of y
Y = fft(fY,NFFT)/a;
f = Fs/2*linspace(0,1,NFFT/2+1);


% Plot single-sided amplitude spectrum.
figure
plot(f,2*abs(Y(1:NFFT/2+1)),'r') 
title('Filtered Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

