;====================================================================================================================================================================================================
;================================== GLOBAL VARIABLES ================================================================================================================================================
;====================================================================================================================================================================================================
(global boolean editor FALSE)

(global boolean g_player_training TRUE)

(global boolean g_debug TRUE)
(global boolean dialogue TRUE)
;(global boolean music TRUE)
(global boolean g_mid_cinematic FALSE)

(global short intro_obj_control 0)
(global short motorpool_obj_control 0)
(global short supply_obj_control 0)
(global short ghost_obj_control 0)
(global short gate_obj_control 0)
(global short assault_obj_control 0)
(global short interior_obj_control 0)
(global short security_obj_control 0)
(global short ice_cave_obj_control 0)
(global short g_clumps_banshee 10)

; insertion point index 
(global short g_insertion_index 0)

(global real g_nav_offset 0.55)

(global object obj_carter none)
(global object obj_jun none)
(global object obj_emile none)
(global ai ai_carter none)
(global ai ai_jun none)
(global ai ai_emile none)

(global boolean b_spartans_land FALSE)
(global boolean g_drop_occupied01 FALSE)
(global boolean g_drop_occupied02 FALSE)
(global boolean g_drop_occupied03 FALSE)
(global boolean g_drop_begin01 FALSE)
(global boolean g_drop_begin02 FALSE)
(global boolean g_drop_begin03 FALSE)
(global boolean g_phantom_dropped01 FALSE)
(global boolean g_phantom_dropped02 FALSE)
(global boolean g_phantom_dropped03 FALSE)
(global boolean g_phantom_dropped04 FALSE)
(global boolean g_phantom_dropped05 FALSE)
(global boolean g_phantom_dropped06 FALSE)
(global boolean g_phantom_dropped07 FALSE)
(global boolean g_tank_drop FALSE)

(global short g_turret_type 14)
(global short g_ice_wave 0)
(global ai g_ice_dropship01 none)
(global ai g_ice_dropship02 none)
(global ai g_ice_dropship03 none)
(global ai g_ice_dropship04 none)
(global ai g_ice_dropship05 none)
(global ai g_ice_dropship06 none)
(global ai g_ice_dropship07 none)
(global ai g_ice_squad01a none)
(global ai g_ice_squad01b none)
(global ai g_ice_squad01c none)
(global ai g_ice_squad01d none)
(global ai g_ice_squad02a none)
(global ai g_ice_squad02b none)
(global ai g_ice_squad02c none)
(global ai g_ice_squad02d none)
(global ai g_ice_squad03a none)
(global ai g_ice_squad03b none)
(global ai g_ice_squad03c none)
(global ai g_ice_squad03d none)
(global ai g_ice_squad04a none)
(global ai g_ice_squad04b none)
(global ai g_ice_squad04c none)
(global ai g_ice_squad04d none)
(global ai g_ice_squad05a none)
(global ai g_ice_squad05b none)
(global ai g_ice_squad05c none)
(global ai g_ice_squad05d none)
(global ai g_ice_squad06a none)
(global ai g_ice_squad06b none)
(global ai g_ice_squad06c none)
(global ai g_ice_squad06d none)
(global ai g_ice_squad07a none)
(global ai g_ice_squad07b none)
(global ai g_ice_squad07c none)
(global ai g_ice_squad07d none)

(global short phantom01_hold 0)
(global short phantom02_hold 0)
(global short phantom03_hold 0)
(global short phantom04_hold 0)
(global short phantom05_hold 0)
(global short phantom06_hold 0)
(global short phantom07_hold 0)


;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
;=============================== MISSION SCRIPT ==============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
(script startup mission_startup
; fade out 
	(fade_out 0 0 0 0)
	(if (editor_mode)
		(fade_in 0 0 0 0)
		(start)		
	)
)

(script static void start
	(print "starting")
	
 	(wake m60_mission)
 	
 	(soft_ceiling_enable soft_ceiling_interior FALSE)
 
	; coop initial profiles
	(if (game_is_cooperative)
		(begin
			(unit_add_equipment player0 coop_starting_profile TRUE FALSE)
			(unit_add_equipment player1 coop_starting_profile TRUE FALSE)
			(unit_add_equipment player2 coop_starting_profile TRUE FALSE)
			(unit_add_equipment player3 coop_starting_profile TRUE FALSE)
		)
	)
	
	; coop respawn profile
	(player_set_profile swordbase_respawn_profile)
 
	(cond
		((= (game_insertion_point_get) 0) (ins_main_start))
		;((= (game_insertion_point_get) 1) (ins_motorpool))
		;((= (game_insertion_point_get) 2) (ins_supply_depot))
		;((= (game_insertion_point_get) 3) (ins_gate_attack))		
		((= (game_insertion_point_get) 4) (ins_assault))
		;((= (game_insertion_point_get) 5) (ins_interior))			
		;((= (game_insertion_point_get) 6) (ins_security))
		((= (game_insertion_point_get) 7) (ins_ice_cave))			
	)
	
)

(script dormant m60_mission
	;setup allegiance
			
	(ai_allegiance human player)
	(ai_allegiance player human)
	(object_intialization)
	(wake object_management)
	(wake special_elite)
		; === PLAYER IN WORLD TEST =====================================================

			(sleep_until (>= g_insertion_index 1) 1)
			
			(if (= g_insertion_index 1) (wake enc_intro))
			
			(sleep_until	(or
							(volume_test_players tv_motorpool)
							(>= g_insertion_index 2)
						)
			1)
		
			(if (<= g_insertion_index 2) (wake enc_motorpool))	

			(sleep_until	(or
							(volume_test_players tv_supply_depot)
							(>= g_insertion_index 3)
						)
			1)
			
			(if (<= g_insertion_index 3) (wake enc_supply_depot))

			(sleep_until	(or
							(volume_test_players tv_gate_attack)
							(>= g_insertion_index 4)
						)
			1)

			(if (<= g_insertion_index 4) (wake enc_gate_attack))	

			(sleep_until	(or
							(volume_test_players tv_base_assault)
							(>= g_insertion_index 5)
						)
			1)
			
			(if (<= g_insertion_index 5) (wake enc_base_assault))
			
			(sleep_until	(or
							(volume_test_players tv_interior_battle)
							(>= g_insertion_index 6)
						)
			1)
			(if (<= g_insertion_index 6) (wake enc_interior_battle))
			
			(sleep_until	(or
							(volume_test_players tv_security_battle)
							(>= g_insertion_index 7)
						)
			1)

			(if (<= g_insertion_index 7) (wake enc_security_battle))
			
			(sleep_until	
						(or
							(and 
								(> (device_get_position cin_mid_door_switch) 0)
								(< g_insertion_index 8)
							)
							(>= g_insertion_index 8)
						)
			1)

			(if (<= g_insertion_index 8) (wake cin_tram_ride))
			
			(sleep_until	(or (>= g_insertion_index 9) (= g_mid_cinematic TRUE))
			1)
			(wake enc_ice_cave)					
							
)

;===================================================================================================
;=====================ENCOUNTER_INTRO SCRIPTS =============================================
;===================================================================================================

(script dormant enc_intro
	(data_mine_set_mission_segment "m60_intro")
	(print "m60_intro")
	(switch_zone_set enc_intro_set)
	(cond 
		((= (game_coop_player_count) 1)
			(begin
				(ai_place sq_initial_troopers/odst01)
				(ai_place sq_initial_troopers/odst02)
				(ai_place sq_initial_troopers/odst03)	
			)
		)	
		((= (game_coop_player_count) 2)
			(begin
				(ai_place sq_initial_troopers/odst01)
				(ai_place sq_initial_troopers/odst02)	
			)
		)
		((= (game_coop_player_count) 3)(ai_place sq_initial_troopers/odst01))
	)			
	(flock_create fl_banshee_init)
	(flock_create fl_falcon_init)		
	(if 
		(or
			(= (game_difficulty_get) easy)
			(= (game_difficulty_get) normal)
		) 
		(begin
			(object_create noob_dmr)
			(object_create noob_sniper)
		)
	)	
	(if (not (game_is_cooperative))
		(ai_player_add_fireteam_squad (player0) sq_initial_troopers))

	(wake marine_nanny)
	(wake md_010_initial)
	(wake md_010_spartans)	
	;(wake md_010_reminder)
	(sleep 1)
	(ai_place sq_intro01)
	(sleep 1)	
	(ai_place sq_intro02)
	(ai_place sq_scorpion01)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_scorpion01/tank) "scorpion_d" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_scorpion01/tank) "scorpion_p_lf" true)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_starting_location sq_scorpion01/tank) "scorpion_p_rf" true)		
	(sleep 1)	
	(if 
		(or
			(>= (game_coop_player_count) 2)
			(= (game_difficulty_get) legendary)
		)
		(ai_place sq_intro03)
	)
	(ai_place sq_intro04)
	(if 
		(or
			(>= (game_coop_player_count) 2)
			(= (game_difficulty_get) legendary)
		)	
		(ai_place sq_intro05)
	)
	(ai_place sq_intro08)
	(sleep 1)
	(ai_place sq_intro09)
	(sleep 1)	
	(ai_place sq_intro10)
	(wake m60_music_01)
	(wake m60_music_02)
	(wake m60_music_02_alt)
	(cinematic_exit_into_title 060la_returnsword TRUE)		
	(wake enc_intro_obj_control)
	(wake aj_mode)	
	(wake enc_intro_saves)
	(wake title_start)
	(wake nav_intro)
	(sleep 30)
	(set g_music_m60_01 1)
	(sleep 60)
	(game_save)
)	

(script dormant enc_intro_test1
	(ai_place gr_intro)
)

(script dormant enc_intro_test2
	(ai_place sq_intro01)
)

(script dormant enc_intro_obj_control
	(sleep_until (volume_test_players tv_intro_obj_control_10) 1)
	(set intro_obj_control 10)	
	(sleep_until (volume_test_players tv_intro_obj_control_20) 1)
	(set intro_obj_control 20)		
	(sleep_until (volume_test_players tv_intro_obj_control_30) 1)
	(set intro_obj_control 30)		
)

(script dormant enc_intro_saves
	(sleep_until 
		(or 
			(< (ai_living_count sq_intro02) 1)
			(and
				(< (ai_living_count sq_intro01) 1)
				(< (ai_living_count sq_intro03) 1)
			)
			(and
				(< (ai_living_count sq_intro04) 1)
				(< (ai_living_count sq_intro05) 1)
			)
			(<= (ai_strength gr_intro) 0.50)				
		)
	5)	
	(game_save_no_timeout)
	(sleep_until (< (ai_living_count gr_intro) 1)5)
	(game_save)
)

(script dormant nav_intro
	(branch
		(>= motorpool_obj_control 10)
		(unblip_all)
	)
	(sleep 3600)
	(f_blip_flag cf_nav_motorpool 21)
)


;===================================================================================================
;=====================ENCOUNTER_MOTORPOOL SCRIPTS =============================================
;===================================================================================================

(script static void grunt_test
	(ai_place sq_motorpool08)		
	(ai_vehicle_enter_immediate sq_motorpool08/01 (object_get_turret motorpool_watchtower02 0))
	;(cs_run_command_script sq_motorpool08/01 cs_stay_in_turret)
	(ai_vehicle_enter_immediate sq_motorpool08/02 (object_get_turret motorpool_watchtower02 1))
	;(cs_run_command_script sq_motorpool08/02 cs_stay_in_turret)		
)

(script dormant enc_motorpool
	; set first mission segment
	(data_mine_set_mission_segment "m60_01_motorpool")
	(print "m60_cov_motorpool")
	;(if (>= (game_coop_player_count) 3) (ai_place sq_scorpion02))
	(set g_music_m60_02 3)
	(ai_place sq_motorpool07)
	(ai_vehicle_enter_immediate sq_motorpool07/01 (object_get_turret motorpool_watchtower01 2))
	;(cs_run_command_script sq_motorpool07/01 cs_stay_in_turret)
	(ai_vehicle_enter_immediate sq_motorpool07/02 (object_get_turret motorpool_watchtower01 1))
	;(cs_run_command_script sq_motorpool07/02 cs_stay_in_turret)		
	(ai_place sq_motorpool08)		
	(ai_vehicle_enter_immediate sq_motorpool08/01 (object_get_turret motorpool_watchtower02 0))
	;(cs_run_command_script sq_motorpool08/01 cs_stay_in_turret)
	(ai_vehicle_enter_immediate sq_motorpool08/02 (object_get_turret motorpool_watchtower02 1))
	;(cs_run_command_script sq_motorpool08/02 cs_stay_in_turret)		
	
	(ai_place sq_motorpool01)
	(ai_place sq_motorpool02)
	(ai_place sq_motorpool03a)
;	(ai_place sq_motorpool03b)		
	(ai_place sq_motorpool04)
	(ai_place sq_motorpool05)
	(soft_ceiling_enable camera_blocker_01 FALSE)


	
	; place allies 	
	; wake global scripts 
	; wake navigation point scripts 		
	; mission dialogue scripts
	(wake md_020_motorpool)	
	(wake md_030_supply)	
	; wake vignettes
	; wake ai background threads 
	; wake music scripts 
	; start Objective Control checks
	(wake enc_motorpool_obj_control)
	(wake enc_motorpool_saves)
;	(wake enc_motorpool_scorpion)
	(wake enc_motorpool_reinf)
)

(script dormant enc_motorpool_obj_control
	(sleep_until (volume_test_players tv_motorpool_obj_control_10) 1)
	(set motorpool_obj_control 10)	
	(sleep_until (volume_test_players tv_motorpool_obj_control_20) 1)
	(set motorpool_obj_control 20)		
	(sleep_until (volume_test_players tv_motorpool_obj_control_30) 1)
	(set motorpool_obj_control 30)		
	(sleep_until (volume_test_players tv_motorpool_obj_control_40) 1)
	(set motorpool_obj_control 40)
	(sleep_until (volume_test_players tv_motorpool_obj_control_50) 1)
	(set motorpool_obj_control 50)
	(sleep_until (volume_test_players tv_motorpool_obj_control_60) 1)
	(set motorpool_obj_control 60)		
)

(script dormant enc_motorpool_reinf
	(sleep_until (>= motorpool_obj_control 30)5)
	(ai_place sq_motorpool10)
	(ai_place sq_motorpool06)
;	(sleep_until (>= motorpool_obj_control 40)5)
;	(ai_place sq_motorpool11)
;	(ai_place sq_motorpool12)
)
(script dormant enc_motorpool_saves
	(sleep_until (>= motorpool_obj_control 10))
	(game_save_no_timeout)
	(sleep_until 
		(or 
			(and
				(< (ai_living_count sq_motorpool01) 1)
				(< (ai_living_count sq_motorpool02) 1)				
			)
			(and
				(< (ai_living_count sq_motorpool12) 1)
				(< (ai_living_count sq_motorpool11) 1)			
			)
			(and
				(< (ai_living_count sq_motorpool10) 1)
				(< (ai_living_count sq_motorpool06) 1)
			)
			(<= (ai_strength gr_motorpool) 0.50)			
		)
	5)
	(game_save_no_timeout)
	(sleep_until (< (ai_living_count gr_motorpool) 1)5)
	(game_save)
)

;===================================================================================================
;=====================ENCOUNTER_SUPPLY_DEPOT SCRIPTS =============================================
;===================================================================================================

(script dormant enc_supply_depot
	; set second mission segment
	(data_mine_set_mission_segment "m60_02_supply_depot")
	(print "m60_cov_supply_depot")
	(ai_place sq_depot02)
	;(ai_place sq_depot03)	perf removal.
	(sleep 1)
	(ai_place sq_depot04)
	;(ai_place sq_depot05)
	(sleep 1)	
	(ai_place sq_depot06)
;	(ai_place sq_depot07)	for perf! :(
	(sleep 1)			
	(ai_place sq_depot08)
	(sleep 1)			
	(ai_place sq_depot12)
	(ai_erase gr_intro)	
	(wake m60_music_03)
	(ai_set_clump sq_depot12 g_clumps_banshee)
	(wake supply_floor_garbage)
	(soft_ceiling_enable camera_blocker_02 FALSE)	
	(add_recycling_volume tv_start_garbage 1 1)
	(sleep 1)
	(add_recycling_volume tv_motorpool_garbage 20 20)
	(wake supply_depot_teleport)
	(wake enc_supply_obj_control)
	(wake enc_supply_banshee)
	
	(sleep 10)
	(wake enc_supply_nav)		
	(wake md_030_supply_reminder)
	(wake md_030_supply_AA_progress)
	(wake falcon_attack)
	(game_save)
	(sleep_until 
		(or 
			(= g_bfg01_destroyed true)
			(= g_bfg02_destroyed true)
		)
	5)
	(sleep 30)
	(add_recycling_volume tv_supply_depot_garbage 5 10)	
	(game_save)		
	(sleep_until 
		(and 
			(= g_bfg01_destroyed true)
			(= g_bfg02_destroyed true)
		)
	5)
	(ai_erase gr_motorpool)
	(set g_music_m60_03 1)
	;(if (> (ai_living_count gr_depot) 9) (ai_kill_silent gr_depot))
	(if (!= (game_difficulty_get) legendary)
		(ai_renew sq_scorpion01))
	(wake gate_zone_load)
	(f_hud_obj_complete)	
	(sleep 210)
	(add_recycling_volume tv_supply_depot_garbage 5 10)	
	(f_hud_obj_new ct_objective_gate PRIMARY_OBJECTIVE_3)		
	(game_save_no_timeout)		
)

(script dormant supply_depot_teleport
	(sleep_until (>= supply_obj_control 10)1)
	(volume_teleport_players_not_inside tv_supply_depot_teleport ins_supply_start_00)
	(ai_cleanup tv_start_garbage sq_initial_troopers)		
)

(global boolean g_bfg01_core_destroyed false)
(global boolean g_bfg01_destroyed false)
(global boolean g_bfg02_core_destroyed false)
(global boolean g_bfg02_destroyed false)

(script dormant bfg01_state
	(sleep_until (object_model_target_destroyed (vehicle v_bfg01) "target_core"))
	(print "bfg01_core_destroyed")
	(set g_bfg01_core_destroyed TRUE)
	(sleep (* 16 30))
	(print "bfg01_destroyed")
	(set g_bfg01_destroyed TRUE)
)
(script dormant bfg02_state
	(sleep_until (object_model_target_destroyed (vehicle v_bfg02) "target_core"))
	(print "bfg02_core_destroyed")
	(set g_bfg02_core_destroyed TRUE)
	(sleep (* 16 30))
	(print "bfg02_destroyed")
	(set g_bfg02_destroyed TRUE)
)

(script dormant supply_floor_garbage
	(sleep_until
		(begin
			(add_recycling_volume tv_supply_floor_garbage 0 0)
		false)
	30)
)

(script dormant falcon_attack
	(sleep_until 
		(and 
			(= g_bfg02_core_destroyed true)
			(= g_bfg01_core_destroyed true)
		)
	5)
	
	(ai_place sq_carter_event)
	(ai_force_active sq_carter_event TRUE)
	(ai_cannot_die sq_carter_event true)
	(object_ignores_emp (ai_vehicle_get_from_starting_location sq_carter_event/actor) true)
	(object_cannot_take_damage (ai_vehicle_get_from_starting_location sq_carter_event/actor))
	(cs_run_command_script sq_carter_event cs_spartan_falcon_path)

	(if 
		(and
			(= enc_gate_start_prematurely FALSE)
			(< (ai_living_count gr_gate_attack) 1)
		)
		(begin
			(set enc_gate_start TRUE)
			(sleep 5)		
			(ai_place gr_gate_attack)
		)
	)
	
	(wake carter_nanny)
	;(wake fake_battle_nanny)
	;(ai_set_targeting_group gr_depot_banshees 1)	
	(flock_create fl_banshee)
	(sleep 15)
	(ai_place sq_falcon02)
	(ai_force_active sq_falcon02 TRUE)
	(object_ignores_emp (ai_vehicle_get_from_starting_location sq_falcon02/pilot) true)	
	(sleep 15)

	(sleep_until (= supply_banshee_end true)5)
	
	(if 
		(and
			(= enc_gate_start_prematurely false)
			(not (game_is_cooperative))
		)
		(begin			
			(ai_place sq_falcon01)
			(ai_force_active sq_falcon01 TRUE)
			(object_ignores_emp (ai_vehicle_get_from_starting_location sq_falcon01/pilot) true)	
			(flock_create fl_falcon)
		)
	)
)

(script command_script bfg01_look_at
	;(ai_vehicle_enter_immediate sq_depot_bfg01/pilot v_bfg02)
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point true ps_supply_bfg_pts/p7)
				(cs_shoot_point true ps_supply_bfg_pts/p8)
				(cs_shoot_point true ps_supply_bfg_pts/p9)
				(cs_shoot_point true ps_supply_bfg_pts/p10)
				(cs_shoot_point true ps_supply_bfg_pts/p11)
				(cs_shoot_point true ps_supply_bfg_pts/p12)
				(cs_shoot_point true ps_supply_bfg_pts/p13)
			)
		false)
	(* (random_range 2 7)30))
)

