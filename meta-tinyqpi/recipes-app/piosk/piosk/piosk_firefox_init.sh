#!/bin/sh
# Init script to start the piosk
### BEGIN INIT INFO
# Provides: Piosk
# Default-Start:     5
# Default-Stop:      0 1 6
### END INIT INFO

killproc() {
        pid=`/bin/pidof $1`
        [ "$pid" != "" ] && kill $pid
}

case "$1" in
  start)
      # Chromium depends on weston wm
      echo "Start Piosk"
      WESTON_USER=weston
      # Weston started wait until socket is available, stop after 30s
      i=0 
	while [ -z "$wayland_display" ] && [ $i -lt 6 ]
	do
	      ((i+=1))
	      sleep 5
            wayland_display=$(ls /run/user/$(id -u ${WESTON_USER})/ | grep  '^wayland-[0-9]$' | head -n 1)
	done
	su -c "XDG_RUNTIME_DIR=/run/user/$(id -u ${WESTON_USER}) WAYLAND_DISPLAY=$wayland_display chromium --kiosk --hide-scrollbars --no-first-run $2" $WESTON_USER &
  ;;

  stop)
        echo "Stop Piosk"
      #   killproc chromium
  ;;

  restart)
	$0 stop
        sleep 1
        $0 start
  ;;

  *)
        echo "usage: $0 { start | stop | restart }"
  ;;
esac

exit 0
