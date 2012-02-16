PATCHES=patches/main.bin patches/version.bin patches/tags_bug.bin patches/fence_bug.bin patches/arguments.bin patches/nocd_Force_CD_Available.bin patches/nocd_search_type.bin patches/hires.bin
SOURCES=include/globals.asm include/arguments.asm
NASM=nasm
NFLAGS=-i./include/

all: ra95p

ra95p: ra95.exe $(PATCHES)

ra95.exe: extpe
	cp ra95.dat ra95.exe
	./extpe ra95.exe 4095

patches/main.bin: patches/main.asm $(SOURCES) linker
	$(NASM) $(NFLAGS) -f bin -o patches/main.bin patches/main.asm
	./linker ra95.exe `grep -iE '\s*\[?\s*ORG' patches/main.asm | sed -E 's/\[?org\s+([^]]+).*/\1/'` patches/main.bin
	fgrep ' _' patches/main.map | sed -r 's/\s*[0-9A-F]+\s+([0-9A-F]+)\s+(.+)/%define \2 0x\1/' > include/main.inc

include/main.inc: patches/main.bin $(SOURCES)

patches/%.bin: patches/%.asm include/main.inc linker
	$(NASM) $(NFLAGS) -f bin -o $@ $<
	./linker ra95.exe `grep -iE '\s*\[?\s*ORG' $< | sed -E 's/\[?org\s+([^]]+).*/\1/'` $@

ra95.dat:
	@echo "You are missing the required ra95.dat from 3.03 patch"
	@false

linker: tools/linker.c
	gcc -m32 -ansi -pedantic -O2 -Wall -o linker tools/linker.c

extpe: tools/extpe.c tools/pe.h
	gcc -m32 -ansi -pedantic -O2 -Wall -o extpe tools/extpe.c

win32:
	i586-mingw32msvc-gcc -ansi -pedantic -O2 -Wall -o linker.exe tools/linker.c
	i586-mingw32msvc-gcc -ansi -pedantic -O2 -Wall -o extpe.exe tools/extpe.c

clean:
	rm -f code.bin extpe linker extpe.exe linker.exe ra95.exe patches/*.map patches/*.bin include/main.inc
