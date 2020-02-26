//
// file: mp_docks_amb.csc
// description: clientside ambient script for mp_docks: setup ambient sounds, etc.
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
	//_none
	//***************

	declareAmbientPackage( "default_pkg" );
	
	declareAmbientPackage( "rain_package" );
	
	declareAmbientPackage( "rain_out_package" );
	
	declareAmbientPackage( "sub_package" );
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms

	//***************
	//_none
	//***************

	declareAmbientRoom( "default_room" );
		setAmbientRoomReverb( "default_room" , "cave", 1, 1 );
		//setAmbientRoomTone( "default_room" , "roof_rain_loop" );
	
	declareAmbientRoom( "rain_room" );
		setAmbientRoomReverb( "rain_room" , "cave", 1, 1 );
		setAmbientRoomTone( "rain_room" , "helmetrainf" );
	
	declareAmbientRoom( "rain_out_room" );
		setAmbientRoomReverb( "rain_out_room" , "mountains", 1, 1 );
		setAmbientRoomTone( "rain_out_room" , "helmetrainf_2" );
		
	declareAmbientRoom( "sub_room" );
		setAmbientRoomReverb( "sub_room" , "sewerpipe", 1, 0.5 );
		//setAmbientRoomTone( "sub_room" , "roof_rain_loop" );
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

		activateAmbientPackage( 0, "default_pkg", 0 );
		activateAmbientRoom( 0, "default_room", 0 );
		
		array_thread(getstructarray( "lightning", "targetname" ), ::lightning_audio);
}

lightning_audio()
{
	while(1)
	{
		wait(randomintrange(45,120));
		{
			playfx (0, level._effect["mp_lightning_flash"], self.origin );
			playsound(0,"thunder", self.origin );
		}
	}
}