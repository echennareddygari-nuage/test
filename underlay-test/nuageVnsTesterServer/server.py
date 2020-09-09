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

"""The module implements super class of nuage vns test server."""
import logging
import signal


class Server(object):

    def __init__(self, port, ip_addr="0.0.0.0"):
        self.log_level = logging.INFO
        self.log_file = "/opt/nuage_vns_tester_server/log"
        logging.basicConfig(filename=self.log_file, format='%(asctime)s %(filename)s:%(lineno)d %(levelname)s %(message)s', level=self.log_level)
        self.logger = logging.getLogger(__name__)
        self.is_running = True
        self.BUFFER_SIZE = 10240
        self.ip_addr = ip_addr
        self.port = port

    def start(self, port, ip_addr):
        pass

    def stop(self):
        self.is_running = False
