//
// file: mp_labc_amb.csc
// description: clientside ambient script for mp_labc: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\mp\_utility; 
#include clientscripts\mp\_ambientpackage;


//{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

//		activateAmbientPackage( 0, "_pkg", 0 );
//		activateAmbientRoom( 0, "_room", 0 );		
//}


main()
{
	
	declareAmbientRoom("outside", true );
		setAmbientRoomtone ("outside", "amb_wind_la_outside", 1, 1);
		setAmbientRoomReverb( "outside", "mp_la_outside", 1, 1 );
		setAmbientRoomContext( "outside", "ringoff_plr", "outdoor" );
		
	activateAmbientRoom( 0, "outside", 0 );	
	
}
