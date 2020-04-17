




#include maps\_utility;




e4_main()
{
				thread spawn_crossfire_enemies();
				thread start_passing_contraband();

				
				

				
				
				
				
				level thread e4_passenger_jump_back();
				

				
				level waittill( "in_car_4" );
				thread maps\MontenegroTrain_car5::e5_main();
}




spawn_crossfire_enemies()
{
				

				
				
				
				
				

				
				

				
				level thread car4_enemy_announce();

				
				level thread car4_crossfire();

				


				

}



start_passing_contraband()
{
				contraband_trig_end = GetEnt("contraband_trig_end", "targetname");
				
				
				
				
				trig_stop_train_contraband = getent( "trig_get_contraband_ready", "targetname" );

				
				if( isdefined( trig_stop_train_contraband ) )
				{
								
								trig_stop_train_contraband waittill( "trigger" );

								
								
								level.freight_train_active = false;
								level flag_clear( "freight_train_active" );

								
								
								
								while( flag( "freight_train_moving" ) )
								{
												
												wait( 0.05 );
								}
								
								
								
								
								
								

				}
				else
				{
								
								iprintlnbold( trig_stop_train_contraband + " not defined!" );

								
								return;
				}


				if ( IsDefined(contraband_trig_end) )
				{
								contraband_trig_end waittill("trigger");
								thread Open_contraband_door();
				}

}


Open_contraband_door()
{
				

				
				level.door_busy = true;

				
				
				
				
				trig_move_to_train2 = getent( "trig_move_from_train2", "targetname" );

				
				
				
				level flag_set( "freight_door_busy" );

				while( level.train_moving == true )
				{
								wait(0.05);
				}
				
				
				
				
				
				
				
				
				
				
				

				
				level flag_set( "car4_boxcar_surprise" );

				
				
				
				
				level.freight_door1_right unlink();
				
				level.freight_door1_left unlink();

				
				
				level.freight_door1_right rotateyaw( 120, 2.0 );

				
				level notify( "wave_1_fire" );

				
				level.freight_door1_right playsound("container_doors_open");
				

				
				level.freight_door1_left rotateyaw( -120, 2.0 );
				

				
				level.freight_door1_left waittill( "rotatedone" );

				
				
				level.freight_door1_right linkto( getent( level.freight_door1_right.target, "targetname" ) );
				
				level.freight_door1_left linkto( getent( level.freight_door1_left.target, "targetname" ) );

				
				level.door_busy = false;
				
				
				
				level flag_clear( "freight_door_busy" );

				
				level.player play_dialogue_nowait( "BDMR_TraiG_032A" );
				level.player play_dialogue_nowait( "BDMR_TraiG_033A" );

				
				
				
				if( isdefined( trig_move_to_train2 ) )
				{
								
								
								trig_move_to_train2 waittill( "trigger" );

								
								
								

								
								level thread car4_container_panel_control();

								

								
								
								
								
								
								
								
								
								
								
								
								deleteallcorpses( 1 );

								
								while( !level.player isonground() )
								{
									wait(0.05);
								}
								
								
								
								level flag_set( "freight_to_node3" );
				}
				else
				{
								
								iprintlnbold( "trig_move_to_train2 not found" );
				}

}	





car4_container_panel_control()
{
				

				
				
				level.car4_panel = undefined;
				
				sbrush_container_panel_0 = getent( "e4_container_hole_0", "script_noteworthy" );
				sbrush_container_panel_1 = getent( "e4_container_hole_1", "script_noteworthy" );
				sbrush_container_panel_2 = getent( "e4_container_hole_2", "script_noteworthy" );
				
				sbrush_container_panel_d_0 = getent( "e4_container_hole_d_0", "script_noteworthy" );
				sbrush_container_panel_d_1 = getent( "e4_container_hole_d_1", "script_noteworthy" );
				sbrush_container_panel_d_2 = getent( "e4_container_hole_d_2", "script_noteworthy" );
				
				fx = [];

				
				
				
				
				
				
				

				




				
				





				
				level.car4_panel = level.player;

				
				level notify( "first_uncouple_start" );
				level notify( "e4_container_shoot_done" );
}





