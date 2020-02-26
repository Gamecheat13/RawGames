// _vehicle_death.gsc - all things related to vehicles dying

// Utility rain functions:
#include maps\_utility;
#include maps\_vehicle;
#include common_scripts\utility;

#insert raw\maps\_utility.gsh;
#insert raw\common_scripts\utility.gsh;

#using_animtree( "vehicles" );

init()
{
	if( IsAssetLoaded( "fx", "trail/fx_trail_heli_killstreak_engine_smoke" ) )
	{
		//level.heli_hit_fx = 
		level.heli_crash_smoke_trail_fx = LoadFX( "trail/fx_trail_heli_killstreak_engine_smoke" );
	}
}

main()
{
	self endon( "nodeath_thread" );

	while ( IsDefined( self ) )
	{
		// waittill death twice. in some cases the vehicle dies and does a bunch of stuff. then it gets deleted. which it then needs to do more stuff
		self waittill( "death", attacker, damageFromUnderneath, weaponName, point, dir );
		
		if ( !IsDefined( self.delete_on_death ) )
		{
			self thread play_death_audio();
		}
		
		if ( !IsDefined( self ) )
		{
			return;
		}
		
		self lights_off();
		self death_cleanup_level_variables();			
	
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
			
		if ( is_corpse( self ) )
		{
			// Cleanup Riders
			if( IS_FALSE( self.dont_kill_riders ) )
			{
				self death_cleanup_riders();
			}
			
			// kills some destructible fxs
			self notify( "delete_destructible" );

			// Done here
			return;
		}

		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	
		// Run vehicle death thread
		if( IsDefined( level.vehicle_death_thread[ self.vehicletype ] ) )
		{
			thread [[ level.vehicle_death_thread[ self.vehicletype ] ]]();
		}

		if( !IsDefined( self.delete_on_death ) )
		{
			// Do death rumble 
			if( IsDefined( self.deathquakescale ) && self.deathquakescale > 0 )
			{
				Earthquake( self.deathquakescale, self.deathquakeduration, self.origin, self.deathquakeradius );
			}
			// Do radius damage
			thread death_radius_damage();
		}
		
		is_aircraft = (  IS_PLANE( self ) || IS_HELICOPTER( self ) );

		if( !IsDefined( self.destructibledef ) )
		{
			if( !is_aircraft && !( self.vehicleType == "horse" || self.vehicleType == "horse_player" || self.vehicleType == "horse_player_low" || self.vehicleType == "horse_low" ) && IsDefined( self.deathmodel ) && self.deathmodel != "" )
			{
				self thread set_death_model( self.deathmodel, self.modelswapdelay );
			}

			// Do death_fx if it has not been mantled
			if( !IsDefined( self.delete_on_death ) && ( !IsDefined( self.mantled ) || !self.mantled ) && !IsDefined( self.nodeathfx ) )
			{
				thread death_fx();
			}
			
			if( IsDefined( self.delete_on_death ) )
			{
				wait( 0.05 );

				if( !IsDefined( self.dontDisconnectPaths ) )
				{
					self vehicle_disconnectpaths_wrapper();
				}

				self freevehicle();
				self.isacorpse = true;

				wait( 0.05 ); 

				self notify( "death_finished" );
				self delete();

				continue;
			}
		}		
		
		// makes riders blow up
		if ( IsDefined( self.riders ) && self.riders.size > 0 )
		{
			maps\_vehicle_aianim::blowup_riders();
		}
	
		// Place a bad place cylinder if specified
		thread death_make_badplace( self.vehicletype );

		// Send vehicle type specific notify
		if( IsDefined( level.vehicle_deathnotify ) && IsDefined( level.vehicle_deathnotify[ self.vehicletype ] ) )
		{
			level notify( level.vehicle_deathnotify[ self.vehicletype ], attacker );
		}	
		
		if ( Target_IsTarget( self ) )
		{
			Target_Remove( self );
		}

		// all the vehicles get the same jolt..
		if ( self.classname == "script_vehicle" )
		{
			self thread death_jolt( self.vehicletype );
		}

		if ( do_scripted_crash() )
		{
			// Check for scripted crash
			self thread death_update_crash( point, dir );
		}

		// Clear turret target
		if( IsDefined( self.turretweapon ) && self.turretweapon != "" )
		{
			self clearTurretTarget();
		}

		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 

		// Wait here until we're finished with a crash or rolling death
		self waittill_crash_done_or_stopped();
		
		if ( IsDefined( self ) )
		{
			while( IsDefined( self ) && IsDefined( self.dontfreeme ) )
			{
				wait( .05 );
			}
			
			// send notifies
			self notify( "stop_looping_death_fx" );
			self notify( "death_finished" );
		
			wait .05;
		
			if( IsDefined( self ) )
			{
				if ( is_corpse( self ) )
				{
					continue;
				}
				
				if( !IsDefined( self ) )
				{
					continue;
				}
				
				// AE 2-18-09: if the player is using it, then spit them out or kill them before freeing the vehicle
				occupants = self GetVehOccupants();
				if ( IsDefined( occupants ) && occupants.size )
				{
					for(i = 0; i < occupants.size; i++)
					{
						self UseBy( occupants[i] );
					}
				}
	
				self freevehicle();
				self.isacorpse = true;
				
				if ( self.modeldummyon )
				{
					self hide();
				}
			}
		}
	}
}

do_scripted_crash()
{
	return !IsDefined( self.do_scripted_crash ) || IS_TRUE( self.do_scripted_crash );
}

