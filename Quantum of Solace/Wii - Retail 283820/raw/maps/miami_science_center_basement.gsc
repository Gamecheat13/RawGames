#include maps\_utility;
#include maps\_distraction;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;















main()
{
	level waittill ( "basement" );
	
	
	

	
	
	
	

	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	

	
	level thread basement_camera_01();
	
	
	
	
	
	
	
	
	
	
	level.alert_status_artroom = 0;
	level.spawned_security_monitors = false;
	level.monitors_alerted = false;
	level.guard_office_alerted = false;
	
	thread spawn_artroom();
}









basement_camera_01()
{
	trigger = getent ( "section_one_thug_trigger", "targetname" );
	trigger waittill ( "trigger" );
	
	
	flag_set("reached_basement");

	
	setExpFog(0,435,0.29,0.304,0.304, 2.0);
	
	level.player play_dialogue("TANN_SciBG02A_016A", true);	
	
	
	

	
	
	

	
	
	
	
	
	
	

	
	
	

	
	
	

	
	
	

	
}



basement_camera_cover()
{
	wait( .5 );
	lid = GetEntArray( "basement_camera_lid", "targetname" );

	for ( i = 0; i<lid.size; i++ )
	{
		lid[i] maps\_distract_object_small::distract_obj_setup( maps\_distraction::phys_push_ondmg, undefined, false );
		lid[i] thread enable_camera_hack();
		lid[i].script_alert = "none";
	}
}

enable_camera_hack()
{
	

	entBox = GetEnt( self.target, "targetname" );

	entBox notify( entBox.script_alert );
}



basement_camera_movement()
{
	self endon ( "damage" );
	while ( 1 )
	{
		wait ( .1 );
		self rotateyaw( 125, 4 );
		self playsound ("security_cam_move");
		self waittill ( "rotatedone" );
		self rotateyaw( -125, 4 );
		self playsound ("security_cam_move");
		self waittill ( "rotatedone" );
	}
}



basement_camera_health()
{
	self waittill ( "damage" );
	
	self notify ( "damage" );
}



basement_trigger_amb_thug_01()
{
	trigger = getent ( "basement_amb_thug_trigger_01", "targetname" );
	trigger waittill ( "trigger" );
	thug = getent ("basement_amb_thug_01", "targetname")  stalingradspawn( "thug" );
	thug waittill( "finished spawning" );
}



basement_trigger_amb_thug_02()
{
	trigger = getent ( "basement_amb_thug_trigger_02", "targetname" );
	trigger waittill ( "trigger" );
	thug = getent ("basement_amb_thug_02", "targetname")  stalingradspawn( "thug" );
	thug waittill( "finished spawning" );
}



basement_trigger_amb_thug_03()
{
	trigger = getent ( "basement_amb_thug_trigger_03", "targetname" );
	trigger waittill ( "trigger" );

	

	thug = getent ("basement_amb_thug_03", "targetname")  stalingradspawn( "thug" );
	thug waittill( "finished spawning" );
}



basement_trigger_amb_thug_04()
{
	trigger = getent ( "basement_amb_thug_trigger_04", "targetname" );
	trigger waittill ( "trigger" );
	thug = getent ("basement_amb_thug_04", "targetname")  stalingradspawn( "thug" );
	thug waittill( "finished spawning" );
}



basement_trigger_amb_thug_05()
{
	trigger = getent ( "dock_truck_backing_up", "targetname" );
	trigger waittill ( "trigger" );
	level thread eleavator_dock_blinking_light_func();
	thug = getent ("basement_amb_thug_05", "targetname")  stalingradspawn( "thug" );
	thug waittill( "finished spawning" );
}



eleavator_dock_blinking_light_func()
{
	light = GetEnt( "eleavator_dock_blinking_light", "targetname" );

	level endon ( "kill_dock_light" );
	while ( 1 )
	{
		wait( 1 );
		light hide();
		wait( 1 );
		light show();
	}
}



basement_trigger_amb_thug_06()
{
	trigger = getent ( "basement_amb_thug_trigger_06", "targetname" );
	trigger waittill ( "trigger" );
	thug = getent ("basement_amb_thug_06", "targetname")  stalingradspawn( "thug" );
	thug waittill( "finished spawning" );
}



















































































security_thugs_chat()
{
	level notify ( "thugs_are_synced" );
}



