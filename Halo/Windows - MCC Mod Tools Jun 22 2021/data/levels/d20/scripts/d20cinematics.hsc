;   Script:		Halo D20 Cinematics Script 
; Synopsis:		

;- History ---------------------------------------------------------------------

; 07/01/01 - Initial version (Tyson)


;- Globals ---------------------------------------------------------------------

; Print useful debugging text
(global boolean cinematics_debug false)

; Sound control parameters
(global real cortana_dialogue_scale 1)
(global real keyes_dialogue_scale 1)
(global real chief_dialogue_scale 1)


;- Vehicles --------------------------------------------------------------------
					
; Outro Banshee 1
(script static void outro_banshee1
	(object_teleport ending_banshee1 outro_banshee1)
	(recording_play (unit ending_banshee1) outro_banshee1)
)


; Outro Banshee 2
(script static void outro_banshee2
	(object_teleport ending_banshee2 outro_banshee2)
	(recording_play (unit ending_banshee2) outro_banshee2)
)


;- Outro -----------------------------------------------------------------------

; Launch banshees appropriately
(script static void outro_banshees

	(if (> (list_count (players)) 1)
		(begin
			(outro_banshee2)
			(outro_banshee1)
		)
		(begin
			(if (vehicle_test_seat_list ending_banshee1 "B-driver" (players))
				(begin (outro_banshee1) (object_destroy ending_banshee2))
				(begin (outro_banshee2) (object_destroy ending_banshee1))
			)
		)
	)
)


; Trigger the outro
(script static void cinematic_outro
	(fade_out 1 1 1 30)
	(sleep 30)

	(camera_control on)
	(cinematic_start)

	; Place the finale elites
	(ai_place outro_cov)

	(camera_set outro_1 0)
	(sleep 15)
	(fade_in 1 1 1 30)
	
	; Cram the players into the banshees
	(vehicle_load_magic ending_banshee1 "B-driver" (player0))
	(vehicle_load_magic ending_banshee2 "B-driver" (player1))
	
	; MOVE EVERY BANSHEE
	(outro_banshees)
	(sleep 100)
	(sound_class_set_gain ambient_machinery 0 3)
	(camera_set outro_2 135)
	(sleep 180)

	; MUZAK!
	(sound_looping_stop "levels\d20\music\d20_06")
	
	(sleep 30)

	; Fade to black
	(fade_out 0 0 0 60)
	(sleep 90)
)


;- Captain Cinematic -----------------------------------------------------------

(script stub void cutscene_captain (print "foo"))
(script static void cinematic_captain
	(cutscene_captain)
)


;- Lift Cinematic --------------------------------------------------------------

;*	Cinematic for when the player travels from the exterior of the ship into the
	ship by route of the gravity lift. Also responsible for teleporting the 
	player from the lift site to the appropriate part of the ship, and swapping
	the BSP.
*;
(script stub void cutscene_lift (print "foo"))
(script static void cinematic_lift
	(cutscene_lift)
)


;- Drop Cinematic --------------------------------------------------------------

;*	Cinematic for when the player drops from the ship to the exterior
	environment. Also responsible for switching the BSP and teleporting the 
	player into the new BSP (as well as saving the game)
*;
(script stub void cutscene_fall (print "foo"))
(script static void cinematic_drop
	(cutscene_fall)
)


;- Intro Cinematic -------------------------------------------------------------

(script stub void cutscene_insertion (print "foo"))
(script static void cinematic_intro
	(cutscene_insertion)
)


;- Section 1 Dialogue Hooks ----------------------------------------------------

(script static void D20_10_Cortana ;
	(if cinematics_debug (print "Cortana: I can read the Captain's CNI transponder. He's in the Control Room….but I'm not detecting any human life signs."))
	(sound_impulse_start sound\dialog\d20\D20_010_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_010_Cortana) 30)))
)

(script static void D20_20_Cortana ;
	(if cinematics_debug (print "Cortana: The damage caused by the crash and the Flood have sealed off all nearby accessways to the Control Room. We should find another way in."))
	(sound_impulse_start sound\dialog\d20\D20_020_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_020_Cortana) 30)))
)

