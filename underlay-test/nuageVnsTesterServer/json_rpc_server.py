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

"""The module implements the Nuage JSON RPC test server."""
import errno
import logging
from werkzeug.wrappers import Request, Response
from werkzeug.serving import run_simple

from jsonrpc import JSONRPCResponseManager, dispatcher
from server import Server as Server


@dispatcher.add_method
def foobar(**kwargs):
    return kwargs["foo"] + kwargs["bar"]


@Request.application
def application(request):
    # Dispatcher is dictionary {<method_name>: callable}
    dispatcher["echo"] = lambda s: s
    # dispatcher["add"] = lambda a, b: a + b

    response = JSONRPCResponseManager.handle(
        request.data, dispatcher)
    return Response(response.json, mimetype='application/json')


class JsonRpcServer(Server):
    def __init__(self, port, ip_addr="0.0.0.0"):
        super(JsonRpcServer, self).__init__(port, ip_addr)

    def start(self):
        self.logger.info("JSON RPC server starting up on %s port %s" % (self.ip_addr, self.port))
        try:
            _logger = logging.getLogger('werkzeug')
            _logger.setLevel(logging.ERROR)
            run_simple(self.ip_addr, self.port, application, threaded=True)
        except OSError as (code, msg):
            if code != errno.ESRCH:
                self.logger.error("JSON RPC server run_simple failed with exception %s." % msg)
            else:
                self.stop()
        except KeyboardInterrupt:
            self.logger.error("JSON RPC server is interrupted.")
        except Exception as e:
            self.logger.error("JSON RPC server run_simple failed with exception %s." % e)

    def stop(self):
        self.logger.info("JSON RPC server on %s port %s is stopped." % (self.ip_addr, self.port))
        super(JsonRpcServer, self).stop()

if __name__ == '__main__':
    JsonRpcServer(7407).start()
