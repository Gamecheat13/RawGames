;====================================================================================================================================================================================================
;================================== GLOBAL VARIABLES ================================================================================================================================================
;====================================================================================================================================================================================================
(global boolean editor FALSE)

(global boolean g_play_cinematics TRUE)
(global short g_secondary_test 0)


(global short g_coop_simulation 0)
(global boolean debug TRUE)
;(global boolean dialogue TRUE)
;(global boolean music TRUE)
(global short m_progression 3)
(global boolean b_banshee_spawn TRUE)
(global short g_prev_mission 0)
(global short oni_wave_progression 0)
(global short m_sec_started 0)
(global short m_sec_complete 0)
(global boolean g_main_dialog_playing FALSE)
(global short g_mission_unlock 0)
(global short s_entry_timeout 900)
(global boolean m_sec_alpha FALSE)
(global boolean m_sec_beta FALSE)
(global boolean m_sec_gamma FALSE)
(global boolean m_sec_delta FALSE)
(global boolean m_alpha_complete FALSE)
(global boolean m_beta_complete FALSE)
(global boolean m_gamma_complete FALSE)
(global boolean m_delta_complete FALSE)
(global boolean m_coop_1st_dialog TRUE)
(global boolean m_coop_1st_dialog_done FALSE)
(global boolean m_sec_alpha01_start FALSE)
(global boolean m_sec_alpha02_start FALSE)
(global boolean m_sec_alpha03_start FALSE)
(global boolean m_sec_beta01_start FALSE)
(global boolean m_sec_beta02_start FALSE)
(global boolean m_sec_beta03_start FALSE)
(global boolean m_sec_gamma01_start FALSE)
(global boolean m_sec_gamma02_start FALSE)
(global boolean m_sec_gamma03_start FALSE)
(global boolean m_sec_delta01_start FALSE)
(global boolean m_sec_delta02_start FALSE)
(global boolean m_sec_delta03_start FALSE)
(global boolean mission_obj_gamma_1 FALSE)
(global boolean mission_obj_gamma_2 FALSE)
(global boolean mission_obj_gamma_3 FALSE)
(global boolean b_start_hub FALSE)
(global boolean b_training_complete FALSE)

(global short obj_control_bldg_a 0)
(global short obj_control_bldg_b 0)
(global short obj_control_bldg_c 0)
(global boolean g_bldg_c_elev_active FALSE)
(global boolean g_bldg_c_drones_attack FALSE)
(global short g_alpha_enc 0)
(global short g_beta_enc 0)
(global short g_gamma_enc 0)
(global short g_delta_enc 0)
(global boolean g_alpha_1_marine_safe FALSE)
(global boolean g_alpha_2_marine_safe FALSE)
(global boolean g_alpha_3_marine_safe FALSE)
(global boolean g_beta_1_marine_safe FALSE)
(global boolean g_beta_2_marine_safe FALSE)
(global boolean g_beta_3_marine_safe FALSE)
(global boolean g_gamma_1_marine_safe FALSE)
(global boolean g_gamma_complete FALSE)
(global boolean g_gamma_2_marine_safe FALSE)
(global boolean g_gamma_2_success FALSE)
(global boolean g_gamma_3_marine_safe FALSE)
(global boolean g_gamma_3_complete FALSE)

(global ai ai_bldgb_trooper02 none)
(global ai ai_bldgb_trooper04 none)
(global ai ai_bldga_fem02 none)
(global ai ai_bldga_trooper01 none)
(global ai ai_buck none)

(global short g_clumps_turret 20)
(global short g_clumps_banshee 1)
(global short g_banshee_type 30)
(global short g_falcon_type 20)

(global short prev_zone 0)
(global object reserve_vehicle00 none)
(global object reserve_vehicle01 none)
(global object reserve_vehicle02 none)
(global object reserve_vehicle03 none)

(global object obj_final_falcon01 none)
(global object obj_final_falcon02 none)
(global object obj_final_falcon03 none)

; insertion point index 
(global short g_insertion_index 0)

; navpoint variables
(global real g_nav_offset 0.55)

;====================================================================================================================================================================================================
;================================== BUILDING NAMES ================================================================================================================================================
;====================================================================================================================================================================================================

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;=============================== MISSION SCRIPT ==============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================

(script startup mission_startup
; fade out 
	;(fade_out 0 0 0 0)
	; === PLAYER IN WORLD TEST =====================================================
	(if (editor_mode)
		; if game is allowed to start 
		(fade_in 0 0 0 0)
		(start)		
	)
		; === PLAYER IN WORLD TEST =====================================================
)
(script static void start
	(print "starting")

	(set respawn_players_into_friendly_vehicle true)
	; coop initial profiles
	(if (game_is_cooperative)
		(begin
			(unit_add_equipment player0 player_coop_profile TRUE FALSE)
			(unit_add_equipment player1 player_coop_profile TRUE FALSE)
			(unit_add_equipment player2 player_coop_profile TRUE FALSE)
			(unit_add_equipment player3 player_coop_profile TRUE FALSE)
		)
	)
	
	; coop respawn profile
	(player_set_profile player_respawn_profile)
		
	(if (editor_mode)
		(fade_in 0 0 0 0)	
		(m52_cin_intro)
	)	
	(wake m52_mission)
	; switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) g_set_all)
		(begin
			;(if debug (print "switching zone sets..."))
			;(switch_zone_set m52_intro_cinematic)
			(sleep 1)
		)
	)
	; set insertion point index 
	(set g_insertion_index 1)

)
	
(script static boolean (g_coop_mode)
	(if 
		(or
			(>= g_coop_simulation 2)
			(>= (game_coop_player_count) 2)
		)
	TRUE)
)
			
(script static boolean (g_3coop_mode)
	(if 
		(or
			(>= g_coop_simulation 3)
			(>= (game_coop_player_count) 3)
		)
	TRUE)
)
			
(script dormant m52_mission
	;setup allegiance
	(switch_zone_set m52_000_secondary)	
	(ai_allegiance human player)
	(ai_allegiance player human)

	(flock_create banshees_1)
	(flock_create banshees_2)
	(flock_create banshees_3)
	(flock_create falcons_1)
	(flock_create falcons_2)
	(flock_create falcons_3)	
		
	(ai_designer_clump_perception_range 900)
	(zone_set_trigger_volume_enable zone_set:m52_010_a FALSE)
	(zone_set_trigger_volume_enable zone_set:m52_020_b FALSE)
	(zone_set_trigger_volume_enable zone_set:m52_030_c FALSE)
	(zone_set_trigger_volume_enable zone_set:m52_040_oni FALSE)
	(object_set_persistent dm_building_a_objective TRUE)
	(object_set_persistent dm_building_b_objective TRUE)
	(object_set_persistent dm_building_c_objective TRUE)		
	(wake f_ground_fx_ambient)
	(wake f_ground_fx_ambient_2)
;	(wake fire_damage_effect)				
	(if 
		(or
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) normal)
			(= (game_difficulty_get) legendary)
		)
	(object_create easy_terminal))
	(if (= (game_difficulty_get) legendary)(object_create legendary_terminal))	
	(sleep_until (>= g_insertion_index 1) 1)
		(cond
			((= g_insertion_index 1)
				(begin
					(wake banshee_spawn)
					(wake enc_mission)
				)
			)
			((= g_insertion_index 2)
				(begin
					(wake enc_mission)
				)
			)
		)	
	(object_destroy_folder building_a_control)
	(object_destroy_folder building_a_equipment)
	(object_destroy_folder building_a_weapons)
	(object_destroy_folder building_a_crates)
	(object_destroy_folder building_a_scenery)
	(object_destroy_folder bldg_a_interior_bodies)	
	(object_destroy_folder building_b_weapons)
	(object_destroy_folder building_b_equipment)
	(object_destroy_folder building_b_controls)
	(object_destroy_folder building_b_crates)
	(object_destroy_folder building_b_scenery)
	(object_destroy_folder bldg_b_interior_bodies)		
	(object_destroy_folder building_b_dm)
	(object_destroy_folder bldg_c_interior_bodies)
	(object_destroy_folder building_c_controls)
	(object_destroy_folder building_c_equipment)
	(object_destroy_folder building_c_weapons)
	(object_destroy_folder building_c_crates)
	(object_destroy_folder building_c_scenery)
	(object_destroy_folder building_c_vehicles)		
)

;===================================================================================================
;=====================ENCOUNTER_MAIN SCRIPTS =============================================
;===================================================================================================

(script dormant enc_mission
	;(print "enc_cell01")	
	(wake special_elite)	
	(wake md_000_initial)
	(wake m52_covenant_cruiser_vignette)				
	(wake m52_music_01)
	(wake m52_building_fall)
	(wake level_checkpoint)
	(f_player_loadout)
	
	(wake player0_evac_nanny)
	(wake md_001_falcon_evac)
	(wake low_flying_volume_player0)
	(wake vehicle_reserve00)
	(wake falcon_a1_nanny)
	(wake falcon_b1_nanny)
	(wake falcon_c1_nanny)
	(wake falcon_a2_nanny)
	(wake falcon_b2_nanny)
	(wake falcon_c2_nanny)
	(wake falcon_start1_nanny)
	(wake falcon_start2_nanny)					
	(wake player1_evac_nanny)
	(wake vehicle_reserve01)
	(wake low_flying_volume_player1)
	(wake vehicle_reserve02)
	(wake player2_evac_nanny)
	(wake low_flying_volume_player2)
	(wake vehicle_reserve03)
	(wake player3_evac_nanny)
	(wake low_flying_volume_player3)
	(wake global_mission_nav)
	(wake building_c_horrible_kill01)

	
	(ai_place sq_turret_00)
	(ai_set_clump sq_turret_00 12)
	
	(ai_place sq_turret_01)
	(ai_set_clump sq_turret_01 13)
	
	(ai_place sq_turret_02)
	(ai_set_clump sq_turret_02 13)
	
	(ai_place sq_turret_03)
	(ai_set_clump sq_turret_03 14)
	
	(ai_place sq_turret_04)
	(ai_set_clump sq_turret_04 10)
	
	(ai_place sq_turret_05)
	(ai_set_clump sq_turret_05 10)
	
	(ai_place sq_turret_06)
	(ai_set_clump sq_turret_06 10)
			
	(ai_place sq_turret_07)
	(ai_set_clump sq_turret_07 12)
			
	(ai_place sq_turret_08)
	(ai_set_clump sq_turret_08 11)
	
	(wake bldg_b_turret)
	(wake bldg_c_turret)
	
	; somewhat expensive ambient events!
	(if (= (g_3coop_mode) false)
		(begin
			(wake phantom_patrol)
			(wake pelican_patrol)
			(wake falcon_patrol)
		)
		(wake cheap_patrol)
	)
	(wake banshee_patrol_refresh)
	(weather_animate_force off 1 0)
	(wake weather_lightning)
	(cinematic_exit 052la_airlift TRUE)
	(if
		(= g_insertion_index 1)
		(sleep_until 
			(and
				(or
					(f_vehicle_pilot_seat player0)
					(f_vehicle_pilot_seat player1)
					(f_vehicle_pilot_seat player2)
					(f_vehicle_pilot_seat player3)
				)
				(volume_test_players tv_falcon_start)
			)
		5)
	)
	(sleep 90)
	(wake title_start)
	(set b_start_hub true)
	(sleep 1)
	(if (!= (game_difficulty_get) legendary)
		(begin
			(sleep 300)
			(wake player_training00)
			(wake player_training01)
			(wake player_training02)
			(wake player_training03)
		)
		;(print "YOU ARE LEET, NO TRAINING!")
	)
	(if (< g_secondary_test 5)
		(begin
			(wake sec_obj_alpha)
			(wake sec_obj_beta)
			(wake sec_obj_gamma)
			(wake sec_obj_delta)
		)
	)
	(sleep 90)
	(if (= (g_all_lost) FALSE)(game_save))

	(cond
		((= g_secondary_test 0)(primary_objectives))
		((= g_secondary_test 1) (test_secondary_objectives))
		((= g_secondary_test 2) (enc_building_a))
		((= g_secondary_test 3) (enc_building_b))
		((= g_secondary_test 4) (enc_building_c))
		((= g_secondary_test 5) (wake enc_oni))
	)
)

(script static void primary_objectives
	
	(if
		(or
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
			(= (g_coop_mode) true)
		)
		(begin
			(begin_random
				(enc_building_b)
				(enc_building_c)			
				(enc_building_a)
			)			
			(wake enc_oni)
		)		
		(begin
			(enc_building_a)
			(begin_random
				(enc_building_b)
				(enc_building_c)
			)
			(wake enc_oni)
		)
	)
)

(script dormant level_checkpoint
	(sleep_until
		(begin
			(sleep 1600)		
			;(print "LOOP-SAVING")	
			(if 
				(or
					(= (b_player_lost player0) false)
					(= (b_player_lost player1) false)
					(= (b_player_lost player2) false)
					(= (b_player_lost player3) false)
					;(not (f_all_hub_check))
				)
				(begin
					(game_save_no_timeout)
					;(print "looping checkpoint")
				)
			)
		FALSE)
	)
)

(global boolean b_player_in_mission FALSE)
(global boolean g_mission_nav_loop true)
(script dormant global_mission_nav
	(sleep_until
		(begin
			(if 
				(and
					(!= (current_zone_set_fully_active) 5)
					(f_all_hub_check)
					(= b_player_in_mission true)
					(not (volume_test_players tv_falcon_building_a))
					(not (volume_test_players tv_falcon_building_b))
					(not (volume_test_players tv_loc_building_c))
				)
				(cond
					((= g_mission_unlock 1) 
						(begin
							(set g_mission_nav_loop false)
							(f_unblip_flag cf_pri_bldg_b_reminder)
							(f_unblip_flag cf_pri_bldg_c_reminder)
							(f_blip_flag cf_pri_bldg_a_reminder 21)
						)
					)
					((= g_mission_unlock 2) 
						(begin
							(set g_mission_nav_loop false)
							(f_unblip_flag cf_pri_bldg_a_reminder)
							(f_unblip_flag cf_pri_bldg_c_reminder)	
							(f_blip_flag cf_pri_bldg_b_reminder 21)
						)
					)
					((= g_mission_unlock 3)
						(begin
							(set g_mission_nav_loop false)
							(f_unblip_flag cf_pri_bldg_a_reminder)
							(f_unblip_flag cf_pri_bldg_b_reminder)	
							(f_blip_flag cf_pri_bldg_c_reminder 21)
						)
					)
				)
				(begin
					(set g_mission_nav_loop true)
					(f_unblip_flag cf_pri_bldg_a_reminder)
					(f_unblip_flag cf_pri_bldg_b_reminder)
					(f_unblip_flag cf_pri_bldg_c_reminder)
				)
			)	
		false)
	30)
)

;===================================================================================================
;=====================ENCOUNTER_BRIDGE SCRIPTS =============================================
;===================================================================================================

(script static void enc_building_a
	(sleep_until (= g_main_dialog_playing false))
	(if (!= m_progression 0)
		(begin
			(wake m52_music_02)
			(sleep (* 30 (random_range 4 7)))		
			;(print "enc_building_a")
			(wake md_010_bldg_a)
			;(garbage_cleaning)							
			(sleep 10)
		 	(prepare_to_switch_to_zone_set m52_010_a)		 	
			(if (editor_mode) (switch_zone_set m52_010_a))
			;(data_mine_set_mission_segment "m52_route_to_building_a")
			(set b_player_in_mission true)			
			(wake bldg_a_nav_point)			
			(sleep_until 
				(and
					(= (current_zone_set_fully_active) 1)
					(= g_mission_unlock 1)
				)
			5)
			(sleep 5)	
			(device_set_power dm_bldg_a_door01 1)	
			(object_create_folder building_a_control)
			(object_create_folder building_a_equipment)
			(object_create_folder building_a_weapons)
			(object_create_folder building_a_crates)
			(object_create_folder building_a_scenery)
			(object_create_folder bldg_a_interior_bodies)
			(sleep 1)	
			(wake m52_bldg_a_dead_marines)							
			(wake enc_bldg_a_enemies)
			(wake md_010_bldg_a_end)
			(wake md_010_bldg_a_troopers)
			(wake md_010_bldg_a_complete)
			(wake enc_bldg_a_obj_control)			
			(sleep_until (volume_test_players tv_bldg_a_start) 1)
			(set g_music_m52_01 2)					
			;(data_mine_set_mission_segment "m52_building_a")
			(game_save)					
			; unlock bridge mission door here
			; wake global scripts 
			; wake vignettes
			; wake ai background threads 
			; wake music scripts 
			; start Objective Control checks
			(f_bldg_objective dm_building_a_objective dc_objective_a_switch)
			(if (> (ai_living_count gr_bldg_a) 15)(ai_erase gr_bldg_a_initial))
			(f_hud_obj_complete)
			(game_save)	
			(sleep_until (= (f_any_hub_check) true)5)
			(set b_player_in_mission false)
			(set g_mission_unlock 0)
			; waiting for all dudes to bolt
			(sleep_until (=	(f_all_hub_check) true)5 5400)	
			(f_zone_teleport_player0)	
			(f_zone_teleport_player1)	
			(f_zone_teleport_player2)		
			(f_zone_teleport_player3)							
			(set g_prev_mission 1)					
			(set m_progression (- m_progression 1))
			(set s_banshee_max 7)
			(start_ambient_patrol)
			(device_set_power dm_bldg_a_door01 0)
			(sleep 5)
			;(garbage_cleaning)
			(object_removal)						
			(if (= m_progression 0)	
					(wake falcon_friendly_final_battle)						
				;(if (= (g_3coop_mode) true)(ai_place gr_turrets)); I hate doing this, but perf dictates I have no choice
			)		
			(sleep 90)
			(game_save)
			(sleep 90)			
			; this tests two things: whether it's in 'test mode' or no more primary missions ready then it fires off the appropriate number of secondary objectives				
			(if (and (!= g_secondary_test 6)(> m_progression 0))
				(begin
					(if (= (g_3coop_mode) false)
						(sec_objective 1)
						(sec_objective 2)
					)
				)
			)
		)
	)	
)


(script dormant bldg_a_nav_point
	(sleep_until (>= obj_control_bldg_a 10) 5)
	(f_unblip_flag cf_bldg_a_ext)
	(sleep_until (>= obj_control_bldg_a 20) 5 3200)
	(if (< obj_control_bldg_a 20) (f_blip_flag cf_bldg_a_bridge 21))
	(sleep_until (>= obj_control_bldg_a 20) 5)		
	(f_unblip_flag cf_bldg_a_bridge)		
	(sleep_until (>= obj_control_bldg_a 60) 5 3200)
	(f_blip_object dc_objective_a_switch blip_interface)
	(sleep_until (<= (object_get_health dm_building_a_objective) 0)5)
	(wake bldg_a_navpoint_exit)
	(sleep_until (= (f_bsp_any_player 2) FALSE) 1)
	(sleep 1)
	(f_unblip_flag cf_bldg_a_ext)
	(f_unblip_flag cf_bldg_a_objective)
	(f_unblip_flag cf_bldg_a_bridge)
)

(script dormant bldg_a_navpoint_exit
	(branch
		(= (f_bsp_any_player 2) FALSE)
		(branch_abort)
	)
	(sleep 1200)
	(f_blip_flag cf_bldg_a_ext 21)
)

(script static void vignette_test
	(ai_allegiance human player)
	(ai_allegiance player human)
	(set obj_control_bldg_a 100)
	(wake md_010_bldg_a_troopers)
	(wake m52_a_vignette_cancel)
	(m52_a_vignette01)
	(m52_a_vignette02)		
	(m52_a_vignette03)
	(wake m52_a_vignette04)			
)

(script dormant enc_bldg_a_enemies
	; Initial Enemy Placement
	(sleep_until (volume_test_players tv_bldg_a_start) 1)
	(sleep 1)
	(ai_place sq_bldg_a_10)	
	(ai_place sq_bldg_a_01)
	(ai_place sq_bldg_a_02)
	(ai_place sq_bldg_a_03)
	(ai_place sq_bldg_a_06)
	(sleep_until (>= obj_control_bldg_a 13)5)
	(wake m52_bldg_a_outside_cleanup)		
	;(garbage_cleaning)	
	(ai_place sq_bldg_a_04)	
	(ai_place sq_bldg_a_05)
	(sleep_until (>= obj_control_bldg_a 20)5)	
	;(garbage_cleaning)
	(ai_disposable sq_bldg_a_01 TRUE)
	(ai_disposable sq_bldg_a_02 TRUE)
	(ai_disposable sq_bldg_a_03 TRUE)	
	(wake m52_a_vignette_cancel)
	(m52_a_vignette01)
	(m52_a_vignette02)		
	(m52_a_vignette03)
	(wake m52_a_vignette04)			
	(sleep 1)
	(ai_place sq_bldg_a_07)
	(ai_place sq_bldg_a_08)

	(ai_place sq_bldg_a_11)
;	(ai_place sq_bldg_a_12)
	(sleep_until (>= obj_control_bldg_a 30)5)
	(sleep_until (<= (object_get_health dm_building_a_objective) 0)5)
	(sleep 30)
	(device_set_power dm_bldg_a_door02 1)
	(ai_place sq_bldg_a_01_return)
	(ai_place sq_bldg_a_02_return)
	(ai_place sq_bldg_a_03_return)
	(wake m52_bldg_a_boss_kill)
	(if 
		(or
			(g_3coop_mode)
			(= (game_difficulty_get) legendary)
		)
		(ai_place sq_bldg_a_04_return)
	)
	(ai_place sq_bldg_a_05_return)
	(if 
		(or
			(g_3coop_mode)
			(= (game_difficulty_get) legendary)
		)
		(begin	
			(ai_place sq_bldg_a_06_return)
			(ai_place sq_bldg_a_07_return)
		)
	)
	(sleep_until (< (ai_living_count gr_bldg_a_jetpack) 1)5)
	(game_save_no_timeout)			
)

(script dormant m52_bldg_a_outside_cleanup
	(ai_erase gr_banshee)
	(if (= (g_3coop_mode) true)
		(begin
			(ai_erase gr_banshee)
			(set s_banshee_max 0)
			(f_banshee_force_max 0)
		)
		(begin
			(set s_banshee_max 4)
			(f_banshee_force_max 4)
		)		
	)	
	(erase_ambient_patrol)
	;(if (= (g_3coop_mode) true)(ai_erase gr_turrets)); I hate doing this, but perf dictates I have no choice
)

(script dormant m52_bldg_a_boss_kill
	(sleep_until 
		(or
			(=	(f_all_hub_check) true)
			(< (ai_living_count sq_bldg_a_02_return) 1)
		)
	5)
	(set g_music_m52_02 2)
)

(script static boolean b_engineer_escape
	(if
		(and 
			(= (unit_get_health sq_bldg_a_10) 1) 
			(<= obj_control_bldg_a 10)
			(<= (ai_task_status obj_bldg_a/top) 1)
		)
	true)
)

(script static boolean b_engineer_hide
	(if
		(and 
			(>= (unit_get_health sq_bldg_a_10) 0.5) 
			(<= obj_control_bldg_a 13)
			(>= (ai_task_count obj_bldg_a/lobby_mid) 3)
		)
	true)
)


(script dormant enc_bldg_a_obj_control
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_10) 1)
	(set obj_control_bldg_a 10)	
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_13) 1)
	(set obj_control_bldg_a 13)
	(game_save)		
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_17) 1)
	(set obj_control_bldg_a 17)		
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_20) 1)
	(set obj_control_bldg_a 20)
	(game_save)				
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_30) 1)
	(set obj_control_bldg_a 30)	
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_40) 1)
	(set obj_control_bldg_a 40)	
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_45) 1)
	(set obj_control_bldg_a 45)		
	(game_save)	
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_50) 1)
	(set obj_control_bldg_a 50)	
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_55) 1)
	(set obj_control_bldg_a 55)				
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_60) 1)
	(set obj_control_bldg_a 60)	
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_70) 1)
	(set obj_control_bldg_a 70)
	(game_save)	
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_75) 1)
	(set obj_control_bldg_a 75)
	(game_save)			
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_80) 1)
	(set obj_control_bldg_a 80)	
	(game_save)			
	(sleep_until (f_bsp_and_volume_check 2 tv_bldg_a_obj_control_100) 1)
	(set obj_control_bldg_a 100)
	(game_save)			

)


;===================================================================================================
;=====================ENCOUNTER_HUNTERS SCRIPTS =============================================
;===================================================================================================

(global boolean b_disco FALSE)
(global boolean b_disco_disco FALSE)

(script static void enc_building_b
	(sleep_until (= g_main_dialog_playing false))
	(if (!= m_progression 0)
		(begin
			(zone_set_trigger_volume_enable zone_set:m52_010_a FALSE)
			(zone_set_trigger_volume_enable zone_set:m52_030_c FALSE)						
			(prepare_to_switch_to_zone_set m52_020_b)		
			(wake m52_music_06)
			(wake m52_music_07)
			(sleep (* 30 (random_range 4 7)))					
			(wake md_020_bldg_b)						
			;(data_mine_set_mission_segment "m52_route_to_building_b")
			;(garbage_cleaning)			
			(wake enc_bldg_b_obj_control)							
			(sleep 10)								
			(set b_player_in_mission true)				
			(if (editor_mode) (switch_zone_set m52_020_b))		
			(wake bldg_b_nav_point)
			(wake disco_fever)
			(wake start_disco)			
			(wake enc_bldg_b_enemies)								
			(sleep_until 
				(and
					(= (current_zone_set_fully_active) 2)
					(= g_mission_unlock 2) 
				)
			5)
			(sleep 90)		
			(game_save)
			(sleep 90)
			(device_set_power dm_bldg_b_door01 1)
			(device_set_power dm_bldg_b_door02 1)	
			(object_create_folder building_b_weapons)
			(object_create_folder building_b_equipment)
			(object_create_folder building_b_controls)
			(object_create_folder building_b_crates)
			(object_create_folder building_b_scenery)
			(object_create_folder building_b_dm)
			(object_create_folder bldg_b_interior_bodies)	
			(if 
				(or
					(g_3coop_mode)
					(= (game_difficulty_get) heroic)
					(= (game_difficulty_get) legendary)
				)
				(object_destroy bldg_b_rl_ammo))					
			(wake md_020_bldg_b_end)		
			(sleep_until (volume_test_players tv_bldg_b_start) 1)		
			(set g_music_m52_01 2)
			(set g_music_m52_06 1)
			(game_save)				
			;(data_mine_set_mission_segment "m52_building_b")
			(sleep 5)
			(erase_ambient_patrol)														
			(f_bldg_objective dm_building_b_objective dc_objective_b_switch)	
			(wake bldg_b_music_script)
			(set g_music_m52_07 1)
			;(garbage_cleaning)
			;(ai_set_objective sq_bldg_b_trooper_01 obj_bldg_b_outside)	
			(f_hud_obj_complete)	
			(sleep_until (= (f_any_hub_check) true)5)
			; waiting for all dudes to bolt
			(start_ambient_patrol)
			(set b_player_in_mission false)
			(set g_mission_unlock 0)						
			(sleep_until (=	(f_all_hub_check) true)5 3600)	
			(f_zone_teleport_player0)	
			(f_zone_teleport_player1)	
			(f_zone_teleport_player2)		
			(f_zone_teleport_player3)														
			(set g_prev_mission 2)															
			(set m_progression (- m_progression 1))
			(device_set_power dm_bldg_b_door01 0)
			(device_set_power dm_bldg_b_door02 0)
			(sleep 5)
			;(garbage_cleaning)
			(object_removal)					
			(if (= m_progression 0)
					(wake falcon_friendly_final_battle)					
			)
			(sleep 90)			
			(game_save)
			; this tests two things: whether it's in 'test mode' or no more primary missions ready then it fires off the appropriate number of secondary objectives	
			(if (and (!= g_secondary_test 6)(> m_progression 0))
				(begin
					(if (= (g_3coop_mode) false)
						(sec_objective 1)
						(sec_objective 2)
					)
				)
			)		
		)
	)							
)

(script dormant bldg_b_turret
	(sleep_until 
		(or
			(= (current_zone_set_fully_active) 2)
			(= g_mission_unlock 2) 
			(f_hub_and_radius_check cf_bldg_b_ext01 100)
		)5)

	(ai_place sq_bldg_b_turret01)
	(ai_place sq_bldg_b_turret02)

	(ai_set_clump sq_bldg_b_turret01 g_clumps_turret)
	(ai_set_clump sq_bldg_b_turret02 g_clumps_turret)		
)

(script dormant bldg_b_music_script
	(sleep_until 
		(or
			(< (ai_living_count gr_bldg_b) 1)
			(= (f_all_hub_check) true)
		)
	5)
	(set g_music_m52_06 3)
)

(script dormant bldg_b_nav_point

	(sleep_until 
		(or 
			(volume_test_players tv_bldg_b_interior_start)
			(>= obj_control_bldg_b 10)
		)
	1)
	(sleep_until  (<= (ai_living_count gr_bldg_b) 0)5 2400)

	(sleep 60)
	(f_blip_object dc_objective_b_switch blip_interface)
	;(wake hud_object_bldg_b_obj)
	
	(sleep_until (<= (object_get_health dm_building_b_objective) 0)5)

	(wake bldg_b_navpoint_exit)
	(sleep_until (= (f_bsp_any_player 3) FALSE) 1)
	(sleep 1)
	(f_unblip_flag cf_bldg_b_ext)		
)


(script dormant bldg_b_navpoint_exit
	(branch
		(= (f_bsp_any_player 3) FALSE)
		(branch_abort)
	)
	(sleep 1200)
	(f_blip_flag cf_bldg_b_ext 21)
)

(script dormant enc_bldg_b_enemies
	(device_set_power dm_bldg_b_enemy_door 1)
	(ai_place sq_bldg_b_03)
	(ai_force_active sq_bldg_b_03 TRUE)
	(ai_place sq_bldg_b_04)
	(ai_force_active sq_bldg_b_04 TRUE)
	(ai_place sq_bldg_b_05)
	(ai_force_active sq_bldg_b_05 TRUE)
	(ai_place sq_bldg_b_06)
	(ai_force_active sq_bldg_b_06 TRUE)
	(sleep_until (volume_test_players tv_bldg_b_interior_start)5)
	;(garbage_cleaning)
	(object_destroy disco_switch01)		
	(if (= b_disco false)
		(begin
			(ai_place sq_bldg_b_01)			
			(ai_place sq_bldg_b_02)
			(ai_place sq_bldg_b_07)			
			(ai_place sq_bldg_b_08)					
			(ai_place sq_bldg_b_trooper_01)
			(ai_place sq_bldg_b_trooper_02) 
			(ai_place sq_bldg_b_trooper_03)
			(if 
				(or
					(not (g_3coop_mode))
					(!= (game_difficulty_get) legendary)
				)
			(ai_place sq_bldg_b_trooper_04))		 						
			(ai_cannot_die sq_bldg_b_trooper_01 TRUE)
			(set ai_bldgb_trooper02 sq_bldg_b_trooper_01/02)
			(set ai_bldgb_trooper04 sq_bldg_b_trooper_01/04 )			
			(wake enc_bldg_b_troopers_damage)
			(wake md_020_bldg_b_troopers)
		)
	)
	
	;(print "achievement: club errera reference")
	(submit_incident_with_cause_player "errera_achieve" player0)
	(submit_incident_with_cause_player "errera_achieve" player1)
	(submit_incident_with_cause_player "errera_achieve" player2)
	(submit_incident_with_cause_player "errera_achieve" player3)	
	
	(sleep_until (<= (object_get_health dm_building_b_objective) 0)5)
	(ai_erase gr_bldg_b_outside)
	(sleep_until (= (f_bsp_any_player 3) FALSE) 1)
	(device_one_sided_set dm_bldg_b_enemy_door true)
	(ai_disposable sq_bldg_b_trooper_01 true) 
)
(script dormant start_disco
	(sleep_until (= b_disco true)5)
	(prepare_to_switch_to_zone_set m52_020_b)
	(sleep 210)
	(switch_zone_set m52_020_b)	
	(sleep_until (= (current_zone_set_fully_active) 2))
	(sleep 30)
	(ai_erase gr_bldg_b_outside)	
	(sleep_forever m52_music_06)
	(sleep_forever m52_music_07)
	(kill_music)
	(sleep 5)
	(object_destroy bldg_b_rocket)			
	(object_create disco_music_loop)									
	(ai_place gr_bldg_b_disco)
	;(ai_place gr_b_disco_help)
	(wake shake01)	
	(sleep_until (volume_test_players tv_bldg_b_start) 1)
	(sleep_until (volume_test_players tv_bldg_b_interior_start)5)
	(wake stop01)
)
(script dormant disco_fever
	(object_create disco_switch01)	
	(sleep_until (= (device_get_position disco_switch01) 1)5) 
	(object_create disco_switch02)
	(set b_disco true)
	(wake disco_achievement_check)
	(sleep_until (= (device_get_position disco_switch02) 1)5)
	(sleep_forever shake01)
	(object_destroy disco_music_loop)	
	(sleep 30)	
	(set b_disco_disco true)
	(wake disco_alt_achievement_check)
	(object_create disco_music_alt)
	(wake shake02)
)

(script dormant disco_achievement_check
	(sleep_until 
		(and
			(= b_disco true)
			(volume_test_players tv_bldg_b_interior_start)
		)
	5)
	
	;(print "achievement: dj brute")
	(submit_incident_with_cause_player "dj_achieve" player0)
	(submit_incident_with_cause_player "dj_achieve" player1)
	(submit_incident_with_cause_player "dj_achieve" player2)
	(submit_incident_with_cause_player "dj_achieve" player3)	
	
)

(script dormant disco_alt_achievement_check
	(sleep_until 
		(and
			(= b_disco_disco true)
			(volume_test_players tv_bldg_b_interior_start)
		)
	5)
	
	;(print "achievement: siege of madrigal")
	(submit_incident_with_cause_player "madrigal_achieve" player0)
	(submit_incident_with_cause_player "madrigal_achieve" player1)
	(submit_incident_with_cause_player "madrigal_achieve" player2)
	(submit_incident_with_cause_player "madrigal_achieve" player3)	

)

(script static void dance
	(object_create disco_music_loop)
	(ai_place gr_bldg_b_disco)
	;(ai_place gr_b_disco_help)
	(wake shake01)
	(wake stop01)
)
(script static void dancin
	(object_create disco_music_alt)
	(ai_place gr_bldg_b_disco)
	;(ai_place gr_b_disco_help)
	(wake shake01)
	(wake stop01)
)
(global object_list shake_var (players))
(global short g_beat 15)

(script dormant shake01
	(set shake_var (ai_actors gr_bldg_b_disco))
	(sleep_until
		(begin
			(begin_random
				(unit_play_random_ping (unit (list_get shake_var 0)))
				(unit_play_random_ping (unit (list_get shake_var 1)))
				(unit_play_random_ping (unit (list_get shake_var 2)))
				(unit_play_random_ping (unit (list_get shake_var 3)))
				(unit_play_random_ping (unit (list_get shake_var 4)))
				(unit_play_random_ping (unit (list_get shake_var 5)))
				(unit_play_random_ping (unit (list_get shake_var 6)))
				(unit_play_random_ping (unit (list_get shake_var 7)))
				(unit_play_random_ping (unit (list_get shake_var 8)))
				(unit_play_random_ping (unit (list_get shake_var 9)))
				(unit_play_random_ping (unit (list_get shake_var 10)))
				(unit_play_random_ping (unit (list_get shake_var 11)))
				(unit_play_random_ping (unit (list_get shake_var 12)))
				(unit_play_random_ping (unit (list_get shake_var 13)))
				(unit_play_random_ping (unit (list_get shake_var 14)))
				(unit_play_random_ping (unit (list_get shake_var 15)))
				(unit_play_random_ping (unit (list_get shake_var 16)))
				(unit_play_random_ping (unit (list_get shake_var 17)))				
			)
		FALSE)
	g_beat)
)
(script dormant shake02
	(set shake_var (ai_actors gr_bldg_b_disco))
	(sleep_until
		(begin
			(begin_random
				(unit_play_random_ping (unit (list_get shake_var 0)))
				(unit_play_random_ping (unit (list_get shake_var 1)))
				(unit_play_random_ping (unit (list_get shake_var 2)))
				(unit_play_random_ping (unit (list_get shake_var 3)))
				(unit_play_random_ping (unit (list_get shake_var 4)))
				(unit_play_random_ping (unit (list_get shake_var 5)))
				(unit_play_random_ping (unit (list_get shake_var 6)))
				(unit_play_random_ping (unit (list_get shake_var 7)))
				(unit_play_random_ping (unit (list_get shake_var 8)))
				(unit_play_random_ping (unit (list_get shake_var 9)))
				(unit_play_random_ping (unit (list_get shake_var 10)))
				(unit_play_random_ping (unit (list_get shake_var 11)))
				(unit_play_random_ping (unit (list_get shake_var 12)))
				(unit_play_random_ping (unit (list_get shake_var 13)))
				(unit_play_random_ping (unit (list_get shake_var 14)))
				(unit_play_random_ping (unit (list_get shake_var 15)))
				(unit_play_random_ping (unit (list_get shake_var 16)))
				(unit_play_random_ping (unit (list_get shake_var 17)))				
			)
		FALSE)
	g_beat)
)

(script dormant stop01
	(sleep_until 
		(or
			(< (ai_strength gr_bldg_b_disco) 1)
			(<= (object_get_health dm_building_b_objective) 0)
		)
	5)
	(object_destroy disco_music_alt)
	(object_destroy disco_music_loop)	
	(sleep 15)	
	(sound_impulse_start sound\levels\solo\m52\sound_scenery\disco_scratch_oneshot scratch 1)
	(sleep_forever shake01)
	(sleep 90)
	(set dance_stop TRUE)
	(ai_magically_see_object gr_bldg_b_disco player0)
	(ai_magically_see_object gr_bldg_b_disco player1)
	(ai_magically_see_object gr_bldg_b_disco player2)
	(ai_magically_see_object gr_bldg_b_disco player3)			
)

(global boolean dance_stop FALSE)

(script command_script cs_dancing01
	(cs_enable_looking FALSE)
	(cs_enable_moving FALSE)
	(cs_enable_targeting FALSE)
	(sleep_until 
		(or
			(= dance_stop TRUE)
			(<= (object_get_health dm_building_b_objective) 0)
		)
	5)
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
)

