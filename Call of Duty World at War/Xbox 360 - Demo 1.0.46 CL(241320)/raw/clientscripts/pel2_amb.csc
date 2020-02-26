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
//pel2_outdoors
//***************
	package = "pel2_outdoors";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_flies", 10, 20, 10, 110);
		
//***************
//Pel2_Mangrove
//***************
	package = "pel2_mangrove";
	declareAmbientPackage( package );	
		addAmbientElement( package, "amb_bugs_other", 8, 15, 25, 110 );

//***************
//Pel2_bunker
//***************
	package = "pel2_bunker";
	declareAmbientPackage( package );	
		
		addAmbientElement( package, "amb_water_drips", 0.4, 6.0, 10, 25);
	
//***************
//pel2_concrete_bldg
//***************
	package = "pel2_concrete_bldg";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_seagull", 10, 20, 10, 150 );		
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
// 160 -296 13 Mak1_IGD_050A_ROEB.wav

//***************
//Pel2_Outdoors
//***************
	room = "pel2_outdoors";
	declareAmbientRoom( room );
		//setAmbientRoomTone( room, "bgt_wind" );
		setAmbientRoomReverb( "pel2_outdoors", "ber1", 1, 1 );

//***************
//Pel2_Mangrove
//***************
	room = "pel2_mangrove";
	declareAmbientRoom( room );
		//setAmbientRoomTone( room, "bgt_wind_mangrove" );
		setAmbientRoomReverb( "pel2_mangrove", "ber1", 1, 1 );
//***************
//Pel2_bunker
//***************	
	room = "pel2_bunker";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_bunker" );
		setAmbientRoomReverb( "pel2_bunker", "stone_corridor", 1, 1 );
//***************
//pel2_concrete_bldg
//***************	
	room = "pel2_concrete_bldg";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_bunker" );
		setAmbientRoomReverb( "pel2_concrete_bldg", "alley", 1, 1 );
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "pel2_outdoors", 0 );
	activateAmbientRoom( 0, "pel2_outdoors", 0 );


//**********************************************************************

//				MUSIC PACKAGES

//**********************************************************************


	

	//  declareMusicState("INTRO"); //one shot dont transition until done
    //  musicAlias("makin_torture", 0);
   //   musicWaitTillDone();

	    declareMusicState("SWAMP"); //stinger + fadeout
	    musicAliasLoop("mx_underscore", 0, 1);
	    musicStinger("mx_ambushed_stgr");
		musicWaitTillDone();    

	    declareMusicState("AMBUSHED"); //stinger + fadeout
	    musicAliasLoop("mx_tension_swamp", 0, 6);

	    declareMusicState("ENDSWAMP"); //crossfade
	    musicAliasLoop("mx_first_fight", 0, 4);
	    musicWaitTillDone();

		declareMusicState("FLAMER_DIED");
		musicAliasloop("mx_bunker_fight", 4, 4);

		declareMusicState("PLAYER_GETS_FLAMETHROWER");
		musicAlias("mx_oh_yeah", 2);
		musicwaittilldone();
	    
	    declareMusicState("AFTERBUNKER"); 
	    musicAliasloop("mx_calm", 0, 1);
        musicStinger("mx_banzai_stg");
		musicwaittillstingerdone();

		declareMusicState("BOMBER"); 
	    musicAliasloop("mx_admin",0, 1);
	
		declareMusicState("POST_ADMIN"); 
		musicAlias("mx_pre_airfield_stgr", 2);

		declareMusicState("AIRFIELD");
		musicAliasloop("mx_jungle_push_action",0,6);
//		musicStinger("mx_pre_airfield_stgr", 2);

		declareMusicState("POST_AIRFIELD");
		musicAlias("mx_post_airfield_stg", 1);
		musicStinger("mx_counterattack_stg", 20);

	 	declareMusicState("COUNTER_ATTACK");
		musicAliasloop("mx_counterattack_loop", 0, 4);
		musicStinger("mx_level_end", 0);

		declareMusicState("LEVEL_END");







// CUSTOM BUSSING

	declarebusstate("ADMIN");
	busFadeTime(2.0);
	busVolumesExcept("full_vol","voice", "ui","pis_1st","smg_1st","rfl_1st", 0.6);

	declarebusstate("COUNTER_ATTACK");
	busFadeTime(2.0);
	busVolumesExcept("voice", "ui","music", "explosion", "full_vol", "pis_1st","smg_1st","rfl_1st", 0.65);
	busvolume("hvy_wpn", 0.7);
	busvolume("decay", 0.8);



	declarebusstate("LEVEL_END");
	busFadeTime(4.0);
	busVolumesExcept("full_vol","voice", "music",0.65);
	

	
	declareBusState("RESET");
	busFadeTime(2);
	busVolumeAll(1);




}

