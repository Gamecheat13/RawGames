; =================================================================================================
; =================================================================================================
; *** GLOBALS ***
; =================================================================================================
; =================================================================================================

; Debug Options
(global boolean b_debug 						TRUE)
(global boolean b_breakpoints				FALSE)
(global boolean b_md_print					TRUE)
(global boolean b_debug_objectives 	FALSE)
(global boolean b_editor 						(editor_mode))
(global boolean b_game_emulate			FALSE)
(global boolean b_cinematics 				TRUE)
(global boolean b_editor_cinematics FALSE)
(global boolean b_encounters				TRUE)
(global boolean b_dialogue 					TRUE)
(global boolean b_skip_intro				FALSE)

; Mission Started
(global boolean b_landed FALSE)
(global boolean b_mission_started FALSE)

; Insertion
(global short s_insertion_index 0)
(global short s_court_ins_idx 1)
(global short s_valley_ins_idx 2)
(global short s_return_ins_idx 3)
(global short s_garage_ins_idx 4)
(global short s_sword_ins_idx 5)

; Objective Controls
(global short s_objcon_court -1)
(global short s_objcon_valley -1)
(global short s_objcon_gate -1)
(global short s_objcon_far -1)
(global short s_objcon_air -1)
(global short s_objcon_return -1)
(global short s_objcon_garage -1)
(global short s_objcon_sword -1)
(global short s_objcon_roof -1)

(global boolean b_court_ready FALSE)
(global boolean b_valley_ready FALSE)
(global boolean b_gate_ready FALSE)
(global boolean b_far_ready FALSE)
(global boolean b_air_ready FALSE)
(global boolean b_garage_ready FALSE)
(global boolean b_sword_ready FALSE)
(global boolean b_roof_ready FALSE)

; Zone Sets
(global short s_zoneset_intro_cinematic 0)
(global short s_zoneset_courtyard_valley 1)
(global short s_zoneset_exterior 2)
(global short s_zoneset_courtyard_return 3)
(global short s_zoneset_interior 4)
(global short s_zoneset_end_cinematic 5)
(global short s_zoneset_courtyard_valley_re 6)
(global short s_zoneset_courtyard 7)
(global short s_zoneset_all 8)

; Fire Teams
(global short s_fireteam_max 3)
(global real r_fireteam_dist 2.0)

; Mission Specific
(global boolean b_mission_complete FALSE)

(global boolean b_court_defended FALSE)
(global boolean b_far_defended FALSE)
(global boolean b_air_defended FALSE)
(global boolean b_corvette_destroyed FALSE)

(global boolean b_radio_chatter FALSE)

; Persistent Objects
(global object o_emile NONE)
(global object o_kat NONE)
(global object o_jorge NONE)
(global object o_jun NONE)

(global object o_corvette_AA_01 NONE)
(global object o_corvette_AA_02 NONE)

; Persistent ai
(global ai ai_emile NONE)
(global ai ai_kat NONE)
(global ai ai_jorge NONE)
(global ai ai_jun NONE)

; Utility
(global boolean b_wave_spawning FALSE)
(global short s_wave_spawning 0)

; Hints
(global short s_waypoint_timer 90)

; =================================================================================================
; =================================================================================================
; START-UP
; =================================================================================================
; =================================================================================================

(script startup swordbase

	(zone_set_trigger_volume_enable begin_zone_set:zoneset_courtyard_return FALSE)
	(zone_set_trigger_volume_enable zone_set:zoneset_courtyard_return FALSE)

	(if b_debug (print_difficulty))
	(if b_debug (print "::: M20 - SWORD BASE :::"))

	; Allegiances
	(ai_allegiance human player)
	(ai_allegiance player human)
	
	(set respawn_players_into_friendly_vehicle true)

	(f_loadout_set "default")

	(set breakpoints_enabled FALSE)	

	(if b_encounters
		(begin
			;(wake f_landing_main)
			(wake f_court_main)
			(wake f_valley_main)
			(wake f_far_main)
			(wake f_air_main)
			(wake f_air_far_main)
			(wake f_return_main)
			(wake f_garage_main)
			(wake f_sword_main)
			(wake f_roof_main)
		)
	)

	(wake f_slew)
	(wake special_elite)

	(soft_ceiling_enable soft_ceiling_interior 0)
	(soft_ceiling_enable camera_blocker_07 0)
	(soft_ceiling_enable camera_blocker_08 0)
	(soft_ceiling_enable camera_blocker_09 0)	


	; STARTING THE GAME
	; ============================================================================================
	(if	
		(or 
			b_game_emulate
			(and
				(not b_editor)
				(> (player_count) 0)
			)
		)

		; if true, start the game
		(begin
			(start)
		)

		; else just fade in, we're in edit mode
		(begin
			(if b_debug (print ":::  editor mode  :::"))
			(fade_in 0 0 0 0)
			;(wake f_objects_manage)
		)
	)
)

(global boolean b_insertion_fade_in FALSE)
(script dormant f_insertion_fade_in

	(sleep_until b_insertion_fade_in)
	(insertion_fade_to_gameplay)

)

(script static void f_kill_all_scripts
	(sleep_forever f_court_main)
	(sleep_forever f_valley_main)
	(sleep_forever f_far_main)
	(sleep_forever f_air_main)
	(sleep_forever f_air_far_main)
	(sleep_forever f_return_main)
	(sleep_forever f_garage_main)
	(sleep_forever f_sword_main)
	(sleep_forever f_roof_main)
)

; =================================================================================================
; =================================================================================================
; START
; =================================================================================================
; =================================================================================================

(script static void start

	; Figure out what insertion point to use
	(cond
		((= (game_insertion_point_get) 0) (ins_court))
		((= (game_insertion_point_get) 1) (ins_valley))
		((= (game_insertion_point_get) 2) (ins_return))
		((= (game_insertion_point_get) 3) (ins_sword))
		((= (game_insertion_point_get) 4) (f_test_airbomb))
		((= (game_insertion_point_get) 5) (f_test_gatebomb))
		((= (game_insertion_point_get) 6) (f_test_basebomb))
		((= (game_insertion_point_get) 7) (f_test_hallbomb))
		((= (game_insertion_point_get) 8) (f_test_roofbomb))
	)

)

; =================================================================================================
; =================================================================================================
; SHARED
; =================================================================================================
; =================================================================================================

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

	(if (= area "exterior")(begin
		(if (game_is_cooperative)(begin
			(player_set_profile exterior_coop_respawn player0)
			(player_set_profile exterior_coop_respawn player1)
			(player_set_profile exterior_coop_respawn player2)
			(player_set_profile exterior_coop_respawn player3)
		)(begin
			(player_set_profile exterior_single_respawn player0)
		))
	))

	(if (= area "interior")(begin
		(if (game_is_cooperative)(begin
			(player_set_profile interior_coop_respawn player0)
			(player_set_profile interior_coop_respawn player1)
			(player_set_profile interior_coop_respawn player2)
			(player_set_profile interior_coop_respawn player3)
		)(begin
			(player_set_profile interior_single_respawn player0)
		))
	))

)




(script static void (f_kat_respawn (ai kat) (string_id obj))

	(ai_erase ai_kat)
	(ai_erase sq_kat)
	(object_destroy o_kat)
	(sleep 10)
	(f_kat_spawn kat obj)

)

(script static void (f_kat_spawn (ai kat) (string_id obj))

	(ai_place kat)
	(tick)
	(set ai_kat kat)
	(set o_kat (ai_get_object kat))
	(ai_cannot_die kat TRUE)
	(ai_force_active ai_kat TRUE)
	(ai_set_objective (ai_get_squad kat) obj)
	(f_kat_blip)

)


(script static void (f_jorge_spawn (ai jorge) (string_id obj))

	(ai_place jorge)
	(sleep 30)
	(set ai_jorge jorge)
	(set o_jorge (ai_get_object jorge))
	(ai_cannot_die jorge TRUE)
	(ai_force_active ai_jorge TRUE)
	(ai_set_objective (ai_get_squad jorge) obj)

)


(script static void (f_jun_spawn (ai jun) (string_id obj))

	(ai_place jun)
	(sleep 30)
	(set ai_jun jun)
	(set o_jun (ai_get_object jun))
	(ai_cannot_die jun TRUE)
	(ai_force_active ai_jun TRUE)
	(ai_set_objective (ai_get_squad jun) obj)

)


(script static void (f_emile_spawn (ai emile) (string_id obj))

	(ai_place emile)
	(sleep 30)
	(set ai_emile emile)
	(set o_emile (ai_get_object emile))
	(ai_cannot_die emile TRUE)
	(ai_force_active ai_emile TRUE)
	(ai_set_objective (ai_get_squad emile) obj)

)

(global boolean b_jun_blip FALSE)
(global boolean b_jun_unblip FALSE)
(script dormant f_jun_blip


	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_jun) jun_name 60)
		)
	)

)

(global boolean b_jorge_blip FALSE)
(global boolean b_jorge_unblip FALSE)
(script dormant f_jorge_blip

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_jorge) jorge_name 60)
		)
	)

)

(global boolean b_emile_blip FALSE)
(global boolean b_emile_unblip FALSE)
(script dormant f_emile_blip

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_emile) emile_name 60)
		)
	)

)


; =================================================================================================
; SPARTAN WAYPOINT SCRIPTS
; =================================================================================================
(script static void (f_hud_spartan_waypoint_object (object spartan) (string_id spartan_hud) (short max_dist))
	(sleep_until
		(begin
			(cond
				((> (objects_distance_to_object spartan player0) max_dist)
					(begin
						(dprint "chud track")
						(chud_track_object spartan FALSE)
						(sleep 60)
					)
				)
				
				((< (objects_distance_to_object spartan player0) 3)
					(begin
						(dprint "chud track priority 1")
						(chud_track_object_with_priority o_kat 22 spartan_hud)
						(sleep 60)
					)
				)
				
				((objects_can_see_object player0 spartan 10)
					(begin
						(dprint "chud track priority 2")
						(chud_track_object_with_priority o_kat 22 spartan_hud)
						(sleep 60)
					)
				)
				
				(TRUE
					(begin
						(dprint "chud default")
						(chud_track_object_with_priority o_kat 5 "")
						;(sleep 30)
					)
				)
			)
		0)
	30)
	
)

(global boolean b_nanny_reset FALSE)
(script static void (f_kat_area_forward (trigger_volume tv_area) (point_reference pt) (ai respawn) (string_id obj))

	(branch
		b_nanny_reset
		(f_abort)
	)

	; Bring Forward Failsafe
	(sleep_until
		(and
			(volume_test_object tv_area o_kat)
			(volume_test_players tv_area)
		)
	5 (* 30 s_kat_forward_timer))
	(if
		(not
			(and
				(volume_test_object tv_area o_kat)
				(volume_test_players tv_area)
			)
		)
		(begin
			(dbreak "kat forward")
			(ai_set_objective sq_kat obj)
			(tick)
			(ai_bring_forward o_kat r_kat_forward_range)
		)
	)
	
	; Teleport Failsafe
	(sleep_until
		(and
			(volume_test_object tv_area o_kat)
			(volume_test_players tv_area)
		)
	5 (* 30 s_kat_teleport_timer))
	(if
		(not
			(and
				(volume_test_object tv_area o_kat)
				(volume_test_players tv_area)
			)
		)
		(begin
			(dbreak "kat teleport")
			(object_teleport_to_ai_point o_kat pt)
			(ai_set_objective sq_kat obj)
		)
	)

	; Respawn Failsafe
	(sleep_until
		(and
			(volume_test_object tv_area o_kat)
			(volume_test_players tv_area)
		)
	5 (* 30 s_kat_teleport_timer))
	(if
		(not
			(and
				(volume_test_object tv_area o_kat)
				(volume_test_players tv_area)
			)
		)
		(begin
			(dbreak "kat respawn")
			(f_kat_respawn respawn obj)
		)
	)

)

(global short s_kat_forward_timer 15)
(global real r_kat_forward_range 50)
(global short s_kat_teleport_timer 5)
(global short s_kat_spawn_timer 5)
(script dormant f_kat_nanny

	(dprint "kat nanny")
	(if (<= s_insertion_index s_valley_ins_idx)
		(begin
			(wake f_kat_nanny_valley)
			(wake f_kat_nanny_air)
			(wake f_kat_nanny_far)
		)
	)

	(if (<= s_insertion_index s_return_ins_idx)
		(begin
			(sleep_until (>= s_objcon_return 1) 5)
			(wake f_kat_nanny_return)
		)
	)

	(if (<= s_insertion_index s_garage_ins_idx)
		(begin
			(sleep_until (>= s_objcon_garage 1) 5)
			(wake f_kat_nanny_garage)
		)
	)

	(if (<= s_insertion_index s_sword_ins_idx)
		(begin
			(sleep_until (>= s_objcon_sword 1) 5)
			(wake f_kat_nanny_sword)
		)
	)

)

(script dormant f_kat_nanny_valley
	
	(sleep_until (volume_test_players tv_area_valley) 5)
	(f_kat_area_forward tv_area_valley ps_kat_teleport/valley sq_kat/valley_respawn obj_valley_hum)

)


(script dormant f_kat_nanny_air
	
	(sleep_until (and (volume_test_players tv_area_air) (>= s_objcon_air 1) ) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_kat_area_forward tv_area_air ps_kat_teleport/air sq_kat/air_respawn obj_air_hum)

)


(script dormant f_kat_nanny_far

	(sleep_until (and (volume_test_players tv_area_far) (>= s_objcon_far 1) ) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_kat_area_forward tv_area_far ps_kat_teleport/far sq_kat/far_respawn obj_far_hum)

)

(script dormant f_kat_nanny_return
	
	(sleep_until (volume_test_players tv_area_return) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_kat_area_forward tv_area_return ps_kat_teleport/return sq_kat/return_respawn obj_return_hum)

)

(script dormant f_kat_nanny_garage
	
	(sleep_until (volume_test_players tv_area_court) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_kat_area_forward tv_area_court ps_kat_teleport/garage sq_kat/garage_respawn obj_garage_hum)

)

(script dormant f_kat_nanny_sword
	
	(sleep_until (volume_test_players tv_area_sword) 5)
	(set b_nanny_reset TRUE) (tick) (set b_nanny_reset FALSE)
	(f_kat_area_forward tv_area_sword ps_kat_teleport/sword sq_kat/sword_respawn obj_sword_hum)

)


(script static void f_kat_blip_kill

	(sleep_forever f_kat_blip_1)
	(sleep_forever f_kat_blip_2)
	(sleep_forever f_kat_blip_3)
	(sleep_forever f_kat_blip_4)
	(sleep_forever f_kat_blip_5)
	(sleep_forever f_kat_blip_6)
	(sleep_forever f_kat_blip_7)
	(sleep_forever f_kat_blip_8)

)


(global short s_kat_blip 1)
(script static void f_kat_blip

	(cond
		((= s_kat_blip 1)
			(wake f_kat_blip_1)
			(set s_kat_blip 2)
		)
		((= s_kat_blip 2)
			(sleep_forever f_kat_blip_1)
			(wake f_kat_blip_2)
			(set s_kat_blip 3)
		)
		((= s_kat_blip 3)
			(sleep_forever f_kat_blip_2)
			(wake f_kat_blip_3)
			(set s_kat_blip 4)
		)
		((= s_kat_blip 4)
			(sleep_forever f_kat_blip_3)
			(wake f_kat_blip_4)
			(set s_kat_blip 5)
		)
		((= s_kat_blip 5)
			(sleep_forever f_kat_blip_4)
			(wake f_kat_blip_5)
			(set s_kat_blip 6)
		)
		((= s_kat_blip 6)
			(sleep_forever f_kat_blip_5)
			(wake f_kat_blip_6)
			(set s_kat_blip 7)
		)
		((= s_kat_blip 7)
			(sleep_forever f_kat_blip_6)
			(wake f_kat_blip_7)
			(set s_kat_blip 8)
		)
		((= s_kat_blip 8)
			(sleep_forever f_kat_blip_7)
			(wake f_kat_blip_8)
			(set s_kat_blip -1)
		)

	)

)

(script dormant f_kat_blip_1

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_kat) kat_name 60)
		)
	)

)

(script dormant f_kat_blip_2

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_kat) kat_name 60)
		)
	)

)

(script dormant f_kat_blip_3

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_kat) kat_name 60)
		)
	)

)

(script dormant f_kat_blip_4

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_kat) kat_name 60)
		)
	)

)

(script dormant f_kat_blip_5

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_kat) kat_name 60)
		)
	)

)

(script dormant f_kat_blip_6

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_kat) kat_name 60)
		)
	)

)

(script dormant f_kat_blip_7

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_kat) kat_name 60)
		)
	)

)

(script dormant f_kat_blip_8

	(if (not (game_is_cooperative))
		(begin
			(f_hud_spartan_waypoint (object_get_ai o_kat) kat_name 60)
		)
	)

)

(global short s_zoneset_last_refreshed -1)
(script dormant f_objects_manage

		(sleep_until_game_ticks (begin

			(if (not b_ins_return_objects) (begin
			
				(cond
	
					((and (= (current_zone_set_fully_active) s_zoneset_intro_cinematic)(not (= s_zoneset_last_refreshed s_zoneset_intro_cinematic)))
						(dprint "intro objects manage")
						(f_objects_court_init_create)
						(f_objects_court_shared_create)
						(soft_ceiling_enable camera_blocker_05 1)
						(set s_zoneset_last_refreshed s_zoneset_intro_cinematic)
					)
	
					((and (= (current_zone_set_fully_active) s_zoneset_courtyard_valley)(not (= s_zoneset_last_refreshed s_zoneset_courtyard_valley)))
						(dprint "valley objects manage")
						(f_objects_valley_create)
						(set s_zoneset_last_refreshed s_zoneset_courtyard_valley)
					)
	
					((and (= (current_zone_set_fully_active) s_zoneset_exterior)(not (= s_zoneset_last_refreshed s_zoneset_exterior)))
						(dprint "exterior objects manage")
						(f_objects_exterior_create)
						(f_objects_court_init_destroy)
						(f_objects_court_shared_destroy)
						(soft_ceiling_enable camera_blocker_05 0)
						(set s_zoneset_last_refreshed s_zoneset_exterior)
					)
	
					((and (= (current_zone_set_fully_active) s_zoneset_courtyard_valley_re)(not (= s_zoneset_last_refreshed s_zoneset_courtyard_valley_re)))
						(dprint "courtyard valley return objects manage")
						(f_objects_court_return_create)
						(f_objects_court_init_destroy)
						(f_objects_court_shared_create)
						(device_set_position_immediate dm_garagedoor_1 1)
						(device_set_position_immediate dm_garagedoor_2 1)
						(soft_ceiling_enable camera_blocker_05 1) 
						(set s_zoneset_last_refreshed s_zoneset_courtyard_valley_re)
					)
	
					((and (= (current_zone_set_fully_active) s_zoneset_courtyard_return)(not (= s_zoneset_last_refreshed s_zoneset_courtyard_return)))
						(dprint "courtyard return objects manage")
						(f_objects_exterior_destroy)
						(f_objects_valley_destroy)
						(set s_zoneset_last_refreshed s_zoneset_courtyard_return)
					)
	
					((and (= (current_zone_set_fully_active) s_zoneset_interior)(not (= s_zoneset_last_refreshed s_zoneset_interior)))
						(dprint "interior objects manage")
						(f_objects_interior_create)
						(f_objects_court_shared_destroy)
						(f_objects_court_return_destroy)
						(set s_zoneset_last_refreshed s_zoneset_interior)
					)
	
				)
				
			) (begin
	
				(dprint "bravo insertion objects manage")
				(f_objects_exterior_create)
				(f_objects_valley_create)
				(f_objects_court_init_destroy)
				(f_objects_court_shared_destroy)
				(soft_ceiling_enable camera_blocker_05 0)
				(set s_zoneset_last_refreshed s_zoneset_exterior)
				(sleep (* 30 10))
				(set b_ins_return_objects FALSE)
			
			))

	FALSE) 3)

)

(script static void f_objects_court_init_create

	(dprint "creating court init objects")
	(object_create_folder v_court_init)
	(object_create_folder cr_court_init)
	(object_create_folder sc_court_init)
	(object_create_folder dc_court_init)

	(pose_body sc_court_marine_1 pose_on_side_var3)
	(pose_body sc_court_marine_2 pose_face_down_var1)
	(pose_body sc_court_marine_3 pose_face_down_var2)

)	


(script static void f_objects_court_init_destroy

	(dprint "destroying court init objects")
	(object_destroy_folder v_court_init)
	(object_destroy_folder cr_court_init)
	(object_destroy_folder sc_court_init)
	(object_destroy_folder dc_court_init)

)	


(script static void f_objects_court_return_create

	(dprint "creating court return objects")
	(object_create_folder sc_court_return)
	(object_create_folder cr_court_return)
	(object_create_folder wp_court_return)
	(object_create_folder dc_court_return)
	(object_create_folder eq_court_return)
	(object_create_folder v_court_return)

	(pose_body sc_court_return_marine_1 pose_face_down_var2)
	(pose_body sc_court_return_marine_2 pose_face_down_var3)

)

(script static void f_objects_court_return_create_anew

	(dprint "creating court return objects anew")
	(object_create_folder_anew sc_court_return)
	(object_create_folder_anew cr_court_return)
	(object_create_folder_anew wp_court_return)
	(object_create_folder_anew dc_court_return)
	(object_create_folder_anew eq_court_return)
	(object_create_folder_anew v_court_return)

	(pose_body sc_court_return_marine_1 pose_face_down_var2)
	(pose_body sc_court_return_marine_2 pose_face_down_var3)

)

(script static void f_objects_court_return_destroy

	(object_destroy_folder sc_court_return)
	(object_destroy_folder cr_court_return)
	(object_destroy_folder dc_court_return)
	(object_destroy_folder eq_court_return)
	(object_destroy_folder v_court_return)

)

(script static void f_objects_court_shared_create

	(object_create_folder dm_court_shared)
	(object_create_folder v_court_shared)
	(object_create_folder sc_court_shared)
	(object_create_folder cr_court_shared)

)

(script static void f_objects_court_shared_destroy

	(object_destroy_folder dm_court_shared)
	(object_destroy_folder v_court_shared)
	(object_destroy_folder sc_court_shared)
	(object_destroy_folder cr_court_shared)

)

(script static void f_objects_valley_create

	(object_create_folder dc_valley)
	(object_create_folder cr_valley)
	(object_create_folder wp_valley)
	(object_create_folder sc_valley)

	(pose_body sc_valley_marine_1 pose_on_side_var5)

)

(script static void f_objects_valley_destroy

	(object_destroy_folder dc_valley)
	(object_destroy_folder cr_valley)
	(object_destroy_folder sc_valley)

)

(script static void f_objects_exterior_create

	(object_create_folder dm_exterior)
	(object_create_folder dc_exterior)
	(object_create_folder dt_exterior)
	(object_create_folder wp_exterior)
	(object_create_folder sc_exterior)
	(object_create_folder cr_exterior)

	(pose_body sc_exterior_marine_1 pose_against_wall_var2)
	(pose_body sc_exterior_marine_2 pose_on_side_var1)
	(pose_body sc_exterior_marine_3 pose_against_wall_var1)
	(pose_body sc_exterior_marine_4 pose_against_wall_var2)
	(pose_body sc_exterior_marine_5 pose_against_wall_var3)
	(pose_body sc_exterior_marine_6 pose_face_down_var3)
	(pose_body sc_exterior_marine_7 pose_on_back_var3)
	(pose_body sc_exterior_marine_8 pose_on_side_var4)
	(pose_body sc_exterior_marine_9 pose_face_down_var2)
	(pose_body sc_exterior_marine_10 pose_on_side_var5)

	(if (difficulty_is_legendary) (object_create dt_term_2) (object_destroy dt_term_2) )

)

(script static void f_objects_exterior_destroy

	(object_destroy_folder dm_exterior)
	(object_destroy_folder dc_exterior)
	(object_destroy_folder dt_exterior)
	(object_destroy_folder sc_exterior)
	(object_destroy_folder cr_exterior)

)

(script static void f_objects_interior_create

	(object_create_folder dm_interior)
	(object_create_folder dc_interior)
	(object_create_folder dt_interior)
	(object_create_folder eq_interior)
	(object_create_folder wp_interior)
	(object_create_folder v_interior)
	(object_create_folder sc_interior)
	(object_create_folder cr_interior)

	(object_destroy sc_breach_proxy)
	(object_destroy swordbase_smoke_outside_01)
	(object_destroy swordbase_smoke_outside_02)
	(object_destroy swordbase_smoke_outside_03)

	(pose_body sc_interior_marine_1 pose_on_back_var2)
	(pose_body sc_interior_marine_2 pose_against_wall_var3)
	(pose_body sc_interior_marine_3 pose_face_down_var3)
	(pose_body sc_interior_marine_4 pose_on_side_var3)
	(pose_body sc_interior_marine_5 pose_on_back_var2)

	(if (difficulty_is_normal_or_higher) (object_create dt_term_1) (object_destroy dt_term_1) )

)

(script static void f_objects_interior_destroy

	(object_destroy_folder dm_interior)
	(object_destroy_folder dc_interior)
	(object_destroy_folder dt_interior)
	(object_destroy_folder eq_interior)
	(object_destroy_folder wp_interior)
	(object_destroy_folder v_interior)
	(object_destroy_folder sc_interior)
	(object_destroy_folder cr_interior)

)

(script static void f_objects_outro_destroy

	(object_destroy dm_corvette_exterior)
	(object_destroy dm_corvette_sword)

)

(script dormant f_train_targetlaser

	(wake f_train_targetlaser_0)
	(wake f_train_targetlaser_1)
	(wake f_train_targetlaser_2)
	(wake f_train_targetlaser_3)

)

(script dormant f_train_targetlaser_0

	(sleep_until (unit_has_weapon (player0) objects\weapons\pistol\target_laser\target_laser.weapon))
	(f_hud_training_new_weapon_player player0)

)

(script dormant f_train_targetlaser_1

	(sleep_until (unit_has_weapon (player1) objects\weapons\pistol\target_laser\target_laser.weapon))
	(f_hud_training_new_weapon_player player1)

)

(script dormant f_train_targetlaser_2

	(sleep_until (unit_has_weapon (player2) objects\weapons\pistol\target_laser\target_laser.weapon))
	(f_hud_training_new_weapon_player player2)

)

(script dormant f_train_targetlaser_3

	(sleep_until (unit_has_weapon (player3) objects\weapons\pistol\target_laser\target_laser.weapon))
	(f_hud_training_new_weapon_player player3)

)

(script dormant f_train_armorlock

	(wake f_train_armorlock_0)
	(wake f_train_armorlock_1)
	(wake f_train_armorlock_2)
	(wake f_train_armorlock_3)

)


(script dormant f_train_armorlock_0

	(sleep_until (unit_has_equipment (player0) objects\equipment\armor_lockup\armor_lockup.equipment))
	(f_hud_training_new_weapon_player player0)

)

(script dormant f_train_armorlock_1

	(sleep_until (unit_has_equipment (player1) objects\equipment\armor_lockup\armor_lockup.equipment))
	(f_hud_training_new_weapon_player player1)

)

(script dormant f_train_armorlock_2

	(sleep_until (unit_has_equipment (player2) objects\equipment\armor_lockup\armor_lockup.equipment))
	(f_hud_training_new_weapon_player player2)

)

(script dormant f_train_armorlock_3

	(sleep_until (unit_has_equipment (player3) objects\equipment\armor_lockup\armor_lockup.equipment))
	(f_hud_training_new_weapon_player player3)

)


