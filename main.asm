ASSUME CS:CODE,SS:STACK,DS:DATA
STACK SEGMENT
		DB 200 DUP ('STACK')
STACK ENDS

DATA SEGMENT
;中断向量存取处		
		DW   0,0	;存取CS IP 
;贪吃蛇坐标部分
	DEATH_H			DB   12,12,12,12,12,12,12,12,12	;行坐标 Y	;死亡后新的开始位置，恒定不变
	DEATH_L			DB   16,17,18,19,20,21,22,23,24	;列坐标 X
	DATAH			DB   12,12,12,12,12,12,12,12,12	;行坐标 Y	;运行过程中一直被修改
	DATAL			DB   16,17,18,19,20,21,22,23,24	;列坐标 X
;窗口判断部分
	INTFLAG			DB   4		;中断修改标志——控制蛇的方向：1向上2向下3向左4向右
	WINDOWS			DB   1		;窗口修改标志——控制左右两个窗口：1左窗口2右窗口
;人机交互，输出显示部分
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
;三角形及画线部分
	TRI_INFOR		DB	 "PRESS 'ENTER' TO BEGIN INPUTTING!" 	;33
	TRI_ERROR		DB	 "INCORRECT INPUT.PRESS ENTER AGAIN" 	;33
	X_1				DW	 0		;三角形三个点的坐标
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
	DRAW_COLOR		DB   4				;红色
	LOOP_FLAG 		DB 	 0
	R				DB   0	
;声音部分		
	MSG DB 0DH,0AH,'[Q W E R T Y U 1 2 3 4 5 6 7]:VOICE  9:EXIT'
		DB 0DH,0AH,'_________________','$'
	;********音调******后面用到-1判断音乐播是否放完
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
;=======音乐部分========
;
	; MUS_FREG	DW 330,294,262,294,3 DUP (330)     ;频率表
				; DW 3 DUP (294),330,392,392
				; DW 330,294,262,294,4 DUP (330)
				; DW 294,294,330,294,262,-1
    ; MUS_TIME	DW 6 DUP (25),50                   ;节拍表
				; DW 2 DUP (25,25,50)
				; DW 12 DUP (25),100
;******************************两只老虎******************************			
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
;########清屏########
;INT 10H由BIOS或操作系统设定以供软件调用
;AH=06H 清除或滚动栏画面(上)  AL=滚动的行（0=清除，被用于CH，CL，DH，DL）
;BH=背景颜色和前景颜色.例如：BH=43H  //0黑色 1蓝色 2绿色 3青色 4红色 5紫色 6橙色 7白色 8灰色
;CH=高行数，CL=左列数，DH=低行数，DL=右列数
FULLCLEAR MACRO COLOR,COL1,ROW1,COL2,ROW2
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	MOV  AX,0600H	;清屏
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
;########设置光标位置########
;AH=02H,  BH=页码,  DL=列X,  DH=行Y,
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
;########在光标位置写字符和颜色########
;在当前光标位置写字符和属性	AH=09H	AL=字符，BH=页码，BL=颜色，CX=多次打印字符
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
;########画细点宏########
;参数：页面、Y坐标、X坐标、颜色，通过将AH放入0CH,通过10H中断来描点
;0黑色 1蓝色 2绿色 3青色 4红色 5紫色 6橙色 7白色 8灰色
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
;########画横线宏，参数：X坐标、Y坐标、长度、颜色
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

;*****定义一个宏，显示字符串*****
SHOW MACRO B
	LEA DX,B
	MOV AH,9
	INT 21H
ENDM
;********一个声音宏********
ONESOUND MACRO SOUNDIS,JUMPIS,LETTERIS
	CMP AL,LETTERIS
	JNZ JUMPIS
	LEA SI,SOUNDIS
	LEA BP,DS:TIME
	CALL MUSIC
	CALL INPUT
ENDM

;----------音乐地址宏-----------
ADDRESS MACRO A,B
     LEA SI,A
     LEA BP,DS:B
ENDM
;-------------------------------

;====================宏结束，主程序开始=============================
;**初始化数据段 堆栈段 附加数据段（用ES=0来定位到 中断向量表）**
MAIN:
	MOV AX,STACK
	MOV SS,AX
	MOV SP,128

	MOV AX,DATA
	MOV DS,AX

	MOV AX,0
	MOV ES,AX     

