.include "tn2313def.inc"   ; ���������� ATtiny2313
;= Start macro.inc ========================================
 
; ��� ����� ���� �������, �����. 
 
;= End macro.inc  ========================================
 
 
; RAM =====================================================
		.DSEG			; ������� ���

		Variables:	.byte	3
		Variavles2:	.byte	1
 
; FLASH ===================================================
		.CSEG			; ������� �������

		LDI R16,Low(RAMEND)	; ������������� �����
		OUT SPL,R16
 
		LDI	R17,0	; �������� ��������
		LDI	R18,1
		LDI	R19,2
		LDI	R20,3
		LDI	R21,4
		LDI	R22,5
		LDI	R23,6
		LDI	R24,7
		LDI	R25,8
		LDI	R26,9
 
		PUSH	R17		; ���������� �������� � ����
		PUSH	R18
		PUSH	R19
		PUSH	R20
		PUSH	R21
		PUSH	R22
		PUSH	R23
		PUSH	R24
		PUSH	R25
		PUSH	R26
 
 
		POP	R0	; ������� �������� �� �����
		POP	R1
		POP	R2
		POP	R3
		POP	R4
		POP	R5
		POP	R6
		POP	R7
		POP	R8
		POP	R9

 
; EEPROM ==================================================
		.ESEG			; ������� EEPROM
