ASSUME CS:CODE,SS:STACK,DS:DATA
STACK SEGMENT
		DB 200 DUP ('STACK')
STACK ENDS

DATA SEGMENT
;�ж�������ȡ��		
		DW   0,0	;��ȡCS IP 
;̰�������겿��
	DEATH_H			DB   12,12,12,12,12,12,12,12,12	;������ Y	;�������µĿ�ʼλ�ã��㶨����
	DEATH_L			DB   16,17,18,19,20,21,22,23,24	;������ X
	DATAH			DB   12,12,12,12,12,12,12,12,12	;������ Y	;���й�����һֱ���޸�
	DATAL			DB   16,17,18,19,20,21,22,23,24	;������ X
;�����жϲ���
	INTFLAG			DB   4		;�ж��޸ı�־���������ߵķ���1����2����3����4����
	WINDOWS			DB   1		;�����޸ı�־�������������������ڣ�1�󴰿�2�Ҵ���
;�˻������������ʾ����
	XUPT			DB   '           THE 9TH ASSEMBLY LANGUAGE PROGRAMMING COMPETITION OF XUPT            '
	TEAM			DB	 '                         --- HC  WC  WYX  LDY  CYH ---                          '
	TRIANGLE_SIDE1	DB   'PLEASE ENTER TRIANGLE SIDE LENGTH'	;33
	TRIANGLE_SIDE2	DB   '(0001-0294):'	;12
	BYEBYE			DB   'THANKS FOR YOUR USE. GOODBYE!'		;29
	TOPIC			DB 	 'DOUBLE WINDOWS DISPLAY'				;22
	INFOR1			DB	 'R:START   TAB:SWITCH   ESC:EXIT'		;31
	INFOR2			DB	 'SNAKE'								;5
	INFOR3			DB	 'TRIANGLE'								;8
	INFOR4			DB	 'W:',24,'  S:',25,'  A:',27,'  D:',26	;18
	GAME_1			DB	 'GAME OVER!'							;10
	GAME_2			DB	 "PLEASE PRESS 'R' TO START AGAIN."		;32
;�����μ����߲���
	TRI_INFOR		DB	 "PRESS 'ENTER' TO BEGIN INPUTTING!" 	;33
	TRI_ERROR		DB	 "INCORRECT INPUT.PRESS ENTER AGAIN" 	;33
	X_1				DW	 0		;�����������������
	X_2				DW	 0
	X_3				DW	 0
	Y_1				DW	 0
	Y_2				DW	 0
	Y_3				DW	 0
	PK 				DW	 0
	SIDE_LENGTH		DW   0
	DRAW_X0			DW   0
	DRAW_Y0			DW   0
	DRAW_X1			DW   0
	DRAW_Y1			DW   0
	DRAW_X2			DW   0
	DRAW_Y2			DW	 0
	DRAW_COLOR		DB   4				;��ɫ
	LOOP_FLAG 		DB 	 0
	R				DB   0	
;��������		
	MSG DB 0DH,0AH,'[Q W E R T Y U 1 2 3 4 5 6 7]:VOICE  9:EXIT'
		DB 0DH,0AH,'_________________','$'
	;********����******�����õ�-1�ж����ֲ��Ƿ����
	SOUND_0  	DW -1
	SOUND_11 	DW 441,-1
	SOUND_12 	DW 495,-1
	SOUND_13 	DW 556,-1
	SOUND_14 	DW 589,-1
	SOUND_15 	DW 661,-1
	SOUND_16 	DW 742,-1
	SOUND_17 	DW 833,-1
	SOUND_1 	DW 882,-1
	SOUND_2 	DW 990,-1
	SOUND_3 	DW 1112,-1
	SOUND_4 	DW 1178,-1
	SOUND_5 	DW 1322,-1
	SOUND_6 	DW 1484,-1
	SOUND_7 	DW 1655,-1
	TIME 		DW 25
	DELAY_S 	DW 0
;=======���ֲ���========
;
	; MUS_FREG	DW 330,294,262,294,3 DUP (330)     ;Ƶ�ʱ�
				; DW 3 DUP (294),330,392,392
				; DW 330,294,262,294,4 DUP (330)
				; DW 294,294,330,294,262,-1
    ; MUS_TIME	DW 6 DUP (25),50                   ;���ı�
				; DW 2 DUP (25,25,50)
				; DW 12 DUP (25),100
;******************************��ֻ�ϻ�******************************			
	MUS_FREG    DW  262,294,330,262,262,294,330,262
				DW  330,349,392,330,349,392,392,440
				DW  392,349,330,262,392,440,392,349
				DW  330,262,294,196,262,294,196,262,-1
	MUS_TIME   	DW  25,25,25,25,25,25,25,25,25,25
				DW  50,25,25,50,12,12,12,12,25,25
				DW  12,12,12,12,25,25,25,25,50,25,25,50

DATA ENDS

CODE SEGMENT
START: 
;########����########
;INT 10H��BIOS�����ϵͳ�趨�Թ��������
;AH=06H ��������������(��)  AL=�������У�0=�����������CH��CL��DH��DL��
;BH=������ɫ��ǰ����ɫ.���磺BH=43H  //0��ɫ 1��ɫ 2��ɫ 3��ɫ 4��ɫ 5��ɫ 6��ɫ 7��ɫ 8��ɫ
;CH=��������CL=��������DH=��������DL=������
FULLCLEAR MACRO COLOR,COL1,ROW1,COL2,ROW2
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	MOV  AX,0600H	;����
	MOV  BH,COLOR
	MOV  CH,ROW1
	MOV  DH,ROW2
	MOV  CL,COL1
	MOV  DL,COL2
	INT  10H
	POP  DX
	POP  CX
	POP  BX
	POP  AX
