// Montenegro Train car 7
// Builder: Don Sielke
// Scripter: Don Sielke
//////////////////////////////////////////////////////////////////////////////////////////
// includes
#include maps\_utility;

//
//	Spawns a civilian
//
e7_main()
{
				// thread maps\MontenegroTrain_util::lights_flickering();
				level thread car7_light_flicker_init();
				// thread sneaky_guards_baggage();
				// 06-03-08
				// wwilliams
				// new sneaky function start
				level thread car7_sneaky_init();

				// startup car8
				level waittill( "in_car_7" );
				thread maps\MontenegroTrain_car8::e8_main();
				thread remove_train2_civilians();
}

//////////////////////////////////////////////////////////////////////////////////////////
// Can no longer go back to train 2&4, remove civilian ai.
//////////////////////////////////////////////////////////////////////////////////////////

remove_train2_civilians()
{
				civ2_array = getentarray("train2_civilian", "script_noteworthy");

				for (i = 0; i < civ2_array.size; i++)
				{
								if( IsDefined (civ2_array[i]) )
								{
												civ2_array[i] delete();
								}		
				}

} 

//////////////////////////////////////////////////////////////////////////////////////////
// Setup sneaky guards.
//////////////////////////////////////////////////////////////////////////////////////////
// 06-03-08
// wwilliams
// commenting out the old sneaky guards, going to try this a different way
/* sneaky_guards_baggage()
{
trig = GetEnt( "sneaky_car7", "targetname" );
if ( IsDefined(trig) )
{
if ( IsDefined(trig.target) )
{
enemy_spawner = GetEntArray(trig.target, "targetname");

trig waittill( "trigger" );
for (i=0; i<enemy_spawner.size; i++)
{
if(IsDefined (enemy_spawner[i].target, "targetname"))
{
enemy_trigger[i] = GetEnt(enemy_spawner[i].target, "targetname");
enemy[i] = enemy_spawner[i] StalingradSpawn();
enemy[i] LockAlertState("alert_green");

enemy_trigger[i] waittill("trigger");
enemy[i] LockAlertState("alert_red");
enemy[i] CmdShootAtEntity(level.player, true, 2, 0.5);
}
else
{	
enemy[i] = enemy_spawner[i] StalingradSpawn();
}
}

}

}

}*/	 
car7_sneaky_init()
{
				//Wait time to delay music start
				wait( 1.0 );

				//Battle Music - Added by crussom
				level notify( "playmusicpackage_action2" );

				// endon
				level.player endon( "death" );

				// objects to be defined for this function
				// trig
				trig_setup = getent( "sneaky_car7", "targetname" );

				// double check that everything needed is defined
				//assertex( isdefined( trig_setup ), "trig_setup not defined" );

				// wait for the trigger
				trig_setup waittill( "trigger" );

				// fire off the three functions that run the three ambushers
				level thread car7_ambush_1();
				level thread car7_ambush_2();
				level thread car7_ambush_3();
				level thread car7_amb3_backup();



}
///////////////////////////////////////////////////////////////////////////
// 06-04-08
// wwilliams
// first ambusher in car7, waits until the player is close before stepping out
// might need to move the trigger back
// or wait for first guy to finish blindfire then make this guy step out
car7_ambush_1()
{
				// endon
				level.player endon( "death" );

				// objects to define for this function
				// spawner
				amb1_spawner = getent( "spwn_car7_ambush1", "targetname" );
				// make sure spawner is defined
				//assertex( isdefined( amb1_spawner ), "amb1_spawner not defined" );
				// node
				amb1_node = getnode( amb1_spawner.target, "targetname" );
				// make sure spawner is defined
				//assertex( isdefined( amb1_node ), "amb1_node not defined" );
				// trigger
				amb1_trig = getent( amb1_node.target, "targetname" );
				trig_clean_up = getent( "player_at_car_8", "targetname" );
				// make sure spawner is defined
				//assertex( isdefined( amb1_trig ), "amb1_trig not defined" );
				//assertex( isdefined( trig_clean_up ), "trig_clean_up not defined" );
				// undefined
				ent_temp = undefined;

				// spawn out a guy
				ent_temp = amb1_spawner stalingradspawn( "car7_enemy" );

				// check to see if the guy failed his spawn
				if( spawn_failed( ent_temp ) )
				{
								// debug text
								iprintlnbold( "amb1 ent failed spawn" );

								// wait
								wait( 5.0 );

								// end the function
								return;
				}
				// if he spawned out then send him to the next function
				else
				{
								// run a function on the guy
								ent_temp thread car7_amb_guy1( amb1_node, amb1_trig );

				}

				// clean up here
				// wait for trigger
				trig_clean_up waittill( "trigger" );

				// delete the spawner
				amb1_spawner delete();
				// and the trig
				amb1_trig delete();

}
//////////////////////////////////////////////////////////////////////
// 06-04-08
// wwilliams
// function controls the guy for the first ambush
// runs on self/npc
car7_amb_guy1( node, trig )
{
				// endon
				level.player endon( "death" );
				self endon( "death" );
				self endon( "damage" );

				// set up the guy
				self setenablesense( false );
				self setalertstatemin( "alert_red" );

				// make sure the ai resets in case the player shoots them before this function is done
				self thread car7_ai_back_to_normal();

				// send the guy to his node
				self setgoalnode( node );

				// wait for him to get there
				self waittill( "goal" );

				// wait for the notify from the second ambusher
				level waittill( "car7_first_go" );

				// wait for the player to hit the trigger
				trig waittill( "trigger" );

				// blindfire at the player
				self cmdshootatentity( level.player, true, 2.0, 0.2, true );

				// turn the guy back on normal
				self setenablesense( true );
				self setengagerule( "tgtSight" );
				self addengagerule( "tgtPerceive" );
				self addengagerule( "Damaged" );
				self addengagerule( "Attacked" );

				// turn off the back to normal function
				self notify( "already_normal" );

}
//////////////////////////////////////////////////////////////////////
// 06-04-08
// wwilliams
// set up the second ambush guy, this guys will actually shoot first
// when the player enters
// runs on level
car7_ambush_2()
{
				// endon
				level.player endon( "death" );

				// objects to be defined for this function
				// spawner
				amb2_spawner = getent( "spwn_car7_ambush2", "targetname" );
				// verify the object
				//assertex( isdefined( amb2_spawner ), "amb2_spawner not defined" );
				// node
				amb2_node = getnode( amb2_spawner.target, "targetname" );
				// verify the object
				//assertex( isdefined( amb2_node ), "amb2_node not defined" );
				// trigger
				amb2_trig = getent( amb2_node.target, "targetname" );
				trig_clean_up = getent( "player_at_car_8", "targetname" );
				// verify the object
				//assertex( isdefined( amb2_trig ), "amb2_trig not defined" );
				//assertex( isdefined( trig_clean_up ), "trig_clean_up not defined" );
				// undefined
				ent_temp = undefined;

				// spawn out the guy
				ent_temp = amb2_spawner stalingradspawn( "car7_enemy" );

				// check to see if the spawn failed
				if( spawn_failed( ent_temp ) )
				{
								// debug text
								iprintlnbold( "amb2_spawner spawn fail" );

								// wait
								wait( 5.0 );

								// end function
								return;
				}
				// if the spawn didn't fail, then thread a func on him
				else
				{
								// run a function on the guy
								ent_temp thread car7_amb_guy2( amb2_node, amb2_trig );
				}

				// clean up here
				// wait for the trigger
				trig_clean_up waittill( "trigger" );

				// delete the spawn
				amb2_spawner delete();
				// and the trig
				amb2_trig delete();

}
//////////////////////////////////////////////////////////////////////
// 06-04-08
// wwilliams
// function controls the guy for the second ambush
// runs on self/npc
car7_amb_guy2( node, trig )
{
				// endon
				level.player endon( "death" );
				self endon( "death" );
				self endon( "damage" );

				// set up the guy
				self setenablesense( false );
				self setalertstatemin( "alert_red" );

				// make sure the ai resets in case the player shoots them before this function is done
				self thread car7_ai_back_to_normal();

				// send the guy to his node
				self setgoalnode( node );

				// wait for him to get there
				self waittill( "goal" );

				// wait for the player to hit the trigger
				trig waittill( "trigger" );

				// blindfire at the player
				self cmdshootatentity( level.player, true, 4.0, 0.6, true );

				// notify the first guy to shoot now
				level notify( "car7_first_go" );

				// turn the guy back on normal
				self setenablesense( true );
				self setengagerule( "tgtSight" );
				self addengagerule( "tgtPerceive" );
				self addengagerule( "Damaged" );
				self addengagerule( "Attacked" );

				// turn off the back to normal function
				self notify( "already_normal" );

}
//////////////////////////////////////////////////////////////////////
// 06-04-08
// wwilliams
// set up the second ambush guy, this guys will actually shoot first
// when the player enters
// runs on level
car7_ambush_3()
{
				// endon
				level.player endon( "death" );

				// objects to be defined for this function
				// spawner
				amb3_spawner = getent( "spwn_car7_ambush3", "targetname" );
				// verify the object
				//assertex( isdefined( amb3_spawner ), "amb2_spawner not defined" );
				// node
				amb3_start_node = getnode( amb3_spawner.target, "targetname" );
				// verify the object
				//assertex( isdefined( amb3_start_node ), "amb2_node not defined" );
				// go to node
				amb3_destin_node = getnode( amb3_start_node.target, "targetname" );
				// verify the object
				//assertex( isdefined( amb3_destin_node ), "amb3_destin_node not defined!" );
				// trigger
				amb3_trig = getent( amb3_destin_node.target, "targetname" );
				trig_clean_up = getent( "player_at_car_8", "targetname" );
				// verify the object
				//assertex( isdefined( amb3_trig ), "amb2_trig not defined" );
				//assertex( isdefined( trig_clean_up ), "trig_clean_up not defined" );
				// undefined
				ent_temp = undefined;

				// spawn out the guy
				ent_temp = amb3_spawner stalingradspawn( "car7_enemy" );

				// check to see if the spawn failed
				if( spawn_failed( ent_temp ) )
				{
								// debug text
								iprintlnbold( "amb3_spawner spawn fail" );

								// wait
								wait( 5.0 );

								// end function
								return;
				}
				// if the spawn didn't fail, then thread a func on him
				else
				{
								// run a function on the guy
								ent_temp thread car7_amb_guy3( amb3_start_node, amb3_destin_node, amb3_trig );
				}

				// clean up here
				// wait for the trigger
				trig_clean_up waittill( "trigger" );

				// delete the spawn
				amb3_spawner delete();
				// and the trig
				amb3_trig delete();

}
//////////////////////////////////////////////////////////////////////
// 06-04-08
// wwilliams
// function controls the guy for the first ambush
// runs on self/npc
car7_amb_guy3( start_node, destin_node, trig )
{
				// endon
				level.player endon( "death" );
				self endon( "death" );
				self endon( "damage" );

				// set up the guy
				self setenablesense( false );
				self setalertstatemin( "alert_red" );

				// make sure the ai resets in case the player shoots them before this function is done
				self thread car7_ai_back_to_normal();

				// send the guy to his node
				self setgoalnode( start_node );

				// wait for him to get there
				self waittill( "goal" );

				// wait for the player to hit the trigger
				trig waittill( "trigger" );

				// give the guy sense for a time
				self thread maps\MontenegroTrain_util::turn_on_sense( 5 );

				// send him to the destin node while shooting
				self setgoalnode( destin_node, 1 );

				// should wait for goal?


				// turn the guy back on normal
				self setenablesense( true );
				self setengagerule( "tgtSight" );
				self addengagerule( "tgtPerceive" );
				self addengagerule( "Damaged" );
				self addengagerule( "Attacked" );

				// turn off the back to normal function
				self notify( "already_normal" );

				// give the guy sense for a time
				self thread maps\MontenegroTrain_util::turn_on_sense( 5 );

				// go to the destin node while shooting at the player
				self setgoalnode( destin_node, 1 );

}
//////////////////////////////////////////////////////////////////////
// 06-04-08
// wwilliams
// function turns the ai back on in case they take damage
// runs on self/npc
car7_ai_back_to_normal()
{
				// endon
				self endon( "death" );
				self endon( "already_normal" );

				// wait for damage
				self waittill( "damage" );

				// set self to the right settings
				self setenablesense( true );
				self setengagerule( "tgtSight" );
				self addengagerule( "tgtPerceive" );
				self addengagerule( "Damaged" );
				self addengagerule( "Attacked" );

}
//////////////////////////////////////////////////////////////////////
// 06-04-08
// wwilliams
// function spawns out three guys to backup the third ambusher
// runs on level
car7_amb3_backup()
{
				// endon
				level.player endon( "death" );

				// objects to be defined for this function
				// spawner
				enta_car7_backup = getentarray( "spwn_car7_amb_backup", "targetname" );
				// verify the array is valid
				//assertex( isdefined( enta_car7_backup ), "enta_car7_backup not defined" );
				// trigger
				trig_start = getent( "auto2156", "targetname" );
				trig_clean_up = getent( "player_at_car_8", "targetname" );
				// check that object is valid
				//assertex( isdefined( trig_start ), "trig_start is not defined" );
				//assertex( isdefined( trig_clean_up ), "trig_clean_up not defined" );

				// wait for the trigger to hit
				trig_start waittill( "trigger" );

				// quick wait so these guys don't compound the moving guy
				wait( 1.5 );

				// for loop goes through each spot in the array
				for( i=0; i<enta_car7_backup.size; i++ )
				{
								// thread the function on the spawner
								enta_car7_backup[i] thread car7_backup_guy();

								// frame wait
								wait( 0.05 );
				}

				// wait for the clean up trigger
				trig_clean_up waittill( "trigger" );

				// delete each spawner
				for( i=0; i<enta_car7_backup.size; i++ )
				{
								// thread the function on the spawner
								enta_car7_backup[i] delete();

								// frame wait
								wait( 0.05 );
				}

}
//////////////////////////////////////////////////////////////////
// 06-04-08
// wwilliams
// function spawns out a guy and sends him to the 
// spawner target
// runs on self/spawner
car7_backup_guy()
{
				// make sure the spawner has a target
				//assertex( isdefined( self.target ), "ca7_backup spawner missing a target!" );

				// object to define for the function
				nod_tether_car7 = GetNode( "nod_car7_tether", "targetname" );

				// set the count
				self.count = 1;

				// define the node
				destin_node = getnode( self.target, "targetname" );

				// spawn out a guy
				ent_temp = self stalingradspawn( "car7_enemy" );

				// check to see if the guy failed spawn
				if( spawn_failed( ent_temp ) )
				{
								// debug text
								iprintlnbold( "car7_backup_guy failed spawn" );

								// wait
								wait( 5.0 );

								// end the function
								return;
				}
				else
				{
								// set the guy up
								ent_temp setalertstatemin( "alert_red" );
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );

								// give him perfect sense
								ent_temp thread maps\MontenegroTrain_util::turn_on_sense();

								// send him to the node
								ent_temp setgoalnode( destin_node );

								// tether the guy to the tether node of the car
								ent_temp thread maps\MontenegroTrain_util::train_reset_speed_activate_tether( nod_tether_car7, 384, 900, 256 );

				}

				// finished, clean up happens in the other function
}
///////////////////////////////////////////////////////////////////////////
// 08-13-08 WWilliams
// function flickers the lights in car 7
car7_light_flicker_init()
{
				// endon

				// objects to defined for this function
				start_trig = getent( "sneaky_car7", "targetname" );
				// light one
				car7_light1 = getent( "luggcar2_light_1", "targetname" );
				car7_light1_model_on = getent( "luggcar2_light_1_on", "targetname" );
				car7_light1_model_off = getent( "luggcar2_light_1_off", "targetname" );
				// light two
				car7_light2 = getent( "luggcar2_light_2", "targetname" );
				car7_light2_model_on = getent( "luggcar2_light_2_on", "targetname" );
				car7_light2_model_off = getent( "luggcar2_light_2_off", "targetname" );
				// light three
				car7_light3 = getent( "luggcar2_light_3", "targetname" );
				car7_light3_model_on = getent( "luggcar2_light_3_on", "targetname" );
				car7_light3_model_off = getent( "luggcar2_light_3_off", "targetname" );

				// wait before switching stuff out
				wait( 0.1 );

				// hide the on versions
				car7_light1_model_on hide();
				car7_light2_model_on hide();
				car7_light2_model_on hide();

				// turn off the lights
				car7_light1 setlightintensity( 0 );
				car7_light2 setlightintensity( 0 );
				car7_light3 setlightintensity( 0 );

				// wait for the trigger
				start_trig waittill( "trigger" );

				// iprintlnbold( "sneaky lights start!" );

				level thread car7_light_flicker( car7_light1, car7_light1_model_off, car7_light1_model_on );
				level thread car7_light_flicker( car7_light2, car7_light2_model_off, car7_light2_model_on );
				level thread car7_light_flicker( car7_light3, car7_light2_model_off, car7_light3_model_on ); 


}
///////////////////////////////////////////////////////////////////////////
// 08-13-08 WWilliams
// makes the light set in car7 flicker, ends when the player drops into bliss's car
car7_light_flicker( ent_light, model_off, model_on )
{
				// endon

				// double check the stuff passed in
				//assertex( isdefined( ent_light ), "ent_light not defined" );
				//assertex( isdefined( model_off ), "model_off not defined" );
				//assertex( isdefined( model_on ), "model_on not defined" );

				while( !maps\_utility::flag( "bliss_run_started" ) )
				{
								// light starts off, play an fx on the model, and switch to the on version
								ent_light setlightintensity ( randomfloatrange( 0.5, 2 ) );
								model_on show();
								model_off hide();
								fx = playfx( level._effect["fx_metalhit_lg"], model_on.origin );
								wait( randomfloatrange( .005, 0.7 ) );

								// turn it back off
								ent_light setlightintensity (0);
								model_off show();
								model_on hide();
								wait( randomfloatrange(.005, 0.5) );

								// light starts off, play an fx on the model, and switch to the on version
								ent_light setlightintensity ( randomfloatrange( 0.5, 2 ) );
								model_on show();
								model_off hide();
								fx = playfx( level._effect["fx_metalhit_lg"], model_on.origin );
								wait( randomfloatrange( .005, 0.9 ) );

								// turn it back off
								ent_light setlightintensity (0);
								model_off show();
								model_on hide();
								wait( randomfloatrange( .005, 0.7 ) );

								// light starts off, play an fx on the model, and switch to the on version
								ent_light setlightintensity ( randomfloatrange( 0.5, 2 ) );
								model_on show();
								model_off hide();
								fx = playfx( level._effect["fx_metalhit_lg"], model_on.origin );
								wait( randomfloatrange( .005, 0.5 ) );

								// turn it back off
								ent_light setlightintensity (0);
								model_off show();
								model_on hide();
								wait( randomfloatrange(.005, 1.2) );
				}

				// turn light off once the player has entered the bliss car
				ent_light setlightintensity (0);
}