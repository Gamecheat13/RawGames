




main()
{

				
				
				level maps\_autosave::autosave_now( "airport" );

				
				

				
				level thread e3_stealth_flag_set();

				
				
				
				
				

				
				
				
				
				
				
				
				

				
				level thread e3_villiers_dialogue();

				
				level thread server_room_doors();

				
				
				
				level thread e3_comp_settings();

				
				
				level thread e3_change_monitor_model();

				
				
				

				
				
				
				
				
				

				
				level thread e3_server_reaction();

				
				
				level thread e3_server_door_basher();

				
				
				
				
				
				
				

				
				
				
				
				

				
				level thread e4_server_room_door();

				
				
				
				
				
				
				level thread e3_clean_up();

				
				
				
				level thread end_event_three();

				
				level waittill( "event_three_done" );

}






e3_patrol_setup()
{
	

	
	
	patrol_spawner = getent( "spwn_e3_lower_patrol", "targetname" );
	computer_spawner = getent( "spwn_e3_computer", "targetname" );
	
	
	
	
	
	
	
	if( !isdefined( patrol_spawner.target ) )
	{
		
		

		
		return;
	}
	
	if( !isdefined( computer_spawner.target ) )
	{
		
		
	}
	
	nod_patrol_convo = getnode( patrol_spawner.target, "targetname" );
	nod_computer_convo = getnode( computer_spawner.target, "targetname" );
	
	temp_ent = undefined;

	
	patrol_spawner.count = 1;
	computer_spawner.count = 1;

	
	wait( 0.05 );

	
	
	temp_ent = patrol_spawner stalingradspawn( "e3_enemy" );

	
	
	if( maps\_utility::spawn_failed( temp_ent ) )
	{
		
		

		
		return;
	}
	
	else
	{
		
		temp_ent thread e3_bottom_patrol( nod_patrol_convo );

		
		temp_ent = undefined;

		
		wait( 0.05 );
	}

	
	temp_ent = computer_spawner stalingradspawn( "e3_enemy" );

	
	
	if( maps\_utility::spawn_failed( temp_ent ) )
	{
		
		

		
		return;
	}
	else
	{
		
		temp_ent thread e3_computer_patrol( nod_computer_convo );
		

		
		
		
		


		
		temp_ent = undefined;

		
		wait( 0.05 );
	}
}
























































e3_computer_patrol( nod_start )
{

	
	level.player endon( "death" );
	self endon( "death" );
	self endon( "damage" );

	
	
	

	
	
	
	


	
	


	
	self setgoalnode( nod_start );


	
	self waittill( "goal" );


	
	self thread air_play_anim( "TalkA1", "stop_looping_anim" );


	
	level maps\_utility::flag_wait( "objective_2" );


	
	self notify( "stop_looping_anim" );

	
	

	
	self stopallcmds();

	
	self setenablesense( true );

	
	
	self thread maps\airport_util::event_enemy_watch( "e3_stealth_cancelled", "e3_stealth_broken" );

	
	
	


	
	

}







air_play_anim( str_animation, str_endon )
{
				
				level.player endon( "death" );
				self endon( "death" );
				self endon( "damage" );
				self endon( str_endon );

				
				assertex( isdefined( str_animation ), "animation not defined for air_play_anim" );

				
				while( 1 )
				{
								
								self CmdAction( str_animation );

								
								wait( 0.05 );

								
								self waittill( "cmd_done" );
				}
}















server_guard_animation()
{
	
	self endon( "death" );
	
	

	
	self thread maps\airport_util::event_enemy_watch( "e3_stealth_cancelled", "e3_stealth_broken" );

	
	self waittill( "goal" );
	self animscripts\shared::placeWeaponOn(self.weapon, "none");

	while( self getalertstate() == "alert_green" )
	{
		
		self cmdplayanim( "thu_laptop_lowersurface" );

		self waittill( "cmd_done" );
		
		wait( 0.05 );
	}
	self animscripts\shared::placeWeaponOn(self.weapon, "right");
}





