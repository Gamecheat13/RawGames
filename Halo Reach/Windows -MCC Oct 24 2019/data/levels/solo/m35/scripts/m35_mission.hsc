;====================================================================================================================================================================================================
; GLOBAL VARIABLES ================================================================================================================================================
;====================================================================================================================================================================================================
(global boolean editor_cinematics 0)
(global boolean editor_object_management 0)

(global boolean g_play_cinematics TRUE)
(global boolean g_player_training TRUE)

(global boolean debug TRUE)
(global boolean dialogue TRUE)
(global boolean g_music TRUE)

; insertion point index 
(global short g_insertion_index 0)

(global object obj_kat NONE)
(global object obj_jorge NONE)

; objective control global shorts
(global short g_hill_obj_control 0)
(global short g_twin_obj_control 0)
(global short g_facility_obj_control 0)
(global short g_cannon_obj_control 0)
(global short g_falcon_obj_control 0)
(global short g_spire_obj_control 0)

; global waypoint time
(global short b_waypoint_time (* 30 120))
(global short b_easy_waypoint_time (* 30 30))
;(global short b_waypoint_time (* 30 1))

; global booleans
(global boolean g_player_on_foot FALSE)

; mission booleans
(global boolean g_facility_zealot_escaped FALSE)
(global boolean g_bfg01_destroyed FALSE)
(global boolean g_bfg01_core_destroyed FALSE)
(global boolean g_bfg02_destroyed FALSE)
(global boolean g_bfg02_core_destroyed FALSE)
(global boolean g_longswords01_clear FALSE)
(global short g_frigate_position 0)


; starting player pitch 
(global short g_player_start_pitch -16)

(global boolean g_null FALSE)

(global real g_nav_offset 0.55)

(global boolean g_e3 TRUE)

(script static void branch_kill
	(print "branch kill")
)


; global scripts ================================================================================================================================================

(script static void hud_unblip_all
	(f_unblip_object (ai_vehicle_get_from_squad sq_hill_rockethog_01 0))
	(f_unblip_object sc_hud_bfg01_core)
	(f_unblip_object sc_hud_bridge)
	(f_unblip_object sc_hud_bfg02_core)
	(f_unblip_flag fl_falcon_01)
	(f_unblip_object (ai_vehicle_get_from_squad sq_falcon_01 0))
	(f_unblip_object dc_spire_01)
)

; cs globals =====================================================================================================================================================================================

(script command_script abort_cs
	(print "abort_cs")
	(sleep 1)
)

(script command_script sleep_cs
	(sleep_forever)
)

(script static short f_get_waypoint_time_for_difficulty
	; sets waypoint timer to 30 seconds on easy else 120 seconds. used selectively throughout mission
	(if (= (game_difficulty_get_real) easy)
		b_easy_waypoint_time
		b_waypoint_time
	)
)

;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
; MISSION 35 MISSION SCRIPT ==============================================================================================================================================
;====================================================================================================================================================================================================
;====================================================================================================================================================================================================
(script startup m35_startup
	(if debug (print "m35 startup script"))

	; fade out 
	(fade_out 0 0 0 0)
	
	; soft ceilings
	(wake soft_ceilings)
	
	;setup allegiance
	(ai_allegiance human player)
	(ai_allegiance player human)
	
	; health saves
	(wake f_global_health_saves)
	
	; coop initial profiles
	(if (game_is_cooperative)
		(begin
			(unit_add_equipment player0 profile_coop_starting TRUE FALSE)
			(unit_add_equipment player1 profile_coop_starting TRUE FALSE)
			(unit_add_equipment player2 profile_coop_starting TRUE FALSE)
			(unit_add_equipment player3 profile_coop_starting TRUE FALSE)
			
			; coop respawn profile
			(player_set_profile profile_coop_respawn)
		)
	)

	
	(if (and (> (player_count) 0) (not (editor_mode)))
		; if game is allowed to start 
		(start)
			
		; if the game is NOT allowed to start do this 
		(begin 
			(fade_in 0 0 0 0)
			;(wake temp_camera_bounds_off)
		)
	)
	
	(wake m35)
)

(script static void start
	(print "starting")

	(cond
		((= (game_insertion_point_get) 0) (ins_hill))
		((= (game_insertion_point_get) 1) (ins_twin))
		((= (game_insertion_point_get) 2) (ins_facility))
		((= (game_insertion_point_get) 3) (ins_cannon))
		((= (game_insertion_point_get) 4) (ins_falcon))
		((= (game_insertion_point_get) 5) (ins_spire))
		((= (game_insertion_point_get) 10) (ins_blank))
		((= (game_insertion_point_get) 11) (test_setpiece_twin))
		((= (game_insertion_point_get) 9) (test_setpiece_frigate))
	)	
)

(script dormant m35
	
	; turns off player disable
	(player_disable_movement 0)
	
	; vehicle test 
	(wake player_on_foot)
	
	; bob the elite
	(wake bob_start)
	
	; global zone set control 
	(wake zone_set_control)
	
	; global object management
	(wake object_control)
	
	; global garbage collection 
	(wake garbage_collect)
	
	; sky scripts
	;(wake frigate_fire_control_start)
	;(wake frigate_move_control_start)
		
		; === MISSION LOGIC SCRIPT =====================================================		
		
			(sleep_until (>= g_insertion_index 1) 1)
			
			(if (= g_insertion_index 1) (wake enc_hill))
			
			(sleep_until	(or
							(volume_test_players tv_enc_twin)
							(>= g_insertion_index 2)
						)
			1)
			
			(if (<= g_insertion_index 2) (wake enc_twin))	

			(sleep_until	(or
							(= (current_zone_set_fully_active) 4)
							(>= g_insertion_index 3)
						)
			1)
			
			(if (<= g_insertion_index 3) (wake enc_facility))

			(sleep_until	(or
							(volume_test_players tv_enc_cannon)
							(>= g_insertion_index 4)
						)
			1)
			
			(if (<= g_insertion_index 4) (wake enc_cannon))				

			(sleep_until	(or
							(= (current_zone_set_fully_active) 5)
							(>= g_insertion_index 5)
						)
			1)
			
			(if (<= g_insertion_index 5) (wake enc_falcon))
						
			(sleep_until	(or
							(volume_test_players tv_enc_spire)
							(>= g_insertion_index 6)
						)
			1)
			
			(if (<= g_insertion_index 6) (wake enc_spire))
)

; vehicle test ==============================================================================================================================================

(script dormant player_on_foot
	(sleep_until
		(begin
			(if
				(or
					(and
						(= (game_coop_player_count) 1)
						(= (unit_in_vehicle player0) TRUE)
					)
					(and
						(= (game_coop_player_count) 2)
						(and
							(= (unit_in_vehicle player0) TRUE)
							(= (unit_in_vehicle player1) TRUE)
						)
					)
					(and
						(= (game_coop_player_count) 3)
						(and
							(= (unit_in_vehicle player0) TRUE)
							(= (unit_in_vehicle player1) TRUE)
							(= (unit_in_vehicle player2) TRUE)
						)
					)
					(and
						(= (game_coop_player_count) 4)
						(and
							(= (unit_in_vehicle player0) TRUE)
							(= (unit_in_vehicle player1) TRUE)
							(= (unit_in_vehicle player2) TRUE)
							(= (unit_in_vehicle player3) TRUE)
						)
					)
				)
				(set g_player_on_foot FALSE)
				(set g_player_on_foot TRUE)
			)
		FALSE)
	)
)


;====================================================================================================================================================================================================
; HILL ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant enc_hill
	; Play the intro cinematic
	(if (or editor_cinematics (not (editor_mode))) 

		(begin
			(print "Starting intro cinematic!")
			(f_start_mission 035la_bigpush)
		)
	)
	
	; set first segment for competitive time.
	(data_mine_set_mission_segment "m35_01_enc_hill")
	
	; grenade launcher training
	(if (not (game_is_cooperative))
		(wake hill_grenade_launcher_training)
	)
	
	; initial bridge setup
	(object_set_permutation m35_bridge_intro default destroyed_gp)
	
	; kat
	(ai_place sq_hill_kat)
	(ai_cannot_die sq_hill_kat TRUE)
	(set obj_kat (ai_get_unit gr_kat))
	
	; intro hog
	(wake hill_intro_hog)
	
	; coop extra pickup
	(if (>= (game_coop_player_count) 3)
		(object_create v_hill_ghost)
	)
	
	; music
	(wake music_hill)

	; place initial AI + fork_01
	(wake hill_place_01)
	(wake hill_big_battle)
	(sleep 20)
	
	; moar falcons
	(if (not (game_is_cooperative))
		(wake hill_place_02)
	)
	
	; kat control
	(wake kat_control)
	
	; zoneset
	(switch_zone_set set_hill)
	(sleep 1)
	(prepare_to_switch_to_zone_set set_hill_transition)
	
	(cinematic_exit 035la_bigpush TRUE)
	
	; spartans waypoints
	(if (not (game_is_cooperative))
		(wake spartan_waypoints_hill)
	)
	
	; chapter title
	(wake chapter_01_start)
	
	; hill dialogue
	(wake md_hill_intro)
	(wake md_twin_intro)
	
	;BFG
	(wake twin_bfg_start)
	
	;Trigger Volumes =================================

	(sleep_until (volume_test_players tv_hill_01) 1)
	(if debug (print "set objective control 1"))
	(set g_hill_obj_control 1)
		
		(game_save)
	
	(sleep_until (volume_test_players tv_hill_02) 1)
	(if debug (print "set objective control 2"))
	(set g_hill_obj_control 2)
		
		(game_save)		
		
	(sleep_until (volume_test_players tv_hill_03) 1)
	(if debug (print "set objective control 3"))
	(set g_hill_obj_control 3)
		
		(game_save)

	(sleep_until (volume_test_players tv_hill_04) 1)
	(if debug (print "set objective control 4"))
	(set g_hill_obj_control 4)
		
		(game_save)
		
	(sleep_until (volume_test_players tv_hill_05) 1)
	(if debug (print "set objective control 5"))
	(set g_hill_obj_control 5)
		
		
		(game_save)	
		
	(sleep_until (volume_test_players tv_hill_06) 1)
	(if debug (print "set objective control 6"))
	(set g_hill_obj_control 6)
		
		(game_save)				
)


; HILL secondary scripts =======================================================================================================================================

(script dormant hill_place_01
	(if (not (game_is_cooperative))
		(begin
			(ai_place sq_hill_falcon_01)
			(object_ignores_emp (ai_vehicle_get_from_squad sq_hill_falcon_01 0) TRUE)
			(damage_object (ai_vehicle_get_from_squad sq_hill_falcon_01 0) "hull" 400)
			;*
			(ai_place sq_hill_falcon_02)
			(object_ignores_emp (ai_vehicle_get_from_squad sq_hill_falcon_02 0) TRUE)
			(damage_object (ai_vehicle_get_from_squad sq_hill_falcon_02 0) "hull" 300)
			*;
			
			(wake cov_flak_control)
		)
	)
		(sleep 1)	
	(ai_place sq_hill_grunt_01)
	(ai_place sq_hill_grunt_02)
	(ai_place sq_hill_jacks_01)
	(ai_place sq_hill_shades)
		(sleep 1)		
	(ai_place sq_fork_01)
	(ai_place sq_hill_banshees)
	(ai_disregard (ai_actors sq_hill_banshees) TRUE)
		(sleep 1)
	(ai_place sq_hill_elite_01)
	(ai_disregard (ai_actors sq_hill_elite_01) TRUE)
	
	(wake hill_pelican_control)
	(f_ai_magically_see_players obj_hill_cov)
	
	;setting hero character
	(ai_cannot_die sq_hill_kat TRUE)
	
	(sleep_until (>= g_hill_obj_control 3) 30 500)
	(print "ai_disregard Elite: FALSE")
	(ai_disregard (ai_actors sq_hill_elite_01) FALSE)
)

(script command_script cs_hill_kat_start
	;(cs_abort_on_damage TRUE)
	(cs_crouch TRUE)
	(sleep 20)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(sleep 55)
	(cs_use_equipment 2.3)
	
)

(script dormant hill_place_02	
	(ai_place sq_hill_falcon_03)
	(object_ignores_emp (ai_vehicle_get_from_squad sq_hill_falcon_03 0) TRUE)
	(ai_place sq_hill_falcon_04)
	(object_ignores_emp (ai_vehicle_get_from_squad sq_hill_falcon_04 0) TRUE)
	
)

(script dormant hill_pelican_control
	(sleep_until 
		(or
			(and
				(>= g_hill_obj_control 4)
				(<= (ai_living_count sq_hill_shades) 1)
			)
			(and
				(<= (ai_living_count obj_hill_cov) 3)
				(<= (ai_living_count sq_hill_shades) 1)
			)
			(<= (ai_living_count sq_hill_shades) 0)
		)
	)
	(print "placing pelican")
	(ai_place sq_hill_pelican_01)
	(ai_disregard (ai_vehicle_get_from_squad sq_hill_pelican_01 0) TRUE)
	(sleep_until 
		(and 
			(<= (ai_living_count sq_hill_shades) 0)
			(>= g_hill_obj_control 4)
		)
	)
	(cs_run_command_script (f_ai_get_vehicle_driver sq_hill_pelican_01) cs_pelican_01_drop)
	(game_save)
)

(script dormant cov_flak_control
	;(sleep_until (> (unit_get_health (ai_get_unit sq_fork_01_grunt_01)) 0))
	(print "cov_flak_control: setting targetting group")
	(ai_set_targeting_group sq_hill_shades 2)
	(ai_set_targeting_group sq_hill_pelican_01 2)
	(sleep_until
		(or
			(>= g_hill_obj_control 3)
			(<= (ai_living_count obj_hill_cov/shades) 1)
			(<= (ai_living_count sq_hill_elite_01/elite) 0)
			(<= (ai_living_count obj_hill_cov) 10)
		)
	)
	(print "cov_flak_control: re-setting targetting group")
	(ai_set_targeting_group sq_hill_shades -1)
	(f_ai_magically_see_players sq_hill_shades)
	(ai_set_targeting_group sq_hill_pelican_01 -1)
)

(script dormant hill_big_battle
	(wake flocks_01_start)
	(wake sky_scarab01_start)
	(sleep 60)
	(wake sky_scarab02_start)
	(sleep 60)
	(wake sky_scarab03_start)
)

(script command_script cs_hill_shades
	(ai_disregard (ai_actors ai_current_actor) TRUE)
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point TRUE ps_hill_shades/p0)
				(cs_shoot_point TRUE ps_hill_shades/p1)
				(cs_shoot_point TRUE ps_hill_shades/p2)
				(cs_shoot_point TRUE ps_hill_shades/p3)
				(cs_shoot_point TRUE ps_hill_shades/p4)
			)
			(>= g_hill_obj_control 3)
			)
	30 250)
	(cs_enable_targeting TRUE)
	(ai_disregard (ai_actors ai_current_actor) FALSE)
	(ai_magically_see_object ai_current_actor (ai_vehicle_get_from_squad sq_hill_falcon_01 0))
	;(ai_magically_see_object ai_current_actor (ai_vehicle_get_from_squad sq_hill_falcon_02 0))
	(f_ai_magically_see_players ai_current_actor)
	(print "shades done shooting points")
)

(script dormant hill_intro_hog
	(object_create v_hill_intro_hog)
	(sleep 1)
	(object_dynamic_simulation_disable v_hill_intro_hog TRUE)
	(damage_object v_hill_intro_hog "hull" 400)
	(sleep_until (< (objects_distance_to_object (players) v_hill_intro_hog) 3) 5 80)
	;(sleep 90)
	(object_dynamic_simulation_disable v_hill_intro_hog FALSE)
	(unit_kill v_hill_intro_hog)
)

(script dormant hill_grenade_launcher_training
	(branch
		(unit_action_test_rotate_weapons player0)
		(branch_kill_launcher_training)
	)
	(sleep 200)
	(f_hud_training_new_weapon)
)

(script static void branch_kill_launcher_training
	(chud_clear_hs_variable player0 0)
	(chud_clear_hs_variable player1 0)
	(chud_clear_hs_variable player2 0)
	(chud_clear_hs_variable player3 0)
)

; hill falcons =====================================================================================================================================================================================
(script command_script cs_hill_falcon_01
	(ai_set_targeting_group ai_current_actor 2)
	(cs_fly_by ps_hill_falcons/p0)
	(cs_vehicle_speed .8)
	(cs_fly_by ps_hill_falcons/p1)
	(cs_face TRUE ps_hill_falcons/p2)
	(damage_object (ai_vehicle_get ai_current_actor) "hull" 100)
	(cs_vehicle_speed .2)
	(sleep 30)
	(cs_fly_by ps_hill_falcons/p4 1)
	(cs_vehicle_speed .5)
	(sleep 30)
	(cs_fly_by ps_hill_falcons/p1 1)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_hill_falcons/p2)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_hill_falcon_02
	(ai_set_targeting_group ai_current_actor 2)
	(cs_fly_by ps_hill_falcons/p3)
	;(cs_vehicle_speed .8)
	(cs_fly_by ps_hill_falcons/p4)
	(damage_object (ai_vehicle_get ai_current_actor) "hull" 100)
	;(cs_vehicle_speed 1)
	(cs_fly_by ps_hill_falcons/p2)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_hill_falcon_03
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	;(damage_object (ai_vehicle_get ai_current_actor) "hull" 100)
	(sleep (random_range 430 530))
	(unit_kill (ai_vehicle_get ai_current_actor))
	;*
	(sleep (random_range 400 500))
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
	*;
)

(script command_script cs_hill_falcon_04
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(damage_object (ai_vehicle_get ai_current_actor) "hull" 100)
	(sleep (random_range 330 430))
	(unit_kill (ai_vehicle_get ai_current_actor))
)

; banshees =====================================================================================================================================================================================
(script command_script cs_hill_banshees
	(cs_vehicle_boost TRUE)
	;(ai_prefer_target_ai ai_current_actor gr_spartans TRUE)
	(sleep (random_range 60 70))
	(cs_vehicle_boost FALSE)
	(print "cs banshees: boost done")
	;(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	;(cs_enable_targeting TRUE)
	
	;*
	(begin_random_count 1
		(cs_shoot_secondary_trigger TRUE)
		(cs_shoot_secondary_trigger TRUE)
		(cs_shoot_secondary_trigger FALSE)
	)
	*;
	;(cs_shoot TRUE gr_spartans)
	
	(print "cs banshees: shoot")
	;(cs_shoot_point TRUE ps_hill_banshees/p0)
	;(sleep_forever)
	
	;(begin_random_count 1
	(begin_random
		(cs_shoot_point TRUE ps_hill_banshees/p0)
		(cs_shoot_point TRUE ps_hill_banshees/p1)
		(cs_shoot_point TRUE ps_hill_banshees/p2)
		(cs_shoot_point TRUE ps_hill_banshees/p3)
		(cs_shoot_point TRUE ps_hill_banshees/p4)
		(cs_shoot_point TRUE ps_hill_banshees/p5)
		(cs_shoot_point TRUE ps_hill_banshees/p6)
	)
	(sleep (random_range 60 110))
	
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_hill_banshees/fly_by_01 10)
	(cs_fly_by ps_hill_banshees/fly_by_02 10)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)


; fork_01 =====================================================================================================================================================================================

(script command_script cs_fork_01

	(if debug (print "fork 01"))
		
	; == spawning ====================================================
		;(f_load_fork (ai_vehicle_get ai_current_actor) "left" none sq_fork_01_grunt_01 sq_fork_01_grunt_02 none)
		(f_load_fork (ai_vehicle_get ai_current_actor) "left" none none sq_fork_01_grunt_02 none)
		
		; force all AI active 
		(ai_force_active gr_fork_01 TRUE)

		; set the objective
		(ai_set_objective gr_fork_01 obj_hill_cov)

	; start movement 
			;(cs_vehicle_boost TRUE)
		;(cs_fly_by ps_fork_01/approach_01 1)
			;(cs_vehicle_boost FALSE)
		;(cs_fly_by ps_fork_01/approach_02 1)		
		;(cs_fly_by ps_fork_01/approach_03 1)				
			;(cs_vehicle_speed .75) 

	; == begin drop ====================================================
		(cs_fly_to_and_face ps_fork_01/hover_01 ps_fork_01/face_01 1)
			(unit_open (ai_vehicle_get ai_current_actor))
		(cs_fly_to_and_face ps_fork_01/drop_01 ps_fork_01_end/face_01 1)
			
		;drop 
		(f_unload_fork (ai_vehicle_get ai_current_actor) "left")		
		
			(cs_vehicle_speed 1)
			
		(cs_fly_to_and_face ps_fork_01/hover_01 ps_fork_01/face_01 1)	
		(unit_close (ai_vehicle_get ai_current_actor))
			(sleep 15)
			
		(cs_vehicle_speed .5) 			
	(cs_fly_by ps_fork_01/exit_01)
		(cs_vehicle_speed 1)	
	(cs_fly_by ps_fork_01/exit_02)
	(cs_fly_by ps_fork_01/exit_03)	
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_fork_01/erase)
	(ai_erase ai_current_squad)
)

