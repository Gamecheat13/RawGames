// Airport utility file
// Builder: Brian Glines
// Scritper: Walter Williams
// Created: 10-08-2007

// Includes
#include maps\_utility;

airport_util_main()
{



}

// -------------------//
//print3d function, needs to place it where i want, loop for as long as I want, notify me when done
// only need to input the first four parts
// second have to be in the thousands!
loop_print3d( vec_text_position, str_text, color, seconds, str_notify, alpha, scale )
{
				// safety endons, for when i run this on entities
				self endon( "death" );
				self endon( "damage" );

				// double check that the position is set, this must be set
				assertex( isdefined( vec_text_position ), "Position for a loop_print3d is not set, ending function." );

				if( !isdefined( str_notify ) )
				{
								str_notify = "no_notify";
				}
				if( !isdefined( alpha ) )
				{
								alpha = 1;
				}
				if( !isdefined( scale ) )
				{
								scale = 0.5;
				}
				timer = GetTime() + seconds;
				while( GetTime() < timer )
				{
								//tell me he's there and getting a ticket
								print3d( vec_text_position, str_text, color, alpha, scale );
								wait( 0.05 );
				}

				level notify( str_notify );


}
// -------------------//
// wwilliams
// objectives, this will controls the objectives for airport
//<<Use>>( awareness_entity_name, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, awareness_material, awareness_glow, awareness_shine, wait_until_finished )
airport_objectives()
{
				// endon

				// objects to be defined for this function
				// script orgs
				objective_1_marker = getent( "ent_air_comp_1", "targetname" );
				objective_2_marker = getent( "ent_air_comp_2", "targetname" );
				objective_3_marker = getent( "ent_air_comp_3", "targetname" );
				objective_4a_marker = getent( "obj_4a_mark", "targetname" );
				objective_4b_marker = getent( "obj_4b_mark", "targetname" );
				objective_4c_marker = getent( "obj_4c_mark", "targetname" );
				objective_5_marker = getent( "ent_e5_gdoor_button", "targetname" );
				// trigs
				trig_move_to_4b = getent( "ent_start_e4_slam", "targetname" );
				trig_move_to_4c = getent( "trig_lugg_3_f4", "targetname" );

				// objective_4_marker = getent( "ent_e5_gdoor_button", "targetname" );
				//setupSingleUseOnly( awareness_entity_name, use_event_to_call, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished )

				// grab all the objective triggers
				enta_trig_air_objectives = getentarray( "hack_computers", "script_noteworthy" );

				// the array of hack computers
				level.computer_array = [];

				// the temp spot to use for the array
				temp_container = undefined;

				// 02-27-08
				// wwilliams
				// can't just grab these things in an array anymore
				// have to make sure the right computer goes into the right part of the
				// level.computer_array
				// place the first computer into the first spot of the level array
				temp_container = objective_1_marker setup_objective_reactions();
				// debug report
				// iprintlnbold( "finished applying the object_reactions on temp_container" );
				// now add it to the first spot of the array
				level.computer_array = maps\_utility::array_add( level.computer_array, temp_container );
				//debug report
				// iprintlnbold( "finished adding temp_container to level.array" );
				// now that the item is in the array i can undefine the container i used to put it in there
				temp_contianer = undefined;

				// quick wait to make sure these don't fall in the same frame
				wait( 0.05 );

				// now the second computer
				temp_container = objective_2_marker setup_objective_reactions();
				// iprintlnbold( "finished applying the object_reactions on temp_container" );
				level.computer_array = maps\_utility::array_add( level.computer_array, temp_container );
				// iprintlnbold( "finished adding temp_container to level.array" );
				temp_contianer = undefined;

				// quick wait to make sure these don't fall in the same frame
				wait( 0.05 );

				// and the last computer where the antivirus is uploaded
				temp_container = objective_3_marker setup_objective_reactions();
				// iprintlnbold( "finished applying the object_reactions on temp_container" );
				level.computer_array = maps\_utility::array_add( level.computer_array, temp_container );
				// iprintlnbold( "finished adding temp_container to level.array" );
				temp_contianer = undefined;

				// first obj - download virus
				if( !maps\_utility::flag( "objective_1" ) )
				{
								// first virus download

								// wait for the notify from the tanner lines
								level waittill( "give_1st_obj" );

								objective_add( 1, "active", &"AIRPORT_OBJ_1_TITLE", objective_1_marker.origin, &"AIRPORT_OBJ_1_BODY" );
								level maps\_utility::flag_wait( "objective_1" );
								objective_state( 1, "done" );
				}

				// second obj - download rest of virus
				if( !maps\_utility::flag( "objective_2" ) )
				{
								// second virus download
								objective_add( 2, "active", &"AIRPORT_OBJ_2_TITLE", objective_2_marker.origin, &"AIRPORT_OBJ_2_BODY" );
								level maps\_utility::flag_wait( "objective_2" );
								objective_state( 2, "done" );
				}

				// third obj - upload the anti virus
				if( !maps\_utility::flag( "objective_3" ) )
				{
								// upload the antivirus
								objective_add( 3, "active", &"AIRPORT_OBJ_3_TITLE", objective_3_marker.origin, &"AIRPORT_OBJ_3_BODY" );
								level maps\_utility::flag_wait( "objective_3" );
								objective_state( 3, "done" );
				}

				// fourth obj - move through the luggage room
				if( !maps\_utility::flag( "objective_4" ) )
				{

								// objective 4 stuff will go here
								objective_add( 4, "active", &"AIRPORT_OBJ_4_TITLE", objective_4a_marker.origin, &"AIRPORT_OBJ_4_BODY" );

								// wait for the player to hit the 4b trig
								trig_move_to_4b waittill( "trigger" );

								// change the marker to the next spot
								objective_add( 4, "active", &"AIRPORT_OBJ_4_TITLE", objective_4b_marker.origin, &"AIRPORT_OBJ_4_BODY" );

								// wait for the player to hit the 4c trig
								trig_move_to_4c waittill( "trigger" );

								// change marker to next spot
								objective_add( 4, "active", &"AIRPORT_OBJ_4_TITLE", objective_4c_marker.origin, &"AIRPORT_OBJ_4_BODY" );

								level maps\_utility::flag_wait( "objective_4" );
								objective_state( 4, "done" );
				}

				// fifth obj - open garage doors
				if( !maps\_utility::flag( "objective_5" ) )
				{
								// objective 5 stuff will go here
									objective_add( 5, "active", &"AIRPORT_OBJ_5_TITLE", objective_5_marker.origin, &"AIRPORT_OBJ_5_BODY" );
								level maps\_utility::flag_wait( "objective_5" );
								objective_state( 5, "done" );
				}

				// wait for the notify that carlos is spawned
				level waittill( "carlos_made" );

				// sixth obj - carlos objective
				if( !maps\_utility::flag( "objective_6" ) )
				{
								// objective 6 setup
								objective_add( 6, "active", &"AIRPORT_OBJ_6_TITLE", level.carlos.origin, &"AIRPORT_OBJ_6_BODY" );

								// wait for the flag to change
								level maps\_utility::flag_wait( "objective_6" );

				}



}
// -------------------//
// wwilliams 12-04-07
// take each objective point and setup the event for it
setup_objective_reactions()
{
				// endon

				// stuff, should all come off of self which is the script model of the monitors
				// awareness_entity_name = self.targetname;
				// hint_string = "Press &&1 to hack computer.";
				// use_time = self.script_int;
				// use_text = undefined;
				// require_lookat = false;
				// filter_to_call = undefined;
				// awareness_material = undefined;
				// awareness_glow = true;
				// awareness_shine = true;
				// wait_until_finished = undefined;
				// single_use = true;

				// iprintlnbold( "inside setup_objective_reactions" );

				// define the objects needed for this function
				str_flag = undefined;
				int_which_message = undefined;
				// create_useable_object( 
				entity = self;
				on_use_function = ::temp_hack_computer;
				hint_string = &"HINT_HACK_COMPUTER";
				// hint_string = "Hold &&1 to hack computer.";
				use_time = self.script_int;
				use_text = undefined; 
				single_use = true ;
				require_lookat = true;
				initially_active = true;
				// this is the thing that returns out
				ent_return = undefined;


				if( self.script_string == "download" )
				{
								use_text = &"AIRPORT_DOWNLOAD_VIRUS";
								if( !maps\_utility::flag( "objective_1" ) )
								{
												str_flag = "objective_1";
												int_which_message = 0;
								}
								else if( maps\_utility::flag( "objective_1" ) && !maps\_utility::flag( "objective_2" ) )
								{
												str_flag = "objective_2";
												int_which_message = 0;
								}

				}
				else if( self.script_string == "upload" )
				{
								use_text = &"AIRPORT_UPLOAD_VIRUS";
								str_flag = "objective_3";
								int_which_message = 1;

				}

				// now call the self
				// self thread maps\_playerawareness::setupSingleUseOnly( awareness_entity_name, ::temp_hack_computer, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
				ent_return = self maps\_useableobjects::create_useable_object( entity, on_use_function, hint_string, use_time, use_text, single_use, require_lookat, initially_active );

				// once the useable object has been set up them return it back to the for loop that called this function
				return ent_return;

}
// -------------------//
// wwilliams 12-10-07
// function for checking the amount of items recieved
// need to pass in the entity from the setup because the function threads on the awareness ent
airport_laptop_count( awareness_entity_name )
{
				// stuff
				int_amount = undefined;

				// changes the count up as each laptop is hacked
				level.awareness_obj++;

				// copy over the amount
				int_amount = level.awareness_obj;

				// debug text to the screen
				//iprintlnbold( "Located " + int_amount + "o f 3 cellphones in airport." );

				wait( 1.0 );

				if( level.awareness_obj == 3 )
				{
								level playerawareness_laptop_success();
				}
}
// -------------------//
// wwilliams 12-10-07
// success for finding all the laptops
playerawareness_laptop_success()
{
				// just prints to the screen
				//iprintlnbold( "SUCCESS!" );

				wait( 2.0 );

				//iprintlnbold( "You found all the hidden phones in Airport!" );
}
// -------------------//
temp_hack_computer( thing )
{
				// stuff
				str_flag = undefined;
				int_which_message = undefined;
				player_spot = undefined;
				mover = undefined;

				// get info from self in order to set the stuff needed
				if( !maps\_utility::flag( "objective_1" ) )
				{
								str_flag = "objective_1";
								int_which_message = 0;
								player_spot = getent( "ent_obj_1", "targetname" );
				}
				else if( maps\_utility::flag( "objective_1" ) && !maps\_utility::flag( "objective_2" ) )
				{
								str_flag = "objective_2";
								int_which_message = 0;
								player_spot = getent( "ent_obj_2", "targetname" );
				}
				else if( maps\_utility::flag( "objective_1" ) && maps\_utility::flag( "objective_2" ) && !maps\_utility::flag( "objective_3" ) )
				{
								str_flag = "objective_3";
								int_which_message = 1;
								player_spot = getent( "ent_obj_3", "targetname" );
				}

				// sound for hacking
				level.player playsound( "AIR_computer_hack" );

				level notify( "hack_complete" );

				// set the flag to finish the objective
				// wwilliams 10-29-07, moving this notify here so the suspense guy during objective one moves
				// while the player is still at the computer
				level maps\_utility::flag_set( str_flag );
				level notify( str_flag );
				//trig maps\_utility::trigger_off();


				// the message to display what is happening
				if( int_which_message == 0 )
				{
								// iprintlnbold( "Player downloads virus to phone" );
								// wait( 1.0 );
				}
				else if( int_which_message == 1 )
				{
								// iprintlnbold( "Player uploads the antivirus from phone" );
								// wait( 1.0 );
				}

}
// -------------------//

