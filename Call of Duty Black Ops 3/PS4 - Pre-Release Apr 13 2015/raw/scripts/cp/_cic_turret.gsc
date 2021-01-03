#using scripts\codescripts\struct;

#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                       	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     	                                                              	                                                          	                                   	                                   	                                                    	                                       
       

#precache( "eventstring", "hud_cic_weapon_heat" );
#precache( "fx", "destruct/fx_dest_turret_1" );
#precache( "fx", "destruct/fx_dest_turret_2" );
#precache( "fx", "_t6/destructibles/fx_cic_turret_death" );
#precache( "fx", "_t6/electrical/fx_elec_sp_emp_stun_cic_turret" );
#precache( "fx", "_t6/electrical/fx_elec_sp_emp_stun_sentry_turret" );

#namespace cic_turret;

function autoexec __init__sytem__() {     system::register("cic_turret",&__init__,undefined,undefined);    }

function __init__()
{
	vehicle::add_main_callback( "turret_cic",		&cic_turret_think );
	vehicle::add_main_callback( "turret_cic_world",	&cic_turret_think );
	vehicle::add_main_callback( "turret_sentry",		&cic_turret_think );
	vehicle::add_main_callback( "turret_sentry_world",&cic_turret_think );
	vehicle::add_main_callback( "turret_sentry_cic",&cic_turret_think );
	vehicle::add_main_callback( "turret_sentry_rts",	&cic_turret_think );

	level._effect[ "cic_turret_damage01" ]	= "destruct/fx_dest_turret_1";
	level._effect[ "cic_turret_damage02" ]	= "destruct/fx_dest_turret_2";
	level._effect[ "sentry_turret_damage01" ]	= "destruct/fx_dest_turret_1";
	level._effect[ "sentry_turret_damage02" ]	= "destruct/fx_dest_turret_2";
	level._effect[ "cic_turret_death" ]	= "_t6/destructibles/fx_cic_turret_death";
	
	level._effect[ "cic_turret_stun" ]	= "_t6/electrical/fx_elec_sp_emp_stun_cic_turret";
	level._effect[ "sentry_turret_stun" ]	= "_t6/electrical/fx_elec_sp_emp_stun_sentry_turret";
}

function cic_turret_think()
{
	self EnableAimAssist();
	
	if( isSubStr(self.vehicletype,"cic") )
	{
		self.scanning_arc = 60;
		self.default_pitch = 15;
	}
	else
	{
		self.scanning_arc = 60;
		self.default_pitch = 0;
	}
	
	self.state_machine = statemachine::create( "brain", self );
	
	main 		= self.state_machine statemachine::add_state( "main", undefined, &cic_turret_main, undefined );
	scripted 	= self.state_machine statemachine::add_state( "scripted", undefined, &cic_turret_scripted, undefined );
	
	vehicle_ai::set_role( "brain" );

	vehicle_ai::add_interrupt_connection( "main", "scripted", "enter_vehicle" );
	vehicle_ai::add_interrupt_connection( "main", "scripted", "scripted" );
	vehicle_ai::add_interrupt_connection( "scripted", "main", "exit_vehicle" );
	vehicle_ai::add_interrupt_connection( "scripted", "main", "scripted_done" );
	
	// Navmesh
	self DisconnectPaths();
	//self SetVehicleAvoidance( true, 22 );
	
	self thread cic_turret_death();
	self thread cic_turret_damage();
	self thread turret::track_lens_flare();
	
	self.overrideVehicleDamage =&CICTurretCallback_VehicleDamage;
	
	// Set the first state
	if ( isdefined( self.script_startstate ) )
	{
		if( self.script_startstate == "off" )
			self cic_turret_off( self.angles );
		else
			self.state_machine statemachine::set_state( self.script_startstate );
	}
	else
	{
		// Set the first state
		cic_turret_start_ai();
	}

	self laserOn();
}

function cic_turret_start_scripted()
{
	self.state_machine statemachine::set_state( "scripted" );
}

function cic_turret_start_ai()
{
	self.state_machine statemachine::set_state( "main" );
}

function cic_turret_main( params )
{
	if( IsAlive( self ) )
	{
		self EnableAimAssist();
		self thread cic_turret_fireupdate();
	}
}


function cic_turret_off(angles)
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
	self.ignoreme = true;
}


