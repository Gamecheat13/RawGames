#include common_scripts\utility;
#include maps\_utility;
#include maps\_vehicle;
#include maps\_statemachine;

#insert raw\common_scripts\utility.gsh;
#insert raw\maps\_utility.gsh;
#insert raw\maps\_statemachine.gsh;

init()
{
	vehicle_add_main_callback( "turret_cic", ::cic_turret_think );
	
	level._effect[ "cic_turret_damage01" ]	= LoadFX( "destructibles/fx_cic_turret_damagestate01" );
	level._effect[ "cic_turret_damage02" ]	= LoadFX( "destructibles/fx_cic_turret_damagestate02" );
	level._effect[ "cic_turret_damage03" ]	= LoadFX( "destructibles/fx_cic_turret_damagestate03" );
	level._effect[ "cic_turret_damage04" ]	= LoadFX( "destructibles/fx_cic_turret_damagestate04" );
	
	level._effect[ "cic_turret_crash" ]	= LoadFX( "destructibles/fx_cic_turret_crash01" );
	level._effect[ "cic_turret_nudge" ]	= LoadFX( "destructibles/fx_cic_turret_nudge01" );
}

cic_turret_think()
{
	self EnableAimAssist();
	
	self.scanning_arc = 60;
	self.default_pitch = 15;
	
	self.state_machine = create_state_machine( "brain", self );
	
	main 		= self.state_machine add_state( "main", undefined, undefined, ::cic_turret_main, undefined, undefined );
	scripted 	= self.state_machine add_state( "scripted", undefined, undefined, ::cic_turret_scripted, undefined, undefined );
	
	main add_connection_by_type( "scripted", 1, CONNECTION_TYPE_ON_NOTIFY, undefined, "enter_vehicle" );
	scripted add_connection_by_type( "main", 1, CONNECTION_TYPE_ON_NOTIFY, undefined, "exit_vehicle" );
	
	// Scripted to patrol
	scripted add_connection_by_type( "main", 1, CONNECTION_TYPE_ON_NOTIFY, undefined, "scripted_done" );		
	
	self thread cic_turret_death();
	self thread cic_turret_damage();
	
	// Set the first state
	if ( IsDefined( self.script_startstate ) )
	{
		self.state_machine set_state( self.script_startstate );
	}
	else
	{
		// Set the first state
		cic_turret_start_ai();
	}
	
	// start the update
	self.state_machine update_state_machine( 0.3 );
}

cic_turret_start_scripted()
{
	self.state_machine set_state( "scripted" );
}

cic_turret_start_ai()
{
	self.goalpos = self.origin;
	self.state_machine set_state( "main" );
}

cic_turret_main()
{
	self EnableAimAssist();
	self thread cic_turret_fireupdate();
}

cic_turret_on_target_thread()
{
	self endon( "death" );
	self endon( "change_state" );
	
	self.turret_on_target = false;
	
	while( 1 )
	{
		self waittill( "turret_on_target" );
		self.turret_on_target = true;
	}
}

cic_turret_fireupdate()
{
	self endon( "death" );
	self endon( "change_state" );
	
	cant_see_enemy_count = 0;

	left_look_at_pt = self.origin + AnglesToForward( self.angles + (self.default_pitch, self.scanning_arc, 0) ) * 1000;
	right_look_at_pt = self.origin + AnglesToForward( self.angles + (self.default_pitch, -self.scanning_arc, 0) ) * 1000;
	
	self thread cic_turret_on_target_thread();
	
	while( 1 )
	{
	
		if( IsDefined( self.enemy ) && self VehCanSee( self.enemy ) )
		{
			self.turretRotScale = 1;
			
			if( cant_see_enemy_count > 0 && IsPlayer( self.enemy ) )
			{
				cic_turret_alert_sound();
				wait 0.5;
			}
			
			cant_see_enemy_count = 0;
			
			for( i = 0; i < 3; i++ )
			{
				if( IsDefined( self.enemy ) )
				{
					self SetTurretTargetEnt( self.enemy, ( 0, 0, RandomIntRange( -10, 60 ) ) );
					self cic_turret_fire_for_time( 0.3 );
				}
				wait 0.3;
			}
			
			wait( RandomFloatRange( 1.0, 1.5 ) );
		}
		else
		{
			self.turretRotScale = 0.25;
			
			cant_see_enemy_count++;
			
			wait 1;
			
			if( cant_see_enemy_count > 1 )
			{
				self.turret_state = 0;
				while( !IsDefined( self.enemy ) || !(self VehCanSee( self.enemy )) )
				{
					if( self.turret_on_target )
					{
						self.turret_on_target = false;
						self.turret_state++;
						if( self.turret_state > 1 )
							self.turret_state = 0;
					}
					if( self.turret_state == 0 )
						self SetTurretTargetVec( left_look_at_pt );
					else 
						self SetTurretTargetVec( right_look_at_pt );
					
					wait 0.5;
				}
			}
			else
			{
				self ClearTargetEntity();
			}
		}
		
		wait 0.5;
	}
}

