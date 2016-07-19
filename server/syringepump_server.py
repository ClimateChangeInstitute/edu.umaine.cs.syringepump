#!/usr/bin/python
'''
Created on May 22, 2016

@author: Mark Royer
'''
import sys
from motors import MotorEmulator, ArduinoMotor, RaspberryPiMotor
import time
import thread
import os
from syringe import SyringePump

sys.path.append('lib')

import json
from bottle import run, request, route, static_file

SYSTEM_PASS = ''  # set this if you want to be able to shutdown the server
SERVER_PATH = '../client'
SETTINGS_FILE = 'settings.json'


def getSyringePump():
    '''
    @return: A syringe pump with motor 
    '''
    
    with open(SETTINGS_FILE) as f:    
        data = json.load(f)
    
    if data == None:
        print "Unable to load settings file %s." % SETTINGS_FILE
        print "Server will not exit."
        exit(-1)
        
    pitch_mm = data['defaultPitch_mmPerRev']
    stepsPerRev = data['defaultStepsPerRevolution']
    syringeDiameter_mm = data['defaultSyringeDiameter_mm']
    
    motor = None
    try:
        motor = ArduinoMotor(stepsPerRev)
        print "Using Arduino motor controller"
    except:
        try:
            #from motors import MotorEmulator, ArduinoMotor, RaspberryPiMotor
            motor = RaspberryPiMotor(stepsPerRev)
            print "Using Raspberry Pi Adafruit Python motor controller"
        except:
            motor = MotorEmulator(stepsPerRev)
            print "Using motor emulation."
    
    return SyringePump(pitch_mm, syringeDiameter_mm, motor)

syringePump = getSyringePump()

@route('/')
def serveRoot():  # Default server home page
    return static_file('/index.html', root=SERVER_PATH)

@route('/<filename:path>')
def server_static(filename):
    '''
    Serves the static documents in SERVER_PATH.
    @param filename: The name of the file to retrieve
    '''
    return static_file(filename, root=SERVER_PATH)

@route('/load', method='POST')
def load():
    amnt = float(request.forms.get('amnt'))
    time = float(request.forms.get('time'))
        
    print "Moving motor %f mm in %f ms" % (amnt, time)
        
    syringePump.reset(0)
    syringePump.movePositionAsync(amnt, time)
    
    obj = {
           'msg': "Started to load syringe!",
           'amnt': amnt,
           'time': time
           }
    
    return json.dumps(obj)

@route('/unload', method='POST')
def unload():
    
    amnt = float(request.forms.get('amnt'))
    time = float(request.forms.get('time'))
        
    print "Moving motor %f mm in %f ms" % (amnt, time)
        
    syringePump.movePositionAsync(-1 * amnt, time)
    
    obj = {
           'msg': "Started to unload syringe!",
           'amnt': amnt,
           'time': time
           }
    
    return json.dumps(obj)

@route('/moveSteps', method='POST')
def moveSteps():
    
    steps = int(request.forms.get('steps'))
    time_ms = float(request.forms.get('time_ms'))
    
    print "Moving motor %d steps in %f ms" % (steps, time_ms)
    
    start = syringePump.motor.getCurrentstep()
    
    syringePump.moveStepsAsync(steps, time_ms)
    
    obj = {
           'msg': "Started to unload syringe!",
           'start': start,
           'end': start + steps,
           'time_ms': time_ms
           }
    
    return json.dumps(obj)
    

@route('/info', method='GET')
def info():
    
    infoType = request.params['type']
    
    obj = {}
    
    if infoType == "amnt" :
        obj['msg'] = "Position of motor"
        obj['amnt'] = syringePump.getPosition()
    elif infoType == "steps" :
        obj['msg'] = "Steps motor moved"
        obj['steps'] = syringePump.motor.getCurrentstep()
        print 'steps %d' % obj['steps']
    
    return json.dumps(obj)

@route('/defaults')
def defaults():
    
    action = request.params['action']
    
    if action == 'load':
        with open('settings.json') as settingsFile:    
            data = json.load(settingsFile)
        return json.dumps(data)
    

def shutdownFuncThread():
    time.sleep(2)
    sudoPass = SYSTEM_PASS
    command = 'shutdown now'
    os.system('echo %s|sudo -S %s' % (sudoPass, command))
       

@route('/shutdown', method='POST')
def shutdown():
    
    obj = {}
    
    obj['msg'] = "Syringe pump is shutting down..."
    
    thread.start_new_thread(shutdownFuncThread, ())
    
    return json.dumps(obj)
    
if __name__ == '__main__':
    
    # Listen on localhost interface only
    # run(host='localhost', port=8080, debug=True)
    
    # Listen to all interfaces, which will allow external connections
    run(host='0.0.0.0', port=8080, debug=True)
    