function cic_turret_on()
{
	self endon( "death" );
	
	self playsound ("veh_cic_turret_boot");
	self vehicle::lights_on();
	self EnableAimAssist();
	self vehicle::toggle_sounds( 1 );
	self bootup();
	self vehicle::toggle_exhaust_fx( 1 );
	self.off = undefined;
	self LaserOn();
	cic_turret_start_ai();
	self.ignoreme = false;
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

function cic_turret_fireupdate()
{
	self endon( "death" );
	self endon( "change_state" );
	
	cant_see_enemy_count = 0;

	wait 0.2;

	origin = self GetTagOrigin( "tag_barrel" );
	
	left_look_at_pt = origin + AnglesToForward( self.angles + (self.default_pitch, self.scanning_arc, 0) ) * 1000;
	right_look_at_pt = origin + AnglesToForward( self.angles + (self.default_pitch, -self.scanning_arc, 0) ) * 1000;
	
	while( 1 )
	{
	
		if( isdefined( self.enemy ) && self VehCanSee( self.enemy ) )
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
				if( isdefined( self.enemy ) && IsAlive( self.enemy) && self VehCanSee( self.enemy ) )
				{
					self SetTurretTargetEnt( self.enemy );
					wait 0.1;
					self cic_turret_fire_for_time( RandomFloatRange( 0.4, 1.5 ) );
				}
				else
				{
					self ClearTargetEntity();
				}
				
				if( isdefined( self.enemy ) && IsPlayer( self.enemy ) )
					wait RandomFloatRange( 0.3, 0.6 );
				else
					wait RandomFloatRange( 0.3, 0.6 ) * 2;
			}
			
			if( isdefined( self.enemy ) && IsAlive( self.enemy ) && self VehCanSee( self.enemy ) )
			{
				if( IsPlayer( self.enemy ) )
					wait RandomFloatRange( 0.5, 1.3 );
				else
					wait RandomFloatRange( 0.5, 1.3 ) * 2;
			}
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

function cic_turret_scripted( params )
{
	// do nothing state
	driver = self GetSeatOccupant( 0 );
	if( isdefined(driver) )
	{
		self.turretRotScale = 1;
		self DisableAimAssist();
		
		if ( driver == level.players[0]	)
		{
			self thread vehicle_death::vehicle_damage_filter( "firestorm_turret" );
			level.players[0] thread cic_overheat_hud( self );
		}
	}
	
	self ClearTargetEntity();
}

function cic_turret_get_damage_effect( health_pct )
{
	if( isSubStr( self.vehicletype, "turret_sentry" ) )
	{
		if( health_pct < .6 )
		{
			return level._effect[ "sentry_turret_damage02" ];
		}
		else
		{
			return level._effect[ "sentry_turret_damage01" ];
		}
	}
	else
	{
		if( health_pct < .6 )
		{
			return level._effect[ "cic_turret_damage02" ];
		}
		else
		{
			return level._effect[ "cic_turret_damage01" ];
		}
	}
}

function cic_turret_play_single_fx_on_tag( effect, tag )
{	
	if( isdefined( self.damage_fx_ent ) )
	{
		if( self.damage_fx_ent.effect == effect )
		{
			// already playing
			return;
		}
		self.damage_fx_ent delete();
	}
	
	if (!isdefined(self GetTagAngles( tag )))
		return;
	
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

function cic_turret_damage()
{
	self endon( "crash_done" );
	
	while( isdefined(self) )
	{
		self waittill( "damage" );
		
		if( self.health > 0 )		
		{
			effect = self cic_turret_get_damage_effect( self.health / self.healthdefault );
			tag = "tag_fx";
				
			cic_turret_play_single_fx_on_tag( effect, tag );			
		}
		
		wait 0.3;
	}
}

function cic_turret_death()
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
	self thread cic_turret_death_movement( attacker, dir );
	
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
	self playsound("veh_cic_turret_sparks");
	fire_ent = Spawn( "script_origin", self.origin );
	fire_ent playloopsound( "veh_cic_turret_dmg_fire_loop", .5 );
}

function cic_turret_death_movement( attacker, hitdir )
{
	self endon( "crash_done" );
	self endon( "death" );
	
	//drone death sounds JM - play 1 shot hit, turn off main loop, thread dmg loop
	self playsound("veh_cic_turret_dmg_hit");
	//self vehicle::toggle_sounds( 0 );
	//self thread cic_turret_dmg_snd();  Unnecessary for ceiling turret? 

	wait 0.1;
	
	self.turretRotScale = 0.5;
	tag_angles = self GetTagAngles( "tag_flash" );
	target_pos = self.origin + AnglesToForward( ( 0, tag_angles[1], 0 ) ) * 1000 + (0,0,-1800);
	
	self SetTurretTargetVec( target_pos );
	
// OAA: Removing the chance of shooting ( per dt bug )
//	if( RandomInt( 100 ) < 40 )
//	{
//		self thread cic_turret_fire_for_time( RandomFloatRange( 0.7, 2.0 ) );
//	}
	
	wait 4;
	
	// failsafe notify
	self notify( "crash_done" );
}

/*
function cic_turret_dmg_snd()
{
	dmg_ent = Spawn("script_origin", self.origin);
	dmg_ent linkto (self);
	dmg_ent PlayLoopSound ("veh_cic_turret_dmg_loop");
	self waittill("crash_done");
	dmg_ent stoploopsound(1);
	wait (2);
	dmg_ent delete();
}
*/

function cic_turret_fire_for_time( totalFireTime )
{
	self endon( "crash_done" );
	self endon( "death" );
	
	cic_turret_alert_sound();
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
		if( isdefined( self.enemy ) && isdefined(self.enemy.attackerAccuracy) && self.enemy.attackerAccuracy == 0 )
		{
			self FireWeapon();
		}
		else if( fireChance > 1 )
		{
			self FireWeapon();
		}
		else
		{
			self FireWeapon();
		}
		
		fireCount++;
		wait fireTime;
		time += fireTime;
	}
	
	if( is_minigun )
	{
		self SetTurretSpinning( false );
	}
}

function cic_turret_alert_sound()    //NOT USING FOR NOW  JM
{
	self playsound ("veh_turret_alert");
}


function cic_turret_set_team( team )
{
	self.team = team;

	if( !isdefined( self.off ) )
	{
		cic_turret_blink_lights();
	}
}

function cic_turret_blink_lights()
{
	self endon( "death" );
	
	self vehicle::lights_off();
	wait 0.1;
	self vehicle::lights_on();
}

function cic_turret_emped()
{
	self endon( "death" );
	self notify( "emped" );
	self endon( "emped" );
	
	self.emped = true;
	PlaySoundAtPosition( "veh_cic_turret_emp_down", self.origin );
	self.turretRotScale = 0.2;
	self cic_turret_off();
	if( !isdefined( self.stun_fx) )
	{
		self.stun_fx = Spawn( "script_model", self.origin );
		self.stun_fx SetModel( "tag_origin" );
		self.stun_fx LinkTo( self, "tag_fx", (0,0,0), (0,0,0) );
		if( isSubStr(self.vehicletype,"turret_sentry") )
			PlayFXOnTag( level._effect[ "sentry_turret_stun" ], self.stun_fx, "tag_origin" );
		else
			PlayFXOnTag( level._effect[ "cic_turret_stun" ], self.stun_fx, "tag_origin" );
	}
	
	wait RandomFloatRange( 6, 10 );
	
	self.stun_fx delete();
	
	self.emped = undefined;
	self cic_turret_on();
}
	
function CICTurretCallback_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName )
{
	if( weapon.isEmp && sMeansOfDeath != "MOD_IMPACT" )
	{
		driver = self GetSeatOccupant( 0 );
		if( !isdefined(driver) )
		{
			self thread cic_turret_emped();
		}
	}
	
	if( weapon == GetWeapon( "shotgun_pump_taser" ) && sMeansOfDeath == "MOD_PISTOL_BULLET" )
	{
		iDamage = Int( iDamage * 3 );//One shot kill at close range
		self thread cic_turret_stunned();
	}
	
	//greatly reduce the damage done by AI
	if( !IsPlayer( eAttacker ) )
	{
		iDamage = Int( iDamage / 4 );
	}
	
	return iDamage;
}


