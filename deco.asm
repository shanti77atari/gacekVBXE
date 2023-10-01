//dekompresja obrazka
.local deco
flaga=pom0h
wsk_y=pom0g
wsk1_y=pom0c
okno=pom0d
okno1=pom0f
ostatni_kod=pom0a
mapa		org *+1
mapa1=pom0b

tab_kolory	org *+48
mapa_okno_tab	.he 50,54,58,5c,60

init
			mwa #$8000 _ad_src+1			;źródło
			mwa #$4000 pom1		;cel
			mva #0 flaga
			
			ldy #$5e				;MEMAC_CONTROL, okno zrodlowe
			mva #$89 (fx_ptr),y	;$8000,dostęp cpu,wielkość 8K
			iny						;MEMAC_BANK_SEL
			ldx mapa
			lda mapa_okno_tab,x
			ora #$80
			sta (fx_ptr),y	
			sta mapa1
			
			ldy #16*3-1
@			lda $8000,y
			sta tab_kolory,y
			dey
			bpl @-
			
			ldy #$5e
			mva #0 (fx_ptr),y
			iny
			sta (fx_ptr),y
			
			mva #16*3 wsk_y
			mva #0 wsk1_y
			ldy #$5d
			mva #$80+[bufor_vbxe>>14] (fx_ptr),y
			sta okno			;okno docelowe
			
			mva #255 ostatni_kod
			
			ldy #$5e				;MEMAC_CONTROL, okno zrodlowe
			mva #$89 (fx_ptr),y	;$8000,dostęp cpu,wielkość 8K
			iny						;MEMAC_BANK_SEL
			lda mapa1
			sta (fx_ptr),y
			
			mva #208 pom0e			;ile linii
			
			mva fx_ptr+1 _ad2+2
			sta _ad0+23
			sta _ad1+23
			
			rts

get_byte				
			ldy wsk_y
_ad_src			
			lda $ffff,y
			
			ldx flaga
			bne @+
			:4 lsr
			inx
			inx
@			and #15
			dex
			stx flaga
			bne @+
			iny
			sty wsk_y
			bne @+
			inc _ad_src+2
			ldx _ad_src+2
			cpx #$a0
			bcc @+
			inc mapa1
			inc mapa1
			mvx #$80 _ad_src+2 
			
		
			ldx mapa1 
_ad2			
			stx $d75f
@			
			rts

			

.macro DRAW_BYTE			
			sta (pom1),y
			iny
			bne dbe
			dec pom0e
			beq _rts
			inc pom1+1
			bpl dbe
			mva #$40 pom1+1		;ustaw na poczatek okna			
			inc okno

			mva okno $d75d
			lda ostatni_kod
dbe			equ *
.endm
			

copy_screen
			jsr get_byte
			cmp #$0f
			bne normal
			jsr get_byte
			tax					;licznik
			inx
			ldy wsk1_y
			lda ostatni_kod
@	
_ad0		
			DRAW_BYTE
			dex
			bpl @-
			sty wsk1_y
			bmi copy_screen	;jmp
		
normal
			ora #192
			sta ostatni_kod
			ldy wsk1_y
_ad1			
			DRAW_BYTE
			sty wsk1_y
			jmp copy_screen
_rts			
@			rts						;koniec 	


set_colors
			ldy	#$44
			mva	#192	(fx_ptr),y+	; CSEL ,nr koloru
			mva	#1	(fx_ptr),y	; PSEL	,nr palety	

			ldx #0
@			ldy	#$46	; CR
			lda tab_kolory,x
			sta	(fx_ptr),y		;RED
			iny
			inx
			lda tab_kolory,x
			sta	(fx_ptr),y		;GREEN
			iny
			inx
			lda tab_kolory,x
			sta	(fx_ptr),y		;BLUE
			inx
			cpx #16*3
			bcc @-
			
			rts
			
draw_screen
		ldy	#$53	; BLITTER_BUSY
@		lda (fx_ptr),y
		bne @-

		ldy	#$50	; BL_ADR0
		mva	#bcb2_vbxe&$ff	(fx_ptr),y+	; BL_ADR0			;najmlodszy bajt adresu
		mva	#[bcb2_vbxe>>8]&$ff	(fx_ptr),y+	; BL_ADR1		;nastepne bajty adresu
		mva	#bcb2_vbxe>>16	(fx_ptr),y+	; BL_ADR2
		mva	#1	(fx_ptr),y	; BLITTER_START				;wykonaj
		
		rts	
		
