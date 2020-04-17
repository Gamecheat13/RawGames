; ===================================================================================================================================================
; ===================================================================================================================================================
; MISSION MUSIC
; ===================================================================================================================================================
; ===================================================================================================================================================

(global short g_music_m60_01 0)
(global short g_music_m60_02 0)
(global short g_music_m60_03 0)
(global short g_music_m60_04 0)
(global short g_music_m60_05 0)
(global short g_music_m60_06 0)
(global short g_music_m60_07 0)
(global short g_music_m60_08 0)
(global short g_music_m60_09 0)
(global short g_music_m60_10 0)
(global short g_music_m60_11 0)
(global short g_music_m60_12 0)
(global short g_music_m60_13 0)
(global short g_music_m60_14 0)
(global short g_music_m60_15 0)



(script dormant m60_music_01
	(sleep_until (= g_music_m60_01 1))
	(if g_debug (print "start music m60_01"))	
	(sound_looping_start levels\solo\m60\music\m60_music_01 NONE 1)

	(sleep_until (= g_music_m60_01 2))
	(if g_debug (print "stop music m60_01"))
	(sound_looping_stop levels\solo\m60\music\m60_music_01)
)

(script dormant m60_music_02
	(sleep_until (= g_music_m60_02 1))
	(if g_debug (print "start music m60_02"))
	(sound_looping_start levels\solo\m60\music\m60_music_02 NONE 1)

	(sleep_until (= g_music_m60_02 3))
	(if g_debug (print "stop music m60_02"))
	(sound_looping_stop levels\solo\m60\music\m60_music_02)
	(sleep_forever m60_music_02_alt)
)

(script dormant m60_music_02_alt
	(sleep_until (= g_music_m60_02 2))
	(if g_debug (print "start music m60_02_alt"))
	(sound_looping_set_alternate levels\solo\m60\music\m60_music_02 TRUE)
)

(script dormant m60_music_03
	(sleep_until (= g_music_m60_03 1))
	(if g_debug (print "start music m60_03"))
	(sound_looping_start levels\solo\m60\music\m60_music_03 NONE 1)

	(sleep_until (= g_music_m60_03 2))
	(if g_debug (print "stop music m60_03"))
	(sound_looping_stop levels\solo\m60\music\m60_music_03)
)

(script dormant m60_music_04
	(sleep_until 
		(or
			(= g_music_m60_04 1)
			(>= (device_get_position stairwell_door) 1)
		)
	)
	(if g_debug (print "start music m60_04"))
	(sound_looping_start levels\solo\m60\music\m60_music_04 NONE 1)

	(sleep_until (= g_music_m60_04 2))
	(if g_debug (print "stop music m60_04"))
	(sound_looping_stop levels\solo\m60\music\m60_music_04)
)
(script dormant m60_music_05
	(sleep_until 
		(or
			(>= interior_obj_control 20)
			(= g_music_m60_05 1)
		)
	)
	(if g_debug (print "start music m60_05"))
	(sound_looping_start levels\solo\m60\music\m60_music_05 NONE 1)

	(sleep_until 
		(or
			(>= security_obj_control 5)
			(= g_music_m60_05 2)
			(>= (device_get_position dm_oni_stairwell_top) 1)			
		)
	)
	(if g_debug (print "stop music m60_05"))
	(sound_looping_stop levels\solo\m60\music\m60_music_05)
)

(script dormant m60_music_06
	(sleep_until 
		(or
			(and
				(< (ai_living_count gr_security_battle) 1)
				(<= (ai_living_count gr_security_boss) 1)
			)
			(= g_music_m60_06 1)
		)
	)
	(if g_debug (print "start music m60_06"))
	(sound_looping_start levels\solo\m60\music\m60_music_06 NONE 1)
;*
	(sleep_until (= g_music_m60_06 2))
	(if g_debug (print "stop music m60_06"))
	(sound_looping_stop levels\solo\m60\music\m60_music_06)
*;
)

