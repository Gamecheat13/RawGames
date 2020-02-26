#include maps\_utility; 
#include common_scripts\utility;

#using_animtree("fxanim_props");

main()
{
	init_model_anims();
	precache_scripted_fx();
	precache_createfx_fx();
	wind_init();
	
	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\panama_fx::main();
}


// Scripted effects
precache_scripted_fx()
{
	level._effect[ "fx_vlight_brakelight_default" ]	= LoadFX("light/fx_vlight_brakelight_default");
	level._effect[ "fx_vlight_headlight_default" ]	= LoadFX("light/fx_vlight_headlight_default");
		
	//extra muzzle flash on ladder pdf
	level._effect[ "maginified_muzzle_flash" ]	= LoadFX( "weapon/muzzleflashes/fx_muz_lg_gas_flash_3p" );

	//more intense AC130 fx
	level._effect[ "ac130_intense_fake" ]				= LoadFX( "maps/panama/fx_tracer_ac130_fake" );
	
	//sky light up for AC130 vulcan fire
	level._effect[ "ac130_sky_light" ]					= LoadFX( "weapon/muzzleflashes/fx_ac130_vulcan_world" );

	//Jet fx
	level._effect[ "jet_exhaust" ]	            = LoadFX( "vehicle/exhaust/fx_exhaust_jet_afterburner" );
	level._effect[ "jet_contrail" ]             = LoadFX( "trail/fx_geotrail_jet_contrail" );			
	
	//Cessna Fires
	level._effect[ "cessna_fire" ] = LoadFX( "explosions/fx_exp_cessna_ground" );
	
	//LearJet Explosion
	level._effect[ "learjet_explosion" ]				= LoadFX( "vehicle/vexplosion/fx_vexp_truck_gaz66" );
	
	//Door kick fx
	level._effect[ "door_breach" ]							= LoadFX("props/fx_door_breach");		
	
	// Event 5: Slums
	level._effect[ "ambulance_siren" ]				= loadFX( "light/fx_light_ambulance_red_flashing" );
	level._effect[ "ir_strobe" ]					= loadFX( "weapon/grenade/fx_strobe_grenade_runner" );
	level._effect[ "flashlight" ]					= loadFX( "env/light/fx_flashlight_ai" );
	level._effect[ "digbat_doubletap" ]				= loadFX( "impacts/fx_head_fatal_lg_side" );
	level._effect[ "all_sky_exp" ]					= loadFX( "maps/panama/fx_sky_exp_orange" );
	level._effect[ "on_fire_tor" ]					= loadFX( "fire/fx_fire_ai_torso" );
	level._effect[ "on_fire_leg" ]					= loadFX( "fire/fx_fire_ai_leg" );
	level._effect[ "on_fire_arm" ]					= loadFX( "fire/fx_fire_ai_arm" );
	level._effect[ "molotov_lit" ]					= loadFX( "weapon/molotov/fx_molotov_wick" );
	level._effect[ "nightingale_smoke" ]			= loadFX( "weapon/grenade/fx_smoke_grenade_red" );
		
	// Event 7: Apache Escape
	level._effect["apache_spotlight"]		= loadFX( "light/fx_vlight_apache_spotlight" );
	level._effect["apache_spotlight_cheap"]		= loadFX( "light/fx_vlight_apache_spotlight_cheap" );
	
	// Event 8: Take the Shot
	level._effect["mason_fatal_shot"]		= loadFX( "impacts/fx_flesh_hit_head_fatal_mason" );
	
	// Event 9: By my Hand
	level._effect["player_knee_shot"]		= loadFX( "impacts/fx_flesh_hit_knee_blowout" );
	
	// Sniper Glint
	level._effect[ "sniper_glint" ]		= LoadFX( "misc/fx_misc_sniper_scope_glint" );
	
	// Claymore 
	level._effect[ "claymore_laser" ] = LoadFX( "weapon/claymore/fx_claymore_laser" );
	level._effect[ "claymore_explode" ] = LoadFX( "explosions/fx_grenadeexp_dirt" );
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


wind_init()
{
	SetSavedDvar( "wind_global_vector", "1 0 0" );						// change "1 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0 );						// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 5000 );					// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.5 );	// change 0.5 to your desired wind strength percentage
}


// FXanim Props
init_model_anims()
{
	level.scr_anim["fxanim_props"]["wall_fall"] = %fxanim_panama_wall_fall_anim;
	level.scr_anim["fxanim_props"]["laundromat_wall"] = %fxanim_panama_laundromat_wall_anim;
	level.scr_anim["fxanim_props"]["laundromat_apc"] = %fxanim_panama_laundromat_apc_anim;
	level.scr_anim["fxanim_props"]["wall_tackle"] = %fxanim_panama_wall_tackle_anim;
	level.scr_anim["fxanim_props"]["ceiling_collapse"] = %fxanim_panama_ceiling_collapse_anim;
}
