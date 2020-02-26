#include maps\_utility;
#include maps\_distraction;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;















main()
{
	
	

	
	level thread global_rain();
	
	
	
	
	
	level thread stairs_bottom_of_stairs();
	
	
	level.basement = 0;
	level.newpatrol = 0;
	level.thug_count = 0;
	level.no_spawn = 0;
	
	
	
	
	level.alert_changed = false;
	level.had_conversation1 = false;
	level.had_conversation2 = false;
	level.catwalk2_door_open = false;
	
	thread door_open_stairwell();
	thread savegame_triggers();
	thread vo_start_tanner();
	
	thread helium_tank_setup();
	
	
	
	thread vent_access_door();
}








global_rain()
{
	level endon ( "end_rain" );
	while( 1 )
	{
		wait ( 0.5 );
		player_angle = level.player.angles[1];
		offset = anglestoforward( ( 0,  player_angle, 0 ) );
		offset = vectorscale( offset, 1500 );
		forwardrain = level.player.origin + offset;



		
	}
}



catwalk_anim_talk_01()
{
	
	while ( 1 )
	{
		wait( .5 );
		self CmdAction( "TalkA1", true );
		self waittill ( "cmd_done" );
		if (( self GetAlertState() != "alert_green" ) || ( level.newpatrol == 1 ))
		{
			self thread catwalk_wait_new_patrol_01();
			break;
		}
	}
}



catwalk_wait_new_patrol_01()
{
	self StartPatrolRoute ( "catwalk_stay_in_area" );
}



stop_talking()
{
	while ( 1 )
	{
		wait( .5 );
		if ( level.newpatrol == 1 )
		{
			self stopcmd();
			break;
		}
	}
}



catwalk_anim_talk_02()
{
	
	while ( 1 )
	{
		wait( .5 );
		self CmdAction( "TalkA2", true );
		self waittill ( "cmd_done" );
		if (( self GetAlertState() != "alert_green" ) || ( level.newpatrol == 1 ))
		{
			self thread catwalk_wait_new_patrol_02();
			break;
		}
	}
}



catwalk_wait_new_patrol_02()
{
	self StartPatrolRoute ( "catwalk_leave_area" );
}



catwalk_back_to_work()
{
	pos = self.origin + ( 0, 0,64 );
	color = ( 0, .5, 0 );            
	scale = 1.5;       
	Print3d( pos, "Hey, you two get back on patrol.", color, 1, scale, 200 );
	wait( 1 );
	level.newpatrol++;
	wait( 3 );
	if ( IsDefined( self ))
	{
		self StartPatrolRoute ( "catwalk_goto_next_area" );
	}
}



stop_commands()
{
	self stopcmd();
}



catwalk_setup_look_at_triggers()
{
	level thread catwalk_right_01();
	level thread catwalk_left_01();
	level thread catwalk_middle();
	level thread catwalk_middle_top();
	level thread catwalk_center();
}



catwalk_right_01()
{
	trigger = getent ( "catwalk_lower_thug_right_spawn", "targetname" );
	trigger waittill ( "trigger" );
	
	
	thug = getent ("catwalk_lower_thug_right_01", "targetname")  stalingradspawn( "thug" );
	thug waittill( "finished spawning" );
	wait ( 4 );
	thug = getent ("catwalk_lower_thug_right_02", "targetname")  stalingradspawn( "thug" );
	thug waittill( "finished spawning" );
}



catwalk_left_01()
{
	trigger = getent ( "catwalk_lower_thug_left_spawn", "targetname" );
	trigger waittill ( "trigger" );
	

	thug1 = getent ("catwalk_lower_thug_left_02", "targetname")  stalingradspawn( "thug1" );
	thug1 waittill( "finished spawning" );
	wait ( 4 );
	
	catwalk_thug = getentarray ( "catwalk_lower_thug_left_01", "targetname" );

	for ( i = 0; i < catwalk_thug.size; i++ )
	{
		thug[i] = catwalk_thug[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
		}
	}
}



