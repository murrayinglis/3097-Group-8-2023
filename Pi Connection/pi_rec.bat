@echo off
setlocal

:: Define variables
set remote_host1=192.168.101.144
set remote_user1=design
set remote_password1=design
set remote_path1=/home/design/pi1.wav
set local_path1=pi1.wav

set remote_host2=192.168.101.102
set remote_user2=design
set remote_password2=uct1
set remote_path2=/home/design/pi2.wav
set local_path2=pi2.wav

REM Path to plink.exe (change this to the actual path on your system)
set plink_path=C:\Program Files\PuTTY\plink.exe

REM Execute the SSH command

start "" "%plink_path%" -ssh %remote_user1%@%remote_host1% -pw %remote_password1% "arecord -D plughw:0 -c 2 -r 64000 -f S32_LE -t wav -V stereo -v /home/design/pi1.wav -d 35"
start "" "%plink_path%" -ssh %remote_user2%@%remote_host2% -pw %remote_password2% "arecord -D plughw:0 -c 2 -r 64000 -f S32_LE -t wav -V stereo -v /home/design/pi2.wav -d 35"

:: Check the exit code to see if the transfer was successful
if %errorlevel% equ 0 (
    echo Command executed successfully
) else (
    echo Error
)

endlocal