play_death_audio()
{
	if(IsDefined (self) && IS_HELICOPTER( self ))
	{
		if(!IsDefined (self.death_counter))
		{
			self.death_counter = 0;	
		}
		if(self.death_counter == 0)
		{
			self.death_counter++;
			self playsound ("exp_veh_helicopter_hit");
		}
	}
}

play_spinning_plane_sound()
{
	self playloopsound( "veh_drone_spin", .05 );
	level waittill_any( "crash_move_done", "death" );
	self stoploopsound(.02);
}

set_death_model( sModel, fDelay )
{
	assert( IsDefined( sModel ) );
	
	if( IsDefined( fDelay ) && ( fDelay > 0 ) )
	{
		wait fDelay;
	}
	
	if ( !IsDefined( self ) )
	{
		return;
	}
	
	if ( IsDefined( self.deathmodel_attached ) )
	{
		return;
	}
	
	eModel = get_dummy();
	if ( !IsDefined( eModel.death_anim ) )
	{
		eModel ClearAnim( %root, 0 );
	}
	
	eModel SetModel( sModel );
	eModel SetVehicleAttachments( 1 );
}


aircraft_crash( point, dir )
{
	self.crashing = true; 

	if( IsDefined( self.unloading ) )
	{
		while( IsDefined( self.unloading ) )
		{
			wait( 0.05 ); 
		}
	}

	if( !IsDefined( self ) )
	{
		return; 
	}

	self thread aircraft_crash_move( point, dir );
	self thread play_spinning_plane_sound();
}

helicopter_crash( point, dir )
{
	self.crashing = true; 
	self thread play_crashing_loop();

	if( IsDefined( self.unloading ) )
	{
		while( IsDefined( self.unloading ) )
		{
			wait( 0.05 ); 
		}
	}

	if( !IsDefined( self ) )
	{
		return; 
	}

	//self thread helicopter_crash_move( point, dir );
	self thread helicopter_crash_movement( point, dir );

}

helicopter_crash_movement( point, dir )
{
	self endon( "crash_done" );
	
	self CancelAIMove();
	self ClearVehGoalPos();	
	
	if ( IsDefined( level.heli_crash_smoke_trail_fx ) && self.vehicletype == "drone_firescout_axis" )
	{
		playfxontag( level.heli_crash_smoke_trail_fx, self, "tag_main_rotor" );
	}
	
	else if( IsDefined( level.heli_crash_smoke_trail_fx ) )
	{
		playfxontag( level.heli_crash_smoke_trail_fx, self, "tag_engine_left" );
	}

	crash_zones = GetStructArray( "heli_crash_zone", "targetname" );
	if ( crash_zones.size > 0  )
	{
		best_dist = 99999;
		best_idx = -1;
		for ( i = 0; i < crash_zones.size; i++ )
		{
			vec_to_crash_zone = crash_zones[i].origin - self.origin;
			vec_to_crash_zone = ( vec_to_crash_zone[0], vec_to_crash_zone[1], 0 );
			dist = Length( vec_to_crash_zone );
			vec_to_crash_zone /= dist;
	
			veloctiy_scale = -VectorDot( self.velocity, vec_to_crash_zone );
			dist += 500 * veloctiy_scale;
			if ( dist < best_dist )
			{
				best_dist = dist;
				best_idx = i;				
			}
		}
		
		if ( best_idx != -1 )
		{
			self.crash_zone = crash_zones[best_idx];
			self thread helicopter_crash_zone_accel( dir );
		}
	}
	else
	{
		dir = VectorNormalize( dir );
		side_dir = VectorCross( dir, (0,0,1) );
		side_dir_mag = RandomFloatRange( -500, 500 );
		side_dir_mag += Sign( side_dir_mag ) * 60;
		side_dir *= side_dir_mag;
		side_dir += (0,0,150);
		
		self SetPhysAcceleration( ( 0, 0, -800 ) );		
		self SetVehVelocity( self.velocity + side_dir );
		self thread helicopter_crash_accel();
		self thread helicopter_crash_rotation( point, dir );
	}
	
	//self thread helicopter_collision();
	self thread crash_collision_test();	
	
	wait 15;
	
	// failsafe notify
	self notify( "crash_done" );
}

helicopter_crash_accel()
{
	self endon( "crash_done" );
	self endon( "crash_move_done" );
	
	if ( !IsDefined( self.crash_accel ) )
	{
		self.crash_accel = RandomFloatRange( 50, 80 );
	}
	
	while( isDefined(self) )
	{
		self SetVehVelocity( self.velocity + AnglesToUp( self.angles ) * self.crash_accel );
		wait 0.1;
	}
}

helicopter_crash_rotation( point, dir )
{
	self endon( "crash_done" );
	self endon( "crash_move_done" );
	self endon( "death" );
	
	ang_vel = self GetAngularVelocity();
	ang_vel = ( 0, ang_vel[1] * RandomFloatRange( 2, 3 ), 0 );
	self SetAngularVelocity( ang_vel );			
	
	point_2d = ( point[0], point[1], self.origin[2] );

	//DebugStar( self.origin, 1000, ( 1, 1, 1 ) );
	//DebugStar( point_2d, 1000, ( 1, 0, 0 ) );

	torque = ( 0, 720, 0 );
	if ( Distance( self.origin, point_2d ) > 5 )
	{
		local_hit_point = point_2d - self.origin;		
		
		dir_2d = ( dir[0], dir[1], 0 );
		if ( Length( dir_2d ) > 0.01 )
		{
			dir_2d = VectorNormalize( dir_2D );
			torque = VectorCross( VectorNormalize( local_hit_point ), dir );
			torque = ( 0, 0, torque[2] );
			torque = VectorNormalize( torque );
			torque = ( 0, torque[2] * 180, 0 );
		}
	}

	while ( 1 )
	{
		ang_vel = self GetAngularVelocity();
		ang_vel += torque * 0.05;
		
		const max_angluar_vel = 180;
		if ( ang_vel[1] < max_angluar_vel * -1 )
		{
			ang_vel = ( ang_vel[0], max_angluar_vel * -1, ang_vel[2] );
		}
		else if ( ang_vel[1] > max_angluar_vel )
		{
			ang_vel = ( ang_vel[0], max_angluar_vel, ang_vel[2] );
		}

		self SetAngularVelocity( ang_vel );

		wait( 0.05 );
	}	
}

