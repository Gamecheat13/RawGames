#include common_scripts\utility;
#include maps\_utility;

main()
{
	level._effect[ "m16_muzzleflash" ]		        = loadfx( "muzzleflashes/m16_flash_wv" );
	
	level._effect[ "javelin_muzzle" ] 						= loadfx( "muzzleflashes/javelin_flash_wv" );
	
	//Hangar Welder
	level._effect[ "welding_runner" ]						= loadfx( "misc/welding_runner" );
	
	//humvees at end
	level._effect[ "humvee_radiator_steam" ]				= loadfx( "smoke/steam_vent_large_wind" );
	
	//basketball effects
	level._effect[ "ball_bounce_dust_runner" ]				= loadfx( "impacts/ball_bounce_dust_runner" );
	level._effect[ "footstep_dust" ]						= loadfx( "impacts/footstep_dust" );
		
	
	//ambient fx
	level._effect[ "sand_storm_distant_oriented" ] 			= LoadFX( "weather/sand_storm_distant_oriented_training" );
	level._effect[ "sand_storm_distant" ] 					= LoadFX( "weather/sand_storm_distant_training" );

	level._effect[ "dust_wind_fast" ]						= loadfx( "dust/dust_wind_fast_afcaves" );
	level._effect[ "sand_spiral_runner" ] 					= loadfx( "dust/sand_spiral_runner" );
	level._effect[ "trash_spiral_runner" ] 					= loadfx( "misc/trash_spiral_runner" );
	level._effect[ "sand_spray_detail_oriented_runner" ]	= loadfx( "dust/sand_spray_detail_oriented_runner" );

	level._effect[ "room_smoke_200" ] 						= loadfx( "smoke/room_smoke_200" );
	level._effect[ "room_smoke_400" ] 						= loadfx( "smoke/room_smoke_400" );
	level._effect[ "hallway_smoke_light" ] 					= loadfx( "smoke/hallway_smoke_light" );
	level._effect[ "ground_smoke_1200x1200" ]				= loadfx( "smoke/ground_smoke1200x1200" );

	level._effect[ "drips_slow" ]							= loadfx( "misc/drips_slow" );
	level._effect[ "drips_fast" ]							= loadfx( "misc/drips_fast" );
	
	footstep_effects();
	treadfx_override();
	maps\createfx\trainer_fx::main();	

}

hummer_steam()
{
	hummer_steam = getent( "hummer_steam", "targetname" );
	playfx( getfx( "humvee_radiator_steam" ), hummer_steam.origin );
	hummer_steam thread play_sound_in_space( "scn_trainer_radiator_start" );
	wait( 2 );
	hummer_steam thread play_loop_sound_on_entity( "scn_trainer_radiator_loop" );
}