(script command_script bfg02_look_at
	;(ai_vehicle_enter_immediate sq_depot_bfg02/pilot v_bfg02)
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point true ps_supply_bfg_pts/p0)
				(cs_shoot_point true ps_supply_bfg_pts/p1)
				(cs_shoot_point true ps_supply_bfg_pts/p2)
				(cs_shoot_point true ps_supply_bfg_pts/p3)
				(cs_shoot_point true ps_supply_bfg_pts/p4)
				(cs_shoot_point true ps_supply_bfg_pts/p5)
				(cs_shoot_point true ps_supply_bfg_pts/p6)
			)
		false)
	(* (random_range 2 7)30))
)

(script dormant sc_carter01_waypoint
	(if (not (game_is_cooperative))
    (f_hud_spartan_waypoint sq_carter_event carter_name 60)
  )
)

(script dormant sc_emile01_waypoint
	(if (not (game_is_cooperative))
		(f_hud_spartan_waypoint sq_emile_event emile_name 60)
	)
)

(script dormant sc_jun01_waypoint
	(if (not (game_is_cooperative))
		(f_hud_spartan_waypoint sq_jun_event jun_name 60)
	)
)


(script command_script cs_spartan_falcon_path
	(cs_vehicle_boost 1)	
	(cs_vehicle_speed 1)
	(if	(<= (game_coop_player_count) 2)
		(begin			
			(ai_place sq_emile_event)
			(ai_place sq_jun_event)
			(ai_force_active sq_emile_event TRUE)
			(ai_force_active sq_jun_event TRUE)
			(sleep 10)				
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_carter_event/actor) "falcon_g_l" (ai_get_object sq_emile_event/actor))
			(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_carter_event/actor) "falcon_g_r" (ai_get_object sq_jun_event/actor))
			(ai_cannot_die sq_emile_event TRUE)	
			(ai_cannot_die sq_jun_event TRUE)						
		)
	)
	(cs_ignore_obstacles true)	
	(cs_fly_by ps_spartan_falcon_carter/p0 3)
	(cs_fly_by ps_spartan_falcon_carter/p1 3)
	(f_blip_ai sq_carter_event 21)
	;(wake sc_carter01_waypoint)
	;(wake sc_emile01_waypoint)
	;(wake sc_jun01_waypoint)		
	(cs_fly_by ps_spartan_falcon_carter/p2 3)
	(cs_vehicle_speed 0.7)
	(if (< (ai_living_count gr_depot_banshees) 1) 
		(begin
			(ai_place sq_depot17)
			(ai_set_clump sq_depot17 g_clumps_banshee)
		)
	)
	(if (< (ai_living_count gr_depot_banshees) 3) 
		(begin
			(ai_place sq_depot18)			
			(ai_set_clump sq_depot18 g_clumps_banshee)
		)
	)		
	(cs_fly_by ps_spartan_falcon_carter/p3 2)	
	(cs_fly_by ps_spartan_falcon_carter/p4 2)
	(ai_disregard (ai_actors sq_carter_event) true)
	(ai_disregard (ai_actors sq_emile_event) true)
	(ai_disregard (ai_actors sq_jun_event) true)
	(ai_set_blind sq_jun_event true)
	(ai_set_blind sq_emile_event true)
	(ai_set_blind sq_carter_event true)
	(ai_set_deaf sq_carter_event true)	
	(ai_set_deaf sq_jun_event true)
	(ai_set_deaf sq_emile_event true)			
	(cs_fly_by ps_spartan_falcon_carter/p5 3)		
	(cs_fly_to ps_spartan_falcon_carter/p6 3)		
	(cs_fly_by ps_spartan_falcon_carter/p7 3)
	(cs_fly_by ps_spartan_falcon_carter/p8 3)			
	(sleep 30)
	(set b_spartans_land TRUE)
	(sleep 30)	
	(fade_to_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_falcon_attack01
	(ai_cannot_die ai_current_squad TRUE)
	(cs_enable_looking true)
	(cs_vehicle_boost 1)			
	(cs_fly_by ps_spartan_falcon01/p0 3)
	(ai_cannot_die ai_current_squad FALSE)
	(cs_ignore_obstacles true)			
	(cs_fly_by ps_spartan_falcon01/p1 5)
	(cs_fly_by ps_spartan_falcon01/p2 5)
	(cs_vehicle_speed 0.9)	
	(cs_fly_by ps_spartan_falcon01/p3 5)	
	;(ai_set_targeting_group ai_current_squad 1)
	(sleep_until
		(begin
			(begin_random
				(cs_fly_by ps_spartan_falcon01/p3 3)
				(cs_fly_by ps_spartan_falcon01/p9 3)
				(cs_fly_by ps_spartan_falcon01/p10 3)				
			)
			(>= supply_obj_control 90)
		)
	)	
	(cs_vehicle_speed 1)	
	(cs_fly_by ps_spartan_falcon01/p4 3)
	;(ai_set_targeting_group ai_current_squad -1)	
	(cs_fly_by ps_spartan_falcon01/p5 3)
	(ai_set_objective ai_current_squad obj_gate_attack)
	(sleep_until
		(begin
			(begin_random
				(cs_fly_by ps_spartan_falcon01/p6 3)
				(cs_fly_by ps_spartan_falcon01/p7 3)
				(cs_fly_by ps_spartan_falcon01/p8 3)
			)
		FALSE)
	)
)

(script command_script cs_falcon_attack02
	(ai_cannot_die ai_current_squad TRUE)
	(cs_vehicle_boost 1)		
	(cs_fly_by ps_spartan_falcon02/p1 3)
	(cs_enable_looking true)

	(ai_cannot_die ai_current_squad FALSE)		
	(cs_ignore_obstacles true)
	(cs_fly_by ps_spartan_falcon02/p2 5)
	(cs_vehicle_speed 0.9)		
	(cs_fly_by ps_spartan_falcon02/p3 5)
	;(ai_set_targeting_group ai_current_squad 1)		
	(sleep_until
		(begin
			(begin_random
				(cs_fly_by ps_spartan_falcon02/p3 3)
				(cs_fly_by ps_spartan_falcon02/p9 3)
				(cs_fly_by ps_spartan_falcon02/p10 3)				
			)
			(>= supply_obj_control 90)
		)
	)
	(cs_vehicle_speed 1)	
	(cs_fly_by ps_spartan_falcon02/p4 5)
	;(ai_set_targeting_group ai_current_squad -1)	
	(ai_set_objective ai_current_squad obj_gate_attack)		
	(cs_fly_by ps_spartan_falcon02/p5 3)			
	(sleep_until
		(begin
			(begin_random
				(cs_fly_by ps_spartan_falcon02/p6 3)
				(cs_fly_by ps_spartan_falcon02/p7 3)
				(cs_fly_by ps_spartan_falcon02/p8 3)				
			)
		FALSE)
	)
)

(script dormant enc_supply_obj_control
	(sleep_until (volume_test_players tv_supply_obj_control_10) 1)
	(set supply_obj_control 10)	
	(sleep_until (volume_test_players tv_supply_obj_control_20) 1)
	(set supply_obj_control 20)		
	(sleep_until (volume_test_players tv_supply_obj_control_30) 1)
	(set supply_obj_control 30)		
	(sleep_until (volume_test_players tv_supply_obj_control_40) 1)
	(set supply_obj_control 40)
	(sleep_until (volume_test_players tv_supply_obj_control_50) 1)
	(set supply_obj_control 50)	
	(sleep_until (volume_test_players tv_supply_obj_control_60) 1)
	(set supply_obj_control 60)		
	(sleep_until (volume_test_players tv_supply_obj_control_70) 1)
	(set supply_obj_control 70)
	(sleep_until (volume_test_players tv_supply_obj_control_80) 1)
	(set supply_obj_control 80)
	(sleep_until (volume_test_players tv_supply_obj_control_90) 1)
	(set supply_obj_control 90)		
	(sleep_until (volume_test_players tv_supply_obj_control_100) 1)
	(set supply_obj_control 100)							
)

(global boolean supply_banshee_end false)


(script dormant enc_supply_banshee
	(sleep_until (< (ai_living_count gr_depot_banshees) 1)5)
		(ai_place sq_depot13)	
		(ai_set_clump sq_depot13 g_clumps_banshee)	
		(sleep (random_range 60 90))
	(sleep_until 
		(and
			(or
				(= g_bfg01_destroyed true)
				(= g_bfg02_destroyed true)
			)(< (ai_living_count gr_depot_banshees) 3)
		)
	5)
		(if (= enc_gate_start_prematurely false) 
			(begin
				(ai_place sq_depot14)
				(ai_set_clump sq_depot14 g_clumps_banshee)	
			)
		)
	(sleep_until (< (ai_living_count gr_depot_banshees) 3)30 (random_range 240 320))		
		(ai_place sq_depot15)
		(ai_set_clump sq_depot15 g_clumps_banshee)
	(sleep_until (< (ai_living_count gr_depot_banshees) 3)5)
		(sleep 150)
		(set supply_banshee_end true)
)

(script dormant enc_supply_nav

	
	(sleep_until 
			(or
				(= g_bfg01_destroyed true)
				(= g_bfg02_destroyed true)
			)
		5)
		(if (= g_bfg01_destroyed true)
				(begin
					(f_unblip_flag gun01_flag)
					(sleep 30)
				)
				(f_unblip_flag gun02_flag)
		)
	(sleep 30)			
	(sleep_until 
			(and
				(= g_bfg01_destroyed true)	
				(= g_bfg02_destroyed true)
			)
		5)
	(f_unblip_flag gun01_flag)
	(f_unblip_flag gun02_flag)
					
)

(script dormant gate_zone_load
	; activates the begin_zone volume, then waits for the current_zone_set to change before it enables the zone_set to prevent loading hitches
	(sleep_until (= b_spartans_land TRUE)5)
	(zone_set_trigger_volume_enable begin_zone_set:sword_surf_exterior:*	TRUE)
	(print "BEGIN LOADING SWORD SURF EXTERIOR")
	(sleep_until 
		(and 
			(!= (current_zone_set_fully_active)(current_zone_set))
			(< (ai_living_count gr_gate_attack) 5)
		)
	1)

	;(wake horrible_coop_teleport)
	(sleep 450)
	(zone_set_trigger_volume_enable zone_set:sword_surf_exterior TRUE)
	
)

;===================================================================================================
;=====================ENCOUNTER_GATE_ATTACK SCRIPTS =============================================
;===================================================================================================
(global boolean enc_gate_start FALSE)
(global boolean enc_gate_start_prematurely FALSE)
(script dormant enc_gate_attack
	; set third mission segment
	(data_mine_set_mission_segment "m60_03_gate_attack")
	(print "m60_gate_attack")
	(if 
		(or
			(= g_bfg01_destroyed false)	
			(= g_bfg02_destroyed false)
		)
		(begin
			(set enc_gate_start_prematurely TRUE)
		)
	)
	(if
		(and  
			(< (ai_living_count gr_gate_attack) 1)
			(= enc_gate_start FALSE)
		)
		(begin
			(wake enc_gate_attack_return)
			(ai_place sq_depot10)
			(sleep 1)
			(ai_place sq_depot11)	
			(sleep 1)			
			(ai_place sq_depot09)
			(sleep 1)
			(ai_place gr_gate_attack)							
		)
		(begin
			(ai_place sq_depot10)
			(sleep 1)
			(ai_place sq_depot11)	
			(sleep 1)			
			(ai_place sq_depot09)
			(sleep 1)
		)		
	)
	(soft_ceiling_enable camera_blocker_03 FALSE)
	(soft_ceiling_enable soft_ceiling_interior FALSE)
	; place allies 	
	; wake global scripts 
	; wake navigation point scripts 		
	; mission dialogue scripts
	(wake md_050_gate)
	(game_save)		
	; wake vignettes
	; wake music scripts 
	; start Objective Control checks

	(wake enc_gate_obj_control)
	(wake enc_gate_enemies)
	
	(sleep_until (= (current_zone_set_fully_active) 3) 5)
	(print "OPEN THE DOOR!")

	(if (game_is_cooperative)
		(begin
			(zone_set_trigger_volume_enable begin_zone_set:initial_zone_set	FALSE)
			(zone_set_trigger_volume_enable zone_set:initial_zone_set	FALSE)
			(wake horrible_coop_teleport)
		)
		(begin
			(zone_set_trigger_volume_enable begin_zone_set:initial_zone_set	TRUE)
			(zone_set_trigger_volume_enable zone_set:initial_zone_set	TRUE)
		)
	)
	
	(ai_erase gr_depot)	
	(device_set_position oni_front_gate 1)
	(f_hud_obj_complete)	
	(game_save_no_timeout)
	(wake tank_achievement)


)
(script dormant tank_achievement
	(sleep_until (volume_test_object tv_tank_achievement (ai_vehicle_get_from_spawn_point sq_scorpion01/tank))5)
	(if 
		(and
			(= (game_difficulty_get) legendary)
			(volume_test_object tv_tank_achievement (ai_vehicle_get_from_spawn_point sq_scorpion01/tank))
		)
		(begin
			(submit_incident_with_cause_player "tank_survive_achieve" player0)
			(submit_incident_with_cause_player "tank_survive_achieve" player1)
			(submit_incident_with_cause_player "tank_survive_achieve" player2)
			(submit_incident_with_cause_player "tank_survive_achieve" player3)
		)
	)
)
(script dormant enc_gate_attack_return
	(sleep_until
		(begin
			(sleep_until (volume_test_players tv_base_assault)5)
			(ai_cannot_die gr_gate_attack FALSE)
		FALSE)
	)
)
(script dormant enc_gate_obj_control
	(sleep_until (volume_test_players tv_gate_obj_control_10) 1)
	(set gate_obj_control 10)	
	(sleep_until (volume_test_players tv_gate_obj_control_20) 1)
	(set gate_obj_control 20)		
	(sleep_until (volume_test_players tv_gate_obj_control_30) 1)
	(set gate_obj_control 30)		
	(sleep_until (volume_test_players tv_gate_obj_control_40) 1)
	(set gate_obj_control 40)
	(sleep_until (volume_test_players tv_gate_obj_control_50) 1)
	(set gate_obj_control 50)
	(f_unblip_flag front_gate_flag)	
)
(script dormant enc_gate_enemies

	(object_create_folder w_depot)
	(object_create_folder v_gate)	
	(sleep_until (>= gate_obj_control 10)5)

	(if (> (ai_living_count gr_falcons) 0)
	(ai_place gr_gate_banshees))

	;(ai_set_targeting_group gr_falcons 2)	
	;(ai_set_targeting_group gr_gate_banshees 2)	

	(sleep_until (< (ai_living_count gr_gate_attack) 3)5 900)

	(if (> (ai_living_count gr_falcons) 0)
	(ai_place gr_gate_banshees))	

	;(ai_set_targeting_group gr_falcons 2)	
	;(ai_set_targeting_group gr_gate_banshees 2)
)
(script dormant horrible_coop_teleport
	(sleep_until
		(begin
			(sleep_until (volume_test_players tv_player_blocker)5)
				(cond
					((volume_test_object tv_player_blocker player0)
						(begin
							(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player0)
							(object_teleport player0 player0_teleport)
							(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player0)
						)
					)
					((volume_test_object tv_player_blocker player1)
						(begin
							(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player1)
							(object_teleport player1 player1_teleport)
							(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player1)
						)
					)
					((volume_test_object tv_player_blocker player2)
						(begin
							(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player2)
							(object_teleport player2 player2_teleport)
							(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player2)
						)
					)
					((volume_test_object tv_player_blocker player3)
						(begin
							(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player3)
							(object_teleport player3 player3_teleport)
							(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player3)
						)
					)
				)			
		FALSE)
	1)															
)

(script dormant carter_nanny
	(sleep_until 
		(or
			(< (ai_living_count sq_carter_event) 1)
			(not (cs_command_script_running sq_carter_event cs_spartan_falcon_path))
		)5 2400)
	(print "CARTER GOT HUNG UP- SEZ THE NANNY")
	(set b_spartans_land TRUE)
)

(script static boolean b_fake_battle_gate
	(if
		(and 
			(= enc_gate_start_prematurely false)
			(not (volume_test_players tv_fake_battle))
		)
	true)	
	
)

;===================================================================================================
;=====================ENCOUNTER_BASE_ASSAULT SCRIPTS =============================================
;===================================================================================================

(script dormant sc_carter02_waypoint
	(if (not (game_is_cooperative))
    (f_hud_spartan_waypoint sq_carter carter_name 60)
  )
)

(script dormant sc_emile02_waypoint
	(if (not (game_is_cooperative))
		(f_hud_spartan_waypoint sq_emile emile_name 60)
	)
)

(script dormant sc_jun02_waypoint
	(if (not (game_is_cooperative))
		(f_hud_spartan_waypoint sq_jun jun_name 60)
	)
)

(script dormant enc_base_assault
	; set fourth mission segment
	(data_mine_set_mission_segment "m60_04_base_assault")
	(print "m60_base_assault")
	(wake m60_music_04)	
	(f_unblip_flag front_gate_flag)	
	(ai_place gr_base_assault)
	(ai_place sq_base_assault04)
	(ai_place sq_base_assault06)	
	(ai_place sq_carter/carter)
	(set ai_carter sq_carter/carter)
	(set obj_carter (ai_get_object sq_carter/carter))
	(if	(<= (game_coop_player_count) 2)
		(begin			
			(ai_place sq_emile/emile)
			(set ai_emile sq_emile/emile)
			(set obj_emile (ai_get_object sq_emile/emile))
			(ai_place sq_jun/jun)
			(set ai_jun sq_jun/jun)
			(set obj_jun (ai_get_object sq_jun/jun))
		)
	)
	(ai_cannot_die gr_spartans TRUE)
	(ai_cannot_die gr_base_assault TRUE)
	(ai_actor_dialogue_effect_enable gr_spartans true)
	(ai_set_objective sq_carter obj_base_assault)
	(if	(<= (game_coop_player_count) 2)
		(begin			
			(ai_set_objective sq_emile obj_base_assault)
			(ai_set_objective sq_jun obj_base_assault)
		)
	)
;	(damage_object dead_falcon "hull" 1000)	
	(wake spartan_nanny)
	(game_save)		
	; place allies 	
	; wake global scripts 
	; wake navigation point scripts 		
	; mission dialogue scripts
	(wake md_070_assault)
	; wake vignettes
	; wake ai background threads 
	; wake music scripts 
	; start Objective Control checks	
	(wake enc_assault_obj_control)
	(wake title_courtyard)
	(sleep_forever enc_supply_banshee)
	(ai_erase gr_depot_banshees)
	(sleep_until (>= assault_obj_control 10) 5)
	(wake sc_carter02_waypoint)
	(wake sc_emile02_waypoint)
	(wake sc_jun02_waypoint)		
	(ai_cannot_die gr_base_assault FALSE)
	(ai_actor_dialogue_effect_enable gr_spartans false)
	(game_insertion_point_unlock 4)	
	(if (= s_special_elite 1)
		(begin
			(print "SPECIAL ELITE DROPPING IN ASSAULT")
			(ai_place special_elite01)
		)
	)
	(sleep_until (<= (ai_living_count gr_base_assault) 6)5)
	(add_recycling_volume tv_base_assault_garbage01 5 5)
	(game_save)
	(sleep 150)	
	(sleep_until (<= (ai_living_count gr_base_assault) 3)5)
	(add_recycling_volume tv_base_assault_garbage01 5 5)	
	(sleep 150)		
	(game_save)	
	(sleep_until (<= (ai_living_count gr_base_assault) 0)5)
	(add_recycling_volume tv_base_assault_garbage01 5 5)
	(sleep 150)	
	(game_save_no_timeout)				
)

(script dormant enc_assault_obj_control
	(sleep_until (volume_test_players tv_assault_obj_control_10) 1)
	(set assault_obj_control 10)	
	(sleep_until (volume_test_players tv_assault_obj_control_20) 1)
	(set assault_obj_control 20)		
	(sleep_until (volume_test_players tv_assault_obj_control_30) 1)
	(set assault_obj_control 30)
	(ai_erase sq_initial_troopers)			
	(sleep_until (volume_test_players tv_assault_obj_control_40) 1)
	(set assault_obj_control 40)
	(wake enc_assault_nav)
	(game_save)
)

(script dormant enc_assault_nav
	(branch
		(>= interior_obj_control 5)
		(unblip_all)
	)
	(sleep 1200)
	(f_blip_flag cf_interior 21)
		

)

;===================================================================================================
;=====================ENCOUNTER_INTERIOR SCRIPTS =============================================
;===================================================================================================
(script dormant enc_interior_battle
	; set fifth mission segment
	(data_mine_set_mission_segment "m60_05_interior")
	(sleep_forever tank_achievement)
	(print "m60_interior_battle")
	(wake m60_music_05)		
	(flock_stop fl_banshee)
	(flock_stop fl_falcon)
	(flock_stop fl_banshee_init)
	(flock_stop fl_falcon_init)	
	(sleep_forever supply_floor_garbage)
	; place allies 
	(wake enc_interior_enemies)
	(ai_set_objective gr_spartans obj_interior)
	; wake navigation point scripts 		
	; mission dialogue scripts
	; wake vignettes
	; wake ai background threads 
	; wake music scripts 
	; start Objective Control checks
	(wake enc_interior_obj_control)	
	(thespian_performance_kill_by_name tn_elevator)		
	(device_set_power oni_elev_maintenance 1)
	(sleep_until (>= interior_obj_control 10)5)	
	(soft_ceiling_enable soft_ceiling_interior TRUE)
	(soft_ceiling_enable default FALSE)	
	(device_set_power oni_elev_maintenance 0)	
	(device_set_position_immediate oni_elev_maintenance 0)
	(f_interior_coop_teleport)	
)

