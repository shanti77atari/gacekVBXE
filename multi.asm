//MULTI
//multiplekser
MAX_SPRITES	equ 8		
POSY_MIN		equ 16
POSY_MAX		equ 208
	
POSX_MIN		equ 64
POSX_MAX		equ 184

					.align
sprite_x			org *+MAX_SPRITES		;pozycja X obiektu
sprite_dx			org *+MAX_SPRITES		;pozycja X po przecinku
sprite_y			org *+MAX_SPRITES
sprite_dy			org *+MAX_SPRITES	
sprite_shape		org *+MAX_SPRITES		;ksztalt obiektu (obecny)
sprite_shape0		org *+MAX_SPRITES		;  -II-         początkowy
sprite_c0			org *+MAX_SPRITES		;kolor 0 obiektu
sprite_c1			org *+MAX_SPRITES		;kolor 1 obiektu
sprite_anim			org *+MAX_SPRITES		;liczba klatek animacji obiektu	(dowolna liczba)
sprite_anim_speed 	org *+MAX_SPRITES		;szybkość animacji obiektu  (1,3,7...)
sprite_mask 		org *+MAX_SPRITES		;maska potrzebna do animacji
sprite_typ			org *+MAX_SPRITES
tab_nr_pary			org *+MAX_SPRITES
tab_duch_dy			org *+MAX_SPRITES
sprite_ad0			org *+MAX_SPRITES
sprite_ad1			org *+MAX_SPRITES
sprite_draw		org *+MAX_SPRITES
sprite_score_licznik	org *+MAX_SPRITES

