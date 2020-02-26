





#include maps\_utility;

airport_util_main()
{



}





loop_print3d( vec_text_position, str_text, color, seconds, str_notify, alpha, scale )
{
				
				self endon( "death" );
				self endon( "damage" );

				
				assertex( isdefined( vec_text_position ), "Position for a loop_print3d is not set, ending function." );

				if( !isdefined( str_notify ) )
				{
								str_notify = "no_notify";
				}
				if( !isdefined( alpha ) )
				{
								alpha = 1;
				}
				if( !isdefined( scale ) )
				{
								scale = 0.5;
				}
				timer = GetTime() + seconds;
				while( GetTime() < timer )
				{
								
								print3d( vec_text_position, str_text, color, alpha, scale );
								wait( 0.05 );
				}

				level notify( str_notify );


}




airport_objectives()
{
				

				
				
				objective_1_marker = getent( "ent_air_comp_1", "targetname" );
				objective_2_marker = getent( "ent_air_comp_2", "targetname" );
				objective_3_marker = getent( "ent_air_comp_3", "targetname" );
				objective_4a_marker = getent( "obj_4a_mark", "targetname" );
				objective_4b_marker = getent( "obj_4b_mark", "targetname" );
				objective_4c_marker = getent( "obj_4c_mark", "targetname" );
				objective_5_marker = getent( "ent_e5_gdoor_button", "targetname" );
				
				trig_move_to_4b = getent( "ent_start_e4_slam", "targetname" );
				trig_move_to_4c = getent( "trig_lugg_3_f4", "targetname" );

				
				

				
				enta_trig_air_objectives = getentarray( "hack_computers", "script_noteworthy" );

				
				level.computer_array = [];

				
				temp_container = undefined;

				
				
				
				
				
				
				temp_container = objective_1_marker setup_objective_reactions();
				
				
				
				level.computer_array = maps\_utility::array_add( level.computer_array, temp_container );
				
				
				
				temp_contianer = undefined;

				
				wait( 0.05 );

				
				temp_container = objective_2_marker setup_objective_reactions();
				
				level.computer_array = maps\_utility::array_add( level.computer_array, temp_container );
				
				temp_contianer = undefined;

				
				wait( 0.05 );

				
				temp_container = objective_3_marker setup_objective_reactions();
				
				level.computer_array = maps\_utility::array_add( level.computer_array, temp_container );
				
				temp_contianer = undefined;

				
				if( !maps\_utility::flag( "objective_1" ) )
				{
								

								
								level waittill( "give_1st_obj" );

								objective_add( 1, "current", &"AIRPORT_OBJ_1_TITLE", objective_1_marker.origin, &"AIRPORT_OBJ_1_BODY" );
								
								
								
								
								level maps\_utility::flag_wait( "objective_1" );
								
				}

				
				if( !maps\_utility::flag( "objective_2" ) )
				{
								
								
								objective_add( 1, "current", &"AIRPORT_OBJ_2_TITLE", objective_2_marker.origin, &"AIRPORT_OBJ_2_BODY" );
								
								level maps\_utility::flag_wait( "objective_2" );
								
				}

				
				if( !maps\_utility::flag( "objective_3" ) )
				{
								
								objective_add( 1, "current", &"AIRPORT_OBJ_3_TITLE", objective_3_marker.origin, &"AIRPORT_OBJ_3_BODY" );
								
								level maps\_utility::flag_wait( "objective_3" );
								
				}

				
				if( !maps\_utility::flag( "objective_4" ) )
				{

								
								
								objective_add( 1, "current", &"AIRPORT_OBJ_4_TITLE", objective_4a_marker.origin, &"AIRPORT_OBJ_4_BODY" );

								
								trig_move_to_4b waittill( "trigger" );

								
								objective_add( 1, "current", &"AIRPORT_OBJ_4_TITLE", objective_4b_marker.origin, &"AIRPORT_OBJ_4_BODY" );

								
								trig_move_to_4c waittill( "trigger" );

								
								objective_add( 1, "current", &"AIRPORT_OBJ_4_TITLE", objective_4c_marker.origin, &"AIRPORT_OBJ_4_BODY" );

								
								level maps\_utility::flag_wait( "objective_4" );
								
				}

				
				if( !maps\_utility::flag( "objective_5" ) )
				{
								
								
								
								objective_add( 1, "current", &"AIRPORT_OBJ_5_TITLE", objective_5_marker.origin, &"AIRPORT_OBJ_5_BODY" );
								
								level maps\_utility::flag_wait( "objective_5" );
								
				}

				
				level waittill( "carlos_made" );

				
				if( !maps\_utility::flag( "objective_6" ) )
				{
								
								objective_add( 1, "current", &"AIRPORT_OBJ_6_TITLE", level.carlos.origin, &"AIRPORT_OBJ_6_BODY" );

								
								level maps\_utility::flag_wait( "objective_6" );

				}



}