(script dormant enc_interior_obj_control
	(sleep_until (volume_test_players tv_interior_obj_control_05) 1)
	(set interior_obj_control 5)	
	(sleep_until (volume_test_players tv_interior_obj_control_10) 1)
	(set interior_obj_control 10)	
	(sleep_until 
		(or
			(volume_test_players tv_interior_obj_control_20)
			(volume_test_players tv_interior_obj_control_50)
		) 1)
		(if (volume_test_players tv_interior_obj_control_20) (set interior_obj_control 20))
	(sleep_until 
		(or
			(volume_test_players tv_interior_obj_control_30)
			(volume_test_players tv_interior_obj_control_50)
		) 1)
		(if (volume_test_players tv_interior_obj_control_30) (set interior_obj_control 30))
	(sleep_until 
		(or
			(volume_test_players tv_interior_obj_control_40)
			(volume_test_players tv_interior_obj_control_50)
		) 1)
		(if (volume_test_players tv_interior_obj_control_40) (set interior_obj_control 40))
	(sleep_until (volume_test_players tv_interior_obj_control_50) 1)
	(set interior_obj_control 50)	
	(sleep_until (volume_test_players tv_interior_obj_control_60) 1)
	(set interior_obj_control 60)		
	(sleep_until (volume_test_players tv_interior_obj_control_70) 1)
	(set interior_obj_control 70)					
)

(script static void f_interior_coop_teleport
	(if (not (volume_test_object tv_interior_teleport player0))
		(begin
			(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player0)
			(object_teleport player0 ins_interior_start_00)
			(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player0)
		)
	)
	(if (not (volume_test_object tv_interior_teleport player1))
		(begin
			(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player1)
			(object_teleport player1 ins_interior_start_01)
			(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player1)
		)
	)
	(if (not (volume_test_object tv_interior_teleport player2))
		(begin
			(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player2)
			(object_teleport player2 ins_interior_start_02)
			(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player2)
		)
	)
	(if (not (volume_test_object tv_interior_teleport player3))
		(begin
			(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player3)
			(object_teleport player3 ins_interior_start_03)
			(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player3)
		)
	)															
)

(script dormant enc_interior_enemies
	(ai_place sq_interior01)
	(ai_place sq_interior02)
	(ai_place sq_interior03)
	(ai_place sq_interior04)
	(if 
		(or
			(>= (game_coop_player_count) 3)
			(= (game_difficulty_get) legendary) 
		)	
	(ai_place sq_interior06))			
	(sleep_until 
		(or
			(<= (ai_living_count gr_interior_battle) 5)
			(> interior_obj_control 10)
		)5)
	(ai_place sq_interior09)

	(sleep_until 
		(or
			(<= (ai_living_count gr_interior_battle) 5)
			(>= interior_obj_control 20)
		)5)
	(if 
		(or
			(>= (game_coop_player_count) 3)
			(= (game_difficulty_get) legendary) 
		)		
	(ai_place sq_interior07))
	(game_save)		
	(sleep_until 
		(or
			(<= (ai_living_count gr_interior_battle) 5)
			(>= interior_obj_control 30)
		)5)
	(ai_place sq_interior08)

	(sleep_until 
		(or
			(<= (ai_living_count gr_interior_battle) 5)
			(>= interior_obj_control 40)
		)5)
	(if 
		(or
			(>= (game_coop_player_count) 3)
			(= (game_difficulty_get) legendary) 
		)
	(ai_place sq_interior05))
	(game_save)
	(sleep_until (< (ai_living_count gr_interior_battle) 1)5)
	(game_save)				
)

;===================================================================================================
;=====================ENCOUNTER_SECURITY SCRIPTS =============================================
;===================================================================================================
(script dormant enc_security_battle
	; set sixth mission segment
	(data_mine_set_mission_segment "m60_06_security")
	(print "m60_security_battle")
	(flock_delete fl_banshee)
	(flock_delete fl_falcon)
	(flock_delete fl_banshee_init)
	(flock_delete fl_falcon_init)	
	(ai_place sq_security01)
	(ai_place sq_security03)
	;(ai_set_targeting_group sq_security03 7 true)
	;(ai_disregard (ai_actors gr_spartans) true)	
	(ai_place sq_security04)
	(if 
		(or
			(>= (game_coop_player_count) 3)
			(= (game_difficulty_get) legendary) 
		)
	(ai_place sq_security05))
	(ai_place sq_security06)
	(if 
		(or
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) normal)
			(= (game_difficulty_get) legendary)
		)
	(object_create easy_terminal))
	; place allies 	
	; wake global scripts 
	; wake navigation point scripts 		
	; mission dialogue scripts
	(wake m60_music_06)	
	(wake md_080_security)
	; wake vignettes
	; wake ai background threads 
	; wake music scripts 
	; start Objective Control checks
	(wake enc_security_obj_control)
	(wake enc_security_saves)
	(wake enc_security_nav_point)
		
	(sleep_until (volume_test_players tv_dm_oni_interior)5)
	(device_set_power dm_oni_interior 1)
	(sleep_until (>= security_obj_control 30)5)
	(if (= s_special_elite 2)
		(begin
			(set s_special_elite_ticks 1200)
			(print "SPECIAL ELITE DROPPING IN SECURITY")
			(ai_place special_elite02)
		)
	)
			
)

(script command_script cs_engineer_movement
	;(cs_ignore_obstacles true)
	;(cs_fly_to ps_sword_atrium/p2)
	;(object_set_physics (ai_get_object sq_security06/engineer) false)		
	;(cs_fly_to ps_sword_atrium/p3)
	;(object_set_physics (ai_get_object sq_security06/engineer) true)
	(cs_fly_to ps_sword_atrium/p4)		
	(cs_face_player true)		
	(sleep_forever)
)

(script static void engineer_test
	(ai_place sq_security06)
	(cs_run_command_script sq_security06 cs_engineer_movement)

)

(script dormant enc_security_nav_point
	(sleep_until (>= security_obj_control 70)5)
	(sleep 900)
	(f_unblip_flag cf_sword_base_objective)
	(f_blip_object cin_mid_door_switch blip_interface)	
)

(script dormant enc_security_obj_control
	(sleep_until (volume_test_players tv_security_obj_control_05) 1)
	(set security_obj_control 5)
	(sleep_until (volume_test_players tv_security_obj_control_10) 1)
	(set security_obj_control 10)
	(sleep_until (volume_test_players tv_security_obj_control_15) 1)
	(set security_obj_control 15)			
	(sleep_until (volume_test_players tv_security_obj_control_20) 1)
	(set security_obj_control 20)		
	(sleep_until (volume_test_players tv_security_obj_control_30) 1)
	(set security_obj_control 30)		
	(sleep_until (volume_test_players tv_security_obj_control_40) 1)
	(set security_obj_control 40)
	(sleep_until 
		(or
			(volume_test_players tv_security_obj_control_50)
			(volume_test_players tv_security_obj_control_60)
		) 1)
		(if (volume_test_players tv_security_obj_control_50) (set security_obj_control 50))	
	(sleep_until (volume_test_players tv_security_obj_control_60) 1)
	(set security_obj_control 60)	
	(set g_music_m60_06 1)		
	(sleep_until (volume_test_players tv_security_obj_control_70) 1)
	(set security_obj_control 70)
	(sleep_until (volume_test_players tv_security_obj_control_80) 1)
	(set security_obj_control 80)						
)
; this is run from the objective task 
(script static void enc_security_bs_hack
	(cs_run_command_script sq_security04/p0 elite_glass01) 
	(cs_run_command_script sq_security04/p1 elite_glass01) 
)

(script dormant enc_security_saves
	(sleep_until 
		(or
			(>= security_obj_control 50)
			(and
				(< (ai_living_count sq_security04) 1)
				(<= (ai_living_count sq_security01) 1)
			)
		)
	)
		(game_save_no_timeout)
)

(script command_script elite_glass01
	(cs_go_to ps_atrium_bs/p0)
	(cs_move_towards_point ps_atrium_bs/p1 1)
)
(script command_script elite_glass02
	(cs_go_to ps_atrium_bs/p2)
	(cs_move_towards_point ps_atrium_bs/p3 1)
)
;===================================================================================================
;=====================CINEMATIC_TRAM_RIDE SCRIPTS =============================================
;===================================================================================================
(script dormant cin_tram_ride
	; (data_mine_set_mission_segment "m60_cin_tram_ride")
	(sleep_forever md_080_security)
	(set b_is_dialogue_playing FALSE)
;*
	(if (game_is_cooperative)
		(begin
			(unit_add_equipment player0 coop_starting_profile TRUE FALSE)
			(unit_add_equipment player1 coop_starting_profile TRUE FALSE)
			(unit_add_equipment player2 coop_starting_profile TRUE FALSE)
			(unit_add_equipment player3 coop_starting_profile TRUE FALSE)
		)
		(unit_add_equipment player0 solo_starting_profile TRUE FALSE)
	)
*;
	(if (not (editor_mode))
		(begin
			(cinematic_enter 060lb_tramride true)
			(sleep_forever enc_security_nav_point)
			(f_unblip_flag cf_sword_base_objective)
			(f_unblip_object cin_mid_door_switch)
			(ai_disregard (ai_actors gr_spartans) false)	
			(garbage_collect_unsafe)	
			(print "m60_tram_ride")
			(m60_cin_mid)
		)
		(begin
			(sleep_forever enc_security_nav_point)
			(f_unblip_flag cf_sword_base_objective)
			(f_unblip_object cin_mid_door_switch)
			(garbage_collect_unsafe)
			(switch_zone_set forerunner_ice_cave)
		)		
	)
	(sleep_until (= (current_zone_set_fully_active) 9)1)
	(set g_mid_cinematic TRUE)
	
		; place allies 	
		; wake global scripts 
		; wake navigation point scripts 		
		; mission dialogue scripts
		; wake vignettes
		; wake ai background threads 
		; wake music scripts 
		; start Objective Control checks
)
;===================================================================================================
;=====================ENCOUNTER_ICE_CAVE SCRIPTS =============================================
;===================================================================================================
(script dormant enc_ice_cave
	; set seventh mission segment
	(data_mine_set_mission_segment "m60_07_ice_cave")
	(print "m60_ice_cave")
	(wake m60_music_07)
	(wake m60_music_08)
	(wake m60_music_09)
	(wake m60_music_10)
	(wake m60_music_11)
	(wake m60_music_12)
	(wake m60_music_13)
	(wake m60_music_14)
	(sleep_forever md_080_security)
	(if 
		(or
			(= (game_difficulty_get) heroic)
			(= (game_difficulty_get) legendary)
		)
		(object_destroy eazy_rocket)
	)
	(f_unblip_flag cf_sword_base_objective)
	(f_unblip_object cin_mid_door_switch)
	(set b_is_dialogue_playing FALSE)
	(if (= (game_difficulty_get) legendary)(object_create legendary_terminal))	
	(ai_place sq_carter/carter_cave)
	(set ai_carter sq_carter/carter_cave)
	(set obj_carter (ai_get_object sq_carter/carter_cave))
	(ai_cannot_die ai_carter true)
	(if	(<= (game_coop_player_count) 2)
		(begin			
			(ai_place sq_emile/emile_cave)
			(set ai_emile sq_emile/emile_cave)
			(set obj_emile (ai_get_object sq_emile/emile_cave))
			(ai_cannot_die ai_emile true)
			(ai_place sq_jun/jun_cave)
			(set ai_jun sq_jun/jun_cave)
			(set obj_jun (ai_get_object sq_jun/jun_cave))
			(ai_cannot_die ai_jun true)
		)
	)
	
	(sleep 30)
	(object_cannot_die player0 true)
	(object_cannot_die player1 true)
	(object_cannot_die player2 true)
	(object_cannot_die player3 true)
	(if (!= (game_insertion_point_get) 7)
		(begin
			(object_teleport (player0) player0_mid_cin_teleport)
			(object_teleport (player1) player1_mid_cin_teleport)
			(object_teleport (player2) player2_mid_cin_teleport)
			(object_teleport (player3) player3_mid_cin_teleport)
		)
	)
	; coop respawn profile
	(player_set_profile ice_cave_respawn_profile)	
	(object_cannot_die player0 false)
	(object_cannot_die player1 false)
	(object_cannot_die player2 false)
	(object_cannot_die player3 false)	
	(wake md_100_ice_cave_initial)			


	(wake ice_cave_turret01)
	(wake ice_cave_turret02)
	(wake ice_cave_turret03)
	(wake ice_cave_turret04)
	
	(object_create obj_halsey_door)
	(object_create dm_ice_cave_elevator)
	(object_create tram_gate)
	(if (not (editor_mode))
		(cinematic_exit_into_title 060lb_tramride2 false)
	)
	(wake sc_carter03_waypoint)
	(wake sc_emile03_waypoint)
	(wake sc_jun03_waypoint)
	(wake enc_ice_cave_obj_control)			
	(ai_set_objective sq_carter obj_trooper_ice_cave)
	(if	(<= (game_coop_player_count) 2)
		(begin			
			(ai_set_objective sq_emile obj_trooper_ice_cave)			
			(ai_set_objective sq_jun obj_trooper_ice_cave)
		)
	)
	
	(sleep 60)

	(wake title_ice_cave)
	
	(sleep 30)
	(print "FOR DAVE LIEBER CAUSE THIS IS HIS ANIMATION")
	(device_set_position dm_ice_cave_elevator 0)
	
	(game_insertion_point_unlock 7)
	(game_save)	
		
	(sleep_until (>= ice_cave_obj_control 30)5)
	(wake ice_cave_battle)
	(wake md_120_ice_cave_mid)
	(wake md_130_ice_cave_end)		

	
)

(script dormant sc_carter03_waypoint
	(if (not (game_is_cooperative))
    (f_hud_spartan_waypoint sq_carter carter_name 60)
  )
)

(script dormant sc_emile03_waypoint
	(if (not (game_is_cooperative))
		(f_hud_spartan_waypoint sq_emile emile_name 60)
	)
)

(script dormant sc_jun03_waypoint
	(if (not (game_is_cooperative))
		(f_hud_spartan_waypoint sq_jun jun_name 60)
	)
)

(script dormant enc_ice_cave_obj_control
	(set ice_cave_obj_control 10)
	(sleep_until 
		(or
			(volume_test_players tv_ice_cave_obj_control_20)
			(volume_test_players tv_ice_cave_obj_control_30)
			(volume_test_players tv_ice_cave_obj_control_40)
			(volume_test_players tv_ice_cave_obj_control_50)						
		) 1)
		(if (volume_test_players tv_ice_cave_obj_control_20) 
			(begin
				(print "ice_cave_obj_control 20")
				(set ice_cave_obj_control 20)
			)
		)
	(sleep_until 
		(or	
			(volume_test_players tv_ice_cave_obj_control_30)
			(volume_test_players tv_ice_cave_obj_control_40)
			(volume_test_players tv_ice_cave_obj_control_50)		
		) 1)
		(if (volume_test_players tv_ice_cave_obj_control_30) 
			(begin
				(print "ice_cave_obj_control 30")
				(set ice_cave_obj_control 30)
			)
		)
	(sleep_until 
		(or

			(volume_test_players tv_ice_cave_obj_control_40)
			(volume_test_players tv_ice_cave_obj_control_50)
		) 1)
		(if (volume_test_players tv_ice_cave_obj_control_40) 
			(begin
				(print "ice_cave_obj_control 40")
				(set ice_cave_obj_control 40)
			)
		)
	(sleep_until 
			(volume_test_players tv_ice_cave_obj_control_50)
	1)
		(if (volume_test_players tv_ice_cave_obj_control_50) 
			(begin
				(print "ice_cave_obj_control 50")
				(set ice_cave_obj_control 50)
			)
		)
)

(global boolean b_ice_turret01 false)
(global boolean b_ice_turret02 false)
(global boolean b_ice_turret03 false)
(global boolean b_ice_turret04 false)
(global short s_total_turrets 0)


(script dormant ice_cave_turret01
	(ai_place sq_ice_turret01)
	(ai_cannot_die sq_ice_turret01 true)
	(ai_disregard (ai_actors sq_ice_turret01/pilot) true)
	(ai_braindead sq_ice_turret01 TRUE)
	(sleep_until (> (device_get_position ice_turret_switch01) 0)1)
	(if (= g_music_m60_08 0)(set g_music_m60_08 1))	
	(chud_track_object_with_priority (ai_vehicle_get sq_ice_turret01/pilot) 17)	
	(f_ice_cave_turret sq_ice_turret01/pilot ice_turret_switch01)
)
(script dormant ice_cave_turret02
	(ai_place sq_ice_turret02)
	(ai_cannot_die sq_ice_turret02 true)
	(ai_disregard (ai_actors sq_ice_turret02/pilot) true)
	(ai_braindead sq_ice_turret02 TRUE)
	(sleep_until (> (device_get_position ice_turret_switch02) 0)1)
	(if (= g_music_m60_08 0)(set g_music_m60_08 1))		
	(chud_track_object_with_priority (ai_vehicle_get sq_ice_turret02/pilot) 18)	
	(f_ice_cave_turret sq_ice_turret02/pilot ice_turret_switch02)
)
(script dormant ice_cave_turret03
	(ai_place sq_ice_turret03)
	(ai_cannot_die sq_ice_turret03 true)
	(ai_disregard (ai_actors sq_ice_turret03/pilot) true)
	(ai_braindead sq_ice_turret03 TRUE)
	(sleep_until (> (device_get_position ice_turret_switch03) 0)1)
	(if (= g_music_m60_08 0)(set g_music_m60_08 1))		
	(chud_track_object_with_priority (ai_vehicle_get sq_ice_turret03/pilot) 19)	
	(f_ice_cave_turret sq_ice_turret03/pilot ice_turret_switch03)
)
(script dormant ice_cave_turret04
	(ai_place sq_ice_turret04)
	(ai_cannot_die sq_ice_turret04 true)
	(ai_disregard (ai_actors sq_ice_turret04/pilot) true)
	(ai_braindead sq_ice_turret04 TRUE)
	(sleep_until (> (device_get_position ice_turret_switch04) 0)1)	
	(if (= g_music_m60_08 0)(set g_music_m60_08 1))	
	(chud_track_object_with_priority (ai_vehicle_get sq_ice_turret04/pilot) 20)	
	(f_ice_cave_turret sq_ice_turret04/pilot ice_turret_switch04)
)

;object_get_health sq_ice_turret01
(global boolean b_turret_switch_help FALSE)
(global short s_turret_online_count 0)
(global short s_turret_online_old -1)
(script static void (f_ice_cave_turret (ai turret) (device switch)) 
	(sleep_until
		(begin
			(print "generator switch activated!")			
			(set s_turret_online_count (+ s_turret_online_count 1))
			(if (>= s_turret_online_count 4) (set b_turret_switch_help true))
			(device_set_power switch 0)
			(ai_object_set_team turret player)
			(unit_open (ai_vehicle_get_from_spawn_point turret))
			(object_can_take_damage (ai_vehicle_get_from_starting_location turret))
			(f_unblip_object switch)			
			(sleep 30)															
			(ai_braindead turret false)
			(ai_disregard (ai_actors turret) false)
			(sleep_until (< (object_get_health (ai_vehicle_get_from_starting_location turret)) 0)1)
			(object_cannot_take_damage (ai_vehicle_get_from_starting_location turret))
			(set s_turret_online_count (- s_turret_online_count 1))			
			(md_140_turret_offline)
			(print "too much damage turret01!")			
			(ai_braindead turret TRUE)
			(ai_disregard (ai_actors turret) true)
			(cond
				((= turret sq_ice_turret01/pilot)(chud_track_object (ai_vehicle_get sq_ice_turret01/pilot) FALSE ))
				((= turret sq_ice_turret02/pilot)(chud_track_object (ai_vehicle_get sq_ice_turret02/pilot) FALSE ))
				((= turret sq_ice_turret03/pilot)(chud_track_object (ai_vehicle_get sq_ice_turret03/pilot) FALSE ))
				((= turret sq_ice_turret04/pilot)(chud_track_object (ai_vehicle_get sq_ice_turret04/pilot) FALSE ))
			)
			(unit_close (ai_vehicle_get_from_spawn_point turret))
			(sleep 300)
			(device_set_position_immediate switch 0)
			(unit_set_current_vitality (ai_vehicle_get_from_starting_location turret) 400 0)
			(f_blip_object switch blip_interface)
			(device_set_power switch 1)
			(sleep_until (> (device_get_position switch) 0)1)
			(cond
				((= turret sq_ice_turret01/pilot)(chud_track_object_with_priority (ai_vehicle_get sq_ice_turret01/pilot) 17))
				((= turret sq_ice_turret02/pilot)(chud_track_object_with_priority (ai_vehicle_get sq_ice_turret02/pilot) 18))
				((= turret sq_ice_turret03/pilot)(chud_track_object_with_priority (ai_vehicle_get sq_ice_turret03/pilot) 19))
				((= turret sq_ice_turret04/pilot)(chud_track_object_with_priority (ai_vehicle_get sq_ice_turret04/pilot) 20))
			)			
		false)		
	1)
)
(script dormant blip_turrets

	(f_blip_object ice_turret_switch03 blip_interface)
	(sleep 15)
	(f_hud_flash_object sc_turret03_obj)
	(f_blip_title sc_turret03_box "WP_CALLOUT_M60_TURRET")
	(device_set_power ice_turret_switch03 1)

	(f_blip_object ice_turret_switch02 blip_interface)
	(sleep 15)
	(f_hud_flash_object sc_turret02_obj)
	(f_blip_title sc_turret02_box "WP_CALLOUT_M60_TURRET")
	(device_set_power ice_turret_switch02 1)

	(f_blip_object ice_turret_switch01 blip_interface)
	(sleep 15)
	(f_hud_flash_object sc_turret01_obj)
	(f_blip_title sc_turret01_box "WP_CALLOUT_M60_TURRET")
	(device_set_power ice_turret_switch01 1)

	(f_blip_object ice_turret_switch04 blip_interface)
	(sleep 15)
	(f_hud_flash_object sc_turret04_obj)
	(f_blip_title sc_turret04_box "WP_CALLOUT_M60_TURRET")
	(device_set_power ice_turret_switch04 1)

)

