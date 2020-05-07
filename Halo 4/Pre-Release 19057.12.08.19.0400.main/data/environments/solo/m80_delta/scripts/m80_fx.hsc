//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434
//
// Mission: 					m80_delta_fx
//										
//34343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434343434334343434343434343434343434343434343434343434343434343434


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** GLOBALS ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


// General editable values

global real r_light_transition_time = 0.5;


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** START-UP ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


script startup m80_delta_fx()

	sleep_s( 1.0 );
	
end


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** HUD EFFECTS ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


//script static void f_fx_hud_lite()

//	dprint( "Switching to lite HUD" );

//end


//script static void f_fx_hud_full()

//	dprint( "Switching to normal HUD" );

//end


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** DYNAMIC LIGHTS ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


script static void f_dynamic_light_green_on( object the_light_location )

	effect_new_on_object_marker( "fx\library\light\light_green\light_green.effect", the_light_location, "" );

end


script static void f_dynamic_light_red_on( object the_light_location )

	effect_new_on_object_marker( "fx\library\light\light_red\light_red.effect", the_light_location, "" );

end


script static void f_dynamic_light_red_to_green( object the_light_location )

	effect_stop_object_marker( "fx\library\light\light_red\light_red.effect", the_light_location, "" );
	sleep_s( r_light_transition_time );
	effect_stop_object_marker( "fx\library\light\light_green\light_green.effect", the_light_location, "" );
	effect_new_on_object_marker( "fx\library\light\light_green\light_green.effect", the_light_location, "" );

end


script static void f_dynamic_light_green_to_red( object the_light_location )

	effect_stop_object_marker( "fx\library\light\light_green\light_green.effect", the_light_location, "" );
	sleep_s( r_light_transition_time );
	effect_stop_object_marker( "fx\library\light\light_red\light_red.effect", the_light_location, "" );
	effect_new_on_object_marker( "fx\library\light\light_red\light_red.effect", the_light_location, "" );

end


script static void f_dynamic_light_off( object the_light_location )

	effect_stop_object_marker( "fx\library\light\light_green\light_green.effect", the_light_location, "" );
	effect_stop_object_marker( "fx\library\light\light_red\light_red.effect", the_light_location, "" );

end


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** SCREEN FX AND FADES ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


script static void f_FX_start_low_G_particles()

	//dprint( "Starting floaty zero-G particle effect" );
	effect_attached_to_camera_new( environments\solo\m80_delta\fx\particulates.effect );

end


script static void f_FX_stop_low_G_particles()

	//dprint( "Stopping floaty zero-G particle effect" );
	effect_attached_to_camera_stop( environments\solo\m80_delta\fx\particulates.effect );

end


// ==========================================================================================================================================================
// ==========================================================================================================================================================
// *** PARTICLE FX ***
// ==========================================================================================================================================================
// ==========================================================================================================================================================


// ==========================================================================================================================================================
// *** SCANNING ***
// ==========================================================================================================================================================


//script static void f_fx_exterior_scan( )

//	dprint( "" );

//end


script static void f_fx_interior_scan( cutscene_flag the_location )

	effect_new( environments\solo\m10_crash\fx\scan\didact_scan.effect, the_location );

end

/*
script static void f_fx_composer_scan()
	effect_new( environments\solo\m80_delta\fx\scan\dscan_atrium.effect, fx_atrium_didact_scan_1 );

	

end
*/

// ==========================================================================================================================================================
// *** CRASH ***
// ==========================================================================================================================================================


script static void f_fx_crash_start()
	
	effect_new_at_ai_point( "fx\reach\fx_library\ambient\sparks\sparks_small_frequent\sparks_small_frequent.effect_scenery", spark_fx_01.p0 );

end


// ==========================================================================================================================================================
// *** AIRLOCKS ***
// ==========================================================================================================================================================

script static effect f_FX_airlock_transition()			// THIS IS THE ONE I'M USING NOW, MIGHT BE ABLE TO CLEAR OUT OTHERS UNLESS THEY ARE USED ELSEWHERE - TWF
	'environments\solo\m80_delta\fx\atmosphere\door_airlock_explode_atmo.effect';
