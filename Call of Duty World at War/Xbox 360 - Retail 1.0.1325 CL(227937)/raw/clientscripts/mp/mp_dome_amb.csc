//
// file: mp_dome_amb.csc
// description: clientside ambient script for mp_dome: setup ambient sounds, etc.
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
	//Dome Pkgs
	//***************


	declareAmbientPackage( "outdoor_pkg" );	

	declareAmbientPackage( "dome_out_hall_pkg" );

	declareAmbientPackage( "dome_int_hall_pkg" );
		addambientelement( "dome_int_hall_pkg", "arty_aftershock", 15, 45, 100, 500 );

	declareAmbientPackage( "dome_int_pkg" );
		addambientelement( "dome_int_pkg", "arty_aftershock", 15, 45, 100, 500 );
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms

	//***************
	//Dome Rooms
	//***************


	declareAmbientRoom( "outdoor_room" );
			setAmbientRoomReverb( "outdoor_room", "dome_out", 0.8, 1);

	declareAmbientRoom( "dome_out_hall_room" );
			setAmbientRoomReverb( "dome_out_hall_room", "dome_out_hall", 0.8, 1);

	declareAmbientRoom( "dome_int_hall_room" );
			setAmbientRoomReverb( "dome_int_hall_room", "dome_int_hall", 1, 1);
	
	declareAmbientRoom( "dome_int_room" );
			setAmbientRoomReverb( "dome_int_room", "dome_int", 1, 1);
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

		activateAmbientPackage( 0, "outdoor_pkg", 0 );
		activateAmbientRoom( 0, "outdoor_room", 0 );	
}

