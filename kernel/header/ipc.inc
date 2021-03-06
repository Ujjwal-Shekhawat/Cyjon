;===============================================================================
; Copyright (C) by blackdev.org
;===============================================================================

struc	KERNEL_IPC_STRUCTURE
	.ttl						resb	8
	.pid_source					resb	8
	.pid_destination				resb	8
	.type						resb	1
	.reserved					resb	7
	.data:
	.size						resb	8
	.pointer					resb	8
	.other						resb	32
	.SIZE:
endstruc

KERNEL_IPC_TYPE_KEYBOARD				equ	0x00	; komunikat zawiera dane: klawiatury
KERNEL_IPC_TYPE_MOUSE					equ	0x01	; komunikat zawiera dane: myszka
KERNEL_IPC_TYPE_GRAPHICS				equ	0x02	; komunikat zawiera dane: ekran
KERNEL_IPC_TYPE_INTERNAL				equ	0x03	; komunikat zawiera dane: rodzic <> dziecko/wątek
