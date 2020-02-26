//
// file: ber3_fx.gsc
// description: fx script for berlin3: setup, special fx functions, etc.
// scripter: slayback
//

#include maps\_utility;
main()
{
	precache_util_fx();
	precache_createfx_fx();
	maps\createart\ber3_art::main(); //Added by Rich 05/07/08 calls the ber3_art.gsc that controls the vision sets and fog
	maps\createfx\ber3_fx::main();
//	fog_settings();
//	thread vision_settings(); //Added by Rich 5/7/2008 NOW HANDLED BY ber3_art.gsc
	thread wind_settings();
	spawnFX();
}

// load fx used by util scripts
precache_util_fx()
{	
	level._effect["flesh_hit"] 					= Loadfx( "impacts/flesh_hit" );
	
	level._effect["shreck_trail"]				= loadfx("weapon/rocket/fx_trail_bazooka_geotrail");
	level._effect["shreck_explode"]				= loadfx("Weapon/Rocket/fx_LCI_rocket_explosion_beach");
	
	level._effect["distant_muzzleflash"] =	loadfx("weapon/muzzleflashes/fx_50cal");	
	level._effect["reich_tracer"] = loadfx("weapon/tracer/fx_tracer_single_md");
	
	// katyusha particles
	level._effect["katyusha_rocket_launch"] = LoadFX("weapon/muzzleflashes/fx_rocket_katyusha_launch");
	level._effect["katyusha_rocket_trail"] = LoadFX( "weapon/rocket/fx_rocket_katyusha_geotrail" );
	level._effect["katyusha_rocket_explosion"] = LoadFX( "weapon/rocket/fx_LCI_rocket_explosion_beach" );	
	level._effect["rocket_launch"]					= loadfx("weapon/muzzleflashes/fx_rocket_katyusha_launch");
	level._effect["rocket_trail"]					= loadfx("weapon/rocket/fx_rocket_katyusha_geotrail");
	level._effect["rocket_explode"]					= loadfx("weapon/rocket/fx_LCI_rocket_explosion_beach");
	//level._effect["rocket_explode_far"]				= loadfx("maps/ber1/fx_exp_katyusha_barrage_far");	
	
	// pak43 particles
	level._effect["pak43_trail"] = LoadFX( "weapon/artillery/fx_artillery_pak43_geotrail" );
	level._effect["pak43_muzzleflash"] = LoadFX( "weapon/artillery/fx_artillery_pak43_muz" );
	level._effect["pak43_impact"] = LoadFX( "explosions/default_explosion" );	
	
	level._effect["brick_explode"] = LoadFX( "maps/ber3/fx_exp_wall_bricks" );
	
	// For molotov toss animation
	level._effect["molotov_trail_fire"] = LoadFx( "weapon/molotov/fx_molotov_wick" );
	level._effect["molotov_explosion"] = LoadFx( "weapon/molotov/fx_molotov_exp" );
	
	// Chernov's finale
	level._effect["pillar_cover_smoke"] = loadfx("maps/ber3/fx_column_collapse_cover");
	level._effect["flame_death1"] = loadfx("env/fire/fx_fire_player_sm");
	level._effect["flame_death2"] = loadfx("env/fire/fx_fire_player_torso_mp");
	
	// Mortar stuff
	level.scr_sound["mortar_flash"] = "wpn_mortar_fire";
	level._effect["mortar_flash"] = loadfx("weapon/mortar/fx_mortar_launch_w_trail");	
	
	//dirt mortars
	level._effectType["dirt_mortar"] 			= "mortar";
	level._effect["dirt_mortar"]					= loadfx("weapon/mortar/fx_mortar_exp_dirt_brown");
	level.explosion_stopNotify["dirt_mortar"] = "stop_ambush_mortars";	
	
	// ai flame fx
	level._effect["character_fire_pain_sm"] 		 = LoadFx( "env/fire/fx_fire_player_sm_1sec" ); 
	level._effect["character_fire_death_sm"] 		 = LoadFx( "env/fire/fx_fire_player_md" ); 
	level._effect["character_fire_death_torso"] 	 = LoadFx( "env/fire/fx_fire_player_torso" ); 	
	
	// flamethrower guy death
	level._effect["flameguy_explode"] = LoadFX( "explosions/fx_flamethrower_char_explosion" );	
	
	// Statue fx
	level._effect["e2_statue_explode"] = LoadFX( "maps/ber3/fx_exp_statue" );
}

