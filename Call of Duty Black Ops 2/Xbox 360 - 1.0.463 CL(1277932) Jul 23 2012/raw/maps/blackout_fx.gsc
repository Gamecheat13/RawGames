#include maps\_utility; 
#include common_scripts\utility;
#using_animtree("fxanim_props");

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{	
	initModelAnims();
	precache_scripted_fx();
	precache_createfx_fx();
	wind_init();
	
	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\blackout_fx::main();
}


// Scripted effects
precache_scripted_fx()
{
	level._effect[ "flesh_hit" ]		= LoadFX( "impacts/fx_flesh_hit" );
	
	// section 1
	level._effect[ "ear_blood" ] 							= LoadFX( "blood/fx_blood_ear_drop" );
	level._effect[ "camera_recording" ]						= LoadFX( "maps/command_center/fx_com_camera_light_red" );
	level._effect[ "handcuffs_light" ]						= LoadFX( "maps/command_center/fx_com_handcuff_light_red" );
	level._effect[ "door_light_locked" ] 					= LoadFX( "maps/command_center/fx_com_door_light_red" );
	level._effect[ "door_light_unlocked" ] 					= LoadFX( "maps/command_center/fx_com_door_light_green" );
	level._effect[ "turret_death" ]							= LoadFX( "destructibles/fx_cic_turret_death" );
	level._effect[ "fx_wire_spark" ]						= LoadFX( "maps/command_center/fx_com_camera_wire_sparks" );
	
	// section 3
	level._effect[ "eyeball_glass" ]						= LoadFX( "maps/command_center/fx_com_eyeball_glass" );
	level._effect["steam_burst_1"]							= LoadFX( "maps/command_center/fx_com_pipe_steam_burst" );
	level._effect["messiah_papers"]							= LoadFX( "maps/command_center/fx_com_messiah_papers" );
	level._effect[ "sparks" ]               				= LoadFX( "maps/command_center/fx_com_torch_cutter" );
	level._effect["fx_la_drones_above_city"]				= loadFX("maps/la/fx_la_drones_above_city");

	level._effect[ "f35_exhaust_hover_front" ]				= LoadFX( "vehicle/exhaust/fx_exhaust_la1_f35_vtol_front" );
	level._effect[ "f35_exhaust_hover_rear" ]				= LoadFX( "vehicle/exhaust/fx_exhaust_la1_f35_vtol_rear" );
	level._effect[ "f35_exhaust_fly" ]						= LoadFX( "vehicle/exhaust/fx_exhaust_la1_f38_afterburner" );
	
	level._effect["fx_turret_flash"] 						= LoadFX("weapon/muzzleflashes/fx_muz_ar_flash_3p");
	
	level._effect["fx_laser_cutter_on"] 					= LoadFX("electrical/fx_com_weld_spark_burst_2");
	level._effect["laser_cutter_sparking"] 					= LoadFX("props/fx_com_laser_cutter_sparking_2");
}


