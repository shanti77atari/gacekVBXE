//inicjalizacja vbxe
shape_vbxe=$00000
xdl_vbxe=$70800
bcb_vbxe=$70880
bcb1_vbxe=$70900
bcb2_vbxe=$70980
bcb3_vbxe=$70a00
bcb4_vbxe=$70a80
bcb5_vbxe=$70b00
bcb6_vbxe=$70b80
bcb7_vbxe=$70c00
bcb8_vbxe=$70c80
bcb9_vbxe=$70d00
bcb10_vbxe=$70d80
bcb11_vbxe=$70e00
bcb12_vbxe=$70e80
scr_vbxe=$10000
bufor_vbxe=$30000		;do rozpakowania tła


shape_WIDTH=16
shape_HEIGHT=16

			
_init				
			jsr fx_detect
			beq @+
			jmp (10)
@			equ *			


//clear VBXE		
			ldy	#$40	; VIDEO_CONTROL			blokujemy vbxe
			mva	#0	(fx_ptr),y	; xdl_disabled

			ldy	#$5d	; MEMB		
			mva	#$80+[bcb_vbxe>>14]	(fx_ptr),y	; mbce  $80=dostep 6502+bank
			mwa	#cls_bcb	pom2
			jsr	blit							;skopiuj procedure i wyczysc ekran
			
//WAIT for BLITTER
			ldy	#$53	; BLITTER_BUSY
@			lda (fx_ptr),y
			bne @-	
			
//COPY SHAPE		
			ldy #$5d
			mva #$80+[shape_vbxe>>14] (fx_ptr),y

			mwa #76 pom0
			mwa #$4000 pom1				;jack right 4 klatki;0
			mwa #$8000+[15*76] pom
			jsr copy_shape			
			mwa #$8000+[15*76]+20 pom
			jsr copy_shape			
			mwa #$8000+[15*76]+40 pom
			jsr copy_shape		
			mwa #$8000+[15*76]+60 pom
			jsr copy_shape
			
			
			
			mwa #jack_left+[15*76] pom		;jack left 4 klatki;4
			jsr copy_shape
			mwa #jack_left+[15*76]+20 pom		
			jsr copy_shape
			mwa #jack_left+[15*76]+40 pom		
			jsr copy_shape
			mwa #jack_left+[15*76]+60 pom		
			jsr copy_shape
			
			mwa #160 pom0
			mwa #jack_lata+[15*160] pom		;jack gora_srodek	;8
			jsr copy_shape
			mwa #jack_lata+[15*160]+80 pom		;jack gora_prawo;9	
			jsr copy_shape
			mwa #jack_lata+[15*160]+120 pom		;jack gora_lewo;10
			jsr copy_shape
			mwa #jack_lata+[15*160]+20 pom		;jack dol_srodek;11
			jsr copy_shape
			mwa #jack_lata+[15*160]+100 pom		;jack dol_prawo;12
			jsr copy_shape
			mwa #jack_lata+[15*160]+140 pom		;jack dol_lewo;13
			jsr copy_shape
			
			mwa #36 pom0
			mwa #jack_spada+[15*36] pom		;jack_spada0	;14
			jsr copy_shape			
			mwa #jack_spada+[15*36]+20 pom		;jack_spada1	;15
			jsr copy_shape
			
			mwa #44 pom0
			mwa #jack_upada+[15*44] pom		;jack_upada0	;16
			jsr copy_shape			
			mwa #jack_upada+[15*44]+24 pom		;jack_upada1	;17
			jsr copy_shape
			
			mwa #16 pom0
			mwa #jack_stoi+[15*16] pom		;jack_stoi	;18
			jsr copy_shape		

			mwa #empty+[15*16] pom		;pusty klocek ;19
			jsr copy_shape
			
			mwa #348 pom0
			mwa #mumia0+[348*15] pom	;	mumia_spada0		;20
			jsr copy_shape		
			mwa #mumia0+[348*15]+20 pom	;	mumia_spada1	;21
			jsr copy_shape		
			mwa #mumia0+[348*15]+38+1 pom	;	mumia_prawo0	;22
			jsr copy_shape		
			mwa #mumia0+[348*15]+55 pom	;	mumia_prawo1	;23
			jsr copy_shape	
			mwa #mumia0+[348*15]+71 pom	;	mumia_prawo2	;24
			jsr copy_shape	
			mwa #mumia0+[348*15]+85 pom	;	mumia_lewo0	;25
			jsr copy_shape	
			mwa #mumia0+[348*15]+101 pom	;	mumia_lewo1	;26
			jsr copy_shape	
			mwa #mumia0+[348*15]+117 pom	;	mumia_lewo2	;27
			jsr copy_shape	
			mwa #mumia0+[348*15]+136 pom	;	ptak_lewo0		;28
			jsr copy_shape	
			mwa #mumia0+[348*15]+156 pom	;	ptak_lewo1		;29
			jsr copy_shape	
			mwa #mumia0+[348*15]+176 pom	;	ptak_lewo2		;30
			jsr copy_shape	
			mwa #mumia0+[348*15]+197 pom	;	ptak_srodek0	;31
			jsr copy_shape	
			mwa #mumia0+[348*15]+217 pom	;	ptak_srodek1	;32
			jsr copy_shape
			mwa #mumia0+[348*15]+237 pom	;	ptak_srodek2	;33
			jsr copy_shape
			mwa #mumia0+[348*15]+136 pom	;	ptak_prawo0	;34
			jsr copy_shape1	
			mwa #mumia0+[348*15]+156 pom	;	ptak_prawo1	;35
			jsr copy_shape1	
			mwa #mumia0+[348*15]+176 pom	;	ptak_prawo2	;36
			jsr copy_shape1
			mwa #mumia0+[348*15]+276 pom	;	radar0			;37
			jsr copy_shape	
			mwa #mumia0+[348*15]+296 pom	;	radar1			;38
			jsr copy_shape	
			mwa #mumia0+[348*15]+312 pom	;	radar2			;39
			jsr copy_shape	
			mwa #mumia0+[348*15]+328 pom	;	radar0			;40
			jsr copy_shape	
			
			