(script command_script cs_working01
	(cs_enable_looking FALSE)
	(cs_enable_moving FALSE)
	(cs_enable_targeting FALSE)
	(cs_stow true)	
	(begin_random_count 1
		(cs_custom_animation_loop objects\characters\brute\brute "m52_brute_bar:clean" true)
		(cs_custom_animation_loop objects\characters\brute\brute "m52_brute_bar:idle" true)
	)
	(sleep_until 
		(or
			(= dance_stop TRUE)
			(<= (object_get_health dm_building_b_objective) 0)
		)
	5)
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
)
(script command_script cs_dj01
	(cs_enable_looking FALSE)
	(cs_enable_moving FALSE)
	(cs_enable_targeting FALSE)
	(cs_stow true)
		(sleep_until
			(begin
				(begin_random_count 1
					(cs_custom_animation objects\characters\brute\brute "m52_brute_dj:idle" true)
					(cs_custom_animation objects\characters\brute\brute "m52_brute_dj:idle:var1" true)
				)
			(or
				(= dance_stop TRUE)
				(<= (object_get_health dm_building_b_objective) 0)
		))
	1)
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
)
(script dormant enc_bldg_b_troopers_damage
	(sleep_until (volume_test_players tv_bldg_b_troopers_damage) 5 600)
	(ai_cannot_die sq_bldg_b_trooper_01 false)
	(ai_cannot_die sq_bldg_b_trooper_02 false)
	(ai_cannot_die sq_bldg_b_trooper_03 false)
	(ai_cannot_die sq_bldg_b_trooper_04 false)		
)

(script dormant enc_bldg_b_obj_control
	(sleep_until (f_bsp_and_volume_check 3 tv_bldg_b_obj_control_10) 1)
	(set obj_control_bldg_b 10)
	(sleep_until (f_bsp_and_volume_check 3 tv_bldg_b_obj_control_20) 1)
	(set obj_control_bldg_b 20)
	(game_save)	
	(sleep_until (f_bsp_and_volume_check 3 tv_bldg_b_obj_control_30) 1)
	(set obj_control_bldg_b 30)
	(sleep_until (f_bsp_and_volume_check 3 tv_bldg_b_obj_control_40) 1)
	(set obj_control_bldg_b 40)	
	(game_save)	
)

;===================================================================================================
;=====================ENCOUNTER_BUGGERS SCRIPTS =============================================
;===================================================================================================

(script static void enc_building_c
	(sleep_until (= g_main_dialog_playing false))
	(if (!= m_progression 0)
		(begin
			(wake m52_music_03)
			(wake m52_music_04)
			(wake m52_music_05)
			(sleep (* 30 (random_range 4 7)))				
			(wake md_030_bldg_c)
			(wake enc_bldg_c_enemies)
			(wake enc_bldg_c_obj_control)			
			;(garbage_cleaning)								
			(sleep 10)					
			(zone_set_trigger_volume_enable zone_set:m52_020_b FALSE)
			(zone_set_trigger_volume_enable zone_set:m52_010_a FALSE)			
			(prepare_to_switch_to_zone_set m52_030_c)
			(set b_player_in_mission true)			
			(if (editor_mode) (switch_zone_set m52_030_c))
			;(data_mine_set_mission_segment "m52_route_to_building_c")								
			(wake bldg_c_nav_point)			
			(sleep_until 
				(and
					(= (current_zone_set_fully_active) 3)
					(= g_mission_unlock 3) 
				)
			5)
			(sleep 90)
			(game_save)	
			(sleep 5)
			(wake building_c_elev01)
			(wake building_c_elev02)
			(wake elevator_no_spawn00)
			(wake elevator_no_spawn01)
			(wake elevator_no_spawn02)
			(wake elevator_no_spawn03)
			(sleep_until (volume_test_players tv_bldg_c_start) 1)
			(set g_music_m52_01 2)
			(set g_music_m52_03 1)	
			;(data_mine_set_mission_segment "m52_building_c")									
			(game_save)	
			(sleep_until (volume_test_players tv_bldg_c_int_mission_start) 1)
			;(garbage_cleaning)
			(wake m52_bldg_c_outside_cleanup)
			(object_create_folder building_c_controls)
			(object_create_folder building_c_equipment)
			(object_create_folder building_c_weapons)
			(object_create_folder building_c_crates)
			(object_create_folder building_c_scenery)				
			(object_create_folder bldg_c_interior_bodies)
			(object_create_folder building_c_vehicles)
			(sleep 1)
			(wake m52_bldg_c_dead_marines)
			(f_bldg_objective dm_building_c_objective dc_objective_c_switch)
			(sleep_forever m52_music_03)
			(set g_music_m52_04 1)
			;(garbage_cleaning)	
			(game_save)		
			(f_hud_obj_complete)			
			(wake md_030_bldg_c_end)
			(wake md_030_bldg_c_exit)
			(sleep_until (= (f_any_hub_check) true)5)
			(set b_player_in_mission false)	
			(set g_mission_unlock 0)				
			; waiting for all dudes to bolt
			(sleep_until (=	(f_all_hub_check) true)5 3600)
			(if (!= g_music_m52_04 0)
				(begin
					(m52_really_stop)
					(set g_music_m52_04 2)
				)
			)
			(f_zone_teleport_player0)	
			(f_zone_teleport_player1)	
			(f_zone_teleport_player2)		
			(f_zone_teleport_player3)													
			(set g_prev_mission 3)	
			(game_save)												
			(device_set_power dc_bldg_c_switch01a 0)
			(device_set_power dc_bldg_c_switch02a	0)	
			(set m_progression (- m_progression 1))
			(set s_banshee_max 7)
			(start_ambient_patrol)
			(device_set_position dm_bldg_c_door01a 0)
			(device_set_position dm_bldg_c_door02a 0) 
			(sleep 5)
			(sleep_forever elevator_no_spawn00)
			(sleep_forever elevator_no_spawn01)
			(sleep_forever elevator_no_spawn02)
			(sleep_forever elevator_no_spawn03)									
			(sleep 10)
			(game_safe_to_respawn true)
;			(game_safe_to_respawn true player1)		
;			(game_safe_to_respawn true player2)		
;			(game_safe_to_respawn true player3)
			(set g_music_m52_05 1)
			(object_removal)
			;(garbage_cleaning)											
			(if (= m_progression 0)
				(begin
					(wake falcon_friendly_final_battle)
					(ai_erase gr_bldg_c_buggers)
					(ai_erase sq_bldg_c_scared_marine)																
				)
			)
			(sleep 90)
			; this tests two things: whether it's in 'test mode' and no more primary missions then it fires off the appropriate number of secondary objectives		
			(if (and (!= g_secondary_test 6)(> m_progression 0))
				(begin
					(if (= (g_3coop_mode) false)
						(sec_objective 1)
						(sec_objective 2)
					)
				)
			)
		)
	)				
)
(script dormant bldg_c_turret
	(sleep_until 
		(or
			(= (current_zone_set_fully_active) 3)
			(= g_mission_unlock 3) 
			(f_hub_and_radius_check cf_bldg_c_ext 100)
		)5)

	(ai_place sq_bldg_c_turret01)
	(ai_place sq_bldg_c_turret02)	
	
	(ai_set_clump sq_bldg_c_turret01 g_clumps_turret)
	(ai_set_clump sq_bldg_c_turret02 g_clumps_turret)		
)

(script dormant enc_bldg_c_obj_control
	(sleep_until (volume_test_players tv_bldg_c_obj_control_10) 1)
	(if (< obj_control_bldg_c 10) (set obj_control_bldg_c 10))
	(sleep_until (volume_test_players tv_bldg_c_obj_control_20) 1)
	(if (< obj_control_bldg_c 20) (set obj_control_bldg_c 20))
	(game_save)		
	(sleep_until (volume_test_players tv_bldg_c_obj_control_30) 1)
	(if (< obj_control_bldg_c 30) (set obj_control_bldg_c 30))
	(sleep_until (volume_test_players tv_bldg_c_obj_control_40) 1)
	(if (< obj_control_bldg_c 40) (set obj_control_bldg_c 40))
	(game_save)	
	(sleep_until 
		(or
			(volume_test_players tv_bldg_c_obj_control_50)
			(volume_test_players tv_bldg_c_obj_control_50a)
		) 1)
	(if (< obj_control_bldg_c 50) (set obj_control_bldg_c 50))
	(sleep_until (volume_test_players tv_bldg_c_obj_control_60) 1)
	(if (< obj_control_bldg_c 60) (set obj_control_bldg_c 60))
	(game_save)	
)

(script dormant bldg_c_nav_point
	(sleep_until (volume_test_players tv_bldg_c_start) 1)
	(sleep 5)				
	(f_unblip_flag cf_bldg_c_ext)
	(sleep 90)	
	(f_blip_flag cf_bldg_c_entrance 21)	
	(sleep_until (volume_test_players tv_bldg_c_elevator) 1)
	(sleep 90)
	(f_unblip_flag cf_bldg_c_ext)	
	(f_unblip_flag cf_bldg_c_entrance)	
	(sleep_until 
		(or
			(volume_test_players tv_bldg_c_help_vol01)
			(volume_test_players tv_bldg_c_help_vol02)
		)
	1)
	(game_save)	
	(f_blip_object dc_objective_c_switch blip_interface)
	(sleep_until (<= (object_get_health dm_building_c_objective) 0)5)

	(if (= (device_get_position dm_bldg_c_elev01) 1)(f_blip_object dc_bldg_c_switch01c blip_interface))
	(if (= (device_get_position dm_bldg_c_elev02) 1)(f_blip_object dc_bldg_c_switch02c blip_interface))	
	(f_unblip_flag cf_bldg_c_ext)	
	
	(sleep_until 
		(or
			(and
				(< (device_get_position dm_bldg_c_elev01) 1)
				(> (device_get_position dm_bldg_c_elev01) 0)
			)
			(and
				(< (device_get_position dm_bldg_c_elev02) 1)
				(> (device_get_position dm_bldg_c_elev02) 0)
			)
			(= (f_bsp_any_player 4) FALSE)				
		)
	5)
	(f_unblip_object dc_bldg_c_switch01c)		
	(f_unblip_object dc_bldg_c_switch02c)	
	(f_unblip_flag cf_bldg_c_elev)	
	(f_unblip_flag cf_bldg_c_entrance)		
	(f_unblip_flag cf_bldg_c_ext)	
	(f_unblip_flag cf_bldg_c_obj)		
)
(script dormant enc_bldg_c_enemies
	(sleep_until (volume_test_players tv_near_bldg_c) 1)
	(kill_volume_disable kill_bldg_c_door_ext02)
	(sleep 1)			
	(ai_place sq_bldg_c_01)
	(ai_force_active sq_bldg_c_01 TRUE)		
	(ai_place sq_bldg_c_02)
	(ai_force_active sq_bldg_c_02 TRUE)
	(ai_place sq_bldg_c_03)
	(ai_force_active sq_bldg_c_03 TRUE)
	(ai_place sq_bldg_c_04)
	(ai_force_active sq_bldg_c_04 TRUE)
	(ai_place sq_bldg_c_05)
	(ai_force_active sq_bldg_c_05 TRUE)
	(ai_place sq_bldg_c_06)		
	(ai_force_active sq_bldg_c_06 TRUE)
	(wake bldg_c_ext_door02)
	(sleep_until (= (current_zone_set_fully_active) 3) 1)
	(wake bldg_c_scary_vig)	
	(wake bldg_c_scary_enc01)
	(wake bldg_c_scary_enc02)
	(wake bldg_c_scary_enc03)		
	(ai_force_active sq_bldg_c_01 FALSE)	
	(ai_force_active sq_bldg_c_02 FALSE)
	(ai_force_active sq_bldg_c_03 FALSE)
	(ai_force_active sq_bldg_c_04 FALSE)
	(ai_force_active sq_bldg_c_05 FALSE)	
	(ai_force_active sq_bldg_c_06 FALSE)	
	(sleep_until (<= (object_get_health dm_building_c_objective) 0)5)
	(ai_erase gr_bldg_c_outside)	
	(ai_disregard (ai_actors sq_bldg_c_scared_marine) false)
	(ai_erase sq_bldg_c_bugger_scary_01)
	(ai_erase sq_bldg_c_bugger_scary_02)
	(ai_erase sq_bldg_c_bugger_scary_03)
	(ai_erase sq_bldg_c_bugger_scary_04)			
	(wake bldg_c_bugger_clump00)		
	(wake bldg_c_bugger_clump01)	
	(wake bldg_c_bugger_clump02)	
	(wake bldg_c_bugger_clump03)
	(wake bldg_c_bugger_clump04)
	(wake bldg_c_bugger_clump05)
	(wake bldg_c_bugger_clump06)	
	(wake bldg_c_bugger_clump07)
	(wake bldg_c_bugger_clump08)	
	(wake bldg_c_bugger_clump09)		
	(sleep 1)
	(sleep_until
		(and 
			(script_finished bldg_c_bugger_clump01)
			(script_finished bldg_c_bugger_clump03)
			(script_finished bldg_c_bugger_clump05)
			(script_finished bldg_c_bugger_clump07)
			(script_finished bldg_c_bugger_clump09)								
		)
	5 150)
	;(ai_kill sq_bldg_c_scared_marine)
	(wake bugger_respawner)
	;(ai_kill sq_bldg_c_scared_marine)
	(sleep_until (= (f_bsp_any_player 4) FALSE) 1)
	(sleep_forever bugger_respawner)
)

(script dormant m52_bldg_c_outside_cleanup
	(set s_banshee_max 4)	
	(f_banshee_force_max 4)
	(erase_ambient_patrol)
)

(script dormant bldg_c_ext_door02
	(sleep 120)
	(device_set_power dm_bldg_c_ext02 0)	
	(device_set_position dm_bldg_c_ext02 0)
	(kill_volume_enable kill_bldg_c_door_ext02)
)
(script dormant bldg_c_scary_vig
	(sleep_until (volume_test_players tv_bldg_c_scary_start01)5)
	(ai_place sq_bldg_c_scared_marine)
	(set ai_crazy sq_bldg_c_scared_marine)
	(ai_disregard (ai_actors sq_bldg_c_scared_marine) true)
)

(script dormant bldg_c_scary_enc01
	(branch
		(or
			(volume_test_players tv_bldg_c_scary_start02)
			(volume_test_players tv_bldg_c_scary_start03)
			(volume_test_players tv_bldg_c_scary_start04)
		)
		(branch_abort)
	)
	(sleep_until (volume_test_players tv_bldg_c_scary_start01)5)
	(ai_place sq_bldg_c_bugger_scary_01)
	(ai_place sq_bldg_c_bugger_scary_02)
	(ai_force_full_lod sq_bldg_c_bugger_scary_01)
	(ai_force_full_lod sq_bldg_c_bugger_scary_02)		
)
(script dormant bldg_c_scary_enc02
	(branch
			(volume_test_players tv_bldg_c_scary_start04)
		(branch_abort)
	)
	(sleep_until (volume_test_players tv_bldg_c_scary_start02)5)
	(ai_place sq_bldg_c_bugger_scary_03)
	(ai_force_full_lod sq_bldg_c_bugger_scary_03)
)
(script dormant bldg_c_scary_enc03
	(branch
		(volume_test_players tv_bldg_c_scary_start04)
		(branch_abort)
	)
	(sleep_until (volume_test_players tv_bldg_c_scary_start03)5)
	(ai_place sq_bldg_c_bugger_scary_04)
	(ai_force_full_lod sq_bldg_c_bugger_scary_04)
)

(script command_script cs_bldg_c_bugger_scary01
	(cs_enable_moving false)
	(cs_enable_looking false)
	(cs_enable_targeting false)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_dialogue false)
	(ai_cannot_die ai_current_actor true)
	(sleep_until 
		(or
			(volume_test_players tv_bldg_c_scary01)
			(objects_can_see_object (players) (ai_get_object sq_bldg_c_bugger_scary_01) 40)
		)
	1)
	;(cs_enable_moving true)	
	(cs_go_to sd_bldg_c_bugger_scary/p0)
	(ai_erase ai_current_actor)
)
(script command_script cs_bldg_c_bugger_scary02
	(cs_enable_moving false)
	(cs_enable_looking false)
	(cs_enable_targeting false)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_dialogue false)
	(ai_cannot_die ai_current_actor true)
	(sleep_until 
		(or
			(volume_test_players tv_bldg_c_scary02)
			(objects_can_see_object (players) (ai_get_object sq_bldg_c_bugger_scary_02) 40)
		)
	1)
	;(cs_enable_moving true)	
	(cs_go_to sd_bldg_c_bugger_scary/p1)
	(ai_erase ai_current_actor)
)
(script command_script cs_bldg_c_bugger_scary03
	(cs_enable_moving false)
	(cs_enable_looking false)
	(cs_enable_targeting false)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_dialogue false)
	(ai_cannot_die ai_current_actor true)
	(sleep_until 
		(or
			(volume_test_players tv_bldg_c_scary03)
			(objects_can_see_object (players) (ai_get_object sq_bldg_c_bugger_scary_03) 40)
		)
	1)
	;(cs_enable_moving true)	
	(cs_go_to sd_bldg_c_bugger_scary/p2)
	(ai_erase ai_current_actor)
)
(script command_script cs_bldg_c_bugger_scary04
	(cs_enable_moving false)
	(cs_enable_looking false)
	(cs_enable_targeting false)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_dialogue false)
	(ai_cannot_die ai_current_actor true)
	(sleep_until 
		(or
			(volume_test_players tv_bldg_c_scary04)
			(objects_can_see_object (players) (ai_get_object sq_bldg_c_bugger_scary_04) 40)
		)
	1)
	(cs_enable_moving true)	
	(cs_go_to sd_bldg_c_bugger_scary/p3)
	(ai_erase ai_current_actor)
)

(script dormant bldg_c_bugger_clump00
	(sleep (random_range 5 15))
	(f_bugger_vent_exit sq_bldg_c_bugger_00 v_bugger_vent_00)
)
(script dormant bldg_c_bugger_clump01
	(sleep (random_range 5 15))
	(f_bugger_vent_exit sq_bldg_c_bugger_01 v_bugger_vent_01)	
)
(script dormant bldg_c_bugger_clump02
	(sleep (random_range 5 15))
	(f_bugger_vent_exit sq_bldg_c_bugger_02 v_bugger_vent_02)			
)
(script dormant bldg_c_bugger_clump03
	(sleep (random_range 5 15))
	(f_bugger_vent_exit sq_bldg_c_bugger_03 v_bugger_vent_03)				
)
(script dormant bldg_c_bugger_clump04
	(sleep (random_range 5 15))
	(f_bugger_vent_exit sq_bldg_c_bugger_04 v_bugger_vent_04)		
)
(script dormant bldg_c_bugger_clump05
	(sleep (random_range 5 15))
	(f_bugger_vent_exit sq_bldg_c_bugger_05 v_bugger_vent_05)
)
(script dormant bldg_c_bugger_clump06
	(sleep (random_range 5 15))
	(f_bugger_vent_exit sq_bldg_c_bugger_06 v_bugger_vent_06)
)
(script dormant bldg_c_bugger_clump07
	(sleep (random_range 5 15))
	(f_bugger_vent_exit sq_bldg_c_bugger_07 v_bugger_vent_07)
)
(script dormant bldg_c_bugger_clump08
	(sleep (random_range 5 15))
	(f_bugger_vent_exit sq_bldg_c_bugger_08 v_bugger_vent_08)	
)
(script dormant bldg_c_bugger_clump09
	(sleep (random_range 5 15))
	(f_bugger_vent_exit sq_bldg_c_bugger_09 v_bugger_vent_09)
)

(script command_script cs_bugger_swoop
	(cs_custom_animation objects\characters\bugger\bugger "flight:pistol:vent_exit" true)
)

(script static void (f_bugger_vent_exit (ai bugger) (vehicle emitter))
	(ai_place bugger)
	(unit_enter_vehicle_immediate bugger emitter "vent")
	;(vehicle_load_magic (ai_get_object bugger) "vent" emitter)
	(sleep (random_range 5 15))
	(unit_open emitter)	
	(ai_vehicle_exit bugger)
	(sleep 30)
	(unit_close emitter)	
)

(script command_script cs_bugger_kill_marine
	(if (> (ai_living_count sq_bldg_c_scared_marine) 0)
		(begin
			(cs_fly_by sd_bldg_c_bugger_scary/p9)
			(cs_fly_by sd_bldg_c_bugger_scary/p6)
			(cs_fly_by sd_bldg_c_bugger_scary/p7)
			(cs_fly_by sd_bldg_c_bugger_scary/p8)	
			(cs_enable_targeting true)
			(sleep_until (< (ai_living_count sq_bldg_c_scared_marine) 1))
			(cs_enable_moving true)
			(cs_enable_looking true)
			(cs_enable_targeting true)				
			;(cs_approach (object_get_ai sq_bldg_c_scared_marine) 2 1000 1000)
		)
	)
)

(script dormant building_c_elev01
	(device_set_position_immediate dm_bldg_c_elev01 0)
	(device_set_power dc_bldg_c_switch01c 0)
	(kill_volume_disable kill_elev01)		
	(sleep_until 
		(begin
			(cond
			; elevator is down
			((= (device_get_position dm_bldg_c_elev01) 0)
				(begin
					(device_set_position dm_bldg_c_door01a 1)
					(device_set_power dc_bldg_c_switch01b 1)
					(device_set_power dc_bldg_c_switch01c 1)
					(device_set_power dc_bldg_c_switch01a 0)
					(kill_volume_disable kill_elev01)							
				FALSE)
			)
			; elevator is up			
			((= (device_get_position dm_bldg_c_elev01) 1)
				(begin 
					(device_set_position dm_bldg_c_door01b 1)
					(device_set_power dc_bldg_c_switch01a 1)
					(device_set_power dc_bldg_c_switch01c 1)
					(device_set_power dc_bldg_c_switch01b 0)
					(kill_volume_enable kill_elev01)								
				FALSE)
			)
			(( AND (< (device_get_position dm_bldg_c_elev01) 1)
				  (> (device_get_position dm_bldg_c_elev01) 0))		
				(begin
					(device_set_position dm_bldg_c_door01a 0)
					(device_set_position dm_bldg_c_door01b 0)
					(device_set_power dc_bldg_c_switch01a 0)
					(device_set_power dc_bldg_c_switch01b 0)
					(device_set_power dc_bldg_c_switch01c 0)
					(set g_bldg_c_elev_active TRUE)
					(kill_volume_disable kill_elev01)
				FALSE)
			))			
		)
	1)
)
(script dormant building_c_elev02
	(device_set_position_immediate dm_bldg_c_elev02 0)
	(device_set_power dc_bldg_c_switch02c 0)
	(kill_volume_disable kill_elev02)			
	(sleep_until 
		(begin
			(cond
			; elevator is down
			((= (device_get_position dm_bldg_c_elev02) 0)
				(begin
					(device_set_position dm_bldg_c_door02a 1)
					(device_set_power dc_bldg_c_switch02b 1)
					(device_set_power dc_bldg_c_switch02c 1)
					(device_set_power dc_bldg_c_switch02a 0)
					(kill_volume_disable kill_elev02)							
				FALSE)
			)
			; elevator is up			
			((= (device_get_position dm_bldg_c_elev02) 1)
				(begin 
					(device_set_position dm_bldg_c_door02b 1)
					(device_set_power dc_bldg_c_switch02a 1)
					(device_set_power dc_bldg_c_switch02c 1)
					(device_set_power dc_bldg_c_switch02b 0)					
					(kill_volume_enable kill_elev02)
				FALSE)
			)
			(( AND (< (device_get_position dm_bldg_c_elev02) 1)
				  (> (device_get_position dm_bldg_c_elev02) 0))			
				(begin
					(device_set_position dm_bldg_c_door02a 0)
					(device_set_position dm_bldg_c_door02b 0)
					(device_set_power dc_bldg_c_switch02a 0)
					(device_set_power dc_bldg_c_switch02b 0)
					(device_set_power dc_bldg_c_switch02c 0)
					(set g_bldg_c_elev_active TRUE)
					(kill_volume_disable kill_elev02)
				FALSE)
			))			
		)
	1)
)

(global short elevator_music_bool 1)

(script dormant elevator_no_spawn00
	(sleep_until
		(begin
			(if
				(and
					(> (object_get_health player0) 0)
					(volume_test_object tv_bldg_c_elevator_shaft player0)
				)
				(begin
					(game_save_cancel)
					(game_safe_to_respawn false)
					; if not in coop, do the crazy music thing!
					(if 
						(and
							(= elevator_music_bool 1)
							(= (game_is_cooperative) false)
						)
						(begin 
							(set g_music_m52_03 2)
							(set elevator_music_bool 0)
						)
					)
					; if the music is playing- the buggers are attacking, turn off the music 
					(if (>= g_music_m52_04 1)
						(begin
							(m52_really_stop)
							(set g_music_m52_04 2)
						)
					)				
				)
				(begin
					(game_safe_to_respawn true)
					; if not in coop, do the crazy music thing!					
					(if (= (game_is_cooperative) false)
						(if (= elevator_music_bool 0)
							(begin
								(set g_music_m52_03 1)
								(set elevator_music_bool 1)
							)
						)
					)
				)
			)
		false)
	1)
)
(script dormant elevator_no_spawn01
	(sleep_until
		(begin
			(if
				(and
						(> (object_get_health player1) 0)
						(volume_test_object tv_bldg_c_elevator_shaft player1)
					)
				(begin
					(game_save_cancel)
					(game_safe_to_respawn false)
					(if (>= g_music_m52_04 1)
						(begin
							(m52_really_stop)
							(set g_music_m52_04 2)
						)
					)
				)
				(game_safe_to_respawn true)
			)
		false)
	1)
)
(script dormant elevator_no_spawn02
	(sleep_until
		(begin
			(if
				(and
						(> (object_get_health player2) 0)
						(volume_test_object tv_bldg_c_elevator_shaft player2)
					)
				(begin
					(game_save_cancel)
					(game_safe_to_respawn false)
					(if (>= g_music_m52_04 1)
						(begin
							(m52_really_stop)
							(set g_music_m52_04 2)
						)
					)					
				)
				(game_safe_to_respawn true)
			)
		false)
	1)
)
(script dormant elevator_no_spawn03
	(sleep_until
		(begin	
			(if
				(and
					(> (object_get_health player3) 0)
					(volume_test_object tv_bldg_c_elevator_shaft player3)
				)
				(begin
					(game_save_cancel)
					(game_safe_to_respawn false)
					(if (>= g_music_m52_04 1)
						(begin
							(m52_really_stop)
							(set g_music_m52_04 2)
						)
					)					
				)
				(game_safe_to_respawn true)
			)									
		FALSE)
	1)
)		

(global short s_bldg_c_bugger_max 15)
(global short s_bldg_c_bugger_per_vent 3)
(global short s_bldg_c_bugger_num 30)
(script dormant bugger_respawner
	(if (or (g_3coop_mode) (= (game_difficulty_get) legendary)) (set s_bldg_c_bugger_max 30))
	(if (or (g_3coop_mode) (= (game_difficulty_get) legendary)) (set s_bldg_c_bugger_per_vent 2))
	(if (or (g_3coop_mode) (= (game_difficulty_get) legendary)) (set s_bldg_c_bugger_num 15))
	(sleep_until
		(begin
			(sleep_until (and (<= (ai_spawn_count gr_bldg_c_buggers) 40) (< (ai_living_count gr_bldg_c_buggers) s_bldg_c_bugger_max))5)
				(begin_random
				(if 
					(and 
						(< (ai_living_count gr_bldg_c_buggers) s_bldg_c_bugger_max)
						(< (ai_living_count sq_bldg_c_bugger_00) s_bldg_c_bugger_per_vent)
					) 
						(begin
							(sleep s_bldg_c_bugger_num)
							(f_bugger_vent_exit sq_bldg_c_bugger_00 v_bugger_vent_00)
						)
					(sleep 5)
					)
					(if 
						(and 
							(< (ai_living_count gr_bldg_c_buggers) s_bldg_c_bugger_max)
							(< (ai_living_count sq_bldg_c_bugger_01) s_bldg_c_bugger_per_vent)
						) 
						(begin
							(sleep s_bldg_c_bugger_num)
							(f_bugger_vent_exit sq_bldg_c_bugger_01 v_bugger_vent_01)
						)
						(sleep s_bldg_c_bugger_num)
					)					
					(if 
						(and 
							(< (ai_living_count gr_bldg_c_buggers) s_bldg_c_bugger_max)
							(< (ai_living_count sq_bldg_c_bugger_02) s_bldg_c_bugger_per_vent)
						) 
						(begin
							(sleep s_bldg_c_bugger_num)
							(f_bugger_vent_exit sq_bldg_c_bugger_02 v_bugger_vent_02)
						)
						(sleep s_bldg_c_bugger_num)
					)
					(if 
						(and 
							(< (ai_living_count gr_bldg_c_buggers) s_bldg_c_bugger_max)
							(< (ai_living_count sq_bldg_c_bugger_03) s_bldg_c_bugger_per_vent)
						) 
						(begin
							(sleep s_bldg_c_bugger_num)
							(f_bugger_vent_exit sq_bldg_c_bugger_03 v_bugger_vent_03)
						)
						(sleep s_bldg_c_bugger_num)
					)
					(if 
						(and 
							(< (ai_living_count gr_bldg_c_buggers) s_bldg_c_bugger_max)
							(< (ai_living_count sq_bldg_c_bugger_04) s_bldg_c_bugger_per_vent)
						) 
						(begin
							(sleep s_bldg_c_bugger_num)
							(f_bugger_vent_exit sq_bldg_c_bugger_04 v_bugger_vent_04)
						)
						(sleep s_bldg_c_bugger_num)
					)
					(if 
						(and 
							(< (ai_living_count gr_bldg_c_buggers) s_bldg_c_bugger_max)
							(< (ai_living_count sq_bldg_c_bugger_05) s_bldg_c_bugger_per_vent)
						) 
						(begin
							(sleep s_bldg_c_bugger_num)
							(f_bugger_vent_exit sq_bldg_c_bugger_05 v_bugger_vent_05)
						)
						(sleep s_bldg_c_bugger_num)
					)
					(if 
						(and 
							(< (ai_living_count gr_bldg_c_buggers) s_bldg_c_bugger_max)
							(< (ai_living_count sq_bldg_c_bugger_06) s_bldg_c_bugger_per_vent)
						) 
						(begin
							(sleep s_bldg_c_bugger_num)
							(f_bugger_vent_exit sq_bldg_c_bugger_06 v_bugger_vent_06)
						)
						(sleep s_bldg_c_bugger_num)
					)
					(if 
						(and 
							(< (ai_living_count gr_bldg_c_buggers) s_bldg_c_bugger_max)
							(< (ai_living_count sq_bldg_c_bugger_07) s_bldg_c_bugger_per_vent)
						) 
						(begin
							(sleep s_bldg_c_bugger_num)
							(f_bugger_vent_exit sq_bldg_c_bugger_07 v_bugger_vent_07)	
						)
						(sleep s_bldg_c_bugger_num)
					)
						
					(if 
						(and 
							(< (ai_living_count gr_bldg_c_buggers) s_bldg_c_bugger_max)
							(< (ai_living_count sq_bldg_c_bugger_08) s_bldg_c_bugger_per_vent)
						) 
						(begin
							(sleep s_bldg_c_bugger_num)
							(f_bugger_vent_exit sq_bldg_c_bugger_08 v_bugger_vent_08)	
						)
						(sleep s_bldg_c_bugger_num)
					)
						
					(if 
						(and 
							(< (ai_living_count gr_bldg_c_buggers) s_bldg_c_bugger_max)
							(< (ai_living_count sq_bldg_c_bugger_09) s_bldg_c_bugger_per_vent)
						) 
						(begin
							(sleep (random_range 5 15))
							(f_bugger_vent_exit sq_bldg_c_bugger_09 v_bugger_vent_09)	
						)
						(sleep s_bldg_c_bugger_num)
					)																																				
				)
		;(add_recycling_volume tv_garbage_bldg_c 10 1)
	FALSE)
	)
)
; only the hackiest of hackiest solutions for the lamest bugs!
(script dormant building_c_horrible_kill01
	(sleep_until
		(begin
			(sleep_until (volume_test_players tv_building_c_kill_vol) 5)
			(cond 
				((and
					(volume_test_object tv_building_c_kill_vol player0)
					(not (f_player_flying player0))
				)
				(unit_kill (unit (player0))))
				((and
					(volume_test_object tv_building_c_kill_vol player1)
					(not (f_player_flying player1))
				)
				(unit_kill (unit (player1))))
				((and
					(volume_test_object tv_building_c_kill_vol player2)
					(not (f_player_flying player2))
				)
				(unit_kill (unit (player2))))
				((and
					(volume_test_object tv_building_c_kill_vol player3)
					(not (f_player_flying player3))
				)
				(unit_kill (unit (player3))))					
			)
		false)
	)
)



(script static void (f_bldg_objective 
											(device_name objective)
											(device switch)
										)
	(if (= (object_get_health objective) -1)
		(object_create_anew objective))
	;(print "Objective Created")
  (object_cannot_take_damage objective)                              
  (sleep_until (>= (device_get_position switch) 1)5)
	(f_unblip_object switch)
	(device_set_power switch 0)	  
  (device_set_position objective 1)
  (sleep 1)
  (sleep_until (>= (device_get_position objective) 1) 5 80); to prevent badness
 	(object_can_take_damage objective)
 	(object_set_shield objective 0)
 	(sleep 10)                    
  (object_damage_damage_section objective "body" 1000)
  (object_destroy switch)
)

; this can be used to check to see if the objective is complete or also for sleep untils so it doesn't block
(script static boolean (f_objective_complete (device_name sc_objective) (device switch))
	(if
		(and
			(<= (object_get_health sc_objective) 0)
			(>= (device_get_position switch) 0)
			(= (object_get_health switch) -1)
		)
	true)
)

;===================================================================================================
;=====================ENCOUNTER_ONI SCRIPTS =============================================
;===================================================================================================
(global boolean b_oni_start false)
(global boolean b_oni_begin false)

(script dormant enc_oni
	(sleep_until (= m_progression 0) 5)
		(wake title_final)
		(wake m52_music_08)
		(erase_ambient_patrol)
		(zone_set_trigger_volume_enable zone_set:m52_010_a FALSE)	
		(zone_set_trigger_volume_enable zone_set:m52_020_b FALSE)
		(zone_set_trigger_volume_enable zone_set:m52_030_c FALSE)		
		;(data_mine_set_mission_segment "m52_route_to_building_oni")		
		(sleep 10)
		;(set b_achievement_turrets_end true)		
		(ai_erase gr_turrets)					
		(ai_place sq_oni_cd_01)
		(ai_place sq_oni_cd_02)
		(ai_place sq_oni_cd_03)		
		(sleep (* 30 (random_range 4 7)))
		(wake md_040_bldg_oni)	
		(ai_set_objective gr_banshee obj_oni) ; all old banshees go to the oni building			
		(wake oni_banshee_spawn)
		(wake hud_object_bldg_oni)
		(wake aj_mode)				
		(sleep_until (volume_test_players	tv_oni_start) 5)		
		(f_unblip_flag cf_bldg_oni)
		(set b_oni_start TRUE)
		;(garbage_cleaning)		
		;(data_mine_set_mission_segment "m52_building_oni")		
		(wake pelican01_hangar_load)
		(wake pelican02_hangar_load)	
		(wake pelican03_hangar_load)						
		(sleep 10)
		(sleep_until (= b_oni_begin TRUE) 5 2400)		
		(sleep_until (= (b_oni_end) TRUE) 5)
		(set g_music_m52_08 2)
		(prepare_to_switch_to_zone_set m52_040_oni)		
		(wake md_040_oni_end)
		;(data_mine_set_mission_segment "m52_building_oni_end")
		(sleep_until (script_finished md_040_oni_end)5)
		(switch_zone_set m52_040_oni)		
		(object_create dm_end_oni_platform)
		(device_set_position dm_end_oni_platform 1)
		(sleep 60)
		(sleep_until (volume_test_players tv_landing_pad_end)5)
		(wake m52_cin_end)
)
						
(script static boolean b_oni_end
	(if 					
		(and
			(or
				(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_01/gunner)) 0)
				(< (ai_living_count sq_oni_s_01) 1)
			)
			(or
				(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_02/gunner)) 0)
				(< (ai_living_count sq_oni_s_02) 1)
			)
			(or
				(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_03/gunner)) 0)
				(< (ai_living_count sq_oni_s_03) 1)
			)
			(or
				(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_04/gunner)) 0)
				(< (ai_living_count sq_oni_s_04) 1)
			)
			(or
				(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_05/gunner)) 0)
				(< (ai_living_count sq_oni_s_05) 1)
			)
			(or
				(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_06/gunner)) 0)
				(< (ai_living_count sq_oni_s_06) 1)
			)
			(or
				(= oni_dropship01_exit true)
				(< (ai_living_count sq_oni_cd_01) 1)
			)
			(or
				(= oni_dropship02_exit true)
				(< (ai_living_count sq_oni_cd_02) 1)
			)
			(or
				(= oni_dropship03_exit true)
				(< (ai_living_count sq_oni_cd_03) 1)
			)					
		)
	TRUE				 
	)
)

(script dormant falcon_friendly_final_battle
	(sleep_forever falcon_patrol)
	(sleep_forever phantom_patrol)
	(sleep_forever pelican_patrol)
	(ai_erase gr_hub_falcons)
	(ai_erase gr_hub_phantoms)
	(ai_erase gr_hub_pelicans)		
	(cond
		((= g_prev_mission 1)
			(begin
				(ai_place sq_falcon_final01)
				(set obj_final_falcon01 (ai_get_object sq_falcon_final01/driver))
				(cs_run_command_script sq_falcon_final01/driver cs_falcon_final_a1)				
			)
		)
		((= g_prev_mission 2)
			(begin
				(ai_place sq_falcon_final01)
				(set obj_final_falcon01 (ai_get_object sq_falcon_final01/driver))
				(cs_run_command_script sq_falcon_final01/driver cs_falcon_final_b1)							
			)
		)
		((= g_prev_mission 3)
			(begin
				(ai_place sq_falcon_final01)
				(set obj_final_falcon01 (ai_get_object sq_falcon_final01/driver))
				(cs_run_command_script sq_falcon_final01/driver cs_falcon_final_c1)
						
			)
		)			
	)
)
	

