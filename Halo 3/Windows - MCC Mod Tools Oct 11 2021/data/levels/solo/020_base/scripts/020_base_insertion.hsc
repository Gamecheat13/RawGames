;=========================================================================================
;================================ GLOBAL VARIABLES =======================================
;=========================================================================================
(global short g_set_all 17)

;=========================================================================================
;================================== COMMAND CENTER START =========================================
;=========================================================================================
(script static void ins_command_center_start
	
	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 020_06_00_cinematic)
			(sleep 1)
		)
	)
	
	; wake opening cinematic 
	(wake cin_base_insertion)
	(sleep_until (script_finished cin_base_insertion) 1)

	; set insertion point index 
	(set g_insertion_index 1)
)

;=========================================================================================
;================================== HIGHWAY A ==========================================
;=========================================================================================
(script static void ins_highway_a
	
	; set insertion point index 
	(set g_insertion_index 3)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 020_00_01_encounter)
			(sleep 1)
		)
	)

	
	; teleporting players... to the proper location 
	(if debug (print "teleporting players to highway..."))
	(object_teleport (player0) highway_player0)
	(object_teleport (player1) highway_player1)
	(object_teleport (player2) highway_player2)
	(object_teleport (player3) highway_player3)
	
	(sleep 1)
	
	; placing allies...	
;	(if debug (print "placing allies..."))
;	(ai_place sq_jw_johnson_marines)
;	(ai_place sq_jw_marines)
;	(ai_place sq_jw_arbiter)
;	(sleep 1)
)

;=========================================================================================
;================================== HANGAR A ==========================================
;=========================================================================================
(script static void ins_hangar_a
	
	; set insertion point index 
	(set g_insertion_index 4)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 020_01_03_encounter)
			(sleep 1)
		)
	)

	
	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) hangar_a_player0)
	(object_teleport (player1) hangar_a_player1)
	(object_teleport (player2) hangar_a_player2)
	(object_teleport (player3) hangar_a_player3)

	; placing allies... 
;	(if debug (print "placing allies..."))
;	(ai_place sq_jw_johnson_marines)
;	(ai_place sq_jw_marines)
;	(ai_place sq_jw_arbiter)
;	(sleep 1)
)

;=========================================================================================
;=================================== LOOP01 RETURN ==========================================
;=========================================================================================
(script static void ins_loop01_return
	
	; set insertion point index 
	(set g_insertion_index 5)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 020_00_01_return)
			(sleep 1)
		)
	)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) loop01_return_player0)
	(object_teleport (player1) loop01_return_player1)
	(object_teleport (player2) loop01_return_player2)
	(object_teleport (player3) loop01_return_player3)
	(sleep 1)
	
	; placing allies... 
;	(if debug (print "placing allies..."))
;	(ai_place sq_gc_arbiter)
;	(ai_place sq_gc_marines)
;	(sleep 1)
)

;=========================================================================================
;=================================== LOOP02 BEGIN ========================================
;=========================================================================================
(script static void ins_loop02_begin

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 020_00_04_05_encounter)
			(sleep 1)
		)
	)

	; add player equipment 
	(unit_add_equipment (player0) chief_insertion TRUE TRUE)
	(unit_add_equipment (player1) elite_insertion TRUE TRUE)
	(unit_add_equipment (player2) elite_insertion TRUE TRUE)
	(unit_add_equipment (player3) elite_insertion TRUE TRUE)
	(sleep 1)

	; start insertion 
	(insertion_start)
	
	; wake music script 
	(wake 020_music_065)
	
	; start music 
	(set g_music_020_065 TRUE)

	; set insertion point index 
	(set g_insertion_index 6)

		; teleporting players... to the proper location 
		(object_teleport (player0) loop02_begin_player0)
		(object_teleport (player1) loop02_begin_player1)
		(object_teleport (player2) loop02_begin_player2)
		(object_teleport (player3) loop02_begin_player3)
		(sleep 1)

		; set player pitch 
		(player0_set_pitch -10 0)
		(player1_set_pitch -10 0)
		(player2_set_pitch -10 0)
		(player3_set_pitch -10 0)

	; set door power / position 
	(device_set_power command_door_init 0)
	(device_set_position cave_a_door_command 0)
	
	; wake fade in script 
	(wake ins_loop02_begin_fade_in)
)