; pelican_01 =====================================================================================================================================================================================

(script command_script cs_pelican_01

	(print "pelican_01")
		
	; == spawning ====================================================
		(f_load_pelican_cargo (ai_vehicle_get ai_current_actor) "large" sq_hill_rockethog_01 none)
		(wake hill_hog_setup)
		(wake hog_hill_driver)
		
		(cs_run_command_script (ai_get_turret_ai ai_current_actor 0) cs_pelican_01_drop_turret)
		
		(cs_vehicle_boost TRUE)
		;(cs_fly_by ps_pelican_01/approach_01)
		(cs_fly_to_and_face ps_pelican_01/approach_01 ps_pelican_01/face_01)
		(cs_vehicle_boost FALSE)
		(cs_vehicle_speed .5)
	
		(sleep_until
			(begin
				(begin_random
					(cs_fly_to_and_face ps_pelican_01/evade_01 ps_pelican_01/face_01)
					(cs_fly_to_and_face ps_pelican_01/evade_02 ps_pelican_01/face_01)
					(sleep (random_range 0 10))
				)
			0)
		)
)


(script command_script cs_pelican_01_drop

	(if debug (print "pelican_01_drop"))
	(cs_run_command_script (ai_get_turret_ai ai_current_actor 0) abort_cs)
	(cs_fly_to ps_pelican_01/approach_01)
	(cs_vehicle_speed .6)
	
	; == begin drop ====================================================
		(cs_fly_to_and_face ps_pelican_01/drop_01 ps_pelican_01/face_01 1)
		(sleep_until (not (volume_test_players tv_hill_hog_drop)) 5)
			
		;drop 
		(f_unload_pelican_cargo (ai_vehicle_get ai_current_actor) "large")
		(wake hill_hog_blip)
		
		(sleep_until (volume_test_players tv_hill_hog_drop) 30 (* 30 20))
		
		(sleep 60)
		;(cs_fly_by ps_pelican_01/approach_01)
		(cs_vehicle_speed 1)
		(cs_fly_by ps_hill_falcons/p2)
		(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)

(script command_script cs_pelican_01_drop_turret
	(sleep_until
		(begin
			(if (not (volume_test_players tv_hill_kat))
				(begin_random
					(cs_shoot_point TRUE ps_pelican_01/shoot_01)
					(cs_shoot_point TRUE ps_pelican_01/shoot_02)
					(cs_shoot_point TRUE ps_pelican_01/shoot_03)
					(cs_shoot_point TRUE ps_pelican_01/shoot_04)
				)
				(cs_shoot_point TRUE ps_pelican_01/shoot_air)
			)
		0)
	)
)

(script dormant hill_hog_setup
	(branch
		(<= (object_get_health (ai_vehicle_get_from_squad sq_hill_rockethog_01 0)) 0)
		(branch_kill)
	)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_d" TRUE)
	(sleep_until (player_in_vehicle (ai_vehicle_get_from_squad sq_hill_rockethog_01 0)))
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_d" FALSE)
	
	(if (not (game_is_cooperative))
		(ai_player_add_fireteam_squad player0 sq_hill_rockethog_01/gunner01)
	)
	
	(sleep_until
		(begin
			(sleep_until (not (player_in_vehicle (ai_vehicle_get_from_squad sq_hill_rockethog_01 0))))
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_d" TRUE)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_p" TRUE)
			(vehicle_unload (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_d")
			(vehicle_unload (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_p")
			(sleep_until (player_in_vehicle (ai_vehicle_get_from_squad sq_hill_rockethog_01 0)))
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_d" FALSE)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_p" FALSE)
			(game_save)
			FALSE
		)
	)
	
)

(script dormant hill_hog_blip
	(f_blip_object_offset (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) blip_default 1)
	;(wake md_hill_hog)
	
	(sleep_until
		(or
			(player_in_vehicle (ai_vehicle_get_from_squad sq_hill_rockethog_01 0))
			(volume_test_players tv_enc_twin)
		)
	)
	(f_unblip_object (ai_vehicle_get_from_squad sq_hill_rockethog_01 0))
)

;====================================================================================================================================================================================================
; TWIN ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant enc_twin
	; set second mission segment
	(data_mine_set_mission_segment "m35_02_enc_twin")
	
	; exit bundle
	(wake twin_01)
	(wake twin_waypoints)
	
	; wraith fx bombardment
	(wake twin_wraith_fx)
	
	; twin dialogue
	(wake md_twin_gun_in_range)
	(wake md_twin_gun_info_02)
	(wake md_facility_intro)
	
	; ai lod
	(ai_lod_full_detail_actors 15)
	
	; initial AI
	(wake twin_place_01)
	
	; objective
	(ai_set_objective gr_allies obj_twin_allies)
	
	; hog driving
	(wake hog_twin_driver)
	
	; bob the elite
	(if (= g_bob_number 1)
		(ai_place sq_twin_bob)
	)
	
	; saving script
	;(wake twin_save)
	
	;twin exit bridge
	(wake twin_bridge)
	
	;music
	(wake music_twin)
	
	;Trigger Volumes =================================

	(sleep_until (volume_test_players tv_twin_01) 5)
	(if debug (print "set objective control 1"))
	(set g_twin_obj_control 1)
	
		(ai_set_objective gr_hill_allies obj_twin_allies)
		
		(wake twin_place_02)
		(wake twin_place_02b)
		
		; removing of previous AI
		(ai_disposable gr_hill_cov TRUE)
		(ai_disposable gr_hill_cov TRUE)
		
		;(game_save)
		
	(sleep_until (or g_bfg01_core_destroyed (volume_test_players tv_twin_02)) 5)
	(if debug (print "set objective control 2"))
	(set g_twin_obj_control 2)

		(game_save)	
		
	(sleep_until g_bfg01_core_destroyed 5)
	; set third mission segment
	(data_mine_set_mission_segment "m35_03_bfg01_core_destroyed")
	(if debug (print "set objective control 3"))
	(set g_twin_obj_control 3)
	
		;brings phantom sacrifice
		(wake twin_place_03)
		(wake twin_place_04)
		
		(game_save)
	
	(sleep_until (volume_test_players tv_twin_upper) 5)
	(if debug (print "set objective control 4"))
	(set g_twin_obj_control 4)
		
		(game_save)
		
	(sleep_until (volume_test_players tv_twin_05) 5)
	(if debug (print "set objective control 5"))
	(set g_twin_obj_control 5)
	
		; place final skirms
		(wake twin_place_05)
		
		; hog driving
		(wake hog_twin_exit_driver)
	
	(game_insertion_point_unlock 2)

		(game_save)		

)

; TWIN secondary scripts =======================================================================================================================================

(script dormant twin_place_01

	(ai_place sq_twin_grunt_02)
		(sleep 1)	
	(ai_place sq_twin_skirmisher_01)
	(ai_place sq_twin_skirmisher_02)
		(sleep 1)	
	(ai_place sq_twin_jackal_watch)
	
	;vehicles
	(ai_place sq_twin_rev_01)
		(sleep 5)
	
	(if (<= (game_coop_player_count) 2)
		(begin
			(ai_place sq_twin_cov_02)
			(ai_place sq_twin_ghost_02)
				(sleep 1)
			(ai_place sq_twin_ghost_01)
		)
		(begin
			(ai_place sq_twin_cov_02_3coop)
		)
	)
	
)

(script dormant twin_place_02
	(ai_place sq_phantom_03)

)

(script dormant twin_place_02b
	(sleep_until (volume_test_players tv_twin_lower_final) 5)
	(ai_place sq_twin_grunt_01b)
		(sleep 1)
	(ai_place sq_twin_jackal_01)
	(ai_place sq_twin_elite_01)
	
	(if (<= (game_coop_player_count) 2)
		(ai_place sq_twin_grunt_01)
		(ai_place sq_twin_elite_3coop)
	)
)


(script dormant twin_place_03
	(if (>= (game_coop_player_count) 3)
		(sleep_forever)
	)
	
	(sleep (random_range 280 330))
	(ai_place sq_phantom_03)
	(object_set_scale (ai_vehicle_get_from_squad sq_phantom_03 0) .01 0)
	(object_set_scale (ai_vehicle_get_from_squad sq_phantom_03 0) 1 90)
)

(script dormant twin_place_04
	(sleep_until g_bfg01_destroyed 5)
	;brings in final cov- delay for perf reasons
	(sleep 120)
	(ai_place sq_twin_phantom_final)
	
	(game_save)
	
	(sleep_until (>= (device_get_position dm_pelican) .3))
	(cs_run_command_script (ai_get_turret_ai sq_twin_phantom_final 0) cs_twin_phantom_turret)
	
	(sleep_until (<= (ai_living_count sq_twin_wraith_01) 0))
	(cs_run_command_script (f_ai_get_vehicle_driver sq_twin_phantom_final) cs_twin_phantom_final_exit)
	(game_save)

)


(script dormant twin_place_05
	(ai_place sq_facility_intro_cov)

)


; Twin Saves =======================================================================================================================================
(script dormant twin_save
	(branch
		(>= g_twin_obj_control 3)
		(branch_kill)
	)
	
	(sleep_until
		(begin	
			(sleep (* 30 60))
			(game_save)
			FALSE
		)
	)

)


; phantom_03 =====================================================================================================================================================================================

(script command_script cs_phantom_03

	; == spawning ====================================================		
		
		;(ai_force_active gr_phantom_03 TRUE)
			
	; == seating ====================================================
		(cond
			((not g_bfg01_core_destroyed)
				(begin
					(print "phantom 03")
					(ai_place sq_phantom_03_cov_01)
					(ai_place sq_phantom_03_cov_02)
					(ai_vehicle_enter_immediate sq_phantom_03_cov_01 (ai_vehicle_get ai_current_actor) "phantom_p_lb")	
					(ai_vehicle_enter_immediate sq_phantom_03_cov_02 (ai_vehicle_get ai_current_actor) "phantom_p_lf")
				)
			)
			(g_bfg01_core_destroyed
				(begin
					(print "phantom 04")
				)
			)
		)
		
			(sleep 1)

		; set the objective
		(ai_set_objective gr_phantom_03 obj_twin_cov)

	; start movement 
			;(cs_vehicle_boost TRUE)
		;(cs_fly_by ps_phantom_03/approach_01 1)
			;(cs_vehicle_boost FALSE)
		(cs_fly_by ps_phantom_03/approach_02 1)
		
			(cs_vehicle_speed .75) 				

	; == begin drop ====================================================
		(cs_fly_to_and_face ps_phantom_03/hover_01 ps_phantom_03/face_01 1)
			(unit_open (ai_vehicle_get ai_current_actor))
			(sleep 30)
		(cs_fly_to_and_face ps_phantom_03/drop_01 ps_phantom_03/face_01 1)
			
		;drop		
		(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_lf")
		(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_p_lb")
		(sleep 150)
		
		
		(cs_fly_by ps_phantom_03/run_01 1)		
		;*
	; == begin drop ====================================================
		(cs_fly_to_and_face ps_phantom_03/hover_02 ps_phantom_03/face_02 1)
			(sleep 30)
		(cs_fly_to_and_face ps_phantom_03/drop_02 ps_phantom_03/face_02 1)
			
		;drop		
		(vehicle_unload phantom_03 "phantom_p_lb")
		(sleep 85)		
		*;
			(cs_vehicle_speed 1)
			
		;(cs_fly_to_and_face ps_phantom_03/hover_02 ps_phantom_03/face_02 1)	
		(unit_close (ai_vehicle_get ai_current_actor))
			(sleep 15)
			
	(cs_fly_by ps_phantom_03/exit_01)
	(cs_fly_by ps_phantom_03/exit_02)
	(cs_fly_by ps_phantom_03/exit_03)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_phantom_03/erase)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
)


; twin_Phantom_final =======================================================================================================================================

(script command_script cs_twin_phantom_final
	(set b_debug_phantom TRUE)
	(print "twin_phantom_final")
	(f_load_phantom (ai_vehicle_get ai_current_actor) "right" sq_twin_skirmisher_03 none none none)
	(f_load_phantom_cargo (ai_vehicle_get ai_current_actor) "single" sq_twin_wraith_01 none)
	(cs_run_command_script sq_twin_wraith_01 abort_cs)
	
	
	;(ai_place sq_phantom_03_cov_02)
	;(ai_vehicle_enter_immediate sq_phantom_03_cov_01 (ai_vehicle_get ai_current_actor) "phantom_p_lb")	
	
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_twin_phantom_final/p0 1)
	(cs_vehicle_boost FALSE)
	(cs_fly_to_and_face ps_twin_phantom_final/p1 ps_twin_phantom_final/p2 1)
	
	(sleep 30)
	(f_unload_phantom_cargo (ai_vehicle_get ai_current_actor) "single")
	(f_unload_phantom (ai_vehicle_get ai_current_actor) "right")
	(sleep 40)
	(cs_run_command_script sq_twin_wraith_01/driver01 cs_twin_wraith_01)
	
)

(script command_script cs_twin_phantom_turret
	(cs_shoot TRUE dm_pelican)
	(sleep_until (>= (device_get_position dm_pelican) .7))
	
)

(script command_script cs_twin_phantom_final_exit
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_twin_phantom_final/p0 1)
	(cs_fly_by ps_twin_phantom_final/p3 1)
	
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
	
)


; Wraith FX =======================================================================================================================================
(script dormant twin_wraith_fx
	(sleep_until 
		(or
			(<= (ai_task_count obj_twin_cov/gt_lower_center) 0)
			(volume_test_players tv_twin_lower_final)
		)
	)
	(sleep_until
		(begin
			(sleep_until (volume_test_players tv_twin_lower) 5)
			(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" ps_fx_twin_wraith/p0 7 3)
			(sleep (random_range 60 120))
			(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" ps_fx_twin_wraith/p1 7 3)
			(sleep (random_range 90 150))
		g_bfg01_core_destroyed)
	)
)			

; Banshee =======================================================================================================================================
(global short g_twin_banshee 0)

(script command_script cs_twin_banshee_lower
		(cs_enable_targeting TRUE)
		(cs_enable_looking TRUE)
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_twin_banshee/lower_run_01)
	(cs_fly_by ps_twin_banshee/lower_run_02)
	(cs_fly_by ps_twin_banshee/lower_run_03)
	;(cs_fly_by ps_twin_banshee/lower_run_04)
	(cs_fly_by ps_twin_banshee/lower_run_05)
	(cs_fly_by ps_twin_banshee/lower_run_06)	
		(cs_vehicle_boost FALSE)
)

(script command_script cs_twin_banshee_upper
		(cs_enable_targeting TRUE)
		(cs_enable_looking TRUE)
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_twin_banshee/upper_run_01)
	(cs_fly_by ps_twin_banshee/upper_run_02)
	(cs_fly_by ps_twin_banshee/upper_run_03)
	(cs_fly_by ps_twin_banshee/upper_run_04)
	(cs_fly_by ps_twin_banshee/upper_run_05)
		(cs_vehicle_boost FALSE)
)

(script command_script cs_twin_banshee_exit
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_twin_banshee/exit_01)
	(cs_fly_by ps_twin_banshee/exit_02)
	(cs_fly_by ps_twin_banshee/exit_03)
	(cs_fly_by ps_twin_banshee/erase)
	(ai_erase ai_current_squad)
)

; TWIN WRAITH scripts =======================================================================================================================================
(script command_script cs_twin_wraith_01
	(cs_abort_on_damage TRUE)
	
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot_point TRUE ps_twin_wraith/p0)
				(cs_shoot_point TRUE ps_twin_wraith/p1)
				(cs_shoot_point TRUE ps_twin_wraith/p2)
				(cs_shoot_point TRUE ps_twin_wraith/p3)
				(cs_shoot_point TRUE ps_twin_wraith/p4)
				(cs_shoot_point TRUE ps_twin_wraith/p5)
			)
			(sleep 120)
		(volume_test_players tv_twin_upper_center)
		)
	)
	(f_ai_magically_see_players ai_current_actor)
)

(script static void twin_wraith_fight
	(f_ai_magically_see_players ai_current_actor)
	(game_save)
)

; falcon_01 =====================================================================================================================================================================================

(script command_script cs_twin_falcon_01
	(ai_set_targeting_group ai_current_actor 2)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	
	;*
	(begin_random_count 1
		(object_teleport_to_ai_point (ai_vehicle_get ai_current_actor)  ps_twin_falcon_01/t1)
		(object_teleport_to_ai_point (ai_vehicle_get ai_current_actor)  ps_twin_falcon_01/t2)
		(object_teleport_to_ai_point (ai_vehicle_get ai_current_actor)  ps_twin_falcon_01/t3)
	)
	*;
	
	(object_set_velocity (ai_vehicle_get ai_current_actor) 5 0 10)
	;(cs_face TRUE ps_twin_falcon_01/face)
	
	(cs_fly_by ps_twin_falcon_01/start)
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_fly_by ps_twin_falcon_01/p0)
				(cs_fly_by ps_twin_falcon_01/p1)
				(cs_fly_by ps_twin_falcon_01/p2)
			)
		0)
	60)
	
)


; TWIN BFG scripts =======================================================================================================================================
(script dormant twin_bfg_start
	(sleep_until (= (current_zone_set_fully_active) 2))
	
	(wake twin_bfg_target_control)
	
	(sleep_until (object_model_target_destroyed (ai_vehicle_get_from_squad sq_twin_bfg_driver 0) "target_core"))
	(print "bfg01_core_destroyed")
	
	(set g_bfg01_core_destroyed TRUE)
	
	(sleep (* 16 30))
	(print "bfg01_destroyed")
	(set g_bfg01_destroyed TRUE)
	
	(game_save)
	
)

(script dormant twin_bfg_target_control
	(ai_place sq_twin_bfg_driver)
	(wake twin_bfg_failsafe)
	(ai_set_targeting_group sq_twin_bfg_driver 2)
	;(ai_disregard (ai_actors sq_twin_bfg_driver) TRUE)
	(object_set_persistent (ai_vehicle_get_from_squad sq_twin_bfg_driver 0) TRUE)
	(cs_run_command_script sq_twin_bfg_driver cs_twin_bfg_shoot)
	
	(if (not (game_is_cooperative))
		(wake twin_falcon_control)
	)

)

(script dormant twin_falcon_control
	(sleep_until (>= g_twin_obj_control 1))
	(ai_place sq_twin_falcon_01)
	(ai_set_targeting_group sq_twin_falcon_01/driver01 2)
	
	(sleep 200)
	(cs_run_command_script sq_twin_bfg_driver abort_cs)
	
	(sleep_until (<= (ai_task_count obj_twin_allies/gt_falcons) 0))
	(cs_run_command_script sq_twin_bfg_driver cs_twin_bfg_shoot)
	
	(sleep 200)
	(ai_place sq_twin_falcon_02)
	(ai_set_targeting_group sq_twin_falcon_02/driver01 2)
	(sleep 200)
	(cs_run_command_script sq_twin_bfg_driver abort_cs)
	
	(sleep_until (<= (ai_task_count obj_twin_allies/gt_falcons) 0))
	(cs_run_command_script sq_twin_bfg_driver cs_twin_bfg_shoot)
	
)

(script dormant twin_bfg_failsafe
	(sleep_until (< (object_get_health (ai_vehicle_get_from_squad sq_twin_bfg_driver 0)) .5))
	(ai_disregard (ai_actors sq_twin_bfg_driver) TRUE)
)

(script command_script cs_twin_bfg_shoot
	(if  (= g_twin_obj_control 0)
		(begin
			(cs_shoot_point TRUE ps_twin_bfg/p0)
			(sleep_until (>= g_twin_obj_control 1) 5)
			(cs_aim TRUE ps_twin_bfg/p0)
			(sleep 90)
			(cs_aim FALSE ps_twin_bfg/p0)
			(print "BFG done standing still")
		)
	)
	
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point TRUE ps_twin_bfg/p0)
				(cs_shoot_point TRUE ps_twin_bfg/p1)
				(cs_shoot_point TRUE ps_twin_bfg/p2)
			)
			FALSE
		)
	)
)

(script dormant twin_bfg_flash
	(print "UI flashing BFG01")
	(f_hud_flash_object sc_hud_highlight_bfg01)
	(f_blip_title sc_hud_bfg "WP_CALLOUT_M35_BFG")
)


; TWIN exit scripts =======================================================================================================================================

;twin_01 
(script dormant twin_01
	(sleep_until g_bfg01_core_destroyed 5)
	(if debug (print "twin_01 complete"))
	;(sleep 90)
	
	;frigates
	(wake frigate_setup)
	
	;banshee retreat
	(set g_twin_banshee 2)

)

; TWIN bridge scripts =======================================================================================================================================

(script dormant twin_bridge
	(sleep_until (>= (current_zone_set_fully_active) 3) 1)
	(objects_attach dm_pelican "" dm_bridge "")
	(device_set_position_track dm_pelican m35_device_position 0)
	
	;wait for playe to enter last space
	(sleep_until (>= g_twin_obj_control 4) 5)
	
	(print "bridge incoming")
	(wake md_twin_bridge)
	(wake md_twin_bridge_02)

	(device_animate_position dm_pelican 1.0 40.0 1.0 1.0 TRUE)
	
	(sleep_until (>= (device_get_position dm_pelican) .48) 1)
	
	(print "drop")
	(objects_detach dm_pelican dm_bridge)
	(device_set_position dm_bridge 1)

)

