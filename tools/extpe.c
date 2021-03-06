/*
 * Copyright (c) 2012 Toni Spets <toni.spets@iki.fi>
 *
 * Permission to use, copy, modify, and distribute this software for any
 * purpose with or without fee is hereby granted, provided that the above
 * copyright notice and this permission notice appear in all copies.
 *
 * THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
 * WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
 * MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
 * ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
 * WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
 * ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
 * OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
 */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "pe.h"

unsigned long bytealign(unsigned long raw, unsigned long align)
{
    return ((raw / align) + (raw % align > 0)) * align;
}

int main(int argc, char **argv)
{
    FILE *fh;
    unsigned char *data;
    unsigned int bytes = 0x1000;
    long length;
    int i;
    unsigned int address = 0;
    unsigned int flags = 0;
    char *name = NULL;

    PIMAGE_DOS_HEADER dos_hdr;
    PIMAGE_NT_HEADERS nt_hdr;
    PIMAGE_SECTION_HEADER sct_hdr;

    if (argc < 5)
    {
        fprintf(stderr, "extpe for ra303p git~%s (c) 2012 Toni Spets\n\n", REV);
        fprintf(stderr, "usage: %s <executable> <section name> <flags: rwxciu> <size>\n", argv[0]);
        return 1;
    }

    name = argv[2];

    if (strlen(name) > 8)
    {
        fprintf(stderr, "Error: section name over 8 characters.\n");
        return 1;
    }

    for (i = 0; i < strlen(argv[3]); i++)
    {
        switch (argv[3][i])
        {
            case 'r': flags |= IMAGE_SCN_MEM_READ;                  break;
            case 'w': flags |= IMAGE_SCN_MEM_WRITE;                 break;
            case 'x': flags |= IMAGE_SCN_MEM_EXECUTE;               break;
            case 'c': flags |= IMAGE_SCN_CNT_CODE;                  break;
            case 'i': flags |= IMAGE_SCN_CNT_INITIALIZED_DATA;      break;
            case 'u': flags |= IMAGE_SCN_CNT_UNINITIALIZED_DATA;    break;
        }
    }

    bytes = abs(atoi(argv[4]));

    fh = fopen(argv[1], "rb+");
    if (!fh)
    {
        perror("Error opening executable");
        return 1;
    }

    fseek(fh, 0L, SEEK_END);
    length = ftell(fh);
    rewind(fh);

    data = malloc(length);

    if (fread(data, length, 1, fh) != 1)
    {
        fclose(fh);
        perror("Error reading executable");
        return 1;
    }

    rewind(fh);

    dos_hdr = (void *)data;
    nt_hdr = (void *)(data + dos_hdr->e_lfanew);
    sct_hdr = IMAGE_FIRST_SECTION(nt_hdr);

    printf("   section    start      end   length    vaddr  flags\n");
    printf("-----------------------------------------------------\n");

    nt_hdr->FileHeader.NumberOfSections++;

    for (i = 0; i < nt_hdr->FileHeader.NumberOfSections; i++)
    {
        if (i == nt_hdr->FileHeader.NumberOfSections - 1)
        {
            /* for once, strncpy is useful */
            strncpy((char *)sct_hdr->Name, name, 8);
            sct_hdr->Misc.VirtualSize = bytes;
            sct_hdr->VirtualAddress = address;
            sct_hdr->SizeOfRawData = bytealign(bytes, nt_hdr->OptionalHeader.FileAlignment);
            sct_hdr->PointerToRawData = flags & IMAGE_SCN_CNT_UNINITIALIZED_DATA ? 0 : length;
            sct_hdr->Characteristics = flags;

            /* for expanding the image file */
            bytes = sct_hdr->SizeOfRawData;

            if (flags & IMAGE_SCN_CNT_CODE)
                nt_hdr->OptionalHeader.SizeOfCode               += sct_hdr->SizeOfRawData;

            if (flags & IMAGE_SCN_CNT_INITIALIZED_DATA)
                nt_hdr->OptionalHeader.SizeOfInitializedData    += sct_hdr->SizeOfRawData;

            if (flags & IMAGE_SCN_CNT_UNINITIALIZED_DATA)
                nt_hdr->OptionalHeader.SizeOfUninitializedData  += sct_hdr->SizeOfRawData;

            nt_hdr->OptionalHeader.SizeOfImage  = bytealign(sct_hdr->VirtualAddress +  sct_hdr->SizeOfRawData, nt_hdr->OptionalHeader.SectionAlignment);
            nt_hdr->OptionalHeader.CheckSum     = 0x00000000;
        } else
        {
            if (sct_hdr->VirtualAddress >= address)
            {
                address = sct_hdr->VirtualAddress + bytealign(sct_hdr->Misc.VirtualSize ? sct_hdr->Misc.VirtualSize : sct_hdr->SizeOfRawData, nt_hdr->OptionalHeader.SectionAlignment);
            }
        }

        printf("%10.8s %8d %8d %8d %8X %s%s%s%s%s%s %s\n",
                sct_hdr->Name,
                sct_hdr->PointerToRawData,
                sct_hdr->PointerToRawData + sct_hdr->SizeOfRawData,
                sct_hdr->SizeOfRawData ? sct_hdr->SizeOfRawData : sct_hdr->Misc.VirtualSize,
                sct_hdr->VirtualAddress + nt_hdr->OptionalHeader.ImageBase,
                sct_hdr->Characteristics & IMAGE_SCN_MEM_READ               ? "r" : "-",
                sct_hdr->Characteristics & IMAGE_SCN_MEM_WRITE              ? "w" : "-",
                sct_hdr->Characteristics & IMAGE_SCN_MEM_EXECUTE            ? "x" : "-",
                sct_hdr->Characteristics & IMAGE_SCN_CNT_CODE               ? "c" : "-",
                sct_hdr->Characteristics & IMAGE_SCN_CNT_INITIALIZED_DATA   ? "i" : "-",
                sct_hdr->Characteristics & IMAGE_SCN_CNT_UNINITIALIZED_DATA ? "u" : "-",
                i == nt_hdr->FileHeader.NumberOfSections - 1        ? "<- you are here" : ""
        );

        sct_hdr++;
    }

    fwrite(data, length, 1, fh);
    free(data);

    /* only expand image if real data */
    if (!(flags & IMAGE_SCN_CNT_UNINITIALIZED_DATA))
    {
        data = calloc(1, bytes);
        fwrite(data, bytes, 1, fh);
        free(data);
    }

    fclose(fh);

    return 0;
}
