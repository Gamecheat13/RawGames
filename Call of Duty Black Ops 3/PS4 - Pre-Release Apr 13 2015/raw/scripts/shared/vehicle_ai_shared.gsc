#using scripts\codescripts\struct;

#using scripts\shared\flag_shared;
#using scripts\shared\math_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\system_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       



#namespace vehicle_death;

function autoexec __init__sytem__() {     system::register("vehicle_death",&__init__,undefined,undefined);    }

// _vehicle_death.gsc - all things related to vehicles dying

// Utility rain functions:


#using_animtree( "generic" );

function __init__()
{
	SetDvar( "debug_crash_type", -1 );
	
	//TODO T7 - function port
	/*if( IsAssetLoaded( "fx", "_t6/trail/fx_trail_heli_killstreak_engine_smoke" ) )
	{
		//level.heli_hit_fx =
		level.heli_crash_smoke_trail_fx = "_t6/trail/fx_trail_heli_killstreak_engine_smoke";
	}*/
}

function main()
{
	self endon( "nodeath_thread" );

	while ( isdefined( self ) )
	{
		// waittill death twice. in some cases the vehicle dies and does a bunch of stuff. then it gets deleted. which it then needs to do more stuff
		self waittill( "death", attacker, damageFromUnderneath, weapon, point, dir );

		if ( isdefined( self.script_deathflag ) )
		{
			level flag::set( self.script_deathflag );
		}

		if ( !isdefined( self.delete_on_death ) )
		{
			self thread play_death_audio();
		}

		if ( !isdefined( self ) )
		{
			return;
		}

		self death_cleanup_level_variables();

		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

		if ( vehicle::is_corpse( self ) )
		{
			// Cleanup Riders
			if ( !( isdefined( self.dont_kill_riders ) && self.dont_kill_riders ) )
			{
				self death_cleanup_riders();
			}

			// kills some destructible fxs
			self notify( "delete_destructible" );

			// Done here
			return;
		}

		self vehicle::lights_off();
		
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

		// Run vehicle death thread
		if ( isdefined( level.vehicle_death_thread[ self.vehicletype ] ) )
		{
			thread [[ level.vehicle_death_thread[ self.vehicletype ] ]]();
		}

		if ( !isdefined( self.delete_on_death ) )
		{
			// Do radius damage
			thread death_radius_damage();
		}

		is_aircraft = (  ( isdefined(self.vehicleclass) && (self.vehicleclass == "plane") ) || ( isdefined(self.vehicleclass) && (self.vehicleclass == "helicopter" ) ) );

		if ( !isdefined( self.destructibledef ) )
		{
			if ( !is_aircraft && !( self.vehicleType == "horse" || self.vehicleType == "horse_player" || self.vehicleType == "horse_player_low" || self.vehicleType == "horse_low" || self.vehicleType == "horse_axis" ) && isdefined( self.deathmodel ) && self.deathmodel != "" )
			{
				self thread set_death_model( self.deathmodel, self.modelswapdelay );
			}

			// Do death_fx if it has not been mantled
			if ( !isdefined( self.delete_on_death ) && ( !isdefined( self.mantled ) || !self.mantled ) && !isdefined( self.nodeathfx ) )
			{
				thread death_fx();
			}

			if ( isdefined( self.delete_on_death ) )
			{
				{wait(.05);};

				if ( self.disconnectPathOnStop === true )
				{
					self DisconnectPaths();
				}

				if ( !( isdefined( self.no_free_on_death ) && self.no_free_on_death ) )
				{
					self freevehicle();
					self.isacorpse = true;

					{wait(.05);};

					if ( isdefined( self ) )
					{
						self notify( "death_finished" );
						self delete();
					}
				}

				continue;
			}
		}

//		// makes riders blow up
//		if ( isdefined( self.riders ) && self.riders.size > 0 )
//		{
//			vehicle_aianim::blowup_riders();
//		}

		// Place a bad place cylinder if specified
		thread death_make_badplace( self.vehicletype );

		// Send vehicle type specific notify
		if ( isdefined( level.vehicle_deathnotify ) && isdefined( level.vehicle_deathnotify[ self.vehicletype ] ) )
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
		if ( isdefined( self.turretweapon ) && self.turretweapon != level.weaponNone)
		{
			self clearTurretTarget();
		}

		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -

		// Wait here until we're finished with a crash or rolling death
		self waittill_crash_done_or_stopped();

		if ( isdefined( self ) )
		{
			while ( isdefined( self ) && isdefined( self.dontfreeme ) )
			{
				wait( .05 );
			}

			// send notifies
			self notify( "stop_looping_death_fx" );
			self notify( "death_finished" );

			wait .05;

			if ( isdefined( self ) )
			{
				if ( vehicle::is_corpse( self ) )
				{
					continue;
				}

				if ( !isdefined( self ) )
				{
					continue;
				}

				// AE 2-18-09: if the player is using it, then spit them out or kill them before freeing the vehicle
				occupants = self GetVehOccupants();
				if ( isdefined( occupants ) && occupants.size )
				{
					for ( i = 0; i < occupants.size; i++ )
					{
						self usevehicle( occupants[i], 0 );
					}
				}

				if ( !( isdefined( self.no_free_on_death ) && self.no_free_on_death ) )
				{
					self freevehicle();
					self.isacorpse = true;
				}

				if ( self.modeldummyon )
				{
					self hide();
				}
			}
		}
	}
}

