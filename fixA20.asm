;;; -*- mode: nasm -*-

;;; This is only a probabilistic test.
;; https://wiki.osdev.org/A20_Line
;;  Return: CF <- A20 is Enabled
fixA20_testA20enabled:
	pusha

	mov ax,[0x7DFE] 	; The boot magic number position

	mov bx,0xffff
	mov es,bx
	mov bx,0x7DFE+0x0010
	mov dx,[es:bx] 		; 0x17DFE is the same position if A20 is disabled
	cmp ax,dx
	je fixA20_t_cont
fixA20_t_en_true:
	popa
	stc
	ret
fixA20_t_cont:
	mov bx,fixA20_testA20enabled+0x0010 ; Again with second test position
	mov ax,[fixA20_testA20enabled]
	mov dx,[es:bx]
	cmp ax,dx
	jne fixA20_t_en_true
fixA20_t_en_false:
	popa
	clc
	ret
	

fixA20:
	pusha
	;; If already ok, done
	call fixA20_testA20enabled
	jc fixA20_done

	;;  Ask the BIOS nicely
	mov ax, 0x2401
	int 15
	;; Check
	call fixA20_testA20enabled
	jc fixA20_done

	;; Ask the Keyboard Controller
	mov al, 1
	call Keyboard_Set_Flag
	;; Check
	call fixA20_testA20enabled
	jc fixA20_done

	;; Fast A20 (Might Reboot System)
	in al,0x92
	or al,1<<1
	out 0x92,al
	;; Check
	call fixA20_testA20enabled
	jc fixA20_done

fixA20_fail:
	mov si,STR_A20_FAIL
	call printerr
	jmp $
STR_A20_FAIL:	db "Enabling A20",0
fixA20_done:
	popa
	ret


Keyboard_Set_Flag:
	pusha
	mov cl,al
	cli
	call Wait_Keyboard_Con
	mov al,0xad 		; Disable keyboard
	out 0x64, al
	call Wait_Keyboard_Con
	mov al, 0xd0		; Read
	out 0x64,al
	call Wait_Keyboard_Dat
	in al, 0x60		; Do the Read
	push ax
	call Wait_Keyboard_Con
	mov al, 0xd1		; Write
	out 0x64,al
	call Wait_Keyboard_Con
	pop ax			; Do the Write with flag
	mov bx,0x01
	shr bx,cl
	or ax, bx
	out 0x60,al
	call Wait_Keyboard_Con
	mov al, 0xae		; Enable Keyboard
	out 0x64,al
	popa
	ret
	
Wait_Keyboard_Con:
	in al, 0x64
	test al, 1<<1
	jnz Wait_Keyboard_Con
	ret

Wait_Keyboard_Dat:
	in al, 0x64
	test al, 1<<0
	jz Wait_Keyboard_Dat
	ret
