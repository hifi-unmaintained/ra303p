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

; derived from ra95-hires

%define ScreenWidth 0x006016B0
%define ScreenHeight 0x006016B4

str_options: db "Options",0
str_width: db "Width",0
str_height: db "Height",0

; handles Width and Height redalert.ini options
_hires_ini:

    PUSH EBX
    PUSH EDX

.width:
    MOV ECX, 640            ; default
    MOV EDX, str_options    ; section
    MOV EBX, str_width      ; key
    LEA EAX, [EBP-0x54]     ; this
    CALL INIClass_Get_Int
    TEST EAX,EAX
    JE .height
    MOV DWORD [ScreenWidth], EAX

.height:
    MOV ECX, 400
    MOV EDX, str_options
    MOV EBX, str_height
    LEA EAX, [EBP-0x54]
    CALL INIClass_Get_Int
    TEST EAX,EAX
    JE .cleanup
    MOV DWORD [ScreenHeight], EAX

.cleanup:

    MOV EDX, [ScreenWidth]
    MOV EBX, [ScreenHeight]

    MOV DWORD [0x00552629], EBX
    MOV DWORD [0x00552638], EDX

    MOV DWORD [0x00552646], EBX
    MOV DWORD [0x00552655], EDX

    POP EDX
    POP EBX

    JMP 0x00552979