(script dormant ins_loop02_begin_fade_in
	; fade in 
	(sleep 60)
	(fade_in 0 0 0 15)
)
;=========================================================================================
;=================================== MOTORPOOL =========================================
;=========================================================================================
(script static void ins_motorpool

	; set insertion point index 
	(set g_insertion_index 7)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 020_00_04_05_encounter)
			(sleep 1)
		)
	)

		
	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) motor_pool_player0)
	(object_teleport (player1) motor_pool_player1)
	(object_teleport (player2) motor_pool_player2)
	(object_teleport (player3) motor_pool_player3)
	(sleep 1)
	(unit_add_equipment (player0) chief_insertion TRUE TRUE)
	(unit_add_equipment (player1) elite_insertion TRUE TRUE)
	(unit_add_equipment (player2) elite_insertion TRUE TRUE)
	(unit_add_equipment (player3) elite_insertion TRUE TRUE)		
)

;=========================================================================================
;===================================== SEWERS ============================================
;=========================================================================================
(script static void ins_sewers

	; set insertion point index 
	(set g_insertion_index 8)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 020_00_04_05_encounter)
			(sleep 1)
		)
	)

		
	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) sewer_player0)
	(object_teleport (player1) sewer_player1)
	(object_teleport (player2) sewer_player2)
	(object_teleport (player3) sewer_player3)
	(sleep 1)
	
	; placing allies... 
;	(if debug (print "placing allies..."))
;	(ai_place sq_pb_arbiter)
;	(ai_place sq_pb_marines)
;	(sleep 1)
)

;=========================================================================================
;================================== BARRACKS =========================================
;=========================================================================================
(script static void ins_barracks

	; set insertion point index 
	(set g_insertion_index 9)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 020_05_06_07_encounter)
			(sleep 1)
		)
	)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_create_folder crates_barracks_folder)
	
	(object_teleport (player0) barracks_player0)
	(object_teleport (player1) barracks_player1)
	(object_teleport (player2) barracks_player2)
	(object_teleport (player3) barracks_player3)
	(sleep 1)
	(ai_place 020_arbiter)
	(set obj_arbiter (ai_get_object 020_arbiter/actor01))
	
	(ai_set_objective 020_arbiter evac_hangar_hum_obj)
	
	; placing allies... 
;	(if debug (print "placing allies..."))
;	(ai_place sq_ba_arbiter)
;	(ai_place sq_ba_marines)
;	(sleep 1)
)

;=========================================================================================
;====================================== EVAC HANGAR ==============================================
;=========================================================================================
(script static void ins_evac_hangar
	; set insertion point index 
	(set g_insertion_index 10)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 020_05_06_07_encounter)
			(sleep 1)
		)
	)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) evac_hangar_player0)
	(object_teleport (player1) evac_hangar_player1)
	(object_teleport (player2) evac_hangar_player2)
	(object_teleport (player3) evac_hangar_player3)
	(sleep 1)
	(ai_place evac_hangar_marine01)
	(ai_place evac_hangar_marine02)
	(ai_place evac_hangar_marine03)
	(ai_place evac_hangar_marine04)
	(ai_place evac_hangar_marine05)
	(ai_place evac_hangar_marine06)
	(ai_place evac_hangar_marine07)
	(ai_place evac_arbiter)
	(set obj_arbiter (ai_get_object evac_arbiter/actor01))
	
	(wake Evac02_Elevator_Activate)		


)

;=========================================================================================
;====================================== CORTANA MOMENT / ENCOUNTER =======================
;=========================================================================================

