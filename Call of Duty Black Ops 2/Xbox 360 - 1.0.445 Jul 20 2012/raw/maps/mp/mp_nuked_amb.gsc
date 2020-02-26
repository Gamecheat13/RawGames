//
// file: mp_nuked_amb.gsc
// description: level ambience script for mp_nuked
// scripter: 
//

#include maps\mp\_utility;
#include maps\mp\_ambientpackage;


main()
{
	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
//	declareAmbientPackage( "outdoors_pkg" );
//	addAmbientElement( "outdoors_pkg", "elm_dog1", 3, 6, 1800, 2000, 270, 450 );
//	addAmbientElement( "outdoors_pkg", "elm_dog2", 5, 10 );
//	addAmbientElement( "outdoors_pkg", "elm_dog3", 10, 20 );
//	addAmbientElement( "outdoors_pkg", "elm_donkey1", 25, 35 );
//	addAmbientElement( "outdoors_pkg", "elm_horse1", 10, 25 );

//	declareAmbientPackage( "west_pkg" );
//	addAmbientElement( "west_pkg", "elm_insect_fly", 2, 8, 0, 150, 345, 375 );
//	addAmbientElement( "west_pkg", "elm_owl", 3, 10, 400, 500, 269, 270 );
//	addAmbientElement( "west_pkg", "elm_wolf", 10, 15, 100, 500, 90, 270 );
//	addAmbientElement( "west_pkg", "animal_chicken_idle", 3, 12 );
//	addAmbientElement( "west_pkg", "animal_chicken_disturbed", 10, 30 );

//	declareAmbientPackage( "northwest_pkg" );
//	addAmbientElement( "northwest_pkg", "elm_wind_buffet", 3, 6 );
//	addAmbientElement( "northwest_pkg", "elm_rubble", 5, 10 );
//	addAmbientElement( "northwest_pkg", "elm_industry", 10, 20 );
//	addAmbientElement( "northwest_pkg", "elm_stress", 5, 20, 200, 2000 );

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
//	activateAmbientPackage( "outdoors_pkg", 0 );


	//the same pattern is followed for setting up ambientRooms
//	declareAmbientRoom( "outdoors_room" );
//	setAmbientRoomTone( "outdoors_room", "amb_shanty_ext_temp" );

//	declareAmbientRoom( "west_room" );
//	setAmbientRoomTone( "west_room", "bomb_tick" );

//	declareAmbientRoom( "northwest_room" );
//	setAmbientRoomTone( "northwest_room", "weap_sniper_heartbeat" );

//	activateAmbientRoom( "outdoors_room", 0 );
}
