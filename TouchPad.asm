GTPAD	EQU	00DBH
LDIRVM 	EQU	005CH
SETWRT  EQU 0053H

SPRATR 	EQU	01B00H
SPRTBL	EQU	03800H

H_TIMI  EQU 0FD9FH
JPCODE	EQU	0C3H
VDP_DW	EQU	0007h

	ORG	0C000H
    
	JP SWHOOK		;HOOKのON/OFF (0:ON/1:OFF)
    JP GETVL		;状態取得 (タップ:0/Y:1/X:1)
    JP GETADR		;W32*H24時のカーソル座標のテキストバッファ上の相対アドレス取得
    
SWHOOK:				;HOOKのON/OFF
	CP 2			;INT?
    RET NZ
    
    INC HL
    INC HL
    LD A,(HL)		;USRのパラメーターをAに取得(1バイト）
    OR A
    JP Z,HOOKON		;0:ON/1:OFF
    JP HOOKOFF
    
GETADR:				;W32*H24時のカーソル座標のテキストバッファ上の相対アドレス取得
	CP 2			;INT?
    RET NZ
    
    PUSH HL
	LD HL,(VADR)	;値をAレジスタに取得
    EX DE,HL
    POP HL
    INC HL
    INC HL
    LD (HL),E		;返り値に格納
    INC HL
    LD (HL),D
    RET

GETVL:
	CP 2			;INT?
    RET NZ
    
    INC HL
    INC HL
    PUSH HL
    LD C,(HL)	;USRのパラメーターをBCに取得（2バイト）
    INC HL
    LD B,(HL)
    LD HL,TPFLG	;ワーク基準アドレス:TPFLG
    ADD HL,BC	;ワーク基準アドレス + BC
    LD A,(HL)	;値をAに取得
    POP HL
    LD (HL),A	;返り値に格納（1バイト）
    INC HL
    LD (HL),0
    LD A,C		;TPFLG取得時はTPFLGを0にリセット
    OR A
    RET NZ
    XOR A
    LD (TPFLG),A
    RET
    
    
HOOKON:
    LD A,(HKMODE)
    OR A
    RET NZ
    CPL
    LD (HKMODE),A
    
    DI
	LD	HL,H_TIMI	;OLD HOOK SAVE
	LD	DE,HKSAVE
	LD	BC,5
	LDIR

	LD	A,JPCODE	;NEW HOOK SET
	LD	(H_TIMI),A
	LD	HL,HOOK
	LD	(H_TIMI+1),HL
	EI
	RET
    
HOOKOFF:
	LD A,(HKMODE)
    OR A
    RET Z
    XOR A
    LD (HKMODE),A
    
	DI
	LD	HL,HKSAVE	;RECOVER HOOK
	LD	DE,H_TIMI
	LD	BC,5
	LDIR
	EI
	RET
    
;----- interrupt routine -----
HOOK:
    PUSH    AF
    
    ;LD HL,SPRATR+(4*31)	;スプライトアトリビュートテーブル31番にマウス座標を書き込む
    ;CALL SETWRT
	;LD HL,Y
    ;DEC (HL)
    ;LD	A,(VDP_DW)
	;LD	C,A
    ;OUTI
    ;OUTI
    ;OUTI
    ;OUTI
	;LD HL,Y
    ;INC (HL)
    
    ;LD A,(CNT)				;カーソル色変え(Color 14 or 15)
    ;INC A
    ;LD (CNT),A
    ;AND 1
    ;JP NZ,GETPAD

	;LD HL,CL
    ;LD A,(HL)
    ;CP 15
    ;JR NZ,SPRCL2

    ;LD (HL),14
    ;JP GETPAD
;SPRCL2:	
	;LD (HL),15

GETPAD:
	LD A,(NX)
	LD (PX),A
	LD A,(NY)
	LD (PY),A
	LD A,5
	CALL GTPAD		;NX=PAD(5)
	LD (NX),A
	LD A,6
	CALL GTPAD		;NY=PAD(6)
	LD (NY),A

	LD A,(TN)
	LD (TP),A		;TP=TN
	LD A,4
	CALL GTPAD		;TP=PAD(4)
    LD (TN),A

L110:
	OR A		;IF NOT TN THEN 120
	JP Z,L120
    LD A,(TM)
    INC A
    CP 128
    JR NC,L115
    LD (TM),A

L115:
	LD A,(TP)	;IF TP=0 THEN TIME=0 ELSE 
	OR A
	JP Z,L115_2
    
	LD A,(TM) 	;IF TIME>4 THEN 130
	CP 5
	JP NC,L130
	JP L116
    
L115_2:
	XOR A
	LD (TM),A
		
L116:			;GOTO 190
 	JP FIN

L120:
	LD A,(TP)	;IF NOT TP THEN 190
	OR A
	JP Z,FIN
L123:
	LD A,(TM)	;IF TIME<5 THEN BEEP:LOCATE 0,0:? X;Y
	CP 5
	;CALL C,BEEP
    JR NC,L125
    LD A,1
    LD (TPFLG),A
L125:
	JP FIN		;GOTO 190

L130:			;PX=NX:PY=NY:NX=PAD(5):NY=PAD(6)


L140:			;DX=NX-PX:DY=NY-PY:IF ABS(DX)<64 AND ABS(DY)<64 THEN 
	LD A,(PX)
	LD B,A
	LD A,(NX)
	SUB	B
	LD (DX),A

	LD A,(PY)
	LD B,A
	LD A,(NY)
	SUB	B
	LD (DY),A
	
	LD A,(DX)
	OR A
	JP P,L140_1
	NEG
    
L140_1:
    CP 128
    JP NC,FIN

	LD A,(DY)
	OR A
	JP P,L140_2
	NEG

L140_2:
	CP 128
	JP NC,FIN
	
L150:				;X=X+(DX*1.5):IF X<0 THEN X=0 ELSE IF X>255 THEN X=255
	LD A,(DX)
    OR A
    JP P,PLUS_X
    
    NEG
PLUS_X:
	LD H,0
    LD L,A
    SRA A
    LD B,0
    LD C,A
    ADD HL,BC	;HL=DX*1.5
    LD B,H
    LD C,L		;BC=HL
	LD A,(X)
    LD L,A
    LD H,0

	LD A,(DX)
    OR A
    JP M,MINUS_X

    ADD HL,BC
    LD A,H
    OR A
    LD A,L
    JP Z,SAVEX
    LD A,255
	JP SAVEX
    
MINUS_X:
    OR A
    SBC HL,BC
    LD A,H
    OR A
    LD A,L
    JP Z,SAVEX
    XOR A
SAVEX:
	LD (X),A

L160:			;Y=Y+(DY*1.5):IF Y<0 THEN Y=0 ELSE IF Y>191 THEN Y=191
	LD A,(DY)
    OR A
    JP P,PLUS_Y
    
    NEG
PLUS_Y: 
	LD H,0
    LD L,A
    SRA A
    LD B,0
    LD C,A
    ADD HL,BC	;HL=DY*1.5
    LD B,H
    LD C,L		;BC=HL
	LD A,(Y)
    LD L,A
    LD H,0
    
    LD A,(DY)
    OR A
    JP M,MINUS_Y
    
    ADD HL,BC
    LD D,H
    LD E,L
    LD BC,191
    OR A
    SBC HL,BC
    LD A,E
    JP C,SAVEY
    LD A,191
	JP SAVEY
    
MINUS_Y:
    OR A
    SBC HL,BC
    
    LD A,H
    OR A
    LD A,L
    JP Z,SAVEY
    XOR A
SAVEY:
	LD (Y),A

FIN:				;マウスカーソル座標のバッファアドレス計算( (Y\8)*32 + (X\8) )
	LD A,(Y)
	OR A
    LD H,0
    RLA
    RL H
    RLA
    RL H				;HL=(Y\8)*32 = (Y*4) AND &HFFE0
    AND 0E0H
    LD L,A
    
    LD A,(X);
	RRA
    RRA
    RRA
    AND 00011111B 		;A = X \ 8
    LD C,A
    LD B,0
    ADD HL,BC
	LD (VADR),HL		;マウスカーソル座標のバッファアドレス格納

	POP AF
	JP    HKSAVE
	;RET

HKSAVE: DB 0,0,0,0,0
        
TP: DB	0
TN: DB	0
TPFLG:DB 0
Y:	DB	100
X:	DB	128
PT:	DB	0
CL:	DB	15
PX:	DB 128
PY:	DB 100
NX: DB 128
NY: DB 100
DX: DB 0
DY: DB 0
TM:	DB 0
CNT: DB 0
VADR:DW 1111
HKMODE:DB 0
;SPR: DB 080H,0C0H,0E0H,0F0H,0F8H,0E0H,0B0H,010H
