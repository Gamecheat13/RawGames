#include animscripts\utility;
#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_vehicle_death;
#include maps\_statemachine;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_statemachine.gsh;
#insert raw\animscripts\utility.gsh;

init()
{
	PrecacheRumble( "quadrotor_fly" );
	
	vehicle_add_main_callback( "heli_quadrotor", ::quadrotor_think );
	vehicle_add_main_callback( "heli_quadrotor_rts", ::quadrotor_think );
	
	level._effect[ "quadrotor_damage01" ]	= LoadFX( "destructibles/fx_quadrotor_damagestate01" );
	level._effect[ "quadrotor_damage02" ]	= LoadFX( "destructibles/fx_quadrotor_damagestate02" );
	level._effect[ "quadrotor_damage03" ]	= LoadFX( "destructibles/fx_quadrotor_damagestate03" );
	level._effect[ "quadrotor_damage04" ]	= LoadFX( "destructibles/fx_quadrotor_damagestate04" );
	
	level._effect[ "quadrotor_crash" ]	= LoadFX( "destructibles/fx_quadrotor_crash01" );
	level._effect[ "quadrotor_nudge" ]	= LoadFX( "destructibles/fx_quadrotor_nudge01" );
}

quadrotor_think()
{
	self EnableAimAssist();
	self SetHoverParams( 15.0, 60.0, 40 );
	self SetNearGoalNotifyDist( 30 );
	
	self.flyheight = GetDvarFloat( "g_quadrotorFlyHeight" );
	//self SetVehicleAvoidance( true );
	
	if( !IsDefined( self.goalradius ) )
	{
		self.goalradius = 600;
	}
	
	if( !IsDefined( self.goalpos ) )
	{
		self.goalpos = self.origin;
	}
	
	self.original_vehicle_type = self.vehicletype;
	
	self.state_machine = create_state_machine( "brain", self );
	main 		= self.state_machine add_state( "main", undefined, undefined, ::quadrotor_main, undefined, undefined );
	scripted 	= self.state_machine add_state( "scripted", undefined, undefined, ::quadrotor_scripted, undefined, undefined );
	
	main add_connection_by_type( "scripted", 1, CONNECTION_TYPE_ON_NOTIFY, undefined, "enter_vehicle" );
	
	scripted add_connection_by_type( "main", 1, CONNECTION_TYPE_ON_NOTIFY, undefined, "exit_vehicle" );
	scripted add_connection_by_type( "main", 1, CONNECTION_TYPE_ON_NOTIFY, undefined, "scripted_done" );		
	
	self thread quadrotor_death();
	self thread quadrotor_damage();
	self HidePart( "tag_viewmodel" );
		
	// Set the first state
	if ( IsDefined( self.script_startstate ) )
	{
		if( self.script_startstate == "off" )
		{
			self quadrotor_off();
		}
		else
		{
			self.state_machine set_state( self.script_startstate );
		}
	}
	else
	{
		// Set the first state
		quadrotor_start_ai();
	}
	
	self thread quadrotor_set_team( self.vteam );
	
	// start the update
	self.state_machine update_state_machine( 0.05 );
}

quadrotor_start_scripted()
{
	self.state_machine set_state( "scripted" );
}

quadrotor_off()
{
	self.state_machine set_state( "scripted" );
	self lights_off();
	self veh_toggle_tread_fx( 0 );
	self vehicle_toggle_sounds( 0 );
	self HidePart( "tag_rotor_fl" );
	self HidePart( "tag_rotor_fr" );
	self HidePart( "tag_rotor_rl" );
	self HidePart( "tag_rotor_rr" );
	self DisableAimAssist();
	self.off = true;
}

quadrotor_on()
{
	self lights_on();
	self veh_toggle_tread_fx( 1 );
	self vehicle_toggle_sounds( 1 );
	self ShowPart( "tag_rotor_fl" );
	self ShowPart( "tag_rotor_fr" );
	self ShowPart( "tag_rotor_rl" );
	self ShowPart( "tag_rotor_rr" );
	self EnableAimAssist();
	self.off = undefined;
	quadrotor_start_ai();
}

quadrotor_start_ai()
{
	self.goalpos = self.origin;
	self.state_machine set_state( "main" );
}

quadrotor_main()
{
	self thread quadrotor_blink_lights();
	self thread quadrotor_fireupdate();
	self thread quadrotor_movementupdate();
}

