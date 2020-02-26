#include maps\_utility;
#include common_scripts\utility;
#include maps\_anim;
#using_animtree("fxanim_props");

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

// fx used by util scripts
precache_util_fx()
{
}

// Scripted effects
precache_scripted_fx()
{
	level._effect[ "sniper_glint" ]		= LoadFX( "misc/fx_misc_sniper_scope_glint" );

	level._effect[ "flesh_hit" ]		= LoadFX( "impacts/fx_flesh_hit" );

	// Scanner alert ping
	level._effect["scanner_ping"]	= LoadFX( "misc/fx_weapon_indicator01" );
	
	// Spiderbot
	level._effect["spiderbot_light"]	= LoadFX( "env/light/fx_spotlight_spiderbot" );
	level._effect["spiderbot_scanner"]	= LoadFX( "maps/karma/fx_kar_spider_scanner" );
		
	// Section 3 blood FX	
	level._effect["defalco_blood"]	= LoadFX( "maps/karma/fx_kar_blood_defalco" );
	level._effect["karma_blood"]	= LoadFX( "maps/karma/fx_kar_blood_karma" );
	level._effect["salazar_blood"]	= LoadFX( "maps/karma/fx_kar_blood_salazar" );

	// MikeA - Shrimp test FX
	level._effect["shrimp_dance_front"]		= LoadFX( "bio/shrimps/fx_shrimp_karma_dance_front" );
	level._effect["shrimp_run_left"]		= LoadFX( "bio/shrimps/fx_shrimp_karma_run_left" );
	level._effect["shrimp_run_right"]		= LoadFX( "bio/shrimps/fx_shrimp_karma_run_right" );
	
	// Misc Explosion - Event 9
	level._effect["def_explosion"] = LoadFX( "explosions/fx_default_explosion" );

	// Event 9 - Tracers	
	level._effect["fake_tracer"] = LoadFX( "maps/karma/fx_kar_static_tracer" );
	level._effect["metal_storm_death"] = LoadFX( "explosions/fx_vexp_metalstorm01" );
	level._effect["blood_wounded_streak"] = LoadFX( "bio/player/fx_blood_wounded_streak" );
	
	level._effect["heli_missile_tracer"] = LoadFX( "weapon/rocket/fx_rocket_drone_geotrail" );
	
	
	// Metal Storm Damage Effects
	level._effect["metal_storm_damage_1"] = LoadFX( "vehicle/vfire/fx_metalstorm_damagestate01" );
	level._effect["metal_storm_damage_2"] = LoadFX( "vehicle/vfire/fx_metalstorm_damagestate02" );
	level._effect["metal_storm_damage_3"] = LoadFX( "vehicle/vfire/fx_metalstorm_damagestate03" );
	level._effect["metal_storm_damage_4"] = LoadFX( "vehicle/vfire/fx_metalstorm_damagestate04" );
}


// FXanim Props
initModelAnims()
{
	level.scr_anim["fxanim_props"]["tree_palm_sm_dest01"] = %fxanim_gp_tree_palm_sm_dest01_anim;
	level.scr_anim["fxanim_props"]["seagull_circle_01"] = %fxanim_gp_seagull_circle_01_anim;
	level.scr_anim["fxanim_props"]["seagull_circle_02"] = %fxanim_gp_seagull_circle_02_anim;
	level.scr_anim["fxanim_props"]["seagull_circle_03"] = %fxanim_gp_seagull_circle_03_anim;
	level.scr_anim["fxanim_props"]["circle_bar"] = %fxanim_karma_circle_bar_anim;
	level.scr_anim["fxanim_props"]["balcony_block"] = %fxanim_karma_balcony_block_anim;
}

// --- FX DEPT SECTION ---//
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

wind_initial_setting()
{
	SetSavedDvar( "wind_global_vector", "0.01 .01 .01" );			// change "0 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0);						// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 2775);					// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.5);	// change 0.5 to your desired wind strength percentage

}

main()
{
	initModelAnims();
	precache_util_fx();
	precache_scripted_fx();
	precache_createfx_fx();

	footsteps();

	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\karma_fx::main();

	wind_initial_setting();
}

footsteps()
{
	LoadFx( "bio/player/fx_footstep_dust" );
	LoadFx( "bio/player/fx_footstep_dust" );
}

