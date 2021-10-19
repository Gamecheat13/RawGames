;=========================================================================================
;================================ GLOBAL VARIABLES =======================================
;=========================================================================================

;=========================================================================================
;====================================== START ============================================
;=========================================================================================


;=========================================================================================
;================================== INTRO ================================================
;=========================================================================================
(script static void ins_intro
	(print "insertion point : intro")
	(cinematic_snap_to_black)
	
	(print "switching zone sets...")
	(switch_zone_set intro)
	(sleep 1)
	
	; set insertion point index 
	(set g_insertion_index 1)
	
	; unhide the players 
	(object_hide (player0) FALSE)
	(object_hide (player1) FALSE)
	(object_hide (player2) FALSE)
	(object_hide (player3) FALSE)
)

;=========================================================================================
;================================== SCARAB ===============================================
;=========================================================================================
(script static void ins_scarab
	(print "insertion point : scarab")
	
	; switch to correct zone set
	(switch_zone_set scarab)
	(sleep 1)
	
	; add player equipment 
	(unit_add_equipment (player0) chief_insertion TRUE TRUE)
	(unit_add_equipment (player1) elite_insertion TRUE TRUE)
	(unit_add_equipment (player2) elite_insertion TRUE TRUE)
	(unit_add_equipment (player3) elite_insertion TRUE TRUE)
	(sleep 1)

	(insertion_start)
	
	; set insertion point index 
	(set g_insertion_index 6)

	; place objects
	(object_create_folder scenery_lab)
	(object_create_folder crates_lab)
	
	(flock_start "lake_b_hornets")
	(flock_start "lake_b_phantoms")
	(flock_start "lake_b_bashee_excort01")
	(flock_start "lake_b_bashee_excort02")
	
	(sound_class_set_gain "" 1 0)
	(wake sc_bridge_cruiser)
	(wake objective_2_clear)
	(wake lakeb_BFG_go)
	(device_set_position_immediate lakebed_b_entry_door 0)
	(wake crane_ctrl)
	(device_set_power lakebed_b_exit 1)
	(device_set_position lakebed_b_exit 1)
	(sleep 1)
	
	; teleport players to the proper location 
	(print "teleport players")
	(object_teleport (player0) teleport_scarab_player0)
	(object_teleport (player1) teleport_scarab_player1)
	(object_teleport (player2) teleport_scarab_player2)
	(object_teleport (player3) teleport_scarab_player3)
	(sleep 1)
	(player_disable_movement FALSE)
	
	; unhide the players 
	(object_hide (player0) FALSE)
	(object_hide (player1) FALSE)
	(object_hide (player2) FALSE)
	(object_hide (player3) FALSE)
	
		; set player pitch 
		(player0_set_pitch 5 0)
		(player1_set_pitch 5 0)
		(player2_set_pitch 5 0)
		(player3_set_pitch 5 0)

	; placing allies
	(ai_place lake_b_def_turrets)
	(ai_place test_lake_b_allies)
	(wake lake_b_hornet_control)
	
	; wake chapter title 
	(wake 040_title2_insert)
	
	;music
	(wake music_040_07)
	(set g_music_040_07 TRUE)

	; fade in 
	(sleep 45)
	(fade_in 0 0 0 15)
)