(script dormant m60_music_07
	(sleep_until (= g_music_m60_07 1))
	(if g_debug (print "start music m60_07"))
	(sound_looping_start levels\solo\m60\music\m60_music_07 NONE 1)

	(sleep_until (= g_music_m60_07 2))
	(if g_debug (print "stop music m60_07"))
	(sound_looping_stop levels\solo\m60\music\m60_music_07)
)
(script dormant m60_music_08
	(wake m60_music_08_layer)
	(wake m60_music_08_alt)
	(sleep_until (= g_music_m60_08 1))
	(if g_debug (print "start music m60_08"))
	(sound_looping_start levels\solo\m60\music\m60_music_08 NONE 1)

	(sleep_until (= g_music_m60_08 4))
	(if g_debug (print "stop music m60_08"))
	(sound_looping_stop levels\solo\m60\music\m60_music_08)
	(sleep_forever m60_music_08_layer)
	(sleep_forever m60_music_08_alt)
)
(script dormant m60_music_08_layer
	(sleep_until (= g_music_m60_08 2))
	(if g_debug (print "start music_layer m60_08"))
	(sound_looping_activate_layer levels\solo\m60\music\m60_music_08 1)
)
(script dormant m60_music_08_alt
	(sleep_until (= g_music_m60_08 3))
	(sleep 60)
	(if g_debug (print "start music_alt m60_08"))
	(sound_looping_set_alternate levels\solo\m60\music\m60_music_08 TRUE)	
)
(script dormant m60_music_09
	(sleep_until (= g_music_m60_09 1))
	(if g_debug (print "start music m60_09"))
	(sound_looping_start levels\solo\m60\music\m60_music_09 NONE 1)

	(sleep_until (= g_music_m60_09 2))
	(if g_debug (print "stop music m60_09"))
	(sound_looping_stop levels\solo\m60\music\m60_music_09)
)
(script dormant m60_music_10
	(wake m60_music_10_alt)
	(sleep_until (= g_music_m60_10 1))
	(if g_debug (print "start music m60_10"))
	(sound_looping_start levels\solo\m60\music\m60_music_10 NONE 1)

	(sleep_until (= g_music_m60_10 3))
	(if g_debug (print "stop music m60_10"))
	(sound_looping_stop levels\solo\m60\music\m60_music_10)
)
(script dormant m60_music_10_alt
	(sleep_until (= g_music_m60_10 2))
	(sleep 60)
	(if g_debug (print "start music_alt m60_10"))
	(sound_looping_set_alternate levels\solo\m60\music\m60_music_10 TRUE)	
)
(script dormant m60_music_11
	(sleep_until (= g_music_m60_11 1))
	(if g_debug (print "start music m60_11"))
	(sound_looping_start levels\solo\m60\music\m60_music_11 NONE 1)

	(sleep_until (= g_music_m60_11 2))
	(if g_debug (print "stop music m60_11"))
	(sound_looping_stop levels\solo\m60\music\m60_music_11)
)
(script dormant m60_music_12
	(sleep_until (= g_music_m60_12 1))
	(if g_debug (print "start music m60_12"))
	(sound_looping_start levels\solo\m60\music\m60_music_12 NONE 1)

	(sleep_until (= g_music_m60_12 2))
	(if g_debug (print "stop music m60_12"))
	(sound_looping_stop levels\solo\m60\music\m60_music_12)
)
(script dormant m60_music_13
	(sleep_until (= g_music_m60_13 1))
	(if g_debug (print "start music m60_13"))
	(sound_looping_start levels\solo\m60\music\m60_music_13 NONE 1)

	(sleep_until (= g_music_m60_13 2))
	(if g_debug (print "stop music m60_13"))
	(sound_looping_stop levels\solo\m60\music\m60_music_13)
)
(script dormant m60_music_14
	(sleep_until (= g_music_m60_14 1))
	(if g_debug (print "start music m60_14"))
	(sound_looping_start levels\solo\m60\music\m60_music_14 NONE 1)

	(sleep_until (= g_music_m60_14 2))
	(if g_debug (print "stop music m60_14"))
	(sound_looping_stop levels\solo\m60\music\m60_music_14)
)
(script dormant m60_music_15
	(sleep_until (= g_music_m60_15 1))
	(if g_debug (print "start music m60_15"))
	(sound_looping_start levels\solo\m60\music\m60_music_15 NONE 1)

	(sleep_until (= g_music_m60_15 2))
	(if g_debug (print "stop music m60_15"))
	(sound_looping_stop levels\solo\m60\music\m60_music_15)
)
(script dormant kill_music
  (sound_looping_stop levels\solo\m60\music\m60_music_01)
  (sound_looping_stop levels\solo\m60\music\m60_music_02)
  (sound_looping_stop levels\solo\m60\music\m60_music_03)
  (sound_looping_stop levels\solo\m60\music\m60_music_04)
  (sound_looping_stop levels\solo\m60\music\m60_music_05)
  (sound_looping_stop levels\solo\m60\music\m60_music_06)
  (sound_looping_stop levels\solo\m60\music\m60_music_07)
  (sound_looping_stop levels\solo\m60\music\m60_music_08)
  (sound_looping_stop levels\solo\m60\music\m60_music_09)
  (sound_looping_stop levels\solo\m60\music\m60_music_10)
  (sound_looping_stop levels\solo\m60\music\m60_music_11)
  (sound_looping_stop levels\solo\m60\music\m60_music_12)
  (sound_looping_stop levels\solo\m60\music\m60_music_13)
  (sound_looping_stop levels\solo\m60\music\m60_music_14)
  (sound_looping_stop levels\solo\m60\music\m60_music_15)
)

;====================================================================================================================================================================================================
;================================== CINEMATICS ================================================================================================================================================
;====================================================================================================================================================================================================


(script static void m60_cin_intro
	(print "m60 intro cinematic")
	(f_start_mission 060la_returnsword)
)