;=======设置显示模式、绘制窗口、输出标题栏========
	MOV  AH,0		;设置显示模式为图形模式640*480  16色
	MOV  AL,12H	
	INT  10H
	
	FULLCLEAR 00H,0,0,80,29 	;显示三个窗口
	FULLCLEAR 03H,2,7,39,27
	FULLCLEAR 69H,41,7,77,27
	CALL HEADLINE	;显示标题栏
	
	
;音乐播放与按键音效设置	
	;MOV  CX,3314
	MOV  WORD PTR DELAY_S,3314
	CALL MUSIC
; ;音乐播放与按键音效设置	
; VOICE:	
	; ADDRESS MUS_FREG, MUS_TIME
	; CALL MUSIC
; ;	CALL BEEP	;声音
	; JMP VOICE
; ENDVOICE:

;=====载入中断=====
	PUSH ES:[9*4]
	POP  DS:[0]
	PUSH ES:[9*4+2]
	POP  DS:[2]		;将原来的INT 9中断例程的入口地址保存在DS:0、DS:2单元中

	CLI			;置屏蔽中断标志位IF=0
	MOV WORD PTR ES:[9*4],OFFSET INT9
	MOV ES:[9*4+2],CS	;在中断向量表中设置新的INT 9中断例程的入口地址
	STI			;撤消屏蔽，置屏蔽中断标志位IF=1

;==============全局窗口判断==================
BEGIN:
	CMP  WINDOWS,1 
	JZ   CHECK

	CALL TRI
	JMP  BEGIN
;*****贪吃蛇程序循环*****
CHECK: 
		
	;光标闪烁与检测R键
	MOV  R,BYTE PTR 0
	SETCURSOR  2,28	;设置光标位置
	CHARCURSOR '_',4	;设置光标颜色
	CALL DELAY	
	CHARCURSOR '_',0 	;设置光标颜色
	CALL DELAY
	CMP  R,1
	JNE  BEGIN

FISH: 
;BH=背景颜色和前景颜色.例如：BH=43H  //0黑色 1蓝色 2绿色 3青色 4红色 5紫色 6橙色 7白色 8灰色
;CH=高行数，CL=左列数，DH=低行数，DL=右列数
	CMP  WINDOWS,BYTE PTR 2
	JNZ  SNAKE
	CALL TRI
	JMP  BEGIN
SNAKE:
	
	FULLCLEAR 03H,2,7,39,27
;---------蛇尾---------
	MOV  AH,02 
	MOV  BH,00	;设置光标位置	AH=02H	BH=页码，DH=行，DL=列  
	MOV  SI,OFFSET DATAH
	MOV  DI,OFFSET DATAL      
	MOV  DH,[SI]
	MOV  DL,[DI]
	INT  10H

	MOV  AX,0201H	;显示+
	MOV  DL,'+'
	INT  21H
;---------蛇身---------
	MOV  AH,02 
	MOV  BH,00
	MOV  DH,[SI]+1
	MOV  DL,[DI]+1
	INT  10H		;设置光标位置	AH=02H，BH=页码，DH=行，DL=列
	MOV  AX,0201H
	MOV  DL,'#'
	INT  21H		;显示#

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
;---------蛇头---------
	MOV  AH,02 
	MOV  BH,00
	MOV  DH,[SI]+8
	MOV  DL,[DI]+8
	INT  10H 
	MOV  AX,0201H
	MOV  DL,1
	INT  21H     
;-----判断前进方向-----
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
	
	;光标闪烁
	SETCURSOR  2,28	;设置光标位置
	CHARCURSOR '_',0 	;设置光标颜色
	
;;;;;;;;;;;;;;;蛇动一次唱相应时间的歌;;;;;;;;;;;;
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
	CMP  DI,0FFFFH			;判断是否唱完
	JE   RESET
	MOV  BX,DS:[BP]
	MOV  WORD PTR DELAY_S,500
	CALL GENSOUND			;发声
	ADD  SI, 2
	ADD  BP, 2
	DEC  CL
	CMP  CL,0
	JE   WYX
	JMP  FREG
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

	;CALL DELAY			;用之后的声音代替	
WYX:
	POP  DI
	POP  SI
	POP  DX
	POP  CX
	POP  BX
	POP  AX
	CHARCURSOR '_',4 	;设置光标颜色
	CALL DELAY	
