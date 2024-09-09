#include maps\_utility;
#include maps\_shg_debug;
#include maps\_vehicle_code;

vehicle_turret_default_ai()
{
	self endon( "death" );
	self endon( "vehicle_dismount" );
	self endon( "stop_vehicle_turret_ai" );
	
	self thread aim_at_attacker();
	self thread vehicle_targeting();
	self thread update_aiming();
	self thread vehicle_firing();
}

vehicle_turret_settings_shoot( min_fire_time, max_fire_time, shot_delay, fire_delay, avoid_players )
{
	if ( !IsDefined( self.vehicle_ai_settings ) )
	{
		self.vehicle_ai_settings = SpawnStruct();
	}

	self.vehicle_ai_settings.min_fire_time = min_fire_time;	
	self.vehicle_ai_settings.max_fire_time = max_fire_time;
	self.vehicle_ai_settings.shot_delay = shot_delay;
	self.vehicle_ai_settings.fire_delay = fire_delay;
	self.vehicle_ai_settings.avoid_players = IsDefined( avoid_players ) && avoid_players;
}

vehicle_turret_settings_target( update_target_time )
{
	if ( !IsDefined( self.vehicle_ai_settings ) )
	{
		self.vehicle_ai_settings = SpawnStruct();
	}
	
	self.vehicle_ai_settings.update_target_time = update_target_time;
}


/******************** TARGETING SYSTEM *****************/

// shoot at enemies attacking you
aim_at_attacker()
{
	self endon( "death" );
	self endon( "vehicle_dismount" );
	self endon( "stop_vehicle_turret_ai" );
	
	while ( true )
	{
		self waittill( "damage", amount, attacker );
		if ( IsDefined( amount ) && amount > 0 && 
		     IsDefined( attacker ) && IsAI( attacker ) && IsAlive( attacker ) &&
		     !attacker_isonmyteam( attacker ) &&
		     !attacker_troop_isonmyteam( attacker ) )
		{
			self.ai_target_force = attacker;
			//self notify( "kill_firing" );
			waittillframeend;
			self notify( "update_target" );
			self.ai_target_force wait_for_notify_or_timeout( "death", 7 );
		}
	}
}

vehicle_targeting()
{
	self endon( "death" );
	self endon( "vehicle_dismount" );
	self endon( "stop_vehicle_turret_ai" );
	
	while ( true )
	{
		if ( IsDefined( self.ai_target_force ) )
		{
			if ( !is_valid_target( self.ai_target_force ) )
			{
				self.ai_target_force = undefined;
			}
			else
			{
				if ( !IsDefined( self.ai_target ) || self.ai_target != self.ai_target_force )
				{
					// picking a different target, remove target influence
					if ( IsDefined( self.ai_target ) )
						self.ai_target.target_score = 0;
					
					// set new target
					self.ai_target = self.ai_target_force;
					// discourage other AI from picking this target
					self.ai_target.target_score = -50;
					self notify( "new_ai_target" );
				}
			}
		}
		
		// check to see if target is still good
		if ( IsDefined( self.ai_target ) && !turret_can_see_target( self.ai_target ) )
		{
			self.ai_target = undefined;
		}
		
		// acquire a target if no current target, target is dead, or target already targetted by a walker
		if ( !is_valid_target( self.ai_target ) )
		{
			self.ai_target = self acquire_target();
				
			if ( IsDefined( self.ai_target ) )
			{
				// discourage other AI from picking this target
				self.ai_target.target_score = -50;
				self notify( "new_ai_target" );
			}
		}
		
		update_target_time = 1.5;
		if ( IsDefined( self.vehicle_ai_settings ) && IsDefined( self.vehicle_ai_settings.update_target_time ) )
		{
			update_target_time = self.vehicle_ai_settings.update_target_time;
		}
		
		self wait_for_notify_or_timeout( "update_target", update_target_time );
	}
}

is_valid_target( ai_target )
{
	return ( IsDefined( ai_target ) && IsAlive( ai_target ) );
}

is_on_target( ai_target )
{
	if ( !IsDefined( ai_target ) )
		return false;
	
	target_pos = ai_target.origin + ( 0,0,50 );
	to_target = target_pos - self GetTagOrigin( "tag_flash" );
	to_target = VectorNormalize( to_target );
	
	gun_angles = self GetTagAngles( "tag_flash" );
	gun_forward = AnglesToForward( gun_angles );
	
	target_dot = VectorDot( to_target, gun_forward );
	if ( target_dot > 0.95 )
		return true;
	
	return false;
}

acquire_target()
{
	enemy_team = undefined;
	if ( self.script_team == "allies" )
		enemy_team = "axis";
	else if ( self.script_team == "axis" )
		enemy_team = "allies";
	
	if ( IsDefined( enemy_team ) )
	{
		enemies = GetAIArray( enemy_team );
		if ( IsDefined( enemies ) && enemies.size > 0 )
		{
			// look at enemies and score them to pick a target
			random_index = RandomInt( enemies.size );
			best_target_score = undefined;
			best_target = undefined;
			
			for ( i = 0; i < enemies.size; i++ )
			{
				actual_index = ( i + random_index ) % enemies.size;
				potential_target = enemies[ actual_index ];
				
				if ( IsDefined( potential_target ) && IsAlive( potential_target ) )
				{
					target_score = self get_target_score( potential_target );
					if ( !IsDefined( best_target_score ) || target_score > best_target_score )
					{
						best_target_score = target_score;
						best_target = potential_target;
					}
				}
			}
			
			if ( IsDefined( best_target_score ) && best_target_score > 0 )
			{
				return best_target;
			}
		}
	}
	
	return undefined;
}