helicopter_crash_zone_accel( dir )
{
	self endon( "crash_done" );
	self endon( "crash_move_done" );
	
	torque = ( 0, 180, 0 );
	ang_vel = self GetAngularVelocity();
	//ang_vel = ( 0, ang_vel[1], 0 );	// get rid of the pitch and roll
	//self SetAngularVelocity( ang_vel );	
	torque *= Sign( ang_vel[1] );
	
	while( IsDefined( self ) )
	{
		assert( IsDefined( self.crash_zone ) );
		
		dist = Distance2D( self.origin, self.crash_zone.origin );
		if ( dist < self.crash_zone.radius )
		{
			//if ( IsDefined( self.crash_zone.angles ) ) 
			//	self.crash_vel = Length( self.velocity ) * AnglesToForward( self.crash_zone.angles );
			
			self SetPhysAcceleration( ( 0, 0, -400 ) );
			/#Circle( self.crash_zone.origin + ( 0, 0, self.crash_zone.height ), self.crash_zone.radius, ( 0, 1, 0 ), false, 2000 );#/
			self.crash_accel = 0;
		}
		else
		{
			self SetPhysAcceleration( ( 0, 0, -50 ) );
			/#Circle( self.crash_zone.origin + ( 0, 0, self.crash_zone.height ), self.crash_zone.radius, ( 1, 0, 0 ), false, 2 );#/
		}
	
		self.crash_vel = self.crash_zone.origin - self.origin;
		self.crash_vel = ( self.crash_vel[0], self.crash_vel[1], 0 );
		self.crash_vel = VectorNormalize( self.crash_vel );
		self.crash_vel *= self GetMaxSpeed() * 0.5;
		
		crash_vel_forward = AnglesToUp( self.angles ) * self GetMaxSpeed() * 2;
		crash_vel_forward  = ( crash_vel_forward[0], crash_vel_forward[1], 0 );
		self.crash_vel += crash_vel_forward;
		
		vel_x = DiffTrack( self.crash_vel[0], self.velocity[0], 1, 0.1 );
		vel_y = DiffTrack( self.crash_vel[1], self.velocity[1], 1, 0.1 );
		vel_z = DiffTrack( self.crash_vel[2], self.velocity[2], 1, 0.1 );
		
		self SetVehVelocity( ( vel_x, vel_y, vel_z ) );
		
		ang_vel = self GetAngularVelocity();
		ang_vel = ( 0, ang_vel[1], 0 );
		ang_vel += torque * 0.1;
		
		const max_angluar_vel = 200;
		if ( ang_vel[1] < max_angluar_vel * -1 )
		{
			ang_vel = ( ang_vel[0], max_angluar_vel * -1, ang_vel[2] );
		}
		else if ( ang_vel[1] > max_angluar_vel )
		{
			ang_vel = ( ang_vel[0], max_angluar_vel, ang_vel[2] );
		}

		self SetAngularVelocity( ang_vel );		

		wait( 0.1 );
	}
}

helicopter_collision()
{
	self endon( "crash_done" );
	
	while( 1 )
	{
		self waittill( "veh_collision", velocity, normal );
		
		ang_vel = self GetAngularVelocity() * 0.5;
		self SetAngularVelocity( ang_vel );
		
		// bounce off walls
		if( normal[2] < 0.7 )	
		{
			self SetVehVelocity( self.velocity + normal * 70 );
		}
		else
		{
			//self.crash_accel *= 0.5;
			//self SetVehVelocity( self.velocity * 0.8 );
			CreateDynEntAndLaunch( self.deathmodel, self.origin, self.angles, self.origin, self.velocity * 0.03, self.deathfx, 1 );
			self notify( "crash_done" );
		}
	}
}

play_crashing_loop()
{
	ent = spawn ("script_origin", self.origin);
	ent linkto (self);
	ent playloopsound ("exp_heli_crash_loop");
	self waittill_any ("death", "snd_impact");
	ent delete();
	
}
helicopter_explode( delete_me )
{	
	self endon( "death" );
	
	fx_origin = self GetTagOrigin(self.death_fx_struct.tag);
	fx_angles = self GetTagAngles(self.death_fx_struct.tag);
	PlayFx( self.death_fx_struct.effect, fx_origin, AnglesToForward(fx_angles), AnglesToUp(fx_angles) );
		
	if ( Abs( fx_origin[0] ) > 65000 || Abs( fx_origin[1] ) > 60000 || Abs( fx_origin[2] ) > 30000 )
		return;
	
	playsoundatposition ("exp_veh_helicopter", fx_origin); 		
		
	self notify ("snd_impact");
	
	if ( IsDefined( delete_me ) && delete_me == true )
	{
		self Delete();
	}
	
	self thread set_death_model( self.deathmodel, self.modelswapdelay );	
}

