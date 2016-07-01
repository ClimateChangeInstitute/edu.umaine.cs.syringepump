ifeq ($(OS),Windows_NT)
SHELL = $(ComSpec)
RMDIR = rmdir /s /q
mymkdir = if not exist "$1" mkdir "$1"
else
RMDIR = rm -fr
mymkdir = mkdir -p $1
endif

PROJECT_OBJS = \
	default/project/main.cpp.o \

PLATFORM_OBJS = \
	default/platform/cores/arduino/new.cpp.o \
	default/platform/cores/arduino/HardwareSerial3.cpp.o \
	default/platform/cores/arduino/Stream.cpp.o \
	default/platform/cores/arduino/HardwareSerial.cpp.o \
	default/platform/cores/arduino/IPAddress.cpp.o \
	default/platform/cores/arduino/wiring_digital.c.o \
	default/platform/cores/arduino/HardwareSerial0.cpp.o \
	default/platform/cores/arduino/Tone.cpp.o \
	default/platform/cores/arduino/USBCore.cpp.o \
	default/platform/cores/arduino/WMath.cpp.o \
	default/platform/cores/arduino/CDC.cpp.o \
	default/platform/cores/arduino/HardwareSerial2.cpp.o \
	default/platform/cores/arduino/PluggableUSB.cpp.o \
	default/platform/cores/arduino/main.cpp.o \
	default/platform/cores/arduino/wiring_pulse.S.o \
	default/platform/cores/arduino/wiring.c.o \
	default/platform/cores/arduino/WInterrupts.c.o \
	default/platform/cores/arduino/HardwareSerial1.cpp.o \
	default/platform/cores/arduino/wiring_analog.c.o \
	default/platform/cores/arduino/wiring_shift.c.o \
	default/platform/cores/arduino/abi.cpp.o \
	default/platform/cores/arduino/hooks.c.o \
	default/platform/cores/arduino/WString.cpp.o \
	default/platform/cores/arduino/Print.cpp.o \
	default/platform/cores/arduino/wiring_pulse.c.o \

LIBRARIES_OBJS = \
	default/libraries/Adafruit_Motor_Shield_V2_Library/Adafruit_MotorShield.cpp.o \
	default/libraries/Adafruit_Motor_Shield_V2_Library/utility/Adafruit_MS_PWMServoDriver.cpp.o \
	default/libraries/Wire/src/utility/twi.c.o \
	default/libraries/Wire/src/Wire.cpp.o \

TARGETS = \
	default/Arduino.hex \

all: $(TARGETS)

default/Arduino.hex: default/Arduino.elf
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-objcopy" -O ihex -R .eeprom  "default/Arduino.elf" "default/Arduino.hex"

default/Arduino.elf: $(PROJECT_OBJS) $(LIBRARIES_OBJS) default/core.a
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-gcc" -w -Os -Wl,--gc-sections -mmcu=atmega328p  -o "default/Arduino.elf" $(PROJECT_OBJS) $(LIBRARIES_OBJS) "default/core.a" "-Ldefault" -lm

default/core.a:	$(PLATFORM_OBJS)

clean:
	$(RMDIR) default

size:
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-size" -A "default/Arduino.elf"

default/project/main.cpp.o: ../main.cpp default/project/main.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"

default/project/main.cpp.d: ;

-include default/project/main.cpp.d 


default/platform/cores/arduino/new.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/new.cpp default/platform/cores/arduino/new.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/new.cpp.d: ;

-include default/platform/cores/arduino/new.cpp.d

default/platform/cores/arduino/HardwareSerial3.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/HardwareSerial3.cpp default/platform/cores/arduino/HardwareSerial3.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/HardwareSerial3.cpp.d: ;

-include default/platform/cores/arduino/HardwareSerial3.cpp.d

default/platform/cores/arduino/Stream.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/Stream.cpp default/platform/cores/arduino/Stream.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/Stream.cpp.d: ;

