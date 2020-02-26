// Airport event five file
// Builder: Brian Glines
// Scritper: Walter Williams
// Created: 10-08-2007

// Includes
#include maps\_utility;
#include maps\airport_util;

main()
{
	// level var 
	// level.hangar_fog = false;

	// frame wait
	wait( 0.05 );

	// save the game so the player doesn't have to go through that cutscene each time
	// savegame( "airport" );
	//level maps\_autosave::autosave_now( "airport" );
	level notify("checkpoint_reached"); // checkpoint 8

	level maps\_utility::flag_init("speed_up_carlos");
	level maps\_utility::flag_clear("speed_up_carlos");

	// 04-06-08
	// wwilliams
	// function starts carlos's set of functions
	level thread e5_carlos_init();

	// function opens the garage doors
	level thread e5_gdoors_init();

	// function waits for the player to use the trigger before opening gdoors
	// 06-19-08
	// wwilliams
	// moving this to the beginning of the airport_four
	//level thread e5_button_open_gdoors();

	//Turn Music Off		
	level notify("endmusicpackage");

	// function starts up the functions for the guards
	// 	level thread e5_car_guards_init();

	// function makes tanner talk to bond
	level thread e5_tanner_speaks();

	// function for the test explosion and the smoke pillar
	// 	level thread e5_tank_obsfucate();

	// checking bug 5151
	// level thread test_peeking();

	// thread off the first stair shooter
	//level thread first_stair_shooter();

	//// second staircase enemy
	//level thread second_stair_shooter();

	//// third stair shooter
	//level thread third_stair_shooter();


	// waittill level complete
	level waittill( "e5_complete" );

}
// ---------------------//
// 04-06-08
// wwilliams
// function to control the garage doors that
// open to the hanger
e5_gdoors_init()
{
	// endon
	// single shot function

	// objects to be defined for the function
	// ents
	sbrush_gdoor_1 = getent( "ent_e5_gdoor_a", "targetname" );
	sbrush_gdoor_2 = getent( "ent_e5_gdoor_b", "targetname" );
	sbrush_gdoor_3 = getent( "ent_e5_gdoor_c", "targetname" );
	// trig
	trig = getent( "ent_trig_start_e5", "targetname" );

	// wait for the notify
	level waittill( "str_open_gdoors" );
	// trig hit for debug
	//trig waittill( "trigger" );


	// send each door into the open door function
	sbrush_gdoor_1 thread e5_open_gdoors( 3.0, "gdoor_1" );
	//SOUND door open start - jrb
	sbrush_gdoor_1 playsound("garage_door_open_start");
	wait( 0.2 );
	sbrush_gdoor_3 thread e5_open_gdoors( 3.0, "gdoor_3" );
	sbrush_gdoor_3 playsound("garage_door_open_start");
	wait( 0.3 );
	sbrush_gdoor_2 thread e5_open_gdoors( 3.0, "gdoor_2" );
	sbrush_gdoor_2 playsound("garage_door_open_start");

	// extra wait
	wait( 5.0 );

	// send out the notify to start the ambush
	level notify( "end_ambush_start" );


}
// ---------------------//
// 04-06-08
// wwilliams
// opens the doors, runs on doors/self
// doors are 128 units tall
// subtract six units so the handle doesnt go into the brush
e5_open_gdoors( flt_time, str_notify )
{
	// check that flt_time is defined
	assertex( isdefined( flt_time ), "flt_time is not defined for " + self.targetname );

	// move self up 122 units
	self moveto( self.origin + ( 0, 0, 122 ), flt_time );

	//SOUND: garage doors?
	self playsound("garage_door_open");

	// notify to the ai to start shooting
	level notify( str_notify );

	// wait for the move to be complete
	self waittill( "movedone" );

	// sound hook for the sound of the alarm from the door fail
	//SOUND powerup - jrb
	//self playsound("door_alarm_1");

	// debug explain
	/*iprintlnbold( "garage doors stall!" );*/

	// wait for the enemies to get into place
	// level waittill( "e5_guards_set" );
	wait( 3.0 );

	// move the door up the rest of the way, slowly
	/*		self moveto( self.origin + ( 0, 0, 100 ), ( flt_time * randomfloatrange( 2.7, 4.2 ) ) );*/



	// send out a notify for carlos to start moving
	// level notify( "carlos_go" );

}
// ---------------------//
// 04-06-08
// wwilliams
// function start up carlos then sends him into his own function
// runs on level
e5_carlos_init()
{
	// endon
	// ludes
	// single shot function

	// objects to be defined for the function
	// spawner
	spwn_carlos = getent( "ent_spwn_carlos", "targetname" );
	//				level.ai_temp = undefined;				


	// undefined
	level.carlos = undefined;


	// double check the spawner count
	if( spwn_carlos.count == 0 )
	{
		spwn_carlos.count = 5;
	}

	// spawn out carlos
	level.carlos = spwn_carlos stalingradspawn( "carlos" );

	// make sure he spawned out
	if( spawn_failed( level.carlos ) )
	{
		// debug text
		//iprintlnbold( "carlos failed spawn" );

		// wait
		wait( 1.0 );

		// end function
		return;
	}
	else
	{
		// notify that carlos is around
		level notify( "carlos_made" );

		// set carlos up
		level.carlos setenablesense( false );
		level.carlos lockalertstate( "alert_red" );
		level.carlos SetPainEnable( false );
		level.carlos SetFlashBangPainEnable( false );

		// send off the guards
		// level thread e5_car_guards_init();

		// notify for carlos to start moving
		// level notify( "e5_guards_set" );

		level waittill( "end_ambush_start" );

		// run the function to control carlos
		level.carlos thread e5_carlos_last_stand();

		// function that finishes the level after killing carlos
		level thread e5_carlos_killed( level.carlos );	
		level thread e5_bond_runs_away_kill_em();
	}

	// clean up the spawner
	spwn_carlos delete();
}
// ---------------------//
// 04-06-08
// wwilliams
// function controls carlos's run through the end
// runs on carlos/self
e5_carlos_last_stand()
{
	// endon
	self endon( "death" );

	// objects to be defined for this function
	// nodes
	// singles
	nod_carlos_one = getnode( "nod_carlos_one", "targetname" );
	nod_carlos_two = getnode( "nod_carlos_two", "targetname" );
	nod_carlos_three = getnode( "nod_carlos_three", "targetname" );
	nod_carlos_four = getnode( "nod_carlos_four", "targetname" );
	nod_carlos_five = getnode( "nod_carlos_five", "targetname" );
	nod_carlos_six = getnode( "nod_carlos_six", "targetname" );
	nod_carlos_seven = getnode( "nod_carlos_seven", "targetname" );
	nod_carlos_eight = getnode( "nod_carlos_eight", "targetname" );
	nod_carlos_nine = getnode( "nod_carlos_nine", "targetname" );
	nod_carlos_ten = getnode( "nod_carlos_ten", "targetname" );
	nod_carlos_eleven = getnode( "nod_carlos_eleven", "targetname" );
	nod_carlos_at_truck = GetNode( "nod_carlos_wins", "targetname" );
	// array
	noda_carlos_last = getnodearray( "nod_carlos_last_stop", "targetname" );
	// undefined
	int_random = undefined;

	//while( 1 )
	//{
	//				wait( 50 );
	//}

	// turn on carlos perfectsense
	self setperfectsense( true );
	// make carlos sprint
	self setscriptspeed( "sprint" );
	// run to the first node
	self setgoalnode( nod_carlos_one );
	// wait for goal
	self waittill( "goal" );

	// if this flag is set then skip the fighting crap, just keep going to the next node
	if(!maps\_utility::flag("speed_up_carlos"))
	{
		// go back to default speed
		self setscriptspeed( "default" );
		// fire at the player again
		self cmdshootatentity( level.player, true, randomintrange( 2, 5 ), 0.8, true );
		// wait for carlos to finish firing
		self waittill( "cmd_done" );
		// 08/12/08 jeremyl ludes
		level.carlos_run_support_wave_on = true;
		// random wait?
		wait( 1.0 );
	}

	// move to node two
	self setgoalnode( nod_carlos_two );
	// dialog hook for tanner
	// iprintlnbold( "Tanner:Don't let him reach the fuel truck, Bond." );
	level.player maps\_utility::play_dialogue_nowait( "TANN_AirpG_031B", true );
	// wait for goal
	self waittill( "goal" );

	// if this flag is set then skip the fighting crap, just keep going to the next node
	if(!maps\_utility::flag("speed_up_carlos"))
	{
		// go back to default speed
		self setscriptspeed( "default" );
		// blind fire at the player from here
		self cmdshootatentity( level.player, true, 3, 0.8, true );
		// wait for carlos to finish firing
		self waittill( "cmd_done" );
	}
	else
	{
		// make carlos sprint
		self setscriptspeed( "sprint" );
	}

	// make a random int
	int_random = randomint( 12 );
	// random int decides next spot
	if( int_random <= 6 )
	{
		// send carlos to node three
		self setgoalnode( nod_carlos_three, 1 );
	}
	else
	{
		// send him to the fourth node
		self setgoalnode( nod_carlos_four );
	}
	// tanner dialog hook
	// iprintlnbold( "Tanner:That bomb can't be allowed to reach that truck." );
	level.player maps\_utility::play_dialogue_nowait( "TANN_AirpG_032C", true );
	// wait for goal
	self waittill( "goal" );

	// if this flag is set then skip the fighting crap, just keep going to the next node
	if(!maps\_utility::flag("speed_up_carlos"))
	{
		// go back to default speed
		self setscriptspeed( "default" );
		// fire at the player
		self cmdshootatentity( level.player, true, randomintrange( 3, 7 ), 0.8, true );
		// wait for carlos to finish firing
		self waittill( "cmd_done" );
		level.carlos_run_support_wave_on = true;
	}
	else
	{
		// make carlos sprint
		self setscriptspeed( "sprint" );
	}

	// new random int
	int_random = randomint( 20 );
	// check the new random
	if( int_random > 10 )
	{
		// send to sixth node
		self setgoalnode( nod_carlos_six, 1 );
	}
	else
	{
		// send to fifth node
		self setgoalnode( nod_carlos_five, 1 );
	}
	// wait for goal
	self waittill( "goal" );

	// if this flag is set then skip the fighting crap, just keep going to the next node
	if(!maps\_utility::flag("speed_up_carlos"))
	{
		// go back to default speed
		self setscriptspeed( "default" );
		// fire at the player
		self cmdshootatentity( level.player, true, randomintrange( 3, 7 ), 0.8, true );
		// wait for carlos to finish shooting
		self waittill( "cmd_done" );
	}
	else
	{
		// make carlos sprint
		self setscriptspeed( "sprint" );
	}

	// send carlos to the seventh node
	self setgoalnode( nod_carlos_seven, 1 );
	// wait for goal
	self waittill( "goal" );

	// if this flag is set then skip the fighting crap, just keep going to the next node
	if(!maps\_utility::flag("speed_up_carlos"))
	{
		// go back to default speed
		self setscriptspeed( "default" );
		//  jeremyl
		level.carlos_run_support_wave_on = true;
		// change his allow stances to crouch only
		self allowedstances( "crouch" );
	}
	else
	{
		// make carlos sprint
		self setscriptspeed( "sprint" );
	}

	// move him to the eight node
	self setgoalnode( nod_carlos_eight );
	// tanner dialog hook
	// iprintlnbold( "Tanner:Stop him now, Bond." );
	level.player maps\_utility::play_dialogue_nowait( "TANN_AirpG_033D", true );
	// wait for goal
	self waittill( "goal" );

	// if this flag is set then skip the fighting crap, just keep going to the next node
	if(!maps\_utility::flag("speed_up_carlos"))
	{
		//  jeremyl
		level.carlos_run_support_wave_on = true; 
		// carlos throws grenade at the player
		self magicgrenade( self.origin, level.player.origin, 3.0 );
		// wait two seconds
		wait( 2.0 );
		// change allowedstances back to normal
		self allowedstances( "stand" );
	}
	else
	{
		// make carlos sprint
		self setscriptspeed( "sprint" );
	}

	// change script speed
	self setscriptspeed( "sprint" );
	// send carlos to node nine
	self setgoalnode( nod_carlos_nine, 1 );
	// wait for goal
	self waittill( "goal" );

	// if this flag is set then skip the fighting crap, just keep going to the next node
	if(!maps\_utility::flag("speed_up_carlos"))
	{
		// shoot at the player
		self cmdshootatentity( level.player, true, randomintrange( 3, 7 ), 0.8, true );
		// wait for the shooting to stop
		self waittill( "cmd_done" );
	}

	// carlos to node ten
	self setgoalnode( nod_carlos_ten, 1 );
	// tanner dialog hook
	// iprintlnbold( "Tanner:Hurry, Bond, shoot him." );
	level.player maps\_utility::play_dialogue_nowait( "TANN_AirpG_034E", true );
	// wait for goal
	self waittill( "goal" );

	// if this flag is set then skip the fighting crap, just keep going to the next node
	if(!maps\_utility::flag("speed_up_carlos"))
	{
		// change speed back to normal
		self setscriptspeed( "default" );
		//  jeremyl
		level.carlos_run_support_wave_on = true;
		// wait a sec
		wait( 1.0 );
	}
	else
	{
		// make carlos sprint
		self setscriptspeed( "sprint" );
	}

	// move to eleven
	self setgoalnode( nod_carlos_eleven, 1 );
	// wait for goal
	self waittill( "goal" );

	// carlos is almost to the plane, go to a random low cover before the plane
	self setgoalnode( noda_carlos_last[randomint(noda_carlos_last.size)] );
	// wait for goal
	self waittill( "goal" );

	// if this flag is set then skip the fighting crap, just keep going to the next node
	if(!maps\_utility::flag("speed_up_carlos"))
	{
		// change speed back to normal
		self setscriptspeed( "default" );
		// wait a second
		wait( 1.2 );
		// fire at the player real quick
		self cmdshootatentity( level.player, true, 2.0, 0.7, true );
		// wait for the cmd to finish
		self waittill( "cmd_done" );
		// wait a second
		wait( 1.0 );
	}
	else
	{
		// make carlos sprint
		self setscriptspeed( "sprint" );
	}

	// send carlos to the truck
	self setgoalnode( nod_carlos_at_truck, 1 );
	// tanner dialog hook
	// iprintlnbold( "Tanner:Stop the bomber, Bond. Now!" );
	level.player maps\_utility::play_dialogue_nowait( "TANN_AirpG_035F", true );
	// wait for goal
	self waittill( "goal" );

	// carlos has won and caused the truck to explode
	level thread hangar_plane_explodes();

}
///////////////////////////////////////////////////////////////////////////
// 07-31-08 WWilliams
// plane explodes
hangar_plane_explodes()
{
	// endon

	// objects to be defined for this function
	// explosion points
	truck_explode = GetNode( "nod_carlos_wins", "targetname" );
	plane_fuselage_explode = getent( "so_fuse_exp", "targetname" );
	plane_wing_explode = getent( "so_wing_exp", "targetname" );
	engine_explore = getent( "so_engine_exp", "targetname");
	tugger_explode = getent( "so_engine_exp", "targetname" );
	close_to_bond_explode = getent( "so_close_bond_exp", "targetname" );

	// DCS: start timescale.
	level thread slow_time(.15, 0.25);

	// explode at fuselage
	end_explosion_a = playfx( level._effect[ "end_explosion" ], truck_explode.origin );
	// sound effect
	level.player playsound( "airplane_explo" );
	// earthquake
	earthquake( 0.7, 2.0, truck_explode.origin, 2700 );

	// set blur
	setblur( 0.5, 0.25 );

	// wait
	wait( 0.35 );

	// explode at wing
	end_explosion_b = playfx( level._effect[ "end_explosion" ], plane_fuselage_explode.origin );
	// sound effect
	level.player playsound( "airplane_explo" );
	// earthquake
	earthquake( 0.75, 2.0, plane_fuselage_explode.origin, 2700 );

	// set blur
	setblur( 1.0, 0.25 );

	// wait
	wait( 0.5 ); // 0.35

	// explode at engine
	end_explosion_c = playfx( level._effect[ "end_explosion" ], engine_explore.origin );
	// sound effect
	level.player playsound( "airplane_explo" );
	// earthquake
	earthquake( 0.8, 2.0, engine_explore.origin, 2700 );

	// set blur
	setblur( 1.5, 0.25 );

	// wait
	wait( 0.35 ); // 0.35

	// explode at tugger
	end_explosion_d = playfx( level._effect[ "end_explosion" ], tugger_explode.origin );
	// sound effect

	end_explosion_ba = playfx( level._effect[ "end_explosion" ], level.player.origin +(700,700,0) );
	level.player playsound( "airplane_explo" );
	// earthquake
	earthquake( 0.85, 2.0, tugger_explode.origin, 2700 );

	// set blur
	setblur( 2.0, 0.25 );

	// wait
	wait( 0.35 ); // 0.35

	// 08/10/08 jeremyl
	end_explosion_ba = playfx( level._effect[ "end_explosion" ], level.player.origin +(300,300,0) );


	// explode close to bond
	end_explosion_e = playfx( level._effect[ "end_explosion" ], close_to_bond_explode.origin );
	// sound effect
	level.player playsound( "airplane_explo" );
	earthquake( 2.0, 1, level.player.origin, 4000 );
	// earthquake
	//				earthquake( 0.95, 2.0, close_to_bond_explode.origin, 2700 );

	level notify("stop_timescale");

	// shellshock the player
	wait(0.3);
	// fade to whiet should happen here
	// mission failed
	missionfailedwrapper();
	level.player shellshock( "flashbang", 6 );

}

