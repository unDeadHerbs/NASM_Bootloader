;;; -*- mode: nasm -*-
[org 0x7c00]
[bits 16]

;;; Both of these are blank as they are out of sector
section .text
	global init

init:
%include "setup_env_inline.asm"

	;; Load the second sector
	mov al, 0x01		; Read one sector
	mov cl, 0x02		; Starting after boot loader
	call load_disk
	jmp kernel

%include "printstr.asm"
%include "load_disk.asm"
%include "fixA20.asm"
%include "longmode.asm"
%include "kernel_utils.asm"
	
;;; Pad to sector size with 2 bytes of bootsector magic
	times 0x200-($-$$)-2 db 0
	dw 0xaa55

kernel:
%include "kernel.asm"

;;; Fill out the sector so load_disk doesn't fail
	;; Note, this will throw when sector 2 is too big.
	times 2*0x200-($-$$) hlt
