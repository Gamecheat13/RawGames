#using scripts\codescripts\struct;

#using scripts\mp\_util;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_emp;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_placeables;
#using scripts\mp\killstreaks\_remote_weapons;
#using scripts\mp\teams\_teams;

#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\turret_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicle_death_shared;

  
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#precache( "string", "KILLSTREAK_EARNED_AUTO_TURRET" );
#precache( "string", "KILLSTREAK_AUTO_TURRET_INBOUND" );
#precache( "string", "KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_AUTO_TURRET_HACKED" );
#precache( "string", "KILLSTREAK_DESTROYED_AUTO_TURRET" );
#precache( "triggerstring", "KILLSTREAK_AUTO_TURRET_PLACE_TURRET_HINT" );
#precache( "triggerstring", "KILLSTREAK_AUTO_TURRET_INVALID_TURRET_LOCATION" );
#precache( "triggerstring", "KILLSTREAK_SENTRY_TURRET_PICKUP" );
#precache( "triggerstring", "MP_REMOTE_USE_TURRET" );
#precache( "string", "mpl_killstreak_auto_turret" );
#precache( "model", "wpn_t7_none_world" );



#namespace turret;

function init()
{
	killstreaks::register( "autoturret", "autoturret", "killstreak_auto_turret", "auto_turret_used", &ActivateTurret );
	killstreaks::register_alt_weapon( "autoturret", "auto_gun_turret" );
	killstreaks::register_remote_override_weapon( "autoturret", "killstreak_remote_turret" );
	killstreaks::register_strings( "autoturret", &"KILLSTREAK_EARNED_AUTO_TURRET", &"KILLSTREAK_AUTO_TURRET_NOT_AVAILABLE", &"KILLSTREAK_AUTO_TURRET_INBOUND", undefined, &"KILLSTREAK_AUTO_TURRET_HACKED", false );
	killstreaks::register_dialog( "autoturret", "mpl_killstreak_auto_turret", "turretDialogBundle", undefined, "friendlyTurret", "enemyTurret", "enemyTurretMultiple", "friendlyTurretHacked", "enemyTurretHacked", "requestTurret", "threatTurret" );
			
	// TODO: Move to killstreak data
	level.killstreaks["autoturret"].threatOnKill = true;
	
	remote_weapons::RegisterRemoteWeapon( "autoturret", &"MP_REMOTE_USE_TURRET", &StartTurretRemoteControl, &EndTurretRemoteControl, true );
	vehicle::add_main_callback( "sentry_turret", &InitTurret );
}

function InitTurret()
{
	turretVehicle = self;
	turretVehicle.delete_on_death = true;	
	
	turretVehicle.maxhealth = ( 1800 );
	
	tableHealth = killstreak_bundles::get_max_health( "autoturret" );
	
	if ( isdefined( tableHealth ) )
	{
		turretVehicle.maxhealth = tableHealth;

	}
	
	turretVehicle.health = turretVehicle.maxhealth;
	
	turretVehicle turret::set_max_target_distance( ( 2500 ), 0 );
	turretVehicle turret::set_on_target_angle( ( 15 ), 0 );
	turretVehicle clientfield::set( "enemyvehicle", 1 );
	turretVehicle.soundmod = "drone_land";
	//turretVehicle NotSolid();
	
	turretVehicle.overrideVehicleDamage = &OnTurretDamage;
	turretVehicle.overrideVehicleDeath = &OnTurretDeath;
}

function ActivateTurret()
{
	player = self;
	assert( IsPlayer( player ) );
	
	killstreakId = self killstreakrules::killstreakStart( "autoturret", player.team, false, false );
	if( killstreakId == (-1) )
	{
		return false;
	}
	
	bundle = level.killstreakBundle["autoturret"];

	turret = player placeables::SpawnPlaceable( "autoturret", killstreakId,
	                                            &OnPlaceTurret, &OnCancelPlacement, &OnPickupTurret, &OnShutdown, undefined, undefined,
	                                            "wpn_t7_none_world", "veh_t7_turret_sentry_gun_world_yellow", "veh_t7_turret_sentry_gun_world_red", 
	                                            &"KILLSTREAK_SENTRY_TURRET_PICKUP", ( 90000 ), undefined, 0, bundle.ksPlaceableHint, bundle.ksPlaceableInvalidLocationHint );
	
	turret thread WatchTurretShutdown( killstreakId, player.team );
	
	event = turret util::waittill_any_return( "placed", "cancelled", "death" );
	if( event != "placed" )
	{
		return false;
	}
	
	turret playsound ("mpl_turret_startup");
	return true;
}

