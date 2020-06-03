//
// file: pel2_fx.gsc
// description: clientside fx script for pel2: setup, special fx functions, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_music;

footsteps()
{

    clientscripts\_utility::setFootstepEffect( "asphalt",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "brick",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "carpet",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "cloth",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "concrete",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "dirt",		LoadFx( "bio/player/fx_footstep_sand" ) ); 
    clientscripts\_utility::setFootstepEffect( "foliage",	LoadFx( "bio/player/fx_footstep_sand" ) ); 
    clientscripts\_utility::setFootstepEffect( "gravel",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "grass",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "metal",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "mud",       LoadFx( "bio/player/fx_footstep_mud" ) ); 
    clientscripts\_utility::setFootstepEffect( "paper",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "plaster",	LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "rock",		LoadFx( "bio/player/fx_footstep_dust" ) ); 
    clientscripts\_utility::setFootstepEffect( "sand",		LoadFx( "bio/player/fx_footstep_sand" ) ); 
    clientscripts\_utility::setFootstepEffect( "water",		LoadFx( "bio/player/fx_footstep_water" ) ); 
    clientscripts\_utility::setFootstepEffect( "wood",		LoadFx( "bio/player/fx_footstep_dust" ) ); 

}


// load fx used by util scripts
precache_util_fx()
{	

}

precache_scripted_fx()
{

	//level._effect["TEST_AXIS"]								= loadfx("misc/fx_axis_test_local");

	// Flamethrower
    level._effect["character_fire_pain_sm_1sec"]              		= loadfx( "env/fire/fx_fire_player_sm_1sec" );
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
	level._effect["air_napalm"]									= loadfx("maps/pel2/fx_napalm_ending"); // Delete this if not used in script
	level._effect["telepole_plane_crash"]						= loadfx("maps/fly/fx_exp_kamikaze");
	level._effect["telepole_spark"]								= loadfx("maps/pel2/fx_exp_telepole_spark");
	level._effect["target_smoke"]								= loadfx ("env/smoke/fx_smoke_ground_marker_green_w");
	
	// forest/admin
	level._effect["birds_fly"]									= loadfx("maps/pel2/fx_birds_tree_panic");
	level._effect["flamer_explosion"]							= loadfx("explosions/fx_flamethrower_char_explosion");
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

	// tanks
	//level._effect["sherman_smoke"]            					= loadfx("vehicle/vfire/fx_vfire_sherman");
	level._effect["sherman_camo_smoke"]            				= loadfx("vehicle/vfire/fx_tank_sherman_smldr");
	level._effect["type97_smoke"]            					= loadfx("vehicle/vfire/fx_tank_type97_smldr");
	
	// planes
	level._effect["bomber_wing_hit"]							= loadfx("maps/pel2/fx_bomber_dmg_trail");
	level._effect["fighter_wing_hit"]							= loadfx("maps/pel2/fx_fighter_dmg_trail");
	
	// misc
	level._effect["flesh_hit"]									= loadFX( "impacts/flesh_hit" );
	
}

