//
// file: mp_courtyard_amb.csc
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
	
	declareAmbientPackage( "under_balcony_pkg" );

	declareAmbientPackage( "underground_pkg" );

	declareAmbientPackage( "wooden_pkg" );
	

	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	declareAmbientRoom( "outdoors_room" );
			setAmbientRoomReverb( "outdoors_room", "mountains", 1, 1);

	declareAmbientRoom( "under_balcony_room" );
			setAmbientRoomReverb( "under_balcony_room", "partial_room", 1, 1);

	declareAmbientRoom( "underground_room" );
			setAmbientRoomTone( "underground_room", "underground_tone" );
			setAmbientRoomReverb( "underground_room", "stonecorridor", 1, .8);

	declareAmbientRoom( "wooden_room" );
			setAmbientRoomReverb( "wooden_room", "wood_room", 1, 1);

	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************


		activateAmbientPackage( 0, "outdoors_pkg", 0 );
		activateAmbientRoom( 0, "outdoors_room", 0 );
	
		
}

