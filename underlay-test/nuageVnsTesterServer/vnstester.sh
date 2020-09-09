#! /bin/sh
test -f /opt/nuage_vns_tester_server/service_start.py || exit 0
case "$1" in
    start)
          echo -n "Starting Nuage VNS tester server"
          python /opt/nuage_vns_tester_server/service_start.py &
          iperf3 -s --pidfile /opt/nuage_vns_tester_server/iperf3.pid --logfile /opt/nuage_vns_tester_server/iperf3.result &
          echo "."
          ;;
    stop) 
          echo -n "Stopping Nuage VNS tester server"
          kill -2 `cat /opt/nuage_vns_tester_server/con.pid`
          killall python
          kill -9 `cat /opt/nuage_vns_tester_server/iperf3.pid`
          echo "."
          rm -f /opt/nuage_vns_tester_server/con.pid /opt/nuage_vns_tester_server/iperf3.pid
          ;;
    status)
          test -f /opt/nuage_vns_tester_server/con.pid > /dev/null
          if [ $? -eq 0 ]; then
             echo "Connectivity services are running."
          else
             echo "Connectivity services are stopped."
          fi

          test -f /opt/nuage_vns_tester_server/iperf3.pid > /dev/null
          if [ $? -eq 0 ]; then
             echo "iperf3 is running."
          else
             echo "iperf3 is stopped."
          fi
          ;;
    *)
          echo "Usage: /opt/nuage_vns_tester_server start|status|stop"
          exit 1
          ;;
    esac