(script static void D20_30_Cortana ;
	(if cinematics_debug (print "Cortana: Analyzing damage. [Pause] This hole was caused by some kind of explosive…very powerful, if it tore through the ship's hull. All I detect down there are pools of coolant. We should continue our search somewhere else."))
	(sound_impulse_start sound\dialog\d20\D20_030_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_030_Cortana) 30)))
)

(script static void D20_50_Cortana ;
	(if cinematics_debug (print "Cortana: There's so many I can't track them all!"))
	(sound_impulse_start sound\dialog\d20\D20_050_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_050_Cortana) 30)))
)

(script static void D20_60_Chief
	(sleep 1) ; This hook is obsolete
;	(if cinematics_debug (print "Chief: You have no idea."))
;	(sound_impulse_start sound\dialog\d20\D20_060_Chief none "chief"_dialogue_scale)
;	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_060_Chief) 30)))
)

(script static void D20_70_Cortana ;
	(if cinematics_debug (print "Cortana: Warning! Threat level increasing. [Pause] That jump into the coolant is looking better all the time, Chief. Trust me…its deep enough to cushion our fall."))
	(sound_impulse_start sound\dialog\d20\D20_070_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_070_Cortana) 30)))
)

(script static void D20_71_Cortana ;
	(if cinematics_debug (print "Cortana: Warning! Threat level increasing."))
	(sound_impulse_start sound\dialog\d20\D20_071_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_071_Cortana) 30)))
)

(script static void D20_72_Cortana ;
	(if cinematics_debug (print "Cortana: That jump into the coolant is looking better all the time, Chief."))
	(sound_impulse_start sound\dialog\d20\D20_072_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_072_Cortana) 30)))
)

(script static void D20_73_Cortana ;
	(if cinematics_debug (print "Cortana: Trust me…its deep enough to cushion our fall."))
	(sound_impulse_start sound\dialog\d20\D20_073_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_073_Cortana) 30)))
)

(script static void D20_80_Chief
	(sleep 1) ; This hook is obsolete
;	(if cinematics_debug (print "Chief: Are you sure that pool is deep enough?"))
;	(sound_impulse_start sound\dialog\d20\D20_080_Chief "none" chief_dialogue_scale)
;	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_080_Chief) 30)))
)

(script static void D20_90_Cortana ;
	(if cinematics_debug (print "Cortana: [Very urgent] Chief, we need to jump. NOW! "))
	(sound_impulse_start sound\dialog\d20\D20_090_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_090_Cortana) 30)))
	(activate_team_nav_point_flag "default_red" player waypoint1 0)
)


;- Section 3 Dialogue Hooks ----------------------------------------------------

(script static void D20_120_Cortana ;
	(if cinematics_debug (print "Cortana: Let's get out of here and find another back aboard the ship."))
	(sound_impulse_start sound\dialog\d20\D20_120_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_120_Cortana) 30)))
)

(script static void D20_130_Cortana ;
	(if cinematics_debug (print "Cortana: The crash did more damage than I suspected. Analyzing: [Pause] Coolant leakage rate is significant. The ship's reactors should already have gone critical."))
	(sound_impulse_start sound\dialog\d20\D20_130_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_130_Cortana) 30)))
)

(script static void D20_140_Cortana ;
	(if cinematics_debug (print "Cortana: We should head this way, towards the ship's gravity lift."))
	(sound_impulse_start sound\dialog\d20\D20_140_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_140_Cortana) 30)))
	(activate_team_nav_point_flag "default_red" player waypoint2 0)
)

(script static void D20_150_Cortana ;
	(if cinematics_debug (print "Cortana: Wait. The Covenant and Flood are attacking each other. I recommend we wait until they've worm each other down. Then we'll only have to deal with the stragglers. "))
	(sound_impulse_start sound\dialog\d20\D20_150_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_150_Cortana) 30)))
)