(script static void m60_cin_mid
	(print "m60 mid cinematic")
	(ai_erase_all)
	(object_create_folder v_mid_cinematic)
	(object_create_folder mid_cinematic_scenery)
	(object_create_folder mid_cinematic_crates)	
	(zone_set_trigger_volume_enable zone_set:cin_tram_ride_prep FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:cin_tram_ride_prep FALSE)
	(sleep 1)	
	(f_play_cinematic_advanced 060lb_tramride cin_tram_ride cin_tram_ride2)
	(camera_control on)
	(object_create fx_screenfx_icecave)
	(object_create glacier_glow) 
	(f_play_cinematic_advanced 060lb_tramride2 cin_tram_ride2 forerunner_ice_cave)
	(set b_is_dialogue_playing false)

)
(script static void m60_elevator_test
	(object_create dm_ice_cave_elevator)
	(device_set_position_immediate dm_ice_cave_elevator 0.15)
	(sleep 30)
	(object_teleport (player0) player0_mid_cin_teleport)
	(object_teleport (player1) player1_mid_cin_teleport)
	(object_teleport (player2) player2_mid_cin_teleport)
	(object_teleport (player3) player3_mid_cin_teleport)
	(object_teleport obj_carter carter_mid_cin_teleport)

	(object_teleport obj_emile emile_mid_cin_teleport)
	(object_teleport obj_jun jun_mid_cin_teleport)
	(sleep 30)
	(device_set_position dm_ice_cave_elevator 1)	
)

(script static void m60_cin_end
	(print "m60 end cinematic")
	(object_create_folder end_cinematic_crates)
	(object_destroy spartan_lazer_case)
	(object_destroy_folder w_ice_cave)
	(ai_erase sq_carter)
	(ai_erase sq_emile)
	(ai_erase sq_jun)		
	(ai_erase gr_ice_cave)
	(object_destroy_type_mask 1039)	
	; special sound call... they want to hear the phantoms and wraiths still shelling the lab
	(if (= v_mode false)
		(f_end_mission_ai 060lc_the_package cin_end_set)
		(f_end_mission 060lc_the_package cin_end_set)
	)
	(game_won)
)

(script static void (end_cinematic_object_removal (ai actor))
	(if 
		(volume_test_object tv_ice_cave_garbage_front actor)
		(object_destroy actor)
	)
)

; ===================================================================================================================================================
; ===================================================================================================================================================
; MISSION DIALOGUE 
; ===================================================================================================================================================
; ===================================================================================================================================================
;*
	(f_hud_training player0 ct_falcon_training_fly)
	(f_hud_training player0 ct_falcon_training_attack)
	(f_hud_training player0 ct_falcon_training_lock)
	(f_hud_training_forever player0 ct_falcon_training_lock)
	(f_hud_training_clear player0)
	(f_hud_training_confirm player0 ct_falcon_training_lock "vehicle_trick")
	(f_hud_training_confirm player0 ct_falcon_training_lock "primary_trigger")
*;

(global ai ai_odst_01 NONE)
(global ai ai_odst_02 NONE)


(script dormant md_010_initial
	(sleep 120)
	(print "CARTER: Six: Covenant own this sector now. But they're defending for a major strike not a small group infiltration.")
		(f_md_object_play 5 none m60_0010)
	(set g_music_m60_02 1)	
	(print "CARTER: Eliminate all hostile ground-to-air defenses so the rest of Noble can land at Sword base for the torch-and-burn.")	
		(f_md_object_play 5 none m60_0020)
	(print "Keep a low profile.  We take 'em by surprise, this'll be a hell of a lot easier.")
		(f_md_object_play 5 none m60_0030)
	(sleep 60)
	(vs_cast sq_initial_troopers FALSE 10 "m60_0040" "m60_0050")
    (set ai_odst_02 (vs_role 1))
    (set ai_odst_01 (vs_role 2))
	(cs_enable_moving ai_odst_02 TRUE)
	(cs_enable_moving ai_odst_01 TRUE)
	(cs_enable_targeting ai_odst_02 TRUE)
	(cs_enable_targeting ai_odst_01 TRUE)	
	(cs_enable_looking ai_odst_02 TRUE)
	(cs_enable_looking ai_odst_01 TRUE)	
	(cs_enable_dialogue ai_odst_02 TRUE)
	(cs_enable_dialogue ai_odst_01 TRUE)	
	(sleep 1)	
	(print "ODST: We'll follow your lead, Spartan.")
		(cs_enable_dialogue ai_odst_02 false)	
		(f_md_ai_play 5 ai_odst_02 m60_0040)	
	(f_hud_obj_new ct_objective_destroy PRIMARY_OBJECTIVE_2)
	(cs_enable_dialogue ai_odst_02 true)	
	(set g_music_m60_01 2)
	(game_save)
	(sleep_until 
		(or
			(volume_test_players tv_intro_water)
			(>= intro_obj_control 10)
		)
	30 600)
	(if
		(and
			(not (volume_test_players tv_intro_water))
			(< intro_obj_control 10)
			(< (ai_combat_status gr_intro) 4)
		)
		(begin
			(sleep_until (= b_is_dialogue_playing false)5)
			(cs_enable_dialogue ai_odst_01 false)		
			(print "ODST: Into the water. Nice and quiet")
				(f_md_ai_play 5 ai_odst_01 m60_0050)
				(cs_enable_dialogue ai_odst_01 true)			
		)
	)
	(sleep_until 
		(or
			(volume_test_players tv_intro_water)
			(>= intro_obj_control 10)
		)
	5)
	(sleep_until (= b_is_dialogue_playing false)5)	
	(if 
		(and
			(volume_test_players tv_intro_water)
			(> (ai_living_count ai_odst_01) 0)
			(< (ai_combat_status gr_intro) 4)
		)
		(begin
			(cs_enable_dialogue ai_odst_01 false)			
			(print "ODST: Falcon down. Watch for bodies")
				(f_md_ai_play 5 ai_odst_01 m60_0060)	
			(cs_enable_dialogue ai_odst_01 true)			
		)
	)

	(sleep_until (<= (ai_living_count gr_intro) 0)5)
	(sleep 90)	
	(if	(> (ai_living_count ai_odst_02) 0)
		(begin
			(sleep_until (= b_is_dialogue_playing false)5)	
			(cs_enable_dialogue ai_odst_02 false)			
			(print "ODST: Structure's clear, Lieutenant.")
				(f_md_ai_play 5 ai_odst_02 m60_0070)
			(cs_enable_dialogue ai_odst_02 true)			
				(set g_music_m60_02 3)
		)
	)
)

