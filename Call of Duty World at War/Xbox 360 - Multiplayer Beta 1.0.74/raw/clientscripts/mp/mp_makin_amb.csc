//
// file: mp_makin_amb.csc
// description: clientside ambient script for mp_makin: setup ambient sounds, etc.
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
	
	//***************
	//mp_makin
	//***************

	declareAmbientPackage( "outdoor_pkg" );	
	
	declareAmbientPackage( "hut_pkg" );	
	
	declareAmbientPackage( "walkwaymetal_pkg" );	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms

	//***************
	//mp_makin
	//***************

	declareAmbientRoom( "outdoor_room" );
			setAmbientRoomReverb( "outdoor_room", "mountains", 1, 1);
	
	declareAmbientRoom( "hut_room" );
			setAmbientRoomReverb( "hut_room", "wood_room", 1, 1);
	
	declareAmbientRoom( "walkwaymetal_room" );
			setAmbientRoomReverb( "walkwaymetal_room", "mountains", 1, .3);
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

		activateAmbientPackage( 0, "outdoor_pkg", 0 );
		activateAmbientRoom( 0, "outdoor_room", 0 );
}

