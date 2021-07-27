;   Script:		Halo D40 Cinematics Script 
; Synopsis:		

;- History ---------------------------------------------------------------------
 
; 07/01/01 - Initial version (Tyson)


;- Vehicles --------------------------------------------------------------------
					 
; Print useful debugging text
(global boolean cinematics_debug false)

; Sound control parameters
(global real monitor_dialogue_scale 1)
(global real cortana_dialogue_scale 1)
(global real pilot_dialogue_scale 1)
(global real chief_dialogue_scale 1)


;- Section 1 Dialogue Hooks ----------------------------------------------------

(script static void D40_010_Cortana
	(sound_impulse_start sound\dialog\d40\D40_010_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_010_Cortana) 30)))
)


;- Section 2 Dialogue Hooks ----------------------------------------------------

(script static void D40_020_Cortana
	(sound_impulse_start sound\dialog\d40\D40_020_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_020_Cortana) 0)))
)

(script static void D40_030_Cortana
	(sound_impulse_start sound\dialog\d40\D40_030_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_030_Cortana) 30)))
)

(script static void D40_050_Cortana
	(sound_impulse_start sound\dialog\d40\D40_050_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_050_Cortana) 30)))
)

(script static void D40_060_Cortana
	(sound_impulse_start sound\dialog\d40\D40_060_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_060_Cortana) 30)))
)

(script static void D40_070_Cortana
	(sound_impulse_start sound\dialog\d40\D40_070_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_070_Cortana) 30)))
)

(script static void D40_080_Cortana
	(sound_impulse_start sound\dialog\d40\D40_080_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_080_Cortana) 30)))
)

(script static void D40_100_Cortana
	(sound_impulse_start sound\dialog\d40\D40_100_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_100_Cortana) 30)))
)


;- Section 5 Dialogue Hooks ----------------------------------------------------

(script static void D40_110_Cortana
	(sound_impulse_start sound\dialog\d40\D40_110_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_110_Cortana) 1)))
	(sleep 40)
)

(script static void D40_120_Cortana
	(sound_impulse_start sound\dialog\d40\D40_120_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_120_Cortana) 30)))
)

(script static void D40_130_Cortana
	(sound_impulse_start sound\dialog\d40\D40_130_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_130_Cortana) 5)))
)

(script static void D40_140_Cortana
	(sound_impulse_start sound\dialog\d40\D40_140_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_140_Cortana) 30)))
)

(script static void D40_150_Cortana
	(sound_impulse_start sound\dialog\d40\D40_150_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_150_Cortana) 0)))
)

(script static void D40_160_Cortana
	(sound_impulse_start sound\dialog\d40\D40_160_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_160_Cortana) 0)))
)

(script static void D40_170_Cortana
	(sound_impulse_start sound\dialog\d40\D40_170_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_170_Cortana) 30)))
)

(script static void D40_180_Cortana
	(sound_impulse_start sound\dialog\d40\D40_180_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_180_Cortana) 30)))
)

(script static void D40_200_Cortana
	(sound_impulse_start sound\dialog\d40\D40_200_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_200_Cortana) 10)))
)

(script static void D40_210_Cortana
	(sound_impulse_start sound\dialog\d40\D40_210_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_210_Cortana) 30)))
)

(script static void D40_220_Cortana
	(sound_impulse_start sound\dialog\d40\D40_220_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_220_Cortana) 30)))
)

(script static void D40_230_Cortana
	(sound_impulse_start sound\dialog\d40\D40_230_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_230_Cortana) 10)))
)

(script static void D40_240_Pilot
	(sound_impulse_start sound\dialog\d40\D40_240_Pilot "none" pilot_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_240_Pilot) 15)))
)

(script static void D40_250_Cortana
	(sound_impulse_start sound\dialog\d40\D40_250_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_250_Cortana) 15)))
)

(script static void D40_260_Pilot
	(sound_impulse_start sound\dialog\d40\D40_260_Pilot "none" pilot_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_260_Pilot) 5)))
)

