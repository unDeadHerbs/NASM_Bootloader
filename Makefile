
DEPDIR := .deps
SRCS   := $(wildcard *.asm)

%.bin: %.asm
%.bin: %.asm $(DEPDIR)/%.d | $(DEPDIR)
	nasm -M $< | head -1 | sed 's,\([^ ]*\),\1.bin,' > $(DEPDIR)/$*.d
	nasm -fbin $< -o $@

.PHONY: %.run
%.run: %.bin
	qemu-system-x86_64 -curses $^ &
	sleep 5 && pkill qemu
%.watch: $(SRCS)
	while true; do inotifywait $^; sleep 1; make $*.run; done

# Maybe needed later if working on virtualbox
%.bin.1200k: %.bin
	cp $^ $@
	truncate $@ -s 1200k
%.iso: %.bin.1200k
	mkisofs -o $@ -b $^ ./

# Track Dependencies
$(DEPDIR): ; @mkdir -p $@

DEPFILES := $(SRCS:%.asm=$(DEPDIR)/%.d)
$(DEPFILES): $(DEPDIR)

include $(wildcard $(DEPFILES))