catwalk_middle()
{
	trigger = getent ( "catwalk_lower_thug_middle_spawn", "targetname" );
	trigger waittill ( "trigger" );
	

	catwalk_thug = getentarray ( "catwalk_lower_thug_middle", "targetname" );

	for ( i = 0; i < catwalk_thug.size; i++ )
	{
		thug[i] = catwalk_thug[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
		}
	}
}



catwalk_middle_top()
{
	trigger = getent ( "catwalk_lower_thug_middle_top_spawn", "targetname" );
	trigger waittill ( "trigger" );
	

	catwalk_thug = getentarray ( "catwalk_lower_thug_middle_top", "targetname" );

	for ( i = 0; i < catwalk_thug.size; i++ )
	{
		thug[i] = catwalk_thug[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
		}
	}
}



catwalk_center()
{
	trigger = getent ( "catwalk_lower_thug_center_spawn", "targetname" );
	trigger waittill ( "trigger" );
	

	catwalk_thug = getentarray ( "catwalk_lower_thug_center_01", "targetname" );

	for ( i = 0; i < catwalk_thug.size; i++ )
	{
		thug[i] = catwalk_thug[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
		}
	}
}



catwalk_lower_kill_amb_thugs()
{
	if (( isdefined ( self )) && ( level.basement == 1 ))
	{
		wait ( .5 );
		self delete();
	}
}




catwalk_command_node_01()
{
	self CmdAction( "fidget" );
	pos = self.origin + ( 0, 0,64 );
	color = ( 0, .5, 0 );            
	scale = 1.5;       
	Print3d( pos, "COMMAND_NODE_PLAYING", color, 1, scale, 15 );
}



catwalk_long_section()
{
	trigger = getent ( "catwalk_longway", "targetname" );
	trigger waittill ( "trigger" );

	level thread catwalk_thug_who_die();

	catwalk_thug = getentarray ( "catwalk_thug_02", "targetname" );

	for ( i = 0; i < catwalk_thug.size; i++ )
	{
		thug[i] = catwalk_thug[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] thread catwalk_thug_counter();
		}
	}
	level thread catwalk_thug_count_func();
	level thread catwalk_extra_thug_trigger();
	if ( level.debug_text == 1 )
	{
		
	}
}




catwalk_thug_counter()
{
	self waittill ( "death" );
	level.thug_count++;
}



catwalk_thug_count_func()
{
	new_catwalk_thug = getentarray ( "new_catwalk_thug", "targetname" );

	level endon ( "thug_no_spawn" );
	while ( .5 )
	{
		wait ( .5 );
		if (( level.thug_count >= 4 ) && ( level.no_spawn == 0 ))
		{
			for ( i = 0; i < new_catwalk_thug.size; i++ )
			{
				thug[i] = new_catwalk_thug[i] stalingradspawn();
				if( !maps\_utility::spawn_failed( thug[i]) )
				{
				}
			}
		}
	}
}



catwalk_extra_thug_trigger()
{
	trigger = GetEnt( "catwalk_no_spawn_trigger", "targetname" );
	trigger waittill ( "trigger" );
	level.no_spawn++;
	if ( level.debug_text == 1 )
	{
		
	}
}



catwalk_thug_who_die()
{
	catwalk_thug = getentarray ( "catwalk_light_fall_on_thugs", "targetname" );

	for ( i = 0; i < catwalk_thug.size; i++ )
	{
		thug[i] = catwalk_thug[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] thread catwalk_death_from_above();
			thug[i] lockalertstate( "alert_green" );
		}
	}
}



catwalk_death_from_above()
{
	org = getent ( "damage_point", "targetname" );
	level waittill ( "from_above" );
	radiusdamage ( org.origin, 150, 200, 200 );
}



catwalk_stairs_talk_01()
{
	wait ( 7 );
	
	if ( isdefined ( self ))
	{
		self stoppatrolroute();
		wait ( .5 );
		self startpatrolroute ( "catwalk_gen_node_01" );
	}
}



catwalk_stairs_setup_talk()
{
}



catwalk_stairs_talk_02()
{
	
}



catwalky_loop_talkA2_anim()
{
	self endon ( "death" );
	while ( 1 )
	{
		wait( .5 );
		if (( isdefined ( self )) && ( isalive ( self )))
		{
			
			self CmdAction( "TalkA2", true );
			self waittill ( "cmd_done" );
			wait( 6 );
			
		}
	}
}