(script command_script cs_falcon_final_a1
	(ai_cannot_die ai_current_squad TRUE)
	(ai_teleport ai_current_squad sd_final_falcon_a/p0)
	(cs_fly_by sd_final_falcon_a/p3 3)
	(ai_cannot_die ai_current_squad FALSE)
	(f_blip_ai ai_current_actor 5)
	(sleep_until 
		(and 
			(= (f_players_flying) true)
			(or
				(< (objects_distance_to_object (players) obj_final_falcon01) 10)
				;(< (objects_distance_to_object (players) obj_final_falcon02) 10)
				(volume_test_players	tv_oni_start)
			)
		)
	)
	(ai_set_objective ai_current_squad obj_oni)
)

(script command_script cs_falcon_final_b1
	(ai_cannot_die ai_current_squad TRUE)
	(ai_teleport ai_current_squad sd_final_falcon_b/p0)
	(cs_fly_by sd_final_falcon_b/p3 3)
	(ai_cannot_die ai_current_squad FALSE)
	(f_blip_ai ai_current_actor 5)
	(sleep_until 
		(and (= (f_players_flying) true)
			(or
				(< (objects_distance_to_object (players) obj_final_falcon01) 10)
				;(< (objects_distance_to_object (players) obj_final_falcon02) 10)
				(volume_test_players	tv_oni_start)
			)
		)
	)
	(ai_set_objective ai_current_squad obj_oni)
)


(script command_script cs_falcon_final_c1
	(ai_cannot_die ai_current_squad TRUE)
	(ai_teleport ai_current_squad sd_final_falcon_c/p0)
	(cs_fly_by sd_final_falcon_c/p3 3)
	(ai_cannot_die ai_current_squad FALSE)
	(f_blip_ai ai_current_actor 5)
	(sleep_until 
		(and (= (f_players_flying) true)
			(or
				(< (objects_distance_to_object (players) obj_final_falcon01) 10)
				;(< (objects_distance_to_object (players) obj_final_falcon02) 10)
				(volume_test_players	tv_oni_start)
			)
		)
	)
	(ai_set_objective ai_current_squad obj_oni)
)

(global short pelican_status 0)
(script dormant pelican01_hangar_load
	(sleep (random_range 120 240))
	(ai_place sq_oni_pelican01)	
	(ai_disregard (ai_actors sq_oni_pelican01) true)
	(object_cannot_take_damage (ai_vehicle_get_from_spawn_point sq_oni_pelican01/pilot))	
	(objects_attach oni_hangar_door_a "marker_pelican" (ai_vehicle_get_from_spawn_point sq_oni_pelican01/pilot) "pelican_attach")
	(sleep 30)			
	(device_set_position oni_hangar_door_a 1)
	(sleep_until (>= (device_get_position oni_hangar_door_a) 0.5) 5)
	(sleep 30)
	(objects_detach oni_hangar_door_a (ai_vehicle_get_from_spawn_point sq_oni_pelican01/pilot))	
	(wake md_040_oni_pelican01)	
	(sleep_until 
		(and
			(or
				(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_01/gunner)) 0)
				(<= (ai_living_count sq_oni_s_01) 0)
			)
			(or
				(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_02/gunner)) 0)
				(<= (ai_living_count sq_oni_s_02) 0)
			)
		)
	5)
	(objects_detach oni_hangar_door_a (ai_vehicle_get_from_spawn_point sq_oni_pelican01/pilot))		
	(ai_force_active sq_oni_pelican01 true)	
	(cs_run_command_script sq_oni_pelican01/pilot cs_pelican01_escape)
	(set pelican_status (+ pelican_status 1))
)

(script dormant pelican02_hangar_load
	(sleep (random_range 120 240))
	(ai_place sq_oni_pelican02)
	(ai_disregard (ai_actors sq_oni_pelican02) true)
	(object_cannot_take_damage (ai_vehicle_get_from_spawn_point sq_oni_pelican02/pilot))			
	(cs_run_command_script sq_oni_pelican02/pilot peaceful_flyer)
	(sleep 1)
	(objects_attach oni_hangar_door_b "marker_pelican" (ai_vehicle_get_from_spawn_point sq_oni_pelican02/pilot) "pelican_attach")
	(device_set_position oni_hangar_door_b 1)
	(sleep_until (>= (device_get_position oni_hangar_door_b) 0.5) 5)
	(sleep 30)
	(objects_detach oni_hangar_door_b (ai_vehicle_get_from_spawn_point sq_oni_pelican02/pilot))	
	(wake md_040_oni_pelican02)	
	(sleep_until 
		(and
			(or
				(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_04/gunner)) 0)
				(<= (ai_living_count sq_oni_s_04) 0)
			)
			(or
				(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_05/gunner)) 0)
				(<= (ai_living_count sq_oni_s_05) 0)
			)
		)
	5)
	(sleep 30)
	(ai_force_active sq_oni_pelican02 true)				
	(cs_run_command_script sq_oni_pelican02/pilot cs_pelican02_escape)
	(set pelican_status (+ pelican_status 1))
)
(script dormant pelican03_hangar_load
	(sleep (random_range 120 240))
	(ai_place sq_oni_pelican03)	
	(ai_disregard (ai_actors sq_oni_pelican03) true)
	(object_cannot_take_damage (ai_vehicle_get_from_spawn_point sq_oni_pelican03/pilot))			
	(cs_run_command_script sq_oni_pelican03/pilot peaceful_flyer)
	(sleep 1)
	(objects_attach oni_hangar_door_c "marker_pelican" (ai_vehicle_get_from_spawn_point sq_oni_pelican03/pilot) "pelican_attach")
	(device_set_position oni_hangar_door_c 1)
	(sleep_until (>= (device_get_position oni_hangar_door_c) 0.5) 5)
	(sleep 30)
	(objects_detach oni_hangar_door_c (ai_vehicle_get_from_spawn_point sq_oni_pelican03/pilot))	
	(wake md_040_oni_pelican03)
	(sleep_until 
		(and
			(or
				(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_03/gunner)) 0)
				(<= (ai_living_count sq_oni_s_03) 0)
			)
			(or
				(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_06/gunner)) 0)
				(<= (ai_living_count sq_oni_s_06) 0)
			)
		)
	5)	
	(sleep 30)
	(ai_force_active sq_oni_pelican03 true)				
	(cs_run_command_script sq_oni_pelican03/pilot cs_pelican03_escape)
	(set pelican_status (+ pelican_status 1))
)

(script command_script cs_pelican01_escape
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles false)
;	(ai_teleport ai_current_squad sd_oni_pelican01/p0)
	(cs_fly_by sd_oni_pelican01/p0 1)
	(device_set_position oni_hangar_door_a 0)	
	(cs_fly_by sd_oni_pelican01/p1 3)	
	(cs_fly_by sd_oni_pelican01/p2 3)
	(cs_fly_by sd_oni_pelican01/p3 3)
	(cs_fly_by sd_oni_pelican01/p4 3)
	(cs_fly_to sd_oni_pelican01/p5 5)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
	
)
(script command_script cs_pelican02_escape
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by sd_oni_pelican02/p0 1)
	(device_set_position oni_hangar_door_b 0)				
	(cs_fly_by sd_oni_pelican02/p1 3)	
	(cs_fly_by sd_oni_pelican02/p2 3)
	(cs_fly_by sd_oni_pelican02/p3 3)
	(cs_fly_by sd_oni_pelican02/p4 3)
	(cs_fly_to sd_oni_pelican02/p5 5)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
	
)
(script command_script cs_pelican03_escape
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 0.5)
	(cs_fly_by sd_oni_pelican03/p0 3)
	(cs_vehicle_speed 1)
	(device_set_position oni_hangar_door_c 0)			
	(cs_fly_by sd_oni_pelican03/p1 3)
	;(cs_vehicle_boost TRUE)		
	(cs_fly_by sd_oni_pelican03/p2 1)
	(cs_fly_by sd_oni_pelican03/p3 1)
	(cs_fly_by sd_oni_pelican03/p4 1)
	(cs_fly_to sd_oni_pelican03/p5 5)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
	
)
(global boolean oni_dropship01_exit false)
(global boolean oni_dropship02_exit false)
(global boolean oni_dropship03_exit false)
(script command_script cs_cov_dropship_wave01
	(ai_cannot_die sq_oni_cd_01 TRUE)	
	(cs_fly_by sd_oni_dropship_wave01/p0)	
	(ai_cannot_die sq_oni_cd_01 FALSE)
	(f_load_phantom_cargo (ai_vehicle_get_from_spawn_point sq_oni_cd_01/pilot) "double" sq_oni_s_01 sq_oni_s_02)	
 	(wake md_040_oni_aa01)
 	(wake md_040_oni_aa02) 
 	(cs_ignore_obstacles TRUE)				
	(cs_fly_to sd_oni_dropship_wave01/p1 3)	
	(cs_fly_to sd_oni_dropship_wave01/p2 1)
	(cs_vehicle_speed 0.5)
 	(cs_fly_to sd_oni_dropship_wave01/p3 1)
 	(wake oni_shade_1)			
	(vehicle_unload (ai_vehicle_get_from_spawn_point sq_oni_cd_01/pilot) "phantom_sc01")
 	(cs_fly_to sd_oni_dropship_wave01/p2 1)
 	(cs_fly_to sd_oni_dropship_wave01/p4 1)
 	(cs_fly_to sd_oni_dropship_wave01/p5 1)	 	
 	(sleep 30) 	 	 
	(vehicle_unload (ai_vehicle_get_from_spawn_point sq_oni_cd_01/pilot) "phantom_sc02")
	(wake oni_shade_2)
	(set oni_dropship01_exit true)
 	(cs_fly_to sd_oni_dropship_wave01/p4 1)	
 	(cs_fly_by sd_oni_dropship_wave01/p6)
 	(if 
 		(or 
 			(g_3coop_mode)
 			(= (game_difficulty_get) legendary)
 			1
 		)
 		(begin
	 		(cs_fly_to_and_face sd_oni_dropship_wave01/p9 sd_oni_dropship_wave01/p10)
	 		(sleep_until (= (b_oni_end) true) 5)
	 	)
 	)
 	(cs_fly_by sd_oni_dropship_wave01/p7)
 	(cs_ignore_obstacles FALSE)  
 	(cs_fly_by sd_oni_dropship_wave01/p8) 	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor)) 
)

(script dormant oni_shade_1
	(sleep 15)
	(objects_attach sc_oni_01 "marker01" (ai_vehicle_get_from_spawn_point sq_oni_s_01/gunner) "")
 	(cs_run_command_script sq_oni_s_01 cs_shade_fire_oni)
  (sleep 15)
	(objects_detach sc_oni_01 (ai_vehicle_get_from_spawn_point sq_oni_s_01/gunner)) 	
	(sleep_until (= b_oni_start TRUE)5)
	(sleep 60)	
 	(f_blip_ai sq_oni_s_01 15)
  (sleep_until
		(or
			(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_01/gunner)) 0)
			(<= (ai_living_count sq_oni_s_01) 0)
		)
	5)
	(f_unblip_ai sq_oni_s_01)		
)

(script dormant oni_shade_2
	(sleep 15)
	(objects_attach sc_oni_02 "marker01" (ai_vehicle_get_from_spawn_point sq_oni_s_02/gunner) "")
 	(cs_run_command_script sq_oni_s_02 cs_shade_fire_oni)
  (sleep 15)
	(objects_detach sc_oni_02 (ai_vehicle_get_from_spawn_point sq_oni_s_02/gunner))  	
	(sleep_until (= b_oni_start TRUE)5)
	(sleep 60)	
 	(f_blip_ai sq_oni_s_02 15)
  (sleep_until
		(or
			(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_02/gunner)) 0)
			(<= (ai_living_count sq_oni_s_02) 0)
		)
	5)
	(f_unblip_ai sq_oni_s_02)		
)

(script command_script cs_cov_dropship_wave02
	(ai_cannot_die sq_oni_cd_02 TRUE)
	(cs_ignore_obstacles TRUE)	
	(cs_fly_by sd_oni_dropship_wave02/p0)	
	(ai_cannot_die sq_oni_cd_02 FALSE)
	(f_load_phantom_cargo (ai_vehicle_get_from_spawn_point sq_oni_cd_02/pilot) "double" sq_oni_s_04 sq_oni_s_05)
 	(wake md_040_oni_aa04)
 	(wake md_040_oni_aa05) 		
	(cs_fly_to sd_oni_dropship_wave02/p1 3)	
	(cs_fly_to sd_oni_dropship_wave02/p2 1)
	(sleep 30)
 	(cs_fly_to sd_oni_dropship_wave02/p3 0.5)	
 	(sleep 30)	
	(vehicle_unload (ai_vehicle_get_from_spawn_point sq_oni_cd_02/pilot) "phantom_sc01")
	(wake oni_shade_4)
 	(cs_fly_to sd_oni_dropship_wave02/p2 1)
 	(cs_fly_to sd_oni_dropship_wave02/p4 3)
 	(cs_fly_to sd_oni_dropship_wave02/p5 1)
 	(cs_fly_to sd_oni_dropship_wave02/p6 1) 		 	
 	(sleep 30) 	 	 
	(vehicle_unload (ai_vehicle_get_from_spawn_point sq_oni_cd_02/pilot) "phantom_sc02")
	(wake oni_shade_5)
	(set oni_dropship02_exit true)	
 	(cs_fly_to sd_oni_dropship_wave02/p5 3) 
 	(if 
 		(or 
 			(g_3coop_mode)
 			(= (game_difficulty_get) legendary)
 			1
 		)
 		(begin
	 		(cs_fly_to_and_face sd_oni_dropship_wave02/p9 sd_oni_dropship_wave02/p10)
	 		(sleep_until (= (b_oni_end) true) 5)
	 		(cs_fly_to sd_oni_dropship_wave02/p4)
	 	)
 	)		
 	(cs_fly_to sd_oni_dropship_wave02/p7)
 	(cs_ignore_obstacles FALSE)
 	(cs_fly_to sd_oni_dropship_wave02/p8)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor)) 	  	
)

(script dormant oni_shade_4
	(sleep 15)
	(objects_attach sc_oni_04 "marker01" (ai_vehicle_get_from_spawn_point sq_oni_s_04/gunner) "")
 	(cs_run_command_script sq_oni_s_04 cs_shade_fire_oni)	
 	(sleep 15)
	(objects_detach sc_oni_04 (ai_vehicle_get_from_spawn_point sq_oni_s_04/gunner)) 		
	(sleep_until (= b_oni_start TRUE)5)
	(sleep 60)	
 	(f_blip_ai sq_oni_s_04 15)
  (sleep_until
		(or
			(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_04/gunner)) 0)
			(<= (ai_living_count sq_oni_s_04) 0)
		)
	5)
	(f_unblip_ai sq_oni_s_04)			
)

(script dormant oni_shade_5
	(sleep 15)
	(objects_attach sc_oni_05 "marker01" (ai_vehicle_get_from_spawn_point sq_oni_s_05/gunner) "")
 	(cs_run_command_script sq_oni_s_05 cs_shade_fire_oni)
  (sleep 15)
	(objects_detach sc_oni_05 (ai_vehicle_get_from_spawn_point sq_oni_s_05/gunner)) 		
	(sleep_until (= b_oni_start TRUE)5)
	(sleep 60)	
 	(f_blip_ai sq_oni_s_05 15)
  (sleep_until
		(or
			(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_05/gunner)) 0)
			(<= (ai_living_count sq_oni_s_05) 0)
		)
	5)
	(f_unblip_ai sq_oni_s_05)	
)

(script command_script cs_cov_dropship_wave03
	(ai_cannot_die sq_oni_cd_03 TRUE)	
	(cs_fly_by sd_oni_dropship_wave03/p0 3)
	(ai_cannot_die sq_oni_cd_03 FALSE)
	(cs_ignore_obstacles TRUE)	
	(f_load_phantom_cargo (ai_vehicle_get_from_spawn_point sq_oni_cd_03/pilot) "double" sq_oni_s_03 sq_oni_s_06)	
 	(wake md_040_oni_aa03)
 	(wake md_040_oni_aa06) 			
	(cs_fly_to sd_oni_dropship_wave03/p1 3)	
	(cs_fly_to sd_oni_dropship_wave03/p2 2)
	(cs_vehicle_speed 0.7)
 	(cs_fly_to sd_oni_dropship_wave03/p3 1)	
 	(sleep 45)	
	(vehicle_unload (ai_vehicle_get_from_spawn_point sq_oni_cd_03/pilot) "phantom_sc01")
	(wake oni_shade_3)
	(cs_vehicle_speed 1)	
 	(cs_fly_to sd_oni_dropship_wave03/p2 2)
 	(cs_fly_by sd_oni_dropship_wave03/p4 3)
 	(cs_fly_to sd_oni_dropship_wave03/p5 1)
 	(cs_fly_to sd_oni_dropship_wave03/p6 1) 		 	
 	(sleep 30) 	 	 
	(vehicle_unload (ai_vehicle_get_from_spawn_point sq_oni_cd_03/pilot) "phantom_sc02")
	(wake oni_shade_6)
	(set oni_dropship03_exit true)
 	(cs_fly_to sd_oni_dropship_wave03/p5 3)
	(cs_fly_to_and_face sd_oni_dropship_wave03/p9 sd_oni_dropship_wave03/p10)
	(sleep_until (= (b_oni_end) true) 5)	 	
 	(cs_fly_to sd_oni_dropship_wave03/p7)
 	(cs_ignore_obstacles FALSE)
 	(cs_fly_to sd_oni_dropship_wave03/p8)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script dormant oni_shade_3
	(sleep 15)
	(objects_attach sc_oni_03 "marker01" (ai_vehicle_get_from_spawn_point sq_oni_s_03/gunner) "")
 	(cs_run_command_script sq_oni_s_03 cs_shade_fire_oni)
  (sleep 15)
	(objects_detach sc_oni_03 (ai_vehicle_get_from_spawn_point sq_oni_s_03/gunner))  
	(sleep_until (= b_oni_start TRUE)5)
	(sleep 60)
 	(f_blip_ai sq_oni_s_03 15)
 	(sleep_until
		(or
			(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_03/gunner)) 0)
			(<= (ai_living_count sq_oni_s_03) 0)
		)
	5)
	(f_unblip_ai sq_oni_s_03)	
)

(script dormant oni_shade_6
	(sleep 15)
	(objects_attach sc_oni_06 "marker01" (ai_vehicle_get_from_spawn_point sq_oni_s_06/gunner) "")
	(cs_run_command_script sq_oni_s_06 cs_shade_fire_oni)	
  (sleep 15)
	(objects_detach sc_oni_06 (ai_vehicle_get_from_spawn_point sq_oni_s_06/gunner))  
	(sleep_until (= b_oni_start TRUE)5)
	(sleep 60)	
 	(f_blip_ai sq_oni_s_06 15)
 	(sleep_until
		(or
			(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_s_06/gunner)) 0)
			(<= (ai_living_count sq_oni_s_06) 0)
		)
	5)
	(f_unblip_ai sq_oni_s_06)
)

(script command_script peaceful_flyer
	(sleep_forever)
)

(script command_script cs_banshee_flee
	(cs_vehicle_boost true)
	(begin_random_count 1
		(cs_fly_by sd_banshee_flee/p0 10)
		(cs_fly_by sd_banshee_flee/p1 10)
		(cs_fly_by sd_banshee_flee/p2 10)
		(cs_fly_by sd_banshee_flee/p3 10)
		(cs_fly_by sd_banshee_flee/p4 10)
	)
	(begin_random_count 1
		(cs_fly_by sd_banshee_flee/p5 10)
		(cs_fly_by sd_banshee_flee/p6 10)
		(cs_fly_by sd_banshee_flee/p7 10)
		(cs_fly_by sd_banshee_flee/p8 10)
		(cs_fly_by sd_banshee_flee/p9 10)
	)	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))	
)

(script command_script cs_shade_fire_oni
	(set b_oni_begin true)
	(cs_abort_on_damage true)
	(sleep_until
		(begin
			(begin_random_count 1
				(begin
					;(print "SHOOTING AT PLAYER")	
					(cs_enable_targeting true)
					(cs_enable_looking true)
					(sleep 300)
				)
				(begin		
					(cs_enable_targeting false)
					(cs_enable_looking false)
					(begin_random_count 2
						(cs_shoot_point true sd_oni_shades/p0)
						(cs_shoot_point true sd_oni_shades/p1)
						(cs_shoot_point true sd_oni_shades/p2)
						(cs_shoot_point true sd_oni_shades/p3)
						(cs_shoot_point true sd_oni_shades/p4)
						(cs_shoot_point true sd_oni_shades/p5)
						(cs_shoot_point true sd_oni_shades/p6)
						(cs_shoot_point true sd_oni_shades/p7)
						(cs_shoot_point true sd_oni_shades/p8)
						(cs_shoot_point true sd_oni_shades/p9)
						(cs_shoot_point true sd_oni_shades/p10)
						(cs_shoot_point true sd_oni_shades/p11)
						(cs_shoot_point true sd_oni_shades/p12)
						(cs_shoot_point true sd_oni_shades/p13)
						(cs_shoot_point true sd_oni_shades/p14)
						(cs_shoot_point true sd_oni_shades/p15)
						(cs_shoot_point true sd_oni_shades/p16)
						(cs_shoot_point true sd_oni_shades/p17)
						(cs_shoot_point true sd_oni_shades/p18)
						(cs_shoot_point true sd_oni_shades/p19)
						(cs_shoot_point true sd_oni_shades/p20)
						(cs_shoot_point true sd_oni_shades/p21)
						(cs_shoot_point true sd_oni_shades/p22)
						(cs_shoot_point true sd_oni_shades/p23)
						(cs_shoot_point true sd_oni_shades/p24)
						(cs_shoot_point true sd_oni_shades/p25)
						(cs_shoot_point true sd_oni_shades/p26)
						(cs_shoot_point true sd_oni_shades/p27)
						(cs_shoot_point true sd_oni_shades/p28)
						(cs_shoot_point true sd_oni_shades/p29)
						(cs_shoot_point true sd_oni_shades/p30)																						
					)						
				)
			)
		false)
	30)
)

(global short s_oni_banshee_num 8)

(script dormant oni_banshee_spawn
	(if 
		(or
			(= (game_difficulty_get) legendary)
			(= (g_3coop_mode) true)
		)
		(set s_oni_banshee_num 10)
	)
	(sleep_forever banshee_spawn) ; kill the old banshee machine	
	(sleep_until
		(begin
			(if (<= (ai_living_count gr_banshee) s_oni_banshee_num)
				(begin_random
					(if 
						(and 
							(<= (ai_living_count gr_banshee) s_oni_banshee_num)
							(<= (ai_living_count sq_oni_banshee_01) 1)) 
								(begin
									(ai_place sq_oni_banshee_01)
									(ai_set_clump sq_oni_banshee_01 g_clumps_banshee)
								)
						(sleep 5)
					)
					(if 
						(and 
							(<= (ai_living_count gr_banshee) s_oni_banshee_num)
							(<= (ai_living_count sq_oni_banshee_02) 1)) 
								(begin
									(ai_place sq_oni_banshee_02)
									(ai_set_clump sq_oni_banshee_02 g_clumps_banshee)
								)
						(sleep 5)
					)	
					(if 
						(and 
							(<= (ai_living_count gr_banshee) s_oni_banshee_num)
							(<= (ai_living_count sq_oni_banshee_03) 1))
								(begin
									(ai_place sq_oni_banshee_03)
									(ai_set_clump sq_oni_banshee_03 g_clumps_banshee)
								)
						(sleep 5)
					)			
					(if 
						(and 
							(<= (ai_living_count gr_banshee) s_oni_banshee_num)
							(<= (ai_living_count sq_oni_banshee_04) 1))
								(begin
									(ai_place sq_oni_banshee_04)
									(ai_set_clump sq_oni_banshee_04 g_clumps_banshee)
								)
						(sleep 5)
					)				
					(if 
						(and 
							(<= (ai_living_count gr_banshee) s_oni_banshee_num)
							(<= (ai_living_count sq_oni_banshee_05) 1))
								(begin
									(ai_place sq_oni_banshee_05)
									(ai_set_clump sq_oni_banshee_05 g_clumps_banshee)
								)
						(sleep 5)
					)				
					(if 
						(and 
							(<= (ai_living_count gr_banshee) s_oni_banshee_num)
							(<= (ai_living_count sq_oni_banshee_06) 1))
								(begin
									(ai_place sq_oni_banshee_06)
									(ai_set_clump sq_oni_banshee_06 g_clumps_banshee)
								)
						(sleep 5)
					)
			)
		)
(b_oni_end))
	)
)


;===================================================================================================
;=====================SEC_OBJECTIVE SCRIPTS =============================================
;===================================================================================================
;* secondary missions:
alpha
beta
gamma
delta
*;


; l_instances passes in how many secondary encounters are happening simultaneously
(script static void (sec_objective (short l_instances))
	(f_zone_teleport_player0)	
	(f_zone_teleport_player1)	
	(f_zone_teleport_player2)		
	(f_zone_teleport_player3)
	(prepare_to_switch_to_zone_set m52_000_secondary)
	(sleep 210)
	(switch_zone_set m52_000_secondary)
	;(print "SWITCHED TO SECONDARY")	
	(sleep_until (= (current_zone_set_fully_active) 5)1)
	(falcon_gunner_reserve false)
	(sleep 30)
	(sleep_until
		(begin
			(begin_random_count l_instances
					(set m_sec_alpha TRUE)
					(set m_sec_beta TRUE)
					(set m_sec_gamma TRUE)
					(set m_sec_delta TRUE)																											
				)
		(sleep (* (random_range 5 10) 30))														
		(= m_sec_started l_instances))
		1)
	(sleep_until (= m_sec_complete l_instances)5)
		(set m_sec_started 0)
		(set m_sec_complete 0)
		(if (g_3coop_mode) (set m_coop_1st_dialog true))
	;(print "DONE SECONDARY OBJECTIVES")
	(falcon_gunner_reserve false)
	(sleep 90)
	(game_save)
	(sleep 90)		
)

;======================================================================
;======================SECONDARY ALPHA SCRIPTS=========================
;======================================================================


(script static void test_secondary_objectives
	(prepare_to_switch_to_zone_set m52_000_secondary)
	(sleep 300)
	(switch_zone_set m52_000_secondary)
	(sec_ai_alpha_1)	
	(sec_ai_beta_1)
	(sec_ai_gamma_1)	
	(sec_ai_delta_1)
	(sec_ai_alpha_2)
	(sec_ai_beta_2)	
	(sec_ai_gamma_2)
	(sec_ai_delta_2)
	(sec_ai_alpha_3)	
	(sec_ai_beta_3)	
	(sec_ai_gamma_3)
	(sec_ai_delta_3)		
)

(script dormant sec_obj_alpha
	(sleep_until (and (= m_alpha_complete FALSE)(= m_sec_alpha TRUE))1)
		(set m_sec_started (+ m_sec_started 1))	
			(begin_random_count 1
					(sec_ai_alpha_1)
					(sec_ai_alpha_2)
					(sec_ai_alpha_3)	
			)
		(set m_alpha_complete TRUE)
		(set m_sec_complete (+ m_sec_complete 1))
)

(script static void sec_ai_alpha_1
	;(data_mine_set_mission_segment "m52_sec_alpha_1")	
	(set g_alpha_enc 1)
	(ai_place sq_sec_alpha_cd01)
	(ai_force_active sq_sec_alpha_cd01 TRUE)
	(sleep_until 
		(or 
			(< (ai_living_count sq_sec_alpha_cd01) 1)
			(= m_sec_alpha01_start TRUE)
		)
	5)
	
	(sleep_until (f_hub_and_radius_check cf_sec_alpha_1 50) 5)
	(ai_set_targeting_group gr_marines 2)
	(ai_set_targeting_group gr_banshee 2)
	(sleep_until 
		(or 
			(< (ai_living_count gr_alpha_cov) 1)
			(< (ai_living_count gr_alpha_marine)1)
		)5)
					(if (and 
								(> (ai_living_count gr_alpha_marine) 0)
								(< (ai_living_count gr_alpha_cov) 1)
							)
						(begin
							(ai_place sq_sec_alpha_p01)
							(ai_force_active sq_sec_alpha_p01 TRUE)
						)
					)
					(sleep_until (< (ai_living_count gr_alpha_marine) 1) 5)

	(if (> (ai_living_count sq_sec_alpha_p01) 1)
		(md_050_sec_success_alpha1)
		(md_050_sec_fail_alpha1)
	)
	(ai_set_targeting_group gr_marines -1)
	(ai_set_targeting_group gr_banshee -1)						
	(f_unblip_flag cf_sec_alpha_1)
)

(script static void sec_ai_alpha_2
	;(data_mine_set_mission_segment "m52_sec_alpha_2")	
	(set g_alpha_enc 2)
	(ai_place sq_sec_alpha_cd02)
	(ai_force_active sq_sec_alpha_cd02 TRUE)

	(sleep_until (= m_sec_alpha02_start TRUE) 5)
	(sleep_until (f_hub_and_radius_check cf_sec_alpha_2 50) 5)
	(ai_set_targeting_group gr_marines 2)
	(ai_set_targeting_group gr_banshee 2)	
	(sleep_until 
		(or 
			(< (ai_living_count gr_alpha_cov) 1)
			(< (ai_living_count gr_alpha_marine)1)
		)5)
					(if (and 
								(> (ai_living_count gr_alpha_marine) 0)
								(< (ai_living_count gr_alpha_cov) 1)
							)
						(begin
							(ai_place sq_sec_alpha_p02)
							(ai_force_active sq_sec_alpha_p02 true)
						)
					)
					(sleep_until (< (ai_living_count gr_alpha_marine) 1) 5)
	(if (> (ai_living_count sq_sec_alpha_p02) 1)
		(md_050_sec_success_alpha2)
		(md_050_sec_fail_alpha2)
	)
	(ai_set_targeting_group gr_marines -1)
	(ai_set_targeting_group gr_banshee -1)							
	(f_unblip_flag cf_sec_alpha_2)
	(f_unblip_ai sq_sec_alpha_m02)
)
(script static void sec_ai_alpha_3
	;(data_mine_set_mission_segment "m52_sec_alpha_3")
	(sleep_until (= (current_zone_set_fully_active) 5)1 1200)
	(set g_alpha_enc 3)
	(ai_place sq_sec_alpha_m03)
	(ai_force_active sq_sec_alpha_m03 TRUE)
	(ai_cannot_die sq_sec_alpha_m03 TRUE)
	(ai_force_full_lod sq_sec_alpha_m03)		
	(sleep 60)
	(ai_place sq_sec_alpha_c03a)
	(ai_force_active sq_sec_alpha_c03a TRUE)
	(ai_cannot_die sq_sec_alpha_c03a TRUE)
	(ai_force_full_lod sq_sec_alpha_c03a)	
	(wake md_050_sec_alpha3)
	(sleep_until (f_hub_and_radius_check cf_sec_alpha_3 60) 5)
	(ai_cannot_die sq_sec_alpha_c03a FALSE)
	(ai_set_targeting_group gr_marines 2)
	(ai_set_targeting_group gr_banshee 2)	
	(f_blip_ai sq_sec_alpha_m03 5)
	(f_blip_ai sq_sec_alpha_c03a 15)				
	(sleep_until (f_hub_and_radius_check cf_sec_alpha_3 40) 5 300)
	(ai_cannot_die sq_sec_alpha_m03 FALSE)
	
	(sleep_until 
		(or 
			(< (ai_living_count gr_alpha_cov) 1)
			(< (ai_living_count gr_alpha_marine)1)
		)5)
					(if (and 
								(> (ai_living_count gr_alpha_marine) 0)
								(< (ai_living_count gr_alpha_cov) 1)
							)
						(begin
							(ai_place sq_sec_alpha_p03)
							(ai_force_active sq_sec_alpha_p03 TRUE)
						)
					)
					(sleep_until (< (ai_living_count sq_sec_alpha_m03) 1))
	(if (> (ai_living_count sq_sec_alpha_p03) 1)
		(md_050_sec_success_alpha3)
		(md_050_sec_fail_alpha3)
	)
	(ai_set_targeting_group gr_marines -1)
	(ai_set_targeting_group gr_banshee -1)								
	(f_unblip_flag cf_sec_alpha_3)
	(f_unblip_ai sq_sec_alpha_m03)

)

