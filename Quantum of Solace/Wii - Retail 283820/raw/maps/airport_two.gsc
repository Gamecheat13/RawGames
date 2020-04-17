




main()
{
				
				
				
				level thread air2_savegame();

				
				
				

				
				
				
				level thread e2_stealth_flag_set();

				
				
				
				
				level thread e2_right_patrol();
				level thread e2_computer_patrol();
				

				
	

				
				
				
				level thread e2_comp_settings();

				
				
				level thread e2_change_monitor_model();

				
				
				
				level thread e2_villiers_dialogue();

				
				
				
				level thread e2_lock_player_in_vr();

				
				
				
				level thread e2_exit_door_control();

				
				
				
				
				level thread air_setup_zone3();

				
				
				
				
				
				level thread e2_clean_up();

				
				
				
				level thread end_event_two();

				
				
				level waittill( "event_two_done" );

}




air2_savegame()
{
				
				level waittill( "off_screen" );

				
				level maps\_autosave::autosave_now( "airport" );

}



e2_right_patrol()
{


				
				trig = getent( "ent_close_e1_exit", "targetname" );
				spawner = getent( "spwn_e2_right_patrol", "targetname" );
				orders_node = getnode( "nod_e2_right_patrol", "targetname" );
				nod_e2_tether_point = getnode( "e2_tether_point", "targetname" );

				
				dood = spawner stalingradspawn( "e2_patroller" );
				if( !maps\_utility::spawn_failed( dood ) )
				{
								
								
								
								
								dood endon( "death" );
								dood endon( "damage" );

								
								dood.script_noteworthy = "e2_right_patrol";

								
								dood thread maps\airport_util::reset_script_speed();

								
								dood setalertstatemin( "alert_yellow" );

								
								
								
								dood setscriptspeed( "walk" );

								
								dood setpropagationdelay( 3.0 );

								
								dood setgoalnode( orders_node );

								
								
								
								
								
								dood thread maps\airport_util::event_enemy_watch( "e2_stealth_cancelled", "e2_stealth_broken" );

								
								trig waittill( "trigger" );

								
								

								
								
								
								
								dood settetherradius( 750 );

								
								
								
								dood.tetherpt = nod_e2_tether_point.origin;

								
								level maps\_utility::flag_wait( "event_two_start" );		

								
								dood startpatrolroute( "nod_e2_right_patrol" );
				}
				else
				{
								
								return;
				}


}



e2_right_patrol_dialogue()
{
				
				self endon( "death" );
				self endon( "damage" );
				level endon( "e2_stealth_cancelled" );

				

				
				
				self maps\_utility::play_dialogue_nowait( "CCM3_AirpG_010A" );

				

				
				

				

				
				level notify( "e2_convo_p1" );

				

				
				

				
				
				
				
				

				
				self maps\_utility::play_dialogue_nowait( "CCM3_AirpG_012A" );

				

				
				level notify( "e2_convo_p3" );

				
				level notify( "e2_patrol_start" );
				level maps\_utility::flag_set( "event_two_start" );

}









e2_bottom_hallway_patrol()
{
				
				level endon( "event_two_done" );
				self endon("death");

				if(IsDefined(self))
				{
	
					
					self.script_noteworthy = "e2_bottom_patrol";

					
					
					
					
					self setalertstatemin( "alert_yellow" );

					
					self thread maps\airport_util::reset_script_speed();
				}

				
				trig = getent( "ent_close_e1_exit", "targetname" );
				orders_node = getnode( "nod_e2_bottom_patrol", "targetname" );
				nod_e2_tether_point = getnode( "e2_tether_point", "targetname" );

				
				trig waittill( "trigger" );


				if(IsDefined(self))
				{
					
					
					
					self setscriptspeed( "walk" );

					
					self setgoalnode( orders_node );

					
					
					self thread maps\airport_util::event_enemy_watch( "e2_stealth_cancelled", "e2_stealth_broken" );

					
					
					wait(2.5);

					
					
					
					
					self settetherradius( 750 );

					
					
					
					self.tetherpt = nod_e2_tether_point.origin;
				}
				
				
				level thread e2_enemy_dialogue();

				
				

				
				level maps\_utility::flag_wait( "event_two_start" );

				
				
				
				
				
				


}



