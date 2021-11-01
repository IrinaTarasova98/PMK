; 2021 ОТИ МИФИ
; Учебная группа 1ПО-48Д
; Дисциплина: Программирование микроконтроллеров
; Микроконтроллер: учебный стенд SDK 1.1

; Задание: при нажатии кнопки *, начиная с середины линейки диодов, загорается по два соседних диода.

$Mod812 ; включаем файл, содержащий символы микроконтроллера
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
; здесь располагаются символы, определяемые программистом

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        LJMP START ; переход на начало программы
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        
        ; здесь располагаются обработчики прерываний
        
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        ORG 80h ; адрес начала программы
START:  ; метка начала программы
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

FRAME_0:	  ; выключить все диоды
		LCALL	SET_DIODE	; запись в регистр указателя адрес регистра светодиодов
		MOV	A, #0		; записать диоды для включения (00000000b)
		MOVX	@DPTR, A	; запись значения из A в регистр светодиодов
		LCALL	DELAY		; время чтобы отпустить клавишу 
		LCALL	KEY_DOWN	; проверка нажатия клавиши
		JNZ 	FRAME_0		; если клавиша не нажата повторить FRAME_0
FRAME_1:	  ; включить ДВА центральных диода
		LCALL	SET_DIODE
		MOV	A, #24
		MOVX	@DPTR, A
		LCALL	DELAY
		LCALL	KEY_DOWN	
		JNZ	FRAME_1	
FRAME_2:  ; включить ЧЕТЫРЕ центральных диода
		LCALL	SET_DIODE
		MOV	A, #60
		MOVX	@DPTR, A
		LCALL	DELAY
		LCALL	KEY_DOWN
		JNZ	FRAME_2
FRAME_3:	 ; включить ШЕСТЬ центральных диодов
		LCALL	SET_DIODE
		MOV	A, #126
		MOVX	@DPTR, A
		LCALL	DELAY
		LCALL	KEY_DOWN
		JNZ	FRAME_3
FRAME_4:  ; включить ВОСЕМЬ центральных диодов
		LCALL	SET_DIODE
		MOV	A, #255
		MOVX	@DPTR, A
		LCALL	DELAY
		LCALL	KEY_DOWN
		JNZ	FRAME_4		; если клавиша не нажата повторить FRAME_4
		JZ	FRAME_0		; иначе перейти к FRAME_0 (в начало)
		RET

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        ;SJMP $ ; замкнутый бесконечный цикл
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ПОДПРОГРАММЫ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

KEY_DOWN:  ; проверка нажатия клавиши * 
		; клавиатура
		MOV	DPL, #0
		MOV 	DPH, #0
		MOV	DPP, #8

		; COL1 (11111110b)
		MOV 	A, #0FEh
		MOVX 	@DPTR, A
		MOVX 	A, @DPTR
		; ROW4 (10000000b)
		ANL 	A,#080h
		RET

SET_DIODE:  ; запись в регистр указателя адрес регистра светодиодов
		MOV	DPL,#7
		MOV	DPH,#0
		MOV	DPP,#8
		RET

DELAY:  ; подпрограмма задержки
		MOV	R3, #20
D8933:
		MOV	R2, #20
D8932:
		MOV	R1, #15
D8931:
		MOV	R0, #15
		DJNZ	R0, $
		DJNZ	R1, D8931
		DJNZ	R2, D8932
		DJNZ	R3, D8933
		RET
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        END ; обязательный признак завершения текста
