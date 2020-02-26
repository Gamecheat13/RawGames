#include maps\_utility;
#include maps\_distraction;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////THIS IS WHAT HAPPENS IN THE SCIENCE CENTER////////////////////////////
////////////////////////////////////////  BASEMENT  ////////////////////////////////////////////
//NOTE: This GSC file only deals with the basement
//
//
//
//
//
//
//
////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////

main()
{
	level waittill ( "basement" );
	
	// global variables
	level.basement_red_alert = false;

	// basement threads
	thread reached_basement();			// tells us that the basement has been reached
	thread security_camera_artroom();	// sets up the security cam
	//thread spawn_artroom();				// gets things rolling
	thread check_security_alert();		// lets us know when bond is no longer stealth
	//thread basement_wait_patrol();	// start patrol once bond hits a trigger
	thread spawn_guard_office();		// spawns the office guard that comes out as you turn the hallway corner
	thread spawn_monitor_guards();
	thread security_room_reached();	
	thread change_music();				// watch to change to combat or stealth
	thread basement_elevator_save();	// save when you hit the trigger going into the elevator
}
reached_basement()
{
	trigger = getent ( "section_one_thug_trigger", "targetname" );
	trigger waittill ( "trigger" );
	//level notify("objective_1_done");
	
	//iprintlnbold("reached_basement");

	flag_set("reached_basement"); // shows current objective is clear and sets to the next objective

	//DCS: setting fog for basement. (bug 10937)
	//setExpFog(0,435,0.29,0.304,0.304, 2.0);
	
	level.player play_dialogue("TANN_SciBG02A_016A", true);	//Good.  After the corridor you'll reach the security station.  We're guessing that's their control point.
}
change_music()
{
	self endon("end_basement");

	// start off playing the stealth
	level notify("playmusicpackage_stealth");

	// watch to see if we alert the whole area
	while(1)
	{
		if(level.basement_red_alert)
		{
			// play the combat music
			level notify("playmusicpackage_combat");
			wait(1.0);

			// now wait to see if we kill everyone after they have been alerted
			while(1)
			{
				guardarray = getaiarray("axis");
				if(guardarray.size <= 0)
				{
					// go back to stealth
					level notify("playmusicpackage_stealth");
					break;
				}
				wait(0.05);
			}
			break;
		}
		wait(0.05);
	}
}
basement_elevator_save()
{
	trig = getent("basement_elevator_save_trig", "targetname");
	if(isdefined(trig))
		trig waittill("trigger");

	//thread maps\_autosave::autosave_now("MiamiScienceCenter");
	level notify("checkpoint_reached"); // checkpoint 5
}