get_unused_crash_locations()
{
	unusedLocations = [];
	for ( i = 0; i < level.helicopter_crash_locations.size; i++ )
	{
		if ( IsDefined( level.helicopter_crash_locations[ i ].claimed ) )
		{
			continue; 
		}
		unusedLocations[ unusedLocations.size ] = level.helicopter_crash_locations[ i ]; 
	}
	return unusedLocations;
}

aircraft_crash_move( point, dir )
{
	self endon( "crash_move_done" );
	self endon( "death" );
	
	self thread crash_collision_test();
	self ClearVehGoalPos();
	self CancelAIMove();
	self SetRotorSpeed( 0.2 );

	// swap to deathmodel here
	if( IsDefined( self ) && IsDefined( self.vehicletype ) )
	{
		b_custom_deathmodel_setup = true;
		switch( self.vehicletype )
		{
			case "drone_avenger":
			case "drone_avenger_fast":
			case "drone_avenger_fast_la2":
			case "drone_avenger_fast_la2_2x":
				self maps\_avenger::set_deathmodel( point, dir );
				break;
				
			case "drone_pegasus":
			case "drone_pegasus_fast":
			case "drone_pegasus_fast_la2":
			case "drone_pegasus_fast_la2_2x":
			case "drone_pegasus_low":
			case "drone_pegasus_low_la2":				
				self maps\_pegasus::set_deathmodel( point, dir );
				break;
				
			case "plane_f35":
			case "plane_f35_fast":
			case "plane_f35_vtol":		
			case "plane_f35_fast_la2":
			case "plane_f35_vtol_nocockpit":
			case "plane_fa38_hero":
				self maps\_f35::set_deathmodel( point, dir );
				break;								
				
			default:
				b_custom_deathmodel_setup = false;
				break;
		}
		
		if ( b_custom_deathmodel_setup ) 
		{
			self.deathmodel_attached = true;  // this will not add another deathmodel
		}
	}

	ang_vel = self GetAngularVelocity();
	ang_vel = ( 0, 0, 0 );
	
	self SetAngularVelocity( ang_vel );	
	
	nodes = self GetVehicleAvoidanceNodes( 10000 );
	closest_index = -1;
	best_dist = 999999;
	if ( nodes.size > 0 )
	{
		for ( i = 0; i < nodes.size; i++ )
		{
			dir = VectorNormalize( nodes[i] - self.origin );
			forward = AnglesToForward( self.angles );
			dot = VectorDot( dir, forward );
			if ( dot < 0.0 )
				continue;
			
			dist = Distance2D( self.origin, nodes[i] );
			if ( dist < best_dist )
			{
				best_dist = dist;
				closest_index = i;
			}
		}
		
		if ( closest_index >= 0 )
		{
			o = nodes[closest_index];
			o = ( o[0], o[1], self.origin[2] );
			
			//Line( self.origin, o, ( 1, 1, 1 ), false, 10000 );
			//Circle( o, 2000, ( 1, 1, 0 ), true, 10000 );
			
			dir = VectorNormalize( o - self.origin );
			
			self SetVehVelocity( self.velocity + dir * 2000 );					
		}
		else
		{
			self SetVehVelocity( self.velocity + AnglesToRight( self.angles ) * RandomIntRange( -1000, 1000 ) + ( 0, 0, RandomIntRange( 0, 1500 ) ) );		
		}
	}
	else
	{
		self SetVehVelocity( self.velocity + AnglesToRight( self.angles ) * RandomIntRange( -1000, 1000 ) + ( 0, 0, RandomIntRange( 0, 1500 ) ) );
	}
	
	//self SetVehVelocity( self.velocity + AnglesToRight( self.angles ) * RandomIntRange( -1000, 1000 ) + ( 0, 0, RandomIntRange( 0, 1500 ) ) );	
	self thread delay_set_gravity( RandomFloatRange( 1.5, 3 ) );
	
	torque = ( 0, RandomIntRange( -90, 90 ), RandomIntRange( 90, 720 ) );
	if ( RandomInt( 100 ) < 50 )
	{
		torque = ( torque[0], torque[1], -torque[2] );
	}
	
	while ( IsDefined(self) )
	{
		ang_vel = self GetAngularVelocity();
		ang_vel += torque * 0.05;
		
		const max_angluar_vel = 500;
		if ( ang_vel[2] < max_angluar_vel * -1 )
		{
			ang_vel = ( ang_vel[0], ang_vel[1],  max_angluar_vel * -1 );
		}
		else if ( ang_vel[2] > max_angluar_vel )
		{
			ang_vel = ( ang_vel[0], ang_vel[1],  max_angluar_vel );
		}

		self SetAngularVelocity( ang_vel );
		
		wait( 0.05 );
	}
}

delay_set_gravity( delay )
{
	self endon( "crash_move_done" );
	self endon( "death" );	
	
	wait( delay );
	
	self SetPhysAcceleration( ( RandomIntRange( -1600, 1600 ), RandomIntRange( -1600, 1600 ), -1600 ) );
}

