;----------------------------------------------------------------------------------------------------
; *** GLOBALS *** 
;----------------------------------------------------------------------------------------------------

; b_debug Options
(global boolean b_debug 					TRUE)
(global boolean b_breakpoints			FALSE)
(global boolean b_md_print 				TRUE)
(global boolean debug_objectives 	FALSE)
(global boolean editor 						(editor_mode))
(global boolean cinematics 				TRUE)
(global boolean editor_cinematics FALSE)
(global boolean game_emulate 			FALSE)
(global boolean dialogue 					FALSE)
(global boolean skip_intro				FALSE)

; Objective Controls
(global short objcon_dirt -1)
(global short objcon_goose -1)
(global short objcon_drop -1)
(global short objcon_block -1)
(global short objcon_carter -1)
(global short objcon_tunnels -1)
(global short objcon_wall -1)
(global short objcon_factory -1)
(global short objcon_crane -1)
(global short objcon_catwalk -1)
(global short objcon_platform -1) 
(global short objcon_zealot -1)
(global short objcon_cannon -1)


; Objective Readiness
(global boolean b_dirt_ready FALSE)
(global boolean b_goose_ready FALSE)
(global boolean b_drop_ready FALSE)
(global boolean b_block_ready FALSE)
(global boolean b_carter_ready FALSE)
(global boolean b_tunnels_ready FALSE)
(global boolean b_wall_ready FALSE)
(global boolean b_factory_ready FALSE)
(global boolean b_crane_ready FALSE)
(global boolean b_catwalk_ready FALSE)
(global boolean b_platform_ready FALSE)
(global boolean b_zealot_ready FALSE)
(global boolean b_cannon_ready FALSE)

; Insertion
(global short g_insertion_index 0)

; Insertion Indicies
(global short s_insert_idx_dirt 1)
(global short s_insert_idx_goose 2)
(global short s_insert_idx_drop 3)
(global short s_insert_idx_block 4)
(global short s_insert_idx_carter 5)
(global short s_insert_idx_tunnels 6)
(global short s_insert_idx_wall 7)
(global short s_insert_idx_factory 8)
(global short s_insert_idx_crane 9)
(global short s_insert_idx_catwalk 10)
(global short s_insert_idx_platform 11)
(global short s_insert_idx_zealot 12)
(global short s_insert_idx_cannon 13)

; Zone Sets
(global short s_set_intro_cinematic 0)
(global short s_set_dirt 1)
(global short s_set_block 2)
(global short s_set_cave 3)
(global short s_set_bone 4)
(global short s_set_hall_1 5)
(global short s_set_smelt 6)
(global short s_set_hall_2 7)
(global short s_set_final_0 8)
(global short s_set_final_1 9)
(global short s_set_package_cinematic 10)
(global short s_set_final_2 11)
(global short s_set_outro_cinematic 12)
(global short s_set_all 13)

; Fire Teams
(global short fireteam_max 4)
(global real fireteam_dist 3.0)

; Mission Specific
(global boolean g_mission_complete FALSE)

; Persistent Objects
(global object bp_emile NONE)
(global ai ai_emile NONE)
(global object o_emile NONE)
(global vehicle v_mongoose_player_0 NONE)
(global vehicle v_mongoose_emile NONE)
(global vehicle v_pelican_carter none)

; global functions
(script command_script cs_abort  
	(sleep 1) 
)
; Utility
(global short s_wave_spawning 0)

; =================================================================================================
; PACKAGE STARTUP
; =================================================================================================
(script startup package

	(print_difficulty)
	(dprint "::: M70 - THE PILLAR OF AUTUMN :::")

	; Allegiances
	(ai_allegiance human player)
	(ai_allegiance player human)
	(set respawn_players_into_friendly_vehicle true)

	(f_loadout_set "default")

	(zone_set_trigger_volume_enable begin_zone_set:set_smelt FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_hall_2 FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_final_0 FALSE)
	(zone_set_trigger_volume_enable begin_zone_set:set_final_1 FALSE)
	(zone_set_trigger_volume_enable zone_set:set_final_1 FALSE)

	(set breakpoints_enabled FALSE)

	;(wake f_fireteam_setup)
	(wake f_weather_control)
	(wake f_checkpoint_generic)
	(wake f_coop_forward)
	(wake f_player_on_foot)
	(wake f_objects_manage)
	(wake f_flock_control)
	(wake special_elite)

	; STARTING THE GAME
	; ============================================================================================
	(if	
		(or
			(and (not editor) (> (player_count) 0))
			game_emulate
		)
			(begin			
				; if true, start the game
				(start)
			)
			; else just fade in, we're in edit mode
			(begin
				(dprint ":::  editor mode  :::")
			)
	)

	; ENCOUNTERS
	; ============================================================================================

		; DIRTROAD
		; =======================================================================================
		(sleep_until	
			(or
				(volume_test_players tv_dirt_start)
				(>= g_insertion_index s_insert_idx_dirt))
			1)
		
		(if (<= g_insertion_index s_insert_idx_dirt) (wake f_dirt_objective_control))
		

		; MONGOOSE
		; =======================================================================================
		(sleep_until	
			(or
				(volume_test_players tv_goose_start)
				(>= g_insertion_index s_insert_idx_goose))
			1)
		
		(if (<= g_insertion_index s_insert_idx_goose) (wake f_goose_objective_control))

		; SCARABDROP
		; =======================================================================================
		(sleep_until	
			(or
				(volume_test_players tv_drop_start)
				(>= g_insertion_index s_insert_idx_drop))
			1)

		(if (<= g_insertion_index s_insert_idx_drop) (wake f_drop_objective_control))
		
		; BLOCKADE
		; =======================================================================================
		(sleep_until	
			(or
				(volume_test_players tv_block_start)
				(>= g_insertion_index s_insert_idx_block))
			1)
		
		(if (<= g_insertion_index s_insert_idx_block) (wake f_block_objective_control))
		

		; CAVE - Carter
		; =======================================================================================
		(sleep_until	
			(or
				(volume_test_players tv_carter_start)
				(>= g_insertion_index s_insert_idx_carter))
			1)
		
		(if (<= g_insertion_index s_insert_idx_carter) (wake f_carter_objective_control))


		; CAVE - Tunnels
		; =======================================================================================
		(sleep_until	
			(or
				(volume_test_players tv_tunnels_start)
				(>= g_insertion_index s_insert_idx_tunnels))
			1)
		
		(if (<= g_insertion_index s_insert_idx_tunnels) (wake f_tunnels_objective_control))
		
		
		; BONEYARD - Wall
		; =======================================================================================
		(sleep_until	
			(or
				(volume_test_players tv_wall_start)
				(>= g_insertion_index s_insert_idx_wall))
			1)
		
		(if (<= g_insertion_index s_insert_idx_wall) (wake f_wall_objective_control))


		; BONEYARD - Factory
		; =======================================================================================
		(sleep_until	
			(or
				(volume_test_players tv_factory_start)
				(>= g_insertion_index s_insert_idx_factory))
			1)
		
		(if (<= g_insertion_index s_insert_idx_factory) (wake f_factory_objective_control))		


		; SMELTER - Crane
		; =======================================================================================
		(sleep_until	
			(or
				(volume_test_players tv_crane_start)
				(>= g_insertion_index s_insert_idx_crane))
			1)
		
		(if (<= g_insertion_index s_insert_idx_crane) (wake f_crane_objective_control))


		; SMELTER - Catwalk
		; =======================================================================================
		(sleep_until	
			(or
				(volume_test_players tv_catwalk_start)
				(>= g_insertion_index s_insert_idx_catwalk))
			1)
		
		(if (<= g_insertion_index s_insert_idx_catwalk) (wake f_catwalk_objective_control))


		; BIG GUN - Platform
		; =======================================================================================
		(sleep_until	
			(or
				(volume_test_players tv_platform_start)
				(>= g_insertion_index s_insert_idx_platform))
			1)
		
		(if (<= g_insertion_index s_insert_idx_platform) (wake f_platform_objective_control))


		; BIG GUN - Zealot
		; =======================================================================================
		(sleep_until	
			(or
				(= b_zealot_ready TRUE)
				(>= g_insertion_index s_insert_idx_zealot))
			1)
		
		(if (<= g_insertion_index s_insert_idx_zealot) (wake f_zealot_objective_control))


		; BIG GUN - Cannon
		; =======================================================================================
		(sleep_until	
			(or
				(and
					(= b_cannon_ready TRUE)
					(volume_test_players tv_cannon_start)
				)
				(>= g_insertion_index s_insert_idx_cannon))
			1)
		
		(if (<= g_insertion_index s_insert_idx_cannon) (wake f_cannon_objective_control))

)


(script static void (f_loadout_set (string area))

	(if (= area "default")(begin

		(if (game_is_cooperative)(begin
			(unit_add_equipment player0 default_coop TRUE FALSE)
			(unit_add_equipment player1 default_coop TRUE FALSE)
			(unit_add_equipment player2 default_coop TRUE FALSE)
			(unit_add_equipment player3 default_coop TRUE FALSE)
			(player_set_profile default_coop_respawn player0)
			(player_set_profile default_coop_respawn player1)
			(player_set_profile default_coop_respawn player2)
			(player_set_profile default_coop_respawn player3)
		)(begin
			(player_set_profile default_single_respawn player0)
		))
	))

	(if (= area "boneyard")(begin
		(if (game_is_cooperative)(begin
			(player_set_profile boneyard_coop_respawn player0)
			(player_set_profile boneyard_coop_respawn player1)
			(player_set_profile boneyard_coop_respawn player2)
			(player_set_profile boneyard_coop_respawn player3)
		)(begin
			(player_set_profile boneyard_single_respawn player0)
		))
	))

	(if (= area "smelter")(begin
		(if (game_is_cooperative)(begin
			(player_set_profile smelter_coop_respawn player0)
			(player_set_profile smelter_coop_respawn player1)
			(player_set_profile smelter_coop_respawn player2)
			(player_set_profile smelter_coop_respawn player3)
		)(begin
			(player_set_profile smelter_single_respawn player0)
		))
	))

	(if (= area "platform")(begin
		(if (game_is_cooperative)(begin
			(player_set_profile platform_coop_respawn player0)
			(player_set_profile platform_coop_respawn player1)
			(player_set_profile platform_coop_respawn player2)
			(player_set_profile platform_coop_respawn player3)
		)(begin
			(player_set_profile platform_single_respawn player0)
		))
	))


)


(global object o_package cr_package)
(script static void f_package_attach

	(objects_attach (player0) "package" cr_package "")

)

(script static void f_package_destroy

	(objects_detach (player0) cr_package)
	(object_destroy cr_package)

)

(script dormant f_coop_forward

	(wake f_coop_forward_triggers)
	(sleep_until (volume_test_players "begin_zone_set:set_block:*") 5)
	(sleep_until
		(begin
			(if (game_is_cooperative)
				(cond
					((volume_test_objects tv_block_coop_teleport player0)
						(object_teleport_to_ai_point player0 ps_drop_coop_teleport/p0))
					((volume_test_objects tv_block_coop_teleport player1)
						(object_teleport_to_ai_point player1 ps_drop_coop_teleport/p1))
					((volume_test_objects tv_block_coop_teleport player2)
						(object_teleport_to_ai_point player2 ps_drop_coop_teleport/p2))
					((volume_test_objects tv_block_coop_teleport player3)
						(object_teleport_to_ai_point player3 ps_drop_coop_teleport/p3))
				)
			)
		(volume_test_players begin_zone_set:set_cave)
		)
	1)

)

(global boolean b_cin_delivery_rain FALSE)
(script dormant f_weather_control

	(sleep_until (or (> objcon_wall 0)(> objcon_platform 0) b_dirt_ready b_ins_wall b_ins_platform))
	(if (and (not b_ins_wall)(not b_ins_platform)) (begin (dprint "init rain")(set s_rain_force 2)))
	(wake f_rain)

	; Cave - inward arch
	(sleep_until (or (> objcon_wall 0)(> objcon_platform 0)(>= objcon_carter 10) b_ins_wall b_ins_platform ))
	(if (and (not b_ins_wall)(not b_ins_platform)) (begin (dprint "cave rain")(set s_rain_force 1)))

	(sleep_until (or (> objcon_platform 0)(>= objcon_crane 10) b_ins_platform ))
	(if (not b_ins_platform) (begin (dprint "crane rain") (set s_rain_force 5)))

	(sleep_until (>= objcon_platform 10))
	(set s_rain_force 8)

	(sleep_until b_cin_delivery_rain 1)
	(set s_rain_force 9)

	(sleep_until (> objcon_zealot 0))
	(set s_rain_force 5)
	(sound_class_set_gain weapon_ready_third_person .75 90)

	(sleep_until (> objcon_cannon 0))
	(set s_rain_force 2)
	(sound_class_set_gain weapon_ready_third_person 0 90)

)


(script dormant f_coop_forward_triggers

	(sleep_until
		(begin
			(if (game_is_cooperative)
				(begin
					(zone_set_trigger_volume_enable begin_zone_set:set_dirt:* FALSE)
					(zone_set_trigger_volume_enable zone_set:set_dirt FALSE)
				)(begin
					(zone_set_trigger_volume_enable begin_zone_set:set_dirt:* TRUE)
					(zone_set_trigger_volume_enable zone_set:set_dirt TRUE)
				)
			)
		(volume_test_players begin_zone_set:set_cave)
		)
	1)

)


(script dormant f_fireteam_setup

	(sleep_until (> (player_count) 0))

	; Fireteams
	(ai_player_add_fireteam_squad player0 sq_player_0)
	(ai_player_add_fireteam_squad player1 sq_player_1)
	(ai_player_add_fireteam_squad player2 sq_player_2)
	(ai_player_add_fireteam_squad player3 sq_player_3)
	(ai_player_set_fireteam_max player0 5)
	(ai_player_set_fireteam_max player1 5)
	(ai_player_set_fireteam_max player2 5)
	(ai_player_set_fireteam_max player3 5)
	(ai_player_set_fireteam_max_squad_absorb_distance player0 3.0)
	(ai_player_set_fireteam_max_squad_absorb_distance player1 3.0)
	(ai_player_set_fireteam_max_squad_absorb_distance player2 3.0)
	(ai_player_set_fireteam_max_squad_absorb_distance player3 3.0)

)



(script static void (f_emile_respawn (ai emile) (string_id obj))

	(ai_erase ai_emile)
	(ai_erase sq_emile)
	(object_destroy o_emile)
	(sleep 10)
	(f_emile_spawn emile obj)

)

(script static void (f_emile_respawn_vehicle (ai emile) (ai emile_vehicle) (string_id obj))

	(ai_erase ai_emile)
	(ai_erase sq_emile)
	(object_destroy o_emile)
	(sleep 10)
	(f_emile_spawn_vehicle emile emile_vehicle obj)

)

(script static void (f_emile_spawn (ai emile) (string_id obj))

	(ai_place emile)
	(tick)
	(set ai_emile emile)
	(set o_emile (ai_get_object emile))
	(ai_cannot_die emile TRUE)
	(ai_force_active ai_emile TRUE)
	(ai_set_objective (ai_get_squad emile) obj)
	(f_emile_blip)

)

(script static void (f_emile_spawn_vehicle (ai emile) (ai emile_vehicle) (string_id obj))

	(print "vehicle respawn")

	(ai_place emile)
	(ai_place emile_vehicle)
	(tick)
	(set ai_emile emile)
	(set o_emile (ai_get_object ai_emile))
	(ai_cannot_die ai_emile TRUE)
	(ai_force_active ai_emile TRUE)
	(tick)
	(ai_vehicle_enter_immediate ai_emile (ai_vehicle_get_from_starting_location emile_vehicle) "mongoose_d")
	(ai_set_objective (ai_get_squad ai_emile) obj)
	(ai_set_objective (ai_get_squad emile_vehicle) obj)
	(f_emile_blip)
	
)

(global object o_vehicle_emile NONE)
(script static void (f_emile_area_forward (trigger_volume tv_area) (point_reference pt) (ai respawn_emile) (ai respawn_vehicle) (string_id obj) (boolean b_vehicle) )

	(branch
		b_nanny_reset
		(f_abort)
	)		

	(if (unit_in_vehicle ai_emile) (set o_vehicle_emile (object_get_parent ai_emile)) (set o_vehicle_emile NONE) )

	; Bring Forward Failsafe
	(sleep_until
		(or
			b_vehicle
			(and
				(volume_test_object tv_area o_emile)
				(volume_test_players tv_area)
			)
		)
	5 (* 30 s_emile_forward_timer))
	(if
		(or
			(not b_vehicle)
			(and
				(volume_test_players tv_area)
				(not (volume_test_object tv_area o_emile))
			)
		)
		(begin
			(dbreak "emile forward")
			(ai_set_objective sq_emile obj)
			(tick)
			(ai_bring_forward o_emile r_emile_forward_range)
		)
	)
	
	; Teleport Failsafe
	(sleep_until
		(or
			b_vehicle
			(and
				(volume_test_object tv_area o_emile)
				(volume_test_players tv_area)
			)
		)
	5 (* 30 s_emile_teleport_timer))
	(if
		(or
			(not b_vehicle)
			(and
				(volume_test_players tv_area)
				(not (volume_test_object tv_area o_emile))
			)
		)
		(begin
			(dbreak "emile teleport")
			(ai_set_objective sq_emile obj)
		)
	)

	; Respawn Failsafe
	(sleep_until
		(and
			(volume_test_object tv_area o_emile)
			(volume_test_players tv_area)
		)
	5 (* 30 s_emile_spawn_timer))
	(if
		(and
			(volume_test_players tv_area)
			(not (volume_test_object tv_area o_emile))
		)
		(begin
			(dbreak "emile respawn")
			(if b_vehicle (f_emile_respawn_vehicle respawn_emile respawn_vehicle obj) (f_emile_respawn respawn_emile obj))
		)
	)

)

(global short s_emile_forward_timer 15)
(global real r_emile_forward_range 50)
(global short s_emile_teleport_timer 5)
(global short s_emile_spawn_timer 5)
(global boolean b_nanny_reset FALSE)
(script dormant f_emile_nanny

	(dprint "emile nanny")
	(if (<= g_insertion_index s_insert_idx_dirt) (wake f_emile_nanny_dirt_shack) )
	(if (<= g_insertion_index s_insert_idx_goose) (wake f_emile_nanny_dirt_bend) )
	(if (<= g_insertion_index s_insert_idx_drop) (wake f_emile_nanny_drop_scarab) )
	(if (<= g_insertion_index s_insert_idx_block) (wake f_emile_nanny_block_cliff) )
	(if (<= g_insertion_index s_insert_idx_block) (wake f_emile_nanny_block_jump) )
	(if (<= g_insertion_index s_insert_idx_block) (wake f_emile_nanny_block_gulch) )
	(if (<= g_insertion_index s_insert_idx_carter) (wake f_emile_nanny_carter) )
	(if (<= g_insertion_index s_insert_idx_tunnels) (wake f_emile_nanny_tunnels) )
	(if (<= g_insertion_index s_insert_idx_wall) (wake f_emile_nanny_wall) )
	(if (<= g_insertion_index s_insert_idx_factory) (wake f_emile_nanny_factory) )
	(if (<= g_insertion_index s_insert_idx_factory) (wake f_emile_nanny_hall_1) )
	(if (<= g_insertion_index s_insert_idx_crane) (wake f_emile_nanny_crane) )
	(if (<= g_insertion_index s_insert_idx_catwalk) (wake f_emile_nanny_catwalk) )
	(if (<= g_insertion_index s_insert_idx_platform) (wake f_emile_nanny_hall_2) )
	;(if (<= g_insertion_index s_insert_idx_platform) (wake f_emile_nanny_platform) )

)

(script dormant f_emile_nanny_dirt_shack

	(sleep_until (volume_test_players tv_area_dirt_shack) 5)
	(f_emile_area_forward tv_area_dirt_shack ps_emile_teleport/dirt_shack sq_emile/sp_dirt_shack NONE obj_vehicle_hum FALSE)

)

(script dormant f_emile_nanny_dirt_bend

	(sleep_until (volume_test_players tv_area_dirt_bend) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_dirt_bend ps_emile_teleport/dirt_bend sq_emile/sp_dirt_bend sq_mongoose_emile/sp_dirt_bend obj_vehicle_hum TRUE)

)

(script dormant f_emile_nanny_drop_scarab

	(sleep_until (volume_test_players tv_area_drop_scarab) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_drop_scarab ps_emile_teleport/drop_scarab sq_emile/sp_drop_scarab sq_mongoose_emile/sp_drop_scarab obj_vehicle_hum TRUE)

)

(script dormant f_emile_nanny_block_cliff

	(sleep_until (volume_test_players tv_area_block_cliff) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_block_cliff ps_emile_teleport/block_cliff sq_emile/sp_block_cliff sq_mongoose_emile/sp_block_cliff obj_vehicle_hum TRUE)

)


(script dormant f_emile_nanny_block_jump

	(sleep_until (volume_test_players tv_area_block_jump) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_block_jump ps_emile_teleport/block_jump sq_emile/sp_block_jump sq_mongoose_emile/sp_block_jump obj_vehicle_hum TRUE)

)

(script dormant f_emile_nanny_block_gulch

	(sleep_until (volume_test_players tv_area_block_gulch) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_block_gulch ps_emile_teleport/block_gulch sq_emile/sp_block_gulch NONE obj_block_hum FALSE)

)


(script dormant f_emile_nanny_carter

	(sleep_until (volume_test_players tv_area_carter) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_carter ps_emile_teleport/carter sq_emile/sp_carter NONE obj_carter_hum FALSE)

)


(script dormant f_emile_nanny_tunnels

	(sleep_until (volume_test_players tv_area_tunnels) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_tunnels ps_emile_teleport/tunnels sq_emile/sp_tunnels NONE obj_tunnels_hum FALSE)

)


(script dormant f_emile_nanny_wall

	(sleep_until (volume_test_players tv_area_wall) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_wall ps_emile_teleport/wall_yard sq_emile/sp_wall_yard NONE obj_wall_hum FALSE)

)

(script dormant f_emile_nanny_factory

	(sleep_until (volume_test_players tv_area_factory) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_factory ps_emile_teleport/factory sq_emile/sp_factory NONE obj_factory_hum FALSE)

)


(script dormant f_emile_nanny_hall_1

	(sleep_until (volume_test_players tv_area_hall_1) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_hall_1 ps_emile_teleport/hall_1 sq_emile/sp_hall_1 NONE obj_factory_hum FALSE)

)


(script dormant f_emile_nanny_crane

	(sleep_until (volume_test_players tv_area_crane) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_crane ps_emile_teleport/crane sq_emile/sp_crane NONE obj_crane_hum FALSE)

)

(script dormant f_emile_nanny_catwalk

	(sleep_until (volume_test_players tv_area_catwalk) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_catwalk ps_emile_teleport/catwalk sq_emile/sp_catwalk NONE obj_catwalk_hum FALSE)

)

(script dormant f_emile_nanny_hall_2

	(sleep_until (volume_test_players tv_area_hall_2) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_hall_2 ps_emile_teleport/hall_2 sq_emile/sp_hall_2 NONE obj_platform_hum FALSE)

)

(script dormant f_emile_nanny_platform

	(sleep_until (volume_test_players tv_area_platform) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_emile_area_forward tv_area_platform ps_emile_teleport/platform sq_emile/sp_platform NONE obj_platform_hum FALSE)

)


(script static void f_emile_blip_kill

	(sleep_forever f_emile_blip_1)
	(sleep_forever f_emile_blip_2)
	(sleep_forever f_emile_blip_3)
	(sleep_forever f_emile_blip_4)
	(sleep_forever f_emile_blip_5)
	(sleep_forever f_emile_blip_6)
	(sleep_forever f_emile_blip_7)
	(sleep_forever f_emile_blip_8)
	(sleep_forever f_emile_blip_9)
	(sleep_forever f_emile_blip_10)
	(sleep_forever f_emile_blip_11)
	(sleep_forever f_emile_blip_12)
	(sleep_forever f_emile_blip_13)
	(sleep_forever f_emile_blip_14)
	(sleep_forever f_emile_blip_15)
	(sleep_forever f_emile_blip_16)
	(sleep_forever f_emile_blip_17)
	(sleep_forever f_emile_blip_18)

)

(global short s_emile_blip 1)
(script static void f_emile_blip

	(cond
		((= s_emile_blip 1)
			(wake f_emile_blip_1)
			(set s_emile_blip 2)
		)
		((= s_emile_blip 2)
			(sleep_forever f_emile_blip_1)
			(wake f_emile_blip_2)
			(set s_emile_blip 3)
		)
		((= s_emile_blip 3)
			(sleep_forever f_emile_blip_2)
			(wake f_emile_blip_3)
			(set s_emile_blip 4)
		)
		((= s_emile_blip 4)
			(sleep_forever f_emile_blip_3)
			(wake f_emile_blip_4)
			(set s_emile_blip 5)
		)
		((= s_emile_blip 5)
			(sleep_forever f_emile_blip_4)
			(wake f_emile_blip_5)
			(set s_emile_blip 6)
		)
		((= s_emile_blip 6)
			(sleep_forever f_emile_blip_5)
			(wake f_emile_blip_6)
			(set s_emile_blip 7)
		)
		((= s_emile_blip 7)
			(sleep_forever f_emile_blip_6)
			(wake f_emile_blip_7)
			(set s_emile_blip 8)
		)
		((= s_emile_blip 8)
			(sleep_forever f_emile_blip_7)
			(wake f_emile_blip_8)
			(set s_emile_blip 9)
		)
		((= s_emile_blip 9)
			(sleep_forever f_emile_blip_8)
			(wake f_emile_blip_9)
			(set s_emile_blip 10)
		)
		((= s_emile_blip 10)
			(sleep_forever f_emile_blip_9)
			(wake f_emile_blip_10)
			(set s_emile_blip 11)
		)
		((= s_emile_blip 11)
			(sleep_forever f_emile_blip_10)
			(wake f_emile_blip_11)
			(set s_emile_blip 12)
		)
		((= s_emile_blip 12)
			(sleep_forever f_emile_blip_11)
			(wake f_emile_blip_12)
			(set s_emile_blip 13)
		)
		((= s_emile_blip 13)
			(sleep_forever f_emile_blip_12)
			(wake f_emile_blip_13)
			(set s_emile_blip 14)
		)
		((= s_emile_blip 14)
			(sleep_forever f_emile_blip_13)
			(wake f_emile_blip_14)
			(set s_emile_blip 15)
		)
		((= s_emile_blip 15)
			(sleep_forever f_emile_blip_14)
			(wake f_emile_blip_15)
			(set s_emile_blip 16)
		)
		((= s_emile_blip 16)
			(sleep_forever f_emile_blip_15)
			(wake f_emile_blip_16)
			(set s_emile_blip 17)
		)
		((= s_emile_blip 17)
			(sleep_forever f_emile_blip_16)
			(wake f_emile_blip_17)
			(set s_emile_blip 18)
		)
		((= s_emile_blip 18)
			(sleep_forever f_emile_blip_17)
			(wake f_emile_blip_18)
			(set s_emile_blip -1)
		)



	)

)

(script dormant f_emile_blip_1

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_2

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_3

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_4

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_5

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_6

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_7

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_8

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_9

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_10

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_11

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)