///////////////////////////////////////////////////////////////////////////////////////
//	Check if guards are alerted
///////////////////////////////////////////////////////////////////////////////////////
watch_guard_alert_status()
{
	self endon("death");

	self waittill("start_propagation");

	//iprintlnbold("watch_guard_alert_status");

	//level notify("playmusicpackage_combat");

	// pick random dialogue
	random_num = randomint(100);
	if(random_num < 50)
		self play_dialogue("SBM1_SciBG02A_017A", false);	//He's downstairs!
	else
		self play_dialogue("SBM3_SciBG02A_019A", false);	//Contact!  Basement level.

	level.basement_red_alert = true;
	self setperfectsense(true);
}
check_security_alert()
{
	while(1)
	{
		if(level.basement_red_alert)
		{
			//iprintlnbold("check_security_alert");
			// let all hell break loose
			// spawn reinforcement guards
			thread spawn_reinforcement_guards();
			thread spawn_reinforcement_elites();

			break;
		}

		wait(0.05);
	}
}
spawn_reinforcement_guards()
{
	//iprintlnbold("spawn_reinforcement_guards");

	// open the doors and let the AI out
	thread open_dyn_door("basement_backup_door_l3", 90.0, 0.5);
	thread open_dyn_door("basement_backup_door_r3", -90.0, 0.5);
	wait(0.7);
	//GetNode("guards_door", "targetname") maps\_doors::open_door();

	// spawn AI
	spawnarray = getentarray("guard_basement_reinforce", "targetname");		
	for(i = 0; i < spawnarray.size; i++)
	{
		spawnarray[i] = spawnarray[i] stalingradspawn("guard_reinforce");

		if(isdefined(spawnarray[i]))
		{
			// NOTE: give them a goal node, so they will just run to the goal and ignore everything else
			node_name = "reinforce_goal_node" + (i + 1);
			//iprintlnbold(node_name);
			goal_node = getnode(node_name, "targetname");
			if(isdefined(goal_node))
			{
				spawnarray[i] setscriptspeed("sprint");
				//iprintlnbold(node_name);
				spawnarray[i] setgoalnode(goal_node, 1);
				// turn off sense so they'll run out to the goal
				//spawnarray[i] setenablesense(false);
				// this will check when they hit their goal and turn sense back on
				spawnarray[i] thread check_goal();
			}
		}
	}

	wait(5.0);
	thread close_dyn_door("basement_backup_door_l3", -90.0, 0.5);
	thread close_dyn_door("basement_backup_door_r3", 90.0, 0.5);
}
spawn_reinforcement_elites()
{
	//iprintlnbold("spawn_reinforcement_elites");

	// open the doors and let the AI out
	thread open_dyn_door("basement_backup_door_l2", 90.0, 0.5);
	thread open_dyn_door("basement_backup_door_r2", -90.0, 0.5);
	thread open_dyn_door("basement_backup_door_l1", 90.0, 0.5);
	thread open_dyn_door("basement_backup_door_r1", -90.0, 0.5);
	wait(0.7);
	//GetNode("elites_door1", "targetname") maps\_doors::open_door();

	// spawn elites when monitor guards are alerted
	spawnarray = getentarray("elite_basement_reinforce", "targetname");
	for(i = 0; i < spawnarray.size; i++)
	{
		spawnarray[i] = spawnarray[i] stalingradspawn("guard_reinforce");

		if(isdefined(spawnarray[i]))
		{
			// NOTE: give them a goal node, so they will just run to the goal and ignore everything else
			node_name = "backup_goal_node" + (i + 1);
			//iprintlnbold(node_name);
			goal_node = getnode(node_name, "targetname");
			if(isdefined(goal_node))
			{
				spawnarray[i] setscriptspeed("sprint");
				//iprintlnbold(node_name);
				spawnarray[i] setgoalnode(goal_node, 1);
				// turn off sense so they'll run out to the goal
				//spawnarray[i] setenablesense(false);
				// this will check when they hit their goal and turn sense back on
				spawnarray[i] thread check_goal();
			}
		}
	}

	wait(3.0);
	//door_node = GetNode("elites_door2", "targetname");
	//door_node maps\_doors::open_door();
	wait(5.0);
	//door_node maps\_doors::close_door_from_door_node(); // fail safe because the doors don't want to auto close all the time
	thread close_dyn_door("basement_backup_door_l2", -90.0, 0.5);
	thread close_dyn_door("basement_backup_door_r2", 90.0, 0.5);
	thread close_dyn_door("basement_backup_door_l1", -90.0, 0.5);
	thread close_dyn_door("basement_backup_door_r1", 90.0, 0.5);
}
check_goal()
{
	self endon("death");
	self waittill("goal");

	//iprintlnbold("check_goal");
	self setenablesense(true);
	self setperfectsense(true);
}
open_dyn_door(door_name, rot, time)
{
	//iprintlnbold("open door");
	door = getent(door_name, "targetname");
	if(isdefined(door))
	{
		door rotateyaw(rot, time);
		door waittill("rotatedone");
		door connectpaths();
	}
}
close_dyn_door(door_name, rot, time)
{
	//iprintlnbold("open door");
	door = getent(door_name, "targetname");
	if(isdefined(door))
	{
		door rotateyaw(rot, time);
		door waittill("rotatedone");
		door disconnectpaths();
	}
}


///////////////////////////////////////////////////////////////////////////////////////
//	Setup security access computer
///////////////////////////////////////////////////////////////////////////////////////
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
	//level notify("objective_3_done");
	
	level thread maps\sciencecenter_b::start_dimitri_carlos_cutscene();
	
	flag_set("accessed_elevator");
	level notify("end_basement");
}



