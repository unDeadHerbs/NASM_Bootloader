;;; -*- mode: nasm -*-

;; https://wiki.osdev.org/Setting_Up_Long_Mode#Detection_of_CPUID
assert_longmode:
	pusha

	;; check that longmode works
	pushfd
	pop eax
	mov ecx,eax
	xor eax, 1<<21
	push eax
	popfd
	pushfd
	pop eax
	xor eax,ecx
	jz long_mode_fail

	;; Ask CUPID if extended modes exist
	mov eax, 0x80000000
	cpuid
	cmp eax, 1<<31+1
	jb long_mode_fail

	;; Ask CPUID extended if longmode works
	mov eax, 0x80000001
	cpuid
	test edx,1<<29
	jz long_mode_fail

	popa
	ret
long_mode_fail:
	mov si, STR_NO_LM
	call printerr
	jmp $
STR_NO_LM:	db "Longmode Missing",0
