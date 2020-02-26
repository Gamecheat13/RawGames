




main()
{

				
				
				
				level.r_pos_1 = false;
				level.r_pos_2 = false;
				level.l_pos_1 = false;
				level.bond_ready = false;

				
				
				
				level thread e1_comp_settings();
			
				
				level thread e1_change_monitor_model();
			
			
				
				if( Getdvar( "demo" ) != "1" )
				{
					
					
					
					level thread e1_camera_intro();
				}
				else
				{
					level.player setplayerangles((4.79, 148.23, 0) );
			
					level.introblack fadeOverTime( 1.3 );
					level.introblack.alpha = 0;
				}	
			
				
				
				level thread e1_change_intro_laptop();
			
				
				level thread e1_patrol_setup();
			
				
				level thread e1_villiers_dialogue();
			
				
				level thread e1_player_hold();
			
				
				level thread e1_stealth_flag_set();
			
				level.effects = true;
			
				
				
				level thread e1_cameras_init();
			
				
				
				
				level thread e1_lock_player_in_vr();
			
				
				level thread e1_hack_suspense();
			
				
				level thread e1_virus_rm_lights();
			
				
				level thread e1_light_blinking();
			
				
				level notify("playmusicpackage_stealth");
			
				
				level thread event_one_clean_up();
			
				level thread end_event_one();
			
				level waittill( "event_one_done" );
}







e1_comp_settings()
{
				
				
				level.computer_array[0] maps\_useableobjects::set_on_begin_use_function( ::e1_started_v_dl );

				
				
}




e1_started_v_dl( player )
{
				
				level maps\_utility::flag_set( "e1_virus_started" );

}





e1_change_monitor_model()
{
				
				

				
				

				
				
				
				
				

				

				
				
				

				
				level maps\_utility::flag_wait( "objective_1" );

				
				computer = getent( "ent_air_comp_1", "targetname" );

				
				computer setmodel( "p_dec_monitor_modern" );

				
				
				level thread e1_exit_door_control();

}




e1_light_blinking()
{
				
				

				
				light_blinker = getent( "light_e1_blink", "targetname" );

				
				while( !maps\_utility::flag( "objective_1" ) )
				{
								
								light_blinker setlightintensity( 0.0 );

								
								wait( randomfloatrange( 0.3, 0.7 ) );

								
								light_blinker setlightintensity( 1.0 );

								
								wait( randomfloatrange( 0.1, 1.5 ) );
				}

				
				light_blinker setlightintensity( 0.0 );

				
				wait( randomfloatrange( 0.2, 0.5 ) );

				
				light_blinker setlightintensity( 0.5 );

				
				wait( 0.2 );

				
				light_blinker setlightintensity( 0.0 );

				
				wait( randomfloatrange( 0.2, 0.5 ) );

				
				light_blinker setlightintensity( 1.0 );
}











e1_lock_player_in_vr()
{
				
				

				
				
				e1_vr_enter_door = getent( "ent_e1_virus_enter", "targetname" );

				
				level maps\_utility::flag_wait( "objective_1" );

				
				e1_vr_enter_door maps\_doors::barred_door();

}


e1_exit_door_control()
{
				

				
				e1_exit_door = getent( "ent_door_e1_exit", "targetname" );
				trig = getent( "ent_close_e1_exit", "targetname" );
				e1_noda_exit_door = getnode( "auto963", "targetname" );

				
				

				
				e1_noda_exit_door maps\_doors::open_door();

				
				

				
				
				
				

				
				
				
				
				

				
				

				
				

				
				
}