(script static void intro_combat_begins
	(set g_music_m60_02 2)
)
(script dormant md_010_spartans
	(sleep_until 
		(and
			(script_finished md_010_initial)	
			(= b_is_dialogue_playing false)
			(>= intro_obj_control 10)
		)
	5)
	
	(if 
		(and 
			(<= (game_coop_player_count) 2)
			(<= motorpool_obj_control 30)
		)
		(begin
			(print "EMILE: Kat was right... Does seem like overkill, sending us back here for a simple demo op.")
				(f_md_object_play 5 none m60_0100)	
		
			(print "JUN: oh-nee thinks it's worth it.  Ought ta tell you something.")
				(f_md_object_play 5 none m60_0110)	
		
			(print "EMILE: Tells me it's not so simple.")
				(f_md_object_play 5 none m60_0120)	
		)
	)
)

(script dormant md_010_reminder
	(branch 		
		(>= motorpool_obj_control 10)	
		(f_md_abort)
	)
	(sleep_until (script_finished md_010_spartans)5)
	(sleep 300)
	(sleep_until (= b_is_dialogue_playing false)5)
	(print "CARTER: There's a motor pool west of your position, other side of the pass.  ")
		(f_md_object_play 5 none m60_0080)	
	(print "CARTER: Commandeer a vehicle.  Get you to the guns faster.")
		(f_md_object_play 5 none m60_0090)
)

(script dormant md_020_motorpool

	(vs_cast sq_initial_troopers FALSE 10 "m60_0140" "m60_0130")
    (set ai_odst_01 (vs_role 1))
    (set ai_odst_02 (vs_role 2))

	(sleep_until (>= motorpool_obj_control 10) 4)
	(sleep_until (= b_is_dialogue_playing false))
	(if	
		(and 
			(> (ai_living_count ai_odst_02) 0)
			(= motorpool_obj_control 10)
		)
		(begin
			(print "ODST: Looks like we got a Scorpion that's still operational, Sir.")
				(f_md_ai_play 5 ai_odst_02 m60_0180)
				;(f_md_ai_play 5 ai_odst_02 m60_0190)						
		)
		(begin
			(print "CARTER: Might be a Scorpion that's still operational, Six. Take a look.")
				(f_md_object_play 5 none m60_0200)
		)
	)	
	(wake md_020_motorpool_reminder)
)

(script dormant md_020_motorpool_reminder
	(branch 		
		(or
			(= g_bfg01_core_destroyed true)
			(= g_bfg02_core_destroyed true)
		)
		(f_md_abort)
	)
	(sleep_until (< (ai_living_count gr_motorpool) 2))

		(if	(> (ai_living_count sq_initial_troopers) 0)
			(begin
				(sleep_until (= b_is_dialogue_playing false)5)
				(print "ODST: Ready to hit that anti-air whenever you are, Lieutenant.")
					(f_md_ai_play 5 ai_odst_02 m60_0210)
			)
			(begin
				(sleep_until (= b_is_dialogue_playing false)5)
				(print "CARTER: Noble Six, proceed west and take out those hostile air defenses.")
					(f_md_object_play 5 none m60_0220)	
			)
		)
	
	(sleep_until (>= motorpool_obj_control 60) 30 600)
	(if (< motorpool_obj_control 60)
		(begin
			(sleep_until (= b_is_dialogue_playing false)5)
			(print "CARTER: Get a move on, Noble Six.  Our Falcons are standing by.")
					(f_md_object_play 5 none m60_0230)
		)	
	)	
)	