helicopter_crash_move( point, dir )
{
	self endon( "crash_move_done" );
	self endon( "death" );

	self thread crash_collision_test();
	self CancelAIMove();
	self ClearVehGoalPos();	
	self SetTurningAbility( 0 );


	self SetPhysAcceleration( ( 0, 0, -800 ) );

	vel = self.velocity;
	dir = VectorNormalize( dir );

	ang_vel = self GetAngularVelocity();
	ang_vel = ( 0, ang_vel[1] * RandomFloatRange( 1, 3 ), 0 );
	self SetAngularVelocity( ang_vel );
		
//	if ( Length( vel ) < 10 )
//	{
//		random_yaw = RandomIntRange( -180, 180 );
//		launch_dir = AnglesToForward( ( 0, random_yaw, 0 ) );
//		vel = launch_dir * RandomIntRange( 500, 1000 );
//	}
//	else
//	{
//		vel += dir * 1000.0;
//	}
//	
//	self SetVehVelocity( vel );

	point_2d = ( point[0], point[1], self.origin[2] );

	//DebugStar( self.origin, 1000, ( 1, 1, 1 ) );
	//DebugStar( point_2d, 1000, ( 1, 0, 0 ) );

	torque = ( 0, 720, 0 );
	if ( Distance( self.origin, point_2d ) > 5 )
	{
		local_hit_point = point_2d - self.origin;		
		
		dir_2d = ( dir[0], dir[1], 0 );
		if ( Length( dir_2d ) > 0.01 )
		{
			dir_2d = VectorNormalize( dir_2D );
			torque = VectorCross( VectorNormalize( local_hit_point ), dir );
			torque = ( 0, 0, torque[2] );
			torque = VectorNormalize( torque );
			torque = ( 0, torque[2] * 180, 0 );
		}
	}

	while ( 1 )
	{
		ang_vel = self GetAngularVelocity();
		ang_vel += torque * 0.05;
		
		const max_angluar_vel = 360;
		if ( ang_vel[1] < max_angluar_vel * -1 )
		{
			ang_vel = ( ang_vel[0], max_angluar_vel * -1, ang_vel[2] );
		}
		else if ( ang_vel[1] > max_angluar_vel )
		{
			ang_vel = ( ang_vel[0], max_angluar_vel, ang_vel[2] );
		}

		self SetAngularVelocity( ang_vel );

		wait( 0.05 );
	}
}


boat_crash( point, dir )
{
	self.crashing = true; 
//	self thread play_crashing_loop();

	if( IsDefined( self.unloading ) )
	{
		while( IsDefined( self.unloading ) )
		{
			wait( 0.05 ); 
		}
	}

	if( !IsDefined( self ) )
	{
		return; 
	}

	self thread boat_crash_movement( point, dir );
}

boat_crash_movement( point, dir )
{
	self endon( "crash_move_done" );
	self endon( "death" );

//	self thread crash_collision_test();
	self CancelAIMove();
	self ClearVehGoalPos();	

	self SetPhysAcceleration( ( 0, 0, -50 ) );

	vel = self.velocity;
	dir = VectorNormalize( dir );
///	self SetVehVelocity( ( 0, 0, 0 ) );	

	ang_vel = self GetAngularVelocity();
//	ang_vel = ( 0, 0, 0 );
//	self SetAngularVelocity( ang_vel );
	
	torque = ( RandomIntRange( -5, -3 ), 0, ( RandomIntRange( 0, 100 ) < 50 ? -5 : 5 ) );
	
	self thread boat_crash_monitor( point, dir, 4 );

	while ( 1 )
	{
		ang_vel = self GetAngularVelocity();
		ang_vel += torque * 0.05;
		
		const max_angluar_vel = 360;
		if ( ang_vel[1] < max_angluar_vel * -1 )
		{
			ang_vel = ( ang_vel[0], max_angluar_vel * -1, ang_vel[2] );
		}
		else if ( ang_vel[1] > max_angluar_vel )
		{
			ang_vel = ( ang_vel[0], max_angluar_vel, ang_vel[2] );
		}

		self SetAngularVelocity( ang_vel );
		
		velocity = self.velocity;
		VEC_SET_X( velocity, velocity[0] * 0.975 );
		VEC_SET_Y( velocity, velocity[1] * 0.975 );		
		self SetVehVelocity( velocity );		

		wait( 0.05 );
	}	
}

boat_crash_monitor( point, dir, crash_time )
{
	self endon( "death" );
	
	wait( crash_time );

	self notify( "crash_move_done" );
	self crash_stop();
	self notify( "crash_done" );	
}

crash_stop()
{
	self endon("death");

	self SetPhysAcceleration( ( 0, 0, 0 ) );
	self SetRotorSpeed( 0 );
	
	speed = self GetSpeedMPH();
	while ( speed > 2 )
	{
		velocity = self.velocity;
		velocity *= 0.9;
		self SetVehVelocity( velocity );
		
		angular_velocity = self GetAngularVelocity();
		angular_velocity *= 0.9;
		self SetAngularVelocity( angular_velocity );

		speed = self GetSpeedMPH();

		wait( 0.05 );
	}

	self SetVehVelocity( ( 0, 0, 0 ) );
	self SetAngularVelocity( ( 0, 0, 0 ) );
	
	self veh_toggle_tread_fx( false );
	self veh_toggle_exhaust_fx( false );
	self vehicle_toggle_sounds( false );
}

crash_collision_test()
{
	self endon( "death" );
	
	self waittill( "veh_collision", velocity, normal );

	self helicopter_explode();
	self notify( "crash_move_done" );
	
	if ( normal[2] > 0.7 )
	{
		forward = AnglesToForward( self.angles );
		right = VectorCross( normal, forward );
		desired_forward = VectorCross( right, normal );
		self SetPhysAngles( VectorToAngles( desired_forward ) );
		
		self crash_stop();
		self notify( "crash_done" );
	}
	else
	{
		wait( 0.05 );
		self Delete();
	}
}