ENDM
;########���ù��λ��########
;AH=02H,  BH=ҳ��,  DL=��X,  DH=��Y,
SETCURSOR MACRO COL,ROW
	PUSH AX
	PUSH BX
	PUSH DX
	MOV  AH,02H
	MOV  BH,0
	MOV  DH,ROW
	MOV  DL,COL
	INT  10H
	POP  DX
	POP  BX
	POP  AX
ENDM
;########�ڹ��λ��д�ַ�����ɫ########
;�ڵ�ǰ���λ��д�ַ�������	AH=09H	AL=�ַ���BH=ҳ�룬BL=��ɫ��CX=��δ�ӡ�ַ�
CHARCURSOR MACRO CHAR, COLOR
	PUSH AX
	PUSH BX
	PUSH CX
	MOV  AH,09H
	MOV  AL,CHAR
	MOV  BH,0
	MOV  BL,COLOR
	MOV  CX,2
	INT  10H
	POP  CX
	POP  BX
	POP  AX
ENDM
;########��ϸ���########
;������ҳ�桢Y���ꡢX���ꡢ��ɫ��ͨ����AH����0CH,ͨ��10H�ж������
;0��ɫ 1��ɫ 2��ɫ 3��ɫ 4��ɫ 5��ɫ 6��ɫ 7��ɫ 8��ɫ
POINT_THIN MACRO PAGE,ROW,COLUMN,COLOR
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	MOV AH,0CH
	MOV AL,COLOR
	MOV BH,PAGE
	MOV DX,ROW
	MOV CX,COLUMN
	INT 10H
	POP DX
	POP CX
	POP BX
	POP AX
ENDM 
;########�����ߺ꣬������X���ꡢY���ꡢ���ȡ���ɫ
DRAWLINE1 MACRO COLUMN,ROW,FREE_LENGTH,COLOR
		LOCAL LIN1 
	PUSH CX
	PUSH SI
	MOV  CX,FREE_LENGTH
	MOV  SI,COLUMN
LIN1:
	POINT_THIN 0,ROW,SI,COLOR
	INC  SI
	LOOP LIN1
	POP  SI
	POP  CX
ENDM

;*****����һ���꣬��ʾ�ַ���*****
SHOW MACRO B
	LEA DX,B
	MOV AH,9
	INT 21H
ENDM
;********һ��������********
ONESOUND MACRO SOUNDIS,JUMPIS,LETTERIS
	CMP AL,LETTERIS
	JNZ JUMPIS
	LEA SI,SOUNDIS
	LEA BP,DS:TIME
	CALL MUSIC
	CALL INPUT
ENDM

;----------���ֵ�ַ��-----------
ADDRESS MACRO A,B
     LEA SI,A
     LEA BP,DS:B
ENDM
;-------------------------------

;====================�������������ʼ=============================
;**��ʼ�����ݶ� ��ջ�� �������ݶΣ���ES=0����λ�� �ж�������**
MAIN:
	MOV AX,STACK
	MOV SS,AX
	MOV SP,128

	MOV AX,DATA
	MOV DS,AX

	MOV AX,0
	MOV ES,AX     

;=======������ʾģʽ�����ƴ��ڡ����������========
	MOV  AH,0		;������ʾģʽΪͼ��ģʽ640*480  16ɫ
	MOV  AL,12H	
	INT  10H
	
	FULLCLEAR 00H,0,0,80,29 	;��ʾ��������
	FULLCLEAR 03H,2,7,39,27
	FULLCLEAR 69H,41,7,77,27
	CALL HEADLINE	;��ʾ������
	
	
;���ֲ����밴����Ч����	
	;MOV  CX,3314
	MOV  WORD PTR DELAY_S,3314
	CALL MUSIC
; ;���ֲ����밴����Ч����	
; VOICE:	
	; ADDRESS MUS_FREG, MUS_TIME
	; CALL MUSIC
; ;	CALL BEEP	;����
	; JMP VOICE
; ENDVOICE:

;=====�����ж�=====
	PUSH ES:[9*4]
	POP  DS:[0]
	PUSH ES:[9*4+2]
	POP  DS:[2]		;��ԭ����INT 9�ж����̵���ڵ�ַ������DS:0��DS:2��Ԫ��

	CLI			;�������жϱ�־λIF=0
	MOV WORD PTR ES:[9*4],OFFSET INT9
	MOV ES:[9*4+2],CS	;���ж��������������µ�INT 9�ж����̵���ڵ�ַ
	STI			;�������Σ��������жϱ�־λIF=1

;==============ȫ�ִ����ж�==================
BEGIN:
	CMP  WINDOWS,1 
	JZ   CHECK

	CALL TRI
	JMP  BEGIN
;*****̰���߳���ѭ��*****
CHECK: 
		
	;�����˸����R��
	MOV  R,BYTE PTR 0
	SETCURSOR  2,28	;���ù��λ��
	CHARCURSOR '_',4	;���ù����ɫ
	CALL DELAY	
	CHARCURSOR '_',0 	;���ù����ɫ
	CALL DELAY
	CMP  R,1
	JNE  BEGIN

