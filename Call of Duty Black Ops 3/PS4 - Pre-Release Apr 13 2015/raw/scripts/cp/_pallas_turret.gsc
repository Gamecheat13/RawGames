#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
       

#namespace pallas_turret;

function autoexec __init__sytem__() {     system::register("pallas_turret",&__init__,undefined,undefined);    }

function __init__()
{
	vehicle::add_main_callback( "turret_pallas",		&pallas_turret_init );
}

function pallas_turret_init()
{
	self EnableAimAssist();
	
	self.scanning_arc = 80;
	self.default_pitch = 25;
	
	self.fovcosine = 0;//0.707;	
	self.fovcosinebusy = 0;//0.707;
	self.maxsightdistsqrd = ( (10000) * (10000) );
	
	self.state_machine = statemachine::create( "brain", self );
	
	main 		= self.state_machine statemachine::add_state( "main", undefined,&pallas_turret_main, undefined );
	scripted 	= self.state_machine statemachine::add_state( "scripted", undefined,&pallas_turret_scripted, undefined );
	
	vehicle_ai::set_role( "brain" );

	vehicle_ai::add_interrupt_connection( "main", "scripted", "enter_vehicle" );
	vehicle_ai::add_interrupt_connection( "main", "scripted", "scripted" );
	vehicle_ai::add_interrupt_connection( "scripted", "main", "exit_vehicle" );
	vehicle_ai::add_interrupt_connection( "scripted", "main", "scripted_done" );
	
	// Navmesh
	self DisconnectPaths();
	//self SetVehicleAvoidance( true, 22 );
	
	self thread pallas_turret_death();
	//self thread turret::track_lens_flare();
	
	self.overrideVehicleDamage = &PallasTurretCallback_VehicleDamage;
	
	// Set the first state
	if ( isdefined( self.script_startstate ) )
	{
		if( self.script_startstate == "off" )
			self pallas_turret_off( self.angles );
		else
			self.state_machine statemachine::set_state( self.script_startstate );
	}
	else
	{
		// Set the first state
		pallas_turret_start_ai();
	}

	//self laserOn();
}

function pallas_turret_start_scripted()
{
	self.state_machine statemachine::set_state( "scripted" );
}

function pallas_turret_start_ai()
{
	self.state_machine statemachine::set_state( "main" );
}

function pallas_turret_main( params )
{
	if( IsAlive( self ) )
	{
		self EnableAimAssist();
		self thread pallas_turret_fireupdate();
	}
}


function pallas_turret_off(angles)
{
	self.state_machine statemachine::set_state( "scripted" );
	self vehicle::lights_off();
	self LaserOff();
	self vehicle::toggle_sounds( 0 );
	self vehicle::toggle_exhaust_fx( 0 );
	
	if(!isdefined(angles))
		angles = self GetTagAngles( "tag_flash" );
		
	target_vec = self.origin + AnglesToForward( ( 0, angles[1], 0 ) ) * 1000;
	target_vec = target_vec + ( 0, 0, -1700 );
	self SetTargetOrigin( target_vec );		
	self.off = true;
	if( !isdefined( self.emped ) )
	{
		self DisableAimAssist();
	}
}


function pallas_turret_on()
{
	self playsound ("veh_pallas_turret_boot");
	self vehicle::lights_on();
	self EnableAimAssist();
	self vehicle::toggle_sounds( 1 );
	self bootup();
	self vehicle::toggle_exhaust_fx( 1 );
	self.off = undefined;
	self LaserOn();
	pallas_turret_start_ai();
}


function bootup()
{
	for( i = 0; i < 6; i++ )
	{
		wait 0.1;
		vehicle::lights_off();
		wait 0.1;
		vehicle::lights_on();
	}
	
	if(!isdefined(self.player))
	{	
		angles = self GetTagAngles( "tag_flash" );
		target_vec = self.origin + AnglesToForward( ( self.default_pitch, angles[1], 0 ) ) * 1000;
		self.turretRotScale = 0.3;
		self SetTargetOrigin( target_vec );
		wait 1;
		self.turretRotScale = 1;
	}
}