(script static void f_train_fireteams_1

	(f_hud_training_forever player0 train_fireteams_1)
	(f_hud_training_forever player1 train_fireteams_1)
	(f_hud_training_forever player2 train_fireteams_1)
	(f_hud_training_forever player3 train_fireteams_1)
	(sleep 200)
	(f_hud_training_clear player0)
	(f_hud_training_clear player1)
	(f_hud_training_clear player2)
	(f_hud_training_clear player3)
	(sleep 60)

)

(script dormant f_train_fireteams_2_p0

	(sleep_until (> (ai_living_count sq_player_0) 0) 5)
	(f_train_fireteams_2 player0)

)

(script dormant f_train_fireteams_2_p1

	(sleep_until (> (ai_living_count sq_player_1) 0) 5)
	(f_train_fireteams_2 player1)

)

(script dormant f_train_fireteams_2_p2

	(sleep_until (> (ai_living_count sq_player_2) 0) 5)
	(f_train_fireteams_2 player2)

)

(script dormant f_train_fireteams_2_p3

	(sleep_until (> (ai_living_count sq_player_3) 0) 5)
	(f_train_fireteams_2 player3)

)

(script static void (f_train_fireteams_2 (player p))

	(f_hud_training_forever p train_fireteams_2)
	(sleep 200)
	(f_hud_training_clear p)

)



; =================================================================================================
; =================================================================================================
; VEHICLES
; =================================================================================================
; =================================================================================================

(global short vehicle_none 1)
(global short vehicle_air 1)
(global short vehicle_far 2)
(global short vehicle_return 3)
(global short vehicle_airorfar 4)

(script static void (f_vehicle_goto_set (short dir))

	(if (= dir vehicle_none) (set s_vehicle_goto_idx 0))
	(if (= dir vehicle_air) (set s_vehicle_goto_idx 1))
	(if (= dir vehicle_far) (set s_vehicle_goto_idx 2))
	(if (= dir vehicle_return) (set s_vehicle_goto_idx 3))
	(if (= dir vehicle_airorfar) (set s_vehicle_goto_idx (random_range 1 3)))

)

(global short s_vehicle_goto_idx 0) ; 0-null,1-airview,2-farragut,3-return
(script command_script f_cs_vehicle_rollout

	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)

	(sleep_until

		(begin

				(ai_vehicle_enter ai_current_actor (ai_vehicle_get ai_current_actor))

				; Driving ai - if ai is in driver seat
				(if (vehicle_test_seat_unit (ai_vehicle_get ai_current_actor) "warthog_d" ai_current_actor) (begin
				
					(if (= s_vehicle_goto_idx vehicle_air) (begin

						(if (volume_test_objects tv_vehicle_far_cross ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_far/cross) ) )
						(if (volume_test_objects tv_vehicle_far_tunnel ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_far/tunnel) ) )
						(if (volume_test_objects tv_vehicle_far_ledge ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_far/ledge) ) )
						(if (volume_test_objects tv_vehicle_far_center ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_far/center) ) )
						(if (volume_test_objects tv_vehicle_far_ramp ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_far/ramp) ) )
						(if (volume_test_objects tv_vehicle_far_dock ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_far/dock) ) )
						(if (volume_test_objects tv_vehicle_far_bank ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_far/bank) ) )
						(if (volume_test_objects tv_vehicle_far_bowl ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_far/bowl) ) )
						(if (volume_test_objects tv_vehicle_airfar_fork ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_far/fork) ) )
						(if (volume_test_objects tv_vehicle_airfar_runoff ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_far/runoff) ) )
						(if (volume_test_objects tv_vehicle_airfar_ridge ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_far/ridge) ) )
						(if (volume_test_objects tv_vehicle_airfar_twist ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_far/twist) ) )
						(if (volume_test_objects tv_vehicle_airfar_river ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_air/river) ) )
						(if (volume_test_objects tv_vehicle_airfar_cliff ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_air/cliff) ) )
						(if (volume_test_objects tv_vehicle_airfar_dip ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_air/dip) ) )
						(if (volume_test_objects tv_vehicle_valley_foyer ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_far/foyer) ) )
						(if (volume_test_objects tv_vehicle_valley_ice ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_valley/ice) ) )
						(if (volume_test_objects tv_vehicle_valley_beach ai_current_actor) (begin (cs_vehicle_speed .7) (cs_go_to ps_vehicles_air_valley/beach) ) )
						(if (volume_test_objects tv_vehicle_valley_elbow ai_current_actor) (begin (cs_vehicle_speed .7) (cs_go_to ps_vehicles_air_valley/elbow) ) )
						(if (volume_test_objects tv_vehicle_valley_snake ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_valley/snake) ) )
						(if (volume_test_objects tv_vehicle_valley_stream ai_current_actor) (begin (cs_vehicle_speed .8) (cs_go_to ps_vehicles_air_valley/stream) ) )
						(if (volume_test_objects tv_vehicle_valley_marcela ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_valley/marcela) ) )
						(if (volume_test_objects tv_vehicle_valley_gate ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_valley/gate) ) )
						(if (volume_test_objects tv_vehicle_valley_neck ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_valley/neck) ) )
						(if (volume_test_objects tv_vehicle_valley_triangle ai_current_actor) (begin (cs_vehicle_speed .5) (cs_go_to ps_vehicles_air_valley/triangle) ) )
						(if (volume_test_objects tv_vehicle_valley_split ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_valley/split) ) )
						(if (volume_test_objects tv_vehicle_valley_peak ai_current_actor) (begin (cs_vehicle_speed .6) (cs_go_to ps_vehicles_air_valley/peak) ) )
						(if (volume_test_objects tv_vehicle_valley_alley ai_current_actor) (begin (cs_vehicle_speed .8) (cs_go_to ps_vehicles_air_valley/alley) ) )
						(if (volume_test_objects tv_vehicle_valley_bridge ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_valley/bridge) ) )
						(if (volume_test_objects tv_vehicle_valley_stream ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_valley/stream) ) )
						(if (volume_test_objects tv_vehicle_valley_wall ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_valley/wall) ) )
						(if (volume_test_objects tv_vehicle_valley_hill ai_current_actor) (begin (cs_vehicle_speed .8) (cs_go_to ps_vehicles_air_valley/hill) ) )
						(if (volume_test_objects tv_vehicle_valley_pipe ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_air/pipe) ) )
						(if (volume_test_objects tv_vehicle_air_view ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_air_air/view) ) )

	
					))
	
					(if (= s_vehicle_goto_idx vehicle_far) (begin
	
						(if (volume_test_objects tv_vehicle_air_view ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_air/view) ) )
						(if (volume_test_objects tv_vehicle_air_look ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_air/look) ) )
						(if (volume_test_objects tv_vehicle_air_antenna ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_air/antenna) ) )
						(if (volume_test_objects tv_vehicle_air_lake ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_air/lake) ) )
						(if (volume_test_objects tv_vehicle_air_over ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_air/over) ) )
						(if (volume_test_objects tv_vehicle_air_platform ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_air/platform) ) )
						(if (volume_test_objects tv_vehicle_air_garage ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_air/garage) ) )
						(if (volume_test_objects tv_vehicle_air_road ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_air/road) ) )
						(if (volume_test_objects tv_vehicle_air_back ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_air/back) ) )
						(if (volume_test_objects tv_vehicle_air_nexus ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_air/nexus) ) )
						(if (volume_test_objects tv_vehicle_air_crest ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_air/crest) ) )
						(if (volume_test_objects tv_vehicle_airfar_dip ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_air/dip) ) )
						(if (volume_test_objects tv_vehicle_airfar_cliff ai_current_actor) (begin (cs_vehicle_speed .8) (cs_go_to ps_vehicles_far_air/cliff) ) )
						(if (volume_test_objects tv_vehicle_airfar_river ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_far/river) ) )
						(if (volume_test_objects tv_vehicle_airfar_twist ai_current_actor) (begin (cs_vehicle_speed .8) (cs_go_to ps_vehicles_far_far/twist) ) )
						(if (volume_test_objects tv_vehicle_airfar_ridge ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_far/ridge) ) )
						(if (volume_test_objects tv_vehicle_airfar_runoff ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_far/runoff) ) )
						(if (volume_test_objects tv_vehicle_airfar_fork ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_far/fork) ) )
						(if (volume_test_objects tv_vehicle_valley_pipe ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/pipe) ) )
						(if (volume_test_objects tv_vehicle_valley_hill ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/hill) ) )
						(if (volume_test_objects tv_vehicle_valley_wall ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/wall) ) )
						(if (volume_test_objects tv_vehicle_valley_bridge ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/bridge) ) )
						(if (volume_test_objects tv_vehicle_valley_triangle ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/triangle) ) )
						(if (volume_test_objects tv_vehicle_valley_peak ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/peak) ) )
						(if (volume_test_objects tv_vehicle_valley_alley ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/alley) ) )
						(if (volume_test_objects tv_vehicle_valley_neck ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/neck) ) )
						(if (volume_test_objects tv_vehicle_valley_split ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/split) ) )
						(if (volume_test_objects tv_vehicle_valley_marcela ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/marcela) ) )
						(if (volume_test_objects tv_vehicle_valley_gate ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/gate) ) )
						(if (volume_test_objects tv_vehicle_valley_stream ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/stream) ) )
						(if (volume_test_objects tv_vehicle_valley_snake ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/snake) ) )
						(if (volume_test_objects tv_vehicle_valley_elbow ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/elbow) ) )
						(if (volume_test_objects tv_vehicle_valley_beach ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_valley/beach) ) )
						(if (volume_test_objects tv_vehicle_valley_ice ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_far/ice) ) )
						(if (volume_test_objects tv_vehicle_valley_foyer ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_far_far/foyer) ) )
	
					))
	
					(if (= s_vehicle_goto_idx vehicle_return) (begin
	
						(if (volume_test_objects tv_vehicle_airfar_river ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_far/river) ) )
						(if (volume_test_objects tv_vehicle_airfar_twist ai_current_actor) (begin (cs_vehicle_speed .8) (cs_go_to ps_vehicles_valley_far/twist) ) )
						(if (volume_test_objects tv_vehicle_airfar_ridge ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_far/ridge) ) )
						(if (volume_test_objects tv_vehicle_airfar_runoff ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_far/runoff) ) )
						(if (volume_test_objects tv_vehicle_airfar_fork ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_far/fork) ) )
						(if (volume_test_objects tv_vehicle_airfar_cliff ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_air/cliff) ) )
						(if (volume_test_objects tv_vehicle_airfar_dip ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_air/dip) ) )
						(if (volume_test_objects tv_vehicle_air_garage ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_air/garage) ) )
						(if (volume_test_objects tv_vehicle_air_back ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_air/back) ) )
						(if (volume_test_objects tv_vehicle_air_platform ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_air/platform) ) )
						(if (volume_test_objects tv_vehicle_air_over ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_air/over) ) )
						(if (volume_test_objects tv_vehicle_air_antenna ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_air/antenna) ) )
						(if (volume_test_objects tv_vehicle_air_lake ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_air/lake) ) )
						(if (volume_test_objects tv_vehicle_air_look ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_air/look) ) )
						(if (volume_test_objects tv_vehicle_air_crest ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_air/crest) ) )
						(if (volume_test_objects tv_vehicle_air_nexus ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_air/nexus) ) )
						(if (volume_test_objects tv_vehicle_air_road ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_air/road) ) )
						(if (volume_test_objects tv_vehicle_air_view ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_air/view) ) )
						(if (volume_test_objects tv_vehicle_far_cross ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_far/cross) ) )
						(if (volume_test_objects tv_vehicle_far_ledge ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_far/ledge) ) )
						(if (volume_test_objects tv_vehicle_far_tunnel ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_far/tunnel) ) )
						(if (volume_test_objects tv_vehicle_far_center ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_far/center) ) )
						(if (volume_test_objects tv_vehicle_far_dock ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_far/dock) ) )
						(if (volume_test_objects tv_vehicle_far_ramp ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_far/ramp) ) )
						(if (volume_test_objects tv_vehicle_far_bowl ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_far/bowl) ) )
						(if (volume_test_objects tv_vehicle_far_bank ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_far/bank) ) )
						(if (volume_test_objects tv_vehicle_valley_pipe ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_valley/pipe) ) )
						(if (volume_test_objects tv_vehicle_valley_hill ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_valley/hill) ) )
						(if (volume_test_objects tv_vehicle_valley_wall ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_valley/wall) ) )
						(if (volume_test_objects tv_vehicle_valley_bridge ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_valley/bridge) ) )
						(if (volume_test_objects tv_vehicle_valley_snake ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_valley/snake) ) )
						(if (volume_test_objects tv_vehicle_valley_stream ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_valley/stream) ) )
						(if (volume_test_objects tv_vehicle_valley_elbow ai_current_actor) (begin (cs_vehicle_speed .7) (cs_go_to ps_vehicles_valley_valley/elbow) ) )
						(if (volume_test_objects tv_vehicle_valley_beach ai_current_actor) (begin (cs_vehicle_speed .7) (cs_go_to ps_vehicles_valley_valley/beach) ) )
						(if (volume_test_objects tv_vehicle_valley_ice ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_valley/ice) ) )
						(if (volume_test_objects tv_vehicle_valley_foyer ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_far/foyer) ) )
						(if (volume_test_objects tv_vehicle_valley_triangle ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_valley/triangle) ) )
						(if (volume_test_objects tv_vehicle_valley_split ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_valley/split) ) )
						(if (volume_test_objects tv_vehicle_valley_neck ai_current_actor) (begin (cs_vehicle_speed 1) (cs_go_to ps_vehicles_valley_valley/neck) ) )

	
					))

				))

		false)
	
	5)

)

; =================================================================================================
; =================================================================================================
; COURTYARD
; =================================================================================================
; =================================================================================================

; Courtyard Globals
(global short s_court_aa_repair_secs 125)
(global short s_court_aa_repair_secs_interval 0)
(global boolean b_court_aa_repair_ready FALSE)

(global short s_court_wave 0)
(global boolean b_court_phantom_elbow_spawned FALSE)

; Courtyard Main
(script dormant f_court_main

	(sleep_until (= b_mission_started TRUE))

	(dprint "::: courtyard encounter :::")
	
	; set first mission segment
	(data_mine_set_mission_segment "m20_01_courtyard")
	
	(set b_court_ready TRUE)
	(set s_wave_spawning 0)

	(f_ai_detail ai_detail_high)
	(f_zoneset_direction direction_outward)
	(airstrike_set_launches 2)

	(wake f_court_zoneset_valley)

	(wake f_gatehouse_door_control)

	; Standard scripts
	(wake f_court_save_control)
	(wake f_court_waypoint_control)
	(wake f_court_missionobj_control)
	(wake f_court_music_control)
	(wake f_court_md_control)
	(wake f_court_spawn_control)

	; Encounter scripts
	(wake f_court_flock_control)
	(wake f_court_cleanup_control)
	(wake f_train_targetlaser)
	(wake f_train_armorlock)

	; start
	(if b_debug (print "objective control : courtyard.1"))

	(unit_raise_weapon (player0) 1)
	(unit_raise_weapon (player1) 1)
	(unit_raise_weapon (player2) 1)
	(unit_raise_weapon (player3) 1)

	(set s_objcon_court 1)
	(f_cin_intro_finish)
	(cinematic_exit_into_title 020la_sword TRUE)

	(sleep_until (volume_test_players tv_court_ramps) 5)
	(if b_debug (print "objective control : courtyard.05"))
	(set s_objcon_court 5)

	(sleep_until (volume_test_players tv_court_ledge) 5)
	(if b_debug (print "objective control : courtyard.10"))
	(set s_objcon_court 10)

	(sleep_until (volume_test_players tv_court_barricade) 5)
	(if b_debug (print "objective control : courtyard.20"))
	(set s_objcon_court 20)

	(sleep_until (volume_test_players tv_court_garage) 5)
	(if b_debug (print "objective control : courtyard.30"))
	(set s_objcon_court 30)

	(sleep_until (volume_test_players tv_court_elbow) 5)
	(if b_debug (print "objective control : courtyard.40"))
	(set s_objcon_court 40)

	(sleep_until (volume_test_players tv_court_elbow_mid) 5)
	(if b_debug (print "objective control : courtyard.45"))
	(set s_objcon_court 45)

	(sleep_until b_court_defended)
	(if b_debug (print "objective control : courtyard.50"))
	(set s_objcon_court 50)

)

(script dormant f_court_flock_control

	(flock_create flock_exterior_banshee_01)
	(flock_create flock_exterior_banshee_02)
	(flock_create flock_exterior_falcon_01)
	(flock_create flock_exterior_falcon_02)
	(flock_create flock_exterior_phantom_01)

)

(script dormant f_court_zoneset_valley

	(sleep (* 30 5))
	(prepare_to_switch_to_zone_set zoneset_courtyard_valley)
	(sleep (* 30 20))
	(switch_zone_set zoneset_courtyard_valley)
	(soft_ceiling_enable camera_blocker_06 0)

)


(script dormant	f_court_save_control

	(sleep_until (>= s_objcon_court 1))
	(game_save_immediate)

	(sleep_until (>= s_objcon_court 40))
	(game_save_no_timeout)

	(sleep_until (>= s_objcon_court 50))
	(game_save_no_timeout)

)

(script dormant	f_court_missionobj_control

	(sleep_until (>= s_objcon_court 1))
	(tit_courtyard)
	(sleep 200)
	(mo_courtyard)

)

(global short s_court_waypoint_timer 240)
(script dormant f_court_waypoint_control

	; Nonlinear

	; Linear
	(sleep_until (>= s_objcon_court 40) 5 (* 30 240))
	(if (not (>= s_objcon_court 40))
		(begin
			(f_blip_flag fl_court_waypoint_1 blip_destination)
			(sleep_until (>= s_objcon_court 40) 5)
			(f_unblip_flag fl_court_waypoint_1)
		)
	)

)

(script dormant	f_court_music_control

	(sleep_until (>= s_objcon_court 1) 5)
	(wake music_court)

)

(script dormant f_court_md_control

	(sleep_until (>= s_objcon_court 1) 1)
	(md_court_intro)
	(sleep 100)
	(md_court_north)

	(sleep_until (>= s_objcon_court 50) 1)
	(md_court_combatend)

)

(script dormant f_court_spawn_control

	(if b_debug (print "::: spawning all courtyard squads"))

	(f_squad_group_place gr_court_cov_init)
	
	(if (game_is_cooperative) (begin
	
		(if (= (game_coop_player_count) 2) (begin
		
			(ai_place sq_court_marine_init_1/marine_1)
			(ai_place sq_court_marine_init_1/marine_2)
			(ai_place sq_court_marine_init_2/marine_1)
			
		))

		(if (= (game_coop_player_count) 2) (begin
		
			(ai_place sq_court_marine_init_1/marine_1)
			(ai_place sq_court_marine_init_1/marine_2)

		))

		(if (= (game_coop_player_count) 3) (begin

			(ai_place sq_court_marine_init_1/marine_1)		

		))
		
	)(begin

		(f_squad_group_place gr_court_hum_init)
	
	))
	
	;(f_squad_group_place gr_court_hum_init)

	; Dropship 1
	(sleep_until
		(or
			(<= (ai_living_count obj_court_cov) 4)
			(volume_test_players tv_court_ramps)
		)
	5)
	(ai_place sq_court_phantom_w1)
	(ai_place sq_court_cov_w1_3)
	(ai_place sq_court_cov_w1_4)
	(set s_court_wave 1)

	(sleep_until (volume_test_players tv_court_elbow) 5)
	(ai_place gr_court_cov_elbow)

	; Defend courtyard
	(sleep_until
		(and
			(<= (ai_living_count obj_court_cov) 0)
			(or
				(not b_court_phantom_w1_spawn)
				(<= (object_get_health (ai_vehicle_get_from_squad sq_court_phantom_w1 0) ) 0)
			)
		)
	5)
	(set b_court_defended TRUE)

)

(script dormant f_court_boss_death_tracker

	(sleep (* 30 6))
	(sleep_until (<= (ai_living_count sq_court_cov_w1_1) 0) 5)
	(set s_music_court 2)

)

(global boolean b_court_phantom_w1_spawn FALSE)
(script command_script f_cs_court_phantom_w1

	(cs_enable_pathfinding_failsafe TRUE)
	(cs_enable_targeting TRUE)
	(cs_ignore_obstacles TRUE)

	(set b_court_phantom_w1_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(f_load_phantom (ai_vehicle_get ai_current_actor) "chute" sq_court_cov_w1_1 sq_court_cov_w1_2 NONE NONE)
	(cs_fly_by ps_court_phantom_w1/enter_01)
	(cs_fly_by ps_court_phantom_w1/enter_02)
	(cs_fly_by ps_court_phantom_w1/enter_03)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_court_phantom_w1/hover_in ps_court_phantom_w1/hover_in_face .1)

	;(wake f_md_court_drop_0)
	;(wake f_court_phantom_point)
	(cs_fly_to_and_face ps_court_phantom_w1/drop ps_court_phantom_w1/drop_face .1)
	(print "drop")
	(f_unload_phantom (ai_vehicle_get ai_current_actor) "chute")
	(set b_court_phantom_w1_spawn FALSE)
	(wake f_md_court_contacts_0)
	(wake f_court_boss_death_tracker)
	(cs_fly_to_and_face ps_court_phantom_w1/hover_out ps_court_phantom_w1/hover_out_face)
	(cs_enable_targeting FALSE)
	(cs_vehicle_speed 1)
	(cs_fly_to_and_face ps_court_phantom_w1/exit_01 ps_court_phantom_w1/exit_01_face)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_to_and_face ps_court_phantom_w1/erase ps_court_phantom_w1/erase_face)
	(ai_erase ai_current_squad)

)

(script dormant f_md_court_drop_0

	(md_court_drop_0)

)

(script dormant f_md_court_contacts_0

	(md_court_contacts_0)

)


(script dormant f_court_phantom_point

	(sleep 90)
	(thespian_performance_setup_and_begin th_court_elbow_look "" 25)

)

(script static void f_court_cleanup

	(sleep_forever f_court_main)

)


(script static void f_court_despawn_prev

	(sleep 0)

)


(script static void f_court_despawn_all

	(ai_erase gr_court_cov)

)


(script static void f_court_kill_scripts

	(sleep 0)

)


(script dormant f_court_cleanup_control

	(sleep_until (= 1 0) 5)
	(f_court_despawn_all)
	(f_court_kill_scripts)

)

; =================================================================================================
; =================================================================================================
; EXTERIOR
; =================================================================================================
; =================================================================================================

(script dormant f_exterior_cleanup

	(sleep_until
		(begin
		
			; Airview Cleanup
			(if 
				(and
					b_air_defended
					(not (volume_test_players tv_area_air_wide))
				)
				(begin
					(print "cleanup airview")
					(ai_erase sq_air_cov_init_1)
					(ai_erase sq_air_cov_init_2)
					(ai_erase sq_air_cov_init_3)
					(ai_erase sq_air_cov_init_4)
					(ai_erase sq_air_cov_counter_1_1)
					(ai_erase sq_air_cov_counter_1_2)
					(ai_erase sq_air_cov_counter_1_3)
				)
			)

			; Farragut Cleanup
			(if 
				(and
					b_far_defended
					(not (volume_test_players tv_area_far_wide))
				)
				(begin
					(print "cleanup farragut")
					(ai_erase sq_far_cov_init_1)
					(ai_erase sq_far_cov_init_2)
					(ai_erase sq_far_grunt_init_1)
					(ai_erase sq_far_jackalsniper_init_1)
					(ai_erase sq_far_cov_counter_1_1)
					(ai_erase sq_far_cov_counter_1_2)
					(ai_erase sq_far_cov_counter_1_3)
					(ai_erase sq_far_cov_counter_1_4)
				)
			)

			; Valley Cleanup
			(if 
				(and
					(or
						(volume_test_players tv_area_air_wide)
						(volume_test_players tv_area_far_wide)
						(volume_test_players tv_area_airfar_wide)
					)
					(not (volume_test_players tv_area_valley))
				)
				(begin
					(print "cleanup valley")
					(ai_erase gr_court_hum_init)
					(ai_erase sq_valley_cov_1)
				)
			)

			; Valley Wide Cleanup
			(if 
				(and
					(volume_test_players tv_area_airfar_wide)
					(not (volume_test_players tv_area_valley_wide))
				)
				(begin
					(print "cleanup valley wide")
					(ai_erase sq_valley_cov_air)
					(ai_erase sq_valley_cov_far)
				)
			)

			; Air Far Cleanup
			(if 
				(and
					(volume_test_players tv_area_valley_wide)
					(not (volume_test_players tv_area_airfar_wide))
				)
				(begin
					(print "cleanup air far")
					(ai_erase sq_air_far_cov_w1_1)
					(ai_erase sq_air_far_cov_w1_2)
				)
			)
		
		FALSE)
	90)

)

; =================================================================================================
; =================================================================================================
; VALLEY
; =================================================================================================
; =================================================================================================

(script dormant f_valley_main

	(sleep_until
		(and
			(= b_court_defended TRUE)
			TRUE
		)
	5)
	
    (dprint "::: valley encounter :::")
	
	; set second mission segment
	(data_mine_set_mission_segment "m20_02_valley")
	
	(set s_objcon_valley 1)

	(ai_set_objective gr_hum obj_valley_hum)
	(ai_set_objective gr_spartans obj_valley_hum)

	(f_zoneset_direction direction_outward)
	(f_loadout_set "exterior")

	; Standard scripts
	(wake f_valley_save_control)
	(wake f_valley_missionobj_control)
	(wake f_valley_waypoint_control)
	(wake f_valley_spawn_control)
	(wake f_valley_md_control)
	(wake f_valley_music_control)

	; Encounter scripts
	(wake f_valley_warthog_kill)
	(wake f_valley_pelican_hog)
	(wake f_valley_troophog_join)

	; Objective 1
	(if b_debug (print "objective control : valley.01"))
	(set b_insertion_fade_in TRUE)
	(set s_objcon_valley 1)

	; Objective 5
	(sleep_until (volume_test_players tv_valley_05) 5)
	(if b_debug (print "objective control : valley.05"))
	(set s_objcon_valley 5)

	; Objective 7
	(sleep_until b_gatehouse_door_open)
	(if b_debug (print "objective control : valley.07"))
	(set s_objcon_valley 7)

	(game_insertion_point_unlock 1)
	(f_ai_detail ai_detail_low)
	(wake f_exterior_cleanup)

	; Objective 10
	(sleep_until (volume_test_players tv_valley_10) 5)
	(if b_debug (print "objective control : valley.10"))
	(set s_objcon_valley 10)

	; Objective 20
	(sleep_until (volume_test_players tv_valley_20) 5)
	(if b_debug (print "objective control : valley.20"))
	(set s_objcon_valley 20)

	; Objective 30
	(sleep_until (volume_test_players tv_valley_30) 5)
	(if b_debug (print "objective control : valley.30"))
	(set s_objcon_valley 30)

	; Objective 40
	(sleep_until
		(or
			(volume_test_players tv_valley_exit_to_airview)
			(volume_test_players tv_valley_exit_to_faragate)
		)
	5)
	(if b_debug (print "objective control : valley.40"))
	(set s_objcon_valley 40)

	(set s_music_court 4)
	(set s_music_valley 4)

)

(script dormant f_valley_troophog_join

	(sleep_until
		(or
			(>= s_objcon_valley 40)
			b_valley_hog_drop_start
		)
	)
	(ai_set_objective sq_valley_warthog obj_vehicles_hum)

)

(script dormant f_valley_save_control

	; Nonlinear
	(wake f_valley_save_combatend)

	; Linear
	(sleep_until (>= s_objcon_valley 1))
	(game_save_no_timeout)

	(sleep_until (>= s_objcon_valley 5))
	(game_save_no_timeout)

)


