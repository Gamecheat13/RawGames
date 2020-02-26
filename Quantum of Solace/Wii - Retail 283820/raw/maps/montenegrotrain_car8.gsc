




#include maps\_utility;




e8_main()
{
	
	level.enemy_hurt = 0;
	
	thread car9_hint_triggers();
	thread activate_gate_lock();
	
	thread spawn_bliss_run();

	
	
	
	
	level thread train_tunnel_roof_init();
	
	

	
	level waittill( "in_car_8" );
	
}





spawn_bliss_run()
{
	
	trig = GetEnt( "bliss_trig", "script_noteworthy" );
	trig waittill( "trigger" );
	
	if ( IsDefined( level.bliss_run_spawner ) )
	{
		level.bliss_run = level.bliss_run_spawner Stalingradspawn();
		if ( spawn_failed(level.bliss_run) )
		{
			iPrintLnBold( "Bliss runner spawn failed" );
		}		

		level.bliss_run animscripts\shared::placeWeaponOn( level.bliss_run.weapon, "none" );
		level.bliss_run.goalradius = 12;	
		level.bliss_run.walkdist = 320000;
		level.bliss_run SetEnableSense( false );
		level.bliss_run thread magic_bullet_shield();
		
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

					
					
					level.player play_dialogue_nowait( "BOND_TraiG_050A" );
				
					level.bliss_run play_dialogue_nowait( "BLIS_TraiG_051A" );
					
					
					level notify( "playmusicpackage_bliss" );
					
					
					thread throw_grenade_bliss();
					level.bliss_run SetScriptSpeed( "Run" );
					level.bliss_run SetGoalNode(node);
				}
			}
		}
	}
	
	
	thread maps\MontenegroTrain::finale_igc();

	hatch_bliss = GetEnt( "hatch_bliss", "targetname" );
	hatch_bliss MoveTo( hatch_bliss.origin + (0, 51, 0), 1 );
}	

throw_grenade_bliss()
{
	
	grenade_start = spawn("script_model", level.bliss_run gettagOrigin("TAG_WEAPON_RIGHT"));
	grenade_start setmodel("w_t_grenade_flash");
	grenade_start physicslaunch(grenade_start.origin , vectornormalize((0, 1.0, 0)) );
	wait(0.5);
	grenade_start delete();
			
	grenade = GetEnt( "grenade_pos", "targetname" );
	playfx (level._effect["flash"], grenade.origin +(0, 0, 0));
	grenade playsound ("explo_grenade_flashbang");
	level.player shellshock("flashbang", 4);

	
	
	
				VisionSetNaked("MontenegroTrain_in", 2.0);

				
				
}	



car9_hint_triggers()
{
	car9hint = GetEnt( "car9hint_trig", "targetname" );
	if ( IsDefined( car9hint ) )
	{
		car9hint waittill( "trigger" );
								
								
								
								
								

								
								level.player play_dialogue( "TANN_TraiG_809A", true );
	}	
}




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
				
				ent_temp = undefined;
				ent_temp_target = undefined;
				
				
				
				
				
				
				
				level.tunnel_lights = getentarray( "tunnel_lights", "targetname" );

				
				
				assertex( isdefined( level.tunnel_lights ), "tunnel lights array not defined" );

				
				
				if( isdefined( level.tunnel_lights ) )
				{
								
								for( i=0; i<level.tunnel_lights.size; i++ )
								{
												if( isdefined( level.tunnel_lights[i].target2 ) )
												{
																
																ent_temp = getent( level.tunnel_lights[i].target2, "targetname" );

																
																if(!isdefined(ent_temp))
																{
																	continue;
																}
																
																
																wait( 0.05 );

																
																assertex( isdefined( ent_temp ), "light target2 not valid" );

																

																
																ent_temp_target = getent( ent_temp.target, "targetname" );

																
																assertex( isdefined( ent_temp_target ), "light script origin target not valid" );

																

																
																level.tunnel_lights[i] linklighttoentity( ent_temp );

																
																level.tunnel_lights[i].origin = ( 0, 0, 0 );

																
																ent_temp linkto( ent_temp_target );

																
																

																wait( 0.05 );

																
																ent_temp = undefined;
												}
												else
												{
																
																iprintlnbold( "light missing a target" );

																
																continue;
												}
								}
				}
	
	
	
	Maps\MontenegroTrain_snd::audio_tunnel_linkage();
	
	
	for ( i = 0; i < 8; i++ )
	{
		level.background_tunnel[i] hide();
	}	


	thread background_tunnel_move();
}	



