NFLAGS=-I./include/
CC?=gcc
CFLAGS=-m32 -ansi -pedantic -O2 -Wall
DAT=ra95.dat
EXE=ra95.exe

all: ra95.exe build

tools: linker$(EXT) hooker$(EXT) extpe$(EXT)

ra95.exe: $(DAT) extpe$(EXT)
	cp $(DAT) $(EXE)
	./extpe$(EXT) $(EXE)

build: linker$(EXT) hooker$(EXT)
	nasm $(NFLAGS) -f bin -o src/main.bin src/main.asm | ./linker$(EXT) $(EXE) > /dev/null
	nasm $(NFLAGS) -f bin -o src/nocd_search_type.bin src/nocd_search_type.asm | ./linker$(EXT) $(EXE) > /dev/null
	nasm $(NFLAGS) -f bin -o src/version.bin src/version.asm | ./linker$(EXT) $(EXE) > /dev/null
	nasm $(NFLAGS) -f bin -o src/hooks.bin src/hooks.asm
	./hooker$(EXT) src/hooks.bin $(EXE)

$(DAT):
	@echo "You are missing the required ra95.dat from 3.03 patch"
	@false

linker$(EXT): tools/linker.c
	$(CC) $(CFLAGS) -o linker$(EXT) tools/linker.c

hooker$(EXT): tools/hooker.c
	$(CC) $(CFLAGS) -o hooker$(EXT) tools/hooker.c

extpe$(EXT): tools/extpe.c tools/pe.h
	$(CC) $(CFLAGS) -o extpe$(EXT) tools/extpe.c

clean:
	rm -rf extpe$(EXT) linker$(EXT) hooker$(EXT) $(EXE) src/*.map src/*.bin src/*.inc
