# Linux based Picture Frame V3

This is 3rd version of YAPF (Yet Another Picture Frame) experiments. 

The repository contains a set of shell scripts and configuration files to turn any Raspberry Pi into a picture frame controller. In fact, these would work with any Debian-based linux with exeption of interracting with PIR sensor via GPIO pins, which is specific to RPi.

See:
[http://minkbot.blogspot.com/2018/07/40-picture-frame-for-under-100.html]
[http://minkbot.blogspot.com/2018/08/picture-frame-rpipf-on-schedule.html]
[http://minkbot.blogspot.com/2010/12/yapf-yet-another-pricture-frame.html]

## Files

+ ~/.profile - starts X when first tty1 is logged in
+ ~/.xinitrc - executes X commands and start main controll script
+ ~/bin - contains all scripts
  + pf.sh - main control script invoked from .xinitrc
  + tvon/tvoff - commands to turn the TV on and off via CEC over HDMI
  + gofeh - starts the slideshow via feh program
  + aptu/apti - shortcuts to invoke apt-get conviniently: to install a package or to perform full update
  + gpiord - read a state of GPIO pin (RPi specific)
  + checkpin - continously reads the pin and outputs it (used for PIR testing)

The content of this repository can be directly copied into /home/pi  (ie home directory of user 'pi').
