	module basic

	include	"./BasicLib.asm"

	device	ZXSPECTRUM48
	org	23755

line_useval = 1   ; Заменяем использование 5-и байтных чисел на VAL "1234" 

TapLoader
	LINE :  db clear : NUM start-1   							: LEND
    LINE :  db load, '"code0"', code : NUM start 				: LEND
    LINE :  db rand, usr : NUM start 							: LEND

	emptytap TAP_FILENAME
	savetap  TAP_FILENAME , BASIC , "basic" , TapLoader , $-TapLoader , 10

	org	23755

TrdLoader
	LINE :  db clear : NUM start-1  							: LEND
    LINE :  db rand, usr : NUM 15619
			db ':', rem, ':', load, '"code0"', code : NUM start	: LEND 
    LINE :  db rand, usr : NUM start 							: LEND

	emptytrd TRD_FILENAME
	savetrd  TRD_FILENAME, "boot.B", TrdLoader, $-TrdLoader , 10

	endmodule