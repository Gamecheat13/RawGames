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

	level._effect[ "parting_clouds" ]	= LoadFX( "maps/karma/fx_kar_flight_intro" );
	
	// the fx fo karma vtol - PC (03/24/12)
	level._effect[ "flight_spotlight" ]					= LoadFX( "maps/karma/fx_kar_flight_spotlight" );
	level._effect[ "flight_hologram" ]					= LoadFX( "maps/karma/fx_kar_flight_hologram" );
	level._effect[ "flight_lights_glows1" ]				= LoadFX( "maps/karma/fx_kar_flight_lights_bulk_glows" );
	level._effect[ "flight_lights_centers1" ]			= LoadFX( "maps/karma/fx_kar_flight_lights_bulk_centers" );
	level._effect[ "flight_lights_glows2" ]				= LoadFX( "maps/karma/fx_kar_flight_lights_leftover_glows" );
	level._effect[ "flight_lights_centers2" ]			= LoadFX( "maps/karma/fx_kar_flight_lights_leftover_centers" );
	level._effect[ "flight_overhead_panel_centers" ]	= LoadFX( "maps/karma/fx_kar_flight_lights_bulk2_centers" );
	level._effect[ "flight_overhead_panel_glows" ]		= LoadFX( "maps/karma/fx_kar_flight_lights_bulk2_glows" );
	level._effect[ "flight_overhead_panel_centers2" ]	= LoadFX( "maps/karma/fx_kar_flight_lights_leftover2_centers" );
	level._effect[ "flight_overhead_panel_glows2" ]		= LoadFX( "maps/karma/fx_kar_flight_lights_leftover2_glows" );
	level._effect[ "flight_access_panel_01" ]			= LoadFX( "maps/karma/fx_kar_flight_lights3" );
	level._effect[ "flight_access_panel_02" ]			= LoadFX( "maps/karma/fx_kar_flight_lights4" );
	level._effect[ "flight_lights_3p" ]					= LoadFX( "maps/karma/fx_kar_flight_lights_3p" );
	level._effect[ "flight_tread_player" ]				= LoadFX( "maps/karma/fx_kar_vtol_tread_1p" );
	level._effect[ "vtol_exhaust" ] 					= LoadFx("vehicle/exhaust/fx_exhaust_heli_vtol");

	// Scanner alert ping
	level._effect["scanner_ping"]						= LoadFX( "misc/fx_weapon_indicator01" );
	
  level._effect["crc_neck_stab_blood"]									= loadFX( "maps/karma/fx_kar_blood_neck_stab" );
  level._effect["crc_neck_slash_blood"]									= loadFX( "maps/karma/fx_kar_blood_neck_child" );

	// Elevators
	level._effect["elevator_light"]						= LoadFX( "light/fx_kar_light_spot_elevator" );
	// Spiderbot
	level._effect["spiderbot_scanner"]					= LoadFX( "maps/karma/fx_kar_spider_scanner" );
		
	level._effect["blood_spurt"]						= LoadFX( "maps/karma/fx_kar_blood_meatshield" );
	level._effect["muzzle_flash"]						= LoadFX( "maps/karma/fx_kar_muzzleflash01" );

	// Club
	level._effect["planet_static"]					= LoadFX( "maps/karma/fx_kar_hologram_static1" );
	level._effect["club_dance_floor_laser"]			= LoadFX( "maps/karma/fx_kar_light_projectors2" );
	level._effect["club_dj_cage_laser"]				= LoadFX( "maps/karma/fx_kar_laser_cage1" );
	level._effect["club_dj_front_laser1"]			= LoadFX( "maps/karma/fx_kar_laser_stage1" );
	level._effect["club_dj_front_laser2"]			= LoadFX( "maps/karma/fx_kar_laser_stage2" );
	level._effect["club_dance_floor_laser"]			= LoadFX( "maps/karma/fx_kar_light_projectors2");
	level._effect["club_dj_cage_laser"]				= LoadFX( "maps/karma/fx_kar_laser_cage1");
	level._effect["club_dj_front_laser2_disco"]		= LoadFX( "maps/karma/fx_kar_laser_stage2_disco");
	level._effect["club_dj_front_laser2_fan"]		= LoadFX( "maps/karma/fx_kar_laser_stage2_fan");
	level._effect["club_dj_front_laser2_light"]		= LoadFX( "maps/karma/fx_kar_laser_stage2_light");
	level._effect["club_dj_front_laser2_roller"]	= LoadFX( "maps/karma/fx_kar_laser_stage2_roller");
	level._effect["club_dj_front_laser2_shell"]		= LoadFX( "maps/karma/fx_kar_laser_stage2_shell");
	level._effect["club_dj_front_laser2_smoke"]		= LoadFX( "maps/karma/fx_kar_laser_stage2_smoke");
	level._effect["club_sun"]						= LoadFX( "maps/karma/fx_kar_globe_glow1" );
	level._effect["club_sun_small"]					= LoadFX( "maps/karma/fx_kar_globe_glow2" );

	level._effect["club_dj_front_laser_static" ]	= LoadFX( "maps/karma/fx_kar_laser_static1" );	// Laser goes on the fritz
	level._effect["execution_blood"]				= LoadFX( "maps/karma/fx_kar_blood_execution1" );	// Defalco execution
	level._effect["club_tracers"]					= LoadFX( "maps/karma/fx_kar_club_tracers1" );		// when player runs to bar

	level._effect["light_caution_red_flash"]            = LoadFX("light/fx_light_caution_red_flash");
	level._effect["light_caution_orange_flash"]            = LoadFX("light/fx_light_caution_orange_flash"); 
	level._effect["kar_ashtray01"]            = LoadFX("maps/karma/fx_kar_ashtray01");
	level._effect["kar_candle01"]            = LoadFX("maps/karma/fx_kar_candle01");
	level._effect["kar_shrimp_civ"] 			= LoadFx("maps/karma/fx_kar_shrimp_01" );
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
	level.scr_anim["fxanim_props"]["club_dj_lasers"] = %fxanim_karma_club_dj_lasers_anim;
	level.scr_anim["fxanim_props"]["club_dj_light_cage"] = %fxanim_karma_club_dj_light_cage_anim;
	level.scr_anim["fxanim_props"]["club_top_lasers"] = %fxanim_karma_club_top_lasers_anim;
	level.scr_anim["fxanim_props"]["windsock_01"] = %fxanim_gp_windsock_anim;
	level.scr_anim["fxanim_props"]["rail_chain"] = %fxanim_karma_rail_chain_anim;
	level.scr_anim["fxanim_props"]["step_sign"] = %fxanim_karma_step_sign_anim;
	level.scr_anim["fxanim_props"]["club_bar_shelves_01"] = %fxanim_karma_club_bar_shelves_01_anim;
	level.scr_anim["fxanim_props"]["club_bar_shelves_02"] = %fxanim_karma_club_bar_shelves_02_anim;
	level.scr_anim["fxanim_props"]["club_lights_fall_01"] = %fxanim_karma_club_lights_fall_01_anim;
	level.scr_anim["fxanim_props"]["club_lights_fall_02"] = %fxanim_karma_club_lights_fall_02_anim;
	level.scr_anim["fxanim_props"]["tarp_shootdown_01"] = %fxanim_gp_tarp_shootdown_01_anim;
	level.scr_anim["fxanim_props"]["tarp_shootdown_02"] = %fxanim_gp_tarp_shootdown_02_anim;
	level.scr_anim["fxanim_props"]["tarp_shootdown_bloody"] = %fxanim_gp_tarp_shootdown_bloody_anim;
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

