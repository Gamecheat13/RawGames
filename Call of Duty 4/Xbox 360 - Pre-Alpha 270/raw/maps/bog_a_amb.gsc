#include maps\_ambient;
#include maps\_equalizer;

main()
{
	// Set the underlying ambient track
	level.ambient_track [ "exterior" ] = "ambient_bog_ext3aa";

	level.ambient_reverb[ "exterior" ] = [];
	level.ambient_reverb[ "exterior" ][ "priority" ] = "snd_enveffectsprio_level";
	level.ambient_reverb[ "exterior" ][ "roomtype" ] = "alley";
	level.ambient_reverb[ "exterior" ][ "drylevel" ] = .9;
	level.ambient_reverb[ "exterior" ][ "wetlevel" ] = .01;
	level.ambient_reverb[ "exterior" ][ "fadetime" ] = 2;


	level.ambient_track [ "exterior1" ] = "ambient_bog_ext1";

	level.ambient_reverb[ "exterior1" ] = [];
	level.ambient_reverb[ "exterior1" ][ "priority" ] = "snd_enveffectsprio_level";
	level.ambient_reverb[ "exterior1" ][ "roomtype" ] = "alley";
	level.ambient_reverb[ "exterior1" ][ "drylevel" ] = .9;
	level.ambient_reverb[ "exterior1" ][ "wetlevel" ] = .01;
	level.ambient_reverb[ "exterior1" ][ "fadetime" ] = 2;


	level.ambient_reverb[ "interior_stone" ] = [];
	level.ambient_reverb[ "interior_stone" ][ "priority" ] = "snd_enveffectsprio_level";
	level.ambient_reverb[ "interior_stone" ][ "roomtype" ] = "stoneroom";
	level.ambient_reverb[ "interior_stone" ][ "drylevel" ] = .9;
	level.ambient_reverb[ "interior_stone" ][ "wetlevel" ] = .3;
	level.ambient_reverb[ "interior_stone" ][ "fadetime" ] = 2;

	defineFilter( "interior_stone", 0, "highshelf", 3500, -6, 1 );
	add_channel_to_filter( "interior_stone", "ambient" );
	add_channel_to_filter( "interior_stone", "element" );
	add_channel_to_filter( "interior_stone", "vehicle" );
	add_channel_to_filter( "interior_stone", "weapon" );
	add_channel_to_filter( "interior_stone", "voice" );

	defineFilter( "shanty", 0, "highshelf", 3500, -2, 1 );
	add_channel_to_filter( "shanty", "ambient" );
	add_channel_to_filter( "shanty", "element" );
	add_channel_to_filter( "shanty", "vehicle" );

	defineFilter( "underpass", 0, "highshelf", 3500, -2, 1  );
	add_channel_to_filter( "underpass", "ambient" );
	add_channel_to_filter( "underpass", "element" );
	add_channel_to_filter( "underpass", "vehicle" );

	thread maps\_utility::set_ambient( "exterior" );

	ambientDelay( "exterior", 10.0, 20.0 ); // Trackname, min and max delay between ambient events
	ambientEvent( "exterior", "elm_windgust1", 	2.0 );
	ambientEvent( "exterior", "elm_windgust2", 	2.0 );
	ambientEvent( "exterior", "elm_windgust3", 	2.0 );
	ambientEvent( "exterior", "elm_windgust4", 	2.0 );
	ambientEvent( "exterior", "elm_insect_fly", 3.0 );
	ambientEvent( "exterior", "elm_explosions_dist", 	1.0 );
	ambientEvent( "exterior", "elm_explosions_med", 	1.0 );
	ambientEvent( "exterior", "elm_artillery_med", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_50cal_dist", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_50cal_med", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_ak47_dist", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_ak47_med", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_m16_dist", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_m16_med", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_m240_med", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_m240_dist", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_miniuzi_med", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_miniuzi_dist", 	1.0 );
	ambientEvent( "exterior", "elm_gunfire_usassault_med", 	1.0 );
	ambientEvent( "exterior", "elm_jet_flyover_med", 	2.0 );
	ambientEvent( "exterior", "elm_jet_flyover_dist", 	2.0 );
	ambientEvent( "exterior", "null", 			0.3 );
	

	ambientDelay( "exterior1", 2.0, 8.0 ); // Trackname, min and max delay between ambient events
	ambientEvent( "exterior1", "elm_windgust1", 	3.0 );
	ambientEvent( "exterior1", "elm_windgust2", 	3.0 );
	ambientEvent( "exterior1", "elm_windgust3", 	3.0 );
	ambientEvent( "exterior1", "elm_windgust4", 	3.0 );
	ambientEvent( "exterior1", "elm_insect_fly", 6.0 );
	ambientEvent( "exterior1", "elm_explosions_dist", 	3.0 );
	ambientEvent( "exterior1", "elm_explosions_med", 	3.0 );
	ambientEvent( "exterior1", "elm_artillery_med", 	3.0 );
	ambientEvent( "exterior1", "elm_gunfire_50cal_dist", 	3.0 );
	ambientEvent( "exterior1", "elm_gunfire_50cal_med", 	3.0 );
	ambientEvent( "exterior1", "elm_gunfire_ak47_dist", 	3.0 );
	ambientEvent( "exterior1", "elm_gunfire_ak47_med", 	3.0 );
	ambientEvent( "exterior1", "elm_gunfire_m16_dist", 	3.0 );
	ambientEvent( "exterior1", "elm_gunfire_m16_med", 	3.0 );
	ambientEvent( "exterior1", "null", 			0.3 );
	ambientEventStart( "exterior" );
}	
	
	