crash_path_check( node )
{
	 // find a crashnode on the current path
	 // this only works on ground info_vehicle_node vheicles. not dynamic helicopter script_origin paths. they have their own dynamic crashing.
	targ = node; 
	search_depth = 5;

	while( IsDefined( targ ) && search_depth >= 0 )
	{
		if( ( IsDefined( targ.detoured ) ) && ( targ.detoured == 0 ) )
		{
			detourpath = path_detour_get_detourpath( getvehiclenode( targ.target, "targetname" ) );
			if( IsDefined( detourpath ) && IsDefined( detourpath.script_crashtype ) )
			{
	 			return true; 
	 		}
		}
		if( IsDefined( targ.target ) )
		{
			// Edited for the case of nodes targetting eachother for looping paths 1/30/08 TFlame
			targ1 = getvehiclenode( targ.target, "targetname" );
			if (IsDefined(targ1) && IsDefined(targ1.target) && IsDefined(targ.targetname) && targ1.target == targ.targetname)
			{
				return false;
			}
			else if (IsDefined(targ1) && targ1 == node) // circular case -AP 1/15/09
			{
				return false;
			}
			else 
			{
				targ = targ1;
			}
			
		}
		else
		{
			targ = undefined; 
		}

		search_depth--;
	}
	return false; 

}

death_firesound( sound )
{
	self thread play_loop_sound_on_tag( sound, undefined, false );
	self waittill_any( "fire_extinguish", "stop_crash_loop_sound" );
	if ( !IsDefined( self ) )
	{
		return;
	}
	self notify( "stop sound" + sound );
}

death_fx()
{
	 // going to use vehicletypes for identifying a vehicles association with effects.
	 // will add new vehicle types if vehicle is different enough that it needs to use
	 // different effect. also handles the sound
	if( self isdestructible() )
	{
		return;
	}
	level notify( "vehicle_explosion", self.origin );
	self explode_notify_wrapper();

// commented out until I get multiple deathFx support in -AP 1/14/09
//	for( i = 0; i < level.vehicle_death_fx[ type ].size; i++ )
//	{
		struct = build_death_fx( self.deathfx, self.deathfxtag, self.deathfxsound  );//, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString )
		thread death_fx_thread( struct );
//	}
}

death_fx_thread( struct )
{
	assert( IsDefined( struct ) );
	if( IsDefined( struct.waitDelay ) )
	{
		if( struct.waitDelay >= 0 )
		{
			wait struct.waitDelay; 
		}
		else
		{
			self waittill( "death_finished" );
		}
	}
	
	if ( !IsDefined( self ) )
	{
		// self may have been removed during the wait
		return;
	}
	
	if ( ( IS_HELICOPTER( self ) ||  IS_PLANE( self ) ) && do_scripted_crash() )
	{
		// helicopter swap out to a new model that crashes, so the kill_fx is played in helicopter_crash_move()
		self.death_fx_struct = struct;
		return;
	}

	if( IsDefined( struct.notifyString ) )
	{
		self notify( struct.notifyString );
	}

	eModel = get_dummy();
	if( IsDefined( struct.effect ) )
	{
		if( ( struct.bEffectLooping ) && ( !IsDefined( self.delete_on_death ) ) )
		{
			if( IsDefined( struct.tag ) )
			{
				if( ( IsDefined( struct.stayontag ) ) && ( struct.stayontag == true ) )
				{
					thread loop_fx_on_vehicle_tag( struct.effect, struct.delay, struct.tag );
				}
				else
				{
					thread playLoopedFxontag( struct.effect, struct.delay, struct.tag );
				}
			}
			else
			{
				forward = ( eModel.origin + ( 0, 0, 100 ) ) - eModel.origin; 
				playfx( struct.effect, eModel.origin, forward );
			}
		}
		else if( IsDefined( struct.tag ) )
		{
			if ( IsDefined(self.modeldummyon) && self.modeldummyon )
			{
				playfxontag( struct.effect, deathfx_ent(), struct.tag );
			}
			else
			{
				playfxontag( struct.effect, self, struct.tag );
			}
		}
		else
		{
			forward = ( eModel.origin + ( 0, 0, 100 ) ) - eModel.origin; 
			playfx( struct.effect, eModel.origin, forward );
		}
	}

	if( ( IsDefined( struct.sound ) ) && ( !IsDefined( self.delete_on_death ) ) )
	{
		if( struct.bSoundlooping )
		{
			thread death_firesound( struct.sound );
		}
		else
		{
			self play_sound_in_space( struct.sound );
		}
	}
}

build_death_fx( effect, tag, sound, bEffectLooping, delay, bSoundlooping, waitDelay, stayontag, notifyString )
{
	if( !IsDefined( bSoundlooping ) )
	{
		bSoundlooping = false; 
	}
	if( !IsDefined( bEffectLooping ) )
	{
		bEffectLooping = false; 
	}
	if( !IsDefined( delay ) )
	{
		delay = 1; 
	}
	struct = spawnstruct();
	struct.effect = effect;
	struct.tag = tag; 
	struct.sound = sound; 
	struct.bSoundlooping = bSoundlooping; 
	struct.delay = delay; 
	struct.waitDelay = waitDelay; 
	struct.stayontag = stayontag; 
	struct.notifyString = notifyString; 
	struct.bEffectLooping = bEffectLooping; 
	return struct; 
}

death_make_badplace( type )
{
	if ( !IsDefined( level.vehicle_death_badplace[ type ] ) )
	{
		return;
	}

	struct = level.vehicle_death_badplace[ type ];
	if ( IsDefined( struct.delay ) )
	{
		wait struct.delay;
	}

	if ( !IsDefined( self ) )
	{
		return;
	}

	BadPlace_Cylinder( "vehicle_kill_badplace", struct.duration, self.origin, struct.radius, struct.height, struct.team1, struct.team2 );
}