// ---------------------//
// 02-10-08
// wwilliams
// function checks on the enemies to wait forthem to go alert red
// then sends out the notifies that stealth is broken
// some of this code is taken from teh aigroup functions in _spawner that brian barnes wrote
// 02-12-08
// wwilliams
// retro fitting the functions from the first event backup situation to work in event two
// these functions should be made into utility script because they will be used in 
// the first three events
event_enemy_watch( str_endon, str_notify )
{
				// endon
				self endon( "death" );
				level endon( str_endon );

				// 06-09-08
				// wwilliams
				// wait for the propagation
				self waittill( "start_propagation" );

				// wait for self to be alerted
				/* if ( self GetAlertState() != "alert_red" )
				{
				self waittill( "alert_red" );
				} */

				// notify that stealth has been broken
				level notify( str_notify );

}
// ---------------------//
// 02-10-08
// wwilliams
// watches the security cameras, when they become alerted
// sends out the notify that stealth is broken
// 02-12-08
// wwilliams
// retro fitting the functions from the first event backup situation to work in event two
// these functions should be made into utility script because they will be used in 
// the first three events
// runs on the camera
event_camera_watch( str_endon, str_notify )
{
				// endon
				self endon( "disable" );
				self endon( "damage" );
				level endon( str_endon );

				// wait for the camera to become alerted
				self waittill( "spotted" );

				// once the camera has spotted the player send out the 
				// stealth break notify
				level notify( str_notify );

}
// ---------------------//
// 02-11-08
// wwilliams
// if the security camera is destroyed by the player
// stealth is broken and enemies will spawn out
// 02-12-08
// wwilliams
// retro fitting the functions from the first event backup situation to work in event two
// these functions should be made into utility script because they will be used in 
// the first three events
event_camera_destroyed( str_endon, str_notify )
{
				// endon
				self endon( "disable" );
				level endon( str_endon );

				// wait for the damage to happen
				self waittill( "damage" );

				// send out the notify that stealth has been broken
				level notify( str_notify );

}
// ---------------------//
// 02-11-08
// wwilliams
// function disables the camera if stealth is broken
// 02-12-08
// wwilliams
// retro fitting the functions from the first event backup situation to work in event two
// these functions should be made into utility script because they will be used in 
// the first three events
event_camera_disable( str_waittill )
{
				// endons
				self endon( "disable" );
				self endon( "damage" );

				// wait for the stealth cancelled notify
				level waittill( str_waittill );

				// disable the camera
				self notify( "disable" );
}
// ---------------------//
// 02-10-08
// wwilliams
// checks for the farthest spawn closet
// spawns out extra enemies when stealth was broken
// uses camera functionality
// 02-12-08
// wwilliams
// retro fitting the functions from the first event backup situation to work in event two
// these functions should be made into utility script because they will be used in 
// the first three events
// runs on level
spawn_event_backup_init( spawner, node_array_defense )
{
				// endons, should not be needed

				// assert checks on the items passed into it
				assertex( isdefined( spawner ), "spawner is not defined for backup!" );
				assertex( isdefined( node_array_defense ), "spawner is not defined for backup!" );

				level thread spawn_event_backup( spawner, node_array_defense );

}
// ---------------------//
// 02-11-08
// wwilliams
// function that takes the spawner, nodes, and camera
// populates the area
// freezes the player and the ai
// runs on level
// 02-12-08
// wwilliams
// removing the calls for the camera cuts when backup spawns in
// 02-21-08
// wwilliams
// changing this to only use the spawn point to populate from
// if point two is closer than point one
spawn_event_backup( spawner, noda_destin )
{
				// double check the defines
				assertex( isdefined( spawner ), "spawner not defined, function will fail!" );
				// 02-21-08
				// wwilliams
				// changing this to only use the spawn point to populate from
				// if point two is closer than point one
				//assertex( isdefined( nod_backup ), "nod_backup not defined, function will fail!" );
				assertex( isdefined( noda_destin ), "noda_destin not defined, function will fail!" );

				// define an empty object to use in this function
				str_dood_targetname = undefined;
				// need another empty object for the tether radius
				int_tether_radius = undefined;
				// empty object for the guys who will spawn out
				ent_temp = undefined;
				// needed for the switch statement that will decide what kind of brain the ai uses
				int_choice = undefined;
				// brain to use for the guy
				str_brain = undefined;

				// check to see if the spawner has a script_parameter
				// will use this as the targetname of all the guys who come out of the spawner
				if( isdefined( spawner.script_parameters ) )
				{
								str_dood_targetname = spawner.script_parameters;
				}
				else
				{
								//iprintlnbold( "" + spawner.targetname + " has no script_parameters, can't clean up the guys!" );
				}

				// check to see if the spawner has a script_int on it
				// if it does then that is the tether radius
				// if not then set a deafult distance
				if( isdefined( spawner.script_int ) )
				{
								// specialized tether radius
								int_tether_radius = spawner.script_int;
				}
				else
				{
								// make a default distance for the tether radius
								int_tether_radius = 448;
				}

				// make the spawner count big enough
				// this size will be based on the amount of nodes grabbed
				spawner.count = noda_destin.size;

				// for loop goes through the nodes,
				// spawns a guy out for each,
				// moves him to the farthest closet from the player
				// and sends them to their protection area
				for( i=0; i<noda_destin.size; i++ )
				{
								// spawn out two guys for backup
								ent_temp = spawner stalingradspawn( str_dood_targetname );
								if( !maps\_utility::spawn_failed( ent_temp ) )
								{
												// lock the ai alert state to red
												ent_temp lockalertstate( "alert_red" );

												// 02-27-08
												// wwilliams
												// trying out the new ai types
												// int_choice = i;

												// 02-28-08
												// wwilliams
												// new call to the new utility function
												// str_brain = airport_give_me_brain( "elite" );

												// give him the brain linked with the slot in the array
												// ent_temp SetCombatRole( "elite" );

												// set the tether radius of the backup guy
												// ent_temp SetTetherRadius( int_tether_radius );

												// give NPC perfect sense for a few seconds
												ent_temp thread turn_on_sense();

												// send him to his node 
												ent_temp setgoalnode( noda_destin[i] );

												// give NPC tether after goal
												ent_temp thread give_tether_at_goal( noda_destin[i], 384, 1028, 256 );

												//wait a frame
												wait( 1.0 );

								}
								else
								{
												//iprintlnbold( "ent_temp failed spawning, ending function!" );
												return;
								}

								// frame wait to make sure this if is done
								wait( 1.0 );

								// undefined ent_temp
								ent_temp = undefined;

				}

}
// ---------------------//
// 02-28-08
// wwilliams
// function gets a interger and then returns a brain for teh ai to use
// runs on level
// enter int, return string
airport_give_me_brain( int_brain )
{
				// endon

				// objects to define for this function
				str_brain = undefined;

				// 02-27-08
				// wwilliams
				// trying out the new ai types
				choice = int_brain;

				// switch statement
				switch( choice )
				{
								// case 0 is a defender, but has to use a flanker mind until we get defender
				case 0:
								str_brain = "flanker";

								// break out of the statement
								break;

								// case 1 is also a defender, but will use flanker until defender comes online
				case 1:
								str_brain = "flanker";

								// break out of the statement
								break;

								// case 2 is a rusher, want to see how it works
				case 2:
								str_brain = "rusher";

								// break out of the statement
								break;

								// case 3 will also be a rusher
				case 3:
								str_brain = "rusher";

								// break out of the statement
								break;

								// placing a case 4 for later
				case 4:
								str_brain = "flanker";

								// break out of the statement
								break;

								// placing a case 5  for later
				default:
								str_brain = "flanker";

								// break out of the statement
								break;

				}

				return str_brain;


}
// -------------------//
// 03-11-08
// wwilliams
// plane that flies overhead in event one and two,
// this will also control the plane that flies over the luggage room
// runs on level
airport_plane_flyby()
{
				// endon
				// not sure if this will be needed

				// objects to be defined for this function
				so_first_path = getent( "so_overhead_airplane_start_01", "targetname" );
				so_first_path_end = getent( so_first_path.target, "targetname" );
				so_second_path = getent( "so_overhead_airplane_start_02", "targetname" );
				so_second_path_end = getent( so_second_path.target, "targetname" );
				so_third_path = getent( "so_overhead_airplane_start_03", "targetname" );
				so_third_path_end = getent( so_third_path.target, "targetname" );
				ent_plane = undefined;

				// first spawn the plane in at the beginning of the path
				ent_plane = spawn( "script_model", so_first_path.origin );

				// wait a frame
				wait( 0.05 );

				// set the model on the ent_plane
				ent_plane setmodel( air_random_plane() );

				// set the angles
				ent_plane.angles = so_first_path.angles;

				// debug text
				// iprintlnbold( "v_jet_jumbo in place!" );

				// hide it until starting up the movement
				ent_plane hide();

				// test
				while( maps\_utility::flag( "airplane_fly_over_01" ) )
				{
								// show the plane
								ent_plane show();

								// move it down the path
								ent_plane moveto( so_first_path_end.origin, 5.0 );

								// debug text
								// iprintlnbold( "v_jet_jumbo in flying by!" );

								// 03-27-08
								// wwilliams
								// play sound on the plane
								ent_plane playsound( "AIR_airplane_fly_over" );

								// earthquake
								wait( 3.0 );
								earthquake( 0.1, 3.0, level.player.origin, 850 );

								// make the controller rumble
								// level thread air_ctrl_rumble_timer( 3 );

								// wait for the move to finsih
								ent_plane waittill( "movedone" );

								// hide the plane
								ent_plane hide();

								// move it back to the start
								ent_plane moveto( so_first_path.origin, 0.1 );

								// wait for move to finish
								ent_plane waittill( "movedone" );

								// set the model on the ent_plane
								ent_plane setmodel( air_random_plane() );

								// a dedicated wait to make sure there is a long pause between the
								// rumble calls
								// wait( 240 );

								// wait until the next time the plane should fly over
								wait( randomfloatrange( 110.0, 240.0 ) );

				}

				// wait before checking for the second route flag
				wait( 5.0 );

				// move the plane to the second start
				ent_plane moveto( so_second_path.origin, 0.1 );

				// wait for the move to finish
				ent_plane waittill( "movedone" );

				// set the angles
				ent_plane.angles = so_second_path.angles;

				// second route for the plane to fly over
				while( maps\_utility::flag( "airplane_fly_over_02" ) )
				{
								// show the plane
								ent_plane show();

								// move it down the path
								ent_plane moveto( so_second_path_end.origin, 5.0 );

								// debug text
								// iprintlnbold( "v_jet_jumbo in flying by!" );

								// 03-27-08
								// wwilliams
								// play sound on the plane
								ent_plane playsound( "AIR_airplane_fly_over" );

								// earthquake
								wait( 3.0 );
								earthquake( 0.1, 3.0, level.player.origin, 850 );

								// make the controller rumble
								// level thread air_ctrl_rumble_timer( 3 );

								// wait for the move to finsih
								ent_plane waittill( "movedone" );

								// hide the plane
								ent_plane hide();

								// move it back to the start
								ent_plane moveto( so_second_path.origin, 0.1 );

								// wait for move to finish
								ent_plane waittill( "movedone" );

								// set the model on the ent_plane
								ent_plane setmodel( air_random_plane() );

								// a dedicated wait to make sure there is a long pause between the
								// rumble calls
								// wait( 240 );

								// wait until the next time the plane should fly over
								wait( randomfloatrange( 110.0, 240.0 ) );

				}

				// wait before checking for the third route flag
				wait( 5.0 );

				// move the plane to the second start
				ent_plane moveto( so_third_path.origin, 0.1 );

				// wait for the move to finish
				ent_plane waittill( "movedone" );

				// set the angles
				ent_plane.angles = so_third_path.angles;

				// third route for the plane to fly over
				while( maps\_utility::flag( "airplane_fly_over_03" ) )
				{
								// show the plane
								ent_plane show();

								// move it down the path
								ent_plane moveto( so_third_path_end.origin, 5.0 );

								// debug text
								// iprintlnbold( "v_jet_jumbo in flying by!" );

								// 03-27-08
								// wwilliams
								// play sound on the plane
								ent_plane playsound( "AIR_airplane_fly_over" );

								// earthquake
								wait( 3.0 );
								earthquake( 0.1, 3.0, level.player.origin, 850 );

								// make the controller rumble
								// level thread air_ctrl_rumble_timer( 3 );

								// wait for the move to finsih
								ent_plane waittill( "movedone" );

								// hide the plane
								ent_plane hide();

								// move it back to the start
								ent_plane moveto( so_third_path.origin, 0.1 );

								// wait for move to finish
								ent_plane waittill( "movedone" );

								// set the model on the ent_plane
								ent_plane setmodel( air_random_plane() );

								// a dedicated wait to make sure there is a long pause between the
								// rumble calls
								// wait( 240 );

								// wait until the next time the plane should fly over
								wait( randomfloatrange( 110.0, 240.0 ) );

				}
}
// -------------------//
// 04-11-08
// wwilliams
// function returns a model for the airplane to fly over
// runs on level
air_random_plane()
{
				// contianer to hold the plane
				mld_plane = undefined;

				// six different planes, randomly pick a plane
				int_plane = randomint( 5 );

				// switch statement
				switch( int_plane )
				{
				case 0:
								// use this variant
								mld_plane = "v_jumbo_jet_v1";

								// leave the switch
								break;

				case 1:
								// use this variant
								mld_plane = "v_jumbo_jet_v1";

								// leave the switch
								break;

				case 2:
								// use this variant
								mld_plane = "v_jumbo_jet_v1";

								// leave the switch
								break;

				case 3:
								// use this variant
								mld_plane = "v_jet_737_stationary_v1";

								// leave the switch
								break;

				case 4:
								// use this variant
								mld_plane = "v_jet_737_stationary_v1";

								// leave the switch
								break;

				case 5:
								// use this variant
								mld_plane = "v_jet_737_stationary_v1";

								// leave the switch
								break;
				}

				// return the model
				return mld_plane;

}
// -------------------//
// 03-18-08
// wwilliams
// function removes anything that passes !isai from an array
only_ai_in_array( array )
{
				// make sure an array was passed in
				assertex( isdefined( array ), "Array not defined, ending remove_spawners" );

				// define a new array
				// this will be returned at the bottom
				newArray = [];

				// go through the array passed in 
				for( i=0; i<array.size; i++ )
				{
								// if the spot in the array does not register as an ai exlude it from addition
								if ( !isai( array[i] ) )
								{
												// go to the next spot
												continue;
								}

								// if spot is ai add it to the new array
								newArray[newArray.size] = array[i];
				}

				// return the cleaned array
				return newArray;
}
// -------------------//
// 03-19-08
// wwilliams
// moving fan function will grab all the fans then wait for the right flag before sending them off into their own
// functions to control the fan moving
airport_fans_init()
{
				// endon
				// not needed

				// objects to define for this function
				// ent_array
				// air_fans = getentarray( "ent_airport_fans", "targetname" );
				// array for the streamers
				air_streamers = getentarray( "fan_streamer", "script_noteworthy" );
				// undefinde
				ent_link = undefined;



				// go through the loop and link the stream to the target
				for( i=0; i<air_streamers.size; i++ )
				{
								// make sure there is a target for the streamer
								assertex( isdefined( air_streamers[i].target ), "streamer missing a target!" );

								// grab the ent to link it to
								ent_link = getent( air_streamers[i].target, "targetname" );

								// link them
								air_streamers[i] linkto( ent_link );

								// wait a frame
								wait( 0.05 );

								// undefine the temp
								ent_link = undefined;

								// frame wait
								wait( 0.05 );
				}


				// wait for the flag to be set in airport
				level maps\_utility::flag_wait( "objective_3" );

				// tell the streamers to start moving
				level notify( "streamer_2_start" );
				level notify( "streamer_3_start" );

				// for loop threads each fan to have it's own function
				// for( i=0; i<air_fans.size; i++ )
				// {
				// thread the function on the fan itself
				//	air_fans[i] thread airport_fan_rotate();

				// quick wait
				//	wait( 0.05 );
				//}



}
// -------------------//