(script dormant md_030_supply
	
	(sleep_until (>= supply_obj_control 10)5 3600)

	(if	(> (ai_living_count ai_odst_02) 0)
		(begin
			(sleep_until (= b_is_dialogue_playing false)5)
			(print "ODST: AA guns dead ahead, Lieutenant.")
				(f_md_ai_play 5 ai_odst_02 m60_0250)
		)
	)
	
	(if 		
		(and
			(= g_bfg01_core_destroyed false)
			(= g_bfg02_core_destroyed false)
		)
		(begin
			(sleep_until (= b_is_dialogue_playing false)5)
			(print "CARTER: Time to go to work, Noble Six.  Take out those guns.")
				(f_md_object_play 5 none m60_0260)
			(sleep_until
				(or 
					(= g_bfg01_core_destroyed false)
					(= g_bfg02_core_destroyed false)
				)
			5)
			(wake hud_object_supply)
		)
	)
)


(script dormant hud_object_supply
	; enables the mission objective blip
	(branch
		(and 
			(= g_bfg01_core_destroyed true)
			(= g_bfg02_core_destroyed true)			
		)
		(f_hud_supply_abort)
	)
	(if	(= g_bfg01_core_destroyed false)
	(f_blip_flag gun01_flag 7))
	(sleep 30)
	(if (= g_bfg02_core_destroyed false)	
	(f_blip_flag gun02_flag 8))
	
	(sleep_until 
		(or
			(objects_can_see_flag player0 gun01_flag 20)
			(objects_can_see_flag player1 gun01_flag 20)
			(objects_can_see_flag player2 gun01_flag 20)
			(objects_can_see_flag player3 gun01_flag 20)
			(objects_can_see_flag player0 gun02_flag 20)
			(objects_can_see_flag player1 gun02_flag 20)
			(objects_can_see_flag player2 gun02_flag 20)
			(objects_can_see_flag player3 gun02_flag 20)			
		 )
	5)
	(if 
		(and
			(or
				(> (objects_distance_to_flag player0 gun01_flag) 20)
				(= (objects_distance_to_flag player0 gun01_flag) -1)
			)
			(or
				(> (objects_distance_to_flag player1 gun01_flag) 20)
				(= (objects_distance_to_flag player1 gun01_flag) -1)
			)
			(or
				(> (objects_distance_to_flag player2 gun01_flag) 20)
				(= (objects_distance_to_flag player2 gun01_flag) -1)
			)
			(or
				(> (objects_distance_to_flag player3 gun01_flag) 20)
				(= (objects_distance_to_flag player3 gun01_flag) -1)
			)						
		)
		(begin
			(if (= g_bfg01_core_destroyed false)(f_hud_flash_object sc_bf01_obj))
			(if (= g_bfg02_core_destroyed false)(f_hud_flash_object sc_bf02_obj))
			(if 
				(or
					(= g_bfg01_core_destroyed false)
					(= g_bfg02_core_destroyed false)
				)
				(f_blip_title sc_bfg_box "WP_CALLOUT_M60_BFG")
			)
		)
	)
)

(script static void f_hud_supply_abort
	(print "ABORTED")
	(f_unblip_flag gun01_flag)
	(f_unblip_flag gun02_flag)
	(sleep 5)
	(chud_track_object sc_bfg_box FALSE)
)

(script dormant md_030_supply_reminder
	(branch 		
		(and
			(= g_bfg01_core_destroyed true)
			(= g_bfg02_core_destroyed true)			
		)
		(f_md_abort)
	)
	(sleep_until (>= supply_obj_control 80)5)
	(if	(> (ai_living_count ai_odst_02) 0)
		(begin
			(sleep_until (= b_is_dialogue_playing false)5)
			(print "ODST:Hey -- Spartan, where you going?")
				(f_md_ai_play 5 ai_odst_02 m60_0270)
		)
	)
	
	(sleep 600)
	(sleep_until 
		(and
			(f_no_players_in_volume tv_supply_depot_area)
			(= b_is_dialogue_playing false)
		)
	5)
	(print "CARTER: Get back in there, Six!  I need those AA guns neutralized!")
		(f_md_object_play 5 none m60_0280)

	(sleep 600)
	(sleep_until 
		(and
			(f_no_players_in_volume tv_supply_depot_area)
			(= b_is_dialogue_playing false)
		)
	5)
	(print "CARTER: Take out those guns, Lieutenant!  Our Falcons can't land until they're offline!")
		(f_md_object_play 5 none m60_0290)
)

