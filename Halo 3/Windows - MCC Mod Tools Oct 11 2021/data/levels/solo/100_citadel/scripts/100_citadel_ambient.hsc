; ===================================================================================================================================================
; ===================================================================================================================================================
; MUSIC 
; ===================================================================================================================================================
; ===================================================================================================================================================

(global boolean g_music_100_01 FALSE)
(global boolean g_music_100_02 FALSE)
(global boolean g_music_100_03 FALSE)
(global boolean g_music_100_04 FALSE)
(global boolean g_music_100_05 FALSE)
(global boolean g_music_100_051 FALSE)
(global boolean g_music_100_055 FALSE)
(global boolean g_music_100_056 FALSE)
(global boolean g_music_100_058 FALSE)
(global boolean g_music_100_059 FALSE)
(global boolean g_music_100_06 FALSE)
(global boolean g_music_100_07 FALSE)
(global boolean g_music_100_08 FALSE)
(global boolean g_music_100_088 FALSE)
(global boolean g_music_100_089 FALSE)
(global boolean g_music_100_09 FALSE)
(global boolean g_music_100_10 FALSE)
(global boolean g_music_100_11 FALSE)
(global boolean g_music_100_12 FALSE)
(global boolean g_music_100_13 FALSE)

; =======================================================================================================================================================================
(script dormant music_100_01
	(sleep_until g_music_100_01)
	(print "start music 100_01")
	(sound_looping_start levels\solo\100_citadel\music\100_music_01 NONE 1)
	
	(sleep_until (>= (ai_living_count cella_cov01_wraiths01) 1))
	(sleep_until
		(or
			(<= (object_get_health (ai_vehicle_get_from_starting_location cella_cov01_wraiths01/driver01)) 0)
			(vehicle_test_seat_list (ai_vehicle_get_from_starting_location cella_cov01_wraiths01/driver01) "" (players))
			(not g_music_100_01)
		)
	)
	(print "stop music 100_01")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_01)
	
	(wake music_100_02)
)
; =======================================================================================================================================================================
(script dormant music_100_02
	;(sleep_until g_music_100_02)
	(print "start music 100_02")
	(sound_looping_start levels\solo\100_citadel\music\100_music_02 NONE 1)
	
	;*
	(sleep_until
		(or
			(volume_test_players vol_lock_a01b_start)
			(volume_test_players vol_lock_a_elevator_bottom)
		)
	)
	*;
	(sleep_until (volume_test_players vol_lock_a01_migrate))

	;(sleep_until (not g_music_100_02))
	(print "stop music 100_02")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_02)
	
	(wake music_100_03)
	(set g_music_100_03 TRUE)
)
; =======================================================================================================================================================================
(script dormant music_100_03
	(sleep_until g_music_100_03)
	(sleep_until (> (device_get_position tower1_elevator) 0) 5)
	(print "start music 100_03")
	(sound_looping_start levels\solo\100_citadel\music\100_music_03 NONE 1)
	
	(sleep_until (not g_music_100_03))
	(print "stop music 100_03")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_03)
	
	;player deactivated first tower
	(wake music_100_04)
)
; =======================================================================================================================================================================
(script dormant music_100_04
	;(sleep_until g_music_100_04)
	(print "start music 100_04")
	(sound_looping_start levels\solo\100_citadel\music\100_music_04 NONE 1)
	
	(sleep_until (= (current_zone_set) 2))

	;(sleep_until (not g_music_100_04))
	(print "stop music 100_04")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_04)
	
	;player driving back to beach near waterfall
	(wake music_100_05)
)
; =======================================================================================================================================================================
(script dormant music_100_05
	(print "start music 100_05")
	(sound_looping_start levels\solo\100_citadel\music\100_music_05 NONE 1)
	
	(sleep_until (volume_test_players vol_cell_b_hornet_pickup))

	(print "stop music 100_05")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_05)
)
; =======================================================================================================================================================================
(script dormant music_100_051
	(sleep_until g_music_100_051)
	(print "start music 100_051")
	(sound_looping_start levels\solo\100_citadel\music\100_music_051 NONE 1)

	(sleep_until (not g_music_100_051))
	(print "stop music 100_051")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_051)
)
; =======================================================================================================================================================================
(script dormant music_100_055
	(print "start music 100_055")
	(sound_looping_start levels\solo\100_citadel\music\100_music_055 NONE 1)

	(sleep_until (volume_test_players vol_cell_c_init))

	(print "stop music 100_055")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_055)
	
	(wake music_100_056)
)
; =======================================================================================================================================================================
(script dormant music_100_056
	(sleep_until (not (unit_in_vehicle (unit (player0)))))
	(print "start music 100_056")
	(sound_looping_start levels\solo\100_citadel\music\100_music_056 NONE 1)
	
	(sleep_until (volume_test_players vol_lock_c01_objs) 5)

	(print "stop music 100_056")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_056)
)
; =======================================================================================================================================================================
(script dormant music_100_058
	(sleep_until
		(or
			(and
				(<= (ai_task_count lock_c_cov_obj/bugger_gate) 0)
				(<= (ai_task_count lock_c_cov_obj/hunter_gate) 0)
			)
			(volume_test_players vol_lock_c01b_start)
			(volume_test_players vol_lock_c01b_bypass)
		)
	)
	(print "start music 100_058")
	(sound_looping_start levels\solo\100_citadel\music\100_music_058 NONE 1)
	
	(sleep_until 
		(or
			(> (device_get_position tower3_elevator) 0)
			(not g_music_100_058)
		)
	)
	(print "stop music 100_058")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_058)
)
; =======================================================================================================================================================================
(script dormant music_100_059
	(print "start music 100_059")
	(sound_looping_start levels\solo\100_citadel\music\100_music_059 NONE 1)
	
	(sleep_until 
		(or
			(> (device_get_position tower3_elevator) 0)
			(not g_music_100_058)
		)
	)
	(print "stop music 100_059")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_059)
)
; =======================================================================================================================================================================
(script dormant music_100_06
	(sleep_until g_music_100_06)
	(sleep_until (> (device_get_position tower3_elevator) 0) 5)
	(print "start music 100_06")
	(sound_looping_start levels\solo\100_citadel\music\100_music_06 NONE 1)

	(sleep_until (not g_music_100_06))
	(print "stop music 100_06")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_06)
)
; =======================================================================================================================================================================
(script dormant music_100_07
	(sleep_until g_music_100_07)
	(print "start music 100_07")
	(sound_looping_start levels\solo\100_citadel\music\100_music_07 NONE 1)
	
	(sleep_until (not g_music_100_07))
	(print "stop music 100_07")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_07)
)
; =======================================================================================================================================================================
(script dormant music_100_08
	(sleep_until g_music_100_08)
	(print "start music 100_08")
	(sound_looping_start levels\solo\100_citadel\music\100_music_08 NONE 1)
	
	(sleep_until (not g_music_100_08))
	(print "stop music 100_08")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_08)
)
; =======================================================================================================================================================================
(script dormant music_100_088
	(sleep_until g_music_100_088)
	(print "start music 100_088")
	(sound_looping_start levels\solo\100_citadel\music\100_music_088 NONE 1)
	
	(sleep_until (not g_music_100_088))
	(print "stop music 100_088")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_088)
)
; =======================================================================================================================================================================
(script dormant music_100_089
	(sleep_until g_music_100_089)
	(print "start music 100_089")
	(sound_looping_start levels\solo\100_citadel\music\100_music_089 NONE 1)
	
	(sleep_until (not g_music_100_089))
	(print "stop music 100_089")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_089)
)
; =======================================================================================================================================================================
(script dormant music_100_09
	(print "start music 100_09")
	(sound_looping_start levels\solo\100_citadel\music\100_music_09 NONE 1)
	
	(sleep_until 
		(or
			(volume_test_players vol_crater_main)
			(volume_test_players vol_crater_advance01)
			(volume_test_players vol_crater_hornet_drop02)
		)
	)
	(sound_looping_set_alternate levels\solo\100_citadel\music\100_music_09 TRUE)
	
	(sleep_until (> (ai_living_count scarabs_obj) 0))
	
	(sleep_until
		(and
			(object_model_target_destroyed cin_scarab_a "indirect_engine")
			(object_model_target_destroyed cin_scarab_b "indirect_engine")
		)
	)

	(print "stop music 100_09")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_09)
)
; =======================================================================================================================================================================
(script dormant music_100_10
	(print "start music 100_10")
	(sound_looping_start levels\solo\100_citadel\music\100_music_10 NONE 1)
)
; =======================================================================================================================================================================
(script dormant music_100_11
	(sleep_until g_music_100_11)
	(print "start music 100_11")
	(sound_looping_start levels\solo\100_citadel\music\100_music_11 NONE 1)
	
	(sleep_until (not g_music_100_11))
	(print "stop music 100_11")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_11)
)
; =======================================================================================================================================================================
(script dormant music_100_12
	(sleep_until g_music_100_12)
	(print "start music 100_12")
	(sound_looping_start levels\solo\100_citadel\music\100_music_12 NONE 1)

	(sleep_until (not g_music_100_12))
	(print "stop music 100_12")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_12)
)
; =======================================================================================================================================================================
(script dormant music_100_13
	(sleep_until g_music_100_13)
	(print "start music 100_13")
	(sound_looping_start levels\solo\100_citadel\music\100_music_13 NONE 1)

	(sleep_until (not g_music_100_13))
	(print "stop music 100_13")
	(sound_looping_stop levels\solo\100_citadel\music\100_music_13)
)
; =======================================================================================================================================================================

