all: ra95p

ra95p: ra95.exe code.bin tools/patch
	./tools/patch ra95.exe 2375680 code.bin

code.bin: src/main.asm src/tools.asm src/arguments.asm src/nocd.asm src/max_units_bug.asm src/fence_bug.asm src/tags_bug.asm src/hires.asm
	nasm -isrc/ -f bin -o code.bin src/main.asm

ra95.exe: ra95.dat tools/modpe
	cp ra95.dat ra95.exe
	./tools/modpe ra95.exe 4095

ra95.dat:
	@echo "You are missing the required ra95.dat from 3.03 patch"
	@false

tools/patch: tools/patch.c
	gcc -ansi -pedantic -O2 -Wall -o tools/patch tools/patch.c

tools/modpe: tools/modpe.c tools/modpe.h
	gcc -ansi -pedantic -O2 -Wall -o tools/modpe tools/modpe.c

clean:
	rm -f code.bin tools/modpe tools/patch ra95.exe
