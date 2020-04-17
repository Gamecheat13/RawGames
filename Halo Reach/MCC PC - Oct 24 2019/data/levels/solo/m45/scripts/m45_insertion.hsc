; -------------------------------------------------------------------------------------------------
; INSERTION INDICES
; -------------------------------------------------------------------------------------------------
(global short s_insertion_index			-1)
(global short s_bch_encounter_index		0)
(global short s_fac_encounter_index 	1)
(global short s_slo_encounter_index		2)
(global short s_lnc_encounter_index 	3)
(global short s_waf_encounter_index 	4)
(global short s_wrp_encounter_index		5)
(global short s_crv_encounter_index		6)
(global short s_brd_encounter_index		7)
(global short s_com_encounter_index		8)
(global short s_frg_encounter_index		9)
(global short s_hgr_encounter_index		10)
(global short s_grm_encounter_index		11)
(global short s_brg_encounter_index		12)
(global short s_esc_encounter_index		13)
(global short s_fin_encounter_index		14)

(global short s_zoneindex_landing			0)
(global short s_zoneindex_beach				1)
(global short s_zoneindex_facility			2)
(global short s_zoneindex_silo				3)
(global short s_zoneindex_launch			4)
(global short s_zoneindex_wafer				5)
(global short s_zoneindex_wafercombat		6)
(global short s_zoneindex_warp				7)
(global short s_zoneindex_corvette			8)
(global short s_zoneindex_corvettecombat	9)
(global short s_zoneindex_aftship			10)
(global short s_zoneindex_hangar			11)
(global short s_zoneindex_cinbombdelivery	12)
(global short s_zoneindex_gunroom			13)
(global short s_zoneindex_bridge			14)
(global short s_zoneindex_escape			15)

; -------------------------------------------------------------------------------------------------
; BEACH
; -------------------------------------------------------------------------------------------------
(script static void ins_beach
	(if debug (print "insertion: beach"))
	
	; set insertion point index 
	(set s_insertion_index s_bch_encounter_index)
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_landing_001_005)
	(sleep 1)
	
	(teleport_players
		fl_beach_player0
		fl_beach_player1
		fl_beach_player2
		fl_beach_player3)
)


; -------------------------------------------------------------------------------------------------
; COMMAND
; -------------------------------------------------------------------------------------------------
(script static void ins_facility
	(if debug (print "insertion: facility"))
	
	; set insertion point index 
	(set s_insertion_index s_fac_encounter_index)
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_facility_001_005_010)
	(sleep 1)
	
	; set mission progress accordingly 
	(set s_objcon_bch 100)
	
	; teleporting players 
	(print "teleporting players...")
	(object_teleport (player0) fl_command_player0)
	(object_teleport (player1) fl_command_player1)
	(object_teleport (player2) fl_command_player2)
	(object_teleport (player3) fl_command_player3)
	(sleep 1)
	
	; place fork_01 + allies 
	;(wake beach_place_03)	
	
	(ai_erase gr_unsc_spartans)
	(sleep 1)
	(ai_place sq_carter/fac)
	(ai_place sq_jorge/fac)
	(ai_place sq_kat/fac)
	(sleep 1)
	(set ai_carter sq_carter)
	(set ai_jorge sq_jorge)
	(set ai_kat sq_kat)
	
	;open door 
	;(device_set_power dm_silo_door_01 1)
	;(device_set_position dm_silo_door_01 1)

	(game_save)			
)


; -------------------------------------------------------------------------------------------------
; LAUNCH
; -------------------------------------------------------------------------------------------------
(script static void ins_launch
	(if debug (print "insertion: launch"))
	; set insertion point index 
	
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_silo_005_010_015)
	(sleep 1)
	
	; set mission progress accordingly 
	(set s_objcon_bch 100)
	(set s_objcon_fac 100)	
	
	; teleporting players 
	(print "teleporting players...")
	(object_teleport (player0) fl_launch_player0)
	(object_teleport (player1) fl_launch_player1)
	(object_teleport (player2) fl_launch_player2)
	(object_teleport (player3) fl_launch_player3)
	(sleep 1)

	; open door and set up sabre
	;(device_set_power dm_silo_door_02 1)
	;(device_set_position dm_silo_door_02 1)	
	;(object_create sc_slo_sabre)
	
	;(fac_setup_control_room)
	(sleep 10)
	(lnc_spartan_spawn)
	;(f_blip_flag fl_launch blip_interface)
	;(device_set_position_immediate dm_slo_shutter 1)
	;(lnc_setup_silo)
	
	(set s_insertion_index s_lnc_encounter_index)
)


