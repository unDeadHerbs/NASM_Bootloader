;;; -*- mode: nasm -*-

;;; Print Hex number
;;  Params: dx = Number to print
printh:
	pusha
	mov si, STR_HEX_PATTERN

	;; Copy each nybble into the pattern
	mov bx, dx
	shr bx, 3*4
	;and bx, 0x0F
	mov bx,[STR_HEX_TABLE+bx]
	mov [STR_HEX_PATTERN+2] , bl

	mov bx, dx
	shr bx, 2*4
	and bx, 0x0F
	mov bx,[STR_HEX_TABLE+bx]
	mov [STR_HEX_PATTERN+3] , bl

	mov bx, dx
	shr bx, 1*4
	and bx, 0x0F
	mov bx,[STR_HEX_TABLE+bx]
	mov [STR_HEX_PATTERN+4] , bl

	mov bx, dx
	;shr bx, 0*4
	and bx, 0x0F
	mov bx,[STR_HEX_TABLE+bx]
	mov [STR_HEX_PATTERN+5] , bl
	
	call printf
	mov si, STR_NEW_LINE
	call printf
	popa
	ret


;	;; Make a loop
;	mov cx, 3
;printh_loop:
;	mov bx, dx
;	shr dx, 0x4
;	and bx, 0x0F		
;	mov bx,[STR_HEX_TABLE+bx]
;	mov [STR_HEX_DIGS+cx] , bl
;	sub cx,1
;	jne printh_loop
;	popa
;	ret


	
STR_HEX_PATTERN:	db "0x"
STR_HEX_DIGS:	db "****",0
STR_HEX_TABLE:	db"0123456789ABCDEF"
STR_NEW_LINE:	db 0x0a,0x0d,0
