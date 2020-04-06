;;; -*- mode: nasm -*-

;;; Print string function
;; Params: si = null terminated string pointer
printstr:
	pusha
	;; INT10h AH=0Eh - Teletype Output
	mov ah,0x0e
str_loop:
	mov al, [si]
	cmp al, 0
	je str_end
	;; Call Interupt INT 10H
	int 0x10
	add si, 1
	jmp str_loop
str_end:
	popa
	ret

;;; Print an Error String
;;  Params: si (Destructive) Null Term String
printerr:
	pusha
	mov si, STR_ERR_BEGIN
	call printstr
	popa
	call printstr
	mov si, STR_ERR_END
	call printstr
	ret
STR_ERR_BEGIN: db "ERR: ",0
STR_ERR_END: db 0x0a,0x0d,0
