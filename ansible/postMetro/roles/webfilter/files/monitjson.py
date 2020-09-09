#!/usr/bin/python

import argparse
import BaseHTTPServer
import json
import re
import subprocess

def getStatus():
	ret = {}
	p = subprocess.Popen(["monit", "status"], stdout=subprocess.PIPE)
	(status, _) = p.communicate()

	status = status.split("\n")

	current = None
	for line in status:
		if line == None:
			continue
		header = None
		healthyKey = None
		if line.startswith("Process"):
			header = "process"
			healthyKey = "Running"
		elif line.startswith("File"):
			healthyKey = "Accessible"
			header = "file"
		elif line.startswith("Filesystem"):
			healthyKey = "Accessible"
			header = "filesystem"
		elif line.startswith("System"):
			healthyKey = "Running"
			header = "system"
		elif line.startswith("Program"):
			healthyKey = "Status ok"
			header = "program"

		if header != None:
			vals = line.split(" ")
			name = vals[1].strip("'")
			current = {"hk": healthyKey, "values": {}}
			if header not in ret:
				ret[header] = {}
			ret[header][name] = current
		elif line.startswith("  ") and current != None:
			matches = re.search("  (.*) {2,}(.*)",line)
			key = matches.group(1).strip()
			val = matches.group(2).strip()
			if key=="status":
				current["status"] = "ok" if val == current["hk"] else "fail"
			
			current["values"][key] = val

		
	wholeFail = False
	wholeSuccess = False
	for section in ret:
		fail = False
		success = False
		for service in ret[section]:
			del ret[section][service]["hk"]
			if ret[section][service]["status"] == "ok":
				success = True
				wholeSuccess = True
			else:
				fail = True
				wholeFail = True
		if success and not fail:
			ret[section]["status"] = "ok"
		elif success and fail:
			ret[section]["status"] = "degraded"
		elif not success and fail:
			ret[section]["status"] = "fail"

	if wholeSuccess and not wholeFail:
		ret["status"] = "ok"
	elif wholeSuccess and wholeFail:
		ret["status"] = "degraded"
	elif not wholeSuccess and wholeFail:
		ret["status"] = "fail"

	return ret

def runServer():
	server_class = BaseHTTPServer.HTTPServer
	httpd = server_class(("0.0.0.0", 2813), HttpHandler)
	httpd.serve_forever()

class HttpHandler(BaseHTTPServer.BaseHTTPRequestHandler):
	def do_GET(s):
		s.send_response(200)
		s.send_header("Content-type", "application/json")
		s.end_headers()

		status = getStatus()
		if s.path=="/":
			s.wfile.write(json.dumps(status))
		elif s.path.startswith("/q/"):
			q = s.path.replace("/q/","",1).split("/");
			for word in q:
				print(word);
				status = status[word]
			s.wfile.write(json.dumps(status))
			
			

parser = argparse.ArgumentParser(description='Monit to json.')
parser.add_argument('-d', nargs="?", const=True, dest='server', help='Run as server')

args = parser.parse_args()

if args.server:
	runServer()
else:
	status = getStatus()
	status = json.dumps(status)
	print(status)