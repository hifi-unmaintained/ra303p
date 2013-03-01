NFLAGS    = -I./include/
NASM     ?= nasm$(EXT)
ORIGINAL  = ra95.dat
PATCHED   = ra95.exe

TOOLS_DIR =./tools

# Copies every time so you do not accidentally patch the executable twice

$(PATCHED): $(TOOLS_DIR)/linker$(EXT) $(ORIGINAL) $(TOOLS_DIR)/extpe$(EXT)
	cp $(ORIGINAL) $(PATCHED)
	$(TOOLS_DIR)/linker$(EXT) src/main.asm src/main.inc $(PATCHED) $(NASM) $(NFLAGS)

$(ORIGINAL):
	@echo "You are missing the required ra95.dat from 3.03 patch"
	@false

clean: clean_tools
	rm -rf $(PATCHED) src/*.map src/*.bin src/*.inc

.PHONY: clean

include ./tools/Makefile
