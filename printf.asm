;;; -*- mode: nasm -*-

;;; Print string function
;; Params: si = null terminated string pointer
printf:
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