start
			jsr init
			jsr copy_screen
			ldy #$5e				;MEMAC_CONTROL, okno zrodlowe
			lda #0
			sta (fx_ptr),y
			iny
			sta (fx_ptr),y
			ldy #$5d
			mva #0 (fx_ptr),y
			rts
			
blit4	
		ldy	#$53	; BLITTER_BUSY
@		lda (fx_ptr),y
		bne @-

		ldy	#$50	; BL_ADR0
		mva	#bcb4_vbxe&$ff	(fx_ptr),y+	; BL_ADR0			;najmlodszy bajt adresu
		mva	#[bcb4_vbxe>>8]&$ff	(fx_ptr),y+	; BL_ADR1		;nastepne bajty adresu
		mva	#bcb4_vbxe>>16	(fx_ptr),y+	; BL_ADR2
		mva	#1	(fx_ptr),y	; BLITTER_START				;wykonaj
		rts

blit5	
		ldy	#$53	; BLITTER_BUSY
@		lda (fx_ptr),y
		bne @-

		ldy	#$50	; BL_ADR0
		mva	#bcb5_vbxe&$ff	(fx_ptr),y+	; BL_ADR0			;najmlodszy bajt adresu
		mva	#[bcb5_vbxe>>8]&$ff	(fx_ptr),y+	; BL_ADR1		;nastepne bajty adresu
		mva	#bcb5_vbxe>>16	(fx_ptr),y+	; BL_ADR2
		mva	#1	(fx_ptr),y	; BLITTER_START				;wykonaj
		rts
		
rysuj_rampe1
		ldx ile_ramp
		bne *+3
		rts
		
		ldy	#$5d	; MEMB		
		mva	#$80+[bcb_vbxe>>14]	(fx_ptr),y	; mbce  $80=dostep 6502+bank
		
		
		
rp0		lda rampa_x1-1,x
		sta $4006+[bcb4_vbxe&$3fff]
		lda rampa_y1-1,x
		sta $4007+[bcb4_vbxe&$3fff]
		
		mva #115 $4001+[bcb4_vbxe&$3fff]			;starszy bajt ksztaltu
		
		lda rampa_dx1-1,x
		beq rysuj_pion
//rysujemy w  poziomie	
		sta pom0				;dlugosc
		
		mva #0 $4000+[bcb4_vbxe&$3fff]	;ksztalt
		
@		jsr blit4
		
		clc
		lda $4006+[bcb4_vbxe&$3fff]
		adc #8
		sta $4006+[bcb4_vbxe&$3fff]
		dec pom0
		bne @-
		dex
		bne rp0
		
		beq rp_end
		
rysuj_pion
		lda rampa_dy1-1,x
		sta pom0
		mva #64 $4000+[bcb4_vbxe&$3fff]	;ksztalt
		
@		jsr blit4
		
		clc
		lda $4007+[bcb4_vbxe&$3fff]
		adc #8
		sta $4007+[bcb4_vbxe&$3fff]
		dec pom0
		bne @-
		dex
		bne rp0
		
rp_end	
		ldx level
		lda POZ.rampa_tabx,x
		asl
		tax
		lda level_rampa_tab1,x
		sta pom1
		lda level_rampa_tab1+1,x
		beq @+1
		sta pom1+1
		
		ldy #0
		lda (pom1),y
		sta pom0
		
@		iny
		lda (pom1),y
		tax
		lda tab_rampa_znaki0,x
		sta $4000+[bcb4_vbxe&$3fff]			;ksztalt
		lda tab_rampa_znaki1,x
		sta $4001+[bcb4_vbxe&$3fff]	
		
		iny
		lda (pom1),y
		:3 asl
		sta $4006+[bcb4_vbxe&$3fff]
		iny
		lda (pom1),y
		:3 asl
		sta $4007+[bcb4_vbxe&$3fff]
		sty pom0a
		jsr blit4
		ldy pom0a
		dec pom0
		bne @-
		
	
@		ldy	#$5d	; MEMB		
		mva	#$00	(fx_ptr),y	; mbce  $80=dostep 6502+bank		
		
		rts	

tab_rampa_znaki0
		dta 128,192,0,64
tab_rampa_znaki1
		dta 115,115,116,116
		
poprawF
		dta b(2,0,23,11,3,23,18)
poprawH
		dta b(4,3,9,8,1,9,17,2,22,8,0,22,17)
poprawI
		dta b(2,3,14,17,2,11,23)
poprawJ
		dta b(4,0,5,5,2,5,20,1,26,5,3,26,20)