-include default/platform/cores/arduino/Stream.cpp.d

default/platform/cores/arduino/HardwareSerial.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/HardwareSerial.cpp default/platform/cores/arduino/HardwareSerial.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/HardwareSerial.cpp.d: ;

-include default/platform/cores/arduino/HardwareSerial.cpp.d

default/platform/cores/arduino/IPAddress.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/IPAddress.cpp default/platform/cores/arduino/IPAddress.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/IPAddress.cpp.d: ;

-include default/platform/cores/arduino/IPAddress.cpp.d

default/platform/cores/arduino/wiring_digital.c.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/wiring_digital.c default/platform/cores/arduino/wiring_digital.c.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"
	
default/platform/cores/arduino/wiring_digital.c.d: ;

-include default/platform/cores/arduino/wiring_digital.c.d

default/platform/cores/arduino/HardwareSerial0.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/HardwareSerial0.cpp default/platform/cores/arduino/HardwareSerial0.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/HardwareSerial0.cpp.d: ;

-include default/platform/cores/arduino/HardwareSerial0.cpp.d

default/platform/cores/arduino/Tone.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/Tone.cpp default/platform/cores/arduino/Tone.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/Tone.cpp.d: ;

-include default/platform/cores/arduino/Tone.cpp.d

default/platform/cores/arduino/USBCore.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/USBCore.cpp default/platform/cores/arduino/USBCore.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/USBCore.cpp.d: ;

-include default/platform/cores/arduino/USBCore.cpp.d

default/platform/cores/arduino/WMath.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/WMath.cpp default/platform/cores/arduino/WMath.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/WMath.cpp.d: ;

-include default/platform/cores/arduino/WMath.cpp.d

default/platform/cores/arduino/CDC.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/CDC.cpp default/platform/cores/arduino/CDC.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/CDC.cpp.d: ;

-include default/platform/cores/arduino/CDC.cpp.d

default/platform/cores/arduino/HardwareSerial2.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/HardwareSerial2.cpp default/platform/cores/arduino/HardwareSerial2.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/HardwareSerial2.cpp.d: ;

-include default/platform/cores/arduino/HardwareSerial2.cpp.d

default/platform/cores/arduino/PluggableUSB.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/PluggableUSB.cpp default/platform/cores/arduino/PluggableUSB.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/PluggableUSB.cpp.d: ;

-include default/platform/cores/arduino/PluggableUSB.cpp.d

default/platform/cores/arduino/main.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/main.cpp default/platform/cores/arduino/main.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/main.cpp.d: ;

-include default/platform/cores/arduino/main.cpp.d

default/platform/cores/arduino/wiring_pulse.S.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/wiring_pulse.S
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-gcc" -c -g -x assembler-with-cpp -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/wiring.c.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/wiring.c default/platform/cores/arduino/wiring.c.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"
	
default/platform/cores/arduino/wiring.c.d: ;

-include default/platform/cores/arduino/wiring.c.d

default/platform/cores/arduino/WInterrupts.c.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/WInterrupts.c default/platform/cores/arduino/WInterrupts.c.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"
	
default/platform/cores/arduino/WInterrupts.c.d: ;

-include default/platform/cores/arduino/WInterrupts.c.d

default/platform/cores/arduino/HardwareSerial1.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/HardwareSerial1.cpp default/platform/cores/arduino/HardwareSerial1.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/HardwareSerial1.cpp.d: ;

-include default/platform/cores/arduino/HardwareSerial1.cpp.d

default/platform/cores/arduino/wiring_analog.c.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/wiring_analog.c default/platform/cores/arduino/wiring_analog.c.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"
	
default/platform/cores/arduino/wiring_analog.c.d: ;

-include default/platform/cores/arduino/wiring_analog.c.d

default/platform/cores/arduino/wiring_shift.c.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/wiring_shift.c default/platform/cores/arduino/wiring_shift.c.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"
	