e4_container_shooting_init()
{
				

				
				
				spawner_top = getent( "spwn_car4_top", "targetname" );
				spawner_bottom = getent( "spwn_car4_bottom", "targetname" );
				
				noda_top_spots = getnodearray( "nod_top_shoot_container", "script_noteworthy" );
				noda_bottom_spots = getnodearray( "nod_bottom_shoot_container", "script_noteworthy" );
				
				ent_temp = undefined;

				
				assertex( isdefined( spawner_top ), "spawner_top not defined" );
				assertex( isdefined( spawner_bottom ), "spawner_bottom not defined" );
				assertex( isdefined( noda_top_spots ), "noda_top_spots not defined" );
				assertex( isdefined( noda_bottom_spots ), "noda_bottom_spots not defined" );

				
				spawner_top.count = noda_top_spots.size;
				spawner_bottom.count = noda_bottom_spots.size;

				
				for( i=0; i<noda_top_spots.size; i++ )
				{
								
								ent_temp = spawner_top stalingradspawn( "e4_container_shooter" );

								
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												
												iprintlnbold( "spawner_top in e4 fail" );

												
												wait( 2.0 );

												
												return;
								}
								else
								{
												
												
												ent_temp setperfectsense( true );

												
												wait( 0.05 );

												
												ent_temp setgoalnode( noda_top_spots[i], 1 );

												
												ent_temp setscriptspeed( "run" );

												
												ent_temp setalertstatemin( "alert_red" );

												
												ent_temp thread maps\MontenegroTrain_util::train_goal_n_tether( noda_top_spots[i], 128 );

												
												level thread bottom_shooter_control( ent_temp, spawner_top, noda_top_spots[i] );

												
												level thread train_car4_cleaner( ent_temp );
												
												
												wait( 0.05 );
								}

								
								wait( 1.5 );

								
								ent_temp = undefined;
				}

				
				for( i=0; i<noda_bottom_spots.size; i++ )
				{
								
								ent_temp = spawner_bottom stalingradspawn( "e4_container_shooter" );

								
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												
												iprintlnbold( "spawner_bottom in e4 fail" );

												
												wait( 2.0 );

												
												return;
								}
								else
								{
												
												ent_temp thread maps\MontenegroTrain_util::turn_on_sense( 3 );

												
												wait( 0.05 );

												
												ent_temp setgoalnode( noda_bottom_spots[i], 1 );

												
												ent_temp setscriptspeed( "run" );

												
												ent_temp setalertstatemin( "alert_red" );

												
												ent_temp thread maps\MontenegroTrain_util::train_goal_n_tether( noda_top_spots[i], 128 );

												
												level thread bottom_shooter_control( ent_temp, spawner_bottom, noda_bottom_spots[i] );

												
												level thread train_car4_cleaner( ent_temp );

												
												wait( 0.05 );
								}

								
								wait( 1.5 );

								
								ent_temp = undefined;
				}

}





top_shooter_control( ent_actor, ent_spawner, node_spot )
{
				
				level endon( "e4_container_shoot_done" );

				
				assertex( isdefined( ent_actor ), "top_shooter ent_actor not defined" );
				assertex( isdefined( ent_spawner ), "top_shooter ent_spawner not defined" );
				assertex( isdefined( node_spot ), "top_shooter node_spot not defined" );

				
				while( 1 )
				{
								
								ent_actor waittill( "goal" );
								
								

								
								while( isalive( ent_actor ) )
								{
												
												if( isalive( ent_actor ) )
												{
																
																ent_actor cmdshootatentity( level.player, true, 3, 0.8 );

																
																ent_actor waittill("cmd_done");

																
																

																
																wait( 0.05 );
}	

												
												wait( randomint( 2 ) );
								}

								
								ent_actor = level thread car4_spawn_another_guy( ent_spawner, 1 );

								
								if( !isdefined( ent_actor ) )
								{
												
												

												
												wait( 2.0 );

												
												return;
								}

								
								ent_actor setperfectsense( true );

								
								ent_actor setgoalnode( node_spot, 1 );

				}
}





