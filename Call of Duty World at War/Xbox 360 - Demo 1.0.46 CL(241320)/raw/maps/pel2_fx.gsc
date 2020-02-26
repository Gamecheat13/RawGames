// Pel2 fx script
#include maps\_utility;
#include common_scripts\utility;

main()
{
	precachefx();
	spawnfx();
	
	footsteps();
	
	maps\createart\pel2_art::main();
	//fire_flicker_init();
	level thread wind_settings();
	level thread vision_settings();//added by Rich 3/28
}



// Global Wind Settings
wind_settings()
{
	// These values are supposed to be in inches per second.
	SetSavedDvar( "wind_global_vector", "171 -140 0" ); // (171, -140) = 13.3 mph w/ a normal of -0.9 at hi_altitude
	SetSavedDvar( "wind_global_low_altitude", 20 );
	SetSavedDvar( "wind_global_hi_altitude", 940 );
	SetSavedDvar( "wind_global_low_strength_percent", 0.3 ); // 4mph at low altitude

	// Add a while loop to vary the strength of the wind over time.
}



precachefx()
{

	//level._effect["TEST_AXIS"]								= loadfx("misc/fx_axis_test_local");

	// Flamethrower
    level._effect["character_fire_pain_sm"]              		= loadfx( "env/fire/fx_fire_player_sm_1sec" );
    level._effect["character_fire_death_sm"]             		= loadfx( "env/fire/fx_fire_player_md" );
    level._effect["character_fire_death_torso"] 				= loadfx( "env/fire/fx_fire_player_torso" );


	// airfield mortars
	level._effectType["orig_mortar_airfield_sw"] 						= "mortar";
	level._effect["orig_mortar_airfield_sw"]							= loadfx("explosions/fx_mortarExp_dirt_airfield");

	level._effectType["orig_mortar_airfield_nw"] 						= "mortar";
	level._effect["orig_mortar_airfield_nw"]							= loadfx("explosions/fx_mortarExp_dirt_airfield");
	
	level._effectType["orig_mortar_airfield_ne"] 						= "mortar";
	level._effect["orig_mortar_airfield_ne"]							= loadfx("explosions/fx_mortarExp_dirt_airfield");
	
	level._effectType["orig_mortar_airfield_se"] 						= "mortar";
	level._effect["orig_mortar_airfield_se"]							= loadfx("explosions/fx_mortarExp_dirt_airfield");		

	level._effectType["orig_mortar_airfield_canned"] 					= "mortar";
	level._effect["orig_mortar_airfield_canned"]						= loadfx("explosions/fx_mortarExp_dirt_airfield");		
	level._explosion_stopNotify["orig_mortar_airfield_canned"] 			= "stop_mortar_airfield_canned";

	level._effectType["orig_mortar_airfield_ambient_canned"] 			= "mortar";
	level._effect["orig_mortar_airfield_ambient_canned"]				= loadfx("explosions/fx_mortarExp_dirt_airfield");		
	level._explosion_stopNotify["orig_mortar_airfield_ambient_canned"]  = "stop_mortar_airfield_ambient_canned";
	
	
	
	// TODO what's this for?
	level._effectType["dirt_mortar"] 							= "mortar";
	level._effect["dirt_mortar"]								= loadfx("explosions/artilleryExp_dirt_brown_test");		

	// airfield
	level._effect["truck_hit_by_shell"] 						= loadfx("maps/pel2/fx_exp_tank_to_truck" );
	level._effect["truck_slide_dust"]							= loadfx("maps/pel2/fx_truck_slide_dust" );
	level._effect["arty_dirt"]									= loadfx("explosions/fx_mortarExp_dirt_airfield");
	//level._effect["bomber_smoke"]								= loadfx("maps/pel2/fx_plane_fire_smoke_md");
	level._effect["strafe_squib"]								= loadfx("maps/pel2/fx_bullet_dirt_strafe");
	level._effect["fx_artilleryExp_ridge"]						= loadfx("maps/pel2/fx_artilleryExp_ridge");
	level._effect["air_napalm"]									= loadfx("maps/pel2/fx_napalm_ending"); // This can be deleted if no longer referenced in script.
	level._effect["telepole_plane_crash"]						= loadfx("maps/fly/fx_exp_kamikaze");
	level._effect["telepole_spark"]								= loadfx("maps/pel2/fx_exp_telepole_spark");
	level._effect["target_smoke"]								= loadfx ("env/smoke/fx_smoke_ground_marker_green_w");
	
	// forest/admin
	level._effect["birds_fly"]									= loadfx("maps/pel2/fx_birds_tree_panic");
	level._effect["flamer_explosion"]							= loadfx("explosions/fx_flamethrower_char_explosion");
	level._scr_sound["flamer_explosion"] 						= "flame_explosion";
	level._effect["large_vehicle_explosion"]					= loadfx("explosions/large_vehicle_explosion");
	level._effect["bomber_crash_treetop"]						= loadfx("maps/pel2/fx_bomber_tree_clip");
	
	level._effect["sniper_leaf_loop"]							= loadfx("destructibles/fx_dest_tree_palm_snipe_leaf01");	
	level._effect["sniper_leaf_canned"]							= loadfx("destructibles/fx_dest_tree_palm_snipe_leaf02");
	
	level._effect["admin_wall_explode"]							= loadfx("system_elements/fx_null");
	level.scr_sound["admin_wall_explode"] 						= "imp_stone_chunk";
	
	level._effect["admin_sandbag_explode_large"]				= loadfx("maps/pel2/fx_sandbag_explosion_01_lg");
	level._effect["admin_sandbag_explode_small"]				= loadfx("maps/pel2/fx_sandbag_explosion_02_sm");	
	
	// bunkers
	level._effect["flamer_gunned_down"]							= loadfx("maps/pel2/fx_flamer_gunned_down");	
	level._effect["bunker_chain_reaction"]						= loadfx("destructibles/fx_dest_tank_panzer_tread_lf_grind");
	
	// TODO probably not going to have a sound for this
	//level.scr_sound["admin_sandbag_explode"]					= "admin_sandbag_explode_sound_here";

	// tanks
	//level._effect["sherman_smoke"]            					= loadfx("vehicle/vfire/fx_vfire_sherman");
	level._effect["sherman_camo_smoke"]            				= loadfx("vehicle/vfire/fx_tank_sherman_smldr");
	level._effect["type97_smoke"]            					= loadfx("vehicle/vfire/fx_tank_type97_smldr");
	
	// planes
	level._effect["bomber_wing_hit"]							= loadfx("maps/pel2/fx_bomber_dmg_trail");
	level._effect["fighter_wing_hit"]							= loadfx("maps/pel2/fx_fighter_dmg_trail");
	
	// misc
	level._effect["flesh_hit"]									= loadFX( "impacts/flesh_hit" );
	
	
	
	//----------------------------------AMBIENT EFFECTS------------------------------------------------
	level._effect["insect_swarm"]						= loadfx ("bio/insects/fx_insects_ambient");
	level._effect["seagulls_circling"]			= loadfx ("bio/animals/fx_seagulls_circling");
	level._effect["smoke_smolder"]					= loadfx ("env/smoke/fx_smoke_crater");
	level._effect["wire_sparks"]						= loadfx ("env/electrical/fx_elec_sparking");
	level._effect["wire_sparks_2"]					= loadfx ("env/electrical/fx_elec_sparks_looping");
	level._effect["fire_detail"]						= loadfx ("maps/pel2/fx_fire_debris_small");
	level._effect["ground_mist_w"]					= loadfx ("maps/pel2/fx_mist_swamp_w");
	level._effect["battlefield_smoke_lg_w"]	= loadfx ("env/smoke/fx_battlefield_smokebank_ling_lg_w");
	level._effect["sand_lg_w"]							= loadfx ("env/dirt/fx_sand_blowing_lg_w");
	level._effect["sand_sm"]								= loadfx ("env/dirt/fx_sand_blowing_sm");
	level._effect["a_smokebank_dark_lg"] 		= loadfx("maps/pel2/fx_smokebank_dark_lg_pel2");
	
	level._effect["a_fire_brush_smldr_md"] 	= loadfx("maps/pel2/fx_fire_brush_smldr_md_pel2");
	level._effect["a_fire_debris_lg_dir"] 	= loadfx("maps/pel2/fx_fire_debris_lg_dir_pel2");
	level._effect["a_fire_oil_lg"]					= loadfx("env/fire/fx_fire_oil_lg");
	level._effect["a_fire_oil_md"] 					= loadfx("env/fire/fx_fire_oil_md");
	level._effect["a_fire_thick_lg"] 				= loadfx("maps/pel2/fx_fire_thick_smoke_pel2");
	level._effect["truck_fire"]							= loadfx ("maps/pel2/fx_truck_fire_med");//Should be deleted.
	
	level._effect["a_dust_kickup_lg"]				= loadfx("env/dirt/fx_dust_kickup_lg");
	level._effect["a_dust_kickup_sm"]				= loadfx("env/dirt/fx_dust_kickup_sm");
	level._effect["a_smoke_crater"] 				= loadfx("env/smoke/fx_smoke_crater_w");
	level._effect["a_smoke_impact"] 				= loadfx("env/smoke/fx_smoke_impact_smolder");
	level._effect["a_smoke_column_blk_tall"] 	= loadfx("env/smoke/fx_smoke_plume_xlg_slow_blk_tall_w");
	level._effect["a_heat_haze_sm"] 				= loadfx("env/weather/fx_heathaze_sm");
	level._effect["a_heat_haze_md"] 				= loadfx("env/weather/fx_heathaze_md");
	level._effect["a_heat_haze_lg_dist"] 		= loadfx("env/weather/fx_heathaze_lg_dist");
	level._effect["god_ray_small"] 					= loadfx("maps/pel2/fx_light_god_rays_small");
	level._effect["god_ray_medium"] 				= loadfx("maps/pel2/fx_light_god_rays_medium");
	level._effect["god_ray_large"] 					= loadfx("maps/pel2/fx_light_god_rays_large");
	level._effect["lantern_nimbus"]					= loadfx("maps/pel2/fx_glow_lantern_nimbus");
	level._effect["dust_falling_runner1"] 	= loadfx("maps/pel2/fx_dust_falling_runner1");
	level._effect["sand_gust_medium"] 			= loadfx("maps/pel2/fx_sand_gust_medium");
	level._effect["dust_ambiance_indoor1"] 	= loadfx("maps/pel2/fx_dust_ambiance_indoor1");
	level._effect["dust_ambiance_indoor2"] 	= loadfx("maps/pel2/fx_dust_ambiance_indoor2");
	level._effect["cloud_flashes"] 					= loadfx("maps/pel2/fx_cloud_flashes");
	level._effect["a_smk_ceil_lg_dir"]			= loadfx("maps/pel2/fx_smk_ceiling_lg_dir_pel2");
	level._effect["a_smk_window_lg_dir"]		= loadfx("maps/pel2/fx_smk_window_lg_dir_pel2");
	level._effect["a_wtr_leak_runner_25"]		= loadfx("env/water/fx_water_leak_runner_25");
	level._effect["a_napalm_ground_burst"]	= loadfx("maps/pel2/fx_napalm_groundburst1");
	level._effect["a_napalm_air_burst"]			= loadfx("maps/pel2/fx_napalm_ending");
	level._effect["a_exp_mangrove_ambush"]	= loadfx("maps/pel2/fx_exp_mangrove_ambush");
	level._effect["a_smk_smldr_corsair"]		= loadfx("maps/pel2/fx_smk_smldr_corsair");
	level._effect["a_wtr_splash_debris_sm"]	= loadfx("env/water/fx_wtr_splash_debris_sm");
	level._effect["a_wtr_splash_debris_md"]	= loadfx("env/water/fx_wtr_splash_debris_md");
	
	level._effect["a_bunker_window_flame"]	= loadfx("maps/pel2/fx_bunker_window_flame");
	level._effect["a_exp_bunker_door"]			= loadfx("maps/pel2/fx_exp_bunker_door");
	level._effect["a_exp_corsair_tower_crash"]	= loadfx("maps/pel2/fx_exp_corsair_tower_crash");
	
}



