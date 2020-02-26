//
// file: ber3b_amb.gsc
// description: level ambience script for berlin3b
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
	//ber3b_Indoor_Packages
	//*************** 

		declareAmbientPackage( "ber3b_indoors_room_pkg" );
			
			addAmbientElement( "ber3b_indoors_room_pkg", "ber3b_fake_fire1", 1, 3, 10,350);
			addAmbientElement( "ber3b_indoors_room_pkg", "ber3b_fake_fire2", 1, 3, 10,350);
			addAmbientElement( "ber3b_indoors_room_pkg", "ber3b_fake_fire3", 1, 3, 10,350);
			addAmbientElement( "ber3b_indoors_room_pkg", "bomb_far", 5, 10, 10,350);
		
		declareAmbientPackage( "ber3b_pipe_hall_pkg" );
					
			addAmbientElement( "ber3b_pipe_hall_pkg", "ber3b_fake_fire1", 1, 3, 10,350);
			addAmbientElement( "ber3b_pipe_hall_pkg", "ber3b_fake_fire2", 1, 3, 10,350);
			addAmbientElement( "ber3b_pipe_hall_pkg", "ber3b_fake_fire3", 1, 3, 10,350);
			addAmbientElement( "ber3b_pipe_hall_pkg", "pipe_hits", 3, 10, 10,350);
			
	//***************
	//ber3b_Partial_Room_Packages
	//*************** 

		declareAmbientPackage( "ber3b_first_room_pkg" );
		
			addAmbientElement( "ber3b_first_room_pkg", "amb_fire_ember", 1, 3, 10, 100);
			addAmbientElement( "ber3b_first_room_pkg", "ber3b_fake_fire1", 1, 3, 10,350);
			addAmbientElement( "ber3b_first_room_pkg", "ber3b_fake_fire2", 1, 3, 10,350);
			addAmbientElement( "ber3b_first_room_pkg", "ber3b_fake_fire3", 1, 3, 10,350);
	
		declareAmbientPackage( "ber3b_second_room_pkg" );
	
			addAmbientElement( "ber3b_second_room_pkg", "amb_fire_ember", 2, 15, 10, 200);
			addAmbientElement( "ber3b_second_room_pkg", "ber3b_fake_fire1", 1, 3, 10,350);
			addAmbientElement( "ber3b_second_room_pkg", "ber3b_fake_fire2", 1, 3, 10,350);
			addAmbientElement( "ber3b_second_room_pkg", "ber3b_fake_fire3", 1, 3, 10,350);
			addAmbientElement( "ber3b_second_room_pkg", "bomb_far", 5, 10, 10,350);
			
		declareAmbientPackage( "ber3b_third_room_pkg" );
		
			addAmbientElement( "ber3b_third_room_pkg", "ber3b_fake_fire1", 1, 3, 10,350);
			addAmbientElement( "ber3b_third_room_pkg", "ber3b_fake_fire2", 1, 3, 10,350);
			addAmbientElement( "ber3b_third_room_pkg", "ber3b_fake_fire3", 1, 3, 10,350);
			addAmbientElement( "ber3b_third_room_pkg", "ber3b_fake_fire1_ext", 1, 3, 10,350);
			addAmbientElement( "ber3b_third_room_pkg", "ber3b_fake_fire2_ext", 1, 3, 10,350);
			addAmbientElement( "ber3b_third_room_pkg", "ber3b_fake_fire3_ext", 1, 3, 10,350);

	//***************
	//ber3b_Outdoor_Packages
	//*************** 
		
		declareAmbientPackage( "ber3b_outdoors_room_pkg" );
		
			addAmbientElement( "ber3b_outdoors_room_pkg", "ber3b_fake_fire1_ext", 1, 3, 10,350);
			addAmbientElement( "ber3b_outdoors_room_pkg", "ber3b_fake_fire2_ext", 1, 3, 10,350);
			addAmbientElement( "ber3b_outdoors_room_pkg", "ber3b_fake_fire3_ext", 1, 3, 10,350);
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	
	
	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
	//***************
	//ber3b_Indoors
	//*************** 

		declareAmbientRoom( "ber3b_indoors_room" );
	
			setAmbientRoomTone( "ber3b_indoors_room", "general_interior" );
			setAmbientRoomReverb( "ber3b_indoors_room", "stoneroom",  1, 0.4 );
			
		declareAmbientRoom( "ber3b_pipe_hall" );
			
			setAmbientRoomTone( "ber3b_pipe_hall", "general_interior" );
			setAmbientRoomReverb( "ber3b_pipe_hall", "stoneroom",  1, 0.4 );
			
	//***************
	//ber3b_Partial_Rooms
	//*************** 

		declareAmbientRoom( "ber3b_first_room" );
	
			setAmbientRoomTone( "ber3b_first_room", "first_room_wind" );
			setAmbientRoomReverb( "ber3b_first_room", "stoneroom",  1, 0.4 );
	
		declareAmbientRoom( "ber3b_second_room" );
	
			setAmbientRoomTone( "ber3b_second_room", "second_room_wind" );
			setAmbientRoomReverb( "ber3b_second_room", "stoneroom",  1, 0.4 );
	
		declareAmbientRoom( "ber3b_third_room" );
			
			setAmbientRoomTone( "ber3b_third_room", "third_room_wind" );
			setAmbientRoomReverb( "ber3b_third_room", "stoneroom",  1, 0.4 );
			
	//***************
	//ber3b_Outdoors
	//***************

		declareAmbientRoom( "ber3b_outdoors_room" );
	
			setAmbientRoomTone( "ber3b_outdoors_room", "room_null" );

	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************
	
		activateAmbientPackage( "ber3b_indoors_room_pkg", 0 );
		activateAmbientRoom( "ber3b_indoors_room", 0 );
		
	//*************************************************************************************************
	//                                      START SCRIPTS
	//*************************************************************************************************

		
		//level thread wind_script();
		level thread hitler_script();
		level thread battle_cry();
		//level thread plane_flyby();
		level thread play_arty_sound();
		level thread play_eagle_slip_sound();
		level thread play_roof_fall_sound();
		level thread play_roof_ground_sound();
		//level notify ("hitler_speak");

		play_sparks();
}



	//************************************************************************************************
	//                                      OTHER AUDIO FUNCTIONS
	//************************************************************************************************

