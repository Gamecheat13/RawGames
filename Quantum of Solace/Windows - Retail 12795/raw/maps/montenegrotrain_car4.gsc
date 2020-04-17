// Montenegro Train car 4
// Builder: Don Sielke
// Scripter: Don Sielke
//////////////////////////////////////////////////////////////////////////////////////////
// includes
#include maps\_utility;

//////////////////////////////////////////////////////////////////////////////////////////
// Dining Car. (civilian)
//////////////////////////////////////////////////////////////////////////////////////////
e4_main()
{
				// make a level_var to know if the player shot first
				level.player_shot_first = 0;


				thread spawn_crossfire_enemies();
				thread start_passing_contraband();

				// debug text
				// iprintlnbold( "start_thread_e4_passenger_jump_back" );

				//////////////////////////////////////////////////////////////////////////////////////////
				// 04-25-08
				// wwilliams
				// thread function that controls the jump animation
				level thread e4_passenger_jump_back();
				//////////////////////////////////////////////////////////////////////////////////////////

				///////////////////////////////////////////////////////////////////////
				// 08-07-08 WWilliams
				// function controls the trapped container event
				level thread car4_container_panel_control();
				///////////////////////////////////////////////////////////////////////
				// 08-16-08 WWilliams
				// function causes the box to break and the player to be linked to the freight
				level thread trap_container_box_break();


				// startup car5
				level waittill( "in_car_4" );
				thread maps\MontenegroTrain_car5::e5_main();
}

//////////////////////////////////////////////////////////////////////////////////////////
// At end of train, delete flood spawner.
//////////////////////////////////////////////////////////////////////////////////////////
spawn_crossfire_enemies()
{

				// notify guy in the ob car
				level thread car4_enemy_announce();

				// guys who patrol car4
				level thread car4_crossfire();

}
//////////////////////////////////////////////////////////////////////////////////////////
// Show unloading of contraband.
//////////////////////////////////////////////////////////////////////////////////////////
start_passing_contraband()
{
				contraband_trig_end = GetEnt("contraband_trig_end", "targetname");
				//////////////////////////////////////////////////////////////////////////
				// 05-20-08
				// wwilliams
				// defining a trigger here, in order to stop the freight early to avoid a timing issue
				trig_stop_train_contraband = getent( "trig_get_contraband_ready", "targetname" );

				// set the flag to get the guys shooting
				level maps\_utility::flag_wait( "car4_boxcar_surprise" );

				if ( IsDefined(contraband_trig_end) )
				{
								contraband_trig_end waittill("trigger");
								level thread Open_contraband_door();
				}

}