// DCS: timescale for effect of explosion. stolen from whites.
slow_time(val, out_tim)
{
	SetSavedDVar( "timescale", val);

	level waittill("stop_timescale");

	change = (1-val) / (out_tim*30);
	while(val < 1)
	{
		val += change;
		SetSavedDVar( "timescale", val);
		wait(0.05);
	}

	SetSavedDVar("timescale", 1);
}





// ---------------------//
// 04-06-08
// wwilliams
// function controls the three guards for carlos in the hanger
// runs on level
//e5_car_guards_init()
//{
//				// endon
//
//				// objects to be defined for this function
//				// spawner
//				spwn_guards = getent( "ent_spwn_carlos_guards", "targetname" );
//				// nodes
//				guard_1_start = GetNode( "nod_car_guard_1", "targetname" );
//				guard_2_start = GetNode( "nod_car_guard_2", "targetname" );
//				guard_3_start = GetNode( "nod_car_guard_3", "targetname" );
//				// undefined
//				guard = undefined;
//
//				// double check defines
//				assertex( isdefined( spwn_guards ), "e5_car_guards spawner not defined" );
//
//				// spawn out the guards and send them to their nodes
//				for( i=0; i<3; i++ )
//				{
//								// spawn out a guy
//								guard = spwn_guards stalingradspawn( "car_guard" );
//
//								// double check the spawn
//								if( spawn_failed( guard ) )
//								{
//												// debug text
//												iprintlnbold( "car_guard fail spawn" );
//
//												// wait 
//												wait( 1.0 );
//
//												// exit func
//												return;
//								}
//								else
//								{
//												// should set the speed to sprint to get into place
//												guard setscriptspeed( "sprint" );
//
//												// give guard a tether point and distance
//												// guard.tetherpt = level.carlos.origin;
//
//												// func runs on them to follow carlos
//												guard thread e5_ambush();
//
//												// turn off the ai at first, this way the guy doesn't shoot through the door
//												guard setenablesense( false );
//
//												// setup tether before sending them to the wait nodes
//												guard thread give_tether_at_goal( level.carlos, 32, 256, 24 );
//
//												// check to see where i is
//												if( i == 0 )
//												{
//																guard setgoalnode( guard_1_start );
//												}
//												else if( i == 1)
//												{
//																guard setgoalnode( guard_2_start );
//												}
//												else if( i == 2 )
//												{
//																guard setgoalnode( guard_3_start );
//												}
//												else
//												{
//																// debug text
//																iprintlnbold( "too many e5 guards!" );
//
//																// end function
//																return;
//												}
//
//
//								}
//
//								// undefine the guard
//								guard = undefined;
//
//								// wait so guys don't spawn on top of each other
//								wait( 0.7 );
//				}
//
//				// clean up
//				spwn_guards delete();
//				guard = undefined;
//
//}
// ---------------------//
// 04-06-08
// wwilliams
// ambush function for carlos's guards
// runs on guard/self
//e5_ambush()
//{
//				// endon
//				self endon( "death" );
//
//				// wait for the notify from carlos
//				level waittill( "carlos_go" );
//
//				// turn the ai sense back on
//				self setenablesense( true );
//
//				// turn on perfect sense
//				// self SetPerfectSense( true );
//				self thread turn_on_sense( 3 );
//
//}
// ---------------------//
// 04-06-08
// wwilliams
// function watches the guards for them all to die
// then sends out a notify for carlos to start running
// this function fires out from the guards_init
// runs on level
//e5_guards_watch( ent_array )
//{
//				// endon
//
//				// double check the array is defined
//				assertex( isdefined( ent_array ), "can't watch guards, array not defined!" );
//
//				// while loop checks that the count is over or equal to one
//				while( ent_array.size >= 1 )
//				{
//								// wait a milli
//								wait( 0.1 );
//
//								// check the array
//								ent_array = maps\_utility::remove_dead_from_array( ent_array );
//
//								// wait a frame
//								wait( 0.05 );
//				}
//
//				// once out of the array send out the notify
//				level notify( "carlos_guards_killed" );
//
//}
// ---------------------//
// 04-07-08
// wwilliams
// function waits for damage to be applied to the tankdolly
// then causes a small explosion and a pillar of smoke
//e5_tank_obsfucate()
//{
//				// endon
//				level endon( "no_more_jet_smoke" );
//
//				// objects
//				// trigs
//				ent_jet_fuel = getent( "ent_e5_jet_fuel", "script_noteworthy" );
//				// undefined
//				smoke = undefined;
//
//				// wait for damage to the trig
//				ent_jet_fuel waittill( "death" );
//
//				// play explosion
//				// jet_fuel_explo = playfx( level._effect[ "f_explosion" ], ent_jet_fuel.origin );
//				// explosion too bug, ask for another
//
//				// quick wait
//				wait( 0.5 );
//
//				// play the smoke effects off the top
//				// offset of 58 so it looks like it is coming from the top
//				while( 1 )
//				{
//								// play the smoke effect stolen from destoyed cars
//								smoke = playfx( level._effect[ "pillar_smoke" ], ent_jet_fuel.origin + ( 0, 0, 58 ) );
//
//								// quick wait
//								wait( 0.1 );
//
//								smoke = undefined;
//				}
//
//}
// ---------------------//
// test for the new function from code
/*test_peeking()
{
// endon

// while loop
while( 1 )
{
// check it every five second
wait( 2.0 );

// debug
iprintlnbold( "checking for peek!" );

if( level.player isincover() && level.player isincoverpeek() == 0 )
{
//debug
iprintlnbold( "player is peeking out from cover!" );
}
else
{
iprintlnbold( "peeking check failed!" );
}

wait( 1.0 );

}

}*/
// ---------------------//
// 04-07-08
// wwilliams
// function controls the "button" that opens the garage doors
// bond is informed to go that way after eliminating all teh enemies
// runs on level
// notify str_open_gdoors
e5_button_open_gdoors()
{
	// endon

	// objects to be defined for the function
	// script_model
	// 08/11/08 jeremyl added blinking yellow light
	//level thread blink_yellow_light();
	electrical_box = getent( "ent_e5_gdoor_button", "targetname" );
	// trig
	use_touch_trig = getent( electrical_box.target, "targetname" );
	use_touch_trig sethintstring(&"HINT_OPEN_GARAGE_DOORS");
	// 08/10/08 setup light that is here that can be used
	// tag origins for the top button and bottom button
	top_button_tag = electrical_box gettagorigin( "tag_top_button" );
	bottom_button_tag = electrical_box gettagorigin( "tag_bottom_button" );
	// var for the doors being open or closed
	level.gdoors_open = false;

	// run a trigger off on the trigger right away
	use_touch_trig maps\_utility::trigger_off();

	// spawn the buttons for the control panel
	top_button = spawn( "script_model", top_button_tag );
	// frame wait
	wait( 0.05 );
	// link top to box
	top_button linkto( electrical_box );
	// set the correct model
	top_button setmodel( "p_lvl_garage_control_button_off" );
	// bottom button
	bottom_button = spawn( "script_model", bottom_button_tag );
	// frame wait
	wait( 0.05 );
	// link the button to the tag
	bottom_button linkto( electrical_box );
	// set the correct model
	bottom_button setmodel( "p_lvl_garage_control_button_off" );
	// set the correct angles
	bottom_button.angles = ( -0, 180, 180 );

	// wait for the dialogue from tanner to finish
	//iprintlnbold("waiting on tanner");
	level waittill( "str_tanner_done" );
	//iprintlnbold("tanner spoke");

	// fire off the function that brings the player's attention
	// to the right place
	level thread e5_garage_button_blink( top_button );

	// change the objective text for 4
	// objective_string( 4, "Open the doors to Hangar C-2." );
	// objective_position( 4, electrical_box.origin );
	// notify to change the objective marker

	// wait a frame
	wait( 0.05 );

	// bring the trigger back up
	use_touch_trig maps\_utility::trigger_on();

	// wait for the player to use the trigger
	use_touch_trig waittill( "trigger" );

	// play the sound
	top_button playsound( "door_switch" );

	// change to the fog settings manny gave me
	// set the correct fog for the area
	SetExpFog( 0, 3961, 0.27, 0.28, 0.32, 0.05, 1 );
	Visionsetnaked( "airport_05" );

	//iprintlnbold("fog setting for hangar");

	// wait a frame
	wait( 0.05 );

	//split screen
	level thread split_screen();

	// now turn the trigger off again
	use_touch_trig maps\_utility::trigger_off();

	// send out the notify to open the garage doors
	level notify( "str_open_gdoors" );

	//Start Tarmac Music - added by chuck russom		
	level notify("playmusicpackage_tarmac");

	// change flag
	level.gdoors_open = true;

	// completed objective 4
	// objective_state( 4, "done" );

	// wait
	wait( 3.0 );

	// get carlos
	// carlos = getent( "carlos", "targetname" );


}