battle_cry()
{
	walla_trigger = getent("charge_on", "targetname");
	walla_trigger waittill ("trigger");
	walla_origin = getent("charge_walla", "targetname");
	walla_origin playsound("ber3b_battle_cry");

	//TUEY Set Music State to URA
	setmusicstate("URA");

}
play_arty_sound()
{

	level endon( "ender" );
	
	while(1)
	{
		level waittill("int_strike");
		ber3b_earthquake = getent("sbmodel_pment_door_left", "targetname");
		ber3b_earthquake playsound ("art_int");
	}

}
play_eagle_slip_sound()
{

	level endon( "eagle_fall" );
	
	while(1)
	{
		level waittill("eagle_slip");
		ber3b_eagle_slip_sound = getent("smodel_parliament_eagle", "targetname");
		ber3b_eagle_slip_sound playsound ("ber3b_eagle_slip1", "sound_done");
		ber3b_eagle_slip_sound waittill("sound_done");
	}

}
play_roof_fall_sound()
{
	level waittill("audio_roof_fall");
	roof_arty = getent("smodel_dome_statue", "targetname");
	roof_arty playsound ("ber3b_roof_explo_mn");
}
play_roof_ground_sound()
{
	level waittill("audio_roof_ground");
	roof_arty = getent("smodel_dome_statue", "targetname");
	roof_arty playsound ("ber3b_roof_thump_st");
	wait(.2);
	roof_arty playsound ("ber3b_roof_fall_mn");
}
wind_script()
{
	trigger_on = getent("wind_trigger_on", "targetname");
	trigger_off = getent("wind_trigger_off", "targetname");
	
	wind_high = getent( "wind_high_origin" , "targetname" );
	wind_low = getent( "wind_low_origin" , "targetname" );
	
	music_player = getent("music_playa", "targetname");
	
	while (1)
	{
		trigger_on waittill ("trigger");
		wind_high playloopsound("outdoor_wind_line");
		wind_low playloopsound("outdoor_wind");
		//music_player stoploopsound(3);
		
		trigger_off waittill("trigger");
		wind_high stoploopsound(1);
		wind_low stoploopsound(1);
	}
}
hitler_script()
{
	level waittill ("hitler_speak");
	
	speech_origin_outside = getent( "outside_speech" , "targetname" );
	speech_origin_outside playloopsound("propaganda",2);
	
	march_origin_outside = getent( "outside_march" , "targetname" );
	march_origin_outside playloopsound("march_dry",2);
	
	level waittill ("outside_march_off");
	
	speech_origin_outside stoploopsound(2);
	march_origin_outside stoploopsound(2);
	
	speech_origin_inside = getent( "speech_origin_inside" , "targetname" );
	speech_origin_inside playloopsound("propaganda");
	
	march_origin_inside = getent( "march_origin_inside" , "targetname" );
	march_origin_inside playloopsound("march_dry",2);
	
	stop_inside_trigger = getent("charge_on", "targetname");
	stop_inside_trigger waittill ("trigger");
	speech_origin_inside stoploopsound(1);
	march_origin_inside stoploopsound(1);
}
//sending_plane_ents()
//{
	//Kevin Sending ent name to the client side
	//plane_gun1 = getent("il2_1", "targetname");
	//plane_gun2 = getent("il2_2", "targetname");
	//plane_gun3 = getent("il2_3", "targetname");
	//plane_gun4 = getent("il2_4", "targetname");
	//plane_gun5 = getent("il2_5", "targetname");
	//plane_gun6 = getent("stuka2", "targetname");
			
	//plane_gun1 transmittargetname();
	//plane_gun2 transmittargetname();
	//plane_gun3 transmittargetname();
	//plane_gun4 transmittargetname();
	//plane_gun5 transmittargetname();
	//plane_gun6 transmittargetname();
//}

play_crowd_sound()
{
	wait(0.5);
	playsoundatposition("crowd_for_parliament",	(-132, 20212, 895));
}
play_sparks()
{

	while(1)
	{
		wait(randomfloatrange(1, 3));
		playsoundatposition ("sparks", (-434,13214,531));
		wait(randomfloatrange(1, 3));
		playsoundatposition ("sparks", (1124, 13341, 719));
	}
}