setup_objective_reactions()
{
				

				
				
				
				
				
				
				
				
				
				
				
				

				

				
				str_flag = undefined;
				int_which_message = undefined;
				
				entity = self;
				on_use_function = ::temp_hack_computer;
				hint_string = &"HINT_HACK_COMPUTER";
				
				use_time = self.script_int;
				use_text = undefined; 
				single_use = true ;
				require_lookat = true;
				initially_active = true;
				
				ent_return = undefined;


				if( self.script_string == "download" )
				{
								use_text = &"AIRPORT_DOWNLOAD_VIRUS";
								if( !maps\_utility::flag( "objective_1" ) )
								{
												str_flag = "objective_1";
												int_which_message = 0;
								}
								else if( maps\_utility::flag( "objective_1" ) && !maps\_utility::flag( "objective_2" ) )
								{
												str_flag = "objective_2";
												int_which_message = 0;
								}

				}
				else if( self.script_string == "upload" )
				{
								use_text = &"AIRPORT_UPLOAD_VIRUS";
								str_flag = "objective_3";
								int_which_message = 1;

				}

				
				
				ent_return = self maps\_useableobjects::create_useable_object( entity, on_use_function, hint_string, use_time, use_text, single_use, require_lookat, initially_active );

				
				return ent_return;

}




airport_laptop_count( awareness_entity_name )
{
				
				int_amount = undefined;

				
				level.awareness_obj++;

				
				int_amount = level.awareness_obj;

				
				

				wait( 1.0 );

				if( level.awareness_obj == 3 )
				{
								level playerawareness_laptop_success();
				}
}



playerawareness_laptop_success()
{
				
				

				wait( 2.0 );

				
}

temp_hack_computer( thing )
{
				
				str_flag = undefined;
				int_which_message = undefined;
				player_spot = undefined;
				mover = undefined;

				
				if( !maps\_utility::flag( "objective_1" ) )
				{
								str_flag = "objective_1";
								int_which_message = 0;
								player_spot = getent( "ent_obj_1", "targetname" );
				}
				else if( maps\_utility::flag( "objective_1" ) && !maps\_utility::flag( "objective_2" ) )
				{
								str_flag = "objective_2";
								int_which_message = 0;
								player_spot = getent( "ent_obj_2", "targetname" );
				}
				else if( maps\_utility::flag( "objective_1" ) && maps\_utility::flag( "objective_2" ) && !maps\_utility::flag( "objective_3" ) )
				{
								str_flag = "objective_3";
								int_which_message = 1;
								player_spot = getent( "ent_obj_3", "targetname" );
				}

				
				level.player playsound( "AIR_computer_hack" );

				level notify( "hack_complete" );

				
				
				
				level maps\_utility::flag_set( str_flag );
				level notify( str_flag );
				


				
				if( int_which_message == 0 )
				{
								
								
				}
				else if( int_which_message == 1 )
				{
								
								
				}

}













event_enemy_watch( str_endon, str_notify )
{
				
				self endon( "death" );
				level endon( str_endon );

				
				
				
				self waittill( "start_propagation" );

				
				

				
				level notify( str_notify );

}











event_camera_watch( str_endon, str_notify )
{
				
				self endon( "disable" );
				self endon( "damage" );
				level endon( str_endon );

				
				self waittill( "spotted" );

				
				
				level notify( str_notify );

}










event_camera_destroyed( str_endon, str_notify )
{
				
				self endon( "disable" );
				level endon( str_endon );

				
				self waittill( "damage" );

				
				level notify( str_notify );

}









