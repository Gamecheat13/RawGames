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
//	level._effect["spiderbot_light"]	= LoadFX( "env/light/fx_spotlight_spiderbot" );
//	level._effect["spiderbot_scanner"]	= LoadFX( "maps/karma/fx_kar_spider_scanner" );
		
	// Section 3 blood FX	
	level._effect["defalco_blood"]	= LoadFX( "maps/karma/fx_kar_blood_defalco" );
	level._effect["karma_blood"]	= LoadFX( "maps/karma/fx_kar_blood_karma" );
	level._effect["salazar_blood"]	= LoadFX( "maps/karma/fx_kar_blood_salazar" );
	level._effect["guard_blood"] = LoadFX( "maps/karma/fx_kar_blood_enemy" );

	// Misc Explosion - Event 9
	level._effect["def_explosion"] = LoadFX( "explosions/fx_default_explosion" );

	// Event 9 - Tracers	
	level._effect["fake_tracer"] = LoadFX( "maps/karma/fx_kar_static_tracer" );
	level._effect["metal_storm_death"] = LoadFX( "explosions/fx_vexp_metalstorm01" );
	level._effect["blood_wounded_streak"] = LoadFX( "bio/player/fx_blood_wounded_streak" );
	
	level._effect["heli_missile_tracer"] = LoadFX( "weapon/rocket/fx_rocket_drone_geotrail" );
	
	// Event 10
	level._effect["light_caution_red_flash"]	= LoadFX("light/fx_light_caution_red_flash");
	level._effect["kar_exp_ship_fail_player"]	= loadFX("explosions/fx_kar_exp_ship_fail_player");

	// Balcony death blood splat
	level._effect["balcony_death_blood_splat"] = LoadFX( "maps/karma/fx_kar_blood_melee_hit" );
	
	
	// Metal Storm Damage Effects
	level._effect["metal_storm_damage_1"] = LoadFX( "vehicle/vfire/fx_metalstorm_damagestate01" );
	level._effect["metal_storm_damage_2"] = LoadFX( "vehicle/vfire/fx_metalstorm_damagestate02" );
	level._effect["metal_storm_damage_3"] = LoadFX( "vehicle/vfire/fx_metalstorm_damagestate03" );
	level._effect["metal_storm_damage_4"] = LoadFX( "vehicle/vfire/fx_metalstorm_damagestate04" );
	
	level._effect["vtol_exhaust"] = LoadFx("vehicle/exhaust/fx_exhaust_heli_vtol");
	
	level._effect[ "cutter_on" ] 						= LoadFx("props/fx_laser_cutter_on");
	level._effect[ "cutter_spark" ] 					= LoadFx("props/fx_laser_cutter_sparking");
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
	level.scr_anim["fxanim_props"]["umbrella_01"] = %fxanim_gp_umbrella_01_anim;
	level.scr_anim["fxanim_props"]["cabana_02"] = %fxanim_gp_cabana_02_anim;
	level.scr_anim["fxanim_props"]["store_bomb_01"] = %fxanim_karma_store_bomb_01_anim;
	level.scr_anim["fxanim_props"]["column_explode"] = %fxanim_karma_column_explode_anim;
	level.scr_anim["fxanim_props"]["aquarium_pillar1"] = %fxanim_karma_aquarium_pillar1_anim;
	level.scr_anim["fxanim_props"]["aquarium_pillar2"] = %fxanim_karma_aquarium_pillar2_anim;
	level.scr_anim["fxanim_props"]["aqua_shark1"] = %fxanim_karma_shark1_anim;
	level.scr_anim["fxanim_props"]["aqua_shark2"] = %fxanim_karma_shark2_anim;
	level.scr_anim["fxanim_props"]["aqua_fish1"] = %fxanim_karma_fish1_anim;
	level.scr_anim["fxanim_props"]["aqua_fish2"] = %fxanim_karma_fish2_anim;
	level.scr_anim["fxanim_props"]["aqua_fish3"] = %fxanim_karma_fish3_anim;
	level.scr_anim["fxanim_props"]["aqua_fish_sch1"] = %fxanim_karma_fish_sch1_anim;
}

