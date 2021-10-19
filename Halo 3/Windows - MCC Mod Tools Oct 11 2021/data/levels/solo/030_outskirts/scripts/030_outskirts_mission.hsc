;==============================================================
;==========Global Variables====================================
;==============================================================
(global boolean b_debug TRUE)
(global boolean player_on_foot 0)
(global boolean debug FALSE)

;insertion point index
(global short s_insertion_index 0)

; objective control global shorts
(global short s_elevator_obj_control 0)
(global short s_cavern_obj_control 0)
(global short s_drive_obj_control 0)
(global short s_pond_obj_control 0)
(global short s_crash_obj_control 0)
(global short s_bridge_obj_control 0)
(global short s_garage_obj_control 0)
(global short s_tether_obj_control 0)
(global short s_round_obj_control 0)
(global short s_exit_obj_control 0)
(global boolean b_closed_task 0)

(global boolean b_warthog1_has_crossed_gap FALSE)
(global boolean b_warthog2_has_crossed_gap FALSE)
(global boolean b_warthog3_has_crossed_gap FALSE)
(global boolean b_warthog4_has_crossed_gap FALSE)
(global boolean b_warthog5_has_crossed_gap FALSE)
(global boolean b_warthog6_has_crossed_gap FALSE)
(global boolean b_chopper1_has_crossed_gap FALSE)
(global boolean b_chopper2_has_crossed_gap FALSE)
(global short s_vehicles_across_gap 0)

;==============================================================
;==========Global Scripts======================================
;==============================================================

(global short g_zone_index 0)
(global short s_global_stragglers 0)

(script continuous gs_global_player_in_vehicle
	(sleep_until
		(begin
			(if
				(or
					(and
						(= (game_coop_player_count) 1)
						(= (unit_in_vehicle (player0)) TRUE)
					)
					(and
						(= (game_coop_player_count) 2)
						(and
							(= (unit_in_vehicle (player0)) TRUE)
							(= (unit_in_vehicle (player1)) TRUE)
						)
					)
					(and
						(= (game_coop_player_count) 3)
						(and
							(= (unit_in_vehicle (player0)) TRUE)
							(= (unit_in_vehicle (player1)) TRUE)
							(= (unit_in_vehicle (player2)) TRUE)
						)
					)
					(and
						(= (game_coop_player_count) 4)
						(and
							(= (unit_in_vehicle (player0)) TRUE)
							(= (unit_in_vehicle (player1)) TRUE)
							(= (unit_in_vehicle (player2)) TRUE)
							(= (unit_in_vehicle (player3)) TRUE)
						)
					)
				)
				(set player_on_foot 0)
				(set player_on_foot 1)
			)
		0)
	)
)

;script to get guys in vehicles
(script dormant gs_get_in_vehicles
	(sleep_until
		(begin
			(ai_enter_squad_vehicles sg_all_allies)
		0)
	900)
)

;disposable AI
(script dormant gs_disposable_ai
	(sleep_until (> s_cavern_obj_control 4))
		;(if b_debug (print "**elevator disposable"))
		
		(ai_erase_inactive sg_all_allies 0)
		(ai_erase_inactive sg_elev_hurt 0)
		
	(sleep_until (> s_drive_obj_control 3))
		;(if b_debug (print "**cavern disposable"))
		
		(ai_erase_inactive sg_all_allies 0)
		(ai_erase_inactive sg_elev_hurt 0)
	
	(sleep_until (> s_pond_obj_control 3))
		;(if b_debug (print "**drive disposable"))
		
		(ai_disposable sg_drive_cov TRUE)
		(ai_erase_inactive sg_all_allies 0)
	
	(sleep_until (> s_crash_obj_control 1))
		;(if b_debug (print "**pond disposable"))
		
		(ai_disposable sg_pond_cov TRUE)
		(ai_erase_inactive sg_all_allies 0)

	(sleep_until (> s_bridge_obj_control 4))
		;(if b_debug (print "**crash disposable"))
		
		(ai_disposable sg_crash_cov TRUE)
		(ai_erase_inactive sg_all_allies 0)

	(sleep_until (> s_garage_obj_control 2))
		;(if b_debug (print "**bridge disposable"))
		
		(ai_disposable sg_bridge_cov TRUE)
		(ai_erase_inactive sg_all_allies 0)

	(sleep_until (> s_tether_obj_control 1))
		;(if b_debug (print "**garage disposable"))
		
		(ai_disposable sg_garage_cov TRUE)
		(ai_erase_inactive sg_all_allies 0)
	
	(sleep_until (> s_round_obj_control 1))
		;(if b_debug (print "**tether disposable"))
		
		(ai_disposable sg_tether_cov TRUE)
		(ai_disposable sg_tether_ghosts TRUE)
		(ai_erase_inactive sg_all_allies 0)
	
	(sleep_until (> s_exit_obj_control 2))
		;(if b_debug (print "**round disposable"))
		
		(ai_disposable sg_round_cov TRUE)
		(ai_erase_inactive sg_all_allies 0)
		
	
)
	
;garbage collection
(script dormant gs_recycle_volumes
; === This needs fixing with better collision volumes
	(sleep_until (> s_cavern_obj_control 0))	
		;(if b_debug (print "**elevator recycled"))
		
		(add_recycling_volume tv_gc_bsp000 30 30)
	
	(sleep_until (> s_drive_obj_control 0))
		;(if b_debug (print "**cavern recycled"))
		
		(add_recycling_volume tv_gc_bsp000 0 30)
		(add_recycling_volume tv_gc_bsp010 30 30)
 
	(sleep_until (> s_pond_obj_control 0))
		;(if b_debug (print "**drive recycled"))
		
		(add_recycling_volume tv_gc_bsp010 0 30)
		(add_recycling_volume tv_gc_bsp020 30 30)

	(sleep_until (> s_crash_obj_control 0))
		;(if b_debug (print "**pond recycled"))
		
		(add_recycling_volume tv_gc_bsp020 0 30)
		(add_recycling_volume tv_gc_bsp030 30 30)

	(sleep_until (> s_bridge_obj_control 3))
		;(if b_debug (print "**crash recycled"))
		
		(add_recycling_volume tv_gc_bsp030 0 30)
		(add_recycling_volume tv_gc_bsp030b 30 30)

	(sleep_until (> s_bridge_obj_control 5))
		;(if b_debug (print "**crash recycled"))
		
		(add_recycling_volume tv_gc_bsp030 0 0)
		(add_recycling_volume tv_gc_bsp030b 0 0)

	(sleep_until (>= s_round_obj_control 2))
		;(if b_debug (print "**garage recycled"))
		
		(add_recycling_volume tv_gc_bsp030b 0 30)
		(add_recycling_volume tv_gc_bsp040 30 30)

	(sleep_until (>= s_round_obj_control 2))
		;(if b_debug (print "**tether recycled"))
		
		(add_recycling_volume tv_gc_bsp040 0 30)
		(add_recycling_volume tv_gc_bsp040b 0 30)
		(add_recycling_volume tv_gc_bsp050a 30 30)

	(sleep_until (> s_exit_obj_control 0))
		;(if b_debug (print "**round recycled"))
		
		(add_recycling_volume tv_gc_bsp040b 0 30)
		(add_recycling_volume tv_gc_bsp050a 0 30)
		(add_recycling_volume tv_gc_bsp050 30 30)

	(sleep_until (>= s_exit_obj_control 5))
		;(if b_debug (print "**round recycled"))

		(add_recycling_volume tv_gc_bsp050 0 30)
		
	(sleep_until (= b_exit_garbage_collect 1))
		
		(add_recycling_volume tv_gc_exit 0 0)

)

