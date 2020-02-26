// Airport event three file
// Builder: Brian Glines
// Scritper: Walter Williams
// Created: 10-08-2007

main()
{

				// save progression
				// savegame( "airport" );
				//level maps\_autosave::autosave_now( "airport" );

				// going to need a level var to check against for when to have the ai stop checking against the halon
				// level.halon = false;

				// flag that watches for stealth to be broken
				level thread e3_stealth_flag_set();

				// start the patrols
				// 05-21-08
				// wwilliams
				// this is now done in event two to facilitate the feed box in the virus download room
				// level thread e3_patrol_setup();

				// 02-13-08
				// wwilliams
				// moved the camera init function out into the main
				// cameras
				// 05-21-08
				// wwilliams
				// this is now done in event two to facilitate the feed box in the virus download room
				// level thread e3_cameras_init();

				// villiers
				level thread e3_villiers_dialogue();

				// thread the door opening for the command center
				level thread server_room_doors();

				// 03-28-08
				// wwilliams
				// sets up the functions to run off of the upload
				level thread e3_comp_settings();

				// 08-02-08 WWilliams
				// change the monitor model when hack is complete, change fog and all that jazz
				level thread e3_change_monitor_model();

				// 02-28-08
				// place the on_begin_use on the server room use
				// level thread e3_server_reset();

				// 02-15-08
				// wwilliams
				// moved this out of villier's dislogue because i have to hide the trigger before
				// the server reset happens	
				// halon gas mouse_trap
				//level thread e3_server_room_halon_init();

				// make the guys spawn in the server room once the player has uploaded the virus
				level thread e3_server_reaction();

				// fx for server room racks
				//////////////////////////////////////////////////////////////////////////
				// 05-21-08
				// wwilliams
				// commenting this out until inside alpha, these excess damage triggers are breaking the map
				//////////////////////////////////////////////////////////////////////////
				// level thread server_shot_setup();

				// runs on the player in order to make the halon gas reaction
				// 04-10-08
				// wwilliams
				// changing this to be called on teh destructible
				// level.player thread e3_player_halon_react();

				// this function controls the door in all the states
				level thread e4_server_room_door();

				// 02-13-08
				// wwilliams
				// moveing the call for the clean up outside of the end_event_three function
				// this seemed to fix problems in event two
				// hoping it will do the same here
				// run the clean up function
				level thread e3_clean_up();

				// 02-12-08
				// wwilliams
				// adding the clean up function call to teh end event call
				level thread end_event_three();

				// waits for notify before ending main function of event 3
				level waittill( "event_three_done" );

}
// ---------------------//
// 04-09-08
// changes this to follow new security camera rules
// there will be one guy on patrol
// and one guy at the computer
// this function is called by ending the hack from teh second area
e3_patrol_setup()
{
	// endon

	// objects to be defined for this function
	// ents (spawners)
	patrol_spawner = getent( "spwn_e3_lower_patrol", "targetname" );
	computer_spawner = getent( "spwn_e3_computer", "targetname" );
	// nodes
	// going to run the function on the spawners and have the info come from them
	// nod_e3_server_guard = getnode( "nod_e3_server_guard", "targetname" );
	// nod_e3_top_patrol_wait = getnode( "nod_e3_top_patrol_wait", "targetname" );
	// nod_e3_bottom_patrol_wait = getnode( "nod_e3_bottom_patrol_wait", "targetname" );
	// double check that there is a target on each spawner
	// patrol_spawner
	if( !isdefined( patrol_spawner.target ) )
	{
		// debug text
		//iprintlnbold( "patrol_spawner missing target" );

		// end function
		return;
	}
	// computer_spawner
	if( !isdefined( computer_spawner.target ) )
	{
		// debug text
		//iprintlnbold( "computer_spawner missing target" );
	}
	// nodes
	nod_patrol_convo = getnode( patrol_spawner.target, "targetname" );
	nod_computer_convo = getnode( computer_spawner.target, "targetname" );
	// undefined
	temp_ent = undefined;

	// make the spawner count big enough
	patrol_spawner.count = 1;
	computer_spawner.count = 1;

	// wait a frame to make sure the last if is done
	wait( 0.05 );

	// spawn out the guys for the area and thread functions on them
	// patroller
	temp_ent = patrol_spawner stalingradspawn( "e3_enemy" );

	// make sure the spawn worked
	// if it failed
	if( maps\_utility::spawn_failed( temp_ent ) )
	{
		// debug text
		//iprintlnbold( "patrol_spawner spawn fail" );

		// end function
		return;
	}
	// if it passed
	else
	{
		// thread the function on the patrol guy
		temp_ent thread e3_bottom_patrol( nod_patrol_convo );

		// undefine temp_ent
		temp_ent = undefined;

		// quick wait
		wait( 0.05 );
	}

	// computer guard
	temp_ent = computer_spawner stalingradspawn( "e3_enemy" );

	// make sure the guy spawns out properly
	// if it fails
	if( maps\_utility::spawn_failed( temp_ent ) )
	{
		// debug text
		//iprintlnbold( "computer_spawner spawn fail" );

		// end function
		return;
	}
	else
	{
		// thread the function on the guy
		temp_ent thread e3_computer_patrol( nod_computer_convo );
		//temp_ent thread computer_guard_check_alert();

		//// 08-17-08
		//// aeady
		//// there's a trigger to wake up the typing AI if the user gets in his peripheral vision (bug 19608)
		//temp_ent thread watch_laptop_peripheral_vision();


		// undefine temp_ent
		temp_ent = undefined;

		// quick wait
		wait( 0.05 );
	}
}
//watch_laptop_peripheral_vision()
//{
//	self endon("death");
//
//	trig = getent("awake_laptop_guy_trig", "targetname");
//	if(isdefined(trig))
//	{
//		//iprintlnbold("trigger wait");
//		trig waittill("trigger");
//	}
//	else
//		return;
//
//	// wake the AI
//	//iprintlnbold("wake AI");
//	self stopallcmds();
//	wait(0.05);
//	self animscripts\shared::placeWeaponOn(self.weapon, "right");
//	self setenablesense(true);
//	self setperfectsense(true);
//}
//// DCS : check alert state of computer guard.  If alerted wake up, run out and lock door.
//computer_guard_check_alert()
//{
//	self endon( "death" );
//
//	goto_alerted = getnode( "camera_guard_alerted", "targetname" );
//	e3_lockdoor = getent( "ent_e3_antiv_enter", "targetname" );
//	//e3_lockdoor_node = getnode( "e3_lockdoor_node", "script_noteworthy" );
//	
//	if( self getalertstate() != "alert_red" )
//	{
//		self waittill( "start_propagation" );
//	}
//
//	if(IsDefined(self) && distance(level.player.origin, self.origin) > 128)
//	{
//		self SetScriptSpeed("Run");
//		self setenablesense(false);
//		self setgoalnode(goto_alerted);
//		self waittill("goal");
//		
//		self setenablesense(true);
//		self SetScriptSpeed("default");
//		self setperfectsense(true);
//		self addengagerule("tgtperceive");
//		e3_lockdoor maps\_doors::close_door();
//	}
//
//}
//////////////////////////////////////////////////////////////////////////
// 05-21-08
// wwilliams
// new way for two patrollers in event three act
// this controls the computer enemy
// runs on the self/npc
e3_computer_patrol( nod_start )
{
//iprintlnbold("computer guy start");
	// endon
	level.player endon( "death" );
	self endon( "death" );
	self endon( "damage" );

	//// objects to define for the function
	//// nodes
	//nod_e3_server_guard = getnode( "nod_e3_server_guard", "targetname" );

	//// set the guy up for Michel
	////self setalertstatemin( "alert_yellow" );
	//self setscriptspeed( "walk" );
	//self setenablesense( false );
//iprintlnbold("1");

	//// function to change script speed to normal
	//self thread maps\airport_util::reset_script_speed();
//iprintlnbold("2");

	// first off make him walk to his talk node
	self setgoalnode( nod_start );
//iprintlnbold("3");

	// wait for the guy to reach the node
	self waittill( "goal" );
//iprintlnbold("4");

	// thread him into a constant anim
	self thread air_play_anim( "TalkA1", "stop_looping_anim" );
//iprintlnbold("5");

	// wait for teh flag that the player has finished zone 2
	level maps\_utility::flag_wait( "objective_2" );
//iprintlnbold("6");

	// send notify to self to stop the anim
	self notify( "stop_looping_anim" );

	// send notify to guy to stop animating
	// self notify( "cmd_done" );

	// stop all commands on the guy
	self stopallcmds();

	// turn the ai back on
	self setenablesense( true );

	// run the function that watches self alert state
	// this is called on the guy in  server_guard_animation(), but we aren't calling that anymore
	self thread maps\airport_util::event_enemy_watch( "e3_stealth_cancelled", "e3_stealth_broken" );

	//// send him to the server guard node
	//self.goalradius = 12;
	//self setgoalnode( nod_e3_server_guard );
//iprintlnbold("7");

	//// run the server guard function on him
	//self thread server_guard_animation();
//iprintlnbold("8");
}
//////////////////////////////////////////////////////////////////////////
// 05-21-08
// wwilliams
// plays an animation on a guy endlessly,
// if you use this make sure you call stopallcmds() on the ent when you want
// it to stop
// runs on self/NPC
air_play_anim( str_animation, str_endon )
{
				// endon
				level.player endon( "death" );
				self endon( "death" );
				self endon( "damage" );
				self endon( str_endon );

				// make sure an animation was passed in
				assertex( isdefined( str_animation ), "animation not defined for air_play_anim" );

				// while
				while( 1 )
				{
								// play anim
								self CmdAction( str_animation );

								// quick wait
								wait( 0.05 );

								// wait for the animation to complete
								self waittill( "cmd_done" );
				}
}
//////////////////////////////////////////////////////////////////////////
// ---------------------//
// 02-13-08
// wwilliams
// sets all the parameters up on the e3 top patrol guy
// runs on self
// 04-09-08
// function is no longer used
// new security camera rules dictate only one moving and one stationary guy in the area
// it will be one guy on a longer path
// commenting this out
/*e3_top_patrol()
{
// endons
self endon( "death" );
self endon( "damage" );

// wait for goal
self waittill( "goal" );

// 02-13-08
// wwilliams
// using the new airport_utils made for watching the stealth
// run the functions that watch his alert state
self thread maps\airport_util::event_enemy_watch( "e3_stealth_cancelled", "e3_stealth_broken" );

// wait for the notify to start 
level waittill( "start_e3_patrols" );

// start this guy on his patrol route
self startpatrolroute( "nod_e3_top_patrol" );

}*/
// ---------------------//
// wwilliams 11-15-07
// run the typing cmdaction on the guy at the server desk 
server_guard_animation()
{
	// endon
	self endon( "death" );
	//self endon( "damage" );
	//level endon( "e3_stealth_cancelled" );

	// run the function that checks to see if the player breaks stealth
	self thread maps\airport_util::event_enemy_watch( "e3_stealth_cancelled", "e3_stealth_broken" );

	// get teh ai there
	self waittill( "goal" );
	self animscripts\shared::placeWeaponOn(self.weapon, "none");

	while( self getalertstate() == "alert_green" )
	{
		// run the cmdaction
		self cmdplayanim( "thu_laptop_lowersurface" );

		self waittill( "cmd_done" );
		// frame wait to avoid a infinite loop
		wait( 0.05 );
	}
	self animscripts\shared::placeWeaponOn(self.weapon, "right");
}
// ---------------------//
// 02-13-08
// wwilliams
// runs the lower patrol guy in event 3
// runs on self
e3_bottom_patrol( nod_start )
{
				// endons
				level.player endon( "death" );
				self endon( "death" );
				self endon( "damage" );

				// set the guy up
				self setalertstatemin( "alert_yellow" );
				self setscriptspeed( "walk" );
				self setenablesense( false );

				// function to change script speed to normal
				self thread maps\airport_util::reset_script_speed();

				// first off make him walk to his talk node
				self setgoalnode( nod_start );

				// wait for the guy to reach the node
				self waittill( "goal" );

				// thread him into a constant anim
				self thread air_play_anim( "TalkA2", "stop_looping_anim" );

				// wait for teh flag that the player has finished zone 2
				level maps\_utility::flag_wait( "objective_2" );

				// send notify to self to stop the anim
				self notify( "stop_looping_anim" );

				// stop all commands on the guy
				self stopallcmds();

				// turn the ai back on
				self setenablesense( true );

				// run the function that watches self alert state
				self thread maps\airport_util::event_enemy_watch( "e3_stealth_cancelled", "e3_stealth_broken" );

				// start patrol
				// calling the patrol on the guy as he spawns out
				self startpatrolroute( "nod_e3_patrol" );

				// wait for the guy to make it to his goal
				// no longer waiting for goal
				// self waittill( "goal" );

				// send out the notify to start the patrols
				// no longer syncing two patrols
				// level notify( "start_e3_patrols" );



}
// ---------------------//
// 02-13-08
// wwilliams
// adding the flag check for event three's stealth
e3_stealth_flag_set()
{
	level endon("e3_clean_up");

	// 02-12-08
	// wwilliams
	// define the objects needed for this function
	spawner = getent( "spwn_e3_backup_a", "targetname" );
	spawner_2 = getent( "spwn_e3_backup_b", "targetname" );
	// nodes to defend around
	noda_e3_defense = getnodearray( "nod_e3_backup_a", "targetname" );
	noda_e3_defense_2 = getnodearray( "nod_e3_backup_b", "targetname" );

	// nod_e3_backup_1 = getnode( "nod_e3_backup1_start", "targetname" );
	// nod_e3_backup_2 = getnode( "nod_e3_backup2_start", "targetname" );

	// wait for notify that stealth is broken
	level waittill( "e3_stealth_broken" );

	// send out the notify to turn off all the other threads waiting
	level notify( "e3_stealth_cancelled" );

	// change the flag
	level maps\_utility::flag_set( "e3_stealth_broken" );

	// run the backup function
	level thread maps\airport_util::spawn_event_backup_init( spawner, noda_e3_defense );
	level thread maps\airport_util::spawn_event_backup_init( spawner_2, noda_e3_defense_2 );
}
// ---------------------//
// 03-17-08
// wwilliams
// opens the hack door right away
e3_server_room_door( player )
{
				// endon

				// define the objects needed for the function



}
// ---------------------//
// 03-17-08
// wwilliams
// function closes the door 
e3_comp_settings()
{
				// the first computer is placed into a array accessible by the entire level
				// this will set the function to run when the player starts the virus download
				level.computer_array[2] maps\_useableobjects::set_on_begin_use_function( ::e3_started_av_dl );

				// this will set which function runs once the player has finished the virus download
				level.computer_array[2] maps\_useableobjects::set_on_end_use_function( ::e3_change_monitor_model );


}
// ---------------------//
// 03-28-08
// wwilliams
// changes teh model of the monitor to show that the machine has shut down after the virus is
// runs on the player
e3_change_monitor_model()
{
	
				// 08-02-08 WWilliams
				// wait for the objective to complete
				level maps\_utility::flag_wait( "objective_3" );

				computer = getent( "ent_air_comp_3", "targetname" );

				// set model on the first monitor
				computer setmodel( "p_dec_tv_plasma" );

				// change the visionset
				Visionsetnaked( "airport_server_room" );

				// set the fog value
				SetExpFog( 500, 600, 0.27, 0.28, 0.32, 1.0, 0 );
				// setDvar( "scr_max", "0" );

				// add the call for the airport_challenge_achievement
				level thread airport_challenge_achievement();

				// DCS: Demo mode ends here.
				if( Getdvar( "demo" ) == "1" )
				{
					level maps\_endmission::nextmission();
				}

				// DCS 
				//disable e3 cameras and close door.
				//level notify("e3_stealth_cancelled");
				e3_lockdoor = getent( "ent_e3_antiv_enter", "targetname" );
				e3_lockdoor maps\_doors::close_door();
				
				// DCS: remove any possible remaining enemy from before server room.
				e3_enemy_array = getentarray("e3_enemy", "targetname");
				if(IsDefined(e3_enemy_array) && e3_enemy_array.size > 0)
				{
					for(i=0; i< e3_enemy_array.size; i++)
					{
						e3_enemy_array[i] delete();
					}	 
				}
				// DCS: and the elites.	
				e3_patroller_array = getentarray("e3_patroller", "targetname");
				if(IsDefined(e3_patroller_array) && e3_patroller_array.size > 0)
				{
					for(i=0; i< e3_patroller_array.size; i++)
					{
						e3_patroller_array[i] delete();
					}	 
				}
				
				
				

}
// ---------------------//
// wwilliams 10-26-07
// controls the cameras that scan the third area
e3_cameras_init()
{
				// endon
				level endon( "event_three_done" );

				// entity objects to define for this function
				e3_camera_1 = getent( "ent_e3_camera_1", "targetname" );
				e3_camera_2 = getent( "ent_e3_camera_2", "targetname" );
				// feed box
				e3_feed_box = getent( "air_e3_feed_box", "targetname" );

				// trig objects to define for this function
				// 04-09-08
				// removing old triggers used for hacking cams
				// trig_e3_disable_cam1 = getent( "trig_e3_cam1_disable", "targetname" );
				// trig_e3_disable_cam2 = getent( "trig_e3_cam2_disable", "targetname" );

				// frame wait
				wait( 0.05 );

				// 04-09-08
				// wwilliams
				// new hack box ents for the right way to have security cameras
				e3_cam1_hack_box = getent( e3_camera_1.script_parameters, "targetname" );
				e3_cam2_hack_box = getent( e3_camera_2.script_parameters, "targetname" );

				// start cameras
				e3_camera_1 thread maps\_securitycamera::camera_start( e3_cam1_hack_box, true, true, false );
				e3_camera_2 thread maps\_securitycamera::camera_start( e3_cam2_hack_box, true, true, false );

				// 02-13-08
				// wwilliams
				// sets the three cameras into a array and uses teh cam_array function on them
				// WW 07-08-08, feed boxes now run on side script orgs to display an area
				
				// 08/13/08 jeremyl added all cameras to both feedbox
				enta_e1_cams = getentarray( "air_feedbox_one", "targetname" );
				//e3_cam_array = getentarray( "air_feedbox_two", "targetname" );

				// put the cameras in an array so I can change the render to texture
				// e3_cam_array = maps\_utility::array_add( e3_cam_array, e3_camera_1 );
				// wait( 0.05 );
				// e3_cam_array = maps\_utility::array_add( e3_cam_array, e3_camera_2 );

				// set up the script origins as cameras
				for( i=0; i<enta_e1_cams.size; i++ )
				{
								// set up each script org as a camera
								enta_e1_cams[i] thread maps\_securitycamera::camera_start( undefined, false, undefined, undefined );
				}

				// 05-21-08
				// wwilliams
				// set up the feed box for zone 3
				
				// 08/13/08 jerremyl added camera 1 ent array to this feedbox.
				level thread maps\_securitycamera::camera_tap_start( e3_feed_box, enta_e1_cams );
				//level thread maps\_securitycamera::camera_tap_start( e3_feed_box, e3_cam_array );

				// still need to run the camera function from event two after putting that in the airport_util

				// 02-13-08
				// wwilliams
				// new way of watching the cameras to see if stealth is broken
				e3_camera_1 thread maps\airport_util::event_camera_watch( "e3_stealth_cancelled", "e3_stealth_broken" );
				e3_camera_2 thread maps\airport_util::event_camera_watch( "e3_stealth_cancelled", "e3_stealth_broken" );

				// function watches for damage to the camera and break stealth
				e3_camera_1 thread maps\airport_util::event_camera_destroyed( "e3_stealth_cancelled", "e3_stealth_broken" );
				e3_camera_2 thread maps\airport_util::event_camera_destroyed( "e3_stealth_cancelled", "e3_stealth_broken" );

				// function disables the cameras once the player breaks stealth in the area
				e3_camera_1 thread maps\airport_util::event_camera_disable( "e3_stealth_cancelled" );
				e3_camera_2 thread maps\airport_util::event_camera_disable( "e3_stealth_cancelled" );

				// function that watches for player disabling the camera
				// 04-09-08
				// removing the old way of hacking the cam to the proper way
				// e3_camera_1 thread maps\airport_util::player_camera_disable( trig_e3_disable_cam1 );
				// e3_camera_2 thread maps\airport_util::player_camera_disable( trig_e3_disable_cam2 );

				// level thread maps\_securitycamera::camera_render_switch( e3_cam_array, 3.0, "airport_cam_end" );


}