poprawL
		dta b(2,0,5,5,1,26,5)
poprawN
		dta b(4,1,18,3,0,2,11,3,29,14,2,13,22)
	
level_rampa_tab1
		dta a(0,0,0,0,0,poprawF,0,poprawH,poprawI,poprawJ,0,poprawL,0,poprawN)
		dta a(0,0)
	
start1
		ldy	#$44
		mva	#$28	(fx_ptr),y+	; CSEL ,nr koloru
		mva	#1	(fx_ptr),y	; PSEL	,nr palety
		
		ldy	#$46
		lda #0
		sta	(fx_ptr),y		;RED
		iny
		lda #$e0
		sta	(fx_ptr),y		;GREEN
		iny
		lda #0
		sta	(fx_ptr),y		;BLUE, nr_koloru++

		ldy	#$46
		lda #0
		sta	(fx_ptr),y		;RED
		iny
		sta	(fx_ptr),y		;GREEN
		iny
		sta	(fx_ptr),y		;BLUE, nr_koloru++

		mva #0 pom0a			;x0
		mva #256-64 pom0b		;x1

		ldy	#$5d	; MEMB		
		mva	#$80+[bcb_vbxe>>14]	(fx_ptr),y	; mbce  $80=dostep 6502+bank	
		ldx #48+1

@		mva #1 $4002+[bcb7_vbxe&$3fff]
		mva #4 $4008+[bcb7_vbxe&$3fff]
		jsr blit7
		

		mva #107 $4001+[bcb6_vbxe&$3fff]		;ksztalt
		mva pom0a $4006+[bcb6_vbxe&$3fff]		;pozycja X
		jsr blit6

		mva #111 $4001+[bcb6_vbxe&$3fff]		;ksztalt
		mva pom0b $4006+[bcb6_vbxe&$3fff]		;pozycja X
		jsr blit6

		jsr wait_vbl

		:2 inc pom0a
		:2 dec pom0b
		dex
		beq @+
				
		mva #4 $4002+[bcb7_vbxe&$3fff]
		mva #1 $4008+[bcb7_vbxe&$3fff]
		jsr blit7
		
		jmp @-
		
@		ldy	#$44
		mva	#$28	(fx_ptr),y+	; CSEL ,nr koloru
		mva	#1	(fx_ptr),y	; PSEL	,nr palety
		
		ldy	#$46
		lda #0
		sta	(fx_ptr),y		;RED
		iny
		sta	(fx_ptr),y		;GREEN
		iny
		sta	(fx_ptr),y		;BLUE, nr_koloru++

		ldy	#$46
		lda #$ff
		sta	(fx_ptr),y		;RED
		iny
		sta	(fx_ptr),y		;GREEN
		iny
		sta	(fx_ptr),y		;BLUE, nr_koloru++	
		
		
		ldx #35
@		jsr wait_vbl
		dex
		bne @-
		
		mva #4 $4002+[bcb7_vbxe&$3fff]
		mva #1 $4008+[bcb7_vbxe&$3fff]
		jsr blit7
		
		
		
		
		ldy	#$5d	; MEMB		
		mva	#0	(fx_ptr),y	; mbce  $80=dostep 6502+bank	
		rts
		

blit6	
		ldy	#$53	; BLITTER_BUSY
@		lda (fx_ptr),y
		bne @-

		ldy	#$50	; BL_ADR0
		mva	#bcb6_vbxe&$ff	(fx_ptr),y+	; BL_ADR0			;najmlodszy bajt adresu
		mva	#[bcb6_vbxe>>8]&$ff	(fx_ptr),y+	; BL_ADR1		;nastepne bajty adresu
		mva	#bcb6_vbxe>>16	(fx_ptr),y+	; BL_ADR2
		mva	#1	(fx_ptr),y	; BLITTER_START				;wykonaj
		rts
		
blit7	
		ldy	#$53	; BLITTER_BUSY
@		lda (fx_ptr),y
		bne @-

		ldy	#$50	; BL_ADR0
		mva	#bcb7_vbxe&$ff	(fx_ptr),y+	; BL_ADR0			;najmlodszy bajt adresu
		mva	#[bcb7_vbxe>>8]&$ff	(fx_ptr),y+	; BL_ADR1		;nastepne bajty adresu
		mva	#bcb7_vbxe>>16	(fx_ptr),y+	; BL_ADR2
		mva	#1	(fx_ptr),y	; BLITTER_START				;wykonaj
		rts	