catwalky_loop_talkA1_anim()
{
	self endon ( "death" );
	while ( 1 )
	{
		wait( .5 );
		if (( isdefined ( self )) && ( isalive ( self )))
		{
			
			self CmdAction( "TalkA1", true );
			self waittill ( "cmd_done" );
			wait( 6 );
			
		}
	}
}



stairs_top_of_stairs()
{
	trigger = getent ( "stairs_begin", "targetname" );
	trigger waittill ( "trigger" );
	
	level thread stairs_light_flicker();
}





stairs_path_center()
{
	level notify ( "end_rain" );

	level thread maps\sciencecenter_b::delete_all_ai();

	GetNode("bottom_of_rope_door", "script_noteworthy") maps\_doors::open_door();
	
	
	thread start_doorguy_moving();

	wait( .25 );
	 
	org = getent("origin_rope", "targetname");
	
	level.player SetOrigin(org.origin);
	level thread player_link(org);
	
	
	
	
	

	
	level.player disableWeapons();
	
	
	level.player playsound("rope_grab");
	level.player playsound("bond_xrt_grunt");
	
	wait(0.5);
	
	
	level.player playloopsound("rope_slide", 0.5);
	
	
	
	
	org movez ( -824, 3.0, 2.5 , 0.3 );
	


	
	org waittill ( "movedone" );
	
	
	
	level.player stoploopsound(0.2);

	
	level notify("reached_bottom_of_rope");
	level.player unlink();
	
	level.player playsound("bond_xrt_grunt");

	
	
	

	wait 2;

	
	level.player enableWeapons();
}


start_doorguy_moving()
{
	spawner = getent("guard_art_room", "targetname");
	g = spawner stalingradspawn("guard_artroom");
	if (!spawn_failed(g))
	{
		g SetEnableSense(false);
		door = GetEntArray("auto2652", "targetname");
		g thread enable_sense_for_basement_guy(door[0]);
	}
}	
enable_sense_for_basement_guy(door)
{
	self endon("death");
	door waittill("closed");
	self SetEnableSense(true);
}

player_link(org)
{
	level endon("reached_bottom_of_rope");

	right_arc = 40;
	left_arc = 40;
	top_arc = 40;
	bottom_arc = 40;

	level.player SetPlayerAngles((45, 315, 0));
	level.player PlayerLinkToDelta(org, undefined, 0, right_arc, left_arc, top_arc, bottom_arc);

	wait 4;
	while (true)
	{
		if (right_arc > 0)
		{
			right_arc--;
		}

		if (left_arc > 0)
		{
			left_arc--;
		}

		if (top_arc > 0)
		{
			top_arc--;
		}

		if (bottom_arc > 0)
		{
			bottom_arc--;
		}

		level.player PlayerLinkToDelta(org, undefined, 0, right_arc, left_arc, top_arc, bottom_arc);
		wait .05;
	}
}




stairs_rain()
{	
	
	playfx ( level._effect["rain8"], self.origin );
	
}




stairs_set_time_scale()
{
	wait( 3.5 );
	SetSavedDVar( "timescale", ".35" );
	wait( 3 );
	SetSavedDVar( "timescale", "1" );
}




stairs_light_flicker()
{
	light = getent ( "light_stair", "targetname" );
	
	level endon ( "kill_stair_light" );
	while ( 1 )
	{
		wait ( .1 );
		
		light setlightintensity ( 0 );
		wait( .05 + randomfloat( .1 ) );

		j = randomint( 20 );
		if ( j < 1 )
		{
			wait( 1 );
		}

		
		light setlightintensity ( 1 );
		wait( .05 + randomfloat( .1) );
	}
}



stairs_bottom_of_stairs()
{
	trigger = getent ( "stairs_end", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "basement" );
	
	

	GetNode("locked_basement_door", "script_noteworthy") maps\_doors::close_door_from_door_node();
	

}




