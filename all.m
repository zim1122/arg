//polar nrz
clc;
clear;

% Input binary data
data = [ 0 1 0 0 1 1 1 0];

% Bit and sampling specs
bit_duration = 1;      % in seconds
fs = 100;              % sampling frequency (Hz)
t = 0:1/fs:bit_duration - 1/fs;  % time vector for one bit
N = length(data);      % number of bits

% Full signal time vector
time = 0:1/fs:bit_duration*N - 1/fs;

% Signal initialization
polar_nrz = [];

% Generate the Polar NRZ waveform
for i = 1:N
    if data(i) == 0
        polar_nrz = [polar_nrz ones(1, length(t))];    % +1 V for bit 0
    else
        polar_nrz = [polar_nrz -ones(1, length(t))];   % -1 V for bit 1
    end
end

% Plotting
figure;
plot(time, polar_nrz, 'LineWidth', 2);
axis([0 bit_duration*N -1.5 1.5]);
grid on;
xlabel('Time (s)');
ylabel('Amplitude (V)');
title('Polar NRZ Line Coding');
xticks(0:bit_duration:N);
yticks([-1 0 1]);

//polar-rz

clc;
clear;

% Input binary data
data = [1 1 0 1 0 1 0 0];

% Bit and sampling specs
bit_duration = 1;     % duration of one bit in seconds
fs = 1000;             % samples per second
N = length(data);
samples_per_bit = fs * bit_duration;
half_samples = samples_per_bit / 2;

% Time vector for full signal
time = 0:1/fs:(N*bit_duration) - 1/fs;

% Generate the Polar RZ waveform
polar_rz = [];

for i = 1:length(data)
    if data(i) == 1
        % +1 V for first half, 0 V for second half
        bit_wave = [ones(1, half_samples), zeros(1, half_samples)];
    else
        % -1 V for first half, 0 V for second half
        bit_wave = [-ones(1, half_samples), zeros(1, half_samples)];
    end
    polar_rz = [polar_rz bit_wave];  % append the waveform for this bit
end

% Plot the Polar RZ signal
figure;
plot(time, polar_rz, 'LineWidth', 2);
axis([0 N*bit_duration -1.5 1.5]);
grid on;
xlabel('Time (s)');
ylabel('Amplitude (V)');
title('Polar RZ Line Coding');
xticks(0:bit_duration:N);
yticks([-1 0 1]);

//unipolar-nrz
clc;
clear;

% Input binary data
data = [1 0 1 1 0 0 1 0];

% Bit specifications
bit_duration = 1;  % duration of one bit (in seconds)
fs = 30;          % sampling frequency in Hz
t = 0:1/fs:bit_duration - 1/fs;  % time vector for 1 bit
N = length(data);  % number of bits

% Time vector for entire signal
time = 0:1/fs:bit_duration*N - 1/fs;

% Signal generation
unipolar_nrz = [];

for i = 1:N
    if data(i) == 1
        unipolar_nrz = [unipolar_nrz ones(1, length(t))];  % High for '1'
    else
        unipolar_nrz = [unipolar_nrz zeros(1, length(t))]; % Low for '0'
    end
end

% Plotting
figure;
plot(time, unipolar_nrz, 'LineWidth', 2);
axis([0 bit_duration*N 0 1]);
grid on;
xlabel('Time (s)');
ylabel('Amplitude');
title('Unipolar NRZ Line Coding');
xticks(0:bit_duration:N);
yticks([0 1]);

//bipolar-ami
clc;
clear;

% Input binary data
data = [1 0 1 1 0 1 0 0 1];

% Bit and sampling specifications
bit_duration = 1;      % duration of one bit in seconds
fs = 100;              % sampling frequency in Hz
samples_per_bit = fs * bit_duration;

% Time vector for full signal
time = 0:1/fs:(length(data)*bit_duration) - 1/fs;

% Initialize signal
ami = [];
last_polarity = -1;  % Initialize to -1 so first '1' becomes +1

for i = 1:length(data)
    if data(i) == 1
        last_polarity = -last_polarity;  % Alternate polarity
        bit_wave = last_polarity * ones(1, samples_per_bit);
    else
        bit_wave = zeros(1, samples_per_bit);
    end
    ami = [ami bit_wave];
end