temp_e3_exit_door()
{
				//endon

				// stuff
				e3_exit_door = getent( "ent_e3_exit_door", "targetname" );
				trig = getent( "ent_close_e3_exit", "targetname" );

				e3_exit_door connectpaths();

				e3_exit_door notsolid();
				e3_exit_door rotateyaw( -120, 1.0 );
				e3_exit_door waittill( "rotatedone" );
				e3_exit_door solid();

				level maps\_utility::flag_wait( "objective_3" );

				trig waittill( "trigger" );

				//level notify( "no_more_strobe" );

				e3_exit_door notsolid();
				e3_exit_door rotateyaw( 120, 0.5 );
				e3_exit_door waittill( "rotatedone" );
				e3_exit_door solid();


}
// ---------------------//
// wwilliams 11-05-07
// mock up of the environmental mousetrap: halon
// bond turns on the server fire retardant system, disorients NPCs that run through them
//e3_server_room_halon_init()
//{
//				// endon
//				// single shot function
//
//				// objects to be defined for this function
//				// ent (halon_tank_array)
//				enta_halon_tanks = getentarray( "ent_halon_tank", "targetname" );
//
//				// frame wait
//				wait( 0.05 );
//
//				// run a function on the level for each tank
//				for( i=0; i<enta_halon_tanks.size; i++ )
//				{
//								// run a function on the tank to watch for the death
//								enta_halon_tanks[i] thread e3_halon_tank_death();
//
//								// frame wait
//								wait( 0.05 );
//				}
//
//				// finished
//
//
//				/*	// endon
//				// level endon( "event_three_done" );
//				// level endon( "halon_disable" );
//
//				// stuff
//				// start_trig = getent( "trig_start_halon_event", "targetname" );
//
//				// move it down until the server reset
//				//start_trig moveto( start_trig.origin + ( 0, 0, -500 ), 0.1 );
//				// start_trig maps\_utility::trigger_off();
//
//				// 02-15-08
//				// wwilliams
//				// function holds this trigger and gets rid of it when the event is over
//				start_trig thread e3_halon_start_trig_off();
//
//				// 02-15-08
//				// wwilliams
//				// adding this so i can move the trigger back into place once the player
//				// has reset the server room
//				// wait for the player to upload the virus
//				// 02-26-08
//				// wwilliams
//				// this needs to go off immediately since it will be called on use of the antivirus
//				level maps\_utility::flag_wait( "e3_antivirus_started" );
//
//				// run the halon event once to show what happens
//				// notify the level
//				level notify( "halon_on" );
//
//				// wait
//				wait( 11 );
//
//				// 02-15-08
//				// wwilliams
//				// need to tell the triggers when to drop again
//				// notify the trigger function that halon is over
//				level notify( "halon_off" );
//
//				// 02-15-08
//				// wwilliams
//				// moved the trigger back to the normal spot
//				// move the trigger back up
//				//start_trig moveto( start_trig.origin + ( 0, 0, 500 ), 0.1 );
//				start_trig maps\_utility::trigger_on();
//
//				// 02-13-08
//				// wwilliams
//				// send out a notify when this is done so the door opening animation takes place and the guys spawn out
//				// level notify( "e4_halon_finished" );
//				// changed how the halon works, can't wait for a notify anymore
//				// quicker to set a flag
//				level maps\_utility::flag_set( "e3_door_kick" );
//
//				while( 1 )
//				{
//
//				// wait for the player to hit the trigger
//				start_trig waittill( "trigger" );
//
//				// 02-15-08
//				// wwilliams
//				// move the trigger down until the event is over
//				// start_trig moveto( start_trig.origin + ( 0, 0, -500 ), 0.1 );
//				start_trig maps\_utility::trigger_off();
//
//				// notify the level
//				level notify( "halon_on" );
//
//				// 02-15-08
//				// wwilliams
//				// change the level var about halon
//				level.halon = true;
//
//				// wait
//				wait( 11 );
//
//				// notify the trigger function that halon is over
//				level notify( "halon_off" );
//
//				// 02-15-08
//				// wwilliams
//				// change the level var about halon
//				level.halon = false;
//
//				// 02-15-08
//				// wwilliams
//				// move the trigger back up
//				// start_trig moveto( start_trig.origin + ( 0, 0, 500 ), 0.1 );
//				start_trig maps\_utility::trigger_on();
//
//				}*/
//
//}
// ---------------------//
// 04-10-08
// wwilliams
// function watches for the passed in tank to recieve a death message
// then will run the functions that check for the ai and the player
//e3_halon_tank_death()
//{
//				// endon
//				// single shot function, but let's have a backup to get rid of the thread as the 
//				// player leaves lugg1, need a notify from that
//				level endon( "e4_halon_off" );
//
//				// just wait for the halon tank to notify death
//				self waittill( "death" );
//
//				// run the function for this tank that affects AI
//				// self thread e3_npc_halon_reaction_init();
//				// 05-21-08
//				// wwilliams
//				// new way of doing this
//				RadiusDamage( ( self.origin + ( 0, 0, -40 ) ), 48, 15, 1, self, "MOD_COLLATERAL" );
//
//				// run the function for this tank that affects the player
//				// self thread e3_player_halon_react();
//
//				// the time count that turns off the reaction functions
//				// self thread e3_halon_time();
//
//}
// ---------------------//
// 04-10-08
// wwilliams
// function that waits the amount of time the halon takes
// current lenght is ten seconds
// runs on the self/tank
//e3_halon_time()
//{
//				// endon
//
//				// wait call
//				wait( 10.0 );
//
//				// send a notify to the self
//				self notify( "halon_complete" );
//
//}
// ---------------------//
// 03-17-08
// wwilliams
// function sets off the halon gas by setting a flag
e3_started_av_dl( player )
{

				// player started the antivirus upload
				level maps\_utility::flag_set( "e3_antivirus_started" );

}
// ---------------------//
// 03-17-08
// wwilliams
// server room door control
// this opens the door at the beginning of the event
// and then closes it once the player starts the upload
e4_server_room_door()
{
	// endon
	// not needed, single shot function

	// objects to be defined for this function
	e4_server_enterance = getent( "ent_e3_antiv_enter", "targetname" );
	//e4_noda_door_begin = getnodearray( e4_server_enterance.target, "targetname" );

	//// open the door
	//e4_noda_door_begin[0] maps\_doors::open_door();
	
	// wait for the player to start the upload
	level maps\_utility::flag_wait( "e3_antivirus_started" );

	// close the door
	e4_server_enterance maps\_doors::close_door();

	// change the door attibutes to stay close
	// e4_server_enterance._doors_barred = true;
	e4_server_enterance maps\_doors::barred_door();
}
// ---------------------//
// WW 07-01-08
// function checks to see if the player stealthed the office area
// if all teh flags come back clear then the player recieves the 
// challenge achievement
airport_challenge_achievement()
{
				// endon
				// single shot function

				// check to see if all three flags are not set
				if( !maps\_utility::flag( "e1_stealth_broken" ) && !maps\_utility::flag( "e2_stealth_broken" ) && !maps\_utility::flag( "e3_stealth_broken" ) )
				{
								// award achievement
								GiveAchievement( "Challenge_Airport" );
								
								//iprintlnbold("challenge achievement earned");
				}
				else
				{
					/*  DCS: not prints in shipping game.
								// debug text
								iprintlnbold( "failed stealthing office areas" );

								if( maps\_utility::flag( "e1_stealth_broken" ) )
								{
												iprintlnbold( "broke stealth in area 1" );
								}
								else if( maps\_utility::flag( "e2_stealth_broken" ) )
								{
												iprintlnbold( "broke stealth in area 2" );
								}
								else if( maps\_utility::flag( "e3_stealth_broken" ) )
								{
												iprintlnbold( "broke stealth in area 3" );
								}
					*/
				}
}
// ---------------------//
// 02-15-08
// wwilliams
// will bring up the trigger to register halon is on
// will also send out a notify ai functions to cause flashbang anims to play if
// the ai is touching the trigger
//halon_trig_move()
//{
//				// endon
//				// needs to end with the end of the level
//
//				// define the triggers that will move
//				triga_halon_regist = getentarray( "trig_halon_gas_on", "targetname" );
//
//				// move the triggers down right away
//				for( i=0; i<triga_halon_regist.size; i++ )
//				{
//								// move each trigger down 200 units
//								triga_halon_regist[i] moveto( triga_halon_regist[i].origin + ( 0, 0, -200 ), 0.05 );
//
//								// need a wait to keep the potential infinite script warning away
//								wait( 0.05 );
//				}
//
//				// while loop so the effect can be played over and over again
//				while( 1 )
//				{
//								// wait for the notify to turn the halon on
//								level waittill( "halon_on" );
//
//								// move the triggers up to the right area
//								for( i=0; i<triga_halon_regist.size; i++ )
//								{
//												// move each trigger down 200 units
//												triga_halon_regist[i] moveto( triga_halon_regist[i].origin + ( 0, 0, 200 ), 0.05 );
//
//												// need a wait to keep the potential infinite script warning away
//												wait( 0.05 );
//								}
//
//								// wait for the notify that the halon event is complete
//								level waittill( "halon_off" ); 
//
//								// move the triggers out of the world again
//								for( i=0; i<triga_halon_regist.size; i++ )
//								{
//												// move each trigger down 200 units
//												triga_halon_regist[i] moveto( triga_halon_regist[i].origin + ( 0, 0, -200 ), 0.05 );
//
//												// need a wait to keep the potential infinite script warning away
//												wait( 0.05 );
//								}
//
//				}Entity 0, Brush 57: origin brushes not allowed in world
//
//}
// ---------------------//
// 04-10-08
// wwilliams
// function will make sure the animation plays as long as the AI is in range
// runs on the self/tank
//e3_halon_npc_hit( enemy )
//{
//				// endon
//				self endon( "death" );
//
//				// while loop keeps checking
//				while( 1 )
//				{
//								// check the distance
//								if( distance2d( self.origin, enemy.origin ) < 45 )
//								{
//												// play the animation on the guy in the array
//												enemy cmdplayanim( "Thu_Stand_Pain_Front_Idle_FlashBang_Pistol", true );
//
//												// wait for the cmd action to finish
//												enemy waittill( "cmd_done" );
//
//								}
//
//								// frame wait
//								wait( 0.05 );
//				}
//
//}
// ---------------------//
// 02-15-08
// wwilliams
// runs on ai to see if they are touching a halon trigger
// if they hit one then it should make them play a flashbang animation
// runs on self
// 04-10-08
// this now runs on teh destructible tank itself
// all tanks are 120 units from teh floor
// this one will grab all the ai alive in an array and check to see if they are close to the effect
//e3_npc_halon_reaction_init()
//{
//				// endon
//				// have to see if the destructible has a notify when teh fx is done
//				self endon( "halon_complete" );
//
//				// define an array to put all the ai in
//				/* enta_halon_ai = getaiarray();
//
//				// while loop keeps checking in case a guy runs into it while the gas is dropping
//				while( 1 )
//				{
//				// now that you have the whole array check the distance of the guys to the array
//				for( i=0; i<enta_halon_ai.size; i++ )
//				{
//				// double check that the ai is alive,
//				// in case the player kills one of them
//				if( isalive( enta_halon_ai[i] ) )
//				{
//				// check to see if the ai is within the range of the gas
//				if( distance2d( self.origin, enta_halon_ai[i].origin ) < 45 )
//				{
//				// run the function on the guy to make him flashbang anim
//				self thread e3_halon_npc_hit( enta_halon_ai[i] );
//				}
//				}
//
//
//				}
//
//				// frame wait
//				wait( 0.05 );
//				}
//
//
//
//				// self endon( "death" );
//				// level endon( "halon_disable" );
//				// should also end if the event ends or when i stop allowing halon to emit
//
//				// grab the arrary of triggers
//				triga_e4_halon_check = getentarray( "trig_halon_gas_on", "targetname" );
//
//				// wait for the notify that sends the guys into the room
//				// level waittill( "e4_halon_finished" );
//				// changing this to check for a flag to be set
//				// changed how the halon works, can't wait for a notify anymore
//				// quicker to check a flag
//				while( !level maps\_utility::flag( "e3_door_kick" ) )
//				{
//				wait( 0.5 );
//				}
//
//
//				// while loop
//				while( 1 )
//				{
//				// wait for the notify to the level that the halon is on
//				level waittill( "halon_on" );
//
//				// start checking for the ai to touch the triggers
//				while( level.halon == true )
//				{
//				for( i=0; i<triga_e4_halon_check.size; i++ )
//				{
//				if( self istouching( triga_e4_halon_check[i] ) )
//				{
//				self cmdplayanim( "Thu_Stand_Pain_Front_Idle_FlashBang_Pistol", true );
//				iprintlnbold( "flashbang_anim_play" );
//				wait( 1.0 );
//				}
//				else
//				{
//				wait( 0.5 );
//				}
//				}
//
//				// a wait before looping through all the triggers again
//				wait( 0.1 );
//				}
//
//				}*/
//
//}
// ---------------------//
// 02-15-08
// wwilliams
// player's reaction to the halon
// this will play an fx if the player is in the halon trigger
//e3_player_halon_react()
//{
//				// endon
//				// this will be if there is a notify sent from the tank
//				self endon( "halon_complete" );
//
//				// objects to define for this function
//				// undefined
//				ply_dist = undefined;
//				flt_blur = undefined;
//				flt_time = undefined;
//
//				// need to check for the player's distance, and change the blur according to the distance
//				while( 1 )
//				{
//								// check the player's distance
//								ply_dist = distance2d( level.player.origin, self.origin );
//
//								// first check to see if the player is really close
//								// if so raise the blur alot
//								if( ply_dist < 20 )
//								{
//												// set a high blur
//												flt_blur = 15.0;
//
//												// set the amount of time
//												flt_time = 0.5;
//
//												// run the set blur function
//												setblur( flt_blur, flt_time );
//
//								}
//								else if( ply_dist < 50 )
//								{
//												// set a medium blur
//												flt_blur = 7.5;
//
//												// set the amount of time
//												flt_time = 0.5;
//
//												// set blur function
//												setblur( flt_blur, flt_time );
//								}
//								else if( ply_dist > 60 )
//								{
//												// set no blur
//												flt_blur = 0;
//
//												// set the amount of time
//												flt_time = 1.0;
//
//												// set the blur
//												setblur( flt_blur, flt_time );
//								}
//
//								// wait before the next check
//								wait( flt_time + 1.0 );
//
//				}
//}
// ---------------------//
// 02-12-08
// wwilliams
// this function setups the spawn for the server room
// also starts the door kick event
e3_server_reaction()
{
				//endon

				// DCS: shut off ai chat during intro to server room.
				SetSavedDVar( "ai_ChatEnable", "0" );

				// objects to define for this function
				spawner_1 = getent( "spwn_e3_server_fight_a", "targetname" );

				// define nodes needed for this function
				nod_server_yeller = getnode( "nod_e3_server_yeller", "targetname" );
				noda_server_fight_b = getnodearray( "nod_server_fight_b", "targetname" );
				nod_server_tether = GetNode( "e3_server_main_tether", "targetname" );

				// 02-21-08
				// wwilliams
				// double check size of spawner_1 and spawner_2
				spawner_1.count = 5;


				// 03-25-08
				// wwilliams
				// waits for the flag that the upload is complete
				level maps\_utility::flag_wait( "objective_3" );

				// turn off sun shadows (they were only needed for hack 1 and hack 2)
				setdvar("sm_sunshadowenable", 0);

				// clean up all old ai
				thread maps\airport_util::clean_up_old_ai_except("server_enemy");


				// 02-21-08
				// wwilliams
				// spawn out the guys from spawner_1 and spawner_2
				ent_server_fight_a = spawner_1 stalingradspawn( "server_enemy" );
				if( !maps\_utility::spawn_failed( ent_server_fight_a ) )
				{
								// set this guy to alert red
								ent_server_fight_a thread e3_pip_flow();
								//ent_server_fight_a setalertstatemin( "alert_red" );

								// send him to his node
								//ent_server_fight_a setgoalnode( nod_server_yeller );

								// turn off sense
								//ent_server_fight_a setenablesense( false );
				}
				else
				{
								//iprintlnbold( "ent_server_fight_a_fail" );
								return;
				}

				// quick wait so the two guys don't spawn on to of each other
				wait( 0.5 );

				//// need to turn the player towards the computer
				//level.player maps\_utility::holster_weapons();
				//ent = getent("ent_obj_3", "targetname");
				//if(isdefined(ent))
				//{
				//	// spawn an origin to link the player to
				//	mover = spawn("script_origin", level.player.origin);
				//	mover.angles = level.player.angles;
				//	level.player linkto(mover);
				//	// move to a position in front of the computer
				//	move_to_pos = (ent.origin[0], ent.origin[1], level.player.origin[2]);
				//	time = 0.5;
				//	accel = 0.4;
				//	decel = 0.1;
				//	mover moveto(move_to_pos, time, accel, decel);
				//	mover waittill("movedone");
				//	// rotate the player so they are looking at the computer
				//	time = 0.5;
				//	accel = 0.1;
				//	decel = 0.4;
				//	angles = (0, ent.angles[1], 0);
				//	mover rotateto(angles, time, accel, decel);
				//	mover waittill("rotatedone");
				//	level.player unlink();
				//	mover delete();
				//}
				//level.player maps\_utility::unholster_weapons();

				//add split screen -jc
				level thread split_screen(); // pip starts here

				// 03-03-08
				// wwilliams
				// makes the second set of guys occupy the flank room
				level thread e3_server_flank_pop();

				// notify to send out to the level in order to start the 
				// door_kick beat
				// level notify ( "door_kick_start" );

				// basher sends out this notify
				level waittill( "flood_server_room" );

				// 02-21-08
				// wwilliams
				// send the three guys from the window to their nodes
				// ent_server_fight_a setgoalnode( nod_server_fight_a );
				ent_server_fight_a setenablesense( true );
				// 08-17-08
				// aeady
				// give them perfect sense (bug 18787)
				ent_server_fight_a setperfectsense(true);
				//ent_server_fight_a thread maps\airport_util::turn_on_sense( 5 );
				ent_server_fight_a setgoalnode( noda_server_fight_b[0], 1 );
				ent_server_fight_a thread maps\airport_util::give_tether_at_goal( nod_server_tether, 300, 1100, 256 );
				ent_server_fight_a SetCombatRole( "guardian" );
				

				// quick wait
				//08 14 08 jeremyl
				wait( 1.9 );	//too long? -jc

				// send notify to open server room doors
				level notify( "open_server_room_doors" );
				
				//DCS: holding off spawning third server guard till door open.
				thread spawn_third_serverguy(noda_server_fight_b, nod_server_tether);
				
				// DCS: turn on ai chat after intro to server room.
				SetSavedDVar( "ai_ChatEnable", "1" );

}
spawn_third_serverguy(noda_server_fight_b, nod_server_tether)
{
	spawner_2 = getent( "spwn_e3_server_fight_b", "targetname" );
	nod_server_waiter = getnode( "nod_e3_server_wait", "targetname" );
	spawner_2.count = 5;
	
	// 02-21-08
	// wwilliams
	// guy who waits for door to be opened
	ent_server_fight_b2 = spawner_2 stalingradspawn( "server_enemy" );
	if( !maps\_utility::spawn_failed( ent_server_fight_b2 ) )
	{
		// set this guy to alert red
		ent_server_fight_b2 setalertstatemin( "alert_red" );

		// send him to his node
		//ent_server_fight_b2 setgoalnode( nod_server_waiter );

		// turn off sense
		//ent_server_fight_b2 setenablesense( false );
	}
	else
	{
		//iprintlnbold( "ent_server_fight_b2_fail" );
		return;	
	}
	
	// second guy
	//ent_server_fight_b2 setenablesense( true );
	// 08-17-08
	// aeady
	// give them perfect sense (bug 18787)
	ent_server_fight_b2 setperfectsense(true);
	ent_server_fight_b2 setgoalnode( noda_server_fight_b[1] );
	ent_server_fight_b2 thread maps\airport_util::give_tether_at_goal( nod_server_tether, 300, 1100, 256 );
	ent_server_fight_b2 SetCombatRole( "guardian" );
}

