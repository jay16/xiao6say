#!/bin/sh  
# 

if test -z "$2"
then
    PORT=3456
else
    PORT=$2
fi
if test -z "$3"
then
    ENVIRONMENT="production"
else
    ENVIRONMENT="$3"
fi

echo "recompile phantom's C codes."
cd lib/utils/recognizer && gcc processPattern.c -o processPattern

echo "port: ${PORT} environment: ${ENVIRONMENT}"
UNICORN=unicorn  
CONFIG_FILE=config/unicorn.rb  
  
case "$1" in  
    start)  
        test -d log || mkdir log
        test -d tmp || mkdir -p tmp/pids
        echo "start unicorn"
        bundle exec ${UNICORN} -c ${CONFIG_FILE} -p ${PORT} -E ${ENVIRONMENT} -D  
        ;;  
    stop)  
        echo "stop unicorn"
        kill -QUIT `cat tmp/pids/unicorn.pid`  
        ;;  
    restart|force-reload)  
        kill -USR2 `cat tmp/pids/unicorn.pid`  
        ;;  
    *)  
        echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload}" >&2  
        exit 3  
        ;;  
esac  