FISH: 
;BH=������ɫ��ǰ����ɫ.���磺BH=43H  //0��ɫ 1��ɫ 2��ɫ 3��ɫ 4��ɫ 5��ɫ 6��ɫ 7��ɫ 8��ɫ
;CH=��������CL=��������DH=��������DL=������
	CMP  WINDOWS,BYTE PTR 2
	JNZ  SNAKE
	CALL TRI
	JMP  BEGIN
SNAKE:
	
	FULLCLEAR 03H,2,7,39,27
;---------��β---------
	MOV  AH,02 
	MOV  BH,00	;���ù��λ��	AH=02H	BH=ҳ�룬DH=�У�DL=��  
	MOV  SI,OFFSET DATAH
	MOV  DI,OFFSET DATAL      
	MOV  DH,[SI]
	MOV  DL,[DI]
	INT  10H

	MOV  AX,0201H	;��ʾ+
	MOV  DL,'+'
	INT  21H
;---------����---------
	MOV  AH,02 
	MOV  BH,00
	MOV  DH,[SI]+1
	MOV  DL,[DI]+1
	INT  10H		;���ù��λ��	AH=02H��BH=ҳ�룬DH=�У�DL=��
	MOV  AX,0201H
	MOV  DL,'#'
	INT  21H		;��ʾ#

	MOV  AH,02 
	MOV  BH,00
	MOV  DH,[SI]+2
	MOV  DL,[DI]+2
	INT  10H 
	MOV  AX,0201H
	MOV  DL,'#'
	INT  21H

	MOV  AH,02 
	MOV  BH,00
	MOV  DH,[SI]+3
	MOV  DL,[DI]+3
	INT  10H 
	MOV  AX,0201H
	MOV  DL,'#'
	INT  21H

	MOV  AH,02 
	MOV  BH,00
	MOV  DH,[SI]+4
	MOV  DL,[DI]+4
	INT  10H 
	MOV  AX,0201H
	MOV  DL,'#'
	INT  21H

	MOV  AH,02 
	MOV  BH,00
	MOV  DH,[SI]+5
	MOV  DL,[DI]+5
	INT  10H 
	MOV  AX,0201H
	MOV  DL,'#'
	INT  21H

	MOV  AH,02 
	MOV  BH,00
	MOV  DH,[SI]+6
	MOV  DL,[DI]+6
	INT  10H 
	MOV  AX,0201H
	MOV  DL,'#'
	INT  21H

	MOV  AH,02 
	MOV  BH,00
	MOV  DH,[SI]+7
	MOV  DL,[DI]+7
	INT  10H 
	MOV  AX,0201H
	MOV  DL,'#'
	INT  21H
;---------��ͷ---------
	MOV  AH,02 
	MOV  BH,00
	MOV  DH,[SI]+8
	MOV  DL,[DI]+8
	INT  10H 
	MOV  AX,0201H
	MOV  DL,1
	INT  21H     
;-----�ж�ǰ������-----
	CMP INTFLAG,1
	JZ  UP
	CMP INTFLAG,2
	JZ  DOWN
	CMP INTFLAG,3
	JZ  LEFT
	CMP INTFLAG,4
	JZ  RIGHT

UP:  
	MOV  SI,OFFSET DATAH
	MOV  DI,OFFSET DATAL      
	MOV  DH,[SI]+8
	MOV  DL,[DI]+8
	MOV  CH,DH
	MOV  CL,DL
	DEC  DH
	MOV  [SI]+8,DH
	MOV  [DI]+8,DL  
	JMP  BACK            
               
DOWN: 
	MOV  SI,OFFSET DATAH
	MOV  DI,OFFSET DATAL      
	MOV  DH,[SI]+8
	MOV  DL,[DI]+8
	MOV  CH,DH
	MOV  CL,DL
	INC  DH
	MOV  [SI]+8,DH
	MOV  [DI]+8,DL 
	JMP  BACK         
 
LEFT: 
	MOV  SI,OFFSET DATAH
	MOV  DI,OFFSET DATAL      
	MOV  DH,[SI]+8
	MOV  DL,[DI]+8
	MOV  CH,DH
	MOV  CL,DL
	DEC  DL
	MOV  [SI]+8,DH
	MOV  [DI]+8,DL 
	JMP  BACK    

RIGHT:
	MOV  SI,OFFSET DATAH
	MOV  DI,OFFSET DATAL      
	MOV  DH,[SI]+8
	MOV  DL,[DI]+8
	MOV  CH,DH
	MOV  CL,DL
	INC  DL
	MOV  [SI]+8,DH
	MOV  [DI]+8,DL 
	JMP  BACK     
  