quadrotor_fireupdate()
{
	self endon( "death" );
	self endon( "change_state" );
	
	while( 1 )
	{
		if( IsDefined( self.enemy ) && self VehCanSee( self.enemy ) )
		{
			if( DistanceSquared( self.enemy.origin, self.origin ) < 1280 * 1280 ) 
			{
				if( IsDefined( self.custom_target_offset ) )
					self SetTurretTargetEnt( self.enemy, self.custom_target_offset );
				else
					self SetTurretTargetEnt( self.enemy );
				self quadrotor_fire_for_time( 0.4 );
			}
			wait( RandomFloatRange( 0.5, 1.5 ) );
		}
		else
		{
			wait 0.4;
		}
	}
}

quadrotor_check_move( position )
{
	results = PhysicsTraceEx( self.origin, position, (-15,-15,-5), (15,15,5), self );
	
	if( results["fraction"] == 1 )
	{
		return true;
	}
	
	return false;
}

quadrotor_adjust_goal_for_enemy_height( goalpos )
{
	if( IsDefined( self.enemy ) )
	{
		if( self.enemy.origin[2] - 100 > goalpos[2] )
		{
			goal_z = self.enemy.origin[2] - 100;
			if( goal_z > goalpos[2] + 350 )
			{
				goal_z = goalpos[2] + 350;
			}
			goalpos = ( goalpos[0], goalpos[1], goal_z );
		}
	}
	
	return goalpos;
}

make_sure_goal_is_well_above_ground( pos )
{
	start = pos + (0,0,self.flyheight);
	end = pos + (0,0,-self.flyheight);
	trace = BulletTrace( start, end, false, self, false, false );
	end =  trace["position"];
	return end + (0,0,self.flyheight);
}

quadrotor_movementupdate()
{
	self endon( "death" );
	self endon( "change_state" );
	
	// make sure when we start this that we get above the ground
	old_goalpos = self.goalpos;
	self.goalpos = self make_sure_goal_is_well_above_ground( self.goalpos );
	
	self SetVehGoalPos( self.goalpos, true );
	//self PathVariableOffset( (0,0,25), 2 );
	self PathFixedOffset( ( 0, 0, RandomFloatRange( -20, 20 ) ) );
	
	if( self.goalpos[2] > old_goalpos[2] + 10 )
	{
		self waittill_notify_or_timeout( "near_goal", 4 );
	}
	else
	{
		wait 0.1;
	}
	
	self SetVehicleAvoidance( true );
	goalfailures = 0;
	
	while( 1 )
	{
		goalpos = quadrotor_find_new_position();
		goalpos = quadrotor_adjust_goal_for_enemy_height( goalpos );
		self thread quadrotor_blink_lights();
		if( self SetVehGoalPos( goalpos, true, 2, true ) )
		{
			goalfailures = 0;
			if( IsDefined( self.enemy ) && self VehCanSee( self.enemy ) )
			{
				if( RandomInt( 100 ) > 50 )
				{
					self SetLookAtEnt( self.enemy );
				}
			}
			
			self waittill_any( "near_goal", "reached_end_node" );
		
			if( IsDefined( self.enemy ) && self VehCanSee( self.enemy ) )
			{
				self SetLookAtEnt( self.enemy );
				wait RandomFloatRange( 1, 4 );
				self ClearLookAtEnt();
			}
		}
		else
		{
			goalfailures++;

			if( IsDefined( self.goal_node ) )
			{
				self.goal_node.quadrotor_fails = true;
			}
			
			if( goalfailures > 4 )
			{
				// assign a new goal position because the one we have is probably bad
				self.goalpos = make_sure_goal_is_well_above_ground( goalpos );
			}
			else if( goalfailures > 2 )
			{
				goalpos = make_sure_goal_is_well_above_ground( self.goalpos );
			}
			else
			{
				goalpos = self.origin;
			}
			
			self SetVehGoalPos( goalpos, true );
			
			old_goalpos = goalpos;
			
			offset = ( RandomFloatRange(-50,50), RandomFloatRange(-50,50), RandomFloatRange(50, 150) );
			
			goalpos = goalpos + offset;
			
			goalpos = quadrotor_adjust_goal_for_enemy_height( goalpos );
			
			if( self quadrotor_check_move( goalpos ) )
			{
				self SetVehGoalPos( goalpos, true );
				self waittill( "near_goal" );
				
				wait RandomFloatRange( 1, 3 );
				
				self SetVehGoalPos( old_goalpos, true );
				self waittill( "near_goal" );
			}
			wait 0.5;
		}	
	}
}