tunnel_light_3d_print( light )
{
				

				
				while( 1 )
				{
								
								print3d( light.origin + ( 0, 0, -5 ), "TUNNEL_LIGHT", ( 255, 250, 250 ), 1, 1, 100 );

								
								wait( 1.0 );
				}

}

background_tunnel_move()
{
	start_trig = GetEnt( "start_tunnel_loop", "targetname" );
	if ( IsDefined(start_trig) )
	{
		
		
		
		level thread tunnel_moving_light();

		start_trig waittill ("trigger");
		setExpFog(500, 2000,9/255, 13/255, 15/255, 0);
		
		
		
		
								
								
								level notify( "tunnel_vision_set" );
		
		
		
		VisionSetNaked("MontenegroTrain_tunnel", 2.0);

		
								

								
		
		

		level.standard_background = false;

								
								
								for( i=0; i<level.background_scene.size; i++ )
								{
												
												level.background_scene[i] notify( "stop_delete" );

												
												level.background_scene[i] hide();
								}

		thread setup_tunnel_hurt();
		thread play_tunnel_looping();
		
		
		
		
								
								
								
								for( i=0; i<level.background_tunnel.size; i++ )
								{
												
												level.background_tunnel[i] thread maps\MontenegroTrain::train_scenery_hide();
								}
								
	}
	else
	{
		iPrintLnBold( "Couldn't find trigger for tunnel");
	}		
	
	stop_trig = GetEnt( "stop_tunnel_loop", "targetname" );
	if ( IsDefined(stop_trig) )
	{
		stop_trig waittill ("trigger");
		setExpFog(2000, 6000,3/255, 17/255, 26/255, 0);
		
		level.standard_background = true;

								
								
								
								for( i=0; i<level.background_scene.size; i++ )
								{
												
												level.background_scene[i] thread maps\MontenegroTrain::train_scenery_hide();

												
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
	
	for ( i = 0; i < 11; i++ )
	{
		level.background_scene[i] hide();
	}	

	
	for ( i = 0; i < 8; i++ )
	{
		level.background_tunnel[i] show();
		level.background_tunnel[i] movex(-1*14848, 0.05);
	}	
	level.background_tunnel[0] waittill( "movedone" );

	
	i = 0;
	travel_time = 3.0;		

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
	
	
	for ( i = 0; i < 11; i++ )
	{
		level.background_scene[i] show();
	}	
				
				if( isdefined( level.tunnel_lights ) )
				{
								
								for( i=0; i<level.tunnel_lights.size; i++ )
								{
												
												level.tunnel_lights[i] unlink();

												
												level.tunnel_lights[i] delete();
								}
				}
	for ( i = 0; i < 8; i++ )
	{
								
								level.background_tunnel[i] notify( "stop_delete" );

								
								level.background_tunnel[i] moveto( level.background_tunnel[i].origin + ( 0, 0, -15000 ), 0.5 );

								
								level.background_tunnel[i] waittill( "movedone" );

								
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
			
			
			
			
			if( isalive( entity ) )
			{
				
				entity setenablesense( false );
				
				entity stopallcmds();
				
				entity cmdplayanim( "Thug_Train_roof_hit_back", false, true );
				
				wait( 0.20 );
				
				entity becomecorpse();
				
				entity startragdoll( );
				
				entity waittill( "cmd_done" );
				

				thread enemy_learn_crouch();
			}

		}	
		else if(entity == level.player)
		{
			
			
			
												entity dodamage( 240, entity.origin + ( 0, 40, 0 ) );
												
			level.player allowStand(false);
												
			level.player shellshock( "default", 1.5 );
												
												earthquake( 0.25, 0.25, level.player.origin, 512 );
												
												wait( 1.0 );
												
			level.player allowStand(true);
		}	
	}	
}	
enemy_learn_crouch()
{
	
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
	run2_node = GetNode( baggage_locker_spawner.target, "targetname" );
	
	if ( IsDefined(baggage_locker_trig) )
	{
		baggage_locker_trig waittill( "trigger" );
		baggage_locker = baggage_locker_spawner Stalingradspawn();
		if ( spawn_failed(baggage_locker) )
		{
			iPrintLnBold( "Couldn't spawn lock guy" );
		}	
		
		baggage_locker SetGoalPos(baggage_locker.origin);
		
		baggage_locker.goalradius = 12;	
		baggage_locker.walkdist = 320000;
		baggage_locker SetEnableSense( false );
		
		if ( IsDefined(run1_node) )
		{
			
			
			run_trig waittill( "trigger" );
			lookat_trig waittill( "trigger" );
			
			baggage_locker SetScriptSpeed( "Run" );
			baggage_locker SetGoalNode(run1_node);
			
			baggage_locker waittill( "goal" );

			
			level notify( "baggage_car_locked" );

			
			int_random = randomint( 10 );
			if( int_random > 5 )
			{
							
							baggage_locker play_dialogue( "GAMR_TraiG_049A" );
			}
			else
			{
							
							baggage_locker play_dialogue( "GAMR_TraiG_049B" );
			}



			wait(1.0);

		}
		if ( IsDefined(run2_node) )
		{				
			baggage_locker SetScriptSpeed( "Run" );
			baggage_locker SetGoalNode(run2_node);
				
			baggage_locker waittill( "goal" );
			
		}
	}
}







train_tunnel_roof_init()
{
	
	

	
	
	start_trig = getent( "bliss_trig", "script_noteworthy" );
	
	backup_trig = getent( "car9_trig_roof_backup", "targetname" );
	
	enta_roof_enemies = getentarray( "car9_roof_enemy", "targetname" );
	
	ent_roof_backup = getent( "car9_roof_backup", "targetname" );

	
	
	
	if( isdefined( enta_roof_enemies ) )
	{
		
		for( i=0; i<enta_roof_enemies.size; i++ )
		{
			
			
			if( !isdefined( enta_roof_enemies[i].count ) || enta_roof_enemies[i].count < 1 )
			{
				
				enta_roof_enemies[i].count = 1;
			}

			
			wait( 0.05 );
		}
	}
	else
	{
		iprintlnbold( "enta_roof_enemies not defined!" );
	}

	
	if( isdefined( ent_roof_backup ) )
	{
		
		if( ent_roof_backup.count < 3 )
		{
			
			ent_roof_backup.count = 3;
		}
	}
	else
	{
		
		iprintlnbold( "ent_roof_backup not defined" );
	}

	
	
	
	backup_trig thread train_car9_roof_backup( ent_roof_backup );

	
	start_trig waittill( "trigger" );

	
	for( i=0; i<enta_roof_enemies.size; i++ )
	{
		
		enta_roof_enemies[i] thread train_car9_roof_spawns();

		
		wait( 0.05 );
	}

}







train_car9_roof_spawns()
{
	
	level notify( "endmusicpackage" );
	
	
	
	
	
	ent_temp = undefined;
	
	nod_temp = undefined;

	
	
	if( isdefined( self.target ) )
	{
		
		ent_temp = self stalingradspawn( "car9_roof" );

		
		if( spawn_failed( ent_temp ) )
		{
			
			iprintlnbold( "spawner at " + self.origin + "failed spawn" );

			
			return;
		}

		
		ent_temp setengagerule( "tgtSight" );
		ent_temp addengagerule( "tgtPerceive" );
		ent_temp addengagerule( "Damaged" );
		ent_temp addengagerule( "Attacked" );

		 
		if( isdefined( self.script_string ) )
		{
			
			if( self.script_string == "car9_light_death" )
			{
				
				ent_temp setscriptspeed( "run" );

				
				
				ent_temp settetherradius( 24 );

				
				nod_temp = getnode( self.target, "targetname" );

				
				ent_temp.tetherpt = nod_temp.origin;

				
				level thread car9_light_hit( ent_temp, self.target );

			}
		}
		
		else
		{
			
			
			ent_temp settetherradius( 72 );

			
			nod_temp = getnode( self.target, "targetname" );

			
			ent_temp.tetherpt = nod_temp.origin;
		}
	}
}





car9_light_hit( guy, str_target )
{
	
	level.player endon( "death" );

	
	
	if( isdefined( str_target ) )
	{
		nod_temp = getnode( str_target, "targetname" );
	}
	else
	{
		
		iprintlnbold( "str_Target not defined!" );
	}
	
	
	lookat_trig = getent( "car9_trig_light_death", "targetname" );

	
	if( isdefined( guy ) )
	{
		
		
		guy setscriptspeed( "run" );

		
		
		guy settetherradius( 24 );

		
		guy allowedstances( "crouch" );

		
		nod_temp = getnode( str_target, "targetname" );

		
		guy.tetherpt = nod_temp.origin;

		
		lookat_trig waittill( "trigger" );

		
		guy allowedstances( "stand" );

		
		guy setperfectsense( true );
	}
	else
	{
		
		iprintlnbold( "car9_light_hit guy not defined!" );
	}
}







train_car9_roof_backup( spawner )
{
	
	

	
	
	nod_temp = undefined;
	
	ent_temp = undefined;

	
	if( isdefined( spawner ) )
	{
		
		if( isdefined( spawner.target ) )
		{
			
			
			
			nod_temp = getnode( spawner.target, "targetname" );
			

			
			self waittill( "trigger" );

			
			
			for( i=0; i<3; i++ )
			{
				
				ent_temp = spawner stalingradspawn( "car9_roof" );

				
				if( spawn_failed( ent_temp ) )
				{
					
					iprintlnbold( "fail spawn from train_car9_roof_backup" );

					
					return;
				}

				
				ent_temp allowedstances("crouch");

				
				ent_temp setengagerule( "tgtSight" );
				ent_temp addengagerule( "tgtPerceive" );
				ent_temp addengagerule( "Damaged" );
				ent_temp addengagerule( "Attacked" );

				
				ent_temp settetherradius( 72 );

				
				ent_temp.tetherpt = nod_temp.origin;

				
				wait( 2.0 );
			}
		}
		else
		{
			
			iprintlnbold( "train_car9_roof_backup has no target!" );

			
			return;
		}
	}
	else
	{
		
		iprintlnbold( "train_car9_roof_backup has no spawner!" );

		
		return;
	}
}





tunnel_moving_light()
{
	
	level.player endon( "death" );

	
	
	
	d_tunnel_light = getent( "moving_tunnel_light", "targetname" );
	
	enta_tunnel_points = getentarray( "tunnel_light_side", "targetname" );
	
	temp_ent = undefined;

	
	wait( 0.05 );

	assertex( isdefined( d_tunnel_light ), "d_tunnel_light not defined" );
	assertex( isdefined( enta_tunnel_points ), "enta_tunnel_points not defined" );

	if( isdefined( enta_tunnel_points ) )
	{
		
		for( i=0; i<enta_tunnel_points.size; i++ )
		{
			
			if( isdefined( enta_tunnel_points[i].target ) )
			{
				
				temp_ent = getent( enta_tunnel_points[i].target, "targetname" );

				
				enta_tunnel_points[i] linkto( temp_ent );

				
				wait( 0.05 );

				
				temp_ent = undefined;
			}
			else
			{
				
				iprintlnbold( "enta_tunnel_points fail" );
			}
		}

	}
	else
	{
		
		iprintlnbold( "enta_tunnel_points fail" );
	}

	
	while( level.standard_background == true )
	{
		
		wait( 0.1 );
	}

	
	while( level.standard_background == false )
	{
		
		for( i=0; i<enta_tunnel_points.size; i++ )
		{

			
			
			if( DistanceSquared( level.player.origin, enta_tunnel_points[i].origin ) < 7000*7000 && DistanceSquared( level.player.origin, enta_tunnel_points[i].origin ) > 6000*6000  )
			{
				
				d_tunnel_light.origin = enta_tunnel_points[i].origin;
				
				


				
				d_tunnel_light linkto( enta_tunnel_points[i] );

				

				
				
				level tunnel_light_raise_n_drop( d_tunnel_light, enta_tunnel_points[i] );

				
				

				

			}
			else
			{
				
				wait( 0.05 );
			}
		}

		
		d_tunnel_light.intensity = 0.0;

		
		d_tunnel_light unlink();

		wait( 0.05 );

		
		


		
		wait( 0.05 );
	}
}








tunnel_light_raise_n_drop( light, scr_org )
{
	
	level.player endon( "death" );

	
	
	
	

	
	
	if( isdefined( light ) && isdefined( scr_org ) )
	{
		
		light.intensity = 2.0;

		while( distancesquared( light.origin, level.player.origin ) > 3000*3000 )
		{
			
			wait( 0.05 );
		}

		

		

		while( distancesquared( light.origin, level.player.origin ) > 1500*1500 )
		{
			
			wait( 0.05 );
		}

		

		

		while( distancesquared( light.origin, level.player.origin ) < 4500*4500 )
		{
			
			wait( 0.05 );
		}

		light.intensity = 0;

		

	}
	else
	{
		iprintlnbold( "light or scr_org not defined" );
	}
	



	
	
}


