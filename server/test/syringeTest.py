'''
Created on Jun 28, 2016

@author: Mark Royer
'''
import thread
import time
import unittest

from motors import MotorEmulator
from syringe import SyringePump


class Test(unittest.TestCase):

    def setUp(self):
        pitch_mm = 0.8 # mm
        syringeDiameter_mm = 5 # mm
        
        self.syringe = SyringePump(pitch_mm, syringeDiameter_mm, MotorEmulator())


    def tearDown(self):
        pass


    def testName(self):
        pass

    def testMovePosition(self):
        pos = self.syringe.getPosition()
        self.assertEquals(0, pos, "Positions don't match %f != %f" % (0, pos))
        
        self.syringe.movePosition(5, 0)
        pos = self.syringe.getPosition()
        self.assertEquals(5, pos, "Positions don't match %f != %f" % (5, pos))
        
        self.syringe.movePosition(-3, 0)
        pos = self.syringe.getPosition()
        self.assertEquals(2, pos, "Positions don't match %f != %f" % (2, pos))
        
    def testMovePositionAsync(self):
        pos = self.syringe.getPosition()
        self.assertEquals(0, pos, "Positions don't match %f != %f" % (0, pos))
        
        self.syringe.movePositionAsync(5, 100)
        time.sleep(0.3)
        pos = self.syringe.getPosition()
        self.assertEquals(5, pos, "Positions don't match %f != %f" % (5, pos))
        
        self.syringe.movePositionAsync(-3, 100)
        time.sleep(0.3)
        pos = self.syringe.getPosition()
        self.assertEquals(2, pos, "Positions don't match %f != %f" % (2, pos))
    
    def testReset(self):
        pos = self.syringe.getPosition()
        self.assertEquals(0, pos, "Positions don't match %f != %f" % (0, pos))
        
        self.syringe.reset(5)
        pos = self.syringe.getPosition()
        self.assertEquals(5, pos, "Positions don't match %f != %f" % (5, pos))
        
        self.syringe.reset(0)
        pos = self.syringe.getPosition()
        self.assertEquals(0, pos, "Positions don't match %f != %f" % (0, pos))

if __name__ == "__main__":
    #import sys;sys.argv = ['', 'Test.testName']
    unittest.main()