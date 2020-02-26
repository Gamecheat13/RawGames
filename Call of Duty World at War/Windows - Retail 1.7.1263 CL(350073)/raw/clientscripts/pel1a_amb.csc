//
// file: template_amb.csc
// description: clientside ambient script for template: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;

main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	

//***************
//pel1_atsea
//***************
	package = "pel1_atsea";
	declareAmbientPackage( package );

		//addAmbientElement( package, "amb_seagull", 8, 15, 200, 1500 );


//***************
//pel1_outdoors
//***************
	//package = "pel1_outdoors";
	declareAmbientPackage( "pel1_outdoors" );
	
		addAmbientElement( "pel1_outdoors", "amb_bugs_other", 8, 15, 25, 110 );
		addAmbientElement( "pel1_outdoors", "amb_bugs_cicada", 35, 45, 50, 120 );	
		addAmbientElement( "pel1_outdoors", "amb_seagull", 15, 30, 500, 1500 );
		addAmbientElement( "pel1_outdoors", "amb_mosquito", 15, 30 );
		addAmbientElement( "pel1_outdoors", "amb_flies", 10, 20, 10, 110);
		addAmbientElement( "pel1_outdoors", "amb_bugs_other", 8, 15, 25, 510 );
		addAmbientElement( "pel1_outdoors", "amb_bugs_cicada", 15, 35, 50, 1220 );
		addAmbientElement( "pel1_outdoors", "amb_odd_bug", 5, 20,100, 300 );
		

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
	
		addAmbientElement( package, "amb_seagull", 10, 20, 10, 150 );
		addAmbientElement( package, "amb_water_drips", 0.4, 6.0, 10, 25);

//***************
//pel1_underground (caveish area)
//***************
	package = "pel1_underground";
	declareAmbientPackage( package );
	
		addAmbientElement( package, "amb_mosquito", 20, 40 );
		addAmbientElement( package, "amb_flies", 10, 20, 50, 410);
		addAmbientElement( package, "amb_wood_creak", 5, 10,100, 500 );
		addAmbientElement( package, "amb_sand_fall", 2, 15, 100, 500 );
		addAmbientElement( package, "amb_wood_dust", 2, 10, 10, 150 );
		
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
	
		addAmbientElement( package, "amb_seagull", 10, 20, 10, 150 );	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms


//***************
//pel1_atsea
//***************
	room = "pel1_atsea";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_wind_atsea" );

//***************
//pel1_Outdoors
//***************
	room = "pel1_outdoors";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_wind_land" );

		
//***************
//pel1_bunker (Bunker)
//***************	
	room = "pel1_bunker";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_wind_interior" );
//***************
//pel1_wd_bunker (Wooden Bunker)
//***************	
	room = "pel1_wd_bunker";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_wind_interior" );
		
//***************
//pel1_underground (caveish area)
//***************	
	room = "pel1_underground";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_wind_interior" );
		
	
//***************
//pel1_concrete_bldg
//***************	
	room = "pel1_concrete_bldg";
	declareAmbientRoom( room );
		setAmbientRoomTone( room, "bgt_wind_interior" );

//***************
//pel1_metal_cone (caveish area)
//***************
	//room = "pel1_metal_cone";
	declareAmbientRoom( "pel1_metal_cone" );
		setAmbientRoomTone( "pel1_metal_cone", "bgt_wind_interior" );
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "pel1_outdoors", 0 );
	activateAmbientRoom( 0, "pel1_outdoors", 0 );



	//************************************************************************************************
	//                                    MUSIC PACKAGES
	//************************************************************************************************

	  	declareMusicState("INTRO"); //one shot dont transition until done
			musicAlias("mx_intro_stinger",0);
	  		musicAliasloop("mx_underscore",0, 8);	

	  	declareMusicState("LEVEL_END"); //one shot dont transition until done
			musicAlias("mx_end",0);


}