(script dormant turret_counter
	(sleep_until
		(begin
			(if (!= s_turret_online_old s_turret_online_count)
				(begin
					;(chud_show_screen_objective "")
					(set s_turret_online_old s_turret_online_count)
					(cond
						((= s_turret_online_count 0) 
							(begin
								(f_hud_training player0 ct_turret_online_0)
								(f_hud_training player1 ct_turret_online_0)
								(f_hud_training player2 ct_turret_online_0)
								(f_hud_training player3 ct_turret_online_0)
							)
						)
						((= s_turret_online_count 1) 
							(begin
								(f_hud_training player0 ct_turret_online_1)
								(f_hud_training player1 ct_turret_online_1)
								(f_hud_training player2 ct_turret_online_1)
								(f_hud_training player3 ct_turret_online_1)
							)
						)
						((= s_turret_online_count 2) 
							(begin
								(f_hud_training player0 ct_turret_online_2)
								(f_hud_training player1 ct_turret_online_2)
								(f_hud_training player2 ct_turret_online_2)
								(f_hud_training player3 ct_turret_online_2)
							)
						)
						((= s_turret_online_count 3) 
							(begin
								(f_hud_training player0 ct_turret_online_3)
								(f_hud_training player1 ct_turret_online_3)
								(f_hud_training player2 ct_turret_online_3)
								(f_hud_training player3 ct_turret_online_3)
							)
						)
						((= s_turret_online_count 4) 
							(begin
								(f_hud_training player0 ct_turret_online_4)
								(f_hud_training player1 ct_turret_online_4)
								(f_hud_training player2 ct_turret_online_4)
								(f_hud_training player3 ct_turret_online_4)
							)
						)																		
					)
				)
			)
		false)
	1)												
)

(script static void test_icb_1
	(set g_ice_wave 1)
	(wake ice_cave_turret01)
	(wake ice_cave_turret02)
	(wake ice_cave_turret03)
	(wake ice_cave_turret04)
;*	
	(wake ice_cave_turret_hud01)
	(wake ice_cave_turret_hud02)
	(wake ice_cave_turret_hud03)
	(wake ice_cave_turret_hud04)
*;		
	(sleep 10)
	(wake ice_cave_battle)
	(wake blip_turrets)

)
(script static void test_icb_2
	(set g_ice_wave 2)
	(wake ice_cave_turret01)
	(wake ice_cave_turret02)
	(wake ice_cave_turret03)
	(wake ice_cave_turret04)
;*	
	(wake ice_cave_turret_hud01)
	(wake ice_cave_turret_hud02)
	(wake ice_cave_turret_hud03)
	(wake ice_cave_turret_hud04)
*;		
	(sleep 10)
	(wake ice_cave_battle)
	(wake blip_turrets)		
)
(script static void test_icb_3
	(set g_ice_wave 3)
	(wake ice_cave_turret01)
	(wake ice_cave_turret02)
	(wake ice_cave_turret03)
	(wake ice_cave_turret04)
;*	
	(wake ice_cave_turret_hud01)
	(wake ice_cave_turret_hud02)
	(wake ice_cave_turret_hud03)
	(wake ice_cave_turret_hud04)
*;			
	(sleep 10)
	(wake ice_cave_battle)
	(wake blip_turrets)		
)

(script static void test_icb_4
	(set g_ice_wave 4)
	(wake ice_cave_turret01)
	(wake ice_cave_turret02)
	(wake ice_cave_turret03)
	(wake ice_cave_turret04)
;*	
	(wake ice_cave_turret_hud01)
	(wake ice_cave_turret_hud02)
	(wake ice_cave_turret_hud03)
	(wake ice_cave_turret_hud04)
*;				
	(sleep 10)
	(wake ice_cave_battle)	
)


;*=========================================== ai spawn pool ===================================================
			
			WAVE 1

			(set g_ice_squad01a sq_ice_grunt_quad_00)		
			(set g_ice_squad01b sq_ice_brute_grunt_00)
			(set g_ice_squad01c sq_ice_grunt_quad_01)
			
			(set g_ice_squad03a sq_ice_brute_jackal_00)					
			(set g_ice_squad03b sq_ice_jack_shield_00)
			(set g_ice_squad03c sq_ice_brute_quad_00)


				
			
			WAVE 2
			
			(set g_ice_squad02a sq_ice_jack_shield_01)
			(set g_ice_squad02b sq_ice_elite_jackal_00)
			(set g_ice_squad02c sq_ice_elite_skirmisher_00)
			(set g_ice_squad02d sq_ice_jack_shield_02)	
			
			(set g_ice_squad06a sq_ice_elite_grunt_00)
			(set g_ice_squad06b sq_ice_elite_jackal_02)	
			(set g_ice_squad06c sq_ice_elite_skirmisher_01)		
			(set g_ice_squad06d sq_ice_elite_jackal_03)


			WAVE 3

			(set g_ice_squad01a sq_ice_jetpack_00)
			(set g_ice_squad01b sq_ice_jetpack_01)	


			; rejects
			(set XXXX sq_ice_brute_grunt_01)
			(set XXXX sq_ice_brute_jackal_01)
			(set XXXX sq_ice_hunter_01)
			(set XXXX sq_ice_hunter_00)				
			
;			(if (>= (game_coop_player_count) 3)(set g_ice_squad01d sq_ice_brute_jackal_03))		
;			(if (>= (game_coop_player_count) 3)(set g_ice_squad02d sq_ice_elite_jackal_01))

)
					
	
	
=============================================================================================================*;

(script static void turret_sleep
	(cond 
		((= s_turret_online_count 0) (sleep 600))
		((= s_turret_online_count 1) (sleep 450))
		((= s_turret_online_count 2) (sleep 300))
		((= s_turret_online_count 3) (sleep 150))		
		((= s_turret_online_count 4) (sleep 90))
	)
)

(script dormant ice_cave_battle
	(wake md_110_ice_cave_center)
  (ai_lod_full_detail_actors 15)
  (ai_fast_and_dumb 1)
	(wake ice_cave_garbage_loop)
;	(wake ice_cave_garbage_nuke_loop)  
	(if (= g_ice_wave 0)
		(begin
			(ai_place sq_ice_banshee_00)
		 	(ai_disregard (ai_actors sq_ice_banshee_00) true)
			(ai_place sq_ice_banshee_03)
			(ai_disregard (ai_actors sq_ice_banshee_03) true)
			(set g_ice_squad02a sq_ice_grunt_quad_01)				
			(set g_ice_squad02b sq_ice_grunt_quad_02)
			(phantom02_path 2)
		)
	)						
	(if (= g_ice_wave 0)
		(begin
			(sleep_until 
					(and
						(= b_turret_switch_help true)
						(>= ice_cave_obj_control 50)
					)
			5 900)
			; if the player is making an effort to go to the switches, extend the time
			(if (= b_turret_switch_help false)
				(turret_sleep)
			)
			; remind the player of the objective
			(f_blip_flag nav_halsey_lab blip_defend)			
			;(f_ice_cave_coop_teleport)
			(set g_ice_wave 1)
		)
	)
	(game_save)
	(if (= g_ice_wave	1)
		(begin
	;================= WAVE 1=====================		
			; set eighth mission segment
			(data_mine_set_mission_segment "m60_08_ice_wave_1")
			(print "WAVE 1")
			(wake ice_banshee_spawner)
			(wake ice_banshee_prefer)		
			(wake ice_cave_checkpoint)	
			(begin_random
				(begin
					(set g_ice_squad01a sq_ice_brute_grunt_00)				
					(set g_ice_squad01b sq_ice_brute_grunt_01)
		
					(set phantom01_hold 2)
					(phantom01_path 2)
					(phantom01_vehicle sq_ice_wraith_00 none)
					(wake wave01_phantom01)
					(wake wave01_phantom01_clean)	
					(sleep (* 30 (random_range 3 7)))														
				)			
				(begin
					(set g_ice_squad03a sq_ice_jack_shield_00)					
					(set g_ice_squad03b sq_ice_jack_shield_01)									
					
					(set phantom03_hold 2)			
					(phantom03_path 3)
					(wake wave01_phantom03)
					(wake wave01_phantom03_clean)	
					(sleep (* 30 (random_range 3 7)))			
				)
				(begin
					(set g_ice_squad05a sq_ice_brute_grunt_02)
					(set g_ice_squad05b sq_ice_jack_shield_02)	
	
					(set phantom05_hold 2)
					(phantom05_path 1)	
					(wake wave01_phantom05)
					(sleep (* 30 (random_range 3 7)))			
				)
			)
			(set g_ice_cave_dialog 1)							
			(sleep_until 
				(and
					(< (ai_living_count sq_ice_phantom01) 1)
					(< (ai_living_count sq_ice_phantom03) 1)
					(< (ai_living_count sq_ice_phantom05) 1)
					(<= (ai_living_count gr_ice_cave) 3)
				)
			5)
			(set g_drop_occupied01 false)
			(set g_drop_occupied02 false)
			(set g_drop_occupied03 false)
			(if (= (game_difficulty_get) easy)
				(set g_ice_wave 4)
				(set g_ice_wave 2)
			)			
			(game_save)						
		)
	)

	;================= WAVE 2=====================
	(if (= g_ice_wave	2)
		(begin	
			; set ninth mission segment
			(data_mine_set_mission_segment "m60_09_ice_wave_2")
			(print "WAVE 2")
			(turret_sleep)			
			(wake md_110_ice_cave_sides)
			(variable_flush)
			;(phantom07_vehicle sq_ice_engineer_00 none)			
			(begin_random
				(begin
					(set g_ice_squad02a sq_ice_jetpack_00)				
					(set g_ice_squad02b sq_ice_jetpack_01)
					(set phantom02_hold 2)
					(phantom02_path 1)
					(phantom02_vehicle sq_ice_ghost_00 sq_ice_ghost_01)
					(wake wave02_phantom02)
					(sleep (* 30 (random_range 3 7)))											
				)			
				(begin
					(set g_ice_squad04a sq_ice_elite_jackal_00)					
					(set g_ice_squad04b sq_ice_elite_jackal_01)					
					(set phantom04_hold 2)			
					(phantom04_path 3)
					(wake wave02_phantom04)
					(wake wave02_phantom04_clean)
					(sleep (* 30 (random_range 3 7)))							
				)
				(begin
					(set g_ice_squad06a sq_ice_elite_grunt_00)
					(set g_ice_squad06b sq_ice_elite_grunt_02)
										
					(set phantom06_hold 2)
					(phantom06_path 2)	
					(wake wave02_phantom06)
					(wake wave02_phantom06_clean)
					(sleep (* 30 (random_range 3 7)))							
				)
			)
	(set g_ice_cave_dialog 2)										
			(sleep_until 
				(and
					(< (ai_living_count sq_ice_phantom02) 1)
					(< (ai_living_count sq_ice_phantom04) 1)
					(< (ai_living_count sq_ice_phantom06) 1)
					(<= (ai_living_count gr_ice_cave) 3)
				)
			5)
			(set g_music_m60_10 3)
			(set g_drop_occupied01 false)
			(set g_drop_occupied02 false)
			(set g_drop_occupied03 false)				
			(if 
				(or
					(= (game_difficulty_get) legendary)
					(> (game_coop_player_count) 2)
				)	
				(set g_ice_wave 3) 
				(set g_ice_wave 4)
			)
		(game_save)												
		)
	)

	(if (= g_ice_wave	3)
		(begin
			; set tenth mission segment
			(data_mine_set_mission_segment "m60_10_ice_wave_3")
			(print "WAVE 3")		
			(turret_sleep)					
			(variable_flush)
			(set g_music_m60_11 1)
			;(phantom07_vehicle sq_ice_engineer_00 none)			
			(begin_random
					(begin
						(set g_ice_squad01a sq_ice_hunter_00)				
						(set g_ice_squad01b sq_ice_hunter_01)
						(phantom01_path 2)
						(wake wave03_phantom01)
						(sleep (* 30 (random_range 3 7)))															
					)			
					(begin
						(set g_ice_squad03a sq_ice_jack_shield_04)					
						(set g_ice_squad03b sq_ice_brute_quad_03)									
								
						(phantom03_path 3)
						(phantom03_vehicle sq_ice_ghost_02 none)
						(wake wave03_phantom03)
						(sleep (* 30 (random_range 3 7)))				
					)
					(begin
						(set g_ice_squad05a sq_ice_elite_jackal_02)
						(set g_ice_squad05b sq_ice_elite_skirmisher_02)	
		
						(phantom05_path 1)
						(phantom05_vehicle sq_ice_ghost_03 none)	
						(wake wave03_phantom05)
						(sleep (* 30 (random_range 3 7)))					
					)
				)
				(wake wave03_music)
				(sleep_until 
					(and
						(< (ai_living_count sq_ice_phantom01) 1)
						(< (ai_living_count sq_ice_phantom03) 1)
						(< (ai_living_count sq_ice_phantom05) 1)
						(<= (ai_living_count gr_ice_cave) 3)
					)
				5)
			(set g_drop_occupied01 false)
			(set g_drop_occupied02 false)
			(set g_drop_occupied03 false)					
		(set g_ice_wave 4)
		(game_save)
			
		)
	)
	;================= WAVE 4=====================

	(if (= g_ice_wave	4)
		(begin
			; set eleventh mission segment
			(data_mine_set_mission_segment "m60_11_ice_wave_4")
			(print "WAVE 4")
			(set g_ice_cave_dialog 3)			
			(turret_sleep)				
			(variable_flush)		
			(set g_ice_squad07a sq_ice_big_boss_flak)								
			(set g_ice_squad07b sq_ice_big_boss_3_elite)
			(set g_ice_squad07c sq_ice_big_boss_general)
			(set g_ice_squad07d sq_ice_engineer_00)								
			;(phantom07_vehicle sq_ice_engineer_00 none)			
			(phantom07_path 4)
									
			(phantom02_path 1)
			(if (= s_special_elite 3)
				(begin
					(set s_special_elite_ticks 1200)
					(print "SPECIAL ELITE DROPPING IN ICE CAVE")
					(set g_ice_squad02a special_elite03)
				)
			)	
			(phantom02_vehicle sq_ice_wraith_01 none)
			
			(phantom04_path 3)			
			(phantom04_vehicle sq_ice_wraith_02 none)
			(wake wraith_script02)
			(wake wraith_script03)		

			(sleep_until
				(and 
					(or
						(< (ai_living_count sq_ice_phantom07) 1)
						(= b_dropship07_unload true)
					)
					(or
						(= b_dropship01_unload true)
						(< (ai_living_count sq_ice_phantom01) 1)
					)
					(or
						(= b_dropship04_unload true)
						(< (ai_living_count sq_ice_phantom04) 1)
					)					
				)
			5)
			(ai_disregard (ai_actors gr_spartans) true)			
			(set g_drop_occupied01 false)
			(set g_drop_occupied02 false)
			(set g_drop_occupied03 false)	
			(wake wave04_music)								
			(sleep_until (<= (ai_living_count gr_ice_cave) 3) 5)
			(sleep 150)
			(set g_music_m60_14 1)											
			(set g_ice_wave 5)
		)
	)
	(if (= (game_difficulty_get) legendary) 
		(begin
			(wake v)
			(object_create dc_v)
		)
	)
	(wake end_level)	
			
)

(script command_script cs_engineer_ice_movement
	;(cs_ignore_obstacles true)
	;(cs_fly_to ps_sword_atrium/p2)
	;(object_set_physics (ai_get_object sq_security06/engineer) false)		
	;(cs_fly_to ps_sword_atrium/p3)
	;(object_set_physics (ai_get_object sq_security06/engineer) true)
	(cs_fly_to ps_ice_banshee_exit/p4)		
	(cs_face_player true)	
	(sleep_forever)
)

(script dormant wave03_music
	(sleep_until
		(and
			(< (ai_living_count sq_ice_phantom01) 1)
			(< (ai_living_count sq_ice_phantom03) 1)
			(< (ai_living_count sq_ice_phantom05) 1)
		)
	5)
	(set g_music_m60_11 2)
)

(script dormant wave04_music
	(sleep_until (<= (ai_living_count gr_ice_cave) 5) 5)
	(set g_music_m60_13 2)
)

(global boolean v_mode false)

(script dormant v
	(sleep_until (= (device_get_position dc_v) 1)5)
 	(set g_music_m60_14 2)
	(wake m60_music_15)
	(f_unblip_object dc_halsey_lab)
	(device_set_power dc_halsey_lab 0)
	(prepare_to_switch_to_zone_set secret_set)
	(sleep 150)
	(switch_zone_set secret_set)
	(ai_erase gr_spartans)
	(object_create v_door01)
	(sleep_forever ice_cave_turret01)
	(sleep_forever ice_cave_turret02)
	(sleep_forever ice_cave_turret03)
	(sleep_forever ice_cave_turret04)			
	(f_unblip_object ice_turret_switch01)
	(f_unblip_object ice_turret_switch02)
	(f_unblip_object ice_turret_switch03)			
	(f_unblip_object ice_turret_switch04)
	(unblip_all)
	(chud_track_object (ai_vehicle_get sq_ice_turret01/pilot) FALSE )
	(chud_track_object (ai_vehicle_get sq_ice_turret02/pilot) FALSE )
	(chud_track_object (ai_vehicle_get sq_ice_turret03/pilot) FALSE )
	(chud_track_object (ai_vehicle_get sq_ice_turret04/pilot) FALSE )
	(game_save)	
	(sleep_until (volume_test_players tv_e_v)5)
	(device_set_power v_door 1)
	(device_set_position v_door 1)
	(object_create dc_v_end)
	(object_create v_door02)
	(object_create v_door03)
	(object_create term_v01)
	(object_create term_v02)
	(object_create term_v03)
	(object_create term_v04)
	(object_create term_v05)
	(object_create term_v06)
	(object_create term_v07)
	(object_create_folder sc_easter_egg)		
	(sleep 7)
	(ai_place v_guy01)
	(sleep 7)
	(ai_place v_guy02)
	(sleep 7)
	(ai_place v_guy03)
	(sleep 7)
	(ai_place v_guy04)
	(sleep 7)
	(ai_place v_guy05)
	(sleep 7)
	(ai_place v_guy06)
	(sleep 7)
	(ai_place v_guy07)
	(wake v_cin)
	(sleep_forever ice_cave_checkpoint)
	; hacker, I see you.
	(sleep_until
		(begin
			(cond
				((volume_test_object tv_v player0) 
					(begin
						(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player0)
						(object_teleport player0 cf_v00)
						(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player0)
						(unit_add_equipment player0 v_profile TRUE FALSE)
						(object_cannot_die player0 true)
						(game_safe_to_respawn false player0)
						(set v_mode true)
						(if (= g_music_m60_15 0)(set g_music_m60_15 1))	
						
						(submit_incident_with_cause_player "tribute_room_achieve" player0)
					)
				)
				((volume_test_object tv_v player1) 
					(begin
						(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player1)
						(object_teleport player1 cf_v01)
						(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player1)
						(unit_add_equipment player1 v_profile TRUE FALSE)
						(object_cannot_die player1 true)
						(game_safe_to_respawn false player1)
						(set v_mode true)						
						(if (= g_music_m60_15 0)(set g_music_m60_15 1))	
						
						(submit_incident_with_cause_player "tribute_room_achieve" player1)
					)
				)
				((volume_test_object tv_v player2) 
					(begin
						(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player2)
						(object_teleport player2 cf_v02)
						(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player2)
						(unit_add_equipment player2 v_profile TRUE FALSE)
						(object_cannot_die player2 true)
						(game_safe_to_respawn false player2)
						(set v_mode true)						
						(if (= g_music_m60_15 0)(set g_music_m60_15 1))

						(submit_incident_with_cause_player "tribute_room_achieve" player2)
					)
				)
				((volume_test_object tv_v player3) 
					(begin
						(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player3)
						(object_teleport player3 cf_v03)
						(effect_new_on_ground "objects\characters\spartans\fx\coop_teleport\coop_teleport.effect" player3)
						(unit_add_equipment player3 v_profile TRUE FALSE)
						(object_cannot_die player3 true)
						(game_safe_to_respawn false player3)
						(set v_mode true)						
						(if (= g_music_m60_15 0)(set g_music_m60_15 1))
						
						(submit_incident_with_cause_player "tribute_room_achieve" player3)
					)
				)
			)
		false)
	5)					
)

