import serial
import time


try:
    from Adafruit_MotorHAT import Adafruit_MotorHAT
except:
    pass

class InvalidValueException(Exception):
    def __init__(self, message="Invalid Value"):
        self.message = message
    
    def __str__(self, *args, **kwargs):
        return self.message
    

class Motor(object):
    '''
    The base class of all the types of motors.
    '''
    FORWARD = 1
    BACKWARD = 2
    
    SINGLE = 1  # Step size is 1
    DOUBLE = 2  # Step size is 1, double strength
    INTERLEAVE = 3  # Step size is 1/2
    MICROSTEP = 4  # Step size is 1/8
    
    def __init__(self, initstep, stepsPerRevolution):
        self.reset(initstep)
        self.stepsPerRevolution = stepsPerRevolution

    def reset(self, initstep):
        '''
        Reset the current motor to the given position
        @param initstep: The current step
        '''
        self.currentstep = initstep

    def setCurrentstep(self, step):
        '''
        Set the current position of the stepper.
        @param step: The current step postion (Not null)
        '''
        self.currentstep = step

    def getCurrentstep(self):
        '''
        @return: The current step position
        '''
        return self.currentstep

    def setStepsPerRevolution(self, stepsPerRevolution):
        '''
        Set the number of steps per revolution.
        @param stepsPerRevolution: The number of steps (Not null)
        '''
        self.stepsPerRevolution = stepsPerRevolution
    
    def getStepsPerRevolution(self):
        '''
        @return: The number of steps per revolution
        '''
        return self.stepsPerRevolution
            
    def oneStep(self, direction, style):
        '''
        Turn the motor one step in the given direction and style
        @param direction: The direction to turn Motor.FORWARD=1, Motor.BACKWARD=2
        @param stepstyle: The stepping style SINGLE, DOUBLE, etc.
        @return: The current step 
        '''
        raise NotImplementedError("Should have implemented this")

    def step(self, steps, direction, stepstyle, time_ms, updateSteps=20):
        '''
        Move the motor multiple steps in the given style.
        @param steps: The number of steps to turn
        @param direction: The direction to turn Motor.FORWARD=1, Motor.BACKWARD=2
        @param stepstyle: The stepping style SINGLE, DOUBLE, etc.
        @param time_ms: The amount of time to perform the steps in milliseconds
        @param updateSteps: The amount of steps to update the current step. Default = 20
        @return: The current step
        '''
        raise NotImplementedError("Should have implemented this")
    
    def turnOffMotor(self):
        raise NotImplementedError("Should have implemented this")


class MotorEmulator(Motor):
    '''
    A motor emulator to be used if there is no RaspberryPi or Arduino board.
    '''
    
    def __init__(self, stepsPerRev=200):
        super(MotorEmulator, self).__init__(0, stepsPerRev)

    def oneStep(self, direction, stepstyle):
        
        stepAmnt = 1  # SINGLE or DOUBLE
        if Motor.INTERLEAVE == stepstyle:
            stepAmnt = 1 / 2.0
        elif Motor.MICROSTEP == stepstyle:
            stepAmnt = 1 / 8.0
        
        if Motor.FORWARD == direction:
            self.setCurrentstep(self.getCurrentstep() + stepAmnt)
        elif Motor.BACKWARD == direction:
            self.setCurrentstep(self.getCurrentstep() - stepAmnt)
        
        return self.getCurrentstep()

    def step(self, steps, direction, stepstyle, time_ms, updateSteps=20):
        
        if Motor.INTERLEAVE == stepstyle:
            steps *= 2
        elif Motor.MICROSTEP == stepstyle:
            steps *= 8
        
        sleepAmnt = time_ms / 1000.0 / steps
        
        for _ in range(steps):
            self.oneStep(direction, stepstyle)
            time.sleep(sleepAmnt)
        
        return self.getCurrentstep()
            
    def turnOffMotor(self):
        pass


class ArduinoMotor(Motor):
    '''
    Encapsulates communication to an arduino board via USB serial connection.
    '''
    
    stepTypes = { 1: 'single', 2: 'double', 3: 'interleave', 4: 'microstep'}
    
    def __init__(self, stepsPerRev=200, port='/dev/ttyACM0', baud=9600):
        self.stepsPerRevolution = stepsPerRev
        self.port = port
        self.baud = baud
        self.ard = serial.Serial(self.port, self.baud)  # ,timeout=5)
        time.sleep(2)  # need to wait for setup
        
    
    def __writeln(self, line):
        self.ard.write(line)
        self.ard.write('\n')
    
    def __executeSteps(self, numSteps, stepType, direction, time_ms, updateSteps='20'):
        
        self.__writeln(self.stepTypes[stepType])  # step type
        self.__writeln(str(time_ms))  # time
        self.__writeln(str(numSteps))  # steps
        self.__writeln(updateSteps)  # update steps
        self.__writeln(str(direction))  # Motor.FORWARD or Motor.BACKWARD
            
        init = None
        
        dirSign = 1
        if Motor.BACKWARD == direction :
            dirSign = -1
        
        for line in self.ard :
            val = line.rstrip()
            if init == None:
                init = val            
            elif val != 'done':  # Update position
                self.setCurrentstep(self.setCurrentstep(self.getCurrentstep() + int(val) * dirSign))
                print self.getCurrentstep() 
            
            print val
            if val == 'done':
                print self.ard.readline()  # Last line 
                break  # We're done!
        

        return self.getCurrentstep()
                   
    def oneStep(self, direction, style):
        return self.__executeSteps(1, style, direction, 1, 1)

    def step(self, steps, direction, style, time, updateSteps):
        self.__executeSteps(steps, style, direction, time, updateSteps)
    
    def turnOffMotor(self):
        pass
    
class RaspberryPiMotor(Motor):
    '''
    Encapsulates communication to an underlying Adafruit motor HAT.
    '''
    
    def __init__(self, stepsPerRev=200):
        initStep = 0
        motorNum = 1
        super(RaspberryPiMotor, self).__init__(initStep, stepsPerRev)
        self.motor = Adafruit_MotorHAT().getStepper(stepsPerRev, motorNum)
        
    def __executeSteps(self, numSteps, stepType, direction, time_ms, updateSteps='20'):
        sign = 1
        if Motor.BACKWARD == direction:
            sign = -1
        
        self.motor.setSpeed(float(numSteps) / self.getStepsPerRevolution() / time_ms * 1000.0 * 60)
        
        revs = numSteps / self.getStepsPerRevolution()  
        for _ in range(revs):
            self.motor.step(self.getStepsPerRevolution(), direction, stepType)
            self.setCurrentstep(self.getCurrentstep() + self.getStepsPerRevolution() * sign)
        
        remainingSteps = numSteps - (revs * self.getStepsPerRevolution())

        print "Starting remaining amount... %d " % remainingSteps

        self.motor.step(remainingSteps, direction, stepType)
        self.setCurrentstep(self.getCurrentstep() + remainingSteps * sign)

        print "Self.position = %f" % self.position

        return self.getPosition()
            
    def oneStep(self, direction, style):
        return self.motor.oneStep(direction, style)

    def step(self, steps, direction, style, time_ms, updateSteps):
        self.motor.step(steps, direction, style)
    
    def turnOffMotor(self):
        self.motor.run(Adafruit_MotorHAT.RELEASE)
        


# arduino = ArduinoMotor()
# arduino.movePosition(1, 5000)
# print "Position %s mm" % arduino.getPosition() 