end

script static effect f_FX_airlock_compression()
	'environments\solo\m10_crash\fx\alk_compression.effect';
end
script static effect f_FX_airlock_decompression()
	'environments\solo\m10_crash\fx\alk_decompression.effect';
end 

script static void f_FX_airlock_compression_flag( cutscene_flag the_location )

	effect_new( f_FX_airlock_compression(), the_location );

end


script static void f_FX_airlock_decompression_flag( cutscene_flag the_location )

	//TODO: This FX currently loops without stopping; needs fixing
	effect_new( f_FX_airlock_decompression(), the_location );

end


script static void f_FX_airlock_explosivedecompression()

	//TODO: Have to determine what FX are needed this event
	sleep_s( 1.0 );

end


// ==========================================================================================================================================================
// *** AIRLOCK ONE ***
// ==========================================================================================================================================================
/*
// NOW INTEGRATED INTO MISSION SCRIPT - TWF

script static void f_FX_compress_airlock_one_door_1()

	f_FX_airlock_compression_flag( flag_fx_airlock_one_door_1_01 );
	f_FX_airlock_compression_flag( flag_fx_airlock_one_door_1_02 );
	f_FX_airlock_compression_flag( flag_fx_airlock_one_door_1_03 );
	f_FX_airlock_compression_flag( flag_fx_airlock_one_door_1_04 );

end


script static void f_FX_decompress_airlock_one_door_1()

	f_FX_airlock_decompression_flag( flag_fx_airlock_one_door_1_01 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_one_door_1_02 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_one_door_1_03 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_one_door_1_04 );

end


script static void f_FX_compress_airlock_one_door_2()

	f_FX_airlock_compression_flag( flag_fx_airlock_one_door_2_01 );
	f_FX_airlock_compression_flag( flag_fx_airlock_one_door_2_02 );
	f_FX_airlock_compression_flag( flag_fx_airlock_one_door_2_03 );
	f_FX_airlock_compression_flag( flag_fx_airlock_one_door_2_04 );

end


script static void f_FX_decompress_airlock_one_door_2()

	f_FX_airlock_decompression_flag( flag_fx_airlock_one_door_2_01 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_one_door_2_02 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_one_door_2_03 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_one_door_2_04 );

end


script static void f_FX_compress_airlock_one_door_3()

	f_FX_airlock_compression_flag( flag_fx_airlock_one_door_3_01 );
	f_FX_airlock_compression_flag( flag_fx_airlock_one_door_3_02 );
	f_FX_airlock_compression_flag( flag_fx_airlock_one_door_3_03 );
	f_FX_airlock_compression_flag( flag_fx_airlock_one_door_3_04 );

end


script static void f_FX_decompress_airlock_one_door_3()

	f_FX_airlock_decompression_flag( flag_fx_airlock_one_door_3_01 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_one_door_3_02 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_one_door_3_03 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_one_door_3_04 );

end


// ==========================================================================================================================================================
// *** AIRLOCK TWO ***
// ==========================================================================================================================================================


script static void f_FX_compress_airlock_two_door_1()

	f_FX_airlock_compression_flag( flag_fx_airlock_two_door_1_01 );
	f_FX_airlock_compression_flag( flag_fx_airlock_two_door_1_02 );
	f_FX_airlock_compression_flag( flag_fx_airlock_two_door_1_03 );
	f_FX_airlock_compression_flag( flag_fx_airlock_two_door_1_04 );

end


script static void f_FX_decompress_airlock_two_door_1()

	f_FX_airlock_decompression_flag( flag_fx_airlock_two_door_1_01 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_two_door_1_02 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_two_door_1_03 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_two_door_1_04 );

end


script static void f_FX_compress_airlock_two_door_2()

	f_FX_airlock_compression_flag( flag_fx_airlock_two_door_2_01 );
	f_FX_airlock_compression_flag( flag_fx_airlock_two_door_2_02 );
	f_FX_airlock_compression_flag( flag_fx_airlock_two_door_2_03 );
	f_FX_airlock_compression_flag( flag_fx_airlock_two_door_2_04 );

end


script static void f_FX_decompress_airlock_two_door_2()

	f_FX_airlock_decompression_flag( flag_fx_airlock_two_door_2_01 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_two_door_2_02 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_two_door_2_03 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_two_door_2_04 );

end


script static void f_FX_compress_airlock_two_door_3()

	f_FX_airlock_compression_flag( flag_fx_airlock_two_door_3_01 );
	f_FX_airlock_compression_flag( flag_fx_airlock_two_door_3_02 );
	f_FX_airlock_compression_flag( flag_fx_airlock_two_door_3_03 );
	f_FX_airlock_compression_flag( flag_fx_airlock_two_door_3_04 );

end


script static void f_FX_decompress_airlock_two_door_3()

	f_FX_airlock_decompression_flag( flag_fx_airlock_two_door_3_01 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_two_door_3_02 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_two_door_3_03 );
	f_FX_airlock_decompression_flag( flag_fx_airlock_two_door_3_04 );

end
*/

