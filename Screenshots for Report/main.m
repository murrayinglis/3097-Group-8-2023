function main

system(['C:\Users\user\Desktop\UCT 2023\EEE3097S DESIGN\3097-Group-8-2023\Pi Connection\master_low.bat']);

input("Press enter to start recording");

system(['C:\Users\user\Desktop\UCT 2023\EEE3097S DESIGN\3097-Group-8-2023\Pi Connection\pi_rec.bat']);

pause(40)

disp("Finished recording, transferring files...")
%% 

system(['C:\Users\user\Desktop\UCT 2023\EEE3097S DESIGN\3097-Group-8-2023\Pi Connection\scp_files.bat']);
%% 

[file1,Fs] = audioread("pi1.wav");
[file2,Fs] = audioread("pi2.wav");

sig1 = file2(:,1);  %Left
sig2 = file2(:,2);  %Right
sig3 = file1(:,1);  %Left
sig4 = file1(:,2);  %Right

%% 
t = linspace(0,length(sig1)/Fs,length(sig1));
figure;
subplot(2,2,1);
plot(t, sig1);
title('Signal 1');

subplot(2,2,2);
plot(t, sig2);
title('Signal 2');

subplot(2,2,3);
plot(t, sig3);
title('Signal 3');

subplot(2,2,4);
plot(t, sig4);
title('Signal 4');


%% 

% Filtering
% Define filter parameters
low_cutoff_frequency = 300;  % Adjust the lower cutoff frequency as needed
high_cutoff_frequency = 3000; % Adjust the upper cutoff frequency as needed
filter_order = 4;            % Adjust the filter order as needed

% Design a bandpass Butterworth filter
[b, a] = butter(filter_order, [low_cutoff_frequency, high_cutoff_frequency] / (Fs / 2), 'bandpass');

% Apply the filter to each signal
sig1 = filtfilt(b, a, sig1);
sig2 = filtfilt(b, a, sig2);
sig3 = filtfilt(b, a, sig3);
sig4 = filtfilt(b, a, sig4);

% Cut off start trail
sig1(1:0.03*Fs)=0;
sig2(1:0.03*Fs)=0;
sig3(1:0.03*Fs)=0;
sig4(1:0.03*Fs)=0;

t = linspace(0,length(sig1)/Fs,length(sig1));
figure;
subplot(2,2,1);
plot(t, sig1);
title('Signal 1');

subplot(2,2,2);
plot(t, sig2);
title('Signal 2');

subplot(2,2,3);
plot(t, sig3);
title('Signal 3');

subplot(2,2,4);
plot(t, sig4);
title('Signal 4');

%% 

localize(sig1,sig2,sig3,sig4,Fs)
