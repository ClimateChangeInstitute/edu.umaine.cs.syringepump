'''
Created on May 24, 2016

@author: Mark Royer
'''
import unittest

from motors import MotorEmulator, Motor


class Test(unittest.TestCase):


    def setUp(self):
        self.motor_emulator = MotorEmulator()


    def tearDown(self):
        pass      
 
    def testReset(self):
         
        self.motor_emulator.reset(0)
        pos = self.motor_emulator.getCurrentstep()
        self.assertAlmostEqual(0, pos, 7, "Position not equal. 0 != %f " % pos)
 
        self.motor_emulator.reset(5)
        pos = self.motor_emulator.getCurrentstep()
        self.assertAlmostEqual(5, pos, 7, "Position not equal. 0 != %f " % pos)
         
         
    def testOneStep(self):
         
        me = self.motor_emulator
        currentstep = me.getCurrentstep()
        self.assertEqual(0, currentstep, "Steps not equal. 0 != %d " % currentstep)
         
        currentstep = me.oneStep(Motor.FORWARD, Motor.SINGLE)
        self.assertEqual(1, currentstep, "Steps not equal. 1 != %d " % currentstep)
         
        currentstep = me.oneStep(Motor.FORWARD, Motor.DOUBLE)
        self.assertEqual(2, currentstep, "Steps not equal. 2 != %d " % currentstep)
         
        currentstep = me.oneStep(Motor.FORWARD, Motor.INTERLEAVE)
        self.assertEqual(2.5, currentstep, "Steps not equal. 2.5 != %d " % currentstep)
         
        currentstep = me.oneStep(Motor.FORWARD, Motor.INTERLEAVE)
        self.assertEqual(3.0, currentstep, "Steps not equal. 3.0 != %d " % currentstep)
         
        currentstep = me.oneStep(Motor.FORWARD, Motor.MICROSTEP)
        self.assertEqual(3.125, currentstep, "Steps not equal. 3.125 != %d " % currentstep)
         
        currentstep = me.oneStep(Motor.BACKWARD, Motor.MICROSTEP)
        self.assertEqual(3.0, currentstep, "Steps not equal. 3.0 != %d " % currentstep)
         
        currentstep = me.oneStep(Motor.BACKWARD, Motor.INTERLEAVE)
        self.assertEqual(2.5, currentstep, "Steps not equal. 2.5 != %d " % currentstep)
         
        currentstep = me.oneStep(Motor.BACKWARD, Motor.INTERLEAVE)
        self.assertEqual(2.0, currentstep, "Steps not equal. 3.0 != %d " % currentstep)
 
        currentstep = me.oneStep(Motor.BACKWARD, Motor.SINGLE)
        self.assertEqual(1, currentstep, "Steps not equal. 1 != %d " % currentstep)        
 
        currentstep = me.oneStep(Motor.BACKWARD, Motor.SINGLE)
        self.assertEqual(0, currentstep, "Steps not equal. 0 != %d " % currentstep)
 
    def testStep(self):
         
        me = self.motor_emulator
        currentstep = me.getCurrentstep()
        self.assertEqual(0, currentstep, "Steps not equal. 0 != %d " % currentstep)
         
        currentstep = me.step(20, Motor.FORWARD, Motor.SINGLE, 20)
        self.assertEqual(20, currentstep, "Steps not equal. 20 != %d " % currentstep)
         
        currentstep = me.step(5, Motor.FORWARD, Motor.DOUBLE, 5)
        self.assertEqual(25, currentstep, "Steps not equal. 25 != %d " % currentstep)
 
        currentstep = me.step(5, Motor.FORWARD, Motor.INTERLEAVE, 5)   
        self.assertEqual(30, currentstep, "Steps not equal. 27.5 != %d " % currentstep)
         
        currentstep = me.step(8, Motor.FORWARD, Motor.MICROSTEP, 8)   
        self.assertEqual(38, currentstep, "Steps not equal. 28.5 != %d " % currentstep)
         
        currentstep = me.step(30, Motor.BACKWARD, Motor.MICROSTEP, 30)   
        self.assertEqual(8, currentstep, "Steps not equal. 8.5 != %d " % currentstep)
         
        currentstep = me.step(8, Motor.BACKWARD, Motor.SINGLE, 8)   
        self.assertEqual(0, currentstep, "Steps not equal. 0.5 != %d " % currentstep)
 
        currentstep = me.step(1, Motor.BACKWARD, Motor.DOUBLE, 1)   
        self.assertEqual(-1, currentstep, "Steps not equal. 199.5 != %d " % currentstep)

if __name__ == "__main__":
    # import sys;sys.argv = ['', 'Test.testName']
    unittest.main()