function OnPlaceTurret( turret )
{
	player = self;
	assert( IsPlayer( player ) );
	
	if( isdefined( turret.vehicle ) )
	{
		turret.vehicle.origin = turret.origin;
		turret.vehicle.angles = turret.angles;
		{wait(.05);};
		turret.vehicle Show();
		turret.vehicle playsound ("mpl_turret_startup");
	}
	else
	{
		turret.vehicle = SpawnVehicle( "sentry_turret", turret.origin, turret.angles, "dynamic_spawn_ai" );
		turret.vehicle.owner = player;
		turret.vehicle SetOwner( player );
		turret.vehicle.ownerEntNum = player.entNum;
		turret.vehicle.parentStruct = turret;
		
		turret.vehicle.team = player.team;
		turret.vehicle SetTeam( player.team );
		turret.vehicle turret::set_team( player.team, 0 );
		turret.vehicle.ignore_vehicle_underneath_splash_scalar = true;
		
		turret.vehicle CreateTurretInfluencer( "turret" );
		turret.vehicle CreateTurretInfluencer( "turret_close" );
		
		player killstreaks::play_killstreak_start_dialog( "autoturret", player.pers["team"], turret.killstreakId );
		level thread popups::DisplayKillstreakTeamMessageToAll( "autoturret", player );
	}

	turret.vehicle turret::enable( 0, false );
	Target_Set( turret.vehicle, ( 0, 0, 36 ) );
	turret.vehicle Unlink();
	
	player remote_weapons::UseRemoteWeapon( turret.vehicle, "autoturret", false );
}

function OnCancelPlacement( turret )
{
	turret notify( "sentry_turret_shutdown" );
}

function OnPickupTurret( turret )
{
	player = self;
	turret.vehicle Ghost();
	turret.vehicle turret::disable( 0 );
	turret.vehicle LinkTo( turret );
	Target_Remove( turret.vehicle );
	
	if( isdefined( turret.vehicle.useTrigger ) )
	{
		turret.vehicle.useTrigger Delete();
		turret.vehicle playsound ("mpl_turret_down");
	}
}

function OnTurretDamage( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	empDamage = int( iDamage + ( self.healthdefault * ( 1 ) ) + 0.5 );
	
	iDamage = self killstreaks::OnDamagePerWeapon( "autoturret", eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, self.maxhealth, undefined, self.maxhealth*0.4, undefined, empDamage, undefined, true, 1.0 );

	return iDamage;
}

function OnTurretDeath( eInflictor, eAttacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime )
{
	turretVehicle = self;
	
	if( isdefined( turretVehicle.parentStruct ) )
	{
		turretVehicle.parentStruct placeables::ForceShutdown();
		
		turretVehicle.parentStruct killstreaks::play_destroyed_dialog_on_owner( turretVehicle.parentStruct.killstreakType, turretVehicle.parentStruct.killstreakId );
	}
	
	if ( IsPlayer( eAttacker ) )
	{
		scoreevents::processScoreEvent( "destroyed_sentry_gun", eAttacker, self, weapon );
		LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_AUTO_TURRET", eAttacker.entnum );
	}
	
	turretVehicle vehicle_death::death_fx();
}

function OnShutdown( turret )
{
	turret notify( "sentry_turret_shutdown" );
}

function StartTurretRemoteControl( turretVehicle )
{
	player = self;
	assert( IsPlayer( player ) );
	
	turretVehicle turret::disable( 0 );
	turretVehicle UseVehicle( player, 0 );
	turretVehicle clientfield::set( "vehicletransition", 1 );
}

function EndTurretRemoteControl( turretVehicle, exitRequestedByOwner )
{
	if( exitRequestedByOwner )
	{
		turretVehicle thread EnableTurretAfterWait( 0.1 ); // currently, this must be called after the player leaves the vehicle
	}
	turretVehicle clientfield::set( "vehicletransition", 0 );
}

function EnableTurretAfterWait( wait_time ) // self == turretVehicle
{
	self endon ( "death" );
	if ( isdefined( self.owner ) )
	{
		self.owner endon( "joined_team" );
		self.owner endon( "disconnect" );
		self.owner endon( "joined_spectators" );
	}

	wait wait_time;
	self turret::enable( 0, false );	
}

function CreateTurretInfluencer( name )
{
	turret = self;
	
	preset = GetInfluencerPreset( name );
	
	if ( !IsDefined( preset ) )
	{
		return;
	}
		
	// place the influencer out infront of the turret
	projected_point = turret.origin + VectorScale( AnglesToForward( turret.angles ), preset["radius"] * 0.7 );
	return spawning::create_enemy_influencer( name, turret.origin, turret.team );
}

function WatchTurretShutdown( killstreakId, team )
{
	turret = self;
	
	turret waittill( "sentry_turret_shutdown" );
	
	killstreakrules::killstreakStop( "autoturret", team, killstreakId );
	
	if( isdefined( turret.vehicle ) )
	{
		turret.vehicle spawning::remove_influencers();
		turret.vehicle playsound ("mpl_turret_exp");
		// turret.vehicle Delete(); // do not delete, have it killed instead
	}
}
