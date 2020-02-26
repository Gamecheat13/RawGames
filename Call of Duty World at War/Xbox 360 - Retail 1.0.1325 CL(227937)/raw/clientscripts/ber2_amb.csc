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
	//Ber2_Outdoors
	//*************** 

		declareAmbientPackage( "outdoors_pkg" );			
			//addAmbientElement( "outdoors_pkg", "amb_stone_small", 10, 20, 100, 500);
			//addAmbientElement( "outdoors_pkg", "amb_stone_med", 10, 20, 100,500);
			addAmbientElement( "outdoors_pkg", "bomb_far", 2, 12, 500, 2000 );

	//***************
	//Ber2_Building_Interrior
	//*************** 

		declareAmbientPackage( "stone_room_pkg" );
		
			//addAmbientElement( "stone_room_pkg", "amb_stone_small", 10, 20, 100, 200);
			addAmbientElement( "stone_room_pkg", "bomb_far", 2, 12, 1000, 4000 );
			addAmbientElement( "stone_room_pkg", "bomb_medium", 15, 30, 1000, 3500 );
	
		declareAmbientPackage( "wood_room_pkg" );	
			//addAmbientElement( "wood_room_pkg", "amb_wood_small", 10, 20, 100, 200);
			//addAmbientElement( "wood_room_pkg", "amb_wood_boards", 20, 40, 100, 500);
			//addAmbientElement( "wood_room_pkg", "amb_wood_creak", 20, 40, 100, 500);
			addAmbientElement( "wood_room_pkg", "bomb_far", 2, 12, 500, 3500 );
			addAmbientElement( "wood_room_pkg", "bomb_medium", 15, 30, 800, 3500 );

	//***************
	//Ber2_Subway
	//*************** 
		
			declareAmbientPackage( "rodent_pkg" );		
				addAmbientElement( "rodent_pkg", "amb_rodents", 5, 35, 100, 500 );
	
			declareAmbientPackage( "large_tunnel_pkg" );		
				addAmbientElement( "large_tunnel_pkg", "amb_water_drips", 0.05, 0.8, 10, 100 );
	
			declareAmbientPackage( "small_tunnel_pkg" );
				//addAmbientElement( "small_tunnel_pkg", "amb_dog_bark", 3, 6, 2000, 3000);
				//addAmbientElement( "small_tunnel_pkg", "amb_wood_creak", 4, 12, 10, 100 );

			declareAmbientPackage( "train_car" );
			declareAmbientPackage( "small_room" );
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms

	//***************
	//Ber2_Outdoors
	//*************** 

		declareAmbientRoom( "outdoors_room" );	
			setAmbientRoomTone( "outdoors_room", "helmet_rainr" );
			setAmbientRoomTone( "outdoors_room", "helmet_rainf" );
			setAmbientRoomReverb( "outdoors_room", "ber1",  1, 1 );
			
	//***************
	//Ber2_Building_Interrior
	//*************** 

		declareAmbientRoom( "closed_room" );	
			//setAmbientRoomTone( "closed_room", "closed_room_wind" );
			setAmbientRoomReverb( "closed_room", "cod_alley", 0.70, 1 );
	
		declareAmbientRoom( "partial_room" );	
			setAmbientRoomTone( "partial_room", "partial_room_wind" );
			setAmbientRoomReverb( "partial_room", "livingroom", 1, 0.5 );
	
		declareAmbientRoom( "basement_room" );			
			//setAmbientRoomTone( "basement_room", "basement_wind" );
			setAmbientRoomReverb( "basement_room", "cod_alley", 0.70, 1 );
			
	//***************
	//Ber2_Subway
	//***************

		declareAmbientRoom( "small_tunnel" );	
			setAmbientRoomTone( "small_tunnel", "bgt_small_tunnel" );
			setAmbientRoomReverb( "small_tunnel", "stonecorridor", 1.0, 1 );
	
		declareAmbientRoom( "large_tunnel" );			
			setAmbientRoomTone( "large_tunnel", "bgt_large_tunnel" );
			setAmbientRoomReverb( "large_tunnel", "HANGAR", 1, 0.8);

		declareAmbientRoom( "train_car" );	
			setAmbientRoomTone( "train_car", "bgt_large_tunnel_filtered" );
			setAmbientRoomReverb( "train_car", "sewerpipe", 1, 0.9 );

		declareAmbientRoom( "small_room" );	
			//setAmbientRoomTone( "small_room", "bgt_small_room" );
			setAmbientRoomReverb( "small_room", "SMALLROOM", 1.0, 1 );



	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

		activateAmbientPackage( 0, "outdoors_pkg", 0 );
		activateAmbientRoom( 0, "outdoors_room", 0 );

	//************************************************************************************************
	//                                     MUSIC PACKAGES
	//************************************************************************************************



	  	declareMusicState("INTRO"); //one shot dont transition until done
			musicAlias("MX_intro_stg",0);
	  		musicWaitTillDone();	

		declareMusicState("SIGN_FELL");
			musicAliasloop("MX_underscore",0,1);
			musicStinger ("MX_bank_stg");
			musicWaitTillStingerDone();

		declareMusicstate("BANK");
			musicAliasloop("MX_underscore_drum",0,4);

		declareMusicstate("STREET_ENTRANCE");
			musicAliasloop("mx_boldmen_city",0, 6);
			musicStinger("mx_building_stg", 18);
	
		declareMusicstate ("BOOM_MFER");
			musicAlias ("mx_slayem", 1);		

		declaremusicstate ("SLAY_EM");
			musicAlias ("mx_slayem", 1);		
			
		declaremusicstate ("RUN_MORTARS");
			musicAlias ("mx_runmortars");
			musicwaittilldone();
		
		declaremusicstate("SUBWAY");
			musicAlias ("mx_subway");
			musicAliasloop("mx_subway_loop",4,4);

		declaremusicstate("SUBWAY_END");
			musicAlias ("mx_end_stg");
			//musicAliasloop("mx_subway_loop",0,4);
			//Kevin commented the loop out because the stinger is almost exactly as long as it takes from
			//beginning to end of the event.  THe problem is it ends a second before the level ends and starts
			//the loop and sounds bad.
			
	//SET BUSSES

		declareBusState("underwater");
			busFadeTime(.1);
			busVolumesExcept("music", "full_vol", "ui", 0);


		declareBusState("STREET");
			busFadeTime(3);
			busVolume("ambience", 0.15);
			busVolume("projectile", 0.7);
			busVolume("full_vol", 0.8);
			
		declareBusState("collapse");
			busFadeTime(2);
			busVolumesExcept("music", "full_vol","hvy_wpn", "ui","ambience", 0.1);
			busvolume("pis_1st", 1);
			busvolume ("rfl_1st", 1);
			busvolume("smg_1st", 1);
			busvolume("ambience",1);
			
		declareBusState("return_default");
			busFadeTime(5);
			busVolumeAll(1);


		//busVolume("projectile", 0.4);

		//busVolume("explosion", 1);
		//	busVolume("hvy_wpn", 1);




	//************************************************************************************************
	//                                     OTHER SCRIPTS
	//************************************************************************************************



	thread gramophone();
	thread start_lights();
	thread set_wave_bus();
	thread set_collapse_bus();
}

