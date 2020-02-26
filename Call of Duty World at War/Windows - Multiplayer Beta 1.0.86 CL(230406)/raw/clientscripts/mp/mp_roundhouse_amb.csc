//
// file: mp_seelow_amb.csc
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
		
	declareAmbientPackage( "indoors_pkg" );

	declareAmbientPackage( "indoors2_pkg" );

	declareAmbientPackage( "building_pkg" );

	declareAmbientPackage( "building2_pkg" );

	declareAmbientPackage( "smallroom_pkg" );

	declareAmbientPackage( "train_pkg");

	declareAmbientPackage( "catwalk_pkg");

	declareAmbientPackage( "openmetal_pkg");


	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	declareAmbientRoom( "outdoors_room" );
			setAmbientRoomTone( "outdoors_room", "outdoors_wind" );
			setAmbientRoomReverb( "outdoors_room", "mountains", 1, 1);

	declareAmbientRoom( "indoors_room" );
			setAmbientRoomTone( "indoors_room", "indoors_wind" );
			setAmbientRoomReverb( "indoors_room", "mediumroom", 1, .5);

	declareAmbientRoom( "indoors2_room" );
			setAmbientRoomTone( "indoors2_room", "indoors_wind" );
			setAmbientRoomReverb( "indoors2_room", "stoneroom", 1, .5);
			
	declareAmbientRoom( "building_room" );
			setAmbientRoomTone( "building_room", "outdoors_wind" );
			setAmbientRoomReverb( "building_room", "stoneroom", 1, .6);

	declareAmbientRoom( "building2_room" );
			setAmbientRoomTone( "building2_room", "indoors_wind" );
			setAmbientRoomReverb( "building2_room", "stoneroom", 1, .6);
		
	declareAmbientRoom( "smallroom_room" );
			setAmbientRoomTone( "smallroom_room", "indoors_wind" );
			setAmbientRoomReverb( "smallroom_room", "sewerpipe", 1, .5);

	declareAmbientRoom( "train_room" );
			setAmbientRoomTone( "train_room", "indoors_wind" );
			setAmbientRoomReverb( "train_room", "stoneroom", 1, .3);

	declareAmbientRoom( "catwalk_room" );
			setAmbientRoomTone( "catwalk_room", "outdoors_wind" );
			setAmbientRoomReverb( "catwalk_room", "plate", 1, 1);

	declareAmbientRoom( "openmetal_room" );
			setAmbientRoomTone( "openmetal_room", "outdoors_wind" );
			setAmbientRoomReverb( "openmetal_room", "stoneroom", 1, .5);

	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************


		activateAmbientPackage(0, "outdoors_pkg", 0 );
		activateAmbientRoom(0, "outdoors_room", 0 );


	// Unlike the server side, no need to wait for players to be set up on the client side - 
	// no players == no client scripts running yet.
	
		
}