; -------------------------------------------------------------------------------------------------
; WAFER
; -------------------------------------------------------------------------------------------------
(script static void ins_wafer
	(if debug (print "insertion: wafer"))
	(soft_ceiling_enable beach_blocker_01 0)

	; set insertion point index 
	(set s_insertion_index s_waf_encounter_index)
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_wafercombat_030)
	(sleep 1)
	
	; teleporting players 
	(print "teleporting players...")
	
	;*
	(create_player_sabres
		v_wafer_sabre_player0 
		v_wafer_sabre_player1 
		v_wafer_sabre_player2 
		v_wafer_sabre_player3)
	(load_player_sabres
		v_wafer_sabre_player0 
		v_wafer_sabre_player1 
		v_wafer_sabre_player2 
		v_wafer_sabre_player3)		
	*;
	(nuke_planet)
)


; -------------------------------------------------------------------------------------------------
; WARP
; -------------------------------------------------------------------------------------------------
(script static void ins_warp
	(if debug (print "insertion: warp from wafer to corvette"))
	
	; insertion point index
	(set s_insertion_index s_wrp_encounter_index)
	
; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_wafercombat_030)
	(sleep 1)
	
	(create_player_sabres
		v_warp_sabre_player0 
		v_warp_sabre_player1 
		v_warp_sabre_player2 
		v_warp_sabre_player3)
	(load_player_sabres
		v_warp_sabre_player0 
		v_warp_sabre_player1 
		v_warp_sabre_player2 
		v_warp_sabre_player3)
	
	(object_create dm_savannah_wafer)
	
	(nuke_planet)
)	


; -------------------------------------------------------------------------------------------------
; CORVETTE
; -------------------------------------------------------------------------------------------------
(script static void ins_corvette
	(if debug (print "insertion: corvette assault"))
	; set insertion point index 
	
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_corvettecombat_050_070)
	(sleep 1)
	
	
	;*
	(create_player_sabres
		v_corvette_sabre_player0 
		v_corvette_sabre_player1 
		v_corvette_sabre_player2 
		v_corvette_sabre_player3)
	(load_player_sabres
		v_corvette_sabre_player0 
		v_corvette_sabre_player1 
		v_corvette_sabre_player2 
		v_corvette_sabre_player3)
	
	
	;(object_create savannah_corvette)		
	
	*;
	
	(nuke_planet)
	
	(set s_insertion_index s_crv_encounter_index)
)


; -------------------------------------------------------------------------------------------------
; CORVETTE
; -------------------------------------------------------------------------------------------------
(script static void ins_trailer
	(if debug (print "insertion: corvette assault"))
	; set insertion point index 
	
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_corvettecombat_050_070)
	(sleep 1)
	
	
	;*
	(create_player_sabres
		v_corvette_sabre_player0 
		v_corvette_sabre_player1 
		v_corvette_sabre_player2 
		v_corvette_sabre_player3)
	(load_player_sabres
		v_corvette_sabre_player0 
		v_corvette_sabre_player1 
		v_corvette_sabre_player2 
		v_corvette_sabre_player3)
	
	
	;(object_create savannah_corvette)		
	
	*;
	
	(nuke_planet)
	
	;(set s_insertion_index s_crv_encounter_index)
	
	(wake trailer)
)

(script dormant trailer
	(fade_in 0 0 0 0)
	(if debug (print "spooling up the ambient scene..."))
	
	(object_create_folder sc_crv)
	(object_create_folder dm_crv_engines)
	(ai_lod_full_detail_actors 42)
	(lnos_setup)
	(setup_corvette_cannons)
	(sleep_forever corvette_cannon_control)
	
	(wake trailer_corvette_cannon_control)
	
	(wake crv_pod_drop_left_control)
	(wake crv_pod_drop_right_control)
	
	(object_create sc_crv_shutters)
	(object_cinematic_visibility sc_crv_shutters true)
	
	(sleep 30)
	(ai_disregard (ai_actors sq_cov_crv_cannon_gunners) true)
	
	
	(wake trailer_savannah_control)
	(wake trailer_seraph_control)
	(wake trailer_banshee_control)
	(trailer_fly)
)