; TWIN Waypoints =======================================================================================================================================
(script dormant twin_waypoints
	(branch
		(>= g_twin_obj_control 5)
		(hud_unblip_all)
	)

	(if (= (game_difficulty_get_real) easy)
		; The game difficulty is easy so being more aggressive with waypoint behavior
		(begin
			(sleep_until (>= g_twin_obj_control 1) 30)
			(f_blip_object sc_hud_bfg01_core blip_neutralize)
			(sleep_until g_bfg01_core_destroyed)
			(hud_unblip_all)
		)
	)
	
	(if (!= (game_difficulty_get_real) easy)
		(sleep_until (>= g_twin_obj_control 1) 30 b_waypoint_time)
		(if (not (>= g_twin_obj_control 1))
			(begin
				(f_blip_object sc_hud_bfg01_core blip_neutralize)
				(sleep_until g_bfg01_core_destroyed)
				(hud_unblip_all)
			)
		)
	)
	
	(sleep_until (>= g_twin_obj_control 2) 30 b_waypoint_time)
	(if (not (>= g_twin_obj_control 2))
		(begin
			(f_blip_object sc_hud_bfg01_core blip_neutralize)
			(sleep_until g_bfg01_core_destroyed)
			(hud_unblip_all)
		)
	)
	
	;sleep for twice the waypoint time
	(sleep_until g_bfg01_core_destroyed 30 b_waypoint_time)
	(sleep_until g_bfg01_core_destroyed 30 b_waypoint_time)
	(if (not g_bfg01_core_destroyed)
		(begin
			(wake md_twin_gun_info_03)
			(sleep_until g_bfg01_core_destroyed)
			(sleep 30)
			(hud_unblip_all)
		)
	)
	(game_save)
	
	; The game difficulty is easy so being more aggressive with waypoint behavior. This will pop after 30 seconds rather than 120
	(sleep_until (>= g_twin_obj_control 5) 30 (f_get_waypoint_time_for_difficulty))
	(if (not (>= g_twin_obj_control 5))
		(begin
			(f_blip_object sc_hud_bridge blip_default)
			(sleep_until (>= g_twin_obj_control 5))
			(hud_unblip_all)
		)
	)
	(game_save)
	
)
	
;====================================================================================================================================================================================================
; FACILITY ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant enc_facility
	; set fourth mission segment
	(data_mine_set_mission_segment "m35_04_enc_facility")
	
	; ai lod
	(ai_lod_full_detail_actors 20)

	; initial AI 
	(wake facility_place_01)
	(wake facility_place_02)
	(wake facility_place_03)
	(wake facility_place_04)
	(wake facility_game_saves)
	
	; objective
	(ai_set_objective gr_allies obj_facility_allies)
	
	; facility dialogue 
	(wake md_facility_elite)
	(wake md_facility_end)
	
	; music
	(wake music_facility)
	
	; hologram training
	(wake facility_hologram_training)
	
	; blip launcher
	(wake facility_launcher_blip)
	
	;BFG
	(wake cannon_bfg_start)
	
	; wraith FX
	(wake facility_wraith_fx)
	
	; hog driving
	(wake hog_facility_driver)
	
	;Trigger Volumes =================================

	(sleep_until (volume_test_players tv_facility_01) 1)
	(if debug (print "set objective control 1"))
	(set g_facility_obj_control 1)
		
		; removing of previous AI
		(ai_disposable gr_twin_cov TRUE)
		
		(game_save)
	
	(sleep_until (or (volume_test_players tv_facility_02) (volume_test_players tv_facility_03)) 1)
	(if debug (print "set objective control 2"))
	(set g_facility_obj_control 2)

		(game_save)
	
	(sleep_until (volume_test_players tv_facility_03) 1)
	(if debug (print "set objective control 3"))
	
	;========== BXR Mining company Easter Egg Achievement ==========
	(submit_incident_with_cause_player "bxr_mining_achieve" player0)
	(submit_incident_with_cause_player "bxr_mining_achieve" player1)
	(submit_incident_with_cause_player "bxr_mining_achieve" player2)
	(submit_incident_with_cause_player "bxr_mining_achieve" player3)	
	;===============================================================
	
	(set g_facility_obj_control 3)
		
		(game_save)
	
	(sleep_until (or (volume_test_players tv_facility_04) (volume_test_players tv_facility_11)) 1)
	(if debug (print "set objective control 4"))
	(set g_facility_obj_control 4)
		
		(game_save)
	
	(sleep_until (or (volume_test_players tv_facility_05) (volume_test_players tv_facility_11)) 1)
	(if debug (print "set objective control 5"))
	(set g_facility_obj_control 5)
		
		(game_save)
	
	(sleep_until (or (volume_test_players tv_facility_06) (volume_test_players tv_facility_11)) 1)
	(if debug (print "set objective control 6"))
	(set g_facility_obj_control 6)
	
		; AI placement
		;(wake facility_place_02)
		
		(game_save)
	
	(sleep_until (or (volume_test_players tv_facility_07) (volume_test_players tv_facility_11)) 1)
	(if debug (print "set objective control 7"))
	(set g_facility_obj_control 7)
		
		(game_save)
	
	(sleep_until (or (volume_test_players tv_facility_08) (volume_test_players tv_facility_11)) 1)
	(if debug (print "set objective control 8"))
	(set g_facility_obj_control 8)
		
		(game_save)
	
	(sleep_until (or (volume_test_players tv_facility_09) (volume_test_players tv_facility_11)) 1)
	(if debug (print "set objective control 9"))
	(set g_facility_obj_control 9)
		
		(game_save)
	
	(sleep_until (or (volume_test_players tv_facility_10) (volume_test_players tv_inner_bypass)) 1)	
	(if debug (print "set objective control 10"))
	(set g_facility_obj_control 10)
		
		
		(game_save)																												
	
	(sleep_until (or (volume_test_players tv_facility_11) (volume_test_players tv_inner_bypass)) 1)
	(if debug (print "set objective control 11"))
	(set g_facility_obj_control 11)
		
		(game_save)
	
	(sleep_until (or (volume_test_players tv_facility_12) (volume_test_players tv_inner_bypass)) 1)
	(if debug (print "set objective control 12"))
	(set g_facility_obj_control 12)
		
		;placing garage AI
		;(wake facility_place_04)
		
		(game_save)
	
	(sleep_until (or (volume_test_players tv_facility_13) (volume_test_players tv_inner_bypass)) 1)
	(if debug (print "set objective control 13"))
	(set g_facility_obj_control 13)
		
		(ai_player_remove_fireteam_squad player0 sq_facility_allies_01)
		(ai_player_remove_fireteam_squad player0 sq_facility_allies_02)
		(ai_player_remove_fireteam_squad player0 gr_allies)
		;placing zealot
		;(wake facility_place_03)
		
		(game_save)

	(sleep_until (volume_test_players tv_facility_14) 1)
	(if debug (print "set objective control 14"))
	(set g_facility_obj_control 14)
		
		(game_save)
	
	(sleep_until (volume_test_players tv_facility_15) 1)
	(if debug (print "set objective control 15"))
	(set g_facility_obj_control 15)
	
		;fireteam test end 
		;(ai_player_remove_fireteam_squad (player0) sq_facility_fireteam)		
		
		(game_save)
	
	(sleep_until (volume_test_players tv_facility_16) 1)
	(if debug (print "set objective control 16"))
	(set g_facility_obj_control 16)
	
	(set g_music03 TRUE)
		
		(game_save)		
)

; FACILITY secondary scripts =======================================================================================================================================
(script dormant facility_game_saves
	;*
	(branch
		(= g_cannon_obj_control 2)
		(print "branch_end:facility_game_saves")
	)
	*;
	(sleep_until
		(begin
			
			;change to cond when more than one parameter
			(cond
				((and (volume_test_players tv_facility_14) (<= (ai_living_count sq_facility_grunt_01) 0)) (begin (game_save) (sleep 300)))
				((volume_test_players tv_facility_final_rush) (begin (game_save) (sleep 300)))
			)
			
		0)
	)
	
)

(script dormant facility_place_01
	(ai_place sq_facility_allies_01)
	(ai_place sq_facility_allies_02)
		(sleep 1)
	(ai_place sq_facility_shade_01)
	(ai_place sq_facility_intro_grunts)
	(ai_place sq_facility_intro_jackals)
		(sleep 1)
	(ai_place sq_facility_cov_01)
	(ai_place sq_facility_grunt_02)
	(ai_place sq_facility_plasma_01)
	;(ai_place sq_facility_intro_snipers)
	(ai_place sq_facility_skirmisher_01)
	
	(sleep_until (>= g_facility_obj_control 4))
	(if (not (game_is_cooperative))
		(begin 
			(ai_player_add_fireteam_squad player0 sq_facility_allies_01)
			(ai_player_add_fireteam_squad player0 sq_facility_allies_02)
		)
	)
	
)

(script dormant facility_place_02
	(sleep_until (>= g_facility_obj_control 6) 5)
	(ai_place sq_facility_jackal_02)
	(ai_place sq_facility_jackal_04)
	(ai_place sq_facility_cov_leader01)
	
	(sleep_until (volume_test_players tv_facility_inner))
	(if
		(or
			(and (= (game_difficulty_get) legendary) (>= (game_coop_player_count) 2))
			(and (= (game_difficulty_get) heroic) (>= (game_coop_player_count) 3))
			(and
				(volume_test_players tv_facility_inner)
				(any_players_in_vehicle)
			)
		)
		(ai_place sq_facility_banshees)
	)
	
)

(script dormant facility_place_03
(sleep_until (>= g_facility_obj_control 13) 5)
	(ai_place sq_facility_grunt_04)
	
	(wake facility_zealot)
)

(script dormant facility_place_04
	(sleep_until (>= g_facility_obj_control 12) 5)
	;(ai_place sq_facility_jackal_03)
	(ai_place sq_facility_grunt_01)
	(ai_place sq_facility_grunt_03)	
	(ai_place sq_cannon_ghost_01)
	(ai_place sq_cannon_ghost_02)
	
)

(script dormant facility_hologram_training
	(sleep_until
		(or
			(unit_has_equipment  player0 objects\equipment\hologram\hologram.equipment)
			(unit_has_equipment  player1 objects\equipment\hologram\hologram.equipment)
			(unit_has_equipment  player2 objects\equipment\hologram\hologram.equipment)
			(unit_has_equipment  player3 objects\equipment\hologram\hologram.equipment)
		)
	5)
	(sleep 10)
	(f_hud_training_new_weapon)

)

(script dormant cannon_shield_training
	(sleep_until
		(or
			(unit_has_equipment  player0 objects\equipment\drop_shield\drop_shield.equipment)
	    (unit_has_equipment  player1 objects\equipment\drop_shield\drop_shield.equipment)
	    (unit_has_equipment  player2 objects\equipment\drop_shield\drop_shield.equipment)
	    (unit_has_equipment  player3 objects\equipment\drop_shield\drop_shield.equipment)
	   )
	5)
	(sleep 10)
	(f_hud_training_new_weapon)

)

(script dormant facility_launcher_blip
	(f_blip_weapon w_plasma_launcher_01 5 9)
	(wake facility_plasma_training)
	
)

(script dormant facility_plasma_training
	(sleep_until
		(or
			(unit_has_weapon player0 objects\weapons\support_high\plasma_launcher\plasma_launcher.weapon)
			(unit_has_weapon player1 objects\weapons\support_high\plasma_launcher\plasma_launcher.weapon)
			(unit_has_weapon player2 objects\weapons\support_high\plasma_launcher\plasma_launcher.weapon)
			(unit_has_weapon player3 objects\weapons\support_high\plasma_launcher\plasma_launcher.weapon)
		)
	5)
	(sleep 10)
	(f_hud_training_new_weapon)

)


(script dormant facility_bypass
	(sleep_until (volume_test_players tv_facility_11))
	(if (<= g_facility_obj_control 10)
		(set g_facility_obj_control 11)
	)
)

(global object obj_zealot NONE)
(script dormant facility_zealot
	(ai_place sq_facility_zealot)
	(set obj_zealot (ai_get_unit sq_facility_zealot))
	(f_ai_magically_see_players sq_facility_zealot)
	(sleep 70)
	(f_callout_ai sq_facility_zealot blip_hostile)
	(sleep_until
		(or
			(volume_test_players tv_facility_zealot_03)
			(<= (ai_living_count (object_get_ai obj_zealot)) 0)
		)
	)
	(print "zealot escaping")
	;(f_unblip_ai sq_facility_zealot)
	(cs_run_command_script (object_get_ai obj_zealot) cs_facility_zealot)
	(sleep_until (<= (ai_living_count (object_get_ai obj_zealot)) 0))
	(if (and (not g_facility_zealot_escaped) (<= (current_zone_set_fully_active) 4))
		(begin
			(print "achievement: zealot killed")
			(wake md_facility_zealot_dead)
			(submit_incident_with_cause_player "zealot_achieve" player0)
			(submit_incident_with_cause_player "zealot_achieve" player1)
			(submit_incident_with_cause_player "zealot_achieve" player2)
			(submit_incident_with_cause_player "zealot_achieve" player3)
		)
	)
	
)

(script command_script cs_facility_zealot
	(ai_set_active_camo ai_current_actor TRUE)
	(cs_go_to ps_facility_zealot/p0)
	(if (not (or (>= g_facility_obj_control 16) (volume_test_players tv_facility_zealot_04)))
		(begin
			(print "zealot escaped")
			(set g_facility_zealot_escaped TRUE)
			(ai_erase ai_current_actor)
		)
		(begin
			(print "zealot sword fight")
			(unit_add_equipment ai_current_actor profile_zealot TRUE TRUE)
			(ai_berserk ai_current_actor TRUE)
			(sleep 10)
			(ai_set_active_camo ai_current_actor FALSE)
		)
	)
	
)


; Facility Hog Control =======================================================================================================================================
(script static boolean b_facility_hog_control
	(and
		(volume_test_objects tv_facility_hog_control (ai_vehicle_get_from_squad sq_hill_rockethog_01 0))
		(< (objects_distance_to_object (players) (ai_vehicle_get_from_squad sq_hill_rockethog_01 0)) 10)
	)
)


; Facility Wraith FX =======================================================================================================================================
(script dormant facility_wraith_fx
	(sleep_until (>= g_facility_obj_control 11))
	(sleep_until
		(begin
			(effect_new_random "fx\fx_library\designer_fx\wraith_mortar.effect" ps_fx_facility_wraith 1 1)
			(sleep (random_range 30 90))
		(>= g_facility_obj_control 15))
	)
)


; FACILITY Banshees =====================================================================================================================================================================================

(script command_script cs_facility_banshees
	(cs_vehicle_boost TRUE)
	(sleep (random_range 220 260))
	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(sleep (random_range 120 160))
	;*
	(sleep_until
		(and
			(volume_test_players tv_facility_inner)
			(any_players_in_vehicle)
		)
	)
	*;
	;(if (>= (random_range 0 3) 1)
	;	(begin
			(cs_enable_targeting TRUE)
			(cs_shoot_secondary_trigger TRUE)
			(cs_vehicle_boost FALSE)
			(sleep_forever)
	;	)
	;)
)


;====================================================================================================================================================================================================
; CANNON ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant enc_cannon
	; set fifth mission segment
	(data_mine_set_mission_segment "m35_05_enc_cannon")
	
	; initial AI
	(wake cannon_place_01)
	
	; bob the elite
	(if (= g_bob_number 2)
		(ai_place sq_cannon_bob)
	)
	
	; ending encounter
	(wake cannon_finish)
	
	; kat vehicle enter
	(wake cannon_kat_enter_vehicle)
	
	; cannon exit script
	(wake cannon_01)
	
	; cannon dialogue
	(wake md_cannon_intro)
	(wake md_cannon_end)
	
	; music
	(wake music_cannon)
	
	; flocks
	(wake flocks_02c_start)
	
	; hud
	(wake cannon_ui_bfg_flash)
	
	; equipment training
	(wake cannon_shield_training)
	
	; waypoints
	(wake cannon_waypoints)
	
	; saves
	(wake cannon_backtrack_saves)
	
	
	;Trigger Volumes =================================

	(sleep_until (volume_test_players tv_cannon_01) 1)
	(if debug (print "set objective control 1"))
	(set g_cannon_obj_control 1)
		
		;AI placement
		(wake cannon_place_02)
		
		; terminal area
		(damage_object v_cannon_hog "hull" 400)
		(if (= (game_difficulty_get) legendary)
			(object_create terminal_m35_13)
		)
		
		;(game_save)

	(sleep_until (volume_test_players tv_cannon_02) 1)
	(if debug (print "set objective control 2"))
	(set g_cannon_obj_control 2)
		
		;(game_save)

	(sleep_until (volume_test_players tv_cannon_03) 1)
	(if debug (print "set objective control 3"))
	(set g_cannon_obj_control 3)
	
		; removing of previous AI
		(ai_disposable gr_facility_cov TRUE)
		
		;AI placement
		(wake cannon_place_03)		
		
		(game_save)		
		
	(sleep_until (volume_test_players tv_cannon_04) 1)
	(if debug (print "set objective control 4"))
	(set g_cannon_obj_control 4)
		
		(game_save)
			
	(sleep_until (volume_test_players tv_cannon_05) 1)
	(if debug (print "set objective control 5"))
	(set g_cannon_obj_control 5)
	
	(sleep_until (volume_test_players tv_cannon_06) 1)
	(if debug (print "set objective control 6"))
	(set g_cannon_obj_control 6)
	
		;AI placement
		(wake cannon_place_04)
		
		(game_save)					
)


; CANNON secondary scripts =======================================================================================================================================

(script dormant cannon_place_01
	(ai_place sq_cannon_cov_03)
	
	(if (>= (game_coop_player_count) 3)
		(begin
			(ai_place sq_cannon_skirmisher_02)
			(ai_place sq_cannon_jackal_03)
		)
	)
)

(script dormant cannon_place_02
	(ai_place sq_cannon_wraith_01)
	(ai_place sq_cannon_wraith_02)
	(if (>= (game_coop_player_count) 2)
		(ai_place sq_cannon_wraith_03)
	)
	
	(ai_place sq_cannon_jackal_01)
	(ai_place sq_cannon_skirmisher_01)
	(ai_place sq_cannon_cov_01)
	
	 ;legendary
	;(ai_place sq_cannon_flak)
	
	; saves
	(wake cannon_wraith_saves)
	
)

(script dormant cannon_place_03
	(ai_place sq_cannon_cov_02)
	(ai_place sq_cannon_hunters)
	
	; saves
	(wake cannon_hunter_saves)
)

(script dormant cannon_place_04
	(if 
		(or
			(= (game_difficulty_get) legendary)
			(= (game_difficulty_get) heroic)
			(game_is_cooperative)
		)
		(ai_place sq_cannon_bugger_01)
	)
	
	(if (>= (game_coop_player_count) 3)
		(ai_place sq_cannon_bugger_02)
	)

)

(script dormant cannon_finish
	;(sleep_until (= (current_zone_set) 6) 5)
	(sleep (* 30 20))
	;(zone_set_trigger_volume_enable zone_set:set_cannon_02 TRUE)
	;(sleep_until (= (current_zone_set_fully_active) 6) 5)
	(sleep_until g_bfg02_core_destroyed)
	; set sixth mission segment
	(data_mine_set_mission_segment "m35_06_bfg02_core_destroyed")
	;(sleep_until g_bfg02_destroyed 30 (* 30 3))
	(ai_place sq_cannon_phantom)
	(ai_place sq_cannon_pelican)
	
)

(script dormant cannon_kat_enter_vehicle
	(branch
		(>= g_cannon_obj_control 1)
		(branch_kill)
	)
	
	(sleep_until (any_players_in_vehicle))
	(sleep 20)
	(if (>= (ai_vehicle_count gr_kat) 1)
		(sleep_forever)
	)
	(print "kat enter vehicle")
	(cond
	((vehicle_test_seat_unit_list v_cannon_rev "" (players))
		(ai_vehicle_enter gr_kat v_cannon_rev "")
	)
	((not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad sq_cannon_ghost_01 0) "" (players)))
		(ai_vehicle_enter gr_kat (ai_vehicle_get_from_squad sq_cannon_ghost_01 0) "")
	)
	((not (vehicle_test_seat_unit_list (ai_vehicle_get_from_squad sq_cannon_ghost_02 0) "" (players)))
		(ai_vehicle_enter gr_kat (ai_vehicle_get_from_squad sq_cannon_ghost_02 0) "")
	)
	((not (vehicle_test_seat_unit_list v_cannon_ghost "" (players)))
		(ai_vehicle_enter gr_kat v_cannon_ghost "")
	)
	)
)

; Escaping Ghosts =========================================================================