blink_yellow_light()
{
	light = getent ("e5_yellow_light","targetname");

	//level endon ( "kill_stair_light" );
	while ( 1 )
	{
		light setlightintensity ( 3.4 );
		wait( 1.5 );
		//iprintlnbold("asdfasdfasdfasdf");
		//		j = randomint( 20 );
		//		if ( j < 1 )
		//		{
		//			wait( 1 );
		//		}
		light setlightintensity ( 0 );
		wait(1.5);
	}
}


// ---------------------//
// 06-19-08
// wwilliams
// function controls the blinking of the garage door control
// button
// runs on level
e5_garage_button_blink( button )
{
	// endon
	level.player endon( "death" );

	// objects to be defined for the function
	// undefined
	fx = undefined;
	fx2 = undefined;

	//	fx2 = playfx( level._effect["garage_yellow"], button.origin +(30,30, 30) );

	//fx = playfx( level._effect["garage_yellow"], button.origin + (0,0,-30) );

	// while loop checks the var from the control func
	while(  level.gdoors_open == false )
	{
		// change the model of the button
		button setmodel( "p_lvl_garage_control_button_on" );
		// spawnfx
		//fx = playfx( level._effect["garage_yellow"], button.origin + (0,20,0) );
		fx = spawnfx( level._effect["garage_yellow"], button.origin + (0, 0,0) );
		triggerFx( fx );



		// wait sec & half
		wait( 1.8 );

		// change to the off version
		button setmodel( "p_lvl_garage_control_button_off" );
		// delete fx
		fx delete();
		//fx2 delete();

		// wait sec & half
		wait( 1.8 );

	}

	// after the flag gets set back to true make the button stay on
	button setmodel( "p_lvl_garage_control_button_on" );
	// spawnfx
	fx = playfx( level._effect["garage_yellow"], button.origin );

}
// ---------------------//
// 04-07-08
// wwilliams
// tanner tells Bond where to go after killing all the enemies
// runs on level
e5_tanner_speaks()
{
	//Stops the battle music - added by chuck russom		
	level notify("endmusicpackage");

	// endon

	//objects to be defined for this funciton

	// end fourth objective
	// change the flag
	level maps\_utility::flag_set( "objective_4" );

	// tanner's dialogue
	// iprintlnbold( "TANNER:Bond, the plane is being fueled as we speak." );
	level.player maps\_utility::play_dialogue("TANN_AirpG_030A", true );
	wait(0.05);

	// send out the notify that starts the gdoor button
	level notify( "str_tanner_done" );

	// wait
	// wait( 3.0 );

	// next line
	// iprintlnbold( "TANNER:If the bomber reaches the fuel truck the explosion will be catastrophic." );

	// wait
	// wait( 3.0 );

	// last line
	// iprintlnbold( "M:Find a way through those garage doors, Bond." );
	// need judy dench line here
	level.player maps\_utility::play_dialogue("M_AirpG_047A", true ); 
	level.player maps\_utility::play_dialogue("M_AirpG_048A", true ); // the bomber's nearly reached the target

	// send out the notify that starts the gdoor button
	//level notify( "str_tanner_done" );

}
// ---------------------//
// 04-08-08
// wwilliams
// function watches for carlos to die
// once he does the level ends
// runs on level with carlos passed in
e5_carlos_killed( carlos )
{
	blop = spawn( "script_origin", carlos.origin );	
	blop linkto(carlos, "tag_origin", (0,0,0), (0,0,0));
	crap = getent("jl_poop1","targetname");
	crap2 = crap stalingradspawn();
	crap2.accuracy = 0.3;
	crap2 setperfectsense( true );
	crap2 SetFlashBangPainEnable( false );
	crap2 thread wave_carlose_on();

	fake_grenade_guy = getent("jl_poop2","targetname");
	fake_grenade_guy2 = fake_grenade_guy stalingradspawn();

	fake_grenade_guy2 thread magic_bullet_shield();
	fake_grenade_guy2 hide();
	fake_grenade_guy2 lockalertstate( "alert_green" );
	fake_grenade_guy2 linkto(carlos, "tag_origin", (0,0,-200), (0,0,0));

	// wait for carlos to register death
	carlos waittill( "death" );

	blop unlink();

	fake_grenade_guy2 magicgrenade(fake_grenade_guy2.origin + (0,0,300), fake_grenade_guy2.origin + (0,0,270), 2.0);
	wait(0.1);							
	fake_grenade_guy2 stop_magic_bullet_shield();
	fake_grenade_guy2 delete();
	wait(2);
	blop playsound("bad_guy_explosion");
	end_explosion_a = playfx( level._effect[ "f_explosion" ], blop.origin );
	//physicsExplosionSphere( blop.origin +(0,0,-25), 300, 300, 40 );
	earthquake( 1, 1.0, level.player.origin, 2700 );
	wait(1.3);
	earthquake( 0.6, 0.5, level.player.origin, 2700 );
	//physicsExplosionSphere( blop.origin +(0,0,-25), 300, 300, 40 );
	blop playsound("bad_guy_explosion");
	end_explosion_a = playfx( level._effect[ "f_explosion" ], blop.origin );
	wait(0.5);
	earthquake( 0.3, 0.2, level.player.origin, 2700 );
	//physicsExplosionSphere( blop.origin +(0,0,-25), 300, 300, 40 );
	blop playsound("bad_guy_explosion");
	end_explosion_a = playfx( level._effect[ "f_explosion" ], blop.origin );

	// complete the objective
	objective_state( 5, "done" );

	//Ends the music - added by chuck russom
	level notify ( "endmusicpackage" );

	// give the player a second to relish
	wait( 1.5 ); 

	// leave event five
	level notify( "e5_complete" );
	//				break;
	//			}

	//			wait(0.1);
	//	}

}

