#include maps\_utility;
#include maps\_distraction;
#include common_scripts\utility;
#include maps\_anim;
#include animscripts\shared;

////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////THIS IS WHAT HAPPENS IN THE SCIENCE CENTER////////////////////////////
/////////////////////////////////////////  INSIDE  /////////////////////////////////////////////
//NOTE: This GSC file only deals with the catwalk and stairs.
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
	//---------- OBJECTIVES -------------
	//-----------------------------------

	//------- GLOBAL FUNCTIONS -----------
	level thread global_rain();
	//-----------------------------------
	
	//-------- STAIR FUNCTIONS ----------
	//level thread stairs_path_center();
	//level thread stairs_top_of_stairs();
	level thread stairs_bottom_of_stairs();
	//-----------------------------------
	
	level.basement = 0;
	level.newpatrol = 0;
	level.thug_count = 0;
	level.no_spawn = 0;

	////////////////////////////////////////////////
	// New stuff
	////////////////////////////////////////////////
	level.alert_changed = false;
	level.had_conversation1 = false;
	level.had_conversation2 = false;
	level.catwalk2_door_open = false;
	level.catwalk1_red_alert = false;

	//thread door_open_stairwell();
	wait(0.05);
	setSavedDvar("sf_compassmaplevel",  "level1");
	thread map_level_1to2();

	thread savegame_triggers();
	thread vo_start_tanner();
	
	thread helium_tank_setup();
	thread check_catwalk1_security_alert();

	// get fuentes and start his life as a soon to die ai
	fuentes = getent("thug_overrail", "targetname");
	if(isdefined(fuentes))
		fuentes thread setup_thug_overrail();
}


////////////////////////////////////////////////////
//////////////// CATWALK FUNCTIONS /////////////////
////////////////////////////////////////////////////

//avulaj
//this will handle the rain
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

//		playfx ( level._effect["rain8"], forwardrain + (0,0,650), forwardrain + (0,0,680), forwardrain + (800,0,0) );
//		playfx ( level._effect["rain9"], level.player.origin + (0,0,650), level.player.origin + (0,0,680), (0,0,680) );
		//playfx ( level._effect["rain_mist"], level.player.origin + (0,0,650), level.player.origin + (0,0,680), (0,0,680) );
	}
}

