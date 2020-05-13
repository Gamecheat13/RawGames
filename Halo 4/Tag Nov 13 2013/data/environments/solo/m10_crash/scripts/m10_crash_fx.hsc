
script startup m10_crash_fx()
	
	sleep ( 150 );
	print ("::: M10 - FX :::");
	//effect_attached_to_camera_new( environments\solo\m10_crash\fx\particulates\particulates_moving.effect );
	//attach_fx_to_cam();
	//test_fx();
	//fx_arm_didact_screen_test();
	//fx_arm_didact_scan();
end

// -------------------------------------------------------------------------------------------------
// FX: explosion Alley Test - FXVille v-jepalm
// -------------------------------------------------------------------------------------------------
// Explosion Kills Elite and makes corner look impassible

script static void fx_explosion_alley_test()
	print ("::: M10 VFX - Explosion Alley :::");
	effect_new( "environments\solo\m10_crash\fx\explosions\explosion_brk_eal_large.effect", "fx_panel_3");	
	effect_new( "environments\solo\m10_crash\fx\explosions\explosion_brk_eal_large.effect", "fx_panel_10");
	effect_new( "environments\solo\m10_crash\fx\explosions\explosion_brk_eal_large.effect", "fx_panel_6");
	//effect_new( "environments\solo\m10_crash\fx\gas\gas_pipe_lrg.effect", "fx_panel_5");
	
end

// -------------------------------------------------------------------------------------------------
// FX: decompression and recompression in the airlocks
// -------------------------------------------------------------------------------------------------
//



script static void fx_airlock_compression()
	print ("--- airlock compression ---");
	effect_new( "environments\solo\m10_crash\fx\alk_compression_slow.effect", "fx_arl_gas_17");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression_slow.effect", "fx_arl_gas_16");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression_slow.effect", "fx_arl_gas_15");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_14");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_13");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_12");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_11");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_10");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_09");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_08");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_07");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_06");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_05");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_04");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_03");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_02");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl_gas_01");
end

script static void fx_airlock_decompression()
	print ("--- airlock decompression ---");
	effect_new( "environments\solo\m10_crash\fx\alk_decompression.effect", "fx_arl_dc_01");
	sleep(5);
	effect_new( "environments\solo\m10_crash\fx\alk_decompression.effect", "fx_arl_dc_02");
	sleep(5);
	effect_new( "environments\solo\m10_crash\fx\alk_decompression.effect", "fx_arl_dc_03");
	sleep(5);
	effect_new( "environments\solo\m10_crash\fx\alk_decompression.effect", "fx_arl_dc_04");
end


script static void fx_airlock_compression2()
	print ("--- airlock 2 compression ---");
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_01");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_02");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_03");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_04");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_05");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_06");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_07");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_08");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_09");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_10");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_11");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_12");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_13");
	sleep(10);
	effect_new( "environments\solo\m10_crash\fx\alk_compression.effect", "fx_arl2_gas_14");
end

script static void fx_airlock_decompression2()
	print ("--- airlock 2 decompression ---");
	effect_new( "environments\solo\m10_crash\fx\alk_decompression.effect", "fx_arl2_dc_01");
	sleep(5);
	effect_new( "environments\solo\m10_crash\fx\alk_decompression.effect", "fx_arl2_dc_02");
	sleep(5);
	effect_new( "environments\solo\m10_crash\fx\alk_decompression.effect", "fx_arl2_dc_03");
	sleep(5);
	effect_new( "environments\solo\m10_crash\fx\alk_decompression.effect", "fx_arl2_dc_04");
end

// -------------------------------------------------------------------------------------------------
// FX: explosion Alley Test Off
// -------------------------------------------------------------------------------------------------
// Explosion Kills Elite and makes corner look impassible

script static void fx_explosion_alley_test_off()
	print ("::: M10 VFX - Explosion Alley Test :::");
	effect_delete_from_flag( "environments\solo\m10_crash\fx\explosions\explosion_brk_eal_large.effect", "fx_panel_3");	
	effect_delete_from_flag( "environments\solo\m10_crash\fx\explosions\explosion_brk_eal_large.effect", "fx_panel_10");
	effect_delete_from_flag( "environments\solo\m10_crash\fx\explosions\explosion_brk_eal_large.effect", "fx_panel_6");
	//effect_delete_from_flag( "environments\solo\m10_crash\fx\gas\gas_pipe_lrg.effect", "fx_panel_5");
	
end

// -------------------------------------------------------------------------------------------------
// FX: Elite Death
// -------------------------------------------------------------------------------------------------
// Explosion Kills Elite and makes corner look impassible

script static void fx_hall_explosion()
	print ("::: M10 VFX - Elite Death :::");
	effect_new( "environments\solo\m10_crash\fx\fire\fire_corner_burning.effect", "fx_36_fire_hallway_corner");	
	effect_new( "environments\solo\m10_crash\fx\explosions\explosion_36_elite_death.effect", "fx_36_exp_elite_death");
	// Gas
	effect_new( "environments\solo\m10_crash\fx\gas\gas_pipe_lrg.effect", "fx_36_steam_large_01");
	effect_new( "environments\solo\m10_crash\fx\gas\gas_pipe_lrg.effect", "fx_36_steam_large_04");
	effect_new( "environments\solo\m10_crash\fx\gas\gas_pipe.effect", "fx_36_steam_large_02");
	effect_new( "environments\solo\m10_crash\fx\gas\gas_pipe.effect", "fx_36_steam_large_03");
	effect_new( "environments\solo\m10_crash\fx\smoke\smoke_hall_end_thick.effect", "fx_36_smoke_hall_01");
	effect_new( "environments\solo\m10_crash\fx\gas\gas_slow.effect", "fx_panel_1");
	effect_new( "environments\solo\m10_crash\fx\gas\gas_slow.effect", "fx_panel_2");
	effect_new( "environments\solo\m10_crash\fx\gas\gas_slow.effect", "fx_panel_3");
	// Sparks
	effect_new( "environments\solo\m10_crash\fx\sparks\spark_burst_falling_medium.effect", "fx_36_spark_bursting_01");
	effect_new( "environments\solo\m10_crash\fx\sparks\spark_burst_falling_medium.effect", "fx_36_spark_bursting_02");
	effect_new( "environments\solo\m10_crash\fx\sparks\spark_burst_falling_medium.effect", "fx_36_spark_bursting_03");
