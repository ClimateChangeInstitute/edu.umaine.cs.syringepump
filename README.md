# edu.umaine.cs.syringepump

A syringe pump controller system for Raspberry Pi and Arduino.

The syringe pump controller uses the [Adafruit motor HAT v2.3](https://www.adafruit.com/product/2348) for Raspberry Pi and the [Adafruit motor shield](https://www.adafruit.com/products/1438) for Arduino.  

A case for the Raspberry Pi with the Adafruit motor HAT can be found at [RPi2](https://github.com/markroyer/rpi2-adafruit-motor-hat-case).

## Setup

The syringe pump control software is written in Python and requires Python 2.7 to be installed.

To start the syringe pump controller, `cd` to the `server` directory and type:

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

This starts the syringe pump controller server on port 8080.  Directing a webrowser to

```
http://localhost:8080/index.html
```

opens the syringe pump controller page.

The syringe pump controller can operate in three separate modes: motor emulation, Adafruit Motor HAT (via Raspberry Pi or some linux) operated, or Arduino (with Adafruit motor shield) operated. The type of the motor operation is automatically selected when the server is started.  If an Arduino is detected via serial connection, then it is used.  If the Arduino is not found, then the Adafruit Motor HAT libraries are searched for, and if they are found, they are utilized.  If neither of those libraries are found, then the server falls back to motor emulation which is useful for testing the client. The rest of the setup will be broken up for each of these types.

### Emulation Setup

Nothing further to setup. Everything should work as long as the Python 2.7 is installed.

### Adafruit Motor HAT (via Raspberry Pi)

TODO

### Arduino (with Adafruit motor shield)

TODO

## Usage

TODO

## License

The project is licensed under the terms of the
[GPL3](https://www.gnu.org/licenses/gpl-3.0.en.html) license.