savegame_triggers()
{	
	trigger = getent("trigger_savegame_catwalk1", "targetname");
	trigger waittill("trigger");

	flag_set("reached_stairwell");
		
		level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	
	
	
	
	trigger_obj_01 = getent("trigger_reached_maincatwalk", "targetname");
	trigger_obj_01 waittill("trigger");
	
	level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	
	trigger = getent("trigger_savegame_catwalk2", "targetname");
	trigger waittill("trigger");
	
	level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	
	trigger = getent("trigger_savegame_rope", "targetname");
	trigger waittill("trigger");
	

	
	
	
	
	thread initiate_rope_slide();
}






map_level_1to2()
{
	trigger = getent("trigger_map_1to2", "targetname");
	trigger waittill("trigger");
	
	setSavedDvar("sf_compassmaplevel",  "level2");
	
	thread map_level_2to1();
	thread map_level_2to3();
}


map_level_2to1()
{
	trigger = getent("trigger_map_2to1", "targetname");
	trigger waittill("trigger");
	
	setSavedDvar("sf_compassmaplevel",  "level1");
	
	thread map_level_1to2();
}


map_level_2to3()
{
	trigger = getent("trigger_map_2to3", "targetname");
	trigger waittill("trigger");
	
	setSavedDvar("sf_compassmaplevel",  "level3");
	
	thread map_level_3to2();
	thread map_level_3to4();
}


map_level_3to2()
{
	trigger = getent("trigger_map_3to2", "targetname");
	trigger waittill("trigger");
	
	setSavedDvar("sf_compassmaplevel",  "level2");
	
	thread map_level_2to3();
}


map_level_3to4()
{
	trigger = getent("trigger_map_3to4", "targetname");
	trigger waittill("trigger");
	
	setSavedDvar("sf_compassmaplevel",  "level4");
	
	thread map_level_4to5();
}


map_level_4to5()
{
	trigger = getent("trigger_map_4to5", "targetname");
	trigger waittill("trigger");

	
	
	
	

	
	setSavedDvar("sf_compassmaplevel",  "level5");
	
	thread map_level_5to6();
}


map_level_5to6()
{
	trigger = getent("trigger_map_5to6", "targetname");
	trigger waittill("trigger");
	
	setSavedDvar("sf_compassmaplevel",  "level6");
	
	thread map_level_6to5();
}


map_level_6to5()
{
	trigger = getent("trigger_map_6to5", "targetname");
	trigger waittill("trigger");
	
	setSavedDvar("sf_compassmaplevel",  "level5");
	
	thread map_level_5to6();
}






setup_thug_overrail() 
{	
	
	

	self endon("death");
	self endon("alert_yellow");

	self thread check_thug_alert();
	
	
	self thread check_for_red_alert();
	self StopPatrolRoute();
	
	self play_dialogue("SSTM_SciBG02A_002A", false);	
	wait(0.5);
	
	self cmdaction("CheckEarpiece", true);
	
	self play_dialogue("SCS1_SciBG02A_003A", true);	
	wait(0.5);
	
	self play_dialogue("SSTM_SciBG02A_004A", false);	
	wait(0.05);
	
	self cmdaction("CheckWatch", true);
	wait(0.05);

	while (true)
	{
		self CmdAction("fidget", true);
		self waittill("cmd_done");
		self stopallcmds();
		
		wait(5.0);

		self CmdAction("LookBehind", true, 4);
		wait 6;
	}
}
check_for_red_alert()
{
	while(1)
	{
		if(IsAlive(self))
		{
			if(self GetAlertState() == "alert_red")
			{
				
				self setperfectsense(true);
			}
		}
		wait(0.05);
	}
}


check_thug_alert()
{
	while(!level.alert_changed)
	{
		if (IsAlive(self))
		{
			if (self GetAlertState() != "alert_green")
			{
				level.alert_changed = true;
			}
		}
		
		wait(0.1);
	}
}





vo_start_tanner()
{
	wait(1.0);
	level.player play_dialogue("TANN_SciBG02A_001A", true);	
}






patrol_pause_stairwell()
{
	if (isdefined(self))
	{
		self pausepatrolroute();
	}
	
	level waittill("resumepatrol");
	
	if (isdefined(self))
	{
		self resumepatrolroute();
	}
}