(script command_script cs_failsafe_alpha_1
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_dialogue TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (not (volume_test_object tv_sec_alpha_1 ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)

(script command_script cs_failsafe_alpha_2
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_dialogue TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (not (volume_test_object tv_sec_alpha_2 ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)
(script command_script cs_failsafe_alpha_3
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_dialogue TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (not (volume_test_object tv_sec_alpha_3 ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)
(script command_script cs_failsafe_alpha_3a
	(cs_enable_dialogue TRUE)
	(cs_enable_looking TRUE)	
	(cs_enable_moving TRUE)	
	(cs_enable_targeting TRUE)	
	(sleep_until (not (volume_test_object tv_sec_alpha_3 ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)

(script dormant alpha_1_dropoff
	(sleep_until (f_hub_and_radius_check cf_sec_alpha_1 50) 5)
	(sleep 5)
	(ai_cannot_die sq_sec_alpha_c01a FALSE)
	(ai_cannot_die sq_sec_alpha_c01b FALSE)
	(ai_cannot_die sq_sec_alpha_m01 FALSE)
	(f_blip_ai sq_sec_alpha_m01 5)
	(f_blip_ai sq_sec_alpha_c01a 15)
	(f_blip_ai sq_sec_alpha_c01b 15)		
)
(script command_script cs_dropship_alpha_1
	(object_cannot_die (ai_vehicle_get ai_current_actor) TRUE)
	(ai_cannot_die ai_current_squad TRUE) 	
	(sleep 1)
	;(print "BOOOOST")
	(cs_vehicle_speed_instantaneous 1)	
	(cs_vehicle_boost true)
	(cs_fly_to sd_obj_alpha_1/phantom_start)
	(f_load_phantom (ai_vehicle_get_from_spawn_point sq_sec_alpha_cd01/pilot) "right" sq_sec_alpha_c01a sq_sec_alpha_c01b none none)
	(ai_place sq_sec_alpha_m01)
	(ai_cannot_die sq_sec_alpha_m01 TRUE)	
	(ai_force_active sq_sec_alpha_m01 TRUE)
	(ai_force_full_lod sq_sec_alpha_m01)
	;(ai_cannot_die sq_sec_alpha_cd01 FALSE) 
	(cs_fly_to sd_obj_alpha_1/phantom_fly 1)
	(cs_ignore_obstacles TRUE)
	(cs_vehicle_boost false)	
	(cs_face true sd_obj_alpha_1/phantom_face)
	(cs_fly_to sd_obj_alpha_1/phantom_land)	
	(f_unload_phantom (ai_vehicle_get_from_spawn_point sq_sec_alpha_cd01/pilot) "right")
	(wake md_050_sec_alpha1)
	(ai_cannot_die sq_sec_alpha_c01a TRUE)
	(ai_cannot_die sq_sec_alpha_c01b TRUE)
	(ai_force_active sq_sec_alpha_c01a TRUE)
	(ai_force_active sq_sec_alpha_c01b TRUE)
	(ai_force_full_lod sq_sec_alpha_c01a)
	(ai_force_full_lod sq_sec_alpha_c01b)	
	(set m_sec_alpha01_start TRUE)
	(cs_run_command_script sq_sec_alpha_c01a cs_failsafe_alpha_1)
	(cs_run_command_script sq_sec_alpha_c01b cs_failsafe_alpha_1)
	(ai_magically_see sq_sec_alpha_c01a sq_sec_alpha_m01)
	(ai_magically_see sq_sec_alpha_c01b sq_sec_alpha_m01)
	(ai_magically_see sq_sec_alpha_m01 sq_sec_alpha_c01a)
	(ai_magically_see sq_sec_alpha_m01 sq_sec_alpha_c01b)
	(wake alpha_1_dropoff)
	(object_cannot_die (ai_vehicle_get ai_current_actor) FALSE)
	(ai_cannot_die ai_current_squad FALSE)
	(cs_fly_by sd_obj_alpha_1/phantom_fly_2)
	(cs_face false sd_obj_alpha_1/phantom_face)		
	(cs_vehicle_boost true)	
	(cs_fly_to sd_obj_alpha_1/phantom_exit 10)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_pelican_alpha_1
	(ai_cannot_die ai_current_squad TRUE) 
	(sleep 1)
	(cs_vehicle_speed_instantaneous 1)	
	(cs_vehicle_boost true)
	(cs_ignore_obstacles TRUE)		
	(cs_fly_by sd_obj_alpha_1/pelican_start)
	(ai_cannot_die ai_current_squad FALSE)
	(cs_fly_to sd_obj_alpha_1/pelican_fly)
	(cs_face true sd_obj_alpha_1/pelican_face)
	(cs_vehicle_boost false)		
	(cs_vehicle_speed 0.50)
	(sleep 30)	 
	(cs_fly_to sd_obj_alpha_1/pelican_land 1)
	(set g_alpha_1_marine_safe TRUE)
	(wake alpha_1_vehicle_enter)
	(cs_run_command_script sq_sec_alpha_m01 cs_kill_script)
	(f_unblip_ai sq_sec_alpha_m01)
	(f_load_troopers_sec sq_sec_alpha_p01/pilot sq_sec_alpha_p01 300 sq_sec_alpha_m01)
	(sleep 30)		
	(cs_face false sd_obj_alpha_1/pelican_face)
	(cs_vehicle_speed 1)
	(cs_vehicle_boost true)	
	(cs_fly_by sd_obj_alpha_1/pelican_exit 10)
	(ai_erase sq_sec_alpha_m01)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script dormant alpha_1_vehicle_enter
	(sleep s_entry_timeout)
;*	(sleep_until 
		(or 
			(not (objects_can_see_object (players) (ai_get_object sq_sec_alpha_m01) 30))
			(> (objects_distance_to_object (players) (ai_get_object sq_sec_alpha_m01)) 50)
		)
	30 600)
*;
	(ai_vehicle_enter_immediate sq_sec_alpha_m01 (ai_vehicle_get_from_spawn_point sq_sec_alpha_p01/pilot) "pelican_p")
)

(script command_script cs_pelican_alpha_2
	(ai_cannot_die ai_current_squad TRUE) 
	(sleep 1)
	(cs_vehicle_speed_instantaneous 1)	
	(cs_vehicle_boost true)
	(cs_ignore_obstacles TRUE)		
	(cs_fly_to sd_obj_alpha_2/pelican_start)
	(ai_cannot_die ai_current_squad FALSE) 
	(cs_fly_to sd_obj_alpha_2/pelican_fly 1)
	(cs_face true sd_obj_alpha_2/pelican_face)
	(cs_vehicle_boost false)		
	(cs_vehicle_speed 0.50)	
	(sleep 30)
	(cs_fly_to sd_obj_alpha_2/pelican_land 0.5)	
	(set g_alpha_2_marine_safe TRUE)
	(wake alpha_2_vehicle_enter)
	(cs_run_command_script sq_sec_alpha_m02 cs_kill_script)
	(f_unblip_ai sq_sec_alpha_m02)
	(f_load_troopers_sec  sq_sec_alpha_p02/pilot sq_sec_alpha_p02 300 sq_sec_alpha_m02)		
	(cs_face false sd_obj_alpha_2/pelican_face)
	(cs_vehicle_speed 1)	
	(cs_fly_to sd_obj_alpha_2/pelican_fly 1)
	(cs_vehicle_boost true)	
	(cs_fly_to sd_obj_alpha_2/pelican_exit 5)
	(ai_erase sq_sec_alpha_m02)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script dormant alpha_2_vehicle_enter

	(sleep s_entry_timeout)
;*	(sleep_until 
		(or 
			(not (objects_can_see_object (players) (ai_get_object sq_sec_alpha_m02) 30))
			(> (objects_distance_to_object (players) (ai_get_object sq_sec_alpha_m02)) 50)
		)
	30 600)
*;
	(ai_vehicle_enter_immediate sq_sec_alpha_m02 (ai_vehicle_get_from_spawn_point sq_sec_alpha_p02/pilot) "pelican_p")
)

(script dormant alpha_2_dropoff
	(sleep_until (f_hub_and_radius_check cf_sec_alpha_2 75) 5)
	(sleep 5)
	(ai_cannot_die gr_alpha_cov FALSE)
	(ai_cannot_die gr_alpha_marine FALSE)
	(f_blip_ai sq_sec_alpha_m02 5)
	(f_blip_ai sq_sec_alpha_c02a 15)
	(f_blip_ai sq_sec_alpha_c02b 15)	
)

(script command_script cs_dropship_alpha_2
	(object_cannot_die (ai_vehicle_get ai_current_actor) TRUE)
	(ai_cannot_die ai_current_squad TRUE) 
	(cs_vehicle_speed_instantaneous 1)	
	(cs_vehicle_boost true)	
	(cs_fly_to sd_obj_alpha_2/phantom_start)
	(f_load_phantom (ai_vehicle_get_from_spawn_point sq_sec_alpha_cd02/pilot) "left" sq_sec_alpha_c02a sq_sec_alpha_c02b none none)
	(ai_place sq_sec_alpha_m02)
	(ai_force_active sq_sec_alpha_m02 TRUE)
	(ai_force_full_lod sq_sec_alpha_m02)
	(ai_cannot_die sq_sec_alpha_m02 TRUE)
	;(ai_cannot_die ai_current_squad FALSE) 
	(cs_fly_to sd_obj_alpha_2/phantom_fly)
	(cs_ignore_obstacles TRUE)
	(cs_face true sd_obj_alpha_2/phantom_face)
	(cs_vehicle_boost false)			
	(cs_fly_to sd_obj_alpha_2/phantom_land)
	(sleep 120)
	(vehicle_hover (ai_vehicle_get_from_spawn_point sq_sec_alpha_cd02/pilot) TRUE)
	(f_unload_phantom (ai_vehicle_get_from_spawn_point sq_sec_alpha_cd02/pilot) "left")
	(object_cannot_die (ai_vehicle_get ai_current_actor) FALSE)
	(ai_cannot_die ai_current_squad FALSE) 	
	(wake md_050_sec_alpha2)
	(ai_cannot_die sq_sec_alpha_c02a TRUE)
	(ai_force_active sq_sec_alpha_c02a TRUE)
	(ai_cannot_die sq_sec_alpha_c02b TRUE)	
	(ai_force_active sq_sec_alpha_c02b TRUE)
	(ai_force_full_lod sq_sec_alpha_c02a)
	(ai_force_full_lod sq_sec_alpha_c02b)		
	(set m_sec_alpha02_start TRUE)
	(cs_run_command_script sq_sec_alpha_c02a cs_failsafe_alpha_2)
	(cs_run_command_script sq_sec_alpha_c02b cs_failsafe_alpha_2)
	(ai_magically_see sq_sec_alpha_c02a sq_sec_alpha_m02)
	(ai_magically_see sq_sec_alpha_c02b sq_sec_alpha_m02)
	(ai_magically_see sq_sec_alpha_m02 sq_sec_alpha_c02a)
	(ai_magically_see sq_sec_alpha_m02 sq_sec_alpha_c02b)
	(wake alpha_2_dropoff)
	(vehicle_hover (ai_vehicle_get_from_spawn_point sq_sec_alpha_cd02/pilot) false)		
	(cs_face false sd_obj_alpha_2/phantom_face)
	(cs_fly_to sd_obj_alpha_2/phantom_fly_2)
	(cs_vehicle_boost true)		
	(cs_fly_to sd_obj_alpha_2/phantom_exit 5)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_pelican_alpha_3
	(ai_cannot_die ai_current_squad TRUE) 
	(sleep 1)
	(cs_ignore_obstacles TRUE)		
	(cs_fly_by sd_obj_alpha_3/pelican_start)
	(ai_cannot_die ai_current_squad FALSE) 
	(cs_face true sd_obj_alpha_3/pelican_face)
	(cs_fly_by sd_obj_alpha_3/pelican_fly 1)
	(sleep 30)
	(cs_fly_to sd_obj_alpha_3/pelican_land 1)	
	(set g_alpha_3_marine_safe TRUE)
	(wake alpha_3_vehicle_enter)
	(cs_run_command_script sq_sec_alpha_m03 cs_kill_script)
	(f_unblip_ai sq_sec_alpha_m03)
	(f_load_troopers_sec  sq_sec_alpha_p03/pilot sq_sec_alpha_p03 240 sq_sec_alpha_m03)			
	(cs_face false sd_obj_alpha_3/pelican_face)
	(cs_fly_by sd_obj_alpha_3/pelican_fly 2)
	(cs_fly_to sd_obj_alpha_3/pelican_exit 5)
	(ai_erase sq_sec_alpha_m03)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script dormant alpha_3_vehicle_enter
	(sleep s_entry_timeout)
;*	(sleep_until 
		(or 
			(not (objects_can_see_object (players) (ai_get_object sq_sec_alpha_m03) 30))
			(> (objects_distance_to_object (players) (ai_get_object sq_sec_alpha_m03)) 50)
		)
	30 600)
*;
	(ai_vehicle_enter_immediate sq_sec_alpha_m03 (ai_vehicle_get_from_spawn_point sq_sec_alpha_p03/pilot) "pelican_p")
)

;======================================================================
;======================SECONDARY BETA SCRIPTS==========================
;======================================================================

(script dormant sec_obj_beta
	(sleep_until (and (= m_beta_complete FALSE)(= m_sec_beta TRUE))1)
		(set m_sec_started (+ m_sec_started 1))		

			(begin_random_count 1
				(sec_ai_beta_1)
				(sec_ai_beta_2)
				(sec_ai_beta_3)				
			)
		(set m_beta_complete TRUE)
		(set m_sec_complete (+ m_sec_complete 1))			
)
(script static void sec_ai_beta_1
	;(data_mine_set_mission_segment "m52_sec_beta_1")
	(set g_beta_enc 1)	
	(ai_place sq_sec_beta_c01a)
	(ai_force_active sq_sec_beta_c01a TRUE)
	(ai_force_full_lod sq_sec_beta_c01a)			
	(ai_place sq_sec_beta_c01b)	
	(ai_force_active sq_sec_beta_c01b TRUE)
	(ai_force_full_lod sq_sec_beta_c01b)		
	(ai_place sq_sec_beta_c01c)
	(ai_force_active sq_sec_beta_c01c TRUE)
	(ai_force_full_lod sq_sec_beta_c01c)		
	(ai_place sq_sec_beta_m01a)
	(ai_force_active sq_sec_beta_m01a TRUE)
	(ai_force_full_lod sq_sec_beta_m01a)		
		
	(wake md_050_sec_beta1)
	(ai_cannot_die gr_beta_marine TRUE)
	(ai_cannot_die gr_beta_cov TRUE)
	(ai_magically_see sq_sec_beta_c01a sq_sec_beta_m01a)
			
	(ai_magically_see sq_sec_beta_c01b sq_sec_beta_m01a)

	(ai_magically_see sq_sec_beta_c01c sq_sec_beta_m01a)
	
	(ai_magically_see sq_sec_beta_m01a sq_sec_beta_c01a)
				
	(sleep_until (f_hub_and_radius_check cf_sec_beta_1 150))
	(f_blip_ai sq_sec_beta_m01a 5)
	(sleep 30)	
	(f_blip_ai sq_sec_beta_c01a 15)
	(sleep 5)
	(f_blip_ai sq_sec_beta_c01b 15)
	(sleep 5)
	(f_blip_ai sq_sec_beta_c01c 15)	
	(ai_cannot_die gr_beta_cov FALSE)
	(ai_cannot_die gr_beta_marine FALSE)
	(sleep_until (<= (ai_living_count gr_beta_cov) 0))
		(if (> (ai_living_count gr_beta_marine) 0)
			(begin
				(ai_place sq_sec_beta_p01)
				(ai_force_active sq_sec_beta_p01 TRUE)
				(ai_vehicle_reserve_seat sq_sec_beta_p01 "pelican_g" true)		
			)
		)
	(f_unblip_ai sq_sec_beta_m01a)		
	(sleep_until (< (ai_living_count gr_beta_marine) 1))
	(if (> (ai_living_count sq_sec_beta_p01) 1)
		(md_050_sec_success_beta1)
		(md_050_sec_fail_beta1)
	)				
	(f_unblip_flag cf_sec_beta_1)

)
(script static void sec_ai_beta_2
	;(data_mine_set_mission_segment "m52_sec_beta_2")
	(set g_beta_enc 2)			

	(ai_place sq_sec_beta_s02a)
	(ai_force_active sq_sec_beta_s02a TRUE)	
	(ai_place sq_sec_beta_s02b)
	(ai_force_active sq_sec_beta_s02b TRUE)		
	(ai_place sq_sec_beta_s02c)
	(ai_force_active sq_sec_beta_s02c TRUE)
	(ai_place sq_sec_beta_p02)
	(ai_force_active sq_sec_beta_p02 TRUE)
	(wake md_050_sec_beta2)
	(sleep_until (f_hub_and_radius_check cf_sec_beta_2 90))
	(f_blip_ai sq_sec_beta_s02c 15)		
	(f_blip_ai sq_sec_beta_s02b 15)
	(f_blip_ai sq_sec_beta_s02a 15)				
	(sleep_until (< (ai_living_count gr_beta_cov) 1))
	(if (>= (ai_living_count sq_sec_beta_p02) 1)
		(md_050_sec_success_beta2)
		(md_050_sec_fail_beta2)
	)
	(f_unblip_ai sq_sec_beta_p02)

)
(script static void sec_ai_beta_3
	;(data_mine_set_mission_segment "m52_sec_beta_3")
	(set g_beta_enc 3)
	;(set s_banshee_max 9)	
	;(f_banshee_force_max 9)				
	(ai_place sq_sec_beta_b03a)
	(ai_force_active sq_sec_beta_b03a TRUE)
	(ai_cannot_die sq_sec_beta_b03a true)		
	(ai_place sq_sec_beta_m03)
	(ai_force_active sq_sec_beta_m03 TRUE)
	(ai_cannot_die sq_sec_beta_m03 TRUE)
	(ai_force_full_lod sq_sec_beta_m03)		
	(ai_magically_see sq_sec_beta_m03 sq_sec_beta_b03a)
	(ai_magically_see sq_sec_beta_b03a sq_sec_beta_m03)			
	(wake md_050_sec_beta3)	
	(sleep_until (f_hub_and_radius_check cf_sec_beta_3 150))
	(f_blip_ai sq_sec_beta_b03a 15)
	(f_blip_ai sq_sec_beta_m03 5)
	(f_unblip_flag cf_sec_beta_3)		
	(ai_cannot_die sq_sec_beta_m03 FALSE)
	(ai_cannot_die sq_sec_beta_b03a FALSE)	
	(sleep_until 
		(or
			(< (ai_living_count gr_beta_cov) 3)
			(< (ai_living_count sq_sec_beta_m03) 1)
		)30 2400)
		(f_unblip_ai sq_sec_beta_m03)		
		(if (> (ai_living_count sq_sec_beta_m03) 0)
			(begin
				(ai_place sq_sec_beta_p03)
				(ai_force_active sq_sec_beta_p03 TRUE)
			)
		)
	(sleep_until 
		(and
			(< (ai_living_count gr_beta_cov) 1)
			(< (ai_living_count gr_beta_marine) 1)
		)
	5)
	(sleep 120)
	(if (> (ai_living_count sq_sec_beta_p03) 1)
		(md_050_sec_success_beta3)
		(md_050_sec_fail_beta3)
	)

	(set s_banshee_max 7)	
	(ai_force_active sq_sec_beta_b03a FALSE)
	(ai_erase sq_sec_beta_b03a)		
)

(script command_script cs_failsafe_beta_1a
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_dialogue TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (not (volume_test_object tv_sec_beta_1a ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)
(script command_script cs_failsafe_beta_1b
	(cs_enable_looking TRUE)
	(cs_enable_moving FALSE)
	(cs_enable_dialogue TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (not (volume_test_object tv_sec_beta_1b ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)
(script command_script cs_failsafe_beta_1c
	(cs_enable_looking TRUE)
	(cs_enable_moving FALSE)
	(cs_enable_dialogue TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (not (volume_test_object tv_sec_beta_1c ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)
(script command_script cs_failsafe_beta_1d
	(cs_enable_looking TRUE)
	(cs_enable_moving FALSE)
	(cs_enable_dialogue TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (not (volume_test_object tv_sec_beta_1d ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)

(script command_script cs_pelican_beta_1
	(ai_cannot_die ai_current_squad TRUE) 
	(sleep 1)
	(cs_vehicle_speed_instantaneous 1)
	(cs_ignore_obstacles TRUE)
	(cs_vehicle_boost true)
	(cs_fly_to sd_obj_beta_1/pelican_start)
	(cs_fly_to sd_obj_beta_1/pelican_fly)
	(set g_beta_1_marine_safe TRUE)		
	(cs_face true sd_obj_beta_1/pelican_face)
	(cs_vehicle_boost false)	
	(sleep 30)		
	(cs_fly_to sd_obj_beta_1/pelican_land 1)	
	(wake beta_1_vehicle_enter)
	(cs_run_command_script sq_sec_beta_m01a cs_kill_script)
	(f_load_troopers_sec  sq_sec_beta_p01/pilot sq_sec_beta_p01 450 sq_sec_beta_m01a)		
	(cs_face false sd_obj_beta_1/pelican_face)
	(cs_ignore_obstacles FALSE)
	(cs_vehicle_boost TRUE)
	(cs_fly_by sd_obj_beta_1/pelican_exit 5)
	(ai_erase gr_beta_marine)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
; f_all_squad_in_vehicle sq_sec_beta_p01 sq_sec_beta_m01a
;	(= (ai_living_count sq_sec_beta_p01) (f_vehicle_rider_number (ai_vehicle_get_from_squad sq_sec_beta_p01 0))
(script dormant beta_1_vehicle_enter
		
	(sleep s_entry_timeout)

	(ai_vehicle_enter_immediate sq_sec_beta_m01a (ai_vehicle_get_from_spawn_point sq_sec_beta_p01) "pelican_p")		
)

(script command_script cs_failsafe_beta_2a
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_dialogue TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (not (volume_test_object tv_sec_beta_2a ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)


(script command_script cs_pelican_beta_2
	(ai_cannot_die ai_current_squad TRUE) 
	(cs_ignore_obstacles TRUE)
	(sleep 30)
	(vehicle_hover (ai_vehicle_get_from_spawn_point sq_sec_beta_p02/pilot) TRUE)
	(sleep_until (< (ai_living_count gr_beta_cov) 1))
	(vehicle_hover (ai_vehicle_get_from_spawn_point sq_sec_beta_p02/pilot) FALSE)		
	(cs_face false sd_obj_beta_2/pelican_face)
	(cs_fly_to sd_obj_beta_2/pelican_fly_2)
	(cs_ignore_obstacles FALSE)
	(cs_fly_by sd_obj_beta_2/pelican_exit 5)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_failsafe_beta_3a
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_dialogue TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (not (volume_test_object tv_sec_beta_3a ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)

(script command_script cs_pelican_beta_3
	(ai_cannot_die ai_current_squad TRUE) 
	(sleep 1)
	(cs_ignore_obstacles TRUE)	
	(cs_fly_by sd_obj_beta_3/pelican_start)
	(ai_cannot_die ai_current_squad FALSE)		
	(cs_fly_to sd_obj_beta_3/pelican_fly)
	(cs_fly_to sd_obj_beta_3/pelican_fly_2)	
	(cs_face true sd_obj_beta_3/pelican_face)
	(cs_fly_to sd_obj_beta_3/pelican_land 0.5)
	(set g_beta_3_marine_safe TRUE)
	(wake beta_3_vehicle_enter)
	(cs_run_command_script sq_sec_beta_m03 cs_kill_script)
	(f_load_troopers_sec  sq_sec_beta_p03/pilot sq_sec_beta_p03 300 sq_sec_beta_m03)
	(sleep_until (< (ai_living_count gr_beta_cov) 1)30 600)
	(cs_face false sd_obj_beta_3/pelican_face)	
	(cs_ignore_obstacles FALSE)
	(cs_fly_by sd_obj_beta_3/pelican_exit 5)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script dormant beta_3_vehicle_enter
	(sleep s_entry_timeout)
;*	(sleep_until 
		(or 
			(not (objects_can_see_object (players) (ai_get_object sq_sec_alpha_m01) 30))
			(> (objects_distance_to_object (players) (ai_get_object sq_sec_alpha_m01)) 50)
		)
	30 600)
*;
	(ai_vehicle_enter_immediate sq_sec_beta_m03 (ai_vehicle_get_from_spawn_point sq_sec_beta_p03/pilot) "pelican_p")
)

;======================================================================
;======================SECONDARY GAMMA SCRIPTS==========================
;======================================================================

(script dormant sec_obj_gamma
	(sleep_until (and (= m_gamma_complete FALSE)(= m_sec_gamma TRUE))1)
		(set m_sec_started (+ m_sec_started 1))	
			(wake m52_music_09)
			(begin_random_count 1
					(sec_ai_gamma_1)
					(sec_ai_gamma_2)
					(sec_ai_gamma_3)	
			)
		(set m_gamma_complete TRUE)
		(set m_sec_complete (+ m_sec_complete 1))	
)


(script static void sec_ai_gamma_1
	;(data_mine_set_mission_segment "m52_sec_gamma_1")
	(set g_gamma_enc 1)		
	(set g_gamma_complete FALSE)
	(ai_place sq_sec_gamma_p01)
	(ai_force_active sq_sec_gamma_p01 TRUE)
	(ai_cannot_die 	sq_sec_gamma_p01 TRUE)
	(object_ignores_emp (ai_vehicle_get_from_starting_location sq_sec_gamma_p01/pilot) true)	
	(object_cannot_take_damage (ai_vehicle_get_from_spawn_point sq_sec_gamma_p01/pilot))	
	(sleep 30)
	(ai_place sq_sec_gamma_m01)
	(ai_force_active sq_sec_gamma_m01 TRUE)	
	(ai_cannot_die sq_sec_gamma_m01 true)
	(ai_force_full_lod sq_sec_gamma_m01)
	(set ai_buck sq_sec_gamma_m01/odst)			
	(ai_vehicle_enter_immediate sq_sec_gamma_m01/odst (ai_vehicle_get_from_spawn_point sq_sec_gamma_p01/pilot) "falcon_p_l1")
	(sleep 1)
	(objects_attach gamma_1_box "marker01" (ai_vehicle_get_from_spawn_point sq_sec_gamma_p01/pilot) "falcon_p_bench")
	
	(sleep_until (f_hub_and_radius_check cf_sec_gamma_1a 100))

	(sleep_until 
		(or 
			(and
				(< (ai_living_count sq_sec_gamma_m01/odst) 1)
				(< (ai_living_count sq_sec_gamma_p01) 1)
			)
		(= g_gamma_complete TRUE)
		)5)
	(sleep 150)	
	(md_050_sec_success_gamma1)		
	
)
(script static void sec_ai_gamma_2
	;(data_mine_set_mission_segment "m52_sec_gamma_2")
	(set g_gamma_enc 2)	
	(set g_gamma_complete FALSE)
	(set s_banshee_max 7)	
	;(f_banshee_force_max 7)	
	;(ai_place sq_sec_gamma_b02)	
	(ai_force_active sq_sec_gamma_b02 TRUE)
	(sleep 240)
	(ai_place sq_sec_gamma_p02)
	(ai_force_active sq_sec_gamma_p02 TRUE)
	(ai_place sq_sec_gamma_m02)
	(ai_force_active sq_sec_gamma_m02 TRUE)	
	(ai_cannot_die sq_sec_gamma_m02 true)
	(set ai_buck sq_sec_gamma_m02/odst)			
	(ai_force_full_lod sq_sec_gamma_m02)				
	(sleep 1)
	(ai_vehicle_enter_immediate sq_sec_gamma_m02/odst (ai_vehicle_get_from_spawn_point sq_sec_gamma_p02/pilot)"falcon_g_r")
	(sleep 1)
	(ai_cannot_die sq_sec_gamma_p02 TRUE)
	(object_cannot_take_damage (ai_vehicle_get_from_spawn_point sq_sec_gamma_p02/pilot))
	(object_ignores_emp (ai_vehicle_get_from_starting_location sq_sec_gamma_p02/pilot) true)			
	(objects_attach gamma_2_box "marker01" (ai_vehicle_get_from_spawn_point sq_sec_gamma_p02/pilot) "falcon_p_bench")	
	(wake md_050_sec_gamma2) 		
	(sleep_until (f_hub_and_radius_check cf_sec_gamma_2a 100))

	(sleep_until 
		(or 
			(and
				(< (ai_living_count sq_sec_gamma_m02/odst) 1)
				(< (ai_living_count sq_sec_gamma_p02) 1)
			)
		(= g_gamma_complete TRUE)
		)5)
	
	(sleep 150)
	(md_050_sec_success_gamma2)	

	(ai_force_active sq_sec_gamma_b02 FALSE)	
	(ai_erase sq_sec_gamma_b02)

	(set s_banshee_max 7)
)

(script static void sec_ai_gamma_3
	;(data_mine_set_mission_segment "m52_sec_gamma_3")
	(set g_gamma_enc 3)	
	(ai_place sq_sec_gamma_m03a)
	(ai_force_active sq_sec_gamma_m03a TRUE)
 	(ai_cannot_die sq_sec_gamma_m03a TRUE)
 	(set ai_buck sq_sec_gamma_m03a/pilot)		
	(object_cannot_take_damage (ai_vehicle_get_from_spawn_point sq_sec_gamma_m03a/pilot))
	(object_ignores_emp (ai_vehicle_get_from_starting_location sq_sec_gamma_m03a/pilot) true)			 		
 	(ai_place sq_sec_gamma_cd03a)
 	(ai_force_active sq_sec_gamma_cd03a TRUE)
	(sleep 5)
	(sleep_until (> (ai_living_count sq_sec_gamma_m03a) 0))
	(sleep_until 
		(or 
			(< (ai_living_count sq_sec_gamma_m03a) 1)
			(< (ai_living_count sq_sec_gamma_cd03a) 1)
			(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_sec_gamma_cd03a/pilot)) 0)
		))
	(sleep 150)
	(sleep_until 
		(or
				(< (ai_living_count gr_gamma_marine) 1)
				(= g_gamma_3_complete TRUE)
		)	
	)
	(f_unblip_ai sq_sec_gamma_m03a/pilot)			
	(sleep 60)
	(md_050_sec_success_gamma3)	

)


(script command_script cs_failsafe_gamma_1b
	(ai_cannot_die ai_current_actor true)
	(sleep 90)
	(cs_go_to sd_obj_gamma_1/odst_exit)
)

(script dormant gamma_1b_cleanup
	(sleep_until (not (cs_command_script_running sq_sec_gamma_m01/odst cs_failsafe_gamma_1b))5 600)
	(set g_gamma_1_marine_safe TRUE)
	(set g_gamma_complete TRUE)
	(sleep_until (not (volume_test_players tv_gamma_1_end))5)
	(device_set_power dm_gamma_1 0)
	(device_set_position dm_gamma_1 0)
	(sleep 90)
	(ai_erase sq_sec_gamma_m01/odst)
	(falcon_gunner_reserve false)
)

(script command_script cs_falcon_gamma_1a
	(wake md_050_sec_gamma1)
 	(sleep_until (f_hub_and_radius_check cf_sec_gamma_1a 30))
 	(objects_detach gamma_1_box (ai_vehicle_get_from_spawn_point sq_sec_gamma_p01/pilot))	
	(sleep 1)
	(cs_ignore_obstacles TRUE)
	(cs_face false sd_obj_gamma_1/falcon_face_1)
	(f_unblip_flag cf_sec_gamma_1a)
	(f_blip_ai_offset sq_sec_gamma_p01/pilot 1 5)
	(cs_face true sd_obj_gamma_1/falcon_fly)	
	(cs_fly_to sd_obj_gamma_1/falcon_fly_2 4)
	(cs_face false sd_obj_gamma_1/falcon_fly)		
	(cs_vehicle_speed 0.6) 
	(set mission_obj_gamma_1 TRUE)			
	(cs_fly_by sd_obj_gamma_1/falcon_fly_3 3)
	(sleep_until (f_near_object ai_current_squad 40))			
	(cs_fly_by sd_obj_gamma_1/falcon_fly_4 2)		
	(cs_fly_by sd_obj_gamma_1/falcon_fly_5 2)
	(sleep_until (f_near_object ai_current_squad 40))			
	(cs_fly_by sd_obj_gamma_1/falcon_fly_6 2)		
	(cs_fly_by sd_obj_gamma_1/falcon_fly_7 2)
	(sleep_until (f_near_object ai_current_squad 40))			
	(cs_fly_to sd_obj_gamma_1/falcon_fly_8 2)
	(cs_vehicle_speed 0.5)
	(cs_fly_to sd_obj_gamma_1/falcon_fly_9 2)
	(cs_face true sd_obj_gamma_1/falcon_face_2)		
	(cs_fly_to sd_obj_gamma_1/falcon_land_2 0.5)	
	(set mission_obj_gamma_1 FALSE)
	(f_unblip_ai sq_sec_gamma_p01/pilot)
	(sleep 60)
	(vehicle_unload (ai_vehicle_get_from_spawn_point sq_sec_gamma_p01/pilot) "falcon_p")
	(falcon_gunner_reserve true)
	(set g_gamma_1_marine_safe TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_sec_gamma_p01/pilot) "falcon_p_r1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_sec_gamma_p01/pilot) "falcon_p_l1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_sec_gamma_p01/pilot) "falcon_p_r2" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_sec_gamma_p01/pilot) "falcon_p_l2" true)				
	(sleep_until (= (ai_in_vehicle_count sq_sec_gamma_p01) 1))
	(cs_run_command_script sq_sec_gamma_m01 cs_failsafe_gamma_1b)
	(wake gamma_1b_cleanup)
	(sleep 90)
	(cs_face false sd_obj_gamma_1/falcon_face_2)				
	(cs_fly_to sd_obj_gamma_1/falcon_fly_9 2)
	(cs_vehicle_speed 1)
	(cs_ignore_obstacles FALSE)
	(cs_fly_by sd_obj_gamma_1/falcon_exit 5)		
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script static boolean (f_near_object (object o_object)(short s_number))
	(if 
		(<= (objects_distance_to_object (players) o_object) s_number)
	true)
)

(script command_script cs_failsafe_gamma_2a
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_dialogue TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (not (volume_test_object tv_sec_gamma_2a ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)
(script command_script cs_failsafe_gamma_2b
	(ai_cannot_die ai_current_actor true)
	(sleep 90)
	(cs_go_to sd_obj_gamma_2/odst_exit)
)

(script dormant gamma_2b_cleanup
	(sleep_until (not (cs_command_script_running sq_sec_gamma_m02/odst cs_failsafe_gamma_2b))5 600)
	(set g_gamma_2_success TRUE)
	(set g_gamma_complete TRUE)
	(sleep_until (not (volume_test_players tv_gamma_2_end))5)
	(device_set_power dm_gamma_2 0)
	(device_set_position dm_gamma_2 0)
	(sleep 90)	
	(ai_erase sq_sec_gamma_m02/odst)
	(falcon_gunner_reserve false)
)

(script command_script cs_falcon_gamma_2a 
	(sleep_until (f_hub_and_radius_check cf_sec_gamma_2a 50))
	(f_unblip_flag cf_sec_gamma_2a)
	(f_blip_ai_offset sq_sec_gamma_p02/pilot 1 5)
	(sleep 1)
	(sleep 60)
	(cs_vehicle_speed 0.6) 	 		
	(objects_detach gamma_2_box (ai_vehicle_get_from_spawn_point sq_sec_gamma_p02/pilot))	
	(set mission_obj_gamma_2 TRUE)	
	(ai_set_objective sq_sec_gamma_b02 obj_air)
	(sleep 1)	
	(cs_ignore_obstacles TRUE)	
	(cs_fly_by sd_obj_gamma_2/falcon_fly_2 2)
	(cs_fly_by sd_obj_gamma_2/falcon_fly_3 2)	
	(cs_fly_by sd_obj_gamma_2/falcon_fly_4 2)
	(sleep_until (f_near_object ai_current_squad 40))			
	(cs_fly_by sd_obj_gamma_2/falcon_fly_5 2)	
	(cs_fly_by sd_obj_gamma_2/falcon_fly_6 2)
	(sleep_until (f_near_object ai_current_squad 40))		
	(cs_fly_by sd_obj_gamma_2/falcon_fly_7 1)
	(cs_fly_by sd_obj_gamma_2/falcon_fly_8 2)
	(sleep_until (f_near_object ai_current_squad 40))					
	(cs_fly_by sd_obj_gamma_2/falcon_fly_9 2)
	(cs_fly_by sd_obj_gamma_2/falcon_fly_10 2)
	(cs_fly_by sd_obj_gamma_2/falcon_fly_11 2)	
	(cs_face TRUE sd_obj_gamma_2/falcon_face_2)
	(cs_ignore_obstacles FALSE)
	(cs_vehicle_speed 0.3) 				
	(cs_fly_to sd_obj_gamma_2/falcon_land_2 0.5)
	(vehicle_unload (ai_vehicle_get_from_spawn_point sq_sec_gamma_p02/pilot) "falcon_g")
	(falcon_gunner_reserve true)
	(set g_gamma_2_marine_safe TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_sec_gamma_p02/pilot) "falcon_p_r1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_sec_gamma_p02/pilot) "falcon_p_l1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_sec_gamma_p02/pilot) "falcon_p_r2" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_sec_gamma_p02/pilot) "falcon_p_l2" true)		
	(f_unblip_ai sq_sec_gamma_p02/pilot)
	(f_unblip_ai sq_sec_gamma_m02/odst)			
	(sleep 60)			
	(sleep_until (= (ai_in_vehicle_count sq_sec_gamma_p02/pilot)1))
	(cs_run_command_script sq_sec_gamma_m02/odst cs_failsafe_gamma_2b)
	(wake gamma_2b_cleanup)
	(sleep 90)
	(cs_vehicle_speed 1)	
	(cs_face FALSE sd_obj_gamma_2/falcon_face_2) 
	(cs_ignore_obstacles TRUE)										
	(cs_fly_by sd_obj_gamma_2/falcon_exit 5)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
	(set mission_obj_gamma_2 FALSE)
)

(script dormant gamma_2_vehicle_enter
	(cs_run_command_script sq_sec_gamma_m02 cs_kill_script)
	;(unit_open (ai_vehicle_get sq_sec_gamma_p02/pilot))
	(sleep s_entry_timeout)
;*	(sleep_until 
		(or 
			(not (objects_can_see_object (players) (ai_get_object sq_sec_alpha_m01) 30))
			(> (objects_distance_to_object (players) (ai_get_object sq_sec_alpha_m01)) 50)
		)
	30 600)
*;
	(ai_vehicle_enter_immediate sq_sec_gamma_m02/odst (ai_vehicle_get_from_spawn_point sq_sec_gamma_p02/pilot)"falcon_g")
)

(script command_script cs_falcon_gamma_3a
	(sleep 1)
	(cs_fly_by sd_obj_gamma_3/falcon_start 2)
	(cs_ignore_obstacles TRUE)
	(wake md_050_sec_gamma3)

 	(sleep_until 
 		(begin
 				(cs_fly_by sd_obj_gamma_3/falcon_hover_1 1)
 				(cs_fly_by sd_obj_gamma_3/falcon_hover_2 1)
 				(cs_fly_by sd_obj_gamma_3/falcon_hover_3 1)
 				(<= (objects_distance_to_object (players) (ai_vehicle_get_from_spawn_point sq_sec_gamma_m03a/pilot)) 40)
 		)
 	5)
 	(f_unblip_ai sq_sec_gamma_m03a/pilot)
 	(f_blip_ai_offset sq_sec_gamma_m03a/pilot 1 5)	
 	;(ai_cannot_die ai_current_squad FALSE)
	;(object_can_take_damage (ai_vehicle_get_from_spawn_point sq_sec_gamma_m03a/pilot))	 	 	
 	(cs_fly_by sd_obj_gamma_3/falcon_fly_2)
  (set mission_obj_gamma_3 TRUE)
 	(sleep_until (f_near_object ai_current_squad 40))		 		
  (cs_fly_by sd_obj_gamma_3/falcon_fly_3)   
  (cs_fly_by sd_obj_gamma_3/falcon_fly_4)
	(sleep_until (f_near_object ai_current_squad 40))		  
  (cs_fly_by sd_obj_gamma_3/falcon_fly_5)
  (cs_ignore_obstacles FALSE)
  (cs_enable_moving TRUE)
  (cs_enable_looking TRUE)
  (cs_enable_targeting TRUE)
  (ai_set_objective sq_sec_gamma_m03a obj_gamma)
	(f_unblip_ai sq_sec_gamma_m03a/pilot)
	(f_blip_ai sq_sec_gamma_cd03a/pilot 14)	
	(ai_magically_see sq_sec_gamma_m03a sq_sec_gamma_cd03a)
	(sleep_until 
		(or
			(< (ai_living_count sq_sec_gamma_cd03a) 1)
			(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_sec_gamma_cd03a/pilot)) 0)
		)5)
  (set mission_obj_gamma_3 FALSE)	
	;(f_blip_flag cf_sec_gamma_3b 21)  
  (cs_enable_moving FALSE)
  (cs_enable_looking FALSE)
  (cs_enable_targeting TRUE)  
	(cs_fly_to sd_obj_gamma_3/falcon_fly_6 1)
 	(cs_vehicle_speed 0.3)
 	(cs_ignore_obstacles TRUE)		
	(cs_fly_to sd_obj_gamma_3/falcon_fly_7 1)
 	(cs_face TRUE sd_obj_gamma_3/falcon_face)	
  (cs_fly_by sd_obj_gamma_3/falcon_land 0.5)	
	(ai_place sq_sec_gamma_m03b)
	(ai_force_active sq_sec_gamma_m03b TRUE)
	(ai_force_full_lod sq_sec_gamma_m03b)
	(ai_cannot_die sq_sec_gamma_m03b true)
	(ai_place sq_sec_gamma_m03c)
	(ai_force_active sq_sec_gamma_m03c TRUE)
	(ai_force_full_lod sq_sec_gamma_m03c)	
	(ai_cannot_die sq_sec_gamma_m03c true)
	(falcon_gunner_reserve true)	
	(wake gamma_3_vehicle_enter)	 

	(ai_vehicle_enter sq_sec_gamma_m03b (ai_vehicle_get_from_spawn_point sq_sec_gamma_m03a/pilot) "falcon_g")
	(ai_vehicle_enter sq_sec_gamma_m03c (ai_vehicle_get_from_spawn_point sq_sec_gamma_m03a/pilot) "falcon_g")
 	
	(sleep_until (> (ai_in_vehicle_count sq_sec_gamma_m03a)1))
	(sleep_until (> (ai_in_vehicle_count sq_sec_gamma_m03a)2)30 300)
	(falcon_gunner_reserve false)	
	(set g_gamma_3_complete	TRUE)
	;(f_unblip_flag cf_sec_gamma_3b) 
 	(cs_vehicle_speed 1)
 	(cs_face FALSE sd_obj_gamma_3/falcon_face)	
	(cs_fly_to sd_obj_gamma_3/falcon_fly_8 2)	
 	(cs_face true sd_obj_gamma_3/falcon_exit)	 	 		
  (cs_fly_by sd_obj_gamma_3/falcon_exit 5)
  (cs_ignore_obstacles FALSE)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script dormant gamma_3_vehicle_enter
	(set g_gamma_3_marine_safe TRUE)
;	(cs_run_command_script sq_sec_gamma_m03b cs_kill_script)
;	(cs_run_command_script sq_sec_gamma_m03c cs_kill_script)	
	(sleep s_entry_timeout)
;*	(sleep_until 
		(or 
			(not (objects_can_see_object (players) (ai_get_object sq_sec_alpha_m01) 30))
			(> (objects_distance_to_object (players) (ai_get_object sq_sec_alpha_m01)) 50)
		)
	30 600)
*;
	(ai_vehicle_enter_immediate sq_sec_gamma_m03b/gunner (ai_vehicle_get_from_spawn_point sq_sec_gamma_m03a/pilot) "falcon_g_l") 
	(ai_vehicle_enter_immediate sq_sec_gamma_m03c/gunner (ai_vehicle_get_from_spawn_point sq_sec_gamma_m03a/pilot) "falcon_g_r")
)

(script command_script cs_dropship_gamma_3
	(ai_cannot_die sq_sec_gamma_cd03a TRUE) 
	(sleep 1)
	(sleep_until (= mission_obj_gamma_3 true))
; (sleep_until (<= (objects_distance_to_object (players) (ai_vehicle_get_from_spawn_point sq_sec_gamma_m03a/pilot)) 30))
;  (ai_place sq_sec_gamma_b03a)
; 	(ai_force_active sq_sec_gamma_b03a TRUE)
; 	(ai_place sq_sec_gamma_b03b) 
; 	(ai_force_active sq_sec_gamma_b03b TRUE)
 	(sleep 300)
	(cs_fly_to sd_obj_gamma_3/phantom_start)
 	(cs_face TRUE sd_obj_gamma_3/phantom_face)	
	(ai_cannot_die sq_sec_gamma_cd03a FALSE)
	(cs_fly_to sd_obj_gamma_3/phantom_fly)
 	(cs_face FALSE sd_obj_gamma_3/phantom_face)		

)

;======================================================================
;======================SECONDARY DELTA SCRIPTS==========================
;======================================================================


(script dormant sec_obj_delta
	(sleep_until (and (= m_delta_complete FALSE)(= m_sec_delta TRUE))1)
		(set m_sec_started (+ m_sec_started 1))	
			
			(begin_random_count 1
					(sec_ai_delta_1)
					(sec_ai_delta_2)
					(sec_ai_delta_3)	
			)
		(set m_delta_complete TRUE)
		(f_unblip_flag cf_sec_delta_1)
		(f_unblip_flag cf_sec_delta_2)
		(f_unblip_flag cf_sec_delta_3)
		(set m_sec_complete (+ m_sec_complete 1))
)

(script static void sec_ai_delta_1
	;(data_mine_set_mission_segment "m52_sec_delta_1")
	(set g_delta_enc 1)	
	(ai_place sq_sec_delta_cd01a)
	(ai_force_active sq_sec_delta_cd01a TRUE)
	(sleep 5)
	(sleep_until 
		(or
			(> (ai_living_count gr_delta_cov) 0)
			(> (object_get_health delta_comm_01) 0)
			(< (ai_living_count sq_sec_delta_cd01a) 3)
		)
	5)	
	(wake md_050_sec_delta1)
	(sleep_until (f_hub_and_radius_check cf_sec_delta_1 70))	
	(sleep_until 
		(and
			(< (ai_living_count gr_delta_cov) 1)
			(<= (object_get_health delta_comm_01) 0)
		)
	5)
	(md_050_sec_success_delta1)
)


(script static void sec_ai_delta_2
	;(data_mine_set_mission_segment "m52_sec_delta_2")
	(set g_delta_enc 2)	
	(ai_place sq_sec_delta_cd02a)
	(ai_force_active sq_sec_delta_cd02a TRUE)	
	(sleep 5)
	(sleep_until 
		(or
			(< (ai_living_count sq_sec_delta_cd02a) 1)
			(= m_sec_delta02_start true)
		)
	5)
	(sleep 60)
	(wake md_050_sec_delta2)			
	(sleep_until (f_hub_and_radius_check cf_sec_delta_2 70))					 	
	(sleep_until (< (ai_living_count gr_delta_cov) 1))	
	(f_unblip_flag cf_sec_delta_2)
	(md_050_sec_success_delta2)

)

(script static void sec_ai_delta_3
	;(data_mine_set_mission_segment "m52_sec_delta_3")
	(sleep 240)
	(set g_delta_enc 3)	
	(ai_place sq_sec_delta_s03a)
	(ai_force_active sq_sec_delta_s03a TRUE)		
 	(ai_place sq_sec_delta_s03b)
 	(ai_force_active sq_sec_delta_s03b TRUE)				
	(ai_place sq_sec_delta_c03a)
	(ai_force_active sq_sec_delta_c03a TRUE)
  (ai_force_full_lod sq_sec_delta_c03a) 		
	(ai_cannot_die sq_sec_delta_s03a TRUE)
	(ai_cannot_die sq_sec_delta_s03b TRUE)
	(ai_cannot_die sq_sec_delta_c03a TRUE)	
	(sleep 5)
	(sleep_until (> (ai_living_count gr_delta_cov) 0))
	(wake md_050_sec_delta3)
	(sleep_until (f_hub_and_radius_check cf_sec_delta_3 70))
	(f_blip_ai sq_sec_delta_s03a 15)
	(f_blip_ai sq_sec_delta_s03b 15)
	(f_blip_ai sq_sec_delta_c03a 15)
	(ai_cannot_die sq_sec_delta_s03a false)
	(ai_cannot_die sq_sec_delta_s03b false)
	(ai_cannot_die sq_sec_delta_c03a false)		
	(sleep_until (< (ai_living_count gr_delta_cov) 1))	
	(f_unblip_flag cf_sec_delta_3)
	(md_050_sec_success_delta3)	
)

(script command_script cs_failsafe_delta_1
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_dialogue TRUE)
	(cs_enable_targeting TRUE)
	(ai_cannot_die ai_current_actor TRUE)
	(sleep_until (not (volume_test_object tv_sec_delta_1a ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)

(script dormant delta_1_dropoff
	(sleep_until (f_hub_and_radius_check cf_sec_delta_1 70))
	(if (> (object_get_health delta_comm_01) 0) (f_blip_object delta_comm_switch01 blip_interface))
	(sleep 5)
	(ai_cannot_die sq_sec_delta_c01a FALSE)
	(ai_cannot_die sq_sec_delta_c01b FALSE)
	(ai_cannot_die sq_sec_delta_c01c FALSE)		
)
(script dormant delta_1_objective
	(object_create delta_comm_switch01)
 	(object_create delta_comm_01)
 	(sleep 1)	
	(f_bldg_objective delta_comm_01 delta_comm_switch01)
)

(script command_script cs_dropship_delta_1
	(object_cannot_die (ai_vehicle_get ai_current_actor) TRUE)
	(ai_cannot_die ai_current_squad TRUE) 	
	(sleep 1)
	(cs_vehicle_speed_instantaneous 1)	
	(cs_vehicle_boost true)
	(cs_ignore_obstacles TRUE)	
	(cs_fly_to sd_obj_delta_1/phantom_start)
	(f_load_phantom (ai_vehicle_get_from_spawn_point sq_sec_delta_cd01a/pilot) "left" sq_sec_delta_c01a sq_sec_delta_c01b none sq_sec_delta_c01c)  			
	;(attach the crate here!)	
  (cs_fly_to sd_obj_delta_1/phantom_fly)
  ;(ai_cannot_die ai_current_squad FALSE)
 	(cs_vehicle_boost false)	 
 	(cs_face TRUE sd_obj_delta_1/phantom_face)  
 	(cs_fly_to sd_obj_delta_1/phantom_drop 2)
 	(f_unload_phantom (ai_vehicle_get_from_spawn_point sq_sec_delta_cd01a/pilot) "left")	
 	(wake delta_1_objective)
 	(sleep 30)
	(object_cannot_die (ai_vehicle_get ai_current_actor) FALSE)
	(ai_cannot_die ai_current_squad FALSE) 	
 	(ai_force_active sq_sec_delta_c01a true)
  (ai_force_active sq_sec_delta_c01b true)
  (ai_force_active sq_sec_delta_c01c true)		
  (ai_force_full_lod sq_sec_delta_c01a)	
  (ai_force_full_lod sq_sec_delta_c01b)
  (ai_force_full_lod sq_sec_delta_c01c)	
 	(cs_run_command_script sq_sec_delta_c01a cs_failsafe_delta_1)
  (cs_run_command_script sq_sec_delta_c01b cs_failsafe_delta_1)	
 	(cs_run_command_script sq_sec_delta_c01c cs_failsafe_delta_1)
 	(wake delta_1_dropoff)
 	(set m_sec_delta01_start TRUE)
  (cs_face FALSE sd_obj_delta_1/phantom_face)
  (cs_ignore_obstacles FALSE)  	
  (cs_fly_by sd_obj_delta_1/phantom_exit 5)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_failsafe_delta_2
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_dialogue TRUE)
	(cs_enable_targeting TRUE)
	(ai_cannot_die ai_current_actor TRUE)	
	(sleep_until (not (volume_test_object tv_sec_delta_2a ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)

(script dormant delta_2_dropoff
	(sleep_until (f_hub_and_radius_check cf_sec_delta_2 70))
	(sleep 5)
	(ai_cannot_die sq_sec_delta_c02a false)
	(ai_cannot_die sq_sec_delta_c02b false)
	(ai_cannot_die sq_sec_delta_c02c false)
	(ai_cannot_die sq_sec_delta_c02d false)
	(ai_cannot_die sq_sec_delta_c02e false)		
)

(script command_script cs_dropship_delta_2
	(object_cannot_die (ai_vehicle_get ai_current_actor) TRUE)
	(ai_cannot_die ai_current_squad TRUE) 	
	(sleep 1)
	(cs_vehicle_speed_instantaneous 1)	
	(cs_vehicle_boost true)		
	(cs_ignore_obstacles TRUE)
	(cs_fly_to sd_obj_delta_2/phantom_start)
	;(ai_cannot_die sq_sec_delta_cd02a FALSE)
	(f_load_phantom (ai_vehicle_get_from_spawn_point sq_sec_delta_cd02a/pilot) "left" sq_sec_delta_c02a sq_sec_delta_c02b none none)
  (cs_fly_to sd_obj_delta_2/phantom_fly)
	(cs_vehicle_boost false)	  
 	(cs_face TRUE sd_obj_delta_2/phantom_face)
 	(cs_fly_to sd_obj_delta_2/phantom_drop ) 	
 	(f_unload_phantom (ai_vehicle_get_from_spawn_point sq_sec_delta_cd02a/pilot) "left")
	(ai_force_active sq_sec_delta_c02a TRUE) 
	(ai_force_active sq_sec_delta_c02b TRUE)	
 	(ai_force_full_lod sq_sec_delta_c02a)	
  (ai_force_full_lod sq_sec_delta_c02b)	
 	(cs_run_command_script sq_sec_delta_c02a cs_failsafe_delta_2)
 	(cs_run_command_script sq_sec_delta_c02b cs_failsafe_delta_2)		
 	(cs_face FALSE sd_obj_delta_2/phantom_face) 	
 	(sleep 30)
	(ai_place sq_sec_delta_c02c) 	
	(ai_force_active sq_sec_delta_c02c TRUE)
 	(ai_force_full_lod sq_sec_delta_c02c)		
	(ai_place sq_sec_delta_c02d)
	(ai_force_active sq_sec_delta_c02d TRUE)
 	(ai_force_full_lod sq_sec_delta_c02d)		
	(ai_place sq_sec_delta_c02e)
	(ai_force_active sq_sec_delta_c02e TRUE)
 	(ai_force_full_lod sq_sec_delta_c02e)		
	(set m_sec_delta02_start true)
 	(wake delta_2_dropoff)
 	(sleep 1)
	(object_cannot_die (ai_vehicle_get ai_current_actor) FALSE)
	(ai_cannot_die ai_current_squad FALSE) 	
	(sleep 120)
	(cs_ignore_obstacles FALSE)
  (cs_fly_by sd_obj_delta_2/phantom_exit 5)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
					
(script command_script cs_failsafe_delta_3
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_dialogue TRUE)
	(cs_enable_targeting TRUE)
	(sleep_until (not (volume_test_object tv_sec_delta_3a ai_current_actor )))
	(ai_cannot_die ai_current_actor FALSE)
	(sleep 5)
	(ai_kill_silent ai_current_actor)
)

;===================================================================================================
;==================================EXTERIOR SCRIPTS =============================================
;===================================================================================================

(global short s_banshee_max 7)

(script dormant banshee_spawn
	(f_random_banshee_num)
	(begin_random_count 4
		(begin
			(ai_place sq_banshee01)
			(ai_set_clump sq_banshee01 g_clumps_banshee)
		)
		(begin
			(ai_place sq_banshee02)
			(ai_set_clump sq_banshee02 g_clumps_banshee)
		)
		(begin
			(ai_place sq_banshee03)
			(ai_set_clump sq_banshee03 g_clumps_banshee)
		)
		(begin
			(ai_place sq_banshee04)
			(ai_set_clump sq_banshee04 g_clumps_banshee)
		)
		(begin
			(ai_place sq_banshee05)
			(ai_set_clump sq_banshee05 g_clumps_banshee)
		)
		(begin
			(ai_place sq_banshee06)
			(ai_set_clump sq_banshee06 g_clumps_banshee)
		)
		(begin
			(ai_place sq_banshee07)
			(ai_set_clump sq_banshee07 g_clumps_banshee)
		)										
		(begin
			(ai_place sq_banshee08)
			(ai_set_clump sq_banshee08 g_clumps_banshee)
		)
		(begin
			(ai_place sq_banshee09)
			(ai_set_clump sq_banshee09 g_clumps_banshee)
		)
	)		
	(sleep_until
		(begin
			(if (<= (ai_living_count gr_banshee) s_banshee_max)
				(begin_random
					(if 
						(and 
							(= b_banshee_spawn TRUE)
							(<= (ai_living_count gr_banshee) s_banshee_max)
							(<= (ai_living_count sq_banshee01) 1)) 
								(begin
									(ai_place sq_banshee01)
									(ai_set_clump sq_banshee01 g_clumps_banshee)	
								)
						(sleep 5)
					)
					(if 
						(and 
							(= b_banshee_spawn TRUE)
							(<= (ai_living_count gr_banshee) s_banshee_max)
							(<= (ai_living_count sq_banshee02) 1)) 
								(begin
									(ai_place sq_banshee02)
									(ai_set_clump sq_banshee02 g_clumps_banshee)	
								)
						(sleep 5)
					)			
					(if 
						(and 
							(= b_banshee_spawn TRUE)
							(<= (ai_living_count gr_banshee) s_banshee_max)
							(<= (ai_living_count sq_banshee03) 1))
								(begin
									(ai_place sq_banshee03)
									(ai_set_clump sq_banshee03 g_clumps_banshee)	
								)
						(sleep 5)
					)			
					(if 
						(and 
							(= b_banshee_spawn TRUE)
							(<= (ai_living_count gr_banshee) s_banshee_max)
							(<= (ai_living_count sq_banshee04) 1))
								(begin
									(ai_place sq_banshee04)
									(ai_set_clump sq_banshee04 g_clumps_banshee)	
								)
						(sleep 5)
					)				
					(if 
						(and 
							(= b_banshee_spawn TRUE)
							(<= (ai_living_count gr_banshee) s_banshee_max)
							(<= (ai_living_count sq_banshee05) 1))
								(begin
									(ai_place sq_banshee05)
									(ai_set_clump sq_banshee05 g_clumps_banshee)	
								)
						(sleep 5)
					)				
					(if 
						(and 
							(= b_banshee_spawn TRUE)
							(<= (ai_living_count gr_banshee) s_banshee_max)
							(<= (ai_living_count sq_banshee06) 1))
								(begin
									(ai_place sq_banshee06)
									(ai_set_clump sq_banshee06 g_clumps_banshee)
								)
						(sleep 5)
					)
					(if 
						(and 
							(= b_banshee_spawn TRUE)
							(<= (ai_living_count gr_banshee) s_banshee_max)
							(<= (ai_living_count sq_banshee07) 1))
								(begin
									(ai_place sq_banshee07)
									(ai_set_clump sq_banshee07 g_clumps_banshee)
								)
						(sleep 5)
					)
					(if 
						(and 
							(= b_banshee_spawn TRUE)
							(<= (ai_living_count gr_banshee) s_banshee_max)
							(<= (ai_living_count sq_banshee08) 1))
								(begin
									(ai_place sq_banshee08)
									(ai_set_clump sq_banshee08 g_clumps_banshee)
								)
						(sleep 5)
					)
					(if 
						(and 
							(= b_banshee_spawn TRUE)
							(<= (ai_living_count gr_banshee) s_banshee_max)
							(<= (ai_living_count sq_banshee09) 1))
								(begin
									(ai_place sq_banshee09)
									(ai_set_clump sq_banshee09 g_clumps_banshee)
								)
						(sleep 5)
					)															
			)
		)
FALSE)
	)
)

(script static void (f_banshee_force_max (short kill_total))
	(sleep_until
		(begin
			(if (>= (ai_living_count gr_banshee) kill_total)
				(begin_random_count 1
					(ai_erase sq_banshee01)
					(ai_erase sq_banshee02)
					(ai_erase sq_banshee03)
					(ai_erase sq_banshee04)
					(ai_erase sq_banshee05)
					(ai_erase sq_banshee06)
					(ai_erase sq_banshee07)
					(ai_erase sq_banshee08)
					(ai_erase sq_banshee09)
				)
			)
		(<= (ai_living_count gr_banshee) kill_total))
	5)
)

(script dormant banshee_patrol_refresh
	(sleep_until
		(begin
			(if
				(and
					(>= (ai_task_status obj_air/sector_a_patrol) 3)
					(>= (ai_task_status obj_air/sector_b_patrol) 3)
					(>= (ai_task_status obj_air/sector_c_patrol) 3)
					(>= (ai_task_status obj_air/sector_d_patrol) 3)
					(>= (ai_task_status obj_air/sector_e_patrol) 3)					
				)
				(begin
					(ai_reset_objective obj_air/sector_a_patrol)
					(ai_reset_objective obj_air/sector_b_patrol)
					(ai_reset_objective obj_air/sector_c_patrol)
					(ai_reset_objective obj_air/sector_d_patrol)
					(ai_reset_objective obj_air/sector_e_patrol)
					
					;(print "RESETTING PATROL")	
				)
			)
			FALSE)
		)
)

(global short s_random_banshee_num0 0)
(global short s_random_banshee_num1 0)
(global short s_random_banshee_num2 0)
(global short s_random_banshee_num3 0)

(script static void f_random_banshee_num
	(set s_random_banshee_num0 (random_range 1 4))
	(set s_random_banshee_num1 (random_range 1 4))
	(set s_random_banshee_num2 (random_range 1 4))
	(set s_random_banshee_num3 (random_range 1 4))
	;(print "generated random banshee amount")		
)

(script static void follow_falcon_refresh01
	(sleep (random_range (* 30 3) (* 30 9)))
	(ai_reset_objective obj_air/follow_falcon01)
	;(print "RESETTING FOLLOW")
	(set s_random_banshee_num0 (random_range 1 4))
)
(script static void follow_falcon_refresh02
	(sleep (random_range (* 30 3) (* 30 9)))
	(ai_reset_objective obj_air/follow_falcon02)
	;(print "RESETTING FOLLOW")
	(set s_random_banshee_num1 (random_range 1 4))
)
(script static void follow_falcon_refresh01_reinf
	(sleep (random_range (* 30 3) (* 30 9)))
	(ai_reset_objective obj_air/follow_falcon01_reinf)
	;(print "RESETTING FOLLOW")
	(set s_random_banshee_num2 (random_range 1 4))
)
(script static void follow_falcon_refresh02_reinf
	(sleep (random_range (* 30 3) (* 30 9)))
	(ai_reset_objective obj_air/follow_falcon02_reinf)
	;(print "RESETTING FOLLOW")
	(set s_random_banshee_num3 (random_range 1 4))
)

(script static void test_ambients
	(wake phantom_patrol)
	(wake pelican_patrol)
	(wake falcon_patrol)
)
(global boolean b_safe_for_ambient TRUE)
(script dormant phantom_patrol
	(sleep_until
		(begin
			(if 
				(and 
					(> (ai_living_count gr_hub_phantoms) 1)
					(= b_safe_for_ambient false)
					(= b_start_hub true)
				)
				(begin
					(sleep 150)
					(object_destroy gr_hub_phantoms)
				)
			)
			(if 
				(and 
					(= b_banshee_spawn true)
					(< (ai_living_count gr_hub_phantoms) 1)
					(= b_safe_for_ambient true)
				)
				(begin_random_count 1
					(ai_place sq_phantom01_ambient)
					(ai_place sq_phantom02_ambient)
					(ai_place sq_phantom03_ambient)
					(ai_place sq_phantom04_ambient)
				)
			)
		false)
	)
)
(script dormant pelican_patrol
	(sleep_until
		(begin
			(if 
				(and 
					(> (ai_living_count gr_hub_pelicans) 1)
					(= b_safe_for_ambient false)
					(= b_start_hub true)
				)
				(begin
					(sleep 150)
					(object_destroy gr_hub_pelicans)
				)
			)
			(if 
				(and 
					(= b_banshee_spawn true)
					(< (ai_living_count gr_hub_pelicans) 1)
					(= b_safe_for_ambient true)
				)
				(begin_random_count 1
					(ai_place sq_pelican01_ambient)
					(ai_place sq_pelican02_ambient)
					(ai_place sq_pelican03_ambient)
					(ai_place sq_pelican04_ambient)
				)
			)
		false)
	)
)

(script static void initial_falcon
	(begin_random_count 1
		(begin
			(ai_place sq_falcon00_ambient)
			(sleep 60)
			(ai_place sq_falcon_banshees00)
			(ai_prefer_target_ai sq_falcon_banshees00 sq_falcon00_ambient true)
		)
		(print "NULL")
		(print "NULL")
	)
)
(script dormant falcon_patrol
	(initial_falcon)
	(sleep_until
		(begin
			(if 
				(and 
					(> (ai_living_count gr_hub_falcons) 1)
					(= b_safe_for_ambient false)
					(= b_start_hub true)
				)
				(begin
					(sleep 150)
					(object_destroy gr_hub_falcons)
				)
			)
			(if 
				(and 
					(= b_banshee_spawn true)
					(< (ai_living_count gr_hub_falcons) 1)
					(= b_safe_for_ambient true)
				)
				(begin_random_count 1	
					(ai_place sq_falcon01_ambient)
					(ai_place sq_falcon02_ambient)
					(ai_place sq_falcon03_ambient)
					(ai_place sq_falcon04_ambient)
				)
			)
		false)
	)
)

(script dormant cheap_patrol
	(sleep_until
		(begin
			(if 
				(and 
					(> (ai_living_count gr_hub_falcons) 1)
					(> (ai_living_count gr_hub_phantoms) 1)
					(> (ai_living_count gr_hub_pelicans) 1)
					(= b_safe_for_ambient false)
					(= b_start_hub true)
				)
				(begin
					(sleep 150)
					(object_destroy gr_hub_falcons)
					(object_destroy gr_hub_phantoms)
					(object_destroy gr_hub_pelicans)										
				)
			)
			(if 
				(and 
					(= b_banshee_spawn true)
					(< (ai_living_count gr_hub_falcons) 1)
					(< (ai_living_count gr_hub_phantoms) 1)
					(< (ai_living_count gr_hub_pelicans) 1)										
					(= b_safe_for_ambient true)
				)
				(begin_random_count 1
					(ai_place sq_falcon01_ambient)
					(ai_place sq_falcon02_ambient)
					(ai_place sq_falcon03_ambient)
					(ai_place sq_falcon04_ambient)
					(ai_place sq_pelican01_ambient)
					(ai_place sq_pelican02_ambient)
					(ai_place sq_pelican03_ambient)
					(ai_place sq_pelican04_ambient)
					(ai_place sq_phantom01_ambient)
					(ai_place sq_phantom02_ambient)
					(ai_place sq_phantom03_ambient)
					(ai_place sq_phantom04_ambient)										
				)
			)
		false)
	)
)
(script static void erase_ambient_patrol
	(set b_safe_for_ambient false)
	(ai_erase gr_hub_phantoms)
	(ai_erase gr_hub_pelicans)
	(ai_erase gr_hub_falcons)
)	

(script static void start_ambient_patrol
	(set b_safe_for_ambient true)
)

(script command_script hub_phantom01_patrol
	;(cs_enable_targeting TRUE)
	(cs_fly_by sd_hub_phantom01/p0 5)
	(cs_fly_by sd_hub_phantom01/p1 5)
	(cs_fly_by sd_hub_phantom01/p2 5)
	(cs_fly_by sd_hub_phantom01/p3 5)
	(cs_fly_by sd_hub_phantom01/p4 5)
	(cs_fly_by sd_hub_phantom01/p5 5)
	(cs_fly_by sd_hub_phantom01/p6 5)
	(cs_fly_by sd_hub_phantom01/p7 5)
	(cs_fly_by sd_hub_phantom01/p8 5)
	(cs_vehicle_boost true)				
	(cs_fly_by sd_hub_phantom01/p0 5)	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script command_script hub_phantom02_patrol
	;(cs_enable_targeting TRUE)
	(cs_fly_by sd_hub_phantom02/p7 5)
	(cs_fly_by sd_hub_phantom02/p8 5)			
	(cs_fly_by sd_hub_phantom02/p0 5)
	(cs_fly_by sd_hub_phantom02/p1 5)
	(cs_fly_by sd_hub_phantom02/p2 5)
	(cs_fly_by sd_hub_phantom02/p3 5)
	(cs_fly_by sd_hub_phantom02/p4 5)
	(cs_fly_by sd_hub_phantom02/p5 5)
	(cs_fly_by sd_hub_phantom02/p6 5)
	(cs_vehicle_boost true)
	(cs_fly_by sd_hub_phantom02/p9 5)			
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script hub_phantom03_patrol
	;(cs_enable_targeting TRUE)
	(cs_fly_by sd_hub_phantom03/p6 5)		
	(cs_fly_by sd_hub_phantom03/p7 5)
	(cs_fly_by sd_hub_phantom03/p8 5)			
	(cs_fly_by sd_hub_phantom03/p0 5)
	(cs_fly_by sd_hub_phantom03/p1 5)
	(cs_fly_by sd_hub_phantom03/p2 5)
	(cs_fly_by sd_hub_phantom03/p3 5)
	(cs_fly_by sd_hub_phantom03/p4 5)
	(cs_fly_by sd_hub_phantom03/p5 5)
	(cs_vehicle_boost true)	
	(cs_fly_by sd_hub_phantom03/p9 5)	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script hub_phantom04_patrol
	;(cs_enable_targeting TRUE)
	(cs_fly_by sd_hub_phantom04/p3 5)
	(cs_fly_by sd_hub_phantom04/p4 5)
	(cs_fly_by sd_hub_phantom04/p5 5)		
	(cs_fly_by sd_hub_phantom04/p6 5)		
	(cs_fly_by sd_hub_phantom04/p7 5)
	(cs_fly_by sd_hub_phantom04/p8 5)			
	(cs_fly_by sd_hub_phantom04/p0 5)
	(cs_fly_by sd_hub_phantom04/p1 5)
	(cs_fly_by sd_hub_phantom04/p2 5)
	(cs_vehicle_boost true)		
	(cs_fly_by sd_hub_phantom04/p9 5)			
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script hub_falcon00_patrol
	(cs_vehicle_boost true)	
	;(cs_enable_targeting true)
	;(cs_enable_looking true)
	(cs_vehicle_speed 0.5)
	(cs_fly_by sd_hub_falcon00/p0 4)
	(ai_vitality_pinned sq_falcon00_ambient)	
	(cs_fly_by sd_hub_falcon00/p1 4)
	(unit_set_current_vitality sq_falcon00_ambient 1 1)
	(cs_fly_by sd_hub_falcon00/p2 4)
	(cs_fly_by sd_hub_falcon00/p3 4)
	(cs_fly_by sd_hub_falcon00/p4 4)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script command_script hub_banshee00_patrol
	;(cs_vehicle_boost true)	
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_vehicle_speed 0.7)	
	(cs_fly_by sd_hub_falcon00/p0 10)
	(if (< (ai_living_count sq_falcon00_ambient)1)
		(begin
			(cs_vehicle_speed 1) 
			(cs_vehicle_boost true)
		)
	)
	(cs_fly_by sd_hub_falcon00/p1 10)
	(if (< (ai_living_count sq_falcon00_ambient)1)
		(begin
			(cs_vehicle_speed 1) 
			(cs_vehicle_boost true)
		)
	)	
	(cs_fly_by sd_hub_falcon00/p2 10)
	(if (< (ai_living_count sq_falcon00_ambient)1)
		(begin
			(cs_vehicle_speed 1) 
			(cs_vehicle_boost true)
		)
	)	
	(cs_fly_by sd_hub_falcon00/p3 10)
	(if (< (ai_living_count sq_falcon00_ambient)1)
		(begin
			(cs_vehicle_speed 1) 
			(cs_vehicle_boost true)
		)
	)	
	(cs_fly_by sd_hub_falcon00/p4 10)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script hub_falcon01_patrol
	(ai_cannot_die ai_current_squad TRUE)
	(cs_fly_by sd_hub_falcon01/p0 2)
	(ai_cannot_die ai_current_squad FALSE)	
	(cs_fly_by sd_hub_falcon01/p1 2)
	(cs_fly_by sd_hub_falcon01/p2 2)
	(cs_fly_by sd_hub_falcon01/p3 2)
	(cs_fly_by sd_hub_falcon01/p4 2)
	(cs_fly_by sd_hub_falcon01/p5 2)
	(cs_fly_by sd_hub_falcon01/p6 2)
	(cs_fly_by sd_hub_falcon01/p7 2)
	(cs_fly_by sd_hub_falcon01/p8 2)
	(cs_fly_by sd_hub_falcon01/p9 2)
	(cs_fly_by sd_hub_falcon01/p10 2)
	(cs_fly_by sd_hub_falcon01/p11 2)
	(cs_fly_by sd_hub_falcon01/p12 2)
	(cs_fly_by sd_hub_falcon01/p13 2)
	(cs_fly_by sd_hub_falcon01/p14 2)
	(cs_fly_by sd_hub_falcon01/p15 2)
	(cs_fly_by sd_hub_falcon01/p16 2)
	(cs_vehicle_boost true)	
	(cs_fly_by sd_hub_falcon01/p17 5)	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script command_script hub_falcon02_patrol
	(ai_cannot_die ai_current_squad TRUE)
	(cs_fly_by sd_hub_falcon02/p0 2)
	(ai_cannot_die ai_current_squad FALSE)	
	(cs_fly_by sd_hub_falcon02/p1 2)
	(cs_fly_by sd_hub_falcon02/p2 2)
	(cs_fly_by sd_hub_falcon02/p3 2)
	(cs_fly_by sd_hub_falcon02/p4 2)
	(cs_fly_by sd_hub_falcon02/p5 2)
	(cs_fly_by sd_hub_falcon02/p6 2)
	(cs_fly_by sd_hub_falcon02/p7 2)
	(cs_fly_by sd_hub_falcon02/p8 2)
	(cs_fly_by sd_hub_falcon02/p9 2)
	(cs_fly_by sd_hub_falcon02/p10 2)
	(cs_fly_by sd_hub_falcon02/p11 2)
	(cs_fly_by sd_hub_falcon02/p12 2)
	(cs_fly_by sd_hub_falcon02/p13 2)
	(cs_fly_by sd_hub_falcon02/p14 5)		
	(cs_vehicle_boost true)	
	(cs_fly_by sd_hub_falcon02/p15 5)	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script command_script hub_falcon03_patrol
	(ai_cannot_die ai_current_squad TRUE)
	(cs_fly_by sd_hub_falcon03/p0 2)
	(ai_cannot_die ai_current_squad FALSE)	
	(cs_fly_by sd_hub_falcon03/p1 2)
	(cs_fly_by sd_hub_falcon03/p2 2)
	(cs_fly_by sd_hub_falcon03/p3 2)
	(cs_fly_by sd_hub_falcon03/p4 2)
	(cs_fly_by sd_hub_falcon03/p5 2)
	(cs_fly_by sd_hub_falcon03/p6 2)
	(cs_fly_by sd_hub_falcon03/p7 2)
	(cs_fly_by sd_hub_falcon03/p8 2)
	(cs_fly_by sd_hub_falcon03/p9 2)
	(cs_fly_by sd_hub_falcon03/p10 2)
	(cs_fly_by sd_hub_falcon03/p11 2)
	(cs_fly_by sd_hub_falcon03/p12 2)
	(cs_fly_by sd_hub_falcon03/p13 2)
	(cs_fly_by sd_hub_falcon03/p14 2)
	(cs_fly_by sd_hub_falcon03/p15 2)
	(cs_fly_by sd_hub_falcon03/p16 2)
	(cs_fly_by sd_hub_falcon03/p17 2)
	(cs_fly_by sd_hub_falcon03/p18 2)
	(cs_fly_by sd_hub_falcon03/p19 2)
	(cs_fly_by sd_hub_falcon03/p20 2)
	(cs_vehicle_boost true)	
	(cs_fly_by sd_hub_falcon03/p21 5)	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script command_script hub_falcon04_patrol
	(ai_cannot_die ai_current_squad TRUE)
	(cs_fly_by sd_hub_falcon04/p0 2)
	(ai_cannot_die ai_current_squad FALSE)	
	(cs_fly_by sd_hub_falcon04/p1 2)
	(cs_fly_by sd_hub_falcon04/p2 2)
	(cs_fly_by sd_hub_falcon04/p3 2)
	(cs_fly_by sd_hub_falcon04/p4 2)
	(cs_fly_by sd_hub_falcon04/p5 2)
	(cs_fly_by sd_hub_falcon04/p6 2)
	(cs_fly_by sd_hub_falcon04/p7 2)
	(cs_fly_by sd_hub_falcon04/p8 2)
	(cs_fly_by sd_hub_falcon04/p9 2)
	(cs_fly_by sd_hub_falcon04/p10 2)
	(cs_fly_by sd_hub_falcon04/p11 2)
	(cs_fly_by sd_hub_falcon04/p12 2)
	(cs_fly_by sd_hub_falcon04/p13 2)
	(cs_fly_by sd_hub_falcon04/p14 2)
	(cs_fly_by sd_hub_falcon04/p15 2)
	(cs_fly_by sd_hub_falcon04/p16 2)
	(cs_fly_by sd_hub_falcon04/p17 2)
	(cs_fly_by sd_hub_falcon04/p18 2)
	(cs_fly_by sd_hub_falcon04/p19 2)
	(cs_fly_by sd_hub_falcon04/p20 2)
	(cs_vehicle_boost true)	
	(cs_fly_by sd_hub_falcon04/p21 5)	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script command_script hub_pelican01_patrol
	(ai_cannot_die ai_current_squad TRUE)
	(cs_fly_by sd_hub_pelican01/p0 2)
	(ai_cannot_die ai_current_squad FALSE)	
	(cs_fly_by sd_hub_pelican01/p1 2)
	(cs_fly_by sd_hub_pelican01/p2 2)
	(cs_fly_by sd_hub_pelican01/p3 2)
	(cs_fly_by sd_hub_pelican01/p4 2)
	(cs_ignore_obstacles TRUE)
	(cs_face true sd_hub_pelican01/p6)
	(cs_fly_to sd_hub_pelican01/p5 1)
	(sleep 300)
	(cs_fly_by sd_hub_pelican01/p7 2)
	(cs_face false sd_hub_pelican01/p6)	
	(cs_ignore_obstacles false)	
	(cs_fly_by sd_hub_pelican01/p8 2)
	(cs_fly_by sd_hub_pelican01/p9 2)
	(cs_fly_by sd_hub_pelican01/p10 2)
	(cs_vehicle_boost true)		
	(cs_fly_by sd_hub_pelican01/p11 2)	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script command_script hub_pelican02_patrol
	(ai_cannot_die ai_current_squad TRUE)
	(cs_fly_by sd_hub_pelican02/p0 2)
	(ai_cannot_die ai_current_squad FALSE)	
	(cs_fly_by sd_hub_pelican02/p1 2)
	(cs_fly_by sd_hub_pelican02/p2 2)
	(cs_fly_by sd_hub_pelican02/p3 2)
	(cs_fly_by sd_hub_pelican02/p4 2)
	(cs_ignore_obstacles TRUE)
	(cs_face true sd_hub_pelican02/p6)
	(cs_fly_to sd_hub_pelican02/p5 1)
	(sleep 300)
	(cs_fly_by sd_hub_pelican02/p7 2)
	(cs_face false sd_hub_pelican02/p6)	
	(cs_ignore_obstacles false)	
	(cs_fly_by sd_hub_pelican02/p8 2)
	(cs_vehicle_boost true)		
	(cs_fly_by sd_hub_pelican02/p9 2)	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script command_script hub_pelican03_patrol
	(ai_cannot_die ai_current_squad TRUE)
	(cs_fly_by sd_hub_pelican03/p0 2)
	(ai_cannot_die ai_current_squad FALSE)	
	(cs_fly_by sd_hub_pelican03/p1 2)
	(cs_fly_by sd_hub_pelican03/p2 2)
	(cs_fly_by sd_hub_pelican03/p3 2)
	(cs_fly_by sd_hub_pelican03/p4 2)
	(cs_ignore_obstacles TRUE)
	(cs_face true sd_hub_pelican03/p6)
	(cs_fly_to sd_hub_pelican03/p5 1)
	(sleep 300)
	(cs_fly_by sd_hub_pelican03/p7 2)
	(cs_face false sd_hub_pelican03/p6)	
	(cs_ignore_obstacles false)	
	(cs_fly_by sd_hub_pelican03/p8 2)
	(cs_vehicle_boost true)		
	(cs_fly_by sd_hub_pelican03/p9 2)	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script command_script hub_pelican04_patrol
	(ai_cannot_die ai_current_squad TRUE)
	(cs_fly_by sd_hub_pelican04/p0 2)
	(ai_cannot_die ai_current_squad FALSE)	
	(cs_fly_by sd_hub_pelican04/p1 2)
	(cs_fly_by sd_hub_pelican04/p2 2)
	(cs_fly_by sd_hub_pelican04/p3 2)
	(cs_fly_by sd_hub_pelican04/p4 2)
	(cs_ignore_obstacles TRUE)
	(cs_face true sd_hub_pelican04/p6)
	(cs_fly_to sd_hub_pelican04/p5 1)
	(sleep 300)
	(cs_fly_by sd_hub_pelican04/p7 2)
	(cs_face false sd_hub_pelican04/p6)	
	(cs_ignore_obstacles false)	
	(cs_fly_by sd_hub_pelican04/p8 2)
	(cs_vehicle_boost true)		
	(cs_fly_by sd_hub_pelican04/p9 2)	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
;===================================================================================================
;=======================================FALCON SCRIPTS =============================================
;===================================================================================================
; check to see if anyone is in any flying vehicle -banshee or falcon
(script static boolean f_players_flying
	(if
		(or
			(= (unit_in_vehicle_type player0 g_falcon_type) TRUE)							
			(= (unit_in_vehicle_type player0 g_banshee_type) TRUE)
			(= (unit_in_vehicle_type player1 g_falcon_type) TRUE)							
			(= (unit_in_vehicle_type player1 g_banshee_type) TRUE)
			(= (unit_in_vehicle_type player2 g_falcon_type) TRUE)							
			(= (unit_in_vehicle_type player2 g_banshee_type) TRUE)
			(= (unit_in_vehicle_type player3 g_falcon_type) TRUE)							
			(= (unit_in_vehicle_type player3 g_banshee_type) TRUE)									
		)
	true)
)

(script static boolean (f_player_flying (player actor))
	(if
		(or
			(= (unit_in_vehicle_type actor g_falcon_type) TRUE)							
			(= (unit_in_vehicle_type actor g_banshee_type) TRUE)
		)
	true)
)
(global boolean b_falcon_dispatched01 FALSE)
(global boolean b_falcon_dispatched02 FALSE)
;(global boolean g_falcon01_available TRUE)

(script static boolean (b_falcon_available01 (ai falcon)(ai falcon_squad))
	(if
		(or
			(and
				(or
					(and 
						(= (f_bsp_any_player 2) true)
						(volume_test_objects tv_loc_building_a (ai_vehicle_get_from_spawn_point falcon))
					)
					(and 
						(volume_test_players tv_loc_building_a)
						(volume_test_objects tv_loc_building_a (ai_vehicle_get_from_spawn_point falcon))						
					)
					(f_players_in_falcon falcon_squad)
				)
				(> (object_get_health (ai_vehicle_get_from_spawn_point falcon))0)	
				(= b_falcon_dispatched01 FALSE)						
			)
			(and
				(or 
					(and
						(= (f_bsp_any_player 3) true)
						(volume_test_objects tv_loc_building_b (ai_vehicle_get_from_spawn_point falcon))
					)
					(and 
							(volume_test_players tv_loc_building_b)
							(volume_test_objects tv_loc_building_b (ai_vehicle_get_from_spawn_point falcon))
					)
					(f_players_in_falcon falcon_squad)
				)
				(> (object_get_health (ai_vehicle_get_from_spawn_point falcon))0)	
				(= b_falcon_dispatched01 FALSE)						
			)
			(and
				(or 
					(and
						(= (f_bsp_any_player 4) true)
						(volume_test_objects tv_loc_building_c (ai_vehicle_get_from_spawn_point falcon))
					)
					(and 
							(volume_test_players tv_loc_building_c)
							(volume_test_objects tv_loc_building_c (ai_vehicle_get_from_spawn_point falcon))
					)
					(f_players_in_falcon falcon_squad)
				)
				(> (object_get_health (ai_vehicle_get_from_spawn_point falcon))0)	
				(= b_falcon_dispatched01 FALSE)						
			)				
			(and
				(or
					(and
						(volume_test_players tv_loc_building_start)
						(volume_test_objects tv_loc_building_start (ai_vehicle_get_from_spawn_point falcon))
					)
					(f_players_in_falcon falcon_squad)
				)
				(> (object_get_health (ai_vehicle_get_from_spawn_point falcon))0)
				(= b_falcon_dispatched01 FALSE)						
			)					
		)
true)
)
(script static boolean (b_falcon_available02 (ai falcon)(ai falcon_squad))
	(if
		(or
			(and
				(or
					(and 
						(= (f_bsp_any_player 2) true)
						(volume_test_objects tv_loc_building_a (ai_vehicle_get_from_spawn_point falcon))
					)
					(and 
						(volume_test_players tv_loc_building_a)
						(volume_test_objects tv_loc_building_a (ai_vehicle_get_from_spawn_point falcon))						
					)
					(f_players_in_falcon falcon_squad)
				)
				(> (object_get_health (ai_vehicle_get_from_spawn_point falcon))0)	
				(= b_falcon_dispatched02 FALSE)						
			)
			(and
				(or 
					(and
						(= (f_bsp_any_player 3) true)
						(volume_test_objects tv_loc_building_b (ai_vehicle_get_from_spawn_point falcon))
					)
					(and 
							(volume_test_players tv_loc_building_b)
							(volume_test_objects tv_loc_building_b (ai_vehicle_get_from_spawn_point falcon))
					)
					(f_players_in_falcon falcon_squad)
				)
				(> (object_get_health (ai_vehicle_get_from_spawn_point falcon))0)	
				(= b_falcon_dispatched02 FALSE)						
			)
			(and
				(or 
					(and
						(= (f_bsp_any_player 4) true)
						(volume_test_object tv_loc_building_c (ai_vehicle_get_from_spawn_point falcon))
					)
					(and 
							(volume_test_players tv_loc_building_c)
							(volume_test_objects tv_loc_building_c (ai_vehicle_get_from_spawn_point falcon))
					)
					(f_players_in_falcon falcon_squad)
				)
				(> (object_get_health (ai_vehicle_get_from_spawn_point falcon))0)	
				(= b_falcon_dispatched02 FALSE)						
			)				

			(and
				(or
					(and
						(volume_test_players tv_loc_building_start)
						(volume_test_objects tv_loc_building_start (ai_vehicle_get_from_spawn_point falcon))
					)
					(f_players_in_falcon falcon_squad)
				)
				(> (object_get_health (ai_vehicle_get_from_spawn_point falcon))0)
				(= b_falcon_dispatched02 FALSE)						
			)					
		)
true)
)
;(volume_test_object tv_loc_building_start (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle))
;(object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle))
;(object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01))
;(> (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle)) 0)

(global short s_falcons_active 0)
(global short s_falcons_allowed 1)
(global boolean b_falcon01a_nanny FALSE)
(global boolean b_falcon02a_nanny FALSE)
(global boolean b_falcon01b_nanny FALSE)
(global boolean b_falcon02b_nanny FALSE)
(global boolean b_falcon01c_nanny FALSE)
(global boolean b_falcon02c_nanny FALSE)	
(global boolean b_falcon01_start_nanny FALSE)
(global boolean b_falcon02_start_nanny FALSE)
;*
(script continuous test_f_falcons_available
	(sleep 30)
	(f_falcons_available)
)
*;
(script static void f_falcons_available
	(set s_falcons_active 0)
	(if (= (b_falcon_available01 sq_v_falcon01/vehicle sq_v_falcon01) true) (set s_falcons_active (+ s_falcons_active 1)))
	(if (= (b_falcon_available01 sq_v_falcon01_reinf/vehicle sq_v_falcon01_reinf) true) (set s_falcons_active (+ s_falcons_active 1)))
	(if (= (b_falcon_available02 sq_v_falcon02/vehicle sq_v_falcon02) true) (set s_falcons_active (+ s_falcons_active 1)))		
	(if (= (b_falcon_available02 sq_v_falcon02_reinf/vehicle sq_v_falcon02_reinf) true) (set s_falcons_active (+ s_falcons_active 1)))
	;(if (= s_falcons_active 0) (print "0"))	
	;(if (= s_falcons_active 1) (print "1"))
	;(if (= s_falcons_active 2) (print "2"))
)
(script static void f_falcon_nanny
	; count up the amount of falcons that are currently available 
	(f_falcons_available)
	;(print "checking for first falcon")		
	(if (= (g_coop_mode) true)(set s_falcons_allowed 2))
	(sleep 1)
	(if (= (g_coop_mode) false)
		(begin
			(cond
				((and
						(volume_test_players tv_loc_building_a) 
						(= b_falcon_dispatched01 FALSE)
						(< s_falcons_active s_falcons_allowed)
					)
					(begin
						(marine_clean)
						(if 
							(and
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle))0)
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle))0)
								(= (b_falcon_available01 sq_v_falcon01/vehicle sq_v_falcon01) false)
								(= (b_falcon_available01 sq_v_falcon01_reinf/vehicle sq_v_falcon01_reinf) false)
							)
							(f_falcon_reinf01_bldg_a)
						)
					)
				)
				((and
						(volume_test_players tv_loc_building_b) 
						(= b_falcon_dispatched01 FALSE)
						(< s_falcons_active s_falcons_allowed)
					)					
					(begin
						(marine_clean)
						(if
							(and
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle))0)
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle))0)
								(= (b_falcon_available01 sq_v_falcon01/vehicle sq_v_falcon01) false)
								(= (b_falcon_available01 sq_v_falcon01_reinf/vehicle sq_v_falcon01_reinf) false)										
							)
							(f_falcon_reinf01_bldg_b)
						)
					)
				)
				((and 
						(volume_test_players tv_loc_building_c) 
						(= b_falcon_dispatched01 FALSE)
						(< s_falcons_active s_falcons_allowed)
					)					
					(begin
						(marine_clean)
						(if
							(and 
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle))0)
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle))0)
								(= (b_falcon_available01 sq_v_falcon01/vehicle sq_v_falcon01) false)
								(= (b_falcon_available01 sq_v_falcon01_reinf/vehicle sq_v_falcon01_reinf) false)								
							)
							(f_falcon_reinf01_bldg_c)
						)
					)
			 	)
				((and 
						(= b_falcon_dispatched01 FALSE)
						(< s_falcons_active s_falcons_allowed)
					)					
					(begin
						(marine_clean)
						(if
							(and 
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle))0)
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle))0)
								(= (b_falcon_available01 sq_v_falcon01/vehicle sq_v_falcon01) false)
								(= (b_falcon_available01 sq_v_falcon01_reinf/vehicle sq_v_falcon01_reinf) false)										
							)
							(f_falcon_reinf01_bldg_start)
						)
					)
				)			 	
			)
		)
		(begin
			(cond
				((and 
						(volume_test_players tv_loc_building_a) 
						(= b_falcon_dispatched01 FALSE)
						(< s_falcons_active s_falcons_allowed)
					)
					(begin
						(marine_clean)
						(sleep 10)
						(if 
							(and 
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle))0)
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle))0)
								(= (b_falcon_available01 sq_v_falcon01/vehicle sq_v_falcon01) false)
								(= (b_falcon_available01 sq_v_falcon01_reinf/vehicle sq_v_falcon01_reinf) false)
							)
							(f_falcon_reinf01_bldg_a)
						)
					)
				)
				((and
						(volume_test_players tv_loc_building_b) 
						(= b_falcon_dispatched01 FALSE)
						(< s_falcons_active s_falcons_allowed)								
					)					
					(begin
						(marine_clean)
						(if
							(and 
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle))0)
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle))0)
								(= (b_falcon_available01 sq_v_falcon01/vehicle sq_v_falcon01) false)
								(= (b_falcon_available01 sq_v_falcon01_reinf/vehicle sq_v_falcon01_reinf) false)										
							)
							(f_falcon_reinf01_bldg_b)
						)
					)
				)
				((and 
						(volume_test_players tv_loc_building_c) 
						(= b_falcon_dispatched01 FALSE)
						(< s_falcons_active s_falcons_allowed)								
					)					
					(begin
						(marine_clean)
						(if
							(and 
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle))0)
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle))0)
								(= (b_falcon_available01 sq_v_falcon01/vehicle sq_v_falcon01) false)
								(= (b_falcon_available01 sq_v_falcon01_reinf/vehicle sq_v_falcon01_reinf) false)							
							)
							(f_falcon_reinf01_bldg_c)
						)
					)
			 	)
				((and 
						(= b_falcon_dispatched01 FALSE)
						(< s_falcons_active s_falcons_allowed)								
					)					
					(begin
						(marine_clean)
						(if
							(and 
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle))0)
								(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle))0)
								(= (b_falcon_available01 sq_v_falcon01/vehicle sq_v_falcon01) false)
								(= (b_falcon_available01 sq_v_falcon01_reinf/vehicle sq_v_falcon01_reinf) false)										
							)
							(f_falcon_reinf01_bldg_start)
						)
					)
				)			 	
			)
			(sleep 30)
			(f_falcons_available)
			;(print "checking for second falcon")						
			(cond
				((and 
						(volume_test_players tv_loc_building_a) 
						(= b_falcon_dispatched02 FALSE)
						(< s_falcons_active s_falcons_allowed)								
					)
					(begin
						(marine_clean)
						(if
							(and 
									(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle))0)
									(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle))0)
									(= (b_falcon_available02 sq_v_falcon02/vehicle sq_v_falcon02) false)
									(= (b_falcon_available02 sq_v_falcon02_reinf/vehicle sq_v_falcon02_reinf) false)											
								)
							(f_falcon_reinf02_bldg_a)
						)
					)
				)
				((and
						(volume_test_players tv_loc_building_b) 
						(= b_falcon_dispatched02 FALSE)
						(< s_falcons_active s_falcons_allowed)								
					)						
					(begin
						(marine_clean)
						(if
							(and 
									(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle))0)
									(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle))0)
									(= (b_falcon_available02 sq_v_falcon02/vehicle sq_v_falcon02) false)
									(= (b_falcon_available02 sq_v_falcon02_reinf/vehicle sq_v_falcon02_reinf) false)											
								)
							(f_falcon_reinf02_bldg_b)
						)
					)
				)
				((and		 
						(volume_test_players tv_loc_building_c) 
						(= b_falcon_dispatched02 FALSE)
						(< s_falcons_active s_falcons_allowed)								
					)					
					(begin
						(marine_clean)
						(if
							(and 
									(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle))0)
									(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle))0)
									(= (b_falcon_available02 sq_v_falcon02/vehicle sq_v_falcon02) false)
									(= (b_falcon_available02 sq_v_falcon02_reinf/vehicle sq_v_falcon02_reinf) false)											
								)
							(f_falcon_reinf02_bldg_c)
						)
					)
			 	)
				((and 
						(= b_falcon_dispatched02 FALSE)
						(< s_falcons_active s_falcons_allowed)								
					)					
					(begin
						(marine_clean)
						(if
							(and 
									(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle))0)
									(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle))0)
									(= (b_falcon_available02 sq_v_falcon02/vehicle sq_v_falcon02) false)
									(= (b_falcon_available02 sq_v_falcon02_reinf/vehicle sq_v_falcon02_reinf) false)													
								)
						(f_falcon_reinf02_bldg_start)
						)
					)
				)			 	
			)
		)
	)
)
(script static void f_falcon_reinf01_bldg_start
	;(print "FALCON REINFORCEMENT STARTING")						
	(set b_falcon_dispatched01 TRUE)
	(set b_falcon_evac_dialog true)
	(sleep 1)	
	(set b_falcon01_start_nanny TRUE)								
	(ai_place sq_v_falcon01_reinf)
	(ai_force_active sq_v_falcon01_reinf TRUE)
	(ai_allegiance human player)
	(ai_allegiance player human)		
	(sleep 1)
	(cs_run_command_script sq_v_falcon01_reinf/vehicle cs_reinforcement_falcon01_start)
	(sleep 30)
	(cs_queue_command_script sq_v_falcon01_reinf cs_marine_script)
)
(script static void f_falcon_reinf02_bldg_start
	;(print "SECOND FALCON REINFORCEMENT STARTING")								
	(set b_falcon_dispatched02 TRUE)
	(set b_falcon_evac_dialog true)
	(sleep 1)
	(set b_falcon02_start_nanny TRUE)											
	(ai_place sq_v_falcon02_reinf)
	(ai_force_active sq_v_falcon02_reinf TRUE)
	(ai_allegiance human player)
	(ai_allegiance player human)		
	(sleep 1)
	(cs_run_command_script sq_v_falcon02_reinf/vehicle cs_reinforcement_falcon02_start)
	(sleep 30)
	(cs_queue_command_script sq_v_falcon02_reinf cs_marine_script)
)
(script static void f_falcon_reinf01_bldg_a
	;(print "FALCON REINFORCEMENT HOSPITAL")
	(set b_falcon_dispatched01 TRUE)
	(set b_falcon_evac_dialog true)
	(sleep 1)	
	(set b_falcon01a_nanny TRUE)		
	(ai_place sq_v_falcon01_reinf)
	(ai_force_active sq_v_falcon01_reinf TRUE)
	(ai_allegiance human player)
	(ai_allegiance player human)
	(sleep 1)
	(cs_run_command_script sq_v_falcon01_reinf/vehicle cs_reinforcement_falcon_a1)						
	(sleep 30)
	(cs_queue_command_script sq_v_falcon01_reinf cs_marine_script)
)
(script static void f_falcon_reinf02_bldg_a
	;(print "SECOND FALCON REINFORCEMENT HOSPITAL")								
	(set b_falcon_dispatched02 TRUE)
	(set b_falcon_evac_dialog true)
	(sleep 1)
	(set b_falcon02a_nanny TRUE)								
	(ai_place sq_v_falcon02_reinf)
	(ai_force_active sq_v_falcon02_reinf TRUE)
	(ai_allegiance human player)
	(ai_allegiance player human)	
	(sleep 1)								
	(cs_run_command_script sq_v_falcon02_reinf/vehicle cs_reinforcement_falcon_a2)						
	(sleep 30)
	(cs_queue_command_script sq_v_falcon02_reinf cs_marine_script)
)
(script static void f_falcon_reinf01_bldg_b
	;(print "FALCON REINFORCEMENT NIGHT CLUB")					
	(set b_falcon_dispatched01 TRUE)	
	(set b_falcon_evac_dialog true)
	(sleep 1)
	(set b_falcon01b_nanny TRUE)		
	(ai_place sq_v_falcon01_reinf)
	(ai_force_active sq_v_falcon01_reinf TRUE)
	(ai_allegiance human player)
	(ai_allegiance player human)		
	(sleep 1)						
	(cs_run_command_script sq_v_falcon01_reinf/vehicle cs_reinforcement_falcon_b1)
	(sleep 30)
	(cs_queue_command_script sq_v_falcon01_reinf cs_marine_script)
)
(script static void f_falcon_reinf02_bldg_b
	;(print "SECOND FALCON REINFORCEMENT NIGHT CLUB")								
	(set b_falcon_dispatched02 TRUE)	
	(set b_falcon_evac_dialog true)
	(sleep 1)
	(set b_falcon02b_nanny TRUE)																		
	(ai_place sq_v_falcon02_reinf)
	(ai_force_active sq_v_falcon02_reinf TRUE)
	(ai_allegiance human player)
	(ai_allegiance player human)		
	(sleep 1)
	(cs_run_command_script sq_v_falcon02_reinf/vehicle cs_reinforcement_falcon_b2)
	(sleep 30)
	(cs_queue_command_script sq_v_falcon02_reinf cs_marine_script)
)
(script static void f_falcon_reinf01_bldg_c
	;(print "FALCON REINFORCEMENT SINOVIET")						
	(set b_falcon_dispatched01 TRUE)
	(set b_falcon_evac_dialog true)
	(sleep 1)	
	(set b_falcon01c_nanny TRUE)													
	(ai_place sq_v_falcon01_reinf)
	(ai_force_active sq_v_falcon01_reinf TRUE)
	(ai_allegiance human player)
	(ai_allegiance player human)		
	(sleep 1)						
	(cs_run_command_script sq_v_falcon01_reinf/vehicle cs_reinforcement_falcon_c1)
	(sleep 30)
	(cs_queue_command_script sq_v_falcon01_reinf cs_marine_script)
)
(script static void f_falcon_reinf02_bldg_c
	;(print "SECOND FALCON REINFORCEMENT SINOVIET")								
	(set b_falcon_dispatched02 TRUE)	
	(set b_falcon_evac_dialog true)	
	(sleep 1)	
	(set b_falcon02c_nanny TRUE)																	
	(ai_place sq_v_falcon02_reinf)
	(ai_force_active sq_v_falcon02_reinf TRUE)
	(ai_allegiance human player)
	(ai_allegiance player human)		
	(sleep 1)
	(cs_run_command_script sq_v_falcon02_reinf/vehicle cs_reinforcement_falcon_c2)
	(sleep 30)
	(cs_queue_command_script sq_v_falcon02_reinf cs_marine_script)
)


