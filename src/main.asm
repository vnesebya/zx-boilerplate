    device	zxspectrum48
	org	#6000
start
    ld a,0
loop
    ld  l,a
    ld  h,0 
	ld	de,#4000	;; some loaded and
	ld	bc,#1800	;; executed code
    ldir
    add 32

    jp c,start
    jp loop
codend

	; build
	if (_ERRORS == 0 && _WARNINGS == 0)
        page 0
        include "./include/BasicLib/BasicLoader.asm"
        savetap TAP_FILENAME, CODE, "code0", start, codend-start
        savetrd TRD_FILENAME, "code0.C" , start , codend-start
        savesna SNA_FILENAME, start
        savebin BIN_FILENAME, start, codend-start
        labelslist USERL_FILENAME
	endif
