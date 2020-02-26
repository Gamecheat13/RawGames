//
// file: mp_kneedeep_amb.csc
// description: clientside ambient script for mp_kneedeep: setup ambient sounds, etc.
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
		
		declareAmbientpackage( "indoor_stone_pkg" );	
		
		declareAmbientpackage( "indoor_wood_pkg" );
		
		declareAmbientpackage( "indoor_metallic_pkg" );
		

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
			setAmbientRoomtone( "outdoor_room", "bg_steady" );	
			setAmbientRoomReverb( "outdoor_room", "mountains", .8, 1 );
			
		declareAmbientRoom( "indoor_stone_room" );
			setAmbientRoomReverb( "indoor_stone_room", "stoneroom", 1, .9);
			
		declareAmbientRoom( "indoor_wood_room" );
			setAmbientRoomReverb( "indoor_wood_room", "wood_room", 1, 1);
			
		declareAmbientRoom( "indoor_metallic_room" );
			setAmbientRoomReverb( "indoor_metallic_room", "sewerpipe", 1, .4);


	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************
	
		activateAmbientPackage( 0, "outdoor_pkg", 0 );
		activateAmbientRoom( 0, "outdoor_room", 0 );	
}