(script command_script cs_cannon_ghost_01
	(cs_enable_pathfinding_failsafe TRUE)
		
		;(cs_enable_targeting TRUE)
	
	(cs_go_to_vehicle (ai_vehicle_get_from_squad sq_cannon_ghost_01 0))
	;(ai_vehicle_enter sq_cannon_ghost_01 (ai_vehicle_get_from_squad sq_cannon_ghost_01 0) "ghost_d")
		
		(cs_enable_targeting FALSE)
		(cs_enable_looking FALSE)
		(cs_enable_moving FALSE)
		
		(cs_vehicle_boost TRUE)
		(cs_go_to ps_cannon_ghost/run_01)
		;(cs_go_to ps_cannon_ghost/run_02)
		;(cs_go_to ps_cannon_ghost/run_03)
		;(cs_go_to ps_cannon_ghost/run_04)
		;(cs_go_to ps_cannon_ghost/run_05)
		;(cs_go_to ps_cannon_ghost/run_06)		 
)

(script command_script cs_cannon_ghost_02
	(cs_enable_pathfinding_failsafe TRUE)
	
		;(cs_enable_targeting TRUE)
	
	(cs_go_to_vehicle (ai_vehicle_get_from_squad sq_cannon_ghost_02 0))
	;(ai_vehicle_enter sq_cannon_ghost_02 (ai_vehicle_get_from_squad sq_cannon_ghost_02 0) "ghost_d")
		
		(cs_enable_targeting FALSE)
		(cs_enable_looking FALSE)
		(cs_enable_moving FALSE)
		
		(cs_vehicle_boost TRUE)
		(cs_go_to ps_cannon_ghost/run_01)
		(cs_go_to ps_cannon_ghost/run_02)
		;(cs_go_to ps_cannon_ghost/run_03)
		;(cs_go_to ps_cannon_ghost/run_04)
		;(cs_go_to ps_cannon_ghost/run_05)
		;(cs_go_to ps_cannon_ghost/run_06)		 
)

; Wraith firing behavior =======================================================================================================================================
(script command_script cs_cannon_wraith_shoot_01
	(cs_abort_on_damage TRUE)
	
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot_point TRUE ps_cannon_wraith_01/p0)
				(cs_shoot_point TRUE ps_cannon_wraith_01/p1)
				(cs_shoot_point TRUE ps_cannon_wraith_01/p2)
				(cs_shoot_point TRUE ps_cannon_wraith_01/p3)
				(cs_shoot_point TRUE ps_cannon_wraith_01/p4)
			)
			(sleep 120)
		FALSE
		)
	)
)

(script command_script cs_cannon_wraith_shoot_02
	(cs_abort_on_damage TRUE)
	
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot_point TRUE ps_cannon_wraith_02/p0)
				(cs_shoot_point TRUE ps_cannon_wraith_02/p1)
				(cs_shoot_point TRUE ps_cannon_wraith_02/p2)
				(cs_shoot_point TRUE ps_cannon_wraith_02/p3)
				(cs_shoot_point TRUE ps_cannon_wraith_02/p4)
			)
			(sleep 120)
		FALSE
		)
	)
)

; Backtrack Saves =========================================================================

(script dormant cannon_backtrack_saves
	(branch
		g_bfg02_core_destroyed
		(branch_kill)
	)
	
	(sleep_until
		(begin
			(sleep_until (not (volume_test_players tv_cannon_backtrack)))
			(sleep_until (volume_test_players tv_cannon_backtrack))
			(sleep 90)
			(game_save)
			FALSE
		)
	)
	
)

; Wraith Saves =========================================================================

(script dormant cannon_wraith_saves
	(sleep_until (<= (ai_living_count gr_cannon_wraiths) 2))
	(set g_music02 TRUE)
	(game_save)
	(sleep_until (<= (ai_living_count gr_cannon_wraiths) 0))
	(game_save)
)

; Hunter Saves =========================================================================

(script dormant cannon_hunter_saves
	(sleep_until (<= (ai_living_count sq_cannon_hunters) 1))
	(set g_music02 TRUE)
	(game_save)
	(sleep_until (<= (ai_living_count gr_cannon_wraiths) 0))
	(game_save)
)

; Cannon Phantom =====================================================================================================================================================================================

(script command_script cs_cannon_phantom
	(cs_enable_pathfinding_failsafe TRUE)
	(if debug (print "cs_cannon_phantom"))

	; == spawning ====================================================
		(ai_place sq_cannon_phantom_cov)
		(if (game_is_cooperative)
			(ai_place sq_cannon_phantom_cov_coop)
		)
		;(ai_place sq_phantom_05_ghost_01)		
		
		;(ai_force_active gr_phantom_05 TRUE)
			
	; == seating ====================================================		
		(ai_vehicle_enter_immediate sq_cannon_phantom_cov (ai_vehicle_get ai_current_actor) "phantom_p_rb")
		(ai_vehicle_enter_immediate sq_cannon_phantom_cov_coop (ai_vehicle_get ai_current_actor) "phantom_p_lb")
		
			(sleep 1)



	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_cannon_phantom/p0)
	(cs_vehicle_boost FALSE)
	(cs_fly_by ps_cannon_phantom/p1)
	(unit_open (ai_vehicle_get ai_current_actor))
	(cs_fly_to_and_face ps_cannon_phantom/p2 ps_cannon_phantom/p3 1)	
			
		;drop
		(f_unload_phantom (ai_vehicle_get ai_current_actor) "dual")
		(unit_close (ai_vehicle_get ai_current_actor))
		(sleep 90)		
		
			(cs_vehicle_speed 1)
			
		(cs_fly_by ps_cannon_phantom/p1)
		(cs_fly_by ps_cannon_phantom/p0)
		(cs_fly_by ps_cannon_phantom/p4)
		(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))

)


; Cannon Pelican =========================================================================
(script command_script cs_cannon_pelican
	(f_load_pelican (ai_vehicle_get ai_current_actor) "dual" sq_cannon_troopers sq_cannon_troopers_02)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_cannon_pelican/flyby01)
	(cs_fly_by ps_cannon_pelican/flyby02)
	(cs_vehicle_boost FALSE)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_cannon_pelican/flyby03 ps_cannon_pelican/face 1)
	(f_unload_pelican_all (ai_vehicle_get ai_current_actor))
	(sleep 100)
	(unit_close (ai_vehicle_get ai_current_actor))
	(sleep 100)
	
	(cs_fly_by ps_cannon_pelican/flyby02)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_cannon_pelican/flyby04)
	(cs_fly_by ps_cannon_pelican/flyby05)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))

)

; Cannon BFG scripts =======================================================================================================================================
(script dormant cannon_bfg_start
	(sleep_until (= (current_zone_set_fully_active) 5))
	
	(wake cannon_bfg_target_control)
	(sleep_until (object_model_target_destroyed (ai_vehicle_get_from_squad sq_cannon_bfg_driver 0) "target_core"))
	(print "bfg01: core destroyed")
	
	(set g_bfg02_core_destroyed TRUE)
	(sleep (* 30 15))
	
	(set g_bfg02_destroyed TRUE)
	
	(f_hud_obj_complete)
	(set g_music02 TRUE)
	(set g_music03 TRUE)
	(f_blip_flag fl_falcon_01 blip_defend)
	
	(game_save)
	
)


(script dormant cannon_bfg_target_control
	(ai_place sq_cannon_bfg_driver)
	(wake cannon_bfg_failsafe)
	(ai_set_targeting_group sq_cannon_bfg_driver 2)
	;(ai_disregard (ai_actors sq_cannon_bfg_driver) TRUE)
	(object_set_persistent (ai_vehicle_get_from_squad sq_cannon_bfg_driver 0) TRUE)
	(cs_run_command_script sq_cannon_bfg_driver cs_cannon_bfg01_shoot)
	
	(if (not (game_is_cooperative))
		(wake cannon_falcon_control)
	)
	
)

(script dormant cannon_falcon_control
	(sleep_until (>= g_twin_obj_control 3))
	(ai_place sq_cannon_falcon_01)
	(ai_set_targeting_group sq_cannon_falcon_01 2)
	
	(sleep 150)
	(cs_run_command_script sq_cannon_bfg_driver abort_cs)
	
	(sleep_until (<= (ai_task_count obj_cannon_allies/gt_falcons) 0))
	(cs_run_command_script sq_cannon_bfg_driver cs_cannon_bfg01_shoot)
	
	(sleep 200)
	(ai_place sq_cannon_falcon_02)
	(ai_set_targeting_group sq_cannon_falcon_02 2)
	(sleep 150)
	(cs_run_command_script sq_cannon_bfg_driver abort_cs)
	
	(sleep_until (<= (ai_task_count obj_cannon_allies/gt_falcons) 0))
	(cs_run_command_script sq_cannon_bfg_driver cs_cannon_bfg01_shoot)
	
)

(script dormant cannon_bfg_failsafe
	(sleep_until (< (object_get_health (ai_vehicle_get_from_squad sq_cannon_bfg_driver 0)) .5))
	(ai_disregard (ai_actors sq_cannon_bfg_driver) TRUE)
)


(script command_script cs_cannon_bfg01_shoot
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point TRUE ps_cannon_bfg/p0)
				(cs_shoot_point TRUE ps_cannon_bfg/p1)
				(cs_shoot_point TRUE ps_cannon_bfg/p2)
			)
			FALSE
		)
	)
)

(script dormant cannon_ui_bfg_flash
	(branch
		g_bfg02_core_destroyed
		(cannon_ui_bfg_flash_branch)
	)
	
	(sleep_until
		(and
			(volume_test_players tv_cannon_main)
			(objects_can_see_object (players) sc_hud_highlight_bfg02 30)
		)
	)
	(print "UI flashing BFG01")
	(f_hud_flash_object sc_hud_highlight_bfg02)
	;(f_blip_title sc_hud_outpost_dish "WP_CALLOUT_M35_SPIRE")
	
)

(script static void cannon_ui_bfg_flash_branch
	(print "bfg02 destroyed before UI flash")
)


; falcon_01 =====================================================================================================================================================================================

(script command_script cs_cannon_falcon_01
	(ai_set_targeting_group ai_current_actor 2)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	
	(begin_random_count 1
		(object_teleport_to_ai_point (ai_vehicle_get ai_current_actor)  ps_cannon_falcon_01/t1)
		(object_teleport_to_ai_point (ai_vehicle_get ai_current_actor)  ps_cannon_falcon_01/t2)
		(object_teleport_to_ai_point (ai_vehicle_get ai_current_actor)  ps_cannon_falcon_01/t3)
	)
	
	(object_set_velocity (ai_vehicle_get ai_current_actor) 20 0 10)
	;(cs_face TRUE ps_cannon_falcon_01/face)
	
	(cs_fly_by ps_cannon_falcon_01/start)
	(sleep_until
		(begin
			;(begin_random_count 1
				(cs_fly_by ps_cannon_falcon_01/p0)
				(cs_fly_by ps_cannon_falcon_01/p1)
				(cs_fly_by ps_cannon_falcon_01/p2)
				(cs_fly_by ps_cannon_falcon_01/p1)
			;)
		0)
	60)
	
)


; Cannon exit scripts =======================================================================================================================================

(script dormant cannon_01
	(sleep_until g_bfg02_core_destroyed 1)
	(if debug (print "cannon complete"))

)


; Cannon waypoint scripts =======================================================================================================================================

(script dormant cannon_waypoints
	(branch
		g_bfg02_core_destroyed
		(hud_unblip_all)
	)
	
	(if (= (game_difficulty_get_real) easy)
		(begin
			(sleep_until (>= g_cannon_obj_control 3) 30)
			;Don't need Carter's reminder VO (from ambient file)
			;(wake md_cannon_waypoint)
			(f_blip_object sc_hud_bfg02_core blip_neutralize)
			(sleep_until g_bfg02_core_destroyed 1)
			(hud_unblip_all)
		)
	)
	
	(sleep_until  (<= (ai_task_count obj_cannon_cov/gt_cov) 6) 30 b_waypoint_time)
	(if (not (<= (ai_task_count obj_cannon_cov/gt_cov) 6))
		(begin
			(wake md_cannon_waypoint)
			(f_blip_object sc_hud_bfg02_core blip_neutralize)
			(sleep_until g_bfg02_core_destroyed 1)
			(hud_unblip_all)
		)
	)
	
	(sleep_until  (<= (ai_living_count gr_cannon_wraiths) 2) 30 b_waypoint_time)
	(if (not (<= (ai_living_count gr_cannon_wraiths) 2))
		(begin
			(wake md_cannon_waypoint)
			(f_blip_object sc_hud_bfg02_core blip_neutralize)
			(sleep_until g_bfg02_core_destroyed 1)
			(hud_unblip_all)
		)
	)
	
	(sleep_until  (<= (ai_living_count gr_cannon_wraiths) 0) 30 b_waypoint_time)
	(if (not (<= (ai_living_count gr_cannon_wraiths) 2))
		(begin
			(wake md_cannon_waypoint)
			(f_blip_object sc_hud_bfg02_core blip_neutralize)
			(sleep_until g_bfg02_core_destroyed 1)
			(hud_unblip_all)
		)
	)
	
	(sleep_until (>= g_cannon_obj_control 5) 30 b_waypoint_time)
	(if (not (>= g_cannon_obj_control 5))
		(begin
			(wake md_cannon_waypoint)
			(f_blip_object sc_hud_bfg02_core blip_neutralize)
			(sleep_until g_bfg02_core_destroyed 1)
			(hud_unblip_all)
		)
	)

	(sleep_until g_bfg02_core_destroyed 30 b_waypoint_time)
	(if (not g_bfg02_core_destroyed)
		(begin
			(wake md_cannon_waypoint)
			(f_blip_object sc_hud_bfg02_core blip_neutralize)
			(sleep_until g_bfg02_core_destroyed 1)
			(hud_unblip_all)
		)
	)
)

;====================================================================================================================================================================================================
; FALCON ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant enc_falcon

	; set seventh mission segment
	(data_mine_set_mission_segment "m35_07_enc_falcon")
	
	(sleep_until g_bfg02_destroyed)
	
	(sleep_until 
		(and
			;(<= (ai_living_count sq_cannon_phantom) 0)
			(<= (ai_living_count (f_ai_get_vehicle_driver sq_cannon_phantom)) 0)
			(<= (ai_task_count obj_cannon_cov/final_retreat_cov) 3)
			(<= (ai_task_count obj_cannon_cov/gt_wraith) 0)
			(<= (ai_living_count sq_cannon_hunters) 0)
		)
	30 (* 30 420))
	
	; dialog
	(wake md_falcon_canyon)
	(wake md_falcon_callouts)
	(wake md_falcon_dome_start)
	
	; music
	(wake music_falcon)
	
	; spawn script	
	; cs_falcon is the central script 
	(wake falcon_place)
	(wake falcon_cov_place)
	
	; disable kill
	(kill_volume_disable kill_falcon_01)
	(kill_volume_disable kill_falcon_02)
	
	; garbage collect landing zone
	(add_recycling_volume tv_sp_cannon_evac 0 30)
	
	; flocks
	(wake flocks_03_start)
	
	; garbage collection
	(wake falcon_garbage_collect)
	
	; falcon crash script
	(wake falcon_crash)
	
	; insertion point unlock
	(game_insertion_point_unlock 4)
	
)	
	
; FALCON secondary scripts =======================================================================================================================================

(script dormant falcon_place
	
	; placing all falcons
	(f_ai_place_vehicle_deathless_no_emp sq_falcon_01)
	(ai_cannot_die (f_ai_get_vehicle_driver sq_falcon_01) TRUE)
	;(object_cannot_take_damage (ai_vehicle_get_from_squad sq_falcon_01 0))
	(f_falcon_seat_control sq_falcon_01)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_g_l" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_g_r" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_p_bench" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_p_bench_wpn" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_p_r1" TRUE)
	(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_p_r1_wpn" FALSE)
	;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_p_l1" TRUE)
	

	
	(if (coop_players_3)
		(begin
			(print "placing 2nd falcon")
			(f_ai_place_vehicle_deathless_no_emp sq_falcon_02)
			(ai_cannot_die (f_ai_get_vehicle_driver sq_falcon_02) TRUE)
			;(object_cannot_take_damage (ai_vehicle_get_from_squad sq_falcon_02 0))
			(f_falcon_seat_control sq_falcon_02)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_g_l" TRUE)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_g_r" TRUE)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_p_bench" TRUE)
			(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_p_bench_wpn" TRUE)
			;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_p_r1" TRUE)
			;(ai_vehicle_reserve_seat (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_p_l1" TRUE)
		)
	)
	
	;*
	(f_ai_place_vehicle_deathless_no_emp sq_falcon_02)
	(object_cannot_take_damage (ai_vehicle_get_from_squad sq_falcon_02 0))
	(f_falcon_seat_control sq_falcon_02)
	*;
	
	; falcon seat test 
		(wake falcon_start_test)

)

; !!! function for seat control !!! 
(script static void (f_falcon_seat_control (ai falcon))
	
	; falcon seat control 
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad falcon 0) "falcon_d" FALSE FALSE)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad falcon 0) "falcon_g_l" TRUE FALSE)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad falcon 0) "falcon_g_r" TRUE FALSE)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad falcon 0) "falcon_p_bench" FALSE FALSE)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad falcon 0) "falcon_p_l1" FALSE FALSE)
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad falcon 0) "falcon_p_r1" FALSE FALSE)	
)


; falcon cov =====================================================================================================================================================================================
(script dormant falcon_cov_place
	(wake falcon_cov_sleep_right)
	(wake falcon_cov_sleep_left)
	
	; placement of exposure_01
	(sleep_until (>= g_falcon_obj_control 20) 1)
		
		;*
		(if (not (falcon_has_right_gunners))
			(begin
				(cs_run_command_script sq_falcon_ex_01_left_cov_01 sleep_cs)
			)
		)
		*;
		
			(sleep 1)
		(ai_place sq_falcon_ex_01_right_cov_01)
		
		;(ai_force_low_lod gr_falcon_exposure_01)
		
		;(print "placing first shade")
		;(ai_place sq_falcon_ex_02_right_shade_01)
		
	; placement of exposure_02
	(sleep_until (>= g_falcon_obj_control 30) 5)
		
		; delay this ex_01 squad
		(ai_place sq_falcon_ex_01_left_cov_01)
		(ai_force_low_lod gr_falcon_exposure_01)
		
			(sleep 1)
		(print "placing right side shades")
		(ai_place sq_falcon_ex_02_right_shade_02)
			(sleep 1)
		(print "placing right side wraiths")
		(ai_place sq_falcon_ex_02_wraith_01_r)
		(sleep 1)

			(sleep 1)
		(ai_place sq_falcon_ex_02_left_cov_01)
		(ai_place sq_falcon_ex_02_left_cov_01b)
			(sleep 1)
		(print "placing left side shades")
		(ai_place sq_falcon_ex_02_left_shade_02)
		
			(sleep 1)
		(print "placing left side wraiths")
		(ai_place sq_falcon_ex_02_wraith_01_l)
		
		(sleep 1)
		(print "placing right side flak")
		(ai_place sq_falcon_ex_02_right_watch)
		(ai_place sq_falcon_ex_02_right_cov_01)
		(sleep 1)
		
		(ai_disregard (ai_actors sq_falcon_01) TRUE)
		(ai_disregard (ai_actors sq_falcon_02) TRUE)
		
		(ai_force_full_lod gr_falcon_exposure_02_shades)
		(ai_force_low_lod gr_falcon_exposure_02_inf)
		(f_ai_magically_see_players obj_falcon_cov)
		
	(sleep_until (volume_test_players tv_falcon_01) 5)
	(print "tv_falcon_01")
	; enable kill
	(kill_volume_enable kill_falcon_01)
		(sleep 20)
	(add_recycling_volume tv_sp_falcon 0 1)	
		(sleep 60)
	(ai_place sq_falcon_ex_02_right_shade_03)
	(ai_place sq_falcon_ex_02_left_shade_03)
		(sleep 1)
	(ai_place sq_falcon_ex_02_right_cov_02)
	(ai_place sq_falcon_ex_02_right_cov_02b)
	(ai_place sq_falcon_ex_02_left_cov_02)
	
	(wake falcon_right_shade_fire_control)
	(wake falcon_left_shade_fire_control)
	(f_ai_magically_see_players obj_falcon_cov)
		
	; placement of exposure_02
	(sleep_until (>= g_falcon_obj_control 40) 5)
	(f_ai_magically_see_players obj_falcon_cov)
	(print "kill_falcon_02")
	(kill_volume_enable kill_falcon_02)
		(sleep 20)
	(add_recycling_volume tv_sp_falcon 0 0)	
	
	(sleep 100)
	(cs_run_command_script sq_falcon_ex_02_left_shade_03 cs_sky_shades)
	
	;*
	(unit_kill (ai_vehicle_get sq_falcon_ex_02_right_shade_02/01))
	(unit_kill (ai_vehicle_get sq_falcon_ex_02_right_shade_02/02))
	
	(unit_kill (ai_vehicle_get sq_falcon_ex_02_left_shade_02/01))
	(unit_kill (ai_vehicle_get sq_falcon_ex_02_left_shade_02/02))
	(unit_kill (ai_vehicle_get sq_falcon_ex_02_left_shade_02/03))
	*;

)