//// first group of drug passers. open door to box car.
Open_contraband_door()
{
				// thread maps\MontenegroTrain_util::hud_text_uninterruptible("Stop unloading and take him out!", 2000);

				//// open door to boxcar for battle.
				level.door_busy = true;

				// 05-29-08
				// wwilliams
				// move freight after player mantles
				// define the trigger to move the car forward
				trig_move_to_train2 = getent( "trig_move_from_train2", "targetname" );

				// 05-20-08
				// wwilliams
				// set the flag
				level flag_set( "freight_door_busy" );

				while( level.train_moving == true )
				{
								wait(0.05);
				}

				// makes the roof runners setup start
				level thread roof_runners_init();


				// this is where I would unlink the doors
				// let's try it without unlinking them
				// unlink them
				// right door
				level.freight_door1_right unlink();
				// left door
				level.freight_door1_left unlink();

				// notify for wave one to start firing
				level notify( "wave_1_fire" );
				
				// DCS: trigger second set of fx entities.
				level notify("start_fxgroup_2");
				

				// rotate the doors out
				// right door
				level.freight_door1_right rotateyaw( 120, 2.0 );

				//Steve G
				level.freight_door1_right playsound("container_doors_open");
				//iprintlnbold("DOORS SWING OPEN");

				// left door
				level.freight_door1_left rotateyaw( -120, 2.0 );
				// will probably need to make these swing slightly

				// wait for the left door to finish the rotation
				level.freight_door1_left waittill( "rotatedone" );

				// this is where I would link them back to the car
				// right door
				level.freight_door1_right linkto( getent( level.freight_door1_right.target, "targetname" ) );
				// left door
				level.freight_door1_left linkto( getent( level.freight_door1_left.target, "targetname" ) );

				// false the level var
				level.door_busy = false;
				// 05-20-08
				// wwilliams
				// set the flag
				level flag_clear( "freight_door_busy" );

				// dialog lines for the guys near teh doors, playing them off player for now
				level.player play_dialogue_nowait( "BDMR_TraiG_032A" );
				level.player play_dialogue_nowait( "BDMR_TraiG_033A" );

				// 05-29-08
				// wwilliams
				// waiting for the player to mantle before moving the train back
				if( isdefined( trig_move_to_train2 ) )
				{
								// wait for the trig to be 
								trig_move_to_train2 waittill( "trigger" );

								// save the game now
								level thread maps\_autosave::autosave_now( "montenegrotrain" );

								// clean up bodies function
								deleteallcorpses( 1 );

								// wait for the notify from the box break
								// level waittill( "player_locked_in_trap" );
								level maps\_utility::flag_wait( "player_locked_in_trap" );

								// 05-20-08
								// wwilliams
								// set the flag that causes the train to fall back to the next freight node
								level flag_set( "freight_to_node3" );
				}
				else
				{
								// debug text
								iprintlnbold( "trig_move_to_train2 not found" );
				}

}	
///////////////////////////////////////////////////////////////////////////
// 08-16-08 WWilliams
// breaks the box under bond when he drops into the trap container
trap_container_box_break()
{
				// endon
				// single shot function

				// objects to define for this function
				// trig
				break_trig = getent( "trig_freight_bond_break", "targetname" );
				// script_model
				box_break = getent( "freight_crate", "script_noteworthy" );
				// broken piece models
				box_pieces = getentarray( "freight_crate_pieces", "script_noteworthy" );

				// hide the pieces
				for( i=0; i<box_pieces.size; i++ )
				{
								// hide the pieces
								box_pieces[i] hide();
				}

				// wait for the player to hit the trigger
				break_trig waittill( "trigger" );

				// need to make a script origin at the box's origin
				scr_org = spawn( "script_origin", box_break.origin + ( 0, 0, 6 ) );

				// wait a frame
				wait( 0.05 );

				// link the scr_org to the freight car
				scr_org linkto( getent( "freight6", "targetname" ) );

				// radiusdamage on the box
				// level.player radiusdamage( level.player.origin, 100, 500, 500 );
				// change the model of the box
				box_break setmodel( "d_crate_base" );

				// show the pieces
				for( i=0; i<box_pieces.size; i++ )
				{
								// hide the pieces
								box_pieces[i] show();
				}

				// shellshock the player
				level.player shellshock( "default", 4.0 );

				// move the player to the script origin
				level.player setorigin( scr_org.origin );
				
				//Steve G - Crate Sound
				level.player playsound("land_on_crate");

				// link the player to the org
				level.player playerlinkto( scr_org );

				// quick wait
				wait( 0.1 );

				// notify to start the move of the freight
				// level notify( "player_locked_in_trap" );
				level maps\_utility::flag_set( "player_locked_in_trap" );

				// play dialogue from Tanner
				level.player maps\_utility::play_dialogue_nowait( "TANN_TraiG_805A", true );
				
				// DCS: delete fx entities.
				level notify("delete_fxgroup_1");
				level notify("delete_fxgroup_2");

				// wait for the notify the freight is done
				level waittill( "train_at_node_3" );

				// unlink the player
				level.player unlink();

				// wait a frame
				wait( 0.05 );

				// clean up
				scr_org unlink();
				break_trig unlink();
				scr_org delete();
				break_trig delete();
				
}
///////////////////////////////////////////////////////////////////////////
// 07-16-08 WWilliams
// func creates the level var for shooting at the parts
// arranges the three brushes in the correct order also
// runs on level
car4_container_panel_control()
{
				// endon

				// objects to define for the function
				// trigger
				trig_first_show = getent( "trig_first_show", "targetname" );
				// level var
				level.car4_panel = undefined;
				// panel brushes
				sbrush_container_panel_0 = getent( "e4_container_hole_0", "script_noteworthy" );
				sbrush_container_panel_1 = getent( "e4_container_hole_1", "script_noteworthy" );
				sbrush_container_panel_2 = getent( "e4_container_hole_2", "script_noteworthy" );
				// destroyed panels
				sbrush_container_panel_d_0 = getent( "e4_container_hole_d_0", "script_noteworthy" );
				sbrush_container_panel_d_1 = getent( "e4_container_hole_d_1", "script_noteworthy" );
				sbrush_container_panel_d_2 = getent( "e4_container_hole_d_2", "script_noteworthy" );
				// script orgs for the ai to shoot out
				org_one = getent( "so_panel_one", "script_noteworthy" );
				org_two = getent( "so_panel_two", "script_noteworthy" );
				org_three = getent( "so_panel_three", "script_noteworthy" );
				// empty fx array
				dust_fx = [];
				bullet_fx = [];
				// health
				int_health = 0;

				// double script brush array
				//assertex( isdefined( sbrush_container_panel_0 ), "sbrush_container_panel_0 not defined" );
				//assertex( isdefined( sbrush_container_panel_1 ), "sbrush_container_panel_1 not defined" );
				//assertex( isdefined( sbrush_container_panel_2 ), "sbrush_container_panel_2 not defined" );
				//assertex( isdefined( sbrush_container_panel_d_0 ), "sbrush_container_panel_d_0 not defined" );
				//assertex( isdefined( sbrush_container_panel_d_1 ), "sbrush_container_panel_d_1 not defined" );
				//assertex( isdefined( sbrush_container_panel_d_2 ), "sbrush_container_panel_d_2 not defined" );

				// wait for the trigger to hit
				trig_first_show waittill( "trigger" );

				// hide the destroyed version
				// panel 0
				sbrush_container_panel_d_0 notsolid();
				sbrush_container_panel_d_0 hide();
				// panel 1
				sbrush_container_panel_d_1 notsolid();
				sbrush_container_panel_d_1 hide();
				// panel 2
				sbrush_container_panel_d_2 notsolid();
				sbrush_container_panel_d_2 hide();

				// debug text
				// iprintlnbold( "panels set up" );

				// wait for the freight to finish moving
				// level.freight_train[0] waittill( "movedone" );
				level waittill( "train_at_node_3" );

				// define the level.car4_panel for the shooters
				level.car4_panel = org_one;

				// thread off the other functions to run
				level thread e4_container_shooting_init();

///////////////////////////////////////////////////////////////////////////
// panel 1
///////////////////////////////////////////////////////////////////////////
				// set the level.car4_panel
				// level.car4_panel = sbrush_container_panel_0;

				// set can damage
				sbrush_container_panel_0 setcandamage( true );
				
				//DCS: adding damage to avoid ai not getting the job done.
				sbrush_container_panel_0 thread panel_damage_failsafe();				

				// define the i needed for the loop
				i_fx = 0;
				fx_dust = 0;
				while( sbrush_container_panel_0.health > 0 )
				{
								// make the health i need to check the panel's health
								int_health = sbrush_container_panel_0.health;

								// watch for damage
								sbrush_container_panel_0 waittill( "damage", iDamage, Attacker, vDirection, vPoint, sType, sModelName, sAttachTag, sTagName );

								// iprintlnbold( vPoint );

								if( Attacker == level.player )
								{
												// so if the player causes the damage it won't count
												sbrush_container_panel_0.health = int_health;
								}
								// make sure the guy shooting isn't the player
								else if( Attacker != level.player )
								{
												 // check to make sure i isn't too large
												if( i_fx < 25 )
												{
																// spawn the effect on it
																bullet_fx[i_fx] = spawnfx( level._effect["bullet_pierce"], level.car4_panel.origin + ( -15, randomintrange( -38, 38 ), randomintrange( -13, 13 ) ),  AnglesToForward( ( 0, 180, 0 ) ) );

																// frame wait
																wait( 0.05 );

																// trigger Fx
																TriggerFx( bullet_fx[i_fx] );

																// raise i by one
																i_fx++;

																// wait
																wait( 0.05 );
												}
									}
				}

				// play the dust fx
				// spawn the effect on it
				dust_fx[fx_dust] = spawnfx( level._effect["container_dust"], level.car4_panel.origin + ( -20, 0, 0 ) );
				fx_dust++;
				dust_fx[fx_dust] = spawnfx( level._effect["container_dust"], level.car4_panel.origin + ( -20, 18, 0 ) );
				fx_dust++;
				dust_fx[fx_dust] = spawnfx( level._effect["container_dust"], level.car4_panel.origin + ( -20, -18, 0 ) );

				// trigger Fx
				TriggerFx( dust_fx[0] );
				TriggerFx( dust_fx[1] );
				TriggerFx( dust_fx[2] );

				// wait
				wait( 0.15 );

				////// delete the fx in the array
				for( i=0; i<i_fx; i++ )
				{
								// delete the fx
								bullet_fx[i] delete();
				}

				// metal breaking sound hook

				// wait a moment, let the smoke fill out
				wait( 0.2 );

				// make panel notsolid
				sbrush_container_panel_0 notsolid();

				// hide the panel, this is where the swap happens
				sbrush_container_panel_0 unlink();
				sbrush_container_panel_0 delete();

				// show the destroyed version
				sbrush_container_panel_d_0 show();

				// solid the destroyed verion
				sbrush_container_panel_d_0 solid();

				// frame wait
				wait( 0.05 );

				// reset the fx counts
				i_fx = 0;
				fx_dust = 0;

///////////////////////////////////////////////////////////////////////////
// panel 2
///////////////////////////////////////////////////////////////////////////

				// define the level.car4_panel for the shooters
				level.car4_panel = org_two;

				// set can damage
				sbrush_container_panel_1 setcandamage( true );
				
				//DCS: adding damage to avoid ai not getting the job done.
				sbrush_container_panel_1 thread panel_damage_failsafe();				
				
				// define the i needed for the loop
				// i_fx = 0;
				while( sbrush_container_panel_1.health > 0 )
				{
								// print screen
								// level thread train_3d_text( level.car4_panel, 3000, "SHOOT HERE!",  ( 1, 1, 1 ), "car4_shoot", 1, 1.0 );



								// watch for damage
								sbrush_container_panel_1 waittill( "damage", iDamage, Attacker, vDirection, vPoint, sType, sModelName, sAttachTag, sTagName );

								// iprintlnbold( vPoint );

								if( Attacker == level.player )
								{
												// make sure the damage from the player doesn't register
												sbrush_container_panel_1.health = int_health;

								}
								// make sure the guy shooting isn't the player
								else if( Attacker != level.player )
								{
												// check to make sure i isn't too large
												if( i_fx < 25 )
												{
																// spawn the effect on it
																bullet_fx[i_fx] = spawnfx( level._effect["bullet_pierce"], level.car4_panel.origin + ( -16, randomintrange( -38, 38 ), randomintrange( -13, 13 ) ), AnglesToForward( ( 0, 180, 0 ) ) );

																// frame wait
																wait( 0.05 );

																// trigger Fx
																TriggerFx( bullet_fx[i_fx] );

																// raise i by one
																i_fx++;

																// wait
																wait( 0.05 );
												}

												 // debug text
												 // iprintlnbold( "health is " + sbrush_container_panel_1.health );
								}
				}
				
				// play the dust fx
				// spawn the effect on it
				dust_fx[fx_dust] = spawnfx( level._effect["container_dust"], level.car4_panel.origin + ( -20, 0, 0 ) );
				fx_dust++;
				dust_fx[fx_dust] = spawnfx( level._effect["container_dust"], level.car4_panel.origin + ( -20, 18, 0 ) );
				fx_dust++;
				dust_fx[fx_dust] = spawnfx( level._effect["container_dust"], level.car4_panel.origin + ( -20, -18, 0 ) );

				// trigger Fx
				TriggerFx( dust_fx[0] );
				TriggerFx( dust_fx[1] );
				TriggerFx( dust_fx[2] );

				// wait
				wait( 0.15 );

				////// delete the fx in the array
				for( i=0; i<i_fx; i++ )
				{
								// delete the fx
								bullet_fx[i] delete();
				}

				// metal breaking sound hook

				// wait a moment, let the smoke fill out
				wait( 0.2 );

				// make panel notsolid
				sbrush_container_panel_1 notsolid();

				// hide the panel, this is where the swap happens
				sbrush_container_panel_1 unlink();
				sbrush_container_panel_1 delete();

				// show the destroyed version
				sbrush_container_panel_d_1 show();

				// solid the wall
				sbrush_container_panel_d_1 solid();

				// frame wait
				wait( 0.05 );

				// reset the fx counts
				i_fx = 0;
				fx_dust = 0;

///////////////////////////////////////////////////////////////////////////
// panel 3
///////////////////////////////////////////////////////////////////////////

				// define the level.car4_panel for the shooters
				level.car4_panel = org_three;

				// set can damage
				sbrush_container_panel_2 setcandamage( true );
				
				//DCS: adding damage to avoid ai not getting the job done.
				sbrush_container_panel_2 thread panel_damage_failsafe();
				
				while( sbrush_container_panel_2.health > 0 )
				{
								// print screen
								// level thread train_3d_text( level.car4_panel, 3000, "SHOOT HERE!",  ( 1, 1, 1 ), "car4_shoot", 1, 1.0 );

								// watch for damage
								sbrush_container_panel_2 waittill( "damage", iDamage, Attacker, vDirection, vPoint, sType, sModelName, sAttachTag, sTagName );

								// iprintlnbold( vPoint );

								if( Attacker == level.player )
								{
												// make sure the damage from the player doesn't register
												sbrush_container_panel_2.health = int_health;

								}
								// make sure the guy shooting isn't the player
								else if( Attacker != level.player )
								{
												// check to make sure i isn't too large
												if( i_fx < 25 )
												{
																// spawn the effect on it
																bullet_fx[i_fx] = spawnfx( level._effect["bullet_pierce"], level.car4_panel.origin + ( -15, randomintrange( -38, 38 ), randomintrange( -13, 13 ) ),  AnglesToForward( ( 0, 180, 0 ) ) );

																// frame wait
																wait( 0.05 );

																// trigger Fx
																TriggerFx( bullet_fx[i_fx] );

																// raise i by one
																i_fx++;

																// wait
																wait( 0.1 );
												}

												 // debug text
												 // iprintlnbold( "health is " + sbrush_container_panel_2.health );
								}
				}
				
				// play the dust fx
				// spawn the effect on it
				dust_fx[fx_dust] = spawnfx( level._effect["container_dust"], level.car4_panel.origin + ( -20, 0, 0 ) );
				fx_dust++;
				dust_fx[fx_dust] = spawnfx( level._effect["container_dust"], level.car4_panel.origin + ( -20, 18, 0 ) );
				fx_dust++;
				dust_fx[fx_dust] = spawnfx( level._effect["container_dust"], level.car4_panel.origin + ( -20, -18, 0 ) );

				// trigger Fx
				TriggerFx( dust_fx[0] );
				TriggerFx( dust_fx[1] );
				TriggerFx( dust_fx[2] );

				// wait
				wait( 0.15 );

				////// delete the fx in the array
				for( i=0; i<i_fx; i++ )
				{
								// delete the fx
								bullet_fx[i] delete();
				}

				// metal breaking sound hook

				// wait a moment, let the smoke fill out
				wait( 0.2 );

				// make panel notsolid
				sbrush_container_panel_2 notsolid();

				// hide the panel, this is where the swap happens
				sbrush_container_panel_2 unlink();
				sbrush_container_panel_2 delete();

				// show the destroyed version
				sbrush_container_panel_d_2 show();

				// solid the destroyed version
				sbrush_container_panel_d_2 solid();

				// frame wait
				wait( 0.05 );

///////////////////////////////////////////////////////////////////////////
// panels done
///////////////////////////////////////////////////////////////////////////

				// make the player the new level var
				// level.car4_panel = level.player;

				// notify the first uncouple to start
				level flag_set( "car4_container_shoot" );
				level notify( "first_uncouple_start" );
				level notify( "e4_container_shoot_done" );

				// redefine the level var
				level.car4_panel = level.player;

				// unlink the script orgs and delete them
				org_one unlink();
				org_two unlink();
				org_three unlink();
				// delete them
				org_one delete();
				org_two delete();
				org_three delete();

}
// DCS: adding damage to panels slowly incase not being damaged properly from ai.
panel_damage_failsafe()
{
	while(IsDefined(self))
	{
		self dodamage(10, self.origin);
		wait(0.5);
		//iprintlnbold("giving some damage to panel.");
	}	
}	
///////////////////////////////////////////////////////////////////////////
// 07-16-08 WWilliams
// inits the functions that control the guys that shoot up the shipping
// container once the player is stuck in there
// runs on level
e4_container_shooting_init()
{
				// endon

				// objects to be defined for this function
				// spawners
				spawner_top = getent( "spwn_car4_top", "targetname" );
				spawner_bottom = getent( "spwn_car4_bottom", "targetname" );
				// node arrays
				noda_top_spots = getnodearray( "nod_top_shoot_container", "script_noteworthy" );
				noda_bottom_spots = getnodearray( "nod_bottom_shoot_container", "script_noteworthy" );
				// script_origin
				// level.car4_panel = getent( "ent_contain_shoot", "targetname" );
				// undefined
				ent_temp = undefined;

				// double check defined
				//assertex( isdefined( spawner_top ), "spawner_top not defined" );
				//assertex( isdefined( spawner_bottom ), "spawner_bottom not defined" );
				//assertex( isdefined( noda_top_spots ), "noda_top_spots not defined" );
				//assertex( isdefined( noda_bottom_spots ), "noda_bottom_spots not defined" );
				// assertex( isdefined( level.car4_panel ), "ent_contain_shoot not defined" );

				// set the correct counts for the spawners
				spawner_top.count = noda_top_spots.size;
				spawner_bottom.count = noda_bottom_spots.size;

				// send a guy to each node on the top
				for( i=0; i<noda_top_spots.size; i++ )
				{
								// spawn out a guy
								ent_temp = spawner_top stalingradspawn( "e4_container_shooter" );

								// make sure the spawn didn't fail
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												// debut text
												iprintlnbold( "spawner_top in e4 fail" );

												// wait
												wait( 2.0 );

												// end func
												return;
								}
								else
								{
												// perfect sense for a few seconds
												// ent_temp thread maps\MontenegroTrain_util::turn_on_sense( 3 );
												ent_temp setenablesense( false );

												// frame wait to allow perfect to kick in
												wait( 0.05 );

												// send to a goal
												ent_temp setgoalnode( noda_top_spots[i], 1 );

												// make the guy gun
												ent_temp setscriptspeed( "run" );

												// set his min alert state
												ent_temp setalertstatemin( "alert_red" );

												// tether the guy on node and reset the script speed
												ent_temp thread maps\MontenegroTrain_util::train_goal_n_tether( noda_top_spots[i], 32 );

												// thread off the function to control the situation
												level thread bottom_shooter_control( ent_temp, spawner_top, noda_top_spots[i] );

												// thread clean function on him
												level thread train_car4_cleaner( ent_temp );
												
												// frame wait
												wait( 0.05 );
								}

								// wait
								wait( 1.5 );

								// undefined ent_temp
								ent_temp = undefined;
				}

				// send a guy to each node on the bottom
				for( i=0; i<noda_bottom_spots.size; i++ )
				{
								// spawn out a guy
								ent_temp = spawner_bottom stalingradspawn( "e4_container_shooter" );

								// make sure the spawn didn't fail
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												// debut text
												iprintlnbold( "spawner_bottom in e4 fail" );

												// wait
												wait( 2.0 );

												// end func
												return;
								}
								else
								{
												// perfect sense for a few seconds
												ent_temp setenablesense( false );

												// frame wait to allow perfect to kick in
												wait( 0.05 );

												// send to a goal
												ent_temp setgoalnode( noda_bottom_spots[i], 1 );

												// make the guy gun
												ent_temp setscriptspeed( "run" );

												// set his min alert state
												ent_temp setalertstatemin( "alert_red" );

												// tether the guy on node and reset the script speed
												ent_temp thread maps\MontenegroTrain_util::train_goal_n_tether( noda_top_spots[i], 32 );

												// thread off the function to control the situation
												level thread bottom_shooter_control( ent_temp, spawner_bottom, noda_bottom_spots[i] );

												// thread clean function on him
												level thread train_car4_cleaner( ent_temp );

												// frame wait
												wait( 0.05 );
								}

								// wait
								wait( 1.5 );

								// undefined ent_temp
								ent_temp = undefined;
				}
}
///////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////
// 07-16-08 WWilliams
// function controls a single guy on the top floor of the obs car
// makes the guy fire down at the player in perfect sense 
// runs on level
top_shooter_control( ent_actor, ent_spawner, node_spot )
{
				// endon
				level endon( "e4_container_shoot_done" );

				// double check the objects passed in
				//assertex( isdefined( ent_actor ), "top_shooter ent_actor not defined" );
				//assertex( isdefined( ent_spawner ), "top_shooter ent_spawner not defined" );
				//assertex( isdefined( node_spot ), "top_shooter node_spot not defined" );

				// go into the loop
				while( 1 )
				{
								// wait for ent_actor to hit goal
								ent_actor waittill( "goal" );
								
								// iprintlnbold( "top guy hit goal" );

								// while the guy is alive
								while( isalive( ent_actor ) )
								{
												// double check the guy is alive
												if( isalive( ent_actor ) )
												{
																// shoot at the player for three seconds
																ent_actor cmdshootatentity( level.player, true, 3, 0.8 );

																//wait for the guy to finish
																ent_actor waittill("cmd_done");

																// debug text
																iprintlnbold( "top finished shooting" );

																// wait a frame in case
																wait( 0.05 );
												}

												// wait
												wait( randomint( 2 ) );
								}

								// if the guy is dead he needs to be replaced
								ent_actor = level car4_spawn_another_guy( ent_spawner, 1 );

								// make sure the guy is defined
								if( !isdefined( ent_actor ) )
								{
												// debug text
												iprintlnbold( "_another_guy didn't return a guy!" );

												// wait
												wait( 2.0 );

												// end function
												return;
								}

								// give him perfect sense
								ent_actor setperfectsense( true );

								// send the guy to the node
								ent_actor setgoalnode( node_spot, 1 );

				}
}
///////////////////////////////////////////////////////////////////////////
// 07-16-08 WWilliams
// function controls a single guy on the bottom floor of the obs car
// makes the guy fire at the script brushmodels that will fall off 
// runs off level
bottom_shooter_control( ent_actor, ent_spawner, node_spot )
{
				// endon
				level endon( "e4_container_shoot_done" );
				// double check the objects passed in
				//assertex( isdefined( ent_actor ), "bottom_shooter ent_actor not defined" );
				//assertex( isdefined( ent_spawner ), "bottom_shooter ent_spawner not defined" );
				//assertex( isdefined( node_spot ), "bottom_shooter node_spot not defined" );

				// go into the loop
				while( 1 )
				{
								// wait for ent_actor to hit goal
								ent_actor waittill( "goal" );

								// iprintlnbold( "bottom guy hit goal" );

								// while the guy is alive
								while( isalive( ent_actor ) )
								{
												// double check the guy is alive
												if( isalive( ent_actor ) )
												{
																if( ent_actor cansee( level.player ) )
																{
																				// shoot at the player for three seconds
																				// this guy shoots at the parts of the world
																				ent_actor cmdshootatentity( level.player, true, 5, 0.7 );

																				//wait for the guy to finish
																				ent_actor waittill( "cmd_done" );

																				// debug text
																				// iprintlnbold( "bottom finished shooting" );

																				// wait a frame in case
																				wait( 0.05 );
																}
																else
																{
																				// make sure the car4_panel is defined
																				//assertex( isdefined( level.car4_panel ), "level.car4_panel not defined" );

																				// shoot at the player for three seconds
																				// this guy shoots at the parts of the world
																				ent_actor cmdshootatentity( level.car4_panel, true, 5, 0.5 );

																				//wait for the guy to finish
																				ent_actor waittill("cmd_done");

																				// debug text
																				// iprintlnbold( "bottom finished shooting" );

																				// wait a frame in case
																				wait( 0.05 );
																}
												}

												// wait
												wait( randomint( 2 ) );
								}

								// if the guy is dead he needs to be replaced
								ent_actor = level car4_spawn_another_guy( ent_spawner, 0 );

								// make sure the guy is defined
								if( !isdefined( ent_actor ) )
								{
												// debug text
												iprintlnbold( "_another_guy didn't return a guy!" );

												// wait
												wait( 2.0 );

												// end function
												return;
								}

								// give him perfect sense
								ent_actor thread maps\MontenegroTrain_util::turn_on_sense( 2 );

								// send the guy to the node
								ent_actor setgoalnode( node_spot, 1 );

				}

}
//////////////////////////////////////////////////////////////////////////
// 07-16-08 WWilliams
// function spawns out a new guy from teh spawner passed in and returns him
// and checks to see which floor is asking for a new guy: 0=bottom, 1=top
// runs on level
car4_spawn_another_guy( spawner, int_floor )
{
				// make sure the object passed in is valid
				//assertex( isdefined( spawner ), "another_guy spawner not valid!" );
				//assertex( isdefined( int_floor ), "another_guy int_floor not valid!" );

				// define objects needed for the function
				// undefined
				ent_temp = undefined;

				// check to see if it is the bottom floor
				if( int_floor == 0 )
				{
								// check to see if the flag is set
								while( maps\_utility::flag( "car4_bottom_spawner" ) )
								{
												// wait
												wait( 0.25 );
								}
				}
				else if( int_floor == 1 )
				{
								// check to see if the flag is set
								while( maps\_utility::flag( "car4_top_spawner" ) )
								{
												// wait
												wait( 0.25 );
								}
				}

				// if the function needs the spawner then set the flag
				if( int_floor == 0 )
				{
								// set the flag
								maps\_utility::flag_set( "car4_bottom_spawner" );

								// check the count of the spawner
								if( spawner.count <= 1 )
								{
												// give five count in case the count is equal or less than one
												spawner.count = 5;
								}

								// spawn out the guy
								ent_temp = spawner stalingradspawn( "e4_container_shooter" );

								// check to see if spawn failed
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												// debug text
												iprintlnbold( "fail spawn in _another_guy" + spawner.targetname );

												// wait
												wait( 2.0 );

												// end function
												return;
								}
								// if spawn passes
								{
												// wait a sec to let the guy get out of the area
												wait( 1.0 );

												// clear the flag
												maps\_utility::flag_clear( "car4_bottom_spawner" );

												// thread clean function on him
												level thread train_car4_cleaner( ent_temp );

												// return the guy
												return ent_temp;
								}
				}
				else if( int_floor == 1 )
				{
								// set the flag
								maps\_utility::flag_set( "car4_top_spawner" );

								// check the count of the spawner
								if( spawner.count <= 1 )
								{
												// give five count in case the count is equal or less than one
												spawner.count = 5;
								}

								// spawn out the guy
								ent_temp = spawner stalingradspawn( "e4_container_shooter" );

								// check to see if spawn failed
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												// debug text
												iprintlnbold( "fail spawn in _another_guy with " + spawner.targetname );

												// wait
												wait( 2.0 );

												// end function
												return;
								}
								// if spawn passes
								{
												// wait a sec to let the guy get out of the area
												wait( 1.0 );

												// clear the flag
												maps\_utility::flag_clear( "car4_top_spawner" );

												// return the guy
												return ent_temp;
								}
				}
}
///////////////////////////////////////////////////////////////////////////
// 07-17-08 WWilliams
// function makes text show up on the screen
// runs on level
train_3d_text( ent_spot, seconds, str_text, vec_color, str_notify, int_alpha, flt_scale )
{
				// endon
				level endon( "no_more_3d" );

				// double check defined
				//assertex( isdefined( ent_spot ), "ent_spot not defined" );
				//assertex( isdefined( seconds ), "seconds not defined" );
				//assertex( isdefined( str_text ), "str_text not defined" );
				//assertex( isdefined( vec_color ), "vec_color not defined" );
				//assertex( isdefined( str_notify ), "str_notify not defined" );
				//assertex( isdefined( int_alpha ), "int_alpha not defined" );
				//assertex( isdefined( flt_scale ), "flt_scale not defined" );

				// make the position
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
								//tell me he's there and getting a ticket
								print3d( vec_text_position, str_text, vec_color, int_alpha, flt_scale );
								wait( 0.05 );
				}
}
//////////////////////////////////////////////////////////////////////////
// 07-17-08 WWilliams
// delete the guys who were shooting at the container
// this is a quick clean up that needs to change later
// runs on level
train_car4_cleaner( ent_actor )
{
				// double check passed in ent
				//assertex( isdefined( ent_actor ), "ent_actor is not defined" );

				// endon
				ent_actor endon( "death" );

				// objects to define for this function
				node_escape = GetNode( "shoot_up_escape", "targetname" );

				// wait for notify
				level waittill( "e4_container_shoot_done" );

				// turn off guy
				ent_actor setenablesense( false );

				// hide guy
				ent_actor setgoalnode( node_escape );

				// while loop until the guys gets close enough
				while( distancesquared( ent_actor.origin, node_escape.origin ) > 120*120 )
				{
								// wait
								wait( 0.1 );
				}
				
				// check to see if the player cansee them
				if( ent_actor cansee( level.player ) )
				{
								// set goal node again
								ent_actor setgoalnode( node_escape );

								// wait for goal
								ent_actor waittill( "goal" );
				}

				// hide the guy
				ent_actor hide();

				// delete him
				ent_actor delete();
}
//////////////////////////////////////////////////////////////////////////
// 04-25-08
// wwilliams
// trigger wait for the player to jump back to the passenger train
// runs on level
//////////////////////////////////////////////////////////////////////////
e4_passenger_jump_back()
{
				// endon
				// single shot function
				//level endon( "Train_Bond_Jump_done" );

				// objects to be defined for this function
				// triggers
				trig = getent( "trig_play_jump_anim", "targetname" );
				// look at trigger
				look_at_trig = getent( "trig_lookat_box_fall", "targetname" );

				// double check defines
				//assertex( isdefined( trig ), "jump trig not defined" );
				//assertex( isdefined( look_at_trig ), "trig for jump box drop not defined" );

				// thread off the hint string func
				level thread e4_jump_trigger_hint( trig );

				// wait for the player to see the trig
				look_at_trig waittill( "trigger" );

				// save game
				level thread maps\_autosave::autosave_by_name( "montenegrotrain", 10.0 );

				// delete the freight dynamics
				// level thread freight_light_delete();

				// play the fxanim
				level notify( "jump_break_start" );

				//Steve G
				//iprintlnbold("CRATE FALLS");
				thread maps\montenegrotrain_snd::crate_fall_sounds();

				// wait for the trig hit
				trig waittill( "trigger" );

				// while loop waits for the player to be touching the trigger and hit jump
				while( 1 )
				{
								// watch for the player to be in the trigger
								if( level.player istouching( trig ) )
								{
												// make sure the player is touching
												while( level.player istouching( trig ) )
												{
																// wait for the button press
																if( level.player JumpButtonPressed() )
																{
																				// clean up bodies function
																				deleteallcorpses( 1 );

																				// make the player invincible during the jump
																				// level.player SetCanDamage( false );

																				// play the animation
																				playcutscene( "Train_Bond_Jump", "Train_Bond_Jump_done" );

																				// notify to turn off the hint string
																				level notify( "jump_trig_hint_off" );

																				//End Action Music - Added by crussom
																				level notify( "endmusicpackage" );

																				// thread off the dialogue function
																				level thread train_jump_back_dialogue();

																				//Steve G
																				level.player playsound("igc_jump_from_freight");

																				// wait for the notify
																				level waittill( "Train_Bond_Jump_done" );
																				
																				// DCS: trigger forth set of fx entities.
																				level notify("start_fxgroup_5");

																				// turn off magic_bullet_shield
																				// level.player SetCanDamage( true );

																				// wait a frame
																				wait( 0.05 );

																				// save the game
																				// SaveGame( "montenegrotrain" );
																				level thread maps\_autosave::autosave_now( "montenegrotrain" );

																				// should just be able to leave the function now
																				return;
																}

																// avoid a potential infinite script loop
																wait( 0.05 );
												}
								}

								// avoid a potential infinite script loop
								wait( 0.05 );
				}

				// might have to change the player's orientation when this is over

}
///////////////////////////////////////////////////////////////////////////
// 08-14-08 WWilliams
// special function to delete all of the level.freight_lights from teh freight
//freight_light_delete()
//{
//				// endon
//				// single shot
//
//				// objects to define for this function
//				// using the level.freight_lights
//				// need a base amount for the for loop
//				int_amount = level.freight_lights.size;
//
//				// make sure the light count is the right amount
//				if( level.freight_lights.size > 0 )
//				{
//								// print out the amount
//								// iprintlnbold( level.freight_lights.size + " size of freight lights" );
//				}
//				else
//				{
//								// debug text
//								// iprintlnbold( "freight lights are zero!" );
//				}
//
//				// for loop goes through the lights, unlinks them and deletes them
//				for( i=0; i<int_amount; i++ )
//				{
//								// unlink the light
//								level.freight_lights[i] unlink();
//
//								level.freight_lights[i] setlightintensity( 0 );
//
//								// wait a frame
//								wait( 0.05 );
//
//								// delete the light
//								// level.freight_lights[i] delete();
//
//								// frame wait
//								wait( 0.05 );
//
//								// check to see if script can see the radius
//								if( isdefined( level.freight_lights[i].radius ) )
//								{
//												// set the radius to zero
//												level.freight_lights[i].radius = 0;
//								}
//								else
//								{
//												// debug text
//												// iprintlnbold( "freight lights can't modify radius" );
//								}
//				}
//
//				// wait a frame
//				wait( 0.05 );
//
//				// debug text
//				// iprintlnbold( "done delete dynamic freight lights" );
//}
///////////////////////////////////////////////////////////////////////////
// 07-28-08 WWilliams
// turns on the hint string for the trigger that jumps back
e4_jump_trigger_hint( trig )
{
				// endon
				level endon( "jump_trig_hint_off" );

				// double check define passed in
				//assertex( isdefined( trig ), "trig for jump back not defined" );

				// thread off the clear function
				level thread e4_jump_trigger_hint_off( trig );

				// while loop 
				while( 1 )
				{
								// wait for the trigger to hit
								trig waittill( "trigger" );

								// while player is in the trigger
								while( level.player istouching( trig ) )
								{
												// turn on the hint string
												level.player SetCursorHint( "HINT_JUMP" );
												level.player SetHintString( &"HINT_JUMP" );

												// wait
												wait( 0.05 );

								}

								// when the player is not touching the trigger turn it off
								// give the trig the right cursor hints
								level.player SetCursorHint( "" );
								level.player SetHintString( "" );

								// wait
								wait( 0.05 );
				}

}
//////////////////////////////////////////////////////////////////////////
// 07-28-08 WWilliams
// clears the hint string once hte player has jumped
e4_jump_trigger_hint_off( trig )
{
				// endon
				// single shot function

				// double check passed in
				//assertex( isdefined( trig ), "trig for jump back not defined" );

				// wait for trin jump notify to hit
				level waittill( "jump_trig_hint_off" );

				// clear the hint string
				level.player SetCursorHint( "" );
				level.player SetHintString( "" );
}
//////////////////////////////////////////////////////////////////////////
// WW 07-01-08
// function plays the three lines of dialogue between Tanner and Bond
// as Bond jumps back to the passenger train
// runs on level
train_jump_back_dialogue()
{
				// endon
				// single shot function

				// line 1 - tanner
				level.player play_dialogue( "TANN_TraiG_048A", true );

				//// line 2 - bond
				//level.player play_dialogue( "BOND_TraiG_047A" );

				//// line 3 - tanner
				//level.player play_dialogue( "TANN_TraiG_048A", true );
}
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////////////////////
// 05-01-08
// wwilliams
// spawns out a single guy to take a position and shoot from it to alert the player
// runs on level
//////////////////////////////////////////////////////////////////////////
car4_enemy_announce()
{
				// endon
				level endon( "player_shot_first" );

				// objects to be defined for this function
				// spawner
				car4_notify_spwn = getent( "car4_notify_spwn", "targetname" );
				// ent
				car4_notify_guy1 = undefined;
				car4_notify_guy2 = undefined;
				// trig
				spot_trig = getent( "trig_car4_spot", "targetname" );

				// set the count of the spawner
				car4_notify_spwn.count = 5;

				// spawn out guy one
				car4_notify_guy1 = car4_notify_spwn stalingradspawn( "car4_announcer" );
				// make sure it didn't fail
				if( maps\_utility::spawn_failed( car4_notify_guy1 ) )
				{
								// debug text
								iprintlnbold( "car4_notify_guy1 spawn fail" );
				}
				else
				{
								// thread his function on him
								car4_notify_guy1 thread car4_announcer1_control();
				}
				
				// wait for a second before spawning out the second guy
				wait( 1.0 );

				// spawn out the second guy
				car4_notify_guy2 = car4_notify_spwn stalingradspawn( "car4_announcer" );
				// make sure spawn passed
				if( maps\_utility::spawn_failed( car4_notify_guy2 ) )
				{
								// debug text
								iprintlnbold( "car4_notify_guy2 spawn fail" );
				}
				else
				{
								// thread the function off on the guy
								car4_notify_guy2 thread car4_announcer2_control();
				}

				// wait for the trig hit
				spot_trig waittill( "trigger" );

				// set the flag
				level maps\_utility::flag_set( "car4_populate" );

				// delete the spawner
				car4_notify_spwn delete();

				// removes these guys if the player runs past them
				level thread car4_clean_announcers();
}
//////////////////////////////////////////////////////////////////////////
// 08-12-08 WWilliams
// car4_announcer1 function
// runs on the guy/self
car4_announcer1_control()
{
				// endon
				self endon( "death" );
				// self endon( "damage" );

				// objects to defined for this function
				// nodes
				wait_node = GetNode( "car4_announce1_wait", "targetname" );
				fight_node = getnode( "car4_announce1_fight", "targetname" );

				// set the guy up 
				self setcombatrole( "support" );
				self setengagerule( "tgtSight" );
				self addengagerule( "tgtPerceive" );
				self addengagerule( "Damaged" );
				self addengagerule( "Attacked" );
				self setpropagationdelay( 0 );

				// change script_speed to run
				self setscriptspeed( "run" );

				// set alert state
				self setalertstatemin( "alert_green" );

				// go to the wait node
				self setgoalnode( wait_node );

				// wait for the ai to hit goal
				self waittill( "goal" );

				// once at goal just fidget until it is time
				while( !maps\_utility::flag( "car4_populate" ) )
				{
								// play fidget anim
								self cmdaction( "fidget" );

								// wait for the cmd to end
								self waittill( "cmd_done" );

								// random wait
								wait( 0.1 );

								// check the guy's alert state
								if( self getalertstate() != "alert_green" && level.player_shot_first == 0 )
								{
												// fire off function to set off car 4
												level car4_player_shot_first();
								}
				}

				// setup perfect sense momentarily for this guy
				self thread maps\MontenegroTrain_util::turn_on_sense();

				// change alert state
				self setalertstatemin( "alert_red" );

				// play dialogue on this guy
				self play_dialogue_nowait( "TMR3_TraiG_030A" );

				// go to fight node
				self setgoalnode( fight_node, 1 );

				// tether him to this node
				// self thread maps\MontenegroTrain_util::train_reset_speed_activate_tether( fight_node, 384, 900, 256 );
				self thread maps\MontenegroTrain_util::train_goal_n_tether( fight_node, 128 );

}
//////////////////////////////////////////////////////////////////////////
// 08-12-08 WWilliams
// car4_announcer2 function
// runs on the guy/self
car4_announcer2_control()
{
				// endon
				self endon( "death" );
				// self endon( "damage" );

				// objects to defined for this function
				// nodes
				wait_node = GetNode( "car4_announce2_wait", "targetname" );
				fight_node = getnode( "car4_announce2_fight", "targetname" );

				// set the guy up 
				self setcombatrole( "guardian" );
				self setengagerule( "tgtSight" );
				self addengagerule( "tgtPerceive" );
				self addengagerule( "Damaged" );
				self addengagerule( "Attacked" );
				self setpropagationdelay( 0 );

				// change script_speed to run
				self setscriptspeed( "run" );

				// set alert state
				self setalertstatemin( "alert_green" );

				// go to the wait node
				self setgoalnode( wait_node );

				// wait for the ai to hit goal
				self waittill( "goal" );

				// once at goal just fidget until it is time
				while( !maps\_utility::flag( "car4_populate" ) )
				{
								// play fidget anim
								self cmdaction( "fidget" );

								// wait for the cmd to end
								self waittill( "cmd_done" );

								// random wait
								wait( 0.1 );

								// check the guy's alert state
								if( self getalertstate() != "alert_green" && level.player_shot_first == 0 )
								{
												// fire off function to set off car 4
												level car4_player_shot_first();
								}
				}

				// wait
				// wait( 1.0 );

				// setup perfect sense momentarily for this guy
				self thread maps\MontenegroTrain_util::turn_on_sense();

				// change alert state
				self setalertstatemin( "alert_red" );

				// play dialogue on this guy
				self play_dialogue_nowait( "TMR4_TraiG_031A" );

				// go to fight node
				self setgoalnode( fight_node, 1 );

				// tether him to this node
				// self thread maps\MontenegroTrain_util::train_reset_speed_activate_tether( fight_node, 384, 900, 256 );
				self thread maps\MontenegroTrain_util::train_goal_n_tether( fight_node, 128 );

}
///////////////////////////////////////////////////////////////////////////
// 08-18-08 WWilliams
// cleans the car4 announcers if the player just rushes by them
car4_clean_announcers()
{
				// endon

				// objects to defined for this function
				// ent array
				enta_car4_announcers = getentarray( "car4_announcer", "targetname" );
				// trig
				trig = getent( "trig_spwn_bottom_crossfire", "targetname" );
				// node
				dest_node = GetNode( "nod_remove_announcers", "targetname" );

				// wait for the trigger
				trig waittill( "trigger" );

				// check to make sure the array has a count
				if( enta_car4_announcers.size == 0 )
				{
								// end function
								return;
				}

				// remove dead
				enta_car4_announcers = maps\_utility::array_removeDead( enta_car4_announcers );

				// frame wait
				wait( 0.05 );

				// for loop for the guys
				for( i=0; i<enta_car4_announcers.size; i++ )
				{
								// reset the tether on the guy
								enta_car4_announcers[i] settetherradius( -1 ); 

								// send them to the node
								enta_car4_announcers[i] setgoalnode( dest_node );

								// function waits for them to hit goal and deletes them
								level thread hit_goal_delete( enta_car4_announcers[i] );
				}

}
///////////////////////////////////////////////////////////////////////////
// 08-27-08 WWilliams
// sets off the car4 populate in case the player shoots from the top of the 
// blue container crate
car4_player_shot_first()
{
				// endon

				// notify to stop the main announcer func
				level notify( "player_shot_first" );

				// set level var
				level.player_shot_first = 1;

				// objects to define for this function
				car4_notify_spwn = getent( "car4_notify_spwn", "targetname" );
				
				// in case the flag has already been set
				if( !maps\_utility::flag( "car4_populate" ) )
				{
								// set the flag
								maps\_utility::flag_set( "car4_populate" );
				}
				
				// make sure the spawner is still around
				if( isdefined( car4_notify_spwn ) )
				{
								// delete the spawner
								car4_notify_spwn delete();

								// removes these guys if the player runs past them
								level thread car4_clean_announcers();
				}
}
///////////////////////////////////////////////////////////////////////////
// 08-18-08 WWilliams
// hit goal and delete the guy
hit_goal_delete( ent_actor )
{
				// wait for goal
				ent_actor waittill( "goal" );

				// hide
				ent_actor hide();

				// delete
				ent_actor delete();
}
//////////////////////////////////////////////////////////////////////////
// 05-02-08
// wwilliams
// the main chunk of guys who fight from the ob car
// runs on level
//////////////////////////////////////////////////////////////////////////
car4_crossfire()
{
				// endon
				// level.player endon( "death" );

				// objects to be defined for the function
				// trigger
				trig_lower_crossfire = getent( "trig_car4_spot", "targetname" );
				trig_top_crossfire = getent( "trig_spwn_bottom_crossfire", "targetname" );

				// wait for the announce guy to react before sending these guys to their place
				// level flag_wait( "car4_populate" );
				trig_lower_crossfire waittill( "trigger" );

				// fire off the first set of guys
				level thread car4_crossfire_low();

				// clean up the top_crossfire trig
				//trig_lower_crossfire unlink();
				//wait( 0.05 );
				//trig_lower_crossfire delete();


				// wait for the trigger hit
				trig_top_crossfire waittill( "trigger" );

				// fire off the top guys
				level thread car4_crossfire_high();

				// clean up
				trig_top_crossfire unlink();
				wait( 0.05 );
				trig_top_crossfire delete();


				// debug text
				// iprintlnbold( "e4_crossfire complete" );
				// 07-16-08 WWilliams
				// DON'T DELETE THESE SPAWNERS!
				// THEY ARE USED FOR ANOTHER PART OF THIS EVENT!
}
///////////////////////////////////////////////////////////////////////////
car4_crossfire_low()
{
				// endon

				// objects to define for the function
				// spawner
				spawner_bottom = getent( "spwn_car4_bottom", "targetname" );
				// node
				car4_noda_bottom = getnodearray( spawner_bottom.script_parameters, "targetname" );
				car4_noda_btm_reset = [];
				// undefined
				ent_temp = undefined;

				// set the right count
				spawner_bottom.count = car4_noda_bottom.size;

				// wait to make sure the other guys get into position
				wait( 2.0 );

				// for loop spawns out a guy per node
				for( i=0; i<car4_noda_bottom.size; i++ )
				{
								// spawn out a guy
								ent_temp = spawner_bottom stalingradspawn( "e4_crossfire" );

								// check to see if the guy failed spawn
								if( spawn_failed( ent_temp ) )
								{
												// debug text
												iprintlnbold( "car4_crossfire_low spawn fail " + i + "" );

												// stop function
												break;
								}

								// guy spawned out properly, set him up
								// set the engage rule on the guy
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );

								// lock the guy to alert red
								ent_temp setalertstatemin( "alert_red" );

								// set the guy's speed
								ent_temp setscriptspeed( "run" );

								// give them perfect sense for five seconds
								// ent_temp thread maps\MontenegroTrain_util::turn_on_sense( 5 );
								ent_temp setperfectsense( true );

								// even guys don't shoot and run
								if( ( i + 1 ) % 2 == 0 )
								{
												// send him to his node
												ent_temp setgoalnode( car4_noda_bottom[i] );
								}
								// odd guys do
								else
								{
												// send him to his node
												ent_temp setgoalnode( car4_noda_bottom[i], 1 );
								}

								// tether him to this node
								// ent_temp thread maps\MontenegroTrain_util::train_reset_speed_activate_tether( car4_noda_bottom[i], 32, 72, 24 );
								ent_temp thread maps\MontenegroTrain_util::train_goal_n_tether( car4_noda_bottom[i], 64 );

								// undefine e4_dood for the next loop
								ent_temp = undefined;

								// quick wait
								wait( 1.5 );
				}

}
///////////////////////////////////////////////////////////////////////////
// 08-12-08 WWilliams
// controls the top guys who run into car4
car4_crossfire_high()
{
				// endon

				// objects to define for this function
				// spawner
				spawner_top = getent( "spwn_car4_top", "targetname" );
				// node array
				car4_noda_top = getnodearray( spawner_top.script_parameters, "targetname" );
				// undefined
				ent_temp = undefined;
				nod_temp = undefined;

				// make sure the spawner has the correct count
				spawner_top.count = car4_noda_top.size;

				// spawn out the top guys
				for( i=0; i<car4_noda_top.size; i++ )
				{
								// spawn out a guy
								ent_temp = spawner_top stalingradspawn( "e4_crossfire" );

								// check to see if the guy failed spawn
								if( spawn_failed( ent_temp ) )
								{
												// debug text
												iprintlnbold( "spawner_bottom_spawn_fail_on_loop " + i + "" );

												// stop function
												break;
								}

								// guy spawned out properly, set him up
								// set the engage rule on the guy
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );

								// lock the guy to alert red
								ent_temp setalertstatemin( "alert_red" );

								// set the guy's speed
								ent_temp setscriptspeed( "run" );

								// turn on sense
								// ent_temp thread maps\MontenegroTrain_util::turn_on_sense( 5 );
								ent_temp setperfectsense( true );

								// go through the nodes again
								for( j=0; j<car4_noda_top.size; j++ )
								{
												// make sure that the one farthest away matches the big loop
												if( car4_noda_top[j].script_int == i )
												{
																// if the script int matches the loop then make the node_temp that one
																nod_temp = car4_noda_top[j];

																// break
																break;

												}
												// if is doesn't match
												else
												{
																// go to the next loop
																continue;
												}
								}

								// give them perfect sense for five seconds
								ent_temp thread maps\MontenegroTrain_util::turn_on_sense( 5 );

								// send him to his node
								ent_temp setgoalnode( nod_temp );

								// tether him to this node
								// ent_temp thread maps\MontenegroTrain_util::train_reset_speed_activate_tether( nod_temp, 32, 72, 24 );
								ent_temp thread maps\MontenegroTrain_util::train_goal_n_tether( nod_temp, 64 );

								// quick wait
								wait( 1.0 );

								// undefine e4_dood for the next loop
								ent_temp = undefined;
								node_temp = undefined;
				}

				// wait half a sec
				wait( 0.5 );

				// thread off the check for crossfire to be done
				level thread car4_crossfire_done();
}
///////////////////////////////////////////////////////////////////////////
// 08-12-08 WWilliams
// watch for the crossfire guys to be dead before starting contranbard
car4_crossfire_done()
{
				// endon

				// objects to defined for this function
				enta_crossfire_guys = getentarray( "e4_crossfire", "targetname" );

				// check to make sure the array is defined
				//assertex( isdefined( enta_crossfire_guys ), "enta_crossfire_guys not defined" );

				// while the size of teh array is greater than 0
				while( enta_crossfire_guys.size > 0 )
				{
								// wait
								wait( 0.5 );

								// remove the dead from the array
								enta_crossfire_guys = level maps\_utility::array_removedead( enta_crossfire_guys );
				}

				// save the game
				level maps\_autosave::autosave_by_name( "montenegrotrain", 10.0 );

				// set the flag for contraband to start
				level maps\_utility::flag_set( "car4_boxcar_surprise" );

				// back up plan
				// level thread Open_contraband_door();

}
///////////////////////////////////////////////////////////////////////////
// 08-14-08 WWilliams
// roof_runners, makes the guys run down the top of a luggage car
// this is called from boxcar surprise, 
// which should allow the first two guys to be set up
roof_runners_init()
{
				// endon

				// objects to define for this function
				// spawner
				spawner_roof_runners = getent( "roof_runners_spawner", "targetname" );
				// trigger
				trig_roof_runners = getent( "roof_runners_start", "targetname" );
				trig_stop_runners = getent( "trig_move_from_train2", "targetname" );
				// node
				node_end_run = GetNode( "roof_runners_end", "targetname" );
				// undefined
				ent_temp = undefined;
				int_amount = undefined;

				// double check the defines
				//assertex( isdefined( spawner_roof_runners ), "spawner_roof_runners not defined" );
				//assertex( isdefined( trig_roof_runners ), "trig_roof_runners not defined" );
				//assertex( isdefined( trig_stop_runners ), "trig_stop_runners not defined" );

				// make sure the count of the spawner is ten
				spawner_roof_runners.count = 10;

				// set up the clean function
				level thread roof_runner_cleaner();

				// send off the first guy,
				ent_temp = spawner_roof_runners stalingradspawn( "roof_runner" );
				// check to see if the spawn failed
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								// debug text
								iprintlnbold( "first roof runner fail" );
				}
				else
				{
								// thread this guy into his own function
								ent_temp thread roof_runner_door();

								// wait
								wait( 0.05 );
				}

				// wait half a sec
				wait( 1.0 );

				// undefine ent_temp 
				ent_temp = undefined;

				// spawn out the second guy
				ent_temp = spawner_roof_runners stalingradspawn( "roof_runner" );
				// make sure the spawn didn't fail
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								// debug text
								iprintlnbold( "second roof runner fail" );
				}
				else
				{
								// thread this guy into his own function
								ent_temp thread roof_runner_top_shooter();

								// wait
								wait( 0.05 );
				}

				// wait a second
				wait( 1.0 );

				// wait for the player to hit the trigger
				trig_roof_runners waittill( "trigger" );

				// save game
				level thread maps\_autosave::autosave_by_name( "montenegrotrain", 10.0 );

				// get the count in another object
				int_amount = spawner_roof_runners.count;

				// while loop will spawn out more runners until
				// the player drops into the trap container
				// or the spawner runs count out
				while( !level.player istouching( trig_stop_runners ) && spawner_roof_runners.count > 0 )
				{
								// avoid infinite script loop
								wait( 0.05 );

								// for loop makes sure only the amount of the count spawns out
								for( i=0; i<int_amount; i++ )
								{
												// spawn out a guy
												ent_temp = spawner_roof_runners stalingradspawn( "roof_runner" );
												// make sure the spawn worked
												if( maps\_utility::spawn_failed( ent_temp ) )
												{
																// debug text
																iprintlnbold( "a roof runner failed spawn!" );
												}
												else
												{
																// set the guy up
																ent_temp setscriptspeed( "sprint" );
																ent_temp setalertstatemin( "alert_red" );

																// wait
																wait( 0.2 );

																// send him to the end node
																ent_temp setgoalnode( node_end_run );

																// thread the function on the guy
																level thread roof_runner( ent_temp );

																// wait so guys don't clump up
																wait( 3.0 );
												}
												
												// wait
												wait( 0.5 );

								}
								
								// another safe guard against infinite script loops
								wait( 0.05 );
				}

				// wait
				wait( 1.0 );

				// clean up the spawner
				// 08-20-08 WWilliams, don't delete this spawner, will use it for the jumpers
				// spawner_roof_runners delete();
				ent_temp = undefined;
				int_amount = undefined;

}
///////////////////////////////////////////////////////////////////////////
// 08-14-08 WWilliams
// controls the first roof runner who opens the luggage door
// runs on the guy
roof_runner_door()
{
				// endon
				self endon( "death" );

				// objects to define for this function
				// nodes
				dest_node = GetNode( "roof_runners_door_attacker", "targetname" );
				// sbrush door
				door = getent( "train_car5_shooter_door", "targetname" );
				// trig
				trig = getent( "roof_runners_start", "targetname" );
				trig_stop_runners = getent( "trig_move_from_train2", "targetname" );

				// double check defines
				//assertex( isdefined( dest_node ), "roof runner door node not defined" );
				//assertex( isdefined( door ), "roof runner door not defined" );
				//assertex( isdefined( trig ), "roof runner door trig not defined" );

				// set the guy up
				self setscriptspeed( "sprint" );
				self setalertstatemin( "alert_red" );
				self setenablesense( false );
				self setcombatrole( "support" );

				// send him to his node
				self setgoalnode( dest_node );

				// wait for goal
				self waittill( "goal" );

				// give tether point
				self.tetherpt = dest_node.origin;

				// set tether distance
				self settetherradius( 64 );

				// wait for trigger
				trig waittill( "trigger" );

				wait( 1.5 );

				// turn his sense back on
				self setenablesense( true );

				// move the door out of the way
				// door movey( 125, 1.5, 0.2, 0.3 );

				// wait a second
				// wait( 1.0 );

				// give the guy perfect sense
				self thread maps\MontenegroTrain_util::turn_on_sense( 25 );

				// wait a frame to allow it to kick in
				wait( 0.05 );

				// make guy shoot at the player
				self cmdshootatentity( level.player, true, 10, 0.0 );

				// wait for the player to fall into the container
				trig_stop_runners waittill( "trigger" );

				// get rid of this guy
				self hide();

				// frame wait
				wait( 0.05 );

				// delete the guy
				self delete();

}
///////////////////////////////////////////////////////////////////////////
// 08-14-08 WWilliams
// controls the guy who will shoot from the roof
// runs on the guy
roof_runner_top_shooter()
{
				// endon
				self endon( "death" );

				// objects to define for this function
				dest_node = GetNode( "roof_runners_fin_attacker", "targetname" );
				// trig
				trig = getent( "roof_runners_start", "targetname" );
				trig_stop_runners = getent( "trig_move_from_train2", "targetname" );

				// set the guy up
				self setscriptspeed( "sprint" );
				self setalertstatemin( "alert_red" );
				self setenablesense( false );
				self setcombatrole( "support" );

				// send him to his node
				self setgoalnode( dest_node );

				// wait for goal
				self waittill( "goal" );

				// give tether point
				self.tetherpt = dest_node.origin;

				// set tether distance
				self settetherradius( 64 );

				// wait for the trig
				trig waittill( "trigger" );

				wait( 1.5 );

				// turn his sense back on
				self setenablesense( true );

				// wait a second
				wait( 2.0 );

				// give the guy perfect sense
				self thread maps\MontenegroTrain_util::turn_on_sense( 25 );

				// wait a frame to allow it to kick in
				wait( 0.05 );

				// make guy shoot at the player
				self cmdshootatentity( level.player, true, 10, 0 );

				// wait for the player to fall into the container
				trig_stop_runners waittill( "trigger" );

				// get rid of this guy
				self hide();

				// frame wait
				wait( 0.05 );

				// delete the guy
				self delete();
}
///////////////////////////////////////////////////////////////////////////
// 08-14-08 WWilliams
// controls each guy who runs to the end node and deletes them
// runs on the guy
roof_runner( ent_actor )
{
				// endon
				ent_actor endon( "death" );

				// turn off the sense
				ent_actor setenablesense( false );

				// wait for goal
				ent_actor waittill( "goal" );

				// hide 
				ent_actor hide();

				// delete guy
				ent_actor delete();

}
///////////////////////////////////////////////////////////////////////////
// 08-14-08 WWilliams
// cleans up the roof runners once the player is in the trap container
// runs on level
roof_runner_cleaner()
{
				// endon
				// single shot

				// objects to defined for this function
				// trigs
				trig_end = getent( "trig_move_from_train2", "targetname" );
				// undefined
				int_amount = undefined;

				// wait for the trigger to hit
				trig_end waittill( "trigger" );

				// wait four seconds
				wait( 4.0 );

				// grab all the guys
				enta_roof_runners = getentarray( "roof_runner", "targetname" );

				// wait a frame
				wait( 0.05 );

				enta_roof_runners = maps\_utility::array_removeDead( enta_roof_runners );
				wait( 0.05 );
				enta_roof_runners = maps\_utility::array_removeUndefined( enta_roof_runners );


				// check the count
				if( !isdefined( enta_roof_runners ) || enta_roof_runners.size == 0 )
				{
								// debug text
								// iprintlnbold( "all roof runners gone!" );

								// end function
								return;
				}
				else
				{
								// set the count to another object
								// int_amount = enta_roof_runners.size;

								// for loop goes through all the guys
								for( i=0; i<enta_roof_runners.size; i++ )
								{
												enta_roof_runners = maps\_utility::array_removeDead( enta_roof_runners );
												wait( 0.05 );
												enta_roof_runners = maps\_utility::array_removeUndefined( enta_roof_runners );

												// check to make sure the guy is alive
												if( isalive( enta_roof_runners[i] ) )
												{
																// hide him
																enta_roof_runners[i] hide();

																// delete him
																enta_roof_runners[i] delete();
												}
															
												// frame wait
												wait( 0.05 );
								}
				}	
}
///////////////////////////////////////////////////////////////////////////
// 08-20-08 WWilliams
// AI run down the roof and jump to the freight
//first_uncouple_jumpers()
//{
//				// endon
//
//				// objects to define for this function
//				// spawner
//				roof_runner_spawner = getent( "roof_runners_spawner", "targetname" );
//				// nodes
//				roof_stop_node = getnode( "roof_jumper_stop", "targetname" );
//				roof_jump_node = getnode( "roof_jumper_jump", "targetname" );
//				// undefined
//				temp_ent = undefined;
//
//				// reset the count on this spawner
//				roof_runner_spawner.count = 5;
//
//				// while loop
//				while( roof_runner_spawner.count > 0 )
//				{
//								// spawn out a guy
//								temp_ent = roof_runner_spawner stalingradspawn( "roof_jumper" );
//
//								// make sure the spawn didn't fail
//								if( maps\_utility::spawn_failed( temp_ent ) )
//								{
//												// debug text
//												iprintlnbold( "roof_jumper fail!" );
//
//												// end function
//												return;
//								}
//
//								// set the guy up
//								temp_ent setenablesense( false );
//								temp_ent lockalertstate( "alert_red" );
//
//								// start a function on this guy
//								temp_ent thread roof_jumper( roof_stop_node, roof_jump_node );
//
//								// while loops causes a wait until
//								while( isdefined( temp_ent ) && isalive( temp_ent ) )
//								{
//												// wait
//												wait( 0.1 );
//								}
//
//								// wait to avoid an infinite script loop
//								wait( 0.05 );
//
//				}
//
//}
/////////////////////////////////////////////////////////////////////////////
//// 08-20-08 WWilliams
//// function makes the ai it runs on run to the node then jump to the freight
//roof_jumper( stop_node, jump_node )
//{
//				// endon
//				self endon( "death" );
//
//				// self runs to stop node
//				self setgoalnode( stop_node );
//
//				// wait for goal
//				self waittill( "goal" );
//
//				// rotate to face the node angles
//				self cmdfaceangles( 180, true );
//
//				// wait for the rotate to finish
//				self waittill( "cmd_done" );
//
//				// go to the next goal
//				self setgoalnode( jump_node );
//
//				// wait for goal
//				self waittill( "goal" );
//
//				// play the anim
//				self cmdplayanim( "Thug_TrainJump" );
//
//				// wait for the anim to finish
//				self waittill( "cmd_done" );
//
//				// end the function
//				self delete();
//}