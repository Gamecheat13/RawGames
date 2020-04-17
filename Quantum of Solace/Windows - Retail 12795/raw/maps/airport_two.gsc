// Airport event two file
// Builder: Brian Glines
// Scritper: Walter Williams
// Created: 10-08-2007

main()
{
				// save progression
				// savegame( "airport" );
				// level maps\_autosave::autosave_now( "airport" );
				//level thread air2_savegame();

				// wwilliams 11-30-07
				// changes flag to start e2
				//level thread air_e2_start();

				// 02-12-08
				// wwilliams
				// function watches to see when the player breaks stealth
				level thread e2_stealth_flag_set();

				// start up the patrols
				// wwilliams 11-30-07
				// got rid of the old way of doing this
				// each function should be able to stand on its own
				level thread e2_right_patrol();
				level thread e2_computer_patrol();
				// level thread e2_bottom_hallway_patrol();

				// heli
				level thread e2_helicopter_movement();

				// 03-28-08
				// wwilliams
				// sets up the model to be changed after the download
				level thread e2_comp_settings();

				// 08-02-08 WWilliams
				// thread changes the computer model
				level thread e2_change_monitor_model();

				// 02-13-08
				// wwilliams
				// puting the villiers dialogue function call back into main
				level thread e2_villiers_dialogue();

				// 03-05-08
				// wwilliams
				// locks the door to the virus room once the player hacks the second comp
				level thread e2_lock_player_in_vr();

				// 02-12-08
				// wwilliams
				// opens the door exiting the second virus room
				level thread e2_exit_door_control();

				// 05-21-08
				// wwilliams
				// new function sets up event three cameras and enemies when the player enters the
				// second virus download room
				level thread air_setup_zone3();

				// 02-13-08
				// wwilliams
				// moving this out of ent_event_two function
				// trying to fix an error deleteing one of the spawners
				// run the clean up function
				level thread e2_clean_up();

				// 02-12-08
				// wwilliams
				// added the clean up function call into the end_event_two function
				level thread end_event_two();

				// wait for the notify to be sent out before ending the main function
				// of event 2
				level waittill( "event_two_done" );

}
//// ---------------------//
//// WW 07-08-08
//// waits for a notify to the level before saving the game at the end of the
//// pip
//air2_savegame()
//{
//				// wait for the notify from the level
//				level waittill( "off_screen" );
//
//				// save the game
//				level maps\_autosave::autosave_now( "airport" );
//
//}
// ---------------------//
// makes self wait for the player to hit a trig then sends him out of the bathroom
// and starts him on a patrol route
e2_right_patrol()
{


				// objects to be defined for this function
				trig = getent( "ent_close_e1_exit", "targetname" );
				spawner = getent( "spwn_e2_right_patrol", "targetname" );
				orders_node = getnode( "nod_e2_right_patrol", "targetname" );
				nod_e2_tether_point = getnode( "e2_tether_point", "targetname" );

				// spawn the guy
				dood = spawner stalingradspawn( "e2_patroller" );
				if( !maps\_utility::spawn_failed( dood ) )
				{
								// 02-12-08
								// wwilliams
								// endons based on the guy that just spawned
								// this should be re written
								dood endon( "death" );
								dood endon( "damage" );

								// give him a script_noteworthy for the dialogue function
								dood.script_noteworthy = "e2_right_patrol";

								// function to change script speed to normal
								dood thread maps\airport_util::reset_script_speed();

								// give him the right alert state
								dood setalertstatemin( "alert_yellow" );

								// 02-19-08
								// wwilliams
								// set the speed to walking even though the guy is in alert_yellow
								dood setscriptspeed( "walk" );

								// set propagation delay
								dood setpropagationdelay( 3.0 );

								// send him to the first node
								dood setgoalnode( orders_node );

								// 02-13-08
								// wwillliams
								// moving this down, hopefully a few frames past the setting of the AI alert state		
								// run the function on the dood to wait for 
								// alert red and send out the notify
								dood thread maps\airport_util::event_enemy_watch( "e2_stealth_cancelled", "e2_stealth_broken" );

								// wait for the player to get near
								trig waittill( "trigger" );

								// dialogue for dood
								// dood thread e2_right_patrol_dialogue();

								// 03-04-08
								// wwilliams
								// set the guys's tether distance
								// tether the guy to the tether node
								dood settetherradius( 750 );

								// 03-04-08
								// wwilliams
								// give this guy his tether point
								dood.tetherpt = nod_e2_tether_point.origin;

								// wait for dialogue to finish
								level maps\_utility::flag_wait( "event_two_start" );		

								// start his patrol
								dood startpatrolroute( "nod_e2_right_patrol" );
				}
				else
				{
								//iprintlnbold( "e2_right_patrol_fail" );
								return;
				}


}
// ---------------------//
// wwilliams 12-03-07
// right patrol dialogue, a.k.a. merc 4
e2_right_patrol_dialogue()
{
				// endon
				self endon( "death" );
				self endon( "damage" );
				level endon( "e2_stealth_cancelled" );

				// objects to be defined for this function

				// dialogue
				// level maps\airport_util::loop_print3d( self.origin + ( 0, 0, 70 ), "Stay alert, that's the police.", ( 1.0, 0.8, 0.5 ), 3000, "e2_convo_p0", 1, 0.75 );
				self maps\_utility::play_dialogue_nowait( "CCM3_AirpG_010A" );

				// iprintlnbold( "first line" );

				// wait for first line to finish
				// wait( 3.0 );

				// self waittill( "goal" );

				// notify for other string to continue
				level notify( "e2_convo_p1" );

				// level maps\airport_util::loop_print3d( self.origin + ( 0, 0, 70 ), "Davis, hold this point, no one gets past.", ( 1.0, 0.8, 0.5 ), 3000, "e2_convo_p1", 1, 0.75 );

				// wait
				// wait( 0.5 );

				// wait for landing/bottom patrol dialogue to run
				// level waittill( "e2_convo_p2" );
				// level waittill( "e2_convo_p2" );
				// wait( 2.0 );
				// iprintlnbold( "before third line" );

				// level maps\airport_util::loop_print3d( self.origin + ( 0, 0, 70 ), "Gomez, you're with me. We exfil as soon as Carlos delivers the package.", ( 1.0, 0.8, 0.5 ), 3000, "e2_convo_p3", 1, 0.75 );
				self maps\_utility::play_dialogue_nowait( "CCM3_AirpG_012A" );

				// iprintlnbold( "third line" );

				// notify to other function
				level notify( "e2_convo_p3" );

				// notify for guys to go to their places
				level notify( "e2_patrol_start" );
				level maps\_utility::flag_set( "event_two_start" );

}
// ---------------------//
// wwilliams
// 10-18-07
// starts the guy on the "pr_e2_office_patrol" patrol
// 02-13-08
// wwilliams
// changing how this works to have this guy be the second ai
// for the hack suspense in event one
// will pass him into this function after done with him in the first one
e2_bottom_hallway_patrol()
{
	// endon
	level endon( "event_two_done" );
	self endon("death");

	if(IsDefined(self))
	{

		// set a script_noteworthy for the dialogue function
		self.script_noteworthy = "e2_bottom_patrol";

		// give him the right alert state
		// 02-13-08
		// wwiilliams
		// might not be needed
		self setalertstatemin( "alert_yellow" );

		// function to change script speed to normal
		self thread maps\airport_util::reset_script_speed();
	}

	// objects to be defined for this function
	trig = getent( "ent_close_e1_exit", "targetname" );
	orders_node = getnode( "nod_e2_bottom_patrol", "targetname" );
	nod_e2_tether_point = getnode( "e2_tether_point", "targetname" );

	// wait for the player to get near
	trig waittill( "trigger" );


	if(IsDefined(self))
	{
		// 02-19-08
		// wwilliams
		// set the speed to walking even though the guy is in alert_yellow
		self setscriptspeed( "walk" );

		// send him to his first node
		self setgoalnode( orders_node );

		// run the function on the dood to wait for 
		// alert red and send out the notify
		self thread maps\airport_util::event_enemy_watch( "e2_stealth_cancelled", "e2_stealth_broken" );

		// wait for goal
		//self waittill( "goal" );
		wait(2.5);

		// 03-04-08
		// wwilliams
		// set the guys's tether distance
		// tether the guy to the tether node
		self settetherradius( 750 );

		// 03-04-08
		// wwilliams
		// give this guy his tether point
		self.tetherpt = nod_e2_tether_point.origin;
	}

	// talking hook
	level thread e2_enemy_dialogue();

	// turn on sense
	// self setenablesense( true );

	// wait for dialogue to be done
	level maps\_utility::flag_wait( "event_two_start" );

	// makes this guy repeat a cmdaction
	//while( !level maps\_utility::flag( "e2_stealth_broken" ) )
	// {
	// make the guy do something
	//	self cmdaction( "scratch" );
	// }


}
// ---------------------//
// wwilliams 12-03-07
// dialogue for the bottom patrol guy a.k.a. merc 3
e2_enemy_dialogue()
{
	// define objects for the function
	dood_1 = getent( "e2_right_patrol", "script_noteworthy" );
	dood_2 = getent( "e2_bottom_patrol", "script_noteworthy" );

	// double check defines
	assertex( isdefined( dood_1 ), "dood_1 not defined" );
	assertex( isdefined( dood_2 ), "dood_2 not defined" );

	// endon
	dood_1 endon( "death" );
	dood_1 endon( "damage" );
	dood_2 endon( "death" );
	dood_2 endon( "damage" );
	level endon( "e2_stealth_cancelled" );

	// dialogue
	// level maps\airport_util::loop_print3d( self.origin + ( 0, 0, 70 ), "Yes Sir.", ( 1.0, 0.8, 0.5 ), 3000, "e2_convo_p2", 1, 0.75 );
	// line 1 dood_1
	dood_1 maps\_utility::play_dialogue( "CCM3_AirpG_010A" );

	// line 2 dood_2
	//wait (4.5);
	wait(0.5);
	dood_2 maps\_utility::play_dialogue( "CCM4_AirpG_011A" );

	// line 3 dood_1
	//wait (.7);
	wait(0.7);
	dood_1 maps\_utility::play_dialogue( "CCM3_AirpG_012A" );

	// notify the AI to start
	level maps\_utility::flag_set( "event_two_start" );
				

}
// ---------------------//
// wwilliams
// this runs on the guy who patrols in and out of the hack room
// runs on the NPC
e2_computer_patrol()
{

				// endon
				self endon( "death" );
				self endon( "damage" );

				// stuff
				//trig = getent( "trig_start_bathroom_emerge", "targetname" );
				spawner = getent( "spwn_e2_comp_watch", "targetname" );
				orders_node = getnode( "nod_e2_comp", "targetname" );
				laptop_node = getnode( "nod_e2_cam_lap", "targetname" );
				nod_e2_tether_point = getnode( "e2_tether_point", "targetname" );

				// spawn out the guy
				dood = spawner stalingradspawn("e2_patroller2");
				if( !maps\_utility::spawn_failed( dood ) )
				{
								// endons based off guy
								dood endon( "death" );
								dood endon( "damage" );

								// start the camera stuff
								// 05-20-08
								// wwilliams
								// commenting this out cause event two will not have
								// cameras anymore
								// level thread e2_cameras_init( dood );

								// give him the right alert state
								dood setalertstatemin( "alert_yellow" );

								// set propagation delay
								dood setpropagationdelay( 3.0 );

								dood setscriptspeed( "walk" );

								// send him to the first node
								dood setgoalnode( orders_node );

								// wait for goal
								dood waittill( "goal" );

								// 03-04-08
								// wwilliams
								// set the guys's tether distance
								// tether the guy to the tether node
								dood settetherradius( 750 );

								// 03-04-08
								// wwilliams
								// give this guy his tether point
								dood.tetherpt = nod_e2_tether_point.origin;

								// wait for player to get to the right spot
								level maps\_utility::flag_wait( "event_two_start" );

								// send him to the machine
								dood startpatrolroute( "pr_e2_bottom" );

				}

}
// ---------------------//
// wwilliams 12-03-07
// dialogue from villiers
// 02-13-08
// wwilliams
// putting this in the main, it somehow got out
// bad function, don't leave main() again
e2_villiers_dialogue()
{
	// endon

	// stuff

	// wait for objective
	level maps\_utility::flag_wait( "objective_2" );

	// save
	level notify("checkpoint_reached"); // checkpoint 3

	// villiers
	// iprintlnbold( "TANNER: Download Complete." );
	// wait( 2.0 );
	// iprintlnbold( "TANNER: Good work, Bond, we're going to upload a data packet to your phone as soon as it's ready." );
	level.player maps\_utility::play_dialogue( "TANN_AirpG_013A", true );
	wait(2.0);
	// iprintlnbold( "TANNER: Bond, the data packet is on your phone. You need to find the main terminal and patch into it." );
	// line 1 - tanner
	level.player maps\_utility::play_dialogue( "TANN_AirpG_014A", true );
}
// ---------------------//
// wwilliams 11-27-07
// camera start up and function sets for the camera in zone one
// 05-20-08
// wwilliams
// commenting this out cause event two will not have
// cameras anymore
/* e2_cameras_init( watcher )
{
// endon
level endon( "event_one_done" );

// define the camera in event two
e2_camera_1 = getent( "ent_e2_camera_1", "targetname" );
e2_camera_2 = getent( "ent_e2_camera_2", "targetname" );
// frame wait
wait( 0.05 );
// 04-09-08
// hack box lids for the cameras
e2_cam1_hack_box = getent( e2_camera_1.script_parameters, "targetname" );
e2_cam2_hack_box = getent( e2_camera_2.script_parameters, "targetname" );
// define the trigger for disabling the camera in event 2
// 04-09-08
// changing this to use the new camera system
// trig_e2_disable_cam1 = getent( "trig_e2_cam1_disable", "targetname" );
// trig_e2_disable_cam2 = getent( "trig_e2_cam2_disable", "targetname" );

// event_camera_disable( trig )

// 02-12-08
// wwilliams
// removing the third camera, worrel felt there were too many in the area
// the camerra over the long set of cubicals has been removed
//e2_camera_3 = getent( "ent_e2_camera_3", "targetname" );
//spawner = getent( "spwn_e2_camera_backup_1", "targetname" );
//spawner_2 = getent( "spwn_e2_camera_backup_2", "targetname" );
cam_array = [];

// put the cameras in an array so I can change the render to texture
cam_array = maps\_utility::array_add( cam_array, e2_camera_1 );
wait( 0.1 );
cam_array = maps\_utility::array_add( cam_array, e2_camera_2 );
// 02-12-08
// wwilliams
// removing the third camera, worrel felt there were too many in the area
// the camerra over the long set of cubicals has been removed
//wait( 0.1 );
//cam_array = maps\_utility::array_add( cam_array, e2_camera_3 );

// start cameras
// 04-09-08
// now uses the hack box setup from _securitycameras.gsc
e2_camera_1 thread maps\_securitycamera::camera_start( e2_cam1_hack_box, true, false, false );
e2_camera_2 thread maps\_securitycamera::camera_start( e2_cam2_hack_box, true, false, false );
// 02-12-08
// wwilliams
// removing the third camera, worrel felt there were too many in the area
// the camerra over the long set of cubicals has been removed
//e2_camera_3 thread maps\_securitycamera::camera_start( undefined, true, true, true );

// airport function for spawning out backup guys
// 02-12-08
// wwilliams
// function calls to run on the cameras
// these are just like event one functions
// just renamed in the right places to use event two stuff
// watches to see if the camera spots something
e2_camera_1 thread maps\airport_util::event_camera_watch( "e2_stealth_cancelled", "e2_stealth_broken" );
e2_camera_2 thread maps\airport_util::event_camera_watch( "e2_stealth_cancelled", "e2_stealth_broken" );

// function watches for damage to the camera and break stealth
e2_camera_1 thread maps\airport_util::event_camera_destroyed( "e2_stealth_cancelled", "e2_stealth_broken" );
e2_camera_2 thread maps\airport_util::event_camera_destroyed( "e2_stealth_cancelled", "e2_stealth_broken" );

// function disables the cameras once the player breaks stealth in the area
e2_camera_1 thread maps\airport_util::event_camera_disable( "e2_stealth_cancelled" );
e2_camera_2 thread maps\airport_util::event_camera_disable( "e2_stealth_cancelled" );

// function that watches for player disabling the camera
// e2_camera_1 thread maps\airport_util::player_camera_disable( trig_e2_disable_cam1 );
// e2_camera_2 thread maps\airport_util::player_camera_disable( trig_e2_disable_cam2 );

// funciton that switches the camera feed
// level thread camera_feed_switch( cam_array );
// 03-11-08
// wwilliams
// functionality added to _securitycamera from scrowe for a camera rendering switch
// modifying function to use it
// level thread maps\_securitycamera::camera_render_switch( cam_array, 3.0, "airport_cam_end" );
} */
// ---------------------//