; ===================================================================================================================================================
; ===================================================================================================================================================
; MISSION DIALOGUE 
; ===================================================================================================================================================
; ===================================================================================================================================================

;*
+++++++++++++++++++++++
 DIALOGUE INDEX 
+++++++++++++++++++++++

VA
md_beach_pile_out
md_beach_lost_wingman
nacho01
nacho02
md_beach_beachhead_secure
nacho03
br_tower1_01
md_beach_look_elites
md_beach_prompt01
md_beach_joh_update
md_cella_in_sight
nacho04
md_cella_mir_get_inside
md_locka_arb_breach
md_locka_elite_breach
md_locka_hold_here
nacho05
md_locka_prompt01
md_locka_tower1_done
md_locka_tower2_done
md_locka_joh_update
br_tower03_02
md_cellb_get_in
md_cellb_prompt01
md_cellb_hornets
md_cellb_arb_2nd_clear
md_cellb_elite_2nd_clear
md_cellc_clear_lz
md_cellc_clear_deck
md_cellc_arb_hold_here
md_cellc_elite_hold_here
md_lockc_spark01
md_lockc_arb_prompt01
md_lockc_elite_prompt01
md_lockc_fight_up
md_lockc_spark02
md_lockc_hold_here
CA
md_lockc_prompt02
md_lockc_status
md_lockc_flood_here
md_ridge_spark_assess
md_ridge_arb_assess
md_ridge_elite_assess
br_citadel_03
md_ridge_prompt01
nacho06
+++++++++++++++++++++++
*;

(global ai arbiter NONE)
(global ai brute NONE)
(global ai chieftain NONE)
(global ai elite NONE)
(global ai gravemind NONE)
(global ai spark NONE)
(global ai johnson NONE)
(global ai marine NONE)
(global ai miranda NONE)
(global ai odst NONE)
(global ai odst_01 NONE)
(global ai odst_02 NONE)
(global ai sergeant NONE)
(global ai shipmaster NONE)
(global ai truth NONE)

(script static void md_cleanup
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================
(global boolean debug TRUE)
(global boolean dialogue TRUE)

(script dormant VA
	(if debug (print "VA"))

	(sleep 1)

        (ai_dialogue_enable FALSE)
		(if dialogue (print "HOCUS (radio): Charlie foxtrot!"))
		(sleep (ai_play_line_on_object NONE 100VA_010))
		(sleep 10)

		(if dialogue (print "HOCUS (radio): Tower one approach has active triple-A!"))
		(sleep (ai_play_line_on_object NONE 100VA_020))
		(sleep 10)

		(if dialogue (print "PILOT (radio): Mayday! Can't control her --"))
		(sleep (ai_play_line_on_object NONE 100VA_030))
		(sleep 10)

		(if dialogue (print "PILOT (radio): (death scream that ends in static)"))
		(sleep (ai_play_line_on_object NONE 100VA_040))
		(sleep 10)

		(if dialogue (print "HOCUS (radio): Pelican down! Pelican down!"))
		(sleep (ai_play_line_on_object NONE 100VA_050))
		(sleep 10)

		(if dialogue (print "SERGEANT (radio): Brace yourselves! We're going in hot!"))
		(sleep (ai_play_line_on_object NONE 100VA_060))
		(sleep 10)

	; cleanup
	(ai_dialogue_enable TRUE)
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_beach_pile_out
	(if debug (print "mission dialogue:beach:pile:out"))

		; cast the actors
		(vs_cast beach_inf_marines FALSE 0 "100MA_010")
			(set sergeant (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe sergeant TRUE)
	(vs_enable_looking sergeant  TRUE)
	(vs_enable_targeting sergeant TRUE)
	(vs_enable_moving sergeant TRUE)

	(sleep 1)
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)

		(if dialogue (print "SERGEANT: Pile out! Go, go, go!"))
		(sleep (ai_play_line sergeant 100MA_010))
		(sleep (random_range 40 70))

		(if dialogue (print "SERGEANT: Up the beach! Kill that Wraith!"))
		(sleep (ai_play_line sergeant 100MA_020))
		(sleep 10)

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(sleep 70)
	(wake md_beach_lost_wingman)
)

; ===================================================================================================================================================

(script dormant md_beach_lost_wingman
	(if debug (print "mission dialogue:beach:lost:wingman"))

	(ai_dialogue_enable FALSE)
	(sleep 1)
	
		(if dialogue (print "HOCUS (radio): Commander, this is kilo two three!"))
		(sleep (ai_play_line_on_object NONE 100MA_030))
		(sleep 10)

		(if dialogue (print "HOCUS (radio): Lost my wingman and our only Hog, over!"))
		(sleep (ai_play_line_on_object NONE 100MA_040))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): Roger that, Hocus! Get out of there!"))
		(sleep (ai_play_line_on_object NONE 100MA_050))
		(sleep 10)

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================
;*
(script dormant nacho01
	(if debug (print "nacho01"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MA_060" "100MA_090")
			(set odst_01 (vs_role 1))
			(set odst_02 (vs_role 2))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "ODST 01 (all business): Banshees inbound."))
		(vs_play_line odst_01 TRUE 100MA_060)
		(sleep 10)

		(if dialogue (print "ODST 01 (all business): Affirmative. Target acquired"))
		(vs_play_line odst_01 TRUE 100MA_070)
		(sleep 10)

		(if dialogue (print "ODST 01 (all business): Firing. Watch the back-blast."))
		(vs_play_line odst_01 TRUE 100MA_080)
		(sleep 10)

		(if dialogue (print "ODST 02 (all business): Impact. That's a kill."))
		(vs_play_line odst_02 TRUE 100MA_090)
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant nacho02
	(if debug (print "nacho02"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MA_100")
			(set sergeant (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "SERGEANT: Flank those turrets! Charge the hill!"))
		(vs_play_line sergeant TRUE 100MA_100)
		(sleep 10)

		(if dialogue (print "SERGEANT: All units: target that Wraith!"))
		(vs_play_line sergeant TRUE 100MA_110)
		(sleep 10)

	; cleanup
	(vs_release_all)
)
*;
; ===================================================================================================================================================

(script dormant md_beach_beachhead_secure
	(if debug (print "mission dialogue:beach:beachhead:secure"))
	
	(ai_dialogue_enable FALSE)
	(sleep 1)
		
		(if (>= (ai_living_count beach_inf_marines/sarge) 1)
		;if sarge is still alive
		(begin
		(if dialogue (print "SERGEANT (radio): Beachhead secure, Commander! "))
		(sleep (ai_play_line_on_object NONE 100MA_120))
		(sleep 10)

		(if dialogue (print "SERGEANT (radio): Hostile anti-air has been neutralized!"))
		(sleep (ai_play_line_on_object NONE 100MA_130))
		(sleep 10)
		)
		;if sarge is NOT alive
		(begin
		(if dialogue (print "ODST (radio): Beachhead secure, Commander! "))
		(sleep (ai_play_line_on_object NONE 100MA_120))
		(sleep 10)

		(if dialogue (print "ODST (radio): Hostile anti-air has been neutralized!"))
		(sleep (ai_play_line_on_object NONE 100MA_130))
		(sleep 10)
		)
		)
		(sleep 50)
		(if dialogue (print "MIRANDA (radio): Hold position. I'm on my way!"))
		(sleep (ai_play_line_on_object NONE 100MA_160))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): Shipmaster? Begin diversionary bombardment!"))
		(sleep (ai_play_line_on_object NONE 100MA_170))
		(sleep 10)

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	
	(sleep 30)
	(wake md_beach_drum)
)

; ===================================================================================================================================================

(script dormant md_beach_drum
	(if debug (print "md_beach_drum"))

	(ai_dialogue_enable FALSE)
		
	(sleep 1)


		(if dialogue (print "SHIPMASTER (radio): I will beat the Prophet's shield like a drum!"))
		(sleep (ai_play_line_on_object NONE 100MA_180))
		(sleep 10)

		(if dialogue (print "SHIPMASTER (radio): By the time the barrier falls, he will beg for mercy!"))
		(sleep (ai_play_line_on_object NONE 100MA_190))
		(sleep 10)
	
	(ai_dialogue_enable TRUE)
	(sleep (random_range 50 70))
	(wake capital_ship_control)
	(sleep 50)
	
	(wake br_tower1_01)

)

; ===================================================================================================================================================

(script dormant br_tower1_01
	(if debug (print "br:tower1:01"))
	
	(ai_dialogue_enable FALSE)
	(sleep (random_range 15 40))
;*
		(if dialogue (print "MIRANDA (radio): Don't let the Shipmaster's bravado fool you, Chief"))
		(sleep (ai_play_line_on_object NONE 100BA_010))
		(sleep 10)
*;
		(if dialogue (print "MIRANDA (radio): Spark believes Truth can activate the rings at any time."))
		(sleep (ai_play_line_on_object NONE 100BA_020))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): If he does, Earth -- every being in the galaxy -- Halo will kill them all!"))
		(sleep (ai_play_line_on_object NONE 100BA_030))
		(sleep 10)
		
		(sleep_until
			(and
				(>= (ai_living_count patha_pelican) 1)
				(any_players_in_vehicle)
			)
		5)

		(if dialogue (print "MIRANDA (radio): Get to the first tower! Shut it down!"))
		(sleep (ai_play_line_on_object NONE 100BA_040))
		(sleep 10)

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	
	(wake music_100_01)
	(set g_music_100_01 TRUE)
)
;*
; ===================================================================================================================================================

(script dormant md_beach_look_elites
	(if debug (print "mission dialogue:beach:look:elites"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MA_200")
			(set marine (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "MARINE: Look! The Elites are at the second tower!"))
		(vs_play_line marine TRUE 100MA_200)
		(sleep 10)

		(if dialogue (print "MARINE: So far so good"))
		(vs_play_line marine TRUE 100MA_210)
		(sleep 10)

		(if dialogue (print "MARINE: Except we haven't even seen ours yet"))
		(vs_play_line marine TRUE 100MA_220)
		(sleep 10)

		(if dialogue (print "MARINE: And now everyone knows were coming."))
		(vs_play_line marine TRUE 100MA_230)
		(sleep 10)

		(if dialogue (print "MARINE: Nice, man. Very uplifting."))
		(vs_play_line marine TRUE 100MA_240)
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_beach_prompt01
	(if debug (print "mission dialogue:beach:prompt01"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MA_250" "100MA_260")
			(set odst (vs_role 1))
			(set marine (vs_role 2))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "ODST: Clock's ticking, Chief! We need to move out!"))
		(vs_play_line odst TRUE 100MA_250)
		(sleep 10)

		(if dialogue (print "MARINE: Sir, we have our orders! Let's roll!"))
		(vs_play_line marine TRUE 100MA_260)
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
*;
(script dormant md_beach_joh_update
	(if debug (print "mission dialogue:beach:joh:update"))
	
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "JOHNSON (radio): Ma'am, we're on the ground! Third tower in sight!"))
		(sleep (ai_play_line_on_object NONE 100MB_010))
		(sleep 10)
		
		(if (= (game_is_cooperative) FALSE)
			(begin
				(if dialogue (print "MIRANDA (radio): Good. The Arbiter and the Elites just touched down at number two."))
				(sleep (ai_play_line_on_object NONE 100MB_020))
				(sleep 40)
			)
			(begin
				(if dialogue (print "MIRANDA (radio): Good. The Elites just touched down at number two."))
				(sleep (ai_play_line_on_object NONE 100MB_030))
				(sleep 10)
			)
		)
;*
		(if dialogue (print "JOHNSON (radio): Saw a large building -- some sort of citadel -- just inside the barrier"))
		(sleep (ai_play_line_on_object NONE 100MB_040))
		(sleep 50)

		(if dialogue (print "JOHNSON (radio): Matches Spark's description of the target comm-facility."))
		(sleep (ai_play_line_on_object NONE 100MB_050))
		(sleep 15)

		(if dialogue (print "MIRANDA (radio): Roger that. Transfer coordinates to the Shipmaster"))
		(sleep (ai_play_line_on_object NONE 100MB_060))
		(sleep 25)

		(if dialogue (print "MIRANDA (radio): Truth has got to be somewhere inside!"))
		(sleep (ai_play_line_on_object NONE 100MB_070))
		(sleep 10)
*;		
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_cella_in_sight
	(sleep_until (volume_test_players vol_cell_a_insight))
	(if debug (print "mission dialogue:cella:in:sight"))
	
		; cast the actors
		(vs_cast all_allies FALSE 0 "100MC_010")
			(set odst (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe odst TRUE)
	(vs_enable_looking odst  TRUE)
	(vs_enable_targeting odst TRUE)
	(vs_enable_moving odst TRUE)
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "ODST: Objective in sight!"))
		(sleep (ai_play_line odst 100MC_010))
		(sleep 10)

		(if dialogue (print "ODST: Watch for heavy armor!"))
		(sleep (ai_play_line odst 100MC_020))
		(sleep (random_range 15 40))

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(wake md_cella_mir_get_inside)
)

; ===================================================================================================================================================

(script dormant md_cella_perimeter_secure
	(if debug (print "md_cella_perimeter_secure"))
	
	;just incase player is inside the tower already
	(if (not (volume_test_players vol_cell_a_all))
		(sleep_forever)
	)
		; cast the actors
		(vs_cast all_allies FALSE 0 "100MC_030")
			(set odst (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe odst TRUE)
	(vs_enable_looking odst  TRUE)
	(vs_enable_targeting odst TRUE)
	(vs_enable_moving odst TRUE)
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "ODST: Perimeter secure! Get inside that tower!"))
		(sleep (ai_play_line odst 100MC_030))
		(sleep 10)
		
		(ai_dialogue_enable TRUE)
		(sleep_until (volume_test_players vol_lock_a01_start))
		(ai_dialogue_enable FALSE)
		
		(if dialogue (print "ODST: Stick together, check your corners!"))
		(sleep (ai_play_line odst 100MC_040))
		(sleep 10)
		
		;*
		(if dialogue (print "ODST: Brutes know we're coming in!"))
		(vs_play_line odst TRUE 100MC_050)
		(sleep 10)

		(if dialogue (print "ODST: Sir! We gotta offline this facility!"))
		(vs_play_line odst TRUE 100MC_060)
		(sleep 10)

		(if dialogue (print "ODST: Get inside the tower! Take it down!"))
		(vs_play_line odst TRUE 100MC_070)
		(sleep 10)
		*;

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_cella_mir_get_inside
	(sleep_until (<= (ai_task_count cell_a_cov_obj/ground_vehicles) 0))
	(sleep (random_range 30 100))
	(if debug (print "mission dialogue:cella:mir:get:inside"))
	
	(ai_dialogue_enable FALSE)
	
		(if (not (volume_test_players vol_cell_a_lockstart))
			(begin
				(if dialogue (print "MIRANDA (radio): Chief! You've got to offline that tower!"))
				(sleep (ai_play_line_on_object NONE 100MC_080))
				(ai_dialogue_enable TRUE)
				(sleep (* 30 10))
				
				(if (not (volume_test_players vol_cell_a_lockstart))
					(begin
						(if dialogue (print "MIRANDA (radio): Get inside the tower! Take it down!"))
						(sleep (ai_play_line_on_object NONE 100MC_090))
						(sleep 10)
					)
				)
			)
		)
		
	(ai_dialogue_enable TRUE)
	(game_save)
)

