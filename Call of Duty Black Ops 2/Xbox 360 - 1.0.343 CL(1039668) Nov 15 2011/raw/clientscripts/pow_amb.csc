//
// file: pow_amb.csc
// description: clientside ambient script for pow: setup ambient sounds, etc.
// scripter: 		(initial clientside work - laufer)
//

#include clientscripts\_utility; 
#include clientscripts\_ambientpackage;
#include clientscripts\_music;
#include clientscripts\_audio;

main()
{
	//************************************************************************************************
	//                                              Ambient Packages
	//************************************************************************************************

	//declare an ambientpackage, and populate it with elements
	//mandatory parameters are <package name>, <alias name>, <spawnMin>, <spawnMax>
	//followed by optional parameters <distMin>, <distMax>, <angleMin>, <angleMax>


        	declareAmbientPackage( "outside" );
           		 //addAmbientElement( "outside", "null", 30, 90, 150, 2000 );
	
	
	//************************************************************************************************
	//                                       ROOMS
	//************************************************************************************************

	//explicitly activate the base ambientpackage, which is used when not touching any ambientPackageTriggers
	//the other trigger based packages will be activated automatically when the player is touching them
	//the same pattern is followed for setting up ambientRooms
	
		declareAmbientRoom( "outside" );
 			//setAmbientRoomTone( "outside", "null" );
 			setAmbientRoomReverb ("outside","pow_jungle", 1, 1);
 			setAmbientRoomContext( "outside", "ringoff_plr", "outdoor" );
 			
 		declareAmbientRoom( "cave_room" );
 			setAmbientRoomTone( "cave_room", "amb_cave_bg_growl" );
 			setAmbientRoomReverb ("cave_room","pow_cave_room", 1, 1);
 			setAmbientRoomSnapshot ("cave_room", "spl_pow_no_ext_amb");
 			setAmbientRoomContext( "cave_room", "ringoff_plr", "indoor" );
 			
 		declareAmbientRoom( "cave_ext_room" );
 			setAmbientRoomTone( "cave_ext_room", "amb_cave_bg_growl" );
 			setAmbientRoomReverb ("cave_ext_room","pow_cave_ext_room", 1, 1);
 			setAmbientRoomSnapshot ("cave_ext_room", "spl_pow_low_ext_amb");
 			setAmbientRoomContext( "cave_ext_room", "ringoff_plr", "indoor" );
 			
 		declareAmbientRoom( "cave_office" );
 			setAmbientRoomTone( "cave_office", "amb_cave_bg_growl" );
 			setAmbientRoomReverb ("cave_office","pow_concrete_bldgs", 1, 1);
 			setAmbientRoomSnapshot ("cave_office", "spl_pow_no_ext_amb");
 			setAmbientRoomContext( "cave_office", "ringoff_plr", "indoor" );
 			
 		declareAmbientRoom( "cell_room" );
 			setAmbientRoomTone( "cell_room", "amb_cave_bg_growl" );
 			setAmbientRoomReverb ("cell_room","pow_cell_room", 1, 1);
 			setAmbientRoomSnapshot ("cell_room", "spl_pow_no_ext_amb");
 			setAmbientRoomContext( "cell_room", "ringoff_plr", "indoor" );
            
 		declareAmbientRoom( "tunnels_medium_room" );
 			setAmbientRoomTone( "tunnels_medium_room", "amb_cave_bg_growl" );
 			setAmbientRoomReverb ("tunnels_medium_room","pow_tunnels_medium", 1, 1);
 			setAmbientRoomSnapshot ("tunnels_medium_room", "spl_pow_no_ext_amb");
 			setAmbientRoomContext( "tunnels_medium_room", "ringoff_plr", "indoor" );
 			
 		declareAmbientRoom( "tunnels_medium_ext_room" );
 			setAmbientRoomTone( "tunnels_medium_ext_room", "amb_cave_bg_growl" );
 			setAmbientRoomReverb ("tunnels_medium_ext_room","pow_tunnels_medium", 1, 1);
 			setAmbientRoomSnapshot ("tunnels_medium_ext_room", "spl_pow_low_ext_amb");
 			setAmbientRoomContext( "tunnels_medium_ext_room", "ringoff_plr", "indoor" );
 			
 		 declareAmbientRoom( "tunnels_large_room" );
 			setAmbientRoomTone( "tunnels_large_room", "amb_cave_bg_growl" );
 			setAmbientRoomReverb ("tunnels_large_room","pow_tunnels_large", 1, 1);
 			setAmbientRoomSnapshot ("tunnels_large_room", "spl_pow_no_ext_amb");
 			setAmbientRoomContext( "tunnels_large_room", "ringoff_plr", "indoor" );
 			
 		 declareAmbientRoom( "tunnels" );
 			setAmbientRoomTone( "tunnels", "amb_cave_bg_growl" );
 			setAmbientRoomReverb ("tunnels","pow_tunnels", 1, 1);
 			setAmbientRoomSnapshot ("tunnels", "spl_pow_no_ext_amb");
 			setAmbientRoomContext( "tunnels", "ringoff_plr", "indoor" );
 			
 		declareAmbientRoom( "log_cabins_room" );
 			//setAmbientRoomTone( "log_cabins_room", "null" );
 			setAmbientRoomReverb ("log_cabins_room","pow_log_cabins", 1, 1);
 			setAmbientRoomContext( "log_cabins_room", "ringoff_plr", "indoor" );
 			
  		declareAmbientRoom( "concrete_bldgs_room" );
 			//setAmbientRoomTone( "concrete_bldgs_room", "null" );
 			setAmbientRoomReverb ("concrete_bldgs_room","pow_concrete_bldgs", 1, 1);		
 			setAmbientRoomContext( "concrete_bldgs_room", "ringoff_plr", "indoor" );	 		
 			
 		declareAmbientRoom( "underground_room" );
 			//setAmbientRoomTone( "underground_room", "null" );
 			setAmbientRoomReverb ("underground_room","pow_underground_room", 1, 1); 	
 			setAmbientRoomContext( "underground_room", "ringoff_plr", "indoor" );	
 			
 		declareAmbientRoom( "hind_room" );
 			//setAmbientRoomTone( "hind_room", "null" );
 			setAmbientRoomReverb ("hind_room","pow_hind", 1, 1);
 			setAmbientRoomContext( "hind_room", "ringoff_plr", "outdoor" );	
 			//above is set to outdoor in order to hear the ringoff of your shots even though you are 'in' the chopper.
	
	//************************************************************************************************
	//                                      ACTIVATE DEFAULT AMBIENT SETTINGS
	//************************************************************************************************

  activateAmbientPackage( 0, "outside", 0 );
  activateAmbientRoom( 0, "outside", 0 );



//	wait(1);

		declaremusicState ("INTRO");
			musicAliasloop ("mus_intro_roulette", 0, 2);
			musicStinger ("mus_orchfx_roulette_timeslow", 14, true);
			
		declaremusicState ("ROULETTE_TIMESLOW");
			musicAlias ("mus_orchfx_roulette_timeslow", 0);
			musicAliasloop ("NULL", 0, 0);
			
		declaremusicstate ("CAVE_FIGHT");
			musicAliasloop ("mus_revenge_cave_fight", 0, 4);
			musicStinger ("mus_revenge_tunnels_STG", 14, true);
		
		declaremusicstate ("KILLED_RUSKY");
			musicAliasloop ("NULL", 0, 0);


		declaremusicstate("CLEARING_INTRO");
			musicAliasLoop("mus_intro_loop", 2, 4);

		declaremusicstate("INTRO_FIGHT");
			musicAliasLoop("mus_intro_fight_loop", 0, 3);
			musicStinger("mus_intro_fight_stg", 0);

		declaremusicstate("INTRO_FIGHT_FINISHED");
			musicAlias ("null", 0);

		declareMusicstate("CHOPPER_FIGHT_ONE");
			musicAliasLoop("mus_in_chopper_loop", 0, 4);	
			musicStinger ("mus_revenge_tunnels_STG", 14, true);
			
		declareMusicState ("LANDING");
			musicAliasloop ("NULL", 0, 0);
			
		declareMusicState ("BASE_ENTRANCE");
			musicAliasLoop("mus_revenge_base_entrance", 0, 2);
			
		declareMusicState ("IN_BASE");
			musicAliasLoop("mus_samsung_base_to_office", 0, 2);
			musicStinger ("mus_dummy_silence", 60, true);
		
		declareMusicState ("END_LEVEL_ANIMATION");
			musicAliasLoop("mus_panthers_end_scene", 0, 2);
			
		
		
	//************************************************************************************************
	//                                      THREAD FUNCTIONS
	//************************************************************************************************	

	level thread pow_default_snapshot();
//	level thread tunnel_ext_amb_snapshot();	
	level thread low_ext_amb_snapshot();
	level thread no_ext_amb_snapshot();
	level thread hind_on_snapshot();
	level thread hind_dust_up_1();
	level thread hind_landing();
	level thread hind_dust_up_and_cooldown();
	level thread hind_exit();
	level thread tunnels_bats();
	level thread tunnels_groans();
	level thread bulletcam();
	level thread pow_doors();	
	level thread roll_up_door();	
	level thread play_russian_radio();
	level thread spetz_body_fall();
	level thread woods_vision_snapshot();
}

	//************************************************************************************************
	//                                      SWITCH SNAPSHOTS
	//************************************************************************************************		
	
