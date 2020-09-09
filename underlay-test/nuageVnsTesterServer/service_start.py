# Copyright 2014 Alcatel-Lucent USA Inc.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.

"""The module starts the Nuage VNS test servers."""
import logging
import multiprocessing
import signal
import os
import errno

from json_rpc_server import JsonRpcServer as json_rpc_server
from tcp_server import TcpServer as tcp_server
from udp_server import UdpServer as udp_server
from tls_server import TlsServer as tls_server


SERVICES = {
    "6633": tls_server(6633),
    "7407": json_rpc_server(7407),
    "53": udp_server(53),
    "500": udp_server(500),
    "4789": udp_server(4789),
    "4500": udp_server(4500),
    "123": udp_server(123),
    "50000": udp_server(50000),
    "50001": udp_server(50001),
    "50002": udp_server(50002),
    "50003": udp_server(50003),
    "11443": tcp_server(11443),
    "12443": tcp_server(12443),
    "39090": tcp_server(39090),
    "179": tcp_server(179),
    "48179": tcp_server(48179),
}

log_level = logging.INFO
log_file = "/opt/nuage_vns_tester_server/log"
logging.basicConfig(filename=log_file, format='%(asctime)s %(filename)s:%(lineno)d %(levelname)s %(message)s', level=log_level)
logger = logging.getLogger(__name__)
processes = []
json_rpc_process_pid = 0


def exit_gracefully(signum, frame):
    for process in processes:
        logger.debug("Sending signal %s to process %s" % (signum, process.pid))
        os.kill(process.pid, signum)
    #os.kill(json_rpc_process_pid, 9)

def write_pid():
    pid = str(os.getpid())
    f = open('/opt/nuage_vns_tester_server/con.pid', 'w+')
    f.write(pid)
    f.close()


def main():
    signal.signal(signal.SIGINT, exit_gracefully)
    signal.signal(signal.SIGTERM, exit_gracefully)
    write_pid()

    try:
        for port in SERVICES:
            logger.info("Starting service of port %s" % port)
            process = multiprocessing.Process(target=SERVICES[port].start, args=())
            process.start()
            processes.append(process)
            if(port == "7407"):
                global json_rpc_process_pid
                json_rpc_process_pid = process.pid

        for process in processes:
            process.join()
    except OSError as (code, msg):
        if code == errno.ESRCH:
            return
    except Exception as e:
        logger.error("Start threads failed with exception %s" % e)
    finally:
        pass


if __name__ == '__main__':
    main()