event_camera_disable( str_waittill )
{
				
				self endon( "disable" );
				self endon( "damage" );

				
				level waittill( str_waittill );

				
				self notify( "disable" );
}












spawn_event_backup_init( spawner, node_array_defense )
{
				

				
				assertex( isdefined( spawner ), "spawner is not defined for backup!" );
				assertex( isdefined( node_array_defense ), "spawner is not defined for backup!" );

				level thread spawn_event_backup( spawner, node_array_defense );

}














spawn_event_backup( spawner, noda_destin )
{
				
				assertex( isdefined( spawner ), "spawner not defined, function will fail!" );
				
				
				
				
				
				assertex( isdefined( noda_destin ), "noda_destin not defined, function will fail!" );

				
				str_dood_targetname = undefined;
				
				int_tether_radius = undefined;
				
				ent_temp = undefined;
				
				int_choice = undefined;
				
				str_brain = undefined;

				
				
				if( isdefined( spawner.script_parameters ) )
				{
								str_dood_targetname = spawner.script_parameters;
				}
				else
				{
								
				}

				
				
				
				if( isdefined( spawner.script_int ) )
				{
								
								int_tether_radius = spawner.script_int;
				}
				else
				{
								
								int_tether_radius = 448;
				}

				
				
				spawner.count = noda_destin.size;

				
				
				
				
				for( i=0; i<noda_destin.size; i++ )
				{
								
								ent_temp = spawner stalingradspawn( str_dood_targetname );
								if( !maps\_utility::spawn_failed( ent_temp ) )
								{
												
												ent_temp lockalertstate( "alert_red" );

												
												
												
												

												
												
												
												

												
												

												
												

												
												ent_temp thread turn_on_sense();

												
												ent_temp setgoalnode( noda_destin[i] );

												
												ent_temp thread give_tether_at_goal( noda_destin[i], 384, 1028, 256 );

												
												wait( 1.0 );

								}
								else
								{
												
												return;
								}

								
								wait( 1.0 );

								
								ent_temp = undefined;

				}

}






airport_give_me_brain( int_brain )
{
				

				
				str_brain = undefined;

				
				
				
				choice = int_brain;

				
				switch( choice )
				{
								
				case 0:
								str_brain = "flanker";

								
								break;

								
				case 1:
								str_brain = "flanker";

								
								break;

								
				case 2:
								str_brain = "rusher";

								
								break;

								
				case 3:
								str_brain = "rusher";

								
								break;

								
				case 4:
								str_brain = "flanker";

								
								break;

								
				default:
								str_brain = "flanker";

								
								break;

				}

				return str_brain;


}