end

// -------------------------------------------------------------------------------------------------
// FX: Elite Death Off
// -------------------------------------------------------------------------------------------------
// Explosion Kills Elite and makes corner look impassible

script static void fx_hall_explosion_off()
	print ("::: M10 VFX - Elite Death Off :::");
	effect_delete_from_flag( "environments\solo\m10_crash\fx\fire\fire_corner_burning.effect", "fx_36_fire_hallway_corner");	
	effect_delete_from_flag( "environments\solo\m10_crash\fx\explosions\explosion_36_elite_death.effect", "fx_36_exp_elite_death");
	effect_delete_from_flag( "environments\solo\m10_crash\fx\gas\gas_pipe_lrg.effect", "fx_36_steam_large_01");
	effect_delete_from_flag( "environments\solo\m10_crash\fx\gas\gas_pipe.effect", "fx_36_steam_large_02");
	effect_delete_from_flag( "environments\solo\m10_crash\fx\smoke\smoke_hall_end_thick.effect", "fx_36_smoke_hall_01");
	effect_delete_from_flag( "environments\solo\m10_crash\fx\sparks\spark_burst_falling_medium.effect", "fx_36_spark_bursting_01");
	effect_delete_from_flag( "environments\solo\m10_crash\fx\sparks\spark_burst_falling_medium.effect", "fx_36_spark_bursting_02");
end

// -------------------------------------------------------------------------------------------------
// FX: ENGULF
// -------------------------------------------------------------------------------------------------
// Explosion Engulfs Player - Attach to Camera
/*
script static void f_debris_engulf_cam()
	print ("::: M10 - Attach Explosion Engulf FX to the Camera :::");
	effect_attached_to_camera_new( fx\test\jedwards\fud_engulf.effect );
end
*/

// fx_engulf_player - Opening fx_engulf_player - Engulfs player in flames
script static void fx_engulf_player( player p_player, boolean b_active )
	if ( b_active ) then
		dprint( "ENGULF WAS ON HERE!!!" );
		//effect_new_on_object_marker( environments\solo\m10_crash\fx\explosions\vby_explo_player_engulf.effect, p_player, "pedestal" );
	else
		dprint( "ENGULF WAS OFF HERE!!!" );
		//effect_stop_object_marker( environments\solo\m10_crash\fx\explosions\vby_explo_player_engulf.effect, p_player, "pedestal" );
	end
end

// -------------------------------------------------------------------------------------------------
// FX: DROP PODS
// -------------------------------------------------------------------------------------------------
// fx_droppod_cov_squad_<event> - Attaches effect to squad drop pod
script static void fx_droppod_cov_squad_launch( object obj_pod, boolean b_active )
	//dprint( "fx_droppod_cov_squad_launch" );
	
	if ( b_active ) then
		effect_new_on_object_marker( environments\solo\m10_crash\fx\pod\pod_launch.effect, obj_pod, "fx_drop_trail" );
	else
		effect_stop_object_marker( environments\solo\m10_crash\fx\pod\pod_launch.effect, obj_pod, "fx_drop_trail" );
	end
	
end
script static void fx_droppod_cov_squad_trail( object obj_pod, boolean b_active )
	//dprint( "fx_droppod_cov_squad_trail" );
	
	if ( b_active ) then
		effect_new_on_object_marker( environments\solo\m10_crash\fx\pod\pod_trail.effect, obj_pod, "fx_drop_trail" );
	else
		effect_stop_object_marker( environments\solo\m10_crash\fx\pod\pod_trail.effect, obj_pod, "fx_drop_trail" );
	end
	
end
script static void fx_droppod_cov_squad_impact( object obj_pod, boolean b_active )
	//dprint( "fx_droppod_cov_squad_impact" );
	
	if ( b_active ) then
		effect_new_on_object_marker( environments\solo\m10_crash\fx\podbreak\pod_crash01.effect, obj_pod, "fx_impact" );
	else
		effect_stop_object_marker( environments\solo\m10_crash\fx\podbreak\pod_crash01.effect, obj_pod, "fx_impact" );
	end
	
end

// fx_droppod_cov_elite_<event> - Attaches effect to elite drop pod
script static void fx_droppod_cov_elite_launch( object obj_pod, boolean b_active )
	//dprint( "fx_droppod_cov_elite_launch" );
	
	if ( b_active ) then
		effect_new_on_object_marker( environments\solo\m10_crash\fx\pod\pod_launch.effect, obj_pod, "fx_contrail" );
	else
		effect_stop_object_marker( environments\solo\m10_crash\fx\pod\pod_launch.effect, obj_pod, "fx_contrail" );
	end
	
end
script static void fx_droppod_cov_elite_trail( object obj_pod, boolean b_active )
	//dprint( "fx_droppod_cov_elite_trail" );
	
	if ( b_active ) then
		effect_new_on_object_marker( environments\solo\m10_crash\fx\pod\pod_trail_elite.effect, obj_pod, "fx_contrail" );
	else
		effect_stop_object_marker( environments\solo\m10_crash\fx\pod\pod_trail_elite.effect, obj_pod, "fx_contrail" );
	end
	
end
script static void fx_droppod_cov_elite_impact( object obj_pod, boolean b_active )
	//dprint( "fx_droppod_cov_elite_impact" );
	
	if ( b_active ) then
		effect_new_on_object_marker( environments\solo\m10_crash\fx\podbreak\pod_crash01.effect, obj_pod, "fx_impact" );
	else
		effect_stop_object_marker( environments\solo\m10_crash\fx\podbreak\pod_crash01.effect, obj_pod, "fx_impact" );
	end
	
end