e2_enemy_dialogue()
{
				
				dood_1 = getent( "e2_right_patrol", "script_noteworthy" );
				dood_2 = getent( "e2_bottom_patrol", "script_noteworthy" );

				
				assertex( isdefined( dood_1 ), "dood_1 not defined" );
				assertex( isdefined( dood_2 ), "dood_2 not defined" );

				
				dood_1 endon( "death" );
				dood_1 endon( "damage" );
				dood_2 endon( "death" );
				dood_2 endon( "damage" );
				level endon( "e2_stealth_cancelled" );

				
				
				
				dood_1 maps\_utility::play_dialogue_nowait( "CCM3_AirpG_010A" );

				
				wait (4.5);
				dood_2 maps\_utility::play_dialogue_nowait( "CCM4_AirpG_011A" );

				
				wait (.7);
				dood_1 maps\_utility::play_dialogue_nowait( "CCM3_AirpG_012A" );

				
				level maps\_utility::flag_set( "event_two_start" );
				

}




e2_computer_patrol()
{

				
				self endon( "death" );
				self endon( "damage" );

				
				
				spawner = getent( "spwn_e2_comp_watch", "targetname" );
				orders_node = getnode( "nod_e2_comp", "targetname" );
				laptop_node = getnode( "nod_e2_cam_lap", "targetname" );
				nod_e2_tether_point = getnode( "e2_tether_point", "targetname" );

				
				dood = spawner stalingradspawn();
				if( !maps\_utility::spawn_failed( dood ) )
				{
								
								dood endon( "death" );
								dood endon( "damage" );

								
								
								
								
								
								

								
								dood setalertstatemin( "alert_yellow" );

								
								dood setpropagationdelay( 3.0 );

								dood setscriptspeed( "walk" );

								
								dood setgoalnode( orders_node );

								
								dood waittill( "goal" );

								
								
								
								
								dood settetherradius( 750 );

								
								
								
								dood.tetherpt = nod_e2_tether_point.origin;

								
								level maps\_utility::flag_wait( "event_two_start" );

								
								dood startpatrolroute( "pr_e2_bottom" );

				}

}







e2_villiers_dialogue()
{
	

	

	
	level maps\_utility::flag_wait( "objective_2" );

	
	
	
	
	level.player maps\_utility::play_dialogue( "TANN_AirpG_013A", true );

	
	level notify("checkpoint_reached"); 
}





























e2_exit_door_control()
{
				

				
				nod_e2_virus_exit_node = getnode( "auto966", "targetname" );
				e2_virus_exit_door = getent( "ent_door_e2_exit", "targetname" );
				trig = getent( "ent_close_e2_exit", "targetname" );

				
				level maps\_utility::flag_wait( "objective_2" );

				
				
				
				wait( 3.0 );

				
				
				
				e2_virus_exit_door maps\_doors::unbarred_door();
				e2_virus_exit_door._doors_auto_close = false;

				
				
				
				nod_e2_virus_exit_node maps\_doors::open_door();

				
				trig waittill( "trigger" );

				
				e2_virus_exit_door maps\_doors::close_door();

				
				wait( 1.0 );

				
				e2_virus_exit_door maps\_doors::barred_door();	


}


#using_animtree("vehicles");