e3_bottom_patrol( nod_start )
{
				
				level.player endon( "death" );
				self endon( "death" );
				self endon( "damage" );

				
				self setalertstatemin( "alert_yellow" );
				self setscriptspeed( "walk" );
				self setenablesense( false );

				
				self thread maps\airport_util::reset_script_speed();

				
				self setgoalnode( nod_start );

				
				self waittill( "goal" );

				
				self thread air_play_anim( "TalkA2", "stop_looping_anim" );

				
				level maps\_utility::flag_wait( "objective_2" );

				
				self notify( "stop_looping_anim" );

				
				self stopallcmds();

				
				self setenablesense( true );

				
				self thread maps\airport_util::event_enemy_watch( "e3_stealth_cancelled", "e3_stealth_broken" );

				
				
				self startpatrolroute( "nod_e3_patrol" );

				
				
				

				
				
				



}




e3_stealth_flag_set()
{
	level endon("e3_clean_up");

	
	
	
	spawner = getent( "spwn_e3_backup_a", "targetname" );
	spawner_2 = getent( "spwn_e3_backup_b", "targetname" );
	
	noda_e3_defense = getnodearray( "nod_e3_backup_a", "targetname" );
	noda_e3_defense_2 = getnodearray( "nod_e3_backup_b", "targetname" );

	
	ent_e3_backup_door_a = getent( "e3_backup_door_a", "targetname" );
	ent_e3_backup_door_b = getent( "e3_backup_door_b", "targetname" );
	
	
	ent_e3_backup_door_a maps\_doors::barred_door();
	ent_e3_backup_door_b maps\_doors::barred_door();
	
	
	

	
	level waittill( "e3_stealth_broken" );

	
	level notify( "e3_stealth_cancelled" );

	
	level maps\_utility::flag_set( "e3_stealth_broken" );

	
	ent_e3_backup_door_a maps\_doors::unbarred_door();
	ent_e3_backup_door_b maps\_doors::unbarred_door();
	
	
	level thread maps\airport_util::spawn_event_backup_init( spawner, noda_e3_defense );
	level thread maps\airport_util::spawn_event_backup_init( spawner_2, noda_e3_defense_2 );
}




e3_server_room_door( player )
{
				

				



}




e3_comp_settings()
{
				
				
				level.computer_array[2] maps\_useableobjects::set_on_begin_use_function( ::e3_started_av_dl );

				
				level.computer_array[2] maps\_useableobjects::set_on_end_use_function( ::e3_change_monitor_model );


}





e3_change_monitor_model()
{
	
				
				
				level maps\_utility::flag_wait( "objective_3" );
				
				computer = getent( "ent_air_comp_3", "targetname" );

				
				computer setmodel( "p_dec_tv_plasma" );

				
				Visionsetnaked( "airport_server_room" );

				
				SetExpFog( 500, 600, 0.27, 0.28, 0.32, 1.0, 0 );
				

				
				level thread airport_challenge_achievement();

				
				if( Getdvar( "demo" ) == "1" )
				{
					level maps\_endmission::nextmission();
				}

				
				
				
				e3_lockdoor = getent( "ent_e3_antiv_enter", "targetname" );
				e3_lockdoor maps\_doors::close_door();
				
				
				e3_enemy_array = getentarray("e3_enemy", "targetname");
				if(IsDefined(e3_enemy_array) && e3_enemy_array.size > 0)
				{
					for(i=0; i< e3_enemy_array.size; i++)
					{
						e3_enemy_array[i] delete();
					}	 
				}
				
				e3_patroller_array = getentarray("e3_patroller", "targetname");
				if(IsDefined(e3_patroller_array) && e3_patroller_array.size > 0)
				{
					for(i=0; i< e3_patroller_array.size; i++)
					{
						e3_patroller_array[i] delete();
					}	 
				}
				
				
				

}



