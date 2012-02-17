PATCHES=patches/main.bin patches/version.bin patches/tags_bug.bin patches/fence_bug.bin patches/arguments.bin patches/nocd_Force_CD_Available.bin patches/nocd_search_type.bin patches/hires.bin
INCLUDES=include/globals.asm include/arguments.asm include/fence_bug.asm include/hires.asm include/max_units_bug.asm include/tags_bug.asm
NASM=nasm
NFLAGS=-I./include/ -I./patches/

all: ra95p

ra95p: ra95.exe $(PATCHES)

ra95.exe: extpe
	cp ra95.dat ra95.exe
	./extpe ra95.exe 4095 > /dev/null

patches/%.bin: patches/%.asm linker $(INCLUDES)
	$(NASM) $(NFLAGS) -f bin -o $@ $< | ./linker ra95.exe > /dev/null

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
	rm -f extpe linker extpe.exe linker.exe ra95.exe patches/*.map patches/*.bin patches/*.inc