function do_scripted_crash()
{
	return !isdefined( self.do_scripted_crash ) || ( isdefined( self.do_scripted_crash ) && self.do_scripted_crash );
}

function play_death_audio()
{
	if ( isdefined ( self ) && ( isdefined(self.vehicleclass) && (self.vehicleclass == "helicopter" ) ) )
	{
		if ( !isdefined ( self.death_counter ) )
		{
			self.death_counter = 0;
		}
		if ( self.death_counter == 0 )
		{
			self.death_counter++;
			self playsound ( "exp_veh_helicopter_hit" );
		}
	}
}

function play_spinning_plane_sound()
{
	self playloopsound( "veh_drone_spin", .05 );
	level util::waittill_any( "crash_move_done", "death" );
	self stoploopsound( .02 );
}

function set_death_model( sModel, fDelay )
{
	assert( isdefined( sModel ) );

	if ( isdefined( fDelay ) && ( fDelay > 0 ) )
	{
		wait fDelay;
	}

	if ( !isdefined( self ) )
	{
		return;
	}

	if ( isdefined( self.deathmodel_attached ) )
	{
		return;
	}

	eModel = vehicle::get_dummy();
	if ( !isdefined( eModel ) )
	{
		return;
	}

	if ( !isdefined( eModel.death_anim ) && ( isdefined( eModel.animtree ) ) )
	{
		eModel ClearAnim( %root, 0 );
	}

	eModel SetModel( sModel );
	//TODO T7 - function port
	//eModel SetVehicleAttachments( 1 );
}


function aircraft_crash( point, dir )
{
	self.crashing = true;

	if ( isdefined( self.unloading ) )
	{
		while ( isdefined( self.unloading ) )
		{
			{wait(.05);};
		}
	}

	if ( !isdefined( self ) )
	{
		return;
	}

	self thread aircraft_crash_move( point, dir );
	self thread play_spinning_plane_sound();
}

function helicopter_crash( point, dir )
{
	self.crashing = true;
	self thread play_crashing_loop();

	if ( isdefined( self.unloading ) )
	{
		while ( isdefined( self.unloading ) )
		{
			{wait(.05);};
		}
	}

	if ( !isdefined( self ) )
	{
		return;
	}

	//self thread helicopter_crash_move( point, dir );
	self thread helicopter_crash_movement( point, dir );

}

function helicopter_crash_movement( point, dir )
{
	self endon( "crash_done" );

	self CancelAIMove();
	self ClearVehGoalPos();

	if ( isdefined( level.heli_crash_smoke_trail_fx ) )
	{
		if ( IsSubStr( self.vehicletype, "v78" ) )
		{
			playfxontag( level.heli_crash_smoke_trail_fx, self, "tag_origin" );
		}
		else if ( self.vehicletype == "drone_firescout_axis" || self.vehicletype == "drone_firescout_isi" )
		{
			playfxontag( level.heli_crash_smoke_trail_fx, self, "tag_main_rotor" );
		}
		else
		{
			playfxontag( level.heli_crash_smoke_trail_fx, self, "tag_engine_left" );
		}
	}

	crash_zones = struct::get_array( "heli_crash_zone", "targetname" );
	if ( crash_zones.size > 0  )
	{
		best_dist = 99999;
		best_idx = -1;

		if ( isdefined( self.a_crash_zones ) )
		{
			crash_zones = self.a_crash_zones;
		}

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
		if( isdefined( dir ) )
			dir = VectorNormalize( dir );	
		else
			dir = ( 1,0,0 );
		side_dir = VectorCross( dir, ( 0,0,1 ) );
		side_dir_mag = RandomFloatRange( -500, 500 );
		side_dir_mag += math::sign( side_dir_mag ) * 60;
		side_dir *= side_dir_mag;
		side_dir += ( 0,0,150 );

		self SetPhysAcceleration( ( RandomIntRange( -500, 500 ), RandomIntRange( -500, 500 ), -1000 ) );
		self SetVehVelocity( self.velocity + side_dir );
		self thread helicopter_crash_accel();
		if( isdefined( point ) )
			self thread helicopter_crash_rotation( point, dir );
		else
			self thread helicopter_crash_rotation( self.origin, dir );
	}

	//self thread helicopter_collision();
	self thread crash_collision_test();

	wait 15;

	// failsafe notify
	if ( IsDefined( self ) )
	{
		self notify( "crash_done" );
	}
}

function helicopter_crash_accel()
{
	self endon( "crash_done" );
	self endon( "crash_move_done" );
	self endon( "death" );

	if ( !isdefined( self.crash_accel ) )
	{
		self.crash_accel = RandomFloatRange( 50, 80 );
	}

	while ( isdefined( self ) )
	{
		self SetVehVelocity( self.velocity + AnglesToUp( self.angles ) * self.crash_accel );
		wait 0.1;
	}
}