// --------------------------------- //
// 03-26-08
// wwilliams
// rumble loop function so I can call it for the amount of time I need
air_ctrl_rumble_timer( time )
{
				// endon

				// double check the time so it is an int
				assertex( isdefined( time ), "time is not defined for a ctrl_rumble" );

				// objects to defined for this function
				int_count = 0;

				// loop the rumble
				while( int_count <= time )
				{
								// make the controller rumble
								level.player playrumbleonentity( "damage_light" );

								// wait a second
								wait( 0.25 );

								// make the controller rumble
								level.player playrumbleonentity( "damage_light" );

								// wait a second
								wait( 0.25 );

								// make the controller rumble
								level.player playrumbleonentity( "damage_light" );

								// wait a second
								wait( 0.25 );

								// make the controller rumble
								level.player playrumbleonentity( "damage_light" );

								// wait a second
								wait( 0.25 );

								// increase the count of int_count
								int_count++;
				}
}

// --------------------------------- //
// 04-11-08
// wwilliams
// function makes a guy sprint until he reches goal,
// then changes the speed back to run
// runs on guy/self
sprint_to_goal(ignore_player)
{
	// endon
	self endon( "death" );

	if(!isdefined(ignore_player))
		ignore_player = false;

	if(!ignore_player)
	{
		// set engagerules so guys don't just run pass the player
		self setengagerule( "tgtSight" );
		self addengagerule( "tgtPerceive" );
		self addengagerule( "Damaged" );
		self addengagerule( "Attacked" );
	}
	else
	{
		self setenablesense(false);
	}

	// change the speed
	self setscriptspeed( "sprint" );

	// wait for goal
	self waittill( "goal" );

	// change speed back to run
	self setscriptspeed( "default" );

	if(ignore_player)
	{
		self setenablesense(true);
	}
}
// --------------------------------- //
// 06-11-08
// wwilliams
// function waits for the guy to go to alert red
// once he does then the scriptspeed is set back
// to default
// runs on self/NPC
reset_script_speed()
{
	// endon
	self endon( "death" );

	// while loop checks for the guy not to go into alert red
	while( self getalertstate() != "alert_red" )
	{
		if(!isdefined(self))
			return;

		// wait
		wait( 0.05 );
	}

	// change the script speed to default
	self setscriptspeed( "default" );

}
// --------------------------------- //
// 06-26-08
// wwilliams
// if a guy is setenablesense( false ), but takes damage from the player
// the guy needs to turn his setenablesense( true ) and get a few seconds
// of perfect sense
// runs on self/NPC
dmg_turn_sense_on()
{
				// endon
				self endon( "death" );
				self endon( "sense_on" );

				// wait for damage
				self waittill( "damage", int_amount, str_attacker );

				// check to make sure it was the player
				if( str_attacker == level.player )
				{
								// turn the sense back on
								self setenablesense( true );

								// give the ai perfect sense for a sec
								self turn_on_sense( 3 );
				}


}
// ---------------------//
// 06-25-08
// wwilliams
// make the guy go into perfect sense for a few secs
turn_on_sense( int_time )
{
				// endon
				self endon( "death" );

				// overload on the int_time
				if( !isdefined( int_time ) )
				{
								int_time = 3;
				}

				// turn on perfect sense
				self setperfectsense( true );

				// wait
				wait( 3 );

				// check to see if he is defined and alive
				if( IsDefined( self ) && isalive( self ) )
				{
								// turn off perfect sense
								self setperfectsense( false );

				}           
}
// ---------------------//
// 06-27-08
// wwilliams
// give tether after goal has hit
// runs on self/NPC
give_tether_at_goal( node, int_lowest_tether, int_highest_tether, int_min_tether )
{
				// endon
				self endon( "death" );

				// double check what was passed in
				assertex( isdefined( node ), "str_node not defined" );
				assertex( isdefined( int_lowest_tether ), "int_lowest_tether not defined" );
				assertex( isdefined( int_highest_tether ), "int_highest_tether not defined" );
				assertex( isdefined( int_min_tether ), "int_min_tether not defined" );

				// wait for goal on guy
				self waittill( "goal" );

				// tether the guy to the node passed in
				self.tetherpt = node.origin;
				
				// run the tether function on the guy
				self thread luggage_room_active_tether( int_lowest_tether, int_highest_tether, int_min_tether );

}
// ---------------------//
// 02-27-08
// wwilliams
// function controls the distance of the tether on the guy that it runs on
// stolen from mmailhot's challenge_gauntlet scripts cause it works great and my own function will look very dirty
// adding alot of notes
// first off the guy who this runs on must already have a .tetherpt set
// runs on an ent
// tetherdelta0 is the closest to the tetherpt
// tetherdelta1 is the farthest
// mintether is the minimum amount from the tether point allowed
luggage_room_active_tether( tetherDelta0, tetherDelta1, minTether )
{
				// endon
				self endon( "death" );

				// check to make sure everything passed in works properly
				assertex( isdefined( tetherdelta0 ), "tetherdelta0 is not defined!" );
				assertex( isdefined( tetherDelta1 ), "tetherDelta1 is not defined!" );
				assertex( isdefined( minTether ), "minTether is not defined!" );
				assertex( isdefined( self.tetherpt ), "self.tetherpt is not defined!" );

				// make a tether distance between the numbers fed in
				// just in case 0 is greater than 1
				if( tetherDelta0 > tetherDelta1 )
				{
								tetherDelta = randomfloatrange( tetherDelta1, tetherDelta0 );
				}
				// or do it normally is 0 is less than 1
				else
				{
								tetherDelta = randomfloatrange( tetherDelta0, tetherDelta1 );
				}


				// defining the newrad out here as undefined, i've had problems with making a new object
				// inside of loops so i'm trying to avoid it
				newRad = 1;
				//iprintlnbold( "" + newRad + "" );

				// get the guy's tetherpt origin
				vec_tether_point = self.tetherpt;

				//assertex( isdefined( vec_tether_point ), "vec_tether_point is not defined!" );
				//assertex( isdefined( self.tetherradius ), "self.tetherradius is not defined!" );

				// wwilliams
				// adding a check to make sure the guy has a .tetherpt set on him
				if( !isdefined( self.tetherpt ) )
				{
								//iprintlnbold( "no_tether_on " + self.targetname );
								return;
				}

				// if the tetherpt is set on the guy then start the loop that keeps him moving around
				// plus the while condition wouldn't work if the guy doesn't have the tetherpt
				while( isdefined( self.tetherPt ) )
				{				
								// wait a random time between 1.0 and 3.5		
								wait( randomfloat( 1.0, 3.5 ) );

								// sets self.tetherpt to a level.tetherpt.origin
								// not needed from the original script written by mmailhot
								// self.tetherpt = level.tetherPt.origin;

								// newrad gets set by the distance between the ai and the player
								// minus the random distance made at the beginning of the function
								newRad = Distance( level.player.origin, vec_tether_point ) - tetherDelta;

								// quick wait
								wait( 0.05 );

								//assertex( isdefined( newRad ), "newRad is not defined!" );

								//iprintlnbold( "" + newRad + "" );


								// check the new distance placed into newrad
								if( newRad < self.tetherradius )
								{	
												//Make sure we respect the minimal tether Radius
												// if the newrad distance is lower than the mintether passed into the function
												// then just make the tetherradius the mintether
												if( newRad < minTether )
												{
																// setting the radius to the mintether until next time around
																self.tetherradius = minTether;
												}
												else
												{
																// if the distance is not too small then set it
																self.tetherradius = newRad;

																// make a new tetherdelta for the next rotation
																tetherDelta = randomfloatrange( tetherDelta0, tetherDelta1 );
												}
								}
				}
}
// ---------------------//
// WW 07-09-08
// sets the combat role once the npc gets to the goal
// runs on self/npc
combat_role_on_goal( sCombatRole )
{
				// endon
				self endon( "death" );

				// check the object passed in
				assertex( isdefined( sCombatRole ), "combat role not passed in for " + self.targetname );
				assertex( isstring( sCombatRole ), "combat role pass not string" );

				// wait for goal
				self waittill( "goal" );

				// assign combat role
				self SetCombatRole( sCombatRole );
}
// ---------------------//
// WW 07-01-08
// first radio broadcast
airport_news_radio_one()
{
				// endon
				level.player endon( "death" );

				// objects to be defined for the function
				// ents
				radio = getent( "smodel_radio_1", "targetname" );
				// double check the radio define
				assertex( isdefined( radio ), "radio one not defined" );
				assertex( isdefined( radio.target ), "radio one has not target" );
				// trig
				trig = getent( radio.target, "targetname" );
				// double check trig
				assertex( isdefined( trig ), "radio one trig not defined" );

				// wait for the trigger to be hit
				trig waittill( "trigger" );
				

				// play the news broadcast
				// line 1 - radio male
				radio play_dialogue( "RDM_AirpG_501A" );

				// line 2 - traffic reporter
				radio play_dialogue( "RTR_AirpG_502A" );

				// line 3 - radio male
				radio play_dialogue( "RDM_AirpG_503A" );

				// line 4 - reporter 1
				radio play_dialogue( "RDR1_AirpG_504A" );

				// line 5 - radio male
				radio play_dialogue( "RDM_AirpG_505A" );

				// line 6 - reporter 1
				radio play_dialogue( "RDR1_AirpG_506A" );

				// line 7 - radio male
				radio play_dialogue( "RDM_AirpG_507A" );

				// clean up trigger
				trig delete();
}
// ---------------------//
// WW 07-01-08
// second radio broadcast
airport_news_radio_two()
{
				// endon
				level.player endon( "death" );

				// objects to be defined for the function
				// ents
				radio = getent( "smodel_radio_2", "targetname" );
				// double check the radio define
				assertex( isdefined( radio ), "radio two not defined" );
				assertex( isdefined( radio.target ), "radio two has not target" );
				// trig
				trig = getent( radio.target, "targetname" );
				// double check trig
				assertex( isdefined( trig ), "radio two trig not defined" );

				// wait for the trigger to be hit
				trig waittill( "trigger" );

				// play the news broadcast
				// line 1 - radio male
				radio play_dialogue( "RDM_AirpG_512A" );

				// line 2 - reporter 2
				radio play_dialogue( "RDR2_AirpG_513A" );

				// line 3 - radio male
				radio play_dialogue( "RDM_AirpG_514A" );

				// line 4 - reporter 2
				radio play_dialogue( "RDR2_AirpG_515A" );

				// line 5 - radio male
				radio play_dialogue( "RDM_AirpG_516A" );

				// line 6 - traffic reporter
				radio play_dialogue( "RTR_AirpG_517A" );

				// line 7 - radio male
				radio play_dialogue( "RDM_AirpG_518A" );

				// clean up trigger
				trig delete();
}
// ---------------------//
// WW 07-01-08
// third radio broadcast
airport_news_radio_three()
{
				// endon
				level.player endon( "death" );

				// objects to be defined for the function
				// ents
				radio = getent( "smodel_radio_3", "targetname" );
				// double check the radio define
				assertex( isdefined( radio ), "radio three not defined" );
				assertex( isdefined( radio.target ), "radio three has not target" );
				// trig
				trig = getent( radio.target, "targetname" );
				// double check trig
				assertex( isdefined( trig ), "radio three trig not defined" );

				// wait for the trigger to be hit
				trig waittill( "trigger" );

				// play the news broadcast
				// line 1 - radio male
				radio play_dialogue( "RDM_AirpG_519A" );

				// line 2 - reporter 1
				radio play_dialogue( "RDR1_AirpG_520A" );

				// line 3 - radio male
				radio play_dialogue( "RDM_AirpG_521A" );

				// line 4 - reporter 1
				radio play_dialogue( "RDR1_AirpG_522A" );

				// line 5 - radio male
				radio play_dialogue( "RDM_AirpG_523A" );

				// line 6 - reporter 3
				radio play_dialogue( "RDR3_AirpG_524A" );

				// line 7 - radio male
				radio play_dialogue( "RDM_AirpG_525A" );

				// line 8 - reporter 3
				radio play_dialogue( "RDR3_AirpG_526A" );

				// line 9 - radio male
				radio play_dialogue( "RDM_AirpG_527A" );
}
// -------------------//
// WW 07-08-08
// set up all the functions for the vision sets
airport_vision_set_init()
{
				// endon
				// single shot function

				// objects to define for the function
				trig_vision_air_1 = getent( "vision_airport_01", "targetname" );
				trig_vision_air_2 = getent( "vision_airport_02", "targetname" );
				trig_vision_air_3 = getentarray( "vision_airport_03", "targetname" );
				trig_vision_air_4 = getentarray( "vision_airport_04", "targetname" );
				trig_vision_air_5 = getent( "vision_airport_05", "targetname" );

				// run a function for one and two
				level thread airport_change_vision_set( trig_vision_air_1, "airport_01", "objective_2" );
				level thread airport_change_vision_set( trig_vision_air_2, "airport_02", "objective_2" );

				// for loop for the two triggers of 3
				for( i=0; i<trig_vision_air_3.size; i++ )
				{
								// run vision function on array spot
								level thread airport_change_vision_set( trig_vision_air_3[i], "airport_03", "objective_4" );
								// frame wait
								wait( 0.05 );
				}

				// set up four
				for( i=0; i<trig_vision_air_4.size; i++ )
				{
								// run vision function on array spot
								level thread airport_change_vision_set( trig_vision_air_4[i], "airport_04", "objective_5" );
								// frame wait
								wait( 0.05 );
				}

				// setup five
				// level thread airport_change_vision_set( trig_vision_air_5, "airport_05", "objective_5" );


}
// -------------------//
// WW 07-08-08
// function changes the vision set when the trigger is hit
airport_change_vision_set( eTrig, sVisionSet, sEndFlag )
{
				// double check the defines passed in
				assertex( isdefined( eTrig ), "vision trig not defined" );
				assertex( isdefined( sVisionSet ), "vision set not defined" );
				assertex( isdefined( sEndFlag ), "vision end on flag not defined" );

				// endon
				level.player endon( "death" );

				// while loop, breaks once the player has completed the obj flag sEndFlag
				while( !flag( sEndFlag ) )
				{
								// wait for the trigger to be hit
								eTrig waittill( "trigger" );

								// change the vision set
								Visionsetnaked( sVisionSet, 1 );

								// frame wait
								wait( 1 );
				}

				// wait five seconds
				wait( 5.0 );

				// clean up the trigger
				eTrig delete();

}
// -------------------//