basement_security_room_spawn_thugs()
{
	trigger = getent ( "basement_security_room_trigger", "targetname" );
	trigger waittill ( "trigger" );

	

	level thread security_thugs_chat_spawn();

	thug_spawn = getentarray ( "basement_security_room_spawners", "targetname" );

	for ( i = 0; i < thug_spawn.size; i++ )
	{
		thug[i] = thug_spawn[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
		}
	}
}





security_thugs_chat_spawn()
{
	thug_01 = getent ("basement_security_room_spawners_01", "targetname")  stalingradspawn( "thug_01" );
	thug_02 = getent ("basement_security_room_spawners_02", "targetname")  stalingradspawn( "thug_02" );

	level waittill ( "thugs_are_synced" );
	if ( isdefined ( thug_01 ))
	{
		pos = thug_01.origin + ( 0, 0,64 );
		color = ( 0, .5, 0 );            
		scale = 1.5;       
		Print3d( pos, "We are almost done go check with Kenny.", color, 1, scale, 120 );
	}

	wait( 3 );

	if ( isdefined ( thug_02 ))
	{
		pos = thug_02.origin + ( 0, 0,64 );
		color = ( 0, .5, 0 );            
		scale = 1.5;       
		Print3d( pos, "Yeah all right.", color, 1, scale, 120 );
	}

	if ( isdefined ( thug_02 ))
	{
		thug_02 stoppatrolroute();
	}
	wait( .5 );
	if ( isdefined ( thug_02 ))
	{
		thug_02 startpatrolroute ( "security_wrong_way" );
	}
	wait( 2 );

	if ( isdefined ( thug_01 ))
	{
		pos = thug_01.origin + ( 0, 0,64 );
		color = ( 0, .5, 0 );            
		scale = 1.5;       
		Print3d( pos, "Wait wrong way, that door is locked remember.", color, 1, scale, 120 );
	}

	wait( 1 );
	if ( isdefined ( thug_02 ))
	{
		thug_02 stoppatrolroute();
	}
	wait( .5 );
	if ( isdefined ( thug_01 ))
	{
		thug_01 stoppatrolroute();
	}
	wait( 2 );

	if ( isdefined ( thug_02 ))
	{
		pos = thug_02.origin + ( 0, 0,64 );
		color = ( 0, .5, 0 );            
		scale = 1.5;       
		Print3d( pos, "Yeah all right.", color, 1, scale, 120 );
	}
	wait ( 1 );
	if ( isdefined ( thug_02 ))
	{
		thug_02 startpatrolroute ( "security_right_way" );
	}

	wait ( 5 );
	if ( isdefined ( thug_01 ))
	{
		thug_01 startpatrolroute ( "security_loop_office" );
	}
}



basement_office_stop()
{





}



basement_office_look_cameras()
{
	if ( isdefined ( self ))
	{
		pos = self.origin + ( 0, 0,64 );
		color = ( 0, .5, 0 );            
		scale = 1.5;       
		Print3d( pos, "Hey Joe what'da ya know.", color, 1, scale, 120 );
	}
}







storage_room_spawn_thugs()
{
	trigger = getent ( "basement_storage_room_trigger", "targetname" );
	trigger waittill ( "trigger" );
	
	
	
	
	
	
	thug_on_laptop = getent ("basement_extra_room_spawner", "targetname")  stalingradspawn( "thug_on_laptop" );
	wait( 1 );
	if ( isdefined ( thug_on_laptop ))
	{
		thug_on_laptop CmdAction( "TypeLaptop" );
	}
}



basement_storage_talk_02()
{
	pos = self.origin + ( 0, 0,64 );
	color = ( 0, .5, 0 );            
	scale = 1.5;       
	Print3d( pos, "I got more boxes coming.", color, 1, scale, 120 );
	
	wait( 5 );
	if ( isdefined ( self ))
	{
		self stoppatrolroute();
		wait ( .5 );
		if ( isdefined ( self ))
		{
			self startpatrolroute ( "basement_hall_01" );
		}
	}
}












dock_use_gate()
{
	trigger = GetEnt( "dock_roll_up_gate_trigger", "targetname" );
	gate = GetEnt( "dock_roll_up_gate", "targetname" );

	trigger waittill ( "trigger" );
	trigger trigger_off();
	level notify ( "kill_gate_light" );
	gate movez( 100, 5 );
}