(script dormant f_valley_save_combatend

	(sleep_until (> (ai_living_count gr_valley_cov) 0) 3)
	(tick)
	(sleep_until (<= (ai_living_count gr_valley_cov) 0) 3)
	(game_save_no_timeout)

)

(script dormant f_valley_missionobj_control

	(sleep_until (>= s_objcon_valley 7))
	(tit_valley)
	(sleep 200)
	(mo_valley)

)

(global short s_valley_waypoint_timer 90)
(script dormant f_valley_waypoint_control

	(sleep_until (player_in_vehicle sq_valley_warthog_drop) 1)
	(sleep_until (>= s_objcon_valley 40) 5 (* 30 s_valley_waypoint_timer))
	(if (not (>= s_objcon_valley 40))
		(begin
			(f_blip_flag fl_valley_waypoint_1_1 blip_destination)
			(f_blip_flag fl_valley_waypoint_1_2 blip_destination)
			(sleep_until (>= s_objcon_valley 40) 5)
			(f_unblip_flag fl_valley_waypoint_1_1)
			(f_unblip_flag fl_valley_waypoint_1_2)
		)
	)

)

(script dormant f_valley_music_control

	(if b_valley_ins
		(begin
			(wake music_valley)
			(set s_music_valley 3)	
		)
	)

)

(script dormant f_valley_md_control

	; Conditional
	(wake f_md_valley_airtagger)
	(wake f_md_valley_tagshoot)
	(wake f_md_valley_choice)

	; Linear

	(if (> (game_coop_player_count) 2) (begin

		(sleep_until (>= s_objcon_valley 20))
		(md_valley_trooper_near)

	) )

)

(script dormant f_md_valley_airtagger

	(branch
		(or
			(>= s_objcon_air 1)
			(>= s_objcon_far 1)
		)
		(f_abort)
	)

	(sleep_until (>= s_objcon_valley 5) 5)
	(md_valley_airtagger)

	(sleep_until b_airtagger_taken 5 (* 30 60))
	(if (not b_airtagger_taken)
		(begin
			(md_valley_airtagger_delay_0)
		)
	)

	(sleep_until b_airtagger_taken 5 (* 30 60))
	(if (not b_airtagger_taken)
		(begin
			(md_valley_airtagger_delay_1)
		)
	)

	(sleep_until b_airtagger_taken 5 (* 30 60))
	(if (not b_airtagger_taken)
		(begin
			(md_valley_airtagger_delay_2)
		)
	)

)


(script dormant f_md_valley_tagshoot

	(branch
		(or
			(>= s_objcon_air 1)
			(>= s_objcon_far 1)
		)
		(f_abort)
	)

	(sleep_until (> (ai_task_count obj_valley_cov/gate_wraiths) 0 ) 5)

	; wraith kill reminder	
	(sleep_until (<= (ai_task_count obj_valley_cov/gate_wraiths) 0 ) 1 (* 30 20) )
	(if (not (<= (ai_task_count obj_valley_cov/gate_wraiths) 0 ) )
		(begin
			(md_valley_tagshoot_delay_0)
		)
	)

	(sleep_until (<= (ai_task_count obj_valley_cov/gate_wraiths) 0 ) 1 (* 30 60) )
	(if (not (<= (ai_task_count obj_valley_cov/gate_wraiths) 0 ) )
		(begin
			(md_valley_tagshoot_delay_1)
		)
	)

)


(script dormant f_md_valley_choice

	(sleep_until
		(or
			(player_in_vehicle sq_valley_warthog_drop)
			(>= s_objcon_valley 40)
		)
	1)
	
	(sleep (* 30 (random_range 1 2)))
	(md_valley_choice)

	(sleep_until (>= s_objcon_valley 40) 1 (* 30 90))
	(if (not (>= s_objcon_valley 40) )
		(begin
			(md_valley_choice_delay_0)
		)
	)
	
	(sleep_until (>= s_objcon_valley 40) 1)
	(if (volume_test_players tv_valley_exit_to_airview) (md_valley_choice_air))
	(if (volume_test_players tv_valley_exit_to_faragate) (md_valley_choice_far))

)

(script dormant f_valley_spawn_control

	(f_squad_group_place gr_valley_cov_init)

	(if (= (game_coop_player_count) 1)(begin

		(f_squad_group_place gr_valley_hum_init)

	))
	(if (= (game_coop_player_count) 2)(begin

		(ai_place sq_valley_marines_1/marine_1)
		(ai_place sq_valley_marines_1/marine_2)

	))
	(if (= (game_coop_player_count) 3)(begin

		(ai_place sq_valley_marines_1/marine_1)

	))

	(if (>= (game_coop_player_count) 3) (ai_place sq_valley_troophog) )

	(wake f_valley_spawn_air)
	(wake f_valley_spawn_far)

)

(global boolean b_valley_spawn_air FALSE)
(script dormant f_valley_spawn_air

	(sleep_until (volume_test_players tv_valley_exit_to_airview) 5)
	(sleep_forever f_valley_spawn_far)
	(set b_valley_spawn_air TRUE)
	(ai_place gr_valley_cov_air)

)

(global boolean b_valley_spawn_far FALSE)
(script dormant f_valley_spawn_far

	(sleep_until (volume_test_players tv_valley_exit_to_faragate) 5)
	(sleep_forever f_valley_spawn_air)
	(set b_valley_spawn_far TRUE)
	(ai_place gr_valley_cov_far)

)

(script dormant f_valley_warthog_kill


	(sleep_until (>= s_objcon_valley 10))
	(ai_place sq_valley_warthog)
	(ai_squad_enumerate_immigrants sq_valley_warthog TRUE)

	(cs_run_command_script sq_valley_warthog/driver01 f_cs_sleep)

	(ai_place sq_valley_wraith_1)
	(ai_place sq_valley_wraith_2)

	(wake f_md_valley_hogkill)

	(cs_run_command_script sq_valley_warthog/driver01 f_cs_valley_warthog)

	(sleep 40)
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_valley_wraith_1/driver01))
	(object_can_take_damage (ai_vehicle_get_from_starting_location sq_valley_wraith_2/driver01))
	(cs_run_command_script sq_valley_wraith_1/driver01 f_cs_valley_wraith_1)
	(cs_run_command_script sq_valley_wraith_2/driver01 f_cs_valley_wraith_2)

)

(script dormant f_md_valley_hogkill

	(md_valley_hogkill) 

)

(global boolean b_valley_warthog_deadend FALSE)
(global boolean b_valley_warthog_killed FALSE)
(script command_script f_cs_valley_warthog

	(effect_new_on_object_marker_loop objects\vehicles\human\warthog\fx\destruction\body_constant_major.effect (ai_vehicle_get_from_starting_location sq_valley_warthog/driver01) "")

	(cs_enable_moving TRUE)
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)

	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_go_to ps_valley_warthog/move_01)
	(cs_go_to ps_valley_warthog/move_02)
	(cs_go_to ps_valley_warthog/move_03)
	(sleep 50)
	(object_damage_damage_section (ai_vehicle_get_from_starting_location sq_valley_warthog/driver01) "hull_front" 999)
	(effect_stop_object_marker objects\vehicles\human\warthog\fx\destruction\body_constant_major.effect (ai_vehicle_get_from_starting_location sq_valley_warthog/driver01) "")
	(set b_valley_warthog_deadend TRUE)
	(set b_valley_warthog_killed TRUE)

	;(unit_set_current_vitality (ai_vehicle_get_from_starting_location sq_valley_warthog/driver01) 10 0)
	;(unit_set_maximum_vitality (ai_vehicle_get_from_starting_location sq_valley_warthog/driver01) 10 0)

	;(sleep_until (< (unit_get_health sq_valley_warthog) 0) (* 30 10))
	;(ai_kill sq_valley_warthog)

)

(script command_script f_cs_valley_wraith_1

	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)

	(cs_go_to_and_face ps_valley_wraith_1/move_01 ps_valley_wraith_1/shoot)
	(cs_shoot TRUE (ai_vehicle_get_from_starting_location sq_valley_warthog/driver01))
	(sleep_until
		(or (>= s_objcon_valley 30)
			(<= (unit_get_health (ai_vehicle_get sq_valley_warthog/driver01)) 0)
		)
	5 480)
	(ai_set_blind ai_current_squad FALSE)
	(ai_set_deaf ai_current_squad FALSE)

)

(script command_script f_cs_valley_wraith_2

	(cs_enable_targeting TRUE)
	(cs_enable_looking TRUE)

	(cs_go_to_and_face ps_valley_wraith_2/move_01 ps_valley_wraith_2/shoot)
	(cs_shoot TRUE (ai_vehicle_get_from_starting_location sq_valley_warthog/driver01))
	(sleep_until
		(or (>= s_objcon_valley 30)
			(<= (unit_get_health (ai_vehicle_get sq_valley_warthog/driver01)) 0)
		)
	5 480)
	(ai_set_blind ai_current_squad FALSE)
	(ai_set_deaf ai_current_squad FALSE)

)

(global boolean b_valley_hog_drop FALSE)
(global boolean b_valley_hog_drop_start FALSE)
(script dormant f_valley_pelican_hog

	(sleep_until (> (ai_living_count gr_valley_cov_init) 0) )

	(sleep_until
		(and
			(<= (ai_living_count gr_valley_cov_wraiths) 0)
			(<= (ai_living_count gr_valley_cov_init) 2)
		)
	3 )

	(set b_valley_hog_drop_start TRUE)
	(dprint "valley pelican")
	(ai_place sq_valley_pelican)
	(md_valley_wraiths_dead)
	(f_vehicle_goto_set vehicle_airorfar)

)

(global boolean b_sq_valley_pelican_spawn FALSE)
(script command_script f_cs_valley_pelican

	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)

	(object_cannot_die sq_valley_pelican TRUE)
	(ai_place sq_valley_warthog_drop)
	(ai_squad_enumerate_immigrants sq_valley_warthog_drop TRUE)	
	(wake f_valley_hog_blip)

	(vehicle_load_magic
		(ai_vehicle_get ai_current_actor) "pelican_lc"
		(ai_vehicle_get_from_starting_location sq_valley_warthog_drop/driver01)
	)

	(set b_sq_valley_pelican_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get sq_valley_warthog_drop) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(object_set_scale (ai_vehicle_get sq_valley_warthog_drop) 1 (* 30 5))
	(cs_fly_by ps_valley_pelican/enter_01)
	(cs_fly_by ps_valley_pelican/enter_02)
	(wake f_md_valley_hog)
	(cs_fly_by ps_valley_pelican/hover_in)
	(cs_vehicle_speed .7)
	(cs_fly_to_and_face ps_valley_pelican/drop ps_valley_pelican/drop_face .1)
	(sleep 60)
	(sleep_until (not (volume_test_players tv_valley_pelican_drop)) 5)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_lc")
	(set b_valley_hog_drop TRUE)
	(sleep 100)
	(set b_sq_valley_pelican_spawn FALSE)
	(cs_fly_by ps_valley_pelican/hover_out)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_valley_pelican/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_valley_pelican/erase)
	(ai_erase ai_current_squad)

)

(script dormant f_valley_hog_blip

	(f_blip_object_offset (ai_vehicle_get_from_starting_location sq_valley_warthog_drop/driver01) 5 1)
	
	(sleep_until
		(or
			(player_in_vehicle sq_valley_warthog_drop)
			(volume_test_players tv_valley_exit_to_airview)
			(volume_test_players tv_valley_exit_to_faragate)
		)
	5)
	(f_unblip_object (ai_vehicle_get_from_starting_location sq_valley_warthog_drop/driver01))

)

(script dormant f_md_valley_hog

	(md_valley_hog)

)

(script static void f_valley_cleanup

	(sleep_forever f_valley_main)
	(sleep_forever f_valley_spawn_control)
	(sleep_forever f_valley_md_control)
	(sleep_forever f_valley_warthog_kill)

)

; =================================================================================================
; =================================================================================================
; FARRAGUT
; =================================================================================================
; =================================================================================================

(global boolean b_far_comm_on FALSE)
(global boolean b_far_generator_on FALSE)
(script dormant f_far_main

	(sleep_until (volume_test_players tv_far_start) 5)

	(f_squad_group_place gr_far_cov_init)

	;(if (= s_special_elite 1) (ai_place sq_far_bob) )

	(sleep_forever f_valley_pelican_hog)
	(soft_ceiling_enable camera_blocker_01 0)
	(soft_ceiling_enable camera_blocker_02 0)

	(sleep_until
		(or
			(<= s_objcon_air 0)
			b_air_defended
		)
	5)

	(if b_debug (print "::: faragate encounter :::"))
	(set s_wave_spawning 0)
	(set b_far_ready TRUE)
	(set s_exterior_objective_last 2)

	(f_ai_detail ai_detail_low)
	(f_zoneset_direction direction_none)

	(wake f_far_objective_nanny)

	; Standard Scripts
	(wake f_far_save_control)
	(wake f_far_missionobj_control)
	(wake f_far_waypoint_control)
	(wake f_far_music_control)
	(wake f_far_md_control)
	(wake f_far_cleanup_control)
	(wake f_far_spawn_control)
	(wake f_far_hilite_control)

	; Encounter Scripts
	(wake f_far_comm_control)
	(wake f_far_strike_control)

	(if b_debug (print "objective control : faragate.01"))
	(set b_insertion_fade_in TRUE)
	(set s_objcon_far 1)

	(sleep_until (volume_test_players tv_far_near) 5)
	(if b_debug (print "objective control : faragate.10"))
	(set s_objcon_far 10)

	(sleep_until b_far_generator_on 5)
	(if b_debug (print "objective control : faragate.15"))
	(set s_objcon_far 15)

	(sleep_until b_far_comm_on 5)
	(if b_debug (print "objective control : faragate.20"))
	(set s_objcon_far 20)
	
	; drop optional warthog upgrade
	(sleep_until
		(and 
			b_far_spawn_done
			b_far_defended
		)
	5)


	(if (not b_air_defended)
		(begin
			(if (volume_test_players tv_area_far) (f_far_drop_warthog) )
		)
		(begin
			(if (volume_test_players tv_area_far) (f_far_drop_bighog) )
		)
	)

)

(script static void f_far_hog_return_test

	(set b_air_defended TRUE)
	(f_far_drop_bighog)

)

(script static void f_far_hog_air_test

	(set b_air_defended FALSE)
	(f_far_drop_warthog)

)

(script dormant f_far_strike_control

	(sleep (* 30 5))
	(if (difficulty_is_normal_or_lower)
		(begin
			(airstrike_set_launches 2)
		)
	)	

)

(script dormant f_far_objective_nanny

	(wake f_far_objective_kat)
	
	(sleep_until

		(begin
		
			(f_squad_set_obj_area obj_far_hum tv_area_far_hog)

			; Break out condition
			(or
				(and
					b_far_spawn_done
					b_far_defended
				)
				(and
					b_far_defended
					(not (volume_test_players tv_area_far))
				)
			)
		
		)
		
	(* 30 1))

	(if b_air_defended (begin
	
		(f_vehicle_goto_set vehicle_return)

	)(begin
	
		(f_vehicle_goto_set vehicle_air)

	))

	(sleep_forever f_far_objective_kat)
	(sleep_forever f_far_distance_kat)
	(set b_far_kat_regroup TRUE)
	(f_squad_set_obj gr_vehicles_hum obj_vehicles_hum)

)

(script dormant f_far_objective_kat

	(sleep_until (volume_test_object tv_area_far o_kat) 3)
	(ai_set_objective gr_spartans obj_far_hum)
	(wake f_far_distance_kat)

)

(global boolean b_far_kat_regroup FALSE)
(script dormant f_far_distance_kat

	(sleep_until
		(begin

			(if (>= (objects_distance_to_object (players) o_kat) 17) (set b_far_kat_regroup TRUE) (set b_far_kat_regroup FALSE) )
	
		FALSE)
	30)

)

(script dormant f_far_hilite_control

	(sleep_until (>= s_objcon_far 10) 5)
	
	(sleep 120)

	(sleep_until
		(or
			(objects_can_see_object player0 sc_far_hilite_gen_marker 25)
			(objects_can_see_object player1 sc_far_hilite_gen_marker 25)
			(objects_can_see_object player2 sc_far_hilite_gen_marker 25)
			(objects_can_see_object player3 sc_far_hilite_gen_marker 25)
		)
	1)

	(f_hud_flash_object sc_far_hilite_gen)

	(sleep_until (>= s_objcon_far 15) 5)

	(sleep 120)

	(sleep_until
		(or
			(objects_can_see_object player0 sc_far_hilite_comm_marker 25)
			(objects_can_see_object player1 sc_far_hilite_comm_marker 25)
			(objects_can_see_object player2 sc_far_hilite_comm_marker 25)
			(objects_can_see_object player3 sc_far_hilite_comm_marker 25)
		)
	1)

	(f_hud_flash_object sc_far_hilite_comm)

)


(script dormant f_far_save_control

	(sleep_until (>= s_objcon_far 1))
	(game_save_no_timeout)

	(sleep_until (>= s_objcon_far 15))
	(game_save_no_timeout)

	(sleep_until (>= s_objcon_far 20))
	(game_save_no_timeout)

)


(script dormant f_far_missionobj_control

	(sleep_until (>= s_objcon_far 1))
	(set s_music_far 1)
	(mo_faragate)

	(sleep_until b_far_defended)
	
	(sleep 30)

	(if (not b_far_spawn_done)
		(mo_clean)
	)

	(sleep_until
		(or
			(not (volume_test_players tv_far_near))
			b_far_spawn_done
		)
	5)

	(if (not b_air_defended)
		(begin
			(sleep 30)
			(mo_farair)
			(sleep 30)
			(md_far_done_airview)
		)
	)

)

(global short s_far_waypoint_timer 180)
(script dormant f_far_waypoint_control

	(sleep_until
		(or
			(and
				b_far_defended
				(not (volume_test_players tv_area_far))
			)
			(and
				b_far_spawn_done
				b_far_defended
			)
		)
	5)

	(sleep_until (>= s_objcon_air 1) 5 (* 30 s_far_waypoint_timer))
	(if (not (>= s_objcon_air 1))
		(begin
			(f_blip_flag fl_far_waypoint_air blip_destination)
			(sleep_until (>= s_objcon_air 1) 5)
			(f_unblip_flag fl_far_waypoint_air)
		)
	)

)

(script dormant f_far_cleanup_control

	(sleep_until
		(and
			b_far_defended
			(not (volume_test_players tv_far_start))
		)
	5)
	(ai_erase gr_far_cov)

)

(script dormant f_far_md_control

	; Conditional
	; ---------------
	(wake f_far_md_return)

	; Linear
	;---------------
	(sleep_until (>= s_objcon_far 1) 1)
	(sleep (* 30 2))
	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)
	(wake f_far_md_suppress_1)
	(md_far_view)

	(sleep_until (>= s_objcon_far 10))
	(sleep (* 30 2))
	(md_far_target)
	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)

	(sleep_until (>= s_objcon_far 15) 5 (* 30 180))
	(if (not (>= s_objcon_far 15))
		(md_far_generator_delay_0)
	)

	(sleep_until (>= s_objcon_far 15) 5 (* 30 180))
	(if (not (>= s_objcon_far 15))
		(md_far_generator_delay_1)
	)

	(sleep_until (>= s_objcon_far 15) 5)
	(sleep (* 30 5))
	(md_far_comm)

	(sleep_until (>= s_objcon_far 20) 5 (* 30 180))
	(if (not (>= s_objcon_far 20))
		(md_far_comm_delay_0)
	)

	(sleep_until (>= s_objcon_far 20) 5 (* 30 180))
	(if (not (>= s_objcon_far 20))
		(md_far_comm_delay_1)
	)

	(sleep_until (>= s_objcon_far 20) 5)
	(sleep (* 30 3))
	(md_far_done)


	(sleep_until (or (>= s_objcon_air 1) (>= s_objcon_return 10)) 5 (* 30 90))
	(if (not (or (>= s_objcon_air 1) (>= s_objcon_return 10)))
		(md_far_delay)
	)
	(f_md_exterior_increment)

)

(script dormant f_far_md_suppress_1

	(sleep (* 30 10))
	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)

)


(script dormant f_far_md_return
	
	(sleep_until (volume_test_players tv_far_near) 1 )

	(branch
		b_far_defended
		(f_abort)
	)

	(sleep_until (not (volume_test_players tv_far_start) ) 1 )
	(sleep (* 30 3))
	(md_far_return_0)

)


(script dormant f_far_comm_control

	(sleep_until (>= s_objcon_far 0))
	(device_set_power dc_far_generator_switch 1)

	(sleep_until (>= (device_get_position dc_far_generator_switch) 1) 5 (* 30 40))
	(if (not (> (device_get_position dc_far_generator_switch) 0)) (f_blip_object dc_far_generator_switch blip_interface))

	(sleep_until (>= (device_get_position dc_far_generator_switch) 1) 5)
	(interpolator_start farragut_gen_audio)
	(set b_far_generator_on TRUE)
	(device_set_position dm_far_generator_lever 1)
	(wake f_far_generator_effects)

	(device_set_power dc_far_comm_switch 1)
	(f_unblip_object dc_far_generator_switch)	

	(sleep_until (>= (device_get_position dc_far_comm_switch) 1) 5 (* 30 3))
	(if (not (> (device_get_position dc_far_comm_switch) 0)) (f_blip_object dc_far_comm_switch blip_interface))
	
	(sleep_until (>= (device_get_position dc_far_comm_switch) 1) 5)
	(interpolator_start farragut_comm_audio)
	(set b_far_comm_on TRUE)
	(f_unblip_object dc_far_comm_switch)	
	(set b_far_defended TRUE)
	(set s_music_far 2)

)

(script dormant f_far_generator_effects

	(sleep 30)

	(effect_new_on_object_marker fx\fx_library\ambient\sparks\sparks_electrical_medium\sparks_electrical_medium gen_on_sparks "")
	(sleep 3)
	(object_create gen_on_1)
	(sleep 3)
	(object_create gen_on_4)
	(sleep 3)
	(object_create gen_on_smoke)
	(sleep 8)
	(object_create gen_on_2)
	(object_create gen_on_3)
	(sleep 15)
	(object_create gen_on_consparks)
	(sleep 15)
	(object_create gen_on_trans)

	(sleep 90)

	(dprint "farragut lights")
	(object_create_anew es_interp_10)
	(interpolator_start farragut_lights)
	(sleep (* 30 20))
	(object_destroy es_interp_10)

)

; Standard Scripts
(script dormant f_far_music_control

	(wake music_far)

	(sleep_until (not (volume_test_players tv_area_far_wide)) 1)
	(set s_music_far 2)

)

(global boolean b_far_spawn_done FALSE)
(script dormant f_far_spawn_control

	(sleep_until (>= (device_get_position dc_far_generator_switch) 1) 5)

	; Place the dropship
	(if b_debug (print "dropping faragate fork counter 1"))
	(ai_place sq_far_fork_counter_1)

	(sleep 30)

	(sleep_until
		(and
			(<= (ai_task_count obj_far_cov/gate_infantry) 1)
			(or
				(not b_sq_far_fork_counter_1_spawn)
				(<= (object_get_health sq_far_fork_counter_1/driver01) 0)
			)
		)
	5)

	(set b_far_spawn_done TRUE)

)

; Faragate Dropships
; =================================================================================================

(global boolean b_sq_far_fork_counter_1_spawn FALSE)
(script command_script f_cs_far_fork_counter_1

	(cs_enable_targeting TRUE)
	(cs_ignore_obstacles TRUE)

	(set b_sq_far_fork_counter_1_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(f_load_fork ai_current_squad "left" sq_far_cov_counter_1_1 sq_far_cov_counter_1_2 NONE NONE)
	(f_load_fork ai_current_squad "right" sq_far_cov_counter_1_3 sq_far_cov_counter_1_4 NONE NONE)
	(cs_fly_by ps_far_fork_counter_1/enter_01)
	(cs_fly_by ps_far_fork_counter_1/enter_02)
	(cs_fly_by ps_far_fork_counter_1/hover_in)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_far_fork_counter_1/drop ps_far_fork_counter_1/drop_face .1)
	(print "drop")
	(f_unload_fork ai_current_squad "dual")
	(set b_sq_far_fork_counter_1_spawn FALSE)
	(cs_fly_by ps_far_fork_counter_1/hover_out)
	(cs_fly_by ps_far_fork_counter_1/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_far_fork_counter_1/erase)
	(ai_erase ai_current_squad)

)

; Faragate Pelican
; =================================================================================================
(script static void f_far_drop_warthog

	(ai_place sq_far_pelican_hog)
	(object_cannot_die sq_far_pelican_hog TRUE)
	(ai_place sq_far_warthog)

	(vehicle_load_magic
		(ai_vehicle_get_from_starting_location sq_far_pelican_hog/driver01) "pelican_lc"
		(ai_vehicle_get_from_starting_location sq_far_warthog/driver01)
	)
)


(script static void f_far_drop_bighog

	(ai_place sq_far_pelican_hog)
	(object_cannot_die sq_far_pelican_hog TRUE)
	(ai_place sq_far_bighog)

	(vehicle_load_magic
		(ai_vehicle_get_from_starting_location sq_far_pelican_hog/driver01) "pelican_lc" 
		(ai_vehicle_get_from_starting_location sq_far_bighog/driver01)
	)
)



(global boolean b_sq_far_pelican_spawn FALSE)
(script command_script f_cs_far_pelican_hog

	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)

	(object_cannot_die sq_far_pelican_hog TRUE)

	(set b_sq_far_pelican_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(cs_fly_by ps_far_pelican/enter_01)
	(cs_fly_by ps_far_pelican/enter_02)

	(if b_air_defended
		(begin
			(cs_fly_to_and_face ps_far_pelican/hover ps_far_pelican/hover_face_valley .1)
		)
		(begin
			(cs_fly_to_and_face ps_far_pelican/hover ps_far_pelican/hover_face_air .1)
		)
	)

	(cs_vehicle_speed .7)
	(wake f_md_hogdrop_far)

	(if b_air_defended
		(begin
			(cs_fly_to_and_face ps_far_pelican/drop ps_far_pelican/drop_face_valley .1)
		)
		(begin
			(cs_fly_to_and_face ps_far_pelican/drop ps_far_pelican/drop_face_air .1)
		)
	)

	(sleep 60)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_lc")
	(sleep 100)
	(set b_sq_far_pelican_spawn FALSE)
	(cs_fly_by ps_far_pelican/hover .1)
	(cs_vehicle_speed 1)
	(cs_fly_by ps_far_pelican/exit_01)
	(cs_fly_by ps_far_pelican/exit_02)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
	(cs_fly_by ps_far_pelican/erase)
	(ai_erase ai_current_squad)

)

(script dormant f_md_hogdrop_far

	(md_hogdrop)
	(f_md_hogdrop_increment)

)

;*

(script command_script f_cs_far_pelican_hog_2

	; Initial setup
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_vehicle_speed 1.0)

	; Dropship entry
	(cs_fly_to ps_far_pelican/hover)
	(sleep 30)

	(sleep 30)

	; Dropship is now hovering
	(if b_air_defended
		(cs_fly_to_and_face ps_far_pelican/land ps_far_pelican/face_land 1)
		(cs_fly_to_and_face ps_far_pelican/land ps_far_pelican/face_air 1)
	)
	(sleep 30)

	(md_hogdrop)
	(f_md_hogdrop_increment)

	; Dropship has landed
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_lc")
	(sleep 30)
	(cs_fly_to_and_face ps_far_pelican/hover ps_far_pelican/face_exit 0.3)
	(sleep 90)

	(cs_vehicle_speed 1)
	;(cs_fly_by <erase_point>)

	; Dropship is out of sight, now erase it
	(ai_erase ai_current_squad)

)

