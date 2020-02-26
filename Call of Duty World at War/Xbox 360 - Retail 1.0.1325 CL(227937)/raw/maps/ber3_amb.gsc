//
// file: ber3_amb.gsc
// description: level ambience script for berlin3
// scripter: slayback
//
#include maps\_utility;
#include maps\_ambientpackage;
#include maps\_music;

main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	//***************
	//Ber3_Outdoors
	//*************** 

		declareAmbientPackage( "ber3_outdoors_pkg" );
			
			//addAmbientElement( "ber3_outdoors_pkg", "amb_stone_small", 10, 20, 100, 500);
			//addAmbientElement( "ber3_outdoors_pkg", "amb_stone_med", 10, 20, 100,500);
			//addAmbientElement( "ber3_outdoors_pkg", "bomb_far", 2, 15, 10, 200 );

	//***************
	//Ber3_Building_Interrior
	//*************** 

		declareAmbientPackage( "ber3_stone_room_pkg" );
		
			//addAmbientElement( "ber3_stone_room_pkg", "amb_stone_small", 10, 20, 100, 200);
			//addAmbientElement( "ber3_stone_room_pkg", "bomb_far", 2, 15, 10, 200 );
			//addAmbientElement( "ber3_stone_room_pkg", "bomb_medium", 15, 30, 100, 500 );
	
		declareAmbientPackage( "ber3_wood_room_pkg" );
	
			//addAmbientElement( "ber3_wood_room_pkg", "amb_wood_small", 10, 20, 100, 200);
			//addAmbientElement( "ber3_wood_room_pkg", "amb_wood_boards", 20, 40, 100, 500);
			//addAmbientElement( "ber3_wood_room_pkg", "amb_wood_creak", 20, 40, 100, 500);
			//addAmbientElement( "ber3_wood_room_pkg", "bomb_far", 2, 15, 10, 200 );
			//addAmbientElement( "ber3_wood_room_pkg", "bomb_medium", 15, 30, 100, 500 );

	//***************
	//Ber3_Subway
	//*************** 
		
		declareAmbientPackage( "ber3_rodent_pkg" );		
			addAmbientElement( "ber3_rodent_pkg", "amb_rodents", 5, 35, 100, 500 );
	
		declareAmbientPackage( "ber3_large_tunnel_pkg" );		
			addAmbientElement( "ber3_large_tunnel_pkg", "amb_water_drips", 0.05, 0.8, 10, 100 );
	
		declareAmbientPackage( "ber3_small_tunnel_pkg" );
			//addAmbientElement( "ber3_small_tunnel_pkg", "amb_dog_bark", 3, 6, 2000, 3000);
			//addAmbientElement( "ber3_small_tunnel_pkg", "amb_wood_creak", 4, 12, 10, 100 );
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	
	
	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	//***************
	//Ber3_Outdoors
	//*************** 

		declareAmbientRoom( "ber3_outdoors_room" );
	
			//setAmbientRoomTone( "ber3_outdoors_room", "outdoor_wind" );
			setAmbientRoomReverb( "ber3_outdoors_room", "Ber1",  1, 1 );
			
	//***************
	//Ber3_Building_Interrior
	//*************** 

		declareAmbientRoom( "ber3_hallway_room" );	
			setAmbientRoomTone( "ber3_hallway_room", "train_station_wind" );
	
		declareAmbientRoom( "ber3_partial_room" );
			setAmbientRoomTone( "ber3_partial_room", "partial_room_wind" );
	
		declareAmbientRoom( "ber3_big_room" );			
			setAmbientRoomTone( "ber3_big_room", "train_station_wind" );
			
	//***************
	//Ber3_Subway
	//***************

		declareAmbientRoom( "ber3_small_tunnel" );	
			setAmbientRoomTone( "ber3_small_tunnel", "bgt_small_tunnel" );
	
		declareAmbientRoom( "ber3_large_tunnel" );			
			setAmbientRoomTone( "ber3_large_tunnel", "bgt_large_tunnel" );

	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************
		activateAmbientPackage( "ber3_outdoors_pkg", 0 );
		activateAmbientRoom( "ber3_outdoors_room", 0 );
		
	//*************************************************************************************************
	//                                      START SCRIPTS
	//*************************************************************************************************

		//Start_Intro_Music();
		level thread battle_cry();
		level thread battle_cry2();
}



	//************************************************************************************************
	//                                      OTHER AUDIO FUNCTIONS
	//************************************************************************************************

//Start_Intro_Music()
//{
//	musicplay("MX_Intro", 0);	
//}

battle_cry()
{
	level waittill("battle_cry");
	yell = getent("battle_cry", "targetname");
	playsoundatposition("See1_IGD_700A_RURS",yell.origin);

}
battle_cry2()
{
	level waittill("pwn_joyal");
	yell = getent("battle_cry", "targetname");
	playsoundatposition("See1_IGD_700A_RURS",yell.origin);

}