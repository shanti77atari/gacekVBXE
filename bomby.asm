//obsługuje bomby
bomba_x				org *+24
bomba_y				org *+24
bomba_anim_licznik	org *+24
bomba_anim_licznik1	org *+24
bomba_m_scr			org *+24
bomba_s_scr			org *+24
bomba_anim_faza		org *+24
bomba_anim_typ		org *+24
bomba_zapalona		org *+24
bomba_ch0			org *+24
bomba_ch1			org *+24
bomba_ch2			org *+24
bomba_ch3			org *+24
bomba_score_licznik	org *+24

bomba_ad0			org *+24
bomba_ad1			org *+24
bomba_zmiana		org *+24


BOMBA_ANIM_SPEED=2
MAX_BOMB=24-1

//tablica z nr znaków, po 4 na kazda faze animacji
tab_anim0		
				dta ch_bomb0,ch_bomb0+1,ch_bomb0+2,ch_bomb0+3,ch_bomb0+4,ch_bomb0+5,ch_bomb0+6,ch_bomb0+7,ch_bomb0+8,ch_bomb0+9,ch_bomb0+10,ch_bomb0+11,ch_bomb0+12,ch_bomb0+13,ch_bomb0+14,ch_bomb0+15		;zwykła bomba 4fazy x 4znaki na niebieskim tle
				dta ch_bomb1,ch_bomb1+1,ch_bomb1+2,ch_bomb1+3,ch_bomb1+4,ch_bomb1+5,ch_bomb1+6,ch_bomb1+7,ch_bomb1+8,ch_bomb1+9,ch_bomb1+10,ch_bomb1+11,ch_bomb1+12,ch_bomb1+13,ch_bomb1+14,ch_bomb1+15		;zwykła bomba 4fazy x 4znaki na brazowym tle
				dta ch_bomb0,ch_bomb0+1,ch_bomb0+2,ch_bomb0+3,ch_bomb2,ch_bomb2+1,ch_bomb2+2,ch_bomb2+3,ch_bomb0,ch_bomb0+1,ch_bomb0+2,ch_bomb0+3,ch_bomb0,ch_bomb0+1,ch_bomb0+2,ch_bomb0+3					;biala bomba na niebieskim tle
				dta ch_bomb1,ch_bomb1+1,ch_bomb1+2,ch_bomb1+3,ch_bomb3,ch_bomb3+1,ch_bomb3+2,ch_bomb3+3,ch_bomb1,ch_bomb1+1,ch_bomb1+2,ch_bomb1+3,ch_bomb1,ch_bomb1+1,ch_bomb1+2,ch_bomb1+3					;biala bomba na brazowym tle
				
			

.local bomb			


zgas_bonus
//zmazuje bonus rysowane na duszkach				
				ldx #7
@				lda sprite_score_licznik,x
				beq @+
				dec sprite_score_licznik,x
				bne @+
				
				mva #0 sprite_x,x
				sta sprite_typ,x
				dec ile_score
				
@				dex
				bne @-1


//gasi bonus po pewnym czasie
				ldx #MAX_BOMB
@				lda bomba_score_licznik,x
				beq @+
				dec bomba_score_licznik,x
				bne @+
				mva #-1 bomba_anim_faza,x
				mva #1 bomba_zmiana,x
							
				;jsr zmaz_bombe
				dec ile_score
@				dex
				bpl @-1
				
				
				

						
				rts
								
				
zgas_bombe
				ldx #MAX_BOMB
@				lda bomba_x,x
				beq @+
				lda bomba_zapalona,x
				beq @+
				
				mva #0 bomba_zapalona,x
				mva #1 bomba_zmiana,x
				mva #87 bomba_anim_faza,x

				rts
				
@				dex
				bpl @-1
				rts
				
animuj_bomby	
				lda ramka
				lsr
				bcs @+
				ldy	#$44
				mva	#$1d	(fx_ptr),y+	; CSEL ,nr koloru
				mva	#1	(fx_ptr),y	; PSEL	,nr palety

				ldy	#$46	; CR
				lda random
				sta	(fx_ptr),y+		;RED
				lda random
				sta (fx_ptr),y+	;GREEN
				lda random
				sta (fx_ptr),y		;BLUE
				ldy #$46
				lda random
				sta	(fx_ptr),y+		;RED
				lda random
				sta (fx_ptr),y+	;GREEN
				lda random
				sta (fx_ptr),y		;BLUE