*;


; Faragate Bookkeeping
; =================================================================================================
(script static void f_far_cleanup

	(sleep_forever f_far_main)

)

; =================================================================================================
; =================================================================================================
; AIRVIEW
; =================================================================================================
; =================================================================================================

(script dormant f_air_main

	(sleep_until (volume_test_players tv_air_start) 5)

	(f_squad_group_place gr_air_cov_init)

	;(if (= s_special_elite 2) (ai_place sq_air_bob) )

	(wake f_air_aa_control)
	(sleep_forever f_valley_pelican_hog)
	(soft_ceiling_enable camera_blocker_03 0)
	(soft_ceiling_enable camera_blocker_04 0)

	(sleep_until
		(or
			(<= s_objcon_far 0)
			b_far_defended
		)
	5)
	(if b_debug (print "::: ENCOUNTER START: Airview"))

	(f_zoneset_direction direction_none)
	(f_ai_detail ai_detail_low)

	(wake f_air_objective_nanny)
	(set s_exterior_objective_last 1)

	; Standard Scripts
	(wake f_air_save_control)
	(wake f_air_missionobj_control)
	(wake f_air_music_control)
	(wake f_air_md_control)
	(wake f_air_cleanup_control)
	(wake f_air_spawn_control)
	(wake f_air_hilite_control)
	
	; Encounter Scripts
	(wake f_air_strike_control)

	; Objective 1
	(if b_debug (print "objective control : airview.01"))
	(set b_insertion_fade_in TRUE)
	(set s_objcon_air 1)

	; Objective 10
	(sleep_until (volume_test_players tv_air_near) 10)
	(if b_debug (print "objective control : airview.10"))
	(set s_objcon_air 10)

	(sleep_until
		(and 
			b_air_spawn_done
			b_air_defended
		)
	5)
	(if (not b_far_defended)
		(begin
			(if (volume_test_players tv_area_air) (f_air_drop_warthog) )
		)
		(begin
			(if (volume_test_players tv_area_air) (f_air_drop_bighog) )
		)
	)

)


(script static void f_air_hog_return_test

	(set b_far_defended TRUE)
	(f_air_drop_bighog)

)

(script static void f_air_hog_far_test

	(set b_far_defended FALSE)
	(f_air_drop_warthog)

)


(script dormant f_air_strike_control

	(sleep (* 30 5))
	(if (difficulty_is_normal_or_lower)
		(begin
			(airstrike_set_launches 2)
		)
	)	

)

(script dormant f_air_md_suppress_1

	(sleep (* 30 10))
	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)

)

(script dormant f_air_objective_nanny

	(wake f_air_objective_kat)

	(sleep_until
	
		(begin
		
			(f_squad_set_obj_area obj_air_hum tv_area_air)

			; Break out condition
			(or
				(and
					b_air_defended
					(not (volume_test_players tv_area_air))
				)
				(and
					b_air_spawn_done
					b_air_defended
				)
			)
		
		)
		
	(* 30 1))

	(if b_far_defended (begin

		(f_vehicle_goto_set vehicle_return)

	)(begin

		(f_vehicle_goto_set vehicle_far)	

	))

	(sleep_forever f_air_distance_kat)
	(sleep_forever f_air_objective_kat)
	(set b_air_kat_regroup TRUE)
	(f_squad_set_obj gr_vehicles_hum obj_vehicles_hum)

)

(script dormant f_air_objective_kat

	(sleep_until (volume_test_object tv_area_air o_kat) 3)
	(ai_set_objective gr_spartans obj_air_hum)
	(wake f_air_distance_kat)

)

(global boolean b_air_kat_regroup FALSE)
(script dormant f_air_distance_kat

	(sleep_until
		(begin

			(if (>= (objects_distance_to_object (players) o_kat) 17) (set b_air_kat_regroup TRUE) (set b_air_kat_regroup FALSE) )
	
		FALSE)
	30)

)

(script dormant f_air_hilite_control

	(sleep_until (>= s_objcon_air 10) 5)
	
	(sleep 120)

	(sleep_until
		(or
			(objects_can_see_object player0 sc_air_hilite_turret_marker 25)
			(objects_can_see_object player1 sc_air_hilite_turret_marker 25)
			(objects_can_see_object player2 sc_air_hilite_turret_marker 25)
			(objects_can_see_object player3 sc_air_hilite_turret_marker 25)
		)
	1)

	(wake f_air_turret_hilite_1)
	(wake f_air_turret_hilite_2)

)

(script dormant f_air_turret_hilite_1

	(f_hud_flash_object sc_air_hilite_turret)

)

(script dormant f_air_turret_hilite_2

	(f_hud_flash_object sc_air_hilite_turret_cannon)

)


(global short s_air_wave_count 0)
(global boolean b_air_spawn_done FALSE)
(script dormant f_air_spawn_control

	(wake f_air_phantom_hover_spawn)

	; Dropship 1 - infantry depleted
	(sleep_until (<= (ai_task_count obj_air_cov/gate_infantry) 3))
	(if b_debug (print "dropping airview fork"))
	(ai_place sq_air_fork_counter_1)
	(tick)
	(ai_set_targeting_group sq_air_fork_counter_1 76)

	(set s_air_wave_count 2)

	(sleep_until
		(and
			(<= (ai_task_count obj_air_cov/gate_infantry) 6)
			(or
				(not b_air_fork_counter_1_spawn)
				(<= (object_get_health sq_air_fork_counter_1/driver01) 0)
			)
		)
	5)
	(ai_place sq_air_phantom_cnt_1)
	(tick)
	(ai_set_targeting_group sq_air_phantom_cnt_1 76)

	(sleep 30)

	(sleep_until
		(and
			(<= (ai_task_count obj_air_cov/gate_infantry) 1)
			(<= (ai_task_count obj_air_cov/gate_ghosts) 0)
			(or
				(not b_sq_air_phantom_cnt_1_spawn)
				(<= (object_get_health sq_air_phantom_cnt_1/driver01) 0)
			)
		)
	5)

	(set b_air_spawn_done TRUE)

)

(global short s_air_phantom_hover_idx 1)
(script dormant f_air_phantom_hover_spawn

	(sleep_until
		(or
			(volume_test_players tv_air_phantom_2)
			(volume_test_players tv_air_phantom_3)
		)
	)

	(if (volume_test_players tv_air_phantom_2) (ai_place sq_air_phantom_hover/driver_01))
	(if (volume_test_players tv_air_phantom_3) (ai_place sq_air_phantom_hover/driver_02))

	(tick)
	(ai_set_targeting_group sq_air_phantom_hover 76)

	(sleep_until
		(begin
	
			(if (<= (ai_living_count sq_air_phantom_hover) 0)
				(begin
					(set s_air_phantom_hover_idx (random_range 1 3))
					(if (= s_air_phantom_hover_idx 1) (ai_place sq_air_phantom_hover/driver_01))
					(if (= s_air_phantom_hover_idx 2) (ai_place sq_air_phantom_hover/driver_02))
					(ai_set_targeting_group sq_air_phantom_hover 76)
				)
			)
		
			b_air_defended

		)
	5)
)

(global short s_air_phantom_position -1)
(global short s_air_phantom_update_timer 5)
(global boolean b_air_phantom_hover_spawn FALSE)
(global short s_air_phantom_hover_pos 0)
(global short s_air_phantom_hover_pos_last -1)
(script command_script f_cs_air_phantom_hover

	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)
	(cs_enable_moving TRUE)

	(set b_air_phantom_hover_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))

	(sleep_until
		(begin

			(print "air phantom - position test")
		
			(set s_air_phantom_hover_pos 0)
			(if (volume_test_players tv_air_phantom_3) (set s_air_phantom_hover_pos 3))
			(if (volume_test_players tv_air_phantom_2) (set s_air_phantom_hover_pos 2))
			(if (volume_test_players tv_air_phantom_1) (set s_air_phantom_hover_pos 1))

			(set s_air_phantom_position (random_range 1 4))

				(if (or (= s_air_phantom_hover_pos 1) (= s_air_phantom_hover_pos 0))
					(begin

						(if (= s_air_phantom_position 1) (begin
							(cs_fly_to ps_air_phantom_hover_01/enter_01)
							(cs_fly_to_and_face ps_air_phantom_hover_01/hover_01 ps_air_phantom_hover_01/hover_01_face .25)	
						))
						(if (= s_air_phantom_position 2) (begin
							(cs_fly_to ps_air_phantom_hover_01/enter_02)
							(cs_fly_to_and_face ps_air_phantom_hover_01/hover_02 ps_air_phantom_hover_01/hover_02_face .25)					
						))
						(if (= s_air_phantom_position 3) (begin
							(cs_fly_to ps_air_phantom_hover_01/enter_03)
							(cs_fly_to_and_face ps_air_phantom_hover_01/hover_03 ps_air_phantom_hover_01/hover_03_face .25)					
						))				
					
					)
				)
				(if (= s_air_phantom_hover_pos 2)
					(begin

						(if (= s_air_phantom_position 1) (begin
							(cs_fly_to ps_air_phantom_hover_02/enter_01)
							(cs_fly_to_and_face ps_air_phantom_hover_02/hover_01 ps_air_phantom_hover_02/hover_01_face .25)					
						))
						(if (= s_air_phantom_position 2) (begin
							(cs_fly_to ps_air_phantom_hover_02/enter_02)
							(cs_fly_to_and_face ps_air_phantom_hover_02/hover_02 ps_air_phantom_hover_02/hover_02_face .25)					
						))
						(if (= s_air_phantom_position 3) (begin
							(cs_fly_to ps_air_phantom_hover_02/enter_03)
							(cs_fly_to_and_face ps_air_phantom_hover_02/hover_03 ps_air_phantom_hover_02/hover_03_face .25)					
						))					
					
					)
				)
				(if (= s_air_phantom_hover_pos 3)
					(begin

						(if (= s_air_phantom_position 1) (begin
							(cs_fly_to ps_air_phantom_hover_03/enter_01)
							(cs_fly_to_and_face ps_air_phantom_hover_03/hover_01 ps_air_phantom_hover_03/hover_01_face .25)					
						))
						(if (= s_air_phantom_position 2) (begin
							(cs_fly_to ps_air_phantom_hover_03/enter_02)
							(cs_fly_to_and_face ps_air_phantom_hover_03/hover_02 ps_air_phantom_hover_03/hover_02_face .25)					
						))
						(if (= s_air_phantom_position 3) (begin
							(cs_fly_to ps_air_phantom_hover_03/enter_03)
							(cs_fly_to_and_face ps_air_phantom_hover_03/hover_03 ps_air_phantom_hover_03/hover_03_face .25)					
						))						
					
					)
				)

				(cs_vehicle_speed .6)

		FALSE)
	(* 30 (random_range 1 3)) )
)

(script dormant f_air_save_control

	(sleep_until (>= s_objcon_air 1))
	(game_save_no_timeout)

	(sleep_until (>= s_objcon_air 10))
	(game_save_no_timeout)

	(sleep_until b_air_defended)
	(game_save_no_timeout)

	(sleep_until b_air_spawn_done)
	(game_save_no_timeout)

)

(global short s_air_waypoint_timer 180)
(script dormant f_air_waypoint_control

	(sleep_until
		(or
			(and
				b_air_defended
				(not (volume_test_players tv_area_air))
			)
			(and
				b_air_spawn_done
				b_air_defended
			)
		)
	5)

	(sleep_until (>= s_objcon_far 1) 5 (* 30 s_air_waypoint_timer))
	(if (not (>= s_objcon_far 1))
		(begin
			(f_blip_flag fl_air_waypoint_far blip_destination)
			(sleep_until (>= s_objcon_far 1) 5)
			(f_unblip_flag fl_air_waypoint_far)
		)
	)

)

(script dormant f_air_missionobj_control

	(sleep_until (>= s_objcon_air 1))
	(set s_music_air 1)
	(mo_airview)

	(sleep_until b_air_defended)

	(sleep 30)

	(if (not b_air_spawn_done)
		(mo_clean)
	)

	(sleep_until
		(or
			(not (volume_test_players tv_air_near))
			b_air_spawn_done
		)
	5)

	(if (not b_far_defended)
		(begin
			(sleep 30)
			(mo_airfar)
			(sleep 30)
			(md_air_done_faragate)
		)
	)

)

(script dormant f_air_aa_control

	(f_air_cannon_place)

	(sleep_until (>= s_objcon_air 10))
	(device_set_power dc_air_aa_switch 1)

	(sleep_until (>= (device_get_position dc_air_aa_switch) 1) 5 (* 30 40))
	(if (not (> (device_get_position dc_air_aa_switch) 0)) (f_blip_object dc_air_aa_switch blip_interface))
	
	(sleep_until (> (device_get_position dc_air_aa_switch) 0))
	(f_unblip_object dc_air_aa_switch)
	(set b_air_defended TRUE)
	(ai_set_targeting_group sq_air_aa_cannon 76)
	(ai_braindead sq_air_aa_cannon FALSE)

)

(script static void f_air_cannon_place

	(if (<= (ai_living_count sq_air_aa_cannon) 0) (begin

		(ai_place sq_air_aa_cannon)
		(tick)
		(object_cannot_die (ai_vehicle_get_from_starting_location sq_air_aa_cannon/driver01) TRUE)
		(object_cannot_take_damage (object_get_parent	sq_air_aa_cannon))
		(ai_disregard (ai_actors sq_air_aa_cannon) TRUE)
		(ai_braindead sq_air_aa_cannon TRUE)

	))

)

(script dormant f_air_cleanup_control

	(sleep_until
		(and
			b_air_defended
			(not (volume_test_players tv_air_start))
		)
	5)
	(ai_erase gr_air_cov)

)

(script dormant f_air_md_control

	; Conditional
	; ---------------
	(wake f_air_md_return)

	; Linear
	;---------------
	(sleep_until (>= s_objcon_air 1) 1)
	(sleep (* 30 2))

	(ai_actor_dialogue_enable (object_get_ai o_kat) FALSE)
	(wake f_air_md_suppress_1)
	(md_air_view)

	(sleep_until (>= s_objcon_air 10) 1)
	(sleep (* 30 2))
	(md_air_target)
	(ai_actor_dialogue_enable (object_get_ai o_kat) TRUE)

	(sleep_until b_air_defended 1 (* 30 180))
	(if (not b_air_defended)
		(begin
			(md_air_gun_delay_0)
		)
	)

	(sleep_until b_air_defended 1 (* 30 180))
	(if (not b_air_defended)
		(begin
			(md_air_gun_delay_1)
		)
	)

	(sleep_until b_air_defended 1 (* 30 180))
	(if (not b_air_defended)
		(begin
			(md_air_gun_delay_2)
		)
	)

	(sleep_until b_air_defended 1)
	(sleep (* 30 5))
	(md_air_done)

	(sleep_until (or (>= s_objcon_far 1) (>= s_objcon_return 10)) 5 (* 30 90))
	(if (not (or (>= s_objcon_far 1) (>= s_objcon_return 10)))
		(md_air_delay)
	)
	(f_md_exterior_increment)

)

(script dormant f_air_md_return
	
	(sleep_until (volume_test_players tv_air_near) 1 )

	(branch
		b_air_defended
		(f_abort)
	)

	(sleep_until (not (volume_test_players tv_air_start) ) 1 )
	(sleep (* 30 3))
	(md_air_return_0)

)

(script dormant f_air_music_control

	(wake music_air)

	(sleep_until (not (volume_test_players tv_area_air_wide)) 1)
	(set s_music_air 2)

)

(global boolean b_sq_air_phantom_cnt_1_spawn FALSE)
(script command_script f_cs_air_phantom_cnt_1

	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)

	(set b_sq_air_phantom_cnt_1_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(f_load_phantom_cargo (ai_vehicle_get ai_current_actor) "double" sq_air_counter_ghost_1 sq_air_counter_ghost_2)
	(cs_fly_by ps_air_phantom_cnt_1/enter_01)
	(cs_fly_by ps_air_phantom_cnt_1/hover_in)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_air_phantom_cnt_1/drop ps_air_phantom_cnt_1/drop_face .25)
	(print "drop")
	(f_unload_phantom_cargo ai_current_squad "double")
	(set b_sq_air_phantom_cnt_1_spawn FALSE)
	(cs_fly_by ps_air_phantom_cnt_1/hover_out)
	(cs_fly_by ps_air_phantom_cnt_1/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_by ps_air_phantom_cnt_1/erase)
	(ai_erase ai_current_squad)

)

(global boolean b_air_fork_counter_1_spawn FALSE)
(script command_script f_cs_air_fork_counter_1

	(set b_air_fork_counter_1_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(f_load_fork (ai_vehicle_get ai_current_actor) "any" sq_air_cov_counter_1_1 sq_air_cov_counter_1_2 NONE NONE)

	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)

	; Dropship entry
	(cs_fly_to ps_air_fork_counter_1/enter_01)
	(cs_fly_to ps_air_fork_counter_1/enter_02)	

	; Dropship is now hovering
	(cs_fly_to_and_face ps_air_fork_counter_1/hover_01 ps_air_fork_counter_1/drop_01_face 1)
	(cs_fly_to_and_face ps_air_fork_counter_1/drop_01 ps_air_fork_counter_1/drop_01_face 1)

	(f_unload_fork (ai_vehicle_get ai_current_actor) "dual")
	(set b_air_fork_counter_1_spawn FALSE)

	; Dropship has landed
	(sleep 75)
	; Delivery is complete
	(cs_fly_to_and_face ps_air_fork_counter_1/hover_01 ps_air_fork_counter_1/drop_01_face 1)
	(sleep 60)

	(cs_vehicle_speed 1)
	(cs_fly_by ps_air_fork_counter_1/exit)

	; Dropship is out of sight, now erase it
	(ai_erase ai_current_squad)

)

(global boolean b_sq_air_pelican_spawn FALSE)
(script command_script f_cs_air_pelican_hog

	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)

	(object_cannot_die sq_air_pelican_hog TRUE)

	(set b_sq_air_pelican_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(cs_fly_by ps_air_pelican/enter_01)

	(if b_far_defended
		(begin
			(cs_fly_by ps_air_pelican/enter_02_valley)
			(cs_fly_to_and_face ps_air_pelican/hover_valley ps_air_pelican/valley_face .1)
		)
		(begin
			(cs_fly_by ps_air_pelican/enter_02_far)
			(cs_fly_to_and_face ps_air_pelican/hover_far ps_air_pelican/far_face .1)
		)
	)

	(cs_vehicle_speed .7)
	(wake f_md_hogdrop_air)

	(if b_far_defended
		(begin
			(cs_fly_to_and_face ps_air_pelican/drop_valley ps_air_pelican/valley_face .1)
		)
		(begin
			(cs_fly_to_and_face ps_air_pelican/drop_far ps_air_pelican/far_face .1)
		)
	)

	(sleep 60)
	(vehicle_unload (ai_vehicle_get ai_current_actor) "pelican_lc")
	(sleep 100)
	(set b_sq_air_pelican_spawn FALSE)

	(if b_far_defended
		(begin
			(cs_fly_to_and_face ps_air_pelican/hover_valley ps_air_pelican/valley_face .1)
		)
		(begin
			(cs_fly_to_and_face ps_air_pelican/hover_far ps_air_pelican/far_face .1)
		)
	)

	(cs_vehicle_speed 1)
	(cs_fly_by ps_air_pelican/exit_01)
	(cs_fly_by ps_air_pelican/exit_02)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 5))
	(cs_fly_by ps_air_pelican/erase)
	(ai_erase ai_current_squad)

)

(script dormant f_md_hogdrop_air

	(md_hogdrop)
	(f_md_hogdrop_increment)

)

(script static void f_air_drop_warthog

	(ai_place sq_air_pelican_hog)
	(object_cannot_die sq_air_pelican_hog TRUE)
	(ai_place sq_air_warthog)
	(ai_squad_enumerate_immigrants sq_air_warthog TRUE)

	(vehicle_load_magic
		(ai_vehicle_get_from_starting_location sq_air_pelican_hog/driver01) "pelican_lc"
		(ai_vehicle_get_from_starting_location sq_air_warthog/driver01)
	)
)

(script static void f_air_drop_bighog

	(ai_place sq_air_pelican_hog)
	(object_cannot_die sq_air_pelican_hog TRUE)
	(ai_place sq_air_bighog)
	(ai_squad_enumerate_immigrants sq_air_bighog TRUE)

	(vehicle_load_magic
		(ai_vehicle_get_from_starting_location sq_air_pelican_hog/driver01) "pelican_lc"
		(ai_vehicle_get_from_starting_location sq_air_bighog/driver01)
	)
)

(script static void f_air_cleanup

	(sleep_forever f_air_main)

)

; =================================================================================================
; =================================================================================================
; SLEW
; =================================================================================================
; =================================================================================================

(global boolean b_slew false)
(global boolean b_slew_start false)
(global boolean b_slew_finish false)
(global short s_slew_respawn_timer 10)
(global short s_slew_dir 1)
(script dormant f_slew

	(sleep_until
		(begin

		(if (= (current_zone_set_fully_active) s_zoneset_exterior) (begin

			(sleep_until
				(or
					(> (device_get_position dc_slew_01) 0)
					(> (device_get_position dc_slew_02) 0)
				)
			1)

			(sleep_until
				(and
					(> (device_get_position dc_slew_01) 0)
					(> (device_get_position dc_slew_02) 0)
				)
			1 (* 30 2))

			(if
				(and
					(> (device_get_position dc_slew_01) 0)
					(> (device_get_position dc_slew_02) 0)
				)
				(begin
					(set b_slew true)
										
					(print "achievement: reach racer")
					(submit_incident_with_cause_player "racer_achieve" player0)
					(submit_incident_with_cause_player "racer_achieve" player1)
					(submit_incident_with_cause_player "racer_achieve" player2)
					(submit_incident_with_cause_player "racer_achieve" player3)		
				)
			)

			(device_set_position dc_slew_01 0)
			(device_set_position dc_slew_02 0)

		))

		b_slew)	
	5)

	(f_slew_cleanup)

	(f_zoneset_direction direction_none)
	(switch_zone_set zoneset_exterior)

	(device_set_power dc_slew_01 0)
	(device_set_power dc_slew_02 0)

	(wake f_slew_control)
	(wake f_slew_timer)
	(wake f_slew_player0)
	(wake f_slew_player1)
	(wake f_slew_player2)
	(wake f_slew_player3)
	
)

(script static void f_slew_cleanup

	(set b_save_on FALSE)
	(wake f_save_control)
	(sleep_forever f_save_continuous)
	(sleep_forever f_gatehouse_door_return_triggers)
	(sleep_forever f_gatehouse_door_return_switch)
	(sleep_forever f_gatehouse_door_timer)
	(sleep_forever f_gatehouse_door_objects)

	(f_court_cleanup)
	(f_valley_cleanup)
	(f_far_cleanup)
	(f_air_cleanup)
	(f_air_far_cleanup)
	(f_return_cleanup)

	; Blips
	(f_unblip_flag fl_valley_waypoint_1_1)
	(f_unblip_flag fl_valley_waypoint_1_2)
	(f_unblip_object (ai_vehicle_get_from_starting_location sq_valley_warthog_drop/driver01))
	(f_unblip_flag fl_far_waypoint_air)
	(f_unblip_object dc_far_generator_switch)	
	(device_set_power dc_far_generator_switch 0)
	(f_unblip_object dc_far_comm_switch)	
	(device_set_power dc_far_comm_switch 0)
	(f_unblip_object dc_return_door_switch)
	(device_set_power dc_return_door_switch 0)
	(f_unblip_flag fl_air_waypoint_far)
	(f_unblip_object dc_air_aa_switch)
	(device_set_power dc_air_aa_switch 0)
	(f_unblip_flag fl_return_waypoint_1)

	; Valley
	(sleep_forever f_valley_pelican_hog)
	(sleep_forever f_valley_save_combatend)

	; Farragut
	(sleep_forever f_far_objective_nanny)
	(sleep_forever f_far_save_control)
	(sleep_forever f_far_missionobj_control)
	(sleep_forever f_far_waypoint_control)
	(sleep_forever f_far_music_control)
	(sleep_forever f_far_md_control)
	(sleep_forever f_far_cleanup_control)
	(sleep_forever f_far_spawn_control)
	(sleep_forever f_far_hilite_control)
	(sleep_forever f_far_comm_control)
	(sleep_forever f_far_strike_control)
	(sleep_forever f_far_objective_kat)
	(sleep_forever f_far_distance_kat)

	; Airview
	(sleep_forever f_air_objective_nanny)
	(sleep_forever f_air_save_control)
	(sleep_forever f_air_missionobj_control)
	(sleep_forever f_air_music_control)
	(sleep_forever f_air_md_control)
	(sleep_forever f_air_cleanup_control)
	(sleep_forever f_air_spawn_control)
	(sleep_forever f_air_hilite_control)
	(sleep_forever f_air_distance_kat)
	(sleep_forever f_air_objective_kat)
	(sleep_forever f_air_aa_control)
						
	; Return
	(sleep_forever f_return_objective_nanny)
	(sleep_forever f_return_save_control)	
	(sleep_forever f_return_waypoint_control)	
	(sleep_forever f_return_missionobj_control)	
	(sleep_forever f_return_spawn_control)	
	(sleep_forever f_return_md_control)	
	(sleep_forever f_return_music_control)
	(sleep_forever f_gatehouse_door_return)
	(sleep_forever f_return_strike_control)
	(sleep_forever f_return_objective_kat)
	(sleep_forever f_return_distance_kat)
	(sleep_forever f_return_coop_teleport)
				
	(f_vehicle_goto_set vehicle_return)
	(f_squad_set_obj gr_vehicles_hum obj_vehicles_hum)
	
	; Music
	(sound_looping_stop levels\solo\m20\music\m20_music02)
	(sound_looping_stop levels\solo\m20\music\m20_music03)
	(sound_looping_stop levels\solo\m20\music\m20_music04)
	(sound_looping_stop levels\solo\m20\music\m20_music10)

)

(script static void f_slew_test

	(device_set_position dc_slew_01 1)
	(device_set_position dc_slew_02 1)

)

(global short s_slew_time 0)
(global short s_slew_time_slow 120)
(global short s_slew_time_fast 90)
(script dormant f_slew_timer

	(sleep_until b_slew_start 1)

	(sleep_until
		(begin
		
		(set s_slew_time 0)

			(sleep_until
				(begin
					(set s_slew_time (+ s_slew_time 1))
				b_slew_finish)
			30)
		
			(sleep 60)
		
			(if (<= s_slew_time s_slew_time_slow) (submit_incident_with_cause_player "Race_m20" p_slew_winner))
			(if (<= s_slew_time s_slew_time_fast) (submit_incident_with_cause_player "Race_m20_fast" p_slew_winner))

			(sleep_until b_slew_start 1)

		FALSE)
	1)


)

(script dormant f_slew_control

	(f_hud_obj_repeat CT_SLEW)

	(sleep_until
		(begin

			(set b_slew_start true)
			(set b_slew_finish false)
			(set s_slew_dir (random_range 1 3))
			(object_teleport_to_ai_point player0 ps_slew/p0)
			(object_teleport_to_ai_point player1 ps_slew/p1)
			(object_teleport_to_ai_point player2 ps_slew/p2)
			(object_teleport_to_ai_point player3 ps_slew/p3)
			(tick)
			(ai_erase sq_slew_hog_01)
			(ai_erase sq_slew_hog_02)
			(tick)
			(ai_place sq_slew_hog_01)
			(ai_place sq_slew_hog_02)
			(f_hud_obj_repeat PROMPT_SLEW)
			(sleep_until b_slew_finish 1)
			(f_hud_obj_repeat PROMPT_WIN)
			(sleep (* 30 s_slew_respawn_timer))

		FALSE)
	1)


)

