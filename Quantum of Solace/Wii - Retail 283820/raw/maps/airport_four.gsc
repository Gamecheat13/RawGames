





#include maps\_utility;
#include maps\airport_util;

main()
{

				
				
				level maps\_autosave::autosave_now( "airport" );

				
				
				
				
				
				
				

				
				
				
				

				
				level thread e4_luggage_warning();

				
				

				
				
				level thread e4_luggage_fight_group_one();

				wait ( 2.0 );

				
				
				
				level thread e4_f2_left_cover_init();
				level thread e4_f2_right_cover_init();

				
				
				
				
				level thread e4_luggage_f2_init();

				
				
				
				
				
				
				

				
				
				level thread e4_r2_catwalk_explosion();

				
				
				level thread e4_window_shooter();

				
				
				
				
				level thread e4_lead_into_lugg2();

				
				
				
				

				
				
				
				level thread e4_luggage_fight_group_four();

				
				
				
				level thread lugg3_catwalk_left();
				level thread lugg3_catwalk_right();

				
				
				level thread e4_luggage_fight_group_five();


				
				
				
				
				level thread forklift_explo_setup();

				
				level thread e4_slam_cam();

				
				level thread e4_light_blinking();

				
				
				
				level thread e4_fence_explosion();

				
				
				
				
				
				level thread maps\airport_five::e5_button_open_gdoors();

				level waittill( "airport_four_done" );



}

quick_end()
{
				

				
				

				

				

				
				level thread e4_last_three();

				
				
				
				nb_enemies_e4 = getentarray ( "e4_spawners_b", "script_noteworthy" );
	
				
				
				
				

				
				while( nb_enemies_e4.size > 0 )
				{
								
								wait( 1.0 );

								
								nb_enemies_e4 = level maps\_utility::array_removedead( nb_enemies_e4 );

								
								wait( 1.0 );

				}

				
				level notify( "airport_four_done" );

				
				level notify("endmusicpackage");

				

}






e4_last_three()
{
				
				

				
				
				
				nb_enemies_e4 = getentarray ( "e4_spawners_b", "script_noteworthy" );
	
				
				
				

				
				wait( 0.05 );

				
				for( i=0; i<nb_enemies_e4.size; i++ )
				{
								
								if( distancesquared( nb_enemies_e4[i].origin, level.player.origin ) > 2000*2000 )
								{
												
												nb_enemies_e4[i] hide();

												
												nb_enemies_e4[i] dodamage( nb_enemies_e4[i].health + 500, nb_enemies_e4[i].origin );

								}
				}

				
				while( nb_enemies_e4.size > 3 )
				{
								
								nb_enemies_e4 = level maps\_utility::array_removedead( nb_enemies_e4 );

								
								wait( 1.0 );
				}

				
				for( i=0; i<nb_enemies_e4.size; i++ )
				{
								
								if( isalive( nb_enemies_e4[i] ) )
								{
												
												nb_enemies_e4[i] SetCombatRole( "rusher" );

												
												nb_enemies_e4[i] waittill( "death" );
								}
				}

}



e4_luggage_warning()
{
	
	thread maps\airport_util::clean_up_old_ai();

	

	
	
	spawner_warn = getent( "spwn_e4_warn_retreat", "targetname" );
	
	ent_warn_luggage = undefined;

	
	ent_warn_luggage = spawner_warn stalingradspawn( "e4_warn" );
	if( !maps\_utility::spawn_failed( ent_warn_luggage ) )
	{
		
		ent_warn_luggage thread e4_warn_retreat();
	}
	else
	{
		
		return;
	}

	
	spawner_warn delete();
	ent_warn_luggage = undefined;
}










second_luggage_retreat()
{
				
				

				
				
				nod_tether_3 = getnode( "nod_luggage_tether_3", "targetname" );
				
				trig_start_retreat = getent( "trig_start_2nd_retreat", "targetname" );
				
				enta_lugg2_enemies = getentarray( "e4_lugg2_enemy", "targetname" );

				
				enta_lugg2_enemies = level maps\airport_util::only_ai_in_array( enta_lugg2_enemies );

				
				trig_start_retreat waittill( "trigger" );

				
				enta_lugg2_enemies = level maps\_utility::array_removedead( enta_lugg2_enemies );

				
				for( i=0; i<enta_lugg2_enemies.size; i++ )
				{
								
								
								if( isalive( enta_lugg2_enemies[i] ) )
								{
												
												enta_lugg2_enemies[i] settetherradius( 1750 );

												
												enta_lugg2_enemies[i].tetherpt = nod_tether_3.origin;

												
												enta_lugg2_enemies[i] thread luggage_room_active_tether( 512, 1750, 256 );
								}

								
								wait( 0.05 );

				}
}








e4_warn_retreat()
{
				
				self endon( "death" );

				
				
				trig_run_from_spot_1 = getent( "trig_e4_warn_run", "targetname" );
				trig_run_from_spot_2 = getent( "trig_run_from_point_2", "targetname" );
				trig_start_shooting_at_player = getent( "trig_lug1_fight_wait", "targetname" );
				
				nod_point_one = getnode( "nod_e4_shadowy_fig_1", "targetname" );
				nod_point_two = getnode( "nod_e4_shadowy_fig_2", "targetname" );
				nod_point_three = getnode( "nod_e4_shadowy_fig_3", "targetname" );
				nod_tether = getnode( "nod_luggage_tether_1", "targetname" );
				

				
				
				
				
				
				self LockAlertState( "alert_red" );
				self SetScriptSpeed( "sprint" );

				
				self setgoalnode( nod_point_two );

				
				trig_run_from_spot_2 waittill( "trigger" );

				
				wait( 0.05 );

				
				self thread turn_on_sense();

				
				self setgoalnode( nod_point_three, 1 );

				
				
				
				self maps\_utility::play_dialogue_nowait( "GRM2_AirpG_024A" );

				
				level notify("playmusicpackage_luggage_01");

				
				
				trig_start_shooting_at_player waittill( "trigger" );

				
				self thread turn_on_sense();

				
				self setscriptspeed( "default" );

				
				
				

				
				self setcombatrole( "guardian" );

				
				self.tetherpt = nod_tether.origin;

				
				self thread luggage_room_active_tether( 384, 1024, 256 );

}




forklift_explo_setup()
{
				

				
				triga_dmg_forklift = getentarray( "trg_dmg_forklift", "targetname" );

				
				for( i=0; i<triga_dmg_forklift.size; i++ )
				{
								
								triga_dmg_forklift[i] thread e4_forklift_explosion();
								
								wait( 0.1 );
				}

				
				
}






e4_forklift_explosion()
{
				

				
				forklift_model = getent( self.target, "targetname" );
				forklift_model_dmg = getent( forklift_model.target, "targetname" );

				
				forklift_model_dmg hide();

				
				
				
				while( 1 )
				{
								
								
								self waittill( "damage", amount, attacker, direction_vec, point, type );

								
								if( attacker == level.player )
								{
												
												break;
								}
								else
								{
												
												wait( 0.5 );
								}
				}

				
				forklift_explo = playfx( level._effect[ "f_explosion" ], forklift_model.origin );

				
				self playsound( "AIR_forklift_explo_sound" );

				
				radiusdamage( forklift_model.origin, 300, 600, 200 );

				
				earthquake( 0.5, 2.0, forklift_model.origin, 850 );

				
				level thread maps\airport_util::air_ctrl_rumble_timer( 1 );

				
				wait( 0.08 );

				
				forklift_model hide();
				forklift_model_dmg show();
}



