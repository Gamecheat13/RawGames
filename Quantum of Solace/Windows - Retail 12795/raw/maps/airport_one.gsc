// Airport event one file
// Builder: Brian Glines
// Scritper: Walter Williams
// Created: 10-08-2007

main()
{
	precachemodel("p_msc_soda_machine_airport");

	// 06-10-08
	// wwilliams
	// need a couple of level vars for this area
	level.r_pos_1 = false;
	level.r_pos_2 = false;
	level.l_pos_1 = false;
	level.bond_ready = false;

	// 02-27-08
	// wwilliams
	// setting up the functions for begin and end on the first hack useable object
	level thread e1_comp_settings();

	// thread changes the montior model and opens door
	level thread e1_change_monitor_model();


	// DCS: no intro for Demo.
	if( Getdvar( "demo" ) != "1" )
	{
		// 02-19-08
		// wwilliams
		// new camera intro to the area, by AdamG's request
		level thread e1_camera_intro();
	}
	else
	{
		level.player setplayerangles((4.79, 148.23, 0) );

		level.introblack fadeOverTime( 1.3 );
		level.introblack.alpha = 0;
	}	

	// 08-02-08 WWilliams
	// change the model of the intro laptop out, hoepfully fixes the broadcast issue
	level thread e1_change_intro_laptop();

	// sets up the enemies in event 1
	level thread e1_patrol_setup();

	// dialogue from villiers
	level thread e1_villiers_dialogue();

	// hold the player until everything is set up
	level thread e1_player_hold();

	// checks for if stealth has been broken in the area
	level thread e1_stealth_flag_set();

	level.effects = true;

	// turn on the cameras
	// camera in the area
	level thread e1_cameras_init();

	// 03-05-08
	// wwilliams
	// locks the door that accesses the first virus hack when the player finishs the hack
	level thread e1_lock_player_in_vr();

	// function spawns the guy that walks past the window near the computer
	level thread e1_hack_suspense();

	// turns off the light in the hack room
	level thread e1_virus_rm_lights();

	// light near the second hack box, make this flicker
	level thread e1_light_blinking();

	// play stealth music - added by chuck russom
	level notify("playmusicpackage_stealth");

	// the cleanup for event one
	level thread event_one_clean_up();

	level thread end_event_one();

	// get the weapon wetting triggers
	trigarray = getentarray("wet_weapon_trig", "targetname");
	for(i = 0; i < trigarray.size; i++)
	{
		trigarray[i] thread maps\airport_util::make_weapon_wet();
	}

	level waittill( "event_one_done" );
}
// ---------------------//

// ---------------------//
// 02-27-08
// wwilliams
// function sets up the on_begin_use and on_end_use properties for the first computer
// hack, this can also be expanded to change more settings about the object
e1_comp_settings()
{
				// the first computer is placed into a array accessible by the entire level
				// this will set the function to run when the player starts the virus download
				level.computer_array[0] maps\_useableobjects::set_on_begin_use_function( ::e1_started_v_dl );

				// this will set which function runs once the player has finished the virus download
				// level.computer_array[0] maps\_useableobjects::set_on_end_use_function( ::e1_change_monitor_model );
}
// ---------------------//
// 02-27-08
// wwilliams
// changes the flag that informs the level that the player
e1_started_v_dl( player )
{
				// change e1_virus_started flag to set
				level maps\_utility::flag_set( "e1_virus_started" );

}
// ---------------------//
// 03-28-08
// wwilliams
// changes teh model of the monitor to show that the machine has shut down after the virus is
// runs on the player
e1_change_monitor_model()
{
				// endon
				// single shot function

				// debug text
				// iprintlnbold( "inside e1_change_monitor_model!" );

				//// check to see if the player finished
				//if( bool_result == false )
				//{
				//				// debug text
				//				// iprintlnbold( "leaving the func, bool_result was false!" );

				//				wait( 1.0 );

				//				// end the function
				//				return;
				//}

				// wait for the objective to be complete
				level maps\_utility::flag_wait( "objective_1" );

				// ent
				computer = getent( "ent_air_comp_1", "targetname" );

				// set model on the first monitor
				computer setmodel( "p_dec_monitor_modern" );

				// 08-02-08 WWilliams
				// open the door that leaves this area
				level thread e1_exit_door_control();

}
// ---------------------//
// 03-17-08
// wwilliams
// this will control the flicker of a light in event onw
e1_light_blinking()
{
				// endon
				// won't need this because the while loop will check against something

				// define the objects needed in this function
				light_blinker = getent( "light_e1_blink", "targetname" );

				// while loop checks to see if the player has finished the hack
				while( !maps\_utility::flag( "objective_1" ) )
				{
								// drop the light's intensity
								light_blinker setlightintensity( 0.0 );

								// wait a random float
								wait( randomfloatrange( 0.3, 0.7 ) );

								// raise the light back to normal
								light_blinker setlightintensity( 1.0 );

								// wait a random float
								wait( randomfloatrange( 0.1, 1.5 ) );
				}

				// set the light to off
				light_blinker setlightintensity( 0.0 );

				// flicker it back up to full over a second
				wait( randomfloatrange( 0.2, 0.5 ) );

				// intensity slightly on quickly
				light_blinker setlightintensity( 0.5 );

				// quick wait
				wait( 0.2 );

				// turn it off again
				light_blinker setlightintensity( 0.0 );

				// another random wait
				wait( randomfloatrange( 0.2, 0.5 ) );

				// turn the light on and leave it alone
				light_blinker setlightintensity( 1.0 );
}
// ---------------------//

// ---------------------//

// ---------------------//