// Ambient effects
precache_createfx_fx()
{
	level._effect["fx_com_gas_aftermath_linger"]		= loadFX("maps/command_center/fx_com_gas_aftermath_linger");
	level._effect["fx_com_sparks_slow"]							= loadFX("maps/command_center/fx_com_sparks_slow");
	level._effect["fx_com_sparks"]							= loadFX("maps/command_center/fx_com_sparks");
	level._effect["fx_com_water_drips"]							= loadFX("maps/command_center/fx_com_water_drips");
	level._effect["fx_com_pipe_water"]							= loadFX("maps/command_center/fx_com_pipe_water");
	level._effect["fx_com_pipe_steam"]							= loadFX("maps/command_center/fx_com_pipe_steam");
	level._effect["fx_com_pipe_steam_slow"]							= loadFX("maps/command_center/fx_com_pipe_steam_slow");
	level._effect["fx_com_distant_exp_1"]							= loadFX("maps/command_center/fx_com_distant_exp_1");
	level._effect["fx_com_distant_exp_2"]							= loadFX("maps/command_center/fx_com_distant_exp_2");
	level._effect["fx_com_distant_exp_water"]							= loadFX("maps/command_center/fx_com_distant_exp_water");
	level._effect["fx_com_distant_exp_flak"]							= loadFX("maps/command_center/fx_com_distant_exp_flak");
	level._effect["fx_com_distant_smoke"]							= loadFX("maps/command_center/fx_com_distant_smoke");
	level._effect["fx_com_deck_fire_lrg"]							= loadFX("maps/command_center/fx_com_deck_fire_lrg");
	level._effect["fx_com_deck_fire_sml"]							= loadFX("maps/command_center/fx_com_deck_fire_sml");
	level._effect["fx_com_deck_takeoff_steam"]							= loadFX("maps/command_center/fx_com_deck_takeoff_steam");
	level._effect["fx_com_carrier_runner"]							= loadFX("maps/command_center/fx_com_carrier_runner");
	level._effect["fx_com_menendez_spotlight"]							= loadFX("maps/command_center/fx_com_menendez_spotlight");
	level._effect["fx_com_floating_paper"]							= loadFX("maps/command_center/fx_com_floating_paper");
	level._effect["fx_com_oil_drips"]							= loadFX("maps/command_center/fx_com_oil_drips");
	level._effect["fx_com_steam_debri"]							= loadFX("maps/command_center/fx_com_steam_debri");
	level._effect["fx_com_deck_oil_fire"]							= loadFX("maps/command_center/fx_com_deck_oil_fire");
	level._effect["fx_com_pipe_steam_exp_1"]							= LoadFX( "maps/command_center/fx_com_pipe_steam_exp_1" );
	level._effect["fx_com_pipe_steam_exp_2"]							= LoadFX( "maps/command_center/fx_com_pipe_steam_exp_2" );
	level._effect["fx_com_ceiling_collapse"]							= LoadFX( "maps/command_center/fx_com_ceiling_collapse" );
		level._effect["fx_com_hub_rpg_exp"]							= loadFX("maps/command_center/fx_com_hub_rpg_exp");
	level._effect["fx_com_deck_exp_vtol"]							= loadFX("maps/command_center/fx_com_deck_exp_vtol");
	level._effect["fx_com_deck_exp_f38"]							= loadFX("maps/command_center/fx_com_deck_exp_f38");
	level._effect["fx_com_deck_dust"]							= loadFX("maps/command_center/fx_com_deck_dust");
	level._effect["fx_com_water_leak"]							= loadFX("maps/command_center/fx_com_water_leak");
	level._effect["fx_com_exp_sparks"]							= loadFX("maps/command_center/fx_com_exp_sparks");
	level._effect["fx_com_glass_shatter"]							= loadFX("maps/command_center/fx_com_glass_shatter");
	level._effect["fx_com_glass_shatter_f38"]							= loadFX("maps/command_center/fx_com_glass_shatter_f38");
	level._effect["fx_com_water_ship_sink"]							= LoadFX( "maps/command_center/fx_com_water_ship_sink" );
	level._effect["fx_com_distant_ship_exp"]							= LoadFX( "maps/command_center/fx_com_distant_ship_exp" );
	level._effect["fx_com_window_break_paper"]							= LoadFX( "maps/command_center/fx_com_window_break_paper" );
		level._effect["fx_com_elev_fa38_impact"]							= LoadFX( "maps/command_center/fx_com_elev_fa38_impact" );
	level._effect["fx_com_elev_fa38_exp"]							= LoadFX( "maps/command_center/fx_com_elev_fa38_exp" );
	level._effect["fx_com_elev_fa38_debri_trail"]							= LoadFX( "maps/command_center/fx_com_elev_fa38_debri_trail" );
	level._effect["fx_com_elev_fa38_water_impact"]							= LoadFX( "maps/command_center/fx_com_elev_fa38_water_impact" );
	level._effect["fx_com_messiah_papers_exp"]							= LoadFX( "maps/command_center/fx_com_messiah_papers_exp" );
	level._effect["fx_com_f38_slide"]							= LoadFX( "maps/command_center/fx_com_f38_slide" );
	level._effect["fx_com_drone_slide"]							= LoadFX( "maps/command_center/fx_com_drone_slide" );
	level._effect["fx_com_light_beam"]							= LoadFX( "maps/command_center/fx_com_light_beam" );
	level._effect["fx_com_emergency_lights"]							= LoadFX( "maps/command_center/fx_com_emergency_lights" );
	level._effect["fx_com_hanger_godray"]							= LoadFX( "maps/command_center/fx_com_hanger_godray" );
	level._effect["fx_com_flourescent_glow_white"]							= LoadFX( "maps/command_center/fx_com_flourescent_glow_white" );
	level._effect["fx_com_flourescent_glow_warm"]							= LoadFX( "maps/command_center/fx_com_flourescent_glow_warm" );
	level._effect["fx_com_flourescent_glow_green"]							= LoadFX( "maps/command_center/fx_com_flourescent_glow_green" );
	
	//frontend fx
	level._effect["fx_com_flourescent_glow_cool"]	= loadfx ("maps/command_center/fx_com_flourescent_glow_cool");
	level._effect["fx_com_flourescent_glow_cool_sm"]	= loadfx ("maps/command_center/fx_com_flourescent_glow_cool_sm");
	level._effect["fx_com_tv_glow_blue"]	= loadfx ("maps/command_center/fx_com_tv_glow_blue");
	level._effect["fx_com_tv_glow_green"]	= loadfx ("maps/command_center/fx_com_tv_glow_green");
	level._effect["fx_com_tv_glow_yellow"]	= loadfx ("maps/command_center/fx_com_tv_glow_yellow");
	level._effect["fx_com_tv_glow_yellow_sml"]	= loadfx ("maps/command_center/fx_com_tv_glow_yellow_sml");
	level._effect["fx_com_light_glow_white"]	= loadfx ("maps/command_center/fx_com_light_glow_white");
	level._effect["fx_lf_commandcenter_light1"]	= loadfx ("lens_flares/fx_lf_commandcenter_light1");
		level._effect["fx_lf_commandcenter_light2"]	= loadfx ("lens_flares/fx_lf_commandcenter_light2");
	level._effect["fx_lf_commandcenter_light3"]	= loadfx ("lens_flares/fx_lf_commandcenter_light3");
	level._effect["fx_com_glow_sml_blue"]	= loadfx ("maps/command_center/fx_com_glow_sml_blue");
	level._effect["fx_com_hologram_glow"]	= loadfx ("maps/command_center/fx_com_hologram_glow");
	level._effect["fx_com_button_glows_1"]	= loadfx ("maps/command_center/fx_com_button_glows_1");
	level._effect["fx_com_button_glows_2"]	= loadfx ("maps/command_center/fx_com_button_glows_2");
	level._effect["fx_com_button_glows_3"]	= loadfx ("maps/command_center/fx_com_button_glows_3");
	level._effect["fx_com_button_glows_4"]	= loadfx ("maps/command_center/fx_com_button_glows_4");
	level._effect["fx_com_button_glows_5"]	= loadfx ("maps/command_center/fx_com_button_glows_5");
	level._effect["fx_com_button_glows_6"]	= loadfx ("maps/command_center/fx_com_button_glows_6");
	level._effect["fx_com_button_glows_7"]	= loadfx ("maps/command_center/fx_com_button_glows_7");
	level._effect["fx_com_button_glows_8"]	= loadfx ("maps/command_center/fx_com_button_glows_8");
	level._effect["fx_com_hologram_static"]	= loadfx ("maps/command_center/fx_com_hologram_static");
}