(script dormant f_emile_blip_12

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_13

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_14

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_15

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_16

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_17

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(script dormant f_emile_blip_18

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)

(global boolean b_insertion_fade_in FALSE)
(script dormant f_insertion_fade_in

	(sleep_until b_insertion_fade_in)
	(insertion_fade_to_gameplay)

)


(script dormant f_flock_control

	(if (and (not b_ins_platform)(not b_test_finalbattle)(< objcon_platform 10 )) (begin

			(sleep_until
				(or
					(>= objcon_dirt 1)
					(>= objcon_wall 1)
				)
			)

			(flock_create flc_init_phantom_01)
			(flock_create flc_init_banshee_01)
			(flock_create flc_init_wraith_01)
			(flock_create flc_init_ghost_01)
			
	))

)

(global short s_zoneset_last_refreshed -1)
(script dormant f_objects_manage

		(sleep_until (begin

			(cond
				((and (= (current_zone_set_fully_active) s_set_dirt)(not (= s_zoneset_last_refreshed s_set_dirt)))
					(dprint "creating dirt objects")
					(f_objects_dirt_create)
					(set s_zoneset_last_refreshed s_set_dirt)
				)
				((and (= (current_zone_set_fully_active) s_set_block)(not (= s_zoneset_last_refreshed s_set_block)))
					(dprint "creating block objects")
					(f_objects_block_create)
					(set s_zoneset_last_refreshed s_set_block)
				)
				((and (= (current_zone_set_fully_active) s_set_cave)(not (= s_zoneset_last_refreshed s_set_cave)))
					(dprint "creating cave objects")
					(f_objects_cave_create)
					(f_objects_dirt_destroy)
					(set s_zoneset_last_refreshed s_set_cave)
				)
				((and (= (current_zone_set_fully_active) s_set_bone)(not (= s_zoneset_last_refreshed s_set_bone)))
					(dprint "creating bone objects")
					(f_objects_bone_create)
					(f_objects_block_destroy)
					(set s_zoneset_last_refreshed s_set_bone)
				)
				((and (= (current_zone_set_fully_active) s_set_hall_1)(not (= s_zoneset_last_refreshed s_set_hall_1)))
					(dprint "creating hall 1 objects")
					(f_objects_hall_1_create)
					(f_objects_cave_destroy)
					(set s_zoneset_last_refreshed s_set_hall_1)
				)
				((and (= (current_zone_set_fully_active) s_set_smelt)(not (= s_zoneset_last_refreshed s_set_smelt)))
					(dprint "creating smelt objects")
					(f_objects_smelt_create)
					(f_objects_bone_destroy)
					(set s_zoneset_last_refreshed s_set_smelt)
				)
				((and (= (current_zone_set_fully_active) s_set_hall_2)(not (= s_zoneset_last_refreshed s_set_hall_2)))
					(dprint "creating hall 2 objects")
					(f_objects_hall_2_create)
					(f_objects_hall_1_destroy)
					(set s_zoneset_last_refreshed s_set_hall_2)
				)
				((and (= (current_zone_set_fully_active) s_set_final_0)(not (= s_zoneset_last_refreshed s_set_final_0)))
					(dprint "creating final 0 objects")
					(f_objects_final_0_create)
					(f_objects_smelt_destroy)
					(flock_delete flc_init_phantom_01)
					(flock_delete flc_init_banshee_01)
					(flock_delete flc_init_wraith_01)
					(flock_delete flc_init_ghost_01)
					(object_create_anew sc_poa)
					(set s_zoneset_last_refreshed s_set_final_0)
				)
				((and (= (current_zone_set_fully_active) s_set_final_1)(not (= s_zoneset_last_refreshed s_set_final_1)))
					(dprint "creating final 1 objects")
					(f_objects_final_0_create)
					(f_objects_hall_2_destroy)
					(set s_zoneset_last_refreshed s_set_final_1)
				)
				((and (= (current_zone_set_fully_active) s_set_final_2)(not (= s_zoneset_last_refreshed s_set_final_2)))
					(dprint "creating final 2 objects")
					(f_objects_final_2_create)
					(set s_zoneset_last_refreshed s_set_final_2)
				)
			)

	FALSE) 3)

)

; Objects dirt
(script static void f_objects_dirt_create

	(object_create_folder eq_dirt)
	(object_create_folder dc_dirt)
	(object_create_folder w_dirt)
	(object_create_folder v_dirt)
	(object_create_folder sc_dirt)
	(object_create_folder cr_dirt)

	(f_dirt_place_vehicles)

	(pose_body sc_dirt_marine_1 pose_on_back_var1)
	(pose_body sc_dirt_marine_2 pose_on_back_var2)

)
(script static void f_objects_dirt_destroy

	(f_dirt_erase_vehicles)

	(object_destroy_folder eq_dirt)
	(object_destroy_folder dc_dirt)
	(object_destroy_folder dm_dirt_scarabs)
	(object_destroy_folder w_dirt)
	(object_destroy_folder v_dirt)
	(object_destroy_folder sc_dirt)
	(object_destroy_folder cr_dirt)

)

; Objects block
(script static void f_objects_block_create

	(dprint "creating block objects")

	(object_create_folder dm_block)
	(object_create_folder dc_block)
	(object_create_folder v_block)
	(object_create_folder sc_block)
	(object_create_folder cr_block)

	(pose_body sc_block_marine_1 pose_against_wall_var4)

)

(script static void f_objects_block_destroy

	(object_destroy_folder dm_block)
	(object_destroy_folder dc_block)
	(object_destroy_folder v_block)
	(object_destroy_folder sc_block)
	(object_destroy_folder cr_block)

)

; Objects cave
(script static void f_objects_cave_create

	(object_create_folder w_cave)
	(object_create_folder sc_cave)
	(object_create_folder cr_cave)
	(object_create_folder dc_cave)	
	(object_create_folder eq_cave)

	(pose_body sc_cave_marine_1 pose_against_wall_var4)
	(pose_body sc_cave_marine_2 pose_face_down_var2)
	(pose_body sc_cave_marine_3 pose_on_side_var3)

)

(script static void f_objects_cave_destroy

	(object_destroy_folder w_cave)
	(object_destroy_folder sc_cave)
	(object_destroy_folder dc_cave)	
	(object_destroy_folder eq_cave)
	(object_destroy_folder cr_cave)

)

; Objects bone
(script static void f_objects_bone_create

	(object_create_folder dt_bone)
	(object_create_folder eq_bone)
	(object_create_folder dc_bone)
	(object_create_folder dm_bone)
	(object_create_folder w_bone)
	(object_create_folder v_bone)
	(object_create_folder sc_bone)
	(object_create_folder cr_bone)

	(if (difficulty_is_legendary) (object_create dt_term_2) (object_destroy dt_term_2) )

	(pose_body sc_bone_marine_1 pose_on_back_var3)
	(pose_body sc_bone_marine_2 pose_on_back_var2)
	(pose_body sc_bone_marine_3 pose_face_down_var2)

)

(script static void f_objects_bone_destroy

	(object_destroy_folder dt_bone)
	(object_destroy_folder eq_bone)
	(object_destroy_folder dc_bone)
	(object_destroy_folder dm_bone)
	(object_destroy_folder w_bone)
	(object_destroy_folder v_bone)
	(object_destroy_folder sc_bone)
	(object_destroy_folder cr_bone)

)

; Objects hall_1
(script static void f_objects_hall_1_create

	(object_create_folder dt_hall_1)
	(object_create_folder w_hall_1)
	(object_create_folder cr_hall_1)
	(object_create_folder dm_hall_1)
	(object_create_folder sc_hall_1)

	(if (difficulty_is_normal_or_higher) (object_create dt_term_1) (object_destroy dt_term_1) )

	(pose_body sc_hall1_marine_1 pose_against_wall_var4)
	(pose_body sc_hall1_marine_2 pose_on_side_var2)

)


(script static void f_objects_hall_1_destroy

	(object_create_folder dt_hall_1)
	(object_destroy_folder w_hall_1)
	(object_destroy_folder cr_hall_1)
	(object_destroy_folder dm_hall_1)
	(object_destroy_folder sc_hall_1)

)

; Objects smelt
(script static void f_objects_smelt_create

	(object_create_folder dc_smelt)
	(object_create_folder w_smelt)
	(object_create_folder sc_smelt)
	(object_create_folder cr_smelt)
	(object_create_folder eq_smelt)

	(pose_body sc_smelt_marine_1 pose_on_side_var1)
	(pose_body sc_smelt_marine_2 pose_face_down_var2)

)

(script static void f_objects_smelt_destroy

	(object_destroy_folder dc_smelt)
	(object_destroy_folder w_smelt)
	(object_destroy_folder sc_smelt)
	(object_destroy_folder cr_smelt)
	(object_destroy_folder eq_smelt)

)

; Objects hall_2
(script static void f_objects_hall_2_create

	(object_create_folder cr_hall_2)
	(object_create_folder sc_hall_2)

)

(script static void f_objects_hall_2_destroy

	(object_destroy_folder cr_hall_2)
	(object_destroy_folder sc_hall_2)

)

; Objects final_0
(script static void f_objects_final_0_create

	(object_create_folder dm_final_0)
	(object_create_folder eq_final_0)
	(object_create_folder dc_final_0)
	(object_create_folder sc_final_0)
	(object_create_folder w_final_0)
	(object_create_folder cr_final_0)

	(pose_body sc_final_0_marine_1 pose_on_back_var2)
	(pose_body sc_final_0_marine_2 pose_on_side_var2)

)
(script static void f_objects_final_0_destroy

	(object_destroy_folder dm_final_0)
	(object_destroy_folder eq_final_0)
	(object_destroy_folder dc_final_0)
	(object_destroy_folder sc_final_0)
	(object_destroy_folder w_final_0)
	(object_destroy_folder cr_final_0)

)

; Objects final_2
(script static void f_objects_final_2_create

	(object_create_folder dm_final_2)
	(object_create_folder w_final_2)
	(object_create_folder sc_final_2)
	(object_create_folder cr_final_2)
	(object_create_folder eq_final_2)
	(object_create_folder dc_final_2)

	(pose_body sc_final_2_marine_1 pose_against_wall_var1)
	(pose_body sc_final_2_marine_2 pose_against_wall_var2)
	(pose_body sc_final_2_marine_3 pose_face_down_var2)

	(scenery_animation_start sc_final_2_emile objects\characters\spartans_ai\spartans_ai m70:emile_dead)
	(scenery_animation_start sc_final_2_elite_1 objects\characters\elite_ai\elite_ai m70:zealot_dead_b)
	(scenery_animation_start sc_final_2_elite_2 objects\characters\elite_ai\elite_ai m70:zealot_dead_a)

	(if
		(game_is_cooperative)
		(begin
			(object_create sc_cannon_case_1)
			(object_create sc_cannon_case_2)
			(object_create w_cannon_splaser_1)
			(object_create w_cannon_splaser_2)
			(object_create w_cannon_splaser_3)
			(object_create w_cannon_splaser_4)
		)
	)

)

(script static void f_objects_final_2_destroy

	(object_destroy_folder dm_final_2)
	(object_destroy_folder w_final_2)
	(object_destroy_folder sc_final_2)
	(object_destroy_folder cr_final_2)
	(object_destroy_folder eq_final_2)
	(object_destroy_folder dc_final_2)

)

(script static void f_objects_global_destroy

	(object_destroy_folder dm_global)
	(object_destroy_folder sc_global)

)

(global boolean b_game_safe_to_respawn TRUE)
(script continuous f_rule_volumes

	(set b_game_safe_to_respawn TRUE)

	(cond
		((volume_test_players tv_rule_bridge)
			(begin
				(game_save_cancel)
				(set b_game_safe_to_respawn FALSE)
			)
		)
	)
	
	(if b_game_safe_to_respawn
		(game_safe_to_respawn TRUE)
		(game_safe_to_respawn FALSE)
	)

)


(global boolean b_shake FALSE)
(script continuous f_shake_control

	(sleep_until
		(begin
			(sleep_until b_shake)
			(set b_shake FALSE)
			(player_effect_set_max_rotation 0 1 0.25)
			(player_effect_set_max_rumble 1 1)     
			(player_effect_start .70 .1)                                                        
			(sleep 90)
			(player_effect_stop .5)
			FALSE
		)
	1)

)

; =================================================================================================
; =================================================================================================
; START
; =================================================================================================
; =================================================================================================

(script static void start

	; Handle intro cinematic


	; Figure out what insertion point to use
	(cond
		((= (game_insertion_point_get) 0) (ins_dirt))
		((= (game_insertion_point_get) 1) (ins_block))
		((= (game_insertion_point_get) 2) (ins_wall))
		((= (game_insertion_point_get) 3) (ins_crane))
		((= (game_insertion_point_get) 4) (ins_platform))
		((= (game_insertion_point_get) 5) (f_test_carterdeath))
		((= (game_insertion_point_get) 6) (f_test_finalbattle))
		((= (game_insertion_point_get) 7) (f_test_scarabdrop))
		((= (game_insertion_point_get) 8) (f_test_cruiser))
	)
)

; =================================================================================================
; =================================================================================================
; DIRTROAD
; =================================================================================================
; =================================================================================================

(script dormant f_dirt_objective_control

	(dprint "::: dirtroad encounter :::")
	; set first mission segment
	(data_mine_set_mission_segment "m70_01_dirtroad")
	(set b_dirt_ready TRUE)

	; Standard Scripts	
	(wake f_dirt_title_control)
	(wake f_dirt_missionobj_control)
	(wake f_dirt_waypoint_control)
	(wake f_dirt_hilite_control)
	(wake f_dirt_music_control)
	(wake f_dirt_md_control)
	(wake f_dirt_save_control)
	(wake f_dirt_spawn_control)
	(wake f_dirt_cleanup_control)

	; Encounter Scripts
	(wake f_dirt_emile_control)
	(wake f_dirt_cov_alerted)
	(wake f_dirt_ridge_patrol_listen)

	(sleep_forever f_insertion_fade_in)
	(cinematic_exit 070la_carter TRUE)

	(sleep_until (volume_test_players tv_dirt_10) 1)
	(dprint "objective control : dirtroad.10")
	(set objcon_dirt 10)

	(soft_ceiling_enable camera_blocker_01 FALSE)

	(sleep_until (volume_test_players tv_dirt_20) 1)
	(dprint "objective control : dirtroad.20")
	(set objcon_dirt 20)

	(sleep_until (volume_test_players tv_dirt_30) 1)
	(dprint "objective control : dirtroad.30")
	(set objcon_dirt 30)

	(sleep_until (volume_test_players tv_dirt_40) 1)
	(dprint "objective control : dirtroad.40")
	(set objcon_dirt 40)

	(sleep_until (volume_test_players tv_dirt_50) 1)
	(dprint "objective control : dirtroad.50")
	(set objcon_dirt 50)

	(sleep_until (volume_test_players tv_dirt_55) 1)
	(dprint "objective control : dirtroad.55")
	(set objcon_dirt 55)

	(sleep_until (volume_test_players tv_dirt_60) 1)
	(dprint "objective control : dirtroad.60")
	(set objcon_dirt 60)

	(sleep_until (volume_test_players tv_dirt_70) 1)
	(dprint "objective control : dirtroad.70")
	(set objcon_dirt 70)

)


(script command_script f_cs_dirt_carter

	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_boost TRUE)

	(effect_new_on_object_marker_loop objects\vehicles\human\pelican\fx\destruction\pelican_damage.effect (ai_vehicle_get_from_starting_location sq_pelican_carter/dirt)  "fx_m70_wing_r_damage")

	; enter
	;--------------------------------------------
	(cs_fly_by ps_dirt_carter_chase/carter_exit_01a)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_dirt_carter_chase/carter_exit_01b)
	(cs_fly_by ps_dirt_carter_chase/carter_exit_01c)
	(cs_fly_by ps_dirt_carter_chase/carter_exit_01d)
	(cs_fly_by ps_dirt_carter_chase/carter_exit_01)
	(cs_fly_by ps_dirt_carter_chase/carter_exit_02)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
	(cs_fly_by ps_dirt_carter_chase/carter_erase)

	(effect_stop_object_marker objects\vehicles\human\pelican\fx\destruction\pelican_damage.effect (ai_vehicle_get_from_starting_location sq_pelican_carter/dirt) "fx_m70_wing_r_damage")

	(ai_erase ai_current_squad)

)


(script command_script f_cs_dirt_banshee_1

	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)

	(cs_vehicle_speed 1.8)

	; enter
	;--------------------------------------------
	(cs_fly_by ps_dirt_carter_chase/banshee_1_exit_01a)
	(cs_fly_by ps_dirt_carter_chase/banshee_1_exit_01b)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_dirt_carter_chase/banshee_1_exit_01c)
	(cs_vehicle_boost FALSE)
	(cs_fly_by ps_dirt_carter_chase/banshee_1_exit_01d)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_dirt_carter_chase/banshee_1_exit_01)
	(cs_vehicle_boost FALSE)
	(cs_fly_by ps_dirt_carter_chase/banshee_1_exit_02)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
	(cs_fly_by ps_dirt_carter_chase/banshee_1_erase)
	(ai_erase ai_current_squad)

)



(script command_script f_cs_dirt_banshee_2

	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)

	(cs_vehicle_speed 1.8)

	; enter
	;--------------------------------------------

	(cs_fly_by ps_dirt_carter_chase/banshee_2_exit_01a)
	(cs_fly_by ps_dirt_carter_chase/banshee_2_exit_01b)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_dirt_carter_chase/banshee_2_exit_01c)
	(cs_vehicle_boost FALSE)
	(cs_fly_by ps_dirt_carter_chase/banshee_2_exit_01d)
	(cs_vehicle_boost TRUE)
	(cs_fly_by ps_dirt_carter_chase/banshee_2_exit_01)
	(cs_vehicle_boost FALSE)
	(cs_fly_by ps_dirt_carter_chase/banshee_2_exit_02)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
	(cs_fly_by ps_dirt_carter_chase/banshee_2_erase)
	(ai_erase ai_current_squad)

)



(global short s_dirt_elite_patrol_point 0)
(script command_script f_cs_dirt_elite_patrol

	(cs_walk TRUE)
	(cs_abort_on_damage TRUE)

	(sleep_until
		(begin

			(set s_dirt_elite_patrol_point (random_range 0 4))
			(if (= s_dirt_elite_patrol_point 0) (begin (cs_go_to_and_face ps_dirt_elite_patrol/p0 ps_dirt_elite_patrol/p0_face) (sleep (* 30 2) ) ) )
			(if (= s_dirt_elite_patrol_point 1) (begin (cs_go_to_and_face ps_dirt_elite_patrol/p1 ps_dirt_elite_patrol/p1_face) (sleep (* 30 2) ) ) )
			(if (= s_dirt_elite_patrol_point 2) (begin (cs_go_to_and_face ps_dirt_elite_patrol/p2 ps_dirt_elite_patrol/p2_face) (sleep (* 30 2) ) ) )
			(if (= s_dirt_elite_patrol_point 3) (begin (cs_go_to ps_dirt_elite_patrol/p3) (sleep (* 30 2) ) ) )

		(>= (ai_combat_status obj_dirt_cov) 3) )	
	)

)

(script static void f_dirt_place_vehicles

	(ai_place sq_mongoose_new_0a)
	(ai_place sq_mongoose_new_0)
	(ai_place sq_mongoose_new_1)
	(ai_place sq_mongoose_new_2)
	(ai_place sq_mongoose_new_3)

	(ai_squad_enumerate_immigrants sq_mongoose_new_0 TRUE)
	(ai_squad_enumerate_immigrants sq_mongoose_new_1 TRUE)
	(ai_squad_enumerate_immigrants sq_mongoose_new_2 TRUE)
	(ai_squad_enumerate_immigrants sq_mongoose_new_3 TRUE)

)

(script static void f_dirt_erase_vehicles

	(ai_erase sq_mongoose_new_0)
	(ai_erase sq_mongoose_new_1)
	(ai_erase sq_mongoose_new_2)
	(ai_erase sq_mongoose_new_3)

)

(script dormant f_dirt_hilite_control

	(sleep_until (>= objcon_dirt 20) 5)
	
	(sleep 120)

	(sleep_until
		(or
			(objects_can_see_object player0 sc_pillar_hilite_pillar_marker 25)
			(objects_can_see_object player1 sc_pillar_hilite_pillar_marker 25)
			(objects_can_see_object player2 sc_pillar_hilite_pillar_marker 25)
			(objects_can_see_object player3 sc_pillar_hilite_pillar_marker 25)
		)
	1)

	(f_hud_flash_object sc_pillar_hilite_pillar)
	(object_destroy sc_pillar_hilite_pillar)

)

(script dormant f_dirt_title_control

	(sleep_until (>= objcon_dirt 20) 5)
	(tit_dirt)

)

(script dormant f_dirt_missionobj_control

	(sleep_until (>= objcon_dirt 20) 5)
	(sleep 220)
	(mo_dirtroad)

)

(global short s_dirt_waypoint_timer 180)
(script dormant f_dirt_waypoint_control

	; Nonlinear
	(wake f_dirt_waypoint_goose)

)

(script dormant f_dirt_waypoint_goose

	(branch
		(or
			(>= objcon_drop 1)
			(player_in_vehicle (ai_vehicle_get_from_spawn_point sq_mongoose_player_0/sp_dirt_shack))
			(player_in_vehicle (ai_vehicle_get_from_spawn_point sq_mongoose_emile/sp_dirt_shack))
		)
		(f_dirt_waypoint_goose_end)
	)

	(sleep_until (>= objcon_dirt 20))
	(sleep (* 30 s_dirt_waypoint_timer))
	
	(if
		(not
			(or 
				(>= objcon_drop 1)
				(player_in_vehicle (ai_vehicle_get_from_spawn_point sq_mongoose_player_0/sp_dirt_shack))
				(player_in_vehicle (ai_vehicle_get_from_spawn_point sq_mongoose_emile/sp_dirt_shack))
			)
		)
		(f_blip_object (ai_vehicle_get_from_spawn_point sq_mongoose_player_0/sp_dirt_shack) blip_ordnance)
	)
	

)

(script static void f_dirt_waypoint_goose_end

	(f_unblip_object (ai_vehicle_get_from_spawn_point sq_mongoose_player_0/sp_dirt_shack))

)

(script dormant f_dirt_md_control

	(f_abort_md)

	; LINEAR
	; ---------------

	(sleep_until b_dirt_ready 1)
	(sleep (* 30 9))
	(md_dirt_drop)

	(sleep_until b_dirt_emile_look 1 (* 30 20))
	(md_dirt_look)

	; delay for overlook
	(sleep_until (>= objcon_dirt 30) 1 (* 30 60))
	(if (not (>= objcon_dirt 30))
		(begin
			(md_dirt_look_delay_0)
		)
	)

	(sleep_until (>= objcon_dirt 30) 1 (* 30 60))
	(if (not (>= objcon_dirt 30))
		(begin
			(md_dirt_look_delay_1)
		)
	)

	(sleep_until (>= objcon_dirt 30) 1)

	; delay for bridge
	(sleep_until (>= objcon_dirt 50) 1 (* 30 120))
	(if (not (>= objcon_dirt 50))
		(begin
			(md_dirt_bridge_delay)
		)
	)


)

(global boolean b_dirt_cov_alerted FALSE)
(script dormant f_dirt_cov_alerted

	(sleep_until (>= (ai_combat_status obj_dirt_cov) 3))
	(dprint "dirt squads alerted")
	(tick)
	(ai_set_task sq_dirt_elite_convoy_1 obj_dirt_cov convoy_elite_1_main)
	(tick)
	(set b_dirt_cov_alerted TRUE)
	(tick)
	(ai_squad_patrol_enable obj_dirt_sp_wreck FALSE)
	(tick)
	(ai_squad_patrol_objective_disallow sq_dirt_elite_convoy_1 TRUE)
	(thespian_performance_kill_by_name "th_dirt_grunt_check_1")
	(thespian_performance_kill_by_name "th_dirt_grunt_check_2")
	(thespian_performance_kill_by_name "th_dirt_grunt_check_3")

)


(global boolean b_ridge_search TRUE)
(script dormant f_dirt_ridge_patrol_listen

	(sleep_until (volume_test_object tv_dirt_ridge_patrol (ai_get_object sq_dirt_elite_convoy_2)) 1)
	(sleep 200)
	(set b_ridge_search FALSE)

)


(script static boolean f_ridge_search

	(= b_ridge_search TRUE)

)


(script dormant f_dirt_save_control

	(wake f_dirt_save_combatend)
	(game_save_immediate)

)

(script dormant f_dirt_save_combatend

	(branch (>= objcon_drop 0) (f_abort))

	(sleep_until (<= (ai_living_count gr_dirt_cov) 0))
	(game_save_no_timeout)

)



(script dormant	f_dirt_music_control

	(wake music_dirt)

)


(script dormant f_dirt_spawn_control


	(ai_place sq_pelican_carter/dirt)
	(ai_place sq_dirt_banshee_1)
	(ai_place sq_dirt_banshee_2)

	(sleep_until (>= objcon_dirt 1))
	(f_squad_group_place gr_dirt_cov_init)

)


; OBJECTIVE CONTROL
;============================================

(script static boolean f_dirt_convoy_search

	(<= (ai_combat_status obj_dirt_cov) 3)

)


; EMILE
;============================================

(global boolean b_dirt_emile_look FALSE)
(global boolean b_dirt_emile_moveon FALSE)
(script dormant f_dirt_emile_control

	(ai_set_deaf sq_emile TRUE)
	(ai_set_blind sq_emile TRUE)
	(sleep_until b_dirt_emile_moveon 5 (* 30 20))
	(ai_set_deaf sq_emile FALSE)
	(ai_set_blind sq_emile FALSE)

)


(script dormant f_dirt_cleanup_control

	(sleep_until (volume_test_players tv_dirt_cleanup) 5)
	(f_dirt_despawn_all)
	(f_dirt_kill_scripts)

)

(script static void f_dirt_despawn_all

	(ai_erase gr_dirt_cov)
	(ai_erase gr_goose_cov)

)

