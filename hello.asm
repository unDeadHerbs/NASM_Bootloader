[org 0x7c00]

init:
	mov si, STR
	call printstr
halt:
	jmp $

;;; String literal with null
STR:	db "Hello, world!",0

;;; Print string function
printstr:
	pusha
	;; 0x0e in AH sets INT 10H into "Teletype output" mode
	mov ah,0x0e
str_loop:
	mov al, [si]
	cmp al, 0
	jne print_char
str_end:
	popa
	ret
print_char:
	;; Call Interupt INT 10H
	int 0x10
	add si, 1
	jmp str_loop

;;; Padd to 510 with bootsector magic
	times 510-($-$$) db 0
	dw 0xaa55