// AE: have the checkpoints in a central location, so it's easier to find
watch_checkpoints()
{
	// checkpoint 1
	// event 1 once the intro finishes
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 1");
	level maps\_autosave::autosave_now("airport");

	// checkpoint 2
	// event 1 going to event 2, once the cutscene of the guard in the hallway finishes (computer hack 1)
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 2");
	level maps\_autosave::autosave_now("airport");

	// checkpoint 3
	// event 2, once the player hacks the next computer, before the server computer (computer hack 2)
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 3");
	level maps\_autosave::autosave_now("airport");

	// checkpoint 4
	// event 2 going to event 3, once the cutscene of the guards flooding the server room finishes (computer hack 3)
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 4");
	level maps\_autosave::autosave_now("airport");

	// checkpoint 5
	// event 3, after the server battle and the player gets to the 2 vans parked
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 5");
	level maps\_autosave::autosave_now("airport");

	// checkpoint 6
	// event 3 going to event 4, after the AI started flooding the luggage area before the hangar area
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 6");
	level maps\_autosave::autosave_now("airport");

	// checkpoint 7
	// event 4, after fighting through most of the AI in the luggage area before the hangar area
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 7");
	level maps\_autosave::autosave_now("airport");

	// checkpoint 8
	// event 5, after you clear out the men in the hangar
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 8");
	level maps\_autosave::autosave_now("airport");

	// checkpoint 9
	// event 5, after you press the button to open the garage doors
	level waittill("checkpoint_reached");
	//iprintlnbold("checkpoint 9");
	level maps\_autosave::autosave_now("airport");
}