e1_hack_suspense()
{
				

				
				spawner = getent( "ent_hack_enemy", "targetname" );
				
				
				
				
				spawner_2 = getent( "nod_e2_bottom_patrol", "targetname" );
				check_node = getnode( "nod_check_pause", "targetname" );
				end_node = getnode( "node_suspense_spot", "targetname" );

				
				spawner.count = 5;
				spawner_2.count = 5;

				
				

				
				level maps\_utility::flag_wait( "objective_1" );
				
				level thread maps\airport_util::hideBond( 0.5 );
				
				level thread server1_pip_camera();

				
				
				
				

				
				dood_1 = spawner stalingradspawn( "ent_e1_suspense" );
				if( !maps\_utility::spawn_failed( dood_1 ) )
				{		
								
								
								
								

								
								dood_1 setalertstatemin( "alert_yellow"  );

								
								
								
								dood_1 setscriptspeed( "walk" );

								
								dood_1 setpropagationdelay( 1.0 );

								
								dood_1 setengagerule( "tgtSight" );
								dood_1 addengagerule( "tgtPerceive" );
								dood_1 addengagerule( "Damaged" );
								dood_1 addengagerule( "Attacked" );



								
								dood_1 thread e1_change_role();

								
								dood_1 thread e1_server_check_guy();
				}
				else
				{
								
								return;
				}

				
				
				
				

				dood_2 = spawner_2 stalingradspawn( "ent_e1_suspense" );
				if( !maps\_utility::spawn_failed( dood_2 ) )
				{	
								
								
								
								wait( 0.1 );

								
								
								
								
								

								
								dood_2 setalertstatemin( "alert_yellow"  );

								
								
								
								dood_2 setscriptspeed( "walk" );

								
								dood_2 setengagerule( "tgtSight" );
								dood_2 addengagerule( "tgtPerceive" );
								dood_2 addengagerule( "Damaged" );
								dood_2 addengagerule( "Attacked" );

								
								dood_2 setpropagationdelay( 3.0 );

								
								dood_2 thread e1_server_disappear_guy();

				}
				else
				{
								
								return;
				}

				
				level thread e1_suspense_conversation( dood_1, dood_2 );

			

}




e1_server_check_guy()
{
	
	
	self endon( "death" );
	self endon( "damage" );
	level endon( "e1_suspense_broken" );

	
	talk_node = getnode( "nod_enter_e1_start", "targetname" );
	
	end_node = getnode( "node_suspense_spot", "targetname" );
	
	
	nod_wait_for_virus_dl_finish = getnode( "nod_e1_wait_for_v_dl", "targetname" );
	

	
	

	
	self thread suspense_broken();

	
	self setgoalnode( talk_node );

	

	
	

	
	self waittill( "goal" );
	
	
	level notify( "sending_suspense_dood" );

	
	
	

	
	

	
	
	
	

	
	level notify( "e1_suspense_kept" );


	
	

	
	

	
	

	
	

	
	

	

	wait(4);

	self setgoalnode( end_node );

	
	
	
	
	

	
	self waittill( "goal" );


	
	
	self maps\_utility::play_dialogue( "CCGM_AirpG_009A" );

	
	while( 1 )
	{
		
		self cmdplayanim( "thu_laptop_lowersurface" );

		
		self waittill( "cmd_done" );
	}

	

	
	

	
	


}




e1_change_role()
{
				
				self endon( "death" );
				level endon( "e1_suspense_kept" ); 

				
				level waittill( "e1_suspense_broken");

				
				self SetPerfectSense( true );

				
				self setcombatrole( "rusher" );

}





suspense_broken()
{
				
				self endon( "death" );
				self endon( "damage" );
				level endon( "e1_suspense_kept" );

				
				if( self getalertstate() != "alert_red" )
				{
								self waittill( "alert_red" );
				}

				
				level notify( "sending_suspense_dood" );
				level maps\_utility::flag_set( "e1_suspense_broken" );

				
				level notify( "e1_suspense_broken" );

}








