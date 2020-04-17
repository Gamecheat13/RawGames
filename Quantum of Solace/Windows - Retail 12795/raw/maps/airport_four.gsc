// Airport event four file
// Builder: Brian Glines
// Scritper: Walter Williams
// Created: 10-08-2007

// Includes
#include maps\_utility;
#include maps\airport_util;

main()
{

	// save progression
	// savegame( "airport" );
	//level maps\_autosave::autosave_now( "airport" );

	// start the luggage moving
	// 03-28-08
	// wwilliams
	// commenting out the chair throw event trying to fix a script memory overuse
	// too many strings in use for the system
	level thread luggage_init();

	// 08-06-08 WWilliams
	// hide the off version of the light at teh gdoor
	level thread gdoor_light_flicker_hide();

	// setup the explosive panels
	// 04-10-08
	// this is all done through the destructible system now
	// level thread maps\airport_util::air_explo_panel_init();

	// guys who spot bond near the luggage room
	level thread e4_luggage_warning();

	// grabs all the trigs that spawn out the guys
	// level thread e4_block_out_populate();

	// 02-25-08
	// first set of guys from the right when entering the first luggage fighting area
	level thread e4_luggage_fight_group_one();

	wait ( 2.0 );

	// 06-26-08
	// wwilliams
	// new functions for each guy who covers fight two NPCS
	level thread e4_f2_left_cover_init();
	level thread e4_f2_right_cover_init();

	// 02-27-08
	// second set of enemies in the luggage room
	// 06-26-08
	// changes to this function
	level thread e4_luggage_f2_init();

	// 03-29-08
	// wwilliams
	// look at event before the drop down, should add other events to this
	// 06-19-08
	// wwilliams
	// this function will change from a van to a plane
	// level thread lugg2_lookat_layer();

	// wwilliams 11-28-07
	// causes the explosion to the second catwalk of the 2nd luggage area
	level thread e4_r2_catwalk_explosion();

	// glass shatter event when player gets close to teh area
	// set up the guy who shoots through the window
	level thread e4_window_shooter();

	// 06-25-08
	// wwilliams
	// makes a guy run into lugg2
	// supposed to draw the player's attention
	level thread e4_lead_into_lugg2();

	// 03-18-08
	// wwilliams
	// call for second retreat
	// level thread second_luggage_retreat();

	// 03-20-08
	// wwilliams
	// first fight of lugg3 spawn
	level thread e4_luggage_fight_group_four();

	// 03-20-08
	// wwilliams
	// lugg3 cateqalk spawn
	level thread lugg3_catwalk_left();
	level thread lugg3_catwalk_right();

	// 03-24-08
	// fight five of luggage room
	level thread e4_luggage_fight_group_five();


	// forklift explosion
	// 11-26-07 wwilliams
	// changing this call to the setup func
	//level thread e4_forklift_explosion();
	level thread forklift_explo_setup();

	// the slam cam for the last area
	level thread e4_slam_cam();

	// this makes the lugg3 left flank route light flicker
	level thread e4_light_blinking();

	// 03-24-08
	// wwilliams
	// explosion mousetrap at the end of airport
	level thread e4_fence_explosion();

	// 06-19-08
	// wwilliams
	// function to control the garage door opening
	// need to start it here so the model is set up without the player seeing
	// it
	level thread maps\airport_five::e5_button_open_gdoors();

	level waittill( "airport_four_done" );



}
// ---------------------//
quick_end()
{
	// endon

	// stuff
	//trig = getent( "e4_end_airport", "targetname" );

	// trig waittill( "trigger" );

	//objective_state( 4, "done" );

	// thread off the function that makes the last three rushers
	level thread e4_last_three();

	// 04-08-08
	// wwilliams
	// checking to make sure all the enemies for lugg3 are taken care of
	enta_lugg3_enemies = getaiarray();

	// while loop keeps checking for every NPC to be dead
	while( enta_lugg3_enemies.size > 0 )
	{
		// wait
		wait( 1.0 );

		// remove dead from the array
		enta_lugg3_enemies = level maps\_utility::array_removedead( enta_lugg3_enemies );

		// wait
		wait( 1.0 );

	}

	// once the script comes out of the while loop then the event ends
	level notify( "airport_four_done" );

	//Ending music after all guys are killed - added by chuck russom		
	level notify("endmusicpackage");

	//missionsuccess( "airport_rail", false, 1.0 );

}
// ---------------------//
// 04-13-08
// wwilliams
// if less than three guys left make them rushers
// this way if the player can not find them
// they will find the player
e4_last_three()
{
	// endon
	// single shot, not needed

	// define the objects needed for this function
	// enta
	enta_luggage_enemies = getaiarray();

	// frame wait
	wait( 0.05 );

	// check to see if the guy is more than two thousand units away
	for( i=0; i<enta_luggage_enemies.size; i++ )
	{
		// check to see if each guy is within two thousand units
		if( distancesquared( enta_luggage_enemies[i].origin, level.player.origin ) > 2000*2000 )
		{
			// hide him
			enta_luggage_enemies[i] hide();

			// kill him
			enta_luggage_enemies[i] dodamage( enta_luggage_enemies[i].health + 500, enta_luggage_enemies[i].origin );

		}
	}

	// keep checking the array until there are three or less guys
	while( enta_luggage_enemies.size > 3 )
	{
		// remove dead from the array
		enta_luggage_enemies = level maps\_utility::array_removedead( enta_luggage_enemies );

		// wait a second
		wait( 1.0 );
	}

	// once out of that loop make the last people rushers
	for( i=0; i<enta_luggage_enemies.size; i++ )
	{
		// check to see if the guy is alive
		if( isalive( enta_luggage_enemies[i] ) )
		{
			// make him a rusher
			enta_luggage_enemies[i] SetCombatRole( "rusher" );

			// frame wait
			enta_luggage_enemies[i] waittill( "death" );
		}
	}

}
// ---------------------//
// wwilliams 10-25-07
// sets up the two guys that spot bond coming out of the server room
e4_luggage_warning()
{
	// grab all ai that are currently alive right now, so we can delete later
	maps\airport_util::grab_all_current_ai();

	// endon

	// objects to be defined for the function
	// spawner
	spawner_warn = getent( "spwn_e4_warn_retreat", "targetname" );
	// undefined
	ent_warn_luggage = undefined;

	// spawn him out
	ent_warn_luggage = spawner_warn stalingradspawn( "e4_warn" );
	if( !maps\_utility::spawn_failed( ent_warn_luggage ) )
	{
		// run the function that makes him a shadowy figure
		ent_warn_luggage thread e4_warn_retreat();
	}
	else
	{
		//iprintlnbold( "shadowy_figure_fail" );
		return;
	}

	// clean up function
	spawner_warn delete();
	ent_warn_luggage = undefined;
}
// ---------------------//
// 02-12-08
// wwilliams
// function to grab the enemies in the diagonal room
// then makes them retreat to certain nodes in the end area
// runs on level
// 03-18-08
// wwilliams
// changed this function to grab all teh guys and then make them fall back when the player
// gets farther down the area
second_luggage_retreat()
{
	// endon
	// not needed cause this has to happen

	// define the objects needed for this function
	// tether node
	nod_tether_3 = getnode( "nod_luggage_tether_3", "targetname" );
	// trigs
	trig_start_retreat = getent( "trig_start_2nd_retreat", "targetname" );
	// entity_array
	enta_lugg2_enemies = getentarray( "e4_lugg2_enemy", "targetname" );

	// go through the array and remove all the spawners, this should return a array with only ai in it
	enta_lugg2_enemies = level maps\airport_util::only_ai_in_array( enta_lugg2_enemies );

	// wait for the trigger to be hit
	trig_start_retreat waittill( "trigger" );

	// remove the dead from the array
	enta_lugg2_enemies = level maps\_utility::array_removedead( enta_lugg2_enemies );

	// set the tether function on each guy
	for( i=0; i<enta_lugg2_enemies.size; i++ )
	{
		// do a double check to see if the guy is now alive, 
		// this is in case the player kills a guy deep in the array
		if( isalive( enta_lugg2_enemies[i] ) )
		{
			// set the tether function on the guy
			enta_lugg2_enemies[i] settetherradius( 1750 );

			// will need a tether function for these guy to move down the map
			enta_lugg2_enemies[i].tetherpt = nod_tether_3.origin;

			// use the tether function stolen from mmailhot
			enta_lugg2_enemies[i] thread luggage_room_active_tether( 512, 1750, 256 );
		}

		// quick wait
		wait( 0.05 );

	}
}
// ---------------------//


// ---------------------//
// 02-12-08
// wwilliams
// modified this function work with the shadowy figure principle from AdamG 
// runs on self
e4_warn_retreat()
{
	//endon
	self endon( "death" );

	// objects to be defined
	// trigs
	trig_run_from_spot_1 = getent( "trig_e4_warn_run", "targetname" );
	trig_run_from_spot_2 = getent( "trig_run_from_point_2", "targetname" );
	trig_start_shooting_at_player = getent( "trig_lug1_fight_wait", "targetname" );
	// nodes
	nod_point_one = getnode( "nod_e4_shadowy_fig_1", "targetname" );
	nod_point_two = getnode( "nod_e4_shadowy_fig_2", "targetname" );
	nod_point_three = getnode( "nod_e4_shadowy_fig_3", "targetname" );
	nod_tether = getnode( "nod_luggage_tether_1", "targetname" );


	// changes guy's settings
	// 02-21-08
	// wwilliams
	// stop tweaking ai
	// self setenablesense( false );
	self LockAlertState( "alert_red" );
	self SetScriptSpeed( "sprint" );

	// sne him to spot 2
	self setgoalnode( nod_point_two );

	// wait for next trigger
	trig_run_from_spot_2 waittill( "trigger" );

	// frame wait, sound it tripping for some reason
	wait( 0.05 );

	// turn on sense for the guy to shoot at the player
	self thread turn_on_sense();

	// run to the last node in teh luggage area
	self setgoalnode( nod_point_three, 1 );

	// make him talk
	// iprintlnbold( "Merc:Here he comes!" );
	// dialogue hook
	self maps\_utility::play_dialogue_nowait( "GRM2_AirpG_024A" );

	//Music for the first luggage area - added by chuck russom		
	level notify("playmusicpackage_luggage_01");

	// 02-25-08
	// wait for the player to hit the trigger
	trig_start_shooting_at_player waittill( "trigger" );

	// turn on sense for the guy to shoot at the player
	self thread turn_on_sense();

	// put his speed back to normal
	self setscriptspeed( "default" );

	// 02-25-08
	// make the 
	// self cmdshootatentity( level.player, true, 5, 1 );

	// give him a combat role
	self setcombatrole( "guardian" );

	// will need a tether function for these guy to move down the map
	self.tetherpt = nod_tether.origin;

	// use the tether function stolen from mmailhot
	self thread luggage_room_active_tether( 384, 1024, 256 );

}
// ---------------------//
// wwilliams 11-26-07
// making a array grab func for all teh forklifts in the end area
// runs the explosion function on the script_model of the forklift
forklift_explo_setup()
{
	// endon

	// grab all the forklifts
	triga_dmg_forklift = getentarray( "trg_dmg_forklift", "targetname" );

	// now run the explosion function on each of them
	for( i=0; i<triga_dmg_forklift.size; i++ )
	{
		// thread the function on each one
		triga_dmg_forklift[i] thread e4_forklift_explosion();
		// quick wait just in case
		wait( 0.1 );
	}

	// debug text so i know it finished
	//iprintlnbold( "all_forklifts_setup" );
}
// ---------------------//
// wwilliams 11-9-07
// temp forklift explosion
// wwilliams 11-26-07
// changing func to work with an indivdual piece from the array of forklifts
// will run on the forklift
e4_forklift_explosion()
{
	// endon

	// stuff
	forklift_model = getent( self.target, "targetname" );
	forklift_model_dmg = getent( forklift_model.target, "targetname" );

	// hide the destroyed version of the forklift
	forklift_model_dmg hide();

	// 03-28-08
	// wwilliams
	// while loop will continue until the damage is from teh player
	while( 1 )
	{
		// trig hit
		// self waittill( "trigger" );
		self waittill( "damage", amount, attacker, direction_vec, point, type );

		// check to see if attacker = level.player
		if( attacker == level.player )
		{
			// kick out of this function
			break;
		}
		else
		{
			// quick wait
			wait( 0.5 );
		}
	}

	// explosion FX
	forklift_explo = playfx( level._effect[ "f_explosion" ], forklift_model.origin );

	// explosion SFX, forklift explodes
	self playsound( "AIR_forklift_explo_sound" );

	// damage radius to the area
	radiusdamage( forklift_model.origin, 300, 600, 200 );

	// earthquake
	earthquake( 0.5, 2.0, forklift_model.origin, 850 );

	// controller rumble
	level thread maps\airport_util::air_ctrl_rumble_timer( 1 );

	// quick wait for the effect to fill the area
	wait( 0.08 );

	// swap out for the destroyed model of the forklift
	forklift_model hide();
	forklift_model_dmg show();
}
// ---------------------//
// wwilliams 11-9-07
// guy shoots through the window when Bond gets close
e4_window_shooter()
{
	// stuff
	spawner = getent( "spwn_e4_window_shooter", "targetname" );
	shooter_node = getnode( "nod_e4_glass_break", "targetname" );
	ent_shoot_at = getent( "ent_window_shoot_spot", "targetname" );
	trig_start_shooting = getent( "trig_shoot_through_window", "targetname" );
	nod_after_shooting = getnode( "nod_shooter_destin", "targetname" );
	nod_tether = getnode( "nod_luggage_tether_1", "targetname" );

	// spawn the guy out
	e4_window_shooter = spawner stalingradspawn( "e4_shooter" );
	if( !maps\_utility::spawn_failed( e4_window_shooter ) )
	{
		wait( 0.1 );

		// make him get into position fast
		e4_window_shooter SetScriptSpeed( "Run" );

		// turn his sense off
		e4_window_shooter setenablesense( false );

		// send him to the node
		e4_window_shooter setgoalnode( shooter_node );

		//endon
		e4_window_shooter endon( "death" );

		// send him to the node to wait
		e4_window_shooter waittill( "goal" );
	}

	// 03-12-08
	// wwilliams
	// threading the function that causes the fire extinguisher to react
	level thread e4_extra_layer_for_shooter();

	// wait for the player to hit the trigger
	trig_start_shooting waittill( "trigger" );

	// thread moving the target
	ent_shoot_at thread e4_move_window_shooter_target();

	// shoot through the window
	e4_window_shooter cmdshootatentity( ent_shoot_at, true, 5, 1 );

	wait( 5.0 );

	// notify moving function to end
	level notify( "e4_shooter_done" );

	// reset this ai to normal values
	e4_window_shooter setenablesense( true );
	e4_window_shooter lockalertstate( "alert_red" );

	// send him to his node after he's done shooting
	e4_window_shooter setgoalnode( nod_after_shooting );

	// tether him like the rest
	// will need a tether function for these guy to move down the map
	// e4_window_shooter.tetherpt = nod_tether.origin;

	// use the tether function stolen from mmailhot
	// e4_window_shooter thread luggage_room_active_tether( 384, 900, 64 );
	e4_window_shooter thread give_tether_at_goal( nod_after_shooting, 384, 900, 64 );

	// delete the script origin
	ent_shoot_at delete();

	// delete the spawner
	spawner delete();

}
// ---------------------//
// 03-12-08
// wwilliams
// this is another layer for the guy shooting through the window
// a large dmg_trig waits for the guy to hit it, 
// the trig, targetting a fire extinguisher, will cause the extinguisher to
// fall and react, causing the mousetrap to startle the player
e4_extra_layer_for_shooter()
{
	// endon
	// single shot function, uneeded

	// double check everything is valid
	// assertex( isdefined( guy ), "guy in e4_extra_layer_for_shooter not defined!" );

	// objects to be defined for the function
	trig_damage_from_shooter = getent( "trig_extra_layer_for_shooter_moment", "targetname" );
	// ent_fire_ext = getent( trig_damage_from_shooter.target, "targetname" );

	// wait for the dmg trig
	trig_damage_from_shooter waittill( "trigger" );

	// dodamage to the point where the fire extinguisher is
	radiusdamage( ( -1630, 3172, 169 ), 12, 80, 75 );

}
// ---------------------//
// wwilliams 12-04-07
// sound effects needs in the luggage rooms
/*luggage_sounds()
{
// conveyor sounds, running
level.player playsound( "AIR_conveyors_running" );

// pipe creak, hints at deadpan mouse trap
level.player playsound( "AIR_pipe_creak" );

// deadpan catwalk destruction, pipe is shot, falls and takes out a catwalk
level.player playsound( "AIR_pipe_crash_catwalk" );

// player shoots explosive tanks, destroys second catwalk
level.player playsound( "AIR_catwalk_explo_sound" );

// plane flies over the area
level.player playsound( "AIR_airplane_fly_over" );

// helicopter flies over head
level.player playsound( "AIR_heli_fly_over" );

}*/
// ---------------------//
// wwilliams 11-10-07
// move the ent that shooter npc is firing at
e4_move_window_shooter_target()
{
	// endon
	level endon( "e4_shooter_done" );

	// movement vectors
	first_spot = self.origin;

	while( 1 )
	{
		// move from first to second
		self movex( -272, 3.0 );
		self waittill( "movedone" );

		// move from second to first
		self movex( 272, 3.0 );
		self waittill( "movedone" );
	}
}
// ---------------------//
// 02-22-08
// wwilliams
// function spawns out the guys who will run to the first part of the luggage room fight
e4_luggage_fight_group_one()	