// 08/14/08 jeremyl thread once the button is open
// ludes
e5_bond_runs_away_kill_em()
{
	// end this thread if carlos dies
	level.carlos endon("death");

	// need to wait before I start this thread.
	// ludes 

	while(  level.gdoors_open == false )
	{
		wait(0.1);
	}

	wait( 8 );

	stay_here = getent ("jl_plane_explode3", "targetname" );
	while ( 1 )
	{
		wait( .2 );
		dist = Distance( level.player.origin, stay_here.origin );
		//		pos = objective_marker_1_A.origin + ( 0, 0, 34 );
		//		color = ( 0, .5, 0 );            
		//		scale = 1.5;       
		//		Print3d( pos, dist, color, 1, scale, 1 );

		// the way this needs to work is when bond is close carlos does his normal, when bond is not, carlos does things faster
		// we'll use flags to get this effect
		if( dist < 1100 )
		{
			// keep carlos at normal speed
			level maps\_utility::flag_clear("speed_up_carlos");
		}
		else
		{
			// tell carlos to go faster
			level maps\_utility::flag_set("speed_up_carlos");

			//// send notify to blow up level.
			////level.player dodamage( 20, level.player.origin );	
			//level thread hangar_plane_explodes();
			//wait( 0.3 );
		}	
	}

}