// hides bond during the cutscenes so that we don't see his eyebrows as the camera pans out
hideBond( duration )
{
	level.player hideViewModel();
	wait(duration);
	level.player showViewModel();
}

grab_all_current_ai()
{
	// this is used to fill an array of ai to delete at a later time
	level.aiarray = getaiarray("axis");
}
delete_level_aiarray()
{
	// use this after the grab_all_current_ai function
	if(isdefined(level.aiarray))
	{
		for(i = 0; i < level.aiarray.size; i++)
		{
			if(isdefined(level.aiarray[i]))
				level.aiarray[i] delete();
		}
	}
}
clean_up_old_ai()
{
	aiarray = getaiarray("axis");
	if(isdefined(aiarray))
	{
		for(i = 0; i < aiarray.size; i++)
		{
			if(isdefined(aiarray[i]))
				aiarray[i] delete();
		}
	}
}
clean_up_old_ai_except(targetname)
{
	aiarray = getaiarray("axis");
	if(isdefined(aiarray))
	{
		for(i = 0; i < aiarray.size; i++)
		{
			if(isdefined(aiarray[i]))
			{
				if(	isdefined(aiarray[i].targetname) && 
					aiarray[i].targetname != targetname)	
				{
					aiarray[i] delete();
				}
			}
		}
	}
}