// -------------------------------------------------------------------------------------------------
// FX: EXPLOSION ALLEY
// -------------------------------------------------------------------------------------------------
script static void fx_explosionalley_destruction( boolean b_active )
static long l_thread_01 = 0;
static long l_thread_02 = 0;
static long l_thread_03 = 0;
static long l_thread_04 = 0;
static long l_thread_05 = 0;
static long l_thread_06 = 0;
static long l_thread_07 = 0;
static long l_thread_08 = 0;
static long l_thread_09 = 0;
static long l_thread_10 = 0;
static long l_thread_11 = 0;
static long l_thread_12 = 0;
static long l_thread_13 = 0;
static long l_thread_14 = 0;
static long l_thread_15 = 0;
static long l_thread_16 = 0;
static long l_thread_17 = 0;
static long l_thread_18 = 0;
static long l_thread_19 = 0;
static long l_thread_20 = 0;
static long l_thread_21 = 0;
static long l_thread_22 = 0;
static long l_thread_23 = 0;

	if ( b_active ) then
		dprint( "don't run fx_explosionalley_destruction: ACTIVE" );
//		l_thread_01 = thread( fx_explosionalley_attach("maintenance_hall_explosion_01", fx_panel_1) );
//		l_thread_02 = thread( fx_explosionalley_attach("maintenance_hall_explosion_02", fx_panel_2) );
//		l_thread_03 = thread( fx_explosionalley_attach("maintenance_hall_explosion_03", fx_panel_3) );
//		l_thread_04 = thread( fx_explosionalley_attach("maintenance_hall_explosion_04", fx_panel_4) );
//		l_thread_05 = thread( fx_explosionalley_attach("maintenance_hall_explosion_05", fx_panel_5) );
//		l_thread_06 = thread( fx_explosionalley_attach("maintenance_hall_explosion_06", fx_panel_6) );
//		l_thread_07 = thread( fx_explosionalley_attach("maintenance_hall_explosion_07", fx_panel_7) );
//		l_thread_08 = thread( fx_leveleventstatus_effect_new("maintenance_hall_explosion_08", environments\solo\m10_crash\fx\gas\gas_pipe.effect, fx_panel_8) );
//		l_thread_09 = thread( fx_leveleventstatus_effect_new("maintenance_hall_explosion_09", environments\solo\m10_crash\fx\gas\gas_pipe.effect, fx_panel_9) );
//		l_thread_10 = thread( fx_leveleventstatus_effect_new("maintenance_hall_explosion_10", environments\solo\m10_crash\fx\gas\gas_pipe.effect, fx_panel_10) );
//		l_thread_11 = thread( fx_leveleventstatus_effect_new("maintenance_hall_explosion_11", environments\solo\m10_crash\fx\gas\gas_pipe.effect, fx_panel_11) );
//		l_thread_12 = thread( fx_explosionalley_attach("maintenance_hall_explosion_12", fx_panel_12) );
//		l_thread_13 = thread( fx_explosionalley_attach("maintenance_hall_explosion_13", fx_panel_13) );
//		l_thread_14 = thread( fx_explosionalley_attach("maintenance_hall_explosion_14", fx_panel_14) );
//		l_thread_15 = thread( fx_explosionalley_attach("maintenance_hall_explosion_15", fx_panel_15) );
//		l_thread_16 = thread( fx_explosionalley_attach("maintenance_hall_explosion_16", fx_panel_16) );
//		l_thread_17 = thread( fx_explosionalley_attach("maintenance_hall_explosion_17", fx_panel_17) );
//		l_thread_18 = thread( fx_explosionalley_attach("maintenance_hall_explosion_18", fx_panel_18) );
//		l_thread_19 = thread( fx_explosionalley_attach("maintenance_hall_explosion_19", fx_panel_19) );
//		l_thread_20 = thread( fx_explosionalley_attach("maintenance_hall_explosion_20", fx_panel_20) );
//		l_thread_21 = thread( fx_explosionalley_attach("maintenance_hall_explosion_21", fx_panel_21) );
//		l_thread_22 = thread( fx_explosionalley_attach("maintenance_hall_explosion_22", fx_panel_22) );
//		l_thread_23 = thread( fx_explosionalley_attach("maintenance_hall_explosion_23", fx_panel_23) );
	else
		//dprint( "fx_explosionalley_destruction: CLEANUP" );
		kill_thread( l_thread_01 );
		kill_thread( l_thread_02 );
		kill_thread( l_thread_03 );
		kill_thread( l_thread_04 );
		kill_thread( l_thread_05 );
		kill_thread( l_thread_06 );
		kill_thread( l_thread_07 );
		kill_thread( l_thread_08 );
		kill_thread( l_thread_09 );
		kill_thread( l_thread_10 );
		kill_thread( l_thread_11 );
		kill_thread( l_thread_12 );
		kill_thread( l_thread_13 );
		kill_thread( l_thread_14 );
		kill_thread( l_thread_15 );
		kill_thread( l_thread_16 );
		kill_thread( l_thread_17 );
		kill_thread( l_thread_18 );
		kill_thread( l_thread_19 );
		kill_thread( l_thread_20 );
		kill_thread( l_thread_21 );
		kill_thread( l_thread_22 );
		kill_thread( l_thread_23 );
	end

end

script static void fx_explosionalley_attach( string str_event, cutscene_flag flg_loc )

	sleep_until( LevelEventStatus(str_event), 1 );
	begin_random_count(1)
		effect_new( 'environments\solo\m10_crash\fx\gas\gas_pipe.effect', flg_loc );
		effect_new( 'environments\solo\m10_crash\fx\smoke\smoke_smouldering_sparks.effect', flg_loc );
		effect_new( 'environments\solo\m10_crash\fx\sparks\sparks_burst_broken_pipe.effect', flg_loc );
	end
	
end



// -------------------------------------------------------------------------------------------------
// FX: GENERIC TRIGGERS
// -------------------------------------------------------------------------------------------------
script static void fx_leveleventstatus_effect_new( string str_event, effect fx_new, cutscene_flag flg_loc )
	sleep_until( LevelEventStatus(str_event), 1 );
	effect_new( fx_new, flg_loc );
end



script static void test_fx()
	print ("::: test FX :::");
