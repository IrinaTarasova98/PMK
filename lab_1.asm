; 2021 ОТИ МИФИ
; Учебная группа 1ПО-48Д
; Дисциплина: Программирование микроконтроллеров
; Микроконтроллер: учебный стенд SDK 1.1

; Задание: через равные промежутки веремни, начиная с середины линейки диодов, загорается по два соседних диода.

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

		; запись в регистр указателя адрес регистра светодиодов
		MOV	DPL,#7
		MOV	DPH,#0
		MOV	DPP,#8
		
		; включить ДВА центральных диода
		MOV	A,#24
		; запись значения из A в регистр светодиодов
		MOVX	@DPTR,A
		; вызыв подпрограммы задержки
		LCALL 	DELAY
		
		; включить ЧЕТЫРЕ центральных диода
		MOV	A,#60
		; запись значения из A в регистр светодиодов
		MOVX	@DPTR,A
		; вызыв подпрограммы задержки
		LCALL 	DELAY
		
		; включить ШЕСТЬ центральных диодов
		MOV	A,#126
		; запись значения из A в регистр светодиодов
		MOVX	@DPTR,A
		; вызыв подпрограммы задержки
		LCALL 	DELAY
		
		; включить ВОСЕМЬ центральных диодов
		MOV	A,#255
		; запись значения из A в регистр светодиодов
		MOVX	@DPTR,A
		; вызыв подпрограммы задержки
		LCALL 	DELAY
		
		; выключить все диоды
		MOV	A,#0
		; запись значения из A в регистр светодиодов
		MOVX	@DPTR,A
		; вызыв подпрограммы задержки
		LCALL 	DELAY
		
		LCALL 	START
		
		; очищение аккумулятора A
		MOV	A,#0
		MOVX	@DPTR,A
		
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        SJMP $ ; замкнутый бесконечный цикл
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ПОДПРОГРАММЫ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
; подпрограмма задержки на 250000 мкс
DELAY:
		MOV     R3, #50 ;6
D8933:
		MOV     R2, #50
D8932:
		MOV     R1, #50
D8931:
		MOV     R0, #50
		DJNZ    R0, $
		DJNZ    R1, D8931
		DJNZ    R2, D8932
		DJNZ    R3, D8933
		RET; обязательный признак завершения подпрограммы
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        END ; обязательный признак завершения текста
