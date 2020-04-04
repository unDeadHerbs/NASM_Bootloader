	;; 0x0e in AH sets INT 10H into "Teletype output" mode
	mov ah, 0x0e
	mov al, 'H'
	;; Call Interupt INT 10H
	int 0x10
	mov al, 'e'
	int 0x10
	mov al, 'l'
	int 0x10
	mov al, 'l'
	int 0x10
	mov al, 'o'
	int 0x10
	mov al, ' '
	int 0x10
	mov al, 'W'
	int 0x10
	mov al, 'o'
	int 0x10
	mov al, 'r'
	int 0x10
	mov al, 'l'
	int 0x10
	mov al, 'd'
	int 0x10
	mov al, '!'
	int 0x10

	;; Halt
	jmp $

	;;  Pad to 512 with bootable flag.
	times 510-($-$$) db 0
	dw 0xaa55