(global short straggler_no 0)
; script erases all accompanying marines not in a falcon!
(script static void marine_clean
	(garbage_collect_unsafe)	
	(set straggler_no 0)
	(sleep_until
		(begin
			(if (not (unit_in_vehicle (unit (list_get (ai_actors gr_marines) straggler_no))))
				(ai_erase (object_get_ai (list_get (ai_actors gr_marines) straggler_no)))
				(set straggler_no (+ straggler_no 1))
			)
		(>= straggler_no (ai_living_count gr_marines)))
	5)
	(sleep 30)
	(if 
		(and
			(= b_falcon_dispatched01 false)
			(= (b_falcon_available01 sq_v_falcon01/vehicle sq_v_falcon01) false)
		)
		(begin
			;(print "erasing sq_v_falcon01")
			(ai_erase sq_v_falcon01)
		)
	)
	(if
		(and
			(= b_falcon_dispatched01 false)	
			(= (b_falcon_available01 sq_v_falcon01_reinf/vehicle sq_v_falcon01_reinf) false)
		)
		(begin
			;(print "erasing sq_v_falcon01_reinf")
			(ai_erase sq_v_falcon01_reinf)
		)
	)
	(if
		(and
			(= b_falcon_dispatched02 false)	
	 		(= (b_falcon_available02 sq_v_falcon02/vehicle sq_v_falcon02) false)
	 	)
		(begin
			;(print "erasing sq_v_falcon02")
			(ai_erase sq_v_falcon02)
		)
	)
	(if 
		(and
			(= b_falcon_dispatched02 false)	
			(= (b_falcon_available02 sq_v_falcon02_reinf/vehicle sq_v_falcon02_reinf) false)
		)
		(begin
			;(print "erasing sq_v_falcon02_reinf")
			(ai_erase sq_v_falcon02_reinf)
		)
	)	
	;(print "MARINES CLEANED")
	(sleep 30)		
)