(script dormant falcon_right_shade_fire_control
	(cs_run_command_script sq_falcon_ex_02_right_shade_03 sleep_cs)
	
	(sleep_until 
		(or
			(<= (ai_living_count sq_falcon_ex_02_right_shade_02) 1)
			(>= g_falcon_obj_control 40) 
		)		
	5)
	
	(cs_run_command_script sq_falcon_ex_02_right_shade_03 cs_sky_shades)
)

(script dormant falcon_left_shade_fire_control
	(cs_run_command_script sq_falcon_ex_02_left_shade_03 sleep_cs)
	
	(sleep_until 
		(or
			(<= (ai_living_count sq_falcon_ex_02_left_shade_02) 1)
			(>= g_falcon_obj_control 40) 
		)		
	5)
	
	(cs_run_command_script sq_falcon_ex_02_left_shade_03 cs_sky_shades)
)

(script dormant falcon_cov_sleep_right
	(branch
		g_falcon_crash
		(branch_kill)
	)
	
	(sleep_until
		(begin
			(sleep_until (not (falcon_has_right_gunners)))
			
			(cs_run_command_script sq_falcon_ex_01_right_cov_01 sleep_cs)
			
			(cs_run_command_script sq_falcon_ex_02_wraith_01_r cs_sky_wraiths)
			
			;(cs_run_command_script sq_falcon_ex_02_right_shade_01 cs_sky_shades)
			(cs_run_command_script sq_falcon_ex_02_right_shade_02 sleep_cs)
			(cs_run_command_script sq_falcon_ex_02_right_shade_03 sleep_cs)
			(cs_run_command_script sq_falcon_ex_02_right_watch sleep_cs)
			(cs_run_command_script sq_falcon_ex_02_right_cov_01 sleep_cs)
			(cs_run_command_script sq_falcon_ex_02_right_cov_02 sleep_cs)
			(cs_run_command_script sq_falcon_ex_02_right_cov_02b sleep_cs)
		0)
	)
)

(script dormant falcon_cov_sleep_left
	(branch
		g_falcon_crash
		(branch_kill)
	)
	
	(sleep_until
		(begin
			(sleep_until (not (falcon_has_left_gunners)))
			
			(cs_run_command_script sq_falcon_ex_01_left_cov_01 sleep_cs)
			
			(cs_run_command_script sq_falcon_ex_02_wraith_01_l cs_sky_wraiths)
			
			(cs_run_command_script sq_falcon_ex_02_left_cov_01 sleep_cs)
			(cs_run_command_script sq_falcon_ex_02_left_cov_01b sleep_cs)
			(cs_run_command_script sq_falcon_ex_02_left_cov_02 sleep_cs)
			;(cs_run_command_script sq_falcon_ex_02_left_shade_01 cs_sky_shades)
			(cs_run_command_script sq_falcon_ex_02_left_shade_02 sleep_cs)
			(cs_run_command_script sq_falcon_ex_02_left_shade_03 sleep_cs)
			;(cs_run_command_script sq_falcon_ex_02_left_shade_04 cs_sky_shades)
		0)
	)
)


; sky wriaths =====================================================================================================================================================================================
(script command_script cs_sky_wraiths
	(sleep (random_range 0 100))
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point TRUE ps_sky_wraiths/p0)
				(cs_shoot_point TRUE ps_sky_wraiths/p1)
				(cs_shoot_point TRUE ps_sky_wraiths/p2)
				(cs_shoot_point TRUE ps_sky_wraiths/p3)
				(cs_shoot_point TRUE ps_sky_wraiths/p4)
				(cs_shoot_point TRUE ps_sky_wraiths/p5)
			)
		FALSE
		)
	)
)

; sky shades =====================================================================================================================================================================================
(script command_script cs_sky_shades
	(sleep (random_range 0 100))
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point TRUE ps_sky_shades/p0)
				(cs_shoot_point TRUE ps_sky_shades/p1)
				(cs_shoot_point TRUE ps_sky_shades/p2)
				(cs_shoot_point TRUE ps_sky_shades/p3)
				(cs_shoot_point TRUE ps_sky_shades/p4)
				(cs_shoot_point TRUE ps_sky_shades/p5)
			)
		(< (objects_distance_to_object (players) (ai_vehicle_get ai_current_actor)) 50)
		)
	)
	(cs_aim_player TRUE)
	(sleep 30)
	(f_ai_magically_see_players ai_current_actor)
)

; sky shades =====================================================================================================================================================================================
(script command_script cs_sky_shades_flak
	(sleep (random_range 0 100))
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point TRUE ps_sky_shades/p0)
				(cs_shoot_point TRUE ps_sky_shades/p1)
				(cs_shoot_point TRUE ps_sky_shades/p2)
				(cs_shoot_point TRUE ps_sky_shades/p3)
				(cs_shoot_point TRUE ps_sky_shades/p4)
				(cs_shoot_point TRUE ps_sky_shades/p5)
			)
		(< (objects_distance_to_object (players) (ai_vehicle_get ai_current_actor)) 30)
		)
	)
	(cs_aim_player TRUE)
	(sleep 30)
	(f_ai_magically_see_players ai_current_actor)
)

; falcon seat test =====================================================================================================================================================================================

(script dormant falcon_start_test
	; wait for player
	(sleep_until 
		(or
			(player_in_vehicle (ai_vehicle_get sq_falcon_01/falcon))
			(player_in_vehicle (ai_vehicle_get sq_falcon_02/falcon)) 
		)		
	1)
	
	(sleep_until
		(begin
		;teleport players into falcons
			(if
				(= (unit_in_vehicle_type player0 20) FALSE)
				(f_falcon_start_teleport player0)
			)	
				
				(sleep 1)	
			
			(if
				(= (unit_in_vehicle_type player1 20) FALSE)
				(f_falcon_start_teleport player1)
			)
			
				(sleep 1)
			
			(if
				(= (unit_in_vehicle_type player2 20) FALSE)
				(f_falcon_start_teleport player2)
			)
			
				(sleep 1)
			
			(if
				(= (unit_in_vehicle_type player3 20) FALSE)
				(f_falcon_start_teleport player3)
			)
			
			;sleep until all players in Falcon
			(and
				(or (= (unit_in_vehicle_type player0 20) TRUE) (not (player_is_in_game player0)))
				(or (= (unit_in_vehicle_type player1 20) TRUE) (not (player_is_in_game player1)))
				(or (= (unit_in_vehicle_type player2 20) TRUE) (not (player_is_in_game player2)))
				(or (= (unit_in_vehicle_type player3 20) TRUE) (not (player_is_in_game player3)))
			)
		)
	1)
	
	; respawn
	(game_safe_to_respawn FALSE)
	
	(cs_run_command_script (f_ai_get_vehicle_driver sq_falcon_02) cs_falcon_02a)
	(sleep 50)
	(cs_run_command_script (f_ai_get_vehicle_driver sq_falcon_01) cs_falcon_01a)
		
		(game_save)
	
		; soft ceiling
		(soft_ceiling_enable default FALSE)
		(soft_ceiling_enable m35_flight TRUE)

			
		; turns off the LZ flag
		(hud_unblip_all)
		
		; chapter title
		;(wake chapter_03_start)
		
		
		;frigates
		(wake frigate_falcon_setup)
		
		; zoneset
		(sleep 90)
		(prepare_to_switch_to_zone_set set_cannon_02)
		(sleep (* 30 12))
		(switch_zone_set set_cannon_02)
		
		(sleep 90)
		(if (not (game_is_cooperative))
			(game_save_immediate)
			(game_save)
		)
		
		; music
		(set g_music01 TRUE)
		
)

