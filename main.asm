;;; -*- mode: nasm -*-
[org 0x7c00]

init:
	mov si, STR_HELLO
	call printf
	mov al, 0x01		; Read one sector
	mov cl, 0x02		; Starting after boot loader
	call load_disk
	call qnd_sector
	jmp halt
halt:
	jmp $

%include "strings.asm"

;;; Load from disk
;; Params: al = sector count
;;         cl = sector position
%include "load_disk.asm"

;;; Print string function
;; Params: si = null terminated string pointer
%include "printf.asm"

;;; Pad to 510 with 2 bytes of bootsector magic
	times 510-($-$$) db 0
	dw 0xaa55






;;; Now in second sector
qnd_sector:
	mov si, STR_QND
	call printf
	ret
STR_QND: db "Second Sector String",0x0a,0x0d,0
;;; fill out the sector
	;; Ignore the jank
	times 512-($-$$-512) db 0
