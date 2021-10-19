; ===================================================================================================================================================
; ===================================================================================================================================================
; MUSIC 
; ===================================================================================================================================================
; ===================================================================================================================================================

(global boolean g_music_040_01 FALSE)
(global boolean g_music_040_02 FALSE)
(global boolean g_music_040_03 FALSE)
(global boolean g_music_040_04 FALSE)
(global boolean g_music_040_05 FALSE)
(global boolean g_music_040_06 FALSE)
(global boolean g_music_040_07 FALSE)
(global boolean g_music_040_08 FALSE)
(global boolean g_music_040_09 FALSE)
(global boolean g_music_040_10 FALSE)
(global boolean g_music_040_11 FALSE)
(global boolean g_music_040_12 FALSE)
(global boolean g_music_040_13 FALSE)
(global boolean g_music_040_14 FALSE)
(global boolean g_music_040_15 FALSE)
(global boolean g_music_040_16 FALSE)

; =======================================================================================================================================================================
(script dormant music_040_01
	(sleep_until g_music_040_01)
	(print "start music 040_01")
	(sound_looping_start levels\solo\040_voi\music\040_music_01 NONE 1)

	(sleep_until (not g_music_040_01))
	(print "stop music 040_01")
	(sound_looping_stop levels\solo\040_voi\music\040_music_01)
)
; =======================================================================================================================================================================
(script dormant music_040_02
	(sleep_until g_music_040_02)
	(print "start music 040_02")
	(sound_looping_start levels\solo\040_voi\music\040_music_02 NONE 1)

	(sleep_until (not g_music_040_02))
	(print "stop music 040_02")
	(sound_looping_stop levels\solo\040_voi\music\040_music_02)
)
; =======================================================================================================================================================================
(script dormant music_040_03
	(sleep_until g_music_040_03)
	(print "start music 040_03")
	(sound_looping_start levels\solo\040_voi\music\040_music_03 NONE 1)

	(sleep (* 30 58))
	(print "stop music 040_03")
	(sound_looping_stop levels\solo\040_voi\music\040_music_03)
	
	(wake music_040_04)
	(set g_music_040_04 TRUE)
)
; =======================================================================================================================================================================
(script dormant music_040_04
	(sleep_until g_music_040_04)
	(print "start music 040_04")
	(sound_looping_start levels\solo\040_voi\music\040_music_04 NONE 1)

	(sleep_until (not g_music_040_04))
	(print "stop music 040_04")
	(sound_looping_stop levels\solo\040_voi\music\040_music_04)
)
; =======================================================================================================================================================================
(script dormant music_040_05
	(print "start music 040_05")
	(sound_looping_start levels\solo\040_voi\music\040_music_05 NONE 1)
	
	(sleep_until 
		(or
			(volume_test_players vol_factory_b_tunnel)
			(not g_music_040_05)
		)
	)

	(print "stop music 040_05")
	(sound_looping_stop levels\solo\040_voi\music\040_music_05)
)
; =======================================================================================================================================================================
(script dormant music_040_06
	(sleep_until g_music_040_06)
	(print "start music 040_06")
	(sound_looping_start levels\solo\040_voi\music\040_music_06 NONE 1)
	
	(sleep_until (<= (ai_task_count lakebed_b_covenant_obj/wraith_gate) 0))
	(sound_looping_set_alternate levels\solo\040_voi\music\040_music_06 TRUE)

	(sleep_until (not g_music_040_06))
	(print "stop music 040_06")
	(sound_looping_stop levels\solo\040_voi\music\040_music_06)
)
; =======================================================================================================================================================================
(script dormant music_040_07
	(sleep_until g_music_040_07)
	(print "start music 040_07")
	(sound_looping_start levels\solo\040_voi\music\040_music_07 NONE 1)

	(sleep_until 
		(or
			(not g_music_040_07)
			(= (current_zone_set) 7)
		)
	)
	(print "stop music 040_07")
	(sound_looping_stop levels\solo\040_voi\music\040_music_07)
)
; =======================================================================================================================================================================
(script dormant music_040_08
	(sleep (* 30 60))
	(if (not (object_model_target_destroyed scarab_giant "indirect_engine"))
		(begin
			(print "start music 040_08")
			(sound_looping_start levels\solo\040_voi\music\040_music_08 NONE 1)
			
			(sleep_until (object_model_target_destroyed scarab_giant "indirect_engine"))
			(print "stop music 040_08")
			(sound_looping_stop levels\solo\040_voi\music\040_music_08)
		)
	)
)
; =======================================================================================================================================================================
(script dormant music_040_09
	(sleep_until g_music_040_09)
	(print "start music 040_09")
	(sound_looping_start levels\solo\040_voi\music\040_music_09 NONE 1)
	
	(sleep_until 
		(or
			(not g_music_040_09)
			(= (current_zone_set) 7)
		)
	)
	(print "stop music 040_09")
	(sound_looping_stop levels\solo\040_voi\music\040_music_09)
)
; =======================================================================================================================================================================
(script dormant music_040_10
	(sleep_until g_music_040_10)
	(print "start music 040_10")
	(sound_looping_start levels\solo\040_voi\music\040_music_10 NONE 1)

	(sleep_until 
		(or
			(not g_music_040_10)
			(= (current_zone_set) 7)
		)
	)
	(print "stop music 040_10")
	(sound_looping_stop levels\solo\040_voi\music\040_music_10)
)
; =======================================================================================================================================================================
(script dormant music_040_11
	(print "start music 040_11")
	(sound_looping_start levels\solo\040_voi\music\040_music_11 NONE 1)
)
; =======================================================================================================================================================================
(script dormant music_040_12
	(print "start music 040_12")
	(sound_looping_start levels\solo\040_voi\music\040_music_12 NONE 1)
	
	(sleep_until 
		(or
			(volume_test_players tv_cortana_03)
			(<= (ai_living_count work_cov_chief/chief) 0)
		)
	)
	(print "stop music 040_12")
	(sound_looping_stop levels\solo\040_voi\music\040_music_12)
)
; =======================================================================================================================================================================
(script dormant music_040_13
	(print "start music 040_13")
	(sound_looping_start levels\solo\040_voi\music\040_music_13 NONE 1)

	(sleep (* 30 58))
	(wake music_040_14)
	(wake music_040_15)
	
	(sleep_until (volume_test_players vol_bfg_advance) 30 (* 30 20))
	(wake music_040_16)
	
)
; =======================================================================================================================================================================
(script dormant music_040_14
	(print "start music 040_14")
	(sound_looping_start levels\solo\040_voi\music\040_music_14 NONE 1)

	(sleep_until 
		(or
			(<= (ai_task_count bfg_cov_obj/inf_gate) 5)
			(<= (ai_living_count bfg_cov01/chief) 0)
		)
	)
	(print "stop music 040_14")
	(sound_looping_stop levels\solo\040_voi\music\040_music_14)
)
; =======================================================================================================================================================================
(script dormant music_040_15
	(print "start music 040_15")
	(sound_looping_start levels\solo\040_voi\music\040_music_15 NONE 1)

	(sleep_until 
		(or
			(<= (ai_task_count bfg_cov_obj/inf_gate) 5)
			(<= (ai_living_count bfg_cov01/chief) 0)
		)
	)
	(print "stop music 040_15")
	(sound_looping_stop levels\solo\040_voi\music\040_music_15)
)
; =======================================================================================================================================================================
(script dormant music_040_16
	(print "start music 040_16")
	(sound_looping_start levels\solo\040_voi\music\040_music_16 NONE 1)

	(sleep_until 
		(or
			(<= (ai_task_count bfg_cov_obj/inf_gate) 5)
			(<= (ai_living_count bfg_cov01/chief) 0)
		)
	)
	(sound_looping_set_alternate levels\solo\040_voi\music\040_music_16 TRUE)

	(sleep_until (<= (object_get_health bfg_base) 0) 5)
	(print "stop music 040_16")
	(sound_looping_stop levels\solo\040_voi\music\040_music_16)
)
; ===================================================================================================================================================
; ===================================================================================================================================================
; MISSION DIALOGUE 
; ===================================================================================================================================================
; ===================================================================================================================================================

;*
+++++++++++++++++++++++
 DIALOGUE INDEX 
+++++++++++++++++++++++

br_int_01
md_int_dead_01
md_int_dead_02
md_int_flyby
md_int_storm
md_int_door
md_int_hog_cover
md_faa_door_hint_01a
md_faa_cov_flee
md_faa_door_hint_01b
md_faa_door_go
md_faa_door_hint_02
md_faa_radio_help
md_faa_joh_radio_help
md_faa_mar_help
md_laa_pier_help
md_laa_stop_help
md_laa_thanks_01
md_laa_thanks_02
md_laa_mar_fab_help_01
md_laa_joh_fab_help
md_laa_mar_fab_help_02
md_fab_new_contact
md_fab_flush
md_fab_hog_door
md_fab_turret_help
md_fab_thanks
md_fab_mar_combat
md_fab_mar_buggers
md_fab_mar_lab_help_01
md_fab_goose
md_fab_mar_lab_help_02
md_lab_thanks
md_lab_mar_gun_parts
md_lab_mar_cover_us
md_lab_mar_scarab_sound
md_lab_mar_scarab
md_lab_mar_scarab_hints_01
md_lab_mar_scarab_hints_02
md_lab_mar_scarab_dead
md_lab_mar_fire_in_hole
md_lab_mar_wall_gone_01
md_lab_mar_wall_gone_02
md_lab_mar_ark_01
br_ark_is_bad
+++++++++++++++++++++++
*;

(global boolean g_playing_dialogue FALSE)
(global boolean dialogue TRUE)

(global ai brute NONE)
(global ai female_marine NONE)
(global ai grunt NONE)
(global ai grunt_02 NONE)
(global ai marine NONE)
(global ai marine_01 NONE)
(global ai marine_02 NONE)
(global ai sergeant NONE)
(global ai gr_allies NONE)
(global ai gr_arbiter NONE)

; ===================================================================================================================================================

(script static void md_cleanup
	(ai_dialogue_enable TRUE)
)


(script dormant br_int_01
	(print "br:int:01")
	
	;(wake play_040BA)
	(ai_dialogue_enable FALSE)
	
		(if dialogue (print "MIRANDA (radio): Chief, The prophet of Truth has found the ark."))
		(sleep (ai_play_line_on_object NONE 040ba_010))
		(sleep 20)

		(if dialogue (print "MIRANDA (radio): Our only chance of stopping him is a surprise, aerial assault."))
		(sleep (ai_play_line_on_object NONE 040BA_020))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): Clear this sector of Covenant anti-air defenses…"))
		(sleep (ai_play_line_on_object NONE 040BA_030))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): Make a hole for the Admiral's ships."))
		(sleep (ai_play_line_on_object NONE 040BA_040))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): Good hunting. Keyes out."))
		(sleep (ai_play_line_on_object NONE 040BA_050))
		(sleep 10)

	;(wake objective_1_set)
	(ai_dialogue_enable TRUE)
	(sleep_until (volume_test_players vol_intro_briefing))
	(wake md_int_door)
)

; ===================================================================================================================================================

