from firebase import firebase
import RPi.GPIO as GPIO

GPIO.setmode(GPIO.BCM)

# Setup Pins for Motors
motorFL = 2
motorFR = 3
motorBL = 4
motorBR = 17

GPIO.setup(motorFL, GPIO.OUT)
GPIO.setup(motorFR, GPIO.OUT)
GPIO.setup(motorBL, GPIO.OUT)
GPIO.setup(motorBR, GPIO.OUT)

# Setup Pins for Servos
servoL = 0
servoR = 0

GPIO.setup(27, GPIO.OUT)
GPIO.output(2, GPIO.HIGH)

firebase = firebase.FirebaseApplication("https://hacksbu1.firebaseio.com/", None)
firebase.put('movement', '1', 'Stop')

def moveStraight():
    GPIO.output(27, 1)
    GPIO.output(2, GPIO.HIGH)
    GPIO.output(motorFR, GPIO.HIGH)
    GPIO.output(motorBL, GPIO.HIGH)
    GPIO.output(motorBR, GPIO.HIGH)
def rotateLeft():
    pass
def rotateRight():
    pass
def stop():
    GPIO.output(motorFL, 0)
    GPIO.output(motorFR, 0)
    GPIO.output(motorBL, 0)
    GPIO.output(motorBR, 0)

while True:
    action = firebase.get("movement", "1")
    print(action)
    if action == "Straight":
        moveStraight()
    elif action == "Left":
        rotateLeft()
    elif action == "Right":
        rotateRight()
    elif action == "Stop":
        stop()
        
print("clean up")
GPIO.cleanup() # cleanup all GPIO 