e3_cameras_init()
{
				
				level endon( "event_three_done" );

				
				e3_camera_1 = getent( "ent_e3_camera_1", "targetname" );
				e3_camera_2 = getent( "ent_e3_camera_2", "targetname" );
				
				
				

				
				
				
				
				

				
				wait( 0.05 );

				
				
				
				e3_cam1_hack_box = getent( e3_camera_1.script_parameters, "targetname" );
				e3_cam2_hack_box = getent( e3_camera_2.script_parameters, "targetname" );

				
				e3_camera_1 thread maps\_securitycamera::camera_start( e3_cam1_hack_box, true, true, false );
				e3_camera_2 thread maps\_securitycamera::camera_start( e3_cam2_hack_box, true, true, false );

				
				
				
				
				
				
				enta_e1_cams = getentarray( "air_feedbox_one", "targetname" );
				

				
				
				
				

				
				for( i=0; i<enta_e1_cams.size; i++ )
				{
								
								enta_e1_cams[i] thread maps\_securitycamera::camera_start( undefined, false, undefined, undefined );
				}

				
				
				
				
				

				

				
				
				
				e3_camera_1 thread maps\airport_util::event_camera_watch( "e3_stealth_cancelled", "e3_stealth_broken" );
				e3_camera_2 thread maps\airport_util::event_camera_watch( "e3_stealth_cancelled", "e3_stealth_broken" );

				
				e3_camera_1 thread maps\airport_util::event_camera_destroyed( "e3_stealth_cancelled", "e3_stealth_broken" );
				e3_camera_2 thread maps\airport_util::event_camera_destroyed( "e3_stealth_cancelled", "e3_stealth_broken" );

				
				e3_camera_1 thread maps\airport_util::event_camera_disable( "e3_stealth_cancelled" );
				e3_camera_2 thread maps\airport_util::event_camera_disable( "e3_stealth_cancelled" );

				
				
				
				
				

				


}

temp_e3_exit_door()
{
				

				
				e3_exit_door = getent( "ent_e3_exit_door", "targetname" );
				trig = getent( "ent_close_e3_exit", "targetname" );

				e3_exit_door connectpaths();

				e3_exit_door notsolid();
				e3_exit_door rotateyaw( -120, 1.0 );
				e3_exit_door waittill( "rotatedone" );
				e3_exit_door solid();

				level maps\_utility::flag_wait( "objective_3" );

				trig waittill( "trigger" );

				

				e3_exit_door notsolid();
				e3_exit_door rotateyaw( 120, 0.5 );
				e3_exit_door waittill( "rotatedone" );
				e3_exit_door solid();


}













































































































































































e3_started_av_dl( player )
{

				
				level maps\_utility::flag_set( "e3_antivirus_started" );

}






e4_server_room_door()
{
	
	

	
	e4_server_enterance = getent( "ent_e3_antiv_enter", "targetname" );
	

	
	
	
	
	level maps\_utility::flag_wait( "e3_antivirus_started" );

	
	e4_server_enterance maps\_doors::close_door();

	
	
	e4_server_enterance maps\_doors::barred_door();
}





airport_challenge_achievement()
{
				
				

				
				if( !maps\_utility::flag( "e1_stealth_broken" ) && !maps\_utility::flag( "e2_stealth_broken" ) && !maps\_utility::flag( "e3_stealth_broken" ) )
				{
								
								GiveAchievement( "Challenge_Airport" );
								
								
				}
				else
				{
					
				}
}

























































































































































































































































e3_server_reaction()
{
				

				
				SetSavedDVar( "ai_ChatEnable", "0" );

				
				spawner_1 = getent( "spwn_e3_server_fight_a", "targetname" );
				spawner_2 = getent( "spwn_e3_server_fight_b", "targetname" );
				

				
				nod_server_yeller = getnode( "nod_e3_server_yeller", "targetname" );
				nod_server_waiter = getnode( "nod_e3_server_wait", "targetname" );
				noda_server_fight_b = getnodearray( "nod_server_fight_b", "targetname" );
				nod_server_tether = GetNode( "e3_server_main_tether", "targetname" );

				
				
				
				spawner_1.count = 5;
				spawner_2.count = 5;

				
				
				
				
				

				
				
				
				level maps\_utility::flag_wait( "objective_3" );

				level.player FreezeControls(true);
				
				
				
				thread maps\airport_util::clean_up_old_ai_except("server_enemy");

				
				


				
				
				
				ent_server_fight_a = spawner_1 stalingradspawn( "server_enemy" );
				if( !maps\_utility::spawn_failed( ent_server_fight_a ) )
				{
								
								ent_server_fight_a thread e3_pip_flow();
								

								
								

								
								
				}
				else
				{
								
								return;
				}

				
				wait( 0.5 );

				
				
				
				ent_server_fight_b2 = spawner_2 stalingradspawn( "server_enemy" );
				if( !maps\_utility::spawn_failed( ent_server_fight_b2 ) )
				{
								
								
								ent_server_fight_b2 setalertstatemin( "alert_red" );

								
								ent_server_fight_b2 setgoalnode( nod_server_waiter );

								
								ent_server_fight_b2 setenablesense( false );
				}
				else
				{
								
								return;	
				}

				
				level thread split_screen(); 

				
				
				
				level thread e3_server_flank_pop();

				
				
				

				
				level waittill( "flood_server_room" );

				
				
				
				
				ent_server_fight_a setenablesense( true );
				
				
				
				ent_server_fight_a setperfectsense(true);
				
				ent_server_fight_a setgoalnode( noda_server_fight_b[0], 1 );
				ent_server_fight_a thread maps\airport_util::give_tether_at_goal( nod_server_tether, 300, 1100, 256 );
				ent_server_fight_a SetCombatRole( "guardian" );
				
				
				ent_server_fight_b2 setenablesense( true );
				
				
				
				ent_server_fight_b2 setperfectsense(true);
				
				ent_server_fight_b2 setgoalnode( noda_server_fight_b[1] );
				ent_server_fight_b2 thread maps\airport_util::give_tether_at_goal( nod_server_tether, 300, 1100, 256 );
				ent_server_fight_b2 SetCombatRole( "guardian" );

				
				
				
				
				
				

				
				
				
				
				
				
				
				level maps\_autosave::autosave_now( "airport" );

				
				
				wait( 1.9 );	

				
				
				level notify( "open_server_room_doors" );
				
				
				SetSavedDVar( "ai_ChatEnable", "1" );

				wait(1.0);
				level.player FreezeControls(false);
}