(script dormant md_int_dead_01
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:int:dead:01")

		; cast the actors
		(vs_cast intro_troop_hogs TRUE 0 "040MA_010" "040MA_030" "040MA_050" "040MA_090")
			(set marine_01 (vs_role 1))
			(set female_marine (vs_role 2))
			(set marine_02 (vs_role 3))
			(set sergeant (vs_role 4))

	; movement properties
	(vs_enable_pathfinding_failsafe intro_troop_hogs TRUE)
	(vs_enable_looking intro_troop_hogs  TRUE)
	(vs_enable_targeting intro_troop_hogs TRUE)
	(vs_enable_moving intro_troop_hogs TRUE)
	
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)

	(sleep 1)

		(sleep (random_range 5 200))
		(if dialogue (print "MARINE 01: Do you think there's anybody left?"))
		(vs_play_line marine_01 TRUE 040MA_020)
		
		(begin_random
			(begin
				(sleep (random_range 5 200))
				(if dialogue (print "FEMALE MARINE: Bombed back to the stone age"))
				(vs_play_line female_marine TRUE 040MA_030)
			)
			(begin
				(sleep (random_range 5 200))
				(if dialogue (print "FEMALE MARINE: This was a civilian town.  They didn't stand a chance."))
				(vs_play_line female_marine TRUE 040MA_040)
			)
			(begin
				(sleep (random_range 30 300))
				(if dialogue (print "MARINE 02: The whole place just feelsdead."))
				(vs_play_line marine_02 TRUE 040MA_050)
				(sleep 15)
				
				(if dialogue (print "MARINE 02: It's like a ghost town."))
				(vs_play_line marine_02 TRUE 040MA_060)
			)
			(begin
				(sleep (random_range 5 200))
				(if dialogue (print "MARINE 01: I heard we sent refugees here.  From Mombasa."))
				(vs_play_line marine_01 TRUE 040MA_070)
			)
			(begin
				(sleep (random_range 5 200))
				(if dialogue (print "MARINE 02: Gone.  Everything.  Everyone.  Gone."))
				(vs_play_line marine_02 TRUE 040MA_080)
			)
		)

	; cleanup
	;(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
	(vs_release_all)
	;in case the player is still fuckin around
	;(wake md_int_storm)
)

; ===================================================================================================================================================

(script dormant md_int_dead_02
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:int:dead:02")

		; cast the actors
		(vs_cast intro_troop_hogs TRUE 0 "040MA_110" "040MA_130" "040MA_140" "040MA_190")
			(set marine_01 (vs_role 1))
			(set marine_02 (vs_role 2))
			(set female_marine (vs_role 3))
			(set sergeant (vs_role 4))

	; movement properties
	(vs_enable_pathfinding_failsafe intro_troop_hogs TRUE)
	(vs_enable_looking intro_troop_hogs  TRUE)
	(vs_enable_targeting intro_troop_hogs TRUE)
	(vs_enable_moving intro_troop_hogs TRUE)
    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)

	(sleep 1)
		
		(if dialogue (print "MARINE 01: My god, what the hell happened here?"))
		(vs_play_line marine_01 TRUE 040MA_010)
		(sleep (random_range 10 20))

		(if dialogue (print "MARINE 01: This squad was ripped to pieces."))
		(vs_play_line marine_01 TRUE 040MA_110)
		(sleep 10)

		(if dialogue (print "MARINE 01: Anybody know who these guys were?"))
		(vs_play_line marine_01 TRUE 040MA_120)
		(sleep (random_range 30 40))

		(if dialogue (print "MARINE 02: I think this was 4th battalion.  Well, part of it."))
		(vs_play_line marine_02 TRUE 040MA_130)
		(sleep 10)
		
		(begin_random
			(begin
				(sleep (random_range 50 90))
				(if dialogue (print "FEMALE MARINE: These were the guys sent to secure the town."))
				(vs_play_line female_marine TRUE 040MA_140)
				(sleep 10)
				
				(if dialogue (print "FEMALE MARINE: Poor bastards had no idea what they were walking into."))
				(vs_play_line female_marine TRUE 040MA_150)
				(sleep 10)
				
				(if dialogue (print "MARINE 02: They didn't even make it inside the walls?"))
				(vs_play_line marine_02 TRUE 040MA_160)
				(sleep 10)
			)
			
			(begin
				(sleep (random_range 50 90))
				(if dialogue (print "MARINE 02: These guys were some of the best we had."))
				(vs_play_line marine_02 TRUE 040MA_170)
				(sleep (random_range 20 90))
				
				(if dialogue (print "MARINE 01: These men deserve better than to be left like this."))
				(vs_play_line marine_01 TRUE 040MA_180)
				(sleep 10)
			)
		)
		
		(begin_random
			(begin
				(sleep (random_range 20 50))
				(if dialogue (print "SERGEANT: Heroes.  Every last damn one of them."))
				(vs_play_line sergeant TRUE 040MA_190)
				(sleep 10)

				(if dialogue (print "SERGEANT: Put them out of your minds.  Ain't nothing to be done."))
				(vs_play_line sergeant TRUE 040MA_200)
				(sleep 10)
				
				; cleanup
				;(set g_playing_dialogue FALSE)
				(vs_release_all)
				(sleep (random_range 120 200))
				;(wake md_int_storm)
				(sleep_forever)
			)
			(begin
				(if dialogue (print "SERGEANT: Marines!  Keep your voices down."))
				(vs_play_line sergeant TRUE 040MA_090)
				(sleep (random_range 20 40))

				(if dialogue (print "SERGEANT: This place is crawling with Covenant."))
				(vs_play_line sergeant TRUE 040MA_100)
				(sleep 10)
				
				; cleanup
				;(set g_playing_dialogue FALSE)
				(vs_release_all)
				(sleep (random_range 120 200))
				;(wake md_int_storm)
				(sleep_forever)
			)
		)

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(sleep (random_range 120 200))
	(wake md_int_dead_01)
)

; ===================================================================================================================================================

(script dormant md_int_door
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:int:door")
	
	 ;cast the actors
		(vs_cast all_allies FALSE 0 "040MA_150")
			(set sergeant (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe sergeant TRUE)
	(vs_enable_looking sergeant  TRUE)
	(vs_enable_targeting sergeant TRUE)
	(vs_enable_moving sergeant TRUE)
    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)
		;*
		(if (<= (device_get_position factory_a_entry) 0)
		(begin
			(if dialogue (print "SERGEANT: Covenant's been in the city for more than 36 hours"))
			(sleep (ai_play_line sergeant 040MA_100))
			(sleep 10)
		)
		)

		(if (<= (device_get_position factory_a_entry) 0)
		(begin
			(if dialogue (print "SERGEANT: They're heavily entrenched. Expect stiff resistance."))
			(sleep (ai_play_line_on_object NONE 040MA_110))
			(sleep 10)
		)
		)

		
		(if (<= (device_get_position factory_a_entry) 0)
		(begin
			(if dialogue (print "SERGEANT: Also, we've gotten reports of a Scarab"))
			(sleep (ai_play_line_on_object NONE 040MA_120))
			(sleep 10)
		)
		)
		
		(if (<= (device_get_position factory_a_entry) 0)
		(begin
			(if dialogue (print "MARINE: Damn!"))
			(vs_play_line marine FALSE 040MA_130)
			(sleep 20)
		)
		)
		
		(if (<= (device_get_position factory_a_entry) 0)
		(begin
			(if dialogue (print "SERGEANT: So stay sharp!"))
			(sleep (ai_play_line sergeant 040MA_140))
			(sleep 20)
		)
		)
		*;

		(begin
			(if dialogue (print "SERGEANT: Ready when you are, Chief!"))
			(sleep (ai_play_line sergeant 040MA_150))
			(sleep 20)
		)

		(begin
			(if dialogue (print "SERGEANT: Open the door, take point. We'll cover you with the 50"))
			(sleep (ai_play_line sergeant 040MA_160))
		)

	; cleanup
	(ai_dialogue_enable TRUE)
	(set g_playing_dialogue FALSE)
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_int_hog_cover
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:int:hog:cover")

		; cast the actors
		(vs_cast intro_troop_hogs FALSE 0 "040MA_180")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)

	(sleep_until (volume_test_players vol_intro_hog_msg))
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)
	
		(begin_random
			(begin
				(vs_cast intro_hog TRUE 0 "040MA_180")
				(set marine (vs_role 1))
				(if dialogue (print "MARINE: Got your back, Sir!"))
				(sleep (ai_play_line marine 040MA_180))
				(vs_release_all)
				(sleep_forever)
			)
			(begin
				(vs_cast intro_hog TRUE 0 "040MA_190")
				(set marine (vs_role 1))
				(if dialogue (print "MARINE: Lead the way! We'll follow in the Hog."))
				(sleep (ai_play_line marine 040MA_190))
				(vs_release_all)
				(sleep_forever)
			)
		)

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_faa_cov_flee

	(print "mission dialogue:faa:cov:flee")

		; cast the actors
		;(vs_cast tank_room_a_covies TRUE 0 "040MB_030" "040MB_050")
			(set grunt tank_room_a_init_right/outside01)
			(set grunt_02 tank_room_a_init_right/outside02)

	; movement properties
	(vs_enable_pathfinding_failsafe grunt TRUE)
	(vs_enable_looking grunt  TRUE)
	(vs_enable_targeting grunt TRUE)
	(vs_enable_moving grunt TRUE)
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)
		;(vs_start_to grunt_02 TRUE factory_arm_a/grunt_scare)

		(if dialogue (print "GRUNT: The Demon!  Run!"))
		(vs_play_line grunt FALSE 040MB_010)
		;(sleep (random_range 40 70))

		;(if dialogue (print "BRUTE: Seal the doors!"))
		;(vs_play_line brute TRUE 040MB_040)
		;(sleep 10)

		(if dialogue (print "GRUNT: Wait for me!  Waaaiiit!  Whaaa!"))
		(vs_custom_animation grunt_02 TRUE objects\characters\grunt\grunt "combat:pistol:surprise_front" FALSE)
		(sleep 1)
		(vs_stop_custom_animation grunt_02)
		(sleep 1)
		(vs_play_line grunt_02 FALSE 040MB_030)
		(vs_go_to grunt_02 TRUE factory_arm_a/grunt_scare)

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_faa_door_hint_01a
	(sleep_until (<= (ai_task_count factory_a_covenant_obj/faa_cov_init) 0))
	(sleep (random_range 150 200))
	(print "mission dialogue:faa:door:hint:01a")
	(if (<= (device_get_position factory_a_entry02) 0)
	(begin
		; cast the actors
		(vs_cast all_allies TRUE 0 "040MB_040")
			(set sergeant (vs_role 1))


	; movement properties
	(vs_enable_pathfinding_failsafe sergeant TRUE)
	(vs_enable_looking sergeant  TRUE)
	(vs_enable_targeting sergeant TRUE)
	(vs_enable_moving sergeant TRUE)
	
    (vs_set_cleanup_script md_cleanup)	
	;(ai_dialogue_enable FALSE)
	(sleep 1)
				(if dialogue (print "SERGEANT: Chief, open the door and we can roll through."))
				(sleep (ai_play_line sergeant 040MB_040))
	)
	)

	; cleanup
	(vs_release_all)
	;(ai_dialogue_enable TRUE)
	(sleep (random_range 900 1000))
	(if (<= (device_get_position factory_a_entry02) 0)
		(wake md_faa_door_hint_01c)
	)
)

; ===================================================================================================================================================

