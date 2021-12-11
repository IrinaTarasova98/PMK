; 2021 ��� ����
; ������� ������ 1��-48�
; ����������: ���������������� �����������������
; ���������������: ������� ����� SDK 1.1

; ������ '7'  - ������������� 	��� = 7
; ������ '9' - �������������	������ = 9
; (������ '0' - �������� ��� ��������)

; R0, R1, R2, R3 - ������������ ��� ��������
; R4 - ������� ������ ��������
; R5 - �������� ��� ������
; R6 - ROW ������
; R7 - COL ������

$Mod812 ; �������� ����, ���������� ������� ����������������
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
; ����� ������������� �������, ������������ �������������

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        LJMP START ; ������� �� ������ ���������
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; ����� ������������� ����������� ����������

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        ORG 80h ; ����� ������ ���������

	SJMP		START

CALWR 		EQU 	0A0h	; ���� ������ ���������� ��� ������
CALRD 		EQU 	0A1h	; ���� ������ ���������� ��� ������
I2CACK 		EQU 	0 	; ��������� ��������� ���� acknowledge

START:  ; ����� ������ ���������
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
	; ��������� ���������� ���������
	MOV 	I2CCON, #0C8h	; ������-�����, SCL = 0, SDA = 1
	lCALL 	DELAY1
	LCALL	I2CSTART
	MOV 	A, #CALWR
	LCALL	I2CPUTA
	JC 	ERR
	LCALL 	I2CSTOP
	; ��������� �������� ������ '7'
BWAIT_KEY7:
	LCALL	DELAY2		; ����� ����� ��������� �������
	MOV 	R6, #0FEh		; COL 	1111 1110	0FEh
	MOV 	R7, #040h		; ROW 	0000 0001	040h
	LCALL	KEY_DOWN	; �������� ������� �������
	JNZ 	BWAIT_KEY9	; ���� ������� �� ������ - ��������� ������ '9'
	; ���� ������� ������:
	; �������� � ��������� ��������
	LCALL	I2CSTART
	MOV 	R4, #04h		; ������� ������ ����� - 04h
	MOV 	R5, #07h		; ������ �������� - '7 �����'
	LCALL 	CAL_SET 		; ��������� �������� � ��������
	LCALL 	I2CSTOP
	; ��������� �������� ������ '9'
BWAIT_KEY9:
	LCALL	DELAY2			
	MOV 	R6, #0FBh		; COL 	1111 1011	0FBh
	MOV 	R7, #040h		; ROW 	0100 0000	040h
	LCALL	KEY_DOWN		
	JNZ 	BWAIT_KEY0	; ���� ������� �� ������ - ��������� ������ '0'
	; ���� ������� ������:
	; �������� � ��������� ��������
	LCALL	I2CSTART
	MOV 	R4, #03h		; ������� ������ ����� - 03h
	MOV 	R5, #09h		; ������ �������� - '9 �����'
	LCALL 	CAL_SET 		; ��������� �������� � ��������
	LCALL 	I2CSTOP
	; ��������� �������� ������ '0'
BWAIT_KEY0:
	LCALL	DELAY2			
	MOV 	R6, #0FDh		; COL 	1111 1101	0FDh
	MOV 	R7, #080h		; ROW 	1000 0000	080h
	LCALL	KEY_DOWN		
	JNZ 	BWAIT_KEY7	; ���� ������� �� ������ - ��������� ������ '7'
	; ���� ������� ������:
	; �������� �������� ���� �������� ���������
	LCALL	I2CSTART
	MOV 	R5, #00h		; �������� ���������
	MOV 	R4, #02h		; �������
	LCALL 	CAL_SET 			
	MOV 	R4, #03h		; ������
	LCALL 	CAL_SET 			
	MOV 	R4, #04h		; ����
	LCALL 	CAL_SET 			
	MOV 	R4, #05h		; ���/����
	LCALL 	CAL_SET 	
	MOV 	R4, #06h		; ���� ������/�����
	LCALL 	CAL_SET
	LCALL 	I2CSTOP 			
	JNZ START
ERR:
		sjmp start
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        ;SJMP $ ; ��������� ����������� ����
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ������������ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

; �������� ������� ������

KEY_DOWN:  ; �������� ������� �������
	; ����������� � ����������
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

; ����������� �������� � ��������

CAL_SET:
	LCALL 	I2CSTART
	MOV 	A, #CALWR	; ������ ������ ����������
	LCALL 	I2CPUTA		; ������ ������������ � ����������
	JC 	ERR
	MOV 	A, R4		; ���������� � ������� ��������
	LCALL 	I2CPUTA
	JC 	ERR
	MOV 	A, R5		; ��������� ��������
	LCALL 	I2CPUTA
	JC 	ERR
	RET

; ������������ ��� ������ � ����������

I2CSTART: ; ������������������ "�����"
	SETB	MDO		; SDA = 1
	LCALL	DELAY1
	SETB	MCO 		; SCL = 1
	LCALL 	DELAY1
	CLR	MDO 		; SDA = 0
	LCALL 	DELAY1
	CLR 	MCO		; SCL = 0
	LCALL	DELAY1
	RET

I2CSTOP: ; ������������������ "����"
	CLR 	MDO		; SDA = 0
	LCALL 	DELAY1
	SETB	MCO		; SCL = 1
	LCALL 	DELAY1
	SETB	MDO		; SDA = 1
	LCALL 	DELAY1
	CLR 	MCO 		; SCL = 0
	LCALL 	DELAY1
	RET

I2CPUTA: ; ������ ������������ � ����������
	MOV 	R6, #8
I2CPUTA1:
	RLC	A		; �������� ������� ��� � CY
	MOV 	MDO, C 		; SDA = ������������� ���
	LCALL 	DELAY1
	SETB 	MCO 		; SCL = 1
	LCALL 	DELAY1
	CLR	 MCO		; SCL = 0
	LCALL 	DELAY1
	DJNZ 	R6, I2CPUTA1
	; �������� �������������
	CLR	 MDE
	LCALL 	DELAY1
	SETB 	MCO 		; SCL = 1
	LCALL 	DELAY1
	MOV 	C, MDI		; ������ SDA
	MOV 	I2CACK, C
	LCALL 	DELAY1
	CLR 	MCO		; SCL = 0
	LCALL 	DELAY1
	SETB 	MDE
	MOV 	C, I2CACK
	RET

; ��������

DELAY1:  ; ������������ �������� 6 ���
	MOV	R0, #1
	DJNZ	R0, $
	RET

DELAY2:  ; ������������ �������� 30 ���
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
        END ; ������������ ������� ���������� ������
