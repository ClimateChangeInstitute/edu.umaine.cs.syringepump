# edu.umaine.cs.syringepump

A syringe pump controller system for Raspberry Pi and Arduino.

A case for the Raspberry Pi with the Adafruit motor HAT can be found at [RPi2](https://github.com/markroyer/rpi2-adafruit-motor-hat-case).

## Setup

The syringe pump control software is written in Python and requires Python 2.7 to be installed.

To start the syringe pump controller, `cd` to the `server` directory and type:

```bash
python syringepump_server.py
```

This will generate output as follows.

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

TODO

## Usage

TODO

## License

The project is licensed under the terms of the
[GPL3](https://www.gnu.org/licenses/gpl-3.0.en.html) license.