(script dormant md_faa_door_hint_01b

	(print "mission dialogue:faa:door:hint:01a")

		; cast the actors
		(vs_cast all_allies TRUE 0 "040MB_050")
			(set sergeant (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe sergeant TRUE)
	(vs_enable_looking sergeant  TRUE)
	(vs_enable_targeting sergeant TRUE)
	(vs_enable_moving sergeant TRUE)
	
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)
		
		(if dialogue (print "SERGEANT: Door controls should be in the uppper walkway"))
		(sleep (ai_play_line sergeant 040MB_050))
		(sleep 10)

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_faa_door_hint_01c

	(print "mission dialogue:faa:door:hint:01c")

		; cast the actors
		;(vs_cast all_allies TRUE 0 "040MB_060")
		;	(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)
	
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)
	
		(if dialogue (print "MARINE: Sir? Open the door, and we can drive on through."))
		(sleep (ai_play_line marine 040MB_060))
		(sleep 10)

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(sleep (random_range 60 120))
	(sleep_until (volume_test_players vol_tank_room_a_start))
	(if (<= (device_get_position factory_a_entry02) 0)
		(wake md_faa_door_hint_01b)
	)
)

; ===================================================================================================================================================

(script dormant md_faa_door_go
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:faa:door:go")
	

		; cast the actors
		(vs_cast all_allies TRUE 0 "040MB_080")
			(set sergeant (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe sergeant TRUE)
	(vs_enable_looking sergeant  TRUE)
	(vs_enable_targeting sergeant TRUE)
	(vs_enable_moving sergeant TRUE)
	
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "SERGEANT: There we go! Hustle through, marines"))
		(sleep (ai_play_line sergeant 040MB_080))
		(sleep (random_range 10 50))

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(sleep_until (<= (ai_task_count factory_a_covenant_obj/tank_room_combat01) 0))
	(sleep (random_range 10 40))
	(if (<= (device_get_position factory_a_middle) 0)
		(wake md_faa_door_hint_02)
	)
)

; ===================================================================================================================================================

(script dormant md_faa_door_hint_02
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:faa:door:hint:02")
	

		; cast the actors
		(vs_cast all_allies TRUE 0 "040MB_100")
			(set sergeant (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe sergeant TRUE)
	(vs_enable_looking sergeant  TRUE)
	(vs_enable_targeting sergeant TRUE)
	(vs_enable_moving sergeant TRUE)

    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "SERGEANT: Open the door, Chief! We got you covered!"))
		(sleep (ai_play_line sergeant 040MB_100))
		(sleep 10)

	; cleanup
	;(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_faa_door_go_02
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:faa:door:go")
	

		; cast the actors
		(vs_cast all_allies TRUE 0 "040MB_080")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)

    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "MARINE: Push forward!  Give 'em hell!"))
		(sleep (ai_play_line marine 040MB_090))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_lake_a_radio_sitrep
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)
	(sleep (random_range 45 60))

	(print "mission dialogue:faa:radio:help")

	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "Lord Hood (radio): Kilo-two_three this is Forward unto Dawn..."))
		(sleep (ai_play_line_on_object NONE 040MB_120))
		(sleep 20)

		(if dialogue (print "Lord Hood (radio): I need a sitrep, Commander."))
		(sleep (ai_play_line_on_object NONE 040MB_130))
		(sleep 10)

		(if dialogue (print "Miranda (radio): Atmospheric disturbance is intensifying aborve the artifact, Admiral..."))
		(sleep (ai_play_line_on_object NONE 040MB_140))
		(sleep 10)

		;(if dialogue (print "Miranda (radio): Also, I'm registering a power-surge from the target vessel."))
		;(sleep (ai_play_line_on_object NONE 040MB_150))
		;(sleep 40)
		
		(if dialogue (print "Lord Hood (radio): And Sierra one-one-seven?"))
		(sleep (ai_play_line_on_object NONE 040MB_160))
		(sleep 20)

		(if dialogue (print "Miranda (radio): Moving as fast as he can, sir. I know he'll get it done"))
		(sleep (ai_play_line_on_object NONE 040MB_170))

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	
	;music
	(set g_music_040_02 FALSE)
	(wake music_040_03)
	(set g_music_040_03 TRUE)
	
	
	(sleep_until 
		(or
			(<= (ai_task_count lakebed_a_covenant_obj/wraith_gate) 0)
			(<= (ai_task_count lakebed_a_covenant_obj/center_structure) 0)
		)
	100)
	(sleep (* 30 10))
	(if (> (object_get_health (ai_vehicle_get_from_starting_location lakebed_a_wraith_01/driver01)) 0)
		(wake md_lake_a_radio_sitrep02)
	)
)

; ===================================================================================================================================================

(script dormant md_lake_a_radio_sitrep02
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:faa:joh:radio:help")
	
	(vs_set_cleanup_script md_cleanup)
	
	(ai_dialogue_enable FALSE)
	(sleep (random_range 30 60))
	
;	(if (>= (ai_living_count sergeant) 1)
		;if sergeant is alive:
;		(begin
			(if dialogue (print "SERGEANT: Gotta pick up the pace, Chief!"))
			(sleep (ai_play_line_on_object NONE 040MB_180))
			(sleep 20)
			
			(if dialogue (print "SERGEANT: Admiral needs that anti-air dead ASAP"))
			(sleep (ai_play_line_on_object NONE 040MB_190))
;		)
;*
		;if sergeant is dead:
		(begin
			(if dialogue (print "MARINE: Let's get going, Sir!"))
			(sleep (ai_play_line_on_object NONE 040MB_200))
			(sleep 10)
			
			(if dialogue (print "MARINE: Admiral's waiting for us to clear the anti-air!"))
			(sleep (ai_play_line_on_object NONE 040MB_210))
		)
*;
;	)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	;*
	(sleep_until (volume_test_players vol_lakebed_a))
	(sleep (random_range 900 1000))
	(if
		(and
			(<= (ai_task_status lakebed_a_covenant_obj/center_structure) 3)
			(>= (ai_living_count lakebed_a_def) 1)
		)
		(wake md_laa_pier_help)
	)
	*;
)

; ===================================================================================================================================================

(script dormant md_laa_pier_help
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:laa:pier:help")

		; cast the actors
		(vs_cast all_allies FALSE 1 "040MC_050")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)

    (vs_set_cleanup_script md_cleanup)
    (ai_dialogue_enable FALSE)
    
	(sleep 1)
		
		(if (not (volume_test_players vol_lakebed_a_bridge))
			(begin
				(if dialogue (print "MARINE: There! On the pier!"))
				(vs_play_line marine TRUE 040MC_050)
				(sleep 10)
				
				(if dialogue (print "MARINE: Those guys are getting hammered!"))
				(vs_play_line marine TRUE 040MC_060)
				(sleep 10)
				
				(if dialogue (print "MARINE: They ain't gunna last long without us!"))
				(vs_play_line marine TRUE 040MC_080)
			)
		)

	; cleanup
	(ai_dialogue_enable TRUE)
	(set g_playing_dialogue FALSE)
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_laa_wraith_dead
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:laa:wraith:dead")
	

		; cast the actors
		(vs_cast all_allies FALSE 0 "040MC_120")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "MARINE: Hell Yeah! Boom!"))
		(sleep (ai_play_line marine 040MC_120))
		(sleep 20)

		(if dialogue (print "MARINE: Fly-boys are gunna love us for that!"))
		(sleep (ai_play_line marine 040MC_130))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(sleep (random_range 20 50))
	(wake md_laa_mar_fab_help_01)
)

; ===================================================================================================================================================

(script dormant md_laa_mar_fab_help_01
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:laa:mar:fab:help:01")

	(ai_dialogue_enable FALSE)
	(sleep 1)
	(wake objective_2_set)

		(if dialogue (print "JOHNSON (radio): That-a-way, Chief! Target destroyed!"))
		(sleep (ai_play_line_on_object NONE 040MC_140))
		(sleep 60)

		(if dialogue (print "JOHNSON (radio, static): Move to the next area, over?"))
		(sleep (ai_play_line_on_object NONE 040MC_150))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(sleep_until (<= (ai_living_count lakebed_a_covenant_obj) 0))
	(sleep (* 30 120))
	(if (volume_test_players vol_lakebed_a)
		(wake md_laa_joh_fab_help)
	)
)

; ===================================================================================================================================================

(script dormant md_laa_joh_fab_help
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:laa:joh:fab:help")

	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "JOHNSON (radio): Chief! Keep moving around the crater!"))
		(sleep (ai_play_line_on_object NONE 040MC_180))
		(sleep 100)

		(if dialogue (print "JOHNSON (radio): Hurry, Chief! You need to find all the tanks."))
		(sleep (ai_play_line_on_object NONE 040MC_190))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_laa_mar_fab_help_02
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:laa:mar:fab:help:02")
	

		; cast the actors
		(vs_cast all_allies TRUE 0 "040MC_180" "040MC_190")
			(set marine (vs_role 1))
			(set marine_01 (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)

	(sleep 1)

		(if dialogue (print "MARINE: Let's go help those marines!"))
		(vs_play_line marine TRUE 040MC_180)
		(sleep 20)

		(if dialogue (print "MARINE: C'mon!  Doctors and pretty nurses!  They need us in there!"))
		(vs_play_line marine_01 TRUE 040MC_190)
		(sleep 10)

	; cleanup
	(ai_dialogue_enable TRUE)
	(set g_playing_dialogue FALSE)
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_fab_new_rahrah
	(sleep_until (or
			(sleep_until (volume_test_players vol_fab_entryroom))
			(<= (ai_task_count lakebed_a_covenant_obj/ground_wraith_gate) 0)
		)
	)

	(print "mission dialogue:fab:new:rahrah")
	

		; cast the actors
		(vs_cast factory_b_allies TRUE 0 "040MD_010")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)

    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	
	(if dialogue (print "MARINE: They just keep coming!"))
	(sleep (ai_play_line marine 040MD_010))

	; cleanup
	;(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_fab_new_contact
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:fab:new:contact")
	

		; cast the actors
		(vs_cast factory_b_allies FALSE 1 "040MD_020")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)

    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 50)

		(if dialogue (print "FEMALE MARINE: Check your fire! It's the Chief!"))
		(sleep (ai_play_line marine 040MD_020))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(sleep (random_range 50 90))
	(wake md_fab_flush)
)

; ===================================================================================================================================================

