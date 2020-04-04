
%.bin: %.asm
	nasm -fbin $^ -o $@

.PHONY: %.run
%.run: %.bin
	qemu-system-x86_64 -curses $^ &
	sleep 5 && pkill qemu
%.watch: %.asm
	while true; do inotifywait $^; sleep 1; make $*.run; done

# Maybe needed later if working on virtualbox
%.bin.1200k: %.bin
	cp $^ $@
	truncate $@ -s 1200k
%.iso: %.bin.1200k
	mkisofs -o $@ -b $^ ./