(script static void f_dirt_kill_scripts

	(sleep_forever f_dirt_objective_control)
	(sleep_forever f_dirt_spawn_control)
	(sleep_forever f_dirt_save_combatend)
	(sleep_forever f_dirt_save_control)
	(sleep_forever f_dirt_ridge_patrol_listen)
	(sleep_forever f_dirt_cov_alerted)
	(sleep_forever f_dirt_md_control)
	(sleep_forever f_dirt_waypoint_goose)
	(sleep_forever f_dirt_waypoint_goose_end)
	(sleep_forever f_dirt_missionobj_control)
	(sleep_forever f_dirt_waypoint_control)
	(sleep_forever f_dirt_title_control)
	(sleep_forever f_dirt_hilite_control)
	(sleep_forever f_dirt_emile_control)
	(ai_dialogue_enable TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	
)


; =================================================================================================
; =================================================================================================
; MONGOOSE
; =================================================================================================
; =================================================================================================


(script dormant f_goose_objective_control
	(dprint "::: mongoose encounter :::")
	
	; Wait until the zone is loaded
	;(sleep_until
		;(or
			;(= (current_zone_set_fully_active) 1)
			;(= (current_zone_set_fully_active) 2)))
	
	(set b_goose_ready TRUE)

	; Standard Scripts
	(wake f_goose_save_control)
	(wake f_goose_waypoint_control)
	(wake f_goose_md_control)
	(wake f_goose_cleanup_control)
	(wake f_goose_spawn_control)

	; Encounter Scripts
	(wake f_goose_emile_control)
	(wake f_mongoose_findnew)
	(wake f_goose_birds)

	(set b_insertion_fade_in TRUE)

	(dprint "objective control : mongoose.1")
	(set objcon_goose 1)

	(sleep_until (volume_test_players tv_goose_10) 1)
	(dprint "objective control : mongoose.10")
	(set objcon_goose 10)

	(sleep_until (volume_test_players tv_goose_15) 1)
	(dprint "objective control : mongoose.15")
	(set objcon_goose 15)

	(sleep_until (volume_test_players tv_goose_17) 1)
	(dprint "objective control : mongoose.17")
	(set objcon_goose 17)

	(sleep_until (volume_test_players tv_goose_20) 1)
	(dprint "objective control : mongoose.20")
	(set objcon_goose 20)

	(sleep_until (volume_test_players tv_goose_25) 1)
	(dprint "objective control : mongoose.25")
	(set objcon_goose 25)
	
	(soft_ceiling_enable camera_blocker_02 FALSE)

	(sleep_until (volume_test_players tv_goose_30) 1)
	(dprint "objective control : mongoose.30")
	(set objcon_goose 30)

)

(script dormant f_goose_spawn_control

	(sleep_until (>= objcon_goose 1) 1)
	(f_squad_group_place gr_goose_cov_banshees)

)


(script dormant f_goose_birds

	(sleep_until (>= objcon_goose 17) 1)
	(dprint "birds")
	(flock_create flc_goose_birds_01)

)


(script dormant f_goose_save_control

	(game_save_no_timeout)

)

(global short s_goose_waypoint_timer 30)
(script dormant f_goose_waypoint_control

	; Nonlinear

	; Linear
	(sleep_until (>= objcon_goose 10))

	(sleep_until (>= objcon_goose 25) 5 (* 30 s_goose_waypoint_timer))
	(if (not (>= objcon_goose 25))
		(begin
			(f_blip_flag fl_goose_waypoint_1 blip_destination)
			(sleep_until (>= objcon_goose 25) 5)
			(f_unblip_flag fl_goose_waypoint_1)
		)
	)

)

(script dormant f_goose_md_control

	(f_abort_md)

	; CONDITIONAL
	; ---------------
	; check player not getting on goose
	(wake f_goose_md_goose_delay)

	; LINEAR
	; ---------------
	(sleep_until b_goose_ready 1)
	(md_goose_wheels)

	(sleep_until (>= objcon_goose 10) 1)
	(if (not b_players_any_in_vehicle)
		(begin
			(md_goose_pass)
		)
	)

)

(script dormant f_goose_md_goose_delay

	(branch
		b_players_any_in_vehicle
		(f_abort_md)
	)

	; check player delaying before mongoose
	(sleep (* 30 60))
	(if (not b_players_any_in_vehicle)
		(begin
			(md_goose_wheels_delay_0)
		)
	)

	(sleep (* 30 60))
	(if (not b_players_any_in_vehicle)
		(begin
			(md_goose_wheels_delay_1)
		)
	)

)


(script dormant f_mongoose_findnew

	(branch
		(or
			b_carter_ready
			b_tunnels_ready
			b_wall_ready
			b_factory_ready
			b_crane_ready
			b_catwalk_ready
			b_platform_ready
			b_zealot_ready
			b_cannon_ready
		)
		(f_abort_md)
	)
	
	; loop until branch kills this script
	(sleep_until
		(begin
			; when player enters any tv_goose_new, play a prompt to get on goose
			(sleep_until
				(and
					(or
						(volume_test_players tv_goose_new_0)
						(volume_test_players tv_goose_new_1)
					)
					(not b_players_any_in_vehicle)
				)
			5)
			(md_goose_findnew)
			(sleep 1000)
			(sleep_until
				(not
					(or
						(volume_test_players tv_goose_new_0)
						(volume_test_players tv_goose_new_1)
					)
				)
			)
			FALSE
		)
	5)

)

; EMILE
;============================================
(script dormant f_goose_emile_control

	(sleep_until
		(or
			(<= (ai_living_count obj_dirt_cov) 2)
			(>= objcon_dirt 60)
		)
	)
	(dprint "mongoose approach")

	(ai_set_objective sq_emile obj_vehicle_hum)

)

(script command_script f_cs_abort

	(sleep 0)

)

(global short s_vehicle_player_pos -1)
(global short s_emile_follow_dist 20)
(global short s_emile_mongoose_progress 0)
(script command_script f_cs_emile_goose_move

	(cs_abort_on_vehicle_exit TRUE)

	(sleep_until

		(begin

				(if (not (vehicle_test_seat_unit (ai_vehicle_get ai_current_actor) "mongoose_d" ai_current_actor)) (cs_run_command_script ai_current_actor f_cs_abort))

				(if (volume_test_players tv_area_dirt_shack) (begin

					(if (volume_test_players tv_vehicle_dirt_1) (set s_vehicle_player_pos 1))
					(if (or (volume_test_players tv_vehicle_dirt_2_1)(volume_test_players tv_vehicle_dirt_2_2)) (set s_vehicle_player_pos 2))
					(if (or (volume_test_players tv_vehicle_dirt_3_1)(volume_test_players tv_vehicle_dirt_3_2)) (set s_vehicle_player_pos 3))
					(if (or (volume_test_players tv_vehicle_dirt_4_1)(volume_test_players tv_vehicle_dirt_4_2)) (set s_vehicle_player_pos 4))
					(if (volume_test_players tv_vehicle_dirt_5) (set s_vehicle_player_pos 5))
					(if (volume_test_players tv_vehicle_dirt_6) (set s_vehicle_player_pos 6))
					(if (volume_test_players tv_vehicle_dirt_7) (set s_vehicle_player_pos 7))
					(if (volume_test_players tv_vehicle_dirt_8) (set s_vehicle_player_pos 8))
					(if (volume_test_players tv_vehicle_dirt_9) (set s_vehicle_player_pos 9))


				))

				(if (volume_test_players tv_area_dirt_bend) (begin

					(if (volume_test_players tv_vehicle_dirt_8) (set s_vehicle_player_pos 8))
					(if (volume_test_players tv_vehicle_dirt_9) (set s_vehicle_player_pos 9))
					(if (volume_test_players tv_vehicle_dirt_10) (set s_vehicle_player_pos 10))
					(if (volume_test_players tv_vehicle_dirt_11) (set s_vehicle_player_pos 11))
					(if (volume_test_players tv_vehicle_dirt_12) (set s_vehicle_player_pos 12))
					(if (volume_test_players tv_vehicle_drop_13) (set s_vehicle_player_pos 13))
					(if (or (volume_test_players tv_vehicle_drop_14_1)(volume_test_players tv_vehicle_drop_14_2)) (set s_vehicle_player_pos 14))
					(if (or (volume_test_players tv_vehicle_drop_15_1)(volume_test_players tv_vehicle_drop_15_2)) (set s_vehicle_player_pos 15))


				))

				(if (volume_test_players tv_area_drop_scarab) (begin

					(if (or (volume_test_players tv_vehicle_drop_14_1)(volume_test_players tv_vehicle_drop_14_2)) (set s_vehicle_player_pos 14))
					(if (or (volume_test_players tv_vehicle_drop_15_1)(volume_test_players tv_vehicle_drop_15_2)) (set s_vehicle_player_pos 15))
					(if (or (volume_test_players tv_vehicle_drop_16_1)(volume_test_players tv_vehicle_drop_16_2)(volume_test_players tv_vehicle_drop_16_3)(volume_test_players tv_vehicle_drop_16_4)) (set s_vehicle_player_pos 16))
					(if (or (volume_test_players tv_vehicle_drop_17_1)(volume_test_players tv_vehicle_drop_17_2)(volume_test_players tv_vehicle_drop_17_3)) (set s_vehicle_player_pos 17))
					(if (volume_test_players tv_vehicle_drop_18) (set s_vehicle_player_pos 18))
					(if (volume_test_players tv_vehicle_drop_19) (set s_vehicle_player_pos 19))
					(if (volume_test_players tv_vehicle_drop_20) (set s_vehicle_player_pos 20))
					(if (volume_test_players tv_vehicle_drop_21) (set s_vehicle_player_pos 21))
					(if (volume_test_players tv_vehicle_drop_22) (set s_vehicle_player_pos 22))
					(if (volume_test_players tv_vehicle_drop_23) (set s_vehicle_player_pos 23))
					(if (volume_test_players tv_vehicle_drop_24) (set s_vehicle_player_pos 24))
					(if (volume_test_players tv_vehicle_drop_25) (set s_vehicle_player_pos 25))
					(if (volume_test_players tv_vehicle_block_26) (set s_vehicle_player_pos 26))
					(if (volume_test_players tv_vehicle_block_27) (set s_vehicle_player_pos 27))

				))

				(if (volume_test_players tv_area_block_cliff) (begin

					(if (volume_test_players tv_vehicle_block_26) (set s_vehicle_player_pos 26))
					(if (volume_test_players tv_vehicle_block_27) (set s_vehicle_player_pos 27))
					(if (volume_test_players tv_vehicle_block_28) (set s_vehicle_player_pos 28))
					(if (volume_test_players tv_vehicle_block_29) (set s_vehicle_player_pos 29))
					(if (volume_test_players tv_vehicle_block_30) (set s_vehicle_player_pos 30))
					(if (volume_test_players tv_vehicle_block_31) (set s_vehicle_player_pos 31))
					(if (volume_test_players tv_vehicle_block_32) (set s_vehicle_player_pos 32))
					(if (or (volume_test_players tv_vehicle_block_33_1)(volume_test_players tv_vehicle_block_33_2)) (set s_vehicle_player_pos 33))
					(if (volume_test_players tv_vehicle_block_34) (set s_vehicle_player_pos 34))

				))

				(if (or (volume_test_players tv_area_block_jump)(volume_test_players tv_area_block_gulch)) (begin

					(if (or (volume_test_players tv_vehicle_block_33_1)(volume_test_players tv_vehicle_block_33_2)) (set s_vehicle_player_pos 33))
					(if (volume_test_players tv_vehicle_block_34) (set s_vehicle_player_pos 34))
					(if (volume_test_players tv_vehicle_block_35) (set s_vehicle_player_pos 35))
					(if (volume_test_players tv_vehicle_block_36) (set s_vehicle_player_pos 36))
					(if (or (volume_test_players tv_vehicle_block_37)(volume_test_players tv_area_block_gulch)) (set s_vehicle_player_pos 37))

				))
				
				; EMILE

				(if (volume_test_object tv_area_dirt_shack ai_current_actor) (begin

					(if (and (volume_test_object tv_vehicle_dirt_1 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 0))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 2))))(cs_go_to ps_vehicle_dirt/1 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_2_1 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 1))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 3))))(cs_go_to ps_vehicle_dirt/2_1 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_2_2 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 1))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 3))))(cs_go_to ps_vehicle_dirt/2_2 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_3_1 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 2))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 4))))(cs_go_to ps_vehicle_dirt/3_1 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_3_2 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 2))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 4))))(cs_go_to ps_vehicle_dirt/3_2 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_4_1 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 3))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 5))))(cs_go_to ps_vehicle_dirt/4_1 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_4_2 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 3))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 5))))(cs_go_to ps_vehicle_dirt/4_2 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_5 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 4))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 6))))(cs_go_to ps_vehicle_dirt/5 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_6 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 5))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 7))))(cs_go_to ps_vehicle_dirt/6 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_7 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 6))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 8))))(cs_go_to ps_vehicle_dirt/7 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_8 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 7))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 9))))(cs_go_to ps_vehicle_dirt/8 .25) )

				))

				(if (volume_test_object tv_area_dirt_bend ai_current_actor) (begin

					(if (and (volume_test_object tv_vehicle_dirt_7 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 6))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 8))))(cs_go_to ps_vehicle_dirt/7 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_8 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 7))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 9))))(cs_go_to ps_vehicle_dirt/8 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_9 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 8))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 10))))(cs_go_to ps_vehicle_dirt/9 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_10 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 9))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 11))))(cs_go_to ps_vehicle_dirt/10 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_11 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 10))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 12))))(cs_go_to ps_vehicle_drop/11 .25) )
					(if (and (volume_test_object tv_vehicle_dirt_12 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 11))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 13))))(cs_go_to ps_vehicle_drop/12 .25) )
					(if (and (volume_test_object tv_vehicle_drop_13 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 12))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 14))))(cs_go_to ps_vehicle_drop/13 .25) )
					(if (and (volume_test_object tv_vehicle_drop_14_1 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 13))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 15))))(cs_go_to ps_vehicle_drop/14_1 .25) )
				
				))

				(if (volume_test_object tv_area_drop_scarab ai_current_actor) (begin
				
					(if (and (volume_test_object tv_vehicle_drop_14_1 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 13))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 15))))(cs_go_to ps_vehicle_drop/14_1 .25) )
					(if (and (volume_test_object tv_vehicle_drop_14_2 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 13))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 15))))(cs_go_to ps_vehicle_drop/14_2 .25) )
					(if (and (volume_test_object tv_vehicle_drop_15_1 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 14))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 16))))(cs_go_to ps_vehicle_drop/15_1 .25) )
					(if (and (volume_test_object tv_vehicle_drop_15_2 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 14))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 16))))(cs_go_to ps_vehicle_drop/15_2 .25) )
					(if (and (volume_test_object tv_vehicle_drop_16_1 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 15))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 17))))(cs_go_to ps_vehicle_drop/16_1 .25) )
					(if (and (volume_test_object tv_vehicle_drop_16_2 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 15))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 17))))(cs_go_to ps_vehicle_drop/16_2 .25) )
					(if (and (volume_test_object tv_vehicle_drop_16_3 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 15))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 17))))(cs_go_to ps_vehicle_drop/16_3 .25) )
					(if (and (volume_test_object tv_vehicle_drop_16_4 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 15))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 17))))(cs_go_to ps_vehicle_drop/16_4 .25) )
					(if (and (volume_test_object tv_vehicle_drop_17_1 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 16))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 18))))(cs_go_to ps_vehicle_drop/17_1 .25) )
					(if (and (volume_test_object tv_vehicle_drop_17_2 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 16))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 18))))(cs_go_to ps_vehicle_drop/17_2 .25) )
					(if (and (volume_test_object tv_vehicle_drop_17_3 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 16))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 18))))(cs_go_to ps_vehicle_drop/17_3 .25) )
					(if (and (volume_test_object tv_vehicle_drop_18 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 17))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 19))))(cs_go_to ps_vehicle_drop/18 .25) )
					(if (and (volume_test_object tv_vehicle_drop_19 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 18))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 20))))(cs_go_to ps_vehicle_drop/19 .25) )
					(if (and (volume_test_object tv_vehicle_drop_20 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 19))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 21))))(cs_go_to ps_vehicle_drop/20 .25) )
					(if (and (volume_test_object tv_vehicle_drop_21 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 20))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 22))))(cs_go_to ps_vehicle_drop/21 .25) )
					(if (and (volume_test_object tv_vehicle_drop_22 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 21))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 23))))(cs_go_to ps_vehicle_drop/22 .25) )
					(if (and (volume_test_object tv_vehicle_drop_23 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 22))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 24))))(cs_go_to ps_vehicle_drop/23 .25) )
					(if (and (volume_test_object tv_vehicle_drop_24 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 23))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 25))))(cs_go_to ps_vehicle_drop/24 .25) )
					(if (and (volume_test_object tv_vehicle_drop_25 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 24))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 26))))(cs_go_to ps_vehicle_drop/25 .25) )
					(if (and (volume_test_object tv_vehicle_block_26 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 25))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 27))))(cs_go_to ps_vehicle_drop/26 .25) )
					
				))

				(if (volume_test_object tv_area_block_cliff ai_current_actor) (begin

					(if (and (volume_test_object tv_vehicle_drop_25 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 24))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 26))))(cs_go_to ps_vehicle_drop/25 .25) )
					(if (and (volume_test_object tv_vehicle_block_26 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 25))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 27))))(cs_go_to ps_vehicle_drop/26 .25) )
					(if (and (volume_test_object tv_vehicle_block_27 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 26))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 28))))(cs_go_to ps_vehicle_drop/27 .25) )
					(if (and (volume_test_object tv_vehicle_block_28 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 27))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 29))))(cs_go_to ps_vehicle_block/28 .25) )
					(if (and (volume_test_object tv_vehicle_block_29 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 28))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 30))))(cs_go_to ps_vehicle_block/29 .25) )
					(if (and (volume_test_object tv_vehicle_block_30 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 29))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 31))))(cs_go_to ps_vehicle_block/30 .25) )
					(if (and (volume_test_object tv_vehicle_block_31 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 30))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 32))))(cs_go_to ps_vehicle_block/31 .25) )
					(if (and (volume_test_object tv_vehicle_block_32 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 31))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 33))))(cs_go_to ps_vehicle_block/32 .25) )
					(if (and (volume_test_object tv_vehicle_block_33_1 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 32))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 34))))(cs_go_to ps_vehicle_block/33_1 .25) )

				))

				(if (volume_test_object tv_area_block_jump ai_current_actor) (begin

					(if (and (volume_test_object tv_vehicle_block_32 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 31))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 33))))(cs_go_to ps_vehicle_block/32 .25) )
					(if (and (volume_test_object tv_vehicle_block_33_1 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 32))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 34)))) (cs_go_to ps_vehicle_block/33_1 .25) )
					(if (and (volume_test_object tv_vehicle_block_33_2 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 32))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 34))))(cs_go_to ps_vehicle_block/33_2 .25) )
					(if (and (volume_test_object tv_vehicle_block_34 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 32))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 34))))(cs_go_to ps_vehicle_block/34 .25) )
					(if (and (volume_test_object tv_vehicle_block_35 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 32))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 34))))(begin (set b_emile_boost TRUE)(cs_move_towards_point ps_vehicle_block/35 1) ) )
					(if (and (volume_test_object tv_vehicle_block_36 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 32))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 34))))(cs_go_to ps_vehicle_block/36 .25) )
					(if (and (volume_test_object tv_vehicle_block_37 ai_current_actor) (or (and b_players_any_in_vehicle (>= s_vehicle_player_pos 32))(and (not b_players_any_in_vehicle)(>= s_vehicle_player_pos 34))))(cs_run_command_script ai_current_actor f_cs_abort) )
				))

		false)
	
	1)

)

(global boolean b_emile_boost FALSE)
(global boolean b_player_boost FALSE)
(global real g_boost_speed_0 16)
(global real g_boost_speed_1 13)
(script dormant f_emile_boost

	(sleep_until b_emile_boost 1)
	(sleep 25)

	(if (player_in_vehicle (ai_vehicle_get_from_squad sq_emile 0))
		(begin
			(object_set_velocity (ai_vehicle_get_from_squad sq_emile 0) g_boost_speed_0)
			(sleep_until (volume_test_object tv_vehicle_block_jump (ai_vehicle_get_from_squad sq_emile 0)) 1)
			(object_set_velocity (ai_vehicle_get_from_squad sq_emile 0) g_boost_speed_1)
		)
		(begin
			
			(dprint "emile solo boost")
			(object_set_velocity (ai_vehicle_get_from_squad sq_emile 0) g_boost_speed_0)
			(sleep_until (volume_test_object tv_vehicle_block_jump (ai_vehicle_get_from_squad sq_emile 0)) 1)
			(object_set_velocity (ai_vehicle_get_from_squad sq_emile 0) g_boost_speed_1)
		)
	)

)

(script command_script f_cs_emile_goose_mount

	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(ai_enter_squad_vehicles gr_hum)

)


(script static void f_goose_emile_wait

	(sleep_until (<= (objects_distance_to_object (ai_get_object sq_emile) player0) s_emile_follow_dist) 5 500)

)

(script dormant f_goose_cleanup_control

	(sleep_until (volume_test_players tv_goose_cleanup) 5)
	(f_goose_kill_scripts)
	(f_goose_despawn_all)

)

(script static void f_goose_kill_scripts

	(sleep_forever f_goose_objective_control)
	(sleep_forever f_goose_save_control)
	(sleep_forever f_goose_waypoint_control)
	(sleep_forever f_goose_md_control)
	(sleep_forever f_mongoose_findnew)
	(sleep_forever f_goose_md_goose_delay)
	(sleep_forever f_goose_emile_control)
	(sleep_forever f_goose_birds)
	(ai_dialogue_enable TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)

)

(script static void f_goose_despawn_all

	(ai_erase gr_goose_cov)

)


; =================================================================================================
; =================================================================================================
; SCARABDROP
; =================================================================================================
; =================================================================================================

(script dormant f_drop_objective_control
	(dprint "::: scarab drop encounter :::")
	
	; Wait until the zone is loaded
	;(sleep_until
		;(or
			;(= (current_zone_set_fully_active) 1)
			;(= (current_zone_set_fully_active) 2)))
	
	(set b_drop_ready TRUE)

	; Standard Scripts
	(wake f_drop_save_control)
	(wake f_drop_waypoint_control)
	(wake f_drop_spawn_control)
	(wake f_drop_cleanup_control)
	(wake f_drop_music_control)
	(wake f_drop_md_control)
	(wake f_drop_emile_control)

	; Encounter Scripts
	(wake f_drop_scarabs_start)
	(wake f_drop_pods_control)

	(set b_insertion_fade_in TRUE)
	
	(sleep_until (volume_test_players tv_drop_10) 1)
	(dprint "objective control : scarabdrop.10")
	(set objcon_drop 10)

	(sleep_until (volume_test_players tv_drop_20) 1)
	(dprint "objective control : scarabdrop.20")
	(set objcon_drop 20)

	(sleep_until (volume_test_players tv_drop_30) 1)
	(dprint "objective control : scarabdrop.30")
	(set objcon_drop 30)

	(sleep_until (volume_test_players tv_drop_35) 1)
	(dprint "objective control : scarabdrop.35")
	(set objcon_drop 35)

	(sleep_until (volume_test_players tv_drop_40) 1)
	(dprint "objective control : scarabdrop.40")
	(set objcon_drop 40)

	(sleep_until (volume_test_players tv_drop_45) 1)
	(dprint "objective control : scarabdrop.45")
	(set objcon_drop 45)

	(sleep_until (volume_test_players tv_drop_50) 1)
	(dprint "objective control : scarabdrop.50")
	(set objcon_drop 50)

	(soft_ceiling_enable camera_blocker_03 FALSE)

	(sleep_until (volume_test_players tv_drop_60) 1)
	(dprint "objective control : scarabdrop.60")
	(set objcon_drop 60)

)

(script dormant f_drop_save_control

	(game_save_no_timeout)

)

(global short s_drop_waypoint_timer 90)
(script dormant f_drop_waypoint_control

	; Nonlinear

	; Linear
	(sleep_until (>= objcon_drop 30))
	(sleep_until (>= objcon_drop 60) 5 (* 30 s_drop_waypoint_timer))
	(if (not (>= objcon_drop 60))
		(begin
			(f_blip_flag fl_drop_waypoint_1 blip_destination)
			(sleep_until (>= objcon_drop 60) 5)
			(f_unblip_flag fl_drop_waypoint_1)
		)
	)

)

(script dormant	f_drop_emile_control

	(sleep 0)

)

(script dormant	f_drop_md_control

	(f_abort_md)

	; LINEAR
	; -----------------
	(sleep_until (>= objcon_drop 30) 1)
	(md_drop_intro)

	(sleep_until (>= objcon_drop 35) 1)
	(md_drop_carter)

	(sleep_until (>= objcon_drop 50) 1 (* 30 90))
	(if (not (>= objcon_drop 50))
		(begin
			(md_drop_delay_0)
		)
	)

	(sleep_until (>= objcon_drop 50) 1 (* 30 90))
	(if (not (>= objcon_drop 50))
		(begin
			(md_drop_delay_1)
		)
	)

)

(script dormant	f_drop_music_control

	(wake music_drop)
	
	(sleep_until (>= objcon_block 5))
	(set s_music_drop 2)

	(sleep_until (volume_test_players tv_area_block_gulch))
	(set s_music_drop 4)

)

(script command_script f_cs_drop_pelican_carter

	(cs_ignore_obstacles TRUE)
	(cs_enable_targeting TRUE)

	; enter
	;--------------------------------------------
	(cs_vehicle_speed 5)

	(effect_new_on_object_marker_loop objects\vehicles\human\pelican\fx\destruction\pelican_damage.effect (ai_vehicle_get_from_starting_location sq_pelican_carter/drop)  "fx_m70_wing_r_damage")

	(cs_fly_to ps_drop_pelican_carter/move_01 .1)
	(cs_fly_to ps_drop_pelican_carter/move_02 .1)
	(cs_fly_to_and_face ps_drop_pelican_carter/move_03 ps_drop_pelican_carter/move_03_face .1)
	(cs_fly_to_and_face ps_drop_pelican_carter/move_04 ps_drop_pelican_carter/move_04_face .1)
	(sleep 120)
	(cs_fly_to_and_face ps_drop_pelican_carter/move_05 ps_drop_pelican_carter/move_05_face .1)
	(cs_fly_to_and_face ps_drop_pelican_carter/move_06 ps_drop_pelican_carter/move_06_face .1)	
	(cs_enable_targeting FALSE)
	(cs_fly_to_and_face ps_drop_pelican_carter/move_07 ps_drop_pelican_carter/move_07_face .1)	
	(cs_fly_to ps_drop_pelican_carter/move_08 .1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
	(cs_fly_to ps_drop_pelican_carter/erase)

	(effect_stop_object_marker objects\vehicles\human\pelican\fx\destruction\pelican_damage.effect (ai_vehicle_get_from_starting_location sq_pelican_carter/drop) "fx_m70_wing_r_damage")

	(ai_erase ai_current_squad)
	
)

(script dormant f_drop_longsword_control

	(sleep_until (>= objcon_drop 50))
	(f_ls_flyby dm_dirt_longsword_01)
	(sound_impulse_start sound\device_machines\040vc_longsword\start NONE 1)
	(f_ls_carpetbomb ps_drop_longbomb_1 fx\fx_library\_placeholder\placeholder_explosion 6 10)

)

(script dormant f_drop_spawn_control

	(dprint "::: spawning all scarabdrop squads")
	(sleep_until (volume_test_players tv_drop_drop_1) 1)
	(ai_place sq_pelican_carter/drop)

)


(script dormant f_drop_scarabs_start

	(wake f_drop_scarabs_distance)
	(wake f_drop_scarab_1)
	(wake f_drop_scarab_2)

)


(script dormant f_drop_scarabs_distance

	(sleep_until (volume_test_players tv_drop_drop_1) 1)
	(wake f_drop_scarab_distance_1)
	(wake f_drop_scarab_1_far)
	(sleep 60)
	(wake f_drop_scarab_2_far)
	(sleep 60)
	(sleep_forever f_drop_scarab_distance_1)
	(wake f_drop_scarab_distance_2)
	(wake f_drop_scarab_3_far)

)

(global boolean b_drop_1_scarab_dropped FALSE)
(global short s_drop_scarab_1_loops 0)
(global short s_drop_scarab_1_loop_idx 0)
(global short s_drop_scarab_1_drop_time 0)
(global short s_drop_scarab_1_idlewalk_time 0)
(global short s_drop_scarab_1_walk_time 0)
(global short s_drop_scarab_1_climb_time 0)
(script dormant f_drop_scarab_1

	(if (not b_test_scarabdrop)
		(begin
			(sleep_until (volume_test_players tv_drop_drop_1) 1)
		)
	)

	(sleep_until
		(begin

			(set s_drop_scarab_1_loops 1)
			(set s_drop_scarab_1_loop_idx 0)
			(set s_drop_scarab_1_drop_time 7)
			(set s_drop_scarab_1_idlewalk_time 7)
			(set s_drop_scarab_1_walk_time 7)
			(set s_drop_scarab_1_climb_time 57)
		
			(object_create_anew dm_drop_scarab_1)
			
			(set b_drop_1_scarab_dropped TRUE)

			(ai_place sq_drop_scarab_1_turret)
			;(ai_vehicle_enter_immediate sq_drop_scarab_1_turret/driver_01 (object_get_turret dm_drop_scarab_1 0) "")
			(ai_vehicle_enter_immediate sq_drop_scarab_1_turret/driver_02 (object_get_turret dm_drop_scarab_1 1) "")
			(ai_vehicle_enter_immediate sq_drop_scarab_1_turret/driver_03 (object_get_turret dm_drop_scarab_1 2) "")
			(ai_vehicle_enter_immediate sq_drop_scarab_1_turret/driver_04 (object_get_turret dm_drop_scarab_1 3) "")

			(device_set_position_track dm_drop_scarab_1 "device:scarab_drop" 0)
		  (device_animate_position dm_drop_scarab_1 1 s_drop_scarab_1_drop_time 0.034 0.034 false)
			(sleep (- (* s_drop_scarab_1_drop_time 30) 2) )
		
			(device_set_position_track dm_drop_scarab_1 "device:idle_2_move_front" 0)
		  (device_animate_position dm_drop_scarab_1 1 s_drop_scarab_1_idlewalk_time 0.034 0.034 false)
			(sleep (- (* s_drop_scarab_1_idlewalk_time 30) 2) )
		
			(sleep_until
				(begin
					(device_set_position_track dm_drop_scarab_1 "device:move_front" 0)	
		  		(device_animate_position dm_drop_scarab_1 1 s_drop_scarab_1_walk_time 0.034 0.034 FALSE)
					(set s_drop_scarab_1_loop_idx (+ s_drop_scarab_1_loop_idx 1))
					(sleep (- (* s_drop_scarab_1_walk_time 30) 2) )
					(>= s_drop_scarab_1_loop_idx s_drop_scarab_1_loops)
				)
			1)
		
			(device_set_position_track dm_drop_scarab_1 "device:m70_scarab_climb" 0)
		  (device_animate_position dm_drop_scarab_1 1 s_drop_scarab_1_climb_time 0.034 0.034 false)
			(sleep (- (* s_drop_scarab_1_climb_time 30) 2) )

			(not b_test_scarabdrop)

		)
	1)

)

(global boolean b_drop_scarab_2_near FALSE)
(global short s_drop_scarab_2_drop_time 0)
(global short s_drop_scarab_2_idle_time 0)
(global short s_drop_scarab_2_idlewalk_time 0)
(global short s_drop_scarab_2_wkloops 0)
(global short s_drop_scarab_2_wkloop_idx 0)
(global short s_drop_scarab_2_walk_time 0)
(global short s_drop_scarab_2_climb_time 0)
(script dormant f_drop_scarab_2

	(if (not b_test_scarabdrop)
		(begin
			(sleep_until (volume_test_players tv_drop_drop_2) 1)
		)
	)

	(sleep_until
		(begin

			(set s_drop_scarab_2_drop_time 8)
			(set s_drop_scarab_2_idle_time 1)
			(set s_drop_scarab_2_idlewalk_time 7)
			(set s_drop_scarab_2_wkloops 4)
			(set s_drop_scarab_2_wkloop_idx 0)
			(set s_drop_scarab_2_walk_time 7)
			(set s_drop_scarab_2_climb_time 57)

			(object_create_anew dm_drop_scarab_2)
		
			(ai_place sq_drop_scarab_2_turret)
			;(ai_vehicle_enter_immediate sq_drop_scarab_2_turret/driver_01 (object_get_turret dm_drop_scarab_2 0) "")
			(ai_vehicle_enter_immediate sq_drop_scarab_2_turret/driver_02 (object_get_turret dm_drop_scarab_2 1) "")
			(ai_vehicle_enter_immediate sq_drop_scarab_2_turret/driver_03 (object_get_turret dm_drop_scarab_2 2) "")
			(ai_vehicle_enter_immediate sq_drop_scarab_2_turret/driver_04 (object_get_turret dm_drop_scarab_2 3) "")

			(device_set_position_track dm_drop_scarab_2 "device:scarab_drop" 0)
		  (device_animate_position dm_drop_scarab_2 1 s_drop_scarab_2_drop_time 0.034 0.034 false)
			(sleep (- (* s_drop_scarab_2_drop_time 30) 2) )
		
			(device_set_position_track dm_drop_scarab_2 "device:idle_2_move_front" 0)
		  (device_animate_position dm_drop_scarab_2 1 s_drop_scarab_2_idlewalk_time 0.034 0.034 false)
			(sleep (- (* s_drop_scarab_2_idlewalk_time 30) 2) )
		
			(sleep_until
				(begin
					(device_set_position_track dm_drop_scarab_2 "device:move_front_up" 0)	
		  		(device_animate_position dm_drop_scarab_2 1 s_drop_scarab_2_walk_time 0.034 0.034 FALSE)
					(set s_drop_scarab_2_wkloop_idx (+ s_drop_scarab_2_wkloop_idx 1))
					(sleep (- (* s_drop_scarab_2_walk_time 30) 2) )
					(>= s_drop_scarab_2_wkloop_idx s_drop_scarab_2_wkloops)
				)
			1)
		
			(device_set_position_track dm_drop_scarab_2 "device:m70_scarab_climb" 0)
		 	(print "init anim start")	
		  (device_animate_position dm_drop_scarab_2 1 s_drop_scarab_2_climb_time 0.034 0.034 false)
			(sleep (- (* s_drop_scarab_2_climb_time 30) 2) )
			
			(not b_test_scarabdrop)

		)
	1)

)

(script dormant f_drop_scarab_distance_1
	(sleep_until
		(begin
			(dprint "scarab_distance_1 go!")
			(effect_new_random "levels/solo/m70/fx/scarab_drop.effect" ps_drop_distance_1 5 5)
			(sleep (random_range 10 15))
			FALSE
		)
	5)
)

(script dormant f_drop_scarab_distance_2
	(dprint "scarab_distance_2 go!")
	(effect_new_random "levels/solo/m70/fx/scarab_drop.effect" ps_drop_distance_2)
	(sleep (random_range 10 15))
	(effect_new_random "levels/solo/m70/fx/scarab_drop.effect" ps_drop_distance_2)
	(sleep (random_range 10 15))
)


(global short s_drop_scarab_1_far_drop_time 6)
(script dormant f_drop_scarab_1_far

	(object_create dm_drop_scarab_1_far)
	(device_set_power dm_drop_scarab_1_far 1)

	(device_set_position_track dm_drop_scarab_1_far "device:scarab_drop" 0)
  (device_animate_position dm_drop_scarab_1_far 1 s_drop_scarab_1_far_drop_time 0.034 0.034 false)
	(sleep (- (* s_drop_scarab_1_far_drop_time 30) 2) )

  (sleep_until
    (begin
	    (device_set_position_track dm_drop_scarab_1_far stationary_march 0)
	    (device_animate_position dm_drop_scarab_1_far 1.0 (random_range 7 10) 1.0 1.0 TRUE)
	    (sleep_until (>= (device_get_position dm_drop_scarab_1_far) 1) 1)
	    (sleep (random_range 0 20))
    0)
  )

)

(global short s_drop_scarab_2_far_drop_time 6)
(script dormant f_drop_scarab_2_far

	(object_create dm_drop_scarab_2_far)
	(device_set_power dm_drop_scarab_2_far 1)

	(device_set_position_track dm_drop_scarab_2_far "device:scarab_drop" 0)
  (device_animate_position dm_drop_scarab_2_far 1 s_drop_scarab_2_far_drop_time 0.034 0.034 false)
	(sleep (- (* s_drop_scarab_2_far_drop_time 30) 2) )

  (sleep_until
    (begin
	    (device_set_position_track dm_drop_scarab_2_far stationary_march 0)
	    (device_animate_position dm_drop_scarab_2_far 1.0 (random_range 7 10) 1.0 1.0 TRUE)
	    (sleep_until (>= (device_get_position dm_drop_scarab_2_far) 1) 1)
	    (sleep (random_range 0 20))
    0)
  )

)

(global short s_drop_scarab_3_far_drop_time 6)
(script dormant f_drop_scarab_3_far

	(object_create dm_drop_scarab_3_far)
	(device_set_power dm_drop_scarab_3_far 1)

	(device_set_position_track dm_drop_scarab_3_far "device:scarab_drop" 0)
  (device_animate_position dm_drop_scarab_3_far 1 s_drop_scarab_3_far_drop_time 0.034 0.034 false)
	(sleep (- (* s_drop_scarab_3_far_drop_time 30) 2) )

  (sleep_until
    (begin
	    (device_set_position_track dm_drop_scarab_3_far stationary_march 0)
	    (device_animate_position dm_drop_scarab_3_far 1.0 (random_range 7 10) 1.0 1.0 TRUE)
	    (sleep_until (>= (device_get_position dm_drop_scarab_3_far) 1) 1)
	    (sleep (random_range 0 20))
    0)
  )
)

; PODS
(script dormant f_drop_pods_control

	(sleep_until (volume_test_players tv_drop_pod_1) 1)
	(wake f_drop_pod_1a)
	(wake f_drop_pod_1b)
	(sleep_until (volume_test_players tv_drop_pod_2) 1)
	(wake f_drop_pod_2)
	(sleep_until (volume_test_players tv_drop_pod_3) 1)
	(wake f_drop_pod_3)
	(sleep_until (volume_test_players tv_drop_pod_4) 1)
	(wake f_drop_pod_4)
	(sleep_until (volume_test_players tv_drop_pod_5) 1)
	(wake f_drop_pod_5)
	(sleep_until (volume_test_players tv_drop_pod_6) 1)
	(wake f_drop_pod_6)

)


(script static void f_drop_pods_test
	(wake f_drop_pod_1a)
	(wake f_drop_pod_1b)
	(wake f_drop_pod_2)
	(wake f_drop_pod_3)
	(wake f_drop_pod_4)
	(wake f_drop_pod_5)
	(wake f_drop_pod_6)
)

(script dormant f_drop_pod_1a

	(f_drop_pod dm_drop_pod_1a sq_drop_pod_1a/driver sq_drop_pod_1a)

)

(script dormant f_drop_pod_1b

	(sleep (* 30 1))
	(f_drop_pod dm_drop_pod_1b sq_drop_pod_1b/driver sq_drop_pod_1b)

)

(script dormant f_drop_pod_2

	(f_drop_pod dm_drop_pod_2 sq_drop_pod_2/driver sq_drop_pod_2)

)

(script dormant f_drop_pod_3

	(f_drop_pod dm_drop_pod_3 sq_drop_pod_3/driver sq_drop_pod_3)

)

(script dormant f_drop_pod_4

	(f_drop_pod dm_drop_pod_4 sq_drop_pod_4/driver sq_drop_pod_4)

)

(script dormant f_drop_pod_5

	(f_drop_pod dm_drop_pod_5 sq_drop_pod_5/driver sq_drop_pod_5)

)

(script dormant f_drop_pod_6

	(f_drop_pod dm_drop_pod_6 sq_drop_pod_6/driver sq_drop_pod_6)

)

(script static void (f_drop_pod (device_name pod_marker) (ai pod_pilot) (ai pod_squad))
	(print "pod drop started...")
	(object_create_anew pod_marker)
	(ai_place pod_squad)
	(sleep 1)
	(objects_attach pod_marker "" (ai_vehicle_get_from_spawn_point pod_pilot) "")

	(device_set_position_track pod_marker "position" 0)
	(device_animate_position pod_marker 1.0 2 .034 .034 false)
	(device_set_position pod_marker 1)
	(sleep_until (>= (device_get_position pod_marker) 0.85) 1)
	(unit_open (ai_vehicle_get_from_spawn_point pod_pilot))
	(sleep_until (>= (device_get_position pod_marker) 0.98) 1)
	(dprint "impact fx")
	(effect_new_on_object_marker fx\fx_library\pod_impacts\default\pod_impact_default_large.effect pod_marker "fx_impact")
	(sleep 45)
	(vehicle_unload (ai_vehicle_get_from_spawn_point pod_pilot) "")
	(sleep_until (>= (device_get_position pod_marker) 1) 1)
	(sleep 1)
	(objects_detach pod_marker (ai_vehicle_get_from_spawn_point pod_pilot))
	(object_destroy pod_marker)
	
)


(script dormant f_drop_cleanup_control

	(sleep_until (volume_test_players tv_block_17) 5)
	(f_drop_despawn_all)
	(f_drop_kill_scripts)
	(object_destroy dm_drop_scarab_1)
	(object_destroy dm_drop_scarab_2)

)

(script static void f_drop_despawn_all

	(ai_erase gr_drop_cov)

)

(script static void f_drop_kill_scripts

	(sleep_forever f_drop_objective_control)
	(sleep_forever f_drop_save_control)
	(sleep_forever f_drop_waypoint_control)
	(sleep_forever f_drop_emile_control)
	(sleep_forever f_drop_md_control)
	(sleep_forever f_drop_longsword_control)
	(sleep_forever f_drop_spawn_control)
	(sleep_forever f_drop_scarabs_start)
	(sleep_forever f_drop_scarabs_distance)
	(sleep_forever f_drop_scarab_1)
	(sleep_forever f_drop_scarab_2)
	(sleep_forever f_drop_scarab_1_far)
	(sleep_forever f_drop_scarab_2_far)
	(sleep_forever f_drop_scarab_3_far)
	(sleep_forever f_drop_scarab_distance_1)
	(sleep_forever f_drop_scarab_distance_2)
	(sleep_forever f_drop_pods_control)
	(sleep_forever f_drop_pod_1a)
	(sleep_forever f_drop_pod_1b)
	(sleep_forever f_drop_pod_2)
	(sleep_forever f_drop_pod_3)
	(sleep_forever f_drop_pod_4)
	(sleep_forever f_drop_pod_5)
	(sleep_forever f_drop_pod_6)

	(ai_dialogue_enable TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)

)

; =================================================================================================
; =================================================================================================
; BLOCKADE
; =================================================================================================
; =================================================================================================

(script dormant f_block_objective_control
	(dprint "::: blockade encounter :::")
	
	; Wait until the zone is loaded
	;(sleep_until
		;(or
			;(= (current_zone_set_fully_active) 1)
			;(= (current_zone_set_fully_active) 2)))

	(set b_block_ready TRUE)

	; Standard Scripts
	(wake f_block_title_control)
	(wake f_block_missionobj_control)
	(wake f_block_waypoint_control)
	(wake f_block_spawn_control)
	(wake f_block_cleanup_control)
	(wake f_block_md_control)
	(wake f_block_music_control)
	(wake f_block_save_control)
	(wake f_block_emile_control)

	; Encounter Scripts
	(wake f_block_wraith_control)
	(wake f_block_phantom_gulch)
	(wake f_emile_boost)
	(if (game_is_cooperative) (wake f_block_coop_jump_forward) )

	(set b_insertion_fade_in TRUE)

	(sleep_until (volume_test_players tv_block_05) 1)
	(dprint "objective control : blockade.05")
	(set objcon_block 5)

	(sleep_until (volume_test_players tv_block_10) 1)
	(dprint "objective control : blockade.10")
	(set objcon_block 10)

	(soft_ceiling_enable camera_blocker_04 FALSE)

	(sleep_until (volume_test_players tv_block_17) 1)
	(dprint "objective control : blockade.17")
	; set second mission segment
	(data_mine_set_mission_segment "m70_02_blockade")
	(set objcon_block 17)

	(sleep_until (volume_test_players tv_block_20) 1)
	(dprint "objective control : blockade.20")
	(set objcon_block 20)

	(sleep_until (volume_test_players tv_block_30) 1)
	(dprint "objective control : blockade.30")
	(set objcon_block 30)

	(sleep_until (volume_test_players tv_block_40) 1)
	(dprint "objective control : blockade.40")
	(set objcon_block 40)

	(sleep_until (volume_test_players tv_block_50) 1)
	(dprint "objective control : blockade.50")
	(set objcon_block 50)

	(sleep_until (volume_test_players tv_block_60) 1)
	(dprint "objective control : blockade.60")
	(set objcon_block 60)

	(soft_ceiling_enable camera_blocker_09 FALSE)

	(sleep_until (volume_test_players tv_block_70) 1)
	(dprint "objective control : blockade.70")
	(set objcon_block 70)

)

(script dormant f_block_coop_jump_forward

	(sleep_until (volume_test_players "begin_zone_set:set_cave") 5)
	(sleep_until
		(begin

				(cond
					((volume_test_object tv_block_coop_jump_teleport player0)
						(if (unit_in_vehicle (player0))
							(begin
								(object_teleport_to_ai_point (object_get_parent player0) ps_block_coop_teleport/p0)
							)(begin
								(object_teleport_to_ai_point player0 ps_block_coop_teleport/p0)
						))
					)
					((volume_test_object tv_block_coop_jump_teleport player1)
						(if (unit_in_vehicle (player1))
							(begin
								(object_teleport_to_ai_point (object_get_parent player1) ps_block_coop_teleport/p1)
							)(begin
								(object_teleport_to_ai_point player1 ps_block_coop_teleport/p1)
						))
					)
					((volume_test_object tv_block_coop_jump_teleport player2)
						(if (unit_in_vehicle (player2))
							(begin
								(object_teleport_to_ai_point (object_get_parent player2) ps_block_coop_teleport/p2)
							)(begin
								(object_teleport_to_ai_point player2 ps_block_coop_teleport/p2)
						))
					)
					((volume_test_object tv_block_coop_jump_teleport player3)
						(if (unit_in_vehicle (player3))
							(begin
								(object_teleport_to_ai_point (object_get_parent player3) ps_block_coop_teleport/p3)
							)(begin
								(object_teleport_to_ai_point player3 ps_block_coop_teleport/p3)
						))
					)

				)

		FALSE)
	1)





)

(script dormant	f_block_wraith_control

	(sleep_until (volume_test_players tv_block_tower) 5)

	(sleep_until
		(begin
		
			(if (volume_test_players tv_block_tower) (cs_run_command_script sq_block_wraith f_cs_block_wraith_tower ) )
			(sleep_until (not (volume_test_players tv_block_tower)) 5)
			
		FALSE)
	30)

)

(script command_script f_cs_block_wraith_shoot

	(cs_abort_on_damage TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot_point TRUE ps_block_wraith/shoot_01)
	(sleep_until (volume_test_players tv_block_wraith_active) 5)

)

(script command_script f_cs_block_wraith_tower

	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_shoot_point TRUE ps_block_wraith/shoot_tower)	
	(sleep_until (not (volume_test_players tv_block_tower)) 5)

)

