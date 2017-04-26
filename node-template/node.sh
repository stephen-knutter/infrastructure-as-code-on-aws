#!/bin/bash

# nodejs - Startup script for node.js server

# chkconfig: 35 85 15
# description: node is an event-based web server.
# processname: node
# server: /path/to/your/node/file.js
# pidfile: /var/run/nodejs.pid
#

. /etc/rc.d/init.d/functions

OPTIONS=" /path/to/your/node/file.js"
LOGFILE=" /var/log/nodejs/nodejs.log"
SYSCONFIG="/etc/sysconfig/nodejs"

nodejs=${NODEJS-/usr/local/bin/node}

NODEJS_USER=ec2-user
NODEJS_GROUP=ec2-user

. "$SYSCONFIG" || true


start()
{
  echo -n $"Starting nodejs: "
  daemon --user "$NODEJS_USER" "$nodejs $OPTIONS >> $LOGFILE &"
  RETVAL=$?
  echo
  [ $RETVAL -eq 0 ] && touch /var/lock/subsys/nodejs
}

stop()
{
  echo -n $"Stopping nodejs: "
  killproc /usr/local/bin/node
  RETVAL=$?
  echo
  [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/nodejs
}

restart () {
	stop
	start
}

ulimit -n 12000
RETVAL=0

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart|reload|force-reload)
    restart
    ;;
  condrestart)
    [ -f /var/lock/subsys/nodejs ] && restart || :
    ;;
  status)
    status $nodejs
    RETVAL=$?
    ;;
  *)
    echo "Usage: $0 {start|stop|status|restart|reload|force-reload|condrestart}"
    RETVAL=1
esac

exit $RETVAL
