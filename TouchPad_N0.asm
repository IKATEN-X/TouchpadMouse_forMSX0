BEEP	EQU	00C0H 
GTTRIG  EQU 00D8H 
GTPAD	EQU	00DBH
LDIRVM 	EQU	005CH
SETWRT  EQU 0053H

SPRATR 	EQU	01B00H
SPRTBL	EQU	03800H
PTNMTBL EQU	01800H

H_TIMI  EQU 0FD9FH
JPCODE	EQU	0C3H
VDP_DW	EQU	0007h

	ORG	0C000H
    
	JP SWHOOK
    JP GETVL
    JP GETADR
    
SWHOOK:
	CP 2	;INT?
    RET NZ
    
    INC HL
    INC HL
    LD A,(HL)
    OR A
    JP Z,HOOKON
    JP HOOKOFF
    
GETADR:
	CP 2	;INT?
    RET NZ
    
    PUSH HL
	LD HL,(VADR)
    EX DE,HL
    POP HL
    INC HL
    INC HL
    LD (HL),E
    INC HL
    LD (HL),D
    RET

GETVL:
	CP 2	;INT?
    RET NZ
    
    INC HL
    INC HL
    PUSH HL
    LD C,(HL)
    INC HL
    LD B,(HL)
    LD HL,TPFLG
    ADD HL,BC
    LD A,(HL)
    POP HL
    LD (HL),A
    INC HL
    LD (HL),0
    LD A,C
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
    
;	LD HL,SPR
;	LD DE,SPRTBL
;	LD BC,8
;	CALL LDIRVM
    
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
    PUSH AF
	LD A,(TN)
    LD (TP),A

	LD A,1
	CALL GTTRIG
	LD (TN),A
    LD A,(TP)
	OR A
    JP NZ,GETPAD
    LD A,(TN)
	OR A
    JP Z,GETPAD
    LD A,1
    LD (TPFLG),A
    
GETPAD:
	LD A,12
	CALL GTPAD
    
	LD A,13
	CALL GTPAD
	LD (DX),A
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

	LD A,14
	CALL GTPAD
	LD (DY),A

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


FIN:
	OR A
    LD H,0
    RLA
    RL H
    RLA
    RL H		;HL=(Y\8)*32 = (Y*4) AND FFE0
    AND 0E0H
    LD L,A
    
    LD A,(X);
	RRA
    RRA
    RRA
    AND 00011111B ;A = X \ 8
    LD C,A
    LD B,0
    ADD HL,BC
	;LD DE,PTNMTBL    
	;ADD HL,DE
	LD (VADR),HL

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
	ORG 0C300H
DX: DB 0
DY: DB 0
TM:	DB 0
CNT: DB 0
VADR:DW 1111
HKMODE:DB 0