//	effect_new( environments\solo\m10_crash\fx\steam_pipe.effect, fx_pipe01 );
//	effect_new( environments\solo\m10_crash\fx\steam_pipe.effect, fx_pipe02 );
//	effect_new( environments\solo\m10_crash\fx\particulates\particulates_moving.effect, fx_pipe02 );
//	effect_new( environments\solo\m10_crash\fx\steam_pipe.effect, fx_pipe03 );
//	effect_new( environments\solo\m10_crash\fx\spark_sm.effect, fx_damage_point );
//	effect_new( environments\solo\m10_crash\fx\atmosphere_ground.effect, fx_ground01 );
//	effect_new( environments\solo\m10_crash\fx\atmosphere_ground.effect, fx_ground02 );
//	effect_new( environments\solo\m10_crash\fx\cold_breath.effect, fx_cryoglass );
//	effect_new( environments\solo\m10_crash\fx\spark_sm.effect, fx_cryo01_broken01 );
//	effect_new( environments\solo\m10_crash\fx\steam_pipe.effect, fx_cryo01_broken02 );
//	effect_new( environments\solo\m10_crash\fx\steam_pipe.effect, fx_cryo02_broken01 );
//	effect_new( environments\solo\m10_crash\fx\spark_sm.effect, fx_cryo02_broken02 );
//	effect_new( environments\solo\m10_crash\fx\dust_door_open.effect, fx_door );
//	effect_new( environments\solo\m10_crash\fx\bpass_hall_lgt.effect, fx_lensflare_hallway_cryo01 );
//	effect_new( environments\solo\m10_crash\fx\bpass_hall_lgt.effect, fx_lensflare_hallway_cryo02 );
//	effect_new( environments\solo\m10_crash\fx\bpass_hall_lensflare.effect, fx_lensflare_hallway_cryo03 );

//effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maintenance_fire01);
//effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maintenance_fire02);
//effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maintenance_fire03);
//effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maintenance_fire04);
//effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maintenance_fire05);
//effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maintenance_fire06);
//effect_new( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maintenance_fire_base_01);
//effect_new( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maintenance_fire_base_02);
//effect_new( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maintenance_fire_base_03);


	
//	Cryo Chamber Area
	
//	effect_new( environments\solo\m10_crash\fx\steam_down_med_01.effect, fx_steam_ceiling_lg_01 );
//	effect_new( environments\solo\m10_crash\fx\steam_down_med_02.effect, fx_steam_ceiling_lg_02 );
//	effect_new( environments\solo\m10_crash\fx\steam_down_med_02.effect, fx_steam_ceiling_lg_03 );
//	effect_new( environments\solo\m10_crash\fx\steam_down_med_03.effect, fx_steam_ceiling_lg_04 );
//	effect_new( environments\solo\m10_crash\fx\steam_down_med_02.effect, fx_steam_ceiling_lg_05 );
//	effect_new( environments\solo\m10_crash\fx\steam_down_med_03.effect, fx_steam_ceiling_lg_06 );

//	effect_new( environments\solo\m10_crash\fx\steam_side_med_01.effect, fx_steam_ground_side_01 );
//	effect_new( environments\solo\m10_crash\fx\steam_side_med_02.effect, fx_steam_ground_side_02 );

//	effect_new( environments\solo\m10_crash\fx\cold_sparkle_bits_01.effect, fx_cold_icey_bits_01 );
//	effect_new( environments\solo\m10_crash\fx\cold_sparkle_bits_01.effect, fx_cold_icey_bits_02 );

//	effect_new( environments\solo\m10_crash\fx\steam_up_sm_01.effect, fx_steam_up_sm_01 );
//	effect_new( environments\solo\m10_crash\fx\steam_up_sm_02.effect, fx_steam_up_sm_02 );
//	effect_new( environments\solo\m10_crash\fx\steam_up_sm_02.effect, fx_steam_up_sm_03 );
//	effect_new( environments\solo\m10_crash\fx\steam_up_sm_02.effect, fx_steam_up_sm_04 );

//	effect_new( environments\solo\m10_crash\fx\steam_side_med_01.effect, fx_steam_side_med_01 );
//	effect_new( environments\solo\m10_crash\fx\steam_side_med_02.effect, fx_steam_side_med_02 );
//	effect_new( environments\solo\m10_crash\fx\steam_side_med_02.effect, fx_steam_side_med_03 );
//	effect_new( environments\solo\m10_crash\fx\steam_side_med_01.effect, fx_steam_side_med_04 );
//	effect_new( environments\solo\m10_crash\fx\steam_side_sm_01.effect, fx_steam_side_sm_01 );
//	effect_new( environments\solo\m10_crash\fx\steam_side_sm_01.effect, fx_steam_side_sm_02 );

//	effect_new( environments\solo\m10_crash\fx\steam_fill_med_01.effect, fx_steam_fill_card_01 );
//	effect_new( environments\solo\m10_crash\fx\steam_fill_med_01.effect, fx_steam_fill_card_02 );

//	effect_new( environments\solo\m10_crash\fx\steam_down_med_04.effect, fx_steam_down_fall_01 );
//	effect_new( environments\solo\m10_crash\fx\steam_down_med_04.effect, fx_steam_down_fall_02 );
	
//	effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_break_0g.effect, fx_pod_debris01 );
//	effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_break_0g_02.effect, fx_pod_debris02 );
//	effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_break_0g_02.effect, fx_pod_debris03 );
//	effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_escape_0g.effect, fx_air_escape01 );
//	effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_escape_0g_02.effect, fx_air_escape02 );
//	effect_new( environments\solo\m10_crash\fx\podbreak\pod_glass_escape_0g_02.effect, fx_air_escape03 );


// 04_ARMORY
end
script static void fx_maint_fire_spawn()
	print ("<--   Spawn Fire in Maintenance   -->");
	// ground fire
/*	effect_new( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maint_fire01 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maint_fire02 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maint_fire03 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maint_fire04 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maint_fire05 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maint_fire06 );
	// wall fire
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall01 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall02 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall03 );
	//effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall04 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall05 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall06 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall07 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall08 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall09 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall10 );
	effect_new( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall11 );*/
end

script static void fx_maint_fire_delete()
	print ("<--   Terminate Fire in Maintenance   -->");
	// ground fire
