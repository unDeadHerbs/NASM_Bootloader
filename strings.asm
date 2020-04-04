;;; -*- mode: nasm -*-
;;; String table
;; 0x0a is carrage return
;; 0x0d is new line	
STR_HELLO:	db "Hello, world!",0x0a,0x0d,0
STR_DISK_ERR:	db "Error loading Disk.",0x0a,0x0d,0
