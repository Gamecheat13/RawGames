// Montenegro Train car 6
// Builder: Don Sielke
// Scripter: Don Sielke
//////////////////////////////////////////////////////////////////////////////////////////
// includes
#include maps\_utility;

e6_main()
{
				thread delete_car6_flood();

				// iprintlnbold( "inside car 6 scripts!" );

				/////////////////////////////////////////////////////////////////////////
				// 06-01-08
				// wwilliams
				// new spawning function for car six
				// line 1
				level thread car6_line_1();
				// line 2
				level thread car6_line_2();



				// startup car7
				level waittill( "in_car_6" );
				thread maps\MontenegroTrain_car7::e7_main();

				////////////////////////////////////////////////////////////////////////////////
				// 06-03-08
				// wwilliams
				// clean up will now take place in the functions the guys are spawned from
				// thread delete_freight_spawners();
				////////////////////////////////////////////////////////////////////////////////


}

//////////////////////////////////////////////////////////////////////////////////////////
// At end of train, delete flood spawner.
//////////////////////////////////////////////////////////////////////////////////////////
delete_car6_flood()
{
				trig = GetEnt( "delete_car6_flood", "targetname" );

				car6_floodspawner = GetEnt( "car6_flood", "script_noteworthy" );

				if ( IsDefined(trig) )
				{
								trig waittill ("trigger");
								if ( IsDefined(car6_floodspawner) )
								{
												car6_floodspawner delete();
								}	
				}	
}
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 06-03-08
// wwilliams
// commenting out this clean up
// will be cleaning up the spawners from the crossfire in car4 scripts
/* delete_freight_spawners()
{
crossfire_enemy1 = GetEntArray( "crossfire_enemy1", "targetname" );
crossfire_enemy2 = GetEntArray( "crossfire_enemy2", "targetname" );
crossfire_enemy3 = GetEntArray( "crossfire_enemy3", "targetname" );

if ( IsDefined(crossfire_enemy1) )
{
for (i = 0; i < crossfire_enemy1.size; i++)
{
if( IsDefined (crossfire_enemy1[i]) )
{
crossfire_enemy1[i] delete();
}		
}
}	

if ( IsDefined(crossfire_enemy2) )
{
for (i = 0; i < crossfire_enemy2.size; i++)
{
if( IsDefined (crossfire_enemy2[i]) )
{
crossfire_enemy2[i] delete();
}		
}
}	

if ( IsDefined(crossfire_enemy3) )
{
for (i = 0; i < crossfire_enemy3.size; i++)
{
if( IsDefined (crossfire_enemy3[i]) )
{
crossfire_enemy3[i] delete();
}		
}
}	
}*/
//////////////////////////////////////////////////////////////////////////
// 05-19-08
// wwilliams
// function will spawn the first sets of guys in the passenger train luggage area
// runs on level
car6_line_1()
{
				// endon
				level.player endon( "death" );

				// objects to be defined for the function
				// trigger
				// trig_spawn = getent( "car6_first_wave", "targetname" );

				// spawners
				enta_car6_first_spawners = getentarray( "car6_first_spawner", "targetname" );
				// trigs
				trig = getent( "trig_lookat_box_fall", "targetname" );
				// doors
				// call close on door
				// car5_exit_door_left = getent( "", "targetname" );
				car5_exit_door_right = getent( "dr_car5_r_exit", "targetname" );
				car5_exit_door_left = getent( "dr_car5_l_exit", "targetname" );
				// nodes
				// call open on node
				nodea_car5_exit = getnodearray( "auto2120", "targetname" );

				// double check define
				//assertex( isdefined( enta_car6_first_spawners ), "enta_car6_first_spawners not defined" );
				//assertex( isdefined( trig ), "trig not defined" );
				//assertex( isdefined( car5_exit_door_right ), "car5_exit_door_right not defined" );
				//assertex( isdefined( car5_exit_door_left ), "car5_exit_door_left not defined" );
				//assertex( isdefined( nodea_car5_exit ), "nodea_car5_exit not defined" );

				// wait for the freight to move to spot 3
				level flag_wait( "freight_to_node3" );

				// unbarr the car5 exit door
				// car5_exit_door_right maps\_doors::unbarred_door();

				// wait for the player to hit the trig
				// trig waittill( "trigger" );
				// wait for the jump to complete
				level waittill( "Train_Bond_Jump_done" );

				// save the game when the player gets back on the passenger train
				level maps\_autosave::autosave_by_name( "montenegrotrain", 10.0 );

				// for loop to go through the spawners
				for( i=0; i<enta_car6_first_spawners.size; i++ )
				{
								// spawner function thread off
								enta_car6_first_spawners[i] thread car6_line_1_spawn();

								// frame wait
								wait( 0.05 );
				}

				// wait
				wait( 5.0 );

				// bar the door again
				// car5_exit_door_right maps\_doors::barred_door();

}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 06-01-08
// wwilliams
// populates first line fight of car6
// function runs on the self/spawners from car6_line_1
car6_line_1_spawn()
{
				// endon
				level.player endon( "death" );

				// double check spawner settings
				//assertex( isdefined( self.script_noteworthy ), self.origin + " missing noteworthy" );

				// objects to be defined for this function
				// if the noteworthy it there grab the spawners
				noda_cover = getnodearray( self.script_noteworthy, "targetname" );
				node_tether = GetNode( "nod_bag1_tether", "targetname" );
				// undefined
				ent_temp = undefined;

				// check that the nodes have script_string
				for( i=0; i<noda_cover.size; i++ )
				{
								// make sure there is a script_string
								//assertex( isdefined( noda_cover[i].script_string ), noda_cover[i].targetname + " check script_string" );

								// frame wait
								wait( 0.05 );
				}

				// make the count of the spawner the same as the node array
				self.count = noda_cover.size;

				// for loop for the spawns
				for( i=0; i<noda_cover.size; i++ )
				{
								// spawn out a guy
								ent_temp = self stalingradspawn( "car6_enemy" );

								// check if spawn failed
								if( spawn_failed( ent_temp ) )
								{
												// debug text
												iprintlnbold( self.targetname + " fail spawn" );

												// wait
												wait( 5.0 );

												// end function
												return;
								}

								// set the guy up
								ent_temp setalertstatemin( "alert_red" );
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );

								// give him his mind
								ent_temp SetCombatRole( noda_cover[i].script_string );

								// give him sense for a while
								ent_temp thread maps\MontenegroTrain_util::turn_on_sense( 5 );

								// send this guy to a node
								ent_temp setgoalnode( noda_cover[i], 1 );

								if( noda_cover[i].script_string != "rusher" )
								{
												// give him a tether at goal
												ent_temp thread maps\MontenegroTrain_util::train_reset_speed_activate_tether( node_tether, 384, 1200, 256 );
								}

								// wait
								wait( 1.0 );
				}
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
// 06-01-08
// wwilliams
// function controls the second wave of car6
// these guys come running in after bond has entered
// runs on level
car6_line_2()
{
				// endon
				level.player endon( "death" );

				// objects to be defined for this function
				// trigs
				trig_line2_setup = getent( "player_at_car_6", "targetname" );
				// spawners
				spawner_car6_line_2 = getent( "spwn_car6_line2", "targetname" );
				// node
				node_tether = GetNode( "nod_bag1_tether", "targetname" );
				// undefined
				ent_temp = undefined;

				// frame wait
				wait( 0.05 );

				// make sure the spawner is defined
				//assertex( isdefined( spawner_car6_line_2 ), "spawner_car6_line_2 not defined" );
				//assertex( isdefined( spawner_car6_line_2.script_parameters ), "spawner_car6_line_2.script_parameters not defined" );
				//assertex( isdefined( trig_line2_setup ), "trig_line2_setup not defined" );

				// nodes
				noda_car6_line_2 = getnodearray( spawner_car6_line_2.script_parameters, "targetname" );

				// make sure node array is defined
				//assertex( isdefined( noda_car6_line_2 ), "noda_car6_line_2 not defined" );

				// make sure the count is right
				spawner_car6_line_2.count = noda_car6_line_2.size;

				// wait for the trigger
				trig_line2_setup waittill( "trigger" );

				// thread off the rusher spawn
				level thread car6_rusher_drop();

				// spawn out the wave
				for( i=0; i<noda_car6_line_2.size; i++ )
				{
								// spawn out a guy 
								ent_temp = spawner_car6_line_2 stalingradspawn( "car6_enemy" );

								// check to see if spawn failed
								if( spawn_failed( ent_temp ))
								{
												// debug text
												iprintlnbold( "spawn fail in line2" );

												// wait
												wait( 5.0 );

												// end function
												return;
								}

								// guy spawned properly
								// set him up
								ent_temp setalertstatemin( "alert_red" );
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );

								// give perfect sense for a few secs
								ent_temp thread maps\MontenegroTrain_util::turn_on_sense( 5 );

								// set goal node
								ent_temp setgoalnode( noda_car6_line_2[i] );

								// check to see if the node has a script_string
								if( isdefined( noda_car6_line_2[i].script_string ) && noda_car6_line_2[i].script_string != "rusher" )
								{
												// set the combat role of the guy to the node script_string
												ent_temp SetCombatRole( noda_car6_line_2[i].script_string );

												// give him a tether at goal
												ent_temp thread maps\MontenegroTrain_util::train_reset_speed_activate_tether( node_tether, 384, 1200, 256 );
								}
								// if not make him a flanker
								else
								{
												// default to flanker
												ent_temp SetCombatRole( "flanker" );

												// give him a tether at goal
												ent_temp thread maps\MontenegroTrain_util::train_reset_speed_activate_tether( node_tether, 384, 1200, 256 );
								}


								// wait
								wait( 1.5 );

								// undefine ent_temp
								ent_temp = undefined;
				}


				// clean up stuff here
				spawner_car6_line_2 delete();
}
//////////////////////////////////////////////////////////////////////////////////////////////////////////
// 06-03-08
// wwilliams
// function controls the rusher than will jump down into the car
car6_rusher_drop()
{
				// endon
				level.player endon( "death" );

				// objects to be defined for this function
				// spawner
				spwn_car6_rusher = getent( "spwn_car6_rusher", "targetname" );

				// make sure there is a target for the spawner
				// assertex( isdefined( spwn_car6_rusher.target ), "spwn_car6_rusher no target" );

				// iprintlnbold( "inside car6 rusher" );

				// define the node
				// destin_node = getnode( spwn_car6_rusher.target, "targetname" );
				// undefined
				ent_temp = undefined;

				// spawn the guy out
				ent_temp = spwn_car6_rusher stalingradspawn( "car6_enemy" );

				// check that the guy didn't fail
				if( spawn_failed( ent_temp ) )
				{
								// debug text
								iprintlnbold( "spwn_car6_rusher fail spawn" );

								// wait
								wait( 5.0 );

								// end the function
								return;
				}

				// iprintlnbold( "spawned car6 rusher" );

				// set up the guy
				ent_temp setalertstatemin( "alert_red" );
				ent_temp setengagerule( "tgtSight" );
				ent_temp addengagerule( "tgtPerceive" );
				ent_temp addengagerule( "Damaged" );
				ent_temp addengagerule( "Attacked" );

				// turn on sense for the run
				ent_temp thread maps\MontenegroTrain_util::turn_on_sense( 5 );

				// send the guy to the node shooting at the player
				//	ent_temp setgoalnode( destin_node, 1 );

}