e4_window_shooter()
{
				
				spawner = getent( "spwn_e4_window_shooter", "targetname" );
				shooter_node = getnode( "nod_e4_glass_break", "targetname" );
				ent_shoot_at = getent( "ent_window_shoot_spot", "targetname" );
				trig_start_shooting = getent( "trig_shoot_through_window", "targetname" );
				nod_after_shooting = getnode( "nod_shooter_destin", "targetname" );
				nod_tether = getnode( "nod_luggage_tether_1", "targetname" );

				
				e4_window_shooter = spawner stalingradspawn( "e4_shooter" );
				if( !maps\_utility::spawn_failed( e4_window_shooter ) )
				{
								wait( 0.1 );

								
								e4_window_shooter SetScriptSpeed( "Run" );

								
								e4_window_shooter setenablesense( false );

								
								e4_window_shooter setgoalnode( shooter_node );

								
								e4_window_shooter endon( "death" );

								
								e4_window_shooter waittill( "goal" );
				}

				
				
				
				level thread e4_extra_layer_for_shooter();

				
				trig_start_shooting waittill( "trigger" );

				
				ent_shoot_at thread e4_move_window_shooter_target();

				
				e4_window_shooter cmdshootatentity( ent_shoot_at, true, 5, 1 );

				wait( 5.0 );

				
				level notify( "e4_shooter_done" );

				
				e4_window_shooter setenablesense( true );
				e4_window_shooter lockalertstate( "alert_red" );

				
				e4_window_shooter setgoalnode( nod_after_shooting );

				
				
				

				
				
				e4_window_shooter thread give_tether_at_goal( nod_after_shooting, 384, 900, 64 );

				
				ent_shoot_at delete();

				
				spawner delete();

}







e4_extra_layer_for_shooter()
{
				
				

				
				

				
				trig_damage_from_shooter = getent( "trig_extra_layer_for_shooter_moment", "targetname" );
				

				
				trig_damage_from_shooter waittill( "trigger" );

				
				radiusdamage( ( -1630, 3172, 169 ), 12, 80, 75 );

}







e4_move_window_shooter_target()
{
				
				level endon( "e4_shooter_done" );

				
				first_spot = self.origin;

				while( 1 )
				{
								
								self movex( -272, 3.0 );
								self waittill( "movedone" );

								
								self movex( 272, 3.0 );
								self waittill( "movedone" );
				}
}




e4_luggage_fight_group_one()	

{
				

				
				trig_prepare = getent( "trig_lug1_fight_wait", "targetname" );
				
				spawner = getent( trig_prepare.target, "targetname" );
				noda_dest = getnodearray( spawner.script_parameters, "targetname" );
				nod_wait = getnode( "nod_lug1_wait", "targetname" );
				nod_tether = getnode( "nod_luggage_tether_1", "targetname" );
				enta_lug1_enemies = [];
				ent_temp = undefined;


				
				spawner.count = noda_dest.size;

				
				trig_prepare waittill( "trigger" );

				
				for( i=0; i<noda_dest.size; i++ )
				{
								
								ent_temp = spawner stalingradspawn( "e4_wave_1" );
								
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												
												

												
												return;
								}

								
								ent_temp setalertstatemin( "alert_red" );

								
								if( !isdefined( noda_dest[i].script_string ) )
								{
												
												

												
												return;
								}

								
								ent_temp thread turn_on_sense( 3 );

								
								if( ( i + 1 ) % 2 == 0 )
								{
												
												ent_temp setgoalnode( noda_dest[i], 1 );
								}
								
								else
								{
												
												ent_temp setgoalnode( noda_dest[i] );
								}

								
								ent_temp thread maps\airport_util::sprint_to_goal();

								
								ent_temp thread combat_role_on_goal( noda_dest[i].script_string );

								
								if( noda_dest[i].script_string != "rusher" )
								{
												ent_temp thread give_tether_at_goal( nod_tether, 384, 900, 256 );
								}

								
								enta_lug1_enemies = maps\_utility::array_add( enta_lug1_enemies, ent_temp );

								
								wait( 0.2 );

								
								ent_temp = undefined;
				}

				
				wait( 5.0 );

				
				spawner delete();
}





e4_luggage_f2_init()
{
				
				

				
				
				trig_spawn_enemies = getent( "trig_e4_lug2_fight", "targetname" );
				trig_second_tether = getent( "trig_f2_tether2", "targetname" );
				
				spawner_a = getent( "spwn_lugg1_f2_group_a", "targetname" );
				spawner_b = getent( "spwn_lugg1_f2_group_b", "targetname" );
				
				nod_tether_1 = getnode( "nod_luggage_tether_1", "targetname" );
				nod_tether_2 = getnode( "nod_luggage_tether_2", "targetname" );
				noda_spwn_a_nodes = getnodearray( spawner_a.script_parameters, "targetname" );
				noda_spwn_b_nodes = getnodearray( spawner_b.script_parameters, "targetname" );
				
				ent_temp = undefined;

				
				assertex( isdefined( trig_spawn_enemies ) , "trig_spawn_enemies not defined" );
				assertex( isdefined( trig_second_tether ) , "trig_second_tether not defined" );
				assertex( isdefined( spawner_a ) , "spawner_a not defined" );
				assertex( isdefined( spawner_b ) , "spawner_b not defined" );
				assertex( isdefined( nod_tether_1 ) , "nod_tether_1 not defined" );
				assertex( isdefined( nod_tether_2 ) , "nod_tether_2 not defined" );
				assertex( isdefined( noda_spwn_a_nodes ) , "noda_spwn_a_nodes not defined" );
				assertex( isdefined( noda_spwn_b_nodes ) , "noda_spwn_b_nodes not defined" );

				
				spawner_a.count = noda_spwn_a_nodes.size;
				spawner_b.count = noda_spwn_b_nodes.size;

				
				trig_spawn_enemies waittill( "trigger" );




				
				for( i=0; i<noda_spwn_a_nodes.size; i++ )
				{
								
								ent_temp = spawner_a stalingradspawn( "lugg1_enemy" );

								
								if( spawn_failed( ent_temp ) )
								{
												
												

												
												return;
								}
								
								
								ent_temp setgoalnode( noda_spwn_a_nodes[i] );

								
								ent_temp lockalertstate( "alert_red" );

								
								ent_temp setscriptSpeed( "sprint" );
								
								
								ent_temp thread turn_on_sense( 5 );

								
								
								if( i == 0 )
								{
												
												ent_temp setcombatrole( "rusher" );
												
												
								}
								else if( i == 1 )
								{
												
												ent_temp setcombatrole( "flanker" );

												
												ent_temp thread sprint_to_goal();

												
												ent_temp thread give_tether_at_goal( nod_tether_1, 384, 900, 256 );

												
												ent_temp thread e4_f2_enemy_setup( trig_second_tether, nod_tether_2 );
								}
								else if( i == 2 )
								{
												
												ent_temp setcombatrole( "guardian" );

												
												ent_temp thread sprint_to_goal();

												
												ent_temp thread give_tether_at_goal( nod_tether_1, 384, 900, 256 );

												
												ent_temp thread e4_f2_enemy_setup( trig_second_tether, nod_tether_2 );
								}
								else
								{
												
												ent_temp setcombatrole( "flanker" );

												
												ent_temp thread sprint_to_goal();

												
												ent_temp thread give_tether_at_goal( nod_tether_1, 384, 900, 256 );

												
												ent_temp thread e4_f2_enemy_setup( trig_second_tether, nod_tether_2 );
								}	

								
								wait( 0.7 );

								
								ent_temp = undefined;
				}




				
				wait( 1.0 );




				
				for( i=0; i<noda_spwn_b_nodes.size; i++ )
				{
								
								ent_temp = spawner_b stalingradspawn( "lugg1_enemy" );

								
								if( spawn_failed( ent_temp ) )
								{
												
												

												
												return;
								}

								
								ent_temp setgoalnode( noda_spwn_b_nodes[i] );

								
								ent_temp lockalertstate( "alert_red" );

								
								ent_temp setscriptSpeed( "sprint" );

								
								ent_temp thread turn_on_sense( 5 );

								
								
								if( i == 0 )
								{
												
												ent_temp setcombatrole( "rusher" );

												
								}
								else if( i == 1 )
								{
												
												ent_temp setcombatrole( "flanker" );

												
												ent_temp thread sprint_to_goal();

												
												ent_temp thread give_tether_at_goal( nod_tether_1, 384, 900, 256 );

												
												ent_temp thread e4_f2_enemy_setup( trig_second_tether, nod_tether_2 );
								}
								else if( i == 2 )
								{
												
												ent_temp setcombatrole( "guardian" );

												
												ent_temp thread sprint_to_goal();

												
												ent_temp thread give_tether_at_goal( nod_tether_1, 384, 900, 256 );

												
												ent_temp thread e4_f2_enemy_setup( trig_second_tether, nod_tether_2 );
								}
								else
								{
												
												ent_temp setcombatrole( "flanker" );

												
												ent_temp thread sprint_to_goal();

												
												ent_temp thread give_tether_at_goal( nod_tether_1, 384, 900, 256 );

												
												ent_temp thread e4_f2_enemy_setup( trig_second_tether, nod_tether_2 );
								}	

								
								wait( 0.7 );

								
								ent_temp = undefined;
				}





				
				spawner_a delete();
				spawner_b delete();
				ent_temp = undefined;

}