bottom_shooter_control( ent_actor, ent_spawner, node_spot )
{
				
				level endon( "e4_container_shoot_done" );
				
				assertex( isdefined( ent_actor ), "bottom_shooter ent_actor not defined" );
				assertex( isdefined( ent_spawner ), "bottom_shooter ent_spawner not defined" );
				assertex( isdefined( node_spot ), "bottom_shooter node_spot not defined" );

				
				while( 1 )
				{
								
								ent_actor waittill( "goal" );

								

								
								while( isalive( ent_actor ) )
								{
												
												if( isalive( ent_actor ) )
												{
																if( ent_actor cansee( level.player ) )
																{
																				
																				
																				ent_actor cmdshootatentity( level.player, true, 5, 0.7 );

																				
																				ent_actor waittill("cmd_done");

																				
																				

																				
																				wait( 0.05 );
																}
																
												}

												
												wait( randomint( 2 ) );
								}

								
								ent_actor = level thread car4_spawn_another_guy( ent_spawner, 0 );

								
								if( !isdefined( ent_actor ) )
								{
												
												

												
												wait( 2.0 );

												
												return;
								}

								
								ent_actor thread maps\MontenegroTrain_util::turn_on_sense( 2 );

								
								ent_actor setgoalnode( node_spot, 1 );

				}
}





car4_spawn_another_guy( spawner, int_floor )
{
				
				assertex( isdefined( spawner ), "another_guy spawner not valid!" );
				assertex( isdefined( int_floor ), "another_guy int_floor not valid!" );

				
				
				ent_temp = undefined;

				
				if( int_floor == 0 )
				{
								
								while( maps\_utility::flag( "car4_bottom_spawner" ) )
								{
												
												wait( 0.25 );
								}
				}
				else if( int_floor == 1 )
				{
								
								while( maps\_utility::flag( "car4_top_spawner" ) )
								{
												
												wait( 0.25 );
								}
				}

				
				if( int_floor == 0 )
				{
								
								maps\_utility::flag_set( "car4_bottom_spawner" );

								
								if( spawner.count <= 1 )
								{
												
												spawner.count = 5;
								}

								
								ent_temp = spawner stalingradspawn( "e4_container_shooter" );

								
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												
												iprintlnbold( "fail spawn in _another_guy" + spawner.targetname );

												
												wait( 2.0 );

												
												return;
								}
								
								{
												
												wait( 1.0 );

												
												maps\_utility::flag_clear( "car4_bottom_spawner" );

												
												level thread train_car4_cleaner( ent_temp );

												
												return ent_temp;
								}
				}
				else if( int_floor == 1 )
				{
								
								maps\_utility::flag_set( "car4_top_spawner" );

								
								if( spawner.count <= 1 )
								{
												
												spawner.count = 5;
								}

								
								ent_temp = spawner stalingradspawn( "e4_container_shooter" );

								
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												
												iprintlnbold( "fail spawn in _another_guy with " + spawner.targetname );

												
												wait( 2.0 );

												
												return;
								}
								
{
												
												wait( 1.0 );

												
												maps\_utility::flag_clear( "car4_top_spawner" );

												
												return ent_temp;
								}
				}
}




train_3d_text( ent_spot, seconds, str_text, vec_color, str_notify, int_alpha, flt_scale )
{
				
				level endon( "no_more_3d" );

				
				assertex( isdefined( ent_spot ), "ent_spot not defined" );
				assertex( isdefined( seconds ), "seconds not defined" );
				assertex( isdefined( str_text ), "str_text not defined" );
				assertex( isdefined( vec_color ), "vec_color not defined" );
				assertex( isdefined( str_notify ), "str_notify not defined" );
				assertex( isdefined( int_alpha ), "int_alpha not defined" );
				assertex( isdefined( flt_scale ), "flt_scale not defined" );

				
				vec_text_position = ent_spot.origin;


				if( !isdefined( str_notify ) )
				{
								str_notify = "no_notify";
				}
				if( !isdefined( int_alpha ) )
				{
								alpha = 1;
				}
				if( !isdefined( flt_scale ) )
				{
								scale = 0.5;
				}
				timer = GetTime() + seconds;
				while( GetTime() < timer )
{
								
								print3d( vec_text_position, str_text, vec_color, int_alpha, flt_scale );
wait(0.05);
}
}





train_car4_cleaner( ent_actor )
{
				
				assertex( isdefined( ent_actor ), "ent_actor is not defined" );

				
				ent_actor endon( "death" );

				
				level waittill( "e4_container_shoot_done" );

				
				ent_actor setenablesense( false );

				
				ent_actor hide();

				
				ent_actor delete();
}