dock_gate_blinking_light_func()
{
	trigger = GetEnt( "dock_start_button_blink", "targetname" );
	light = GetEnt( "gate_blinking_light", "targetname" );
	trigger waittill ( "trigger" );

	level endon ( "kill_gate_light" );
	while ( 1 )
	{
		wait( 1 );
		light hide();
		wait( 1 );
		light show();
	}
}



dock_ele_func_down()
{
	trigger_up = getent ( "dock_ele_button_up", "targetname" );
	trigger_up trigger_off();

	trigger_down = getent ( "dock_ele_button_down", "targetname" );
	trigger_down trigger_on();

	ele = getent ( "dock_ele", "targetname" );
	trigger_down waittill ( "trigger" );
	ele movez ( -125, 5 );
	
	ele waittill ( "movedone" );

	level thread dock_ele_func_up();	
}



dock_ele_func_up()
{
	trigger_up = getent ( "dock_ele_button_up", "targetname" );
	trigger_up trigger_on();

	trigger_down = getent ( "dock_ele_button_down", "targetname" );
	trigger_down trigger_off();

	ele = getent ( "dock_ele", "targetname" );
	trigger_up waittill ( "trigger" );
	ele movez ( 125, 5 );
	
	ele waittill ( "movedone" );
	level thread dock_ele_func_down();
}

dock_truck_event()
{
	trigger = getent ( "dock_truck_backing_up", "targetname" );
	trigger waittill ( "trigger" );

	truck = getent ( "dock_truck_trailer", "targetname" );
	truck movex ( -62, 4 );
	truck waittill ( "movedone" );
	
	level thread dock_loading_2();
	dist = Distance( level.player.origin, truck.origin );
	if ( dist <= 300 )
	{
		earthquake( .25, 1, level.player.origin, 300 );
	}
	else
	{
		
	}
}



dock_loading_spawn_thugs()
{
	level waittill ( "spawn_dock_thugs" );
	thug_spawn = getentarray ( "basement_dock_thugs", "targetname" );

	for ( i = 0; i < thug_spawn.size; i++ )
	{
		thug[i] = thug_spawn[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
		}
	}
}



dock_loading_2()
{
	trigger = getent ( "basement_dock_thugs_trigger", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "spawn_dock_thugs" );
}





































basement_spawn_truck_thug()
{
	trigger = getent ( "dock_roll_up_gate_trigger", "targetname" );
	trigger waittill ( "trigger" );
	thug = getent ("basement_dock_truck_thug", "targetname")  stalingradspawn( "thug" );
	thug waittill( "finished spawning" );
	thug thread basement_dock_death_check();
	thug thread basement_dock_agro_check();
	thug thread basement_dock_alert_check();
	wait( 2 );
	thug CmdPlayAnim( "ct_thug_truckguide", true );

}



basement_dock_alert_check()
{
	self endon ( "death" );
	while ( 1 )
	{
		wait( .5 );
		if (( isdefined ( self )) && ( self GetAlertState() == "alert_red" ))
		{
			level notify ( "spawn_dock_thugs" );
		}
	}
}



basement_dock_death_check()
{
	self waittill ( "death" );
	wait( 15 );
	level notify ( "spawn_dock_thugs" );
}



basement_dock_agro_check()
{
	self waittill ( "damage" );
	thug_spawn = getentarray ( "basement_dock_thugs", "targetname" );
	wait ( 1 );

	if ( IsDefined ( self ))
	{
		for ( i = 0; i < thug_spawn.size; i++ )
		{
			thug[i] = thug_spawn[i] stalingradspawn();
			if( !maps\_utility::spawn_failed( thug[i]) )
			{
				thug[i] lockalertstate( "alert_red" );
			}
		}
		level thread basement_dock_agro_check_2();
	}
}



basement_dock_agro_check_2()
{
	wait( 10 );
	thug_spawn = getentarray ( "basement_dock_thugs_2", "targetname" );

	for ( i = 0; i < thug_spawn.size; i++ )
	{
		thug[i] = thug_spawn[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
			thug[i] lockalertstate( "alert_red" );
		}
	}
}





	
	
	
	