make_weapon_wet()
{
//iprintlnbold("make_weapon_wet");
	self endon("no_weapon_wet");
	level endon("sending_suspense_dood"); // this happens after they hack the first comp

	// when bond is standing under sprinklers, they will be in a trigger, while there make the weapon wet
	while(1)
	{
		materialsetwet(0);
		material_is_wet = false;
		
		self waittill("trigger");
		while(level.player IsTouching(self))
		{
			if(!material_is_wet)
			{
				materialsetwet(1);
				material_is_wet = true;
			}
			wait(0.05);
		}	
	}	
}

watch_cull_distance_E4()
{
	// set the cull distance when we get to the final battle area
	trig_setup = getent( "trig_lugg_3_f4", "targetname" );
	trig_setup waittill( "trigger" );
	// set culling so we don't draw everything outside of the luggage area (ps3 only)
	if(level.ps3 || level.bx) //GEBE
	{
		setculldist(2400);
	}
}
watch_cull_distance_E5()
{
	// lengthen the cull distance once we get to this trigger near the gates
	trig = getent( "ent_trig_start_e5", "targetname" );
	trig waittill("trigger");
	// set culling so we draw everything in the hangar area (ps3 only)
	if(level.ps3 || level.bx ) //GEBE
	{
		setculldist(6800);
		//// setexpfog( near_plane, half_plane, fog_red, fog_blue, lerp_time, fog_max );
		//SetExpFog( 460, 3000, 0.5, 0.5, 0.5, 1.0, 1 );
	}
}

////////////////////////////////////////////////////////////////////////////////////
//                  FIX DAD ROCKET JUMP              
////////////////////////////////////////////////////////////////////////////////////
// checking amount, if shot right on you damage is greater than 125, anything less normal damage.
dad_rocket_jump_fix()
{
	level.player endon("death");
	while(true)
	{
		wait(0.05);
		level.player waittill("damage", amount, attacker,direction_vec, point, type);
		if(attacker == level.player && type == "MOD_PROJECTILE_SPLASH" && amount >= 125)
		{
			//iprintlnbold("amount of DAD damage", amount);
			level.player dodamage( level.player.health *2, level.player.origin);
		}           
	}           
}           

