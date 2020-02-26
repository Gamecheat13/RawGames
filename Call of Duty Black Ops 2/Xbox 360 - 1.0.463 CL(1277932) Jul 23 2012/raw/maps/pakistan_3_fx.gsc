#include maps\_utility; 
#include common_scripts\utility;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;

#using_animtree("fxanim_props");

main()
{	
	precache_fxanim_props();
	precache_scripted_fx();
	precache_createfx_fx();
	wind_init();
	
	// calls the createfx server script (i.e., the list of ambient effects and their attributes)
	maps\createfx\pakistan_3_fx::main();
}


// Scripted effects
precache_scripted_fx()
{
	level._effect[ "friendly_marker" ]				= LoadFX( "misc/fx_friendly_indentify01" );
	
	// section 3
	level._effect[ "blockade_explosion" ]			= LoadFX( "explosions/fx_vexp_gen_boat_x_up" );
	level._effect[ "drone_spotlight_cheap" ]		= LoadFX( "light/fx_vlight_firescout_spotlight_cheap" );
	level._effect[ "firescout_spotlight" ]			= LoadFX( "light/fx_vlight_drone_spotlight" );
	level._effect[ "soct_spotlight" ]				= LoadFX( "light/fx_vlight_soct_headlight_spot" );
	level._effect[ "soct_spotlight_cheap" ]			= LoadFX( "light/fx_vlight_soct_headlight_cheap" );
	level._effect[ "heli_crash_smoke_trail" ]		= LoadFX( "trail/fx_trail_la_plane_pieces" );
	level._effect[ "apache_spotlight_cheap" ]		= loadFX( "light/fx_vlight_apache_spotlight_cheap" );
	level._effect[ "soct_water_splash" ]			= LoadFX( "water/fx_vwater_soct_splash" );		
	level._effect[ "soct_boost_fx" ]				= LoadFX( "maps/pakistan/fx_soct_player_boost_os" );
	level._effect[ "soct_damaged" ]					= LoadFX( "vehicle/vfire/fx_vfire_soc_t" );
}


// Ambient effects
precache_createfx_fx()
{
	// Exploders
	// Event 8
	level._effect["fx_pak_heli_crash_exp"]							= loadFX("maps/pakistan/fx_pak_heli_crash_exp");	// 809
	level._effect["fx_exp_harper_burn"]									= loadFX("maps/pakistan/fx_exp_harper_burn");	// 810
	level._effect["fx_pak_smk_signal_dist"]							= loadFX("smoke/fx_pak_smk_signal_dist");	// 850
	level._effect["fx_fire_fuel_sm_water"]							= loadFX("fire/fx_fire_fuel_sm_water");
	level._effect["fx_fire_fuel_md_water"]							= loadFX("fire/fx_fire_fuel_md_water");
	level._effect["fx_fire_fuel_sm_ground"]							= loadFX("fire/fx_fire_fuel_sm_ground");
	level._effect["fx_fire_fuel_sm_line"]								= loadFX("fire/fx_fire_fuel_sm_line");
	level._effect["fx_fire_fuel_sm"]										= loadFX("fire/fx_fire_fuel_sm");
	level._effect["fx_fire_wall_md"]										= loadFX("env/fire/fx_fire_wall_md");
	level._effect["fx_pak_scaffold_collapse"]						= loadFX("maps/pakistan/fx_pak_scaffold_collapse");//10850
	level._effect["fx_exp_catwalk_collapse"]						= loadFX("maps/pakistan/fx_exp_catwalk_collapse");	// 10920
	level._effect["fx_pak_water_splash_catwalk"]				= loadFX("water/fx_pak_water_splash_catwalk");	// 10920 + 1.5 seconds
	level._effect["fx_water_silo_exp"]									= loadFX("weapon/rocket/fx_rocket_exp_water");	// 10925
	
	level._effect["fx_rain_light_loop"]									= loadFX("weather/fx_rain_light_loop");
	level._effect["fx_lights_stadium_drizzle_pak"]			= loadFX("light/fx_lights_stadium_drizzle_pak");
	level._effect["fx_steelworks_lava_bubbles"]					= loadFX("maps/pakistan/fx_steelworks_lava_bubbles");
	level._effect["fx_steelworks_lavafall"]							= loadFX("maps/pakistan/fx_steelworks_lavafall");
	level._effect["fx_steelworks_lava_surface"]					= loadFX("maps/pakistan/fx_steelworks_lava_surface");
	level._effect["fx_pak_light_road_flare"]						= loadFX("maps/pakistan/fx_pak_light_road_flare");
	level._effect["fx_light_glow_blue_lrg"]						= loadFX("maps/pakistan/fx_light_glow_blue_lrg");
}


wind_init()
{
	SetSavedDvar( "wind_global_vector", "-145 110 0" );				// change "1 0 0" to your wind vector
	SetSavedDvar( "wind_global_low_altitude", 0 );						// change 0 to your wind's lower bound
	SetSavedDvar( "wind_global_hi_altitude", 5000 );					// change 10000 to your wind's upper bound
	SetSavedDvar( "wind_global_low_strength_percent", 0.5 );	// change 0.5 to your desired wind strength percentage
}


// FXanim Props
precache_fxanim_props()
{
	level.scr_anim["fxanim_props"]["billboard_pillar_top03"] = %fxanim_la_billboard_pillar_top01_anim;
	level.scr_anim["fxanim_props"]["scaffold_collapse"] = %fxanim_pak_scaffold_collapse_anim;
	level.scr_anim["fxanim_props"]["catwalk_end_collapse"] = %fxanim_pak_catwalk_end_collapse_anim;
	level.scr_anim["fxanim_props"]["silo_end_collapse"] = %fxanim_pak_silo_end_collapse_anim;
	level.scr_anim["fxanim_props"]["scaffold_collapse_02"] = %fxanim_pak_scaffold_collapse_02_anim;
}