;script cleanup
(script dormant gs_script_cleanup
	(sleep_until (> s_cavern_obj_control 4))
		;(if b_debug (print "**elevator script cleanup"))
		
		(sleep_forever sc_elevator_start)
		
		(sleep_forever sc_elev_opening)
		(sleep_forever sc_elev_title1)
		(sleep_forever sc_elev_init)
		(sleep_forever sc_elev_set_states)
		(sleep_forever sc_elev_init_spawn)
		(sleep_forever sc_elev_hurt_spawn)
		(sleep_forever sc_elev_gunlights)
		(sleep_forever sc_elev_second_dialog)
		(sleep_forever sc_elev_set_states)
		(sleep_forever sc_elev_hurt_spawn)
		(sleep_forever sc_elev_second_dialog)
		(sleep_forever sc_elev_door_open)
		;(sleep_forever sc_elev_door_impulse)
		(sleep_forever sc_elev_mech)
		(sleep_forever sc_elev_lights1)
		(sleep_forever sc_elev_lights2)
		(sleep_forever sc_elev_lineup)
		(sleep_forever sc_elev_blast_door)
		(sleep_forever sc_elev_blast_door_cancel)
		(sleep_forever sc_elev_sarge_hogs)
		(sleep_forever sc_elev_load_up)
		(sleep_forever sc_elev_reserve_driver)
		(sleep_forever sc_elev_betrayal)
		(sleep_forever sc_elev_cavern_task)
		(sleep_forever sc_elev_enter_vehicles)
		(sleep_forever sc_elev_hoglights1)		
		(sleep_forever sc_elev_hoglights2)
		(sleep_forever sc_elev_hoglights3)
		(sleep_forever sc_elev_hoglights4)
		(sleep_forever sc_elev_hoglights5)
		(sleep_forever sc_elev_hanglights1)
		(sleep_forever sc_elev_hanglights2)
		(sleep_forever sc_elev_cough)
		(sleep_forever sc_elev_initial_comment)
		(sleep_forever sc_elev_random_comment)
		(sleep_forever sc_elev_chatter_01)
		(sleep_forever sc_elev_chatter_02)
		(sleep_forever sc_elev_medic_01)
		(sleep_forever sc_elev_medic_02)
		(sleep_forever sc_elev_prompt01)
		(sleep_forever sc_elev_prompt02)
		;(sleep_forever sc_elev_navpoint)
		(sleep_forever sc_elev_brief01_sound)
		
	(sleep_until (> s_drive_obj_control 3))
		;(if b_debug (print "**cavern script cleanup"))

		(sleep_forever sc_cavern_start)
		(sleep_forever sc_cavern_initial)
		
		(sleep_forever sc_elev_gunlights_off)
		(sleep_forever sc_cav_firefight)
		(sleep_forever sc_cavern_jackal_fallback)
		(sleep_forever sc_cav_dialog1)
		(sleep_forever sc_cav_dialog2)
		(sleep_forever sc_cav_prompt1)
;		(sleep_forever sc_cav_prompt2)
		;(sleep_forever sc_cavern_navpoint)
	
	(sleep_until (> s_pond_obj_control 3))
		;(if b_debug (print "**drive script cleanup"))

		(sleep_forever sc_drive_start)
		(sleep_forever sc_drive_spawn)
		
		(sleep_forever sc_drive_objective_set)
		(sleep_forever sc_drive_flee_scene)
		(sleep_forever sc_drive_sniper_save)
		(sleep_forever sc_drive_dialog_tether)
		(sleep_forever sc_drive_dialog_update)
		;(sleep_forever sc_drive_navpoint)
	
	(sleep_until (> s_crash_obj_control 1))
		;(if b_debug (print "**pond script cleanup"))

		(sleep_forever sc_pond_start)
		(sleep_forever sc_pond_cov)
		
		(sleep_forever sc_pond_gamesave)
		(sleep_forever sc_pond_dialog)
		(sleep_forever sc_pond_prompt_01)
		(sleep_forever sc_pond_navpoint01)
		(sleep_forever sc_pond_prompt_02)
		;(sleep_forever sc_pond_navpoint02)
		
	(sleep_until (> s_bridge_obj_control 4))
		;(if b_debug (print "**crash script cleanup"))

		(sleep_forever sc_crash_start)
		(sleep_forever sc_crash_marines)
		(sleep_forever sc_crash_cov)
		
		(sleep_forever sc_crash_mid_save)
		(sleep_forever sc_crash_chopper_intro)
		(sleep_forever sc_crash_health_renew)
		(sleep_forever sc_crash_filler_dialog)
		(sleep_forever sc_crash_mombasa_dialog)
		(sleep_forever sc_crash_filler_dialog02)
		(sleep_forever sc_crash_prompt)
		;(sleep_forever sc_crash_navpoint)
		(sleep_forever sc_crash_truth)
		(sleep_forever sc_crash_flocks)
		(sleep_forever sc_crash_flocks2)

	(sleep_until (> s_garage_obj_control 2))
		;(if b_debug (print "**bridge script cleanup"))

		(sleep_forever sc_bridge_start)
		
		(sleep_forever sc_bridge_dialog_getout)
		(sleep_forever sc_bridge_title2)
		(sleep_forever sc_bridge_dialog01)
		(sleep_forever sc_bridge_brief02_sound)
		;(sleep_forever sc_bridge_navpoint)
		(sleep_forever sc_bridge_flocks)
		(sleep_forever sc_bridge_flocks2)
		(sleep_forever sc_bridge_flocks3)

	(sleep_until (> s_round_obj_control 1))
		;(if b_debug (print "**garage script cleanup"))

		(sleep_forever sc_garage_start)
		(sleep_forever sc_garage_initial)
		(sleep_forever sc_garage_reinforcements)
		(sleep_forever sc_garage_reinforcements2)
		
		(sleep_forever sc_garage_health_renew)
		(sleep_forever sc_garage_player_not_driving)
		(sleep_forever sc_garage_sniping)
		(sleep_forever sc_garage_objective)
		(sleep_forever sc_garage_sniper_checkpoint)
		(sleep_forever sc_garage_mid_save)
		(sleep_forever sc_garage_phantom_alive)
		(sleep_forever sc_garage_chatter01)
		(sleep_forever sc_garage_chatter02)
		(sleep_forever sc_garage_chatter03)
		(sleep_forever sc_garage_pelican_inc)
		(sleep_forever sc_garage_wraith_inc)
		(sleep_forever sc_garage_wraith_nasty)
		(sleep_forever sc_garage_pelican_drop)
		;(sleep_forever sc_garage_navpoint)
	
	(sleep_until (> s_round_obj_control 1))
		;(if b_debug (print "**tether script cleanup"))

		(sleep_forever sc_tether_start)
		(sleep_forever sc_tether_cov)
		
		(sleep_forever sc_tether_prompt)
		;(sleep_forever sc_tether_navpoint)

	(sleep_until (> s_exit_obj_control 2))
		;(if b_debug (print "**round script cleanup"))
	
		(sleep_forever sc_round_start)
		(sleep_forever sc_round_reinforce)
		(sleep_forever sc_round_warthog_reinforce)
		
		(sleep_forever sc_round_fallback_save)
		(sleep_forever sc_round_holdout_hogs)
		(sleep_forever sc_round_dialog_storm)
		(sleep_forever sc_round_prompt)
		;(sleep_forever sc_round_navpoint)
		
)

;Rob's halo 2 script
(script dormant gs_kill_stragglers
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors sg_all_allies) s_global_stragglers) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors sg_all_allies) s_global_stragglers)) 250)
				)
					(object_destroy (list_get (ai_actors sg_all_allies) s_global_stragglers))
			)
			(set s_global_stragglers (+ s_global_stragglers 1))
			(if (> s_global_stragglers 30)
				(set s_global_stragglers 0)
			)
			FALSE
		)
	)
)

;dialogue cleanup script
(script static void gs_dialogue_cleanup
	(ai_dialogue_enable TRUE)
)

;script to add the cinematic lights for marcus
(script dormant gs_cinematic_lights
	(print "in lights")
	(cinematic_light_object ark "" lighting_ark light_anchor)
	(cinematic_light_object ark_cruiser_01 "" lighting_ship light_anchor)
	(cinematic_light_object ark_cruiser_02 "" lighting_ship light_anchor)
	(cinematic_light_object truth_ship "" lighting_ship light_anchor)
	(cinematic_lighting_rebuild_all)
)

;script to place the skull
(script dormant gs_award_primary_skull
	(if (award_skull)
		(begin
			(object_create tough_luck_skull)
			
			(sleep_until 
				(or
					(unit_has_weapon (unit (player0)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player1)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player2)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
					(unit_has_weapon (unit (player3)) "objects\weapons\multiplayer\ball\primary_skull.weapon")
				)
			5)
			
			(campaign_metagame_award_primary_skull (player0) 2)
			(campaign_metagame_award_primary_skull (player1) 2)
			(campaign_metagame_award_primary_skull (player2) 2)
			(campaign_metagame_award_primary_skull (player3) 2)
		)
	)
)

;global continuous script to create objects that were forbidened in drive and to close off roundabout
(script continuous gs_con_object_management
	(sleep_until (!= g_zone_index (current_zone_set)) 1)
	(cond
		((= (current_zone_set) 1)	(begin
									(print "*****creating and setting tether")
									(object_create_anew tether01)
									(object_create_anew tether02)
									(object_create_anew tether03)
									(object_create_anew tether04)
								)
		)	
		((= (current_zone_set) 2)	(begin
									(print "*****creating and setting cavern exit and tether")
									(object_create_anew cavern_exit)
									(device_set_position_immediate cavern_exit 0)
									(zone_set_trigger_volume_enable zone_set:bc:* FALSE)
									(zone_set_trigger_volume_enable begin_zone_set:bc:* FALSE)
									
									(object_create_anew tether01)
									(object_create_anew tether02)
									(object_create_anew tether03)
									(object_create_anew tether04)
								)
		)
		((= (current_zone_set) 5)	(begin
									(print "*****creating rock")
									(wake sc_round_rock_kill)
									(object_destroy cruiser_flyover)
									(sleep 1)
									(object_create_anew round_rock)
									(ai_disposable sg_allied_vehicles TRUE)
									(zone_set_trigger_volume_enable zone_set:ef:* FALSE)
									(zone_set_trigger_volume_enable begin_zone_set:ef:* FALSE)
								)
		)
	)
	(set g_zone_index (current_zone_set))
)

;==============================================================
;==========Outskirts Mission Script============================
;==============================================================
(script static void start
	; fade out 
	(fade_out 0 0 0 0)
	
	; select insertion point 
	(cond
		((= (game_insertion_point_get) 0) (ins_elevator))
		((= (game_insertion_point_get) 1) (ins_gathering_storm))
	)
)

(script startup mission_outskirts
		;(if b_debug (print "this is outskirts!"))
		(print_difficulty)
		
		;set allegiances
		(ai_allegiance covenant prophet)
		(ai_allegiance player human)
		
		; snap to black 
		(fade_out 0 0 0 0)
		
		;set objectives
		(objectives_clear)
		
		;wake global scripts
		(wake gs_recycle_volumes)
		;(wake gs_global_player_in_vehicle)
		(wake gs_disposable_ai)
		(wake gs_script_cleanup)
		(wake gs_camera_bounds)
		;(wake gs_kill_stragglers)
		(wake gs_award_primary_skull)
		
		;global HUD settings
		(chud_show_fire_grenades FALSE)
		(campaign_metagame_time_pause TRUE)
		

; === this is a temp fix until insertion points are functional
	(if (> (player_count) 0) (start) (fade_in 0 0 0 0))
; === this is a temp fix until insertion points are functional
	
	; begin elevator encounter (insertion 1)
	(sleep_until (>= s_insertion_index 1) 1)
	(if (<= s_insertion_index 1) 
		(begin
			;(if b_debug (print "***	waking elevator"))
			
			(wake sc_elevator_start)
		)
	)
	
	;begin cavern encounter (insertion 2)
	(sleep_until 	
		(or
			(volume_test_players tv_elev_oc2) 
			(>= s_insertion_index 2)
		)
	1)
	(if (<= s_insertion_index 2) 
		(begin
			;(if b_debug (print "***	waking cavern"))
			
			(wake sc_cavern_start)
		)
	)
	
	;begin drive encounter (insertion 3)
	(sleep_until 
		(or
			(>= (current_zone_set_fully_active) 1) 
			(>= s_insertion_index 3)
		)	
	1)
	(if (<= s_insertion_index 3) 
		(begin
			;(if b_debug (print "***	waking drive"))
			
			(wake sc_drive_start)
		)
	)
	
	;begin pond encounter (insertion 4)
	(sleep_until 
		(or
			(>= (current_zone_set_fully_active) 2) 
			(>= s_insertion_index 4)
		)
	1)
	(if (<= s_insertion_index 4)
		(begin
			;(if b_debug (print "***	waking pond"))
			
			(wake sc_pond_start)
		)
	)
	
	;begin crash encounter (insertion 5)
	(sleep_until 
		(or
			(volume_test_players tv_pond_oc5) 
			(>= s_insertion_index 5)
		)
	1)
	(if (<= s_insertion_index 5)
		(begin
			;(if b_debug (print "***	waking crash"))
			
			(wake sc_crash_start)
		)
	)

	;begin bridge encounter (insertion 6)
	(sleep_until 
		(or
			(volume_test_players tv_crash_oc5) 
			(>= s_insertion_index 6)
		)
	)
	(if (<= s_insertion_index 6)
		(begin
			;(if b_debug (print "***	waking bridge"))
			
			(wake sc_bridge_start)
		)
	)
	
	;begin garage encounter (insertion 7)
	(sleep_until 
		(or
			(volume_test_players tv_bridge_oc6) 
			(>= s_insertion_index 7)
		)
	1)
	(if (<= s_insertion_index 7)
		(begin
			;(if b_debug (print "***	waking garage"))
			
			(wake sc_garage_start)
		)
	)

	;begin tether hole encounter (insertion 8)
	(sleep_until 
		(or
			(volume_test_players tv_garage_oc2) 
			(>= s_insertion_index 8)
		)
	1)
	(if (<= s_insertion_index 8)
		(begin
			;(if b_debug (print "***	waking tether hole"))
			
			(wake sc_tether_start)
		)
	)

	;begin roundabout encounter (insertion 9)
	(sleep_until 
		(or 
			(volume_test_players tv_round_oc1) 
			(>= s_insertion_index 9)
		)
	1)
	(if (<= s_insertion_index 9)
		(begin
			;(if b_debug (print "***	waking roundabout"))
			
			(wake sc_round_start)
		)
	)
	
	;begin exit encounter (insertion 10)
	(sleep_until 
		(or 
			(volume_test_players tv_round_oc1) 
			(>= s_insertion_index 10)
		)	
	1)
	(if (<= s_insertion_index 10)
		(begin
			;(if b_debug (print "***	waking exit"))
			
			(wake sc_exit_start)
		)
	)
)
			
