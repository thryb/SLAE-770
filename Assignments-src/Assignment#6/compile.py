#!/usr/bin/python
#
# Linux x86
# Author:  thryb
# Date:    19-07-16
# Purpose: Dirty asm to C & compile
# ID:      SLAE-770
# Git:	   https://www.github.com/thryb/SLAE-770
#

import sys, os

if len(sys.argv) == 2:
	file_name = str(sys.argv[1])
else:
	print "Usage: %s <filename.asm>" % str(sys.argv[0])
	exit(2)
 
if file_name[-4:] == ".asm":
	file_name = file_name[:-4]

	print " *** Assembling %s." % file_name
	os.system("nasm -g -f elf32 -o " + file_name + ".o " + file_name + ".asm")

	print " *** Linking %s. " % file_name
	os.system("ld -N -o " + file_name + ".bin " + file_name + ".o")

	print " *** Extracting shellcode."
	# modded to not relay on cut field
	shellcode = os.popen("for i in `objdump -d ./" + file_name + ".bin | tr '\t' ' ' " \
	"| tr ' ' '\n' | egrep '^[0-9a-f]{2}$' `; do echo -n \"\\x$i\" ; done | paste -d '' -s "
	"| sed 's/^/\"/' | sed 's/$/\"/g'").read()

	print " *** Building C file."
	cfile = open('shell.c', "w")
	cfile.write("/* This file has been autogenerated. */\n\n")
	cfile.write("#include<stdio.h>\n#include<string.h>\nunsigned char code[] = \\\n")
	cfile.write(shellcode + ";")
	cfile.write("int main()\n{")
        cfile.write("printf(\"Shellcode Length:  %d\\n\", strlen(code));\n")
	cfile.write("int (*ret)() = (int(*)())code;ret();}")
        cfile.close()

	print " *** Compiling shellcode."
	os.system("gcc -g -z execstack -fno-stack-protector shell.c -o " + file_name)
	
	print " *** Done ^_^"
else:
	print "Usage: %s <filename.asm>" % str(sys.argv[0])