pow_default_snapshot()
{
	while(1)
	{
     	level waittill( "pow_default_snapshot" );
     	snd_set_snapshot( "spl_pow_default" );
    }
}

pow_rr_intro_snapshot()
{
     level waittill( "pow_rr_intro_snapshot" );
     snd_set_snapshot( "pow_rr_intro" );
}

//tunnel_ext_amb_snapshot()
//	{
//     level waittill( "tunnel_ext_amb_snapshot" );
//     snd_set_snapshot( "tunnel_ext_amb" );
//	}
	
low_ext_amb_snapshot()
{
     level waittill( "low_ext_amb_snapshot" );
     snd_set_snapshot( "spl_pow_low_ext_amb" );
}
	
no_ext_amb_snapshot()
{
     level waittill( "no_ext_amb_snapshot" );
     realwait(10.2);
     waitforclient(0);
     snd_set_snapshot( "spl_pow_no_ext_amb" );
     realwait(16);
     waitforclient(0);     
     activateAmbientRoom( 0, "hind_room", 1 );
}
hind_on_snapshot()
{
	 level waittill( "hind_on_snapshot" );
	 snd_set_snapshot( "spl_pow_hind_on" );
}

hind_dust_up_1()
{
	level waittill( "hind_first_dust" );
	dust_ent_1 = spawn (0, (0,0,0), "script_origin");
  realwait(3);
  waitforclient(0);
  //iprintlnbold ("dust_fade_in");  
  dust_ent_1 playloopsound ("evt_prop_dust", 2);	
	realwait( 14 );
	waitforclient(0);
  //iprintlnbold ("dust_fade_out");  
	dust_ent_1 stoploopsound( 4 );	
	wait (10);
	waitforclient(0);
	dust_ent_1 delete();		 
}

