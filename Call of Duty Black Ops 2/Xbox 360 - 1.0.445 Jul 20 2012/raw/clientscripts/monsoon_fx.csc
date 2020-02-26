#include clientscripts\_utility;

// Scripted effects
precache_scripted_fx()
{
 level._effect["fx_water_wingsuit"]					= LoadFx( "test/fx_test_looping" );
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

 
 level._effect["fx_mon_cloud_cover_volume"] 		    	= LoadFx("maps/monsoon/fx_mon_cloud_cover_volume" );
 level._effect["fx_mon_cloud_cover_flat"] 		      	= LoadFx("maps/monsoon/fx_mon_cloud_cover_flat" );
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


main()
{
	clientscripts\createfx\monsoon_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