e4_f2_enemy_setup( trig_tether_2, nod_tether_2 )
{
				
				self endon( "death" );

				
				assertex( isdefined( trig_tether_2 ), "trig_tether_2 not defined" );
				assertex( isdefined( nod_tether_2 ), "nod_tether_2 not defined" );

				
				trig_tether_2 waittill( "trigger" );

				
				self.tetherpt = nod_tether_2.origin;
}




e4_f2_left_cover_init()
{
				
				

				
				
				trig_start = getent( "trig_run_from_point_2", "targetname" );
				
				spawner = getent( "spwn_e4_f2_left", "targetname" );
				
				ent_temp = undefined;

				
				assertex( isdefined( trig_start ), "trig_start not defined" );
				assertex( isdefined( spawner ), "spawner not defined" );

				
				spawner.count = 1;

				
				trig_start waittill( "trigger" );

				
				ent_temp = spawner stalingradspawn( "e4_enemy" );

				
				if( spawn_failed( ent_temp ) )
				{
								
								

								
								wait( 2.0 );

								
								return;
				}
				else
				{
								
								ent_temp thread e4_f2_left_shooter();
				}

				
				wait( 2.0 );

				
				ent_temp = undefined;
				spawner delete();

}





e4_f2_left_shooter()
{
				
				self endon( "death" );

				
				trig_fire = getent( "trig_e4_lug2_fight", "targetname" );
				trig_tether = getent( "trig_f2_tether2", "targetname" );
				
				nod_shoot = GetNode( "nod_e4_f2_lshot", "targetname" );
				nod_2nd_tether = getnode( "nod_luggage_tether_2", "targetname" );

				
				assertex( isdefined( trig_fire ), "trig_fire not defined" );
				assertex( isdefined( trig_tether ), "trig_tether not defined" );
				assertex( isdefined( nod_shoot ), "nod_shoot not defined" );
				assertex( isdefined( nod_2nd_tether ), "nod_2nd_tether not defined" );
				
				
				self SetEnableSense( false );

				
				self SetCombatRole( "turret" );

				
				self thread dmg_turn_sense_on();

				
				self lockalertstate( "alert_red" );

				
				self setgoalnode( nod_shoot );

				
				self waittill( "goal" );

				
				self allowedstances( "crouch" );

				
				self.tetherpt = nod_shoot.origin;
				self.tetherradius = 32;

				
				trig_fire waittill( "trigger" );

				
				self notify( "sense_on" );

				
				self SetEnableSense( true );

				
				self allowedstances( "stand", "crouch" );

				
				self thread turn_on_sense( 5 );

				
				self cmdshootatentity( level.player, true, 5, 0.75  );

				
				trig_tether waittill( "trigger" );

				
				self setcombatrole( "guardian" );

				
				self.tetherpt = nod_2nd_tether.origin;
				
				self luggage_room_active_tether( 384, 1400, 256 );
				
				
}




e4_f2_right_cover_init()
{
				
				

				
				
				trig_start = getent( "trig_run_from_point_2", "targetname" );
				
				spawner = getent( "spwn_e4_f2_right", "targetname" );
				
				ent_temp = undefined;

				
				assertex( isdefined( trig_start ), "trig_start not defined" );
				assertex( isdefined( spawner ), "spawner not defined" );

				
				spawner.count = 1;

				
				trig_start waittill( "trigger" );

				
				ent_temp = spawner stalingradspawn( "e4_enemy" );

				
				if( spawn_failed( ent_temp ) )
				{
								
								

								
								wait( 2.0 );

								
								return;
				}
				else
				{
								
								ent_temp thread e4_f2_right_shooter();
				}

				
				wait( 2.0 );

				
				ent_temp = undefined;
				spawner delete();
}





e4_f2_right_shooter()
{
				
				self endon( "death" );

				
				trig_fire = getent( "trig_e4_lug2_fight", "targetname" );
				trig_tether = getent( "trig_f2_tether2", "targetname" );
				
				nod_shoot = GetNode( "nod_e4_f2_rshot", "targetname" );
				nod_2nd_tether = getnode( "nod_luggage_tether_2", "targetname" );

				
				assertex( isdefined( trig_fire ), "trig_fire not defined" );
				assertex( isdefined( trig_tether ), "trig_tether not defined" );
				assertex( isdefined( nod_shoot ), "nod_shoot not defined" );
				assertex( isdefined( nod_2nd_tether ), "nod_2nd_tether not defined" );

				
				self SetEnableSense( false );

				
				self thread dmg_turn_sense_on();

				
				self lockalertstate( "alert_red" );

				
				self SetCombatRole( "turret" );

				
				self setgoalnode( nod_shoot );

				
				self waittill( "goal" );

				

				
				self allowedstances( "crouch" );

				
				self.tetherpt = nod_shoot.origin;
				self.tetherradius = 32;

				
				trig_fire waittill( "trigger" );

				
				self notify( "sense_on" );

				
				self SetEnableSense( true );

				
				self allowedstances( "stand", "crouch" );

				
				self thread turn_on_sense( 5 );

				

				
				self cmdshootatentity( level.player, true, 5, 0.75  );

				
				trig_tether waittill( "trigger" );

				

				
				self setcombatrole( "guardian" );

				
				self.tetherpt = nod_2nd_tether.origin;
				
				self luggage_room_active_tether( 384, 1400, 256 );


}