(script static void D20_160_Cortana ;
	(if cinematics_debug (print "Cortana: Power source detected…there's the gravity lift. [Pause] It's still operational…that's our way back in."))
	(sound_impulse_start sound\dialog\d20\D20_160_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_160_Cortana) 30)))
)


;- Section 4 Dialogue Hooks ----------------------------------------------------

(script static void D20_180_Cortana ;
	(if cinematics_debug (print "Cortana: We should be able to get into the ship's Control Room from here. "))
	(sound_impulse_start sound\dialog\d20\D20_180_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_180_Cortana) 30)))
)

(script static void D20_190_Cortana ;
	(if cinematics_debug (print "Cortana: Wait a moment. We went through the doors on the right the last time we were here. This is a different route. [Pause] The Covenant battle net is a mess…I can't access the ship's schematics. My records indicate that a shuttle bay should be here. "))
	(sound_impulse_start sound\dialog\d20\D20_190_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_190_Cortana) 30)))
	(activate_team_nav_point_flag "default_red" player waypoint3 0)
)

(script static void D20_200_Cortana ;
	(if cinematics_debug (print "Cortana: Look, in the corners… the Flood are gathering bodies here."))
	(sound_impulse_start sound\dialog\d20\D20_200_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_200_Cortana) 30)))
)


;- Section 5 Dialogue Hooks ----------------------------------------------------

(script static void D20_210_Cortana ;
	(if cinematics_debug (print "Cortana: Looks like another shuttle bay, we should be able to reach the Control Room from the third level."))
	(sound_impulse_start sound\dialog\d20\D20_210_Cortana "none" cortana_dialogue_scale)
	(deactivate_team_nav_point_flag player waypoint3)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_210_Cortana) 30)))
	(activate_team_nav_point_flag "default_red" player waypoint4 0)
)


(script static void D20_220_Cortana ;
	(if cinematics_debug (print "Cortana: The Control Room should be this way."))
	(sound_impulse_start sound\dialog\d20\D20_220_Cortana "none" cortana_dialogue_scale)
	(deactivate_team_nav_point_flag player waypoint4)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_220_Cortana) 30)))
	(activate_team_nav_point_flag "default_red" player waypoint5 0)
)


;- Section 7 Dialogue Hooks ----------------------------------------------------

(script static void D20_240_Cortana ;
	(if cinematics_debug (print "Cortana: We need to get back to the Pillar of Autumn.  Let's go back to the shuttle bay and find a ride."))
	(sound_impulse_start sound\dialog\d20\D20_240_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_240_Cortana) 30)))
)

(script static void D20_250_Cortana
	(if cinematics_debug (print "Cortana: Perfect. Grab one of the escort Banshees and we'll use it to return to the Pillar of Autumn."))
	(sound_impulse_start sound\dialog\d20\D20_250_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_250_Cortana) 30)))
	(activate_team_nav_point_object "default_red" player ending_banshee1 0)
)


;- Flava Dialogue Hooks --------------------------------------------------------

(script static void D20_flavor_010_CaptKeyes 
	(if cinematics_debug (print "D20_flavor_010_CaptKeyes"))
	(sound_impulse_start sound\dialog\d20\D20_flavor_010_CaptKeyes "none" keyes_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_flavor_010_CaptKeyes) 15)))
)

(script static void D20_flavor_020_Cortana
	(if cinematics_debug (print "D20_flavor_020_Cortana"))
	(sound_impulse_start sound\dialog\d20\D20_flavor_020_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_flavor_020_Cortana) 15)))
)

(script static void D20_flavor_030_CaptKeyes 
	(if cinematics_debug (print "D20_flavor_030_CaptKeyes"))
	(sound_impulse_start sound\dialog\d20\D20_flavor_030_CaptKeyes "none" keyes_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_flavor_030_CaptKeyes) 15)))
)

(script static void D20_flavor_040_Cortana
	(if cinematics_debug (print "D20_flavor_040_Cortana"))
	(sound_impulse_start sound\dialog\d20\D20_flavor_040_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_flavor_040_Cortana) 15)))
)