function helicopter_crash_rotation( point, dir )
{
	self endon( "crash_done" );
	self endon( "crash_move_done" );
	self endon( "death" );

	start_angles = self.angles;
	start_angles = (start_angles[0] + 10, start_angles[1], start_angles[2]);	//RandomIntRange( -5, 5 ) );
	start_angles = (start_angles[0], start_angles[1], start_angles[2] + 10);	//RandomIntRange( -5, 5 ) );

	ang_vel = self GetAngularVelocity();
	ang_vel = ( 0, ang_vel[1] * RandomFloatRange( 2, 3 ), 0 );
	self SetAngularVelocity( ang_vel );

	point_2d = ( point[0], point[1], self.origin[2] );

	//DebugStar( self.origin, 1000, ( 1, 1, 1 ) );
	//DebugStar( point_2d, 1000, ( 1, 0, 0 ) );

	torque = ( 0, RandomIntRange( 90, 180 ), 0 );
	if ( self GetAngularVelocity()[1] < 0 )
	{
		torque *= -1;
	}

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

		{wait(.05);};
	}
}

function helicopter_crash_zone_accel( dir )
{
	self endon( "crash_done" );
	self endon( "crash_move_done" );

	torque = ( 0, RandomIntRange( 90, 150 ), 0 );
	ang_vel = self GetAngularVelocity();
	//ang_vel = ( 0, ang_vel[1], 0 );	// get rid of the pitch and roll
	//self SetAngularVelocity( ang_vel );
	torque *= math::sign( ang_vel[1] );

	/#
	if ( isdefined( self.crash_zone.height ) )
	{
		self.crash_zone.height = 0;
	}
#/

	// if you don't have any roll give it a little
	if ( Abs( self.angles[2] ) < 3.0 )
	{
		self.angles = ( self.angles[0], self.angles[1], RandomIntRange( 3, 6 ) * math::sign( self.angles[2] ) );
	}

	is_vtol = IsSubStr( self.vehicletype, "v78" );

	if ( is_vtol )
	{
		torque *= 0.3;
	}

	while ( isdefined( self ) )
	{
		assert( isdefined( self.crash_zone ) );

		dist = Distance2D( self.origin, self.crash_zone.origin );
		if ( dist < self.crash_zone.radius )
		{
			//if ( isdefined( self.crash_zone.angles ) )
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

		if ( is_vtol )
		{
			self.crash_vel *= 0.5;
		}

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

		max_angluar_vel = 200;
		if ( is_vtol )
		{
			max_angluar_vel = 100;
		}

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

function helicopter_collision()
{
	self endon( "crash_done" );

	while ( 1 )
	{
		self waittill( "veh_collision", velocity, normal );

		ang_vel = self GetAngularVelocity() * 0.5;
		self SetAngularVelocity( ang_vel );

		// bounce off walls
		if ( normal[2] < 0.7 )
		{
			self SetVehVelocity( self.velocity + normal * 70 );
		}
		else
		{
			//self.crash_accel *= 0.5;
			//self SetVehVelocity( self.velocity * 0.8 );
			//TODO T7 - function port
			//CreateDynEntAndLaunch( self.deathmodel, self.origin, self.angles, self.origin, self.velocity * 0.03, self.deathfx );

			self notify( "crash_done" );
		}
	}
}

function play_crashing_loop()
{
	ent = Spawn ( "script_origin", self.origin );
	ent linkto ( self );
	ent playloopsound ( "exp_heli_crash_loop" );
	self util::waittill_any ( "death", "snd_impact" );
	ent delete();

}
function helicopter_explode( delete_me )
{
	self endon( "death" );

	self vehicle::do_death_fx();

	if ( isdefined( delete_me ) && delete_me == true )
	{
		self Delete();
	}

	self thread set_death_model( self.deathmodel, self.modelswapdelay );
}

function aircraft_crash_move( point, dir )
{
	self endon( "crash_move_done" );
	self endon( "death" );

	self thread crash_collision_test();
	self ClearVehGoalPos();
	self CancelAIMove();
	self SetRotorSpeed( 0.2 );

	// swap to deathmodel here
	if ( isdefined( self ) && isdefined( self.vehicletype ) )
	{
		b_custom_deathmodel_setup = true;
		switch ( self.vehicletype )
		{

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
			{
				continue;
			}

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

	while ( isdefined( self ) )
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

		{wait(.05);};
	}
}

function delay_set_gravity( delay )
{
	self endon( "crash_move_done" );
	self endon( "death" );

	wait( delay );

	self SetPhysAcceleration( ( RandomIntRange( -1600, 1600 ), RandomIntRange( -1600, 1600 ), -1600 ) );
}

function helicopter_crash_move( point, dir )
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

		{wait(.05);};
	}
}


function boat_crash( point, dir )
{
	self.crashing = true;
	//	self thread play_crashing_loop();

	if ( isdefined( self.unloading ) )
	{
		while ( isdefined( self.unloading ) )
		{
			{wait(.05);};
		}
	}

	if ( !isdefined( self ) )
	{
		return;
	}

	self thread boat_crash_movement( point, dir );
}

function boat_crash_movement( point, dir )
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
	ang_vel = ( 0, 0, 0 );
	self SetAngularVelocity( ang_vel );

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
		velocity = (velocity[0] * 0.975, velocity[1], velocity[2]);
		velocity = (velocity[0], velocity[1] * 0.975, velocity[2]);
		self SetVehVelocity( velocity );

		{wait(.05);};
	}
}