over
		ldy	#$5d	; MEMB		
		mva	#$80+[bcb8_vbxe>>14]	(fx_ptr),y

		
		mva sprite_x $4000+[bcb8_vbxe&$3fff]		;pozX
		sta $4006+[bcb9_vbxe&$3fff]
		sta $4006+[bcb10_vbxe&$3fff]
		mva sprite_y $4001+[bcb8_vbxe&$3fff]		;pozY
		sta $4007+[bcb9_vbxe&$3fff]
		sta $4007+[bcb10_vbxe&$3fff]

		jsr blit8				;zapamietaj tlo
		jsr blit10				;narysuj napis
		
		jsr wait_vbl
		
		;jsr blit9				;zmaz
		;ldy	#$5d	; MEMB		
		;mva	#0	(fx_ptr),y

		jsr change_colors
		
		;jsr rmt_play0
		
		lda sprite_x
		cmp #112
		beq @+
		bcc _plus
		:2 dec sprite_x
_plus	inc sprite_x
		jmp go2
		
@		lda sprite_y
		cmp #92
		beq go3
		bcc _plusy
		dec sprite_y
		dec sprite_y
_plusy	inc sprite_y		
		
		
go2		jsr blit9				;zmaz
		ldy	#$5d	; MEMB		
		mva	#0	(fx_ptr),y

		jsr rmt_play0
		jmp over		
		
go3		mva #0 zegar
@		jsr wait_vbl
		jsr rmt_play0
		jsr change_colors
		lda zegar
		cmp #250
		bcc @-
		
		ldy	#$5d	; MEMB		
		mva	#0	(fx_ptr),y

		rts
		
licz_kolor	dta b(0)		
		
change_colors
			lda zegar
			and #3
			bne @+

			ldy	#$44
			mva	#$1f	(fx_ptr),y+	; CSEL ,nr koloru
			mva	#1	(fx_ptr),y	; PSEL	,nr palety
			
			inc licz_kolor
			lda licz_kolor
			lsr
			and #7
			tax
			
			ldy	#$46	; CR
			lda tab_rnd_kolor0,x
			sta	(fx_ptr),y		;RED
			iny
			lda tab_rnd_kolor1,x
			sta	(fx_ptr),y		;GREEN
			iny
			lda tab_rnd_kolor2,x
			sta	(fx_ptr),y		;BLUE, nr_koloru++
@			rts	

tab_rnd_kolor0	.he aa,aa,00,00,00,aa,aa,22
tab_rnd_kolor1	.he 00,aa,aa,00,aa,00,aa,aa
tab_rnd_kolor2	.he 00,00,00,aa,aa,aa,aa,22
		
		
blit8	
		ldy	#$53	; BLITTER_BUSY
@		lda (fx_ptr),y
		bne @-

		ldy	#$50	; BL_ADR0
		mva	#bcb8_vbxe&$ff	(fx_ptr),y+	; BL_ADR0			;najmlodszy bajt adresu
		mva	#[bcb8_vbxe>>8]&$ff	(fx_ptr),y+	; BL_ADR1		;nastepne bajty adresu
		mva	#bcb8_vbxe>>16	(fx_ptr),y+	; BL_ADR2
		mva	#1	(fx_ptr),y	; BLITTER_START				;wykonaj
		rts			

blit9	
		ldy	#$53	; BLITTER_BUSY
@		lda (fx_ptr),y
		bne @-

		ldy	#$50	; BL_ADR0
		mva	#bcb9_vbxe&$ff	(fx_ptr),y+	; BL_ADR0			;najmlodszy bajt adresu
		mva	#[bcb9_vbxe>>8]&$ff	(fx_ptr),y+	; BL_ADR1		;nastepne bajty adresu
		mva	#bcb9_vbxe>>16	(fx_ptr),y+	; BL_ADR2
		mva	#1	(fx_ptr),y	; BLITTER_START				;wykonaj
		rts	
		
blit10	
		ldy	#$53	; BLITTER_BUSY
@		lda (fx_ptr),y
		bne @-

		ldy	#$50	; BL_ADR0
		mva	#bcb10_vbxe&$ff	(fx_ptr),y+	; BL_ADR0			;najmlodszy bajt adresu
		mva	#[bcb10_vbxe>>8]&$ff	(fx_ptr),y+	; BL_ADR1		;nastepne bajty adresu
		mva	#bcb10_vbxe>>16	(fx_ptr),y+	; BL_ADR2
		mva	#1	(fx_ptr),y	; BLITTER_START				;wykonaj
		rts			

.endl