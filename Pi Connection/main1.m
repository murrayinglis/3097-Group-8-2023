function main1

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

localize(sig1,sig2,sig3,sig4,Fs)
