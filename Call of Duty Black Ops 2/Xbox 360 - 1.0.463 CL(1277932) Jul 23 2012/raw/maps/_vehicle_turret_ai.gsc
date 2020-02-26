 /* 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 

VEHICLE_TURRET_AI script

This script handles aiming and firing of vehicle turrets

HIGH LEVEL FUNCTIONS

 // vehicle enable_turret( 0 - 4 )
	the specifiec turret will choose and fire at targets

 // vehicle disable_turret( 0 - 4 )
	
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 * * * * * * * * * * * * * * * * * * * * * * * * * * * * * 
 */ 
#include maps\_utility; 
#include common_scripts\utility; 

// self is the vehicle
enable_turret( turret_index, weapon_type, enemy_team, optional_wait_min, optional_wait_max, forced_targets )
{
	if( !IsDefined( self.turret_ai_array ) )
	{
		init_turret_info();
	}

	if( !isdefined( weapon_type ) )
	{
		weapon_type = "mg";
	}
	
	if( !IsDefined( enemy_team ) )
	{
		enemy_team = "axis";
	}
	
	if( IsDefined( forced_targets ) )  // in case player wants to define forced targets here, allow it
	{
		self set_forced_target( forced_targets );
	}

	self thread turret_ai_thread( turret_index, weapon_type, enemy_team, optional_wait_min, optional_wait_max );
	//self thread kill_audio_ent();
}

// self is the vehicle
disable_turret( turret_index )
{
	if( !IsDefined( self.turret_ai_array ) )
	{
		init_turret_info();
	}
	
	if( !IsDefined( turret_index ) )
	{
		PrintLn( "turret index missing! disable_turret returning" );
		return;
	}

	self.turret_ai_array[turret_index].enabled = false;

	//self setSeatOccupied( turret_index + 1, false );	// seats start with the driver
	self clearGunnerTarget( turret_index );
}

init_turret_info()
{
	self.turret_ai_array = [];

	for( i = 0; i < 4; i++ )
	{
		self.turret_ai_array[i] = spawnstruct();
		self.turret_ai_array[i].enabled = false;
		self.turret_ai_array[i].target_ent = undefined;

		fire_angles = undefined;
		
		weapon = self SeatGetWeapon( i + 1 );
		if( IsDefined(weapon) )
		{
			fire_angles = self GetSeatFiringAngles( i + 1 );
		}
		
		if( !isdefined( fire_angles ) )
		{
			fire_angles = (0,0,0);
		}
			
		self.turret_ai_array[i].rest_angle = AngleClamp180( fire_angles[1] - self.angles[1] );
	}
}

fire_turret_for_time( turret_index, time )
{
	self endon( "death" );
	
	if( !IsDefined( self.turret_ai_array ) )
	{
		init_turret_info();
	}

	weapon = self SeatGetWeapon( turret_index + 1 );

	firetime = WeaponFireTime( weapon );

	assert( time > firetime );

	num_shots = time / firetime;
	
	alias = undefined;
	alias2 = undefined;

	for(i = 0; i < num_shots; i++)
	{
		self fireGunnerWeapon( turret_index );
		
		if( IsDefined( self.turret_audio_override ) )
		{  
		    if( !IsDefined( self.sound_ent ) )
		    {
		        self.sound_ent = Spawn( "script_origin", self.origin );
		        self.sound_ent LinkTo(self);
		        self thread kill_audio_ent(self.sound_ent);
		    }
		    
		    if( IsDefined( self.turret_audio_override_alias ) )
		    {
		        alias = self.turret_audio_override_alias;
		    }
		    if( IsDefined( self.turret_audio_ring_override_alias ) )
		    {
		        alias2 = self.turret_audio_ring_override_alias;
		    }
		    else
		    {
		        alias = "wpn_gaz_quad50_turret_loop_npc";
		    }
		    self.sound_ent PlayLoopSound( alias );
		}
		
		wait firetime;
	}
	
	if( IsDefined( self.sound_ent ) )
	{
	    self.sound_ent Delete();
	    self notify( "stop_audio_delete" );
	    //iprintlnbold("NORMAL DELETE");
		if(IsDefined( alias2 ) )
		{
			self playsound( alias2 );
		}
	}
}

