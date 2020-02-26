#include maps\_utility; 
#include common_scripts\utility;
#include maps\_anim;
#using_animtree("fxanim_props");

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

main()
{	
	precache_fxanim_props();
	precache_scripted_fx();
	precache_createfx_fx();
	wind_init();
	
	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\monsoon_fx::main();
}


// Scripted effects
precache_scripted_fx()
{
	//camera rain fx
	level._effect["fx_water_wingsuit"]					= LoadFx( "test/fx_test_looping" );
	
	//Weather FX
	level._effect[ "player_rain" ]		    = LoadFX( "maps/monsoon/fx_mon_rain_player_runner" );
	level._effect[ "wingsuit_rain" ]	    = LoadFX( "maps/monsoon/fx_rain_suit01" );
	level._effect[ "ai_rain" ]			      = LoadFX( "maps/monsoon/fx_mon_player_rain_impacts" );
	level._effect[ "ai_rain_helmet" ]			= LoadFX( "maps/monsoon/fx_mon_player_rain_impacts_head" );
			
	//Temp Hud FX
	level._effect["enemy_marker"]			= LoadFX( "misc/fx_friendly_indentify01_red" );
	level._effect["enemy_marker_spotted"]	= LoadFX( "misc/fx_friendly_indentify01" );
	
	//Lift
	level._effect[ "lift_light" ]		= LoadFX( "light/fx_mon_light_elevator_blink" );
	level._effect[ "lift_spotlight" ]	= LoadFX( "light/fx_mon_spotlight_lift_interior" );
	
	//Future Helicopter
	level._effect[ "heli_smoke" ]		= LoadFX( "smoke/fx_vsmk_heli_future_damage" );
	level._effect[ "heli_chaff" ]		= LoadFX( "explosions/fx_heli_future_chaff_flares" );
	level._effect[ "heli_spotlight"]	= loadFX( "light/fx_vlight_apache_spotlight_cheap" );
	
	//EMP
	level._effect[ "emp_detonate" ]		= LoadFX( "weapon/emp/fx_mon_emp_grenade_exp" );
	
	//Camo Suit
	level._effect[ "camo_transition" ]	= LoadFX( "misc/fx_camo_reveal_transition" );
	
	//Temp Lightning
	level._effect[ "harper_lightning" ] = LoadFx( "maps/angola/fx_ango_container_light" );
	
	//Nano Gloves FX
	level._effect[ "nanoglove_impact" ] = LoadFx( "dirt/fx_mon_dust_nano_glove" );
	
	//For mudslide collapse
	level._effect[ "fx_mon_sld_lft_tree_fall" ] = LoadFx( "maps/monsoon/fx_mon_sld_lft_tree_fall" );
	level._effect[ "fx_mon_sld_lft_mud_froth" ] = LoadFx( "maps/monsoon/fx_mon_sld_lft_mud_froth" );
	level._effect[ "fx_mon_sld_lft_tower_dust" ] = LoadFx( "maps/monsoon/fx_mon_sld_lft_tower_dust" );
	
	//Lights
	level._effect[ "light_yard" ] 			= LoadFx( "light/fx_light_m_p6_container_yard_light" );
	level._effect[ "light_generator" ]		= LoadFx( "light/fx_light_m_ctl_light_spotlight_generator" );
	level._effect[ "light_pole" ] 			= LoadFx( "light/fx_light_m_p6_stadium_light_pole" );
	level._effect[ "light_pole_b" ] 			= LoadFx( "light/fx_light_m_p6_stadium_light_pole_b" );
	level._effect[ "light_3x" ]				= LoadFx( "light/fx_light_m_ctl_spotlight_modern_3x" );
	level._effect[ "light_single_burst" ]	= LoadFx( "electrical/fx_mon_light_short_pop" );
	level._effect[ "light_3x_burst" ]		= LoadFx( "electrical/fx_mon_light_modern_short_pop" );
	
	// ASD / Metal Storm
	level._effect[ "freeze_short_circuit" ] = LoadFx( "destructibles/fx_metalstorm_damagestate_nitro" );
		
}

// --- FX DEPARTMENT SECTION ---//

