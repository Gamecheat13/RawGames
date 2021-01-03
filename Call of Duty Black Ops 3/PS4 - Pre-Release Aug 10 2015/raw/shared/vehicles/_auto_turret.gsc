#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flag_shared;
#using scripts\shared\fx_shared;
#using scripts\shared\math_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_ai_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
       

#namespace auto_turret;

function autoexec __init__sytem__() {     system::register("auto_turret",&__init__,undefined,undefined);    }

function __init__()
{
	vehicle::add_main_callback( "auto_turret",							&turret_initialze );
}

function turret_initialze()
{
	self.health = self.healthdefault;

	if ( isdefined( self.scriptbundlesettings ) )
	{
		self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );
	}
	else
	{
		self.settings = struct::get_script_bundle( "vehiclecustomsettings", "artillerysettings" );
	}

	sightfov = self.settings.sightfov;
	if ( !isdefined( sightfov ) )
	{
		sightfov = 0;
	}
	self.fovcosine = Cos( sightfov - 0.1 );
	self.fovcosinebusy = Cos( sightfov - 0.1 );

	if ( self.settings.disconnectpaths === true )
	{
		self DisconnectPaths();
	}

	if ( self.settings.ignoreme === true )
	{
		self.ignoreme = true;
	}

	if ( self.settings.laseron === true )
	{
		self laserOn();
	}

	// only auto aim if it can fire. if more specific situation comes we can separate aim assist into a separate GDT field
	if ( self.settings.disablefiring !== true )
	{
		self EnableAimAssist();
	}

	self thread turret::track_lens_flare();

	self.overrideVehicleDamage =&turretCallback_VehicleDamage;
	self.allowFriendlyFireDamageOverride = &turretAllowFriendlyFireDamage;

	//disable some cybercom abilities
	if( IsDefined( level.vehicle_initializer_cb ) )
	{
    	[[level.vehicle_initializer_cb]]( self );
	}

	defaultRole();
}

function defaultRole()
{
	self vehicle_ai::init_state_machine_for_role( "default" );

    self vehicle_ai::get_state_callbacks( "death" ).update_func = &state_death_update;
    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &state_combat_update;
    self vehicle_ai::get_state_callbacks( "off" ).enter_func = &state_off_enter;
    self vehicle_ai::get_state_callbacks( "off" ).exit_func = &state_off_exit;
    self vehicle_ai::get_state_callbacks( "emped" ).enter_func = &state_emped_enter;
    self vehicle_ai::get_state_callbacks( "emped" ).exit_func = &state_emped_exit;

	self vehicle_ai::add_state( "unaware",
		undefined,
		&state_unaware_update,
		undefined );

	vehicle_ai::add_interrupt_connection( "unaware",	"scripted",	"enter_scripted" );
	vehicle_ai::add_interrupt_connection( "unaware",	"emped",	"emped" );
	vehicle_ai::add_interrupt_connection( "unaware",	"off",		"shut_off" );
	vehicle_ai::add_interrupt_connection( "unaware",	"driving",	"enter_vehicle" );
	vehicle_ai::add_interrupt_connection( "unaware",	"pain",		"pain" );

	vehicle_ai::add_utility_connection( "unaware",	"combat",	&should_switch_to_combat );
	vehicle_ai::add_utility_connection( "combat",	"unaware",	&should_switch_to_unaware );

	vehicle_ai::StartInitialState( "unaware" );
}

// ----------------------------------------------
// State: death
// ----------------------------------------------
function state_death_update( params )
{
	self endon( "death" );

	self SetTurretSpinning( false );
	self turret::toggle_lensflare( false );
	
	self thread turret_idle_sound_stop();
	self playsound("veh_sentry_turret_dmg_hit");
	self.turretRotScale = 1.5;
	self rest_turret( params.resting_pitch );
	wait 0.5;
	
	self vehicle_ai::defaultstate_death_update( params );
}
// death-----------------------------------------


// ----------------------------------------------
// State: unaware
// ----------------------------------------------
function should_switch_to_unaware( current_state, to_state, connection )
{
	if ( !isdefined( self.enemy ) || !self VehSeenRecently( self.enemy, 1.5 ) )
	{
		return 100;
	}

	return 0;
}

function state_unaware_update( params )
{
	self endon( "death" );
	self endon( "change_state" );

	turret_left = true;
	relativeAngle = 0;

	self thread turret_idle_sound();
	self playsound ("mpl_turret_startup");
	self ClearTargetEntity();

	while( true )
	{
		rotScale = self.settings.scanning_speedscale;
		if ( !isdefined( rotScale ) )
		{
			rotScale = 0.01;
		}
		self.turretRotScale = rotScale;

		scanning_arc = self.settings.scanning_arc;
		if ( !isdefined( scanning_arc ) )
		{
			scanning_arc = 0;
		}
		limits = self GetTurretLimitsYaw();
		scanning_arc = min( scanning_arc, limits[0] - 0.1 );
		scanning_arc = min( scanning_arc, limits[1] - 0.1 );

		if ( scanning_arc > 179 )
		{
			if ( self.turretontarget )
			{
				relativeAngle += 90;
				if ( relativeAngle > 180 )
				{
					relativeAngle -= 360;
				}
			}
			scanning_arc = relativeAngle;
		}
		else
		{
			if ( self.turretontarget )
			{
				turret_left = !turret_left;
			}

			if ( !turret_left )
			{
				scanning_arc *= -1;
			}
		}

		scanning_pitch = self.settings.scanning_pitch;
		if ( !isdefined( scanning_pitch ) )
		{
			scanning_pitch = 0;
		}
		self SetTurretTargetRelativeAngles( ( scanning_pitch, scanning_arc, 0 ) );

		self vehicle_ai::evaluate_connections();
		wait 0.5;
	}
}
// unaware---------------------------------------

