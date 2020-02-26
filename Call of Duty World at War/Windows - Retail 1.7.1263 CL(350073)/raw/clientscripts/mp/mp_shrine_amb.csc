//
// file: mp_shrine_amb.csc
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
	//Shrine Pkgs
	//***************


	declareAmbientPackage( "outdoor_pkg" );	

	declareAmbientPackage( "indoors_pkg" );

	declareAmbientPackage( "wood_pkg" );

	declareAmbientPackage( "bridge_pkg" );

	declareAmbientPackage( "cave_pkg" );

	declareAmbientPackage( "bowl_pkg" );

	declareAmbientPackage( "pass_pkg" );

	declareAmbientPackage( "nook_pkg" );


	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms

	//***************
	//Shrine Rooms
	//***************


	declareAmbientRoom( "outdoor_room" );
			setAmbientRoomReverb( "outdoor_room", "mountains", 1, 1);

	declareAmbientRoom( "wood_room" );
			setAmbientRoomReverb( "wood_room", "wood_room", 1, 1);

	declareAmbientRoom( "bridge_room" );
			setAmbientRoomReverb( "bridge_room", "under_bridge", 1, 1);

	declareAmbientRoom( "bowl_room" );
			setAmbientRoomReverb( "bowl_room", "auditorium", 1, .5);

	declareAmbientRoom( "nook_room" );
			setAmbientRoomReverb( "nook_room", "stoneroom", 1, .1);

	declareAmbientRoom( "pass_room" );
			setAmbientRoomReverb( "pass_room", "alley", 1, 1);


	declareAmbientRoom( "indoors_room" );
			setAmbientRoomTone( "indoors_room", "inside_wind" );
			setAmbientRoomReverb( "indoors_room", "stoneroom", 1, .4);
			

	declareAmbientRoom( "cave_room" );
			setAmbientRoomTone( "cave_room", "inside_cave" );
			setAmbientRoomReverb( "cave_room", "cave", 1, .3);



	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

		activateAmbientPackage( 0, "outdoor_pkg", 0 );
		activateAmbientRoom( 0, "outdoor_room", 0 );	
}