// ---------------------//
// wwilliams 11-30-07
// test function for switching between camera feeds, if this works i'm moving it to airport_util
// run this on level
// 05-21-08
// wwilliams
// no longer using this hack way of switching between camera feeds
// commenting it out, security cameras does this now
/* camera_feed_switch( enta_cameras )
{
// endon

// stuff

// while loop with a for loop inside
while( 1 )
{
// the for loop that goes between the cameras
for( i=0; i<enta_cameras.size; i++ )
{
// change the player's phone to another camera
level.player.camera_phone = enta_cameras[i];
wait( 3.0 );
}
wait( 0.1 );
}


} */
// ---------------------//

// ---------------------//
// 02-18-08
// wwilliams
// function unlocks the virus room exit door
// automatically opens it
// waits for the player to get far enough away
// closes the door and locks it behind the player
// ---------------------//
e2_exit_door_control()
{
				// endon

				// stuff
				nod_e2_virus_exit_node = getnode( "auto966", "targetname" );
				e2_virus_exit_door = getent( "ent_door_e2_exit", "targetname" );
				trig = getent( "ent_close_e2_exit", "targetname" );

				// wait for the player to be hacking the machine before turning off barred
				level maps\_utility::flag_wait( "objective_2" );

				// 02-14-08
				// wwilliams
				// a wait to allow the AI to get spawned out
				wait( 3.0 );

				// 02-12-08
				// wwilliams
				// change the door attributes
				e2_virus_exit_door maps\_doors::unbarred_door();
				e2_virus_exit_door._doors_auto_close = false;

				// 02-12-08
				// wwilliams
				// automatically open the door
				nod_e2_virus_exit_node maps\_doors::open_door();

				// need to close and lock the door behind the player
				trig waittill( "trigger" );

				// close the door
				e2_virus_exit_door maps\_doors::close_door();

				// wait
				wait( 1.0 );

				// lock door
				e2_virus_exit_door maps\_doors::barred_door();	


}
// ---------------------//
// animtree for helicopters
#using_animtree("vehicles");
// wwilliams 11-27-07
// stolen from zvulaj science center b
// spawn helicopter and make it move
e2_helicopter_movement()
{
				// endon
				level endon( "event_two_done" );

				// objects to be defined for this function
				start_trig = getent( "trig_start_heli_movement", "targetname" );
				heli_spwn_origin = getent( "so_heli_spawn", "targetname" );
				ent_fly_point_one = getent( "so_heli_points", "targetname" );
				old_spot = undefined;
				new_target = undefined;
				fly_spot = [];

				// make the array of spots based on target
				fly_spot[fly_spot.size] = ent_fly_point_one;
				old_spot = ent_fly_point_one;
				// now loop to grab them all
				while( 1 )
				{
								if( !isdefined( old_spot.target ) )
								{
												// stop this loop
												break;
								}
								else if( isdefined( old_spot.target ) )
								{

												// make the targeted ent the new target
												new_target = getent( old_spot.target, "targetname" );
								}

								// add the target to the array
								fly_spot[fly_spot.size] = new_target;

								// make the last new_target to the old target
								old_spot = new_target;

								// quick wait just in case
								wait( 0.1 );
				}


				// spawn the helicopter
				heli_vehic = spawnvehicle( "v_heli_mdpd_low", "e3_heli", "blackhawk", ( heli_spwn_origin.origin ), ( heli_spwn_origin.angles ) );
				wait( 0.5 );
				heli_vehic.health = 10000;

				// animation to play on the helicopter
				heli_vehic UseAnimTree( #animtree );
				heli_vehic setanim( %bh_rotors );

				// attach light
				heli_vehic thread under_light();

				// runs the delete stuff
				heli_vehic thread heli_delete(heli_spwn_origin);

				// wait for the trigger to be activated
				start_trig waittill( "trigger" );

				// have it move about until the end of the event
				while( 1 )
				{
								//fly_spot = randomint( enta_heli_flight_points.size );
								for( i=0; i<fly_spot.size; i++ )
								{
												heli_vehic setspeed( 15, 15 );
												heli_vehic setvehgoalpos( fly_spot[i].origin, 0 );
												heli_vehic waittill( "goal" );
												wait( 1.0 );
								}
								wait( 1.0 );

				}

}
// ---------------------//

// ---------------------//
// wwilliams 11-27-07
// delete heli when player done with event 3
heli_delete( end_point )
{

	level waittill( "event_two_done" );

	self waittill( "goal" );

	//self setspeed(40, 40);
	// send him farther away before deleting (bug 23771)
	self setvehgoalpos ( end_point.origin + (0, -2000, 0), 0 );
	self waittill ( "goal" );

	self delete();
	level notify("heli_deleted");
}
// ---------------------//
//avulaj
// wwilliams
// stolen from science center a 11-27-07
under_light()
{
	//level endon( "event_two_done" );

	//org = getent ( "front_heli_spawn_point", "targetname" );
	entOrigin = Spawn( "script_model", self GetTagOrigin( "tag_turret" ) );
	entOrigin SetModel( "tag_origin" );
	entOrigin.angles = (0, 180, 0);
	entOrigin LinkTo( self );

	// playfx
	playfxontag ( level._effect["science_lightbeam05"], entOrigin, "tag_origin" );

	level waittill("heli_deleted");
	entOrigin delete();
}
// ---------------------//
// wwilliams 11-30-07
// wait for trig, start event 2
// 04-09-08
// commenting this out to lower script string usage
/*air_e2_start()
{
// endon

// stuff
trig = getent( "ent_close_e1_exit", "targetname" );

// wait for the flag to be hit
trig waittill( "trigger" );

// set the flag
level maps\_utility::flag_set( "event_two_start" );

}*/
// ---------------------//
// command action for rummaging through a desk
// guy leaves patrol, and checks someone's desk
// stolen from //avulaj science center, using this to test the command nodes
checking_desk()
{
				//self CmdAction( "Scratch" );
				pos = self.origin + ( 0, 0,64 );
				color = ( 0, .5, 0 );            
				scale = 1.5;       
				Print3d( pos, "Rummaging", color, 1, scale, 15 );
}
// ---------------------//
// command action for urinating
// guy leaves patrol, and uses the bathroom
// stolen from //avulaj science center, using this to test the command nodes
urination()
{
				//self CmdAction( "Scratch" );
				pos = self.origin + ( 0, 0,64 );
				color = ( 0, .5, 0 );            
				scale = 1.5;       
				Print3d( pos, "Relieving self", color, 1, scale, 15 );
}
// ---------------------//
// wwilliams 11-30-07
// expanding upon the cmdaction notifies along the routes
// still based off of what was stolen from avulaj
scan_area()
{
				pos = self.origin + ( 0, 0,64 );
				color = ( 0, .5, 0 );            
				scale = 1.5;       
				Print3d( pos, "Scanning area", color, 1, scale, 15 );
}
// ---------------------//
// ---------------------//
// 03-05-08
// wwilliams
// locking the virus hack door behind the player
// this runs on level
e2_lock_player_in_vr()
{
				// endon
				// not needed this is a straight shot function

				// objects to be defined for this function
				// the door to lock
				e2_vr_enter_door = getent( "ent_e2_virus_enter", "targetname" );

				// wait for the objective to be set after the player gets the virus
				level maps\_utility::flag_wait( "objective_2" );

				// close the door
				e2_vr_enter_door maps\_doors::close_door();

				// lock the door
				e2_vr_enter_door maps\_doors::barred_door();		
}
// ---------------------//
// ---------------------//
// 02-10-08
// wwilliams
// function that waits for the flag informing stealth has been broken in event 1
// runs on the level
// 02-12-08
// wwilliams
// retro fitting the functions from the first event backup situation to work in event two
// these functions should be made into utility script because they will be used in 
// the first three events
e2_stealth_flag_set()
{
	level endon("e2_clean_up");

	// 02-12-08
	// wwilliams
	// define the objects needed for this function
	spawner = getent( "spwn_e2_backup", "targetname" );
	// nodes to defend around
	noda_e2_defense = getnodearray( "nod_e2_backup", "targetname" );

	nod_e2_backup_1 = getnode( "nod_e2_backup1_start", "targetname" );
	nod_e2_backup_2 = getnode( "nod_e2_backup2_start", "targetname" );
	// monster closet door
	ent_e2_backup_door = getentarray( "e2_backup_door", "targetname" );

	// wait for notify that stealth is broken
	level waittill( "e2_stealth_broken" );

	// send out the notify to turn off all the other threads waiting
	level notify( "e2_stealth_cancelled" );

	// change the flag
	level maps\_utility::flag_set( "e2_stealth_broken" );

	// run the backup function
	level thread maps\airport_util::spawn_event_backup_init( spawner, noda_e2_defense );
}
// ---------------------//
// 05-21-08
// wwilliams
// new function sets up the player using the new feed box from the 
// zone 2 virus download
air_setup_zone3()
{
				// endon

				// objects to define for this function
				// trig
				trig = getent( "air_trig_setup_zone3", "targetname" );

				// wait for the trigger to be hit
				trig waittill( "trigger" );

				// set up event three
				// set up the cameras
				level maps\airport_three::e3_cameras_init();
				// set up the patroller
				level maps\airport_three::e3_patrol_setup();

}
// ---------------------//
// 03-17-08
// wwilliams
// function closes the door 
e2_comp_settings()
{
				// the first computer is placed into a array accessible by the entire level
				// this will set the function to run when the player starts the virus download
				// level.computer_array[1] maps\_useableobjects::set_on_begin_use_function( maps\airport_three::e3_patrol_setup() );

				// this will set which function runs once the player has finished the virus download
				// level.computer_array[1] maps\_useableobjects::set_on_end_use_function( ::e2_change_monitor_model );


}
// ---------------------//
// 03-28-08
// wwilliams
// changes teh model of the monitor to show that the machine has shut down after the virus is
// runs on the player
e2_change_monitor_model()
{
				// endon
				// single shot function

				// debug text
				// iprintlnbold( "inside e1_change_monitor_model!" );

				// check to see if the player finished
				//if( bool_result == false )
				//{
				//				// debug text
				//				// iprintlnbold( "leaving the func, bool_result was false!" );

				//				wait( 1.0 );

				//				// end the function
				//				return;
				//}

				// wait for the objective to complete
				level maps\_utility::flag_wait( "objective_2" );

				// ent
				computer = getent( "ent_air_comp_2", "targetname" ) ;

				// set model on the first monitor
				computer setmodel( "p_dec_monitor_modern" );

}
// ---------------------//
// 02-12-08
// wwilliams
// clean up function for event two
// deletes spawners, actors, and any other entity that needs to be gotten rid of
e2_clean_up()
{
	// endon
	// this is uneeded

	// 02-13-08
	// wwilliams
	// waits for the hack to finish in event 2
	level maps\_utility::flag_wait( "objective_2" );

	level notify("e2_clean_up");

	// objects to declare for the function
	enta_e2_spawners = getentarray( "e2_spawners", "script_noteworthy" );

	// for loop to go through the entity array of spawner
	for( i=0; enta_e2_spawners.size; i++ )
	{
		// 02-13-08
		// trying to fix a potential infinite script loop error
		wait( 0.05 );
		// check to see if this array object is not an ai
		if( !isai( enta_e2_spawners[i] ) )
		{
			// 02-13-08
			// trying to fix a potential infinite script loop error
			wait( 0.05 );
			// check to see if this array object is defined
			if( isdefined( enta_e2_spawners[i] ) )
			{
				// delete the spawner
				enta_e2_spawners[i] delete();

				// obligatory wait
				wait( 0.1 );
			}

		}

	}

	// space needed for more clean up stuff
}
// ---------------------//
// waits for player to hack the computer
// flag gets set event two finishes
// 02-12-08
// wwilliams
// adding that this function runs the clean up
end_event_two()
{

				// wait for the flag to be set
				// happens when the player finishes the virus room
				level maps\_utility::flag_wait( "objective_2" );

				// notify for the main function to end
				// which will send it into the next event
				level notify( "event_two_done" );


}
// ---------------------//
