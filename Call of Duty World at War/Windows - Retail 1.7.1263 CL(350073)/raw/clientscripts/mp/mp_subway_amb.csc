//
// file: mp_subway_amb.csc
// description: clientside ambient script for mp_subway: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;

main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	declareAmbientPackage( "station_int_pkg" );	

	declareAmbientPackage( "main_tunnel_pkg" );
	
	declareAmbientPackage( "car_int_pkg" );
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	declareAmbientRoom( "station_int_room" );
			setAmbientRoomReverb( "station_int_room", "STONECORRIDOR", 1, 0.6);

	declareAmbientRoom( "main_tunnel_room" );
			setAmbientRoomReverb( "main_tunnel_room", "CONCERTHALL", 1, 0.9);

	declareAmbientRoom( "car_int_room" );
			setAmbientRoomReverb( "car_int_room", "sewerpipe", 1, 1);


	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

		activateAmbientPackage( 0, "station_int_pkg", 0 );
		activateAmbientRoom( 0, "station_int_room", 0 );
		
	//*************************************************************************************************

	//                                      STATIC LOOPS

	//*************************************************************************************************


		//steam leaks
		//loopsound("steam_leak_high", (-1559, 2668, 925), 7.679);
		//loopsound("steam_leak_low", (-1559, 2668, 925), 8.874);
		
		
}

