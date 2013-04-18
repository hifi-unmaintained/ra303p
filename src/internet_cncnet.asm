;
; Copyright (c) 2013 Toni Spets <toni.spets@iki.fi>
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

; Internet button in the main menu goes to cncnet.org instead of WOL

%define SessionClass_Session    0x0067F2B4
%define ShellExecuteA           0x005E653C
%define ShowWindow              0x005E6884
%define pHWnd                   0x006B1498
%define SW_MINIMIZE             6

str_cncnet_org db "http://cncnet.org/", 0
str_dot db ".", 0

@JMP 0x004F4D7E Internet_Action

Internet_Action:

    PUSH SW_MINIMIZE
    MOV EAX, [pHWnd]
    PUSH EAX
    CALL DWORD [ShowWindow]

    PUSH 5
    PUSH str_dot
    PUSH 0
    PUSH str_cncnet_org
    PUSH 0
    PUSH 0
    CALL DWORD [ShellExecuteA]

    MOV BYTE [SessionClass_Session], 0
    JMP 0x004F467B