/*	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maint_fire01 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maint_fire02 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maint_fire03 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maint_fire04 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maint_fire05 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior.effect, fx_maint_fire06 );
	// wall fire
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall01 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall02 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall03 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall04 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall05 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall06 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall07 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall08 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall09 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall10 );
	effect_delete_from_flag( environments\solo\m10_crash\fx\fire\fire_interior_wall.effect, fx_maint_fire_wall11 );*/
end

script static void attach_fx_to_cam()
	print ("::: attaching FX to the Camera :::");
	effect_attached_to_camera_new( environments\solo\m10_crash\fx\particulates\particulates_moving.effect );
end


script static void fx_arm_didact_scan()
	print ("::: M10 - Didact Scan in the Armory - FX :::");
		//sleep(30 * 3);
		enable_first_person_squish = false;
		effect_new( environments\solo\m10_crash\fx\scan\didact_scan.effect, fx_arm_didact_scan );
		//fx_arm_didat_monitors();
		sleep(30 * 1.2);
		fx_arm_didact_monitors_set01();
		sleep(30 * 1.18);
		fx_arm_didact_monitors_set02();
		//sleep(30 * .005);
		fx_arm_didact_monitors_set03();
		sleep(30 * .1);
		fx_arm_didact_monitors_set04();
		sleep(30 * .15);		//space between monitor geo
		fx_arm_didact_monitors_set05();
		//fx_arm_didact_sparks_set05();
		// 6) side walls C
		sleep(30 * .15);
		fx_arm_didact_monitors_set06();
		// 7) side walls D
		sleep(30 * .15);
		fx_arm_didact_monitors_set07();
		// 8) side walls E
		sleep(30 * .35);		//space between monitor geo
		fx_arm_didact_monitors_set08();
		// 9) side walls F
		sleep(30 * .15);
		fx_arm_didact_monitors_set09();
		// 10) side walls G
		sleep(30 * .2);
		fx_arm_didact_monitors_set10();
		// 11) Back monitor
		sleep(30 * .2);
		fx_arm_didact_monitors_set11();
		enable_first_person_squish = true;
end


script static void fx_arm_didact_monitors_set01()
	print ("--> didact monitors set 1 <--");
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_above_door.effect, fx_arm_grp1_mon041_md_wide );
	//monitors sparks
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark06 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark026 );
	
	
end 

 script static void fx_arm_didact_monitors_set02()
	print ("--> didact monitors set 2 <--");
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_high.effect, fx_arm_grp2_mon07 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_rt.effect, fx_arm_grp2_mon010_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_rt.effect, fx_arm_grp2_mon09_sm_square );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_lf.effect, fx_arm_grp2_mon036_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_lf.effect, fx_arm_grp2_mon037_sm_square );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_tiny.effect, fx_arm_grp2_mon016_sm_square );
	//monitors sparks
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark07 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark08 );
end 

script static void fx_arm_didact_monitors_set03()
	print ("--> didact monitors set 3 <--");
	//monitors sparks
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_centre_scrns.effect, fx_arm_grp3_mon06 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_centre_scrns.effect, fx_arm_grp3_mon03 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_grp3_electric_arc04 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_lg_wide.effect, fx_arm_grp3_mon033_lg_wide );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_wide.effect, fx_arm_grp3_mon038_sm_wide );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_wide.effect, fx_arm_grp3_mon042_sm_wide );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_lg_wide.effect, fx_arm_grp3_mon08_lg_wide );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark033 );

end 

script static void fx_arm_didact_monitors_set04()
	print ("--> didact monitors set 4 <--");
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_lf.effect, fx_arm_grp4_mon011_sm_square );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_lf.effect, fx_arm_grp4_mon012_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_grp4_spark06 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_grp4_spark07 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_rt.effect, fx_arm_grp4_mon035_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_rt.effect, fx_arm_grp4_mon034_sm_square );
	//monitors sparks
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark017 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark018 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark019 );
	
end 


script static void fx_arm_didact_monitors_set05()
	print ("--> didact monitors set 5 <--");
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_rt.effect, fx_arm_grp5_mon014_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_rt.effect, fx_arm_grp5_mon013_sm_square );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_centre_scrns.effect, fx_arm_grp5_mon05 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_centre_scrns.effect, fx_arm_grp5_mon04 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_lf.effect, fx_arm_grp5_mon036_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_lf.effect, fx_arm_grp5_mon037_sm_square );
	//monitors sparks
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark09 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark010 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark011 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark027 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark028 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark029 );
	
end 

script static void fx_arm_didact_monitors_set06()
	print ("--> didact monitors set 6 <--");
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_wide.effect, fx_arm_grp6_mon043_sm_wide );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_lg_wide.effect, fx_arm_grp6_mon015_lg_wide );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_lg_wide.effect, fx_arm_grp6_mon033_lg_wide );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_wide.effect, fx_arm_grp6_mon038_sm_wide );
	
end 

script static void fx_arm_didact_monitors_set07()
	print ("--> didact monitors set 7 <--");
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_lf.effect, fx_arm_grp7_mon016_sm_square );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_lf.effect, fx_arm_grp7_mon017_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_rt.effect, fx_arm_grp7_mon034_sm_square );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_rt.effect, fx_arm_grp7_mon035_md_tall );
	//monitors sparks
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark012 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark013 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark030 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark031 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark032 );
	
end 

script static void fx_arm_didact_monitors_set08()
	print ("--> didact monitors set 8 <--");
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_rt.effect, fx_arm_grp8_mon021_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_rt.effect, fx_arm_grp8_mon022_sm_square );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_lf.effect, fx_arm_grp8_mon036_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_lf.effect, fx_arm_grp8_mon037_sm_square );
	
end 

script static void fx_arm_didact_monitors_set09()
	print ("--> didact monitors set 9 <--");
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_lg_wide.effect, fx_arm_grp9_mon020_lg_wide );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_wide.effect, fx_arm_grp9_mon044_sm_wide );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_lg_wide.effect, fx_arm_grp9_mon033_lg_wide );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_wide.effect, fx_arm_grp9_mon038_sm_wide );
	//monitors sparks
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark014 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark015 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark016 );
	