hind_dust_up_and_cooldown()
{
	level waittill( "hind_dust" );
	dust_ent = spawn (0, (0,0,0), "script_origin");
	steam_ent = spawn (0, (34945, 56962, 650), "script_origin");
	cool_down_ent = spawn (0, (35059, 56964, 575), "script_origin");
  realwait(6);
  waitforclient(0);
  //iprintlnbold ("dust_fade_in");  
  dust_ent playloopsound ("evt_prop_dust", 2);	
	realwait( 14 );
	waitforclient(0);
  //iprintlnbold ("dust_fade_out");  
	dust_ent stoploopsound( 2);	
  steam_ent playloopsound ("evt_steaming", 5);	
  cool_down_ent playloopsound ("evt_cooling", 5);		
  realwait(30);	
  waitforclient(0);
	steam_ent stoploopsound( 5 );
  realwait(10);		
  waitforclient(0);
	cool_down_ent stoploopsound( 7 ); 
	wait (20);
	waitforclient(0);
	dust_ent delete();	
	steam_ent delete();
	cool_down_ent delete();		 
}

	
hind_landing()
{
	 level waittill( "hind_landing" );
   //realwait(14.7);
   //iprintlnbold ("ground!");
 	 playsound (0, "evt_hind_land", (0,0,0));
   realwait(3);	 
   waitforclient(0);
 	 playsound (0, "evt_hind_shut_down", (0,0,0));
 	 //do not remove below  - snapshot is set to shut off the heli sounds
   snd_set_snapshot( "spl_pow_no_ext_amb" ); 	 
}

hind_exit()
{
	 level waittill( "hind_exit_sequence" );
   //iprintlnbold ("cans off");	 
 	 playsound (0, "evt_headset_off_plr", (0,0,0));
   realwait(1.7);
   waitforclient(0);
   //iprintlnbold ("woods cans off");
 	 playsound (0, "evt_headset_off_woods", (0,0,0));	
   realwait(1.5);   
   waitforclient(0);
   //iprintlnbold ("open door!");
 	 playsound (0, "evt_door_open", (0,0,0));
   snd_set_snapshot( "spl_pow_low_ext_amb" );
   realwait(3.5);   
   waitforclient(0);
   //iprintlnbold ("window");
 	 playsound (0, "evt_window_open", (0,0,0));
   realwait(1);    
   waitforclient(0);
 	 playsound (0, "evt_disembark", (0,0,0));
 	 realwait(1);    
   waitforclient(0);
   snd_set_snapshot( "spl_pow_default" );
	 deactivateAmbientRoom( 0, "hind_room", 1 );
}