//xdlist	
			ldy	#$5d	; MEMB
			mva	#$80+[xdl_vbxe>>14]	(fx_ptr),y	; mbce
		
			ldy	#xdl_len-1
@			lda xdl,y
			sta $4000+[xdl_vbxe&$3fff],y		;przygotuj do skopiowania do vbxe
			dey
			bpl @-
			
			ldy	#$40	; VIDEO_CONTROL
			mva	#1	(fx_ptr),y	; xdl_enabled
			iny
			mva	#xdl_vbxe&$ff	(fx_ptr),y	; XDL_ADR0			podaj adres 24bitowy
			iny
			mva	#[xdl_vbxe>>8]&$ff	(fx_ptr),y	; XDL_ADR1
			iny
			mva	#xdl_vbxe>>16	(fx_ptr),y	; XDL_ADR2
			
//paleta	, losowe wartosci	
			jsr set_colors
			
			ldy	#$5d	; MEMB		
			mva	#$80+[bcb_vbxe>>14]	(fx_ptr),y	; mbce  $80=dostep 6502+bank
			mwa	#bcb	pom2
			
			ldy	#bcb_len-1
@			lda (pom2),y
			sta $4000+[bcb_vbxe&$3fff],y
			dey
			bpl @-		

			mwa #bcb1 pom2
			ldy	#bcb1_len-1
@			lda (pom2),y
			sta $4000+[bcb1_vbxe&$3fff],y
			dey
			bpl @-	

			mwa #bcb2 pom2
			ldy	#bcb2_len-1
@			lda (pom2),y
			sta $4000+[bcb2_vbxe&$3fff],y
			dey
			bpl @-	

			mwa #bcb3 pom2
			ldy	#bcb3_len-1
@			lda (pom2),y
			sta $4000+[bcb3_vbxe&$3fff],y
			dey
			bpl @-		

			mwa #bcb4 pom2
			ldy	#bcb4_len-1
@			lda (pom2),y
			sta $4000+[bcb4_vbxe&$3fff],y
			dey
			bpl @-	

			mwa #bcb5 pom2
			ldy	#bcb5_len-1
@			lda (pom2),y
			sta $4000+[bcb5_vbxe&$3fff],y
			dey
			bpl @-	

			mwa #bcb6 pom2
			ldy	#bcb6_len-1
@			lda (pom2),y
			sta $4000+[bcb6_vbxe&$3fff],y
			dey
			bpl @-	

			mwa #bcb7 pom2
			ldy	#bcb7_len-1
@			lda (pom2),y
			sta $4000+[bcb7_vbxe&$3fff],y
			dey
			bpl @-				
			
			mwa #bcb8 pom2
			ldy	#bcb8_len-1
