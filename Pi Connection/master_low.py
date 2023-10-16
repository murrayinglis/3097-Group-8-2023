import RPi.GPIO as GPIO
import time

# Set the GPIO mode to BCM (Broadcom SOC channel numbering)
GPIO.setmode(GPIO.BCM)

# Define the GPIO pin number you want to use
output_pin = 4 

# Set the pin as an output and set to 0
GPIO.setup(output_pin, GPIO.OUT)

try:
    GPIO.output(output_pin, GPIO.LOW)
    print("Output pin set to LOW")
finally:
    GPIO.cleanup()