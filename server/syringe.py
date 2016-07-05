'''
Created on Jun 28, 2016

@author: Mark Royer
'''
import thread
import time
from motors import MotorEmulator, Motor


class SyringePump(object):
    '''
    Represents the pluger mechanism with syringe size and screw pitch.
    '''


    def __init__(self, pitch_mm, syringeDiameter_mm, motor=MotorEmulator()):
        '''
        Create a new syringe with specified pitch, syringe diameter, and motor.
        '''
        self.pitch_mm = pitch_mm
        self.syringeDiameter_mm = syringeDiameter_mm
        self.motor = motor

    
    def getPosition(self):
        '''
        @return: The position of the plunger in millimeters
        '''
        return self.motor.getCurrentstep() * self.pitch_mm / self.motor.getStepsPerRevolution()

    
    def movePosition(self, amnt_mm, time_ms):
        '''
        Moves the plunger of the syringe pump amnt_mm millimeters.
        @param amnt_mm: The number of millimeters to move the pump. (Not null)
        @param time_ms: The amount of time to move in milliseconds (Not null) 
        '''        
        numSteps = int(abs(amnt_mm * self.motor.getStepsPerRevolution() / self.pitch_mm))
        
        print "amnt = %f, stepsPer = %f, pitch = %f" % (amnt_mm, self.motor.getStepsPerRevolution(), self.pitch_mm)
        direction = Motor.FORWARD if amnt_mm >= 0 else Motor.BACKWARD
        
        self.motor.step(numSteps, direction, Motor.SINGLE, time_ms)
        
    
    
    def movePositionAsync(self, amnt_mm, time_ms):
        '''
        Modify the current position of the syringe plunger by the given amount 
        over the given amount of time without waiting for the motor to finish.  
        In other words, this function returns immediately.  Use getPosition to 
        determine the motor position.
        @param amnt_mm: in milliliters
        @param time_ms: in milliseconds
        '''
        thread.start_new_thread(self.movePosition, (amnt_mm, time_ms))


    def moveSteps(self, steps, time_ms):
        '''
        Moves the plunger of the syringe pump by # steps given.
        @param steps: The number of steps to turn the motor. (Not null)
        @param time_ms: The amount of time to move in milliseconds (Not null) 
        '''
        direction = Motor.FORWARD if steps >= 0 else Motor.BACKWARD
        
        print "Starting step position %f " % self.motor.getCurrentstep()
        
        self.motor.step(abs(steps), direction, Motor.SINGLE, time_ms)
        
        print "Ending step position %f " % self.motor.getCurrentstep()
        

    def moveStepsAsync(self, steps, time_ms):
        '''
        Moves the plunger of the syringe pump by # steps given and do not wait 
        for the motor to finish.
        @param steps: The number of steps to turn the motor. (Not null)
        @param time_ms: The amount of time to move in milliseconds (Not null) 
        '''
        thread.start_new_thread(self.moveSteps, (steps, time_ms))

    
    def reset(self, pos_mm=0):
        '''
        Resets the plunger position to pos_mm.
        @param pos_mm: Default value is 0
        '''
        self.motor.setCurrentstep(pos_mm / self.pitch_mm * self.motor.getStepsPerRevolution())
    
        