e1_server_disappear_guy()
{
				
				
				self endon( "death" );

				
				talk_node = getnode( "nod_disappear_start", "targetname" );
				nod_wait_for_disappear = getnode( "nod_wait_to_disappear", "targetname" );
				nod_disappear = getnode( "nod_disappear", "targetname" );
				trig_go_disappear = getent( "trig_disappear", "targetname" );

				
				

				
				self thread maps\airport_util::reset_script_speed();

				
				self setgoalnode( nod_wait_for_disappear );

				
				self waittill( "goal" );
				self cmdaction ( "CheckEarpiece" );
				
				

				wait (6.3);
				
				level notify( "start_sus_convo" );
				
				
				
				level waittill( "e1_sus_convo_3" );

				
				self setgoalnode( nod_wait_for_disappear );

				
				trig_go_disappear waittill( "trigger" );

				
				level thread airport_post_obj1_tanner_update();

				
				
				
				
				
				
				
				
				if(IsDefined(self))
				{
					self thread maps\airport_two::e2_bottom_hallway_patrol();
				}
				else
				{
					level thread maps\airport_two::e2_bottom_hallway_patrol();
				}	
}






e1_suspense_conversation( dood_1, dood_2 )
{

				
				level waittill( "start_sus_convo" );

				
				assertex( isalive( dood_1 ), "Dood_1 is not alive!" );
				assertex( isalive( dood_2 ), "Dood_2 is not alive!" );

				
				
				
				Dood_1 cmdaction( "CheckEarpiece" );
				
				dood_1 maps\_utility::play_dialogue( "CCGM_AirpG_008A" );

				
				level notify( "e1_sus_convo_3" );

				


				
				

				
				
}




e1_virus_rm_lights()
{
				
				

				
				
				light = getent( "light_e1_hack", "targetname" );
				
				sbrush_on = getent( "e1_hack_light_on", "targetname" );
				sbrush_off = getent( "e1_hack_light_off", "targetname" );
				
				times = 0;

				
				
				sbrush_off hide();

				
				light setlightintensity( 1.5 );

				
				level maps\_utility::flag_wait( "objective_1" );

				
				
				while( times != 6 )
				{

								
								light setlightintensity( randomfloatrange( 0.2, 1.4 ) );

								
								wait( randomfloatrange( 0.2, 0.5 ) );

								
								times++;
				}

				
				light setlightintensity( 0.0 );

				
				
				sbrush_off show();

				
				
				
				
				

}




airport_post_obj1_tanner_update()
{
				
				

				
				level.player maps\_utility::play_dialogue( "TANN_AirpG_508A" );

				
				

				
				level.player maps\_utility::play_dialogue( "TANN_AirpG_510A" );

				
				level.player maps\_utility::play_dialogue( "TANN_AirpG_511A" );
}










e1_player_hold()
{
				
				
				
				
				

				
				SetDVar( "r_lodBias", -750 );

				
				
				
				

				
				

				
				
				


				
				
				

				
				

				
				

				
				

				
				

				
				level.player playerSetForceCover( false );

				
				
				
				

				
				


				
				if( Getdvar( "demo" ) != "1" )
				{
					
					level waittill( "air_intro_done" );
				}
				
				
				level.player freezecontrols( false );
				
				
				maps\_utility::letterbox_off();

				
				

				
				SetDVar( "r_lodBias", 0 );

				
				
				
				
				

				
				
				

				
				

				
				

				
				
				
				

				
				
				
				
				

				
				
				
				
				

				
				

}







e1_camera_intro()
{

	
	wait( 0.05 );

	
	
	setSavedDvar( "cg_disableBackButton", "1" ); 

	
	maps\_utility::letterbox_on( false, false );

	
	level thread air1_merc1_line1();
	level thread air1_merc2_line1();
	level thread air1_merc1_line2();

	
	
	
	level.introblack fadeOverTime( 1.3 );
	
	level.introblack.alpha = 0;

	
	playcutscene( "Airport_Intro", "air_intro_done" );
	
	level thread display_chyron();

	
	level waittill( "air_intro_done" );

	maps\_utility::letterbox_off();

	
	setSavedDvar( "cg_disableBackButton", "0" ); 

	
	
	
	
	level maps\_autosave::autosave_now( "airport" );
	level notify("checkpoint_reached"); 
	level notify("give_1st_obj");
}




