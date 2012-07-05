CC             ?= gcc
CFLAGS_patcher  = -m32 -pedantic -O2 -Wall

patcherdir     ?= .

tools: $(patcherdir)/linker$(EXT) $(patcherdir)/extpe$(EXT)

$(patcherdir)/linker$(EXT): $(patcherdir)/linker.c
	$(CC) $(CFLAGS_patcher) -o $(patcherdir)/linker$(EXT) $(patcherdir)/linker.c

$(patcherdir)/extpe$(EXT): $(patcherdir)/extpe.c $(patcherdir)/pe.h
	$(CC) $(CFLAGS_patcher) -o $(patcherdir)/extpe$(EXT)  $(patcherdir)/extpe.c
	
cleantools:
	rm -rf $(patcherdir)/linker$(EXT) $(patcherdir)/extpe$(EXT)