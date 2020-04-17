




#include maps\_utility;
#include common_scripts\utility;

#include animscripts\Utility;
#include animscripts\shared;
#include maps\_anim;
#using_animtree("generic_human");





train_shake_inside()
{
				while(level.inside_train == true)
				{
								timer = randomfloatrange(1.5, 3.0);
								shake_amount = randomfloatrange(0.01, 0.07);
								
								earthquake (shake_amount, timer, level.player.origin, 1000);

								
								thread Maps\MontenegroTrain_snd::play_shake_int(shake_amount);

								wait(timer);
								
				}	
				thread train_shake_outside();
}	
train_shake_outside()
{
				while(level.inside_train == false)
				{
								timer = randomfloatrange(1.5, 3.0);
								blur_amount = randomfloatrange(0.0, 1.5);
								

								
								shake_amount = (blur_amount * 0.1);
								if (shake_amount < 0.05)
								{
												shake_amount = 0.05;
								}	

								setblur( blur_amount, timer );			
								earthquake (shake_amount, timer, level.player.origin, 1000);

								
								thread Maps\MontenegroTrain_snd::play_shake_ext(shake_amount);

								wait(timer);
								
								
				}	
				thread train_shake_inside();
				setblur( 0.0, 1.0 );
}	
setup_environmental_trigs()
{
				trig_out = GetEntArray( "exterior_trig", "script_noteworthy" );
				trig_in = GetEntArray( "interior_trig", "script_noteworthy" );

				if ( IsDefined(trig_out) )
				{
								for (i=0; i<trig_out.size; i++)
								{
												thread change_environmentalfx_outside(trig_out[i]);
								}
				}		
				if ( IsDefined(trig_in) )
				{
								for (i=0; i<trig_in.size; i++)
								{
												thread change_environmentalfx_inside(trig_in[i]);
								}
				}		
}
change_environmentalfx_outside(trig)
{
				while(1)
				{
								trig waittill("trigger");
								if(level.inside_train == true)
								{
												level.inside_train = false;
								}	
				}	
}	
change_environmentalfx_inside(trig)
{ 
				while(1)
				{
								trig waittill("trigger");
								if(level.inside_train == false)
								{
												level.inside_train = true;
								}	
				}
}	







spawn_group( targetname, force_spawn, opt_assign_name )
{
				if ( !IsDefined(opt_assign_name) )
				{
								opt_assign_name = false;
				}

				guys = [];
				spawners = GetEntArray( targetname, "targetname" );
				if ( IsDefined(spawners) )
				{
								for (i=0; i<spawners.size; i++)
								{
												if ( opt_assign_name )
												{
																new_guy = spawners[i] DoSpawn( targetname + i );
												}
												else
												{
																new_guy = spawners[i] StalingradSpawn();	
																
												}
												if ( spawn_failed(new_guy) )
												{
																break;
												}
												guys[guys.size] = new_guy;
								}
				}

				return guys;
}









spawn_group_ordinal( targetname, opt_startnum )
{
				if ( !IsDefined( opt_startnum ) )
				{
								num = 1;
				}
				else
				{
								num = opt_startnum;
				}

				guys = [];
				spawner = GetEnt( targetname + num, "targetname" );
				while ( IsDefined(spawner) )
				{
								new_guy = spawner DoSpawn( targetname + num + "_ai" );
								if ( spawn_failed(new_guy) )
								{
												break;
								}
								guys[guys.size] = new_guy;
								
								
								if( isdefined( spawner.script_string ) )
								{
												
												new_guy.script_string = spawner.script_string;
								}
								
								
								if( isdefined( spawner.script_noteworthy ) )
								{
												
												new_guy.script_noteworthy = spawner.script_noteworthy;
								}
								num++;
								spawner = GetEnt( targetname + num, "targetname" );
				}

				return guys;
}






control_hud()
{
				level.control_hud = newHudElem();
				level.control_hud.x = 0;
				level.control_hud.y = 150;
				level.control_hud.alignX = "center";
				level.control_hud.alignY = "middle";
				level.control_hud.horzAlign = "center";
				level.control_hud.vertAlign = "middle";
				level.control_hud.foreground = true;
				level.control_hud.fontScale = 2.0;
				level.control_hud.alpha = 1.0;
				level.control_hud.color = (0.5, 0.7, 0.5);
				level.control_hud.inuse = false;
}
hud_text_uninterruptible(text, time_ms)
{
				if (IsDefined(level.control_hud))
				{
								level.control_hud.inuse = true;

								while((time_ms > 0) && (level.control_hud.inuse == true)) 
								{
												level.control_hud settext(text);
												wait .05;
												time_ms -= 50;
								}

								level.control_hud.inuse = false;
								level.control_hud settext("");
				}
}





make_civilian( spawnername )
{
				self.goalradius = 12;	
				self.walkdist = 320000;	
				self animscripts\shared::placeWeaponOn( self.primaryweapon, "none" );	

				
				trig = GetEnt( spawnername + "_trig", "targetname" );
				if ( IsDefined(trig) )
				{
								if ( IsDefined(self.target) )
								{
												node = GetNode( self.target, "targetname" );
												if ( IsDefined(node) )
												{
																self SetGoalPos(self.origin);
																trig waittill( "trigger" );

																
																self SetGoalNode(node);
												}
								}
				}
}




roof_hatches_setup()
{
				thread triggered_roof_hatches();

				
				maps\_playerawareness::init();

				entaTemp = GetEntArray( "hatch_unlocked", "targetname" );
				if( IsDefined( entaTemp[0] ) )
				{
								maps\_playerawareness::setupArrayUseOnly(	"hatch_unlocked", 
												::roof_hatch_open, 
												"Press &&1 to open roof hatch", 
												0, 
												undefined, 
												true, 
												true, 
												undefined, 
												level.awarenessMaterialMetal, 
												true, 
												true ); 
				}		

				
				
				
				 													

}
roof_hatch_open(strcObject)
{
				if ( isdefined(strcObject.primaryEntity.script_noteworthy) )
				{
								if(strcObject.primaryEntity.script_noteworthy == "reverse" )
								{
												
												strcObject.primaryEntity MoveTo( strcObject.primaryEntity.origin + (0, -51, 0), 1 );
								}
				}		
				else
				{
								
								strcObject.primaryEntity MoveTo( strcObject.primaryEntity.origin + (0, 51, 0), 1 );
				}
}	



	




triggered_roof_hatches()
{
				hatch = GetEntArray("hatch_triggered", "targetname");
				hatch_trig = GetEntArray( "hatch_triggered_trig", "targetname" );

				if ( IsDefined(hatch_trig) )
				{
								for (i=0; i<hatch_trig.size; i++)
								{
												thread hatch_wait(hatch_trig[i], hatch[i]);
								}
				}		
}

hatch_wait(trig, hatch)
{

				trig waittill("trigger");
				

				if ( isdefined(hatch.script_noteworthy) )
				{
								if(hatch.script_noteworthy == "reverse" )
								{
												
												hatch MoveTo( hatch.origin + (0, -51, 0), 0.5 );

												
												hatch playsound("train_hatch_open");

								}	
				}
				else
				{
								
								hatch MoveTo( hatch.origin + (0, 51, 0), 0.5 );

								
								hatch playsound("train_hatch_open");
				}
				

				
				
				
				
				
				
				hatch waittill( "movedone" );
				
				
				if( isdefined( hatch.script_string ) )
				{
								
								if( hatch.script_string == "lock_behind_player" )
								{
												
												while( 1 )
												{
																
																if( level.player.origin[2] > hatch.origin[2] && distancesquared( level.player.origin, hatch.origin ) > 60*60 )
																{
																				
																				hatch MoveTo( hatch.origin + (0, -51, 0), 0.5 );

																				
																				hatch playsound("train_hatch_close");

																				
																				return;
																}
																else if( level.player.origin[2] < hatch.origin[2] )
																{
																				
																				wait( 0.1 );
																}
																
																
																wait( 0.05 );
												}
								}
				}
				
}		



lights_flickering()
{
				flickering_fixture = GetEntArray("flickering_light_fixture", "targetname");

				i=0;
				if ( IsDefined(flickering_fixture) )
				{
								for (i=0; i<flickering_fixture.size; i++)
								{
												thread busted_light_start(flickering_fixture[i]);
								}
				}
}
busted_light_start(fixture)
{
				light = GetEnt(fixture.target, "targetname");

				if ( IsDefined(light) )
				{
								while(true)
								{
												light setlightintensity (0);
												fixture setmodel("p_lit_ceiling_light_off");
												wait( randomfloatrange(.005, 0.5) );

												light setlightintensity (randomfloatrange(0.5, 2));
												fixture setmodel("p_lit_ceiling_light_on");
												fx = playfx( level._effect["fx_metalhit_lg"], fixture.origin);
												wait( randomfloatrange(.005, 0.5) );

												light setlightintensity (0);
												fixture setmodel("p_lit_ceiling_light_off");
												wait( randomfloatrange(.005, 0.5) );

												light setlightintensity (randomfloatrange(0.5, 2));
												fixture setmodel("p_lit_ceiling_light_on");
												fx = playfx( level._effect["fx_metalhit_lg"], fixture.origin);
												wait( randomfloatrange(.005, 0.5) );

												light setlightintensity (0);
												fixture setmodel("p_lit_ceiling_light_off");
												wait( randomfloatrange(.005, 0.5) );

												light setlightintensity (randomfloatrange(0.5, 2));
												fixture setmodel("p_lit_ceiling_light_on");
												fx = playfx( level._effect["fx_metalhit_lg"], fixture.origin);
												wait( randomfloatrange(.005, 0.5) );

												light setlightintensity (0);
												fixture setmodel("p_lit_ceiling_light_off");
												wait( randomfloatrange(.005, 0.5) );

												light setlightintensity (randomfloatrange(0.5, 2));
												fixture setmodel("p_lit_ceiling_light_on");
												fx = playfx( level._effect["fx_metalhit_lg"], fixture.origin);
												wait( randomfloatrange(.005, 0.5) );

												light setlightintensity(2.0);
												fixture setmodel("p_lit_ceiling_light_on");
												wait(randomfloatrange(1.0, 5.0));		
								}
				}
				else
				{
								iPrintLnBold( "couldn't find light");
				}	
}	





start_hud_camera()
{
				waittime = 5.0;
				if (!IsDefined(level.hud_camera))
				{
								level.hud_camera = newHudElem();
								level.hud_camera.x = -210;
								level.hud_camera.y = 40;
								level.hud_camera.horzAlign = "right";
								level.hud_camera.vertAlign = "top";
								level.hud_camera SetShader("videocamera_hud_train1", 200, 150);
								level.hud_camera.alpha = 0;

								level.hud_camera fadeOverTime(2); 
								level.hud_camera.alpha = 0.7;
								wait(waittime);

								level.hud_camera fadeOverTime(2); 
								level.hud_camera.alpha = 0;
								wait(3.0);	
								if (isdefined(level.hud_camera))
								{
												level.hud_camera destroy();
								}	
				}
}	





compass_map_changer()
{
				for ( i=1; i<10; i++)
				{
								trig = GetEntArray( "map_car"+i, "targetname" );
								if ( IsDefined(trig) )
								{
												for (t=0; t<trig.size; t++)
												{
																thread map_loadnext(trig[t], i);
												}
								}		
				}
}