air1_merc1_line1()
{
            
            
            
            
            laptop_guy = getent( "Merc1", "targetname" );
            
            
            intro_laptop = getent( "intro_laptop", "targetname" );

            
          	

            laptop_guy waittillmatch( "anim_notetrack", "ccm1_airpg_01a" );
                                 
            
           

           intro_laptop maps\_utility::play_dialogue( "CCM1_AirpG_001A", true ); 
}




air1_merc2_line1()
{
          

          

          hallway_guy = getent( "Merc2", "targetname" );

          

          intro_laptop = getent( "intro_laptop", "targetname" );

          

          

          hallway_guy waittillmatch( "anim_notetrack", "ccm1_airpg_02a" );

          

          

          intro_laptop maps\_utility::play_dialogue( "CCM1_AirpG_002A", true ); 

}




air1_merc1_line2()
{

         

         
         laptop_guy = getent( "Merc1", "targetname" );

         
         intro_laptop = getent( "intro_laptop", "targetname" );

 
         

         
         laptop_guy waittillmatch( "anim_notetrack", "ccm2_airpg_03a" );

 
         
 
         

         intro_laptop maps\_utility::play_dialogue( "CCM2_AirpG_003A", true ); 
}







e1_change_intro_laptop()
{
				
				

				
				intro_laptop = getent( "intro_laptop", "targetname" );

				
				assertex( isdefined( intro_laptop ), "intro_laptop not defined" );

				
				if( Getdvar( "demo" ) != "1" )
				{
					
					level waittill( "air_intro_done" );
				}

				
				intro_laptop setmodel( "p_dec_laptop_blck" );
				
				
				setdvar ("r_bx_airport_laptop_enable", 0); 

}









e1_patrol_setup()
{
				

				
				ent_left = getent( "Merc1", "targetname" );
				ent_right = getent( "Merc2", "targetname" );

				
				
				assertex( isdefined( ent_left ), "ent_left not defined" ); 
				assertex( isdefined( ent_right ), "ent_right not defined" ); 

				ent_left setengagerule( "tgtSight" );
				ent_left addengagerule( "tgtPerceive" );
				ent_left addengagerule( "Damaged" );
				ent_left addengagerule( "Attacked" );

				
				ent_left thread hallway_e1_left_patrol( ent_left.script_parameters );

				ent_right setengagerule( "tgtSight" );
				ent_right addengagerule( "tgtPerceive" );
				ent_right addengagerule( "Damaged" );
				ent_right addengagerule( "Attacked" );

				
				ent_right thread hallway_e1_right_patrol( ent_right.script_parameters );

				
				level thread e1_start_conversation( ent_right, ent_left );

}






hallway_e1_left_patrol( str_patrol_route )
{
				
				self endon( "damage" );
				self endon( "death" );

				
				

				
				

				
				left_talk = getnode( "nod_left_walk_convo", "targetname" );
				left_start_patrol_node = getnode( "nod_left_patrol_start", "targetname" );
				nod_left_watcher = getnode( "nod_left_patrol_watch", "targetname" );

				
				str_alert_state = false;

				
				self thread maps\airport_util::event_enemy_watch( "e1_stealth_cancelled", "e1_stealth_broken" );

				
				self thread maps\airport_util::reset_script_speed();

				
				
				self thread e1_patrol_alert();

				
				

				
				
				
				

				
				

				
				

				
				

				

				
				

				
				

				


				
				if( Getdvar( "demo" ) != "1" )
				{
					
					level waittill( "air_intro_done" );
				}	

				
				

				
				
				
				self setscriptspeed( "sprint" );

				
				self setgoalnode( nod_left_watcher );

				

				
				self waittill( "goal" );
				
				self waittill("facing_node");

				
				wait( 1.5 );
				
				
				
				self setscriptspeed( "walk" );

				
				self thread e1_cube_action_loop();

}