;==============================================================
;==========Elevator Room=======================================
;==============================================================

;Main script for the elevator room
(script dormant sc_elevator_start
		(data_mine_set_mission_segment "030_010_elev_room")
		
		(wake sc_elev_set_states)
		(wake sc_elev_init)
		(wake sc_elev_opening)
		(wake sc_elev_enter_vehicles)
		;(wake sc_elev_door_impulse)
		(wake sc_elev_lights2)
		(wake sc_elev_betrayal)	
		;(wake sc_elev_navpoint_door)
		;(wake sc_elev_warthog_throttle)
		(object_create_anew cavern_entrance)
		(device_set_position cavern_entrance 0)
		(object_create_anew cavern_exit)
		(device_set_position cavern_exit 0)
	
	(sleep_until (volume_test_players tv_elev_oc1) 1)
		
		(set s_elevator_obj_control 1)		
		(game_save)

	(sleep_until (volume_test_players tv_elev_oc2) 1)
	
		(set s_elevator_obj_control 2)	
		(wake sc_elev_cavern_task)
		(wake sc_elev_reserve_driver)
		(wake sc_elev_prompt01)
		(wake sc_elev_prompt02)
		(wake sc_elev_navpoint)
		(ai_place sq_cavern_hack)

	(sleep_until (volume_test_players tv_elev_oc3) 1)
		
		(set s_elevator_obj_control 3)
		(wake sc_elev_gunlights_off)	

)

;==============================================================
;==========Cavern==============================================
;==============================================================

;Main script for the intro cavern
(script dormant sc_cavern_start	
	(sleep_until (volume_test_players tv_cav_oc1) 1)
		(data_mine_set_mission_segment "030_020_intro_cavern")
		
		(set s_cavern_obj_control 1)
		(game_save)
		(wake 030_music_01_stop)
		(sleep 1)
		(ai_set_objective sg_allied_vehicles obj_cav_marine)
		(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1) "warthog_d" FALSE)

	(sleep_until (volume_test_players tv_cav_oc2) 1)
		
		(set s_cavern_obj_control 2)		
		(wake sc_cav_prompt1)
		(wake sc_cav_prompt2)
		(wake sc_cavern_navpoint)

	(sleep_until (volume_test_players tv_cav_oc3) 1)
		
		(set s_cavern_obj_control 3)

	(sleep_until (volume_test_players tv_cav_oc4) 1)
		
		(set s_cavern_obj_control 4)
		(print "opening cavern_exit")
		(device_set_position_immediate cavern_exit 0.63)	

	(sleep_until (volume_test_players tv_cav_oc5) 1)
		
		(set s_cavern_obj_control 5)
		(wake sc_cavern_initial)	
		(wake sc_cavern_camera_follow)
		(game_save)

	(sleep_until (volume_test_players tv_cav_oc6) 1)
		
		(set s_cavern_obj_control 6)								
		(wake sc_cav_firefight)
		(wake sc_cav_dialog1)

	(sleep_until (volume_test_players tv_cav_oc7) 1)
		
		(set s_cavern_obj_control 7)
				
		;===closing the door at the start of the cavern
		(device_set_power cavern_entrance 0)	
		(device_set_position_immediate cavern_entrance 0)	
		(wake sc_drive_objective_set)				
		
	(sleep_until (volume_test_players tv_cav_oc8) 1)
		
		(set s_cavern_obj_control 8)	
		(ai_set_objective sg_allied_vehicles obj_drive_marine)		
		(wake sc_cav_dialog2)

)

;script to place the ai at the end of the cavern
(script dormant sc_cavern_initial
	(sleep_until (>= s_cavern_obj_control 3) 1)
		(ai_place sq_cavern_mar1)
		(if (= (game_is_cooperative) 0)
			(begin
				(ai_place sq_cavern_mar2)	
			)
		)
		(ai_place sq_drive_init01)
		(ai_place sq_drive_init02)
	
	(sleep_until (>= s_cavern_obj_control 7) 1)
		(garbage_collect_now)
		(wake sc_drive_spawn)
)

;==============================================================
;==========Drive===============================================
;==============================================================

;main script for the drive section
(script dormant sc_drive_start				
	(sleep_until (volume_test_players tv_drive_oc1) 1)
		(data_mine_set_mission_segment "030_030_drive")
		
		(set s_drive_obj_control 1)
		(wake sc_drive_dialog_tether)	
		(wake sc_drive_flee_scene)
		(player_control_scale_all_input 1.0 0)
		(ai_set_objective sg_allied_vehicles obj_drive_marine)
		(game_can_use_flashlights FALSE)

	(sleep_until (volume_test_players tv_drive_oc2) 1)
		
		(set s_drive_obj_control 2)
		(wake sc_drive_brute_radio_01)

	(sleep_until (volume_test_players tv_drive_oc3) 1)
		
		(set s_drive_obj_control 3)

	(sleep_until (volume_test_players tv_drive_oc4) 1)
		
		(set s_drive_obj_control 4)		
		(game_save)
				
	(sleep_until (volume_test_players tv_drive_oc5) 1)
		(data_mine_set_mission_segment "030_031_drive_second")
		
		(set s_drive_obj_control 5)
		(wake sc_drive_sniper_save)
		(wake 030_music_02_start_alt)		
		
	(sleep_until (volume_test_players tv_drive_oc6) 1)
		
		(set s_drive_obj_control 6)		
		(wake sc_drive_dialog_update)
		(wake sc_drive_brute_radio_02)
		
	(sleep_until (volume_test_players tv_drive_oc7) 1)
		
		(set s_drive_obj_control 7)

	(sleep_until (volume_test_players tv_drive_oc8) 1)
		
		(set s_drive_obj_control 8)
		(ai_set_objective sg_allied_vehicles obj_pond_marine)		
)

;========== drive secondary scripts ========================

;spawns enemies for drive section
(script dormant sc_drive_spawn
	(ai_place sq_drive_init05)
	(ai_place sq_drive_init03)
	(sleep 1)
	(ai_place sq_drive_warthog)		
	(object_damage_damage_section sq_drive_warthog/drive_warthog01 hull 0.5)
		
	(sleep_until (>= s_drive_obj_control 4) 5)
		(ai_place sq_drive2_jack01)
		(ai_place sq_drive2_sniper02)
		(object_damage_damage_section drive_watchpod upper 1)
		
	(sleep_until (>= s_drive_obj_control 5) 5)
		(cond 
			((= (game_difficulty_get_real) EASY) 
				(ai_place sq_drive2_grunt-lead)
				(ai_place sq_drive2_grunttur 1)
			)
			((= (game_difficulty_get_real) NORMAL) 
				(ai_place sq_drive2_grunt-lead)
				(ai_place sq_drive2_grunttur 2)
				(sleep 1)
				(ai_place sq_drive2_grunt01)
			)
			((= (game_difficulty_get_real) HEROIC) 
				(ai_place sq_drive2_grunt-lead)
				(ai_place sq_drive2_grunttur 3)
				(sleep 1)
				(ai_place sq_drive2_grunt01)
			)
			((= (game_difficulty_get_real) LEGENDARY) 
				(ai_place sq_drive2_grunt-lead)
				(ai_place sq_drive2_grunttur 3)
				(sleep 1)
				(ai_place sq_drive2_grunt01)
			)
		)		
	(sleep_until (>= s_drive_obj_control 7) 5)
		(if 
			(and
				(< (ai_task_count obj_drive_marine/main_gate) 4)
				(= (game_is_cooperative) 0)
			)
			(begin
				(print "place extra marines")
				(ai_place sq_pond_marine01)
			)
		)
				
)

;==============================================================
;==========Pond================================================
;==============================================================

(script dormant sc_pond_start
	(sleep_until (volume_test_players tv_pond_oc1) 1)
		(data_mine_set_mission_segment "030_040_pond")

		(set s_pond_obj_control 1)		
		(garbage_collect_now)
		(game_save)
		(sleep 1)
		(wake sc_pond_cov)
		;(ai_renew sg_all_allies)
		(ai_set_objective sg_allied_vehicles obj_pond_marine)
		(wake 030_music_02_stop)
		(wake 030_music_03_start)

	(sleep_until (volume_test_players tv_pond_oc2) 1)

		(set s_pond_obj_control 2)
		(wake sc_pond_prompt_01)
		(wake sc_pond_gamesave)

	(sleep_until (volume_test_players tv_pond_oc3) 1)

		(set s_pond_obj_control 3)

	(sleep_until (volume_test_players tv_pond_oc4) 1)

		(set s_pond_obj_control 4)
		(wake sc_pond_prompt_02)
		(wake sc_crash_flocks)
		(wake sc_crash_flocks2)
		(wake sc_pond_dialog)

	(sleep_until (volume_test_players tv_pond_oc5) 1)

		(set s_pond_obj_control 5)
		(garbage_collect_now)
		(game_save)		
		(wake 030_music_03_stop)
		(ai_set_objective sg_allied_vehicles obj_crash_marine)

)