// ==========================================================================================================================================================
// *** LOOKOUT-GUNS-ATRIUM RETURN "T-JUNCTION" AIRLOCK ***
// ==========================================================================================================================================================


script static void f_FX_compress_junction()

	f_FX_airlock_compression_flag( flag_fx_tjunction_01 );
	f_FX_airlock_compression_flag( flag_fx_tjunction_02 );
	f_FX_airlock_compression_flag( flag_fx_tjunction_03 );
	f_FX_airlock_compression_flag( flag_fx_tjunction_04 );
	f_FX_airlock_compression_flag( flag_fx_tjunction_05 );
	f_FX_airlock_compression_flag( flag_fx_tjunction_06 );
	f_FX_airlock_compression_flag( flag_fx_tjunction_07 );
	f_FX_airlock_compression_flag( flag_fx_tjunction_08 );
	f_FX_airlock_compression_flag( flag_fx_tjunction_09 );
	f_FX_airlock_compression_flag( flag_fx_tjunction_10 );
	f_FX_airlock_compression_flag( flag_fx_tjunction_11 );
	f_FX_airlock_compression_flag( flag_fx_tjunction_12 );

end


script static void f_FX_decompress_junction()

	f_FX_airlock_decompression_flag( flag_fx_tjunction_01 );
	f_FX_airlock_decompression_flag( flag_fx_tjunction_02 );
	f_FX_airlock_decompression_flag( flag_fx_tjunction_03 );
	f_FX_airlock_decompression_flag( flag_fx_tjunction_04 );
	f_FX_airlock_decompression_flag( flag_fx_tjunction_05 );
	f_FX_airlock_decompression_flag( flag_fx_tjunction_06 );
	f_FX_airlock_decompression_flag( flag_fx_tjunction_07 );
	f_FX_airlock_decompression_flag( flag_fx_tjunction_08 );
	f_FX_airlock_decompression_flag( flag_fx_tjunction_09 );
	f_FX_airlock_decompression_flag( flag_fx_tjunction_10 );
	f_FX_airlock_decompression_flag( flag_fx_tjunction_11 );
	f_FX_airlock_decompression_flag( flag_fx_tjunction_12 );

end


// =================================================================================================
// *** ATRIUM DESTROYED ***
// =================================================================================================

// Effects used
// environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_console_01.effect
// environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect
// environments\solo\m80_delta\fx\destruction\atr_dmg_elev_smash_01.effect
// environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect
// environments\solo\m80_delta\fx\atmosphere\atr_dmg_elev_steam_leak_lg.effect
// environments\solo\m80_delta\fx\atmosphere\atr_dmg_elev_steam_leak_sm.effect 