e1_cube_action_loop()
{
				
				self endon( "damage" );
				self endon( "death" );
				level endon( "e1_stealth_broken" );

				
				
				
				while( 1 )
				{
								
								self cmdaction( "fidget" );

								self waittill( "cmd_done" );

								
								
								wait( randomfloatrange( 0.8, 2.0 ) );

								
								self cmdaction( "fidget" );

								self waittill( "cmd_done" );

								
								
								wait( randomfloatrange( 1.0, 2.0 ) );

				}

}




hallway_e1_right_patrol( str_patrol_route )
{
				
				self endon( "damage" );
				self endon( "death" );

				
				assertex( isdefined( str_patrol_route ), "Right patrol route not defined, function will fail!" );

				
				self thread maps\airport_util::event_enemy_watch( "e1_stealth_cancelled", "e1_stealth_broken" );

				
				
				self thread e1_patrol_alert();

				
				self thread maps\airport_util::reset_script_speed();

				
				

				
				nod_first_comment = getnode( "nod_e1_cam_line", "targetname" );
				nod_start_scene = getnode( "e1_right_level_start", "targetname" );
				nod_conversation = getnode( "nod_e1_dood1_convo_start", "targetname" );
				nod_right_talk_and_walk = getnode( "nod_right_walk_convo", "targetname" );
				
				nod_wait_stairs = getnode( "nod_left_patrol_watch", "targetname" );

				
				ent_temp_scr = undefined;

				
				

				
				if( Getdvar( "demo" ) != "1" )
				{
					
					level waittill( "air_intro_done" );
				}

				
				self setalertstatemin( "alert_yellow" );

				
				self setscriptspeed( "walk" );

				
				level notify( "start_e1_patrols" );

				
				self startpatrolroute( str_patrol_route );
				

}








e1_villiers_dialogue()
{

	
	e1_introduction_trig = getent( "trig_start_e1_vin", "targetname" );
	
	level waittill("air_intro_done");

	
	
	
	
	
	level.player maps\_utility::play_dialogue( "TANN_AirpG_004A", true );



	
	
	level.player maps\_utility::play_dialogue( "TANN_AirpG_005A", true );

	
	


	
	maps\_utility::flag_wait( "objective_1" );

	
	
	
	
	
	
	
	
	
	
	level.player maps\_utility::play_dialogue( "BOND_AirpG_006A" );

	
	level.player maps\_utility::play_dialogue_nowait( "TANN_AirpG_007A", true );

	
	e1_introduction_trig delete();
}




e1_start_conversation( dood_1, dood_2 )
{
				
				if( !isdefined( dood_1 ) )
				{
								
								return;
				}
				else if( !isdefined( dood_2 ) )
				{
								
								return;	
				}

				
				dood_1 endon( "damage" );
				dood_1 endon( "death" );
				dood_2 endon( "damage" );
				dood_2 endon( "death" );
				level endon( "e1_stealth_cancelled" );

				

				
				

				
				level waittill( "start_e1_conversation" );

				

				
				
				

				
				

				
				wait( 2.0 );
				
				wait( 2.0 );
				


				

				
				
				

				
				

				
				wait( 2.0 );

				

				
				
				

				
				

				
				wait( 2.0 );
				
				wait( 2.0 );

				

				
				level notify( "e1_convo_p4" );


}