(script dormant md_030_supply_AA_progress
	(sleep_until 
		(and
			(or 
				(= g_bfg01_core_destroyed true)
				(= g_bfg02_core_destroyed true)				
			)
			(= b_is_dialogue_playing false)
		)5)
	(print "CARTER: First target neutralized. Falcon group, stand by")
		(f_md_object_play 5 none m60_0300)		
	
	(sleep_until 
		(and
			(and 
				(= g_bfg01_core_destroyed true)
				(= g_bfg02_core_destroyed true)				
			)
			(= b_is_dialogue_playing false)
		)5)
	(print "CARTER: Nice job, Six.  Falcons: commence descent.  Meet you inside the base, Lieutenant.")
		(f_md_object_play 5 none m60_0310)
			


	(sleep 60)
	(if	(> (ai_living_count ai_odst_02) 0)
		(begin
			(sleep_until (= b_is_dialogue_playing false)5)
			(print "ODST:Let's give 'em hell, Spartan!")
				(f_md_ai_play 5 ai_odst_02 m60_0320)			
			(print "ODST:They sure gave it to Reach")
				(f_md_ai_play 5 ai_odst_01 m60_0330)
		)
	)
)

(script dormant md_050_gate
	(sleep_until 
		(and
			(= b_spartans_land TRUE)
			(= b_is_dialogue_playing false)
		)
	5)
			
	(print "CARTER: Noble team: Falcon group has landed; hostiles engaged.  Jun is working on getting the gate open.")
		(f_md_object_play 5 none m60_0340)
	(if	(<= (game_coop_player_count) 2)
		(begin		
			(print "JUN: Really missing Kat right about now...")
				(f_md_object_play 5 none m60_0350)
		)
	)		

	(sleep_until 
		(and 
			(= (device_get_position oni_front_gate) 1)
			(= b_is_dialogue_playing false)
		)
	)
	(if	(<= (game_coop_player_count) 2)
		(begin		
			(print "JUN: Got it!  Gate's open, boss!")
				(f_md_object_play 5 none m60_0360)
		)
	)
	(print "CARTER: Six, get over here -- Coveys all over the base!")
		(f_md_object_play 5 none m60_0370)	

	(f_hud_obj_new ct_objective_sword PRIMARY_OBJECTIVE_4)
	(set g_music_m60_03 2)

	(sleep_until (>= gate_obj_control 50)30 900)

	(sleep_until (= b_is_dialogue_playing false))
	(if (<= (game_coop_player_count) 2)
		(begin	
			(print "EMILE: Tangos!  Coming from the pad!")
				(f_md_object_play 5 none m60_0380)	
			(print "JUN: And the garage!")
				(f_md_object_play 5 none m60_0390)
		)
	)							
			(print "CARTER: Double-time it, Six!  Come on!")
		(f_md_object_play 5 none m60_0400)
	(if (< gate_obj_control 50)(f_blip_flag front_gate_flag 21))			

	(branch 		
		(>= assault_obj_control 20)
		(f_md_abort)
	)

	(sleep 900)	
	(sleep_until (= b_is_dialogue_playing false))	
	(print "CARTER: Anytime, Noble Six! Get inside the base!")
		(f_md_object_play 5 none m60_0410)
			
)

(script dormant md_070_assault
	(sleep_until (>= assault_obj_control 20)5)
	(sleep_until (= b_is_dialogue_playing false))
	(if (<= (game_coop_player_count) 2)
		(begin			
			(if (> (ai_living_count sq_emile) 0)
				(begin
					(print "EMILE: Just in time, Six!")
						(f_md_ai_play 5 sq_emile m60_0420)
				)
				(begin
					(print "EMILE: Just in time, Six!")
						(f_md_object_play 5 none m60_0420)
				)		
			)
		)
	)
	(if (> (ai_living_count sq_carter) 0)
		(begin	
			(print "CARTER: Kill 'em all, Noble!")
				(f_md_ai_play 5 sq_carter m60_0430)
		)
		(begin	
			(print "CARTER: Kill 'em all, Noble!")
				(f_md_object_play 5 none m60_0430)
		)		
	)
	(set b_is_dialogue_playing false)					
)