// Markers used
// fx_elevator_dmg_glass_top 
// fx_elevator_dmg_glass_bottom 
// fx_elevator_dmg_sm_02 
// fx_elevator_dmg_sm_01 
// fx_elevator_spark_wall_rt_03 
// fx_elevator_spark_wall_rt_02 
// fx_elevator_spark_wall_rt_01 
// fx_elevator_sparks_ceil_01 
// fx_elevator_spark_mon_02 
// fx_elevator_spark_mon_01 
// fx_console_spark_01 
// fx_console_spark_02 
// fx_console_spark_03 
// fx_elevator_spark_wall_lf_01 
// fx_elevator_steam_flr_01 
// fx_elevator_steam_flr_02
// fx_elevator_steam_ceil_rt_02 
// fx_elevator_steam_ceil_rt_01 

// Device machines:
// control_room_elevator "dm_elevator" (environments\solo\m80_delta\device_machines\control_room_elevator\control_room_elevator.device_machine)
// 
// Scenery Objects:
// m80_atrium_destoryed_static_geo "ad_static_geo" (environments\solo\m80_delta\scenery\m80_atrium_destoryed_static_geo\m80_atrium_destoryed_static_geo.scenery)
// m80_atrium_destroyed_object "ad_object" (environments\solo\m80_delta\scenery\m80_atrium_destroyed_object\m80_atrium_destroyed_object.scenery)
// m80_atrium_wall "ad_wall" (environments\solo\m80_delta\scenery\m80_atrium_wall\m80_atrium_wall.scenery)
// didactship "didactship" (objects\cinematics\didactship\didactship.scenery)


// Atrium Ambiance – Triggers at startup
script static void f_fx_atrium_ambiance()
	//dprint("f_fx_atrium_ambiance()");

	// This fixes a bug where the lens flare effect attached to the environment marker of the 10_atrium bsp
	// doesn't go away when the bsp is unloaded. MN-67613
	effect_kill_from_flag(environments\solo\m80_delta\fx\energy\atr_dmg_composer_energy_center.effect, fx_composer_center);
	
//	Composer
	effect_new_on_object_marker(environments\solo\m80_delta\fx\energy\atr_dmg_composer_energy_center.effect, ad_object, fx_comp_eye);


// Didact Ship
	effect_new_on_object_marker(environments\solo\m80_delta\fx\energy\atr_dmg_didact_eye_flare.effect, didactship, fx_didact_eye);
	effect_new_on_object_marker(environments\solo\m80_delta\fx\energy\atr_dmg_didact_sm_flare.effect, didactship, fx_didact_laser);

//	Mini Composers
	effect_new( environments\solo\m80_delta\fx\energy\atr_dmg_mini_comp_energy_btm.effect, fx_composer_mini_a_01 );
	effect_new( environments\solo\m80_delta\fx\energy\atr_dmg_mini_comp_energy_top.effect, fx_composer_mini_a_04 );
	effect_new( environments\solo\m80_delta\fx\energy\atr_dmg_mini_comp_energy_btm.effect, fx_composer_mini_b_01 );
	effect_new( environments\solo\m80_delta\fx\energy\atr_dmg_mini_comp_energy_top.effect, fx_composer_mini_b_04 );
	effect_new( environments\solo\m80_delta\fx\energy\atr_dmg_mini_comp_energy_btm.effect, fx_composer_mini_c_01 );
	effect_new( environments\solo\m80_delta\fx\energy\atr_dmg_mini_comp_energy_top.effect, fx_composer_mini_c_04 );

// Rising Rocks	
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_rocks_01.effect, fx_rising_rocks_sm_02 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_rocks_01.effect, fx_rising_rocks_sm_05 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_rocks_01.effect, fx_rising_rocks_sm_07 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_rocks_01.effect, fx_rising_rocks_sm_12 );
	
//	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_rocks_02.effect, fx_rising_rocks_sm_01 );
//	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_rocks_02.effect, fx_rising_rocks_sm_03 );
//	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_rocks_02.effect, fx_rising_rocks_sm_04 );
//	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_rocks_02.effect, fx_rising_rocks_sm_06 );
//	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_rocks_02.effect, fx_rising_rocks_sm_08 );
//	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_rocks_02.effect, fx_rising_rocks_sm_09 );
//	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_rocks_02.effect, fx_rising_rocks_sm_10 );
//	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_rocks_02.effect, fx_rising_rocks_sm_11 );
end