BACK: 
	MOV  DH,[SI]+7
	MOV  DL,[DI]+7  
	MOV  [SI]+7,CH
	MOV  [DI]+7,CL 
	MOV  CH,DH
	MOV  CL,DL

	MOV  DH,[SI]+6
	MOV  DL,[DI]+6  
	MOV  [SI]+6,CH
	MOV  [DI]+6,CL 
	MOV  CH,DH
	MOV  CL,DL

	MOV  DH,[SI]+5
	MOV  DL,[DI]+5  
	MOV  [SI]+5,CH
	MOV  [DI]+5,CL 
	MOV  CH,DH
	MOV  CL,DL

	MOV  DH,[SI]+4
	MOV  DL,[DI]+4  
	MOV  [SI]+4,CH
	MOV  [DI]+4,CL 
	MOV  CH,DH
	MOV  CL,DL

	MOV  DH,[SI]+3
	MOV  DL,[DI]+3  
	MOV  [SI]+3,CH
	MOV  [DI]+3,CL 
	MOV  CH,DH
	MOV  CL,DL 

	MOV  DH,[SI]+2
	MOV  DL,[DI]+2  
	MOV  [SI]+2,CH
	MOV  [DI]+2,CL 
	MOV  CH,DH
	MOV  CL,DL

	MOV  DH,[SI]+1
	MOV  DL,[DI]+1  
	MOV  [SI]+1,CH
	MOV  [DI]+1,CL 
	MOV  CH,DH
	MOV  CL,DL 

	MOV  DH,[SI]
	MOV  DL,[DI]  
	MOV  [SI],CH
	MOV  [DI],CL 
	MOV  CH,DH
	MOV  CL,DL
	
	;�����˸
	SETCURSOR  2,28	;���ù��λ��
	CHARCURSOR '_',0 	;���ù����ɫ
	
;;;;;;;;;;;;;;;�߶�һ�γ���Ӧʱ��ĸ�;;;;;;;;;;;;
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	
RESET:
	ADDRESS MUS_FREG,MUS_TIME
	MOV  CL,6
	XOR  AX, AX
FREG:	
	
	MOV  DI,[SI]
	CMP  DI,0FFFFH			;�ж��Ƿ���
	JE   RESET
	MOV  BX,DS:[BP]
	MOV  WORD PTR DELAY_S,500
	CALL GENSOUND			;����
	ADD  SI, 2
	ADD  BP, 2
	DEC  CL
	CMP  CL,0
	JE   WYX
	JMP  FREG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;CALL DELAY			;��֮�����������	
WYX:
	POP  DI
	POP  SI
	POP  DX
	POP  CX
	POP  BX
	POP  AX
	CHARCURSOR '_',4 	;���ù����ɫ
	CALL DELAY	
;==========ײǽ��ײ�Լ������ж�==============
;DI=X   SI=Y �����ͷ�Ƿ�ײǽ

	MOV  AL,[DI]+8
	MOV  AH,[SI]+8
	CMP  AL,[DI]+6		;ײ�Լ��Ƿ��������ж�
	JNZ   SSS		
	CMP  AH,[SI]+6		;ײ�Լ��Ƿ��������ж�
	JZ   CHEK		
SSS:

	CMP  [SI]+8,BYTE PTR 7	;��TOP
	JZ   CHEK
	CMP  [SI]+8,BYTE PTR 27	;��BOTTOM
	JZ   CHEK
    CMP  [DI]+8,BYTE PTR 2	;��LEFT
	JZ   CHEK
	CMP  [DI]+8,BYTE PTR 39	;��RIGHT
	JZ   CHEK  
;============================================
;===============û����ʱ��===================
	JMP  FISH
;===============����ʱ��=====================
CHEK:
	;�µĿ�ʼλ�ô���  �� DEATH ���� DATA
	MOV  CX,9
	MOV  SI,OFFSET DATAH
	MOV  AL,DEATH_H
HANG_Y:
	MOV  [SI],AL
	INC  SI
	LOOP HANG_Y
	
	MOV  CX,9
	MOV  SI,OFFSET DATAL
	MOV  BX,OFFSET DEATH_L
	MOV  DI,0
LIE_X:
	MOV  AL,[BX+DI]
	MOV  [SI],AL
	INC  SI
	INC  DI
	LOOP LIE_X
	MOV  INTFLAG,4
	
	FULLCLEAR 00H,5,15,36,16
	;�����ʾ��Ϣ
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET GAME_1	;��ʾ��GAME OVER��
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,11110010B
	MOV CX,10
	MOV DL,16
	MOV DH,15
	INT 10H
	
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET GAME_2	;��ʾ��PRESS R TO START AGAIN��
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,11110010B
	MOV CX,32
	MOV DL,5
	MOV DH,16
	INT 10H
	
	;���ֲ����밴����Ч����	����
	CALL MUSIC
	
	JMP  BEGIN	
;****�����˳�**** 
QUIT:
	CALL FIN_QUIT	;���������˳��ӳ����˳�����ϵͳ
	
;=====================������������ӳ���ʼ====================	
;===============================================================
;========================�������ӳ���===========================
TRI:    ;�����Ҵ���

	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET TRI_INFOR	;��ʾ��PRESS ENTER TO BEGIN INPUTTING��
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,11110011B
	MOV CX,33
	MOV DL,43
	MOV DH,27
	INT 10H
	
	MOV  CL,1
	MOV  LOOP_FLAG,CL
L:
	;�����˸
	SETCURSOR  41,28	;���ù��λ��
	CHARCURSOR '_',4	;���ù����ɫ
	CALL DELAY	
	CHARCURSOR '_',0 	;���ù����ɫ
	CALL DELAY
	CMP  WINDOWS,1
	JNE  RE
	RET
RE:	
	CMP  LOOP_FLAG,1
	JE   L

	FULLCLEAR 69H,41,7,77,27
	FULLCLEAR 00H,41,5,77,6		;����ϴβ�������������ʾ��������ı߳�
;������������TELETYPEģʽ����ʾ�ַ���
;��ڲ�����AH��13H    BH��ҳ��    BL������(��AL=00H�� 01H)  CX����ʾ�ַ�������  (DH��DL)������(�С���)
;ES:BP����ʾ�ַ����ĵ�ַ AL����ʾ�����ʽ
;0���� �ַ�����ֻ����ʾ�ַ�������ʾ������BL�С���ʾ�󣬹��λ�ò���
;1�����ַ�����ֻ����ʾ�ַ�������ʾ������BL�С���ʾ�󣬹��λ�øı�
;2 �����ַ����к���ʾ�ַ�����ʾ���ԡ���ʾ�󣬹��λ�ò���
;3�����ַ����к���ʾ�ַ�����ʾ���ԡ���ʾ�󣬹��λ�øı�	
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET TRIANGLE_SIDE1	;��ʾ�����������α߳���0001-0294����
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,10011011B
	MOV CX,33
	MOV DL,41
	MOV DH,5
	INT 10H
	
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET TRIANGLE_SIDE2	;��ʾ�����������α߳���0001-0294����
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,10011011B
	MOV CX,12
	MOV DL,41
	MOV DH,6
	INT 10H
	
	;������뻺������ִ��ָ���ı�׼���빦�� AH=0CH,AL=���ܺ�(01/06/07/08/0AH),DS:DX=������(0AH����)
	MOV  AH,0CH
	MOV  AL,01H
	INT  21H
	
	CALL SIDE					;�ӳ�����������������ı߳���ŵ�AX��
	CMP  AX,294
	JBE  COTINUE
;������������Teletypeģʽ����ʾ�ַ��� 
;��ڲ�����AH��13H
;BH��ҳ��
;BL������(��AL=00H�� 01H)
;CX����ʾ�ַ�������
;(DH��DL)������(�С���)
;ES:BP����ʾ�ַ����ĵ�ַ AL����ʾ�����ʽ
;0���� �ַ�����ֻ����ʾ�ַ�������ʾ������BL�С���ʾ�󣬹��λ�ò���
;1�����ַ�����ֻ����ʾ�ַ�������ʾ������BL�С���ʾ�󣬹��λ�øı�
;2 �����ַ����к���ʾ�ַ�����ʾ���ԡ���ʾ�󣬹��λ�ò���
;3�����ַ����к���ʾ�ַ�����ʾ���ԡ���ʾ�󣬹��λ�øı�
;���ڲ�������
	MOV BP,OFFSET TRI_ERROR	;��ʾ��PRESS ENTER TO BEGIN INPUTTING��
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,11110011B
	MOV CX,33
	MOV DL,43
	MOV DH,26
	INT 10H
	RET
COTINUE:
	FULLCLEAR 69H,41,7,77,27	;����ϴ�������
	
	PUSH AX
	POP  SIDE_LENGTH
	PUSH AX				;����߳��Ա���������ʱʹ��
;-----------------------------------��� X1=X X2=X+A/2 X3=X-A/2----------------------------------
	MOV  BL,2
	DIV  BL				;�ֽڳ���AX/BL��������AL=A/2,������BH;
	
	MOV  BL,AL				;���̴浽BL��
	
	MOV  AX,475  
	MOV  X_1,AX
	
	MOV  BH,0				;����BH��ʹ��BX=BL��
	PUSH BX
	ADD  BX,475
	MOV  X_3,BX

	POP  BX				;BX=��
	MOV  DX,475
	SUB  DX,BX
	MOV  X_2,DX					
;-----------------------------------���Y1=Y-������/4*A Y2=Y3=Y+������/4*A-----------------------------------
	MOV  DX,0
	MOV  AX,1732
	MOV  BX,4
	DIV  BX					;�ֳ���DX:AX/BX��������AX=433,������DX=0;
	MOV  BX,AX
	MOV  DX,0					;����DX�Ա�ʹ��BX��AX���BX = 433
	POP  AX					;�����߳���AL��  AL=A
	MUL  BX					;�ֽڳ˷�AL*BL�������AX=433*A�����ڳ������ֵ�����ִ�Ų���,���Բ����ֳ˷�
								;�ֳ˷�AX*BX �����(DX:AX)=433A
	MOV  BX,1000				;433A/1000�õ� ������/4*A ���������ֺ�С�����֡�
	DIV	 BX						;��������AX��С������DX
	PUSH AX					;����������С������
	PUSH DX
	ADD  DX,500				;��С���������
	CMP  DX,1000				;���Ƿ��н�λ
	JB   NOCARRY				;�޽�λ�����н�λ������һ��С��-1000
CARRY:
	INC  AX						;�н�λ��������AX++
	SUB  DX,1000				;��С������DX-1000
NOCARRY:	
	ADD  AX,277
	MOV  Y_2,AX
	MOV  Y_3,AX
	POP  DX
	POP  AX					;����433A/1000���������ֺ�С������
	CMP  DX,500
	JBE  NOBORROWER
BORROWER:
	DEC  AX
NOBORROWER:
	MOV  BX,277
	SUB  BX,AX
	MOV  Y_1,BX

	PUSH X_1
	PUSH Y_1
	PUSH X_2
	PUSH Y_2
	POP  DRAW_Y1
	POP  DRAW_X1
	POP  DRAW_Y0
	POP  DRAW_X0
	CALL DECLINE
	
	PUSH X_1
	PUSH Y_1
	PUSH X_3
	PUSH Y_3
	POP  DRAW_Y2
	POP  DRAW_X2
	POP  DRAW_Y0
	POP  DRAW_X0
	CALL RISING_SLASH	
	DRAWLINE1 X_2,Y_2,SIDE_LENGTH,4	
	RET