patrol_stop_stairwell()
{
	while(isalive(self))
	{
		self CmdAction("fidget", true);
		
		wait(10.0);
	}
}






door_open_stairwell()
{	
	trigger = getent("trigger_open_door", "targetname");
	trigger waittill("trigger");
	
	spawner = getent("spawner_thug_overrail", "targetname");
	spawner stalingradspawn("thug_overrail");
	
	
	
	
	
	thread door_close_stairwell();
	
	
	setSavedDvar("sf_compassmaplevel",  "level1");
	thread map_level_1to2();
}






door_close_stairwell()
{
	door_stairwell = getent("door_first_stairwell", "targetname");
	trigger = getent("trigger_lookat_door", "targetname");
	
	trigger waittill("trigger");
	
	level notify("resumepatrol");
	
	wait(0.25);
	
	
}




start_catwalk1_patrol()
{
	spawner01 = getent("guard_01_spawner", "targetname");
	if (IsDefined(spawner01))
	{
		spawner01 stalingradspawn("guard_01");
	}
	else
	{
		return;	
	}

	spawner02 = getent("guard_02_spawner", "targetname");
	if (IsDefined(spawner02))
	{
		spawner02 stalingradspawn("guard_02");
	}
	
	thread door_catwalk2_right();
	thread door_catwalk2_left();
	thread check_catwalk2_reached();

	GetEnt("player_in_catwalk1a", "targetname") thread catwalk1_elites_a();
	GetEnt("player_in_catwalk1b", "targetname") thread catwalk1_elites_b();
}

catwalk1_elites_a()
{
	while (true)
	{
		self waittill("trigger");

		
		
		
		
		

		elites_on = GetEntArray("catwalk1_elites_b", "script_noteworthy");
		for (i = 0; i < elites_on.size; i++)
		{
			elites_on[i].count = 1;
		}
	}
}

catwalk1_elites_b()
{
	while (true)
	{
		self waittill("trigger");

		elites_off = GetEntArray("catwalk1_elites_b", "script_noteworthy");
		for (i = 0; i < elites_off.size; i++)
		{
			elites_off[i].count = 0;
		}

		
		
		
		
		
	}
}

catwalk1()
{
	flag_init("do_catwalk1_vo");
	self waittill("trigger");

	flag_set("do_catwalk1_vo");
	thread maps\miami_science_center_catwalk::start_catwalk1_patrol();
}






check_catwalk2_reached()
{
	trigger = getent("trigger_catwalk2_reached", "targetname");
	trigger waittill("trigger");
		
	thread vo_catwalk2();
}





catwalk_talk_01()
{
	if (!flag("do_catwalk1_vo"))
	{
		return;
	}

	guard2 = GetEnt("guard_02", "targetname");

	guard2 endon("death");
	level endon("catwalk1_alert");

	if (!IsDefined(guard2.at_talk_node) || !guard2.at_talk_node)
	{
		guard2 waittill("at_talk_node");
	}

	if (!flag("catwalk1_alert") && isalive(guard2))
	{
		self play_dialogue("SCM1_SciBG02A_005A", true);	
	}
}

catwalk_talk_02()
{
	if (!flag("do_catwalk1_vo"))
	{
		return;
	}

	self.at_talk_node = true;
	self notify("at_talk_node");

	guard1 = GetEnt("guard_01", "targetname");
	guard1 endon("death");

	wait(2.0);

	if (!flag("catwalk1_alert") && isalive(guard1))
	{
		self play_dialogue("SCM2_SciBG02A_006A", true);	
	}

	flag_clear("do_catwalk1_vo");
}





vo_catwalk2()
{
	level.player play_dialogue("SCS1_SciBG02A_007A", true);		
	
	wait(1.5);
	
	level.player play_dialogue("SCS1_SciBG02A_008A", true);		
	
	wait(0.5);
	
	while(!(level.catwalk2_door_open))
	{
		wait(0.1);
	}
	
	level.player play_dialogue("SSAL_SciBG02A_009A", true);		
	
	wait(0.5);
	
	level.player play_dialogue("SSAL_SciBG02A_010A", true);		
	
	wait(0.5);
	
	level.player play_dialogue("SCS1_SciBG02A_011A", true);		
}