;enemy placement for the pond
(script dormant sc_pond_cov
	(cond 
		((= (game_difficulty_get_real) EASY) 
			(ai_place sq_pond_init01 1)
			(ai_place sq_pond_init02)
			(sleep 1)
			(ai_place sq_pond_init03)
			(sleep 1)
			(ai_place sq_pond_init04)
			(ai_place sq_pond_init07)
		)
		((= (game_difficulty_get_real) NORMAL) 
			(ai_place sq_pond_init01)
			(ai_place sq_pond_init02)
			(sleep 1)
			(ai_place sq_pond_init03)
			(ai_place sq_pond_shade01 1)
			(sleep 1)
			(ai_place sq_pond_init04)
			(ai_place sq_pond_init07)
			(sleep 1)
			(ai_place sq_pond_init08)
			(ai_place sq_pond_init06)
			(sleep 1)
			(ai_place sq_pond_phantom1 1)
		)
		((= (game_difficulty_get_real) HEROIC) 
			(ai_place sq_pond_init01)
			(ai_place sq_pond_init02)
			(sleep 1)
			(ai_place sq_pond_init03)
			(ai_place sq_pond_shade01 2)
			(sleep 1)
			(ai_place sq_pond_init04)
			(ai_place sq_pond_init07)
			(sleep 1)
			(ai_place sq_pond_init08)
			(ai_place sq_pond_init06)
			(sleep 1)
			(ai_place sq_pond_phantom1 3)
		)
		((= (game_difficulty_get_real) LEGENDARY) 
			(ai_place sq_pond_init01)
			(ai_place sq_pond_init02)
			(sleep 1)
			(ai_place sq_pond_init03)
			(ai_place sq_pond_shade01 2)
			(sleep 1)
			(ai_place sq_pond_init07)
			(sleep 1)
			(ai_place sq_pond_init08)
			(ai_place sq_pond_init06)
			(sleep 1)
			(ai_place sq_pond_phantom1 3)
		)
	)
	
	(ai_place sq_pond_warthog)
	(object_damage_damage_section sq_pond_warthog/pond_warthog01 hull 0.5)	
	
	(sleep_until (<= (ai_task_count obj_pond_cov/forward_gate) 0) 1)
		(if 
			(and
				(<= s_pond_obj_control 2) 
				(or
					(= (game_difficulty_get_real) NORMAL) 
					(= (game_difficulty_get_real) HEROIC) 
					(= (game_difficulty_get_real) LEGENDARY)
				)
			) 
			(ai_place sq_pond_init05)
		)
	
)

;==============================================================
;==========Crash===============================================
;==============================================================

(global boolean b_crash_third 0)

;Main script for crash site
(script dormant sc_crash_start		
		;(ai_renew sg_all_allies)
		(wake sc_crash_cov)
		(wake sc_crash_marines)
		(sleep 5)
		(wake sc_crash_health_renew)
		(wake sc_crash_chopper_intro)
		(ai_set_objective sg_allied_vehicles obj_crash_marine)
		
	(sleep_until (volume_test_players tv_crash_oc1) 1)
		(data_mine_set_mission_segment "030_050_crash_site")	
		
		(set s_crash_obj_control 1)
		
		;=== spawns damaged warthog in the crash site
		(ai_place sq_crash_warthog)		
		(object_damage_damage_section sq_crash_warthog/crash_warthog01 hull 0.5)

	(sleep_until (volume_test_players tv_crash_oc2) 1)
		
		(set s_crash_obj_control 2)
		(wake sc_crash_navpoint)
		(wake sc_crash_filler_dialog)
		(wake sc_crash_filler_dialog02)
		;(wake sc_crash_mombasa_dialog)
		(wake sc_crash_truth)
		(wake sc_crash_shield_destroy)
		(wake sc_crash_music)
		(wake sc_crash_mid_save)

	(sleep_until (volume_test_players tv_crash_oc3) 1)
		
		(set s_crash_obj_control 3)
		(wake sc_crash_prompt)
		(wake sc_bridge_flocks)
		(wake sc_bridge_flocks2)
		(wake sc_bridge_flocks3)

	(sleep_until (volume_test_players tv_crash_oc4) 1)
		
		(set s_crash_obj_control 4)

	(sleep_until (volume_test_players tv_crash_oc5) 1)
		
		(set s_crash_obj_control 5)
		(game_can_use_flashlights TRUE)
		
	(sleep_until (volume_test_players tv_crash_oc6) 1)
		
		(set s_crash_obj_control 6)				
		(ai_set_objective sg_allied_infantry obj_bridge_marine)
		(ai_set_objective sg_allied_vehicles obj_bridge_marine)
)

;script to place the marines in crash
(script dormant sc_crash_marines
	(sleep 10)
	(if 
		(and
			(< (ai_task_count obj_crash_marine/main_gate) 4)
			(= (game_is_cooperative) 0)
		)
		(ai_place sq_crash_marines)
		(ai_place sq_crash_marines 2)
	)
)

;all covenant troops for crash
(script dormant sc_crash_cov
	(cond 
		((= (game_difficulty_get_real) EASY) 
			(ai_place sq_crash_initial01)
			(ai_place sq_crash_initial02)
			(sleep 1)
			(ai_place sq_crash_initial03)
			(ai_place sq_crash_initial06)
			
			(sleep_until (<= (ai_task_count obj_crash_cov/forward_gate) 5) )
				(if (<= s_crash_obj_control 4)
					(ai_place sq_crash_second02)
				)
			
			(sleep_until 
				(and
					(= (ai_task_count obj_crash_cov/forward_gate) 0) 
					(<= (ai_task_count obj_crash_cov/third_gate) 3) 
					(>= s_crash_obj_control 4)					
				)
			)
				(if (<= s_crash_obj_control 5)
					(ai_place sq_crash_third01)
					(ai_place sq_crash_third02)
				)
		)
		((= (game_difficulty_get_real) NORMAL) 
			(ai_place sq_crash_initial01)
			(ai_place sq_crash_initial02)
			(sleep 1)
			(ai_place sq_crash_initial03)
			(ai_place sq_crash_initial06)
			(sleep 1)
			(ai_place sq_crash_shade01)
			
			(sleep_until 
				(and
					(<= (ai_task_count obj_crash_cov/initial_gate) 5) 
					(<= (ai_task_count obj_crash_cov/second_gate) 5) 			
				)		
			)
				(if (<= s_crash_obj_control 4)
					(ai_place sq_crash_second01)
					(ai_place sq_crash_second02)
				)
		
				
			(sleep_until 
				(and
					(= (ai_task_count obj_crash_cov/initial_gate) 0) 
					(= (ai_task_count obj_crash_cov/second_gate) 0) 
					(>= s_crash_obj_control 4)				
				)
			)
				(if (<= s_crash_obj_control 5)
					(begin
						(ai_place sq_crash_third01)
						(ai_place sq_crash_third02)
						(ai_place sq_crash_third03)
					)
				)				
		)
		((= (game_difficulty_get_real) HEROIC) 
			(ai_place sq_crash_initial01)
			(ai_place sq_crash_initial02)
			(sleep 1)
			(ai_place sq_crash_initial03)
			(ai_place sq_crash_initial06)
			(sleep 1)
			(ai_place sq_crash_initial07)
			(ai_place sq_crash_shade01 2)
			
			(sleep_until (<= (ai_task_count obj_crash_cov/forward_gate) 5) )
				(if (<= s_crash_obj_control 4)
					(ai_place sq_crash_second01)
					(ai_place sq_crash_second02)
				)
				
			(sleep_until 
				(and
					(= (ai_task_count obj_crash_cov/forward_gate) 0) 
					(<= (ai_task_count obj_crash_cov/third_gate) 5)
					(>= s_crash_obj_control 4)
				)
			)
				(if (<= s_crash_obj_control 5)
					(begin
						(ai_place sq_crash_third01)
						(ai_place sq_crash_third02)
						(ai_place sq_crash_third03)
					)
				)				
		)
		((= (game_difficulty_get_real) LEGENDARY) 
			(ai_place sq_crash_initial01)
			(ai_place sq_crash_initial02)
			(sleep 1)
			(ai_place sq_crash_initial03)
			(ai_place sq_crash_initial06)
			(sleep 1)
			(ai_place sq_crash_initial07)
			(ai_place sq_crash_shade01 2)
			
			(sleep_until (<= (ai_task_count obj_crash_cov/forward_gate) 5) )
				(if (<= s_crash_obj_control 4)
					(ai_place sq_crash_second01)
					(ai_place sq_crash_second02)
				)
				
			(sleep_until 
				(and
					(= (ai_task_count obj_crash_cov/forward_gate) 0) 
					(<= (ai_task_count obj_crash_cov/third_gate) 5) 	
					(>= s_crash_obj_control 4)				
				)
			)
				(if (<= s_crash_obj_control 5)
					(begin
						(ai_place sq_crash_third01)
						(ai_place sq_crash_third02)
						(ai_place sq_crash_third03)
					)
				)				
		)
	)
	(if (> (object_get_health crash_generator) 0)
		(wake 030_music_04_start)
	)
)

;==============================================================
;==========Bridge==============================================
;==============================================================

;Main script for bridge
(script dormant sc_bridge_start
	(sleep_until (volume_test_players tv_bridge_oc1) 1)
		(data_mine_set_mission_segment "030_060_bridge")
		
		(set s_bridge_obj_control 1)
		
		(garbage_collect_now)
		(game_save)
		(sleep 1)
		;(ai_renew sg_all_allies)
		(wake sc_bridge_navpoint)
		(wake sc_bridge_cruiser)
		(sleep 1)
		(ai_set_objective sg_allied_vehicles obj_bridge_marine)
		(wake sc_bridge_overhead_cruiser)
		(game_can_use_flashlights FALSE)
		
	(sleep_until (volume_test_players tv_bridge_oc2) 1)
		
		(set s_bridge_obj_control 2)
		(wake sc_bridge_dialog01)
		
	(sleep_until (volume_test_players tv_bridge_oc3) 1)
		
		(set s_bridge_obj_control 3)
		(wake sc_bridge_dialog_getout)
		
	(sleep_until (volume_test_players tv_bridge_oc4) 1)
		
		(set s_bridge_obj_control 4)	

	(sleep_until (volume_test_players tv_bridge_oc5) 1)
		
		(set s_bridge_obj_control 5)
		(wake 030_music_04_stop_backup)

	(sleep_until (volume_test_players tv_bridge_oc6) 1)
		
		(set s_bridge_obj_control 6)
				
		(wake sc_bridge_brief02_sound)
		(wake sc_bridge_title2)
		(game_save)
		(sleep 1)
		(ai_set_objective sg_allied_infantry obj_garage_marine)
		(ai_set_objective sg_allied_vehicles obj_garage_marine)
)