(script dormant f_block_title_control

	(sleep_until (>= objcon_block 20) 5)
	(tit_block)

)

(script dormant f_block_missionobj_control

	(sleep_until (>= objcon_block 20) 5)
	(sleep 220)
	(mo_blockade)
	(set s_music_drop 5)

)

(global short s_block_waypoint_timer_bridge 90)
(global short s_block_waypoint_timer_cave 240)
(script dormant f_block_waypoint_control

	; Linear
	(sleep_until (>= objcon_block 10))
	(sleep_until (>= objcon_block 20) 5 (* 30 s_block_waypoint_timer_bridge))
	(if (not (>= objcon_block 20))
		(begin
			(f_blip_flag fl_block_waypoint_1 blip_destination)
			(sleep_until (>= objcon_block 20) 5)
			(f_unblip_flag fl_block_waypoint_1)
		)
	)

	(sleep_until (>= objcon_block 70) 5 (* 30 s_block_waypoint_timer_cave))
	(if (not (>= objcon_block 70))
		(begin
			(f_blip_flag fl_block_waypoint_2 blip_destination)
			(sleep_until (>= objcon_block 70) 5)
			(f_unblip_flag fl_block_waypoint_2)
		)
	)

)

(script dormant f_block_emile_control

	(sleep_until
		(and
			(volume_test_object tv_area_block_gulch o_emile)
			(volume_test_players tv_area_block_gulch)
		)
	)
	(ai_set_objective sq_emile obj_block_hum)
	(sleep 10)

	(f_ai_squad_group_vehicles_exit sq_emile gr_vehicles_hum)

)

(global short s_squad_group_vehicle_counter 0)
(script static void (f_ai_squad_group_vehicles_exit (ai exiter) (ai vehicle_group))

	(set s_squad_group_vehicle_counter (ai_squad_group_get_squad_count vehicle_group))
	
	(ai_vehicle_exit exiter)
	(cs_run_command_script exiter f_cs_abort)

	(sleep_until (begin
	
		(set s_squad_group_vehicle_counter (- s_squad_group_vehicle_counter 1))

		;; Exit Vehicles
		(vehicle_unload (ai_squad_group_get_squad vehicle_group s_squad_group_counter) "")
		(ai_vehicle_reserve (ai_squad_group_get_squad vehicle_group s_squad_group_counter) TRUE)

		(<= s_squad_group_vehicle_counter 0)

	) 1)


)

(script dormant	f_block_save_control

	(wake f_block_save_combatend)

	(sleep_until (>= objcon_block 20) 5)
	(game_save_no_timeout)


	(sleep_until (>= objcon_block 60) 5)
	(game_save_no_timeout)

)

(script dormant f_block_save_combatend 

	(branch (>= objcon_tunnels 0) (f_abort))

	(sleep_until (> (ai_living_count obj_block_cov) 0) 1)
	(sleep_until (<= (ai_living_count gr_block_cov) 0))
	(game_save_no_timeout)

)

(script dormant	f_block_md_control

	(f_abort_md)

	; CONDITIONAL
	; -----------------

	; dismount validation prompt
	(wake f_block_md_block_dismount)	
	
	; LINEAR
	; -----------------

	(sleep_until (>= objcon_block 10) 1)
	(md_block_bridge)

	(sleep_until (>= objcon_block 20) 1)
	(md_block_warn)

	;(sleep_until (>= objcon_block 30))
	;(md_block_snipers)

	(sleep_until (>= objcon_block 30) 1)
	(md_block_wraith)

	(sleep_until 
		(or
			(>= objcon_block 60)
			(<= (ai_living_count obj_block_cov) 1)
			(<= (ai_living_count sq_block_wraith) 0)
		)
	1)

	(sleep_until (>= objcon_block 70) 1)

	; cave exit delay
	(sleep_until (>= objcon_block 70) 1 400)
	(if (not (>= objcon_block 70))
		(begin
			(md_block_gulch_delay_0)
		)
	)

	(sleep_until (>= objcon_block 70) 1 400)
	(if (not (>= objcon_block 70))
		(begin
			(md_block_gulch_delay_1)
		)
	)

)

(script dormant	f_block_md_block_dismount

	(branch
		(>= objcon_block 30)
		(f_abort_md)
	)

	(sleep_until
		(and
			(volume_test_players tv_block_bridge_near)
			(not b_players_any_in_vehicle)
		)
	)

	(md_block_dismount)

)

(script dormant	f_block_music_control

	(wake music_block)
	
	(sleep_until (> (ai_living_count obj_block_cov) 0) 1)

	(sleep_until
		(or
			(>= objcon_block 60)
			(<= (ai_living_count obj_block_cov) 0)
		)
	)
	(set s_music_block 1)

)


(script dormant f_block_spawn_control

	(sleep_until (>= objcon_block 17) 1)
	(sleep 30)
	
	(dprint "::: spawning all blockade squads")
	(f_squad_group_place gr_block_cov_init)

	(sleep_until (>= objcon_block 60) 1)

	(f_squad_group_place gr_block_cov_hill)
	(tick)
	(ai_grunt_kamikaze sq_block_grunt_hill)

)

; PHANTOM
;============================================

(script dormant f_block_phantom_gulch
	(sleep_until (volume_test_players tv_block_phantom) 1)
	(garbage_collect_now)
	(tick)
	(ai_place sq_block_phantom_gulch)
)

(global vehicle v_block_phantom_gulch none)
(script command_script f_cs_block_phantom_gulch

	(cs_ignore_obstacles TRUE)

	(dprint "phantom gulch")
	(set v_block_phantom_gulch (ai_vehicle_get_from_starting_location sq_block_phantom_gulch/driver_01))

	(f_load_phantom_cargo v_block_phantom_gulch "single" sq_block_wraith NONE)
	(object_set_velocity v_block_phantom_gulch 5)

	; enter
	;--------------------------------------------
	(cs_fly_by ps_block_phantom_gulch/move_00)
	(cs_fly_by ps_block_phantom_gulch/move_01)
	(cs_fly_by ps_block_phantom_gulch/move_02)
	(cs_fly_by ps_block_phantom_gulch/move_03)
	(cs_fly_by ps_block_phantom_gulch/move_04)
	
	; hover
	;--------------------------------------------
	(cs_fly_by ps_block_phantom_gulch/move_05)	
	(sleep 60)
	
	; lower
	;--------------------------------------------	
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_block_phantom_gulch/move_06 ps_block_phantom_gulch/move_06_face .1)
	(sleep 60)
	(f_unload_phantom_cargo (ai_vehicle_get ai_current_actor) "single")
	(sleep 120)
	;(cs_fly_to_and_face ps_block_phantom_gulch/move_06 ps_block_phantom_gulch/face_05 1)


	; rise ====================================================
	(cs_fly_by ps_block_phantom_gulch/move_05)
		
	; == exit ====================================================
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_block_phantom_gulch/move_07)
	(cs_fly_by ps_block_phantom_gulch/move_08)
	(ai_erase ai_current_squad)
	
)


(script dormant f_block_cleanup_control

	(sleep_until (volume_test_players tv_block_cleanup) 5)
	(f_block_despawn_all)
	(f_block_kill_scripts)

)

(script static void f_block_despawn_all

	(ai_erase gr_block_cov)

)

(script static void f_block_kill_scripts

	(sleep_forever f_block_objective_control)
	(sleep_forever f_block_title_control)
	(sleep_forever f_block_missionobj_control)
	(sleep_forever f_block_waypoint_control)
	(sleep_forever f_block_emile_control)
	(sleep_forever f_block_save_control)
	(sleep_forever f_block_save_combatend)
	(sleep_forever f_block_md_control)
	(sleep_forever f_block_md_block_dismount)
	(sleep_forever f_block_music_control)
	(sleep_forever f_block_spawn_control)
	(sleep_forever f_block_phantom_gulch)
	(sleep_forever f_block_wraith_control)
	(ai_dialogue_enable TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)

)

; =================================================================================================
; =================================================================================================
; CARTER
; =================================================================================================
; =================================================================================================

(script dormant f_carter_objective_control
	(dprint "::: carter encounter :::")
	; set third mission segment
	(data_mine_set_mission_segment "m70_03_carter")
	; Wait until the zone is loaded
	;(sleep_until
		;(or
			;(= (current_zone_set_fully_active) 1)
			;(= (current_zone_set_fully_active) 2)))

	(set b_carter_ready TRUE)

	; Standard
	(wake f_carter_save_control)
	(wake f_carter_waypoint_control)
	(wake f_carter_md_control)
	(wake f_carter_cleanup_control)

	; Encounter
	(wake f_carter_emile_control)
	(wake f_carter_cin_control)
	
	(set b_insertion_fade_in TRUE)

	(sleep_until (volume_test_players tv_carter_10) 1)
	(dprint "objective control : carter.10")
	(set objcon_carter 10)

	(sleep_until (volume_test_players tv_carter_20) 1)
	(dprint "objective control : carter.20")
	(set objcon_carter 20)

	(sleep_until (volume_test_players tv_carter_30) 1)
	(dprint "objective control : carter.30")
	(set objcon_carter 30)

	(sleep_until (volume_test_players tv_carter_40) 1)
	(dprint "objective control : carter.40")
	(set objcon_carter 40)

)

(script dormant f_carter_save_control

	(sleep_until (>= objcon_carter 20) 5)
	(game_save_no_timeout)

)

(global short s_carter_waypoint_timer 90)
(script dormant f_carter_waypoint_control

	; Nonlinear

	; Linear
	(sleep_until (>= objcon_carter 10) 5)
	(sleep_until (>= objcon_carter 40) 5 (* 30 s_carter_waypoint_timer))
	(if (not (>= objcon_carter 40))
		(begin
			(f_blip_flag fl_carter_waypoint_1 blip_destination)
			(sleep_until (>= objcon_carter 40) 5)
			(f_unblip_flag fl_carter_waypoint_1)
		)
	)

)

(script dormant f_carter_emile_control

	(sleep_until
		(and
			(volume_test_object tv_area_carter o_emile)
			(volume_test_players tv_area_carter)
		)
	)
	(ai_set_objective sq_emile obj_carter_hum)
	(sleep 10)
	(cs_run_command_script sq_emile f_cs_abort)

)

(script dormant	f_carter_md_control

	(f_abort_md)

	(sleep_until (>= objcon_carter 30) 1)
	(md_carter_battle_0)

)

(global boolean b_carter_cin_done FALSE)
(script dormant	f_carter_cin_control

	(sleep_until (>= objcon_carter 40) 1)

	(cinematic_enter 070la2_carter_death TRUE)
	(f_cin_carter_prep)
  (f_play_cinematic_advanced 070la2_carter_death set_cave set_cave)
	(f_cin_carter_finish)
  (cinematic_exit 070la2_carter_death TRUE)
	
)


(script static void f_cin_carter_prep

	(ai_erase sq_emile)
	(object_teleport_to_ai_point player0 ps_carter_cin/pre0)
	(object_teleport_to_ai_point player1 ps_carter_cin/pre1)
	(object_teleport_to_ai_point player2 ps_carter_cin/pre2)
	(object_teleport_to_ai_point player3 ps_carter_cin/pre3)

	; vehicles
	(object_destroy_type_mask 2)
	(add_recycling_volume_by_type tv_recycle_cave 0 1 1)

)

(script static void f_cin_carter_finish

	(f_emile_spawn sq_emile/sp_carter_cin obj_tunnels_hum)
	(object_teleport_to_ai_point player0 ps_carter_cin/p0)
	(object_teleport_to_ai_point player1 ps_carter_cin/p1)
	(object_teleport_to_ai_point player2 ps_carter_cin/p2)
	(object_teleport_to_ai_point player3 ps_carter_cin/p3)
	(object_teleport_to_ai_point ai_emile ps_carter_cin/emile)

)


(script dormant f_carter_cleanup_control

	(sleep_until (volume_test_players tv_carter_cleanup) 1)
	(f_carter_despawn_all)
	(f_carter_kill_scripts)

)

(script static void f_carter_despawn_all
	
	(ai_erase gr_carter_cov)
	(ai_erase gr_carter_hum_pelican)

)


(script static void f_carter_kill_scripts

	(sleep_forever f_carter_objective_control)
	(sleep_forever f_carter_save_control)
	(sleep_forever f_carter_waypoint_control)
	(sleep_forever f_carter_emile_control)
	(sleep_forever f_carter_md_control)
	(sleep_forever f_carter_cin_control)
	(ai_dialogue_enable TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)

)

; =================================================================================================
; =================================================================================================
; TUNNELS
; =================================================================================================
; =================================================================================================

(script dormant f_tunnels_objective_control
	(dprint "::: tunnels encounter :::")
	
	; Wait until the zone is loaded
	;(sleep_until
		;(or
			;(= (current_zone_set_fully_active) 1)
			;(= (current_zone_set_fully_active) 2)))

	(set b_tunnels_ready TRUE)

	; Standard Scripts	
	(wake f_tunnels_save_control)
	(wake f_tunnels_waypoint_control)
	(wake f_tunnels_spawn_control)
	(wake f_tunnels_cleanup_control)
	(wake f_tunnels_md_control)
	(wake f_tunnels_music_control)
	(wake f_tunnels_emile_control)

	; Encounter Scripts	

	(set b_insertion_fade_in TRUE)
	
	(sleep_until (volume_test_players tv_tunnels_10) 1)
	(dprint "objective control : tunnels.10")
	(set objcon_tunnels 10)

	(sleep_until (volume_test_players tv_tunnels_15) 1)
	(dprint "objective control : tunnels.15")
	(set objcon_tunnels 15)

	(soft_ceiling_enable camera_blocker_05 FALSE)

	(sleep_until (volume_test_players tv_tunnels_20) 1)
	(dprint "objective control : tunnels.20")
	(set objcon_tunnels 20)
	
	(sleep_until (volume_test_players tv_tunnels_30) 1)
	(dprint "objective control : tunnels.30")
	(set objcon_tunnels 30)

	(sleep_until (volume_test_players tv_tunnels_40) 1)
	(dprint "objective control : tunnels.40")
	(set objcon_tunnels 40)

	(sleep_until
		(or
			(volume_test_players tv_tunnels_50_1)
			(volume_test_players tv_tunnels_50_2)
		)
	1)
	(dprint "objective control : tunnels.50")
	(set objcon_tunnels 50)

	(sleep_until (volume_test_players tv_tunnels_55) 1)
	(dprint "objective control : tunnels.55")
	(set objcon_tunnels 55)

	(sleep_until (volume_test_players tv_tunnels_60) 1)
	(dprint "objective control : tunnels.50")
	(set objcon_tunnels 60)

)

(script dormant f_tunnels_save_control

	(wake f_tunnels_save_combatend)

	(sleep_until (>= objcon_tunnels 15))
	(game_save_no_timeout)

	(sleep_until (>= objcon_tunnels 30))
	(game_save_no_timeout)

)

(script dormant f_tunnels_save_combatend 

	(branch (>= objcon_wall 0) (f_abort))

	(sleep_until (<= (ai_living_count gr_tunnels_cov) 0))
	(game_save_no_timeout)

)

(global short s_tunnels_waypoint_timer_entry 60)
(global short s_tunnels_waypoint_timer_exit 180)
(script dormant f_tunnels_waypoint_control

	; Nonlinear

	; Linear
	(sleep_until (>= objcon_tunnels 10))
	(sleep_until (>= objcon_tunnels 20) 5 (* 30 s_tunnels_waypoint_timer_entry))
	(if (not (>= objcon_tunnels 20))
		(begin
			(f_blip_flag fl_tunnels_waypoint_1 blip_destination)
			(sleep_until (>= objcon_tunnels 20) 5)
			(f_unblip_flag fl_tunnels_waypoint_1)
		)
	)

	(sleep_until (>= objcon_tunnels 50))

	(sleep_until (>= objcon_tunnels 60) 5 (* 30 s_tunnels_waypoint_timer_exit))
	(if (not (>= objcon_tunnels 60))
		(begin
			(f_blip_flag fl_tunnels_waypoint_2 blip_destination)
			(sleep_until (>= objcon_tunnels 60) 5)
			(f_unblip_flag fl_tunnels_waypoint_2)
		)
	)

)

(script dormant f_tunnels_emile_control

	(sleep_until
		(and
			(volume_test_object tv_area_tunnels o_emile)
			(volume_test_players tv_area_tunnels)
		)
	)
	(ai_set_objective sq_emile obj_tunnels_hum)
	(sleep 10)
	(ai_vehicle_exit sq_emile)
	(cs_run_command_script sq_emile f_cs_abort)

)

(script dormant f_tunnels_md_control

	(f_abort_md)

	(sleep_until (>= objcon_tunnels 20) 1)
	(md_tunnels_bugger_0)
	
	(sleep_until (>= objcon_tunnels 30) 1)
	(md_tunnels_bugger_1)

	(sleep_until
		(or
			(>= objcon_tunnels 60)
			(<= (ai_living_count obj_tunnels_cov) 1)
		)
	1)

	(sleep_until (>= objcon_tunnels 60) 1 (* 30 120))
	(if (not (>= objcon_tunnels 60))
		(begin
			(md_tunnels_delay_0)
		)
	)

	(sleep_until (>= objcon_tunnels 60) 1 (* 30 120))
	(if (not (>= objcon_tunnels 60))
		(begin
			(md_tunnels_delay_2)
		)
	)

)

(script dormant f_tunnels_spawn_control

	(sleep_until (>= objcon_tunnels 20))
	(ai_place	gr_tunnels_cov_init)
	
	(sleep_until (>= objcon_tunnels 30))
	(ai_place	gr_tunnels_cov_lake)

)

(script dormant	f_tunnels_music_control

	(wake music_tunnels)

)


(script static void f_tunnels_despawn_all

	(ai_erase	gr_tunnels_cov)

)

(script dormant f_tunnels_cleanup_control

	(sleep_until (volume_test_players tv_tunnels_cleanup) 5)
	(f_tunnels_despawn_all)
	(f_tunnels_kill_scripts)

)


