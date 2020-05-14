(script static void 0
	(if (= game_speed 0)
		(set game_speed 1)
		(set game_speed 0)
	)
)

(script static void 1
	(if ai_render_sector_bsps
		(set ai_render_sector_bsps 0)
		(set ai_render_sector_bsps 1)
	)
)

(script static void 2
	(if ai_render_objectives
		(set ai_render_objectives 0)
		(set ai_render_objectives 1)
	)
)

(script static void 3
	(if ai_render_decisions
		(set ai_render_decisions 0)
		(set ai_render_decisions 1)
	)
)

(script static void 4
	(if ai_render_command_scripts
		(set ai_render_command_scripts 0)
		(set ai_render_command_scripts 1)
	)
)

(script static void 5
	(if debug_performances
		(set debug_performances 0)
		(set debug_performances 1)
	)
)

(script static void 6
	(if debug_instanced_geometry_cookie_cutters
		(begin
			(set debug_instanced_geometry_cookie_cutters 0)
			(set debug_structure_cookie_cutters 0)
		)
		(begin
			(set debug_instanced_geometry_cookie_cutters 1)
			(set debug_structure_cookie_cutters 1)
		)
	)
)

(script static void test_hill_hog
	(ai_place sq_hill_rockethog_01/no_driver)
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) ps_hog_hill/tele)
	
	(ai_place sq_hill_kat)
	(ai_cannot_die sq_hill_kat TRUE)
	(set obj_kat (ai_get_unit gr_kat))
	;(object_teleport_to_ai_point obj_kat ps_hill_hog/kat)

	(ai_vehicle_enter_immediate gr_kat (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_d")
	(vehicle_load_magic (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_g" player0)
	
	(wake hog_hill_driver)
	
)

(script static void test_twin_hog
	(ai_place sq_hill_rockethog_01/no_driver)
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) ps_hog_twin/tele02)
	
	(ai_place sq_hill_kat/facility)
	(ai_cannot_die sq_hill_kat TRUE)
	(set obj_kat (ai_get_unit gr_kat))
	(ai_set_objective gr_allies obj_twin_allies)

	(ai_vehicle_enter_immediate gr_kat (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_d")
	(vehicle_load_magic (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_g" player0)
	
	(set g_bfg01_destroyed TRUE)
	(set g_twin_obj_control 4)
	;(ai_place sq_twin_phantom_final)
	;(object_destroy dm_pelican)
	(wake twin_bridge)
	
	(wake hog_twin_driver)
	
)

(script static void test_facility_hog
	(ai_place sq_hill_rockethog_01/no_driver)
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) ps_hog_facility/p1)
	
	(ai_place sq_hill_kat/facility)
	(ai_cannot_die sq_hill_kat TRUE)
	(set obj_kat (ai_get_unit gr_kat))
	(ai_set_objective gr_allies obj_facility_allies)

	(vehicle_load_magic (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_g" player0)
	
	(kill_volume_disable kill_soft_twin)
	(ai_place sq_facility_intro_cov)
	
	(sleep 10)
	;(ai_vehicle_enter_immediate gr_kat (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_d")
	(unit_enter_vehicle_immediate (ai_get_unit gr_kat) (ai_vehicle_get_from_squad sq_hill_rockethog_01 0) "warthog_d")
	
	(wake hog_facility_driver)
)


(script static void test_bfg_falcon
	(wake twin_bfg_target_controlx)
	(set g_twin_obj_control 1)
	
)

(script dormant twin_bfg_target_controlx
	(ai_place sq_twin_bfg_driver)
	(ai_set_targeting_group sq_twin_bfg_driver 2)
	;(ai_disregard (ai_actors sq_twin_bfg_driver) TRUE)
	(object_set_persistent (ai_vehicle_get_from_squad sq_twin_bfg_driver 0) TRUE)
	(cs_run_command_script sq_twin_bfg_driver cs_twin_bfg_shoot)
	
	(sleep_until (>= g_twin_obj_control 1))
	(ai_place sq_twin_falcon_01)
	(ai_set_targeting_group sq_twin_falcon_01/driver01 2)
	(sleep 500)
	(ai_place sq_twin_falcon_02)
	(ai_set_targeting_group sq_twin_falcon_02/driver01 2)
	(cs_run_command_script sq_twin_bfg_driver abort_cs)
	
	(sleep_until (<= (ai_task_count obj_twin_allies/gt_falcons) 0))
	;(cs_run_command_script sq_twin_bfg_driver cs_twin_bfg_shoot)
	
)

(script static void test_bfg
	(wake twin_place_02)
	;(wake frigate_setup)
	(wake twin_bfg_start)
	(wake flocks_01_start)
)

(script static void test_twin_frigate
	(set g_bfg01_core_destroyed TRUE)
	(set g_bfg01_destroyed TRUE)
	(wake hill_big_battle)
	(wake frigate_setup)
	;(wake twin_longswords_start)
	;(sleep_until g_longswords01_clear)
	
	(wake twin_place_03)

)

(script static void test_falcon_frigate
	(set g_bfg01_destroyed TRUE)
	(wake flocks_04_start)
	(object_create dm_sky_frigate01b)
	(object_create dm_sky_frigate02b)
		(sleep 1)
	(frigate01b_load_gunners)
	(frigate02b_load_gunners)
	
	(wake falcon_frigate_target_control)

)


(script static void test_setpiece_frigate
	(switch_zone_set setpiece_twin)
	(sleep_until (= (current_zone_set_fully_active) 21) 1)
	(object_teleport_to_ai_point player0  ps_teleports/twin_longsword)
	
	(wake frigate_setup)
	(sleep 90)
	(cs_run_command_script sq_sky_frigate01_right_gunners cs_friagte_shoot_ground)

)

(script command_script cs_friagte_shoot_ground
	(sleep_until
		(begin
			(begin_random
				(cs_shoot_point TRUE ps_frigate_ground/p0)
				(cs_shoot_point TRUE ps_frigate_ground/p1)
				(cs_shoot_point TRUE ps_frigate_ground/p2)
				(cs_shoot_point TRUE ps_frigate_ground/p3)
				(cs_shoot_point TRUE ps_frigate_ground/p4)
			)
		0)
	)
)

(script static void test_setpiece_twin
	(switch_zone_set setpiece_twin)
	(sleep_until (= (current_zone_set_fully_active) 23) 1)
	
	(object_teleport_to_ai_point player0  ps_teleports/twin_longsword)
	(wake twin_longsword_loop_start)
	(wake flocks_02_start)
	(wake hill_big_battle)
	;(wake frigate_setup)
	;(wake twin_bfg_start)
	
)

(script static void test_scarabs
	(wake sky_scarab01_start)
	(wake sky_scarab02_start)
	(wake sky_scarab03_start)
	
)


(script static void test_twin_bridge
	;(sleep_until (>= g_twin_obj_control 1) 5)
	;(object_create dm_pelican)
	;(object_create cr_twin_bridge02)
	(objects_attach dm_pelican "" dm_bridge "")
	(device_set_position_track dm_pelican m35_device_position 0)
	
	;wait for playe to enter last space
	;(sleep_until (>= g_twin_obj_control 4) 5)
	
	(wake twin_place_04)
	(set g_bfg01_destroyed TRUE)
	(sleep 200)
	
	(print "bridge incoming")
	(wake md_twin_bridge)
	(wake md_twin_bridge_02)

	(device_animate_position dm_pelican 1.0 40.0 1.0 1.0 TRUE)
	
	(sleep_until (>= (device_get_position dm_pelican) .48) 1)
	
	(print "drop")
	(objects_detach dm_pelican dm_bridge)
	(device_set_position dm_bridge 1)
	
)


(script dormant twin_longsword_loop_start
	 (sleep_until
		(begin
			(device_set_position_track dm_longswords m35_fp1 0)
			(object_create sc_longsword_01)
			(object_create sc_longsword_02)
			(object_create sc_longsword_03)
			(objects_attach dm_longswords "longsword01" sc_longsword_01 "")
			(objects_attach dm_longswords "longsword02" sc_longsword_02 "")
			(objects_attach dm_longswords "longsword03" sc_longsword_03 "")
			(device_animate_position dm_longswords 1.0 15 0 0 TRUE)
			(sleep_until (>= (device_get_position dm_longswords) .5) 1)
			(twin_longsword_fx_start)
			(sleep_until (>= (device_get_position dm_longswords) 1) 1)
			(object_destroy dm_longswords)
			(object_destroy sc_longsword_01)
			(object_destroy sc_longsword_02)
			(object_destroy sc_longsword_03)
			
			(object_create dm_longswords)
			
		0)
	)
)

(script static void test_zealot
	(ai_place sq_facility_zealot)
	(unit_add_equipment sq_facility_zealot profile_zealot TRUE TRUE)
	(ai_berserk sq_facility_zealot TRUE)
)

(script static void test_falcon_rail
	;*
	(f_ai_place_vehicle_deathless sq_falcon_02)
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad sq_falcon_02 0) ps_falcon_02/hover_01)
	(cs_run_command_script (f_ai_get_vehicle_driver sq_falcon_02) cs_falcon_02a)
	(sleep 50)
	(f_ai_place_vehicle_deathless sq_falcon_01)
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad sq_falcon_01 0) ps_falcon_01/hover_01)
	(cs_run_command_script (f_ai_get_vehicle_driver sq_falcon_01) cs_falcon_01a)
	*;
	
	(f_ai_place_vehicle_deathless sq_falcon_02)
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad sq_falcon_02 0) ps_falcon_02/teleport_01b)
	(cs_run_command_script (f_ai_get_vehicle_driver sq_falcon_02) cs_falcon_02b)
	(f_ai_place_vehicle_deathless sq_falcon_01)
	(object_teleport_to_ai_point (ai_vehicle_get_from_squad sq_falcon_01 0) ps_falcon_01/teleport_01b)
	(cs_run_command_script (f_ai_get_vehicle_driver sq_falcon_01) cs_falcon_01b)
	(set g_falcon_obj_control 30)
	
	(vehicle_load_magic (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_g_r" player0)
	;(vehicle_load_magic (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_g_l" player0)
	;(vehicle_load_magic (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_g_r" player0)
	;(vehicle_load_magic (ai_vehicle_get_from_squad sq_falcon_02 0) "falcon_g_l" player0)
	
	; spawn jorge
	(ai_place sq_jorge/falcon)
	(ai_vehicle_enter_immediate gr_jorge (ai_vehicle_get_from_squad sq_falcon_01 0) "falcon_p_r1")
	
	(wake falcon_cov_place)
	
)