;==============================================================
;==========Garage==============================================
;==============================================================
(global short s_garage_phantom 0)
(global boolean b_garage_zed_go 0)
(global short s_garage_gate_latch 0)
(global boolean b_garage_marine_latch 0)
(global boolean b_garage_sniping 0)
(global short s_garage_wraith 0)

;Main script for garage
(script dormant sc_garage_start
	
	; unlock the insertion point 
	(game_insertion_point_unlock 1)

		(wake sc_garage_initial)
		(if (<= (game_difficulty_get_real) NORMAL)
			(wake sc_garage_reinforcements)
			(wake sc_garage_reinforcements2)
		)
		(wake sc_garage_health_renew)
		(wake sc_garage_health_renew2)
		
	(sleep_until (volume_test_players tv_garage_oc1) 1)
		(data_mine_set_mission_segment "030_070_garage")
		
		(set s_garage_obj_control 1)		
		;(ai_renew sg_all_allies)		
		(garbage_collect_now)
		(game_save)
		(sleep 1)
		
		(wake sc_garage_chatter01)
		(wake sc_garage_chatter02)
		(wake sc_garage_chatter03)
		(wake sc_garage_sniper_checkpoint)
		(wake sc_garage_sniping)
		(wake sc_garage_navpoint)
		(wake sc_garage_wraith_inc)
		
	(sleep_until (volume_test_players tv_garage_oc2) 1)
		
		(set s_garage_obj_control 2)		
		(set b_garage_zed_go 1)
		(wake sc_garage_mid_save2)

	(sleep_until (volume_test_players tv_garage_oc3) 1)
		
		(set s_garage_obj_control 3)

	(sleep_until (volume_test_players tv_garage_oc4) 1)
		
		(set s_garage_obj_control 4)
		(wake sc_garage_objective)

)

;Initial spawn script
(script dormant sc_garage_initial
	(sleep 20)
	(cond 
		((= (game_difficulty_get_real) EASY) 
			(ai_place sq_garage_initial01)
			(ai_place sq_garage_initial02)
			(sleep 1)
			(ai_place sq_garage_initial05)
			(ai_place sq_garage_initial06)
			(sleep 1)
			(ai_place sq_garage_jets01 2)
			(ai_place sq_garage_turret)
			(sleep 1)
		)
		((= (game_difficulty_get_real) NORMAL) 
			(ai_place sq_garage_initial01)
			(ai_place sq_garage_initial02)
			(sleep 1)
			(ai_place sq_garage_initial03)
			(ai_place sq_garage_initial04)
			(sleep 1)
			(ai_place sq_garage_initial05)
			(ai_place sq_garage_initial06)
			(sleep 1)
			(ai_place sq_garage_jets01)
			(ai_place sq_garage_turret)
			(sleep 1)				
		)
		((= (game_difficulty_get_real) HEROIC) 
			(ai_place sq_garage_initial01)
			(ai_place sq_garage_initial02)
			(sleep 1)
			(ai_place sq_garage_initial03)
			(ai_place sq_garage_initial04)
			(sleep 1)
			(ai_place sq_garage_initial05)
			(ai_place sq_garage_initial06)
			(sleep 1)
			(ai_place sq_garage_jets01)
			(ai_place sq_garage_turret)
			(sleep 1)				
		)
		((= (game_difficulty_get_real) LEGENDARY) 
			(ai_place sq_garage_initial01)
			(ai_place sq_garage_initial02)
			(sleep 1)
			(ai_place sq_garage_initial03)
			(ai_place sq_garage_initial04)
			(sleep 1)
			(ai_place sq_garage_initial05)
			(ai_place sq_garage_initial06)
			(sleep 1)
			(ai_place sq_garage_jets01)
			(sleep 1)					
		)
	)
	
	(if 
		(and
			(>= (ai_task_count obj_garage_marine/main_gate) 3)
			(= (game_is_cooperative) 0)
		)
		(begin
			(ai_place sq_garage_initial_mar/01)
			(ai_place sq_garage_initial_mar/02)
		)
		(ai_place sq_garage_initial_mar 4)
	)
	
	(if 
		(and
			(>= (ai_task_count obj_garage_marine/main_gate) 5)
			(= (game_is_cooperative) 0)
		)
		(ai_place sq_garage_initial_mar2 1)
		(ai_place sq_garage_initial_mar2 2)
	)
	(sleep 1)		
	
	(ai_place sq_garage_initial07)
	
	(sleep 1)
	
	(sleep_until (>= s_garage_obj_control 3) 5)
	(cond 
		((= (game_difficulty_get_real) EASY) 
			(ai_place sq_garage_wraith)
		)
		((= (game_difficulty_get_real) NORMAL) 
			(ai_place sq_garage_wraith2)
			(ai_place sq_tether_sniper01)				
		)
		((= (game_difficulty_get_real) HEROIC) 
			(ai_place sq_garage_wraith2)
			(ai_place sq_tether_sniper01)			
		)
		((= (game_difficulty_get_real) LEGENDARY) 
			(ai_place sq_garage_wraith2)
			(ai_place sq_tether_sniper01)				
		)
	)	
)

;phantom call script
(script dormant sc_garage_reinforcements
	(sleep_until 
		(and
			(>= s_garage_obj_control 2)
			(< (ai_task_count obj_garage_cov/main_gate) 3) 
		)
	)
		(set s_garage_gate_latch 1)
		(ai_place sq_garage_phantom1)
		(wake 030_music_051_stop)
		(set s_garage_wraith 1)
		
		(sleep 20)
		(wake 030_music_055_start)
	
	(sleep_until 
		(and
			(<= (ai_task_count obj_garage_cov/main_gate) 2) 
			(= s_garage_phantom 1)	
		)
	30 3600)
	
		(sleep 120)
		(game_save)
		(set s_garage_wraith 2)
		(wake sc_garage_mid_save3)
		(wake 030_music_056_start)
		(wake 030_music_057_start)
		(wake sc_garage_music_end)
		(flock_stop bridge_flock3)
		
	(sleep_until (= (ai_task_count obj_garage_cov/wraith_gate) 0) 5)
	
		(game_save)
		(set b_garage_marine_latch 1)
		
		(if (= (game_is_cooperative) 0)
			(begin
				(ai_place sq_garage_pelican1)
				(sleep 30)
				(ai_place sq_garage_pelican2)
			)
			(begin
				(ai_place sq_garage_pelican1)
				(sleep 10)
				(ai_place sq_garage_pelican3)
			)
		)
		
		(wake sc_garage_player_not_driving)
		(if (<= s_tether_obj_control 1)
			(begin
				(ai_place sq_tether_sniper02)
				(ai_place sq_tether_brute01)
			)
		)		
		(flock_stop bridge_flock)
		(flock_stop bridge_flock2)
)

;phantom call script
(script dormant sc_garage_reinforcements2
	(sleep_until 
		(and
			(>= s_garage_obj_control 2)
			(< (ai_task_count obj_garage_cov/main_gate) 3) 
		)
	)
		(set s_garage_gate_latch 1)
		(ai_place sq_garage_phantom1)
		(wake 030_music_051_stop)
		(set s_garage_wraith 1)
		
		(sleep 20)
		(wake 030_music_055_start)
	
	(sleep_until 
		(and
			(<= (ai_task_count obj_garage_cov/main_gate) 2) 
			(= s_garage_phantom 1)	
		)
	30 3600)
		(set s_garage_gate_latch 2)
		(ai_place sq_garage_phantom2)
		
		(sleep 20)
	
	(sleep_until 
		(and
			(<= (ai_task_count obj_garage_cov/main_gate) 2) 
			(= s_garage_phantom 2)	
		)
	30 7200)
		
		(sleep 120)
		(game_save)
		(set s_garage_wraith 2)
		(wake sc_garage_mid_save3)
		(wake 030_music_056_start)
		(wake 030_music_057_start)
		(wake sc_garage_music_end)
		(flock_stop bridge_flock3)
		
	(sleep_until (= (ai_task_count obj_garage_cov/wraith_gate) 0) 5)
	
		(game_save)
		(set b_garage_marine_latch 1)
		
		(if (= (game_is_cooperative) 0)
			(begin
				(ai_place sq_garage_pelican1)
				(sleep 30)
				(ai_place sq_garage_pelican2)
			)
			(begin
				(ai_place sq_garage_pelican1)
				(sleep 10)
				(ai_place sq_garage_pelican3)
			)
		)
		
		(wake sc_garage_player_not_driving)
		(if (<= s_tether_obj_control 1)
			(begin
				(ai_place sq_tether_sniper02)
				(ai_place sq_tether_brute01)
			)
		)
		(if (= s_tether_obj_control 0)
			(ai_place sq_tether_shade01)
		)
		(flock_stop bridge_flock)
		(flock_stop bridge_flock2)
)

;==============================================================
;==========Tether==============================================
;==============================================================

(global boolean b_tether_wraith_awake 0)

;Main script for tether
(script dormant sc_tether_start		
	(sleep_until (volume_test_players tv_tether_oc1) 1)
		(data_mine_set_mission_segment "030_080_tether_hole")
		
		(set s_tether_obj_control 1)
		(wake sc_tether_cov)
		;(ai_renew sg_all_allies)
		(wake sc_tether_navpoint)
		(wake sc_exit_flocks)
		(wake sc_exit_flocks2)
		(wake sc_exit_flocks3)
		(game_save)
		(ai_set_objective sg_allied_vehicles obj_tether_marine)

	(sleep_until (volume_test_players tv_tether_oc2) 1)
		
		(set s_tether_obj_control 2)
		(wake sc_tether_prompt)
		(wake 030_music_055_stop)
		(wake 030_music_056_stop)
		(wake 030_music_057_stop)

	(sleep_until (volume_test_players tv_tether_oc3) 1)
		
		(set s_tether_obj_control 3)
		
	(sleep_until (= (ai_task_count obj_tether_cov/mg_no_sniper) 0) 1)
		(ai_set_objective sg_all_allies obj_round_marine)
)