quadrotor_find_new_position()
{
	if(!isDefined(self.goalpos))
		self.goalpos = self.origin;
		
	origin = self.goalpos;
	
	nodes = GetNodesInRadius( self.goalpos, self.goalradius, 0, self.flyheight + 300, "Path" );
	
	if( nodes.size == 0 )
	{
		nodes = GetNodesInRadius( self.goalpos, self.goalradius + 1000, 0, self.flyheight + 1000, "Path" );
	}
	
	best_node = undefined;
	best_score = 0;
	
	foreach( node in nodes )
	{
		if( node.type == "BAD NODE" || !ISNODEQUADROTOR(node) )
		{
			continue;
		}
		
		if( IsDefined( node.quadrotor_fails ) )
		{
			score = RandomFloat( 30 );
		}
		else
		{
			score = RandomFloat( 100 );
		}
		
		if( score > best_score )
		{
			best_score = score;
			best_node = node;
		}
	}
	
	if( IsDefined( best_node ) )
	{
		origin = best_node.origin + ( 0, 0, self.flyheight + RandomFloatRange( -50, 50 ) );
		self.goal_node = best_node;
	}
	
	return origin;
}

quadrotor_exit_vehicle()
{
	self waittill( "exit_vehicle", player );
	
	player.ignoreme = false;
	player DisableInvulnerability();
	player SetClientDvar( "cg_fov", 65 );
	
	self ShowPart( "tag_turret" );
	self ShowPart( "body_animate_jnt" );
	self ShowPart( "tag_flaps" );
	self ShowPart( "tag_ammo_case" );
	self HidePart( "tag_viewmodel" );
	self SetHeliHeightLock( false );
	self EnableAimAssist();
	self SetVehicleType( self.original_vehicle_type );
	self SetViewModelRenderFlag( false );
}

quadrotor_scripted()
{
	// do nothing state
	driver = self GetSeatOccupant( 0 );
	if( IsDefined(driver) )
	{
		self DisableAimAssist();
		self HidePart( "tag_turret" );
		self HidePart( "body_animate_jnt" );
		self HidePart( "tag_flaps" );
		self HidePart( "tag_ammo_case" );
		self ShowPart( "tag_viewmodel" );
		self SetHeliHeightLock( true );
		self thread vehicle_damage_filter( "firestorm_turret" );
		self thread quadrotor_set_team( driver.team );
		driver.ignoreme = true;
		driver EnableInvulnerability();
		driver SetClientDvar( "cg_fov", 90 );
		self SetVehicleType( "heli_quadrotor_rts_player" );
		self SetViewModelRenderFlag( true );
		self thread quadrotor_exit_vehicle();
		self thread quadrotor_update_rumble();
		self thread quadrotor_self_destruct();
	}
	
	self ClearTargetEntity();
	self CancelAIMove();
	self ClearVehGoalPos();
	self PathVariableOffsetClear();
	self PathFixedOffsetClear();
	self ClearLookAtEnt();
}

quadrotor_get_damage_effect( health_pct )
{
	if( health_pct < .25 )
	{
		return level._effect[ "quadrotor_damage04" ];
	}
	else if( health_pct < .5 )
	{
		return level._effect[ "quadrotor_damage03" ];
	}
	else if( health_pct < .75 )
	{
		return level._effect[ "quadrotor_damage02" ];
	}
	else if( health_pct < 0.9 )
	{
		return level._effect[ "quadrotor_damage01" ];
	}
	
	return undefined;
}