airport_plane_flyby()
{
				
				

				
				so_first_path = getent( "so_overhead_airplane_start_01", "targetname" );
				so_first_path_end = getent( so_first_path.target, "targetname" );
				so_second_path = getent( "so_overhead_airplane_start_02", "targetname" );
				so_second_path_end = getent( so_second_path.target, "targetname" );
				so_third_path = getent( "so_overhead_airplane_start_03", "targetname" );
				so_third_path_end = getent( so_third_path.target, "targetname" );
				ent_plane = undefined;

				
				ent_plane = spawn( "script_model", so_first_path.origin );

				
				wait( 0.05 );

				
				ent_plane setmodel( air_random_plane() );

				
				ent_plane.angles = so_first_path.angles;

				
				

				
				ent_plane hide();

				
				while( maps\_utility::flag( "airplane_fly_over_01" ) )
				{
								
								ent_plane show();

								
								ent_plane moveto( so_first_path_end.origin, 5.0 );

								
								

								
								
								
								ent_plane playsound( "AIR_airplane_fly_over" );

								
								wait( 3.0 );
								earthquake( 0.1, 3.0, level.player.origin, 850 );

								
								

								
								ent_plane waittill( "movedone" );

								
								ent_plane hide();

								
								ent_plane moveto( so_first_path.origin, 0.1 );

								
								ent_plane waittill( "movedone" );

								
								ent_plane setmodel( air_random_plane() );

								
								
								

								
								wait( randomfloatrange( 110.0, 240.0 ) );

				}

				
				wait( 5.0 );

				
				ent_plane moveto( so_second_path.origin, 0.1 );

				
				ent_plane waittill( "movedone" );

				
				ent_plane.angles = so_second_path.angles;

				
				while( maps\_utility::flag( "airplane_fly_over_02" ) )
				{
								
								ent_plane show();

								
								ent_plane moveto( so_second_path_end.origin, 5.0 );

								
								

								
								
								
								ent_plane playsound( "AIR_airplane_fly_over" );

								
								wait( 3.0 );
								earthquake( 0.1, 3.0, level.player.origin, 850 );

								
								

								
								ent_plane waittill( "movedone" );

								
								ent_plane hide();

								
								ent_plane moveto( so_second_path.origin, 0.1 );

								
								ent_plane waittill( "movedone" );

								
								ent_plane setmodel( air_random_plane() );

								
								
								

								
								wait( randomfloatrange( 110.0, 240.0 ) );

				}

				
				wait( 5.0 );

				
				ent_plane moveto( so_third_path.origin, 0.1 );

				
				ent_plane waittill( "movedone" );

				
				ent_plane.angles = so_third_path.angles;

				
				while( maps\_utility::flag( "airplane_fly_over_03" ) )
				{
								
								ent_plane show();

								
								ent_plane moveto( so_third_path_end.origin, 5.0 );

								
								

								
								
								
								ent_plane playsound( "AIR_airplane_fly_over" );

								
								wait( 3.0 );
								earthquake( 0.1, 3.0, level.player.origin, 850 );

								
								

								
								ent_plane waittill( "movedone" );

								
								ent_plane hide();

								
								ent_plane moveto( so_third_path.origin, 0.1 );

								
								ent_plane waittill( "movedone" );

								
								ent_plane setmodel( air_random_plane() );

								
								
								

								
								wait( randomfloatrange( 110.0, 240.0 ) );

				}
}





air_random_plane()
{
				
				mld_plane = undefined;

				
				int_plane = randomint( 5 );

				
				switch( int_plane )
				{
				case 0:
								
								mld_plane = "v_jumbo_jet_v1";

								
								break;

				case 1:
								
								mld_plane = "v_jumbo_jet_v1";

								
								break;

				case 2:
								
								mld_plane = "v_jumbo_jet_v1";

								
								break;

				case 3:
								
								mld_plane = "v_jet_737_stationary_v1";

								
								break;

				case 4:
								
								mld_plane = "v_jet_737_stationary_v1";

								
								break;

				case 5:
								
								mld_plane = "v_jet_737_stationary_v1";

								
								break;
				}

				
				return mld_plane;

}




only_ai_in_array( array )
{
				
				assertex( isdefined( array ), "Array not defined, ending remove_spawners" );

				
				
				newArray = [];

				
				for( i=0; i<array.size; i++ )
				{
								
								if ( !isai( array[i] ) )
								{
												
												continue;
								}

								
								newArray[newArray.size] = array[i];
				}

				
				return newArray;
}





airport_fans_init()
{
				
				

				
				
				
				
				air_streamers = getentarray( "fan_streamer", "script_noteworthy" );
				
				ent_link = undefined;



				
				for( i=0; i<air_streamers.size; i++ )
				{
								
								assertex( isdefined( air_streamers[i].target ), "streamer missing a target!" );

								
								ent_link = getent( air_streamers[i].target, "targetname" );

								
								air_streamers[i] linkto( ent_link );

								
								wait( 0.05 );

								
								ent_link = undefined;

								
								wait( 0.05 );
				}


				
				level maps\_utility::flag_wait( "objective_3" );

				
				level notify( "streamer_2_start" );
				level notify( "streamer_3_start" );

				
				
				
				
				

				
				
				



}






air_ctrl_rumble_timer( time )
{
				

				
				assertex( isdefined( time ), "time is not defined for a ctrl_rumble" );

				
				int_count = 0;

				
				while( int_count <= time )
				{
								
								level.player playrumbleonentity( "damage_light" );

								
								wait( 0.25 );

								
								level.player playrumbleonentity( "damage_light" );

								
								wait( 0.25 );

								
								level.player playrumbleonentity( "damage_light" );

								
								wait( 0.25 );

								
								level.player playrumbleonentity( "damage_light" );

								
								wait( 0.25 );

								
								int_count++;
				}
}







