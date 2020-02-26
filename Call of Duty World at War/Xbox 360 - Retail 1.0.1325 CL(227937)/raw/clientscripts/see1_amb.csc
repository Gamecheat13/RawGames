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
	//See1_Outdoors
	//*************** 

		declareAmbientPackage( "see1_outdoors_pkg" );
			
			//addAmbientElement( "see1_outdoors_pkg", "amb_stone_small", 10, 20, 100, 500);
			addAmbientElement( "see1_outdoors_pkg", "wind_gust_3d", 5, 20, 80,100);
			addAmbientElement( "see1_outdoors_pkg", "bomb_far", 2, 15, 10, 200 );

	//***************
	//See1_Trench_Interrior
	//*************** 

		declareAmbientPackage( "see1_trench_pkg" );
		
			//addAmbientElement( "see1_trench_pkg", "amb_stone_small", 10, 20, 100, 200);
			//addAmbientElement( "see1_trench_pkg", "bomb_far", 2, 15, 10, 200 );
			//addAmbientElement( "see1_trench_pkg", "bomb_medium", 15, 30, 100, 500 );
	
		declareAmbientPackage( "see1_tunnel_pkg" );
	
			//addAmbientElement( "see1_tunnel_pkg", "amb_wood_small", 10, 20, 100, 200);
			//addAmbientElement( "see1_tunnel_pkg", "amb_wood_boards", 20, 40, 100, 500);
			//addAmbientElement( "see1_tunnel_pkg", "amb_wood_creak", 20, 40, 100, 500);
			//addAmbientElement( "see1_tunnel_pkg", "bomb_far", 2, 15, 10, 200 );
			//addAmbientElement( "see1_tunnel_pkg", "bomb_medium", 15, 30, 100, 500 );	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms


	//***************
	//See1_Outdoors
	//*************** 

		declareAmbientRoom( "see1_outdoors_room" );
	
			setAmbientRoomTone( "see1_outdoors_room", "outdoor_wind" );
			setAmbientRoomReverb( "see1_outdoors_room", "forest",  1, 1 );
			
	//***************
	//See1_Trench_Interrior
	//*************** 

		declareAmbientRoom( "see1_interior" );
	
			setAmbientRoomTone( "see1_interior", "partial_room_wind" );
			setAmbientRoomReverb( "see1_outdoors_room", "wood_room",  1, 1 );
			
		declareAmbientRoom( "see1_bunker" );
			
			setAmbientRoomTone( "see1_bunker", "partial_room_wind2" );
			setAmbientRoomReverb( "see1_outdoors_room", "wood_room",  1, 1 );
			
	//***************
	//See1_Subway
	//***************

		declareAmbientRoom( "small_tunnel" );	
			setAmbientRoomTone( "small_tunnel", "bgt_small_tunnel" );
	
		declareAmbientRoom( "large_tunnel" );			
			setAmbientRoomTone( "large_tunnel", "bgt_large_tunnel" );
	
		activateAmbientPackage( 0, "see1_outdoors_pkg", 0 );
		activateAmbientRoom( 0, "see1_outdoors_room", 0 );
	
	//************************************************************************************************
	//                                     MUSIC PACKAGES
	//************************************************************************************************


		declareMusicState("INTRO"); //one shot dont transition until done
	    	musicAlias("mx_intro", 0);
			musicWaitTillDone();

		declareMusicState("FIELDS_OF_FIRE");
			musicAliasloop("mx_battle_outside_loop", 0, 4);
			musicStinger("mx_bridge_stg", 12);
			
		declareMusicState("TRUCK");			
			musicAliasloop("mx_drum_loop",0,4);

		declareMusicState("TANKS_DESTROYED");
			musicAliasloop("mx_underscore_evt2",0,4);

		declareMusicState("SURPRISE");
			musicAlias("mx_tank_surprise", 0);
			musicStinger("mx_evt2_stg", 25);		

		declareMusicState("SURPRISE_TANK_DEAD");
			musicAliasloop("mx_battle_outside_loop",2,4);
			musicStinger("mx_bridge_stg", 4);

		declareMusicState("AT_CAMP");
			musicAliasloop("mx_basecamp_theme", 0, 7);	

		declareMusicState("END_LEVEL");
			musicAlias("mx_level_end",0);

		//TODO Create New Loop for pacing section (or use the MX_UNDERSCORE_ALT)
		//IMPLEMENT THE ABOVE MUSIC STATE FOR POST TANK DESTRUCTION




  