@			lda (pom2),y
			sta $4000+[bcb8_vbxe&$3fff],y
			dey
			bpl @-	

			mwa #bcb9 pom2
			ldy	#bcb9_len-1
@			lda (pom2),y
			sta $4000+[bcb9_vbxe&$3fff],y
			dey
			bpl @-	

			mwa #bcb10 pom2
			ldy	#bcb10_len-1
@			lda (pom2),y
			sta $4000+[bcb10_vbxe&$3fff],y
			dey
			bpl @-				
			
			mwa #bcb11 pom2
			ldy	#bcb11_len-1
@			lda (pom2),y
			sta $4000+[bcb11_vbxe&$3fff],y
			dey
			bpl @-	

			mwa #bcb12 pom2
			ldy	#bcb12_len-1
@			lda (pom2),y
			sta $4000+[bcb12_vbxe&$3fff],y
			dey
			bpl @-			
			
end_init			
			ldy #$5d
			mva #0 (fx_ptr),y			;wylacz pamiec vbxe

			rts
			
_init1
			ldy #$5d
			mva #$80+[shape_vbxe>>14] (fx_ptr),y

			mwa #320 pom0
			mwa #globus0+[15*320]+1 pom	
			jsr copy_shape		;globus0		;41
			mwa #globus0+[15*320]+21 pom	
			jsr copy_shape		;globus1		;42
			mwa #globus0+[15*320]+41 pom	
			jsr copy_shape		;globus2		;43
			mwa #globus0+[15*320]+61 pom	
			jsr copy_shape		;globus3		;44
			mwa #globus0+[15*320]+81 pom	
			jsr copy_shape		;globus4		;45
			mwa #globus0+[15*320]+101 pom	
			jsr copy_shape		;globus5		;46
			mwa #globus0+[15*320]+121 pom	
			jsr copy_shape		;globus6		;47
			mwa #globus0+[15*320]+141 pom	
			jsr copy_shape		;globus7		;48
			mwa #globus0+[15*320]+161 pom	
			jsr copy_shape		;globus8		;49
			mwa #globus0+[15*320]+181 pom	
			jsr copy_shape		;kula0			;50
			mwa #globus0+[15*320]+201 pom	
			jsr copy_shape		;kula1			;51
			mwa #globus0+[15*320]+221 pom	
			jsr copy_shape		;kula2			;52
			mwa #globus0+[15*320]+241 pom	
			jsr copy_shape		;kula3			;53
			mwa #globus0+[15*320]+261 pom	
			jsr copy_shape		;kula4			;54
			mwa #globus0+[15*320]+281 pom	
			jsr copy_shape		;kula5			;55
			mwa #globus0+[15*320]+301 pom	
			jsr copy_shape		;kula6			;56
			
			mwa #64 pom0
			mwa #buzka0+[15*64] pom	
			jsr copy_shape		;buzka0			;57
			mwa #buzka0+[15*64]+16 pom	
			jsr copy_shape		;buzka1			;58
			mwa #buzka0+[15*64]+32 pom	
			jsr copy_shape		;buzka2			;59
			mwa #buzka0+[15*64]+48 pom	
			jsr copy_shape		;buzka3			;60
			
			mwa #140 pom0
			mwa #literki0+[15*140] pom	
			jsr copy_shape		;literaB0			;61
			mwa #literki0+[15*140]+19+1 pom	
			jsr copy_shape		;literaB1			;62
			mwa #literki0+[15*140]+36 pom	
			jsr copy_shape		;literaB2			;63
			
			
			ldy #$5d
			mva #$80+[shape_vbxe>>14]+1 (fx_ptr),y
			mwa #$4000 pom1
			mwa #literki0+[15*140]+51+1 pom	
			jsr copy_shape		;literaB3			;64
			mwa #literki0+[15*140]+72 pom	
			jsr copy_shape		;literaE0			;65
			mwa #literki0+[15*140]+91+1 pom	
			jsr copy_shape		;literaE1			;66
			mwa #literki0+[15*140]+108 pom	
			jsr copy_shape		;literaE2			;67
			mwa #literki0+[15*140]+123+1 pom	
			jsr copy_shape		;literaE3			;68
			
			mwa #64 pom0
			mwa #paraliz0+[15*64] pom	
			jsr copy_shape		;Paraliz0			;69
			mwa #64 pom0
			mwa #paraliz0+[15*64]+16 pom	
			jsr copy_shape		;Paraliz1			;70
			mwa #64 pom0
			mwa #paraliz0+[15*64]+32 pom	
			jsr copy_shape		;Paraliz2			;71
			mwa #64 pom0
			mwa #paraliz0+[15*64]+48 pom	
			jsr copy_shape		;Paraliz3			;72
			
			mwa #przemiana0+[15*64] pom	
			jsr copy_shape		;Przemiana0		;73
			mwa #64 pom0
			mwa #przemiana0+[15*64]+16 pom	
			jsr copy_shape		;Przemiana1		;74
			mwa #64 pom0
			mwa #przemiana0+[15*64]+32 pom	
			jsr copy_shape		;Przemiana2		;75
			mwa #64 pom0
			mwa #przemiana0+[15*64]+48 pom	
			jsr copy_shape		;Przemiana3		;76
			
			mwa #explo0+[15*64] pom	
			jsr copy_shape		;explo0			;77
			mwa #64 pom0
			mwa #explo0+[15*64]+16 pom	
			jsr copy_shape		;explo1			;78
			mwa #64 pom0
			mwa #explo0+[15*64]+32 pom	
			jsr copy_shape		;explo2			;79
			mwa #64 pom0
			mwa #explo0+[15*64]+48 pom	
			jsr copy_shape		;explo3			;80
			
			mwa #120 pom0
			mwa #ufo0+[15*120] pom	
			jsr copy_shape		;ufo0			;81
			mwa #ufo0+[15*120]+20 pom	
			jsr copy_shape		;ufo0			;82
			mwa #ufo0+[15*120]+40 pom	
			jsr copy_shape		;ufo0			;83
			mwa #ufo0+[15*120]+60 pom	
			jsr copy_shape		;ufo0			;84
			mwa #ufo0+[15*120]+80 pom	
			jsr copy_shape		;ufo0			;85
			mwa #ufo0+[15*120]+100 pom
			jsr copy_shape		;ufo0			;86
			
			mva #100 pom0
			mwa #bomby0+[15*100]+40 pom
			jsr copy_shape						;87
			mva #100 pom0
			mwa #bomby0+[15*100]+60 pom
			jsr copy_shape						;88
			rts
			
		
