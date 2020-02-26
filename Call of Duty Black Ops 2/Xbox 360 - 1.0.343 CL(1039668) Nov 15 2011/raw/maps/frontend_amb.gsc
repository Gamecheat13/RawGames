//
// file: frontend_amb.gsc
// description: level ambience script for frontend
// scripter: 
//
#include maps\_music;
#include maps\_utility;
#include common_scripts\utility; 


main()
{
	//level thread set_start_music_state();
//	level thread audio_init();

	level thread zombie_screen_watcher();
	
	
}
zombie_screen_watcher()
{
	
	if(!IsDefined (level.zombie_music_on))
	{
		level.zombie_music_on = 0;
	}
	if(!IsDefined (level.zombie_screen_visited))
	{
		level.zombie_screen_visited = 0;
	}
	wait(2);
	while(1)
	{
		while(!flag("in_zombie_menu"))
		{
			level.zombie_music_on = 0;
			wait(0.1);
			if (level.zombie_screen_visited == 1)
			{
				playsoundatposition ("evt_zombie_transition_out", (0,0,0));
				level.zombie_screen_visited = 0;				
			}
			
		}
		if(level.zombie_music_on == 0)
		{
			playsoundatposition ("evt_zombie_transition", (0,0,0));
			setmusicstate ("ZOMBIE_TIME");
			level.zombie_music_on = 1;
			level.splash_watcher = 0;
			level.zombie_screen_visited = 1;					
		}	

		wait(0.1);	
		
	}
	
}
interrogation_room_watcher()
{
	
	if(!IsDefined (level.splash_watcher))
	{
		level.splash_watcher = 0;
	}
	if(!IsDefined (level.snapshot_set))
	{
		level.snapshot_set = 0;
	}
	if(!IsDefined (level.zombie_music_on))
	{
		level.zombie_music_on = 0;
		
	}
	if(!IsDefined (level.firstplay))
	{
		level.firstplay = 0;
		
	}
	while(1)
	{
		while(flag("at_splash_screen"))
		{
			level notify ("kill_interrogation_room");

			if(level.snapshot_set == 0)
			{
				clientNotify ("ts");
				level.snapshot_set = 1;
			}

			setmusicstate ("TITLE_SCREEN");
			level.firstplay = 0;
			level.splash_watcher = 0;
			wait(0.1);
		}
		if(level.splash_watcher == 0 && level.zombie_music_on == 0)
		{
			if(level.zombie_music_on == 0)
			{
				setmusicstate ("INT_UNDERSCORE");
				if(level.zombie_screen_visited == 0)
				{
					playsoundatposition ("evt_start_button", (0,0,0));	
					
				}
			}
			clientNotify ("nts");
			level.snapshot_set = 0;
			level thread event_heart_beat( "relaxed" );
			level.splash_watcher = 1;
			
			if(level.firstplay == 0)
			{
				level thread sound_category_init();
				level.firstplay = 1;
			}
			
		}
		wait(0.1);		
	}	
	
}
sound_category_init()
{
	level.welcome = "vox_int_back";
	level.taunt = "vox_int_taunt";
	level.menu = "vox_int_menu" ;	// CHange to specific menu's later
	level.current_heart_waittime = 2;
	level.heart_waittime = 2;
	level.current_breathing_waittime = 4;
	level.breathing_waittime = 4;
	
	//Kick off Mason body sounds once we define the var's initially	
	thread play_heart_beat();
	thread play_breathing_aparatus();
	
}

event_heart_beat( emotion )
{	
	// Emotional State of Player
	// sedated (super slow heartbeat )
	// relaxed ( normal heart beat )
	// stressed (fast heartbeat)
	switch (emotion)	
	{
		case "sedated":
			level.heart_waittime = 3;
			level.breathing_waittime = 4;
			break;
		case "relaxed":
			level.heart_waittime = 2;
			level.breathing_waittime = 4;			
			break;
		case "stressed":
		level.heart_waittime = 0.75;
		level.breathing_waittime = 3;
		break;	
		default: AssertMsg("Not a Valid Emotional State.  Please switch with sedated, relaxed, happy, stressed");
	}
	thread heartbeat_state_transitions();  //(controls the wait between breaths and beats
		
}
play_heart_beat ()
{
	level endon ("kill_interrogation_room");
	player = getplayers();
	level.player = player;
	if(!IsDefined ( level.heart_wait_counter) )
	{
		level.heart_wait_counter = 0;	
	}
	while( 1 )  
	{
		while( level.heart_wait_counter < level.current_heart_waittime)
		{
			wait(0.1);
			level.heart_wait_counter = level.heart_wait_counter +0.1;
		}
		
		playsoundatposition ("amb_player_heartbeat", (0,0,0));
		playsoundatposition ("amb_player_heartmonitor", (104, 480, 48));
		player[0] shellshock("int_escape", 0.25);
		level.heart_wait_counter = 0;		
	}	
	
}
play_breathing_aparatus()
{
	
	level endon ("kill_interrogation_room");
	
	if(!IsDefined ( level.breathing_wait_counter) )
	{
		level.breathing_wait_counter = 0;	
	}
	for(;;)  
	{
		while( level.breathing_wait_counter < level.current_breathing_waittime)
		{
			wait(0.1);
			level.breathing_wait_counter = level.breathing_wait_counter +0.1;
		}
		playsoundatposition ("amb_breathing_aparatus_scripted", (107, 486.5, 55));
		level.breathing_wait_counter = 0;	
	}
}
heartbeat_state_transitions()
{
	level endon ("kill_interrogation_room");
	
	if(!IsDefined (level.heart_waittime))
	{
		level.heart_waittime = 2;		
	}	
	if(!IsDefined (level.current_heart_waittime))
	{
		level.current_heart_waittime = 2;		
	}	
	while (level.current_heart_waittime > level.heart_waittime)
	{
		//iprintlnbold ("current: " + level.current_heart_waittime + "goal: "  + level.heart_waittime);
		level.current_heart_waittime = level.current_heart_waittime - .05;
		wait(.10);	
		
	}
	while (level.current_heart_waittime < level.heart_waittime)
	{
		//iprintlnbold ("current: " + level.current_heart_waittime + "goal: "  + level.heart_waittime);
		level.current_heart_waittime = level.current_heart_waittime + .05;
		wait(.30);	
	}	
	level.current_heart_waittime = level.heart_waittime;
}
/*
state_change_tester(  )
{
	while (1)
	{
		wait (20);
		iprintlnbold ("changing state to: stressed"  );
		thread event_heart_beat ( "stressed");
		wait(20);
		iprintlnbold ("changing state to: sedated"  );
		event_heart_beat ( "sedated");
		wait(20);
		iprintlnbold ("changing state to: relaxed"  );
		event_heart_beat ( "relaxed");
	}
}
*/