// --- FX DEPT SECTION ---//
precache_createfx_fx()
{
	// EXPLODERS //
	
	// Event 7: Aftermath - gump: karma_2_gump_mall
	level._effect["fx_kar_shrimp_crowd_escape"]								= LoadFX("maps/karma/fx_kar_shrimp_crowd_escape"); // exploder 721: ,event
	level._effect["fx_kar_exp_store_front"]										= loadFX("explosions/fx_kar_exp_store_front");	// 10700
	level._effect["fx_kar_smk_fire_store_front"]							= loadFX("smoke/fx_kar_smk_fire_store_front");	// 10700
	level._effect["fx_kar_boat_wake1"]								= LoadFX("maps/karma/fx_kar_boat_wake1");
	
	// Event 8: Duty Free - gump: karma_2_gump_mall
	// ASD column destruction																																									// 10810
	level._effect["fx_kar_exp_corner_store"]									= loadFX("explosions/fx_kar_exp_corner_store");	// exploder 10910
	level._effect["fx_kar_concrete_dust_impact_corner_store"] = loadFX("dirt/fx_kar_concrete_dust_impact_corner_store");	// exploder 10911
//		// OUTDOOR FX																																						 // exploder 801: ,event -- deprecated
//		// BALCONY FX																																						 // exploder 840-841: ,event -- deprecated
//	level._effect["fx_kar_balcony_hit01"]											= LoadFX("maps/karma/fx_kar_balcony_hit01"); // exploder 842: ,event -- deprecated
//	level._effect["fx_kar_balcony_hit02"]											= LoadFX("maps/karma/fx_kar_balcony_hit02"); // exploder 843: ,event -- deprecated
//	level._effect["fx_kar_balcony_explosion01"]								= LoadFX("maps/karma/fx_kar_balcony_explosion01"); // exploder 844: ,event -- deprecated
//	level._effect["fx_kar_balcony_explosion02"]								= LoadFX("maps/karma/fx_kar_balcony_explosion02"); // 799 -- deprecated
//	level._effect["fx_kar_puff01"]														= LoadFX("maps/karma/fx_kar_puff01"); // exploder 846: ,event -- deprecated
//	level._effect["fx_kar_balcony_stairs01"]									= LoadFX("maps/karma/fx_kar_balcony_stairs01"); // exploder 846: ,event -- deprecated
	
	// Aquarium fx
	level._effect["fx_kar_exp_aquarium_pillar"]								= loadFX("explosions/fx_kar_exp_aquarium_pillar");	// 10710
	level._effect["fx_kar_aquarium_spill_xlg"]								= loadFX("water/fx_kar_aquarium_spill_xlg");	// 10710
	level._effect["fx_kar_aquarium_spill_lg"]				      		= loadFX("water/fx_kar_aquarium_spill_lg");	// 10710
	level._effect["fx_kar_aquarium_pillar_debris"]						= loadFX("maps/karma/fx_kar_aquarium_pillar_debris");	// 10711
	level._effect["fx_light_c401"]														= LoadFX("env/light/fx_light_c401");	// 750
	
	// Event 9: Little bird - gump: karma_2_gump_sundeck
	level._effect["fx_kar_concrete_pillar_dest"]							= loadFX("dirt/fx_kar_concrete_pillar_dest");	// 10915, 10916
	level._effect["fx_kar_concrete_beam_dest"]								= loadFX("dirt/fx_kar_concrete_beam_dest");	// 10915, 10916
	level._effect["fx_circlebar_glass_dome_dest"]							= loadFX("maps/karma/fx_circlebar_glass_dome_dest");	// 10915, 10916
	level._effect["fx_kar_concrete_dust_impact_circle_bar"]		= loadFX("dirt/fx_kar_concrete_dust_impact_circle_bar");	// 10917
	level._effect["fx_kar_circlebar_dest_pillar01"]						= LoadFX("maps/karma/fx_kar_circlebar_dest_pillar01"); // exploder 10915: ,event
	level._effect["fx_kar_circlebar_dest_pillar02"]						= LoadFX("maps/karma/fx_kar_circlebar_dest_pillar02"); // exploder 10916: ,event
	level._effect["fx_kar_circlebar_roof_debris"]							= LoadFX("maps/karma/fx_kar_circlebar_roof_debris"); // exploder 10917: ,event
	level._effect["fx_kar_circlebar_dest_top"]								= LoadFX("maps/karma/fx_kar_circlebar_dest_top"); // exploder 10917: ,event
	level._effect["fx_kar_circlebar_collapse_dust"]						= LoadFX("maps/karma/fx_kar_circlebar_collapse_dust"); // exploder 10917: ,event
	level._effect["fx_metalstorm_concrete"]										= LoadFX("impacts/fx_metalstorm_concrete"); // exploder 916-919: ,event
	
	// Event 10: Eye for an Eye - gump: karma_2_gump_the_end
	//level._effect["fx_kar_boat_explosion01"]         = LoadFX("maps/karma/fx_kar_boat_explosion01"); // exploder 1035: ,event
	level._effect["fx_kar_spotlight_osprey_int"]							= loadFX("light/fx_kar_spotlight_osprey_int");	// 1010
	level._effect["fx_ridiculously_large_exp_dist"]						= loadFX("explosions/fx_ridiculously_large_exp_dist");	// 1020
	level._effect["fx_kar_exp_ship_fail"]											= loadFX("explosions/fx_kar_exp_ship_fail");	// 1020
 
  // END EXPLODERS //
	
	level._effect["fx_insects_swarm_lg"]											= LoadFX("bio/insects/fx_insects_swarm_lg"); 
	level._effect["fx_seagulls_shore_distant"]								= LoadFX("maps/karma/fx_kar_seagulls_distant");
	level._effect["fx_seagulls_circle_overhead"]							= LoadFX("maps/karma/fx_kar_seagulls_overhead");
	level._effect["fx_fog_drift_slow"]												= LoadFX("fog/fx_fog_drift_slow");
	level._effect["fx_la2_light_beacon_red"]									= LoadFX("light/fx_la2_light_beacon_red");
	level._effect["fx_dust_crumble_sm_runner"]								= loadFX("dirt/fx_dust_crumble_sm_runner");
	level._effect["fx_dust_crumble_md_runner"]								= loadFX("dirt/fx_dust_crumble_md_runner");
	level._effect["fx_dust_crumble_lg_runner"]								= loadFX("dirt/fx_dust_crumble_lg_runner");
	level._effect["fx_concrete_crumble_md_line_runner"]				= loadFX("dirt/fx_concrete_crumble_md_line_runner");
	
	// Sparks
	level._effect["fx_elec_burst_shower_sm_int_runner"]				= loadFX("electrical/fx_elec_burst_shower_sm_int_runner");
	
	// Water
	level._effect["fx_water_fire_sprinkler"]									= loadFX("water/fx_water_fire_sprinkler");
	level._effect["fx_water_fire_sprinkler_dribble"]					= loadFX("water/fx_water_fire_sprinkler_dribble");
	level._effect["fx_water_fire_sprinkler_dribble_spatter"]	= loadFX("water/fx_water_fire_sprinkler_dribble_spatter");
	
	// Fires
	level._effect["fx_fire_wall_md"]													= loadFX("env/fire/fx_fire_wall_md");
	level._effect["fx_fire_column_creep_xsm"]									= loadFX("env/fire/fx_fire_column_creep_xsm");
	level._effect["fx_fire_column_creep_sm"]									= loadFX("env/fire/fx_fire_column_creep_sm");
	level._effect["fx_fire_xsm"]															= loadFX("fire/fx_fire_xsm");
	level._effect["fx_fire_line_xsm"]													= loadFX("env/fire/fx_fire_line_xsm");
	level._effect["fx_fire_line_sm"]													= loadFX("env/fire/fx_fire_line_sm");
	level._effect["fx_fire_line_sm_thin"]											= loadFX("env/fire/fx_fire_line_sm_thin");
	level._effect["fx_fire_line_md"]													= LoadFX("env/fire/fx_fire_line_md");
	level._effect["fx_fire_sm_smolder"]												= loadFX("fire/fx_fire_sm_smolder");
	level._effect["fx_embers_falling_sm"]											= loadFX("env/fire/fx_embers_falling_sm");
	level._effect["fx_embers_falling_md"]											= loadFX("env/fire/fx_embers_falling_md");
	level._effect["fx_embers_falling_lg"]											= loadFX("fire/fx_embers_falling_lg");
	
	// Smoke
	level._effect["fx_smoke_building_med"]										= LoadFX("env/smoke/fx_la_smk_plume_buidling_med");
	level._effect["fx_smk_fire_lg_black"]											= LoadFX("env/smoke/fx_smk_fire_lg_black");
	level._effect["fx_smk_fire_lg_white"]											= loadFX("smoke/fx_smk_fire_lg_white");
	level._effect["fx_smk_fire_md_black"]											= loadFX("smoke/fx_smk_fire_md_black");
	level._effect["fx_smk_plume_lg_blk_wispy_dist"]						= loadFX("smoke/fx_smk_plume_lg_blk_wispy_dist");
	level._effect["fx_smk_plume_lg_gray_wispy_dist"]					= loadFX("smoke/fx_smk_plume_lg_gray_wispy_dist");
	level._effect["fx_smk_plume_lg_gray_wispy_dist"]					= loadFX("smoke/fx_smk_plume_md_blk_wispy_dist");
	level._effect["fx_smk_plume_md_blk_wispy_dist_slow"]			= loadFX("smoke/fx_smk_plume_md_blk_wispy_dist_slow");
	level._effect["fx_smk_plume_md_gray_wispy_dist"]					= loadFX("smoke/fx_smk_plume_md_gray_wispy_dist");
	level._effect["fx_smk_plume_md_gray_wispy_dist_slow"]			= loadFX("smoke/fx_smk_plume_md_gray_wispy_dist_slow");
	level._effect["fx_smk_smolder_sm_int"]										= loadFX("smoke/fx_smk_smolder_sm_int");
	level._effect["fx_smk_smolder_rubble_lg"]									= loadFX("smoke/fx_smk_smolder_rubble_lg");
	level._effect["fx_smk_smolder_rubble_md"]									= loadFX("smoke/fx_smk_smolder_rubble_md_int");
	level._effect["fx_smk_smolder_black_slow"]								= loadFX("smoke/fx_smk_smolder_black_slow");
	level._effect["fx_smk_smolder_gray_slow"]									= loadFX("smoke/fx_smk_smolder_gray_slow");
	level._effect["fx_smk_smolder_gray_slow_shrt"]						= loadFX("smoke/fx_smk_smolder_gray_slow_shrt");
	level._effect["fx_smk_smolder_gray_fast"]									= loadFX("smoke/fx_smk_smolder_gray_fast");
	level._effect["fx_smk_ceiling_crawl"]											= loadFX("smoke/fx_smk_ceiling_crawl");
	level._effect["fx_smk_fire_md_gray_int"]									= loadFX("env/smoke/fx_smk_fire_md_gray_int");
	level._effect["fx_kar_smk_fire_stairwell"]								= loadFX("smoke/fx_kar_smk_fire_stairwell");
	level._effect["fx_smk_hallway_md"]												= loadFX("smoke/fx_smk_hallway_md");
	level._effect["fx_smk_field_room_md"]											= loadFX("smoke/fx_smk_field_room_md_hvy");
	level._effect["fx_smk_door_crack_exit_dark"]							= loadFX("smoke/fx_smk_door_crack_exit_dark");
}

wind_initial_setting()
{
	SetSavedDvar( "wind_global_vector", "-145 143 0" );		// change "0 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", -3367);			// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 1500);			// change 10000 to your wind's upper bound
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
	maps\createfx\karma_2_fx::main();
	maps\karma_exit_club::karma2_hide_tower_and_shell();

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
	maps\karma_2_anim::exit_club_anims();
	maps\karma_2_anim::mall_anims();
	maps\karma_2_anim::sundeck_anims();
	maps\karma_2_anim::the_end_anims();

//	add_gump_function( "karma_gump_mall", 		::createfx_setup_gump_mall );
//	add_gump_function( "karma_gump_sundeck", 			::createfx_setup_gump_sundeck );
//	add_gump_function( "karma_gump_the_end",	::createfx_setup_gump_the_end );

	// Since we're not doing the full init, just set the skipto name
	level.skipto_point = ToLower( GetDvar( "skipto" ) );
	if ( level.skipto_point == "" )
	{
		level.skipto_point = "e7_exit_club";
	}
	maps\karma_2::load_gumps_karma();
}

createfx_setup_gump_mall()
{
}

createfx_setup_gump_sundeck()
{
}

createfx_setup_gump_the_end()
{
}