_init2			
			mwa #180 pom0
			mwa #punkty0+[15*180] pom	
			jsr copy_shape		;100		;89
			mwa #punkty0+[15*180]+16 pom	
			jsr copy_shape		;200		;90
			mwa #punkty0+[15*180]+32 pom	
			jsr copy_shape		;300		;91
			mwa #punkty0+[15*180]+48 pom	
			jsr copy_shape		;500		;92
			mwa #punkty0+[15*180]+64 pom	
			jsr copy_shape		;800		;93
			mwa #punkty0+[15*180]+82 pom	
			jsr copy_shape		;1000		;94
			mwa #punkty0+[15*180]+102 pom	
			jsr copy_shape		;1200		;95
			mwa #punkty0+[15*180]+122 pom	
			jsr copy_shape		;2000		;96
			mwa #punkty0+[15*180]+142 pom	
			jsr copy_shape		;3000		;97
			mwa #punkty0+[15*180]+162 pom	
			jsr copy_shape		;5000		;98
			
			mwa #52 pom0
			mwa #xpunkty0+[15*52] pom	
			jsr copy_shape		;x2		;99
			mwa #xpunkty0+[15*52]+12 pom	
			jsr copy_shape		;x3		;100
			mwa #xpunkty0+[15*52]+24 pom	
			jsr copy_shape		;x4		;101
			mwa #xpunkty0+[15*52]+36 pom	
			jsr copy_shape		;x5		;102
			
			mwa #56 pom0
			mwa #jack_tanczy0+[15*56]+20 pom	
			jsr copy_shape				;103
			mwa #jack_tanczy0+[15*56]+20 pom	
			jsr copy_shape1			;104
			mwa #jack_tanczy0+[15*56] pom	
			jsr copy_shape				;105
			mwa #jack_tanczy0+[15*56]+40 pom	
			jsr copy_shape				;106
		
			mwa #64 pom0
			mva #64-1 copy_shape+3
			mwa #start0+[15*64] pom	;107
			jsr copy_shape
			mwa #start0+[15*64]+1024 pom	;111
			jsr copy_shape
			
			mwa #8 pom0
			mva #8 copy_shape+1
			mva #8-1 copy_shape+3			;8x8
			mwa #rampa0+[7*8] pom	
			jsr copy_shape		;rampa_poziom	;115
			mwa #rampa0+[7*8]+64 pom
			jsr copy_shape		;rampa_pion		;115.25
			mwa #rampa0+[7*8]+128 pom	
			jsr copy_shape		;rampa_lewo_gora	;115.50
			mwa #rampa0+[7*8]+192 pom	
			jsr copy_shape		;rampa_prawo_gora	;115.75
			mwa #rampa0+[7*8]+256 pom	
			jsr copy_shape		;rampa_lewo_dol		;116.00
			mwa #rampa0+[7*8]+320 pom	
			jsr copy_shape		;rampa_prawo_dol	;116.25
			
			inc pom1+1
			mva #0 pom1		;wyrownaj do strony
			
			mwa #32 pom0		;szerokosc obrazka
			mva #24 copy_shape+1		;liczba wierszy
			mva #32-1 copy_shape+3		;liczba kolumn
			mwa #over0+[23*32] pom
			jsr copy_shape			;117 game over (zajmuje 3 strony)
			
			mwa #76 pom0
			mva #16	copy_shape+1
			mva #16-1 copy_shape+3
			mwa #czapka0+[15*76] pom
			jsr copy_shape			;120	czapka0 w lewo
			mwa #czapka0+[15*76]+20 pom
			jsr copy_shape			;121	czapka1 w lewo
			mwa #czapka0+[15*76]+40 pom
			jsr copy_shape			;122	czapka2 w lewo
			mwa #czapka0+[15*76]+60 pom
			jsr copy_shape			;123	czapka3 w lewo
			mwa #czapka0+[15*76] pom
			jsr copy_shape1			;124	czapka0 w prawo
			mwa #czapka0+[15*76]+20 pom
			jsr copy_shape1			;125	czapka1 w prawo
			mwa #czapka0+[15*76]+40 pom
			jsr copy_shape1			;126	czapka2 w prawo
			mwa #czapka0+[15*76]+60 pom
			jsr copy_shape1			;127	czapka3 w prawo
		
			rts
			