// --- BARRY'S SECTION ---//
precache_createfx_fx()
{
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

ridge_flashes()
{

	origs = getstructarray( "orig_ridge_flash", "targetname" );
	
	last_rand = 0;
	rand = 0;
	
	while( 1 )
	{
		
		// make sure we don't play at the same location twice in a row
		while( rand == last_rand )
		{
			rand = randomint(origs.size);
			realwait( 0.05 );
		}
		
		last_rand = rand;
		
		players = getlocalplayers();
		
		for(i = 0; i < players.size; i ++)
		{
			playfx( i, level._effect["fx_artilleryExp_ridge"], origs[rand].origin );
		}
		
		realwait( randomfloatrange( 0.45, 1.75 ) );
		
	}
	
}

airfield_mortars()
{
	level waittill("air_mortars");
	
	level thread ridge_flashes();
	
	clientscripts\_mortar::set_mortar_delays( "orig_mortar_airfield_sw", 1, 4 ,0.5, 1.25 );
	clientscripts\_mortar::set_mortar_range( "orig_mortar_airfield_sw", 200, 15000 );
	clientscripts\_mortar::set_mortar_quake( "orig_mortar_airfield_sw", 0.32, 3, 1800 );
	clientscripts\_mortar::set_mortar_dust( "orig_mortar_airfield_sw", "bunker_dust", 512 );
	
	
	clientscripts\_mortar::set_mortar_delays( "orig_mortar_airfield_nw", 1, 4, 0.5, 1.25 );
	clientscripts\_mortar::set_mortar_range( "orig_mortar_airfield_nw", 200, 15000 );
	clientscripts\_mortar::set_mortar_quake( "orig_mortar_airfield_nw", 0.32, 3, 1800 );
	clientscripts\_mortar::set_mortar_dust( "orig_mortar_airfield_nw", "bunker_dust", 512 );
	
	
	clientscripts\_mortar::set_mortar_delays( "orig_mortar_airfield_ne", 1, 4, 0.5, 1.25 );
	clientscripts\_mortar::set_mortar_range( "orig_mortar_airfield_ne", 200, 15000 );
	clientscripts\_mortar::set_mortar_quake( "orig_mortar_airfield_ne", 0.32, 3, 1800 );
	clientscripts\_mortar::set_mortar_dust( "orig_mortar_airfield_ne", "bunker_dust", 512 );
	
	
	clientscripts\_mortar::set_mortar_delays( "orig_mortar_airfield_se", 1, 4, 0.5, 1.25 );
	clientscripts\_mortar::set_mortar_range( "orig_mortar_airfield_se", 200, 15000 );
	clientscripts\_mortar::set_mortar_quake( "orig_mortar_airfield_se", 0.32, 3, 1800 );
	clientscripts\_mortar::set_mortar_dust( "orig_mortar_airfield_se", "bunker_dust", 512 );		
	
	level thread clientscripts\_mortar::mortar_loop( "orig_mortar_airfield_sw" );
	level thread clientscripts\_mortar::mortar_loop( "orig_mortar_airfield_nw" );
	level thread clientscripts\_mortar::mortar_loop( "orig_mortar_airfield_ne" );
	level thread clientscripts\_mortar::mortar_loop( "orig_mortar_airfield_se" );		
}

ambient_25_monitor_thread()
{
	level endon( "save_restore" ); 
	self endon( "entityshutdown" ); 

	notifystring = "25s"+self getentitynumber();

	level waittill(notifystring);
	level._25stopped[self getentitynumber()] = 1;
	
}

ambient_25_thread(clientNum)
{
	println("*** Clientside AA thread.");
	num = self getentitynumber();
	if(isdefined(level._25stopped[num]) && level._25stopped[num])
		return;		// we're dead.

	if(clientNum != 0)
		return; 

	println("*** Clientside AA thread " + num + " going ahead.");
		
	level endon( "save_restore" ); 
	self endon( "entityshutdown" ); 

	while(!level._ambient_aa_started)
	{
		realwait(0.2);
	}

	println("*** Clientside AA thread " + num + " starts firing.");

	self thread ambient_25_monitor_thread();		
	self thread clientscripts\_triple25::triple25_Shoot(); 
	
}

ambient_25s()
{
	level._25stopped = [];
	
	level._ambient_aa_started = false;
	level waittill("start25s");
	println("Client starts AAs");
	level._ambient_aa_started = true;
	
/*	aa1 = undefined;
	aa2 = undefined;
	aa3 = undefined;
	aa4 = undefined;
	
	while(!isdefined(aa1) && !isdefined(aa2) && !isdefined(aa3) & !isdefined(aa4))
	{
		aa1 =  getent( 0, "aaGun_1", "targetname" );
		aa2 =  getent( 0, "aaGun_2", "targetname" );
		aa3 =  getent( 0, "aaGun_3", "targetname" );
		aa4 =  getent( 0, "aaGun_4", "targetname" );
		wait(0.2);
	}
	
	aa1 thread clientscripts\_triple25::triple25_shoot("aaGun_1");
	aa2 thread clientscripts\_triple25::triple25_shoot("aaGun_2");
	aa3 thread clientscripts\_triple25::triple25_shoot("aaGun_3");
	aa4 thread clientscripts\_triple25::triple25_shoot("aaGun_4");
*/
}

main()
{
	clientscripts\createfx\pel2_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_util_fx();
	
	footsteps();
	
	precache_createfx_fx();

	level._customVehicleCB = [];
	level._customVehicleCB["triple25"] = ::ambient_25_thread;
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
	
	level thread airfield_mortars();
	level thread ambient_25s();
}

