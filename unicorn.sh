#!/bin/sh  
# 
PORT=$(test -z "$2" && echo "3456" || echo "$2")
ENVIRONMENT=$(test -z "$3" && echo "production" || echo "$3")

echo "port: ${PORT} environment: ${ENVIRONMENT}"
UNICORN=unicorn  
CONFIG_FILE=config/unicorn.rb  
 
APP_ROOT_PATH=$(pwd)
echo "recompile phantom's C codes."
cd lib/utils/processPattern 
gcc buildPatternHeader.c -o buildPatternHeader
./buildPatternHeader
gcc processPattern.c -o processPattern
# back to app_root_path
cd ${APP_ROOT_PATH}

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
    deploy)
        echo "RACK_ENV=production bundle exec rake remote:deploy"
        ;;
    *)  
        echo "Usage: $SCRIPTNAME {start|stop|restart|force-reload|deploy}" >&2  
        exit 3  
        ;;  
esac  
