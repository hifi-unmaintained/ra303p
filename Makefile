NASM?=nasm
NFLAGS?=-I./include/ -I./patches/
EXT?=
CP?=cp
NULL?=/dev/null
RM?=rm -f
CC?=gcc
CFLAGS?=-m32 -ansi -pedantic -O2 -Wall

PATCHES=patches/main.bin patches/version.bin patches/tags_bug.bin patches/fence_bug.bin \
        patches/arguments.bin patches/nocd_Force_CD_Available.bin patches/nocd_search_type.bin \
        patches/Is_Aftermath_Installed.bin patches/Is_Counterstrike_Installed.bin \
        patches/hires.bin patches/hires_MainMenu.bin patches/hires_MainMenuClear.bin \
        patches/hires_MainMenuClearPalette.bin patches/hires_Intro.bin \
        patches/hires_NewGameText.bin patches/hires_SkirmishMenu.bin \
        patches/hires_StripClass.bin
INCLUDES=include/globals.asm include/arguments.asm include/fence_bug.asm include/hires.asm include/max_units_bug.asm include/tags_bug.asm

all: ra95.exe $(PATCHES)

tools: linker$(EXT) extpe$(EXT)

ra95.exe: extpe$(EXT)
	$(CP) ra95.dat ra95.exe
	./extpe$(EXT) ra95.exe

patches/%.bin: patches/%.asm linker$(EXT) $(INCLUDES)
	$(NASM) $(NFLAGS) -f bin -o $@ $< | ./linker$(EXT) ra95.exe > $(NULL)

ra95.dat:
	@echo "You are missing the required ra95.dat from 3.03 patch"
	@false

linker$(EXT): tools/linker.c
	$(CC) $(CFLAGS) -o linker$(EXT) tools/linker.c

extpe$(EXT): tools/extpe.c tools/pe.h
	$(CC) $(CFLAGS) -o extpe$(EXT) tools/extpe.c

clean:
	$(RM) extpe$(EXT) linker$(EXT) ra95.exe patches/*.map patches/*.bin patches/*.inc