get_target_score( potential_target )
{
	my_score = 0;
	
	min_sq = 128 * 128;
	max_sq = 1500 * 1500;
	
	gun_pos = self GetTagOrigin( "tag_flash" );
	target_distance = DistanceSquared( gun_pos, potential_target.origin );
	
	// too close
	if ( target_distance < min_sq )
		return 0;
	
	// too far
	if ( target_distance > max_sq )
		return 0;
	
	// distance score
	my_score = 100 * ( 1 - ( target_distance - min_sq ) / ( max_sq - min_sq ) );
	
	// bonus if visible
	if ( !turret_can_see_target( potential_target ) )
	{
		return 0;
	}
	
	// bonus if already aiming
	if ( is_on_target( potential_target ) )
	{
		my_score += 50;
	}
	
	// add bonus/penalty based on target itself
	if ( IsDefined( potential_target.target_score ) )
	{
		my_score += potential_target.target_score;
	}
	
	return my_score;
}

turret_can_see_target( potential_target )
{
	gun_pos = self GetTagOrigin( "tag_flash" );
	if ( SightTracePassed( gun_pos, potential_target.origin + (0,0,40), false, self ) )
		return true;
	else
		return false;
}

/************************* FIRING SYSTEM ****************************/
update_aiming()
{
	self endon( "death" );
	self endon( "vehicle_dismount" );
	self endon( "stop_vehicle_turret_ai" );
	
	while ( true )
	{
		target_offset = ( RandomIntRange( -128, 128 ), RandomIntRange( -128, 128 ), RandomIntRange( -12, 36 ) );
		target_offset = target_offset + (0,0,50);
		
		self thread update_aim_offset( target_offset );
		
		self wait_for_notify_or_timeout( "new_ai_target", 1.5 );
	}
}

update_aim_offset( target_offset )
{
	self notify( "kill_update_aim_offset" );
	self endon( "kill_update_aim_offset" );
	
	self endon( "death" );
	self endon( "vehicle_dismount" );
	self endon( "stop_vehicle_turret_ai" );
	
	self endon( "new_ai_target" );
	
	while ( IsDefined( self.ai_target ) && IsAlive( self.ai_target ) )
	{
		actual_offset = target_offset;
		if ( self.ai_target.a.pose == "crouch" )
		{
			actual_offset = target_offset - ( 0, 0, 15 );
		}
		
		self SetTurretTargetEnt( self.ai_target, actual_offset );
			
		// minimize target_offset over time to zero in on target
		target_offset = target_offset - (0,0,50);
		target_offset = target_offset * 0.2;
		target_offset = target_offset + (0,0,50);
		
		wait 0.5;
	}
}

vehicle_firing()
{
	self endon( "death" );
	self endon( "vehicle_dismount" );
	self endon( "stop_vehicle_turret_ai" );
	
	fire_delay = 1.5;
	if ( IsDefined( self.vehicle_ai_settings ) && IsDefined( self.vehicle_ai_settings.fire_delay ) )
	{
		fire_delay = self.vehicle_ai_settings.fire_delay;
	}

	while ( true )
	{
		if ( IsDefined( self.last_fire_time ) )
		{
			wait_to_fire_time = ( GetTime() - ( self.last_fire_time + ( fire_delay * 1000 ) ) ) / 1000;
			if ( wait_to_fire_time > 0 )
				wait wait_to_fire_time;
			
			self.last_fire_time = undefined;
		}
		
		if ( is_valid_target( self.ai_target ) && turret_can_see_target( self.ai_target ) )
		{
			self fire_at_target();
		}
		
		self wait_for_notify_or_timeout( "new_ai_target", fire_delay );
	}
}

fire_at_target()
{
	//self endon( "kill_firing" );
	
	total_fire_time = 0;
	
	if ( IsDefined( self.vehicle_ai_settings ) && IsDefined( self.vehicle_ai_settings.min_fire_time ) )
	{
		min_fire_time = self.vehicle_ai_settings.min_fire_time;
		max_fire_time = self.vehicle_ai_settings.max_fire_time;
		shot_delay = self.vehicle_ai_settings.shot_delay;
	}
	else
	{
		min_fire_time = 1;
		max_fire_time = 3;
		shot_delay = 1.5;
	}

	desired_fire_time = RandomIntRange( min_fire_time, max_fire_time );
	
/#
	//draw_debug_sphere( self.ai_target, self.ai_target.origin, 32, (1,0,0) );
#/
		
	while ( is_valid_target( self.ai_target ) && !is_on_target( self.ai_target ) )
	{
		wait 0.5;
	}
	
	while ( total_fire_time < desired_fire_time && is_valid_target( self.ai_target ) )
	{
		if ( self.vehicle_ai_settings.avoid_players )
		{
			start = self GetTagOrigin( "tag_flash" );
			end = start + AnglesToForward( self GetTagAngles( "tag_flash" ) ) * 10000;
			if ( shot_endangers_any_player( start, end ) )
			    break;
		}
		
		self FireWeapon();
		self.last_fire_time = GetTime();
		total_fire_time += shot_delay;
		wait shot_delay;
	}
}