e1_cameras_init()
{
				
				level endon( "event_one_done" );

				
				
				e1_camera_1 = getent( "ent_e1_camera_1", "targetname" );
				e1_camera_2 = getent( "ent_e1_camera_2", "targetname" );
				
				trig_cam1_disable = getent( "trig_e1_cam1_hack", "targetname" );
				trig_cam2_disable = getent( "trig_e1_cam2_hack", "targetname" );
				
				wait( 0.05 );
				
				ent_e1_hack_cam1 = getent( e1_camera_1.script_parameters, "targetname" );
				ent_e1_hack_cam2 = getent( e1_camera_2.script_parameters, "targetname" );
				
				
				
				enta_e1_cams = getentarray( "air_feedbox_one", "targetname" );
				
				
				
				

				
				
				e1_camera_1.destroyed = false;
				e1_camera_1.disabled = false;

				

				
				
				
				
				
				e1_camera_1 thread maps\_securitycamera::camera_phone_track( true, true );

				

				
				
				
				
				
				
				
				if( Getdvar( "demo" ) != "1" )
				{
					level waittill( "air_intro_done" );
				}
					
				level.player enablevideocamera(false);

				

				
				
				

				
				
				
				
				


				
				
				
				e1_camera_1 thread maps\_securitycamera::camera_start( ent_e1_hack_cam1, true, true, false );
				e1_camera_2 thread maps\_securitycamera::camera_start( ent_e1_hack_cam2, true, true, false );

				
				wait( 0.05 );

				
				for( i=0; i<enta_e1_cams.size; i++ )
				{
								
								enta_e1_cams[i] thread maps\_securitycamera::camera_start( undefined, false, undefined, undefined );
				}

				
				
				
				
				
				
				
				

				
				
				

				
				
				e1_camera_1 thread e1_camera_destroyed();
				e1_camera_2 thread e1_camera_destroyed();

				
				e1_camera_1 thread e1_camera_disable();
				e1_camera_2 thread e1_camera_disable();

				
				e1_camera_1 thread e1_camera_watch();
				e1_camera_2 thread e1_camera_watch();

}



event_one_clean_up()
{
				
				level maps\_utility::flag_wait( "objective_1" );

				
				ent_array_spawners = getentarray( "e1_spawners", "script_noteworthy" );
				wait( 0.1 );

				
				for( i=0; i<ent_array_spawners.size; i++ )
				{
								
								ent_array_spawners[i] delete();
								wait( 0.1 );
				}
}





e1_stealth_flag_set()
{

				
				
				
				spawner = getent( "spwn_e1_backup", "targetname" );
				
				noda_e1_defense = getnodearray( "nod_e1_backup", "targetname" );
				
				nod_e1_backup_1 = getnode( "nod_e1_backup1_start", "targetname" );
				nod_e1_backup_2 = getnode( "nod_e1_backup2_start", "targetname" );
				
				ent_e1_backup_door = getentarray( "e1_door_backup", "targetname" );
				
				for(i = 0; i < ent_e1_backup_door.size; i++)
				{
					ent_e1_backup_door[i] maps\_doors::barred_door();
				}

				

				
				level waittill( "e1_stealth_broken" );

				
				level notify( "e1_stealth_cancelled" );

				
				level maps\_utility::flag_set( "e1_stealth_broken" );

				
				for(i = 0; i < ent_e1_backup_door.size; i++)
				{
					ent_e1_backup_door[i] maps\_doors::unbarred_door();
				}
				
				
				level thread maps\airport_util::spawn_event_backup_init( spawner, noda_e1_defense );

}






e1_patrol_alert()
{
				
				self endon( "death" );

				
				level waittill( "e1_stealth_broken" );

				
				
				self setalertstatemin( "alert_red" );

				
				self setscriptspeed( "default" );

}






e1_camera_watch()
{
				
				self endon( "disable" );
				self endon( "damage" );
				level endon( "e1_stealth_cancelled" );

				
				self waittill( "spotted" );

				
				
				level notify( "e1_stealth_broken" );

}





e1_camera_destroyed()
{
				
				self endon( "disable" );
				level endon( "e1_stealth_cancelled" );

				
				self waittill( "damage" );

				
				level notify( "e1_stealth_broken" );

}