gramophone()
{
	level waittill ("requiem");
	gramophone = getstruct("gramophone", "targetname");
	
	playsound (0,"gramophone",gramophone.origin);
}
set_wave_bus()
{
	level waittill ("set_wave_bus");
	
	setBusState("underwater");
}
set_collapse_bus()
{
	level waittill ("collapse");
	
	setBusState("collapse");
	
	wait 10;
	
	setBusState("return_default");
}
start_lights()
{
	level waittill ("start_lights");
	array_thread(getstructarray( "light_surge", "targetname" ), ::light_sound);
	array_thread(getstructarray( "subway_generator", "targetname" ), ::generator_sound);
	array_thread(getstructarray( "electrical_room", "targetname" ), ::electrical_room_sound);
}
light_sound()
{
	for(;;)
	{
		e1 = clientscripts\_audio::playloopat(0,"amb_light_hum",self.origin);
		level waittill ("arty_light_hit");
		deletefakeent(0,e1);
		
		playsound(0,"amb_light_surge",self.origin);
		wait randomfloatrange(.2,.6);
		playsound(0,"amb_light_surge",self.origin);
		wait randomfloatrange(.2,.6);
		playsound(0,"amb_light_surge",self.origin);
		wait randomfloatrange(.2,.6);
		playsound(0,"amb_light_surge",self.origin);
		
		level waittill ("f");	// was 'flicker'
		thread one_light_flicker(self);
		level waittill("fs");	// was 'flicker_stop'
	}
}
one_light_flicker(light)
{
	level endon( "fs" );	// was 'flicker_stop'
	while(1)
	{
		playsound (0,"amb_light_surge",self.origin);
		wait randomfloatrange(.2,.6);
	}
}
generator_sound()
{
	for(;;)
	{
		e2 = clientscripts\_audio::playloopat(0,"subway_generator",self.origin);
		level waittill ("arty_light_hit");
		deletefakeent(0,e2);
		playsound(0,"subway_generator_end",self.origin);
		level waittill ("f");	// was 'flicker'
		playsound(0,"subway_generator_start",self.origin);
		level waittill("fs");	// was 'flicker_stop'
	}
}
electrical_room_sound()
{
	for(;;)
	{
		e3 = clientscripts\_audio::playloopat(0,"bgt_small_room",self.origin);
		level waittill ("arty_light_hit");
		deletefakeent(0,e3);
		playsound(0,"bgt_small_room_stop",self.origin);
		level waittill ("f");	// was 'flicker'
		playsound(0,"bgt_small_room_start",self.origin);
		level waittill("fs");	// was 'flicker_stop'
	}
}