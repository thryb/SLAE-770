#!/usr/bin/python
# 
# Convert port to shellcode format
# Author: thryb
# Date: 15-07-16
# ID: SLAE-770
#

import sys

if len(sys.argv) == 2:
	l_port = int(sys.argv[1])
else:
	print "Usage: %s <port number>" % str(sys.argv[0])
	exit(2)

hex_port = '{0:04X}'.format(l_port)

h1 = hex_port[0:2]
h2 = hex_port[2:4]

print "Net order number: %s\n" % hex_port

print "Replace Local port with: \n\\x%s\\x%s" % (h1, h2) 