(global player p_slew_winner player1)
(script static void (f_slew_win (player p))

	(set p_slew_winner p)

	(if (= p player0)
		(begin
			(if (not (= (object_get_parent player0) (object_get_parent player1))) (f_slew_kill_vehicle player1))
			(if (not (= (object_get_parent player0) (object_get_parent player2))) (f_slew_kill_vehicle player2))
			(if (not (= (object_get_parent player0) (object_get_parent player3))) (f_slew_kill_vehicle player3))
		)
	)
	(if (= p player1)
		(begin
			(if (not (= (object_get_parent player1) (object_get_parent player0))) (f_slew_kill_vehicle player0))
			(if (not (= (object_get_parent player1) (object_get_parent player2))) (f_slew_kill_vehicle player2))
			(if (not (= (object_get_parent player1) (object_get_parent player3))) (f_slew_kill_vehicle player3))
		)
	)
	(if (= p player2)
		(begin
			(if (not (= (object_get_parent player2) (object_get_parent player0))) (f_slew_kill_vehicle player0))
			(if (not (= (object_get_parent player2) (object_get_parent player1))) (f_slew_kill_vehicle player1))
			(if (not (= (object_get_parent player2) (object_get_parent player3))) (f_slew_kill_vehicle player3))
		)
	)
	(if (= p player3)
		(begin
			(if (not (= (object_get_parent player3) (object_get_parent player0))) (f_slew_kill_vehicle player0))
			(if (not (= (object_get_parent player3) (object_get_parent player1))) (f_slew_kill_vehicle player1))
			(if (not (= (object_get_parent player3) (object_get_parent player2))) (f_slew_kill_vehicle player2))
		)
	)

)

(script static void (f_slew_kill_vehicle (player p))

	(damage_object (object_get_parent p) "hull" 9999)
	(damage_object (object_get_parent p) "hull_front" 9999)
	(object_damage_damage_section (object_get_parent p) "hull" 9999)
	(object_damage_damage_section (object_get_parent p) "hull_front" 9999)

)

(script dormant f_slew_player0

	(sleep_until
		(begin

			(sleep_until b_slew_start 1)

			(if (= s_slew_dir 1)
				(begin
					(f_slew_point player0 tv_slew_01 fl_slew_01)
					(f_slew_point player0 tv_slew_02 fl_slew_02)
					(f_slew_point player0 tv_slew_03 fl_slew_03)
					(f_slew_point player0 tv_slew_04 fl_slew_04)
					(f_slew_point player0 tv_slew_05 fl_slew_05)
					(f_slew_point player0 tv_slew_06 fl_slew_06)
					(f_slew_point player0 tv_slew_07 fl_slew_07)
					(f_slew_point player0 tv_slew_08 fl_slew_08)
					(f_slew_point player0 tv_slew_09 fl_slew_09)
					(f_slew_point player0 tv_slew_10 fl_slew_10)
				)
			)
			(if (= s_slew_dir 2)
				(begin
					(f_slew_point player0 tv_slew_09 fl_slew_09)
					(f_slew_point player0 tv_slew_08 fl_slew_08)
					(f_slew_point player0 tv_slew_07 fl_slew_07)
					(f_slew_point player0 tv_slew_06 fl_slew_06)
					(f_slew_point player0 tv_slew_05 fl_slew_05)
					(f_slew_point player0 tv_slew_04 fl_slew_04)
					(f_slew_point player0 tv_slew_03 fl_slew_03)
					(f_slew_point player0 tv_slew_02 fl_slew_02)
					(f_slew_point player0 tv_slew_01 fl_slew_01)
					(f_slew_point player0 tv_slew_10 fl_slew_10)
				)
			)

			(if (not b_slew_finish) (f_slew_win player0))
			(set b_slew_finish true)
		
		FALSE)
	1)

)


(script dormant f_slew_player1

	(sleep_until
		(begin

			(sleep_until b_slew_start 1)

			(if (= s_slew_dir 1)
				(begin
					(f_slew_point player1 tv_slew_01 fl_slew_01)
					(f_slew_point player1 tv_slew_02 fl_slew_02)
					(f_slew_point player1 tv_slew_03 fl_slew_03)
					(f_slew_point player1 tv_slew_04 fl_slew_04)
					(f_slew_point player1 tv_slew_05 fl_slew_05)
					(f_slew_point player1 tv_slew_06 fl_slew_06)
					(f_slew_point player1 tv_slew_07 fl_slew_07)
					(f_slew_point player1 tv_slew_08 fl_slew_08)
					(f_slew_point player1 tv_slew_09 fl_slew_09)
					(f_slew_point player1 tv_slew_10 fl_slew_10)
				)
			)
			(if (= s_slew_dir 2)
				(begin
					(f_slew_point player1 tv_slew_09 fl_slew_09)
					(f_slew_point player1 tv_slew_08 fl_slew_08)
					(f_slew_point player1 tv_slew_07 fl_slew_07)
					(f_slew_point player1 tv_slew_06 fl_slew_06)
					(f_slew_point player1 tv_slew_05 fl_slew_05)
					(f_slew_point player1 tv_slew_04 fl_slew_04)
					(f_slew_point player1 tv_slew_03 fl_slew_03)
					(f_slew_point player1 tv_slew_02 fl_slew_02)
					(f_slew_point player1 tv_slew_01 fl_slew_01)
					(f_slew_point player1 tv_slew_10 fl_slew_10)
				)
			)

			(if (not b_slew_finish) (f_slew_win player1))
			(set b_slew_finish true)

		FALSE)
	1)

)

(script dormant f_slew_player2

	(sleep_until
		(begin

			(sleep_until b_slew_start 1)

			(if (= s_slew_dir 1)
				(begin
					(f_slew_point player2 tv_slew_01 fl_slew_01)
					(f_slew_point player2 tv_slew_02 fl_slew_02)
					(f_slew_point player2 tv_slew_03 fl_slew_03)
					(f_slew_point player2 tv_slew_04 fl_slew_04)
					(f_slew_point player2 tv_slew_05 fl_slew_05)
					(f_slew_point player2 tv_slew_06 fl_slew_06)
					(f_slew_point player2 tv_slew_07 fl_slew_07)
					(f_slew_point player2 tv_slew_08 fl_slew_08)
					(f_slew_point player2 tv_slew_09 fl_slew_09)
					(f_slew_point player2 tv_slew_10 fl_slew_10)
				)
			)
			(if (= s_slew_dir 2)
				(begin
					(f_slew_point player2 tv_slew_09 fl_slew_09)
					(f_slew_point player2 tv_slew_08 fl_slew_08)
					(f_slew_point player2 tv_slew_07 fl_slew_07)
					(f_slew_point player2 tv_slew_06 fl_slew_06)
					(f_slew_point player2 tv_slew_05 fl_slew_05)
					(f_slew_point player2 tv_slew_04 fl_slew_04)
					(f_slew_point player2 tv_slew_03 fl_slew_03)
					(f_slew_point player2 tv_slew_02 fl_slew_02)
					(f_slew_point player2 tv_slew_01 fl_slew_01)
					(f_slew_point player2 tv_slew_10 fl_slew_10)
				)
			)

			(if (not b_slew_finish) (f_slew_win player2))
			(set b_slew_finish true)

		FALSE)
	1)

)

(script dormant f_slew_player3

	(sleep_until
		(begin

			(sleep_until b_slew_start 1)

			(if (= s_slew_dir 1)
				(begin
					(f_slew_point player3 tv_slew_01 fl_slew_01)
					(f_slew_point player3 tv_slew_02 fl_slew_02)
					(f_slew_point player3 tv_slew_03 fl_slew_03)
					(f_slew_point player3 tv_slew_04 fl_slew_04)
					(f_slew_point player3 tv_slew_05 fl_slew_05)
					(f_slew_point player3 tv_slew_06 fl_slew_06)
					(f_slew_point player3 tv_slew_07 fl_slew_07)
					(f_slew_point player3 tv_slew_08 fl_slew_08)
					(f_slew_point player3 tv_slew_09 fl_slew_09)
					(f_slew_point player3 tv_slew_10 fl_slew_10)
				)
			)
			(if (= s_slew_dir 2)
				(begin
					(f_slew_point player3 tv_slew_09 fl_slew_09)
					(f_slew_point player3 tv_slew_08 fl_slew_08)
					(f_slew_point player3 tv_slew_07 fl_slew_07)
					(f_slew_point player3 tv_slew_06 fl_slew_06)
					(f_slew_point player3 tv_slew_05 fl_slew_05)
					(f_slew_point player3 tv_slew_04 fl_slew_04)
					(f_slew_point player3 tv_slew_03 fl_slew_03)
					(f_slew_point player3 tv_slew_02 fl_slew_02)
					(f_slew_point player3 tv_slew_01 fl_slew_01)
					(f_slew_point player3 tv_slew_10 fl_slew_10)
				)
			)

			(if (not b_slew_finish) (f_slew_win player3))
			(set b_slew_finish true)

		FALSE)
	1)

)

(script static void (f_slew_point (player p) (trigger_volume tv) (cutscene_flag fl))

	(f_slew_point_clear p)

	(if (not b_slew_finish)
		(begin

			(chud_track_flag_for_player_with_priority p fl 7)
			(sleep_until (or (volume_test_objects tv p) b_slew_finish) 1)
			(f_slew_point_clear p)	

		)
	)

)

(script static void (f_slew_point_clear (player p))

	(chud_track_flag_for_player p fl_slew_01 FALSE)
	(chud_track_flag_for_player p fl_slew_02 FALSE)
	(chud_track_flag_for_player p fl_slew_03 FALSE)
	(chud_track_flag_for_player p fl_slew_04 FALSE)
	(chud_track_flag_for_player p fl_slew_05 FALSE)
	(chud_track_flag_for_player p fl_slew_06 FALSE)
	(chud_track_flag_for_player p fl_slew_07 FALSE)
	(chud_track_flag_for_player p fl_slew_08 FALSE)
	(chud_track_flag_for_player p fl_slew_09 FALSE)
	(chud_track_flag_for_player p fl_slew_10 FALSE)

)

; =================================================================================================
; =================================================================================================
; AIR FAR EXTERIOR TRANSITION
; =================================================================================================
; =================================================================================================

(script dormant f_air_far_main

	(sleep_until (volume_test_players tv_air_far_start) 5)

	(wake f_airfar_flock_control)
	(f_squad_group_place gr_air_far_cov_init)
	(f_squad_group_place gr_air_far_cov_drop_w1)

	;(if (= s_special_elite 3) (ai_place sq_air_far_bob) )

)

(script dormant f_airfar_flock_control

	(sleep 0)

)


(global boolean b_sq_air_far_drop_w1_1_spawn FALSE)
(script command_script f_cs_sq_air_far_drop_w1_1
	
	(cs_enable_pathfinding_failsafe TRUE)
	(cs_ignore_obstacles TRUE)
	(cs_enable_targeting TRUE)

	(set b_sq_air_far_drop_w1_1_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(f_load_fork ai_current_squad "right" sq_air_far_cov_w1_1 NONE NONE NONE)
	(f_load_fork ai_current_squad "left" sq_air_far_cov_w1_2 NONE NONE NONE)
	(cs_fly_to ps_air_far_cov_drop_w1_1/enter_01)
	(cs_fly_to ps_air_far_cov_drop_w1_1/hover_in)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_air_far_cov_drop_w1_1/drop ps_air_far_cov_drop_w1_1/drop_face .01)
	(print "drop")
	(f_unload_fork ai_current_squad "right")
	(f_unload_fork ai_current_squad "left")
	(set b_sq_air_far_drop_w1_1_spawn FALSE)
	(cs_fly_to ps_air_far_cov_drop_w1_1/hover_out)
	(cs_vehicle_speed 1)
	(cs_fly_to ps_air_far_cov_drop_w1_1/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_to ps_air_far_cov_drop_w1_1/erase)
	(ai_erase ai_current_squad)

)



(script static void f_air_far_cleanup

	(sleep_forever f_air_far_main)

)

(global short s_zoneset_directon -1)
(global short direction_outward 0)
(global short direction_return 1)
(global short direction_return_coop 2)
(global short direction_inward 3)
(global short direction_inward_coop 4)
(global short direction_none 5)
(script static void (f_zoneset_direction (short dir))

	(set s_zoneset_directon dir)

	(if (= dir direction_outward)
		(begin

			(zone_set_trigger_volume_enable begin_zone_set:zoneset_courtyard_return FALSE)
			(zone_set_trigger_volume_enable begin_zone_set:zoneset_courtyard_valley_return:* FALSE)

			(zone_set_trigger_volume_enable begin_zone_set:zoneset_exterior TRUE)
			(zone_set_trigger_volume_enable zone_set:zoneset_exterior TRUE)

		)
	)

	(if (= dir direction_return)
		(begin
		
			(zone_set_trigger_volume_enable begin_zone_set:zoneset_courtyard_return FALSE)

			(zone_set_trigger_volume_enable begin_zone_set:zoneset_exterior TRUE)
			(zone_set_trigger_volume_enable zone_set:zoneset_exterior TRUE)
			(zone_set_trigger_volume_enable begin_zone_set:zoneset_courtyard_valley_return:* TRUE)

		)
	)

	(if (= dir direction_return_coop)
		(begin
		
			(zone_set_trigger_volume_enable begin_zone_set:zoneset_courtyard_return FALSE)
			(zone_set_trigger_volume_enable begin_zone_set:zoneset_exterior FALSE)
			(zone_set_trigger_volume_enable zone_set:zoneset_exterior FALSE)

			(zone_set_trigger_volume_enable begin_zone_set:zoneset_courtyard_valley_return:* TRUE)

		)
	)

	
	(if (= dir direction_inward)
		(begin
		
			(zone_set_trigger_volume_enable begin_zone_set:zoneset_courtyard_valley_return:* FALSE)
			(zone_set_trigger_volume_enable begin_zone_set:zoneset_interior FALSE)
			(zone_set_trigger_volume_enable zone_set:zoneset_interior FALSE)
			(zone_set_trigger_volume_enable begin_zone_set:zoneset_exterior FALSE)

			(zone_set_trigger_volume_enable zone_set:zoneset_exterior TRUE)
			(zone_set_trigger_volume_enable zone_set:zoneset_courtyard_return TRUE)

		)
	)

	(if (= dir direction_inward_coop)
		(begin
		
			(zone_set_trigger_volume_enable begin_zone_set:zoneset_courtyard_valley_return:* FALSE)
			(zone_set_trigger_volume_enable begin_zone_set:zoneset_interior FALSE)
			(zone_set_trigger_volume_enable zone_set:zoneset_interior FALSE)
			(zone_set_trigger_volume_enable begin_zone_set:zoneset_exterior FALSE)
			(zone_set_trigger_volume_enable zone_set:zoneset_exterior FALSE)

			(zone_set_trigger_volume_enable zone_set:zoneset_courtyard_return TRUE)

		)
	)


	(if (= dir direction_none)
		(begin

			(zone_set_trigger_volume_enable begin_zone_set:zoneset_exterior FALSE)
			(zone_set_trigger_volume_enable zone_set:zoneset_exterior FALSE)
			(zone_set_trigger_volume_enable begin_zone_set:zoneset_courtyard_valley_return:* FALSE)
			(zone_set_trigger_volume_enable zone_set:zoneset_courtyard_return FALSE)

		)
	)

)

; =================================================================================================
; =================================================================================================
; RETURN
; =================================================================================================
; =================================================================================================

(global short s_exterior_objective_last 0) ; 1 - airview, 2 - farragut
(script dormant f_return_main

	(sleep_until
		(and
			(= b_far_defended TRUE)
			(= b_air_defended TRUE)
		)
	5)
	
	; set third mission segment
	(data_mine_set_mission_segment "m20_03_return")

	(if (game_is_cooperative)(f_zoneset_direction direction_return_coop)(f_zoneset_direction direction_return) )
	(wake f_return_objective_nanny)

	; Standard Scripts
	(wake f_return_save_control)	
	(wake f_return_waypoint_control)	
	(wake f_return_missionobj_control)	
	(wake f_return_spawn_control)	
	(wake f_return_md_control)	
	(wake f_return_music_control)

	; Encounter Scripts
	(wake f_gatehouse_door_return)
	(wake f_return_strike_control)

	; Co-Op Scripts
	(if (game_is_cooperative)
		(begin
			(wake f_return_coop_teleport)
		)
	)
	(f_ai_detail ai_detail_low)	

	(if b_debug (print "objective control : return.01"))
	(set b_insertion_fade_in TRUE)
	(set s_objcon_return 1)
	(game_insertion_point_unlock 2)

	(sleep_until (volume_test_players tv_return_10) 5)
	(if b_debug (print "objective control : return.10"))
	(set s_objcon_return 10)

	(sleep_until (volume_test_players tv_return_20) 5)
	(if b_debug (print "objective control : return.20"))
	(set s_objcon_return 20)

	(sleep_until (volume_test_players tv_return_30) 5)
	(if b_debug (print "objective control : return.30"))
	(set s_objcon_return 30)

)

(script dormant f_return_strike_control

	(sleep (* 30 5))
	(if (difficulty_is_heroic_or_lower)
		(begin
			(airstrike_set_launches 2)
		)
	)	

)


(script dormant f_return_objective_nanny

	(sleep_until (>= s_objcon_return 10))

	(wake f_return_objective_kat)
	(ai_set_objective obj_valley_hum obj_return_hum)

	(sleep_until
	
			(begin
		
			(f_squad_set_obj_area obj_return_hum tv_area_return_wide)

		(or
			(>= s_objcon_garage 1)
			(<= (ai_living_count obj_return_cov) 2)
		))
		
	(* 30 1))

	(sleep_forever f_return_objective_kat)
	(sleep_forever f_return_distance_kat)

	(f_vehicle_goto_set vehicle_return)
	(f_squad_set_obj gr_vehicles_hum obj_vehicles_hum)

)


(script dormant f_return_objective_kat

	(sleep_until (volume_test_object tv_area_valley o_kat) 3)
	(ai_set_objective gr_spartans obj_return_hum)
	(wake f_return_distance_kat)

)

(global boolean b_return_kat_regroup FALSE)
(script dormant f_return_distance_kat

	(sleep_until
		(begin

			(if (>= (objects_distance_to_object (players) o_kat) 17) (set b_return_kat_regroup TRUE) (set b_return_kat_regroup FALSE) )
	
		FALSE)
	30)

)


(script dormant f_return_save_control

	(sleep_until (>= s_objcon_return 10))
	(game_save_no_timeout)

)

(global boolean b_mo_return FALSE)
(script dormant	f_return_missionobj_control

	(sleep_until
		(or
			(= s_exterior_objective_last 0)
			(>= s_objcon_return 10)
			(and
				(= s_exterior_objective_last 1)
				b_air_spawn_done
				b_far_defended
			)
			(and
				(= s_exterior_objective_last 2)
				b_far_spawn_done
				b_air_defended
			)
		)
	)
	(sleep 200)
	(tit_return)
	(sleep 200)
	(mo_return)
	(md_return_pre_intro)

)

(global short s_return_waypoint_timer 120)
(script dormant f_return_waypoint_control

	; Nonlinear

	; Linear
	(sleep_until (>= s_objcon_return 30) 5 (* 30 s_return_waypoint_timer))
	(if (not (>= s_objcon_return 30))
		(begin
			(f_blip_flag fl_return_waypoint_1 blip_destination)
			(sleep_until (>= s_objcon_return 30) 5)
			(f_unblip_flag fl_return_waypoint_1)
		)
	)

)

(script dormant f_return_music_control

	(if b_ins_return
		(begin
			(dprint "return music start")
			(wake f_return_covvehicle_tracker)
		)
	)

)

(script dormant f_return_covvehicle_tracker

	(dprint "tracking cov vehicles")
	(sleep_until (>= s_objcon_return 10))
	(sleep_until (> (ai_task_count obj_return_cov/gate_revenant) 0) 5)
	(dprint "revenants exist")
	(sleep_until (<= (ai_task_count obj_return_cov/gate_revenant) 0) 5)
	(dprint "revenants down")
	(set s_music_return 2)

)

(script dormant f_return_md_control

	; Linear
	(sleep_until (>= s_objcon_return 10))
	(md_return_intro)

	(sleep 30)
	(if b_ins_return
		(begin
			(wake music_return)
			(set s_music_return 1)
		)
	)

)

(script dormant f_return_spawn_control

	(ai_place sq_return_phantom_1)
	(sleep (* 30 2))
	(ai_place sq_return_phantom_2)

	(if
		(or 
			(volume_test_players tv_area_air_wide)
			(volume_test_players tv_area_return_wide)
		)
		(begin
			(ai_place sq_return_air_phantom_1)
			(sleep (* 30 2))
			(ai_place sq_return_air_phantom_2)
		)(begin
			(ai_place sq_return_far_phantom_1)
	)	)

)

(global boolean b_sq_return_phantom_1_spawn FALSE)
(script command_script f_cs_return_phantom_1

	(cs_enable_targeting TRUE)
	(cs_ignore_obstacles TRUE)

	(set b_sq_return_phantom_1_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(f_load_phantom_cargo (ai_vehicle_get ai_current_actor) "single" sq_return_ghost_1 NONE)
	(f_load_phantom (ai_vehicle_get ai_current_actor) "right" sq_return_cov_1 NONE NONE NONE)
	(cs_fly_to ps_return_phantom_1/enter_01)
	(cs_fly_to ps_return_phantom_1/enter_02)
	(cs_enable_targeting TRUE)
	(cs_fly_to_and_face ps_return_phantom_1/hover_in ps_return_phantom_1/hover_in_face .25)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_return_phantom_1/drop ps_return_phantom_1/drop_face .25)
	(f_unload_phantom_cargo ai_current_squad "single")
	(f_unload_phantom ai_current_squad "right")
	(sleep (* 30 3))
	(set b_sq_return_phantom_1_spawn FALSE)
	(cs_fly_to ps_return_phantom_1/hover_out)
	(cs_fly_to ps_return_phantom_1/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_to ps_return_phantom_1/erase)
	(ai_erase ai_current_squad)

)

(global boolean b_sq_return_phantom_2_spawn FALSE)
(script command_script f_cs_return_phantom_2

	(cs_enable_targeting TRUE)
	(cs_ignore_obstacles TRUE)

	(set b_sq_return_phantom_2_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(f_load_phantom_cargo (ai_vehicle_get ai_current_actor) "double" sq_return_revenant_1 sq_return_revenant_2)
	(cs_fly_to ps_return_phantom_2/enter_02)
	(cs_enable_targeting TRUE)
	(cs_fly_to ps_return_phantom_2/hover_in)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_return_phantom_2/drop ps_return_phantom_2/drop_face .25)
	(f_unload_phantom_cargo ai_current_squad "double")
	(sleep (* 30 3))
	(set b_sq_return_phantom_2_spawn FALSE)
	(cs_fly_to ps_return_phantom_2/hover_out)
	(cs_fly_to ps_return_phantom_2/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_to ps_return_phantom_2/erase)
	(ai_erase ai_current_squad)

)


(global boolean b_sq_return_air_phantom_1_spawn FALSE)
(script command_script f_cs_return_air_phantom_1

	(cs_enable_targeting TRUE)
	(cs_ignore_obstacles TRUE)

	(set b_sq_return_air_phantom_1_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(f_load_phantom_cargo (ai_vehicle_get ai_current_actor) "single" sq_return_air_revenant_1 NONE)
	(cs_fly_to_and_face ps_return_air_phantom_1/enter_01 ps_return_air_phantom_1/enter_01_face .25)
	(cs_fly_to_and_face ps_return_air_phantom_1/enter_01a ps_return_air_phantom_1/enter_01a_face .25)
	(cs_fly_to_and_face ps_return_air_phantom_1/enter_02 ps_return_air_phantom_1/enter_02_face .25)
	(cs_enable_targeting TRUE)
	(cs_fly_to_and_face ps_return_air_phantom_1/hover_in ps_return_air_phantom_1/drop_face .25)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_return_air_phantom_1/drop ps_return_air_phantom_1/drop_face .25)
	(f_unload_phantom_cargo ai_current_squad "single")
	(sleep (* 30 3))
	(set b_sq_return_air_phantom_1_spawn FALSE)
	(cs_fly_to_and_face ps_return_air_phantom_1/hover_out ps_return_air_phantom_1/drop_face .25)
	(cs_fly_to_and_face ps_return_air_phantom_1/exit_01 ps_return_air_phantom_1/exit_01_face .25)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_to_and_face ps_return_air_phantom_1/erase ps_return_air_phantom_1/erase_face .25)
	(ai_erase ai_current_squad)

)


(global boolean b_sq_return_air_phantom_2_spawn FALSE)
(script command_script f_cs_return_air_phantom_2

	(cs_enable_targeting TRUE)
	(cs_ignore_obstacles TRUE)

	(set b_sq_return_air_phantom_2_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(f_load_phantom_cargo (ai_vehicle_get ai_current_actor) "double" sq_return_air_ghost_1 NONE)
	(f_load_phantom (ai_vehicle_get ai_current_actor) "dual" sq_return_cov_2 NONE NONE NONE)
	(cs_fly_to_and_face ps_return_air_phantom_2/enter_01 ps_return_air_phantom_2/enter_01_face .25)
	(cs_fly_to_and_face ps_return_air_phantom_2/enter_01a ps_return_air_phantom_2/enter_01a_face .25)
	(cs_fly_to_and_face ps_return_air_phantom_2/enter_02 ps_return_air_phantom_2/enter_02_face .25)
	(cs_ignore_obstacles TRUE)
	(cs_fly_to_and_face ps_return_air_phantom_2/hover_in ps_return_air_phantom_2/drop_face .25)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_return_air_phantom_2/drop ps_return_air_phantom_2/drop_face .25)
	(f_unload_phantom_cargo ai_current_squad "double")
	(f_unload_phantom ai_current_squad "dual")
	(sleep (* 30 3))
	(set b_sq_return_air_phantom_1_spawn FALSE)
	(cs_fly_to_and_face ps_return_air_phantom_2/hover_out ps_return_air_phantom_2/drop_face .25)
	(cs_fly_to_and_face ps_return_air_phantom_2/exit_01 ps_return_air_phantom_2/exit_01_face .25)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_to_and_face ps_return_air_phantom_2/erase ps_return_air_phantom_2/erase_face .25)
	(ai_erase ai_current_squad)

)


(global boolean b_sq_return_far_phantom_1_spawn FALSE)
(script command_script f_cs_return_far_phantom_1

	(cs_enable_targeting TRUE)
	(cs_ignore_obstacles TRUE)

	(set b_sq_return_far_phantom_1_spawn TRUE)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 0)
	(object_set_scale (ai_vehicle_get ai_current_actor) 1 (* 30 5))
	(f_load_phantom_cargo (ai_vehicle_get ai_current_actor) "double" sq_return_far_revenant_1 NONE)
	(f_load_phantom (ai_vehicle_get ai_current_actor) "dual" sq_return_cov_2 NONE NONE NONE)
	(ai_set_task sq_return_cov_2 obj_return_cov far_cov_1)
	(cs_fly_to ps_return_far_phantom_1/enter_01)
	(cs_fly_to ps_return_far_phantom_1/enter_02)
	(cs_fly_to ps_return_far_phantom_1/hover_in)
	(cs_vehicle_speed .5)
	(cs_fly_to_and_face ps_return_far_phantom_1/drop ps_return_far_phantom_1/drop_face .35)
	(f_unload_phantom_cargo ai_current_squad "double")
	(f_unload_phantom ai_current_squad "dual")
	(sleep (* 30 3))
	(set b_sq_return_far_phantom_1_spawn FALSE)
	(cs_fly_to ps_return_far_phantom_1/hover_out)
	(cs_fly_to ps_return_far_phantom_1/exit_01)
	(object_set_scale (ai_vehicle_get ai_current_actor) 0.01 (* 30 10))
	(cs_fly_to ps_return_far_phantom_1/erase)
	(ai_erase ai_current_squad)

)