;==========撞墙及撞自己死亡判断==============
;DI=X   SI=Y 检测蛇头是否撞墙

	MOV  AL,[DI]+8
	MOV  AH,[SI]+8
	CMP  AL,[DI]+6		;撞自己是否死坐标判断
	JNZ   SSS		
	CMP  AH,[SI]+6		;撞自己是否死坐标判断
	JZ   CHEK		
SSS:

	CMP  [SI]+8,BYTE PTR 7	;顶TOP
	JZ   CHEK
	CMP  [SI]+8,BYTE PTR 27	;底BOTTOM
	JZ   CHEK
    CMP  [DI]+8,BYTE PTR 2	;左LEFT
	JZ   CHEK
	CMP  [DI]+8,BYTE PTR 39	;右RIGHT
	JZ   CHEK  
;============================================
;===============没死的时候===================
	JMP  FISH
;===============死的时候=====================
CHEK:
	;新的开始位置处理  将 DEATH 赋给 DATA
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
	;输出提示信息
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET GAME_1	;显示“GAME OVER”
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
	MOV BP,OFFSET GAME_2	;显示“PRESS R TO START AGAIN”
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,11110010B
	MOV CX,32
	MOV DL,5
	MOV DH,16
	INT 10H
	
	;音乐播放与按键音效设置	死亡
	CALL MUSIC
	
	JMP  BEGIN	
;****程序退出**** 
QUIT:
	CALL FIN_QUIT	;调用最终退出子程序退出整个系统
	
;=====================主程序结束，子程序开始====================	
;===============================================================
;========================三角形子程序===========================
TRI:    ;进入右窗口

	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET TRI_INFOR	;显示“PRESS ENTER TO BEGIN INPUTTING”
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
	;光标闪烁
	SETCURSOR  41,28	;设置光标位置
	CHARCURSOR '_',4	;设置光标颜色
	CALL DELAY	
	CHARCURSOR '_',0 	;设置光标颜色
	CALL DELAY
	CMP  WINDOWS,1
	JNE  RE
	RET
RE:	
	CMP  LOOP_FLAG,1
	JE   L

	FULLCLEAR 69H,41,7,77,27
	FULLCLEAR 00H,41,5,77,6		;清除上次残留的三角形提示语句和输入的边长
;功能描述：在TELETYPE模式下显示字符串
;入口参数：AH＝13H    BH＝页码    BL＝属性(若AL=00H或 01H)  CX＝显示字符串长度  (DH、DL)＝坐标(行、列)
;ES:BP＝显示字符串的地址 AL＝显示输出方式
;0—— 字符串中只含显示字符，其显示属性在BL中。显示后，光标位置不变
;1——字符串中只含显示字符，其显示属性在BL中。显示后，光标位置改变
;2 ——字符串中含显示字符和显示属性。显示后，光标位置不变
;3——字符串中含显示字符和显示属性。显示后，光标位置改变	
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET TRIANGLE_SIDE1	;显示“输入三角形边长（0001-0294）”
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
	MOV BP,OFFSET TRIANGLE_SIDE2	;显示“输入三角形边长（0001-0294）”
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,10011011B
	MOV CX,12
	MOV DL,41
	MOV DH,6
	INT 10H
	
	;清除输入缓冲区并执行指定的标准输入功能 AH=0CH,AL=功能号(01/06/07/08/0AH),DS:DX=缓冲区(0AH功能)
	MOV  AH,0CH
	MOV  AL,01H
	INT  21H
	
	CALL SIDE					;子程序描述：计算输入的边长存放到AX中
	CMP  AX,294
	JBE  COTINUE
;功能描述：在Teletype模式下显示字符串 
;入口参数：AH＝13H
;BH＝页码
;BL＝属性(若AL=00H或 01H)
;CX＝显示字符串长度
;(DH、DL)＝坐标(行、列)
;ES:BP＝显示字符串的地址 AL＝显示输出方式
;0—— 字符串中只含显示字符，其显示属性在BL中。显示后，光标位置不变
;1——字符串中只含显示字符，其显示属性在BL中。显示后，光标位置改变
;2 ——字符串中含显示字符和显示属性。显示后，光标位置不变
;3——字符串中含显示字符和显示属性。显示后，光标位置改变
;出口参数：无
	MOV BP,OFFSET TRI_ERROR	;显示“PRESS ENTER TO BEGIN INPUTTING”
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
	FULLCLEAR 69H,41,7,77,27	;清除上次三角形
	
	PUSH AX
	POP  SIDE_LENGTH
	PUSH AX				;保存边长以便算纵坐标时使用