catwalk_pause_01()
{
	self endon("alert_red");

	wait(1.0);
	
	self StopPatrolRoute();
	
	while (isalive(self))
	{
		if (isalive( self ))
		{
			self CmdAction("fidget", true);
			self waittill ( "cmd_done" );
		}
		
		wait(9.0);
	}
}



catwalk_pause_02()
{
	self endon("death");
	self endon("alert_red");

	wait 1;

	self PausePatrolRoute();

	wait 2;

	self CmdAction("fidget", true);
	self waittill("cmd_done");

	wait 2;

	self StopAllCmds();
	self ResumePatrolRoute();
}

catwalk_pause_03()
{
	self endon("death");

	wait 1;

	self PausePatrolRoute();

	wait 3;

	self CmdAction("fidget", true);
	self waittill("cmd_done");

	self ResumePatrolRoute();
}






door_catwalk2_left()
{
	door_left = getent("door_catwalk_left", "targetname");
	
	door_left waittill("opening");
	
	if (!(level.catwalk2_door_open))
	{
		thread spawn_catwalk2_patrol();
		level.catwalk2_door_open = true;
	}
}



door_catwalk2_right()
{
	door_right = getent("door_catwalk_right", "targetname");
	
	door_right waittill("opening");
	
	if (!(level.catwalk2_door_open))
	{
		thread spawn_catwalk2_patrol();
		level.catwalk2_door_open = true;
	}
}






















helium_tank_setup()
{
    tank = GetEntArray ( "exploding_tank", "targetname" );
    for ( i = 0; i<tank.size; i++ )
    {
		tank[i].health = 150;
		tank[i] thread physic_tank_radius();
    }
}



physic_tank_radius()
{
	self setcandamage(true);
	self waittill ( "damage" );
	self playsound("Vehicle_Explosion_01");	;
	self hide();
	wait( .1 );
	fx = playfx (level._effect["elev_expl"], self.origin);
	
	radiusdamage( self.origin + ( 0, 0, 36 ), 100, 200, 200 );
	earthquake( 0.3, 1, self.origin, 400 );
}





	



spawn_catwalk2_patrol()
{
	spawnarray = getentarray("catwalk2_thug", "targetname");
	
	for (i=0; i<spawnarray.size; i++)
	{
		spawnarray[i] = spawnarray[i] stalingradspawn("guard_catwalk2");
	}
	
	thread spawn_catwalk2_backup();
	
	wait(1.5);
	level notify("playmusicpackage_catwalk");

}






spawn_catwalk2_backup()
{
	trigger = getent("trigger_spawn_backup", "targetname");
	trigger waittill("trigger");
	
	level.door_node_right = getnode("auto2513", "targetname");
	level.door_node_left = getnode("auto2515", "targetname");
	
	level.door_node_right maps\_doors::open_door();
	level.door_node_left maps\_doors::open_door();
	
	spawner5 = getent ("catwalk2_thug_05", "targetname");
	spawner5 stalingradspawn("guard_05");
	
	spawner6 = getent ("catwalk2_thug_06", "targetname");
	spawner6 stalingradspawn("guard_06");
	
	spawner9 = getent ("catwalk2_thug_09", "targetname");
	spawner9 stalingradspawn("guard_09");
		
	
	
	
	
	
		
	thread spawn_catwalk2_final();
}






spawn_catwalk2_final()
{
	trigger = getent("catwalk2_guard_final", "targetname");
	trigger waittill("trigger");
	
	door_right = getent("door_pipe_right", "targetname");
	door_left = getent("door_pipe_left", "targetname");
	
	door_right maps\_doors::close_door();
	door_left maps\_doors::close_door();
	
	guardarray = getentarray("final_catwalk_guards", "targetname");
	
	for(i = 0; i < guardarray.size; i++)
	{
		guardarray[i] = guardarray[i] stalingradspawn("guard_final");
		if(isdefined(guardarray[i]))
		{
			guardarray[i] setperfectsense(true);
			guardarray[i] tether_at_goal(5.0);
		}
	}
	
	thread spawn_balance_mainhall();
	
	
	
	thread catwalk_guards_dead();
}
tether_at_goal(radius)
{
	self waittill("goal");

	self settetherradius(radius);
}





