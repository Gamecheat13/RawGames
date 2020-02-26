// _vehicle_death.gsc - all things related to vehicles dying

// Utility rain functions:
#include maps\_utility;
#include maps\_vehicle;
#include common_scripts\utility;

#insert raw\maps\_utility.gsh;

#using_animtree( "vehicles" );

main()
{
	self endon( "nodeath_thread" );

	type = self.vehicletype; 
	model = self.model; 
	attacker = undefined;
	arcadeModePointsRewarded = false;
	
	while ( IsDefined( self ) )
	{
		// waittill death twice. in some cases the vehicle dies and does a bunch of stuff. then it gets deleted. which it then needs to do more stuff
		self waittill( "death", attacker, damageFromUnderneath, weaponName, point, dir );
		
		if ( !IsDefined( self ) )
		{
			return;
		}
		
		arcadeModePointsRewarded = self death_update_arcademode( arcadeModePointsRewarded );

		self lights_off();
		self sirens_off();
		self interior_lights_off();
		self death_cleanup_level_variables();			
	
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
			
		if ( is_corpse( self ) )
		{
			// Cleanup Riders
			self death_cleanup_riders();

			// kills some destructible fxs
			self notify( "delete_destructible" );

			// Done here
			return;
		}

		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
		// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	
		// Run vehicle death thread
		if( IsDefined( level.vehicle_death_thread[ type ] ) )
		{
			thread [[ level.vehicle_death_thread[ type ] ]]();
		}

		// Do death rumble 
		if( IsDefined( self.deathquakescale ) && self.deathquakescale > 0 )
		{
			Earthquake( self.deathquakescale, self.deathquakeduration, self.origin, self.deathquakeradius );
		}
		
		is_aircraft = (  IS_PLANE( self ) || IS_HELICOPTER( self ) );
		is_horse = ( self.vehicleType == "horse" );

		// Do radius damage
		thread death_radius_damage();

		if( !IsDefined( self.destructibledef ) )
		{
			if( !is_aircraft && !is_horse && IsDefined( self.deathmodel ) && self.deathmodel != "" )
			{
				self thread set_death_model( self.deathmodel, self.modelswapdelay );
			}

			// Do death_fx if it has not been mantled
			if( ( !IsDefined( self.mantled ) || !self.mantled ) && !IsDefined( self.nodeathfx ) )
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
		thread death_make_badplace( type );

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
			self thread death_jolt( type );
		}

		// Check for scripted crash
		self thread death_update_crash( point, dir );

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
				
				while( IsDefined( self.dontfreeme ) && IsDefined( self ) )
				{
					wait( .05 );
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
	eModel clearanim( %root, 0 );
	
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

	self thread helicopter_crash_move( point, dir );

}
play_crashing_loop()
{
	ent = spawn ("script_origin", self.origin);
	ent linkto (self);
	ent playloopsound ("exp_heli_crash_loop");
	self waittill ("death");
	ent delete();
	
}
helicopter_explode( delete_me )
{	
	fx_origin = self GetTagOrigin(self.death_fx_struct.tag);
	PlayFx( self.death_fx_struct.effect, fx_origin );
	
	playsoundatposition ("exp_veh_helicopter", fx_origin);
	
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
				self maps\_avenger::set_deathmodel( point, dir );
				break;
				
			case "drone_pegasus":
			case "drone_pegasus_fast":
			case "drone_pegasus_fast_la2":
				self maps\_pegasus::set_deathmodel( point, dir );
				break;
				
			case "plane_f35":
			case "plane_f35_fast":
			case "plane_f35_vtol":		
			case "plane_f35_fast_la2":
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
	self SetPhysAcceleration( ( 0, 0, -1600 ) );
	
	torque = ( 0, 0, RandomIntRange( 50, 100 ) );
	
	while ( IsDefined(self) )
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

helicopter_crash_move( point, dir )
{
	self endon( "crash_move_done" );

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

	up = AnglesToUp( self.angles );
	dot_up = VectorDot( normal, up );

	//IPrintLnBold( "Up Dot: " + dot_up );

	if ( normal[2] > 0.5 )
	{
		forward = AnglesToForward( self.angles );
		right = VectorCross( normal, forward );
		desired_forward = VectorCross( right, normal );
		self SetPhysAngles( VectorToAngles( desired_forward ) );

		//thread draw_line_for_time( self.origin, self.origin + normal * 1000, 1, 0, 1, 1000 );		
		//thread draw_line_for_time( self.origin, self.origin + forward * 1000, 1, 1, 1, 1000 );
		//thread draw_line_for_time( self.origin, self.origin + right * 1000, 1, 0, 0, 1000 );		
		//thread draw_line_for_time( self.origin, self.origin + desired_forward * 1000, 0, 0, 1, 1000 );				
	}
	
	self helicopter_explode();
/*
	if ( IsDefined( self.deathmodel_pieces ) )
	{
		for ( i = 0; i < self.deathmodel_pieces.size; i++ )
		{
			if ( IsDefined( self.deathmodel_pieces[i].b_launched ) && !self.deathmodel_pieces[i].b_launched )
			{
				dir = VectorNormalize( self.deathmodel_pieces[i].origin - self.origin );
				dir = ( dir[0], dir[1], 1 );
				
				self.deathmodel_pieces[i] UnLink();
				self.deathmodel_pieces[i] PhysicsLaunch( v_point, dir * 1000 );
				self.deathmodel_pieces[i].b_launched = true;
			}
		}
	}
*/
	
	self notify( "crash_move_done" );
	self crash_stop();
	self notify( "crash_done" );
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
	
	if( IS_HELICOPTER( self ) ||  IS_PLANE( self ) )
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
	old_dontfreeme = self.dontfreeme;
	
	if ( IsDefined( level.vehicle_death_jolt[ type ] ) )
	{
		self.dontfreeme = true;

		// this is all that exists currently, not to elaborate untill needed.
		wait( level.vehicle_death_jolt[ type ].delay );
	}

	if( !IsDefined( self ) )
	{
		return;
	}

	self joltbody( ( self.origin + ( 23, 33, 64 ) ), 3 );
	wait 2;

	if( !IsDefined( self ) )
	{
		return;
	}

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

death_update_arcademode( arcadeModePointsRewarded )
{
	// CODER MOD: TOMMY K
	if( arcadeMode() && false == arcadeModePointsRewarded )
	{
		if( IsDefined(self.vteam) && (self.vteam != "allies") )
		{	
			if ( IsDefined( self.attackers ) )
			{
				for ( i = 0; i < self.attackers.size; i++ )
				{
					player = self.attackers[i];
					
					if ( !IsDefined( player ) )
					{
						continue;
					}
					//TODO : where is attacker initialized?
					attacker=undefined;
					if ( player == attacker )
					{
						continue;
					}

					// removing coop challenges for now MGORDON			
					// maps\_challenges_coop::doMissionCallback( "playerAssist", player );
					
					player.assists++;	
					
					arcademode_assignpoints( "arcademode_score_tankassist", player );
				}
				self.attackers = [];
				self.attackerData = [];
			}						
		
			if( IsPlayer( attacker ) )
			{
				//ye killed a enemy tank
				arcademode_assignpoints( "arcademode_score_tank", attacker );
				
				// increment the player kills for tank kill
				attacker.kills++;
			}
		}
		else
		{	//u killed a friendly tank
			arcademode_assignpoints( "arcademode_score_tank_friendly", attacker );
		}

		arcadeModePointsRewarded = true;
	}
}

death_cleanup_level_variables()
{
	vteam = self.vteam;
	script_linkname = self.script_linkname;	
	targetname = self.targetname;	
	
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	// -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- -- - 
	if( IsDefined( vteam ) )
	{
		level.vehicles[ vteam ] = array_remove( level.vehicles[ vteam ], self );
	}

	if ( IsDefined( script_linkname ) )
	{
		level.vehicle_link[ script_linkname ] = array_remove( level.vehicle_link[ script_linkname ], self );
	}

	if( IsDefined( self.script_VehicleSpawngroup ) )
	{
		if ( IsDefined( level.vehicle_SpawnGroup[ self.script_VehicleSpawngroup ] ) )
		{
			level.vehicle_SpawnGroup[ self.script_VehicleSpawngroup ] = array_remove( level.vehicle_SpawnGroup[ self.script_VehicleSpawngroup ], self );
			level.vehicle_SpawnGroup[ self.script_VehicleSpawngroup ] = array_removeUndefined( level.vehicle_SpawnGroup[ self.script_VehicleSpawngroup ] );			
		}
	}

	if( IsDefined( self.script_VehicleStartMove ) )
	{
		level.vehicle_StartMoveGroup[ self.script_VehicleStartMove ] = array_remove( level.vehicle_StartMoveGroup[ self.script_VehicleStartMove ], self );
	}

	if( IsDefined( self.script_vehicleGroupDelete ) )
	{
		level.vehicle_DeleteGroup[ self.script_vehicleGroupDelete ] = array_remove( level.vehicle_DeleteGroup[ self.script_vehicleGroupDelete ], self );
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
	if( IsDefined( self ) && ( IS_PLANE(self) || IS_BOAT( self ) ) )
	{
		if( ( IsDefined( self.crashing ) ) && ( self.crashing == true ) )
		{
			self waittill( "crash_done" );
		}
	}
	else
	{
		wait 0.1;	// don't check the velocity right away because we might have been launched
		
		if( self.isphysicsvehicle )
		{
			//GLocke 2/16/10 - just wait for physics vehicles to get close to 0
			while( IsDefined( self.velocity ) && LengthSquared( self.velocity ) > 25.0 )
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