(script static void trailer_fly
	(if debug (print "new wafer sabre to test..."))
	(object_create_anew v_trailer_sabre)
	(vehicle_load_magic v_trailer_sabre "sabre_d" (player0))
)

(script dormant trailer_savannah_control
	(sleep_until
		(begin
			(ai_erase sq_unsc_sav_gunners)
			(object_destroy dm_savannah_corvette)
			(object_create dm_savannah_corvette)
			(sleep 1)
			(device_set_position_track dm_savannah_corvette "m45_orbit_corvette" 0)
			(device_set_position_immediate dm_savannah_corvette 0)
			(device_set_position_transition_time dm_savannah_corvette 0.5)
			(device_set_power dm_savannah_corvette 1)
	
			(savannah_load_gunners dm_savannah_corvette)
			
			(sleep_until (> (device_get_position dm_savannah_corvette) 0.26))
		0)
	1)
)

(script dormant trailer_seraph_control
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count gr_cov_crv_seraphs) 3))
			(crv_seraph_spawn_immediate 8)
		0)
	1)
)

(script dormant trailer_banshee_control
	(set b_crv_banshee_launch true)
	
	(sleep 450)
	
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count gr_cov_crv_banshees) 1))
			(ai_place sq_cov_crv_bsh_start0)
			(ai_place sq_cov_crv_bsh_start1)
		0)
	1)
)

(script dormant trailer_sabre_control
	(sleep_until
		(begin
			(sleep_until (<= (ai_living_count gr_unsc_crv_sabres) 1))
			(crv_sabre_spawn_immediate 5)
		0)
	1)
)


(script dormant trailer_corvette_cannon_control
				(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left0 cs_corvette_gunners_left)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left1 cs_corvette_gunners_left)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left2 cs_corvette_gunners_left)
	;*
	(sleep_until
		(begin
			(sleep_until
				(and
					(> (device_get_position dm_savannah_corvette) 0.00)	;	 frigate is in view of the left guns
					(< (device_get_position dm_savannah_corvette) 0.15)) 1)
					; left-side guns fire at the frigate
					; -------------------------------------------------
					(if debug (print "corvette: left cannons aiming at the frigate.."))
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left0 cs_corvette_gunners_left)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left1 cs_corvette_gunners_left)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left2 cs_corvette_gunners_left)
					; -------------------------------------------------
					
			(sleep_until (> (device_get_position dm_savannah_corvette) 0.15) 1)
			
					; left-side guns are free
					; -------------------------------------------------
					(if debug (print "corvette: left cannons are free.."))
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left0 cs_abort)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left1 cs_abort)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_left2 cs_abort)
					; -------------------------------------------------
					
			(sleep_until 
				(and
					(> (device_get_position dm_savannah_corvette) 0.44)		; frigate is in view of the right guns
					(< (device_get_position dm_savannah_corvette) 0.56)) 1)
					; right-side guns fire at the frigate
					; -------------------------------------------------
					(if debug (print "corvette: right cannons aiming at the frigate.."))
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_right0 cs_corvette_gunners_right)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_right1 cs_corvette_gunners_right)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_right2 cs_corvette_gunners_right)
					; -------------------------------------------------
					
			(sleep_until (> (device_get_position dm_savannah_corvette) 0.56) 1)
			
					; left-side guns are free
					; -------------------------------------------------
					(if debug (print "corvette: right cannons are free.."))
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_right0 cs_abort)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_right1 cs_abort)
					(cs_run_command_script sq_cov_crv_cannon_gunners/gunner_right2 cs_abort)
					; -------------------------------------------------
		0)
	1)
	*;
)


; -------------------------------------------------------------------------------------------------
; BOARDING
; -------------------------------------------------------------------------------------------------
(script static void ins_boarding
	(if debug (print "insertion: corvette boarding"))
	; set insertion point index 
	(set s_insertion_index s_brd_encounter_index)
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_corvettecombat_050_070)
	(sleep 1)
	
	; set mission progress accordingly 
	(set s_objcon_bch 		1000)
	(set s_objcon_fac 	1000)	
	(set s_objcon_lnc 	1000)
	(set s_objcon_waf 	1000)
	
	
	(create_player_sabres
		v_landing_sabre_player0 
		v_landing_sabre_player1 
		v_landing_sabre_player2 
		v_landing_sabre_player3)
	(load_player_sabres
		v_landing_sabre_player0 
		v_landing_sabre_player1 
		v_landing_sabre_player2 
		v_landing_sabre_player3)	
		
	
	(object_create dm_savannah_corvette)
	
	(nuke_planet)
)


