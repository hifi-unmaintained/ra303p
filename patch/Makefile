NFLAGS    = -I $(patchdir)/ -I $(patchdir)/include/
NASM     ?= nasm$(EXT)

patchdir ?= .

Red_Alert: $(GameEXE) prep_patch

prep_patch: $(patcherdir)/linker$(EXT)
	$(patcherdir)/linker$(EXT) $(patchdir)/src/main.asm              $(patchdir)/src/main.inc              $(GameEXE) $(NASM) $(NFLAGS)
	$(patcherdir)/linker$(EXT) $(patchdir)/src/nocd_search_type.asm  $(patchdir)/src/nocd_search_type.inc  $(GameEXE) $(NASM) $(NFLAGS)
	$(patcherdir)/linker$(EXT) $(patchdir)/src/version.asm           $(patchdir)/src/version.inc           $(GameEXE) $(NASM) $(NFLAGS)

$(GameEXE): $(GameDAT) $(patcherdir)/extpe$(EXT)
	cp $(GameDAT) $(GameEXE)
	$(patcherdir)/extpe$(EXT) $(GameEXE)

$(GameDAT):
	@echo "You are missing the required ra95.dat from 3.03 patch"
	@false

clean: cleantools
	rm -rf $(GameEXE) $(patchdir)/src/*.map $(patchdir)/src/*.bin $(patchdir)/src/*.inc

patcherdir ?= ../patcher
include $(patcherdir)/Makefile