tab_sortowanie	
				:8 dta b(#)
				dta b(8)

blok_status		org *+32	;tablica pomocnicza do ustalenia zajętości duszków
blok_x01		org *+32	;pozycje pary duszków 0 i 1
blok_x23		org *+32	;pozycje pary duszków 2 i 3
blok_c0			org *+32	;kolor duszka 0

				.align
blok_c1			org *+32
blok_c2			org *+32
blok_c3			org *+32	
			
tab_nr_bloku		
				:9 dta b(255)

.local multi
spr_flag	equ pom0a
nr_duszka	equ pom0b
;poz_y		equ pom0c
duch_dy		equ pom0d


change_letter_color
		ldy	#$44
		mva	#$13	(fx_ptr),y+	; CSEL ,nr koloru
		mva	#1	(fx_ptr),y	; PSEL	,nr palety

		ldy	#$46+2	; CB
		lda zegar
		:4 asl
		sta (fx_ptr),y		;BLUE
		
		rts	

tab_p0r	.he ff,80,00,33
tab_p0g	.he 00,80,ff,00
tab_p0b	.he 33,80,33,ff

tab_p1r	.he cc,50,00,ff
tab_p1g	.he 00,50,cc,00
tab_p1b	.he ff,50,ff,cc

animuj
		jsr change_letter_color

		lda ramka
		sta _em2+1

		ldx #MAX_SPRITES-1
@		lda sprite_x,x
		bne @+
next	dex
		bpl @-
		rts
@				
		lda sprite_anim_speed,x
		bmi next
_em2	and #$ff
		bne next
		
		inc sprite_shape,x
		lda sprite_shape,x
		and sprite_mask,x
		cmp sprite_anim,x
		bcc *+4
		lda #0
		ora sprite_shape0,x
		sta sprite_shape,x
		jmp next
		
//inicjalizacja spritów
init_sprite
		lda #1
		tax
@		sta bit0-1,x
		inx
		asl
		bne @-
		mva #%110 bit12
		
		lda #$20
		:8 sta sprite_ad1+#
		
init_sprite1	

		;mva #MAX_SPRITES-1 start
		
init_sprite2
		ldx #$f9
		lda #0
@		sta sprites+$300,x			;wyczysc duszki
		sta sprites+$400,x
		sta sprites+$500,x
		sta sprites+$600,x
		sta sprites+$700,x
		dex
		bne @-			
			
		rts
		
hide_sprite
		ldx #7

@		lda sprite_draw,x
		beq @+
		
/*		ldy	#$5d	; MEMB		
		mva	#$80+[bcb_vbxe>>14]	(fx_ptr),y	; mbce  $80=dostep 6502+bank

		mva #19 $4001+[bcb_vbxe&$3fff]
		mva sprite_ad0,x $4006+[bcb_vbxe&$3fff]			;adres ostatniego rysowania duszka
		mva sprite_ad1,x $4007+[bcb_vbxe&$3fff]
		
		mva #0 $4000+bcb_len-1+[bcb_vbxe&$3fff]			;zmazywanie ,przepisuje bez sprawdzania
		sta sprite_draw,x
		jsr blit1  */
		
		mva #0 sprite_draw,x
		
@		dex
		bpl @-1	
		
		ldy #$5d
		mva	#0	(fx_ptr),y	; wylacz pamiec vbxe
		
@		equ *		
hide_sprite1
		lda #0
		sta hposp0s
		sta hposp0
		sta hposp1s
		sta hposp1
		sta hposp2s
		sta hposp2
		sta hposp3s
		sta hposp3
		sta hposm0s
		sta hposm0
		sta hposm1s
		sta hposm1
		sta hposm2s
		sta hposm2
		sta hposm3s
		sta hposm3
		rts


/*		
zmaz_bombeX
		ldy	#$5d	; MEMB		
		mva	#$80+[bcb_vbxe>>14]	(fx_ptr),y	; mbce  $80=dostep 6502+bank
		
		mva #19 $4001+[bcb_vbxe&$3fff]	;pusty klocek
		mva #0 $4000+bcb_len-1+[bcb_vbxe&$3fff]			;zmazywanie ,przepisuje bez sprawdzania
		sta bomba_zmiana,x
		mva bomba_ad0,x $4006+[bcb_vbxe&$3fff]			;pozycja bomby
		mva bomba_ad1,x $4007+[bcb_vbxe&$3fff]
		jsr blit1		
		
		
		ldy #$5d
		lda #0
		sta (fx_ptr),y		;wylacz pamiec vbxe
		rts */
		
zmaz_bomby
		ldy	#$5d	; MEMB		
		mva	#$80+[bcb_vbxe>>14]	(fx_ptr),y	; mbce  $80=dostep 6502+bank
		
		ldx #23
@		lda bomba_x,x
		bne @+
		lda bomba_score_licznik,x
		bne @+
		lda bomba_zmiana,x
		beq @+1		
@		
		lda #0
		sta bomba_zmiana,x
		sta bomba_score_licznik,x
		mva bomba_ad0,x $4006+[bcb3_vbxe&$3fff]			;pozycja bomby
		sta $4000+[bcb3_vbxe&$3fff]
		mva bomba_ad1,x $4007+[bcb3_vbxe&$3fff]
		sta $4001+[bcb3_vbxe&$3fff]
		jsr blit3



/*		mva #19 $4001+[bcb_vbxe&$3fff]	;pusty klocek
		mva #0 $4000+bcb_len-1+[bcb_vbxe&$3fff]			;zmazywanie ,przepisuje bez sprawdzania
		sta bomba_zmiana,x
		sta bomba_score_licznik,x
		
		mva bomba_ad0,x $4006+[bcb_vbxe&$3fff]			;pozycja bomby
		mva bomba_ad1,x $4007+[bcb_vbxe&$3fff]
		jsr blit1  */
		
@		dex
		bpl @-2
		
		ldy #$5d
		lda #0
		sta (fx_ptr),y		;wylacz pamiec vbxe
		rts
		
zmaz_duszki		
		ldy	#$5d	; MEMB		
		mva	#$80+[bcb_vbxe>>14]	(fx_ptr),y	; mbce  $80=dostep 6502+bank

		mva #2 $4002+[bcb_vbxe&$3fff]
		ldx #0
@		lda sprite_draw,x
		beq @+
		
		txa
		sta $4001+[bcb_vbxe&$3fff]				;żródło

		mva sprite_ad0,x $4006+[bcb_vbxe&$3fff]			;adres ostatniego rysowania duszka
		mva sprite_ad1,x $4007+[bcb_vbxe&$3fff]			;cel
		
		mva #0 $4000+bcb_len-1+[bcb_vbxe&$3fff]			;zmazywanie ,przepisuje bez sprawdzania
		jsr blit1						;zmaz	
	
		mva #0 sprite_draw,x
@		inx
		cpx #8
		bcc @-1
		
		ldy #$5d
		lda #0
		sta (fx_ptr),y		;wylacz pamiec vbxe
		rts			

tab_bonus equ *-1
		dta b(99,100,101,102)		;x2,x3,x4,x5
		
show_vbxe_sprites
;zmazywanie	
		ldy	#$5d	; MEMB		
		mva	#$80+[bcb_vbxe>>14]	(fx_ptr),y	; mbce  $80=dostep 6502+bank

		mva #2 $4002+[bcb_vbxe&$3fff]
		ldx #0
@		lda sprite_draw,x
		beq @+
		
;pusty klocek
		txa
		sta $4001+[bcb_vbxe&$3fff]				;żródło

		mva sprite_ad0,x $4006+[bcb_vbxe&$3fff]			;adres ostatniego rysowania duszka
		mva sprite_ad1,x $4007+[bcb_vbxe&$3fff]			;cel
		
		mva #0 $4000+bcb_len-1+[bcb_vbxe&$3fff]			;zmazywanie ,przepisuje bez sprawdzania
		jsr blit1						;zmaz	
	
		mva #0 sprite_draw,x
@		inx
		cpx #8
		bcc @-1
		
		
		mva #0 $4002+[bcb_vbxe&$3fff]
		
//bomby
		ldx #23
@		lda bomba_zmiana,x
		beq nxb

		


		;mva #19 $4001+[bcb_vbxe&$3fff]	;pusty klocek
		;mva #0 $4000+bcb_len-1+[bcb_vbxe&$3fff]			;zmazywanie ,przepisuje bez sprawdzania
		lda #0
		sta bomba_zmiana,x
		mva bomba_ad0,x $4006+[bcb3_vbxe&$3fff]			;pozycja bomby
		sta $4000+[bcb3_vbxe&$3fff]
		sta $4006+[bcb_vbxe&$3fff]	
		mva bomba_ad1,x $4007+[bcb3_vbxe&$3fff]
		sta $4001+[bcb3_vbxe&$3fff]
		sta $4007+[bcb_vbxe&$3fff]
		jsr blit3
		
		lda bomba_anim_faza,x					;jaki ksztalt
		bmi nxb									;nie ma czego rysowac
		
		cmp #90				;=bonus 200
		bne normal
		
;rysujemy bonus
		ldy bonus
		beq normal					;nie ma bonusu
		
		sta $4001+[bcb_vbxe&$3fff]				;200 punktów
		mva #$40 $4000+[bcb_vbxe&$3fff]		;pomiń 4 pierwsze puste linie (wyżej)
		mva #6-1 $400e+[bcb_vbxe&$3fff]		;wysokosc 6 linii
		mva #1 $4000+bcb_len-1+[bcb_vbxe&$3fff]			;teraz rysujemy
		jsr blit1
		ldy bonus
		lda tab_bonus,y
		sta $4001+[bcb_vbxe&$3fff]
		clc
		lda bomba_ad1,x
		adc #8
		sta $4007+[bcb_vbxe&$3fff]		;rysuj 8 linii niżej
		jsr blit1
		mva #0 $4000+[bcb_vbxe&$3fff]		;przywróć mlodszy bajt źródła
		mva #16-1 $400e+[bcb_vbxe&$3fff]		;przywróć wysokosc 16 linii	
		jmp nxb
		
normal		
		sta $4001+[bcb_vbxe&$3fff]
		mva #1 $4000+bcb_len-1+[bcb_vbxe&$3fff]			;teraz rysujemy
		jsr blit1
		
nxb		dex
		bpl @-	
		
	
		ldx #7	
;zapamietaj tlo pod duszkiem	
@		lda sprite_x,x
		beq @+
			
		sec
		sbc #$40
		pha
		lda sprite_dx,x
		asl
		pla
		rol
		sta $4006+[bcb_vbxe&$3fff]
		sta $4000+[bcb1_vbxe&$3fff]
		sta sprite_ad0,x
		mva #1 sprite_draw,x
		sec
		lda sprite_y,x
		sbc #$10
		sta $4007+[bcb_vbxe&$3fff]
		sta $4001+[bcb1_vbxe&$3fff]
		sta sprite_ad1,x
		txa
		sta $4007+[bcb1_vbxe&$3fff]		;gdzie zapisac tlo pod duszkiem
		jsr blit2

		jsr score_paraliz
		beq @+

;rysowanie		
		
		mva #1 $4000+bcb_len-1+[bcb_vbxe&$3fff]		;teraz rysowania
		ldy sprite_shape,x
		lda tab_vbxe_shape,y
		sta $4001+[bcb_vbxe&$3fff]
		jsr blit1
		
@		dex
		bpl @-1
	
		ldy #$5d
		lda #0
		sta (fx_ptr),y		;wylacz pamiec vbxe
		rts

score_paraliz
		lda sprite_typ,x
		bmi *+5
		lda #1
		rts

		and #127
		ldy bonus
		beq normal1					;nie ma bonusu
		
		sta $4001+[bcb_vbxe&$3fff]				;200 punktów
		mva #$40 $4000+[bcb_vbxe&$3fff]		;pomiń 4 pierwsze puste linie (wyżej)
		mva #6-1 $400e+[bcb_vbxe&$3fff]		;wysokosc 6 linii
		mva #1 $4000+bcb_len-1+[bcb_vbxe&$3fff]			;teraz rysujemy
		jsr blit1
		ldy bonus
		lda tab_bonus,y
		sta $4001+[bcb_vbxe&$3fff]
		clc
		lda sprite_ad1,x
		adc #8
		sta $4007+[bcb_vbxe&$3fff]		;rysuj 8 linii niżej
		jsr blit1	
		mva #16-1 $400e+[bcb_vbxe&$3fff]		;przywróć wysokosc 16 linii;  z=0
		mva #0 $4000+[bcb_vbxe&$3fff]		;przywróć mlodszy bajt źródła
		rts
		
normal1		
		sta $4001+[bcb_vbxe&$3fff]
		mva #1 $4000+bcb_len-1+[bcb_vbxe&$3fff]			;teraz rysujemy
		jsr blit1		;z=1
		lda #0
		rts
		
		
blit1	
		ldy	#$53	; BLITTER_BUSY
@		lda (fx_ptr),y
		bne @-

		ldy	#$50	; BL_ADR0
		mva	#bcb_vbxe&$ff	(fx_ptr),y+	; BL_ADR0			;najmlodszy bajt adresu
		mva	#[bcb_vbxe>>8]&$ff	(fx_ptr),y+	; BL_ADR1		;nastepne bajty adresu
		mva	#bcb_vbxe>>16	(fx_ptr),y+	; BL_ADR2
		mva	#1	(fx_ptr),y	; BLITTER_START				;wykonaj
		rts
		
blit2
		ldy	#$53	; BLITTER_BUSY
@		lda (fx_ptr),y
		bne @-

		ldy	#$50	; BL_ADR0
		mva	#bcb1_vbxe&$ff	(fx_ptr),y+	; BL_ADR0			;najmlodszy bajt adresu
		mva	#[bcb1_vbxe>>8]&$ff	(fx_ptr),y+	; BL_ADR1		;nastepne bajty adresu
		mva	#bcb1_vbxe>>16	(fx_ptr),y+	; BL_ADR2
		mva	#1	(fx_ptr),y	; BLITTER_START				;wykonaj
		rts	

blit3
		ldy	#$53	; BLITTER_BUSY
@		lda (fx_ptr),y
		bne @-

		ldy	#$50	; BL_ADR0
		mva	#bcb3_vbxe&$ff	(fx_ptr),y+	; BL_ADR0			;najmlodszy bajt adresu
		mva	#[bcb3_vbxe>>8]&$ff	(fx_ptr),y+	; BL_ADR1		;nastepne bajty adresu
		mva	#bcb3_vbxe>>16	(fx_ptr),y+	; BL_ADR2
		mva	#1	(fx_ptr),y	; BLITTER_START				;wykonaj		
		rts

tab_vbxe_shape	
		dta b(28,29,30,29,31,32,33,32,34,35,36,35)
		dta b(4,5,6,7,0,1,2,3,18,11,12,13,8,9,10,0,14,15,16,17)		;31
		dta b(41,42,43,44,45,46,47,48,49,0,0,0,37,38,39,40)			;47
		dta b(77,78,79,80,20,21,0,0,25,26,27,0,22,23,24,0)			;63
		dta b(73,74,75,76,61,62,63,64,65,66,67,68,69,70,71,72)		;79
		dta b(57,58,59,60,0,0,0,0,50,51,52,53,54,55,56,0)			;95
		dta b(81,82,83,84,85,86,0,0,103,104,105,106)				;107
		dta b(0,0,0,0,120,121,122,123,124,125,126,127)				;119  czapka=112
/*
//narysuj wszystkie duszki
show_sprites	
		jsr show_vbxe_sprites
		
		lda #0	
		sta blok_x01+1
		sta blok_x23+1
		sta hposp1s
		sta hposp0s
		sta hposp3s
		sta hposp2s
		
		mva #-1 pom0a
@		inc pom0a
		ldx pom0a
		ldy tab_sortowanie,x
		ldx tab_nr_bloku,y
		bpl *+3
		rts
		lda tab_nr_pary,y
		bne @+
		
		jsr print_sprite01
		lda tab_nr_bloku,y
		cmp #1
		bne @-
		lda blok_x01+1			;player 0 i 1
		sta hposp1s
		sta hposp0s
		lda blok_c0+1
		sta colpm0s
		lda blok_c1+1
		sta colpm1s		
		jmp @-
		
		
@		jsr print_sprite23
		lda tab_nr_bloku,y
		cmp #1
		bne @-1
		
		lda blok_x23+1			;player 2 i 3
		sta hposp3s
		sta hposp2s
		lda blok_c2+1
		sta colpm2s
		lda blok_c3+1
		sta colpm3s
		jmp @-1
		
		




print_sprite01
		tya
		bne *+3
		rts
		lda blok_x01+3,x	
		bne *+5
		inc blok_x01+3,x
				
		lda sprite_x,y		;sprite 0 i 1
		sta blok_x01,x

		lda sprite_c0,y
		sta blok_c0,x
		lda sprite_c1,y
		sta blok_c1,x
		
		ldx sprite_shape,y
		
		lda shape_bank,x
		sta portb

		lda shape_tab01,x
		sta _psp1+1
		lda shape_tab01+128,x
		sta _psp1+2		

		ldx sprite_y,y
_psp1	equ *		
		jsr $ffff

		mva #BANK_off portb
		
		ldx tab_duch_dy,y
		lda tab_skok01,x
		ldx sprite_y,y
		
		sta l01
		lda #0
l01	equ *+1		
		jmp dy0 

print_sprite23
		lda #2
		ora blok_status,x			;zajmij wybranego duszka w statusie
		sta blok_status,x
		lda #2
		ora blok_status+2,x		
		sta blok_status+2,x


		lda blok_x23+3,x
		bne *+5
		inc blok_x23+3,x
						
		lda sprite_x,y			;sprite 2 i 3
		sta blok_x23,x

		lda sprite_c0,y
		sta blok_c2,x
		lda sprite_c1,y
		sta blok_c3,x	
		
		ldx sprite_shape,y
		
		lda shape_bank,x
		sta portb

		lda shape_tab23,x
		sta _psp2+1
		lda shape_tab23+128,x
		sta _psp2+2
		

		ldx sprite_y,y
_psp2	equ *		
		jsr $ffff	

		mva #BANK_off portb
		

		ldx tab_duch_dy,y
		lda tab_skok23,x
		ldx sprite_y,y

		
		sta l23
		lda #0
l23	equ *+1		
		jmp dy0b



		.align	
//ksztalty dla duszków		
shape_tab01
		dta b(<bird0a,<bird1a,<bird2a,<bird1a)								;0 ptaszek w lewo
		dta b(<bird3a,<bird4a,<bird5a,<bird4a)								;4 ptaszek góra/dol
		dta b(<bird6a,<bird7a,<bird8a,<bird7a)								;8 ptaszek w prawo
		dta b(<jack_left0a,<jack_left1a,<jack_left2a,<jack_left3a)			;12 jack idzie w lewo
		dta b(<jack_right0a,<jack_right1a,<jack_right2a,<jack_right3a)		;16 jack idzie w prawo
		dta b(<jack_stoi0a,<jack_dol0a,<jack_dol1a,<jack_dol2a)				;20 jack stoi w miejscu,21 dol_srodek,22 dol_prawo,23 dol_lewo
		dta b(<jack_gora0a,<jack_gora1a,<jack_gora2a,0)					;24 jack gora_srodek,25 fora_prawo,26_gora_lewo
		dta b(<jack_spada0a,<jack_spada1a,<jack_upada0a,<jack_upada1a)		;28 jack spada w dol, 30 jack upada na platforme
		dta b(0,0,0,0)						;32 czapka
		dta b(<radar0a,<radar1a,<radar2a,<radar3a)							;36 radar
		dta b(<ufo0a,<ufo1a,<ufo2a,<ufo3a)									;40 ufo
		dta b(<globus0a,<globus1a,<globus2a,<globus3a)						;44 globus
		dta b(<explo0a,<explo1a,<explo2a,<explo3a)							;48 explo
		dta b(<mumia_spada0a,<mumia_spada1a,0,0)						;52 mumia spada
		dta b(<mumia_lewo0a,<mumia_lewo1a,<mumia_lewo2a,0)				;56 mumia_lewo
		dta b(<mumia_prawo0a,<mumia_prawo1a,<mumia_prawo2a,0)				;60 mumia_prawo
		dta b(<przemiana0a,<przemiana1a,<przemiana2a,<przemiana3a)			;64 przemiana
		dta b(<bonus0a,<bonus1a,<bonus2a,<bonus3a)							;68 bonus B
		dta b(<extra0a,<extra1a,<extra2a,<extra3a)							;72 extra_life E
		dta b(<paraliz0a,<paraliz1a,<paraliz2a,<paraliz3a)					;76 paraliż P
		dta b(<buzka3a,<buzka2a,<buzka1a,<buzka0a)							;80 buzki
		dta b(<oko0a,<oko1a,<oko2a,<oko3a)									;84 oko			;28 oko

		
		:40 dta b(0)  

		
;shape_tab
		dta b(>bird0a,>bird1a,>bird2a,>bird1a)								;0 ptaszek w lewo
		dta b(>bird3a,>bird4a,>bird5a,>bird4a)								;4 ptaszek góra/dol
		dta b(>bird6a,>bird7a,>bird8a,>bird7a)								;8 ptaszek w prawo
		dta b(>jack_left0a,>jack_left1a,>jack_left2a,>jack_left3a)			;12 jack idzie w lewo
		dta b(>jack_right0a,>jack_right1a,>jack_right2a,>jack_right3a)		;16 jack idzie w prawo
		dta b(>jack_stoi0a,>jack_dol0a,>jack_dol1a,>jack_dol2a)				;20 jack stoi w miejscu,21 dol_srodek,22 dol_prawo,23 dol_lewo
		dta b(>jack_gora0a,>jack_gora1a,>jack_gora2a,0)					;24 jack gora_srodek,25 fora_prawo,26_gora_lewo
		dta b(>jack_spada0a,>jack_spada1a,>jack_upada0a,>jack_upada1a)		;28 jack spada w dol, 30 jack upada na platforme
		dta b(0,0,0,0)						;32 czapka
		dta b(>radar0a,>radar1a,>radar2a,>radar3a)							;36 radar
		dta b(>ufo0a,>ufo1a,>ufo2a,>ufo3a)									;40 ufo
		dta b(>globus0a,>globus1a,>globus2a,>globus3a)						;44 globus
		dta b(>explo0a,>explo1a,>explo2a,>explo3a)							;48 explo
		dta b(>mumia_spada0a,>mumia_spada1a,0,0)						;52 mumia spada
		dta b(>mumia_lewo0a,>mumia_lewo1a,>mumia_lewo2a,0)				;56 mumia_lewo
		dta b(>mumia_prawo0a,>mumia_prawo1a,>mumia_prawo2a,0)				;60 mumia_prawo
		dta b(>przemiana0a,>przemiana1a,>przemiana2a,>przemiana3a)			;64 przemiana
		dta b(>bonus0a,>bonus1a,>bonus2a,>bonus3a)							;68 bonus B
		dta b(>extra0a,>extra1a,>extra2a,>extra3a)							;72 extra_life E
		dta b(>paraliz0a,>paraliz1a,>paraliz2a,>paraliz3a)					;76 paraliż P
		dta b(>buzka3a,>buzka2a,>buzka1a,>buzka0a)							;80 buzki
		dta b(>oko0a,>oko1a,>oko2a,>oko3a)	
		
	

		
		:40 dta b(0) 

shape_tab23
		dta b(<bird0b,<bird1b,<bird2b,<bird1b)								;0 ptaszek w lewo
		dta b(<bird3b,<bird4b,<bird5b,<bird4b)								;4 ptaszek góra/dol
		dta b(<bird6b,<bird7b,<bird8b,<bird7b)								;8 ptaszek w prawo
		dta b(0,0,0,0)			;12 jack idzie w lewo
		dta b(0,0,0,0)		;16 jack idzie w prawo
		dta b(0,0,0,0)				;20 jack stoi w miejscu,21 dol_srodek,22 dol_prawo,23 dol_lewo
		dta b(0,0,0,0)					;24 jack gora_srodek,25 fora_prawo,26_gora_lewo
		dta b(0,0,0,0)		;28 jack spada w dol, 30 jack upada na platforme
		dta b(0,0,0,0)						;32 czapka
		dta b(<radar0b,<radar1b,<radar2b,<radar3b)							;36 radar
		dta b(<ufo0b,<ufo1b,<ufo2b,<ufo3b)									;40 ufo
		dta b(<globus0b,<globus1b,<globus2b,<globus3b)						;44 globus
		dta b(<explo0b,<explo1b,<explo2b,<explo3b)							;48 explo
		dta b(<mumia_spada0b,<mumia_spada1b,0,0)						;52 mumia spada
		dta b(<mumia_lewo0b,<mumia_lewo1b,<mumia_lewo2b,0)				;56 mumia_lewo
		dta b(<mumia_prawo0b,<mumia_prawo1b,<mumia_prawo2b,0)				;60 mumia_prawo
		dta b(<przemiana0b,<przemiana1b,<przemiana2b,<przemiana3b)			;64 przemiana
		dta b(<bonus0b,<bonus1b,<bonus2b,<bonus3b)							;68 bonus B
		dta b(<extra0b,<extra1b,<extra2b,<extra3b)							;72 extra_life E
		dta b(<paraliz0b,<paraliz1b,<paraliz2b,<paraliz3b)					;76 paraliż P
		dta b(<buzka3b,<buzka2b,<buzka1b,<buzka0b)							;80 buzki
		dta b(<oko0b,<oko1b,<oko2b,<oko3b)									;84 oko			;28 oko		
		:40 dta b(0) 
		
		
		dta b(>bird0b,>bird1b,>bird2b,>bird1b)								;0 ptaszek w lewo
		dta b(>bird3b,>bird4b,>bird5b,>bird4b)								;4 ptaszek góra/dol
		dta b(>bird6b,>bird7b,>bird8b,>bird7b)								;8 ptaszek w prawo
		dta b(0,0,0,0)			;12 jack idzie w lewo
		dta b(0,0,0,0)		;16 jack idzie w prawo
		dta b(0,0,0,0)				;20 jack stoi w miejscu,21 dol_srodek,22 dol_prawo,23 dol_lewo
		dta b(0,0,0,0)					;24 jack gora_srodek,25 fora_prawo,26_gora_lewo
		dta b(0,0,0,0)		;28 jack spada w dol, 30 jack upada na platforme
		dta b(0,0,0,0)						;32 czapka
		dta b(>radar0b,>radar1b,>radar2b,>radar3b)							;36 radar
		dta b(>ufo0b,>ufo1b,>ufo2b,>ufo3b)									;40 ufo
		dta b(>globus0b,>globus1b,>globus2b,>globus3b)						;44 globus
		dta b(>explo0b,>explo1b,>explo2b,>explo3b)							;48 explo
		dta b(>mumia_spada0b,>mumia_spada1b,0,0)						;52 mumia spada
		dta b(>mumia_lewo0b,>mumia_lewo1b,>mumia_lewo2b,0)				;56 mumia_lewo
		dta b(>mumia_prawo0b,>mumia_prawo1b,>mumia_prawo2b,0)				;60 mumia_prawo
		dta b(>przemiana0b,>przemiana1b,>przemiana2b,>przemiana3b)			;64 przemiana
		dta b(>bonus0b,>bonus1b,>bonus2b,>bonus3b)							;68 bonus B
		dta b(>extra0b,>extra1b,>extra2b,>extra3b)							;72 extra_life E
		dta b(>paraliz0b,>paraliz1b,>paraliz2b,>paraliz3b)					;76 paraliż P
		dta b(>buzka3b,>buzka2b,>buzka1b,>buzka0b)							;80 buzki
		dta b(>oko0b,>oko1b,>oko2b,>oko3b)									;84 oko			;28 oko		
		:40 dta b(0)  

		
shape_bank
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK1,BANK1,BANK1,BANK1)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK0,BANK0,BANK0,BANK0)
		dta b(BANK1,BANK1,BANK1,BANK1)
		dta b(BANK1,BANK1,BANK1,BANK1)
		
		.align
		
		
tab_skok01	dta <dy0,<dy1,<dy2,<dy3,<dy4,<dy5,<dy6,<dy7		

		
dy0		
		sta sprites+$400+$11,x
		sta sprites+$500+$11,x

		sta sprites+$400+$10,x
		sta sprites+$500+$10,x
			
		sta sprites+$400-8,x
		sta sprites+$400-7,x
		sta sprites+$400-6,x
		sta sprites+$400-5,x
		sta sprites+$400-4,x
		sta sprites+$400-3,x
		sta sprites+$400-2,x
		sta sprites+$400-1,x
		
		sta sprites+$500-8,x		
		sta sprites+$500-7,x
		sta sprites+$500-6,x
		sta sprites+$500-5,x
		sta sprites+$500-4,x
		sta sprites+$500-3,x
		sta sprites+$500-2,x
		sta sprites+$500-1,x
		
		rts
		
dy1		
		sta sprites+$400-9,x
		sta sprites+$500-9,x
		jmp dy0+6
		
dy2	
		sta sprites+$400+$13,x
		sta sprites+$500+$13,x
		sta sprites+$400+$14,x
		sta sprites+$500+$14,x
		sta sprites+$400+$15,x
		sta sprites+$500+$15,x
		sta sprites+$400+$16,x
		sta sprites+$500+$16,x
		sta sprites+$400+$17,x
		sta sprites+$500+$17,x
		jmp dy7+30
		
dy3	
		sta sprites+$400+$13,x
		sta sprites+$500+$13,x
		sta sprites+$400+$14,x
		sta sprites+$500+$14,x
		sta sprites+$400+$15,x
		sta sprites+$500+$15,x
		sta sprites+$400+$16,x
		sta sprites+$500+$16,x
		jmp dy7+24
		
dy4
		sta sprites+$400+$13,x
		sta sprites+$500+$13,x
		sta sprites+$400+$14,x
		sta sprites+$500+$14,x
		sta sprites+$400+$15,x
		sta sprites+$500+$15,x
		jmp dy7+18		
		
		
dy5	
		cpx #POSY_MAX-32
		bcs dy7+12
		sta sprites+$400+$13,x
		sta sprites+$500+$13,x
		sta sprites+$400+$14,x
		sta sprites+$500+$14,x
		jmp dy7+12		
		
dy6		
		sta sprites+$400+$13,x
		sta sprites+$500+$13,x
		jmp dy7+6
		
dy7
		sta sprites+$400-7,x
		sta sprites+$500-7,x
		sta sprites+$400-6,x
		sta sprites+$500-6,x
		sta sprites+$400-5,x
		sta sprites+$500-5,x
		sta sprites+$400-4,x
		sta sprites+$500-4,x		
		sta sprites+$400-3,x
		sta sprites+$500-3,x
		sta sprites+$400-2,x
		sta sprites+$500-2,x
		sta sprites+$400-1,x		
		sta sprites+$500-1,x
		
		sta sprites+$400+$10,x		
		sta sprites+$400+$11,x
		sta sprites+$400+$12,x
		sta sprites+$500+$10,x		
		sta sprites+$500+$11,x
		sta sprites+$500+$12,x
		rts

		
		.align
		
tab_skok23	dta <dy0b,<dy1b,<dy2b,<dy3b,<dy4b,<dy5b,<dy6b,<dy7b		

		
dy0b	
		

		sta sprites+$600+$11,x
		sta sprites+$700+$11,x 
	
		sta sprites+$600+$10,x
		sta sprites+$700+$10,x
		
		sta sprites+$600-8,x
		sta sprites+$600-7,x
		sta sprites+$600-6,x
		sta sprites+$600-5,x
		sta sprites+$600-4,x
		sta sprites+$600-3,x
		sta sprites+$600-2,x
		sta sprites+$600-1,x
		
		sta sprites+$700-8,x		
		sta sprites+$700-7,x
		sta sprites+$700-6,x
		sta sprites+$700-5,x
		sta sprites+$700-4,x
		sta sprites+$700-3,x
		sta sprites+$700-2,x
		sta sprites+$700-1,x
		
		rts
		
dy1b		
		sta sprites+$600-9,x
		sta sprites+$700-9,x
		jmp dy0b+6
		
		
dy2b	
		sta sprites+$600+$13,x
		sta sprites+$700+$13,x
		sta sprites+$600+$14,x
		sta sprites+$700+$14,x
		sta sprites+$600+$15,x
		sta sprites+$700+$15,x
		sta sprites+$600+$16,x
		sta sprites+$700+$16,x
		sta sprites+$600+$17,x
		sta sprites+$700+$17,x
		jmp dy7b+30
		
dy3b	
		sta sprites+$600+$13,x
		sta sprites+$700+$13,x
		sta sprites+$600+$14,x
		sta sprites+$700+$14,x
		sta sprites+$600+$15,x
		sta sprites+$700+$15,x
		sta sprites+$600+$16,x
		sta sprites+$700+$16,x
		jmp dy7b+24
		
dy4b
		sta sprites+$600+$13,x
		sta sprites+$700+$13,x
		sta sprites+$600+$14,x
		sta sprites+$700+$14,x
		sta sprites+$600+$15,x
		sta sprites+$700+$15,x
		jmp dy7b+18
		
dy5b	
		sta sprites+$600+$13,x
		sta sprites+$700+$13,x
		sta sprites+$600+$14,x
		sta sprites+$700+$14,x
		jmp dy7b+12		
		
		
dy6b		
		sta sprites+$600+$13,x
		sta sprites+$700+$13,x
		jmp dy7b+6

dy7b
		sta sprites+$600-7,x
		sta sprites+$700-7,x
		sta sprites+$600-6,x
		sta sprites+$700-6,x
		sta sprites+$600-5,x
		sta sprites+$700-5,x
		sta sprites+$600-4,x
		sta sprites+$700-4,x		
		sta sprites+$600-3,x
		sta sprites+$700-3,x
		sta sprites+$600-2,x
		sta sprites+$700-2,x
		sta sprites+$600-1,x		
		sta sprites+$700-1,x
		
		sta sprites+$600+$10,x		
		sta sprites+$600+$11,x
		sta sprites+$600+$12,x
		sta sprites+$700+$10,x		
		sta sprites+$700+$11,x
		sta sprites+$700+$12,x
		rts	
		*/
.endl
		