function pallas_turret_fireupdate()
{
	self endon( "death" );
	self endon( "change_state" );
	
	cant_see_enemy_count = 10;

	wait 0.2;

	origin = self GetTagOrigin( "tag_barrel" );
	
	left_look_at_pt = origin + AnglesToForward( self.angles + (self.default_pitch, self.scanning_arc, 0) ) * 1000;
	right_look_at_pt = origin + AnglesToForward( self.angles + (self.default_pitch, -self.scanning_arc, 0) ) * 1000;
	
	while( 1 )
	{
	
		if( isdefined( self.enemy ) && cant_see_enemy_count < 5 )
		{
			self.turretRotScale = 1;
			
			if( isdefined( self.enemy ) && IsAlive( self.enemy) && (self VehCanSee( self.enemy ) || (isdefined(self.last_atacker) && self.last_atacker == self.enemy) ) )
			{
//				if( cant_see_enemy_count > 0 && IsPlayer( self.enemy ) && ( isdefined(self._current_enemy ) && self._current_enemy != self.enemy ) )
//				{	
//					//pallas_turret_alert_sound();
//					wait 0.5;
//				}
				
				distance_squared = DistanceSquared( self.origin, self.enemy.origin );
				if( distance_squared > 2000 * 2000 )
				{
					wait(0.05);
					continue;
				}
				
				cant_see_enemy_count = 0;
				self.cant_see_enemy = undefined;
				if( isdefined( self._start_timer ) && GetTime() - self._start_timer < 5000 )
				{
					self SetTurretTargetEnt( self.enemy, (0, 0, 150) );
					self SetGunnerTargetEnt( self.enemy, (0, 0, 150) );
					self._current_enemy = self.enemy;
				}
				else
				{
					self SetTurretTargetEnt( self.enemy );
					self SetGunnerTargetEnt( self.enemy );
				}
				//temp
				a_trigger = getentarray( "pallas_floor_trigger", "script_noteworthy" );
				
				self.enemy._is_hiding = undefined;
				foreach( trigger in a_trigger )
				{
					if( self.enemy istouching( trigger ) )
					{
						self.enemy._is_hiding = true;	
					}
				}
				
				wait 0.1;
				
				if( isdefined( self.enemy_is_hiding ) )
				{
					self pallas_turret_fire_for_time( RandomFloatRange( 0.2, 0.5 ) );
				}
				else
				{
					self pallas_turret_fire_for_time( RandomFloatRange( 0.4, 1.5 ) );
				}
				
			}
			else
			{
				cant_see_enemy_count++;
				self ClearTargetEntity();
				self ClearGunnerTarget();
				self.cant_see_enemy = true;
			}
			
			if( isdefined( self.enemy ) && IsPlayer( self.enemy ) )
				wait RandomFloatRange( 0.3, 0.6 );
			else
				wait RandomFloatRange( 0.3, 0.6 ) * 2;
		}
		else
		{
			self.turretRotScale = 0.25;
			
			cant_see_enemy_count++;
			
			wait 1;
			
			if( cant_see_enemy_count > 1 )
			{
				self.turret_state = 0;
				while( !isdefined( self.enemy ) || !(self VehCanSee( self.enemy )) )
				{
					if( self.turretontarget )
					{
						self.turret_state++;
						if( self.turret_state > 1 )
							self.turret_state = 0;
					}
					if( self.turret_state == 0 )
						self SetTurretTargetVec( left_look_at_pt );
					else 
						self SetTurretTargetVec( right_look_at_pt );

					if( isdefined( self.enemy ) && (isdefined(self.last_atacker) && self.last_atacker == self.enemy) )
					{
						self SetTurretTargetEnt( self.enemy );
					}
										
					wait 0.5;
				}
				
				cant_see_enemy_count = 0;
			}
			else
			{
				self ClearTargetEntity();
				self ClearGunnerTarget();
			}
		}
		
		wait 0.5;
	}
}

function pallas_turret_scripted( params )
{
	// do nothing state
	driver = self GetSeatOccupant( 0 );
	if( isdefined(driver) )
	{
		self.turretRotScale = 1;
		self DisableAimAssist();
	}
	
	self ClearTargetEntity();
}


function pallas_turret_death()
{
	wait 0.1;
	
	self notify( "nodeath_thread" );	// Kill off the vehicle_death::main thread
	
	self waittill( "death", attacker, damageFromUnderneath, weapon, point, dir );

	if( isdefined( self.delete_on_death ) )
	{
		if( isdefined( self.damage_fx_ent ) )
		{
			self.damage_fx_ent delete();
		}
		self delete();
		return;
	}
	
	if ( !isdefined( self ) )
	{
		return;
	}
	
	self vehicle_death::death_cleanup_level_variables();			
	
	self DisableAimAssist();
	self ClearTargetEntity();
	self vehicle::lights_off();
	self LaserOff();
	self SetTurretSpinning( false );
	self turret::toggle_lensflare( false );
	
	self death_fx();
	self thread vehicle_death::death_radius_damage();
	self thread vehicle_death::set_death_model( self.deathmodel, self.modelswapdelay );
	
	self vehicle::toggle_sounds( false );
	self thread pallas_turret_death_movement( attacker, dir );
	
	if( isdefined( self.damage_fx_ent ) )
	{
		self.damage_fx_ent delete();
	}
	
	self.ignoreme = true;
		
	self waittill( "crash_done" );
	
	self freeVehicle();
	//wait 20;
	//self delete();
}