// Ambient effects
precache_createfx_fx()
{
	// exploders
 level._effect["fx_mon_lightning_flash_cliff"] 			   = LoadFx("maps/monsoon/fx_mon_lightning_flash_cliff" ); // exloder_88 lightning spot flash
 level._effect["fx_lightning_flash_single_lg"] 			   = LoadFx("weather/fx_lightning_flash_single_lg" ); // exloder_88 lightning flash
 
 level._effect["fx_mon_exp_lion_statue_a"] 			   = LoadFx("maps/monsoon/fx_mon_exp_lion_statue_a" ); // lion head exp 10420
  
 level._effect["fx_mon_mud_stream_xlg"] 			         = LoadFx("dirt/fx_mon_mud_stream_xlg" ); // exloder_750 left side mud stream
 level._effect["fx_mon_mud_stream_lg"] 			           = LoadFx("dirt/fx_mon_mud_stream_lg" ); // exploder_850 right side mud stream
 level._effect["fx_exp_gate_entrance"] 			           = LoadFx("maps/monsoon/fx_exp_gate_entrance" ); //exploder_1000
 level._effect["fx_exp_glass_window_shatter_lg"] 			 = LoadFx("maps/monsoon/fx_exp_glass_window_shatter_lg" ); //exploder_1250
 level._effect["fx_mon_steam_burst_lg"]							   = loadFX("maps/monsoon/fx_mon_steam_burst_lg"); //exploder_1350
 level._effect["fx_smoke_breach_room_filler"] 			   = LoadFx("maps/monsoon/fx_smoke_breach_room_filler" ); //exploder_1500
 level._effect["fx_exp_int_truck_bash"] 			         = LoadFx("maps/monsoon/fx_exp_int_truck_bash" ); //exploder_2000
 
 level._effect["fx_mon_mud_stream_xlg"] 			           = LoadFx("dirt/fx_mon_mud_stream_xlg" ); //exploder_10549
 level._effect["fx_mon_sld_lft_tower_hit_top"] 			     = LoadFx("maps/monsoon/fx_mon_sld_lft_tower_hit_top" ); //exploder_10550
 level._effect["fx_mon_sld_lft_tower_hit"] 			         = LoadFx("maps/monsoon/fx_mon_sld_lft_tower_hit" ); //exploder_10551
 level._effect["fx_mon_sld_lft_tower_hit"] 			         = LoadFx("maps/monsoon/fx_mon_sld_lft_tower_hit" ); //exploder_10552
 level._effect["fx_mon_sld_lft_tree_hit"] 			         = LoadFx("maps/monsoon/fx_mon_sld_lft_tree_hit" ); //exploder_10553
 level._effect["fx_mon_sld_lft_filler"] 			           = LoadFx("maps/monsoon/fx_mon_sld_lft_filler" ); //exploder_10554
  
	// end_exploders
 level._effect["fx_mon_mud_stream_sm"] 			          = LoadFx("dirt/fx_mon_mud_stream_sm" );
 level._effect["fx_mon_mud_stream_md"] 			          = LoadFx("dirt/fx_mon_mud_stream_md" );
 level._effect["fx_light_dist_base_white"] 			      = LoadFx("light/fx_mon_light_dist_base_white" );
 level._effect["fx_light_dist_base_red"] 			        = LoadFx("light/fx_mon_light_dist_base_red" );
 level._effect["fx_waterfall01"] 			                = LoadFx("maps/monsoon/fx_waterfall01" );
 level._effect["fx_wtr_spill_sm_thin"]								= loadFX("env/water/fx_wtr_spill_sm_thin");
 level._effect["fx_water_pipe_spill_sm_thin_tall"]		= loadFX("water/fx_water_pipe_spill_sm_thin_tall");
 level._effect["fx_water_spill_sm"]									  = loadFX("water/fx_water_spill_sm");
 level._effect["fx_water_spill_sm_splash"]						= loadFX("water/fx_water_spill_sm_splash");
 level._effect["fx_water_roof_spill_md"]							= loadFX("water/fx_water_roof_spill_md");
 level._effect["fx_water_roof_spill_md_hvy"]					= loadFX("water/fx_water_roof_spill_md_hvy");
 level._effect["fx_water_roof_spill_lg"]							= loadFX("water/fx_water_roof_spill_lg");
 level._effect["fx_water_roof_spill_lg_hvy"]					= loadFX("water/fx_water_roof_spill_lg_hvy");
 level._effect["fx_water_sheeting_lg_hvy"]						= loadFX("water/fx_water_sheeting_lg_hvy");
 level._effect["fx_water_splash_detail"]							= loadFX("water/fx_water_splash_detail");
 level._effect["fx_water_splash_detail_lg"]				    = loadFX("water/fx_water_splash_detail_lg");
 level._effect["fx_pak_water_elec_pole_wake"]			    = loadFX("water/fx_pak_water_elec_pole_wake");
 level._effect["fx_pak_water_pipe_spill_wake"]		  	= loadFX("water/fx_pak_water_pipe_spill_wake");
 level._effect["fx_water_spill_splash_wide"]			  	= loadFX("water/fx_water_spill_splash_wide");
 level._effect["fx_water_drips_hvy_30"]						    = loadFX("water/fx_water_drips_hvy_30");
 level._effect["fx_water_drips_hvy_120"]							= loadFX("water/fx_water_drips_hvy_120");
 level._effect["fx_water_drips_hvy_200"]							= loadFX("water/fx_water_drips_hvy_200");

 level._effect["fx_mon_vent_cleanroom_slow"]					= loadFX("maps/monsoon/fx_mon_vent_cleanroom_slow");
 level._effect["fx_mon_steam_highpressure_sm"]				= loadFX("maps/monsoon/fx_mon_steam_highpressure_sm");
 level._effect["fx_mon_steam_highpressure_lg"]				= loadFX("maps/monsoon/fx_mon_steam_highpressure_lg");

 level._effect["fx_mon_vent_roof_steam_lg"]						= loadFX("smoke/fx_mon_vent_roof_steam_lg");
 level._effect["fx_mon_vent_roof_steam_wide"]					= loadFX("smoke/fx_mon_vent_roof_steam_wide");
  level._effect["fx_mon_steam_lab_rising"]				      = loadFX("smoke/fx_mon_steam_lab_rising");

 level._effect["fx_mon_light_overhead_rain"] 			    = LoadFx("light/fx_mon_light_overhead_rain" );
 
 level._effect["fx_mon_cloud_cover_volume"] 		    	= LoadFx("maps/monsoon/fx_mon_cloud_cover_volume" );
 level._effect["fx_mon_cloud_cover_flat"] 		       	= LoadFx("maps/monsoon/fx_mon_cloud_cover_flat" );
 level._effect["fx_mon_fog_rising_tall_xlg"] 			    = LoadFx("fog/fx_mon_fog_rising_tall_xlg" );
 
 level._effect["fx_rain_ground_gusts_fast_sm"] 			= LoadFx("maps/monsoon/fx_rain_ground_gusts_fast_sm" );
 level._effect["fx_rain_ground_gusts_fast_md"] 			= LoadFx("maps/monsoon/fx_rain_ground_gusts_fast_md" );
 level._effect["fx_rain_ground_gusts_fast_lg"] 			= LoadFx("maps/monsoon/fx_rain_ground_gusts_fast_lg" );
 level._effect["fx_mon_leaves_gust_fast_lg"] 			  = LoadFx("foliage/fx_mon_leaves_gust_fast_lg" );
 
  // NEW
 level._effect["fx_mon_light_overhead_rain"] 			    = LoadFx("light/fx_mon_light_overhead_rain" );
 level._effect["fx_mon_wtr_rain_light_fill"] 			    = LoadFx("water/fx_mon_wtr_rain_light_fill" );
 
 level._effect["fx_wtr_spill_sm_thin_gusty"] 		               = LoadFx("water/fx_wtr_spill_sm_thin_gusty" );
 level._effect["fx_water_pipe_spill_sm_thin_tall_gusty"] 		   = LoadFx("water/fx_water_pipe_spill_sm_thin_tall_gusty" );
 level._effect["fx_water_spill_sm_gusty"]						           = loadFX("water/fx_water_spill_sm_gusty");
 level._effect["fx_water_roof_spill_md_gusty"]		             = loadFX("water/fx_water_roof_spill_md_gusty");
 level._effect["fx_water_roof_spill_md_hvy_gusty"]					   = loadFX("water/fx_water_roof_spill_md_hvy_gusty");
 level._effect["fx_water_roof_spill_lg_gusty"]							   = loadFX("water/fx_water_roof_spill_lg_gusty");
 level._effect["fx_water_roof_spill_lg_hvy_gusty"]					   = loadFX("water/fx_water_roof_spill_lg_hvy_gusty");
 level._effect["fx_water_roof_spill_sngl_tall_gusty"]				 = loadFX("water/fx_water_roof_spill_sngl_tall_gusty");
	
 level._effect["fx_mon_lab_ceiling_flat_lg_warm"]				 = loadFX("light/fx_mon_lab_ceiling_flat_lg_warm");
 level._effect["fx_mon_lab_ceiling_led_cool"]				 = loadFX("light/fx_mon_lab_ceiling_led_cool");
 level._effect["fx_mon_lab_ceiling_led_cool_x2"]				 = loadFX("light/fx_mon_lab_ceiling_led_cool_x2");
 level._effect["fx_mon_lab_ceiling_led_cool_x9"]				 = loadFX("light/fx_mon_lab_ceiling_led_cool_x9");	
 
	//frontend fx		
	level._effect["fx_com_emergency_lights"]							= LoadFX( "maps/command_center/fx_com_emergency_lights" );
	level._effect["fx_com_hanger_godray"]							= LoadFX( "maps/command_center/fx_com_hanger_godray" );
	level._effect["fx_com_flourescent_glow_white"]							= LoadFX( "maps/command_center/fx_com_flourescent_glow_white" );
	level._effect["fx_com_flourescent_glow_warm"]							= LoadFX( "maps/command_center/fx_com_flourescent_glow_warm" );
	level._effect["fx_com_flourescent_glow_green"]							= LoadFX( "maps/command_center/fx_com_flourescent_glow_green" );
	
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
	SetSavedDvar( "wind_global_vector", "-287 -284 69" );    // wind vector                                
	SetSavedDvar( "wind_global_low_altitude", -1500 );						// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 5000 );					// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", .5 );	// change 0.5 to your desired wind strength percentage
}