e3_pip_flow()
{
				self setalertstatemin( "alert_red" );
				wait( 0.7 ); 
				nod_server_yeller = getnode( "nod_e3_server_yeller", "targetname" );
				
				self setgoalnode( nod_server_yeller );
				
				self waittill("goal");

				wait(0.5);
				self cmdaction( "CheckEarpiece" );

				self waittill( "cmd_done" );
				
				
				self cmdaction( "LookAround", true, 2.3 );		
				
				self cmdaction( "callout" );

				self waittill( "cmd_done" );

				
				self setenablesense( false );
}





e3_server_door_basher()
{
				

					
				
				door_bash_spawner = getent( "spwn_door_basher", "targetname" );
				
				node_door_bash_start = GetNode( "nod_e3_server_basher", "targetname" );
				nod_server_fight_a = getnode( "nod_server_fight_a", "targetname" );
				nod_server_tether = GetNode( "e3_server_main_tether", "targetname" );
				
				trig_setup = getent( "auto1510", "targetname" );

				
				door_bash_spawner.count = 1;

				
				trig_setup waittill( "trigger" );

				 
				 
				 
				ent_server_basher = door_bash_spawner stalingradspawn( "server_enemy" );
				if( !maps\_utility::spawn_failed( ent_server_basher ) )
				{
								
								ent_server_basher setalertstatemin( "alert_red" );

								
								ent_server_basher setgoalnode( node_door_bash_start );

								
								ent_server_basher setenablesense( false );
				}
				else
				{
								
								return;	
				}

				
				
				level waittill( "bash_server_door" );
				
				
				ent_server_basher thread e3_server_door_break();

				
				ent_server_basher cmdplayanim( "Thug_DoorShoulderCharge" );

				
				ent_server_basher waittill( "cmd_done" );

				
				level notify( "flood_server_room" );

				
				ent_server_basher setenablesense( true );
				
				ent_server_basher playsound ("SAM_E_1_FrRs_Cmb" );

				
				
				
				ent_server_basher setperfectsense(true);
				
				

				
				ent_server_basher setgoalnode( nod_server_fight_a );

				
				ent_server_basher thread maps\airport_util::give_tether_at_goal( nod_server_tether, 300, 1100, 256 );

				
				ent_server_basher SetCombatRole( "flanker" );

}




e3_server_door_break()
{
				
				self endon( "death" );

				
				self waittillmatch( "anim_notetrack", "door_charge_kick" );

				
				

				
				level notify( "door_kick_start" );

				self playsound ("door_charge");
				
				
				
				self waittillmatch( "anim_notetrack", "door_charge_shoulder" );
				self playsound ("door_charge_shoulder");

				self playsound ("SAM_E_1_McGs_Cmb" );
				wait( 1 );
				self playsound ("SAM_E_2_Flan_Cmb" );
				wait( 1.3 );
				self playsound ("SAM_E_3_McGs_Cmb" );
				wait( 1.3 );
				self playsound ("SAM_E_4_McGs_Cmb" );
}






