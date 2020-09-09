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

"""The module implements the Nuage OF-TLS test server."""
import socket
import ssl
import logging
import signal
import threading
import errno
from server import Server as Server


class TlsServer(Server):
    def __init__(self, port, ip_addr="0.0.0.0"):
        super(TlsServer, self).__init__(port, ip_addr)
        self.cert_path = "/opt/nuage_vns_tester_server/crt/"

    def start(self):
        threads = []
        ip_addr = self.ip_addr
        port = self.port
        self.logger.info("TLS TCP server starting up on %s port %s" % (ip_addr, port))
        sock = socket.socket()
        sock.bind((ip_addr, port))
        sock.listen(100)

        while self.is_running:
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

            self.logger.debug("TLS TCP server connected on %s port %s" % (addr, port))
            thread = threading.Thread(target=self.process_connection, args=(conn, ))
            thread.start()
            threads.append(thread)

        try:
            for thread in threads:
                thread.join()
        except OSError as (code, msg):
            if code != errno.ESRCH:
                self.logger.error("TLS TCP server wating threads return failed with error %s" % msg)
        sock.close()

    def process_connection(self, conn):
        try:
            conn.settimeout(3)
            connstream = ssl.wrap_socket(conn,
                                         server_side=True,
                                         certfile=self.cert_path + "server.crt",
                                         keyfile=self.cert_path + "server.key")
        except ssl.SSLError as err:
            if "The handshake operation timed out" not in "{}".format(err):
                self.logger.error("TLS connection failed on %s port %s with error: %s" % (self.ip_addr, self.port, err))
            conn.close()
            return

        while self.is_running:
            try:
                data = connstream.recv(self.BUFFER_SIZE)
                if not data:
                    break
                self.logger.debug("TLS TCP server received data: %s" % data)
                connstream.send(data)  # echo
            except socket.error as err:
                self.logger.error("TLS TCP send/recv failed on connection %s with error: %s" % (connstream, err))
                break
            except KeyboardInterrupt:
                break
        try:
            connstream.close()
            conn.close()
        except socket.error as (code, msg):
            if code == errno.ENOTCONN:
                self.logger.error("TLS TCP shutdown failed with errono [Errno 107] Transport endpoint is not connected")

    def stop(self):
        self.logger.info("TLS TCP server on %s port %s is stopped." % (self.ip_addr, self.port))
        super(TlsServer, self).stop()


if __name__ == '__main__':
    TlsServer(6633).start()