kill_audio_ent(audio_ent)
{
	self endon( "stop_audio_delete" );
	self waittill( "death" );
	//wait_network_frame();
	//iprintlnbold("WAITING");
	wait 2;
	//iprintlnbold("KILLL");
	if( IsDefined( audio_ent ) )
	{
		//iprintlnbold("DEEEELEEETE");
		audio_ent Delete();
	}
	
}

turret_ai_thread( turret_index, weapon_type, enemy_team, optional_wait_min, optional_wait_max )
{
	
	//sholmes 2.16.19 adding endon death
	self endon ("death");
	
	weapon = self SeatGetWeapon( turret_index + 1 );
	if( !IsDefined(weapon) )
	{
		println( "Failed to start gunner turret ai for " + turret_index + " " + self.vehicletype + ". No weapon." );
		return;
	}

	// don't allow the turret to have multiple threads running
	if( IsDefined(self.turret_ai_array[turret_index]) && self.turret_ai_array[turret_index].enabled == true )
	{
		println( "Failed to start gunner turret ai for " + turret_index + " " + self.vehicletype + ". Already started." );
		return;
	}

	self.turret_ai_array[turret_index].enabled = true;
	//self setSeatOccupied( turret_index + 1, true );		// seats start with the driver

	while( self.turret_ai_array[turret_index].enabled )
	{
		// PI_CHANGE - JMA - added so player controlled heli can fire turrets
		if( (isdefined(self.player_controlled_heli) && self.player_controlled_heli == true) || choose_target( turret_index, enemy_team ) )
		{
			if( weapon_type == "mg" )
			{
				fire_turret_for_time( turret_index, .6 );
				wait 1;
				fire_turret_for_time( turret_index, .6 );
				wait 1;
			}
			else if( weapon_type == "slow_mg" )
			{
				burst_fire( turret_index, 3, 0.25 );
				wait 1;
				burst_fire( turret_index, 3, 0.25);
				wait 1;
			}
			else if( weapon_type == "fast_mg" )
			{
				fire_turret_for_time( turret_index, 1.75 );
			}
			else if( weapon_type == "huey_minigun" )
			{
				burst_fire( turret_index, 0.5, 0.1 );
			}
			else if( weapon_type == "huey_spotlight" )
			{
				wait RandomFloat(1, 4);
			}
			else if( weapon_type == "target_finder_only" )
			{
				wait 1;
			}
			else if( weapon_type == "flame" )
			{
				flame_fire( turret_index, 2 );
			}
			else if( weapon_type == "grenade" )
			{
				burst_fire( turret_index, 2, 1.5);
			}
			else if( weapon_type == "grenade_btr" )//kevin added for rebirth override
			{
				burst_fire_rebirthbtr( turret_index, 2, 1.5);
			}

			
			if( IsDefined( optional_wait_min ) && IsDefined( optional_wait_max ) )
			{
				wait( RandomFloatRange( optional_wait_min, optional_wait_max ) );
			}
		}
		else
		{
			wait 2;
		}
	}
}

score_angle( target_ent, turret_index )
{
	return (score_angle_position(target_ent.origin, turret_index));
}
score_angle_position( origin, turret_index )
{
	if( !IsDefined( self.turret_ai_array ) )
	{
		init_turret_info();
	}
		
	angles_to_target 	= VectorToAngles( origin - self.origin );
	rest_angle 				= self.turret_ai_array[turret_index].rest_angle + self.angles[1];
	angle_diff 				= AngleClamp180( angles_to_target[1] - rest_angle );
	angle_diff 				= abs( angle_diff );

	if( angle_diff < 90 )
	{
		return (angle_diff / 90) * 50;
	}
	
	return -1000;
}

score_distance( target_ent )
{
	const max_range = 3000 * 3000;
	dist2 = DistanceSquared( target_ent.origin, self.origin );

	if ( dist2 < max_range )
	{
		return (dist2 / max_range) * 100;
	}

	// out of range
	return -1000;
}

score_special( target_ent, turret_index )
{
	for( i = 0; i < 4; i++ )
	{
		if( isdefined(self.turret_ai_array[i].target_ent) && i != turret_index )
		{
			if( self.turret_ai_array[i].target_ent == target_ent )
			{
				return -50;
			}
		}
	}
	return 0;
}