;==============����߳�SIDE==============
SIDE:
	MOV  AH,1
	INT  21H
	;CMP  AL,
	SUB  AL,30H		;�ַ���ת������Ӧ������
	MOV  BL,100
	MUL  BL			;AX=AL*BL
	MOV  BX,AX		;��λ��һ��
	PUSH BX			;��BX�Ա�֮���
	MOV  AH,1
	INT  21H
	SUB  AL,30H				
	MOV  BL,10
	MUL  BL
	POP  BX
	ADD  BX,AX		;��λ��һ�ټ�ʮλ��10
	
	MOV  AH,1
	INT  21H
	SUB  AL,30H
	MOV  AH,0
	ADD  BX,AX		;��λ��һ�ټ�ʮλ��10�Ӹ�λ���ŵ�BX
	MOV  AX,BX		;�߳��ŵ�AX��			
	RET

	
;=============================��ʾ�������ӳ���============================
HEADLINE PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH ES
	PUSH BP
	;������������TELETYPEģʽ����ʾ�ַ���
	;��ڲ�����AH��13H    BH��ҳ��    BL������(��AL=00H�� 01H)  CX����ʾ�ַ�������  (DH��DL)������(�С���)
	;ES:BP����ʾ�ַ����ĵ�ַ AL����ʾ�����ʽ
	;0���� �ַ�����ֻ����ʾ�ַ�������ʾ������BL�С���ʾ�󣬹��λ�ò���
	;1�����ַ�����ֻ����ʾ�ַ�������ʾ������BL�С���ʾ�󣬹��λ�øı�
	;2 �����ַ����к���ʾ�ַ�����ʾ���ԡ���ʾ�󣬹��λ�ò���
	;3�����ַ����к���ʾ�ַ�����ʾ���ԡ���ʾ�󣬹��λ�øı�
	;16λɫ�ʱ���� (D7 D6 D5 D4Ϊ����ɫ,D3 D2 D1 D0Ϊǰ��ɫ)
	;       �������������������������ש�����������������������
	;       ��   0 0 0 0     ��     ��   1 0 0 0      ��    ��
	;       ��   0 0 0 1     ��     ��   1 0 0 1     ǳ��   ��
	;       ��   0 0 1 0     ��     ��   1 0 1 0     ǳ��   ��
	;       ��   0 0 1 1     ��     ��   1 0 1 1     ǳ��   ��
	;       ��   0 1 0 0     ��     ��   1 1 0 0     ǳ��   ��
	;       ��   0 1 0 1    Ʒ��    ��   1 1 0 1    ǳƷ��  ��
	;       ��   0 1 1 0     ��     ��   1 1 1 0      ��    ��
	;       ��   0 1 1 1    �Ұ�    ��   1 1 1 1      ��    ��
	;       �������������������������ߩ�����������������������
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET XUPT	;'***********THE 9TH ASSEMBLY LANGUAGE PROGRAMMING COMPETITION OF XUPT************$'	
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,00111100B
	MOV CX,80
	MOV DL,0
	MOV DH,0
	INT 10H
	
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET TEAM	;'---------------------------- HC  WC  WYX  LDY  CYH -----------------------------$'
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,00111000B
	MOV CX,80
	MOV DL,0
	MOV DH,1
	INT 10H
	
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET TOPIC		;'DOUBLE WINDOWS DISPLAY'						;22
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,00111010B
	MOV CX,22
	MOV DL,28
	MOV DH,2
	INT 10H
	
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET INFOR1	;'R:START   TAB:SWITCH   ESC:EXIT'		;31
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,00110010B
	MOV CX,31
	MOV DL,24
	MOV DH,3
	INT 10H
	
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET INFOR2	;	'SNAKE'								;5
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,00111110B
	MOV CX,5
	MOV DL,18
	MOV DH,4
	INT 10H
	
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET INFOR3	;	'TRIANGLE'								;8
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,00111110B
	MOV CX,8
	MOV DL,54
	MOV DH,4
	INT 10H
	
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET INFOR4	;	'W:',24,'  S:',25,'  A:',27,'  D:',26	;18
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,00110110B
	MOV CX,18
	MOV DL,12
	MOV DH,6
	INT 10H
	
	POP BP
	POP ES
	POP DX
	POP CX
	POP BX
	POP AX
	RET
HEADLINE ENDP
;=========================== DELAY�ӳ��� ===========================
DELAY:
	PUSH CX
	PUSH AX
	MOV  AX,2
B:
	MOV  CX,0F000H
A:	
	NOP
	NOP
	LOOP A
	DEC  AX
	CMP  AX,0
	JNZ  B

	POP  AX
	POP  CX
	RET