(script dormant f_return_coop_teleport

	(sleep_until (volume_test_players begin_zone_set:zoneset_courtyard_valley_return:*) 5)

	(sleep_until
		(begin

				(cond
					((volume_test_object tv_courtyard_valley_coop_teleport player0)
						(if (unit_in_vehicle (player0))
							(begin
								(object_teleport_to_ai_point (object_get_parent player0) ps_return_coop/player0)
							)(begin
								(object_teleport_to_ai_point player0 ps_return_coop/player0)
						))
					)
					((volume_test_object tv_courtyard_valley_coop_teleport player1)
						(if (unit_in_vehicle (player1))
							(begin
								(object_teleport_to_ai_point (object_get_parent player1) ps_return_coop/player1)
							)(begin
								(object_teleport_to_ai_point player1 ps_return_coop/player1)
						))
					)
					((volume_test_object tv_courtyard_valley_coop_teleport player2)
						(if (unit_in_vehicle (player2))
							(begin
								(object_teleport_to_ai_point (object_get_parent player2) ps_return_coop/player2)
							)(begin
								(object_teleport_to_ai_point player2 ps_return_coop/player2)
						))
					)
					((volume_test_object tv_courtyard_valley_coop_teleport player3)
						(if (unit_in_vehicle (player3))
							(begin
								(object_teleport_to_ai_point (object_get_parent player3) ps_return_coop/player3)
							)(begin
								(object_teleport_to_ai_point player3 ps_return_coop/player3)
						))
					)

				)
		FALSE)
	1)
)



(script static void f_return_cleanup

	(sleep_forever f_return_main)

)

; =================================================================================================
; =================================================================================================
; GARAGE
; =================================================================================================
; =================================================================================================

(script dormant f_garage_main

	(sleep_until
		(and
			(volume_test_players tv_garage_start)
			b_far_defended
			b_air_defended
			b_garage_ready
			;(<= (ai_task_count obj_valley02_cov/inf_return) 2)
		)
	5)
	(if b_debug (print "::: ENCOUNTER START: Garage"))
	
	; set fourth mission segment
	(data_mine_set_mission_segment "m20_04_garage")

	(device_set_position_immediate dm_garagedoor_1 1)
	(device_set_position_immediate dm_garagedoor_2 1)

	(sleep 10)

	; Standard Scripts
	(wake f_garage_save_control)
	(wake f_garage_waypoint_control)
	(wake f_garage_music_control)
	(wake f_garage_spawn_control)
	(wake f_garage_md_control)
	
	; Encounter Scripts
	(wake f_garage_elevator_control)
	(wake f_garage_door_control)
	(wake f_garage_objective_nanny)
	
	(if b_debug (print "objective control : garage.01"))
	(set b_insertion_fade_in TRUE)
	(set s_objcon_garage 1)
	
	(sleep_until (volume_test_players tv_garage_elbowstart) 5)
	(if b_debug (print "objective control : garage.02"))
	(set s_objcon_garage 2)

	(sleep_until (volume_test_players tv_garage_elbowmid) 5)
	(if b_debug (print "objective control : garage.03"))
	(set s_objcon_garage 3)

	(sleep_until (volume_test_players tv_garage_elbowend) 5)
	(if b_debug (print "objective control : garage.04"))
	(set s_objcon_garage 4)

	(sleep_until (volume_test_players tv_garage_fight) 5)
	(if b_debug (print "objective control : garage.05"))
	(set s_objcon_garage 5)

	(sleep_until (volume_test_players tv_garage_int_start) 5)
	(if b_debug (print "objective control : garage.10"))
	(set s_objcon_garage 10)

	(sleep_until (<= (ai_task_count obj_garage_cov/gate_hunters) 0))
	(if b_debug (print "objective control : garage.20"))
	(set s_objcon_garage 20)

)

(script dormant f_garage_objective_nanny

	(ai_set_objective gr_hum obj_garage_hum)
	(ai_set_objective gr_spartans obj_garage_hum)

	(sleep_until
	
		(begin
		
			(f_squad_set_obj_area obj_garage_hum tv_area_court)

			; Break out condition
			(>= s_objcon_sword 1)

		)
		
	(* 30 1))


)

(script command_script f_cs_exit_vehicle

	(ai_vehicle_reserve (ai_vehicle_get ai_current_actor) TRUE)
	(ai_vehicle_exit ai_current_actor)
	(sleep 30)

)

(script dormant f_garage_save_control

	(sleep_until (>= s_objcon_garage 20))
	(sleep 10)
	(dprint "garage save 2")
	(game_save_no_timeout)

)

(global short s_garage_waypoint_timer 120)
(script dormant f_garage_waypoint_control

	; Nonlinear

	; Linear

	(sleep_until (>= s_objcon_garage 10) 5 (* 30 s_garage_waypoint_timer))
	(if (not (>= s_objcon_garage 10))
		(begin
			(f_blip_flag fl_garage_waypoint_1 blip_destination)
			(sleep_until (>= s_objcon_garage 10) 5)
			(f_unblip_flag fl_garage_waypoint_1)
		)
	)

)


(script dormant f_garage_door_control

	(sleep_until (>= s_objcon_garage 2) 5)
	(device_set_position dm_valley_door_large 0)
	(device_set_position dm_valley_door_small 0)
	(sleep_until (<= (device_get_position dm_valley_door_large) 0) 5)

	; Coop Teleport Failsafe

	(if (game_is_cooperative)
		(begin
			(if
				(not
					(or
						(volume_test_object tv_area_court player0)
						(volume_test_object tv_area_garage player0)
						(volume_test_object tv_area_elevator player0)
						(volume_test_object tv_area_sword player0)
					)
				)
				(begin
					(object_teleport_to_ai_point player0 ps_garage_spawn/player0)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_court player1)
						(volume_test_object tv_area_garage player1)
						(volume_test_object tv_area_elevator player1)
						(volume_test_object tv_area_sword player1)
					)
				)
				(begin
					(object_teleport_to_ai_point player1 ps_garage_spawn/player1)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_court player2)
						(volume_test_object tv_area_garage player2)
						(volume_test_object tv_area_elevator player2)
						(volume_test_object tv_area_sword player2)
					)
				)
				(begin
					(object_teleport_to_ai_point player2 ps_garage_spawn/player2)
				)
			)
		
			(if
				(not
					(or
						(volume_test_object tv_area_court player3)
						(volume_test_object tv_area_garage player3)
						(volume_test_object tv_area_elevator player3)
						(volume_test_object tv_area_sword player3)
					)
				)
				(begin
					(object_teleport_to_ai_point player3 ps_garage_spawn/player3)
				)
			)
		)
	)


	(zone_set_trigger_volume_enable begin_zone_set:zoneset_courtyard_valley_return:* FALSE)
	(tick)
	(zone_set_trigger_volume_enable begin_zone_set:zoneset_courtyard_return TRUE)	
	(sleep_forever f_gatehouse_door_return_triggers)
	(sleep_forever f_gatehouse_door_return_switch)
	(sleep_forever f_gatehouse_door_timer)
	(sleep_forever f_gatehouse_door_objects)
	(sleep_forever f_return_coop_teleport)
	(ai_erase gr_air_cov)
	(ai_erase gr_far_cov)
	(ai_erase gr_air_far_cov)
	(ai_erase gr_valley_cov)

	(sleep (* 30 5))
	(game_save_no_timeout)

)

(script dormant f_garage_spawn_control

	(sleep_until (volume_test_players tv_garage_kat) 1)
	(f_squad_group_place gr_garage_cov_init)
	(if (= s_special_elite 1) (ai_place sq_garage_bob) )

	(sleep_until
		(and
			(<= (device_get_position dm_valley_door_large) 0)
			(>= s_objcon_garage 3)
		)		
	5)
	(f_ai_detail ai_detail_low)
	(f_squad_group_place gr_garage_cov_init_inside)
	(f_squad_group_place gr_garage_hum_init_inside)

	(sleep_until 
		(begin
			(ai_renew gr_garage_cov_init_inside)
			(ai_renew gr_garage_hum_init_inside)
			(volume_test_players tv_garage_fight)
		)
	5)
	
)

(script dormant f_garage_md_control

	(sleep_until (>= s_objcon_garage 20) 5)
	(md_garage_clear)
	(sleep (* 30 5))
	(md_garage_elevator_prompt)

)


(script dormant f_garage_music_control


	(if b_ins_return (begin
	
		(set s_music_return 2)
		(sleep 30)
	
	))

	(sleep_until (>= s_objcon_garage 1) 5)
	(wake music_garage)
	(set s_music_garage 1)

	(sleep_until (>= s_objcon_garage 5) 5)
	(set s_music_garage 2)
	(wake f_garage_hunter_tracker)

)

(script dormant f_garage_hunter_tracker

	(sleep_until
		(or
			(<= (ai_living_count sq_garage_hunter_1) 0)
			(<= (ai_living_count sq_garage_hunter_2) 0)
		)
	)
	(set s_music_garage 3)

	(sleep_until
		(and
			(<= (ai_living_count sq_garage_hunter_1) 0)
			(<= (ai_living_count sq_garage_hunter_2) 0)
		)
	)
	(set s_music_garage 4)

)

(global short s_elevator_coop_count 0)
(global boolean b_garage_elevator_open FALSE)
(script dormant f_garage_elevator_control

	(sleep_until (>= s_objcon_garage 20) 5)
	(dprint "elevator ready")
	(f_blip_object dc_garage_elevator_button blip_interface)
	(device_set_position_track dm_garage_elevator "device:position" 0)
  (device_animate_position dm_garage_elevator .099 1 0.034 0.034 false)

	(sleep_until (> (device_get_position dc_garage_elevator_button) 0) 5)
	(set b_save_continuous FALSE)
	(soft_ceiling_enable soft_ceiling_interior 1)
	(soft_ceiling_enable camera_blocker_07 1)
	(soft_ceiling_enable camera_blocker_08 1)
	(soft_ceiling_enable camera_blocker_09 1)
	(soft_ceiling_enable default 0)
	(f_unblip_object dc_garage_elevator_button)
	(set s_music_garage 5)
	(add_recycling_volume tv_area_elevator_wide 0 0)

  (device_animate_position dm_garage_elevator .5 7 0.5 0.5 false)

	(sleep_until (>= (device_get_position dm_garage_elevator) .15) 1)

	(if (volume_test_object tv_area_elevator player0) (set s_elevator_coop_count (+ s_elevator_coop_count 1)))
	(if (volume_test_object tv_area_elevator player1) (set s_elevator_coop_count (+ s_elevator_coop_count 1)))
	(if (volume_test_object tv_area_elevator player2) (set s_elevator_coop_count (+ s_elevator_coop_count 1)))
	(if (volume_test_object tv_area_elevator player3) (set s_elevator_coop_count (+ s_elevator_coop_count 1)))
	
	(if
		(or
			(and
				(not (game_is_cooperative))
				(< s_elevator_coop_count 1)					
			)			
			(and
				(= (game_coop_player_count) 2)
				(< s_elevator_coop_count 2)					
			)
			(and
				(= (game_coop_player_count) 3)
				(< s_elevator_coop_count 3)					
			)
			(and
				(= (game_coop_player_count) 4)
				(< s_elevator_coop_count 4)					
			)
		)
		(begin
	
			(dprint "failsafe elevator coop teleport")
			(object_teleport_to_ai_point o_kat ps_sword_elevator/kat)
			(sleep 1)
			(object_teleport_to_ai_point (player0) ps_sword_elevator/player0)
			(sleep 1)
			(object_teleport_to_ai_point (player1) ps_sword_elevator/player1)
			(sleep 1)
			(object_teleport_to_ai_point (player2) ps_sword_elevator/player2)
			(sleep 1)
			(object_teleport_to_ai_point (player3) ps_sword_elevator/player3)

		)
	)
	
	(zone_set_trigger_volume_enable begin_zone_set:zoneset_interior TRUE)
	
	(sleep_until (>= (device_get_position dm_garage_elevator) .4) 1)
	(wake f_garage_bomb_1)

	(sleep_until (>= (device_get_position dm_garage_elevator) .5) 1)

	(sleep 120)

  (device_animate_position dm_garage_elevator .9 7 0.5 0.034 false)

	(sleep_until (>= (device_get_position dm_garage_elevator) .75) 1)
	(zone_set_trigger_volume_enable zone_set:zoneset_interior TRUE)

	(sleep (* 30 2))
	(ai_set_objective gr_spartans obj_sword_hum)
	(cs_run_command_script sq_kat f_cs_elevator_out)
	(sleep (* 30 3))
	(set b_save_continuous TRUE)

)


(script command_script f_cs_elevator_in

	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(cs_go_to ps_garage_kat_elevator/in .1)
	(cs_go_to ps_garage_kat_elevator/so_in .1)

)

(script command_script f_cs_elevator_out

	(cs_enable_looking TRUE)
	(cs_enable_moving TRUE)
	(cs_enable_targeting TRUE)
	(cs_go_to ps_sword_kat_elevator/out .1)

)


(script dormant f_garage_bomb_1

	(set b_shake TRUE)
	(sleep 60)
	
	(sound_impulse_start sound\levels\020_base\base_scripted_expl1a NONE 1)
	(dprint "garage bomb")
	(object_create_anew es_interp_10)
	(interpolator_start base_bombing)
	(md_garage_bomb)
	(sleep (* 30 10))
	(object_destroy es_interp_10)


)

(script command_script f_cs_garage_hunter
	(cs_abort_on_damage TRUE)
	(cs_enable_moving TRUE)
	(cs_shoot_point TRUE ps_garage_hunter/shoot_01)
	(sleep_until (volume_test_players tv_garage_int_start) 1)
)

(script static void f_garage_cleanup

	(sleep_forever f_garage_main)

)

; =================================================================================================
; =================================================================================================
; SWORD
; =================================================================================================
; =================================================================================================

(script dormant f_sword_main
	
	(sleep_until
		(or
			b_sword_ready
			(volume_test_players tv_sword_start)
		)
	5)
	(if b_debug (print "::: ENCOUNTER START: Sword"))
	(f_loadout_set "interior")
	
	; set fifth mission segment
	(data_mine_set_mission_segment "m20_05_sword")
	
	; Standard Scripts
	(wake f_sword_save_control)
	(wake f_sword_waypoint_control)
	(wake f_sword_missionobj_control)
	(wake f_sword_spawn_control)
	(wake f_sword_music_control)
	(wake f_sword_md_control)
	(wake f_sword_objective_nanny)

	; Encounter Scripts
	(wake f_sword_door_control)
	(wake f_sword_bomb_control)
	(wake f_sword_camera_control)
	(wake f_sword_fireteam_control)

	(if b_debug (print "objective control : sword.01"))
	(set b_insertion_fade_in TRUE)
	(if (not (> s_objcon_sword 1)) (set s_objcon_sword 1) )

	(f_recycle_outside)
	(ai_erase gr_exterior_cov)

	(sleep_until (or (volume_test_players tv_sword_10) (>= s_objcon_sword 10) ) 1)
	(dprint "objective control : sword.10")
	(if (not (> s_objcon_sword 10)) (set s_objcon_sword 10) )

	(sleep_until (or (volume_test_players tv_sword_20) (>= s_objcon_sword 20) ) 1)
	(dprint "objective control : sword.20")
	(if (not (> s_objcon_sword 20)) (set s_objcon_sword 20) )

	(sleep_until (or (volume_test_players tv_sword_25) (>= s_objcon_sword 25) ) 1)
	(dprint "objective control : sword.25")
	(if (not (> s_objcon_sword 25)) (set s_objcon_sword 25) )

	(sleep_until (volume_test_players tv_sword_27) 5)
	(if b_debug (print "objective control : sword.27"))
	(set s_objcon_sword 27)

	(sleep_until (volume_test_players tv_sword_30) 5)
	(if b_debug (print "objective control : sword.30"))
	(set s_objcon_sword 30)

	(sleep_until (volume_test_players tv_sword_32) 5)
	(if b_debug (print "objective control : sword.32"))
	(set s_objcon_sword 32)

	(sleep_until (volume_test_players tv_sword_35) 5)
	(if b_debug (print "objective control : sword.35"))
	(set s_objcon_sword 35)

	(sleep_until (volume_test_players tv_sword_40) 5)
	(if b_debug (print "objective control : sword.40"))
	(set s_objcon_sword 40)

	(sleep_until (volume_test_players tv_sword_50) 5)
	(if b_debug (print "objective control : sword.50"))
	(set s_objcon_sword 50)

	(sleep_until (volume_test_players tv_sword_55) 5)
	(if b_debug (print "objective control : sword.55"))
	(set s_objcon_sword 55)

	(sleep_until (volume_test_players tv_sword_57) 5)
	(if b_debug (print "objective control : sword.57"))
	(set s_objcon_sword 57)

	(set s_music_sword 3)

	(sleep_until (volume_test_players tv_sword_60) 5)
	(if b_debug (print "objective control : sword.60"))
	(set s_objcon_sword 60)

	(sleep_until (volume_test_players tv_sword_70) 5)
	(if b_debug (print "objective control : sword.70"))
	(set s_objcon_sword 70)

)

(script dormant f_sword_objective_nanny

	(ai_set_objective gr_hum obj_sword_hum)

)

(script dormant f_sword_flock_control

	(flock_delete flock_exterior_banshee_01)
	(flock_delete flock_exterior_falcon_01)
	(flock_delete flock_exterior_banshee_02)
	(flock_delete flock_exterior_falcon_02)
	(flock_create flock_exterior_phantom_01)

	(flock_create flock_interior_phantom_01)
	(flock_create flock_interior_banshee_01)
	(flock_create flock_interior_falcon_01)

)

(script static void f_cin_intro_prep

	(object_create sc_cin_terrain_blocker)

	(ai_place gr_intro_hum)
	(ai_place gr_intro_cov)
	(tick)
	(ai_cannot_die gr_intro_hum TRUE)
	(ai_cannot_die gr_intro_cov TRUE)

)

(script static void f_cin_intro_finish

	(ai_cannot_die gr_intro_hum FALSE)
	(ai_cannot_die gr_intro_cov FALSE)
	(tick)
	(ai_erase gr_intro_hum)
	(ai_erase gr_intro_cov)

)

(script dormant f_sword_fireteam_control

	; Fireteam setup
	(wake f_fireteam_setup)
	(sleep_until (>= s_objcon_sword 25) 5)
	(f_train_fireteams_1)
	(wake f_train_fireteams_2_p0)
	(wake f_train_fireteams_2_p1)
	(wake f_train_fireteams_2_p2)
	(wake f_train_fireteams_2_p3)

)