_init2b		
			ldy #$5d
			mva #$80+[shape_vbxe>>14]+2 (fx_ptr),y
			mwa #$4000 pom1			;wyrownuje do 16K czyli pomijamy 8 stron
			mwa #192 pom0
			mva #40 copy_shape2+1
			mva #192-1 copy_shape2+3
			mwa #title0b+[192*39] pom	;192x40
			jsr copy_shape2				;128 
			rts
			
_init2c		
			ldy #$5d
			mva #$80+[shape_vbxe>>14]+3 (fx_ptr),y
			mwa #$4000 pom1			;wyrownuje do 16K 
			mwa #title0c+[192*39] pom	;192x40
			jsr copy_shape2				;192
			
			ldy #$5d
			mva #$99 (fx_ptr),y			;bank dla muzyki
			rts
			
_init3
			ldy #$5d
			mva #$80+$14 (fx_ptr),y
			rts
			
_init4
			ldy #$5d
			mva #$80+$15 (fx_ptr),y
			rts			

_init5
			ldy #$5d
			mva #$80+$16 (fx_ptr),y
			rts	
			
_init6
			ldy #$5d
			mva #$80+$17 (fx_ptr),y
			rts	

_init7
			ldy #$5d
			mva #$80+$18 (fx_ptr),y
			rts				

_init8
			jmp end_init	
			
//obraca w poziomie
copy_shape1			
			ldx #16			;16 linii
@			ldy #15			;16-1 kolumn
@			sty pom0b
			tya
			eor #15
			tay
			lda (pom),y
			ldy pom0b
			sta (pom1),y
			dey
			bpl @-
			clc
			lda pom1
			adc #16
			sta pom1
			bcc *+4
			inc pom1+1
			sec
			lda pom
			sbc pom0
			sta pom
			lda pom+1
			sbc pom0a
			sta pom+1
			dex
			bne @-1
			rts

copy_shape
			ldx #16			;16 linii
@			ldy #15			;16-1 kolumn
@			lda (pom),y
			sta (pom1),y
			dey
			bpl @-
			sec			;+1
			lda pom1
			adc copy_shape+3
			sta pom1
			bcc *+4
			inc pom1+1
			sec
			lda pom
			sbc pom0
			sta pom
			lda pom+1
			sbc pom0a
			sta pom+1
			dex
			bne @-1
			rts
			