map_loadnext(trig, carnum)
{
				while(true)
				{
								trig waittill( "trigger" );
								if(carnum == 1)
								{
												setminimap( "compass_map_montenegrotrain", 400, -7008, -400, -8608  );   	
												
												
												setSavedDvar( "sf_compassmaplevel",  "level1" );
								}
								if(carnum == 2)
								{
												setminimap( "compass_map_montenegrotrain", 400, -5408, -400, -7008  ); 
												
												
												setSavedDvar( "sf_compassmaplevel",  "level2" );
								}	
								if(carnum == 3)
								{
												setminimap( "compass_map_montenegrotrain", 400, -3808, -400, -5408  );
												
												
												setSavedDvar( "sf_compassmaplevel",  "level3" );
								}	
								if(carnum == 4)
								{
												setminimap( "compass_map_montenegrotrain", 400, -2208, -400, -3808  );
												
												
												setSavedDvar( "sf_compassmaplevel",  "level4" );
								}	
								if(carnum == 5)
								{
												setminimap( "compass_map_montenegrotrain", 400, -608, -400, -2208  );
												
												
												setSavedDvar( "sf_compassmaplevel",  "level5" );
								}	
								if(carnum == 6)
								{
												setminimap( "compass_map_montenegrotrain", 400, 992, -400, -608  ); 
												
												
												setSavedDvar( "sf_compassmaplevel",  "level6" );
								}	
								if(carnum == 7)
								{
												setminimap( "compass_map_montenegrotrain", 400, 2592, -400, 992  );
												
												
												setSavedDvar( "sf_compassmaplevel",  "level7" );
								}	
								if(carnum == 8)
								{
												setminimap( "compass_map_montenegrotrain", 400, 4192, -400, 2592  );
												
												
												setSavedDvar( "sf_compassmaplevel",  "level8" );
								}	
								if(carnum == 9)
								{
												setminimap( "compass_map_montenegrotrain", 400, 5792, -400, 4192  );
												
												
												setSavedDvar( "sf_compassmaplevel",  "level9" );
								}
				}
}











setup_automatic_doors()
{
				autodoor_array = GetEntArray( "autodoor_trigger", "script_noteworthy" );
				if ( IsDefined(autodoor_array) )
				{
								for (i=0; i<autodoor_array.size; i++)
								{
												thread autodoors_open(autodoor_array[i]);
								}
				}		
}	
autodoors_open(trig)
{
				door = GetEnt(trig.target, "targetname");
				node = GetNode(door.target, "targetname");

				if ( IsDefined(door) )
				{
								door_pos = door.origin;
								new_pos = undefined;
								move_dist = 50;

								right = AnglesToRight(node.angles);
								rightDot = VectorDot(right, VectorNormalize(door.origin - node.origin));

								if (rightDot > 0)
								{
												new_pos = door.origin + (right * move_dist);
								}
								else
								{
												new_pos = door.origin + ((-1 * right) * move_dist);
								}

								while( true )
								{
												trig waittill( "trigger", ent );

												door MoveTo( new_pos, 0.5 );

												
												door playsound("train_auto_door_open");

												if (door.spawnflags & 1)
												{
																door ConnectPaths();
												}
												while(IsDefined(ent) && Distance( door.origin, ent.origin ) < 128 )
												{
																wait(1.0);
												}
												door MoveTo( door_pos, 0.5 );

												
												door playsound("train_auto_door_close");

												if (door.spawnflags & 1)
												{
																door DisconnectPaths();
												}
								}
				}	
}



setup_automatic_doors_dbl()
{
				autodoor_dbl_array = GetEntArray( "autodoor_dbl_trigger", "script_noteworthy" );
				if ( IsDefined(autodoor_dbl_array) )
				{
								for (i=0; i<autodoor_dbl_array.size; i++)
								{
												thread autodoors_dbl_open(autodoor_dbl_array[i]);
								}
				}		
}	
autodoors_dbl_open(trig)
{
				doorArray = GetEntArray(trig.target, "targetname");

				if ( IsDefined(doorArray) )
				{
								for (i=0; i<doorArray.size; i++)
								{
												thread autodoors_dbl_trigger(doorArray[i], trig);
								}
				}
}				
autodoors_dbl_trigger(door, trig)
{
				node = GetNode(door.target, "targetname");
				door_pos = door.origin;
				new_pos = undefined;
				move_dist = 37;

				right = AnglesToRight(node.angles);
				rightDot = VectorDot(right, VectorNormalize(door.origin - node.origin));

				if (rightDot > 0)
				{
								new_pos = door.origin + (right * move_dist);
				}
				else
				{
								new_pos = door.origin + ((-1 * right) * move_dist);
				}

				
				
				
				
				
				door ConnectPaths();
				

				while( true )
				{
								trig waittill( "trigger", ent );

								door MoveTo( new_pos, 0.5 );

								
								door playsound ("train_double_door_open");

								if (door.spawnflags & 1)
								{
												door ConnectPaths();
								}
								while(IsDefined(ent) && Distance( door.origin, ent.origin ) < 150 )
								{
												wait(1.0);
								}
								door MoveTo( door_pos, 0.5 );

								
								door playsound ("train_double_door_close");

								if (door.spawnflags & 1)
								{
												door DisconnectPaths();
								}
				}
}



setup_auto_service_doors()
{
				service_door_array = GetEntArray( "service_door_trigger", "script_noteworthy" );
				if ( IsDefined(service_door_array) )
				{
								for (i=0; i<service_door_array.size; i++)
								{
												thread auto_service_doors_open(service_door_array[i]);
								}
				}		
}	
auto_service_doors_open(trig)
{
				door = GetEnt(trig.target, "targetname");
				node = GetNode(door.target, "targetname");

				if ( IsDefined(door) )
				{
								door_pos = door.origin;
								new_pos = undefined;
								move_dist = 39;

								right = AnglesToRight(node.angles);
								rightDot = VectorDot(right, VectorNormalize(door.origin - node.origin));

								if (rightDot > 0)
								{
												new_pos = door.origin + (right * move_dist);
								}
								else
								{
												new_pos = door.origin + ((-1 * right) * move_dist);
								}

								while( true )
								{
												trig waittill( "trigger", ent );

												door MoveTo( new_pos, 0.5 );

												
												door playsound("train_auto_door_open");

												if (door.spawnflags & 1)
												{
																door ConnectPaths();
												}
												while(IsDefined(ent) && Distance( door.origin, ent.origin ) < 96 )
												{
																wait(1.0);
												}
												door MoveTo( door_pos, 0.5 );

												
												door playsound("train_auto_door_close");

												if (door.spawnflags & 1)
												{
																door DisconnectPaths();
												}
								}
				}	
}





setup_freight_train()
{
				level.freight_train = [];
				freight = GetEnt( "freight_engine", "targetname" );
				
				
				
				
				level.freight_door1_right = GetEnt( "freight_door_shootopen_right", "script_noteworthy" );
				level.freight_door1_left = GetEnt( "freight_door_shootopen_left", "script_noteworthy" );
				
				level.freight_door2 = GetEnt( "freight9_door", "script_noteworthy" );
				
				
				
				
				
				
				level.freight_playerpos = GetEnt( "freight_playerpos", "targetname" );
				
				
				
				
				
				
				
				level.enta_freight_smodels = getentarray( "freight_train_models", "targetname" );
				
				temp_ent = undefined;
				
				mantle_org = undefined;
				
				temp_org = undefined;
				
				enta_script_trigs_on_freight = getentarray( "trig_script_freight", "script_noteworthy" );
				
				level.enta_freight_enemy_points = getentarray( "scr_freight_enemy", "targetname" );
				
				enta_freight_exploders = GetEntArray( "freight_train_exploder", "script_noteworthy" );
				
				level.freight_train_start = GetEnt( "freight_start_node", "targetname" );
				
				
				
				
				level.freight_train_play1 = GetEnt( "freight_node1", "targetname" ); 
				
				
				
				level.freight_train_play2 = GetEnt( "freight_node2", "targetname" ); 
				
				
				
				level.freight_train_play3 = GetEnt( "freight_node3", "targetname" ); 
				level.freight_train_end = GetEnt( "freight_end_node", "targetname" );	
				level.current_train_pos = undefined;	

				i = 0;
				while ( IsDefined( freight ) )
				{
								level.freight_train[i] = freight;

								
								freight hide();

								if ( IsDefined( freight.target ) )
								{
												freight = GetEnt( freight.target, "targetname" );
								}
								else
								{
												break;
								}
								i++;
				}

				
				for ( i = 1; i < level.freight_train.size; i++ )
				{
								level.freight_train[i] linkto(level.freight_train[i-1]);
				}
				level.freight_playerpos linkto(level.freight_train[0]);

				
				
				
				
				
				
				
				
				level.freight_door1_right hide();
				
				
				
				
				level.freight_door1_left hide();
				
				
				
				
				level.freight_door2 hide();
				
				
				
				
				
				
				
				
				
				
				
				for( i=0; i<enta_script_trigs_on_freight.size; i++ )
				{
								
								
								if( isdefined( enta_script_trigs_on_freight[i].target2 ) )
								{
												
												
												enta_script_trigs_on_freight[i] enablelinkto();

												
												enta_script_trigs_on_freight[i] linkto( getent( enta_script_trigs_on_freight[i].target2, "targetname" ) );

												
												continue;
								}

								
								
								if( isdefined( enta_script_trigs_on_freight[i].target ) )
								{
												
												
												enta_script_trigs_on_freight[i] enablelinkto();

												
												enta_script_trigs_on_freight[i] linkto( getent( enta_script_trigs_on_freight[i].target, "targetname" ) );

												
												continue;
								}
								else
								{
												
												iprintlnbold( "trig at " + enta_script_trigs_on_freight[i].origin + " missing target!" );
								}
				}

				
				
				
				
				
				for( i=0; i<level.enta_freight_smodels.size; i++ )
				{
								
								assertex( isdefined( level.enta_freight_smodels[i].target ),"" + level.enta_freight_smodels[i].origin + " missing target" );
				}

				
				
				

				
				for( i=0; i<level.enta_freight_smodels.size; i++ )
				{
								
								
								if( isdefined( level.enta_freight_smodels[i].target2 ) )
								{
												

												
												
												temp_org = getent( level.enta_freight_smodels[i].target2, "targetname" );

												
												wait( 0.05 );

												
												assertex( isdefined( temp_org ), "a light on the freight does not have a script origin" );
												
												assertex( isdefined( temp_org.target ), "script_origin missing a target!" );
												
												
												temp_ent = getent( temp_org.target, "targetname" );

												
												level.enta_freight_smodels[i] linklighttoentity( temp_org );

												
												level.enta_freight_smodels[i].origin = ( 0, 0, 0 );

												
												temp_org linkto( temp_ent );

												
												temp_org = undefined;
												temp_ent = undefined;

												
												wait( 0.05 );

								}
								else if( isdefined( level.enta_freight_smodels[i].target ) )
								{
												
												
												if( level.enta_freight_smodels[i].target == "freight_mantle_origin" )
												{
																
																mantle_org = getent( level.enta_freight_smodels[i].target, "targetname" );

																
																level.enta_freight_smodels[i] linkto( mantle_org );

																
																if( isdefined( mantle_org.target ) )
																{
																				
																				temp_ent = getent( mantle_org.target, "targetname" );

																				
																				mantle_org linkto( temp_ent );

																				
																				temp_ent = undefined;
																}
																
																else
																{
																				iprintlnbold( "mantle org has no target!" );
																}
												}
												else
												{
								
								temp_ent = getent( level.enta_freight_smodels[i].target, "targetname" );

																
																if( isdefined( temp_ent ) )
																{
								
								level.enta_freight_smodels[i] linkto( temp_ent );

								
								level.enta_freight_smodels[i] hide();

								
								temp_ent = undefined;
																}
												}
								}
				}
				
				
				

				
				
				
				
				
				if( isdefined( level.enta_freight_enemy_points ) )
				{
								
								
								
								for( i=0; i<level.enta_freight_enemy_points.size; i++ )
								{
												
												assertex( isdefined( level.enta_freight_enemy_points[i].target ), level.enta_freight_enemy_points[i].origin + " missing target!" );
												
												assertex( isdefined( level.enta_freight_enemy_points[i].script_noteworthy ), level.enta_freight_enemy_points[i].origin + " missing script_noteworthy!" );
								}
				}
				else
				{
								
								iprintlnbold( "level.enta_freight_enemy_points not defined!" );
				}

				
				if( isdefined( level.enta_freight_enemy_points ) )
				{
								
								for( i=0; i<level.enta_freight_enemy_points.size; i++ )
								{
												
												temp_ent = getent( level.enta_freight_enemy_points[i].target, "targetname" );

												
												level.enta_freight_enemy_points[i] linkto( temp_ent );

												
												temp_ent = undefined;
								}

								
								
				}

				
				for( i=0; i<enta_freight_exploders.size; i++ )
				{
								
								AssertEx( IsDefined( enta_freight_exploders[i].target ), enta_freight_exploders[i].origin + "needs target" );
								
								
								temp_ent = GetEnt( enta_freight_exploders[i].target, "targetname" );

								
								enta_freight_exploders[i] LinkTo( temp_ent );

								
								wait( 0.05 );

								
								ent_temp = undefined;
				}


				thread freight_train_begin();
				
				
				wait( 2.0 );
				
				
				
				level thread freight_train_hide_init();
}	

