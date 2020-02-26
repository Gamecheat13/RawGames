//
// file: karma_fx.gsc
// description: clientside fx script for karma: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 


// load fx used by util scripts
precache_util_fx()
{	

}

precache_scripted_fx()
{
}


// --- FX DEPARTMENT SECTION ---//
precache_createfx_fx()
{
	// EXPLODERS //
  
  // Event 1: Arrival - gump: karma_gump_checkin_images
  	// LEVEL START FX																																					// exploder 101: ,event
  	
  // Event 2: Check-in - gump: karma_gump_checkin_images
  
  // Event 3: Go to your room - gump: karma_gump_checkin_images
  level._effect["fx_kar_shrimp_crowd_neutral"]								= LoadFX("maps/karma/fx_kar_shrimp_crowd_neutral"); // exploder 330: ,event
	level._effect["fx_seagulls_shore_distant"]					= LoadFX("maps/karma/fx_kar_seagulls_distant");	// exploder 331: ,event 
	level._effect["fx_seagulls_circle_overhead"]				= LoadFX("maps/karma/fx_kar_seagulls_overhead");	// exploder 331: ,event 
//  level._effect["fx_kar_shrimp_crowd_line01"]									= LoadFX("maps/karma/fx_kar_shrimp_crowd_line01"); // exploder 332: ,event

	// Event 4: Spider Bot - gump: karma_gump_construction_images
//  level._effect["fx_kar_bug_zapped_intro"]         = LoadFX("maps/karma/fx_kar_bug_zapped_intro"); // exploder 441: ,event
//  level._effect["fx_kar_bug_zapped_scared"]         = LoadFX("maps/karma/fx_kar_bug_zapped_scared"); // exploder 442: ,event
//  level._effect["fx_kar_bug_zapped"]         = LoadFX("maps/karma/fx_kar_bug_zapped"); // exploder 443: ,event
  level._effect["fx_kar_elec_box_power_surge"]								= loadFX("electrical/fx_kar_elec_box_power_surge");	// 444
  level._effect["fx_kar_elec_vent_field"]											= LoadFX("maps/karma/fx_kar_elec_vent_field"); // exploder 445: ,event
  level._effect["fx_powerbutton_blink_green_sm"]							= LoadFX("light/fx_powerbutton_blink_green_sm"); // exploder 446: ,event
  level._effect["fx_powerbutton_constant_green_sm"]						= LoadFX("light/fx_powerbutton_constant_green_sm"); // exploder 446: ,event
//  level._effect["fx_light_alarm01"]														= LoadFX("env/light/fx_light_alarm01"); // exploder 475: ,event
  level._effect["fx_kar_eye_scanner"]													= LoadFX("maps/karma/fx_kar_eye_scanner"); // exploder 480: ,event
  
  // Event 5: Construction - gump: karma_gump_construction_images
  level._effect["fx_flashbang_breach_godray"]									= loadFX("maps/karma/fx_flashbang_breach_godray");	// 540
	level._effect["fx_crc_projector_glow"]											= loadFX("maps/karma/fx_crc_projector_glow");	// 545
	level._effect["fx_kar_smk_grenade_hall_fill_os"]						= loadFX("smoke/fx_kar_smk_grenade_hall_fill_os");	// 550
	level._effect["fx_kar_smk_grenade_hall_spillout_os"]				= loadFX("smoke/fx_kar_smk_grenade_hall_spillout_os");	// 550
	
	// Event 6: Sunburned - gump: karma_gump_club_images
  level._effect["fx_shrimp_kar_dance_female_a"]								= LoadFX("bio/shrimps/fx_shrimp_kar_dance_female_a"); // exploder 621-623: ,event
  level._effect["fx_shrimp_kar_dance_female_b"]								= LoadFX("bio/shrimps/fx_shrimp_kar_dance_female_b"); // exploder 621-623: ,event
  level._effect["fx_shrimp_kar_dance_male_a"]									= LoadFX("bio/shrimps/fx_shrimp_kar_dance_male_a"); // exploder 621-623: ,event
  level._effect["fx_shrimp_kar_dance_male_b"]									= LoadFX("bio/shrimps/fx_shrimp_kar_dance_male_b"); // exploder 621-623: ,event
  level._effect["fx_shrimp_group_dance01"]										= LoadFX("bio/shrimps/fx_shrimp_group_dance01"); // exploder 621-623: ,event
  level._effect["fx_shrimp_group_dance02"]										= LoadFX("bio/shrimps/fx_shrimp_group_dance02"); // exploder 621-623: ,event
//  level._effect["fx_shrimp_group_hangout01"]									= LoadFX("bio/shrimps/fx_shrimp_group_hangout01"); // exploder 621-623: ,event
//  level._effect["fx_shrimp_group_hangout02"]									= LoadFX("bio/shrimps/fx_shrimp_group_hangout02"); // exploder 621-623: ,event
  level._effect["fx_shrimp_group_hangout02_strobe"]						= LoadFX("bio/shrimps/fx_shrimp_group_hangout02_strobe"); // exploder 621-623: ,event
  	// CLUB FX																																														 // exploder 620: ,event
  level._effect["fx_kar_club_spotlight"]											= LoadFX("maps/karma/fx_kar_club_spotlight"); // exploder 620: ,event
  level._effect["fx_kar_club_dancefloor"]											= LoadFX("maps/karma/fx_kar_club_dancefloor"); // exploder 620: ,event
  level._effect["fx_kar_club_dancefloor2"]										= LoadFX("maps/karma/fx_kar_club_dancefloor2"); // exploder 630: ,event
  level._effect["fx_kar_club_mist1"]													= LoadFX("maps/karma/fx_kar_club_mist1"); // exploder 630: ,event
 
 // END EXPLODERS //
 
//	level._effect["fx_kar_redlight"]										= LoadFx("maps/karma/fx_kar_redlight" );
	level._effect["fx_kar_flare01"]											= LoadFX("maps/karma/fx_kar_flare01");
	level._effect["fx_kar_towerlights"]									= LoadFX("maps/karma/fx_kar_towerlights");
	level._effect["fx_kar_club_floormist2"]							= LoadFX("maps/karma/fx_kar_club_floormist2");
	level._effect["fx_kar_club_floormist2_blue"]				= LoadFX("maps/karma/fx_kar_club_floormist2_blue");
	level._effect["fx_kar_clouds_lg"]										= LoadFX("maps/karma/fx_kar_clouds_lg");
	level._effect["fx_lf_karma_club01"]									= LoadFX("lens_flares/fx_lf_karma_club01");
	level._effect["fx_lf_karma_club02"]									= LoadFX("lens_flares/fx_lf_karma_club02");
	level._effect["fx_lf_karma_light_plain1"]						= LoadFX("lens_flares/fx_lf_karma_light_plain1");
	level._effect["fx_lf_karma_sun1"]										= LoadFX("lens_flares/fx_lf_karma_sun1");
	level._effect["fx_lf_karma_sun2"]										= LoadFX("lens_flares/fx_lf_karma_sun2");
	level._effect["fx_lf_karma_sun2_reflection"]				= LoadFX("lens_flares/fx_lf_karma_sun2_reflection");
	level._effect["fx_kar_spotlights1"]									= LoadFx("maps/karma/fx_kar_spotlights1");
	level._effect["fx_kar_dancefloor_spotlight"]				= LoadFx("maps/karma/fx_kar_dancefloor_spotlight");
	level._effect["fx_kar_sconce1"]											= LoadFx("maps/karma/fx_kar_sconce1");
	level._effect["fx_kar_sconce2"]											= LoadFx("maps/karma/fx_kar_sconce2");
	level._effect["fx_kar_club_bardive_dest1"]					= LoadFx("maps/karma/fx_kar_club_bardive_dest1");
	level._effect["fx_kar_laser_static2"]								= LoadFx("maps/karma/fx_kar_laser_static2");
	level._effect["fx_kar_club_stage_mist1"]						= LoadFx("maps/karma/fx_kar_club_stage_mist1");
	level._effect["fx_kar_club_mist2"]									= LoadFx("maps/karma/fx_kar_club_mist2");
	level._effect["fx_kar_mist1"]												= LoadFx("maps/karma/fx_kar_mist1");
	level._effect["fx_kar_floor_glow1"]									= LoadFx("maps/karma/fx_kar_floor_glow1");
	level._effect["fx_kar_starfield1"]									= LoadFx("maps/karma/fx_kar_starfield1");
	level._effect["fx_kar_starfield2"]									= LoadFx("maps/karma/fx_kar_starfield2");
	level._effect["fx_kar_globe_steam1"]								= LoadFx("maps/karma/fx_kar_globe_steam1" );
	level._effect["fx_kar_stairs1"]											= LoadFx("maps/karma/fx_kar_stairs1" );
	level._effect["fx_kar_clubmist1"]										= LoadFx("maps/karma/fx_kar_clubmist1" );
	level._effect["fx_kar_clubmist2"]										= LoadFx("maps/karma/fx_kar_clubmist2" );
	level._effect["fx_kar_club_godray"]									= LoadFx("maps/karma/fx_kar_club_godray" );
	level._effect["fx_kar_checkin_godray"]							= LoadFx("maps/karma/fx_kar_checkin_godray" );
	level._effect["fx_kar_checkin_godray_wide"]					= LoadFx("maps/karma/fx_kar_checkin_godray_wide" );
	level._effect["fx_kar_ocean_mist1"]									= LoadFX("maps/karma/fx_kar_ocean_mist1");
	level._effect["fx_kar_ocean_mist2"]									= LoadFX("maps/karma/fx_kar_ocean_mist2");
	level._effect["fx_kar_water_glints1"]								= LoadFX("maps/karma/fx_kar_water_glints1");
	level._effect["fx_kar_water_glints2"]								= LoadFX("maps/karma/fx_kar_water_glints2");
	level._effect["fx_kar_water_glints3"]								= LoadFX("maps/karma/fx_kar_water_glints3");
	level._effect["fx_kar_dust01"]											= LoadFX("maps/karma/fx_kar_dust01"); 
	level._effect["fx_kar_vent_steam01"]								= LoadFX("maps/karma/fx_kar_vent_steam01"); 
	level._effect["fx_kar_vent_steam02"]								= LoadFX("maps/karma/fx_kar_vent_steam02");
	level._effect["fx_kar_vent_steam03"]								= LoadFX("maps/karma/fx_kar_vent_steam03"); 
	level._effect["fx_kar_fountain_details01"]					= LoadFX("maps/karma/fx_kar_fountain_details01"); 
	level._effect["fx_kar_fountain_details02"]					= LoadFX("maps/karma/fx_kar_fountain_details02"); 
	level._effect["fx_kar_fountain_details05"]					= LoadFX("maps/karma/fx_kar_fountain_details05"); 
	level._effect["fx_kar_fountain_show"]								= LoadFX("maps/karma/fx_kar_fountain_show"); 
	level._effect["fx_kar_machinery01"]									= LoadFX("maps/karma/fx_kar_machinery01");
	level._effect["fx_snow_windy_heavy_md_slow"]				= LoadFX("env/weather/fx_snow_windy_heavy_md_slow");
//	level._effect["fx_kar_dust_vent_sm"]								= LoadFX("maps/karma/fx_kar_dust_vent_sm");
	level._effect["fx_light_beams_smoke_hard"]					= LoadFX("env/light/fx_light_beams_smoke_hard");
	level._effect["fx_light_beams_smoke"]								= LoadFX("env/light/fx_light_beams_smoke");
//	level._effect["fx_light_strobe02"]									= LoadFX("env/light/fx_light_strobe02");
	level._effect["fx_light_c401"]											= LoadFX("env/light/fx_light_c401");
	level._effect["fx_kar_debris_papers_windy_os_loop"]	= LoadFX("maps/karma/fx_kar_debris_papers_windy_os_loop1");
	level._effect["fx_light_laser_fan_runner02"]				= LoadFX("env/light/fx_light_laser_fan_runner02");
	level._effect["fx_light_laser_shell_runner02"]			= LoadFX("env/light/fx_light_laser_shell_runner02");
	level._effect["fx_light_laser_smoke_cool_oneshot_run"]	= LoadFX("env/light/fx_light_laser_smoke_cool_oneshot_run");
	level._effect["fx_light_laser_smoke_spin_runner02"]	= LoadFX("env/light/fx_light_laser_smoke_spin_runner02");
	level._effect["fx_pipe_steam_md"]										= loadFX("env/smoke/fx_pipe_steam_md");
	level._effect["fx_pipe_steam_xsm"]									= loadFX("smoke/fx_pipe_steam_xsm");
	level._effect["fx_kar_steam_corridor_xsm"]					= loadFX("smoke/fx_kar_steam_corridor_xsm");
	level._effect["fx_steam_hallway_md"]								= loadFX("smoke/fx_steam_hallway_md");
	level._effect["fx_kar_light_ray_fan"]								= loadFX("light/fx_kar_light_ray_fan");
	level._effect["fx_kar_light_ray_vent_grill_xsm"]		= loadFX("light/fx_kar_light_ray_vent_grill_xsm");
	level._effect["fx_kar_light_ray_vent_grill_sm"]			= loadFX("light/fx_kar_light_ray_vent_grill_sm");
  level._effect["fx_kar_light_ray_vent_grill_md"]							= loadFX("light/fx_kar_light_ray_vent_grill_md");
  level._effect["fx_kar_dust_motes_vent"]											= loadFX("dirt/fx_kar_dust_motes_vent");
  level._effect["fx_kar_dust_motes_vent_lit"]									= loadFX("dirt/fx_kar_dust_motes_vent_lit");

// level._effect["fx_kar_smoke_machine1"] 			= LoadFx("maps/karma/fx_kar_smoke_machine1" );
// level._effect["fx_exhaust_heli_vtol"] 			= LoadFx("vehicle/exhaust/fx_exhaust_heli_vtol" );
// level._effect["fx_lensflare_exp_hexes_sm"]            = LoadFX("light/fx_lensflare_exp_hexes_sm");
// level._effect["fx_kar_fountain_details03"]            = LoadFX("maps/karma/fx_kar_fountain_details03"); 
// level._effect["fx_kar_fountain_details04"]            = LoadFX("maps/karma/fx_kar_fountain_details04"); 
// level._effect["fx_kar_screenglow_security01"]            = LoadFX("maps/karma/fx_kar_screenglow_security01");
// level._effect["fx_fog_ground_placement"]            = LoadFX("env/smoke/fx_fog_ground_placement");
// level._effect["fx_light_beam_dust_chameleon"]            = LoadFX("env/light/fx_light_beam_dust_chameleon");
// level._effect["fx_light_beam_dust"]            = LoadFX("env/light/fx_light_beam_dust");
// level._effect["fx_light_laser_smoke"]            = LoadFX("env/light/fx_light_laser_smoke");
// level._effect["fx_light_strobe01"]            = LoadFX("env/light/fx_light_strobe01");
// level._effect["fx_light_laser_fan_loop"]            = LoadFX("env/light/fx_light_laser_fan_loop");
// level._effect["fx_light_laser_smoke_loop"]            = LoadFX("env/light/fx_light_laser_smoke_loop");
// level._effect["fx_light_beams_fan_anim01"]            = LoadFX("env/light/fx_light_beams_fan_anim01");
// level._effect["fx_light_laser_shell"]            = LoadFX("env/light/fx_light_laser_shell");
// level._effect["fx_light_laser_smoke_spin"]            = LoadFX("env/light/fx_light_laser_smoke_spin");
// level._effect["fx_debris_papers_windy_os_loop"]            = LoadFX("env/debris/fx_debris_papers_windy_os_loop");
// level._effect["fx_dust_falling"]            = LoadFX("env/debris/fx_dust_falling");
// level._effect["fx_light_beams_fan_oneshot"]            = LoadFX("env/light/fx_light_beams_fan_oneshot");
// level._effect["fx_light_beams_fan_cool_oneshot"]            = LoadFX("env/light/fx_light_beams_fan_cool_oneshot");
// level._effect["fx_light_beams_fan_runner"]            = LoadFX("env/light/fx_light_beams_fan_runner");
// level._effect["fx_light_beams_fan_runner02"]            = LoadFX("env/light/fx_light_beams_fan_runner02");
// level._effect["fx_light_laser_fan_oneshot"]            = LoadFX("env/light/fx_light_laser_fan_oneshot");
// level._effect["fx_light_laser_fan_cool_oneshot"]            = LoadFX("env/light/fx_light_laser_fan_cool_oneshot");
// level._effect["fx_light_laser_fan_runner"]            = LoadFX("env/light/fx_light_laser_fan_runner");
// level._effect["fx_light_laser_shell_oneshot"]            = LoadFX("env/light/fx_light_laser_shell_oneshot");
// level._effect["fx_light_laser_shell_cool_oneshot"]            = LoadFX("env/light/fx_light_laser_shell_cool_oneshot");
// level._effect["fx_light_laser_shell_runner"]            = LoadFX("env/light/fx_light_laser_shell_runner");
// level._effect["fx_light_laser_smoke_oneshot"]            = LoadFX("env/light/fx_light_laser_smoke_oneshot");
// level._effect["fx_light_laser_smoke_cool_oneshot"]            = LoadFX("env/light/fx_light_laser_smoke_cool_oneshot");
// level._effect["fx_light_laser_smoke_runner"]            = LoadFX("env/light/fx_light_laser_smoke_runner");
// level._effect["fx_light_laser_smoke_runner02"]            = LoadFX("env/light/fx_light_laser_smoke_runner02");
// level._effect["fx_light_laser_smoke_spin_oneshot"]            = LoadFX("env/light/fx_light_laser_smoke_spin_oneshot");
// level._effect["fx_light_laser_smoke_spin_cool_oneshot"]            = LoadFX("env/light/fx_light_laser_smoke_spin_cool_oneshot");
// level._effect["fx_light_laser_smoke_spin_runner"]            = LoadFX("env/light/fx_light_laser_smoke_spin_runner");
// level._effect["bullet_time_muzzle_flash"]		= LoadFX( "maps/karma/fx_kar_bullet_runner" );
// level._effect["fx_kar_shadow_dance1"] 			= LoadFx("maps/karma/fx_kar_shadow_dance1");
// level._effect["fx_kar_club_floormist"]            = LoadFX("maps/karma/fx_kar_club_floormist");
// level._effect["fx_lf_karma"]            = LoadFX("lens_flares/fx_lf_karma");
}

/*footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
}*/


main()
{
	clientscripts\createfx\karma_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