(script dormant f_sword_camera_control

		(tick)


;*

		(vehicle_auto_turret #_security_camera_interior_02 tv_roof_start 1 1 1)
		(vehicle_auto_turret #_security_camera_interior_01 tv_camera_01 1 1 1)
		(vehicle_auto_turret #_security_camera_interior_03 tv_camera_03 1 1 1)
		(vehicle_auto_turret #_oni_ext_security_camera_01 tv_middle_cameras 1 1 1)
		(vehicle_auto_turret #_oni_ext_security_camera_02 tv_middle_cameras 1 1 1)
		(vehicle_auto_turret #_oni_ext_security_camera_04 tv_camera_05 1 1 1)
		(vehicle_auto_turret #_security_camera_interior_07 tv_camera_04 1 1 1)
		(vehicle_auto_turret #_security_camera_interior_09 tv_camera_04 1 1 1)
		(vehicle_auto_turret #_security_camera_interior_05 tv_camera_06 1 1 1)
		(vehicle_auto_turret #_security_camera_interior_04 tv_sword_security 1 1 1)
		(vehicle_auto_turret #_security_camera_interior_10 tv_sword_security 1 1 1)		
		(vehicle_auto_turret #_security_camera_interior_11 tv_camera_07 1 1 1)		
		(vehicle_auto_turret #_security_camera_interior_06 tv_camera_07 1 1 1)		

*;

)

(script dormant f_sword_save_control

	(sleep_until (>= s_objcon_sword 1))
	(sleep (* 30 6))
	(game_save_no_timeout)

	(sleep_until (>= s_objcon_sword 25))
	(game_save_no_timeout)

	(sleep_until (>= s_objcon_sword 40))
	(game_save_no_timeout)

	(sleep_until (>= s_objcon_sword 50))
	(game_save_no_timeout)

)


(script dormant	f_sword_missionobj_control

	(sleep_until (>= s_objcon_sword 1))
	(tit_sword)
	(sleep 200)
	(mo_sword)

)

(global short s_roof_waypoint_timer 300)
(script dormant f_sword_waypoint_control

	; Nonlinear

	; Linear
	(sleep_until (>= s_objcon_sword 25) 5 (* 30 s_roof_waypoint_timer))
	(if (not (>= s_objcon_sword 25))
		(begin
			(f_blip_flag fl_sword_waypoint_1 blip_destination)
			(sleep_until (>= s_objcon_sword 25) 5)
			(f_unblip_flag fl_sword_waypoint_1)
		)
	)

)

(script dormant f_sword_door_control




;*

	(device_operates_automatically_set #_door_interior_standard_glass_01 FALSE)
	(device_operates_automatically_set #_door_interior_standard_glass_03 FALSE)
	(device_closes_automatically_set #_door_interior_standard_glass_01 FALSE)
	(device_closes_automatically_set #_door_interior_standard_glass_03 FALSE)
	(device_set_position_immediate #_door_interior_standard_glass_01 1)
	(device_set_position_immediate #_door_interior_standard_glass_03 1)

*;

	(sleep_until (>= s_objcon_sword 20) 5)
	(device_set_position dm_door_atrium 1)
	(tick)
	(device_operates_automatically_set dm_door_atrium TRUE)


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

(script dormant f_sword_bomb_control

	(f_object_create_frozen cr_sword_panel_1_1)
	(f_object_create_frozen cr_sword_panel_1_2)
	(f_object_create_frozen cr_sword_panel_1_3)
	(f_object_create_frozen cr_sword_panel_1_4)

	(f_object_create_frozen cr_sword_panel_2_1)
	(f_object_create_frozen cr_sword_panel_2_2)
	(f_object_create_frozen cr_sword_panel_2_3)
	(f_object_create_frozen cr_sword_panel_2_4)

	(if (not b_test_hallbomb)
		(begin
			(sleep_until (volume_test_players tv_sword_strike_door) 5)
			(wake f_sword_bomb_0)
		)
	)

	(sleep_until (volume_test_players tv_sword_strike_top) 5)
	(wake f_sword_bomb_1)
	(set s_music_sword 4)

)

(script dormant f_sword_bomb_0

	(set b_shake TRUE)
	(sleep 60)

	(f_object_fall_forward cr_sword_panel_1_1)
	(sleep (random_range 2 7))
	(f_object_fall_forward cr_sword_panel_1_4)
	(sleep (random_range 2 7))
	(f_object_fall_forward cr_sword_panel_1_3)
	(sleep (random_range 2 7))
	(f_object_fall_forward cr_sword_panel_1_2)


	(sound_impulse_start sound\levels\020_base\base_scripted_expl2a NONE 1)

	(dprint "sword bomb 0")
	(object_create_anew es_interp_10)
	(interpolator_start base_bombing)
	(md_sword_bomb_0)
	(sleep (* 30 10))
	(object_destroy es_interp_10)


)

(script dormant f_sword_bomb_1	

	(set b_shake TRUE)
	(sleep 60)

	(f_object_fall_forward cr_sword_panel_2_4)
	(sleep (random_range 2 7))
	(f_object_fall_forward cr_sword_panel_2_2)
	(sleep (random_range 2 7))
	(f_object_fall_forward cr_sword_panel_2_1)
	(sleep (random_range 2 7))
	(f_object_fall_forward cr_sword_panel_2_3)


	(sound_impulse_start sound\levels\020_base\base_scripted_expl1a NONE 1)

	(dprint "sword bomb 1")
	(object_create_anew es_interp_10)
	(interpolator_start base_bombing)
	(md_sword_bomb_1)
	(sleep (* 30 10))
	(object_destroy es_interp_10)

)

(script static void (f_object_create_frozen (object_name o_freeze))

	(object_create o_freeze)
	(object_dynamic_simulation_disable o_freeze true)

)

(script static void (f_object_fall_forward (object_name o_fall))

	(dprint "fall") 
	(object_dynamic_simulation_disable o_fall FALSE)
	(object_set_velocity o_fall -0.8 0 0)

)

(script dormant f_sword_md_control

	; Linear
	(sleep_until (>= s_objcon_sword 1) 5)
	(sleep (* 30 2))
	(md_sword_enter)

	(sleep_until (>= s_objcon_sword 10) 5)
	(md_sword_scanner)

	(sleep_until (>= s_objcon_sword 25) 5)
	(sleep (* 30 3))
	(md_sword_atrium)

	(sleep_until (>= s_objcon_roof 1) 1 (* 30 180))
	(if (not (>= s_objcon_roof 1))
		(md_sword_delay_0)
	)

	(sleep_until (>= s_objcon_roof 1) 1 (* 30 180))
	(if (not (>= s_objcon_roof 1))
		(md_sword_delay_1)
	)

)

(script dormant f_sword_music_control

	(sleep_until (>= s_objcon_sword 1))
	(wake music_sword)

)

(script dormant f_sword_spawn_control

	(if (< s_objcon_sword 20)
		(begin
			(f_squad_group_place gr_sword_cov_init_lobby)
		)
	)

	(sleep_until (>= s_objcon_sword 20))
	(wake f_sword_jun_control)
	(wake f_sword_jorge_control)

	(f_squad_group_place gr_sword_cov_init_interior)
	(f_squad_group_place gr_sword_hum_init_interior)

	(if (= (game_coop_player_count) 1) (begin
	
		(f_squad_group_place gr_sword_hum_marine_3_stranded)

	))

	(if (= (game_coop_player_count) 2) (begin
	
		(ai_place sq_sword_marine_3_stranded/male)
		(ai_place sq_sword_marine_3_stranded/female_1)

	))

	(if (= (game_coop_player_count) 3) (begin
	
		(ai_place sq_sword_marine_3_stranded/male)

	))

	(sleep_until (>= s_objcon_sword 30))
	(ai_place sq_sword_cov_2_closet)
	(ai_place sq_sword_cov_2_room_1)
	(ai_place sq_sword_cov_2_room_2)
	(soft_ceiling_enable camera_blocker_07 0)

	(sleep_until (>= s_objcon_sword 35))
	(ai_place sq_sword_cov_3_snipers)
	(ai_place sq_sword_cov_3_room)
	(ai_place sq_sword_cov_3_stair)
	(ai_place sq_sword_cov_3_conference)
	(if (= s_special_elite 2) (ai_place sq_sword_bob) )
	(soft_ceiling_enable camera_blocker_08 0)


	(sleep_until (>= s_objcon_sword 50))
	(ai_place sq_sword_cov_4_boss)
	(ai_place sq_sword_cov_4_hall)
	(soft_ceiling_enable camera_blocker_09 0)
	(ai_disregard (ai_actors sq_sword_cov_4_boss) TRUE)		

	(sleep_until (>= s_objcon_sword 57))
	(ai_disregard (ai_actors sq_sword_cov_4_boss) FALSE)		

)

(script dormant f_sword_boss_disregard

	(sleep_until
		(begin
		
			(ai_disregard (ai_get_object sq_sword_cov_4_boss) TRUE)
			(ai_disregard (ai_actors sq_sword_cov_4_boss) TRUE)		

		(>= s_objcon_sword 57))
	30)
	(ai_disregard (ai_get_object sq_sword_cov_4_boss) FALSE)
	(ai_disregard (ai_actors sq_sword_cov_4_boss) FALSE)

)


(script static void f_sword_boss_retreat

	(sleep (* 30 15))
	(ai_set_task sq_sword_cov_4_boss obj_roof_cov gate_infantry)

)

(script dormant f_sword_jun_control

	; Jun Setup
	(f_jun_spawn sq_jun/sword obj_sword_hum)
	(ai_set_task ai_jun obj_sword_hum gate_jun)
	(set b_jun_blip TRUE)
	(wake f_jun_blip)

)

(script dormant f_sword_jorge_control

	; Jorge Setup
	(f_jorge_spawn sq_jorge/sword obj_sword_hum)
	(ai_set_task ai_jorge obj_sword_hum gate_jorge)
	(set b_jorge_blip TRUE)
	(wake f_jorge_blip)

)

(script command_script f_cs_sword_skirm_5_1

	(cs_jump_to_point 2.2 2.2)

)

(script static void f_sword_cleanup

	(sleep_forever f_sword_main)

)


; =================================================================================================
; =================================================================================================
; ROOF
; =================================================================================================
; =================================================================================================


(script dormant f_roof_main
	
	(sleep_until (volume_test_players tv_roof_start) 5)
	(if b_debug (print "::: ENCOUNTER START: Roof"))
	
	; set sixth mission segment
	(data_mine_set_mission_segment "m20_06_roof")

	; Standard Scripts
	(wake f_roof_missionobj_control)
	(wake f_roof_md_control)
	(wake f_roof_music_control)
	(wake f_roof_spawn_control)
	(wake f_roof_save_control)

	; Encounter Scripts
	(wake f_corvette_sword)
	(wake f_roof_emile_control)
	(wake f_roof_banshee_death_tracker)
	(wake f_roof_banshee_failsafe)

	(if b_debug (print "objective control : roof.01"))
	(set b_insertion_fade_in TRUE)
	(set s_objcon_roof 1)

	(sleep_until (volume_test_players tv_roof_enter) 5)
	(if b_debug (print "objective control : roof.15"))
	(set s_objcon_roof 15)

	(set s_music_sword 5)

	(ai_set_objective sq_jorge obj_roof_hum)


	(sleep_until
		(and
			(<= (ai_living_count obj_roof_cov) 0)
			(<= (object_get_health (ai_vehicle_get_from_squad sq_roof_phantom_w1 0) ) 0)
		)
	5)
	(if b_debug (print "objective control : roof.20"))
	(set s_objcon_roof 20)

	(sleep (* 30 2))

	(wake f_md_roof_clear_1)
	(sleep 63)

	(sleep (* 30 2))

	(wake f_md_roof_clear_2)
	(sleep (* 30 4))

	(cinematic_enter 020lb_halsey TRUE)
	(f_cin_outro_prep)
	(f_end_mission 020lb_halsey zoneset_end_cinematic)
	(game_won)

)

(script dormant f_md_roof_clear_1

	(md_roof_clear_1)

)

(script dormant f_md_roof_clear_2

	(md_roof_clear_2)

)

(script static void f_cin_outro_prep

	(f_objects_interior_destroy)
	(f_objects_outro_destroy)
	(object_teleport_to_ai_point player0 ps_roof_cin_final/p0)
	(object_teleport_to_ai_point player1 ps_roof_cin_final/p1)
	(object_teleport_to_ai_point player2 ps_roof_cin_final/p2)
	(object_teleport_to_ai_point player3 ps_roof_cin_final/p3)
	(object_destroy dm_corvette_exterior)
	(object_destroy dm_corvette_sword)
	(sleep_forever f_save_continuous)
	(flock_delete flock_exterior_banshee_01)
	(flock_delete flock_exterior_falcon_01)
	(flock_delete flock_exterior_falcon_02)
	(flock_delete flock_exterior_phantom_01)
	(flock_delete flock_exterior_banshee_02)
	(flock_delete flock_interior_phantom_01)
	(flock_delete flock_interior_banshee_01)
	(flock_delete flock_interior_falcon_01)

)

(script dormant f_roof_save_control

	(sleep_until (>= s_objcon_roof 1))
	(game_save_no_timeout)

	(sleep_until (>= s_objcon_roof 15))
	(game_save_no_timeout)

)

(script dormant	f_roof_missionobj_control

	(sleep_until (>= s_objcon_sword 1))
	(mo_roof)

)

(script dormant f_roof_md_control

	(sleep_until (>= s_objcon_roof 10) 5)
	(sleep (* 30 3))
	(md_roof_enter)

	(sleep_until (>= s_objcon_roof 20) 1 (* 30 30))
	(if (not (>= s_objcon_roof 20))
		(md_roof_delay_0)
	)

	(sleep_until (>= s_objcon_roof 20) 1 (* 30 90))
	(if (not (>= s_objcon_roof 20))
		(md_roof_delay_1)
	)

)

(script dormant f_roof_emile_control

	; Emile Setup
	(f_emile_spawn sq_emile/roof obj_roof_hum)
	(ai_set_task ai_emile obj_roof_hum init)
	(set b_emile_blip TRUE)
	(wake f_emile_blip)


)

(script static void f_roof_emile_banshee
	
	(if b_debug (print "emile targeting banshees"))
	(ai_prefer_target_ai ai_emile gr_roof_cov_air TRUE)
	(ai_set_targeting_group ai_emile 1)

)

(script static void f_roof_emile_banshee_retreat
	
	(if b_debug (print "emile retreating"))
	(ai_prefer_target_ai ai_emile gr_roof_cov_air FALSE)

)

(script dormant f_roof_spawn_control

	(f_squad_group_place gr_roof_cov_init)
	(f_squad_group_place gr_roof_cov_banshees)

	(ai_set_targeting_group gr_roof_cov_banshees 1)

	(sleep_until (>= s_objcon_roof 15) 5)
	(ai_place sq_roof_phantom_w1)
	(tick)
	(unit_set_current_vitality (ai_vehicle_get_from_starting_location sq_roof_phantom_w1/driver_01) 1000 0)
	(unit_set_maximum_vitality (ai_vehicle_get_from_starting_location sq_roof_phantom_w1/driver_01) 1000 0)

	(sleep (* 30 180))
	(f_blip_ai gr_roof_cov_banshees blip_neutralize)
	(f_blip_ai sq_roof_banshee_2 blip_neutralize)
	(f_blip_ai sq_roof_banshee_3 blip_neutralize)
	(f_blip_ai sq_roof_phantom_w1/driver_01 blip_neutralize)

)

(script dormant f_roof_banshee_death_tracker

	(sleep_until (<= (ai_living_count gr_roof_cov_banshees) 0) 5)
	(dprint "cov air attack")
	(ai_set_targeting_group gr_roof_cov_air 1)

)

(script dormant f_roof_banshee_failsafe

	(sleep_until b_roof_phantom_w1_spawn 5)
	(sleep_until (not b_roof_phantom_w1_spawn) 5)
	(sleep_until (<= (ai_task_count obj_roof_cov/gate_infantry) 0) 5)
	(sleep (* 30 180))
	(sleep_until
		(begin
		
			(if (not (volume_test_objects tv_roof_banshee_safe (ai_get_object sq_roof_banshee_1)))(unit_kill sq_roof_banshee_1))
			(if (not (volume_test_objects tv_roof_banshee_safe (ai_get_object sq_roof_banshee_2)))(unit_kill sq_roof_banshee_2))
			(if (not (volume_test_objects tv_roof_banshee_safe (ai_get_object sq_roof_banshee_3)))(unit_kill sq_roof_banshee_3))
			(if (not (volume_test_objects tv_roof_banshee_safe (ai_get_object sq_roof_banshee_4)))(unit_kill sq_roof_banshee_4))
			(if (not (volume_test_objects tv_roof_banshee_safe (ai_get_object sq_roof_banshee_5)))(unit_kill sq_roof_banshee_5))
			(if (not (volume_test_objects tv_roof_banshee_safe (ai_get_object sq_roof_banshee_6)))(unit_kill sq_roof_banshee_6))
			(if (not (volume_test_objects tv_roof_banshee_safe (ai_get_object sq_roof_banshee_7)))(unit_kill sq_roof_banshee_7))

		
		FALSE )
	(* 30 5))

)

(script dormant f_roof_music_control

	(sleep_until (>= s_objcon_roof 20) 5)

)

(script static void f_roof_cleanup

	(sleep_forever f_roof_main)

)


(global short s_roof_phantom_fight 1)
(global boolean b_roof_phantom_w1_spawn FALSE)
(script command_script cs_roof_phantom_w1

	(object_cannot_die (ai_vehicle_get ai_current_actor) TRUE)
	(set b_roof_phantom_w1_spawn TRUE)

	(if b_debug (print "roof phantom"))
	
	(f_load_phantom ai_current_squad "left" sq_roof_backup_1 sq_roof_backup_2 NONE NONE)

	; enter
	;--------------------------------------------
	(cs_fly_by ps_roof_phantom_1/enter_01)
	(cs_fly_by ps_roof_phantom_1/enter_02)
	(cs_fly_by ps_roof_phantom_1/enter_03)
	(cs_vehicle_speed 0.6)
	(cs_fly_to_and_face ps_roof_phantom_1/enter_04 ps_roof_phantom_1/enter_04_face .1)
	
	(f_unload_phantom ai_current_squad "left")	
	(set b_roof_phantom_w1_spawn FALSE)

	(sleep (* 30 2))
	(cs_enable_looking TRUE)
	(cs_enable_targeting TRUE)

	(cs_fly_to_and_face ps_roof_phantom_1/fight_02 ps_roof_phantom_1/fight_02_face .1)
	(object_cannot_die (ai_vehicle_get ai_current_actor) FALSE)

	(sleep_until
		(begin

			(set s_roof_phantom_fight (random_range 1 5))
			(if (= s_roof_phantom_fight 1) (cs_fly_to_and_face ps_roof_phantom_1/fight_01 ps_roof_phantom_1/fight_01_face .1) )
			(if (= s_roof_phantom_fight 2) (cs_fly_to_and_face ps_roof_phantom_1/fight_02 ps_roof_phantom_1/fight_02_face .1) )
			(if (= s_roof_phantom_fight 3) (cs_fly_to_and_face ps_roof_phantom_1/fight_03 ps_roof_phantom_1/fight_03_face .1) )
			(if (= s_roof_phantom_fight 4) (cs_fly_to_and_face ps_roof_phantom_1/fight_04 ps_roof_phantom_1/fight_04_face .1) )
		
		FALSE)
	(* 30 1))	


)

; =================================================================================================
; =================================================================================================
; GATEHOUSE
; =================================================================================================
; =================================================================================================

(global boolean b_gatehouse_door_open FALSE)
(global boolean b_gatehouse_door_active FALSE)
(global boolean b_airtagger_taken FALSE)
(script dormant f_gatehouse_door_control

	(sleep_until (= b_court_defended TRUE))

	(if
		(not (or
			(unit_has_weapon (player0) objects\weapons\pistol\target_laser\target_laser.weapon)
			(unit_has_weapon (player1) objects\weapons\pistol\target_laser\target_laser.weapon)
			(unit_has_weapon (player2) objects\weapons\pistol\target_laser\target_laser.weapon)
			(unit_has_weapon (player3) objects\weapons\pistol\target_laser\target_laser.weapon)
		) )	
		(begin
			; First blip laser
			(f_blip_object wp_valley_targetlaser blip_ordnance)
		)
	)

	(sleep_until
		(or
			(>= s_objcon_valley 20)
			(unit_has_weapon (player0) objects\weapons\pistol\target_laser\target_laser.weapon)
			(unit_has_weapon (player1) objects\weapons\pistol\target_laser\target_laser.weapon)
			(unit_has_weapon (player2) objects\weapons\pistol\target_laser\target_laser.weapon)
			(unit_has_weapon (player3) objects\weapons\pistol\target_laser\target_laser.weapon)
		)
	)
	(f_unblip_object wp_valley_targetlaser)
	(set b_airtagger_taken TRUE)

	(if b_debug (print "opening gatehouse_frontdoor"))
	(set b_gatehouse_door_open TRUE)
	(wake f_gatehouse_open_delay)
	(device_set_position dm_valley_door_large .99)
	(device_set_position dm_valley_door_small .99)

	(sleep_until (volume_test_players tv_gate_close) 5)
	(if b_debug (print "closing gatehouse_frontdoor"))
	(device_set_position dm_valley_door_large 0)
	(device_set_position dm_valley_door_small 0)

	(sleep_until (<= (device_get_position dm_valley_door_large) 0))
	(if b_debug (print "gatehouse_frontdoor closed"))
	(f_gatehouse_door_teleport)
	(set b_gatehouse_door_open FALSE)

)


(global boolean b_gatehouse_delay FALSE)
(script dormant f_gatehouse_open_delay

	(sleep (* 30 5))
	(set b_gatehouse_delay TRUE)
	
)

(script static void f_gatehouse_door_teleport

	(if (not (volume_test_object tv_area_valley player0)) (object_teleport_to_ai_point player0 ps_valley_gate/p0))
	(if (not (volume_test_object tv_area_valley player1)) (object_teleport_to_ai_point player1 ps_valley_gate/p1))
	(if (not (volume_test_object tv_area_valley player2)) (object_teleport_to_ai_point player2 ps_valley_gate/p2))
	(if (not (volume_test_object tv_area_valley player3)) (object_teleport_to_ai_point player3 ps_valley_gate/p3))

)

(global boolean b_gatehouse_door_return_open FALSE)
(global boolean b_gatehouse_door_switch_prepare FALSE)
(global boolean b_gatehouse_door_switch_power FALSE)
(script dormant f_gatehouse_door_return

	(wake f_gatehouse_door_return_triggers)
	(wake f_gatehouse_door_return_switch)
	(wake f_gatehouse_door_timer)
	(wake f_gatehouse_door_objects)

	(sleep_until
		(begin

			(sleep_until (and b_gatehouse_door_timer_done (= (device_get_position dc_return_door_switch) 1) ) 1)

			(if
				(or
					(not b_gatehouse_trigger_exterior)
					(game_is_cooperative)
				)
				(begin

					(device_set_position dm_valley_door_large .99)
					(device_set_position dm_valley_door_small .99)
					(effect_stop_object_marker objects\levels\solo\m20\gatehouse_door\fx\gatehouse_steam_release.effect dm_valley_door_large "fx_release")
					(effect_stop_object_marker objects\levels\solo\m20\gatehouse_door\fx\gatehouse_steam_release.effect dm_valley_door_small "fx_release")
					(dprint "door open")
					(if (game_is_cooperative) (f_zoneset_direction direction_inward_coop) (f_zoneset_direction direction_inward) )
					(switch_zone_set zoneset_courtyard_valley_return)
					(sleep 10)
					(f_objects_court_return_create_anew)
					(set b_garage_ready TRUE)
					(f_gatehouse_door_timer_reset)
				
			))

			(if (game_is_cooperative)
				(begin
					(f_gatehouse_open_coop)
				)
				(begin
					(sleep_until b_gatehouse_trigger_exterior 1)
					(dprint "door close trigger")
					(device_set_position dm_valley_door_large 0)
					(device_set_position dm_valley_door_small 0)
					(effect_stop_object_marker objects\levels\solo\m20\gatehouse_door\fx\gatehouse_steam_release.effect dm_valley_door_large "fx_release")
					(effect_stop_object_marker objects\levels\solo\m20\gatehouse_door\fx\gatehouse_steam_release.effect dm_valley_door_small "fx_release")
					(sleep_until (<= (device_get_position dm_valley_door_large) 0) 1)
					(dprint "door closed")
					(f_zoneset_direction direction_return)
					(f_gatehouse_door_timer_reset)
				)
			)

		(game_is_cooperative))
	1)

)

(script dormant f_gatehouse_door_objects

	(sleep_until
		(begin

			(sleep_until (= (current_zone_set) s_zoneset_courtyard_valley_re) 1)
			(sleep_until (= (current_zone_set_fully_active) s_zoneset_exterior) 1)
			(f_objects_exterior_create)
			(f_air_cannon_place)

		FALSE)
	1)
	
)

(script static void f_gatehouse_open_coop

	(effect_stop_object_marker objects\levels\solo\m20\gatehouse_door\fx\gatehouse_steam_release.effect dm_valley_door_large "fx_release")
	(effect_stop_object_marker objects\levels\solo\m20\gatehouse_door\fx\gatehouse_steam_release.effect dm_valley_door_small "fx_release")
	(sleep_forever f_gatehouse_door_return_triggers)
	(sleep_forever f_gatehouse_door_return_switch)
	(sleep_forever f_gatehouse_door_timer)
	(sleep_forever f_gatehouse_door_objects)
	(device_set_power dc_return_door_switch 0)
	(f_unblip_object dc_return_door_switch)

)

(global boolean b_gatehouse_trigger_courtyard FALSE)
(global boolean b_gatehouse_trigger_exterior FALSE)
(script dormant f_gatehouse_door_return_triggers

	(sleep_until
		(begin

			(sleep_until (volume_test_players "begin_zone_set:zoneset_courtyard_valley_return:*") 1)
			(set b_gatehouse_trigger_courtyard TRUE)
			(set b_gatehouse_trigger_exterior FALSE)
			(sleep_until (volume_test_players "begin_zone_set:zoneset_exterior" ) 1)
			(set b_gatehouse_trigger_courtyard FALSE)
			(set b_gatehouse_trigger_exterior TRUE)

		FALSE)
	1)

)

(script dormant f_gatehouse_door_return_switch

	(sleep_until
		(begin

			(sleep_until b_gatehouse_trigger_courtyard 1)
			(device_set_power dc_return_door_switch 1)
			(f_blip_object dc_return_door_switch blip_interface)
			(f_gatehouse_door_timer_start)
	
			(if (game_is_cooperative) (begin

				(sleep_until (= (device_get_position dc_return_door_switch) 1) 1)
				(wake f_md_return_gate)
				(effect_new_on_object_marker_loop objects\levels\solo\m20\gatehouse_door\fx\gatehouse_steam_release.effect dm_valley_door_large "fx_release")
				(effect_new_on_object_marker_loop objects\levels\solo\m20\gatehouse_door\fx\gatehouse_steam_release.effect dm_valley_door_small "fx_release")
				(device_set_power dc_return_door_switch 0)
				(f_unblip_object dc_return_door_switch)

			)(begin
			
				(sleep_until 
					(or
						(= (device_get_position dc_return_door_switch) 1)
						b_gatehouse_trigger_exterior
					)
				1)
	
				(f_gatehouse_door_timer_reset)
	
				(if (= (device_get_position dc_return_door_switch) 1) (begin
	
					(wake f_md_return_gate)
					(effect_new_on_object_marker_loop objects\levels\solo\m20\gatehouse_door\fx\gatehouse_steam_release.effect dm_valley_door_large "fx_release")
					(effect_new_on_object_marker_loop objects\levels\solo\m20\gatehouse_door\fx\gatehouse_steam_release.effect dm_valley_door_small "fx_release")
	
				))
	
				(device_set_position dc_return_door_switch 0)
				(device_set_power dc_return_door_switch 0)
				(f_unblip_object dc_return_door_switch)
	
				(sleep_until b_gatehouse_trigger_exterior)
			
			))
			
		(game_is_cooperative))
	1)

)

(script dormant f_md_return_gate

	(sleep (* 30 2))
	(md_return_gate)

)

(global boolean b_gatehouse_door_timer FALSE)
(global boolean b_gatehouse_door_timer_done FALSE)
(script dormant f_gatehouse_door_timer

	(sleep_until
		(begin
			(sleep_until b_gatehouse_door_timer)
			(sleep (* 30 15))
			(set b_gatehouse_door_timer_done TRUE)
		FALSE)
	1)

)

(script static void f_gatehouse_door_timer_reset

	(set b_gatehouse_door_timer_done FALSE)
	(set b_gatehouse_door_timer FALSE)

)

(script static void f_gatehouse_door_timer_start

	(set b_gatehouse_door_timer_done FALSE)
	(set b_gatehouse_door_timer TRUE)

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

(script dormant f_checkpoint_generic

	(sleep 0)

)

(script static void tick
	(sleep 1)
)

(script command_script f_cs_abort
	(sleep 1)
)

(script command_script f_cs_sleep
	(sleep_forever)
)


(script dormant f_fireteam_setup

	(sleep_until (> (player_count) 0))

	; Fireteams
	(ai_player_add_fireteam_squad (player0) sq_player_0)
	(ai_player_add_fireteam_squad (player1) sq_player_1)
	(ai_player_add_fireteam_squad (player2) sq_player_2)
	(ai_player_add_fireteam_squad (player3) sq_player_3)
	(ai_player_set_fireteam_max (player0) s_fireteam_max)
	(ai_player_set_fireteam_max (player1) s_fireteam_max)
	(ai_player_set_fireteam_max (player2) s_fireteam_max)
	(ai_player_set_fireteam_max (player3) s_fireteam_max)
	(ai_player_set_fireteam_max_squad_absorb_distance (player0) r_fireteam_dist)
	(ai_player_set_fireteam_max_squad_absorb_distance (player1) r_fireteam_dist)
	(ai_player_set_fireteam_max_squad_absorb_distance (player2) r_fireteam_dist)
	(ai_player_set_fireteam_max_squad_absorb_distance (player3) r_fireteam_dist)
	(ai_set_fireteam_absorber gr_hum TRUE)

)

(global boolean b_players_any_on_foot FALSE)
(global boolean b_players_all_on_foot FALSE)
(script continuous f_players_any_on_foot

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
		(set b_players_any_on_foot FALSE)
		(set b_players_any_on_foot TRUE)
	)

	(if
		(or
			(= (unit_in_vehicle (player0)) FALSE)
			(= (unit_in_vehicle (player1)) FALSE)
			(= (unit_in_vehicle (player2)) FALSE)
			(= (unit_in_vehicle (player3)) FALSE)		
		)
		(set b_players_all_on_foot FALSE)
		(set b_players_all_on_foot TRUE)
	)



)

(global boolean b_valley_troophog_trav TRUE)
(global boolean b_valley_warthog_drop_trav TRUE)
(global boolean b_air_warthog_ins_trav TRUE)
(global boolean b_air_warthog_trav TRUE)
(global boolean b_air_bighog_trav TRUE)
(global boolean b_far_warthog_ins_trav TRUE)
(global boolean b_far_warthog_trav TRUE)
(global boolean b_far_bighog_trav TRUE)
(global boolean b_return_warthog_ins_trav TRUE)

(global short s_squad_group_obj_area_counter 0)
(script static void (f_squad_set_obj_area (string_id obj) (trigger_volume vol)  )


		; sq_valley_troophog
		;------------------------
		(if
			(and
				(volume_test_objects vol (ai_get_object sq_valley_troophog) )
				b_valley_warthog_drop_trav
			)
			(begin
				(print "migrating sq_valley_troophog to local")
				(cs_run_command_script sq_valley_troophog f_cs_abort)
				(ai_set_objective sq_valley_troophog obj )
				(set b_valley_troophog_trav FALSE) ; False
			)
		)


		(if
			(and
				(not (volume_test_objects vol (ai_get_object sq_valley_warthog_drop) ) )
				(not b_valley_warthog_drop_trav)
			)
			(begin
				(print "migrating local squad to traversal")
				(cs_run_command_script sq_valley_warthog_drop f_cs_abort)
				(ai_set_objective sq_valley_warthog_drop obj_vehicles_hum )
				(set b_valley_warthog_drop_trav TRUE) ; True
			)
		)


		; sq_valley_warthog_drop
		;------------------------
		(if
			(and
				(volume_test_objects vol (ai_get_object sq_valley_warthog_drop) )
				b_valley_warthog_drop_trav
			)
			(begin
				(print "migrating sq_valley_warthog_drop to local")
				(cs_run_command_script sq_valley_warthog_drop f_cs_abort)
				(ai_set_objective sq_valley_warthog_drop obj )
				(set b_valley_warthog_drop_trav FALSE) ; False
			)
		)


		(if
			(and
				(not (volume_test_objects vol (ai_get_object sq_valley_warthog_drop) ) )
				(not b_valley_warthog_drop_trav)
			)
			(begin
				(print "migrating local squad to traversal")
				(cs_run_command_script sq_valley_warthog_drop f_cs_abort)
				(ai_set_objective sq_valley_warthog_drop obj_vehicles_hum )
				(set b_valley_warthog_drop_trav TRUE) ; True
			)
		)


		; sq_air_warthog_ins
		;------------------------
		(if
			(and
				(volume_test_objects vol (ai_get_object sq_air_warthog_ins) )
				b_air_warthog_ins_trav
			)
			(begin
				(print "migrating sq_air_warthog_ins to local")
				(cs_run_command_script sq_air_warthog_ins f_cs_abort)
				(ai_set_objective sq_air_warthog_ins obj )
				(set b_air_warthog_ins_trav FALSE) ; False
			)
		)


		(if
			(and
				(not (volume_test_objects vol (ai_get_object sq_air_warthog_ins) ) )
				(not b_air_warthog_ins_trav)
			)
			(begin
				(print "migrating air_warthog_ins to traversal")
				(cs_run_command_script sq_air_warthog_ins f_cs_abort)
				(ai_set_objective sq_air_warthog_ins obj_vehicles_hum )
				(set b_air_warthog_ins_trav TRUE) ; True
			)
		)


		; sq_air_warthog
		;------------------------
		(if
			(and
				(volume_test_objects vol (ai_get_object sq_air_warthog) )
				b_air_warthog_trav
			)
			(begin
				(print "migrating sq_air_warthog to local")
				(cs_run_command_script sq_air_warthog f_cs_abort)
				(ai_set_objective sq_air_warthog obj )
				(set b_air_warthog_trav FALSE) ; False
			)
		)


		(if
			(and
				(not (volume_test_objects vol (ai_get_object sq_air_warthog) ) )
				(not b_air_warthog_trav)
			)
			(begin
				(print "migrating air_warthog to traversal")
				(cs_run_command_script sq_air_warthog f_cs_abort)
				(ai_set_objective sq_air_warthog obj_vehicles_hum )
				(set b_air_warthog_trav TRUE) ; True
			)
		)


		; sq_air_bighog
		;------------------------
		(if
			(and
				(volume_test_objects vol (ai_get_object sq_air_bighog) )
				b_air_bighog_trav
			)
			(begin
				(print "migrating sq_air_bighog to local")
				(cs_run_command_script sq_air_bighog f_cs_abort)
				(ai_set_objective sq_air_bighog obj )
				(set b_air_bighog_trav FALSE) ; False
			)
		)


		(if
			(and
				(not (volume_test_objects vol (ai_get_object sq_air_bighog) ) )
				(not b_air_bighog_trav)
			)
			(begin
				(print "migrating air_bighog to traversal")
				(cs_run_command_script sq_air_bighog f_cs_abort)
				(ai_set_objective sq_air_bighog obj_vehicles_hum )
				(set b_air_bighog_trav TRUE) ; True
			)
		)

		; sq_far_warthog_ins
		;------------------------
		(if
			(and
				(volume_test_objects vol (ai_get_object sq_far_warthog_ins) )
				b_far_warthog_ins_trav
			)
			(begin
				(print "migrating sq_far_warthog_ins to local")
				(cs_run_command_script sq_far_warthog_ins f_cs_abort)
				(ai_set_objective sq_far_warthog_ins obj )
				(set b_far_warthog_ins_trav FALSE) ; False
			)
		)


		(if
			(and
				(not (volume_test_objects vol (ai_get_object sq_air_warthog_ins) ) )
				(not b_air_warthog_ins_trav)
			)
			(begin
				(print "migrating air_warthog_ins to traversal")
				(cs_run_command_script sq_air_warthog_ins f_cs_abort)
				(ai_set_objective sq_air_warthog_ins obj_vehicles_hum )
				(set b_air_warthog_ins_trav TRUE) ; True
			)
		)

		; sq_far_warthog
		;------------------------
		(if
			(and
				(volume_test_objects vol (ai_get_object sq_far_warthog) )
				b_far_warthog_trav
			)
			(begin
				(print "migrating sq_far_warthog to local")
				(cs_run_command_script sq_far_warthog f_cs_abort)
				(ai_set_objective sq_far_warthog obj )
				(set b_far_warthog_trav FALSE) ; False
			)
		)


		(if
			(and
				(not (volume_test_objects vol (ai_get_object sq_far_warthog) ) )
				(not b_far_warthog_trav)
			)
			(begin
				(print "migrating far_warthog to traversal")
				(cs_run_command_script sq_far_warthog f_cs_abort)
				(ai_set_objective sq_far_warthog obj_vehicles_hum )
				(set b_far_warthog_trav TRUE) ; True
			)
		)

		; sq_far_bighog
		;------------------------
		(if
			(and
				(volume_test_objects vol (ai_get_object sq_far_bighog) )
				b_far_bighog_trav
			)
			(begin
				(print "migrating sq_far_bighog to local")
				(cs_run_command_script sq_far_bighog f_cs_abort)
				(ai_set_objective sq_far_bighog obj )
				(set b_far_bighog_trav FALSE) ; False
			)
		)


		(if
			(and
				(not (volume_test_objects vol (ai_get_object sq_far_bighog) ) )
				(not b_far_bighog_trav)
			)
			(begin
				(print "migrating far_bighog to traversal")
				(cs_run_command_script sq_far_bighog f_cs_abort)
				(ai_set_objective sq_far_bighog obj_vehicles_hum )
				(set b_far_bighog_trav TRUE) ; True
			)
		)
		
		; sq_return_warthog_ins
		;------------------------
		(if
			(and
				(volume_test_objects vol (ai_get_object sq_return_warthog_ins) )
				b_return_warthog_ins_trav
			)
			(begin
				(print "migrating sq_return_warthog_ins to local")
				(cs_run_command_script sq_return_warthog_ins f_cs_abort)
				(ai_set_objective sq_return_warthog_ins obj )
				(set b_return_warthog_ins_trav FALSE) ; False
			)
		)


		(if
			(and
				(not (volume_test_objects vol (ai_get_object sq_return_warthog_ins) ) )
				(not b_return_warthog_ins_trav)
			)
			(begin
				(print "migrating sq_return_warthog_ins to traversal")
				(cs_run_command_script sq_return_warthog_ins f_cs_abort)
				(ai_set_objective sq_return_warthog_ins obj_vehicles_hum )
				(set b_return_warthog_ins_trav TRUE) ; True
			)
		)
		



;*


	(set b_valley_warthog_drop_trav (f_squad_area_handle sq_valley_warthog_drop b_valley_warthog_drop_trav obj vol))
	(set b_air_warthog_ins_trav (f_squad_area_handle sq_air_warthog_ins b_air_warthog_ins_trav obj vol))

		(if
			(and
				(volume_test_objects vol (ai_get_object sq_valley_warthog_drop) )
				b_valley_warthog_drop_trav
			)
			(begin
				(dbreak "found valley_warthog_drop in volume")
				(cs_run_command_script sq_valley_warthog_drop f_cs_abort)
				(ai_set_objective sq_valley_warthog_drop obj )
				(set b_valley_warthog_drop_trav FALSE)
			)
		)


		(if
			(and
				(volume_test_objects vol (ai_get_object sq_air_warthog_ins) )
				b_air_warthog_ins_trav
			)
			(begin
				(dbreak "found air_warthog_ins in volume")
				(cs_run_command_script sq_air_warthog_ins f_cs_abort)
				(ai_set_objective sq_air_warthog_ins obj )
				(set b_air_warthog_ins_trav FALSE)
			)
		)

	(set s_squad_group_obj_area_counter (ai_squad_group_get_squad_count squad_group))
	
	(sleep_until (begin
	
		(set s_squad_group_obj_area_counter (- s_squad_group_obj_area_counter 1))
		(if (volume_test_objects vol (ai_squad_group_get_squad squad_group s_squad_group_obj_area_counter) )
			(begin
				(dbreak "found squad in volume")
				(cs_run_command_script (ai_squad_group_get_squad squad_group s_squad_group_obj_area_counter) f_cs_abort)
				(ai_set_objective (ai_squad_group_get_squad squad_group s_squad_group_obj_area_counter) obj )
			)
		)
		(<= s_squad_group_obj_area_counter 0)

	) 5 )


*;

)

(script static boolean (f_squad_area_handle (ai squad) (boolean trav) (string_id obj) (trigger_volume vol) )

		(if
			(and
				(volume_test_objects vol (ai_get_object squad) )
				trav
			)
			(begin
				(print "migrating traversal squad to local")
				(cs_run_command_script squad f_cs_abort)
				(ai_set_objective squad obj )
				(= 1 0) ; False
			)
		)


		(if
			(and
				(not (volume_test_objects vol (ai_get_object squad) ) )
				(not trav)
			)
			(begin
				(print "migrating local squad to traversal")
				(cs_run_command_script squad f_cs_abort)
				(ai_set_objective squad obj_vehicles_hum )
				(= 1 1) ; True
			)
		)

)

(global short s_squad_group_obj_counter 0)
(script static void (f_squad_set_obj (ai squad_group) (string_id obj) )

	(set s_squad_group_obj_counter (ai_squad_group_get_squad_count squad_group))
	
	(sleep_until (begin
	
		(set s_squad_group_obj_counter (- s_squad_group_obj_counter 1))
		(cs_run_command_script (ai_squad_group_get_squad squad_group s_squad_group_obj_counter) f_cs_abort)
		(ai_set_objective (ai_squad_group_get_squad squad_group s_squad_group_obj_counter) obj)
		(<= s_squad_group_obj_counter 0)

	) 5)

)



(global short s_squad_group_place_counter 0)
(script static void (f_squad_group_place (ai squad_group))

	(set s_squad_group_place_counter (ai_squad_group_get_squad_count squad_group))
	
	(sleep_until (begin
	
		(set s_squad_group_place_counter (- s_squad_group_place_counter 1))
		(ai_place (ai_squad_group_get_squad squad_group s_squad_group_place_counter))
		(<= s_squad_group_place_counter 0)

	) 1)

)


(script static boolean difficulty_is_normal_or_lower  

	(or 
		(= (game_difficulty_get) easy)  
		(= (game_difficulty_get) normal)  
	) 

) 

(script static boolean difficulty_is_normal_or_higher  

	(or 
		(= (game_difficulty_get) normal)  
		(= (game_difficulty_get) heroic)  
		(= (game_difficulty_get) legendary)  
	) 

)

(script static boolean difficulty_is_heroic_or_lower  

	(or
		(= (game_difficulty_get) easy)  
		(= (game_difficulty_get) normal)  
		(= (game_difficulty_get) heroic)  
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

; p - pause/unpause
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
		(set ai_render_sector_bsps 0)
		(set ai_render_sector_bsps 1)
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

; d - decisions
(script static void d
	(if ai_render_decisions
		(set ai_render_decisions 0)
		(set ai_render_decisions 1)
	)
)

; c - command scripts
(script static void c
	(if ai_render_command_scripts
		(begin
			(set ai_render_command_scripts 0)
			(print "command scripts OFF")
		)
		(begin
			(set ai_render_command_scripts 1)
			(print "command scripts ON")
		)
	)
)

; p - command scripts
(script static void t
	(print "performances")
	(if debug_performances
		(set debug_performances 0)
		(set debug_performances 1)
	)
)

; k - kill scripts
(script static void k

	(f_court_cleanup)
	(f_valley_cleanup)
	(f_far_cleanup)
	(f_air_cleanup)
	(f_air_far_cleanup)
	(f_return_cleanup)
	(f_garage_cleanup)
	(f_sword_cleanup)
	(f_roof_cleanup)

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
                  (if b_debug_globals (print "boom..."))
                  (effect_new_at_point_set_point e p global_s_current_bomb)
                  (set global_s_current_bomb (+ global_s_current_bomb 1))
                  (sleep delay)
            (>= global_s_current_bomb count)) 1)
)

; CORVETTES
; =================================================================================================
(script dormant f_corvette_exterior

	(object_create dm_corvette_exterior)

	(device_set_position_track dm_corvette_exterior "device:position" 0)
	(if b_debug (print "corvette moving distance"))
	(device_animate_position dm_corvette_exterior .22 (* 60 2) 5 5 TRUE)

	(if (not (game_is_cooperative)) (begin

		(sleep 30)

		(ai_place sq_corvette_AA_bombard)
		(ai_cannot_die sq_corvette_AA_bombard TRUE)
	
		(tick)
	
		(ai_vehicle_enter_immediate sq_corvette_AA_bombard/driver_01 (object_get_turret dm_corvette_exterior 0) "")
		(ai_vehicle_enter_immediate sq_corvette_AA_bombard/driver_02 (object_get_turret dm_corvette_exterior 1) "")
		(ai_vehicle_enter_immediate sq_corvette_AA_bombard/driver_03 (object_get_turret dm_corvette_exterior 2) "")
		(ai_vehicle_enter_immediate sq_corvette_AA_bombard/driver_04 (object_get_turret dm_corvette_exterior 3) "")
	
		(cs_run_command_script sq_corvette_AA_bombard/driver_01 f_cs_corvette_shoot_init_1)
		(cs_run_command_script sq_corvette_AA_bombard/driver_02 f_cs_corvette_shoot_init_2)
		(cs_run_command_script sq_corvette_AA_bombard/driver_03 f_cs_corvette_shoot_init_3)
		(cs_run_command_script sq_corvette_AA_bombard/driver_04 f_cs_corvette_shoot_init_4)

	) )

	(sleep_until
		(or
			b_court_defended
			b_test_gatebomb
			b_test_airbomb
		)
	)
	(if b_debug (print "corvette moving airview"))
	(device_animate_position dm_corvette_exterior .9 (* 60 5) 1 1 TRUE)

	(if (not (game_is_cooperative)) (begin

		(sleep_forever f_cs_corvette_shoot_init_1)
		(sleep_forever f_cs_corvette_shoot_init_2)
		(sleep_forever f_cs_corvette_shoot_init_3)
		(sleep_forever f_cs_corvette_shoot_init_4)
		(cs_run_command_script sq_corvette_AA_bombard/driver_01 f_cs_corvette_shoot_air_1)
		(cs_run_command_script sq_corvette_AA_bombard/driver_02 f_cs_corvette_shoot_air_2)
		(cs_run_command_script sq_corvette_AA_bombard/driver_03 f_cs_corvette_shoot_air_3)
		(cs_run_command_script sq_corvette_AA_bombard/driver_04 f_cs_corvette_shoot_air_4)	

	))

	(if b_test_airbomb
		(begin
			;(device_set_position_track dm_corvette_exterior "device:position" 0)
			;(object_create_anew dm_corvette_exterior)
			(device_animate_position dm_corvette_exterior .9 0 .034 .034 FALSE)
		)
	)

	(sleep_until
		(or
			(and
				b_far_defended
				b_air_defended
			)
			b_test_gatebomb
		)
	)
	(if b_debug (print "corvette moving gatehouse"))
	(device_animate_position dm_corvette_exterior 1 (* 60 3) 1 1 TRUE)

	(if (not (game_is_cooperative)) (begin

		(sleep_forever f_cs_corvette_shoot_air_1)
		(sleep_forever f_cs_corvette_shoot_air_2)
		(sleep_forever f_cs_corvette_shoot_air_3)
		(sleep_forever f_cs_corvette_shoot_air_4)
		(cs_run_command_script sq_corvette_AA_bombard/driver_01 f_cs_corvette_shoot_gate_1)
		(cs_run_command_script sq_corvette_AA_bombard/driver_02 f_cs_corvette_shoot_gate_2)
		(cs_run_command_script sq_corvette_AA_bombard/driver_03 f_cs_corvette_shoot_gate_3)
		(cs_run_command_script sq_corvette_AA_bombard/driver_04 f_cs_corvette_shoot_gate_4)

	))

	(if b_test_gatebomb
		(begin
			;(device_set_position_track dm_corvette_exterior "device:position" 0)
			;(object_create_anew dm_corvette_exterior)
			(device_animate_position dm_corvette_exterior 1 0 .034 .034 FALSE)
		)
	)

	(sleep_until (>= s_objcon_sword 1) 1)

	(if (not (game_is_cooperative)) (begin

		(sleep_forever f_cs_corvette_shoot_gate_1)
		(sleep_forever f_cs_corvette_shoot_gate_2)
		(sleep_forever f_cs_corvette_shoot_gate_3)
		(sleep_forever f_cs_corvette_shoot_gate_4)
		(ai_erase sq_corvette_AA_bombard)

	))

)

(script dormant f_corvette_sword

	(sleep_forever f_corvette_exterior)
	(sleep_forever f_cs_corvette_shoot_gate_1)
	(sleep_forever f_cs_corvette_shoot_gate_2)
	(sleep_forever f_cs_corvette_shoot_gate_3)
	(sleep_forever f_cs_corvette_shoot_gate_4)

	(ai_erase sq_corvette_AA_bombard)
	(object_destroy dm_corvette_exterior)
	(object_create dm_corvette_sword)

	(tick)

	(ai_place sq_corvette_AA_bombard)
	(ai_cannot_die sq_corvette_AA_bombard TRUE)

	(if (not (game_is_cooperative)) (begin

		(ai_vehicle_enter_immediate sq_corvette_AA_bombard/driver_01 (object_get_turret dm_corvette_sword 0) "")
		(ai_vehicle_enter_immediate sq_corvette_AA_bombard/driver_02 (object_get_turret dm_corvette_sword 1) "")
		(ai_vehicle_enter_immediate sq_corvette_AA_bombard/driver_03 (object_get_turret dm_corvette_sword 2) "")
		(ai_vehicle_enter_immediate sq_corvette_AA_bombard/driver_04 (object_get_turret dm_corvette_sword 3) "")

		(cs_run_command_script sq_corvette_AA_bombard/driver_01 f_cs_corvette_shoot_roof_1)
		(cs_run_command_script sq_corvette_AA_bombard/driver_02 f_cs_corvette_shoot_roof_2)
		(cs_run_command_script sq_corvette_AA_bombard/driver_03 f_cs_corvette_shoot_roof_3)
		(cs_run_command_script sq_corvette_AA_bombard/driver_04 f_cs_corvette_shoot_roof_4)

	))

)


(global short s_corvette_shoot_random 1)
(script command_script f_cs_corvette_shoot_init_1

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_init/01_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_init/01_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_init/01_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_init/01_04))
			FALSE
		)
	(random_range 30 300))

)

(script command_script f_cs_corvette_shoot_init_2

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_init/02_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_init/02_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_init/02_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_init/02_04))
			FALSE
		)
	(random_range 30 300))

)


(script command_script f_cs_corvette_shoot_init_3

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_init/03_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_init/03_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_init/03_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_init/03_04))
			FALSE
		)
	(random_range 30 300))

)


(script command_script f_cs_corvette_shoot_init_4

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_init/04_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_init/04_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_init/04_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_init/04_04))
			FALSE
		)
	(random_range 30 300))

)




(script command_script f_cs_corvette_shoot_air_1

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_air/01_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_air/01_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_air/01_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_air/01_04))
			FALSE
		)
	(random_range 30 300))

)