wind_initial_setting()
{
	SetSavedDvar( "wind_global_vector", "86.1767 149.316 18.6" );			// change "0 0 0" to your wind vector
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


//*************************************************
//	CREATEFX
//*************************************************
createfx_setup()
{
	// Need to define all scene anims so the ents used in them don't get deleted.
	maps\karma_anim::arrival_anims();
	maps\karma_anim::checkin_anims();
	maps\karma_anim::dropdown_anims();
	maps\karma_anim::spiderbot_anims();
	maps\karma_anim::construction_anims();
	maps\karma_anim::club_anims();

//	add_gump_function( "karma_gump_checkin", 		::createfx_setup_gump_checkin );
//	add_gump_function( "karma_gump_hotel", 			::createfx_setup_gump_hotel );
//	add_gump_function( "karma_gump_construction",	::createfx_setup_gump_construction );
//	add_gump_function( "karma_gump_club", 			::createfx_setup_gump_club );

	// Since we're not doing the full init, just set the skipto name
	level.skipto_point = ToLower( GetDvar( "skipto" ) );
	if ( level.skipto_point == "" )
	{
		level.skipto_point = "e1_arrival";
	}
	maps\karma::load_gumps_karma();
}

createfx_setup_gump_checkin()
{
}

createfx_setup_gump_hotel()
{
}

createfx_setup_gump_construction()
{
}

createfx_setup_gump_club()
{
}