e4_luggage_fight_group_three()
{
				
				

				
				
				
				
				sbrush_garage_door = getent( "ent_lugg2_garage_door", "targetname" );
				ent_spwn_ground_1 = getent( "ent_e4_g3_grd1", "targetname" );
				ent_spwn_ground_2 = getent( "ent_e4_g3_grd2", "targetname" );
				ent_spwn_cat_1a = getent( "ent_e4_g3_cat1a", "targetname" );
				ent_spwn_cat_1b = getent( "ent_e4_g3_cat1b", "targetname" );
				
				start_trig = getent( "ent_start_e4_slam", "targetname" );
				
				ent_temp = undefined;
				
				noda_dest_ground_1 = getnodearray( ent_spwn_ground_1.script_parameters, "targetname" );
				noda_dest_ground_2 = getnodearray( ent_spwn_ground_2.script_parameters, "targetname" );
				nod_dest_cat_1a = getnode( ent_spwn_cat_1a.script_parameters, "targetname" );
				nod_dest_cat_1b = getnode( ent_spwn_cat_1b.script_parameters, "targetname" );
				
				nod_lugg2_tether = getnode( "lugg2_tether", "targetname" );

				
				ent_spwn_ground_1.count = noda_dest_ground_1.size;
				ent_spwn_ground_2.count = noda_dest_ground_2.size;
				ent_spwn_cat_1a.count = nod_dest_cat_1a.size;
				ent_spwn_cat_1b.count = nod_dest_cat_1b.size;

				
				start_trig waittill( "trigger" );

				
				thread maps\airport_util::clean_up_old_ai_except("e4_enemy");

				
				level notify( "e4_halon_off" );

				

				
				level notify("playmusicpackage_luggage_02");

				level thread e4_luggage_fight_catwalk_2();


				
				ent_temp = ent_spwn_cat_1a stalingradspawn( "e4_lugg2_enemy" );
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								
								
								
								
								return;
				}
				else
				{
								
								ent_temp setalertstatemin( "alert_red" );

								
								ent_temp SetCombatRole( "turret" );

								
								ent_temp thread turn_on_sense();

								
								ent_temp setgoalnode( nod_dest_cat_1a, 1 );

								
								ent_temp thread maps\airport_util::sprint_to_goal();
				}

				
				wait( 0.05 );

				
				ent_temp = undefined;

				
				ent_spwn_cat_1a delete();

				
				
				ent_temp = ent_spwn_cat_1b stalingradspawn( "e4_lugg2_enemy" );
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								
								
								
								
								return;
				}
				else
				{
								
								ent_temp setalertstatemin( "alert_red" );

								
								ent_temp SetCombatRole( "turret" );

								
								ent_temp thread turn_on_sense();

								
								ent_temp setgoalnode( nod_dest_cat_1b );

								
								ent_temp thread maps\airport_util::sprint_to_goal();
				}

				
				wait( 0.05 );

				
				ent_temp = undefined;

				
				ent_spwn_cat_1b delete();

				

				
				


				
				for( i=0; i<noda_dest_ground_1.size; i++ )
				{
								
								ent_temp = ent_spwn_ground_1 stalingradspawn( "e4_lugg2_enemy" );
								if( !maps\_utility::spawn_failed( ent_temp ) )
								{
												
												ent_temp setalertstatemin( "alert_red" );

												
												
												
												
												

												
												

												
												if( ( i + 1 ) % 2 == 0 )
												{
																
																ent_temp setgoalnode( noda_dest_ground_1[i], 1 );
												}
												else
												{
																
																ent_temp setgoalnode( noda_dest_ground_1[i] );
												}

												
												if( !IsDefined( noda_dest_ground_1[i].script_string ) )
												{
																
																
												}

												
												ent_temp thread combat_role_on_goal( noda_dest_ground_1[i].script_string );

												
												ent_temp thread maps\airport_util::sprint_to_goal(true);

												
												if( noda_dest_ground_1[i].script_string != "rusher" )
												{
																ent_temp thread give_tether_at_goal( nod_lugg2_tether, 550, 1500, 512 );
												}

												
												wait( 0.7 );

												
												ent_temp = undefined;
								}
				}
				
				
				for( i=0; i<noda_dest_ground_2.size; i++ )
				{
								
								ent_temp = ent_spwn_ground_2 stalingradspawn( "e4_lugg2_enemy" );
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												
												

												
												wait( 2.0 );

												
												return;
								}
								else
								{
												
												ent_temp setalertstatemin( "alert_red" );

												
												
												
												
												

												
												

												
												if( ( i + 1 ) % 2 == 0 )
												{
																
																ent_temp setgoalnode( noda_dest_ground_2[i], 1 );
												}
												else
												{
																
																ent_temp setgoalnode( noda_dest_ground_2[i] );
												}

												
												ent_temp thread maps\airport_util::sprint_to_goal(true);

												
												if( !IsDefined( noda_dest_ground_2[i].script_string ) )
												{
																
																
												}

												
												ent_temp thread combat_role_on_goal( noda_dest_ground_2[i].script_string );

												
												if( noda_dest_ground_2[i].script_string != "rusher" )
												{
																ent_temp thread give_tether_at_goal( nod_lugg2_tether, 550, 1500, 512 );
												}

												
												wait( 1.0 );

												
												ent_temp = undefined;
								}
				}
				
				
				
				
				
				
				trig_close_garage_door = getent( "trig_start_2nd_retreat", "targetname" );
				trig_close_garage_door waittill( "trigger" );

				
				sbrush_garage_door movez( -127, 0.5 );
				sbrush_garage_door playsound("garage_door_slam");
				
				

				
				sbrush_garage_door waittill( "movedone" );

				
				sbrush_garage_door disconnectpaths();

				
				ent_spwn_ground_1 delete();
				ent_spwn_ground_2 delete();

}





e4_luggage_fight_catwalk_2()
{
				
				

				
				
				trig_spawn = getent( "ent_start_e4_slam", "targetname" );
				
				spawner = getent( "ent_e4_g3_cat2", "targetname" );
				
				noda_cat_dest = getnodearray( spawner.script_parameters, "targetname" );
				nod_tether_3 = getnode( "nod_luggage_tether_3", "targetname" );
				nod_lugg2_tether = getnode( "lugg2_tether", "targetname" );
				
				ent_temp = undefined;
				
				
				spawner.count = noda_cat_dest.size;

				
				trig_spawn waittill( "trigger" );

				
				
				
				
	
				
	

				for( i=0; i<noda_cat_dest.size; i++ )
				{
								
								ent_temp = spawner stalingradspawn( "e4_lugg2_enemy" );
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												
												

												
												wait( 2.0 );

												
												return;
								}
								else
								{
												
												ent_temp setalertstatemin( "alert_red" );

												
												ent_temp setengagerule( "tgtSight" );
												ent_temp addengagerule( "tgtPerceive" );
												ent_temp addengagerule( "Damaged" );
												ent_temp addengagerule( "Attacked" );

												
												ent_temp thread turn_on_sense( 3 );

												if(	level.catwalk_invalid == true)
												{
													noda_cat_dest = getnodearray( "node_e4_catwalk_backup", "script_noteworthy" );
												}
												
												
												if( ( i + 1 ) % 2 == 0 )
												{
																
																ent_temp setgoalnode( noda_cat_dest[i], 1 );
												}
												else
												{
																
																ent_temp setgoalnode( noda_cat_dest[i] );
												}

												
												ent_temp thread maps\airport_util::sprint_to_goal();

												
												if( !IsDefined( noda_cat_dest[i].script_string ) )
												{
																
																
												}
												else
												{
													
													ent_temp thread combat_role_on_goal( noda_cat_dest[i].script_string );

													
													ent_temp thread sprint_to_goal();

													
													if( noda_cat_dest[i].script_string != "rusher" )
													{
														ent_temp thread give_tether_at_goal( nod_lugg2_tether, 550, 1500, 512 );
													}
												}	
								}

								
								wait( 1.5 );

								
								ent_temp = undefined;
				}

				
				wait( 4.0 );

				
				spawner delete();

}