(script command_script cs_reinforcement_falcon_a1
	(ai_cannot_die ai_current_squad TRUE)
	(ai_teleport ai_current_actor sd_final_falcon_a/p10)
	(cs_vehicle_speed_instantaneous 1)
	(sleep 1)
	(cs_ignore_obstacles TRUE)		
	(cs_fly_by sd_final_falcon_a/p8 2)
	(f_blip_ai ai_current_actor blip_ordnance)		
	(cs_fly_by sd_final_falcon_a/p6 1)
	(cs_vehicle_speed 0.7)
	(cs_fly_by sd_final_falcon_a/p15 1)
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face sd_final_falcon_a/p7 sd_final_falcon_a/p9 0.5)
	(ai_cannot_die ai_current_squad FALSE)
	(f_unblip_ai ai_current_actor)
	(sleep 30)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_d" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r2" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l2" true)	
	(ai_vehicle_exit sq_v_falcon01_reinf/vehicle)
	(set b_falcon_dispatched01 FALSE)	
	(sleep 30)		
)

(script dormant falcon_a1_nanny
	(sleep_until
		(begin
			(sleep_until (= b_falcon01a_nanny true)1)
			(set b_falcon01a_nanny false)				
			(sleep_until (= b_falcon_dispatched01 true)5)
			(sleep_until (= b_falcon_dispatched01 false)5 1600)
			(if (= b_falcon_dispatched01 true)
				(begin
					(ai_teleport sq_v_falcon01_reinf/vehicle sd_final_falcon_a/p7)
					(ai_cannot_die sq_v_falcon01_reinf/vehicle FALSE)
					(f_unblip_ai sq_v_falcon01_reinf/vehicle)		
					(set b_falcon_dispatched01 FALSE)
					(cs_run_command_script sq_v_falcon01_reinf/vehicle cs_marine_script)	
					(sleep 30)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_d" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r2" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l2" true)	
					(ai_vehicle_exit sq_v_falcon01_reinf/vehicle)
				)
			)
		false)
	)
)

(script command_script cs_reinforcement_falcon_b1
	(ai_cannot_die ai_current_squad TRUE)
	(ai_teleport ai_current_actor sd_final_falcon_b/p8)
	(cs_vehicle_speed_instantaneous 1)
	(sleep 1)
	(cs_ignore_obstacles TRUE)
	(f_blip_ai ai_current_actor blip_ordnance)	
	(cs_fly_by sd_final_falcon_b/p10 1)			
	(cs_fly_by sd_final_falcon_b/p6 1)
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face sd_final_falcon_b/p7 sd_final_falcon_b/p9 0.5)
	(ai_cannot_die ai_current_squad FALSE)
	(f_unblip_ai ai_current_actor)
	(sleep 30)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_d" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r2" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l2" true)	
	(ai_vehicle_exit sq_v_falcon01_reinf/vehicle)
	(set b_falcon_dispatched01 FALSE)	
	(sleep 30)		
)

(script dormant falcon_b1_nanny
	(sleep_until
		(begin
			(sleep_until (= b_falcon01b_nanny true)1)
			(set b_falcon01b_nanny false)		
			(sleep_until (= b_falcon_dispatched01 true)5)
			(sleep_until (= b_falcon_dispatched01 false)5 1600)
			(if (= b_falcon_dispatched01 true)
				(begin
					(ai_teleport sq_v_falcon01_reinf/vehicle sd_final_falcon_b/p7)
					(ai_cannot_die sq_v_falcon01_reinf/vehicle FALSE)
					(f_unblip_ai sq_v_falcon01_reinf/vehicle)		
					(set b_falcon_dispatched01 FALSE)
					(cs_run_command_script sq_v_falcon01_reinf/vehicle cs_marine_script)	
					(sleep 30)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_d" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r2" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l2" true)	
					(ai_vehicle_exit sq_v_falcon01_reinf/vehicle)
				)
			)
		false)
	)
)

(script command_script cs_reinforcement_falcon_c1
	(ai_cannot_die ai_current_squad TRUE)
	(ai_teleport ai_current_actor sd_final_falcon_c/p8)
	(cs_vehicle_speed_instantaneous 1)
	(sleep 1)
	(cs_ignore_obstacles TRUE)
	(f_blip_ai ai_current_actor blip_ordnance)		
	(cs_fly_by sd_final_falcon_c/p10 1)
	(cs_vehicle_speed 0.5)			
	(cs_fly_by sd_final_falcon_c/p6 1)
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face sd_final_falcon_c/p7 sd_final_falcon_c/p9 0.5)
	(ai_cannot_die ai_current_squad FALSE)
	(f_unblip_ai ai_current_actor)	
	(sleep 30)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_d" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r2" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l2" true)		
	(ai_vehicle_exit ai_current_actor)
	(set b_falcon_dispatched01 FALSE)
	(sleep 30)			
)

(script dormant falcon_c1_nanny
	(sleep_until
		(begin
			(sleep_until (= b_falcon01c_nanny true)1)
			(set b_falcon01c_nanny false)
			(sleep_until (= b_falcon_dispatched01 true)5)
			(sleep_until (= b_falcon_dispatched01 false)5 2400)
			(if (= b_falcon_dispatched01 true)
				(begin
					(ai_teleport sq_v_falcon01_reinf/vehicle sd_final_falcon_c/p7)
					(ai_cannot_die sq_v_falcon01_reinf/vehicle FALSE)
					(f_unblip_ai sq_v_falcon01_reinf/vehicle)		
					(set b_falcon_dispatched01 FALSE)
					(cs_run_command_script sq_v_falcon01_reinf/vehicle cs_marine_script)	
					(sleep 30)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_d" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r2" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l2" true)	
					(ai_vehicle_exit sq_v_falcon01_reinf/vehicle)
				)
			)
		false)
	)
)

(script command_script cs_reinforcement_falcon01_start
	(ai_cannot_die ai_current_squad TRUE)
	(cs_vehicle_speed_instantaneous 1)
	(cs_fly_by sd_start_falcon/p0 1)
	(f_blip_ai ai_current_actor blip_ordnance)			
	(sleep 1)
	(cs_ignore_obstacles TRUE)	
	(cs_fly_by sd_start_falcon/p1 2)
	(cs_vehicle_speed 0.7)	
	(cs_fly_by sd_start_falcon/p2 1)	
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face sd_start_falcon/p3 sd_start_falcon/p4 0.5)
	(ai_cannot_die ai_current_squad FALSE)
	(f_unblip_ai ai_current_actor)	
	(sleep 30)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_d" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r2" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l2" true)	
	(ai_vehicle_exit ai_current_actor)
	(set b_falcon_dispatched01 FALSE)	
	(sleep 30)		
)

(script dormant falcon_start1_nanny
	(sleep_until
		(begin
			(sleep_until (= b_falcon01_start_nanny true)1)
			(set b_falcon01_start_nanny false)		
			(sleep_until (= b_falcon_dispatched01 true)5)
			(sleep_until (= b_falcon_dispatched01 false)5 1600)
			(if (= b_falcon_dispatched01 true)
				(begin
					(ai_teleport sq_v_falcon01_reinf/vehicle sd_start_falcon/p13)
					(ai_cannot_die sq_v_falcon01_reinf/vehicle FALSE)
					(f_unblip_ai sq_v_falcon01_reinf/vehicle)		
					(set b_falcon_dispatched01 FALSE)
					(cs_run_command_script sq_v_falcon01_reinf/vehicle cs_marine_script)	
					(sleep 30)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_d" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_r2" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_p_l2" true)	
					(ai_vehicle_exit sq_v_falcon01_reinf/vehicle)
				)
			)
		false)
	)
)

(script command_script cs_reinforcement_falcon_a2
	(ai_cannot_die ai_current_squad TRUE)
	(ai_teleport ai_current_actor sd_final_falcon_a/p11)
	(cs_vehicle_speed_instantaneous 1)
	(sleep 1)
	(cs_ignore_obstacles TRUE)	
	(cs_fly_by sd_final_falcon_a/p12 2)	
	(f_blip_ai ai_current_actor blip_ordnance)		
	(cs_fly_by sd_final_falcon_a/p13 1)
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face sd_final_falcon_a/p14 sd_final_falcon_a/p16 0.5)
	(ai_cannot_die ai_current_squad FALSE)
	(f_unblip_ai ai_current_actor)		
	(sleep 30)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_d" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r2" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l2" true)	
	(ai_vehicle_exit sq_v_falcon02_reinf/vehicle)
	(set b_falcon_dispatched02 FALSE)
	(sleep 30)			
)

(script dormant falcon_a2_nanny
	(sleep_until
		(begin
			(sleep_until (= b_falcon02a_nanny true)1)
			(set b_falcon02a_nanny false)
			(sleep_until (= b_falcon_dispatched02 true)5)
			(sleep_until (= b_falcon_dispatched02 false)5 1600)
			(if (= b_falcon_dispatched02 true)
				(begin
					(ai_teleport sq_v_falcon02_reinf/vehicle sd_final_falcon_a/p14)
					(ai_cannot_die sq_v_falcon02_reinf/vehicle FALSE)
					(f_unblip_ai sq_v_falcon02_reinf/vehicle)		
					(set b_falcon_dispatched02 FALSE)
					(cs_run_command_script sq_v_falcon02_reinf/vehicle cs_marine_script)	
					(sleep 30)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_d" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r2" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l2" true)	
					(ai_vehicle_exit sq_v_falcon02_reinf/vehicle)
				)
			)
		false)
	)
)

(script command_script cs_reinforcement_falcon_b2
	(ai_cannot_die ai_current_squad TRUE)
	(ai_teleport ai_current_actor sd_final_falcon_b/p11)
	(cs_vehicle_speed_instantaneous 1)
	(sleep 1)
	(cs_ignore_obstacles TRUE)
	(f_blip_ai ai_current_actor blip_ordnance)		
	(cs_fly_by sd_final_falcon_b/p12 2)		
	(cs_fly_by sd_final_falcon_b/p3 1)
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face sd_final_falcon_b/p14 sd_final_falcon_b/p15 0.5)
	(ai_cannot_die ai_current_squad FALSE)
	(f_unblip_ai ai_current_actor)		
	(sleep 30)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_d" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r2" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l2" true)	
	(ai_vehicle_exit sq_v_falcon02_reinf/vehicle)
	(set b_falcon_dispatched02 FALSE)
	(sleep 30)			
)

(script dormant falcon_b2_nanny
	(sleep_until
		(begin
			(sleep_until (= b_falcon02b_nanny true)1)
			(set b_falcon02b_nanny false)		
			(sleep_until (= b_falcon_dispatched02 true)5)
			(sleep_until (= b_falcon_dispatched02 false)5 1600)
			(if (= b_falcon_dispatched02 true)
				(begin
					(ai_teleport sq_v_falcon02_reinf/vehicle sd_final_falcon_b/p14)
					(ai_cannot_die sq_v_falcon02_reinf/vehicle FALSE)
					(f_unblip_ai sq_v_falcon02_reinf/vehicle)		
					(set b_falcon_dispatched02 FALSE)
					(cs_run_command_script sq_v_falcon02_reinf/vehicle cs_marine_script)
					(sleep 30)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_d" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r2" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l2" true)	
					(ai_vehicle_exit sq_v_falcon02_reinf/vehicle)
				)
			)
		false)
	)
)

(script command_script cs_reinforcement_falcon_c2
	(ai_cannot_die ai_current_squad TRUE)
	(ai_teleport ai_current_actor sd_final_falcon_c/p11)
	(cs_vehicle_speed_instantaneous 1)
	(sleep 1)
	(cs_ignore_obstacles TRUE)
	(f_blip_ai ai_current_actor blip_ordnance)	
	(cs_fly_by sd_final_falcon_c/p12 1)
	(cs_vehicle_speed 0.5)			
	(cs_fly_by sd_final_falcon_c/p13 1)
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face sd_final_falcon_c/p14 sd_final_falcon_c/p15 0.5)
	(ai_cannot_die ai_current_squad FALSE)
	(f_unblip_ai ai_current_actor)	
	(sleep 30)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_d" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r2" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l2" true)	
	(ai_vehicle_exit sq_v_falcon02_reinf/vehicle)
	(set b_falcon_dispatched02 FALSE)
	(sleep 30)					
)

(script dormant falcon_c2_nanny
	(sleep_until
		(begin
			(sleep_until (= b_falcon02c_nanny true)1)
			(set b_falcon02c_nanny false)			
			(sleep_until (= b_falcon_dispatched02 true)5)
			(sleep_until (= b_falcon_dispatched02 false)5 2400)
			(if (= b_falcon_dispatched02 true)
				(begin
					(ai_teleport sq_v_falcon02_reinf/vehicle sd_final_falcon_c/p14)
					(ai_cannot_die sq_v_falcon02_reinf/vehicle FALSE)
					(f_unblip_ai sq_v_falcon02_reinf/vehicle)		
					(set b_falcon_dispatched02 FALSE)
					(cs_run_command_script sq_v_falcon02_reinf/vehicle cs_marine_script)
					(sleep 30)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_d" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r2" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l2" true)	
					(ai_vehicle_exit sq_v_falcon02_reinf/vehicle)
				)
			)
		false)
	)
)

(script command_script cs_reinforcement_falcon02_start
	(ai_cannot_die ai_current_squad TRUE)
	(cs_vehicle_speed_instantaneous 1)
	(sleep 1)	
	(cs_fly_to sd_start_falcon/p10 1)	
	(f_blip_ai ai_current_actor blip_ordnance)	
	(cs_ignore_obstacles TRUE)
	(cs_fly_by sd_start_falcon/p11 2)
	(cs_vehicle_speed 0.7)	
	(cs_fly_by sd_start_falcon/p12 1)	
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face sd_start_falcon/p13 sd_start_falcon/p14 0.5)
	(ai_cannot_die ai_current_squad FALSE)	
	(f_unblip_ai ai_current_actor)
	(sleep 30)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_d" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r2" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l2" true)	
	(ai_vehicle_exit sq_v_falcon02_reinf/vehicle)
	(set b_falcon_dispatched02 FALSE)
	(sleep 30)		
)

