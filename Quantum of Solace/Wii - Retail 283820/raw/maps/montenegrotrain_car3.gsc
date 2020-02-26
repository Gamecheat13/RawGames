




#include maps\_utility;




e3_main()
{
				thread load_car3_thugs();

				
				level.seen_on_roof = false;
				thread roof_glass_setup();

				
				
				
				level thread car3_table_drop_trigs();


				
				level maps\_utility::flag_wait( "on_freight_train" );
				level thread maps\MontenegroTrain_car4::e4_main();
				level thread remove_train1_civilians();
}





remove_train1_civilians()
{
				civ1_array = getentarray("train1_civilian", "script_noteworthy");

				
				
				
				
				
				level flag_set( "clean_car_1" );

				
				wait( 1.0 );
				

				for (i = 0; i < civ1_array.size; i++)
				{
								if( IsDefined (civ1_array[i]) )
								{
												civ1_array[i] delete();

												
								}		
				}
} 




load_car3_thugs()
{
				trig = GetEnt( "car3_spawner", "targetname" );
				if ( IsDefined(trig) )
				{
								trig waittill ("trigger");

								spawners = GetEntArray( "car3_thugs", "targetname" );
								if ( IsDefined(spawners) )
								{
												for (i=0; i<spawners.size; i++)
												{
																spawners[i] StalingradSpawn( "car3_enemy" );
												}
								}
				}
				else
				{
								iPrintLnBold( "car 3 spawn trig not found" );
				}

				
				
				
				
				level thread clean_car3_thugs();
				
				
				
				
				
				
}








clean_car3_thugs()
{
				
				

				
				
				enta_car3_thugs = getentarray( "car3_enemy", "targetname" );

				
				level flag_wait( "on_freight_train" );

				
				level remove_dead_from_array( enta_car3_thugs );

				
				
				if( enta_car3_thugs.size == 0 )
				{
								

								
								return;
				}

				
				for( i=0; i<enta_car3_thugs.size; i++ )
				{
								
								if( isalive( enta_car3_thugs[i] ) )
								{
												
												if( enta_car3_thugs[i] getalertstate() == "alert_red" )
												{
																
																break;
												}
												else
												{
																
																enta_car3_thugs[i] hide();

																
																enta_car3_thugs[i] delete();
												}
								}
				}
}





roof_glass_setup()
{
				
	
				
				car3_roof_glass = getentarray( "car_roof_windows", "script_noteworthy" );

				
				if( isdefined( car3_roof_glass ) )
				{
								
								for( i=0; i<car3_roof_glass.size; i++ )
								{
												
												level thread player_on_glass( car3_roof_glass[i] );

												
								}
				}		

				
				
				
				
				
				
				
				
				
				
				
				level.jump_trig = GetEnt("freight_jump_trig", "targetname");
				
				thread jump_to_freight();
}




player_on_glass( sbrush_glass )
{
				
				sbrush_glass endon( "death" );

				
				

				
				enemy = getentarray( "car3_enemy", "targetname" );

				
				assertex( isdefined( sbrush_glass ), "sbrush_glass not defined" );

				

				
				while( level.seen_on_roof == false )
				{	

								

								
								while( !level.player istouching( sbrush_glass ) )
								{
												
												wait( 0.05 );
								}

								
								while( level.player istouching( sbrush_glass ) )
								{
												iprintlnbold( "player on glass!" );

												
												if( sbrush_glass.health > 0 )
												{
																
																sbrush_glass.health = sbrush_glass.health - 15;

																
																wait( .10 );

																iprintlnbold( "glass damaged, health at " + sbrush_glass.health );
												}
												else
				{	
																
																
																level thread fail_timer_glass();
																
																
																level thread check_car3_alert( enemy );
												}
								}

								
								wait( 0.05 );

								
								
								
								
								
								
								
								
				}	
}




roof_glass_timer(seconds, trig)
{
				
				level endon("off_glass");
				level.player endon("death");

				
				enemy = getentarray("car3_enemy", "targetname");
				
				for (i = 0; i < enemy.size; i++)
				{
								
								
								if(enemy[i] getalertstate() != "alert_red")
								{
												
												enemy[i] SetAlertStateMin( "alert_yellow" );
												
								}	
				}

				
				
				trig thread end_timer_glass();
				
				trig thread fail_timer_glass();
				
				thread check_car3_alert(enemy);

				
				for(i = seconds; i > -1; i--)
				{
								
								wait(0.5);
				}
				
				level notify("glass_limit_reached");
}


end_timer_glass()
{
				
				level endon("glass_limit_reached");
				level.player endon("death");

				
				
				while(level.player istouching(self) )
				{	
								
								wait(0.05);
				}
				
				level notify("off_glass");

				
				
				self thread player_on_glass();

				
				
				enemy = getentarray("car3_enemy", "targetname");
				
				for (i = 0; i < enemy.size; i++)
				{
								
								if(enemy[i] getalertstate() != "alert_red")
								{
												
												enemy[i] SetAlertStateMin( "alert_green" );
												
												enemy[i] LockAlertState( "alert_green" );
												
												enemy[i] UnlockAlertState();
												
								}
				}
}