default/platform/cores/arduino/wiring_shift.c.d: ;

-include default/platform/cores/arduino/wiring_shift.c.d

default/platform/cores/arduino/abi.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/abi.cpp default/platform/cores/arduino/abi.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/abi.cpp.d: ;

-include default/platform/cores/arduino/abi.cpp.d

default/platform/cores/arduino/hooks.c.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/hooks.c default/platform/cores/arduino/hooks.c.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"
	
default/platform/cores/arduino/hooks.c.d: ;

-include default/platform/cores/arduino/hooks.c.d

default/platform/cores/arduino/WString.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/WString.cpp default/platform/cores/arduino/WString.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/WString.cpp.d: ;

-include default/platform/cores/arduino/WString.cpp.d

default/platform/cores/arduino/Print.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/Print.cpp default/platform/cores/arduino/Print.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"

default/platform/cores/arduino/Print.cpp.d: ;

-include default/platform/cores/arduino/Print.cpp.d

default/platform/cores/arduino/wiring_pulse.c.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino/wiring_pulse.c default/platform/cores/arduino/wiring_pulse.c.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-ar" rcs  "default/core.a" "$@"
	
default/platform/cores/arduino/wiring_pulse.c.d: ;

-include default/platform/cores/arduino/wiring_pulse.c.d


default/libraries/Adafruit_Motor_Shield_V2_Library/Adafruit_MotorShield.cpp.o: /home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/Adafruit_MotorShield.cpp default/libraries/Adafruit_Motor_Shield_V2_Library/Adafruit_MotorShield.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"

default/libraries/Adafruit_Motor_Shield_V2_Library/Adafruit_MotorShield.cpp.d: ;

-include default/libraries/Adafruit_Motor_Shield_V2_Library/Adafruit_MotorShield.cpp.d

default/libraries/Adafruit_Motor_Shield_V2_Library/utility/Adafruit_MS_PWMServoDriver.cpp.o: /home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility/Adafruit_MS_PWMServoDriver.cpp default/libraries/Adafruit_Motor_Shield_V2_Library/utility/Adafruit_MS_PWMServoDriver.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"

default/libraries/Adafruit_Motor_Shield_V2_Library/utility/Adafruit_MS_PWMServoDriver.cpp.d: ;

-include default/libraries/Adafruit_Motor_Shield_V2_Library/utility/Adafruit_MS_PWMServoDriver.cpp.d

default/libraries/Wire/src/utility/twi.c.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src/utility/twi.c default/libraries/Wire/src/utility/twi.c.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-gcc" -c -g -Os -w -std=gnu11 -ffunction-sections -fdata-sections -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"

default/libraries/Wire/src/utility/twi.c.d: ;

-include default/libraries/Wire/src/utility/twi.c.d

default/libraries/Wire/src/Wire.cpp.o: /home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src/Wire.cpp default/libraries/Wire/src/Wire.cpp.d
	@$(call mymkdir,$(dir $@))
	"/home/mroyer/.arduinocdt/packages/arduino/tools/avr-gcc/4.8.1-arduino5/bin/avr-g++" -c -g -Os -w -std=gnu++11 -fno-exceptions -ffunction-sections -fdata-sections -fno-threadsafe-statics -MMD -mmcu=atmega328p -DF_CPU=16000000L -DARDUINO=10607 -DARDUINO_AVR_UNO -DARDUINO_ARCH_AVR   -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/cores/arduino" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/variants/standard" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4" -I"/home/mroyer/.arduinocdt/libraries/Adafruit_Motor_Shield_V2_Library/1.0.4/utility" -I"/home/mroyer/.arduinocdt/packages/arduino/hardware/arduino/avr/1.6.11/libraries/Wire/src" "$<" -o "$@"

default/libraries/Wire/src/Wire.cpp.d: ;

-include default/libraries/Wire/src/Wire.cpp.d