// stolen from Mark Maestas/MontenegroTrain_util
//
//	Button Prompt Check
//		Pass in a button string.  If the player hits it within the time limit, return success.
//		If the player presses a button other than the one specified, it will return failure.
//		A button of "random" will randomize the type of button to be pressed.
//
/*button_pressed( button, time )
{
if ( button == "random" )
{
choice = RandomInt(4);
switch( choice )
{
case 0:
button = "BUTTON_A";
break;
case 1:
button = "BUTTON_B";
break;
case 2:
button = "BUTTON_X";
break;
case 3:
button = "BUTTON_Y";
break;
}
}

// Display button to press
iPrintLnBold( " " );
iPrintLnBold( button );
iPrintLnBold( " " );

while ( time > 0 )
{
// Fail if the wrong button is pressed
if ( button != "BUTTON_A" && level.player buttonPressed( "BUTTON_A" ) )
{
return false;
}
if ( button != "BUTTON_B" && level.player buttonPressed( "BUTTON_B" ) )
{
return false;
}
if ( button != "BUTTON_X" && level.player buttonPressed( "BUTTON_X" ) )
{
return false;
}
if ( button != "BUTTON_Y" && level.player buttonPressed( "BUTTON_Y" ) )
{
return false;
}

// Otherwise, succeed if the correct button is pressed
if ( level.player buttonPressed( button ) )
{
return true;
}
//xxx temp PC testing hack
if ( level.player attackbuttonpressed() )
{
return true;
}

time = time - 0.05;
wait(0.05);
}

return false;  // button not pressed
}*/
// -------------------//
/*quick_populate( str_targetname, bool_trig, str_aigroup )
{

// define containers
temp_guy_container = undefined;
temp_vec_storage = ( 0, 0, 0 );
temp_tether_dist = undefined;
temp_amount = undefined;


// endon
//temp_guy_container endon( "damage" );
// not sure if that would work

// check to see if the spawner has script_parameters on it
if( !isdefined( self.script_parameters ) )
{
iprintlnbold( self.targetname + "has_no_script_parameters!" );
return;
}

if( !isdefined( self.script_int ) )
{
temp_tether_dist = 128;
}
else if( isdefined( self.script_int ) )
{
temp_tether_dist = self.script_int;
}

if( !isdefined( bool_trig ) )
{

bool_trig = false;
}

// grab the nodes that have the targetname of the script_parameters
pop_nodes = getnodearray( self.script_parameters, "targetname" );
wait( 0.1 );




if( bool_trig == false )
{
self.count = pop_nodes.size;
temp_amount = self.count;
}
//else if( bool_trig == true && !isdefined( str_aigroup) )
//{
//	iprintlnbold( "aigroup_not_defined_returning" );
//	return;
//}
else if( bool_trig == true && isdefined( str_aigroup ) )
{
temp_amount = maps\_utility::get_ai_group_sentient_count( str_aigroup );
temp_amount = pop_nodes.size - temp_amount;
}

// makes sure spwn has enough count
//self.count = pop_nodes.size;

// now spawn the guys and send them to the nodes
for( i=0; i<temp_amount; i++ )
{


//spawn the guy
dood = self spwn_guy_set_attributes( str_targetname );

// check to see if goal is occupied
if( isnodeoccupied( pop_nodes[i] ) )
{
dood.goalradius = 36;
//if( 
dood setgoalpos( pop_nodes[i].origin + ( 0, 12, 0 ) );
}
else if( !isnodeoccupied( pop_nodes[i] ) )
{
// send him to a node
dood setgoalnode( pop_nodes[i] );
}

//temp_guy_container thread send_off();

}
}*/
// -------------------//
/*spwn_guy_set_attributes( str_targetname )
{
// stuff
temp_guy_container = undefined;

//spawn the guy
temp_guy_container = self stalingradspawn( str_targetname );
if( !maps\_utility::spawn_failed( temp_guy_container ) )
{
// place proper settings on the guy
temp_guy_container LockAlertState( "alert_red" );
temp_guy_container SetScriptSpeed( "Run" );
//temp_guy_container SetPerfectSense( true );
wait( 0.2 );
temp_guy_container SetTetherRadius( 256 );
//temp_guy_container setEngagementMaxDist( 600, 900 );
//temp_guy_container setEngagementMinDist( 300, 100 );
}
//else if( maps\_utility::spawn_failed( temp_guy_container ) )
//{ 
//	iprintlnbold( "guy_failed_spawn"  );
//	return;
//}

// send out the guy
return temp_guy_container;

}*/
// -------------------//
// red lights scripts from kworrel - thanks!
/*redlights()
{
light = getentarray( "redlight","targetname" );

maps\_utility::array_thread( light, ::redlights_think );
}
// -------------------//
// the think thread
redlights_think()
{
// endon
level endon( "event_one_done" );

time = 5000;

while( level.effects )
{
self rotatevelocity( ( 0,360,0 ), time );    

// sound effect of the emergency click of the emergency lights
self playsound( "AIR_emergency_click" );

wait time;
}
}*/
/*hack_awareness( str_endon )
{
// endon
//level endon( str_endon );

// play the effect on the computer
aware_fx_1 = playloopedfx( level._effect[ "hack_comp_three" ], 0.5, self.origin + ( 0, 0, 15 ) );
//wait( 1.5 );
//aware_fx_2 = playfx( level._effect[ "hack_comp_two" ], self.origin );
//wait( 1.5 );
//aware_fx_3 = playfx( level._effect[ "hack_comp_three" ], self.origin );
//wait( 1.5 );
//aware_fx_4 = playfx( level._effect[ "hack_comp_four" ], self.origin );
//wait( 1.5 );

level maps\_utility::flag_wait( str_endon );

aware_fx_1 delete();



}*/
// -------------------//
// wwilliams made for concourse
// the ambient move function
// used to make a sbrush follow a targeted path of script origins
/*func_move_amb()
{
// end on
// this will be needed

// this self needs to be the first origin in the link chain
targets = self target_array();

// this actually moves self along the target array made
self path_script_org( targets );

}*/
// -------------------//
// wwilliams made for concourse
// runs on self, shouldn't be used with live ents
// grabs a line of targets made by script origins
/*target_array()
{

// make an array of the targets
targets = [];
// make another container for the self
old_target = getent( self.targetname, "targetname" );;
// adds one to the node array
targets[targets.size] = old_target;
// new target declare
new_target = old_target;

// get those targets
while(1)
{
// if it comes across a ent without a target it stops running the loop
if( !isdefined( old_target.target ) )
{
// leave the loop if there are no more targets
break;
}
// if there is a target place it into the array
else if( isdefined( old_target.target ) )
{
// assign the next into the array
new_target = getent( old_target.target, "targetname" );		
}
// adds the newly assigned target into the array
targets[targets.size] = new_target;
// reassign old_target so the loop checks the next script_origin
old_target = new_target;
}

// give me this array
return targets;
}*/
// -------------------//
// wwilliams made for concourse
// runs on self
// made for moving script ents without life
/*path_script_org( ent_array )
{
// check the array given has angles
for( i=0; i<ent_array.size; i++ )
{
if( !isdefined( ent_array[i].angles ) )
{
println( "" + ent_array[i] + "has no angles" );
// report fully
iprintlnbold( "" + self.targetname + "has no angles set for the pathing!" );
iprintlnbold( "stopping function" );
return;
}
}


// temp float container
temp_float_container = 0;

// once all the targets have been found start the action
for( i=0; i<ent_array.size; i++ )
{
// rotate the brush to the right angle
self rotateto( ent_array[i].angles, 0.5 );
self waittill( "rotatedone" );
// verify that there is a parameter field on the script origin
if( isdefined(ent_array[i].script_float) )
{
// make sure the script_parameter is coverted into a int
temp_float_container = ent_array[i].script_float;
}
// if not, set one and tell me which one doesn't have one
else if( !isdefined( ent_array[i].script_float ) )
{
ent_array[i].script_float = 1.0;
println( ent_array[i].targetname + "has no parameters!" );
temp_float_container = ent_array[i].script_float;
}

// move them
self moveto( ent_array[i].origin + (0,0,-7), temp_float_container );
self waittill( "movedone" );
wait( 0.1 );
}

}*/
// -------------------//
// wwilliams 11-01-07
// function grabs all teh table flip triggers and assigns them each their own function for flipping
// 04-09-08
// commenting this out to lower the string usage of the script
/*setup_flip_table()
{
// endon

// grab all the triggers
enta_trig_table_flip = getentarray( "trig_flip_table", "targetname" );

// quick wait
wait( 0.1 );

// now run the function of all the trigs
for( i=0; i<enta_trig_table_flip.size; i++ )
{
// dynamic table function
enta_trig_table_flip[i] thread airport_dynamic_table();

}

// debug text test
iprintlnbold( "setup_flip_table_done" );

}*/
// -------------------//
// wiilliams 11-01-07
// function flips the table
/*airport_dynamic_table()
{
// endon

// stuff
sbrush_collision = getent( self.target, "targetname" );
table_model = getent( sbrush_collision.target, "targetname" );

// link the sbrush and the table model
sbrush_collision linkto( table_model );

// wait for the trigger to get hit
self waittill( "trigger" );

table_model notsolid();

table_model moveto( table_model.origin + ( 0, 0, 20 ), 0.2 );
table_model rotateroll( -90, 1.0 );

table_model waittill( "rotatedone" );

self maps\_utility::trigger_off();

}*/
// -------------------//
// wwilliams 11-5-07
// can not use teleport in release, making a function to move guys
// runs on guy, sends to the origin of something
/*airport_moveto( node, fl_time )
{
// overload check
if( !isdefined( fl_time ) )
{
fl_time = 0.2;
}

// endon


// stuff
end_point = node.origin;
end_angles = undefined;

// check if the angle should be taken into account
if( isdefined( node.angles ) )
{
end_angles = node.angles;
}
else if( !isdefined( node.angles ) )
{
end_angles = undefined;
}

mover = spawn( "script_origin", self.origin );
wait( 0.2 );
mover rotateto( self.angles + ( 0, 0, 5 ), 0.1 );
mover waittill( "rotatedone" );

// link the things
self linkto( mover );

// move self with mover
mover moveto( node.origin, fl_time );

// wait for the move to end
mover waittill( "movedone" );

// rotate if specified
if( isdefined( end_angles ) )
{
mover rotateto( end_angles, 0.2 );
mover waittill( "rotatedone" );
}

// unlink self
self unlink();

// wait
wait( 0.2 );

// delete mover
mover delete();

}*/
// -------------------//
// wwilliams 11-9-07
// grabbed from miamiconcourse_util, used to move the luggage around
// give the function the beginning of the script_origin/node chain
// as well as the item moving down the chain
// guting this for parts
/*fake_patrol( dood, node, int_backtrack, st_endon, int_entnode )
{

if( !isdefined(int_entnode) )
{
int_entnode = 0;	
}

//endon
self endon( st_endon );
// makes the node array
nodes = [];
// adds one to the node array
nodes[nodes.size] = node;

//check to see if the guy is alive
//assert( isalive( dood ) );

// should loop until a node target is not defined
while( 1 )
{
// if it comes across a node without a target it stops running the loop
if( !isdefined( node.target ) )
{
break;
}
if( int_entnode == 0 )
{
// assign the next node the node identifier
node = getnode( node.target, "targetname" );		
}
else if( int_entnode == 1 )
{
// assign the next node the node identifier
node = getent( node.target, "targetname" );

}

// adds the newly assigned node into the node array
nodes[nodes.size] = node;

}
// constant loop of the guy
// guy will stop once carlos reaches the security room exit door
// another thread will kill all the guys
// if st_backtrack is set to zero then the item will go to the end of the path and then 
// it will hide, move back to the beginning and unhide, starting over again
if( int_backtrack == 0 )
{
while(1)
{
// makes him go up the array
for( i=0; i<nodes.size; i++ )
{
dood moveto( nodes[i].origin, 3.0 );
dood waittill( "movedone" );
}
//reset i
i=0;
so_mover = spawn( "script_origin", dood.origin );
dood hide();
dood linkto( so_mover );
so_mover moveto( nodes[0].origin, 0.7 );
so_mover waittill( "movedone" );
wait(0.1);
dood unlink();
wait(0.1);
dood show();
wait(0.1);
}
}
else if( int_backtrack == 1 )
{
while( 1 )
{
// makes him go up the array
for( i=0; i<nodes.size; i++ )
{
dood setgoalpos( nodes[i].origin );
dood waittill( "goal" );
}
//reset i
i=0;
// makes him go down the array
for( i=nodes.size - 1; i>0; i-- )
{
dood setgoalpos( nodes[i].origin );
dood waittill( "goal" );
}
}
}
}*/
// -------------------//
// wwilliams 11-9-07
// used to set up the pieces for movement, from miamiconcourse_six
/*move_luggage( start_point, entarray, st_endon )
{

// this is the func
for( i=0; i<entarray.size; i++ )
{
entarray[i] hide();
entarray[i] moveto( start_point.origin, 1.0 );
entarray[i] waittill( "movedone" );
entarray[i] show();
wait(0.5);
level thread maps\airport_util::fake_patrol( entarray[i], start_point, 0, "end_evt6", 0 );
wait( 3.0 );
}

}*/
// -------------------//
// wwilliams 11-26-07
// luggage damage, runs on the piece of luggage
/*luggage_drop_dmg()
{
// wait for the luggage to take dmg
self waittill( "damage" );

// cause dmg around luggage
self thread maps\_utility::Radiusdamage_overtime( undefined, 50, 60, 45, 1.0 );

// gets rid of the luggage after awhile
self thread maps\_utility::delete_over_time( 3.0 );

}*/
// -------------------//
// wwilliams 01-09-08
// spawn plane, fly it over the interior
/*plane_pass()
{
// endon

// stuff
start_point = getent( "so_overhead_airplane_start", "targetname" );
end_point = getent( start_point.target, "targetname" );
airplane = undefined;

// spawn the plane
airplane = spawn( "script_model", start_point.origin );

// change the model
airplane setmodel( "v_jet_jumbo" );

// set angles
airplane.angles = start_point.angles;

while( maps\_utility::flag( "airplane_fly_over" ) )
{

// move the airplane down to the end
airplane moveto( end_point.origin, 5 );

// debug
iprintlnbold( "airplane moving" );

// wait for it to finish
airplane waittill( "movedone" );

// hide the airplane
airplane hide();

// move it back to the start
airplane moveto( start_point.origin, 0.2 );

// unhide
airplane show();

}

// delete airplane
airplane delete();

}*/
// -------------------//
// 02-12-08
// wwilliams
// camera functions
// ---------------------//
// 02-10-08
// wwilliams
// proof of concept for hacking the security cams in event one
// is just a temp, will be changed out for willie's _securitycamera
// run it on the camera
/*player_camera_disable( trig )
{
// double check the asserts
assertex( isdefined( trig ), "Disable trig is not defined, function will fail!" );
assertex( isdefined( trig.target ), "No target on the trigger, can not hide script model!" );

// endon
self endon( "damage" );

// define the object needed for the function
// the script model to hide
mdl_hack_box_door = getent( trig.target, "targetname" );

// wait for the player to hit the trig
trig waittill( "trigger" );

// get the script model door targetted by the trigger
if( isdefined( trig.target ) )
{

// hide the script model targeted by the trigger
mdl_hack_box_door hide();

}

// notify self that the cam is disabled
self notify( "disable" );

// turn off the trigger
trig maps\_utility::trigger_off();

}*/
// ---------------------//
// 03-19-08
// wwilliams
// function makes self(fan)'s target rotate the roll
// runs on ent
/* airport_fan_rotate()
{
// endon

// grab the target
fan_blade = getent( self.target, "targetname" );

// link the blade to the fan
// fan_blade linkto( self );
// if i link the blade to the fan then i can't rotate it

// while loop makes it continue to rotate
while( 1 )
{
// rotate the fan blade
fan_blade rotatepitch( 360, 0.1, 0.0, 0.0 );

// wait for the roll to finish
fan_blade waittill( "rotatedone" );

// wait for 0.1 instead, trying to get rid of the hitch i see
//wait( 0.1 );
// didn't work


}

} */
// -------------------//
// 03-24-08
// wwilliams
// inits all the explosive panels in teh last area
// threads them off on their own individual functions
// runs on level
// 04-10-08
// this is all doen through the destructive system now
/*air_explo_panel_init()
{
// endon
// not needed single shot function

// defined the objects needed for this function
// ent_array
enta_explosive_panels = getentarray( "ent_explosive_panel", "targetname"  );

// thread off the explosive function on each array spot
for( i=0; i<enta_explosive_panels.size; i++ )
{
// run function that controls the explosion
enta_explosive_panels[i] thread air_explo_panel();

// wait a frame
wait( 0.5 );
}

}*/
// -------------------//
// 03-24-08
// wwilliams
// waits for damage then causes explosion, then swaps models
// runs on self
/*air_explo_panel()
{
// endon
// no endon needed

// objects to be defined for this function
// the panel, a script model, is self
// trig
dmg_trig = getent( self.target, "targetname" );
// script_model
// 03-24-08
// removing red tank from the situation
// red_tank = getent( dmg_trig.target, "targetname" );

// double check the defined objects
assertex( isdefined( dmg_trig ), "dmg_trig is not defined, check prefab!" );
// 03-24-08
// removing red tank from the situation
// assertex( isdefined( red_tank ), "red_tank is not defined, check prefab!" );

// wait for damage
dmg_trig waittill( "trigger" );

// play explosion
// explosion FX
// panel_explo = playfx( level._effect[ "f_explosion" ], red_tank.origin );

// change health of destructible to 0
self.health = 0;

// do damage
radiusdamage( self.origin, 25, 1500, 750 );

// 03-27-08
// wwilliams
// play sound off of the console
self playsound( "Airport_Console_Explosion" );

// send out a physics push
// 03-24-08
// no longer a fireball explosion
// physicsexplosionsphere( red_tank.origin + ( 0, 0, 50 ), 150, 65, 1.0 );

// camera shake
// 03-24-08
// no longer a fireball explosion
// earthquake( 0.5, 1.0, red_tank.origin, 768 );

// wait two frames
wait( 0.10 );

// 03-24-08
// play spark effect
panel_spark = playfx( level._effect[ "electric_spark" ], self.origin + ( 0, 0, 45 ) );

// 03-24-08
// play smoke effect
panel_smoke = playfx( level._effect[ "dmg_smoke" ], self.origin + ( 0, 0, 40 ) );

// play spark effect
panel_spark = playfx( level._effect[ "electric_spark" ], self.origin + ( 0, 0, 45 ) );

// model swap
// for the panel/swap

// for the red tank

// wait for five seconds
wait( 5.0 );

// turn off the smoke
panel_smoke delete();


}*/
// ---------------------//
// 02-20-08
// wwilliams
// function waits for the notify that stealth is broken
// then sets the guys on patrol to alert red
// moved this to the airport_util
// runs on self
/*event_patrol_alert()
{
// endon
self endon( "death" );

// wait for the notify that stealth is broken
level waittill( "e1_stealth_broken" );

// change the alert state to red
self lockalertstate( "alert_red" );

// change the script speed to run
self setscriptspeed( "run" );

}*/
// -------------------//
// wwiilliams 12-05-07
// 
// -------------------//
//setupEntSingleUseOnly(	awareness_entity, 
//						use_event_to_call, 
//						hint_string, 
//						use_time, 
//						use_text, 
//						single_use, 
//						require_lookat, 
//						filter_to_call, 
//						awareness_material, 
//						awareness_glow, 
//						awareness_shine, 
//						wait_until_finished )
// -------------------//
// wwilliams 12-10-07
// function grabs all the laptops and feeds them into the config 
/*)
{
// stuff
laptop_array = getentarray( "ent_hidden_laptop", "targetname" );
//laptop_1 = getent( "ent_hidden_laptop_1", "targetname" );
//laptop_2 = getent( "ent_hidden_laptop_2", "targetname" );
//laptop_3 = getent( "ent_hidden_laptop_3", "targetname" );

// got them now set them up
//laptop_1 thread config_playerawareness_objects();
//laptop_2 thread config_playerawareness_objects();
//laptop_3 thread config_playerawareness_objects();

}*/
// -------------------//
// wwilliams 12-10-07
// function setups the hidden laptop/dossiers and such
/*config_playerawareness_objects()
{

//	setupArrayUseOnly( awareness_entity_name,use_event_to_call,hint_string,use_time,use_text,single_use,require_lookat,filter_to_call,awareness_material,awareness_glow,awareness_shine )

// stuff, should all come off of self which is the script model of the monitors
laptop_array = getentarray( "ent_hidden_laptop", "targetname" );

awareness_entity_name = self.targetname;
hint_string = &"HINT_HACK_LAPTOP";
// hint_string = "Hold &&1 to hack laptop.";
use_time = 5;
use_text = "Acquire Phone";
single_use = true;
require_lookat = true;
filter_to_call = undefined;
awareness_material = undefined;
awareness_glow = true;
awareness_shine = true;
wait_until_finished = true;

//str_flag = undefined;
//int_which_message = undefined;

// now call the self
// self thread maps\_playerawareness::setupSingleUseOnly( awareness_entity_name, ::airport_laptop_count, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine, wait_until_finished );
level thread maps\_playerawareness::setupArrayUseOnly( "ent_hidden_laptop", ::airport_laptop_count, hint_string, use_time, use_text, single_use, require_lookat, filter_to_call, awareness_material, awareness_glow, awareness_shine );

}*/