;======================= ��INT9�жϴ������ ========================
INT9: 
	PUSH AX
	PUSH BX
	PUSH ES

	IN  AL,60H
	MOV DL,AL

	PUSHF
	CALL DWORD PTR DS:[0] ;����ϵͳ�ṩ���жϴ�����򡪡�ԭ����INT9,�����жϵ��õ��ƺ���
	
	CMP DL,13H  ;'R'
	JZ  R1
	CMP DL,1CH  ;'�س�'
	JZ  ENTE
	CMP DL,11H	;'W'
	JZ  UP_1
	CMP DL,1FH	;'S'
	JZ  DOWN_2
	CMP DL,1EH	;'A'
	JZ  LEFT_3
	CMP DL,20H	;'D'
	JZ  RIGHT_4
	CMP DL,0FH	;'TAB'
	JZ  TRIANGLE	;������
	CMP DL,01H	;'ESC'
	JZ  ESC_QUIT	;�˳�ϵͳ
	JMP INT9RET
;============�жϴ���============
R1:
	MOV R,BYTE PTR 1
	JMP INT9RET
ENTE:
	MOV LOOP_FLAG,BYTE PTR 0
	JMP INT9RET
UP_1: 
	MOV INTFLAG,1
	JMP INT9RET
DOWN_2: 
	MOV INTFLAG,2
	JMP INT9RET
LEFT_3: 
	MOV INTFLAG,3
	JMP INT9RET
RIGHT_4:
	MOV INTFLAG,4
	JMP INT9RET
TRIANGLE:
	CMP WINDOWS,BYTE PTR 1
	JZ  TRIANGLE1
	CMP WINDOWS,BYTE PTR 2
	JZ  TRIANGLE2
	JMP INT9RET
TRIANGLE1:
	MOV WINDOWS,BYTE PTR 2
	JMP INT9RET
TRIANGLE2:
	MOV WINDOWS,BYTE PTR 1
	JMP INT9RET
ESC_QUIT:
	CALL FIN_QUIT	;���������˳��ӳ����˳�����ϵͳ
;============�жϷ���============
INT9RET:
	POP ES
	POP BX
	POP AX
	IRET
;========�˳�����ϵͳ�ӳ���===========
FIN_QUIT:	
	;****�ָ��ж�����****
	MOV AX,0
	MOV ES,AX

	CLI		;�������жϱ�־λ
	PUSH DS:[0]
	POP  ES:[9*4]
	PUSH DS:[2]
	POP  ES:[9*4+2]	;���ж��������е�INT 9 �ж������ָ�
	STI		;ȡ������

	FULLCLEAR 00H,26,14,58,16
	;MOV  DX,OFFSET BYEBYE	;����˳���ʾ
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET BYEBYE	;��ʾ��PRESS ENTER TO BEGIN INPUTTING��
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,11110011B
	MOV CX,29
	MOV DL,28
	MOV DH,15
	INT 10H
	
	SETCURSOR 2,28
	MOV AX,4C00H	;����DOS
	INT 21H
;-------------------------------------------------------
;======================����б��============================
RISING_SLASH PROC 	;����б����б��С��1��С����ʮ��ȣ�
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	MOV SI,00H
	MOV DI,00H

  	MOV AH,0CH
    MOV AL,DRAW_COLOR
	MOV BH,0
	MOV CX,DRAW_X0
	MOV DX,DRAW_Y0
	INT 10H
	MOV AH,0CH
	MOV AL,DRAW_COLOR
	MOV BH,0

	MOV CX,DRAW_X2
	MOV DX,DRAW_Y2	;������
	
	INT 10H
	MOV BX,DRAW_X2
	;MOV DX,DRAW_Y2	;������
	MOV AX,DRAW_X0
	SUB BX,AX
	MOV SI,BX
	;MOV SI, (XN-X0)	;DX
	ADD SI,CX
	;ADD SI,(XN-X0)
	SUB SI,DRAW_X0
	MOV AX,DRAW_Y0
	MOV BX,DRAW_Y2
	SUB BX,AX
	MOV DI,BX
	;MOV DI,(YN-Y0)	;DY
	;ADD DI,(YN-Y0)
		
	;SUB DI,SI		;2*DY-DX
	SUB SI,DI
	;MOV PK,DI	;P0=2*DY-DX
	MOV PK,SI
	MOV CX ,DRAW_X0
	MOV DX ,DRAW_Y0
	
DRAW:
	MOV AX,0
	MOV AX ,WORD PTR PK
	MOV DI,0
	MOV DI,DRAW_Y2
	SUB DI,DRAW_Y0
	;MOV DI,(YN-Y0)	;DY
	;ADD DI,(YN-Y0)
	MOV SI,DRAW_X2
	SUB SI,DRAW_X0
	;MOV SI, (XN-X0)	;DX
	;ADD SI,(XN-X0)
	MOV BX,SI
	ADD SI,BX
	INC DX
	CMP AX,0

	JG UPPER

	JMP  LOWER	;Ĭ��ȡY=Y+1�ĵ�

LOWER:
	ADD SI,WORD PTR PK
	;ADD DI,WORD PTR PK
	;MOV PK,DI	;�µ�PK=PK+2DY
	MOV PK,SI
	JMP SEND_X_AND_Y
		;Y����		
		;2DY+PK
UPPER:
	;ADD DX,1
	ADD CX,1	
	;SUB DI,(XN-X0)
	;SUB DI,(XN-X0)
	SUB SI,DRAW_Y2
	ADD SI,DRAW_Y0
;	SUB SI,(YN-Y0)
;	SUB SI,(YN-Y0)

	SUB SI,DRAW_Y2
	ADD SI,DRAW_Y0
	;ADD DI,WORD PTR PK
	ADD SI,WORD PTR PK
	;MOV PK,DI	;�µ�PK=PK+2DY-2DX
	MOV PK,SI
	JMP SEND_X_AND_Y
