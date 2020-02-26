//
// file: mp_brandenburg_amb.csc
// description: clientside ambient script for template: setup ambient sounds, etc.
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
	
	declareAmbientPackage( "outdoors_pkg" );
	
	declareAmbientPackage( "small_room_pkg" );
		
	declareAmbientPackage( "partial_room_pkg" );

	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	declareAmbientRoom( "outdoors_room" );
			setAmbientRoomTone( "outdoors_room", "outdoor_wind" );
			setAmbientRoomReverb( "outdoors_room", "mountains", 1, 1);

	declareAmbientRoom( "small_room" );
			setAmbientRoomTone( "small_room", "indoor_wind" );
			setAmbientRoomReverb( "small_room", "partial_room", 1, .9);

	declareAmbientRoom( "partial_room" );
			setAmbientRoomTone( "partial_room", "partial_wind" );
			setAmbientRoomReverb( "partial_room", "partial_room", 1, 1);


	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************


		activateAmbientPackage(0, "outdoors_pkg", 0 );
		activateAmbientRoom(0, "outdoors_room", 0 );


	// Unlike the server side, no need to wait for players to be set up on the client side - 
	// no players == no client scripts running yet.
	
		
}

