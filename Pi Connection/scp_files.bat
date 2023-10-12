@echo off
setlocal

:: Define variables
set remote_host1=raspberrypi
set remote_user1=design
set remote_password1=design
set remote_path1=/home/design/pi1.wav
set local_path1="C:\Users\user\Desktop\UCT 2023\EEE3097S DESIGN\3097-Group-8-2023\Gui\pi1.wav"

set remote_host2=design
set remote_user2=design
set remote_password2=uct1
set remote_path2=/home/design/pi2.wav
set local_path2="C:\Users\user\Desktop\UCT 2023\EEE3097S DESIGN\3097-Group-8-2023\Gui\pi2.wav"

:: Execute SCP command using pscp
pscp -pw %remote_password1% %remote_user1%@%remote_host1%:%remote_path1% %local_path1%

:: Check the exit code to see if the transfer was successful
if %errorlevel% equ 0 (
    echo File %remote_path1% has been copied to %local_path1% successfully.
) else (
    echo Error: SCP transfer failed.
)

:: Execute SCP command using pscp       
pscp -pw %remote_password2% %remote_user2%@%remote_host2%:%remote_path2% %local_path2%

:: Check the exit code to see if the transfer was successful
if %errorlevel% equ 0 (
    echo File %remote_path2% has been copied to %local_path2% successfully.
) else (
    echo Error: SCP transfer failed.
)

endlocal