SEND_X_AND_Y:

	MOV AH,0CH
	MOV AL,DRAW_COLOR
	MOV BH,0
	INT 10H
	
	CMP DX,DRAW_Y2
	
	JB DRAW
	JMP EXIT
  	
EXIT:
	POP DI
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX

;ENDM
	RET
RISING_SLASH ENDP
;============================����б��===============================
DECLINE PROC 	;б�ʴ���1��������ʮ��ȣ�
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH SI
	PUSH DI
	MOV SI,00H
	MOV DI,00H

  	MOV AH,0CH
	MOV AL,DRAW_COLOR
	MOV BH,0
	MOV CX,DRAW_X0
	MOV DX,DRAW_Y0
	INT 10H
	MOV AH,0CH
	MOV AL,DRAW_COLOR
	MOV BH,0

	MOV CX,DRAW_X1
	MOV DX,DRAW_Y1	;������
	
	INT 10H
	MOV BX,DRAW_X0
	;������
	MOV AX,DRAW_X1
	MOV CX,DRAW_X0
	MOV DX,DRAW_Y1
	SUB BX,AX	;X0-X1
	MOV SI,BX	;SI=DX
	;DX
	ADD SI,CX		;SI=SI+X0
	
	SUB SI,DRAW_X1	;SI=SI-X1,SI=2DX
	MOV AX,DRAW_Y0	;
	MOV BX,DRAW_Y1
	SUB BX,AX	;BX=Y1-Y0;DY
	MOV DI,BX	;DY
	
		
			;2*DY-DX
	SUB SI,DI		;2DX-DY
			;P0=2*DY-DX
	MOV PK,SI	;P0=2DX-DY
	MOV CX ,DRAW_X0
	MOV DX ,DRAW_Y0	
			;SI=2*DX
			;DI=DY
	
DE_DRAW:
	MOV AX,0
	MOV AX ,WORD PTR PK
	MOV DI,0
	MOV DI, DRAW_Y1	
	SUB DI,DRAW_Y0	;DY=Y1-Y0
			;DY
			
	MOV SI,DRAW_X0	;SI=X0
	SUB SI,DRAW_X1	;SI=X0-X1
			;DX
		
	MOV BX,SI	;
	ADD SI,BX		;SI=SI+SI
	INC DX		;Y0++
	CMP AX,0
	
	JG DE_UPPER 	
	
	JMP  DE_LOWER	;Ĭ��ȡY=Y+1�ĵ�

DE_LOWER:
	ADD SI,WORD PTR PK	;PK=PK+2DX
	
			;�µ�PK=PK+2DY
	MOV PK,SI	
	JMP DE_SEND_X_AND_Y

		;Y����		
		;2DY+PK
DE_UPPER:
		
	SUB CX,1	

	ADD SI,DRAW_Y0	;DX+Y0
	SUB SI,DRAW_Y1	;DX+Y0-Y1

	ADD SI,DRAW_Y0	
	SUB SI,DRAW_Y1

	ADD SI,WORD PTR PK	;PK=PK+2DX-2DY
	
	MOV PK,SI
	JMP DE_SEND_X_AND_Y
DE_SEND_X_AND_Y:

	MOV AH,0CH
	MOV AL,DRAW_COLOR
	MOV BH,0
	
	INT 10H
	
	CMP DX,DRAW_Y1
	
	JB DE_DRAW
	JMP DE_EXIT
  	
DE_EXIT:
	POP DI
	POP SI
	POP DX
	POP CX
	POP BX
	POP AX
	RET
DECLINE ENDP

;���ֲ���
;------------����-------------
GENSOUND PROC NEAR
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX
     PUSH DI

     MOV AL, 0B6H
     OUT 43H, AL			;8253��ʼ��
     MOV DX, 12H
     					
     MOV AX, 348CH			;��������Ƶ��533H��896��348C���¸���Ƶ��=123280H�¸���Ƶ��
     DIV DI				
     OUT 42H, AL			;���͵�λ

     MOV AL, AH
     OUT 42H, AL			;���͸�λ

     IN AL, 61H				;��������
     MOV AH, AL
     OR AL, 3				;������˿�61H��PB0��PB1��λ��1����������
     OUT 61H, AL
WAIT1:
     MOV CX, DELAY_S
     CALL WAITF
DELAY1:
     DEC BX
     JNZ WAIT1

     MOV AL, AH
     OUT 61H, AL

     POP DI
     POP DX
     POP CX
     POP BX
     POP AX
     RET 
GENSOUND ENDP

;--------------------------
WAITF PROC NEAR
      PUSH AX
WAITF1:
      IN AL,61H
      AND AL,10H
      CMP AL,AH
      JE WAITF1
      MOV AH,AL
      LOOP WAITF1
      POP AX
      RET
WAITF ENDP
;--------------�������ú���----------------
MUSIC PROC NEAR
	ADDRESS MUS_FREG, MUS_TIME
	XOR AX, AX
FREG1:
	MOV DI, [SI]
	CMP DI, 0FFFFH			;�ж��Ƿ���
	JE END_MUS
	MOV BX, DS:[BP]
	CALL GENSOUND
	ADD SI, 2
	ADD BP, 2
	JMP FREG1
END_MUS:
      RET
MUSIC ENDP


CODE ENDS
	END START