choose_target( turret_index, enemy_team )  
{	
	if( !IsDefined( self.turret_ai_array ) )
	{
		init_turret_info();
	}

	player = self getseatoccupant( turret_index+1 );
	if( isdefined(player) )
	{
		self ClearGunnerTarget( turret_index );
		return false;
	}
	
	if( IsDefined( self._forced_target_ent_array )  )  // added 5/5/2010 -TJanssen
	{
		self update_forced_gunner_targets();
		if( self._forced_target_ent_array.size == 0 )  // don't kick in normal functionality unless parameter is undefined.
		{
			self ClearGunnerTarget( turret_index );
			return false;
		}
		else
		{		
			best_target = score_target( self._forced_target_ent_array, turret_index );
			if( IsDefined( best_target ) )
			{
				self setGunnerTargetEnt( best_target, (0,0,30), turret_index );
				return true;
			}
			else  // target is dead or was just deleted, so return false
			{
				self ClearGunnerTarget( turret_index );
				return false;		

			}
		}
	}
	else
	{
		ai = getaiarray( enemy_team );
		
		// PI_CHANGE_BEGIN - adding in drones for heli to attack
		if(isDefined(level.heli_attack_drone_targets_func))
		{
			ai = [[ level.heli_attack_drone_targets_func ]]( ai, enemy_team );	
		}
		// PI_CHANGE_END
		
		best_target = score_target( ai, turret_index );
	
		self.turret_ai_array[turret_index].target_ent = best_target;
			
		if( IsDefined(best_target) )
		{
			self setGunnerTargetEnt( best_target, (0,0,30), turret_index );
			return true;
		}
	
		self ClearGunnerTarget( turret_index );
		return false;
	}
}

burst_fire( turret_index, bullet_count, interval )
{
	for(i = 0; i < bullet_count; i++)
	{
		self fireGunnerWeapon( turret_index );
		wait interval;
	}
}

burst_fire_rebirthbtr( turret_index, bullet_count, interval )//kevin adding this for rebirth AI grenade turrets.  The gdt entries won't work.
{
	for(i = 0; i < bullet_count; i++)
	{
		self fireGunnerWeapon( turret_index );
		self playsound( "wpn_china_lake_fire_npc" );
		wait interval;
	}
}

flame_fire( turret_index, interval )
{
	while( interval > 0 )
	{
		self fireGunnerWeapon( turret_index );
		wait( 0.05 );
		interval -= 0.05;
	}
	self StopFireWeapon( turret_index );
}

/*==========================================================================
FUNCTION: score_target
SELF: vehicle with turret, but not used here
PURPOSE: find best target based on distance, angle and special parameters. 
		-set up this way so it can be called easily by either normal AI or
		 forced target scenario

ADDITIONS NEEDED:
==========================================================================*/
score_target( target_array, turret_index )
{
		if( !IsDefined( target_array ) || !IsDefined( turret_index ) )
		{
			return;
		}
		else
		{
			best_score = 0;
			best_target = undefined;
			for ( i = 0 ; i < target_array.size ; i++ )
			{
				score = score_distance( target_array[i] );
				score += score_angle( target_array[i], turret_index );
				score += score_special( target_array[i], turret_index );
				if( score > best_score )
				{
					best_score = score;
					best_target = target_array[i];
				}
			}
			
			return best_target;
		}
}


// Player aim assist functions
setup_driver_turret_aim_assist( driver_turret, target_radius, target_offset )
{
	self endon( "death" );
	
	// AE 9-10-09: added the target_radius parameter so we can change it when we call this function
	if(!IsDefined(target_radius))
	{
		target_radius = 60;
	}

	// AE 9-24-09: added the target_offset parameter so we can change it when we call this function
	if(!IsDefined(target_offset))
	{
		target_offset = (0, 0, 30);
	}

	while( 1 )
	{
		driver = self getseatoccupant( 0 );
		if( isdefined(driver) )
		{
			ai = getaiarray( "axis" );
			best_target = undefined;
	
			// AE 9-18-09: grab the current fov instead of thinking it'll always be 65
			fov = GetDvarfloat( "cg_fov");

			for( i = 0; i < ai.size; i++ )
			{
				if( target_isincircle( ai[i], driver, fov, target_radius ) )
					best_target = ai[i];
			}
			
			if( isdefined(driver_turret) )
			{
				if( isdefined(best_target) )
				{
					self setGunnerTargetEnt( best_target, target_offset, driver_turret );
				}
				else
				{
					self clearGunnerTarget( driver_turret );
				}
			}
			else
			{
				if( isdefined(best_target) )
				{
					self SetTurretTargetEnt( best_target, target_offset, driver_turret );
				}
				else
				{
					self ClearTurretTarget( driver_turret );
				}
			}
			
			wait 0.05;
		}
		else
		{
			wait 1;
		}
	}
	
}