(script dormant v_cin
	(sleep_until (= (device_get_position dc_v_end) 1)5)
	(set g_music_m60_15 2)
	(fade_out 0 0 0 300)
	(sleep 300)
	(cinematic_enter 060lc_the_package true)	
	(object_destroy dc_v_end)
	(object_destroy v_door01)
	(object_destroy v_door02)
	(object_destroy v_door03)
	(object_destroy_folder sc_easter_egg)					
	(if (not (editor_mode))
		(m60_cin_end))
)

(script static void variable_flush

	(set g_ice_squad01a none)					
	(set g_ice_squad01b none)
	(set g_ice_squad01c none)
	(set g_ice_squad01d none)
	(set g_ice_squad02a none)					
	(set g_ice_squad02b none)
	(set g_ice_squad02c none)
	(set g_ice_squad02d none)
	(set g_ice_squad03a none)					
	(set g_ice_squad03b none)
	(set g_ice_squad03c none)
	(set g_ice_squad03d none)						
	(set g_ice_squad04a none)					
	(set g_ice_squad04b none)
	(set g_ice_squad04c none)
	(set g_ice_squad04d none)
	(set g_ice_squad05a none)					
	(set g_ice_squad05b none)
	(set g_ice_squad05c none)
	(set g_ice_squad05d none)
	(set g_ice_squad06a none)					
	(set g_ice_squad06b none)
	(set g_ice_squad06c none)
	(set g_ice_squad06d none)
)							
(global boolean g_wave01_01 false)
(global boolean g_wave01_03 false)
(global boolean g_wave01_05 false)
(global boolean g_wave02_02 false)
(global boolean g_wave02_04 false)
(global boolean g_wave02_06 false)
(script dormant wave01_phantom01

		(sleep_until (>= phantom01_progress 2)5)
		(sleep_until (< (ai_living_count gr_ice_cave) 10) 5)
		(if (<= g_music_m60_08 2)(set g_music_m60_08 3))		
		(set g_ice_squad01c sq_ice_grunt_quad_00)							
		(set g_ice_squad01d sq_ice_brute_quad_00)				
		(chute_drop_add sq_ice_phantom01/pilot g_ice_squad01c false)
		(chute_drop_add sq_ice_phantom01/pilot g_ice_squad01d true)
		(sleep 150)
		(set g_wave01_01 true)
		(wake wraith_script01)	
)

(script dormant wave01_phantom03

		(sleep_until (>= phantom03_progress 2)5)
		(sleep_until (= g_wave01_01 true)5)
		(sleep 90)				
		(sleep_until (<= (ai_living_count gr_ice_cave) 7) 5)
		(set g_ice_squad03c sq_ice_brute_jackal_00)						
		(set g_ice_squad03d sq_ice_brute_quad_01)
		(chute_drop_add sq_ice_phantom03/pilot g_ice_squad03c false)
		(chute_drop_add sq_ice_phantom03/pilot g_ice_squad03d true)
		(sleep 150)		
		(set g_wave01_03 true)						
	
)
(script dormant wave01_phantom05

		(sleep_until (>= phantom05_progress 2)5)
		(sleep_until (= g_wave01_03 true)5)
		(sleep 90)					
		(sleep_until (<= (ai_living_count gr_ice_cave) 5) 5)	
		(set g_ice_squad05c sq_ice_brute_jackal_01)
		(set g_ice_squad05d sq_ice_brute_quad_02)				
		(chute_drop_add sq_ice_phantom05/pilot g_ice_squad05c false)
		(chute_drop_add sq_ice_phantom05/pilot g_ice_squad05d true)
		(sleep 90)
		(set g_music_m60_08 4)	
		(set g_wave01_05 true)				
)

(script dormant wave01_phantom01_clean
	(sleep_until
		(begin
			(ai_cleanup tv_ice_cave_out_of_bounds03 sq_ice_brute_grunt_00)
			(ai_cleanup tv_ice_cave_out_of_bounds03 sq_ice_brute_grunt_01)		
			(ai_cleanup tv_ice_cave_out_of_bounds03 sq_ice_grunt_quad_00)
			(ai_cleanup tv_ice_cave_out_of_bounds03 sq_ice_brute_quad_00)
		(>= g_ice_wave 2))
	30)
)
  
(script dormant wave01_phantom03_clean
	(sleep_until
		(begin
			(ai_cleanup tv_ice_cave_out_of_bounds01 sq_ice_jack_shield_00)
			(ai_cleanup tv_ice_cave_out_of_bounds02 sq_ice_jack_shield_00)		
			(ai_cleanup tv_ice_cave_out_of_bounds01 sq_ice_jack_shield_01)
			(ai_cleanup tv_ice_cave_out_of_bounds02 sq_ice_jack_shield_01)
			(ai_cleanup tv_ice_cave_out_of_bounds01 sq_ice_brute_jackal_00)
			(ai_cleanup tv_ice_cave_out_of_bounds02 sq_ice_brute_jackal_00)
			(ai_cleanup tv_ice_cave_out_of_bounds01 sq_ice_brute_quad_01)
			(ai_cleanup tv_ice_cave_out_of_bounds02 sq_ice_brute_quad_01)	
		(>= g_ice_wave 2))
	30)
)

(script dormant wave02_phantom02

		(sleep_until (>= phantom02_progress 2)5)	
		(sleep_until (< (ai_living_count gr_ice_cave) 10) 5)
		(set g_ice_squad02c sq_ice_elite_skirmisher_00)				
		(chute_drop_add sq_ice_phantom02/pilot g_ice_squad02c true)
		(set g_wave02_02 true)			
			
)

(script dormant wave02_phantom04

		(sleep_until (>= phantom04_progress 2)5)
		(sleep_until (= g_wave02_02 true)5)						
		(sleep_until (< (ai_living_count gr_ice_cave) 7) 5)
		(set g_music_m60_09 2)
		(set g_music_m60_10 2)
		(set g_ice_squad04c sq_ice_jack_shield_03)			
		(chute_drop_add sq_ice_phantom04/pilot g_ice_squad04c true)	
		(set g_wave02_04 true)		
)
(script dormant wave02_phantom06
		(sleep_until (>= phantom06_progress 2)5)
		(sleep_until (= g_wave02_04 true)5)				
		(sleep_until (< (ai_living_count gr_ice_cave) 5) 5)
		(set g_ice_squad06c sq_ice_elite_skirmisher_01)				
		(chute_drop_add sq_ice_phantom06/pilot g_ice_squad06c true)			
		
)

(script dormant wave02_phantom04_clean
	(sleep_until
		(begin
			(ai_cleanup tv_ice_cave_out_of_bounds01 sq_ice_elite_jackal_00)
			(ai_cleanup tv_ice_cave_out_of_bounds02 sq_ice_elite_jackal_00)
			(ai_cleanup tv_ice_cave_out_of_bounds01 sq_ice_elite_jackal_01)
			(ai_cleanup tv_ice_cave_out_of_bounds02 sq_ice_elite_jackal_01)		
			(ai_cleanup tv_ice_cave_out_of_bounds01 sq_ice_jack_shield_03)
			(ai_cleanup tv_ice_cave_out_of_bounds02 sq_ice_jack_shield_03)
		(>= g_ice_wave 3))
	30)
)

(script dormant wave02_phantom06_clean
	(sleep_until
		(begin
			(ai_cleanup tv_ice_cave_out_of_bounds03 sq_ice_elite_skirmisher_01)		
			(ai_cleanup tv_ice_cave_out_of_bounds03 sq_ice_elite_grunt_00)
			(ai_cleanup tv_ice_cave_out_of_bounds03 sq_ice_elite_grunt_02)
		(>= g_ice_wave 3))
	30)
)

(script dormant wave03_phantom01
		(sleep_until (<= (ai_strength gr_ice_cave) 0.5) 5)
)
(script dormant wave03_phantom03
		(sleep_until (<= (ai_strength gr_ice_cave) 0.5) 5)
)
(script dormant wave03_phantom05
		(sleep_until (<= (ai_strength gr_ice_cave) 0.5) 5)
)

(script dormant wave03_phantom03_clean
	(sleep_until
		(begin
			(ai_cleanup tv_ice_cave_out_of_bounds01 sq_ice_jack_shield_04)
			(ai_cleanup tv_ice_cave_out_of_bounds02 sq_ice_jack_shield_04)
			(ai_cleanup tv_ice_cave_out_of_bounds01 sq_ice_brute_quad_03)
			(ai_cleanup tv_ice_cave_out_of_bounds02 sq_ice_brute_quad_03)		
		(>= g_ice_wave 4))
	30)
)			
(script dormant end_level
	(game_save)		
	(f_hud_obj_complete)
	(sleep_until (> (device_get_position dc_halsey_lab) 0) 5)
	(cinematic_enter 060lc_the_package true)
	(sleep_forever ice_cave_turret01)
	(sleep_forever ice_cave_turret02)
	(sleep_forever ice_cave_turret03)
	(sleep_forever ice_cave_turret04)			
	(f_unblip_object dc_halsey_lab)
	(sleep 1)
	(if (not (editor_mode))
		(m60_cin_end))
)
(script static void hunter_load_test
	(ai_place test_phantom)
	(ai_place sq_ice_hunter_00)
	(ai_vehicle_enter_immediate sq_ice_hunter_00 test_phantom "phantom_pc")
	(sleep 60)	
	(vehicle_unload test_phantom "phantom_pc")
	(sleep 90)
)

(script dormant ice_cave_garbage_loop
	(sleep_until
		(begin
			(add_recycling_volume tv_ice_cave_garbage_floor 0 0)	
  		(sleep 10)
      (add_recycling_volume_by_type tv_ice_cave_garbage_all 0 30 16371)
 			(sleep 300)
      (sleep 10)
			(add_recycling_volume tv_ice_cave_garbage_floor 0 0)	
  		(sleep 10)      
      (add_recycling_volume_by_type tv_ice_cave_garbage_all 30 10 12)
 			(sleep 300)
 			(sleep 1)
 			(add_recycling_volume tv_ice_cave_garbage_floor 0 0)		
		FALSE)
	30)
)

(script dormant wraith_script01
	(wake wraith01_kill)
	(sleep_until (= b_dropship01_unload true)5)
	(cs_run_command_script sq_ice_wraith_00/pilot ice_wraith_shell00)
)
(script dormant wraith01_kill
	(sleep_until (<= (object_get_health sq_ice_wraith_00) 0)5)
	(set g_music_m60_08 4)
)
(script dormant wraith_script02
	(sleep_until (= b_dropship02_unload true)5)
	(cs_run_command_script sq_ice_wraith_01/pilot ice_wraith_shell02)
)
(script dormant wraith_script03
	(sleep_until (= b_dropship04_unload true)5)
	(cs_run_command_script sq_ice_wraith_02/pilot ice_wraith_shell01)
)

(script dormant ice_banshee_spawner
	(sleep_until
		(begin
			(sleep_until (< (ai_living_count gr_ice_banshees) 2)5)
			(sleep (random_range 300 450))
			(ice_cave_banshee_cleanup)			
			(begin_random_count 1
				(if 
					(and
						(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_ice_banshee_00/pilot)) 0)
						(< (ai_living_count sq_ice_banshee_00) 1)
					)
					(begin
						(ai_place sq_ice_banshee_00)
						(ai_disregard (ai_actors sq_ice_banshee_00) true)
					)
				)
				(if 					
					(and
						(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_ice_banshee_01/pilot)) 0)
						(< (ai_living_count sq_ice_banshee_01) 1)
					)
					(begin
						(ai_place sq_ice_banshee_01)
						(ai_disregard (ai_actors sq_ice_banshee_01) true)
					)
				)
				(if 					
					(and
						(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_ice_banshee_02/pilot)) 0)
						(< (ai_living_count sq_ice_banshee_02) 1)
					)
					(begin
						(ai_place sq_ice_banshee_02)
						(ai_disregard (ai_actors sq_ice_banshee_02) true)
					)
				)
				(if 					
					(and
						(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_ice_banshee_03/pilot)) 0)
						(< (ai_living_count sq_ice_banshee_03) 1)
					)
					(begin
						(ai_place sq_ice_banshee_03)
						(ai_disregard (ai_actors sq_ice_banshee_03) true)
					)
				)
				(if 					
					(and
						(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_ice_banshee_04/pilot)) 0)
						(< (ai_living_count sq_ice_banshee_04) 1)
					)
					(begin
						(ai_place sq_ice_banshee_04)
						(ai_disregard (ai_actors sq_ice_banshee_04) true)
					)
				)
				(if 					
					(and
						(<= (object_get_health (ai_vehicle_get_from_spawn_point sq_ice_banshee_05/pilot)) 0)
						(< (ai_living_count sq_ice_banshee_05) 1)
					)
					(begin
						(ai_place sq_ice_banshee_05)
						(ai_disregard (ai_actors sq_ice_banshee_05) true)
					)
				)																						
			)
		(>= g_ice_wave 4))
	)
)

(script dormant ice_banshee_prefer
	(sleep_until
		(begin
			(if 	
				(and
					(volume_test_players tv_banshee_player_safe)
					(not (f_players_flying))
				)
				(ai_prefer_target_ai gr_ice_banshees gr_spartans TRUE)
				(ai_prefer_target_ai gr_ice_banshees gr_spartans FALSE)
			)
		false)
	)
)

(script static void ice_cave_banshee_cleanup
	(cond
		((and
			(> (object_get_health (ai_vehicle_get_from_spawn_point sq_ice_banshee_00/pilot)) 0)
			(> (objects_distance_to_object (players) (ai_vehicle_get_from_spawn_point sq_ice_banshee_00/pilot))10)
			(not (vehicle_test_seat (ai_vehicle_get_from_spawn_point sq_ice_banshee_00/pilot) ""))
		)	(begin
				(print "DESTROYING BANSHEE00")
				(object_destroy (ai_vehicle_get_from_spawn_point sq_ice_banshee_00/pilot))
			)
		)
		((and
			(> (object_get_health (ai_vehicle_get_from_spawn_point sq_ice_banshee_01/pilot)) 0)
			(> (objects_distance_to_object (players) (ai_vehicle_get_from_spawn_point sq_ice_banshee_01/pilot))10)		
			(not (vehicle_test_seat (ai_vehicle_get_from_spawn_point sq_ice_banshee_01/pilot) ""))
		)	(begin
				(print "DESTROYING BANSHEE01")
				(object_destroy (ai_vehicle_get_from_spawn_point sq_ice_banshee_01/pilot))
			)
		)
		((and
			(> (object_get_health (ai_vehicle_get_from_spawn_point sq_ice_banshee_02/pilot)) 0)
			(> (objects_distance_to_object (players) (ai_vehicle_get_from_spawn_point sq_ice_banshee_02/pilot))10)						
			(not (vehicle_test_seat (ai_vehicle_get_from_spawn_point sq_ice_banshee_02/pilot) ""))
		)	(begin
				(print "DESTROYING BANSHEE02")
				(object_destroy (ai_vehicle_get_from_spawn_point sq_ice_banshee_02/pilot))
			)
		)
		((and
			(> (object_get_health (ai_vehicle_get_from_spawn_point sq_ice_banshee_03/pilot)) 0)
			(> (objects_distance_to_object (players) (ai_vehicle_get_from_spawn_point sq_ice_banshee_03/pilot))10)						
			(not (vehicle_test_seat (ai_vehicle_get_from_spawn_point sq_ice_banshee_03/pilot) ""))
		)	(begin
				(print "DESTROYING BANSHEE03")
				(object_destroy (ai_vehicle_get_from_spawn_point sq_ice_banshee_03/pilot))
			)
		)
		((and
			(> (object_get_health (ai_vehicle_get_from_spawn_point sq_ice_banshee_04/pilot)) 0)
			(> (objects_distance_to_object (players) (ai_vehicle_get_from_spawn_point sq_ice_banshee_04/pilot))10)				
			(not (vehicle_test_seat (ai_vehicle_get_from_spawn_point sq_ice_banshee_04/pilot) ""))
		)	(begin
				(print "DESTROYING BANSHEE04")
				(object_destroy (ai_vehicle_get_from_spawn_point sq_ice_banshee_04/pilot))
			)
		)
		((and
			(> (object_get_health (ai_vehicle_get_from_spawn_point sq_ice_banshee_05/pilot)) 0)
			(> (objects_distance_to_object (players) (ai_vehicle_get_from_spawn_point sq_ice_banshee_05/pilot))7)				
			(not (vehicle_test_seat (ai_vehicle_get_from_spawn_point sq_ice_banshee_05/pilot) ""))
		)
			(begin
				(print "DESTROYING BANSHEE05")
				(object_destroy (ai_vehicle_get_from_spawn_point sq_ice_banshee_05/pilot))
			)
		)																				
	) 
)

(script static boolean f_players_flying
	(if
		(or						
			(= (unit_in_vehicle_type player0 26) TRUE)						
			(= (unit_in_vehicle_type player1 26) TRUE)						
			(= (unit_in_vehicle_type player2 26) TRUE)					
			(= (unit_in_vehicle_type player3 26) TRUE)									
		)
	true)
)

(script dormant ice_cave_checkpoint
	(sleep_until
		(begin
			(print "SAVING")		
			(game_save_no_timeout)
			(print "SAVED")
			(sleep 900)
		(= g_ice_wave 5))
	)
)

(global short c_front 0)

(script static void front_change
	(print "FRONT SWAP!")
	(if (= c_front 0)
		(set c_front 1)
		(set c_front 0)
	)
)


(script command_script cs_stay_in_turret
	(cs_shoot true)
	(cs_enable_targeting true)
	(cs_enable_moving true)
	(cs_enable_looking true)
	(cs_abort_on_damage FALSE)	
	(cs_abort_on_alert FALSE)
	(sleep_until (<= (ai_living_count ai_current_actor) 0))
)

(script static void (phantom01_vehicle (ai l_veh01) (ai l_veh02))
	(if (= l_veh02 none)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship01
											"single"
											l_veh01
											none
			)
		)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship01
											"double"
											l_veh01
											l_veh02
			)
		)
	)
)


(script static void (phantom02_vehicle (ai l_veh01) (ai l_veh02))
	(if (= l_veh02 none)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship02
											"single"
											l_veh01
											none
			)
		)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship02
											"double"
											l_veh01
											l_veh02
			)
		)
	)
)

(script static void (phantom03_vehicle (ai l_veh01) (ai l_veh02))
	(if (= l_veh02 none)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship03
											"single"
											l_veh01
											none
			)
		)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship03
											"double"
											l_veh01
											l_veh02
			)
		)
	)
)
(script static void (phantom04_vehicle (ai l_veh01) (ai l_veh02))
	(if (= l_veh02 none)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship04
											"single"
											l_veh01
											none
			)
		)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship04
											"double"
											l_veh01
											l_veh02
			)
		)
	)
)
(script static void (phantom05_vehicle (ai l_veh01) (ai l_veh02))
	(if (= l_veh02 none)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship05
											"single"
											l_veh01
											none
			)
		)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship05
											"double"
											l_veh01
											l_veh02
			)
		)
	)
)
(script static void (phantom06_vehicle (ai l_veh01) (ai l_veh02))
	(if (= l_veh02 none)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship06
											"single"
											l_veh01
											none
			)
		)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship06
											"double"
											l_veh01
											l_veh02
			)
		)
	)
)

(script static void (phantom07_vehicle (ai l_veh01) (ai l_veh02))
	(if (= l_veh02 none)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship07
											"single"
											l_veh01
											none
			)
		)
		(begin
			(f_load_phantom_cargo
											g_ice_dropship07
											"double"
											l_veh01
											l_veh02
			)
		)
	)
)

(script static void (chute_drop_add
										(vehicle phantom)
										(ai squad)
										(boolean end)
										)

	(cond 
		((= phantom sq_ice_phantom01/pilot) (if end (set phantom01_hold 0)))
		((= phantom sq_ice_phantom02/pilot) (if end (set phantom02_hold 0)))
		((= phantom sq_ice_phantom03/pilot) (if end (set phantom03_hold 0)))
		((= phantom sq_ice_phantom04/pilot) (if end (set phantom04_hold 0)))
		((= phantom sq_ice_phantom05/pilot) (if end (set phantom05_hold 0)))
		((= phantom sq_ice_phantom06/pilot) (if end (set phantom06_hold 0)))
		((= phantom sq_ice_phantom07/pilot) (if end (set phantom07_hold 0)))		
	)																				
)