(script dormant falcon_start2_nanny
	(sleep_until
		(begin
			(sleep_until (= b_falcon02_start_nanny true)1)
			(set b_falcon02_start_nanny false)	
			(sleep_until (= b_falcon_dispatched02 true)5)
			(sleep_until (= b_falcon_dispatched02 false)5 1600)
			(if (= b_falcon_dispatched02 true)
				(begin
					(ai_teleport sq_v_falcon02_reinf/vehicle sd_start_falcon/p3)
					(ai_cannot_die sq_v_falcon02_reinf/vehicle FALSE)
					(f_unblip_ai sq_v_falcon02_reinf/vehicle)		
					(set b_falcon_dispatched02 FALSE)
					(cs_run_command_script sq_v_falcon02_reinf/vehicle cs_marine_script)
					(sleep 30)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_d" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l1" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_r2" true)
					(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_p_l2" true)	
					(ai_vehicle_exit sq_v_falcon02_reinf/vehicle)
				)
			)
		false)
	)
)

(script static void (f_player_teleport (player actor) (cutscene_flag flag_name) (boolean fade))
	(if (= fade true)
		(begin
			(sleep 60)
			(fade_out_for_player actor)
			(sleep 30)
		)
	)	
	(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" actor)
	(object_teleport actor flag_name)
	(if (= fade true)
		(begin	
			(sleep 30)
			(fade_in_for_player actor)
		)
	)
)

(script static boolean (f_action_test_evac (player actor))
	(if
		(and 
			(> (object_get_health actor) 0) 
			(unit_action_test_dpad_down actor)
			(not 
				(and 
					(unit_action_test_dpad_down actor)
					(unit_action_test_back actor)
				)
			)
			(not 
				(and 
					(unit_action_test_dpad_down actor)
					(unit_action_test_start actor)
				)
			)		
		)
		true
	)
)

; f_player_teleport player0 ins_start_player_00
(script dormant player0_evac_nanny
	(wake player0_evac_reminder)
	(wake f_player0_flying)
	(sleep_until
		(begin
			(unit_action_test_reset player0)	
			(sleep_until (= (f_action_test_evac player0) true)1)
				(if 
					(and
						(b_player_lost player0)
						(= b_falcon_dispatched01 FALSE)
						(= b_falcon_dispatched02 FALSE)
					)
					(begin
						(chud_clear_hs_variable player0 2)
						(chud_set_static_hs_variable player0 3 1)
						(cond
							((or 
									(and
										(not (volume_test_object tv_loc_building_a player0))
										(or
											(volume_test_object tv_loc_building_a player1)
											(volume_test_object tv_loc_building_a player2)
											(volume_test_object tv_loc_building_a player3)
										)
									)
									(= (f_bsp_any_player 2)	true)
								)
							(f_player_teleport player0 ins_building_a_player_00 true)								
							)
							((or 
									(and
										(not (volume_test_object tv_loc_building_b player0))
										(or
											(volume_test_object tv_loc_building_b player1)
											(volume_test_object tv_loc_building_b player2)
											(volume_test_object tv_loc_building_b player3)
										)
									)
									(= (f_bsp_any_player 3)	true)
								)
							(f_player_teleport player0 ins_building_b_player_00 true)
							)
							((or 
									(and
										(not (volume_test_object tv_loc_building_c player0))
										(or
											(volume_test_object tv_loc_building_c player1)
											(volume_test_object tv_loc_building_c player2)
											(volume_test_object tv_loc_building_c player3)
										)
									)
									(= (f_bsp_any_player 4)	true)
								)
							(f_player_teleport player0 ins_building_c_player_00 true)
							)											
							((and
									(not (volume_test_players tv_loc_building_a))
									(not (volume_test_players tv_loc_building_b))
									(not (volume_test_players tv_loc_building_c))
									(not (volume_test_object tv_loc_building_start player0))											
									(= (f_bsp_any_player 2)	false)
									(= (f_bsp_any_player 3)	false)
									(= (f_bsp_any_player 4)	false)
								)
								(f_player_teleport player0 ins_start_player_00 true)
							)
						)							
					)
				)
		(f_falcon_nanny)
		(chud_clear_hs_variable player0 3)
		(sleep 90)
	false)
	1)
)
(script dormant player1_evac_nanny
	(wake player1_evac_reminder)
	(wake f_player1_flying)
	(sleep_until
		(begin
			(unit_action_test_reset player1)	
			(sleep_until (= (f_action_test_evac player1) true)1)
				(if 
					(and
						(b_player_lost player1)
						(= b_falcon_dispatched01 FALSE)
						(= b_falcon_dispatched02 FALSE)
					)
					(begin
						(chud_clear_hs_variable player1 2)
						(chud_set_static_hs_variable player1 3 1)
					(cond
						((or 
								(and
									(not (volume_test_object tv_loc_building_a player1))
										(or
											(volume_test_object tv_loc_building_a player0)
											(volume_test_object tv_loc_building_a player2)
											(volume_test_object tv_loc_building_a player3)
										)
								)
								(= (f_bsp_any_player 2)	true)
							)
							(f_player_teleport player1 ins_building_a_player_01 true)
						)
						((or 
								(and
									(not (volume_test_object tv_loc_building_b player1))
										(or
											(volume_test_object tv_loc_building_b player0)
											(volume_test_object tv_loc_building_b player2)
											(volume_test_object tv_loc_building_b player3)
										)
								)
								(= (f_bsp_any_player 3)	true)
							)
							(f_player_teleport player1 ins_building_b_player_01 true)
						)
						((or 
								(and
									(not (volume_test_object tv_loc_building_c player1))
										(or
											(volume_test_object tv_loc_building_c player0)
											(volume_test_object tv_loc_building_c player2)
											(volume_test_object tv_loc_building_c player3)
										)
								)
								(= (f_bsp_any_player 4)	true)
							)
							(f_player_teleport player1 ins_building_c_player_01 true)
						)											
						((and
								(not (volume_test_players tv_loc_building_a))
								(not (volume_test_players tv_loc_building_b))
								(not (volume_test_players tv_loc_building_c))
								(not (volume_test_object tv_loc_building_start player1))								
								(= (f_bsp_any_player 2)	false)
								(= (f_bsp_any_player 3)	false)
								(= (f_bsp_any_player 4)	false)
							)
							(f_player_teleport player1 ins_start_player_01 true)							
						)
					)										
				)
			)
	(f_falcon_nanny)
	(chud_clear_hs_variable player1 3)
	(sleep 90)				
	false)
	1)
)
(script dormant player2_evac_nanny
	(wake player2_evac_reminder)
	(wake f_player2_flying)
	(sleep_until
		(begin
			(unit_action_test_reset player2)
			(sleep_until (= (f_action_test_evac player2) true)1)
				(if 
					(and
						(b_player_lost player2)
						(= b_falcon_dispatched01 FALSE)
						(= b_falcon_dispatched02 FALSE)
					)
					(begin
						(chud_clear_hs_variable player2 2)
						(chud_set_static_hs_variable player2 3 1)
					(cond
						((or 
								(and
									(not (volume_test_object tv_loc_building_a player2))
									(or
											(volume_test_object tv_loc_building_a player0)
											(volume_test_object tv_loc_building_a player1)
											(volume_test_object tv_loc_building_a player3)
									)
								)
								(= (f_bsp_any_player 2)	true)
							)
							(f_player_teleport player2 ins_building_a_player_02 true)
						)
						((or 
								(and
									(not (volume_test_object tv_loc_building_b player2))
									(or
											(volume_test_object tv_loc_building_b player0)
											(volume_test_object tv_loc_building_b player1)
											(volume_test_object tv_loc_building_b player3)
									)
								)
								(= (f_bsp_any_player 3)	true)
							)
							(f_player_teleport player2 ins_building_b_player_02 true)
						)
						((or 
								(and
									(not (volume_test_object tv_loc_building_c player2))
									(or
											(volume_test_object tv_loc_building_c player0)
											(volume_test_object tv_loc_building_c player1)
											(volume_test_object tv_loc_building_c player3)
									)
								)
								(= (f_bsp_any_player 4)	true)
							)
							(f_player_teleport player2 ins_building_c_player_02 true)
						)											
						((and
								(not (volume_test_players tv_loc_building_a))
								(not (volume_test_players tv_loc_building_b))
								(not (volume_test_players tv_loc_building_c))
								(not (volume_test_object tv_loc_building_start player2))										
								(= (f_bsp_any_player 2)	false)
								(= (f_bsp_any_player 3)	false)
								(= (f_bsp_any_player 4)	false)
							)
							(f_player_teleport player2 ins_start_player_02 true)
						)
					)							
				)
			)
		(f_falcon_nanny)
		(chud_clear_hs_variable player2 3)
		(sleep 90)					
	false)
	)
)
(script dormant player3_evac_nanny
	(wake player3_evac_reminder)
	(wake f_player3_flying)
	(sleep_until
		(begin
			(unit_action_test_reset player3)	
			(sleep_until (= (f_action_test_evac player3) true)1)
				(if 
					(and
						(b_player_lost player3)
						(= b_falcon_dispatched01 FALSE)
						(= b_falcon_dispatched02 FALSE)
					)
					(begin
						(chud_clear_hs_variable player3 2)
						(chud_set_static_hs_variable player3 3 1)
					(cond
						((or 
								(and
									(not (volume_test_object tv_loc_building_a player3))
									(or
											(volume_test_object tv_loc_building_a player0)
											(volume_test_object tv_loc_building_a player1)
											(volume_test_object tv_loc_building_a player2)
									)
								)
								(= (f_bsp_any_player 2)	true)
							)
							(f_player_teleport player3 ins_building_a_player_03 true)
						)
						((or 
								(and
									(not (volume_test_object tv_loc_building_b player3))
									(or
											(volume_test_object tv_loc_building_b player0)
											(volume_test_object tv_loc_building_b player1)
											(volume_test_object tv_loc_building_b player2)
									)
								)
								(= (f_bsp_any_player 3)	true)
							)
						(f_player_teleport player3 ins_building_b_player_03 true)
						)
						((or 
								(and
									(not (volume_test_object tv_loc_building_c player3))
									(or
											(volume_test_object tv_loc_building_c player0)
											(volume_test_object tv_loc_building_c player1)
											(volume_test_object tv_loc_building_c player2)
									)
								)
								(= (f_bsp_any_player 4)	true)
							)
						(f_player_teleport player3 ins_building_c_player_03 true)
						)											
						((and
								(not (volume_test_players tv_loc_building_a))
								(not (volume_test_players tv_loc_building_b))
								(not (volume_test_players tv_loc_building_c))
								(not (volume_test_object tv_loc_building_start player3))										
								(= (f_bsp_any_player 2)	false)
								(= (f_bsp_any_player 3)	false)
								(= (f_bsp_any_player 4)	false)
							)
						(f_player_teleport player3 ins_start_player_03 true)							
						)
					)									
				)
			)
	(f_falcon_nanny)
	(chud_clear_hs_variable player3 3)
	(sleep 90)					
	false)
	)
)
(script dormant player0_evac_reminder
	(sleep_until
		(begin
			(sleep 90) 
			(if
				(and
					(> (object_get_health player0) 0)
					(b_player_lost player0)
					(= b_falcon_dispatched01 FALSE)
					(= b_falcon_dispatched02 FALSE)
				)
				(begin
					(f_sleep_player0 5)
				(if 				
						(and
							(> (object_get_health player0) 0)
							(b_player_lost player0)
							(= b_falcon_dispatched01 FALSE)
							(= b_falcon_dispatched02 FALSE)
						)
						(begin			
							(unit_action_test_reset player0)
							(chud_set_static_hs_variable player0 2 1)
						)
					)
				)
				(chud_clear_hs_variable player0 2)
			)
		false)
	)
)
(script dormant player1_evac_reminder
	(sleep_until
		(begin
			(sleep 90)
			(if 				
				(and
					(> (object_get_health player1) 0)
					(b_player_lost player1)
					(= b_falcon_dispatched01 FALSE)
					(= b_falcon_dispatched02 FALSE)
				)
				(begin
					(f_sleep_player1 5)
				(if 				
						(and
							(> (object_get_health player1) 0)
							(b_player_lost player1)
							(= b_falcon_dispatched01 FALSE)
							(= b_falcon_dispatched02 FALSE)
						)
						(begin			
							(unit_action_test_reset player1)
							(chud_set_static_hs_variable player1 2 1)
						)
					)
				)
				(chud_clear_hs_variable player1 2)
			)
		false)
	)
)
(script dormant player2_evac_reminder
	(sleep_until
		(begin
			(sleep 90)
			(if 				
				(and
					(> (object_get_health player2) 0)
					(b_player_lost player2)
					(= b_falcon_dispatched01 FALSE)
					(= b_falcon_dispatched02 FALSE)
				)
				(begin
					(f_sleep_player2 5)
					(if 				
						(and
							(> (object_get_health player2) 0)
							(b_player_lost player2)
							(= b_falcon_dispatched01 FALSE)
							(= b_falcon_dispatched02 FALSE)
						)
						(begin			
							(unit_action_test_reset player2)
							(chud_set_static_hs_variable player2 2 1)
						)
					)
				)
				(chud_clear_hs_variable player2 2)
			)
		false)
	)
)
(script dormant player3_evac_reminder
	(sleep_until
		(begin
			(sleep 90)
			(if 				
				(and
					(> (object_get_health player3) 0)
					(b_player_lost player3)
					(= b_falcon_dispatched01 FALSE)
					(= b_falcon_dispatched02 FALSE)
				)
				(begin
					(f_sleep_player3 5)
					(if 				
						(and
							(> (object_get_health player3) 0)
							(b_player_lost player3)
							(= b_falcon_dispatched01 FALSE)
							(= b_falcon_dispatched02 FALSE)
						)
						(begin			
							(unit_action_test_reset player3)
							(chud_set_static_hs_variable player3 2 1)
						)
					)
				)
				(chud_clear_hs_variable player3 2)
			)
		false)
	)
)

(script static boolean g_all_lost
	(if
		(and
			(= (b_player_lost player0) true)
			(= (b_player_lost player1) true)
			(= (b_player_lost player2) true)
			(= (b_player_lost player3) true)
		)
	true)
)

(global short g_count0 0)
(global short g_count1 0)
(global short g_count2 0)
(global short g_count3 0)


(script static void (f_sleep_player0 (short l_timer))
	;(print "TIMER START!")
	(set g_count0 0)	
	(sleep_until
		(begin
			(if 				
				(and 
					(> (object_get_health player0) 0)
					(b_player_lost player0)
					(= b_falcon_dispatched01 FALSE)
					(= b_falcon_dispatched02 FALSE)					
				)
				(begin
					;(print "INCREMENTING SLEEP_PLAYER0")
					(set g_count0 (+ g_count0 1))
				)
				(begin
					;(print "RESETTING_0")
					(set g_count0 -1)
				)
			)
	(or
		(>= g_count0 l_timer)
		(= g_count0 -1)
	))
	30)
	;(print "TIMER DONE!")
)
(script static void (f_sleep_player1 (short l_timer))
	;(print "TIMER START!")
	(set g_count1 0)	
	(sleep_until
		(begin
			(if 				
				(and 
					(> (object_get_health player1) 0)
					(b_player_lost player1)
					(= b_falcon_dispatched01 FALSE)
					(= b_falcon_dispatched02 FALSE)						
				)
				(begin
					;(print "INCREMENTING SLEEP_PLAYER1")
					(set g_count1 (+ g_count1 1))
				)
				(begin
					;(print "RESETTING_1")
					(set g_count1 -1)
				)
			)
	(or
		(>= g_count1 l_timer)
		(= g_count1 -1)
	))
	30)
	;(print "TIMER DONE!")
)
(script static void (f_sleep_player2 (short l_timer))
	;(print "TIMER START!")
	(set g_count2 0)	
	(sleep_until
		(begin
			(if 				
				(and 
					(> (object_get_health player2) 0)
					(b_player_lost player2)
					(= b_falcon_dispatched01 FALSE)
					(= b_falcon_dispatched02 FALSE)										
				)
				(begin
					;(print "INCREMENTING SLEEP_PLAYER2")
					(set g_count2 (+ g_count2 1))
				)
				(begin
					;(print "RESETTING_2")
					(set g_count2 -1)
				)
			)
	(or
		(>= g_count2 l_timer)
		(= g_count2 -1)
	))
	30)
	;(print "TIMER DONE!")
)
(script static void (f_sleep_player3 (short l_timer))
	;(print "TIMER START!")
	(set g_count3 0)	
	(sleep_until
		(begin
			(if 				
				(and 
					(> (object_get_health player3) 0)
					(b_player_lost player3)
					(= b_falcon_dispatched01 FALSE)
					(= b_falcon_dispatched02 FALSE)										
				)
				(begin
					;(print "INCREMENTING SLEEP_PLAYER3")
					(set g_count3 (+ g_count3 1))
				)
				(begin
					;(print "RESETTING_3")
					(set g_count3 -1)
				)
			)
	(or
		(>= g_count3 l_timer)
		(= g_count3 -1)
	))
	30)
	;(print "TIMER DONE!")
)

(script static boolean (b_player_lost (player actor))
	(if 
		(and 
			(= (unit_in_vehicle_type actor g_banshee_type) FALSE)							
			(= (unit_in_vehicle_type actor g_falcon_type) FALSE)
			(!= (object_get_bsp actor) 2)					
			(!= (object_get_bsp actor) 3)								
			(!= (object_get_bsp actor) 4)		
			(not (b_player_on_building_with_vehicle actor tv_falcon_building_a tv_falcon_building_a2 tv_falcon_building_a2))	
			(not (b_player_on_building_with_vehicle actor tv_falcon_building_b tv_falcon_building_b tv_falcon_building_b))
			(not (b_player_on_building_with_vehicle actor tv_falcon_building_c1 tv_falcon_building_c2 tv_falcon_building_c3))
			(not (b_player_on_building_with_vehicle actor tv_loc_building_start tv_loc_building_start tv_loc_building_start))	
		)																																	
TRUE)
)

(script static boolean (b_player_on_building_with_vehicle (player actor) (trigger_volume tv1) (trigger_volume tv2) (trigger_volume tv3))
	(or
		(and
			(or
				(volume_test_object tv1 actor)
				(volume_test_object tv2 actor)
				(volume_test_object tv3 actor)
			)
			(or
				(f_falcon_in_volume tv1)
				(f_falcon_in_volume tv2)
				(f_falcon_in_volume tv3)
			)

		)
		(and
			(or
				(volume_test_object tv1 actor)
				(volume_test_object tv2 actor)
				(volume_test_object tv3 actor)
			)
			(or
				(f_banshee_in_volume tv1)
				(f_banshee_in_volume tv2)
				(f_banshee_in_volume tv3)
			)		
		)
	)
)


;(volume_test_object tv_loc_building_a player0)
; (b_player_on_building_with_vehicle player0 tv_falcon_building_a)
; (> (list_count (volume_return_objects_by_campaign_type tv_loc_building_a 20))0)
(script static void f_player0_pilotless
	(if
		(and
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player0) 0) "falcon_d" player0))
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player0) 0) "falcon_d" player1))
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player0) 0) "falcon_d" player2))								
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player0) 0) "falcon_d" player3))
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player0) 0) "" player0)
		)										
		(if 
			(and
				(not (volume_test_object tv_loc_building_a player0))
				(not (volume_test_object tv_loc_building_b player0))
				(not (volume_test_object tv_loc_building_c player0))
				(not (volume_test_object tv_loc_building_start player0))			
			)
			(f_player_teleport player0 ins_start_player_00 false)
		)
	)
)

(script static void f_player1_pilotless
	(if
		(and
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player1) 0) "falcon_d" player0))
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player1) 0) "falcon_d" player1))
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player1) 0) "falcon_d" player2))								
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player1) 0) "falcon_d" player3))
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player1) 0) "" player1)
		)									
		(if
			(and
				(not (volume_test_object tv_loc_building_a player1))
				(not (volume_test_object tv_loc_building_b player1))
				(not (volume_test_object tv_loc_building_c player1))
				(not (volume_test_object tv_loc_building_start player1))	
			)
			(f_player_teleport player1 ins_start_player_01 false)
		)
	)
)
(script static void f_player2_pilotless
	(if
		(and
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player2) 0) "falcon_d" player0))
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player2) 0) "falcon_d" player1))
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player2) 0) "falcon_d" player2))								
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player2) 0) "falcon_d" player3))
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player2) 0) "" player2)
		)								
		(if
			(and
				(not (volume_test_object tv_loc_building_a player2))
				(not (volume_test_object tv_loc_building_b player2))
				(not (volume_test_object tv_loc_building_c player2))
				(not (volume_test_object tv_loc_building_start player2))	
			)
			(f_player_teleport player2 ins_start_player_02 false)
		)		
	)
)


(script static void f_player3_pilotless
	(if
		(and
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player3) 0) "falcon_d" player0))
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player3) 0) "falcon_d" player1))
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player3) 0) "falcon_d" player2))								
			(not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player3) 0) "falcon_d" player3))
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad player3) 0) "" player3)
		)								
		(if
			(and
				(not (volume_test_object tv_loc_building_a player3))
				(not (volume_test_object tv_loc_building_b player3))
				(not (volume_test_object tv_loc_building_c player3))
				(not (volume_test_object tv_loc_building_start player3))				
			)
			(f_player_teleport player3 ins_start_player_03 false)
		)
	)
)
(script dormant f_player0_flying
	(sleep_until (= (player_is_in_game player0) true) 1)
	;(print "PLAYER0 IN THE GAME")
	(sleep_until (= (player_is_in_game player0) false) 1)
	;(print "Player0 LEFT THE GAME")
	(f_player1_pilotless)
	(f_player2_pilotless)
	(f_player3_pilotless)
)
(script dormant f_player1_flying
	(sleep_until (= (player_is_in_game player1) true) 1)
	;(print "PLAYER1 IN THE GAME")
	(sleep_until (= (player_is_in_game player1) false) 1)
	;(print "Player1 LEFT THE GAME")
	(f_player0_pilotless)
	(f_player2_pilotless)
	(f_player3_pilotless)
)
(script dormant f_player2_flying
	(sleep_until (= (player_is_in_game player2) true) 1)
	;(print "PLAYER2 IN THE GAME")
	(sleep_until (= (player_is_in_game player2) false) 1)
	;(print "Player2 LEFT THE GAME")
	(f_player0_pilotless)
	(f_player1_pilotless)
	(f_player3_pilotless)
)
(script dormant f_player3_flying
	(sleep_until (= (player_is_in_game player3) true) 1)
	;(print "PLAYER3 IN THE GAME")
	(sleep_until (= (player_is_in_game player3) false) 1)
	;(print "Player3 LEFT THE GAME")
	(f_player1_pilotless)
	(f_player2_pilotless)
	(f_player0_pilotless)
)
; (falcon_gunner_reserve true)
(script static void (falcon_gunner_reserve (boolean reserve))
	(if 
		(and 
			(= b_falcon_dispatched01 false)
			(= b_falcon_dispatched02 false)
			(= reserve true)
		)
		(begin
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_g_l" true)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_g_r" true)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_g_l" true)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_g_r" true)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "falcon_g_l" true)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "falcon_g_r" true)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_g_l" true)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_g_r" true)			
		)
		(begin
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_g_l" false)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_g_r" false)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_g_l" false)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "falcon_g_r" false)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "falcon_g_l" false)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "falcon_g_r" false)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_g_l" false)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "falcon_g_r" false)			
		)
	)
)
;(> (list_count (volume_return_objects_by_campaign_type tv_loc_building_start 20))0)
(script command_script cs_marine_script
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_dialogue TRUE)
	(ai_prefer_target_ai gr_marines gr_banshee true)
	(sleep_until
		(begin
			(if
				(and
					(or 
						(volume_test_objects tv_loc_building_start (ai_actors ai_current_actor))
						(volume_test_objects tv_loc_building_a (ai_actors ai_current_actor))
						(volume_test_objects tv_loc_building_b (ai_actors ai_current_actor))
						(volume_test_objects tv_loc_building_c (ai_actors ai_current_actor))
					)
						(not (= (ai_carrying_player ai_current_actor) TRUE))
				)
					(begin
						;;(print "HIDE MARINES01")
						(ai_disregard (ai_get_object ai_current_actor) TRUE)
						(cs_enable_targeting FALSE)
					)
					(begin
						;;(print "UNHIDE MARINES01")
						(ai_disregard (ai_get_object ai_current_actor) FALSE)
						(cs_enable_targeting TRUE)
					)				
			)	
		FALSE)
	30)		
)


(script static void (f_load_troopers_sec (ai driver)(ai driver_squad) (short delay) (ai troopers))
	(if (> (ai_living_count troopers) 0)
		(begin
			(falcon_gunner_reserve true)
			(ai_set_blind troopers true)
			(ai_set_deaf troopers true)
			(sleep 120)
			(unit_open (ai_vehicle_get driver))
			(vehicle_hover (ai_vehicle_get_from_spawn_point driver) TRUE)	
			(sleep 90)
			(ai_vehicle_enter troopers (ai_vehicle_get_from_spawn_point driver) "pelican_p")
			(sleep_until (= (f_all_squad_in_vehicle troopers driver_squad) true)5 delay)
			(falcon_gunner_reserve false)
			;(sleep delay)
			(vehicle_hover (ai_vehicle_get_from_spawn_point driver) FALSE)
			(unit_close (ai_vehicle_get driver))	
		)
	)
)

(script command_script cs_stay_in_turret
	(cs_shoot true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_abort_on_damage FALSE)	
	(cs_abort_on_alert FALSE)
)

(script static boolean f_player0_in_banshee
	(if
		(= (unit_in_vehicle_type player0 g_banshee_type) TRUE)													
	true)
)
(script static boolean f_player1_in_banshee
	(if
		(= (unit_in_vehicle_type player1 g_banshee_type) TRUE)													
	true)
)
(script static boolean f_player2_in_banshee
	(if
		(= (unit_in_vehicle_type player2 g_banshee_type) TRUE)													
	true)
)
(script static boolean f_player3_in_banshee
	(if
		(= (unit_in_vehicle_type player3 g_banshee_type) TRUE)													
	true)
)

(script static boolean (f_players_driving_falcon (ai falcon))
	(if
		(or
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad falcon 0) "falcon_d" player0)
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad falcon 0) "falcon_d" player1)
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad falcon 0) "falcon_d" player2)
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad falcon 0) "falcon_d" player3)			
		)
	true)
)
(script static boolean (f_players_in_falcon (ai falcon))
	(if
		(or
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad falcon 0) "" player0)
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad falcon 0) "" player1)
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad falcon 0) "" player2)
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad falcon 0) "" player3)			
		)
	true)
)

;f_players_driving_falcon sq_v_falcon01
;(vehicle_test_seat_unit sq_v_falcon01 "falcon_d" player0)
;======================================================================
;=====================LEVEL ZONESET SCRIPTS==========================
;======================================================================

(script continuous zone_loader
	(if 
		(and (!= prev_zone 1) (= (current_zone_set) 1))
		(begin
			(set prev_zone 1)
			;(print "zone_loader enabling zone_set m52_010_a volume")
			(zone_set_trigger_volume_enable zone_set:m52_010_a TRUE)
			(zone_set_trigger_volume_enable zone_set:m52_020_b FALSE)
			(zone_set_trigger_volume_enable zone_set:m52_030_c FALSE)		
		)
	)
	(if 		
		(and (!= prev_zone 2) (= (current_zone_set) 2))
		(begin
			(set prev_zone 2)
			;(print "zone_loader enabling zone_set m52_020_b volume")			
			(zone_set_trigger_volume_enable zone_set:m52_020_b TRUE)
			(zone_set_trigger_volume_enable zone_set:m52_010_a FALSE)
			(zone_set_trigger_volume_enable zone_set:m52_030_c FALSE)							
		)
	)	
	(if 		
		(and (!= prev_zone 3) (= (current_zone_set) 3))
		(begin
			(set prev_zone 3)
			;(print "zone_loader enabling zone_set m52_030_c volume")				
			(zone_set_trigger_volume_enable zone_set:m52_030_c TRUE)
			(zone_set_trigger_volume_enable zone_set:m52_010_a FALSE)
			(zone_set_trigger_volume_enable zone_set:m52_020_b FALSE)							
		)
	)					
	(if 		
		(and (!= prev_zone 4) (= (current_zone_set) 4))
		(begin
			(set prev_zone 4)
			;(print "zone_loader enabling zone_set m52_040_oni volume")				
			(zone_set_trigger_volume_enable zone_set:m52_040_oni TRUE)
			(zone_set_trigger_volume_enable zone_set:m52_010_a FALSE)
			(zone_set_trigger_volume_enable zone_set:m52_020_b FALSE)
			(zone_set_trigger_volume_enable zone_set:m52_030_c FALSE)									
		)
	)
	(if 		
		(and (!= prev_zone 5) (= (current_zone_set) 5))
		(begin
			(set prev_zone 5)
			;(print "zone_loader enabling zone_set m52_secondary volume")				
			(zone_set_trigger_volume_enable zone_set:m52_040_oni FALSE)
			(zone_set_trigger_volume_enable zone_set:m52_010_a FALSE)
			(zone_set_trigger_volume_enable zone_set:m52_020_b FALSE)
			(zone_set_trigger_volume_enable zone_set:m52_030_c FALSE)									
		)
	)	
)
;======================================================================
;========================MISCELLANEOUS SCRIPTS==========================
;======================================================================
(script command_script cs_kill_script
	(sleep 1)
)

(script command_script boost_5seconds
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost TRUE)
	(sleep 150)
)

(script command_script boost_10seconds
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost TRUE)
	(sleep 300)
)
(script command_script boost_20seconds
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost TRUE)
	(sleep 600)
)
(script command_script boost_infinite
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost TRUE)
	(sleep_forever)
)

(script static void object_removal
	(cond
		((= g_prev_mission 1)
			(begin
				(device_set_position dm_bldg_a_door01 0)			
				(object_destroy_folder building_a_control)
				(object_destroy_folder building_a_equipment)
				(object_destroy_folder building_a_weapons)
				(object_destroy_folder building_a_crates)
				(object_destroy_folder building_a_scenery)
				(object_destroy_folder bldg_a_interior_bodies)
				(ai_erase sq_bldg_a_trooper_01)
				(ai_erase gr_bldg_a)					
			)
		)
		((= g_prev_mission 2)
			(begin			
				(device_set_position dm_bldg_b_door01 0)
				(device_set_position dm_bldg_b_door02 0) 
				(ai_erase gr_bldg_b_disco)
				(ai_erase gr_bldg_b)
				(object_destroy_folder bldg_b_interior_bodies)				 				
				(object_destroy_folder building_b_weapons)
				(object_destroy_folder building_b_equipment)
				(object_destroy_folder building_b_controls)
				(object_destroy_folder building_b_crates)
				(object_destroy_folder building_b_scenery)
				(object_destroy_folder building_b_dm)	
				(ai_erase sq_bldg_b_trooper_01)
				(ai_erase sq_bldg_b_trooper_02)
				(ai_erase sq_bldg_b_trooper_03)	
				(ai_erase sq_bldg_b_trooper_04)
												
			)
		)
		((= g_prev_mission 3)
			(begin				
				(device_set_power dm_bldg_c_door02a 0)	
				(device_set_power dm_bldg_c_door01a 0)
				(device_set_position dm_bldg_c_door02a 0)	
				(device_set_position dm_bldg_c_door01a 0)							
				(device_set_power dc_bldg_c_switch01a 0)
				(device_set_power dc_bldg_c_switch02a 0)
				(ai_erase gr_bldg_c)								
				(object_destroy_folder bldg_c_interior_bodies)
				(object_destroy_folder building_c_controls)
				(object_destroy_folder building_c_equipment)
				(object_destroy_folder building_c_weapons)
				(object_destroy_folder building_c_crates)
				(object_destroy_folder building_c_scenery)
				(object_destroy_folder building_c_vehicles)
			)
		)
		((= g_prev_mission 10)
			(begin
				(device_set_power dm_bldg_c_door01a 0)
				(device_set_position dm_bldg_c_door01a 0)
				(device_set_power dm_bldg_c_door02a 0)
				(device_set_position dm_bldg_c_door02a 0) 						
				(device_set_power dc_bldg_c_switch01a 0)
				(device_set_power dc_bldg_c_switch02a 0)				
				(object_destroy_folder bldg_c_interior_bodies)
				(object_destroy_folder building_c_controls)
				(object_destroy_folder building_c_equipment)
				(object_destroy_folder building_c_weapons)
				(object_destroy_folder building_c_crates)
				(object_destroy_folder building_c_scenery)
				(object_destroy_folder building_c_vehicles)
				(device_set_power dm_bldg_b_door01 0)
				(device_set_position dm_bldg_b_door01 0)
				(device_set_power dm_bldg_b_door02 0)
				(device_set_position dm_bldg_b_door02 0)
				(object_destroy_folder bldg_b_interior_bodies)	 				 				
				(object_destroy_folder building_b_weapons)
				(object_destroy_folder building_b_equipment)
				(object_destroy_folder building_b_controls)
				(object_destroy_folder building_b_crates)
				(object_destroy_folder building_b_scenery)
				(object_destroy_folder building_b_dm)
				(device_set_power dm_bldg_a_door01 0)
				(device_set_position dm_bldg_a_door01 0)			
				(object_destroy_folder building_a_control)
				(object_destroy_folder building_a_equipment)
				(object_destroy_folder building_a_weapons)
				(object_destroy_folder building_a_crates)
				(object_destroy_folder building_a_scenery)
				(object_destroy_folder bldg_a_interior_bodies)							
			)
		)	
	)
)	

(script static boolean (f_falcon_in_volume (trigger_volume tv))
	(if
		(or
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle))
			)			
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle))
			)
		)
	true)	
)

(script static boolean (f_banshee_in_volume (trigger_volume tv))
	(if
		(or
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee01/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee01/pilot01))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee01/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee01/pilot02))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee02/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee02/pilot01))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee02/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee02/pilot02))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee03/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee03/pilot01))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee03/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee03/pilot02))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee04/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee04/pilot01))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee04/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee04/pilot02))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee05/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee05/pilot01))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee05/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee05/pilot02))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee06/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee06/pilot01))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee06/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee06/pilot02))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee07/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee07/pilot01))
			)			
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee07/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee07/pilot02))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee08/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee08/pilot01))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee08/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee08/pilot02))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee09/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee09/pilot01))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee09/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_banshee09/pilot02))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot01))
			)			
				(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot02))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot03)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot03))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot01))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot02))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot03)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot03))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot01))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot02))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot03)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot03))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot01))
			)			
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot02))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot03)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot03))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot01))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot02))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot03)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot03))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot01))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot02))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot03)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot03))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot01))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot02))
			)				
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot03)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot03))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot01))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot02))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot03)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot03))
			)	
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot01))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot02))
			)				
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot01))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot02))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_falcon_banshees00/pilot01)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_falcon_banshees00/pilot01))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_falcon_banshees00/pilot02)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_falcon_banshees00/pilot02))
			)
			(and 
				(> (object_get_health (ai_vehicle_get_from_spawn_point sq_empty_banshee01/pilot)) 0)
				(volume_test_object tv (ai_vehicle_get_from_spawn_point sq_empty_banshee01/pilot))
			)
		)
	true)	
)

(script continuous banshee_cleanup
	(sleep 600)
	(banshee_vehicle_cleanup sq_banshee01/pilot01)
	(banshee_vehicle_cleanup sq_banshee01/pilot02)
	(banshee_vehicle_cleanup sq_banshee02/pilot01)
	(banshee_vehicle_cleanup sq_banshee02/pilot02)
	(banshee_vehicle_cleanup sq_banshee03/pilot01)
	(banshee_vehicle_cleanup sq_banshee03/pilot02)
	
	(banshee_vehicle_cleanup sq_banshee04/pilot01)
	(banshee_vehicle_cleanup sq_banshee04/pilot02)
	(banshee_vehicle_cleanup sq_banshee05/pilot01)
	(banshee_vehicle_cleanup sq_banshee05/pilot02)
	(banshee_vehicle_cleanup sq_banshee06/pilot01)
	(banshee_vehicle_cleanup sq_banshee06/pilot02)
	
	(banshee_vehicle_cleanup sq_banshee07/pilot01)
	(banshee_vehicle_cleanup sq_banshee07/pilot02)
	(banshee_vehicle_cleanup sq_banshee08/pilot01)
	(banshee_vehicle_cleanup sq_banshee08/pilot02)
	(banshee_vehicle_cleanup sq_banshee09/pilot01)
	(banshee_vehicle_cleanup sq_banshee09/pilot02)
	
	(banshee_vehicle_cleanup sq_oni_banshee_01/pilot01)
	(banshee_vehicle_cleanup sq_oni_banshee_01/pilot02)
	(banshee_vehicle_cleanup sq_oni_banshee_01/pilot03)	
	(banshee_vehicle_cleanup sq_oni_banshee_02/pilot01)
	(banshee_vehicle_cleanup sq_oni_banshee_02/pilot02)
	(banshee_vehicle_cleanup sq_oni_banshee_02/pilot03)
	(banshee_vehicle_cleanup sq_oni_banshee_03/pilot01)
	(banshee_vehicle_cleanup sq_oni_banshee_03/pilot02)
	(banshee_vehicle_cleanup sq_oni_banshee_03/pilot03)	
	
	(banshee_vehicle_cleanup sq_oni_banshee_04/pilot01)
	(banshee_vehicle_cleanup sq_oni_banshee_04/pilot02)
	(banshee_vehicle_cleanup sq_oni_banshee_04/pilot03)
	(banshee_vehicle_cleanup sq_oni_banshee_05/pilot01)
	(banshee_vehicle_cleanup sq_oni_banshee_05/pilot02)
	(banshee_vehicle_cleanup sq_oni_banshee_05/pilot03)	
	(banshee_vehicle_cleanup sq_oni_banshee_06/pilot01)
	(banshee_vehicle_cleanup sq_oni_banshee_06/pilot02)
	(banshee_vehicle_cleanup sq_oni_banshee_06/pilot03)
	
	(banshee_vehicle_cleanup sq_sec_beta_b03a/pilot01)
	(banshee_vehicle_cleanup sq_sec_beta_b03a/pilot02)
	(banshee_vehicle_cleanup sq_sec_beta_b03a/pilot03)
	
	(banshee_vehicle_cleanup sq_sec_gamma_b02/pilot01)
	(banshee_vehicle_cleanup sq_sec_gamma_b02/pilot02)
	(banshee_vehicle_cleanup sq_sec_gamma_b02/pilot03)
	
	(banshee_vehicle_cleanup sq_sec_gamma_b03a/pilot01) 
	(banshee_vehicle_cleanup sq_sec_gamma_b03a/pilot02)
	
	(banshee_vehicle_cleanup sq_sec_gamma_b03b/pilot01)
	(banshee_vehicle_cleanup sq_sec_gamma_b03b/pilot02)
	
	(banshee_vehicle_cleanup sq_falcon_banshees00/pilot01)
	(banshee_vehicle_cleanup sq_falcon_banshees00/pilot02)
)