e3_server_flank_pop()
{
				
				

				
				e3_flank_spawner = getent( "spwn_e3_server_fight_c", "targetname" );
				nodae3_flank_destin = getnodearray( e3_flank_spawner.script_parameters, "targetname" );
				nod_flank_tether = getnode( "e3_server_flank_tether", "targetname" );
				
				
				ent_temp = undefined;
				
				str_brain = undefined;
				
				

				
				e3_flank_spawner.count = nodae3_flank_destin.size;

				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				
				

				
				level waittill( "window_uncrop" );

				
				wait( 1.0 );

				
				
				
				level notify( "chair_throw_start" );

				
				

				
				

				
				

				
				

				
				for( i=0; i<nodae3_flank_destin.size; i++ )
				{
								
								ent_temp = e3_flank_spawner stalingradspawn( "server_enemy" );
								if( !maps\_utility::spawn_failed( ent_temp ) )
								{
												
												ent_temp setalertstatemin( "alert_red" );

												
												

												

												str_brain = level maps\airport_util::airport_give_me_brain( i );
												
												
												ent_temp SetCombatRole( str_brain );

												
												ent_temp setgoalnode( nodae3_flank_destin[i] );

												
												
												if( str_brain == "flanker" )
												{
																
																
																
																ent_temp thread maps\airport_util::give_tether_at_goal( nod_flank_tether, 300, 1100, 256 );

																
																ent_temp.tetherpt = nod_flank_tether.origin;

												}
												else if( str_brain == "rusher" )
												{
																str_brain = "flanker";
																
												}
												
												ent_temp SetCombatRole( str_brain );

												
												
												
												ent_temp setperfectsense(true);

												
												
												wait( 0.7 );
								}

				}


}









e3_villiers_dialogue()
{
				

				
				antivirus_trig = getent( "trig_e3_antivirus", "targetname" );
				server_room_radio = getent( "e3_server_fight_radio", "targetname" );

				
				antivirus_trig waittill( "trigger" );

				
				
				
				level.player maps\_utility::play_dialogue( "TANN_AirpG_014A", true );

				
				level maps\_utility::flag_wait( "objective_3" );

				
				
				level.player maps\_utility::play_dialogue( "TANN_AirpG_015B", true );


				
				

				

				

				
				
				server_room_radio maps\_utility::play_dialogue( "CCRM_AirpG_016A", true );
				
				
				
				level notify( "bash_server_door" );

				
				server_room_radio maps\_utility::play_dialogue( "CCM5_AirpG_017A", true );

				
				server_room_radio maps\_utility::play_dialogue( "CCM6_AirpG_018A", true );

				
				

				
				server_room_radio maps\_utility::play_dialogue( "CCM7_AirpG_019A", true );



}




server_room_doors()
{
				
				left_door_node = getnode( "server_room_left_nodes", "targetname" );
				left_door = getent( "server_room_left", "targetname" );
				right_door = getent( "server_room_right", "targetname" );
				right_door_node = getnode( "server_room_right_nodes", "targetname" );
				trig = getent( "ent_close_e3_exit", "targetname" );

				
				level maps\_utility::flag_wait( "objective_3" );

				
				
				
				level waittill( "open_server_room_doors" );

				
				left_door._doors_barred = false;
				right_door._doors_barred = false;

				
				left_door_node maps\_doors::open_door();
				right_door_node maps\_doors::open_door();

				
				trig waittill( "trigger" );

				
				left_door._doors_auto_close = true;
				right_door._doors_auto_close = true;

				
				left_door maps\_doors::close_door();
				right_door maps\_doors::close_door();

				
				wait( 1.5 );

				
				left_door._doors_barred = true;
				right_door._doors_barred = true;

				

				
				level notify("checkpoint_reached"); 
}