// Rising Debris 01 – First stage of rising rocks and debris bits
script static void f_fx_rising_debris_01()
	dprint("f_fx_rising_debris_01()");
end


// Atrium Destruction 01 – Triggers just before the crane swings, as the atrium exterior buckles a bit
script static void f_fx_atrium_destroy_01()
	//dprint("f_fx_atrium_destroy_01()");

	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_crane_blast_lg_01.effect, fx_bridge_lf_dmg_01 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_crane_blast_sm_01.effect, fx_bridge_lf_dmg_02 );
	sleep(30);
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_crane_blast_lg_01.effect, fx_bridge_bk_dmg_01 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_crane_blast_sm_01.effect, fx_bridge_bk_dmg_02 );
	sleep(20);
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_crane_blast_sm_01.effect, fx_bridge_rt_dmg_01 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_crane_blast_lg_01.effect, fx_bridge_rt_dmg_02 );
end


// Lights Power Down – When the bridge starts to bust loose 
script static void f_fx_power_down()
	dprint("f_fx_power_down()");
end


// Emergency Lights – A short delay after the main lights power down
script static void f_fx_emergency_lights()
	//dprint("f_fx_emergency_lights()");

	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_a_01 );
	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_a_02 );

	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_b_01 );
	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_b_02 );
	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_b_03 );
	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_b_04 );

	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_c_01 );
	effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_c_02 );
	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_c_03 );
	effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_c_04 );

	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_d_01 );
	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_d_02 );
	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_d_03 );
	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_d_04 );	

	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_e_01 );
	effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_e_02 );
	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_e_03 );
	effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_e_04 );

	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_f_01 );
	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_f_02 );
	//effect_new( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_f_03 );
end


// Atrium Destruction 02 – When the whole back face of the atrium exterior gets destroyed, revealing the Didact
script static void f_fx_atrium_destroy_02()
	//dprint("f_fx_atrium_destroy_02()");

//	Back Wall Destruction from Didact Ship
	sleep(30);
//	Kill Emergency Lights on the Damaged Wall Hole
	//effect_kill_from_flag( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_e_01 );
	effect_kill_from_flag( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_e_02 );
	//effect_kill_from_flag( environments\solo\m80_delta\fx\lights\atr_dmg_emerg_light.effect, fx_flashing_light_e_03 );

//	Wall Destruction
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_wall_blast_lg_01.effect, fx_wall_destruction_01 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_wall_blast_lg_01.effect, fx_wall_destruction_02 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_wall_blast_sm_01.effect, fx_wall_destruction_03 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_wall_blast_sm_01.effect, fx_wall_destruction_04 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_wall_blast_sm_01.effect, fx_wall_destruction_05 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_wall_blast_lg_01.effect, fx_wall_destruction_06 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_wall_blast_sm_01.effect, fx_wall_destruction_07 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_wall_blast_lg_01.effect, fx_wall_destruction_08 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_wall_blast_lg_01.effect, fx_wall_destruction_09 );
	
//	Wall Debris from sides of Elevator pulling towards Didact Ship
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_wall_suck_debris.effect, fx_wall_dmg_debris_suck_01 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_wall_suck_debris.effect, fx_wall_dmg_debris_suck_02 );
end


// Rising Debris 02 – When the Didact sends an energy beam towards the Composer, just before it starts to shift around and lift up
script static void f_fx_rising_debris_02()
	//dprint("f_fx_rising_debris_02()");

//	Composer
	//effect_new_on_object_marker(environments\solo\m80_delta\fx\energy\atr_dmg_composer_energy_big.effect, ad_object, fx_comp_center);