function boat_crash_monitor( point, dir, crash_time )
{
	self endon( "death" );

	wait( crash_time );

	self notify( "crash_move_done" );
	self crash_stop();
	self notify( "crash_done" );
}

function crash_stop()
{
	self endon( "death" );

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

		{wait(.05);};
	}

	self SetVehVelocity( ( 0, 0, 0 ) );
	self SetAngularVelocity( ( 0, 0, 0 ) );

	self vehicle::toggle_tread_fx( false );
	self vehicle::toggle_exhaust_fx( false );
	self vehicle::toggle_sounds( false );
}

function crash_collision_test()
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
		{wait(.05);};
		self Delete();
	}
}

function crash_path_check( node )
{
	// find a crashnode on the current path
	// this only works on ground info_vehicle_node vheicles. not dynamic helicopter script_origin paths. they have their own dynamic crashing.
	targ = node;
	search_depth = 5;

	while ( isdefined( targ ) && search_depth >= 0 )
	{
		if ( ( isdefined( targ.detoured ) ) && ( targ.detoured == 0 ) )
		{
			detourpath = vehicle::path_detour_get_detourpath( getvehiclenode( targ.target, "targetname" ) );
			if ( isdefined( detourpath ) && isdefined( detourpath.script_crashtype ) )
			{
				return true;
			}
		}
		if ( isdefined( targ.target ) )
		{
			// Edited for the case of nodes targetting eachother for looping paths 1/30/08 TFlame
			targ1 = getvehiclenode( targ.target, "targetname" );
			if ( isdefined( targ1 ) && isdefined( targ1.target ) && isdefined( targ.targetname ) && targ1.target == targ.targetname )
			{
				return false;
			}
			else if ( isdefined( targ1 ) && targ1 == node ) // circular case -AP 1/15/09
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

function death_firesound( sound )
{
	self thread sound::loop_on_tag( sound, undefined, false );
	self util::waittill_any( "fire_extinguish", "stop_crash_loop_sound" );
	if ( !isdefined( self ) )
	{
		return;
	}
	self notify( "stop sound" + sound );
}

function death_fx()
{
	// going to use vehicletypes for identifying a vehicles association with effects.
	// will add new vehicle types if vehicle is different enough that it needs to use
	// different effect. also handles the sound
	if ( self vehicle::is_destructible() )
	{
		return;
	}

	self util::explode_notify_wrapper();

	if(isdefined(self.do_death_fx))
	{
		self [[self.do_death_fx]]();
	}
	else
	{
		self vehicle::do_death_fx();
	}
}


function death_make_badplace( type )
{
	if ( !isdefined( level.vehicle_death_badplace[ type ] ) )
	{
		return;
	}

	struct = level.vehicle_death_badplace[ type ];
	if ( isdefined( struct.delay ) )
	{
		wait struct.delay;
	}

	if ( !isdefined( self ) )
	{
		return;
	}

	badplace_box( "vehicle_kill_badplace", struct.duration, self.origin, struct.radius, "all" );
}

function death_jolt( type )
{
	self endon( "death" );

	if ( ( isdefined( self.ignore_death_jolt ) && self.ignore_death_jolt ) )
	{
		return;
	}

	self JoltBody( ( self.origin + ( 23, 33, 64 ) ), 3 );

	if ( isdefined( self.death_anim ) )
	{
		self AnimScripted( "death_anim", self.origin, self.angles, self.death_anim, "normal", %root, 1, 0 );
		self waittillmatch( "death_anim", "end" );
	}
	else // if ( !isdefined( self.destructibledef ) )
	{
		if ( self.isphysicsvehicle )
		{
			num_launch_multiplier = 1;

			if ( isdefined( self.physicslaunchdeathscale ) )
			{
				num_launch_multiplier = self.physicslaunchdeathscale;
			}
			
			self LaunchVehicle( (0, 0, 180) * num_launch_multiplier, (RandomFloatRange(5, 10), RandomFloatRange(-5, 5), 0), true, false, true );
		}
	}
}

function deathrollon()
{
	if ( self.health > 0 )
	{
		self.rollingdeath = 1;
	}
}

function deathrolloff()
{
	self.rollingdeath = undefined;
	self notify( "deathrolloff" );
}

function loop_fx_on_vehicle_tag( effect, loopTime, tag )
{
	assert( isdefined( effect ) );
	assert( isdefined( tag ) );
	assert( isdefined( loopTime ) );

	self endon( "stop_looping_death_fx" );

	while ( isdefined( self ) )
	{
		playfxontag( effect, deathfx_ent(), tag );
		wait loopTime;
	}
}

function deathfx_ent()
{
	if ( !isdefined( self.deathfx_ent ) )
	{
		ent = Spawn( "script_model", ( 0, 0, 0 ) );
		emodel = vehicle::get_dummy();
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

function death_cleanup_level_variables()
{
	script_linkname = self.script_linkname;
	targetname = self.targetname;

	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -
	if ( isdefined( script_linkname ) )
	{
		ArrayRemoveValue( level.vehicle_link[ script_linkname ], self );
	}

	if ( isdefined( self.script_VehicleSpawngroup ) )
	{
		if ( isdefined( level.vehicle_SpawnGroup[ self.script_VehicleSpawngroup ] ) )
		{
			ArrayRemoveValue( level.vehicle_SpawnGroup[ self.script_VehicleSpawngroup ], self );
			ArrayRemoveValue( level.vehicle_SpawnGroup[ self.script_VehicleSpawngroup ], undefined );
		}
	}

	if ( isdefined( self.script_VehicleStartMove ) )
	{
		ArrayRemoveValue( level.vehicle_StartMoveGroup[ self.script_VehicleStartMove ], self );
	}

	if ( isdefined( self.script_vehicleGroupDelete ) )
	{
		ArrayRemoveValue( level.vehicle_DeleteGroup[ self.script_vehicleGroupDelete ], self );
	}
}

function death_cleanup_riders()
{
	// if vehicle is gone then delete the ai here.
	if ( isdefined( self.riders ) )
	{
		for ( j = 0; j < self.riders.size; j++ )
		{
			if ( isdefined( self.riders[ j ] ) )
			{
				self.riders[ j ] delete();
			}
		}
	}

	if ( vehicle::is_corpse( self ) )
	{
		self.riders = [];
	}
}

function death_radius_damage()
{
	if ( self.abandoned === true )
	{
		return;
	}
	
	if ( !isdefined( self ) || self.radiusdamageradius <= 0 )
	{
		return;
	}

	{wait(.05);};

	if ( isdefined( self ) )
	{
		self RadiusDamage( self.origin + ( 0,0,15 ), self.radiusdamageradius, self.radiusdamagemax, self.radiusdamagemin, self, "MOD_EXPLOSIVE" );
	}
}


function death_update_crash( point, dir )
{
	if ( !isdefined( self.destructibledef ) )
	{
		if ( isdefined( self.script_crashtypeoverride ) )
		{
			crashtype = self.script_crashtypeoverride;
		}
		else if ( ( isdefined(self.vehicleclass) && (self.vehicleclass == "plane") ) )
		{
			crashtype = "aircraft";
		}
		else if ( ( isdefined(self.vehicleclass) && (self.vehicleclass == "helicopter" ) ) )
		{
			crashtype = "helicopter";
		}
		else if ( ( isdefined(self.vehicleclass) && (self.vehicleclass == "boat" ) ) )
		{
			crashtype = "boat";
		}
		else if ( isdefined( self.currentnode ) && crash_path_check( self.currentnode ) )
		{
			crashtype = "none";
		}
		else
		{
			crashtype = "tank";  // tanks used to be the only vehicle that would stop. legacy nonsense from CoD1
		}

		if ( crashtype == "aircraft" )
		{
			self thread aircraft_crash( point, dir );
		}
		else if ( crashtype == "helicopter" )
		{
			if ( isdefined( self.script_nocorpse ) )
			{
				// GLocke - Does not drop a physics script model on death
				self thread helicopter_explode();
			}
			else
			{
				self thread helicopter_crash( point, dir );
			}
		}
		else if ( crashtype == "boat" )
		{
			self thread boat_crash( point, dir );
		}
		else if ( crashtype == "tank" )
		{
			if ( !isdefined( self.rollingdeath ) )
			{
				self vehicle::set_speed( 0, 25, "Dead" );
			}
			else
			{
				// dpg 3/12/08 removed this. if you need it for something, let someone know
				//self vehicle::set_speed( 8, 25, "Dead rolling out of path intersection" );
				self waittill( "deathrolloff" );
				self vehicle::set_speed( 0, 25, "Dead, finished path intersection" );
			}

			wait .4;

			if ( isdefined( self ) && !vehicle::is_corpse( self ) )
			{
				self vehicle::set_speed( 0, 10000, "deadstop" );

				self notify( "deadstop" );
				if ( self.disconnectPathOnStop === true )
				{
					self DisconnectPaths();
				}

				if ( ( isdefined( self.tankgetout ) ) && ( self.tankgetout > 0 ) )
				{
					// tankgetout will never get notified if there are no guys getting out
					self waittill( "animsdone" );
				}
			}
		}
	}
}

function waittill_crash_done_or_stopped()
{
	self endon( "death" );

	if ( isdefined( self ) && ( ( isdefined(self.vehicleclass) && (self.vehicleclass == "plane") ) || ( isdefined(self.vehicleclass) && (self.vehicleclass == "boat" ) ) ) )
	{
		if ( ( isdefined( self.crashing ) ) && ( self.crashing == true ) )
		{
			self waittill( "crash_done" );
		}
	}
	else
	{
		wait 0.2;	// don't check the velocity right away because we might have been launched

		if ( self.isphysicsvehicle )
		{
			self ClearVehGoalPos();
			self CancelAIMove();
			//GLocke 2/16/10 - just wait for physics vehicles to get close to 0
			stable_count = 0;
			while( stable_count < 3 )
			{
				if ( isdefined( self.velocity ) && LengthSquared( self.velocity ) > 1.0 )
				{
					stable_count = 0;
				}
				else
				{
					stable_count++;
				}
				wait( 0.3 );
			}
			self DisconnectPaths();
		}
		else
		{
			while ( isdefined( self ) && self GetSpeedMPH() > 0 )
			{
				wait( 0.3 );
			}
		}
	}
}


function vehicle_damage_filter_damage_watcher( driver, heavy_damage_threshold )
{
	self endon( "death" );
	self endon( "exit_vehicle" );
	self endon( "end_damage_filter" );

	if ( !isdefined( heavy_damage_threshold ) )
	{
		heavy_damage_threshold = 100;
	}

	while ( 1 )
	{
		self waittill( "damage",  damage, attacker, direction, point, type, tagName, modelName, partname, weapon );

		//IPrintLn( "damage: " + damage );
		//self ClearDamageIndicator();
		Earthquake( 0.25, 0.15, self.origin, 512, self );
		driver PlayRumbleOnEntity( "damage_light" );

		time = GetTime();
		if ( ( time - level.n_last_damage_time ) > 500 )
		{
			level.n_hud_damage = true;

			if ( damage > heavy_damage_threshold )
			{
				//rpc( "scripts/_vehicle", "damage_filter_heavy" );
				driver playsound ( "veh_damage_filter_heavy" );
			}
			else
			{
				//rpc( "scripts/_vehicle", "damage_filter_light" );
				driver playsound ( "veh_damage_filter_light" );
			}

			level.n_last_damage_time = GetTime();
		}
	}
}

function vehicle_damage_filter_exit_watcher( driver )
{
	self util::waittill_any( "exit_vehicle", "death", "end_damage_filter" );

	//rpc( "scripts/_vehicle", "damage_filter_disable" );
	//rpc( "scripts/_vehicle", "damage_filter_off" );

	//self.damage_filter_init = undefined;

	//if ( isdefined( driver.save_visionset ) )
	//{
	//	//TODO T7 - convert to use manager
	//	driver VisionSetNaked( driver.save_visionset, 0 );
	//	#endif
	//}
}

function vehicle_damage_filter( vision_set, heavy_damage_threshold, filterid = 0, b_use_player_damage = false )
{
	self endon( "death" );
	self endon( "exit_vehicle" );
	self endon( "end_damage_filter" );
	
	driver = self GetSeatOccupant( 0 );

	if ( !isdefined( self.damage_filter_init ) )
	{
		//rpc( "scripts/_vehicle", "init_damage_filter", filterid );
		self.damage_filter_init = true;
	}
	else
	{
		//rpc( "scripts/_vehicle", "damage_filter_enable", 0, filterid );
	}

	if ( isdefined( vision_set ) )
	{
		//TODO T7 - convert to use manager
		/*level.player.save_visionset = level.player GetVisionSetNaked();
		level.player VisionSetNaked( vision_set, 0.5 );*/
	}

	level.n_hud_damage = false;
	level.n_last_damage_time = GetTime();

	damagee = ( ( isdefined( b_use_player_damage ) && b_use_player_damage ) ? driver : self );

	damagee thread vehicle_damage_filter_damage_watcher( driver, heavy_damage_threshold );
	damagee thread vehicle_damage_filter_exit_watcher( driver );

	while ( 1 )
	{
		if ( ( isdefined( level.n_hud_damage ) && level.n_hud_damage ) )
		{
			time = GetTime();
			if ( ( time - level.n_last_damage_time ) > 500 )
			{
				//rpc( "scripts/_vehicle", "damage_filter_off" );
				level.n_hud_damage = false;
			}
		}

		{wait(.05);};
	}
}

// self == vehicle
function play_damage_fx_on_tag( tag, effect, sound )
{	
	if ( !isdefined( self.damage_fx ) )
	{
		self.damage_fx = [];
	}

	if( isdefined( self.damage_fx[ tag ] ) )
	{
		if( self.damage_fx[ tag ].effect == effect )
		{
			// already playing
			return;
		}
		self.damage_fx[ tag ] delete();
	}
	
	ent = Spawn( "script_model", ( 0, 0, 0 ) );
	ent SetModel( "tag_origin" );
	ent.origin = self GetTagOrigin( tag );
	ent.angles = self GetTagAngles( tag );
	ent NotSolid();
	ent Hide();
	ent LinkTo( self, tag );
	ent.effect = effect;
	playfxontag( effect, ent, "tag_origin" );

	if ( isdefined( sound ) && sound != "" )
	{
		ent.sound = sound;
		ent playsound( sound );
	}

	self.damage_fx[ tag ] = ent;
}

// self == vehicle
function stop_damage_fx_on_tag( tag )
{
	if ( isdefined( self.damage_fx ) && isdefined( self.damage_fx[ tag ] ) )
	{
		self.damage_fx[ tag ] delete();
	}
}

// self == vehicle
function cleanup_fx()
{
	if( isdefined( self.damage_fx ) )
	{
		foreach( damage_fx in self.damage_fx )
		{
			damage_fx delete();
		}

		self.damage_fx = undefined;
	}
	
	if( isdefined( self.stun_fx ) )
	{
		self.stun_fx delete();
	}
}

// self == vehicle
function flipping_shooting_death( attacker, hitDir )
{
	// do we need this?
	if( isdefined( self.delete_on_death ) )
	{
		if ( isdefined( self ) )
		{
			self vehicle_death::cleanup_fx();
			self delete();
		}
		
		return;
	}
	
	if ( !isdefined( self ) )
	{
		return;
	}
	
	self endon( "death" ); //quit thread if deleted
	
	self vehicle_death::death_cleanup_level_variables();			
	
	self DisableAimAssist();
	
	self vehicle_death::death_fx();
	self thread vehicle_death::death_radius_damage();
	self thread vehicle_death::set_death_model( self.deathmodel, self.modelswapdelay );
	
	self vehicle::toggle_tread_fx( false );
	self vehicle::toggle_exhaust_fx( false );
	self vehicle::toggle_sounds( false );
	self vehicle::lights_off();
	self thread flipping_shooting_crash_movement( attacker, hitDir );
	
	self vehicle_death::cleanup_fx();
	
	self waittill( "crash_done" );
	
	// A dynEnt will be spawned in the collision thread when it hits the ground and "crash_done" notify will be sent
	self delete();
}

function flipping_shooting_crash_movement( attacker, hitdir )
{
	self endon( "crash_done" );
	self endon( "death" );
	
	self CancelAIMove();
	self ClearVehGoalPos();	
	self ClearLookAtEnt();
	
	self SetPhysAcceleration( ( 0, 0, -1000 ) );
	self.vehcheckforpredictedcrash = true; // code field to get veh_predictedcollision notify
	
	if( !isdefined( hitdir ) )
	{
		hitdir = (1,0,0);
	}
	
	hitdir = VectorNormalize( hitdir );
	
	new_vel = self.velocity;
	
	self.crash_style = GetDvarInt( "debug_crash_type" );
	if( self.crash_style == -1 )
	{
		self.crash_style = RandomInt( 3 );
	}
	
	if( self.crash_style == 0 )	// plane style crash
	{
		forward = AnglesToForward( self.angles );
		forward_mag = RandomFloatRange( 0, 300 );
		forward_mag += math::sign( forward_mag ) * 400;
		forward *= forward_mag;
		
		new_vel = forward + (self.velocity * 0.2);
		
		ang_vel = self GetAngularVelocity();
		
		yaw_vel = RandomFloatRange( 0, 130 ) * math::sign( ang_vel[1] );
		yaw_vel += math::sign( yaw_vel ) * 20;
		
		ang_vel = ( RandomFloatRange( -1, 1 ), yaw_vel, 0 );
		
		// setup the roll to look correct
		roll_amount = ( abs( ang_vel[1] ) / 150.0 ) * 30.0;
		if( ang_vel[1] > 0 )
		{
			roll_amount = -roll_amount;
		}
	
		self.angles = ( self.angles[0], self.angles[1], roll_amount );
		ang_vel = ( ang_vel[0], ang_vel[1], roll_amount * 0.9 );
		
		// set how much of the forward velocity to rotate when the vehicle rotates, more like a plane
		self.velocity_rotation_frac = 1.0;//RandomFloatRange( 0.95, 0.99 );
		
		self.crash_accel = RandomFloatRange( 65, 90 );
	}
	else if( self.crash_style == 1 )	// barrel rolling plane style
	{
		forward = AnglesToForward( self.angles );
		forward_mag = RandomFloatRange( 0, 250 );
		forward_mag += math::sign( forward_mag ) * 300;
		forward *= forward_mag;
		
		new_vel = forward + (0,0,70);
		
		ang_vel = self GetAngularVelocity();
		yaw_vel = RandomFloatRange( 0, 60 ) * math::sign( ang_vel[1] );
		yaw_vel += math::sign( yaw_vel ) * 30;
		
		roll_vel = RandomFloatRange( -200, 200 );
		roll_vel += math::sign( roll_vel ) * 300;
		ang_vel = ( RandomFloatRange( -5, 5 ), yaw_vel, roll_vel );
	
		// set how much of the forward velocity to rotate when the vehicle rotates, more like a plane
		self.velocity_rotation_frac = 1.0;//RandomFloatRange( 0.95, 0.99 );
		
		self.crash_accel = RandomFloatRange( 145, 210 );
		
		self SetPhysAcceleration( ( 0, 0, -250 ) );
	}
	else	// other random crash
	{
		side_dir = VectorCross( hitdir, (0,0,1) );
		side_dir_mag = RandomFloatRange( -280, 280 );
		side_dir_mag += math::sign( side_dir_mag ) * 150;
		side_dir *= side_dir_mag;
		
		forward = AnglesToForward( self.angles );
		forward_mag = RandomFloatRange( 0, 300 );
		forward_mag += math::sign( forward_mag ) * 30;
		forward *= forward_mag;
		
		new_vel = (self.velocity * 1.2) + forward + side_dir + (0,0,50);
		
		ang_vel = self GetAngularVelocity();
		ang_vel = ( ang_vel[0] * 0.3, ang_vel[1], ang_vel[2] * 1.2 );
		
		yaw_vel = RandomFloatRange( 0, 130 ) * math::sign( ang_vel[1] );
		yaw_vel += math::sign( yaw_vel ) * 50;
		
		ang_vel += ( RandomFloatRange( -5, 5 ), yaw_vel, RandomFloatRange( -18, 18 ) );
		
		// set how much of the forward velocity to rotate when the vehicle rotates, more like a plane
		self.velocity_rotation_frac = RandomFloatRange( 0.3, 0.99 );
		
		self.crash_accel = RandomFloatRange( 65, 90 );
	}
	
	self SetVehVelocity( new_vel );
	self SetAngularVelocity( ang_vel );
	
	if( !isdefined( self.off ) )
	{
		self thread flipping_shooting_crash_accel();
	}
	self thread vehicle_ai::nudge_collision();
	
	//drone death sounds JM - play 1 shot hit, turn off main loop, thread dmg loop
	self playsound("veh_wasp_dmg_hit");
	self vehicle::toggle_sounds( 0 );
	
	if( !isdefined( self.off ) )
	{
		self thread flipping_shooting_dmg_snd();
	}

	wait 0.1;
	
	if( RandomInt( 100 ) < 40 && !isdefined( self.off ) )
	{
		self thread vehicle_ai::fire_for_time( RandomFloatRange( 0.7, 2.0 ) );
	}
	
	wait 15;
	
	// failsafe notify
	self notify( "crash_done" );
}

function flipping_shooting_dmg_snd()
{
	dmg_ent = Spawn("script_origin", self.origin);
	dmg_ent linkto (self);
	dmg_ent PlayLoopSound ("veh_wasp_dmg_loop");
	self util::waittill_any("crash_done", "death");
	dmg_ent stoploopsound(1);
	wait (2);
	dmg_ent delete();
}

function flipping_shooting_crash_accel()
{
	self endon( "crash_done" );
	self endon( "death" );
	
	count = 0;
	
	prev_forward = AnglesToForward( self.angles );
	prev_forward_vel = VectorDot( self.velocity, prev_forward ) * self.velocity_rotation_frac;
	if( prev_forward_vel < 0 )
	{
		prev_forward_vel = 0;
	}
	
	while( 1 )
	{
		self SetVehVelocity( self.velocity + AnglesToUp( self.angles ) * self.crash_accel );
		self.crash_accel *= 0.98;
		
		// Rotate part of the velocity
		new_velocity = self.velocity;
		new_velocity -= prev_forward * prev_forward_vel;
		
		forward = AnglesToForward( self.angles );
		new_velocity += forward * prev_forward_vel;// * 0.98;
		
		prev_forward = forward;
		prev_forward_vel = VectorDot( new_velocity, prev_forward ) * self.velocity_rotation_frac;
		if( prev_forward_vel < 10 )
		{
			new_velocity += forward * 40;
			prev_forward_vel = 0;
		}
		
		self SetVehVelocity( new_velocity );
		
		wait 0.1;
		
		count++;
		if ( count % 8 == 0 && RandomInt( 100 ) > 40 )
		{
			if ( self.velocity[2] > 130.0 )
			{
				self.crash_accel *= 0.75;
			}
			else if ( self.velocity[2] < 40.0 && count < 60 )
			{
				if ( Abs( self.angles[0] ) > 35 || Abs( self.angles[2] ) > 35 ) // tilted
				{
					self.crash_accel = RandomFloatRange( 100, 150 );
				}
				else
				{
					self.crash_accel = RandomFloatRange( 45, 70 );
				}
			}
			
			//ang_vel = self GetAngularVelocity();
			//ang_vel += ( RandomFloatRange( -10, 10 ), RandomFloatRange( -35, 35 ), RandomFloatRange( -1, 1 ) );
			//self SetAngularVelocity( ang_vel );
		}
	}
}

function death_fire_loop_audio()
{
	sound_ent = Spawn( "script_origin", self.origin );
	sound_ent PlayLoopSound( "veh_qrdrone_death_fire_loop" , .1 );
	wait 11;
	sound_ent StopLoopSound( 1 );
	sound_ent delete();
}
