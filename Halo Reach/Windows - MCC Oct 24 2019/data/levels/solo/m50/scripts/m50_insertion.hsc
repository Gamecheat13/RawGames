; =================================================================================================
; GLOBALS
; =================================================================================================
(global short s_zoneset_all_index 6)
(global short g_encounter_variant 0)

; ENCOUNTER INDICES
(global short s_index_panoptical 1)
(global short s_index_towers 2)
(global short s_index_interior 3)
(global short s_index_canyonview 4)
(global short s_index_atrium 5)
(global short s_index_ready 6)
(global short s_index_jetpack_low 7)
(global short s_index_jetpack_high 8)
(global short s_index_trophy 9)
(global short s_index_ride 10)
(global short s_index_starport 11)

; =================================================================================================
; PANOPTICAL
; =================================================================================================
(script static void ins_panoptical
	(if debug (print "::: insertion point: panoptical"))
	(set s_active_insertion_index s_index_panoptical)

	;(insertion_snap_to_black)
			
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_panoptical_010_020)
			(sleep 1)))

	;(objects_destroy_all)
	;(objects_manage_0)

	
	; Teleport
	(object_teleport (player0) spawn_panoptical_player0)
	(object_teleport (player1) spawn_panoptical_player1)
	(object_teleport (player2) spawn_panoptical_player2)
	(object_teleport (player3) spawn_panoptical_player3)
	
	(if (editor_mode)	
		(insertion_fade_to_gameplay)
	)
		
)


; =================================================================================================
; TOWERS
; =================================================================================================
(script static void ins_towers
	(if debug (print "::: insertion point: towers"))
	(set s_active_insertion_index s_index_towers)
				
	; Snap out
	(insertion_snap_to_black)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_interior_010_020_030)
			(sleep 1)))

	;(objects_destroy_all)
	;(objects_manage_1)
	
	;(wake f_corvette_exterior)
	
	; Teleport
	(object_teleport (player0) spawn_towers_player0)
	(object_teleport (player1) spawn_towers_player1)
	(object_teleport (player2) spawn_towers_player2)
	(object_teleport (player3) spawn_towers_player3)
		
	(insertion_fade_to_gameplay)
)

; =================================================================================================
; INTERIOR
; =================================================================================================
(script static void ins_interior
	(if debug (print "::: insertion point: interior"))
	(set s_active_insertion_index s_index_interior)
				
	; Snap out
	(insertion_snap_to_black)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_interior_010_020_030)
			(sleep 1)))

	;(objects_destroy_all)
	;(objects_manage_1)
	
	; Teleport
	(object_teleport (player0) spawn_interior_player0)
	(object_teleport (player1) spawn_interior_player1)
	(object_teleport (player2) spawn_interior_player2)
	(object_teleport (player3) spawn_interior_player3)
		
	(wake md_amb_cruiser01)
	(insertion_fade_to_gameplay)
)


; =================================================================================================
; CANYON VIEW
; =================================================================================================
(script static void ins_canyonview
	(if debug (print "::: insertion point: canyon view"))
	(set s_active_insertion_index s_index_canyonview)
				
	; Snap out
	(insertion_snap_to_black)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_canyonview_030_040)
			(sleep 1)))

	;(objects_destroy_all)
	;(objects_manage_2)
	;(wake f_corvette_exterior)
	
	; Teleport
	(object_teleport (player0) spawn_canyonview_player0)
	(object_teleport (player1) spawn_canyonview_player1)
	(object_teleport (player2) spawn_canyonview_player2)
	(object_teleport (player3) spawn_canyonview_player3)
		
	(sleep 1)
	(wake ambient_spawn_dropships)
	(wake ambient_wraith_shells_a)
	(wake ambient_wraith_shells_b)
	(player_set_profile profile_combat)
	(insertion_fade_to_gameplay)
)


; =================================================================================================
; ATRIUM
; =================================================================================================
(script static void ins_atrium
	(if debug (print "::: insertion point: atrium"))
	(set s_active_insertion_index s_index_atrium)
				
	; Snap out
	(insertion_snap_to_black)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_atrium_040_050_060)
			(sleep 1)))

	;(objects_destroy_all)
	;(objects_manage_3)
	;(wake f_corvette_exterior)
		
	; Teleport
	(object_teleport (player0) spawn_atrium_player0)
	(object_teleport (player1) spawn_atrium_player1)
	(object_teleport (player2) spawn_atrium_player2)
	(object_teleport (player3) spawn_atrium_player3)
		

	(ai_place atrium_unsc_troopers)
	;(ai_cannot_die atrium_unsc_troopers TRUE)
	
	;(wake atrium_civilians)
	(device_set_position dm_canyonview_door1 1)
	(player_set_profile profile_combat)
	(insertion_fade_to_gameplay)
)