(script dormant md_080_security
	(sleep 60)
	(sleep_until (>= security_obj_control 20)5)	
	;(sleep_until (= b_is_dialogue_playing false))		
	(print "JUN: Where we going now, boss?")
		(f_md_ai_play 5 sq_jun m60_0440)
	(print "CARTER: Dot?")
		(f_md_ai_play 5 sq_carter m60_0450)
	(print "DOT: Please proceed to the pre-arranged coordinates..")
		(f_md_object_play 5 none m60_0460)

	(f_blip_flag cf_sword_base_objective 21)
	(if (<= (game_coop_player_count) 2)
		(begin			
			(print "EMILE: Cryptic...")
				(f_md_ai_play 5 sq_emile m60_0470)
			(print "DOT: You know as much as I do, Noble Four.")
				(f_md_object_play 5 none m60_0480)
		)
	)

	(f_hud_obj_new ct_objective_halsey PRIMARY_OBJECTIVE_5)	
	(set g_music_m60_04 2)
  (game_save)
	(sleep_until (>= (device_get_position dm_oni_interior) 1)5)
	(sleep_until 
		(and
			(= b_is_dialogue_playing false)	
			(>= security_obj_control 30)
		)5)
	(print "DOT: Coordinates nearby, Commander.")
		(f_md_object_play 5 none m60_0550)

	(print "CARTER: We're close!  Up the ramp and to the right!")
		(f_md_ai_play 5 sq_carter m60_0560)
	
	(sleep_until 
		(and
			(= b_is_dialogue_playing false)	
			(= security_obj_control 70)
		)
	5)
	(print "CARTER: This is it.  In here!")
		(f_md_ai_play 5 sq_carter m60_0570)
)
(script dormant md_100_ice_cave_initial
	(sleep_until (= b_is_dialogue_playing false))
	(print "CARTER: Let's find Halsey's lab.  Move!")
		(f_md_ai_play 5 sq_carter m60_0580)
	(sleep_until (>= ice_cave_obj_control 10)5)
	(if (<= (game_coop_player_count) 2)
		(begin
			(print "JUN: Commander, I'm seeing turrets already in defensive positions.")
				(f_md_ai_play 5 sq_jun m60_0610)
				
			(print "EMILE: ONI was expecting company.")
				(f_md_ai_play 5 sq_emile m60_0620)
			
			(sleep 30)
			(print "CARTER: Well, they sure as hell got it... Doctor, we have hostiles inbound NOW.")
				(f_md_ai_play 5 sq_carter m60_0630)
		)	
	)	
	(print "HALSEY: Spartans, you cannot allow the Covenant to break through the door to my lab!")
		(f_md_object_play 5 none m60_0640)
		(wake hud_object_halseys_lab)
			
	(print "CARTER: Understood.")
		(f_md_ai_play 5 sq_carter m60_0650)	
		
	(sleep 30)
		
	(print "CARTER: Let's give the doctor the time she needs.")
		(f_md_ai_play 5 sq_carter m60_0710)
		(set g_music_m60_07 1)
	(sleep 30)
	(wake md_110_ice_cave_start)
	; enables the mission objective blip
	(sleep 150)
	(if (not (volume_test_players tv_ice_cave_start))
	(f_blip_flag nav_halsey_front 21))
				
	(sleep_until (volume_test_players tv_ice_cave_start) 5)
	(f_unblip_flag nav_halsey_front)			
				
)

(script dormant hud_object_halseys_lab


	(f_hud_obj_new ct_objective_defend PRIMARY_OBJECTIVE_6)
	
	(sleep_until 
		(or
			(objects_can_see_flag player0 nav_halsey_lab 20)
			(objects_can_see_flag player1 nav_halsey_lab 20)
			(objects_can_see_flag player2 nav_halsey_lab 20)
			(objects_can_see_flag player3 nav_halsey_lab 20)
		 )
	5)
	(if 
		(and
			(or
				(> (objects_distance_to_flag player0 nav_halsey_lab) 20)
				(= (objects_distance_to_flag player0 nav_halsey_lab) -1)
			)
			(or
				(> (objects_distance_to_flag player1 nav_halsey_lab) 20)
				(= (objects_distance_to_flag player1 nav_halsey_lab) -1)
			)
			(or
				(> (objects_distance_to_flag player2 nav_halsey_lab) 20)
				(= (objects_distance_to_flag player2 nav_halsey_lab) -1)
			)
			(or
				(> (objects_distance_to_flag player3 nav_halsey_lab) 20)
				(= (objects_distance_to_flag player3 nav_halsey_lab) -1)
			)						
		)
		(begin
			(f_hud_flash_object sc_halsey_lab_obj)
			(f_blip_title sc_halsey_box "WP_CALLOUT_M60_LAB")
		)
	)
)

(script dormant md_110_ice_cave_start
	(sleep_until (>= ice_cave_obj_control 30)5)
	(sleep_until (= b_is_dialogue_playing false))		
	(print "SWORD CONTROL: Noble Team, there are four defense turrets to assist you in defending the lab, get them online- and quick!")
		(f_md_object_play 5 none m60_0845)
		(wake blip_turrets)
	(sleep_until (= b_is_dialogue_playing false))	
	(print "SWORD CONTROL: When the turrets take too much damage they’ll shut down to recharge. You’ll need to re-activate them when they come back online.")
		(f_md_object_play 5 none m60_0847)
	(print "CARTER: Noble Six, activate the turret to set up a perimeter.")
		(f_md_ai_play 5 sq_carter m60_0720)
		(set g_music_m60_07 2)		
)

(script dormant md_110_ice_cave_center
	(sleep_until (= b_dropship02_unload true)5)
	(sleep_until (= b_is_dialogue_playing false))		
	(print "CARTER: They’re landing out of range, across the bridge!")
		(f_md_ai_play 5 sq_carter m60_0880)
	(if (= g_music_m60_08 0)(set g_music_m60_08 1))	
)
(script dormant md_110_ice_cave_wraith
	;(sleep_until (= b_dropship02_unload true)5)
	(sleep_until (= b_is_dialogue_playing false))	
	(if (<= (game_coop_player_count) 2)
		(begin
			(sleep_until (= b_is_dialogue_playing false))				
			(print "EMILE: Watch out for the Wraith!")
				(f_md_ai_play 5 sq_emile m60_0900)
		)
	)
	(if (<= g_music_m60_08 2)(set g_music_m60_08 3))		
)