death_jolt( type )
{
	self endon( "death" );

	if ( is_true( self.ignore_death_jolt ) )
	{
		return;
	}
	
	old_dontfreeme = self.dontfreeme;
	
	self JoltBody( ( self.origin + ( 23, 33, 64 ) ), 3 );
	
	if ( IsDefined( self.death_anim ) )
	{
		self AnimScripted( "death_anim", self.origin, self.angles, self.death_anim, "normal", %root, 1, 0 );
		self waittillmatch( "death_anim", "end" );
	}
	else if( !IsDefined( self.destructibledef ) )
	{
		if( self.isphysicsvehicle )
		{
			num_launch_multiplier = 1;
			
			if( IS_TANK( self ))
			{
				num_launch_multiplier = 0.1;	
			}
			
			
			self LaunchVehicle( (0, 0, 250) * num_launch_multiplier, (RandomFloatRange(5, 10), RandomFloatRange(-5, 5), 0), true, false, true );
		}
	}
	
	wait 2;
	self.dontfreeme = old_dontfreeme;
}

deathrollon()
{
	if( self.health > 0 )
	{
		self.rollingdeath = 1; 
	}
}

deathrolloff()
{
	self.rollingdeath = undefined; 
	self notify( "deathrolloff" );
}

loop_fx_on_vehicle_tag( effect, loopTime, tag )
{
	assert( IsDefined( effect ) );
	assert( IsDefined( tag ) );
	assert( IsDefined( loopTime ) );

	self endon( "stop_looping_death_fx" );

	while( IsDefined( self ) )
	{
		playfxontag( effect, deathfx_ent(), tag );
		wait loopTime; 
	}
}

deathfx_ent()
{
	if ( !IsDefined( self.deathfx_ent ) )
	{
		ent = spawn( "script_model", ( 0, 0, 0 ) );
		emodel = get_dummy();
		ent setmodel( self.model );
		ent.origin = emodel.origin;
		ent.angles = emodel.angles;
		ent notsolid();
		ent hide();
		ent linkto( emodel );
		self.deathfx_ent = ent;
	}
	else
	{
		self.deathfx_ent setmodel( self.model );
	}
	return self.deathfx_ent;
}

death_cleanup_level_variables()
{
	script_linkname = self.script_linkname;	
	targetname = self.targetname;	
	
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	if ( IsDefined( script_linkname ) )
	{
		ArrayRemoveValue( level.vehicle_link[ script_linkname ], self );
	}

	if( IsDefined( self.script_VehicleSpawngroup ) )
	{
		if ( IsDefined( level.vehicle_SpawnGroup[ self.script_VehicleSpawngroup ] ) )
		{
			ArrayRemoveValue( level.vehicle_SpawnGroup[ self.script_VehicleSpawngroup ], self );
			ArrayRemoveValue( level.vehicle_SpawnGroup[ self.script_VehicleSpawngroup ], undefined );			
		}
	}

	if( IsDefined( self.script_VehicleStartMove ) )
	{
		ArrayRemoveValue( level.vehicle_StartMoveGroup[ self.script_VehicleStartMove ], self );
	}

	if( IsDefined( self.script_vehicleGroupDelete ) )
	{
		ArrayRemoveValue( level.vehicle_DeleteGroup[ self.script_vehicleGroupDelete ], self );
	}
}

death_cleanup_riders()
{
	// if vehicle is gone then delete the ai here.
	if ( IsDefined( self.riders ) )
	{
		for ( j = 0; j < self.riders.size; j++ )
		{
			if ( IsDefined( self.riders[ j ] ) )
			{
				self.riders[ j ] delete();
			}
		}
	}

	if ( is_corpse( self ) )
	{
		self.riders = [];
	}
}

death_radius_damage()
{	
	if( !IsDefined( self ) || self.radiusdamageradius <= 0 )
	{
		return;
	}
	
 	wait(0.05);

	if ( IsDefined( self) )
	{
		self RadiusDamage( self.origin + (0,0,15), self.radiusdamageradius, self.radiusdamagemax, self.radiusdamagemin, self, "MOD_EXPLOSIVE" );
	}
}


death_update_crash( point, dir )
{
	if( !IsDefined( self.destructibledef ) )
	{
		if ( IsDefined( self.script_crashtypeoverride ) )
		{
			crashtype = self.script_crashtypeoverride; 
		}
		else if ( IS_PLANE( self ) )
		{
			crashtype = "aircraft"; 
		}
		else if ( IS_HELICOPTER( self ) )
		{
			crashtype = "helicopter"; 
		}
		else if ( IS_BOAT( self ) )
		{
			crashtype = "boat";	
		}
		else if ( IsDefined( self.currentnode ) && crash_path_check( self.currentnode ) )
		{
			crashtype = "none"; 
		}
		else
		{
			crashtype = "tank";  // tanks used to be the only vehicle that would stop. legacy nonsense from CoD1
		}
	
		if( crashtype == "aircraft" )
		{
			self thread aircraft_crash( point, dir );
		}

		if( crashtype == "helicopter" )
		{
			if( IsDefined(self.script_nocorpse) )
			{
				// GLocke - Does not drop a physics script model on death
				self thread helicopter_explode();
			}
			else
			{
				self thread helicopter_crash( point, dir );
			}
		}
		
		if ( crashtype == "boat" )
		{
			self thread boat_crash( point, dir );
		}
	
		if( crashtype == "tank" )
		{
			if( !IsDefined( self.rollingdeath ) )
			{
				self vehicle_setspeed( 0, 25, "Dead" );
			}
			else
			{
				// dpg 3/12/08 removed this. if you need it for something, let someone know
				//self vehicle_setspeed( 8, 25, "Dead rolling out of path intersection" );
				self waittill( "deathrolloff" );
				self vehicle_setspeed( 0, 25, "Dead, finished path intersection" );
			}
			
			wait .4;
			
			if ( IsDefined( self ) && !is_corpse( self ) )
			{
				self vehicle_setspeed( 0, 10000, "deadstop" );
	
				self notify( "deadstop" );
				if ( !IsDefined( self.dontDisconnectPaths ) )
				{
					self vehicle_disconnectpaths_wrapper();
				}
				
				if( ( IsDefined( self.tankgetout ) ) && ( self.tankgetout > 0 ) )
				{
					// tankgetout will never get notified if there are no guys getting out
					self waittill( "animsdone" ); 
				}
			}
		}
	}
}