; -------------------------------------------------------------------------------------------------
; COMM CENTER
; -------------------------------------------------------------------------------------------------
(script static void ins_comms
	(if debug (print "insertion: communications center"))
	(soft_ceiling_enable beach_blocker_01 0)
	
	(set s_insertion_index s_com_encounter_index)
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_aftship_050_070)
	(sleep 1)
	
	; teleporting players 
	(print "teleporting players...")
	(teleport_players
		fl_comms_player0
		fl_comms_player1
		fl_comms_player2
		fl_comms_player3)
	
	; put the savannah in position
	(object_destroy dm_savannah_corvette)
	(object_create dm_savannah_corvette)
	
	
	
	(lnos_setup)
	(nuke_planet)
	
	(mus_start mus_07)
)


; -------------------------------------------------------------------------------------------------
; HANGAR
; -------------------------------------------------------------------------------------------------
(script static void ins_hangar
	(if debug (print "insertion: hangar"))
	(set s_insertion_index s_hgr_encounter_index)
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_hangar_050_070_060)
	(sleep 1)
	
	(teleport_players
		fl_hangar_player0
		fl_hangar_player1
		fl_hangar_player2
		fl_hangar_player3)
		
	; put the savannah in position
	(object_destroy dm_savannah_corvette)
	(object_create dm_savannah_hangar)	
		
	
	(object_create_folder sc_comms)
	;(object_create_folder sc_aft)

	
	(nuke_planet)
	
	(sleep 1)
	
	(ai_place sq_unsc_com_pilots/hangar_pilot0)
	(ai_place sq_unsc_com_pilots/hangar_pilot1)
	(ai_place sq_unsc_com_pilots/hangar_pilot2)
	(ai_set_objective sq_unsc_com_pilots obj_unsc_hgr)
)


; -------------------------------------------------------------------------------------------------
; GUN ROOM
; -------------------------------------------------------------------------------------------------
(script static void ins_gunroom
	(if debug (print "insertion: gunroom"))
	(set s_insertion_index s_grm_encounter_index)
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_gunroom_050_060_065)
	(sleep 1)
	
	(teleport_players
		fl_gunroom_player0
		fl_gunroom_player1
		fl_gunroom_player2
		fl_gunroom_player3)
	
	; put the savannah in position
	(object_destroy dm_savannah_corvette)
	(object_create dm_savannah_hangar)	
	
	; spawn the final pelican
	;(object_create sc_final_pelican)
	
	
	(nuke_planet)
	(lnos_setup)
	

)


; -------------------------------------------------------------------------------------------------
; BRIDGE
; -------------------------------------------------------------------------------------------------
(script static void ins_bridge
	(if debug (print "insertion: bridge"))
	; set insertion point index 
	(set s_insertion_index s_brg_encounter_index)
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_bridge_050_065_080)
	(sleep 1)
	
	; teleporting players 
	(print "teleporting players...")
	(object_teleport (player0) fl_bridge_player0)
	(object_teleport (player1) fl_bridge_player1)
	(object_teleport (player2) fl_bridge_player2)
	(object_teleport (player3) fl_bridge_player3)
	(sleep 1)

	;(game_save)			
	
	; remove all instances of the savannah
	(object_destroy_folder dm_savannah)
	
	;(object_create sc_final_pelican)
	
	(open_hangar_gunroom_doors)
	
		
	;(ai_set_objective sq_unsc_pilots_test obj_unsc_brg)
	
	(lnos_setup)
	(nuke_planet)
	
	(ai_place sq_unsc_brg_pilots0)
)


; -------------------------------------------------------------------------------------------------
; ESCAPE
; -------------------------------------------------------------------------------------------------
(script static void ins_escape
	(if debug (print "insertion: escape"))
	(set s_insertion_index s_esc_encounter_index)
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_bridge_050_065_080)
	(sleep 1)
	
	(teleport_players
		fl_escape_player0
		fl_escape_player1
		fl_escape_player2
		fl_escape_player3)
	
	(open_hangar_gunroom_doors)
	;(object_create sc_final_pelican)
	
	
	(nuke_planet)
)