(script dormant md_110_ice_cave_sides
	(sleep_until 
		(or
			(>= phantom04_progress 2)
			(>= phantom06_progress 2)
			(= b_dropship04_unload true)
			(= b_dropship06_unload true)
			)
	5)
	(sleep_until (= b_is_dialogue_playing false))	
	(print "CARTER: Another Phantom, dropping troops to flank us!")
		(f_md_ai_play 5 sq_carter m60_0890)
	(set g_music_m60_10 1)		
	(if (<= (game_coop_player_count) 2)
		(begin
			(sleep_until (= b_is_dialogue_playing false))				
			(print "JUN: Maybe we can grab a banshee and bring the fight to them!")
				(f_md_ai_play 5 sq_jun m60_0910)
		)
	)	
)
(script dormant md_110_ice_cave_front
	(sleep_until (= b_is_dialogue_playing false))	
	(print "CARTER: More Covenant! Get your defenses ready, Six!")
		(f_md_ai_play 5 sq_carter m60_0920)	
	(set g_music_m60_12 2)
	(set g_music_m60_13 1)				
)

(global short g_ice_cave_dialog 0)

(script dormant md_120_ice_cave_mid
	(sleep_until 
		(and
			(= b_is_dialogue_playing false)	
			(>= g_ice_cave_dialog 1)
		)5)
		(if (= g_ice_cave_dialog 1)
			(begin
				(print "HALSEY: I need more time.  Whatever you have to do, do it...")
				(f_md_object_play 5 none m60_0760)
				(if (= g_music_m60_08 1)(set g_music_m60_08 2))
			)
		)
	
	(sleep_until 
		(and
			(= b_is_dialogue_playing false)	
			(>= g_ice_cave_dialog 2)
		)5)
		(if (= g_ice_cave_dialog 2)
			(begin
				(set g_music_m60_09 1)					
				(print "HALSEY: Hold on, Spartans.  I'm getting close...")
					(f_md_object_play 5 none m60_0770)
			)
		)
	(sleep_until 
		(and
			(= b_is_dialogue_playing false)	
			(= g_ice_cave_dialog 3)
		)5)
		(if (= g_ice_cave_dialog 3)
			(begin
				(set g_music_m60_12 1)			
				(print "HALSEY: The package is almost ready -- just a little more…")
					(f_md_object_play 5 none m60_0780)
			)
		)
)

(script dormant md_130_ice_cave_end
	(sleep_until (= g_ice_wave 5))
	(sleep_until (= b_is_dialogue_playing false))
	(sleep 90)		
	(print "HALSEY: I'm opening the door to the lab, Noble Six.  The package should be ready by the time you get inside.")
		(f_md_object_play 5 none m60_0800)

	(f_hud_obj_new ct_objective_enter PRIMARY_OBJECTIVE_7)
	(device_set_power dc_halsey_lab 1)
	(sleep 150)
	(sleep_until (= b_is_dialogue_playing false))		
	(print "CARTER: Door's open, Noble Six. Head into the lab.")
	(f_md_ai_play 5 sq_carter m60_0810)
	(f_unblip_flag nav_halsey_lab)	
	(f_blip_object dc_halsey_lab 3)	
	(sleep 900)
	(sleep_until (= b_is_dialogue_playing false))		
	(print "CARTER: Lieutenant!  Get into Halsey's lab! That's an order!")
	(f_md_ai_play 5 sq_carter m60_0820)	
		
)

(script static void md_140_turret_offline
	(if (= b_is_dialogue_playing false)
		(begin_random_count 1
			(f_md_object_play 5 none m60_0871)
			(f_md_object_play 5 none m60_0872)
			(f_md_object_play 5 none m60_0873)
		)
	)
)
(script static void md_140_turret_online
	(if (= b_is_dialogue_playing false)
		(begin_random_count 1
			(f_md_object_play 5 none m60_0875)
			(f_md_object_play 5 none m60_0876)
			(f_md_object_play 5 none m60_0877)
		)
	)
)

(script static boolean (f_no_players_in_volume (trigger_volume vol))
	(if
		(and
			(not (volume_test_objects vol (player0)))
			(not (volume_test_objects vol (player1)))
			(not (volume_test_objects vol (player2)))
			(not (volume_test_objects vol (player3)))
		)
	true)
)

(script static void thespian_dialog
	(set b_is_dialogue_playing TRUE)
	(print "PLAYING A LINE OF DIALOG")
	(sleep s_md_play_time)
	(set b_is_dialogue_playing FALSE)
)


(script dormant title_start
	(f_hud_chapter ct_start)
)

(script dormant title_courtyard
	(f_hud_chapter ct_courtyard)
)

(script dormant title_ice_cave
	(f_hud_chapter ct_ice_cave)
)