//////////////////////////////////////////////////////////////////////////////////////
///////////////////////BARRY'S SECTION	//////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////
precache_createfx_fx()
{
	level._effect["fire_static_detail"]					= loadfx("env/fire/fx_static_fire_detail_ndlight");
	level._effect["fire_static_small"]					= loadfx("env/fire/fx_static_fire_sm_ndlight");
	level._effect["fire_static_blk_smk"]				= loadfx("env/fire/fx_static_fire_md_ndlight");
	level._effect["dlight_fire_glow"]						= loadfx("env/light/fx_dlight_fire_glow");

	level._effect["fire_distant_150_150"]				= loadfx("env/fire/fx_fire_150x150_tall_distant");
	level._effect["fire_distant_150_600"]				= loadfx("env/fire/fx_fire_150x600_tall_distant");

	level._effect["fire_wall_100_150"]							= loadfx("env/fire/fx_fire_wall_smk_0x100y155z");
	level._effect["fire_ceiling_100_100"]						= loadfx("env/fire/fx_fire_ceiling_100x100");
	level._effect["fire_ceiling_300_300"]						= loadfx("env/fire/fx_fire_ceiling_300x300");
	level._effect["fire_win_smk_0x35y50z_blk"]			= loadfx("env/fire/fx_fire_win_smk_0x35y50z_blk");
	level._effect["fire_window_nsmk"]								= loadfx("env/fire/fx_fire_win_nsmk_0x35y50z");
	level._effect["fire_tree"]											= loadfx("env/fire/fx_fire_smoke_tree_trunk_med_w");
	level._effect["a_fire_rubble_detail"]						= loadfx("env/fire/fx_fire_rubble_detail");
	level._effect["a_fire_rubble_detail_grp"]				= loadfx("env/fire/fx_fire_rubble_detail_grp");
	level._effect["a_fire_rubble_md"]								= loadfx("env/fire/fx_fire_rubble_md");
	level._effect["a_fire_rubble_md_lowsmk"]				= loadfx("env/fire/fx_fire_rubble_md_lowsmk");
	level._effect["a_fire_rubble_sm"]								= loadfx("env/fire/fx_fire_rubble_sm");
	level._effect["a_fire_rubble_sm_column"]				= loadfx("env/fire/fx_fire_rubble_sm_column");
	level._effect["a_fire_rubble_sm_column_smldr"]	= loadfx("env/fire/fx_fire_rubble_sm_column_smldr");
	
	level._effect["smoke_detail"]								= loadfx("env/smoke/fx_smoke_smolder_sm_blk");
	level._effect["smoke_battle_mist"]					= loadfx("env/smoke/fx_battlefield_smokebank_ling_lg_w");
	level._effect["smoke_plume_sm_fast_blk_w"]	= loadfx("env/smoke/fx_smoke_plume_sm_fast_blk_w");
	level._effect["smoke_plume_md_slow_def"]		= loadfx("env/smoke/fx_smoke_plume_md_slow_def");
	level._effect["smoke_plume_lg_slow_blk"]		= loadfx("env/smoke/fx_smoke_plume_xlg_slow_blk");
	level._effect["smoke_plume_lg_slow_def"]		= loadfx("env/smoke/fx_smoke_plume_lg_slow_def");
	level._effect["smoke_hallway_thick_dark"]		= loadfx("env/smoke/fx_smoke_hall_ceiling_600");
	level._effect["smoke_hallway_faint_dark"]		= loadfx("env/smoke/fx_smoke_hallway_faint_dark");
	level._effect["smoke_window_out"]						= loadfx("env/smoke/fx_smoke_door_top_exit_drk");
	level._effect["a_smoke_smolder_md_gry"]			= loadfx("env/smoke/fx_smoke_smolder_md_gry");
	level._effect["a_smokebank_thick_dist1"]		= loadfx("maps/ber3/fx_smokebank_thick_dist1");
	level._effect["a_smokebank_thick_dist2"]		= loadfx("maps/ber3/fx_smokebank_thick_dist2");
	level._effect["a_smokebank_thick_dist3"]		= loadfx("maps/ber3/fx_smokebank_thick_dist3");
	level._effect["a_smokebank_thin_dist1"]			= loadfx("maps/ber3/fx_smokebank_thin_dist1");
	
	level._effect["water_single_leak"]					= loadfx("env/water/fx_water_single_leak");
	level._effect["water_leak_runner"]					= loadfx("env/water/fx_water_leak_runner_100");
	
	level._effect["debris_paper_falling"]				= loadfx("maps/ber3/fx_debris_papers_falling");
	level._effect["debris_wood_burn_fall"]			= loadfx("maps/ber3/fx_debris_burning_wood_fall");
	level._effect["a_dust_falling_sm"]					= loadfx("env/dirt/fx_dust_falling_sm");
	level._effect["a_dust_falling_md"]					= loadfx("env/dirt/fx_dust_falling_md");
	level._effect["a_column_collapse_ground"]		= loadfx("maps/ber3/fx_column_collapse_ground");
	level._effect["a_column_collapse_ground_end"]		= loadfx("maps/ber3/fx_column_collapse_ground_end");
	level._effect["a_column_collapse_thick"]		= loadfx("maps/ber3/fx_column_collapse_ground_thick");
	level._effect["a_debris_papers_windy"]			= loadfx("maps/ber3/fx_debris_papers_windy");

	level._effect["wire_sparks"]								= loadfx("env/electrical/fx_elec_wire_spark_burst");
	level._effect["wire_sparks_blue"]						= loadfx("env/electrical/fx_elec_wire_spark_burst_blue");

	level._effect["ash_and_embers"]							= loadfx("env/fire/fx_ash_embers_light");	
	level._effect["flak_field"]									= loadfx("weapon/flak/fx_flak_field_8k_dist");
	level._effect["a_flak_field_cloudflash"]		= loadfx("weapon/flak/fx_flak_cloudflash_8k");
	level._effect["a_tracers_flak88_amb"]				= loadfx("maps/ber3/fx_tracers_flak88_amb");
	level._effect["a_tracers_flak88_dir"]				= loadfx("maps/ber3/fx_tracers_flak88_dir");
	level._effect["bio_flies"]									= loadfx("bio/insects/fx_insects_carcass_flies");
	level._effect["bio_crows_overhead"]					= loadfx("bio/animals/fx_crows_circling");
}