// 08/12/08 jeremyl
wave_carlose_on()
{
	// event 5
	self endon( "death" );
	//		nod_shoot = getnode( "nod_1st_stair_shot", "targetname" );

	//		self setgoalnode( nod_carlos_one );

	// wait for goal
	//		self waittill( "goal" );


	//-2322 2635.5 92
	fake = spawn( "script_origin", (-1424, 8104, 312));
	while(1)
	{
		fake playsound ("SAM_E_1_McGs_Cmb" );
		//level.player playsound();
		wait( randomfloatrange( 5, 8) );
	}


	//flag_set
	//flag_clear
	while(1)
	{
		if( level.carlos_run_support_wave_on == true )
		{
			flag_wait( "carlos_run_support_wave_on" );
			//flag_wait("carlos_run_support_wave_on");
			//level waittill ("carlos_run_support_wave_on");

			self cmdaction( "callout" );

			self waittill( "cmd_done" );

			wait(3);

			level.carlos_run_support_wave_on = false;
			//flag_clear( "carlos_run_support_wave_on" );
			//flag_clear("carlos_run_support_wave_on");

		}
		wait(0.3);
	}
}

// ---------------------//
// 04-13-08
// wwilliams
// will wait a random amount of time, then make a guy stop,
// and shoot at the player for a couple of seconds
// runs on NPC\self
//e5_random_running_shot()
//{
//				// endon
//				self endon( "death" );
//				self endon( "goal" );
//
//				// wait a random amount less than two seconds
//				wait( randomfloatrange( 0.75, 2.0 ) );
//
//				// make self shoot at the player for two seconds with high accuracy
//				self cmdshootatentity( level.player, true, 2.0, 0.95 );
//
//}
// ---------------------//
// 06-23-08
// wwilliams
// function makes a guy run up the first set of stairs and fire
// down at the player
// runs on level
//first_stair_shooter()
//{
//				// endon
//
//				// objects to be defined for the function
//				// spawner
//				spawner = getent( "spwn_1st_stair_shot", "targetname" );
//				nod_shoot = getnode( "nod_1st_stair_shot", "targetname" );
//				// undefined
//				ent_temp = undefined;
//
//				// double check that the items are defined
//				assertex( isdefined( spawner ), "first_stair_shooter, spawner not defined" );
//				assertex( isdefined( nod_shoot ), "first_stair_shooter, node not defined" );
//
//				// spawn out an enemy
//				ent_temp = spawner stalingradspawn( "e5_stair_shooter" );
//
//				// double check the spawn
//				if( maps\_utility::spawn_failed( ent_temp ) )
//				{
//								// debug text
//								iprintlnbold( "fail spawn first_stair_shooter" );
//
//								// wait
//								wait( 5.0 );
//
//								// end function
//								return;
//				}
//
//				// quick endons
//				ent_temp endon( "death" );
//
//				level waittill( "end_ambush_start" );
//
//				// make sure the guy is alive
//				if( isalive( ent_temp ) )
//				{
//								// send the guy up the stairs
//								ent_temp setgoalnode( nod_shoot );
//
//								// give shooter perfect sense
//								ent_temp SetPerfectSense( true );
//
//								// wait for goal
//								ent_temp waittill( "goal" );
//
//								// make him throw a grenade
//								ent_temp magicgrenade( ent_temp.origin + ( 0, 0, 60 ), level.player.origin, 2.5 );
//
//								// see how this works for now
//				}
//
//				// clean up after wards
//				spawner delete();
//
//}
// ---------------------//
// 06-24-08
// wwilliams
// controls the second shooter on the stair case
//second_stair_shooter()
//{
//				// endon
//
//				// objects to be defined for this function
//				// spawner
//				spawner = getent( "spwn_2nd_stair_shot", "targetname" );
//				// node
//				nod_shoot = GetNode( "nod_2nd_stair_shot", "targetname" );
//				// trig
//				trig = getent( "trig_start_carlos", "targetname" );
//				// undefined
//				ent_temp = undefined;
//
//				// double check defines
//				assertex( isdefined( spawner ), "second_shot spawner fail" );
//				assertex( isdefined( nod_shoot ), "second_shot node fail" );
//				assertex( isdefined( trig ), "second_shot trig fail" );
//
//				// wait for the trig
//				trig waittill( "trigger" );
//
//				// spawn out the guy
//				ent_temp = spawner stalingradspawn( "e5_stair_shooter" );
//
//				// make sure the spawn didn't fail
//				if( maps\_utility::spawn_failed( ent_temp ) )
//				{
//								// debug text
//								iprintlnbold( "second_shot NPC fail spawn" );
//
//								// wait
//								wait( 5.0 );
//
//								// end function
//								return;
//				}
//
//				// extra endon added late
//				ent_temp endon( "death" );
//
//				if( isalive( ent_temp ) )
//				{
//								// send him to his node
//								ent_temp setgoalnode( nod_shoot );
//
//								// give shooter perfect sense
//								ent_temp SetPerfectSense( true );
//
//								// might need an extra layer
//				}
//
//				// clean up
//				spawner delete();
//
//}
// ---------------------//
// 06-28-08
// wwilliams
// controls the second shooter on the stair case
//third_stair_shooter()
//{
//				// endon
//
//				// objects to be defined for this function
//				// spawner
//				spawner = getent( "spwn_3rd_stair_shot", "targetname" );
//				// node
//				nod_shoot = GetNode( "nod_3rd_stair_shot", "targetname" );
//				// trig
//				trig = getent( "ent_run_from_three", "targetname" );
//				// undefined
//				ent_temp = undefined;
//
//				// double check defines
//				assertex( isdefined( spawner ), "third_shot spawner fail" );
//				assertex( isdefined( nod_shoot ), "third_shot node fail" );
//				assertex( isdefined( trig ), "third_shot trig fail" );
//
//				// wait for the trig
//				trig waittill( "trigger" );
//
//				// spawn out the guy
//				ent_temp = spawner stalingradspawn( "e5_stair_shooter" );
//
//				// make sure the spawn didn't fail
//				if( maps\_utility::spawn_failed( ent_temp ) )
//				{
//								// debug text
//								iprintlnbold( "third_shot NPC fail spawn" );
//
//								// wait
//								wait( 5.0 );
//
//								// end function
//								return;
//				}
//
//				// extra endon added late
//				ent_temp endon( "death" );
//
//				if( isalive( ent_temp ) )
//				{
//								// send him to his node
//								ent_temp setgoalnode( nod_shoot );
//
//								// give shooter perfect sense
//								ent_temp SetPerfectSense( true );
//
//								// wait for goal
//								ent_temp waittill( "goal" );
//
//								// change stance
//								ent_temp allowedstances( "crouch" );
//				}
//
//				// clean up
//				spawner delete();
//
//}
// ---------------------//