//	Rising Debris
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_debris_sm_01.effect, fx_rising_debris_09 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_debris_sm_01.effect, fx_rising_debris_14 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_debris_sm_02.effect, fx_rising_debris_08 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_debris_lg_01.effect, fx_rising_debris_05 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_debris_lg_01.effect, fx_rising_debris_13 );
	effect_new( environments\solo\m80_delta\fx\destruction\atr_dmg_rising_debris_lg_02.effect, fx_rising_debris_04 );

//	Didact Ship
	effect_new_on_object_marker(environments\solo\m80_delta\fx\energy\atr_dmg_didact_tractor_energy.effect, didactship, fx_didact_eye);
end


// Composer Release – When the Composer breaks free from the ground and begins to rise
script static void f_fx_composer_release()
	//dprint("f_fx_composer_release()");

	effect_new_on_object_marker(environments\solo\m80_delta\fx\energy\atr_dmg_didact_beam.effect, ad_object, fx_comp_center);
end




///// ELEVATOR
// Plays the impact effects when the crane hits the elevator
script static void f_FX_atr_elevator_impact_1()
	//dprint("f_FX_atr_elevator_impact_1() - Playing elevator sparks and glass");
	
	// The metal cross beam in the window breaks, throwing sparks
	effect_new_on_object_marker(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, dm_elevator, fx_elevator_dmg_sm_02);
	effect_new_on_object_marker(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, dm_elevator, fx_elevator_dmg_sm_01);
	
	// The window glass breaks
	effect_new_on_object_marker(environments\solo\m80_delta\fx\destruction\atr_dmg_elev_smash_01.effect, dm_elevator, fx_elevator_dmg_glass_bottom);
	effect_new_on_object_marker(environments\solo\m80_delta\fx\destruction\atr_dmg_elev_smash_01.effect, dm_elevator, fx_elevator_dmg_glass_top);
end


// Plays the sparks that follow the crane impact on the elevator
script static void f_FX_atr_elevator_sparks_wave_1()
	//dprint("f_FX_atr_elevator_sparks_wave_1() - Playing sparks wave");
	effect_new_on_object_marker(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, dm_elevator, fx_elevator_spark_wall_rt_01);
	effect_new_on_object_marker(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, dm_elevator, fx_elevator_spark_wall_rt_02);
	effect_new_on_object_marker(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, dm_elevator, fx_elevator_spark_wall_rt_03);
	effect_new_on_object_marker(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, dm_elevator, fx_elevator_spark_wall_lf_01);
	effect_new_on_object_marker(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_lg_01.effect, dm_elevator, fx_elevator_sparks_ceil_01);
end


// Plays the sparks from the console following the crane impact on the elevator
script static void f_FX_atr_elevator_cons_sparks_1()
	//dprint("f_FX_atr_elevator_cons_sparks_1() - Playing console sparks");
	effect_new_on_object_marker(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_console_01.effect, dm_elevator, fx_console_spark_01);
	effect_new_on_object_marker(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_console_01.effect, dm_elevator, fx_console_spark_02);
	effect_new_on_object_marker(environments\solo\m80_delta\fx\sparks\atr_dmg_sparks_console_01.effect, dm_elevator, fx_console_spark_03);
end


// Plays the steam/gas leaks following the crane impact on the elevator
script static void f_FX_atr_elevator_steam_leaks_1()
	//dprint("f_FX_atr_elevator_steam_leaks_1() - Playing stteam"); 
	effect_new_on_object_marker(environments\solo\m80_delta\fx\atmosphere\atr_dmg_elev_steam_leak_sm.effect, dm_elevator, fx_elevator_steam_flr_01);
	effect_new_on_object_marker(environments\solo\m80_delta\fx\atmosphere\atr_dmg_elev_steam_leak_lg.effect, dm_elevator, fx_elevator_steam_flr_02);
	effect_new_on_object_marker(environments\solo\m80_delta\fx\atmosphere\atr_dmg_elev_steam_leak_sm.effect, dm_elevator, fx_elevator_steam_ceil_rt_02);
	effect_new_on_object_marker(environments\solo\m80_delta\fx\atmosphere\atr_dmg_elev_steam_leak_sm.effect, dm_elevator, fx_elevator_steam_ceil_rt_01);
end








