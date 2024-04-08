.PHONY: clean

CC="gcc"
LD="ld"
AS="nasm"
ASFLAGS="-f elf64"
CFLAGS="-Wall"

main: main.o diamond.o
	$(LD) $^ -o $@

test: test.c diamond.o
	$(CC) $(CFLAGS) $^ -o $@

main.o: main.asm
	$(AS) $(ASFLAGS) $<

diamond.o: diamond.asm
	$(AS) $(ASFLAGS) $<

clean:
	rm -f *.o main test