(script static void (f_falcon_start_teleport (unit player_name))
	(cond
		;((= (player_in_vehicle (ai_vehicle_get_from_squad sq_falcon_01 0)) FALSE)
		((not (vehicle_test_seat (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_g_r"))
		(unit_enter_vehicle_immediate player_name (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_g_r"))
		
		;((= (player_in_vehicle (ai_vehicle_get_from_squad sq_falcon_02 0)) FALSE)
		((not (vehicle_test_seat (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_g_l"))
		(unit_enter_vehicle_immediate player_name (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_g_l"))
		
		((not (vehicle_test_seat (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_g_r"))
		(unit_enter_vehicle_immediate player_name (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_g_r"))
		
		((not (vehicle_test_seat (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_g_l"))
		(unit_enter_vehicle_immediate player_name (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_g_l"))
	)
)	


(script static boolean all_players_in_falcon
	(and
		(unit_in_vehicle_type player0 20)
		(if (>= (game_coop_player_count) 2) (unit_in_vehicle_type player1 20))
		(if (>= (game_coop_player_count) 3) (unit_in_vehicle_type player2 20))
		(if (>= (game_coop_player_count) 4) (unit_in_vehicle_type player3 20))
	)
)


(script static boolean falcon_has_right_gunners
	(or
		(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_g_r" (players))
		(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_g_r" (players))
	)
)

(script static boolean falcon_has_left_gunners
	(or
		(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_g_l" (players))
		(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_g_l" (players))
	)
)

; FALCON GARBAGE COLLECTION =======================================================================================================================================
	
	(script dormant falcon_garbage_collect
		; end of cannon
		(sleep_until (>= g_falcon_obj_control 20) 1)
			(print "recycle cannon")
			(add_recycling_volume tv_sp_cannon 0 0)
			(object_destroy_folder cr_cannon)
			(object_destroy_folder v_cannon)
			;disposable
			
		; start of exposure_01 
		(sleep_until (>= g_falcon_obj_control 30) 1)
			
		; end of exposure_01 
		(sleep_until (>= g_falcon_obj_control 40) 1)
			(print "recycle 01")
			(add_recycling_volume tv_sp_falcon_ex_01 0 0)	
			
		; end of exposure_02 
		(sleep_until (>= g_falcon_obj_control 100) 1)
			(print "recycle 02")
			(add_recycling_volume tv_sp_falcon_ex_02 0 0)														
	)

; falcon_01 =====================================================================================================================================================================================

(script command_script cs_falcon_01
	(cs_enable_pathfinding_failsafe TRUE)
	(print "cs_falcon_01")
	
	; spawn gunner
	;*
	(ai_place sq_falcon_allies_01)
	(vehicle_load_magic (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_g_l" (ai_get_object sq_falcon_allies_01/gunner))
	*;
	
	; spawn jorge
	(ai_place sq_jorge/falcon)
	(sleep 1)
	(set obj_jorge (ai_get_unit gr_jorge))
	(ai_cannot_die (object_get_ai obj_jorge) TRUE)
	(ai_force_low_lod sq_jorge)
	(ai_vehicle_enter_immediate gr_jorge (ai_vehicle_get ai_current_actor) "falcon_p_r1_wpn")
	
	(ai_place sq_falcon_01_trooper)
	(ai_cannot_die sq_falcon_01_trooper TRUE)
	(ai_force_low_lod sq_falcon_01_trooper)
	(ai_vehicle_enter_immediate sq_falcon_01_trooper/01 (ai_vehicle_get ai_current_actor) "falcon_p_l1")
	
	; spartans waypoints
	(if (not (game_is_cooperative))
		(wake spartan_waypoints_falcon)
	)

	; start movement 
	(cs_fly_by ps_falcon_01/approach_01)
	;(cs_fly_to_and_face ps_falcon_01/approach_04 ps_falcon_01/face_01)
	(cs_fly_by ps_falcon_01/approach_04)
	(cs_vehicle_speed .5)
	(cs_fly_by ps_falcon_01/approach_05)
	(cs_vehicle_speed .1)

	; hover in sky	
	(cs_fly_to_and_face ps_falcon_01/hover_01 ps_falcon_01/face_01 1)
	(wake md_falcon_start)
	(f_unblip_flag fl_falcon_01)
	(f_blip_object_offset (ai_vehicle_get_from_squad sq_falcon_01 0) blip_default 1)
	
)

(script command_script cs_falcon_01a
	(cs_enable_pathfinding_failsafe TRUE)
	(print "cs_falcon_01a")

		; Objective control 
		(if debug (print "set objective control 10"))
		(set g_falcon_obj_control 10)
	
		; speed 
		(cs_vehicle_speed .25)
	(cs_fly_by ps_falcon_01/cinematic_01_02 1)
		; speed 
		(cs_vehicle_speed .6)
		
	(cs_attach_to_spline "spline_falcon_01a")

; exposure_04 	
	(cs_fly_by ps_falcon_01/exposure_01a_01)
		; Objective control
		(print "set objective control 15")
		(if (< g_falcon_obj_control 15) (set g_falcon_obj_control 15))	
		(sleep 30)
		
		(print "set objective control 20")
		(if (< g_falcon_obj_control 20) (set g_falcon_obj_control 20))	
		
		; speed 
		(cs_vehicle_speed .7)
		
; exposure_05
	(cs_fly_by ps_falcon_01/exposure_01a_02)
	
	(cs_attach_to_spline "")
	
		; Objective control 
		(if debug (print "set objective control 30"))
		(if (< g_falcon_obj_control 30) (set g_falcon_obj_control 30))	
	(cs_fly_by ps_falcon_01/exposure_01a_03)
	
	(cs_run_command_script ai_current_actor cs_falcon_01b)

)


(script command_script cs_falcon_01b
	(cs_enable_pathfinding_failsafe TRUE)
	(print "cs_falcon_01b")
	
	(cs_attach_to_spline "spline_falcon_01b")
		
		;speed
		(cs_vehicle_speed .4)
		
	(cs_fly_by ps_falcon_01/exposure_01b_01)
	
		; Objective control 
		(if debug (print "set objective control 40"))
		(if (< g_falcon_obj_control 40) (set g_falcon_obj_control 40))		
		
		;speed
		(cs_vehicle_speed .3)
		
	(cs_attach_to_spline "")
	
	(cs_fly_by ps_falcon_01/exposure_01b_02)
	(cs_face TRUE ps_falcon_01/face01)
	
		;speed
		(cs_vehicle_speed .1)
	
	(wake falcon_wraiths_dead)
	(sleep_until 
		(begin
			(sleep 90)
			(cs_fly_by ps_falcon_01/exposure_01b_03)
			(sleep 90)
			(cs_fly_by ps_falcon_01/exposure_01b_02)
			
			;loop until player kills enough
			;(<= (ai_task_count obj_falcon_cov/gt_wraiths) 1)
			FALSE
		)
	)

	;(cs_run_command_script ai_current_actor cs_falcon_01c)
					
)


(script dormant falcon_wraiths_dead
	(if (falcon_has_left_gunners)
		(begin
			(sleep_until (<= (ai_task_count obj_falcon_cov/wraith_left_attack) 0) 60 (* 30 10))
			;(sleep_until (<= (ai_task_count obj_falcon_cov/gt_exposure_02_left) 2) 60 (* 30 30))
		)
	)
	(if (falcon_has_right_gunners)
		(begin
			(sleep_until (<= (ai_task_count obj_falcon_cov/wraith_right_attack) 0) 60 (* 30 10))
			;(sleep_until (<= (ai_task_count obj_falcon_cov/gt_exposure_02_right) 2) 60 (* 30 30))
		)
	)
	(cs_run_command_script (f_ai_get_vehicle_driver sq_falcon_01) cs_falcon_01c)
	(cs_run_command_script (f_ai_get_vehicle_driver sq_falcon_02) cs_falcon_02c)
)


(script command_script cs_falcon_01c
	(cs_enable_pathfinding_failsafe TRUE)
	(print "cs_falcon_01c")
	
	; Objective control 
		(if debug (print "set objective control 40"))
		(if (< g_falcon_obj_control 50) (set g_falcon_obj_control 50))	
	
		;speed
		(cs_vehicle_speed .5)
	
	(cs_attach_to_spline "spline_falcon_01c")
	(cs_fly_by ps_falcon_01/exposure_01c_01)	
	
	; Objective control 
		(if debug (print "set objective control 100"))
		(if (< g_falcon_obj_control 100) (set g_falcon_obj_control 100))
		
		(sleep 60)
		;(cs_attach_to_spline "")
	
	; sets a bool that the falcon_crash script is listening for 
	(set g_falcon_crash TRUE)
	
	(cs_fly_by ps_falcon_01/exposure_01c_02)	

	(sleep_forever)					
)


; falcon_02 =====================================================================================================================================================================================

(script command_script cs_falcon_02
	(print "cs_falcon_02")
	
	(ai_place sq_falcon_02_trooper)
	(ai_cannot_die sq_falcon_02_trooper TRUE)
	(ai_force_low_lod sq_falcon_02_trooper)
	(ai_vehicle_enter_immediate sq_falcon_02_trooper/01 (ai_vehicle_get ai_current_actor) "falcon_p_l1")
	(ai_vehicle_enter_immediate sq_falcon_02_trooper/02 (ai_vehicle_get ai_current_actor) "falcon_p_r1")


	; start movement 
	(cs_fly_by ps_falcon_02/approach_01)
	(cs_fly_by ps_falcon_02/approach_04)
	(cs_vehicle_speed .5)
	(cs_fly_by ps_falcon_02/approach_05)
	(cs_vehicle_speed .1)

	; hover in sky	
	(cs_fly_to_and_face ps_falcon_02/hover_01 ps_falcon_02/face_01 1)

	
		; speed 
		(cs_vehicle_speed .25)
	;(cs_fly_by ps_falcon_02/cinematic_01_02 1)
		; speed 
		(cs_vehicle_speed .7)
		
	(cs_attach_to_spline "spline_falcon_01a")

; exposure_04 	
	;(cs_fly_by ps_falcon_01/exposure_04_01)
		
; exposure_05
)


(script command_script cs_falcon_02a
	(cs_enable_pathfinding_failsafe TRUE)
	(print "cs_falcon_02b")
	
	(object_cannot_die (ai_vehicle_get ai_current_actor) TRUE)
	;(object_can_take_damage (ai_vehicle_get ai_current_actor))
	
		; speed 
		(cs_vehicle_speed .25)
	(cs_fly_by ps_falcon_02/cinematic_01_02 1)
		; speed 
		(cs_vehicle_speed .5)
		
	(cs_attach_to_spline "spline_falcon_02a")
	
		(cs_fly_by ps_falcon_02/exposure_01a_01)
		
		; speed 
		(cs_vehicle_speed .7)
		
		(cs_fly_by ps_falcon_02/exposure_01a_02)
		(cs_attach_to_spline "")
		
		(cs_fly_by ps_falcon_02/exposure_01a_03)
	
	(cs_run_command_script ai_current_actor cs_falcon_02b)
)


(script command_script cs_falcon_02b
	(cs_enable_pathfinding_failsafe TRUE)
	(print "cs_falcon_02b")
	
	(cs_attach_to_spline "spline_falcon_02b")
		
		;speed
		(cs_vehicle_speed .4)
		
	(cs_fly_by ps_falcon_02/exposure_01b_01)
		
		;speed
		(cs_vehicle_speed .3)
		
	(cs_attach_to_spline "")
	
	(cs_fly_by ps_falcon_02/exposure_01b_02)
	(cs_face TRUE ps_falcon_02/face01)
	
		;speed
		(cs_vehicle_speed .7)
		
	(sleep_until 
		(begin
			(sleep 90)
			(cs_fly_by ps_falcon_02/exposure_01b_03 2)
			(sleep 90)
			(cs_fly_by ps_falcon_02/exposure_01b_02 2)
			
			;loop until player kills enough
			;(>= g_falcon_obj_control 50)
			FALSE
		)
	30 (* 30 20))
	
	;(cs_run_command_script ai_current_actor cs_falcon_02c)
					
)


(script command_script cs_falcon_02c
	(cs_enable_pathfinding_failsafe TRUE)
	(print "cs_falcon_02c")
	
		;speed
		(cs_vehicle_speed .5)
	
	(cs_attach_to_spline "spline_falcon_02c")
	(cs_fly_by ps_falcon_02/exposure_01c_01)	
	
		(cs_attach_to_spline "")
		
		(sleep 60)
		
	(cs_fly_by ps_falcon_02/exposure_01c_02)

	(sleep_forever)					
)


; falcon_crash =====================================================================================================================================================================================
(global boolean g_falcon_crash FALSE)
(script dormant falcon_crash
	
	; Waiting for one of the falcons to reach the end of its command script 
	(sleep_until g_falcon_crash 1)
	(sleep 100)
	
	(cinematic_enter 035lb_falconcrash TRUE)
	
	; dead crew
	(setup_spire_bodies)
	
	; remove falcon
	(vehicle_set_player_interaction (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_g_r" FALSE FALSE)
	(unit_exit_vehicle player0)
	(unit_exit_vehicle player1)
	(unit_exit_vehicle player2)
	(unit_exit_vehicle player3)
	(sleep_until (not (any_players_in_vehicle)) 1)
	
	(object_destroy (ai_vehicle_get_from_squad sq_falcon_01 0))
	(object_destroy (ai_vehicle_get_from_squad sq_falcon_02 0))
	(ai_cannot_die sq_falcon_01_trooper FALSE)
	(ai_cannot_die sq_falcon_02_trooper FALSE)
	(sleep 1)
	
	(object_hide player0 TRUE)
	(object_hide player1 TRUE)
	(object_hide player2 TRUE)
	(object_hide player3 TRUE)
	
	; removing of previous ai
	(ai_erase_all)
	;(ai_disposable gr_falcon_cov TRUE)
	;(ai_disposable gr_falcon_allies TRUE)
	;(ai_erase sq_jorge)
	
	; set up for player full health
	(unit_add_equipment player0 profile_full_health TRUE FALSE)
	
	(if (or editor_cinematics (not (editor_mode))) 
		(begin
			(print "cinematic: 035lb_falconcrash")
			;(035lb_falconcrash)
			(f_play_cinematic_advanced 035lb_falconcrash set_falcon set_spire)
		)
	)
	
	(object_create sc_spire_crashed_falcon_01)
	(object_create sc_spire_crashed_falcon_02)
	(object_create sc_falcon_chunk01)
	(object_create sc_falcon_chunk02)
	(object_create sc_falcon_chunk03)

	; teleporting players 
	(object_teleport_to_ai_point player0 ps_teleports/spire00)
	(object_teleport_to_ai_point player1 ps_teleports/spire01)
	(object_teleport_to_ai_point player2 ps_teleports/spire02)
	(object_teleport_to_ai_point player3 ps_teleports/spire03)
	
	(if (not (game_is_cooperative))
		(begin
			(object_destroy dm_sky_frigate01b)
			(sleep 1)
			(object_create dm_sky_frigate01b)
			(simplify_frigate_turrets_02 dm_sky_frigate01b)
			(frigate01b_load_gunners)
			(cs_run_command_script sq_sky_frigate01_right_gunners cs_falcon_frigate_spire)
		)
	)

	(cinematic_exit 035lb_falconcrash TRUE)
	
	(sleep 60)
	(game_save_immediate)
)


;=============================== banshees =====================================================================================================================================================================================

(script command_script falcon_banshee
	(cs_enable_pathfinding_failsafe TRUE)
		
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_falcon_banshee_01/approach_01)
	(cs_fly_by ps_falcon_banshee_01/approach_02)
	(cs_fly_by ps_falcon_banshee_01/approach_03)			
		(cs_vehicle_boost FALSE)			
)

(script command_script falcon_banshee_attack
	(cs_enable_pathfinding_failsafe TRUE)
		
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_falcon_banshee_02/approach_01)
	(cs_fly_by ps_falcon_banshee_02/approach_02)
		(cs_vehicle_boost FALSE)			
)

(script command_script falcon_banshee_retreat
	(cs_enable_pathfinding_failsafe TRUE)
		
		(cs_vehicle_boost TRUE)
	(cs_fly_by ps_falcon_banshee_02/exit_01)
	(cs_fly_by ps_falcon_banshee_02/exit_02)
	(cs_fly_by ps_falcon_banshee_02/erase)
	(ai_erase ai_current_squad)	
)

;====================================================================================================================================================================================================
; SPIRE ==============================================================================================================================================
;====================================================================================================================================================================================================

(script dormant enc_spire
	; set eighth mission segment
	(data_mine_set_mission_segment "m35_08_enc_spire")

	; player setup
	(unit_add_equipment player0 profile_spire TRUE FALSE)
	(unit_add_equipment player1 profile_spire TRUE FALSE)
	(unit_add_equipment player2 profile_spire TRUE FALSE)
	(unit_add_equipment player3 profile_spire TRUE FALSE)
	
	; trun off deathless
	(object_cannot_die player0 FALSE)
	(object_cannot_die player1 FALSE)
	(object_cannot_die player2 FALSE)
	(object_cannot_die player3 FALSE)
	
	; turn off falcon soft ceiling
	(soft_ceiling_enable m35_flight FALSE)
	
	; initial AI
	(wake spire_place_01)
	(wake md_spire_start)
	(wake md_spire_up)
	(wake md_spire_interior)
	
	; bob the elite
		(if (>= g_bob_number 3)
			(ai_place sq_spire_bob)
		)
	
	; objects
	(wake spire_place_objects)
	
	; flocks
	(wake flocks_04_start)
	
	; ai lod
	(ai_lod_full_detail_actors 15)
	
	; phantoms teleporting from spire
	;(wake spire_phantoms)
	
	; waypoints
	(wake spire_waypoints)
	
	; music
	(wake music_spire)
	
	; training
	(wake spire_focus_training)
	
	; saves
	(wake spire_grav_base_save)
	
	; respawn
	(game_safe_to_respawn TRUE)
	;*
	(if (game_is_cooperative)
		(wake spire_coop_respawn)
	)
	*;
	
	; spawn jorge
	(ai_place sq_jorge/spire)
	(ai_cannot_die gr_spartans TRUE)
	(set obj_jorge (ai_get_unit gr_jorge))
	(ai_force_full_lod sq_jorge)
	(ai_set_objective gr_spartans obj_spire_allies)

	; spartan waypoints
	(if (not (game_is_cooperative))
		(begin
			(sleep_forever spartan_waypoints_falcon)
			(wake spartan_waypoints_spire)
		)
	)
	
	;Trigger Volumes =================================

	(sleep_until (volume_test_players tv_spire_01) 1)
	(if debug (print "set objective control 1"))
	(set g_spire_obj_control 1)
		
		(game_save)

	(sleep_until (volume_test_players tv_spire_02) 1)
	(if debug (print "set objective control 2"))
	(set g_spire_obj_control 2)
		
		(game_save)

	(sleep_until (volume_test_players tv_spire_03) 1)
	(if debug (print "set objective control 3"))
	(set g_spire_obj_control 3)
		
		; base AI
		(wake spire_place_02)	
		
		; upper AI
		(wake spire_place_03)	
		
		(game_save)

	(sleep_until (volume_test_players tv_spire_04) 1)
	(if debug (print "set objective control 4"))
	(set g_spire_obj_control 4)
		
		; music
		(set g_music03 TRUE)
		
		(f_ai_magically_see_players gr_spire_top_cov)
		;(game_save_no_timeout)
		
	(sleep_until (volume_test_players tv_spire_05) 1)
	(if debug (print "set objective control 5"))
	(set g_spire_obj_control 5)
		
		(game_save)
	
	;(sleep_until (<= (ai_living_count gr_spire_top_cov) 0))
	(sleep_until (not (volume_test_objects tv_spire_top (ai_get_object gr_spire_top_cov))))
	(device_set_power dc_spire_01 1)
	(sleep_until (> (device_get_position dc_spire_01) 0) 1)
	
	; music
	(set g_music04 TRUE)
	
	;cinematic
	(cinematic_enter 035lc_blackship_reveal true)
	
	(ai_erase_all)
	(object_destroy dm_sky_frigate01b)
	(object_destroy dm_sky_frigate02b)
	
	(flock_delete fk_phantoms_04)
	(flock_delete fk_wraiths_04)
	(flock_delete fk_ghosts_04)
	(flock_delete fk_scorpions_04)
	(flock_delete fk_warthogs_04)
	(flock_delete fk_banshee_04)
	(flock_delete fk_falcon_04)
	
	(f_end_mission 035lc_blackship_reveal set_ending)
	(print "M35 done")
	(game_won)
)

; SPIRE secondary scripts =======================================================================================================================================

(script dormant spire_place_01
	; banshees
	(ai_place sq_spire_banshee_01)
	(ai_place sq_spire_banshee_02)
	
	; upper encounters 
	;(ai_place sq_spire_plasma_01)
	;	(sleep 1)
	; ground encounters
	(ai_place sq_spire_jackal_01)
		(sleep 1)
	(ai_place sq_spire_skirmisher_01)
	(ai_place sq_spire_skirmisher_02)
	(ai_place sq_spire_plasma_03)
		(sleep 1)
	(ai_place sq_spire_grunt_03_left)
	(ai_place sq_spire_grunt_04_left)
		(sleep 1)
	(ai_place sq_spire_grunt_03_right)
	(ai_place sq_spire_grunt_04_right)
		(sleep 1)
	(ai_place sq_spire_base_shade_01)
	
	(sleep_until (>= g_spire_obj_control 3))
	(ai_magically_see gr_spire_base_cov gr_jorge)
	(f_ai_magically_see_players gr_spire_base_cov)
)

(script dormant spire_place_02
	
	; base encounters 
	(ai_place sq_spire_base_cov_01)
	(ai_place sq_spire_base_cov_02)
		(sleep 1)
	(ai_place sq_spire_base_cov_03)
	(ai_place sq_spire_base_center)
		(sleep 1)
	(ai_place sq_spire_base_grunts_left)
	(ai_place sq_spire_base_grunts_right)
	
	(sleep_until (<= (ai_living_count gr_spire_base_cov) 0))
	(game_save)
)
	
(script dormant spire_place_03

; perf
(sleep_until (volume_test_players tv_spire_top))

	; upper encounters 
	(ai_place sq_spire_elite_01)
	(if (game_is_cooperative)
		; coop: two concussion elite
		(begin
			(ai_place sq_spire_elite_02)
			(ai_place sq_spire_elite_03)
		)
		; single: two flak grunt
		(ai_place sq_spire_grunt_01)
	)
	(ai_place sq_spire_grunt_02)
	
	(if (>= (game_coop_player_count) 3)
		(begin
			(ai_place sq_spire_engineer)
			(sleep_until (not (volume_test_objects tv_spire_top (object_get_ai gr_spire_top_cov))))
			(cs_run_command_script sq_spire_engineer cs_spire_engineer_exit)
		)
	)

)


(script dormant spire_place_objects
	(sleep_until (= (current_zone_set_fully_active) 8) 5)
	(object_create w_spire_focus)
	(object_create v_spire_pickup_01)
	(object_create v_spire_pickup_02)
	
	(wake jorge_in_pickup_save)
	(wake player_in_banshee_save)
)

(script dormant jorge_in_pickup_save
	(sleep_until 
		(or
			(vehicle_test_seat_unit v_spire_pickup_01 "pickup_g" (ai_get_unit sq_jorge))
			(vehicle_test_seat_unit v_spire_pickup_02 "pickup_g" (ai_get_unit sq_jorge))
		)
	)
	(print "jorge in pickup: game save")
	(game_save)
)

(script dormant player_in_banshee_save
	(sleep_until 
		(or
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad sq_spire_banshee_01 0) "banshee_d" (players))
			(vehicle_test_seat_unit_list (ai_vehicle_get_from_squad sq_spire_banshee_02 0) "banshee_d" (players))
		)
	)
	(print "player in banshee: game save")
	(game_save)
)

(script command_script cs_spire_grunt01
	(sleep 5)
	(print "yoo hoo")
	(cs_abort_on_damage TRUE)
	(cs_go_to ps_spire_grunts/goto01)
	(sleep_until (volume_test_players tv_spire_top_grunt01) 10)
	(cs_shoot_point TRUE ps_spire_grunts/goto01_shoot)
	(sleep 90)
	(cs_enable_targeting TRUE)
	(sleep 130)
	
)

(script command_script cs_spire_grunt02
	(cs_abort_on_damage TRUE)
	(cs_go_to ps_spire_grunts/goto02)
	(sleep_until (volume_test_players tv_spire_top_grunt02) 10)
	(cs_shoot_point TRUE ps_spire_grunts/goto02_shoot)
	(sleep 90)
	(cs_enable_targeting TRUE)
	(sleep 130)
	
)

(script command_script cs_spire_engineer_exit
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_to ps_spire_engineer/p0)
	(cs_fly_to ps_spire_engineer/p1)
	(cs_fly_to ps_spire_engineer/p2)
	(cs_fly_to ps_spire_engineer/p3)
	(sleep_forever)
	;*
	(object_set_scale (ai_get_object ai_current_actor) .01 (* 30 5))
	(sleep (* 30 5))
	(ai_erase ai_current_actor)
	*;
)


(script command_script cs_spire_banshees
	(cs_vehicle_boost TRUE)
	(ai_prefer_target_ai ai_current_actor gr_spartans TRUE)
	(sleep 130)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(sleep 200)
)

(script dormant spire_phantoms
	(ai_place sq_spire_phantom)
)

(script command_script cs_spire_phantom
	(effect_new_on_object_marker "fx\fx_library\object_spawn\object_spawn_vehicles.effect" (ai_vehicle_get ai_current_actor) "")
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_spire_phantom/p0)
	(begin_random_count 1
		(cs_fly_by ps_spire_phantom/p1a)
		(cs_fly_by ps_spire_phantom/p1b)
		(cs_fly_by ps_spire_phantom/p1c)
	)
	(f_vehicle_scale_destroy (ai_vehicle_get ai_current_actor))
	
)


(script dormant spire_focus_training
	(sleep_until
		(or
		(unit_has_weapon  player0 objects\weapons\rifle\focus_rifle\focus_rifle.weapon)
		(unit_has_weapon  player1 objects\weapons\rifle\focus_rifle\focus_rifle.weapon)
		(unit_has_weapon  player2 objects\weapons\rifle\focus_rifle\focus_rifle.weapon)
		(unit_has_weapon  player3 objects\weapons\rifle\focus_rifle\focus_rifle.weapon)
	   )
	5)
	(sleep 10)
	(f_hud_training_new_weapon)

)

(script dormant spire_grav_base_save
	(if (game_is_cooperative)
		; if coop: save when ALL players around base
		(wake spire_grav_base_save_coop)
		; if single: save when player near grav lift
		(wake spire_grav_base_save_single)
	)
)

(script dormant spire_grav_base_save_single
	(sleep_until 
		(begin
			(sleep_until (volume_test_players tv_spire_grav_base))
			(print "spire base: game save")
			(game_save)
			FALSE	
		)
	)
)

(script dormant spire_grav_base_save_coop
	(sleep_until (volume_test_players_all tv_spire_base))
	(print "spire base coop: game save")
	(game_save_no_timeout)
	
)

(script dormant spire_coop_respawn
	(sleep_until
		(begin
			(sleep_until (volume_test_players_all tv_spire_top) 5)
			(game_safe_to_respawn FALSE)
			(sleep_until (not (volume_test_players_all tv_spire_top)) 5)
			(game_safe_to_respawn TRUE)
			FALSE
		)
	)
)


; SPIRE Shade scripts =======================================================================================================================================

(script command_script cs_spire_shade
	(cs_abort_on_damage TRUE)
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot_point TRUE ps_spire_shade/p0)
				(cs_shoot_point TRUE ps_spire_shade/p1)
				(cs_shoot_point TRUE ps_spire_shade/p2)
				(cs_shoot_point TRUE ps_spire_shade/p3)
				(cs_shoot_point TRUE ps_spire_shade/p4)
				(cs_shoot_point TRUE ps_spire_shade/p5)
			)
			(print "done")
			(and
				(>= g_spire_obj_control 3)
				(not (volume_test_players tv_spire_halfway_area))
			)
			)
	80)
)

; leader scripts =======================================================================================================================================
;*
(script command_script cs_spire_leader
	(cs_abort_on_damage TRUE)
	(sleep_until 
		(or
			(>= g_spire_obj_control 5)
			(<= (ai_living_count gr_spire_top_cov) 3)
		)
	)
)
*;

; SPIRE Waypoints =======================================================================================================================================
(script dormant spire_waypoints
	(branch
		(>= (device_get_position dc_spire_01) 1)
		(hud_unblip_all)
	)
	
	;player advances up the hill
	(sleep_until (>= g_spire_obj_control 2) 30 (f_get_waypoint_time_for_difficulty))
	(if (not (>= g_spire_obj_control 2))
		(begin
			(f_blip_object dc_spire_01 blip_default)
			(sleep_until (>= g_spire_obj_control 4) 5)
			(hud_unblip_all)
		)
	)
	(game_save)
	
	;player enters top of spire
	(sleep_until (>= g_spire_obj_control 4) 30 (f_get_waypoint_time_for_difficulty))
	(if (not (>= g_spire_obj_control 4))
		(begin
			(f_blip_object dc_spire_01 blip_default)
			(sleep_until (>= g_spire_obj_control 4) 5)
			(hud_unblip_all)
		)
	)
	(game_save)
	
	;player leaves top of spire
	(sleep_until
	(begin
	
	(sleep_until (not (volume_test_players_all tv_spire_top)))
	(sleep 200)
	(if (not (<= (ai_living_count gr_spire_top_cov) 0))
		(begin
			(f_blip_object dc_spire_01 blip_default)
			(md_spire_interior_remind)
			(sleep_until (volume_test_players_all tv_spire_top) 5)
			(hud_unblip_all)
		)
	)
	(game_save)
	
	FALSE
	)
	)
	
)

;====================================================================================================================================================================================================
; GARBAGE COLLECTION SCRIPTS ==========================================================================================================================================
;====================================================================================================================================================================================================

(script dormant garbage_collect

	; hill total 
	(sleep_until (>= (current_zone_set) 3) 1)
		(if debug (print "recycle"))	
		(add_recycling_volume tv_sp_hill 0 0)
		(ai_erase gr_hill_cov)
		(ai_erase_inactive gr_allies 30)
		
	; BFG01
	(sleep_until g_bfg01_core_destroyed 1)
		;BFG destruction time = (* 16 30)
		(sleep (* 5 30))
		(add_recycling_volume tv_sp_bfg01 5 8)
		(sleep (* 8 30))
		(add_recycling_volume tv_sp_bfg01 5 2)

	; twin total 
	(sleep_until (>= (current_zone_set) 4) 1)
		(if debug (print "recycle"))
		(object_set_persistent (ai_vehicle_get_from_squad sq_twin_bfg_driver 0) FALSE)
		(sleep 1)
		(add_recycling_volume tv_sp_twin 0 0)						
		(ai_erase gr_twin_cov)
		(ai_erase_inactive gr_allies 30)
		
	; facility total 
	(sleep_until (>= (current_zone_set) 5) 1)
		(if debug (print "recycle"))
		(add_recycling_volume tv_sp_facility 0 0)		
		(ai_erase gr_facility_cov)

		;(object_destroy (ai_vehicle_get_from_starting_location sq_hill_allies_01/warthog))
		;(object_destroy (ai_vehicle_get_from_starting_location sq_hill_allies_02/warthog))		
		;(ai_erase gr_hill_allies)
		;(ai_erase gr_facility_allies)
		(ai_erase_inactive gr_allies 30)

	; cannon partial 
	(sleep_until g_bfg02_core_destroyed 1)
		(if debug (print "recycle"))
		(add_recycling_volume tv_sp_cannon 30 30)
		
	; cannon total 
	(sleep_until (>= (current_zone_set) 6) 1)
	(sleep_until (>= g_falcon_obj_control 15) 1)
		(if debug (print "recycle"))
		(object_set_persistent (ai_vehicle_get_from_squad sq_cannon_bfg_driver 0) FALSE)
		(sleep 1)
		(add_recycling_volume tv_sp_cannon 0 0)
		(ai_erase gr_cannon_canyon)
		(ai_erase gr_cannon_cov)
		(ai_erase gr_cannon_allies)
		(ai_erase_inactive gr_allies 30)
	
	; falcon total 
	(sleep_until (>= (current_zone_set) 9) 1)
		(if debug (print "recycle"))
		(add_recycling_volume tv_sp_falcon 0 0)
		(ai_erase gr_falcon_cov)
		(ai_erase_inactive gr_allies 30)
		
	; spire partial 
	(sleep_until (>= g_spire_obj_control 1) 1)
		(if debug (print "recycle"))
		(add_recycling_volume tv_sp_spire 30 30)

	; spire cinematic total
	(sleep_until (= (device_get_position dc_spire_01) 1) 1)
		(if debug (print "recycle"))
		(add_recycling_volume tv_sp_spire 0 0)
		(ai_erase gr_cov)
		(ai_erase_inactive gr_allies 30)
)

(script continuous recycle_all_continuous
	(sleep_until
		(begin
			(if (volume_test_players tv_sp_hill)
				(recycle_lite_go tv_sp_hill)
				(recycle_go tv_sp_hill)
			)
			
			(if (volume_test_players tv_sp_twin)
				(recycle_lite_go tv_sp_twin)
				(recycle_go tv_sp_twin)
			)
			
			(if (volume_test_players tv_sp_facility)
				(recycle_lite_go tv_sp_facility)
				(recycle_go tv_sp_facility)
			)
			
			(if (volume_test_players tv_sp_cannon)
				(recycle_lite_go tv_sp_cannon)
				(recycle_go tv_sp_cannon)
			)
			
			(if (volume_test_players tv_sp_falcon)
				(if (game_is_cooperative)
					(recycle_falcon_go tv_sp_falcon)
					(recycle_medium_go tv_sp_falcon)
				)
				(recycle_go tv_sp_falcon)
			)
			
			(if (volume_test_players tv_sp_spire)
				(recycle_lite_go tv_sp_spire)
				(recycle_go tv_sp_spire)
			)
			
			FALSE
		)
	400)
)

(script static void (recycle_lite_go (trigger_volume vol))
	(add_recycling_volume vol 60 5)
)

(script static void (recycle_medium_go (trigger_volume vol))
	(add_recycling_volume vol 20 5)
)

(script static void (recycle_falcon_go (trigger_volume vol))
	(add_recycling_volume vol 0 5)
)

(script static void (recycle_go (trigger_volume vol))
	(add_recycling_volume vol 0 0)
)

;====================================================================================================================================================================================================
; Sky Scripts ==========================================================================================================================================
;====================================================================================================================================================================================================
(script static void test_sky
	(wake flocks_01_start)
	;(wake frigate_setup)
)

(script dormant flocks_01_start
	(print "flocks_01")
	(flock_create fk_banshee_01)
	(flock_create fk_falcon_01)
	
	(flock_create fk_warthogs01)
	(flock_create fk_ghosts01)
	
	;*
	(sleep 200)
	(print "stopping flocks_01 banshees and falcons")
	(flock_stop fk_banshee_01)
	(flock_stop fk_falcon_01)
	*;
	
	(sleep_until (>= g_hill_obj_control 4))
	(print "destroying flocks_01 banshees and falcons")
	(flock_destroy fk_banshee_01)
	(flock_destroy fk_falcon_01)
	(sleep (* 4 30))
	
	(wake flocks_02_start)
	
)

(script dormant flocks_02_start
	(print "flocks_02")
	(flock_create fk_scorpions02)
	(flock_create fk_wraiths02)
	(flock_create fk_warthogs02)
	(flock_create fk_ghosts02)
	(flock_create fk_falcon_02)
	(flock_create fk_banshee_02)
	
	(sleep_until g_bfg01_core_destroyed)
	
	(sleep_until g_bfg02_core_destroyed)
	(wake flocks_02b_start)
)

(script dormant flocks_02b_start
	(print "flocks_02b_start")
	(flock_create fk_falcon_twin)
	(flock_create fk_pelican_twin)
	(sleep 600)
	(flock_stop fk_falcon_twin)
	(flock_stop fk_pelican_twin)
	
	(sleep_until (>= g_facility_obj_control 1))
	
	(flock_destroy fk_warthogs01)
	(flock_destroy fk_ghosts01)
	
	(print "flocks_02: destroy")
	(flock_destroy fk_scorpions02)
	;(flock_destroy fk_wraiths02)
	(flock_destroy fk_warthogs02)
	(flock_destroy fk_ghosts02)
	(flock_destroy fk_banshee_02)
)

(script dormant flocks_02c_start
	(print "flocks_02c_start")
	(flock_create fk_banshee_02c)
	(flock_create fk_falcon_02c)
	
	(sleep_until g_bfg02_destroyed)
	(flock_destroy fk_banshee_02c)
	
)

(script dormant flocks_03_start
	;wait until player enters falcon experience
	(sleep_until (>= g_falcon_obj_control 10))
	
	(print "flocks_03_start")
	(flock_create fk_warthogs03)
	(flock_create fk_ghosts_03)
	(flock_create fk_scorpions_03)
	(flock_create fk_wraiths_03)
	(flock_create fk_phantoms_03)
	
	(sleep_until (>= g_falcon_obj_control 20) 5)
	(flock_create fk_banshee_03)
	
	(sleep_until (>= g_falcon_obj_control 30) 5)
	(sleep 200)
	(flock_create fk_falcon_03)
	
	(sleep_until (>= g_falcon_obj_control 50) 5)
	(print "flocks_03: destroy")
	(flock_stop fk_warthogs03)
	(flock_stop fk_ghosts_03)
	(flock_stop fk_scorpions_03)
	(flock_stop fk_wraiths_03)
	(flock_stop fk_banshee_03)
	(flock_stop fk_falcon_03)
	(flock_stop fk_phantoms_03)
	
)

(script dormant flocks_04_start
	(print "flocks_04_start")
	(flock_delete fk_warthogs03)
	(flock_delete fk_ghosts_03)
	(flock_delete fk_scorpions_03)
	(flock_delete fk_wraiths_03)
	(flock_delete fk_banshee_03)
	; delete falcon flock from BFG02 to keep them out of outro cinematic
	(flock_delete fk_falcon_02c)
	(flock_delete fk_falcon_03)
	(flock_delete fk_phantoms_03)
	(sleep 1)
	
	(flock_create fk_phantoms_04)
	(flock_create fk_wraiths_04)
	(flock_create fk_ghosts_04)
	(flock_create fk_scorpions_04)
	(flock_create fk_warthogs_04)
	(flock_create fk_banshee_04)
	(flock_create fk_falcon_04)
	
)


(script dormant sky_scarab01_start
	(sky_scarab_anim dm_scarab01)
)

(script dormant sky_scarab02_start
	(sky_scarab_anim dm_scarab02)
)

(script dormant sky_scarab03_start
	(sky_scarab_anim dm_scarab03)
)

(script static void (sky_scarab_anim (device_name scarab))
	(sleep_until
		(begin
			(device_set_position_track scarab stationary_march 0)
			(device_animate_position scarab 1.0 (random_range 7 10) 1.0 1.0 TRUE)
			(sleep_until (>= (device_get_position scarab) 1) 1)
			(sleep (random_range 0 20))
		0)
	)
)

(script dormant twin_scarab_destruction
	(sleep (random_range 220 250))
	(print "twin_scarab_destruction")
	(begin_random
		(begin
			(sleep_forever sky_scarab01_start)
			(wake sky_scarab01_death)
			(sleep (random_range 20 120))
		)
		(begin
			(sleep_forever sky_scarab02_start)
			(wake sky_scarab02_death)
			(sleep (random_range 20 120))
		)
		(begin
			(sleep_forever sky_scarab03_start)
			(wake sky_scarab03_death)
			(sleep (random_range 20 120))
		)
		
	)
	
)

(script dormant sky_scarab01_death
	(destroy_scarab dm_scarab01)
)

(script dormant sky_scarab02_death
	(destroy_scarab dm_scarab02)
)

(script dormant sky_scarab03_death
	(destroy_scarab dm_scarab03)
)

(script static void (destroy_scarab (device_name scarab))
	(sleep_until
		(or
			(>= (device_get_position scarab) 1)
			(<= (device_get_position scarab) 0)
		)
	)
	
	(device_set_position_track scarab "device:scarab_death" 0)
	(device_animate_position scarab 1.0 (random_range 9 12) 1.0 1.0 TRUE)
	(sleep_until (>= (device_get_position scarab) 1) 1)
	(object_set_permutation scarab "default" "destroyed")
	(print "scarab dead FX")
	(effect_new_on_object_marker "objects\giants\scarab\fx\destruction\main_explosion.effect" scarab "")
)


; Twin Longswords =====================================================================================================================================================================================

(script dormant twin_longswords_start
	(wake md_twin_longswords)
	(sleep (* 10 30))
	;(sleep_until g_longswords01_clear)
	
	(object_create dm_longswords)
	(object_create sc_longsword_01)
	(object_create sc_longsword_02)
	(object_create sc_longsword_03)
		(sleep 1)
	(device_set_position_track dm_longswords m35_fp1 0)
	(objects_attach dm_longswords "longsword01" sc_longsword_01 "")
	(objects_attach dm_longswords "longsword02" sc_longsword_02 "")
	(objects_attach dm_longswords "longsword03" sc_longsword_03 "")
	(device_animate_position dm_longswords 1.0 15 0 0 TRUE)
	(sleep_until (>= (device_get_position dm_longswords) .5) 1)
	(flock_destroy fk_wraiths02)
	(twin_longsword_fx_start)
	
	(sleep_until (>= (device_get_position dm_longswords) 1) 1)
	(object_destroy dm_longswords)
	(object_destroy sc_longsword_01)
	(object_destroy sc_longsword_02)
	(object_destroy sc_longsword_03)
	
)


(script static void twin_longsword_fx_start
	(print "longsword FX")
	(effect_new_at_ai_point "fx\fx_library\explosions\human_longsword_bomb\human_longsword_bomb.effect" ps_twin_longswords/p0)
	(sleep 5)
	(effect_new_at_ai_point "fx\fx_library\explosions\human_longsword_bomb\human_longsword_bomb.effect" ps_twin_longswords/p1)
	(sleep 5)
	(effect_new_at_ai_point "fx\fx_library\explosions\human_longsword_bomb\human_longsword_bomb.effect" ps_twin_longswords/p2)
	(sleep 5)
	(effect_new_at_ai_point "fx\fx_library\explosions\human_longsword_bomb\human_longsword_bomb.effect" ps_twin_longswords/p3)
	(sleep 5)
	(effect_new_at_ai_point "fx\fx_library\explosions\human_longsword_bomb\human_longsword_bomb.effect" ps_twin_longswords/p4)
	(sleep 5)
	(effect_new_at_ai_point "fx\fx_library\explosions\human_longsword_bomb\human_longsword_bomb.effect" ps_twin_longswords/p5)
	(sleep 5)
	(effect_new_at_ai_point "fx\fx_library\explosions\human_longsword_bomb\human_longsword_bomb.effect" ps_twin_longswords/p6)
)

(script static void (f_ls_flyby (device_name d))
	(object_create d)
	(device_set_position_immediate d 0)
	(object_set_scale d 1 10)
	(device_set_position d 1)
	
	(sleep_until (>= (device_get_position d) .9) 1)
	(print "longsword done")
	(object_destroy d)
)

; TWIN Frigate scripts =======================================================================================================================================

(script command_script cs_twin_frigate
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point TRUE ps_twin_frigate/p0)
				(cs_shoot_point TRUE ps_twin_frigate/p1)
				(cs_shoot_point TRUE ps_twin_frigate/p2)
				(cs_shoot_point TRUE ps_twin_frigate/p3)
				(cs_shoot_point TRUE ps_twin_frigate/p4)
			)
			FALSE
			)
	30)
)

(script command_script cs_twin_frigate_sky
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_shoot_point TRUE ps_twin_frigate_sky/p0)
				(cs_shoot_point TRUE ps_twin_frigate_sky/p1)
				(cs_shoot_point TRUE ps_twin_frigate_sky/p2)
				(cs_shoot_point TRUE ps_twin_frigate_sky/p3)
				(cs_shoot_point TRUE ps_twin_frigate_sky/p4)
			)
			FALSE
			)
	80)
)


; frigate fire control =====================================================================================================================================================================================

(script dormant frigate_setup
	(print "frigate_setup")
	(object_create dm_sky_frigate01)
	(object_hide dm_sky_frigate01 TRUE)
	(simplify_frigate_turrets dm_sky_frigate01)
	(object_create dm_sky_frigate02)
	(object_hide dm_sky_frigate02 TRUE)
	(simplify_frigate_turrets_02 dm_sky_frigate02)
	
	(wake frigate_move_control_start)
	
	(sleep 1)
	(frigate01_load_gunners)
	(wake frigate_target_control)
	
	(sleep 160)
	;brings in longswords
	(wake twin_longswords_start)
	
)

(script static void test
	(object_create dm_sky_frigate02)
	(simplify_frigate_turrets_02 dm_sky_frigate02)
)

(script static void (simplify_frigate_turrets (device_name frigate))
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 2))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 2))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 2))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 2))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 2))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 4))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 4))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 4))
	;(sleep 1)
	;(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 2))
	;(sleep 1)
	;(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 2))
	;(sleep 1)
	;(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 0))
	;(sleep 1)
	;(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 0))
)