;-----------------------------------算出 X1=X X2=X+A/2 X3=X-A/2----------------------------------
	MOV  BL,2
	DIV  BL				;字节除法AX/BL除完商在AL=A/2,余数在BH;
	
	MOV  BL,AL				;把商存到BL中
	
	MOV  AX,475  
	MOV  X_1,AX
	
	MOV  BH,0				;清零BH，使得BX=BL。
	PUSH BX
	ADD  BX,475
	MOV  X_3,BX

	POP  BX				;BX=商
	MOV  DX,475
	SUB  DX,BX
	MOV  X_2,DX					
;-----------------------------------算出Y1=Y-根号三/4*A Y2=Y3=Y+根号三/4*A-----------------------------------
	MOV  DX,0
	MOV  AX,1732
	MOV  BX,4
	DIV  BX					;字除法DX:AX/BX除完商在AX=433,余数在DX=0;
	MOV  BX,AX
	MOV  DX,0					;清零DX以便使用BX与AX相乘BX = 433
	POP  AX					;弹出边长到AL中  AL=A
	MUL  BX					;字节乘法AL*BL乘完积在AX=433*A，由于乘完后数值过大，字存放不下,所以采用字乘法
								;字乘法AX*BX 积存放(DX:AX)=433A
	MOV  BX,1000				;433A/1000得到 根号三/4*A 的整数部分和小数部分。
	DIV	 BX						;整数部分AX，小数部分DX
	PUSH AX					;保存整数与小数部分
	PUSH DX
	ADD  DX,500				;先小数部分相加
	CMP  DX,1000				;看是否有进位
	JB   NOCARRY				;无进位跳，有进位整数加一，小数-1000
CARRY:
	INC  AX						;有进位整数部分AX++
	SUB  DX,1000				;且小数部分DX-1000
NOCARRY:	
	ADD  AX,277
	MOV  Y_2,AX
	MOV  Y_3,AX
	POP  DX
	POP  AX					;弹出433A/1000的整数部分和小数部分
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
;==============输入边长SIDE==============
SIDE:
	MOV  AH,1
	INT  21H
	;CMP  AL,
	SUB  AL,30H		;字符串转换成相应的数字
	MOV  BL,100
	MUL  BL			;AX=AL*BL
	MOV  BX,AX		;百位乘一百
	PUSH BX			;存BX以便之后加
	MOV  AH,1
	INT  21H
	SUB  AL,30H				
	MOV  BL,10
	MUL  BL
	POP  BX
	ADD  BX,AX		;百位乘一百加十位乘10
	
	MOV  AH,1
	INT  21H
	SUB  AL,30H
	MOV  AH,0
	ADD  BX,AX		;百位乘一百加十位乘10加个位，放到BX
	MOV  AX,BX		;边长放到AX中			
	RET

	
;=============================显示标题栏子程序============================
HEADLINE PROC
	PUSH AX
	PUSH BX
	PUSH CX
	PUSH DX
	PUSH ES
	PUSH BP
	;功能描述：在TELETYPE模式下显示字符串
	;入口参数：AH＝13H    BH＝页码    BL＝属性(若AL=00H或 01H)  CX＝显示字符串长度  (DH、DL)＝坐标(行、列)
	;ES:BP＝显示字符串的地址 AL＝显示输出方式
	;0—— 字符串中只含显示字符，其显示属性在BL中。显示后，光标位置不变
	;1——字符串中只含显示字符，其显示属性在BL中。显示后，光标位置改变
	;2 ——字符串中含显示字符和显示属性。显示后，光标位置不变
	;3——字符串中含显示字符和显示属性。显示后，光标位置改变
	;16位色彩编码表 (D7 D6 D5 D4为背景色,D3 D2 D1 D0为前景色)
	;       ┏━━━━━━━━━━━┳━━━━━━━━━━━┓
	;       ┃   0 0 0 0     黑     ┃   1 0 0 0      灰    ┃
	;       ┃   0 0 0 1     蓝     ┃   1 0 0 1     浅蓝   ┃
	;       ┃   0 0 1 0     绿     ┃   1 0 1 0     浅绿   ┃
	;       ┃   0 0 1 1     青     ┃   1 0 1 1     浅青   ┃
	;       ┃   0 1 0 0     红     ┃   1 1 0 0     浅红   ┃
	;       ┃   0 1 0 1    品红    ┃   1 1 0 1    浅品红  ┃
	;       ┃   0 1 1 0     棕     ┃   1 1 1 0      黄    ┃
	;       ┃   0 1 1 1    灰白    ┃   1 1 1 1      白    ┃
	;       ┗━━━━━━━━━━━┻━━━━━━━━━━━┛
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
;=========================== DELAY子程序 ===========================
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
;======================= 新INT9中断处理程序 ========================
INT9: 
	PUSH AX
	PUSH BX
	PUSH ES

	IN  AL,60H
	MOV DL,AL

	PUSHF
	CALL DWORD PTR DS:[0] ;调用系统提供的中断处理程序——原来的INT9,进行中断调用的善后处理
	
	CMP DL,13H  ;'R'
	JZ  R1
	CMP DL,1CH  ;'回车'
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
	JZ  TRIANGLE	;三角形
	CMP DL,01H	;'ESC'
	JZ  ESC_QUIT	;退出系统
	JMP INT9RET
