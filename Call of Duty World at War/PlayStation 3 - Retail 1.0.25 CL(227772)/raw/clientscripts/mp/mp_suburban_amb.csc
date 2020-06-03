//
// file: mp_suburban_amb.csc
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
	
	declareAmbientPackage( "outdoor_pkg" );
	
	declareAmbientPackage( "indoor_pkg" );

	declareAmbientPackage( "train_pkg" );
	
	declareAmbientPackage( "shed_pkg" );
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	declareAmbientRoom( "outdoor_room" );
			setAmbientRoomReverb( "outdoor_room", "mountains", 1, 1);		

	declareAmbientRoom( "indoor_room" );
			setAmbientRoomReverb( "indoor_room", "mediumroom", 1, 1);

	declareAmbientRoom( "train_room" );
			setAmbientRoomReverb( "train_room", "plate", 1, 1);

	declareAmbientRoom( "shed_room" );
			setAmbientRoomReverb( "shed_room", "smallroom", 1, 1);
	
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************


		activateAmbientPackage( 0, "outdoor_pkg", 0 );
		activateAmbientRoom( 0, "outdoor_room", 0 );
	
		
}