e4_luggage_fight_group_four()
{
				

				
				
				trig = getent( "trig_lugg_3_f4", "targetname" );
				
				spawner_1 = getent( "spwn_lugg3_f4_left", "targetname" );
				spawner_2 = getent( "spwn_lugg3_f4_right", "targetname" );
				
				lugg3_tether_3 = getnode( "nod_luggage_tether_3", "targetname" );
				noda_left_side = getnodearray( spawner_1.script_parameters, "targetname" );
				noda_right_side = getnodearray( spawner_2.script_parameters, "targetname" );
				
				ent_temp = undefined;

				
				assertex( isdefined( trig ), "trig not defined, fight four" );
				assertex( isdefined( spawner_1 ), "spawner_1 not defined, fight four" );
				assertex( isdefined( spawner_2 ), "spawner_2 not defined, fight four" );
				assertex( isdefined( lugg3_tether_3 ), "lugg3_tether_3 not defined, fight four" );
				assertex( isdefined( noda_left_side ), "noda_left_side not defined, fight four" );
				assertex( isdefined( noda_right_side ), "noda_right_side not defined, fight four" );

				
				spawner_1.count = noda_left_side.size;
				spawner_2.count = noda_right_side.size;

				
				trig waittill( "trigger" );

				
				
				level maps\_autosave::autosave_now( "airport" );
				level notify("checkpoint_reached"); 

				
				level thread e4_lugg3_dialog();


				
				
				for( i=0; i<noda_left_side.size; i++ )
				{
								
								ent_temp = spawner_1 stalingradspawn( "ent_e4_lugg3" );
								
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												
												

												
												return;
								}

								
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );

								
								ent_temp setalertstatemin( "alert_red" );

								
								ent_temp thread turn_on_sense( 3 );

								if( ( i + 1 ) % 2 == 0 )
								{
												
												ent_temp setgoalnode( noda_left_side[i], 1 );
								}
								else
								{
												
												ent_temp setgoalnode( noda_left_side[i] );
								}

								
								if( !IsDefined( noda_left_side[i].script_string ) )
								{
												
												
								}

								
								ent_temp thread combat_role_on_goal( noda_left_side[i].script_string );

								
								ent_temp thread sprint_to_goal();


								
								if( noda_left_side[i].script_string != "rusher" )
								{
												ent_temp thread give_tether_at_goal( lugg3_tether_3, 384, 1024, 256 );
								}

								
								wait( 0.5 );

								
								ent_temp = undefined;
				}
				
				
				for( i=0; i<noda_right_side.size; i++ )
				{
								
								ent_temp = spawner_2 stalingradspawn( "ent_e4_lugg3" );
								
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												
												

												
												return;
								}

								
								ent_temp setengagerule( "tgtSight" );
								ent_temp addengagerule( "tgtPerceive" );
								ent_temp addengagerule( "Damaged" );
								ent_temp addengagerule( "Attacked" );

								
								ent_temp setalertstatemin( "alert_red" );

								
								ent_temp thread turn_on_sense( 3 );

								if( ( i + 1 ) % 2 == 0 )
								{
												
												ent_temp setgoalnode( noda_right_side[i], 1 );
								}
								else
								{
												
												ent_temp setgoalnode( noda_right_side[i] );
								}

								
								if( !IsDefined( noda_right_side[i].script_string ) )
								{
												
												
								}

								
								ent_temp thread combat_role_on_goal( noda_right_side[i].script_string );

								
								ent_temp thread sprint_to_goal();

								
								if( noda_right_side[i].script_string != "rusher" )
								{
												ent_temp thread give_tether_at_goal( lugg3_tether_3, 384, 1024, 256 );
								}

								
								wait( 0.8 );

								
								ent_temp = undefined;
				}
}





lugg3_catwalk_left()
{
				

				
				
				trig_setup = getent( "trig_lugg_3_f4", "targetname" );
				trig_start = getent( "trig_lugg3_catwalk", "targetname" );
				
				spawner = getent( "lugg3_catwalk_left", "targetname" );
				
				nod_lugg3_cat_left = getnode( "nod_lugg3_cat_left", "targetname" );
				
				ent_temp = undefined;

				
				assertex( isdefined( trig_setup ), "trig_setup not defined" );
				assertex( isdefined( trig_start ), "trig_start not defined" );
				assertex( isdefined( spawner ), "spawner not defined" );
				assertex( isdefined( nod_lugg3_cat_left ), "noda_lugg3_cat not defined" );

				
				spawner.count = 1;

				
				trig_setup waittill( "trigger" );

				
				ent_temp = spawner stalingradspawn( "ent_e4_lugg3" );

				
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								
								

								
								wait( 3.0 );

								
								return;
				}

				
				ent_temp endon( "death" );

				
				ent_temp lockalertstate( "alert_red" );

				
				ent_temp setgoalnode( nod_lugg3_cat_left );

				
				ent_temp waittill( "goal" );

				
				trig_start waittill( "trigger" );

				
				ent_temp thread turn_on_sense();

				
				ent_temp cmdshootatentity( level.player, true, 4, 0.4 );

}





lugg3_catwalk_right()
{
				

				
				
				trig_setup = getent( "trig_lugg_3_f4", "targetname" );
				trig_start = getent( "trig_lugg3_catwalk", "targetname" );
				
				spawner = getent( "lugg3_catwalk_right", "targetname" );
				
				nod_lugg3_cat_right = getnode( "nod_lugg3_cat_right", "targetname" );
				
				ent_temp = undefined;

				
				assertex( isdefined( trig_setup ), "trig_setup not defined" );
				assertex( isdefined( trig_start ), "trig_start not defined" );
				assertex( isdefined( spawner ), "spawner not defined" );
				assertex( isdefined( nod_lugg3_cat_right ), "noda_lugg3_cat not defined" );

				
				spawner.count = 1;

				
				trig_setup waittill( "trigger" );

				
				ent_temp = spawner stalingradspawn( "ent_e4_lugg3" );

				
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								
								

								
								wait( 3.0 );

								
								return;
				}

				
				ent_temp endon( "death" );

				
				ent_temp lockalertstate( "alert_red" );

				
				ent_temp setgoalnode( nod_lugg3_cat_right );

				
				ent_temp waittill( "goal" );

				
				trig_start waittill( "trigger" );

				
				ent_temp thread turn_on_sense();

				
				ent_temp cmdshootatentity( level.player, true, 4, 0.4 );

}






e4_luggage_fight_group_five()
{
				
				

				
				
				trig = getent( "trig_lugg3_f5", "targetname" );
				
				spwn_lugg3_f5_left = getent( "ent_spwn_lugg3_f5_left", "targetname" );
				spwn_lugg3_f5_right = getent( "ent_spwn_lugg3_f5_right", "targetname" );
				
				noda_lugg3_f5_left = getnodearray( spwn_lugg3_f5_left.script_parameters, "targetname" );
				noda_lugg3_f5_right = getnodearray( spwn_lugg3_f5_right.script_parameters, "targetname" );
				nod_tether_4 = getnode( "nod_luggage_tether_4", "targetname" );
				
				ent_temp = undefined;

				
				spwn_lugg3_f5_left.count = noda_lugg3_f5_left.size;
				spwn_lugg3_f5_right.count = noda_lugg3_f5_right.size;

				
				trig waittill( "trigger" );

				

				
				for( i=0; i<noda_lugg3_f5_left.size; i++ )
				{
								
								ent_temp = spwn_lugg3_f5_left stalingradspawn( "ent_e4_lugg3" );
								
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												
												

												
												wait( 2.0 );

												
												return;
								}

								
								assertex( isdefined( noda_lugg3_f5_left[i].script_string ), "noda_lugg3_f5_right missing script_string" );

								
								
								ent_temp setalertstatemin( "alert_red" );

								
								ent_temp thread turn_on_sense();

								
								if( ( i + 1 ) % 2 == 1 )
								{
												
												ent_temp setgoalnode( noda_lugg3_f5_left[i], 1 );
								}
								
								else
								{
												
												ent_temp setgoalnode( noda_lugg3_f5_left[i] );
								}

								
								ent_temp thread combat_role_on_goal( noda_lugg3_f5_left[i].script_string );

								
								ent_temp thread maps\airport_util::sprint_to_goal();

								if( noda_lugg3_f5_left[i].script_string != "rusher" )
								{ 
												
												ent_temp thread give_tether_at_goal( nod_tether_4, 384, 1800, 256 );
								}

								
								wait( 0.2 );

								
								ent_temp = undefined;
				}

				
				
				
				for( i=0; i<noda_lugg3_f5_right.size; i++ )
				{
								
								ent_temp = spwn_lugg3_f5_right stalingradspawn( "ent_e4_lugg3" );
								
								if( maps\_utility::spawn_failed( ent_temp ) )
								{
												
												

												
												wait( 2.0 );

												
												return;
								}

								
								assertex( isdefined( noda_lugg3_f5_right[i].script_string ), "noda_lugg3_f5_right missing script_string" );

								
								
								ent_temp setalertstatemin( "alert_red" );

								
								ent_temp thread turn_on_sense();

								
								if( ( i + 1 ) % 2 == 0 )
								{
												
												ent_temp setgoalnode( noda_lugg3_f5_right[i], 1 );
								}
								
								else
								{
												
												ent_temp setgoalnode( noda_lugg3_f5_right[i] );
								}

								
								ent_temp thread combat_role_on_goal( noda_lugg3_f5_right[i].script_string );

								
								ent_temp thread maps\airport_util::sprint_to_goal();

								if( noda_lugg3_f5_right[i].script_string != "rusher" )
								{
												
												ent_temp thread give_tether_at_goal( nod_tether_4, 384, 1800, 256 );
								}

								
								wait( 1.2 );

								
								ent_temp = undefined;
				}

				
				wait( 4.0 );

				
				spwn_lugg3_f5_left delete();
				spwn_lugg3_f5_right delete();

				
				level thread quick_end();

}




