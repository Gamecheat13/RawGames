#include maps\_utility;
#include maps\_ambientpackage;
#include maps\_music;
main()
{
	
	//Set up Ambient Rooms and Packages

//************************************************************************************************
//				Ambient Packages
//************************************************************************************************

	
	
//************************************************************************************************
//				ACTIVATE DEFAULT AMBIENT SETTINGS
//************************************************************************************************
	activateAmbientPackage( "pel1_outdoors", 0 );
	activateAmbientRoom( "pel1_outdoors", 0 );


//*************************************************************************************************
//				   START SCRIPTS
//*************************************************************************************************
	level.directiontracker = 0;
	level.action_music_playing = 0;

	//(This waits until 1st player is connected)
	wait_for_first_player(); 
	
	level thread play_distant_battle_sound();
	level thread bunker_footsteps();
	thread start_intro_sounds();
//	level thread player_goes_middle();
//	level thread player_goes_right();

//	level thread player_music_state_switcher_right();

//	level thread player_music_state_switcher_middle();
	level thread player_upstairs();

	level thread start_intro_planes_0();
	level thread start_intro_planes_8();		
	level thread start_intro_planes_9();
	level thread start_intro_planes_21();
		
	//REMOVE AFTER TEST
	turn_on_bc();
}

//************************************************************************************************
//			 	OTHER AUDIO FUNCTIONS
//************************************************************************************************

start_intro_sounds()
{	
	door_hydro = getent("lst_door_open_sound", "targetname");
	ramp_location = getent("lst_door_splash_sound","targetname");
	
	level waittill ("lst door opening");
	door_hydro playsound("door_hydro");
	
	level waittill ("lst door splash");
	ramp_location playsound("ramp_splash");
		
	level waittill("lvt_splash");
	ramp_location playsound("lvt_splash");
	
	activateAmbientPackage( "pel1_outdoors", 0 );
	activateAmbientRoom( "pel1_outdoors", 0 );
	
	// do the PA stuff on left and right
	trigger_wait("ambient_lci_pre_trigger","targetname");
	pa_fire = getent("pa_fire_right","targetname");
	playsoundatposition("pa_fire", pa_fire.origin);
	
	wait(0.4);
	pa_fire_b = getent("pa_fire_left","targetname");
	pa_fire_b playsound("pa_fire");
}

get_next_vo(prefix,last_vo,maximum)
{
	line = 0;
	for(i=0; i<100; i++)
	{
		line = randomintrange(1,maximum);
		if(prefix+line != last_vo)
			break;
	}
	return prefix+line;
}

bunker_voices()
{
	lastvoiceover =  "null";
	level endon ("grenades_dropped");
	
	while(1)
	{
		lastvoiceover = get_next_vo("amb_dist_voices_", lastvoiceover, 6);
		
		
		if(randomintrange(1,2) == 1)
		{
			playsoundatposition(lastvoiceover, (1614, -3948, -98));	
		}
		else		
		{
			playsoundatposition(lastvoiceover, (2079, -3951, -107));
		}
		

		wait(randomintrange(4,8));
	
	}

}

bunker_footsteps()
{
	
	level endon ("grenades_dropped");	
	while(1)
	{				
		
		if(randomintrange(1,2) == 1)
		{
			playsoundatposition("s_wood_steps_upstairs", (1614, -3948, -98));
		}
		else		
		{
			playsoundatposition("s_wood_steps_upstairs", (2079, -3951, -107));
		}		

		wait(randomintrange(5,8));
	
	}


}

music_switcher(music)
{	
	//This is for the section where the player can go different ways
	setmusicstate(music);

}

player_music_state_switcher_right()
{
	level endon("front_bunker");
	while(1)
	{
		level waittill("front_bunker");
		music_switcher ("STEALTHY_PLAYER");
		wait(15);

	}

}

player_music_state_switcher_middle()
{
	level endon("front_bunker");
	while(1)
	{
		level waittill("player_went_middle");
		music_switcher ("CRAZY_PLAYER");
		wait(15);

	}

}


player_goes_middle()
{
	level endon ("player_comitted");
	level waittill("player_went_middle");
	music_switcher("CRAZY_PLAYER");
	level thread player_watcher("middle");

}

player_goes_right()
{
	level endon ("player_comitted");
	level waittill("player_went_right");
	music_switcher ("STEALTHY_PLAYER");
	level thread player_watcher ("right");

}

player_watcher(location)
{
	if (location == "middle")
	{
		level waittill("front_bunker");
		level notify ("player_comitted");
		//music_switcher ("BLITZ_KRIEG");

	}
	if (location == "right")
	{
		level notify ("player_comitted");	
	}

}

player_upstairs()
{
	level waittill ("player_upstairs");
	music_switcher("LAST_BUNKER_UPSTAIRS");

}


play_end_music()
{
	musicstop();
	wait(0.1);
	musicplay("MX_pel1_resolution");

}


player_fired_rockets()
{
	
}