e4_passenger_jump_back()
{
				
				
				level endon( "Train_Bond_Jump_done" );

				
				
				trig = getent( "trig_play_jump_anim", "targetname" );
				
				look_at_trig = getent( "trig_lookat_box_fall", "targetname" );

				
				assertex( isdefined( trig ), "jump trig not defined" );
				assertex( isdefined( look_at_trig ), "trig for jump box drop not defined" );

				
				level thread e4_jump_trigger_hint( trig );

				
				look_at_trig waittill( "trigger" );

				
				level notify( "jump_break_start" );

				
				
				thread maps\montenegrotrain_snd::crate_fall_sounds();

				
				trig waittill( "trigger" );

				
				while( 1 )
				{
								
								if( level.player istouching( trig ) )
								{
												
												while( level.player istouching( trig ) )
												{
																
																if( level.player JumpButtonPressed() )
																{
																				
																				
																				deleteallcorpses( 1 );

																				
																				playcutscene( "Train_Bond_Jump", "Train_Bond_Jump_done" );

																				
																				level notify( "jump_trig_hint_off" );

																				
																				level notify( "endmusicpackage" );

																				
																				level thread train_jump_back_dialogue();

																				
																				level.player playsound("igc_jump_from_freight");

																				
																				level waittill( "Train_Bond_Jump_done" );

																				
																				
																				level maps\_autosave::autosave_now( "montenegrotrain" );

																				
																				return;
																}

																
																wait( 0.05 );
												}
								}

								
								wait( 0.05 );
				}

				

}



e4_jump_trigger_hint( trig )
{
				
				level endon( "jump_trig_hint_off" );

				
				assertex( isdefined( trig ), "trig for jump back not defined" );

				
				level thread e4_jump_trigger_hint_off( trig );

				
				while( 1 )
				{
								
								trig waittill( "trigger" );

								
								while( level.player istouching( trig ) )
								{
												
												level.player SetCursorHint( "HINT_JUMP" );
												level.player SetHintString( &"HINT_JUMP" );

												
												wait( 0.05 );

								}

								
								
								level.player SetCursorHint( "" );
								level.player SetHintString( "" );

								
								wait( 0.05 );
				}

}



e4_jump_trigger_hint_off( trig )
{
				
				

				
				assertex( isdefined( trig ), "trig for jump back not defined" );

				
				level waittill( "jump_trig_hint_off" );

				
				level.player SetCursorHint( "" );
				level.player SetHintString( "" );
}





train_jump_back_dialogue()
{
				
				

				
				level.player play_dialogue( "TANN_TraiG_046A", true );

				
				level.player play_dialogue( "BOND_TraiG_047A" );

				
				level.player play_dialogue( "TANN_TraiG_048A", true );
}























car4_enemy_announce()
{
				

				
				
				car4_notify_spwn = getent( "car4_notify_spwn", "targetname" );
				
				car4_notify_guy = undefined;
				
				
				
				
				
				
				
				car4_notify_node = getnode( "nod_car4_notify", "targetname" );
				
				spot_trig = getent( "trig_car4_spot", "targetname" );
				
				sc_announcer_shoot = getent( car4_notify_node.target, "targetname" );

				
				
				
				
				
				

				
				level flag_wait( "on_freight_train" );

				
				car4_announcer = car4_notify_spwn stalingradspawn();

				
				if( spawn_failed( car4_announcer ) )
				{
								
								iprintlnbold( "car4_announcer_failed_spawn" );

								
								return;
				}
				else
				{
								
								car4_announcer endon( "death" );
				}

				
				car4_announcer setenablesense( false );

				
				
				
				car4_announcer setpropagationdelay( 0 );

				
				
				
				car4_announcer setscriptspeed( "run" );

				
				
				
				
				car4_announcer settetherradius( 128 );

				
				
				
				
				car4_announcer.tetherpt = car4_notify_node.origin;

				
				
				
				
				
				
				car4_announcer setgoalnode( car4_notify_node );

				
				car4_announcer allowedstances( "crouch" );

				
				spot_trig waittill( "trigger" );

				
				

				
				
				
				

				
				car4_announcer allowedstances( "stand" );

				
				car4_announcer setenablesense( true );

				
				car4_announcer setcombatrole( "turret" );
				car4_announcer setengagerule( "tgtSight" );
				car4_announcer addengagerule( "tgtPerceive" );
				car4_announcer addengagerule( "Damaged" );
				car4_announcer addengagerule( "Attacked" );

				
				car4_announcer play_dialogue_nowait( "TMR3_TraiG_030A" );

				car4_announcer play_dialogue_nowait( "TMR4_TraiG_031A" );

				
				car4_announcer thread maps\MontenegroTrain_util::turn_on_sense( 5 );

				
				car4_announcer cmdshootatentity( level.player, false, 3, 0.3, true );

				
				wait( 3.0 );

				
			

				

}







