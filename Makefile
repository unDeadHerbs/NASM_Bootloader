DEPDIR := .deps
SRCS   := $(wildcard *.asm)

all: bootloader.bin

%.bin: %.asm
%.bin: %.asm $(DEPDIR)/%.d | $(DEPDIR)
	nasm -M $< -o $@ > $(DEPDIR)/$*.d
	nasm -fbin $< -o $@

%.obj: %.c
	gcc -fno-asynchronous-unwind-tables -s -c $^ -o $@
%.asm: %.obj
	objconv -fnasm $^ $@
	sed -i -e 's/align=1//g' $@
	sed -i -e 's/[a-z]*execute//g' $@
	sed -i -e 's/: *funciton//g' $@
	sed -i -e '/sefault *rel/d' $@

.PHONY: %.run
%.run: %.bin
	qemu-system-x86_64 -display curses $^ &
	sleep 5 && pkill qemu
.PHONY: %.watch
%.watch: $(SRCS)
	while true; do inotifywait $^; sleep 1; make $*.run; done
.PHONY: IDE
IDE: bootloader.watch

# Maybe needed later if working on virtualbox
%.bin.1200k: %.bin
	cp $^ $@
	truncate $@ -s 1200k
%.iso: %.bin.1200k
	mkisofs -o $@ -b $^ ./

clean:
	-rm -f *.obj
	-rm bootloader.bin

# Track Dependencies
$(DEPDIR): ; @mkdir -p $@

DEPFILES := $(SRCS:%.asm=$(DEPDIR)/%.d)
$(DEPFILES): $(DEPDIR)

include $(wildcard $(DEPFILES))