// 08/1-/08 jeremyl
e3_pip_flow()
{
	// turn off sense
	self setenablesense( false ); // this needs to happen first or else you can throw a grenade, then hack the computer and this ai will clip through the door and take cover

	self setalertstatemin( "alert_red" );

	//DCS: reducing radius to get ai out of way of basher for sure.
	self.goalradius = 12;

	wait( 0.7 ); //removed wait to make it happen in faster was 6 seconds
	nod_server_yeller = getnode( "nod_e3_server_yeller", "targetname" );

	self setgoalnode( nod_server_yeller );

	self waittill("goal");

	//DCS: moved to spawn when guy in room.
	// 08-01-08 WWilliams
	// guy who bashes in the door
	level thread e3_server_door_basher();

	wait(0.5);
	self cmdaction( "CheckEarpiece" );

	self waittill( "cmd_done" );

	//wait(2.3);
	self cmdaction( "LookAround", true, 2.3 );		

	self cmdaction( "callout" );

	self waittill( "cmd_done" );
}


///////////////////////////////////////////////////////////////////////////
// 08-01-08 WWilliams
// function for the ai that bashes the door, must have precise control of this guy
e3_server_door_basher()
{
				// endon

					// objects to be defined for this function
				door_bash_spawner = getent( "spwn_door_basher", "targetname" );
				node_door_bash_start = GetNode( "nod_e3_server_basher", "targetname" );
				nod_server_fight_a = getnode( "nod_server_fight_a", "targetname" );
				nod_server_tether = GetNode( "e3_server_main_tether", "targetname" );
				// trigger
				//trig_setup = getent( "auto1510", "targetname" );

				// make sure the spawner has a count
				door_bash_spawner.count = 1;

				// wait for the trigger hit
				//trig_setup waittill( "trigger" );

				 //02-21-08
				 //wwilliams
				 //guy who bashes the door
				ent_server_basher = door_bash_spawner stalingradspawn( "server_enemy" );
				if( !maps\_utility::spawn_failed( ent_server_basher ) )
				{
								// set this guy to alert red
								//ent_server_basher setalertstatemin( "alert_red" );
								ent_server_basher.goalradius = 12;

								// send him to his node
								ent_server_basher setgoalnode( node_door_bash_start );

								// turn off sense until he needs to go
								ent_server_basher setenablesense( false );
				}
				else
				{
								//iprintlnbold( "ent_server_fight_b1_fail" );
								return;	
				}

				// wait for the notify to start the bash
				// notify to start the door kick
				level waittill( "bash_server_door" );
				
				//DCS: just to be sure he is right at the node to start.
				ent_server_basher teleport(node_door_bash_start.origin, node_door_bash_start.angles);
				wait(0.05);
				
				// function counts up to 62 frames and then starts teh door animation
				ent_server_basher thread e3_server_door_break();

				// play an animation on the guy who rushes the door
				ent_server_basher cmdplayanim( "Thug_DoorShoulderCharge" );

				// wait 
				ent_server_basher waittill( "cmd_done" );

				// notify the other guys
				level notify( "flood_server_room" );

				// turn back on sense
				ent_server_basher setalertstatemin( "alert_red" );
				ent_server_basher setenablesense( true );
				
				ent_server_basher playsound ("SAM_E_1_FrRs_Cmb" );

				// 08-17-08
				// aeady
				// give them perfect sense (bug 18787)
				ent_server_basher setperfectsense(true);
				//// turn on perfect sense for a second or so
				//ent_server_basher thread maps\airport_util::turn_on_sense( 5 );

				// send him to his node
				ent_server_basher setgoalnode( nod_server_fight_a );

				// give tether at goal
				ent_server_basher thread maps\airport_util::give_tether_at_goal( nod_server_tether, 300, 1100, 256 );

				// set combat role
				ent_server_basher SetCombatRole( "flanker" );

}
///////////////////////////////////////////////////////////////////////////
// 08-01-08 WWilliams
// counts out 62 frames then starts teh door animation
// runs on self/NPC
e3_server_door_break()
{
				// endon
				self endon( "death" );

				// wait for the notetrack on the guy
				self waittillmatch( "anim_notetrack", "door_charge_kick" );
				// add dust particle
				// ludes
				earthquake( 0.6, 0.5, level.player.origin, 2700 );
				boom = spawn ("script_origin", (-2322, 2635, 92));
				physicsExplosionSphere( boom.origin, 200, 100, 0.1 );
				fx = playfx( level._effect[ "pillar_smoke" ], boom.origin + (-50,-20,20));
				fx2 = playfx( level._effect[ "pillar_smoke" ], boom.origin + (-50,-20,-30));
				fx3 = playfx( level._effect[ "pillar_smoke" ], boom.origin + (-50,-20,-60));
				//airport_forklift_smoke
				// pillar_smoke
				// physics pulse here.
				

				// debug text
				// iprintlnbold( "start door kick" );

				// notify the door to start
				level notify( "door_kick_start" );

				self playsound ("door_charge");
				
				wait(2.4);
				
				earthquake( 0.7, 0.9, level.player.origin, 2700 );
				physicsExplosionSphere( boom.origin, 200, 100, 0.3 );
				fx = playfx( level._effect[ "pillar_smoke" ], boom.origin + (-50,-20,20));
				fx = playfx( level._effect[ "pillar_smoke" ], boom.origin + (-50,-20,-30));
				fx3 = playfx( level._effect[ "pillar_smoke" ], boom.origin + (-50,-20,-60));
				//iprintlnbold("SOUND: door charge");
				
				self playsound ("SAM_E_1_McGs_Cmb" );
				wait( 1 );
				self playsound ("SAM_E_2_Flan_Cmb" );
				wait( 1.3 );
				self playsound ("SAM_E_3_McGs_Cmb" );
				wait( 1.3 );
				self playsound ("SAM_E_4_McGs_Cmb" );
}
// ---------------------//
// 03-03-08
// wwilliams
// spawning out the guys from the server room flank route differently
// this should also talk to the chair throwing function
// why don't we just throw the chair in this function?
e3_server_flank_pop()
{
				// endon
				// not needed for this single shot function

				// objects to be defined for this function
				e3_flank_spawner = getent( "spwn_e3_server_fight_c", "targetname" );
				nodae3_flank_destin = getnodearray( e3_flank_spawner.script_parameters, "targetname" );
				nod_flank_tether = getnode( "e3_server_flank_tether", "targetname" );
				// scr_org_throw_chair_start = getent( "so_e3_chair_throw_start", "targetname" );
				// scr_org_throw_chair_end = getent( scr_org_throw_chair_start.target, "targetname" );
				ent_temp = undefined;
				// int_count = undefined;
				str_brain = undefined;
				// chair_vec = undefined;
				// chair_velocity = undefined;

				// set the counter of the spawner
				e3_flank_spawner.count = nodae3_flank_destin.size;

				// 03-28-08
				// wwilliams
				// commenting out the chair throw event trying to fix a script memory overuse
				// 03-11-08
				// wwilliams
				// need to look into why i can't get this to work
				// spawn out the script model 
				// script_chair = spawn( "script_model", scr_org_throw_chair_start.origin );
				// set the model
				// script_chair setmodel( "p_frn_chair_metal" );
				// change the angles
				// script_chair.angles = ( -0, 150, -90 );
				// taek away the collision of the chair
				// script_chair notsolid();
				// get the vector for the chair
				// chair_vec = anglestoforward( scr_org_throw_chair_start.angles ) * 1100;
				// get the velocity for the chair
				// chair_velocity = common_scripts\utility::vectorscale( chair_vec, 5.0 );

				// wait for the notify to the level about the door kick
				level waittill( "window_uncrop" );

				// quick wait
				wait( 1.0 );

				// 03-28-08
				// wwilliams
				// call for the chair
				level notify( "chair_throw_start" );

				// shoot the window out first
				// magicbullet( "mp5", scr_org_throw_chair_start.origin, ( -2192, 2440, 101 ) );

				// radius damage on the window
				// radiusdamage( ( -2224, 2327, 101 ), 25, 1500, 1400 );

				// wait a frame
				// wait( 0.1 );

				// throw the chair through the window
				// script_chair physicslaunch( scr_org_throw_chair_start.origin, chair_vec );

				// spawn out the guys
				for( i=0; i<nodae3_flank_destin.size; i++ )
				{
								// spawn out guys one
								ent_temp = e3_flank_spawner stalingradspawn( "server_enemy" );
								if( !maps\_utility::spawn_failed( ent_temp ) )
								{
												// give the guy an alert state
												ent_temp setalertstatemin( "alert_red" );

												// assign a value to the int_count
												// int_count = i + 1;

												// get a brain state

												str_brain = level maps\airport_util::airport_give_me_brain( i );
												
												// give the guy his brain type
												ent_temp SetCombatRole( str_brain );

												// now send him to his goal node
												ent_temp setgoalnode( nodae3_flank_destin[i] );

												// make sure to tether the flankers
												// but not the rushers
												if( str_brain == "flanker" )
												{
																// tether the guy to the tether node
																// ent_temp settetherradius( 750 );
																// ent_temp thread maps\airport_util::luggage_room_active_tether( 512, 900, 256 );
																ent_temp thread maps\airport_util::give_tether_at_goal( nod_flank_tether, 300, 1100, 256 );

																// will need a tether function for these guy to move down the map
																ent_temp.tetherpt = nod_flank_tether.origin;

												}
												else if( str_brain == "rusher" )
												{
																str_brain = "flanker";
																// no tether for these guys because they act funny when they are	
												}
												
												ent_temp SetCombatRole( str_brain );

												// 08-17-08
												// aeady
												// give them perfect sense (bug 18787)
												ent_temp setperfectsense(true);

												// need to add a wait so these guys don't spawn on top
												// of each other
												wait( 0.7 );
								}

				}


}
// ---------------------//
// 02-15-08
// needed to make sure i could do special things with these guys
// adding the function call that will watch to see if they are in the halon trigger
// if so it will make them play the flashbang anim
/* test_quick_populate()
{
// endon

// objects to be defined for this function
pop_nodes = getnodearray( self.script_parameters, "targetname" );
temp_ent = undefined;
int_tether_dist = undefined;

// make the count of the spawner the same size as the nodes that were grabbed
// using the spawner's script_noteworthy
self.count = pop_nodes.size;

// double check to see if the spawn has a script_int
// this kvp will dictate how far the AI is allowed to run from their
// goal nodes
if( isdefined( self.script_int ) )
{
int_tether_dist = self.script_int;
}
else
{
int_tether_dist = 256;
}

for( i=0; i<pop_nodes.size; i++ )
{
	temp_ent = self stalingradspawn( "server_room_enemy" );
	if( !maps\_utility::spawn_failed( temp_ent ) )
	{
	temp_ent setgoalnode( pop_nodes[i] );
	wait( 0.2 );
	// temp_ent lockalertstate( "alert_red" );
	temp_ent setalertstatemin( "alert_red" );
	//temp_ent setperfectsense( true );
	// 02-15-08
	// wwilliams
	// adding a new function to these guys
	// they need to react to the halon gas if they are in the room
	temp_ent thread e3_npc_halon_reaction();
}

wait( 0.2 );
temp_ent = undefined;

}

}*/
// ---------------------//
// wwilliams 12-03-07
// dialogue from villiers informing bond about the antivirus
e3_villiers_dialogue()
{
				// endon

				// stuff
				antivirus_trig = getent( "trig_e3_antivirus", "targetname" );
				server_room_radio = getent( "e3_server_fight_radio", "targetname" );

				// wait till hit
				antivirus_trig waittill( "trigger" );

				// villiers speaks
				//// iprintlnbold( "TANNER: Bond, the data packet is on your phone. You need to find the main terminal and patch into it." );
				//// line 1 - tanner
				//level.player maps\_utility::play_dialogue( "TANN_AirpG_014A", true );

				// wait for the player to upload the virus
				level maps\_utility::flag_wait( "objective_3" );

				// iprintlnbold( "TANNER: That's it, the network is back online. Now find that bomber--" );
				// line 2 - tanner
				level.player maps\_utility::play_dialogue( "TANN_AirpG_015B", true );


				// radio chatter busts in
				// level maps\airport_util::loop_print3d( server_room_radio.origin + ( 0, 0, 10 ), "We've got a problem!", ( 1.0, 0.8, 0.5 ), 3000, "e3_radio_p1", 1, 0.25 );

				// level maps\airport_util::loop_print3d( server_room_radio.origin + ( 0, 0, 10 ), "The airport is back online!", ( 1.0, 0.8, 0.5 ), 3000, "e3_radio_p2", 1, 0.25 );

				// level maps\airport_util::loop_print3d( server_room_radio.origin + ( 0, 0, 10 ), "The fix was local, check the server rooms!", ( 1.0, 0.8, 0.5 ), 3000, "e3_radio_p3", 1, 0.25 ); 

				// dialogue for the radio
				// line 1 - merc
				server_room_radio maps\_utility::play_dialogue( "CCRM_AirpG_016A", true );
				
				//08/14/08 jeremyl
				// notify to start the door kick
				level notify( "bash_server_door" );

				// line 2 - merc
				server_room_radio maps\_utility::play_dialogue( "CCM5_AirpG_017A", true );

				// line 3 - merc
				server_room_radio maps\_utility::play_dialogue( "CCM6_AirpG_018A", true );

				// notify to start the door kick
				//level notify( "bash_server_door" );

				// line 4 - merc
				server_room_radio maps\_utility::play_dialogue( "CCM7_AirpG_019A", true );



}
// ---------------------//
// wwilliams
// 01-14-08
// opens the doors to the server room once the objective is completed
server_room_doors()
{
				// stuff
				left_door_node = getnode( "server_room_left_nodes", "targetname" );
				left_door = getent( "server_room_left", "targetname" );
				right_door = getent( "server_room_right", "targetname" );
				right_door_node = getnode( "server_room_right_nodes", "targetname" );
				trig = getent( "ent_close_e3_exit", "targetname" );

				// wait for the objective
				level maps\_utility::flag_wait( "objective_3" );

				// 02-13-08
				// wwilliams
				// wait for the flag from the population script
				level waittill( "open_server_room_doors" );

				// unbar the server room doors
				left_door._doors_barred = false;
				right_door._doors_barred = false;

				// automatically open the doors
				left_door_node maps\_doors::open_door();
				right_door_node maps\_doors::open_door();

				// wait for a trigger to be hit before closing these off
				trig waittill( "trigger" );

				// change the always open parameter of the doors
				left_door._doors_auto_close = true;
				right_door._doors_auto_close = true;

				// close the doors to the server room
				left_door maps\_doors::close_door();
				right_door maps\_doors::close_door();

				// wait
				wait( 1.5 );

				// rebar the doors
				left_door._doors_barred = true;
				right_door._doors_barred = true;

				//Music change for sever room / luggage room combat - added by chuck russom

				// save
				level notify("checkpoint_reached"); // checkpoint 5
}
// ---------------------//

