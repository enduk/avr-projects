.include "tn2313def.inc"   	; ���������� ATtiny2313

.include "..\macro\tinymacro.inc"		; ���������� �������
 
 
; RAM ==========================================================
		.DSEG			; ������� ���

	CCNT:	.byte	4
	TCNT:	.byte	4

; END RAM ======================================================


; FLASH ========================================================
		.CSEG			; ������� �������

	; ������� �������� �����������

		 .ORG $0000        
         RJMP   Reset	  ;  (RESET) 

         .ORG INT0addr
         RETI             ; (INT0) External Interrupt Request 0

         .ORG INT1addr
         RETI             ; (INT1) External Interrupt Request 1

         .ORG ICP1addr
         RETI		      ; (TIMER1) CAPTTimer/Counter1 Capture Event

         .ORG OC1Aaddr
         RETI             ; (TIMER1) COMPATimer/Counter1 Compare Match A

		 .ORG OVF1addr
         RETI             ; (TIMER1) OVFTimer/Counter1 Overflow

		 .ORG OVF0addr
         RJMP TIM0_OVF	  ; (TIMER0) OVFTimer/Counter0 Overflow

		 .ORG URXCaddr
         RETI		      ; (USART0, RX�) USART0, Rx Complete

		 .ORG UDREaddr
         RETI             ; (USART0, UDRE) USART Data Register Empty

		 .ORG UTXCaddr
         RETI             ; (USART0, TXUSART0) USART, Tx Complete

		 .ORG ACIaddr
         RETI             ; (ANA_COMP) ANALOG COMPAnalog Comparator

		 .ORG PCIaddr
         RETI             ; PCINTPin Change Interrupt

		 .ORG OC1Baddr
         RETI             ; (TIMER1) COMPBTimer/Counter1 Compare Match B

		 .ORG OC0Aaddr
         RETI             ; (TIMER0) COMPATimer/Counter0 Compare Match A

		 .ORG OC0Baddr
         RETI             ; (TIMER0) COMPBTimer/Counter0 Compare Match B

		 .ORG USI_STARTaddr
         RETI             ; (USI) STARTUSI Start Condition

		 .ORG USI_OVFaddr
         RETI             ; (USI) OVERFLOWUSI Overflow

		 .ORG ERDYaddr
         RETI             ; EE READYEEPROM Ready

		 .ORG WDTaddr
         RETI             ; WDT OVERFLOWWatchdog Timer Overflow
 
	 	.ORG   INT_VECTORS_SIZE      	; ����� ������� ����������


; Interrupts ===================================================
	
	TIM0_OVF:	PUSHF			; ��������� SREG � R16 � ����, �.�. � �������� ��������� ��� ������������

				PUSH	R17		; ��������� � ���� r17-r19, ���� �� ������ �� �������� ���������
				PUSH	R18
				PUSH	R19
 
				INCM	TCNT	; ��������� �������� TCNT
 
				POP	R19			; ������� �� �����, ����� ������� �� ����������, ��������������� ��������� ��������� �� ����������
				POP	R18
				POP	R17
				POPF			; ��������������� ��������� �������� SREG
 
				RETI

; End Interrupts ===============================================


; Initialisation / ������������� ===============================
.include "coreinit.inc"   ; ���������� ���� � ����� �������������


; Internal Hardware Init  ======================================

	; ��������� ����� ����� D �� ����� (��� ��������)
	SETB	DDRD,2,R16	; DDRD.2 = 1
	SETB	DDRD,3,R16	; DDRD.3 = 1
	;SETB	DDRD,5,R16	; DDRD.5 = 1

	; ������������� ����, �� ������� ������, �� ����
	SETB	PORTB,3,R16	; ������������� 3 ��� �������� PORTB � 1 - pullUp �����
	CLRB	DDRB,3,R16	; ���������� DDR.3 � 0 - pullUp

	SETB	TIMSK,TOIE0,R16 	; ��������� ���������� �������0 �� ������������ (������ 1 � ��� TOIE0, ��������� R16 ��� ���������)
 	OUTI	TCCR0,1<<CS00		; ��������� ������. ������������=1
								; �.�. ������ � �������� ��������.
	SEI							; ��������� ���������� ����������

; End Internal Hardware Init ===================================

 
; External Hardware Init  ======================================
 
; End Internal Hardware Init ===================================

 
; Run ==========================================================


; End Run ======================================================


; Main =========================================================

Main:	SBIS	PINB,3		; ���� ������ ������ - �������
		RJMP	BT_Push

		SETB	PORTD,2		; ������ LED2
		CLRB	PORTD,3		; ������� LED3
 
Next:	LDS	R16,TCNT		; ������ ����� � ��������
		LDS	R17,TCNT+1
		
		CPI	R16,0x12		; ����������� ��������
		BRCS	NoMatch		; ���� ������ -- ������ �� ��������.
		CPI	R17,0x7A
		BRCS	NoMatch		; ���� ������ -- ������ �� ��������.

 
; ���� ������� �� ������ ����
Match:	INVB	PORTD,2,R16,R17	; ������������� LED3	

; ������ ���� �������� �������, ����� �� ��� �� �������� �������� �����
; �� ���� ������� ��� �� ���� ��� -- ������ �� �� ������ �������� 255 ��������,
; ����� ����� � ������ ���� ������ �������� ���������� � ������� ���������.
; �������, ����� ������ ��� ��� �������, �� ����� �������� ������� :) 
 
		CLR	R16			; ��� ����� ����
 
		CLI 			; ������ � ������������ ���������� ������������ �� ���������� � ����
						; ������������� ����� ��������� ������.  ������ ����������
 
		OUTU TCNT0,R16		; ���� � ������� ������� �������
		STS	TCNT,R16		; ���� � ������ ���� �������� � RAM
		STS	TCNT+1,R16		; ���� � ������ ���� �������� � RAM
		STS	TCNT+2,R16		; ���� � ������ ���� �������� � RAM
		STS	TCNT+3,R16		; ���� � ������ ���� �������� � RAM
		SEI 				; ��������� ���������� �����.

; �� ������� - �� ������ :) 
NoMatch:NOP
 
		INCM	CCNT		; ������� ������ ������
							; ������, ���� � �� ������������.
		RJMP	Main

BT_Push:SETB	PORTD,3	; ������ LED3
		CLRB	PORTD,2	; ������� LED2
		RJMP	Next

; End Main =====================================================



; Procedure ====================================================

; End Procedure ================================================


; EEPROM =======================================================
		.ESEG			; ������� EEPROM