(script static void f_tunnels_kill_scripts

	(sleep_forever f_tunnels_objective_control)
	(sleep_forever f_tunnels_save_control)
	(sleep_forever f_tunnels_save_combatend)
	(sleep_forever f_tunnels_waypoint_control)
	(sleep_forever f_tunnels_emile_control)
	(sleep_forever f_tunnels_md_control)
	(sleep_forever f_tunnels_spawn_control)	
	(sleep_forever f_tunnels_music_control)
	(ai_dialogue_enable TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	
)


; =================================================================================================
; =================================================================================================
; WALL
; =================================================================================================
; =================================================================================================

(script dormant f_wall_objective_control
	(dprint "::: wall encounter :::")
	; set fourth mission segment
	(data_mine_set_mission_segment "m70_04_wall")
	;Wait until the zone is loaded
	;(sleep_until
		;(or
			;(= (current_zone_set_fully_active) 1)
			;(= (current_zone_set_fully_active) 2)))

	(set b_wall_ready TRUE)

	; Standard Scripts
	(wake f_wall_missionobj_control)
	(wake f_wall_save_control)
	(wake f_wall_waypoint_control)
	(wake f_wall_spawn_control)
	(wake f_wall_music_control)
	(wake f_wall_md_control)
	(wake f_wall_cleanup_control)
	(wake f_wall_emile_control)

	; Encounter Scripts
	(wake f_wall_dropship_control)
	(wake f_wall_combat_refresh)

	(set b_insertion_fade_in TRUE)
	(game_insertion_point_unlock 2)
	(f_loadout_set "boneyard")

	(sleep_until (volume_test_players tv_wall_10) 1)
	(dprint "objective control : wall.10")
	(set objcon_wall 10)

	(soft_ceiling_enable camera_blocker_06 FALSE)

	(sleep_until (volume_test_players tv_wall_15) 1)
	(dprint "objective control : wall.15")
	(set objcon_wall 15)

	(sleep_until (volume_test_players tv_wall_20) 1)
	(dprint "objective control : wall.20")
	(set objcon_wall 20)

	(sleep_until (volume_test_players tv_wall_30) 1)
	(dprint "objective control : wall.30")
	(set objcon_wall 30)

	(sleep_until (volume_test_players tv_wall_40) 1)
	(dprint "objective control : wall.40")
	(set objcon_wall 40)

	(sleep_until (volume_test_players tv_wall_50) 1)
	(dprint "objective control : wall.50")
	(set objcon_wall 50)

	(sleep_until (volume_test_players tv_wall_60) 1)
	(dprint "objective control : wall.60")
	(set objcon_wall 60)

)

(script dormant f_wall_combat_refresh

	(sleep_until
		(begin
			(ai_renew gr_wall_cov)
			(ai_renew gr_wall_hum)
			(>= objcon_wall 15)
		)
	30)

)

(script dormant f_wall_missionobj_control

	(if b_ins_wall
		(begin
			(sleep 0)
		)
		(begin
			(sleep_until (>= objcon_wall 15) 5)		
		)
	)
	(mo_wall)

)

(script dormant f_wall_save_control

	(wake f_wall_save_combatend)

	(sleep_until (>= objcon_wall 20) 5)
	(game_save_no_timeout)

)

(script dormant f_wall_save_combatend

	(branch (>= objcon_factory 0) (f_abort))

	(sleep_until (<= (ai_living_count gr_wall_cov) 0))
	(game_save_no_timeout)

)

(script dormant f_wall_title_control

	(sleep_until (>= objcon_wall 15) 5)
	(tit_wall)

)

(global short s_wall_waypoint_timer 240)
(script dormant f_wall_waypoint_control

	(sleep_until (>= objcon_wall 10) 5)
	(sleep_until (>= objcon_wall 60) 5 (* 30 s_wall_waypoint_timer))
	(if (not (>= objcon_wall 60))
		(begin
			(f_blip_flag fl_wall_waypoint_1 blip_destination)
			(sleep_until (>= objcon_wall 60) 5)
			(f_unblip_flag fl_wall_waypoint_1)
		)
	)

)

(script dormant f_wall_emile_control

	(sleep_until
		(and
			(volume_test_object tv_area_wall o_emile)
			(volume_test_players tv_area_wall)
		)
	)
	(ai_set_objective sq_emile obj_wall_hum)
	(sleep 10)
	(ai_vehicle_exit sq_emile)
	(cs_run_command_script sq_emile f_cs_abort)

)

(script dormant f_wall_md_control

	(f_abort_md)

	; CONDITIONAL
	; ---------------
	(wake f_wall_md_wall_marine_0)
	(wake f_wall_md_wall_marine_1)

	; LINEAR
	(sleep_until (>= objcon_wall 10) 1)
	(md_wall_intro)
	
)

(global short s_wall_md_marine_idx 0)
(script dormant	f_wall_md_wall_marine_0

	(branch
		(>= objcon_wall 40)
		(f_abort_md)
	)

	(sleep_until (<= (objects_distance_to_object (players) sq_wall_marine_2/trooper_0) 6) 1)
	(sleep_forever f_wall_md_wall_marine_1)
	(set s_wall_md_marine_idx 0)
	(md_wall_marine_0_near)

	(sleep_until (<= (objects_distance_to_object (players) sq_wall_marine_2/trooper_0) 2) 1)
	(md_wall_marine_0)

)

(script dormant	f_wall_md_wall_marine_1

	(branch
		(>= objcon_wall 40)
		(f_abort_md)
	)

	(sleep_until (<= (objects_distance_to_object (players) sq_wall_marine_4/trooper_1) 6) 1)
	(sleep_forever f_wall_md_wall_marine_0)
	(set s_wall_md_marine_idx 1)
	(md_wall_marine_0_near)

	(sleep_until (<= (objects_distance_to_object (players) sq_wall_marine_4/trooper_1) 2) 1)
	(md_wall_marine_0)

)

(script dormant f_wall_music_control

	(wake music_wall)
	
	(sleep_until (= s_music_wall 1) 1)

	(sleep (* 30 140))
	
	(if (<= objcon_factory 50) (begin

		(set s_music_wall 2)

	)(begin

		(sleep_forever music_wall)
	
	))

)


(script dormant f_wall_dropship_control

	(set s_wave_spawning 0)

	(sleep_until (>= objcon_wall 20))
	;(ai_place sq_wall_phantom_w1_1)

)

(script command_script f_cs_wall_phantom_w1_1

	(set s_wave_spawning (+ s_wave_spawning 1))

	(f_load_phantom ai_current_squad "right" sq_wall_w1_1_1 NONE NONE NONE)

	; enter
	;--------------------------------------------
	(cs_fly_by ps_wall_phantom_w1_1/enter_01)
	(cs_fly_by ps_wall_phantom_w1_1/enter_02)
	
	; unload 1
	;--------------------------------------------
	(cs_fly_by ps_wall_phantom_w1_1/hover_01)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_wall_phantom_w1_1/drop_01 ps_wall_phantom_w1_1/drop_01_face 1)
	(f_unload_phantom ai_current_squad "dual")

	(sleep 30)
	(set s_wave_spawning (- s_wave_spawning 1))

	; exit
	;--------------------------------------------
	(cs_fly_to_and_face ps_wall_phantom_w1_1/hover_01 ps_wall_phantom_w1_1/drop_01_face 1)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_wall_phantom_w1_1/exit_01)
	(cs_fly_by ps_wall_phantom_w1_1/exit_02)
	(cs_fly_by ps_wall_phantom_w1_1/erase)
	(ai_erase ai_current_squad)

)

(script dormant f_wall_spawn_control
	(dprint "::: spawning all wall squads")

	(if (= s_special_elite 1) (ai_place sq_wall_bob) )

	(ai_place gr_wall_cov_init)
	(ai_place gr_wall_hum)

)

(script dormant f_wall_cleanup_control

	(sleep_until (volume_test_players tv_wall_cleanup) 5)
	(f_wall_despawn_all)
	(f_wall_kill_scripts)

)


(script static void f_wall_despawn_all
	(dprint "::: despawning all wall squads")

	(ai_erase gr_wall_cov)
	(ai_erase gr_wall_hum)

)

(script static void f_wall_kill_scripts

	(sleep_forever f_wall_objective_control)
	(sleep_forever f_wall_combat_refresh)
	(sleep_forever f_wall_missionobj_control)
	(sleep_forever f_wall_save_control)
	(sleep_forever f_wall_save_combatend)
	(sleep_forever f_wall_title_control)
	(sleep_forever f_wall_waypoint_control)
	(sleep_forever f_wall_emile_control)
	(sleep_forever f_wall_md_control)
	(sleep_forever f_wall_md_wall_marine_0)
	(sleep_forever f_wall_md_wall_marine_1)
	(sleep_forever f_wall_music_control)
	(sleep_forever f_wall_dropship_control)
	(sleep_forever f_wall_spawn_control)
	(ai_dialogue_enable TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)
	
)


; =================================================================================================
; =================================================================================================
; FACTORY
; =================================================================================================
; =================================================================================================

(script dormant f_factory_objective_control
	(dprint "::: factory encounter :::")
	; set fifth mission segment
	(data_mine_set_mission_segment "m70_05_factory")
	; Wait until the zone is loaded
	;(sleep_until
		;(or
			;(= (current_zone_set_fully_active) 1)
			;(= (current_zone_set_fully_active) 2)))

	(set b_factory_ready TRUE)

	; Standard Scripts
	(wake f_factory_save_control)
	(wake f_factory_waypoint_control)
	(wake f_factory_spawn_control)
	(wake f_factory_md_control)
	(wake f_factory_music_control)
	(wake f_factory_cleanup_control)
	(wake f_factory_emile_control)

	; Encounter Scripts
	(wake f_factory_squad_migrate)
	(wake f_factory_zoneset_door)
	(wake f_factory_bomb)

	(dprint "objective control : factory.1")
	(set objcon_factory 1)

	(set b_insertion_fade_in TRUE)

	(sleep_until (volume_test_players tv_factory_10) 5)
	(dprint "objective control : factory.10")
	(set objcon_factory 10)

	(soft_ceiling_enable camera_blocker_07 FALSE)

	(sleep_until (volume_test_players tv_factory_20) 5)
	(dprint "objective control : factory.20")
	(set objcon_factory 20)

	(sleep_until (volume_test_players tv_factory_25) 5)
	(dprint "objective control : factory.25")
	(set objcon_factory 25)

	(sleep_until (volume_test_players tv_factory_30) 5)
	(dprint "objective control : factory.30")
	(set objcon_factory 30)

	(sleep_until (volume_test_players tv_factory_40) 5)
	(dprint "objective control : factory.40")
	(set objcon_factory 40)

	(sleep_until (volume_test_players tv_factory_50) 5)
	(dprint "objective control : factory.50")
	(set objcon_factory 50)

	(sleep_until (volume_test_players tv_factory_60) 5)
	(dprint "objective control : factory.60")
	(set objcon_factory 60)

)

(script dormant f_factory_music_control

	(wake music_factory)

)

(script dormant f_factory_bomb

	(sleep_until (>= objcon_factory 60))

	(set s_music_factory 1)

	(set b_shake TRUE)
	(sleep 60)

	(interpolator_start base_bombing)
	(sound_impulse_start sound\levels\020_base\base_scripted_expl1 NONE 1)

)


(script dormant f_factory_zoneset_door

	(sleep_until (>= objcon_factory 60) 1)
	(device_set_power dm_hall1_door 1)
	(device_operates_automatically_set dm_hall1_door FALSE)
	(device_set_position dm_hall1_door 0)
	(sleep_until (= (device_get_position dm_hall1_door) 0) 1)
	(device_set_power dm_hall1_door 0)

	; Coop Teleport Failsafe
	(if (game_is_cooperative)
		(begin
			(if
				(not
					(or
						(volume_test_object tv_area_hall_1 player0)
						(volume_test_object tv_area_crane player0)
					)
				)
				(begin
					(object_teleport_to_ai_point player0 ps_factory_hall1_spawn/p0)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_hall_1 player1)
						(volume_test_object tv_area_crane player1)
					)
				)
				(begin
					(object_teleport_to_ai_point player1 ps_factory_hall1_spawn/p1)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_hall_1 player2)
						(volume_test_object tv_area_crane player2)
					)
				)
				(begin
					(object_teleport_to_ai_point player2 ps_factory_hall1_spawn/p2)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_hall_1 player3)
						(volume_test_object tv_area_crane player3)
					)
				)
				(begin
					(object_teleport_to_ai_point player3 ps_factory_hall1_spawn/p3)
				)
			)
		)
	)

	(zone_set_trigger_volume_enable begin_zone_set:set_smelt TRUE)

)

(script dormant f_factory_squad_migrate

	(sleep_until (>= objcon_factory 1))
	(ai_set_task gr_wall_hum obj_factory_hum gate_ship)

)

(script dormant f_factory_save_control

	(wake f_factory_save_combatend)

	(sleep_until (>= objcon_factory 20))
	(game_save_no_timeout)

	(sleep_until (>= objcon_factory 40))
	(game_save_no_timeout)

)

(script dormant f_factory_save_combatend

	(branch (>= objcon_crane 0) (f_abort))

	(sleep_until (<= (ai_living_count gr_factory_cov) 0))
	(game_save_no_timeout)

)

(global short s_factory_waypoint_timer 180)
(script dormant f_factory_waypoint_control

	(sleep_until (>= objcon_factory 10) 5)
	(sleep_until (>= objcon_factory 50) 5 (* 30 s_factory_waypoint_timer))
	(if (not (>= objcon_factory 50))
		(begin
			(f_blip_flag fl_factory_waypoint_1 blip_destination)
			(sleep_until (>= objcon_factory 50) 5)
			(f_unblip_flag fl_factory_waypoint_1)
		)
	)

)

(script dormant f_factory_emile_control

	(sleep_until
		(and
			(volume_test_object tv_area_factory o_emile)
			(volume_test_players tv_area_factory)
		)
	)
	(ai_set_objective sq_emile obj_factory_hum)
	(sleep 10)
	(ai_vehicle_exit sq_emile)
	(cs_run_command_script sq_emile f_cs_abort)

)

(script dormant f_factory_md_control

	(f_abort_md)

	; CONDITIONAL
	; ---------------
	(wake f_factory_md_factory_marine_0)

	; LINEAR
	(sleep_until (>= objcon_factory 20) 1 (* 30 120))
	(if (not (>= objcon_factory 20))
		(begin
			(md_factory_ship_delay_0)
		)
	)

	(sleep_until
		(or
			(>= objcon_factory 30)
			(<= (ai_task_count obj_factory_cov/gate_factory_ent) 1)
		)
	1)

	(sleep_until (>= objcon_factory 30) 1 (* 30 90))
	(if (not (>= objcon_factory 30))
		(begin
			(md_factory_delay_2)
		)
	)

	(sleep_until
		(or
			(>= objcon_factory 50)
			(<= (ai_task_count obj_factory_cov/gate_factory) 1)
		)
	1)

	(sleep_until (>= objcon_factory 50) 1 (* 30 90))
	(if (not (>= objcon_factory 50))
		(begin
			(md_factory_delay_3)
		)
	)

)

(script dormant	f_factory_md_factory_marine_0

	(sleep_until (volume_test_players tv_factory_marine_0))
	(md_factory_marine_0)

)

(script dormant f_factory_spawn_control
	(dprint "::: spawning all wall squads")

	(sleep_until (>= objcon_factory 10))

	(if (= s_special_elite 2) (ai_place sq_factory_bob) )

	(f_squad_group_place gr_factory_cov_init)
	(f_squad_group_place gr_factory_cov_rush)
	(f_squad_group_place gr_factory_hum_init)

	(if b_factory_ins
		(f_squad_group_place gr_factory_hum_ins)
	)

	(sleep_until (>= objcon_factory 30))
	(f_squad_group_place gr_factory_cov_inside)

)

(script dormant f_factory_cleanup_control

	(sleep_until (volume_test_players tv_factory_cleanup) 5)
	(f_factory_despawn_all)
	(f_factory_kill_scripts)

)

(script static void f_factory_despawn_all

	(ai_erase gr_factory_cov)

)

(script static void f_factory_kill_scripts

	(sleep_forever f_factory_objective_control)
	(sleep_forever f_factory_zoneset_door)
	(sleep_forever f_factory_squad_migrate)
	(sleep_forever f_factory_save_control)
	(sleep_forever f_factory_save_combatend)
	(sleep_forever f_factory_waypoint_control)
	(sleep_forever f_factory_emile_control)
	(sleep_forever f_factory_md_control)
	(sleep_forever f_factory_music_control)
	(sleep_forever f_factory_md_factory_marine_0)
	(sleep_forever f_factory_spawn_control)
	(sleep_forever f_factory_bomb)
	(ai_dialogue_enable TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)

)

; =================================================================================================
; =================================================================================================
; CRANE
; =================================================================================================
; =================================================================================================

(global boolean b_crane_hunters_active FALSE)
(script dormant f_crane_objective_control
	(dprint "::: crane encounter :::")
	; set sixth mission segment
	(data_mine_set_mission_segment "m70_06_crane")
	(set b_crane_ready TRUE)
	
	; Standard Scripts
	(wake f_crane_waypoint_control)
	(wake f_crane_spawn_control)
	(wake f_crane_save_control)
	(wake f_crane_music_control)
	(wake f_crane_md_control)
	(wake f_crane_cleanup_control)
	(wake f_crane_emile_control)
	(wake f_crane_zoneset_door)

	; Encounter Scripts
	(wake f_crane_phantom)
	(wake f_crane_catwalk_entry)
	(wake f_crane_combat_refresh)
	
	(set b_insertion_fade_in TRUE)
	(f_loadout_set "smelter")

	(dprint "objective control : crane.01")
	(set objcon_crane 1)

	(sleep_until (volume_test_players tv_crane_10) 5)
	(dprint "objective control : crane.10")
	(set objcon_crane 10)

	(sleep_until (volume_test_players tv_crane_20) 5)
	(dprint "objective control : crane.20")
	(set objcon_crane 20)

	(sleep_until (volume_test_players tv_crane_30) 5)
	(dprint "objective control : crane.30")
	(set objcon_crane 30)

	(sleep_until (volume_test_players tv_crane_40) 5)
	(dprint "objective control : crane.40")
	(set objcon_crane 40)

	(sleep_until (volume_test_players tv_crane_45) 5)
	(dprint "objective control : crane.45")
	(set objcon_crane 45)

	(sleep_until (volume_test_players tv_crane_50) 5)
	(dprint "objective control : crane.50")
	(set objcon_crane 50)

	(sleep_until (volume_test_players tv_crane_53) 5)
	(dprint "objective control : crane.53")
	(set objcon_crane 53)

	(sleep_until (volume_test_players tv_crane_55) 5)
	(dprint "objective control : crane.55")
	(set objcon_crane 55)

	(soft_ceiling_enable camera_blocker_08 FALSE)

	(sleep_until (volume_test_players tv_crane_60) 5)
	(dprint "objective control : crane.60")
	(set objcon_crane 60)

	(sleep_until (volume_test_players tv_crane_70) 5)
	(dprint "objective control : crane.70")
	(set objcon_crane 70)

	(sleep_until (volume_test_players tv_crane_75) 5)
	(dprint "objective control : crane.75")
	(set objcon_crane 75)

	(sleep_until (volume_test_players tv_crane_80) 5)
	(dprint "objective control : crane.80")
	(set objcon_crane 80)

)

(script dormant f_crane_zoneset_door

	(device_set_power dm_smelt_door 1)

	(sleep_until (>= objcon_crane 50) 1)
	(device_operates_automatically_set dm_smelt_door FALSE)
	(device_set_position dm_smelt_door 0)
	(sleep_until (= (device_get_position dm_smelt_door) 0) 1)
	(device_set_power dm_smelt_door 0)

	; Coop Teleport Failsafe
	(if (game_is_cooperative)
		(begin
			(if
				(not
					(or
						(volume_test_object tv_area_hall_2 player0)
						(volume_test_object tv_area_crane player0)
					)
				)
				(begin
					(object_teleport_to_ai_point player0 ps_crane_coop_spawn/p0)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_hall_2 player1)
						(volume_test_object tv_area_crane player1)
					)
				)
				(begin
					(object_teleport_to_ai_point player1 ps_crane_coop_spawn/p1)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_hall_2 player2)
						(volume_test_object tv_area_crane player2)
					)
				)
				(begin
					(object_teleport_to_ai_point player2 ps_crane_coop_spawn/p2)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_hall_2 player3)
						(volume_test_object tv_area_crane player3)
					)
				)
				(begin
					(object_teleport_to_ai_point player3 ps_crane_coop_spawn/p3)
				)
			)
		)
	)

	(zone_set_trigger_volume_enable begin_zone_set:set_hall_2 TRUE)

)

(script dormant f_crane_combat_refresh

	(sleep_until
		(begin
			(ai_renew gr_crane_cov_init)
			(>= objcon_crane 30)
		)
	5)

	(sleep_until
		(begin
			(ai_renew sq_crane_marine_low)
			(>= objcon_crane 45)
		)
	5)

)

(global short s_crane_waypoint_timer_platform 180)
(global short s_crane_waypoint_timer_exit 120)
(script dormant f_crane_waypoint_control

	(sleep_until (>= objcon_crane 10) 5)
	(sleep_until (>= objcon_crane 60) 5 (* 30 s_crane_waypoint_timer_platform))
	(if (not (>= objcon_crane 60))
		(begin
			(f_blip_flag fl_crane_waypoint_1 blip_destination)
			(sleep_until (>= objcon_crane 60) 5)
			(f_unblip_flag fl_crane_waypoint_1)
		)
	)

	(sleep_until (<= (ai_task_count obj_crane_cov/gate_hunter) 0))

	(sleep_until (>= objcon_crane 80) 5 (* 30 s_crane_waypoint_timer_exit))
	(if (not (>= objcon_crane 80))
		(begin
			(f_blip_flag fl_crane_waypoint_2 blip_destination)
			(sleep_until (>= objcon_crane 80) 5)
			(f_unblip_flag fl_crane_waypoint_2)
		)
	)

)

(script dormant f_crane_save_control

	(wake f_crane_save_combatend)

	(sleep_until (>= objcon_crane 30) 5)
	(game_save_no_timeout)

	(sleep_until (>= objcon_crane 55) 5)
	(game_save_no_timeout)

)

(script dormant f_crane_save_combatend

	(branch (>= objcon_drop 0) (f_abort))

	(sleep_until (<= (ai_living_count gr_crane_cov) 0))
	(game_save_no_timeout)

)

(script dormant f_crane_emile_control

	(sleep_until
		(and
			(volume_test_object tv_area_crane o_emile)
			(volume_test_players tv_area_crane)
		)
	)
	(ai_set_objective sq_emile obj_crane_hum)
	(sleep 10)
	(ai_vehicle_exit sq_emile)
	(cs_run_command_script sq_emile f_cs_abort)

)

(script dormant f_crane_music_control

	(wake music_crane)
	
	(sleep_until (>= objcon_crane 60) 1)
	(set s_music_crane 1)

)

(script dormant f_crane_md_control

	(f_abort_md)

	; LINEAR
	; ---------------
	(sleep_until (>= objcon_crane 20) 1)
	(md_crane_intro)

	(sleep_until (>= objcon_crane 30) 1)
	(md_crane_combat)

	(sleep_until (>= objcon_crane 40) 1)
	(md_crane_phantom)

	(sleep_until
		(or
			(>= objcon_crane 50)
			(<= (ai_task_count obj_crane_cov/gate_interior) 1)
		)
	1)

	(sleep_until (>= objcon_crane 50) 1 (* 30 120))
	(if (not (>= objcon_crane 50))
		(begin
			(md_crane_room_delay_0)
		)
	)

	(sleep_until
		(or
			(>= objcon_crane 80)
			(and
				(<= (ai_task_count obj_crane_cov/gate_hunter) 0)
				(<= (ai_task_count obj_crane_cov/gate_skirmisher) 0)
			)
		)
	1)

	(sleep_until (>= objcon_crane 80) 1 (* 30 60))
	(if (not (>= objcon_crane 80))
		(begin
			(md_crane_outside_delay_0)
		)
	)

)

(script dormant f_crane_spawn_control
	(dprint "::: spawning all smelter squads")

	(ai_place gr_crane_cov_init)
	(ai_place gr_crane_hum_init)

	(sleep_until (>= objcon_crane 55))
	(ai_place gr_crane_cov_hunters)
	(ai_place sq_crane_skirmishers_1)
	(ai_place sq_crane_skirmishers_2)
	(tick)
	(ai_place sq_catwalk_marine_entry)

)

; PHANTOM
;============================================
(script dormant f_crane_phantom

	(sleep_until (>= objcon_crane 30))
	(ai_place sq_crane_phantom)

)

(global vehicle v_crane_phantom none)
(global boolean b_crane_phantom_drop FALSE)

(script command_script f_cs_crane_phantom

	(dprint "phantom crane")

	(wake f_crane_phantom_spawn_control)

	(set v_crane_phantom (ai_vehicle_get_from_starting_location sq_crane_phantom/driver_01))

	(f_load_phantom ai_current_squad "left" NONE NONE sq_crane_cov_backup NONE)
	;(f_load_phantom ai_current_squad "chute" sq_crane_hunter NONE NONE NONE)
	(set b_crane_hunters_active TRUE)

	; spawning
	;--------------------------------------------
	;(ai_place sq_crane_phantom_hunter)
	(ai_force_active gr_crane_cov_phantom TRUE)
	(sleep 5)
			
	; seating
	;--------------------------------------------	
	;(ai_vehicle_enter_immediate sq_crane_phantom_hunter v_crane_phantom "phantom_p_mr_f")
	;(sleep 1)

	; enter
	;--------------------------------------------
	(cs_fly_by ps_crane_phantom/approach_01)
	(cs_fly_by ps_crane_phantom/approach_02)

	; hover_02
	;--------------------------------------------
	(cs_fly_to_and_face ps_crane_phantom/hover_02 ps_crane_phantom/hover_02_face 1)
	(sleep 15)
	
	; drop_02
	;--------------------------------------------	
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_crane_phantom/drop_02 ps_crane_phantom/hover_02_face 1)


	(f_unload_phantom ai_current_squad "left")

	(sleep 150)

	; hover_03
	;--------------------------------------------
	(cs_fly_to_and_face ps_crane_phantom/hover_03 ps_crane_phantom/hover_03_face 1)
	(sleep 150)

	(f_unload_phantom ai_current_squad "chute")
	
	; == exit ====================================================
	(cs_fly_to_and_face ps_crane_phantom/hover_04 ps_crane_phantom/hover_04_face 1)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_crane_phantom/exit_01)
	(cs_fly_by ps_crane_phantom/exit_02)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
	(cs_fly_by ps_crane_phantom/erase)
	(ai_erase ai_current_squad)
	
)

(script dormant f_crane_phantom_spawn_control

	(sleep_until (volume_test_players tv_crane_phantom_exit) 5)
	(dprint "phantom can exit")
	(set b_crane_phantom_drop TRUE)

)

(global boolean b_crane_catwalk_entry FALSE)
(script dormant f_crane_catwalk_entry

	(sleep_until (> (ai_living_count gr_crane_cov_hunters) 0))
	(sleep_until (and (<= (ai_living_count gr_crane_cov_hunters) 0) (<= (ai_living_count sq_crane_skirmishers_1) 0) (<= (ai_living_count sq_crane_skirmishers_2) 0) ) 5)
	(device_set_power dm_catwalk_door_entry 1)
	(device_set_position dm_catwalk_door_entry .99)
	(set s_music_crane 2)

)

(script dormant f_crane_cleanup_control

	(sleep_until (volume_test_players tv_crane_cleanup) 5)
	(f_crane_despawn_all)
	(f_crane_kill_scripts)

)

(script static void f_crane_despawn_all
	(dprint "::: despawning all smelter squads")

	(ai_place gr_crane_cov)
	(ai_place gr_crane_hum)

)

(script static void f_crane_kill_scripts

	(sleep_forever f_crane_objective_control)
	(sleep_forever f_crane_zoneset_door)
	(sleep_forever f_crane_combat_refresh)
	(sleep_forever f_crane_waypoint_control)
	(sleep_forever f_crane_save_control)
	(sleep_forever f_crane_save_combatend)
	(sleep_forever f_crane_emile_control)
	(sleep_forever f_crane_music_control)
	(sleep_forever f_crane_md_control)
	(sleep_forever f_crane_spawn_control)
	(sleep_forever f_crane_phantom)
	(sleep_forever f_crane_phantom_spawn_control)
	(sleep_forever f_crane_catwalk_entry)
	(ai_dialogue_enable TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)

)

; =================================================================================================
; =================================================================================================
; CATWALK
; =================================================================================================
; =================================================================================================

(script dormant f_catwalk_objective_control
	(dprint "::: catwalk encounter :::")
	
	; Wait until the zone is loaded
	;(sleep_until
		;(or
			;(= (current_zone_set_fully_active) 1)
			;(= (current_zone_set_fully_active) 2)))

	(set b_catwalk_ready TRUE)
	
	; Standard Scripts
	(wake f_catwalk_save_control)
	(wake f_catwalk_waypoint_control)
	(wake f_catwalk_spawn_control)
	(wake f_catwalk_md_control)
	(wake f_catwalk_music_control)
	(wake f_catwalk_cleanup_control)
	(wake f_catwalk_emile_control)
	
	; Encounter Scripts
	(wake f_catwalk_cov_stairs)
	(wake f_catwalk_zoneset_door)
	(wake f_catwalk_bomb)

	(dprint "objective control : catwalk.1")
	(set objcon_catwalk 1)

	(set b_insertion_fade_in TRUE)

	(sleep_until (volume_test_players tv_catwalk_10) 5)
	(dprint "objective control : catwalk.10")
	(set objcon_catwalk 10)

	(sleep_until (volume_test_players tv_catwalk_20) 5)
	(dprint "objective control : catwalk.20")
	(set objcon_catwalk 20)

	(sleep_until (volume_test_players tv_catwalk_30) 5)
	(dprint "objective control : catwalk.30")
	(set objcon_catwalk 30)

	(sleep_until (volume_test_players tv_catwalk_35) 5)
	(dprint "objective control : catwalk.35")
	(set objcon_catwalk 35)

	(sleep_until (volume_test_players tv_catwalk_40) 5)
	(dprint "objective control : catwalk.40")
	(set objcon_catwalk 40)

	(sleep_until (volume_test_players tv_catwalk_50) 5)
	(dprint "objective control : catwalk.50")
	(set objcon_catwalk 50)

	(sleep_until (volume_test_players tv_catwalk_60) 5)
	(dprint "objective control : catwalk.60")
	(set objcon_catwalk 60)

	(sleep_until (volume_test_players tv_catwalk_70) 5)
	(dprint "objective control : catwalk.70")
	(set objcon_catwalk 70)

	(sleep_until (volume_test_players tv_catwalk_80) 5)
	(dprint "objective control : catwalk.80")
	(set objcon_catwalk 80)

)

(script dormant f_catwalk_music_control

	(wake music_catwalk)

	(sleep_until (>= objcon_catwalk 10))
	(set s_music_catwalk 1)

)

(script dormant f_catwalk_bomb

	(sleep_until (>= objcon_catwalk 70) 1)
	(set b_shake TRUE)
	(sleep 60)
	(interpolator_start base_bombing)
	(sound_impulse_start sound\levels\020_base\base_scripted_expl2 NONE 1)

)