copy_shape2	
			ldx #16			;16 linii
@			ldy #15			;16-1 kolumn
@			lda (pom),y
			sta (pom1),y
			dey
			cpy #255
			bne @-
			sec			;+1
			lda pom1
			adc copy_shape2+3
			sta pom1
			bcc *+4
			inc pom1+1
			sec
			lda pom
			sbc pom0
			sta pom
			lda pom+1
			sbc pom0a
			sta pom+1
			dex
			bne @-1
			rts


set_colors	
			ldy	#$44
			mva	#1	(fx_ptr),y+	; CSEL ,nr koloru
			mva	#1	(fx_ptr),y	; PSEL	,nr palety
			
			ldx #0
@			ldy	#$46	; CR
			lda tab_color,x
			sta	(fx_ptr),y		;RED
			iny
			inx
			lda tab_color,x
			sta	(fx_ptr),y		;GREEN
			iny
			inx
			lda tab_color,x
			sta	(fx_ptr),y		;BLUE, nr_koloru++
			inx
			cpx #$30*3
			bcc @-
			rts

tab_color
			.he 00,00,00		;1
			.he ff,ff,ff		;2
			.he ff,00,00		;3
			.he 00,a0,c0		;4
			.he ff,ff,00		;5
			.he e0,c0,80		;6
			.he 2a,2a,2a		;7
			.he 88,88,88		;8
			.he bb,bb,bb		;9
			.he dd,dd,dd		;0a
			.he a0,a0,00		;0b
			.he c0,c0,00		;0c
			.he e0,e0,00		;0d
			.he ff,ff,00		;0e
			.he aa,aa,aa		;0f
			.he 44,44,44		;10
			.he 66,66,66		;11
			.he 88,88,88		;12
			.he 00,00,ff		;13		kolor litery
			.he cc,cc,cc		;14
			.he ff,00,33		;15		kolor_paraliz0
			.he cc,00,ff		;16		kolor_paraliz1
			.he 80,00,00		;17
			.he e0,20,40		;18
			.he ff,ff,00		;19
			.he c0,80,40		;1a
			.he 80,00,00		;1b		czerwony0	; bomba
			.he c0,20,00		;1c		czerwony1
			.he a0,20,00		;1d		zapalona0
			.he ff,ff,00		;1e		zapalona1	
			
			.he 00,00,00		;game_over $1f
			
			
			.he ff,33,00		;20 rampa
			.he ff,55,00
			.he ff,77,00
			.he ff,99,00
			
			.he ff,bb,00
			.he ff,cc,00
			.he ff,dd,00
			.he ff,ff,00		;27
			
			.he ff,00,00		;start0	;28
			.he 00,ff,00		;start1	;29
			
			.he ff,00,88		;title 2a
			.he 00,88,ff		;sredni niebieski 2b
			.he ff,aa,00		;2c
			.he 00,bb,ff		;najjaśniejszy biebieski 2d
			.he 00,55,ff		;najciemniejszy niebieski 2e
			.he ff,ff,ff		;2f
			.he ff,00,00		;30			ostatni kolor title

; Detect VBXE
fx_detect
	mwa	#$d600	fx_ptr
	jsr	fx_detect_1
	beq	fx_detect_exit
	inc	fx_ptr+1
fx_detect_1
	ldy	#$40	; CORE_VERSION
	lda	(fx_ptr),y
	cmp	#$10	; FX 1.xx
	bne	fx_detect_exit
	iny	; MINOR_VERSION
	lda	(fx_ptr),y
	and	#$70
	cmp	#$20	; 1.2x
fx_detect_exit
	rts

	

blit
	ldy	#bcb_len-1
@	lda (pom2),y
	sta $4000+[bcb_vbxe&$3fff],y
	dey
	bpl @-
	
	ldy	#$50	; BL_ADR0
	mva	#bcb_vbxe&$ff	(fx_ptr),y+	; BL_ADR0			;najmlodszy bajt adresu
	mva	#[bcb_vbxe>>8]&$ff	(fx_ptr),y+	; BL_ADR1		;nastepne bajty adresu
	mva	#bcb_vbxe>>16	(fx_ptr),y+	; BL_ADR2
	mva	#1	(fx_ptr),y	; BLITTER_START				;wykonaj
	rts