steam_balance_beam()
{
	steam_tag = getent("tag_steam_balance", "targetname");
	
	playfxontag( level._effect[ "steam_small" ], steam_tag, "tag_origin" );
	
	level waittill ( "basement" );
	
	steam_tag delete();
}






spawn_balance_mainhall()
{
	
	SetSavedDVar("bal_move_speed", 65.0);
	SetSavedDVar("bal_wobble_accel", 1.035);
	SetSavedDVar("bal_wobble_decel", 1.06);
	
	trigger = getent("trigger_balance_mainhall", "targetname");
	trigger waittill("trigger");
	
	
	
	
	
	node_balance = getnode("node_balance", "targetname");
	
	array = getentarray("guard_mainhall_balance", "targetname");
	
	for (i=0; i<array.size; i++)
	{
		array[i] = array[i] stalingradspawn("guard_balance_mainhall");
		array[i] setgoalnode(node_balance);
		array[i] thread die_at_marker();
		array[1] thread yell_above();
	}
	
	guard = getent("guard_mainhall_balancelast", "targetname");
	
	thug = guard stalingradspawn("guard_die");
	thug setgoalnode(node_balance);
	
	wait(2.7);
	
	dynEnt_StartPhysics("catwalk_light_balance");
	
	wait(5.0);
	
	
	
	level.player play_dialogue("TANN_SciBG02A_012A", true);	
	
	for (j=0; j<array.size; j++)
	{
		if (isalive(array[j]))
		{
			array[j] waittill("goal");
			array[j] delete();
		}
	}
}

yell_above()
{
	self play_dialogue("SAM_E_1_McGS_Cmb", true);	
	wait(1.1);
	self play_dialogue("SAM_E_1_Flan_Cmb", true);	
	wait(1.3);
	self play_dialogue("SAM_E_4_Flan_Cmb", true);	
}

die_at_marker()
{
	self waittill("goal");
	self delete();
}







show_ceiling()
{
	trigger = getent("trigger_spawn_balance", "targetname");
	trigger waittill("trigger");
	
	level.ceiling_balance show();
}






delete_mainhall_runners()
{
	self delete();
}






catwalk_guards_dead()
{
	alldead = false;
	
	while( !(alldead) )
	{
		guards = getaiarray("axis", "neutral");
		
		if ( !(guards.size) &&  !isanyaidying("axis", "neutral") )
		{
			level notify("endmusicpackage");
			alldead = true;
			
			
			level thread maps\_autosave::autosave_now("MiamiScienceCenter");
		}
		
		wait(0.5);
	}
}
			





access_door(origin)
{
	doorarray = getentarray("vent_access_door", "targetname");
	wheelarray = getentarray("vent_access_wheels", "targetname");
	dooraccess = getent("vent_access_main", "targetname");
	
	
	level.vent_door PlaySound("metal_hatch_slide");
	
	level.vent_door movey(70, 2.0);
	
	for (i=0; i<doorarray.size; i++)
	{
		doorarray[i] movey(70, 2.0);
	}
	
	for (j=0; j<wheelarray.size; j++)
	{
		wheelarray[j] movey(70, 2.0);
	}
	level notify("remove_vent_fx");
}






vent_access_door()
{
	level.vent_door = getent("vent_access_main", "targetname");
	
	maps\_playerawareness::setupEntSingleUseOnly(
		level.vent_door, 
		::access_door, 
		&"HINT_OPEN_VENT",
		0, 
		"", 
		true, 
		true, 
		undefined, 
		undefined, 
		true, 
		false, 
		true);
}






initiate_rope_slide()
{	
	level notify("endmusicpackage");
	
	
	
	
	
	VisionSetNaked( "sciencecenter_b_03", 2);
	
	trigger = getent("trigger_rope_slide", "targetname");
	trigger sethintstring(&"HINT_ROPE_SLIDE");
	trigger waittill("trigger");
	
	thread stairs_path_center();
	
	wait(2.0);
	
	level notify("musicstinger_rope");
}
