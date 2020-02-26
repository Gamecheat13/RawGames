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
	level._effect["spiderbot_light"]	= LoadFX( "env/light/fx_spotlight_spiderbot" );
}


// --- FX DEPARTMENT SECTION ---//
precache_createfx_fx()
{
// EXPLODERS //
  
  // LEVEL START FX LEVEL START FX LEVEL START FX LEVEL START FX LEVEL START FX LEVEL START FX LEVEL START FX // exploder 101: ,event
  level._effect["fx_kar_shrimp_crowd_neutral"]            = LoadFX("maps/karma/fx_kar_shrimp_crowd_neutral"); // exploder 330: ,event
  // AMBIENT SEAGULLS AMBIENT SEAGULLS AMBIENT SEAGULLS AMBIENT SEAGULLS AMBIENT SEAGULLS AMBIENT SEAGULLS // exploder 331: ,event 
  level._effect["fx_kar_bug_zapped_intro"]         = LoadFX("maps/karma/fx_kar_bug_zapped_intro"); // exploder 441: ,event
  level._effect["fx_kar_bug_zapped_scared"]         = LoadFX("maps/karma/fx_kar_bug_zapped_scared"); // exploder 442: ,event
  level._effect["fx_kar_bug_zapped"]         = LoadFX("maps/karma/fx_kar_bug_zapped"); // exploder 443: ,event
  level._effect["fx_kar_elec_vent_spark"]         = LoadFX("maps/karma/fx_kar_elec_vent_spark"); // exploder 444: ,event
  level._effect["fx_kar_elec_vent_field"]         = LoadFX("maps/karma/fx_kar_elec_vent_field"); // exploder 445: ,event
  level._effect["fx_powerbutton_blink_green_sm"]         = LoadFX("light/fx_powerbutton_blink_green_sm"); // exploder 446: ,event
  level._effect["fx_powerbutton_constant_green_sm"]         = LoadFX("light/fx_powerbutton_constant_green_sm"); // exploder 446: ,event
  level._effect["fx_light_alarm01"]            = LoadFX("env/light/fx_light_alarm01"); // exploder 475: ,event
  level._effect["fx_shrimp_kar_dance_female_a"]          = LoadFX("bio/shrimps/fx_shrimp_kar_dance_female_a"); // exploder 621-623: ,event
  level._effect["fx_shrimp_kar_dance_female_b"]          = LoadFX("bio/shrimps/fx_shrimp_kar_dance_female_b"); // exploder 621-623: ,event
  level._effect["fx_shrimp_kar_dance_male_a"]            = LoadFX("bio/shrimps/fx_shrimp_kar_dance_male_a"); // exploder 621-623: ,event
  level._effect["fx_shrimp_kar_dance_male_b"]            = LoadFX("bio/shrimps/fx_shrimp_kar_dance_male_b"); // exploder 621-623: ,event
  level._effect["fx_shrimp_group_dance01"]            = LoadFX("bio/shrimps/fx_shrimp_group_dance01"); // exploder 621-623: ,event
  level._effect["fx_shrimp_group_dance02"]            = LoadFX("bio/shrimps/fx_shrimp_group_dance02"); // exploder 621-623: ,event
  level._effect["fx_shrimp_group_hangout01"]            = LoadFX("bio/shrimps/fx_shrimp_group_hangout01"); // exploder 621-623: ,event
  level._effect["fx_shrimp_group_hangout02"]            = LoadFX("bio/shrimps/fx_shrimp_group_hangout02"); // exploder 621-623: ,event
  // CLUB FX CLUB FX CLUB FX CLUB FX CLUB FX CLUB FX CLUB FX CLUB FX CLUB FX CLUB FX CLUB FX CLUB FX CLUB FX // exploder 620: ,event
  level._effect["fx_kar_club_spotlight"]            = LoadFX("maps/karma/fx_kar_club_spotlight"); // exploder 620: ,event
  level._effect["fx_kar_club_dancefloor"]            = LoadFX("maps/karma/fx_kar_club_dancefloor"); // exploder 620: ,event
  level._effect["fx_kar_shrimp_crowd_escape"]            = LoadFX("maps/karma/fx_kar_shrimp_crowd_escape"); // exploder 721: ,event
  // OUTDOOR FX OUTDOOR FX OUTDOOR FX OUTDOOR FX OUTDOOR FX OUTDOOR FX OUTDOOR FX OUTDOOR FX OUTDOOR FX // exploder 801: ,event
  // BALCONY FX BALCONY FX BALCONY FX BALCONY FX BALCONY FX BALCONY FX BALCONY FX BALCONY FX BALCONY FX // exploder 840-841: ,event
  level._effect["fx_kar_balcony_hit01"]         = LoadFX("maps/karma/fx_kar_balcony_hit01"); // exploder 842: ,event
  level._effect["fx_kar_balcony_hit02"]         = LoadFX("maps/karma/fx_kar_balcony_hit02"); // exploder 843: ,event
  level._effect["fx_kar_balcony_explosion01"]         = LoadFX("maps/karma/fx_kar_balcony_explosion01"); // exploder 844: ,event
  level._effect["fx_kar_balcony_explosion02"]         = LoadFX("maps/karma/fx_kar_balcony_explosion02"); // exploder 845: ,event
  level._effect["fx_kar_balcony_stairs01"]         = LoadFX("maps/karma/fx_kar_balcony_stairs01"); // exploder 846: ,event
  level._effect["fx_kar_circlebar_dest_pillar01"]         = LoadFX("maps/karma/fx_kar_circlebar_dest_pillar01"); // exploder 913: ,event
  level._effect["fx_kar_circlebar_dest_pillar02"]         = LoadFX("maps/karma/fx_kar_circlebar_dest_pillar02"); // exploder 914: ,event
  level._effect["fx_kar_circlebar_dest_top"]         = LoadFX("maps/karma/fx_kar_circlebar_dest_top"); // exploder 915: ,event
  level._effect["fx_metalstorm_concrete"]         = LoadFX("impacts/fx_metalstorm_concrete"); // exploder 916-919: ,event
  level._effect["fx_kar_boat_explosion01"]         = LoadFX("maps/karma/fx_kar_boat_explosion01"); // exploder 1035: ,event
 
 // END EXPLODERS //
 
 level._effect["fx_lensflare_exp_hexes_sm"]            = LoadFX("light/fx_lensflare_exp_hexes_sm");
 level._effect["fx_tools_blend_test"]            = LoadFX("fx_tools/fx_tools_blend_test"); 
 level._effect["fx_kar_fog_machine"]            = LoadFX("maps/karma/fx_kar_fog_machine"); 
 level._effect["fx_kar_vent_steam01"]            = LoadFX("maps/karma/fx_kar_vent_steam01"); 
 level._effect["fx_kar_vent_steam02"]            = LoadFX("maps/karma/fx_kar_vent_steam02"); 
 level._effect["fx_light_caution_orange_flash"]            = LoadFX("light/fx_light_caution_orange_flash"); 
 level._effect["fx_insects_swarm_lg"]            = LoadFX("bio/insects/fx_insects_swarm_lg"); 

 level._effect["fx_seagulls_shore_distant"]            = LoadFX("maps/karma/fx_kar_seagulls_distant");
 level._effect["fx_seagulls_circle_overhead"]            = LoadFX("maps/karma/fx_kar_seagulls_overhead");
 level._effect["fx_snow_windy_heavy_md_slow"]            = LoadFX("env/weather/fx_snow_windy_heavy_md_slow");
  
 level._effect["fx_fog_ground_placement"]            = LoadFX("env/smoke/fx_fog_ground_placement");
 level._effect["fx_kar_dust_vent_sm"]            = LoadFX("maps/karma/fx_kar_dust_vent_sm");
 level._effect["fx_light_beam_dust_chameleon"]            = LoadFX("env/light/fx_light_beam_dust_chameleon");
 level._effect["fx_light_beam_dust"]            = LoadFX("env/light/fx_light_beam_dust");
 level._effect["fx_light_beams_smoke_hard"]            = LoadFX("env/light/fx_light_beams_smoke_hard");
 level._effect["fx_light_beams_smoke"]            = LoadFX("env/light/fx_light_beams_smoke");
 level._effect["fx_light_laser_smoke"]            = LoadFX("env/light/fx_light_laser_smoke");
 level._effect["fx_light_strobe01"]            = LoadFX("env/light/fx_light_strobe01");
 level._effect["fx_light_strobe02"]            = LoadFX("env/light/fx_light_strobe02");
 level._effect["fx_light_laser_fan_loop"]            = LoadFX("env/light/fx_light_laser_fan_loop");
 level._effect["fx_light_laser_smoke_loop"]            = LoadFX("env/light/fx_light_laser_smoke_loop");
 level._effect["fx_light_beams_fan_anim01"]            = LoadFX("env/light/fx_light_beams_fan_anim01");
 level._effect["fx_light_laser_shell"]            = LoadFX("env/light/fx_light_laser_shell");
 level._effect["fx_light_laser_smoke_spin"]            = LoadFX("env/light/fx_light_laser_smoke_spin");
 level._effect["fx_light_c401"]            = LoadFX("env/light/fx_light_c401");
 level._effect["fx_debris_papers_windy_os_loop"]            = LoadFX("env/debris/fx_debris_papers_windy_os_loop");
 level._effect["fx_dust_falling"]            = LoadFX("env/debris/fx_dust_falling");
 
  level._effect["fx_smk_fire_lg_black"]            = LoadFX("env/smoke/fx_smk_fire_lg_black");
  level._effect["fx_fire_line_md"]             		= LoadFX("env/fire/fx_fire_line_md");

}

footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
}


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