//avulaj
//this plays an anim to make it look like a thug is talking
catwalk_anim_talk_01()
{
	//self stop_talking();
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

//avulaj
//this is waitting for a level notify to start the AI on a new patrol
catwalk_wait_new_patrol_01()
{
	self StartPatrolRoute ( "catwalk_stay_in_area" );
}

//avulaj
//once level.newpatrol == 1 this function will run and stp the AI from plkkay a cmdaction
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

//avulaj
//this plays an anim to make it look like a thug is talking
catwalk_anim_talk_02()
{
	//self stop_talking();
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

//avulaj
//this is waitting for a level notify to start the AI on a new patrol
catwalk_wait_new_patrol_02()
{
	self StartPatrolRoute ( "catwalk_leave_area" );
}

//avulaj
//this handles a thug coming into the first catwalk room and telling the two other thugs to get back on patrol.
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

//avulaj
//when an AI is past through this function all cmdactions will stop
stop_commands()
{
	self stopcmd();
}

////avulaj
////
//catwalk_setup_look_at_triggers()
//{
//	level thread catwalk_right_01();
//	level thread catwalk_left_01();
//	level thread catwalk_middle();
//	level thread catwalk_middle_top();
//	level thread catwalk_center();
//}
//
////avulaj
////
//catwalk_right_01()
//{
//	trigger = getent ( "catwalk_lower_thug_right_spawn", "targetname" );
//	trigger waittill ( "trigger" );
//	//iprintlnbold ( "right_trigger_spotted" );
//	
//	thug = getent ("catwalk_lower_thug_right_01", "targetname")  stalingradspawn( "thug" );
//	thug waittill( "finished spawning" );
//	wait ( 4 );
//	thug = getent ("catwalk_lower_thug_right_02", "targetname")  stalingradspawn( "thug" );
//	thug waittill( "finished spawning" );
//}
//
////avulaj
////
//catwalk_left_01()
//{
//	trigger = getent ( "catwalk_lower_thug_left_spawn", "targetname" );
//	trigger waittill ( "trigger" );
//	//iprintlnbold ( "left_trigger_spotted" );
//
//	thug1 = getent ("catwalk_lower_thug_left_02", "targetname")  stalingradspawn( "thug1" );
//	thug1 waittill( "finished spawning" );
//	wait ( 4 );
//	
//	catwalk_thug = getentarray ( "catwalk_lower_thug_left_01", "targetname" );
//
//	for ( i = 0; i < catwalk_thug.size; i++ )
//	{
//		thug[i] = catwalk_thug[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//		}
//	}
//}

////avulaj
////
//catwalk_middle()
//{
//	trigger = getent ( "catwalk_lower_thug_middle_spawn", "targetname" );
//	trigger waittill ( "trigger" );
//	//iprintlnbold ( "middle_trigger_spotted" );
//
//	catwalk_thug = getentarray ( "catwalk_lower_thug_middle", "targetname" );
//
//	for ( i = 0; i < catwalk_thug.size; i++ )
//	{
//		thug[i] = catwalk_thug[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//		}
//	}
//}
//
////avulaj
////
//catwalk_middle_top()
//{
//	trigger = getent ( "catwalk_lower_thug_middle_top_spawn", "targetname" );
//	trigger waittill ( "trigger" );
//	//iprintlnbold ( "middle_top_trigger_spotted" );
//
//	catwalk_thug = getentarray ( "catwalk_lower_thug_middle_top", "targetname" );
//
//	for ( i = 0; i < catwalk_thug.size; i++ )
//	{
//		thug[i] = catwalk_thug[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//		}
//	}
//}

//avulaj
//
catwalk_center()
{
	trigger = getent ( "catwalk_lower_thug_center_spawn", "targetname" );
	trigger waittill ( "trigger" );
	//iprintlnbold ( "middle_top_trigger_spotted" );

	catwalk_thug = getentarray ( "catwalk_lower_thug_center_01", "targetname" );

	for ( i = 0; i < catwalk_thug.size; i++ )
	{
		thug[i] = catwalk_thug[i] stalingradspawn();
		if( !maps\_utility::spawn_failed( thug[i]) )
		{
		}
	}
}

//avulaj
//
catwalk_lower_kill_amb_thugs()
{
	if (( isdefined ( self )) && ( level.basement == 1 ))
	{
		wait ( .5 );
		self delete();
	}
}


//avulaj
//
catwalk_command_node_01()
{
	self CmdAction( "fidget" );
	pos = self.origin + ( 0, 0,64 );
	color = ( 0, .5, 0 );            
	scale = 1.5;       
	Print3d( pos, "COMMAND_NODE_PLAYING", color, 1, scale, 15 );
}

////avulaj
////
//catwalk_long_section()
//{
//	trigger = getent ( "catwalk_longway", "targetname" );
//	trigger waittill ( "trigger" );
//
//	level thread catwalk_thug_who_die();
//
//	catwalk_thug = getentarray ( "catwalk_thug_02", "targetname" );
//
//	for ( i = 0; i < catwalk_thug.size; i++ )
//	{
//		thug[i] = catwalk_thug[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//			thug[i] thread catwalk_thug_counter();
//		}
//	}
//	level thread catwalk_thug_count_func();
//	level thread catwalk_extra_thug_trigger();
//	if ( level.debug_text == 1 )
//	{
//		//iPrintLnBold( "spawner_set" );
//	}
//}

//avulaj
//this counts the death of the thugs when 4 or more are killed 2 more will spawn
//if the player has progressed far enough on the catwalk the 2 extra thugs will not spawn
catwalk_thug_counter()
{
	self waittill ( "death" );
	level.thug_count++;
}

//avulaj
//this tracks level.thug_count and spwans thugs when it reaches 4 or more
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

////avulaj
////this trigger will set level.no_spawn to 1 which will cause the extra thugs on the catwalk not to spawn.
//catwalk_extra_thug_trigger()
//{
//	trigger = GetEnt( "catwalk_no_spawn_trigger", "targetname" );
//	trigger waittill ( "trigger" );
//	level.no_spawn++;
//	if ( level.debug_text == 1 )
//	{
//		//iPrintLnBold( "trigger_hit" );
//	}
//}

////avulaj
////
//catwalk_thug_who_die()
//{
//	catwalk_thug = getentarray ( "catwalk_light_fall_on_thugs", "targetname" );
//
//	for ( i = 0; i < catwalk_thug.size; i++ )
//	{
//		thug[i] = catwalk_thug[i] stalingradspawn();
//		if( !maps\_utility::spawn_failed( thug[i]) )
//		{
//			thug[i] thread catwalk_death_from_above();
//			thug[i] lockalertstate( "alert_green" );
//		}
//	}
//}
//
////avulaj
////
//catwalk_death_from_above()
//{
//	org = getent ( "damage_point", "targetname" );
//	level waittill ( "from_above" );
//	radiusdamage ( org.origin, 150, 200, 200 );
//}

//avulaj
//
catwalk_stairs_talk_01()
{
	wait ( 7 );
	//iprintlnbold ( "top_thug_at_point_talking" );
	if ( isdefined ( self ))
	{
		self stoppatrolroute();
		wait ( .5 );
		self startpatrolroute ( "catwalk_gen_node_01" );
	}
}

//avulaj
//
catwalk_stairs_setup_talk()
{
}

//avulaj
//
catwalk_stairs_talk_02()
{
	//iprintlnbold ( "bottom_thug_at_point_talking" );
}

//avulaj
//
catwalky_loop_talkA2_anim()
{
	self endon ( "death" );
	while ( 1 )
	{
		wait( .5 );
		if (( isdefined ( self )) && ( isalive ( self )))
		{
			//true allows the anim to be interrupted
			self CmdAction( "TalkA2", true );
			self waittill ( "cmd_done" );
			wait( 6 );
			//iprintlnbold ( "play_anim_talk" );
		}
	}
}

//avulaj
//
catwalky_loop_talkA1_anim()
{
	self endon ( "death" );
	while ( 1 )
	{
		wait( .5 );
		if (( isdefined ( self )) && ( isalive ( self )))
		{
			//true allows the anim to be interrupted
			self CmdAction( "TalkA1", true );
			self waittill ( "cmd_done" );
			wait( 6 );
			//iprintlnbold ( "play_anim_talk" );
		}
	}
}

//avulaj
//stairs_begin this simply starts a light to flicker
stairs_top_of_stairs()
{
	trigger = getent ( "stairs_begin", "targetname" );
	trigger waittill ( "trigger" );
	
	level thread stairs_light_flicker();
}

//avulaj
//this is temp till I get models and anims
//this will be Bond grabbing a rope and sliding down the middle of the stairs
//the player will get a chance to shoot two thugs on the way down
stairs_path_center()
{
	level notify ( "end_rain" );

	// clean up the catwalk entities
	level thread maps\sciencecenter_b::delete_all_ai();
	level thread maps\sciencecenter_b::delete_catwalk_spawners();
	level thread maps\sciencecenter_b::delete_catwalk_triggers();

	// turn on the rope dynamic light
	if(isdefined(level.rope_light))
	{
		level.rope_light setlightintensity(1);
		//iprintlnbold("rope light on");
	}

	GetNode("bottom_of_rope_door", "script_noteworthy") maps\_doors::open_door();
	
	//// NOTE: save here so we can have the guy take his normal route and not get stuck on restart, per bug 10685
	//thread maps\_autosave::autosave_now("MiamiScienceCenter");
	
	// DCS: (bug 15355) for making slide down faster.
	thread start_doorguy_moving();

	//wait( .25 );
	 
	org = getent("origin_rope", "targetname");
	level thread player_link(org);
	
	the_rope = GetEnt("fxanim_rope_dangle", "targetname");
	the_rope Hide();

	//level.player holster_weapons();
	//level.player disableWeapons();
	
	//Steve G
	level.player playsound("rope_grab");
	level.player playsound("bond_xrt_grunt");
	
	wait(0.5);
	
	//Steve G
	level.player playloopsound("rope_slide", 0.5);
	
	//org movez ( -824, 6.5 );
	
	// DCS: (bug 15355) making slide down faster.
	org movez ( -824, 3.0, 2.5 , 0.3 );
	// can I spawn a guy in the beggining to shoot still


	//wait 2.0;
	org waittill ( "movedone" );
	
	// add a little earthquake to get a better feel
	earthquake(0.25, 1, level.player.origin, 300);
	level.player shellshock("default", 2);

	//level.player playsound("bond_xrt_grunt");
	
	//Steve G
	level.player stoploopsound(0.2);

	
	level notify("reached_bottom_of_rope");
	level.player unlink();
	
	level.player playsound("bond_xrt_grunt");

	the_rope Show();

	wait 2;

	//level.player unholster_weapons();
	level.player enableWeapons();
}

// DCS: retiming for faster rope slide (bug 15355)
start_doorguy_moving()
{
	spawner = getent("guard_art_room", "targetname");
	g = spawner stalingradspawn("guard_artroom");
	if (!spawn_failed(g))
	{
		goal_node = getnode("first_guard_start_node", "targetname");
		g setgoalnode(goal_node);
		g thread maps\miami_science_center_basement::check_first_guard_goal();

		g SetEnableSense(false);
		door = GetEntArray("auto2652", "targetname");
		g thread maps\miami_science_center_basement::enable_sense_for_basement_guy(door[0]);
	}
}	

player_link(org)
{
	level endon("reached_bottom_of_rope");

	right_arc = 40;
	left_arc = 40;
	top_arc = 40;
	bottom_arc = 40;

	level.player disableWeapons();

	// spawn a script origin so we can move the player
	player_org = spawn("script_origin", level.player.origin + (0, 0, 52));
	player_org.angles = level.player.angles;
	//iprintlnbold("linkto");
	level.player linkto(player_org);
	//iprintlnbold("moveto");
	player_org moveto(org.origin, 0.5, 0.3, 0.2);
	player_org waittill("movedone");
	//iprintlnbold("rotateto");
	player_org rotateto((45, 315, 0), 0.5, 0.3, 0.2);
	player_org waittill("rotatedone");
	//iprintlnbold("unlink");
	level.player unlink();
	//level.player SetOrigin(org.origin);
	//level.player SetPlayerAngles((45, 315, 0));
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


//avulaj
//this will handle the rain in the stairwell
stairs_rain()
{	
	//THIS IS NOT WORKING
	playfx ( level._effect["rain8"], self.origin );
	//playfx ( level._effect["rain9"], self.origin );
}

//avulaj
//this will slow down time when Bond gets to the two thugs on the stair well
//after an X amount of time Bond will return to normal time
stairs_set_time_scale()
{
	wait( 3.5 );
	SetSavedDVar( "timescale", ".35" );
	wait( 3 );
	SetSavedDVar( "timescale", "1" );
}

//avulaj
//this flickers a light in the stair well that takes place after the catwalks
//this also swaps a model of the light ficture being on and off
stairs_light_flicker()
{
	light = getent ( "light_stair", "targetname" );
	
	level endon ( "kill_stair_light" );
	while ( 1 )
	{
		wait ( .1 );
		//light_fix_start setmodel ( "com_lightbox" );
		light setlightintensity ( 0 );
		wait( .05 + randomfloat( .1 ) );

		j = randomint( 20 );
		if ( j < 1 )
		{
			wait( 1 );
		}

		//light_fix_start setmodel ( "com_lightbox_on" );
		light setlightintensity ( 1 );
		wait( .05 + randomfloat( .1) );
	}
}

//avulaj
//
stairs_bottom_of_stairs()
{
	trigger = getent ( "stairs_end", "targetname" );
	trigger waittill ( "trigger" );
	level notify ( "basement" );
	//iPrintLnBold( "begin_basement" );
	//iprintlnbold ( "END OF STAIRS" );

	GetNode("locked_basement_door", "script_noteworthy") maps\_doors::close_door_from_door_node();
	
//	VisionSetNaked( "sciencecenter_b_03" );
}

///////////////////////////////////////////////////////////////////////////////////////
//	Savegame triggers
///////////////////////////////////////////////////////////////////////////////////////
savegame_triggers()
{	
	// NOTE: save game after first lock pick hack
	trig = getent("catwalk_longway", "targetname");
	if(isdefined(trig))
	{
		trig waittill("trigger");

		level waittill("ACH_LOCK_PASS");
		
		// open both doors (bug 21115)
		door_node = getnodearray("auto2037", "targetname");
		if(isdefined(door_node))
		{
			door_node[0] maps\_doors::open_door();
			door_ent = getent("door_catwalk_left", "targetname");
			if(isdefined(door_ent))
				door_ent maps\_doors::unlock_door();
		}
		door_node = getnodearray("auto2040", "targetname");
		if(isdefined(door_node))
		{
			door_node[0] maps\_doors::open_door();
			door_ent = getent("door_catwalk_right", "targetname");
			if(isdefined(door_ent))
				door_ent maps\_doors::unlock_door();
		}

		thread delete_aim_triggers();

		//level thread maps\_autosave::autosave_now("MiamiScienceCenter");
		level notify("checkpoint_reached"); // checkpoint 1
	}

	//trigger = getent("trigger_savegame_catwalk1", "targetname");
	//trigger waittill("trigger");
	
	// commented this out because this flag needs to be set when we kill all of the catwalk AI
	//flag_set("reached_stairwell");
	
	//level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	
	//savegame("MiamiScienceCenter");
	//autosave_by_name("catwalk");
	
	//trigger_obj_01 = getent("trigger_reached_maincatwalk", "targetname");
	//trigger_obj_01 waittill("trigger");
	//
	//level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	
	trigger = getent("trigger_savegame_catwalk2", "targetname");
	trigger waittill("trigger");
	
	//level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	level notify("checkpoint_reached"); // checkpoint 2
	
	trigger = getent("trigger_savegame_rope", "targetname");
	trigger waittill("trigger");
	
//	level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	
	//savegame("MiamiScienceCenter");
	//autosave_by_name("rope");
	
	thread initiate_rope_slide();

	level waittill("reached_bottom_of_rope");

	// make the doors stay open
	door_ent = getentarray("auto2652", "targetname");
	if(isdefined(door_ent))
	{
		for(i = 0; i < door_ent.size; i++)
		{
			door_ent[i]._doors_auto_close = false;
		}
	}

	level waittill("ACH_LOCK_PASS");

	// save so they don't have to hack again
	//level thread maps\_autosave::autosave_now("MiamiScienceCenter");
	level notify("checkpoint_reached"); // checkpoint 4
}
delete_aim_triggers()
{
	// delete the triggers that keep bond from clipping through the doors
	trigarray = getentarray("delete_after_trig", "script_noteworthy");
	if(isdefined(trigarray))
	{
		for(i = 0; i < trigarray.size; i++)
		{
			trigarray[i] delete();
		}
	}
}


///////////////////////////////////////////////////////////////////////////////////////
//	Level maps
///////////////////////////////////////////////////////////////////////////////////////
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

	// DCS: added vision change when exiting elevator shaft.
	//VisionSetNaked( "Sciencecenter_b_06", 2.0 );
	//setExpFog(708.895,1277.02,0.375,0.398438,0.4140063, 2.0);

	
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



///////////////////////////////////////////////////////////////////////////////////////
//	Setup guard to throw over rail
///////////////////////////////////////////////////////////////////////////////////////
setup_thug_overrail() // ludes
{	
	//level.thug = getent("thug_overrail", "targetname");
	//self SetCtxParam("Interact", "SpecialQKAnim", "Skylight_QK");

	self endon("death");
	self endon("alert_yellow");

	self thread check_thug_alert();
	
	// NOTE: check for red alert so we can make him do something per bug 16075 where he stays in suspicious state
	self thread check_for_red_alert();
	self StopPatrolRoute();	// stop patrol route to keep the vo from skipping, because the ai can hit goal twice

	// tanner talks to us right before this, so we don't want these walking all over each other
	level waittill("vo_start_tanner_done");
	wait(0.5);
	self play_dialogue("SSTM_SciBG02A_002A", false);	//This is Fuentes.  The door to the roof is locked.  All secure, over.
	wait(0.5);
	// have him do a talking on the phone animation or something, he looks funny doing nothing with VO going on
	self cmdaction("CheckEarpiece", true);
	
	self play_dialogue("SCS1_SciBG02A_003A", true);	//Roger that, Fuentes.  Head down to catwalk three, I need you to relieve Salter.
	wait(0.5);
	
	self play_dialogue("SSTM_SciBG02A_004A", false);	//On my way, over.
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
loop_action(action)
{
	self endon("death");
	while(1)
	{
		self CmdAction(action);
		self waittill("cmd_done");
		wait(0.05);
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
				// NOTE: give him perfect sense, per bug 16075 never gets out of suspicious
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


///////////////////////////////////////////////////////////////////////////////////////
//	Opening VO from Tanner
///////////////////////////////////////////////////////////////////////////////////////
vo_start_tanner()
{
	wait(1.0);
	level.player play_dialogue("TANN_SciBG_077A", true); // Bond, that helicopter that just went down.  Good work.
	wait(0.5);
	level.player play_dialogue("TANN_SciBG02A_001A", true);	// Now find a way to the other side of the main hall.  It looks like there are some catwalks you may be able to use.
	level notify("vo_start_tanner_done");
}



/////////////////////////////////////////////////////////////////////////////////////////
////	Guard waits until player sees him
/////////////////////////////////////////////////////////////////////////////////////////
//patrol_pause_stairwell()
//{
//	if (isdefined(self))
//	{
//		self pausepatrolroute();
//	}
//	
//	level waittill("resumepatrol");
//	
//	if (isdefined(self))
//	{
//		self resumepatrolroute();
//	}
//}



///////////////////////////////////////////////////////////////////////////////////////
//	Guard stops and looks out window
///////////////////////////////////////////////////////////////////////////////////////
patrol_stop_stairwell()
{
	while(isalive(self))
	{
		self CmdAction("fidget", true);
		
		wait(10.0);
	}
}



/////////////////////////////////////////////////////////////////////////////////////////
////	Door to first stairwell starts in the open position
/////////////////////////////////////////////////////////////////////////////////////////
//door_open_stairwell()
//{	
//	trigger = getent("trigger_open_door", "targetname");
//	trigger waittill("trigger");
//		
//	setSavedDvar("sf_compassmaplevel",  "level1");
//	thread map_level_1to2();
//}



/////////////////////////////////////////////////////////////////////////////////////////
////	Door closes to show player someone is on the other side
/////////////////////////////////////////////////////////////////////////////////////////
//door_close_stairwell()
//{
//	door_stairwell = getent("door_first_stairwell", "targetname");
//	trigger = getent("trigger_lookat_door", "targetname");
//	
//	trigger waittill("trigger");
//	
//	level notify("resumepatrol");
//	
//	wait(0.25);
//	
//	//door_stairwell maps\_doors::close_door();
//}

///////////////////////////////////////////////////////////////////////////////////////
//	Start catwalk1 guards on patrol when door opens
///////////////////////////////////////////////////////////////////////////////////////
start_catwalk1_patrol()
{
	self waittill("trigger");

	spawner01 = getent("guard_01_spawner", "targetname");
	if (IsDefined(spawner01))
	{
		guard = spawner01 stalingradspawn("guard_01");
		if(isdefined(guard))
		{
			guard thread watch_catwalk1_guard_alert_status();
		}
		// clean up the spawner
		spawner01 delete();
	}
	else
	{
		return;	//this function was already called somewhere else and we dont need it again.
	}

	spawner02 = getent("guard_02_spawner", "targetname");
	if (IsDefined(spawner02))
	{
		guard = spawner02 stalingradspawn("guard_02");
		if(isdefined(guard))
		{
			guard thread watch_catwalk1_guard_alert_status();
		}
		// clean up the spawner
		spawner02 delete();
	}
	
	thread catwalk_talk();
	thread door_catwalk2_right();
	thread door_catwalk2_left();
	thread check_catwalk2_reached();

	GetEnt("player_in_catwalk1a", "targetname") thread catwalk1_elites_a();
	GetEnt("player_in_catwalk1b", "targetname") thread catwalk1_elites_b();
}
watch_catwalk1_guard_alert_status()
{
	self endon("death");

	self waittill("start_propagation");

	//iprintlnbold("watch_guard_alert_status");

	level.catwalk1_red_alert = true;
	self setperfectsense(true);

	// also stop any vo they might be using	
	self play_dialogue("null_voice");
}
check_catwalk1_security_alert()
{
	while(1)
	{
		if(level.catwalk1_red_alert)
		{
			//iprintlnbold("check_security_alert");
			
			// let all hell break loose
			// spawn reinforcement guards
			thread spawn_catwalk1_reinforcement_elites();

			break;
		}

		wait(0.05);
	}
}
spawn_catwalk1_reinforcement_elites()
{
	// give the elites perfect sense
	elites = getentarray("catwalk1_elites", "targetname");
	if(isdefined(elites))
	{
		for(i = 0; i < elites.size; i++)
		{
			guard = elites[i] stalingradspawn();
			if(isdefined(guard))
			{
				//iprintlnbold("set perfect sense");
				guard setperfectsense(true);
				//iprintlnbold("set to rusher");
				guard setcombatrole("rusher");
			}
		}
	}
}

catwalk1_elites_a()
{
	while (true)
	{
		self waittill("trigger");

		//elites_off = GetEntArray("catwalk1_elites_a", "script_noteworthy");
		//for (i = 0; i < elites_off.size; i++)
		//{
		//	elites_off[i].count = 0;
		//}

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

		//elites_on = GetEntArray("catwalk1_elites_a", "script_noteworthy");
		//for (i = 0; i < elites_on.size; i++)
		//{
		//	elites_on[i].count = 1;
		//}
	}
}

//catwalk1()
//{
//	self waittill("trigger");
//
//	thread maps\miami_science_center_catwalk::start_catwalk1_patrol();
//}



///////////////////////////////////////////////////////////////////////////////////////
// Check 2nd catwalk reached before spawning guards
///////////////////////////////////////////////////////////////////////////////////////
check_catwalk2_reached()
{
	trigger = getent("trigger_catwalk2_reached", "targetname");
	trigger waittill("trigger");
		
	thread vo_catwalk2();

	// delete the trigger so there's no hitting it again
	if(isdefined(trigger))
		trigger delete();
}


///////////////////////////////////////////////////////////////////////////////////////
//	First catwalk guards behaviors
///////////////////////////////////////////////////////////////////////////////////////
catwalk_talk()
{
	// wait for both of the guards to get to the node and face each other
	thread sync_catwalk_talk();
	
	guard1 = GetEnt("guard_01", "targetname");
	if(isdefined(guard1))
		guard1 thread catwalk_talk_01();

	guard2 = GetEnt("guard_02", "targetname");
	if(isdefined(guard2))
		guard2 thread catwalk_talk_02();
}
catwalk_talk_01()
{
	self endon("death");
	level endon("catwalk1_alert");

	goal_node = getnode("guard1_talk_node", "targetname");
	self setgoalnode(goal_node);

	self waittill("goal");
	//iprintlnbold("01 goal");
	self waittill("facing_node");
	level.catwalk_talker1_ready = true;
	//iprintlnbold("01 facing");
	level waittill("synced");
	//iprintlnbold("01 synced");

	self play_dialogue("SCM1_SciBG02A_005A", false);	//How much longer 'til we wrap up?
	level notify("catwalk_talk_01_done");

	level waittill("catwalk_talk_02_done");
	//iprintlnbold("01 talk 02 done");
	self stopallcmds();
	self stoppatrolroute();
	wait(0.5);
	self startpatrolroute("catwalk1_patrol_route");
}
catwalk_talk_02()
{
	self endon("death");
	level endon("catwalk1_alert");

	goal_node = getnode("guard2_talk_node", "targetname");
	self setgoalnode(goal_node);

	self waittill("goal");
	//iprintlnbold("02 goal");
	self waittill("facing_node");
	level.catwalk_talker2_ready = true;
	//iprintlnbold("02 facing");
	level waittill("catwalk_talk_01_done");
	//iprintlnbold("02 talk 01 done");

	self play_dialogue("SCM2_SciBG02A_006A", false);	//The trucks are just about loaded.  Another hour will do it.

	self stopallcmds();
	self stoppatrolroute();
	wait(0.5);
	self startpatrolroute("catwalk2_patrol_route");
	//iprintlnbold("02 start patrol");
	wait(2.0);
	level notify("catwalk_talk_02_done");
}
sync_catwalk_talk()
{
	guard1 = GetEnt("guard_01", "targetname");
	if(isdefined(guard1))
		guard1 endon("death");

	guard2 = GetEnt("guard_02", "targetname");
	if(isdefined(guard2))
		guard2 endon("death");

	level endon("catwalk1_alert");

	level.catwalk_talker1_ready = false;
	level.catwalk_talker2_ready = false;
	while(	!level.catwalk_talker1_ready ||
			!level.catwalk_talker2_ready)
	{
		wait(0.05);
	}
	level notify("synced");
}

///////////////////////////////////////////////////////////////////////////////////////
//	VO for second and third catwalk
///////////////////////////////////////////////////////////////////////////////////////
vo_catwalk2()
{
	level.player play_dialogue("SCS1_SciBG02A_007A", true);		//Fuentes, what's your location?  Salter's still waiting, over.
	
	wait(1.5);
	
	level.player play_dialogue("SCS1_SciBG02A_008A", true);		//Salter, check on Fuentes, he's not responding.  Last location was the roof access stairwell.  Over.
	
	wait(0.5);
	
	while(!(level.catwalk2_door_open))
	{
		wait(0.1);
	}
	
	level.player play_dialogue("SSAL_SciBG02A_009A", true);		//Yes, sir.  Moving now, over.
	
	wait(0.5);
	
	level.player play_dialogue("SSAL_SciBG02A_010A", true);		//Reed!  You heard him.  Let's go.
	
	wait(0.5);
	
	level.player play_dialogue("SCS1_SciBG02A_011A", true);		//All teams, we have an intruder in the catwalks.
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

	if ( self IsOnPatrol() )
	{
		self PausePatrolRoute();
	}

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

	if ( self IsOnPatrol() )
	{
		self PausePatrolRoute();
	}

	wait 3;

	self CmdAction("fidget", true);
	self waittill("cmd_done");

	self ResumePatrolRoute();
}



///////////////////////////////////////////////////////////////////////////////////////
// Doors leading to second catwalk
///////////////////////////////////////////////////////////////////////////////////////
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



///////////////////////////////////////////////////////////////////////////////////////
//	Exploding tanks
///////////////////////////////////////////////////////////////////////////////////////
//exploding_tank_01()
//{
//	tank = getent("exploding_tank_01", "targetname");
//	explosion = getent("origin_tank_01", "targetname");
//	
//	while(isdefined(tank))
//	{
//		tank = getent("exploding_tank_01", "targetname");
//		wait(0.1);
//	}
//	
//	radiusdamage ( explosion.origin, 75, 200, 200 );
//	explosion playsound("Vehicle_Explosion_01");	
//}


helium_tank_setup()
{
    tank = GetEntArray ( "exploding_tank", "targetname" );
    for ( i = 0; i<tank.size; i++ )
    {
		tank[i].health = 150;
		tank[i] thread physic_tank_radius();
    }
}

//############################################################################
// Helium tanks wait for damage then explode
physic_tank_radius()
{
	self setcandamage(true);
	self waittill ( "damage" );
	self playsound("Vehicle_Explosion_01");	;
	self hide();
	wait( .1 );
	fx = playfx (level._effect["elev_expl"], self.origin);
	//physicsExplosionSphere( self.origin, 200, 100, 5 );
	radiusdamage( self.origin + ( 0, 0, 36 ), 100, 200, 200 );
	earthquake( 0.3, 1, self.origin, 400 );
}





	
///////////////////////////////////////////////////////////////////////////////////////
// Second catwalk patrol
///////////////////////////////////////////////////////////////////////////////////////
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



///////////////////////////////////////////////////////////////////////////////////////
// Third catwalk2 guards
///////////////////////////////////////////////////////////////////////////////////////
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
		
	level.guard_05 = getent("guard_05", "targetname");
	level.guard_06 = getent("guard_06", "targetname");
	
	//level.guard_05 settetherradius(12.0);
	//level.guard_06 settetherradius(12.0);
		
	thread spawn_catwalk2_final();
}



///////////////////////////////////////////////////////////////////////////////////////
// Final catwalk2 guards
///////////////////////////////////////////////////////////////////////////////////////
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
			guardarray[i] thread tether_at_goal(5.0);
		}
	}
	
	thread spawn_balance_mainhall();
	thread steam_balance_beam();
	thread vent_access_door();
	thread catwalk_guards_dead();
}
tether_at_goal(radius)
{
	self endon("death");
	self waittill("goal");

	self settetherradius(radius);
}


///////////////////////////////////////////////////////////////////////////////////////
// Steam from catwalk balance beam
///////////////////////////////////////////////////////////////////////////////////////
steam_balance_beam()
{
	//steam_tag = getent("tag_steam_balance", "targetname");
	//steam_tag = spawn("script_model", (-36, 2191, 740));
	//steam_tag setmodel("tag_origin");
	//if(isdefined(steam_tag))
	//{
		playfx(level._effect["steam_small"], (-36, 2191, 740));
		
		level waittill ( "basement" );
		
	//	steam_tag delete();
	//}
}



///////////////////////////////////////////////////////////////////////////////////////
// Spawn guards below catwalk balance beam
///////////////////////////////////////////////////////////////////////////////////////
spawn_balance_mainhall()
{
	//balance beam settings
	SetSavedDVar("bal_move_speed", 65.0);
	SetSavedDVar("bal_wobble_accel", 1.035);
	SetSavedDVar("bal_wobble_decel", 1.06);
	
	trigger = getent("trigger_balance_mainhall", "targetname");
	trigger waittill("trigger");
	
	// i think we need to turn off camera collision because a pipe is causing it to go down and back up while on the beam
	level.player customcamera_checkcollisions(0);

	thread show_ceiling(); // this is the trigger at the end of the balance beam
	thread show_ceiling_back(); // this is the trigger if they go back the way they came
	
	level notify("rope_dangle_start");
	
	level.ceiling_balance = getent("ceiling_balance", "targetname");
	level.ceiling_balance hide();
	
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
	// NOTE: have this guy die like the others that way he's not shooting at us, per bug 12103
	thug thread die_at_marker();

	wait(2.7);
	
	//dynEnt_StartPhysics("catwalk_light_balance");
	
	wait(5.0);
	
	//radiusdamage((thug.origin + (0, -10, 0)), 15, thug.health, thug.health);
	
	level.player play_dialogue("TANN_SciBG02A_012A", true);	//You're near one of the old air ducts, Bond.  It should take you to the main stairwell.
	
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
	self play_dialogue("SAM_E_1_McGS_Cmb", true);	//You're near one of the old air ducts, Bond.  It should take you to the main stairwell.
	wait(1.1);
	self play_dialogue("SAM_E_1_Flan_Cmb", true);	//You're near one of the old air ducts, Bond.  It should take you to the main stairwell.
	wait(1.3);
	self play_dialogue("SAM_E_4_Flan_Cmb", true);	//You're near one of the old air ducts, Bond.  It should take you to the main stairwell.
}

die_at_marker()
{
	self waittill("goal");
	self delete();
}




///////////////////////////////////////////////////////////////////////////////////////
// show the ceiling piece now that we're off the balance beam
///////////////////////////////////////////////////////////////////////////////////////
show_ceiling()
{
	trigger = getent("trigger_spawn_balance", "targetname");
	trigger waittill("trigger");
	
	level.ceiling_balance show();

	// turn camera collision back on because we turned it off at the start of the beam
	level.player customcamera_checkcollisions(1);
}
show_ceiling_back()
{
	trigger = getent("trigger_balance_mainhall", "targetname");
	trigger waittill("trigger");
	
	level.ceiling_balance show();

	// turn camera collision back on because we turned it off at the start of the beam
	level.player customcamera_checkcollisions(1);

	// setup this trigger again for when they decide to go the correct way
	trigger = getent("trigger_balance_mainhall", "targetname");
	trigger waittill("trigger");
	
	// i think we need to turn off camera collision because a pipe is causing it to go down and back up while on the beam
	level.player customcamera_checkcollisions(0);

	thread show_ceiling_back(); // this is the trigger if they go back the way they came
}



///////////////////////////////////////////////////////////////////////////////////////
// Delete guards who spawned below balance beam
///////////////////////////////////////////////////////////////////////////////////////
delete_mainhall_runners()
{
	self delete();
}



///////////////////////////////////////////////////////////////////////////////////////
// End battle music when all ai on catwalks are dead
///////////////////////////////////////////////////////////////////////////////////////
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
			//savegame("MiamiScienceCenter");
			//autosave_by_name("catwalk_end");
			
			// NOTE: this flag tells us to go to the next objective, moved it here per bug 16750
			flag_set("reached_stairwell");

			//level thread maps\_autosave::autosave_now("MiamiScienceCenter");
			level notify("checkpoint_reached"); // checkpoint 3
		}
		
		wait(0.5);
	}
}
			


