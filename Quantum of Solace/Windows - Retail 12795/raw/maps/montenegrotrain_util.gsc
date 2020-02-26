// Montenegro Train utility
// Builder: Don Sielke
// Scripter: Don Sielke
//////////////////////////////////////////////////////////////////////////////////////////
// includes
#include maps\_utility;
#include common_scripts\utility;
// trying to get teh match up to work
#include animscripts\Utility;
#include animscripts\shared;
#include maps\_anim;
#using_animtree("generic_human");


//////////////////////////////////////////////////////////////////////////////////////////
// Simple camera shake for train movement effect. (blur for exterior)
//////////////////////////////////////////////////////////////////////////////////////////
train_shake_inside()
{
				while(level.inside_train == true)
				{
								timer = randomfloatrange(1.5, 3.0);
								shake_amount = randomfloatrange(0.01, 0.07);
								//earthquake(<scale>,<duration>,<source>,<radius>)
								earthquake (shake_amount, timer, level.player.origin, 1000);

								// Steve G - shake sound
								thread Maps\MontenegroTrain_snd::play_shake_int(shake_amount);

								wait(timer);
								//iprintlnbold ( "shake it up inside", shake_amount );
				}	
				thread train_shake_outside();
}	
train_shake_outside()
{
				while(level.inside_train == false)
				{
								timer = randomfloatrange(1.5, 3.0);
								blur_amount = randomfloatrange(0.0, 1.5);
								//shake_amount = randomfloatrange(0.1, 0.15);

								//tie the two together shake more, blur more.
								shake_amount = (blur_amount * 0.1);
								if (shake_amount < 0.05)
								{
												shake_amount = 0.05;
								}	

								setblur( blur_amount, timer );			//ramp up blur
								earthquake (shake_amount, timer, level.player.origin, 1000);

								// Steve G - shake sound
								thread Maps\MontenegroTrain_snd::play_shake_ext(shake_amount);

								wait(timer);
								//iprintlnbold ( "shake amount", shake_amount );
								//iprintlnbold ( "blur amount ", blur_amount );
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

//////////////////////////////////////////////////////////////////////////////////////////
//	Looks for entities with targetname and spawns them
//	Returns the group of spawned AI in an array for reference later
//		targetname = targetname 
//		opt_assign_name = optionally assign each spawned AI a unique targetname starting with (targetname + "0")
//////////////////////////////////////////////////////////////////////////////////////////
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
																new_guy = spawners[i] StalingradSpawn();	//xxx temp fix for the spawners in car 5.  You can sometimes see where they spawn.
																//				new_guy = spawners[i] DoSpawn();
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


//////////////////////////////////////////////////////////////////////////////////////////
//	Looks for entities starting with (targetname + number) and spawns them
//	Returns the group of spawned AI in an array for reference later
//		guys = an empty array to store the AI entities
//		targetname = targetname prefix
//		opt_startnum = optional starting number after targetname.  Defaults to 1
//////////////////////////////////////////////////////////////////////////////////////////
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
								// wwilliams 07-01-08
								// need to check to ssee if the spawner has a script_string
								if( isdefined( spawner.script_string ) )
								{
												// pass this info to the ai
												new_guy.script_string = spawner.script_string;
								}
								// 07-16-08 WWilliams
								// pass the script_noteworthy to the actor so I can clean them up
								if( isdefined( spawner.script_noteworthy ) )
								{
												// pass this info to the ai
												new_guy.script_noteworthy = spawner.script_noteworthy;
								}
								num++;
								spawner = GetEnt( targetname + num, "targetname" );
				}

				return guys;
}
//////////////////////////////////////////////////////////////////////////////////////////
//
// Hud overlay setup.
//
//////////////////////////////////////////////////////////////////////////////////////////

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
//////////////////////////////////////////////////////////////////////////////////////////
//	Assigns civilian behavior, waits for it to be triggered if necessary before moving
//	Thread on an AI
//	spawnername = targetname of the AI's spawner
//////////////////////////////////////////////////////////////////////////////////////////
make_civilian( spawnername )
{
				self.goalradius = 12;	// so she'll go exactly where we want him to
				self.walkdist = 320000;	// walk everywhere
				self animscripts\shared::placeWeaponOn( self.primaryweapon, "none" );	//xxx haxxor to remove weapon

				// If there is a companion trigger, then don't do anything until the trigger is hit
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

																//iPrintLnBold( "civilian moving about.");
																self SetGoalNode(node);
												}
								}
				}
}
//////////////////////////////////////////////////////////////////////////////////////////
//	Setup awarness array for roof hatches.
//////////////////////////////////////////////////////////////////////////////////////////

roof_hatches_setup()
{
				thread triggered_roof_hatches();

				// init bond awareness
				maps\_playerawareness::init();

				entaTemp = GetEntArray( "hatch_unlocked", "targetname" );
				if( IsDefined( entaTemp[0] ) )
				{
								maps\_playerawareness::setupArrayUseOnly(	"hatch_unlocked", 
												::roof_hatch_open, //use event
												"Press &&1 to open roof hatch", //hint string
												0, //use time
												undefined, //use text
												true, //single use
												true, //require lookat
												undefined, //filter to call
												level.awarenessMaterialMetal, //material
												true, //glow
												true ); //shine
				}		

				// 05-22-08
				// wwilliams
				// commenting this out to avoid a crash					
				/* entbTemp = GetEntArray( "hatch_locked", "targetname" );
				if( IsDefined( entbTemp[0] ) )
				{
				maps\_playerawareness::setupArrayUseOnly(	"hatch_locked", 
				::roof_hatch_locked, //use event
				"Roof Hatch Locked", //hint string
				0, //use time
				undefined, //use text
				false, //single use
				true, //require lookat
				undefined, //filter to call
				level.awarenessMaterialNone, //material
				false, //glow
				false ); //shine
				} */ 													

}
roof_hatch_open(strcObject)
{
				if ( isdefined(strcObject.primaryEntity.script_noteworthy) )
				{
								if(strcObject.primaryEntity.script_noteworthy == "reverse" )
								{
												//strcObject.primaryEntity rotatePitch( 170, 1 );
												strcObject.primaryEntity MoveTo( strcObject.primaryEntity.origin + (0, -51, 0), 1 );
								}
				}		
				else
				{
								//strcObject.primaryEntity rotatePitch( -170, 1 );
								strcObject.primaryEntity MoveTo( strcObject.primaryEntity.origin + (0, 51, 0), 1 );
				}
}	
// 05-22-08
// wwilliams
// commenting this out to avoid a crash
/* roof_hatch_locked(strcObject)
{
entbTemp = GetEntArray( "hatch_locked", "targetname" );
if( IsDefined( entbTemp[0] ) )
{
maps\_playerawareness::setupArrayUseOnly(	"hatch_locked", 
::roof_hatch_locked, //use event
"Roof Hatch Locked", //hint string
0, //use time
undefined, //use text
false, //single use
true, //require lookat
undefined, //filter to call
level.awarenessMaterialNone, //material
false, //glow
false ); //shine
}													
} */	

//////////////////////////////////////////////////////////////////////////////////////////
//	Setup triggered roof hatches. (ones you enter from below)
//////////////////////////////////////////////////////////////////////////////////////////
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
				//iPrintLnBold( "trigger hatch ");

				if ( isdefined(hatch.script_noteworthy) )
				{
								if(hatch.script_noteworthy == "reverse" )
								{
												//hatch rotatePitch( 170, 1 );
												hatch MoveTo( hatch.origin + (0, -51, 0), 0.5 );

												//Steve G
												hatch playsound("train_hatch_open");

								}	
				}
				else
				{
								//hatch rotatePitch( -170, 1 );
								hatch MoveTo( hatch.origin + (0, 51, 0), 0.5 );

								//Steve G
								hatch playsound("train_hatch_open");
				}
				// need to add anim for lifting hatch.

				//////////////////////////////////////////////////////////////////////////////////
				// 04-23-08
				// wwilliams
				// making the first hatch close behind the player
				//
				// wait for the hatch to finish moving
				hatch waittill( "movedone" );
				//
				//
				if( isdefined( hatch.script_string ) )
				{
								// now check the script_string to be the correct string
								if( hatch.script_string == "lock_behind_player" )
								{
												// keeps making sure the player has fullfilled a certain criteria
												while( 1 )
												{
																// check to see if the player is above the trig
																if( level.player.origin[2] > hatch.origin[2] && distancesquared( level.player.origin, hatch.origin ) > 60*60 )
																{
																				// close the door behind the player
																				hatch MoveTo( hatch.origin + (0, -51, 0), 0.5 );

																				//Steve G
																				hatch playsound("train_hatch_close");

																				// end function
																				return;
																}
																else if( level.player.origin[2] < hatch.origin[2] )
																{
																				// wait
																				wait( 0.1 );
																}
																
																// avoid infinite script loop
																wait( 0.05 );
												}
								}
				}
				
				//////////////////////////////////////////////////////////////////////////////////
}		
//////////////////////////////////////////////////////////////////////////////////////////
//	Flickering baggage car light.
//////////////////////////////////////////////////////////////////////////////////////////
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


//////////////////////////////////////////////////////////////////////////////////////////
//	Special HUD element for camera.
//////////////////////////////////////////////////////////////////////////////////////////
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

//////////////////////////////////////////////////////////////////////////////////////////
//	Compass Map Changes
//  Monitors what car player is currently in.
//////////////////////////////////////////////////////////////////////////////////////////
compass_map_changer()
{
				// thread off the new functions
				level thread train_level2_map();
				level thread train_level3_map();
				level thread train_level4_map();
				level thread train_level5_map();
				level thread train_level6_map();
				level thread train_level7_map();
				
				
				
				
				//				for ( i=1; i<10; i++)
//				{
//								trig = GetEntArray( "map_car"+i, "targetname" );
//								if ( IsDefined(trig) )
//								{
//												for (t=0; t<trig.size; t++)
//												{
//																thread map_loadnext(trig[t], i);
//												}
//								}		
//				}
//}
//
//map_loadnext(trig, carnum)
//{
//				while(true)
//				{
//								trig waittill( "trigger" );
//								if(carnum == 1)
//								{
//												setminimap( "compass_map_montenegrotrain", 400, -7008, -400, -8608  );   	
//												// WW 07-02-08
//												// map has changed, new call for switching cars
//												setSavedDvar( "sf_compassmaplevel",  "level1" );
//								}
//								if(carnum == 2)
//								{
//												setminimap( "compass_map_montenegrotrain", 400, -5408, -400, -7008  ); 
//												// WW 07-02-08
//												// map has changed, new call for switching cars
//												setSavedDvar( "sf_compassmaplevel",  "level2" );
//								}	
//								if(carnum == 3)
//								{
//												setminimap( "compass_map_montenegrotrain", 400, -3808, -400, -5408  );
//												// WW 07-02-08
//												// map has changed, new call for switching cars
//												setSavedDvar( "sf_compassmaplevel",  "level3" );
//								}	
//								if(carnum == 4)
//								{
//												setminimap( "compass_map_montenegrotrain", 400, -2208, -400, -3808  );
//												// WW 07-02-08
//												// map has changed, new call for switching cars
//												setSavedDvar( "sf_compassmaplevel",  "level4" );
//								}	
//								if(carnum == 5)
//								{
//												setminimap( "compass_map_montenegrotrain", 400, -608, -400, -2208  );
//												// WW 07-02-08
//												// map has changed, new call for switching cars
//												setSavedDvar( "sf_compassmaplevel",  "level5" );
//								}	
//								if(carnum == 6)
//								{
//												setminimap( "compass_map_montenegrotrain", 400, 992, -400, -608  ); 
//												// WW 07-02-08
//												// map has changed, new call for switching cars
//												setSavedDvar( "sf_compassmaplevel",  "level6" );
//								}	
//								if(carnum == 7)
//								{
//												setminimap( "compass_map_montenegrotrain", 400, 2592, -400, 992  );
//												// WW 07-02-08
//												// map has changed, new call for switching cars
//												setSavedDvar( "sf_compassmaplevel",  "level7" );
//								}	
//								if(carnum == 8)
//								{
//												setminimap( "compass_map_montenegrotrain", 400, 4192, -400, 2592  );
//												// WW 07-02-08
//												// map has changed, new call for switching cars
//												setSavedDvar( "sf_compassmaplevel",  "level8" );
//								}	
//								if(carnum == 9)
//								{
//												setminimap( "compass_map_montenegrotrain", 400, 5792, -400, 4192  );
//												// WW 07-02-08
//												// map has changed, new call for switching cars
//												setSavedDvar( "sf_compassmaplevel",  "level9" );
//								}
//				}
}
///////////////////////////////////////////////////////////////////////////
// 08-11-08 WWilliams
// changes the map to level2
train_level2_map()
{
				// endon
				level notify( "in_shoot_car" );

				// objects to define for this function
				trig = getent( "map_level2", "targetname" );

				// while loop
				while( 1 )
				{
								// wait for the trigger
								trig waittill( "trigger" );

								if( getdvar( "sf_compassmaplevel" ) != "level2" )
								{
												// change the map to the level2 setup
												setminimap( "compass_map_montenegrotrain", 200, -5408, -448, -10208 );
												// WW 07-02-08
												// map has changed, new call for switching cars
												setSavedDvar( "sf_compassmaplevel",  "level2" );

												// wait
												wait( 0.5 );
								}
								else
								{
												// wait
												wait( 1.0 );
								}
				}
}
///////////////////////////////////////////////////////////////////////////
// 08-11-08 WWilliams
// changes the map to level3
train_level3_map()
{
				// endon
				level notify( "in_shoot_car" );

				// objects to defined for this function
				trig = getent( "trig_car4_spot", "targetname" );

				// while loop
				while( 1 )
				{
								// wait for the trigger
								trig waittill( "trigger" );
								
								if( getdvar( "sf_compassmaplevel" ) != "level3" )
								{
												// change the map to the level3 setup
												setminimap( "compass_map_montenegrotrain", 200, -608, -448, -5408 );
												// WW 07-02-08
												// map has changed, new call for switching cars
												setSavedDvar( "sf_compassmaplevel",  "level3" );

												// wait
												wait( 0.5 );
								}
								else
								{
												wait( 1.0 );
								}

				}
}
///////////////////////////////////////////////////////////////////////////
// 08-11-08 WWilliams
// changes the map to level4
train_level4_map()
{
				// endon

				// objects to be defined for this function
				// trig = getent( "", "targetname" );

				// wait for the notify to move the freight
				level maps\_utility::flag_wait( "freight_to_node3" );

				// wait for the freight to move into position
				level.freight_train[0] waittill( "movedone" );

				// change the map to level4
				setminimap( "compass_map_montenegrotrain", 200, -2304, -448, -7104 );
				// WW 07-02-08
				// map has changed, new call for switching cars
				setSavedDvar( "sf_compassmaplevel",  "level4" );

}
///////////////////////////////////////////////////////////////////////////
// 08-11-08 WWilliams
// change the map to level5
train_level5_map()
{
				// endon

				// objects to define this function

				// wait for the jump to hit
				level waittill( "level5_map" );

				// change the map to level5
				// setminimap( "compass_map_montenegrotrain", 200, -2304, -448, -7104 );
				// WW 07-02-08
				// map has changed, new call for switching cars
				setSavedDvar( "sf_compassmaplevel",  "level5" );

}
///////////////////////////////////////////////////////////////////////////
// 08-11-08 WWilliams
// change the map to level6
train_level6_map()
{
				// endon

				// objects to define for this function
				trig = getent( "trig_send_shotgun_rusher", "targetname" );

				// wait for the trigger
				trig waittill( "trigger" );

				// change the map to level6
				setminimap( "compass_map_montenegrotrain", 200, 2496, -448, -2304 );
				// WW 07-02-08
				// map has changed, new call for switching cars
				setSavedDvar( "sf_compassmaplevel",  "level6" );

}
///////////////////////////////////////////////////////////////////////////
// 08-11-08 WWilliams
// change the map to level7
train_level7_map()
{
				// endon

				// objects to define for this function
				trig = getent( "map_car9", "targetname" );

				// wait for the trigger
				trig waittill( "trigger" );

				// change the map to level7
				setminimap( "compass_map_montenegrotrain", 200, 7296, -448, 2496 );
				// WW 07-02-08
				// map has changed, new call for switching cars
				setSavedDvar( "sf_compassmaplevel",  "level7" );

}
//////////////////////////////////////////////////////////////////////////////////////////
// Setup hidden objects, phones.
//////////////////////////////////////////////////////////////////////////////////////////
// 04-16-08
// wwilliams
// commenting this out so the phones work with the new barnes system
/*setup_hidden_objects()
{
maps\_playerawareness::init();

entaTemp = GetEntArray( "ent_hidden_laptops", "targetname" );
if( IsDefined( entaTemp[0] ) )
{
maps\_playerawareness::setupArrayUseOnly(	"ent_hidden_laptops", 
::train_laptop_count, //use event
"Pick up cell phone", //hint string
0, //use time
"Retrieving Phone", //use text
true, //single use
true, //require lookat
undefined, //filter to call
undefined, //material
true, //glow
true ); //shine
}			
}
// 04-16-08
// wwilliams
// commenting this out so the phones work with the new barnes system
train_laptop_count(strcObject)
{
if(isdefined(strcObject.primaryEntity))
{
strcObject.primaryEntity hide();
}
level.laptops_found++;
iprintlnbold( "Found " + level.laptops_found + " of 3 phones." );

wait( 1.0 );

if( level.laptops_found == 3 )
{
iprintlnbold( "Congratulations!" );
wait( 2.0 );
iprintlnbold( "You have found all the hidden phones." );	
}
}*/
//////////////////////////////////////////////////////////////////////////////////////////
// Automatic doors (glass).
//////////////////////////////////////////////////////////////////////////////////////////
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
												new_pos = door.origin + (right * move_dist);// right
								}
								else
								{
												new_pos = door.origin + ((-1 * right) * move_dist);// left
								}

								while( true )
								{
												trig waittill( "trigger", ent );

												door MoveTo( new_pos, 0.5 );

												//Steve G
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

												//Steve G
												door playsound("train_auto_door_close");

												if (door.spawnflags & 1)
												{
																door DisconnectPaths();
												}
								}
				}	
}
//////////////////////////////////////////////////////////////////////////////////////////
// Automatic doors (double).
//////////////////////////////////////////////////////////////////////////////////////////
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
								new_pos = door.origin + (right * move_dist);// right
				}
				else
				{
								new_pos = door.origin + ((-1 * right) * move_dist);// left
				}

				////////////////////////////////////////////////////////////////////////////////////
				// 06-02-08
				// wwilliams
				// need to make these nodes connect at the beginning of the map
				// that way ai will path through them properly
				door ConnectPaths();
				////////////////////////////////////////////////////////////////////////////////////

				while( true )
				{
								trig waittill( "trigger", ent );

								door MoveTo( new_pos, 0.5 );

								//Steve G
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

								//Steve G
								door playsound ("train_double_door_close");

								if (door.spawnflags & 1)
								{
												door DisconnectPaths();
								}
				}
}
//////////////////////////////////////////////////////////////////////////////////////////
// Automatic doors (service rooms).
//////////////////////////////////////////////////////////////////////////////////////////
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
												new_pos = door.origin + (right * move_dist);// right
								}
								else
								{
												new_pos = door.origin + ((-1 * right) * move_dist);// left
								}

								while( true )
								{
												trig waittill( "trigger", ent );

												door MoveTo( new_pos, 0.5 );

												//Steve G
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

												//Steve G
												door playsound("train_auto_door_close");

												if (door.spawnflags & 1)
												{
																door DisconnectPaths();
												}
								}
				}	
}


//////////////////////////////////////////////////////////////////////////////////////////
//  Freight Train.
//////////////////////////////////////////////////////////////////////////////////////////
setup_freight_train()
{
		thread freight_train_mantles();

				level.freight_train = [];
				freight = GetEnt( "freight_engine", "targetname" );
				//////////////////////////////////////////////////////////////////////////
				// 05-10-08
				// wwilliams
				// removing the old door define and adding a new define for the doors that swing open
				level.freight_door1_right = GetEnt( "freight_door_shootopen_right", "script_noteworthy" );
				level.freight_door1_left = GetEnt( "freight_door_shootopen_left", "script_noteworthy" );
				//////////////////////////////////////////////////////////////////////////
				level.freight_door2 = GetEnt( "freight9_door", "script_noteworthy" );
				//////////////////////////////////////////////////////////////////////////
				// 05-15-08
				// wwilliams
				// removing the define for this door, it no longer exsists in the level
				// level.freight_door3 = GetEnt( "freight6_door", "targetname" );
				//////////////////////////////////////////////////////////////////////////
				level.freight_playerpos = GetEnt( "freight_playerpos", "targetname" );
				//////////////////////////////////////////////////////////////////////////
				// 05-15-08
				// wwilliams
				// objects to be defined for the function
				// script_model
				// 05-15-08
				// making this a level ent array so I can call it later with the other freight train stuff
				level.enta_freight_smodels = getentarray( "freight_train_models", "targetname" );
				// undefined
				temp_ent = undefined;
				// mantle org
				mantle_org = undefined;
				// light org
				temp_org = undefined;
				// trigger array
				enta_script_trigs_on_freight = getentarray( "trig_script_freight", "script_noteworthy" );
				// script org array for enemy placement
				level.enta_freight_enemy_points = getentarray( "scr_freight_enemy", "targetname" );
				// exploders on the train
				enta_freight_exploders = GetEntArray( "freight_train_exploder", "script_noteworthy" );
				// setup movement nodes
				level.freight_train_start = GetEnt( "freight_start_node", "targetname" );
				// 05-20-08
				// wwilliams
				// this freight node is setup to allow the player to jump on the freight and allow
				// the log car to match up with the observation car
				level.freight_train_play1 = GetEnt( "freight_node1", "targetname" ); // main battle node. lines up with cars well.
				// 05-20-08
				// wwilliams
				// this freight node matches the guys throwing the bags with the open door to the passenger train
				level.freight_train_play2 = GetEnt( "freight_node2", "targetname" ); // node to exit freight train.
				// 05-20-08
				// wwilliams
				// this freight node matches the jump back to the passenger train to the freight train
				level.freight_train_play3 = GetEnt( "freight_node3", "targetname" ); // node to transition to freight train.
				level.freight_train_end = GetEnt( "freight_end_node", "targetname" );	
				// level.freight_lights = getentarray( "freight_train_light", "targetname" ); // lights that must be linked to the freight
				level.current_train_pos = undefined;	

				i = 0;
				while ( IsDefined( freight ) )
				{
								level.freight_train[i] = freight;

								//hide until time to play.
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

				//// Linking pieces so all move together
				for ( i = 1; i < level.freight_train.size; i++ )
				{
								level.freight_train[i] linkto(level.freight_train[i-1]);
				}
				level.freight_playerpos linkto(level.freight_train[0]);

				//////////////////////////////////////////////////////////////////////////
				// 05-10-08
				// wwilliams
				// adding the new doors to be linked
				// right door
				// 05-19-08
				// shouldn't need to link these, it is done inside of setup_freight_train
				// level.freight_door1_right linkto(level.freight_train[8]);
				level.freight_door1_right hide();
				// left door
				// 05-19-08
				// shouldn't need to link these, it is done inside of setup_freight_train
				// level.freight_door1_left linkto(level.freight_train[8]);
				level.freight_door1_left hide();
				//////////////////////////////////////////////////////////////////////////
				// 05-19-08
				// shouldn't need to link these, it is done inside of setup_freight_train
				// level.freight_door2 linkto(level.freight_train[9]);
				level.freight_door2 hide();
				//////////////////////////////////////////////////////////////////////////
				// -05-15-08
				// wwilliams
				// no longer using this door, it no longer exsists in the map
				// level.freight_door3 linkto(level.freight_train[0]);
				// level.freight_door3 hide();
				//////////////////////////////////////////////////////////////////////////
				// 05-15-08
				// wwilliams
				// link the script triggers I have on the freight
				// for loop goes through
				for( i=0; i<enta_script_trigs_on_freight.size; i++ )
				{
								// check to see if there is a target2, this is used by the breadcrumb
								// triggers
								if( isdefined( enta_script_trigs_on_freight[i].target2 ) )
								{
												// if the target is defined
												// enable link to
												enta_script_trigs_on_freight[i] enablelinkto();

												// link it
												enta_script_trigs_on_freight[i] linkto( getent( enta_script_trigs_on_freight[i].target2, "targetname" ) );

												// go to the next spot in the array
												continue;
								}

								// make sure the trig has a target, this covers the normal triggers used
								// for scripting
								if( isdefined( enta_script_trigs_on_freight[i].target ) )
								{
												// if the target is defined
												// enable link to
												enta_script_trigs_on_freight[i] enablelinkto();

												// link it
												enta_script_trigs_on_freight[i] linkto( getent( enta_script_trigs_on_freight[i].target, "targetname" ) );

												// go to the next spot in the array
												continue;
								}
								else
								{
												// debug text
												iprintlnbold( "trig at " + enta_script_trigs_on_freight[i].origin + " missing target!" );
								}
				}
				///////////////////////////////////////////////////////////////////////
				// 08-05-08 WWilliams
				// lights that must link to the freight train
				// make sure the lights are defined
				//assertex( isdefined( level.freight_lights ), "level.freight_lights not defined" );

				//// loop through the lights are link them
				//for( i=0; i<level.freight_lights.size; i++ )
				//{
				//				// 07-26- 08 WWilliams
				//				// if it is a light it will use target2
				//				if( isdefined( level.freight_lights[i].target2 ) )
				//				{
				//								// iprintlnbold( level.enta_freight_smodels[i].classname + " should be a light" );

				//								// this is a light and needs to be linked by target2
				//								// script_org to link light to
				//								temp_org = getent( level.freight_lights[i].target2, "targetname" );

				//								// wait to avoid a script error
				//								wait( 0.05 );

				//								// make sure the org is defined
				//								assertex( isdefined( temp_org ), "a light on the freight does not have a script origin" );
				//								// make sure the org has a target
				//								assertex( isdefined( temp_org.target ), "script_origin missing a target!" );

				//								// define the car the org targets
				//								temp_ent = getent( temp_org.target, "targetname" );

				//								// link the model to the target
				//								level.freight_lights[i] linklighttoentity( temp_org );

				//								// need to move the light to the zero point of ent I'm linking it to
				//								level.freight_lights[i].origin = ( 0, 0, 0 );

				//								// frame wait just in case
				//								wait( 0.05 );

				//								// link the temp_org to the temp_ent
				//								temp_org linkto( temp_ent );

				//								// undefine temp_ent and temp_org
				//								temp_org = undefined;
				//								temp_ent = undefined;

				//								// frame wait
				//								wait( 0.05 );
				//				}
				//				else
				//				{
				//								// debug text
				//								iprintlnbold( "freight light is missing target2!" );
				//				}
				//}

				//////////////////////////////////////////////////////////////////////////
				// 05-15-08
				// wwilliams
				// moving this into don's function
				// check that all the models have a target
				for( i=0; i<level.enta_freight_smodels.size; i++ )
				{
								// check to see that each model has a target
								assertex( isdefined( level.enta_freight_smodels[i].target ),"" + level.enta_freight_smodels[i].origin + " missing target" );
				}

				// debug text
				// how many models are there?
				// iprintlnbold( enta_freight_smodels.size );

				// now go through the array and link them
				for( i=0; i<level.enta_freight_smodels.size; i++ )
				{
								// 07-26- 08 WWilliams
								// if it is a light it will use target2
								//if( isdefined( level.enta_freight_smodels[i].target2 ) )
								//{
								//				// iprintlnbold( level.enta_freight_smodels[i].classname + " should be a light" );

								//				// this is a light and needs to be linked by target2
								//				// script_org to link light to
								//				temp_org = getent( level.enta_freight_smodels[i].target2, "targetname" );

								//				// wait to avoid a script error
								//				wait( 0.05 );

								//				// make sure the org is defined
								//				assertex( isdefined( temp_org ), "a light on the freight does not have a script origin" );
								//				// make sure the org has a target
								//				assertex( isdefined( temp_org.target ), "script_origin missing a target!" );
								//				
								//				// define the car the org targets
								//				temp_ent = getent( temp_org.target, "targetname" );

								//				// link the model to the target
								//				level.enta_freight_smodels[i] linklighttoentity( temp_org );

								//				// need to move the light to the zero point of ent I'm linking it to
								//				level.enta_freight_smodels[i].origin = ( 0, 0, 0 );

								//				// link the temp_org to the temp_ent
								//				temp_org linkto( temp_ent );

								//				// undefine temp_ent and temp_org
								//				temp_org = undefined;
								//				temp_ent = undefined;

								//				// frame wait
								//				wait( 0.05 );

								//}
								if( isdefined( level.enta_freight_smodels[i].target ) )
								{
												// special case for the mantle at the stock car
												// check to see what the target is, if it is the origin...
												if( level.enta_freight_smodels[i].target == "freight_mantle_origin" )
												{
																// define the org 
																mantle_org = getent( level.enta_freight_smodels[i].target, "targetname" );

																// link the mantle brush to this org
																level.enta_freight_smodels[i] linkto( mantle_org );

																// check to make sure the mantle org has a target
																if( isdefined( mantle_org.target ) )
																{
																				// define the org's target
																				temp_ent = getent( mantle_org.target, "targetname" );

																				// link the org to the car
																				mantle_org linkto( temp_ent );

																				// undefine temp_ent for the next loop
																				temp_ent = undefined;
																}
																// report if the mantle org has no target 
																else
																{
																				iprintlnbold( "mantle org has no target!" );
																}
												}
												else
												{
																// quick define the target
																temp_ent = getent( level.enta_freight_smodels[i].target, "targetname" );

																// make sure the temp_ent is defined
																if( isdefined( temp_ent ) )
																{
																				// link the model to the target
																				level.enta_freight_smodels[i] linkto( temp_ent );

																				// hide the model
																				level.enta_freight_smodels[i] hide();

																				// undefine temp_ent for next rotation
																				temp_ent = undefined;
																}
												}
								}
				}
				//////////////////////////////////////////////////////////////////////////
				// debug text, finished with linking
				// iprintlnbold( "done linking models to freight" );

				//////////////////////////////////////////////////////////////////////////
				// 05-30-08
				// wwilliams
				// link all the script orgs for enemies on the train
				// check to make sure they are defined
				if( isdefined( level.enta_freight_enemy_points ) )
				{
								// 05-30-08
								// wwilliams
								// go through each one and check
								for( i=0; i<level.enta_freight_enemy_points.size; i++ )
								{
												// check to make sure they have a target and a script_noteworthy
												assertex( isdefined( level.enta_freight_enemy_points[i].target ), level.enta_freight_enemy_points[i].origin + " missing target!" );
												// script_noteworthy
												assertex( isdefined( level.enta_freight_enemy_points[i].script_noteworthy ), level.enta_freight_enemy_points[i].origin + " missing script_noteworthy!" );
								}
				}
				else
				{
								// debug text
								iprintlnbold( "level.enta_freight_enemy_points not defined!" );
				}

				// all spots in array have info needed, link them
				if( isdefined( level.enta_freight_enemy_points ) )
				{
								// for loop to go through each scr org
								for( i=0; i<level.enta_freight_enemy_points.size; i++ )
								{
												// define the target
												temp_ent = getent( level.enta_freight_enemy_points[i].target, "targetname" );

												// link each org to its target
												level.enta_freight_enemy_points[i] linkto( temp_ent );

												// undefine
												temp_ent = undefined;
								}

								// debug text
								// iprintlnbold( "done with linking level.enta_freight_enemy_points" );
				}

				// link all the exploders to the freight train
				for( i=0; i<enta_freight_exploders.size; i++ )
				{
								// check that it has a target
								AssertEx( IsDefined( enta_freight_exploders[i].target ), enta_freight_exploders[i].origin + "needs target" );
								
								// get the target
								temp_ent = GetEnt( enta_freight_exploders[i].target, "targetname" );

								// link to the target
								enta_freight_exploders[i] LinkTo( temp_ent );

								// wait a frame
								wait( 0.05 );

								// undefine ent_temp
								ent_temp = undefined;
				}


				thread freight_train_begin();
				// isn't working when run at teh beginning of the level
				// try a wait
				wait( 2.0 );
				///////////////////////////////////////////////////////////////////////
				// 07-22-08 WWilliams
				// function hides certain cars to help with rendering while on the freight
				level thread freight_train_hide_init();
}	
freight_train_mantles()
{
	train_mantles = GetEntArray("train_ledge_mantel_brush", "targetname");
	train_car = GetEnt("freight4", "targetname");
	
	for(i=0; i<train_mantles.size; i++)
	{
		train_mantles[i] linkto(train_car);
		org = getent(train_mantles[i].target, "targetname");
		org linkto(train_car);
	}	
}	
freight_train_begin()
{
				//////////////////////////////////////////////////////////////////////////
				// 05-20-08
				// defining objects needed for this function
				// trigs
				start_trig = GetEnt("freight_start_trig", "targetname");

				//////////////////////////////////////////////////////////////////////////
				// wwilliams
				// 05-08-08
				// moved this trigger higher on the y axis to make the train come in later
				// keeps players from cheesing the train arrival and forces them to walk at least
				// half of the car roof
				//////////////////////////////////////////////////////////////////////////
				if ( IsDefined( start_trig ) )
				{
								start_trig waittill("trigger");
								level.freight_train_active = true;
								//////////////////////////////////////////////////////////////////////////
								// 05-10-08
								// wwilliams
								// new flag mimics this level var
								if( !flag( "freight_train_active" ) )
								{
												level flag_set( "freight_train_active" );

												// debug text
												// iprintlnbold( "set_freight_train_active" );
								}
								//////////////////////////////////////////////////////////////////////////
								// WW 07-01-08
								// thread off a diadlogue function for tanner to react to teh train about
								// to show up
								level thread train_tanner_talks_freight();


								level.on_freight_train = false;
								//////////////////////////////////////////////////////////////////////////
								// 05-10-08
								// wwilliams
								// new flag mimics this level var
								if( flag( "on_freight_train" ) )
								{
												level flag_clear( "on_freight_train" );

												// debug text
												// iprintlnbold( "cleared_on_freight_train" );
								}
								//////////////////////////////////////////////////////////////////////////
				}
				else
				{
								iPrintLnBold( "couldn't find freight train trigger!" );
								return;
				}

				//show the train.
				for ( i = 0; i < level.freight_train.size; i++ )
				{
								level.freight_train[i] show();
				}	
				//////////////////////////////////////////////////////////////////////////
				// 05-10-08
				// wwilliams
				// adding show for the new doors the AI shoot open
				// right door
				level.freight_door1_right show();
				// left door
				level.freight_door1_left show();
				//level.freight_door1 show();
				//////////////////////////////////////////////////////////////////////////
				level.freight_door2 show();
				//////////////////////////////////////////////////////////////////////////
				// 05-15-08
				// wwilliams
				// no longer using this door, it no longer exists in the map
				// level.freight_door3 show();
				//////////////////////////////////////////////////////////////////////////
				// 05-15-08
				// wwilliams
				// show all the other script models
				// for loop goes through them
				for( i=0;i<level.enta_freight_smodels.size; i++ )
				{
								// show the model
								level.enta_freight_smodels[i] show();
				}
				//////////////////////////////////////////////////////////////////////////
				// 05-15-08
				// wwilliams
				// start the fx animations
				level notify( "train_anim_start" );
				//////////////////////////////////////////////////////////////////////////

				// move train into position.
				movetime = 12;
				accel = 0;
				decel = 4;

				level.freight_train[0] moveto( level.freight_train_play1.origin, movetime, accel, decel );
				level.freight_train[0] waittill( "movedone" );
				level.current_train_pos = level.freight_train_play1;

				setminimap( "compass_map_montenegrotrain", 200, -5408, -448, -10208 );
				// WW 07-02-08
				// map has changed, new call for switching cars
				setSavedDvar( "sf_compassmaplevel",  "level2" );

				//// spawn freight train ai.
				thread spawn_train_enemies();
				thread special_freight_nme();

				// thread random_train_movement();
				thread stop_freight_train();

				//////////////////////////////////////////////////////////////////////////
				// 05-15-08
				// wwilliams
				// thread off the uncoupling function
				level thread train_first_uncouple();
				// 05-15-08
				// second uncouple call will go here
				level thread train_second_uncouple();
				//////////////////////////////////////////////////////////////////////////

				// change the var/flags back to allow random_train_movement to work
				// change the flags to stop the train from moving
				// change the var/flag
				level.freight_train_active = true;
				level flag_set( "freight_train_active" );

				//start the random movement on the new node
				// level thread random_train_movement();

				//////////////////////////////////////////////////////////////////////////
				// 05-20-08
				// wwilliams
				// need to change the freight node the freight train is on
				// might need to stop the random movement here

				// make sure the node is defined
				/* if( isdefined( level.freight_train_play2 ) )
				{
								// wait for first adjustment notify
								// level flag_wait( "freight_to_node2" );

								// stop the random movement
								// level notify( "stop_random_freight" );

								// stop the train
								// level.freight_train[0] notify( "movedone" );

								// frame wait
								// wait( 0.05 );

								// now move the train to the right position
								// use the same values that moved the train into place,
								// might need to adjust these
								// move freight into place
								// level.freight_train[0] moveto( level.freight_train_play2.origin, movetime, accel, decel );

								// wait for move to complete
								// level.freight_train[0] waittill( "movedone" );

								// reset the current position to the new node
								// level.current_train_pos = level.freight_train_play2;

								// change the var/flags back to allow random_train_movement to work
								// change the flags to stop the train from moving
								// change the var/flag
								// level.freight_train_active = true;
								// level flag_set( "freight_train_active" );

								// start the random movement on the new node
								//level thread random_train_movement();
				}
				else
				{
								// debug text
								// iprintlnbold( "level.freight_train_play2 not defined!" );

								// end function
								// return;
				} */


				// make sure the third freight nod is valid
				if( isdefined( level.freight_train_play3 ) )
				{
								// now wait for the second adjust notify
								level flag_wait( "freight_to_node3" );

								// stop the random movement function
								// level notify( "stop_random_freight" );

								// stop movement on the main train
								//level.freight_train[0] notify( "movedone" );

								// grab the sbrush collision for the freight
								sbrush_freight_collision = getent( "freight_train_pathing_clips", "targetname" );

								// frame wait
								wait( 0.05 );

								// delete the sbrush
								sbrush_freight_collision delete();

								// frame wait
								wait( 0.05 );

								// move freight to spot three
								level.freight_train[0] moveto( level.freight_train_play3.origin, 0.75, 0.0, 0.0 );

								// wait for the move to complete
								level.freight_train[0] waittill( "movedone" );

								// notify the level it is done
								level notify( "train_at_node_3" );

								// reset the current position to the new node
								level.current_train_pos = level.freight_train_play3;

								// change the var/flags back to allow random_train_movement to work
								// change the flags to stop the train from moving
								// change the var/flag
								level.freight_train_active = true;
								level flag_set( "freight_train_active" );

								// start the random movement on the new node
								// level thread random_train_movement();
				}
				else
				{
								// debug text
								iprintlnbold( "level.freight_train_play3 not defined!" );

								// end function
								return;
				}
}
///////////////////////////////////////////////////////////////////////////
// 07-22-08 WWilliams
// controls hiding and showing the freight cars after the player has
// jumped to the freight
// runs on level
freight_train_hide_init()
{
				// endon
				// single shot function that should not be stopped

				// obejcts to be defined for this function
				// already a level.var for the cars
				//level.freight_train[0]
				//level.freight_train[1]
				//level.freight_train[2]
				//level.freight_train[3]
				//level.freight_train[4]
				// notifies
				str_hide = "freightcar_hide";
				str_first_show = "freight_show_1";
				str_second_show = "freight_show_2";
				// trigs
				trig_first_show = getent( "trig_first_show", "targetname" );
				trig_second_show = getent( "trig_first_uncouple_success", "targetname" );

				// double check defines
				//assertex( isstring( str_hide ), "str_hide not string" );
				//assertex( isstring( str_first_show ), "str_first_show not string" );
				//assertex( isstring( str_second_show ), "str_second_show not string" );
				//assertex( isdefined( trig_first_show ), "trig_first_show not defined" );
				//assertex( isdefined( trig_second_show ), "trig_second_show not defined" );

				// thread the function on them
				// these are second show
				level.freight_train[0] thread freight_hide_n_show( str_hide, str_second_show );
				level.freight_train[1] thread freight_hide_n_show( str_hide, str_second_show );
				// these are first show
				level.freight_train[2] thread freight_hide_n_show( str_hide, str_first_show );
				level.freight_train[3] thread freight_hide_n_show( str_hide, str_first_show );
				level.freight_train[4] thread freight_hide_n_show( str_hide, str_first_show );

				// wait for the player to get on the freight
				level flag_wait( "on_freight_train" );

				// level notify for hide
				level notify( str_hide );

				// wait for the trigger to be hit
				trig_first_show waittill( "trigger" );

				// notify the first set to show
				level notify( str_first_show );

				// 07-29-08 WWilliams
				// function turns off teh cam collision while on the ladder
				level thread freight_ladder_cam();

				// wait for the second trigger to be hit
				trig_second_show waittill( "trigger" );

				// notify the second set to show
				level notify( str_second_show );

				// 07-29-08 WWilliams
				// fucntion turns off cam collision for the ledge
				level thread freight_ledge_cam();
				
}
///////////////////////////////////////////////////////////////////////////
// 07-22-08 WWilliams
// hides the freight train car as well as all the script models targeting it
// runs on the freight car/self
freight_hide_n_show( str_hide_notify, str_shownotify )
{
				// endon

				// objects to be defined for the function
				// ent array
				enta_quick = getentarray( self.targetname, "target" );
				enta_car_s_models = [];

				// double check defines
				//assertex( isdefined( enta_quick ), "enta_quick not defined" );

				// for loop checks that each spot has a targetname
				for( i=0; i<enta_quick.size; i++ )
				{
								// check that the spot has a targetname
								//assertex( isdefined( enta_quick[i].targetname ), "missing targetname on one spot in the array" );
				}
				
				// go through the array and remove anything that doesn't have the right classname
				for( i=0; i<enta_quick.size; i++ )
				{
								// check the targetname of the array spot
								if( enta_quick[i].targetname != "freight_train_models" )
								{
												// go to the next array spot
												continue;
								}
								else
								{
												// add the array spot to the s_model
												// newArray[newArray.size] = array[i];
												enta_car_s_models[enta_car_s_models.size] = enta_quick[i];
								}
				}
				
				// wait for the hide notify
				level waittill( str_hide_notify );

				// for loop goes through the smodel array
				for( i=0; i<enta_car_s_models.size; i++ )
				{
								// hide the model
								enta_car_s_models[i] hide();
				}

				// hide self
				self hide();

				// wait for the show notify
				level waittill( str_shownotify );

				// for loop goes through the smodel array
				for( i=0; i<enta_car_s_models.size; i++ )
				{
								// hide the model
								enta_car_s_models[i] show();
				}

				// hide self
				self show();
}
///////////////////////////////////////////////////////////////////////////
// 07-29-08 WWilliams
// function makes sure the camera has no collision while bond uses the ladder
freight_ladder_cam()
{
				// endon

				// objects to define for this function
				trig_end_cam = getent( "trig_move_from_train2", "targetname" );
				// undefined
				notice = undefined;

				// double check defines
				//assertex( isdefined( trig_end_cam ), "trig_end_cam not defined" );

				// while loop as long as the player doesn't drop into the container
				while( !level.player istouching( trig_end_cam ) )
				{
								// wait for the player to start the ladder climb
								level.player waittill( "ladder", notice );

								if( notice == "begin" )
								{
												// turn off cam collision
												level.player customcamera_checkcollisions( 0 );
								}
								else if( notice == "end" )
								{
												// turn back on the collision
												level.player customcamera_checkcollisions( 1 );
								}
				}
}
///////////////////////////////////////////////////////////////////////////
// 07-29-08 WWilliams
// turn off camera collision for the ledge crawl
freight_ledge_cam()
{
				// endon


				// objects to define for this function
				trig_end_ledge = getent( "trig_end_tosser_dialogue", "targetname" );
				// undefined
				notice = undefined;

				// double check defines
				assertex( isdefined( trig_end_ledge ), "trig_end_ledge not defined" );

				// while the player is not touching the trigger
				while( !level.player istouching( trig_end_ledge ) )
				{
								// wait for the player to start the ledge
								level.player waittill( "ledge", notice );

								if( notice == "begin" )
								{
												// turn off cam collision
												level.player customcamera_checkcollisions( 0 );
								}
								else if( notice == "end" )
								{
												// turn the cam collisions back on
												level.player customcamera_checkcollisions( 1 );
												
												// DCS: trigger third set of fx entities.
												level notify("start_fxgroup_4");
												level notify("delete_fxgroup_3");
										
								}
				}
}
//////////////////////////////////////////////////////////////////////////////////////////
//  Enemy on Freight Train.
//////////////////////////////////////////////////////////////////////////////////////////
spawn_train_enemies()
{

				//////////////////////////////////////////////////////////////////////////
				// 05-30-08
				// wwilliams
				// changing how guys are populated on the freight
				// now with the two extra cars it's harder to just use spawners
				// set in the main.map, linked mulitple scr orgs to the freight
				// and will move guys to the points
				// the grouping is now in three waves
				//////////////////////////////////////////////////////////////////////////
				// endon
				level.player endon( "death" );

				// objects to be defined for the function
				// trigs
				trig_wave_1 = getent( "trig_spwn_bottom_crossfire", "targetname" );
				trig_wave_2 = getent( "trig_ready_show_train", "targetname" );
				trig_wave_3 = getent( "trig_first_uncouple_success", "targetname" );
				// spawner
				spawner = getent( "spwn_freight_train", "targetname" );
				// scr org arrays
				// enta_boxcar_surprise = getentarray( "freight_boxcar_surprise", "script_noteworthy" );
				enta_freight_wave_1 = getentarray( "freight_wave_1", "script_noteworthy" );
				enta_freight_wave_2 = getentarray( "freight_wave_2", "script_noteworthy" );
				enta_freight_wave_3 = getentarray( "freight_wave_3", "script_noteworthy" );
				// undefined
				ent_move_org = undefined;
				ent_guy = undefined;

				// make sure everything is defined
				//assertex( isdefined( trig_wave_1 ), "trig_wave_1 fail" );
				//assertex( isdefined( trig_wave_2 ), "trig_wave_2 fail" );
				//assertex( isdefined( trig_wave_3 ), "trig_wave_3 fail" );
				//assertex( isdefined( spawner ), "spawner fail" );
				//assertex( isdefined( enta_freight_wave_1 ), "enta_freight_wave_1 fail" );
				//assertex( isdefined( enta_freight_wave_2 ), "enta_freight_wave_2 fail" );
				//assertex( isdefined( enta_freight_wave_3 ), "enta_freight_wave_3 fail" );

				// wait for the trigger to hit
				trig_wave_1 waittill( "trigger" );

				// spawn out the script origin
				ent_move_org = spawn( "script_origin", spawner.origin + ( 0, 0, -10 ) );

				///// wave one setup ////////////////////////////////////////////////////////////////////////////////////////////////

				// set the count of the spawner for wave 1
				spawner.count = enta_freight_wave_1.size + 1;

				// spawn out guys for wave 1
				// for each org spawn out a guy
				for( i=0; i<enta_freight_wave_1.size; i++ )
				{
								// spawn out a guy
								ent_guy = spawner stalingradspawn( "f_enemy_wave_1" );
								// make sure the guy spawns out
								if( spawn_failed( ent_guy ) )
								{
												// debug text
												iprintlnbold( "ent_guy, wave_1 on " + i + " loop fail" );

												// wait
												wait( 5.0 );

												// end the function
												return;
								}
								else
								{
												// turn off his sense
												ent_guy setenablesense( false );

												// hide the guy
												ent_guy hide();

												// now we got to move him
												// move the ent_move_org to the guy
												ent_move_org.origin = ent_guy.origin;

												// link the move_org and _guy
												ent_guy linkto( ent_move_org );

												// now move the move_org to the right spot
												ent_move_org moveto( enta_freight_wave_1[i].origin, 0.5, 0.0, 0.0 );

												// wait for the move to finish
												ent_move_org waittill( "movedone" );

												// rotate the org into the right position
												ent_move_org rotateto( enta_freight_wave_1[i].angles, 0.5, 0.0, 0.0 );

												// wait for rotate to finish
												ent_move_org waittill( "rotatedone" );

												// link the guy to the org on the freight
												// unlink him from the move_org
												ent_guy unlink();

												// quick wait
												wait( 0.05 );

												// link the guy to the right node
												ent_guy linkto( enta_freight_wave_1[i] );

												// set the guy back up
												ent_guy show();
												ent_guy setenablesense( true );
												ent_guy setcombatrole( "support" );
												ent_guy setengagerule( "tgtSight" );
												ent_guy addengagerule( "tgtPerceive" );
												ent_guy addengagerule( "Damaged" );
												ent_guy addengagerule( "Attacked" );
												ent_guy setalertstatemin( "alert_red" );

												// function makes them shoot at the right time
												ent_guy thread train_notify_for_sense( "wave_1_fire" );

								}

				}
				///// wave one end ////////////////////////////////////////////////////////////////////////////////////////////////
				///// wave two start ////////////////////////////////////////////////////////////////////////////////////////////////
				// thread off the setup for wave_2
				level thread train_wave_2_init();
				///// wave two end ////////////////////////////////////////////////////////////////////////////////////////////////
				///// wave three start ////////////////////////////////////////////////////////////////////////////////////////////////
				// set the count of the spawner
				spawner.count = enta_freight_wave_3.size + 1;

				// wait for the trigger to hit
				trig_wave_3 waittill( "trigger" );

				// set up the guys who throw the bags
				level thread train_bag_tossers();

				// 07-21-08 WWilliams
				// new wave3 setup for the stock car and jump car
				level thread train_wave3_init();
				///// wave three end ////////////////////////////////////////////////////////////////////////////////////////////////

				// clean up
				// delete the ent_move_org
				// unlink first, in case
				ent_move_org unlink();
				// quick wait
				wait( 0.05 );
				// delete
				ent_move_org delete();

				// clean up spawner
				spawner delete();

				// ent guy undefined
				ent_guy = undefined;

}
///////////////////////////////////////////////////////////////////////////
// 06-15-08 WWilliams
// function waits for a level notify then starts perfect sense for awhile
train_notify_for_sense( str_notify )
{
				// endon
				level.player endon( "death" );
				self endon( "death" );

				// make sure what was passed in is valid
				//AssertEx( isdefined( str_notify ), "notify is not defined!" );
				//AssertEx( isstring( str_notify ), "notify is not a string" );

				// give self a backup response if damaged
				self thread dmg_turn_sense_on();

				// wait for the notify
				level waittill( str_notify );

				// notify turns off other function
				self notify( "sense_on" );

				// give self perfect sense for a few seconds
				self thread turn_on_sense( 15 );	

				// shoot at the player
				self cmdshootatentity( level.player, true, 6, 0.8 );
}
///////////////////////////////////////////////////////////////////////////
// 07-19-08 WWilliams
// setups the guys to run around first uncouple car
// runs on level
train_wave_2_init()
{
				// endon

				// objects to define for this function
				// spawner array
				enta_wave2_spawner = getentarray( "spwn_first_uncouple", "targetname" );
				// node
				nod_wave2_tether = getnode( "first_uncouple_tether", "targetname" );
				// train jump nodes
				nod_train_jump_0 = getnode( "train_jumper_dest_a", "targetname" );
				// nod_train_jump_1 = getnode( "train_jumper_dest_b", "targetname" );
				// int
				// int_train_jump = 0; 


				// double check defines
				assertex( isdefined( enta_wave2_spawner ), "enta_wave2_spawner not defined" );
				// make sure each spawner has a script string
				for( i=0; i<enta_wave2_spawner.size; i++ )
				{
								// check to make sure each spawner has a script string
								assertex( isdefined( enta_wave2_spawner[i].script_string ), "wave_2 spawner missing string" );
				}

				// go through the array and send off the spawner to the right function
				for( i=0; i<enta_wave2_spawner.size; i++ )
				{
								// check the string
								if( enta_wave2_spawner[i].script_string == "on_car" )
								{
												// send this spawner to the on_car function
												level thread train_wave2_oncar( enta_wave2_spawner[i], nod_wave2_tether, "wave_2_start" );
								}
								//else if( enta_wave2_spawner[i].script_string == "train_jumper" )
								//{
								//				// thread spawner into the function
								//				level thread train_wave2_jump_across( enta_wave2_spawner[i], nod_wave2_tether, nod_train_jump_0, "wave_2_start" );
								//}
				}
}
///////////////////////////////////////////////////////////////////////////
// 07-19-08 WWilliams
// function waits for a notify
// spawns out a guy
// sets the guy up
// and tethers the guy
// cleans the spawner once done
// runs on level
train_wave2_oncar( ent_spawner, nod_tether, str_notify )
{
				// double check what was passed in
				//assertex( isdefined( ent_spawner ), "ent_spawner not defined" );
				//assertex( isdefined( ent_spawner.target ), "ent_spawner missing target" );
				//assertex( isdefined( nod_tether ), "nod_tether not defined" );
				//assertex( isdefined( str_notify ), "str_notify not defined" );
				//assertex( isstring( str_notify ), "str_notify not string" );

				// make sure the spawner has a count
				if( !isdefined( ent_spawner ) || ent_spawner.count <= 0 )
				{
								// give the spawner the count
								ent_spawner.count = 1;
				}

				// define the target of the spawner
				nod_goal = GetNode( ent_spawner.target, "targetname" );

				// wait for the notify
				level waittill( str_notify );

				// spawn out the guy
				ent_temp = ent_spawner stalingradspawn( "f_enemy_wave_2" );
				// make sure the guy spawned out
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								// debug text
								iprintlnbold( "problem spawning from " + ent_spawner.origin );

								// wait
								wait( 1.0 );

								// end func
								return;
				}
				else
				{
								// set the guy up
								ent_temp thread turn_on_sense( 5 );
								ent_temp setcombatrole( "guardian" );
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );
								ent_temp setalertstatemin( "alert_red" );

								// send him to his goal
								ent_temp setgoalnode( nod_goal );

								// set up the tether
								ent_temp thread train_reset_speed_activate_tether( nod_tether, 325, 900, 285 );
				}

				// wait
				wait( 2.0 );

				// clean up
				ent_spawner delete();

}
///////////////////////////////////////////////////////////////////////////
// 07-19-08 WWilliams
// function controls the guy who jumps across from the passenger train
// runs on level
train_wave2_jump_across( ent_spawner, nod_tether, dest_node, str_notify )
{
				// double check defines
				//assertex( isdefined( ent_spawner ), "ent_spawner not defined" );
				//assertex( isdefined( nod_tether ), "nod_tether not defined" );
				//assertex( isdefined( dest_node ), "dest_node not defined" );
				//assertex( isdefined( str_notify ), "str_notify not defined" );
				//assertex( isstring( str_notify ), "str_notify not string" );

				// make sure the spawner has a count
				if( !isdefined( ent_spawner ) || ent_spawner.count <= 0 )
				{
								// give the spawner the count
								ent_spawner.count = 1;
				}

				// wait for the notify
				level waittill( str_notify );

				// spawn out the guy
				ent_temp = ent_spawner stalingradspawn( "f_enemy_wave_2" );
				// make sure the guy spawned out
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								// debug text
								iprintlnbold( "problem spawning from " + ent_spawner.origin );

								// wait
								wait( 1.0 );

								// end func
								return;
				}
				else
				{
								// set the guy up
								ent_temp thread turn_on_sense( 5 );
								ent_temp setcombatrole( "guardian" );
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );
								ent_temp setalertstatemin( "alert_red" );

								// send him to his goal
								ent_temp setgoalnode( dest_node );

								// set up the tether
								ent_temp thread train_reset_speed_activate_tether( nod_tether, 325, 900, 285 );
				}

				// wait
				wait( 2.0 );

				// clean up
				ent_spawner delete();
}
///////////////////////////////////////////////////////////////////////////
// 07-21-08 WWilliams
// set up function for wave 3 on teh freight train
// runs on level
train_wave3_init()
{
				// endon


				// objects to be defined for this function
				// spawners
				enta_wave3_spawners = getentarray( "spwn_wave3", "targetname" );
				// node
				stockcar_tether = getnode( "stock_car_tether", "targetname" );
				jumpcar_tether = getnode( "jump_back_car_tether", "targetname" );

				// double check defines
				//assertex( isdefined( enta_wave3_spawners ), "enta_wave3_spawners not defined" );
				//assertex( isdefined( stockcar_tether ), "stockcar_tether not defined" );
				//assertex( isdefined( jumpcar_tether ), "jumpcar_tether not defined" );

				// for loop to go through the spawner array
				for( i=0; i<enta_wave3_spawners.size; i++ )
				{
								// check the spawner has a string
								//assertex( isdefined( enta_wave3_spawners[i].script_string ), "wave3 spawner missing string" );

								// check the spawner string for the tether node
								if( enta_wave3_spawners[i].script_string == "tether_stockcar" )
								{
												// tether this guy to the stockcar
												level thread train_wave3_oncar( enta_wave3_spawners[i], stockcar_tether, "box_fall_start" );
								}
								else if( enta_wave3_spawners[i].script_string == "tether_jumpcar" )
								{
												// tether this guy to the jumpcar
												level thread train_wave3_oncar( enta_wave3_spawners[i], jumpcar_tether, "box_fall_start" );
								}
								else if( enta_wave3_spawners[i].script_string == "no_tether" )
								{
												// don't tether this guy, he is a rusher
												level thread train_wave3_rusher( enta_wave3_spawners[i], "box_fall_start" );
								}
								else if( enta_wave3_spawners[i].script_string == "passenger_escape" )
								{
												// special guy who runs off to the passenger train
												level thread train_wave3_passenger_jump( enta_wave3_spawners[i] );
								}
				}
}
///////////////////////////////////////////////////////////////////////////
// 07-21-08 WWilliams
// function sets up those with targets
// one spawner is a special turret that will be checked for
train_wave3_oncar( ent_spawner, tether_node, str_notify )
{
				// endon

				// double check defined
				//assertex( isdefined( ent_spawner ), "ent_spawner for wave3 fail" );
				//assertex( isdefined( ent_spawner.target ), "ent_spawner.target for wave3 fail" );
				//assertex( isdefined( tether_node ), "tether_node for wave3 fail" );
				//assertex( isdefined( str_notify ), "str_notify for wave3 fail" );

				// objects to be defined for the function
				// node
				dest_node = getnode( ent_spawner.target, "targetname" );
				// undefined
				ent_temp = undefined;

				// another check for the node script_string
				//assertex( isdefined( dest_node.script_string ), "wave3 spawner target not string!" );

				// make sure the spawner has a count
				if( !isdefined( ent_spawner.count ) ||  ent_spawner.count <= 0 )
				{
								// set the count
								ent_spawner.count = 1;
				}

				// wait for notify
				level waittill( str_notify );

				// spawn out a guy
				ent_temp = ent_spawner stalingradspawn( "f_enemy_wave_3" );
				// make sure spawn didn't fail 
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								// debug text
								iprintlnbold( "problem spawning from " + ent_spawner.origin );

								// wait
								wait( 1.0 );

								// end func
								return;
				}
				// if spawn didn't fail
				else
				{
								// set the guy up
								ent_temp thread turn_on_sense( 5 );
								ent_temp setcombatrole( "guardian" );
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );
								ent_temp setalertstatemin( "alert_red" );

								// send him to his goal
								ent_temp setgoalnode( dest_node );

								// give combatrole once he gets there
								ent_temp thread goal_n_combatrole( dest_node.script_string );

								// set up the tether
								ent_temp thread train_reset_speed_activate_tether( tether_node, 325, 1900, 285 );
				}

				// wait
				wait( 1.0 );

				// clean up the spawner
				ent_spawner delete();

}
///////////////////////////////////////////////////////////////////////////
// 07-21-08 WWilliams
// function controls the shotgun rusher for teh stock car
train_wave3_rusher( ent_spawner, str_notify )
{
				// endon


				// double check objects
				//assertex( isdefined( ent_spawner ), "ent_spawner for wave3 rusher fail" );
				//assertex( isdefined( str_notify ), "str_notify for wave3 rusher fail" );
				//assertex( isstring( str_notify ), "str_notify for wave3 rusher not string" );

				// define a trigger for more precise rushing
				trig = getent( "trig_send_shotgun_rusher", "targetname" );

				// set the count for the spawner
				if( !isdefined( ent_spawner.count ) ||  ent_spawner.count <= 0 )
				{
								// set the count
								ent_spawner.count = 1;
				}

				// wait for the notify
				level waittill( str_notify );

				// spawn out the guy
				ent_temp = ent_spawner stalingradspawn( "f_enemy_wave_3" );
				// check for spawn failed
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								// debug text
								iprintlnbold( "problem spawning from " + ent_spawner.origin );

								// wait
								wait( 1.0 );

								// end func
								return;
				}
				// if it passes
				else
				{
								// endon for the guy
								ent_temp endon( "death" );

								// turn off his sense
								ent_temp setenablesense( false );

								// wait for teh trigger
								trig waittill( "trigger" );

								// save game
								level thread maps\_autosave::autosave_by_name( "montenegrotrain", 15.0 );

								// turn off his sense
								ent_temp setenablesense( true );

								// set the guy up
								ent_temp thread turn_on_sense( 5 );
								ent_temp setcombatrole( "RusherShotgun" );
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );
								ent_temp setalertstatemin( "alert_red" );
								ent_temp setscriptspeed( "walk" );
				}

				// wait
				wait( 1.0 );

				// clean up spawner
				ent_spawner delete();
}
///////////////////////////////////////////////////////////////////////////
// 08-09-08 WWilliams
// function controls the guy who jumps back to the passenger train
train_wave3_passenger_jump( ent_spawner )
{
				// double check objects passed in
				//assertex( isdefined( ent_spawner ), "passenger jump back spawner not defined" );

				// objects to define for this function
				node_wait = GetNode( "nod_jump_back_wait", "targetname" );
				node_destin = GetNode( "nod_jumper_destin", "targetname" );
				node_tether = GetNode( "nod_bag1_tether", "targetname" );
				

				// spawn out the guy
				guy = ent_spawner stalingradspawn( "f_enemy_wave_3" );
				if( maps\_utility::spawn_failed( guy ) )
				{
								// debug text
								iprintlnbold( "spawn fail on jump back guy" );
				}

				// endon
				guy endon( "death" );
				
				// turn off this guy until the right moment
				guy setenablesense( false );

				// wait for the notify that makes the boxes fall
				level waittill( "jump_break_start" );

				// turn this guy back on
				guy setscriptspeed( "run" );

				//// make this guy shoot at teh player
				//guy cmdshootatentity( level.player, true, 2.0 );

				//// wait for the end of the shooting
				//guy waittill( "cmd_done" );

				// run to the destination node
				guy setgoalnode( node_destin );

				// wait for goal
				guy waittill( "goal" );

				// give him his sense
				guy setenablesense( true );
				guy thread turn_on_sense( 5 );
				guy setengagerule( "tgtSight" );
				guy addengagerule( "tgtPerceive" );
				guy addengagerule( "Damaged" );
				guy addengagerule( "Attacked" );
				guy setalertstatemin( "alert_red" );

				// give combatrole once he gets there
				guy thread goal_n_combatrole( "guardian" );

				// set up the tether
				guy thread train_reset_speed_activate_tether( node_tether, 325, 1900, 285 );

}







//////////////////////////////////////////////////////////////////////////
// 05-31-08
// wwilliams
// special function on wave three guys
// keeps them crouched and not shooting until the player pulls the switch to uncouple
// second car
// runs on self/NPC
wait_for_2nd_uncouple()
{
				// endon
				level.player endon( "death" );
				self endon( "death" );
				self endon( "damage" );

				// turn them off real quick
				self setenablesense( false );

				// make them crouch
				self allowedstances( "crouch" );

				// wait for the notify that the car has been uncoupled
				level waittill( "knuckle_release_release_start" );

				// turn them back on
				self setenablesense( true );

				// check to see if the guy has a script_string defined
				// this will make the guys on the top of the car crouch
				if( isdefined( self.script_string ) )
				{
								// if the guy is on the top then he will crouch only
								self allowedstances( self.script_string );
				}
				// if no string then just do the normal
				else
				{
								// allow all stances again
								self allowedstances( "crouch", "stand" );
				}

}
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
//// setup specially animated enemy trying to seperate train.
special_freight_nme()
{
				freight_nme_seperator = GetEnt( "spwn_freight_uncouple", "targetname" );
				show_train_special = GetEnt("show_train_special", "targetname");
				//////////////////////////////////////////////////////////////////////////
				// 05-20-08
				// wwilliams
				// adding a new trigger define, this way i can get the freight to stop moving before
				// any of the rest of the scripts hit
				trig_stop_freight_for_seperate = getent( "trig_ready_show_train", "targetname" );
				// 05-30-08
				// wwilliams
				// scr to move the guy to
				ent_uncouple = getent( "freight_uncouple", "script_noteworthy" );
				// move_org
				scr_move_org = spawn( "script_origin", freight_nme_seperator.origin + ( 0, 0, -10 ) );
				// node
				cut_node = GetNode( "first_uncouple_tether", "targetname" );


				// check that everything is defined
				//assertex( isdefined( freight_nme_seperator ), "freight_nme_seperator not defined" );
				//assertex( isdefined( show_train_special ), "show_train_special not defined" );
				//assertex( isdefined( trig_stop_freight_for_seperate ), "trig_stop_freight_for_seperate not defined" );
				//assertex( isdefined( ent_uncouple ), "ent_uncouple not defined" );
				//assertex( isdefined( scr_move_org ), "scr_move_org not defined" );

				// set the count for the spawner
				freight_nme_seperator.count = 1;


				if ( IsDefined(freight_nme_seperator) )
				{
								// wait for notify, comes after wave_2 is set
								level waittill( "train_at_node_3" );

								// level.enemy_seperator = freight_nme_seperator StalingradSpawn("enemy_seperator");
								// level.enemy_seperator linkto(level.freight_train[6]);
								// level.enemy_seperator allowedstances("crouch");
								level.enemy_seperator = freight_nme_seperator StalingradSpawn("enemy_seperator");
								if( spawn_failed( level.enemy_seperator ) )
								{
												// debug text
												iprintlnbold( "level.enemy_seperator failed spawn" );

												// wait
												wait( 5.0 );

												// end function
												return;
								}
								else
								{
												// turn off the guy
												level.enemy_seperator SetEnableSense( false );

												// remove his gun
												level.enemy_seperator animscripts\shared::placeWeaponOn( level.enemy_seperator.primaryweapon, "none" );

												wait(0.05);
												
												// DCS: setting up necessary offset for grinder.
												saw_tag = Spawn( "script_model", level.enemy_seperator GetTagOrigin( "tag_weapon_left" ) + (-10, 7, 0) );
												saw_tag.angles = level.enemy_seperator gettagangles( "tag_weapon_left" ) + (180, 180, 0);
												saw_tag SetModel( "tag_origin" );
												saw_tag LinkTo( level.enemy_seperator, "tag_weapon_left" );
												saw_tag Attach("p_msc_grinder", "tag_origin");
												level.enemy_seperator thread remove_grinder_thug(saw_tag);
												level.enemy_seperator setQuickKillEnable(false);
												
												// wait for the player to go through the boxcar surprise
												level flag_wait( "car4_container_shoot" );

												if (IsDefined(show_train_special))
												{

																show_train_special waittill("trigger");

																if(IsDefined(level.freight_door2))
																{
																				level.door_busy = true;
																				thread activate_boxcar_door();

																				// wait for a notify from activate boxcar door
																				level waittill( "seperator_play" );

																				// 05-27-08
																				// wwilliams
																				// play an anim on this guy
																				level.enemy_seperator cmdplayanim( "Thug_TrainUncouple_Look_Crouch", true );

																				// wait for the anim to finish
																				// level.enemy_seperator waittill( "cmd_done" );

																				// play the looping anim for the guy
																				level.enemy_seperator cmdplayanim( "Thug_TrainUncouple_CrouchLoop", true );

																				// wait for the anim to complete
																				level.enemy_seperator waittill( "cmd_done" );

																				spark = spawn("script_origin", level.enemy_seperator gettagOrigin( "tag_weapon_left" ) );
																				spark linkto(level.enemy_seperator, "tag_weapon_left");
																				// welding_light = GetEnt("weldlight","targetname");
																				// define the origin for where the weldlight must be
																				// weldlight_position = ( -255, -3384, 132 );

																				// move the weldlight into the right position
																				// welding_light moveto( weldlight_position, 0.05 );


																				level.welding_now = true;
																				thread welding_sparks(spark);
																}
																else
																{
																				iPrintLnBold( "Couldn't find boxcar door" );
																}
												}
								}
				}

				// clean up the spawner
				freight_nme_seperator delete();
}

remove_grinder_thug(grinder)
{
	self waittill_any("death");
	grinder detach("p_msc_grinder", "tag_origin");
	grinder delete();
}	
//////////////////////////////////////////////////////////////////////////
// 05-19-08
// wwilliams
// new function for the guys throwing bags into the passenger train
// runs on level
train_bag_tossers()
{
				// endon
				level.player endon( "death" );
				// self endon( "death" );
				// self endon( "damage" );

				// objects to be defined for this function
				// spawner
				bag_tosser_spawner = getent( "spwn_bag_tosser", "targetname" );
				bag_talker_spawner = getent( "spwn_bag_talker", "targetname" );
				// nodes
				tosser_node = GetNode( "bag_tosser_tosser", "targetname" );
				talker_node = GetNode( "bag_tosser_talker", "targetname" );
				// objects to define for this function
				// undefined
				str_animation = undefined;
				ent_temp = undefined;
				// notify that will be used to start the animations
				str_start_notify = "bag_toss_begin";
				str_end_notify = "stop_bag_toss";

				// make sure everything is defined
				//assertex( isdefined( bag_tosser_spawner ), "bag_tosser_spawner not defined" );
				//assertex( isdefined( bag_talker_spawner ), "bag_talker_spawner not defined" );
				//assertex( isdefined( tosser_node ), "tosser_node not defined" );
				//assertex( isdefined( talker_node ), "talker_node not defined" );

				// set the right count on the spawner
				bag_tosser_spawner.count = 1;
				bag_talker_spawner.count = 1;

				///////////////////////////////////////////////////////////////////////////////////////////////////////////////
				// set the guys up
				// part 1
				ent_temp = bag_tosser_spawner stalingradspawn( "bag_tosser" );
				if( spawn_failed( ent_temp ) )
				{
								// debug text
								iprintlnbold( "bag_tosser_spawner fail" );

								// wait
								wait( 5.0 );

								// end function
								return;
				}
				else
				{
								// turn off ai
								ent_temp setenablesense( false );

								// give this guy a special script_noteworthy
								ent_temp.script_noteworthy = "train_bag_toss_guy";

								// give the guy the spawner's script_string
								ent_temp.script_string = bag_tosser_spawner.script_string;

								// send him to his node
								ent_temp setgoalnode( tosser_node );

								// wait for goal
								ent_temp waittill( "goal" );

								// run the bag tosser anim part1 on him
								// run the function on guy
								//ent_temp thread train_play_bag_throw( str_start_notify, "Thug_Train_BagToss_Part1", str_end_notify );

								//DCS: bag toss anim was bad, just playing fidget.
								ent_temp thread thugs_just_fidget();

								// frame wait
								wait( 0.05 );
								
								// thread off the bag control
								ent_temp thread train_bag_tosses(str_start_notify);

				}

				// bag toss part2
				ent_temp2 = bag_talker_spawner stalingradspawn( "bag_tosser" );
				if( spawn_failed( ent_temp2 ) )
				{
								// debug text
								iprintlnbold( "bag_talker_spawner fail" );

								// wait
								wait( 5.0 );

								// end function
								return;
				}
				else
				{
								// turn off ai
								ent_temp2 setenablesense( false );

								// give the guy the spawner's script_string
								ent_temp2.script_string = bag_talker_spawner.script_string;

								// send him to his node
								ent_temp2 setgoalnode( talker_node );

								// wait for goal
								ent_temp2 waittill( "goal" );

								// run the bag tosser anim part1 on him
								// run the function on guy
								//ent_temp2 thread train_play_bag_throw( str_start_notify, "Thug_Train_BagToss_Part2", str_end_notify );

								//DCS: bag toss anim was bad, just playing fidget.
								ent_temp2 thread thugs_just_fidget();
							
								// frame wait
								wait( 0.05 );

				}

				// send out the notify to start the anim
				level notify( str_start_notify );

				// start the dialogue function
				level thread train_bagtoss_dialogue();

				// clean up the spawner
				bag_tosser_spawner delete();
				bag_talker_spawner delete();

}
thugs_just_fidget()
{
	self cmdaction( "fidget" );
	//self cmdaction ( "CheckEarpiece" );
}	

//////////////////////////////////////////////////////////////////////////
// 05-19-08
// wwilliams
// // function waits for a notify
// then plays an animation on the guy passed in 
train_play_bag_throw( str_start_notify, str_animation, str_end_notify )
{
				// endon
				level.player endon( "death" );
				self endon( "death" );
				self endon( "damage" );

				// double check the defines
				//assertex( isdefined( str_start_notify ), "train_play_bag_throw missing str_notify!" );
				//assertex( isdefined( str_animation ), "train_play_bag_throw missing str_animation!" );
				//assertex( isdefined( str_end_notify ), "train_play_bag_throw missing str_end_notify!" );

				// extra endon, but the value needs to be doubled checked first
				level endon( str_end_notify );

				// wait for the notify to be sent out
				level waittill( str_start_notify );

				// while loop keeps playing the anim
				while( 1 )
				{
								// make sure self is alive
								if( isalive( self ) )
								{
												// play the anim
												self cmdplayanim( str_animation, true );

												// wait for the anim to finish
												self waittill( "cmd_done" );
								}
				}

}
//////////////////////////////////////////////////////////////////////////////////////////
// WW 07-01-08
// controls the bag showing up for the tossers
// runs on self/level
train_bag_tosses(str_start_notify)
{
	// endon
	level.player endon( "death" );
	level endon( "stop_bag_toss" );
	
	level waittill(str_start_notify);
	
	if(IsDefined(self))
	{
				
		//DCS: setup open door.
		door = getent("train_contraband_door", "targetname");
		door movey( -125, 1.0, 0.2, 0.3 );
		self thread close_door_tossers(door);
/*		
		while(true)				
		{
			// wait for the notetrack
			self waittillmatch( "anim_notetrack", "bag_appear" );

			//iprintlnbold( "Bag_Appear" );

			// model
			bag = spawn( "script_model", self.origin );
			bag setmodel( "p_igc_duffle_bag" );
			self attach( "p_igc_duffle_bag", "TAG_WEAPON_RIGHT" );

			// wait for the notetrack
			self waittillmatch( "anim_notetrack", "bag_disappear" );

			// DCS: remove bag.
			self detach( "p_igc_duffle_bag", "TAG_WEAPON_RIGHT" );
			bag delete();

			//iprintlnbold( "Bag_Disappear" );
		}	
*/
	}
}

close_door_tossers(door)
{
	// DCS: close door.
	self waittill_any("death", "alert_red", "alert_yellow");
  door movey( 125, 1.0, 0.2, 0.3 );
}
	
//////////////////////////////////////////////////////////////////////////////////////////
// WW 07-01-08
// function waits for the end notify
// hides the bag and gets rid of it
// runs on level
train_toss_bag_clean_up( bag )
{
				// endon
				// single shot

				// double check passed in item
				//assertex( isdefined( bag ), "bag is not defined" );

				// objects to define for the function
				// ent
				guy = getent( "train_bag_toss_guy", "script_noteworthy" );

				// wait for the notify
				level waittill( "stop_bag_toss" );

				// hide the bag
				bag hide();

				// detach it
				guy detach( "p_igc_duffle_bag", "TAG_WEAPON_RIGHT" );

				// wait a second
				wait( 1.0 );

				// delete it
				bag delete();


}
//////////////////////////////////////////////////////////////////////////////////////////
// WW 07-01-08
// function plays the sound off of the bag_tossers
// also sends out the notify when the player finishes the ledge crawl
//////////////////////////////////////////////////////////////////////////////////////////
train_bagtoss_dialogue()
{
				// endon

				// objects to be defined for this function
				// trigs
				trig_start_dialogue = getent( "trig_start_tosser_dialogue", "targetname" );
				trig_end_dialogue = getent( "trig_end_tosser_dialogue", "targetname" );
				// ent array-the tossers
				enta_bag_tossers = getentarray( "bag_tosser", "targetname" );
				// undefined
				temp_node = undefined;

				// double check defines
				//assertex( isdefined( trig_start_dialogue ), "trig_start_dialogue not defined" );
				//assertex( isdefined( trig_end_dialogue ), "trig_end_dialogue not defined" );
				//assertex( isdefined( enta_bag_tossers ), "enta_bag_tossers not defined" );

				// wait for start trig
				trig_start_dialogue waittill( "trigger" );

				// start the dialogue between the guys
				// line 1 
				enta_bag_tossers[0] play_dialogue( "DMR1_TraiG_037A" );

				// line 2
				enta_bag_tossers[1] play_dialogue( "DMR2_TraiG_038A" );

				// line 3
				enta_bag_tossers[0] play_dialogue( "DMR1_TraiG_039A" );

				// line 4
				enta_bag_tossers[1] play_dialogue( "DMR2_TraiG_040A" );

				// wait for the player to reach the end of the ledge crawl
				trig_end_dialogue waittill( "trigger" );

				// notify to stop the bag toss anim
				level notify( "stop_bag_toss" );

				// stop the guys movement
				for( i=0; i<enta_bag_tossers.size; i++ )
				{
								// check to see if the guy is alive
								if( isalive( enta_bag_tossers[i] ) )
								{
												// stop all cmds on each guy
												enta_bag_tossers[i] stopallcmds();

												// enable sense again
												enta_bag_tossers[i] setenablesense( true );

												// turn them to red
												enta_bag_tossers[i] lockalertstate( "alert_red" );

												// get teh node to send them to
												temp_node = GetNode( enta_bag_tossers[i].script_string, "targetname" );

												// send him to his node
												enta_bag_tossers[i] setgoalnode( temp_node );

												// set combat role
												enta_bag_tossers[i] setcombatrole( "guardian" );

												// give them a taste of perfect sense
												enta_bag_tossers[i] thread turn_on_sense( 5 );

												// undefine temp node
												temp_node = undefined;
								}
				}

				// line 5
				enta_bag_tossers[0] play_dialogue_nowait( "DMR1_TraiG_041A" );
				// line 6
				enta_bag_tossers[1] play_dialogue( "DMR2_TraiG_042A" );

				// Tanner line
				level.player play_dialogue( "TANN_TraiG_807A", true );

}
///////////////////////////////////////////////////////////////////////////
// 08-18-08 WWilliams
// grabs the tossers and links them to the car if the uncouple happens when
// player causes uncouple
second_uncouple_alive_link()
{
				// endon

				// objects to define for this function
				// train car
				train_car = GetEnt( "freight4", "targetname" );
				// ent array
				enta_second_uncouple = getentarray( "bag_tosser", "targetname" );
				// unefined
				scr_org = undefined;

				// frame wait
				wait( 0.05 );

				// make sure the array has a count
				if( isdefined( enta_second_uncouple ) && enta_second_uncouple.size == 0 )
				{
								// end this function
								return;
				}

				// other wise for loop through them and link them to the train car
				for( i=0; i<enta_second_uncouple.size; i++ )
				{
								// make sure the guy is alive
								if( isalive( enta_second_uncouple[i] ) )
								{
												// spawn script origin
												scr_org = spawn( "script_origin", enta_second_uncouple[i].origin );

												// link him to the car
												enta_second_uncouple[i] linkto( scr_org );

												// link scr_org to car
												scr_org linkto( train_car );

												// undefined scr_org
												scr_org = undefined;
								}

								// check for life
								if( isalive( enta_second_uncouple[i] ) )
								{
												// make them shoot at the player with zero accuracy
												enta_second_uncouple[i] cmdshootatpos( level.player.origin + ( 0, 0, 100 ), true, -1, 0 );
								}
				}

				// wait for the notify the car is out of range
				while( distancesquared( level.player.origin, train_car.origin ) < 4000*4000 )
				{
								// wait
								wait( 0.1 );
				}

				// clean out the array
				enta_second_uncouple maps\_utility::remove_dead_from_array( enta_second_uncouple );
				// frame wait
				wait( 0.05 );
				// clean out undefined
				enta_second_uncouple maps\_utility::array_removeUndefined( enta_second_uncouple );

				// for loop goes through the guys to get rid of them
				for( i=0; i<enta_second_uncouple.size; i++ )
				{
								// if is alive
								if( isalive( enta_second_uncouple[i] ) )
								{
												// stop shooting
												enta_second_uncouple[i] stopallcmds();

												// hide him
												enta_second_uncouple[i] hide();

												// unlink him
												enta_second_uncouple[i] unlink();

												// delete him
												enta_second_uncouple[i] delete();
								}
				}
}
///////////////////////////////////////////////////////////////////////////
//	Setup activation of boxcar door.
///////////////////////////////////////////////////////////////////////////
activate_boxcar_door()
{
				//// save just before walking up to door.
				// SaveGame( "montenegrotrain" );
				level thread maps\_autosave::autosave_now( "montenegrotrain" );

				while(Distance( level.freight_playerpos.origin, level.player.origin ) > 64 )
				{
								wait(0.05);
				}	
				
				//DCS: moving camera in front of door before force cover.
				level.cameraID = level.player customcamera_push( "entity", level.freight_playerpos, level.enemy_seperator, (-50, 0, 58 ), ( 0, 0, 0 ), 1.0 );
				
				//// force player to cover.
				level.player setorigin( level.freight_playerpos.origin + (55, -30, -10));
				level.player setplayerangles( level.freight_playerpos.angles );
				thread open_boxcar_door();
				
				// DCS: trigger third set of fx entities.
				level notify("start_fxgroup_3");
				
				wait( 0.5 );

				while( level.door_busy == true )
				{
								//////////////////////////////////////////////////////////////////////////
								// 05-10-08
								// wwilliams
								// new condition for playersetforcecover, makes it so the player doesn't pop out
								// when set to false
								//////////////////////////////////////////////////////////////////////////
								level.player playerSetForceCover( true, (0, 0, 0), true, true );
								//wait
								wait( 0.1 );
								
				}

				// wait
				wait( 0.1 );

				// notify the customcamera to go
				// level notify( "start_boxcar_camera" );
				level flag_set( "start_boxcar_camera" );

				// thread off the function to make guys jump across to the freight
				// level thread maps\MontenegroTrain_car4::first_uncouple_jumpers();

				//////////////////////////////////////////////////////////////////////////
				// 05-10-08
				// wwilliams
				// new condition for playersetforcecover, makes it so the player doesn't pop out
				// when set to false
				//////////////////////////////////////////////////////////////////////////
				level.player playerSetForceCover( false, false );


}						
////////////////////////////////////////////////
//// stop train so I can open the freight door
//// zoom in to show enemy at work.
////////////////////////////////////////////////

open_boxcar_door(strcObject)
{
				thread start_boxcar_scene();
}
start_boxcar_scene()
{	

				level.player freezecontrols( true );
				level.player SetCanDamage(false);

				//// wait for the train to be still, then open door.
				while( level.train_moving == true )
				{
								wait(0.05);
				}

				level.freight_door2 unlink();
				level.freight_door2 movex(58, 1.0);

				///////////////////////////////////////////////////////////
				// 07-19-08 WWilliams
				// notify makes the wave_2 get into position
				level notify( "wave_2_start" );

				//Steve G
				level.freight_door2 playsound("boxcar_door_open");

				wait(1.0);

				level.door_busy = false;

				level.freight_door2 linkto( getent( level.freight_door2.target, "targetname" ) );

				// wait for the player to be in cover properly before moving the camera
				// level waittill( "start_boxcar_camera" );
				level flag_wait( "start_boxcar_camera" );

				// notify the guy to play the animation
				level notify( "seperator_play" );

				// false the camera's collision
				level.player customcamera_checkcollisions( 0 );

				// change the lodbias
				SetDvar( "r_lodBias", -750 );

				//DCS: put camera in doorway prior to zoom out to avoid going threw wall.
				//level.cameraID = level.player customcamera_push( "entity", level.freight_playerpos, level.enemy_seperator, (20, 0, 60 ), ( 0, 0, 0 ), 0.5 );
				//wait(0.5);
				level.player customCamera_change(level.cameraID, "entity", level.enemy_seperator, level.enemy_seperator, (-120, 10, 60 ), ( -20, 0, 0 ), 2.0 );
			

				//level.cameraID = level.player customcamera_push( "entity", level.enemy_seperator, level.enemy_seperator, (-120, 10, 60 ), ( -20, 0, 0 ), 2.0 );
				wait(1.0);
				// iPrintLnBold( "Hold him off, I've almost got it!" );
				// WW 07-01-08
				// dialogue line for this guy
				level.enemy_seperator play_dialogue( "CPMR_TraiG_034A" );

				//Start Decouple Music - Added by crussom
				level notify( "playmusicpacakge_decouple" );

				wait(2.0);

				// thread enemy_seperator_wakeup(level.enemy_seperator);
				// thread enemy_seperator_healthcheck(level.enemy_seperator);
				// thread create_time_limit(45);


				level.player customCamera_pop(level.cameraID, 0.05);

				// true the camera's collision
				level.player customcamera_checkcollisions( 1 );

				// change the lodbias back to normal
				SetDvar( "r_lodBias", 0 );

				level.player freezecontrols( false );
				level.player SetCanDamage(true);

				// start the timer
				level thread maps\_utility::timer_start( 30 );
				level.clock_running = true;

				// 08-19-08 WWilliams
				// links guys if alive to the first uncouple car
				level thread first_uncouple_alive_link();

				//////////////////////////////////////////////////////////////////////////
				// 05-12-08
				// wwilliams
				// removing the call into the function for PIP while hte guy is trying
				// to uncouple the train
				// thread enemy_seperator_camera(level.enemy_seperator);
				//////////////////////////////////////////////////////////////////////////
}	
//////////////////////////////////////////////////////////////////////////
// 05-12-08
// wwilliams
// commenting out the function that starts the PIP on the 
// uncouple freight train guy
/*enemy_seperator_camera(enemy)
{
if( getdvar( "pip_off") != "true")
{
//turn on picture in picture
thread pip_freight_setup();
wait(0.05);
cameraID_freight = level.player SecurityCustomCamera_Push("entity",enemy, enemy, (-60.0, 60.0, 90.0),(-20, 0, 0),  0.0);
thread check_for_player_death();
}
}*/	
//////////////////////////////////////////////////////////////////////////
check_for_player_death()
{
				level endon("enemy_dead");

				while(IsAlive(level.player) && level.clock_running == true )
				{
								wait(0.05);
				}	
				//	SetDVar("r_pipMainMode", 0);
				SetDVar("r_pipSecondaryMode", 0);
}	

//// wake up guy trying to seperate train when player gets too close.
enemy_seperator_wakeup(enemy)
{
				while(IsDefined(enemy) && Distance( enemy.origin, level.player.origin ) > 128 )
				{
								//enemy CmdPlayAnim( "need_anim", true );
								//print3d(enemy.origin + (0, 10, 80), "seperation animation", ( 1.0, 0.8, 0.5 ), 1, 0.5);
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
								//////////////////////////////////////////////////////////////////////////
								// 05-10-08
								// wwilliams
								// new flag mimics this level var
								if( flag( "freight_train_active" ) )
								{
												level flag_clear( "freight_train_active" );

												// debug text
												// 05-22-08
												// wwilliams
												// commenting out all iprintlnbold debug
												// iprintlnbold( "cleared_freight_train_active" );
								}
								//////////////////////////////////////////////////////////////////////////

								//////////////////////////////////////////////////////////////////////////
								// 05-10-08
								// wwilliams
								// need to come back here and set this to watch the flag instead of the
								// level var
								// for both
								// freight_train_active
								// on_freight_train
								//////////////////////////////////////////////////////////////////////////

								// put player back on main train.
								if(	level.on_freight_train == true)
								{
												exit_train_pos = GetEnt( "exit_freight_train", "targetname" );
												level.on_freight_train = false;

												// 05-15-08
												// wwilliams
												// turn off the on_freight flag
												level flag_clear( "on_freight_train" );

												level.train_passing_by = false;
								}

								//////////////////////////////////////////////////////////////////////////
								// 05-16-08
								// wwilliams
								// wait for the cutscene to finish
								level waittill( "Train_Bond_Jump_done" );

								// thread rain control
								// 05-16-08
								// wwilliams
								// quick hack for where the rain starts
								// 06-06-08
								// rain could be causing issue with DObjs
								// commenting out
								// level thread maps\MontenegroTrain::train_rain();

								//move train to end node then hide.
								level.freight_train[0] moveto( level.freight_train_end.origin, 30 );
								level.freight_train[0] waittill( "movedone" );
								
								// DCS: delete last of freight fx entities.
							level notify("delete_fxgroup_4");
								
								
								//DCS: freight train gone, reset culldist.
								level thread reset_culldist_freight();

								// clean out the array
								level.freight_train = maps\_utility::array_removeUndefined( level.freight_train );

								for ( i = 0; i < level.freight_train.size; i++ )
								{
												// hide the cars
												level.freight_train[i] hide();

												// unlink them
												level.freight_train[i] unlink();

												// delete the car
												level.freight_train[i] delete();
								}
								//////////////////////////////////////////////////////////////////////////
								// 05-10-08
								// wwilliams
								// comment out old door hide
								//level.freight_door1 hide();
								if( isdefined( level.freight_door1_right ) )
								{
												// add new door hide
												// right door
												level.freight_door1_right hide();
								}

								// left door
								level.freight_door1_left hide();
								//////////////////////////////////////////////////////////////////////////
								level.freight_door2 hide();
								//////////////////////////////////////////////////////////////////////////
								// 05-15-08
								// wwilliams
								// no longer using this door, it doesn't exist in the map
								// level.freight_door3 hide();
								//////////////////////////////////////////////////////////////////////////
								// clean out the array
								level.enta_freight_smodels = maps\_utility::array_removeUndefined( level.enta_freight_smodels );
								//////////////////////////////////////////////////////////////////////////
								// 05-15-08
								// wwilliams
								// hide all the other script models
								// for loop goes through them
								for( i=0;i<level.enta_freight_smodels.size; i++ )
								{
												// check to make sure the thing is defined
												if( isdefined( level.enta_freight_smodels[i] ) )
												{
																// unlink it
																level.enta_freight_smodels[i] unlink();
																// delete it
																// show the model
																level.enta_freight_smodels[i] delete();
												}

												// wait
												wait( 0.05 );
								}
								// clean up the guys left behind by a player
								enta_boxcar_enemies = getentarray( "boxcar_surprise", "targetname" );
								enta_bagtoss_enemies = getentarray( "bag_tosser", "targetname" );
								enta_freight_wave1 = getentarray( "f_enemy_wave_1", "targetname" );
								enta_freight_wave2 = getentarray( "f_enemy_wave_2", "targetname" );
								enta_freight_wave3 = getentarray( "f_enemy_wave_3", "targetname" );

								// check to see if there is anything in the boxcar array
								if( enta_boxcar_enemies.size > 0 )
								{
												// check each spot and if there is a guy alive in it
												for( i=0; i<enta_boxcar_enemies.size; i++ )
												{
																if( isalive( enta_boxcar_enemies[i] ) )
																{
																				// hide him
																				enta_boxcar_enemies[i] hide();

																				// unlink him
																				enta_boxcar_enemies[i] unlink();

																				wait( 0.05 );

																				// delete
																				enta_boxcar_enemies[i] delete();


																}
												}
								}

								// check to see if there is anything in the boxcar array
								if( enta_bagtoss_enemies.size > 0 )
								{
												// check each spot and if there is a guy alive in it
												for( i=0; i<enta_bagtoss_enemies.size; i++ )
												{
																if( isalive( enta_bagtoss_enemies[i] ) )
																{
																				// hide him
																				enta_bagtoss_enemies[i] hide();

																				// unlink him
																				enta_bagtoss_enemies[i] unlink();

																				wait( 0.05 );

																				// delete
																				enta_bagtoss_enemies[i] delete();

																				wait( 0.05 );
																}
												}
								}

								// check to see if there is anything in the wave 1 array
								if( enta_freight_wave1.size > 0 )
								{
												// check each spot and if there is a guy alive in it
												for( i=0; i<enta_freight_wave1.size; i++ )
												{
																if( isalive( enta_freight_wave1[i] ) )
																{
																				// hide him
																				enta_freight_wave1[i] hide();

																				// unlink him
																				enta_freight_wave1[i] unlink();

																				wait( 0.05 );

																				// delete
																				enta_freight_wave1[i] delete();
																}
												}
								}

								// check to see if there is anything in the wave 2 array
								if( enta_freight_wave2.size > 0 )
								{
												// check each spot and if there is a guy alive in it
												for( i=0; i<enta_freight_wave2.size; i++ )
												{
																if( isalive( enta_freight_wave2[i] ) )
																{
																				// hide him
																				enta_freight_wave2[i] hide();

																				// unlink him
																				enta_freight_wave2[i] unlink();

																				wait( 0.05 );

																				// delete
																				enta_freight_wave2[i] delete();

																}
												}
								}

								// check to see if there is anything in the wave 3 array
								if( enta_freight_wave3.size > 0 )
								{
												// check each spot and if there is a guy alive in it
												for( i=0; i<enta_freight_wave3.size; i++ )
												{
																if( isalive( enta_freight_wave3[i] ) )
																{
																				// hide him
																				enta_freight_wave3[i] hide();

																				// unlink him
																				enta_freight_wave3[i] unlink();

																				wait( 0.05 );

																				// delete
																				enta_freight_wave3[i] delete();

																}
												}
								}
								///////////////////////////////////////////////////////////////////////////////////////
				}
				else
				{
								iPrintLnBold( "couldn't find freight end trigger!" );
								return;
				}	
}	
reset_culldist_freight()
{
	if( level.ps3 || level.bx ) //GEBE
	{
		SetExpFog( 500, 4000, 0.012, 0.022, 0.02, 2.0, 1.0 );	
		wait(2.0);
		setculldist( 10000 );
	}
}	
random_train_movement()
{	
				//////////////////////////////////////////////////////////////////////////
				// 05-10-08
				// wwilliams
				// need to come back here and set this to watch the flag instead of the
				// level var
				// for both
				// freight_train_active
				// on_freight_train
				//////////////////////////////////////////////////////////////////////////
				// 05-20-08
				// wwilliams
				// i need to add an end on for this, that way another function can check for the train 
				// to stop moving and set up the moments for the freight
				level endon( "stop_random_freight" );


				// randomly slow and speed up train.
				// 05-20-08
				// wwilliams
				// while the train var is set to true
				while( level.freight_train_active == true )
				{
								// 05-20-08
								// wwilliams
								// make time random between 1 and 5
								time = randomfloatrange(1.0, 5.0);
								// wait that time
								wait(time);

								// make sure the player is on the train
								if(	level.on_freight_train == true)
								{
												// pick a number between negative 64 and positive 64
												y = randomfloatrange(-64.0, 64.0);
												// speed of 8
												speed = 8.0;
								}
								// if the player is not on the freight
								else
								{
												// pick a larger random from negative 256 and positive 256
												y = randomfloatrange(-256.0, 256.0);
												// higher speed change
												speed = randomfloatrange(10.0, 20.0);
								}	

								// if none of the moving doors are busy
								if(level.door_busy == false)
								{
												// set the level var that the train is now going to move
												level.train_moving = true;
												// 05-20-08
												// wwilliams
												// setting a flag for this
												level flag_set( "freight_train_moving" );

												////dividing movement in half for door movement check.
												// take the y and speed value from above, halve them, and apply them to the train's current position
												level.freight_train[0] moveto( level.current_train_pos.origin + (0, y * 0.5, 0), speed * 0.5 );
												// wait for the move to finish
												level.freight_train[0] waittill( "movedone" );

												// make sure none of the doors are moving again
												if(level.door_busy == false)
												{
																// this time only half the time and allow the train to go all the way to the y from above
																level.freight_train[0] moveto( level.current_train_pos.origin + (0, y, 0), speed * 0.5 );
																// wait for move to finish
																level.freight_train[0] waittill( "movedone" );
												}
												// set the var that the train is done movine
												level.train_moving = false;
												// 05-20-08
												// clearing a flag for this
												level flag_clear( "freight_train_moving" );
								}
				}

				// debug text
				// 05-22-08
				// wwilliams
				// commenting out all iprintlnbold debug
				// iprintlnbold( "random_train_movement has ended!" );
}
//////////////////////////////////////////////////////////////////////////////////////////
//  time limit counter, stolen from construction site util.
//////////////////////////////////////////////////////////////////////////////////////////
//seperation_successful()
//{
//				//// take away control.
//				level.player SetCanDamage(false);
//
//				//// look at enemy seperator.
//				look_direction = VectorToAngles( (level.enemy_seperator.origin + (0, 0, 72)) - (level.player.origin + (0, 0, 72)) ); 
//				level.player setplayerangles(look_direction);
//				level.player freezecontrols( true );
//
//				level.welding_now = false;
//				level notify("stop_welding");
//
//				train_car = GetEnt("freight7", "targetname");
//				train_car unlink();
//
//				//// Move train back to see failure.	
//				train_car moveto( level.freight_train_end.origin, 40, 10, 0 );
//				wait(3.0);
//				MissionFailedWrapper();
//}	
//////////////////////////////////////////////////////////////////////////////////////////
//  Set up picture in picture.
//////////////////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
// 05-13-08
// wwilliams
// removing calls to security cameras, trying to stop a monkey error
/*pip_freight_setup()
{
if( getdvar( "pip_off") == "true")
{
return;
}

//setup pip cameras.
//	SetDVar("r_pip1X", 0.08);
//	SetDVar("r_pip1Y", 0.065);						// place top left corner of display safe zone
//	SetDVar("r_pip1Anchor", 4);						// use top left anchor point
//	SetDVar("r_pip1Scale", "0.75 0.75 1.0 1.0");		// scale image, without cropping
//	SetDVar("r_pipMainMode", 1);

SetDVar("r_pipSecondaryX", 0.05);
SetDVar("r_pipSecondaryY", 0.05);						// place top left corner of display safe zone
SetDVar("r_pipSecondaryAnchor", 0);						// use top left anchor point
SetDVar("r_pipSecondaryScale", "0.45 0.45 1.0 1.0");		// scale image, without cropping
SetDVar("r_pipSecondaryAspect", false);					// 4:3 aspect ratio
SetDVar("r_pipSecondaryMode", 5);						// enable video camera display with highest priority 		
level.player setsecuritycameraparams( 55, 3/4 );
}*/

//////////////////////////////////////////////////////////////////////////////////////////
//  Steal welding anim from construction site.
//////////////////////////////////////////////////////////////////////////////////////////
/*
Name: saw_sparks
Author: Kevin Drew
Purpose: modified from K. Drews saw.
Paramters:
none.
*/
welding_sparks(fx)
{
				level endon("stop_welding");

				// thread off the function to turn off the light
				//level thread welding_light_off( light );

				//light SetLightIntensity( 1.2 );

				while(level.welding_now == true)
				{
								wait(1.25);
								//light thread light_flicker(true, 0.5 , 1.5);
								Playfx(level._effect["welding_sparks"], fx.origin);
								wait(2.25);
								//light notify("stop_light_flicker");
				}
				/*light setlightintensity (0);*/
}
//////////////////////////////////////////////////////////////////////////
// WW 07-01-08
// function turns off the light from the welding after recieving the notify
// runs on level
//welding_light_off( light )
//{
//				// verify light that was passed is
//				//assertex( isdefined( light ), "light not defined" );
//
//				// wait for notify
//				level waittill( "stop_welding" );
//
//				// wait a frame for everything else to turn off
//				wait( 0.05 );
//
//				// turn off the light
//				light setlightintensity (0);
//}
//////////////////////////////////////////////////////////////////////////
// 05-15-08
// wwilliams
// func waits for the player to hit a trig
// then starts the decoupling of the train car
train_first_uncouple()
{
				// endon
				level.player endon( "death" );

				// objects to be defined for this function
				// trig
				trig_uncouple = getent( "trig_start_first_uncouple", "targetname" );

				// ents
				train_car = GetEnt( "freight5", "targetname" );
				// car_to_be_on = getent( "freight4", "targetname" );
				// origin
				earthquake_org = undefined;
				// undefined
				int_time = undefined;

				// frame wait cause a trigger is not being defined
				wait( 0.05 );

				// thread off the seperator comment if he is alive
				level thread train_first_uncouple_comment();

				// double check the trig is defined
				if( isdefined( trig_uncouple ) )
				{
								// wait for the player to hit the uncouple trigger
								// trig_uncouple waittill( "trigger" );
								level train_notify_or_trigger( "timer_ended", trig_uncouple );

								// change the flag that allows the train to move
								level.freight_train_active = false;
								// should stop the wielding
								level notify("stop_welding");

								// check to see if the seperator is defined
								if( isdefined( level.enemy_seperator ) )
								{
												// make sure he is alive
												if( isalive( level.enemy_seperator ) )
												{
																// run dialogue on the guy
																level.enemy_seperator thread maps\_utility::play_dialogue_nowait( "CPMR_TraiG_036A" );

																// stop the animation on the guy
																level.enemy_seperator stopallcmds();

																// wait a frame
																wait( 0.05 );

																// turn his sense back on
																level.enemy_seperator setenablesense( true );

																//// unlink the saw
																//level.saw unlink();

																//// frame wait
																//wait( 0.05 );

																//// delete the saw
																//level.saw delete();

																// remove his gun
																// level.enemy_seperator animscripts\shared::placeWeaponOn( level.enemy_seperator.primaryweapon, "SAF45_Train" );

																// change the allowed stanced
																level.enemy_seperator allowedstances( "stand" );

																// give him perfect sens for a second
																level.enemy_seperator thread turn_on_sense( 3 );

																// send the notify for the break uncouple to take place
																level notify( "knuckle_break_break_start" );

																// earthquake
																earthquake( 0.5, 4, level.player.origin, 500 );
																
																//Steve G - shake sound
																level.player playsound("uncouple_big_shake_01");

																// run dialogue on the guy
																level.player thread maps\_utility::play_dialogue_nowait( "TANN_TraiG_801A", true );

																// quick store the origin of the seperator
																temp_origin = level.enemy_seperator.origin;

																// kill the guy
																level.enemy_seperator dodamage( level.enemy_seperator.health + 500, level.enemy_seperator.origin + ( 0, -5, 70 ) );

																// physics push to send him off the car
																physicsExplosionCylinder( temp_origin + ( 0, -5, 60 ), 34, 12, 0.5 );
												}
								}
								level.welding_now = false;
								// should stop the clock
								level.clock_running = false;
								// removes the timer
								// level.timer_hud destroy();
				}
				else
				{
								// debug text
								iprintlnbold( trig_uncouple.targetname + " is not defined!" );
				}

				// wait for the train to stop moving
				while( level.train_moving == true )
				{
								// quick wait
								wait( 0.05 );
				}

				// check to make sure the thing is defined
				if( isdefined( train_car ) )
				{
								// unlink the train
								train_car unlink();

								// define the two cars needed to check for the player touching
								freight_car_5_trig = getent( "uncouple1_disable_cover", "targetname" );

								// thread off the ability to turn off cover
								level thread wrong_car_no_cover( freight_car_5_trig );
								
								

								// link all the guys who are alive on the car
				}
				else
				{
								// debug text
								iprintlnbold( train_car.targetname + " is not defined!" );

								// end func
								return;
				}

				// clean up function for these cars
				level thread freight_1st_uncouple_cleanup();
				
				// clean up bodies function
				deleteallcorpses( 1 );

				// thread off save function
				level thread first_uncouple_save();

				//// Move train back to see failure.	
				// train_car moveto( level.freight_train_end.origin, 40, 30, 0 );
				train_car thread train_car_fall_back( level.freight_train_end.origin, "1_uncouple_done" );
				// need to change this from a simple wait, will have to probably check to see if the player is not touching a trigger

				// wait(3.0);
				// iprintlnbold( "The train car has uncoupled!" );

				//Steve G
				freight_coupling_1_org_var = getent("freight_coupling_1_org", "targetname");
				if( isdefined( freight_coupling_1_org_var ) )
				{
								freight_coupling_1_org_var playsound("freight_coupler_1");

				}	

				// thread off the function that checks for the player's position
				level train_player_made_jump( getent( "freight5", "targetname" ), getent( "freight4", "targetname" ), getent( "trig_first_uncouple_success", "targetname" ) );

				//// wait for the notify
				level notify( "level5_map" );

				//// give player an extra second
				//wait( 1.0 );
}
///////////////////////////////////////////////////////////////////////////
// 08-22-08 WWilliams
// saves when the player makes it to the trigger past the first uncouple
first_uncouple_save()
{
				// endon

				// objects to define for this function
				// trigs
				save_trig = getent( "trig_first_uncouple_success", "targetname" );

				// wait for the player to hit the save_trig
				save_trig waittill( "trigger" );
				
				// DCS: need to kill timer once jump across.
				level notify("kill_timer");

				// turn off the no_cover function
				level notify( "stop_disable_cover" );

				// frame wait
				wait( 0.05 );

				// check to make sure the dvar for cover is enabled
				if( getdvar( "cover_disable" ) == "1" )
				{
								// turn off cover disable
								SetSavedDvar( "cover_disable", "0" );
				}

				// save the game
				level thread maps\_autosave::autosave_now( "montenegrotrain" );
}
///////////////////////////////////////////////////////////////////////////
// 08-22-08 WWilliams
// saves when the player makes it to the trigger past the second uncouple
second_uncouple_save()
{
				// endon

				// objects to define for this function
				// trigs
				save_trig = getent( "trig_check_2nd_success", "targetname" );

				// wait for the trigger to hit
				save_trig waittill( "trigger" );

				// turn off the no_cover function
				level notify( "stop_disable_cover" );

				// frame wait
				wait( 0.05 );

				// check to make sure the dvar for cover is enabled
				if( getdvar( "cover_disable" ) == "1" )
				{
								// turn off cover disable
								SetSavedDvar( "cover_disable", "0" );
				}

				// save the game
				level thread maps\_autosave::autosave_now( "montenegrotrain" );
}
///////////////////////////////////////////////////////////////////////////
// 08-22-08 WWilliams
// disable cover if the player is on the car that has been uncoupled
wrong_car_no_cover( sbrush_car )
{
				// endon
				level endon( "stop_disable_cover" );

				// objects to define for this function
				// train car
				// train_car = sbrush_car
				assertex( isdefined( sbrush_car ), sbrush_car.targetname + "is not defined" );
				// local var
				forced_out_of_cover = false;
				dvar_changed = false;

				// continue loop
				while( isdefined( sbrush_car ) )
				{
								// check to see if the player is touching the car
								while( level.player istouching( sbrush_car ) )
								{
												if( forced_out_of_cover == false )
												{
																// kick player out of cover
																level.player playersetforcecover(false, true);
																wait(0.05);
																level.player ForceOutOfCover();

																//iprintlnbold( "player forced out of cover" );

																// change local var
																forced_out_of_cover = true;
												}

												// wait
												wait( 0.1 );

												if( dvar_changed == false )
												{
																// turn off the dvar to 
																SetSavedDVar( "cover_disable", "1" );

																// iprintlnbold( "cover has been disabled" );

																dvar_changed = true;
												}
								}

								// change the local vars back to normal
								forced_out_of_cover = false;
								dvar_changed = false;

								// wait
								wait( 0.05 );
				}
}
///////////////////////////////////////////////////////////////////////////
// 08-11-08 WWilliams
// function makes the seperator talk if he is alive and the player gets
// halfway to the first uncouple
train_first_uncouple_comment()
{
				// objects to defined for this function
				// trig
				trig_seperator_dialogue = getent( "trig_1st_uncouple_dialogue", "targetname" );

				//double check the trig is real
				if( isdefined( trig_seperator_dialogue ) )
				{
								// wait for it to trigger
								trig_seperator_dialogue waittill( "trigger" );

								// earthquake_org = level.player.origin;

								// check to see if the seperator is defined
								if( isdefined( level.enemy_seperator ) )
								{
												// check to see if the seperator is alive
												if( isalive( level.enemy_seperator ) )
												{
																// play the sound off the guy
																level.enemy_seperator thread maps\_utility::play_dialogue_nowait( "CPMR_TraiG_035A" );
												}
								}
				}
}
///////////////////////////////////////////////////////////////////////////
// 08-18-08 WWilliams
// links all the guys left alive after first uncouple to the car
first_uncouple_alive_link()
{
				// endon

				// objects to define for this function
				// train car sbrush
				train_car = GetEnt( "freight5", "targetname" );
				// ent_array of guys
				enta_first_uncouple_guys = getentarray( "f_enemy_wave_2", "targetname" );
				// undefined
				scr_org = undefined;

				// frame wait to let teh array finish
				wait( 0.05 );

				// make sure there are guys in the array
				if( enta_first_uncouple_guys.size == 0 )
				{
								// end the function
								return;
				}

				// other wise for loop through them and link them to the train car
				for( i=0; i<enta_first_uncouple_guys.size; i++ )
				{
								// make sure the guy is alive
								if( isalive( enta_first_uncouple_guys[i] ) )
								{
												// spawn script origin
												scr_org = spawn( "script_origin", enta_first_uncouple_guys[i].origin );

												// link him to the car
												enta_first_uncouple_guys[i] linkto( scr_org );

												// link org to train
												scr_org linkto( train_car );

												// undefined script origin
												scr_org = undefined;
								}

								// check for life
								if( isalive( enta_first_uncouple_guys[i] ) )
								{
												// make them shoot at the player with zero accuracy
												enta_first_uncouple_guys[i] cmdshootatpos( level.player.origin + ( 0, 0, 100 ), true, -1, 0 );
								}
				}

				// wait for the notify the car is out of range
				while( distancesquared( level.player.origin, train_car.origin ) < 4000*4000 )
				{
								// wait
								wait( 0.1 );
				}

				// clean out the array
				enta_first_uncouple_guys maps\_utility::remove_dead_from_array( enta_first_uncouple_guys );
				// frame wait
				wait( 0.05 );
				// clean out undefined
				enta_first_uncouple_guys maps\_utility::array_removeUndefined( enta_first_uncouple_guys );

				// for loop goes through the guys to get rid of them
				for( i=0; i<enta_first_uncouple_guys.size; i++ )
				{
								// if is alive
								if( isalive( enta_first_uncouple_guys[i] ) )
								{
												// stop shooting
												enta_first_uncouple_guys[i] stopallcmds();

												// hide him
												enta_first_uncouple_guys[i] hide();

												// unlink him
												enta_first_uncouple_guys[i] unlink();

												// delete him
												enta_first_uncouple_guys[i] delete();
								}
				}
}
//////////////////////////////////////////////////////////////////////////
// 08-09-08 WWilliams
// function checks to see if the player is on the right train and within a trigger
train_player_made_jump( sbrush_unlinked, sbrush_safe, trig )
{
				// double check the objects passed in
				//assertex( isdefined( sbrush_unlinked ), "sbrush_unlinked not defined" );
				//assertex( isdefined( sbrush_safe ), "sbrush_safe not defined" );
				//assertex( isdefined( trig ), "trig not defined" );

				while( distancesquared( sbrush_unlinked.origin, sbrush_safe.origin ) < 1700*1700 )
				{
								// wait a frame
								wait( 0.05 );
				}
				// wait three seconds
				// wait( 5.0 );

				// check to see if the player is touching the unlinked car
				if( level.player istouching( sbrush_unlinked ) )
				{
								// mission failed
								MissionFailedWrapper();
				}

				// wait
				wait( 0.5 );

				// check to see if the player is touching the right objects
				if( level.player istouching( sbrush_safe ) || level.player istouching( trig ) )
				{
								// clean up bodies function
								deleteallcorpses( 1 );

								// check to see if the timer is active
								if( isdefined( level.timer ) )
								{
												// kill the timer
												level notify( "kill_timer" );
								}



								// check to make sure the dvar for cover is enabled
								if( getdvar( "cover_disable" ) == "1" )
								{
												// turn off the no_cover function
												level notify( "stop_disable_cover" );

												// iprintlnbold( "disable cover" );

												// frame wait
												wait( 0.05 );

												// turn off cover disable
												SetSavedDvar( "cover_disable", "0" );
								}

								// player passed, save the game
								// level maps\_autosave::autosave_now( "montenegrotrain" );
								// level maps\_autosave::autosave_by_name( "montenegrotrain", 10.0 );
								// level thread train_ledge_check();
								if( level.player.ledge_active == 0 )
								{
												// save the game
												level thread maps\_autosave::autosave_now( "montenegrotrain" );
								}

								// leave this function
								return;
				}

				// wait
				wait( 1.0 );

				// double check in case the player was in the air or something
				if( level.player istouching( sbrush_safe ) || level.player istouching( trig ) )
				{
								// clean up bodies function
								deleteallcorpses( 1 );

								// check to see if the timer is active
								if( isdefined( level.timer ) )
								{
												// kill the timer
												level notify( "kill_timer" );
								}


								// check to make sure the dvar for cover is enabled
								if( getdvar( "cover_disable" ) == "1" )
								{
												// turn off the no_cover function
												level notify( "stop_disable_cover" );

												// iprintlnbold( "disable cover" );

												// frame wait
												wait( 0.05 );

												// turn off cover disable
												SetSavedDvar( "cover_disable", "0" );
								}

								// player passed, save the game
								// level maps\_autosave::autosave_now( "montenegrotrain" );
								// level maps\_autosave::autosave_by_name( "montenegrotrain", 10.0 );
								// check the level var
								if( level.player.ledge_active == 0 )
								{
												// save the game
												level thread maps\_autosave::autosave_now( "montenegrotrain" );
								}

								// leave this function
								return;
				}

				// last check to make sure the player is at least north of the car that was uncoupled
				// the distance should be more than the check at the beginning of the level
				if( level.player.origin[1] > sbrush_unlinked.origin[1] )
				{
								// player passes because the player is up the y axis from the uncoupled car
								// clean up bodies function
								deleteallcorpses( 1 );

								// check to see if the timer is active
								if( isdefined( level.timer ) )
								{
												// kill the timer
												level notify( "kill_timer" );
								}

								// check to make sure the dvar for cover is enabled
								if( getdvar( "cover_disable" ) == "1" )
								{
												// turn off the no_cover function
												level notify( "stop_disable_cover" );

												// iprintlnbold( "disable cover" );

												// frame wait
												wait( 0.05 );

												// turn off cover disable
												SetSavedDvar( "cover_disable", "0" );
								}

								// player passed, save the game
								// level maps\_autosave::autosave_now( "montenegrotrain" );
								// level maps\_autosave::autosave_by_name( "montenegrotrain", 10.0 );
								// level thread train_ledge_check();
								if( level.player.ledge_active == 0 )
								{
												// save the game
												level thread maps\_autosave::autosave_now( "montenegrotrain" );
								}

								// leave this function
								return;
				}


				// wait
				wait( 0.5 );
				
				// if the player is still not touching either of these things what should be done?
				// iprintlnbold( "the player is still not touching one of two things!" );
				// mission failed
				MissionFailedWrapper();

}
//////////////////////////////////////////////////////////////////////////
// 08-22-08 WWilliams
// checks to see if the player is on a ledge, if not saves the game
train_ledge_check()
{
				// endon
				
				// check the level var
				if( level.player.ledge_active == 1 )
				{
								// wait a frame
								wait( 0.05 );
				}
				else
				{
								// save the game
								level thread maps\_autosave::autosave_now( "montenegrotrain" );
				}
}
//////////////////////////////////////////////////////////////////////////
// 07-22-08 WWilliams
// clean up all the cars that drop back after the first uncouple
// runs on level
freight_1st_uncouple_cleanup()
{
				// endon

				// objects to be defined for the function
				// freight cars should already be defined
				//level.freight_train[4]
				//level.freight_train[5]
				//level.freight_train[6]
				//level.freight_train[7]
				//level.freight_train[8]
				//level.freight_train[9]

				// wait for the notify that the first uncouple is complete
				level waittill( "1_uncouple_done" );

				// wait
				wait( 5.0 );

				// thread off the function for each car
				level thread freight_clean_off_single_car( level.freight_train[4] );
				level thread freight_clean_off_single_car( level.freight_train[5] );
				level thread freight_clean_off_single_car( level.freight_train[6] );
				level thread freight_clean_off_single_car( level.freight_train[7] );
				level thread freight_clean_off_single_car( level.freight_train[8] );
				level thread freight_clean_off_single_car( level.freight_train[9] );

}
//////////////////////////////////////////////////////////////////////////
// 07-22-08 WWilliams
// get all the ents that target the passed in ent
// runs on level
freight_clean_off_single_car( ent_car )
{
				// endon

				// double check defines
				//assertex( isdefined( ent_car ), "ent_car not defined" );

				// define every ent that is targeting the ent_car
				// triggers, script models, and fxanim models
				enta_stuff_oncar = getentarray( ent_car.targetname, "target" );
				// undefined
				ent_temp = undefined;

				// for loop goes through everything
				for( i=0; i<enta_stuff_oncar.size; i++ )
				{
								if( isdefined( enta_stuff_oncar[i] ) && enta_stuff_oncar[i].classname == "script_model" )
								{
												if( isdefined( enta_stuff_oncar[i] ) )
												{
																// delete each piece
																enta_stuff_oncar[i] delete();
												}

								}
								else if( isdefined( enta_stuff_oncar[i] ) && enta_stuff_oncar[i].classname == "script_origin" )
								{
												// grab what ever is targetting the script origin
												ent_temp = getent( enta_stuff_oncar[i].targetname, "target2" );

												// frame wait
												wait( 0.05 );

												if( isdefined( ent_temp ) )
												{
																// delete this thing
																ent_temp delete();
												}


												// double check the define
												if( isdefined( enta_stuff_oncar[i] ) )
												{
																// now delete the script org
																enta_stuff_oncar[i] delete();								
												}

												// undefine ent_temp
												ent_temp = undefined;

								}
								//else if( enta_stuff_oncar[i].classname == "light" )
								//{

								//}
								else
								{
												continue;
								}
				}

				// frame wait
				wait( 0.05 );

				// ent_car unlink
				ent_car unlink();

				// delete the car
				ent_car delete();
}
//////////////////////////////////////////////////////////////////////////
// 05-15-08
// wwilliams
// function uncouples the second car
// runs on level
train_second_uncouple()
{
				// endon
				level.player endon( "death" );

				// objects to be defined for the function
				// trigs
				use_trig = getent( "freight_uncouple_trigger", "targetname" );
				move_train3 = getent( "trig_move_train3", "targetname" );
				success_trig = getent( "trig_check_2nd_success", "targetname" );
				// s brush
				uncouple_lever = getent( "freight_uncouple_lever", "script_noteworthy" );
				brush_blocker = getent( "freight_box_blocker", "script_noteworthy" );
				// ents
				train_car = GetEnt( "freight4", "targetname" );
				wooden_box = getent( "freight_uncouple_crate", "script_noteworthy" );
				original_link = getent( uncouple_lever.target, "targetname" );
				// undefined
				push_away_vec = undefined;
				second_point = undefined;
				final_point = undefined;

				// sethintstring for trigger
				use_trig sethintstring( &"MONTENEGROTRAIN_UNCOUPLE_LEVER" );

				// wait for the player to hit the trigger
				use_trig waittill( "trigger" );

				// unset hint string
				use_trig sethintstring( "" );

				// unlink the trigger
				use_trig unlink();

				// turn off the trigger
				use_trig thread maps\_utility::trigger_off();

				// clean dead people
				deleteallcorpses( 1 );
				
				// setup the guys to react if alive
				level thread second_uncouple_alive_link();

				// unlnk the level
				uncouple_lever unlink();

				// move the lever
				uncouple_lever rotateyaw( 180, 1.0 );

				//Steve G
				uncouple_lever playsound("uncoupling_lever");

				// wait for the move to finish
				uncouple_lever waittill( "rotatedone" );

				// linkt he lever back to it's original target
				uncouple_lever linkto( original_link );

				// play the uncouple fxanim
				level notify( "knuckle_release_release_start" );

				// earthquake the uncoupling
				earthquake( 0.7, 1.2, level.player.origin, 512 );
				
				// DCS: don't allow Quick kill again till uncoupled train well away.(22525)
				thread disallow_quick_kill();

				//Steve G
				freight_coupling_2_org_var = getent("freight_coupling_2_org", "targetname");
				if( isdefined( freight_coupling_2_org_var ) )
				{
								freight_coupling_2_org_var playsound("freight_coupler_2");
								//iprintlnbold( "KA-CHUNK");
				}	

				// play the animation
				level notify( "box_fall_start" );
				
				// Steve G - Play box fall sound
				level.player playsound("freight_crate_fall_02");

				// quick wait
				wait( 1.0 );

				// check to make sure the thing is defined
				if( isdefined( train_car ) )
				{
								// unlink the brush_blocker
								brush_blocker unlink();

								// delete the brush_blocker
								brush_blocker delete();

								// unlink the train
								train_car unlink();

								// delete the ledge brushes
								level thread train_second_uncouple_ledge_crawl_remove();

								//Steve G
								level.player playsound("uncouple_big_shake_01");

								// define car four to check against
								freight_car_4_trig = getent( "uncouple2_disable_cover", "targetname" );

								// function disables cover until the player is off the car that is falling back
								level thread wrong_car_no_cover( freight_car_4_trig );

				}
				else
				{
								// debug text
								iprintlnbold( train_car.targetname + " is not defined!" );

								// end func
								return;
				}

				// clean up function for these cars
				level thread freight_2nd_uncouple_cleanup();

				//// Move train back to see failure.	
				// train_car moveto( level.freight_train_end.origin, 40, 5, 0 );
				train_car thread train_car_fall_back( level.freight_train_end.origin, "2_uncouple_done" );

				// second uncouple for sure save
				level thread second_uncouple_save();

				// check to see if the player made the jump
				level train_player_made_jump( getent( "freight4", "targetname" ), getent( "freight3", "targetname" ), getent( "trig_check_2nd_success", "targetname" ) );

				// need to check to make sure the player is in the right place
				// locking the player in place now
				// start conversation with Tanner
				// line one - tanner
				level.player play_dialogue( "TANN_TraiG_046A", true );

				// line two - Bond
				level.player play_dialogue( "BOND_GlobG_105A" );

				// save game
				level thread maps\_autosave::autosave_by_name( "montenegrotrain", 10.0 );

				// line three - tanner
				// level.player play_dialogue_nowait( "TANN_TraiG_045A", true );

}
///////////////////////////////////////////////////////////////////////////
// 08-26-08 WWilliams
// remove the ladder brushes from the ledge crawl
train_second_uncouple_ledge_crawl_remove()
{
				// endon

				// objects to define for this function
				enta_ledge_crawl_brushes = getentarray( "ladder_ledge_crawl", "script_noteworthy" );

				// frame wait
				wait( 0.05 );

				// double check the define
				assertex( isdefined( enta_ledge_crawl_brushes ), "enta_ledge_crawl_brushes not defined" );

				// for loop goes through the brushes and deletes them`
				for( i=0; i<enta_ledge_crawl_brushes.size; i++ )
				{
								// unlink the brush
								enta_ledge_crawl_brushes[i] unlink();

								// frame wait
								wait( 0.05 );

								// delete the brush
								enta_ledge_crawl_brushes[i] delete();
				}

				// debug text
				// iprintlnbold( "done deleting ledge brushes" );

}
///////////////////////////////////////////////////////////////////////////


disallow_quick_kill()
{
	setsaveddvar("bg_quick_kill_enabled", false);
	//iprintlnbold("NO quick kills allowed");

	//DCS. once uncoupled train finished and away reallow quick kills.
	level waittill("stop_disable_cover");
	setsaveddvar("bg_quick_kill_enabled", true);
	//iprintlnbold("quick kills OK");
}	
//////////////////////////////////////////////////////////////////////////
// 07-22-08 WWilliams
// clean up all the cars that drop back after the first uncouple
// runs on level
freight_2nd_uncouple_cleanup()
{
				// endon

				// objects to be defined for the function
				// freight cars should already be defined
				//level.freight_train[4]
				//level.freight_train[5]
				//level.freight_train[6]
				//level.freight_train[7]
				//level.freight_train[8]
				//level.freight_train[9]

				// wait for the notify that the first uncouple is complete
				level waittill( "2_uncouple_done" );

				// wait
				// wait( 5.0 );

				// thread off the function for each car
				level thread freight_clean_off_single_car( level.freight_train[3] );


}
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
// 05-19-08
// wwilliams
// will take in an ent, should be a train car, and a vector
// then will move the ent down the y axis twice before sending it to the vector supplied
// will send out a notify when the moveto the vector happens
// runs on self/train car
train_car_fall_back( vec_final_point, str_notify )
{
				// endon
				level.player endon( "death" );

				// objects to define for this function
				// int
				int_loops = 0;
				// double check the things that needed to be passed in

				// vec_final_position
				//assertex( isdefined( vec_final_point ), "train_car_fall_back missing vec_final"  );

				// set a default str_notify
				if( !isdefined( str_notify ) )
				{
								// set it to something
								str_notify = "train_car_away";
				}

				// 07-19-08 WWilliams
				// move the object down a bit at a time
				//while( int_loops < 3 )
				//{
				//				// move it slowly away
				//				self moveto( self.origin + ( 0, -2, 0 ), 0.5 );

				//				// wait for the move
				//				self waittill( "movedone" );

				//				// increase int_loops
				//				int_loops++;
				//}

				// now send the train_car to the vec_final_point
				self moveto( vec_final_point, 50.0, 25.0 );

				// wait five seconds
				self waittill( "movedone" );

				// send out the notify
				level notify( str_notify );

}
///////////////////////////////////////////////////////////////////////////////
// 04-26-08
// wwilliams
// outside effects setup and init
outside_train_init()
{
				// endon
				// single shot func, not needed

				// objects to be defined for the func
				// none

				// setup the trigs that watch the player's position
				level thread inside_trigger_init();

				// frame wait to allow the trigger init to setup
				wait( 0.1 );

				// train materials wet
				level thread train_materials_wet();

				// now start the functions that blur and cause wind
				level thread train_blur_control();

				// controls the wind for the level
				level thread train_wind_control();

				// disable sprinting when outside
				level thread train_no_sprint();

}
///////////////////////////////////////////////////////////////////////////////
// 04-26-08
// wwilliams
// inside trigger init, gets all the trigs that watch the player position
inside_trigger_init()
{
				// endon
				// single shot function
				level.player endon( "death" );

				// objects to be defined for the func
				// trigger array
				enta_trig_playerinside = getentarray( "trig_player_inside", "targetname" );

				// make sure the array is defined
				if( isdefined( enta_trig_playerinside ) )
				{
								// while loop to constantly check the array
								while( 1 )
								{
												// go through each one in teh array
												for( i=0; i<enta_trig_playerinside.size; i++ )
												{
																// check to see if the player is touching any of these triggers
																if( level.player istouching( enta_trig_playerinside[i] ) )
																{
																				// clear the flag
																				flag_clear( "outside_train" );

																				// 04-239-08
																				// wwilliams
																				// while loop waits for the player to no longer be touching the trigger
																				while( level.player istouching( enta_trig_playerinside[i] ) )
																				{
																								// wait
																								wait( 0.05 );
																				}
																}

																// set the flag
																flag_set( "outside_train" );
												}

												// wait to avoid infinite script loop
												wait( 0.1 );
								}
				}
				else
				{
								//debug text
								iprintlnbold( "enta_trig_playerinside, not defined!" );

								// end function
								return;
				}
}
///////////////////////////////////////////////////////////////////////////
// 08-25-08 WWilliams
// turns on and off the wet materials for the guns and models
train_materials_wet()
{
				// endon
				level endon( "train_end_wet_materials" );

				// while loop
				while( 1 )
				{
								// frame wait
								wait( 0.05 );

								// while the player is on the freight train
								while( !maps\_utility::flag( "outside_train" ) )
								{
												// turn off wetmaterials
												materialsetwet( 0 );

												// iprintlnbold( "wet off" );
												while( !maps\_utility::flag( "outside_train" ) )
												{
																// wait in case the outside is already set
																wait( 0.05 );
												}

												// wait in case the outside is already set
												wait( 0.05 );
								}

								// frame wait
								wait( 0.05 );

								// while the player is outside the train 
								while( maps\_utility::flag( "outside_train" ) )
								{
												// turn off wetmaterials
												materialsetwet( 1 );

												// iprintlnbold( "wet on" );

												while( maps\_utility::flag( "outside_train" ) )
												{
																// wait
																wait( 0.05 );
												}

												// wait
												wait( 0.05 );
								}

								// frame wait to avoid potential infinite
								wait( 0.05 );
				}
}
///////////////////////////////////////////////////////////////////////////
// 04-26-08
// wwilliams
// runs on a trigger
// will check to see if the player is touching a trigger
// then will change the "outside_train" flag
train_player_touching()
{	
				// endon
				// should have no end on
				level.player endon( "death" );

				// constant while loop
				// gotta keep an eye on this
				while( 1 )
				{
								// check to see if the player is touching
								if( level.player istouching( self ) )
								{
												if( flag( "outside_train" ) )
												{
																// remove the flag because the player is inside a trig
																flag_clear( "outside_train" );

																iprintlnbold( "cleared_outside_train" );
												}

												// wait to avoid infinite script loop
												wait( 0.1 );

								}
								else
								{
												if( !flag( "outside_train" ) )
												{

												}
												// set the flag
												flag_set( "outside_train" );

												// wait to avoid infinite script loop
												wait( 0.1 );
								}
								// wait to avoid infinite script loop
								wait( 0.1 );

				}

}
///////////////////////////////////////////////////////////////////////////////
// 04-26-08
// wwilliams
// causes wind while outside the train
train_wind_control()
{
				// endon
				// should end with the level
				// maybe at the boss fight
				level.player endon( "death" );

				// objects to be defined for the func
				// dvars
				// setdvar( "setwind", ( 0, 200, 0 ) );
				// 05-15-08
				// wwilliams
				// now going to change the speed of the wind based on the player's stance
				// so this will be set in the check for the flag
				// level.player setwind( 0, -30 );

				// constant while
				while( 1 )
				{
								// turn off the wind
								setsaveddvar( "wind_movementEnabled", 0 );
								// debug text
								// iprintlnbold( "wind_off" );

								//check to see if the flag is set
								while( !maps\_utility::flag( "outside_train" ) )
								{
												// wait to avoid infinite script loop
												wait( 0.1 );
								}

								// change the dvar to true
								setsaveddvar( "wind_movementEnabled", 1 );
								// debug text
								// iprintlnbold( "wind_on" );

								// while the flag is true the loop will check for the player's stance
								while( maps\_utility::flag( "outside_train" ) )
								{
												// check the player's stance
												if( level.player getstance() == "stand" )
												{
																// turn off the wind
																// level.player setwind( 0, 0 );

																// DCS: keep wind low if uncoupling timed event.
																if(level.clock_running == true)
																{
																	//iprintlnbold("reduced wind event");
																	level.player setwind( 0, -20 );
																}	
																if(level.standard_background == false) // In tunnel
																{
																	level.player setwind( 0, -30 );
																}	
																else
																{
																	// set the wind to 25
																	level.player setwind( 0, -55 );
																}
																// debug text
																// iprintlnbold( "player standing, changed wind" );

																// quick wait
																wait( 0.05 );

												}
												// check to see if the player is crouching
												if( level.player getstance() == "crouch" )
												{
																// turn off the wind
																// level.player setwind( 0, 0 );

																// set the wind lower, to ten for now
																// might need to go to five
																level.player setwind( 0, -20 );

																// debug text
																// iprintlnbold( "player crouched, changed wind" );

																// quick wait
																wait( 0.05 );

												}

												// wait to avoid infinite script loop
												wait( 0.05 );
								}
				}
}
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// 04-26-08
// wwilliams
// watches the flag that shows if the player is outside/inside
train_blur_control()
{
				// endon
				// should end with the level
				level.player endon( "death" );

				// objects to be defined for this function
				// dvars, set the dvars for the level
				setdvar( "r_motionblur_dist", 420 );
				setdvar( "r_motionblur_maxBlurAmt", 8 );
				setdvar( "r_motionblur_farStart", 1750 );
				setdvar( "r_motionblur_farEnd", 3000 );
				setdvar( "r_motionblur_nearStart", 350 );
				setdvar( "r_motionblur_nearEnd", 450 );
				setdvar( "r_motionblur_envMotionVector", "1 10 1" );

				// while loop
				// constantly true
				while( 1 )
				{
								// watch for the interior flag
								if( !maps\_utility::flag( "outside_train" ) )
								{
												// change dvars to disable blur
												setdvar( "r_motionblur_enable", 0 );

												// debug text
												// iprintlnbold( "blur_off" );

												// wait a frame, avoids infinite script loop
												wait( 0.1 );
								}

								// watch for the exterior flag
								if( maps\_utility::flag( "outside_train" ) )
								{
												// change dvar to enable blur
												setdvar( "r_motionblur_enable", 1 );

												// debug text
												// iprintlnbold( "" + flag( "outside_train" ) + "" );

												// wait a frame, avoids infinite script loop
												wait( 0.1 );
								}

				}

}
///////////////////////////////////////////////////////////////////////////
// 07-21-08 WWilliams
// function changes the vision sets according to where the player is
// loops
// runs on level
train_vision_sets()
{
				// endon
				// level endon( "tunnel_vision_set" );
				level endon( "boss_fight_start" );
				
				// objects to define for this function
				// variables
				int_inside = 0;
				int_outside = 0;

				// while loop continuously loops
				while( 1 )
				{
								// when the player is inside but not on the freight
								while( !maps\_utility::flag( "outside_train" ) && !maps\_utility::flag( "on_freight_train" ) )
								{
												// check the local variable, if inside is set to false then
												if( int_inside == 0 )
												{
																// change the vision set
																VisionSetNaked( "MontenegroTrain_in", 0.5 );

																// frame wait
																wait( 0.6 );

																// debug text
																//iprintlnbold( "interior vision set" );

																// set inside just in case
																int_inside = 1;
																int_outside = 0;
												}

												// wait
												wait( 0.2 );
								}

								while( maps\_utility::flag( "outside_train" ) && level.standard_background == 0 )
								{
												// check the local variable, if inside is set to false then
												if( int_outside == 0 )
												{
																// change the vision set
																VisionSetNaked( "MontenegroTrain_tunnel", 0.5 );

																// frame wait
																wait( 0.6 );

																// debug text
																//iprintlnbold( "exterior vision set" );

																// set inside just in case
																int_inside = 0;
																int_outside = 1;
												}

												// wait
												wait( 0.2 );
								}

								// while the player is on the freight train
								while( maps\_utility::flag( "on_freight_train" ) )
								{
												// check the local var
												if( int_outside == 0 )
												{
																// change the vision set
																VisionSetNaked( "MontenegroTrain", 0.5 );

																// frame wait
																wait( 0.6 );

																// debug text
																//iprintlnbold( "exterior vision set" );

																// set inside just in case
																int_inside = 0;
																int_outside = 1;
												}

												// wait in case the outside is already set
												wait( 0.2 );
								}

								// while the player is outside the train 
								while( maps\_utility::flag( "outside_train" ) && level.standard_background == 1 )
								{
												// check the local variable, if inside is set to false then
												if( int_outside == 0 )
												{
																// change the vision set
																VisionSetNaked( "MontenegroTrain", 0.5 );

																// frame wait
																wait( 0.6 );

																// debug text
																//iprintlnbold( "exterior vision set" );

																// set inside just in case
																int_inside = 0;
																int_outside = 1;
												}

												// wait
												wait( 0.2 );
								}

								// frame wait to avoid potential infinite
								wait( 0.05 );
				}
}
///////////////////////////////////////////////////////////////////////////////
// 07-23-08 WWilliams
// function disables sprinting while outside
train_no_sprint()
{
				// endon

				// objects to define for this function
				// variables
				int_inside = 0;
				int_outside = 0;

				// while loop continuously loops
				while( 1 )
				{
								// when the player is inside set this vision set
								while( flag( "outside_train" ) == 0 )
								{
												// check the local variable, if inside is set to false then
												if( int_inside == 0 )
												{
																// change sprint dvars - false
																SetSavedDVar( "cover_dash_fromCover_enabled", true );
																SetSavedDVar( "cover_dash_from1stperson_enabled", true );
																SetDVar( "player_sprintEnabled", "1" );

																// frame wait
																wait( 0.6 );

																// debug text
															 // iprintlnbold( "sprint to true" );

																// set inside just in case
																int_inside = 1;
																int_outside = 0;
												}

												// wait
												wait( 0.2 );
								}

								while( flag( "outside_train" ) == 1 )
								{
												// check the local variable, if inside is set to false then
												if( int_outside == 0 )
												{
																// change sprint dvars - true
																SetSavedDVar( "cover_dash_fromCover_enabled", false );
																SetSavedDVar( "cover_dash_from1stperson_enabled", false );
																SetDVar( "player_sprintEnabled", "0" );

																// frame wait
																wait( 0.6 );

																// debug text
																// iprintlnbold( "sprint to false" );

																// set inside just in case
																int_inside = 0;
																int_outside = 1;
												}

												// wait
												wait( 0.2 );
								}

								// frame wait to avoid potential infinite
								wait( 0.05 );
				}

}
///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// 05-07-08
// wwilliams
// linking all the script models to the freight train prefab
// runs on level
// 05-15-08
// wwilliams
// commenting this out, i just piggy back don's stuff now
///////////////////////////////////////////////////////////////////////////////
/*ftrain_model_link()
{
// endon
// single shot function

// objects to be defined for the function
// script_model
// 05-15-08
// making this a level ent array so I can call it later with the other freight train stuff
level.enta_freight_smodels = getentarray( "freight_train_models", "targetname" );
// undefined
temp_ent = undefined;

// check that all the models have a target
for( i=0; i<enta_freight_smodels.size; i++ )
{
// check to see that each model has a target
//assertex( isdefined( enta_freight_smodels[i].target ),"" + enta_freight_smodels[i].origin + " missing target" );
}

// debug text
// how many models are there?
// iprintlnbold( enta_freight_smodels.size );

// now go through the array and link them
for( i=0; i<enta_freight_smodels.size; i++ )
{
// quick define the target
temp_ent = getent( enta_freight_smodels[i].target, "targetname" );

// link the model to the target
enta_freight_smodels[i] linkto( temp_ent );

// quick wait
wait( 0.5 );

// undefine temp_ent for next rotation
temp_ent = undefined;

}

// debug text, finished with linking
// iprintlnbold( "done linking models to freight" );

}*/
///////////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
// 05-08-08
// wwilliams
// funciton grabs all the damage triggers on the roof and runs a thread
// on each one in order for sound to grab when the player is being damaged by them
// runs on level
train_elec_pylon_init()
{
				// endon
				// single shot func
				level.player endon( "death" );

				// objects to be defined for the function
				// trigger array
				enta_elec_pylon_dmg_trigs = getentarray( "conduit_damage", "targetname" );

				// debug text
				// tell me how many there are
				// iprintlnbold( "elec_pylon_amount: " + enta_elec_pylon_dmg_trigs.size + "" );

				// for loop goes through each one
				for( i=0; i<enta_elec_pylon_dmg_trigs.size; i++ )
				{
								// run a function on each trigger
								enta_elec_pylon_dmg_trigs[i] thread train_elec_pylon_sound();

								// quick wait
								wait( 0.5 );
				}

}
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
// 05-08-08
// wwilliams
// waits for the damage trigger to receive a trigger notify
// then plays the sound for steve
// runs on self/damage trig
//////////////////////////////////////////////////////////////////////////
train_elec_pylon_sound()
{
				// endon
				level.player endon( "death" );
				// need an endon for the end of the level

				// while loop constant check
				while( 1 )
				{
								// check to see if the player is touching self
								if( level.player istouching( self ) )
								{
												// play the sound here I guess off of trigger/self
												// notify
												level notify( "player_touching_elec_pylon" );

												// Steve G
												//iprintlnbold( "player touching elec trig!" );
												self playsound("electric_shock");
												wait( 0.5 );
								}

								// wait to keep the infinite script loop demon away
								wait( 0.5 );
				}
}
//////////////////////////////////////////////////////////////////////////
// 05-10-08
// wwilliams
// function waits for a flag then makes NPC shoot at the player
// used to swing the doors open on the player after the first freight
// fight
// runs on self/NPC
freight_boxcar_door_surprise()
{
				// endon
				self endon( "death" );
				level.player endon( "death" );

				// wait for a flag
				level flag_wait( "car4_boxcar_surprise" );

				// make self shoot at the player
				// will need to change this to shoot straight and over the player
				self cmdshootatentity( level.player, true, 6.0, 0.2 );

				// set the guy up properly
				self setenablesense( true );
				self setcombatrole( "turret" );
				self setengagerule( "tgtSight" );
				self addengagerule( "tgtPerceive" );
				self addengagerule( "Damaged" );
				self addengagerule( "Attacked" );

}
//////////////////////////////////////////////////////////////////////////
// 05-27-08
// wwilliams
// functon displays the card and picture during the intro cutscene
intro_card_n_pic()
{
				// endon
				level.player endon( "death" );

				// frame wait
				wait( 0.05 );

				// spawn a script origin
				// 05-27-08
				// wwilliams
				// commenting out the attach/detach stuff cause the new bond is missing tags
				// level.cutscene_tag = spawn( "script_model", level.player gettagorigin( "TAG_WEAPON_RIGHT" ) );

				// iprintlnbold( "" + level.player gettagorigin( "TAG_WEAPON_RIGHT" ) + "" );

				wait( 0.05 );

				// if( spawn_failed( level.cutscene_tag ) )
				// {
								// debut text
								// iprintlnbold( "cutscene_tag failed" );
				// }

				level.move_intro_scr = true;

				// trying to link the level.cut_scene again
				// level.cutscene_tag linkto( level.player, "TAG_WEAPON_RIGHT", ( 0, 0, 0 ), ( 0, 0, 0 ) );

				// level.bizcard linkto( level.player, "TAG_WEAPON_RIGHT", ( 0, 0, 0 ), ( 0, 0, 0 ) );
				// show the card
				// level.bizcard show();
				// attach the model to the tag
				// 05-27-08
				// wwilliams
				// commenting out the attach/detach stuff cause the new bond is missing tags
				level.player attach( "p_igc_vesper_business_card", "TAG_WEAPON_RIGHT" );

				// run the func
				// level thread maps\MontenegroTrain_util::update_cutscene_org();

				// wait a frame to make sure
				wait( 0.05 );


				// wait for the first notify
				level.player waittillmatch( "anim_notetrack", "lightning_flash" );
				// iprintlnbold( "lighting_flash" );

				// wait for second notify
				level.player waittillmatch( "anim_notetrack", "bizcard_show" );

				// show the model on the tag
				// linkto didn't work
				// level.cutscene_tag setmodel( "p_igc_vesper_business_card" );

				// wait for the third notify
				level.player waittillmatch( "anim_notetrack", "bizcard_hide" );

				// hide the model
				// level.bizcard hide();
				// detach the model to the tag
				// 05-27-08
				// wwilliams
				// commenting out the attach/detach stuff cause the new bond is missing tags
				level.player detach( "p_igc_vesper_business_card", "TAG_WEAPON_RIGHT" );
				
				// frame wait
				wait( 0.05 );

				// hide the model on the tag
				// level.cutscene_tag hide();
				// hide the bizcard
				// level.bizcard hide();
				level.bizcard delete();

				// frame wait
				wait( 0.05 );

				// attach the photo
				// 05-27-08
				// wwilliams
				// commenting out the attach/detach stuff cause the new bond is missing tags
				level.player attach( "p_igc_bliss_headshot", "TAG_WEAPON_RIGHT" );

				// change the model so I just have to show it after next notify
				// linkto didn't work
				// level.cutscene_tag setmodel( "p_igc_bliss_headshot" ); 

				// wait for the fourth notify
				level.player waittillmatch( "anim_notetrack", "photo_show" );
				// 05-27-08
				// wwilliams
				// commenting out the attach/detach stuff cause the new bond is missing tags
				level.bliss_pic show();

				// show the model
				// level.cutscene_tag show();

				// wait for the last match
				level.player waittillmatch( "anim_notetrack", "photo_release" );

				// detach
				// 05-27-08
				// wwilliams
				// commenting out the attach/detach stuff cause the new bond is missing tags
				level.player detach( "p_igc_bliss_headshot", "TAG_WEAPON_RIGHT" );

				// hide and remove the pic
				level.bliss_pic hide();

				// need to spawn a picture on the table at this point

				level waittill( "MT_TR_Intro_done" );

				// send out a notify
				level notify( "intro_model_attach" );

				// frame wait
				wait( 0.05 );

				// unlink the model
				// level.cutscene_tag unlink();

				// wait
				wait( 1.0 );

				// get rid of it
				// level.cutscene_tag delete();
}
//////////////////////////////////////////////////////////////////////////
// 05-27-08
// wwilliams
// updates the cutscene origin every frame, working around SRE
// 06-05-08
// wwilliams
// commenting this out, not needed
/* update_cutscene_org()
{
// endon
level.player endon( "death" );
level endon( "intro_model_attach" );

// objects to be defined
temp_vector = undefined;

// while loop
while( level.move_intro_scr == true )
{
// get the tag's origin
temp_vector = level.player gettagorigin( "TAG_WEAPON_RIGHT" );

// move the cutscene org
level.cutscene_tag.origin = temp_vector + ( 0, 0, 20 );

// wait a frame
wait( 0.05 );
}

// clean up the script origin

}*/
//////////////////////////////////////////////////////////////////////////
// function controls which objective is shown on the phone
// runs on level
train_objectives()
{
				// endon
				level.player endon( "death" );

				// objects to be defined for this function
				// obj_positions
				// obj one
				obj_1a = getent( "so_train_obj_1a", "script_noteworthy" ); // at the foot of the stairs in car 1
				obj_1b = getent( "so_train_obj_1b", "script_noteworthy" ); // near the electric pylon on top of ceiling glass car
				obj_1c = getent( "so_train_obj_1c", "script_noteworthy" ); // near the mouth of the blue continaer the player jumps to
				// obj 2
				obj_2a = getent( "so_train_obj_2a", "script_noteworthy" ); // at boxcar surprise door
				obj_2b = getent( "so_train_obj_2b", "script_noteworthy" ); // near exit door of trap container car
				obj_2c = getent( "so_train_obj_2c", "script_noteworthy" ); // right before ledge walk
				obj_2d = getent( "so_train_obj_2d", "script_noteworthy" ); // at box drop door, after 2nd uncouple
				// obj 3
				obj_3a = getent( "so_train_obj_3a", "script_noteworthy" ); // at the exit door to the cattle car
				obj_3b = getent( "so_train_obj_3b", "script_noteworthy" ); // at the jump back to the pass. train spot
				// obj 4
				obj_4a = getent( "so_train_obj_4a", "script_noteworthy" ); // at the end of the first baggage car
				obj_4b = getent( "so_train_obj_4b", "script_noteworthy" ); // at the locked door in third baggage car
				// obj 5
				obj_5 = getent( "so_train_obj_5", "script_noteworthy" ); // right before the ladder drop into bliss's car
				// obj 6
				obj_6a = getent( "so_train_obj_6a", "script_noteworthy" ); // where Bliss is standing before running off
				obj_6b = getent( "so_train_obj_6b", "script_noteworthy" ); // the ladder bliss escapes to the roof with
				
				
				// double check defines
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
				

				// check to see if the first objective is set
				// if it isn't go inside this function
				if( !flag( "train_obj_1" ) )
				{
								// set up the objective
								objective_add( 1, "current", &"MONTENEGROTRAIN_OBJ_1_TITLE", obj_1a.origin, &"MONTENEGROTRAIN_OBJ_1_BODY" );

								// wait for the player to get close
								while( distancesquared( level.player.origin, obj_1a.origin ) > 35*35 )
								{
												// wait
												wait( 0.1 );
								}

								// switch to the next objective marker
								objective_position( 1, obj_1b.origin );

								// wait for the player to get close
								while( distancesquared( level.player.origin, obj_1b.origin ) > 60*60 )
								{
												// wait
												wait( 0.1 );
								}

								// switch to the next objective marker
								objective_position( 1, obj_1c.origin );

								// wait for the player to get close
								while( distancesquared( level.player.origin, obj_1c.origin ) > 200*200 )
								{
												// wait
												wait( 0.1 );
								}

								// objective state to complete
								objective_state( 1, "done" );

								// objective complete
								flag_set( "train_obj_1" );
				}

				// check to see if the second objective is set
				if( !flag( "train_obj_2" ) )
				{
								// set up the objective
								objective_add( 1, "current", &"MONTENEGROTRAIN_OBJ_2_TITLE", obj_2a.origin, &"MONTENEGROTRAIN_OBJ_2_BODY" );

								// clean up 

								// wait for the player to get close
								while( distancesquared( level.player.origin, obj_2a.origin ) > 200*200 )
								{
												// wait
												wait( 0.1 );
								}

								// update the position of the marker
								objective_position( 1, obj_2b.origin );

								// wait for the player to get close
								while( distancesquared( level.player.origin, obj_2b.origin ) > 150*150 )
								{
												// wait
												wait( 0.1 );
								}

								// update the position
								objective_position( 1, obj_2c.origin );

								// wait for the player to get close
								while( distancesquared( level.player.origin, obj_2c.origin ) > 70*70 )
								{
												// wait
												wait( 0.1 );
								}

								// update the position
								objective_position( 1, obj_2d.origin );

								// wait for the player to get close
								while( distancesquared( level.player.origin, obj_2d.origin ) > 40*40 )
								{
												// wait
												wait( 0.1 );
								}

								// objective state to complete
								objective_state( 1, "done" );

								// objective complete
								flag_set( "train_obj_2" );

				}

				// check to see if the third objective is set
				if( !flag( "train_obj_3" ) )
				{
								// set up the objective
								objective_add( 1, "current", &"MONTENEGROTRAIN_OBJ_3_TITLE", obj_3a.origin, &"MONTENEGROTRAIN_OBJ_3_BODY" );

								// wait for the player to get close enough
								while( distancesquared( level.player.origin, obj_3a.origin ) > 70*70 )
								{
												// wait
												wait( 0.1 );
								}

								// update the objective position
								objective_position( 1, obj_3b.origin );

								// wait for the player to finish the jump back to the passenger train
								level waittill( "Train_Bond_Jump_done" );

								// objective state to complete
								objective_state( 1, "done" );

								// objective complete
								flag_set( "train_obj_3" );
								
				}

				// check to see if the fourth objective is set
				if( !flag( "train_obj_4" ) )
				{
								// set up the objective
								objective_add( 1, "current", &"MONTENEGROTRAIN_OBJ_4_TITLE", obj_4a.origin, &"MONTENEGROTRAIN_OBJ_4_BODY" );
								
								// wait for the player to get close enough
								while( distancesquared( level.player.origin, obj_4a.origin ) > 90*90 )
								{
												// wait
												wait( 0.1 );
								}

								// update the objective position
								objective_position( 1, obj_4b.origin );

								// wait for notify from the lock door
								level waittill( "baggage_car_locked" );

								// objective state to complete
								objective_state( 1, "done" );

								// objective complete
								flag_set( "train_obj_4" );
				}

				// check to see if the fifth objective is set
				if( !flag( "train_obj_5" ) )
				{
								// set up the objective
								objective_add( 1, "current", &"MONTENEGROTRAIN_OBJ_5_TITLE", obj_5.origin, &"MONTENEGROTRAIN_OBJ_5_BODY" );

								// wait for the player to get close enough
								while( distancesquared( level.player.origin, obj_5.origin ) > 80*80 )
								{
												// wait
												wait( 0.1 );
								}

								// objective state to complete
								objective_state( 1, "done" );

								// objective complete
								flag_set( "train_obj_5" );
				}

				// check to see if the sixth objective is set
				if( !flag( "train_obj_6" ) )
				{
								// set up the objective
								objective_add( 1, "current", &"MONTENEGROTRAIN_OBJ_6_TITLE", obj_6a.origin, &"MONTENEGROTRAIN_OBJ_6_BODY" );

								// wait for player to get close
								while( distancesquared( level.player.origin, obj_6b.origin ) > 65*65 )
								{
												// wait
												wait( 0.1 );
								}

								// update to the next spot
								objective_position( 1, obj_6b.origin );

								// wait for player to finish bliss
								level waittill( "bliss_defeated" );

								// objectives complete
								objective_state( 1, "done" );

								// objective complete
								flag_set( "train_obj_6" );
				}
}
///////////////////////////////////////////////////////////////////////////
train_tanner_talks_freight()
{
				// endon
				// single shot function

				// play dialogue for tanner telling bond about the freight
				level.player play_dialogue( "TANN_TraiG_029A", true );
				
				// Steve G - Train Horn
				thread Maps\MontenegroTrain_snd::play_freight_train_horn();

				// thread off the achievement function
				level thread train_challenge_achievement();
}
///////////////////////////////////////////////////////////////////////////
train_challenge_achievement()
{
				// endon
				// single shot function

				// objects to define for this function
				// undefined;
				str_weapon = undefined;

				// wait for the freight train flag to set
				level flag_wait( "on_freight_train" );

				// while on_freight_train is true
				while( flag( "on_freight_train" ) )
				{
								// check the player's weapon
								str_weapon = level.player GetCurrentWeapon();

								if( str_weapon == "p99_wet_s" || str_weapon == "p99_wet" || str_weapon == "none" || str_weapon == "phone" )
								{
												// debug text
												// iprintlnbold( "player has p99 out" );

												wait( 0.05 );
								}
								else if( str_weapon != "p99_wet_s" || str_weapon != "p99_wet" || str_weapon != "none" || str_weapon != "phone" )
								{
												// check to see if the player presses the attackbutton
												if( level.player attackButtonPressed() )
												{
																// debug text
																// iprintlnbold( "player fired other weapon" );
																
																// end the function
																return;
												}

												// wait
												wait( 0.05 );

												// iprintlnbold( "wrong weapon, but not fired!" );
								}
				}

				// if it came out of this while without exiting then the player should
				// get the achievement
				GiveAchievement( "Challenge_Train" );
}
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// AI functions
// Misc funcs that controls small parts of AI logic for train
///////////////////////////////////////////////////////////////////////////
// wwilliams 07-01-08
// func perfect sense for an amount of time
// then disables perfect sense
// runs on self/NPC
turn_on_sense( int_time )
{
				// endon
				self endon( "death" );

				// overload on the int_time
				if( !isdefined( int_time ) )
				{
								int_time = 3;
				}

				if( isalive( self ) )
				{
								// turn on perfect sense
								self setperfectsense( true );
				}

				// wait
				wait( int_time );

				// check to see if he is defined and alive
				if( IsDefined( self ) && isalive( self ) )
				{
								// turn off perfect sense
								self setperfectsense( false );

				}           
}
///////////////////////////////////////////////////////////////////////////
// wwilliams 07-01-08
// function makes an ai sprint to goal
// then resets the script speed upon goal
// also sets enagage rules in case the player gets to close
// runs on self/NPC
sprint_to_goal()
{
				// endon
				self endon( "death" );

				// set engagerules so guys don't just run pass the player
				self setengagerule( "tgtSight" );
				self addengagerule( "tgtPerceive" );
				self addengagerule( "Damaged" );
				self addengagerule( "Attacked" );

				// change the speed
				self setscriptspeed( "sprint" );

				// wait for goal
				self waittill( "goal" );

				// change speed back to run
				self setscriptspeed( "default" );

}
///////////////////////////////////////////////////////////////////////////
// wwilliams 07-01-08
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
								// wait
								wait( 0.05 );
				}

				// change the script speed to default
				self setscriptspeed( "default" );

}
///////////////////////////////////////////////////////////////////////////
// wwilliams 07-01-08
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
///////////////////////////////////////////////////////////////////////////
// wwilliams 07-01-08
// play dialogue on a guy
// runs on self/NPC
train_play_dialogue( str_SoundFile )
{
				// endon
				self endon( "death" );

				// play the dialogue
				self play_dialogue( str_SoundFile );
}
///////////////////////////////////////////////////////////////////////////
// WW 07-03-08
// brings out the player's gun once on the roof of the train
// trying to stop a crash that can happen
train_bring_up_gun()
{
				// endon
				// single shot function

				// defined objects for this function
				// trig
				trig = getent( "roof_start", "targetname" );

				// double check define
				//assertex( isdefined( trig ), "trig is not defined!" );

				// wait for teh trig
				trig waittill( "trigger" );

				// extra wait to lock the door behind teh player
				wait( 1.0 );

				// unholster weapon
				maps\_utility::unholster_weapons();

				wait( 0.05 );

				//level.player switchtoWeapon("p99_wet_s");

				// remove the civs once the player is stuck outside car1
				level thread maps\MontenegroTrain_car3::remove_train1_civilians();
}
///////////////////////////////////////////////////////////////////////////
// 07-17-08 WWilliams
// func changes speed back to default at goal
// also tethers ai to spot at goal and sets the tether
// runs on self
train_goal_n_tether( str_node, int_tether_dist )
{
				// endon
				self endon( "death" );

				// double check what was passed in
				//assertex( isdefined( str_node ), "str_node not defined" );
				//assertex( isdefined( int_tether_dist ), "int_tether_dist not defined" );

				// wait for goal
				self waittill( "goal" );

				// reset script speed
				self setscriptspeed( "default" );

				// set the tether point
				self.tetherpt = str_node.origin;

				// set the tether distance
				self settetherradius( int_tether_dist );
}
///////////////////////////////////////////////////////////////////////////
// 07-19-08 WWilliams
// function waits for a guy to get to goal
// resets the script speed
// starts the tether for a guy
train_reset_speed_activate_tether( nod_tether, int_low_tether, int_high_tether, int_default_tether )
{
				// endon
				self endon( "death" );
				
				// double check the defines
				//assertex( isdefined( nod_tether ), "nod_tether not defined" );
				//assertex( isdefined( int_low_tether ), "int_low_tether not defined" );
				//assertex( isdefined( int_high_tether ), "int_high_tether not defined" );
				//assertex( isdefined( int_default_tether ), "int_default_tether not defined" );

				// wait for goal
				self waittill( "goal" );

				// reset script speed
				self setscriptspeed( "default" );

				// tether the guy
				self.tetherpt = nod_tether.origin;

				// give tether to the guy
				self thread train_active_tether( int_low_tether, int_high_tether, int_default_tether );

}
///////////////////////////////////////////////////////////////////////////
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
train_active_tether( tetherDelta0, tetherDelta1, minTether )
{
				// endon
				self endon( "death" );

				// check to make sure everything passed in works properly
				//assertex( isdefined( tetherdelta0 ), "tetherdelta0 is not defined!" );
				//assertex( isdefined( tetherDelta1 ), "tetherDelta1 is not defined!" );
				//assertex( isdefined( minTether ), "minTether is not defined!" );
				//assertex( isdefined( self.tetherpt ), "self.tetherpt is not defined!" );

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

				////assertex( isdefined( vec_tether_point ), "vec_tether_point is not defined!" );
				//assertex( isdefined( self.tetherradius ), "self.tetherradius is not defined!" );

				// wwilliams
				// adding a check to make sure the guy has a .tetherpt set on him
				if( !isdefined( self.tetherpt ) )
				{
								iprintlnbold( "no_tether_on " + self.targetname );
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
// 07-21-08 WWilliams
// gives combat role upon goal
// runs on NPC/self
goal_n_combatrole( str_combatrole )
{
				// endon
				self endon( "death" );

				// double check objects
				//assertex( isdefined( str_combatrole ), "not defined role for combatrole" );
				//assertex( isstring( str_combatrole ), "not string for combatrole" );

				// wait for goal
				self waittill( "goal" );

				// give combat role
				self setcombatrole( str_combatrole );

}
///////////////////////////////////////////////////////////////////////////
// 08-11-08 WWilliams
// wait for either a notify or a trigger
train_notify_or_trigger( str_notify, ent_trigger )
{
				// double check values passed in
				//assertex( isstring( str_notify ), "notify passed in is not a trigger" );
				//assertex( isdefined( ent_trigger ), "trigger passed in is not defined" );

				// endon
				level endon( "off_notify_or_trigger" );

				// thread off teh function that watches for the notify
				level thread train_notify_activate_trig( str_notify, ent_trigger );

				// wait for the trigger
				ent_trigger waittill( "trigger" );

				// wait
				wait( 0.1 );

				// turn off train_notify_activate_trig
				level notify( "end_notify_activate_trig" );
}
train_notify_activate_trig( str_notify, ent_trigger )
{
				// turn off train_notify_activate_trig
				level endon( "end_notify_activate_trig" );

				// double check values passed in
				//assertex( isstring( str_notify ), "notify passed in is not a trigger" );
				//assertex( isdefined( ent_trigger ), "trigger passed in is not defined" );
				
				// wait for the notify
				level waittill( str_notify );

				// notify the trigger
				ent_trigger notify( "trigger" );

				// wait
				wait( 0.1 );

				// turn off train_notify_or_trigger
				level notify( "off_notify_or_trigger" );
}

//////////////////////////////////////////////////////////////////////////////////////////
// 										Bar Tap Setup
//////////////////////////////////////////////////////////////////////////////////////////
bar_tap_dest_fx_precache()
{
	level._effect["tap_vfx"] = loadfx("maps/MontenegroTrain/train_beer_tap_spray");  
	thread bar_tap_setup_fx();
}	
bar_tap_setup_fx()
{
	
	bar_tap_dest = getentarray("bar_tap_model_dest", "targetname");
	if(IsDefined(bar_tap_dest))
	{
		for (i = 0; i < bar_tap_dest.size; i++)
		{
			bar_tap_dest[i] setcandamage(true);
			bar_tap_dest[i] thread bar_tap_play_fx();
		}
	}
}	
bar_tap_play_fx()
{
	P = (0,0,0);
	self waittill("damage", other, damage, direction_vec, P , type);

	direction_vec = vector_multiply(direction_vec, -1);
	direction_vec playsound("mtl_water_pipe_hit");
	fx = playfx( level._effect["tap_vfx"], P, direction_vec);

}	
//////////////////////////////////////////////////////////////////////////////////////////
// 										Keep dead AI off glass
//////////////////////////////////////////////////////////////////////////////////////////
glass_physics_pulse_setup()
{
				glassarray = getentarray("glass", "targetname");
				if(IsDefined(glassarray))
				{
								for (i = 0; i < glassarray.size; i++)
								{
												if(IsDefined(glassarray[i].target))
												{
																cracked_section[i] = getent(glassarray[i].target, "targetname");
																cracked_section[i] thread glass_physics_pulse_start();
												}
								}
				}	
}	
glass_physics_pulse_start()
{
				while(IsDefined(self))
				{
								self waittill("damage");
								if(IsDefined(self))
								{
												physicsExplosionSphere( self.origin, 80, 60, 0.05 );
								}
								wait(0.05);
				}
}	