(script dormant f_catwalk_zoneset_door

	(sleep_until (>= objcon_catwalk 80) 1)
	(device_set_power #_m70_door_small_06 1)
	(device_set_position #_m70_door_small_06 0)
	(device_operates_automatically_set #_m70_door_small_06 FALSE)
	(sleep_until (= (device_get_position #_m70_door_small_06) 0) 1)
	(device_set_power #_m70_door_small_06 0)

	; Coop Teleport Failsafe
	(if (game_is_cooperative)
		(begin
			(if
				(not
					(or
						(volume_test_object tv_area_hall_2 player0)
						(volume_test_object tv_area_platform player0)
					)
				)
				(begin
					(object_teleport_to_ai_point player0 ps_platform_hall_spawn/player0)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_hall_2 player1)
						(volume_test_object tv_area_platform player1)
					)
				)
				(begin
					(object_teleport_to_ai_point player1 ps_platform_hall_spawn/player1)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_hall_2 player2)
						(volume_test_object tv_area_platform player2)
					)
				)
				(begin
					(object_teleport_to_ai_point player2 ps_platform_hall_spawn/player2)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_hall_2 player3)
						(volume_test_object tv_area_platform player3)
					)
				)
				(begin
					(object_teleport_to_ai_point player3 ps_platform_hall_spawn/player3)
				)
			)
		)
	)

	(zone_set_trigger_volume_enable begin_zone_set:set_final_0 TRUE)

)

(script dormant f_catwalk_save_control

	(wake f_catwalk_save_combatend)

	(sleep_until (>= objcon_catwalk 10) 5)
	(game_save_no_timeout)

)

(script dormant f_catwalk_save_combatend

	(branch (>= objcon_platform 0) (f_abort))

	(sleep_until (<= (ai_living_count gr_catwalk_cov) 0))
	(game_save_no_timeout)

)

(global short s_catwalk_waypoint_timer 180)
(script dormant f_catwalk_waypoint_control

	(sleep_until (>= objcon_catwalk 10) 5)
	(sleep_until (>= objcon_catwalk 70) 5 (* 30 s_catwalk_waypoint_timer))
	(if (not (>= objcon_catwalk 70))
		(begin
			(f_blip_flag fl_catwalk_waypoint_1 blip_destination)
			(sleep_until (>= objcon_catwalk 70) 5)
			(f_unblip_flag fl_catwalk_waypoint_1)
		)
	)

)

(script dormant f_catwalk_emile_control

	(sleep_until
		(and
			(volume_test_object tv_area_catwalk o_emile)
			(volume_test_players tv_area_catwalk)
		)
	)
	(ai_set_objective sq_emile obj_catwalk_hum)
	(sleep 10)
	(ai_vehicle_exit sq_emile)
	(cs_run_command_script sq_emile f_cs_abort)

)

(script dormant f_catwalk_md_control

	(f_abort_md)

	; CONDITIONAL
	; ---------------

	; LINEAR
	; ---------------

	; low delay
	(sleep_until (>= objcon_catwalk 40) 1 (* 30 120))
	(if (not (>= objcon_catwalk 40))
		(begin
			(md_catwalk_floor_delay_0)
		)
	)

	(sleep_until (>= objcon_catwalk 40) 1 (* 30 60))
	(if (not (>= objcon_catwalk 40))
		(begin
			(md_catwalk_floor_delay_1)
		)
	)

	(sleep_until (>= objcon_catwalk 40) 1 (* 30 60))
	(if (not (>= objcon_catwalk 40))
		(begin
			(md_catwalk_floor_delay_2)
		)
	)

	; top delay
	(sleep_until (>= objcon_catwalk 80) 1 (* 30 90))
	(if (not (>= objcon_catwalk 80))
		(begin
			(md_catwalk_top_delay_0)
		)
	)

	(sleep_until (>= objcon_catwalk 80) 1)
	(md_catwalk_exit)

)

(global boolean b_catwalk_cov_stairs FALSE)
(script dormant f_catwalk_cov_stairs

	(sleep_until (objects_can_see_object (players) sq_catwalk_cov_platform 15) 5)
	(set b_catwalk_cov_stairs TRUE)

)

(script dormant f_catwalk_spawn_control

	(dprint "::: spawning all catwalk squads")

	(ai_place gr_catwalk_cov_init)
	(ai_place gr_catwalk_hum_init)
	(tick)
	(ai_braindead sq_catwalk_cov_elite TRUE)

	(sleep_until (>= objcon_catwalk 30) 1)
	(ai_braindead sq_catwalk_cov_elite FALSE)

	(sleep_until (>= objcon_catwalk 40) 1)
	(device_set_power #_m70_door_small_06 1)
	(ai_place sq_catwalk_cov_exit)
	(ai_place sq_catwalk_cov_exit_elites)

)

(script static void f_catwalk_despawn_all

	(ai_erase gr_catwalk_cov)
	(ai_erase gr_catwalk_hum)


)

(script dormant f_catwalk_cleanup_control

	(sleep_until (volume_test_players tv_catwalk_cleanup) 1)
	(f_catwalk_despawn_all)
	(f_catwalk_kill_scripts)

)

(script static void f_catwalk_kill_scripts

	(sleep_forever f_catwalk_objective_control)
	(sleep_forever f_catwalk_zoneset_door)
	(sleep_forever f_catwalk_save_control)
	(sleep_forever f_catwalk_save_combatend)
	(sleep_forever f_catwalk_waypoint_control)
	(sleep_forever f_catwalk_emile_control)
	(sleep_forever f_catwalk_md_control)
	(sleep_forever f_catwalk_cov_stairs)
	(sleep_forever f_catwalk_spawn_control)
	(sleep_forever f_catwalk_bomb)
	(ai_dialogue_enable TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)

)

; =================================================================================================
; =================================================================================================
; PLATFORM
; =================================================================================================
; =================================================================================================

(global short s_platform_wave 0)
(global boolean b_platform_defended FALSE)
(script dormant f_platform_objective_control
	(dprint "::: platform encounter :::")
	; set seventh mission segment
	(data_mine_set_mission_segment "m70_07_platform")
	(set b_platform_ready TRUE)
	
	; Standard Scripts		
	(wake f_platform_missionobj_control)	
	(wake f_platform_title_control)	
	(wake f_platform_spawn_control)
	(wake f_platform_music_control)
	(wake f_platform_md_control)
	(wake f_platform_save_control)
	(wake f_platform_cleanup_control)

	; Encounter Scripts	
	(wake f_platform_cannon_init)
	(wake f_platform_emile_control)
	(wake f_platform_finalbattle_control)
	(wake f_platform_zoneset_door)
	(wake f_platform_pillar)

	(dprint "objective control : platform.01")
	(if (not (> objcon_platform 1)) (set objcon_platform 1) )

	(set b_insertion_fade_in TRUE)
	(game_insertion_point_unlock 4)
	(f_loadout_set "platform")

	(sleep_until (or (volume_test_players tv_platform_05) (> objcon_platform 5) ) 1)
	(dprint "objective control : platform.05")
	(if (not (> objcon_platform 5)) (set objcon_platform 5) )
	
	(sleep_until (or (volume_test_players tv_platform_10) (> objcon_platform 10) ) 1)
	(dprint "objective control : platform.10")
	(if (not (> objcon_platform 10)) (set objcon_platform 10) )

	(sleep_until (or (volume_test_players tv_platform_20) (> objcon_platform 20) ) 1)
	(dprint "objective control : platform.20")
	(if (not (> objcon_platform 20)) (set objcon_platform 20) )

	(sleep_until (or (volume_test_players tv_platform_25) (> objcon_platform 25) ) 1)
	(dprint "objective control : platform.25")
	(if (not (> objcon_platform 25)) (set objcon_platform 25) )

	(sleep_until (or (volume_test_players tv_platform_30) (> objcon_platform 30) ) 1)
	(dprint "objective control : platform.30")
	(if (not (> objcon_platform 30)) (set objcon_platform 30) )

	(sleep_until (or (volume_test_players tv_platform_40) (> objcon_platform 40) ) 1)
	(dprint "objective control : platform.40")
	(if (not (> objcon_platform 40)) (set objcon_platform 40) )

	(dprint "objective control : platform.50")
	(set objcon_platform 50)

	(sleep_until (>= s_platform_wave 1))
	(dprint "objective control : platform.60")
	(set objcon_platform 60)

	(sleep_until (>= s_platform_wave 2))
	(dprint "objective control : platform.70")
	(set objcon_platform 70)

	(sleep_until b_platform_defended)
	(dprint "objective control : platform.90")
	(set objcon_platform 90)

)


(script dormant f_platform_pillar

	(sleep_until
		(or 
			(>= objcon_platform 40)
			b_test_finalbattle
		)	
	1)

	(if (not (game_is_cooperative) ) (begin

		(ai_place sq_pillar_guns)
		(ai_cannot_die sq_pillar_guns TRUE)
	
		(tick)
	
		(ai_vehicle_enter_immediate sq_pillar_guns/gun_01 (object_get_turret sc_poa 0) "")
		(ai_vehicle_enter_immediate sq_pillar_guns/gun_02 (object_get_turret sc_poa 1) "")
		(ai_vehicle_enter_immediate sq_pillar_guns/gun_03 (object_get_turret sc_poa 2) "")
		(ai_vehicle_enter_immediate sq_pillar_guns/gun_04 (object_get_turret sc_poa 3) "")
	
		(ai_force_active sq_pillar_guns TRUE)
		(ai_set_targeting_group sq_pillar_guns 76)
		(ai_prefer_target_ai sq_pillar_guns gr_pillar_cov_air TRUE)
		(ai_set_clump sq_pillar_guns 8888)
		(ai_disregard (ai_actors sq_pillar_guns) TRUE)

	))

)


(script command_script f_cs_platform_pillar_turret_1

	(sleep_until
		(begin
			(cs_shoot_point TRUE ps_platform_pillar/p0)
			(sleep 400)
			(cs_shoot_point TRUE ps_platform_pillar/p1)
			(sleep 400)
			(cs_shoot_point TRUE ps_platform_pillar/p2)
			(sleep 400)
			(cs_shoot_point TRUE ps_platform_pillar/p3)
			(sleep 400)
			FALSE
		)
	)

)

(script command_script f_cs_platform_pillar_turret_2

	(sleep_until
		(begin
			(cs_shoot_point TRUE ps_platform_pillar/p0)
			(sleep 400)
			(cs_shoot_point TRUE ps_platform_pillar/p1)
			(sleep 400)
			(cs_shoot_point TRUE ps_platform_pillar/p2)
			(sleep 400)
			(cs_shoot_point TRUE ps_platform_pillar/p3)
			(sleep 400)
			FALSE
		)
	)

)


(script command_script f_cs_platform_pillar_turret_3

	(sleep_until
		(begin
			(cs_shoot_point TRUE ps_platform_pillar/p0)
			(sleep 400)
			(cs_shoot_point TRUE ps_platform_pillar/p1)
			(sleep 400)
			(cs_shoot_point TRUE ps_platform_pillar/p2)
			(sleep 400)
			(cs_shoot_point TRUE ps_platform_pillar/p3)
			(sleep 400)
			FALSE
		)
	)

)


(script command_script f_cs_platform_pillar_turret_4

	(sleep_until
		(begin
			(cs_shoot_point TRUE ps_platform_pillar/p0)
			(sleep 400)
			(cs_shoot_point TRUE ps_platform_pillar/p1)
			(sleep 400)
			(cs_shoot_point TRUE ps_platform_pillar/p2)
			(sleep 400)
			(cs_shoot_point TRUE ps_platform_pillar/p3)
			(sleep 400)
			FALSE
		)
	)

)

(script dormant f_platform_zoneset_door

	(sleep_until (or (volume_test_players tv_area_platform_low)(volume_test_players tv_area_platform_low_2) ) 1 )

	(device_set_power dm_platform_door 1)
	(device_operates_automatically_set dm_platform_door FALSE)
	(device_set_position dm_platform_door 0)
	(sleep_until (= (device_get_position dm_platform_door) 0) 1)

	(print "preparing switch")
	(device_set_power dm_platform_door 0)

	(wake f_platfom_emile_split)
	
	(sleep 10)
	
	; Coop Teleport Failsafe
	(if (game_is_cooperative)
		(begin
			(if
				(not
					(or
						(volume_test_object tv_area_zealot player0)
						(volume_test_object tv_area_platform player0)
					)
				)
				(begin
					(object_teleport_to_ai_point player0 ps_platform_door_spawn/player0)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_zealot player1)
						(volume_test_object tv_area_platform player1)
					)
				)
				(begin
					(object_teleport_to_ai_point player1 ps_platform_door_spawn/player1)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_zealot player2)
						(volume_test_object tv_area_platform player2)
					)
				)
				(begin
					(object_teleport_to_ai_point player2 ps_platform_door_spawn/player2)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_zealot player3)
						(volume_test_object tv_area_platform player3)
					)
				)
				(begin
					(object_teleport_to_ai_point player3 ps_platform_door_spawn/player3)
				)
			)
		)
	)


	(zone_set_trigger_volume_enable begin_zone_set:set_final_1 TRUE)
	(sleep (* 30 5))
	(zone_set_trigger_volume_enable zone_set:set_final_1 TRUE)

)

(global boolean b_platform_emile_split_done FALSE)
(global boolean b_platform_emile_in_gun FALSE)
(script dormant f_platfom_emile_split

	(object_teleport_to_ai_point o_emile ps_platform_emile/mac)
	(sleep_forever f_emile_blip_kill)
	(f_unblip_ai ai_emile)
	(set b_platform_emile_split_done TRUE)
	(sleep (* 30 15))
	(dprint "emile entering gun")	
	(set b_platform_emile_in_gun TRUE)
	(ai_vehicle_enter_immediate ai_emile (ai_vehicle_get_from_starting_location sq_cannon_mac/clean) "mac_d")
	(ai_force_active ai_emile TRUE)
	(ai_set_targeting_group ai_emile 76)
	(ai_set_clump ai_emile 7777)
	(ai_designer_clump_targeting_group 76)
	(ai_prefer_target_ai sq_emile gr_pillar_cov_air TRUE)
	(dprint "emile in gun")	
	(md_platform_emilegun)

)


(script dormant f_platform_missionobj_control

	(if b_ins_platform
		(begin
			(mo_wall)
		)
	)

	(sleep_until (>= objcon_platform 50) 5)
	(sleep 220)
	(mo_platform)

)

(script dormant f_platform_title_control

	(sleep_until (>= objcon_platform 50) 5)
	(tit_platform)

)

(script dormant f_platform_save_control

	(sleep_until (>= objcon_platform 30) 1)
	(game_save_no_timeout)

	(sleep_until (>= objcon_platform 50) 5)
	(game_save_immediate)

	(sleep_until (>= objcon_platform 60) 5)
	(game_save_no_timeout)

	(sleep_until (>= objcon_platform 70) 5)
	(game_save_no_timeout)

	(sleep_until (>= objcon_platform 90) 5)
	(game_save_no_timeout)

)

(script dormant f_platform_cannon_init

	(sleep_until
		(or
			(>= objcon_platform 20)
			(> objcon_zealot 0)
			(> objcon_cannon 0)
			b_test_cruiser
		)
	1)
	(ai_place sq_cannon_mac/clean)

)

(script dormant f_platform_emile_control

	(sleep_until
		(and
			(volume_test_object tv_area_hall_2 o_emile)
			(volume_test_players tv_area_hall_2)
		)
	)
	(ai_set_objective sq_emile obj_platform_hum)
	(sleep 10)
	(ai_vehicle_exit sq_emile)
	(cs_run_command_script sq_emile f_cs_abort)

)

(script dormant f_platform_md_control

	(f_abort_md)

	(sleep_until (>= objcon_platform 30) 1)
	(f_abort_md)
	(md_platform_intro)

	(sleep_until (>= objcon_platform 50) 1)
	(sleep_until (>= objcon_platform 60) 1 (* 30 180))
	(if (not (>= objcon_platform 60))
		(begin
			(md_platform_wave_0_delay_0)
		)
	)

	(sleep_until (>= objcon_platform 60) 1)
	(md_platform_wave_1)

	; wave 1 delay
	(sleep_until (>= objcon_platform 70) 1 (* 30 180))
	(if (not (>= objcon_platform 70))
		(begin
			(md_platform_wave_1_delay_0)
		)
	)

	; wave 2
	(sleep_until (>= objcon_platform 70) 1)
	(sleep (* 30 5))
	(md_platform_wave_2)

	; wave 2 delay
	(sleep_until (>= objcon_platform 90) 1 (* 30 180))
	(if (not (>= objcon_platform 90))
		(begin
			(if (> (ai_living_count obj_platform_hum ) 0)
				(md_platform_wave_2_delay_0_marine)
				(md_platform_wave_2_delay_0)
			)
		)
	)

	; combat done
	(sleep_until (>= objcon_platform 90) 1)
	(sleep (* 30 5))
	(md_platform_done)

	(sleep (* 30 10))
	(md_platform_keyesenter)

)

(script dormant f_platform_finalbattle_control

	(if (not b_ins_platform_2) (begin

		(sleep_until
			(or
				(>= objcon_platform 10)
				b_test_finalbattle
			)
		)
		
		(flock_create "flc_pillar_warthog_01")
		(flock_create "flc_pillar_scorpion_01")
		(flock_create "flc_pillar_wraith_01")
		(flock_create "flc_pillar_ghost_01")
		(flock_create "flc_pillar_phantom_01")
		(flock_create "flc_pillar_banshee_01")
		(flock_create "flc_pillar_falcon_01")
		
		(sleep_until
			(or
				(>= objcon_platform 40)
				b_test_finalbattle
			)
		)
	
		(sleep (* 30 1))
		(wake f_platform_banshee_spawn)
		(wake f_platform_phantom_spawn)
	
		(sleep (* 30 20))
		(wake f_platform_scarab_1)
		(wake f_platform_scarab_2)

	))

)

(script static void f_platform_flock_delete

	(flock_delete "flc_pillar_phantom_01")
	(flock_delete "flc_pillar_banshee_01")
	(flock_delete "flc_pillar_falcon_01")

)

(global short s_platform_scarab_1_loops 15)
(global short s_platform_scarab_1_loop_idx 0)
(global short s_platform_scarab_1_drop_time 6)
(global short s_platform_scarab_1_idwlk_time 6)
(global short s_platform_scarab_1_walk_time 6)
(global short s_platform_scarab_1_wlkid_time 6)
(script dormant f_platform_scarab_1

	(object_create dm_platform_scarab_1)
	(device_set_power dm_platform_scarab_1 1)

	(device_set_position_track dm_platform_scarab_1 "device:scarab_drop" 0)
 	(print "init anim start")	
  (device_animate_position dm_platform_scarab_1 1 s_platform_scarab_1_drop_time 0.034 0.034 false)
	(sleep (- (* s_platform_scarab_1_drop_time 30) 2) )

	(device_set_position_track dm_platform_scarab_1 "device:idle_2_move_front" 0)
 	(print "init anim start")	
  (device_animate_position dm_platform_scarab_1 1 s_platform_scarab_1_idwlk_time 0.034 0.034 false)
	(sleep (- (* s_platform_scarab_1_idwlk_time 30) 2) )

	(sleep_until
		(begin
			(device_set_position_track dm_platform_scarab_1 "device:move_front" 0)	
  		(device_animate_position dm_platform_scarab_1 1 s_platform_scarab_1_walk_time 0.034 0.034 FALSE)
			(set s_platform_scarab_1_loop_idx (+ s_platform_scarab_1_loop_idx 1))
			(sleep (- (* s_platform_scarab_1_walk_time 30) 2) )
			(>= s_platform_scarab_1_loop_idx s_platform_scarab_1_loops)
		)
	1)

	(device_set_position_track dm_platform_scarab_1 "device:move_front_2_idle" 0)
 	(print "init anim start")	
  (device_animate_position dm_platform_scarab_1 1 s_platform_scarab_1_wlkid_time 0.034 0.034 false)
	(sleep (- (* s_platform_scarab_1_wlkid_time 30) 2) )

  (sleep_until
    (begin
	    (device_set_position_track dm_platform_scarab_1 stationary_march 0)
	    (device_animate_position dm_platform_scarab_1 1.0 (random_range 7 10) 1.0 1.0 TRUE)
	    (sleep_until (>= (device_get_position dm_platform_scarab_1) 1) 1)
	    (sleep (random_range 0 20))
    0)
  )

)

(global short s_platform_scarab_2_loops 15)
(global short s_platform_scarab_2_loop_idx 0)
(global short s_platform_scarab_2_drop_time 6)
(global short s_platform_scarab_2_idwlk_time 6)
(global short s_platform_scarab_2_walk_time 6)
(global short s_platform_scarab_2_wlkid_time 6)
(script dormant f_platform_scarab_2

	(sleep 35)

	(object_create dm_platform_scarab_2)
	(device_set_power dm_platform_scarab_2 1)

	(device_set_position_track dm_platform_scarab_2 "device:scarab_drop" 0)
 	(print "init anim start")	
  (device_animate_position dm_platform_scarab_2 1 s_platform_scarab_2_drop_time 0.034 0.034 false)
	(sleep (- (* s_platform_scarab_2_drop_time 30) 2) )

	(device_set_position_track dm_platform_scarab_2 "device:idle_2_move_front" 0)
 	(print "init anim start")	
  (device_animate_position dm_platform_scarab_2 1 s_platform_scarab_2_idwlk_time 0.034 0.034 false)
	(sleep (- (* s_platform_scarab_2_idwlk_time 30) 2) )

	(sleep_until
		(begin
			(device_set_position_track dm_platform_scarab_2 "device:move_front" 0)	
  		(device_animate_position dm_platform_scarab_2 1 s_platform_scarab_2_walk_time 0.034 0.034 FALSE)
			(set s_platform_scarab_2_loop_idx (+ s_platform_scarab_2_loop_idx 1))
			(sleep (- (* s_platform_scarab_2_walk_time 30) 2) )
			(>= s_platform_scarab_2_loop_idx s_platform_scarab_2_loops)
		)
	1)

	(device_set_position_track dm_platform_scarab_2 "device:move_front_2_idle" 0)
 	(print "init anim start")	
  (device_animate_position dm_platform_scarab_2 1 s_platform_scarab_2_wlkid_time 0.034 0.034 false)
	(sleep (- (* s_platform_scarab_2_wlkid_time 30) 2) )

  (sleep_until
    (begin
	    (device_set_position_track dm_platform_scarab_2 stationary_march 0)
	    (device_animate_position dm_platform_scarab_2 1.0 (random_range 7 10) 1.0 1.0 TRUE)
	    (sleep_until (>= (device_get_position dm_platform_scarab_2) 1) 1)
	    (sleep (random_range 0 20))
    0)
  )


)

(script static void f_platform_door_open

	(dprint "door opening")
	(device_operates_automatically_set #_m70_door_ff_01 FALSE)
	(device_set_power #_m70_door_ff_01 1)
	(device_set_position #_m70_door_ff_01 .9)


)

(script static void f_platform_door_close

	(dprint "door opening")
	(device_set_power #_m70_door_ff_01 1)
	(device_operates_automatically_set #_m70_door_ff_01 FALSE)
	(device_set_position #_m70_door_ff_01 1)
	(sleep_until (<= (device_get_position #_m70_door_ff_01) 0))
	(device_set_power #_m70_door_ff_01 0)

)

(script command_script f_cs_platform_emile_shoot

	(sleep_until
		(begin
			(cs_shoot_point TRUE ps_platform_mac/p0)
			(sleep 120)
			(cs_shoot_point FALSE ps_platform_mac/p0)
			(sleep 600)
			(cs_shoot_point TRUE ps_platform_mac/p1)
			(sleep 120)
			(cs_shoot_point FALSE ps_platform_mac/p1)
			(sleep 600)
			(cs_shoot_point TRUE ps_platform_mac/p2)
			(sleep 120)
			(cs_shoot_point FALSE ps_platform_mac/p2)
			(sleep 600)
			FALSE
		)
	1)

)

(script dormant f_platform_music_control

	(wake music_platform)
	(wake f_platform_hammer_death)
	(wake f_platform_plasma_death)

	(sleep_until (>= objcon_platform 25) 1)
	(set s_music_platform 1)
	(set s_music_bravo 2)

	(sleep_until (>= objcon_platform 70) 1)
	(set s_music_platform 4)

	(sleep_until (>= objcon_platform 80) 1)
	(set s_music_platform 5)

)

(script dormant f_platform_hammer_death

	(sleep_until (> (ai_living_count sq_platform_w1_4b) 0))
	(sleep_until (<= (ai_living_count sq_platform_w1_4b) 0))
	(set s_music_platform 4)

)

(script dormant f_platform_plasma_death

	(sleep_until (> (ai_living_count sq_platform_w2_3/main) 0))
	(sleep_until (<= (ai_living_count sq_platform_w2_3/main) 0))
	(set s_music_platform 5)

)

(script dormant f_platform_spawn_control
	(dprint "::: spawning all platform squads")

	(sleep 10)

	(if (< objcon_platform 40)
		(begin

			(if
				(not (game_is_cooperative))
				(begin
					(ai_place sq_platform_marine_w0_1)
				)
			)

			(ai_place sq_platform_marine_w0_2)
			(ai_place sq_platform_cov_interior)

		)
	)

	(sleep_until
		(begin
			(ai_renew sq_platform_marine_w0_1)
			(ai_renew sq_platform_marine_w0_2)
			(ai_renew sq_platform_cov_interior)
			(>= objcon_platform 5)
		)
	2)

	(sleep_until (>= objcon_platform 40) 1)

	(if b_ins_platform_2 (begin
		(ai_place sq_platform_marine_w0_1_ins)
		(ai_place sq_platform_marine_w0_2_ins)
	))

	(ai_place sq_platform_w0_0a)
	(ai_place sq_platform_w0_0b)

	(ai_place sq_platform_phantom_w0_1)
	(sleep (* 30 8))
	(ai_place sq_platform_phantom_w0_2)

	; Dropship 1
	(sleep_until
		(and
			(<= (ai_living_count gr_platform_cov) 2)
			(or
				(not b_platform_phantom_w0_1_spawn)
				(<= (object_get_health (ai_vehicle_get_from_squad sq_platform_phantom_w0_1 0) ) 0)
			)
			(or
				(not b_platform_phantom_w0_2_spawn)
				(<= (object_get_health (ai_vehicle_get_from_squad sq_platform_phantom_w0_2 0) ) 0)
			)
		)
	5)

	(ai_place sq_platform_phantom_w1_1)
	(ai_place sq_platform_phantom_w1_2)
	(sleep 90)
	(set s_platform_wave 1)
	(sleep 120)
	(ai_place sq_platform_pelican_drop)
	(sleep 30)
	(ai_reset_objective obj_platform_cov/gate_area)
	
	; Dropship 2
	(sleep_until
		(and
			(<= (ai_living_count gr_platform_cov) 2)
			(or
				(not b_platform_phantom_w1_1_spawn)
				(<= (object_get_health (ai_vehicle_get_from_squad sq_platform_phantom_w1_1 0) ) 0)
			)
			(or
				(not b_platform_phantom_w1_2_spawn)
				(<= (object_get_health (ai_vehicle_get_from_squad sq_platform_phantom_w1_2 0) ) 0)
			)
		)
	5)

	;*

	(if (<= (ai_living_count gr_platform_hum_marines) 1)
		(begin
			(ai_place sq_platform_pelican_drop)
		)
	)

	*;

	(ai_place sq_platform_phantom_w2_1)
	(ai_place sq_platform_phantom_w2_2)
	(set s_platform_wave 2)
	(wake f_platform_bezerk)

	(sleep 30)
	(ai_reset_objective obj_platform_cov/gate_area)
	

	; KEYES
	(sleep_until
		(and
			(or
				(not b_platform_phantom_w2_2_spawn)
				(<= (object_get_health (ai_vehicle_get_from_squad sq_platform_phantom_w2_1 0)) 0)
			)
			(or
				(not b_platform_phantom_w2_2_spawn)
				(<= (object_get_health (ai_vehicle_get_from_squad sq_platform_phantom_w2_2 0)) 0)
			)
		)
	5)

	(sleep_until
		(and
			(<= (ai_living_count gr_platform_cov) 3)
			(<= (ai_living_count sq_platform_w1_4b) 0)
			(<= (ai_living_count sq_platform_w1_4a) 0)
			(<= (ai_living_count sq_platform_w2_3/main) 0)
		)
	5)

	(wake f_platform_end_timer)
	(sleep_until
		(or
			(<= (ai_living_count gr_platform_cov) 2)
			(and
				(volume_test_players tv_platform_pad)
				b_platform_end_timer
			)
		)
	5)

	(set b_platform_defended TRUE)
	(ai_place sq_platform_pelican_keyes/enter)
	(ai_place sq_platform_pelican_keyes_1)
	(wake f_platform_keyes_handoff)

)

(global boolean b_platform_end_timer FALSE)
(script dormant f_platform_end_timer

	(sleep 450)
	(set b_platform_end_timer TRUE)

)

(global boolean b_platform_bezerk FALSE)
(script dormant f_platform_bezerk

	(sleep (* 30 480))
	(set b_platform_bezerk TRUE)

)

(script dormant f_platform_banshee_spawn

	(sleep_until
		(begin
		
		(if (<= (ai_living_count sq_pillar_banshee_1) 0)(ai_place sq_pillar_banshee_1)(sleep 30))
		(if (<= (ai_living_count sq_pillar_banshee_2) 0)(ai_place sq_pillar_banshee_2)(sleep 30))
		(if (<= (ai_living_count sq_pillar_banshee_3) 0)(ai_place sq_pillar_banshee_3)(sleep 30))
		(if (<= (ai_living_count sq_pillar_banshee_4) 0)(ai_place sq_pillar_banshee_4)(sleep 30))
		(if (<= (ai_living_count sq_pillar_banshee_5) 0)(ai_place sq_pillar_banshee_5)(sleep 30))
		
		(ai_set_targeting_group gr_pillar_cov_air 76)

		b_platform_defended)

	30)

)


(script dormant f_platform_phantom_spawn

	(sleep_until
		(begin
		
		(if (<= (ai_living_count sq_pillar_phantom_1) 0)
			(begin
				(ai_place sq_pillar_phantom_1)
				(sleep 30)
			)
		)
		(if (<= (ai_living_count sq_pillar_phantom_2) 0)
			(begin
				(ai_place sq_pillar_phantom_2)
				(sleep 30)
			)
		)
		
		(ai_set_targeting_group gr_pillar_cov_air 76)

		b_platform_defended)

	30)

)

(script command_script f_cs_vehicle_scale

	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(tick)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 10))

)

(global boolean b_platform_phantom_w0_1_spawn FALSE)
(script command_script f_cs_platform_phantom_w0_1

	(set b_platform_phantom_w0_1_spawn TRUE)

	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(f_load_phantom ai_current_squad "right" sq_platform_w0_2 sq_platform_w0_1 NONE NONE)
	(cs_fly_by ps_platform_phantom_w0_1/enter_01)
	(cs_fly_by ps_platform_phantom_w0_1/enter_02)
	(cs_vehicle_speed .5)	
	(cs_fly_to_and_face ps_platform_phantom_w0_1/hover_01 ps_platform_phantom_w0_1/hover_01_face .1)
	(sleep 1)
	(cs_fly_to_and_face ps_platform_phantom_w0_1/drop_01 ps_platform_phantom_w0_1/drop_01_face .1)
	(f_unload_phantom ai_current_squad "right")
	(sleep 30)
	(set b_platform_phantom_w0_1_spawn FALSE)
	(cs_fly_to_and_face ps_platform_phantom_w0_1/hover_01 ps_platform_phantom_w0_1/hover_01_face 1)
	(ai_set_targeting_group ai_current_squad 76)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_platform_phantom_w0_1/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_platform_phantom_w0_1/erase)
	(ai_erase ai_current_squad)

)

(global boolean b_platform_phantom_w0_2_spawn FALSE)
(script command_script f_cs_platform_phantom_w0_2

	(set b_platform_phantom_w0_2_spawn TRUE)

	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(f_load_phantom ai_current_squad "right" sq_platform_w0_3 sq_platform_w0_4 NONE NONE)
	(cs_fly_by ps_platform_phantom_w0_2/enter_01)
	(cs_fly_by ps_platform_phantom_w0_2/enter_02)
	(cs_vehicle_speed .5)	
	(cs_fly_to_and_face ps_platform_phantom_w0_2/hover_01 ps_platform_phantom_w0_2/hover_01_face .1)
	(sleep 1)
	(cs_fly_to_and_face ps_platform_phantom_w0_2/drop_01 ps_platform_phantom_w0_2/drop_01_face .1)
	(f_unload_phantom ai_current_squad "right")
	(sleep 30)
	(set b_platform_phantom_w0_2_spawn FALSE)
	(cs_fly_to_and_face ps_platform_phantom_w0_2/hover_01 ps_platform_phantom_w0_2/hover_01_face 1)
	(ai_set_targeting_group ai_current_squad 76)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_platform_phantom_w0_2/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_platform_phantom_w0_2/erase)
	(ai_erase ai_current_squad)

)


(global boolean b_platform_phantom_w1_1_spawn FALSE)
(script command_script f_cs_platform_phantom_w1_1

	(set b_platform_phantom_w1_1_spawn TRUE)

	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(f_load_phantom ai_current_squad "right" sq_platform_w1_1 sq_platform_w1_2 NONE NONE)
	(cs_fly_by ps_platform_phantom_w1_1/enter_01)
	(cs_fly_by ps_platform_phantom_w1_1/enter_02)
	(cs_fly_by ps_platform_phantom_w1_1/enter_03)
	(cs_vehicle_speed .5)	
	(cs_fly_to_and_face ps_platform_phantom_w1_1/hover_01 ps_platform_phantom_w1_1/hover_01_face .1)
	(sleep 1)
	(cs_fly_to_and_face ps_platform_phantom_w1_1/drop_01 ps_platform_phantom_w1_1/drop_01_face .1)
	(f_unload_phantom ai_current_squad "right")
	(sleep 30)
	(set b_platform_phantom_w1_1_spawn FALSE)
	(cs_fly_to_and_face ps_platform_phantom_w1_1/hover_01 ps_platform_phantom_w1_1/hover_01_face 1)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_platform_phantom_w1_1/exit_01)
	(ai_set_targeting_group ai_current_squad 76)
	(cs_fly_by ps_platform_phantom_w1_1/exit_02)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_platform_phantom_w1_1/erase)
	(ai_erase ai_current_squad)

)

(global boolean b_platform_phantom_w1_2_spawn FALSE)
(script command_script f_cs_platform_phantom_w1_2

	(set b_platform_phantom_w1_2_spawn TRUE)

	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(f_load_phantom ai_current_squad "left" sq_platform_w1_3 sq_platform_w1_4a sq_platform_w1_4b NONE)
	(cs_fly_by ps_platform_phantom_w1_2/enter_01)
	(cs_fly_by ps_platform_phantom_w1_2/enter_02)
	(cs_vehicle_speed .5)	
	(cs_fly_to_and_face ps_platform_phantom_w1_2/hover_01 ps_platform_phantom_w1_2/hover_01_face .1)
	(sleep 1)
	(cs_fly_to_and_face ps_platform_phantom_w1_2/drop_01 ps_platform_phantom_w1_2/drop_01_face .1)
	(f_unload_phantom ai_current_squad "left")
	(sleep 30)
	(set b_platform_phantom_w1_2_spawn FALSE)
	(cs_fly_to_and_face ps_platform_phantom_w1_2/hover_01 ps_platform_phantom_w1_2/hover_01_face 1)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_platform_phantom_w1_2/exit_01)
	(ai_set_targeting_group ai_current_squad 76)
	(cs_fly_by ps_platform_phantom_w1_2/exit_02)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_platform_phantom_w1_2/erase)
	(ai_erase ai_current_squad)

)

(global boolean b_platform_phantom_w2_1_spawn FALSE)
(script command_script f_cs_platform_phantom_w2_1

	(set b_platform_phantom_w2_1_spawn TRUE)

	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(f_load_phantom ai_current_squad "right" sq_platform_w2_1 sq_platform_w2_2 NONE NONE)
	(cs_fly_by ps_platform_phantom_w2_1/enter_01)
	(cs_fly_by ps_platform_phantom_w2_1/enter_02)
	(cs_vehicle_speed .5)	
	(cs_fly_to_and_face ps_platform_phantom_w2_1/hover_01 ps_platform_phantom_w2_1/hover_01_face .1)
	(sleep 1)
	(cs_fly_to_and_face ps_platform_phantom_w2_1/drop_01 ps_platform_phantom_w2_1/drop_01_face .1)
	(f_unload_phantom ai_current_squad "right")
	(sleep 30)
	(set b_platform_phantom_w2_1_spawn FALSE)
	(cs_fly_to_and_face ps_platform_phantom_w2_1/hover_01 ps_platform_phantom_w2_1/hover_01_face 1)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_platform_phantom_w2_1/exit_01)
	(ai_set_targeting_group ai_current_squad 76)
	(cs_fly_by ps_platform_phantom_w2_1/exit_02)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_platform_phantom_w2_1/erase)
	(ai_erase ai_current_squad)

)

