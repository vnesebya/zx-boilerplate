	DEVICE zxspectrum128

	ORG #6000
start
	di:					; запрещаем прерывания
	ld sp,$-2			; ставим вершину стека на два байта меньше ORG по тому что
	xor a
	out (#fe), a
	ld hl,#4000 
	ld de,#4001
	ld bc,#1800
	ld (hl),l
	ldir
	ld bc,#02ff
	ld (hl),#47
	ldir
	ldi
	ld a,#5c
	ld i,a
	ld hl,interr
	ld (#5cff),hl
	im 2
	ei


main_loop
	; Выводим в порт #FE белую полоску
1	halt
	call start_delay
	ld a,6				; 7 тактов
	out (#fe), a		; 11 тактов
	call main_delay		; 17 тактов + delay_loop 177 тактов == 194 такта
	nop: nop

	ld a,0				; 7 тактов
	out (#fe), a		; 11 тактов
	call main_delay		; 17 тактов + delay_loop 177 тактов == 194 такта
	nop: nop

	in a,(#fe)
	; and 31
	; ld r,a
	out (#fe),a



	; Выводим в порт #FE красную полоску 
    ld a,6			; 7 тактов
	out (#fe), a		; 11 тактов
	call main_delay		; 17 тактов	+ delay_loop 177 тактов == 194 такта
	jr main_loop  	    ; 12 тактов


start_delay				; 17 тактов вызов CALL
	ld bc,478			; 10 тактов
.loop				    ; Локальная метка не затрагивает такую-же ниже
	dec bc				; 6
	ld a,b				; 4
	or c				; 4
	jr nz,.loop			; 12 + 7
	; ld r,a				; 9
	; ld b ,0				;
	ret					; 10 тактов


main_delay
	ld b,12				; 7 тактов
.loop
	djnz .loop 	     	; 13 тактов если не 0, 8 если ноль == 151 такт
	ld r,a				; 9	команда не важна, нам нодо сожрать 9 тактов
	ret					; 10 тактов


interr	di
	push af,bc,de,hl,ix,iy
	exx : ex af, af'
	push af,bc,de,hl,ix,iy
	ifdef _DEBUG_BORDER : ld a, #01 : out (#fe), a : endif ; debug

	ifdef _DEBUG_BORDER : xor a : out (#fe), a : endif ; debug
	pop iy,ix,hl,de,bc,af
	exx : ex af, af'
	pop iy,ix,hl,de,bc,af
	ei
	ret

	display 'PAGE0 end: ', $

	display /d, 'Total bytes used: ', $ - start

	; build
	if (_ERRORS == 0 && _WARNINGS == 0)
	  savesna SNA_FILENAME, start			; SNA_FILENAME defined in Makefile
	  savebin BIN_FILENAME, start, $-start 	; BIN_FILENAME defined in Makefile
	  labelslist "user.l"
	endif
