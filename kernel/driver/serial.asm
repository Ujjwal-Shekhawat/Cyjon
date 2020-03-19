;===============================================================================
; Copyright (C) by Blackend.dev
;===============================================================================

DRIVER_SERIAL_PORT_COM1				equ	0x03F8
DRIVER_SERIAL_PORT_COM2				equ	0x02F8

struc	DRIVER_SERIAL_STRUCTURE_REGISTERS
	.data_or_divisor_low			resb	1
	.interrupt_enable_or_divisor_high	resb	1
	.interrupt_identification_or_fifo	resb	1
	.line_control_or_dlab			resb	1
	.modem_control				resb	1
	.line_status				resb	1
	.modem_status				resb	1
	.scratch				resb	1
endstruc

;===============================================================================
driver_serial:
	; zachowaj oryginalne rejestry
	push	rax
	push	rdx

	; wyłącz generowanie przerwań
	mov	al,	0x00
	mov	dx,	DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.interrupt_enable_or_divisor_high
	out	dx,	al

	; włącz DLAB (podzielnik częstotliwości)
	mov	al,	0x80
	mov	dx,	DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.line_control_or_dlab
	out	dx,	al

	; częstotliwość 115200
	mov	al,	0x03
	mov	dx,	DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.data_or_divisor_low
	out	dx,	al
	mov	al,	0x00
	mov	dx,	DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.interrupt_enable_or_divisor_high
	out	dx,	al

	; 8 bitów na znak, bez parzystości, 1 bit końca
	mov	al,	0x03
	mov	dx,	DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.line_control_or_dlab
	out	dx,	al

	; włącz FIFO, wyczyść z 14 Bajtowym progiem
	mov	al,	0xC7
	mov	dx,	DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.interrupt_identification_or_fifo
	out	dx,	al

	; przywóć oryginalne rejestry
	pop	rdx
	pop	rax

	; powrót z procedury
	ret

;===============================================================================
; wejście:
;	rbp - wskaźnik do danych zakończony terminatorem
driver_serial_send:
	; zachowaj oryginalne rejestry
	push	rax
	push	rdx
	push	rbp

	; ustaw numer portu
	mov	dx,	DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.data_or_divisor_low

.loop:
	; koniec danych?
	cmp	byte [rbp],	STATIC_ASCII_TERMINATOR
	je	.end	; tak

	; odczekaj na gotowość kontrolera
	call	driver_serial_ready

	; pobierz znak
	mov	al,	byte [rbp]

	; wyślij znak
	out	dx,	al

	; przesuń wskaźnik na następny znak z ciągu
	inc	rbp

	; wyświetl pozostałe dane ciągu
	jmp	.loop

.end:
	; przywróć oryginalne rejestry
	pop	rbp
	pop	rdx
	pop	rax

	; powrót z procedury
	ret


;===============================================================================
driver_serial_ready:
	; zachowaj oryginalne rejestry
	push	rax
	push	rdx

	; ustaw port
	mov	dx,	DRIVER_SERIAL_PORT_COM1 + DRIVER_SERIAL_STRUCTURE_REGISTERS.line_status

.loop:
	; pobierz stan kontrolera
	in	al,	dx

	; bufor pusty?
	test	al,	01100000b
	jz	.loop	; nie

	; przywróć oryginalne rejestry
	pop	rdx
	pop	rax

	; powrót z procedury
	ret
