all: ra95p

ra95p: ra95.exe code.bin patch
	./patch ra95.exe 2375680 code.bin

code.bin: src/main.asm src/tools.asm src/arguments.asm src/nocd.asm src/max_units_bug.asm src/fence_bug.asm src/tags_bug.asm src/hires.asm
	nasm -isrc/ -f bin -o code.bin src/main.asm

ra95.exe: ra95.dat extpe
	cp ra95.dat ra95.exe
	./extpe ra95.exe 4095

ra95.dat:
	@echo "You are missing the required ra95.dat from 3.03 patch"
	@false

patch: tools/patch.c
	gcc -ansi -pedantic -O2 -Wall -o patch tools/patch.c

extpe: tools/extpe.c tools/extpe.h
	gcc -ansi -pedantic -O2 -Wall -o extpe tools/extpe.c

win32:
	i586-mingw32msvc-gcc -ansi -pedantic -O2 -Wall -o patch.exe tools/patch.c
	i586-mingw32msvc-gcc -ansi -pedantic -O2 -Wall -o extpe.exe tools/extpe.c

clean:
	rm -f code.bin extpe patch extpe.exe patch.exe ra95.exe