;tether covenant spawn script
(script dormant sc_tether_cov
	(ai_place sq_tether_brute02)
)

;==============================================================
;==========Round===============================================
;==============================================================

;Main script for round
(script dormant sc_round_start
	(sleep_until 
		(or
			(volume_test_players tv_round_oc1a) 
			(volume_test_players tv_round_oc1) 
		)		
	1)
		(data_mine_set_mission_segment "030_090_roundabout")
		
		(set s_round_obj_control 1)
		(garbage_collect_now)
		(game_save)
		(ai_set_objective sg_allied_vehicles obj_round_marine)
		(sleep 1)	
		;(ai_renew sg_all_allies)
		(wake sc_round_reinforce)
		(sleep 10)
		(wake sc_round_holdout_hogs)
		(wake sc_round_holdout_dialog)
		
	(sleep_until (volume_test_players tv_round_oc2) 1)
		
		(set s_round_obj_control 2)
		(wake sc_round_fallback_save)	
		(wake sc_round_warthog_reinforce)
		(game_save)
		(wake sc_round_navpoint)
		(wake sc_round_prompt)
		(wake sc_round_dialog_storm)
		(wake sc_round_mid_save)
		(wake sc_round_music_stop)
		
	(sleep_until (volume_test_players tv_round_oc3) 1)
		
		(set s_round_obj_control 3)	
		
	(sleep_until (volume_test_players tv_round_oc4) 1)
		
		(set s_round_obj_control 4)
		
		(ai_set_objective sg_all_allies obj_exit_marine)

)

;reinforcement script for round
(script dormant sc_round_reinforce
	(ai_place sq_round_warthog01)

	(sleep 15)

	;spawn guys at entrance
	(if (= (game_is_cooperative) 0)
		(begin
			(if (< (ai_living_count sg_all_allies) 4)
				(ai_place sq_round_marine01)
				(begin
					(object_create round_mar01)
					(object_create round_mar02)
				)
			)
			(ai_place sq_round_hold)
			(ai_place sq_round_hold_chopper)
			(sleep 1)
			(ai_magically_see sq_round_hold sq_round_marine01)
		)
		(begin
			(object_create round_mar01)
			(object_create round_mar02)
			(ai_place sq_round_hold_chopper)
			(object_create round_brute01)
			(object_create round_brute02)			
		)
	)
	
	(if 
		(and
			(< (ai_living_count sg_all_allies) 4)
			(= (game_is_cooperative) 0)
		)
		(ai_place sq_round_marine02)
	)
	
	;spawn main block of ai in the round
		(sleep 1)
	(ai_place sq_round_init02)
	(ai_place sq_round_init03)
		(sleep 1)
	(ai_place sq_round_init04)
	(ai_place sq_round_init05)
	(sleep 1)
	(ai_place sq_round_shade01)
	(ai_place sq_round_shade02)
		(sleep 1)
		
		;magically see the player
		(if 
			(or
				(>= (game_difficulty_get_real) HEROIC)
				(= (game_is_cooperative) 1)
			)
			(begin
				(ai_magically_see_object sg_round_cov (player0))
				(ai_magically_see_object sg_round_cov (player1))
				(ai_magically_see_object sg_round_cov (player2))
				(ai_magically_see_object sg_round_cov (player3))
			)
			(begin
				(ai_magically_see_object sg_round_cov_choppers (player0))
				(ai_magically_see_object sg_round_cov_choppers (player1))
				(ai_magically_see_object sg_round_cov_choppers (player2))
				(ai_magically_see_object sg_round_cov_choppers (player3))
			)
		)
;*		
	;spawn the shades up on the hill
	(if 
		(or
			(>= (game_difficulty_get_real) HEROIC)
			(= (game_is_cooperative) 1)
		)
		(ai_place sq_round_shade03)
	)
*;
	;spawn the first phantom to drop reinforcements
	(sleep_until (< (ai_living_count sg_round_cov) 8))
		(if (<= s_exit_obj_control 3)
			(ai_place sq_round_phantom02)		
		)
		
	(sleep 30)
		
		;magically see the player
		(if 
			(or
				(>= (game_difficulty_get_real) HEROIC)
				(= (game_is_cooperative) 1)
			)
			(begin
				(ai_magically_see_object sg_round_cov (player0))
				(ai_magically_see_object sg_round_cov (player1))
				(ai_magically_see_object sg_round_cov (player2))
				(ai_magically_see_object sg_round_cov (player3))
			)
			(begin
				(ai_magically_see_object sg_round_cov_choppers (player0))
				(ai_magically_see_object sg_round_cov_choppers (player1))
				(ai_magically_see_object sg_round_cov_choppers (player2))
				(ai_magically_see_object sg_round_cov_choppers (player3))
			)
		)		
	
	;spawn a couple of chopper up the road
	(sleep_until (< (ai_living_count sg_round_cov) 8))
		(if (<  s_round_obj_control 3)
			(ai_place sq_round_second01)
		)
		
	(sleep 30)
		
		;magically see the player
		(if 
			(or
				(>= (game_difficulty_get_real) HEROIC)
				(= (game_is_cooperative) 1)
			)
			(begin
				(ai_magically_see_object sg_round_cov (player0))
				(ai_magically_see_object sg_round_cov (player1))
				(ai_magically_see_object sg_round_cov (player2))
				(ai_magically_see_object sg_round_cov (player3))
			)
			(begin
				(ai_magically_see_object sg_round_cov_choppers (player0))
				(ai_magically_see_object sg_round_cov_choppers (player1))
				(ai_magically_see_object sg_round_cov_choppers (player2))
				(ai_magically_see_object sg_round_cov_choppers (player3))
			)
		)
	
	;spawn the second phantom
	(sleep_until (< (ai_living_count sg_round_cov) 8))
		(if 
			(or
				(>= (game_difficulty_get_real) HEROIC)
				(= (game_is_cooperative) 1)
			)
		(ai_place sq_round_phantom01)	
		)
		
	(sleep 30)				
		;magically see the player
		(if 
			(or
				(>= (game_difficulty_get_real) HEROIC)
				(= (game_is_cooperative) 1)
			)
			(begin
				(ai_magically_see_object sg_round_cov (player0))
				(ai_magically_see_object sg_round_cov (player1))
				(ai_magically_see_object sg_round_cov (player2))
				(ai_magically_see_object sg_round_cov (player3))
			)
			(begin
				(ai_magically_see_object sg_round_cov_choppers (player0))
				(ai_magically_see_object sg_round_cov_choppers (player1))
				(ai_magically_see_object sg_round_cov_choppers (player2))
				(ai_magically_see_object sg_round_cov_choppers (player3))
			)
		)
	
	;spawn the second group of choppers up the road
	(sleep_until (< (ai_living_count sg_round_cov) 8))
		(if (<  s_round_obj_control 3)
			(ai_place sq_round_second02)
		)
		
	(sleep 30)	
	
		;magically see the player
		(if 
			(or
				(>= (game_difficulty_get_real) HEROIC)
				(= (game_is_cooperative) 1)
			)
			(begin
				(ai_magically_see_object sg_round_cov (player0))
				(ai_magically_see_object sg_round_cov (player1))
				(ai_magically_see_object sg_round_cov (player2))
				(ai_magically_see_object sg_round_cov (player3))
			)
			(begin
				(ai_magically_see_object sg_round_cov_choppers (player0))
				(ai_magically_see_object sg_round_cov_choppers (player1))
				(ai_magically_see_object sg_round_cov_choppers (player2))
				(ai_magically_see_object sg_round_cov_choppers (player3))
			)
		)
	
	;spawn the third phantom of reinforcements
	(sleep_until (< (ai_living_count sg_round_cov) 8))
		(if 
			(or
				(>= (game_difficulty_get_real) HEROIC)
				(= (game_is_cooperative) 1)
			)
		(ai_place sq_round_phantom03)	
		)
		
		;magically see the player
		(if 
			(or
				(>= (game_difficulty_get_real) HEROIC)
				(= (game_is_cooperative) 1)
			)
			(begin
				(ai_magically_see_object sg_round_cov (player0))
				(ai_magically_see_object sg_round_cov (player1))
				(ai_magically_see_object sg_round_cov (player2))
				(ai_magically_see_object sg_round_cov (player3))
			)
			(begin
				(ai_magically_see_object sg_round_cov_choppers (player0))
				(ai_magically_see_object sg_round_cov_choppers (player1))
				(ai_magically_see_object sg_round_cov_choppers (player2))
				(ai_magically_see_object sg_round_cov_choppers (player3))
			)
		)		
	
	;wait then save the game
	(sleep_until (< (ai_task_count obj_round_cov/main_gate) 0))	
		(game_save)
				
)

;script to bring in more warthogs if player gets low on marines
(script dormant sc_round_warthog_reinforce
	(sleep_until
		(begin
			(if 
				(and
					(<= (ai_task_count obj_round_marine/main_gate) 1)
					(= (game_is_cooperative) 0)
					(or
						(= (current_zone_set) 4)
						(= (current_zone_set) 5)
					)
				)
				(begin
					(sleep 30)
					(if (< s_round_obj_control 4)
						(begin
							(ai_place sq_round_reinforce)
							(sleep 300)
						)
					)
				)
			)
		(>= s_round_obj_control 4))
	30)
)

;==============================================================
;==========Exit================================================
;==============================================================

(global boolean b_exit_garbage_collect 0)
(global short s_exit_marine_reinforce 0)
(global ai act_exit_marine1 NONE)
(global ai act_exit_marine2 NONE)
(global ai act_exit_marine3 NONE)
(global ai act_exit_marine4 NONE)