; =================================================================================================
;  READY ROOM
; =================================================================================================
(script static void ins_ready
	;*
	(if editor
		(game_insertion_point_set 1))
	*;
	(if debug (print "::: insertion point: ready room"))
	(set s_active_insertion_index s_index_ready)

	;(insertion_snap_to_black)
	(fade_out 0 0 0 0)
	
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_jetpack_060_070_080)
			(sleep 1)))

	;(objects_destroy_all)
	;(objects_manage_4)
	;(soft_ceiling_enable blocker_01 1)
	 
	; Teleport
	(object_teleport (player0) spawn_ready_player0)
	(object_teleport (player1) spawn_ready_player1)
	(object_teleport (player2) spawn_ready_player2)
	(object_teleport (player3) spawn_ready_player3)
;*	
	(ai_place atrium_unsc_elevator/ready)
	(ai_place rr_unsc_inf0)
	(sleep 1)
	(ai_set_targeting_group rr_unsc_inf0 1 FALSE);troopers shooting at banshees
	(ai_place rr_unsc_medic0)	
	(ai_place rr_civilians0)
	(sleep 1)
	(thespian_performance_setup_and_begin ready_injured "" 0)
*;	
	(wake alpha_insertion_objective)
	
	(sleep 5)
	(player_set_profile profile_combat)
	;(insertion_fade_to_gameplay)
	(fade_in 0 0 0 30)
	(mus_start mus_09)
)
(script dormant alpha_insertion_objective
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_jetpack" "PRIMARY_OBJECTIVE_6");ACQUIRE JETPACK EQUIPMENT
	;(f_hud_start_menu_obj "PRIMARY_OBJECTIVE_6");Acquire Jet Pack armor ability and assist ODST squad gearing up to traverse the Cargo Port.	
)
; =================================================================================================
; JETPACK LOW
; =================================================================================================
(script static void ins_jetpack_low
	(if debug (print "::: insertion point: jetpack low"))
	;(set s_active_insertion_index s_index_jetpack_low)

	; Snap out
	(insertion_snap_to_black)
		
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_jetpack_060_070_080)
			(sleep 1)))

	;(objects_destroy_all)
	;(objects_manage_4)
	
	; Teleport
	(object_teleport (player0) spawn_jetpack_low_player0)
	(object_teleport (player1) spawn_jetpack_low_player1)
	(object_teleport (player2) spawn_jetpack_low_player2)
	(object_teleport (player3) spawn_jetpack_low_player3)

	(ai_place unsc_jl_odsts/low0)
	(ai_place unsc_jl_odsts/low1)
	(ai_place unsc_jl_odsts1/low0)
	(ai_place unsc_jl_odsts1/low1)
	
	(if (not (game_is_cooperative))
		(begin
			(ai_player_add_fireteam_squad player0 unsc_jl_odsts)
			(ai_player_add_fireteam_squad player0 unsc_jl_odsts1)))

	;(ai_cannot_die unsc_jl_odsts TRUE)
	(sleep 1)
	(ai_set_objective unsc_jl_odsts obj_jetpack_low_unsc)	
	(ai_set_objective unsc_jl_odsts1 obj_jetpack_low_unsc)	
	(wake jl_odst_renew)
	(player_set_profile profile_jetpack)
	(jp)
	(set s_active_insertion_index s_index_jetpack_low)
	(insertion_fade_to_gameplay)
	(sleep 1)
	
)

; =================================================================================================
; JETPACK HIGH
; =================================================================================================
(script static void ins_jetpack_high
	(if debug (print "::: insertion point: jetpack high"))
	(set s_active_insertion_index s_index_jetpack_high)

	; Snap out
	(insertion_snap_to_black)
		
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_jetpack_060_070_080)
			(sleep 1)))

	;(objects_destroy_all)
	(objects_manage_4b)
	;(soft_ceiling_enable blocker_02 0)
	
	; Teleport
	(object_teleport (player0) spawn_jetpack_high_player0)
	(object_teleport (player1) spawn_jetpack_high_player1)
	(object_teleport (player2) spawn_jetpack_high_player2)
	(object_teleport (player3) spawn_jetpack_high_player3)	
	(player_set_profile profile_jetpack)	
	(jp)
	(insertion_fade_to_gameplay)
	(sleep 1)
)

; =================================================================================================
;  TROPHY
; =================================================================================================

(script static void ins_trophy
	(if debug (print "::: insertion point: trophy"))
	(set s_active_insertion_index s_index_trophy)
	
	; Snap out
	(insertion_snap_to_black)
		
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_jetpack_060_070_080)
			(sleep 1)))

	;(objects_destroy_all)
	(objects_manage_4b)
	(soft_ceiling_enable low_jetpack_blocker 0)
	
	; Teleport
	(object_teleport (player0) spawn_trophy_player0)
	(object_teleport (player1) spawn_trophy_player1)
	(object_teleport (player2) spawn_trophy_player2)
	(object_teleport (player3) spawn_trophy_player3)

	(ai_place jh_unsc_mars_tree_inf0/sf_trophy)
	(ai_place jh_unsc_mars_balcony_inf0/sf_trophy)
	(ai_place jh_unsc_odst_balcony_inf0/sp_trophy)
	(ai_place jh_unsc_odst_tree_inf0/sp_trophy)
	(ai_place jh_civilians0/sf_trophy)
	(wake jh_odst_renew)
	(player_set_profile profile_jetpack)
	(jp)
	(insertion_fade_to_gameplay)
	(sleep 1)
	
)