e1_camera_disable()
{
				
				self endon( "disable" );
				self endon( "damage" );

				
				level waittill( "e1_stealth_cancelled" );

				
				self notify( "disable" );
}





end_event_one()
{


				level maps\_utility::flag_wait( "objective_1" );

				level.effects = false;

				level notify( "event_one_done" );
	
}






server1_pip_camera()
{
	
	setdvar("ui_hud_showstanceicon", "0"); 
	setsaveddvar("ammocounterhide", "1");  
	setdvar("ui_hud_showcompass", 0);
	
	level.player FreezeControls( true );

	
	level thread main_camera();
	
	level thread second_anim();

	wait(3.0);

	
	level thread main_crop();
	level thread main_move();

	
	level thread second_move();

	level waittill( "window_uncrop" );
	
	
	
	setdvar("ui_hud_showstanceicon", "1"); 
	setsaveddvar("ammocounterhide", "0");  
	setdvar("ui_hud_showcompass", 1);
	
	level.player FreezeControls( false );
	
	level notify("checkpoint_reached"); 
}
main_camera()
{
	
	level.player customcamera_checkcollisions( 0 );

	
	hall_cam = level.player customCamera_Push( "world", ( 309, 986, 175 ), ( .74, 121.9, 0 ), 2.0);
	
	
	thread maps\airport_util::hideBond( 0.25 );
	wait(0.1);
	
	level waittill("window_uncrop");
	
	level.player customCamera_pop( hall_cam, 0 );
	
	level.player customcamera_checkcollisions( 1 );
}
main_crop()
{
	
	setdvar("cg_pipmain_border", 2);
	setdvar("cg_pipmain_border_color", "0 0 0.2 1");
	
	
	SetDVar("r_pipMainMode", 1);	
	SetDVar("r_pip1Anchor", 3);		

	
	
	level.player animatepip( 500, 1, -1, -1, .75, .75, 0.75, .75);
	level.player waittill("animatepip_done");
		
	level notify("window_crop");
		
	
	level waittill("window_up");

	
	
	level.player animatepip( 500, 1, -1, -1, 1, 1, 1, 1);
	wait(1);
	
	
	level notify( "window_uncrop" );
	
	
	SetDVar("r_pip1Scale", "1 1 1 1");		
	SetDVar("r_pipMainMode", 0);	
}
main_move()
{
	
	level waittill("window_crop");
		
	
	
	
	
	
	level notify("window_down");
	
	level waittill("off_screen");
	
	level.player animatepip( 500, 1, -1, 0 );
	wait(0.5);
	
	level notify("window_up");
}

second_move()
{
	

	
	level.player setsecuritycameraparams( 65, 3/4 );
	wait(0.05);	
	cameraID_hack = level.player securityCustomCamera_Push( "entity", level.player, level.player, ( -50, -40, 77), ( -32, -7, 0), 0.1);
	
	
	
	SetDVar("r_pipSecondaryAnchor", 4);						
	
	

	
	setdvar("cg_pipsecondary_border", 2);
	setdvar("cg_pipsecondary_border_color", "0 0 0.2 1");

	
	
	
	
	level.player animatepip( 10, 0, 0.6, -0.5, .352188, .5, .35, .5);
	level.player waittill("animatepip_done");
	
	level waittill( "window_down" );

	SetDVar("r_pipSecondaryMode", 5);		

	
	level.player animatepip( 500, 0, 0.6, .15);
	level.player waittill("animatepip_done");
	
	

	
	
	level waittill( "sending_suspense_dood" );
	

	
	
	level.player animatepip( 500, 0, .6, 1 );
	wait(0.6);
		
	level notify("off_screen");
	
	
	level.player securitycustomcamera_pop(cameraID_hack);
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





display_chyron()
{
	wait(2);
	maps\_introscreen::introscreen_chyron(&"AIRPORT_INTRO_01", &"AIRPORT_INTRO_02", &"AIRPORT_INTRO_03");
}