e3_clean_up()
{
	
	

	
	
	
	level waittill( "event_three_done" );

	level notify("e3_clean_up");

	
	
	enta_e3_spawners = getentarray( "e3_spawners", "script_noteworthy" );

	
	for( i=0; i<enta_e3_spawners.size; i++ )
	{
		
		wait( 0.05 );
		if( isdefined( enta_e3_spawners[i] ) )
		{
			
			wait( 0.05 );
			if( !isai( enta_e3_spawners[i] ) )
			{
				
				enta_e3_spawners[i] delete();

				
				wait( 0.1 );
			}
		}

	}

	
	
	
}






end_event_three()
{
				
				end_trig = getent( "trig_start_e4", "targetname" );

				
				level maps\_utility::flag_wait( "objective_3" );

				
				end_trig waittill( "trigger" );

				
				
	

				
				
				SetExpFog( 460, 3000, 0.5, 0.5, 0.5, 1.0, 1 );
				
				

				
				level notify( "event_three_done" );

}





split_screen()
{
	
	
	setdvar("ui_hud_showstanceicon", "0"); 
	setsaveddvar("ammocounterhide", "1");  
	setdvar("ui_hud_showcompass", 0);

	


	
	level thread main_camera();

	
	level thread second_anim();

	

	
	level thread main_crop();
	

	
	level thread second_move();

	level waittill( "window_uncrop" );

	


	
	setdvar("ui_hud_showstanceicon", "1"); 
	setsaveddvar("ammocounterhide", "0");  
	setdvar("ui_hud_showcompass", 1);
}

main_camera()
{
	
	level.player customcamera_checkcollisions( 0 );

	
	server_cam = level.player customCamera_Push( "world", ( -2042, 2570, 98 ), ( 7.4, -174, 0 ), 3.0);
	
	level thread maps\airport_util::hideBond( 0.5 );
	wait(0.1);
	
	level waittill( "off_screen" );

	
	level.player customCamera_pop( server_cam, 0 );
	
	
	level.player customcamera_checkcollisions( 1 );

}


main_crop()
{

	
	setdvar("cg_pipmain_border", 2);
	setdvar("cg_pipmain_border_color", "0 0 0.2 1");
	
	
	SetDVar("r_pipMainMode", 1);	
	SetDVar("r_pip1Anchor", 3);		

	
	
	level.player animatepip( 500, 1, -1, -1, .75, .75, 0.75, .75);
	wait(0.6);	
		
	level notify( "window_crop" );
		
	level waittill( "off_screen" );
	

	
	
	level.player animatepip( 500, 1, -1, -1, 1, 1, 1, 1);
	wait(0.5);
	level notify( "window_uncrop" );
	
	
	SetDVar("r_pip1Scale", "1 1 1 1");		
	SetDVar("r_pipMainMode", 0);	
	setSavedDvar("cg_drawHUD","1");

	
	level notify("checkpoint_reached"); 
}


main_move()
{
	
	level waittill( "window_crop" );
		
	
	level.player animatepip( 500, 1, -1, 0.16 );
	wait(0.5);
	
	level notify( "window_down" );
	
	level waittill( "off_ledge" );
	
	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify( "window_up" );
}



second_move()
{
	
	
	level.player setsecuritycameraparams( 65, 3/4 );

	
	thread maps\airport_util::hideBond( 0.5 );

	wait(0.05);	
	cameraID_hack = level.player securityCustomCamera_Push( "entity", level.player, level.player, ( -50, -40, 77), ( -32, -7, 0), 0.1);
	
	
	
	
	SetDVar("r_pipSecondaryAnchor", 4);						
	
	

	
	setdvar("cg_pipsecondary_border", 1);
	setdvar("cg_pipsecondary_border_color", "0 0 0.2 1");
		
	
	
	
	level.player animatepip( 10, 0, 0.6, -0.5, .352188, .5, .35, .5);
	level.player waittill("animatepip_done");
	
	level waittill( "window_crop" );
	SetDVar("r_pipSecondaryMode", 5);		
	
	
	level.player animatepip( 500, 0, 0.6, .15);
	wait(0.5);
	
	

	
	
	level waittill( "open_server_room_doors" );

	
	level.player animatepip( 500, 0, .6, 1 );
	wait(0.6);
		
	level notify( "off_screen" );
	
	
	SetDVar("r_pipSecondaryMode", 0);
	
	level.player PlayerAnimScriptEvent("");

						
}


second_anim()
{
	level endon("off_screen");

	while (true)
	{
		level.player PlayerAnimScriptEvent("phonehacklock");
		wait .05;
	}
}

