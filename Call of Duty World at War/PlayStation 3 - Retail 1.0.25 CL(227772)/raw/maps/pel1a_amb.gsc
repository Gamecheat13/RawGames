#include maps\_utility;
#include maps\_ambientpackage;
main()
{
	
	//Set up Ambient Rooms and Packages

//************************************************************************************************
//				Ambient Packages
//************************************************************************************************


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
//				ROOMS
//************************************************************************************************

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
//				ACTIVATE DEFAULT AMBIENT SETTINGS
//************************************************************************************************
	activateAmbientPackage( "pel1_outdoors", 0 );
	activateAmbientRoom( "pel1_outdoors", 0 );


//*************************************************************************************************
//				   START SCRIPTS
//*************************************************************************************************


	
//	level thread start_intro_music();
	level thread play_plane_audio_plane1();
//	level thread play_fake_japanese_battlechatter();
}

//************************************************************************************************
//			 	OTHER AUDIO FUNCTIONS
//************************************************************************************************

start_intro_music()
{
	wait (0.3);
	musicplay("MX_EndTheme");
	
}
play_plane_audio_plane1()
{
	level waittill("spawnvehiclegroup6");
	wait(2);
	
	planes = getentarray("auto4825" ,"targetname");

	for (i = 0; i < planes.size; i++)
	{	
		planes[i] thread play_plane_sound();	

	}	
	

	
}
play_plane_sound()
{
	// CODER_MOD - JamesS, script_noteworthy not defined sometimes
	if( !IsDefined(self.script_noteworthy) )
	{
		return;
	}
	else if (self.script_noteworthy == "corsair")
	{
		self playsound("pel1a_corsair_by");
	}
	else if (self.script_noteworthy == "zero")
	{
		self playsound("pel1a_zero_by");
	}
	
	/*
	plane1 = getent("corsair_1" ,"targetname");
	plane1 playsound("pel1a_corsair_by");
	
	plane2 = getent("zero_1" ,"targetname");
	plane2 playsound("pel1a_zero_by");
	*/
}
play_fake_japanese_battlechatter()
{
	
	wait (4);
	while (1)
	{
		level endon ("player_win");
				
		// get all all the allies
		ai = getaiarray("axis");
		
		// grab a random guy from the array of allies
		ent = ai[randomint(ai.size)];
		
		// if he dead or not around anymore, start back at the top of this loop and try again
		// in half a second
		if (!isalive (ent) || !isdefined(ent) || (isdefined(ent.isplaying_fake_bc) && ent.isplaying_fake_bc == true))
		{
			wait 0.5;
			continue;
		}
		
		num_battle_chatters = 24;		// number of possible battle chatters
		randomizer = randomintrange(1, num_battle_chatters);
		
		ent playsound("fake_jbc_" + randomizer, "sound_done");		
		ent.isplaying_fake_bc = true;
		
		ent waittill("sound_done");

		if (isalive(ent) && isdefined(ent))
		{
			ent.isplaying_fake_bc = false;
		}
		
		wait(1);		// hard wait of 1

		wait (randomintrange (1,3));	// extra random wait
	}
}