//******************************************************************************************
//						OTHER SCRIPTS
//********************************************************************************************
	
//		activateAmbientPackage( "_pkg", 0 );
//		activateAmbientRoom( "_room", 0 );
		thread temp_wheat_fire();
		//thread house_explosion1();
		thread house_explosion2();
		//thread getsoundpos();
		//thread camp_audio();
		thread plane_machine_gun();
}

temp_wheat_fire()
{
	level waittill("wheat_fire");
	wheat_fire1 = getstruct("wheat_fire1","targetname");
	wheat_fire2 = getstruct("wheat_fire2","targetname");
	wheat_fire3 = getstruct("wheat_fire3","targetname");
	wheat_fire4 = getstruct("wheat_fire4","targetname");
	wheat_fire5 = getstruct("wheat_fire5","targetname");

	clientscripts\_audio::playloopat(0,"see1_fire_med",wheat_fire1.origin,0);
	clientscripts\_audio::playloopat(0,"see1_fire",wheat_fire2.origin,0);
	clientscripts\_audio::playloopat(0,"see1_fire_med",wheat_fire3.origin,0);
	clientscripts\_audio::playloopat(0,"see1_fire",wheat_fire4.origin,0);
	clientscripts\_audio::playloopat(0,"see1_fire_med",wheat_fire5.origin,0);
}

getsoundpos()
{
	while(!isdefined(level._explosionEntPos))
	{
		ent = getent(0,"opening_house_explosion_target", "targetname");
		if(isdefined(ent))
		{
			level._explosionEntPos = ent.origin;
		}
		else
		{
			wait(0.2);
		}
	}
	
}

house_explosion1()
{
	level thread getsoundpos();
	level waittill("house_explosion");
/*	house_explo = getstruct( "house_explo", "targetname" );
	
	playsound(0,"explosion_house",house_explo.origin);*/
	
	if(isdefined(level._explosionEntPos))
	{
		playsound(0,"explosion_house",level._explosionEntPos.origin);
	}
}
house_explosion2()
{
	level waittill("house_explosion");
	house_explo = getstruct( "house_explo", "targetname" );
	
	playsound(0,"explosion_house",house_explo.origin);
}
camp_audio()
{
	level waittill("camp_audio_on");
	klaxxon = getstruct( "klaxxon", "targetname" );
	pa_speaker = getstruct( "pa_speaker", "targetname" );
	
	//playsound(0,"klaxxon",klaxxon.origin);
	//clientscripts\_audio::playloopat(0,"klaxxon",klaxxon.origin,0);
	//playsound(0,"pa_speaker",pa_speaker.origin);
	e1 = clientscripts\_audio::playloopat(0,"klaxxon",klaxxon.origin);
	e2 = clientscripts\_audio::playloopat(0,"pa_speaker",pa_speaker.origin);
	level waittill( "stop_pa" );
	deletefakeent(0,e2);
	level waittill( "stop_klaxxon" );
	deletefakeent(0,e1);
			
}
plane_machine_gun()
{

	for(;;)
	{
		level waittill("start_firing_sound");	
		thread my_coolness();
	}
}

my_coolness()
{
	level endon( "stop_firing_sound" );
	while(1)
	{
		// There could be more than 1 plane at any given time (Alex Liu)
		plane_guns = getentarray(0,"plane", "targetname");
		for( i = 0; i < plane_guns.size; i++ )
		{
			playsound(0,"plane_shot",plane_guns[i].origin);
		}
		wait(.048);
	}

}