(script dormant md_fab_flush
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:fab:flush")
	

		; cast the actors
		(vs_cast factory_b_allies TRUE 0 "040MD_030")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)

    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "FEMALE MARINE: Flush 'em out, Sir!"))
		(sleep (ai_play_line marine 040MD_030))
		(sleep 25)

		(if dialogue (print "FEMALE MARINE: We'll nail em with the 50!"))
		(sleep (ai_play_line marine 040MD_040))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_fab_hog_door
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:fab:hog:door")
	
	;sleep this one for 80ticks... lame
	(wake md_fab_last_mags)

		; cast the actors
		(vs_cast factory_b_allies TRUE 0 "040MD_050" "040MX_050")
			(set marine (vs_role 1))
			(set marine_02 (vs_role 2))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)

    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)
		
		(if 
			(and
				(volume_test_object vol_fab (ai_vehicle_get_from_starting_location intro_hog/driver))
				(not (<= (object_get_health (ai_vehicle_get_from_starting_location intro_hog/driver)) 0))
			)
		(begin
		(if dialogue (print "MARINE: They've got a hog!"))
		(sleep (ai_play_line marine 040MD_050))
		(sleep 10)
		)
		)
		
		(if dialogue (print "MARINE: Open the door!"))
		(sleep (ai_play_line marine 040MX_050))
		(sleep (random_range 20 60))

		(if dialogue (print "MARINE: Hurry!  Before any more Covenant show up!"))
		(sleep (ai_play_line marine 040MD_060))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_fab_last_mags
	(sleep_until (or
			(volume_test_players vol_factory_b_center)
			(>= (ai_task_count factory_b_cov_obj/buggers_arrive_gate) 1)
		)
	)
	
	;thanks to the casting bs from above
	(sleep 80)

	(print "mission dialogue:fab:turret:help")
	

		; cast the actors
		(vs_cast factory_b_allies FALSE 0 "040MD_070")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)

    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)
	(if (<= (ai_task_count factory_b_cov_obj/buggers_arrive_gate) 0)
	(begin
		(if dialogue (print "MARINE: We're down to our last mags, sir..."))
		(vs_play_line marine TRUE 040MD_070)
		(sleep 10)
	)
	)
	
	(if (<= (ai_task_count factory_b_cov_obj/buggers_arrive_gate) 0)
	(begin
		(if dialogue (print "MARINE: Thought those last ones had us."))
		(vs_play_line marine TRUE 040MD_080)
		(sleep 10)
	)
	)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_fab_thanks
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:fab:thanks")
	

		; cast the actors
		(vs_cast factory_b_allies TRUE 0 "040MD_160")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)

    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "FEMALE MARINE: Clear! Check the wounded!"))
		(vs_play_line female_marine TRUE 040MD_160)
		(sleep 10)

		(if dialogue (print "FEMALE MARINE: We spotted Wraiths in the next lakebed, sir..."))
		(vs_play_line female_marine TRUE 040MD_170)
		(sleep 10)
		
		(if dialogue (print "FEMALE MARINE: Our orders were to hold here until we got some support..."))
		(vs_play_line female_marine TRUE 040MD_180)
		(sleep 10)
		
		(if dialogue (print "FEMALE MARINE: I guess that's you."))
		(vs_play_line female_marine TRUE 040MD_190)
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_fab_mar_buggers
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)
	(sleep 60)
	(print "mission dialogue:fab:mar:buggers")
	

		; cast the actors
		(vs_cast factory_b_allies TRUE 0 "040MD_100" "040MD_110")
			(set marine (vs_role 1))
			(set marine_01 (vs_role 2))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)
	
	(vs_enable_pathfinding_failsafe marine_01 TRUE)
	(vs_enable_looking marine_01  TRUE)
	(vs_enable_targeting marine_01 TRUE)
	(vs_enable_moving marine_01 TRUE)

    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "MARINE: Hey! You hear something?"))
		(sleep (ai_play_line marine 040MD_100))
		(sleep 10)
		
		(sleep_until (>= (ai_task_count factory_b_cov_obj/buggers_arrive_gate) 1) 10)
		(if dialogue (print "MARINE: Sounds like... Drones!"))
		(sleep (ai_play_line marine_01 040MD_060))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(sleep 110)
	(wake md_fab_mar_buggers_02)
)

; ===================================================================================================================================================

(script dormant md_fab_mar_buggers_02
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:fab:mar:buggers:02")
	

		; cast the actors
		(vs_cast factory_b_allies TRUE 0 "040MD_120" "040MD_130")
			(set marine (vs_role 1))
			(set marine_01 (vs_role 2))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)
	
	(vs_enable_pathfinding_failsafe marine_01 TRUE)
	(vs_enable_looking marine_01  TRUE)
	(vs_enable_targeting marine_01 TRUE)
	(vs_enable_moving marine_01 TRUE)
	
    (vs_set_cleanup_script md_cleanup)
    (ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "MARINE: There's too many!"))
		(sleep (ai_play_line marine 040MD_120))
		(sleep 10)
		
		(if dialogue (print "MARINE: Fall Back! Fall Back!"))
		(sleep (ai_play_line marine 040MD_130))
		(sleep 10)
		
		(if dialogue (print "MARINE: Get the door!"))
		(sleep (ai_play_line marine 040MD_140))
		(sleep 10)

	; cleanup
	(ai_dialogue_enable TRUE)
	(set g_playing_dialogue FALSE)
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_fab_more_wraiths
	(sleep_until (or
			(volume_test_players vol_factory_b_tunnel_end)
			(<= (ai_task_count factory_b_cov_obj/buggers_arrive_gate) 0)
		)
	)
	(sleep 80)
	
	(set g_playing_dialogue TRUE)
	(ai_dialogue_enable FALSE)
	(sleep 1)
	
		(if dialogue (print "JOHNSON (radio): You got anti-air Wraiths in the next lakebed, Chief!"))
		(sleep (ai_play_line_on_object NONE 040MD_240))
		(sleep 10)
		;*
		(sleep_until (volume_test_players vol_drive_factory_b_end))
		(if dialogue (print "JOHNSON (radio): Use rockets! Hit 'em hard!"))
		(sleep (ai_play_line_on_object NONE 040MD_250))
		(sleep 10)
		*;
	; cleanup
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
	(cs_run_command_script female_marine pause_forever)
	(sleep_until (volume_test_players vol_lakebed_b_ledge) 30 (* 30 25))
	(if (>= (ai_living_count lakebed_b_covenant_obj/dumb_init) 1)
		(md_fab_mar_lab_help_02)
	)
	(cs_run_command_script female_marine abort)
)

; ===================================================================================================================================================

(script dormant md_fab_goose
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:fab:goose")
	

		; cast the actors
		(vs_cast allied_goose TRUE 1 "040MD_200")
			(set female_marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe female_marine TRUE)
	(vs_enable_looking female_marine  TRUE)
	(vs_enable_targeting female_marine TRUE)
	;(vs_enable_moving allied_goose TRUE)
    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)
		(if dialogue (print "FEMALE MARINE (radio 3D): Mount up! Rockets in back!"))
		(sleep (ai_play_line female_marine 040MD_200))
		(sleep 10)
	
	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_punch_hard
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:punch:hard")
	

		; cast the actors
		(vs_cast allied_goose FALSE 1 "040MD_230")
			(set female_marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe female_marine TRUE)
	(vs_enable_looking female_marine  TRUE)
	(vs_enable_targeting female_marine TRUE)
	;(vs_enable_moving allied_goose TRUE)

	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "FEMALE MARINE (radio 3D): We gotta move fast and punch hard!"))
		(sleep (ai_play_line female_marine 040MD_230))
		;(sleep 10)
		
		;music
		(wake music_040_06)
		(set g_music_040_06 TRUE)
	
	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(wake md_fab_more_wraiths)
)

; ===================================================================================================================================================

(script static void md_fab_mar_lab_help_02
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:fab:mar:lab:help:02")
	

		; cast the actors
		(vs_cast allied_goose TRUE 1 "040MD_260")
			(set female_marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe female_marine TRUE)
	(vs_enable_looking female_marine  TRUE)
	(vs_enable_targeting female_marine TRUE)
	;(vs_enable_moving allied_goose TRUE)
    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "FEMALE MARINE: Let's get those Wraiths, sir! Come on!"))
		(sleep (ai_play_line female_marine 040MD_260))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(cs_run_command_script female_marine pause_forever)
)

; ===================================================================================================================================================

(script dormant md_lab_wraith01
	;(sleep_until (and
	;		(not g_playing_dialogue)
	;		TRUE
	;	)
	;)

	(print "mission dialogue:lab:wraith01")
	

		; cast the actors
		(vs_cast lake_b_def_center FALSE 0 "040ME_040")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)
    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "Marine: One down, one to go!"))
		(vs_play_line marine TRUE 040ME_040)
		(sleep 10)

	; cleanup
	(vs_release_all)
;*
	(sleep 60)
		
		(if dialogue (print "JOHNSON (radio): Wraith down!"))
		(sleep (ai_play_line_on_object NONE 040ME_050))
		(sleep 10)
		
		(if dialogue (print "JOHNSON (radio): But you still have one more in your area, Chief!"))
		(sleep (ai_play_line_on_object NONE 040ME_051))
		(sleep 10)
*;		
	(ai_dialogue_enable TRUE)
	
	;(sleep_until (<= (ai_task_count lakebed_b_covenant_obj/wraith_gate) 0))
	;(wake md_lab_wraith02)
)

; ===================================================================================================================================================

(script dormant md_lab_wraith02
	(print "mission dialogue:lab:wraith02")
	(sleep (random_range 30 100))
	(ai_dialogue_enable FALSE)
	
	(if (= (game_insertion_point_get) 0)
	(begin
		
		(if dialogue (print "JOHNSON (radio): Both AA Wraiths have been neutralized!"))
		(sleep (ai_play_line_on_object NONE 040ME_052))
		(sleep 10)
		
	)
	)
		
	; cleanup
	(ai_dialogue_enable TRUE)
	
	(sleep (random_range 45 60))
	(wake md_lab_something_big)
)

; ===================================================================================================================================================

(script dormant md_lab_something_big
	(print "mission dialogue:lab:something_big")
	;(sleep (random_range 30 100))
	(ai_dialogue_enable FALSE)

		(if dialogue (print "JOHNSON (radio): Standby… something big... closing in on your location… "))
		(sleep (ai_play_line_on_object NONE 040ME_053))
		(sleep 10)
		
		;music 
		(set g_music_040_06 FALSE)
		
	; cleanup
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_lab_few_pelicans
	(print "mission dialogue:few:pelicans")
	;(wake play_040BA)
	(set g_playing_dialogue TRUE)
	(ai_dialogue_enable FALSE)
	
		(if dialogue (print "MIRANDA (radio): Well done, Chief!"))
		(sleep (ai_play_line_on_object NONE 040BB_010))
		(sleep 20)

		(if dialogue (print "MIRANDA (radio): I'm sending in a few Pelicans…"))
		(sleep (ai_play_line_on_object NONE 040BB_020))
		(sleep 10)
	
	(sleep (random_range 90 150))
		(if dialogue (print "JOHNSON (radio): One more target, Chief!"))
		(sleep (ai_play_line_on_object NONE 040ME_054))
		(sleep 10)
		
		(if dialogue (print "JOHNSON (radio): There's a Covenant AA gun in the next area!"))
		(sleep (ai_play_line_on_object NONE 040ME_055))
		(sleep 10)
		
		(wake objective_4_set)
		
		(if dialogue (print "JOHNSON (radio): Take it down, and Lord Hood can start his attack run!"))
		(sleep (ai_play_line_on_object NONE 040ME_056))
		(sleep 10)
		
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================
;*
(script dormant md_lab_mar_gun_parts
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:lab:mar:gun:parts")
	

		; cast the actors
		(vs_cast SQUAD TRUE 0 "040ME_050")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies  TRUE)
	(vs_enable_targeting gr_allies TRUE)
	(vs_enable_moving gr_allies TRUE)

	(sleep 1)

		(if dialogue (print "MARINE: What are those Phantoms carrying?"))
		(vs_play_line marine TRUE 040ME_050)
		(sleep 10)

		(if dialogue (print "MARINE: Looks like they're flying in artillery."))
		(vs_play_line marine TRUE 040ME_060)
		(sleep 10)

		(if dialogue (print "MARINE: If that gun goes online, we've lost our avenue of attack."))
		(vs_play_line marine TRUE 040ME_070)
		(sleep 10)

		(if dialogue (print "MARINE: We're going to need to take that thing out."))
		(vs_play_line marine TRUE 040ME_080)
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_lab_mar_cover_us
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:lab:mar:cover:us")
	

		; cast the actors
		(vs_cast SQUAD TRUE 0 "040ME_090")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe gr_allies TRUE)
	(vs_enable_looking gr_allies  TRUE)
	(vs_enable_targeting gr_allies TRUE)
	(vs_enable_moving gr_allies TRUE)

	(sleep 1)

		(if dialogue (print "MARINE: Should take just a few minutes to set the charges."))
		(vs_play_line marine TRUE 040ME_090)
		(sleep 10)

		(if dialogue (print "MARINE: Watch our backs."))
		(vs_play_line marine TRUE 040ME_100)
		(sleep 10)

		(if dialogue (print "MARINE: This would be a bad time for more Covenant to show up."))
		(vs_play_line marine TRUE 040ME_110)
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
)

; ===================================================================================================================================================
*;
(script dormant md_lab_mar_scarab_sound
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:lab:mar:scarab:sound")


	(ai_dialogue_enable FALSE)
	(sleep 1)
	(print "scarab sounds")
	(sound_impulse_start sound\device_machines\scarab\scarab_roar_distant scarab_sound 2)
	(sleep 70)

		(if dialogue (print "MARINE: What's that sound?"))
		(sleep (ai_play_line_on_object NONE 040ME_131))
		(sleep (random_range 50 70))

		(if dialogue (print "MARINE: It's getting closer!"))
		(sleep (ai_play_line_on_object NONE 040ME_132))
		(sleep (random_range 50 110))
		
		(if dialogue (print "MARINE: This can't be good, man…"))
		(sleep (ai_play_line_on_object NONE 040ME_133))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_lab_mar_scarab
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:lab:mar:scarab")
	
	;*
		; cast the actors
		(vs_cast lake_b_def_center FALSE 0 "040ME_140")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe lake_b_def_center TRUE)
	(vs_enable_looking lake_b_def_center  TRUE)
	(vs_enable_targeting lake_b_def_center TRUE)
	(vs_enable_moving lake_b_def_center TRUE)
	*;

	(sleep (* 30 6))
	(ai_dialogue_enable FALSE)

		(if dialogue (print "MARINE: Scarab!"))
		(sleep (ai_play_line_on_object NONE 040ME_140))
		(sleep 10)

		(if dialogue (print "MARINE: Find some cover! Now!"))
		(sleep (ai_play_line_on_object NONE 040ME_150))
		(sleep 10)
		
		(if (= (game_insertion_point_get) 0)
			(begin
				;music
				(wake music_040_07)
				(set g_music_040_07 TRUE)
			)
		)
		
	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(game_save)
	(sleep (* 30 15))
	(wake md_lab_mar_scarab_hints_01)
)

; ===================================================================================================================================================

(script dormant md_lab_mar_scarab_hints_01
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:lab:mar:scarab:hints:01")
	
	;*
		; cast the actors
		(vs_cast lake_b_def_center FALSE 0 "040ME_160" "040ME_170")
			(set marine_01 (vs_role 1))
			(set marine_02 (vs_role 2))

	; movement properties
	(vs_enable_pathfinding_failsafe lake_b_def_center TRUE)
	(vs_enable_looking lake_b_def_center  TRUE)
	(vs_enable_targeting lake_b_def_center TRUE)
	(vs_enable_moving lake_b_def_center TRUE)
	*;
	(ai_dialogue_enable FALSE)
	(sleep 1)
		
		;*
		(if dialogue (print "MARINE 01: There's no way we can stop that thing!"))
		(sleep (ai_play_line marine_01 040ME_160))
		(sleep 120)
		
		(if dialogue (print "MARINE 02: The Chief can do it again.  And we can help."))
		(vs_play_line marine_02 TRUE 040ME_170)
		(sleep 10)

		(if dialogue (print "MARINE 01: Help?!?  Are you crazy?"))
		(vs_play_line marine_01 TRUE 040ME_180)
		(sleep 10)

		(if dialogue (print "MARINE 02: All we need to do is distract it..."))
		(vs_play_line marine_02 TRUE 040ME_190)
		(sleep 10)

		(if dialogue (print "MARINE 02: Long enough for the Chief to get on board."))
		(vs_play_line marine_02 TRUE 040ME_200)
		(sleep 10)
		
		(if dialogue (print "MARINE 02: Sir! Find a way up onto that Scarab!"))
		(sleep (ai_play_line_on_object NONE 040ME_210))
		;(vs_play_line marine_02 TRUE 040ME_210)
		(sleep 10)
		*;
		(sleep (* 30 70))
		(if 
		(and
			(not (object_model_target_destroyed scarab_giant "indirect_engine"))
			(not (volume_test_players vol_scarab_top))
			(<= (object_buckling_magnitude_get scarab_giant) 0)
		)
		(begin
		(if dialogue (print "MARINE 02: We'll try to draw its fire."))
		(sleep (ai_play_line_on_object NONE 040ME_220))
		;(vs_play_line marine_02 TRUE 040ME_240)
		(sleep 40)
		)
		)
		
		(if 
		(and
			(not (object_model_target_destroyed scarab_giant "indirect_engine"))
			(not (volume_test_players vol_scarab_top))
			(<= (object_buckling_magnitude_get scarab_giant) 0)
		)
		(begin
		(if dialogue (print "MARINE (radio 3D): Use rockets! Target its joints!"))
		(sleep (ai_play_line_on_object NONE 040ME_230))
		;(vs_play_line marine_02 TRUE 040ME_250)
		(sleep 10)
		)
		)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(wake md_lab_mar_scarab_hints_03)
)

; ===================================================================================================================================================
;*
(script dormant md_lab_mar_scarab_hints_02
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:lab:mar:scarab:hints:02")
	

		; cast the actors
		(vs_cast lake_b_def_center TRUE 0 "040ME_250")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe lake_b_def_center TRUE)
	(vs_enable_looking lake_b_def_center  TRUE)
	(vs_enable_targeting lake_b_def_center TRUE)
	(vs_enable_moving lake_b_def_center TRUE)

	(sleep 1)

		(if dialogue (print "MARINE (radio 3D): Use your rockets, marines!  Try to hit a joint or something!"))
		(vs_play_line marine TRUE 040ME_250)
		(sleep 10)

		(if dialogue (print "MARINE (radio 3D): Slam a rocket into its kneecaps!"))
		(vs_play_line marine TRUE 040ME_260)
		(sleep 10)

		(if dialogue (print "MARINE (radio 3D): Find a way inside that thing, Chief!"))
		(vs_play_line marine TRUE 040ME_270)
		(sleep (random_range 300 400))

		(if dialogue (print "MARINE (radio 3D): Try to get on its back!"))
		(vs_play_line marine TRUE 040ME_280)
		(sleep 10)

		(if dialogue (print "MARINE (radio 3D): Get to high ground, Chief!  Find a way onto the deck!"))
		(vs_play_line marine TRUE 040ME_290)
		(sleep 10)

		(if dialogue (print "MARINE (radio 3D): Its armor is too thick!  You need to get to its guts!"))
		(vs_play_line marine TRUE 040ME_300)
		(sleep (random_range 300 400))

		(if dialogue (print "MARINE (radio 3D): It's got to be vulnerable inside, Chief!"))
		(vs_play_line marine TRUE 040ME_310)
		(sleep (random_range 300 400))

		(if dialogue (print "MARINE (radio 3D): Find its power core and blow that thing!"))
		(vs_play_line marine TRUE 040ME_320)
		(sleep (random_range 300 400))

		(if dialogue (print "MARINE (radio 3D): The power core, Chief!  You'll know it when you see it!"))
		(vs_play_line marine TRUE 040ME_330)
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
)
*;
; ===================================================================================================================================================

(script dormant md_lab_mar_scarab_hints_03
	(sleep (* 30 100))
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)
	
	(sound_looping_set_alternate levels\solo\040_voi\music\040_music_08 TRUE)
	(print "mission dialogue:lab:mar:scarab:hints:02")
	(ai_dialogue_enable FALSE)
	(sleep 1)
		(if 
		(and
			(not (object_model_target_destroyed scarab_giant "indirect_engine"))
			(not (volume_test_players vol_scarab_top))
			(<= (object_buckling_magnitude_get scarab_giant) 0)
		)
		(begin
			(if dialogue (print "JOHNSON (radio): Armor's too thick! Gotta take it out from the inside!"))
			(sleep (ai_play_line_on_object NONE 040ME_370))
			(sleep (* 30 20))
		)
		)
		
		(if
		(and
			(not (object_model_target_destroyed scarab_giant "indirect_engine"))
			(not (volume_test_players vol_scarab_top))
			(<= (object_buckling_magnitude_get scarab_giant) 0)
		)
		(begin
			(if dialogue (print "JOHNSON (radio): Try to get on its back!"))
			(sleep (ai_play_line_on_object NONE 040ME_350))
			(sleep (* 30 20))

			(if dialogue (print "JOHNSON (radio): Jump on top of it, Chief! Just like New Mombasa!"))
			(sleep (ai_play_line_on_object NONE 040ME_360))
			(sleep (* 30 20))
		)
		)


		(begin_random
			(begin
				(if
				(and
					(not (object_model_target_destroyed scarab_giant "indirect_engine"))
					(not (volume_test_players vol_scarab_top))
					(<= (object_buckling_magnitude_get scarab_giant) 0)
				)
				(begin
					(if dialogue (print "JOHNSON (radio): Armor's too thick! Gotta take it out from the inside!"))
					(sleep (ai_play_line_on_object NONE 040ME_370))
					(sleep (* 30 20))
				)
				)
			)
			(begin
				(if
				(and
					(not (object_model_target_destroyed scarab_giant "indirect_engine"))
					(not (volume_test_players vol_scarab_top))
					(<= (object_buckling_magnitude_get scarab_giant) 0)
				)
				(begin
					(if dialogue (print "JOHNSON (radio): Try to get on its back!"))
					(sleep (ai_play_line_on_object NONE 040ME_350))
					(sleep (* 30 20))
				)
				)
			)
		)

	; cleanup
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_lab_mar_scarab_hints_04
	
	(sleep (* 30 50))
	(sleep_until
	(begin
		(begin_random
			(begin
				(if 
					(and
						(not (object_model_target_destroyed scarab_giant "indirect_engine"))
						(volume_test_players vol_scarab)
					)
				(begin
					(ai_dialogue_enable FALSE)
					(if dialogue (print "JOHNSON (radio): Look for a weak spot, Chief!"))
					(sleep (ai_play_line_on_object NONE 040ME_380))
					(sleep 10)
					(if dialogue (print "JOHNSON (radio): A power-core! Something like that!"))
					(sleep (ai_play_line_on_object NONE 040ME_390))
					(ai_dialogue_enable TRUE)
					(sleep (* 30 40))
				)
				)
			)
			(begin
				(if 
					(and
						(not (object_model_target_destroyed scarab_giant "indirect_engine"))
						(volume_test_players vol_scarab)
					)
				(begin
					(ai_dialogue_enable FALSE)
					(if dialogue (print "JOHNSON (radio): Looks for the core, Chief! You'll know it when you see it!"))
					(sleep (ai_play_line_on_object NONE 040ME_400))
					(ai_dialogue_enable TRUE)
					(sleep (* 30 40))
				)
				)
			)
		)
		FALSE
	)
	)
)

; ===================================================================================================================================================

(script dormant md_scarab_inside
	(sleep_until 
		(and
			(not g_playing_dialogue)
			(>= (object_buckling_magnitude_get scarab_giant) .5)
			(not (object_model_target_destroyed scarab_giant "indirect_engine"))
		)
	)
	(sleep 60)
	(if (not (volume_test_players vol_scarab))
		(begin
			(print "mission dialogue:scarab:inside")
			(ai_dialogue_enable FALSE)
			(sleep 1)
			
				(if dialogue (print "MARINE (radio): Now! While it's down! Find a way inside!"))
				(sleep (ai_play_line_on_object NONE 040ME_250))
			
			; cleanup
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
)

; ===================================================================================================================================================

(script dormant md_scarab_get_off
	(sleep_until 
		(and
			(not g_playing_dialogue)
			(object_model_target_destroyed scarab_giant "indirect_engine")
		)
	)
	(sleep 60)
	(if (volume_test_players vol_scarab)
		(begin
			(print "mission dialogue:scarab:get:0ff")
			(ai_dialogue_enable FALSE)
			(sleep 1)
			
				(if dialogue (print "MARINE (radio): Get away! It's gunna blow!"))
				(sleep (ai_play_line_on_object NONE 040MQ_030))
			
			; cleanup
			(set g_playing_dialogue FALSE)
			(ai_dialogue_enable TRUE)
		)
	)
)

; ===================================================================================================================================================

(script dormant md_lab_mar_scarab_dead
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)
	(sleep (random_range 15 30))

	(print "mission dialogue:lab:mar:scarab:dead")
	

		; cast the actors
		(vs_cast lake_b_def_center TRUE 0 "040ME_410")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)
    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "MARINE: I don't believe it!  He killed a Scarab!"))
		(sleep (ai_play_line marine 040ME_410))
		(sleep 10)

		;(if dialogue (print "MARINE: Hell Yeah!  Spartan beats scarab!"))
		;(vs_play_line marine TRUE 040ME_420)
		;(sleep 80)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_lab_joh_back_inside
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:lab:joh:back:inside")
	(ai_dialogue_enable FALSE)
	(sleep 1)
		
		(if dialogue (print "JOHNSON (radio): Aint got time for celecration, marines!"))
		(sleep (ai_play_line_on_object NONE 040ME_430))
		(sleep 10)
		
		(if dialogue (print "JOHNSON (radio): Cut through the warehouse, get to that gun!"))
		(sleep (ai_play_line_on_object NONE 040ME_440))
		(sleep (* 30 30))
		
		(if dialogue (print "JOHNSON (radio): Keep going, Chief! Head back inside!"))
		(sleep (ai_play_line_on_object NONE 040ME_470))
		(sleep (* 30 40))
		
		(if dialogue (print "JOHNSON (radio): Chief! Forward progress! Come on!"))
		(sleep (ai_play_line_on_object NONE 040ME_480))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_arb_entrance
	(sleep_until	(and
					(not g_playing_dialogue)
					(<= (objects_distance_to_object (players) arbiter) 5)
				)
	)
	(print "mission dialogue:arb:entrance")
	

		; cast the actors
		(vs_cast arbiter FALSE 0 "040MQ_020")
			(set gr_arbiter (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe arbiter TRUE)
	(vs_enable_looking arbiter  TRUE)
	(vs_enable_targeting arbiter TRUE)
	(vs_enable_moving arbiter TRUE)
	(vs_set_cleanup_script md_cleanup)
	(set g_playing_dialogue TRUE)
	(ai_dialogue_enable TRUE)
	(sleep 1)
		
		;music
		(wake music_040_10)
		(set g_music_040_10 TRUE)
		
		(if dialogue (print "ARBITER: There was honor in our Covenant once...and there shall be again!"))
		(sleep (ai_play_line gr_arbiter 040MQ_020))
		(sleep 10)
	
	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_cor_mar_locked_down
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:cor:mar:locked:down")
	

		; cast the actors
		(vs_cast all_allies FALSE 0 "040MF_010")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)
	(vs_set_cleanup_script md_cleanup)
	(set g_playing_dialogue TRUE)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "MARINE: We got this area locked down, sir!"))
		(sleep (ai_play_line marine 040MF_010))
		(sleep 10)

		(if dialogue (print "MARINE: Follow us! We'll get you through!"))
		(sleep (ai_play_line marine 040MF_020))
		(sleep 10)
		
		;music
		(set g_music_040_07 FALSE)
		(set g_music_040_09 FALSE)
		(set g_music_040_10 FALSE)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	;(sleep (random_range 40 60))
	;(wake md_laa_last_night)
)

; ===================================================================================================================================================

(script dormant md_laa_last_night
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:laa:thanks:01")
	

		; cast the actors
		(vs_cast all_allies FALSE 0 "040MC_090")
			(set sergeant (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe sergeant TRUE)
	(vs_enable_looking sergeant  TRUE)
	(vs_enable_targeting sergeant TRUE)
	(vs_enable_moving sergeant TRUE)
    (vs_set_cleanup_script md_cleanup)
	(sleep 1)

		(if dialogue (print "SERGEANT: We infilled last night, sir. Twenty-one hundred."))
		(sleep (ai_play_line sergeant 040MC_090))
		(sleep (random_range 10 100))

		(if dialogue (print "SERGEANT: Ran into multiple bravo kilos, had to split my squads."))
		(sleep (ai_play_line sergeant 040MC_100))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(sleep (random_range 200 300))
	(wake md_cor_mar_safest_place)
)

; ===================================================================================================================================================

(script dormant md_cor_mar_safest_place
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:cor:mar:safest:place")
	

		; cast the actors
		(vs_cast cortana_office_allies TRUE 0 "040MF_030")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)
    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "MARINE: Warehouse was the safest place for all the civilians"))
		(sleep (ai_play_line marine 040MF_030))
		(sleep 10)

		(if dialogue (print "MARINE: Most are locals. Some are from Mombasa..."))
		(sleep (ai_play_line marine 040MF_040))
		(sleep 90)
		
		;(if dialogue (print "MARINE: None of 'em are fit to fight."))
		;(vs_play_line marine TRUE 040MF_050)
		;(sleep 10)
		
		(if dialogue (print "MARINE: We got hostiles in the surrounding buildings..."))
		(sleep (ai_play_line marine 040MF_060))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_office_morphine
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:office:morphine")
	
		; cast the actors
		(vs_cast cortana_office_allies02/medic01 FALSE 0 "040mq_040")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	(vs_enable_looking marine  TRUE)
	(vs_enable_targeting marine TRUE)
	(vs_enable_moving marine TRUE)
	(vs_set_cleanup_script md_cleanup)
	(sleep 1)

		(if dialogue (print "MARINE: Some one get me some morphine!"))
		(sleep (ai_play_line marine 040mq_040))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	
	; wake mission dialogue 
	(wake vig_office_radio)
)

; ===================================================================================================================================================

(script dormant md_work_mir_single_ship
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:work:mir:single:ship")
	(ai_dialogue_enable FALSE)
	(sleep 1)
		
		(if dialogue (print "MIRANDA (radio): Admiral? A single Covenant ship just slipped in-system!"))
		(sleep (ai_play_line_on_object NONE 040MH_040))
		(sleep 10)
		
		(if dialogue (print "HOOD (radio): Just one? What's its range and disposition?"))
		(sleep (ai_play_line_on_object NONE 040MH_050))
		(sleep 10)
		
		(if dialogue (print "MIRANDA (radio): Above the artifact, inside the orbital line. Seems to be holding stready."))
		(sleep (ai_play_line_on_object NONE 040MH_060))
		(sleep 10)
		
		(if dialogue (print "HOOD (radio): The attack proceeds as planned, Commander..."))
		(sleep (ai_play_line_on_object NONE 040MH_070))
		(sleep 10)
		
		(if dialogue (print "HOOD (radio): We're not going to get another shot at Truth"))
		(sleep (ai_play_line_on_object NONE 040MH_080))
		(sleep 10)
		
		(if dialogue (print "MIRANDA (radio): Sir, yes sir!"))
		(sleep (ai_play_line_on_object NONE 040MH_090))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_hunter_hints
	(print "mission dialogue:hunter:hints")
	(if
		(or
			(difficulty_heroic)
			(difficulty_legendary)
		)
		(sleep (* 30 90))
		(sleep (* 30 30))
	)
		
	(if 
		(and
			(>= (ai_living_count ware_cov_hunters) 2)
			(volume_test_players vol_warehouse_backhalf)
		)
		(begin
		(ai_dialogue_enable FALSE)
		(if dialogue (print "Sergeant (radio): Gotta get around behind them, Chief!"))
		(sleep (ai_play_line_on_object NONE 040MG_270))
		(sleep 10)
		(if dialogue (print "Sergeant (radio): Look for gaps in their armor!"))
		(sleep (ai_play_line_on_object NONE 040MG_280))
		(ai_dialogue_enable TRUE)
		)
	)
)

; ===================================================================================================================================================
(script dormant md_arb_truth_response
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)
	
	(sleep 90)
	(print "mission dialogue:arb:truth:response")
	

		; cast the actors
		(vs_cast arbiter FALSE 0 "040MQ_010")
			(set gr_arbiter (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe arbiter TRUE)
	;(vs_enable_looking arbiter  TRUE)
	;(vs_enable_targeting arbiter TRUE)
	;(vs_enable_moving arbiter TRUE)
	
	(vs_go_to gr_arbiter TRUE worker_pts/arbiter01)
	(vs_face_object gr_arbiter TRUE truth_worker)
	
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "ARBITER: I will not be shamed! Not again! Not by you!"))
		(sleep (ai_play_line gr_arbiter 040MQ_010))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_work_pil_energy_cascades
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:work:pil:energy:cascades")
	(ai_dialogue_enable FALSE)
	(sleep 1)
		
		(if dialogue (print "PILOT (radio): All Brutes cruisers are pulling back to Truth's ship!"))
		(sleep (ai_play_line_on_object NONE 040MH_100))
		(sleep 10)
		
		(if dialogue (print "PILOT (radio): Wind inside the storm just hit 200 kilometers per hour"))
		(sleep (ai_play_line_on_object NONE 040MH_110))
		(sleep 10)
		
		(if dialogue (print "PILOT (radio): Energy cascades! All over the artifact!"))
		(sleep (ai_play_line_on_object NONE 040MH_120))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_bfg_joh_straight_ahead
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:work:joh:straight:ahead")
	(ai_dialogue_enable FALSE)
	(sleep 1)
		
		(if dialogue (print "JOHNSON (radio): Gun should be straight ahead, Chief!"))
		(sleep (ai_play_line_on_object NONE 040MH_010))
		(sleep 10)
		
		(if dialogue (print "JOHNSON (radio): Once it's destroyed, Lord Hood will start his run!"))
		(sleep (ai_play_line_on_object NONE 040MH_020))
		(sleep 10)
		
		(if dialogue (print "JOHNSON (radio): C'mon, Spartan! It's all up to you!"))
		(sleep (ai_play_line_on_object NONE 040MH_030))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================