quadrotor_play_single_fx_on_tag( effect, tag )
{	
	if( IsDefined( self.damage_fx_ent ) )
	{
		if( self.damage_fx_ent.effect == effect )
		{
			// already playing
			return;
		}
		self.damage_fx_ent delete();
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
	ent playsound("veh_qrdrone_sparks");

		
	self.damage_fx_ent = ent;
}

quadrotor_update_damage_fx()
{
	max_health = self.healthdefault;
	if( IsDefined( self.health_max ) )
	{
		max_health = self.health_max;
	}
	
	effect = quadrotor_get_damage_effect( self.health / max_health );
	if( IsDefined( effect ) )
	{
		quadrotor_play_single_fx_on_tag( effect, "tag_origin" );	
	}
	else
	{
		if( IsDefined( self.damage_fx_ent ) )
		{
			self.damage_fx_ent delete();
		}
	}
}

quadrotor_damage()
{
	self endon( "crash_done" );
	
	while( IsDefined(self) )
	{
		self waittill( "damage", damage, undefined, dir, point, type );
		
		if( self.health > 0 )		
		{
			quadrotor_update_damage_fx();
		}
		
		if( type == "MOD_EXPLOSIVE" || type == "MOD_GRENADE_SPLASH" || type == "MOD_PROJECTILE_SPLASH" )
		{
			self SetVehVelocity( self.velocity + VectorNormalize(dir) * 300 );
			ang_vel = self GetAngularVelocity();
			ang_vel += ( RandomFloatRange( -300, 300 ), RandomFloatRange( -300, 300 ), RandomFloatRange( -300, 300 ) );
			self SetAngularVelocity( ang_vel );
		}
		else
		{
			ang_vel = self GetAngularVelocity();
			yaw_vel = RandomFloatRange( -320, 320 );
		
			if( yaw_vel < 0 )
				yaw_vel -= 150;
			else
				yaw_vel += 150;
			
			ang_vel += ( RandomFloatRange( -150, 150 ), yaw_vel, RandomFloatRange( -150, 150 ) );
			self SetAngularVelocity( ang_vel );
		}
		
		wait 0.3;
	}
}

quadrotor_death()
{
	wait 0.1;
	
	self notify( "nodeath_thread" );	// Kill off the _vehicle_death::main thread
	
	self waittill( "death", attacker, damageFromUnderneath, weaponName, point, dir );
	if( IsDefined( self.delete_on_death ) )
	{
		if( IsDefined( self.damage_fx_ent ) )
		{
			self.damage_fx_ent delete();
		}
		
		if ( IsDefined( self ) )
		{
			self delete();
		}
		
		return;
	}
	
	if ( !IsDefined( self ) )
	{
		return;
	}
	
	self endon( "death" ); //quit thread if deleted
	
	self maps\_vehicle_death::death_cleanup_level_variables();			
	
	self DisableAimAssist();
	
	self death_fx();
	self thread maps\_vehicle_death::death_radius_damage();
	self thread maps\_vehicle_death::set_death_model( self.deathmodel, self.modelswapdelay );
	
	self veh_toggle_tread_fx( false );
	self veh_toggle_exhaust_fx( false );
	self vehicle_toggle_sounds( false );
	self lights_off();
	self thread quadrotor_crash_movement( attacker, dir );
	
	if( IsDefined( self.damage_fx_ent ) )
	{
		self.damage_fx_ent delete();
	}
	
	self waittill( "crash_done" );
	
	// A dynEnt will be spawned in the collision thread when it hits the ground and "crash_done" notify will be sent
	//self freeVehicle();
	//self Hide(); // Hide our self so the particle effect doesn't blink out
	//wait 5;
	self delete();
}

death_fx()
{
	playfxontag( self.deathfx, self, self.deathfxtag );
	self playsound("veh_qrdrone_sparks");
}

quadrotor_crash_movement( attacker, hitdir )
{
	self endon( "crash_done" );
	self endon( "death" );
	
	self CancelAIMove();
	self ClearVehGoalPos();	
	self ClearLookAtEnt();
	
	self SetPhysAcceleration( ( 0, 0, -800 ) );

	side_dir = VectorCross( hitdir, (0,0,1) );
	side_dir_mag = RandomFloatRange( -100, 100 );
	side_dir_mag += Sign( side_dir_mag ) * 80;
	side_dir *= side_dir_mag;
	
	self SetVehVelocity( self.velocity + (0,0,100) + VectorNormalize( side_dir ) );

	ang_vel = self GetAngularVelocity();
	ang_vel = ( ang_vel[0] * 0.3, ang_vel[1], ang_vel[2] * 0.3 );
	
	yaw_vel = RandomFloatRange( 0, 210 ) * Sign( ang_vel[1] );
	yaw_vel += Sign( yaw_vel ) * 180;
	
	ang_vel += ( RandomFloatRange( -1, 1 ), yaw_vel, RandomFloatRange( -1, 1 ) );
	
	self SetAngularVelocity( ang_vel );
	
	self.crash_accel = RandomFloatRange( 75, 110 );
	
	self thread quadrotor_crash_accel();
	self thread quadrotor_collision();
	
	//drone death sounds JM - play 1 shot hit, turn off main loop, thread dmg loop
	self playsound("veh_qrdrone_dmg_hit");
	self vehicle_toggle_sounds( 0 );
	self thread qrotor_dmg_snd();

	wait 0.1;
	
	if( RandomInt( 100 ) < 40 )
	{
		self thread quadrotor_fire_for_time( RandomFloatRange( 0.7, 2.0 ) );
	}
	
	wait 15;
	
	// failsafe notify
	self notify( "crash_done" );
}


qrotor_dmg_snd()
{
	dmg_ent = spawn("script_origin", self.origin);
	dmg_ent linkto (self);
	dmg_ent PlayLoopSound ("veh_qrdrone_dmg_loop");
	self waittill("crash_done");
	dmg_ent stoploopsound(1);
	wait (2);
	dmg_ent delete();
}


quadrotor_fire_for_time( totalFireTime )
{
	self endon( "crash_done" );
	self endon( "change_state" );
	self endon( "death" );
	
	weaponName = self SeatGetWeapon( 0 );
	fireTime = WeaponFireTime( weaponName );
	time = 0;
	
	fireCount = 1;
	
	while( time < totalFireTime )
	{
		self FireWeapon( undefined, undefined, fireCount % 2 );
		fireCount++;
		wait fireTime;
		time += fireTime;
	}
}

quadrotor_crash_accel()
{
	self endon( "crash_done" );
	self endon( "death" );
	
	count = 0;
	
	while( 1 )
	{
		self SetVehVelocity( self.velocity + AnglesToUp( self.angles ) * self.crash_accel );
		self.crash_accel *= 0.98;
		
		wait 0.1;
		
		count++;
		if( count % 8 == 0 )
		{
			if( RandomInt( 100 ) > 40 )
			{
				if( self.velocity[2] > 150.0 )
				{
					self.crash_accel *= 0.75;
				}
				else if( self.velocity[2] < 40.0 && count < 60 )
				{
					if( Abs( self.angles[0] ) > 30 || Abs( self.angles[2] ) > 30 )
					{
						self.crash_accel = RandomFloatRange( 160, 200 );
					}
					else
					{
						self.crash_accel = RandomFloatRange( 85, 120 );
					}
				}
			}
		}
	}
}

quadrotor_collision()
{
	self endon( "crash_done" );
	self endon( "death" );
	
	while( 1 )
	{
		self waittill( "veh_collision", velocity, normal );
		ang_vel = self GetAngularVelocity() * 0.5;
		self SetAngularVelocity( ang_vel );
		
		// bounce off walls
		if( normal[2] < 0.7 )	
		{
			self SetVehVelocity( self.velocity + normal * 70 );
			self playsound ("veh_qrdrone_wall");
			PlayFX( level._effect[ "quadrotor_nudge" ], self.origin );
		}
		else
		{
			//self.crash_accel *= 0.5;
			//self SetVehVelocity( self.velocity * 0.8 );
			CreateDynEntAndLaunch( self.deathmodel, self.origin, self.angles, self.origin, self.velocity * 0.03, level._effect[ "quadrotor_crash" ], 1 );
			self playsound ("veh_qrdrone_explo");
			self notify( "crash_done" );
		}
	}
}

quadrotor_set_team( team )
{
	self.vteam = team;
	if( IsDefined( self.vehmodelenemy ) )
	{
		if( team == "axis" )
		{
			self SetModel( self.vehmodelenemy );
		}
		else
		{
			self SetModel( self.vehmodel );
		}
	}
	
	if( !IsDefined( self.off ) )
	{
		quadrotor_blink_lights();
	}
}

quadrotor_blink_lights()
{
	self endon( "death" );
	
	self lights_off();
	wait 0.1;
	self lights_on();
}

// Lots of gross hardcoded values! :( 
quadrotor_update_rumble()
{
	self endon( "death" );
	self endon( "exit_vehicle" );

	while ( 1 )
	{
		vr = Abs( self GetSpeed() / self GetMaxSpeed() );
		
		if ( vr < 0.1 )
		{
			level.player PlayRumbleOnEntity( "quadrotor_fly" );		
			wait( 0.35 );						
		}
		else
		{
			time = RandomFloatRange( 0.1, 0.2 );
			Earthquake( RandomFloatRange( 0.1, 0.15 ), time, self.origin, 200 );
			level.player PlayRumbleOnEntity( "quadrotor_fly" );		
			wait( time );							
		}
	}
}

quadrotor_self_destruct()
{
	self endon( "death" );
	self endon( "exit_vehicle" );
	
	const max_self_destruct_time = 5;
	
	self_destruct = false;
	self_destruct_time = 0;
	
	while ( 1 )
	{
		if ( !self_destruct )
		{
			if ( level.player MeleeButtonPressed() )
			{
				self_destruct = true;
				self_destruct_time = max_self_destruct_time;				
			}
			
			wait( 0.05 );			
			continue;
		}
		else
		{
			IPrintLnBold( self_destruct_time );
			
			wait( 1 );
			
			self_destruct_time -= 1;
			if ( self_destruct_time == 0 )
			{
				driver = self GetSeatOccupant( 0 );
				if( IsDefined(driver) )
				{
					driver DisableInvulnerability();
				}

				Earthquake( 3, 1, self.origin, 256 );
				RadiusDamage( self.origin, 1000, 15000, 15000, level.player, "MOD_EXPLOSIVE" );
				self DoDamage( self.health + 1000, self.origin );
			}
			
			continue;
		}
	}
}
