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

"""The module implements the Nuage TCP test server."""
import socket
import logging
import signal
import threading
import errno
from server import Server as Server


class TcpServer(Server):
    def __init__(self, port, ip_addr="0.0.0.0"):
        super(TcpServer, self).__init__(port, ip_addr)

    def start(self):
        threads = []
        ip_addr = self.ip_addr
        port = self.port
        self.logger.info("TCP server starting up on %s port %s" % (ip_addr, port))
        sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        sock.bind((ip_addr, port))
        sock.listen(100)

        while self.is_running:
            conn = None
            try:
                conn, addr = sock.accept()
            except socket.error as (code, msg):
                if code != errno.EINTR:
                    self.logger.error("TCP socket accept error with %s" % msg)
                else:
                    self.stop()
                    break
            except KeyboardInterrupt:
                self.stop()
                break
            finally:
                # Win7 will reply the ACK automaticly, that will cause connection be created successful.
                # Just close the socket
                if conn is not None:
                    conn.close()

        sock.close()

    def stop(self):
        self.logger.info("TCP server on %s port %s is stopped." % (self.ip_addr, self.port))
        super(TcpServer, self).stop()

if __name__ == '__main__':
    TcpServer(11443).start()