(global boolean b_platform_phantom_w2_2_spawn FALSE)
(script command_script f_cs_platform_phantom_w2_2

	(set b_platform_phantom_w2_2_spawn TRUE)

	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(cs_fly_by ps_platform_phantom_w2_2/enter_01)
	(cs_fly_by ps_platform_phantom_w2_2/enter_02)
	(cs_vehicle_speed .5)	
	(cs_fly_to_and_face ps_platform_phantom_w2_2/hover_01 ps_platform_phantom_w2_2/hover_01_face .1)
	(sleep (* 30 1))
	(cs_fly_to_and_face ps_platform_phantom_w2_2/drop_01 ps_platform_phantom_w2_2/drop_01_face .1)
	(sleep (* 30 1))
	(ai_place sq_platform_w2_3)
	(ai_vehicle_enter_immediate sq_platform_w2_3 (ai_vehicle_get ai_current_actor) "phantom_pc")
	(vehicle_unload (ai_vehicle_get ai_current_actor) "phantom_pc")
	(sleep (* 30 3))
	(set b_platform_phantom_w2_2_spawn FALSE)
	(cs_fly_to_and_face ps_platform_phantom_w2_2/hover_01 ps_platform_phantom_w2_2/hover_01_face 1)
	(ai_set_targeting_group ai_current_squad 76)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_platform_phantom_w2_2/exit_01)
	(cs_fly_by ps_platform_phantom_w2_1/exit_02)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_platform_phantom_w2_2/erase)
	(ai_erase ai_current_squad)


)

(script command_script f_cs_platform_pelican_drop

	(object_cannot_die ai_current_actor TRUE)

	(if
		(game_is_cooperative)
		(begin
			(f_load_pelican ai_current_squad "dual" sq_platform_marine_drop_1 NONE)
		)
		(begin
			(f_load_pelican ai_current_squad "dual" sq_platform_marine_drop_1 sq_platform_marine_drop_2)
		)
	)


	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)

	; enter
	;--------------------------------------------
	(cs_fly_by ps_platform_pelican_drop/enter_01)
	(cs_fly_by ps_platform_pelican_drop/enter_02)
	(cs_fly_by ps_platform_pelican_drop/enter_03)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_platform_pelican_drop/hover_01 ps_platform_pelican_drop/hover_01_face 1)
	(cs_fly_to_and_face ps_platform_pelican_drop/drop_01 ps_platform_pelican_drop/drop_01_face 1)

	; unload
	;--------------------------------------------
	(f_unload_pelican_all ai_current_squad)
	
	(sleep 240)
	(unit_close ai_current_actor)

	; exit
	;--------------------------------------------
	(cs_fly_to_and_face ps_platform_pelican_drop/hover_01 ps_platform_pelican_drop/hover_01_face 1)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_platform_pelican_drop/exit_01)
	(cs_fly_by ps_platform_pelican_drop/erase)
	(ai_erase ai_current_squad)

)


(script command_script f_cs_platform_pelican_keyes_1

	(object_cannot_die ai_current_actor TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)

	; enter
	;--------------------------------------------
	(cs_fly_by ps_platform_pelican_keyes_1/enter_01)
	(cs_fly_by ps_platform_pelican_keyes_1/enter_02)
	(cs_fly_by ps_platform_pelican_keyes_1/enter_03)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_platform_pelican_keyes_1/hover_01 ps_platform_pelican_keyes_1/hover_01_face 1)

)


(global boolean b_platform_keyes_handoff FALSE)
(script dormant f_platform_keyes_handoff

	(sleep_until b_platform_keyes_landed 5)

	(sleep_until (volume_test_players tv_platform_keyes) 5)
	; set eighth mission segment
	(data_mine_set_mission_segment "m70_08_handoff")
	(set b_platform_keyes_handoff TRUE)

	(zone_set_trigger_volume_enable begin_zone_set:set_final_1 FALSE)
	(zone_set_trigger_volume_enable zone_set:set_final_1 FALSE)

	(cinematic_enter 070lb_delivery TRUE)
	(f_cin_delivery_prep)
  (f_play_cinematic_advanced 070lb_delivery set_package_cinematic set_final_2)
	(f_cin_delivery_finish)
  (cinematic_exit 070lb_delivery FALSE)

	(set b_cannon_ready TRUE)
	(set b_zealot_ready TRUE)

)

(script static void f_cin_delivery_prep

	(set b_cin_delivery_rain TRUE)
	(ai_erase sq_cannon_mac)
	(ai_erase sq_platform_pelican_keyes)
	(ai_erase sq_platform_pelican_keyes_1)
	(ai_erase gr_platform_hum)
	(ai_erase gr_platform_cov)

	(object_destroy_type_mask 2)

	(object_teleport_to_ai_point player0 ps_platform_cin/p0)
	(object_teleport_to_ai_point player1 ps_platform_cin/p1)
	(object_teleport_to_ai_point player2 ps_platform_cin/p2)
	(object_teleport_to_ai_point player3 ps_platform_cin/p3)

)

(script static void f_cin_delivery_finish

	(ai_place sq_cannon_mac/broken_glass)
	(ai_place sq_platform_pelican_keyes/exit)
	(ai_erase sq_emile)
	(f_package_destroy)

	(object_teleport_to_ai_point player0 ps_zealot_spawn/player0)
	(object_teleport_to_ai_point player1 ps_zealot_spawn/player1)
	(object_teleport_to_ai_point player2 ps_zealot_spawn/player2)
	(object_teleport_to_ai_point player3 ps_zealot_spawn/player3)

)

(global boolean b_platform_keyes_landed FALSE)
(script command_script f_cs_platform_pelican_keyes

	(object_cannot_die ai_current_actor TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(wake f_blip_keyes)
	(cs_fly_by ps_platform_pelican_keyes/enter_01 10)
	(cs_fly_by ps_platform_pelican_keyes/enter_02 10)
	(cs_fly_by ps_platform_pelican_keyes/enter_03 10)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_platform_pelican_keyes/hover_01 ps_platform_pelican_keyes/hover_01_face .25)
	(wake f_md_platform_keyesland)
	(set b_platform_keyes_landed TRUE)
	(cs_fly_to_and_face ps_platform_pelican_keyes/drop_01 ps_platform_pelican_keyes/drop_01_face .25)

)


(script command_script f_cs_platform_pelican_keyes_exit

	(object_cannot_die ai_current_actor TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_fly_by ps_platform_pelican_keyes/exit_01 1)
	(cs_fly_by ps_platform_pelican_keyes/exit_02 1)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
	(cs_fly_by ps_platform_pelican_keyes/erase 1)
	(ai_erase ai_current_squad)

)


(script dormant f_blip_keyes

	(f_blip_ai sq_platform_pelican_keyes/enter blip_destination)

)


(script dormant f_md_platform_keyesland

	(if (not (volume_test_players tv_platform_keyes)) (begin

		(md_platform_keyesland)

	))

)

(script dormant f_platform_cleanup_control

	(sleep_until b_platform_keyes_handoff)
	(f_platform_despawn_all)
	(f_platform_kill_scripts)

)


(script static void f_platform_despawn_all

	(ai_erase gr_platform_cov)
	(ai_erase gr_platform_hum)

)

(script static void f_platform_kill_scripts

	(sleep_forever f_platform_objective_control)
	(sleep_forever f_platform_zoneset_door)
	(sleep_forever f_platform_missionobj_control)
	(sleep_forever f_platform_title_control)
	(sleep_forever f_platform_save_control)
	(sleep_forever f_platform_cannon_init)
	(sleep_forever f_platform_emile_control)
	(sleep_forever f_platform_md_control)
	(sleep_forever f_platform_finalbattle_control)
	(sleep_forever f_platform_scarab_1)
	(sleep_forever f_platform_scarab_2)
	(sleep_forever f_platform_spawn_control)
	(sleep_forever f_platform_banshee_spawn)
	(sleep_forever f_platform_phantom_spawn)
	(ai_dialogue_enable TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)

)


; =================================================================================================
; =================================================================================================
; ZEALOT
; =================================================================================================
; =================================================================================================

(script dormant f_zealot_objective_control
	(dprint "::: zealot encounter :::")
	
	; Wait until the zone is loaded
	;(sleep_until
		;(or
			;(= (current_zone_set_fully_active) 1)
			;(= (current_zone_set_fully_active) 2)))

	(set b_zealot_ready TRUE)

	; Standard Scripts	
	(wake f_zealot_missionobj_control)
	(wake f_zealot_save_control)
	(wake f_zealot_hilite_control)
	(wake f_zealot_waypoint_control)
	(wake f_zealot_spawn_control)
	(wake f_zealot_music_control)
	(wake f_zealot_md_control)
	(wake f_zealot_cleanup_control)

	; Encounter Scripts	
	(wake f_zealot_elite_story_control)
	(wake f_zealot_cruiser)
	(wake f_zealot_door)
	(wake f_zealot_pillar_control)

	(dprint "objective control : zealot.1")
	(set objcon_zealot 1)

	(set b_insertion_fade_in TRUE)

	(sleep_until (volume_test_players tv_zealot_platform_mid) 5)
	(dprint "objective control : zealot.20")
	(set objcon_zealot 20)

	(sleep_until (volume_test_players tv_zealot_stair) 5)
	(dprint "objective control : zealot.25")
	(set objcon_zealot 25)

	(sleep_until (volume_test_players tv_zealot_door) 5)
	(dprint "objective control : zealot.27")
	(set objcon_zealot 27)

	(sleep_until (volume_test_players tv_zealot_int_step) 5)
	(dprint "objective control : zealot.30")
	(set objcon_zealot 30)

	(sleep_until (volume_test_players tv_zealot_ledge) 5)
	(dprint "objective control : zealot.40")
	(set objcon_zealot 40)

	(sleep_until (volume_test_players tv_zealot_step_near) 5)
	(dprint "objective control : zealot.45")
	(set objcon_zealot 45)

	(sleep_until (volume_test_players tv_zealot_step) 5)
	(dprint "objective control : zealot.50")
	(set objcon_zealot 50)

	(sleep_until (volume_test_players tv_zealot_end) 5)
	(dprint "objective control : zealot.90")
	(set objcon_zealot 90)
	
)

(script dormant f_zealot_pillar_control

	(sleep_until
		(begin
			(scenery_animation_start sc_poa objects\vehicles\human\unsc_fleet\unsc_halcyon_class_cruiser_poa\unsc_halcyon_class_cruiser_poa any:thruster)
		FALSE)
	(* 30 (random_range 10 20)))
	
)

(script dormant f_zealot_camointro

	(ai_set_active_camo sq_zealot_elite_ext_1 FALSE)

	(sleep_until (>= objcon_zealot 20) 5)

	(cs_force_combat_status sq_zealot_elite_ext_1 2)
	(ai_set_active_camo sq_zealot_elite_ext_1 TRUE)

)

(script dormant f_zealot_missionobj_control

	(sleep_until (>= objcon_zealot 1) 5)
	(mo_zealot)

)

(script dormant f_zealot_save_control

	(wake f_zealot_save_combatend)

	(sleep_until (>= objcon_zealot 1))
	(sleep (* 30 5))
	(game_save_no_timeout)

	(sleep_until (>= objcon_zealot 40))
	(game_save_no_timeout)

)

(script dormant f_zealot_save_combatend

	(branch (>= objcon_cannon 0) (f_abort))

	(sleep_until (<= (ai_living_count gr_zealot_cov) 0))
	(game_save_no_timeout)

)

(script dormant f_zealot_hilite_control

	(sleep_until
		(or
			(>= objcon_zealot 1)
			TRUE
		)
	5)
	
	(sleep 120)
	
	(sleep_until
		(or
			(objects_can_see_object player0 sc_zealot_hilite_mac_marker 25)
			(objects_can_see_object player1 sc_zealot_hilite_mac_marker 25)
			(objects_can_see_object player2 sc_zealot_hilite_mac_marker 25)
			(objects_can_see_object player3 sc_zealot_hilite_mac_marker 25)
		)
	1)

	(f_hud_flash_object sc_zealot_hilite_mac)
	(object_destroy sc_zealot_hilite_mac)

)

(global short s_zealot_waypoint_timer_door 90)
(global short s_zealot_waypoint_timer_cannon 180)
(script dormant f_zealot_waypoint_control

	; Nonlinear

	; Linear
	(sleep_until (>= objcon_zealot 1))

	(sleep_until (>= objcon_zealot 27) 5 (* 30 s_zealot_waypoint_timer_door))
	(if (not (>= objcon_zealot 27))
		(begin
			(f_blip_flag fl_zealot_waypoint_1 blip_destination)
			(sleep_until (>= objcon_zealot 27) 5)
			(f_unblip_flag fl_zealot_waypoint_1)
		)
	)

	(sleep_until (>= objcon_cannon 10) 5 (* 30 s_zealot_waypoint_timer_cannon))
	(if (not (>= objcon_cannon 10))
		(begin
			(f_blip_flag fl_zealot_waypoint_2 blip_destination)
			(sleep_until (>= objcon_cannon 10) 5)
			(f_unblip_flag fl_zealot_waypoint_2)
		)
	)

)

(script dormant f_zealot_cruiser

	(set b_cruiser_moving TRUE)

	(object_create dm_cannon_cruiser)
	(object_cannot_take_damage dm_cannon_cruiser)
	(device_set_position_immediate dm_cannon_cruiser 0)

	(sleep_until (>= objcon_zealot 1))
	(wake f_zealot_cruiser_move)

)

(script dormant f_zealot_cruiser_move

	(print "cruiser move")

	(device_set_position_track dm_cannon_cruiser "device:position" 0)
	(device_animate_position dm_cannon_cruiser .2 0.0 1 1 TRUE)
	(device_animate_position dm_cannon_cruiser .4 90.0 1 1 TRUE)

)

(script dormant f_zealot_md_control

	(f_abort_md)

	(sleep_until b_zealot_ready 1)
	(sleep (* 30 5))
	(md_zealot_gotogun)

	(sleep_until (>= objcon_zealot 90) 1 (* 30 120) )
	(if (not (>= objcon_zealot 90))
		(begin
			(md_zealot_delay_0)
		)
	)

	(sleep_until (>= objcon_zealot 90) 1 (* 30 120) )
	(if (not (>= objcon_zealot 90))
		(begin
			(md_zealot_delay_1)
		)
	)

	(sleep_until (>= objcon_zealot 90) 1 (* 30 120) )
	(if (not (>= objcon_zealot 90))
		(begin
			(md_zealot_delay_2)
		)
	)

)

(script dormant f_zealot_elite_story_control

	(sleep 0)

)

(script dormant f_zealot_music_control

	(wake music_zealot)
	
	(sleep_until (>= objcon_zealot 27) 5)
	(wake f_zealot_elite_death)

)

(global short s_zealot_elites_alive 0)
(script dormant f_zealot_elite_death

	(sleep_until
		(begin
			(set s_zealot_elites_alive 0)
			(if (> (ai_living_count sq_zealot_elite_zealot) 0) (set s_zealot_elites_alive (+ s_zealot_elites_alive 1)) )
			(if (> (ai_living_count sq_zealot_elite_int_1) 0) (set s_zealot_elites_alive (+ s_zealot_elites_alive 1)) )
			(if (> (ai_living_count sq_zealot_elite_int_2) 0) (set s_zealot_elites_alive (+ s_zealot_elites_alive 1)) )
			(if (> (ai_living_count sq_zealot_elite_ext_1) 0) (set s_zealot_elites_alive (+ s_zealot_elites_alive 1)) )
		(= s_zealot_elites_alive 1))
	)
	(set s_music_zealot 2)

)

(script dormant f_zealot_spawn_control

	(ai_place gr_zealot_cov_init)

)

