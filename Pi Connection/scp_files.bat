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