/*==========================================================================
FUNCTION: update_forced_gunner_targets
SELF: vehicle with turret
PURPOSE: remove dead targets from forced target array, if they exist. this
		function should be called automatically by choose_target in the event
		of a dead/missing target returning a dead/undefined entity. 

ADDITIONS NEEDED:
==========================================================================*/
update_forced_gunner_targets()
{	
	if( IsDefined( self._forced_target_ent_array ) ) 
	{
		self._forced_target_ent_array = remove_dead_from_array( self._forced_target_ent_array );
	}
	else
	{
		turret_debug_message( "_vehicle_turret_ai couldn't update_forced_gunner_targets since none exist. " );
	}
}


/*==========================================================================
FUNCTION: set_forced_target
SELF: vehicle with turret
PURPOSE: 	- create an array of targets for a vehicle to focus fire on
			- if no targets currently exist, create array of targets
			- if targets exist already, add new targets to the old
			
ADDITIONS NEEDED:					
==========================================================================*/
set_forced_target( target_array )
{	
	if( IsDefined( target_array ) )
	{
		forced_targets = [];
		
		if( !IsArray( target_array ) )  // if single entity passed in, promote to array 
		{
			forced_targets[ forced_targets.size ] = target_array; 
		}
		else  
		{
			forced_targets = target_array;
		}
		
		if( !IsDefined( self._forced_target_ent_array ) || ( self._forced_target_ent_array.size == 0 ) )  // create array
		{
			self._forced_target_ent_array = forced_targets;
		}
		else  // add to preexisting array
		{
			for( i = 0; i < forced_targets.size; i++ )
			{
				ARRAY_ADD( self._forced_target_ent_array, forced_targets[ i ] );
			}
		}
	}
	else
	{
		if( IsDefined( self._forced_target_ent_array ) ) // don't do anything since array exists and no targets were specified
		{
			turret_debug_message( "_vehicle_turret_ai tried to set_forced_target without any targets." );
		}
		else  // instantiate array but leave it empty
		{
			self._forced_target_ent_array = [];  // create array with size zero
		}
	}
}


/*==========================================================================
 FUNCTION: clear_forced_target
 SELF: vehicle with turret
 PURPOSE: 	-check if _forced_target_ent_array exists on a vehicle and clears it 
			if it does. 
			-if a target_to_remove is specified, take it out of the array instead
			of just deleting the whole thing

 ADDITIONS NEEDED:	
==========================================================================*/
clear_forced_target( target_to_remove )
{	
	if( IsDefined( self._forced_target_ent_array ) )
	{
		if( IsDefined( target_to_remove ) )
		{
			if( IsArray( target_to_remove ) )  // array_remove is looking for an array, so we promote an ent
			{
				for( i = 0; i < target_to_remove.size; i++ )
				{
					ArrayRemoveValue( self._forced_target_ent_array, target_to_remove[ i ] );	
				}		
			}
			else
			{
				ArrayRemoveValue( self._forced_target_ent_array, target_to_remove );
			}			
		}
		else
		{
			self._forced_target_ent_array = undefined;
		}
	}
	else
	{
		turret_debug_message( "_vehicle_turret_ai tried to clear_forced_target, but no targets existed. " );
	}
}

/*==========================================================================
FUNCTION: turret_debug_message
SELF: level (but not used)
PURPOSE: looks for a dvar, and prints debug messages if it exists and is set.
		No debug messages should be printed otherwise.
		-dvar name: debug_vehicle_turret_ai
		
ADDITIONS NEEDED:
==========================================================================*/
turret_debug_message( debug_string )
{
	/#
	if( IsDefined( GetDvar( "debug_vehicle_turret_ai" ) ) )
	{
		if( GetDvar( "debug_vehicle_turret_ai" ) != "" )
		{
			PrintLn( debug_string );
		}
	}
	#/
}
