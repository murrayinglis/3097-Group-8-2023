function main

system(['C:\Users\user\Desktop\UCT 2023\EEE3097S DESIGN\3097-Group-8-2023\Pi Connection\master_low.bat']);

pool = parpool('local', 2); % Create a parallel pool
%% 
q = parallel.pool.DataQueue();
afterEach(q, @disp);

job1 = parfeval(@slave_start,0,q);
job2 = parfeval(@master_start,0,q);



delete(pool);

disp("Finished recording, transferring files...")
%% 

system(['C:\Users\user\Desktop\UCT 2023\EEE3097S DESIGN\3097-Group-8-2023\Pi Connection\scp_files.bat']);

[file1,Fs] = audioread("pi1.wav");
[file2,Fs] = audioread("pi2.wav");

sig1 = file2(:,1);  %Left
sig2 = file2(:,2);  %Right
sig3 = file1(:,1);  %Left
sig4 = file1(:,2);  %Right

localize(sig1,sig2,sig3,sig4,Fs)

end


function slave_start()
    system(['C:\Users\user\Desktop\UCT 2023\EEE3097S DESIGN\3097-Group-8-2023\Pi Connection\slave_start.bat']);
end

function master_start(q)
    message = 'Recording starting...';
    send(q, message);  % Send the message to the DataQueue
    pause(2);
    system(['C:\Users\user\Desktop\UCT 2023\EEE3097S DESIGN\3097-Group-8-2023\Pi Connection\master_start.bat']);
end