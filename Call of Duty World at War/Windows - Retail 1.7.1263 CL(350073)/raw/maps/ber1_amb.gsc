// Ambients Level File

#include maps\_utility;
#include maps\_ambientpackage;

main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>
	
	//***************
	//Ber1_Outdoors
	//*************** 

		declareAmbientPackage( "ber1_outdoors_pkg" );
			
			//addAmbientElement( "ber1_outdoors_pkg", "amb_stone_small", 10, 20, 100, 500);
			//addAmbientElement( "ber1_outdoors_pkg", "amb_stone_med", 10, 20, 100,500);
			//addAmbientElement( "ber1_outdoors_pkg", "bomb_far", 2, 15, 10, 200 );

	//***************
	//Ber1_Building_Interrior
	//*************** 

		declareAmbientPackage( "ber1_stone_room_pkg" );
		
			addAmbientElement( "ber1_stone_room_pkg", "amb_stone_small", 10, 20, 100, 200);
			addAmbientElement( "ber1_stone_room_pkg", "bomb_far", 2, 15, 10, 200 );
			addAmbientElement( "ber1_stone_room_pkg", "bomb_medium", 15, 30, 100, 500 );
	
		declareAmbientPackage( "ber1_wood_room_pkg" );
	
			addAmbientElement( "ber1_wood_room_pkg", "amb_wood_small", 10, 20, 100, 200);
			addAmbientElement( "ber1_wood_room_pkg", "amb_wood_boards", 20, 40, 100, 500);
			addAmbientElement( "ber1_wood_room_pkg", "amb_wood_creak", 20, 40, 100, 500);
			addAmbientElement( "ber1_wood_room_pkg", "bomb_far", 2, 15, 10, 200 );
			addAmbientElement( "ber1_wood_room_pkg", "bomb_medium", 15, 30, 100, 500 );

	//***************
	//Ber1_Asylum
	//*************** 
		
		declareAmbientPackage( "ber1_asylum_pkg" );
		
			addAmbientElement( "ber1_asylum_pkg", "amb_rodents", 5, 35, 100, 500 );
				
	//***************
	//Ber1_Train_Station
	//*************** 
	
		declareAmbientPackage( "ber1_train_station_pkg" );
		
			addAmbientElement( "ber1_train_station_pkg", "amb_water_drips", 0.05, 0.8, 10, 100 );
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	
	
	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	//***************
	//Ber1_Outdoors
	//*************** 

		declareAmbientRoom( "ber1_outdoors_room" );
	
			//setAmbientRoomTone( "ber1_outdoors_room", "outdoor_wind" );
			setAmbientRoomReverb( "ber1_outdoors_room", "Ber1",  1, 1 );
			
	//***************
	//Ber1_Building_Interrior
	//*************** 

		declareAmbientRoom( "ber1_closed_room" );
	
			setAmbientRoomTone( "ber1_closed_room", "closed_room_wind" );
			setAmbientRoomReverb( "ber1_closed_room", "cod_room",  1, 0.4 );
	
		declareAmbientRoom( "ber1_partial_room" );
	
			setAmbientRoomTone( "ber1_partial_room", "partial_room_wind" );
			setAmbientRoomReverb( "ber1_partial_room", "cod_room",  1, 0.4 );
	
			
	//***************
	//Ber1_Asylum
	//***************

		declareAmbientRoom( "ber1_asylum" );
	
			setAmbientRoomTone( "ber1_asylum", "asylum_wind" );
			setAmbientRoomReverb( "ber1_asylum", "cod_room",  1, 0.4 );
			
	//***************
	//Ber1_Train_Station
	//***************

		declareAmbientRoom( "ber1_train_station" );
	
			setAmbientRoomTone( "ber1_train_station", "train_station_wind" );
	

	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************
		activateAmbientPackage( "ber1_outdoors_pkg", 0 );
		activateAmbientRoom( "ber1_outdoors_room", 0 );
		
	//*************************************************************************************************
	//                                      START SCRIPTS
	//*************************************************************************************************

		//Start_Intro_Music();
		//level thread play_bell_toll_sound();
		//level thread play_stuka_flying();
		//level thread play_il2_flying();
		//level thread train_ride();
		level thread play_music_box();
		level thread play_children_chant();
		//level thread play_insane_scream();
		level thread playground();
		level thread play_arty_sound();
		level thread wall_fire();
}



	//************************************************************************************************
	//                                      OTHER AUDIO FUNCTIONS
	//************************************************************************************************