(script static void (simplify_frigate_turrets_02 (device_name frigate))
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 0))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 0))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 0))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 0))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 0))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 0))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 0))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 2))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 2))
	(sleep 1)
	(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 2))
	;(sleep 1)
	;(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 0))
	;(sleep 1)
	;(object_destroy (list_get (object_list_children frigate "objects\vehicles\human\turrets\frigate_turret_medium\frigate_turret_medium.vehicle") 0))
)


(script dormant frigate_move_control_start
	(print "FRIGATE: moving")

	(device_set_position_track dm_sky_frigate01 "m35_advance0" 0)
	(device_set_position_immediate dm_sky_frigate01 0)
	(object_hide dm_sky_frigate01 FALSE)
	(device_animate_position dm_sky_frigate01 .4 3 .1 .5 FALSE)
	(sleep (* 30 3))
	(print "frig")
	(device_animate_position dm_sky_frigate01 1 32 .1 .1 FALSE)
	

	(sleep (random_range 200 220))
	(device_set_position_track dm_sky_frigate02 "m35_advance0" 0)
	(device_set_position_immediate dm_sky_frigate02 0)
	(device_animate_position dm_sky_frigate02 1 41 .1 .1 FALSE)
	(sleep 1)
	(object_hide dm_sky_frigate02 FALSE)

)

(script dormant frigate_falcon_setup
	(ai_erase sq_sky_frigate01_right_gunners)
	(object_destroy dm_sky_frigate01)
	(object_destroy dm_sky_frigate02)
		(sleep 1)
	(object_create dm_sky_frigate01b)
	(simplify_frigate_turrets dm_sky_frigate01b)
	
	(if (game_is_cooperative)
		(sleep_forever)
	)
	
	(object_create dm_sky_frigate02b)
	(simplify_frigate_turrets_02 dm_sky_frigate02b)
		(sleep 1)
	(frigate01b_load_gunners)
	;(frigate02b_load_gunners)
	
	(wake falcon_frigate_target_control)
	
)


(script dormant frigate_target_control
	
	(sleep_until (>= (device_get_position dm_sky_frigate01) .5))
	(cs_run_command_script sq_sky_frigate01_right_gunners cs_twin_frigate_sky)
	(wake twin_scarab_destruction)
	
	(if (>= (game_coop_player_count) 3)
		(sleep_forever)
	)
	
	(sleep_until (>= (device_get_position dm_sky_frigate01) .6))
	
	(print "frigate01: targeting phantom")
	(cs_run_command_script sq_sky_frigate01_right_gunners cs_twin_frigate)
	
	(sleep 150)
	(cs_run_command_script sq_sky_frigate01_right_gunners abort_cs)
	
	(ai_set_targeting_group sq_sky_frigate01_right_gunners 11)
	(ai_set_targeting_group sq_phantom_03 11)
	
	;*
	(ai_prefer_target_ai sq_sky_frigate01_right_gunners obj_twin_cov/twin_cov_lower_destroyed TRUE)
	(ai_magically_see sq_sky_frigate01_right_gunners obj_twin_cov/twin_cov_lower_destroyed)
	*;
	(sleep_until (>= (ai_living_count sq_phantom_03) 1) 30 (* 30 30))
	(sleep_until (<= (ai_living_count sq_phantom_03) 0) 30 (* 30 30))
	(sleep_until (<= (ai_task_count obj_twin_cov/twin_cov_lower_destroyed) 3) 30 (* 30 30))
	(cs_run_command_script sq_sky_frigate01_right_gunners cs_twin_frigate_sky)
	
	(print "frigate01: done helping player")
	;(ai_set_targeting_group sq_sky_frigate01_right_gunners 11)
)

(script static void frigate01_load_gunners

       (if debug (print "frigate01: loading gunners"))
       
       (ai_place sq_sky_frigate01_right_gunners)
       (ai_place sq_sky_frigate01_left_gunners)
       (ai_cannot_die sq_sky_frigate01_right_gunners TRUE)
       (ai_cannot_die sq_sky_frigate01_left_gunners TRUE)
       
       (ai_set_clump sq_sky_frigate01_right_gunners 1)
       (ai_set_clump sq_sky_frigate01_left_gunners 1)
       (ai_designer_clump_perception_range 600)
       
       (vehicle_load_magic (object_at_marker dm_sky_frigate01 "turret_right_bottom01") "" (ai_get_object sq_sky_frigate01_right_gunners/bottom01))
       (vehicle_load_magic (object_at_marker dm_sky_frigate01 "turret_right_bottom02") "" (ai_get_object sq_sky_frigate01_right_gunners/bottom02))
       (vehicle_load_magic (object_at_marker dm_sky_frigate01 "turret_left_bottom01") "" (ai_get_object sq_sky_frigate01_left_gunners/bottom01))
       (vehicle_load_magic (object_at_marker dm_sky_frigate01 "turret_left_bottom02") "" (ai_get_object sq_sky_frigate01_left_gunners/bottom02))
)

(script static void frigate01b_load_gunners

       (if debug (print "frigate01: loading gunners"))
       
       (ai_place sq_sky_frigate01_right_gunners)
       ;(ai_place sq_sky_frigate01_left_gunners)
       (ai_cannot_die sq_sky_frigate01_right_gunners TRUE)
       ;(ai_cannot_die sq_sky_frigate01_left_gunners TRUE)
       
       (ai_set_clump sq_sky_frigate01_right_gunners 1)
       ;(ai_set_clump sq_sky_frigate01_left_gunners 1)
       (ai_designer_clump_perception_range 600)
       
       (vehicle_load_magic (object_at_marker dm_sky_frigate01b "turret_right_bottom01") "" (ai_get_object sq_sky_frigate01_right_gunners/bottom01))
       (vehicle_load_magic (object_at_marker dm_sky_frigate01b "turret_right_bottom02") "" (ai_get_object sq_sky_frigate01_right_gunners/bottom02))
       ;(vehicle_load_magic (object_at_marker dm_sky_frigate01b "turret_left_bottom01") "" (ai_get_object sq_sky_frigate01_left_gunners/bottom01))
       ;(vehicle_load_magic (object_at_marker dm_sky_frigate01b "turret_left_bottom02") "" (ai_get_object sq_sky_frigate01_left_gunners/bottom02))
)

(script dormant falcon_frigate_target_control
	(sleep_until (>= g_falcon_obj_control 40))
	(cs_run_command_script sq_sky_frigate01_right_gunners cs_falcon_frigate)
	
	(sleep_until (>= g_falcon_obj_control 50))
	(cs_run_command_script sq_sky_frigate01_right_gunners cs_falcon_frigate_spire)
	(cs_run_command_script sq_sky_frigate01_left_gunners cs_falcon_frigate02)
	(cs_run_command_script sq_sky_frigate02_right_gunners cs_falcon_frigate_spire)
	
	;*
	(sleep_until
		(begin
			(begin_random_count 1
				(cs_run_command_script sq_sky_frigate01_right_gunners cs_falcon_frigate)
				(cs_run_command_script sq_sky_frigate01_left_gunners cs_falcon_frigate02)
				(cs_run_command_script sq_sky_frigate02_right_gunners cs_falcon_frigate_spire)
				(cs_run_command_script sq_sky_frigate01_right_gunners cs_falcon_frigate_spire)
				(cs_run_command_script sq_sky_frigate01_left_gunners cs_falcon_frigate_spire)
				(cs_run_command_script sq_sky_frigate02_right_gunners cs_falcon_frigate02)
				(cs_run_command_script sq_sky_frigate01_right_gunners sleep_cs)
				(cs_run_command_script sq_sky_frigate01_left_gunners sleep_cs)
				(cs_run_command_script sq_sky_frigate02_right_gunners sleep_cs)
			)
			(sleep (random_range 0 150))
			FALSE
		)
	)
	*;
	
)


(script command_script cs_falcon_frigate
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point TRUE ps_falcon_frigate/p0)
				(cs_shoot_point TRUE ps_falcon_frigate/p1)
				(cs_shoot_point TRUE ps_falcon_frigate/p2)
				(cs_shoot_point TRUE ps_falcon_frigate/p3)
				(cs_shoot_point TRUE ps_falcon_frigate/p4)
			)
			FALSE
		)
	)
)

(script command_script cs_falcon_frigate02
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point TRUE ps_falcon_frigate02/p0)
				(cs_shoot_point TRUE ps_falcon_frigate02/p1)
				(cs_shoot_point TRUE ps_falcon_frigate02/p2)
				(cs_shoot_point TRUE ps_falcon_frigate02/p3)
				(cs_shoot_point TRUE ps_falcon_frigate02/p4)
			)
			FALSE
		)
	)
)

(script command_script cs_falcon_frigate_spire
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point TRUE ps_falcon_frigate_spire/p0)
				(cs_shoot_point TRUE ps_falcon_frigate_spire/p1)
				(cs_shoot_point TRUE ps_falcon_frigate_spire/p2)
				(cs_shoot_point TRUE ps_falcon_frigate_spire/p3)
				(cs_shoot_point TRUE ps_falcon_frigate_spire/p4)
			)
			FALSE
		)
	)
)

(script static void frigate02_load_gunners

       (if debug (print "frigate02: loading gunners"))
       
       (ai_place sq_sky_frigate02_right_gunners)
       (ai_cannot_die sq_sky_frigate02_right_gunners TRUE)
       (vehicle_load_magic (object_at_marker dm_sky_frigate02 "turret_right_bottom01") "" (ai_get_object sq_sky_frigate02_right_gunners/bottom01))
       (vehicle_load_magic (object_at_marker dm_sky_frigate02 "turret_right_bottom02") "" (ai_get_object sq_sky_frigate02_right_gunners/bottom02))
)

(script static void frigate02b_load_gunners

       (if debug (print "frigate02: loading gunners"))
       
       (ai_place sq_sky_frigate02_right_gunners)
       (ai_cannot_die sq_sky_frigate02_right_gunners TRUE)
       (vehicle_load_magic (object_at_marker dm_sky_frigate02b "turret_right_bottom01") "" (ai_get_object sq_sky_frigate02_right_gunners/bottom01))
       (vehicle_load_magic (object_at_marker dm_sky_frigate02b "turret_right_bottom02") "" (ai_get_object sq_sky_frigate02_right_gunners/bottom02))
)

