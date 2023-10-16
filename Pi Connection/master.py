import RPi.GPIO as GPIO
import time
import subprocess

# Define the command as a list of arguments
command = [
    "arecord",
    "-D",
    "plughw:0",
    "-c",
    "2",
    "-r",
    "64000",
    "-f",
    "S32_LE",
    "-t",
    "wav",
    "-V",
    "stereo",
    "-v",
    "/home/design/pi1.wav",
    "-d",
    "15"
]

# Set the GPIO mode to BCM (Broadcom SOC channel numbering)
GPIO.setmode(GPIO.BCM)

# Define the GPIO pin number you want to use
output_pin = 4 

# Set the pin as an output and set to 0
GPIO.setup(output_pin, GPIO.OUT)
GPIO.output(output_pin, GPIO.LOW)
print("Output pin set to LOW")

end_string = ""

while end_string!="a":
    end_string = input("Enter 'a' to record.\n")

try:
    GPIO.output(output_pin, GPIO.HIGH)
    print("Output pin set to HIGH")
finally:
    GPIO.cleanup()
    
try:
    # Run the command
    subprocess.run(command, check=True)
    print("Command executed successfully")
except subprocess.CalledProcessError as e:
    print(f"Error running the command: {e}")




    