car4_crossfire()
{
				
				

				
				
				spawner_bottom = getent( "spwn_car4_bottom", "targetname" );
				spawner_top = getent( "spwn_car4_top", "targetname" );
				
				e4_dood = undefined;
				
				car4_noda_bottom = getnodearray( spawner_bottom.script_parameters, "targetname" );
				car4_noda_top = getnodearray( spawner_top.script_parameters, "targetname" );
				
				trig_top_crossfire = getent( "trig_car4_spot", "targetname" );
				trig_lower_crossfire = getent( "trig_spwn_bottom_crossfire", "targetname" );

				
				
				spawner_bottom.count = car4_noda_bottom.size;
				
				spawner_top.count = car4_noda_top.size;

				
				
				
				
				

				
				
				trig_top_crossfire waittill( "trigger" );

				
				
				for( i=0; i<car4_noda_bottom.size; i++ )
				{
								
								e4_dood = spawner_bottom stalingradspawn( "e4_dood" );

								
								if( spawn_failed( e4_dood ) )
								{
												
												iprintlnbold( "spawner_bottom_spawn_fail_on_loop " + i + "" );

												
												break;
								}

								
								
								e4_dood setengagerule( "tgtSight" );
								e4_dood addengagerule( "tgtPerceive" );
								e4_dood addengagerule( "Damaged" );
								e4_dood addengagerule( "Attacked" );

								
								e4_dood setalertstatemin( "alert_red" );

								
								e4_dood setscriptspeed( "run" );

								
								e4_dood setgoalnode( car4_noda_bottom[i] );

								
								
								
								
								e4_dood settetherradius( 64 );

								
								
								
								e4_dood.tetherpt = car4_noda_bottom[i].origin;

								
								wait( 1.0 );

								
								e4_dood = undefined;
				}
				

				
				
				
				

				
				trig_lower_crossfire waittill( "trigger" );

				
				
				for( i=0; i<car4_noda_top.size; i++ )
				{
								
								e4_dood = spawner_top stalingradspawn( "e4_dood" );

								
								if( spawn_failed( e4_dood ) )
								{
												
												iprintlnbold( "spawner_bottom_spawn_fail_on_loop " + i + "" );

												
												break;
								}

								
								
								e4_dood setengagerule( "tgtSight" );
								e4_dood addengagerule( "tgtPerceive" );
								e4_dood addengagerule( "Damaged" );
								e4_dood addengagerule( "Attacked" );
								
								
								
								
								
								
								

								
								e4_dood setalertstatemin( "alert_red" );

								
								e4_dood setscriptspeed( "run" );

								
								e4_dood thread maps\MontenegroTrain_util::turn_on_sense( 5 );

								
								e4_dood setgoalnode( car4_noda_top[i], 1 );

								
								
								
								
								e4_dood settetherradius( 48 );

								
								
								
								e4_dood.tetherpt = car4_noda_top[i].origin;

								
								wait( 1.0 );

								
								e4_dood = undefined;
				}
				

				
				
				
				
				

}



obs_car_fight_cleanup()
{
				

				
				
				
}






car4_watch_for_player()
{
				
				self endon( "death" );

				
				self waittill( "start_propagation" );

				
				if( flag( "car4_player_spotted" ) )
				{
								
								return;
				}
				else
				{
								flag_set( "car4_player_spotted" );
				}
}







train_engage_after_goal()
{
				
				self endon( "death" );
				level.player endon( "death" );

				
				self waittill( "goal" );

				
				self setengagerule( "tgtSight" );
				
				
				
				
				
				
				self addengagerule( "tgtPerceive" );
				self addengagerule( "Damaged" );
				self addengagerule( "Attacked" );
}