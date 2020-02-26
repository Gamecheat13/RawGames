//
// file: pow_amb.gsc
// description: level ambience script for pow
// scripter: 
//
#include maps\_utility;
#include common_scripts\utility;
#include maps\_ambientpackage;
#include maps\_music;

main()
{

	//************************************************************************************************
	//                                      THREAD FUNCTIONS
	//************************************************************************************************	

	array_thread(GetEntArray("amb_generator", "targetname"), ::generator_damage);
	array_thread(GetEntArray("amb_generator_origin", "targetname"), ::generator_loop);	
	
	array_thread(GetEntArray("amb_radio", "targetname"), ::radio_loop);
	array_thread(GetEntArray("amb_radio", "targetname"), ::radio_damage);
	
	level thread heartbeat_init();
	
}


//************************************************************************************************
//                                      DAMAGE TRIGGERS WITH LOOPERS
//************************************************************************************************		
	
	
//************ generators ************

generator_loop()
{
	self playloopsound ("amb_generator");
	level waittill ("generator_off");
	self stoploopsound();	
}	
	
generator_damage()
{
	self waittill ("trigger");
	level notify ("generator_off");
}

//************ radios ************

radio_loop()
{

	self playloopsound ("amb_radio_01");

}	

	
radio_damage()
{

	self waittill ("trigger");
	self stoploopsound();	
}
heartbeat_init()
{
	level.current_heart_waittime = 2;
	level.heart_waittime = 2;
	level.current_breathing_waittime = 4;
	level.breathing_waittime = 4;
	level.emotional_state_system = 0;

}

event_heart_beat( emotion, loudness )
{	
	
	// Emotional State of Player
	// sedated (super slow heartbeat )
	// relaxed ( normal heart beat )
	// stressed (fast heartbeat)
	
//	iprintlnbold (emotion );
	level.current_emotion = emotion;
	if(!IsDefined (level.last_emotion))
	{
		level.last_emotion = "undefined";		
	}
	if( level.current_emotion != level.last_emotion)
	{	
		if(level.emotional_state_system == 0)
		{
			level.emotional_state_system = 1;
			level thread play_heart_beat();
			level thread play_breathing();
			
		}
		if(!IsDefined (loudness) || (loudness == 0))
		{
			level.loudness = 0;	
		}	
		else
		{
			level.loudness = loudness;	
			
		}
		
		if(!IsDefined(level.rumble_heart))
		{
			level.rumble_heart = "heartbeat_low";
		}
		
		switch (emotion)	
		{
			case "sedated":
				level.heart_waittime = 3;
				level.breathing_waittime = 4;
				level.last_emotion = "sedated";	
				level.rumble_heart = "heartbeat_low";			
				break;
				
			case "relaxed":
				level.heart_waittime = 1.5;
				level.breathing_waittime = 4;
				level.last_emotion = "relaxed";	
				level.rumble_heart = "heartbeat_low";
				break;
				
			case "stressed":
				level.heart_waittime = 0.7;
				level.breathing_waittime = 2;
				level.last_emotion = "stressed";
				level.rumble_heart = "heartbeat_low";
				break;
				
			case "panicked":
				level.heart_waittime = 0.25;
				level.breathing_waittime = 1.5;
				level.last_emotion = "panicked";
				level.rumble_heart = "heartbeat";
				break;
				
			case "none":
				level.last_emotion = "none";
				level notify ("no_more_heartbeat");	
				playsoundatposition ("vox_breath_scared_stop", (0,0,0));
				level.emotional_state_system = 0;				
				break;
			
			default: AssertMsg("Not a Valid Emotional State.  Please switch with sedated, relaxed, happy, stressed, or none");
		}
		thread heartbeat_state_transitions();  //(controls the wait between breaths and beats
	}
		
}
heartbeat_state_transitions()
{
	while (level.current_heart_waittime > level.heart_waittime)
	{
		//iprintlnbold ("current: " + level.current_heart_waittime + "goal: "  + level.heart_waittime);
		level.current_heart_waittime = level.current_heart_waittime - .10;
		wait(.10);	
		
	}
	while (level.current_heart_waittime < level.heart_waittime)
	{
		//iprintlnbold ("current: " + level.current_heart_waittime + "goal: "  + level.heart_waittime);
		level.current_heart_waittime = level.current_heart_waittime + .05;
		wait(.10);	
	}	
	level.current_heart_waittime = level.heart_waittime;
}
play_heart_beat ()
{
	level notify("only_one_heartbeat");
	level endon("only_one_heartbeat");
	
	player = getplayers()[0];
	level endon ("no_more_heartbeat");
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
		
		if (level.loudness == 0)
		{
			playsoundatposition ("amb_player_heartbeat", (0,0,0));	
		}
		else
		{
			playsoundatposition ("amb_player_heartbeat_loud", (0,0,0));	
		}
		
		player PlayRumbleOnEntity("heartbeat");	
		level.heart_wait_counter = 0;
		
	}	
	
}
play_breathing()
{
	level endon ("no_more_heartbeat");	
	
	if(!IsDefined ( level.breathing_wait_counter) )
	{
		level.breathing_wait_counter = 0;	
	}
	for(;;)  
	{
		while( level.breathing_wait_counter < level.current_breathing_waittime )
		{
			wait(0.1);
			level.breathing_wait_counter = level.breathing_wait_counter +0.1;
		}
		playsoundatposition ("amb_player_breath_cold", (0,0,0));
		level.breathing_wait_counter = 0;	
	}
}
heartbeat_controller_intro()
{
	//wait(30);
	level waittill("at_roullete_table");
	level thread maps\pow_amb::event_heart_beat("relaxed");
	level waittill("hb_bowman_spit");
	level thread maps\pow_amb::event_heart_beat("stressed");
	level waittill("hb_bowman_hit");
	level thread maps\pow_amb::event_heart_beat("panicked");
	level waittill("woods_at_table");
	level thread maps\pow_amb::event_heart_beat("stressed");
	level waittill("hb_gun_at_head");
	level thread maps\pow_amb::event_heart_beat("panicked");
	level waittill("kill_heart");
	level thread maps\pow_amb::event_heart_beat("none");
}