(script dormant br_ark_is_bad
	(print "br:ark:is:bad")
	
	;(wake play_040BA)
	(ai_dialogue_enable FALSE)
	(sleep 1)
	
		;music
		(wake music_040_13)

		(if dialogue (print "MIRANDA (radio): Chief! Hood's ships are closing fast!"))
		(sleep (ai_play_line_on_object NONE 040BC_010))
		(sleep 20)

		(if dialogue (print "MIRANDA (radio): Destroy that gun! We're out of time!"))
		(sleep (ai_play_line_on_object NONE 040BC_030))
		(sleep 10)
		
	(ai_dialogue_enable TRUE)
)


; ===================================================================================================================================================

(script dormant md_bfg_joh_charge
	(sleep_until (and
			(not g_playing_dialogue)
			TRUE
		)
	)

	(print "mission dialogue:bfg:joh:charge")
	
		
		(if dialogue (print "JOHNSON (radio): Charge that hill, marines! Do not give up!"))
		(sleep (ai_play_line_on_object NONE 040MH_160))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
)

; ===================================================================================================================================================

(script dormant md_bfg_joh_hints
	(print "mission dialogue:bfg:joh:hints")
	(ai_dialogue_enable FALSE)
	
		
		(if dialogue (print "JOHNSON (radio): Chief, that gun's been firing non-stop. It's gotta be running hot..."))
		(sleep (ai_play_line_on_object NONE 040MH_210))
		(sleep (* 30 17))
		
		(if dialogue (print "JOHNSON (radio): Wait for it to open up - vent its excess plasma..."))
		(sleep (ai_play_line_on_object NONE 040MH_220))
		(Hud_activate_team_nav_point_flag player nav_bfg_core 0)
		(sleep 10)
		
		(if dialogue (print "JOHNSON (radio): Then shove some lead down its throat!"))
		(sleep (ai_play_line_on_object NONE 040MH_240))
		(sleep 10)

	; cleanup
	(set g_playing_dialogue FALSE)
	(ai_dialogue_enable TRUE)
)


; ===================================================================================================================================================
; ===================================================================================================================================================
; VIGNETTES 
; ===================================================================================================================================================
; ===================================================================================================================================================
(script static void vs_scarab_intro
	(wake md_lab_mar_scarab_sound)
	(sleep 100)
	(data_mine_set_mission_segment "040_60_scarab")
	(ai_place scarab)
	(object_cannot_take_damage scarab_giant)
	(wake spawn_scarab_ai)
	(wake scarab_allies_backup)
	(wake md_lab_mar_scarab)
	;(wake 040pb_scarab_intro_pers)
	;(if (volume_test_players vol_lakebed_b_persp) (wake 040pb_scarab_intro_pers))
	;(vs_custom_animation scarab/driver01 TRUE objects\giants\scarab\cinematics\perspectives\040pa_scarab_intro\040pa_scarab_intro "040pa_scarab_intro" FALSE)
	(vs_custom_animation scarab/driver01 FALSE objects\giants\scarab\cinematics\perspectives\040pb_scarab_intro\040pb_scarab_intro "040pb_scarab_intro_1" FALSE)
	(sleep (unit_get_custom_animation_time (ai_get_unit scarab/driver01)))
	(vs_stop_custom_animation scarab/driver01)
	(ai_force_active scarab/driver01 TRUE)
	(object_can_take_damage scarab_giant)
	(wake objective_3_set)
	
	;music
	(wake music_040_08)
	
	(sleep 30)
	(wake scarab_present)
	(wake md_scarab_inside)
	(sleep 1)
	(ai_enter_squad_vehicles all_allies)
	(ai_enter_squad_vehicles all_enemies)
)

(script dormant spawn_scarab_ai
	(sleep 200)
	(print "spawning scarab ai")
	(ai_place lakebed_b_scarab_brutes)
	(ai_place lakebed_b_scarab_brutes02)
	(ai_place lakebed_b_scarab_grunts)
)

(script static void scarab_test
	(ai_place scarab)
	(vs_custom_animation scarab/driver01 FALSE objects\giants\scarab\cinematics\perspectives\040pa_scarab_intro\040pa_scarab_intro "040pa_scarab_intro_1" FALSE)
	(sleep (unit_get_custom_animation_time (ai_get_unit scarab/driver01)))
	(vs_stop_custom_animation scarab/driver01)
	(ai_force_active scarab/driver01 TRUE)
)

; ===================================================================================================================================================

(script dormant vig_office_radio
	(sleep (random_range 120 180))
	(print "PILOT (radio): All Brutes cruisers are pulling back to Truth's ship!")
	(sleep (ai_play_line_on_object office_radio 040MH_100))
		(sleep 10)
	(print "PILOT (radio): Wind inside the storm just hit 200 kilometers per hour")
	(sleep (ai_play_line_on_object office_radio 040MH_110))
		(sleep 10)
	(print "PILOT (radio): Energy cascades! All over the artifact!")
	(sleep (ai_play_line_on_object office_radio 040MH_120))


	(sleep (* 30 11))
	(print "MIRANDA (radio): Admiral? A single Covenant ship just slipped in-system!")
	(sleep (ai_play_line_on_object office_radio 040MH_040))
		(sleep 10)
	(print "HOOD (radio): Just one? What's its range and disposition?")
	(sleep (ai_play_line_on_object office_radio 040MH_050))
		(sleep 10)
	(print "MIRANDA (radio): Above the artifact, inside the orbital line. Seems to be holding stready.")
	(sleep (ai_play_line_on_object office_radio 040MH_060))
		(sleep 10)
	(print "HOOD (radio): The attack proceeds as planned, Commander...")
	(sleep (ai_play_line_on_object office_radio 040MH_070))
		(sleep 10)
	(print "HOOD (radio): We're not going to get another shot at Truth")
	(sleep (ai_play_line_on_object office_radio 040MH_080))
		(sleep 10)
	(print "MIRANDA (radio): Sir, yes sir!")
	(sleep (ai_play_line_on_object office_radio 040MH_090))
)

; ===================================================================================================================================================

(script dormant vig_cor_mar_open_up
	(print "mission vig:cor:mar:open:up")
	

		; cast the actors
		;(vs_cast cortana_office_code TRUE 0 "040MG_010")
			(set marine cortana_office_code/open_up)
			(vs_reserve marine 1)
			;(set marine_01 cortana_office_code/ok)

	; movement properties
	(vs_enable_pathfinding_failsafe marine TRUE)
	;(vs_enable_looking cortana_office_allies  TRUE)
	;(vs_enable_targeting cortana_office_allies TRUE)
	;(vs_enable_moving cortana_office_allies TRUE)

	;(sleep_until (volume_test_players vol_cortana_moment01))
		(vs_go_to marine TRUE warehouse/open_up01)
		(if dialogue (print "MARINE: Come on, man! I have the chief"))
		(vs_play_line marine TRUE 040MG_010)
		(sleep 10)

		(if dialogue (print "MARINE: Yeah, well the Chief's gunna solve that problem real quick."))
		(vs_play_line marine TRUE 040MG_040)
		(sleep 10)

	; cleanup
	(vs_release_all)
	
	(device_set_position warehouse_entry 1)
	(device_set_position ware_security_door 0)
)

; ===================================================================================================================================================