waittill_crash_done_or_stopped()
{
	self endon( "death" );
	
	if( IsDefined( self ) && ( IS_PLANE(self) || IS_BOAT( self ) ) )
	{
		if( ( IsDefined( self.crashing ) ) && ( self.crashing == true ) )
		{
			self waittill( "crash_done" );
		}
	}
	else
	{
		wait 0.2;	// don't check the velocity right away because we might have been launched
		
		if( self.isphysicsvehicle )
		{
			self ClearVehGoalPos();
			self CancelAIMove();
			//GLocke 2/16/10 - just wait for physics vehicles to get close to 0
			while( IsDefined( self.velocity ) && LengthSquared( self.velocity ) > 1.0 )
			{
				wait( 0.3 );
			}
		}
		else
		{
			while( IsDefined( self ) && self GetSpeedMPH() > 0 )
			{
				wait( 0.3 );
			}
		}
	}
}

precache_death_model_wrapper( death_model_name )
{
	if (!IsDefined(self.script_string) || (IsDefined(self.script_string) && self.script_string != "no_deathmodel") )
	{
		PrecacheModel( death_model_name );
	}			
}

#define DAMAGE_FILTER_MIN_TIME 500
vehicle_damage_filter_damage_watcher( heavy_damage_threshold )
{
	self endon( "death" );
	self endon( "exit_vehicle" );
	self endon( "end_damage_filter" );	
	
	if ( !IsDefined( heavy_damage_threshold ) )
	{
		heavy_damage_threshold = 100;
	}
	
	while ( 1 )
	{	
		self waittill( "damage",  damage, attacker, direction, point, type, tagName, modelName, partname, weaponName );
		
		//IPrintLn( "damage: " + damage );
		//self ClearDamageIndicator();
		Earthquake( 0.25, 0.15, self.origin, 512, self );
		level.player PlayRumbleOnEntity( "damage_light" );		
		
		time = GetTime();
		if ( ( time - level.n_last_damage_time ) > DAMAGE_FILTER_MIN_TIME )
		{	
			level.n_hud_damage = true;
				
			if ( damage > heavy_damage_threshold )
			{
				rpc( "clientscripts/_vehicle", "damage_filter_heavy" );
				level.player playsound ( "veh_damage_filter_heavy" );
			}
			else
			{
				rpc( "clientscripts/_vehicle", "damage_filter_light" );		
				level.player playsound ( "veh_damage_filter_light" );				
			}
			
			level.n_last_damage_time = GetTime();							
		}
	}
}

vehicle_damage_filter_exit_watcher()
{
	self waittill_any( "exit_vehicle", "death", "end_damage_filter" );

	rpc( "clientscripts/_vehicle", "damage_filter_disable" );
	rpc( "clientscripts/_vehicle", "damage_filter_off" );
	
	self.damage_filter_init = undefined;	
	
	if ( IsDefined( level.player.save_visionset ) )
	{
		level.player VisionSetNaked( level.player.save_visionset, 0 );
	}
}

vehicle_damage_filter( vision_set, heavy_damage_threshold, filterid = 0, b_use_player_damage = false )
{
	self endon( "death" );
	self endon( "exit_vehicle" );
	self endon( "end_damage_filter" );	

	if ( !IsDefined( self.damage_filter_init ) )
	{
		rpc( "clientscripts/_vehicle", "init_damage_filter", filterid );		
		self.damage_filter_init = true;
	}
	else
	{
		rpc( "clientscripts/_vehicle", "damage_filter_enable", 0, filterid );		
	}
	
	if ( IsDefined( vision_set ) )
	{
		level.player.save_visionset = level.player GetVisionSetNaked();
		level.player VisionSetNaked( vision_set, 0.5 );
	}
	
	level.n_hud_damage = false;	
	level.n_last_damage_time = GetTime();		
	
	damagee = ( IS_TRUE( b_use_player_damage ) ? level.player : self );
	
	damagee thread vehicle_damage_filter_damage_watcher( heavy_damage_threshold );
	damagee thread vehicle_damage_filter_exit_watcher();
	
	while ( 1 )
	{
		if ( IS_TRUE( level.n_hud_damage ) )
		{
			time = GetTime();
			if ( ( time - level.n_last_damage_time ) > DAMAGE_FILTER_MIN_TIME )
			{
				rpc( "clientscripts/_vehicle", "damage_filter_off" );				
				level.n_hud_damage = false;
			}
		}
		
		wait 0.05;
	}	
}
