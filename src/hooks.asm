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

%include "config.inc"
%include "src/main.inc"

%macro HOOK 2
    db 0        ; hook
    dd %1       ; org
    dd %2       ; dst
%endmacro

%macro PAD 3
    db 1        ; memset
    dd %1       ; start address
    db %2       ; data
    dd (%3 - %1); bytes
%endmacro

%macro PHOOK 3
    db 1        ; memset
    dd %1       ; start address
    db 0x90     ; data
    dd %2       ; bytes

    db 0        ; hook
    dd %1       ; org
    dd %3       ; dst
%endmacro

HOOK 0x004F5B38, _arguments
HOOK 0x004AC024, _Is_Aftermath_Installed
HOOK 0x004ABF88, _Is_Counterstrike_Installed

%ifdef USE_NOCD
HOOK 0x004AAC58, _Force_CD_Available
HOOK 0x004F7A08, _Init_CDROM_Access
%endif

%ifdef USE_EXCEPTIONS
HOOK 0x005DE636, _try_WinMain
%endif

%ifdef USE_BUGFIXES
HOOK 0x004A0219, _fence_bug
%endif

%ifdef USE_HIRES
HOOK 0x00552974, _hires_ini
HOOK 0x004A9EA9, _hires_Intro
HOOK 0x005B3DBF, _hires_MainMenu
HOOK 0x004F479B, _hires_MainMenuClear
HOOK 0x004F75FB, _hires_MainMenuClearPalette
HOOK 0x005518A3, _hires_NewGameText
HOOK 0x005128D4, _hires_SkirmishMenu
HOOK 0x0054D009, _hires_StripClass
HOOK 0x004BE388, _NewMissions_Handle_Hires_Buttons_A
HOOK 0x004BE3B2, _NewMissions_Handle_Hires_Buttons_B
HOOK 0x004BE3E6, _NewMissions_Handle_Hires_List
%endif