(script dormant vig_war_sgt_brute_pack
	(print "mission vig:war:sgt:brute:pack")
	
	(set sergeant ware_hum_marines_flee/shotgun01)
	; movement properties
	(vs_enable_pathfinding_failsafe sergeant TRUE)
	;(vs_enable_looking cortana_office_allies  TRUE)
	;(vs_enable_targeting cortana_office_allies TRUE)
	;(vs_enable_moving cortana_office_allies TRUE)
	
		(vs_force_combat_status sergeant ai_combat_status_active)
		;(if dialogue (print "SERGEANT: Brute Pack!"))
		;(vs_play_line sergeant TRUE 040MG_190)
		(vs_go_to_and_face sergeant TRUE warehouse/p0 warehouse/p2)
		;(if dialogue (print "SERGEANT: Protect the civilians!"))
		(vs_shoot sergeant TRUE ware_cov_brutes01/leader)
		;(vs_play_line sergeant TRUE 040MG_200)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
(script dormant vig_ware_brute02
	(ai_place ware_cov_brutes02)
	(ai_place ware_hum_201)
	
	(ai_disregard (ai_actors ware_hum_201/civ01) TRUE)
	
	(vs_cast ware_cov_brutes02/brute01 TRUE 0 "")
		(set brute (vs_role 1))
			
	(vs_cast ware_hum_201/civ01 TRUE 0 "")
		(set marine (vs_role 1))
	
	(sleep 1)
	(ai_magically_see ware_cov_brutes02 ware_hum_201)

	(vs_custom_animation_loop marine objects\characters\marine\cinematics\vignettes\010va_brute_intro\010va_brute_intro "020vb_vict_idle" FALSE warehouse/vig02)
	(vs_custom_animation_loop brute objects\characters\brute\cinematics\vignettes\010va_brute_intro\010va_brute_intro "020vb_exec_idle" FALSE warehouse/vig02)
	
	(sleep 60)
	(cs_run_command_script ware_hum_201/run02 abort)
	(vs_custom_animation brute FALSE objects\characters\brute\cinematics\vignettes\010va_brute_intro\010va_brute_intro "020vb_exec_kill" TRUE warehouse/vig02)		
	(vs_custom_animation marine TRUE objects\characters\marine\cinematics\vignettes\010va_brute_intro\010va_brute_intro "020vb_vict_kill" TRUE warehouse/vig02)
	
	(vs_release marine)
	(sleep 1)
	(ai_kill_silent marine)
	
	(sleep_until (not (unit_is_playing_custom_animation brute)) 1)
	(vs_release_all)
)

; ===================================================================================================================================================
(script static void test_longsword
	(object_create cin_longsword)
	;(sleep 1)
	(ai_disregard cin_longsword TRUE)
	;(effect_new "fx\scenery_fx\explosions\human_explosion_huge\human_explosion_huge.effect" cin_longsword_explosion)
	(scenery_animation_start_relative cin_longsword objects\vehicles\longsword\cinematics\vignettes\040vc_crashing_longsword\040vc_crashing_longsword "040vc_crashing_longsword" cin_longsword_start)
)

(script dormant vig_crashing_longsword
	;wait for bfg to fire
	;(sleep 40)
	
	(print "vignette:va_crashing_longsword")
	(object_create cin_longsword)
	;(sleep 1)
	(ai_disregard cin_longsword TRUE)
	;(effect_new "fx\scenery_fx\explosions\human_explosion_huge\human_explosion_huge.effect" cin_longsword_explosion)
	(scenery_animation_start_relative cin_longsword objects\vehicles\longsword\cinematics\vignettes\040vc_crashing_longsword\040vc_crashing_longsword "040vc_crashing_longsword" cin_longsword_start)
	
	(sleep 110)
	;screen shake
	(print "boom")
	(player_effect_set_max_rotation 0 0.5 0.5)
	(player_effect_set_max_rumble 1 1)
	(player_effect_start 0.50 0.05)
	(sleep 20)
	(player_effect_stop 0.5)
	(sleep 50)
	;(wake 040_title3)
	
	(sleep 50)
	(wake br_ark_is_bad)
	(sleep 100)
	(object_destroy cin_longsword)
	
	;(sleep 40)
	;screen shake
	(print "boom")
	(player_effect_set_max_rotation 0 0.5 0.5)
	(player_effect_set_max_rumble 1 1)
	(player_effect_start 0.50 0.05)
	(sleep 20)
	(player_effect_stop 0.5)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; perspectives 
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(script dormant 040pb_scarab_intro_pers
	(if 
		(and
			g_play_cinematics
			(volume_test_players vol_lakebed_b_persp)
		)
		(begin
			(cs_run_command_script lakebed_b_covenant_obj/ground_gate pause_forever)
			(perspective_start)
			(040pb_scarab_intro)
			(perspective_stop)
			(cs_run_command_script lakebed_b_covenant_obj/ground_gate abort)
			(game_save_immediate)
		)
		(begin
			(print "player not in perspective area")
			(cinematic_show_letterbox FALSE)
			(sleep 30)
			(chud_cinematic_fade 1 1)
			(game_save)
		)
	)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; briefings 
; =======================================================================================================================================================================
; =======================================================================================================================================================================
;*
(script dormant play_040BA
            (040BA)
)

(script dormant play_040BB
            (040BB)
)
*;

; ======================================================================================
;Giant bad hack to fix blocking issue 55008 (Swah)
(script static void cinematic_title_to_gameplay_loc
		(sleep 30)
		
		; unlock the players gaze 
		(player_control_unlock_gaze (player0))
		(player_control_unlock_gaze (player1))
		(player_control_unlock_gaze (player2))
		(player_control_unlock_gaze (player3))
			(sleep 1)

			; lower weapon 
			(unit_lower_weapon (player0) 1)
			(unit_lower_weapon (player1) 1)
			(unit_lower_weapon (player2) 1)
			(unit_lower_weapon (player3) 1)
				(sleep 1)
				
		; raise weapons 
		(unit_raise_weapon (player0) 30)
		(unit_raise_weapon (player1) 30)
		(unit_raise_weapon (player2) 30)
		(unit_raise_weapon (player3) 30)
		(sleep 10)

	; enable player input 
	(player_enable_input TRUE)

	; scale player input to one 
	(player_control_fade_in_all_input 1)

	; player can now move 
	;(player_disable_movement FALSE)
		(sleep 110)

	; remove letterboxes 
	(cinematic_show_letterbox FALSE)
		(sleep 15)

	; fade in the HUD 
	(chud_cinematic_fade 1 1)
		
	; pause the meta-game timer 
	(campaign_metagame_time_pause FALSE)

	; the ai will disregard all players 
	(ai_disregard (players) 	FALSE)

	; players cannot take damage 
	(object_can_take_damage (players))
	
	; game save 
	(game_save)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; chapter titles 
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(script dormant 040_title1
	(sleep 30)
	(cinematic_set_title title_1)
	(cinematic_title_to_gameplay_loc)
	;(player_enable_input FALSE)
	(player_disable_movement TRUE)
	(wake br_int_01)
)

(script dormant 040_title2
	(chapter_start)
	; display chapter title 
	(cinematic_set_title title_3)
		(sleep 150)
	(chapter_stop)

	(vs_scarab_intro)
)

(script dormant 040_title2_insert
	(sleep 60)
	
	; display chapter title 
	(cinematic_set_title title_3)
	(cinematic_title_to_gameplay)

	(vs_scarab_intro)
)

;*
(script dormant 040_title3
	;give time to the longsword
	(sleep 30)
	(cinematic_show_letterbox TRUE)
	(sleep 30)
	(cinematic_set_title title_3)
	(cinematic_title_to_gameplay)
)
*;

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; cortana moment  
; =======================================================================================================================================================================
; =======================================================================================================================================================================
;(global boolean g_pa_cortana FALSE)
;(global boolean g_pa_cortana_dialogue FALSE)

;*
NOTES 
----- 
- (render_exposure -4 5) to darken the screen 
- flicker the HUD using (chud_cinematic_fade <real> <real>) 


*;
(script dormant cor_fab
	(sleep_until (volume_test_players tv_cortana_01) 1)
	(sound_impulse_start sound\levels\040_voi\sound_scenery\bfg_for_cortana NONE 1)
	(sleep 5)
	(bfg_shake_fx)
	(set g_cortana_playing TRUE)
	(print "CORTANA: I have defied gods and demons.")
	(wake 040ca_have_defied)
	(set g_cortana_playing FALSE)
	(game_save)
)

(script dormant cor_ware
	(sleep_until (= (current_zone_set) 7) 1)
	(sound_impulse_start sound\levels\040_voi\sound_scenery\bfg_for_cortana NONE 1)
	(sleep 5)
	(bfg_shake_fx)
	(print "CORTANA: I am your shield. I am your sword.")
	(wake 040cb_your_shield)
	
	;office radio chatter
	(sleep (random_range 240 270))
	
	; add marine reactions here 
	
	; wake mission dialogue scripts 
	(wake md_office_morphine)
)

(script dormant cor_worker
	(sleep_until (volume_test_players tv_cortana_03) 1)
	(print "CORTANA: I know you. Your past. Your future.")
	(wake 040cc_know_you)
	(game_save)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; truth channel  
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global boolean g_truth FALSE)
(global short g_truth_count 0)
(global short g_truth_limit 7)

(script dormant truth_channel
	(object_create_anew truth)
	(object_create_anew gravity_throne)
	(object_create_anew truth_holo_projector)
	(objects_attach truth_holo_projector "attach_marker" truth "")
	(objects_attach truth "driver" gravity_throne "driver")
	
	(object_hide truth FALSE)
	(object_hide gravity_throne FALSE)
	
	(sleep_until (volume_test_players tv_truth) 30 (* 30 3))
	(truth_flicker)
	(object_hide truth FALSE)
	(object_hide gravity_throne FALSE)
	(unit_limit_lipsync_to_mouth_only truth TRUE)
		(sleep 15)
		
	(if (> (object_get_health truth_holo_projector) 0)
		(begin
		    (custom_animation truth objects\characters\truth\cinematics\truth_holos\040_truth_a\040_truth_a.model_animation_graph "040_truth_a" TRUE)
			(sound_impulse_start sound\dialog\040_voi\mission\040MY_050_pot truth 1)
				(sleep (sound_impulse_language_time sound\dialog\040_voi\mission\040MY_050_pot))
				(sleep (* 30 10))
		)
	)
	
	(if (> (object_get_health truth_holo_projector) 0)
		(begin
		    (custom_animation truth objects\characters\truth\cinematics\truth_holos\040_truth_a\040_truth_a.model_animation_graph "040_truth_a2" TRUE)
			(sound_impulse_start sound\dialog\040_voi\mission\040MY_070_pot truth 1)
				(sleep (sound_impulse_language_time sound\dialog\040_voi\mission\040MY_070_pot))
				(sleep 45)
		)
	)
	(truth_flicker)
	(object_destroy truth)
	(object_destroy gravity_throne)
	(ai_set_task_condition factory_a_covenant_obj/faa_cov_init FALSE)
)

(script dormant truth_channel_worker
	(object_create_anew truth_worker)
	(object_create_anew gravity_throne_worker)
	(object_create_anew truth_holo_projector_worker)
	(objects_attach truth_holo_projector_worker "attach_marker" truth_worker "")
	(objects_attach truth_worker "driver" gravity_throne_worker "driver")
	
	(object_hide truth_worker FALSE)
	(object_hide gravity_throne_worker FALSE)
	
	(sleep_until (volume_test_players tv_truth_worker))
	(truth_flicker)
	(object_hide truth_worker FALSE)
	(object_hide gravity_throne_worker FALSE)
	(unit_limit_lipsync_to_mouth_only truth_worker TRUE)
		(sleep 15)
		
	(if (> (object_get_health truth_holo_projector_worker) 0)
		(begin
		    (custom_animation truth_worker objects\characters\truth\cinematics\truth_holos\040_truth_b\040_truth_b.model_animation_graph "040_truth_b" TRUE)
			(sound_impulse_start sound\dialog\040_voi\mission\040MY_020_pot truth_worker 1)
				(sleep (sound_impulse_language_time sound\dialog\040_voi\mission\040MY_020_pot))
				(sleep_until (<= (ai_task_count worker_cov_obj/cov_inf) 1))
				(wake md_arb_truth_response)
		)
	)
	
	(if (> (object_get_health truth_holo_projector_worker) 0)
		(begin
		    (custom_animation truth_worker objects\characters\truth\cinematics\truth_holos\040_truth_b\040_truth_b.model_animation_graph "040_truth_b2" TRUE)
			(sound_impulse_start sound\dialog\040_voi\mission\040MY_030_pot truth_worker 1)
				(sleep (sound_impulse_language_time sound\dialog\040_voi\mission\040MY_030_pot))
				(sleep 45)
		)
	)
	(truth_flicker)
	(object_destroy truth_worker)
	(object_destroy gravity_throne_worker)
)

(script static void truth_flicker
	(set g_truth FALSE)
	(set g_truth_count 0)
	(sleep_until
		(begin
			(object_hide truth_worker FALSE)
			(object_hide gravity_throne_worker FALSE)
			(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
				(sleep (random_range 4 15))
			(object_hide truth_worker true)
			(object_hide gravity_throne_worker true)
			(set g_truth_count (+ g_truth_count 1))
			(if (= g_truth_limit g_truth_count) (set g_truth TRUE))
		g_truth)
	(random_range 1 10))
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; Sky Ambience 
; =======================================================================================================================================================================
; =======================================================================================================================================================================

;script to place and fly around the cruisers over the ark
(script dormant sc_bridge_cruiser
	(print "cruiser is awake")
	(object_create_anew ark_cruiser_01)
	(object_create_anew ark_cruiser_02)
	(sleep 1)
	(scenery_animation_start_loop ark_cruiser_01 objects\vehicles\cov_cruiser\cinematics\vignettes\030vb_excavation\030vb_excavation "cinematic_cov_cruiser")
	(object_set_custom_animation_speed ark_cruiser_01 0.009)
	(object_cinematic_visibility ark_cruiser_01 TRUE)
	(scenery_animation_start_at_frame_loop ark_cruiser_02 objects\vehicles\cov_cruiser\cinematics\vignettes\030vb_excavation\030vb_excavation "cinematic_cov_cruiser1" 10)
	(object_set_custom_animation_speed ark_cruiser_02 0.01)
	(object_cinematic_visibility ark_cruiser_02 TRUE)
)

;===========================================================================================================
;============================== AWARD SKULLS ===================================================================
;===========================================================================================================

(script dormant gs_create_primary_skull
	(if
		(and
			(>= (game_difficulty_get_real) normal)
			(= (game_insertion_point_get) 0)
			(or
				(= (campaign_is_finished_normal) TRUE)
				(= (campaign_is_finished_heroic) TRUE)
				(= (campaign_is_finished_legendary) TRUE)
			)
		)
		(begin
			(sleep_until (>= (ai_task_count lakebed_a_covenant_obj/ground_wraith_gate) 1))
			(object_create skull_catch)
			(wake gs_award_primary_skull)
			(sleep_until (<= (ai_task_count lakebed_a_covenant_obj/ground_wraith_gate) 0))
			(object_destroy skull_catch)
		)
	)
)

(script dormant gs_award_primary_skull
	(sleep_until 
		(or
			(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
			(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
			(unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
			(unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
		)
	5)
	
	(print "award catch skull")
	(campaign_metagame_award_primary_skull (player0) 3)
	(campaign_metagame_award_primary_skull (player1) 3)
	(campaign_metagame_award_primary_skull (player2) 3)
	(campaign_metagame_award_primary_skull (player3) 3)
)