freight_train_begin()
{
				
				
				
				
				start_trig = GetEnt("freight_start_trig", "targetname");

				
				
				
				
				
				
				
				if ( IsDefined( start_trig ) )
				{
								start_trig waittill("trigger");
								level.freight_train_active = true;
								
								
								
								
								if( !flag( "freight_train_active" ) )
								{
												level flag_set( "freight_train_active" );

												
												
								}
								
								
								
								
								level thread train_tanner_talks_freight();


								level.on_freight_train = false;
								
								
								
								
								if( flag( "on_freight_train" ) )
								{
												level flag_clear( "on_freight_train" );

												
												
								}
								
				}
				else
				{
								iPrintLnBold( "couldn't find freight train trigger!" );
								return;
				}

				
				for ( i = 0; i < level.freight_train.size; i++ )
				{
								level.freight_train[i] show();
				}	
				
				
				
				
				
				level.freight_door1_right show();
				
				level.freight_door1_left show();
				
				
				level.freight_door2 show();
				
				
				
				
				
				
				
				
				
				
				for( i=0;i<level.enta_freight_smodels.size; i++ )
				{
								
								level.enta_freight_smodels[i] show();
				}
				
				
				
				
				level notify( "train_anim_start" );
				

				
				movetime = 12;
				accel = 0;
				decel = 3;

				level.freight_train[0] moveto( level.freight_train_play1.origin, movetime, accel, decel );
				level.freight_train[0] waittill( "movedone" );
				level.current_train_pos = level.freight_train_play1;

				
				thread spawn_train_enemies();
				thread special_freight_nme();

				
				thread stop_freight_train();

				
				
				
				
				level thread train_first_uncouple();
				
				
				level thread train_second_uncouple();
				

				
				
				
				level.freight_train_active = true;
				level flag_set( "freight_train_active" );

				
				

				
				
				
				
				

				
				


				
				if( isdefined( level.freight_train_play3 ) )
				{
								
								level flag_wait( "freight_to_node3" );

								
								

								
								

								
								
								
								sbrush_freight_collision = getent( "freight_train_pathing_clips", "targetname" );
					
								
								level.player playsound("bond_xrt_grunt");
								wait(0.05);
								level.player shellshock( "default", 3.0 );

								
								scr_org = spawn( "script_origin", level.player.origin );

								
								wait( 0.05 );

								
								scr_org linkto( getent( "freight6", "targetname" ) );

								
								sbrush_freight_collision delete();

								
								wait( 0.05 );

								
								level.player setorigin( scr_org.origin );

								
								level.player playerlinkto( scr_org, undefined, 0 );

								
								wait( 0.1 );

								
								level.freight_train[0] moveto( level.freight_train_play3.origin, 0.75, 0, 0 );

								
								level.freight_train[0] waittill( "movedone" );

								
								wait( 0.05 );

								
								tempAngles = level.player getplayerangles();
								scr_org unlink();
								scr_org delete();
								
								level.player setplayerangles (tempAngles + (0, 180, 0));

								
								level notify( "train_at_node_3" );

								
								level.current_train_pos = level.freight_train_play3;

								
								
								
								level.freight_train_active = true;
								level flag_set( "freight_train_active" );

								
								
				}
				else
				{
								
								iprintlnbold( "level.freight_train_play3 not defined!" );

								
								return;
				}
}





freight_train_hide_init()
{
				
				

				
				
				
				
				
				
				
				
				str_hide = "freightcar_hide";
				str_first_show = "freight_show_1";
				str_second_show = "freight_show_2";
				
				trig_first_show = getent( "trig_first_show", "targetname" );
				trig_second_show = getent( "trig_first_uncouple_success", "targetname" );

				
				assertex( isstring( str_hide ), "str_hide not string" );
				assertex( isstring( str_first_show ), "str_first_show not string" );
				assertex( isstring( str_second_show ), "str_second_show not string" );
				assertex( isdefined( trig_first_show ), "trig_first_show not defined" );
				assertex( isdefined( trig_second_show ), "trig_second_show not defined" );

				
				
				level.freight_train[0] thread freight_hide_n_show( str_hide, str_second_show );
				level.freight_train[1] thread freight_hide_n_show( str_hide, str_second_show );
				
				level.freight_train[2] thread freight_hide_n_show( str_hide, str_first_show );
				level.freight_train[3] thread freight_hide_n_show( str_hide, str_first_show );
				level.freight_train[4] thread freight_hide_n_show( str_hide, str_first_show );

				
				level flag_wait( "on_freight_train" );

				
				level notify( str_hide );

				
				trig_first_show waittill( "trigger" );

				
				level notify( str_first_show );

				
				
				level thread freight_ladder_cam();

				
				trig_second_show waittill( "trigger" );

				
				level notify( str_second_show );

				
				
				level thread freight_ledge_cam();
				
}




freight_hide_n_show( str_hide_notify, str_shownotify )
{
				

				
				
				enta_quick = getentarray( self.targetname, "target" );
				enta_car_s_models = [];

				
				assertex( isdefined( enta_quick ), "enta_quick not defined" );

				
				for( i=0; i<enta_quick.size; i++ )
				{
								
								assertex( isdefined( enta_quick[i].targetname ), "missing targetname on one spot in the array" );
				}
				
				
				for( i=0; i<enta_quick.size; i++ )
				{
								
								if( enta_quick[i].targetname != "freight_train_models" )
								{
												
												continue;
								}
								else
								{
												
												
												enta_car_s_models[enta_car_s_models.size] = enta_quick[i];
								}
				}
				
				
				level waittill( str_hide_notify );

				
				for( i=0; i<enta_car_s_models.size; i++ )
				{
								
								enta_car_s_models[i] hide();
				}

				
				self hide();

				
				level waittill( str_shownotify );

				
				for( i=0; i<enta_car_s_models.size; i++ )
				{
								
								enta_car_s_models[i] show();
				}

				
				self show();
}



freight_ladder_cam()
{
				

				
				trig_end_cam = getent( "trig_move_from_train2", "targetname" );
				
				notice = undefined;

				
				assertex( isdefined( trig_end_cam ), "trig_end_cam not defined" );

				
				while( !level.player istouching( trig_end_cam ) )
				{
								
								level.player waittill( "ladder", notice );

								if( notice == "begin" )
								{
												
												level.player customcamera_checkcollisions( 0 );
								}
								else if( notice == "end" )
								{
												
												level.player customcamera_checkcollisions( 1 );
								}
				}
}



freight_ledge_cam()
{
				

				
				trig_end_ledge = getent( "trig_end_tosser_dialogue", "targetname" );
				
				notice = undefined;

				
				assertex( isdefined( trig_end_ledge ), "trig_end_ledge not defined" );

				
				while( !level.player istouching( trig_end_ledge ) )
				{
								
								level.player waittill( "ledge", notice );

								if( notice == "begin" )
								{
												
												level.player customcamera_checkcollisions( 0 );
								}
								else if( notice == "end" )
								{
												
												level.player customcamera_checkcollisions( 1 );
								}
				}
}



spawn_train_enemies()
{

				
				
				
				
				
				
				
				
				
				
				level.player endon( "death" );

				
				
				trig_wave_1 = getent( "trig_spwn_bottom_crossfire", "targetname" );
				trig_wave_2 = getent( "trig_ready_show_train", "targetname" );
				trig_wave_3 = getent( "trig_first_uncouple_success", "targetname" );
				
				spawner = getent( "spwn_freight_train", "targetname" );
				
				
				enta_freight_wave_1 = getentarray( "freight_wave_1", "script_noteworthy" );
				enta_freight_wave_2 = getentarray( "freight_wave_2", "script_noteworthy" );
				enta_freight_wave_3 = getentarray( "freight_wave_3", "script_noteworthy" );
				
				ent_move_org = undefined;
				ent_guy = undefined;

				
				assertex( isdefined( trig_wave_1 ), "trig_wave_1 fail" );
				assertex( isdefined( trig_wave_2 ), "trig_wave_2 fail" );
				assertex( isdefined( trig_wave_3 ), "trig_wave_3 fail" );
				assertex( isdefined( spawner ), "spawner fail" );
				assertex( isdefined( enta_freight_wave_1 ), "enta_freight_wave_1 fail" );
				assertex( isdefined( enta_freight_wave_2 ), "enta_freight_wave_2 fail" );
				assertex( isdefined( enta_freight_wave_3 ), "enta_freight_wave_3 fail" );

				
				trig_wave_1 waittill( "trigger" );

				
				ent_move_org = spawn( "script_origin", spawner.origin + ( 0, 0, -10 ) );

				
				
				
				
				

				
				spawner.count = enta_freight_wave_1.size + 1;

				
				
				for( i=0; i<enta_freight_wave_1.size; i++ )
				{
								
								ent_guy = spawner stalingradspawn( "f_enemy_wave_1" );
								
								if( spawn_failed( ent_guy ) )
								{
												
												iprintlnbold( "ent_guy, wave_1 on " + i + " loop fail" );

												
												wait( 5.0 );

												
												return;
								}
								else
								{
												
												ent_guy setenablesense( false );

												
												ent_guy hide();

												
												
												ent_move_org.origin = ent_guy.origin;

												
												ent_guy linkto( ent_move_org );

												
												ent_move_org moveto( enta_freight_wave_1[i].origin, 0.5, 0.0, 0.0 );

												
												ent_move_org waittill( "movedone" );

												
												ent_move_org rotateto( enta_freight_wave_1[i].angles, 0.5, 0.0, 0.0 );

												
												ent_move_org waittill( "rotatedone" );

												
												
												ent_guy unlink();

												
												wait( 0.05 );

												
												ent_guy linkto( enta_freight_wave_1[i] );

												
												ent_guy show();
												ent_guy setenablesense( true );
												ent_guy setcombatrole( "support" );
												ent_guy setengagerule( "tgtSight" );
												ent_guy addengagerule( "tgtPerceive" );
												ent_guy addengagerule( "Damaged" );
												ent_guy addengagerule( "Attacked" );
												ent_guy setalertstatemin( "alert_red" );

												
												

												
												ent_guy thread train_notify_for_sense( "wave_1_fire" );

								}

				}
				
				
				
				level thread train_wave_2_init();
				
				
				
				spawner.count = enta_freight_wave_3.size + 1;

				
				trig_wave_3 waittill( "trigger" );

				
				level thread train_bag_tossers();

				
				
				level thread train_wave3_init();
				

				
				
				
				ent_move_org unlink();
				
				wait( 0.05 );
				
				ent_move_org delete();

				
				spawner delete();

				
				ent_guy = undefined;

}



train_notify_for_sense( str_notify )
				{
				
				level.player endon( "death" );
				self endon( "death" );

				
				AssertEx( isdefined( str_notify ), "notify is not defined!" );
				AssertEx( isstring( str_notify ), "notify is not a string" );

				
				self thread dmg_turn_sense_on();

				
				level waittill( str_notify );

				
				self notify( "sense_on" );

				
				self cmdshootatentity( level.player, true, 3, 0.8 );

				
				self thread turn_on_sense( 5 );	
}




train_wave_2_init()
{
				

				
				
				enta_wave2_spawner = getentarray( "spwn_first_uncouple", "targetname" );
				
				nod_wave2_tether = getnode( "first_uncouple_tether", "targetname" );
				
				nod_train_jump_0 = getnode( "train_jumper_dest_a", "targetname" );
				
				
				


				
				assertex( isdefined( enta_wave2_spawner ), "enta_wave2_spawner not defined" );
				
				for( i=0; i<enta_wave2_spawner.size; i++ )
				{
								
								assertex( isdefined( enta_wave2_spawner[i].script_string ), "wave_2 spawner missing string" );
				}

				
				for( i=0; i<enta_wave2_spawner.size; i++ )
				{
								
								if( enta_wave2_spawner[i].script_string == "on_car" )
								{
												
												level thread train_wave2_oncar( enta_wave2_spawner[i], nod_wave2_tether, "wave_2_start" );
								}
								
								
								
								
								
				}
}








train_wave2_oncar( ent_spawner, nod_tether, str_notify )
{
				
				assertex( isdefined( ent_spawner ), "ent_spawner not defined" );
				assertex( isdefined( ent_spawner.target ), "ent_spawner missing target" );
				assertex( isdefined( nod_tether ), "nod_tether not defined" );
				assertex( isdefined( str_notify ), "str_notify not defined" );
				assertex( isstring( str_notify ), "str_notify not string" );

				
				if( !isdefined( ent_spawner ) || ent_spawner.count <= 0 )
				{
								
								ent_spawner.count = 1;
				}

				
				nod_goal = GetNode( ent_spawner.target, "targetname" );

				
				level waittill( str_notify );

				
				ent_temp = ent_spawner stalingradspawn( "f_enemy_wave_2" );
				
				if( maps\_utility::spawn_failed( ent_temp ) )
								{
												
								iprintlnbold( "problem spawning from " + ent_spawner.origin );

												
								wait( 1.0 );

								
												return;
								}
								else
								{
								
								ent_temp thread turn_on_sense( 5 );
								ent_temp setcombatrole( "guardian" );
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );
								ent_temp setalertstatemin( "alert_red" );

								
								ent_temp setgoalnode( nod_goal );

								
								ent_temp thread train_reset_speed_activate_tether( nod_tether, 325, 900, 285 );
				}

				
				wait( 2.0 );

				
				ent_spawner delete();

}




train_wave2_jump_across( ent_spawner, nod_tether, dest_node, str_notify )
{
				
				assertex( isdefined( ent_spawner ), "ent_spawner not defined" );
				assertex( isdefined( nod_tether ), "nod_tether not defined" );
				assertex( isdefined( dest_node ), "dest_node not defined" );
				assertex( isdefined( str_notify ), "str_notify not defined" );
				assertex( isstring( str_notify ), "str_notify not string" );

				
				if( !isdefined( ent_spawner ) || ent_spawner.count <= 0 )
				{
								
								ent_spawner.count = 1;
				}

				
				level waittill( str_notify );

				
				ent_temp = ent_spawner stalingradspawn( "f_enemy_wave_2" );
				
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								
								iprintlnbold( "problem spawning from " + ent_spawner.origin );

								
								wait( 1.0 );

								
								return;
				}
				else
				{
								
								ent_temp thread turn_on_sense( 5 );
								ent_temp setcombatrole( "guardian" );
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );
								ent_temp setalertstatemin( "alert_red" );

								
								ent_temp setgoalnode( dest_node );

								
								ent_temp thread train_reset_speed_activate_tether( nod_tether, 325, 900, 285 );
				}

				
				wait( 2.0 );

				
				ent_spawner delete();
								}




train_wave3_init()
{
				


				
				
				enta_wave3_spawners = getentarray( "spwn_wave3", "targetname" );
				
				stockcar_tether = getnode( "stock_car_tether", "targetname" );
				jumpcar_tether = getnode( "jump_back_car_tether", "targetname" );

				
				assertex( isdefined( enta_wave3_spawners ), "enta_wave3_spawners not defined" );
				assertex( isdefined( stockcar_tether ), "stockcar_tether not defined" );
				assertex( isdefined( jumpcar_tether ), "jumpcar_tether not defined" );

				
				for( i=0; i<enta_wave3_spawners.size; i++ )
				{
								
								assertex( isdefined( enta_wave3_spawners[i].script_string ), "wave3 spawner missing string" );

								
								if( enta_wave3_spawners[i].script_string == "tether_stockcar" )
								{
												
												level thread train_wave3_oncar( enta_wave3_spawners[i], stockcar_tether, "box_fall_start" );
				}
								else if( enta_wave3_spawners[i].script_string == "tether_jumpcar" )
								{
												
												level thread train_wave3_oncar( enta_wave3_spawners[i], jumpcar_tether, "box_fall_start" );
								}
								else if( enta_wave3_spawners[i].script_string == "no_tether" )
								{
												
												level thread train_wave3_rusher( enta_wave3_spawners[i], "box_fall_start" );
								}
				}
}




train_wave3_oncar( ent_spawner, tether_node, str_notify )
{
				

				
				assertex( isdefined( ent_spawner ), "ent_spawner for wave3 fail" );
				assertex( isdefined( ent_spawner.target ), "ent_spawner.target for wave3 fail" );
				assertex( isdefined( tether_node ), "tether_node for wave3 fail" );
				assertex( isdefined( str_notify ), "str_notify for wave3 fail" );

				
				
				dest_node = getnode( ent_spawner.target, "targetname" );
				
				ent_temp = undefined;

				
				assertex( isdefined( dest_node.script_string ), "wave3 spawner target not string!" );

				
				if( !isdefined( ent_spawner.count ) ||  ent_spawner.count <= 0 )
				{
								
								ent_spawner.count = 1;
				}

				
				level waittill( str_notify );

								
				ent_temp = ent_spawner stalingradspawn( "f_enemy_wave_3" );
				
				if( maps\_utility::spawn_failed( ent_temp ) )
								{
												
								iprintlnbold( "problem spawning from " + ent_spawner.origin );

												
								wait( 1.0 );

								
												return;
								}
				
								else
								{
								
								ent_temp thread turn_on_sense( 5 );
								ent_temp setcombatrole( "guardian" );
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );
								ent_temp setalertstatemin( "alert_red" );

								
								ent_temp setgoalnode( dest_node );

								
								ent_temp thread goal_n_combatrole( dest_node.script_string );

								
								ent_temp thread train_reset_speed_activate_tether( tether_node, 325, 1900, 285 );
				}

				
				wait( 1.0 );

				
				ent_spawner delete();

}



train_wave3_rusher( ent_spawner, str_notify )
{
				


				
				assertex( isdefined( ent_spawner ), "ent_spawner for wave3 rusher fail" );
				assertex( isdefined( str_notify ), "str_notify for wave3 rusher fail" );
				assertex( isstring( str_notify ), "str_notify for wave3 rusher not string" );

				
				if( !isdefined( ent_spawner.count ) ||  ent_spawner.count <= 0 )
												{
								
								ent_spawner.count = 1;
												}

				
				level waittill( str_notify );

				
				ent_temp = ent_spawner stalingradspawn( "f_enemy_wave_3" );
				
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								
								iprintlnbold( "problem spawning from " + ent_spawner.origin );

								
								wait( 1.0 );

								
								return;
								}
				
				else
				{
								
								ent_temp thread turn_on_sense( 5 );
								ent_temp setcombatrole( "rusher" );
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );
								ent_temp setalertstatemin( "alert_red" );
								ent_temp setscriptspeed( "walk" );
				}

				
				wait( 1.0 );

				
				ent_spawner delete();
}






















wait_for_2nd_uncouple()
{
				
				level.player endon( "death" );
				self endon( "death" );
				self endon( "damage" );

				
				self setenablesense( false );

				
				self allowedstances( "crouch" );

				
				level waittill( "knuckle_release_release_start" );

				
				self setenablesense( true );

				
				
				if( isdefined( self.script_string ) )
				{
								
								self allowedstances( self.script_string );
				}
				
				else
				{
								
								self allowedstances( "crouch", "stand" );
				}

}




train_death_unlink()
{
				
				self waittill( "death" );

				
				self unlink();

}



special_freight_nme()
{
				freight_nme_seperator = GetEnt( "spwn_freight_uncouple", "targetname" );
				show_train_special = GetEnt("show_train_special", "targetname");
				
				
				
				
				
				trig_stop_freight_for_seperate = getent( "trig_ready_show_train", "targetname" );
				
				
				
				ent_uncouple = getent( "freight_uncouple", "script_noteworthy" );
				
				scr_move_org = spawn( "script_origin", freight_nme_seperator.origin + ( 0, 0, -10 ) );


				
				assertex( isdefined( freight_nme_seperator ), "freight_nme_seperator not defined" );
				assertex( isdefined( show_train_special ), "show_train_special not defined" );
				assertex( isdefined( trig_stop_freight_for_seperate ), "trig_stop_freight_for_seperate not defined" );
				assertex( isdefined( ent_uncouple ), "ent_uncouple not defined" );
				assertex( isdefined( scr_move_org ), "scr_move_org not defined" );

				
				freight_nme_seperator.count = 1;


				
				
				
				
				
				


				if ( IsDefined(freight_nme_seperator) )
				{
								
								level waittill( "train_at_node_3" );

								
								
								
								level.enemy_seperator = freight_nme_seperator StalingradSpawn("enemy_seperator");
								if( spawn_failed( level.enemy_seperator ) )
								{
												
												iprintlnbold( "level.enemy_seperator failed spawn" );

												
												wait( 5.0 );

												
												return;
								}
								else
								{
												
												level.enemy_seperator SetEnableSense( false );

												
												scr_move_org.origin = level.enemy_seperator.origin;
												
												scr_move_org.angles = level.enemy_seperator.angles;

												
												level.enemy_seperator hide();

												
												level.enemy_seperator linkto( scr_move_org );

												
												scr_move_org moveto( ent_uncouple.origin, 0.5, 0.0, 0.0 );

												
												scr_move_org waittill( "movedone" );

												
												scr_move_org rotateto( ent_uncouple.angles, 0.5, 0.0, 0.0 );

												
												scr_move_org waittill( "rotatedone" );

												
												level.enemy_seperator unlink();

												
												wait( 0.05 );

												
												level.enemy_seperator linkto( ent_uncouple );

												
												level.enemy_seperator show();

												
												scr_move_org delete();

												
												level.enemy_seperator animscripts\shared::placeWeaponOn( level.enemy_seperator.primaryweapon, "none" );

												
												saw = spawn( "script_model", level.enemy_seperator.origin );

												
												wait( 0.05 );

												
												saw setmodel( "p_msc_grinder" );

												
												saw moveto( level.enemy_seperator gettagorigin( "TAG_WEAPON_RIGHT" ), 0.05 );

												
												saw waittill( "movedone" );

												
												saw linkto( level.enemy_seperator, "TAG_WEAPON_RIGHT" );

												

												if (IsDefined(show_train_special))
												{

																show_train_special waittill("trigger");

																if(IsDefined(level.freight_door2))
																{
																				level.door_busy = true;
																				thread activate_boxcar_door();

																				
																				level waittill( "seperator_play" );

																				
																				
																				
																				level.enemy_seperator cmdplayanim( "Thug_TrainUncouple_Look_Crouch", true );

																				
																				level.enemy_seperator waittill( "cmd_done" );

																				
																				level.enemy_seperator cmdplayanim( "Thug_TrainUncouple_CrouchLoop", true );

																				spark = spawn("script_origin", level.enemy_seperator gettagOrigin( "TAG_WEAPON_RIGHT" ) );
																				spark linkto(level.enemy_seperator, "TAG_WEAPON_RIGHT");
																				welding_light = GetEnt("weldlight","targetname");

					if (IsDefined(welding_light))
					{
																				level.welding_now = true;
																				thread welding_sparks(spark, welding_light);
																}
																else
																{
						iprintlnbold ("Welding_light is not defined ??");
					}
				}
				else
				{
																				iPrintLnBold( "Couldn't find boxcar door" );
																}
												}
								}
				}

				
				freight_nme_seperator delete();
}





train_bag_tossers()
{
				
				level.player endon( "death" );
				
				

				
				
				bag_spawner = getent( "spwn_freight_bag_toss", "targetname" );
				
				ent_bag_toss_part1 = getent( "freight_bag_part1", "script_noteworthy" );
				ent_bag_toss_part2 = getent( "freight_bag_part2", "script_noteworthy" );
				
				scr_move_org = spawn( "script_origin", bag_spawner.origin + ( 0, 0, -10 ) );
				
				
				str_animation = undefined;
				ent_temp = undefined;
				
				str_start_notify = "bag_toss_begin";
				str_end_notify = "stop_bag_toss";

				
				assertex( isdefined( bag_spawner ), "bag_spawner not defined" );
				assertex( isdefined( ent_bag_toss_part1 ), "ent_bag_toss_part1 not defined" );
				assertex( isdefined( ent_bag_toss_part2 ), "ent_bag_toss_part2 not defined" );
				assertex( isdefined( scr_move_org ), "scr_move_org not defined" );

				
				bag_spawner.count = 2;

				
				
				
				ent_temp = bag_spawner stalingradspawn( "bag_tosser" );
				if( spawn_failed( ent_temp ) )
				{
								
								iprintlnbold( "bag_spawner fail" );

								
								wait( 5.0 );

								
								return;
				}
				else
				{
								
								ent_temp setenablesense( false );

								
								ent_temp hide();

								
								scr_move_org.origin = ent_temp.origin;
								
								scr_move_org.angles = ent_temp.angles;

								
								ent_temp linkto( scr_move_org );

								
								scr_move_org moveto( ent_bag_toss_part1.origin + ( 0, 0, 4 ), 0.5, 0.0, 0.0 );

								
								scr_move_org waittill( "movedone" );

								
								scr_move_org rotateto( ent_bag_toss_part1.angles, 0.5, 0.0, 0.0 );

								
								scr_move_org waittill( "rotatedone" );

								
								ent_temp unlink();

								
								wait( 0.05 );

								
								

								
								ent_temp show();

								
								
								ent_temp thread train_play_bag_throw( str_start_notify, "Thug_Train_BagToss_Part1", str_end_notify );

								
								ent_temp.script_noteworthy = "train_bag_toss_guy";

								
								wait( 0.05 );

								
								ent_temp = undefined;
				}
				

				
				ent_temp = bag_spawner stalingradspawn( "bag_tosser" );
				if( spawn_failed( ent_temp ) )
				{
								
								iprintlnbold( "bag_spawner fail" );

								
								wait( 5.0 );

								
								return;
				}
				else
				{
								
								ent_temp setenablesense( false );

								
								ent_temp hide();

								
								scr_move_org.origin = ent_temp.origin;
								
								scr_move_org.angles = ent_temp.angles;

								
								ent_temp linkto( scr_move_org );

								
								scr_move_org moveto( ent_bag_toss_part2.origin + ( 0, 0, 4 ), 0.5, 0.0, 0.0 );

								
								scr_move_org waittill( "movedone" );

								
								scr_move_org rotateto( ent_bag_toss_part2.angles, 0.5, 0.0, 0.0 );

								
								scr_move_org waittill( "rotatedone" );

								
								ent_temp unlink();

								
								wait( 0.05 );

								
								

								
								ent_temp show();

								
								
								ent_temp thread train_play_bag_throw( str_start_notify, "Thug_Train_BagToss_Part2", str_end_notify );

								
								wait( 0.05 );

								
								ent_temp = undefined;
				}

				
				level notify( str_start_notify );

				
				level thread train_bagtoss_dialogue();

				
				level thread train_bag_tosses();

				
				bag_spawner delete();

}





train_play_bag_throw( str_start_notify, str_animation, str_end_notify )
{
				
				level.player endon( "death" );
				self endon( "death" );
				self endon( "damage" );

				
				assertex( isdefined( str_start_notify ), "train_play_bag_throw missing str_notify!" );
				assertex( isdefined( str_animation ), "train_play_bag_throw missing str_animation!" );
				assertex( isdefined( str_end_notify ), "train_play_bag_throw missing str_end_notify!" );

				
				level endon( str_end_notify );

				
				level waittill( str_start_notify );

				
				while( 1 )
				{
								
								if( isalive( self ) )
								{
												
												self cmdplayanim( str_animation, true );

												
												self waittill( "cmd_done" );
								}
				}

}




train_bag_tosses()
{
				
				level.player endon( "death" );
				level endon( "stop_bag_toss" );
				
				
				
				guy = getent( "train_bag_toss_guy", "script_noteworthy" );
				
				bag = spawn( "script_model", guy.origin );
				
				bag setmodel( "p_igc_duffle_bag" );
				
				bag.targetname = "train_toss_bag";

				
				assertex( isdefined( guy ), "guy not defined" );
				assertex( isdefined( bag ), "bag not defined" );

				
				level thread train_toss_bag_clean_up( bag );

				
				
				guy attach( "p_igc_duffle_bag", "TAG_WEAPON_RIGHT" );

				
				while( 1 )
				{
								
								bag hide();

								
								

								
								level.player waittillmatch( "anim_notetrack", "Bag_Appear" );

								
								bag show();

								
								

								
								level.player waittillmatch( "anim_notetrack", "Bag_Disappear" );
				}

}





train_toss_bag_clean_up( bag )
{
				
				

				
				assertex( isdefined( bag ), "bag is not defined" );

				
				
				guy = getent( "train_bag_toss_guy", "script_noteworthy" );

				
				level waittill( "stop_bag_toss" );

				
				bag hide();

				
				guy detach( "p_igc_duffle_bag", "TAG_WEAPON_RIGHT" );

				
				wait( 1.0 );

				
				bag delete();


}





train_bagtoss_dialogue()
{
				

				
				
				trig_start_dialogue = getent( "trig_start_tosser_dialogue", "targetname" );
				trig_end_dialogue = getent( "trig_end_tosser_dialogue", "targetname" );
				
				enta_bag_tossers = getentarray( "bag_tosser", "targetname" );

				
				assertex( isdefined( trig_start_dialogue ), "trig_start_dialogue not defined" );
				assertex( isdefined( trig_end_dialogue ), "trig_end_dialogue not defined" );
				assertex( isdefined( enta_bag_tossers ), "enta_bag_tossers not defined" );

				
				trig_start_dialogue waittill( "trigger" );

				
				
				enta_bag_tossers[0] play_dialogue( "DMR1_TraiG_037A" );

				
				enta_bag_tossers[1] play_dialogue_nowait( "DMR1_TraiG_038A" );

				
				enta_bag_tossers[0] play_dialogue_nowait( "DMR1_TraiG_039A" );

				
				enta_bag_tossers[1] play_dialogue_nowait( "DMR1_TraiG_040A" );

				
				enta_bag_tossers[0] play_dialogue_nowait( "DMR1_TraiG_041A" );

				
				enta_bag_tossers[1] play_dialogue_nowait( "DMR1_TraiG_042A" );

				
				trig_end_dialogue waittill( "trigger" );

				
				level notify( "stop_bag_toss" );

				
				for( i=0; i<enta_bag_tossers.size; i++ )
				{
								
								if( isalive( enta_bag_tossers[i] ) )
								{
												
												enta_bag_tossers[i] stopallcmds();

												
												enta_bag_tossers[i] setenablesense( true );

												
												enta_bag_tossers[i] setcombatrole( "turret" );

												
												enta_bag_tossers[i] thread turn_on_sense( 5 );
								}
				}
}


activate_boxcar_door()
{
				
				
				level maps\_autosave::autosave_now( "montenegrotrain" );

				while(Distance( level.freight_playerpos.origin, level.player.origin ) > 64 )
				{
								wait(0.05);
				}	
				
				
				
				level.player setorigin( level.freight_playerpos.origin );
				
				
				
				
				level.player setplayerangles( (0, 92, 0) );
				
				thread open_boxcar_door();

				wait( 0.5 );

				while( level.door_busy == true)
				{
								
								
								
								
								
								
								level.player playerSetForceCover( true );
								wait(0.1);
				}
				
				
				
				
				
				
				wait (0.1);
				level.player playerSetForceCover( false, false );

}						





open_boxcar_door(strcObject)
{
				thread start_boxcar_scene();
}
start_boxcar_scene()
{	

				level.player freezecontrols( true );
				level.player SetCanDamage(false);

				
				while( level.train_moving == true )
				{
								wait(0.05);
				}


				level.freight_door2 unlink();
				level.freight_door2 movex(58, 1.0);

				
				level.freight_door2 playsound("boxcar_door_open");

				wait(1.0);
				level.freight_door2 linkto( getent( level.freight_door2.target, "targetname" ) );

				
				level notify( "seperator_play" );

				
				level.player customcamera_checkcollisions( 0 );

				
				SetDvar( "r_lodBias", -750 );

				
				
				
				level notify( "wave_2_start" );

				level.cameraID = level.player customcamera_push( "entity", level.enemy_seperator, level.enemy_seperator, (-120, 10, 60 ), ( -20, 0, 0 ), 2.0 );
				wait(1.0);
				
				
				
				level.enemy_seperator play_dialogue( "CPMR_TraiG_034A" );

				
				level notify( "playmusicpacakge_decouple" );

				wait(2.0);

				
				
				


				level.player customCamera_pop(level.cameraID, 0.05);

				
				level.player customcamera_checkcollisions( 1 );

				
				SetDvar( "r_lodBias", 0 );

				level.player freezecontrols( false );
				level.player SetCanDamage(true);

				level.door_busy = false;

				
				
				
				
				
				
				
}	





	

check_for_player_death()
{
				level endon("enemy_dead");

				while(IsAlive(level.player) && level.clock_running == true )
				{
								wait(0.05);
				}	
				
				SetDVar("r_pipSecondaryMode", 0);
}	


enemy_seperator_wakeup(enemy)
{
				while(IsDefined(enemy) && Distance( enemy.origin, level.player.origin ) > 128 )
				{
								
								
								wait(0.05);
				}
				level.welding_now = false;
				level notify("stop_welding");

				if(IsDefined(enemy))
				{
								enemy allowedstances("crouch", "stand");
								enemy SetEnableSense( true );
								enemy waittill("death");
								level notify("enemy_dead");
				}
				else
				{
								level notify("enemy_dead");
				}	
}
enemy_seperator_healthcheck(enemy)
{
				while(enemy.health > 0)
				{
								wait(0.05);
				}	
				level notify("enemy_dead");
}	

stop_freight_train()
{
				end_trig = GetEnt("freight_end_trig", "targetname");

				if ( IsDefined( end_trig ) )
				{
								end_trig waittill("trigger");
								level.freight_train_active = false;
								
								
								
								
								if( flag( "freight_train_active" ) )
								{
												level flag_clear( "freight_train_active" );

												
												
												
												
												
								}
								

								
								
								
								
								
								
								
								
								

								
								if(	level.on_freight_train == true)
								{
												exit_train_pos = GetEnt( "exit_freight_train", "targetname" );
												level.on_freight_train = false;

												
												
												
												level flag_clear( "on_freight_train" );

												level.train_passing_by = false;
								}

								
								
								
								
								level waittill( "Train_Bond_Jump_done" );

								
								
								
								
								
								
								
								

								
								level.freight_train[0] moveto( level.freight_train_end.origin, 30 );
								level.freight_train[0] waittill( "movedone" );

								
								level.freight_train = maps\_utility::array_removeUndefined( level.freight_train );

								for ( i = 0; i < level.freight_train.size; i++ )
								{
												
												level.freight_train[i] hide();

												
												level.freight_train[i] unlink();

												
												level.freight_train[i] delete();
								}
								
								
								
								
								
								if( isdefined( level.freight_door1_right ) )
								{
									
									
									level.freight_door1_right hide();
								}

								
								if( isdefined( level.freight_door1_left ) )
								{
									level.freight_door1_left hide();
								}
								
								if( isdefined( level.freight_door2 ) )
								{
									level.freight_door2 hide();
								}
								
								
								
								
								
								
								
								level.enta_freight_smodels = maps\_utility::array_removeUndefined( level.enta_freight_smodels );
								
								
								
								
								
								for( i=0;i<level.enta_freight_smodels.size; i++ )
								{
												
												if( isdefined( level.enta_freight_smodels[i] ) )
												{
																
																level.enta_freight_smodels[i] unlink();
																
																
																level.enta_freight_smodels[i] delete();
												}

												
												wait( 0.05 );
								}
								
								enta_boxcar_enemies = getentarray( "boxcar_surprise", "targetname" );
								enta_bagtoss_enemies = getentarray( "bag_tosser", "targetname" );
								enta_freight_wave1 = getentarray( "f_enemy_wave_1", "targetname" );
								enta_freight_wave2 = getentarray( "f_enemy_wave_2", "targetname" );
								enta_freight_wave3 = getentarray( "f_enemy_wave_3", "targetname" );

								
								if( enta_boxcar_enemies.size > 0 )
								{
												
												for( i=0; i<enta_boxcar_enemies.size; i++ )
												{
																if( isalive( enta_boxcar_enemies[i] ) )
																{
																				
																				enta_boxcar_enemies[i] hide();

																				
																				enta_boxcar_enemies[i] unlink();

																				wait( 0.05 );

																				
																				enta_boxcar_enemies[i] delete();


																}
												}
								}

								
								if( enta_bagtoss_enemies.size > 0 )
								{
												
												for( i=0; i<enta_bagtoss_enemies.size; i++ )
												{
																if( isalive( enta_bagtoss_enemies[i] ) )
																{
																				
																				enta_bagtoss_enemies[i] hide();

																				
																				enta_bagtoss_enemies[i] unlink();

																				wait( 0.05 );

																				
																				enta_bagtoss_enemies[i] delete();

																				wait( 0.05 );
																}
												}
								}

								
								if( enta_freight_wave1.size > 0 )
								{
												
												for( i=0; i<enta_freight_wave1.size; i++ )
												{
																if( isalive( enta_freight_wave1[i] ) )
																{
																				
																				enta_freight_wave1[i] hide();

																				
																				enta_freight_wave1[i] unlink();

																				wait( 0.05 );

																				
																				enta_freight_wave1[i] delete();
																}
												}
								}

								
								if( enta_freight_wave2.size > 0 )
								{
												
												for( i=0; i<enta_freight_wave2.size; i++ )
												{
																if( isalive( enta_freight_wave2[i] ) )
																{
																				
																				enta_freight_wave2[i] hide();

																				
																				enta_freight_wave2[i] unlink();

																				wait( 0.05 );

																				
																				enta_freight_wave2[i] delete();

																}
												}
								}

								
								if( enta_freight_wave3.size > 0 )
								{
												
												for( i=0; i<enta_freight_wave3.size; i++ )
												{
																if( isalive( enta_freight_wave3[i] ) )
																{
																				
																				enta_freight_wave3[i] hide();

																				
																				enta_freight_wave3[i] unlink();

																				wait( 0.05 );

																				
																				enta_freight_wave3[i] delete();

																}
												}
								}
								
				}
				else
				{
								iPrintLnBold( "couldn't find freight end trigger!" );
								return;
				}	
}	
random_train_movement()
{	
				
				
				
				
				
				
				
				
				
				
				
				
				
				level endon( "stop_random_freight" );


				
				
				
				
				while( level.freight_train_active == true )
				{
								
								
								
								time = randomfloatrange(1.0, 5.0);
								
								wait(time);

								
								if(	level.on_freight_train == true)
								{
												
												y = randomfloatrange(-64.0, 64.0);
												
												speed = 8.0;
								}
								
								else
								{
												
												y = randomfloatrange(-256.0, 256.0);
												
												speed = randomfloatrange(10.0, 20.0);
								}	

								
								if(level.door_busy == false)
								{
												
												level.train_moving = true;
												
												
												
												level flag_set( "freight_train_moving" );

												
												
												level.freight_train[0] moveto( level.current_train_pos.origin + (0, y * 0.5, 0), speed * 0.5 );
												
												level.freight_train[0] waittill( "movedone" );

												
												if(level.door_busy == false)
												{
																
																level.freight_train[0] moveto( level.current_train_pos.origin + (0, y, 0), speed * 0.5 );
																
																level.freight_train[0] waittill( "movedone" );
												}
												
												level.train_moving = false;
												
												
												level flag_clear( "freight_train_moving" );
								}
				}

				
				
				
				
				
}



create_time_limit(seconds)
{
				level endon("enemy_dead");
				level endon("death");
				
				
				
				
				level endon( "stop_welding" );

				level.timer_hud = newHudElem();
				level.timer_hud.alignX = "center";
				level.timer_hud.alignY = "top";
				level.timer_hud.fontScale = 3.0;
				level.timer_hud.x = 0;
				level.timer_hud.y = 50;
				level.timer_hud.horzAlign = "center";
				level.timer_hud.vertAlign = "fullscreen";
				level.timer_hud setText( seconds );

				
				
				
				
				
				
				
				level.clock_running = true;

				for(i = seconds; i > -1; i--)
				{
								level.timer_hud settext(i);
								wait(1);
				}

				level.clock_running = false;
				level notify("time_limit_reached");
}
end_timer_hud()
{
				level waittill("enemy_dead");
				level.clock_running = false;
				level.timer_hud destroy();

				
				
				
				
				
				
				

				
}
fail_timer_hud()
{
				level endon("enemy_dead");
				level endon("death");

				level waittill("time_limit_reached");

				
				
				SetDVar("r_pipSecondaryMode", 0);
				
				thread seperation_successful();
}

seperation_successful()
{
				
				level.player SetCanDamage(false);

				
				look_direction = VectorToAngles( (level.enemy_seperator.origin + (0, 0, 72)) - (level.player.origin + (0, 0, 72)) ); 
				level.player setplayerangles(look_direction);
				level.player freezecontrols( true );

				level.welding_now = false;
				level notify("stop_welding");

				train_car = GetEnt("freight7", "targetname");
				train_car unlink();

				
				train_car moveto( level.freight_train_end.origin, 40, 10, 0 );
				wait(3.0);
				MissionFailedWrapper();
}	














welding_sparks(fx, light)
{
				level endon("stop_welding");

				
				level thread welding_light_off( light );

				light SetLightIntensity( 1.2 );

				while(level.welding_now == true)
				{
								wait(1.25);
								light thread light_flicker(true, 0.5 , 1.5);
								Playfx(level._effect["welding_sparks"], fx.origin);
								wait(2.25);
								light notify("stop_light_flicker");
				}
				light setlightintensity (0);
}




welding_light_off( light )
{
				
				assertex( isdefined( light ), "light not defined" );

				
				level waittill( "stop_welding" );

				
				wait( 0.05 );

				
				light setlightintensity (0);


}

train_car4_delayed_clean()
{
	wait(10.0);
	deleteallcorpses( 1 );
}






train_first_uncouple()
{
				
				level.player endon( "death" );

				
				
				trig_seperator_dialogue = getent( "trig_1st_uncouple_dialogue", "targetname" );
				trig_uncouple = getent( "trig_start_first_uncouple", "targetname" );
				trig_jump_success = getent( "trig_first_uncouple_success", "targetname" );
				
				train_car = GetEnt( "freight5", "targetname" );
				
				
				earthquake_org = undefined;
				
				int_time = undefined;

				
				if( isdefined( trig_seperator_dialogue ) )
				{
								
								trig_seperator_dialogue waittill( "trigger" );

								

								
								if( isdefined( level.seperator ) )
								{
												
												if( isalive( level.seperator ) )
												{
																
																level.seperator thread train_play_dialogue( "CPMR_TraiG_035A" );
												}
								}
				}

				
				if( isdefined( trig_uncouple ) )
				{
								
								trig_uncouple waittill( "trigger" );

								
								level.freight_train_active = false;
								
								level notify("stop_welding");

								
								if( isdefined( level.seperator ) )
								{
												
												if( isalive( level.seperator ) )
												{
																
																level.seperator stopallcmds();

																
																wait( 0.05 );

																
																level.seperator setenablesense( true );

																
																level.seperator thread train_play_dialogue( "CPMR_TraiG_036A" );

																
																level.seperator allowedstances( "stand" );

																
																level.seperator thread turn_on_sense( 3 );

																
																level notify( "knuckle_break_break_start" );

																
																earthquake( 0.7, 4, level.player, 500 );

																
																

																
																level.seperator dodamage( level.seperator.health + 500, level.seperator.origin + ( 0, 0, 65 ) );
																
												}
								}
								level.welding_now = false;
								
								level.clock_running = false;
								
								
				}
				else
				{
								
								iprintlnbold( trig_uncouple.targetname + " is not defined!" );
				}

				
				while( level.train_moving == true )
				{
								
								wait( 0.05 );
				}

				
				if( isdefined( train_car ) )
				{
								
								train_car unlink();
				}
				else
				{
								
								iprintlnbold( train_car.targetname + " is not defined!" );

								
								return;
				}

				
				level thread freight_1st_uncouple_cleanup();
				
				
				
				level thread train_car4_delayed_clean();
				
				deleteallcorpses( 1 );

				
				
				
				level.ai_to_delete = getaiarray("axis", "neutral");
				
				train_car thread train_car_fall_back( level.freight_train_end.origin, "1_uncouple_done" );
				

				
				

				
				freight_coupling_1_org_var = getent("freight_coupling_1_org", "targetname");
				if( isdefined( freight_coupling_1_org_var ) )
				{
								freight_coupling_1_org_var playsound("freight_coupler_1");

				}	

				
				level waittill( "1_uncouple_done" );
				level thread jump_success_autosave();

				
				wait( 1.0 );

				
				
				
				if( isdefined( trig_jump_success ) )
				{
								
								if( level.player istouching( train_car ) )
								{
								if( !level.player istouching( trig_jump_success ) )
								{
												
												MissionFailedWrapper();
								}
								
								}
								
				}

}

jump_success_autosave()
{
	trig_jump_success = getent( "trig_first_uncouple_success", "targetname" );
	trig_jump_success waittill("trigger");
	
	
	
	
	
	
	level maps\_autosave::autosave_now( "montenegrotrain" );
}





freight_1st_uncouple_cleanup()
{
				

				
				
				
				
				
				
				
				

				
				level waittill( "1_uncouple_done" );

				
				wait( 30.0 );

				
				level thread freight_clean_off_single_car( level.freight_train[4] );
				level thread freight_clean_off_single_car( level.freight_train[5] );
				level thread freight_clean_off_single_car( level.freight_train[6] );
				level thread freight_clean_off_single_car( level.freight_train[7] );
				level thread freight_clean_off_single_car( level.freight_train[8] );
				level thread freight_clean_off_single_car( level.freight_train[9] );
				deleteallcorpses( 1 );
				if(isdefined(level.ai_to_delete))
				{
					size = level.ai_to_delete.size;
					for( i = 0; i < size; i++)
					{
						if(!isremovedentity(level.ai_to_delete[i]))
						{
							level.ai_to_delete[i] setenablesense( false );
							
							level.ai_to_delete[i] hide();
							
							level.ai_to_delete[i] delete();
						}
					}
					level.ai_to_delete = undefined;
				}
				else
				{
					iprintlnbold("aitodelete is not defined!!!");
				}
}




freight_clean_off_single_car( ent_car )
				{
				

				
				assertex( isdefined( ent_car ), "ent_car not defined" );

				
				
				enta_stuff_oncar = getentarray( ent_car.targetname, "target" );

				
				for( i=0; i<enta_stuff_oncar.size; i++ )
				{
								if( enta_stuff_oncar[i].targetname == "freight_train_models" )
								{
												
												enta_stuff_oncar[i] delete();
				}
				else
				{
												continue;
				}
				}

				
				wait( 0.05 );

				
				ent_car delete();
}





train_second_uncouple()
{
				
				level.player endon( "death" );

				
				
				use_trig = getent( "freight_uncouple_trigger", "targetname" );
				
				use_trig sethintstring(&"MONTENEGROTRAIN_UNCOUPLE_LEVER");
				move_train3 = getent( "trig_move_train3", "targetname" );
				success_trig = getent( "trig_check_2nd_success", "targetname" );
				
				uncouple_lever = getent( "freight_uncouple_lever", "script_noteworthy" );
				brush_blocker = getent( "freight_box_blocker", "script_noteworthy" );
				
				train_car = GetEnt( "freight4", "targetname" );
				wooden_box = getent( "freight_uncouple_crate", "script_noteworthy" );
				original_link = getent( uncouple_lever.target, "targetname" );
				
				push_away_vec = undefined;
				second_point = undefined;
				final_point = undefined;

				
				use_trig waittill( "trigger" );

	
	use_trig delete();

				
				

				
				

				
				uncouple_lever unlink();

				
				uncouple_lever rotateyaw( 90, 1.0 );

				
				uncouple_lever playsound("uncoupling_lever");

				
				uncouple_lever waittill( "rotatedone" );

				
				uncouple_lever linkto( original_link );

				
				level notify( "knuckle_release_release_start" );

				
				earthquake( 0.7, 1.2, level.player.origin, 512 );

				
				freight_coupling_2_org_var = getent("freight_coupling_2_org", "targetname");
				if( isdefined( freight_coupling_2_org_var ) )
				{
								freight_coupling_2_org_var playsound("freight_coupler_2");
								
				}	

				
				deleteallcorpses( 1 );

				
				wait( 1.0 );

				
				if( isdefined( train_car ) )
				{
								
								train_car unlink();

								
								level.player playsound("uncouple_big_shake_01");

								
								brush_blocker unlink();

								
								brush_blocker delete();

				}
				else
				{
								
								iprintlnbold( train_car.targetname + " is not defined!" );

								
								return;
				}

				
				level thread freight_2nd_uncouple_cleanup();

				
				
				train_car thread train_car_fall_back( level.freight_train_end.origin, "2_uncouple_done" );

				
				level waittill( "2_uncouple_done" );

				
				if( !level.player istouching( train_car ) )
				{
								
								if( !level.player istouching( success_trig ) )
								{
												
												MissionFailedWrapper();
								}
				}
				else
				{
								
								iprintlnbold( "player made jump" );
				}

				
				level notify( "box_fall_start" );
				
				
				boxfallclip = getent( "boxfallclip" , "script_noteworthy" );
				if (isdefined(boxfallclip))
				{
					boxfallclip delete();
				}
				
				
				
				
				
				level.player play_dialogue( "TANN_TraiG_043A", true );

				
				level.player play_dialogue( "BOND_TraiG_044A" );

				
				level.player play_dialogue( "TANN_TraiG_045A", true );

				
				
				level maps\_autosave::autosave_now( "montenegrotrain" );

}




freight_2nd_uncouple_cleanup()
{
				

				
				
				
				
				
				
				
				

				
				level waittill( "2_uncouple_done" );

				
				wait( 30.0 );

				
				level thread freight_clean_off_single_car( level.freight_train[3] );


}








train_car_fall_back( vec_final_point, str_notify )
{
				
				level.player endon( "death" );

				
				
				int_loops = 0;
				

				
				assertex( isdefined( vec_final_point ), "train_car_fall_back missing vec_final"  );

				
				if( !isdefined( str_notify ) )
				{
								
								str_notify = "train_car_away";
				}

				
				
				while( int_loops < 3 )
				{
								
								self moveto( self.origin + ( 0, -2, 0 ), 0.5 );

								
				self waittill( "movedone" );

								
								int_loops++;
				}

				
				self moveto( vec_final_point, 50.0, 25.0 );

				
				wait( 4.4 );

				
				level notify( str_notify );

}




outside_train_init()
{
				
				

				
				

				
				level thread inside_trigger_init();

				
				

				
	
	

				
				level thread train_wind_control();

				
				level thread train_vision_sets();

				
				level thread train_no_sprint();

}




inside_trigger_init()
{
				
				
				level.player endon( "death" );

				
				
				enta_trig_playerinside = getentarray( "trig_player_inside", "targetname" );

				
				if( isdefined( enta_trig_playerinside ) )
				{
								
								while( 1 )
								{
												
												for( i=0; i<enta_trig_playerinside.size; i++ )
												{
																
																if( level.player istouching( enta_trig_playerinside[i] ) )
																{
																				
																				flag_clear( "outside_train" );

																				
																				

																				
																				

																				
																				
																				
																				while( level.player istouching( enta_trig_playerinside[i] ) )
																				{
																								
																								wait( 0.2 );
																				}

																}

																
																flag_set( "outside_train" );

																
																

												}

												
												wait( 0.1 );
								}
				}
				else
				{
								
								iprintlnbold( "enta_trig_playerinside, not defined!" );

								
								return;
				}



}








train_player_touching()
{	
				
				
				level.player endon( "death" );

				
				
				while( 1 )
				{
								
								if( level.player istouching( self ) )
								{
												if( flag( "outside_train" ) )
												{
																
																flag_clear( "outside_train" );

																iprintlnbold( "cleared_outside_train" );
												}

												
												wait( 0.1 );

								}
								else
								{
												if( !flag( "outside_train" ) )
												{

												}
												
												flag_set( "outside_train" );

												
												wait( 0.1 );
								}
								
								wait( 0.1 );

				}

}




train_wind_control()
{
				
				
				
				level.player endon( "death" );

				
				
				
				
				
				
				
				

				
				while( 1 )
				{

								
								if( flag( "outside_train" ) == 0 )
								{
												
												setsaveddvar( "wind_movementEnabled", 0 );

												
												

												
												wait( 0.1 );

								}

								if( flag( "outside_train" ) == 1 )
								{
												
												setsaveddvar( "wind_movementEnabled", 1 );

												
												

												
												wait( 0.1 );

								}

								
								wait( 0.1 );

								
								
								
								while( flag( "outside_train" ) == 1 )
								{
												
												if( level.player getstance() == "stand" )
												{
																
																

																
																level.player setwind( 0, -65 );

																
																

																
																wait( 0.05 );

												}
												
												if( level.player getstance() == "crouch" )
												{
																
																

																
																
																level.player setwind( 0, -20 );

																
																

																
																wait( 0.05 );

												}

												
												wait( 0.05 );
								}
				}
}





train_blur_control()
{
				
				
				level.player endon( "death" );

				
				
				setdvar( "r_motionblur_dist", 420 );
				setdvar( "r_motionblur_maxBlurAmt", 8 );
				setdvar( "r_motionblur_farStart", 1750 );
				setdvar( "r_motionblur_farEnd", 3000 );
				setdvar( "r_motionblur_nearStart", 350 );
				setdvar( "r_motionblur_nearEnd", 450 );
				setdvar( "r_motionblur_envMotionVector", "1 10 1" );

				
				
				while( 1 )
				{
								
								if( flag( "outside_train" ) == 0 )
								{
												
												setdvar( "r_motionblur_enable", 0 );

												
												

												
												wait( 0.1 );
								}

								
								if( flag( "outside_train" ) == 1 )
								{
												
												setdvar( "r_motionblur_enable", 1 );

												
												

												
												wait( 0.1 );
								}

				}

}





train_vision_sets()
{
				
				level endon( "tunnel_vision_set" );
				
				
				
				int_inside = 0;
				int_outside = 0;

				
				while( 1 )
				{
								
								while( flag( "outside_train" ) == 0 && flag( "on_freight_train" ) == 0 )
								{
												
												if( int_inside == 0 )
												{
																
																VisionSetNaked( "MontenegroTrain_in", 0.5 );

																
																wait( 0.6 );

																
																

																
																int_inside = 1;
																int_outside = 0;
												}

												
												wait( 0.2 );
								}

								
								while( flag( "on_freight_train" ) == 1 )
								{
												
												if( int_outside == 0 )
												{
																
																VisionSetNaked( "MontenegroTrain", 0.5 );

																
																wait( 0.6 );

																
																

																
																int_inside = 0;
																int_outside = 1;
												}

												
												wait( 0.2 );
								}

								
								while( flag( "outside_train" ) == 1 )
								{
												
												if( int_outside == 0 )
												{
																
																VisionSetNaked( "MontenegroTrain", 0.5 );

																
																wait( 0.6 );

																
																

																
																int_inside = 0;
																int_outside = 1;
												}

												
												wait( 0.2 );
								}

								
								wait( 0.05 );
				}
}



train_no_sprint()
{
				

				
				
				int_inside = 0;
				int_outside = 0;

				
				while( 1 )
				{
								
								while( flag( "outside_train" ) == 0 )
								{
												
												if( int_inside == 0 )
												{
																
																SetSavedDVar( "cover_dash_fromCover_enabled", false );
																SetSavedDVar( "cover_dash_from1stperson_enabled", false );

																
																wait( 0.6 );

																
																

																
																int_inside = 1;
																int_outside = 0;
												}

												
												wait( 0.2 );
								}

								while( flag( "outside_train" ) == 1 )
								{
												
												if( int_outside == 0 )
												{
																
																SetSavedDVar( "cover_dash_fromCover_enabled", true );
																SetSavedDVar( "cover_dash_from1stperson_enabled", true );

																
																wait( 0.6 );

																
																

																
																int_inside = 0;
																int_outside = 1;
												}

												
												wait( 0.2 );
								}

								
								wait( 0.05 );
				}

}




















train_elec_pylon_init()
{
				
				
				level.player endon( "death" );

				
				
				enta_elec_pylon_dmg_trigs = getentarray( "conduit_damage", "targetname" );

				
				
				

				
				for( i=0; i<enta_elec_pylon_dmg_trigs.size; i++ )
				{
								
								enta_elec_pylon_dmg_trigs[i] thread train_elec_pylon_sound();

								
								wait( 0.5 );
				}

}








train_elec_pylon_sound()
{
				
				level.player endon( "death" );
				

				
				while( 1 )
				{
								
								if( level.player istouching( self ) )
								{
												
												
												level notify( "player_touching_elec_pylon" );

												
												
												self playsound("electric_shock");
												wait( 0.5 );
								}

								
								wait( 0.5 );
				}
}







freight_boxcar_door_surprise()
{
				
				self endon( "death" );
				level.player endon( "death" );

				
				level flag_wait( "car4_boxcar_surprise" );

				
				
				self cmdshootatentity( level.player, true, 6.0, 0.2 );

				
				self setenablesense( true );
				self setcombatrole( "turret" );
				self setengagerule( "tgtSight" );
				self addengagerule( "tgtPerceive" );
				self addengagerule( "Damaged" );
				self addengagerule( "Attacked" );

}




intro_card_n_pic()
{
				
				level.player endon( "death" );

				
				wait( 0.05 );

				
				
				
				
				

				

				wait( 0.05 );

				
				
								
								
				

				level.move_intro_scr = true;

				
				

				
				
				
				
				
				
				
				level.player attach( "p_igc_vesper_business_card", "TAG_WEAPON_RIGHT" );

				
				

				
				wait( 0.05 );


				
				level.player waittillmatch( "anim_notetrack", "lightning_flash" );
				

				
				level.player waittillmatch( "anim_notetrack", "bizcard_show" );

				
				
				

				
				level.player waittillmatch( "anim_notetrack", "bizcard_hide" );

				
				
				
				
				
				
				level.player detach( "p_igc_vesper_business_card", "TAG_WEAPON_RIGHT" );
				
				
				wait( 0.05 );

				
				
				
				
				level.bizcard delete();

				
				wait( 0.05 );

				
				
				
				
				level.player attach( "p_igc_bliss_headshot", "TAG_WEAPON_RIGHT" );

				
				
				

				
				level.player waittillmatch( "anim_notetrack", "photo_show" );
				
				
				
				level.bliss_pic show();

				
				

				
				level.player waittillmatch( "anim_notetrack", "photo_release" );

				
				
				
				
				level.player detach( "p_igc_bliss_headshot", "TAG_WEAPON_RIGHT" );

				
				level.bliss_pic hide();

				

				level waittill( "MT_TR_Intro_done" );

				
				level notify( "intro_model_attach" );

				
				wait( 0.05 );

				
				

				
				wait( 1.0 );

				
				
}











train_objectives()
{
				
				level.player endon( "death" );

				
				
				
				obj_1a = getent( "so_train_obj_1a", "script_noteworthy" ); 
				obj_1b = getent( "so_train_obj_1b", "script_noteworthy" ); 
				obj_1c = getent( "so_train_obj_1c", "script_noteworthy" ); 
				
				obj_2a = getent( "so_train_obj_2a", "script_noteworthy" ); 
				obj_2b = getent( "so_train_obj_2b", "script_noteworthy" ); 
				obj_2c = getent( "so_train_obj_2c", "script_noteworthy" ); 
				obj_2d = getent( "so_train_obj_2d", "script_noteworthy" ); 
				
				obj_3a = getent( "so_train_obj_3a", "script_noteworthy" ); 
				obj_3b = getent( "so_train_obj_3b", "script_noteworthy" ); 
				
				obj_4a = getent( "so_train_obj_4a", "script_noteworthy" ); 
				obj_4b = getent( "so_train_obj_4b", "script_noteworthy" ); 
				
				obj_5 = getent( "so_train_obj_5", "script_noteworthy" ); 
				
				obj_6a = getent( "so_train_obj_6a", "script_noteworthy" ); 
				obj_6b = getent( "so_train_obj_6b", "script_noteworthy" ); 
				
				
				
				assertex( isdefined( obj_1a ), "obj_1a not defined" );
				assertex( isdefined( obj_1b ), "obj_1b not defined" );
				assertex( isdefined( obj_1c ), "obj_1c not defined" );
				assertex( isdefined( obj_2a ), "obj_2a not defined" );
				assertex( isdefined( obj_2b ), "obj_2b not defined" );
				assertex( isdefined( obj_2c ), "obj_2c not defined" );
				assertex( isdefined( obj_2d ), "obj_2d not defined" );
				assertex( isdefined( obj_3a ), "obj_3a not defined" );
				assertex( isdefined( obj_3b ), "obj_3b not defined" );
				assertex( isdefined( obj_4a ), "obj_4a not defined" );
				assertex( isdefined( obj_4b ), "obj_4b not defined" );
				assertex( isdefined( obj_5 ), "obj_5 not defined" );
				assertex( isdefined( obj_6a ), "obj_6a not defined" );
				assertex( isdefined( obj_6b ), "obj_6b not defined" );
				

				
				
				if( !flag( "train_obj_1" ) )
				{
								
								objective_add( 1, "current", &"MONTENEGROTRAIN_OBJ_1_TITLE", obj_1a.origin, &"MONTENEGROTRAIN_OBJ_1_BODY" );

								
								while( distancesquared( level.player.origin, obj_1a.origin ) > 35*35 )
								{
												
												wait( 0.1 );
								}

								
								objective_position( 1, obj_1b.origin );

								
								while( distancesquared( level.player.origin, obj_1b.origin ) > 60*60 )
								{
												
												wait( 0.1 );
								}

								
								objective_position( 1, obj_1c.origin );

								
								while( distancesquared( level.player.origin, obj_1c.origin ) > 200*200 )
								{
												
												wait( 0.1 );
								}

								
								flag_set( "train_obj_1" );
				}

				
				if( !flag( "train_obj_2" ) )
				{
								
								objective_add( 1, "current", &"MONTENEGROTRAIN_OBJ_2_TITLE", obj_2a.origin, &"MONTENEGROTRAIN_OBJ_2_BODY" );

								

								
								while( distancesquared( level.player.origin, obj_2a.origin ) > 200*200 )
								{
												
												wait( 0.1 );
								}

								
								objective_position( 1, obj_2b.origin );

								
								while( distancesquared( level.player.origin, obj_2b.origin ) > 150*150 )
								{
												
												wait( 0.1 );
								}

								
								objective_position( 1, obj_2c.origin );

								
								while( distancesquared( level.player.origin, obj_2c.origin ) > 70*70 )
								{
												
												wait( 0.1 );
								}

								
								objective_position( 1, obj_2d.origin );

								
								while( distancesquared( level.player.origin, obj_2d.origin ) > 40*40 )
								{
												
												wait( 0.1 );
								}

								
								flag_set( "train_obj_2" );

				}

				
				if( !flag( "train_obj_3" ) )
				{
								
								objective_add( 1, "current", &"MONTENEGROTRAIN_OBJ_3_TITLE", obj_3a.origin, &"MONTENEGROTRAIN_OBJ_3_BODY" );

								
								while( distancesquared( level.player.origin, obj_3a.origin ) > 70*70 )
								{
												
												wait( 0.1 );
								}

								
								objective_position( 1, obj_3b.origin );

								
								level waittill( "Train_Bond_Jump_done" );

								
								flag_set( "train_obj_3" );
								
				}

				
				if( !flag( "train_obj_4" ) )
				{
								
								objective_add( 1, "current", &"MONTENEGROTRAIN_OBJ_4_TITLE", obj_4a.origin, &"MONTENEGROTRAIN_OBJ_4_BODY" );
								
								
								while( distancesquared( level.player.origin, obj_4a.origin ) > 90*90 )
								{
												
												wait( 0.1 );
								}

								
								objective_position( 1, obj_4b.origin );

								
								level waittill( "baggage_car_locked" );

								
								flag_set( "train_obj_4" );
				}

				
				if( !flag( "train_obj_5" ) )
				{
								
								objective_add( 1, "current", &"MONTENEGROTRAIN_OBJ_5_TITLE", obj_5.origin, &"MONTENEGROTRAIN_OBJ_5_BODY" );

								
								while( distancesquared( level.player.origin, obj_5.origin ) > 80*80 )
								{
												
												wait( 0.1 );
								}

								
								flag_set( "train_obj_5" );
				}

				
				if( !flag( "train_obj_6" ) )
				{
								
								objective_add( 1, "current", &"MONTENEGROTRAIN_OBJ_6_TITLE", obj_6a.origin, &"MONTENEGROTRAIN_OBJ_6_BODY" );

								
								while( distancesquared( level.player.origin, obj_6b.origin ) > 65*65 )
								{
												
												wait( 0.1 );
								}

								
								objective_position( 1, obj_6b.origin );

								
								level waittill( "bliss_defeated" );

								
								objective_state( 1, "done" );

								
								flag_set( "train_obj_6" );
				}
}

train_tanner_talks_freight()
{
				
				

				
				level.player play_dialogue( "TANN_TraiG_029A", true );

				
				level thread train_challenge_achievement();
}

train_challenge_achievement()
{
				
				

				
				
				str_weapon = undefined;

				
				level flag_wait( "on_freight_train" );

				
				while( flag( "on_freight_train" ) )
				{
								
								str_weapon = level.player GetCurrentWeapon();

								if( str_weapon == "p99_s" || str_weapon == "p99" || str_weapon == "none" || str_weapon == "phone" )
								{
												wait( 0.5 );
								}
								else
								{
												
												

												
												

												
												
												
												
												
												return;
								}
				}

				
				
				GiveAchievement( "Challenge_Train" );
}









turn_on_sense( int_time )
{
				
				self endon( "death" );

				
				if( !isdefined( int_time ) )
				{
								int_time = 3;
				}

				
				self setperfectsense( true );

				
				wait( 3 );

				
				if( IsDefined( self ) && isalive( self ) )
				{
								
								self setperfectsense( false );

				}           
}






sprint_to_goal()
{
				
				self endon( "death" );

				
				self setengagerule( "tgtSight" );
				self addengagerule( "tgtPerceive" );
				self addengagerule( "Damaged" );
				self addengagerule( "Attacked" );

				
				self setscriptspeed( "sprint" );

				
				self waittill( "goal" );

				
				self setscriptspeed( "default" );

}






reset_script_speed()
{
				
				self endon( "death" );

				
				while( self getalertstate() != "alert_red" )
				{
								
								wait( 0.05 );
				}

				
				self setscriptspeed( "default" );

}






dmg_turn_sense_on()
{
				
				self endon( "death" );
				self endon( "sense_on" );

				
				self waittill( "damage", int_amount, str_attacker );

				
				if( str_attacker == level.player )
				{
								
								self setenablesense( true );

								
								self turn_on_sense( 3 );
				}
}




train_play_dialogue( str_SoundFile )
{
				
				self endon( "death" );

				
				self play_dialogue( str_SoundFile );
}




train_bring_up_gun()
{
				
				

				
				
				trig = getent( "roof_start", "targetname" );

				
				assertex( isdefined( trig ), "trig is not defined!" );

				
				trig waittill( "trigger" );

	
	level.player giveWeapon("p99_s");
	
	level.player switchtoWeapon("p99_s");

				
				wait( 1.0 );

				
				maps\_utility::unholster_weapons();

				wait( 0.05 );

				level.player switchtoWeapon("p99_s");
}





train_goal_n_tether( str_node, int_tether_dist )
{
				
				self endon( "death" );

				
				assertex( isdefined( str_node ), "str_node not defined" );
				assertex( isdefined( int_tether_dist ), "int_tether_dist not defined" );

				
				self waittill( "goal" );

				
				self setscriptspeed( "default" );

				
				self.tetherpt = str_node.origin;

				
				self.tetherradius = int_tether_dist;
}





train_reset_speed_activate_tether( nod_tether, int_low_tether, int_high_tether, int_default_tether )
{
				
				self endon( "death" );
				
				
				assertex( isdefined( nod_tether ), "nod_tether not defined" );
				assertex( isdefined( int_low_tether ), "int_low_tether not defined" );
				assertex( isdefined( int_high_tether ), "int_high_tether not defined" );
				assertex( isdefined( int_default_tether ), "int_default_tether not defined" );

				
				self waittill( "goal" );

				
				self setscriptspeed( "default" );

				
				self.tetherpt = nod_tether.origin;

				
				self thread train_active_tether( int_low_tether, int_high_tether, int_default_tether );

}












train_active_tether( tetherDelta0, tetherDelta1, minTether )
{
				
				self endon( "death" );

				
				assertex( isdefined( tetherdelta0 ), "tetherdelta0 is not defined!" );
				assertex( isdefined( tetherDelta1 ), "tetherDelta1 is not defined!" );
				assertex( isdefined( minTether ), "minTether is not defined!" );
				assertex( isdefined( self.tetherpt ), "self.tetherpt is not defined!" );

				
				
				if( tetherDelta0 > tetherDelta1 )
				{
								tetherDelta = randomfloatrange( tetherDelta1, tetherDelta0 );
				}
				
				else
				{
								tetherDelta = randomfloatrange( tetherDelta0, tetherDelta1 );
				}


				
				
				newRad = 1;
				

				
				vec_tether_point = self.tetherpt;

				
				

				
				
				if( !isdefined( self.tetherpt ) )
				{
								iprintlnbold( "no_tether_on " + self.targetname );
								return;
				}

				
				
				while( isdefined( self.tetherPt ) )
				{				
								
								wait( randomfloat( 1.0, 3.5 ) );

								
								
								

								
								
								newRad = Distance( level.player.origin, vec_tether_point ) - tetherDelta;

								
								wait( 0.05 );

								

								


								
								if( newRad < self.tetherradius )
								{	
												
												
												
												if( newRad < minTether )
												{
																
																self.tetherradius = minTether;
												}
												else
												{
																
																self.tetherradius = newRad;

																
																tetherDelta = randomfloatrange( tetherDelta0, tetherDelta1 );
												}
								}
				}
}




goal_n_combatrole( str_combatrole )
{
				
				self endon( "death" );

				
				assertex( isdefined( str_combatrole ), "not defined role for combatrole" );
				assertex( isstring( str_combatrole ), "not string for combatrole" );

				
				self waittill( "goal" );

				
				self setcombatrole( str_combatrole );

}
