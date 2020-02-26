#include common_scripts\utility;
#include maps\_utility;
#include maps\_sandstorm;

main()
{
	
	precachemodel( "fog_blackout" );
	
	getent( "damaged_pavelow", "targetname" ) hide();
	
	maps\_vehicle::build_deathfx_override( "pavelow", "vehicle_pavelow", "explosions/helicopter_explosion_secondary_small", 	"tag_engine_left", 	"littlebird_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		0.0, 		true );
	maps\_vehicle::build_deathfx_override( "pavelow", "vehicle_pavelow", "explosions/helicopter_explosion_secondary_small", 	"tag_engine_right", 	"littlebird_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		1.4, 		true );
	maps\_vehicle::build_deathfx_override( "pavelow", "vehicle_pavelow", "explosions/helicopter_explosion_secondary_small", 	"tag_engine_right", 	"littlebird_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		3.9, 		true );
	maps\_vehicle::build_deathfx_override( "pavelow", "vehicle_pavelow", "explosions/helicopter_explosion_secondary_small", 	"tail_rotor_jnt", 	"littlebird_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		5.34, 		true );
	maps\_vehicle::build_deathfx_override( "pavelow", "vehicle_pavelow", "explosions/helicopter_explosion_secondary_small", 	"tag_engine_left", 	"littlebird_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		6.0, 		true );
	maps\_vehicle::build_deathfx_override( "pavelow", "vehicle_pavelow", "fire/fire_smoke_trail_L", 							"tag_engine_left", 	"littlebird_helicopter_dying_loop", 	true, 				0.05, 			true, 			0.2, 		true );
	maps\_vehicle::build_deathfx_override( "pavelow", "vehicle_pavelow", "explosions/helicopter_explosion_secondary_small",	"tag_engine_right", 	"littlebird_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		2.5, 		true );
	maps\_vehicle::build_deathfx_override( "pavelow", "vehicle_pavelow", "explosions/aerial_explosion_large", 						undefined, 		"littlebird_helicopter_crash", 			undefined, 			undefined,		undefined, 		- 1, 		undefined, 	"stop_crash_loop_sound" );

	//walking through water
	level._effect[ "water_stop" ]				= LoadFX( "misc/parabolic_water_stand" );
	level._effect[ "water_movement" ]			= LoadFX( "misc/parabolic_water_movement" );

	level._effect[ "rocket_hits_heli" ]			= LoadFX( "explosions/grenadeExp_metal" );

	level._effect[ "zodiac_wake_geotrail" ]		= LoadFX( "treadfx/zodiac_wake_geotrail_af_chase" );

	// only ever see the front of the players boat plays on tag_origin	
	level._effect[ "zodiac_leftground" ]		= LoadFX( "misc/watersplash_large" );
	
	//Zodiac bigbump
	level._effect[ "player_zodiac_bumpbig" ]	= LoadFX( "misc/watersplash_large" );
	level._effect[ "zodiac_bumpbig" ]			= LoadFX( "misc/watersplash_large" );
	level._effect_tag[ "zodiac_bumpbig" ] 		= "tag_guy2"; // pushing this farther forward so the player sees it better.

	//Zodiac bump
	level._effect[ "player_zodiac_bump" ] 		= LoadFX( "impacts/large_waterhit" );
	level._effect[ "zodiac_bump" ] 				= LoadFX( "impacts/large_waterhit" );

	//Zodiac Hard left/Hit left
	level._effect[ "zodiac_sway_left" ] 		= LoadFX( "misc/watersplash_hardturn" );
	level._effect_tag[ "zodiac_sway_left" ] 	= "TAG_FX_LF";

	//Zodiac Hard right/Hit right
	level._effect[ "zodiac_sway_right" ] 		= LoadFX( "misc/watersplash_hardturn" );
	level._effect_tag[ "zodiac_sway_right" ] 	= "TAG_FX_RF";

	//zodiac collision
	level._effect[ "zodiac_collision" ] 		= LoadFX( "misc/watersplash_large" );
	level._effect_tag[ "zodiac_collision" ] 	= "TAG_DEATH_FX"; // pushing this farther forward so the player sees it better.
	
	//sound
	level.zodiac_fx_sound[ "zodiac_bump" ]		= "water_boat_splash_small";
	level.zodiac_fx_sound[ "zodiac_bumpbig" ]	= "water_boat_splash";

	level.zodiac_fx_sound[ "player_zodiac_bump" ]		= "water_boat_splash_small_plr";
	level.zodiac_fx_sound[ "player_zodiac_bumpbig" ]	= "water_boat_splash_plr";
	
	//two bumps small and big. change them at points in the level to allow more or less visibility. 
	level.water_sheating_time[ "bump_big_start" ] = 2;
	level.water_sheating_time[ "bump_small_start" ] = 1;

	// sheeting time smaller just so action can be more visible.  I'm just trying this I suppose
	level.water_sheating_time[ "bump_big_after_rapids" ] = 4;
	level.water_sheating_time[ "bump_small_after_rapids" ] = 2;
	
	// water sheating time when the player dies. meant to be really long to cover up some nasty.
	level.water_sheating_time[ "bump_big_player_dies" ] = 7;
	level.water_sheating_time[ "bump_small_player_dies" ] = 3;
	
	
	//player falls over waterfall, this shoots up just as they go over.
	level._effect[ "splash_over_waterfall"		 ] = LoadFX( "misc/watersplash_large" );

	//player falls over waterfall, this shoots up when they hit below
	level._effect[ "player_hits_water_after_waterfall"		 ] = LoadFX( "misc/watersplash_large" );

	

//	level._effect[ "heli_crash_fire" ]								 = LoadFX( "fire/heli_crash_fire" );
	level._effect[ "heli_crash_fire" ]								 = LoadFX( "misc/no_effect" );

	// need something cool here.
	level._effect[ "body_falls_from_ropes_splash"			 ] = LoadFX( "impacts/large_waterhit" );


	level._effect[ "sand_storm_canyon_light" ]				= loadfx( "weather/sand_storm_canyon_light" );
	level._effect[ "sand_storm_player" ]					= loadfx( "weather/sand_storm_player" );
	level._effect[ "sand_storm_intro" ]						= loadfx( "weather/sand_storm_intro" );
	level._effect[ "sand_storm_light" ]						= loadfx( "weather/sand_storm_light" );
	level._effect[ "sand_storm_distant_oriented" ] 			= LoadFX( "weather/sand_storm_distant_oriented" );
	level._effect[ "sand_spray_detail_runner0x400" ]	 	= loadfx( "dust/sand_spray_detail_runner_0x400" );
	level._effect[ "sand_spray_detail_runner400x400" ]	 	= loadfx( "dust/sand_spray_detail_runner_400x400" );
	level._effect[ "sand_spray_detail_oriented_runner" ]	= loadfx( "dust/sand_spray_detail_oriented_runner" );
	level._effect[ "sand_spray_detail_oriented_runner" ]	= loadfx( "dust/sand_spray_detail_oriented_runner" );
	level._effect[ "sand_spray_cliff_oriented_runner" ] 	= LoadFX( "dust/sand_spray_cliff_oriented_runner" );

	level._effect[ "dust_wind_fast" ]						= loadfx( "dust/dust_wind_fast_afcaves" );
	level._effect[ "dust_wind_canyon" ]						= loadfx( "dust/dust_wind_canyon_far" );
	level._effect[ "steam_vent_large_wind" ]				= loadfx( "smoke/steam_vent_large_wind" );

	level._effect[ "ground_fog_afchase" ]	 				= loadfx( "smoke/ground_fog_afchase" );
	level._effect[ "light_shaft_ground_dust_small" ]	 	= loadfx( "dust/light_shaft_ground_dust_small" );
	level._effect[ "light_shaft_ground_dust_large" ]	 	= loadfx( "dust/light_shaft_ground_dust_large" );
	level._effect[ "light_shaft_ground_dust_small_yel" ]	= loadfx( "dust/light_shaft_ground_dust_small_yel" );
	level._effect[ "light_shaft_ground_dust_large_yel" ]	= loadfx( "dust/light_shaft_ground_dust_large_yel" );
	level._effect[ "light_shaft_motes_afchase" ]			= loadfx( "dust/light_shaft_motes_afchase" );


	/*
	level._effect[ "waterfall_drainage_short" ] 			= loadfx( "water/waterfall_drainage_short_physics" );
	level._effect[ "waterfall_drainage_splash" ] 			= loadfx( "water/waterfall_drainage_splash" );
	level._effect[ "waterfall_splash_large" ] 				= loadfx( "water/waterfall_splash_large" );
	level._effect[ "waterfall_splash_large_drops" ]			= loadfx( "water/waterfall_splash_large_drops" );
	level._effect[ "falling_water_trickle" ]	 			= loadfx( "water/falling_water_trickle" );
	*/
	level._effect[ "rapids_splash_large" ] 					= loadfx( "water/rapids_splash_large" );
	level._effect[ "rapids_splash_large_dark" ] 			= loadfx( "water/rapids_splash_large_dark" );
	level._effect[ "rapids_splash_large_far" ] 				= loadfx( "water/rapids_splash_large_far" );
	level._effect[ "waterfall_afchase" ]	 				= loadfx( "water/waterfall_afchase" );
	level._effect[ "waterfall_base_afchase" ]	 			= loadfx( "water/waterfall_base_afchase" );
	
	//mask the disappearance of the bad guy.
	level._effect[ "vanishing_shepherd" ]					= LoadFX( "misc/no_effect" );
	level._effect[ "sand_storm_player_blind"]				= LoadFX( "weather/sand_storm_player_blind" );
	
	level._effect[ "splashy_bubbles" ]			 			= loadfx( "water/scuba_bubbles_breath" );

	// this overrides the blizzard snow fx.	
	
	if ( getdvarint( "r_reflectionProbeGenerate" ) )
		return;
		
	maps\createfx\af_chase_fx::main();	

}

sand_storm_rolls_in()
{
	fog_set_changes( "afch_fog_dunes" , 4 ); //fog transitions over 20 seconds
	thread blind_player_effect();  //using the blinder effect to cover the transition 
	wait 2;
	thread sand_storm_effect();
	flag_set( "blinder_effect" );
	wait 2.5;
	block_out_the_sky();
	thread start_sandstorm();	
	flag_clear( "blinder_effect" );
}

sunlight_remove()
{
	sunvect = ( 1.441176, 1.2411765, 0.9705885 );
	sunvect *= .46;
	SetSunLight( sunvect[ 0 ], sunvect[ 1 ], sunvect[ 2 ] );
}

start_sandstorm()
{
	block_out_the_sky();
	sunlight_remove();
}

block_out_the_sky()
{
	fogent = spawn( "script_model", level.player geteye() );
	fogent setmodel ("fog_blackout" );
	fogent linkto ( level.player );
	flag_set( "sandstorm_fully_masked" );  // lets script know effects are good to go.
}

blind_player_effect()
{
	ent = spawn( "script_model", level.player.origin );
	ent setmodel ("tag_origin");

	ent linkto( level.player );
	
	player = getentarray( "player", "classname" )[ 0 ];
	
//	ent thread follow_player();
	for ( ;; )
	{
		if( flag( "blinder_effect" ) )
			playfxontag( level._effect[ "sand_storm_player_blind" ], ent, "tag_origin" );
//		playfx( level._effect[ "sand_storm_player_blind" ], player.origin );
		wait( 0.2 );
	}
}

follow_player()
{
	while(1)
	{
		self MoveTo( level.player.origin, .1, 0, 0 );
		wait .1;
	}
}





sand_storm_effect()
{
	player = getentarray( "player", "classname" )[ 0 ];
	for ( ;; )
	{
		playfx( level._effect[ "sand_storm_player" ], player.origin + ( 0, 0, 100 ) );
		wait( 0.2 );
	}
}