// ---------------------//
// 02-12-08
// wwilliams
// clean up function for event three
// deletes spawners and any other entities that take
// up memory
e3_clean_up()
{
	// endon
	// this isn't needed, this function must happen

	// 02-13-08
	// wwilliams
	// wait for the notify from the event ending function
	level waittill( "event_three_done" );

	level notify("e3_clean_up");

	// define the objects needed for this function
	// spawners used in event three
	enta_e3_spawners = getentarray( "e3_spawners", "script_noteworthy" );

	// for loop goes through each spawner for event 3
	for( i=0; i<enta_e3_spawners.size; i++ )
	{
		// quick wait to avoid a potential infinite script loop
		wait( 0.05 );
		if( isdefined( enta_e3_spawners[i] ) )
		{
			// another wait to avoid doing too much in one frame
			wait( 0.05 );
			if( !isai( enta_e3_spawners[i] ) )
			{
				// delete the spawner
				enta_e3_spawners[i] delete();

				// obligatory wait keeps multiple deletes from happening in one frame
				wait( 0.1 );
			}
		}

	}

	// turn off all the functions running on the halon event,
	// also gets rid of the trigger that starts the halong
	// level notify( "halon_disable" );
}
// ---------------------//
// waits for player to hack the computer
// flag gets set event two finishes
// 02-12-08
// wwilliams
// adding the function call that cleans up event three in this function
end_event_three()
{
				// define the objects needed in this function
				end_trig = getent( "trig_start_e4", "targetname" );

				// wait for the flag to be set from uploading the anti virus
				level maps\_utility::flag_wait( "objective_3" );

				// wait for the end trig to be hit
				end_trig waittill( "trigger" );

				// change the flags that control the airplane flyover
				// first clear the old flag
				level maps\_utility::flag_clear( "airplane_fly_over_01" );
				// set the second flag
				level maps\_utility::flag_set( "airplane_fly_over_02" );

				// set the fog for the luggage area
				// setexpfog( near_plane, half_plane, fog_red, fog_blue, lerp_time, fog_max );
				SetExpFog( 460, 3000, 0.5, 0.5, 0.5, 1.0, 1 );
				// this is the max, whatever that is:  0.999,
				// setDVar( "scr_fog_max", "0.87" );

				// notify the main script to end and allow event four to start
				level notify( "event_three_done" );

}
// ---------------------//

