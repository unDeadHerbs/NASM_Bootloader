;;; -*- mode: nasm -*-

;;; Load from disk
;; Params: al = sector count
;;         cl = sector position
load_disk:
	pusha
	;; INT13H AH=02H
	mov ah, 0x02
	mov dl, 0x80 		; 00 on floppy(flash drive), 80 on hdd(Qemu)
	mov ch, 0x00		; First Cylinder
	mov dh, 0x00		; First head
	;mov al, 0x01		; Sectors to read count
	;mov cl, 0x02		; Sector after boot loader
	mov bx, 0x00
	mov es, bx		; mov an indirect 0
	mov bx, 0x7c00+512	; space after loaded bootsector

	int 0x13		; Call the interupt
	
	jc load_disk_err	; Errors set carry flag
	popa
	ret
load_disk_err:
	mov si, STR_DISK_ERR
	call printf
	jmp $
STR_DISK_ERR:	db "Error loading Disk.",0x0a,0x0d,0