cls_bcb
	dta	0,0,0				;adres=000000 nie zmienia się
	dta	a(0),0
	dta	a(scr_vbxe&$ffff),1		;adres docelowy=poczatek pamieci obrazu
	dta	a(256*8),1			;odleglosc w pamieci miedzy liniami=2048,skok=1
	dta	a(256-1),254-1		;szerokosc obiektu=256,wysokosc=254
	dta	0,0,0				;wypełniaj zerami
	dta	7,0,0				;X=X*8
	

bcb
	dta	a(shape_vbxe),0			;adres danych żródłowych w pamięci vbxe 24bity
	dta	a(shape_WIDTH),1		;odstęp w pamięci pomiędzy kolejnymi liniami <-4096..4095>, kolejność pobierania danych (1,-1)
bcb_dest
	dta	a(scr_vbxe&$ffff)						;adres docelowy dla operacji blittera 24bity
bcb_frame
	dta	1
	dta	a(256),1				;odleglość w pamięci pomiędzy kolejnymi liniami <-4096..4095>,skok pomiędzy danymi (-1,1)
	dta	a(shape_WIDTH-1),shape_HEIGHT-1	;szerokosć obiektu-1(0,511),wysokosć obiektu-1(0,255)
	dta	$ff,0,0				;maska AND źródła,maska XOR źródła,maska AND wykrywania kolizji	
	dta	0,0,1				;zoom X i Y,sterowanie wypełnianiem wzorkiem, dodatkowe informacje 1=kopiuje jesli zrodlo>0
bcb_len	equ	*-bcb	

bcb1
	dta a(scr_vbxe&$ffff),1
	dta a(256),1
bcb1_dest	
	dta a(0),2			
	dta a(shape_WIDTH),1
	dta a(shape_WIDTH-1),shape_HEIGHT-1
	dta $ff,0,0
	dta 0,0,0
bcb1_len equ *-bcb1

bcb2
	dta a(bufor_vbxe&$ffff),3
	dta a(512),1	
	dta a(0),1			
	dta a(512),1
	dta a(511),103
	dta $ff,0,0
	dta 0,0,0
bcb2_len equ *-bcb2

bcb3
	dta a(0),3
	dta a(256),1
bcb3_dest	
	dta a(0),1			
	dta a(256),1
	dta a(15),15
	dta $ff,0,0
	dta 0,0,0
bcb3_len equ *-bcb3

//rysuje obiekty 8x8
bcb4
	dta b(0),b(115),0
	dta a(8),1	
	dta a(0),3			
	dta a(256),1
	dta a(7),7
	dta $ff,0,0
	dta 0,0,0
bcb4_len equ *-bcb4
//cls screen
bcb5
	dta b(0),b(19),0
	dta a(0),0
	dta a(0),1
	dta a(256),1
	dta a(256-1),b(208-1)
	dta $ff,0,0
	dta 0,0,0
bcb5_len equ *-bcb5
//rysuje start
bcb6
	dta a(0),0
	dta a(64),1
	dta b(0),b(96),1
	dta a(256),1
	dta a(64-1),b(16-1)
	dta $ff,0,0
	dta 0,0,1
bcb6_len equ *-bcb6
//zapamietuje pod startem
bcb7
	dta b(0),b(96),1		;bufor
	dta a(256),1
	dta b(0),b(96),2
	dta a(256),1
	dta a(256-1),b(16-1)
	dta $ff,0,0
	dta 0,0,0
bcb7_len equ *-bcb7

//zapamietuje pod game_over
bcb8
	dta a(0),1		;zrodlo =ekran
	dta a(256),1
	dta b(0),b(96),2
	dta a(32),1
	dta a(32-1),b(24-1)
	dta $ff,0,0
	dta 0,0,0
bcb8_len equ *-bcb8

//przywroc po game over
bcb9
	dta b(0),b(96),2		;zrodlo bufor
	dta a(32),1
	dta a(0),1				;cel=ekran
	dta a(256),1
	dta a(32-1),b(24-1)
	dta $ff,0,0
	dta 0,0,0
bcb9_len equ *-bcb9

//rysuj game over
bcb10
	dta b(0),b(117),0		;zrodlo shape
	dta a(32),1
	dta a(0),1				;cel=ekran
	dta a(256),1
	dta a(32-1),b(24-1)
	dta $ff,0,0
	dta 0,0,1				;z maska
bcb10_len equ *-bcb10

