;;; -*- mode: nasm -*-

mov si, STR_HELLO
	call printstr
	jmp $
STR_HELLO:	db "Hello, world!",0x0a,0x0d,0