;==================================================================================================================
; Bob the Elite =========================================================================
;==================================================================================================================
(global short g_bob_number 0)
(script dormant bob_start
	(if (= g_bob_number 0)
		(begin_random_count 1
			(set g_bob_number 1)
			(set g_bob_number 2)    
			(set g_bob_number 3)
			(set g_bob_number 4)                                
		)
	)
		
)

(script command_script cs_bob_elite           
	(sleep_until
		(or
			(bob_will_run_from_player player0 ai_current_actor)
			(bob_will_run_from_player player1 ai_current_actor)
			(bob_will_run_from_player player2 ai_current_actor)
			(bob_will_run_from_player player3 ai_current_actor)
		)
	)
	
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_dialogue TRUE)          
	(print "SPECIAL ELITE SPOTTED")                               
	(sleep (* 30 25))
	(ai_set_active_camo ai_current_actor TRUE)
	(sleep 30)
	(print "SPECIAL FAIL")
	(sleep 1)
	(ai_erase ai_current_actor)
)

(script static boolean (bob_will_run_from_player (player player_num) (ai bob))
	(and
		(or
			(or
				(> (object_get_recent_shield_damage (ai_get_object bob)) 0)
				(> (object_get_recent_body_damage (ai_get_object bob)) 0)
			)
			(< (objects_distance_to_object player_num bob) 15)
		)
		(= (player_is_in_game player_num) true)
	)
)


;==================================================================================================================
; soft celiings =========================================================================
;==================================================================================================================
(script dormant soft_ceilings
	; set up
	(soft_ceiling_enable blocker_01 FALSE)
	(soft_ceiling_enable blocker_02 TRUE)
	(soft_ceiling_enable blocker_03 FALSE)
	(soft_ceiling_enable blocker_05 FALSE)
	(soft_ceiling_enable m35_flight FALSE)
	
	; soft kills
	(kill_volume_disable kill_soft_twin)
	
	; camera soft ceilings
	;*
	(sleep_until 
		(or
			(>= (current_zone_set) 2) 
			(volume_test_players tv_hill_kat)
		)
	1)
	*;
	(sleep_until (>= (current_zone_set_fully_active) 2) 1)
	(soft_ceiling_enable camera_blocker_01 FALSE)
	(soft_ceiling_enable camera_blocker_02 FALSE)
	
	(sleep_until (>= (current_zone_set) 3) 1)
	(soft_ceiling_enable blocker_01 TRUE)
	
	; after dropping into twin
	(sleep_until (>= (current_zone_set_fully_active) 3) 1)
	(soft_ceiling_enable camera_blocker_03 FALSE)
	(kill_volume_enable kill_soft_twin)

	; after the bridge comes down to go to facility
	(sleep_until g_bfg01_destroyed 1)
	(kill_volume_disable kill_soft_twin)
	(soft_ceiling_enable blocker_02 false)
	
	; after dropping into facility
	(sleep_until (>= (current_zone_set) 4) 1)
	(soft_ceiling_enable blocker_03 TRUE)
	
	(sleep_until (>= (current_zone_set_fully_active) 4) 1)
	(soft_ceiling_enable camera_blocker_04 FALSE)
	
	(sleep_until (>= (current_zone_set) 5) 1)
	(soft_ceiling_enable camera_blocker_05 FALSE)
	
	; after dropping into cannon
	(sleep_until (>= (current_zone_set) 6) 1)
	(soft_ceiling_enable blocker_05 true)

)

;==================================================================================================================
; zone set =========================================================================
;==================================================================================================================

(script dormant zone_set_control
                       
	(sleep_until (>= (current_zone_set) 0) 1)
	(sleep_until (>= (current_zone_set) 1) 1)
	
		(sleep_until (>= (current_zone_set_fully_active) 1) 1)	
				
				;(if debug (print "disable set_hill triggers"))
				;(zone_set_trigger_volume_enable begin_zone_set:set_hill FALSE)
				;(zone_set_trigger_volume_enable zone_set:set_hill FALSE)
	
	(sleep_until (>= (current_zone_set) 2) 1)	
	
		(sleep_until (>= (current_zone_set_fully_active) 2) 1)
				;(if debug (print "disable set_hill_transition triggers"))	
				;(zone_set_trigger_volume_enable begin_zone_set:set_hill_transition FALSE)
				(zone_set_trigger_volume_enable zone_set:set_hill_transition FALSE)
	                         
	(sleep_until (>= (current_zone_set) 3) 1)
	;backcheck
	
		(sleep_until (>= (current_zone_set_fully_active) 3) 1)
	
				(if debug (print "disable set_twin triggers"))
				(zone_set_trigger_volume_enable begin_zone_set:set_twin:* FALSE)
	 
	(sleep_until (>= (current_zone_set) 4) 1)
				(zone_set_trigger_volume_enable zone_set:set_twin FALSE)
				(zone_set_trigger_volume_enable begin_zone_set:set_twin FALSE)
	
		(sleep_until (>= (current_zone_set_fully_active) 4) 1)
	
				(if debug (print "disable set_facility triggers"))
				(zone_set_trigger_volume_enable begin_zone_set:set_facility:* FALSE)
				(zone_set_trigger_volume_enable zone_set:set_facility FALSE)
		
	(sleep_until (>= (current_zone_set) 5) 1)
	
		; slam door shut
		(zone_set_trigger_volume_enable begin_zone_set:set_facility FALSE)
		(device_set_position_immediate dm_facility_door_01 0)
		(object_create sc_080_standin_rock)
		
		
		(sleep_until (>= (current_zone_set_fully_active) 5) 1)
	
				;(if debug (print "disable set_facility_transition triggers"))
				;(zone_set_trigger_volume_enable begin_zone_set:set_facility_transition FALSE)
				;(zone_set_trigger_volume_enable zone_set:set_facility_transition FALSE)			
	                         
	(sleep_until (>= (current_zone_set) 6) 1)
	(sleep_until (>= (current_zone_set) 7) 1)	
	(sleep_until (>= (current_zone_set) 8) 1)	
)

;==================================================================================================================
; Hog control =========================================================================
;==================================================================================================================
(global ai v_hog_control NONE)

(script dormant hog_hill_driver
	(branch
		(volume_test_players tv_enc_twin)
		(branch_kill)
	)
	(print "hog_hill_driver")
	(sleep_until
		(begin
			;(sleep_until (>= (ai_living_count (f_ai_get_vehicle_driver sq_hill_rockethog_01)) 1) 1)
			(sleep_until (>= (ai_living_count (f_ai_get_vehicle_driver (players_vehicle))) 1) 1)
			(set v_hog_control (players_vehicle))
			(print "hog has driver")
			;(cs_run_command_script (f_ai_get_vehicle_driver sq_hill_rockethog_01) cs_hog_hill)
			(cs_run_command_script (f_ai_get_vehicle_driver (players_vehicle)) cs_hog_hill)
			
			;(sleep_until (= (ai_living_count (f_ai_get_vehicle_driver (players_vehicle))) 0) 1)
			(sleep_until (= (ai_living_count (f_ai_get_vehicle_driver (players_vehicle))) 0) 1)
			(sleep_until (not (= (players_vehicle) v_hog_control)))
			(cs_run_command_script (f_ai_get_vehicle_driver v_hog_control) abort_cs)
			(print "hog has NO driver")
			FALSE
		)
	)
	
)

(script static ai players_vehicle
	(ai_player_get_vehicle_squad player0)
)

(script command_script cs_hog_hill
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_vehicle_exit TRUE)
	
	(cs_go_to ps_hog_hill02/p0 3)
	(cs_go_to ps_hog_hill02/p1 3)
	(cs_go_to ps_hog_hill02/p2 3)
	(cs_go_to ps_hog_hill02/p3 3)
	(cs_go_to ps_hog_hill02/p4 3)
	(cs_go_to ps_hog_hill02/p5 3)
	;(cs_go_to ps_hog_hill02/p0)
	
)


(script dormant hog_twin_driver
	(branch
		(>= g_twin_obj_control 5)
		(branch_kill)
	)
	
	(sleep_until g_bfg01_destroyed)
	(sleep_until (>= (device_get_position dm_bridge) 1))
	(sleep_until (<= (ai_living_count sq_twin_wraith_01) 0))
	(sleep_until (not (volume_test_object tv_twin_bridge_end (ai_get_object (players_vehicle)))))
	(print "hog_twin_driver")
	(sleep_until
		(begin
			;(sleep_until
			(sleep_until (>= (ai_living_count (f_ai_get_vehicle_driver (players_vehicle))) 1) 1)
			(set v_hog_control (players_vehicle))
			(print "vehicle has driver")
			(cs_run_command_script (f_ai_get_vehicle_driver (players_vehicle)) cs_hog_twin)
			(sleep_until (= (ai_living_count (f_ai_get_vehicle_driver (players_vehicle))) 0) 1)
			(cs_run_command_script (f_ai_get_vehicle_driver v_hog_control) abort_cs)
			(print "vehicle has NO driver")
			FALSE
		)
	)
	
)

(script command_script cs_hog_twin
	;(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_vehicle_exit TRUE)
	
	(cs_go_to ps_hog_twin/twin_bridge01)
	(cs_go_to ps_hog_twin/twin_bridge02)
	(cs_vehicle_speed .9)
	(cs_go_to ps_hog_twin/twin_bridge03)
	(cs_vehicle_speed 1)
	(cs_go_to ps_hog_twin/twin_bridge04)
	
	;(object_set_velocity (ai_vehicle_get ai_current_actor) 17)
	
	(cs_go_to ps_hog_twin/twin_bridge_exit)
	
)

(script dormant hog_twin_exit_driver
	(branch
		(>= g_facility_obj_control 1)
		(branch_kill)
	)
	(sleep_until (volume_test_object tv_twin_05 (f_ai_get_vehicle_driver (players_vehicle))))
	(ai_set_objective (f_ai_get_vehicle_driver (players_vehicle)) obj_facility_allies)
	(print "hog_twin_exit_driver")
	(sleep_until
		(begin
			(sleep_until (>= (ai_living_count (f_ai_get_vehicle_driver (players_vehicle))) 1) 1)
			(set v_hog_control (players_vehicle))
			(print "vehicle has driver")
			(cs_run_command_script (f_ai_get_vehicle_driver (players_vehicle)) cs_hog_twin_exit)
			(sleep_until (= (ai_living_count (f_ai_get_vehicle_driver (players_vehicle))) 0) 1)
			(cs_run_command_script (f_ai_get_vehicle_driver v_hog_control) abort_cs)
			(print "vehicle has NO driver")
			FALSE
		)
	)
	
)

(script command_script cs_hog_twin_exit
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_vehicle_exit TRUE)

	(cs_go_to ps_hog_facility/p0)
	(cs_go_to ps_hog_facility/p1)

)


(script dormant hog_facility_driver
	(branch
		(>= g_facility_obj_control 2)
		(branch_kill)
	)
	
	(sleep_until (= (current_zone_set_fully_active) 4))
	(sleep_until (not (volume_test_object zone_set:set_facility (ai_get_object (players_vehicle)))))
	(print "hog_facility_driver")
	(sleep_until
		(begin
			(sleep_until (>= (ai_living_count (f_ai_get_vehicle_driver (players_vehicle))) 1) 1)
			(set v_hog_control (players_vehicle))
			(print "vehicle has driver")
			(cs_run_command_script (f_ai_get_vehicle_driver (players_vehicle)) cs_hog_facility)
			(sleep_until (= (ai_living_count (f_ai_get_vehicle_driver (players_vehicle))) 0) 1)
			(cs_run_command_script (f_ai_get_vehicle_driver v_hog_control) abort_cs)
			(print "vehicle has NO driver")
			FALSE
		)
	)
	
)

(script command_script cs_hog_facility
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_abort_on_vehicle_exit TRUE)
	
	(cs_go_to ps_hog_facility/p3)
	(object_set_velocity (ai_vehicle_get ai_current_actor) 8)

	;(cs_go_to ps_hog_facility/p4)
	;(cs_go_to ps_hog_facility/p5)
	;(cs_go_to ps_hog_facility/p6)

)


;==================================================================================================================
; kat control =========================================================================
;==================================================================================================================
(script dormant kat_control
	(sleep_until (>= (current_zone_set) 3))
	(if (<= (ai_living_count (object_get_ai obj_kat)) 0)
		(begin
			(print "kat has been left")
			(wake md_kat_left)
			(sleep_forever)
		)
		(begin
			(print "kat changing objectives")
			(ai_set_objective obj_hill_allies obj_twin_allies)
			(ai_set_objective sq_hill_kat obj_twin_allies)
		)
		
	)
	
	(sleep_until (>= (current_zone_set) 4))
	(if (<= (ai_living_count (object_get_ai obj_kat)) 0)
		(begin
			(print "kat has been left")
			(wake md_kat_left)
			(sleep_forever)
		)
		(begin
			(print "kat changing objectives")
			;(ai_set_objective gr_kat obj_facility_allies)
			(ai_set_objective obj_twin_allies obj_facility_allies)
			(ai_set_objective sq_hill_kat obj_facility_allies)
			
			(sleep_until (>= g_facility_obj_control 15))
			(ai_bring_forward gr_kat 10)
			
			(sleep_until (>= g_facility_obj_control 16))
			(ai_bring_forward gr_kat 10)
			
		)
		
	)
	
	(sleep_until (>= (current_zone_set) 5))
	(if (<= (ai_living_count (object_get_ai obj_kat)) 0)
		(begin
			(print "kat has been left")
			(wake md_kat_left)
			(sleep_forever)
		)
		(begin
			(print "kat changing objectives")
			;(ai_set_objective gr_kat obj_cannon_allies)
			(ai_set_objective obj_facility_allies obj_cannon_allies)
			(ai_set_objective sq_hill_kat obj_cannon_allies)
			
			(sleep_until (>= g_cannon_obj_control 3))
			(ai_bring_forward gr_kat 20)
			
		)
		
	)
	
)

;==================================================================================================================
; object control =========================================================================
;==================================================================================================================
(script dormant object_control
	;if in editor, create all objects
	(if (and (editor_mode) (not editor_object_management))
		(begin
			(print "(sleep_forever object_control)")
			(sleep_forever)
		)
	)
	
	(print "object_control")
	(objects_destroy_all)
			
	(if (= (current_zone_set) 0) (objects_manage_0))
	
	(sleep_until (>= (current_zone_set_fully_active) 1) 1)
	(if (= (current_zone_set_fully_active) 1) (objects_manage_1))
	;(objects_manage_1)
	
	(sleep_until (>= (current_zone_set_fully_active) 2) 1)
	(if (= (current_zone_set_fully_active) 2) (objects_manage_2))
	;(objects_manage_2)
	
	(sleep_until (>= (current_zone_set_fully_active) 3) 1)
	(if (= (current_zone_set_fully_active) 3) (objects_manage_3))
	;(objects_manage_3)
	
	(sleep_until (>= (current_zone_set_fully_active) 4) 1)
	(if (= (current_zone_set_fully_active) 4) (objects_manage_4))
	;(objects_manage_4)
	
	(sleep_until (>= (current_zone_set_fully_active) 5) 1)
	(if (= (current_zone_set_fully_active) 5) (objects_manage_5))
	;(objects_manage_5)
	
	(sleep_until (>= (current_zone_set_fully_active) 6) 1)
	(sleep_until (>= g_falcon_obj_control 15) 1)
	(if (= (current_zone_set_fully_active) 6) (objects_manage_6))
	;(objects_manage_6)
	
	(sleep_until (>= (current_zone_set_fully_active) 7) 1)
	(if (= (current_zone_set_fully_active) 7) (objects_manage_7))
	;(objects_manage_7)
	
	(sleep_until (>= (current_zone_set_fully_active) 8) 1)
	(if (= (current_zone_set_fully_active) 8) (objects_manage_8))
	;(objects_manage_8)
)

(script static void objects_manage_0
	(object_create_folder cr_hill)
	(object_create_folder dc_hill)
	(print "no objects to destroy")
)

(script static void objects_manage_1
	(print "no objects to create")
	(print "no objects to destroy")
)

(script static void objects_manage_2
	(object_create_folder cr_twin)
	(object_create_folder dc_twin)
	(object_create_folder sc_twin)
	(object_create_folder v_twin)
	(sleep 1)
	(if (game_is_cooperative)
		(begin
			(object_destroy v_twin_ghost)
			(object_destroy bi_twin_grunt)
		)
	)
	(print "no objects to destroy")
)

(script static void objects_manage_3
	(print "no objects to create")
	(object_destroy_folder cr_hill)
	(object_destroy_folder dc_hill)
)

(script static void objects_manage_4
	(object_destroy_folder cr_twin)
	(object_destroy_folder dm_twin)
	(object_destroy_folder dc_twin)
	(object_destroy_folder sc_twin)
	(object_destroy_folder v_twin)
	(sleep 1)
	(object_create_folder cr_facility)
	(object_create_folder sc_facility)
	(object_create_folder v_facility)
	(object_create_folder dm_facility)
	(object_create_folder bi_facility)
	(sleep 1)
	(if (game_is_cooperative)
		(object_destroy cr_facility_hog)
	)
	(setup_facility_bodies)
)

(script static void objects_manage_5
	(object_destroy_folder cr_facility)
	(object_destroy_folder sc_facility)
	(object_destroy_folder v_facility)
	(object_destroy_folder dm_facility)
	(object_destroy_folder bi_facility)
	(sleep 1)
	(object_create_folder cr_cannon)
	(object_create_folder dc_cannon)
	(object_create_folder v_cannon)
)

(script static void objects_manage_6
	(object_destroy_folder cr_cannon)
	(object_destroy_folder dc_cannon)
	(object_destroy_folder v_cannon)
	(sleep 1)
	(object_create_folder dm_falcon)
	;(object_create_folder cr_falcon_05)
	(object_create_folder cr_falcon_07+08)
)

(script static void objects_manage_7
	(print "no objects to create")
	(print "no objects to destroy")
)

(script static void objects_manage_8
	;(object_destroy_folder cr_falcon_05)
	(object_destroy_folder cr_falcon_07+08)
	(object_destroy_folder dm_falcon)
	(sleep 1)
	(object_create_folder cr_spire)
	(object_create_folder sc_spire)
	(object_create_folder dc_spire)
	
)

(script static void objects_destroy_all
	(print "destroying all objects")
	(object_destroy_folder dc_hill)
	(object_destroy_folder cr_hill)
	(object_destroy_folder cr_twin)
	(object_destroy_folder dc_twin)
	(object_destroy_folder sc_twin)
	(object_destroy_folder v_twin)
	(object_destroy_folder cr_facility)
	(object_destroy_folder sc_facility)
	(object_destroy_folder v_facility)
	(object_destroy_folder dm_facility)
	(object_destroy_folder bi_facility)
	(object_destroy_folder cr_cannon)
	(object_destroy_folder dc_cannon)
	;(object_destroy_folder cr_falcon_05)
	(object_destroy_folder cr_falcon_07+08)
	(object_destroy_folder dm_falcon)
	(object_destroy_folder cr_spire)
	(object_destroy_folder sc_spire)
	(object_destroy_folder dc_spire)
)


(script static void setup_facility_bodies
	(print "setup_facility_bodies")
	(scenery_animation_start sc_facility_deadciv01 objects\characters\marine\marine deadbody_02)
	(scenery_animation_start sc_facility_deadciv02 objects\characters\marine\marine deadbody_13)
	(scenery_animation_start sc_facility_deadciv03 objects\characters\marine\marine deadbody_01)
	(scenery_animation_start sc_facility_deadciv04 objects\characters\marine\marine deadbody_05)
	(scenery_animation_start sc_facility_deadciv05 objects\characters\marine\marine deadbody_14)
	(scenery_animation_start sc_facility_deadciv06 objects\characters\marine\marine deadbody_03)
	(scenery_animation_start sc_facility_deadciv07 objects\characters\marine\marine deadbody_04)
	(scenery_animation_start sc_facility_deadciv08 objects\characters\marine\marine deadbody_07)
	(scenery_animation_start sc_facility_deadciv09 objects\characters\marine\marine deadbody_10)
	(scenery_animation_start sc_facility_deadciv10 objects\characters\marine\marine deadbody_01)

)

(script static void setup_spire_bodies
	(print "setup_spire_bodies")
	(object_create sc_spire_deadmarine01)
	(object_create sc_spire_deadmarine02)
	(object_create sc_spire_deadmarine03)
	(object_create sc_spire_deadmarine04)
	(object_create sc_spire_deadmarine05)
		(sleep 1)
	(scenery_animation_start sc_spire_deadmarine01 objects\characters\marine\marine deadbody_06)
	(scenery_animation_start sc_spire_deadmarine02 objects\characters\marine\marine deadbody_12)
	(scenery_animation_start sc_spire_deadmarine03 objects\characters\marine\marine deadbody_14)
	(scenery_animation_start sc_spire_deadmarine04 objects\characters\marine\marine deadbody_11)
	(scenery_animation_start sc_spire_deadmarine05 objects\characters\marine\marine deadbody_07)
	
)