@				rts

				

rysuj_bombe1
			pha
			tya
			pha
			
			ldy	#$5d	; MEMB		
			mva	#$80+[bcb_vbxe>>14]	(fx_ptr),y	; wlacz bank z duszkami
			
			mva #1 $4000+bcb_len-1+[bcb_vbxe&$3fff]		;teraz rysowania
			
			pla
			tay
			pla
			:3 asl
			sta $4006+[bcb_vbxe&$3fff]			;pozycja X
			sta bomba_ad0,x
			tya
			:3 asl
			sta $4007+[bcb_vbxe&$3fff]     	;pozycja Y
			sta bomba_ad1,x
			lda #87			;BOMBA
			sta $4001+[bcb_vbxe&$3fff]

			jsr multi.blit1	

			ldy #$5d
			mva #0 (fx_ptr),y		;wylacz pamiec vbxe
			sta bomba_zmiana,x
			sta bomba_score_licznik,x
			mva #87 bomba_anim_faza,x
			
			rts
			
dec_paraliz
			sta _dp0+1
			lda paraliz_flag
			bne @+
			lda sprite_typ+7			
			cmp #t_paraliz
			beq @+
			lda licznik_paraliz
			ora licznik_paraliz+1
			bne @+
			
			sec
			lda licznik1_paraliz
_dp0		sbc #1
			sta licznik1_paraliz
			bcc @+1
@			rts

@			
			mva #1 paraliz_flag				;zezwol na paraliz
			mva #19 licznik1_paraliz		;zeruj licznik
			rts		
							
nie_zapalona	
			lda #1
			jsr dec_paraliz

			stx last_bomba
			lda #2
			ldy #fx_bomba
			jsr sfx.add_fx
			
			ldy bonus
			lda score_tab0,y
			jsr score_add
			
			lda ile_bomb
			beq @+
			lda czy_zapalona
			beq *+3
@			rts
			inc czy_zapalona
			jmp zapal_bombe

			
zbieraj_bomby
			ldx #MAX_BOMB
@			lda bomba_x,x
			bne @+
nx_bmb		dex
			bpl @-
			rts
			
@			sec
			sbc sprite_x
			clc
			adc #4
			cmp #9
			bcs nx_bmb
			lda bomba_y,x
			sec
			sbc sprite_y
			clc
			adc #9
			cmp #19
			bcs nx_bmb

			
			
			dec ile_bomb
			mva #0 bomba_x,x			;nie ma juz bomby
			mva #-1 bomba_zmiana,x		;zmaz
			sta bomba_anim_faza,x		;nie rysuj nowej	
			stx last_bomba
			
			lda bomba_zapalona,x
			beq nie_zapalona
			
			lda #2
			jsr dec_paraliz	
			
			inc ile_zapalonych
			ldy bonus
			lda score_tab,y
			jsr score_add
			cpy #4
			bne *+7
			lda #$50					;1000=2x500
			jsr score_add	

			
			mva #90 bomba_anim_faza,x			;bonus=200
			mva #1 bomba_zmiana,x				;przerysuj tą bombkę
			
			mva #30 bomba_score_licznik,x
			inc ile_score
			
			lda #2
			ldy #fx_bomba1
			jsr sfx.add_fx			
			
			lda ile_bomb
			beq @+1
			
			
;wlaczamy nastepna bombe	
zapal_bombe
			ldx last_bomba
@			dex
			bpl *+4
			ldx #23
			lda bomba_x,x
			beq @-
			
			mva #1 bomba_zapalona,x
			sta bomba_zmiana,x
			mva #88 bomba_anim_faza,x
			
			
@			rts
			
			
			


score_tab	
			.he 20,40,60,80,50			;punkty dla zapalonej bomby
score_tab0	
			.he 10,20,30,40,50			;punkty dla zwykłej bomby
					
.endl		

score_add
			clc
			sed
			adc score
			sta score
			lda score+1
			adc #0
			sta score+1
			lda score+2
			adc #0
			cld
			sta score +2
			rts
			
score_addx100
			clc
			sed
			adc score+1
			sta score+1
			lda score+2
			adc #0
			cld
			sta score+2
			rts
			

				