footsteps()

{

    animscripts\utility::setFootstepEffect( "asphalt",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "brick",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "carpet",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "cloth",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "concrete",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "dirt",		LoadFx( "bio/player/fx_footstep_sand" ) ); 
    animscripts\utility::setFootstepEffect( "foliage",	LoadFx( "bio/player/fx_footstep_sand" ) ); 
    animscripts\utility::setFootstepEffect( "gravel",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "grass",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "metal",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "mud",		LoadFx( "bio/player/fx_footstep_mud" ) ); 
    animscripts\utility::setFootstepEffect( "paper",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "plaster",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "rock",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    animscripts\utility::setFootstepEffect( "sand",		LoadFx( "bio/player/fx_footstep_sand" ) ); 
    animscripts\utility::setFootstepEffect( "water",	LoadFx( "bio/player/fx_footstep_water" ) ); 
    animscripts\utility::setFootstepEffect( "wood",		LoadFx( "bio/player/fx_footstep_dust" ) ); 

}




spawnfx()
{
	// Search me what's supposed to go here, but it's in the other map's fx scripts.
	maps\createfx\pel2_fx::main();
}



pel2_merge_sunsingledvar( dvar, delay, timer, l1, l2 )
{
//	level notify( dvar + "new_lightmerge" );
//	level endon( dvar + "new_lightmerge" );

	setsaveddvar( dvar, l1 );
	wait( delay );
	timer = timer*20;
	suncolor = [];
	
	/*
	0	i
	1	timer*20
	*/
	for ( i=0; i < timer; i++ )
	{
		dif = i / timer;
		level.thedif = dif;
		ld = l2 * dif + l1 * ( 1 - dif );
		
		setsaveddvar( dvar, ld );
		wait( 0.05 );
	}
	
	setsaveddvar( dvar, l2 );
	
}



fire_flicker_init()
{
	lights = GetEntArray( "firecaster", "targetname" );
	
	if( !IsDefined( lights ) || lights.size <= 0 )
	{
		return;
	}
	
	array_thread( lights, ::pel2_firelight );
}



// modified version of _lights::burning_trash_fire()
pel2_firelight()
{
	full = self GetLightIntensity();
	
	old_intensity = full;
	
	while( 1 )
	{
		intensity = RandomFloatRange( full * 0.63, full * 1.2 );
		// old values = 6, 12
		timer = RandomFloatRange( 2, 5 );

		for ( i = 0; i < timer; i ++ )
		{
			new_intensity = intensity * ( i / timer ) + old_intensity * ( ( timer - i ) / timer );
			
			self SetLightIntensity( new_intensity );
			wait( 0.05 );
		}
		
		old_intensity = intensity;
	}	
}

////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////Rich's Section////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////

vision_settings()

{

//  	set_all_players_visionset( "pel2_2", 0.1 );
//	
//	if( IsSplitScreen() )
//	{
//		halfway_height 	= 10000;
//		cull_dist 		= 2000;
//		set_splitscreen_fog( 300, 500, halfway_height, -120, 0.51, 0.52, 0.36, 0.0, cull_dist );
//	}
//	else
//	{
////		setVolFog( 350, 500, 90, -120, 0.51, 0.52, 0.36, 0.0 );	
//	}
	
	thread pel2_merge_sunsingledvar( "sm_sunSampleSizeNear", 0, 1, 1, 0.7 );
	
	wait( 0.05 );	

	flag_init( "setup_bunkers_for_vision" );	
	flag_wait( "setup_bunkers_for_vision" );
	
	thread pel2_merge_sunsingledvar( "sm_sunSampleSizeNear", 0, 1, 1, 0.25 );
	
}