//Start_Intro_Music()
//{
//	musicplay("MX_Intro", 0);	
//}
wall_fire()
{
	//wait 10;
	level waittill( "first_player_ready" );
	wait 5;
	wall_fire = Spawn( "script_origin", (3400, 4400, -72) );
	wall_fire playloopsound("wall_fire", 1);
}
play_bell_toll_sound()
{
	level endon( "ber1_clock_shot" );
	level waittill("ber1_bell_toll");
	
	toll1 = getent("clock", "targetname");
	toll1 playsound ("bell_toll1", "sound_done");
	toll1 waittill("sound_done");

	toll2 = getent("clock", "targetname");
	toll2 playsound ("bell_toll2", "sound_done");
	toll2 waittill("sound_done");
	
	toll3 = getent("clock", "targetname");
	toll3 playsound ("bell_toll3", "sound_done");
	toll3 waittill("sound_done");
	
	toll4 = getent("clock", "targetname");
	toll4 playsound ("bell_toll4", "sound_done");
	toll4 waittill("sound_done");
	
	toll5 = getent("clock", "targetname");
	toll5 playsound ("bell_toll5", "sound_done");
	toll5 waittill("sound_done");
	
	toll_end = getent("clock", "targetname");
	toll_end playsound ("bell_toll_end", "sound_done");
	toll_end waittill("sound_done");
}
play_music_box()
{
	level waittill("music_box_on");
	music_box = getent("music_box", "targetname");
	music_box playloopsound("music_box");
	level waittill("music_box_off");
	music_box stoploopsound(.5);
	music_box playsound("music_box_close");
	wait 1;
	music_box playsound("insane_laugh");
}
play_children_chant()
{
	level waittill("music_box_on");
	chant = getent("chant", "targetname");
	chant playloopsound("child_chant");
	level waittill("boy_scream_off");
	chant stoploopsound(.5);
	wait 1;
	chant playsound("child_scream");
}
playground()
{
	level waittill("playground_on");
	playground = getent("playground", "targetname");
	playground playloopsound("playground");
	level waittill("playground_off");
	playground stoploopsound(.5);
}
play_insane_scream()
{
	level waittill("insane_scream");
	insane_scream = getent("insane_scream", "targetname");
	insane_scream playsound("insane_scream");
}
play_arty_sound()
{
	level waittill("ber2_earthquake");
	ber2_earthquake = getent("music_box", "targetname");
	ber2_earthquake playsound ("art_int", "sound_done");
}
//play_stuka_flying()
//{
//	level waittill("ber1_stuka_audio");
//	stuka_fly = getent("stuka", "targetname");
//	stuka_fly playsound("stuka_flyby");
//
//}
//play_il2_flying()
//{
//	level waittill("ber1_stuka_audio");
//	il2_fly = getent("il2", "targetname");
//	il2_fly playsound("il2_flyby");
//
//}
/*
train_ride()
{
	//wait(3);
	//trigger = getent("train_ride", "targetname");
	//rleft = getent("train_rear_left", "targetname");
	//rright = getent("train_rear_right", "targetname");
	//fleft = getent("train_front_left", "targetname");
	//fright = getent("train_front_right", "targetname");
	
	//trigger waittill("trigger");
	playsoundatposition ("train_rear_left", (-10600,-2232, -856));
	playsoundatposition ("train_rear_right", (-10568, -10792, -856));
	playsoundatposition ("train_front_left", (2992, -32, -792));
	playsoundatposition ("train_front_right", (3192, -10712, -792));
	playsoundatposition ("train_front_center", (2096, -6736, -792));
	
}
*\
//radio_location = getent("audio_pa_origin","targetname"); 
      //playsoundatposition ("village_music", radio_location.origin);