///////////////////////////////////////////////////////////////////////////
// HANGAR PIP
///////////////////////////////////////////////////////////////////////////
// split screen for hangar

split_screen()
{
	level notify("checkpoint_reached"); // checkpoint 9
	wait(1.0);

	level.player freezecontrols(true);
	thread letterbox_on();
	//change cam
	main_camera();
	level.player freezecontrols(false);
	letterbox_off();
}

main_camera()
{
	// objects to define
	hangar_cam = getent( "cam_hangar", "targetname" );
	track_ent = spawn("script_origin", level.carlos.origin);
	target_node1 = getnode("nod_carlos_one", "targetname");
	target_node2 = getnode("nod_carlos_wins", "targetname");

	//turn off camera collision
	level.player customcamera_checkcollisions( 0 );

	server_cam = level.player customCamera_Push( "entity", hangar_cam, track_ent, ( 8.43, 2.71, 28.11 ), ( -3.13, -1.30, 0 ), 0.0 );
	level notify("end_ambush_start");

	track_ent moveto(target_node1.origin, 4.0);
	track_ent waittill("movedone");
	track_ent moveto(target_node2.origin, 4.0);
	track_ent waittill("movedone");
	track_ent delete();

	//wait(6);

	//back to player
	level.player customCamera_pop( server_cam, 0 );

	//turn on camera collision
	level.player customcamera_checkcollisions( 1 );

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

}

//pip
second_move()
{
	//moved earlier. will crash unless set up right away - bug?
	//setup pip camera
	level.player setsecuritycameraparams( 65, 3/4 );
	wait(0.05);	//need this or it will crash
	cameraID_hack = level.player securityCustomCamera_Push( "entity", level.player, level.player, ( -50, -40, 77), ( -32, -7, 0), 0.1);

	//setup PIP
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
	level.player animatepip( 10, 0, 0.6, -0.5, .36, .5, .35, .5);

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