// ----------------------------------------------
// State: combat
// ----------------------------------------------
function should_switch_to_combat( current_state, to_state, connection )
{
	if ( isdefined( self.enemy ) && isAlive( self.enemy ) && self VehCanSee( self.enemy ) )
	{
		return 100;
	}

	return 0;
}

function state_combat_update( params )
{
	self endon( "death" );
	self endon( "change_state" );
	
	if( isdefined( self.enemy ) && IsPlayer( self.enemy ) )
	{	
		sentry_turret_alert_sound();
		wait 0.5;
	}

	origin = self GetTagOrigin( "tag_barrel" );
	
	while( 1 )
	{		
		if( isdefined( self.enemy ) && self VehCanSee( self.enemy ) )
		{
			self.turretRotScale = 1;
			
			for( i = 0; i < 3; i++ )
			{
				if( isdefined( self.enemy ) && IsAlive( self.enemy ) && self VehCanSee( self.enemy ) )
				{
					self SetTurretTargetEnt( self.enemy );
					wait 0.1;
					waitTime = RandomFloatRange( 0.4, 1.5 );
					if ( self.settings.disablefiring !== true )
					{
						self sentry_turret_fire_for_time( waitTime, self.enemy );
					}
					else
					{
						wait waitTime;
					}
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

		self vehicle_ai::evaluate_connections();
		wait 0.5;
	}
}

function sentry_turret_fire_for_time( totalFireTime, enemy )
{
	self endon( "death" );
	self endon( "change_state" );
	
	sentry_turret_alert_sound();
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
	
	while( time < totalFireTime )
	{
		self FireWeapon(0, enemy);
		
		wait fireTime;
		time += fireTime;
	}
	
	if( is_minigun )
	{
		self SetTurretSpinning( false );
	}
}
// combat----------------------------------------

// ----------------------------------------------
// State: off
// ----------------------------------------------
function state_off_enter( params )
{
	self vehicle_ai::defaultstate_off_enter( params );

	self.turretRotScale = 0.5;
	self rest_turret( params.resting_pitch );
}

function state_off_exit( params )
{
	self vehicle_ai::defaultstate_off_exit( params );

	self.turretRotScale = 1.0;
	self playsound ("mpl_turret_startup");
}

function rest_turret( resting_pitch )
{
	if ( !isdefined( resting_pitch ) )
	{
		resting_pitch = self.settings.resting_pitch;
	}
		
	if ( !isdefined( resting_pitch ) )
	{
		resting_pitch = 0;
	}
	
	angles = self GetTagAngles( "tag_turret" );

	self SetTurretTargetRelativeAngles( ( resting_pitch, angles[1], 0 ) );
}
// off-------------------------------------------

// ----------------------------------------------
// State: emped
// ----------------------------------------------
function state_emped_enter( params )
{
	self vehicle_ai::defaultstate_emped_enter( params );
	PlaySoundAtPosition( "veh_sentry_turret_emp_down", self.origin );
	self.turretRotScale = 0.5;
	self rest_turret( params.resting_pitch );
}

function state_emped_exit( params )
{
	self vehicle_ai::defaultstate_emped_exit( params );

	self.turretRotScale = 1.0;
	self playsound ("mpl_turret_startup");
}
// emped-----------------------------------------

// ----------------------------------------------
// State: scripted
// ----------------------------------------------
function state_scripted_update( params )
{
	self.turretRotScale = 1;
}
// scripted--------------------------------------

function turretAllowFriendlyFireDamage( eInflictor, eAttacker, sMeansOfDeath, weapon )
{
	if ( isdefined( eAttacker ) && isdefined( sMeansOfDeath ) && sMeansOfDeath == "MOD_EXPLOSIVE" )
	{
		return true;
	}

	return false;
}

function turretCallback_VehicleDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	iDamage = vehicle_ai::shared_callback_damage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal );

	return iDamage;
}

function sentry_turret_alert_sound()
{
	self playsound ("veh_turret_alert");
}

function turret_idle_sound()
{
	if ( !isdefined( self.sndloop_ent ) )
	{
		self.sndloop_ent = Spawn("script_origin", self.origin);
		self.sndloop_ent linkto (self);
		self.sndloop_ent PlayLoopSound ("veh_turret_idle");
	}
}

function turret_idle_sound_stop()
{
	self endon( "death" );

	if ( isdefined( self.sndloop_ent ) )
	{
		self.sndloop_ent stoploopsound( .5 );
		wait( 2 );
		self.sndloop_ent delete();
	}
}
