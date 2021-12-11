; 2021 ОТИ МИФИ
; Учебная группа 1ПО-48Д
; Дисциплина: Программирование микроконтроллеров
; Микроконтроллер: учебный стенд SDK 1.1

; кнопка '7'  - устанавливает 	ЧАС = 7
; кнопка '9' - устанавливает	МИНУТА = 9
; (кнопка '0' - обнуляет все значения)

; R0, R1, R2, R3 - используются для задержки
; R4 - регистр записи значения
; R5 - значение для записи
; R6 - ROW кнопки
; R7 - COL кнопки

$Mod812 ; включаем файл, содержащий символы микроконтроллера
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
; здесь располагаются символы, определяемые программистом

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        LJMP START ; переход на начало программы
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; здесь располагаются обработчики прерываний

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        ORG 80h ; адрес начала программы

	SJMP		START

CALWR 		EQU 	0A0h	; байт адреса устройства при записи
CALRD 		EQU 	0A1h	; байт адреса устройства при чтении
I2CACK 		EQU 	0 	; временный хранитель бита acknowledge

START:  ; метка начала программы
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
	; установка начального состояния
	MOV 	I2CCON, #0C8h	; мастер-режим, SCL = 0, SDA = 1
	lCALL 	DELAY1
	LCALL	I2CSTART
	MOV 	A, #CALWR
	LCALL	I2CPUTA
	JC 	ERR
	LCALL 	I2CSTOP
	; выполнить проверку кнопки '7'
BWAIT_KEY7:
	LCALL	DELAY2		; время чтобы отпустить клавишу
	MOV 	R6, #0FEh	; COL 	1111 1110	0FEh
	MOV 	R7, #040h	; ROW 	0000 0001	040h
	LCALL	KEY_DOWN	; проверка нажатия клавиши
	JNZ 	BWAIT_KEY9	; если клавиша не нажата - проверить кнопку '9'
	; если клавиша нажата:
	; записать в календарь значение
	LCALL	I2CSTART
	MOV 	R4, #04h	; регистр записи часов - 04h
	MOV 	R5, #07h	; запись значения - '7 часов'
	LCALL 	CAL_SET 	; поместить значение в каледарь
	LCALL 	I2CSTOP
	; выполнить проверку кнопки '9'
BWAIT_KEY9:
	LCALL	DELAY2			
	MOV 	R6, #0FBh	; COL 	1111 1011	0FBh
	MOV 	R7, #040h	; ROW 	0100 0000	040h
	LCALL	KEY_DOWN		
	JNZ 	BWAIT_KEY0	; если клавиша не нажата - проверить кнопку '0'
	; если клавиша нажата:
	; записать в календарь значение
	LCALL	I2CSTART
	MOV 	R4, #03h	; регистр записи минут - 03h
	MOV 	R5, #09h	; запись значения - '9 минут'
	LCALL 	CAL_SET 	; поместить значение в каледарь
	LCALL 	I2CSTOP		; выполнить проверку кнопки '0'
BWAIT_KEY0:
	LCALL	DELAY2			
	MOV 	R6, #0FDh	; COL 	1111 1101	0FDh
	MOV 	R7, #080h	; ROW 	1000 0000	080h
	LCALL	KEY_DOWN		
	JNZ 	BWAIT_KEY7	; если клавиша не нажата - проверить кнопку '7'
	; если клавиша нажата:
	; очистить значения всех значимых регистров
	LCALL	I2CSTART
	MOV 	R5, #00h	; значение обнуления
	MOV 	R4, #02h	; секунды
	LCALL 	CAL_SET 			
	MOV 	R4, #03h	; минуты
	LCALL 	CAL_SET 			
	MOV 	R4, #04h	; часы
	LCALL 	CAL_SET 			
	MOV 	R4, #05h	; год/дата
	LCALL 	CAL_SET 	
	MOV 	R4, #06h	; день недели/месяц
	LCALL 	CAL_SET
	LCALL 	I2CSTOP 			
	JNZ START
ERR:
	sjmp start
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        ;SJMP $ ; замкнутый бесконечный цикл
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ПОДПРОГРАММЫ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

; ПРОВЕРКА НАЖАТИЯ КНОПКИ

KEY_DOWN:  ; проверка нажатия клавиши
	; подключение к клавиатуре
	MOV	DPL, #0
	MOV 	DPH, #0
	MOV	DPP, #8
	; COL1 - R6
	MOV 	A, R6
	MOVX 	@DPTR, A
	MOVX 	A, @DPTR
	; ROW4 - R7
	ANL 	A, R7
	RET

; ВЫСТАВЛЕНИЕ ЗНАЧЕНИЙ В КАЛЕДАРЬ

CAL_SET:
	LCALL 	I2CSTART
	MOV 	A, #CALWR	; запись адреса устройства
	LCALL 	I2CPUTA		; запись аккумулятора в устройство
	JC 	ERR
	MOV 	A, R4		; обратиться к нужному регистру
	LCALL 	I2CPUTA
	JC 	ERR
	MOV 	A, R5		; выставить значение
	LCALL 	I2CPUTA
	JC 	ERR
	RET

; ПОДПРОГРАММЫ ДЛЯ РАБОТЫ С КАЛЕНДАРЕМ

I2CSTART: ; последовательность "старт"
	SETB	MDO		; SDA = 1
	LCALL	DELAY1
	SETB	MCO 		; SCL = 1
	LCALL 	DELAY1
	CLR	MDO 		; SDA = 0
	LCALL 	DELAY1
	CLR 	MCO		; SCL = 0
	LCALL	DELAY1
	RET

I2CSTOP: ; последовательность "стоп"
	CLR 	MDO		; SDA = 0
	LCALL 	DELAY1
	SETB	MCO		; SCL = 1
	LCALL 	DELAY1
	SETB	MDO		; SDA = 1
	LCALL 	DELAY1
	CLR 	MCO 		; SCL = 0
	LCALL 	DELAY1
	RET

I2CPUTA: ; запись аккумулятора в устройство
	MOV 	R6, #8
I2CPUTA1:
	RLC	A		; сдвигаем старший бит в CY
	MOV 	MDO, C 		; SDA = передвигаемый бит
	LCALL 	DELAY1
	SETB 	MCO 		; SCL = 1
	LCALL 	DELAY1
	CLR	 MCO		; SCL = 0
	LCALL 	DELAY1
	DJNZ 	R6, I2CPUTA1
	; получить подтверждение
	CLR	 MDE
	LCALL 	DELAY1
	SETB 	MCO 		; SCL = 1
	LCALL 	DELAY1
	MOV 	C, MDI		; чтение SDA
	MOV 	I2CACK, C
	LCALL 	DELAY1
	CLR 	MCO		; SCL = 0
	LCALL 	DELAY1
	SETB 	MDE
	MOV 	C, I2CACK
	RET

; ЗАДЕРЖКИ

DELAY1:  ; подпрограмма задержки 6 мкс
	MOV	R0, #1
	DJNZ	R0, $
	RET

DELAY2:  ; подпрограмма задержки 30 мкс
	MOV     R3, #20
D1133:
	MOV     R2, #20
D1132:
	MOV     R1, #10
D1131:
	MOV     R0, #10
	DJNZ    R0, $
	DJNZ    R1, D1131
	DJNZ    R2, D1132
	DJNZ    R3, D1133
	RET
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        END ; обязательный признак завершения текста