{
	// endons

	// objects to be defined for this function
	trig_prepare = getent( "trig_lug1_fight_wait", "targetname" );
	// trig_go_fight = getent( "trig_luggage_fight_one", "targetname" );
	spawner = getent( trig_prepare.target, "targetname" );
	noda_dest = getnodearray( spawner.script_parameters, "targetname" );
	nod_wait = getnode( "nod_lug1_wait", "targetname" );
	nod_tether = getnode( "nod_luggage_tether_1", "targetname" );
	enta_lug1_enemies = [];
	ent_temp = undefined;


	// make sure the spawner has a high enough count
	spawner.count = noda_dest.size;

	// wait for the player to hit the prepare trigger
	trig_prepare waittill( "trigger" );

	// clean up old ai, that we grabbed earlier
	thread maps\airport_util::delete_level_aiarray();


	// prepare the guys
	for( i=0; i<noda_dest.size; i++ )
	{
		// spawn out a gun
		ent_temp = spawner stalingradspawn( "e4_wave_1" );
		// make sure the guy spawned out
		if( maps\_utility::spawn_failed( ent_temp ) )
		{
			// report out the problem the level encountered
			//iprintlnbold( "e4_group_one_fail" );

			// end function
			return;
		}

		// lock the guy to alert red
		ent_temp setalertstatemin( "alert_red" );

		// make sure the node has a script_string
		if( !isdefined( noda_dest[i].script_string ) )
		{
			// debug text
			//iprintlnbold( "group one noda_dest[i], missing script_string" );

			// end function
			return;
		}

		// give momentary perfect sense
		ent_temp thread turn_on_sense( 3 );

		//// make the even guy fire at the player while going to position
		//if( ( i + 1 ) % 2 == 0 )
		//{
		// send the guy out to the node
		ent_temp setgoalnode( noda_dest[i], 1 );
		//}
		//// an odd guy will not shoot at the player while moving
		//else
		//{
		//				// send the guy out to the node
		//				ent_temp setgoalnode( noda_dest[i] );
		//}

		// function makes the guy sprint until he is at goal
		ent_temp thread maps\airport_util::sprint_to_goal();

		// thread off the function for combat role
		ent_temp thread combat_role_on_goal( noda_dest[i].script_string );

		// make sure the guy isn't a rusher
		if( noda_dest[i].script_string != "rusher" )
		{
			ent_temp thread give_tether_at_goal( nod_tether, 384, 900, 256 );
		}

		// add them to the array to move them after the player hits the trigger
		enta_lug1_enemies = maps\_utility::array_add( enta_lug1_enemies, ent_temp );

		// quick wait so guys don't spawn on top of each other
		wait( 0.2 );

		// clean up ent_temp
		ent_temp = undefined;
	}

	// wait so it doesn't happen right away
	wait( 5.0 );

	// clean up function
	spawner delete();
}
// ---------------------//
// 02-27-08
// wwilliams
// function controls the second set of guys that spawn out in the
// first luggage room fight
e4_luggage_f2_init()
{
	// endon
	// single shot func

	// objects to define for this function
	// trig
	trig_spawn_enemies = getent( "trig_e4_lug2_fight", "targetname" );
	trig_second_tether = getent( "trig_f2_tether2", "targetname" );
	// spawner
	spawner_a = getent( "spwn_lugg1_f2_group_a", "targetname" );
	spawner_b = getent( "spwn_lugg1_f2_group_b", "targetname" );
	// nodes
	nod_tether_1 = getnode( "nod_luggage_tether_1", "targetname" );
	nod_tether_2 = getnode( "nod_luggage_tether_2", "targetname" );
	noda_spwn_a_nodes = getnodearray( spawner_a.script_parameters, "targetname" );
	noda_spwn_b_nodes = getnodearray( spawner_b.script_parameters, "targetname" );
	// undefined
	ent_temp = undefined;

	// double check defines
	assertex( isdefined( trig_spawn_enemies ) , "trig_spawn_enemies not defined" );
	assertex( isdefined( trig_second_tether ) , "trig_second_tether not defined" );
	assertex( isdefined( spawner_a ) , "spawner_a not defined" );
	assertex( isdefined( spawner_b ) , "spawner_b not defined" );
	assertex( isdefined( nod_tether_1 ) , "nod_tether_1 not defined" );
	assertex( isdefined( nod_tether_2 ) , "nod_tether_2 not defined" );
	assertex( isdefined( noda_spwn_a_nodes ) , "noda_spwn_a_nodes not defined" );
	assertex( isdefined( noda_spwn_b_nodes ) , "noda_spwn_b_nodes not defined" );

	// make sure the spawners have enough count
	spawner_a.count = noda_spwn_a_nodes.size;
	spawner_b.count = noda_spwn_b_nodes.size;

	// wait for the trigger to hit
	trig_spawn_enemies waittill( "trigger" );

	///////////////////////////////////////////////////////////////////////////
	///// GROUP A
	///////////////////////////////////////////////////////////////////////////
	// spawn out group a
	for( i=0; i<noda_spwn_a_nodes.size; i++ )
	{
		// spawn out a guy
		ent_temp = spawner_a stalingradspawn( "lugg1_enemy" );

		// check to see if the guy failed
		if( spawn_failed( ent_temp ) )
		{
			// debug text
			//iprintlnbold( "e4_luggage_f2_init fail spawn" );

			// end function
			return;
		}

		// guy spawned properly, send him off
		ent_temp setgoalnode( noda_spwn_a_nodes[i] );

		// lock his alert state to red
		ent_temp lockalertstate( "alert_red" );

		// change speed for postitioning
		ent_temp setscriptSpeed( "sprint" );

		// give him a few seconds of perfect sense
		ent_temp thread turn_on_sense( 5 );

		// check i and give the guy the correct setup
		// if 0 make him a rusher
		if( i == 0 )
		{
			// setcombat role to rusher
			ent_temp setcombatrole( "rusher" );

			// no tether func on rusher
		}
		else if( i == 1 )
		{
			// set combat role to flanker
			ent_temp setcombatrole( "flanker" );

			// make him sprint to goal
			ent_temp thread sprint_to_goal();

			// give him the tether function
			ent_temp thread give_tether_at_goal( nod_tether_1, 384, 900, 256 );

			// switch tether when the player gets too close
			ent_temp thread e4_f2_enemy_setup( trig_second_tether, nod_tether_2 );
		}
		else if( i == 2 )
		{
			// set combat role to guardian
			ent_temp setcombatrole( "guardian" );

			// make him sprint to goal
			ent_temp thread sprint_to_goal();

			// tether function
			ent_temp thread give_tether_at_goal( nod_tether_1, 384, 900, 256 );

			// switch tether when the player gets too close
			ent_temp thread e4_f2_enemy_setup( trig_second_tether, nod_tether_2 );
		}
		else
		{
			// set combat role to basic
			ent_temp setcombatrole( "flanker" );

			// make him sprint to goal
			ent_temp thread sprint_to_goal();

			// tether function
			ent_temp thread give_tether_at_goal( nod_tether_1, 384, 900, 256 );

			// switch tether when the player gets too close
			ent_temp thread e4_f2_enemy_setup( trig_second_tether, nod_tether_2 );
		}	

		// wait keeps guys from spawning on top of each other
		wait( 0.7 );

		// undefine
		ent_temp = undefined;
	}
	///////////////////////////////////////////////////////////////////////////
	///// GROUP A END
	///////////////////////////////////////////////////////////////////////////

	// wait to spawn out group two
	wait( 1.0 );

	///////////////////////////////////////////////////////////////////////////
	///// GROUP B
	///////////////////////////////////////////////////////////////////////////
	// spawn out group b
	for( i=0; i<noda_spwn_b_nodes.size; i++ )
	{
		// spawn out a guy
		ent_temp = spawner_b stalingradspawn( "lugg1_enemy" );

		// check to see if the guy failed
		if( spawn_failed( ent_temp ) )
		{
			// debug text
			//iprintlnbold( "e4_luggage_f2_init group b fail spawn" );

			// end function
			return;
		}

		// guy spawned properly, send him off
		ent_temp setgoalnode( noda_spwn_b_nodes[i] );

		// lock his alert state to red
		ent_temp lockalertstate( "alert_red" );

		// change speed for postitioning
		ent_temp setscriptSpeed( "sprint" );

		// give him a few seconds of perfect sense
		ent_temp thread turn_on_sense( 5 );

		// check i and give the guy the correct setup
		// if 0 make him a rusher
		if( i == 0 )
		{
			// setcombat role to rusher
			ent_temp setcombatrole( "rusher" );

			// no tether func on rusher
		}
		else if( i == 1 )
		{
			// set combat role to flanker
			ent_temp setcombatrole( "flanker" );

			// make him sprint to goal
			ent_temp thread sprint_to_goal();

			// give him the tether function
			ent_temp thread give_tether_at_goal( nod_tether_1, 384, 900, 256 );

			// switch tether when the player gets too close
			ent_temp thread e4_f2_enemy_setup( trig_second_tether, nod_tether_2 );
		}
		else if( i == 2 )
		{
			// set combat role to guardian
			ent_temp setcombatrole( "guardian" );

			// make him sprint to goal
			ent_temp thread sprint_to_goal();

			// tether function
			ent_temp thread give_tether_at_goal( nod_tether_1, 384, 900, 256 );

			// switch tether when the player gets too close
			ent_temp thread e4_f2_enemy_setup( trig_second_tether, nod_tether_2 );
		}
		else
		{
			// set combat role to basic
			ent_temp setcombatrole( "flanker" );

			// make him sprint to goal
			ent_temp thread sprint_to_goal();

			// tether function
			ent_temp thread give_tether_at_goal( nod_tether_1, 384, 900, 256 );

			// switch tether when the player gets too close
			ent_temp thread e4_f2_enemy_setup( trig_second_tether, nod_tether_2 );
		}	

		// wait keeps guys from spawning on top of each other
		wait( 0.7 );

		// clear ent_temp
		ent_temp = undefined;
	}

	///////////////////////////////////////////////////////////////////////////
	///// GROUP B END
	///////////////////////////////////////////////////////////////////////////

	// clean up the function
	spawner_a delete();
	spawner_b delete();
	ent_temp = undefined;

}
// ---------------------//
// 06-26-08
// wwilliams 
// change tether points
e4_f2_enemy_setup( trig_tether_2, nod_tether_2 )
{
	// endon
	self endon( "death" );

	// double check passed in variables
	assertex( isdefined( trig_tether_2 ), "trig_tether_2 not defined" );
	assertex( isdefined( nod_tether_2 ), "nod_tether_2 not defined" );

	// wait for the trigger hit
	trig_tether_2 waittill( "trigger" );

	// change tether
	self.tetherpt = nod_tether_2.origin;
}
// ---------------------//
// 06-25-08
// wwilliams
// set up the cover guy for the left of f2
e4_f2_left_cover_init()
{
	// endon
	// single shot function, no need for a endon

	// objects to define for the function
	// trigs
	trig_start = getent( "trig_run_from_point_2", "targetname" );
	// ents
	spawner = getent( "spwn_e4_f2_left", "targetname" );
	// undefined
	ent_temp = undefined;

	// double check the defines
	assertex( isdefined( trig_start ), "trig_start not defined" );
	assertex( isdefined( spawner ), "spawner not defined" );

	// make sure the spawner has the right count
	spawner.count = 1;

	// wait for the trigger to hit
	trig_start waittill( "trigger" );

	// spawn out the guy
	ent_temp = spawner stalingradspawn( "e4_enemy" );

	// check to make sure spawn passed
	if( spawn_failed( ent_temp ) )
	{
		// debug text
		//iprintlnbold( "e4_f2_left_cover_init fail spawn" );

		// wait
		wait( 2.0 );

		// end func
		return;
	}
	else
	{
		// thread the control func on the guy
		ent_temp thread e4_f2_left_shooter();
	}

	// wait to make sure the guy has left the spawner
	wait( 2.0 );

	// clean up
	ent_temp = undefined;
	spawner delete();

}
// ---------------------//
// 06-25-08
// wwilliams
// controls the left shot guy who covers fight 2 populate
// runs on the guy
e4_f2_left_shooter()
{
	// endon
	self endon( "death" );

	// trigger
	trig_fire = getent( "trig_e4_lug2_fight", "targetname" );
	trig_tether = getent( "trig_f2_tether2", "targetname" );
	// nodes
	nod_shoot = GetNode( "nod_e4_f2_lshot", "targetname" );
	nod_2nd_tether = getnode( "nod_luggage_tether_2", "targetname" );

	// double check defined
	assertex( isdefined( trig_fire ), "trig_fire not defined" );
	assertex( isdefined( trig_tether ), "trig_tether not defined" );
	assertex( isdefined( nod_shoot ), "nod_shoot not defined" );
	assertex( isdefined( nod_2nd_tether ), "nod_2nd_tether not defined" );

	// turn off the guy until it is time
	self SetEnableSense( false );

	// set his combatrole
	self SetCombatRole( "turret" );

	// thread off the attack sense change
	self thread dmg_turn_sense_on();

	// set his alert state
	self lockalertstate( "alert_red" );

	// send him to his first node
	self setgoalnode( nod_shoot );

	// wait for him to get there
	self waittill( "goal" );

	// make him crouch
	self allowedstances( "crouch" );

	// tether him to this node
	self.tetherpt = nod_shoot.origin;
	self.tetherradius = 32;

	// wait for the player to hit the trig
	trig_fire waittill( "trigger" );

	// turn off dmg_turn_sense_on
	self notify( "sense_on" );

	// turn on the guy 
	self SetEnableSense( true );

	// give him back normal stances
	self allowedstances( "stand", "crouch" );

	// turn on perfect sense momentarily
	self thread turn_on_sense( 5 );

	// shoot at the player
	self cmdshootatentity( level.player, true, 5, 0.75  );

	// wait here until the player hits the tether trigger
	trig_tether waittill( "trigger" );

	// change the combat role
	self setcombatrole( "guardian" );

	// change the tether
	self.tetherpt = nod_2nd_tether.origin;
	// self.tetherradius = 32;
	self luggage_room_active_tether( 384, 1400, 256 );


}
// ---------------------//
// 06-25-08
// wwilliams
// set up the cover guy for the left of f2
e4_f2_right_cover_init()
{
	// endon
	// single shot function, no need for a endon

	// objects to define for the function
	// trigs
	trig_start = getent( "trig_run_from_point_2", "targetname" );
	// ents
	spawner = getent( "spwn_e4_f2_right", "targetname" );
	// undefined
	ent_temp = undefined;

	// double check the defines
	assertex( isdefined( trig_start ), "trig_start not defined" );
	assertex( isdefined( spawner ), "spawner not defined" );

	// make sure the spawner has the right count
	spawner.count = 1;

	// wait for the trigger to hit
	trig_start waittill( "trigger" );

	// spawn out the guy
	ent_temp = spawner stalingradspawn( "e4_enemy" );

	// check to make sure spawn passed
	if( spawn_failed( ent_temp ) )
	{
		// debug text
		//iprintlnbold( "e4_f2_right_cover_init fail spawn" );

		// wait
		wait( 2.0 );

		// end func
		return;
	}
	else
	{
		// thread the control func on the guy
		ent_temp thread e4_f2_right_shooter();
	}

	// wait to make sure the guy has left the spawner
	wait( 2.0 );

	// clean up
	ent_temp = undefined;
	spawner delete();
}
// ---------------------//
// 06-25-08
// wwilliams
// controls the left shot guy who covers fight 2 populate
// runs on the guy
e4_f2_right_shooter()
{
	// endon
	self endon( "death" );

	// trigger
	trig_fire = getent( "trig_e4_lug2_fight", "targetname" );
	trig_tether = getent( "trig_f2_tether2", "targetname" );
	// nodes
	nod_shoot = GetNode( "nod_e4_f2_rshot", "targetname" );
	nod_2nd_tether = getnode( "nod_luggage_tether_2", "targetname" );

	// double check defined
	assertex( isdefined( trig_fire ), "trig_fire not defined" );
	assertex( isdefined( trig_tether ), "trig_tether not defined" );
	assertex( isdefined( nod_shoot ), "nod_shoot not defined" );
	assertex( isdefined( nod_2nd_tether ), "nod_2nd_tether not defined" );

	// turn off the guy until it is time
	self SetEnableSense( false );

	// thread off the attack sense change
	self thread dmg_turn_sense_on();

	// set his alert state
	self lockalertstate( "alert_red" );

	// set his combatrole
	self SetCombatRole( "turret" );

	// send him to his first node
	self setgoalnode( nod_shoot );

	// wait for him to get there
	self waittill( "goal" );

	// iprintlnbold( "right shoot in place" );

	// make him crouch
	self allowedstances( "crouch" );

	// tether him to this node
	self.tetherpt = nod_shoot.origin;
	self.tetherradius = 32;

	// wait for the player to hit the trig
	trig_fire waittill( "trigger" );

	// turn off dmg_turn_sense_on
	self notify( "sense_on" );

	// turn on the guy 
	self SetEnableSense( true );

	// make him crouch
	self allowedstances( "stand", "crouch" );

	// turn on perfect sense momentarily
	self thread turn_on_sense( 5 );

	// iprintlnbold( "right shoot shooting" );

	// shoot at the player
	self cmdshootatentity( level.player, true, 5, 0.75  );

	// wait here until the player hits the tether trigger
	trig_tether waittill( "trigger" );

	// iprintlnbold( "right shoot moving" );

	// change the combat role
	self setcombatrole( "guardian" );

	// change the tether
	self.tetherpt = nod_2nd_tether.origin;
	// self.tetherradius = 32;
	self luggage_room_active_tether( 384, 1400, 256 );


}
// ---------------------//

