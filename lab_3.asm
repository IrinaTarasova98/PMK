; 2021 ОТИ МИФИ
; Учебная группа 1ПО-48Д
; Дисциплина: Программирование микроконтроллеров
; Микроконтроллер: учебный стенд SDK 1.1

; Задание: Кадр меняется при нажатии * (звездочки); номер очередного кадра отображается на дисплее (в нижнем ряду по середине).

; R0, R1, R2, R3 - используются для задержки
; R4 - счетчик места в строке
; R5 - количество итераций (кадров)

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

LEDS: 		DB 0h, 18h, 03Ch, 07Eh, 0FFh 	; значения для линейки диодов
NUMBERS:	DB '01234'						; значения для дисплея

START:  ; метка начала программы
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
		MOV 	R4, #0 			; позиция в строке
		MOV 	R5, #5 			; число итераций
DLOOP: ; выполнять очередной кадр пока не нажата клавиша
		MOV		A, #0C7h 		; начать запись с 7 места второй строки
		LCALL 	CDISP
		MOV 	DPTR, #LEDS 	; получить список значений для линейки диодов
		MOV 	A, R4 			; записать номер значения
		MOVC 	A, @A+DPTR  	; записать очередное значение для линейки диодов
		LCALL	SET_DIODE	
		MOV 	DPTR, #NUMBERS 	; получить список значений для дисплея
		MOV 	A, R4			; записать номер значения
		MOVC 	A, @A+DPTR		; записать очередное значение для дисплея
		LCALL 	DISPA
BWAIT: ; выполнять проверку пока не нажата клавиша
		LCALL	DELAY2			; время чтобы отпустить клавишу 
		LCALL	KEY_DOWN		; проверка нажатия клавиши
		JNZ 		BWAIT		; если клавиша не нажата - ждать (вернуться к метке BWAIT)
		INC 		R4 			; прибавить единицу к индексу значения 
		DJNZ 	R5, DLOOP 		; если число итераций не равно нулю - начать новый кадр
		SJMP		START 		; иначе начать программу заново
		RET
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        ;SJMP $ ; замкнутый бесконечный цикл
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ПОДПРОГРАММЫ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

DISPA: ; вывод символа
		MOV		DPP, #8
		MOV		DPH, #0
		MOV		DPL, #1
		; запись значения в регистр данных
		MOVX	@DPTR, A
		LCALL	DELAY1
		; смена состояния регистра E
		MOV		DPL, #6
		MOV		A, #0Dh
		MOVX	@DPTR, A
		LCALL	DELAY1
		; запись в регистр управления 
		MOV		A, #0Ch
		MOVX 	@DPTR, A
		LCALL	DELAY1
		RET
	
CDISP: ; запись команд
		MOV		DPP, #8
		MOV		DPH, #0
		MOV		DPL, #1
		; запись значения в регистр данных
		MOVX	@DPTR, A
		LCALL	DELAY2
		; смена состояния регистра E
		MOV		DPL, #6
		MOV		A, #9
		MOVX	@DPTR, A
		LCALL	DELAY2
		; запись в регистр управления 
		MOV		A, #8
		MOVX 	@DPTR, A
		LCALL	DELAY2
		RET

KEY_DOWN:  ; проверка нажатия клавиши * 
		; клавиатура
		MOV		DPL, #0
		MOV 	DPH, #0
		MOV		DPP, #8
		; COL1 (11111110b)
		MOV 	A, #0FEh
		MOVX 	@DPTR, A
		MOVX 	A, @DPTR
		; ROW4 (10000000b)
		ANL 	A,#080h
		RET

SET_DIODE:  ; запись значения линейки светодиодов
		MOV		DPL,#7
		MOV		DPH,#0
		MOV		DPP,#8
		; запись значения из A в регистр светодиодов
		MOVX	@DPTR, A 
		LCALL	DELAY1
		RET

DELAY1:  ; подпрограмма задержки 70 мс
   		MOV		R1, #10
D2131:
		MOV		R0, #10
		DJNZ	R0, $
		DJNZ	R1, D2131
		RET

DELAY2:  ; подпрограмма задержки 30 мс
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
