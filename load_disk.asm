;;; -*- mode: nasm -*-

;;; Load from disk
;; Params: al = sector count
;;         cl = sector position
load_disk:
	pusha
	mov ch, 0x00		; First Cylinder
	mov dx, 0x00		; dh=0, First head
	mov es, dx		; mov an indirect 0
	mov dl, 0x80 		; 0x00 on floppy, 0x80 on hdd
	mov bx, 0x7c00+512	; space after loaded bootsector
	;; INT13H AH=02H - Read from Disk
	mov ah, 0x02
	int 0x13
	
	jc load_disk_err	; Errors set carry flag
	popa
	ret
load_disk_err:
	mov si, STR_DISK_ERR
	call printerr
	jmp $
STR_DISK_ERR:	db "Reading Disk",0
