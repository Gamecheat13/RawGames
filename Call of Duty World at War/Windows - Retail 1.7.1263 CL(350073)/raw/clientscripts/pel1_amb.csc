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
//pel1_inboat
//***************
	package = "pel1_inboat";
	declareAmbientPackage( package );

		addAmbientElement( package, "ship_creak", 1, 3, 50, 450 );
//***************
//pel1_atsea
//***************
	package = "pel1_atsea";
	declareAmbientPackage( package );  

		//addAmbientElement( package, "amb_seagull", 8, 15, 200, 1500 );


//***************
//pel1_outdoors
//***************
	package = "pel1_outdoors";
	declareAmbientPackage( "pel1_outdoors" );
	
		
		
		addAmbientElement( package, "amb_bugs_cicada", 35, 45, 50, 120 );	
		addAmbientElement( package, "amb_crickets", 1, 2, 5, 500 );
		addAmbientElement( package, "amb_mosquito", 15, 30 );
		addAmbientElement( package, "amb_flies", 15, 30, 10, 110);
		addAmbientElement( package, "amb_bugs_other", 20, 25, 25, 510 );		
		addAmbientElement( package, "amb_odd_bug", 5, 20,100, 300 );
		addAmbientElement( package, "bomb_far", 2, 8,1000, 4500);		
		addAmbientElement( package, "amb_distant_arty", 4, 13,1000, 4000);
		addAmbientElement( package, "amb_distant_arty", 1, 6,3000, 6000);


//***************
//pel1_bunker
//***************
	package = "pel1_bunker";
	declareAmbientPackage( package );
	
		//addAmbientElement( package, "amb_seagull", 10, 20, 10, 150 );
		//addAmbientElement( package, "amb_water_drips", 0.4, 6.0, 10, 25);
		addAmbientElement( package, "amb_mosquito", 15, 30 );
		addAmbientElement( package, "amb_flies", 10, 20, 10, 110);
		addAmbientElement( package, "amb_wood_creak", 5, 20,100, 300 );
		addAmbientElement( package, "amb_sand_fall", 5, 20,100, 300 );
		addAmbientElement( package, "bomb_far_falloff_occluded", 2, 10,1000, 4500);

//***************
//pel1_wd_bunker (Wooden Bunker)
//***************
	package = "pel1_wd_bunker";
	declareAmbientPackage( package );
	
		//addAmbientElement( package, "amb_seagull", 10, 20, 10, 150 );
		addAmbientElement( package, "amb_water_drips", 0.4, 6.0, 10, 25);
		addAmbientElement( package, "amb_mosquito", 15, 30 );
		addAmbientElement( package, "amb_flies", 10, 20, 10, 110);

//***************
//pel1_underground (caveish area)
//***************
	package = "pel1_underground";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_mosquito", 6, 30 );
		addAmbientElement( package, "amb_flies", 4, 20, 1, 100);
		addAmbientElement( package, "amb_wood_creak", 5, 10,1, 100 );
		addAmbientElement( package, "amb_sand_fall", 2, 6, 1, 100 );
		addAmbientElement( package, "amb_wood_dust", 2, 6, 1, 100 );
		addAmbientElement( package, "bomb_far_falloff_occluded", 2, 10,1000, 4500);
		
//***************
//pel1_metal_cone (caveish area)
//***************
	package = "pel1_metal_cone";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_water_drips", 0.4, 6.0, 10, 25);

//***************
//pel1_concrete_bldg
//***************
	package = "pel1_concrete_bldg";
	declareAmbientPackage( package );
	
		//addAmbientElement( package, "amb_seagull", 10, 20, 10, 150 );		
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms


//***************
//pel1_inboat
//***************
	room = "pel1_inboat";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_LST_Interior" );
		setAmbientRoomReverb( room, "sewerpipe", 1.0, 0.85 );
		
//***************
//pel1_atsea
//***************
	room = "pel1_atsea";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_wind_atsea" );
		setAmbientRoomReverb( room, "plain", 1, 1);
	
//***************
//pel1_Outdoors
//***************
	room = "pel1_outdoors";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_wind_outdoor" );
		setAmbientRoomReverb( room, "forest",  1, 1);

		
//***************
//pel1_bunker (Bunker)
//***************	
	room = "pel1_bunker";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_wind_interior" );
		setAmbientRoomReverb( room, "cave", 1, 1 );

//***************
//pel1_wd_bunker (Wooden Bunker)
//***************	
	room = "pel1_wd_bunker";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_wind_interior" );
		setAmbientRoomReverb( room, "cave", 1, 1 );
		
//***************
//pel1_underground (caveish area)
//***************	
	room = "pel1_underground";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_wind_interior" );
		setAmbientRoomReverb( room, "cave", 1, 1 );
		
	
//***************
//pel1_concrete_bldg
//***************	
	room = "pel1_concrete_bldg";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_wind_interior" );
		setAmbientRoomReverb( room, "livingroom", 1, 1);

//***************
//pel1_metal_cone (caveish area)
//***************
	//room = "pel1_metal_cone";
	declareAmbientRoom( "pel1_metal_cone" );
		setAmbientRoomTone( "pel1_metal_cone", "bgt_wind_interior" );
		setAmbientRoomReverb( room, "auditorium", 0.9, 0.0 );
	
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "pel1_outdoors", 0 );
	activateAmbientRoom( 0, "pel1_outdoors", 0 );




//************************************************************************************************
//                                      MUSIC PACKAGES
//******************************************************************************************


	    declareMusicState("INTRO"); //one shot dont transition until done
		musicAlias("mx_intro", 3);	
		musicwaittilldone();

	    declareMusicState("BEACH"); //one shot dont transition until done
		musicAlias("MX_Beach", 3);	
		musicStinger("mx_rockets", 36);

	    declareMusicState("PLAYER_ROCKETS"); //one shot dont transition until done
		musicalias("mx_post_rockets", 1);
//musicaliasloop("mx_post_rockets_underscore", 1, 1);
		musicStinger("mx_mg_stinger", 8, true);

		declareMusicState("MG_ENCOUNTER");		
		musicaliasloop("mx_calm_backup", 12, 2);

		declareMusicState("FIRST_FIGHT");
		musicAliasloop("mx_first_fight", 1, 3);
		musicStinger ("mx_ambush_stinger", 3, true);

		declareMusicState("BANZAI");
		musicAliasloop("mx_first_fight", 1, 2);


//This event is if the player takes the bunker on directly
		declareMusicState("CRAZY_PLAYER");
		musicAliasloop("mx_first_fight", 2, 4);

//This event is if the player takes the easy side flanking bunker route
		declareMusicState("STEALTHY_PLAYER");
		musicAliasloop("mx_first_fight", 2, 4);

//This event is if the player rushes through the middle and then enters the bunker from any entrance point
		declareMusicState("BLITZ_KRIEG");
		musicAliasloop("mx_first_fight", 2, 4);

		declareMusicState("LAST_BUNKER_UPSTAIRS");
		musicAlias("mx_last_bunker", 4);

		declareMusicState("END_LEVEL");
		musicAlias("mx_pel1_resolution", 3);

		declareMusicState("SULLIVAN_DIED");
		musicAlias("mx_sullivan_died", 1);


		declareBusState("EASTER");
		busFadeTime(1);
		busVolumesExcept("voice","character","pis_1st",	0.0);
		

		declareBusState("return_default");
		busFadeTime(2);
		busVolumeAll(1);


		declareBusState("return_default_slow");
		busFadeTime(12);
		busVolumeAll(1);







}