(script static void ins_cortana_highway


	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 020_06_08_04_encounter)
			(sleep 1)
		)
	)
	
	; add player equipment 
	(unit_add_equipment (player0) chief_insertion TRUE TRUE)
	(unit_add_equipment (player1) elite_insertion TRUE TRUE)
	(unit_add_equipment (player2) elite_insertion TRUE TRUE)
	(unit_add_equipment (player3) elite_insertion TRUE TRUE)
	(sleep 1)

	; start insertion 
	(insertion_start)
	
	; turn OFF all object sounds 
	(sound_class_set_gain "object" 0 0)
	(sound_class_set_gain "vehicle" 0 0)

	; wake music script 
	(wake 020_music_114)
	
	; start music 
	(set g_music_020_114 TRUE)

	; set insertion point index 
	(set g_insertion_index 11)
	
		; teleporting players... to the proper location 
		(object_teleport (player0) cortana_player0)
		(object_teleport (player1) cortana_player1)
		(object_teleport (player2) cortana_player2)
		(object_teleport (player3) cortana_player3)
		
	; finish objectives 
	(objectives_finish_up_to 4)
	(wake obj_self_destruct_set_ins)

		; set player pitch 
		(player0_set_pitch -15 0)
		(player1_set_pitch -15 0)
		(player2_set_pitch -15 0)
		(player3_set_pitch -15 0)

	; fade in 
	(sleep 45)
	(fade_in 0 0 0 15)

	; turn ON all object sounds 
	(sound_class_set_gain "object" 1 30)
	(sound_class_set_gain "vehicle" 1 30)
)

;====================================== SELF DESTRUCT ==============================================
;=========================================================================================
(script static void ins_self_destruct

	; set insertion point index 
	(set g_insertion_index 13)

	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 020_00_04_08_encounter)
			(sleep 1)
		)
	)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) Self_Destruct_player0)
	(object_teleport (player1) Self_Destruct_player1)
	(object_teleport (player2) Self_Destruct_player2)
	(object_teleport (player3) Self_Destruct_player3)
	(sleep 1)
)

;====================================== CAVE A RETURN ==============================================
;=========================================================================================
(script static void ins_exit_run

	; set insertion point index 
	(set g_insertion_index 14)


	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 020_00_01_exit_encounter)
			(sleep 1)
		)
	)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) exit_run_player0)
	(object_teleport (player1) exit_run_player1)
	(object_teleport (player2) exit_run_player2)
	(object_teleport (player3) exit_run_player3)
	; other scripts from previous encounter
	(sleep 1)
	(wake destruct_bomb_navpoint_deactive)
	(wake rumble_event_strong_loop)
	(sleep_forever md_10_self_destruct_joh)
	(device_set_power sec_light01 1)
	(device_group_change_only_once_more_set 020_01_g3 TRUE)
	(device_set_power loop02_begin_switch 0)				
	(device_set_position loop02_begin_door 0)
	(sleep_until (= (device_get_position loop02_begin_door) 0)5)
	(zone_set_trigger_volume_enable begin_zone_set:020_00_01_exit_encounter true)
	(zone_set_trigger_volume_enable zone_set:020_00_01_exit_encounter true)		
	(game_save)
	(wake br_10_command_objective)
	(wake obj_self_destruct_clear)
	(wake obj_exit_set)	
	(sleep_until (or (volume_test_players cave_a_start_trig)(= briefing_play FALSE))5)
	(ai_place self_destruct_cov04)		
	(device_set_position cave_a_door_command 1)
	(wake self_destruct_navpoint_active)
	(wake self_destruct_navpoint_deactive)	
	
)

;====================================== HANGAR A RETURN ==============================================
;=========================================================================================
(script static void ins_hangar_a_return

	; set insertion point index 
	(set g_insertion_index 15)


	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set 020_01_03_exit_encounter)
			(sleep 1)
		)
	)

	; teleporting players... to the proper location 
	(if debug (print "teleporting players..."))
	(object_teleport (player0) hangar_a_return_player0)
	(object_teleport (player1) hangar_a_return_player1)
	(object_teleport (player2) hangar_a_return_player2)
	(object_teleport (player3) hangar_a_return_player3)
	(sleep 1)

	(device_set_position hangar_a_exit_door 1)
	
)

;*
=========================================================================================
================================== COMMENTS AND JUNK ====================================
=========================================================================================


Objects per frame		characters	vehicles	weapons	scenery	crates/garbage/items 
						28			12		30		50		60 



*;

