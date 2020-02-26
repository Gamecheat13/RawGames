#include maps\_utility;
#include maps\_ambientpackage;
main()
{
	
	//Set up Ambient Rooms and Packages

//************************************************************************************************
//				Ambient Packages
//************************************************************************************************

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
	declareAmbientPackage( package );
	
		addAmbientElement( "pel1b_cave", "amb_sand_fall", 2, 15, 100, 500 );
		addAmbientElement( "pel1b_cave", "amb_wood_dust", 2, 10, 10, 150 );
		addAmbientElement( "pel1b_cave", "amb_drip", 2, 15, 25, 110 );
		addAmbientElement( "pel1b_cave", "amb_Japanese_cave_1", 10, 20, 500, 1000 );
                addAmbientElement( "pel1b_cave", "amb_bats", 2, 15, 25, 110 );

//***************

	
	
	
	
//************************************************************************************************
//				ROOMS
//************************************************************************************************



//***************
//pel1b_outdoors
//***************
	//room = "pel1b_outdoors";
	declareAmbientRoom( "pel1b_outdoors" );
		setAmbientRoomTone( "pel1b_outdoors", "bgt_wind" );



//***************
//pel1b_cave (caveish area)
//***************
	//room = "pel1b_cave";
	declareAmbientRoom( "pel1b_cave" );
		setAmbientRoomTone( "pel1b_cave", "bgt_wind_interior" );
	
	
//************************************************************************************************
//				ACTIVATE DEFAULT AMBIENT SETTINGS
//************************************************************************************************
	activateAmbientPackage( "pel1b_outdoors", 0 );
	activateAmbientRoom( "pel1b_outdoors", 0 );


//*************************************************************************************************
//				   START SCRIPTS
//*************************************************************************************************



//************************************************************************************************
//			 	OTHER AUDIO FUNCTIONS
//************************************************************************************************

}