function death_fx()
{
	self vehicle::do_death_fx();
	self playsound("veh_pallas_turret_sparks");
	fire_ent = Spawn( "script_origin", self.origin );
	fire_ent playloopsound( "veh_pallas_turret_dmg_fire_loop", .5 );
}

function pallas_turret_death_movement( attacker, hitdir )
{
	self endon( "crash_done" );
	self endon( "death" );
	
	//drone death sounds JM - play 1 shot hit, turn off main loop, thread dmg loop
	self playsound("veh_pallas_turret_exp");
	//self vehicle::toggle_sounds( 0 );
	//self thread pallas_turret_dmg_snd();  Unnecessary for ceiling turret? 

	wait 0.1;
	
	self.turretRotScale = 0.5;
	tag_angles = self GetTagAngles( "tag_flash" );
	target_pos = self.origin + AnglesToForward( ( 0, tag_angles[1], 0 ) ) * 1000 + (0,0,-1800);
	
	self SetTurretTargetVec( target_pos );
	
	wait 4;
	
	// failsafe notify
	self notify( "crash_done" );
}

function pallas_turret_fire_for_time( totalFireTime )
{
	self endon( "crash_done" );
	self endon( "death" );
	
	//pallas_turret_alert_sound();
	wait .1;//giving time for the alert to play
	
	weapon = self SeatGetWeapon( 0 );
	fireTime = weapon.fireTime;
	time = 0;
	
	is_minigun = false;
	if ( IsSubStr( weapon.name, "minigun" ) )
	{
		is_minigun = true;
		self SetTurretSpinning( true );
		wait 0.5;
	}
	
	fireChance = 2;
	
	if( isdefined( self.enemy ) && IsPlayer( self.enemy ) )
	{
		fireChance = 1;
	}
	
	fireCount = 1;
	
	while( time < totalFireTime )
	{
		self FireWeapon( 1, self.enemy );
		
		fireCount++;
		wait fireTime;
		time += fireTime;
	}
	
	if( is_minigun )
	{
		self SetTurretSpinning( false );
	}
}

function pallas_turret_alert_sound()
{
	self playsound ("veh_pallas_turret_lock");

		
}


function pallas_turret_set_team( team )
{
	self.team = team;

	if( !isdefined( self.off ) )
	{
		pallas_turret_blink_lights();
	}
}

function pallas_turret_blink_lights()
{
	self endon( "death" );
	
	self vehicle::lights_off();
	wait 0.1;
	self vehicle::lights_on();
}

function pallas_turret_emped()
{
	self endon( "death" );
	self notify( "emped" );
	self endon( "emped" );
	
	self.emped = true;
	PlaySoundAtPosition( "veh_pallas_turret_emp_down", self.origin );
	self.turretRotScale = 0.2;
	self pallas_turret_off();
	if( !isdefined( self.stun_fx) )
	{
		self.stun_fx = Spawn( "script_model", self.origin );
		self.stun_fx SetModel( "tag_origin" );
		self.stun_fx LinkTo( self, "tag_fx", (0,0,0), (0,0,0) );
		PlayFXOnTag( level._effect[ "pallas_turret_stun" ], self.stun_fx, "tag_origin" );
	}
	
	wait RandomFloatRange( 6, 10 );
	
	self.stun_fx delete();
	
	self.emped = undefined;
	self pallas_turret_on();
}
	
function clear_last_attacker( time )
{
	self endon( "death" );
	self notify( "clear_last_attacker" );
	self endon( "clear_last_attacker" );
	
	wait time;
	
	self.last_atacker = undefined;
}
	
function PallasTurretCallback_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName,  vSurfaceNormal )
{
	if( weapon.isEmp && sMeansOfDeath != "MOD_IMPACT" )
	{
		driver = self GetSeatOccupant( 0 );
		if( !isdefined(driver) )
		{
			self thread pallas_turret_emped();
		}
	}

	if( IsPlayer( eAttacker ) )
	{
		self.last_atacker = eAttacker;
		self thread clear_last_attacker( 2 );
	}
	
	return iDamage;
}