footstep_effects()
{

	//Regular footstep fx
	animscripts\utility::setFootstepEffect( "wood",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "sand",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "dirt",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "concrete",	loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "rock",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffect( "mud",		loadfx ( "impacts/footstep_mud" ) );
	
	//Small footstep fx
	animscripts\utility::setFootstepEffectSmall( "wood",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffectSmall( "sand",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffectSmall( "dirt",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffectSmall( "concrete",	loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffectSmall( "rock",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setFootstepEffectSmall( "mud",			loadfx ( "impacts/footstep_mud" ) );
	  
	//Other notetrack fx
	/*
	setNotetrackEffect( <notetrack>, <tag>, <surface>, <loadfx>, <sound_prefix>, <sound_suffix> )
		<notetrack>: name of the notetrack to do the fx/sound on
		<tag>: name of the tag on the AI to use when playing fx
		<surface>: the fx will only play when the AI is on this surface. Specify "all" to make it work for all surfaces.
		<loadfx>: load the fx to play here
		<sound_prefix>: when this notetrack hits a sound can be played. This is the prefix of the sound alias to play ( gets followed by surface type )
		<sound_suffix>: suffix of sound alias to play, follows the surface type. Example: prefix of "bodyfall_" and suffix of "_large" will play sound alias "bodyfall_dirt_large" when the notetrack happens on dirt.
	*/
	animscripts\utility::setNotetrackEffect( "bodyfall small", 		"J_SpineLower", 		"sand",		loadfx ( "impacts/bodyfall_dust_small_runner" ), "bodyfall_", "_small" );
	animscripts\utility::setNotetrackEffect( "bodyfall small", 		"J_SpineLower", 		"dirt",		loadfx ( "impacts/bodyfall_dust_small_runner" ), "bodyfall_", "_small" );
	animscripts\utility::setNotetrackEffect( "bodyfall small", 		"J_SpineLower", 		"concrete",	loadfx ( "impacts/bodyfall_default_small_runner" ), "bodyfall_", "_small" );
	animscripts\utility::setNotetrackEffect( "bodyfall small", 		"J_SpineLower", 		"rock",		loadfx ( "impacts/bodyfall_default_small_runner" ), "bodyfall_", "_small" );
//	animscripts\utility::setNotetrackEffect( "bodyfall small", 		"J_SpineLower", 		"mud",		loadfx ( "impacts/bodyfall_mud_small_runner" ), "bodyfall_", "_small" );
	
	animscripts\utility::setNotetrackEffect( "bodyfall large", 		"J_SpineLower", 		"sand",		loadfx ( "impacts/bodyfall_dust_large_runner" ), "bodyfall_", "_large" );
	animscripts\utility::setNotetrackEffect( "bodyfall large", 		"J_SpineLower", 		"dirt",		loadfx ( "impacts/bodyfall_dust_large_runner" ), "bodyfall_", "_large" );
	animscripts\utility::setNotetrackEffect( "bodyfall large", 		"J_SpineLower", 		"concrete",	loadfx ( "impacts/bodyfall_default_large_runner" ), "bodyfall_", "_large" );
	animscripts\utility::setNotetrackEffect( "bodyfall large", 		"J_SpineLower", 		"rock",		loadfx ( "impacts/bodyfall_default_large_runner" ), "bodyfall_", "_large" );
	animscripts\utility::setNotetrackEffect( "bodyfall large", 		"J_SpineLower", 		"mud",		loadfx ( "impacts/bodyfall_mud_large_runner" ), "bodyfall_", "_large" );
	
	animscripts\utility::setNotetrackEffect( "knee fx left", 		"J_Knee_LE", 			"sand",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx left", 		"J_Knee_LE", 			"dirt",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx left", 		"J_Knee_LE", 			"concrete",	loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx left", 		"J_Knee_LE", 			"rock",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx left", 		"J_Knee_LE", 			"mud",		loadfx ( "impacts/footstep_mud" ) );
	
	animscripts\utility::setNotetrackEffect( "knee fx right", 		"J_Knee_RI", 			"sand",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx right", 		"J_Knee_RI", 			"dirt",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx right", 		"J_Knee_RI", 			"concrete",	loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx right", 		"J_Knee_RI", 			"rock",		loadfx ( "impacts/footstep_dust" ) );
	animscripts\utility::setNotetrackEffect( "knee fx right", 		"J_Knee_RI", 			"mud",		loadfx ( "impacts/footstep_mud" ) );
	
}

treadfx_override()
{

	maps\_treadfx::setvehiclefx( "pavelow", "brick", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "bark", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "carpet", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "cloth", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "concrete", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "dirt", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "flesh", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "foliage", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "glass", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "grass", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "gravel", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "ice", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "metal", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "mud", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "paper", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "plaster", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "rock", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "sand", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "snow", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "water", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "wood", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "asphalt", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "ceramic", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "plastic", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "rubber", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "cushion", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "fruit", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "painted metal", "treadfx/heli_sand_large" );
 	maps\_treadfx::setvehiclefx( "pavelow", "default", "treadfx/heli_sand_large" );
	maps\_treadfx::setvehiclefx( "pavelow", "none", "treadfx/heli_sand_large" );

	maps\_treadfx::setvehiclefx( "cobra", "brick", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "bark", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "carpet", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "cloth", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "concrete", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "dirt", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "flesh", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "foliage", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "glass", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "grass", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "gravel", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "ice", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "metal", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "mud", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "paper", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "plaster", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "rock", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "sand", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "snow", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "water", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "wood", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "asphalt", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "ceramic", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "plastic", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "rubber", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "cushion", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "fruit", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "painted metal", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "cobra", "default", "treadfx/heli_sand_default" );
	maps\_treadfx::setvehiclefx( "cobra", "none", "treadfx/heli_sand_default" );

	maps\_treadfx::setvehiclefx( "blackhawk", "brick", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "bark", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "carpet", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "cloth", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "concrete", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "dirt", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "flesh", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "foliage", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "glass", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "grass", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "gravel", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "ice", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "metal", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "mud", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "paper", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "plaster", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "rock", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "sand", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "snow", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "water", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "wood", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "asphalt", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "ceramic", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "plastic", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "rubber", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "cushion", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "fruit", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "painted metal", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "blackhawk", "default", "treadfx/heli_sand_default" );
	maps\_treadfx::setvehiclefx( "blackhawk", "none", "treadfx/heli_sand_default" );

	maps\_treadfx::setvehiclefx( "f15", "brick", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "bark", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "carpet", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "cloth", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "concrete", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "dirt", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "flesh", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "foliage", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "glass", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "grass", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "gravel", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "ice", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "metal", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "mud", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "paper", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "plaster", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "rock", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "sand", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "snow", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "water", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "wood", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "asphalt", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "ceramic", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "plastic", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "rubber", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "cushion", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "fruit", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "painted metal", "treadfx/heli_sand_default" );
 	maps\_treadfx::setvehiclefx( "f15", "default", "treadfx/heli_sand_default" );
	maps\_treadfx::setvehiclefx( "f15", "none", "treadfx/heli_sand_default" );

	maps\_treadfx::setvehiclefx( "hummer_physics", "brick", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "bark", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "carpet", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "cloth", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "concrete", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "dirt", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "flesh", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "foliage", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "glass", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "grass", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "gravel", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "ice", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "metal", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "mud", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "paper", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "plaster", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "rock", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "sand", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "snow", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "water", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "wood", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "asphalt", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "ceramic", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "plastic", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "rubber", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "cushion", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "fruit", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "painted metal", "treadfx/tread_sand_default" );
 	maps\_treadfx::setvehiclefx( "hummer_physics", "default", "treadfx/tread_sand_default" );
	maps\_treadfx::setvehiclefx( "hummer_physics", "none", "treadfx/tread_sand_default" );

}