;============中断处理============
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
	CALL FIN_QUIT	;调用最终退出子程序退出整个系统
;============中断返回============
INT9RET:
	POP ES
	POP BX
	POP AX
	IRET
;========退出整个系统子程序===========
FIN_QUIT:	
	;****恢复中断向量****
	MOV AX,0
	MOV ES,AX

	CLI		;置屏蔽中断标志位
	PUSH DS:[0]
	POP  ES:[9*4]
	PUSH DS:[2]
	POP  ES:[9*4+2]	;将中断向量表中的INT 9 中断向量恢复
	STI		;取消屏蔽

	FULLCLEAR 00H,26,14,58,16
	;MOV  DX,OFFSET BYEBYE	;输出退出提示
	MOV AX,DS
	MOV ES,AX
	MOV BP,OFFSET BYEBYE	;显示“PRESS ENTER TO BEGIN INPUTTING”
	MOV AH,13H
	MOV AL,1
	MOV BH,0
	MOV BL,11110011B
	MOV CX,29
	MOV DL,28
	MOV DH,15
	INT 10H
	
	SETCURSOR 2,28
	MOV AX,4C00H	;返回DOS
	INT 21H
;-------------------------------------------------------
;======================画右斜线============================
RISING_SLASH PROC 	;上升斜线且斜率小于1（小于四十五度）
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
	MOV DX,DRAW_Y2	;画两点
	
	INT 10H
	MOV BX,DRAW_X2
	;MOV DX,DRAW_Y2	;画两点
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

	JMP  LOWER	;默认取Y=Y+1的点

LOWER:
	ADD SI,WORD PTR PK
	;ADD DI,WORD PTR PK
	;MOV PK,DI	;新的PK=PK+2DY
	MOV PK,SI
	JMP SEND_X_AND_Y
		;Y不变		
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
	;MOV PK,DI	;新的PK=PK+2DY-2DX
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
;============================画左斜线===============================
DECLINE PROC 	;斜率大于1（大于四十五度）
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
	MOV DX,DRAW_Y1	;画两点
	
	INT 10H
	MOV BX,DRAW_X0
	;画两点
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
	
	JMP  DE_LOWER	;默认取Y=Y+1的点

DE_LOWER:
	ADD SI,WORD PTR PK	;PK=PK+2DX
	
			;新的PK=PK+2DY
	MOV PK,SI	
	JMP DE_SEND_X_AND_Y

		;Y不变		
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

;音乐部分
;------------发声-------------
GENSOUND PROC NEAR
     PUSH AX
     PUSH BX
     PUSH CX
     PUSH DX
     PUSH DI

     MOV AL, 0B6H
     OUT 43H, AL			;8253初始化
     MOV DX, 12H
     					
     MOV AX, 348CH			;产生声音频率533H×896（348C）÷给定频率=123280H÷给定频率
     DIV DI				
     OUT 42H, AL			;先送低位

     MOV AL, AH
     OUT 42H, AL			;再送高位

     IN AL, 61H				;打开扬声器
     MOV AH, AL
     OR AL, 3				;把输出端口61H的PB0、PB1两位置1，发出声音
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
;--------------发声调用函数----------------
MUSIC PROC NEAR
	ADDRESS MUS_FREG, MUS_TIME
	XOR AX, AX
FREG1:
	MOV DI, [SI]
	CMP DI, 0FFFFH			;判断是否唱完
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