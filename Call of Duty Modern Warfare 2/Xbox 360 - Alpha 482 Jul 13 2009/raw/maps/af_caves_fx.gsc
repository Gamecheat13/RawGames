 #include common_scripts\utility;
#include maps\_utility;

main()
{
	maps\_vehicle::build_deathfx_override( "littlebird", "vehicle_little_bird_armed", "explosions/helicopter_explosion_secondary_small", 	"tag_engine", 	"littlebird_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		0.0, 		true );
	maps\_vehicle::build_deathfx_override( "littlebird", "vehicle_little_bird_armed", "fire/fire_smoke_trail_L", 							"tag_engine", 	"littlebird_helicopter_dying_loop", 	true, 				0.05, 			true, 			0.5, 		true );
	maps\_vehicle::build_deathfx_override( "littlebird", "vehicle_little_bird_armed", "explosions/helicopter_explosion_secondary_small",	"tag_engine", 	"littlebird_helicopter_secondary_exp", 	undefined, 			undefined, 		undefined, 		2.5, 		true );
	maps\_vehicle::build_deathfx_override( "littlebird", "vehicle_little_bird_armed", "explosions/helicopter_explosion", 					undefined, 		"littlebird_helicopter_crash", 			undefined, 			undefined,		undefined, 		- 1, 		undefined, 	"stop_crash_loop_sound" );

	//Zodiacs
	level._effect[ "zodiac_wake_geotrail_oilrig" ]		= loadfx( "treadfx/zodiac_wake_geotrail_oilrig" );
	
	//ambient fx	
	level._effect[ "sand_storm_intro" ]						= loadfx( "weather/sand_storm_intro" );
	level._effect[ "sand_storm_light" ]						= loadfx( "weather/sand_storm_light" );
	level._effect[ "sand_storm_distant_oriented" ] 			= LoadFX( "weather/sand_storm_distant_oriented" );
	level._effect[ "sand_spray_detail_runner0x400" ]	 	= loadfx( "dust/sand_spray_detail_runner_0x400" );
	level._effect[ "sand_spray_detail_runner400x400" ]	 	= loadfx( "dust/sand_spray_detail_runner_400x400" );
	level._effect[ "sand_spray_detail_oriented_runner" ]	= loadfx( "dust/sand_spray_detail_oriented_runner" );
	level._effect[ "sand_spray_detail_oriented_runner" ]	= loadfx( "dust/sand_spray_detail_oriented_runner" );
	level._effect[ "sand_spray_cliff_oriented_runner" ] 	= LoadFX( "dust/sand_spray_cliff_oriented_runner" );

	level._effect[ "dust_wind_fast" ]						= loadfx( "dust/dust_wind_fast_afcaves" );
	level._effect[ "dust_wind_canyon" ]						= loadfx( "dust/dust_wind_canyon" );
	level._effect[ "steam_vent_large_wind" ]				= loadfx( "smoke/steam_vent_large_wind" );
	level._effect[ "thermal_draft_afcaves" ]				= loadfx( "smoke/thermal_draft_afcaves" );

	level._effect[ "waterfall_drainage_short" ] 			= loadfx( "water/waterfall_drainage_short_physics" );
	level._effect[ "waterfall_drainage_splash" ] 			= loadfx( "water/waterfall_drainage_splash" );
	level._effect[ "waterfall_splash_large" ] 				= loadfx( "water/waterfall_splash_large" );
	level._effect[ "waterfall_splash_large_drops" ]			= loadfx( "water/waterfall_splash_large_drops" );
	level._effect[ "falling_water_trickle" ]	 			= loadfx( "water/falling_water_trickle" );

	level._effect[ "light_shaft_ground_dust_small" ]	 	= loadfx( "dust/light_shaft_ground_dust_small" );
	level._effect[ "light_shaft_ground_dust_large" ]	 	= loadfx( "dust/light_shaft_ground_dust_large" );
	level._effect[ "light_shaft_ground_dust_small_yel" ]	= loadfx( "dust/light_shaft_ground_dust_small_yel" );
	level._effect[ "light_shaft_ground_dust_large_yel" ]	= loadfx( "dust/light_shaft_ground_dust_large_yel" );
	level._effect[ "light_shaft_motes_afcaves" ]			= loadfx( "dust/light_shaft_motes_afcaves" );

	//Scripted fx
	level._effect[ "flashlight" ]							= loadfx( "misc/flashlight" );
	level._effect[ "pistol_muzzleflash" ]					= loadfx( "muzzleflashes/pistolflash" );
	level._effect[ "player_death_explosion" ]				= loadfx( "explosions/player_death_explosion" );
	level._effect[ "cave_explosion" ]						= loadfx( "explosions/cave_explosion" );
	level._effect[ "cave_explosion_exit" ]					= loadfx( "explosions/cave_explosion_exit" );

	level._effect[ "mortar" ][ "bunker_ceiling" ]			= loadfx( "dust/ceiling_dust_default" );
	level._effect[ "ceiling_collapse_dirt1" ] 				= loadfx( "dust/ceiling_collapse_dirt1" );
	level._effect[ "ceiling_rock_break" ] 					= loadfx( "misc/ceiling_rock_break" );
	level._effect[ "hallway_collapsing_big" ] 				= loadfx( "misc/hallway_collapsing_big" );
	level._effect[ "hallway_collapsing_huge" ] 				= loadfx( "misc/hallway_collapsing_huge" );
	level._effect[ "hallway_collapse_ceiling_smoke" ] 		= loadfx( "smoke/hallway_collapse_ceiling_smoke" );
	level._effect[ "hallway_collapsing_chase" ] 			= loadfx( "misc/hallway_collapsing_chase" );
	level._effect[ "hallway_collapsing_cavein" ] 			= loadfx( "misc/hallway_collapsing_cavein" );
	level._effect[ "hallway_collapsing_cavein_short" ]		= loadfx( "misc/hallway_collapsing_cavein_short" );
	
	level._effect[ "hallway_collapsing_burst" ] 			= loadfx( "misc/hallway_collapsing_burst" );
	level._effect[ "hallway_collapsing_burst_no_linger" ] 	= loadfx( "misc/hallway_collapsing_burst_no_linger" );
	level._effect[ "hallway_collapsing_major" ] 			= loadfx( "misc/hallway_collapsing_major" );
	level._effect[ "hallway_collapsing_major_norocks" ] 	= loadfx( "misc/hallway_collapsing_major_norocks" );
	
	level._effect[ "building_explosion_metal" ]				= loadfx( "explosions/building_explosion_metal_gulag" );
	level._effect[ "tanker_explosion" ]						= loadfx( "explosions/tanker_explosion" );
	level._effect[ "bunker_ceiling" ]		 				= loadfx( "dust/ceiling_dust_default" );
	
	level._effect[ "heli_impacts" ] 						= loadfx( "impacts/large_dirt_1" );
	level._effect[ "welding_small_extended" ] 				= loadfx( "misc/welding_small_extended" );
	level._effect[ "fire_falling_runner_point" ]			= loadfx( "fire/fire_falling_runner_point" );
	
	level._effect[ "gulag_cafe_spotlight" ] 				= loadfx( "misc/gulag_cafe_spotlight" );
	
	level._effect[ "heli_aerial_explosion" ]			 	= loadfx( "explosions/aerial_explosion" );
	level._effect[ "heli_aerial_explosion_large" ]		 	= loadfx( "explosions/aerial_explosion_large" );

		
	add_earthquake( "backdoor_barracks" , 0.2, .75, 1024 );
	add_earthquake( "steamroom" , 0.25, 2.75, 1024 );
	add_earthquake( "controlroom_shake" , 0.25, .75, 1024 );    

	maps\createfx\af_caves_fx::main();
}


introSandStorm()
{
	player = getentarray( "player", "classname" )[ 0 ];
	playfx( getfx( "sand_storm_intro" ), player.origin );
}