(global short phantom01_progress 0)
(global short phantom02_progress 0)
(global short phantom03_progress 0)
(global short phantom04_progress 0)
(global short phantom05_progress 0)
(global short phantom06_progress 0)
(global short phantom07_progress 0)
									
(script static void (chute_drop
										(vehicle phantom)
										)
	(cond 
		((= phantom sq_ice_phantom01/pilot)
			(begin
					(object_set_phantom_power phantom TRUE)
					(if 
						  (!= g_ice_squad01a NONE)
						(begin
							(ai_place g_ice_squad01a)
							(ai_vehicle_enter_immediate g_ice_squad01a phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom01_progress 1)
							(if (= phantom01_hold 1)
								(sleep_until (= phantom01_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 							
						  (!= g_ice_squad01b NONE)
						(begin
							(ai_place g_ice_squad01b)
							(ai_vehicle_enter_immediate g_ice_squad01b phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom01_progress 2)
							(if (= phantom01_hold 2)
								(sleep_until (= phantom01_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 				
							(!= g_ice_squad01c NONE)
						(begin							
							(ai_place g_ice_squad01c)
							(ai_vehicle_enter_immediate g_ice_squad01c phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom01_progress 3)
							(if (= phantom01_hold 3)
								(sleep_until (= phantom01_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 
							(!= g_ice_squad01d NONE)
						(begin							
							(ai_place g_ice_squad01d)
							(ai_vehicle_enter_immediate g_ice_squad01d phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom01_progress 4)
							(if (= phantom01_hold 4)
								(sleep_until (= phantom01_hold 0)5)
								(sleep 90)
							)							
						)
					)
					
					(object_set_phantom_power phantom FALSE)
			)
		)		
		((= phantom sq_ice_phantom02/pilot) 			
			(begin
					(object_set_phantom_power phantom TRUE)
					(if 
						  (!= g_ice_squad02a NONE)
						(begin
							(ai_place g_ice_squad02a)
							(ai_vehicle_enter_immediate g_ice_squad02a phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom02_progress 1)
							(if (= phantom02_hold 1)
								(sleep_until (= phantom02_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 							
						  (!= g_ice_squad02b NONE)
						(begin
							(ai_place g_ice_squad02b)
							(ai_vehicle_enter_immediate g_ice_squad02b phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom02_progress 2)
							(if (= phantom02_hold 2)
								(sleep_until (= phantom02_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 				
							(!= g_ice_squad02c NONE)
						(begin							
							(ai_place g_ice_squad02c)
							(ai_vehicle_enter_immediate g_ice_squad02c phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom02_progress 3)
							(if (= phantom02_hold 3)
								(sleep_until (= phantom02_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 
							(!= g_ice_squad02d NONE)
						(begin							
							(ai_place g_ice_squad02d)
							(ai_vehicle_enter_immediate g_ice_squad02d phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom02_progress 4)
							(if (= phantom02_hold 4)
								(sleep_until (= phantom02_hold 0)5)
								(sleep 90)
							)							
						)
					)
					;(set g_ice_squad02a NONE)
					;(set g_ice_squad02b NONE)		
					;(set g_ice_squad02c NONE)		
					;(set g_ice_squad02d NONE)							
					(object_set_phantom_power phantom FALSE)
			)
		)
		((= phantom sq_ice_phantom03/pilot) 			
			(begin
					(object_set_phantom_power phantom TRUE)
					(if 
						  (!= g_ice_squad03a NONE)
						(begin
							(ai_place g_ice_squad03a)
							(ai_vehicle_enter_immediate g_ice_squad03a phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom03_progress 1)
							(if (= phantom03_hold 1)
								(sleep_until (= phantom03_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 							
						  (!= g_ice_squad03b NONE)
						(begin
							(ai_place g_ice_squad03b)
							(ai_vehicle_enter_immediate g_ice_squad03b phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom03_progress 2)
							(if (= phantom03_hold 2)
								(sleep_until (= phantom03_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 				
							(!= g_ice_squad03c NONE)
						(begin							
							(ai_place g_ice_squad03c)
							(ai_vehicle_enter_immediate g_ice_squad03c phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom03_progress 3)
							(if (= phantom03_hold 3)
								(sleep_until (= phantom03_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 
							(!= g_ice_squad03d NONE)
						(begin							
							(ai_place g_ice_squad03d)
							(ai_vehicle_enter_immediate g_ice_squad03d phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom03_progress 4)
							(if (= phantom03_hold 4)
								(sleep_until (= phantom03_hold 0)5)
								(sleep 90)
							)							
						)
					)
					;(set g_ice_squad03a NONE)
					;(set g_ice_squad03b NONE)		
					;(set g_ice_squad03c NONE)		
					;(set g_ice_squad03d NONE)							
					(object_set_phantom_power phantom FALSE)
			)
		)
		((= phantom sq_ice_phantom04/pilot) 			
			(begin
					(object_set_phantom_power phantom TRUE)
					(if 
						  (!= g_ice_squad04a NONE)
						(begin
							(ai_place g_ice_squad04a)
							(ai_vehicle_enter_immediate g_ice_squad04a phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom04_progress 1)
							(if (= phantom04_hold 1)
								(sleep_until (= phantom04_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 							
						  (!= g_ice_squad04b NONE)
						(begin
							(ai_place g_ice_squad04b)
							(ai_vehicle_enter_immediate g_ice_squad04b phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom04_progress 2)
							(if (= phantom04_hold 2)
								(sleep_until (= phantom04_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 				
							(!= g_ice_squad04c NONE)
						(begin							
							(ai_place g_ice_squad04c)
							(ai_vehicle_enter_immediate g_ice_squad04c phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom04_progress 3)
							(if (= phantom04_hold 3)
								(sleep_until (= phantom04_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 
							(!= g_ice_squad04d NONE)
						(begin							
							(ai_place g_ice_squad04d)
							(ai_vehicle_enter_immediate g_ice_squad04d phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom04_progress 4)
							(if (= phantom04_hold 4)
								(sleep_until (= phantom04_hold 0)5)
								(sleep 90)
							)							
						)
					)
					;(set g_ice_squad04a NONE)
					;(set g_ice_squad04b NONE)		
					;(set g_ice_squad04c NONE)		
					;(set g_ice_squad04d NONE)							
					(object_set_phantom_power phantom FALSE)
			)
		)
		((= phantom sq_ice_phantom05/pilot) 			
			(begin
					(object_set_phantom_power phantom TRUE)
					(if 
						  (!= g_ice_squad05a NONE)
						(begin
							(ai_place g_ice_squad05a)
							(ai_vehicle_enter_immediate g_ice_squad05a phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom05_progress 1)
							(if (= phantom05_hold 1)
								(sleep_until (= phantom05_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 							
						  (!= g_ice_squad05b NONE)
						(begin
							(ai_place g_ice_squad05b)
							(ai_vehicle_enter_immediate g_ice_squad05b phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom05_progress 2)
							(if (= phantom05_hold 2)
								(sleep_until (= phantom05_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 				
							(!= g_ice_squad05c NONE)
						(begin							
							(ai_place g_ice_squad05c)
							(ai_vehicle_enter_immediate g_ice_squad05c phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom05_progress 3)
							(if (= phantom05_hold 3)
								(sleep_until (= phantom05_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 
							(!= g_ice_squad05d NONE)
						(begin							
							(ai_place g_ice_squad05d)
							(ai_vehicle_enter_immediate g_ice_squad05d phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom05_progress 4)
							(if (= phantom05_hold 4)
								(sleep_until (= phantom05_hold 0)5)
								(sleep 90)
							)							
						)
					)
					;(set g_ice_squad05a NONE)
					;(set g_ice_squad05b NONE)		
					;(set g_ice_squad05c NONE)		
					;(set g_ice_squad05d NONE)							
					(object_set_phantom_power phantom FALSE)
			)
		)																
		((= phantom sq_ice_phantom06/pilot) 			
			(begin
					(object_set_phantom_power phantom TRUE)
					(if 
						  (!= g_ice_squad06a NONE)
						(begin
							(ai_place g_ice_squad06a)
							(ai_vehicle_enter_immediate g_ice_squad06a phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom06_progress 1)
							(if (= phantom06_hold 1)
								(sleep_until (= phantom06_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 							
						  (!= g_ice_squad06b NONE)
						(begin
							(ai_place g_ice_squad06b)
							(ai_vehicle_enter_immediate g_ice_squad06b phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom06_progress 2)
							(if (= phantom06_hold 2)
								(sleep_until (= phantom06_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 				
							(!= g_ice_squad06c NONE)
						(begin							
							(ai_place g_ice_squad06c)
							(ai_vehicle_enter_immediate g_ice_squad06c phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom06_progress 3)
							(if (= phantom06_hold 3)
								(sleep_until (= phantom06_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 
							(!= g_ice_squad06d NONE)
						(begin							
							(ai_place g_ice_squad06d)
							(ai_vehicle_enter_immediate g_ice_squad06d phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom06_progress 4)
							(if (= phantom06_hold 4)
								(sleep_until (= phantom06_hold 0)5)
								(sleep 90)
							)							
						)
					)
					;(set g_ice_squad06a NONE)
					;(set g_ice_squad06b NONE)		
					;(set g_ice_squad06c NONE)		
					;(set g_ice_squad06d NONE)							
					(object_set_phantom_power phantom FALSE)
			)
		)
	((= phantom sq_ice_phantom07/pilot) 			
			(begin
					(object_set_phantom_power phantom TRUE)
					(if 
						  (!= g_ice_squad07a NONE)
						(begin
							(ai_place g_ice_squad07a)
							(ai_vehicle_enter_immediate g_ice_squad07a phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom07_progress 1)
							(if (= phantom07_hold 1)
								(sleep_until (= phantom07_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 							
						  (!= g_ice_squad07b NONE)
						(begin
							(ai_place g_ice_squad07b)
							(ai_vehicle_enter_immediate g_ice_squad07b phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom07_progress 2)
							(if (= phantom07_hold 2)
								(sleep_until (= phantom07_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 				
							(!= g_ice_squad07c NONE)
						(begin							
							(ai_place g_ice_squad07c)
							(ai_vehicle_enter_immediate g_ice_squad07c phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							(set phantom07_progress 3)
							(if (= phantom07_hold 3)
								(sleep_until (= phantom07_hold 0)5)
								(sleep 90)
							)
						)
					)
					(if 
							(!= g_ice_squad07d NONE)
						(begin							
							(ai_place g_ice_squad07d)
							(sleep 90)
							;*
							(ai_vehicle_enter_immediate g_ice_squad07d phantom "phantom_pc")
							(sleep 60)	
							(vehicle_unload phantom "phantom_pc")
							*;
							(set phantom07_progress 4)
							(if (= phantom07_hold 4)
								(sleep_until (= phantom07_hold 0)5)
								(sleep 90)
							)							
						)
					)
					;(set g_ice_squad07a NONE)
					;(set g_ice_squad07b NONE)		
					;(set g_ice_squad07c NONE)		
					;(set g_ice_squad07d NONE)							
					(object_set_phantom_power phantom FALSE)
			)
		)		
	)
)

(script static void (phantom01_path (short l_loc))
	(sleep_until (= (ai_living_count gr_ice_dropship01) 0)5)
		(set b_dropship01_unload false)	
		(ai_place sq_ice_phantom01/pilot)
		(ai_disregard (ai_actors sq_ice_phantom01) true)
		(ai_cannot_die sq_ice_phantom01 true)
		;(ai_place sq_invis_phantom_guy_01)
		;(ai_vehicle_enter_immediate sq_invis_phantom_guy_01 sq_ice_phantom01 "close_turret_doors")
		
		(set g_ice_dropship01 sq_ice_phantom01/pilot)
	
	(cs_queue_command_script g_ice_dropship01 cs_cave01_start)
	(cond
		((= l_loc 1)
			(begin
				(cs_queue_command_script sq_ice_phantom01 cs_cave01_wait)
				(cs_queue_command_script sq_ice_phantom01 cs_cave01_drop)
			)
		)
		((= l_loc 2)
			(begin
				(cs_queue_command_script g_ice_dropship01 cs_cave02_wait)
				(cs_queue_command_script g_ice_dropship01 cs_cave02_drop)
			)
		)
		((= l_loc 3)
			(begin
				(cs_queue_command_script g_ice_dropship01 cs_cave03_wait)
				(cs_queue_command_script g_ice_dropship01 cs_cave03_drop)
			)
		)
		((= l_loc 4)
				(cs_queue_command_script g_ice_dropship01 cs_cave04_drop)
		)			
	)	
	(begin_random_count 1
		(cs_queue_command_script g_ice_dropship01 cs_cave01_exit)	
		(cs_queue_command_script g_ice_dropship01 cs_cave02_exit)
	)	
)

(script static void (phantom02_path (short l_loc))
	(sleep_until (= (ai_living_count gr_ice_dropship02) 0)5)
	(set b_dropship02_unload false)	
		(ai_place sq_ice_phantom02/pilot)
		(ai_disregard (ai_actors sq_ice_phantom02) true)
		(ai_cannot_die sq_ice_phantom02 true)
		;(ai_place sq_invis_phantom_guy_02)
		;(ai_vehicle_enter_immediate sq_invis_phantom_guy_02 sq_ice_phantom02 "close_turret_doors")			
		
		(set g_ice_dropship02 sq_ice_phantom02/pilot)
	(cs_queue_command_script g_ice_dropship02 cs_cave01_start)

	(cond
		((= l_loc 1)
			(begin
				(cs_queue_command_script g_ice_dropship02 cs_cave01_wait)
				(cs_queue_command_script g_ice_dropship02 cs_cave01_drop)
			)
		)
		((= l_loc 2)
			(begin
				(cs_queue_command_script g_ice_dropship02 cs_cave02_wait)
				(cs_queue_command_script g_ice_dropship02 cs_cave02_drop)
			)
		)
		((= l_loc 3)
			(begin
				(cs_queue_command_script g_ice_dropship02 cs_cave03_wait)
				(cs_queue_command_script g_ice_dropship02 cs_cave03_drop)
			)
		)
		((= l_loc 4)
				(cs_queue_command_script g_ice_dropship02 cs_cave04_drop)
		)			
	)	
	(begin_random_count 1
		(cs_queue_command_script g_ice_dropship02 cs_cave01_exit)	
		(cs_queue_command_script g_ice_dropship02 cs_cave02_exit)
	)
)
(script static void (phantom03_path (short l_loc))
	(sleep_until (= (ai_living_count gr_ice_dropship03) 0)5)
		(set b_dropship03_unload false)	
		(ai_place sq_ice_phantom03/pilot)
		(ai_disregard (ai_actors sq_ice_phantom03) true)
		(ai_cannot_die sq_ice_phantom03 true)
		;(ai_place sq_invis_phantom_guy_03)
		;(ai_vehicle_enter_immediate sq_invis_phantom_guy_03 sq_ice_phantom03 "close_turret_doors")	
			
		(set g_ice_dropship03 sq_ice_phantom03/pilot)
	(cs_queue_command_script g_ice_dropship03 cs_cave02_start)

	(cond
		((= l_loc 1)
			(begin
				(cs_queue_command_script g_ice_dropship03 cs_cave01_wait)
				(cs_queue_command_script g_ice_dropship03 cs_cave01_drop)
			)
		)
		((= l_loc 2)
			(begin
				(cs_queue_command_script g_ice_dropship03 cs_cave02_wait)
				(cs_queue_command_script g_ice_dropship03 cs_cave02_drop)
			)
		)
		((= l_loc 3)
			(begin
				(cs_queue_command_script g_ice_dropship03 cs_cave03_wait)
				(cs_queue_command_script g_ice_dropship03 cs_cave03_drop)
			)
		)
		((= l_loc 4)
				(cs_queue_command_script g_ice_dropship03 cs_cave04_drop)
		)			
	)			
	(begin_random_count 1
		(cs_queue_command_script g_ice_dropship03 cs_cave01_exit)	
		(cs_queue_command_script g_ice_dropship03 cs_cave02_exit)
	)

)		
(script static void (phantom04_path (short l_loc))
	(sleep_until (= (ai_living_count gr_ice_dropship04) 0)5)
		(set b_dropship04_unload false)	
		(ai_place sq_ice_phantom04/pilot)
		(ai_disregard (ai_actors sq_ice_phantom04) true)
		(ai_cannot_die sq_ice_phantom04 true)
		;(ai_place sq_invis_phantom_guy_04)
		;(ai_vehicle_enter_immediate sq_invis_phantom_guy_04 sq_ice_phantom04 "close_turret_doors")	
			
		(set g_ice_dropship04 sq_ice_phantom04/pilot)
	(cs_queue_command_script g_ice_dropship04 cs_cave02_start)

	(cond
		((= l_loc 1)
			(begin
				(cs_queue_command_script g_ice_dropship04 cs_cave01_wait)
				(cs_queue_command_script g_ice_dropship04 cs_cave01_drop)
			)
		)
		((= l_loc 2)
			(begin
				(cs_queue_command_script g_ice_dropship04 cs_cave02_wait)
				(cs_queue_command_script g_ice_dropship04 cs_cave02_drop)
			)
		)
		((= l_loc 3)
			(begin
				(cs_queue_command_script g_ice_dropship04 cs_cave03_wait)
				(cs_queue_command_script g_ice_dropship04 cs_cave03_drop)
			)
		)
		((= l_loc 4)
				(cs_queue_command_script g_ice_dropship04 cs_cave04_drop)
		)			
	)	
	(begin_random_count 1
		(cs_queue_command_script g_ice_dropship04 cs_cave01_exit)	
		(cs_queue_command_script g_ice_dropship04 cs_cave02_exit)
	)
)

(script static void (phantom05_path (short l_loc))
	(sleep_until (= (ai_living_count gr_ice_dropship05) 0)5)
		(set b_dropship05_unload false)	
		(ai_place sq_ice_phantom05/pilot)
		(ai_disregard (ai_actors sq_ice_phantom05) true)
		(ai_cannot_die sq_ice_phantom05 true)
		;(ai_place sq_invis_phantom_guy_05)
		;(ai_vehicle_enter_immediate sq_invis_phantom_guy_05 sq_ice_phantom05 "close_turret_doors")		
				
		(set g_ice_dropship05 sq_ice_phantom05/pilot)
	(cs_queue_command_script g_ice_dropship05 cs_cave03_start)

	(cond
		((= l_loc 1)
			(begin
				(cs_queue_command_script g_ice_dropship05 cs_cave01_wait)
				(cs_queue_command_script g_ice_dropship05 cs_cave01_drop)
			)
		)
		((= l_loc 2)
			(begin
				(cs_queue_command_script g_ice_dropship05 cs_cave02_wait)
				(cs_queue_command_script g_ice_dropship05 cs_cave02_drop)
			)
		)
		((= l_loc 3)
			(begin
				(cs_queue_command_script g_ice_dropship05 cs_cave03_wait)
				(cs_queue_command_script g_ice_dropship05 cs_cave03_drop)
			)
		)
		((= l_loc 4)
				(cs_queue_command_script g_ice_dropship05 cs_cave04_drop)
		)			
	)	
	(begin_random_count 1
		(cs_queue_command_script g_ice_dropship05 cs_cave01_exit)	
		(cs_queue_command_script g_ice_dropship05 cs_cave02_exit)
	)	
)
(script static void (phantom06_path (short l_loc))
	(sleep_until (= (ai_living_count gr_ice_dropship06) 0)5)
		(set b_dropship06_unload false)	
		(ai_place sq_ice_phantom06/pilot)
		(ai_disregard (ai_actors sq_ice_phantom06) true)
		(ai_cannot_die sq_ice_phantom06 true)
		;(ai_place sq_invis_phantom_guy_06)
		;(ai_vehicle_enter_immediate sq_invis_phantom_guy_06 sq_ice_phantom06 "close_turret_doors")	
			
		(set g_ice_dropship06 sq_ice_phantom06/pilot)	
	(cs_queue_command_script g_ice_dropship06 cs_cave03_start)

	(cond
		((= l_loc 1)
			(begin
				(cs_queue_command_script g_ice_dropship06 cs_cave01_wait)
				(cs_queue_command_script g_ice_dropship06 cs_cave01_drop)
			)
		)
		((= l_loc 2)
			(begin
				(cs_queue_command_script g_ice_dropship06 cs_cave02_wait)
				(cs_queue_command_script g_ice_dropship06 cs_cave02_drop)
			)
		)
		((= l_loc 3)
			(begin
				(cs_queue_command_script g_ice_dropship06 cs_cave03_wait)
				(cs_queue_command_script g_ice_dropship06 cs_cave03_drop)
			)
		)
		((= l_loc 4)
				(cs_queue_command_script g_ice_dropship06 cs_cave04_drop)
		)		
	)	
	(begin_random_count 1
		(cs_queue_command_script g_ice_dropship06 cs_cave01_exit)	
		(cs_queue_command_script g_ice_dropship06 cs_cave02_exit)
	)	
)

(script static void (phantom07_path (short l_loc))
	(sleep_until (= (ai_living_count gr_ice_dropship07) 0)5)
		(set b_dropship07_unload false)	
		(ai_place sq_ice_phantom07/pilot)
		(ai_disregard (ai_actors sq_ice_phantom07) true)
		(ai_cannot_die sq_ice_phantom07 true)
		;(ai_place sq_invis_phantom_guy_07)
		;(ai_vehicle_enter_immediate sq_invis_phantom_guy_07 sq_ice_phantom07 "close_turret_doors")	
			
		(set g_ice_dropship07 sq_ice_phantom07/pilot)	
	(cs_queue_command_script g_ice_dropship07 cs_cave03_start)

	(cond
		((= l_loc 1)
			(begin
				(cs_queue_command_script g_ice_dropship07 cs_cave01_wait)
				(cs_queue_command_script g_ice_dropship07 cs_cave01_drop)
			)
		)
		((= l_loc 2)
			(begin
				(cs_queue_command_script g_ice_dropship07 cs_cave02_wait)
				(cs_queue_command_script g_ice_dropship07 cs_cave02_drop)
			)
		)
		((= l_loc 3)
			(begin
				(cs_queue_command_script g_ice_dropship07 cs_cave03_wait)
				(cs_queue_command_script g_ice_dropship07 cs_cave03_drop)
			)
		)
		((= l_loc 4)
				(cs_queue_command_script g_ice_dropship07 cs_cave04_drop)
		)		
	)	
	(begin_random_count 1
		(cs_queue_command_script g_ice_dropship07 cs_cave01_exit)	
		(cs_queue_command_script g_ice_dropship07 cs_cave02_exit)
	)	
)

(script command_script ice_wraith_shell00
	(cs_enable_moving TRUE)
	(cs_go_to ps_ice_wraith_attack/p28)
	(sleep 90)
	(wake md_110_ice_cave_wraith)
	;(cs_enable_looking TRUE)
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point true ps_ice_wraith_attack/p0 )
				(cs_shoot_point true ps_ice_wraith_attack/p1 )
				(cs_shoot_point true ps_ice_wraith_attack/p2 )
				(cs_shoot_point true ps_ice_wraith_attack/p3 )
				(cs_shoot_point true ps_ice_wraith_attack/p4 )
				(cs_shoot_point true ps_ice_wraith_attack/p5 )
				(cs_shoot_point true ps_ice_wraith_attack/p6 )
				(cs_shoot_point true ps_ice_wraith_attack/p7 )
				(cs_shoot_point true ps_ice_wraith_attack/p8 )
				(cs_shoot_point true ps_ice_wraith_attack/p9 )
				(cs_shoot_point true ps_ice_wraith_attack/p10 )
				(cs_shoot_point true ps_ice_wraith_attack/p11 )
				(cs_shoot_point true ps_ice_wraith_attack/p12 )
				(cs_shoot_point true ps_ice_wraith_attack/p13 )
				(cs_shoot_point true ps_ice_wraith_attack/p14 )				
				(cs_shoot_point true ps_ice_wraith_attack/p15 )								
				(cs_shoot_point true ps_ice_wraith_attack/p16 )
				(cs_shoot_point true ps_ice_wraith_attack/p17 )
				(cs_shoot_point true ps_ice_wraith_attack/p18 )
				(cs_shoot_point true ps_ice_wraith_attack/p19 )
				(cs_shoot_point true ps_ice_wraith_attack/p20 )
				(cs_shoot_point true ps_ice_wraith_attack/p21 )
				(cs_shoot_point true ps_ice_wraith_attack/p22 )
				(cs_shoot_point true ps_ice_wraith_attack/p23 )
				(cs_shoot_point true ps_ice_wraith_attack/p24 )
				(cs_shoot_point true ps_ice_wraith_attack/p25 )
				(cs_shoot_point true ps_ice_wraith_attack/p26 )
				(cs_shoot_point true ps_ice_wraith_attack/p27 )				
			)
		false)
	)
)
(script command_script ice_wraith_shell01
	(cs_enable_moving TRUE)
	(cs_go_to ps_ice_wraith_attack/p29)
	(sleep 90)
	;(cs_enable_looking TRUE)
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point true ps_ice_wraith_attack/p0 )
				(cs_shoot_point true ps_ice_wraith_attack/p1 )
				(cs_shoot_point true ps_ice_wraith_attack/p2 )
				(cs_shoot_point true ps_ice_wraith_attack/p3 )
				(cs_shoot_point true ps_ice_wraith_attack/p4 )
				(cs_shoot_point true ps_ice_wraith_attack/p5 )
				(cs_shoot_point true ps_ice_wraith_attack/p6 )
				(cs_shoot_point true ps_ice_wraith_attack/p7 )
				(cs_shoot_point true ps_ice_wraith_attack/p8 )
				(cs_shoot_point true ps_ice_wraith_attack/p9 )
				(cs_shoot_point true ps_ice_wraith_attack/p10 )
				(cs_shoot_point true ps_ice_wraith_attack/p11 )
				(cs_shoot_point true ps_ice_wraith_attack/p12 )
				(cs_shoot_point true ps_ice_wraith_attack/p13 )
				(cs_shoot_point true ps_ice_wraith_attack/p14 )				
				(cs_shoot_point true ps_ice_wraith_attack/p15 )								
				(cs_shoot_point true ps_ice_wraith_attack/p16 )
				(cs_shoot_point true ps_ice_wraith_attack/p17 )
				(cs_shoot_point true ps_ice_wraith_attack/p18 )
				(cs_shoot_point true ps_ice_wraith_attack/p19 )
				(cs_shoot_point true ps_ice_wraith_attack/p20 )
				(cs_shoot_point true ps_ice_wraith_attack/p21 )
				(cs_shoot_point true ps_ice_wraith_attack/p22 )
				(cs_shoot_point true ps_ice_wraith_attack/p23 )
				(cs_shoot_point true ps_ice_wraith_attack/p24 )
				(cs_shoot_point true ps_ice_wraith_attack/p25 )
				(cs_shoot_point true ps_ice_wraith_attack/p26 )
				(cs_shoot_point true ps_ice_wraith_attack/p27 )				
			)
		false)
	)
)
(script command_script ice_wraith_shell02
	(cs_enable_moving TRUE)
	(cs_go_to ps_ice_wraith_attack/p30)
	(sleep 90)
	;(cs_enable_looking TRUE)
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point true ps_ice_wraith_attack/p0 )
				(cs_shoot_point true ps_ice_wraith_attack/p1 )
				(cs_shoot_point true ps_ice_wraith_attack/p2 )
				(cs_shoot_point true ps_ice_wraith_attack/p3 )
				(cs_shoot_point true ps_ice_wraith_attack/p4 )
				(cs_shoot_point true ps_ice_wraith_attack/p5 )
				(cs_shoot_point true ps_ice_wraith_attack/p6 )
				(cs_shoot_point true ps_ice_wraith_attack/p7 )
				(cs_shoot_point true ps_ice_wraith_attack/p8 )
				(cs_shoot_point true ps_ice_wraith_attack/p9 )
				(cs_shoot_point true ps_ice_wraith_attack/p10 )
				(cs_shoot_point true ps_ice_wraith_attack/p11 )
				(cs_shoot_point true ps_ice_wraith_attack/p12 )
				(cs_shoot_point true ps_ice_wraith_attack/p13 )
				(cs_shoot_point true ps_ice_wraith_attack/p14 )				
				(cs_shoot_point true ps_ice_wraith_attack/p15 )								
				(cs_shoot_point true ps_ice_wraith_attack/p16 )
				(cs_shoot_point true ps_ice_wraith_attack/p17 )
				(cs_shoot_point true ps_ice_wraith_attack/p18 )
				(cs_shoot_point true ps_ice_wraith_attack/p19 )
				(cs_shoot_point true ps_ice_wraith_attack/p20 )
				(cs_shoot_point true ps_ice_wraith_attack/p21 )
				(cs_shoot_point true ps_ice_wraith_attack/p22 )
				(cs_shoot_point true ps_ice_wraith_attack/p23 )
				(cs_shoot_point true ps_ice_wraith_attack/p24 )
				(cs_shoot_point true ps_ice_wraith_attack/p25 )
				(cs_shoot_point true ps_ice_wraith_attack/p26 )
				(cs_shoot_point true ps_ice_wraith_attack/p27 )				
			)
		false)
	)
)


(script command_script cs_cave01_start
	(cs_vehicle_speed 1)
	(cs_ignore_obstacles TRUE)	
	(cs_fly_to_and_face ps_ice_cave01_start/p0 ps_ice_cave01_start/p3 )	
	(cs_fly_by ps_ice_cave01_start/p1 1)
	(cs_fly_by ps_ice_cave01_start/p2 3)
	(ai_cannot_die ai_current_actor false)
)

(script command_script cs_cave02_start
	(cs_vehicle_speed 1)
	(cs_ignore_obstacles TRUE)
	(cs_fly_to_and_face ps_ice_cave02_start/p0 ps_ice_cave02_start/p3 )		
	(cs_fly_by ps_ice_cave02_start/p1 1)
	(cs_fly_by ps_ice_cave02_start/p2 3)
	(ai_cannot_die ai_current_actor false)
)

(script command_script cs_cave03_start
	(cs_vehicle_speed 1)
	(cs_ignore_obstacles TRUE)	
	(cs_fly_to_and_face ps_ice_cave03_start/p0 ps_ice_cave03_start/p3)	
	(cs_fly_by ps_ice_cave03_start/p1 1)
	(cs_fly_by ps_ice_cave03_start/p2 3)
	(ai_cannot_die ai_current_actor false)	
)

(script command_script cs_cave01_wait
	(if (= g_drop_occupied01 TRUE)
		(begin
			(cs_ignore_obstacles TRUE)
			(cs_fly_to ps_ice_cave01_wait/wait 1)
			(sleep_until (= g_drop_occupied01 FALSE) 5)
		)
	)
)
(script command_script cs_cave02_wait
	(if (= g_drop_occupied02 TRUE)
		(begin
			(cs_ignore_obstacles TRUE)
			(cs_fly_to ps_ice_cave02_wait/wait 1)
			(sleep_until (= g_drop_occupied02 FALSE) 5)
			(sleep 60)
		)
	)
)
(script command_script cs_cave03_wait
	(if (= g_drop_occupied03 TRUE)
		(begin
			(cs_ignore_obstacles TRUE)
			(cs_fly_to ps_ice_cave03_wait/wait 1)
			(sleep_until (= g_drop_occupied03 FALSE) 5)
		)
	)
)
(global boolean b_dropship01_unload FALSE)
(global boolean b_dropship02_unload FALSE)
(global boolean b_dropship03_unload FALSE)
(global boolean b_dropship04_unload FALSE)
(global boolean b_dropship05_unload FALSE)
(global boolean b_dropship06_unload FALSE)
(global boolean b_dropship07_unload FALSE)

(script static void f_dropship

	(cond 
		((= (ai_vehicle_get ai_current_actor) sq_ice_phantom01/pilot)
		(begin 
			(print "DROPSHIP01 DROPPED!!")
			(set b_dropship01_unload true)	
		))
		((= (ai_vehicle_get ai_current_actor) sq_ice_phantom02/pilot)
		(begin 
			(print "DROPSHIP02 DROPPED!!")
			(set b_dropship02_unload true)	
		))
		((= (ai_vehicle_get ai_current_actor) sq_ice_phantom03/pilot)
		(begin 
			(print "DROPSHIP03 DROPPED!!")
			(set b_dropship03_unload true)	
		))
		((= (ai_vehicle_get ai_current_actor) sq_ice_phantom04/pilot)
		(begin 
			(print "DROPSHIP04 DROPPED!!")
			(set b_dropship04_unload true)	
		))
		((= (ai_vehicle_get ai_current_actor) sq_ice_phantom05/pilot)
		(begin 
			(print "DROPSHIP05 DROPPED!!")
			(set b_dropship05_unload true)	
		))
		((= (ai_vehicle_get ai_current_actor) sq_ice_phantom06/pilot)
		(begin 
			(print "DROPSHIP06 DROPPED!!")
			(set b_dropship06_unload true)	
		))
		((= (ai_vehicle_get ai_current_actor) sq_ice_phantom07/pilot)
		(begin 
			(print "DROPSHIP07 DROPPED!!")
			(set b_dropship07_unload true)	
		))											
	)
)



(script command_script cs_cave01_drop
	(set g_drop_occupied01 TRUE)
	(cs_vehicle_boost true)	
	(cs_ignore_obstacles TRUE)			
	(cs_fly_by ps_ice_cave01_drop/land01a 3)
	(cs_face TRUE ps_ice_cave01_drop/face01 )
	(cs_vehicle_boost false)
	(cs_fly_to ps_ice_cave01_drop/land01b )
	(sleep 120)
	(vehicle_hover (ai_vehicle_get ai_current_actor) true)		
	(set g_drop_begin01 true)		
	(chute_drop (ai_vehicle_get ai_current_actor))	
	(set g_drop_begin01 FALSE)		
	(sleep 120)		
	(f_unload_phantom_cargo (ai_vehicle_get ai_current_actor) "single")
	(f_unload_phantom_cargo (ai_vehicle_get ai_current_actor) "double")
	(set g_drop_occupied01 FALSE)
	(vehicle_hover (ai_vehicle_get ai_current_actor) false)			
	(f_dropship)		
	(cs_face FALSE ps_ice_cave01_drop/face01)
	(cs_fly_by ps_ice_cave01_drop/land01a 3)
)

(script command_script cs_cave02_drop
	(set g_drop_occupied02 TRUE)
	(cs_vehicle_boost true)
	(cs_ignore_obstacles TRUE)				
	(cs_fly_by ps_ice_cave02_drop/land01a)
	(cs_face TRUE ps_ice_cave02_drop/face01 )
	(cs_vehicle_boost false)
	(cs_fly_to ps_ice_cave02_drop/land01b )
	(sleep 120)
	(vehicle_hover (ai_vehicle_get ai_current_actor) true)		
	(set g_drop_begin02 true)			
	(chute_drop (ai_vehicle_get ai_current_actor))
	(set g_drop_begin02 false)
	(sleep 120)				
	(f_unload_phantom_cargo (ai_vehicle_get ai_current_actor) "single")
	(f_unload_phantom_cargo (ai_vehicle_get ai_current_actor) "double")
	(set g_drop_occupied02 FALSE)
	(vehicle_hover (ai_vehicle_get ai_current_actor) false)				
	(f_dropship)	
	(cs_face FALSE ps_ice_cave02_drop/face01)	
	(cs_fly_by ps_ice_cave02_drop/land01a 3)
)

(script command_script cs_cave03_drop
	(set g_drop_occupied03 TRUE)
	(cs_vehicle_boost true)
	(cs_ignore_obstacles TRUE)					
	(cs_fly_by ps_ice_cave03_drop/land01a 3)
	(cs_face TRUE ps_ice_cave03_drop/face01 )
	(cs_vehicle_boost false)	
	(cs_fly_to ps_ice_cave03_drop/land01b )
	(sleep 120)
	(vehicle_hover (ai_vehicle_get ai_current_actor) true)	
	(set g_drop_begin03 true)	
	(chute_drop (ai_vehicle_get ai_current_actor))
	(set g_drop_begin03 FALSE)	
	(sleep 120)
	(f_unload_phantom_cargo (ai_vehicle_get ai_current_actor) "single")
	(f_unload_phantom_cargo (ai_vehicle_get ai_current_actor) "double")
	(set g_drop_occupied03 FALSE)
	(vehicle_hover (ai_vehicle_get ai_current_actor) false)	
	(f_dropship)	
	(cs_face FALSE ps_ice_cave03_drop/face01)	
	(cs_fly_by ps_ice_cave03_drop/land01a 3)
)

(script command_script cs_cave04_drop
	(cs_vehicle_boost true)
	(cs_ignore_obstacles TRUE)		
	(cs_fly_by ps_ice_cave04_drop/land01a 3)
	(cs_face TRUE ps_ice_cave04_drop/face01 )
	(cs_vehicle_boost false)	
	(wake md_110_ice_cave_front)
	(cs_fly_to ps_ice_cave04_drop/land01b )
	(chute_drop (ai_vehicle_get ai_current_actor))
	(sleep 120)	
	(f_unload_phantom_cargo (ai_vehicle_get ai_current_actor) "single")
	(f_unload_phantom_cargo (ai_vehicle_get ai_current_actor) "double")
	(f_dropship)
	(cs_face FALSE ps_ice_cave04_drop/face01)	
	(cs_fly_by ps_ice_cave04_drop/land01a 3)
)

(script command_script cs_cave01_exit
	(ai_cannot_die ai_current_actor false)
	(cs_vehicle_boost true)	
	(cs_ignore_obstacles TRUE)
	(cs_fly_by ps_ice_cave01_exit/p0 10)
	(cs_fly_by ps_ice_cave01_exit/p1 10)
	(cs_fly_by ps_ice_cave01_exit/p2 10)
	(fade_to_destroy (ai_vehicle_get ai_current_actor))

)
(script command_script cs_cave02_exit
	(ai_cannot_die ai_current_actor false)
	(cs_vehicle_boost true)		
	(cs_ignore_obstacles TRUE)	
	(cs_fly_by ps_ice_cave02_exit/p0 10)
	(cs_fly_by ps_ice_cave02_exit/p1 10)
	(cs_fly_by ps_ice_cave02_exit/p2 5)
	(cs_fly_by ps_ice_cave02_exit/p3 10)
	(fade_to_destroy (ai_vehicle_get ai_current_actor))

)
(script command_script cs_banshee01_exit
	(cs_vehicle_boost true)		
	(cs_fly_by ps_ice_banshee_exit/p1 10)
	(cs_fly_by ps_ice_banshee_exit/p0 3)	
	(fade_to_destroy (ai_vehicle_get ai_current_actor))
)
(script command_script cs_banshee02_exit
	(cs_vehicle_boost true)		
	(cs_fly_by ps_ice_banshee_exit/p2 10)	
	(cs_fly_by ps_ice_banshee_exit/p3 3)
	(fade_to_destroy (ai_vehicle_get ai_current_actor))
)

(script static void elite_refresh
	(sleep (random_range (* 30 15) (* 30 25)))
	(ai_reset_objective obj_ice_cave/elite_push)
	(print "RESETTING elite_PUSH")
)

(script static void (fade_to_destroy (vehicle vehicle_variable))
                (object_set_scale vehicle_variable .01 (* 30 5))
                (sleep (* 30 5))
                (object_destroy vehicle_variable)
)

(script command_script cs_reinforcement_hack
	(print "cs_reinforcement_hack")
	(sleep 120)
)

(script command_script cs_reinforcement_drop
	(print "cs_reinforcement_drop")
	(sleep 30)
)


(script command_script cs_banshee01_start
	(cs_vehicle_speed 1)	
	(cs_fly_by ps_ice_cave01_start/p1 3)
	(cs_fly_by ps_ice_cave01_start/p2 3)
)

(script command_script cs_banshee02_start
	(cs_vehicle_speed 1)	
	(cs_fly_by ps_ice_cave02_start/p1 3)
	(cs_fly_by ps_ice_cave02_start/p2 3)
)

(script command_script cs_banshee03_start
	(cs_vehicle_speed 1)	
	(cs_fly_by ps_ice_cave03_start/p1 3)
	(cs_fly_by ps_ice_cave03_start/p2 3)
)

(script dormant marine_nanny
	(sleep_until (>= motorpool_obj_control 10)5)
	(ai_set_objective sq_initial_troopers obj_motorpool)
			
	(sleep_until (>= motorpool_obj_control 60)5)
	(ai_set_objective sq_initial_troopers obj_depot)
	
	(sleep_until (>= supply_obj_control 90)5)
	(ai_set_objective sq_initial_troopers obj_ghost_patrol)


	(sleep_until (>= gate_obj_control 10)5)
	(ai_set_objective sq_initial_troopers obj_gate_attack)

)
(script dormant spartan_nanny
	(sleep_until (>= assault_obj_control 40)5)
	(ai_bring_forward sq_carter 2)	
	(if	(<= (game_coop_player_count) 2)
		(begin			
			(ai_bring_forward sq_emile 2)
			(ai_bring_forward sq_jun 2)
		)
	)		
			
	(sleep_until (>= interior_obj_control 5)5)
	(ai_set_objective gr_spartans obj_interior)
	(sleep 60)
	(ai_bring_forward sq_carter 3)	
	(if	(<= (game_coop_player_count) 2)
		(begin		
			(ai_bring_forward sq_emile 3)
			(ai_bring_forward sq_jun 3)
		)
	)
	
	(sleep_until (>= interior_obj_control 60)5)	
	(sleep 60)
	(ai_bring_forward sq_carter 7)
	(if	(<= (game_coop_player_count) 2)
		(begin			
			(ai_bring_forward sq_emile 7)
			(ai_bring_forward sq_jun 7)
		)
	)

	(sleep_until (>= security_obj_control 10)5)
	(ai_set_objective gr_spartans obj_security)	
	(ai_bring_forward sq_carter 4)
	(if	(<= (game_coop_player_count) 2)
		(begin		
			(ai_bring_forward sq_emile 4)
			(ai_bring_forward sq_jun 4)
		)
	)
	(sleep_until (>= ice_cave_obj_control 10)	5)	
	(ai_set_objective gr_spartans obj_trooper_ice_cave)
)

; use (ai_erase_inactive sq_initial_troopers 0) instead
(global short straggler_no 0)

(script static void (ai_cleanup (trigger_volume vol) (ai squad))
	(set straggler_no 0)
	(sleep_until
		(begin
			(if (volume_test_objects vol (object_get_ai (list_get (ai_actors squad) straggler_no)))
				(begin
		    	(ai_erase (object_get_ai (list_get (ai_actors squad) straggler_no)))
		     	(print "disposing of unused AI")
		     	(set straggler_no 0)
		    )
		    (set straggler_no (+ straggler_no 1))
			)
		(> straggler_no (ai_living_count squad)))
	5)
)
;==============SPECIAL ELITE=====================;
(global short s_special_elite 0)
(global boolean b_special false)
(global boolean b_special_win false)
(global short s_special_elite_ticks 600)

(script dormant special_elite
	(if (= s_special_elite 0)
		(begin_random_count 1
			(set s_special_elite 1)
			(set s_special_elite 2)	
			(set s_special_elite 3)			
		)
	)
	(sleep_until (> (ai_living_count gr_special_elite) 0)1)
	(sleep_until 
		(and
			(< (ai_living_count gr_special_elite) 1)
			(= b_special_win true)
		)
	1)
	(set b_special true)
	;(submit_incident "kill_elite_bob")
	(print "SPECIAL WIN!")
)

(script command_script cs_special_elite
	(set b_special_win true)
	(cs_face_player true)
	(sleep 5)
	(print "SPECIAL START")	
	(sleep_until
		(or
			(and
				(or
					(objects_can_see_object player0 (ai_get_object ai_current_actor) 10)
					(< (objects_distance_to_object player0 (ai_get_object ai_current_actor))15)
				)
				(= (player_is_in_game player0) true)
			)		
			(and
				(or
					(objects_can_see_object player1 (ai_get_object ai_current_actor) 10)
					(< (objects_distance_to_object player1	 (ai_get_object ai_current_actor))15)
				)
				(= (player_is_in_game player1) true)
			)			
			(and
				(or
					(objects_can_see_object player2 (ai_get_object ai_current_actor) 10)
					(< (objects_distance_to_object player2	 (ai_get_object ai_current_actor))15)
				)
				(= (player_is_in_game player2) true)
			)		
			(and
				(or
					(objects_can_see_object player3 (ai_get_object ai_current_actor) 10)
					(< (objects_distance_to_object player3	 (ai_get_object ai_current_actor))15)
				)
				(= (player_is_in_game player3) true)
			)									
		)
	5)
	(cs_enable_moving true)
	(cs_enable_targeting true)
	(cs_enable_looking true)
	(cs_enable_dialogue true)	
	(print "SPECIAL ELITE SPOTTED")		
	(sleep s_special_elite_ticks)
	(ai_set_active_camo ai_current_actor true)
	(sleep 30)
	(set b_special_win false)
	(print "SPECIAL FAIL")
	(sleep 1)
	(ai_erase ai_current_actor)
)

(script command_script boost_5seconds
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost TRUE)
	(sleep 150)
)
(script command_script boost_7seconds
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost TRUE)
	(sleep 210)
)
(script command_script boost_10seconds
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_vehicle_boost TRUE)
	(sleep 300)
)

;==============OBJECTS=================

(script static void object_intialization
	(object_destroy_folder v_initial)	
	(object_destroy_folder bp_initial)
	(object_destroy_folder cr_initial)
	(object_destroy_folder sc_initial)	
	(object_destroy_folder eq_initial)	
	(object_destroy_folder cr_motorpool)
	(object_destroy_folder v_motorpool)
	(object_destroy_folder sc_motorpool)		
	(object_destroy_folder dc_initial)	
	(object_destroy_folder cr_depot)
	(object_destroy_folder v_depot)
	(object_destroy_folder w_depot)
	(object_destroy_folder eq_depot)		
	(object_destroy_folder v_gate)
	(object_destroy_folder cr_gate)	
	(object_destroy_folder sc_depot)
	(object_destroy_folder dc_depot)	
	(object_destroy_folder cr_assault)
	(object_destroy_folder sc_assault)
	(object_destroy_folder bp_assault)		
	(object_destroy_folder v_assault)
	(object_destroy_folder w_assault)	
	(object_destroy_folder eq_assault)	
	(object_destroy_folder dc_assault)	
	(object_destroy_folder cr_interior)
	(object_destroy_folder sc_interior)	
	(object_destroy_folder v_interior)
	(object_destroy_folder w_interior)
	(object_destroy_folder bp_interior)				
	(object_destroy_folder dm_interior)
	(object_destroy_folder dc_interior)
	(object_destroy_folder eq_interior)	
	(object_destroy_folder cr_security)
	(object_destroy_folder sc_security)
	(object_destroy_folder w_security)
	(object_destroy_folder bp_security)			
	(object_destroy_folder dm_security)
	(object_destroy_folder eq_security)			
	(object_destroy_folder sc_ice_cave)
	(object_destroy_folder cr_ice_cave)
	(object_destroy_folder v_ice_cave)
	(object_destroy_folder dc_ice_cave)
	(object_destroy_folder w_ice_cave)
	(object_destroy_folder dm_ice_cave)						
)

(script dormant object_management
	(zone_set_trigger_volume_enable begin_zone_set:sword_surf_exterior:* FALSE)
	(zone_set_trigger_volume_enable zone_set:sword_surf_exterior FALSE)
	(sleep_until (>= (current_zone_set) 0) 1)
	(if (= (current_zone_set) 0)
		(begin

			(print "OBJ_MGMT- Cinematic_initial")
		)
	)
	(sleep_until (>= (current_zone_set) 1) 1)	
	(if (= (current_zone_set) 1)
		(begin
			(object_create_folder cr_initial)
			(object_create_folder sc_initial)				
			(object_create_folder eq_initial)	
			(object_create_folder dc_initial)
			(object_create_folder v_initial)				
			(object_create_folder cr_motorpool)
			(object_create_folder v_motorpool)
			(object_create_folder sc_motorpool)				
			(object_create_folder bp_initial)			
			(print "OBJ_MGMT- Encounter_initial")
		)
	)
	(sleep_until (>= (current_zone_set) 2) 1)
	(sleep 5)
	(if (= (current_zone_set) 2)
		(begin
			(add_recycling_volume tv_start_garbage 20 20)				
			(print "OBJ_MGMT- Initial Zone_set")
			(sleep_until (>= (current_zone_set_fully_active) 2) 1)			
			(object_create v_bfg01)	
			(wake bfg01_state)		
			(object_create v_bfg02)
			(wake bfg02_state)			
			(ai_place sq_depot_bfg01)
			(unit_enter_vehicle_immediate sq_depot_bfg01 v_bfg01 "shade_d")
			;(unit_enter_vehicle_immediate player0 aj_phantom0 "phantom_d" )
			;(ai_vehicle_enter_immediate sq_depot_bfg01 v_bfg01)
			(cs_run_command_script sq_depot_bfg01 bfg01_look_at)
			(ai_place sq_depot_bfg02)
			(unit_enter_vehicle_immediate sq_depot_bfg02 v_bfg02 "shade_d" )
			(cs_run_command_script sq_depot_bfg02 bfg02_look_at)			
			(object_create_folder cr_depot)
			(object_create_folder eq_depot)		
			(object_create_folder cr_gate)
			(object_create_folder sc_depot)
			(object_create_folder dc_depot)
			(object_create_folder v_depot)									
		)
	)
		
	(sleep_until (>= (current_zone_set) 3) 1)
	(sleep 5)	
	(if (= (current_zone_set) 3)
		(begin		
			(object_destroy_folder bp_initial)
			(object_destroy_folder cr_initial)
			(object_destroy_folder sc_initial)			
			(object_destroy_folder eq_initial)		
			(object_destroy_folder dm_initial)
			(object_destroy_folder dc_initial)						
			(object_destroy_folder cr_motorpool)
			(object_destroy_folder dm_motorpool)
			(object_destroy_folder sc_motorpool)
			(object_destroy_folder eq_depot)									
			(object_destroy_folder cr_depot)
			(object_destroy_folder sc_depot)
			(object_destroy_folder dm_depot)
			(object_destroy_folder dc_depot)		
			(object_destroy_folder v_depot)
			(object_destroy_folder w_depot)					
			(print "OBJ_MGMT- Sword_Surf_Exterior")
			(ai_cleanup tv_motorpool_garbage sq_initial_troopers)
			(add_recycling_volume tv_motorpool_garbage 0 1)
			(sleep 1)
			(add_recycling_volume tv_supply_depot_garbage 0 20)
			(sleep_until (= (current_zone_set_fully_active) 3) 1)
			(sleep 5)
			(object_create_folder cr_assault)
			(object_create_folder sc_assault)
			(object_create_folder bp_assault)					
			(object_create_folder eq_assault)			
			(object_create_folder v_assault)
			(object_create_folder w_assault)
			(object_create_folder dc_assault)									
		)
	)
	(sleep_until (>= (current_zone_set) 4) 1)

		(object_destroy v_bfg01)		
		(object_destroy v_bfg02)
		(ai_cleanup tv_supply_depot_garbage sq_initial_troopers)	
		(sleep 5)		
	(if (= (current_zone_set) 4)
		(begin
			(print "OBJ_MGMT- Sword_stairwell")		
			(zone_set_trigger_volume_enable begin_zone_set:sword_surf_exterior:* FALSE)
			(device_set_position_immediate oni_front_gate 0)
			(ai_cleanup tv_gate_attack_garbage sq_initial_troopers)											
			(add_recycling_volume tv_supply_depot_garbage 0 0)
			(sleep 1)
			(add_recycling_volume tv_gate_attack_garbage 20 20)
			(ai_erase gr_gate_attack)
			(ai_erase gr_depot_ghosts)
			(zone_set_trigger_volume_enable zone_set:sword_surf_exterior FALSE)
			(zone_set_trigger_volume_enable begin_zone_set:sword_surf_exterior:* FALSE)								
			(sleep_until (= (current_zone_set_fully_active) 4)5)
			(print "OBJ_MGMT- Sword_stairwell-LOADED")
			(object_destroy_folder v_gate)
			(object_destroy_folder cr_gate)
			(object_destroy_folder dm_gate)						
			(object_create_folder cr_interior)
			(object_create_folder sc_interior)				
			(object_create_folder eq_interior)		
			(object_create_folder v_interior)
			(object_create_folder w_interior)
			(object_create_folder bp_interior)									
			(object_create_folder dm_interior)
			(object_create_folder dc_interior)				
			(flock_create fl_rats01)
			(flock_create fl_rats02)
			(flock_create fl_rats03)
			(flock_create fl_rats04)
;			(flock_create fl_cochroach01)
;			(flock_create fl_cochroach02)
;			(flock_create fl_cochroach03)
;			(flock_create fl_cochroach04)											
			(wake stairwell_recycle)	
		)
	)
	(sleep_until (>= (current_zone_set) 5) 1)
			(object_destroy_folder cr_assault)
			(object_destroy_folder sc_assault)
			(object_destroy_folder bp_assault)				
			(object_destroy_folder eq_assault)					
			(object_destroy_folder dm_assault)
			(object_destroy_folder dc_assault)
			(object_destroy_folder v_assault)
			(object_destroy_folder w_assault)									
			(object_destroy_folder v_motorpool)	
	(sleep 5)				
	(if (= (current_zone_set) 5)
		(begin
			(print "OBJ_MGMT- Sword_INTERIOR")	
			(device_set_power stairwell_door 0)
			(device_set_position_immediate stairwell_door 0)
			(ai_cleanup tv_base_assault_garbage01 sq_initial_troopers)		
			(ai_cleanup tv_base_assault_garbage02 sq_initial_troopers)		
			(ai_cleanup tv_base_assault_garbage03 sq_initial_troopers)		
			(ai_cleanup tv_base_assault_garbage04 sq_initial_troopers)		
			(add_recycling_volume tv_base_assault_garbage01 0 0)
			(sleep 1)
			(add_recycling_volume tv_base_assault_garbage02 0 0)
			(sleep 1)					
			(add_recycling_volume tv_base_assault_garbage03 0 0)
			(sleep 1)					
			(add_recycling_volume tv_base_assault_garbage04 0 0)
			(ai_erase gr_base_assault)
			(sleep_until (= (current_zone_set_fully_active) 5)5)
			(object_create_folder cr_security)
			(object_create_folder eq_security)			
			(object_create_folder sc_security)
			(object_create_folder w_security)
			(object_create_folder dm_security)
			(object_create_folder bp_security)
			(flock_create fl_cochroach05)
			(flock_create fl_cochroach06)
			(flock_create fl_cochroach07)
			(flock_create fl_cochroach08)
			(flock_create fl_cochroach09)		
			(flock_create fl_cochroach10)																
		)
	)
	(sleep_until (>= (current_zone_set) 6) 1)
		(object_destroy_folder cr_interior)
		(object_destroy_folder sc_interior)			
		(object_destroy_folder eq_interior)			
		(object_destroy_folder dc_interior)
		(object_destroy_folder dm_interior)
		(object_destroy_folder w_interior)
		(object_destroy_folder bp_interior)
		(flock_stop fl_rats01)
		(flock_stop fl_rats02)
		(flock_stop fl_rats03)
		(flock_stop fl_rats04)
;		(flock_stop fl_cochroach01)
;		(flock_stop fl_cochroach02)
;		(flock_stop fl_cochroach03)
;		(flock_stop fl_cochroach04)
		(flock_destroy fl_rats01)
		(flock_destroy fl_rats02)
		(flock_destroy fl_rats03)
		(flock_destroy fl_rats04)
;		(flock_destroy fl_cochroach01)
;		(flock_destroy fl_cochroach02)
;		(flock_destroy fl_cochroach03)
;		(flock_destroy fl_cochroach04)												
	(sleep 5)		
	(if (= (current_zone_set) 6)
		(begin
			(print "OBJ_MGMT- TRAM RIDE PREP")	
			(device_set_power dm_oni_stairwell_top 0)			
			(device_set_position_immediate dm_oni_stairwell_top 0)
			(ai_erase gr_interior_battle)
			(object_create door_interior_blocker) 
		)
	)		
(sleep_until (>= (current_zone_set) 8) 1)
	(print "ICE CAVE PLUS CINEMATIC")
	(object_destroy_folder v_interior)
	(object_destroy_folder cr_security)
	(object_destroy_folder eq_security)	
	(object_destroy_folder sc_security)
	(object_destroy_folder w_security)	
	(object_destroy_folder dm_security)
	(object_destroy_folder dc_security)
	(object_destroy_folder bp_security)
	(flock_stop fl_cochroach05)
	(flock_stop fl_cochroach06)
	(flock_stop fl_cochroach07)
	(flock_stop fl_cochroach08)
	(flock_stop fl_cochroach09)
	(flock_stop fl_cochroach10)		
	(flock_destroy fl_cochroach05)
	(flock_destroy fl_cochroach06)
	(flock_destroy fl_cochroach07)
	(flock_destroy fl_cochroach08)
	(flock_destroy fl_cochroach09)
	(flock_destroy fl_cochroach10)				

(sleep_until (= (current_zone_set_fully_active) 9)5)			
	(object_create_folder sc_ice_cave)
	(object_create_folder cr_ice_cave)								
	(object_create_folder v_ice_cave)
	(object_create_folder dc_ice_cave)
	(object_create_folder w_ice_cave)
	(object_create_folder dm_ice_cave)				
)


(script static void unblip_all
	(f_unblip_flag cf_nav_motorpool)	
	(f_unblip_flag gun01_flag)
	(f_unblip_flag gun02_flag)
	(f_unblip_flag cf_sword_base_objective)
	(f_unblip_object cin_mid_door_switch)
	(f_unblip_flag front_gate_flag)	
	(f_unblip_ai sq_carter_event)
	(f_unblip_flag cf_sword_base_objective)
	(f_unblip_object cin_mid_door_switch)	
	(f_unblip_flag nav_halsey_lab)
	(f_unblip_object dc_halsey_lab)
	(f_unblip_flag nav_halsey_front)
	(f_unblip_flag cf_interior)				
)

;=============================== MISC SCRIPTS=====================================
(script dormant aj_mode
	(sleep_until (>= (device_get_position aj_switch) 1)5)	
	(object_destroy aj_switch)
	(object_create aj_switch_2)
	(sleep_until (>= (device_get_position aj_switch_2) 1)30 150)
	(if (>= (device_get_position aj_switch_2) 1)
		(begin
			(soft_ceiling_enable default false)
			(disable_kill_soft)
			(print "AJ MODE!")
			(object_create aj_banshee01)
			(object_create aj_banshee02)
			(object_create aj_banshee03)
			(object_create aj_banshee04)									
			(zone_set_trigger_volume_enable zone_set:sword_surf_exterior false)
			(object_cannot_take_damage v_bfg01)
			(object_cannot_take_damage v_bfg02)

			(print "achievement: hidden banshees")
			(submit_incident_with_cause_player "hidden_banshees_achieve" player0)
			(submit_incident_with_cause_player "hidden_banshees_achieve" player1)
			(submit_incident_with_cause_player "hidden_banshees_achieve" player2)
			(submit_incident_with_cause_player "hidden_banshees_achieve" player3)
			
			(sleep_until
				(begin
					(game_save_cancel)
				false)
			30)
		)	
		(begin
			(object_destroy aj_switch_2)
			(soft_ceiling_enable default true)
		)
	)
)

(script static void disable_kill_soft
	(kill_volume_disable kill_soft_00)
	(kill_volume_disable kill_soft_01)
	(kill_volume_disable kill_soft_02)
	(kill_volume_disable kill_soft_03)
	(kill_volume_disable kill_soft_04)
	(kill_volume_disable kill_soft_05)
	(kill_volume_disable kill_soft_06)
	(kill_volume_disable kill_soft_07)
	(kill_volume_disable kill_soft_08)
	(kill_volume_disable kill_soft_09)	
	(kill_volume_disable kill_soft_10)
	(kill_volume_disable kill_soft_11)
	(kill_volume_disable kill_soft_12)
	(kill_volume_disable kill_soft_13)
	(kill_volume_disable kill_soft_14)	
	(kill_volume_disable kill_soft_15)
	(kill_volume_disable kill_soft_16)
	(kill_volume_disable kill_soft_17)
	(kill_volume_disable kill_soft_18)
	(kill_volume_disable kill_soft_19)
	(kill_volume_disable kill_soft_20)
	(kill_volume_disable kill_soft_21)
	(kill_volume_disable kill_soft_22)
	(kill_volume_disable kill_soft_23)
	(kill_volume_disable kill_soft_24)
	(kill_volume_disable kill_soft_25)
	(kill_volume_disable kill_soft_26)
	(kill_volume_disable kill_soft_27)	
)						

(script dormant stairwell_recycle
	(add_recycling_volume tv_gate_attack_garbage 0 0)
	(sleep 1)
	(add_recycling_volume tv_base_assault_garbage01 5 10)
	(sleep 300)	
	(add_recycling_volume tv_base_assault_garbage02 5 10)
	(sleep 300)				
	(add_recycling_volume tv_base_assault_garbage03 5 10)
	(sleep 300)				
	(add_recycling_volume tv_base_assault_garbage04 5 10)	
)
;*
ct_objective_new			= ">>> NEW OBJECTIVE:"
ct_objective_end			= ">>> OBJECTIVE COMPLETE"
ct_objective_shades			= "DESTROY ANTI-AIR SHADES"
ct_objective_destroy			= "DESTROY COVENANT ANTI-AIR TOWERS"
ct_objective_gate			= "ELIMINATE COVENANT GATE DEFENSE"
ct_objective_sword			= "ENTER SWORD BASE"
ct_objective_halsey			= "PROCEEED TO THE COORDINATES"
ct_objective_defend			= "DEFEND HALSEY'S LAB"
ct_objective_enter			= "ENTER HALSEY'S LAB"
PRIMARY_OBJECTIVE_1			= "Destroy the Anti-Air Shades to receive reinforcements"
PRIMARY_OBJECTIVE_2 			= "Eliminate the Anti-Air Towers so that the Spartans can airdrop into Sword Base"
PRIMARY_OBJECTIVE_3			= "Clear out the Sword Base Gate Defense and assault sword base"
PRIMARY_OBJECTIVE_4 			= "Breach sword base with your squad"
PRIMARY_OBJECTIVE_5 			= "Proceed to the coordinates and await further instructions"
PRIMARY_OBJECTIVE_6 			= "Defend Halsey's Lab using the Defensive Systems"
PRIMARY_OBJECTIVE_7 			= "Meet up with Dr. Halsey"
*;