(script static void D20_flavor_050_CaptKeyes 
	(if cinematics_debug (print "D20_flavor_050_CaptKeyes"))
	(sound_impulse_start sound\dialog\d20\D20_flavor_050_CaptKeyes "none" keyes_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_flavor_050_CaptKeyes) 15)))
)

(script static void D20_flavor_060_Cortana
	(if cinematics_debug (print "D20_flavor_060_Cortana"))
	(sound_impulse_start sound\dialog\d20\D20_flavor_060_Cortana "none" cortana_dialogue_scale)
	(sleep (max 0 (- (sound_impulse_time sound\dialog\d20\D20_flavor_060_Cortana) 15)))
)


;- Music Control ---------------------------------------------------------------

; Scale controls
(global real music_01_scale 1)
(global real music_02_scale 1)
(global real music_03_scale 1)
(global real music_04_scale 1)
(global real music_05_scale 1)
(global real music_06_scale 1)

; Play controls
(global boolean music_01_base false)
(global boolean music_02_base false)
(global boolean music_03_base false)
(global boolean music_03_alt false)
(global boolean music_04_base false)
(global boolean music_05_base false)
(global boolean music_06_base false)

(script static void music_01 
	; Wait for it... waaaait for it... then begin music
	(sleep_until music_01_base)
	(if cinematics_debug (print "Start music_01"))
	(sound_looping_start "levels\d40\music\d40_01" none music_01_scale)

	; Stop?
	(sleep_until (not music_01_base))
	(if cinematics_debug (print "End music_01"))
	(sound_looping_stop "levels\d40\music\d40_01")
)

(script static void music_02 
	; Wait for it... waaaait for it... then begin music
	(sleep_until music_02_base)
	(if cinematics_debug (print "Start music_02"))
	(sound_looping_start "levels\d40\music\d40_02" none music_02_scale)

	; Stop?
	(sleep_until (not music_02_base))
	(if cinematics_debug (print "End music_02"))
	(sound_looping_stop "levels\d40\music\d40_02")
)

(script static void music_03 
	; Wait for it... waaaait for it... then begin music
	(sleep_until music_03_base)
	(if cinematics_debug (print "Start music_03"))
	(sound_looping_start "levels\d40\music\d40_03" none music_03_scale)

	; Alt?
	(sleep_until music_03_alt)
	(if cinematics_debug (print "Alt music_03"))
	(sound_looping_set_alternate "levels\d40\music\d40_03" true)
	
	; Stop?
	(sleep_until (not music_03_base))
	(set music_03_alt false)
	(if cinematics_debug (print "End music_03"))
	(sound_looping_stop "levels\d40\music\d40_03")
)

(script static void music_04_start
	(set music_04_base true)
	(if cinematics_debug (print "Start music_04"))
	(sound_looping_start "levels\d40\music\d40_02" none music_02_scale)
)

(script static void music_04_end
	(set music_04_base false)
	(if cinematics_debug (print "End music_04"))
	(sound_looping_stop "levels\d40\music\d40_02")
)

(script static void music_05 
	; Wait for it... waaaait for it... then begin music
	(sleep_until music_05_base)
	(if cinematics_debug (print "Start music_05"))
	(sound_looping_start "levels\d40\music\d40_02" none music_02_scale)

	; Stop?
	(sleep_until (not music_05_base))
	(if cinematics_debug (print "End music_05"))
	(sound_looping_stop "levels\d40\music\d40_02")
)

(script static void music_06 
	; Wait for it... waaaait for it... then begin music
	(sleep_until music_06_base)
	(if cinematics_debug (print "Start music_06"))
	(sound_looping_start "levels\d40\music\d40_02" none music_02_scale)

	; Stop?
	(sleep_until (not music_06_base))
	(if cinematics_debug (print "End music_06"))
	(sound_looping_stop "levels\d40\music\d40_02")
)

(script dormant music_control
	(music_01)
	(music_02)
	(music_03)
;	(music_04)
	(music_05)
	(music_06)
)

