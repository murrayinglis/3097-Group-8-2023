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
    "/home/design/pi2.wav",
    "-d",
    "15"
]

# Set the GPIO mode to BCM (Broadcom SOC channel numbering)
GPIO.setmode(GPIO.BCM)

# Define the GPIO pin number you want to use
input_pin = 4   

# Set the pin as an input
GPIO.setup(input_pin, GPIO.IN)

try:
    input_state = GPIO.input(input_pin)
    while input_state == 0:
        input_state = GPIO.input(input_pin)

    print(f"Input pin state: {input_state}")

    try:
        # Run the command
        subprocess.run(command, check=True)
        print("Command executed successfully")
    except subprocess.CalledProcessError as e:
        print(f"Error running the command: {e}")    

finally:
    # Cleanup and reset GPIO settings
    GPIO.cleanup()