; ===================================================================================================================================================

(script dormant md_locka_arb_breach
	(if debug (print "mission dialogue:locka:arb:breach"))
	
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "ARBITER (radio): We have breached the second tower!"))
		(sleep (ai_play_line_on_object NONE 100MD_010))
		(sleep 10)

		(if dialogue (print "ARBITER (radio): It's control-station appears to be on an upper floor!"))
		(sleep (ai_play_line_on_object NONE 100MD_020))
		(sleep 50)
		
		(if dialogue (print "MIRANDA (radio): Chief! Find the tower controls, and shut it down!"))
		(sleep (ai_play_line_on_object NONE 100MD_110))
		(sleep 10)
	
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_locka_elite_breach
	(if debug (print "mission dialogue:locka:elite:breach"))
	
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "ELITE (radio): We have breached the second tower!"))
		(sleep (ai_play_line_on_object NONE 100MD_030))
		(sleep 10)

		(if dialogue (print "ELITE (radio): It's control-station appears to be on an upper floor!"))
		(sleep (ai_play_line_on_object NONE 100MD_040))
		(sleep 10)
		
		(if dialogue (print "MIRANDA (radio): Chief! Find the tower controls, and shut it down!"))
		(sleep (ai_play_line_on_object NONE 100MD_110))
		(sleep 10)
		
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_locka_hold_here
	(sleep_until (and 
		(<= (ai_living_count lock_a_cov_obj) 0)
		(volume_test_players vol_lock_a_elevator_bottom))
	)
	(if debug (print "mission dialogue:locka:hold:here"))

		; cast the actors
		(vs_cast beach_inf_marines FALSE 0 "100MD_050")
			(set odst (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe odst TRUE)
	(vs_enable_looking odst  TRUE)
	(vs_enable_targeting odst TRUE)
	(vs_enable_moving odst TRUE)
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		;(if dialogue (print "ODST: We'll hold here, sir!  Watch for hostile reinforcements!"))
		;(sleep (ai_play_line odst 100MD_050))
		;(sleep 10)
		
		(vs_go_to odst TRUE lock_a_pts/send_off)
		;(vs_face_player odst TRUE)
		(vs_action_at_player odst FALSE 20)
		(if dialogue (print "ODST: Sir! Go on! Tower control should be up top!"))
		(sleep (ai_play_line odst 100MD_060))
		(sleep 10)


	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================
;*
(script dormant nacho05
	(if debug (print "nacho05"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MD_070")
			(set truth (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "TRUTH: I opened the portal to this hallowed place -- this shelter from Halos fire -- in the hopes that more of our Covenant would follow."))
		(vs_play_line truth TRUE 100MD_070)
		(sleep 10)

		(if dialogue (print "TRUTH: Alas, save for a rabble of heretics and their demon allies, we are all that made the passage. "))
		(vs_play_line truth TRUE 100MD_080)
		(sleep 10)

		(if dialogue (print "TRUTH: And thus we must temper joy with sorrow -- keep in our hearts those left behind."))
		(vs_play_line truth TRUE 100MD_090)
		(sleep 10)

	; cleanup
	(vs_release_all)
)
*;
; ===================================================================================================================================================

(script dormant md_locka_prompt01
	(if debug (print "mission dialogue:locka:prompt01"))
	
	(sleep (random_range 30 60))

	(sleep 1)

		;(if dialogue (print "MIRANDA (radio): You should be close to the tower controls, Chief!"))
		;(sleep (ai_play_line_on_object NONE 100MD_100))
		;(sleep 10)

		(if dialogue (print "MIRANDA (radio): Chief! Find the tower controls, and shut it down!"))
		(sleep (ai_play_line_on_object NONE 100MD_110))
		(sleep 10)
)

; ===================================================================================================================================================

(script dormant md_locka_tower1_done
	(if debug (print "mission dialogue:locka:tower1:done"))

	(sleep 1)
		(sleep 90)
		(print "Left Beam: OFF")
		(effect_new_on_object_marker "levels\solo\100_citadel\fx\beam_deactivation\beam_deactivation_small.effect" beam_deactivation_1 "")
		(device_set_power beam_diag_left 0)
		(device_set_power beam_vert_left 0)
		(device_set_power beam_vert_left_crater 0)

		(sleep 30)
		(if dialogue (print "MIRANDA (radio): Good work, Chief! That's one!"))
		(sleep (ai_play_line_on_object NONE 100PA_010))
		(sleep 10)
		
		(if (= (game_is_cooperative) FALSE)
			(begin
				(if dialogue (print "MIRANDA (radio): The Arbiter should be just about to"))
				(sleep (ai_play_line_on_object NONE 100PA_020))
			)
			(begin		
				(if dialogue (print "MIRANDA (radio): The Elites should be just about to"))
				(sleep (ai_play_line_on_object NONE 100PA_030))
			)
		)
		
		(print "Mid Beam: OFF")
		(effect_new_on_object_marker "levels\solo\100_citadel\fx\beam_deactivation\beam_deactivation_large.effect" beam_deactivation_2 "")
		(device_set_power beam_diag_mid 0)
		(device_set_power beam_vert_mid 0)
		(device_set_power beam_vert_mid_crater 0)

		
		(if dialogue (print "MIRANDA (radio): That's two! It's all up to Johnson's team now."))
		(sleep (ai_play_line_on_object NONE 100PA_040))
		(sleep 40)

		(if dialogue (print "MIRANDA (radio): Get back outside, Chief. Wait for transport!"))
		(sleep (ai_play_line_on_object NONE 100PA_050))
		
		(cinematic_set_chud_objective obj_1)
		(sleep (random_range 60 100))
		(wake md_locka_joh_update)
)

; ===================================================================================================================================================

(script dormant md_locka_joh_update
	(if debug (print "mission dialogue:locka:joh:update"))

	(ai_dialogue_enable FALSE)
	(sleep 1)
;*
		(if dialogue (print "MIRANDA (radio): What's your status, Sergeant Major?"))
		(sleep (ai_play_line_on_object NONE 100MD_120))
		(sleep 10)
*;
		(if dialogue (print "MIRANDA (radio): Johnson? Come in, over?"))
		(sleep (ai_play_line_on_object NONE 100MD_130))
		(sleep (random_range 50 80))

		(if dialogue (print "JOHNSON (radio, over combat): Brute reinforcements, ma'am! We're pinned down!"))
		(sleep (ai_play_line_on_object NONE 100MD_140))
		(sleep 10)
;*
		(if dialogue (print "JOHNSON (radio, over combat): Hunters, ma'am! We're pinned down!"))
		(vs_play_line johnson TRUE 100MD_150)
		(sleep 10)

		(if dialogue (print "JOHNSON (radio, over combat): Hunters and Drones, ma'am! We're pinned down!"))
		(sleep (ai_play_line_on_object NONE 100MD_160))
		(sleep 10)
*;
		(if dialogue (print "MIRANDA (radio): I'm on my way!"))
		(sleep (ai_play_line_on_object NONE 100MD_170))
		(sleep 10)

		(if dialogue (print "JOHNSON (radio, over combat): Negative! Fire's too heavy!"))
		(sleep (ai_play_line_on_object NONE 100MD_180))
		(sleep 10)

		(if dialogue (print "JOHNSON (to his marines): Everyone fall back! Now!"))
		(sleep (ai_play_line_on_object NONE 100MD_200))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): Sergeant Major!"))
		(sleep (ai_play_line_on_object NONE 100MD_210))
		(sleep (random_range 45 60))
;*		
		(if dialogue (print "JOHNSON (radio, over combat): (grunt of pain)"))
		(sleep (ai_play_line_on_object NONE 100MD_190))
		(sleep 10)
*;
		(if dialogue (print "MIRANDA (radio): Johnson, can you hear me?"))
		(sleep (ai_play_line_on_object NONE 100MD_220))
		(sleep (random_range 50 80))
		
		(ai_dialogue_enable TRUE)
		(wake br_tower03_02)
)

; ===================================================================================================================================================

(script dormant br_tower03_02
	(if debug (print "br:tower03:02"))

	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "MIRANDA (radio): Chief, I've lost contact with Johnson and his team."))
		(sleep (ai_play_line_on_object NONE 100BB_010))
		(sleep 10)
		;(wake play_100BB)
		
		(if (= (game_is_cooperative) FALSE)
			(begin
				(if dialogue (print "MIRANDA (radio): You need to link up with the Arbiter, and proceed directly to the third tower."))
				(sleep (ai_play_line_on_object NONE 100BB_020))
				(sleep 10)
			)
			(begin
				(if dialogue (print "MIRANDA (radio): You need to link up with the Elites, and proceed directly to the third tower."))
				(sleep (ai_play_line_on_object NONE 100BB_030))
				(sleep 10)
			)
		)
		
		(if dialogue (print "MIRANDA (radio): Make your way back to the beach."))
		(sleep (ai_play_line_on_object NONE 100BB_040))
		(sleep 10)
;*
		(if dialogue (print "MIRANDA (radio): I'll have transport meet you en route!"))
		(sleep (ai_play_line_on_object NONE 100BB_050))
		(sleep 10)
*;		
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_cellb_get_in
	(if debug (print "mission dialogue:cellb:get:in"))

		; cast the actors
		(vs_cast cell_b_hog FALSE 0 "100ME_010")
			(set odst (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe cell_b_hog TRUE)
	(vs_enable_looking cell_b_hog  TRUE)
	(vs_enable_targeting cell_b_hog TRUE)
	(vs_enable_moving cell_b_hog TRUE)
    (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "ODST: Get in, sir!"))
		(sleep (ai_play_line odst 100ME_010))
		(sleep 10)

		(if dialogue (print "ODST: Hog's all yours!"))
		(sleep (ai_play_line odst 100ME_020))
		(sleep 10)

		(if dialogue (print "ODST: Gotta get to the beach!"))
		(sleep (ai_play_line odst 100ME_030))
		(sleep 60)

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)
;*
; ===================================================================================================================================================

