; 2021 ��� ����
; ������� ������ 1��-48�
; ����������: ���������������� �����������������
; ���������������: ������� ����� SDK 1.1

; �������: ����� ������ ���������� �������, ������� � �������� ������� ������, ���������� �� ��� �������� �����.

$Mod812 ; �������� ����, ���������� ������� ����������������
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
; ����� ������������� �������, ������������ �������������

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        LJMP START ; ������� �� ������ ���������
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        
        ; ����� ������������� ����������� ����������
        
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        ORG 80h ; ����� ������ ���������
START:  ; ����� ������ ���������
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

		; ������ � ������� ��������� ����� �������� �����������
		MOV		DPL,#7
		MOV		DPH,#0
		MOV		DPP,#8
		
		; �������� ��� ����������� �����
		MOV		A,#24
		; ������ �������� �� A � ������� �����������
		MOVX	@DPTR,A
		; ����� ������������ ��������
		LCALL 	DELAY
		
		; �������� ������ ����������� �����
		MOV		A,#60
		; ������ �������� �� A � ������� �����������
		MOVX	@DPTR,A
		; ����� ������������ ��������
		LCALL 	DELAY
		
		; �������� ����� ����������� ������
		MOV		A,#126
		; ������ �������� �� A � ������� �����������
		MOVX	@DPTR,A
		; ����� ������������ ��������
		LCALL 	DELAY
		
		; �������� ������ ����������� ������
		MOV		A,#255
		; ������ �������� �� A � ������� �����������
		MOVX	@DPTR,A
		; ����� ������������ ��������
		LCALL 	DELAY
		
		; ��������� ��� �����
		MOV		A,#0
		; ������ �������� �� A � ������� �����������
		MOVX	@DPTR,A
		; ����� ������������ ��������
		LCALL 	DELAY
		
		LCALL 	START
		
		; �������� ������������ A
		MOV		A,#0
		MOVX	@DPTR,A
		
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        SJMP $ ; ��������� ����������� ����
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;

        ; XXXXXX - ������������ - XXXXXX ;

; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
; ������������ �������� �� 250000 ���
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
		RET; ������������ ������� ���������� ������������
; XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX ;
        END ; ������������ ������� ���������� ������
