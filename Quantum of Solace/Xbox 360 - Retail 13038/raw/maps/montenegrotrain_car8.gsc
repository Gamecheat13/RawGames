// Montenegro Train car 8
// Builder: Don Sielke
// Scripter: Don Sielke
//////////////////////////////////////////////////////////////////////////////////////////
// includes
#include maps\_utility;

//
//	Spawns a civilian
//
e8_main()
{

				level.enemy_hurt = 0;

				level thread car_b4_bliss_extra_save();

				thread car9_hint_triggers();
				thread activate_gate_lock();

				thread spawn_bliss_run();

				//////////////////////////////////////////////////////////////////////////
				// 05-13-08
				// wwilliams
				// adding func call for the new enemy setup on car9 roof
				level thread train_tunnel_roof_init();
				///////////////////////////////////////////////////////////////////////
				// 08-14-08 WWilliams
				// the guy who gets hit by the light is controled by a special function now
				level thread car9_light_hit();



				// startup car9
				level waittill( "in_car_8" );
				//thread maps\MontenegroTrain_car9::e9_main();
}

//////////////////////////////////////////////////////////////////////////////////////////
// Hint Triggers.
//////////////////////////////////////////////////////////////////////////////////////////

spawn_bliss_run()
{

				// objects to define for this function
				// scr_org
				scr_org_talk = getent( "bliss_talk", "targetname" );
				grenade_spot = getent( "grenade_pos", "targetname" );
				// undefined ent_array
				enta_enemies = undefined;
				// triggers
				trig = GetEnt( "bliss_trig", "script_noteworthy" );
				bliss_guard_trig = getent( "bliss_guards", "script_noteworthy" );
				// node
				node_bliss_grenade = GetNode( "nod_bliss_grenade", "script_noteworthy" );

				// double check define
				//assertex( isdefined( scr_org_talk ), "scr_org_talk not defined" );

				trig waittill( "trigger" );
				
				// DCS: delete fifth set of fx entities.
				level notify("delete_fxgroup_5");

				if ( IsDefined( level.bliss_run_spawner ) )
				{
								level.bliss_run = level.bliss_run_spawner Stalingradspawn( "mr_bliss" );
								if ( spawn_failed(level.bliss_run) )
								{
												iPrintLnBold( "Bliss runner spawn failed" );
								}		

								level.bliss_run animscripts\shared::placeWeaponOn( level.bliss_run.weapon, "none" );
								level.bliss_run.goalradius = 12;	
								level.bliss_run.walkdist = 320000;
								level.bliss_run SetEnableSense( false );
								level.bliss_run thread magic_bullet_shield();
								//level.bliss_run SetDeathEnable(false);
								level.bliss_run SetPainEnable(false);


								trig_run = GetEnt( "bliss_run_trig", "targetname" );
								if ( IsDefined(trig_run) )
								{
												if ( IsDefined(level.bliss_run.target) )
												{
																node = GetNode( level.bliss_run.target, "targetname" );
																if ( IsDefined(node) )
																{	
																				level.bliss_run SetGoalPos(level.bliss_run.origin);
																				trig_run waittill( "trigger" );

																				// thread off the clean bliss func
																				level thread leave_bliss_only();

																				// 05-16-08
																				// wwilliams
																				// changing the vision set back to normal
																				VisionSetNaked("MontenegroTrain_in", 2.0);

																				//// freeze player control
																				//level.player freezecontrols( true );

																				//// set stance
																				//level.player setstance( "stand" );

																				//// send bliss to patrol node
																				//level.bliss_run startpatrolroute( "bliss_suprise" );

																				//// unfreeze controls
																				//level.player freezecontrols( false );

																				// autosave now
																				level thread maps\_autosave::autosave_now( "montenegrotrain" );

																				//// holster the player's weapons, letterbox should do this
																				//level.player maps\_utility::letterbox_on( true, false );

																				////iprintlnbold( "letterbox" );

																				//// wait for the player to get closer to the ground
																				//while( level.player.origin[2] > scr_org_talk.origin[2] + 15 )
																				//{
																				//				// wait a frame
																				//				wait( 0.05 );
																				//}

																				//// iprintlnbold( "origin check" );
																				//
																				//// stick the player
																				//level maps\_utility::player_stick( false );

																				////iprintlnbold( "player stick" );

																				// once this trigger hits set the player to a specific spot
																				//level.sticky_origin rotateto( scr_org_talk.angles, 0.3 );

																				//// wait for rotate
																				//level.sticky_origin waittill( "rotatedone" );

																				//// move player to the origin
																				//level.sticky_origin moveto( scr_org_talk.origin, 0.2 );

																				//// wait for move
																				//level.sticky_origin waittill( "movedone" );

																				//// dialogue between bond and bliss
																				//// line 1 - bond
																				//level.player play_dialogue( "BOND_TraiG_050A" );
																				//// play anim on bliss
																				//level.bliss_run cmdaction( "listen" );
																				//// line 2 - bliss
																				//level.bliss_run play_dialogue( "BLIS_TraiG_051A" );
																				//// quick wait
																				//// wait( 0.25 );

																				//// send bliss to the grenade node
																				//// level.bliss_run setgoalnode( node_bliss_grenade );
																				//// line 3 - bond
																				//level.player thread play_dialogue( "BOND_TraiG_052A" );
																				
																				// wait a second
																				// wait( 2.8 );

																				//iprintlnbold( "dialog done" );

																				//iprintlnbold( "michel" );

																				// level.bliss_run cmdshootatentity( level.player, false, 1 );

																				//// wait for the cmd to finish
																				//level.bliss_run stopallcmds();
																				//// stop the patrol route
																				//level.bliss_run stoppatrolroute();

																				//// bliss throws a flashbang at bond
																				//level.bliss_run cmdthrowgrenadeatpos( grenade_spot.origin + ( 0, 10, 5 ), false, 0.25 );

																				//// wait for cmddone
																				//level.bliss_run waittill( "cmd_done" );

																				//iprintlnbold( "grenade thrown" );

																				//// setup flashbang. 
																				level.bliss_run SetScriptSpeed( "Run" );
																				level.bliss_run SetGoalNode( node );
																				
																				//// quick wait
																				//wait( 1.1 );
																				
																				

																				level throw_grenade_bliss();
	
																				// force the player into cover
																				//level.player playersetforcecover( true, ( 0.0, 1.0, 0.0 ), true, true, true );

																				//// wait
																				wait( 0.1 );

																				//// spawn out the enemies
																				bliss_guard_trig notify( "trigger" );

																				// change a flag
																				level maps\_utility::flag_set( "bliss_run_started" );

																				//// unstick the player
																				//level maps\_utility::player_unstick();

																				//// forward angles
																				//forward = AnglesToForward( 0, 90, 0 );

																				//// wait
																				//wait( 0.25 );

																				// force the player into cover
																				level.player playersetforcecover( true, ( 1, 0, 0 ), true, true );

																				//// wait a sec
																				//wait( 1.0 );
																				
																				// DCS: adding force sense on all living ai.
																				wait(0.05);
																				thugs = getaiarray("axis");
																				for (i = 0; i < thugs.size; i++)
																				{
																					thugs[i] setperfectsense(true);
																					thugs[i] lockalertstate("alert_red");

																				}	
																				//// turn off letterbox
																				//level maps\_utility::letterbox_off( true, 1.0 );

																				// unforce cover
																				level.player playersetforcecover( false );

																}
												}
								}
				}

				//// setup final trigger.	
				thread maps\MontenegroTrain::finale_igc();

				hatch_bliss = GetEnt( "hatch_bliss", "targetname" );
				hatch_bliss MoveTo( hatch_bliss.origin + (0, 51, 0), 1 );
}	
///////////////////////////////////////////////////////////////////////////
// 08-22-08 WWilliams
// clean everyone but bliss
leave_bliss_only()
{
				// kill any ai that aren't bliss
				enta_enemies = getaiarray( "axis" );
				// for loop goes through and eliminates all AI that aren't bliss
				for( i=0; i<enta_enemies.size; i++ )
				{
								// check to see if there is a target name
								if( isdefined( enta_enemies[i].targetname ) )
								{
												// check to see if the targetname is bliss's
												if( enta_enemies[i].targetname == "mr_bliss" )
												{
																// don't delete bliss
																// continue through the array
																continue;
												}
												else // if it ain't bliss get rid of it
												{
																// hide
																enta_enemies[i] hide();
																// delete
																enta_enemies[i] delete();
												}
								}
								else // if there is no targetname get rid of them
								{
												// hide the guy
												enta_enemies[i] hide();
												// delete the guy
												enta_enemies[i] delete();
								}
				}
}
///////////////////////////////////////////////////////////////////////////
throw_grenade_bliss()
{

				grenade_start = spawn("script_model", level.bliss_run gettagOrigin("TAG_WEAPON_RIGHT"));
				grenade_start setmodel("w_t_grenade_flash");
				grenade_start physicslaunch(grenade_start.origin , vectornormalize((0, 1.0, 0)) );
				
				wait(0.5);
				grenade_start delete();

				grenade = GetEnt( "grenade_pos", "targetname" );
				
				//This part is confusing, we need VO and sound to sell this - CRussom
				grenade playsound ("BLISS_GrenadeVO");
				wait(1.0);
				playfx (level._effect["flash"], grenade.origin +(0, 0, 0));
				grenade playsound ("explo_grenade_flashbang");
				level.player shellshock("flashbang", 5);
				
				//Start Climax Music - Added by crussom
				level notify( "playmusicpackage_bliss" );

				// debug text
				//iprintlnbold( "interior vision set" );
}	
//////////////////////////////////////////////////////////////////////////////////////////
// Hint Triggers.
//////////////////////////////////////////////////////////////////////////////////////////
car9_hint_triggers()
{
				car9hint = GetEnt( "car9hint_trig", "targetname" );
				if ( IsDefined( car9hint ) )
				{
								car9hint waittill( "trigger" );
								//iPrintLnBold( "Villiers: Bond,");
								//wait( 1.5 );
								//iPrintLnBold( "They've barred the door.");
								//wait( 1.5 );
								//iPrintLnBold( "Find a way to the roof.");

								// play tanner dialogue
								level.player play_dialogue( "TANN_TraiG_809A", true );
				}	
}

//////////////////////////////////////////////////////////////////////////////////////////
// Setup and Enter Tunnel sequence.
//////////////////////////////////////////////////////////////////////////////////////////
setup_tunnel_segments()
{
				level.background_tunnel[0] = GetEnt( "background_tunnel_00", "targetname" );
				level.background_tunnel[1] = GetEnt( "background_tunnel_01", "targetname" );
				level.background_tunnel[2] = GetEnt( "background_tunnel_02", "targetname" );
				level.background_tunnel[3] = GetEnt( "background_tunnel_03", "targetname" );
				level.background_tunnel[4] = GetEnt( "background_tunnel_04", "targetname" );
				level.background_tunnel[5] = GetEnt( "background_tunnel_05", "targetname" );
				level.background_tunnel[6] = GetEnt( "background_tunnel_06", "targetname" );
				level.background_tunnel[7] = GetEnt( "background_tunnel_07", "targetname" );
				// undefined
				ent_temp = undefined;
				ent_temp_target = undefined;
				
				///////////////////////////////////////////////////////////////////////
				// 07-28-08 WWilliams
				// setup the light for the tunnel area
				///////////////////////////////////////////////////////////////////////
				// 07-24-08 WWilliams
				// defining the lights for the tunnel
				//level.tunnel_lights = getentarray( "tunnel_lights", "targetname" );

				//// 07-28-08 WWilliams
				//// double check light array
				////assertex( isdefined( level.tunnel_lights ), "tunnel lights array not defined" );

				//// 07-24-08 WWilliams
				//// link the lights to their targets
				//if( isdefined( level.tunnel_lights ) )
				//{
				//				// link the lights
				//				for( i=0; i<level.tunnel_lights.size; i++ )
				//				{
				//								if( isdefined( level.tunnel_lights[i].script_string ) )
				//								{
				//												// get the target of the light
				//												ent_temp = getent( level.tunnel_lights[i].script_string, "targetname" );

				//												// frame wait to avoid an error
				//												wait( 0.05 );

				//												// check that the node is valid
				//												assertex( isdefined( ent_temp ), "light target2 not valid" );

				//												// iprintlnbold( ent_temp.targetname + " is the script origin" );

				//												// define the target of the script origin
				//												ent_temp_target = getent( ent_temp.target, "targetname" );

				//												// check that the node is valid
				//												assertex( isdefined( ent_temp_target ), "light script origin target not valid" );

				//												// iprintlnbold( ent_temp_target.targetname + " is the tunnel piece" );

				//												// link the light to the target script origin
				//												level.tunnel_lights[i] linklighttoentity( ent_temp );

				//												// need to move the light to the zero point of ent I'm linking it to
				//												level.tunnel_lights[i].origin = ( 0, 0, 0 );

				//												// link the script origin to the part of the tunnel
				//												ent_temp linkto( ent_temp_target );

				//												// debug func
				//												// level thread tunnel_light_3d_print( ent_temp );

				//												wait( 0.05 );

				//												// undefine ent_temp
				//												ent_temp = undefined;
				//								}
				//								else
				//								{
				//												// light missing a target2!
				//												iprintlnbold( "light missing a script_string" );

				//												// go to the next one
				//												continue;
				//								}
				//				}
				//}

				//// debug text
				//iprintlnbold( level.tunnel_lights.size + " lights in the tunnel");

				//////////////////////////////////
				//Added by Steve G
				Maps\MontenegroTrain_snd::audio_tunnel_linkage();
				//////////////////////////////////	

				for ( i = 0; i < 8; i++ )
				{
								level.background_tunnel[i] hide();
				}	


				thread background_tunnel_move();
}	
///////////////////////////////////////////////////////////////////////////
// 07-28-08 WWilliams
// temp 3d-print to see where the tunnel lights are
tunnel_light_3d_print( light )
{
				// endon

				// while loop
				while( 1 )
				{
								// debug text
								print3d( light.origin + ( 0, 0, -5 ), "TUNNEL_LIGHT", ( 255, 250, 250 ), 1, 1, 100 );

								// wait
								wait( 1.0 );
				}

}
///////////////////////////////////////////////////////////////////////////
background_tunnel_move()
{
				start_trig = GetEnt( "start_tunnel_loop", "targetname" );
				if ( IsDefined(start_trig) )
				{
								// 05-29-08
								// wwilliams
								// function controls the moving light
								// level thread tunnel_moving_light();

								start_trig waittill ("trigger");
								setExpFog(500, 2000,9/255, 13/255, 15/255, 0);
								//////////////////////////////////////////////////////////////////////////////////////////
								// 04-25-08
								// wwilliams
								// commenting this out to fix issue 6375
								// 07-21-08 WWilliams
								// turn off the automatic vision set change
								level notify( "tunnel_vision_set" );
								level notify( "stop_passing_train" );
								level notify( "train_end_wet_materials" );
								// 05-15-08
								// wwilliams
								// bringing this back in order to make the tunnel visible
								// VisionSetNaked("MontenegroTrain_tunnel", 2.0);

								// debug text
								//iprintlnbold( "tunnel vision set" );

								// debug text
								// iprintlnbold( "changed to tunnel vision set" );
								//////////////////////////////////////////////////////////////////////////////////////////

								level.standard_background = false;

								materialsetwet( 0 );

								// go through the array of standard backgrounds
								// turn off the auto hide, and hide them until tunnel is complete
								for( i=0; i<level.background_scene.size; i++ )
								{
												// notify for the auto hide function to end
												level.background_scene[i] notify( "stop_delete" );

												// hide the piece
												level.background_scene[i] hide();
								}

								thread setup_tunnel_hurt();
								thread play_tunnel_looping();
								// 05-29-08
								// wwilliams
								// function to move light down tunnel
								// level thread tunnel_moving_light();
								///////////////////////////////////////////////////////////////////////
								// 07-21-08 WWilliams
								// for loop to setup the hide/show function
								for( i=0; i<level.background_tunnel.size; i++ )
								{
												// thread off the hide function
												level.background_tunnel[i] thread maps\MontenegroTrain::train_scenery_hide();

												// turn off shadows for the pieces
												level.background_tunnel[i] disableshadowon();
								}
								///////////////////////////////////////////////////////////////////////
				}
				else
				{
								iPrintLnBold( "Couldn't find trigger for tunnel");
				}		

				stop_trig = GetEnt( "stop_tunnel_loop", "targetname" );
				if ( IsDefined(stop_trig) )
				{
								stop_trig waittill ("trigger");
								
								if(level.ps3)
								{
									setExpFog(1000, 4000,3/255, 17/255, 26/255, 0);
								}
								else
								{
									setExpFog(2000, 6000,3/255, 17/255, 26/255, 0);
								}
								// VisionSetNaked("default_glow", 2.0);
								level.standard_background = true;

								// go through the array of standard backgrounds
								// turn back on the auto hide, and show the standard background cause the
								// tunnel is done
								for( i=0; i<level.background_scene.size; i++ )
								{
												// notify for the auto hide function to end
												level.background_scene[i] thread maps\MontenegroTrain::train_scenery_hide();

												// hide the piece
												level.background_scene[i] show();
								}
				}
				else
				{
								iPrintLnBold( "Couldn't find trigger to stop tunnel");
				}				
}
play_tunnel_looping()
{	
				//// hide standard background segments.
				for ( i = 0; i < 11; i++ )
				{
								level.background_scene[i] hide();
				}	

				////Show and move entire tunnel over -14848 on the x to line up with train. 
				for ( i = 0; i < 8; i++ )
				{
								level.background_tunnel[i] show();
								level.background_tunnel[i] movex(-1*14848, 0.05);
				}	
				level.background_tunnel[0] waittill( "movedone" );

				//// start tunnel conveyor system running.
				i = 0;
				travel_time = 3.0;		// seconds

				while (level.standard_background == false)
				{
								for ( i = 0; i < 7; i++ )
								{
												level.background_tunnel[i] moveto( level.background_tunnel[i+1].origin, travel_time );
								}	
								if (i >=7)
								{
												level.background_tunnel[i] moveto( level.background_tunnel[i-i].origin, travel_time );
												i = 0;
								}
								level.background_tunnel[i] waittill( "movedone" );
				}

				//// go back to original background.
				for ( i = 0; i < 11; i++ )
				{
								level.background_scene[i] show();
				}	
				// unlink and delete the lights attached to the tunnel
				if( isdefined( level.tunnel_lights ) )
				{
								// loop through and delete them
								for( i=0; i<level.tunnel_lights.size; i++ )
								{
												// unlink the light
												level.tunnel_lights[i] unlink();

												// delete the light
												level.tunnel_lights[i] delete();
								}
				}
				for ( i = 0; i < 8; i++ )
				{
								// notify the function to stop hiding it
								level.background_tunnel[i] notify( "stop_delete" );

								// move the tunnel down and out of the way
								level.background_tunnel[i] moveto( level.background_tunnel[i].origin + ( 0, 0, -15000 ), 0.5 );

								// frame wait
								level.background_tunnel[i] waittill( "movedone" );

								// delete the segment
								level.background_tunnel[i] delete();
				}	
}
setup_tunnel_hurt()
{
				hurt_trigger[0] = GetEnt( "tunnel_00_damage", "targetname" );
				hurt_trigger[1] = GetEnt( "tunnel_01_damage", "targetname" );
				hurt_trigger[2] = GetEnt( "tunnel_02_damage", "targetname" );
				hurt_trigger[3] = GetEnt( "tunnel_03_damage", "targetname" );
				hurt_trigger[4] = GetEnt( "tunnel_04_damage", "targetname" );
				hurt_trigger[5] = GetEnt( "tunnel_05_damage", "targetname" );
				hurt_trigger[6] = GetEnt( "tunnel_06_damage", "targetname" );
				hurt_trigger[7] = GetEnt( "tunnel_07_damage", "targetname" );

				for ( i = 0; i < 8; i++ )
				{
								hurt_trigger[i] enablelinkto();
								hurt_trigger[i] linkto(level.background_tunnel[i]);
								thread notify_when_hurt(hurt_trigger[i]);
				}	
}
notify_when_hurt(trigger)
{
				while(level.standard_background == false)
				{
								trigger waittill("trigger", entity);

								if( entity != level.player && level.enemy_hurt == 0)
								{
												//iPrintLnBold( "Enemy getting hurt ", level.enemy_hurt);

												//apply extra damage to first enemy ai. Then force the rest to crouch.
												// play the animation of the guy being hit
												if( isalive( entity ) )
												{
																// entity dodamage(75, entity.origin + (0,40,0));
																entity setenablesense( false );
																// stop all commands
																entity stopallcmds();
																// play the flip animation: this is a death animation 
																entity cmdplayanim( "Thug_Train_roof_hit_back", false, true );
																// wait
																wait( 0.05 );
																// ragdoll
																entity startragdoll( );
																// wait for the anim to finish
																entity waittill( "cmd_done" );
																// kill him
																entity becomecorpse();

																thread enemy_learn_crouch();
												}

								}	
								else if( entity == level.player )
								{
												//iPrintLnBold( "Player getting hurt");
												// entity cmdplayanim( )
												//for the player.
												
												//Steve G - impact sound
												hit_sound = GetEnt("tunnel_00_damage", "targetname");
												hit_sound playsound("tunnel_light_impact_01");
												
												entity dodamage( 240, entity.origin + ( 0, 40, 0 ) );
												// force them to crouch
												level.player allowStand( false );
												// blue the screen 
												level.player shellshock( "default", 1.5 );
												// need to add an earthquake here
												earthquake( 0.25, 0.25, level.player.origin, 512 );
												// wait before allowing a stand again
												wait( 1.0 );
												// player can stand again
												level.player allowStand(true);
								}	
				}	
}	
enemy_learn_crouch()
{
				// give it time to get anyone on the roof standing at the same time.
				wait(1.0);
				level.enemy_hurt = 1;

				axis = getaiarray("axis");
				for (i = 0; i < axis.size; i++)
				{
								axis[i] allowedstances("crouch");
				}
				if ( IsDefined( level.bliss_run))
				{
								level.bliss_run allowedstances("crouch", "stand");
				}	
}	

activate_gate_lock()
{
				baggage_locker_trig = GetEnt( "baggage_locker_trig", "targetname" );
				run_trig = GetEnt( "baggage_locker_run", "targetname" );
				lookat_trig = GetEnt( "baggage_locker_lookat", "targetname" );
				baggage_locker_spawner = GetEnt( "baggage_locker", "targetname" );

				run1_node = GetNode( "baggage_lock_pos", "targetname" );
				run2_node = GetNode( "locker_escape", "targetname" );

				if ( IsDefined(baggage_locker_trig) )
				{
								baggage_locker_trig waittill( "trigger" );
								baggage_locker = baggage_locker_spawner Stalingradspawn();
								if ( spawn_failed(baggage_locker) )
								{
												iPrintLnBold( "Couldn't spawn lock guy" );
								}	
								baggage_locker allowedstances( "crouch" );
								baggage_locker SetGoalpos( baggage_locker_spawner.origin );
								//baggage_locker animscripts\shared::placeWeaponOn( baggage_locker.weapon, "none" );
								//baggage_locker.goalradius = 12;	
								//baggage_locker.walkdist = 320000;
								baggage_locker SetEnableSense( false );
								// baggage_locker setscriptspeed( "run" );


								if ( IsDefined(run1_node) )
								{

												//// must enter baggage car and lookat gate.
												run_trig waittill( "trigger" );
												lookat_trig waittill( "trigger" );

												baggage_locker SetScriptSpeed( "Run" );
												baggage_locker SetGoalNode(run1_node);

												baggage_locker waittill( "goal" );

												// notify the level the door is locked
												level notify( "baggage_car_locked" );

												// randomize the comment
												int_random = randomint( 10 );
												if( int_random > 5 )
												{
																// dialog play for this guy
																baggage_locker play_dialogue( "GAMR_TraiG_049A" );
												}
												else
												{
																// dialog play for this guy
																baggage_locker play_dialogue( "GAMR_TraiG_049B" );
												}

												wait(1.0);

								}

								// save right before going up to the top
								// might need to change this to a double check save
								level maps\_autosave::autosave_by_name( "montenegrotrain", 10.0 );

								if ( IsDefined(run2_node) && isalive( baggage_locker ) )
								{			
												baggage_locker allowedstances( "stand" );
												baggage_locker SetScriptSpeed( "Run" );
												baggage_locker SetGoalNode(run2_node);



												baggage_locker waittill( "goal" );
												baggage_locker delete();
								}



				}
}
//////////////////////////////////////////////////////////////////////////
// 05-13-08
// wwilliams
// function spawns out the guys that used to just be off a trig hit
// need to control these guys better for the roof
// runs on level
//////////////////////////////////////////////////////////////////////////
train_tunnel_roof_init()
{
				// endon
				// single shot function

				// objects to be defined for the function
				// trig
				start_trig = getent( "bliss_trig", "script_noteworthy" );
				// backup trig
				backup_trig = getent( "car9_trig_roof_backup", "targetname" );
				// roof spawner array
				enta_roof_enemies = getentarray( "car9_roof_enemy", "targetname" );
				// backup spawner 
				ent_roof_backup = getent( "car9_roof_backup", "targetname" );

				// check the counts on all the spawners

				// if the array is defined
				if( isdefined( enta_roof_enemies ) )
				{
								// first for loop through the array
								for( i=0; i<enta_roof_enemies.size; i++ )
								{
												// check the count, check to see if it is not defined
												// or if the count is less than one
												if( !isdefined( enta_roof_enemies[i].count ) || enta_roof_enemies[i].count < 1 )
												{
																// set the count to one
																enta_roof_enemies[i].count = 1;
												}

												// quick wait
												wait( 0.05 );
								}
				}
				else
				{
								iprintlnbold( "enta_roof_enemies not defined!" );
				}

				// now check that ent_roof_backup is defined
				if( isdefined( ent_roof_backup ) )
				{
								// make sure there is a count
								if( !isdefined( ent_roof_backup.count ) || ent_roof_backup.count < 1 )
								{
												ent_roof_backup.count = 1;
								}

				}
				else
				{
								// debug text
								iprintlnbold( "ent_roof_backup not defined" );
				}

				// thread off the trigger for backup
				// threads on the trig
				// pass in the spawner also
				backup_trig thread train_car9_roof_backup( ent_roof_backup );

				// wait for the player to hit the main trigger
				start_trig waittill( "trigger" );

				// then thread off a function on the top spawners
				for( i=0; i<enta_roof_enemies.size; i++ )
				{
								// thread the function on the spawner
								enta_roof_enemies[i] thread train_car9_roof_spawns();

								// quick wait
								wait( 0.05 );
				}

}
//////////////////////////////////////////////////////////////////////////
// 05-13-08
// wwilliams
// function runs on a spawner, checks for a target, then spawns a guy
// sets the guy up and sends him to his node
// runs on self/spawner
//////////////////////////////////////////////////////////////////////////
train_car9_roof_spawns()
{
				//End Music - Added by crussom
				level notify( "endmusicpackage" );

				// endon
				// single shot function
				// objects to be defined for this function
				// undefined ent
				ent_temp = undefined;
				// undefined node
				nod_temp = undefined;

				//make sure there is a count
				if( !isdefined( self.count ) || self.count == 0 )
				{
								// set count
								self.count = 1;
				}

				// count has already been checked in the function this is threaded from
				// check for a target
				if( isdefined( self.target ) )
				{
								// spawn out a guy
								ent_temp = self stalingradspawn( "car9_roof" );

								// check for the spawn failed
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												// debug text
												iprintlnbold( "spawner at " + self.origin + "failed spawn" );

												// end the function
												return;
								}

								// endon
								ent_temp endon( "death" );

								// guy spawns properly set the engage rules for him
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );

								// grab the node that is being targeted
								nod_temp = getnode( self.target, "targetname" );

								if( isdefined( nod_temp.script_string ) && nod_temp.script_string != "rusher" )
								{
												// set a low tether
												// tether the guy to the tether node
												ent_temp settetherradius( 128 );

												// give them perfect sense for five seconds
												ent_temp thread maps\MontenegroTrain_util::turn_on_sense( 8 );

												// send them to their node
												ent_temp setgoalnode( nod_temp );

												// set the combat role
												ent_temp setcombatrole( nod_temp.script_string );

												// will need a tether function for these guy to move down the map
												ent_temp.tetherpt = nod_temp.origin;
								}
								else
								{
												// give them perfect sense for five seconds
												ent_temp thread maps\MontenegroTrain_util::turn_on_sense( 8 );

												// send them to their node
												// ent_temp setgoalnode( nod_temp );

												// set the combat role
												ent_temp setcombatrole( "turret" );
								}
				}
}
//////////////////////////////////////////////////////////////////////////
// 05-16-08
// wwilliams
// special function to run on the guy who gets hit by the light in the tunnel
// runs on level
car9_light_hit()
{
				// endon
				level.player endon( "death" );

				// objects to define for this function
				// spawner
				spawner = getent( "car9_roof_light_hit", "targetname" );
				// trig
				trig_setup = getent( "start_tunnel_loop", "targetname" );
				lookat_trig = getent( "car9_trig_light_death", "targetname" );
				// node
				node_setup = GetNode( "nod_tunnel_light_hit", "targetname" );
				// undefined
				ent_temp = undefined;

				// double check the count of the spawner
				spawner.count = 1;

				// wait for the setup trigger
				trig_setup waittill( "trigger" );

				// spawn out the guy
				ent_temp = spawner stalingradspawn( "car9_light_hit" );
				// make sure guy spawned
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								// debug text
								iprintlnbold( "car_light guy didn't spawn!" );
				}

				// endon based on guy
				ent_temp endon( "death" );

				// make the guy crouch
				ent_temp allowedstances( "crouch" );

				// move him into position
				ent_temp setgoalnode( node_setup );

				// wait for goal
				ent_temp waittill( "goal" );

				// set guy as a turret
				ent_temp setcombatrole( "turret" );

				// turn off sense
				ent_temp setenablesense( false );

				// will need a tether function for these guy to move down the map
				ent_temp.tetherpt = node_setup.origin;

				// tether the guy to the tether node
				ent_temp settetherradius( 24 );

				// wait for the lookat_trig
				lookat_trig waittill( "trigger" );

				// make the guy see the player
				ent_temp setperfectsense( true );

				// make the guy stand
				ent_temp allowedstances( "stand" );

				// make him shoot at the player
				ent_temp cmdshootatentity( level.player, true, 10, 0.2 );

				// disable pain so that it can get special deathanimation played
				ent_temp setpainenable( false );

}
//////////////////////////////////////////////////////////////////////////
// 05-13-08
// wwilliams
// function waits for the player to hit a trig/self
// then spawns out back up for the roof
// runs on self/trigger
//////////////////////////////////////////////////////////////////////////
train_car9_roof_backup( spawner )
{
				// endon
				// single shot function

				// objects to define for the function
				// temp node
				nod_temp = undefined;
				// temp ent
				ent_temp = undefined;

				// make sure the stuff that needs to be defined is
				if( isdefined( spawner ) )
				{
								// wait for the trigger to hit
								self waittill( "trigger" );

								// spawn out a enemy
								ent_temp = spawner stalingradspawn( "car9_roof" );

								// check for spawn failed
								if( spawn_failed( ent_temp ) )
								{
												// debug text
												iprintlnbold( "fail spawn from train_car9_roof_backup" );

												// break out
												return;
								}

								// these guys must stay in crouch
								// ent_temp allowedstances("crouch");

								// if the spawn works then set the engage rules
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );

								// give perfect sense
								ent_temp setperfectsense( true );

				}
				else
				{
								// debugt text
								iprintlnbold( "train_car9_roof_backup has no spawner!" );

								// leave function
								return;
				}

				// clean up
}
///////////////////////////////////////////////////////////////////////////
// 08-22-08 WWilliams
// extra save spot before bliss
car_b4_bliss_extra_save()
{
				// endon

				// objects to define for this function
				trig = getent( "player_at_car_9", "targetname" );

				// wait for trig to hit
				trig waittill( "trigger" );

				// autosave_by_name
				level maps\_autosave::autosave_by_name( "montenegrotrain", 10.0 );
}