// ---------------------//
// 03-05-08
// wwilliams
// locking the virus hack door behind the player
// this runs on level
e1_lock_player_in_vr()
{
				// endon
				// not needed this is a straight shot function

				// objects to be defined for this function
				// the door to lock
				e1_vr_enter_door = getent( "ent_e1_virus_enter", "targetname" );

				// wait for the objective to be set after the player gets the virus
				level maps\_utility::flag_wait( "objective_1" );

				// lock the door
				e1_vr_enter_door maps\_doors::barred_door();

}
// ---------------------//
// wwilliams
e1_exit_door_control()
{
	e1_exit_door = getent( "ent_door_e1_exit", "targetname" );
	//trig = getent( "ent_close_e1_exit", "targetname" );

	e1_exit_door rotateYaw(100, 1.0);
	e1_exit_door ConnectPaths();
	e1_exit_door playsound("Door_Rotating_Open");
}
// ---------------------//
e1_hack_suspense()
{
	// endon

	// stuff
	spawner = getent( "ent_hack_enemy", "targetname" );
	// 02-13-08
	// wwilliams
	// adding the spawner for event 2 patrollers
	// so dood_2 will actually be part of event two's patrols
	spawner_2 = getent( "nod_e2_bottom_patrol", "targetname" );
	check_node = getnode( "nod_check_pause", "targetname" );
	end_node = getnode( "node_suspense_spot", "targetname" );

	// make sure the count on the spawners are high enough
	spawner.count = 5;
	spawner_2.count = 5;

	// 02-25-08
	// need to change this to watch for the player to start the hack

	// wait for the player to finish the hack
	level maps\_utility::flag_wait( "objective_1" );

	//// need to turn the player towards the computer
	//level.player maps\_utility::holster_weapons();
	//ent = getent("ent_obj_1", "targetname");
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

	//split screen
	level thread server1_pip_camera();

	// wait

	// 08/12/08 jeremyl commented out wait to get guys on screen faster
	//wait( 1.5 );

	// spawn the guy
	dood_1 = spawner stalingradspawn( "ent_e1_suspense" );
	if( !maps\_utility::spawn_failed( dood_1 ) )
	{		
		// 02-13-08
		// wwilliams
		// turn off the sense for this guy, trying to fix the pathing issue i'm having with them
		// dood_1 setenablesense( false );

		// set the correct state 
		dood_1 setalertstatemin( "alert_yellow"  );

		// 02-19-08
		// wwilliams
		// set the speed to walking even though the guy is in alert_yellow
		dood_1 setscriptspeed( "walk" );

		// set propagation delay
		dood_1 setpropagationdelay( 1.0 );

		// give him most of the rules
		dood_1 setengagerule( "tgtSight" );
		dood_1 addengagerule( "tgtPerceive" );
		dood_1 addengagerule( "Damaged" );
		dood_1 addengagerule( "Attacked" );



		// thread func to change this guy to a rusher
		dood_1 thread e1_change_role();

		// runs function on guy
		dood_1 thread e1_server_check_guy();
	}
	else
	{
		//iprintlnbold( "coversation_dood_one_fail" );
		return;
	}

	// quick wait
	// 02-13-08
	// two spawners used, no wait needed
	// wait( 1.0 );

	dood_2 = spawner_2 stalingradspawn( "ent_e1_suspense" );
	if( !maps\_utility::spawn_failed( dood_2 ) )
	{	
		// 02-13-08
		// wwilliams
		// give this guy a few frames before starting everything
		wait( 0.1 );

		// 02-13-08
		// wwilliams
		// turn off the sense for this guy, trying to fix the pathing 
		// issue i'm having with them
		// dood_2 setenablesense( false );

		// set the correct state 
		dood_2 setalertstatemin( "alert_yellow"  );

		// 02-20-08
		// wwilliams
		// this guy needs to walk, not run
		dood_2 setscriptspeed( "walk" );

		// set the proper rules on the guy
		dood_2 setengagerule( "tgtSight" );
		dood_2 addengagerule( "tgtPerceive" );
		dood_2 addengagerule( "Damaged" );
		dood_2 addengagerule( "Attacked" );

		// set propagation delay
		dood_2 setpropagationdelay( 3.0 );

		// run the disappear function on guy
		dood_2 thread e1_server_disappear_guy();

	}
	else
	{
		//iprintlnbold( "coversation_dood_two_fail" );
		return;
	}

	// run the conversation function on the doods
	level thread e1_suspense_conversation( dood_1, dood_2 );
}
// ---------------------//
// 02-12-08
// wwilliams
// runs on the guy who enters the event one space
e1_server_check_guy()
{
//iprintlnbold("server guy start");
	// runs on self
	// basic endons
	self endon( "death" );
	self endon( "damage" );
	level endon( "e1_suspense_broken" );

	// defining objects needed for this function
	talk_node = getnode( "nod_enter_e1_start", "targetname" );
	// check_node = getnode( "nod_check_pause", "targetname" );
	end_node = getnode( "node_suspense_spot", "targetname" );
	// 02-27-08
	// needed more nodes to make this function work
	nod_wait_for_virus_dl_finish = getnode( "nod_e1_wait_for_v_dl", "targetname" );
	// nod_e1_unlock_exit_door = getnode( "nod_e1_unlock_exit_door", "targetname" );

	// modify the perception of this ai
	//self setenablesense( false );

	// function waits to see if the player broke suspense
	self thread suspense_broken();
//iprintlnbold("1");

	// head toward first node
	self setgoalnode( talk_node );
//iprintlnbold("2");

	// guy will wait until the conversation between him and another are complete

	//wait(3);
	// wait for goal

	//level notify( "sending_suspense_dood" );
	self waittill( "goal" );
//iprintlnbold("3");
	// wait for conversation to finish
	//level waittill( "e1_sus_convo_3" );
	level notify( "sending_suspense_dood" );

	// now that he is going to check on the dl
	// send him to the node next to the door before unlocking it
	// self setgoalnode( nod_e1_unlock_exit_door );

	// wait for him to get there
	// self waittill( "goal" );

	// now that he is at the door
	// notify other function that guy is heading to the barred door
	// this notify tells the door script to turn off the _doors_barred sub parameter
	//level notify( "sending_suspense_dood" );

	// turn off the broekn suspense thread
	level notify( "e1_suspense_kept" );
//iprintlnbold("4");

	// go to check node
	// self setgoalnode( check_node );

	// wait to arrive at the node
	// self waittill( "goal" );

	// make him call for the guys
	// level maps\airport_util::loop_print3d( self.origin + ( 0, 0, 70 ), "Hey guys? Why did the alarm turn off?", ( 1.0, 0.8, 0.5 ), 2000, "e1_convo_p2", 1, 0.75 );

	// still talking
	// level maps\airport_util::loop_print3d( self.origin + ( 0, 0, 70 ), "Guys? Where are you?", ( 1.0, 0.8, 0.5 ), 2000, "e1_convo_p2", 1, 0.75 );

	// comments before entering the hack room
	// level maps\airport_util::loop_print3d( self.origin + ( 0, 0, 70 ), "I'll check on the virus.", ( 1.0, 0.8, 0.5 ), 2000, "e1_convo_p2", 1, 0.75 );

	// send the guy to the node

	wait(4);

	self setgoalnode( end_node );
//iprintlnbold("5");

	//// 8-17-08
	//// aeady
	//// save the game here because if you start from last checkpoint he wasn't moving
	//// the old save happened right after the pip went away
	//level maps\_autosave::autosave_now( "airport" );

	// wait for the suspense dood to get to his node
	self waittill( "goal" );
//iprintlnbold("6");

	// before he talks we need something to kill the talking if he dies
	//self thread watch_server_guy_death();

	// talking
	// level maps\airport_util::loop_print3d( self.origin + ( 0, 0, 70 ), "Control, computer's on, but no one's here. Over.", ( 1.0, 0.8, 0.5 ), 3000, "e1_convo_p2", 1, 0.75 );
	self maps\_utility::play_dialogue("CCGM_AirpG_009A");

	// loop the guy typing on the keyboard
	while( 1 )
	{
		// play anim
		self cmdplayanim( "thu_laptop_lowersurface" );

		// wait for it to end
		self waittill( "cmd_done" );
	}

	// wait( 3.0 );

	// a little bit more
	// level maps\airport_util::loop_print3d( self.origin + ( 0, 0, 70 ), "The virus isn't even on this machine anymore.", ( 1.0, 0.8, 0.5 ), 3000, "e1_convo_p2", 1, 0.75 );

	// reset the perception of this ai
	// self setenablesense( true );


}
//watch_server_guy_death()
//{
//	self waittill("death");
//
//	// force a null sound to stop the dialogue
//	self maps\_utility::play_dialogue("null_voice");
//}
// ---------------------//
// 06-28-08
// wwilliams
// extra layer in case the player breaks suspense
e1_change_role()
{
				// endon
				self endon( "death" );
				level endon( "e1_suspense_kept" ); 

				// wait for notify
				level waittill( "e1_suspense_broken");

				// give perfect sense
				self SetPerfectSense( true );

				// change combat role to rusher
				self setcombatrole( "rusher" );

}
// ---------------------//
// 02-29-08
// wwilliams
// in case the guys who do the suspense are shot at
// runs on self
suspense_broken()
{
				// endon
				self endon( "death" );
				self endon( "damage" );
				level endon( "e1_suspense_kept" );

				// wait for the guy to go to alert_red
				if( self getalertstate() != "alert_red" )
				{
								self waittill( "alert_red" );
				}

				// notify the door to open
				level notify( "sending_suspense_dood" );
				level maps\_utility::flag_set( "e1_suspense_broken" );

				// end the other function
				level notify( "e1_suspense_broken" );

}
// ---------------------//
// 02-12-08
// wwilliams
// runs on the guy who will "disappear"
// 02-13/08
// wwilliams
// guy will no longer disappear
// now the guy is passed into the guys in event 2
e1_server_disappear_guy()
{
	// runs on self
	// basic endons
	self endon( "death" );

	thread watch_server_disappear_guy_death(self);

	// define objects needed for this function
	talk_node = getnode( "nod_disappear_start", "targetname" );
	nod_wait_for_disappear = getnode( "nod_wait_to_disappear", "targetname" );
	nod_disappear = getnode( "nod_disappear", "targetname" );
	trig_go_disappear = getent( "trig_disappear", "targetname" );

	// modify the ai to not pay attention
	//self setenablesense( false );

	// function to change script speed to normal
	if(isdefined(self))
	{
		self thread maps\airport_util::reset_script_speed();
	}

	// send him to the first node
	if(isdefined(self))
	{
		self setgoalnode( nod_wait_for_disappear );
	}

	// wait for goal
	if(isdefined(self))
	{
		self waittill( "goal" );
		self cmdaction ( "CheckEarpiece" );
	}
	//Scan 		
	// nod_e1_wait_for_v_dl	node I can make a guy wait at

	wait (6.3);
	// start conversation
	level notify( "start_sus_convo" );


	// wait for conversation to end
	level waittill( "e1_sus_convo_3" );

	// run to disappear node
	if(isdefined(self))
		self setgoalnode( nod_wait_for_disappear );

	// wait for the player to hit the trigger
	trig_go_disappear waittill( "trigger" );

	// thread off teh tanner convo
	level thread airport_post_obj1_tanner_update();

	// 02-13-08
	// wwilliams
	// this guy will not disappear anymore,
	// will wait for the player to hit the trigger
	// then will run the e2_bottom_hallway_patrol function on him
	// start him on the patrol function in event 2

	// start others on patrol.
	if(isdefined(self))
		self thread maps\airport_two::e2_bottom_hallway_patrol();
}
watch_server_disappear_guy_death(ent)
{
	// we need to know if he's killed so we can alert the other patrollers
	//	this is important because he talks to them and they rely on him to live so they can start patrol
	//ent endon("goal");
	ent waittill("death");

	if(level.flag["event_two_start"])
		return;

	// alert
	guardarray = getaiarray("axis");
	if(isdefined(guardarray))
	{
		for(i = 0; i < guardarray.size; i++)
		{
			guardarray[i] setalertstatemin("alert_red");
			guardarray[i] setperfectsense(true);
			guardarray[i] maps\_utility::play_dialogue_nowait("null_voice");
		}
	}
	//guard1 = getent("e2_right_patrol", "script_noteworthy");
	//if(isdefined(guard1))
	//{
	//	guard1 setalertstatemin("alert_red");
	//}
	//guard2 = getent("e2_bottom_patrol", "script_noteworthy");
	//if(isdefined(guard2))
	//{
	//	guard2 setalertstatemin("alert_red");
	//}
}
// ---------------------//
// 02-12-08
// wwilliams
// outside server room discussion between the two guys
// runs on level
// has two entities passed into it
e1_suspense_conversation( dood_1, dood_2 )
{

				// wait for a notify to start the conversation
				level waittill( "start_sus_convo" );

				// check to see if dood_1 and dood_2 are alive
				assertex( isalive( dood_1 ), "Dood_1 is not alive!" );
				assertex( isalive( dood_2 ), "Dood_2 is not alive!" );

				// start conversation
				// talking
				// level maps\airport_util::loop_print3d( dood_1.origin + ( 0, 0, 70 ), "I'll catch up. We've got unauthorized activity on one of the servers.", ( 1.0, 0.8, 0.5 ), 3000, "e1_sus_convo_3", 1, 0.75 );
				Dood_1 cmdaction( "CheckEarpiece" );
				
				dood_1 maps\_utility::play_dialogue( "CCGM_AirpG_008A" );

				// wait for conversation to end
				level notify( "e1_sus_convo_3" );
//				Dood_1 waittill( "cmd_done" );
				
//				Dood_1 cmdaction( "LookAround", true, 1.3 ); 

				// next line
				// level maps\airport_util::loop_print3d( dood_2.origin + ( 0, 0, 70 ), "I haven't seen anyone yet.", ( 1.0, 0.8, 0.5 ), 3000, "e1_sus_convo_2", 1, 0.75 );

				// last line
				// level maps\airport_util::loop_print3d( dood_1.origin + ( 0, 0, 70 ), "Keep your eyes open, I don't want any surprises.", ( 1.0, 0.8, 0.5 ), 3000, "e1_sus_convo_3", 1, 0.75 );
}
// ---------------------//
// 03-17-08
// wwilliams
// this function waits for the player to finish the hack then turns off teh light in the room
e1_virus_rm_lights()
{
				// endon
				// single shot function, not needed

				// define the objects needed for this function
				// light
				light = getent( "light_e1_hack", "targetname" );
				// sbrush
				sbrush_on = getent( "e1_hack_light_on", "targetname" );
				sbrush_off = getent( "e1_hack_light_off", "targetname" );
				// int
				times = 0;

				// hide the sbrush
				// sbrush_on show();
				sbrush_off hide();

				// set the intensity of the light high at first
				light setlightintensity( 1.5 );

				// wait for the flag to be set
				level maps\_utility::flag_wait( "objective_1" );

				// 06-17-08
				// while loop makes it happen in less lines
				while( times != 6 )
				{

								// this light will flicker before it goes out
								light setlightintensity( randomfloatrange( 0.2, 1.4 ) );

								// wait
								wait( randomfloatrange( 0.2, 0.5 ) );

								// increase the check that the while loop uses
								times++;
				}

				// set the intensity of the light high at first
				light setlightintensity( 0.0 );

				// show the sbrush to help the player understand the light is out
				// sbrush_on hide();
				sbrush_off show();

				// 03-26-08
				// wwilliams
				// this light will flicker before it goes out
				/* light setlightintensity( 0.5 );

				// wait
				wait( 0.2 );

				// raise it
				light setlightintensity( 0.9 );

				// wait
				wait( 0.2 );

				// drop it again
				light setlightintensity( 0.3 );

				// wait
				wait( 0.2 );

				// raise again real quick
				light setlightintensity( 1.0 );

				// wait 
				wait( 0.2 );

				// turn the light off
				light setlightintensity( 0.1 ); */
				

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// WW 07-01-08
// Tanner asks Bond for a sit rep
// runs on level
airport_post_obj1_tanner_update()
{
				// endon
				// single shot function

				// line 1 - tanner
				level.player maps\_utility::play_dialogue( "TANN_AirpG_508A" );

				// line 2 - bond CUT 
				//level.player maps\_utility::play_dialogue( "TANN_AirpG_509A" );

				// line 3 - tanner
				//level.player maps\_utility::play_dialogue( "TANN_AirpG_510A" );

				// line 4 - bond
				level.player maps\_utility::play_dialogue( "TANN_AirpG_511A" );
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// EVENT ONE INTRO START
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ---------------------//
// wiilliams 11-8-07
// function to freeze the player until the notify is sent to let them go
// 02-05-08
// wwilliams
// function sets up the camera push to start the level
// also starts letterbox
e1_player_hold()
{
				// turn on letterbox 
				// 02-19-08
				// wwilliams
				// removing letterbox from the level per JoeC's request
				// maps\_utility::letterbox_on( false, false );

				// raise the LOD distance
				SetDVar( "r_lodBias", -750 );

				// move the player into position
				// level.player setorigin( ( -392, -48, 208 ) );
				// make sure there are angles on the node
				// level.player setplayerangles( ( 0, 180, 0 ) );

				// unfreeze player control real quick
				level.player freezecontrols( false );

				// while loop
				//while( level.r_pos_2 == false )
				//{


				// wait
				//	wait( 0.05 );
				//}

				// lock the player to the wall
				// level.player playerSetForceCover( true );

				// freeze player control real quick
				// level.player freezecontrols( true );

				// change level var
				// level.bond_ready = true;

				// wait for notify to move the player into last position
				// level waittill( "player_at_laptop" );

				// lock the player to the wall
				level.player playerSetForceCover( false );

				// set player origin
				// level.player setorigin( ( -552, -8, 208 ) );
				// set player angles
				// level.player setplayerangles( ( 0, 90, 0 ) );

				// freeze player control real quick
				// level.player freezecontrols( true );


				// DCS: no intro for Demo.
				if( Getdvar( "demo" ) != "1" )
				{
					// wait for the intro to finish
					level waittill( "air_intro_done" );
				}
				
				// turn off letterbox
				maps\_utility::letterbox_off();

				// send out the notify to release the player
				// level waittill( "release_player" );

				// give the player back control
				level.player freezecontrols( false );

				// put the LOD back to normal
				SetDVar( "r_lodBias", 0 );

				// setup the camera
				// 02-19-08
				// wwilliams
				// changes to the camera intro
				//level.CameraID = level.player customcamera_push( "world", ( -155, 0, 280 ), ( 0, 180, 0 ), 0.1 );

				// freeze the player
				// already frozen in airport.gsc
				// level.player freezecontrols( true );

				// wait a second or two
				// wait( 2.0 );

				// wait for the notify that the first set of guys are ready
				// level waittill( "release_player" );

				// 02-15-08
				// wwilliams
				// adding a bit more of a wait to try and fix the error from killing the guys too fast
				// wait( 2.0 );

				// turn off the camera
				// 02-19-08
				// wwilliams
				// changes to the camera intro
				// level.player customcamera_pop( level.CameraID, 1.0 );

				// letterbox off
				// 02-19-08
				// wwilliams
				// removing letterbox from the level per JoeC's request
				// maps\_utility::letterbox_off();

				// allow the player to move
				// level.player freezecontrols( false );

}
// ---------------------//
// 02-19-08
// wwilliams
// new camera intro to the level
// this will start in the hallway looking at the camera
// snake back toward the enterance
// and show Bond enter the area
e1_camera_intro()
{

	// wait a frame cause starting all this in the first frame doesn't work
	wait( 0.05 );

	// disable the back button
	// disable the phone
	setSavedDvar( "cg_disableBackButton", "1" ); // disable

	// turn on letterbox
	maps\_utility::letterbox_on( false, false );

	// hide the soda machines that don't look good for the camera
	soda_machines = getentarray("soda_machines", "targetname");
	cam_soda_machines = [];
	for(i = 0; i < soda_machines.size; i++)
	{
		soda_machines[i] hide();

		// spawn the replacement
		cam_soda_machines[i] = spawn("script_model", soda_machines[i].origin);
		cam_soda_machines[i].angles = soda_machines[i].angles;
		cam_soda_machines[i] setmodel("p_msc_soda_machine_airport");
	}

	// thread off the dialogue functions
	level thread air1_merc1_line1();
	level thread air1_merc2_line1();
	level thread air1_merc1_line2();

	// fade the black out
	// level maps\_utility::fade_out_black( 1.5 );
	// make the hud element on the screen fade away
	level.introblack fadeOverTime( 1.3 );
	// not sure why this is set
	level.introblack.alpha = 0;

	// play the cutscene
	playcutscene( "Airport_Intro", "air_intro_done" );
	level thread display_chyron();

	// wait for the cutscene to end
	level waittill( "air_intro_done" );

	// hide the soda machines that look good for the camera and show the others
	for(i = 0; i < soda_machines.size; i++)
	{
		soda_machines[i] show();

		cam_soda_machines[i] delete();
	}

	maps\_utility::letterbox_off();

	// disable the phone
	setSavedDvar( "cg_disableBackButton", "0" ); // enable

	// 02-25-08
	// wwilliams
	// save the game so the player doesn't have to watch this again
	// savegame( "airport" );
	//level maps\_autosave::autosave_now( "airport" );
	level notify("checkpoint_reached"); // checkpoint 1
	level notify("give_1st_obj");
}

///////////////////////////////////////////////////////////////////////////
// 08-06-08 WWilliams
// function watches for the notetrack for merc one's first line
air1_merc1_line1()
{
            // endon
            // objects to be defined for this function
            // objects to define for the function
            // guy at laptop
            laptop_guy = getent( "Merc1", "targetname" );
            // ent_right = getent( "Merc2", "targetname" );
            // grab the laptop also
            intro_laptop = getent( "intro_laptop", "targetname" );

            // iprintlnbold( "merc1_line1 notetrack" );
          	// wait for the notetrack on the guy

            laptop_guy waittillmatch( "anim_notetrack", "ccm1_airpg_01a" );
                                 
            //iprintlnbold( "merc1_line1 notetrack" );
           // play sound 

           intro_laptop maps\_utility::play_dialogue( "CCM1_AirpG_001A", true ); // terminal's almost clear
}

///////////////////////////////////////////////////////////////////////////
// 08-06-08 WWilliams
// function watches for the notetrack for the merc two's line
air1_merc2_line1()
{
          //endon

          // objects to define for this function

          hallway_guy = getent( "Merc2", "targetname" );

          // grab the laptop also

          intro_laptop = getent( "intro_laptop", "targetname" );

          // iprintlnbold( "merc2 notetrack" );

          // wait for the notetrack on the guy

          hallway_guy waittillmatch( "anim_notetrack", "ccm1_airpg_02a" );

          //iprintlnbold( "merc2 notetrack" );

          // play sound off the laptop

          intro_laptop maps\_utility::play_dialogue( "CCM1_AirpG_002A", true ); // how long until

}

///////////////////////////////////////////////////////////////////////////
// 08-06-08 WWilliams
// function watch for the notetrack for merc1 second line
air1_merc1_line2()
{

         // endon

         // objects to define for this function
         laptop_guy = getent( "Merc1", "targetname" );

         // grab the laptop also
         intro_laptop = getent( "intro_laptop", "targetname" );

 
         // iprintlnbold( "merc1_line2 notetrack" );

         // wait for the notetrack
         laptop_guy waittillmatch( "anim_notetrack", "ccm2_airpg_03a" );

 
         //iprintlnbold( "merc1_line2 notetrack" );
 
         // play sound on the laptop

         intro_laptop maps\_utility::play_dialogue( "CCM2_AirpG_003A", true ); // it's already happening
}


//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// EVENT ONE INTRO END
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 08-02-08 WWilliams
// change the model of the laptop once the intro is complete
e1_change_intro_laptop()
{
				// endon
				// single shot function

				// define the objects needed for the function
				intro_laptop = getent( "intro_laptop", "targetname" );

				// double check objects
				assertex( isdefined( intro_laptop ), "intro_laptop not defined" );

				// DCS: no intro for Demo.
				if( Getdvar( "demo" ) != "1" )
				{
					// wait for the cutscene to end
					level waittill( "air_intro_done" );
				}

				// change the model of teh laptop
				intro_laptop setmodel( "p_dec_laptop_blck" );

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// EVENT ONE ENEMIES START
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// ---------------------//
// revision: 02-07-08
// wwilliams
// setup the enemies in event one
// deals with the discussion between them before the go to their positions
// removed gimme guy situation from event 1
e1_patrol_setup()
{
				// endon, not needed

				// objects to define for the function
				ent_left = getent( "Merc1", "targetname" );
				ent_right = getent( "Merc2", "targetname" );

				// 06-10-08
				// verify the spawners 
				assertex( isdefined( ent_left ), "ent_left not defined" ); 
				assertex( isdefined( ent_right ), "ent_right not defined" ); 

				ent_left setengagerule( "tgtSight" );
				ent_left addengagerule( "tgtPerceive" );
				ent_left addengagerule( "Damaged" );
				ent_left addengagerule( "Attacked" );

				// pass this guy into the function that will take him from here
				ent_left thread hallway_e1_left_patrol( ent_left.script_parameters );

				ent_right setengagerule( "tgtSight" );
				ent_right addengagerule( "tgtPerceive" );
				ent_right addengagerule( "Damaged" );
				ent_right addengagerule( "Attacked" );

				// pass this guy into the function that will take him from here
				ent_right thread hallway_e1_right_patrol( ent_right.script_parameters );

				// pass the guys into the conversation function if they spawned out
				level thread e1_start_conversation( ent_right, ent_left );

}
// ---------------------//
// makes the guy inside the cafeteria walk around
// this guy has to sync up with the guy walking the halls
// 02-25-08
// this guy will no longer go on a patrol, he will stand in the open bullpin near the security room
// the other guy in this area will patrol in a circle that cuts through the cafeteria
hallway_e1_left_patrol( str_patrol_route )
{
				// endon
				self endon( "damage" );
				self endon( "death" );

				// double check that the patrol route is defined
				// assertex( isdefined( str_patrol_route ), "Left side patrol route not defined, function will fail!" );

				// ents to declare for the function
				// trig_start_patrol = getent( "trig_start_e1_patrols", "targetname" );

				// nodes to declare for the function
				left_talk = getnode( "nod_left_walk_convo", "targetname" );
				left_start_patrol_node = getnode( "nod_left_patrol_start", "targetname" );
				nod_left_watcher = getnode( "nod_left_patrol_watch", "targetname" );

				// empty container to define
				str_alert_state = false;

				// function checks for his alert state
				self thread maps\airport_util::event_enemy_watch( "e1_stealth_cancelled", "e1_stealth_broken" );

				// function to change script speed to normal
				self thread maps\airport_util::reset_script_speed();

				// 02-19-08
				// will set the guy into alert red if stealth is broken
				self thread e1_patrol_alert();

				// make this guy walk to the node while the two talk
				// self setgoalnode( left_talk );

				// 02-21-08
				// wwilliams
				// wait for guy to hit goal
				// self waittill( "goal" );

				// change level var for left being in position
				// level.l_pos_1 = true;

				// send the notify to run the comments between the two thugs
				// level waittill( "continue_e1_convo" );

				// play an anim on the guys
				// self cmdplayanim( "Thu_Cas_Hgn_A1" );

				// iprintlnbold( "left play anim" );

				// wait for the conversation to stop
				// level waittill( "e1_convo_p4" );

				// stop the anim
				// self stopallcmds();

				// iprintlnbold( "left stop anim" );


				// DCS: no intro for Demo.
				if( Getdvar( "demo" ) != "1" )
				{
					// wait for the intro to finish
					level waittill( "air_intro_done" );
				}	

				// change his alert state to have the movement speed desired
				//self setalertstatemin( "alert_yellow" ); // commented out because of the idle animations in this situation

				// 02-19-08
				// wwilliams
				// set the speed to walking even though the guy is in alert_yellow
				self setscriptspeed( "sprint" );

				// send him to the start node of his patrol
				self setgoalnode( nod_left_watcher );

				// iprintlnbold( "left to gimme node" );

				// wait for him to get there
				self waittill( "goal" );
				// wait for him to face the direction of the node
				self waittill("facing_node");

				// wait an extra half sec
				wait( 1.5 );
				// 05-20-08
				// wwilliams
				// now make htis guy stop sprinting
				self setscriptspeed( "walk" );

				// loop the cmdaction function on this guy
				self thread e1_cube_action_loop();

}
// ---------------------//
// 03-11-08
// wwilliams
// command action loop on the guy in the cubical
// runs on self
e1_cube_action_loop()
{
				// endon
				self endon( "damage" );
				self endon( "death" );
				level endon( "e1_stealth_broken" );

				// 03-05-08
				// wwilliams
				// loop this guy performing a cmdaction
				while( 1 )
				{
								// make the guy scratch his nose
								self cmdaction( "fidget" );

								self waittill( "cmd_done" );

								// wait until it is done
								//self waittill("Cmd_Done");
								wait( randomfloatrange( 0.8, 2.0 ) );

								// make the guy reload
								self cmdaction( "fidget" );

								self waittill( "cmd_done" );

								// wait until it is done
								//self waittill("Cmd_Done");
								wait( randomfloatrange( 1.0, 2.0 ) );

				}

}
// ---------------------//
// this starts the enemy that walks through the hallways
// outside the middle room, runs on the guy
// this guy will have to get the guys in offices to report in
hallway_e1_right_patrol( str_patrol_route )
{
				// endon
				self endon( "damage" );
				self endon( "death" );

				// double check that the patrol route has been inpit
				assertex( isdefined( str_patrol_route ), "Right patrol route not defined, function will fail!" );

				// function checks for his alert state
				self thread maps\airport_util::event_enemy_watch( "e1_stealth_cancelled", "e1_stealth_broken" );

				// 02-19-08
				// will set the guy into alert red if stealth is broken
				self thread e1_patrol_alert();

				// function to change script speed to normal
				self thread maps\airport_util::reset_script_speed();

				// entities to be declared for the function
				// trig = getent( "trig_start_e1_thug_dialog", "targetname" );

				// nodes to be declared for the function
				nod_first_comment = getnode( "nod_e1_cam_line", "targetname" );
				nod_start_scene = getnode( "e1_right_level_start", "targetname" );
				nod_conversation = getnode( "nod_e1_dood1_convo_start", "targetname" );
				nod_right_talk_and_walk = getnode( "nod_right_walk_convo", "targetname" );
				// right_start_patrol_node = getnode( "nod_right_patrol_start", "targetname" );
				nod_wait_stairs = getnode( "nod_left_patrol_watch", "targetname" );

				// undefined
				ent_temp_scr = undefined;

				// send the guy to his first node at the laptop
				/* self setgoalnode( nod_start_scene );

				// wait for goal
				self waittill( "goal" );

				// set level var for first position
				level.r_pos_1 = true;

				// wait for the notify from the intro function
				level waittill( "leave_security" );

				// send him to the first comment node
				self setgoalnode( nod_first_comment );

				// wait for him to get there
				self waittill( "goal" );

				// spawn out a scr org
				ent_temp_scr = spawn( "script_origin", self.origin );
				// set the right angles
				ent_temp_scr.angles = self.angles;

				// link the guy to the org
				self linkto( ent_temp_scr );

				// hide guy
				self hide();

				// move him fast
				ent_temp_scr moveto( nod_right_talk_and_walk.origin + ( 0, 0, 5 ), 0.05 );

				// wait for the move to finish
				ent_temp_scr waittill( "movedone" );

				// rotate the org to match the node angle
				ent_temp_scr rotateto( nod_right_talk_and_walk.angles, 0.05 );

				// wait for the rotate to finish
				ent_temp_scr waittill( "rotatedone" );

				// unlink guy
				self unlink();

				// make visible
				self show();

				// delete the scr_org
				ent_temp_scr delete();

				// make the guy go to the node
				// self setgoalnode( nod_right_talk_and_walk );

				// wait for goal
				// self waittill( "goal" );

				// set level var for first position
				level.r_pos_1 = false;
				level.r_pos_2 = true;

				// once there send out the notify for the comment to be said by self
				level waittill( "start_e1_conversation" );

				// play an anim on the guys
				self cmdplayanim( "Thu_Cas_Hgn_A2" );

				// send the notify to run the comments between the two thugs
				level notify( "continue_e1_convo" );

				// wait for the conversation to be over then start the patrol
				level waittill( "e1_convo_p4" );

				// stop the anim
				self stopallcmds();

				// change alert state to show a better animation
				// new anim for alert green should be coming in
				// or maybe leave alert state green and just change speed
				self setalertstatemin( "alert_yellow" );

				// 02-19-08
				// wwilliams
				// set the speed to walking even though the guy is in alert_yellow
				self setscriptspeed( "walk" ); */

				// DCS: no intro for Demo.
				if( Getdvar( "demo" ) != "1" )
				{
					// wait for the intro to finish
					level waittill( "air_intro_done" );
				}

				// change his alert state to have the movement speed desired
				self setalertstatemin( "alert_yellow" );

				// set the correct script speed on the guy
				self setscriptspeed( "walk" );

				// notify the left side to start
				level notify( "start_e1_patrols" );

				// don't start the patrol route until we hit a trigger at the bottom of the stairs
				trig = getent("start_patrol_trig", "targetname");
				trig waittill("trigger");

				// start self on the patrol
				self startpatrolroute( str_patrol_route );
				// send him to the node to wait

}
// ---------------------//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// EVENT ONE ENEMIES END
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

// ---------------------//
// wwilliams 12-03-07
// villers all in your ear, giving those orders
e1_villiers_dialogue()
{

	// instead of triggering this we'll wait for the intro to send a notify
	e1_introduction_trig = getent( "trig_start_e1_vin", "targetname" );
	//e1_introduction_trig waittill( "trigger" );
	level waittill("air_intro_done");

	//iprintlnbold( "TANNER: Bond, some sort of malware just froze the airport's network." );
	// wait( 2.5 );
	// 06-10-08
	// play the sound, line one
	// sound not working, printlns
	level.player maps\_utility::play_dialogue( "TANN_AirpG_004A", true );



	// iprintlnbold( "TANNER: It's probably a virus. Download a copy and we'll see if we can neutralize it." );
	// play the sound
	level.player maps\_utility::play_dialogue( "TANN_AirpG_005A", true );

	//// give the notify for the 1st obj
	//level notify( "give_1st_obj" );


	// wait for the player to start the download of the machine
	maps\_utility::flag_wait( "objective_1" );

	// Bond talks to Villiers
	// iprintlnbold( "BOND: I'm downloading now." );
	// wait( 1.0 );
	// iprintlnbold( "TANNER I'm seeings the virus, it's a worm." );
	// wait( 2.0 );
	// iprintlnbold( "TANNER: But I only got half before it deteced you and shut down your terminal." );
	// wait( 3.0 );
	// iprintlnbold( "TANNER: Get to another computer. To do a disinfect, I'll need a complete copy." );
	// play the sound
	// dialogue - Bond
	level.player maps\_utility::play_dialogue( "BOND_AirpG_006A" );

	// dialogue - tanner
	level.player maps\_utility::play_dialogue_nowait( "TANN_AirpG_007A", true );

	// clean up the trigger
	e1_introduction_trig delete();
}
// ---------------------//
// 02-08-08
// wwilliams
// conversation between the two guys in event one
e1_start_conversation( dood_1, dood_2 )
{
				// double check that the two people passed into the function are defined
				if( !isdefined( dood_1 ) )
				{
								//iprintlnbold( "dood_1_not_defined" );
								return;
				}
				else if( !isdefined( dood_2 ) )
				{
								//iprintlnbold( "dood_2_not_defined" );
								return;	
				}

				// the endons
				dood_1 endon( "damage" );
				dood_1 endon( "death" );
				dood_2 endon( "damage" );
				dood_2 endon( "death" );
				level endon( "e1_stealth_cancelled" );

				// define the objects needed for the function

				// reminders of the conditions to pass into the loop_print3d
				// loop_print3d( vec_text_position, str_text, color, seconds, str_notify, alpha, scale )

				// wait for the activate notify
				level waittill( "start_e1_conversation" );

				// iprintlnbold( "start talking" );

				// first new dialog
				// "The terminal's almost clear, and we've taken the office.  Only men left are ours."
				// level.player playsound( "CCM1_AirpG_01A", "e1_thu_dia1" );

				// wait for first line
				// level.player waittill( "e1_thu_dia1" );

				//iprintlnbold( "MERC 1: The terminal is almost clear," );
				wait( 2.0 );
				//iprintlnbold( "MERC 1: and we've taken the office" );
				wait( 2.0 );
				//iprintlnbold( "MERC 1: Only men left are ours." );


				// iprintlnbold( "line 1" );

				// second line new dialog
				// "How long 'til we've got control of network traffic?"
				// level.player playsound( "CCM1_AirpG_02A", "e1_thu_dia2" );

				// wait for second line
				// level.player waittill( "e1_thu_dia2" );

				//iprintlnbold( "MERC 2: How long 'til we've got control of the network traffic?" );
				wait( 2.0 );

				// iprintlnbold( "line 2" );

				// third dialog line
				// "Already happening.  It'll take about two minutes to infect the whole network."
				// level.player playsound( "CCM2_AirpG_03A", "e1_thu_dia3" );

				// wait for the third line to finish
				// level.player waittill( "e1_thu_dia3" );

				//iprintlnbold( "MERC 1: Already happening." );
				wait( 2.0 );
				//iprintlnbold( "MERC 1: It'll take about two minutes to infect the whole network." );
				wait( 2.0 );

				// iprintlnbold( "line 3" );

				// send out this notify to continue the level
				level notify( "e1_convo_p4" );


}
// ---------------------//

// ---------------------//
// wwilliams 11-27-07
// camera start up and function sets for the camera in zone one
e1_cameras_init()
{
				// endon
				level endon( "event_one_done" );

				// objects needed defined for the function to work
				// cameras
				e1_camera_1 = getent( "ent_e1_camera_1", "targetname" );
				e1_camera_2 = getent( "ent_e1_camera_2", "targetname" );
				// trigs
				trig_cam1_disable = getent( "trig_e1_cam1_hack", "targetname" );
				trig_cam2_disable = getent( "trig_e1_cam2_hack", "targetname" );
				// frame wait
				wait( 0.05 );
				// ent (hack boxes)
				ent_e1_hack_cam1 = getent( e1_camera_1.script_parameters, "targetname" );
				ent_e1_hack_cam2 = getent( e1_camera_2.script_parameters, "targetname" );
				// ent array
				// WW 07-08-08
				// feedboxes no longer hook to main cameras, they hook to script orgs
				enta_e1_cams = getentarray( "air_feedbox_one", "targetname" );
				// enta_e1_one_cam = [];
				// feed box
				ent_e1_feed_box = getent( "air_e1_feed_box", "targetname" );

				// 02-21-08
				// need to define destroyed on the first cam to use it in this fashion
				e1_camera_1.destroyed = false;
				e1_camera_1.disabled = false;

				// level maps\_utility::add_to_array ( enta_e1_one_cam, e1_camera_1 );

				// 02-21-08
				// wwilliams
				// need to activate camera right away and try to capture the moment of the two guys talking
				// calling a function straight from _securitycamera, this should start the camera
				// without it turning
				e1_camera_1 thread maps\_securitycamera::camera_phone_track( true, true );

				// level thread maps\_securitycamera::camera_render_switch( enta_e1_one_cam, 5 );

				// 02-21-08
				// wwilliams
				// first camera should be on without moving now
				// wait for the conversation to end
				// wait for the intro to end
				
				// DCS: no intro for Demo.
				if( Getdvar( "demo" ) != "1" )
				{
					level waittill( "air_intro_done" );
				}
					
				level.player enablevideocamera(false);

				// e1_camera_1 notify( "stop_tracking" );

				// disable global video camera
				// level.player EnableVideoCamera( false );
				// e1_camera_1 thread maps\_securitycamera::camera_phone_track( false, false );

				// 04-21-08
				// wwilliams
				// hack to make the cameras work
				// enta_e1_cams = maps\_utility::add_to_array( enta_e1_cams, e1_camera_1 );
				// enta_e1_cams = maps\_utility::add_to_array( enta_e1_cams, e1_camera_2 );


				// start cameras
				// 04-09-08
				// now uses the hack box setup from _securitycameras.gsc
				e1_camera_1 thread maps\_securitycamera::camera_start( ent_e1_hack_cam1, true, true, false );
				e1_camera_2 thread maps\_securitycamera::camera_start( ent_e1_hack_cam2, true, true, false );

				// frame wait
				wait( 0.05 );

				// set up the script origins as cameras
				for( i=0; i<enta_e1_cams.size; i++ )
				{
								// set up each script org as a camera
								enta_e1_cams[i] thread maps\_securitycamera::camera_start( undefined, false, undefined, undefined );
				}

				// pass the cam array into the e1_air_feed_box
				// level thread e1_air_feed_box( enta_e1_cams );
				// 05-21-08
				// wwilliams
				// commmented out the old hack way of using the feed box
				// switching to the new hottness from mark
				level thread maps\_securitycamera::camera_tap_start( ent_e1_feed_box, enta_e1_cams );

				// 
				// e1_camera_1 thread camera_disable( trig_cam1_disable );
				// e1_camera_2 thread camera_disable( trig_cam2_disable );

				// function that watches for damage applied to the camera
				// then sends out the broken stealth notify
				e1_camera_1 thread e1_camera_destroyed();
				e1_camera_2 thread e1_camera_destroyed();

				// function that disables the other camera when stealth is broken
				e1_camera_1 thread e1_camera_disable();
				e1_camera_2 thread e1_camera_disable();

				// function checks to see if camera spots player
				e1_camera_1 thread e1_camera_watch();
				e1_camera_2 thread e1_camera_watch();

}
// ---------------------//
// wwilliams 11-28-07
// clean up the spawners, trigs and wahtever else of event one
event_one_clean_up()
{
				// wait for the flag to be set
				level maps\_utility::flag_wait( "objective_1" );

				// grab the spawners of the area
				ent_array_spawners = getentarray( "e1_spawners", "script_noteworthy" );
				wait( 0.1 );

				// delete them
				for( i=0; i<ent_array_spawners.size; i++ )
				{
								// delete them one by one
								ent_array_spawners[i] delete();
								wait( 0.1 );
				}
}
// ---------------------//
// 02-10-08
// wwilliams
// function that waits for the flag informing stealth has been broken in event 1
// runs on the level
e1_stealth_flag_set()
{

				// define objects needed for this function
				// objects to be defined for the function
				// enemy spawner
				spawner = getent( "spwn_e1_backup", "targetname" );
				// nodes to defend around
				noda_e1_defense = getnodearray( "nod_e1_backup", "targetname" );
				// nodes to start the backup from
				nod_e1_backup_1 = getnode( "nod_e1_backup1_start", "targetname" );
				nod_e1_backup_2 = getnode( "nod_e1_backup2_start", "targetname" );
				// backup door that needs to be locked after the enemies come through
				ent_e1_backup_door = getentarray( "e1_door_backup", "targetname" );
				// nod_e1_back_door = getnodearray( ent_e1_backup_door[0].target, "targetname" );

				// wait for notify that stealth is broken
				level waittill( "e1_stealth_broken" );

				// send out the notify to turn off all the other threads waiting
				level notify( "e1_stealth_cancelled" );

				// change the flag
				level maps\_utility::flag_set( "e1_stealth_broken" );


				// 02-19-08
				// new stealth function call from the airport_util
				level thread maps\airport_util::spawn_event_backup_init( spawner, noda_e1_defense );

}
// ---------------------//
// 02-19-08
// wwilliams
// function waits for the notify that stealth is broken
// then sets the guys on patrol to alert red
// runs on self
e1_patrol_alert()
{
				// endon
				self endon( "death" );

				// wait for the notify that stealth is broken
				level waittill( "e1_stealth_broken" );

				// change the alert state to red
				// self lockalertstate( "alert_red" );
				self setalertstatemin( "alert_red" );

				// change the script speed to run
				self setscriptspeed( "default" );

}
// ---------------------//
// 02-10-08
// wwilliams
// watches the security cameras, when they become alerted
// sends out the notify that stealth is broken
// runs on the camera
e1_camera_watch()
{
				// endon
				self endon( "disable" );
				self endon( "damage" );
				level endon( "e1_stealth_cancelled" );

				// wait for the camera to become alerted
				self waittill( "spotted" );

				// once the camera has spotted the player send out the 
				// stealth break notify
				level notify( "e1_stealth_broken" );

}
// ---------------------//
// 02-11-08
// wwilliams
// if the security camera is destroyed by the player
// stealth is broken and enemies will spawn out
e1_camera_destroyed()
{
				// endon
				self endon( "disable" );
				level endon( "e1_stealth_cancelled" );

				// wait for the damage to happen
				self waittill( "damage" );

				// send out the notify that stealth has been broken
				level notify( "e1_stealth_broken" );

}
// ---------------------//
// 02-11-08
// wwilliams
// function disables the camera if stealth is broken
e1_camera_disable()
{
				// endons
				self endon( "disable" );
				self endon( "damage" );

				// wait for the stealth cancelled notify
				level waittill( "e1_stealth_cancelled" );

				// disable the camera
				self notify( "disable" );
}
// ---------------------//

// ---------------------//
// waits for player to hit trigger
// then ends event one
end_event_one()
{


				level maps\_utility::flag_wait( "objective_1" );

				level.effects = false;

				level notify( "event_one_done" );
	
}


////////////////////////////////////////////////////
//				FIRST SERVER PIP 
////////////////////////////////////////////////////

server1_pip_camera()
{
	// no hud
	//setSavedDvar("cg_drawHUD", "0");
	setdvar("ui_hud_showstanceicon", "0"); 
	setsaveddvar("ammocounterhide", "1");  
	setdvar("ui_hud_showcompass", 0);
	//lock player
	level.player FreezeControls( true );

	// change cam
	level thread main_camera();
	// play anim on bond
	level thread second_anim();

	wait(3.0);

	// crop and move down
	level thread main_crop();
	level thread main_move();

	// PIP
	level thread second_move();

	level waittill( "window_uncrop" );
	
	// hud
	//setSavedDvar("cg_drawHUD","1");
	setdvar("ui_hud_showstanceicon", "1"); 
	setsaveddvar("ammocounterhide", "0");  
	setdvar("ui_hud_showcompass", 1);
	// unlock player
	level.player FreezeControls( false );
	// save
	level notify("checkpoint_reached"); // checkpoint 2
}
main_camera()
{
	//turn off camera collision
	level.player customcamera_checkcollisions( 0 );

	// DCS: need to hide bond so don't see clipping through head.
	thread maps\airport_util::hideBond(0.5);

	//cut to hallway
	ent = getent("ent_obj_1", "targetname");
	time = 0.0;
	hall_cam = level.player customCamera_push("world", ent.origin + (0, 0, 60), ent.angles, time);

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

	time = 2.0;
	org = ( 309, 986, 175 );
	ang = ( .74, 121.9, 0 );
	hall_cam = level.player customCamera_change(hall_cam, "world", org, ang, time);
	
	level waittill("window_uncrop");
	//back to player
	level.player customCamera_pop(hall_cam, 0);
	//turn on camera collision
	level.player customcamera_checkcollisions(1);
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
	//iprintlnbold("main_crop 1");
	level.player animatepip( 500, 1, -1, -1, .75, .75, 0.75, .75);
	level.player waittill("animatepip_done");
		
	level notify("window_crop");
		
	//level waittill("off_screen");
	level waittill("window_up");

	//uncrop
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	//iprintlnbold("main_crop 2");
	level.player animatepip( 500, 1, -1, -1, 1, 1, 1, 1);
	wait(1);
	//// 08/12/08 jeremyl
	//wait(0.1);
	level notify( "window_uncrop" );
	
	//reset back to default
	SetDVar("r_pip1Scale", "1 1 1 1");		// default
	SetDVar("r_pipMainMode", 0);	//so aiming not messed up
}
main_move()
{
	
	level waittill("window_crop");
		
	////(time,screen,x,y,scalex, scaley, cropx, cropy)
	////iprintlnbold("main_move 1");
	//level.player animatepip( 500, 1, -1, 0.16 );
	//wait(0.5);
	
	level notify("window_down");
	
	level waittill("off_screen");
	
	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify("window_up");
}
//pip
second_move()
{
	//setup PIP

	//setup pip camera
	level.player setsecuritycameraparams( 65, 3/4 );
	wait(0.05);	//need this or it will crash
	cameraID_hack = level.player securityCustomCamera_Push( "entity", level.player, level.player, ( -50, -40, 77), ( -32, -7, 0), 0.1);
	
	//SetDVar("r_pipSecondaryX", .6 );						// start off screen
	//SetDVar("r_pipSecondaryY", -.3);						// place top right corner of display safe zone
	SetDVar("r_pipSecondaryAnchor", 4);						// use top left anchor point
	//SetDVar("r_pipSecondaryScale", ".36, .5, .35, .5");		// scale image, without cropping
	//SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio

	//set border and color
	setdvar("cg_pipsecondary_border", 2);
	setdvar("cg_pipsecondary_border_color", "0 0 0.2 1");

	//set up the pip	
	//start offscreen
	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	//iprintlnbold("second_move 1");
	level.player animatepip( 10, 0, 0.6, -0.5, .352188, .5, .35, .5);
	level.player waittill("animatepip_done");
	
	level waittill( "window_down" );

	SetDVar("r_pipSecondaryMode", 5);		// enable video camera display with highest priority 		

	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	level.player animatepip( 500, 0, 0.6, .15);
	level.player waittill("animatepip_done");
	
	//level.player animatepip( 3000, 0, 0.6, .3);

	//notify from 
	// wait for conversation to end
	level waittill( "sending_suspense_dood" );
	//wait(1.5);

	//(time,screen,x,y,scalex, scaley, cropx, cropy)
	//iprintlnbold("second_move 2");
	level.player animatepip( 500, 0, .6, 1 );
	wait(0.6);
		
	level notify("off_screen");
	
	//reset
	level.player securitycustomcamera_pop(cameraID_hack);
	SetDVar("r_pipSecondaryMode", 0);
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

////////////////////////////////////////////////////

// ---------------------//

display_chyron()
{
	wait(2);
	maps\_introscreen::introscreen_chyron(&"AIRPORT_INTRO_01", &"AIRPORT_INTRO_02", &"AIRPORT_INTRO_03");
}
