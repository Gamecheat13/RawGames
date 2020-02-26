#include clientscripts\_utility; 

// Scripted effects
precache_scripted_fx()
{
	
}


// Ambient effects
precache_createfx_fx()
{
	// Exploders
	// Event 1: Let it snow
	// Event 2: The Men in Charge
	level._effect["fx_tracers_antiair_night"]				= loadFX("weapon/antiair/fx_tracers_antiair_night");	// 101
	level._effect["fx_flak_field_flash"]						= loadFX("weapon/antiair/fx_flak_field_flash");	// 101
	level._effect["fx_flak_field_30k"]							= loadFX("explosions/fx_flak_field_30k");	// 101
	level._effect["fx_flak_field_flash"]						= loadFX("weapon/antiair/fx_flak_field_flash");	// 101
	level._effect["fx_ambient_bombing_10000"]				= loadFX("weapon/bomb/fx_ambient_bombing_10000");	// 101
	level._effect[ "fx_all_sky_exp" ]					= loadFX( "maps/panama/fx_sky_exp_orange" ); // 102-105
	// Event 3: Old Friends
	level._effect["fx_table_cash_drop_panama"]			= loadFX("props/fx_table_cash_drop_panama");	// 301
	// Event 4: Ambulance Assault
	// Event 5: Slums
	level._effect["fx_ac130_dropping_paratroopers"]	= loadFX("bio/shrimps/fx_ac130_dropping_paratroopers");	// 500
	// sky light: 501-504
	level._effect["fx_apc_store_front_crash"]				= loadFX("maps/panama/fx_apc_store_front_crash");	// 10540
	// Gasoline fires: 520
	level._effect["fx_bulletholes"]									= loadFX("impacts/fx_bulletholes");	// 540
	level._effect["fx_building_collapse_exp_sm"]		= loadFX("maps/panama/fx_building_collapse_exp_sm");	// 550
	level._effect["fx_building_collapse_front"]			= loadFX("maps/panama/fx_building_collapse_front");	// 550
	level._effect["fx_building_collapse_side"]			= loadFX("maps/panama/fx_building_collapse_side");	// 550
	// Event 6: Slums Burned Building
	level._effect["fx_exp_window_fire"]							= loadFX("explosions/fx_exp_window_fire");	// 560-562
	// Event 7: Apache Escape
	// Event 8: Take the Shot
	level._effect["fx_gate_crash"]									= loadFX("impacts/fx_gate_crash");	// 801
	// Event 9: By My Hand
	// Event 10: Old Man Woods
	
	// Ambient Effects
	level._effect["fx_light_runway_line"]						= loadFX("env/light/fx_light_runway_line");
	level._effect["fx_spotlight"]										= loadFX("env/light/fx_spotlight");
	level._effect["fx_shrimp_paratrooper_ambient"]	= loadFX("bio/shrimps/fx_shrimp_paratrooper_ambient");
	level._effect["fx_smk_fire_md_black"]						= loadFX("smoke/fx_smk_fire_md_black");
	level._effect["fx_smk_fire_lg_black"]						= loadFX("smoke/fx_smk_fire_lg_black");
	level._effect["fx_smk_fire_lg_white"]						= loadFX("smoke/fx_smk_fire_lg_white");
	level._effect["fx_fire_column_creep_xsm"]				= loadFX("env/fire/fx_fire_column_creep_xsm");
	level._effect["fx_fire_column_creep_sm"]				= loadFX("env/fire/fx_fire_column_creep_sm");
	level._effect["fx_fire_wall_md"]								= loadFX("env/fire/fx_fire_wall_md");
	level._effect["fx_fire_ceiling_md"]							= loadFX("env/fire/fx_fire_ceiling_md");
	level._effect["fx_fire_line_xsm"]								= loadFX("env/fire/fx_fire_line_xsm");
	level._effect["fx_fire_line_sm"]								= loadFX("env/fire/fx_fire_line_sm");
	level._effect["fx_fire_line_md"]								= loadFX("env/fire/fx_fire_line_md");
	level._effect["fx_fire_sm_smolder"]							= loadFX("env/fire/fx_fire_sm_smolder");
	level._effect["fx_fire_md_smolder"]							= loadFX("env/fire/fx_fire_md_smolder");
}


main()
{
	clientscripts\createfx\panama_fx::main();
	clientscripts\_fx::reportNumEffects();
	
	precache_createfx_fx();
	
	disableFX = GetDvarInt( "disable_fx" );
	if( !IsDefined( disableFX ) || disableFX <= 0 )
	{
		precache_scripted_fx();
	}
}