///////////////////////////////////////////////////////////////////////////////////////
// start the event
///////////////////////////////////////////////////////////////////////////////////////
//spawn_artroom()
//{	
//	trigger = getent("trigger_spawn_artroom", "targetname");
//	trigger waittill("trigger");
//	//iprintlnbold("spawn_artroom");
//
//	//level notify("playmusicpackage_stealth");
//	
//	guard = getent("guard_artroom", "targetname");
//	if(isdefined(guard))
//	{
//		//guard thread basement_wait_patrol(); // this gets called in catwalk code, because that's where he's spawned
//		guard thread watch_guard_alert_status();
//		guard thread watch_to_spawn_reinforcements();
//	}
//}
watch_to_spawn_reinforcements()
{
	self waittill("start_propagation");

	spawnerarray = getentarray("guard_reinforce_artroom", "targetname");			
	for(i = 0; i < spawnerarray.size; i++)
	{
		spawnerarray[i] = spawnerarray[i] stalingradspawn("guard_reinforce");
		if(isdefined(spawnerarray[i]))
		{
			spawnerarray[i] setperfectsense(true);
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////
// Security Camera
///////////////////////////////////////////////////////////////////////////////////////
security_camera_artroom()
{
	sec_camera = getent("camera_artroom","targetname");
	
	hack_box = getent("camera_hackbox", "targetname");	
	sec_camera thread maps\_securitycamera::camera_start(hack_box, true, false, false);

	feed_box = GetEnt("feed_box2", "targetname");
	feed_box thread security_camera_artroom_tapped();
	

	// wait until the camera spots bond
	sec_camera waittill("spotted");
	//iprintlnbold("security_camera_artroom");

	level.basement_red_alert = true;
	//level notify("playmusicpackage_combat");
	level.player play_dialogue("SCS1_SciBG02A_025A", false);		//Intruder spotted.  He's downstairs!  In the basement.
	wait(0.5);
	level.player play_dialogue("SCA1_SciBG02A_026A", true);		//We're on him!
}
// if the camera gets tapped, kick off the patroller down the hall so you can see him in the camera -bb
security_camera_artroom_tapped()
{
	self waittill("tapped");

	// trigger the trigger that spawns the patroller as if the player walked down the hall and triggered it -bb
	trigger = getent("trigger_spawn_officeguard", "targetname");
	trigger notify("trigger");
}




///////////////////////////////////////////////////////////////////////////////////////
// Guard waits for player before starting patrol
///////////////////////////////////////////////////////////////////////////////////////
enable_sense_for_basement_guy(door)
{
	self endon("death");
	door waittill("closed");
	self SetEnableSense(true);
}
check_first_guard_goal()
{
	self waittill("goal");

	//iprintlnbold("met goal");
	self thread basement_wait_patrol();
}
basement_wait_patrol()
{
	//if (isdefined(self))
	//{
	//	self pausepatrolroute();
	//}
	
	trigger = getent("trigger_resume_patrol", "targetname");
	trigger waittill("trigger");
	
	//iprintlnbold("basement_wait_patrol");
	
	if (isdefined(self))
	{
		self thread watch_guard_alert_status();
		self thread watch_to_spawn_reinforcements();

		//self resumepatrolroute();
		//iprintlnbold("start patrol");
		self stopallcmds();
		wait(0.05);
		self startpatrolroute("first_guard_route");
		wait(0.05);
		self play_dialogue("SARM_SciBG02A_022A", false);	//Rivera, basement's clear, do you want me to head upstairs, over?
	}
	
	
	wait(0.5);
	
	if(!(level.basement_red_alert))
	{
		if (isalive(self))
		{
			self play_dialogue("SCS1_SciBG02A_023A", true);		//Negative.  I think we've got the problem contained, stay on your route.
		}
	}
	
	wait(0.5);
	
	if(!(level.basement_red_alert))
	{
		if (isalive(self))
		{
			self play_dialogue("SARM_SciBG02A_024A", false);	//Will do, over.
		}
	}
}




///////////////////////////////////////////////////////////////////////////////////////
// Spawn patrolling guard after camera
///////////////////////////////////////////////////////////////////////////////////////
spawn_guard_office()
{
	trigger = getent("trigger_spawn_officeguard", "targetname");
	trigger waittill("trigger");
	//iprintlnbold("spawn_guard_office");

	spawner = getent("guard_security_01", "targetname");
	spawner stalingradspawn("guard_office");
	
	guard = getent("guard_office", "targetname");
	if(isdefined(guard))
	{
		guard thread watch_guard_alert_status();
	}
	if(level.basement_red_alert)
	{
		guard lockalertstate("alert_red");
		guard setperfectsense(true);
	}

	// turn on the console dynamic light
	if(isdefined(level.console_light))
	{
		level.console_light setlightintensity(1);
		//iprintlnbold("console light on");
	}
}



///////////////////////////////////////////////////////////////////////////////////////
// Spawns guards having conversation
///////////////////////////////////////////////////////////////////////////////////////
spawn_monitor_guards()
{
	trigger = getent("trigger_monitor_guards", "targetname");
	trigger waittill("trigger");
	//iprintlnbold("spawn_monitor_guards");
	
	if(!(level.basement_red_alert))
	{
		spawnarray = getentarray("guard_security_conversation", "targetname");
	
		for(i = 0; i < spawnarray.size; i++)
		{
			spawnarray[i] = spawnarray[i] stalingradspawn("guard_monitors");
			if(isdefined(spawnarray[i]))
			{
				spawnarray[i] thread watch_guard_alert_status();
			}
			if(level.basement_red_alert)
			{
				spawnarray[i] lockalertstate("alert_red");
			}
		}
	}
}




///////////////////////////////////////////////////////////////////////////////////////
//	Security room reached
///////////////////////////////////////////////////////////////////////////////////////
security_room_reached()
{
	trigger = getent("trigger_security_reached", "targetname");
	trigger waittill("trigger");
	//iprintlnbold("security_room_reached");

	level notify("objective_2_done");
	
	thread security_access_computer();
}



///////////////////////////////////////////////////////////////////////////////////////
//	Guard looks toward window
///////////////////////////////////////////////////////////////////////////////////////
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
///////////////////////////////////////////////////////////////////////////////////////
//	Guard scratches
///////////////////////////////////////////////////////////////////////////////////////
guard_scratch()
{
	if (isalive ( self ))
	{
		self CmdAction("fidget", true);	
	}
}
///////////////////////////////////////////////////////////////////////////////////////
//	Monitor guards conversation
///////////////////////////////////////////////////////////////////////////////////////
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