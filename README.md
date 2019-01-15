# syringepump

A syringe pump controller system for Raspberry Pi and Arduino.

The syringe pump controller uses the [Adafruit motor HAT
v2.3](https://www.adafruit.com/product/2348) for Raspberry Pi and the
[Adafruit motor shield](https://www.adafruit.com/products/1438) for
Arduino.

A case for the Raspberry Pi with the Adafruit motor HAT can be found
at [RPi2](https://github.com/markroyer/rpi2-adafruit-motor-hat-case).

## Setup

The syringe pump control software is written in Python and requires
Python 2.7 to be installed.  The software also requires that the
`pyserial` library is installed (see below for installation details).

The syringe pump controller can operate in three separate modes: motor
emulation, Adafruit Motor HAT (via Raspberry Pi or some Linux)
operated, or Arduino (with Adafruit motor shield) operated. The type
of the motor operation is automatically selected when the server is
started.  If an Arduino is detected via serial connection, then it is
used.  If the Arduino is not found, then the Adafruit Motor HAT
libraries are searched for, and if they are found, they are utilized.
If neither of those libraries are found, then the server falls back to
motor emulation which is useful for testing the client. The rest of
the setup will be broken up for each of these types.

### Emulation Setup

Nothing further to setup. Everything should work as long as the Python
2.7 is installed.

### Adafruit Motor HAT (via Raspberry Pi)

To use the Adafruit motor HAT with the syringe pump controller, the
[Adafruit Python
library](https://github.com/adafruit/Adafruit-Motor-HAT-Python-Library)
must be installed.  Once it is installed, the syringe pump controller
will select it by default during startup.

### Arduino (with Adafruit motor shield)

To use the syringe controller with an Arduino with an Adafruit motor
shield, the pyserial library must be installed so that the controller
can communicate with the Arduino.  The pyserial library can be
installed a number of ways depending on what system is being run.

On Debian based systems the pyserial library can be installed by
performing an apt update and then installing

```bash
sudo apt-get install python-serial
```

## Usage

This section contains description of standard syringe pump usage.

### Starting the Controller

To start the syringe pump controller, `cd` to the `server` directory
and type:

```bash
python syringepump_server.py
```

This will generate the following output.

```bash
Using motor emulation.
Bottle v0.13-dev server starting up (using WSGIRefServer())...
Listening on http://0.0.0.0:8080/
Hit Ctrl-C to quit.
```

This starts the syringe pump controller server on port 8080.
Directing a web browser to

```
http://localhost:8080/index.html
```

opens the syringe pump controller page.

### Calibrating the Syringe Pump

The first action that should occur when the syringe pump is initially
run, is to perform pump calibration. Clicking on the **Calibrate**
button starts the calibration wizard.  This makes the syringe pump
perform a series of three loads and unloads.  Each loading and
unloading is a larger amount of motor steps, which results in a larger
amount of fluid being loaded and discharged.  The loaded amounts are
as follows.

1. 1000 motor steps
2. 2000 motor steps
3. 4000 motor steps

Each time the motor loads the fluid and then discharges it, the amount
of fluid is measured and recorded.

Finally, a linear regression is performed on the motor steps vs the
amount of fluid, and this formula is used to calibrate the syringe
pump. This allows the syringe pump controller to get very accurate
results without strictly relying on measurements of the syringe size
and the screw pitch.

### Standard Options

#### Basic Operation

Assuming the syringe pump has been calibrated, then the standard
operation is quite simple.  The amount to be loaded is specified (the
default value is 1ml). Next, the **Load Syringe!** button is pressed.
The syringe loads the fluid in approximately 20 seconds.

Next, the amount of time to take for the fluid to be discharged is
specified (the default is 30min). The **Unload Syringe!** button is
pressed, and the fluid begins to empty at the specified rate.

#### Motor Adjustments

There are a number of buttons listed below the basic operations for
moving the syringe plunger.  The options are 100, 1000, and 2000 in
either direction.  There is also the option to reset the motors
initial position back to zero (the motor control software calculates
load amounts relative to this position).

#### System Shutdown

There is also a button to shutdown the system. This button only works
if the system password has been specified at the top of the
`syringepump_server.py` file.  The line looks like the following.

```python
SYSTEM_PASS = ''  # set this if you want to be able to shutdown the server
```

You can decide for yourself if this is a security risk for your system
and setup.

### Advanced Features

This section contains settings that most users are unlikely to edit
(at least directly).

#### Load Time

The default load time of 20 seconds is a reasonable speed to load 1 ml
of fluid at 200 motor steps per revolution. Setting its value too low
may result in the motor skipping steps.  The system is intended to
move the syringe pump slowly, so if a decrease in this value is needed,
then changes to syringe and motor gearing may be required.

#### Calibration Settings

The calibration settings affect the amount of fluid that is loaded and
discharged by the syringe pump. By default, the number of steps per 1
ml of fluid is 1415. Additional default settings are shown in the
table below.

| Setting              | Default Value |
| -------------------- | -------------:|
| Syringe Diameter     |            15 |
| Pitch (# mm / 1 rev) |           0.8 |
| # Steps / 1 rev      |           200 |

The **syringe diameter** is the inner space of the syringe.  The
**pitch** is the distance that a single rotation of the screw causes
the plunger to move in millimeters.  The **# steps / 1 rev** is how
many motor steps it takes to make the screw complete a single
revolution.

## License

The project is licensed under the terms of the
[GPL3](https://www.gnu.org/licenses/gpl-3.0.en.html) license.

<!--

LocalWords:  Arduino Adafruit RPi cd syringepump py dev WSGIRefServer
LocalWords:  Ctrl TODO GPL pyserial sudo min rev

-->