cic_turret_scripted()
{
	// do nothing state
	driver = self GetSeatOccupant( 0 );
	if( IsDefined(driver) )
	{
		self.turretRotScale = 1;
		self DisableAimAssist();
		
		if ( driver == level.player	)
		{
			self thread maps\_vehicle_death::vehicle_damage_filter( "firestorm_turret" );
		}
	}
	
	self ClearTargetEntity();
}

cic_turret_get_damage_effect( health_pct )
{
	if( health_pct < .25 )
	{
		return level._effect[ "cic_turret_damage04" ];
	}
	else if( health_pct < .5 )
	{
		return level._effect[ "cic_turret_damage03" ];
	}
	else if( health_pct < .75 )
	{
		return level._effect[ "cic_turret_damage02" ];
	}
	else
	{
		return level._effect[ "cic_turret_damage01" ];
	}
}

cic_turret_play_single_fx_on_tag( effect, tag )
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
	ent playsound("veh_cic_turret_sparks");
		
	self.damage_fx_ent = ent;
}

cic_turret_damage()
{
	self endon( "crash_done" );
	
	while( IsDefined(self) )
	{
		self waittill( "damage" );
		
		if( self.health > 0 )		
		{
			effect = cic_turret_get_damage_effect( self.health / self.healthdefault );
			tag = "tag_origin";
				
			cic_turret_play_single_fx_on_tag( effect, tag );			
		}
		
		ang_vel = self GetAngularVelocity();
		yaw_vel = RandomFloatRange( -420, 420 );
		
		if( yaw_vel < 0 )
			yaw_vel -= 200;
		else
			yaw_vel += 200;
		
		ang_vel += ( RandomFloatRange( -100, 100 ), yaw_vel, RandomFloatRange( -100, 100 ) );
		self SetAngularVelocity( ang_vel );
		
		wait 0.3;
	}
}

cic_turret_death()
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
		self delete();
		return;
	}
	
	if ( !IsDefined( self ) )
	{
		return;
	}
	
	self maps\_vehicle_death::death_cleanup_level_variables();			
	
	self DisableAimAssist();
	
	self death_fx();
	self thread maps\_vehicle_death::death_radius_damage();
	self thread maps\_vehicle_death::set_death_model( self.deathmodel, self.modelswapdelay );
	
	self vehicle_toggle_sounds( false );
	self thread cic_turret_death_movement( attacker, dir );
	
	if( IsDefined( self.damage_fx_ent ) )
	{
		self.damage_fx_ent delete();
	}
	
	self.ignoreme = true;
		
	self waittill( "crash_done" );
	
	// A dynEnt will be spawned in the collision thread when it hits the ground and "crash_done" notify will be sent
	//self freeVehicle();
	//wait 20;
	self delete();
}

death_fx()
{
	playfxontag( self.deathfx, self, self.deathfxtag );
	self playsound("veh_cic_turret_sparks");
}

cic_turret_death_movement( attacker, hitdir )
{
	self endon( "crash_done" );
	self endon( "death" );
	
	//drone death sounds JM - play 1 shot hit, turn off main loop, thread dmg loop
	self playsound("veh_cic_turret_dmg_hit");
	//self vehicle_toggle_sounds( 0 );
	//self thread cic_turret_dmg_snd();  Unnecessary for ceiling turret? 

	wait 0.1;
	
	if( RandomInt( 100 ) < 40 )
	{
		self thread cic_turret_fire_for_time( RandomFloatRange( 0.7, 2.0 ) );
	}
	
	wait 15;
	
	// failsafe notify
	self notify( "crash_done" );
}

/*
cic_turret_dmg_snd()
{
	dmg_ent = spawn("script_origin", self.origin);
	dmg_ent linkto (self);
	dmg_ent PlayLoopSound ("veh_cic_turret_dmg_loop");
	self waittill("crash_done");
	dmg_ent stoploopsound(1);
	wait (2);
	dmg_ent delete();
}
*/

cic_turret_fire_for_time( totalFireTime )
{
	self endon( "crash_done" );
	self endon( "death" );
	
	weaponName = self SeatGetWeapon( 0 );
	fireTime = WeaponFireTime( weaponName );
	time = 0;
	
	while( time < totalFireTime )
	{
		self FireWeapon();
		wait fireTime;
		time += fireTime;
	}
	
}

cic_turret_alert_sound()    //NOT USING FOR NOW  JM
{
	self playsound ("veh_turret_alert");
}
			
	
	