;Main script for exit
(script dormant sc_exit_start
	(sleep_until (volume_test_players tv_exit_oc1) 1)
		(data_mine_set_mission_segment "030_100_exit_tunnel")
		
		(set s_exit_obj_control 1)
		(garbage_collect_now)
		(game_save)
		(sleep 1)
		;(ai_renew sg_all_allies)
		(wake sc_exit_reinforce)
		;(wake sc_exit_marine_reinforce)
		(wake sc_exit_truth)
		(wake sc_exit_brute_flavor_01)
		(wake sc_exit_johnson_flavor)
		(ai_set_objective sg_allied_vehicles obj_exit_marine)
		
		; place sniper rifle 
		(if (>= (game_difficulty_get) legendary) (object_create exit_sniper))
				
	(sleep_until (volume_test_players tv_exit_oc2) 1)
		
		(set s_exit_obj_control 2)
		(wake sc_exit_music_stop)
		(wake sc_exit_music_start)
		
	(sleep_until (volume_test_players tv_exit_oc3) 1)
		
		(set s_exit_obj_control 3)
		(object_create_anew exit_pelican_crashed)
		
	(sleep_until (volume_test_players tv_exit_oc4) 1)
		
		(set s_exit_obj_control 4)
		(wake sc_exit_prompt)
		(wake sc_exit_navpoint)
		
	(sleep_until (volume_test_players tv_exit_oc5) 1)
		
		(set s_exit_obj_control 5)
		(wake sc_exit_fallback_save)
		(wake sc_exit_infantry_save)
		(wake sc_exit_shield_destroy)
		(wake sc_exit_brute_flavor_02)
		(wake sc_exit_music09_start)
		(wake sc_exit_music08_end)
		(game_save)
		
	(sleep_until (volume_test_players tv_exit_oc6) 1)
		
		(set s_exit_obj_control 6)
		(wake sc_exit_mission_over)
		(wake sc_exit_midsave01)
		
	(sleep_until (volume_test_players tv_exit_oc7) 1)
		
		(set s_exit_obj_control 7)

)

;reinforcements script
(script dormant sc_exit_reinforce	
	;(ai_place sq_exit_wraith01)
	(ai_place sq_exit_shade01)
	(cond 
		((= (game_difficulty_get_real) EASY) 
			(ai_place sq_exit_brute01)
			(ai_place sq_exit_jetpack01)
			(sleep 1)
			(ai_place sq_exit_brute02)
			;(ai_place sq_exit_jetpack02)
		)
		((= (game_difficulty_get_real) NORMAL)
			(ai_place sq_exit_brute01)
			(ai_place sq_exit_jetpack01)
			(sleep 1)
			(ai_place sq_exit_brute02)
			;(ai_place sq_exit_jetpack02)
		)
		((= (game_difficulty_get_real) HEROIC)
			(ai_place sq_exit_brute01)
			(ai_place sq_exit_jetpack01)
			(sleep 1)
			(ai_place sq_exit_brute02)
			(ai_place sq_exit_jetpack02)
		)
		((= (game_difficulty_get_real) LEGENDARY)
			(ai_place sq_exit_brute01)
			(ai_place sq_exit_jetpack01)
			(sleep 1)
			(ai_place sq_exit_brute02)
			(ai_place sq_exit_jetpack02)
		)
	)

	(sleep 1)
	(ai_place sq_exit_brute04)
	(ai_place sq_exit_brute05)
	(sleep 1)
	(ai_place sq_exit_jetpack04)
	(ai_place sq_exit_jackal01)
	
	(sleep_until (>= s_exit_obj_control 4) 1)
	(if (<= (ai_task_count obj_exit_cov/main_gate) 16)
		(begin
			(ai_place sq_exit_brute06)
			(ai_place sq_exit_jetpack05)
		)
	)
	
	(sleep_until (= (ai_task_count obj_exit_cov/forward_gate) 0) 5)
		(game_save)
)

;script to call the marine reinforcements
(script dormant sc_exit_marine_reinforce
	(sleep_until 	(<= (ai_task_count obj_round_marine/main_gate) 0) )
	
	(sleep_until
		(begin
			(if 
				(and
					(<= (ai_task_count obj_exit_marine/main_gate) 4)
					(= b_exit_pelican 0)
					(= (game_is_cooperative) 0)
				)
					
				(begin
					(set b_exit_pelican 1)
					(ai_place sq_exit_pelican01)
					(ai_place sq_exit_marine01)
					(ai_place sq_exit_marine02)
					(sleep 1)
					(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p" (ai_actors sq_exit_marine01) )
					(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_exit_pelican01/pilot) "pelican_p" (ai_actors sq_exit_marine02) )
					(set s_exit_marine_reinforce (+ s_exit_marine_reinforce 1) )
					(sleep 300)
				)
			)
		(= s_exit_marine_reinforce 5))
	60)	
)

;script to get a mid encounter save
(script dormant sc_exit_midsave01
	;wait then save the game
	(sleep_until (game_safe_to_save) 1 1200)
	
	(game_save)
)

;this ends the mission
(script dormant sc_exit_mission_over	
	(sleep_until 
		(and
			;(= (ai_task_count obj_exit_cov/wraith) 0) 
			(= (ai_living_count sq_exit_shade01) 0)
			(= (volume_test_object tv_exit_enemy_check (ai_get_object sg_exit_cov) ) 0)
			(= (volume_test_object tv_exit_enemy_check2 (ai_get_object sg_exit_cov) ) 0)
			(<= (object_get_health exit_generator) 0)
		)		
	5)

	(vs_cast sg_exit_mar FALSE 10 "030MF_240" "030MF_240" "030MF_240" "030MF_240")
	(set act_exit_marine1 (vs_role 1))
	(set act_exit_marine2 (vs_role 2))
	(set act_exit_marine3 (vs_role 3))
	(set act_exit_marine4 (vs_role 4))	

	(print "MARINE:  Ooh-Rah!  Alright!   Hell yeah!")
	(vs_play_line act_exit_marine1 TRUE 030MF_240)
	(vs_play_line act_exit_marine2 TRUE 030MF_240)
	(vs_play_line act_exit_marine3 TRUE 030MF_240)
	(vs_play_line act_exit_marine4 TRUE 030MF_240)

	;(sleep_until (> (device_get_position exit_button) 0) 5)
	
	(sleep 30)
	(sleep_forever sc_exit_truth)
	(sleep 1)

	(sound_impulse_stop sound\dialog\030_outskirts\mission\030mz_060_pot)
	(sound_impulse_stop sound\dialog\030_outskirts\mission\030mz_070_pot)
	(sound_impulse_stop sound\dialog\030_outskirts\mission\030mz_080_pot)
	(set b_exit_garbage_collect 1)
	(wake sc_exit_ending_cinematic)
	(ai_erase_all)
	(ai_erase sq_exit_brute01) 
	(ai_erase sq_exit_brute02) 
	(ai_erase sq_exit_brute04) 
	(ai_erase sq_exit_brute05) 
	(ai_erase sq_exit_jetpack01) 
	(ai_erase sq_exit_jetpack02) 
	(ai_erase sq_exit_jetpack04) 
	(ai_erase sq_exit_jackal01)
)

;==============================================================
;==========Kill Volumes========================================
;==============================================================

;And, stolen from Halo 2, my kill straggler script
(global short straggler_no 0)
(script dormant kill_stragglers
	(sleep_until
		(begin
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors sq_elev_mar) straggler_no) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors sq_elev_mar) straggler_no)) 250)
				)
					(object_destroy (list_get (ai_actors sq_elev_mar) straggler_no))
			)
			(if 
				(AND
					(= (objects_can_see_object (players) (list_get (ai_actors sg_allied_vehicles) straggler_no) 45) FALSE)
					(> (objects_distance_to_object (players) (list_get (ai_actors sg_allied_vehicles) straggler_no)) 250)
				)
					(object_destroy (list_get (ai_actors sg_allied_vehicles) straggler_no))
			)
			(set straggler_no (+ straggler_no 1))
			(if (> straggler_no 30)
				(set straggler_no 0)
			)
			FALSE
		)
	)
)

;====================================================================================================================================================================================================
;=============================== CAMERA BOUNDS ======================================================================================================================================================
;====================================================================================================================================================================================================
(script dormant gs_camera_bounds
	; turn on all camera bounds 
	(gs_camera_bounds_on)
	
	; cave
	(sleep_until (>= s_cavern_obj_control 3) 1)
		(soft_ceiling_enable camera_cv_00 FALSE)
	(sleep_until (>= s_cavern_obj_control 6) 1)
		(soft_ceiling_enable camera_cv_01 FALSE)

	; drivey part 
	(sleep_until (>= s_drive_obj_control 4) 1)
		(soft_ceiling_enable camera_dv_00 FALSE)
	(sleep_until (>= s_drive_obj_control 7) 1)
		(soft_ceiling_enable camera_dv_01 FALSE)

	; pond
	(sleep_until (>= s_pond_obj_control 1) 1)
		(soft_ceiling_enable camera_pd_00 FALSE)
	(sleep_until (>= s_pond_obj_control 5) 1)
		(soft_ceiling_enable camera_cr_00 FALSE)

	; crash site 
	(sleep_until (>= s_crash_obj_control 5) 1)
		(soft_ceiling_enable camera_cr_01 FALSE)

	; bridge
	(sleep_until (>= s_bridge_obj_control 5) 1)
		(soft_ceiling_enable camera_br_00 FALSE)
	(sleep_until (>= s_bridge_obj_control 6) 1)
		(soft_ceiling_enable camera_br_01 FALSE)

	; tether 
	(sleep_until (>= s_tether_obj_control 2) 1)
		(soft_ceiling_enable camera_th_00 FALSE)
		
	; round about 
	(sleep_until (>= s_round_obj_control 1) 1)
		(soft_ceiling_enable camera_rb_00 FALSE)
	(sleep_until (>= s_round_obj_control 3) 1)
		(soft_ceiling_enable camera_rb_01 FALSE)

)		
		
(script static void gs_camera_bounds_off		
	(print "turn off camera bounds")

	; cave 
	(soft_ceiling_enable camera_cv_00 FALSE)
	(soft_ceiling_enable camera_cv_01 FALSE)


	; drivey part 
	(soft_ceiling_enable camera_dv_00 FALSE)
	(soft_ceiling_enable camera_dv_01 FALSE)


	; pond 
	(soft_ceiling_enable camera_pd_00 FALSE)
	(soft_ceiling_enable camera_cr_00 FALSE)
	
	; crash site 
	(soft_ceiling_enable camera_cr_01 FALSE)

	; bridge
	(soft_ceiling_enable camera_br_00 FALSE)
	(soft_ceiling_enable camera_br_01 FALSE)

	; tether 
	(soft_ceiling_enable camera_th_00 FALSE)
		
	; round about 
	(soft_ceiling_enable camera_rb_00 FALSE)
	(soft_ceiling_enable camera_rb_01 FALSE)

)		