% Plotting
figure;
plot(time, ami, 'LineWidth', 2);
axis([0 length(data) * bit_duration -1.5 1.5]);
grid on;
xlabel('Time (s)');
ylabel('Amplitude (V)');
title('Bipolar AMI (Alternate Mark Inversion) Line Coding');
xticks(0:bit_duration:length(data));
yticks([-1 0 1]);

//multilevel-2B1Q
clc;
clear;

% Input binary data (length must be even for 2-bit grouping)
data = [1 0 0 0 1 1 0 1];  % 8 bits = 4 symbols

% Check length
if mod(length(data), 2) ~= 0
    error('Input data length must be even for 2B1Q.');
end

% Bit and symbol specs
fs = 100;               % samples per second
symbol_duration = 1;    % seconds per symbol (2 bits per symbol)
samples_per_symbol = fs * symbol_duration;

% Time vector for full signal
num_symbols = length(data) / 2;
time = 0:1/fs:(num_symbols * symbol_duration) - 1/fs;

% 2B1Q Mapping Table
map = containers.Map({'00', '01', '10', '11'}, [-3, -1, 3, 1]);

% Generate 2B1Q waveform
twoB1Q = [];
for i = 1:2:length(data)
    pair = sprintf('%d%d', data(i), data(i+1));
    level = map(pair);
    twoB1Q = [twoB1Q level * ones(1, samples_per_symbol)];
end

% Plotting
figure;
plot(time, twoB1Q, 'LineWidth', 2);
axis([0 num_symbols * symbol_duration -3.5 3.5]);
grid on;
xlabel('Time (s)');
ylabel('Amplitude (V)');
title('2B1Q (2 Binary 1 Quaternary) Line Coding');
xticks(0:symbol_duration:num_symbols);
yticks([-3 -1 0 1 3]);

//bi-polarphase-manchestar
clc;
clear;

% Input binary data
data = [1 0 1 1 0 0 1 0];

% Bit and sampling parameters
bit_duration = 1;     % seconds
fs = 500;             % samples per second
N = length(data);
samples_per_bit = fs * bit_duration;
half_samples = samples_per_bit / 2;

% Time vector for full signal
time = 0:1/fs:(N*bit_duration) - 1/fs;

% Initialize Manchester waveform
manchester = [];

for i = 1:N
    if data(i) == 0
        % Bit 0: High to Low
        bit_wave = [ones(1, half_samples), -ones(1, half_samples)];
    else
        % Bit 1: Low to High
        bit_wave = [-ones(1, half_samples), ones(1, half_samples)];
    end
    manchester = [manchester bit_wave];
end

% Plot Manchester waveform
figure;
plot(time, manchester, 'LineWidth', 2);
axis([0 N*bit_duration -1.5 1.5]);
grid on;
xlabel('Time (s)');
ylabel('Amplitude (V)');
title('Polar Biphase (Manchester) Line Coding');
xticks(0:bit_duration:N);
yticks([-1 0 1]);

//frequency modulation
% Parameters
Fs = 10000;             % Sampling frequency (Hz)
t = 0:1/Fs:0.01;        % Time vector (10 ms)
fc = 1000;              % Carrier frequency (Hz)
fm = 100;               % Message frequency (Hz)
Am = 1;                 % Message amplitude
Ac = 1;                 % Carrier amplitude
kf = 2 * pi * 75;       % Frequency sensitivity (rad/s per unit amplitude)

% Message signal
m = Am * cos(2 * pi * fm * t);

% Integrate the message signal
int_m = cumsum(m) / Fs;

% FM signal
s_fm = Ac * cos(2 * pi * fc * t + kf * int_m);

% Plotting
figure;