(script command_script f_cs_corvette_shoot_air_2

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_air/02_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_air/02_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_air/02_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_air/02_04))
			FALSE
		)
	(random_range 30 300))

)

(script command_script f_cs_corvette_shoot_air_3

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_air/03_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_air/03_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_air/03_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_air/03_04))
			FALSE
		)
	(random_range 30 300))

)

(script command_script f_cs_corvette_shoot_air_4

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_air/04_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_air/04_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_air/04_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_air/04_04))
			FALSE
		)
	(random_range 30 300))

)

(script command_script f_cs_corvette_shoot_gate_1

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_gate/01_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_gate/01_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_gate/01_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_gate/01_04))
			FALSE
		)
	(random_range 30 300))

)

(script command_script f_cs_corvette_shoot_gate_2

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_gate/02_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_gate/02_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_gate/02_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_gate/02_04))
			FALSE
		)
	(random_range 30 300))

)


(script command_script f_cs_corvette_shoot_gate_3

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_gate/03_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_gate/03_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_gate/03_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_gate/03_04))
			FALSE
		)
	(random_range 30 300))

)

(script command_script f_cs_corvette_shoot_gate_4

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_gate/04_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_gate/04_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_gate/04_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_gate/04_04))
			FALSE
		)
	(random_range 30 300))

)

(script command_script f_cs_corvette_shoot_roof_1

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_roof/01_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_roof/01_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_roof/01_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_roof/01_04))
			FALSE
		)
	(random_range 30 300))

)

(script command_script f_cs_corvette_shoot_roof_2

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_roof/02_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_roof/02_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_roof/02_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_roof/02_04))
			FALSE
		)
	(random_range 30 300))

)

(script command_script f_cs_corvette_shoot_roof_3

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_roof/03_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_roof/03_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_roof/03_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_roof/03_04))
			FALSE
		)
	(random_range 30 300))

)

(script command_script f_cs_corvette_shoot_roof_4

	(sleep_until
		(begin
			(set s_corvette_shoot_random (random_range 1 4))
			(if (= s_corvette_shoot_random 1) (cs_shoot_point TRUE ps_corvette_shoot_roof/04_01))
			(if (= s_corvette_shoot_random 2) (cs_shoot_point TRUE ps_corvette_shoot_roof/04_02))
			(if (= s_corvette_shoot_random 3) (cs_shoot_point TRUE ps_corvette_shoot_roof/04_03))
			(if (= s_corvette_shoot_random 4) (cs_shoot_point TRUE ps_corvette_shoot_roof/04_04))
			FALSE
		)
	(random_range 30 300))

)

(script command_script f_cs_corvette_shoot
	(cs_shoot_point TRUE ps_sword_corvette/shoot)
	(sleep_forever)
)

; Save Scripts
; =================================================================================================
(global boolean b_save_continuous TRUE)
(script continuous f_save_continuous

	(sleep_until b_insertion_fade_in)

	(sleep_until
		(begin
			(if b_save_continuous
			(begin
				(sleep_until (= (current_zone_set) (current_zone_set_fully_active)) 2)
				(sleep (* 30 5))
				(dprint "continuous save")
				(game_save_no_timeout)
			))
			FALSE
		)
	(* 30 120))
)

(global boolean b_save_on TRUE)
(script dormant f_save_control

	(sleep_until
		(begin
			(if (not b_save_on)
				(game_save_cancel)
			)
		FALSE)
	30)

)

; Recycling Scripts
; =================================================================================================
(script continuous f_recycle_all_continuous

	(sleep_until b_insertion_fade_in)

	(sleep_until
		(begin
			(if (volume_test_players tv_recycle_courtyard)
				(f_recycle_courtyard_lite)
				(f_recycle_courtyard)
			)
			(if (volume_test_players tv_recycle_faragate)
				(f_recycle_faragate_lite)
				(f_recycle_faragate)
			)
			(if (volume_test_players tv_recycle_airview)
				(f_recycle_airview_lite)
				(f_recycle_airview)
			)
			(if (volume_test_players tv_recycle_valley)
				(f_recycle_valley_lite)
				(f_recycle_valley)
			)
			(if (volume_test_players tv_recycle_sword)
				(f_recycle_sword_lite)
				(f_recycle_sword)
			)
			FALSE
		)
	400)
)

(script static void f_recycle_courtyard
	(add_recycling_volume tv_recycle_courtyard 5 5)
)

(script static void f_recycle_courtyard_lite
	; bipeds
	(add_recycling_volume_by_type tv_recycle_courtyard 25 (* 30 4) 1)
	(sleep (* 30 5))
	; weapons
	(add_recycling_volume_by_type tv_recycle_courtyard 30 (* 30 4) 4)
	(sleep (* 30 5))
	; equipment
	(add_recycling_volume_by_type tv_recycle_courtyard 20 (* 30 4) 8)
	(sleep (* 30 5))
)

(script static void f_recycle_sword
	(add_recycling_volume tv_recycle_sword 5 5)
)

(script static void f_recycle_sword_lite
	; bipeds
	(add_recycling_volume_by_type tv_recycle_sword 25 (* 30 4) 1)
	(sleep (* 30 5))
	; weapons
	(add_recycling_volume_by_type tv_recycle_sword 30 (* 30 4) 4)
	(sleep (* 30 5))
	; equipment
	(add_recycling_volume_by_type tv_recycle_sword 20 (* 30 4) 8)
	(sleep (* 30 5))
)

(script static void f_recycle_faragate
	(add_recycling_volume tv_recycle_faragate 5 5)
)

(script static void f_recycle_faragate_lite
	; bipeds
	(add_recycling_volume_by_type tv_recycle_faragate 25 (* 30 4) 1)
	(sleep (* 30 5))
	; weapons
	(add_recycling_volume_by_type tv_recycle_faragate 30 (* 30 4) 4)
	(sleep (* 30 5))
	; equipment
	(add_recycling_volume_by_type tv_recycle_faragate 20 (* 30 4) 8)
	(sleep (* 30 5))
)


(script static void f_recycle_airview
	(add_recycling_volume tv_recycle_airview 5 5)
)

(script static void f_recycle_airview_lite
	; bipeds
	(add_recycling_volume_by_type tv_recycle_airview 25 (* 30 4) 1)
	(sleep (* 30 5))
	; weapons
	(add_recycling_volume_by_type tv_recycle_airview 30 (* 30 4) 4)
	(sleep (* 30 5))
	; equipment
	(add_recycling_volume_by_type tv_recycle_airview 20 (* 30 4) 8)
	(sleep (* 30 5))
)


(script static void f_recycle_valley
	(add_recycling_volume tv_recycle_valley 5 5)
)

(script static void f_recycle_valley_lite
	; bipeds
	(add_recycling_volume_by_type tv_recycle_valley 25 (* 30 4) 1)
	(sleep (* 30 5))
	; weapons
	(add_recycling_volume_by_type tv_recycle_valley 30 (* 30 4) 4)
	(sleep (* 30 5))
	; equipment
	(add_recycling_volume_by_type tv_recycle_valley 20 (* 30 4) 8)
	(sleep (* 30 5))
)


(script static void f_recycle_outside

	(sleep_forever f_recycle_all_continuous)
	
	(add_recycling_volume tv_recycle_courtyard 0 0)
	(add_recycling_volume tv_recycle_faragate 0 0)
	(add_recycling_volume tv_recycle_airview 0 0)

)


; Test Scripts
; =================================================================================================

(global boolean b_test_airbomb FALSE)
(script static void f_test_airbomb

	(switch_zone_set zoneset_exterior)
	(set b_insertion_fade_in TRUE)
	(set b_test_airbomb TRUE)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_air_airbomb_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_air_airbomb_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_air_airbomb_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_air_airbomb_spawn/player3)

	(wake f_corvette_exterior)

)

(global boolean b_test_gatebomb FALSE)
(script static void f_test_gatebomb

	(f_kill_all_scripts)

	(switch_zone_set zoneset_exterior)
	(set b_insertion_fade_in TRUE)
	(set b_test_gatebomb TRUE)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_return_gatebomb_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_return_gatebomb_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_return_gatebomb_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_return_gatebomb_spawn/player3)

	(wake f_corvette_exterior)

)

(global boolean b_test_basebomb FALSE)
(script static void f_test_basebomb

	(f_kill_all_scripts)

	(switch_zone_set zoneset_interior)
	(set b_insertion_fade_in TRUE)
	(set b_test_basebomb TRUE)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_sword_basebomb_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_sword_basebomb_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_sword_basebomb_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_sword_basebomb_spawn/player3)

	(wake f_sword_bomb_control)

)

(global boolean b_test_hallbomb FALSE)
(script static void f_test_hallbomb

	(f_kill_all_scripts)

	(switch_zone_set zoneset_interior)
	(set b_insertion_fade_in TRUE)
	(set b_test_hallbomb TRUE)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_sword_roofbomb_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_sword_roofbomb_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_sword_roofbomb_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_sword_roofbomb_spawn/player3)

	(wake f_sword_bomb_control)

)

(global boolean b_test_roofbomb FALSE)
(script static void f_test_roofbomb

	(f_kill_all_scripts)

	(switch_zone_set zoneset_interior)
	(set b_insertion_fade_in TRUE)
	(set b_test_roofbomb TRUE)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_sword_roofbomb_spawn/player0)
	(object_teleport_to_ai_point (player1) ps_sword_roofbomb_spawn/player1)
	(object_teleport_to_ai_point (player2) ps_sword_roofbomb_spawn/player2)
	(object_teleport_to_ai_point (player3) ps_sword_roofbomb_spawn/player3)

	(wake f_corvette_sword)

)

(global boolean b_test_sword FALSE)
(script static void f_test_sword

	(f_kill_all_scripts)

	(switch_zone_set zoneset_interior)
	(set b_insertion_fade_in TRUE)
	(set b_test_sword TRUE)
	(soft_ceiling_enable default 0)

	; Teleport
	(object_teleport_to_ai_point (player0) ps_sword_atrium/player0)
	(object_teleport_to_ai_point (player1) ps_sword_atrium/player1)
	(object_teleport_to_ai_point (player2) ps_sword_atrium/player2)
	(object_teleport_to_ai_point (player3) ps_sword_atrium/player3)

	(f_kat_spawn sq_kat/atrium obj_sword_hum)
	(device_set_position dm_door_atrium 1)
	(tick)
	(device_operates_automatically_set dm_door_atrium TRUE)

	(set s_objcon_sword 10)

	(wake f_sword_main)	

)

;==============SPECIAL ELITE=====================;
(global short s_special_elite 0)
(global boolean b_special false)
(global boolean b_special_win false)
(global short s_special_elite_ticks 600)

(script dormant special_elite
	(dprint "special elite")
	(set s_special_elite (random_range 1 3))
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

(script static void f_test_vehicle_air

	(f_kill_all_scripts)
	(f_vehicle_goto_set vehicle_air)
	(ai_place sq_valley_troophog/test)

	(f_kat_spawn sq_kat/test obj_air_hum)
	(tick)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_valley_troophog/test) "warthog_d" o_kat)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_valley_troophog/test) "warthog_p" (player0))

)

(script static void f_test_vehicle_far

	(f_kill_all_scripts)
	(f_vehicle_goto_set vehicle_far)
	(ai_place sq_valley_troophog/test)

	(f_kat_spawn sq_kat/test obj_far_hum)
	(tick)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_valley_troophog/test) "warthog_d" o_kat)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_valley_troophog/test) "warthog_p" (player0))

)

(script static void f_test_vehicle_valley

	(f_kill_all_scripts)
	(f_vehicle_goto_set vehicle_return)
	(ai_place sq_valley_troophog/test)

	(f_kat_spawn sq_kat/test obj_return_hum)
	(tick)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_valley_troophog/test) "warthog_d" o_kat)
	(vehicle_load_magic (ai_vehicle_get_from_starting_location sq_valley_troophog/test) "warthog_p" (player0))

)

(global short ai_detail_low 1)
(global short ai_detail_medium 2)
(global short ai_detail_high 3)
(script static void (f_ai_detail (short detail))

	(if (= detail ai_detail_low) (ai_lod_full_detail_actors 15) )
	(if (= detail ai_detail_medium) (ai_lod_full_detail_actors 20) )
	(if (= detail ai_detail_high) (ai_lod_full_detail_actors 20) )

)