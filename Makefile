
%.bin: %.asm
	nasm -fbin $^ -o $@

.PHONY: %.run
%.run: %.bin
	qemu-system-x86_64 -curses $^ &
	sleep 5 && pkill qemu