///////////////////////////////////////////////////////////////////////////////////////
// Access door to rope slide
///////////////////////////////////////////////////////////////////////////////////////
access_door()
{
	doorarray = getentarray("vent_access_door", "targetname");
	wheelarray = getentarray("vent_access_wheels", "targetname");
	dooraccess = getent("vent_access_main", "targetname");
	
	//Steve G
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
	level notify("remove_vent_fx");//removing the effect on the vent
}



///////////////////////////////////////////////////////////////////////////////////////
//	Open vent access door to rope slide
///////////////////////////////////////////////////////////////////////////////////////
vent_access_door()
{
	level.vent_door = getent("vent_access_main", "targetname");

	// instead of player awareness we need a trigger so we can control the area where the user can do this
	trig = getent("open_vent_trig", "targetname");
	trig sethintstring(&"HINT_OPEN_VENT");
	trig waittill("trigger");

	access_door();

	trig delete();

	//maps\_playerawareness::setupEntSingleUseOnly(
	//	level.vent_door, 
	//	::access_door, 
	//	&"HINT_OPEN_VENT", 
	//	0, 
	//	"", 
	//	true, 
	//	true, 
	//	undefined, 
	//	undefined, 
	//	true, 
	//	false, 
	//	true);
}



///////////////////////////////////////////////////////////////////////////////////////
// Initiates rope slide in stairwell
///////////////////////////////////////////////////////////////////////////////////////
initiate_rope_slide()
{	
	level notify("endmusicpackage");
	
	level notify("rope_wiggle_start");
	
	//VisionSetNaked( "sciencecenter_b_03", 2);
	
	trigger = getent("trigger_rope_slide", "targetname");
	trigger sethintstring(&"HINT_ROPE_SLIDE");
	trigger waittill("trigger");
	
	thread stairs_path_center();
	
	wait(2.0);
	
	level notify("musicstinger_rope");
}