end 

script static void fx_arm_didact_monitors_set10()
	print ("--> didact monitors set 10 <--");
	
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_lf.effect, fx_arm_grp10_mon019_sm_square );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_lf.effect, fx_arm_grp10_mon018_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_lg_wide.effect, fx_arm_grp10_mon025_lg_wide );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square.effect, fx_arm_grp10_mon027_sm_square );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_rt.effect, fx_arm_grp10_mon035_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_rt.effect, fx_arm_grp10_mon034_sm_square );
	//monitors sparks
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark020 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark021 );
	
	sleep(30 * .1);
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_lf.effect, fx_arm_grp10_mon031_md_tall);
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark024 );
	sleep(30 * .1);
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_lf.effect, fx_arm_grp10_mon032_sm_square );
	sleep(30 * .1);
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_rt.effect, fx_arm_grp10_mon028_sm_square );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark025 );
	sleep(30 * .1);
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_rt.effect, fx_arm_grp10_mon029_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_rt.effect, fx_arm_grp10_mon023_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark022 );
	sleep(30 * .1);
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_lg_wide.effect, fx_arm_grp10_mon030_lg_wide );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_md_tall_lf.effect, fx_arm_grp10_mon026_md_tall );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark023 );
	sleep(30 * .1);
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_wide.effect, fx_arm_grp10_mon040_sm_wide );
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_rt.effect, fx_arm_grp10_mon024_sm_square );
	sleep(30 * .1);
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_lg_wide.effect, fx_arm_grp10_mon025_lg_wide );
	sleep(30 * .1);
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_square_lf.effect, fx_arm_grp10_mon027_sm_square );
	sleep(30 * .1);
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_sm_wide.effect, fx_arm_grp10_mon045_sm_wide );
		

end 

script static void fx_arm_didact_monitors_set11()
	print ("--> didact monitors set 11 <--");
	effect_new( environments\solo\m10_crash\fx\scan\didact_screen_above_door.effect, fx_arm_grp11_mon046_md_wide );

	//monitors sparks
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark01 );
	effect_new( environments\solo\m10_crash\fx\scan\didact_spark_lg.effect, fx_arm_spark038 );
end 

// 04_Armory - Ghost in the Machine

script static void fx_ghost_mon()
	print ("::: M10 - Ghost in the Machine - FX :::");

	sleep(1);
	effect_new (environments\solo\m10_crash\fx\misc\arm_ghost_monitor_01.effect, fx_ghost_mon_01 );
	effect_new (environments\solo\m10_crash\fx\misc\arm_ghost_monitor_02.effect, fx_ghost_mon_02 );
	effect_new (environments\solo\m10_crash\fx\misc\arm_ghost_monitor_03.effect, fx_ghost_mon_03 );

	sleep(33);
	effect_new (environments\solo\m10_crash\fx\sparks\arm_ghost_sparks_04.effect, fx_ghost_mon_01_sparks_01 );
	effect_new (environments\solo\m10_crash\fx\sparks\arm_ghost_sparks_02.effect, fx_ghost_mon_01_sparks_02 );
	effect_new (environments\solo\m10_crash\fx\sparks\arm_ghost_sparks_01.effect, fx_ghost_mon_01_sparks_03 );
	effect_new (environments\solo\m10_crash\fx\sparks\arm_ghost_sparks_04.effect, fx_ghost_mon_01_sparks_04 );

	sleep(34);
	effect_new (environments\solo\m10_crash\fx\sparks\arm_ghost_sparks_01.effect, fx_ghost_mon_02_sparks_01 );
	effect_new (environments\solo\m10_crash\fx\sparks\arm_ghost_sparks_02.effect, fx_ghost_mon_02_sparks_02 );
	effect_new (environments\solo\m10_crash\fx\sparks\arm_ghost_sparks_03.effect, fx_ghost_mon_02_sparks_03 );
	effect_new (environments\solo\m10_crash\fx\sparks\arm_ghost_sparks_04.effect, fx_ghost_mon_02_sparks_04 );

	sleep(35);
	effect_new (environments\solo\m10_crash\fx\sparks\arm_ghost_sparks_01.effect, fx_ghost_mon_03_sparks_01 );
	effect_new (environments\solo\m10_crash\fx\sparks\arm_ghost_sparks_02.effect, fx_ghost_mon_03_sparks_02 );
	effect_new (environments\solo\m10_crash\fx\sparks\arm_ghost_sparks_03.effect, fx_ghost_mon_03_sparks_03 );
	effect_new (environments\solo\m10_crash\fx\sparks\arm_ghost_sparks_04.effect, fx_ghost_mon_03_sparks_04 );

	sleep(8);
	effect_new (environments\solo\m10_crash\fx\sparks\arm_ghost_sparks_02.effect, fx_ghost_mon_03_sparks_04 );

end


/*
script static void fx_test_vehiclebay_destruction_loop()
	//dprint( "::: f_test_vehiclebay_destruction_loop :::" );
	B_vehiclebay_destruction_loop = TRUE;
	B_vehiclebay_destruction_vacuum = FALSE;
	B_vehiclebay_destruction_destroy = FALSE;
	B_debris_FUD_destruction_action = FALSE;
	B_debris_podchase_tube = FALSE;
	R_rumble_intensity_mod = 0.0;
	R_shake_intensity_mod = 0.0;
end
*/




