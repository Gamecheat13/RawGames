// Montenegro Train car 3
// Builder: Don Sielke
// Scripter: Don Sielke
//////////////////////////////////////////////////////////////////////////////////////////
// includes
#include maps\_utility;

//////////////////////////////////////////////////////////////////////////////////////////
// Private car. (combat)
///////////////////////////////////////////////////////////////////////////////////////////
e3_main()
{
				thread load_car3_thugs();

				wait( 1.0 );

				//Enemy enter roof fight
				level.seen_on_roof = false;
				

				// wwilliams
				// 06-08-08
				// function starts controlling table drop stuff
				level thread car3_table_drop_trigs();

				// define the function that starts the freight
				start_trig = GetEnt("freight_start_trig", "targetname");

				// wait for the freight to be activated
				start_trig waittill( "trigger" );
				
				// DCS: bring in cull when freigt train appears.						
				level thread move_culldist_freight();

				// wait for the freight to get into position
				level.freight_train[0] waittill( "movedone" );

				// setup the car four guys
				level thread maps\MontenegroTrain_car4::e4_main();

				// startup car4
				level maps\_utility::flag_wait( "on_freight_train" );
}

move_culldist_freight()
{
	if( level.ps3 || level.bx ) //GEBE
	{
		SetExpFog( 500, 2500, 0.012, 0.022, 0.02, 2.0, 1.0 );
		wait(2.0);
		setculldist( 6500 );
		//iprintlnbold("culldist now 6500");
	}
	// DCS: trigger first set of fx entities.
	level notify("start_fxgroup_1");
}	
//////////////////////////////////////////////////////////////////////////////////////////
// Can no longer go back to train 1, remove civilian ai.
//////////////////////////////////////////////////////////////////////////////////////////

remove_train1_civilians()
{
				civ1_array = getentarray("train1_civilian", "script_noteworthy");

				//////////////////////////////////////////////////////////////////////////////////////////
				// 04-17-08
				// wwilliams
				// adding a flag set so I can stop the animations that are looping on the civs
				//////////////////////////////////////////////////////////////////////////////////////////
				level flag_set( "clean_car_1" );

				// give it a second to turn off the anims
				wait( 1.0 );
				//////////////////////////////////////////////////////////////////////////////////////////

				for (i = 0; i < civ1_array.size; i++)
				{
								if( IsDefined (civ1_array[i]) )
								{
												civ1_array[i] delete();

												// iprintlnbold( "one civ deleted" );
								}		
				}
} 