(script static void D40_270_Pilot
	(sound_impulse_start sound\dialog\d40\D40_270_Pilot "none" pilot_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_270_Pilot) 15)))
)

(script static void D40_280_Cortana
	(sound_impulse_start sound\dialog\d40\D40_280_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_280_Cortana) 30)))
)

(script static void D40_300_Cortana
	(sound_impulse_start sound\dialog\d40\D40_300_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_300_Cortana) 30)))
)

(script static void D40_310_Cortana
	(sound_impulse_start sound\dialog\d40\D40_310_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_310_Cortana) 30)))
)

(script static void D40_320_Cortana
	(sound_impulse_start sound\dialog\d40\D40_320_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_320_Cortana) 30)))
)

(script static void D40_330_Cortana
	(sound_impulse_start sound\dialog\d40\D40_330_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_330_Cortana) 30)))
)


;- Section 6 Dialogue Hooks ----------------------------------------------------

(script static void D40_340_Cortana
	(sound_impulse_start sound\dialog\d40\D40_340_Cortana "none" cortana_dialogue_scale)
;	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_340_Cortana) 30)))
)

(script static void D40_350_Cortana
	(sound_impulse_start sound\dialog\d40\D40_350_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_350_Cortana) 30)))
)

(script static void D40_360_Cortana
	(sound_impulse_start sound\dialog\d40\D40_360_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_360_Cortana) 30)))
)

(script static void D40_362_Cortana
	(sound_impulse_start sound\dialog\d40\D40_362_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_362_Cortana) 30)))
)

(script static void D40_363_Cortana
	(sound_impulse_start sound\dialog\d40\D40_363_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_363_Cortana) 30)))
)

(script static void D40_370_Cortana
	(sound_impulse_start sound\dialog\d40\D40_370_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_370_Cortana) 30)))
)

(script static void D40_380_Cortana
	(sound_impulse_start sound\dialog\d40\D40_380_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_380_Cortana) 30)))
)
 
(script static void D40_390_Pilot
	(sound_impulse_start sound\dialog\d40\D40_390_Pilot "none" pilot_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_390_Pilot) 30)))
)

(script static void D40_400_Cortana
	(sound_impulse_start sound\dialog\d40\D40_400_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_400_Cortana) 30)))
)

(script static void D40_410_Pilot
	(sound_impulse_start sound\dialog\d40\D40_410_Pilot "none" pilot_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_410_Pilot) 30)))
)

(script static void D40_420_Pilot
	(sound_impulse_start sound\dialog\d40\D40_420_Pilot "none" pilot_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_420_Pilot) 30)))
)

(script static void D40_440_Cortana
	(sound_impulse_start sound\dialog\d40\D40_440_Cortana "none" cortana_dialogue_scale)
;	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_440_Cortana) 240)))
)

(script static void D40_441_Cortana
	(sound_impulse_start sound\dialog\d40\D40_441_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_441_Cortana) 240)))
)


;- Section 7 Dialogue Hooks ----------------------------------------------------

(script static void D40_450_Cortana
	(sound_impulse_start sound\dialog\d40\D40_450_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d40\D40_450_Cortana) 30)))
)


;- PLAYER TOO SLOW! Cinematic --------------------------------------------------

(script stub void cutscene_lose (print "cutscene_lose"))
(script static void cinematic_time_up
	; Ka-BLAM!
	(cutscene_lose)
)


;- Death of Pelican Cinematic --------------------------------------------------

(script stub void x70_finale (print "x70_finale"))
(script static void cinematic_finale
	; Cinematic goes here!
	(x70_finale)
)


;- Bridge Cinematic ------------------------------------------------------------

(script stub void x70_bridge (print "x70_bridge"))
(script static void cinematic_bridge
	; Cinematic goes here!
	(x70_bridge)
)


;- Intro Cinematic -------------------------------------------------------------

(script stub void cutscene_insertion (print "foo"))
(script static void cinematic_intro
	; Cinematic goes here!
	(cutscene_insertion)
)

