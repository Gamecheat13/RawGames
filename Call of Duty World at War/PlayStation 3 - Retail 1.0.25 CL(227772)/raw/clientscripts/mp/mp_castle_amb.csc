//
// file: mp_castle_amb.csc
// description: clientside ambient script for mp_castle: setup ambient sounds, etc.
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

	declareAmbientPackage( "outdoor_pkg" );	

	declareambientpackage( "wood_room_pkg" );

	declareambientpackage( "partial_room_pkg" );

	declareambientpackage( "stone_tunnel_pkg" );
	
	declareambientpackage( "under_bridge_pkg" );

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
			setAmbientRoomReverb( "outdoor_room", "mountains", 1, 1);

	declareAmbientRoom( "wood_room" );
			setAmbientRoomTone( "wood_room", "int_wind" );
			setAmbientRoomReverb( "wood_room", "wood_room", 1, 1);

	declareAmbientRoom( "partial_room" );
			setAmbientRoomTone( "partial_room", "int_wind" );
			setAmbientRoomReverb( "partial_room", "wood_room", 1, 1);

	declareAmbientRoom( "stone_tunnel_room" );
			setAmbientRoomReverb( "stone_tunnel_room", "stonecorridor", 1, .4);

	declareAmbientRoom( "under_bridge_room" );
			setAmbientRoomReverb( "under_bridge_room", "stonecorridor", 1, .15);
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

		activateAmbientPackage( 0, "outdoor_pkg", 0 );
		activateAmbientRoom( 0, "outdoor_room", 0 );	
}