(script dormant md_cellb_prompt01
	(if debug (print "mission dialogue:cellb:prompt01"))

		; cast the actors
		(vs_cast SQUAD TRUE "100ME_040")
			(set odst (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "ODST: Let's head back to the beach, sir!"))
		(vs_play_line odst TRUE 100ME_040)
		(sleep 10)

		(if dialogue (print "ODST: Drive back down the same way you came up!"))
		(vs_play_line odst TRUE 100ME_050)
		(sleep 10)

	; cleanup
	(vs_release_all)
)
*;
; ===================================================================================================================================================

(script dormant md_cellb_hornets
	(if debug (print "mission dialogue:cellb:hornets"))
	
	(ai_dialogue_enable FALSE)
	(sleep 1)
	
		(if dialogue (print "HOCUS (radio): Sir! Got a flight of birds that need an escort!"))
		(sleep (ai_play_line_on_object NONE 100MF_010))
		(sleep 10)

		(if dialogue (print "HOCUS (radio): Take the Hornet!"))
		(sleep (ai_play_line_on_object NONE 100MF_020))
		(sleep 10)

		(if dialogue (print "HOCUS (radio): Get those Pelicans safely to the third tower!"))
		(sleep (ai_play_line_on_object NONE 100MF_030))
		(sleep 10)
		
	(ai_dialogue_enable TRUE)
	(game_save)
)

; ===================================================================================================================================================

(script dormant md_cellb_arb_2nd_clear
	(sleep_until (or
		(volume_test_players vol_cell_b_towerclear)
		(= (current_zone_set) 5))
	)
	(if (= (current_zone_set) 5)
		(sleep_forever)
	)
	(if debug (print "mission dialogue:cellb:arb:2nd:clear"))
	
	(ai_dialogue_enable FALSE)
	(sleep 1)
	
	(if (= (game_is_cooperative) FALSE)
		(begin
		(if dialogue (print "ARBITER (radio): The second tower is clear, Spartan! No need to land!"))
		(sleep (ai_play_line_on_object NONE 100MF_040))
		(sleep 20)

		(if dialogue (print "ARBITER (radio): Let us hasten to the third!"))
		(sleep (ai_play_line_on_object NONE 100MF_050))
		(sleep 10)
		)
		(begin
		(if dialogue (print "ELITE (radio): The second tower is clear! No need to land!"))
		(sleep (ai_play_line_on_object NONE 100MF_060))
		(sleep 10)

		(if dialogue (print "ELITE (radio): Let us hasten to the third!"))
		(sleep (ai_play_line_on_object NONE 100MF_070))
		(sleep 10)
		)
	)
	(ai_dialogue_enable TRUE)
	(wake lock_c_nav_start01)
)

; ===================================================================================================================================================

