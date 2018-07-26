#!/usr/bin/env bash

SIDEKIQ_PID_FILE=tmp/pids/sidekiq.pid

# check if sidekiq process is running
sidekiq_is_running() {
  if [ -e $SIDEKIQ_PID_FILE ] ; then
    if cat $SIDEKIQ_PID_FILE | xargs ps -o comm= -p > /dev/null ; then
      return 0
    else
      echo "No sidekiq process found"
    fi
  else
    echo "No sidekiq pid file found"
  fi

  return 1
}

case "$1" in
  start)
    echo "Starting sidekiq..."
    bundle exec sidekiq -d -P $SIDEKIQ_PID_FILE

    echo "done"
    ;;

  stop)
    echo "Stopping sidekiq..."
      bundle exec sidekiqctl stop $SIDEKIQ_PID_FILE 5
      rm -f $SIDEKIQ_PID_FILE

    echo "done"
    ;;

  restart)
    echo "Restarting sidekiq..."
    if sidekiq_is_running ; then
      bundle exec sidekiqctl stop $SIDEKIQ_PID_FILE 5
    fi

    bundle exec sidekiq -d -P $SIDEKIQ_PID_FILE

    echo "done"
    ;;

  *)
    echo "Usage: script/sidekiq.sh {start|stop|restart}" >&2
    ;;
esac
