;;; -*- mode: nasm -*-

	;; Setup Environment

	cli 			; Disable interupts
	jmp 0x0000:ZeroSeg 	; Clear Segment
        ZeroSeg:
	xor ax, ax		; Clear Segment Registers
	mov ss, ax
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	mov sp, init		; Set the stack pointer
	cld			; Read string ltr (usualy default)
	sti			; Renable interupts
	int 0x13		; Reset disk heads

	;; Fancier System Setup
	call fixA20
	call assert_longmode
