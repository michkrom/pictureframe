#!/usr/bin/env bash

# Picture Frame control script

logger "PF started"

# last time a user motion was detected (via PIR connected to GPIO18)
lastmotion=`date +%s`

# loop forever
while true; do

  # check for allowed time of day
  timeok=false
  tnow=`date +%H%M` # time in HHMM 24h used as single number
  if [ $tnow -gt 700 ] && [ $tnow -lt 2300 ]; then
    timeok=true
  fi

  # check for viewer activity (PIR on GPIO18)
  nowts=`date +%s` # timestamp in seconds since epoch
  if [ `gpiord 18` -eq 1 ]; then
    lastmotion=$nowts
  fi
  let lastmotionage=$nowts-$lastmotion

  # decide if ok to show: 10min motion age (600s) and within the right time of day
  show=false
  if [ $lastmotionage -lt 600 ] && [ $timeok ]; then
    show=true
  fi

  echo $lastmotion $lastmotionage $timeok $show

  # start showing or shutdown the slide show
  fehpid=`pidof feh`
  if $show; then
    if [ -z $fehpid ]; then # if feh is not running
      echo "ON"
      logger "PF ON"
      tvon
      gofeh &
    fi
  else
    if [ ! -z $fehpid ]; then # if feh is running
      echo "off"
      logger "PF OFF"
      skill feh
      tvoff
    fi
  fi

  # wait a moment before checking again
  sleep 1

done