(script dormant md_cellc_clear_lz
	(if debug (print "mission dialogue:cellc:clear:lz"))

	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "PILOT (radio): Objective in sight, Commander!"))
		(sleep (ai_play_line_on_object NONE 100MG_010))
		(sleep 50)

		(if dialogue (print "PILOT (radio): No sign of Johnson or his team"))
		(sleep (ai_play_line_on_object NONE 100MG_020))
		(sleep 40)

		(if dialogue (print "MIRANDA (radio): Understood."))
		(sleep (ai_play_line_on_object NONE 100MG_030))
		(sleep 50)
		
		;(sleep_until (<= (ai_task_count cell_c_cov_obj/air_gate) 0) 30 (* 30 10))
		
		(if dialogue (print "MIRANDA (radio): Chief, clear an LZ, then get inside the tower!"))
		(sleep (ai_play_line_on_object NONE 100MG_040))
		(sleep 10)
	
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_cellc_clear_deck
	(if debug (print "mission dialogue:cellc:clear:deck"))

	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "PILOT (radio): Brutes, sir! Light 'em up!"))
		(sleep (ai_play_line_on_object NONE 100MG_050))
		(sleep 50)

		(if dialogue (print "PILOT (radio): Clear the deck so we can land!"))
		(sleep (ai_play_line_on_object NONE 100MG_060))
		(sleep 10)
		
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================
;*
(script dormant md_cellc_arb_hold_here
	(if debug (print "mission dialogue:cellc:arb:hold:here"))

		; cast the actors
		(vs_cast all_allies TRUE 0 "100MG_070")
			(set arbiter (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "ARBITER: I will hold the perimeter, Spartan!"))
		(sleep (ai_play_line arbiter 100MG_070))
		(sleep 10)

		(if dialogue (print "ARBITER: Dispatch the traitors inside!"))
		(sleep (ai_play_line arbiter 100MG_080))
		(sleep 50)
		
		(if dialogue (print "ARBITER: Darken this tower, and the barrier will fall!"))
		(sleep (ai_play_line arbiter 100MG_130))
		(sleep 90)

		(if dialogue (print "ARBITER: Go, Spartan! We have no time to waste!"))
		(sleep (ai_play_line arbiter 100MG_140))

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_cellc_elite_hold_here
	(if debug (print "mission dialogue:cellc:elite:hold:here"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MG_090")
			(set elite (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "ELITE: We'll hold the perimeter!"))
		(vs_play_line elite TRUE 100MG_090)
		(sleep 10)

		(if dialogue (print "ELITE: You dispatch the traitors inside!"))
		(vs_play_line elite TRUE 100MG_100)
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_lockc_spark01
	(if debug (print "mission dialogue:lockc:spark01"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MG_110")
			(set spark (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "GUILTY (quietly, to himself): First verify the Foundry's assignment"))
		(vs_play_line spark TRUE 100MG_110)
		(sleep 10)

		(if dialogue (print "GUILTY (quietly, to himself): Then decide which protocols apply."))
		(vs_play_line spark TRUE 100MG_120)
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
*;
(script dormant md_lockc_arb_prompt01
	(sleep_until (and 
		(<= (ai_living_count lock_c_cov_obj) 0)
		(volume_test_players vol_lock_c_elevator_bottom))
	)
	(if debug (print "mission dialogue:lockc:arb:prompt01"))

		; cast the actors
		(vs_cast all_allies TRUE 0 "100MG_130")
			(set arbiter (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)
     (vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)
	
		(vs_go_to arbiter TRUE lock_c_pts/send_off)
		(vs_face_player arbiter TRUE)
		;(vs_action_at_player arbiter TRUE 20)

		(if dialogue (print "ARBITER: Darken this tower, and the barrier will fall!"))
		(sleep (ai_play_line arbiter 100MG_130))
		(sleep 10)

		(if dialogue (print "ARBITER: Go, Spartan! We have no time to waste!"))
		(sleep (ai_play_line arbiter 100MG_140))
		(sleep 10)

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
	(game_save)
)
;*
; ===================================================================================================================================================

(script dormant md_lockc_elite_prompt01
	(if debug (print "mission dialogue:lockc:elite:prompt01"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MG_150")
			(set elite (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "ELITE: Darken this tower, and the barrier will fall!"))
		(vs_play_line elite TRUE 100MG_150)
		(sleep 10)

		(if dialogue (print "ELITE: Go! We have no time to waste!"))
		(vs_play_line elite TRUE 100MG_160)
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_lockc_fight_up
	(if debug (print "mission dialogue:lockc:fight:up"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MH_010")
			(set sergeant (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "SERGEANT (to Player): Same as before, Chief!"))
		(vs_play_line sergeant TRUE 100MH_010)
		(sleep 10)

		(if dialogue (print "SERGEANT: Fight your way up top, cut the power!"))
		(vs_play_line sergeant TRUE 100MH_020)
		(sleep 10)

		(if dialogue (print "SERGEANT (to his squad): On me, marines! Keep him covered!"))
		(vs_play_line sergeant TRUE 100MH_030)
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_lockc_spark02
	(if debug (print "mission dialogue:lockc:spark02"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MH_040")
			(set spark (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "GUILTY (quietly, to himself): How dare he lock me out!"))
		(vs_play_line spark TRUE 100MH_040)
		(sleep 10)

		(if dialogue (print "GUILTY (quietly, to himself): The Foundry is none of his concern!"))
		(vs_play_line spark TRUE 100MH_050)
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant md_lockc_hold_here
	(if debug (print "mission dialogue:lockc:hold:here"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MH_060" "100MH_070")
			(set sergeant (vs_role 1))
			(set marine (vs_role 2))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "SERGEANT: We'll hold the exit, Chief! You head on up!"))
		(vs_play_line sergeant TRUE 100MH_060)
		(sleep 10)

		(if dialogue (print "MARINE: Go on up, sir! We got the exit!"))
		(vs_play_line marine TRUE 100MH_070)
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================

(script dormant CA
	(if debug (print "CA"))


	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "CORTANA (radio, static): It asked, and I answered. "))
		(sleep (ai_play_line_on_object NONE 100CA_010))
		(sleep 10)

		(if dialogue (print "CORTANA (radio, static): Why spend your fury on one world, when the galaxy awaits?"))
		(sleep (ai_play_line_on_object NONE 100CA_020))
		(sleep 10)

		(if dialogue (print "CORTANA (radio, static): For a moment of safety, I loosed damnation on the stars."))
		(sleep (ai_play_line_on_object NONE 100CA_030))
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
*;
(script dormant md_lockc_prompt02
	(if debug (print "mission dialogue:lockc:prompt02"))

	(sleep (random_range 30 60))

		;(if dialogue (print "MIRANDA (radio): Chief! Take that tower off-line!"))
		;(sleep (ai_play_line_on_object NONE 100MH_080))
		;(sleep 10)

		(if dialogue (print "MIRANDA (radio): Hit the switch, Chief! And the barrier will fall!"))
		(sleep (ai_play_line_on_object NONE 100MH_090))
		(sleep 10)
)

; ===================================================================================================================================================

(script dormant md_lockc_status
	(if debug (print "mission dialogue:lockc:status"))

	(sleep (random_range 100 160))
	(ai_dialogue_enable FALSE)
	
		(if dialogue (print "MIRANDA (radio): Shipmaster, what's your status?"))
		(sleep (ai_play_line_on_object NONE 100MH_100))
		(sleep 10)

		(if dialogue (print "SHIPMASTER (radio, static): Significant damage! Weapons systems disabled!"))
		(sleep (ai_play_line_on_object NONE 100MH_110))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): Move to a safe distance! Stay away from the Flood!"))
		(sleep (ai_play_line_on_object NONE 100MH_120))
		(sleep 10)

		(if dialogue (print "SHIPMASTER (radio, static): Why would the Parasite come here?"))
		(sleep (ai_play_line_on_object NONE 100MH_130))
		(sleep 10)

		(if dialogue (print "GUILTY (radio): Safety! The Ark is well beyond the installations' range!"))
		(sleep (ai_play_line_on_object NONE 100MH_140))
		(sleep 10)

		(if dialogue (print "GUILTY (radio): We must contain the outbreak before --"))
		(sleep (- (ai_play_line_on_object NONE 100MH_150) 15))

		(if dialogue (print "MIRANDA (radio): No! First we stop Truth, then we deal with the Flood!"))
		(sleep (ai_play_line_on_object NONE 100MH_160))
		(sleep 10)
	
	(ai_dialogue_enable TRUE)
)
;*
; ===================================================================================================================================================

(script dormant md_lockc_flood_here
	(if debug (print "mission dialogue:lockc:flood:here"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MH_170")
			(set odst (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "ODST: If the Flood is here, what happened to Earth?"))
		(vs_play_line odst TRUE 100MH_170)
		(sleep 10)

		(if dialogue (print "ODST: Don't think! Shoot!"))
		(vs_play_line odst TRUE 100MH_180)
		(sleep 10)

	; cleanup
	(vs_release_all)
)
*;
; ===================================================================================================================================================

(script dormant md_ridge_spark_assess
	(if debug (print "mission dialogue:ridge:spark:assess"))

		; cast the actors
		(vs_cast all_allies TRUE 0 "100MI_010")
			(set spark (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe spark TRUE)
	;(vs_enable_looking spark  TRUE)
	;(vs_enable_targeting spark TRUE)
	;(vs_enable_moving spark TRUE)
    (vs_set_cleanup_script md_cleanup)
	(sleep 1)
		
		(if dialogue (print "GUILTY: Quickly! I must see the point of impact!"))
		(ai_play_line spark 100MI_010)
		(sleep 10)

		(vs_fly_to spark TRUE cell_c_pts/spark_phantom_exit01 1)
		(if dialogue (print "GUILTY: Assess the damage to the Ark!"))
		(ai_play_line spark 100MI_020)
		(sleep 10)
		(vs_fly_to spark TRUE cell_c_pts/spark_phantom_exit02 1)

	; cleanup
	;(vs_release_all)
	(wake md_ridge_arb_assess)
)

; ===================================================================================================================================================

(script dormant md_ridge_arb_assess
	(if debug (print "mission dialogue:ridge:arb:assess"))

		; cast the actors
		(vs_cast all_allies TRUE 0 "100MI_030")
			(set arbiter (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe arbiter TRUE)
	(vs_enable_looking arbiter  TRUE)
	(vs_enable_targeting arbiter TRUE)
	(vs_enable_moving arbiter TRUE)
	(vs_set_cleanup_script md_cleanup)
	(sleep 1)
		
		(if dialogue (print "ARBITER: To the top of these hills, Oracle! No higher!"))
		(sleep (ai_play_line arbiter 100MI_030))
		(sleep 10)

		(if dialogue (print "ARBITER: We cannot risk your capture by the Flood!"))
		(sleep (ai_play_line arbiter 100MI_040))
		(sleep 10)

	; cleanup
	(vs_release_all)
)
;*
; ===================================================================================================================================================

(script dormant md_ridge_elite_assess
	(if debug (print "mission dialogue:ridge:elite:assess"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MI_050")
			(set elite (vs_role 1))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "ELITE: To the top of these hills, Oracle! No higher!"))
		(vs_play_line elite TRUE 100MI_050)
		(sleep 10)

		(if dialogue (print "ELITE: We cannot risk your capture by the Flood!"))
		(vs_play_line elite TRUE 100MI_060)
		(sleep 10)

	; cleanup
	(vs_release_all)
)

; ===================================================================================================================================================
*;
(script dormant br_citadel_03
	(sleep_until 
		(or
			(any_players_in_vehicle)
			(volume_test_players vol_ice_start)
		)
	)
	(if debug (print "br:citadel:03"))
		(ai_dialogue_enable FALSE)
		
		(if dialogue (print "MIRANDA (radio): The Shipmaster's carrier is out of commission, Chief."))
		(sleep (ai_play_line_on_object NONE 100BC_010))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): I need you to take down Truth!"))
		(sleep (ai_play_line_on_object NONE 100BC_020))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio) : The Flood's just going to put pressure on him -- accelerate his plans"))
		(sleep (ai_play_line_on_object NONE 100BC_030))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): Punch through the cliffs, get inside that citadel!"))
		(sleep (ai_play_line_on_object NONE 100BC_040))
		(sleep 40)

		(ai_dialogue_enable TRUE)
)
;*
; ===================================================================================================================================================

(script dormant md_ridge_prompt01
	(if debug (print "mission dialogue:ridge:prompt01"))

		; cast the actors
		(vs_cast SQUAD TRUE "100MI_070" "100MI_080")
			(set sergeant (vs_role 1))
			(set odst (vs_role 2))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)

	(sleep 1)

		(if dialogue (print "SERGEANT: Come on, Chief! Let's roll! "))
		(vs_play_line sergeant TRUE 100MI_070)
		(sleep 10)

		(if dialogue (print "ODST: Sir! Clock's ticking! Let's hit that citadel!"))
		(vs_play_line odst TRUE 100MI_080)
		(sleep 10)

	; cleanup
	(vs_release_all)
)
*;
; ===================================================================================================================================================

(script dormant md_crater_citadel_insight
	(if debug (print "mission dialogue:ridge:prompt01"))
	;*
		; cast the actors
		(vs_cast all_allies TRUE "100MI_070" "100MI_080")
			(set sergeant (vs_role 1))
			(set odst (vs_role 2))

	; movement properties
	(vs_enable_pathfinding_failsafe all_allies TRUE)
	(vs_enable_looking all_allies  TRUE)
	(vs_enable_targeting all_allies TRUE)
	(vs_enable_moving all_allies TRUE)
	*;
	
	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "ODST (radio): Citadel in sight!"))
		(sleep (ai_play_line_on_object NONE 100MJ_010))
		(sleep 40)
		
		;music
		(wake music_100_09)
		
		; stop music 
		(set g_music_100_088 FALSE)
		(set g_music_100_089 FALSE)

		(if dialogue (print "ODST (radio): Brutes are mobilizing everything they've got!"))
		(sleep (ai_play_line_on_object NONE 100MJ_020))
		(sleep 10)

	; cleanup
	(vs_release_all)
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_crater_hornets_inbound
	(sleep 200)
	(if debug (print "md:crater:hornets:inbound"))

	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "SERGEANT: Hornets inbound!"))
		(sleep (ai_play_line_on_object NONE 100MK_010))
		(sleep 10)
		
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_crater_two_scarabs
	(sleep 60)
	(if debug (print "md:crater:two:scarabs"))

	(ai_dialogue_enable FALSE)
	(sleep 1)

		(if dialogue (print "ODST (radio): I count two Scarabs! Repeat: two Scarabs!"))
		(sleep (ai_play_line_on_object NONE 100MJ_030))
		(sleep 10)
		
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_crater_first_scarab_dead
	(sleep 100)
	(if debug (print "md:crater:first:scarab:dead"))
	
	(ai_dialogue_enable FALSE)
	(sleep 1)
		
		(if dialogue (print "MIRANDA: First Scarab's down!"))
		(sleep (ai_play_line_on_object NONE 100MK_190))
		(sleep 10)

		(if dialogue (print "MIRANDA: All units: concentrate your fire on number two!"))
		(sleep (ai_play_line_on_object NONE 100MK_200))
		(sleep 10)
		
	(ai_dialogue_enable TRUE)
)
; ===================================================================================================================================================

(script dormant md_crater_second_scarab_dead
	(sleep 100)
	(if debug (print "md:crater:second:scarab:dead"))
	
	(ai_dialogue_enable FALSE)
	(sleep 1)
		
		(if dialogue (print "MIRANDA: Both Scarabs down! Well done!"))
		(sleep (ai_play_line_on_object NONE 100MK_210))
		(sleep 10)
	
	(if (>= (ai_task_count crater_cov_obj/grond_vehicle_gate) 1)
	(begin
		(if dialogue (print "MIRANDA: Marines: kill the stragglers!"))
		(sleep (ai_play_line_on_object NONE 100MK_220))
		(sleep 10)
	)
	)
		
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_crater_platform
	(sleep 100)
	(if debug (print "md:crater:platform"))
	
	(ai_dialogue_enable FALSE)
	(sleep 1)
	
	(if (= (game_is_cooperative) FALSE)
		(begin
		(if dialogue (print "ARBITER (radio): Spartan! Come to me!"))
		(sleep (ai_play_line_on_object NONE 100MK_240))
		(sleep 10)

		(if dialogue (print "ARBITER (radio): This platform hides a path!"))
		(sleep (ai_play_line_on_object NONE 100MK_250))
		(sleep 10)
		)
	)

		(if dialogue (print "MIRANDA (radio): Chief, the Monitor's found a way into the Citadel!"))
		(sleep (ai_play_line_on_object NONE 100MK_260))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): He's waiting for you on the platform, Chief! Go!"))
		(sleep (ai_play_line_on_object NONE 100MK_270))
		(sleep 10)
		
		(sleep (* 30 200))
		(if (<= (device_get_position citadel_entry_door01) 0)
			(wake md_crater_platform02)
		)
		
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_crater_platform02
	(sleep 100)
	(if debug (print "md:crater:platform02"))
	
	(ai_dialogue_enable FALSE)
	(sleep 1)
		
		(if dialogue (print "MIRANDA (radio): Chief, the Monitor's found a way into the Citadel!"))
		(sleep (ai_play_line_on_object NONE 100MK_260))
		(sleep 10)

		(if dialogue (print "MIRANDA (radio): He's waiting for you on the platform, Chief! Go!"))
		(sleep (ai_play_line_on_object NONE 100MK_270))
		(sleep 10)
	
	(ai_dialogue_enable TRUE)
)

; ===================================================================================================================================================

(script dormant md_crater_platform_active
	(if debug (print "md:crater:platform:active"))
	
	; cast the actors
	(if (= (game_is_cooperative) FALSE)
		(begin
			(vs_cast crater_arbiter FALSE 0 "100MK_280")
				(set arbiter (vs_role 1))
			
			; movement properties
			(vs_enable_pathfinding_failsafe crater_arbiter TRUE)
			(vs_enable_looking crater_arbiter  TRUE)
			(vs_enable_targeting crater_arbiter TRUE)
			(vs_enable_moving crater_arbiter TRUE)
		)
	)
		(vs_cast crater_spark FALSE 0 "100MK_340")
			(set spark (vs_role 1))
	
	(vs_enable_pathfinding_failsafe crater_spark TRUE)
	(vs_enable_looking crater_spark  TRUE)
	(vs_enable_targeting crater_spark TRUE)
	(vs_enable_moving crater_spark TRUE)
	(vs_set_cleanup_script md_cleanup)
	(ai_dialogue_enable FALSE)
	(sleep 1)
	(if (= (game_is_cooperative) FALSE)
		(begin
			(vs_face_object arbiter TRUE spark)
			(if dialogue (print "ARBITER (to Player): The Flood scales the citadel's far wall!"))
			(sleep (ai_play_line arbiter 100MK_280))
			(sleep 10)
	
			(if dialogue (print "ARBITER (to Spark): Activate this bridge, Oracle! "))
			(sleep (ai_play_line arbiter 100MK_290))
			(sleep 40)
			
			(vs_face_player arbiter TRUE)
			(if dialogue (print "ARBITER: The Prophet will die by my hands not theirs!"))
			(sleep (ai_play_line arbiter 100MK_300))
			(sleep 10)
			(vs_face_player arbiter FALSE)
		)
	)
		(object_create lightbridge_crater)
		(device_set_position lightbridge_crater 1)
		(device_set_position citadel_entry_door01 1)
		
;*
		(if dialogue (print "GUILTY: The Flood has breached the citadel!"))
		(vs_play_line spark TRUE 100MK_310)
		(sleep 10)

		(if dialogue (print "GUILTY: And the Meddler will soon activate the installations!"))
		(vs_play_line spark TRUE 100MK_320)
		(sleep 20)
*;
;*
		(if dialogue (print "GUILTY: The bridge is stable!"))
		(sleep (ai_play_line spark 100MK_340))
		(cs_run_command_script spark crater_spark_exit_cs)
		(sleep 40)
*;		
		(if dialogue (print "GUILTY: Calamity! If only we had more time!"))
		(sleep (ai_play_line spark 100MK_330))
		(sleep 20)
;*
		(if dialogue (print "GUILTY: Quickly! Follow me!"))
		(vs_play_line spark TRUE 100MK_350)
		(sleep 10)
*;		
	(ai_dialogue_enable TRUE)
)

(script command_script crater_spark_exit_cs
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by crater_pts/spark_exit01 8)
	(cs_fly_by crater_pts/spark_exit02 6)
	(cs_fly_by crater_pts/spark_exit03)
	(cs_fly_to crater_pts/spark_exit04)
	(ai_erase ai_current_actor)
)

; ===================================================================================================================================================

(script dormant md_truth_tapestry_start
	(if debug (print "md:truth:tapestry:start"))
	
	;(ai_dialogue_enable FALSE)
	(sleep 1)
		
		(if dialogue (print "TRUTH (tapestry) : My faithful! Stand firm!"))
		(sleep (ai_play_line_on_object NONE 100LC_010))
		(sleep 10)

		;(if dialogue (print "TRUTH (tapestry) : Though our enemies crowd around us, we tread the blessed path!"))
		;(sleep (ai_play_line_on_object NONE 100LC_011))
		;(sleep 10)
	
	;(ai_dialogue_enable TRUE)
)
; ===================================================================================================================================================

(script dormant md_head_back
	(if debug (print "br:head:back"))
	
	(sleep 30)
		
		(ai_dialogue_enable FALSE)
		
		(if dialogue (print "Johnson: I can barely keep hold of her, Chief!"))
		(sleep (ai_play_line_on_object NONE 100VB_010))
		(sleep 10)

		(if dialogue (print "Johnson: There's no way I can pick you up!"))
		(sleep (ai_play_line_on_object NONE 100VB_020))
		(sleep 30)

		(if dialogue (print "Johnson: Head back to the lift! Find a way down!"))
		(sleep (ai_play_line_on_object NONE 100VB_030))
		(sleep 10)
		
	(wake objective_5_set)
	(ai_dialogue_enable TRUE)
)
; ===================================================================================================================================================
; ===================================================================================================================================================
; VIGNETTES 
; ===================================================================================================================================================
; ===================================================================================================================================================


; =======================================================================================================================================================================
; =======================================================================================================================================================================
; perspectives 
; =======================================================================================================================================================================
; =======================================================================================================================================================================


; =======================================================================================================================================================================
; =======================================================================================================================================================================
; subtitles 
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(script dormant 100_title1
	;(cinematic_fade_from_black_bars)
	(sleep 30)
	(cinematic_set_title title_1)
	;(sleep 150)
	;(cinematic_show_letterbox FALSE)
	;(sleep 30)
	;(chud_cinematic_fade 1 1)
)

(script dormant 100_title2
	(if (= (game_insertion_point_get) 0) (chapter_start))
	(cinematic_set_title title_2)
	(cinematic_title_to_gameplay)
)
(script dormant 100_title3
	(if (!= (game_insertion_point_get) 2) (chapter_start))
	(cinematic_set_title title_3)
	(cinematic_title_to_gameplay)
)
(script dormant 100_title4
	(cinematic_set_title title_4)
	(cinematic_title_to_gameplay)
)

; =======================================================================================================================================================================
; =======================================================================================================================================================================
; truth channel  
; =======================================================================================================================================================================
; =======================================================================================================================================================================
(global boolean g_truth FALSE)
(global short g_truth_count 0)
(global short g_truth_limit 7)

(script dormant ring_holo_truth
    (objects_attach holo_marker01right "marker" holo_truth01right "")
	(objects_attach holo_truth01right "driver"  holo_throne01right "driver")
	
	(objects_attach holo_marker01left "marker" holo_truth01left "")
	(objects_attach holo_truth01left "driver" holo_throne01left "driver")
	
	(objects_attach holo_marker02right "marker" holo_truth02right "")
	(objects_attach holo_truth02right "driver" holo_throne02right "driver")
	
	(objects_attach holo_marker02left "marker" holo_truth02left "")
	(objects_attach holo_truth02left "driver" holo_throne02left "driver")
	
	;*
	(object_hide holo_throne01right TRUE)
	(object_hide holo_truth01right TRUE)
	(object_hide holo_throne01left TRUE)
	(object_hide holo_truth01left TRUE)
	(object_hide holo_throne02right TRUE)
	(object_hide holo_truth02right TRUE)
	(object_hide holo_throne02left TRUE)
	(object_hide holo_truth02left TRUE)
	*;
	
	(ai_disregard holo_truth01right TRUE)
	(ai_disregard holo_truth01left TRUE)
	(ai_disregard holo_truth02right TRUE)
	(ai_disregard holo_truth02left TRUE)
	
	(sleep_until (volume_test_players vol_ring_truth01) 5)
	(truth_flicker01)
	(sleep_until (volume_test_players vol_ring02_init) 5)
	
	(object_hide holo_truth01right FALSE)
	(object_hide holo_truth01left FALSE)
	(object_hide holo_throne01right FALSE)
	(object_hide holo_throne01left FALSE)

	(sleep 15)
	(print "truth dialog start")
	(sound_impulse_trigger sound\dialog\100_citadel\mission\100ML_010_pot holo_truth01right 1.0 1)
	(sleep (ai_play_line_on_object holo_truth01left 100ML_010))
	(sleep 10)
;	(sound_impulse_trigger sound\dialog\100_citadel\mission\100ML_010_pot holo_truth01left 1.0 1)
;		(sleep (sound_impulse_language_time sound\dialog\100_citadel\mission\100ML_010_pot))
		
	(sound_impulse_trigger sound\dialog\100_citadel\mission\100ML_020_pot holo_truth01right 1.0 1)
	(sleep (ai_play_line_on_object holo_truth01left 100ML_020))
	(sleep 10)
;	(sound_impulse_trigger sound\dialog\100_citadel\mission\100ML_020_pot holo_truth01left 1.0 1)
;		(sleep (sound_impulse_language_time sound\dialog\100_citadel\mission\100ML_020_pot))
	(sound_impulse_trigger sound\dialog\100_citadel\mission\100ML_030_pot holo_truth01right 1.0 1)
	(sleep (ai_play_line_on_object holo_truth01left 100ML_030))
;	(sound_impulse_trigger sound\dialog\100_citadel\mission\100ML_030_pot holo_truth01left 1.0 1)
;		(sleep (sound_impulse_language_time sound\dialog\100_citadel\mission\100ML_030_pot))
		(sleep (* 30 10))
	;(sound_impulse_start sound\dialog\100_citadel\mission\040MY_070_pot holo_truth01right 1)
	;(sound_impulse_start sound\dialog\100_citadel\mission\040MY_070_pot holo_truth01left 1)
	;	(sleep (sound_impulse_language_time sound\dialog\100_citadel\mission\040MY_070_pot))
	;	(sleep 45)
	;(wake truth_flicker01)
	;(set g_truth TRUE)
	(print "truth dialog end")
	(object_destroy holo_truth01right)
	(object_destroy holo_truth01left)
	(object_destroy holo_throne01right)
	(object_destroy holo_throne01left)
	
	(sleep_until (volume_test_players vol_ring_truth02) 5)
	(truth_flicker02)
	(sleep_until (volume_test_players vol_ring03_init) 5)
	(object_hide holo_truth02right FALSE)
	(object_hide holo_truth02left FALSE)
	(object_hide holo_throne02right FALSE)
	(object_hide holo_throne02left FALSE)
	(sleep 15)
	(sound_impulse_trigger sound\dialog\100_citadel\mission\100MQ_020_pot holo_truth02right 1.0 1)
	(sleep (ai_play_line_on_object holo_truth02left 100MQ_020))
	(sleep 10)
;	(sound_impulse_trigger sound\dialog\100_citadel\mission\100MQ_020_pot holo_truth02left 1.0 1)
;		(sleep (sound_impulse_language_time sound\dialog\100_citadel\mission\100MQ_020_pot))
		
	(sound_impulse_trigger sound\dialog\100_citadel\mission\100MQ_030_pot holo_truth02right 1.0 1)
	(sleep (ai_play_line_on_object holo_truth02left 100MQ_030))
;	(sound_impulse_trigger sound\dialog\100_citadel\mission\100MQ_030_pot holo_truth02left 1.0 1)
;		(sleep (sound_impulse_language_time sound\dialog\100_citadel\mission\100MQ_030_pot))
		(sleep (* 30 10))
	;(sound_impulse_start sound\dialog\100_citadel\mission\040MY_070_pot holo_truth01right 1)
	;(sound_impulse_start sound\dialog\100_citadel\mission\040MY_070_pot holo_truth01left 1)
	;	(sleep (sound_impulse_language_time sound\dialog\100_citadel\mission\040MY_070_pot))
	;	(sleep 45)
	(set g_truth TRUE)
	;(truth_flicker02)
	(object_destroy holo_truth02right)
	(object_destroy holo_truth02left)
	(object_destroy holo_throne02right)
	(object_destroy holo_throne02left)
)

(script static void truth_flicker01
	(set g_truth FALSE)
	(set g_truth_count 0)
	(sleep_until
		(begin
			(object_hide holo_truth01right FALSE)
			(object_hide holo_truth01left FALSE)
			(object_hide holo_throne01right FALSE)
			(object_hide holo_throne01left FALSE)
			(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
				(sleep (random_range 4 15))
			(object_hide holo_truth01right TRUE)
			(object_hide holo_truth01left TRUE)
			(object_hide holo_throne01right TRUE)
			(object_hide holo_throne01left TRUE)
			(set g_truth_count (+ g_truth_count 1))
			(if (= g_truth_limit g_truth_count) (set g_truth TRUE))
		g_truth)
	(random_range 1 10))
)

(script static void truth_flicker02
	(set g_truth FALSE)
	(set g_truth_count 0)
	(sleep_until
		(begin
			(object_hide holo_truth02right FALSE)
			(object_hide holo_truth02left FALSE)
			(object_hide holo_throne02right FALSE)
			(object_hide holo_throne02left FALSE)
			(sound_impulse_start sound\visual_fx\sparks_medium NONE 1)
				(sleep (random_range 4 15))
			(object_hide holo_truth02right TRUE)
			(object_hide holo_truth02left TRUE)
			(object_hide holo_throne02right TRUE)
			(object_hide holo_throne02left TRUE)
			(set g_truth_count (+ g_truth_count 1))
			(if (= g_truth_limit g_truth_count) (set g_truth TRUE))
		g_truth)
	(random_range 1 10))
)

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

(script dormant cor01
	;(sleep_until (volume_test_players tv_cortana_01) 1)
	(sleep_until (< (device_get_position tower3_elevator) 1) 1)
	(print "CORTANA: It asked, and I answered.")
	(print "CORTANA: For a moment of safety I loosed damnation on the stars.")
	(wake 100ca_her_plan)
	;(cortana_effect_100ca)
	;(game_save)
)

(script dormant cor02
	(sleep_until (volume_test_players tv_cortana_02) 1)
	(print "CORTANA: I've lied. Cheated. Stolen. I'm a thief.")
	(print "CORTANA: But I keep what I steal.")
	(wake 100cb_confession)
	;(cortana_effect_100cb)
	;(game_save)
)

(script dormant cor03
	(sleep_until (volume_test_players tv_cortana_03) 1)
	(print "CORTANA: It's hidden deep. Where only you can find it.")
	(wake 100cc_hidden)
	;(cortana_effect_100cb)
	;(game_save)
)

;===========================================================================================================
;============================== AWARD SKULLS ===================================================================
;===========================================================================================================

(script dormant gs_award_primary_skull
	(if
		(and
			(>= (game_difficulty_get_real) normal)
			(= (game_insertion_point_get) 0)
		)
		(begin
			(object_create skull_thunderstorm)
			
			(sleep_until 
				(or
					(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
				)
			5)
	
			(print "award thunderstorm skull")
			(campaign_metagame_award_primary_skull (player0) 6)
			(campaign_metagame_award_primary_skull (player1) 6)
			(campaign_metagame_award_primary_skull (player2) 6)
			(campaign_metagame_award_primary_skull (player3) 6)
		)
	)
)

(script dormant gs_award_secondary_skull
	(if
		(and
			(>= (game_difficulty_get_real) normal)
			(= (game_insertion_point_get) 0)
		)
		(wake ring_skull)
	)
)

(script dormant ring_skull
	(print "ring skull")
	(sleep_until
	(begin
		(if g_ring_code_continue
			(begin
				(sleep_until (in_ring) 1)
				(if (not (volume_test_players vol_skull_alpha))
					(set g_ring_code_continue FALSE)
				)
			)
		)
		(sleep_until (not (volume_test_players vol_skull_alpha)) 1)
		(if g_ring_code_continue
			(begin
				(sleep_until (in_ring) 1)
				(if (not (volume_test_players vol_skull_epsilon))
					(set g_ring_code_continue FALSE)
				)
			)
		)
		(sleep_until (not (volume_test_players vol_skull_epsilon)) 1)
		(if g_ring_code_continue
			(begin
				(sleep_until (in_ring) 1)
				(if (not (volume_test_players vol_skull_eta))
					(set g_ring_code_continue FALSE)
				)
			)
		)
		(sleep_until (not (volume_test_players vol_skull_eta)) 1)
		(if g_ring_code_continue
			(begin
				(sleep_until (in_ring) 1)
				(if (not (volume_test_players vol_skull_alpha))
					(set g_ring_code_continue FALSE)
				)
			)
		)
		(sleep_until (not (volume_test_players vol_skull_alpha)) 1)
		(if g_ring_code_continue
			(begin
				(sleep_until (in_ring) 1)
				(if (not (volume_test_players vol_skull_eta))
					(set g_ring_code_continue FALSE)
				)
			)
		)
		(sleep_until (not (volume_test_players vol_skull_eta)) 1)
		(if g_ring_code_continue
			(begin
				(sleep_until (in_ring) 1)
				(if (not (volume_test_players vol_skull_delta))
					(set g_ring_code_continue FALSE)
				)
			)
		)
		(sleep_until (not (volume_test_players vol_skull_delta)) 1)
		(if g_ring_code_continue
			(begin
				(sleep_until (in_ring) 1)
				(if (not (volume_test_players vol_skull_alpha))
					(set g_ring_code_continue FALSE)
					(wake skull_ring_flashes)
				)
			)
		)
		(sleep_until (not (volume_test_players vol_skull_alpha)) 1)
		(if (not g_ring_code_continue)
			(print "you FAIL")
		)
		(set g_ring_code_continue TRUE)
		FALSE
	)
	)
)

(script dormant skull_ring_flashes
	(print "you WIN")
	(set g_music_100_13 FALSE)
	(object_create skull_daddy)
	(sleep_until
		(begin
			(object_set_function_variable haloring_zeta bloom .5 0)
			(sleep 5)
			(object_set_function_variable haloring_gamma bloom .5 0)
			(sleep 5)
			(object_set_function_variable haloring_delta bloom .5 0)
			(sleep 5)
			(object_set_function_variable haloring_alpha bloom .5 0)
			(sleep 5)
			(object_set_function_variable haloring_eta bloom .5 0)
			(sleep 5)
			(object_set_function_variable haloring_epsilon bloom .5 0)
			(sleep 5)
			(object_set_function_variable haloring_beta bloom .5 0)
			(sleep 5)
			
			(object_set_function_variable haloring_alpha bloom 0 10)
			(object_set_function_variable haloring_beta bloom 0 10)
			(object_set_function_variable haloring_gamma bloom 0 10)
			(object_set_function_variable haloring_delta bloom 0 10)
			(object_set_function_variable haloring_epsilon bloom 0 10)
			(object_set_function_variable haloring_eta bloom 0 10)
			(object_set_function_variable haloring_zeta bloom 0 10)
			(sleep 10)
			(or
				(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
				(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
				(unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
				(unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\secondary_skull.weapon")
			)
		)
	)
	
	
	(skull_ring_song)
	(object_set_function_variable haloring_alpha bloom 1 60)
	(object_set_function_variable haloring_beta bloom 1 60)
	(object_set_function_variable haloring_gamma bloom 1 60)
	(object_set_function_variable haloring_delta bloom 1 60)
	(object_set_function_variable haloring_epsilon bloom 1 60)
	(object_set_function_variable haloring_eta bloom 1 60)
	(object_set_function_variable haloring_zeta bloom 1 60)
	
	(print "award daddy skull")
	(campaign_metagame_award_secondary_skull (player0) 4)
	(campaign_metagame_award_secondary_skull (player1) 4)
	(campaign_metagame_award_secondary_skull (player2) 4)
	(campaign_metagame_award_secondary_skull (player3) 4)
)

(script static void skull_ring_song
	(sound_impulse_start sound\music\stingers\iwhbyd NONE 1)
	(object_set_function_variable haloring_alpha bloom 1 30)
	(sleep 30)
	(object_set_function_variable haloring_alpha bloom 0 30)
	(sleep 40)
	
	(object_set_function_variable haloring_epsilon bloom 1 30)
	(sleep 30)
	(object_set_function_variable haloring_epsilon bloom 0 30)
	(sleep 30)
	
	(object_set_function_variable haloring_eta bloom 1 30)
	(sleep 30)
	(object_set_function_variable haloring_eta bloom 0 30)
	(sleep 30)
	
	(object_set_function_variable haloring_alpha bloom 1 30)
	(sleep 30)
	(object_set_function_variable haloring_alpha bloom 0 30)
	(sleep 15)
	
	(object_set_function_variable haloring_eta bloom 1 30)
	(sleep 30)
	(object_set_function_variable haloring_eta bloom 0 30)
	(sleep 30)
	
	(object_set_function_variable haloring_delta bloom 1 30)
	(sleep 30)
	(object_set_function_variable haloring_delta bloom 0 30)
	(sleep 30)
	
	(object_set_function_variable haloring_alpha bloom 1 30)
	(sleep 90)
)

;===================
(global boolean g_ring_code_continue TRUE)

(script static boolean in_ring
	(or
		(volume_test_players vol_skull_zeta)
		(volume_test_players vol_skull_gamma)
		(volume_test_players vol_skull_delta)
		(volume_test_players vol_skull_alpha)
		(volume_test_players vol_skull_eta)
		(volume_test_players vol_skull_epsilon)
		(volume_test_players vol_skull_beta)
	)
)