; =================================================================================================
;  FALCON RIDE
; =================================================================================================
(script static void ins_ride	
	(if debug (print "::: insertion point: ride"))
	(set s_active_insertion_index s_index_ride)

	(insertion_snap_to_black)

	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_jetpack_060_070_080)
			(sleep 1)))

	;(objects_destroy_all)
	(objects_manage_4b)
	(soft_ceiling_enable low_jetpack_blocker 0)
	
	; Teleport
	(object_teleport (player0) spawn_ride_player0)
	(object_teleport (player1) spawn_ride_player1)
	(object_teleport (player2) spawn_ride_player2)
	(object_teleport (player3) spawn_ride_player3)	

	(set b_trophy_complete TRUE)

	(ai_place sq_evac1_m1 10)			
	(ai_place jh_unsc_odst_balcony_inf0/sp_ride)
	(ai_place jh_unsc_odst_tree_inf0/sp_ride)
	(ai_place jh_unsc_mars_balcony_inf0/sp_ride 3)
	(sleep 1)

	;perf
	;(ai_force_low_lod gr_civilian)
	(ai_force_full_lod gr_civilian)
	
	(ai_lod_full_detail_actors 15)
	
	(ai_set_objective jh_unsc_odst_balcony_inf0 obj_trophy_unsc)
	(ai_set_objective jh_unsc_odst_tree_inf0 obj_trophy_unsc)
	(ai_set_objective jh_unsc_mars_balcony_inf0 obj_trophy_unsc)
	

	(flock_create fl_shared_banshee0)
	(flock_create fl_shared_falcon0)
	(flock_create fl_shared_banshee1)
	(flock_create fl_shared_falcon1)
	(flock_create fl_corvette_phantom1)
		
	(player_set_profile profile_jetpack)
	(jp)
	;(set s_active_insertion_index s_index_ride)
	(insertion_fade_to_gameplay)
	(mus_start mus_10)
	(wake bravo_insertion_objective)
	
	;(wake ride_objective_control)
	(set b_jetpack_complete true)
)
(script dormant bravo_insertion_objective
	(sleep objective_delay)
	(f_hud_obj_new "ct_objective_transports" "PRIMARY_OBJECTIVE_10"); "EVACUATE CIVILIAN TRANSPORTS"
	;(f_hud_start_menu_obj "PRIMARY_OBJECTIVE_10");"Covenant Corvettes over the city are preventing the evacuation of civilian transport ships. Assist UNSC forces at the Starport."
)
; =================================================================================================
; STARPORT
; =================================================================================================
(script static void ins_starport
	(if debug (print "::: insertion point: starport"))
	(set s_active_insertion_index s_index_starport)
	
	(insertion_snap_to_black)
		
	; Switch to correct zone set unless "set_all" is loaded 
	(if (!= (current_zone_set) s_zoneset_all_index)
		(begin
			(if debug (print "switching zone sets..."))
			(switch_zone_set set_starport_090)
			(sleep 1)))

	;(objects_destroy_all)
	;(objects_manage_5)
	;(soft_ceiling_enable blocker_02 0)

	; Teleport
	(object_teleport (player0) spawn_starport_player0)
	(object_teleport (player1) spawn_starport_player1)
	(object_teleport (player2) spawn_starport_player2)
	(object_teleport (player3) spawn_starport_player3)
		
	(ai_place starport_insertion_unsc)
	(ai_place starport_insertion0_unsc)

	(flock_create fl_shared_banshee2)
	(flock_create fl_shared_falcon2)
	(flock_create fl_corvette_phantom2)

	(object_destroy dm_civilian_transport)
	(set b_starport_monologue TRUE)
	(set b_starport_intro TRUE)
	(set b_falcon_unloaded TRUE)
	(set b_falcon_lz_setup TRUE)
	
	(player_set_profile profile_jetpack)
	(jp)
	(sleep 1)
	(insertion_fade_to_gameplay)		
	
)

(script static void test_starport
	(ins_starport)
	(sleep 1)
	(jp)
)

; =================================================================================================
; JETPACK PROFILE
; =================================================================================================
(script static void jp
	(unit_add_equipment (player0) profile_jetpack TRUE TRUE)
	(unit_add_equipment (player1) profile_jetpack TRUE TRUE)
	(unit_add_equipment (player2) profile_jetpack TRUE TRUE)
	(unit_add_equipment (player3) profile_jetpack TRUE TRUE)
)