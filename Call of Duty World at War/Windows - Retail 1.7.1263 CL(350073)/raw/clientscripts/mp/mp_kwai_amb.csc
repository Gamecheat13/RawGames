//
// file: mp_kwai_amb.csc
// description: clientside ambient script for mp_kwai: setup ambient sounds, etc.
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
	//Outdoor
	//***************

		declareAmbientpackage( "outdoor_pkg" );	
		
		declareAmbientpackage( "cave_pkg" );	
		
		declareAmbientpackage( "partial_pkg" );
		
		declareAmbientpackage( "full_pkg" );
		

	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms

	//***************
	//Outdoor
	//*************** 

		declareAmbientRoom( "outdoor_room" );	
			setAmbientRoomReverb( "outdoor_room", "mountains", .8, 1 );
			setAmbientRoomtone( "outdoor_room", "bg_steady" );	
			
		declareAmbientRoom( "cave_room" );
			setAmbientRoomReverb( "cave_room", "stoneroom", 1, 1);
			setAmbientRoomtone( "cave_room", "cave_int" );
			
		declareAmbientRoom( "partial_room" );
			setAmbientRoomReverb( "partial_room", "wood_room", 1, 1);
			setAmbientRoomtone( "partial_room", "partial" );
			
		declareAmbientRoom( "full_room" );
			setAmbientRoomReverb( "full_room", "wood_room", 1, 1);
			setAmbientRoomtone( "full_room", "full" );


	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************
	
		activateAmbientPackage( 0, "outdoor_pkg", 0 );
		activateAmbientRoom( 0, "outdoor_room", 0 );	
}