; -------------------------------------------------------------------------------------------------
; FINAL
; -------------------------------------------------------------------------------------------------
(script static void ins_final
	(if debug (print "insertion: final"))
	
	; set insertion point index 
	(set s_insertion_index s_fin_encounter_index)
	
	; switch to correct zone set
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_escape_050_065_060)
	(sleep 1)
		
	; teleporting players 
	(print "teleporting players...")
	(teleport_players
		fl_final_player0
		fl_final_player1
		fl_final_player2
		fl_final_player3)
		
	(sleep 1)

	(game_save)			
	
	(open_hangar_gunroom_doors)
	
	;(object_create sc_final_pelican)
	
	(nuke_planet)
)


; -------------------------------------------------------------------------------------------------
; TEST INSERTIONS
; -------------------------------------------------------------------------------------------------
(global vehicle test_saber none)

(script static void (create_player_sabres
					(object_name sabre0) 
					(object_name sabre1) 
					(object_name sabre2) 
					(object_name sabre3))
	
		(if (player_is_in_game player3)
		(begin
			(if debug (print "creating sabre3..."))
			(object_create sabre3)
		))

	(if  (player_is_in_game player2)
		(begin
			(if debug (print "creating sabre2..."))
			(object_create sabre2)
		))
		
	(if  (player_is_in_game player1)
		(begin
			(if debug (print "creating sabre1..."))
			(object_create sabre1)
		))
		
	(if  (player_is_in_game player0)
		(begin
			(if debug (print "creating sabre0..."))
			(object_create sabre0)
		))
		
	(sleep 1)
)

(script static void (load_player_sabres 
					(vehicle sabre0) 
					(vehicle sabre1) 
					(vehicle sabre2) 
					(vehicle sabre3))
					
	(if (player_is_in_game player3)
		(begin
			(if debug (print "loading sabre3..."))
			;(object_create sabre3)
			(vehicle_load_magic sabre3 "sabre_d" player3)
			(vehicle_set_player_interaction sabre3 "sabre_d" false false)
		))

	(if (player_is_in_game player2)
		(begin
			(if debug (print "loading sabre2..."))
			;(object_create sabre2)
			(vehicle_load_magic sabre2 "sabre_d" player2)
			(vehicle_set_player_interaction sabre2 "sabre_d" false false)
		))
		
	(if (player_is_in_game player1)
		(begin
			(if debug (print "loading sabre1..."))
			;(object_create sabre1)
			(vehicle_load_magic sabre1 "sabre_d" player1)
			(vehicle_set_player_interaction sabre1 "sabre_d" false false)
		))
		
	(if (player_is_in_game player0)
		(begin
			(if debug (print "loading sabre0..."))
			;(object_create sabre0)
			(vehicle_load_magic sabre0 "sabre_d" player0)
			(vehicle_set_player_interaction sabre0 "sabre_d" false false)
		))
)


(script dormant sabre_seat_exit_control
	(branch
		(= b_com_started true) (branch_abort)
	)
	
	(sleep_until
		(begin
			(if (player_is_in_game player0)
				(vehicle_set_player_interaction (unit_get_vehicle player0) "sabre_d" true false))
			
			(if (player_is_in_game player1)
				(vehicle_set_player_interaction (unit_get_vehicle player1) "sabre_d" true false))
				
			(if (player_is_in_game player2)
				(vehicle_set_player_interaction (unit_get_vehicle player2) "sabre_d" true false))
			
			(if (player_is_in_game player3)
				(vehicle_set_player_interaction (unit_get_vehicle player3) "sabre_d" true false))
		0)
	1)
)

; -------------------------------------------------------------------------------------------------
; ENCOUNTER TESTS
; -------------------------------------------------------------------------------------------------
(script static void test_crv_fly
	(create_player_sabres
		v_corvette_sabre_player0 
		v_corvette_sabre_player1 
		v_corvette_sabre_player2 
		v_corvette_sabre_player3)
	(load_player_sabres
		v_corvette_sabre_player0 
		v_corvette_sabre_player1 
		v_corvette_sabre_player2 
		v_corvette_sabre_player3)
)

(script static void waf_test
	(object_create_folder cr_waf)
	(object_create_folder sc_waf_bays)
	(object_create_folder sc_waf_debris)
)

(script static void waf_fly
	(if debug (print "new wafer sabre to test..."))
	(vehicle_unload v_test_waf_sabre "")
	(object_create_anew v_test_waf_sabre)
	(vehicle_load_magic v_test_waf_sabre "sabre_d" (player0))
)

