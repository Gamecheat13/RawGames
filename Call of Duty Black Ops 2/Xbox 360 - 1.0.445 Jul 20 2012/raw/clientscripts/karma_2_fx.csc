//
// file: karma_2_fx.gsc
// description: clientside fx script for karma_2: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 


// load fx used by util scripts
precache_util_fx()
{	

}

precache_scripted_fx()
{
//	level._effect["spiderbot_light"]	= LoadFX( "env/light/fx_spotlight_spiderbot" );
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

/*footsteps()
{
	clientscripts\_utility::setFootstepEffect( "asphalt", LoadFx( "bio/player/fx_footstep_dust" ) );
	clientscripts\_utility::setFootstepEffect( "concrete", LoadFx( "bio/player/fx_footstep_dust" ) );
}*/


main()
{
	clientscripts\createfx\karma_2_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