subplot(3,1,1);
plot(t, m);
title('Message Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, cos(2*pi*fc*t));
title('Carrier Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,3);
plot(t, s_fm);
title('FM Signal');
xlabel('Time (s)');
ylabel('Amplitude');

//pcm

clc;
clear;

% Parameters
f = 5;                  % Frequency of analog signal (Hz)
fs = 100;               % Sampling frequency (samples per second)
t = 0:1/fs:1;           % Time vector for 1 second
x = sin(2*pi*f*t);      % Original analog signal (sine wave)

% Quantization
n_bits = 2;                      % Number of bits per sample (e.g., 3 bits ? 8 levels)
L = 2^n_bits;                    % Number of quantization levels
x_min = min(x); x_max = max(x);
q_step = (x_max - x_min) / (L - 1);   % Quantization step size

% Uniform quantizer
xq_index = round((x - x_min) / q_step);    % Get quantization index
xq = xq_index * q_step + x_min;            % Quantized signal

% Binary Encoding
bin_pcm = dec2bin(xq_index, n_bits);       % Binary PCM values (as string matrix)

% Plot original and quantized signal
figure;
plot(t, x, 'b', 'LineWidth', 1.5);
hold on;
stairs(t, xq, 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('PCM Encoding of a Sine Wave');
legend('Original Signal', 'Quantized Signal');
grid on;

//delta modulation

clc;
clear;

% Parameters
fs = 200;                    % Sampling frequency
t = 0:1/fs:1;                % Time vector
x = sin(2*pi*5*t);           % Input signal (sine wave)
delta = 0.2;                 % Step size

% Initialization
x_dm = zeros(size(x));       % Delta modulated signal (reconstructed)
bitstream = zeros(size(x));  % Output bitstream (0 or 1)

for i = 2:length(x)
    if x(i) > x_dm(i-1)
        bitstream(i) = 1;
        x_dm(i) = x_dm(i-1) + delta;
    else
        bitstream(i) = 0;
        x_dm(i) = x_dm(i-1) - delta;
    end
end

% Plot input and reconstructed signal
figure;
plot(t, x, 'b', 'LineWidth', 1.5); hold on;
stairs(t, x_dm, 'r', 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Delta Modulation of a Sine Wave');
legend('Original Signal', 'Delta Modulated Reconstruction');
grid on;

//Amplitude Modulation

% Parameters
Fs = 10000;            % Sampling frequency (Hz)
t = 0:1/Fs:0.01;       % Time vector (10 ms)
fc = 1000;             % Carrier frequency (Hz)
fm = 100;              % Message frequency (Hz)
Am = 1;                % Message amplitude
Ac = 1;                % Carrier amplitude
mu = 0.5;              % Modulation index (0 < mu < 1 for under modulation)

% Message signal
m = Am * cos(2 * pi * fm * t);

% Carrier signal
c = Ac * cos(2 * pi * fc * t);

% AM signal
s = (1 + mu * cos(2 * pi * fm * t)) .* c;

% Plotting
figure;

subplot(3,1,1);
plot(t, m);
title('Message Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,2);
plot(t, c);
title('Carrier Signal');
xlabel('Time (s)');
ylabel('Amplitude');

subplot(3,1,3);
plot(t, s);
title('AM Modulated Signal');
xlabel('Time (s)');
ylabel('Amplitude');

//sqare wave
% this program generate a square wav based on sine signals and sign()
% function returns: +1 if the input > 0, 0 if the input = 0, and -1 if the input < 0 
frequency = 1; % Hz
amplitude = 2;
duration = 10; % seconds
samplingRate = 100; % Samples per second

% Create the time vector
t = 0:1/samplingRate:duration-1/samplingRate;


% Create the signal
x = amplitude * sign(sin(2 * pi * frequency * t));
% Plot the signal
plot(t, x,'LineWidth', 1.5);

xlabel('Time (s)');
ylabel('Amplitude');
title(' Sine square Signal');

//triangular_wave
frequency = 1;       % Hz
amplitude = 2;
duration = 10;        % seconds
samplingRate = 100; % Samples/second

t = 0:1/samplingRate:duration;

% Triangle wave from absolute value of a sawtooth-like function
x = 4* amplitude * abs(t * frequency - floor(t * frequency + 0.5)) - amplitude;


% Plot
plot(t, x, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Manual Triangular Wave');

//pulse wave

f = 5;                  % Frequency (Hz)
duty = 90;              % Duty cycle in percent
duration = 1;           % seconds
fs = 1000;              % Sampling rate
t = 0:1/fs:duration;

% Generate a pulse wave (10% duty cycle)
x = square(2 * pi * f * t, duty);

% Make the wave range from 0 to 1 instead of -1 to 1
x = (x + 1) / 2;

% Plot
plot(t, x, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Pulse Wave (10% Duty Cycle)');

//satooth wave

frequency = 1;       % Hz
amplitude = 2;
duration = 4;        % seconds
samplingRate = 100; % Samples per second

% Time vector
t = 0:1/samplingRate:duration-1/samplingRate;

% Generate sawtooth manually (range: -A to +A)
x = 2 * amplitude * (t * frequency - floor(t * frequency + 0.5));

% Plot
plot(t, x, 'LineWidth', 1.5);
xlabel('Time (s)');
ylabel('Amplitude');
title('Manually Generated Sawtooth Signal');