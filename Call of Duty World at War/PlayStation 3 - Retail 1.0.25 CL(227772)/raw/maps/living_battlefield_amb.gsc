#include maps\_ambientpackage;


main()
{
	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	declareAmbientPackage( "outdoors_pkg" );
	//addAmbientElement( "outdoors_pkg", "amb_dog_bark", 3, 6, 500, 2000);
	addAmbientElement( "outdoors_pkg", "amb_bugs_other", 8, 15, 25, 110 );
	addAmbientElement( "outdoors_pkg", "amb_bugs_cicada", 35, 45, 50, 120 );
	addAmbientElement( "outdoors_pkg", "amb_flies", 15, 30, 10, 110);
	addAmbientElement( "outdoors_pkg", "amb_odd_bug", 60, 90,100, 300 );
	addAmbientElement( "outdoors_pkg", "amb_raven", 10, 15, 10, 200 );
	addAmbientElement( "outdoors_pkg", "amb_seagull", 10, 20, 10, 150 );
	addAmbientElement( "outdoors_pkg", "amb_bird", 25, 30, 20, 200 );
	addAmbientElement( "outdoors_pkg", "amb_mosquito", 25, 35 );
	addAmbientElement( "outdoors_pkg", "amb_crickets", 0.05, 0.8, 10, 250 );
	


	declareAmbientPackage( "rodent_pkg" );
	addAmbientElement( "rodent_pkg", "amb_rodents", 0.2, 0.75, 0, 150, 345, 375 );


	declareAmbientPackage( "night_pkg" );
	addAmbientElement( "night_pkg", "amb_dog_bark", 3, 6, 1000, 2000);
	addAmbientElement( "night_pkg", "amb_crickets", 0.2, 0.8, 10, 100 );
	addAmbientElement( "night_pkg", "amb_frogs", 1, 12, 10, 100 );
	addAmbientElement( "night_pkg", "amb_odd_bug", 10, 20, 10, 100 );
	addAmbientElement( "night_pkg", "amb_owl", 5, 20, 200, 2000 );
	addAmbientElement( "night_pkg", "amb_bugs_other", 1, 8, 10, 100 );


	declareAmbientPackage( "interior_house_pkg" );
	addAmbientElement( "interior_house_pkg", "amb_dog_bark", 3, 6, 2000, 3000);
	addAmbientElement( "interior_house_pkg", "amb_water_drips", 0.05, 0.8, 10, 100 );
	addAmbientElement( "interior_house_pkg", "amb_wood_creak", 4, 12, 10, 100 );
	
	
	 declareAmbientPackage( "lb_bunker" );
	 	addAmbientElement( "lb_bunker", "amb_mosquito", 25, 35 );
	 	addAmbientElement( "lb_bunker", "amb_seagull", 10, 20, 500, 1050 );
	 	addAmbientElement( "lb_bunker", "amb_raven", 10, 15, 100, 900 );
	 	//addAmbientElement( "lb_bunker", "amb_water_drips", 0.15, 0.8, 10, 250 );
	 
	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	activateAmbientPackage( "outdoors_pkg", 0 );


	//the same pattern is followed for setting up ambientRooms
	declareAmbientRoom( "outdoors_room" );
	setAmbientRoomTone( "outdoors_room", "bgt_wind" );

	declareAmbientRoom( "lb_bunker" );
	setAmbientRoomTone( "lb_bunker", "bgt_wind_interior" );

	declareAmbientRoom( "rodent_room" );
	setAmbientRoomTone( "rodent_room", "bgt_wind" );

	declareAmbientRoom( "night_room" );
	setAmbientRoomTone( "night_room", "bgt_wind" );
	
	declareAmbientRoom( "interior_house_room" );
	setAmbientRoomTone( "interior_house_room", "bgt_wind_interior" );

	activateAmbientRoom( "outdoors_room", 0 );
	thread start_music_outside ();
	// thread play_cave_stinger ();
} 
start_music_outside ()
{
	musicstop(2);
	wait(2);
	musicplay("mx_sbowl");
}
play_cave_stinger ()
{
	trig = getent( "play_cave_trigger", "targetname" );
	trig waittill ("trigger");
	musicstop(2);
	wait(2);
	println("waited 2.1, hitting cave stinger");
	musicplay("MX_Cave_Stinger");
	wait (50);
	thread start_music_outside ();
}