// self == player
function cic_overheat_hud( turret )
{
	self endon( "exit_vehicle" );
	turret endon( "turret_exited" );
	level endon( "player_using_turret" );

	heat = 0;
	overheat = 0;
	while( true )
	{
		if( isdefined( self.viewlockedentity ) )
		{
			old_heat = heat;
			heat = self.viewlockedentity GetTurretHeatValue( 0 );

			old_overheat = overheat;
			overheat = self.viewlockedentity IsVehicleTurretOverheating( 0 );

			if( old_heat != heat || old_overheat != overheat )
			{
				LUINotifyEvent( &"hud_cic_weapon_heat", 2, Int( heat ), overheat );
			}
		}
		{wait(.05);};
	}
}

function cic_turret_stunned()
{
	self endon( "death" );
	self notify( "stunned" );
	self endon( "stunned" );
	
	self.stunned = true;
	self.turretRotScale = 0.2;
	self cic_turret_off();
	if( !isdefined( self.stun_fx) )
	{
		PlaySoundAtPosition( "veh_cic_turret_emp_down", self.origin );
		
		self.stun_fx = Spawn( "script_model", self.origin );
		self.stun_fx SetModel( "tag_origin" );
		self.stun_fx LinkTo( self, "tag_fx", (0,0,0), (0,0,0) );
		if( isSubStr(self.vehicletype,"turret_sentry") )
		{
			PlayFXOnTag( level._effect[ "sentry_turret_stun" ], self.stun_fx, "tag_origin" );
		}
		else
		{
			PlayFXOnTag( level._effect[ "cic_turret_stun" ], self.stun_fx, "tag_origin" );
		}
	}
	
	wait RandomFloatRange( 3, 5 );
	
	self.stun_fx delete();
	
	self.stunned = undefined;
	self cic_turret_on();
}

