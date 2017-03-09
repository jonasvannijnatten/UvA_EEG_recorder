
noise = 0;

Fs = 256;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
x1 = sin(2*pi*t);
x2 = sin(2*pi*5*t);
x3 = sin(2*pi*20*t);
x = x1 + x2 + x3;
% x = 0.5*sin(2*pi*2*t) + sin(2*pi*8*t) + sin(2*pi*15*t); 
if noise == 1
    y = x + randn(size(t));     % Sinusoids plus noise
elseif noise == 0    
    y = x ; %+ randn(size(t));     % Sinusoids plus noise
end
figure; 
subplot(4,1,1); plot(x1); xlabel('time (milliseconds)'); ylabel('signal amplitude'); title('function 1')
subplot(4,1,2); plot(x2); xlabel('time (milliseconds)'); ylabel('signal amplitude'); title('function 2')
subplot(4,1,3); plot(x3); xlabel('time (milliseconds)'); ylabel('signal amplitude'); title('function 3')
subplot(4,1,4); plot(x);  xlabel('time (milliseconds)'); ylabel('signal amplitude'); title('sum of functions')

% plot(Fs*t,y)
% title('Signal Corrupted with Zero-Mean Random Noise')
xlabel('time (milliseconds)'); ylabel('signal amplitude');

NFFT = 2^nextpow2(L); % Next power of 2 from length of y
Y = fft(y,NFFT)/L;
f = Fs/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure; plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of y(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')



%%

noise = 1;

Fs = 256;                    % Sampling frequency
T = 1/Fs;                     % Sample time
L = 1000;                     % Length of signal
t = (0:L-1)*T;                % Time vector
% Sum of a 50 Hz sinusoid and a 120 Hz sinusoid
x = 0.5*sin(2*pi*10*t) + sin(2*pi*50*t); 
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