e2_helicopter_movement()
{
				
				level endon( "event_two_done" );

				
				start_trig = getent( "trig_start_heli_movement", "targetname" );
				heli_spwn_origin = getent( "so_heli_spawn", "targetname" );
				ent_fly_point_one = getent( "so_heli_points", "targetname" );
				old_spot = undefined;
				new_target = undefined;
				fly_spot = [];

				
				fly_spot[fly_spot.size] = ent_fly_point_one;
				old_spot = ent_fly_point_one;
				
				while( 1 )
				{
								if( !isdefined( old_spot.target ) )
								{
												
												break;
								}
								else if( isdefined( old_spot.target ) )
								{

												
												new_target = getent( old_spot.target, "targetname" );
								}

								
								fly_spot[fly_spot.size] = new_target;

								
								old_spot = new_target;

								
								wait( 0.1 );
				}


				
				heli_vehic = spawnvehicle( "v_heli_mdpd_low", "e3_heli", "blackhawk", ( heli_spwn_origin.origin ), ( heli_spwn_origin.angles ) );
				wait( 0.5 );
				heli_vehic.health = 10000;

				
				heli_vehic UseAnimTree( #animtree );
				heli_vehic setanim( %bh_rotors );

				
				heli_vehic thread under_light();

				
				heli_vehic thread heli_delete( heli_spwn_origin );

				
				start_trig waittill( "trigger" );

				
				while( 1 )
				{
								
								for( i=0; i<fly_spot.size; i++ )
								{
												heli_vehic setspeed( 15, 15 );
												heli_vehic setvehgoalpos( fly_spot[i].origin, 0 );
												heli_vehic waittill( "goal" );
												wait( 1.0 );
								}
								wait( 1.0 );

				}

}





heli_delete( end_point )
{

				level waittill( "event_two_done" );

				self waittill( "goal" );

				self setspeed(40, 40);
				self setvehgoalpos ( end_point.origin, 0 );
				self waittill ( "goal" );

				self delete();

}




under_light()
{
				level endon( "event_two_done" );

				
				entOrigin = Spawn( "script_model", self GetTagOrigin( "tag_ground" ) );
				entOrigin SetModel( "tag_origin" );
				entOrigin.angles = ( 45, 0, 0);
				entOrigin LinkTo( self );

				
				playfxontag ( level._effect["science_lightbeam05"], entOrigin, "tag_origin" );
}










checking_desk()
{
				
				pos = self.origin + ( 0, 0,64 );
				color = ( 0, .5, 0 );            
				scale = 1.5;       
				Print3d( pos, "Rummaging", color, 1, scale, 15 );
}




urination()
{
				
				pos = self.origin + ( 0, 0,64 );
				color = ( 0, .5, 0 );            
				scale = 1.5;       
				Print3d( pos, "Relieving self", color, 1, scale, 15 );
}




scan_area()
{
				pos = self.origin + ( 0, 0,64 );
				color = ( 0, .5, 0 );            
				scale = 1.5;       
				Print3d( pos, "Scanning area", color, 1, scale, 15 );
}






e2_lock_player_in_vr()
{
				
				

				
				
				e2_vr_enter_door = getent( "ent_e2_virus_enter", "targetname" );

				
				level maps\_utility::flag_wait( "objective_2" );

				
				e2_vr_enter_door maps\_doors::close_door();

				
				e2_vr_enter_door maps\_doors::barred_door();		
}











e2_stealth_flag_set()
{
	level endon("e2_clean_up");

	
	
	
	spawner = getent( "spwn_e2_backup", "targetname" );
	
	noda_e2_defense = getnodearray( "nod_e2_backup", "targetname" );

	nod_e2_backup_1 = getnode( "nod_e2_backup1_start", "targetname" );
	nod_e2_backup_2 = getnode( "nod_e2_backup2_start", "targetname" );
	
	ent_e2_backup_door = getentarray( "e2_backup_door", "targetname" );

	
	level waittill( "e2_stealth_broken" );

	
	level notify( "e2_stealth_cancelled" );

	
	level maps\_utility::flag_set( "e2_stealth_broken" );

	
	level thread maps\airport_util::spawn_event_backup_init( spawner, noda_e2_defense );
}





air_setup_zone3()
{
				

				
				
				trig = getent( "air_trig_setup_zone3", "targetname" );

				
				trig waittill( "trigger" );

				
				
				level maps\airport_three::e3_cameras_init();
				
				level maps\airport_three::e3_patrol_setup();

}




e2_comp_settings()
{
				
				
				

				
				


}





e2_change_monitor_model()
{
				
				

				
				

				
				
				
				
				

				

				
				
				

				
				level maps\_utility::flag_wait( "objective_2" );

				
				computer = getent( "ent_air_comp_2", "targetname" ) ;

				
				computer setmodel( "p_dec_monitor_modern" );

}





e2_clean_up()
{
	
	

	
	
	
	level maps\_utility::flag_wait( "objective_2" );

	level notify("e2_clean_up");

	
	enta_e2_spawners = getentarray( "e2_spawners", "script_noteworthy" );

	
	for( i=0; enta_e2_spawners.size; i++ )
	{
		
		
		wait( 0.05 );
		
		if( !isai( enta_e2_spawners[i] ) )
		{
			
			
			wait( 0.05 );
			
			if( isdefined( enta_e2_spawners[i] ) )
			{
				
				enta_e2_spawners[i] delete();

				
				wait( 0.1 );
			}

		}

	}

	
}






end_event_two()
{

				
				
				level maps\_utility::flag_wait( "objective_2" );

				
				
				level notify( "event_two_done" );


}