//////////////////////////////////////////////////////////////////////////////////////////
// Load Car3 thugs.
//////////////////////////////////////////////////////////////////////////////////////////
load_car3_thugs()
{
				trig = GetEnt( "car3_spawner", "targetname" );
				spawners = GetEntArray( "car3_thugs", "targetname" );
				// undefined
				temp_ent = undefined;
				if ( IsDefined(trig) )
				{
								trig waittill ("trigger");

								if ( IsDefined(spawners) )
								{
												for (i=0; i<spawners.size; i++)
												{
																temp_ent = spawners[i] StalingradSpawn( "car3_enemy" );

																if( maps\_utility::spawn_failed( temp_ent ) )
																{
																				// debug text
																				iprintlnbold( "car3 guy didn't spawn!" );
																}

																// frame wait
																wait( 0.05 );

																// make sure there is a script string on the spawner
																if( isdefined( spawners[i].script_string ) )
																{
																				// transfer teh script_string
																				temp_ent.script_string = spawners[i].script_string;

																				// run the idle function on the guy
																				temp_ent thread car3_idles();
																				
																				// 06-08-08 WWilliams
																				// function opens the hatch if any of the ai see you
																				temp_ent thread car3_alert_open_hatch();

																				// undefine temp_ent
																				temp_ent = undefined;
																}
																else
																{
																				// debug text
																				iprintlnbold( "car3 spawner missing a script_string" );
																}
												}
								}
				}
				else
				{
								iPrintLnBold( "car 3 spawn trig not found" );
				}

				//////////////////////////////////////////////////////////////////////////
				// 05-14-08
				// wwilliams
				// after the guys are spawner out start the clean up function
				level thread clean_car3_thugs();

				// setup glass after these guys are alive
				level thread roof_glass_setup();

				// delete the spawners
				for( i=0; i<spawners.size; i++ )
				{
								// delete spawner
								spawners[i] delete();

								// wait
								wait( 0.05 );
				}
}
///////////////////////////////////////////////////////////////////////////
// 08-16-08 WWilliams
// function watches to see if a guy spots the player, then opens the hatch
car3_alert_open_hatch()
{
				// endon
				self endon( "death" );

				// tether node
				tether_node = GetNode( "nod_car3_tether", "targetname" );

				// while loop
				while( self getalertstate() != "alert_red" )
				{
								// wait
								wait( 0.1 );
				}

				// open the hatch
				level thread check_car3_alert();

				// give tether point
				self.tetherpt = tether_node.origin;

				// start the tether on these guys
				self thread maps\MontenegroTrain_util::train_active_tether( 400, 2000, 256 );
}
//////////////////////////////////////////////////////////////////////////
// 05-14-08
// wwilliams
// clean up the guys from car 3 once the player jumps to the freight
// this way when the guys rush back for the observation car it seems like it was these
// NPCs
// runs on level
//////////////////////////////////////////////////////////////////////////
clean_car3_thugs()
{
				// endon
				// not needed, single run function

				// objects to be defined for the function
				// ent_array
				enta_car3_thugs = getentarray( "car3_enemy", "targetname" );

				// wait for the on freight flag
				level flag_wait( "on_freight_train" );

				// notify to turn off idles
				level notify( "stop_car3_idles" );

				// clean out the array of dead guys
				enta_car3_thugs = remove_dead_from_array( enta_car3_thugs );

				// check the size of the array
				// if it is zero then we can end this function
				if( enta_car3_thugs.size == 0 )
				{
								// end the function
								return;
				}

				// now go through the array
				for( i=0; i<enta_car3_thugs.size; i++ )
				{
								// check to see if the guy is alive
								if( isalive( enta_car3_thugs[i] ) )
								{
												// check to see if they are alerted to the player
												if( enta_car3_thugs[i] getalertstate() == "alert_red" )
												{
																// don't delete this guy cause he is after the player
																break;
												}
												else
												{
																// hide the guys
																enta_car3_thugs[i] hide();

																// kill him
																enta_car3_thugs[i] delete();
												}
								}
				}
}
///////////////////////////////////////////////////////////////////////////
// 08-09-08 WWilliams
// function runs on each other the car3 guys, makes them perform animations
// so they seem alive
// runs on the guy
car3_idles()
{
				// endon
				level endon( "stop_car3_idles" );

				// double check the guy has a script string
				//assertex( isdefined( self.script_string ), "car3 guy missing script_string" );

				// undefined
				int_anim = undefined;

				// keep looping while the guy is not alerted
				while( isdefined( self ) && self getalertstate() != "alert_red" )
				{
								// check what that script string is
								if( self.script_string == "single" )
								{
												// play animation
												self cmdaction( "fidget" );

												// wait for it to finish
												self waittill( "cmd_done" );
								}
								else if( self.script_string == "convo" )
								{
												// get a random number
												int_anim = randomint( 21 );

												if( int_anim < 12 )
												{
																// play animation
																self cmdaction( "fidget" );

																// wait for it to finish
																self waittill( "cmd_done" );
												}
												else
												{
																//// play animation
																//self cmdaction( "TalkA2" );

																//// wait for it to finish
																//self waittill( "cmd_done" );
																wait( 0.1 );
												}
								}

								// random wait
								wait( randomfloat( 1.2 ) );
				}

				// once alert red has been hit
				self stopallcmds();

				// know where the player is
				self thread maps\MontenegroTrain_util::turn_on_sense( 5 );

}
//////////////////////////////////////////////////////////////////////////////////////////
//	Setup car glass triggers.
//////////////////////////////////////////////////////////////////////////////////////////
// wwilliams
// NOTE: Func grabs all the triggers at the top of the skylight car3 roof
roof_glass_setup()
{
				// define array
	/*			bullet_trigger = getentArray ( "bullet_start_trigger", "targetname" );*/
				// define the glass array
				car3_roof_glass = getentarray( "trig_car3_glass", "targetname" );

				// if the array is defined
				if( isdefined( car3_roof_glass ) )
				{
								// for loop goes through the array
								for( i=0; i<car3_roof_glass.size; i++ )
								{
												// thread a function for each piece of glass
												level thread player_on_glass( car3_roof_glass[i] );

												// iprintlnbold( "glass thread on " + i );
								}
				}

				//// if the array is defined
				//if ( IsDefined(bullet_trigger) )
				//{
				//				// for loop goes through each array spot
				//				for (i=0; i<bullet_trigger.size; i++)
				//				{
				//								// run a function on the trigger
				//								bullet_trigger[i] thread player_on_glass();
				//				}
				//}		
				// get the trigger that registers the jump to the freight
				level.jump_trig = GetEnt("freight_jump_trig", "targetname");
				// function runs on level for the jump to the freight train
				thread jump_to_freight();
}
// wwilliams
// NOTE: Func waits for the player to touch the trig
// doesn't do it if player has already been spotted
// runs on trig/self
player_on_glass( trig_overglass )
{
				// endon
				level endon( "car3_alerted" );

				// check the object passed in 
				//assertex( isdefined( trig_overglass ), "sbrush_glass not defined" );
				// make sure the trig has a target
				//assertex( isdefined( trig_overglass.target ), "roof glass missing a target" );
				
				// need to add an endon if the player shoots through the glass
				// then comes back up
				trig = GetEnt( "car3_spawner", "targetname" );

				// wait for the trig
				trig waittill( "trigger" );
				
				// define all the bad guys in car3
				enemy = getentarray( "car3_enemy", "targetname" );
				// define the target of the trigger
				sbrush_glass = getentarray( trig_overglass.target, "targetname" );
				// undefined
				actual_glass = undefined;

				// go through the glass of the level
				for( i=0; i<sbrush_glass.size; i++ )
				{
								if( isdefined( sbrush_glass[i].script_noteworthy ))
								{
												// check the distance on each glass
												if( distancesquared( trig_overglass.origin, sbrush_glass[i].origin ) > 65*65 )
												{
																continue;
												}
												else if( distancesquared( trig_overglass.origin, sbrush_glass[i].origin ) < 65*65 && sbrush_glass[i].script_noteworthy == "car_roof_windows" )
												{
																// this is teh right piece of glass
																actual_glass = sbrush_glass[i];

																// thread this on the glass to make sure the AI is always alerted from aggresive action
																actual_glass thread car3_player_shoots_glass();

																// end this for loop
																break;
												}
								}
				}

				// double check this is the right glass
				//assertex( isdefined( actual_glass ), "no actual glass for one of the roof glasses" );
				//assertex( isdefined( actual_glass.glasshealth ), "roof glass missing glasshealth!" );

				// iprintlnbold( "watching for the glass to be touched" );

				// check the var in the player has been seen already
				while( level.seen_on_roof == false && isdefined( actual_glass ) )
				{	

								// iprintlnbold( "inside while loop" );

								// wait for the player to touch the glass
								while( !level.player istouching( trig_overglass ) )
								{
												// wait
												wait( 0.05 );
								}

								// once the player touches the glass start damaging it
								while( level.player istouching( trig_overglass ) && isdefined( actual_glass ) )
								{
												// iprintlnbold( "player on glass!" );

												// check that the glass still has health on it
												if( actual_glass.glasshealth > 1 && isdefined( actual_glass ) )
												{
																// damage the glass slightly
																actual_glass.glasshealth = actual_glass.glasshealth - 10;

																// sound hook for cracking glass

																// wait a tenth of a second
																wait( 1.0 );

																// iprintlnbold( "glass damaged, health at " + actual_glass.glasshealth );
												}
												else
												{
																// dodamage to the piece of glass
																// actual_glass dodamage( 80, actual_glass.origin, level.player );

																// the glass has damaged to the point that it should crack
																// notify that the player has broken stealth
																trig_overglass thread fail_timer_glass();
																
																// function checks if the alert becomes red, and then opens the hatch
																level thread check_car3_alert();

																// leave the loop
																return;
												}
								}

								// wait
								wait( 0.05 );
				}	
}
///////////////////////////////////////////////////////////////////////////
// 08-09-08 WWilliams
// if the player shoots at teh glass alert all the guards
// runs on the glass/self
car3_player_shoots_glass()
{
				// endon

				// grab the car3 guys
				car3_guys = getentarray( "car3_enemy", "targetname" );
				
				// loop in case it wasn't the player that damaged it
				while( isdefined( self ) )
				{
								// wait for damage from the player
								self waittill( "damage", iDamage, sAttacker );

								// check to see if it was the player
								if( sAttacker == level.player )
								{
												// remove the dead from the array 
												car3_guys = remove_dead_from_array( car3_guys );

												// alert the guys
												for( i=0; i<car3_guys.size; i++ )
												{
																if( isalive( car3_guys[i] ) && car3_guys[i] getalertstate() != "alert_red" )
																{
																				// alert the guy
																				car3_guys[i] lockalertstate( "alert_red" );

																				// give him perfect sense for a limited time
																				car3_guys[i] thread maps\MontenegroTrain_util::turn_on_sense( 5 );
																}
																//else if( isalive( car3_guys[i] ) && car3_guys[i] getalertstate() == "alert_red" )
																//{
																//				// open the hatch
																//				level thread check_car3_alert();

																//				// end the function
																//				return;
																//}
												}

												// open the hatch
												level thread check_car3_alert();
								}

								// wait to avoid infinite loop
								wait( 0.05 );
				}
}
///////////////////////////////////////////////////////////////////////////
// wwilliams
// NOTE: Func waits a set time, then checks to see
// if the player is touching the trig
// runs on level
roof_glass_timer(seconds, trig)
{
				// endons
				level endon("off_glass");
				level.player endon("death");

				// define all the bad guys in car3
				enemy = getentarray("car3_enemy", "targetname");
				// for loop goes through each array slot
				for (i = 0; i < enemy.size; i++)
				{
								// check the enemy alert state
								// if it is not red
								if(enemy[i] getalertstate() != "alert_red")
								{
												// make it yellow
												enemy[i] SetAlertStateMin( "alert_yellow" );
												//iprintlnbold("alert set to yellow minimum");
								}	
				}

				// on the trig run a couple of functions
				// function notifies the other functions that the player is off the glass
				trig thread end_timer_glass();
				// function causes the fail reaction
				trig thread fail_timer_glass();
				// function checks if the alert becomes red, and then opens the hatch
				thread check_car3_alert();

				// go down the amount of time given into the func
				for(i = seconds; i > -1; i--)
				{
								// wait half a sec
								wait(0.5);
				}
				// notify that the player has been on the glass too long
				level notify("glass_limit_reached");
}
// wwilliams
// NOTE: Func
end_timer_glass()
{
				// endon
				level endon("glass_limit_reached");
				level.player endon("death");

				//// wait for player to leave glass trigger.	
				// while the player is touching the trig
				while(level.player istouching(self) )
				{	
								// wait half a sec
								wait(0.05);
				}
				// when the player leaves the glass notify the level
				level notify("off_glass");

				//// reset trigger
				// starts the trigger back through the series of functions
				self thread player_on_glass();

				//// put back into green.
				// define all the enemies in car3
				enemy = getentarray("car3_enemy", "targetname");
				// for loop goes through the array
				for (i = 0; i < enemy.size; i++)
				{
								// if the enemy is not is alert state red
								if(enemy[i] getalertstate() != "alert_red")
								{
												// change the alert state down
												enemy[i] SetAlertStateMin( "alert_green" );
												// make sure it goes there
												enemy[i] LockAlertState( "alert_green" );
												// no longer lock the alert state
												enemy[i] UnlockAlertState();
												//iprintlnbold("alert set to green minimum");
								}
				}
}
// wwilliams
// NOTE: Func waits for the timer func to report the player has
// been on the glass too long
// runs on trig/self
fail_timer_glass()
{
				// endon
				level.player endon("death");

				// wait for the notify from the timer function
				// level waittill("glass_limit_reached");

				//// put enemy on red alert.	
				// define the enemies in car3
				enemy = getentarray("car3_enemy", "targetname");

				// check to see if the var is false
				if( level.seen_on_roof == false )
				{	
								// inform the player they have been seen
								// iPrintLnBold( "Someone's up there! On the roof!");
								// randomize the comment yelled
								int_random = randomint( 10 );
								if( int_random < 5 )
								{
												if( isalive( enemy[0] ) )
												{
																// play dialogue off of one of the guys
																// enemy[0] maps\MontenegroTrain_util::train_play_dialogue( "TMR1_TraiG_027A" );
																enemy[0] maps\_utility::play_dialogue_nowait( "TMR1_TraiG_027A" );
												}
								}
								else
								{
												if( isalive( enemy[0] ) )
												{
																// play dialogue off of one of the guys
																//enemy[0] maps\MontenegroTrain_util::train_play_dialogue( "TMR1_TraiG_027B" );
																enemy[0] maps\_utility::play_dialogue_nowait( "TMR1_TraiG_027B" );
												}
								}

							
								// set the var

								level.seen_on_roof = true;

								// endon
								// level notify( "car3_alerted" );
				}

				//// put enemy on red alert.	
				// define the enemies in car3
				enemy = remove_dead_from_array( enemy );
				// start the function that shoots through the roof
				self thread fire_through_roof(enemy);
				// thread off one guy ta
				if( isalive( enemy[1] ) )
				{
								// thread off one guy talking
								enemy[1] maps\_utility::play_dialogue( "TMR1_TraiG_027B" );;
				}
				// go through the ai array
				for (i = 0; i < enemy.size; i++)
				{
								// make the ai shoot at the player
								enemy[i] CmdShootAtEntity(level.player, true, 2, 0.5);
								// lock the alert state
								enemy[i] LockAlertState( "alert_red" );
	
				}
}
// wwilliams
// NOTE: Func makes the sparks hit the ground around the player
// as if guys are shooting up into the roof
// takes in an enemy array
// runs on trig/self
fire_through_roof(enemy)
{		
				// endon
				level endon ("stop_roof_bullets");

				// define local vars
				i=0;
				// define array
				fx2 = [];

				// while the player is touching the trig and the enemies are greater than 0
				while ( level.player istouching(self) && enemy.size > 0 )
				{
								// wwilliams
								// NOTE: this litle section basically makes a bullet shoot from near the ground 
								// and close to the player
								// toward the ground, so the fx kick off in the player's sight
								// random x offset
								x = randomfloatrange(-10.0,10.0);
								// random y offset
								y = randomfloatrange(20.0,80.0);
								// define a firing position using the random x & y
								firepos = level.player.origin + ( x, y, 3 );
								// define a hit point using the random x & y
								hitpos = firepos + ( x, y, -3);

								// fire a bullet from the firing point to the hit point
								magicbullet("p99_wet_s", firepos, hitpos);
								// play the fx at the player's feet to accompany the magic bullet
								fx = playfx( level._effect["fx_metalhit_lg"], hitpos);

								// wait a random amount of time
								wait(randomfloatrange(0.2,1.0));
								// increase local var i
								i++;
				}	
}	
// wwilliams
// NOTE: function controls the hatch opening
// by checking to see if the enemies are alerted to the player
// takes in an enemy array
// runs on level
check_car3_alert()
{
															
				//// open hatch.
				// get the hatch near the ai with the automatic
				hatch_ai = GetEnt( "hatch_ai", "targetname" );

				if( hatch_ai.script_int == 0 )
				{
								// check the hatch for a script_noteworthy
								if ( isdefined(hatch_ai.script_noteworthy) )
								{
												// the noteworthy dictates which way to move the hatch
												if(hatch_ai.script_noteworthy == "reverse" )
												{
																// make it not solid so it will move
																hatch_ai notsolid();

																// if reverse move it negative y																								
																hatch_ai MoveTo( hatch_ai.origin + (0, -51, 0), 0.5 );

																// wait for the move to finish
																hatch_ai waittill( "movedone" );

																// solid again
																hatch_ai solid();

																// connect paths
																hatch_ai connectpaths();

																// set the opened variable
																hatch_ai.script_int = 1;
												}
								}		
								else
								{
												// make it not solid so it will move
												hatch_ai notsolid();

												// if not reverse the positive on the y
												hatch_ai MoveTo( hatch_ai.origin + (0, 51, 0), 0.5 );

												// wait for the move to finish
												hatch_ai waittill( "movedone" );

												// solid again
												hatch_ai solid();

												// connect paths
												hatch_ai connectpaths();

												// set the opened variable
												hatch_ai.script_int = 1;
								}
				}

}
//////////////////////////////////////////////////////////////////////////////////////////
// 06-08-08
// wwilliams
// Table drop under skylights
//////////////////////////////////////////////////////////////////////////////////////////
// 06-08-08
// wwilliams
// define all the triggers
car3_table_drop_trigs()
{
				// endon
				// level.player endon( "death" );

				// define the objects for the function
				// trigs
				enta_table_drop_trig = getentarray( "train_table_drop", "targetname" );

				// make sure the trigs are defined
				//assertex( isdefined( enta_table_drop_trig ), "enta_table_drop_trig not defined" );

				// for loop goes through the array
				for( i=0; i<enta_table_drop_trig.size; i++ )
				{
								// function on each trig
								enta_table_drop_trig[i] thread car3_table_init();

								// wait
								wait( 0.05 );
				}
}
///////////////////////////////////////////////////////////////////////////
// 06-08-08
// wwilliams
// defines the targets and waits for activation
// runs on self/trig
car3_table_init()
{
				// endon
				// level.player endon( "death" );

				// make sure the trig has a target
				//assertex( isdefined( self.target ), "table_drop trig missing target" );

				// define the objects for the function
				smodel_table = getent( self.target, "targetname" );

				// make sure the table has a target
				//assertex( isdefined( smodel_table.target ), "smodel_table missing target" );

				// define the sbrush collision
				smodel_collision = getent( smodel_table.target, "targetname" );

				// while loop
				while( 1 )
				{
								// wait for the trig to hit
								self waittill( "trigger", ent_guy );

								// check to see if the player is touching it
								if( ent_guy == level.player )
								{
												// see if the player is above the model
												if( ent_guy.origin[2] > smodel_table.origin[2] )
												{
																// shoot off all the dyn ents on the table
																physicsExplosionSphere( level.player.origin + ( 0, 0, -10 ), 75, 55, 1.0 );

																// delete the collision
																smodel_collision delete();

																// move the table down 32 units
																smodel_table moveto( smodel_table.origin + ( 0, 0, -30 ), 0.5 );

																// wait for the drop to finish
																smodel_table waittill( "movedone" );

																// check to see which model is being used
																if( smodel_table.model == "p_lvl_train_dining_tbl" )
																{
																				// switch the model to the correct destroyed version
																				
																				//Steve G
																				level.player playsound("table_break");
																				
																				smodel_table setmodel( "p_lvl_train_dining_tbl_d" );
																}
																else if( smodel_table.model == "p_lvl_train_dining_tbl_sngl" )
																{
																				// switch the model to the correct destroyed version
																				
																				//Steve G
																				level.player playsound("table_break");
																				
																				smodel_table setmodel( "p_lvl_train_dining_tbl_sngl_d" );
																}
																else
																{
																				// debug text
																				iprintlnbold( "how is it neither of the table models are correct?" );
																}

																// slight earthquake
																earthquake( 0.4, 0.7, level.player.origin, 48 );

																// get rid of the trig
																level thread car3_clean_self_up( self );

																// end function
																return;
												}
												else
												{
																// the player is not above the table
																continue;
												}
								}

								// what if it is an ai?
								if( ent_guy != level.player )
								{
												// delete the collision
												smodel_collision delete();

												// drop the table
												// move the table down 32 units
												smodel_table moveto( smodel_table.origin + ( 0, 0, -30 ), 0.5 );

												// wait for the drop to finish
												smodel_table waittill( "movedone" );

												// check to see which model is being used
												if( smodel_table.model == "p_lvl_train_dining_tbl" )
												{
																// switch the model to the correct destroyed version
																smodel_table setmodel( "p_lvl_train_dining_tbl_d" );
												}
												else if( smodel_table.model == "p_lvl_train_dining_tbl_sngl" )
												{
																// switch the model to the correct destroyed version
																smodel_table setmodel( "p_lvl_train_dining_tbl_sngl_d" );
												}
												else
												{
																// debug text
																iprintlnbold( "how is it neither of the table models are correct?" );
												}

												// get rid of the trig
												level thread car3_clean_self_up( self );

												// end the function
												return;
								}

								// wait
								wait( 0.05 );
				}
}
///////////////////////////////////////////////////////////////////////////
// 06-08-08
// wwilliams
// function is run from a self function
// will delete what ever self was in the last function after five seconds
// runs on level
car3_clean_self_up( delete_ent )
{
				// make sure delete_ent is valid
				if( isdefined( delete_ent ) )
				{

								// wait five secs
								wait( 5.0 );

								// delete
								delete_ent delete();
				}
				// it must already be dead
				else
				{

								// end function
								return;
				}
}
///////////////////////////////////////////////////////////////////////////
//	Jump to freight train.
///////////////////////////////////////////////////////////////////////////
//trigger will completely stop the bullets through the roof.
jump_to_freight()
{
				if ( IsDefined( level.jump_trig ) )
				{
								level.jump_trig waittill("trigger");
								level.on_freight_train = true;
								///////////////////////////////////////////////////////////////////
								// 05-10-08
								// wwilliams
								// new flag mimics this level var
								// if( !flag( "on_freight_train" ) )
								// {

								// just set it without checking it
								// getting an error when I try to check it as false
								level flag_set( "on_freight_train" );

								// wait for an extra second
								wait( 2.0 );

								// save the game now
								level thread maps\_autosave::autosave_now( "montenegrotrain" );

								// debug text
								// 05-22-08
								// wwilliams
								// commenting out all iprintlnbold debug
								// iprintlnbold( "set_on_freight_train" );
								// }
								//////////////////////////////////////////////////////////////////////////

								//////////////////////////////////////////////////////////////////////////
								// 05-08-08
								// wwilliams
								// also going to set a flag that informs script the freight train jump has occured
								// level flag_set( "on_freight_train" );
								//////////////////////////////////////////////////////////////////////////
								level notify("stop_roof_bullets");

								//End Action Music - Added by crussom
								level notify( "endmusicpackage" );

								wait(2.0);
							// 	thread maps\MontenegroTrain_util::hud_text_uninterruptible("Hurry up and unload that stuff!", 2000);

				}	
}
//////////////////////////////////////////////////////////////////////////////////////////
// 04-23-08
// wwilliams
// adding a function that checks to see if the player is inside or outside car 3
// used to change the flag that turns on and off the wind and blur
e3_player_position()
{
				// endon

				// objects to be defined for this function
				// trigs
				trig = getent( "ent_trig_in_car3" );

				// 05-10-08
				// wwilliams
				// old function, I don't think it is called anymore,
				// this is now watched in the function that grabs the triggers
				// in the _util file

				// while loop keeps checking for the player to be inside the trigger before jumping
				// to the freight
				while( level.on_freight_train == false )
				{
								// check to see if the player is touching the trigger
								if( level.player istouching( trig ) )
								{
												// change the flag from outside to inside
												level flag_clear( "outside_train" );
								}
								else
								{
												// set the flag for being outside
												level flag_set( "outside_train" );
								}

				}
}
//////////////////////////////////////////////////////////////////////////////////////////
