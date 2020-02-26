//
// file: mp_airfield_amb.csc
// description: clientside ambient script for mp_drum: setup ambient sounds, etc.
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
		
		declareAmbientPackage( "admin_int_pkg" );
	
		declareAmbientpackage( "admin_partial_pkg" );
			addambientelement ( "admin_int_pkg", "rock_dust", 15, 25, 75, 300 );
			addambientelement ( "admin_int_pkg", "wood_dust", 10, 30, 75, 300 );
		
		declareAmbientpackage( "tunnel_ent_pkg" );	

		declareAmbientpackage( "tunnel_pkg" );	

		declareAmbientpackage( "plane_int_pkg" );
			addambientelement ( "plane_int_pkg", "creaks", 5, 20, 15, 100 );

		declareAmbientpackage( "bunker_pkg" );

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
			setAmbientRoomtone( "outdoor_room", "default_amb" );	
			setAmbientRoomReverb( "outdoor_room", "mountains", .8, 1 );

		declareAmbientRoom( "admin_int_room" );
			setAmbientRoomReverb( "admin_int_room", "dome_int_hall", 1, .8 );

		declareAmbientRoom( "admin_partial_room" );
			setAmbientRoomReverb( "admin_partial_room", "dome_int_hall", 1, .8 );

		declareAmbientRoom( "tunnel_ent_room" );
			setAmbientRoomReverb( "tunnel_ent_room", "wooden_structure", .8, 1 );

		declareAmbientRoom( "tunnel_room" );
			setAmbientRoomReverb( "tunnel_room", "stonecorridor", 1, 0.6 );
	
		declareAmbientRoom( "plane_int_room" );
			setAmbientRoomReverb( "plane_int_room", "sewerpipe", 1, 0.5 );

		declareAmbientRoom( "bunker_room" );
			setAmbientRoomReverb( "bunker_room", "dome_int_hall", 1, 0.8 );

	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************
	
		activateAmbientPackage( 0, "outdoor_pkg", 0 );
		activateAmbientRoom( 0, "outdoor_room", 0 );	
}