basement_loop_talkA2_anim()
{
	self endon ( "damage" );
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



basement_loop_talkA1_anim()
{
	self endon ( "damage" );
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










security_access_computer()
{
	level.computer = getent("computer_security_access", "targetname");

	maps\_playerawareness::setupEntSingleUseOnly(
		level.computer, 
		::access_security, 
		&"SCIENCECENTER_B_ACCESS_ELEVATOR", 
		2, 
		"", 
		true, 
		true, 
		undefined, 
		undefined, 
		true, 
		false, 
		true);
}



access_security(origin)
{
	level thread maps\sciencecenter_b::access_camera_controls();
	
	
	level thread maps\sciencecenter_b::start_dimitri_carlos_cutscene();
	
	flag_set("accessed_elevator");
}






spawn_artroom()
{	
	trigger = getent("trigger_spawn_artroom", "targetname");
	trigger waittill("trigger");
	
	level notify("playmusicpackage_stealth");
	
	
	
	level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	
	thread check_security_alert();
	thread security_camera_artroom();
	thread spawn_guard_office();
		
	
	
	
	guard_artroom = getent("guard_artroom", "targetname");

	if (!level.alert_status_artroom)
	{
		guard_artroom waittill("start_propagation");

		spawnerarray = getentarray("guard_reinforce_artroom", "targetname");			

		guard_artroom play_dialogue("SBM1_SciBG02A_017A", false);	

		for (i=0; i<spawnerarray.size; i++)
		{
			spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_reinforce");
		}

		level.alert_status_artroom = 1;
		level notify("playmusicpackage_combat");
	}
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}






security_camera_artroom()
{
	sec_camera = getent("camera_artroom","targetname");
	
	hack_box = getent("camera_hackbox", "targetname");	
	sec_camera thread maps\_securitycamera::camera_start(hack_box, true, false, false);

	
	
	
	
	







	
	sec_camera waittill("start_camera_spawner");

	level notify("playmusicpackage_combat");
	
	level.player play_dialogue("SCS1_SciBG02A_025A", false);		
	
	level.alert_status_artroom = 1;
	
	level notify("playmusicpackage_combat");
	
	wait(0.5);
	
	level.player play_dialogue("SCA1_SciBG02A_026A", true);		
}


security_camera_artroom_tapped()
{
	self waittill("tapped");

	
	trigger = getent("trigger_spawn_officeguard", "targetname");
	trigger notify("trigger");
}




basement_wait_patrol()
{
	if (isdefined(self))
	{
		self pausepatrolroute();
	}
	
	trigger = getent("trigger_resume_patrol", "targetname");
	trigger waittill("trigger");
	
	if (isdefined(self))
	{
		self resumepatrolroute();
		self play_dialogue("SARM_SciBG02A_022A", true);	
	}
	
	
	wait(0.5);
	
	if (!(level.alert_status_artroom))
	{
		if (isalive(self))
		{
			self play_dialogue("SCS1_SciBG02A_023A", true);		
		}
	}
	
	wait(0.5);
	
	if (!(level.alert_status_artroom))
	{
		if (isalive(self))
		{
			self play_dialogue("SARM_SciBG02A_024A", true);	
		}
	}
}






basement_type_laptop()
{
	wait(1.0);
	
	self stoppatrolroute();
	
	self CmdAction( "TypeLaptop" );			
}






spawn_guard_office()
{
	trigger = getent("trigger_spawn_officeguard", "targetname");
	trigger waittill("trigger");
	
	spawner = getent("guard_security_01", "targetname");
	spawner stalingradspawn("guard_office");
	
	guard = getent("guard_office", "targetname");
	
	if (level.alert_status_artroom)
	{
		guard lockalertstate("alert_red");
	}
	
	thread check_alert_office();
	thread spawn_monitor_guards();
}
	





check_security_alert()
{
	trigger = getent("trigger_check_alert", "targetname");
	trigger waittill("trigger");

	VisionSetNaked( "Sciencecenter_b_04" );
	
	if (level.alert_status_artroom)
	{
		alertarray = getentarray("guard_security_alert", "targetname");
		
		for (i=0; i<alertarray.size; i++)
		{
			alertarray[i] = alertarray[i] stalingradspawn("guard_alert");
		}
		
		thread spawn_office_guards();
		thread spawn_office_backup();
	}
	
	thread security_room_reached();
}






spawn_office_guards()
{
	trigger = getent("trigger_spawn_office", "targetname");
	trigger waittill("trigger");
	
	
	
	
	alertarray2 = getentarray("guard_security_alert2", "targetname");		
	for (i=0; i<alertarray2.size; i++)
	{
		alertarray2[i] = alertarray2[i] stalingradspawn("guard_alert2");
	}
}






spawn_office_backup()
{
	trigger = getent("trigger_office_reinforce", "targetname");
	trigger waittill("trigger");
	
	guardarray = getentarray("guard_office_backup", "targetname");
		
	for (i=0; i<guardarray.size; i++)
	{
		guardarray[i] = guardarray[i] stalingradspawn("guard_officebackup");
	}
}






check_alert_office()
{
	guard = getent("guard_office", "targetname");
	
	while(!(level.guard_office_alerted))
	{
		if ((isalive(guard)) && (guard getalertstate() == "alert_red") && (!(level.alert_status_artroom)))
		{
			array = getentarray("guard_security_reinforce", "targetname");
			
			guard play_dialogue("SBM3_SciBG02A_019A", true);		
			
			for (i=0; i<array.size; i++)
			{
				array[i] = array[i] stalingradspawn("guard_office_reinforce");
			}
			
			level.guard_office_alerted = true;
		}
		
		wait(0.5);
	}		
}






security_room_reached()
{
	trigger = getent("trigger_security_reached", "targetname");
	trigger waittill("trigger");
	
	level notify("objective_2_done");
	
	level notify("playmusicpackage_stealth");
		
	thread security_access_computer();
}






guard_look_window()
{
	if (isalive ( self ))
	{
		self CmdAction("fidget", true);
	}
	
	wait(7.0);
	
	if (isalive ( self ))
	{
		self stopallcmds();
	}
}






guard_scratch()
{
	if (isalive ( self ))
	{
		self CmdAction("fidget", true);	
	}
}






spawn_monitor_guards()
{
	trigger = getent("trigger_monitor_guards", "targetname");
	trigger waittill("trigger");
	
	if(!(level.alert_status_artroom))
	{
		spawnarray = getentarray("guard_security_conversation", "targetname");
	
		for (i=0; i<spawnarray.size; i++)
		{
			spawnarray[i] = spawnarray[i] stalingradspawn("guard_monitors");
		}
	}
	
	thread check_alert_status();
	thread spawn_monitor_backup();
	thread spawn_office_last();
}






spawn_monitor_backup()
{
	guardarray = getentarray("guard_monitors", "targetname");
	backuparray = getentarray("guard_monitor_backup", "targetname");
	
	while(!(level.monitors_alerted))
	{
		for (i=0; i<guardarray.size; i++)
		{
			if ((isalive(guardarray[i])) && (guardarray[i] getalertstate() == "alert_red") && (!(level.monitors_alerted)))
			{
				for (j=0; j<backuparray.size; j++)
				{
					backuparray[j] = backuparray[j] stalingradspawn("guard_monitors");
				}
				
				level.monitors_alerted = true;
			}
		}
		
		wait(0.5);		
	}
}





spawn_office_last()
{
	guardarray = getentarray("guard_office_last", "targetname");
		
	if ((level.alert_status_artroom) || (level.guard_office_alerted))
	{
		for (i=0; i<guardarray.size; i++)
		{
			guardarray[i] = guardarray[i] stalingradspawn("guards_last");
		}
	}
}






monitor_talk_01()
{	
	self CmdAction( "TalkA1", true );
	
	wait(12.0);
			
	if (isalive ( self ))
	{
		self stopallcmds();
	}
}


monitor_talk_02()
{	
	self CmdAction( "TalkA2", true );
	
	wait(12.0);
			
	if (isalive ( self ))
	{
		self stopallcmds();
	}
}


monitor_patrol_stop()
{
	wait(1.0);
	
	if (isalive(self))
	{
		self stoppatrolroute();
	}
	
	while(isalive(self))
	{
			if (isalive ( self ))
		{
			self CmdAction("fidget", true);
			self waittill ( "cmd_done" );
		}
		
		wait(9.0);
	}
}






check_alert_status()
{
	guys = getaiarray("axis");
	
	for (i=0; i<guys.size; i++)
	{
		if((guys[i] GetAlertState() == "alert_red") && (!(level.monitors_alerted)))
		{
			array = getentarray("guard_monitors", "targetname");
			
			for (j=0; j<array.size; j++)
			{
				array[j] lockalertstate("alert_red");
			}
			
			level.monitors_red_alert = true;
		}
	}
}