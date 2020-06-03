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
	//ber3b_Indoor_Packages
	//*************** 

		declareAmbientPackage( "ber3b_indoors_room_pkg" );
			
			addAmbientElement( "ber3b_indoors_room_pkg", "ber3b_fake_fire1", 1, 3, 10,350);
			addAmbientElement( "ber3b_indoors_room_pkg", "ber3b_fake_fire2", 1, 3, 10,350);
			addAmbientElement( "ber3b_indoors_room_pkg", "ber3b_fake_fire3", 1, 3, 10,350);
			addAmbientElement( "ber3b_indoors_room_pkg", "bomb_far", 5, 10, 10,350);
			addAmbientElement( "ber3b_indoors_room_pkg", "amb_spooky_2d", 10, 18, 10,350);
		
		declareAmbientPackage( "ber3b_pipe_hall_pkg" );
					
			addAmbientElement( "ber3b_pipe_hall_pkg", "ber3b_fake_fire1", 1, 3, 10,350);
			addAmbientElement( "ber3b_pipe_hall_pkg", "ber3b_fake_fire2", 1, 3, 10,350);
			addAmbientElement( "ber3b_pipe_hall_pkg", "ber3b_fake_fire3", 1, 3, 10,350);
			addAmbientElement( "ber3b_pipe_hall_pkg", "pipe_hits", 3, 10, 10,350);
			addAmbientElement( "ber3b_pipe_hall_pkg", "amb_spooky_2d", 10, 18, 10,350);
			
	//***************
	//ber3b_Partial_Room_Packages
	//*************** 

		declareAmbientPackage( "ber3b_first_room_pkg" );
		
			addAmbientElement( "ber3b_first_room_pkg", "amb_fire_ember", 1, 3, 10, 100);
			addAmbientElement( "ber3b_first_room_pkg", "ber3b_fake_fire1", 1, 3, 10,350);
			addAmbientElement( "ber3b_first_room_pkg", "ber3b_fake_fire2", 1, 3, 10,350);
			addAmbientElement( "ber3b_first_room_pkg", "ber3b_fake_fire3", 1, 3, 10,350);
			addAmbientElement( "ber3b_first_room_pkg", "amb_spooky_2d", 10, 18, 10,350);
	
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
			setAmbientRoomReverb( "ber3b_indoors_room", "stoneroom",  1, 0.6 );
			
		declareAmbientRoom( "ber3b_pipe_hall" );
			
			setAmbientRoomTone( "ber3b_pipe_hall", "general_interior" );
			setAmbientRoomReverb( "ber3b_pipe_hall", "stoneroom",  1, 0.6 );
			
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
	//                                      MUSIC PACKAGES
	//************************************************************************************************



		declareMusicState("DIARY");
			musicAlias("mx_diary_brutal", 0);

	  	declareMusicState("INTRO"); //one shot dont transition until done
			musicAlias("mx_intro_stinger",0);
	  		musicAliasloop("mx_underscore",0, 4);	

		declareMusicState("PARLIAMENT_ROOM");
			musicAliasloop("mx_parliament_room",4,4);

		declareMusicstate("DOWN_THE_STAIRS");
			musicAliasloop("mx_parliament_downstairs",0,4);
			musicStinger("mx_parliament_stg",7);
			
		declareMusicstate("PARLIAMENT_CLEARED");
			musicAliasloop("mx_underscore",0,4);

		declareMusicstate("THROUGH_THE_DOOR");
			musicAlias("mx_bold_stg",0);
			musicAliasloop("mx_underscore",0,4);

		declareMusicstate("URA");
			musicAliasloop("mx_theme_loop",0,1);
			musicStinger("mx_theme_loop_stg", 20);

		declareMusicState("ROCKETS_GALORE");
			musicAliasloop("mx_flag_loop",4, 4);	

		declareMusicstate("ANTHEM");
			musicAlias("mx_rus_anthem_final",10);
//			musicAliasLoop("mx_roof_loop",2,4);

		declareMusicState ("PLANT_FLAG");
			musicAlias("mx_planted_stg", 0);


	





	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************


		activateAmbientPackage( 0, "ber3b_indoors_room_pkg", 0 );
		activateAmbientRoom( 0, "ber3b_indoors_room", 0 );
		
//		thread plane_machine_gun1();
//		thread plane_machine_gun2();
//		thread plane_machine_gun3();
//		thread plane_machine_gun4();
}

plane_machine_gun1()
{

	for(;;)
	{
		level waittill("start_firing_il2_1_gun");
		plane_gun1 = getent(0,"il2_1", "targetname");
		thread plane_gun(17,plane_gun1);
		wait 1;
		thread plane_gun(35,plane_gun1);
		wait .5;
		thread plane_gun(17,plane_gun1);
		wait 1;
		thread plane_gun(10,plane_gun1);
		wait 1.5;
		thread plane_gun(10,plane_gun1);
		wait .75;
		thread plane_gun(10,plane_gun1);
		
	}
}
plane_machine_gun2()
{
	for(;;)
	{
		level waittill("start_firing_il2_2_gun");
		plane_gun2 = getent(0,"il2_2", "targetname");
		thread plane_gun(17,plane_gun2);
		wait 1;
		thread plane_gun(35,plane_gun2);
		wait 1;
		thread plane_gun(17,plane_gun2);
		wait 1;
		thread plane_gun(10,plane_gun2);
		wait 1;
		thread plane_gun(10,plane_gun2);
		wait .5;
		thread plane_gun(10,plane_gun2);
		
	}
}
plane_machine_gun3()
{
	for(;;)
	{
		level waittill("start_firing_il2_3_gun");
		plane_gun3 = getent(0,"il2_4", "targetname");
		thread plane_gun(17,plane_gun3);
		wait .5;
		thread plane_gun(17,plane_gun3);
		wait 1;
		thread plane_gun(10,plane_gun3);
		wait 1.5;
		thread plane_gun(10,plane_gun3);
		wait .75;
		thread plane_gun(10,plane_gun3);
		wait 1.5;
		thread plane_gun(10,plane_gun3);
		wait 1.5;
		thread plane_gun(14,plane_gun3);
		wait .75;
		thread plane_gun(17,plane_gun3);
	}
}
plane_machine_gun4()
{
	for(;;)
	{
		level waittill("start_firing_il2_4_gun");
		plane_gun4 = getent(0,"il2_3", "targetname");
		thread plane_gun(17,plane_gun4);
		wait .5;
		thread plane_gun(17,plane_gun4);
		wait 1;
		thread plane_gun(10,plane_gun4);
		wait 1;
		thread plane_gun(14,plane_gun4);
		wait .75;
		thread plane_gun(10,plane_gun4);
		wait 1.5;
		thread plane_gun(24,plane_gun4);
		wait 1;
		thread plane_gun(14,plane_gun4);
		wait .75;
		thread plane_gun(17,plane_gun4);
	}
}

plane_gun(fire_times, plane_name)
{
	
	for( i = 0; i < fire_times; i++ )
	{
		playsound(0,"plane_shot",plane_name.origin);
		wait(.048);
	}
}