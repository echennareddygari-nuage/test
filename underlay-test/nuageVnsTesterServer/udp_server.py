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

"""The module implements the Nuage UDP test server."""
import socket
import signal
import logging
import errno
from server import Server as Server


class UdpServer(Server):

    def __init__(self, port, ip_addr="0.0.0.0"):
        super(UdpServer, self).__init__(port, ip_addr)

    def start(self):
        ip_addr = self.ip_addr
        port = self.port
        sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
        self.logger.info("UDP server starting up on %s port %s" % (ip_addr, port))
        sock.bind((ip_addr, port))

        while self.is_running:
            try:
                data, address = sock.recvfrom(self.BUFFER_SIZE)
            except socket.error as (code, msg):
                if code != errno.EINTR:
                    self.logger.error("UDP socket recvfrom error with %s" % msg)
                else:
                    self.stop()
                    break
            except KeyboardInterrupt:
                self.stop()
                break

            self.logger.debug("UDP server received %s bytes from %s" % (len(data), address))

            if data:
                sent = sock.sendto(data, address)
                self.logger.debug("UDP server sent %s bytes back to %s" % (sent, address))
        sock.close()

    def stop(self):
        self.logger.info("UDP server on %s port %s is stopped." % (self.ip_addr, self.port))
        super(UdpServer, self).stop()

if __name__ == '__main__':
    UdpServer(4500).start()