luggage_init()
{
				

				
				
				
				
				trig = getent( "ent_start_e4_slam", "targetname" );
				
				
				
				
				
				
				
				
				conveyor_a_s0 = getent( "ent_luggage_a_s0", "targetname" );
				conveyor_a_s1 = getent( "ent_luggage_a_s1", "targetname" );
				conveyor_a_s2 = getent( "ent_luggage_a_s2", "targetname" );
				conveyor_a_s3 = getent( "ent_luggage_a_s3", "targetname" );
				conveyor_a_s4 = getent( "ent_luggage_a_s4", "targetname" );
				conveyor_a_s5 = getent( "ent_luggage_a_s5", "targetname" );
				conveyor_a_s6 = getent( "ent_luggage_a_s6", "targetname" );

				
				
				conveyor_b_s0 = getent( "ent_luggage_b_s0", "targetname" );
				conveyor_b_s1 = getent( "ent_luggage_b_s1", "targetname" );
				conveyor_b_s2 = getent( "ent_luggage_b_s2", "targetname" );
				conveyor_b_s3 = getent( "ent_luggage_b_s3", "targetname" );
				conveyor_b_s4 = getent( "ent_luggage_b_s4", "targetname" );
				conveyor_b_s5 = getent( "ent_luggage_b_s5", "targetname" );
				conveyor_b_s6 = getent( "ent_luggage_b_s6", "targetname" );

				
				
				conveyor_c_s0 = getent( "ent_luggage_c_s0", "targetname" );
				conveyor_c_s1 = getent( "ent_luggage_c_s1", "targetname" );
				conveyor_c_s2 = getent( "ent_luggage_c_s2", "targetname" );
				conveyor_c_s3 = getent( "ent_luggage_c_s3", "targetname" );
				conveyor_c_s4 = getent( "ent_luggage_c_s4", "targetname" );
				conveyor_c_s5 = getent( "ent_luggage_c_s5", "targetname" );
				conveyor_c_s6 = getent( "ent_luggage_c_s6", "targetname" );

				
				
				conveyor_d_s0 = getent( "ent_luggage_d_s0", "targetname" );
				conveyor_d_s1 = getent( "ent_luggage_d_s1", "targetname" );
				conveyor_d_s2 = getent( "ent_luggage_d_s2", "targetname" );
				conveyor_d_s3 = getent( "ent_luggage_d_s3", "targetname" );
				conveyor_d_s4 = getent( "ent_luggage_d_s4", "targetname" );

				
				
				conveyor_e_s0 = getent( "ent_luggage_e_s0", "targetname" );
				conveyor_e_s1 = getent( "ent_luggage_e_s1", "targetname" );
				conveyor_e_s2 = getent( "ent_luggage_e_s2", "targetname" );
				conveyor_e_s3 = getent( "ent_luggage_e_s3", "targetname" );
				conveyor_e_s4 = getent( "ent_luggage_e_s4", "targetname" );
				conveyor_e_s5 = getent( "ent_luggage_e_s5", "targetname" );
				conveyor_e_s6 = getent( "ent_luggage_e_s6", "targetname" );

				
				
				conveyor_h_s0 = getent( "ent_luggage_h_s0", "targetname" );
				
				
				
				

				
				
				conveyor_f_s0 = getent( "ent_luggage_f_s0", "targetname" );
				conveyor_f_s1 = getent( "ent_luggage_f_s1", "targetname" );
				conveyor_f_s2 = getent( "ent_luggage_f_s2", "targetname" );
				conveyor_f_s3 = getent( "ent_luggage_b_s3", "targetname" );
				conveyor_f_s4 = getent( "ent_luggage_b_s4", "targetname" );

				
				
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

				
				
				
				


				
				
				
				
				

				
				
				conveyor_a_s0 thread conveyor_start();
				conveyor_a_s1 thread conveyor_start();
				conveyor_a_s2 thread conveyor_start();
				conveyor_a_s3 thread conveyor_start();
				conveyor_a_s4 thread conveyor_start();
				conveyor_a_s5 thread conveyor_start();
				conveyor_a_s6 thread conveyor_start();
				
				conveyor_b_s0 thread conveyor_start();
				conveyor_b_s1 thread conveyor_start();
				conveyor_b_s2 thread conveyor_start();
				conveyor_b_s3 thread conveyor_start();
				conveyor_b_s4 thread conveyor_start();
				conveyor_b_s5 thread conveyor_start();
				conveyor_b_s6 thread conveyor_start();
				
				conveyor_c_s0 thread conveyor_start();
				conveyor_c_s1 thread conveyor_start();
				conveyor_c_s2 thread conveyor_start();
				conveyor_c_s3 thread conveyor_start();
				conveyor_c_s4 thread conveyor_start();
				conveyor_c_s5 thread conveyor_start();
				conveyor_c_s6 thread conveyor_start();
				
				conveyor_d_s0 thread conveyor_start();
				conveyor_d_s1 thread conveyor_start();
				conveyor_d_s2 thread conveyor_start();
				conveyor_d_s3 thread conveyor_start();
				conveyor_d_s4 thread conveyor_start();
				
				conveyor_e_s0 thread conveyor_start();
				conveyor_e_s1 thread conveyor_start();
				conveyor_e_s2 thread conveyor_start();
				conveyor_e_s3 thread conveyor_start();
				conveyor_e_s4 thread conveyor_start();
				conveyor_e_s5 thread conveyor_start();
				conveyor_e_s6 thread conveyor_start();
				
				conveyor_h_s0 thread conveyor_start();

				
				wait( 5.0 );

				
				level thread conveyor_belt_a_lugg_init();
				
				level thread conveyor_belt_b_lugg_init();
				
				level thread conveyor_belt_c_lugg_init();
				
				level thread conveyor_belt_d_lugg_init();
				
				level thread conveyor_belt_e_lugg_init();
				
				level thread conveyor_belt_h_lugg_init();
				

				
				trig waittill( "trigger" );

				
				conveyor_f_s0 thread conveyor_start();
				conveyor_f_s1 thread conveyor_start();
				conveyor_f_s2 thread conveyor_start();
				conveyor_f_s3 thread conveyor_start();
				conveyor_f_s4 thread conveyor_start();

				
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






conveyor_start()
{
				
				vec_direction = undefined;

				
				assertex( isdefined( self.script_vector ), "" + self.targetname + " has no script_vector, can't get teh angles!" );

				
				

				
				
				vec_direction = anglestoforward( self.script_vector ) * 75;

				
				self setconveyor( vec_direction );

}




conveyor_belt_a_lugg_init()
{
				

				
				belt_start = getent( "con_lug_a_start", "targetname" );
				belt_end = getent( "con_lug_a_end", "targetname" );
				
				
				
				
				
				str_end_on = "entered_lugg2";
				
				belt_start_g = getent( "con_lug_g_start", "targetname" );
				belt_end_g = getent( "con_lug_g_end", "targetname" );

				
				level thread luggage_control( "belt_a_0", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_a_1", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_a_2", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_a_3", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_a_4", belt_start, belt_end, "entered_lugg2" );

				
				level waittill( "entered_lugg2" );

				
				level thread luggage_control( "belt_a_0", belt_start_g, belt_end_g, "e5_complete" );
				wait( 2.0 );
				level thread luggage_control( "belt_a_1", belt_start_g, belt_end_g, "e5_complete" );
				wait( 2.0 );
				level thread luggage_control( "belt_a_2", belt_start_g, belt_end_g, "e5_complete" );
				wait( 2.0 );
				level thread luggage_control( "belt_a_3", belt_start_g, belt_end_g, "e5_complete" );
				wait( 2.0 );
				level thread luggage_control( "belt_a_4", belt_start_g, belt_end_g, "e5_complete" );

				
				level notify( "b_to_g" );

}

conveyor_belt_b_lugg_init()
{
				

				
				belt_start = getent( "con_lug_b_start", "targetname" );
				belt_end = getent( "con_lug_b_end", "targetname" );
				
				
				belt_start_g = getent( "con_lug_g_start", "targetname" );
				belt_end_g = getent( "con_lug_g_end", "targetname" );

				
				level thread luggage_control( "belt_b_0", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_b_1", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_b_2", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_b_3", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_b_4", belt_start, belt_end, "entered_lugg2" );

				
				level waittill( "entered_lugg2" );

				
				level waittill( "b_to_g" );

				
				level thread luggage_control( "belt_b_0", belt_start_g, belt_end_g, "e5_complete" );
				wait( 3.0 );
				level thread luggage_control( "belt_b_1", belt_start_g, belt_end_g, "e5_complete" );
				wait( 3.0 );
				level thread luggage_control( "belt_b_2", belt_start_g, belt_end_g, "e5_complete" );
				wait( 3.0 );
				level thread luggage_control( "belt_b_3", belt_start_g, belt_end_g, "e5_complete" );
				wait( 3.0 );
				level thread luggage_control( "belt_b_4", belt_start_g, belt_end_g, "e5_complete" );

}

conveyor_belt_c_lugg_init()
{
				

				
				belt_start = getent( "con_lug_c_start", "targetname" );
				belt_end = getent( "con_lug_c_end", "targetname" );
				
				
				belt_start_g = getent( "con_lug_g_start", "targetname" );
				belt_end_g = getent( "con_lug_g_end", "targetname" );

				
				level thread luggage_control( "belt_c_0", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_c_1", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_c_2", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_c_3", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_c_4", belt_start, belt_end, "entered_lugg2" );

				
				level waittill( "entered_lugg2" );

				
				level thread luggage_control( "belt_c_0", belt_start_g, belt_end_g, "e5_complete" );
				wait( 2.0 );
				level thread luggage_control( "belt_c_1", belt_start_g, belt_end_g, "e5_complete" );
				wait( 2.0 );
				level thread luggage_control( "belt_c_2", belt_start_g, belt_end_g, "e5_complete" );
				wait( 2.0 );
				level thread luggage_control( "belt_c_3", belt_start_g, belt_end_g, "e5_complete" );
				wait( 2.0 );
				level thread luggage_control( "belt_c_4", belt_start_g, belt_end_g, "e5_complete" );

				
				level notify( "d_to_f" );

}

conveyor_belt_d_lugg_init()
{
				

				
				belt_start = getent( "con_lug_d_start", "targetname" );
				belt_end = getent( "con_lug_d_end", "targetname" );
				
				
				belt_start_f = getent( "con_lug_f_start", "targetname" );
				belt_end_f = getent( "con_lug_f_end", "targetname" );

				
				level thread luggage_control( "belt_d_0", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_d_1", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_d_2", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_d_3", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_d_4", belt_start, belt_end, "entered_lugg2" );

				
				level waittill( "entered_lugg2" );

				
				level waittill( "d_to_f" );

				
				level thread luggage_control( "belt_d_0", belt_start_f, belt_end_f, "e5_complete" );
				wait( 8.0 );
				level thread luggage_control( "belt_d_1", belt_start_f, belt_end_f, "e5_complete" );
				wait( 8.0 );
				level thread luggage_control( "belt_d_2", belt_start_f, belt_end_f, "e5_complete" );
				wait( 8.0 );
				level thread luggage_control( "belt_d_3", belt_start_f, belt_end_f, "e5_complete" );
				wait( 8.0 );
				level thread luggage_control( "belt_d_4", belt_start_f, belt_end_f, "e5_complete" );

				
				level notify( "e_to_f" );


}

conveyor_belt_e_lugg_init()
{
				

				
				belt_start = getent( "con_lug_e_start", "targetname" );
				belt_end = getent( "con_lug_e_end", "targetname" );
				
				
				belt_start_f = getent( "con_lug_f_start", "targetname" );
				belt_end_f = getent( "con_lug_f_end", "targetname" );

				
				level thread luggage_control( "belt_e_0", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_e_1", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_e_2", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_e_3", belt_start, belt_end, "entered_lugg2" );
				wait( 8.0 );
				level thread luggage_control( "belt_e_4", belt_start, belt_end, "entered_lugg2" );

				
				level waittill( "entered_lugg2" );

				
				level waittill( "e_to_f" );

				
				level thread luggage_control( "belt_e_0", belt_start_f, belt_end_f, "e5_complete" );
				wait( 8.0 );
				level thread luggage_control( "belt_e_1", belt_start_f, belt_end_f, "e5_complete" );
				wait( 8.0 );
				level thread luggage_control( "belt_e_2", belt_start_f, belt_end_f, "e5_complete" );
				wait( 8.0 );
				level thread luggage_control( "belt_e_3", belt_start_f, belt_end_f, "e5_complete" );
				wait( 8.0 );
				level thread luggage_control( "belt_e_4", belt_start_f, belt_end_f, "e5_complete" );

}

conveyor_belt_h_lugg_init()
{
				

				
				belt_start = getent( "con_lug_h_start", "targetname" );
				belt_end = getent( "con_lug_h_end", "targetname" );
				belt_lugg_one = "belt_h_0";
				belt_lugg_two = "belt_h_1";
				belt_lugg_three = "belt_h_2";
				belt_lugg_four = "belt_h_3";
				belt_lugg_five = "belt_h_4";
				str_end_on = "event_5_complete";

				
				level thread luggage_control( "belt_h_0", belt_start, belt_end, "event_5_complete" );
				wait( 8.0 );
				level thread luggage_control( "belt_h_1", belt_start, belt_end, "event_5_complete" );
				wait( 8.0 );
				level thread luggage_control( "belt_h_2", belt_start, belt_end, "event_5_complete" );
				wait( 8.0 );
				level thread luggage_control( "belt_h_3", belt_start, belt_end, "event_5_complete" );
				wait( 8.0 );
				level thread luggage_control( "belt_h_4", belt_start, belt_end, "event_5_complete" );

}







luggage_control( str_luggage, ent_so_start, end_point, str_end_on )
{
				if( isdefined( str_end_on ) )
				{	
								
								level endon( str_end_on );
				}

				
				if(IsDefined(str_luggage))
				{
					level thread setup_luggage_flaps(str_luggage);
				}

				

				

				
				temp_vec = undefined;
				temp_org = undefined;

				

				while( 1 )
				{
								
								dynent_stopphysics( str_luggage );

								
								dynent_setvisible( str_luggage, 0 );

								
								wait( 0.15 );

								
								dynent_setorigin( str_luggage, ent_so_start.origin );

								
								wait( 0.15 );

								
								dynent_setvisible( str_luggage, 1 );

								
								wait( 0.15 );

								
								dynent_startphysics( str_luggage );

								
								while( 1 )
								{
												
												temp_org = dynent_getorigin( str_luggage );

												
												if( distance( temp_org, end_point.origin ) < 50 )
												{
																
																break;
												}
												else
												{
																
																wait( randomfloatrange( 2.0, 3.5 ) );
												}

								}

				}
}



e4_r2_catwalk_explosion()
{
				


				
				trig = getent( "trig_catwalk_explo", "targetname" );
				explosion_point = getent( "so_catwalk_explo", "targetname" );
				
				
				
				

				
				
				
				while( 1 )
				{
								
								
								trig waittill( "damage", amount, attacker, direction_vec, point, type );

								
								if( attacker == level.player )
								{
												
												break;
								}
								else
								{
												
												wait( 0.5 );
								}
				}

				
				earthquake( 0.7, 2.5, level.player.origin, 850 );

				
				level thread maps\airport_util::air_ctrl_rumble_timer( 1 );

				
				level notify( "catwalk02_start" );

				
				cliparray = getentarray("catwalk_explosion_clip", "targetname");
				if(isdefined(cliparray))
				{
					for(i = 0; i < cliparray.size; i++)
					{
						cliparray[i] delete();
					}
				}
				
				catwalk_explo = playfx( level._effect[ "f_explosion" ], explosion_point.origin );

				
				explosion_point playsound( "airport_catwalk_explosion" );
				
				

				
				

				
				

				
				radiusdamage( explosion_point.origin, 300, 600, 200 );
				radiusdamage( explosion_point.origin + ( 0, 0, -25 ), 300, 600, 200 );

				
				

				
				badplace_cylinder( "catwalk_explosion", 0, explosion_point.origin, 256, 182, "axis" );

				
				
				
				

}




e4_slam_cam()
{
				
				start_trig = getent( "ent_start_e4_slam", "targetname" );
				
				
				
				
				

				
				
				
				

				
				start_trig waittill( "trigger" );

				
				

				
				level thread e4_luggage_fight_group_three();

				
				level notify ( "entered_lugg2" );

				
				
				level maps\_autosave::autosave_now( "airport" );
				level notify("checkpoint_reached"); 

				
				
				
				
				level.player maps\_utility::play_dialogue( "M_AirpG_046A", true ); 


}




e4_fence_explosion()
{
				
				level.player endon( "death" );

				
				
				dmg_trig = getent( "ent_e4_trig_fence_explo", "targetname" );
				
				scr_org_bash = getent( "ent_e4_door_bash_exit", "targetname" );

				
				while( 1 )
				{
								
								
								dmg_trig waittill( "damage", amount, attacker, direction_vec, point, type );

								
								if( attacker == level.player )
								{
												
												break;
								}
								else
								{
												
												wait( 0.5 );
								}
				}

				
				
				
				level notify( "exit_explode_start" );

				
				scr_org_bash playsound( "Airport_Huge_Explosion" );
				

				
				fence_explosion = playfx( level._effect[ "f_explosion" ], scr_org_bash.origin );

				
				radiusdamage( scr_org_bash.origin, 300, 600, 200 );

				
				earthquake( 0.7, 1.0, scr_org_bash.origin, 200 );

				
				

				
				
				

				
				
				
				
}


























lugg2_lookat_layer()
{
				

				
				
				trig = getent( "ent_lugg2_lookat", "targetname" );
				vehicle = getent( "vehic_lugg2_lookat", "targetname" );
				
				vnod_vehic_start = getvehiclenode( vehicle.target, "targetname" );

				
				vehicle attachpath( vnod_vehic_start );

				
				trig waittill( "trigger" );

				
				
				

				
				vehicle startpath();

				
				


}





e4_light_blinking()
{
				
				
				level endon( "e5_complete" );

				
				light_blinker = getent( "lugg3_light1", "targetname" );

				
				while( 1 )
				{
								
								light_blinker setlightintensity( 0.0 );

								
								wait( randomfloatrange( 0.3, 0.7 ) );

								
								light_blinker setlightintensity( 1.0 );

								
								wait( randomfloatrange( 0.1, 1.5 ) );
				}

}











































































e4_lugg3_dialog()
{
				
				

				
				level.player maps\_utility::play_dialogue( "M_AirpG_029A", true );

				
				level notify("playmusicpackage_luggage_02");

				
				level.player maps\_utility::play_dialogue( "LGM4_AirpG_028A" );
}





e4_lead_into_lugg2()
{
				
				level.player endon( "death" );

				
				
				trig_setup = getent( "trig_e4_lug2_fight", "targetname" );
				trig_lookat = getent( "trig_lookat_lead_2_lugg2", "targetname" );
				trig_touch = getent( "trig_start_r1_luugage_sur", "targetname" );
				
				spawner = getent( "spwn_lead_into_lugg2", "targetname" );
				
				destin_node = GetNode( "nod_lead_into_lugg2", "targetname" );
				
				ent_temp = undefined;

				
				assertex( isdefined( trig_setup ), "trig_setup not defined" );
				assertex( isdefined( trig_lookat ), "trig_lookat not defined" );
				assertex( isdefined( trig_touch ), "trig_touch not defined" );
				assertex( isdefined( spawner ), "spawner not defined" );
				assertex( isdefined( destin_node ), "destin_node not defined" );

				
				if( spawner.count < 1 )
				{
								
								spawner.count = 1;
				}

				
				trig_setup waittill( "trigger" );

				
				ent_temp = spawner stalingradspawn( "e4_enemy" );

				
				if( maps\_utility::spawn_failed( ent_temp ) )
				{
								
								

								
								wait( 5.0 );

								
								return;
				}

				
				ent_temp endon( "death" );

				
				ent_temp setenablesense( false );

				
				level maps\_utility::wait_for_either_trigger( "trig_lookat_lead_2_lugg2", "trig_start_r1_luugage_sur" );

				
				ent_temp setenablesense( true );

				ent_temp lockalertstate( "alert_red" );

				
				ent_temp setcombatrole( "turret" );

				
				ent_temp thread maps\airport_util::turn_on_sense( 5 );

				
				ent_temp setgoalnode( destin_node, 1 );

}





e4_clean_up()
{
				
				

				
				
				trig = getent( "ent_start_e4_slam", "targetname" );
				
				enta_spawners_a = getentarray( "e4_spawners_a", "script_noteworthy" );
				enta_spawners_b = getentarray( "e4_spawners_b", "script_noteworthy" );


				
				trig waittill( "trigger" );

				
				
				for( i=0; i<enta_spawners_a.size; i++ )
				{
								
								enta_spawners_a[i] delete();

								
								wait( 0.05 );
				}

				
				wait( 0.05 );

				
				
				

				
				level waittill( "airport_four_done" );

				
				level thread e4_garage_door_lights();

				
				for( i=0; i<enta_spawners_b.size; i++ )
				{
								
								enta_spawners_b[i] delete();

								
								wait( 0.05 );
				}

}



e4_garage_door_lights()
{
				


				
				gdoor_light_1a = getent( "light_gdoor_1", "targetname" );
				gdoor_light_1b = getent( "light_gdoor_1a", "targetname" );
				gdoor_light_2a = getent( "light_gdoor_2", "targetname" );
				gdoor_light_2b = getent( "light_gdoor_2a", "targetname" );
				gdoor_light_3a = getent( "light_gdoor_3", "targetname" );
				gdoor_light_3b = getent( "light_gdoor_3a", "targetname" );

				
				

				
				

				
				level thread e4_light_flicker( gdoor_light_2a, gdoor_light_2b, "event_5_complete" );

				
				

}



e4_light_flicker( ent_light, ent_light_2, str_endon )
{

				
				assertex( isdefined( ent_light ), "ent_light not defined" );
				assertex( isdefined( ent_light_2 ), "ent_light_2 not defined" );
				assertex( isdefined( str_endon ), "str_endon not defined" );

				
				level endon( str_endon );

				
				while( 1 )
				{
								
								wait( randomint( 5 ) );

								
								ent_light setlightintensity( 0 );
								ent_light_2 setlightintensity( 0 );

								
								wait( randomint( 6 ) );

								
								ent_light setlightintensity( 1 );
								ent_light_2 setlightintensity( 1 );

								
								wait( randomint( 3 ) );
				}
}





setup_luggage_flaps(str_luggage)
{
	if(!IsDefined(str_luggage))
	return;
	
	i = 0;
	
	
	for(i=1; i<12; i++)
	{
		luggage_flaps_array[i] = getent("fxanim_luggage_flaps_"+i, "targetname");
		
		
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



















