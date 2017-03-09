close all
clc
noise_on = 1;

Fs = 256;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 1Hz, 5Hz and 20Hz sinusoid
x1 = sin(2*pi*t);
x2 = sin(2*pi*5*t);
x3 = sin(2*pi*20*t);
x = x1 + x2 + x3;
noise = randn(size(t));
% x = 0.5*sin(2*pi*2*t) + sin(2*pi*8*t) + sin(2*pi*15*t); 
if noise_on == 1
    y = x + noise;     % Sinusoids plus noise
    figure;
    subplot(5,1,1); plot(x1); xlabel(''); ylabel('amplitude'); title('');   legend('1 Hz', 'NorthEastInside');
    subplot(5,1,2); plot(x2); xlabel(''); ylabel('amplitude'); title('+');  legend('5 Hz', 'NorthEastInside');
    subplot(5,1,3); plot(x3); xlabel(''); ylabel('amplitude'); title('+');  legend('20 Hz', 'NorthEastInside');
    subplot(5,1,4); plot(noise);          ylabel('amplitude'); title('+');  legend('noise', 'NorthEastInside');
    subplot(5,1,5); plot(y);  xlabel('time (milliseconds)'); ylabel('amplitude'); title('=');   legend('convoluted', 'NorthEastInside');
elseif noise_on == 0
    y = x ; %+ randn(size(t));     % Sinusoids plus noise
    figure;
    subplot(4,1,1); plot(x1); xlabel(''); ylabel('amplitude'); title('');   legend('1 Hz', 'NorthEastInside');
    subplot(4,1,2); plot(x2); xlabel(''); ylabel('amplitude'); title('+');   legend('5 Hz', 'NorthEastInside');
    subplot(4,1,3); plot(x3); xlabel(''); ylabel('amplitude'); title('+');   legend('20 Hz', 'NorthEastInside');
    subplot(4,1,4); plot(y);  xlabel('time (milliseconds)'); ylabel('amplitude'); title('=');   legend('convoluted', 'NorthEastInside');
end

figure; plot(y); xlabel('time (milliseconds)'); ylabel('amplitude'); title('=');
% plot(Fs*t,y)
% title('Signal Corrupted with Zero-Mean Random Noise')
% xlabel('time (milliseconds)'); ylabel('signal amplitude');

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure; plot(f,2*abs(Y(1:NFFT/2+1))) 
xlim([0 50]);
title('Powerspectrum')
xlabel('Frequency (Hz)')
ylabel('power')



%%
close all
noise = 1;

Fs = 256;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
x = 0.5*sin(2*pi*10*t) + sin(2*pi*50*t); 

x1 = zeros(size(x));
for i = 1:.1:20
    x1 = x1 + (1/i)*sin(2*pi*i*t);
end

x2 = [];clc
for i = 9:.1:11
    % make nice alpha band
end

x=x1+x2;

if noise == 1
    y = x + randn(size(t));     % Sinusoids plus noise
elseif noise == 0    
    y = x ; %+ randn(size(t));     % Sinusoids plus noise
end
figure; plot(Fs*t,y)
title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('time (milliseconds)')

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure; plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')