// FXanim Props
precache_fxanim_props()
{
	level.scr_anim["fxanim_props"]["helo_arch"] = %fxanim_monsoon_helo_arch_anim;
	level.scr_anim["fxanim_props"]["shrine_lft"] = %fxanim_monsoon_shrine_lft_anim;
	level.scr_anim["fxanim_props"]["shrine_lft_mudslide"] = %fxanim_monsoon_shrine_lft_mudslide_anim;
	level.scr_anim["fxanim_props"]["shrine_rt"] = %fxanim_monsoon_shrine_rt_anim;
	level.scr_anim["fxanim_props"]["metal_storm_enter01"] = %fxanim_monsoon_metal_storm_enter01_anim;
	level.scr_anim["fxanim_props"]["metal_storm_enter02"] = %fxanim_monsoon_metal_storm_enter02_anim;
	level.scr_anim["fxanim_props"]["defend_truck_env"] = %fxanim_monsoon_defend_truck_env_anim;
	level.scr_anim["fxanim_props"]["lion_statue_01"] = %fxanim_monsoon_lion_statue_01_anim;
	
	addnotetrack_customfunction( "fxanim_props", "exploder 10550 #shrine_lft_mudslide", maps\monsoon_ruins::inner_ruins_destroy_left_temple, "shrine_lft_mudslide" );
	addnotetrack_fxontag( "fxanim_props", "shrine_lft_mudslide", "exploder 10551 #temple_impact_1", "fx_mon_sld_lft_tree_fall", "fx_tag_tree_mid_jnt" );
	addnotetrack_fxontag( "fxanim_props", "shrine_lft_mudslide", "exploder 10550 #shrine_lft_mudslide", "fx_mon_sld_lft_mud_froth", "fx_tag_slide_01_jnt" );
	addnotetrack_fxontag( "fxanim_props", "shrine_lft_mudslide", "exploder 10550 #shrine_lft_mudslide", "fx_mon_sld_lft_mud_froth", "fx_tag_slide_02_jnt" );
	addnotetrack_fxontag( "fxanim_props", "shrine_lft_mudslide", "exploder 10550 #shrine_lft_mudslide", "fx_mon_sld_lft_mud_froth", "fx_tag_slide_03_jnt" );
	addnotetrack_fxontag( "fxanim_props", "shrine_lft_mudslide", "exploder 10550 #shrine_lft_mudslide", "fx_mon_sld_lft_mud_froth", "fx_tag_slide_04_jnt" );
	addnotetrack_fxontag( "fxanim_props", "shrine_lft_mudslide", "exploder 10551 #temple_impact_1", "fx_mon_sld_lft_mud_froth", "fx_tag_wall_01_jnt" );
	addnotetrack_fxontag( "fxanim_props", "shrine_lft_mudslide", "exploder 10552 #temple_impact_2", "fx_mon_sld_lft_mud_froth", "fx_tag_wall_02_jnt" );
	addnotetrack_fxontag( "fxanim_props", "shrine_lft_mudslide", "exploder 10550 #shrine_lft_mudslide", "fx_mon_sld_lft_tower_dust", "fx_tag_temple_top_jnt" );
	addnotetrack_fxontag( "fxanim_props", "shrine_lft_mudslide", "exploder 10552 #temple_impact_2", "fx_mon_sld_lft_mud_froth", "fx_tag_temple_mid_jnt" );
	addnotetrack_fxontag( "fxanim_props", "shrine_lft_mudslide", "exploder 10552 #temple_impact_2", "fx_mon_sld_lft_tower_dust", "fx_tag_filler_jnt" );
	
}