(script dormant vehicle_reserve00
	(sleep_until
		(begin
			(sleep_until (= (unit_in_vehicle (player0)) true)5)
			(cond
			
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle)))			
			
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee01/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee01/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee01/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee01/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee02/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee02/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee02/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee02/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee03/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee03/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee03/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee03/pilot02)))
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee04/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee04/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee04/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee04/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee05/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee05/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee05/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee05/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee06/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee06/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee06/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee06/pilot02)))
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee07/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee07/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee07/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee07/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee08/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee08/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee08/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee08/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee09/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee09/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee09/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_banshee09/pilot02)))
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot03) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot03) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot03) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot03)))		
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot03) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot03) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot03) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot03)))									
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot03) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot03)))										
			
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot03) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot03)))
		
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot02)))
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot01) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot02) "" player0)(set reserve_vehicle00 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot02)))
			)
		FALSE)
	)
)
(script dormant vehicle_reserve01
	(sleep_until
		(begin
			(sleep_until (= (unit_in_vehicle (player1)) true)5)
			(cond
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle)))	
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle)))
			
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee01/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee01/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee01/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee01/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee02/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee02/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee02/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee02/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee03/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee03/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee03/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee03/pilot02)))
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee04/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee04/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee04/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee04/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee05/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee05/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee05/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee05/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee06/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee06/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee06/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee06/pilot02)))
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee07/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee07/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee07/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee07/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee08/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee08/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee08/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee08/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee09/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee09/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee09/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_banshee09/pilot02)))
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot03) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot03) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot03) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot03)))		
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot03) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot03) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot01) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot02) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot03) "" player1)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot03)))									
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot01) "" player0)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot02) "" player0)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot03) "" player0)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot03)))										
			
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot01) "" player0)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot02) "" player0)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot03) "" player0)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot03)))
		
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot01) "" player0)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot02) "" player0)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot02)))
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot01) "" player0)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot02) "" player0)(set reserve_vehicle01 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot02)))
		)
	false)
	)
)
(script dormant vehicle_reserve02
	(sleep_until
		(begin
			(sleep_until (= (unit_in_vehicle (player2)) true)5)
			(cond
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle)))			
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee01/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee01/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee01/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee01/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee02/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee02/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee02/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee02/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee03/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee03/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee03/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee03/pilot02)))
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee04/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee04/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee04/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee04/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee05/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee05/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee05/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee05/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee06/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee06/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee06/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee06/pilot02)))
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee07/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee07/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee07/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee07/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee08/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee08/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee08/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee08/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee09/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee09/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee09/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_banshee09/pilot02)))
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot03) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot03) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot03) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot03)))		
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot03) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot03) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot01) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot02) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot03) "" player2)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot03)))									
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot01) "" player0)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot02) "" player0)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot03) "" player0)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot03)))										
			
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot01) "" player0)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot02) "" player0)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot03) "" player0)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot03)))
		
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot01) "" player0)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot02) "" player0)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot02)))
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot01) "" player0)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot02) "" player0)(set reserve_vehicle02 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot02)))
			)
	false)
	)
)
(script dormant vehicle_reserve03
	(sleep_until
		(begin
			(sleep_until (= (unit_in_vehicle (player3)) true)5)
			(cond
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle)))	
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_v_falcon01_reinf/vehicle)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_v_falcon02_reinf/vehicle)))	
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee01/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee01/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee01/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee01/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee02/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee02/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee02/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee02/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee03/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee03/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee03/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee03/pilot02)))
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee04/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee04/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee04/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee04/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee05/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee05/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee05/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee05/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee06/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee06/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee06/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee06/pilot02)))
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee07/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee07/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee07/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee07/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee08/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee08/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee08/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee08/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee09/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee09/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_banshee09/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_banshee09/pilot02)))
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot03) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_01/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot03) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_02/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot03) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_03/pilot03)))		
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot03) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_04/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot03) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_05/pilot03)))		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot01) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot02) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot03) "" player3)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_oni_banshee_06/pilot03)))									
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot01) "" player0)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot02) "" player0)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot03) "" player0)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_sec_beta_b03a/pilot03)))										
			
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot01) "" player0)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot02) "" player0)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot02)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot03) "" player0)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b02/pilot03)))
		
				
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot01) "" player0)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot02) "" player0)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03a/pilot02)))
		
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot01) "" player0)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot01)))
				((vehicle_test_seat_unit (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot02) "" player0)(set reserve_vehicle03 (ai_vehicle_get_from_spawn_point sq_sec_gamma_b03b/pilot02)))
			)
		false)
	)
)

(script static void (banshee_vehicle_cleanup (ai l_banshee))
	(if
		(or (volume_test_object tv_garbage_floor (ai_vehicle_get_from_spawn_point l_banshee))
			(and
				;(> (object_get_health (ai_vehicle_get_from_spawn_point sq_banshee01/pilot01)) 0)
				(not (vehicle_test_seat (ai_vehicle_get_from_spawn_point l_banshee) ""))
				(not (= reserve_vehicle00 (ai_vehicle_get_from_spawn_point l_banshee)))
				(not (= reserve_vehicle01 (ai_vehicle_get_from_spawn_point l_banshee)))
				(not (= reserve_vehicle02 (ai_vehicle_get_from_spawn_point l_banshee)))
				(not (= reserve_vehicle03 (ai_vehicle_get_from_spawn_point l_banshee)))							
			)
		)
		(begin
			(if 
				(volume_test_object tv_garbage_floor (ai_vehicle_get_from_spawn_point l_banshee))
				(print "DESTROYING banshee by volume")
				(print "DESTROYING banshee by clean-up- RARE")
			)
			(object_destroy (ai_vehicle_get_from_spawn_point l_banshee))
		)
	)
)
;(vehicle_test_seat (ai_vehicle_get_from_spawn_point sq_banshee01/pilot01) "")
;(vehicle_test_seat (ai_vehicle_get_from_spawn_point ) 
(script continuous floor_garbage
	(add_recycling_volume tv_garbage_floor 0 0)
	(sleep 1)
	(add_recycling_volume tv_garbage_start 1 0)
	(sleep 1)
	(cond
		((= (current_zone_set) 1)
			(begin
				;(print "CLEANING LADY!!! BLDGA")
				(add_recycling_volume_by_type tv_garbage_bldg_a1 15 5 12)
				(sleep 150)
				(add_recycling_volume_by_type tv_garbage_bldg_a2 15 5 12)
				(sleep 150)
				(add_recycling_volume tv_garbage_bldg_b 0 0)
				(sleep 1)
				(add_recycling_volume tv_garbage_bldg_c 0 1)
				(sleep 1)		
			)
		)
		((= (current_zone_set) 2)
			(begin
				;(print "CLEANING LADY!!! BLDGB")
				(add_recycling_volume tv_garbage_bldg_a1 0 1)
				(sleep 1)
				(add_recycling_volume tv_garbage_bldg_a2 0 1)
				(sleep 1)
				(add_recycling_volume_by_type tv_garbage_bldg_b 30 10 12)
				(sleep 300)
				(add_recycling_volume tv_garbage_bldg_c 0 1)
				(sleep 1)				
			)
		)
		((= (current_zone_set) 3)
			(begin
				;(print "CLEANING LADY!!! BLDGC")
				(add_recycling_volume tv_garbage_bldg_a1 0 1)
				(sleep 1)
				(add_recycling_volume tv_garbage_bldg_a2 0 1)
				(sleep 1)
				(add_recycling_volume tv_garbage_bldg_b 0 1)
				(sleep 1)
				(add_recycling_volume_by_type tv_garbage_bldg_c 30 10 12)
				(sleep 300)			
			)
		)
		(
			(or
				(= (current_zone_set) 4)
				(> (current_zone_set) 5)
			)
			(begin
				;(print "CLEANING LADY!!! END")
				(add_recycling_volume tv_garbage_bldg_a1 0 1)
				(sleep 1)
				(add_recycling_volume tv_garbage_bldg_a2 0 1)
				(sleep 1)
				(add_recycling_volume tv_garbage_bldg_b 0 1)
				(sleep 1)				
				(add_recycling_volume tv_garbage_bldg_c 0 1)
				(sleep 1)
				(add_recycling_volume tv_garbage_alpha_1 0 1)
				(sleep 1)				
				(add_recycling_volume tv_garbage_alpha_2 0 1)
				(sleep 1)				
				(add_recycling_volume tv_garbage_alpha_3 0 1)
				(sleep 1)	
				(add_recycling_volume tv_garbage_beta_1 0 1)
				(sleep 1)				
				(add_recycling_volume tv_garbage_beta_2 0 1)
				(sleep 1)				
				(add_recycling_volume tv_garbage_beta_3 0 1)
				(sleep 1)
				(add_recycling_volume tv_garbage_gamma_1 0 1)
				(sleep 1)				
				(add_recycling_volume tv_garbage_gamma_2 0 1)
				(sleep 1)				
				(add_recycling_volume tv_garbage_gamma_3 0 1)
				(sleep 1)
				(add_recycling_volume tv_garbage_delta_1 0 1)
				(sleep 1)				
				(add_recycling_volume tv_garbage_delta_2 0 1)
				(sleep 1)				
				(add_recycling_volume tv_garbage_delta_3 0 1)				
			)
		)		
	)
	(cond 
		((= m_alpha_complete true)
			(begin
				(ai_erase gr_alpha)
				(add_recycling_volume tv_garbage_alpha_1 0 1)
				(sleep 1)		
				(add_recycling_volume tv_garbage_alpha_2 0 1)
				(sleep 1)	
				(add_recycling_volume tv_garbage_alpha_3 0 1)
			)
		)
		((= m_beta_complete true)
			(begin	
				(ai_erase gr_beta)
				(add_recycling_volume tv_garbage_beta_1 0 1)
				(sleep 1)	
				(add_recycling_volume tv_garbage_beta_2 0 1)
				(sleep 1)		
				(add_recycling_volume tv_garbage_beta_3 0 1)
			)
		)
		((= m_gamma_complete true)
			(begin						
				(ai_erase gr_gamma)
				(add_recycling_volume tv_garbage_gamma_1 0 1)
				(sleep 1)		
				(add_recycling_volume tv_garbage_gamma_2 0 1)
				(sleep 1)	
				(add_recycling_volume tv_garbage_gamma_3 0 1)
			)
		)
		((= m_delta_complete true)
			(begin
				(ai_erase gr_delta)
				(add_recycling_volume tv_garbage_delta_1 0 1)
				(sleep 1)	
				(add_recycling_volume tv_garbage_delta_2 0 1)
				(sleep 1)	
				(add_recycling_volume tv_garbage_delta_3 0 1)
			)
		)
	)		
	(sleep 30)

)

(script static void f_zone_teleport_player0
	(cond
		(
			(and 
				(= (current_zone_set) 1)
				(= (object_get_bsp player0) 2)
			)
			(f_player_teleport player0 cf_bldg_a_player_00 false)
		)
		(
			(and 
				(= (current_zone_set) 2)
				(= (object_get_bsp player0) 3)
			)
			(f_player_teleport player0 cf_bldg_b_player_00 false)
		)
		(
			(and 
				(= (current_zone_set) 3)
				(= (object_get_bsp player0) 4)
			)
			(f_player_teleport player0 cf_bldg_c_player_00 false)	
		)
	)
)

(script static void f_zone_teleport_player1
	(cond
		(
			(and 
				(= (current_zone_set) 1)
				(= (object_get_bsp player1) 2)
			)
			(f_player_teleport player1 cf_bldg_a_player_01 false)			
		)
		(
			(and 
				(= (current_zone_set) 2)
				(= (object_get_bsp player1) 3)
			)
			(f_player_teleport player1 cf_bldg_b_player_01 false)				
		)
		(
			(and 
				(= (current_zone_set) 3)
				(= (object_get_bsp player1) 4)
			)
			(f_player_teleport player1 cf_bldg_c_player_01 false)
		)
	)
)
(script static void f_zone_teleport_player2
	(cond
		(
			(and 
				(= (current_zone_set) 1)
				(= (object_get_bsp player2) 2)
			)
			(f_player_teleport player2 cf_bldg_a_player_02 false)		
		)
		(
			(and 
				(= (current_zone_set) 2)
				(= (object_get_bsp player2) 3)
			)
			(f_player_teleport player2 cf_bldg_b_player_02 false)	
		)
		(
			(and 
				(= (current_zone_set) 3)
				(= (object_get_bsp player2) 4)
			)
			(f_player_teleport player2 cf_bldg_c_player_02 false)	
		)
	)
)
(script static void f_zone_teleport_player3
	(cond
		(
			(and 
				(= (current_zone_set) 1)
				(= (object_get_bsp player3) 2)
			)
			(f_player_teleport player3 cf_bldg_a_player_03 false)	
		)
		(
			(and 
				(= (current_zone_set) 2)
				(= (object_get_bsp player3) 3)
			)
			(f_player_teleport player3 cf_bldg_b_player_03 false)	
		)
		(
			(and 
				(= (current_zone_set) 3)
				(= (object_get_bsp player3) 4)
			)
			(f_player_teleport player3 cf_bldg_c_player_03 false)	
		)
	)
)
; default spawning properties for AI/Falcons

(script static void f_player_loadout
	
	(cond
		((= (game_coop_player_count) 1)
			(begin
				(ai_place sq_solo_troopers)				
				(sleep 1)
				(ai_place sq_v_falcon01/vehicle)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_d" true)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_r1" true)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_l1" true)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_r2" true)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_l2" true)					
				(ai_vehicle_enter sq_solo_troopers/01 (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_g")
				(ai_vehicle_enter sq_solo_troopers/02 (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_g")							
			)
		)
		((or
				(= (game_coop_player_count) 2)
				(= g_coop_simulation 2)
			) 
			(begin
				(ai_place sq_coop_troopers_2)
				(ai_place sq_v_falcon01/vehicle)
				(ai_place sq_v_falcon02/vehicle)
				(ai_place sq_v_falcon02/gunner)
				(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_v_falcon02/vehicle) "falcon_g_l" (ai_get_object sq_v_falcon02/gunner))			
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_d" true)				
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_r1" true)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_l1" true)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_r2" true)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_l2" true)	
				(sleep 1)						
				(ai_vehicle_enter sq_coop_troopers_2/01 (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_g")
				(ai_vehicle_enter sq_coop_troopers_2/02 (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_g")													
			)
		)
		((or
				(= (game_coop_player_count) 3)
				(= g_coop_simulation 3)
			) 
			(begin
				(ai_place sq_coop_troopers_1)
				(ai_place sq_v_falcon01/vehicle)
				(ai_place sq_v_falcon02/vehicle)
				(ai_place sq_v_falcon02/gunner)
				(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_v_falcon02/vehicle) "falcon_g_l" (ai_get_object sq_v_falcon02/gunner))
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_d" true)		
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_r1" true)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_l1" true)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_r2" true)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_l2" true)				
				(sleep 1)		
				(ai_vehicle_enter sq_coop_troopers_1/01 (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_g")																				
			)
		)
		((or
				(= (game_coop_player_count) 4)
				(= g_coop_simulation 4)
			) 
			(begin
				;(ai_place sq_coop_troopers_1)	
				(ai_place sq_v_falcon01/vehicle)
				(ai_place sq_v_falcon02/vehicle)
				(ai_place sq_v_falcon02/gunner)
				(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_v_falcon02/vehicle) "falcon_g_l" (ai_get_object sq_v_falcon02/gunner))
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_d" true)		
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_r1" true)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_l1" true)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_r2" true)
				(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_p_l2" true)
				(sleep 1)										
				;(ai_vehicle_enter sq_coop_troopers_1/01 (ai_vehicle_get_from_spawn_point sq_v_falcon01/vehicle) "falcon_g")	
				;(sleep 90)						
				;(ai_vehicle_enter sq_coop_troopers_2/02 (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "falcon_g")		
																
			)
		)
	)
)

(script command_script cs_second_falcon_intro
	(ai_cannot_die ai_current_squad TRUE)
	(cs_vehicle_speed_instantaneous 1)
	(sleep 1)
	(cs_ignore_obstacles TRUE)			
	(cs_fly_by sd_start_falcon/p5 3)
	(cs_vehicle_speed 0.7)		
	(cs_fly_by sd_start_falcon/p6 2)
	(cs_vehicle_speed 0.3)
	(cs_fly_to_and_face sd_start_falcon/p13 sd_start_falcon/p14 0.5)
	(ai_cannot_die ai_current_squad FALSE)
	(f_unblip_ai ai_current_actor)	
	(set b_falcon_dispatched02 FALSE)	
	(sleep 30)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "falcon_d" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "falcon_p_r1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "falcon_p_l1" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "falcon_p_r2" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_spawn_point sq_v_falcon02/vehicle) "falcon_p_l2" true)	
	(ai_vehicle_exit sq_v_falcon02/vehicle)
	(cs_queue_command_script sq_v_falcon02/vehicle cs_marine_script)	
	(cs_queue_command_script sq_v_falcon02/gunner cs_marine_script)
)

(script static void branch_abort
	(sleep 1)
)

;checks to see if the player is in the appropriate BSP and the appropriate trigger volume
(script static boolean (f_bsp_and_volume_check (short bsp_num) (trigger_volume vol_name))
	(if
		(or
			(and
				(volume_test_object vol_name player0) (= (object_get_bsp player0) bsp_num)
			)
			(and
				(volume_test_object vol_name player1) (= (object_get_bsp player1) bsp_num)
			)
			(and
				(volume_test_object vol_name player2) (= (object_get_bsp player2) bsp_num)
			)
			(and
				(volume_test_object vol_name player3) (= (object_get_bsp player3) bsp_num)
			)
		)
	TRUE)								
)
;checks to see if the player is in the appropriate BSP and ai radius
(script static boolean (f_bsp_and_ai_radius_check (short bsp_num) (ai sq_name) (real ai_distance))
	(if
		(or
			(and
				(>= (objects_distance_to_object player0 (ai_get_object sq_name)) ai_distance) (= (object_get_bsp player0) bsp_num)
			)
			(and
				(>= (objects_distance_to_object player1 (ai_get_object sq_name)) ai_distance) (= (object_get_bsp player1) bsp_num)
			)
			(and
				(>= (objects_distance_to_object player2 (ai_get_object sq_name)) ai_distance) (= (object_get_bsp player2) bsp_num)
			)
			(and
				(>= (objects_distance_to_object player3 (ai_get_object sq_name)) ai_distance) (= (object_get_bsp player3) bsp_num)
			)
		)
	TRUE)								
)
;checks to see if the player is in the hub and outside of an ai radius
(script static boolean (f_hub_and_ai_radius_check (ai sq_name) (real ai_distance))
	(if
		(and
			(and
				(> (objects_distance_to_object player0 (ai_get_object sq_name)) ai_distance) 
				(or
					(< (object_get_bsp player0) 2)
					(> (object_get_bsp player0) 4)
				)
			)
			(and
				(> (objects_distance_to_object player1 (ai_get_object sq_name)) ai_distance)
				(or
					(< (object_get_bsp player1) 2)
					(> (object_get_bsp player1) 4)
				)
			)
			(and
				(> (objects_distance_to_object player2 (ai_get_object sq_name)) ai_distance)
				(or
					(< (object_get_bsp player2) 2)
					(> (object_get_bsp player2) 4)
				)				
			)
			(and
				(> (objects_distance_to_object player3 (ai_get_object sq_name)) ai_distance)
				(or
					(< (object_get_bsp player3) 2)
					(> (object_get_bsp player3) 4)
				)
			)
		)
	TRUE)								
)

; checks to see if anyone is in the hub and if that player is within a cutscene flag radius
(script static boolean (f_hub_and_radius_check (cutscene_flag flag_name) (short rad_num))
	(if
		(or
			(and
				(or
					(< (object_get_bsp player0) 2)
					(> (object_get_bsp player0) 4)
				)
				(= (player_is_in_game player0) true)	
				(<= (objects_distance_to_flag player0 flag_name) rad_num)
			)
			(and
				(or
					(< (object_get_bsp player1) 2)
					(> (object_get_bsp player1) 4)
				)
				(= (player_is_in_game player1) true)			
				(<= (objects_distance_to_flag player1 flag_name) rad_num)
			)
			(and
				(or
					(< (object_get_bsp player2) 2)
					(> (object_get_bsp player2) 4)
				)
				(= (player_is_in_game player2) true)					
				(<= (objects_distance_to_flag player2 flag_name) rad_num)
			)
			(and
				(or
					(< (object_get_bsp player3) 2)
					(> (object_get_bsp player3) 4)
				)
				(= (player_is_in_game player3) true)						
				(<= (objects_distance_to_flag player3 flag_name) rad_num)
			)
		)
	TRUE)								
)

(script static boolean (f_hub_and_radius_greater (cutscene_flag flag_name) (short rad_num))
	(if
		(or
			(and
				(or
					(< (object_get_bsp player0) 2)
					(> (object_get_bsp player0) 4)
				)
				(= (player_is_in_game player0) true)	
				(> (objects_distance_to_flag player0 flag_name) rad_num)
			)
			(and
				(or
					(< (object_get_bsp player1) 2)
					(> (object_get_bsp player1) 4)
				)
				(= (player_is_in_game player1) true)					
				(> (objects_distance_to_flag player1 flag_name) rad_num)
			)
			(and
				(or
					(< (object_get_bsp player2) 2)
					(> (object_get_bsp player2) 4)
				)
				(= (player_is_in_game player2) true)					
				(> (objects_distance_to_flag player2 flag_name) rad_num)
			)
			(and
				(or
					(< (object_get_bsp player3) 2)
					(> (object_get_bsp player3) 4)
				)
				(= (player_is_in_game player3) true)						
				(> (objects_distance_to_flag player3 flag_name) rad_num)
			)
		)
	TRUE)								
)

;checks to see if a specific player is in the hub
(script static boolean (f_player_hub_check (player actor))
	(if
		(or
			(< (object_get_bsp actor) 2)
			(> (object_get_bsp actor) 4)
		)
	TRUE)
)

; checks to see if anyone is in the hub
(script static boolean f_any_hub_check
	(if
		(or
			(and
				(= (player_is_in_game player0) true)						
				(or
					(< (object_get_bsp player0) 2)
					(> (object_get_bsp player0) 4)
				)
			)
			(and
				(= (player_is_in_game player1) true)					
				(or
					(< (object_get_bsp player1) 2)
					(> (object_get_bsp player1) 4)
				)
			)
			(and
				(= (player_is_in_game player2) true)				
				(or
					(< (object_get_bsp player2) 2)
					(> (object_get_bsp player2) 4)
				)
			)
			(and
				(= (player_is_in_game player3) true)					
				(or
					(< (object_get_bsp player3) 2)
					(> (object_get_bsp player3) 4)
				)
			)
		)
	TRUE)
)
; checks to see if all is in the hub
(script static boolean f_all_hub_check
		(if 
			(and
				(or
					(< (object_get_bsp player0) 2)
					(> (object_get_bsp player0) 4)
				)
				(or
					(< (object_get_bsp player1) 2)
					(> (object_get_bsp player1) 4)
				)
				(or
					(< (object_get_bsp player2) 2)
					(> (object_get_bsp player2) 4)
				)			
				(or
					(< (object_get_bsp player3) 2)
					(> (object_get_bsp player3) 4)
				)					
			)
		TRUE)
)
; checks to see if anyone is in a specific BSP
(script static boolean (f_bsp_any_player (short bsp_num))
	(if
		(or
			(= (object_get_bsp player0) bsp_num)
			(= (object_get_bsp player1) bsp_num)
			(= (object_get_bsp player2) bsp_num)
			(= (object_get_bsp player3) bsp_num)
		)
	TRUE)
)

; checks to see if all are in a specific BSP
(script static boolean (f_bsp_all_player (short bsp_num))
	(if
		(and
			(or				
				(= (object_get_bsp player0) bsp_num)
				(= (object_get_bsp player0) -1)
			)
			(or				
				(= (object_get_bsp player1) bsp_num)
				(= (object_get_bsp player1) -1)
			)
			(or				
				(= (object_get_bsp player2) bsp_num)
				(= (object_get_bsp player2) -1)
			)
			(or				
				(= (object_get_bsp player3) bsp_num)
				(= (object_get_bsp player3) -1)
			)
		)
	TRUE)
)

;==============SPECIAL ELITE=====================;
(global short s_special_elite 0)
(global boolean b_special false)
(global boolean b_special_win false)

(script dormant special_elite
	(sleep_until
		(begin
			(sleep (* 30 60 (random_range 5 7)))
			(if 
				(and
					(< (ai_living_count sq_banshee_bob01) 1) 
					(= b_safe_for_ambient true)
					(= b_special false)
				)
				(begin
					(ai_place sq_banshee_bob01)
					(sleep_until (< (ai_living_count sq_banshee_bob01) 1)5)
					(if (= b_special_win true)
						(begin
							(set b_special true)
							;(print "SPECIAL WIN!")
							(submit_incident "kill_elite_bob")
						)
					)
				)
			)
		(= m_progression 0))
	5)
)

(script command_script cs_special_elite01
	(set b_special_win true)
	;(print "SPECIAL START")	
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost TRUE)
	(ai_teleport sq_banshee_bob01 sd_elite_bob/p0)
	(cs_fly_by sd_elite_bob/p1)
	(cs_fly_by sd_elite_bob/p2)
	(cs_fly_by sd_elite_bob/p3)	
	(set b_special_win false)
	;(print "SPECIAL FAIL")
	(sleep 1)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script command_script cs_special_elite02
	(set b_special_win true)
	;(print "SPECIAL START")	
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost TRUE)
	(ai_teleport sq_banshee_bob01 sd_elite_bob/p4)
	(cs_fly_by sd_elite_bob/p5)
	(cs_fly_by sd_elite_bob/p6)
	(cs_fly_by sd_elite_bob/p7)	
	(set b_special_win false)
	;(print "SPECIAL FAIL")
	(sleep 1)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script command_script cs_special_elite03
	(set b_special_win true)
	;(print "SPECIAL START")	
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost TRUE)
	(ai_teleport sq_banshee_bob01 sd_elite_bob/p8)
	(cs_fly_by sd_elite_bob/p9)
	(cs_fly_by sd_elite_bob/p10)
	(cs_fly_by sd_elite_bob/p11)
	(cs_fly_by sd_elite_bob/p12)	
	(set b_special_win false)
	;(print "SPECIAL FAIL")
	(sleep 1)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)
(script command_script cs_special_elite04
	(set b_special_win true)
	;(print "SPECIAL START")	
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost TRUE)
	(ai_teleport sq_banshee_bob01 sd_elite_bob/p13)
	(cs_fly_by sd_elite_bob/p14)
	(cs_fly_by sd_elite_bob/p15)
	(cs_fly_by sd_elite_bob/p16)
	(cs_fly_by sd_elite_bob/p17)
	(set b_special_win false)
	;(print "SPECIAL FAIL")
	(sleep 1)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

;======================================================================
;========================LEVEL TURRET SCRIPTS==========================
;======================================================================
;*

(global boolean b_achievement_turrets_end false)
(global boolean b_main_turrets_dead false)
(script dormant aa_achievement
	(sleep_until (< (ai_living_count gr_turrets) 1)5)
	(if (= b_achievement_turrets_end false)(set b_main_turrets_dead true))
	(sleep_until (b_oni_end) 5)
	(if b_main_turrets_dead (submit_incident "m52_aa_kill"))
)

*;
;======================================================================
;==========================BOUNDARY SCRIPTS============================
;======================================================================

(global short player0_death 0)
(global short player1_death 0)
(global short player2_death 0)
(global short player3_death 0)

; this script determines if a player is a pilot of a falcon or a banshee
(script static boolean (f_vehicle_pilot_seat (player l_player))
	(if
		(or
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad l_player) 0) "falcon_d" l_player)
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad (ai_player_get_vehicle_squad l_player) 0) "banshee_d" l_player)				
		)
	true
	)
)

(script dormant low_flying_volume_player0
	(sleep_until
		(begin			
				(if (volume_test_object tv_low_warning player0)
					(begin
						(f_hud_training_clear player0)			
						(if (f_vehicle_pilot_seat player0)
							(f_hud_training player0 ct_too_low)								
							(effect_new_on_object_marker "objects\vehicles\covenant\turrets\shade\weapons\shade_anti_air_cannon\weapon\fx\shade_anti_air_cannon_explosion.effect" (object_get_parent player0) "")
						)
					)
				)		
		FALSE)
	15)
)
(script dormant low_flying_volume_player1
	(sleep_until
		(begin			
				(if (volume_test_object tv_low_warning player1)
					(begin
						(f_hud_training_clear player1)				
						(if (f_vehicle_pilot_seat player1)
							(f_hud_training player1 ct_too_low)			
							(effect_new_on_object_marker "objects\vehicles\covenant\turrets\shade\weapons\shade_anti_air_cannon\weapon\fx\shade_anti_air_cannon_explosion.effect" (object_get_parent player1) "")
						)
					)
				)		
		FALSE)
	15)
)
(script dormant low_flying_volume_player2
	(sleep_until
		(begin			
				(if (volume_test_object tv_low_warning player2)
					(begin
						(f_hud_training_clear player2)						
						(if (f_vehicle_pilot_seat player2)
							(f_hud_training player2 ct_too_low)	
							(effect_new_on_object_marker "objects\vehicles\covenant\turrets\shade\weapons\shade_anti_air_cannon\weapon\fx\shade_anti_air_cannon_explosion.effect" (object_get_parent player2) "")
						)
					)
				)		
		FALSE)
	15)
)
(script dormant low_flying_volume_player3
	(sleep_until
		(begin			
				(if (volume_test_object tv_low_warning player3)
					(begin
						(f_hud_training_clear player3)				
						(if (f_vehicle_pilot_seat player3)
							(f_hud_training_forever player3 ct_too_low)	
							(effect_new_on_object_marker "objects\vehicles\covenant\turrets\shade\weapons\shade_anti_air_cannon\weapon\fx\shade_anti_air_cannon_explosion.effect" (object_get_parent player3) "")
						)
					)
				)		
		FALSE)
	15)
)

;======================================================================
;========================MISC SCRIPTS==========================
;======================================================================

(global boolean has_flown_pelican FALSE)
(global boolean has_flown_phantom FALSE)

(script dormant aj_mode
	(object_create aj_switch)
	(sleep_until (>= (device_get_position aj_switch) 1))
	;(print "AJ MODE!")
	(sleep_forever level_checkpoint)
	(sleep_forever low_flying_volume_player0)
	(sleep_forever low_flying_volume_player1)
	(sleep_forever low_flying_volume_player2)
	(sleep_forever low_flying_volume_player3)
	(sleep_forever player0_evac_nanny)
	(sleep_forever player1_evac_nanny)	
	(sleep_forever player2_evac_nanny)	
	(sleep_forever player3_evac_nanny)
	(sleep_forever md_001_falcon_evac)							
	(soft_ceiling_enable default false)
	(wake player_phantom)
	(wake player_pelican)
	(wake aj_clean_0)
	(wake aj_clean_1)
	(wake aj_clean_2)
	(wake aj_clean_3)	
	(kill_volume_disable kill_soft_00)
	(kill_volume_disable kill_soft_01)	
	(kill_volume_disable kill_soft_02)	
	(kill_volume_disable kill_soft_03)
	(kill_volume_disable kill_soft_04)	
	(kill_volume_disable kill_soft_05)						
	(kill_volume_disable kill_soft_06)
	(wake aj_achievement_check)
)

(script dormant player_phantom
	(sleep_until
		(begin
			(sleep_until (volume_test_players tv_aj_pelican)5)
				(cond
					 ((and
					 		(volume_test_object tv_aj_pelican player0)
					 		(= (unit_in_vehicle_type player0 g_banshee_type) TRUE)
					 		(<= (object_get_health aj_phantom0)0)
					 	)
					 			(begin
									(object_create aj_phantom0)
									(unit_enter_vehicle_immediate player0 aj_phantom0 "phantom_d" )
									(object_hide (player0) TRUE)
									(set has_flown_phantom TRUE)
								)
						)
					 ((and
					 		(volume_test_object tv_aj_pelican player1)
					 		(= (unit_in_vehicle_type player1 g_banshee_type) TRUE)
					 		(<= (object_get_health aj_phantom1)0)
					 	)
					 			(begin
									(object_create aj_phantom1)
									(unit_enter_vehicle_immediate player1 aj_phantom1 "phantom_d" )
									(object_hide (player1) TRUE)
									(set has_flown_phantom TRUE)
								)
						)
					 ((and
					 		(volume_test_object tv_aj_pelican player2)
					 		(= (unit_in_vehicle_type player2 g_banshee_type) TRUE)
					 		(<= (object_get_health aj_phantom2)0)
					 	)
					 			(begin
									(object_create aj_phantom2)
									(unit_enter_vehicle_immediate player2 aj_phantom2 "phantom_d" )
									(object_hide (player2) TRUE)
									(set has_flown_phantom TRUE)
								)
						)
					 ((and
					 		(volume_test_object tv_aj_pelican player3)
					 		(= (unit_in_vehicle_type player3 g_banshee_type) TRUE)
					 		(<= (object_get_health aj_phantom3)0)
					 	)
					 			(begin
									(object_create aj_phantom3)
									(unit_enter_vehicle_immediate player3 aj_phantom3 "phantom_d" )
									(object_hide (player3) TRUE)
									(set has_flown_phantom TRUE)
								)
						)																						
				)
		false)
		30)
)
(script dormant player_pelican
	(sleep_until
		(begin
			(sleep_until (volume_test_players tv_aj_pelican)5)
				(cond
					 ((and
					 		(volume_test_object tv_aj_pelican player0)
					 		(= (unit_in_vehicle_type player0 g_falcon_type) TRUE)
					 		(<= (object_get_health aj_pelican0)0)
					 	)
					 			(begin
									(object_create aj_pelican0)
									(unit_enter_vehicle_immediate player0 aj_pelican0 "pelican_d" )
									(object_hide (player0) TRUE)
									(set has_flown_pelican TRUE)
								)
						)
					 ((and
					 		(volume_test_object tv_aj_pelican player1)
					 		(= (unit_in_vehicle_type player1 g_falcon_type) TRUE)
					 		(<= (object_get_health aj_pelican1)0)
					 	)
					 			(begin
									(object_create aj_pelican1)
									(unit_enter_vehicle_immediate player1 aj_pelican1 "pelican_d" )
									(object_hide (player1) TRUE)
									(set has_flown_pelican TRUE)
								)
						)
					 ((and
					 		(volume_test_object tv_aj_pelican player2)
					 		(= (unit_in_vehicle_type player2 g_falcon_type) TRUE)
					 		(<= (object_get_health aj_pelican2)0)
					 	)
					 			(begin
									(object_create aj_pelican2)
									(unit_enter_vehicle_immediate player2 aj_pelican2 "pelican_d" )
									(object_hide (player2) TRUE)
									(set has_flown_pelican TRUE)
								)
						)
					 ((and
					 		(volume_test_object tv_aj_pelican player3)
					 		(= (unit_in_vehicle_type player3 g_falcon_type) TRUE)
					 		(<= (object_get_health aj_pelican3)0)
					 	)
					 			(begin
									(object_create aj_pelican3)
									(unit_enter_vehicle_immediate player3 aj_pelican3 "pelican_d" )
									(object_hide (player3) TRUE)
									(set has_flown_pelican TRUE)
								)
						)																						
				)
		false)
		30)
)
(script dormant aj_clean_0
	(sleep_until
		(begin
			(sleep_until 
				(and
					(not (vehicle_test_seat_unit aj_pelican0 "" player0))
					(not (vehicle_test_seat_unit aj_phantom0 "" player0))
				))
				(object_destroy aj_pelican0)
				(object_destroy aj_phantom0)
				(object_hide (player0) false)
			false)
		)
)
(script dormant aj_clean_1
	(sleep_until
		(begin
			(sleep_until 
				(and
					(not (vehicle_test_seat_unit aj_pelican1 "" player1))
					(not (vehicle_test_seat_unit aj_phantom1 "" player1))
				))
				(object_destroy aj_pelican1)
				(object_destroy aj_phantom1)
				(object_hide (player1) false)
			false)
		)
)
(script dormant aj_clean_2
	(sleep_until
		(begin
			(sleep_until 
				(and
					(not (vehicle_test_seat_unit aj_pelican2 "" player2))
					(not (vehicle_test_seat_unit aj_phantom2 "" player2))
				))
				(object_destroy aj_pelican2)
				(object_destroy aj_phantom2)
				(object_hide (player2) false)
			false)
		)
)
(script dormant aj_clean_3
	(sleep_until
		(begin
			(sleep_until 
				(and
					(not (vehicle_test_seat_unit aj_pelican3 "" player3))
					(not (vehicle_test_seat_unit aj_phantom3 "" player3))
				))
				(object_destroy aj_pelican3)
				(object_destroy aj_phantom3)
				(object_hide (player3) false)
			false)
		)
)

(script dormant aj_achievement_check
	(sleep_until (and has_flown_pelican has_flown_phantom) 5)
			
	(submit_incident_with_cause_player "pelican_phantom_achieve" player0)
	(submit_incident_with_cause_player "pelican_phantom_achieve" player1)
	(submit_incident_with_cause_player "pelican_phantom_achieve" player2)
	(submit_incident_with_cause_player "pelican_phantom_achieve" player3)	

)


; ===============================================================================================================================================
; NEW INTEL MESSAGING ===========================================================================================================================
; ===============================================================================================================================================

;*
ct_objective_new			= ">>> NEW OBJECTIVE:"
ct_objective_end			= ">>> OBJECTIVE COMPLETE"
0		= "Destroy Covenant Jammer at the Hospital"
1		= "Destroy Covenant Jammer at the Tower"
2 	= "Destroy Covenant Jammer in Sinoviet Industries"
3		= "Fly to the Oni Building"
4		= "Help the Pelicans Evac by destroying all nearby Anti-Air"
5		= "Dock at the Oni Hangar"
6		= "Rescue marines from Brutes"
7		= "Rescue marines from Skirmishers"
8		= "Rescue marines from Hunters"
9		= "Protect the Marines and Kill the Jackal Snipers"
PRIMARY_OBJECTIVE_11	= "Help the Pelican and destroy the Anti-Air Turrets"
11	= "Take down the Banshees to assist the Marines"
12	= "Protect the ODST in a Falcon"
13	= "Help Buck rescue his squadmates"
14	= "Assist the ODST in rescuing some troopers"
15	= "Destroy a Jammer and eliminate the covenant"
16	= "Kill the elites and engineers"
17	= "Take out the covenant infantry and anti-air turrets"
ct_objective_bldg_a 			= "DESTROY COVENANT JAMMER AT THE HOSPITAL"
ct_objective_bldg_b			= "DESTROY COVENANT JAMMER AT THE TOWER"
ct_objective_bldg_c			= "DESTROY COVENANT JAMMER AT SINOVIET INDUSTRIES"
ct_objective_oni			= "GO TO ONI BUILDING"
ct_objective_oni_aa			= "DESTROY ALL ANTI-AIR TURRETS"
ct_objective_oni_end			= "LAND AT ONI"
ct_objective_alpha_1			= "DEFEND MARINES AGAINST BRUTES"
ct_objective_alpha_2 			= "DEFEND MARINES AGAINST JACKALS"
ct_objective_alpha_3 			= "DEFEND MARINES AGAINST HUNTERS"
ct_objective_beta_1 			= "KILL JACKAL SNIPERS"
ct_objective_beta_2			= "ASSIST THE PELICAN"
ct_objective_beta_3 			= "DESTROY THE BANSHEES"
ct_objective_gamma_1 			= "ESCORT THE FALCON"
ct_objective_gamma_2			= "ESCORT THE FALCON"
ct_objective_gamma_3 			= "ESCORT THE FALCON"
ct_objective_delta_1 			= "DESTROY THE JAMMER AND INFANTRY"
ct_objective_delta_2 			= "KILL ELITES AND ENGINEERS"
ct_objective_delta_3			= "DESTROY THE ANTI-AIR AND INFANTRY"
ct_emergency_evac			= "PREPARE FOR EMERGENCY EVAC"
ct_too_low				= "TOO LOW!! PULL UP!!!"
*;