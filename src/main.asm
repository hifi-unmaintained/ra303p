;
; Copyright (c) 2012 Toni Spets <toni.spets@iki.fi>
;
; Permission to use, copy, modify, and distribute this software for any
; purpose with or without fee is hereby granted, provided that the above
; copyright notice and this permission notice appear in all copies.
;
; THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
; WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
; MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
; ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
; WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
; ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
; OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.
;

[org 0x00710000]
[bits 32]

PUSHA

MOV DWORD [0x00589976],version

%include "tools.asm"

; bug fixes
%include "max_units_bug.asm"
%include "fence_bug.asm"
%include "tags_bug.asm"

; extra
%include "arguments.asm"
%include "nocd.asm"
%include "hires.asm"

POPA

MOV DWORD [0x006EC9B0], 0x00551A70
JMP 0x005DE558; real module entry point

version: db "3.03p3 A2 ",0