start_igc_audio()
{
	//door_hydro = getent("audio_bunkerlocation_banzai", "targetname");
	
	door_hydro = getent("door", "targetname");
	ramp_location = getent("splash","targetname");
	
	level waittill ("lst door opening");
	door_hydro playsound("door_hydro");
	
	level waittill ("lst doors opened");
	ramp_location playsound("ramp_splash");
		
	level waittill("lvt_splash");
	ramp_location playsound("lvt_splash");
	
	activateAmbientPackage( "pel1_outdoors", 0 );
	activateAmbientRoom( "pel1_outdoors", 0 );
	
	wait (8.5);
	pa_fire = getent("audio_distant_battle_right","targetname");
	playsoundatposition("pa_fire", pa_fire.origin);
	
	wait(0.4);
	pa_fire_b = getent("audio_distant_battle_left","targetname");
	pa_fire_b playsound("pa_fire");

}

play_rocket_sound(rocket)
{

	//wait(RandomIntRange(2, 5));
	counter = RandomIntRange(1,2);
	if (counter == 1)
	{
		rocket playloopsound ("rocket_run");
	}
}

start_intro_planes_0()
{
	level waittill("spawnvehiclegroup0");
	wait(10);
	
	planes = getentarray("intro_plane1" ,"targetname");
	for (i = 0; i < planes.size; i++)
	{	
		planes[i] thread play_plane_sound();	
		
	}	

	planes = getentarray("intro_plane2" ,"targetname");
	for (i = 0; i < planes.size; i++)
	{	
		planes[i] thread play_plane_sound_special();	
		
	}	
	
}

start_intro_planes_8()
{
	level waittill("spawnvehiclegroup8");
	wait(10);
	planes = getentarray("intro_plane1" ,"targetname");
	
	for (i = 0; i < planes.size; i++)
	{	
		planes[i] thread play_plane_sound();	
		
	}	
	
}


start_intro_planes_21()
{
	level waittill("spawnvehiclegroup21");
	wait 1;
	planes = getentarray("buzz_by1" ,"targetname");
	
	for (i = 0; i < planes.size; i++)
	{	
		planes[i] thread play_plane_sound_short();	
		
	}	
	
}

start_intro_planes_9()
{
	level waittill("spawnvehiclegroup9");
	//level waittill("beached");
	wait(1.0);
	crashing_plane = getent("crashing_plane","targetname");	
	wait(5.0);
	crashing_plane playsound("plane_crashing");
	level thread play_plane_boom();

	
}
play_plane_boom()
{
	wait(7);
	plane_crash_origin = getent("plane_impact","targetname");
	wait(0.5);
	plane_crash_origin playsound("imp_plane");

}

play_plane_sound()
{
	if( IsDefined( self.script_delay ))
	{
		wait( self.script_delay + 5 );	
	}
	if( IsDefined( self.script_sound ))
	{
		self PlaySound( self.script_sound );
	}

}

play_plane_sound_short()
{
	if( IsDefined( self.script_delay ))
	{
		wait( self.script_delay );	
	}
	if( IsDefined( self.script_sound ))
	{
		self PlaySound( self.script_sound );
	}

}

play_plane_sound_special()
{
	if( IsDefined( self.script_delay ))
	{
		wait( self.script_delay + 10 );	
	}
	if( IsDefined( self.script_sound ))
	{
		self PlaySound( self.script_sound );
	}
}

play_distant_battle_sound()
{
	//wait until the LVT is beached---from start_intro_music()
	level waittill ("beached");
	
	sound_origin = getent("audio_distant_battle","targetname");
	sound_origin playloopsound("pel1_dst_btl"); 
	
	//wait until the rocket strike happens and shut down the distant battle audio	
	level waittill ("rockets red glare");
	sound_origin stoploopsound();
	
	
	//wait until the bunker is flamed and start it back up again.  Add the walla
	level waittill("flame guy is flaming bunker");
	
	firelocation = getent("audio_bunkerlocation_banzai", "targetname");
	firelocation playloopsound("bunker_fire");
	level thread stop_fire_sound_hack(firelocation);
	wait(5);
	//sound_origin playloopsound("pel1_dst_btl");	
	sound_origin2 = getent("audio_distant_walla","targetname");	
	
	wait (3);
	sound_origin2 playsound("distant_walla");
	
	wait (1);
	thread play_action_music();
	level thread turn_on_bc();
	
	
	level notify("battle_on");
	sound_origin stoploopsound();
	level thread bunker_voices();
	level thread bunker_footsteps();

}

play_action_music()
{
	musicplay("MX_evt_1");
	level.action_music_playing = 1;
	wait(130);
	level.action_music_playing = 0;

}

stop_fire_sound_hack(firesound)
{
	wait (35);
	firesound stoploopsound();	

}

turn_on_bc()
{
	ai = getaiarray("allies");
	if(isdefined (level.polo))
	{
		level.polo set_battlechatter(false);
	}

	if(isdefined (level.sarge))
	{
		level.sarge set_battlechatter(false);
	}

	if(isdefined (level.radioguy))
	{
		level.radioguy set_battlechatter(false);
	}
	
	wait(0.1);
	setdvar ("bcs_enable", "on");					
	battlechatter_on ("allies");
	
}