tunnels_bats()
{
	wait(2);
	waitforclient(0);
	bats = getstructarray ("amb_bats", "targetname");
	for(i=0;i<bats.size;i++)
	{
		bats[i] thread play_bat_sounds();	
		
	}
	
	
}
play_bat_sounds()
{
	players = getlocalplayers();
	while(1)
	{
		
		distance_to_player = Distance( players[0].origin, self.origin );
		while(distance_to_player > 300)
		{
			wait(randomfloatrange (0.5, 3));
			waitforclient(0);
			playsound (0, "amb_anml_bat", self.origin);	
			
		}
		wait(0.1);
		waitforclient(0);
		
	}
	
	
}
tunnels_groans()
{
	wait(2);
	wood_groans = getstructarray ("amb_wood_creak", "targetname");
	for(i=0;i<wood_groans.size;i++)
	{
		wood_groans[i] thread play_groan_sounds();	
		
	}
	
	
}
play_groan_sounds()
{
	players = getlocalplayers();
	while(1)
	{
	
		distance_to_player = Distance( players[0].origin, self.origin );
		while(distance_to_player < 500)
		{
			wait(randomfloatrange (3, 8));
			waitforclient(0);
			playsound (0, self.script_sound, self.origin);	
			
		}
		wait(0.1);
		waitforclient(0);
		
	}
	
	
}

bulletcam()
{
	while(1)
	{
		ent1 = Spawn( 0, (0,0,0), "script_origin" );
		ent2 = Spawn( 0, (0,0,0), "script_origin" );
		
		level waittill( "blt_st" );
		snd_set_snapshot( "spl_timeslow_bulletcam" );
		PlaySound( 0, "evt_bulletcam_start", (0,0,0) );
		PlaySound( 0, "evt_bulletcam_end", (0,0,0) );
		ent1 PlayLoopSound( "evt_bulletcam_vox", .05 );
		ent2 PlayLoopSound( "evt_bulletcam_whiz", .05 );
		
		level waittill( "blt_imp" );
		PlaySound( 0, "evt_bulletcam_ai_death", (0,0,0) );
		ent1 Delete();
		ent2 Delete();
		wait(.75);
		waitforclient(0);
		activateAmbientPackage( 0, "outside", 0 );
		snd_set_snapshot( "spl_pow_low_ext_amb" );
		wait(1.5);
		waitforclient(0);
		playsound ( 0,"fly_bodyfall_spetz", (-6547,-44754,-291));
	}
}

roll_up_door()
{
	level waittill( "roll_up_door" );
	door_ent = Spawn( 0, (29918, 58763, 1022), "script_origin" );	
	playsound (0, "evt_roll_up_start", (29918, 58763, 1022));		
	door_ent PlayLoopSound( "evt_roll_up_loop", .5 );
	realwait(1.5);
	waitforclient(0);
	door_ent stoploopsound( .5 );
	playsound (0, "evt_roll_up_stop", (29918, 58763, 1022));
	wait(5);	
	waitforclient(0);
	door_ent Delete();					  
}

pow_doors()
{
	level waittill( "pow_doors" );
	//iprintlnbold ("button & doors");
	
	playsound (0, "evt_pow_button", (30301, 59034, 967));		
	playsound (0, "evt_pow_door_latch", (30304, 59086, 967));	
	realwait(.3);
	waitforclient(0);
	playsound (0, "evt_pow_door_latch", (30127, 58966, 968));			
	realwait(1.2);
	waitforclient(0);
	playsound (0, "evt_pow_door_open_1", (30283, 59229, 972));	 	 
	playsound (0, "evt_pow_door_open_2", (30304, 59086, 967));	
	realwait(1.4);
	waitforclient(0);
	playsound (0, "evt_rez_door_open", (30127, 58966, 968));	

}
play_russian_radio()
{
	level waittill ("rsd");
	radio = clientscripts\_audio::playloopat(0, "amb_radio_02", (-6547,-44793,-288.5));	
}

spetz_body_fall()
{
	level waittill ("spetz_ded");	
	playsound (0, "fly_bodyfall_spetz", (-6547,-44793,-288.5));
	
}

woods_vision_snapshot()
{
	while(1)
	{
     	level waittill( "woods_snapshot" );
     	snd_set_snapshot( "spl_pow_amb_fade" );
		realwait (15);
		snd_set_snapshot ("spl_pow_default");
    }
}