// ---------------------//
// split screen for last server room

split_screen()
{
	//no hud
	//turn off weapon icon - hud will negate border
	setdvar("ui_hud_showstanceicon", "0"); 
	setsaveddvar("ammocounterhide", "1");  
	setdvar("ui_hud_showcompass", 0);

	//lock player
	level.player FreezeControls( true );

	//change cam
	level thread main_camera();

	//play anim on bond
	level thread second_anim();

	//wait( 3 );

	//crop and move down
	level thread main_crop();
	//level thread main_move();

	//PIP
	level thread second_move();

	level waittill( "window_uncrop" );

	//unlock player
	level.player FreezeControls( false );

	// hud
	setdvar("ui_hud_showstanceicon", "1"); 
	setsaveddvar("ammocounterhide", "0");  
	setdvar("ui_hud_showcompass", 1);
}

main_camera()
{
	//turn off camera collision
	level.player customcamera_checkcollisions( 0 );

	// DCS: need to hide bond so don't see clipping through head.
	thread maps\airport_util::hideBond(0.5);

	//cut to server room
	ent = getent("ent_obj_3", "targetname");
	time = 0.0;
	server_cam = level.player customCamera_push("world", ent.origin + (0, 0, 60), ent.angles, time);

	// need to turn the player towards the computer
	// spawn an origin to link the player to
	mover = spawn("script_origin", level.player.origin);
	mover.angles = level.player.angles;
	level.player linkto(mover);
	// move to a position in front of the computer
	move_to_pos = (ent.origin[0], ent.origin[1], level.player.origin[2]);
	time = 0.05;
	mover moveto(move_to_pos, time);
	mover waittill("movedone");
	// rotate the player so they are looking at the computer
	time = 0.05;
	//angles = (0, ent.angles[1], 0);
	mover rotateto(ent.angles, time);
	mover waittill("rotatedone");
	level.player unlink();
	mover delete();

	time = 3.0;
	org = ( -2042, 2570, 98 );
	ang = ( 7.4, -174, 0 );
	server_cam = level.player customCamera_change(server_cam, "world", org, ang, time);
	
	level waittill( "off_screen" );

	//back to player
	level.player customCamera_pop( server_cam, 0 );
	
	//turn on camera collision
	level.player customcamera_checkcollisions( 1 );

	// 8-17-08
	// aeady
	// save after we've gotten out of pip and popped back to the player
	wait(0.05);
	level maps\_autosave::autosave_by_name( "airport" );					
}