// -------------------------------------------------------------------------------------------------
// FX: ZONE SET: SETUP
// -------------------------------------------------------------------------------------------------
// === fx_zoneset_cin_opening::: Startup and cleanup area FX
script static void fx_zoneset_cin_opening( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( s_zoneset_loading_index ==  S_zoneset_cin_opening ) then
		dprint( "fx_zoneset_cin_opening: STARTUP" );
  // XXX
		fx_camera_set( environments\solo\m10_crash\fx\particulates\particulates_waitless.effect );
	elseif ( s_zoneset_unloading_index == S_zoneset_cin_opening ) then
		dprint( "fx_zoneset_cin_opening: CLEANUP" );
  // XXX
	end
end


// === fx_zoneset_00_cryo_02_hallway_04_armory::: Startup and cleanup area FX
script static void fx_zoneset_00_cryo_02_hallway_04_armory( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( s_zoneset_loading_index ==  S_zoneset_00_cryo_02_hallway_04_armory ) then
		//dprint( "fx_zoneset_00_cryo_02_hallway_04_armory: STARTUP" );
		// XXX
		fx_camera_set( environments\solo\m10_crash\fx\particulates\particulates_moving.effect );
	elseif ( s_zoneset_unloading_index == S_zoneset_00_cryo_02_hallway_04_armory ) then
		dprint( "fx_zoneset_00_cryo_02_hallway_04_armory: CLEANUP" );
		// XXX
	end
end

// === fx_zoneset_06_hallway_08_elevator_10_elevator_12_observatory::: Startup and cleanup area FX
script static void fx_zoneset_06_hallway_08_elevator_10_elevator_12_observatory( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( s_zoneset_loading_index ==  S_zoneset_06_hallway_08_elevator_10_elevator_12_observatory ) then
		//dprint( "fx_zoneset_06_hallway_08_elevator_10_elevator_12_observatory: STARTUP" );
		// XXX
		//fx_camera_set( environments\solo\m10_crash\fx\particulates\particulates_moving.effect );
		fx_camera_set( NONE );
	elseif ( s_zoneset_unloading_index == S_zoneset_06_hallway_08_elevator_10_elevator_12_observatory ) then
		dprint( "fx_zoneset_06_hallway_08_elevator_10_elevator_12_observatory: CLEANUP" );
		// XXX
	end
end

// === fx_zoneset_08_elevator_14_elevator_16_lookout::: Startup and cleanup area FX
script static void fx_zoneset_08_elevator_14_elevator_16_lookout( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( s_zoneset_loading_index ==  S_zoneset_08_elevator_14_elevator_16_lookout ) then
		//dprint( "fx_zoneset_08_elevator_14_elevator_16_lookout: STARTUP" );
		// XXX
		//fx_camera_set( environments\solo\m10_crash\fx\particulates\particulates_moving.effect );
		fx_camera_set( NONE );
	elseif ( s_zoneset_unloading_index == S_zoneset_08_elevator_14_elevator_16_lookout ) then
		dprint( "fx_zoneset_08_elevator_14_elevator_16_lookout: CLEANUP" );
		// XXX
	end
end

// === fx_zoneset_16_lookout_18_elevator_30_beacons::: Startup and cleanup area FX
//script static void fx_zoneset_16_lookout_18_elevator_30_beacons( short s_zoneset_loading_index, short s_zoneset_unloading_index )
//	if ( s_zoneset_loading_index ==  S_zoneset_16_lookout_18_elevator_30_beacons ) then
//		//dprint( "fx_zoneset_16_lookout_18_elevator_30_beacons: STARTUP" );
//		// XXX
//		//fx_camera_set( environments\solo\m10_crash\fx\particulates\particulates_moving.effect );
//		fx_camera_set( NONE );
//	elseif ( s_zoneset_unloading_index == S_zoneset_16_lookout_18_elevator_30_beacons ) then
//		dprint( "fx_zoneset_16_lookout_18_elevator_30_beacons: CLEANUP" );
//		// XXX
//	end
//end

// === fx_zoneset_16_lookout_18_elevator_20_cafe::: Startup and cleanup area FX
script static void fx_zoneset_16_lookout_18_elevator_20_cafe( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( s_zoneset_loading_index ==  S_zoneset_16_lookout_18_elevator_20_cafe ) then
		//dprint( "fx_zoneset_16_lookout_18_elevator_20_cafe: STARTUP" );
		// XXX
		//fx_camera_set( environments\solo\m10_crash\fx\particulates\particulates_moving.effect );
		fx_camera_set( NONE );
	elseif ( s_zoneset_unloading_index == S_zoneset_16_lookout_18_elevator_20_cafe ) then
		dprint( "fx_zoneset_16_lookout_18_elevator_20_cafe: CLEANUP" );
		// XXX
	end
end

// === fx_zoneset_24_corner_26_box_28_airlock::: Startup and cleanup area FX
script static void fx_zoneset_24_corner_26_box_28_airlock( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( s_zoneset_loading_index ==  S_zoneset_24_corner_26_box_28_airlock ) then
		//dprint( "fx_zoneset_24_corner_26_box_28_airlock: STARTUP" );
		// XXX
		//fx_camera_set( environments\solo\m10_crash\fx\particulates\particulates_moving.effect );
		fx_camera_set( NONE );
	elseif ( s_zoneset_unloading_index == S_zoneset_24_corner_26_box_28_airlock ) then
		dprint( "fx_zoneset_24_corner_26_box_28_airlock: CLEANUP" );
		// XXX
	end
end

// === fx_zoneset_28_airlock_30_beacons::: Startup and cleanup area FX
script static void fx_zoneset_28_airlock_30_beacons( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( s_zoneset_loading_index ==  S_zoneset_28_airlock_30_beacons ) then
		//dprint( "fx_zoneset_28_airlock_30_beacons: STARTUP" );
		// XXX
		fx_camera_set( NONE );
	elseif ( s_zoneset_unloading_index == S_zoneset_28_airlock_30_beacons ) then
		dprint( "fx_zoneset_28_airlock_30_beacons: CLEANUP" );
		// XXX
	end
end

// === fx_zoneset_28_airlock_32_broken::: Startup and cleanup area FX
//script static void fx_zoneset_28_airlock_32_broken( short s_zoneset_loading_index, short s_zoneset_unloading_index )
//	if ( s_zoneset_loading_index ==  S_zoneset_28_airlock_32_broken ) then
//		//dprint( "fx_zoneset_28_airlock_32_broken: STARTUP" );
//		// XXX
//		fx_camera_set( NONE );
//	elseif ( s_zoneset_unloading_index == S_zoneset_28_airlock_32_broken ) then
//		dprint( "fx_zoneset_28_airlock_32_broken: CLEANUP" );
//		// XXX
//	end
//end

// === fx_zoneset_32_broken_34_maintenance::: Startup and cleanup area FX
script static void fx_zoneset_32_broken_34_maintenance( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( s_zoneset_loading_index ==  S_zoneset_32_broken_34_maintenance ) then
		//dprint( "fx_zoneset_32_broken_34_maintenance: STARTUP" );
		fx_maint_fire_spawn();
	  // XXX
  	// XXX
		//fx_camera_set( environments\solo\m10_crash\fx\particulates\particulates_moving.effect );
		fx_camera_set( NONE );
	elseif ( s_zoneset_unloading_index == S_zoneset_32_broken_34_maintenance ) then
		//dprint( "fx_zoneset_32_broken_34_maintenance: CLEANUP" );
		fx_maint_fire_delete();
  	// XXX
	end
end

// === fx_zoneset_36_hallway_38_vehicle_40_debris::: Startup and cleanup area FX
script static void fx_zoneset_36_hallway_38_vehicle_40_debris( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( s_zoneset_loading_index ==  S_zoneset_36_hallway_38_vehicle_40_debris ) then
		//dprint( "fx_zoneset_36_hallway_38_vehicle_40_debris: STARTUP" );
  // XXX
		//fx_camera_set( environments\solo\m10_crash\fx\particulates\particulates_moving.effect );
		fx_camera_set( NONE );
	elseif ( s_zoneset_unloading_index == S_zoneset_36_hallway_38_vehicle_40_debris ) then
		dprint( "fx_zoneset_36_hallway_38_vehicle_40_debris: CLEANUP" );
  // XXX
	end
end

// === fx_zoneset_40_debris_42_skybox::: Startup and cleanup area FX
script static void fx_zoneset_40_debris_42_skybox( short s_zoneset_loading_index, short s_zoneset_unloading_index )
	if ( s_zoneset_loading_index ==  S_zoneset_40_debris_42_skybox ) then
		//dprint( "fx_zoneset_40_debris_42_skybox: STARTUP" );
  // XXX
		// XXX USING M90 EFFECT
		fx_camera_set( environments\solo\m90_sacrifice\fx\particulates\particulate_space.effect );
	elseif ( s_zoneset_unloading_index == S_zoneset_40_debris_42_skybox ) then
		dprint( "fx_zoneset_40_debris_42_skybox: CLEANUP" );
  // XXX
	end
end


script static void f_debris_whiteout_player( player p_player, boolean b_active )

	if ( b_active ) then
		effect_attached_to_camera_new( environments\solo\m10_crash\fx\explosions\vby_explo_player_overexpose.effect );
		//effect_new_on_object_marker( 'environments\solo\m10_crash\fx\explosions\vby_explo_player_overexpose.effect', p_player, "pedestal" );
	else
		effect_attached_to_camera_new( environments\solo\m10_crash\fx\explosions\vby_explo_player_overexpose_reverse.effect );
		effect_attached_to_camera_stop( environments\solo\m10_crash\fx\explosions\vby_explo_player_overexpose.effect );
		//effect_new_on_object_marker( 'environments\solo\m10_crash\fx\explosions\vby_explo_player_overexpose_reverse.effect', p_player, "pedestal" );
		//effect_stop_object_marker( 'environments\solo\m10_crash\fx\explosions\vby_explo_player_overexpose.effect', p_player, "pedestal" );
	end
	
end



// -------------------------------------------------------------------------------------------------
// FX: CAMERA
// -------------------------------------------------------------------------------------------------
// VARIABLES
global boolean B_fx_camera_paused = FALSE;
global effect FX_camera_last = NONE;
global effect FX_camera_paused = NONE;

// FUNCTIONS
// === fx_camera_set::: Sets the camera FX and cleans up any fx that may be running; while paused will only store new camera FX requests and then re-add them when unpaused
script static void fx_camera_set( effect fx_camera_new )

	if ( not B_fx_camera_paused ) then
		// make sure this is a new FX
		if ( fx_camera_new != fx_camera_last ) then
		
			// start the new effect
			if ( fx_camera_new != NONE ) then
				effect_attached_to_camera_new( fx_camera_new );
			end
		
			// remove the old effect
			if ( fx_camera_last != NONE ) then
				effect_attached_to_camera_stop( fx_camera_last );
			end
			
			// store the camera FX for the next time it changes
			fx_camera_last = fx_camera_new;
		end
	else
		// store the fx for later
		FX_camera_paused = fx_camera_new;
	end

end

// === fx_camera_pause::: Pauses or unpauses camera FX; if TRUE will stores and clear current FX from the camera, FALSE will restore FX
script static void fx_camera_pause( boolean b_pause )

	if ( B_fx_camera_paused != b_pause ) then
	
		if ( b_pause ) then
		
			// store the last fx in the paused
			FX_camera_paused = FX_camera_last;
			// set fx to none
			fx_camera_set( NONE );
			
		else
		
			// restore the paused camera FX
			fx_camera_set( FX_camera_paused );
			// clear the paused fx stored
			FX_camera_paused = NONE;
			
		end
	
		B_fx_camera_paused = b_pause;
	end

end

// =======================================
// Elevator Attached Lens Flares
// =======================================

script static void fx_elevator_flares()
                dprint("play_fx_elevator_attached_flares()");

                effect_new_on_object_marker( environments\solo\m10_crash\fx\lens_flare\elevator_light_cone_01.effect, elevator_1_platform, 

lightcone01);
                effect_new_on_object_marker( environments\solo\m10_crash\fx\lens_flare\elevator_light_cone_01.effect, elevator_1_platform, 

lightcone02);
                effect_new_on_object_marker( environments\solo\m10_crash\fx\lens_flare\elevator_light_cone_01.effect, elevator_1_platform, 

lightcone03);
                effect_new_on_object_marker( environments\solo\m10_crash\fx\lens_flare\elevator_light_cone_01.effect, elevator_1_platform, 

lightcone04);
                effect_new_on_object_marker( environments\solo\m10_crash\fx\lens_flare\elevator_light_cone_01.effect, elevator_1_platform, 

lightcone05);
                effect_new_on_object_marker( environments\solo\m10_crash\fx\lens_flare\elevator_light_cone_01.effect, elevator_1_platform, 

lightcone06);
end