// Global Wind Settings
wind_settings()
{
	// These values are supposed to be in inches per second.
	SetSavedDvar( "wind_global_vector", "-176 70 0" );
	SetSavedDvar( "wind_global_low_altitude", 26 );
	SetSavedDvar( "wind_global_hi_altitude", 3000 );
	SetSavedDvar( "wind_global_low_strength_percent", 0.3 );
}

// fog_settings() NOW HANDLED BY ber_art.gsc
// {
	// temp settings for split screen fog
//	start_dist 		= 700;
//	halfway_dist 	= 2000;
//	halfway_height 	= 350;
//	base_height 	= 0;
//	red 			= 0.115;
//	green 			= 0.123;
//	blue		 	= 0.141;
//	trans_time		= 0;
//
//	if( IsSplitScreen() )
//	{
//		halfway_height 	= 10000;
//		cull_dist 		= 2000;
//		set_splitscreen_fog( start_dist, halfway_dist, halfway_height, base_height, red, green, blue, trans_time, cull_dist );
//	}
// }

spawnFX()
{
	
}

//////////////////////////////////////////////////////////////////////////////////////
///////////////////////RICH'S SECTION	//////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////NOW HANDLED BY ber3_art.gsc
//Rich's Section - Handles Vision And Fog Settings - Added 5/7/2008
// vision_settings()//- Handles Vision And Fog Settings - Added 5/7/2008
// {
// 	wait .5;
	//VisionSetNaked( "ber3", 0 );
//	
//	set_all_players_visionset("ber3", 0);
// }