(script dormant f_zealot_door

	(device_set_power #_m70_door_ff_01 1)
	(device_operates_automatically_set #_m70_door_ff_01 1)
	(device_closes_automatically_set #_m70_door_ff_01 1)
	(sleep_until (>= objcon_zealot 27) 5)
	(device_set_position #_m70_door_ff_01 .9)
	(sleep_until (>= (device_get_position #_m70_door_ff_01) .9) 1)
	(device_set_power #_m70_door_ff_01 0)
	(device_operates_automatically_set #_m70_door_ff_01 0)
	(device_closes_automatically_set #_m70_door_ff_01 0)


)

(script command_script f_cs_zealot_phantom

	;(f_load_phantom ai_current_squad "right" sq_zealot_elite_1 sq_zealot_elite_2 sq_zealot_elite_3 NONE)

	; enter
	;--------------------------------------------
	(cs_fly_by ps_zealot_phantom/enter_01)
	(cs_fly_by ps_zealot_phantom/enter_02)
	(cs_fly_by ps_zealot_phantom/enter_03)
	(cs_fly_to_and_face ps_zealot_phantom/hover_01 ps_zealot_phantom/hover_01_face 1)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_zealot_phantom/drop_01 ps_zealot_phantom/drop_01_face 1)

	; unload
	;--------------------------------------------
	;(f_unload_phantom ai_current_squad "right")

	; exit
	;--------------------------------------------
	(cs_fly_to_and_face ps_zealot_phantom/hover_01 ps_zealot_phantom/hover_01_face 1)
	(cs_vehicle_speed 1.0)
	(cs_fly_by ps_zealot_phantom/exit_01)
	(cs_fly_by ps_zealot_phantom/erase)
	(ai_erase ai_current_squad)

)

(script command_script f_cs_combat_alert

	(dprint "alert!")
	(cs_force_combat_status ai_current_squad 3)
	
)

(script dormant f_zealot_cleanup_control

	(sleep_until (>= objcon_cannon 10) 1)
	(f_zealot_kill_scripts)
	;(f_zealot_despawn_all)

)

(script static void f_zealot_kill_scripts

	(sleep_forever f_zealot_objective_control)
	(sleep_forever f_zealot_camointro)
	(sleep_forever f_zealot_missionobj_control)
	;(sleep_forever f_zealot_save_control)
	;(sleep_forever f_zealot_save_combatend)
	(sleep_forever f_zealot_hilite_control)
	(sleep_forever f_zealot_waypoint_control)
	(sleep_forever f_zealot_cruiser)
	(sleep_forever f_zealot_cruiser_move)
	(sleep_forever f_zealot_md_control)
	(sleep_forever f_zealot_elite_story_control)
	(sleep_forever f_zealot_spawn_control)
	(sleep_forever f_zealot_door)
	(sleep_forever f_zealot_pillar_control)
	(ai_dialogue_enable TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)

)

; =================================================================================================
; =================================================================================================
; CANNON
; =================================================================================================
; =================================================================================================

(global boolean b_cruiser_kill FALSE)
(global boolean b_cruiser_vulnerable FALSE)
(global boolean b_cruiser_dead FALSE)
(global boolean b_cruiser_moving FALSE)

(script dormant f_cannon_objective_control
	(dprint "::: cannon encounter :::")

	; Standard Scripts
	(wake f_cannon_missionobj_control)
	(wake f_cannon_save_control)
	(wake f_cannon_spawn_control)
	(wake f_cannon_music_control)
	(wake f_cannon_md_control)
	(wake f_cannon_cleanup_control)

	; Encounter Scripts
	(wake f_cannon_cruiser)
	(wake f_train_mac)

	(dprint "objective control : cannon.1")
	(set objcon_cannon 1)
	(set b_insertion_fade_in TRUE)

	(sleep_forever f_save_continuous)

	(sleep_until (volume_test_players tv_cannon_10) 1)
	(dprint "objective control : cannon.10")
	(set objcon_cannon 10)

	(sleep_until b_cruiser_vulnerable 1)
	(dprint "objective control : cannon.20")
	(set objcon_cannon 20)

	(sleep_until b_cruiser_dead 1)
	(dprint "objective control : cannon.30")
	(set objcon_cannon 30)

)

(script dormant f_cannon_missionobj_control

	(sleep_until (>= objcon_cannon 1) 5)
	(mo_cannon)

)

(script dormant f_cannon_save_control

	(game_save)

)

(script dormant f_cannon_spawn_control

	(sleep_until (>= objcon_cannon 10) 1)

	(dprint "starting spawns")
	(wake f_cannon_spawn_banshees)
	(wake f_cannon_spawn_phantoms)
	
)

(script dormant f_cannon_spawn_phantoms

	(ai_place sq_cannon_phantom_1)
	(sleep (* 30 2))
	(ai_place sq_cannon_phantom_2)
	(sleep (* 30 3))
	(ai_place sq_cannon_phantom_3)
	(sleep (* 30 2))

	(sleep_until
		(begin
			(if (<= (ai_living_count sq_cannon_phantom_1) 1) (ai_place sq_cannon_phantom_1) )
			(if (<= (ai_living_count sq_cannon_phantom_2) 1) (ai_place sq_cannon_phantom_2) )
			(if (<= (ai_living_count sq_cannon_phantom_3) 1) (ai_place sq_cannon_phantom_3) )
			(if (<= (ai_living_count sq_cannon_phantom_4) 1) (ai_place sq_cannon_phantom_4) )
			(sleep (* 30 3))
	FALSE)
	)

)

(global short s_cannon_phantom_1 1)
(script command_script f_cs_cannon_phantom_1

	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)

	(cs_vehicle_speed 2)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(cs_fly_to ps_cannon_phantom/01_enter_01 1)
	(cs_vehicle_speed .7)
	(cs_fly_to ps_cannon_phantom/01_enter_02 1)

	(sleep_until
		(begin
			(set s_cannon_phantom_1 (random_range 1 4))
			(if (= s_cannon_phantom_1 1)(begin
				(cs_fly_to_and_face ps_cannon_phantom/01_hover_01 ps_cannon_phantom/01_hover_01_face)
			))
			(if (= s_cannon_phantom_1 2)(begin
				(cs_fly_to_and_face ps_cannon_phantom/01_hover_02 ps_cannon_phantom/01_hover_02_face)
			))
			(if (= s_cannon_phantom_1 3)(begin
				(cs_fly_to_and_face ps_cannon_phantom/01_hover_03 ps_cannon_phantom/01_hover_03_face)
			))
		FALSE)
	(* 30 (random_range 1 2) ) )

)

(global short s_cannon_phantom_2 1)
(script command_script f_cs_cannon_phantom_2

	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)

	(cs_vehicle_speed 2)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(cs_fly_to ps_cannon_phantom/02_enter_01 1)
	(cs_vehicle_speed .7)
	(cs_fly_to ps_cannon_phantom/02_enter_02 1)

	(sleep_until
		(begin
			(set s_cannon_phantom_2 (random_range 1 4))
			(if (= s_cannon_phantom_2 1)(begin
				(cs_fly_to_and_face ps_cannon_phantom/02_hover_01 ps_cannon_phantom/02_hover_01_face)
			))
			(if (= s_cannon_phantom_2 2)(begin
				(cs_fly_to_and_face ps_cannon_phantom/02_hover_02 ps_cannon_phantom/02_hover_02_face)
			))
			(if (= s_cannon_phantom_2 3)(begin
				(cs_fly_to_and_face ps_cannon_phantom/02_hover_03 ps_cannon_phantom/02_hover_03_face)
			))
		FALSE)
	(* 30 (random_range 1 2) ) )

)

(global short s_cannon_phantom_3 1)
(script command_script f_cs_cannon_phantom_3

	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)

	(cs_vehicle_speed 2)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(cs_fly_to ps_cannon_phantom/03_enter_01 1)
	(cs_vehicle_speed .7)
	(cs_fly_to ps_cannon_phantom/03_enter_02 1)

	(sleep_until
		(begin
			(set s_cannon_phantom_3 (random_range 1 4))
			(if (= s_cannon_phantom_3 1)(begin
				(cs_fly_to_and_face ps_cannon_phantom/03_hover_01 ps_cannon_phantom/03_hover_01_face)
			))
			(if (= s_cannon_phantom_3 2)(begin
				(cs_fly_to_and_face ps_cannon_phantom/03_hover_02 ps_cannon_phantom/03_hover_02_face)
			))
			(if (= s_cannon_phantom_3 3)(begin
				(cs_fly_to_and_face ps_cannon_phantom/03_hover_03 ps_cannon_phantom/03_hover_03_face)
			))
		FALSE)
	(* 30 (random_range 1 2) ) )

)

(global short s_cannon_phantom_4 1)
(script command_script f_cs_cannon_phantom_4

	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)

	(cs_vehicle_speed 2)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(cs_fly_to ps_cannon_phantom/04_enter_01 1)
	(cs_vehicle_speed .7)
	(cs_fly_to ps_cannon_phantom/04_enter_02 1)

	(sleep_until
		(begin
			(set s_cannon_phantom_4 (random_range 1 4))
			(if (= s_cannon_phantom_4 1)(begin
				(cs_fly_to_and_face ps_cannon_phantom/04_hover_01 ps_cannon_phantom/04_hover_01_face)
			))
			(if (= s_cannon_phantom_4 2)(begin
				(cs_fly_to_and_face ps_cannon_phantom/04_hover_02 ps_cannon_phantom/04_hover_02_face)
			))
			(if (= s_cannon_phantom_4 3)(begin
				(cs_fly_to_and_face ps_cannon_phantom/04_hover_03 ps_cannon_phantom/04_hover_03_face)
			))
		FALSE)
	(* 30 (random_range 1 2) ) )

)

(script dormant f_cannon_spawn_banshees

	(ai_place sq_cannon_banshee_1)
	(sleep (* 30 4))
	(ai_place sq_cannon_banshee_2)
	(sleep (* 30 4))
	(ai_place sq_cannon_banshee_3)
	(sleep (* 30 4))

	(sleep_until
		(begin
			(if
				(< (ai_task_count obj_cannon_cov/gate_banshees) 2)
				(begin
					(ai_place sq_cannon_banshee_1)
					(sleep (* 30 4))
				)
			)
			FALSE
		)	
	)

)

(script dormant f_cannon_md_control

	(f_abort_md)

	(sleep 150)

	(md_cannon_enter)

	(sleep_until (>= objcon_cannon 10) 5)

	(sleep_until (>= objcon_cannon 20) 1 (* 30 30))
	(if (not (>= objcon_cannon 20))
		(begin
			(md_cannon_move_0)
		)
	)

	(sleep_until (>= objcon_cannon 20) 5)

	(sleep_until (>= objcon_cannon 30) 1 (* 30 2))
	(if (not (>= objcon_cannon 30))
		(begin
			(md_cannon_fire_delay_0)
		)
	)

	(sleep_until (>= objcon_cannon 30) 1 (* 30 2))
	(if (not (>= objcon_cannon 30))
		(begin
			(md_cannon_fire_delay_1)
		)
	)

	(sleep_until (>= objcon_cannon 30) 1 (* 30 2))
	(if (not (>= objcon_cannon 30))
		(begin
			(md_cannon_fire_delay_2)
		)
	)

	(sleep_until (>= objcon_cannon 30) 1)

	(sleep_until (not g_dialog))
	(md_cannon_die)

)


(script dormant f_cannon_music_control

	(wake music_cannon)

)

(script dormant f_train_mac

	(sleep_until
		(or
			(vehicle_test_seat_unit (ai_vehicle_get_from_squad sq_cannon_mac 0) mac_d player0)
			(vehicle_test_seat_unit (ai_vehicle_get_from_squad sq_cannon_mac 0) mac_d player1)
			(vehicle_test_seat_unit (ai_vehicle_get_from_squad sq_cannon_mac 0) mac_d player2)
			(vehicle_test_seat_unit (ai_vehicle_get_from_squad sq_cannon_mac 0) mac_d player3)
		)	
	)

	(set s_music_zealot 2)
	(set s_music_cannon 1)

	(if (vehicle_test_seat_unit (ai_vehicle_get_from_squad sq_cannon_mac 0) mac_d player0) (f_train_mac_player player0))
	(if (vehicle_test_seat_unit (ai_vehicle_get_from_squad sq_cannon_mac 0) mac_d player1) (f_train_mac_player player1))
	(if (vehicle_test_seat_unit (ai_vehicle_get_from_squad sq_cannon_mac 0) mac_d player2) (f_train_mac_player player2))
	(if (vehicle_test_seat_unit (ai_vehicle_get_from_squad sq_cannon_mac 0) mac_d player3) (f_train_mac_player player3))

	(sleep (* 30 10))
	(set s_music_cannon 2)
	
)

(script static void (f_train_mac_player (player p))

	(f_hud_training p train_mac)

)

(script dormant f_cannon_cruiser
	
	; set ninth mission segment
	(data_mine_set_mission_segment "m70_09_cruiser")
	
	(object_create_if_necessary dm_cannon_cruiser)
	
	(sleep_until (>= objcon_cannon 10))
	(if (not b_cruiser_moving)
		(device_set_position_track dm_cannon_cruiser "device:position" 0)
	)
	(device_animate_position dm_cannon_cruiser .4 0.0 .034 .034 TRUE)
	(device_animate_position dm_cannon_cruiser 1 90 .034 .034 TRUE)

	(sleep_until (>= (device_get_position dm_cannon_cruiser) .9) 1)
	(print "CRUISER VULNERABLE")
	(object_create_anew sc_cannon_cruiser_target)
	(effect_new_on_object_marker levels\solo\m70\fx\glassing\glassing_init dm_cannon_cruiser fx_glass_hole)
	(f_blip_object sc_cannon_cruiser_target 16)
	(set b_cruiser_vulnerable TRUE)
	(wake f_cannon_cruiser_kill)
	(set s_music_cannon 3)

	(sleep_until (< (object_get_health sc_cannon_cruiser_target) .76) 1)
	(set b_cruiser_dead TRUE)
	(print "CRUISER DEAD")
	(cinematic_enter 070lc_poa_launch TRUE)
	(f_cin_outro_prep)
	(f_end_mission 070lc_poa_launch set_outro_cinematic)
	(game_won)

)


(script dormant f_cannon_cruiser_test

	(object_create_if_necessary dm_cannon_cruiser)

	(if (not b_cruiser_moving)
		(device_set_position_track dm_cannon_cruiser "device:position" 0)
	)

	(sleep_until
		(begin
			(device_animate_position dm_cannon_cruiser .4 0.0 .034 .034 TRUE)
			(device_animate_position dm_cannon_cruiser 1 60 .034 .034 TRUE)
		
			(sleep_until (>= (device_get_position dm_cannon_cruiser) .9) 1)
			(print "CRUISER VULNERABLE")
			(object_create_anew sc_cannon_cruiser_target)
			(effect_new_on_object_marker levels\solo\m70\fx\glassing\glassing_init dm_cannon_cruiser fx_glass_hole)
			(f_blip_object sc_cannon_cruiser_target 16)
			(set b_cruiser_vulnerable TRUE)
			(sleep_until (>= (device_get_position dm_cannon_cruiser) 1) 1)
			(sleep 300)
			(effect_new_on_object_marker levels\solo\m70\fx\glassing\glassing_main.effect dm_cannon_cruiser fx_glass_hole)
			(sleep 45)
		FALSE)
	1)


)

(script dormant f_cannon_cruiser_kill

	(branch
		b_cruiser_dead
		(f_abort)
	)

	(sleep_until (>= (device_get_position dm_cannon_cruiser) 1) 1)
	(sleep 300)
	(effect_new_on_object_marker levels\solo\m70\fx\glassing\glassing_main.effect dm_cannon_cruiser fx_glass_hole)

	(sleep 45)
	(fade_out 1 1 1 0)

	(sleep 45)
	(unit_kill player0)
	(unit_kill player1)
	(unit_kill player2)
	(unit_kill player3)
		
)


(script static void f_cin_outro_prep

	(sleep_forever f_save_continuous)

	(wake f_outro_scarab_1)
	(wake f_outro_scarab_2)

	(f_objects_final_2_destroy)
	(f_objects_global_destroy)

	(f_platform_flock_delete)
	(ai_erase sq_cannon_mac)

)

(script dormant f_cannon_cleanup_control

	(sleep_until b_cruiser_dead 1)
	(f_cannon_kill_scripts)
	(f_cannon_despawn_all)

)

(script dormant f_outro_scarab_1
	(object_create dm_outro_scarab_1)
	(sleep_until
	  (begin
	    (device_set_position_track dm_outro_scarab_1 stationary_march 0)
	    (device_animate_position dm_outro_scarab_1 1.0 (random_range 7 10) 1.0 1.0 TRUE)
	    (sleep_until (>= (device_get_position dm_outro_scarab_1) 1) 1)
	    (sleep (random_range 0 20))
	  0)
	)
)

(script dormant f_outro_scarab_2 
	(object_create dm_outro_scarab_2)
	(sleep_until
	  (begin
	    (device_set_position_track dm_outro_scarab_2 stationary_march 0)
	    (device_animate_position dm_outro_scarab_2 1.0 (random_range 7 10) 1.0 1.0 TRUE)
	    (sleep_until (>= (device_get_position dm_outro_scarab_2) 1) 1)
	    (sleep (random_range 0 20))
	  0)
	)
)

(script static void f_cannon_kill_scripts

	(sleep_forever f_cannon_objective_control)
	(sleep_forever f_cannon_missionobj_control)
	(sleep_forever f_cannon_save_control)
	(sleep_forever f_cannon_spawn_control)
	(sleep_forever f_cannon_spawn_phantoms)
	(sleep_forever f_cannon_spawn_banshees)
	(sleep_forever f_cannon_md_control)
	;(sleep_forever f_cannon_load_player)
	(sleep_forever f_train_mac)
	;(sleep_forever f_cannon_cruiser)
	;(sleep_forever f_cannon_cruiser_move)
	;(sleep_forever f_cannon_cruiser_vulnerable)
	;(sleep_forever f_cannon_cruiser_die)
	;(sleep_forever f_cannon_cruiser_kill)
	(ai_dialogue_enable TRUE)
	(ai_actor_dialogue_enable (object_get_ai o_emile) TRUE)

)


(script static void f_cannon_despawn_all

	(ai_erase gr_cannon_cov)

)

;----------------------------------------------------------------------------------------------------
; Utility

(script static void (dprint (string s) )
	(if b_debug (print s))
)

(script static void (dbreak (string s) )
	;(if (or (not (editor_mode)) b_breakpoints) (breakpoint s))
	(sleep 0)
)

(script static void (md_print (string s) )
	(if b_md_print (print s))
)

(script static void f_abort
	(dprint "function aborted")
)

(script static void tick
	(sleep 1)
)

(script dormant f_checkpoint_generic

	(sleep_until (volume_test_players tv_checkpoint_1) 5)
	(dprint "trying to save")
	(game_save_no_timeout)
	(sleep_until (volume_test_players tv_checkpoint_2) 5)
	(dprint "trying to save")
	(game_save_no_timeout)

)

(script command_script f_cs_emile_mongoose_reenter

	(cs_enable_pathfinding_failsafe TRUE)

	(sleep_until 
		(begin
			(dprint "get back in vehicle")
			(cs_go_to_vehicle v_mongoose_emile)
		(vehicle_test_seat v_mongoose_emile "mongoose_d"))
	30 )
	
)

(global boolean b_players_all_on_foot FALSE)
(global boolean b_players_any_in_vehicle FALSE)
(script dormant f_player_on_foot
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
				(begin
					(set b_players_all_on_foot FALSE)
					(set b_players_any_in_vehicle TRUE)
				)
				(begin
					(set b_players_all_on_foot TRUE)
					(set b_players_any_in_vehicle FALSE)
				)
			)
		FALSE)
	)
)

(global short s_squad_group_counter 0)
(script static void (f_squad_group_place (ai squad_group))

	(set s_squad_group_counter (ai_squad_group_get_squad_count squad_group))
	
	(sleep_until (begin
	
		(set s_squad_group_counter (- s_squad_group_counter 1))
		(ai_place (ai_squad_group_get_squad squad_group s_squad_group_counter))
		(<= s_squad_group_counter 0)

	) 1)

)

(script static boolean difficulty_is_normal_or_higher  

	(or 
		(= (game_difficulty_get) normal)  
		(= (game_difficulty_get) heroic)  
		(= (game_difficulty_get) legendary)  
	) 

) 
 
(script static boolean difficulty_is_heroic_or_higher  

	(or 
		(= (game_difficulty_get) heroic)  
		(= (game_difficulty_get) legendary)  
	) 

) 
 
(script static boolean difficulty_is_legendary  

	(= (game_difficulty_get) legendary) 

)  

; BODIES
; -------------------------------------------------------------------------------------------------
(global short pose_against_wall_var1     0)
(global short pose_against_wall_var2     1)
(global short pose_against_wall_var3     2)
(global short pose_against_wall_var4     3)
(global short pose_on_back_var1          4)
(global short pose_on_back_var2          5)
(global short pose_on_side_var1          6)
(global short pose_on_side_var2          7)
(global short pose_on_back_var3          8)
(global short pose_face_down_var1        9)
(global short pose_face_down_var2        10)
(global short pose_on_side_var3          11)
(global short pose_on_side_var4          12)
(global short pose_face_down_var3        13)
(global short pose_on_side_var5          14)


(script static void (pose_body (object_name body_name) (short pose))
       (object_create body_name)
       (cond
              ((= pose pose_against_wall_var1) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_01))
              ((= pose pose_against_wall_var2) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_02))
              ((= pose pose_against_wall_var3) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_03))
              ((= pose pose_against_wall_var4) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_04))
              ((= pose pose_on_back_var1) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_05))
              ((= pose pose_on_back_var2) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_06))
              ((= pose pose_on_side_var1) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_07))
              ((= pose pose_on_side_var2) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_08))
              ((= pose pose_on_back_var3) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_09))
              ((= pose pose_face_down_var1) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_10))
              ((= pose pose_face_down_var2) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_11))
              ((= pose pose_on_side_var3) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_12))
              ((= pose pose_on_side_var4) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_13))
              ((= pose pose_face_down_var3) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_14))
              ((= pose pose_on_side_var5) (scenery_animation_start (scenery body_name) objects\characters\marine\marine deadbody_15))
       )             
)


;----------------------------------------------------------------------------------------------------
; Shortcuts

; sh - half speed
(script static void sh
	(if (!= game_speed .5)
		(set game_speed .5)
		(set game_speed 1)
	)
)

; s0 - pause/unpause
(script static void p
	(if (!= game_speed 0)
		(set game_speed 0)
		(set game_speed 1)
	)
)

; s5 - game speed 5
(script static void s5
	(if (!= game_speed 5)
		(set game_speed 5)
		(set game_speed 1)
	)
)

; b - bsps
(script static void b
	(if ai_render_sector_bsps
		(begin
			(set ai_render_sector_bsps 0)
			(print "ai_render_sector_bsps OFF")
		)
		(begin
			(set ai_render_sector_bsps 1)
			(print "ai_render_sector_bsps ON")
		)
	)
)

; o - objectives
(script static void o
	(if ai_render_objectives
		(begin
			(set ai_render_objectives 0)
			(print "render objectives OFF")
		)
		(begin
			(set ai_render_objectives 1)
			(print "render objectives ON")
		)
	)
)


; d - decisions
(script static void d
	(if ai_render_decisions
		(begin
			(set ai_render_decisions 0)
			(print "ai_render_decisions OFF")
		)
		(begin
			(set ai_render_decisions 1)
			(print "ai_render_decisions ON")
		)
	)
)

; c - command scripts
(script static void c
	(if ai_render_command_scripts
		(begin
			(set ai_render_command_scripts 0)
			(print "ai_render_command_scripts OFF")
		)
		(begin
			(set ai_render_command_scripts 1)
			(print "ai_render_command_scripts ON")
		)
	)
)

; p - command scripts
(script static void t
	(if debug_performances
		(begin
			(set debug_performances 0)
			(print "debug_performances OFF")
		)
		(begin
			(set debug_performances 1)
			(print "debug_performances ON")
		)
	)
)

(global boolean b_debug_scripting TRUE)
; s - debug scripting
(script static void s
	(if b_debug_scripting
		(begin
			(debug_scripting FALSE)
			(print "debug_scripting OFF")
			(set b_debug_scripting FALSE)
		)
		(begin
			(debug_scripting TRUE)
			(print "debug_scripting ON")
			(set b_debug_scripting TRUE)
		)
	)
)

; f - cinematic_fade_to_gameplay
(script static void f
	(print "cinematic_fade_to_gameplay")
	(cinematic_fade_to_gameplay)
)


; pr - ai render props
(script static void pr
	(if ai_render_props
		(begin
			(set ai_render_props 0)
			(print "ai_render_props OFF")
		)
		(begin
			(set ai_render_props 1)
			(print "ai_render_props ON")
		)
	)
)

; be - ai render behavior stack
(script static void be
	(if ai_render_behavior_stack_all
		(begin
			(set ai_render_behavior_stack_all 0)
			(print "ai_render_behavior_stack_all OFF")
		)
		(begin
			(set ai_render_behavior_stack_all 1)
			(print "ai_render_behavior_stack_all ON")
		)
	)
)


; de - ai render decisions
(script static void de
	(if ai_render_decisions
		(begin
			(set ai_render_decisions 0)
			(print "ai_render_decisions OFF")
		)
		(begin
			(set ai_render_decisions 1)
			(print "ai_render_decisions ON")
		)
	)
)


;* COMMANDS
ai_render_tracked_props : shows scariness
ai_render_decisions : shows behaviors
ai_render_target : shows you the currently selected actor’s target
ai_render_sector_bsps : pathfinding debugging
ai_render_evaluations : shows you firing point evaluation results 
                ai_render_evaluations_text 
                ai_render_evaluations_detailed
                ai_render_evaluations_shading
                ai_render_evaluations_shading_none
                ai_render_evaluations_shading_#name of firing point evaluation tag#
ai_render_emotions : shows the danger level of an AI
ai_render_vehicle_turns : shows the trottle speed for an ai driving (must select the ai first)
ai_render_timeslices : shows how often an ai is checking for new firing points
ai_render_aiming_vectors : show the view lines the AI wants to look and and the ones he is looking at
ai_render_props : use this to show the objects in the world the AI can perceive (orphans and such)
ai_render_vision_cones : the visual representation of the perception cone model
*;

;GLOBALS

; LONGSWORDS
; =================================================================================================
; Make a longsword device activate. 
; Device Tag: sound\device_machines\040vc_longsword\start
; Flyby Sound Tag: sound\device_machines\040vc_longsword\start
; =================================================================================================
; Example: (f_ls_flyby my_longsword_device_machine)
;           (sound_impulse_start sound\device_machines\040vc_longsword\start NONE 1)
; =================================================================================================
(script static void (f_ls_flyby (device d))
      (device_animate_position d 0 0.0 0.0 0.0 TRUE)
      (device_set_position_immediate d 0)
      (device_set_power d 0)
      (sleep 1)
      (device_set_position_track d device:position 0)
      (device_animate_position d 0.5 7.0 0.1 0.1 TRUE))

; CARPETBOMBS
; =================================================================================================
; Spawn a trail of bombs across a point set.
; Effect Tag: fx\fx_library\explosions\reach_test_explosion_large\reach_test_explosion_large
; Count: How many points are in the set?
; Delay: Time (in ticks) between the detonation of each bomb effect
; =================================================================================================
; Example: (f_ls_carpetbomb pts_030 fx\my_explosion_fx 6 10)
; =================================================================================================
(global short global_s_current_bomb 0)
(script static void (f_ls_carpetbomb (point_reference p) (effect e) (short count) (short delay))
      (set global_s_current_bomb 0)
      (sleep_until
            (begin
                  (if b_debug_globals (dprint "boom..."))
                  (effect_new_at_point_set_point e p global_s_current_bomb)
                  (set global_s_current_bomb (+ global_s_current_bomb 1))
                  (sleep delay)
            (>= global_s_current_bomb count)) 1) 
)

; Save Scripts
; =================================================================================================
(global boolean b_save_continuous TRUE)
(script continuous f_save_continuous

	(sleep_until b_insertion_fade_in)

	(sleep_until
		(begin
			(if b_save_continuous (begin
				(sleep_until (= (current_zone_set) (current_zone_set_fully_active)) 2)
				(sleep (* 30 5))
				(dprint "continuous save")
				(game_save_no_timeout)
			))
			FALSE
		)
	(* 30 120))
)

; Recycling Scripts
; =================================================================================================
(script continuous f_recycle_all_continuous

	(sleep_until
		(begin
			(if (volume_test_players tv_recycle_dirt)
				(f_recycle_dirt_lite)
				(f_recycle_dirt)
			)
			(if (volume_test_players tv_recycle_drop)
				(f_recycle_drop_lite)
				(f_recycle_drop)
			)
			(if (volume_test_players tv_recycle_block)
				(f_recycle_block_lite)
				(f_recycle_block)
			)
			(if (volume_test_players tv_recycle_cave)
				(f_recycle_cave_lite)
				(f_recycle_cave)
			)
			(if (volume_test_players tv_recycle_bone)
				(f_recycle_bone_lite)
				(f_recycle_bone)
			)
			(if (volume_test_players tv_recycle_smelt)
				(f_recycle_smelt_lite)
				(f_recycle_smelt)
			)
			(if (volume_test_players tv_recycle_bgun)
				(f_recycle_bgun_lite)
				(f_recycle_bgun)
			)

			FALSE
		)
	400)
)

(script static void f_recycle_dirt
	(add_recycling_volume tv_recycle_dirt 5 5)
)

(script static void f_recycle_dirt_lite
	; bipeds
	(add_recycling_volume_by_type tv_recycle_dirt 20 (* 30 4) 1)
	(sleep (* 30 5))
	; weapons
	(add_recycling_volume_by_type tv_recycle_dirt 30 (* 30 4) 4)
	(sleep (* 30 5))
	; equipment
	(add_recycling_volume_by_type tv_recycle_dirt 20 (* 30 4) 8)
	(sleep (* 30 5))
)


(script static void f_recycle_drop
	(add_recycling_volume tv_recycle_drop 5 5)
)

(script static void f_recycle_drop_lite
	; bipeds
	(add_recycling_volume_by_type tv_recycle_drop 25 (* 30 4) 1)
	(sleep (* 30 5))
	; weapons
	(add_recycling_volume_by_type tv_recycle_drop 30 (* 30 4) 4)
	(sleep (* 30 5))
	; equipment
	(add_recycling_volume_by_type tv_recycle_drop 20 (* 30 4) 8)
	(sleep (* 30 5))

)

(script static void f_recycle_block
	(add_recycling_volume tv_recycle_block 5 5)
)

(script static void f_recycle_block_lite
	; bipeds
	(add_recycling_volume_by_type tv_recycle_block 25 (* 30 4) 1)
	(sleep (* 30 5))
	; weapons
	(add_recycling_volume_by_type tv_recycle_block 30 (* 30 4) 4)
	(sleep (* 30 5))
	; equipment
	(add_recycling_volume_by_type tv_recycle_block 20 (* 30 4) 8)
	(sleep (* 30 5))
)

(script static void f_recycle_cave
	(add_recycling_volume tv_recycle_cave 5 5)
)

(script static void f_recycle_cave_lite
	; bipeds
	(add_recycling_volume_by_type tv_recycle_cave 25 (* 30 4) 1)
	(sleep (* 30 5))
	; weapons
	(add_recycling_volume_by_type tv_recycle_cave 30 (* 30 4) 4)
	(sleep (* 30 5))
	; equipment
	(add_recycling_volume_by_type tv_recycle_cave 20 (* 30 4) 8)
	(sleep (* 30 5))
)

(script static void f_recycle_bone
	(add_recycling_volume tv_recycle_bone 5 5)
)

(script static void f_recycle_bone_lite
	; bipeds
	(add_recycling_volume_by_type tv_recycle_bone 25 (* 30 4) 1)
	(sleep (* 30 5))
	; weapons
	(add_recycling_volume_by_type tv_recycle_bone 30 (* 30 4) 4)
	(sleep (* 30 5))
	; equipment
	(add_recycling_volume_by_type tv_recycle_bone 20 (* 30 4) 8)
	(sleep (* 30 5))
)

(script static void f_recycle_smelt
	(add_recycling_volume tv_recycle_smelt 5 5)
)

(script static void f_recycle_smelt_lite
	; bipeds
	(add_recycling_volume_by_type tv_recycle_smelt 25 (* 30 4) 1)
	(sleep (* 30 5))
	; weapons
	(add_recycling_volume_by_type tv_recycle_smelt 30 (* 30 54) 4)
	(sleep (* 30 5))
	; equipment
	(add_recycling_volume_by_type tv_recycle_smelt 20 (* 30 4) 8)
	(sleep (* 30 5))
)

(script static void f_recycle_bgun
	(add_recycling_volume tv_recycle_bgun 5 5)
)

(script static void f_recycle_bgun_lite
	; bipeds
	(add_recycling_volume_by_type tv_recycle_bgun 25 (* 30 4) 1)
	(sleep (* 30 5))
	; weapons
	(add_recycling_volume_by_type tv_recycle_bgun 30 (* 30 4) 4)
	(sleep (* 30 5))
	; equipment
	(add_recycling_volume_by_type tv_recycle_bgun 20 (* 30 4) 8)
	(sleep (* 30 5))
)

; Test Scripts
; =================================================================================================

(global boolean b_test_carterdeath FALSE)
(script static void f_test_carterdeath

	(switch_zone_set set_cave)

	; Teleport
	(object_teleport_to_ai_point player0 ps_carter_spawn/player0)
	(object_teleport_to_ai_point player1 ps_carter_spawn/player1)
	(object_teleport_to_ai_point player2 ps_carter_spawn/player2)
	(object_teleport_to_ai_point player3 ps_carter_spawn/player3)

	(set b_test_carterdeath TRUE)	
	(wake f_carter_objective_control)

)

(global boolean b_test_finalbattle FALSE)
(script static void f_test_finalbattle

	(switch_zone_set set_final_0)

	; Teleport
	(object_teleport_to_ai_point player0 ps_platform_door_spawn/player0)
	(object_teleport_to_ai_point player1 ps_platform_door_spawn/player1)
	(object_teleport_to_ai_point player2 ps_platform_door_spawn/player2)
	(object_teleport_to_ai_point player3 ps_platform_door_spawn/player3)

	(set b_test_finalbattle TRUE)	
	(wake f_platform_finalbattle_control)
	(wake f_platform_pillar)

)


(global boolean b_test_scarabdrop FALSE)
(script static void f_test_scarabdrop

	(switch_zone_set set_dirt)

	; Teleport
	(object_teleport_to_ai_point player0 ps_drop_test_spawn/player0)
	(object_teleport_to_ai_point player1 ps_drop_test_spawn/player1)
	(object_teleport_to_ai_point player2 ps_drop_test_spawn/player2)
	(object_teleport_to_ai_point player3 ps_drop_test_spawn/player3)

	(set b_test_scarabdrop TRUE)	
	(wake f_drop_scarabs_start)

)


(global boolean b_test_cannon FALSE)
(script static void f_test_cannon

	(switch_zone_set set_final_2)

	; Teleport
	(object_teleport_to_ai_point player0 ps_cannon_spawn/player0)
	(object_teleport_to_ai_point player1 ps_cannon_spawn/player1)
	(object_teleport_to_ai_point player2 ps_cannon_spawn/player2)
	(object_teleport_to_ai_point player3 ps_cannon_spawn/player3)

	(set b_test_cannon TRUE)	
	(wake f_platform_cannon_init)
	(wake f_cannon_objective_control)

)


(global boolean b_test_cruiser FALSE)
(script static void f_test_cruiser

	(switch_zone_set set_final_2)

	; Teleport
	(object_teleport_to_ai_point player0 ps_cannon_spawn/player0)
	(object_teleport_to_ai_point player1 ps_cannon_spawn/player1)
	(object_teleport_to_ai_point player2 ps_cannon_spawn/player2)
	(object_teleport_to_ai_point player3 ps_cannon_spawn/player3)

	(set objcon_cannon 10)
	(set b_test_cruiser TRUE)	
	(wake f_platform_cannon_init)
	(wake f_cannon_cruiser)

)


(script static void f_test_platform_wave_0

	(ai_place sq_platform_phantom_w0_1)
	(sleep (* 30 8))
	(ai_place sq_platform_phantom_w0_2)
	(set s_platform_wave 0)
	(set objcon_platform 50)

)


(script static void f_test_platform_wave_1

	(ai_place sq_platform_phantom_w1_1)
	(ai_place sq_platform_phantom_w1_2)
	(set s_platform_wave 1)
	(set objcon_platform 50)

)


(script static void f_test_platform_wave_2

	(ai_place sq_platform_phantom_w2_2)
	(ai_place sq_platform_phantom_w2_1)
	(set s_platform_wave 2)
	(set objcon_platform 50)

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
	        (< (objects_distance_to_object player1 (ai_get_object ai_current_actor))15)
	      )
	      (= (player_is_in_game player1) true)
	    )                                              
	    (and
	      (or
	        (objects_can_see_object player2 (ai_get_object ai_current_actor) 10)
	        (< (objects_distance_to_object player2 (ai_get_object ai_current_actor))15)
	      )
	      (= (player_is_in_game player2) true)
	    )                              
	    (and
	      (or
	        (objects_can_see_object player3 (ai_get_object ai_current_actor) 10)
	        (< (objects_distance_to_object player3 (ai_get_object ai_current_actor))15)
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


(script static void (f_hud_spartan_waypoint_object (object spartan) (string_id spartan_hud) (short max_dist))
	(sleep_until
		(begin
			(cond
				((< (objects_distance_to_object spartan player0) .95)
					(begin
						(chud_track_object spartan FALSE)
						(sleep 60)
					)
				)
				
				((> (objects_distance_to_object spartan player0) max_dist)
					(begin
						(chud_track_object spartan FALSE)
						(sleep 60)
					)
				)
				
				((< (objects_distance_to_object spartan player0) 3)
					(begin
						(chud_track_object_with_priority spartan 22 spartan_hud)
						(sleep 60)
					)
				)
				
				((objects_can_see_object player0 spartan 10)
					(begin
						(chud_track_object_with_priority spartan 22 spartan_hud)
						(sleep 60)
					)
				)
				
				(TRUE
					(begin
						(chud_track_object_with_priority spartan 5 "")
						;(sleep 30)
					)
				)
			)
		0)
	30)
	
)