(script static void test_aft
	(if debug (print "switching zone sets..."))
	(switch_zone_set set_aftship_050_070)
	
	(teleport_players
		fl_comms_player0
		fl_comms_player1
		fl_comms_player2
		fl_comms_player3)
		
	(physics_set_gravity 0.3)
	
	(object_destroy sc_aft_top)
	
	(ai_erase gr_cov_com)
	(ai_place gr_cov_com)
)


(script static void test_waf_start
	(create_player_sabres
		v_wafer_sabre_player0 
		v_wafer_sabre_player1 
		v_wafer_sabre_player2 
		v_wafer_sabre_player3)	
	(load_player_sabres
		v_wafer_sabre_player0 
		v_wafer_sabre_player1 
		v_wafer_sabre_player2 
		v_wafer_sabre_player3)	
)
; -------------------------------------------------------------------------------------------------
; FX TESTING
; -------------------------------------------------------------------------------------------------
(script static void ins_fx_frigate_destruction

	; switch to correct zone set
	(if debug (print "switching zone sets for frigate destruction..."))
	;(switch_zone_set set_fx_frigate_destruction)
	(sleep 1)
	
	(object_teleport_to_ai_point (player0) ps_grm_fx_teleport/player0)
	;(object_teleport (player0) fl_fx_frigate_destruction)
	
	; set up frigate destruction parameters
	(physics_set_gravity 0)
)


(global short s_fx_frigate_death_time 35)
(script static void fx_frigate_destruction
	(object_destroy_folder dm_savannah)
	
	
	(if debug (print "pristing model created for 30 ticks..."))
	(object_create dm_savannah_gunroom)
	(object_create_folder v_corvette_cannons)
	
	(sleep 30)
	
			; -------------------------------------------------		
			(if debug (print "swapping pristine frigate for destroyed..."))
			(object_destroy dm_savannah_gunroom)
			(object_create dm_savannah_destroyed)
			
			(if debug (print "putting destroyed frigate on m45_drift animation track..."))
			(device_set_position_track dm_savannah_destroyed "m45_drift" 0)
			(device_set_position_immediate dm_savannah_destroyed 0)
			(sleep 1)
			
			(device_animate_position dm_savannah_destroyed 1.0 s_fx_frigate_death_time 0.034 0.034 false)
			; start destroying the frigate with specific script calls if needed...
			
			(sleep (* 30 s_fx_frigate_death_time))	; sleep as long as the destruction takes
			(object_destroy_folder dm_savannah)
			; -------------------------------------------------
)

(script static void fx_loop_frigate_destruction
	(sleep_until
		(begin
			;(countdown)
			(fx_frigate_destruction)
			(if debug (print "frigate destruction complete: restarting..."))
		0)
	1)
)

;*
(script static void fx_corvette_cannons
	(ai_erase_all)
	(setup_corvette_cannons)
	(crv_savannah_orbit)
	(sleep 1)
	(device_set_position_immediate dm_savannah_corvette 0.1)
	(device_set_power dm_savannah_corvette 0)
)
*;
(script static void fx_phantom_shield
	(ai_erase_all)
	(ai_place sq_cov_waf_ph_top_left)
	(ai_place sq_unsc_waf_aa)
)

(script static void fx_phantom_vs_sabre
	(sleep_until
		(begin
			(ai_erase_all)
			
			(ai_place sq_cov_fx_phantom/pilot)
			(ai_place sq_unsc_waf_sbr_station3)
			
			(sleep 10)
			(sleep_until
				(or
					(<= (ai_living_count sq_cov_fx_phantom) 0)
					(<= (ai_living_count sq_unsc_waf_sbr_station3) 0)))
		0)
	1)
)

(script static void ins_fx_corvette_exterior
	; switch to correct zone set
	(if debug (print "switching zone sets for frigate destruction..."))
	;(switch_zone_set set_fx_corvette_exterior)
	(sleep 1)
	
	(object_teleport (player0) fl_fx_frigate_destruction)
	
	(create_player_sabres
		v_corvette_sabre_player0 
		v_corvette_sabre_player1 
		v_corvette_sabre_player2 
		v_corvette_sabre_player3)
	(load_player_sabres
		v_corvette_sabre_player0 
		v_corvette_sabre_player1 
		v_corvette_sabre_player2 
		v_corvette_sabre_player3)
		
	; set up frigate destruction parameters
	(physics_set_gravity 0)
	
	(object_create dm_savannah_corvette)
	
)
