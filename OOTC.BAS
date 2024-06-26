10 '=================-===========
12 ' Order of the colors. v.1.1
13 '           Auther by IKATEN.
14 '                 2024.06.22
15 '=============================
20 COLOR 15,4,4:SCREEN 1,2:WIDTH 32:KEY OFF:CLEAR 2000
25 DEFUSR=&H7E:A=USR(0)
30 BLOAD"PAT.SC2",S:BLOAD"CAL.SC2",S
40 BLOAD"program.bin"
50 DEFUSR=&HC000:DEFUSR1=&HC003:DEFUSR2=&HC006:A=USR(0)
60 DEFINT A-Z:R=RND(-TIME)
70 DIM AS(10),QT(10),BY(10),CX(15)
80 FOR J=0 TO 5:SP$="":FOR I=0 TO 31:READ A$:SP$=SP$+CHR$(VAL("&H"+A$)):NEXT:SPRITE$(J)=SP$:NEXT
90 X=128:Y=100:CM=1:MC(0)=15:MC(1)=14:CI=0:PS=0:ST=0
100 ON INTERVAL=6 GOSUB 980
110 CB$="":FOR I=138 TO 152:CB$=CB$+CHR$(I)+CHR$(I):NEXT
120 CT$=STRING$(30,CHR$(134)):CU$=STRING$(30,CHR$(135))
130 O1$=CHR$(157)+CHR$(157)+CHR$(158)+CHR$(159)+CHR$(157)+CHR$(157)
135 O2$=CHR$(165)+CHR$(165)+CHR$(166)+CHR$(167)+CHR$(165)+CHR$(165)
140 S1$=CHR$(157)+CHR$(157)+CHR$(160)+CHR$(161)+CHR$(162)+CHR$(163)+CHR$(161)+CHR$(157)+CHR$(157)
142 S2$=CHR$(165)+CHR$(165)+CHR$(168)+CHR$(169)+CHR$(170)+CHR$(171)+CHR$(169)+CHR$(165)+CHR$(165)
145 LC$=STRING$(32," ")
147 FOR I=0 TO 9:BY(I)=48+(IMOD5)*16:NEXT
148 FOR I=0 TO 14:CX(I)=I*16+8:NEXT
149 SG=1:M2=0
150 INTERVAL ON:GOSUB 200
160 GOSUB 370
170 SG=SG+1:M1=M1+1:IF M1>M2 THEN M2=M1
175 IF SG<=30 THEN 160
180 GOSUB 1120
190 GOTO 150
200 '----- TITLE
210 M1=0:FOR I=1 TO 10:PUT SPRITE I,(0,209):NEXT
220 CM=1:CLS:PS=0:GOSUB 1110
230 LOCATE 6,8:PRINT "Order of the colors"
232 LOCATE 7,17:PRINT USING "Reached stage:###";SG
236 LOCATE 4,18:PRINT USING "Consecutive stages:###";M2
240 CX=11:CY=14:CD=1:CS$=S1$:LOCATE CX,CY:PRINT CS$:GOSUB 1090
245 CX=11:CY=15:CD=1:CS$=S2$:LOCATE CX,CY:PRINT CS$:GOSUB 1090
250 CM=0
260 IF PD<>1 THEN 260
265 PLAY "T180 O5 L8 V15 C E G O6 C E G o7 C R L16 O7 C O6 B A G F E D C o5 b a g f e d c8"
270 RETURN
370 '----- GAME
380 SB=-1:LF=2:CM=1:CLS:PS=0:GOSUB 1110:LOCATE 6,0:PRINT USING "STAGE:###  LEFT:###";SG;LF
390 MX=(SG-1)\3:IF MX>9 THEN MX=9
400 FOR I=0 TO MX:QT(I)=RND(1)*14+1:NEXT:FOR I=MX+1 TO 9:QT(I)=0:NEXT:FOR I=0 TO 25:SWAP QT(RND(1)*10),QT(RND(1)*10):NEXT
410 FOR I=0 TO 9:AS(I)=0:NEXT
420 BX=80:CX=10:FOR B=0 TO 4:BC=QT(B)+1:GOSUB 1040
430 CY=6+B*2:CD=B:CS$="  ":GOSUB 1090:CY=CY+1:GOSUB 1090:NEXT
440 BX=152:CX=19:FOR B=5 TO 9:BC=QT(B)+1:GOSUB 1040
450 CY=6+(BMOD5)*2:CD=B:CS$="  ":GOSUB 1090:CY=CY+1:GOSUB 1090:NEXT
460 LOCATE 1,17:PRINT CT$
465 LOCATE 0,18:PRINT CHR$(136);CB$;CHR$(137):LOCATE 0,19:PRINT CHR$(136);CB$;CHR$(137)
467 LOCATE 1,20:PRINT CU$
470 CX=1:CY=18:CS$=CB$:GOSUB 1100
475 CX=1:CY=19:CS$=CB$:GOSUB 1100
480 PLAY "T120 O5 L16 V15 C E G o6 C R D F A R E G o6 C R C o5 G C R"
490 LOCATE 4,2:PRINT"Please remember    "
500 LOCATE 4,3:PRINT" the order of the colors.":TM=0
510 LOCATE 14,5:PRINT 10-TM\10
515 IF TM<102 THEN 510
520 LOCATE 0,2:PRINT LC$;LC$;LC$;LC$;
530 IF SG>1 THEN 660
540 PLAY "t180 l32 v13 o7 cg"
550 LOCATE 3,2:PRINT"You can change the color "
560 LOCATE 3,3:PRINT"  of the balls by clicking"
570 LOCATE 3,4:PRINT"    on the color bar.":TM=0
580 IF TM<50 THEN 580
590 LOCATE 0,2:PRINT LC$;LC$;LC$;
600 PLAY "t180 l32 v13 o7 cg"
610 LOCATE 4,2:PRINT"Once you have ordered"
620 LOCATE 4,3:PRINT" the colors "
630 LOCATE 4,4:PRINT"  in the remembered order,
640 LOCATE 4,5:PRINT" press the OK button.":TM=0
650 IF TM<50 THEN 650
660 FOR I=2 TO 5:LOCATE 0,I:PRINT LC$;:NEXT
670 CX=13:CY=22:CD=32:CS$=O1$:LOCATE CX,CY:PRINT CS$;:GOSUB 1090
675 CX=13:CY=23:CD=32:CS$=O2$:LOCATE CX,CY:PRINT CS$;:GOSUB 1090
680 LOCATE 6,0:PRINT USING "STAGE:###  LEFT:###";SG;LF
690 BX=80:FOR B=0 TO 4:BC=AS(B)+1:GOSUB 1040:NEXT
700 BX=152:FOR B=5 TO 9:BC=AS(B)+1:GOSUB 1040:NEXT
705 ' GAME LOOP
710 CM=0
720 IF PD=255 THEN 720 ELSE CM=1:PP=PD
730 IF PP=32 THEN 810
750 IF PP<16 THEN SB=PP:GOTO 770 ' SELECT BALL
760 SC=PP-138:IF SB>-1 THEN AS(SB)=SC ' SELECT COLOR
770 IF SB>4 THEN BX=152 ELSE BX=80
780 IF SB=-1 THEN 710
785 IF AS(SB)=14 THEN BC=7 ELSE BC=15
787 PUT SPRITE 1,(BX,BY(SB)),BC,5
790 PUT SPRITE 12,(CX(AS(SB)),143),BC,4:PD=255
795 B=SB:BC=AS(B)+1:GOSUB 1040
800 GOTO 710
810 CX=12:CY=22:CD=255:CS$="       ":LOCATE CX,CY:PRINT CS$;:GOSUB 1090
815 CX=12:CY=23:CD=255:CS$="       ":LOCATE CX,CY:PRINT CS$;:GOSUB 1090
820 CR=0:FOR I=0 TO 9:IF QT(I)=AS(I) THEN CR=CR+1:NEXT
830 TM=0:PD=255:IF CR<10 THEN 860
840 GOSUB 975:PLAY"t150l16o6s1m10000ececec4" 'CLEAR
850 IF TM<30 THEN 850 ELSE 970
860 LF=LF-1:PLAY"t150l16o2v13cr16c4" 'FAIL
870 IF TM<30 THEN 870 ELSE IF LF>=0 THEN 670
880 BX=80:FOR B=0 TO 4:BC=QT(B)+1:GOSUB 1040:NEXT
890 BX=152:FOR B=5 TO 9:BC=QT(B)+1:GOSUB 1040:NEXT
900 GOSUB 975: LOCATE 0,17:PRINT LC$;LC$;LC$;LC$;
905 TM=0:PLAY "T180 O4 L8 V15 C E G C6 R E D C R G F E R E D C4" 'GAMEOVER
910 LOCATE 8,10:PRINT "== GAME OVER =="
920 FOR I=0 TO 9:EL(I)=I+2:NEXT:FOR I=0 TO 29:SWAP EL(RND(1)*10),EL(RND(1)*10):NEXT
930 FOR I=0 TO 9:PUT SPRITE EL(I),(0,209):TM=0
940 IF TM<1 THEN 940
950 NEXT
960 IF TM<30 THEN 960 ELSE RETURN 150
970 INTERVAL ON:RETURN
975 '===== REMOVE SELECT SPRITE
977 PUT SPRITE 1,(0,209):PUT SPRITE 12,(0,209):RETURN
980 '===== MOUSE
990 TM=TM+1:IF TM>1000 THEN TM=1000
1000 Y=USR1(1):X=USR1(2)
1010 PUT SPRITE 0,(X,Y-1),MC(CI),CM:CI=CIXOR1
1020 IF USR1(0) AND CM=0 THEN AD=USR2(1)+&HD000:PD=PEEK(AD) ELSE PD=255
1030 RETURN
1040 '==== PUT BALL
1050 IF BC=4 THEN BP=3:BC=5 ELSE BP=2
1060 PUT SPRITE B+2,(BX,BY(B)),BC,BP
1070 RETURN
1080 '===== WRITE CLICK POINT
1090 AD=&HD000+CY*32+CX:FOR I=AD TO AD+LEN(CS$):POKE I,CD:NEXT:RETURN
1100 AD=&HD000+CY*32+CX:FOR I=1 TO LEN(CS$):POKE AD+I-1,ASC(MID$(CS$,I,1)):NEXT:RETURN
1110 '===== CLEAR SCREEN BUFFER
1115 FOR I=&HD000 TO &HD2FF:POKE I,255:NEXT:RETURN
1120 '===== ENDING
1130 FOR I=1 TO 12:PUT SPRITE I,(0,209):NEXT
1140 CM=1:CLS:PS=0:GOSUB 1110
1145 PLAY"T150L8O5l16 cr16 cr16 r8 o4b4.r4 ar16 ar16 r8 o4g4.r4 l8cdefg b4go5c2"
1150 LOCATE 7,10:PRINT "Congratulations!!"
1160 LOCATE 6,12:PRINT "You did a great job!":TIME=0
1165 IF TIME<360 THEN 1165
1170 CX=13:CY=15:CD=1:CS$=O1$:LOCATE CX,CY:PRINT CS$;:GOSUB 1090
1175 CX=13:CY=16:CD=1:CS$=O2$:LOCATE CX,CY:PRINT CS$;:GOSUB 1090
1180 CM=0
1185 IF PD<>1 THEN 1185
1190 RETURN
10120 '===== SPRITE DATA
10130 DATA 80,C0,E0,F0,F8,E0,B0,10,00,00,00,00,00,00,00,00
10140 DATA 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
10150 DATA FC,68,78,30,30,48,68,FC,00,00,00,00,00,00,00,00
10160 DATA 00,00,00,00,00,00,00,00,00,00,00,00,00,00,00,00
10170 DATA 00,07,1F,3F,3F,7F,7F,7F,7F,7F,7F,3F,3F,1F,07,00
10180 DATA 00,E0,F8,FC,FC,FE,FE,FE,FE,FE,FE,FC,FC,F8,E0,00
10190 DATA 00,07,18,20,20,40,40,40,40,40,40,20,20,18,07,00
10200 DATA 00,E0,18,04,04,02,02,02,02,02,02,04,04,18,E0,00
10210 DATA FF,FF,C0,C0,C0,C0,C0,C1,C1,C0,C0,C0,C0,C0,FF,FF
10220 DATA FF,FF,03,03,03,03,03,83,83,03,03,03,03,03,FF,FF
10230 DATA 03,0C,10,20,40,40,80,80,80,80,40,40,20,10,0C,03
10240 DATA C0,30,08,04,02,02,01,01,01,01,02,02,04,08,30,C0