fail_timer_glass()
{
				
				level.player endon("death");

				
				level waittill("glass_limit_reached");

				
				
				enemy = getentarray("car3_enemy", "targetname");

				
				if(level.seen_on_roof == false)
				{	
								
								
								
								int_random = randomint( 10 );
								if( int_random < 5 )
								{
												if( isalive( enemy[0] ) )
												{
																
																enemy[0] maps\MontenegroTrain_util::train_play_dialogue( "TMR1_TraiG_027A" );
												}
								}
								else
								{
												if( isalive( enemy[0] ) )
												{
																
																enemy[0] maps\MontenegroTrain_util::train_play_dialogue( "TMR1_TraiG_027B" );
												}
								}

							
								
								level notify( "playmusicpackage_action1" );
								

								level.seen_on_roof = true;
				}

				
				
				enemy = remove_dead_from_array( enemy );
				
				self thread fire_through_roof(enemy);
				
				if( isalive( enemy[1] ) )
				{
								
								enemy[1] thread maps\MontenegroTrain_util::train_play_dialogue( "TMR2_TraiG_028A" );
				}
				
				for (i = 0; i < enemy.size; i++)
				{
								
								enemy[i] CmdShootAtEntity(level.player, true, 2, 0.5);
								
								enemy[i] LockAlertState( "alert_red" );
				}
}





fire_through_roof(enemy)
{		
				
				level endon ("stop_roof_bullets");

				
				i=0;
				
				fx2 = [];

				
				while ( level.player istouching(self) && enemy.size > 0 )
				{
								
								
								
								
								
								x = randomfloatrange(-10.0,10.0);
								
								y = randomfloatrange(20.0,80.0);
								
								firepos = level.player.origin + ( x, y, 3 );
								
								hitpos = firepos + ( x, y, -3);

								
								magicbullet("p99_s", firepos, hitpos);
								
								fx = playfx( level._effect["fx_metalhit_lg"], hitpos);

								
								wait(randomfloatrange(0.2,1.0));
								
								i++;
				}	
}	





check_car3_alert(enemy)
{
				
				
				
				if( isdefined( enemy ) )
				{
								
								for( i=0; i<enemy.size; i++ )
								{
												
												enemy[i] endon( "death" );
								}
				}
				
				else
				{
								
								iprintlnbold( "fail_in_check_car3_alert" );
								
								return;
				}

				
				enemy_alerted = false;
				
				while (enemy_alerted == false)
				{
								
								for (i = 0; i < enemy.size; i++)
								{
												
												if(enemy[i] getalertstate() == "alert_red")
												{
																
																enemy_alerted = true;
																
																
																
																
																
												}
								}	
								
								wait(1.0);
				}		
}



car3_see_player_init()
{
				

				
				enta_car3_enemies = getentarray( "car3_enemy", "targetname" );

				
				assertex( isdefined( enta_car3_enemies ), "enta_car3_enemies not defined" );

				
				for( i=0; i<enta_car3_enemies.size; i++ )
				{
								
								
				}

}



car3_see_player()
{
				
				
				self endon( "damage" );
				self endon( "death" );

				
				while( 1 )
				{
								
								if( self getalertstate() == "alert_red" )

								{
												
												return;
								}

								
								if( self cansee( level.player ) == true )
								{
												
												iprintlnbold( "enemy at " + self.origin + " cansee player" );

												
												level notify( "playmusicpackage_action1" );

								}

								
								wait( 0.05 );
				}
}








car3_table_drop_trigs()
{
				
				

				
				
				enta_table_drop_trig = getentarray( "train_table_drop", "targetname" );

				
				assertex( isdefined( enta_table_drop_trig ), "enta_table_drop_trig not defined" );

				
				for( i=0; i<enta_table_drop_trig.size; i++ )
				{
								
								enta_table_drop_trig[i] thread car3_table_init();

								
								wait( 0.05 );
				}

}





car3_table_init()
{
				
				

				
				assertex( isdefined( self.target ), "table_drop trig missing target" );

				
				smodel_table = getent( self.target, "targetname" );

				
				assertex( isdefined( smodel_table.target ), "smodel_table missing target" );

				
				smodel_collision = getent( smodel_table.target, "targetname" );

				
				while( 1 )
				{
								
								self waittill( "trigger", ent_guy );

								
								if( ent_guy == level.player )
								{
												
												if( ent_guy.origin[2] > smodel_table.origin[2] )
												{
																
																physicsExplosionSphere( level.player.origin + ( 0, 0, -10 ), 75, 55, 1.0 );

																
																smodel_collision delete();

																
																smodel_table moveto( smodel_table.origin + ( 0, 0, -30 ), 0.5 );

																
																smodel_table waittill( "movedone" );

																
																earthquake( 0.2, 0.7, level.player.origin, 48 );

																
																level thread car3_clean_self_up( self );

																
																return;
												}
												else
												{
																
																continue;
												}
								}

								
								if( ent_guy != level.player )
								{
												
												smodel_collision delete();

												
												
												smodel_table moveto( smodel_table.origin + ( 0, 0, -30 ), 0.5 );

												
												smodel_table waittill( "movedone" );

												
												level thread car3_clean_self_up( self );

												
												return;
								}

								
								wait( 0.05 );
				}
}






car3_clean_self_up( delete_ent )
{
				
				if( isdefined( delete_ent ) )
				{

								
								wait( 5.0 );

								
								delete_ent delete();
				}
				
				else
				{

								
								return;
				}
}




jump_to_freight()
{
				if ( IsDefined( level.jump_trig ) )
				{
								level.jump_trig waittill("trigger");
								level.on_freight_train = true;
								
								
								
								
								
								

								
								
								level flag_set( "on_freight_train" );

								
								level maps\_autosave::autosave_now( "montenegrotrain" );

								
								
								
								
								
								
								

								
								
								
								
								
								
								level notify("stop_roof_bullets");

								
								level notify( "endmusicpackage" );

								wait(2.0);
							

				}	
}





e3_player_position()
{
				

				
				
				trig = getent( "ent_trig_in_car3" );

				
				
				
				
				

				
				
				while( level.on_freight_train == false )
				{
								
								if( level.player istouching( trig ) )
								{
												
												level flag_clear( "outside_train" );
								}
								else
								{
												
												level flag_set( "outside_train" );
								}

				}
}