wind_init()
{
	SetSavedDvar( "wind_global_vector", "1 0 0" );						// change "1 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0 );						// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 5000 );					// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.5 );	// change 0.5 to your desired wind strength percentage
}


// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["obs_hub_rpg"] = %fxanim_black_obs_hub_rpg_anim;
	level.scr_anim["fxanim_props"]["flag_horiz_rig_01"] = %fxanim_gp_flag_horiz_rig_01_anim;
	level.scr_anim["fxanim_props"]["stairwell_ceiling"] = %fxanim_black_stairwell_ceiling_anim;
	level.scr_anim["fxanim_props"]["pipes_block"] = %fxanim_black_pipes_block_anim;
	level.scr_anim["fxanim_props"]["life_preserver"] = %fxanim_gp_life_preserver_anim;
	level.scr_anim["fxanim_props"]["wirespark_long"] = %fxanim_gp_wirespark_long_anim;
	level.scr_anim["fxanim_props"]["wirespark_med"] = %fxanim_gp_wirespark_med_anim;
	level.scr_anim["fxanim_props"]["elevator_debris"] = %fxanim_black_elevator_debris_anim;
	level.scr_anim["fxanim_props"]["pipes_break_loop_01"] = %fxanim_black_pipes_break_loop_01_anim;
	level.scr_anim["fxanim_props"]["pipes_break_loop_02"] = %fxanim_black_pipes_break_loop_02_anim;
	level.scr_anim["fxanim_props"]["pipes_break_burst_01"] = %fxanim_black_pipes_break_burst_01_anim;
	level.scr_anim["fxanim_props"]["pipes_break_burst_02"] = %fxanim_black_pipes_break_burst_02_anim;
	level.scr_anim["fxanim_props"]["drone_cover_01"] = %fxanim_black_drone_cover_01_anim;
	level.scr_anim["fxanim_props"]["drone_cover_02"] = %fxanim_black_drone_cover_02_anim;
	level.scr_anim["fxanim_props"]["f38_launch_fail"] = %fxanim_black_f38_launch_fail_anim;
}
