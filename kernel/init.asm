;===============================================================================
; Copyright (C) by Blackend.dev
;===============================================================================

	;-----------------------------------------------------------------------
	; wszystkie procedury inicjalizacyjne zostały zaprojektowane z myślą
	; o trybie 64 bitowym procesora, do tej pory Cyjon nie był kompatybilny
	; z programem rozruchowym GRUB, zatem aby tą kompatybilność uzyskać
	; najniższym kosztem, przełączam od razu procesor w tryb 64 bitowy
	;
	; program rozruchowy "Zero" zwraca już taki sam nagłówek Multiboot
	; oraz przekazuje procesor w trybie 32 bitowym do jądra systemu
	;
	; kod który przełącza procesor w tryb 64 bitowy, został zapożyczony
	; z programu rozruchowego "Zero" (bez modyfikacji)
	;-----------------------------------------------------------------------

	;-----------------------------------------------------------------------
	; przełącz procesor w tryb 64 bitowy
	;-----------------------------------------------------------------------
	%include	"kernel/init/long_mode.asm"

	;-----------------------------------------------------------------------
	; domyślny komunikat błędu
	;-----------------------------------------------------------------------
	%include	"kernel/init/panic.asm"

	;-----------------------------------------------------------------------
	; zmienne - wykorzystywane podczas inicjalizacji środowiska jądra systemu
	;-----------------------------------------------------------------------
	%include	"kernel/init/data.asm"
	;-----------------------------------------------------------------------

	;-----------------------------------------------------------------------
	; multiboot - nagłówek dla programu rozruchowego GRUB
	;-----------------------------------------------------------------------
	%include	"kernel/init/multiboot.asm"

;===============================================================================
; 64 bitowy kod jądra systemu ==================================================
;===============================================================================
[BITS 64]

kernel_init_long_mode:
	;-----------------------------------------------------------------------
	; inicjalizacja przestrzeni trybu tekstowego
	;-----------------------------------------------------------------------
	%include	"kernel/init/video.asm"

	;-----------------------------------------------------------------------
	; utworzenie binarnej mapy pamięci i oznaczenie w niej jądra systemu
	;-----------------------------------------------------------------------
	%include	"kernel/init/memory.asm"

	;-----------------------------------------------------------------------
	; przetworzenie tablic ACPI
	;-----------------------------------------------------------------------
	%include	"kernel/init/acpi.asm"

	;-----------------------------------------------------------------------
	; utwórz stronicowanie docelowe jądra systemu
	;-----------------------------------------------------------------------
	%include	"kernel/init/page.asm"

	;-----------------------------------------------------------------------
	; utwórz Globalną Tablicę Deskryptorów
	;-----------------------------------------------------------------------
	%include	"kernel/init/gdt.asm"

	;-----------------------------------------------------------------------
	; utwórz Tablicę Deskryptorów Przerwań
	;-----------------------------------------------------------------------
	%include	"kernel/init/idt.asm"

	;-----------------------------------------------------------------------
	; konfiguruj zegar czasu rzeczywistego - uptime systemu
	;-----------------------------------------------------------------------
	%include	"kernel/init/rtc.asm"

	;-----------------------------------------------------------------------
	; utwórz kolejkę zada
	;-----------------------------------------------------------------------
	%include	"kernel/init/task.asm"
