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
//pel1b_outdoors
//***************
	//package = "pel1b_outdoors";
	declareAmbientPackage( "pel1b_outdoors" );
	
		addAmbientElement( "pel1b_outdoors", "amb_bugs_other", 8, 15, 25, 110 );
		addAmbientElement( "pel1b_outdoors", "amb_bugs_cicada", 35, 45, 50, 120 );	
		addAmbientElement( "pel1b_outdoors", "amb_seagull", 15, 30, 500, 1500 );
		addAmbientElement( "pel1b_outdoors", "amb_mosquito", 15, 30 );
		addAmbientElement( "pel1b_outdoors", "amb_flies", 10, 20, 10, 110);
		addAmbientElement( "pel1b_outdoors", "amb_bugs_other", 8, 15, 25, 510 );
		addAmbientElement( "pel1b_outdoors", "amb_bugs_cicada", 15, 35, 50, 1220 );
		addAmbientElement( "pel1b_outdoors", "amb_odd_bug", 5, 20,100, 300 );
		


		
//***************
//pel1b_cave
//***************
	package = "pel1b_cave";
	declareAmbientPackage( "pel1b_cave" );
	
		addAmbientElement( "pel1b_cave", "amb_sand_fall", 2, 15, 100, 500 );
		addAmbientElement( "pel1b_cave", "amb_wood_dust", 2, 10, 10, 150 );
		addAmbientElement( "pel1b_cave", "amb_drip", 2, 15, 25, 110 );
		addAmbientElement( "pel1b_cave", "amb_Japanese_cave_1", 10, 20, 500, 1000 );
                addAmbientElement( "pel1b_cave", "amb_bats", 2, 15, 25, 110 );	
                
//***************
//pel1b_cave_gunroom
//***************
	package = "pel1b_cave_gunroom";
	declareAmbientPackage( "pel1b_cave_gunroom" );
	
		addAmbientElement( "pel1b_cave_gunroom", "amb_sand_fall", 2, 15, 100, 500 );
		addAmbientElement( "pel1b_cave_gunroom", "amb_wood_dust", 2, 10, 10, 150 );
		addAmbientElement( "pel1b_cave_gunroom", "amb_drip", 2, 15, 25, 110 );
		addAmbientElement( "pel1b_cave_gunroom", "amb_Japanese_cave_1", 10, 20, 500, 1000 );
                addAmbientElement( "pel1b_cave_gunroom", "amb_bats", 2, 15, 25, 110 );	
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms



//***************
//pel1b_outdoors
//***************
	//room = "pel1b_outdoors";
	declareAmbientRoom( "pel1b_outdoors" );
		setAmbientRoomTone( "pel1b_outdoors", "bgt_wind" );
		setAmbientRoomReverb( "pel1b_outdoors", "FOREST",  1, 1 );



//***************
//pel1b_cave (caveish area)
//***************
	//room = "pel1b_cave";
	declareAmbientRoom( "pel1b_cave" );
		setAmbientRoomTone( "pel1b_cave", "bgt_wind_interior" );
		setAmbientRoomReverb( "pel1b_cave", "CAVE",  1, 1 );
		
		
//***************
//pel1b_cave_gunroom
//***************
	//room = "pel1b_cave_gunroom";
	declareAmbientRoom( "pel1b_cave_gunroom" );
		setAmbientRoomTone( "pel1b_cave_gunroom", "bgt_wind_gunroom" );
		setAmbientRoomReverb( "pel1b_cave_gunroom", "CONCERTHALL",  1, 1 );
		
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

	activateAmbientPackage( 0, "pel1b_outdoors", 0 );
	activateAmbientRoom( 0, "pel1b_outdoors", 0 );





	//************************************************************************************************
	//                                    MUSIC PACKAGES
	//************************************************************************************************



	    declareMusicState("INTRO"); 
	    musicAlias("mx_intro",0);
		musicStinger("mx_first_fight_stg", 38 );
	
	
	    declareMusicState("FIRST_FIGHT"); 
	    musicAliasloop("mx_first_fight", 0, 4);

		declareMusicState("DROP_OFF");
		musicAliasloop ("mx_underscore_tense",0,4);


		declareMusicState("CAVE");
		musicAliasloop ("mx_underscore_cave",0,2);

		declareMusicState("LEVEL_END");
		musicAlias("mx_level_end", 1);




}