// ---------------------//
// 02-28-08
// wwilliams
// this will start the population of the guys for the who run in as the slam cam returns
// runs on level
// wiil not need a trigger to start the spawning since i will call it when i want it to start
e4_luggage_fight_group_three()
{
	// endon
	// not needed cause this is a single shot

	// objectives to define for this function
	// ents
	ent_van_pulls_up = getent( "ent_lugg2_gdoor_van", "targetname" );
	sbrush_garage_door = getent( "ent_lugg2_garage_door", "targetname" );
	ent_spwn_ground_1 = getent( "ent_e4_g3_grd1", "targetname" );
	ent_spwn_ground_2 = getent( "ent_e4_g3_grd2", "targetname" );
	ent_spwn_cat_1a = getent( "ent_e4_g3_cat1a", "targetname" );
	ent_spwn_cat_1b = getent( "ent_e4_g3_cat1b", "targetname" );
	// trigs
	start_trig = getent( "ent_start_e4_slam", "targetname" );
	// undefines
	ent_temp = undefined;
	// nodes
	noda_dest_ground_1 = getnodearray( ent_spwn_ground_1.script_parameters, "targetname" );
	noda_dest_ground_2 = getnodearray( ent_spwn_ground_2.script_parameters, "targetname" );
	nod_dest_cat_1a = getnode( ent_spwn_cat_1a.script_parameters, "targetname" );
	nod_dest_cat_1b = getnode( ent_spwn_cat_1b.script_parameters, "targetname" );
	vnod_van_start = getvehiclenode( ent_van_pulls_up.target, "targetname" );
	nod_lugg2_tether = getnode( "lugg2_tether", "targetname" );

	// set the counts of the spawners
	ent_spwn_ground_1.count = noda_dest_ground_1.size;
	ent_spwn_ground_2.count = noda_dest_ground_2.size;
	ent_spwn_cat_1a.count = nod_dest_cat_1a.size;
	ent_spwn_cat_1b.count = nod_dest_cat_1b.size;

	// wait for the player to drop in
	start_trig waittill( "trigger" );

	// clean up old ai
	thread maps\airport_util::clean_up_old_ai_except("e4_enemy_jump_fence");

	// send out the notify that turns off the halon threads
	level notify( "e4_halon_off" );

	// this will spawn out the guys on the second catwalk when the player gets far enough down the middle

	//Music change for the second luggage area - added by chuck russom		
	level notify("playmusicpackage_luggage_02");

	level thread e4_luggage_fight_catwalk_2();

	///////////////////////////////////////////////////////////////////////////
	// spawn out right side 1st catwalk enemy
	ent_temp = ent_spwn_cat_1a stalingradspawn( "e4_lugg2_enemy" );
	if( maps\_utility::spawn_failed( ent_temp ) )
	{
		// debug text
		//iprintlnbold( "ent_spwn_cat_1a fail spawn" );

		// end function
		return;
	}
	else
	{
		// set the right alert state on the guys
		ent_temp setalertstatemin( "alert_red" );

		// assign brain type
		ent_temp SetCombatRole( "turret" );

		// give NPC perfect sense for a few seconds
		ent_temp thread turn_on_sense();

		// send the guy out to the node
		ent_temp setgoalnode( nod_dest_cat_1a, 1 );

		// function makes the guy sprint until he is at goal
		ent_temp thread maps\airport_util::sprint_to_goal();
	}

	// wait a frame
	wait( 0.05 );

	// undefine ent_temp
	ent_temp = undefined;

	// delete the spawner
	ent_spwn_cat_1a delete();
	///////////////////////////////////////////////////////////////////////////
	// spawn out the left side 1st catwalk enemy
	// spawn out right side 1st catwalk enemy
	ent_temp = ent_spwn_cat_1b stalingradspawn( "e4_lugg2_enemy" );
	if( maps\_utility::spawn_failed( ent_temp ) )
	{
		// debug text
		//iprintlnbold( "ent_spwn_cat_1b fail spawn" );

		// end function
		return;
	}
	else
	{
		// set the right alert state on the guys
		ent_temp setalertstatemin( "alert_red" );

		// assign brain type
		ent_temp SetCombatRole( "turret" );

		// give NPC perfect sense for a few seconds
		ent_temp thread turn_on_sense();

		// send the guy out to the node
		ent_temp setgoalnode( nod_dest_cat_1b, 1 );

		// function makes the guy sprint until he is at goal
		ent_temp thread maps\airport_util::sprint_to_goal();
	}

	// wait a frame
	wait( 0.05 );

	// undefine ent_temp
	ent_temp = undefined;

	// delete the spawner
	ent_spwn_cat_1b delete();
	///////////////////////////////////////////////////////////////////////////
	// this makes the van pull up
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// flip the vehicle
	ent_van_pulls_up.angles = ( 0, 270, 0 );

	// attach the van to the path
	ent_van_pulls_up attachpath( vnod_van_start );

	// start the path
	ent_van_pulls_up startpath();
	ent_van_pulls_up playsound("van_pull_up");
	//iprintlnbold("SOUND: van pull up");


	// wait for the van to finish
	ent_van_pulls_up waittill( "reached_end_node" );
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////

	// now spawn out the first set of guys
	for( i=0; i<noda_dest_ground_1.size; i++ )
	{
		// spawn out the guy
		ent_temp = ent_spwn_ground_1 stalingradspawn( "e4_lugg2_enemy" );
		if( !maps\_utility::spawn_failed( ent_temp ) )
		{
			// set the right alert state on the guys
			ent_temp setalertstatemin( "alert_red" );

			//// set up the rules for the NPC
			//ent_temp setengagerule( "tgtSight" );
			//ent_temp addengagerule( "tgtPerceive" );
			//ent_temp addengagerule( "Damaged" );
			//ent_temp addengagerule( "Attacked" );

			//// give the NPC perfect sense for a few seconds
			//ent_temp thread turn_on_sense( 3 );

			//// even ai shoot while running
			//if( ( i + 1 ) % 2 == 0 )
			//{
			// set his goal node
			ent_temp setgoalnode( noda_dest_ground_1[i], 1 );
			//}
			//else
			//{
			//				// set his goal node
			//				ent_temp setgoalnode( noda_dest_ground_1[i] );
			//}

			// make sure the node the NPC is going to has a script string
			if( !IsDefined( noda_dest_ground_1[i].script_string ) )
			{
				// debug text
				//IPrintLnBold( "noda_dest_ground_1 missing script_string" );
			}

			if(isdefined( noda_dest_ground_1[i].script_string ) )
			{
				// with a script string set up the Ai to get their combat role
				ent_temp thread combat_role_on_goal( noda_dest_ground_1[i].script_string );

				// function makes the guy sprint until he is at goal
				ent_temp thread maps\airport_util::sprint_to_goal();

				// make sure the guy isn't a rusher
				if( noda_dest_ground_1[i].script_string != "rusher" )
				{
					ent_temp thread give_tether_at_goal( nod_lugg2_tether, 550, 1500, 512 );
				}
			}
			// wait
			wait( 0.7 );

			// undefined ent_temp
			ent_temp = undefined;
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// the second ground spawner and nodes
	for( i=0; i<noda_dest_ground_2.size; i++ )
	{
		// spawn out the guy
		ent_temp = ent_spwn_ground_2 stalingradspawn( "e4_lugg2_enemy" );
		if( maps\_utility::spawn_failed( ent_temp ) )
		{
			// debug text
			//iprintlnbold( "ent_spwn_ground_2 spawn fail" );

			// wait
			wait( 2.0 );

			// end the function
			return;
		}
		else
		{
			// set the right alert state on the guys
			ent_temp setalertstatemin( "alert_red" );

			//// set up the rules for the NPC
			//ent_temp setengagerule( "tgtSight" );
			//ent_temp addengagerule( "tgtPerceive" );
			//ent_temp addengagerule( "Damaged" );
			//ent_temp addengagerule( "Attacked" );

			//// give the NPC perfect sense for a few seconds
			//ent_temp thread turn_on_sense( 3 );

			//// even guy shoots while running to node
			//if( ( i + 1 ) % 2 == 0 )
			//{
			// set his goal node
			ent_temp setgoalnode( noda_dest_ground_2[i], 1 );
			//}
			//else
			//{
			//				// set his goal node
			//				ent_temp setgoalnode( noda_dest_ground_2[i] );
			//}

			// function makes the guy sprint until he is at goal
			ent_temp thread maps\airport_util::sprint_to_goal();

			// make sure the node the NPC is going to has a script string
			if( !IsDefined( noda_dest_ground_2[i].script_string ) )
			{
				// debug text
				//IPrintLnBold( "noda_dest_ground_2 missing script_string" );
			}

			// with a script string set up the Ai to get their combat role
			if(isdefined(noda_dest_ground_2[i].script_string))
			{
				ent_temp thread combat_role_on_goal( noda_dest_ground_2[i].script_string );

				// make sure the guy isn't a rusher
				if( noda_dest_ground_2[i].script_string != "rusher" )
				{
					ent_temp thread give_tether_at_goal( nod_lugg2_tether, 550, 1500, 512 );
				}
			}
			// wait
			wait( 1.0 );

			// undefine ent_temp
			ent_temp = undefined;
		}
	}
	//////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// wait five seconds for the guys to run through
	// 08-17-08
	// aeady
	// close the garage later because AI can get stuck outside (bug 20431)
	trig_close_garage_door = getent( "close_garage_door", "targetname" );
	//trig_close_garage_door = getent( "trig_start_2nd_retreat", "targetname" );
	trig_close_garage_door waittill( "trigger" );

	// now close the garage door
	sbrush_garage_door movez( -127, 0.5 );
	sbrush_garage_door playsound("garage_door_slam");
	//iprintlnbold ("SOUND: garage close");


	// wait for the move to finish
	sbrush_garage_door waittill( "movedone" );

	// disconnect the paths through it
	sbrush_garage_door disconnectpaths();

	// clean up the spawners
	ent_spwn_ground_1 delete();
	ent_spwn_ground_2 delete();

	// kill all ai left outside
	aiarray = getaiarray("axis");
	for(i = 0; i < aiarray.size; i++)
	{
		if(isdefined(aiarray[i]))
		{
			if(aiarray[i].origin[0] > -300.0)
			{
				aiarray[i] startragdoll();
				aiarray[i] becomecorpse();
			}
		}
	}
}
// ---------------------//
// 02-28-08
// wwilliams
// will wait for the player to hit the trigger that spawns the second set of catwalk guys
// runs on level
e4_luggage_fight_catwalk_2()
{
	// endon
	// single shot function, shouldn't need endons

	// objectives to define for this function
	// trigs
	trig_spawn = getent( "ent_start_e4_slam", "targetname" );
	// spawner
	spawner = getent( "ent_e4_g3_cat2", "targetname" );
	// nodes
	noda_cat_dest = getnodearray( spawner.script_parameters, "targetname" );
	nod_tether_3 = getnode( "nod_luggage_tether_3", "targetname" );
	nod_lugg2_tether = getnode( "lugg2_tether", "targetname" );
	// undefined
	ent_temp = undefined;

	// set the count for the spawner
	spawner.count = noda_cat_dest.size;

	// wait for the trigger to be hit
	trig_spawn waittill( "trigger" );

	// 03-11-08
	// wwilliams
	// change the airplane fly over flag to the third route
	// first clear the second flag
	level maps\_utility::flag_clear( "airplane_fly_over_02" );
	// set the third flag
	level maps\_utility::flag_set( "airplane_fly_over_03" );

	for( i=0; i<noda_cat_dest.size; i++ )
	{
		// spawn out all the guys
		ent_temp = spawner stalingradspawn( "e4_lugg2_enemy" );
		if( maps\_utility::spawn_failed( ent_temp ) )
		{
			// debug text
			//iprintlnbold( "ent_e4_g3_cat2 fail spawn" );

			// wait
			wait( 2.0 );

			// end function
			return;
		}
		else
		{
			// set the right alert state on the guys
			ent_temp setalertstatemin( "alert_red" );

			// set up the rules for the NPC
			ent_temp setengagerule( "tgtSight" );
			ent_temp addengagerule( "tgtPerceive" );
			ent_temp addengagerule( "Damaged" );
			ent_temp addengagerule( "Attacked" );

			// give the NPC perfect sense for a few seconds
			ent_temp thread turn_on_sense( 3 );

			if(	level.catwalk_invalid == true)
			{
				noda_cat_dest = getnodearray( "node_e4_catwalk_backup", "script_noteworthy" );
			}

			// if even shoot while running to spot
			if( ( i + 1 ) % 2 == 0 )
			{
				// set his goal node
				ent_temp setgoalnode( noda_cat_dest[i], 1 );
			}
			else
			{
				// set his goal node
				ent_temp setgoalnode( noda_cat_dest[i] );
			}

			// function makes the guy sprint until he is at goal
			ent_temp thread maps\airport_util::sprint_to_goal();

			// make sure the node the NPC is going to has a script string
			if( !IsDefined( noda_cat_dest[i].script_string ) )
			{
				// debug text
				//IPrintLnBold( "noda_dest_ground_2 missing script_string" );
			}
			else
			{
				// with a script string set up the Ai to get their combat role
				ent_temp thread combat_role_on_goal( noda_cat_dest[i].script_string );

				// function makes the guy sprint until he is at goal
				ent_temp thread sprint_to_goal();

				// make sure the guy isn't a rusher
				if( noda_cat_dest[i].script_string != "rusher" )
				{
					ent_temp thread give_tether_at_goal( nod_lugg2_tether, 550, 1500, 512 );
				}
			}	
		}

		// wait
		wait( 1.5 );

		// undefine ent_Temp
		ent_temp = undefined;
	}

	// wait
	wait( 4.0 );

	// clean up spawner
	spawner delete();

}
// ---------------------//
// 03-20-08
// wwilliams
// controls the guys for fight at the first line of lugg3 area
// fight four of the luggage area
// runs on level
e4_luggage_fight_group_four()
{
	// endon

	// objects to define for this function
	// trigs
	trig = getent( "trig_lugg_3_f4", "targetname" );
	// spawners
	spawner_1 = getent( "spwn_lugg3_f4_left", "targetname" );
	spawner_2 = getent( "spwn_lugg3_f4_right", "targetname" );
	// nodes
	lugg3_tether_3 = getnode( "nod_luggage_tether_3", "targetname" );
	noda_left_side = getnodearray( spawner_1.script_parameters, "targetname" );
	noda_right_side = getnodearray( spawner_2.script_parameters, "targetname" );
	// undefined
	ent_temp = undefined;

	// double check defines
	assertex( isdefined( trig ), "trig not defined, fight four" );
	assertex( isdefined( spawner_1 ), "spawner_1 not defined, fight four" );
	assertex( isdefined( spawner_2 ), "spawner_2 not defined, fight four" );
	assertex( isdefined( lugg3_tether_3 ), "lugg3_tether_3 not defined, fight four" );
	assertex( isdefined( noda_left_side ), "noda_left_side not defined, fight four" );
	assertex( isdefined( noda_right_side ), "noda_right_side not defined, fight four" );

	// set the correct count on each spawner
	spawner_1.count = noda_left_side.size;
	spawner_2.count = noda_right_side.size;

	// wait for the trigger to hit
	trig waittill( "trigger" );

	// save game to deal with issue 
	// savegame( "airport" );
	//level maps\_autosave::autosave_now( "airport" );
	level notify("checkpoint_reached"); // checkpoint 6
	
	// thread off the function that handles the dialogue
	level thread e4_lugg3_dialog();


	///////////////////////////////////////////////////////////////////////
	// spawn out the left side
	counter = noda_left_side.size;
	if(level.ps3 || level.bx ) //GEBE
		counter = 1;
//iprintlnbold("left: " + counter);
	for(i = 0; i < counter; i++)
	{
		// spawn out a guy
		ent_temp = spawner_1 stalingradspawn( "ent_e4_lugg3" );
		// make sure the guy spawns out
		if( maps\_utility::spawn_failed( ent_temp ) )
		{
			// debug text to tell me something went wrong
			//iprintlnbold( "e4_fight_group_four_left fail spawn" );

			// exit function
			return;
		}

		// set up the rules for the NPC
		ent_temp setengagerule( "tgtSight" );
		ent_temp addengagerule( "tgtPerceive" );
		ent_temp addengagerule( "Damaged" );
		ent_temp addengagerule( "Attacked" );

		// set his alert state
		ent_temp setalertstatemin( "alert_red" );

		// give the NPC perfect sense for a few seconds
		ent_temp thread turn_on_sense( 3 );

		if( ( i + 1 ) % 2 == 0 )
		{
			// set his goal node
			ent_temp setgoalnode( noda_left_side[i], 1 );
		}
		else
		{
			// set his goal node
			ent_temp setgoalnode( noda_left_side[i] );
		}

		// make sure the node the NPC is going to has a script string
		if( !IsDefined( noda_left_side[i].script_string ) )
		{
			// debug text
			//IPrintLnBold( "noda_left_side missing script_string" );
		}

		// with a script string set up the Ai to get their combat role
		ent_temp thread combat_role_on_goal( noda_left_side[i].script_string );

		// function makes the guy sprint until he is at goal
		ent_temp thread sprint_to_goal();


		// make sure the guy isn't a rusher
		if( noda_left_side[i].script_string != "rusher" )
		{
			ent_temp thread give_tether_at_goal( lugg3_tether_3, 384, 1024, 256 );
		}

		// quick wait so the guys don't spawn on top of each other
		wait( 0.5 );

		// undefine ent_temp
		ent_temp = undefined;
	}
	///////////////////////////////////////////////////////////////////////
	// spawn out the right side
	counter = noda_right_side.size;
	if(level.ps3 || level.bx) //GEBE
		counter = 1;
//iprintlnbold("right: " + counter);
	for(i = 0; i < counter; i++)
	{
		//spawn out the guys on the right
		ent_temp = spawner_2 stalingradspawn( "ent_e4_lugg3" );
		// make sure the guy spawned out
		if( maps\_utility::spawn_failed( ent_temp ) )
		{
			// debug text to tell me something went wrong
			//iprintlnbold( "e4_fight_group_four_right fail spawn" );

			// exit function
			return;
		}

		// set up the rules for the NPC
		ent_temp setengagerule( "tgtSight" );
		ent_temp addengagerule( "tgtPerceive" );
		ent_temp addengagerule( "Damaged" );
		ent_temp addengagerule( "Attacked" );

		// set his alert state
		ent_temp setalertstatemin( "alert_red" );

		// give the NPC perfect sense for a few seconds
		ent_temp thread turn_on_sense( 3 );

		if( ( i + 1 ) % 2 == 0 )
		{
			// set his goal node
			ent_temp setgoalnode( noda_right_side[i], 1 );
		}
		else
		{
			// set his goal node
			ent_temp setgoalnode( noda_right_side[i] );
		}

		// make sure the node the NPC is going to has a script string
		if( !IsDefined( noda_right_side[i].script_string ) )
		{
			// debug text
			//IPrintLnBold( "noda_left_side missing script_string" );
		}

		// with a script string set up the Ai to get their combat role
		ent_temp thread combat_role_on_goal( noda_right_side[i].script_string );

		// function makes the guy sprint until he is at goal
		ent_temp thread sprint_to_goal();

		// make sure the guy isn't a rusher
		if( noda_right_side[i].script_string != "rusher" )
		{
			ent_temp thread give_tether_at_goal( lugg3_tether_3, 384, 1024, 256 );
		}

		// quick wait so the guys don't spawn on top of each other
		wait( 0.8 );

		// undefine ent_temp
		ent_temp = undefined;
	}

	// stop the luggage spawn on conveyor h
	level notify("stop_conveyor_h");
}
// ---------------------//
// WW 07-09-08
// function spawns the left guy who fires from the last
// catwalk in lugg3
// runs on level
lugg3_catwalk_left()
{
	// endon

	// objects to be defined for this function
	// trig
	trig_setup = getent( "trig_lugg_3_f4", "targetname" );
	trig_start = getent( "trig_lugg3_catwalk", "targetname" );
	// spawner
	spawner = getent( "lugg3_catwalk_left", "targetname" );
	// nodes
	nod_lugg3_cat_left = getnode( "nod_lugg3_cat_left", "targetname" );
	// undefined
	ent_temp = undefined;

	// double check defines
	assertex( isdefined( trig_setup ), "trig_setup not defined" );
	assertex( isdefined( trig_start ), "trig_start not defined" );
	assertex( isdefined( spawner ), "spawner not defined" );
	assertex( isdefined( nod_lugg3_cat_left ), "noda_lugg3_cat not defined" );

	// set the proper count
	spawner.count = 1;

	// wait for the trigger to hit
	trig_setup waittill( "trigger" );

	//// set culling so we don't draw everything outside of the luggage area (ps3 only)
	//if(level.ps3)
	//{
	//	setculldist(2100);
	//}

	// spawn out the guy
	ent_temp = spawner stalingradspawn( "ent_e4_lugg3" );

	// make sure the spawn worked
	if( maps\_utility::spawn_failed( ent_temp ) )
	{
		// debug text
		//iprintlnbold( "lugg3_catwalk_left spawn fail" );

		// wait
		wait( 3.0 );

		// end function
		return;
	}

//iprintlnbold("catwalk left: 1");
	// extra endons
	ent_temp endon( "death" );

	// guy spawned out properly, set him up
	ent_temp lockalertstate( "alert_red" );

	// send npc to node
	ent_temp setgoalnode( nod_lugg3_cat_left );

	// wait for goal
	ent_temp waittill( "goal" );

	// wait for the player to hit the second trig
	trig_start waittill( "trigger" );

	// give npc perfect sense for a few seconds
	ent_temp thread turn_on_sense();

	// fire at the player
	ent_temp cmdshootatentity( level.player, true, 4, 0.4 );

}
// ---------------------//
// WW 07-09-08
// function spawns the left guy who fires from the last
// catwalk in lugg3
// runs on level
lugg3_catwalk_right()
{
	// endon

	// objects to be defined for this function
	// trig
	trig_setup = getent( "trig_lugg_3_f4", "targetname" );
	trig_start = getent( "trig_lugg3_catwalk", "targetname" );
	// spawner
	spawner = getent( "lugg3_catwalk_right", "targetname" );
	// nodes
	nod_lugg3_cat_right = getnode( "nod_lugg3_cat_right", "targetname" );
	// undefined
	ent_temp = undefined;

	// double check defines
	assertex( isdefined( trig_setup ), "trig_setup not defined" );
	assertex( isdefined( trig_start ), "trig_start not defined" );
	assertex( isdefined( spawner ), "spawner not defined" );
	assertex( isdefined( nod_lugg3_cat_right ), "noda_lugg3_cat not defined" );

	// set the proper count
	spawner.count = 1;

	// wait for the trigger to hit
	trig_setup waittill( "trigger" );

	// spawn out the guy
	ent_temp = spawner stalingradspawn( "ent_e4_lugg3" );

	// make sure the spawn worked
	if( maps\_utility::spawn_failed( ent_temp ) )
	{
		// debug text
		//iprintlnbold( "lugg3_catwalk_left spawn fail" );

		// wait
		wait( 3.0 );

		// end function
		return;
	}
//iprintlnbold("catwalk right: 1");

	// extra endons
	ent_temp endon( "death" );

	// guy spawned out properly, set him up
	ent_temp lockalertstate( "alert_red" );

	// send npc to node
	ent_temp setgoalnode( nod_lugg3_cat_right );

	// wait for goal
	ent_temp waittill( "goal" );

	// wait for the player to hit the second trig
	trig_start waittill( "trigger" );

	// give npc perfect sense for a few seconds
	ent_temp thread turn_on_sense();

	// fire at the player
	ent_temp cmdshootatentity( level.player, true, 4, 0.4 );

}
// ---------------------//
// 03-24-08
// wwilliams
// spawns out the gusy for the fifth fight in the luggage room
// spawn points are in the locker area and the office area
// runs on level
e4_luggage_fight_group_five()
{
	// endon
	// single shot function doens't need to be interrupted

	// objects to be defined for this function
	// trigs
	trig = getent( "trig_lugg3_f5", "targetname" );
	// spawners
	spwn_lugg3_f5_left = getent( "ent_spwn_lugg3_f5_left", "targetname" );
	spwn_lugg3_f5_right = getent( "ent_spwn_lugg3_f5_right", "targetname" );
	// nodes
	noda_lugg3_f5_left = getnodearray( spwn_lugg3_f5_left.script_parameters, "targetname" );
	noda_lugg3_f5_right = getnodearray( spwn_lugg3_f5_right.script_parameters, "targetname" );
	nod_tether_4 = getnode( "nod_luggage_tether_4", "targetname" );
	// undefined
	ent_temp = undefined;

	// set the count on the spawners
	spwn_lugg3_f5_left.count = noda_lugg3_f5_left.size;
	spwn_lugg3_f5_right.count = noda_lugg3_f5_right.size;

	// wait for the trigger to be hit
	trig waittill( "trigger" );

	// spawn out the left guys
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// spawn out a guy for each node
	counter = noda_lugg3_f5_left.size;
	if(level.ps3 || level.bx)
		counter = 3;
//iprintlnbold("left: " + counter);
	for(i = 0; i < counter; i++)
	{
		// spawning
		ent_temp = spwn_lugg3_f5_left stalingradspawn( "ent_e4_lugg3" );
		// double check the spawn
		if( maps\_utility::spawn_failed( ent_temp ) )
		{
			// debug text
			//iprintlnbold( "spwn_lugg3_f5_left fail spawn" );

			// wait
			wait( 2.0 );

			// end function
			return;
		}

		// make sure the node has a script string
		assertex( isdefined( noda_lugg3_f5_left[i].script_string ), "noda_lugg3_f5_right missing script_string" );

		// set up this guy
		// set the right alert state on the guys
		ent_temp setalertstatemin( "alert_red" );

		// give the guy a few secs of perfectsense
		ent_temp thread turn_on_sense();

		// if odd fire at the player while running to goal
		if( ( i + 1 ) % 2 == 1 )
		{
			// send the guy out to the node
			ent_temp setgoalnode( noda_lugg3_f5_left[i], 1 );
		}
		// if even just run to the right spot
		else
		{
			// send the guy out to the node
			ent_temp setgoalnode( noda_lugg3_f5_left[i] );
		}

		// give brain when ai reaches node
		ent_temp thread combat_role_on_goal( noda_lugg3_f5_left[i].script_string );

		// function makes the guy sprint until he is at goal 
		ent_temp thread maps\airport_util::sprint_to_goal();

		if( noda_lugg3_f5_left[i].script_string != "rusher" )
		{ 
			// give tether when NPC reaches goal
			ent_temp thread give_tether_at_goal( nod_tether_4, 384, 1800, 256 );
		}

		// wait
		wait( 0.2 );

		// undefine ent_temp so there is no weird stuff
		ent_temp = undefined;
	}

	// spawn out the right guys
	/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
	// spawn out a guy for each node
	counter = noda_lugg3_f5_right.size;
	if(level.ps3 || level.bx)
		counter = 3;
//iprintlnbold("right: " + counter);
	for(i = 0; i < counter; i++)
	{
		// spawning
		ent_temp = spwn_lugg3_f5_right stalingradspawn( "ent_e4_lugg3" );
		// double check the spawn
		if( maps\_utility::spawn_failed( ent_temp ) )
		{
			// debug text
			//iprintlnbold( "spwn_lugg3_f5_right spawn fail" );

			// wait
			wait( 2.0 );

			// end function
			return;
		}

		// make sure the node has a script string
		assertex( isdefined( noda_lugg3_f5_right[i].script_string ), "noda_lugg3_f5_right missing script_string" );

		// set up this guy
		// set the right alert state on the guys
		ent_temp setalertstatemin( "alert_red" );

		// give the guy a few secs of perfectsense
		ent_temp thread turn_on_sense();

		// if even fire at the player while running to goal
		if( ( i + 1 ) % 2 == 0 )
		{
			// send the guy out to the node
			ent_temp setgoalnode( noda_lugg3_f5_right[i], 1 );
		}
		// if odd just run to the right spot
		else
		{
			// send the guy out to the node
			ent_temp setgoalnode( noda_lugg3_f5_right[i] );
		}

		// give brain when ai reaches node
		ent_temp thread combat_role_on_goal( noda_lugg3_f5_right[i].script_string );

		// function makes the guy sprint until he is at goal
		ent_temp thread maps\airport_util::sprint_to_goal();

		if( noda_lugg3_f5_right[i].script_string != "rusher" )
		{
			// give tether when NPC reaches goal
			ent_temp thread give_tether_at_goal( nod_tether_4, 384, 1800, 256 );
		}

		// wait
		wait( 1.2 );

		// undefine ent_temp so there is no weird stuff
		ent_temp = undefined;
	}

	// wait
	wait( 4.0 );

	// clean up spawners
	spwn_lugg3_f5_left delete();
	spwn_lugg3_f5_right delete();

	// run the function that ends event four
	level thread quick_end();

}
// ---------------------//
// wwilliams 11-10-7
// grabs the luggage models in an array, and the conveyor start
// then runs the function from airport_util to move them down the line
luggage_init()
{
	// endon

	// objects to be defined
	// 03-27-08
	// wwilliams
	// trigger to start teh second set of belt
	trig = getent( "ent_start_e4_slam", "targetname" );
	// conveyors
	// 03-27-08
	// old way of doing it
	/*luggage_0_start = getnode( "sc_ent_luggage_start_0", "targetname" );
	luggage_1_start = getnode( "sc_ent_luggage_start_1", "targetname" );
	luggage_2_start = getnode( "sc_ent_luggage_start_2", "targetname" );
	luggage_3_start = getnode( "sc_ent_luggage_start_3", "targetname" );
	luggage_4_start = getnode( "sc_ent_luggage_start_4", "targetname" );*/
	// 03-27-08
	// defining the sections of each conveyor belt
	// conveyor a
	// first one that is near the entrance to the lugg 1
	conveyor_a_s0 = getent( "ent_luggage_a_s0", "targetname" );
	conveyor_a_s1 = getent( "ent_luggage_a_s1", "targetname" );
	conveyor_a_s2 = getent( "ent_luggage_a_s2", "targetname" );
	conveyor_a_s3 = getent( "ent_luggage_a_s3", "targetname" );
	conveyor_a_s4 = getent( "ent_luggage_a_s4", "targetname" );
	conveyor_a_s5 = getent( "ent_luggage_a_s5", "targetname" );
	conveyor_a_s6 = getent( "ent_luggage_a_s6", "targetname" );

	// conveyor b
	// first raised belt in the lugg 1
	conveyor_b_s0 = getent( "ent_luggage_b_s0", "targetname" );
	conveyor_b_s1 = getent( "ent_luggage_b_s1", "targetname" );
	conveyor_b_s2 = getent( "ent_luggage_b_s2", "targetname" );
	conveyor_b_s3 = getent( "ent_luggage_b_s3", "targetname" );
	conveyor_b_s4 = getent( "ent_luggage_b_s4", "targetname" );
	conveyor_b_s5 = getent( "ent_luggage_b_s5", "targetname" );
	conveyor_b_s6 = getent( "ent_luggage_b_s6", "targetname" );

	// conveyor c
	// second raised belt in lugg 2
	conveyor_c_s0 = getent( "ent_luggage_c_s0", "targetname" );
	conveyor_c_s1 = getent( "ent_luggage_c_s1", "targetname" );
	conveyor_c_s2 = getent( "ent_luggage_c_s2", "targetname" );
	conveyor_c_s3 = getent( "ent_luggage_c_s3", "targetname" );
	conveyor_c_s4 = getent( "ent_luggage_c_s4", "targetname" );
	conveyor_c_s5 = getent( "ent_luggage_c_s5", "targetname" );
	conveyor_c_s6 = getent( "ent_luggage_c_s6", "targetname" );

	// conveyor d
	// belt to the left of the exit ramp from lugg1
	conveyor_d_s0 = getent( "ent_luggage_d_s0", "targetname" );
	conveyor_d_s1 = getent( "ent_luggage_d_s1", "targetname" );
	conveyor_d_s2 = getent( "ent_luggage_d_s2", "targetname" );
	conveyor_d_s3 = getent( "ent_luggage_d_s3", "targetname" );
	conveyor_d_s4 = getent( "ent_luggage_d_s4", "targetname" );

	// conveyor e
	// belt to the right of the exit ramp from lugg1
	conveyor_e_s0 = getent( "ent_luggage_e_s0", "targetname" );
	conveyor_e_s1 = getent( "ent_luggage_e_s1", "targetname" );
	conveyor_e_s2 = getent( "ent_luggage_e_s2", "targetname" );
	conveyor_e_s3 = getent( "ent_luggage_e_s3", "targetname" );
	conveyor_e_s4 = getent( "ent_luggage_e_s4", "targetname" );
	conveyor_e_s5 = getent( "ent_luggage_e_s5", "targetname" );
	conveyor_e_s6 = getent( "ent_luggage_e_s6", "targetname" );

	// conveyor h
	// belt seen through windows before the drop down to lugg2
	conveyor_h_s0 = getent( "ent_luggage_h_s0", "targetname" );
	// conveyor_h_s1 = getent( "ent_luggage_d_s1", "targetname" );
	// conveyor_h_s2 = getent( "ent_luggage_d_s2", "targetname" );
	// conveyor_b_s3 = getent( "ent_luggage_b_s3", "targetname" );
	// conveyor_b_s4 = getent( "ent_luggage_b_s4", "targetname" );

	// conveyor f
	// belt that exits lugg3
	conveyor_f_s0 = getent( "ent_luggage_f_s0", "targetname" );
	conveyor_f_s1 = getent( "ent_luggage_f_s1", "targetname" );
	conveyor_f_s2 = getent( "ent_luggage_f_s2", "targetname" );
	conveyor_f_s2.script_vector = (0, 40.2, 0);
	conveyor_f_s3 = getent( "ent_luggage_f_s3", "targetname" );
	conveyor_f_s4 = getent( "ent_luggage_f_s4", "targetname" );

	// conveyor g
	// belt to the right when entering lugg3
	conveyor_g_s0 = getent( "ent_luggage_g_s0", "targetname" );
	conveyor_g_s1 = getent( "ent_luggage_g_s1", "targetname" );
	conveyor_g_s2 = getent( "ent_luggage_g_s2", "targetname" );
	conveyor_g_s3 = getent( "ent_luggage_g_s3", "targetname" );
	conveyor_g_s4 = getent( "ent_luggage_g_s4", "targetname" );
	conveyor_g_s5 = getent( "ent_luggage_g_s5", "targetname" );
	conveyor_g_s6 = getent( "ent_luggage_g_s6", "targetname" );
	conveyor_g_s7 = getent( "ent_luggage_g_s7", "targetname" );
	conveyor_g_s8 = getent( "ent_luggage_g_s8", "targetname" );
	conveyor_g_s9 = getent( "ent_luggage_g_s9", "targetname" );
	conveyor_g_s10 = getent( "ent_luggage_g_s10", "targetname" );
	conveyor_g_s11 = getent( "ent_luggage_g_s11", "targetname" );
	conveyor_g_s12 = getent( "ent_luggage_g_s12", "targetname" );
	conveyor_g_s13 = getent( "ent_luggage_g_s13", "targetname" );

	// luggage
	// 03-27-08
	// old way of doing it
	/*luggage_set_0 = getentarray( "scrp_ent_luggage_0", "targetname" );
	luggage_set_1 = getentarray( "scrp_ent_luggage_1", "targetname" );
	luggage_set_2 = getentarray( "scrp_ent_luggage_2", "targetname" );
	luggage_set_3 = getentarray( "scrp_ent_luggage_3", "targetname" );
	luggage_set_4 = getentarray( "scrp_ent_luggage_4", "targetname" );*/


	// run the airport_util functions
	// 03-27-08
	// old way of doing it
	// move_luggage( start_point, entarray, st_endon )
	/*level thread maps\airport_util::move_luggage( luggage_0_start, luggage_set_0, "airport_four_done" );
	level thread maps\airport_util::move_luggage( luggage_1_start, luggage_set_1, "airport_four_done" );
	level thread maps\airport_util::move_luggage( luggage_2_start, luggage_set_2, "airport_four_done" );
	level thread maps\airport_util::move_luggage( luggage_3_start, luggage_set_3, "airport_four_done" );
	level thread maps\airport_util::move_luggage( luggage_4_start, luggage_set_4, "airport_four_done" );*/

	// activate the belts in lugg1
	// belt a
	conveyor_a_s0 thread conveyor_start();
	conveyor_a_s1 thread conveyor_start();
	conveyor_a_s2 thread conveyor_start();
	conveyor_a_s3 thread conveyor_start();
	conveyor_a_s4 thread conveyor_start();
	conveyor_a_s5 thread conveyor_start();
	conveyor_a_s6 thread conveyor_start();
	// belt b
	conveyor_b_s0 thread conveyor_start();
	conveyor_b_s1 thread conveyor_start();
	conveyor_b_s2 thread conveyor_start();
	conveyor_b_s3 thread conveyor_start();
	conveyor_b_s4 thread conveyor_start();
	conveyor_b_s5 thread conveyor_start();
	conveyor_b_s6 thread conveyor_start();
	// belt c
	conveyor_c_s0 thread conveyor_start();
	conveyor_c_s1 thread conveyor_start();
	conveyor_c_s2 thread conveyor_start();
	conveyor_c_s3 thread conveyor_start();
	conveyor_c_s4 thread conveyor_start();
	conveyor_c_s5 thread conveyor_start();
	conveyor_c_s6 thread conveyor_start();
	// belt d
	conveyor_d_s0 thread conveyor_start();
	conveyor_d_s1 thread conveyor_start();
	conveyor_d_s2 thread conveyor_start();
	conveyor_d_s3 thread conveyor_start();
	conveyor_d_s4 thread conveyor_start();
	// belt e
	conveyor_e_s0 thread conveyor_start();
	conveyor_e_s1 thread conveyor_start();
	conveyor_e_s2 thread conveyor_start();
	conveyor_e_s3 thread conveyor_start();
	conveyor_e_s4 thread conveyor_start();
	conveyor_e_s5 thread conveyor_start();
	conveyor_e_s6 thread conveyor_start();
	// belt h
	conveyor_h_s0 thread conveyor_start();

	// wait for teh brushes to begin
	wait( 5.0 );

	// start the luggage on these conveyors
	level thread conveyor_belt_a_lugg_init();
	//iprintlnbold( "lugg_a" );
	level thread conveyor_belt_b_lugg_init();
	//iprintlnbold( "lugg_b" );
	level thread conveyor_belt_c_lugg_init();
	//iprintlnbold( "lugg_c" );
	level thread conveyor_belt_d_lugg_init();
	//iprintlnbold( "lugg_d" );
	level thread conveyor_belt_e_lugg_init();
	//iprintlnbold( "lugg_e" );
	if(!level.ps3 && !level.bx) //GEBE
		level thread conveyor_belt_h_lugg_init();
	//iprintlnbold( "lugg_f" );

	// wait for the trig to hit before starting the other area
	trig waittill( "trigger" );

	// belt f
	conveyor_f_s0 thread conveyor_start();
	conveyor_f_s1 thread conveyor_start();
	conveyor_f_s2 thread conveyor_start();
	conveyor_f_s3 thread conveyor_start();
	conveyor_f_s4 thread conveyor_start();

	// belt g
	conveyor_g_s0 thread conveyor_start();
	conveyor_g_s1 thread conveyor_start();
	conveyor_g_s2 thread conveyor_start();
	conveyor_g_s3 thread conveyor_start();
	conveyor_g_s4 thread conveyor_start();
	conveyor_g_s5 thread conveyor_start();
	conveyor_g_s6 thread conveyor_start();
	conveyor_g_s7 thread conveyor_start();
	conveyor_g_s8 thread conveyor_start();
	conveyor_g_s9 thread conveyor_start();
	conveyor_g_s10 thread conveyor_start();
	conveyor_g_s11 thread conveyor_start();
	conveyor_g_s12 thread conveyor_start();
	conveyor_g_s13 thread conveyor_start();
}
// ---------------------//
// 03-27-08
// wwilliams
// function starts up the conveyor physics on the conveyors in event four
// conveyors are script brushes
// runs on self, which is the conveyor
conveyor_start()
{
	// define an undefined container to store the value in
	vec_direction = undefined;

	// check that self has a target, this is what the angles of the conveyor will use
	assertex( isdefined( self.script_vector ), "" + self.targetname + " has no script_vector, can't get teh angles!" );

	// define the target of the brush, 
	// ent_direction = getent( self.target, "targetname" );

	// angles to forward on the target of the conveyor
	// multiply the returned angle by 50 for speed foward
	vec_direction = anglestoforward( self.script_vector ) * 75;

	// start the conveyor with the proper direction
	self setconveyor( vec_direction );

}
// ---------------------//
// 03-27-08
// wwilliams
// controls belt a of the conveyors
conveyor_belt_a_lugg_init()
{
	// endon

	// objects to be defined for this function
	belt_start = getent( "con_lug_a_start", "targetname" );
	belt_end = getent( "con_lug_a_end", "targetname" );
	// belt_lugg_one = "belt_a_0";
	// belt_lugg_two = "belt_a_1";
	// belt_lugg_three = "belt_a_2";
	// belt_lugg_four = "belt_a_3";
	// belt_lugg_five = "belt_a_4";
	str_end_on = "entered_lugg2";
	// second section of the airport
	belt_start_g = getent( "con_lug_g_start", "targetname" );
	belt_end_g = getent( "con_lug_g_end", "targetname" );

	// start the function on each piece
	level thread luggage_control( "belt_a_0", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_a_1", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_a_2", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_a_3", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_a_4", belt_start, belt_end, "entered_lugg2" );

	// wait for the notify that the player is in the second area
	level waittill( "entered_lugg2" );

	//// now start moving all the bags to teh next area
	//level thread luggage_control( "belt_a_0", belt_start_g, belt_end_g, "e5_complete" );
	//wait( 2.0 );
	//level thread luggage_control( "belt_a_1", belt_start_g, belt_end_g, "e5_complete" );
	//wait( 2.0 );
	//level thread luggage_control( "belt_a_2", belt_start_g, belt_end_g, "e5_complete" );
	//wait( 2.0 );
	//level thread luggage_control( "belt_a_3", belt_start_g, belt_end_g, "e5_complete" );
	//wait( 2.0 );
	//level thread luggage_control( "belt_a_4", belt_start_g, belt_end_g, "e5_complete" );

	// send out the notify for b's bags to move
	level notify( "b_to_g" );

}
// ---------------------//
conveyor_belt_b_lugg_init()
{
	// endon

	// objects to be defined for this function
	belt_start = getent( "con_lug_b_start", "targetname" );
	belt_end = getent( "con_lug_b_end", "targetname" );
	/* belt_lugg_one = "belt_b_0";
	belt_lugg_two = "belt_b_1";
	belt_lugg_three = "belt_b_2";
	belt_lugg_four = "belt_b_3";
	belt_lugg_five = "belt_b_4";
	str_end_on = "entered_lugg2"; */
	// second section of the airport
	belt_start_g = getent( "con_lug_g_start", "targetname" );
	belt_end_g = getent( "con_lug_g_end", "targetname" );

	// start the function on each piece
	level thread luggage_control( "belt_b_0", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_b_1", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_b_2", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_b_3", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_b_4", belt_start, belt_end, "entered_lugg2" );

	// wait for the notify that the player is in the second area
	level waittill( "entered_lugg2" );

	// wait for the a bags to finish
	level waittill( "b_to_g" );

	//// move these bags to the second belt
	//level thread luggage_control( "belt_b_0", belt_start_g, belt_end_g, "e5_complete" );
	//wait( 3.0 );
	//level thread luggage_control( "belt_b_1", belt_start_g, belt_end_g, "e5_complete" );
	//wait( 3.0 );
	//level thread luggage_control( "belt_b_2", belt_start_g, belt_end_g, "e5_complete" );
	//wait( 3.0 );
	//level thread luggage_control( "belt_b_3", belt_start_g, belt_end_g, "e5_complete" );
	//wait( 3.0 );
	//level thread luggage_control( "belt_b_4", belt_start_g, belt_end_g, "e5_complete" );

}
// ---------------------//
conveyor_belt_c_lugg_init()
{
	// endon

	// objects to be defined for this function
	belt_start = getent( "con_lug_c_start", "targetname" );
	belt_end = getent( "con_lug_c_end", "targetname" );
	/* belt_lugg_one = "belt_c_0";
	belt_lugg_two = "belt_c_1";
	belt_lugg_three = "belt_c_2";
	belt_lugg_four = "belt_c_3";
	belt_lugg_five = "belt_c_4";
	str_end_on = "entered_lugg2"; */
	// second section of the airport
	belt_start_g = getent( "con_lug_g_start", "targetname" );
	belt_end_g = getent( "con_lug_g_end", "targetname" );

	// start the function on each piece
	level thread luggage_control( "belt_c_0", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_c_1", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_c_2", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_c_3", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_c_4", belt_start, belt_end, "entered_lugg2" );

	// wait for the notify that the player is in the second area
	level waittill( "entered_lugg2" );

	//// next section of belt
	//level thread luggage_control( "belt_c_0", belt_start_g, belt_end_g, "e5_complete" );
	//wait( 2.0 );
	//level thread luggage_control( "belt_c_1", belt_start_g, belt_end_g, "e5_complete" );
	//wait( 2.0 );
	//level thread luggage_control( "belt_c_2", belt_start_g, belt_end_g, "e5_complete" );
	//wait( 2.0 );
	//level thread luggage_control( "belt_c_3", belt_start_g, belt_end_g, "e5_complete" );
	//wait( 2.0 );
	//level thread luggage_control( "belt_c_4", belt_start_g, belt_end_g, "e5_complete" );

	// notify the next set of bags
	level notify( "d_to_f" );

}
// ---------------------//
conveyor_belt_d_lugg_init()
{
	// endon

	// objects to be defined for this function
	belt_start = getent( "con_lug_d_start", "targetname" );
	belt_end = getent( "con_lug_d_end", "targetname" );
	/* belt_lugg_one = "belt_d_0";
	belt_lugg_two = "belt_d_1";
	belt_lugg_three = "belt_d_2";
	belt_lugg_four = "belt_d_3";
	belt_lugg_five = "belt_d_4";
	str_end_on = "entered_lugg2"; */
	// second section of the airport
	belt_start_f = getent( "con_lug_f_start", "targetname" );
	belt_end_f = getent( "con_lug_f_end", "targetname" );

	// start the function on each piece
	level thread luggage_control( "belt_d_0", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_d_1", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_d_2", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_d_3", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_d_4", belt_start, belt_end, "entered_lugg2" );

	// wait for the notify that the player is in the second area
	level waittill( "entered_lugg2" );

	// wait for the notify to start
	level waittill( "d_to_f" );

	//// move these bags to the second area
	//level thread luggage_control( "belt_d_0", belt_start_f, belt_end_f, "e5_complete" );
	//wait( 8.0 );
	//level thread luggage_control( "belt_d_1", belt_start_f, belt_end_f, "e5_complete" );
	//wait( 8.0 );
	//level thread luggage_control( "belt_d_2", belt_start_f, belt_end_f, "e5_complete" );
	//wait( 8.0 );
	//level thread luggage_control( "belt_d_3", belt_start_f, belt_end_f, "e5_complete" );
	//wait( 8.0 );
	//level thread luggage_control( "belt_d_4", belt_start_f, belt_end_f, "e5_complete" );

	// send out the notify for the next set
	level notify( "e_to_f" );


}
// ---------------------//
conveyor_belt_e_lugg_init()
{
	// endon

	// objects to be defined for this function
	belt_start = getent( "con_lug_e_start", "targetname" );
	belt_end = getent( "con_lug_e_end", "targetname" );
	/* belt_lugg_one = "belt_e_0";
	belt_lugg_two = "belt_e_1";
	belt_lugg_three = "belt_e_2";
	belt_lugg_four = "belt_e_3";
	belt_lugg_five = "belt_e_4";
	str_end_on = "entered_lugg2"; */
	// second section of the airport
	belt_start_f = getent( "con_lug_f_start", "targetname" );
	belt_end_f = getent( "con_lug_f_end", "targetname" );

	// start the function on each piece
	level thread luggage_control( "belt_e_0", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_e_1", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_e_2", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_e_3", belt_start, belt_end, "entered_lugg2" );
	wait( 8.0 );
	level thread luggage_control( "belt_e_4", belt_start, belt_end, "entered_lugg2" );

	// wait for the notify that the player is in the second area
	level waittill( "entered_lugg2" );

	// wait for the notify to move to teh next belt
	level waittill( "e_to_f" );

	//// move the bags to the next spot
	//level thread luggage_control( "belt_e_0", belt_start_f, belt_end_f, "e5_complete" );
	//wait( 8.0 );
	//level thread luggage_control( "belt_e_1", belt_start_f, belt_end_f, "e5_complete" );
	//wait( 8.0 );
	//level thread luggage_control( "belt_e_2", belt_start_f, belt_end_f, "e5_complete" );
	//wait( 8.0 );
	//level thread luggage_control( "belt_e_3", belt_start_f, belt_end_f, "e5_complete" );
	//wait( 8.0 );
	//level thread luggage_control( "belt_e_4", belt_start_f, belt_end_f, "e5_complete" );

}
// ---------------------//
conveyor_belt_h_lugg_init()
{
	// endon

	// objects to be defined for this function
	belt_start = getent( "con_lug_h_start", "targetname" );
	belt_end = getent( "con_lug_h_end", "targetname" );
	belt_lugg_one = "belt_h_0";
	belt_lugg_two = "belt_h_1";
	belt_lugg_three = "belt_h_2";
	belt_lugg_four = "belt_h_3";
	belt_lugg_five = "belt_h_4";
	str_end_on = "stop_conveyor_h";

	// start the function on each piece
	level thread luggage_control( "belt_h_0", belt_start, belt_end, str_end_on );
	wait( 8.0 );
	level thread luggage_control( "belt_h_1", belt_start, belt_end, str_end_on );
	wait( 8.0 );
	level thread luggage_control( "belt_h_2", belt_start, belt_end, str_end_on );
	wait( 8.0 );
	level thread luggage_control( "belt_h_3", belt_start, belt_end, str_end_on );
	wait( 8.0 );
	level thread luggage_control( "belt_h_4", belt_start, belt_end, str_end_on );

}
// ---------------------//
// 03-27-08
// wwilliams
// controls a single piece of luggage through the journey
// checks against distance from the end before restarting the journey
// need to add the ability to store own origin 
// and check against it multiple times before removing it from the world
luggage_control( str_luggage, ent_so_start, end_point, str_end_on )
{
	if( isdefined( str_end_on ) )
	{	
		// endon
		level endon( str_end_on );
	}

	// DCS: send luggage to check for flaps.
	if(IsDefined(str_luggage))
	{
		level thread setup_luggage_flaps(str_luggage);
	}

	// iprintlnbold( "" + denta_luggage[i].targetname + "" );

	// iprintlnbold( "" + denta_luggage[i].scritp_noteworthy + "" );

	// temp undefined
	temp_vec = undefined;
	temp_org = undefined;

	// iprintlnbold( " luggage go! " );

	while( 1 )
	{
		// stop physics on the luggage piece
		dynent_stopphysics( str_luggage );

		// grab the first one and make it disappear
		dynent_setvisible( str_luggage, 0 );

		// wait
		wait( 0.15 );

		// move the dyn ent
		dynent_setorigin( str_luggage, ent_so_start.origin );

		// wait
		wait( 0.15 );

		// show the dyn_ent
		dynent_setvisible( str_luggage, 1 );

		// wait
		wait( 0.15 );

		// start physics on the thing
		dynent_startphysics( str_luggage );

		// loop until the luggage is too close to the end
		while( 1 )
		{
			// get the origin of the luggage
			temp_org = dynent_getorigin( str_luggage );

			// if the luggage is close to the end 
			if( distance( temp_org, end_point.origin ) < 50 )
			{
				// start bigger while loop over
				break;
			}
			else
			{
				// wait awhile before checking again
				wait( randomfloatrange( 2.0, 3.5 ) );
			}

		}

	}
}
// ---------------------//
// wwilliams 11-28-07
// causes the tank explosion that drops the second catwalk
e4_r2_catwalk_explosion()
{
	// endon


	// objects to define for the function
	trig = getent( "trig_catwalk_explo", "targetname" );
	explosion_point = getent( "so_catwalk_explo", "targetname" );
	// 02-15-08
	// adding the script brushmodel
	// brush model not working out, switching to use bad place
	// sbrush_walk = getent( "sbrush_catwalk_explo", "targetname" );

	// connect the paths of teh sbrush
	// sbrush_walk connectpaths();
	// wait for the trigger to be hit by the player
	while( 1 )
	{
		// trig hit
		// self waittill( "trigger" );
		trig waittill( "damage", amount, attacker, direction_vec, point, type );

		// check to see if attacker = level.player
		if( attacker == level.player )
		{
			// kick out of this function
			break;
		}
		else
		{
			// quick wait
			wait( 0.5 );
		}
	}

	// earthquake the player
	earthquake( 0.7, 2.5, level.player.origin, 850 );

	// controller rumble
	level thread maps\airport_util::air_ctrl_rumble_timer( 1 );

	// notify the catwalk drop
	level notify( "catwalk02_start" );

	// delete the metal clip
	cliparray = getentarray("catwalk_explosion_clip", "targetname");
	if(isdefined(cliparray))
	{
		for(i = 0; i < cliparray.size; i++)
		{
			cliparray[i] delete();
		}
	}
	// cause the explosion effect
	catwalk_explo = playfx( level._effect[ "f_explosion" ], explosion_point.origin );

	// play sound of explosion
	explosion_point playsound( "airport_catwalk_explosion" );
	//iprintlnbold("sound playing?");
	//level notify(fire sounds start);

	// disconnect paths
	// sbrush_walk disconnectpaths();

	// move the sbrush down under the level
	// sbrush_walk moveto( sbrush_walk.origin + ( 0, 0, -700 ), 0.1 );

	// damage radius to the area
	radiusdamage( explosion_point.origin, 300, 600, 200 );
	radiusdamage( explosion_point.origin + ( 0, 0, -25 ), 300, 600, 200 );

	// lets see how a little physics push helps
	//physicsExplosionSphere( explosion_point.origin, 80, 30, 3.0 );

	// make a badplace so the AI don't come over here anymore
	badplace_cylinder( "catwalk_explosion", 0, explosion_point.origin, 256, 182, "axis" );

	// 04-12-08
	// wwilliams
	// start the thread that causes damage from the fire
	// level thread catwalk_fire_react();

}
// ---------------------//
// 02-04-08
// wwilliams
// start slam cam for last room
e4_slam_cam()
{
	// define objects needed for this function
	start_trig = getent( "ent_start_e4_slam", "targetname" );
	// trig to call for the forced spawn during the camera movements
	// no longer spawing guys off of these triggers
	// trig_cam_enemies_1 = getent( "trig_luggage_r2_floor1", "script_noteworthy" );
	// trig_cam_enemies_2 = getent( "trig_luggage_r2_catwalk", "script_noteworthy" );
	// trig_cam_enemies_3 = getent( "trig_luggage_r2_floor2", "script_noteworthy" );

	// 02-26-08
	// example
	// level.CameraID = level.player customcamera_push( "world", ( origin/offset ), ( angles ), time );
	// level.player customcamera_change( level.CameraID, "world", ( origin/offset ), ( angles ), time );

	// wait for the player to hit the trigger
	start_trig waittill( "trigger" );

	// stop player movement
	// level.player freezecontrols( true );

	// calls the function that spawns out all these guys
	level thread e4_luggage_fight_group_three();

	// turn off the luggage threads on the other belts
	level notify ( "entered_lugg2" );

	// save the game so the player doesn't have to go through that cutscene each time
	// savegame( "airport" );
	//level maps\_autosave::autosave_now( "airport" );
	level notify("checkpoint_reached"); // checkpoint 7

	// M updates bond on the situation
	// iprintlnbold( "M:Bond, we still haven't identified the bomber's target." );
	// wait( 3.0 );
	// iprintlnbold( "M:You've got to stop him." );
	level.player maps\_utility::play_dialogue( "M_AirpG_046A", true ); // get to the hangar bond


}
// ---------------------//
// 03-23-08
// wwilliams
// getting the old explosion at the end as just a explosive mousetrap
e4_fence_explosion()
{
	// endon
	level.player endon( "death" );

	// objects to define for this function
	// trig
	dmg_trig = getent( "ent_e4_trig_fence_explo", "targetname" );
	// script origin
	scr_org_bash = getent( "ent_e4_door_bash_exit", "targetname" );

	// wait for the trigger to be hit by the player
	while( 1 )
	{
		// trig hit
		// self waittill( "trigger" );
		dmg_trig waittill( "damage", amount, attacker, direction_vec, point, type );

		// check to see if attacker = level.player
		if( attacker == level.player )
		{
			// kick out of this function
			break;
		}
		else
		{
			// quick wait
			wait( 0.5 );
		}
	}

	// 03-24-08
	// wwilliams
	// notify the end area explosion
	level notify( "exit_explode_start" );

	// play the sound of the explosion
	scr_org_bash playsound( "Airport_Huge_Explosion" );
	//iprintlnbold("sound playing?");

	// explosion FX
	fence_explosion = playfx( level._effect[ "f_explosion" ], scr_org_bash.origin );

	// damage radius to the area
	radiusdamage( scr_org_bash.origin, 300, 600, 200 );

	// earthquake
	earthquake( 0.7, 1.0, scr_org_bash.origin, 200 );

	// start the fire damage area
	// level thread fence_fire_init();

	// move the sbrush out of the way
	// leave the 
	// ent_collision_over_exit moveto( ent_collision_over_exit.origin + ( 0, 0, -2000 ), 0.1 );

	// 03-24-08
	// wwilliams
	// leave the collision 
	//ent_collision_over_exit waittill( "movedone" );
}
// ---------------------//
// 07-30-08 WWilliams
// set up the fire spots for the fence explosion
//fence_fire_init()
//{
//				// endon
//
//				// objects to define for this function
//				vec_fence_fire_1 = ( -432, 6514, 61 );
//				vec_fence_fire_2 = ( -695, 6680, 61 );
//
//				// frame wait
//				wait( 0.05 );
//
//				// thread off the fire reaction
//				level thread e4_fire_too_close( vec_fence_fire_1, "vec_fence_fire_1" );
//
//				// second fire
//				level thread e4_fire_too_close( vec_fence_fire_2, "vec_fence_fire_2" ); 
//
//}
// ---------------------//
// 03-29-08
// wwilliams
// look at event before the drop down in lugg2
// runs on level
lugg2_lookat_layer()
{
	// endon

	// objects to define for this function
	// ents
	trig = getent( "ent_lugg2_lookat", "targetname" );
	vehicle = getent( "vehic_lugg2_lookat", "targetname" );
	// vehic nodes
	vnod_vehic_start = getvehiclenode( vehicle.target, "targetname" );

	// first off link the vehicle to the node
	vehicle attachpath( vnod_vehic_start );

	// wait for the player to look
	trig waittill( "trigger" );

	// this area to fire off other events in the view of the player
	// drone bad guys
	// airplane taking off

	// start the path of the vehicle
	vehicle startpath();

	// another layer for sound goes heree
	// can mimick this with the print3d stuff


}
// ---------------------//
// ---------------------//
// 04-12-08
// wwilliams
// left flank of lugg3 blinking light
e4_light_blinking()
{
	// endon
	// won't need this because the while loop will check against something
	level endon( "e5_complete" );

	// define the objects needed in this function
	light_blinker = getent( "lugg3_light1", "targetname" );

	// objects to define for the function
	model_light_on = getent( "lugg_light_flicker1_on", "targetname" );
	model_light_off = getent( "lugg_light_flicker1_off", "targetname" );

	// while loop checks to see if the player has finished the hack
	while( 1 )
	{
		// drop the light's intensity
		light_blinker setlightintensity( 0.0 );

		// hide the on
		model_light_on hide();
		// show the off
		model_light_off show();

		// wait a random float
		wait( randomfloatrange( 0.3, 0.7 ) );

		// raise the light back to normal
		light_blinker setlightintensity( 1.0 );

		// hide the on
		model_light_off hide();
		// show the off
		model_light_on show();

		// wait a random float
		wait( randomfloatrange( 0.1, 1.5 ) );
	}

}
// ---------------------//
// 04-12-08
// wwilliams
// starts the threads that checks fo rhte player's prox to the fires of event 4
// runs on level
//catwalk_fire_react()
//{
//				// endon
//				// not needed cause this just fires through
//
//				// define the vectors where the fires will be
//				fire_one_org = ( -792, 4962, -19 );
//				fire_two_org = ( -441, 4899, -19 );
//				fire_three_org = ( -317, 4968, -19 );
//				fire_four_org = ( -339, 5044, -19 );
//
//				// frame wait
//				wait( 0.05 );
//
//				// thread off the four fires from the catwalk explosion
//				level thread e4_fire_too_close( fire_one_org, "catwalk_fire_1" );
//				// frame wait
//				wait( 0.05 );
//				level thread e4_fire_too_close( fire_two_org, "catwalk_fire_2" );
//				// frame wait
//				wait( 0.05 );
//				level thread e4_fire_too_close( fire_three_org, "catwalk_fire_3" );
//				// frame wait
//				wait( 0.05 );
//				level thread e4_fire_too_close( fire_four_org, "catwalk_fire_4" );
//
//				// probably will need to wait for a trigger
//				// then do this fo the fire near the end of the level
//
//}
//// ---------------------//
//// 04-12-08
//// wwilliams
//// functions checks to see if self/player is too close to the passed in origin
//// if it is then do damage to the player until they get far enough away
//// using distancesquared
//// runs on self/ intended for player
//e4_fire_too_close( vec_org, str_badplace_name )
//{
//				// endon
//				level.player endon( "death" );
//
//				// verify the vec_org
//				assertex( isdefined( vec_org ), "vec_org_not_def not defined" );
//				assertex( isdefined( str_badplace_name ), "str_badplace_name not defined" );
//
//				// spawn a script org at the vec
//				scr_org = spawn( "script_origin", vec_org );
//
//				// make this spot a badplace
//				badplace_cylinder( str_badplace_name, 0, scr_org.origin, 128, 60, "axis" );
//
//				// play the sound here
//				scr_org playsound( "fire_small" );
//
//				// while loop keeps checking if the player is too close
//				while( 1 )
//				{
//								// radius damage on teh spot
//								radiusdamage( scr_org.origin, 36, 1.0, 0.8 );
//
//								// quick wait
//								wait( 0.05 );
//				}
//
//}
// ---------------------//
// 04-13-08
// wwilliams
// function updates Bond when he enters lugg3
e4_lugg3_dialog()
{
	// M updates Bond on the target
	/* iprintlnbold( "M:Bond!The bomber's target is the Skyfleet prototype, the largest plane in the world." );
	wait( 3.0 );
	iprintlnbold( "M:It's being prepped for launch in hangar C-2." );
	wait( 3.0 );
	iprintlnbold( "Merc:Keep him away from the loading bay. Don't let him get out those doors!" ); */

	// dialogue - M
	level.player maps\_utility::play_dialogue( "M_AirpG_029A", true );

	//Music change for the second luggage area - added by chuck russom		
	level notify("playmusicpackage_luggage_02");

	// dialogue - Merc
	level.player maps\_utility::play_dialogue( "LGM4_AirpG_028A" );
}
// ---------------------//
// 06-25-08
// wwilliams
// adding a guy to run into lugg2
// should help lead the player into the area
e4_lead_into_lugg2()
{
	// endon
	level.player endon( "death" );

	// objects to define for this function
	// trigs
	trig_setup = getent( "trig_e4_lug2_fight", "targetname" );
	trig_lookat = getent( "trig_lookat_lead_2_lugg2", "targetname" );
	trig_touch = getent( "trig_start_r1_luugage_sur", "targetname" );
	// spawner
	spawner = getent( "spwn_lead_into_lugg2", "targetname" );
	// node
	destin_node = GetNode( "nod_lead_into_lugg2", "targetname" );
	// undefined
	ent_temp = undefined;

	// double check defined
	assertex( isdefined( trig_setup ), "trig_setup not defined" );
	assertex( isdefined( trig_lookat ), "trig_lookat not defined" );
	assertex( isdefined( trig_touch ), "trig_touch not defined" );
	assertex( isdefined( spawner ), "spawner not defined" );
	assertex( isdefined( destin_node ), "destin_node not defined" );

	// make sure the count is at least one
	if( spawner.count < 1 )
	{
		// make sure it is at least one
		spawner.count = 1;
	}

	// wait for the player to hit the setup
	//trig_setup waittill( "trigger" );
	trig_touch waittill("trigger"); // using the other trigger so there isn't a guy just standing there during the big fight

	// spawn out the guy and keep him still
	ent_temp = spawner stalingradspawn( "e4_enemy_jump_fence" );

	// make sure the guy didn't fail
	if( maps\_utility::spawn_failed( ent_temp ) )
	{
		// debug text
		//iprintlnbold( "lead_2_lugg2 spawn fail" );

		// wait
		wait( 5.0 );

		// end func
		return;
	}

	// quick endon
	ent_temp endon( "death" );

	// if he spawned turn him off for a second
	ent_temp setenablesense( false );

	// wait for the player to activate either trigger
	level maps\_utility::wait_for_either_trigger( "trig_lookat_lead_2_lugg2", "trig_start_r1_luugage_sur" );

	// turn the guy back on
	ent_temp setenablesense( true );

	ent_temp lockalertstate( "alert_red" );

	// make him a turret
	ent_temp setcombatrole( "turret" );

	// give him sight beyond sight
	ent_temp thread maps\airport_util::turn_on_sense( 5 );

	// send him to his node
	ent_temp setgoalnode( destin_node, 1 );

}
// ---------------------//
// 04-13-08
// wwilliams
// clean up event four
// runs on level
e4_clean_up()
{
	// endon
	//single shot function no need for clean up

	// define the objects needed for this function
	// trigs
	trig = getent( "ent_start_e4_slam", "targetname" );
	// spawners
	enta_spawners_a = getentarray( "e4_spawners_a", "script_noteworthy" );
	enta_spawners_b = getentarray( "e4_spawners_b", "script_noteworthy" );


	// wait for the trigger to be hit
	trig waittill( "trigger" );

	// clean up of the spawners will happen in two parts
	// part a when you do the drop down
	for( i=0; i<enta_spawners_a.size; i++ )
	{
		// delete each spawner
		enta_spawners_a[i] delete();

		// frame wait
		wait( 0.05 );
	}

	// frame wait
	wait( 0.05 );

	// delete the entarray
	// not sure if this is needed
	// enta_spawners_a delete();

	// wait for all the guys to be killed before cleaning the rest of the spawners
	level waittill( "airport_four_done" );

	// thread off the function for blinking the lights
	level thread e4_garage_door_lights();

	// clean up the other set of spawners
	for( i=0; i<enta_spawners_b.size; i++ )
	{
		// delete each spawner
		enta_spawners_b[i] delete();

		// frame wait
		wait( 0.05 );
	}

}
// ---------------------//
// 08-02-08 WWilliams
// causes the lights near the garage doors to blink
e4_garage_door_lights()
{
	// endon


	// objects to define for this function
	gdoor_light_1a = getent( "light_gdoor_1", "targetname" );
	gdoor_light_1b = getent( "light_gdoor_1a", "targetname" );
	gdoor_light_2a = getent( "light_gdoor_2", "targetname" );
	gdoor_light_2b = getent( "light_gdoor_2a", "targetname" );
	gdoor_light_3a = getent( "light_gdoor_3", "targetname" );
	gdoor_light_3b = getent( "light_gdoor_3a", "targetname" );

	// thread these lights off on to their own functions
	// endon = event_5_complete

	// thread light set one
	// level thread e4_light_flicker( gdoor_light_1a, gdoor_light_1b, "event_5_complete" );

	// thread light set two
	level thread e4_light_flicker( gdoor_light_2a, gdoor_light_2b, "event_5_complete" );

	// thread light set three
	// level thread e4_light_flicker( gdoor_light_3a, gdoor_light_3b, "event_5_complete" );

}
///////////////////////////////////////////////////////////////////////////
// 08-06-08 WWilliams
// hide the off version of the light at the garage doors
gdoor_light_flicker_hide()
{
	// endon

	// objects needed for this function
	model_light_off = getent( "lugg_light_flicker1_off", "targetname" );

	// hide it
	model_light_off hide();
}
///////////////////////////////////////////////////////////////////////////
// 08-02-08 WWilliams
// causes lights to flicker
e4_light_flicker( ent_light, ent_light_2, str_endon )
{

	// double check what was passed in
	assertex( isdefined( ent_light ), "ent_light not defined" );
	assertex( isdefined( ent_light_2 ), "ent_light_2 not defined" );
	assertex( isdefined( str_endon ), "str_endon not defined" );

	// endon
	level endon( str_endon );

	// while loop
	while( 1 )
	{
		// random wait
		wait( randomint( 5 ) );

		// change the intensity of the light
		ent_light setlightintensity( 0 );
		ent_light_2 setlightintensity( 0 );

		// random wait
		wait( randomint( 6 ) );

		// put light back to normal
		ent_light setlightintensity( 1 );
		ent_light_2 setlightintensity( 1 );

		// random wait
		wait( randomint( 3 ) );
	}
}
///////////////////////////////////////////////////////////////////////////
//		SETUP LUGGAGE FLAPS
//		:DCS
//		Send a piece of luggage to check when it is near any of the flaps
///////////////////////////////////////////////////////////////////////////
setup_luggage_flaps(str_luggage)
{
	if(!IsDefined(str_luggage))
		return;

	i = 0;

	//get all of the luggage flaps.
	for(i=1; i<12; i++)
	{
		luggage_flaps_array[i] = getent("fxanim_luggage_flaps_"+i, "targetname");

		//send each one plus the piece of luggage to start distance checks
		luggage_flaps_array[i] thread start_luggage_anim(i, str_luggage);
	}
}
start_luggage_anim(i, str_luggage)
{
	if(!IsDefined(str_luggage))
		return;

	if(!IsDefined(i))
		return;

	while(true)
	{
		luggage_org = dynent_getorigin( str_luggage );

		if( distance( luggage_org, self.origin ) < 38 )
		{
			level notify("luggage_flaps_"+i+"_start");
			wait(0.5);
		}
		wait(0.1);
	}
}

///////////////////////////////////////////////////////////////////////////
// 02-15-08
// wwilliams
// door bash at the end of the level
// first idea for the completion event
// commenting this out to lower script string usage
/*e4_airport_end_bash()
{
// endon


// objects to define for this function
trig_bash = getent( "trig_e4_door_bash_exit", "targetname" );
scr_org_bash = getent( "ent_e4_door_bash_exit", "targetname" );
door_node_bash = getnode( "nod_end_airport", "targetname" );
door_bash = getent( "door_end_airport", "targetname" );
ent_collision_over_exit = getent( "ent_exit_point_col", "targetname" );

// 03-28-08
// wwilliams
// changing the hintstring on this trigger to no longer reflect a bash door
trig_bash sethintstring( "Plant Explosive" );

// wait for the player to hit the trigger
trig_bash waittill( "trigger" );

// use the new function from willie to door bash off of the scr_org_bash
// level thread maps\_utility::player_anim_doorbash( "door_bash", scr_org_bash, 1 );

// open the door after the bash has happened
// door_node_bash maps\_doors::open_door();

// trigger off the trig
trig_bash maps\_utility::trigger_off();

// 03-24-08
// wwilliams
// counts down to ten before continuing
for( i=10; i>0; i-- )
{
// the wait time
wait( 1.0 );

// the debug print	
iprintlnbold( "" + i + " seconds remain before fence explosion!" );

}
// ---------------------//
// 03-24-08
// wwilliams
// notify the end area explosion
level notify( "exit_explode_start" );

// play the sound of the explosion
scr_org_bash playsound( "Airport_Huge_Explosion" );

// explosion FX
fence_explosion = playfx( level._effect[ "f_explosion" ], scr_org_bash.origin );

// damage radius to the area
radiusdamage( scr_org_bash.origin, 300, 600, 200 );

// move the sbrush out of the way
ent_collision_over_exit moveto( ent_collision_over_exit.origin + ( 0, 0, -2000 ), 0.1 );

ent_collision_over_exit waittill( "movedone" );

// 03-24-08
// wwilliams
// wait ten second to allow time to see the explosion
wait( 15.0 );

// wwilliams
// notify the end of the level
level notify( "airport_four_done" );

//missionsuccess( "airport_rail", false, 1.0 );

// wwilliams 11-27-07
// new ending function call
//changelevel( "casino" );
// 04-06-08
// no longer ending level here
// changelevel( "montenegrotrain" );


}*/
// ---------------------//
// wwilliams 11-7-07
// if guy checking for bond after server room dies set the flag for warn
/*e4_fight_killed()
{
level endon( "e4_warn_alerted" );

self waittill( "death" );

level maps\_utility::flag_set( "e4_warn" );
}
// ---------------------//
// wwilliams 11-9-07
// if guy checking for bond after server room is hurt then set the flag
e4_fight_damaged()
{
level endon( "e4_warn_alerted" );

self waittill( "damage" );

level maps\_utility::flag_set( "e4_warn" );
}*/
// ---------------------//
// ---------------------//
/*e4_block_out_populate()
{
// endon

// stuff
enta_trigs_e4_pop = getentarray( "e4_basic_populate", "targetname" );

// run a function on each trig
for( i=0; i<enta_trigs_e4_pop.size; i++ )
{
// run the function
level thread e4_test_pop( enta_trigs_e4_pop[i] );

}




}
// ---------------------//
e4_test_pop( trig )
{
// stuff
spawner = getent( trig.target, "targetname" );
wait( 0.2 );
destin_nodes = getnodearray( spawner.script_noteworthy, "targetname" );
temp_ent = undefined;
str_targetname = undefined;

// 02-12-08
// wwilliams
// double check to see if the spawner has script_string defined
if( isdefined( spawner.script_string ) )
{
str_targetname = spawner.script_string;
}
else
{
str_targetname = "e4_enemy";
}

spawner.count = destin_nodes.size;

// trig hit
trig waittill( "trigger" );

for( i=0; i<destin_nodes.size; i++ )
{
temp_ent = spawner maps\airport_util::spwn_guy_set_attributes( str_targetname );
//wait( 0.05 );
level thread run_to_destin( temp_ent, destin_nodes[i] );
wait( 0.2 );

}

temp_ent = undefined;


//spwn_guy_set_attributes( str_targetname )

}
// ---------------------//
run_to_destin( guy, destin_node )
{

// endon
guy endon( "damage" );
guy endon( "death" );

guy setgoalnode( destin_node );

guy waittill( "goal" );

}*/
// ---------------------//
// wwilliams 11-7-07
// wait for the self to hit alert_green then sends out a notify
/* e4_fight_alert_state()
{
self endon( "death" );
self endon( "damage" );

while( self getalertstate() == "alert_green" )
{
wait( 0.1 );
}

self notify( "e4_warn_alerted" );
} */
// ---------------------//