//rysuj title
bcb11
	dta b(0),b(128),0		;zrodlo shape
	dta a(192),1
	dta 32,4,1				;cel=ekran 
	dta a(256),1
	dta a(192-1),b(40-1)
	dta $ff,0,0
	dta 0,0,0				;z kopiuj
bcb11_len equ *-bcb11

bcb12
	dta b(0),b(192),0		;zrodlo shape
	dta a(192),1
	dta 32,44,1				;cel=ekran 
	dta a(256),1
	dta a(192-1),b(40-1)
	dta $ff,0,0
	dta 0,0,0				;z kopiuj
bcb12_len equ *-bcb12

xdl
	dta	a($24),b(23-16)	; XDLC_OVOFF|XDLC_RTPL  ;24 puste linie
	dta	a($8862),b(191+16) ; XDLC_GMON|XDLC_RTPL|XDLC_OVADR|XDLC_END|XDLC_ATT  ; 192 linie w hires
	dta	a(scr_vbxe&$ffff)		;adres pamieci obrazu dla tych linii	
xdl_frame
	dta	b(1),a(256)		;3 bajt adresu obrazu=0,256=o ile bajtów skaczemy co linie
	dta a($ff10)			;paleta1+szerokosc 256 bajtów=$10, prio_default=$ff
	
xdl_len	equ	*-xdl



			org $8000
jack_right			
			ins './sprites1/right.spr'	;76x16
jack_left
			ins './sprites1/left.spr'	;76x16
jack_lata
			ins './sprites1/jack_lata.spr' ;160x16
jack_spada
			ins './sprites1/jack_spada.spr' ;36x16
jack_upada
			ins './sprites1/jack_upada.spr' ;44x16
jack_stoi
			ins './sprites1/jack_stoi.spr' ;16x16
empty
			:256 dta b(0)			
mumia0
			ins './sprites1/mumia.spr'		;348x16		

			ini	_init
			
			org $8000
globus0			
			ins './sprites1/globus.spr'		;320x16
buzka0	
			ins './sprites1/buzka.spr'		;64x16	
literki0
			ins './sprites1/literki.spr'		;140x16	
paraliz0
			ins './sprites1/paraliz.spr'		;64x16	
przemiana0
			ins './sprites1/przemiana.spr'	;64x16		
explo0
			ins './sprites1/explo.spr'		;64x16	
ufo0	
			ins './sprites1/ufo.spr'			;120x16	
bomby0
			ins './sprites1/bomby.spr'		;100x16	
			
			
						
			ini _init1
			
			org $8000			
punkty0		
			ins './sprites1/punkty.spr'		;180x16
xpunkty0	
			ins './sprites1/xpunkty.spr'		;52x16
jack_tanczy0
			ins './sprites1/jack_tanczy.spr'	;56x16
			
start0
			ins './sprites1/start0.spr'	;64x16		
			ins './sprites1/start1.spr'	;64x16	
			
rampa0	
			ins './sprites1/rampa_poziom.spr'	;8x8	
			ins './sprites1/rampa_pion.spr'
			ins './sprites1/rampa_lg.spr'
			ins './sprites1/rampa_pg.spr'
			ins './sprites1/rampa_ld.spr'
			ins './sprites1/rampa_pd.spr'
over0			
			ins './sprites1/gameover.spr'		;32x64
czapka0			
			ins './sprites1/czapka.spr'		;76x16
			
			ini _init2
			

			org $8000
title0b			
			ins './sprites1/title0.spr'			;192x80
			
			ini _init2b
			
			org $8000
title0c			
			ins './sprites1/title1.spr'			;192x80
			
			ini _init2c
			
			
			org $4000
			ins 'ingame1.rmt'
			
			ini _init3
			
			org $4000
			ins './levels1/kolory_sfinks.dat'
			ins './levels1/sfinks.dat'
			
			ini _init4
			
			org $4000
			ins './levels1/kolory_akropol.dat'
			ins './levels1/akropol.dat'
			
			ini _init5
			
			org $4000
			ins './levels1/kolory_zamek.dat'
			ins './levels1/zamek.dat'
			
			ini _init6
			
			org $4000
			ins './levels1/kolory_miasto.dat'
			ins './levels1/miasto.dat'
			
			ini _init7
			
			org $4000
			ins './levels1/kolory_droga.dat'
			ins './levels1/droga.dat'
			
			ini _init8
			
			