main_crop()
{

	//set border size and color
	setdvar("cg_pipmain_border", 2);
	setdvar("cg_pipmain_border_color", "0 0 0.2 1");
	
	//set main window
	SetDVar("r_pipMainMode", 1);	//set window
	SetDVar("r_pip1Anchor", 3);		// use top middle anchor point

	//crop window
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, -1, .75, .75, 0.75, .75);
	wait(0.6);	//replace with notify
		
	level notify( "window_crop" );
		
	level waittill( "off_screen" );
	//level waittill( "window_up" );

	//uncrop
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, -1, 1, 1, 1, 1);
	wait(0.5);
	level notify( "window_uncrop" );
	
	//reset back to default
	SetDVar("r_pip1Scale", "1 1 1 1");		// default
	SetDVar("r_pipMainMode", 0);	//so aiming not messed up
	setSavedDvar("cg_drawHUD","1");

	// save
	level notify("checkpoint_reached"); // checkpoint 4
}

//
main_move()
{
	
	level waittill( "window_crop" );
		
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.5);
	
	level notify( "window_down" );
	
	level waittill( "off_ledge" );
	
	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify( "window_up" );
}


//pip
second_move()
{
	//moved earlier. will crash unless set up right away - bug?
	//setup pip camera
	level.player setsecuritycameraparams( 65, 3/4 );

	// need to hide bond so don't see clipping through head.
	thread maps\airport_util::hideBond( 0.5 );

	wait(0.05);	//need this or it will crash
	cameraID_hack = level.player securityCustomCamera_Push( "entity", level.player, level.player, ( -50, -40, 77), ( -32, -7, 0), 0.1);
	
	//setup PIP
	//SetDVar("r_pipSecondaryX", .6 );						// start off screen
	//SetDVar("r_pipSecondaryY", -.3);						// place top right corner of display safe zone
	SetDVar("r_pipSecondaryAnchor", 4);						// use top left anchor point
	//SetDVar("r_pipSecondaryScale", ".36, .5, .35, .5");		// scale image, without cropping
	//SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio

	//set border and color
	setdvar("cg_pipsecondary_border", 1);
	setdvar("cg_pipsecondary_border_color", "0 0 0.2 1");
		
	//set up the pip	
	//start offscreen
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 10, 0, 0.6, -0.5, .352188, .5, .35, .5);
	level.player waittill("animatepip_done");
	
	level waittill( "window_crop" );
	SetDVar("r_pipSecondaryMode", 5);		// enable video camera display with highest priority 		
	
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 0, 0.6, .15);
	wait(0.5);
	
	//level.player animatepip( 3000, 0, 0.6, .3);

	//notify from 
	// wait for conversation to end
	level waittill( "open_server_room_doors" );

	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 0, .6, 1 );
	wait(0.6);
		
	level notify( "off_screen" );
	
	//reset
	SetDVar("r_pipSecondaryMode", 0);
	level.player securitycustomcamera_pop( cameraID_hack );
	level.player PlayerAnimScriptEvent("");

	//// 8-17-08
	//// aeady
	//// save after we've gotten out of pip and popped back to the player
	//wait(0.05);
	//level maps\_autosave::autosave_by_name( "airport" );					
}

//bond anim during pip
second_anim()
{
	level endon("off_screen");

	while (true)
	{
		level.player PlayerAnimScriptEvent("phonehacklock");
		wait .05;
	}
	
}
