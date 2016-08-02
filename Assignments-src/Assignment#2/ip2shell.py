#!/usr/bin/python
#
# Linux x86
# Author:  thryb
# Date:    21-07-16
# Purpose: Convert IP address to shellcode format
# ID:      SLAE-770
# Git:     https://www.github.com/thryb/SLAE-770
#

import sys
import socket
import struct

if len(sys.argv) == 2:
        ip = str(sys.argv[1])
else:
        print "Usage: %s <ip address>" % str(sys.argv[0])
        exit(2)

def ip2long(ip):
    packedIP = socket.inet_aton(ip)
    return struct.unpack("!L", packedIP)[0]

long = ip2long(ip)

hex_ip = '{0:04X}'.format(long)

j = iter(hex_ip)

hex = '\\x'.join(a+b for a,b in zip(j, j))
hex = '\\x' + hex

print "Replace hex IP format with: %s" % hex.lower()
