//
// file: template_amb.csc
// description: clientside ambient script for template: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;
#include clientscripts\_busing;

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
			//addAmbientElement( "ber3_rodent_pkg", "amb_rodents", 5, 35, 100, 500 );
	
		declareAmbientPackage( "ber3_large_tunnel_pkg" );		
			//addAmbientElement( "ber3_large_tunnel_pkg", "amb_water_drips", 0.05, 0.8, 10, 100 );
	
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
			setAmbientRoomReverb( "ber3_outdoors_room", "auditorium",  1, 0.3 );
			
	//***************
	//Ber3_Building_Interrior
	//*************** 

		declareAmbientRoom( "ber3_hallway_room" );	
			//setAmbientRoomTone( "ber3_hallway_room", "train_station_wind" );
	
		declareAmbientRoom( "ber3_partial_room" );	
			//setAmbientRoomTone( "ber3_partial_room", "partial_room_wind" );
			setAmbientRoomReverb( "ber3_partial_room", "STONEROOM",  1, 0.3 );
	
		declareAmbientRoom( "ber3_big_room" );			
			//setAmbientRoomTone( "ber3_big_room", "train_station_wind" );
			
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

		activateAmbientPackage( 0, "ber3_outdoors_pkg", 0 );
		activateAmbientRoom( 0, "ber3_outdoors_room", 0 );

	//************************************************************************************************
	//                                      MUSIC PACKAGES
	//************************************************************************************************

	    declareMusicState("INTRO"); //one shot dont transition until done
	    musicAlias("mx_intro", 0);
	    musicWaitTillDone();

	    declareMusicState("WAKE_UP"); //stinger + fadeout
		musicAliasLoop("mx_underscore", 0, 3);

		declareMusicState("FIRST_FIGHT");
		musicAliasLoop("mx_first_fight", 0, 6);
		musicStinger ("mx_first_fight_stg", 2);

	    declareMusicState("POST_LIBRARY"); //stinger + fadeout
		musicAliasLoop("mx_underscore", 0, 6);
	  
	    declareMusicState("LAST_FIGHT"); //stinger + fadeout
	    musicAlias("mx_last_fight", 0);
		musicAliasLoop("mx_underscore_stag", 0, 6);
//		musicStinger("mx_last_fight_stg", 0);

	    declareMusicState("STAG_DOORSTEP"); //stinger + fadeout
	    musicAliasloop("mx_first_fight", 3, 4);

		declareMusicState("PILLAR");
		musicAlias("mx_chernov_died");
		musicAliasLoop("mx_underscore_stag", 0, 6);


		

//************************************************************************************************
//                                      CUSTOM BUSES
//************************************************************************************************


		declareBusState("INTRO");
		busFadeTime(0.25);
		busVolumesExcept("music", "voice", "ui","full_vol", 0.50);

		declareBusState("RESET");
		busFadeTime(2);
		busVolumeAll(1);
		
		declareBusState("PILLAR");
		busFadeTime(5);
		busVolumesExcept("music", "voice", "full_vol", "ui", 0.25);


}

