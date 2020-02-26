//
// file: see2_fx.gsc
// description: clientside fx script for see2: setup, special fx functions, etc.
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


// --- QUINN'S SECTION ---//
precache_createfx_fx()
{

	level._effect["fire_foliage_large"]		        = loadfx("maps/see2/fx_fire_foliage_large");
	level._effect["fire_foliage_medium"]	      	= loadfx("maps/see2/fx_fire_foliage_medium");	
	level._effect["fire_foliage_small"]		        = loadfx("maps/see2/fx_fire_foliage_small");	
	level._effect["fire_foliage_xsmall"]		      = loadfx("maps/see2/fx_fire_foliage_xsmall");	
	level._effect["fog_rolling_thick"]		        = loadfx("maps/see2/fx_fog_rolling_thick");		
	level._effect["smoke_rolling_thick"]	      	= loadfx("maps/see2/fx_smoke_rolling_thick");				
	level._effect["smoke_column1"]		            = loadfx("maps/see2/fx_smoke_column");				
	level._effect["smoke_column2"]		            = loadfx("maps/see2/fx_smoke_column2");
	level._effect["smoke_chimney"]	             	= loadfx("maps/see2/fx_smoke_chimney");	
	level._effect["dust_kick_up_emitter"]         = loadfx("maps/see2/fx_dust_kick_up_emitter");	
	level._effect["cloud_flashes"]                = loadfx("maps/see2/fx_cloud_flashes");	
	level._effect["aa_tracers_ambient"]           = loadfx("maps/see2/fx_tracers_flak88_amb");	
	level._effect["aa_tracers_directional"]       = loadfx("maps/see2/fx_tracers_flak88_dir");	
	level._effect["flak_field"]                   = loadfx("maps/see2/fx_flak_field");							
	
}


main()
{
	clientscripts\createfx\see2_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	// --- LUCAS' SECTION --- //
	// Script exploders
	level._effect["house_blow_up"] = LoadFx( "maps/see1/fx_explosion_tank_shell_med_house" );
	level._effect["wood_house"] = LoadFx( "weapon/tank/fx_tank_generic_house_wood" );
	level._effect["brick_house"] = LoadFx( "weapon/tank/fx_tank_generic_house_brick" );
	level._effect["water_tower_explode"] = LoadFx( "maps/see2/fx_water_tower_exp" );
	level._effect["crate_explode"] = LoadFx( "explosions/fx_exp_ger_supply_crate" );
	
	// Turret pops
	level._effect["panzer_turret_fly"] = LoadFx( "vehicle/vexplosion/fx_turretexp_panzer4" );
	level._effect["panther_turret_fly"] = LoadFx( "vehicle/vexplosion/fx_turretexp_panther" );
	level._effect["tiger_turret_fly"] = LoadFx( "vehicle/vexplosion/fx_turretexp_kingtiger" );
	
	// Vehicle intermediate damage fx
	level._effect["panzer_int_dmg"] = LoadFx( "vehicle/vfire/fx_vsmoke_ger_panzer" );
	level._effect["panther_int_dmg"] = LoadFx( "vehicle/vfire/fx_vsmoke_ger_panther" );
	level._effect["tiger_int_dmg"] = LoadFx( "vehicle/vfire/fx_vsmoke_ger_tiger" );
	
	// FT FX
	level._effect["character_fire_pain_sm"] 		= LoadFx("env/fire/fx_fire_player_sm_1sec");
	level._effect["character_fire_death_sm"] 		= LoadFx("env/fire/fx_fire_player_md");
	level._effect["character_fire_death_torso"] 	= LoadFx("env/fire/fx_fire_player_torso");			

	// Destruction FX
	level._effect["tower_secondary_explosion"] = LoadFx( "maps/see2/fx_dust_collapse_plume" );
	level._effect["tower_explode"] = LoadFx( "maps/see2/fx_radio_tower_exp" );

	// Generic FX
	level._effect["tank_destruct"] = LoadFx( "vehicle/vexplosion/fx_vexplode_rus_t34" );
	level._effect["tank_smoulder"] = LoadFx( "vehicle/vfire/fx_vfire_rus_t34" );
	level._effect["rocket_trail"]		= LoadFx("weapon/rocket/fx_trail_bazooka_geotrail");
	level._effect["shreck_explode"]		= LoadFx("explosions/default_explosion");
	level._effect["pc132_trail"] 		= LoadFx("weapon/rocket/fx_rocket_katyusha_geotrail");
	level._effect["pc132_explode"] 		= LoadFx("weapon/napalm/fx_napalmExp_lg_blk_smk_01");
	level._effect["retreat_smoke"] = LoadFx( "weapon/grenade/fx_smoke_grenade_generic" );
	level._effect["drone_smoke"] = LoadFx( "weapon/grenade/fx_smoke_grenade_generic_no_blocksight" );
	level._effect["bunker_fire_start"] = LoadFx( "maps/see2/fx_flame_bunker_burst_outward" );
	level._effect["bunker_fire_out"] 		= LoadFx( "maps/see2/fx_flame_bunker_burst_residual" );
	level._effect["bunker_secondary_window"] = LoadFx( "maps/see2/fx_flame_bunker_explosion_outward" );
	level._effect["bunker_secondary_flash"] = LoadFx( "maps/see2/fx_flame_bunker_explosion_outward" );
	level._effect["bunker_secondary_explosion"] = LoadFx( "maps/see2/fx_explosion_bunker_main" );
	level._effect["large_vehicle_explosion"]	= LoadFx ("explosions/large_vehicle_explosion");
	level._effect["grenadeExp_dirt"]			= LoadFx ("explosions/grenadeExp_dirt");
	level._effect["tree_explode"] 				= LoadFx( "maps/see1/fx_explosion_tank_shell_med_house" );
	level._effect["truck_gib_explode" ] 	= LoadFx( "maps/see2/fx_vexplode_opel_blitz_gibs" );
	level._effect["plane_final_explode"] 	= loadfx("maps/fly/fx_exp_zero_final");
	level._effect["client_rocket_trail"] = loadfx("system_elements/fx_smk_wht_short_em");
	level.mortar = LoadFx( "explosions/fx_mortarExp_dirt" );
	
	// aaa muzzle flash -- borrowed from Pel1
	level._effect["aaa_tracer"]				= loadfx ("Weapon/Tracer/fx_tracer_jap_tripple25_projectile");
	
	//-- DRONE FX
	level._effect["drone_burst"]						= LoadFx("impacts/fx_flesh_blood_geyser");
	level._effect["character_fire_pain_sm"] 		= LoadFx( "env/fire/fx_fire_player_sm_1sec" );
	level._effect["character_fire_death_sm"] 		= LoadFx( "env/fire/fx_fire_player_md" );
	level._effect["character_fire_death_torso"] 	= LoadFx( "env/fire/fx_fire_player_torso" );
	
	precache_util_fx();
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