(script static void gs_camera_bounds_on		
	(print "turn on camera bounds")

	; cave 
	(soft_ceiling_enable camera_cv_00 TRUE)
	(soft_ceiling_enable camera_cv_01 TRUE)


	; drivey part 
	(soft_ceiling_enable camera_dv_00 TRUE)
	(soft_ceiling_enable camera_dv_01 TRUE)


	; pond 
	(soft_ceiling_enable camera_pd_00 TRUE)
	(soft_ceiling_enable camera_cr_00 TRUE)
	
	; crash site 
	(soft_ceiling_enable camera_cr_01 TRUE)

	; bridge
	(soft_ceiling_enable camera_br_00 TRUE)
	(soft_ceiling_enable camera_br_01 TRUE)

	; tether 
	(soft_ceiling_enable camera_th_00 TRUE)
		
	; round about 
	(soft_ceiling_enable camera_rb_00 TRUE)
	(soft_ceiling_enable camera_rb_01 TRUE)
)

;==============================================================
;==========Music===============================================
;==============================================================

;Starts after marine says "What happened" in first space
(script dormant 030_music_01_start
	(print "***MUSIC: 030_music_01 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_01" none 1.0)
)

;After "Let's mount up, get the hell out of these caves!"
(script dormant 030_music_02_start
	(print "***MUSIC: 030_music_02 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_02" none 1.0)
)

;When player enters the cavern area
(script dormant 030_music_01_stop
	(print "***MUSIC: 030_music_01 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_01")
)

;drivey part 2 - near sniper tower
(script dormant 030_music_02_start_alt
	(print "***MUSIC: 030_music_02 start alt")
	(sound_looping_set_alternate "levels\solo\030_outskirts\music\030_music_02" true)
)

;After arriving at the pond encounter
(script dormant 030_music_02_stop
	(print "***MUSIC: 030_music_02 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_02")
)
(script dormant 030_music_03_start
	(print "***MUSIC: 030_music_03 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_03" none 1.0)
)

;After "I've got wounded!"
(script dormant 030_music_03_stop
	(print "***MUSIC: 030_music_03 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_03")
)

;When drones enter the tunnel
(script dormant 030_music_04_start
	(print "***MUSIC: 030_music_04 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_04" none 1.0)
)

;When the player destroys the barrier
(script dormant 030_music_04_stop
	(print "***MUSIC: 030_music_04 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_04")
)
(script dormant 030_music_05_start
	(print "***MUSIC: 030_music_05 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_05" none 1.0)
)

;backup stop for 04
(script dormant 030_music_04_stop_backup
	(print "***MUSIC: 030_music_04 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_04")
)

;start at insertion point 
(script dormant 030_music_051_start
	(print "***MUSIC: 030_music_051 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_051" none 1.0)
)

;when the phantom comes in with reinforcements 
(script dormant 030_music_055_start
	(print "***MUSIC: 030_music_055 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_055" none 1.0)
)

;when the wraith comes in 
(script dormant 030_music_056_start
	(print "***MUSIC: 030_music_056 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_056" none 1.0)
)

(script dormant 030_music_057_start
	(print "***MUSIC: 030_music_057 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_057" none 1.0)
)

;when first phantom comes with reinforcements 
(script dormant 030_music_051_stop
	(print "***MUSIC: 030_music_051 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_051")
)

;end of the garage encounter
(script dormant 030_music_055_stop
	(print "***MUSIC: 030_music_055 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_055")
)

;At chapter title "The broken path"
(script dormant 030_music_05_stop
	(print "***MUSIC: 030_music_05 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_05")
)

;Enter hog after garage encounter
(script dormant 030_music_06_start
	(print "***MUSIC: 030_music_06 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_06" none 1.0)
)

(script dormant 030_music_056_stop
	(print "***MUSIC: 030_music_056 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_056")
)

(script dormant 030_music_057_stop
	(print "***MUSIC: 030_music_057 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_057")
)

;At "wraiths's circling the hill"
(script dormant 030_music_06_start_alt
	(print "***MUSIC: 030_music_06 start alt")
	(sound_looping_set_alternate "levels\solo\030_outskirts\music\030_music_06" true)
)

;end of roundabout at the top of the hill
(script dormant 030_music_06_stop
	(print "***MUSIC: 030_music_06 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_06")
)
(script dormant 030_music_07_start
	(print "***MUSIC: 030_music_07 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_07" none 1.0)
)

;when prophet of truth starts speaking or after crest of the hill
(script dormant 030_music_07_stop
	(print "***MUSIC: 030_music_07 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_07")
)

;shoot with sniper rifle or at checkpoint past sniper tower
(script dormant 030_music_08_start
	(print "***MUSIC: 030_music_08 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_08" none 1.0)
)

;Mid of last encounter or death of wraith
(script dormant 030_music_08_stop
	(print "***MUSIC: 030_music_08 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_08")
)

;shoot with sniper rifle or at checkpoint past sniper tower
(script dormant 030_music_09_start
	(print "***MUSIC: 030_music_09 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_09" none 1.0)
)

;Barrier down
(script dormant 030_music_09_stop
	(print "***MUSIC: 030_music_09 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_09")
)

;shoot with sniper rifle or at checkpoint past sniper tower
(script dormant 030_music_10_start
	(print "***MUSIC: 030_music_10 start")
	(sound_looping_start "levels\solo\030_outskirts\music\030_music_10" none 1.0)
)

;Barrier down
(script dormant 030_music_10_stop
	(print "***MUSIC: 030_music_10 stop")
	(sound_looping_stop "levels\solo\030_outskirts\music\030_music_10")
)

;==============================================================
;==========Objectives==========================================
;==============================================================

(script dormant objective_1_set
       (sleep 30)
       (print "new objective set:")
       (print "Clear a path for marine forces away from the base.")
       (objectives_show_up_to 0)
       (cinematic_set_chud_objective obj_0)
       
)
(script dormant objective_1_clear
       (print "objective complete:")
       (print "Clear a path for marine forces away from the base.")
       (objectives_finish_up_to 0)
)

(script dormant objective_2_set
       (sleep 30)
       (print "new objective set:")
       (print "Clear a path into the town of Voi.")
       (objectives_show_up_to 1)
       (cinematic_set_chud_objective obj_1)
)
(script dormant objective_2_clear
       (print "objective complete:")
       (print "Clear a path into the town of Voi.")
       (objectives_finish_up_to 1)
)

;==============================================================
;==========Outskirts Achievements Checks============================
;==============================================================

(script continuous check_for_mind_the_gap_cheevo
	
	(if (= b_warthog1_has_crossed_gap FALSE)
		(begin
			(if (= (volume_test_object tv_bridge_oc6 (ai_vehicle_get_from_starting_location sq_elev_warthog1/warthog1)) TRUE)
				(begin
					(set b_warthog1_has_crossed_gap TRUE)
					(set s_vehicles_across_gap (+ s_vehicles_across_gap 1))
				)
			)
		)
	)
	
	(if (= b_warthog2_has_crossed_gap FALSE)
		(begin
			(if (= (volume_test_object tv_bridge_oc6 (ai_vehicle_get_from_starting_location sq_elev_warthog2/warthog2)) TRUE)
				(begin
					(set b_warthog2_has_crossed_gap TRUE)
					(set s_vehicles_across_gap (+ s_vehicles_across_gap 1))
				)
			)
		)
	)
	
	(if (= b_warthog3_has_crossed_gap FALSE)
		(begin
			(if (= (volume_test_object tv_bridge_oc6 (ai_vehicle_get_from_starting_location sq_elev_warthog3/warthog3)) TRUE)
				(begin
					(set b_warthog3_has_crossed_gap TRUE)
					(set s_vehicles_across_gap (+ s_vehicles_across_gap 1))
				)
			)
		)
	)
	
	(if (= b_warthog4_has_crossed_gap FALSE)
		(begin
			(if (= (volume_test_object tv_bridge_oc6 (ai_vehicle_get_from_starting_location sq_drive_warthog/drive_warthog01)) TRUE)
				(begin
					(set b_warthog4_has_crossed_gap TRUE)
					(set s_vehicles_across_gap (+ s_vehicles_across_gap 1))
				)
			)
		)
	)
	
	(if (= b_warthog5_has_crossed_gap FALSE)
		(begin
			(if (= (volume_test_object tv_bridge_oc6 (ai_vehicle_get_from_starting_location sq_pond_warthog/pond_warthog01)) TRUE)
				(begin
					(set b_warthog5_has_crossed_gap TRUE)
					(set s_vehicles_across_gap (+ s_vehicles_across_gap 1))
				)
			)
		)
	)
	
	(if (= b_warthog6_has_crossed_gap FALSE)
		(begin
			(if (= (volume_test_object tv_bridge_oc6 (ai_vehicle_get_from_starting_location sq_crash_warthog/crash_warthog01)) TRUE)
				(begin
					(set b_warthog6_has_crossed_gap TRUE)
					(set s_vehicles_across_gap (+ s_vehicles_across_gap 1))
				)
			)
		)
	)
	
	(if (= b_chopper1_has_crossed_gap FALSE)
		(begin
			(if (= (volume_test_object tv_bridge_oc6 (ai_vehicle_get_from_starting_location sq_crash_chopper01/starting_locations_0)) TRUE)
				(begin
					(set b_chopper1_has_crossed_gap TRUE)
					(set s_vehicles_across_gap (+ s_vehicles_across_gap 1))
				)
			)
		)
	)
	
	(if (= b_chopper2_has_crossed_gap FALSE)
		(begin
			(if (= (volume_test_object tv_bridge_oc6 (ai_vehicle_get_from_starting_location sq_crash_chopper02/starting_locations_0)) TRUE)
				(begin
					(set b_chopper2_has_crossed_gap TRUE)
					(set s_vehicles_across_gap (+ s_vehicles_across_gap 1))
				)
			)
		)
	)
	
	(if (>= s_vehicles_across_gap 4)
		(begin
			(achievement_grant_to_player 0 _achievement_ace_mind_the_gap)
			(achievement_grant_to_player 1 _achievement_ace_mind_the_gap)
			(achievement_grant_to_player 2 _achievement_ace_mind_the_gap)
			(achievement_grant_to_player 3 _achievement_ace_mind_the_gap)
			(sleep_forever)
		)
	)
	
)
