;;; -*- mode: nasm -*-
[org 0x7c00]
[bits 16]

;;; Both of these are blank as they are out of sector
section .data
	;; Constants
section .bss
	;; Mutable Variables

section .text
	global init

init:
	cli 			; Disable interupts
	jmp 0x0000:ZeroSeg
        ZeroSeg:
	xor ax, ax		; Smol mov ax, 0
	mov ss, ax		; Clear segement values
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov sp, init		; Set the stack pointer
	cld			; Read string ltr (usualy default)
	sti			; Renable interupts

	push ax 		; Reset disk heads
	xor ax,ax
	int 0x13
	pop ax

	; fix A20 line on a real system
	; https://wiki.osdev.org/A20_Line
	; Currently don't care because on Qemu this isn't a problem.

	; also detect/setup long mode
	; https://wiki.osdev.org/Setting_Up_Long_Mode#Detection_of_CPUID
	; Again, don't care while using Qemu.

	mov si, STR_HELLO
	call printf
	mov al, 0x01		; Read one sector
	mov cl, 0x02		; Starting after boot loader
	call load_disk
	call qnd_sector
	mov dx,[0x7c00+510]
	call printh
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

;;; Print Hex number
;;  Params: dx = Number to print
%include "printh.asm"

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
