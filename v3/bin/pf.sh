logger "PF started"

while true; do
  now=`date +%H%M`
  fehpid=`pidof feh`
  if [ $now -gt 700 ] && [ $now -lt 2300 ]; then
    if [ -z $fehpid ]; then
      logger "PF now=$now fehpid=$fehpid ON"
      tvon
      gofeh &
    fi
  else
    if [ ! -z $fehpid ]; then
      logger "PF now=$now fehpid=$fehpid OFF"
      skill feh
      tvoff
    fi
  fi
  sleep 1m 
done
