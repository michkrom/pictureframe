#!/usr/bin/env bash

# Picture Frame control script

logger "PF started"

# last time a user motion was detected (via PIR connected to GPIO18)
lastmotion=`date +%s`
prevpinstate=0
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
  pinstate=`gpiord 18`

  if [ $pinstate -ne $prevpinstate ]; then
      #logger "PF motion pin change to $pinstate"
      if [ $pinstate -eq 1 ]; then 
         logger "PF motion detected"
      fi
      prevpinstate=$pinstate
  fi

  if [ $pinstate -eq 1 ]; then
    lastmotion=$nowts
  fi   
  let lastmotionage=$nowts-$lastmotion
  
  # logger $nowts $pinstate $lastmotion  $lastmotionage

  # decide if ok to show: 10min motion age (600s) and within the right time of day
  show=false

  if [ $lastmotionage -lt 600 ] && [ "$timeok" = true ]; then
  #if [ "$timeok" = true ]; then
    show=true
  fi

  # start showing or shutdown the slide show
  fehpid=`pidof feh`
  if "$show" = true; then
    if [ -z $fehpid ]; then # if feh is not running
      echo "ON"
      logger "PF ON"
      #logger "PF $lastmotion : $lastmotionage $timeok $show $fehpid"
      tvon
      gofeh &
    fi
  else
    if [ ! -z $fehpid ]; then # if feh is running
      echo "off"
      logger "PF off"
      logger $lastmotion ':' $lastmotionage $timeok $show $fehpid
      skill feh
      tvoff
      sleep 10 # to work around bouncing of the PIR sencor
    fi
  fi

  echo $lastmotion $lastmotionage $timeok $show $fehpid

  # wait a moment before checking again
  sleep 1

done