sprint_to_goal(ignore_player)
{
	
	self endon( "death" );

	if(!isdefined(ignore_player))
		ignore_player = false;

	if(!ignore_player)
	{
		
		self setengagerule( "tgtSight" );
		self addengagerule( "tgtPerceive" );
		self addengagerule( "Damaged" );
		self addengagerule( "Attacked" );
	}
	else
	{
		self setenablesense(false);
	}

	
	self setscriptspeed( "sprint" );

	
	self waittill( "goal" );

	
	self setscriptspeed( "default" );

	if(ignore_player)
	{
		self setenablesense(true);
	}
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





give_tether_at_goal( node, int_lowest_tether, int_highest_tether, int_min_tether )
{
				
				self endon( "death" );

				
				assertex( isdefined( node ), "str_node not defined" );
				assertex( isdefined( int_lowest_tether ), "int_lowest_tether not defined" );
				assertex( isdefined( int_highest_tether ), "int_highest_tether not defined" );
				assertex( isdefined( int_min_tether ), "int_min_tether not defined" );

				
				self waittill( "goal" );

				
				self.tetherpt = node.origin;
				
				
				self thread luggage_room_active_tether( int_lowest_tether, int_highest_tether, int_min_tether );

}











luggage_room_active_tether( tetherDelta0, tetherDelta1, minTether )
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




combat_role_on_goal( sCombatRole )
{
				
				self endon( "death" );

				
				assertex( isdefined( sCombatRole ), "combat role not passed in for " + self.targetname );
				assertex( isstring( sCombatRole ), "combat role pass not string" );

				
				self waittill( "goal" );

				
				self SetCombatRole( sCombatRole );
}








airport_vision_set_init()
{
				
				

				
				trig_vision_air_1 = getent( "vision_airport_01", "targetname" );
				trig_vision_air_2 = getent( "vision_airport_02", "targetname" );
				trig_vision_air_3 = getentarray( "vision_airport_03", "targetname" );
				trig_vision_air_4 = getentarray( "vision_airport_04", "targetname" );
				trig_vision_air_5 = getent( "vision_airport_05", "targetname" );

				
				level thread airport_change_vision_set( trig_vision_air_1, "airport_01", "objective_2" );
				level thread airport_change_vision_set( trig_vision_air_2, "airport_02", "objective_2" );

				
				for( i=0; i<trig_vision_air_3.size; i++ )
				{
								
								level thread airport_change_vision_set( trig_vision_air_3[i], "airport_03", "objective_4" );
								
								wait( 0.05 );
				}

				
				for( i=0; i<trig_vision_air_4.size; i++ )
				{
								
								level thread airport_change_vision_set( trig_vision_air_4[i], "airport_04", "objective_5" );
								
								wait( 0.05 );
				}

				
				


}



airport_change_vision_set( eTrig, sVisionSet, sEndFlag )
{
				
				assertex( isdefined( eTrig ), "vision trig not defined" );
				assertex( isdefined( sVisionSet ), "vision set not defined" );
				assertex( isdefined( sEndFlag ), "vision end on flag not defined" );

				
				level.player endon( "death" );

				
				while( !flag( sEndFlag ) )
				{
								
								eTrig waittill( "trigger" );

								
								Visionsetnaked( sVisionSet, 1 );

								
								wait( 1 );
				}

				
				wait( 5.0 );

				
				eTrig delete();

}


hideBond( duration )
{
	level.player hideViewModel();
	wait(duration);
	level.player showViewModel();
}

clean_up_old_ai()
{
	aiarray = getaiarray("axis");
	if(isdefined(aiarray))
	{
		for(i = 0; i < aiarray.size; i++)
		{
			if(isdefined(aiarray[i]))
				aiarray[i] delete();
		}
	}
}
clean_up_old_ai_except(targetname)
{
	aiarray = getaiarray("axis");
	if(isdefined(aiarray))
	{
		for(i = 0; i < aiarray.size; i++)
		{
			if(isdefined(aiarray[i]))
			{
				if(	isdefined(aiarray[i].targetname) && 
					aiarray[i].targetname != targetname)	
				{
					aiarray[i] delete();
				}
			}
		}
	}
}
































































































































