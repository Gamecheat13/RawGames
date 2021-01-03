#using scripts\codescripts\struct;

#using scripts\shared\array_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\math_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\statemachine_shared;
#using scripts\shared\system_shared;
#using scripts\shared\turret_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicle_ai_shared;
#using scripts\shared\vehicle_death_shared;
#using scripts\shared\vehicle_shared;
#using scripts\shared\vehicles\_wasp;
#using scripts\shared\visionset_mgr_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\weapons\_heatseekingmissile;

#using scripts\mp\_util;
#using scripts\mp\gametypes\_shellshock;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\killstreaks\_airsupport;
#using scripts\mp\killstreaks\_helicopter;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_qrdrone;
#using scripts\mp\killstreaks\_rcbomb;
#using scripts\mp\killstreaks\_remote_weapons;
#using scripts\mp\teams\_teams;

  
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
                                             
                                                                                                             	     	                                                                                                                                                                
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#precache( "string", "mpl_killstreak_sentinel_strt" );
#precache( "string", "KILLSTREAK_SENTINEL_HACKED" );
#precache( "string", "KILLSTREAK_SENTINEL_INBOUND" );
#precache( "string", "KILLSTREAK_SENTINEL_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_SENTINEL_EARNED" );
#precache( "string", "KILLSTREAK_SENTINEL_NOT_PLACEABLE" );
#precache( "string", "KILLSTREAK_DESTROYED_SENTINEL" );
                    
#precache( "triggerstring", "KILLSTREAK_SENTINEL_USE_REMOTE" );

#namespace sentinel;




function init()
{
	killstreaks::register( "sentinel", "sentinel", "killstreak_" + "sentinel", "sentinel" + "_used", &ActivateSentinel, true );
	killstreaks::register_strings( "sentinel", &"KILLSTREAK_SENTINEL_EARNED", &"KILLSTREAK_SENTINEL_NOT_AVAILABLE", &"KILLSTREAK_SENTINEL_INBOUND", undefined, &"KILLSTREAK_SENTINEL_HACKED" );
	killstreaks::register_dialog( "sentinel", "mpl_killstreak_sentinel_strt", "sentinelDialogBundle", "sentinelPilotDialogBundle", "friendlySentinel", "enemySentinel", "enemySentinelMultiple", "friendlySentinelHacked", "enemySentinelHacked", "requestSentinel", "threatSentinel" );
	killstreaks::register_alt_weapon( "sentinel", "killstreak_remote" );
	killstreaks::register_alt_weapon( "sentinel", "sentinel_turret" );
	remote_weapons::RegisterRemoteWeapon( "sentinel", &"KILLSTREAK_SENTINEL_USE_REMOTE", &StartSentinelRemoteControl, &EndSentinelRemoteControl, false );
	
	// TODO: Move to killstreak data
	level.killstreaks["sentinel"].threatOnKill = true;

	vehicle::add_main_callback( "veh_sentinel_mp", &InitSentinel );
	
	visionset_mgr::register_info( "visionset", "sentinel_visionset", 1, 100, 16, true, &visionset_mgr::ramp_in_out_thread_per_player, false  );
}

function InitSentinel()
{
	self.settings = struct::get_script_bundle( "vehiclecustomsettings", self.scriptbundlesettings );
	Target_Set( self, ( 0, 0, 0 ) );
	self.health = self.healthdefault;
	self.numFlares = 1;
	self vehicle::friendly_fire_shield();
	self EnableAimAssist();
	self SetNearGoalNotifyDist( ( 40 ) );
	self SetHoverParams( ( 50.0 ), ( 100.0 ), ( 100.0 ) );
	self.fovcosine = 0; // +/-90 degrees = 180
	self.fovcosinebusy = 0;	//+/- 55 degrees = 110 fov
	self.vehAirCraftCollisionEnabled = true;
	
	self thread vehicle_ai::nudge_collision();
	self thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile( "explode", "death" );			// fires chaff if needed
	self thread helicopter::create_flare_ent( (0,0,-20) );
	self thread audio::vehicleSpawnContext();
	self.do_scripted_crash = false;
	
	self.overrideVehicleDamage = &SentinelDamageOverride;
	self.selfDestruct = false;
	
	self vehicle_ai::init_state_machine_for_role( "default" );
	self vehicle_ai::get_state_callbacks( "combat" ).enter_func = &wasp::state_combat_enter;
    self vehicle_ai::get_state_callbacks( "combat" ).update_func = &wasp::state_combat_update;
   	self vehicle_ai::get_state_callbacks( "death" ).update_func = &wasp::state_death_update;
   	self vehicle_ai::get_state_callbacks( "driving" ).enter_func = &driving_enter;
 
   	wasp::init_guard_points();
   	self vehicle_ai::add_state( "guard",
		undefined,
		&wasp::state_guard_update,
		undefined );

   	vehicle_ai::add_utility_connection( "combat", "guard", &wasp::state_guard_can_enter );
	vehicle_ai::add_utility_connection( "guard", "combat" );
	vehicle_ai::add_interrupt_connection( "guard",	"emped",	"emped" );
	vehicle_ai::add_interrupt_connection( "guard",	"surge",	"surge" );
	vehicle_ai::add_interrupt_connection( "guard",	"off",		"shut_off" );
	vehicle_ai::add_interrupt_connection( "guard",	"pain",		"pain" );
	vehicle_ai::add_interrupt_connection( "guard",	"driving",	"enter_vehicle" );
  	
	self vehicle_ai::StartInitialState( "combat" );
}

function driving_enter( params )
{
	vehicle_ai::defaultstate_driving_enter( params );
		
	if( isdefined( params.driver ) )
	{
		params.driver.ignoreme = true;
	}
}

function drone_pain_for_time( time, stablizeParam, restoreLookPoint, weapon )
{
	self endon( "death" );
	
	self.painStartTime = GetTime();

	if ( !( isdefined( self.inpain ) && self.inpain ) && isdefined( self.health ) && self.health > 0 )
	{
		self.inpain = true;
		

		while ( GetTime() < self.painStartTime + time * 1000 )
		{
			self SetVehVelocity( self.velocity * stablizeParam );
			self SetAngularVelocity( self GetAngularVelocity() * stablizeParam );
			wait 0.1;
		}

		if ( isdefined( restoreLookPoint ) && isdefined( self.health ) && self.health > 0 )
		{
			restoreLookEnt = Spawn( "script_model", restoreLookPoint );
			restoreLookEnt SetModel( "tag_origin" );

			self ClearLookAtEnt();
			self SetLookAtEnt( restoreLookEnt );
			self setTurretTargetEnt( restoreLookEnt );
			wait 1.5;

			self ClearLookAtEnt();
			self ClearTurretTarget();
			restoreLookEnt delete();
		}
		
		if( weapon.isEmp ) remote_weapons::set_static( 0 );

		self.inpain = false;
	}
}

function drone_pain( eAttacker, damageType, hitPoint, hitDirection, hitLocationInfo, partName, weapon )
{
	if ( !( isdefined( self.inpain ) && self.inpain ) )
	{
		yaw_vel = math::randomSign() * RandomFloatRange( 280, 320 );

		ang_vel = self GetAngularVelocity();
		ang_vel += ( RandomFloatRange( -120, -100 ), yaw_vel, RandomFloatRange( -200, 200 ) );
		self SetAngularVelocity( ang_vel );

		self thread drone_pain_for_time( 0.8, 0.7, undefined, weapon );
	}
}

function SentinelDamageOverride( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	if( sMeansOfDeath == "MOD_TRIGGER_HURT" )
		return 0;
	
	emp_damage = self.healthdefault * ( 0.5 ) + 0.5;
	
	iDamage = killstreaks::OnDamagePerWeapon( "sentinel", eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, self.maxhealth, &destroyed_cb, self.maxhealth*0.4, &low_health_cb, emp_damage, undefined, true, 1.0 );	
	
	if( isdefined( eAttacker ) && isdefined( eAttacker.team ) && eAttacker.team != self.team )
	{
		drone_pain( eAttacker, sMeansOfDeath, vPoint, vDir, sHitLoc, partName, weapon );
	}
	
	return iDamage;
}

function destroyed_cb( attacker, weapon )
{
	if( isdefined( attacker ) && isdefined( attacker.team ) && attacker.team != self.team )
		self.owner.dofutz = true;
}

function low_health_cb( attacker, weapon )
{
	if( self.playedDamaged == false )
	{
		self killstreaks::play_pilot_dialog_on_owner( "damaged", "sentinel", self.killstreak_id );
		self.playedDamaged = true;
	}
}
	
function ActivateSentinel( killstreakType )
{
	assert( IsPlayer( self ) );
	player = self;
	
	if( !IsNavVolumeLoaded() )
	{
		/# IPrintLnBold( "Error: NavVolume Not Loaded" ); #/
		self iPrintLnBold( &"KILLSTREAK_SENTINEL_NOT_AVAILABLE" );
		return false;
	}
	
	spawnPos = rcbomb::calculateSpawnOrigin( player.origin, player.angles );
	if( !isdefined( spawnPos ) )
	{
		self iPrintLnBold( &"KILLSTREAK_SENTINEL_NOT_PLACEABLE" );
		return false;
	}
	
	killstreak_id = player killstreakrules::killstreakStart( "sentinel", player.team, false, true );
	if( killstreak_id == (-1) )
	{
		return false;
	}
	
	player AddWeaponStat( GetWeapon( "sentinel" ), "used", 1 );
	
	sentinel = SpawnVehicle( "veh_sentinel_mp", spawnPos.origin + ( 0, 0, ( 50 ) ), spawnPos.angles, "dynamic_spawn_ai" );
	
	sentinel killstreaks::configure_team( "sentinel", killstreak_id, player, "small_vehicle", undefined, &ConfigureTeamPost );
	sentinel killstreak_hacking::enable_hacking( "sentinel", &HackedCallbackPre, &HackedCallbackPost );
	sentinel.killstreak_id = killstreak_id;
	sentinel.killstreak_end_time = GetTime() + ( 60000 );
	sentinel.original_vehicle_type = sentinel.vehicletype;
	sentinel.ignore_vehicle_underneath_splash_scalar = true;

	sentinel clientfield::set( "enemyvehicle", 1 );
	sentinel.hardpointType = "sentinel";
	sentinel.soundmod = "drone_land";

	sentinel.maxhealth = killstreak_bundles::get_max_health( "sentinel" );
	sentinel.health = sentinel.maxhealth;
	sentinel.hackedhealth = killstreak_bundles::get_hacked_health( "sentinel" );
	sentinel.rocketDamage = ( sentinel.maxhealth / ( 1 ) ) + 1;	
	sentinel.playedDamaged = false;
	
	sentinel.goalradius = ( 750 );
	sentinel.goalHeight = 500;
	//sentinel SetGoal( player, false, sentinel.goalRadius, sentinel.goalHeight );
	sentinel.enable_guard = true;
	sentinel.always_face_enemy = true;
		
	sentinel thread killstreaks::WaitForTimeout( "sentinel", ( 60000 ), &OnTimeout, "sentinel_shutdown" );
	sentinel thread WatchWater();
	sentinel thread WatchDeath();
	sentinel thread WatchShutdown();
	
	player remote_weapons::UseRemoteWeapon( sentinel, "sentinel", false );
	
	sentinel killstreaks::play_pilot_dialog_on_owner( "arrive", "sentinel", killstreak_id );
	
	sentinel vehicle::init_target_group();
	sentinel vehicle::add_to_target_group( sentinel );
	
	self killstreaks::play_killstreak_start_dialog( "sentinel", self.team, killstreak_id );
	
	sentinel thread WatchGameEnded();

	return true;
}

function HackedCallbackPre( hacker )
{
	sentinel = self;
	sentinel.owner unlink();
	sentinel clientfield::set( "vehicletransition", 0 );
	visionset_mgr::deactivate( "visionset", "sentinel_visionset", sentinel.owner );
	sentinel.owner remote_weapons::RemoveAndAssignNewRemoteControlTrigger( sentinel.useTrigger );
	sentinel remote_weapons::EndRemoteControlWeaponUse( true );
	EndSentinelRemoteControl( sentinel, true );
}

function HackedCallbackPost( hacker )
{
	sentinel = self;

	hacker remote_weapons::UseRemoteWeapon( sentinel, "sentinel", false );
	sentinel notify("WatchRemoteControlDeactivate_remoteWeapons");
	sentinel.killstreak_end_time = hacker killstreak_hacking::set_vehicle_drivable_time_starting_now( sentinel );
}

function ConfigureTeamPost( owner, isHacked )
{
	sentinel = self;
	sentinel thread WatchTeamChange();
}

function WatchGameEnded()
{
	sentinel = self;
	sentinel endon( "death" );
	
	level waittill("game_ended");

	sentinel.abandoned = true;
	sentinel.selfDestruct = true;
	sentinel notify( "sentinel_shutdown" );
}

function StartSentinelRemoteControl( sentinel )
{
	player = self;
	assert( IsPlayer( player ) );
	
	sentinel UseVehicle( player, 0 );
	
	sentinel clientfield::set( "vehicletransition", 1 );
	sentinel thread audio::sndUpdateVehicleContext(true);
	sentinel thread vehicle::monitor_missiles_locked_on_to_me( player );
	
	sentinel.inHeliProximity = false;
	
	minHeightOverride = undefined;
	minz_struct = struct::get( "vehicle_oob_minz", "targetname");
	if( isdefined( minz_struct ) )
		minHeightOverride = minz_struct.origin[2];			
	
	sentinel thread qrdrone::QRDrone_watch_distance( ( 0 ), minHeightOverride );
	sentinel.distance_shutdown_override = &SentinelDistanceFailure;
	
	player vehicle::set_vehicle_drivable_time( ( 60000 ), sentinel.killstreak_end_time );
	visionset_mgr::activate( "visionset", "sentinel_visionset", player, 1, 90000, 1 );	

	if ( isdefined( sentinel.PlayerDrivenVersion ) )
		sentinel SetVehicleType( sentinel.PlayerDrivenVersion );
}

function EndSentinelRemoteControl( sentinel, exitRequestedByOwner )
{
	if ( isdefined( sentinel.owner ) )
	{
		sentinel.owner vehicle::stop_monitor_missiles_locked_on_to_me();
		visionset_mgr::deactivate( "visionset", "sentinel_visionset", sentinel.owner );
	}

	if( exitRequestedByOwner )
	{
		if ( isdefined( sentinel.owner ) )
		{
			sentinel.owner qrdrone::destroyHud();
			sentinel.owner unlink();
			sentinel clientfield::set( "vehicletransition", 0 );
		}
		sentinel thread audio::sndUpdateVehicleContext(false);
	}
	
	if ( isdefined( sentinel.original_vehicle_type ) )
		sentinel SetVehicleType( sentinel.original_vehicle_type );
	
}

function OnTimeout()
{
	sentinel = self;
	
	sentinel killstreaks::play_pilot_dialog_on_owner( "timeout", "sentinel" );
	
	sentinel notify( "sentinel_shutdown" );
}

function SentinelDistanceFailure()
{
	sentinel = self;
	
	sentinel notify( "sentinel_shutdown" );
}

function WatchDeath()
{
	sentinel = self;
	sentinel waittill( "death", attacker, type, weapon );
	sentinel notify( "sentinel_shutdown" );
	
	if ( IsPlayer( attacker ) )
	{
		scoreevents::processScoreEvent( "destroyed_sentinel", attacker, sentinel.owner, weapon );
		LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_SENTINEL", attacker.entnum );
		
		sentinel killstreaks::play_destroyed_dialog_on_owner(  "sentinel", sentinel.killstreak_id );
	}
}

function WatchTeamChange()
{
	self notify( "Sentinel_WatchTeamChange_Singleton" );
	self endon ( "Sentinel_WatchTeamChange_Singleton" );
	sentinel = self;
	
	sentinel endon( "sentinel_shutdown" );
	sentinel.owner util::waittill_any( "joined_team", "disconnect", "joined_spectators", "emp_jammed" );
	sentinel notify( "sentinel_shutdown" );
}





	
function WatchWater()
{
	sentinel = self;
	sentinel endon( "sentinel_shutdown" );
			
	while( true )
	{
		wait ( 0.1 );
		trace = physicstrace( self.origin + ( 0, 0, 10 ), self.origin + ( 0, 0, 6 ), ( -2, -2, -2 ), (  2,  2,  2 ), self, ( (1 << 2) ));
		if( trace["fraction"] < 1.0 )
			break;
	}
	
	sentinel notify( "sentinel_shutdown" );
}

function WatchShutdown()
{
	sentinel = self;
	
	sentinel waittill( "sentinel_shutdown" );
	
	if( ( isdefined( sentinel.control_initiated ) && sentinel.control_initiated ) || ( isdefined( sentinel.controlled ) && sentinel.controlled ) )
	{
		sentinel remote_weapons::EndRemoteControlWeaponUse( false );
		while( ( isdefined( sentinel.control_initiated ) && sentinel.control_initiated ) || ( isdefined( sentinel.controlled ) && sentinel.controlled ) )
			{wait(.05);};
	}
	
	if( isdefined( sentinel.owner ) )
	{
		sentinel.owner qrdrone::destroyHud();
	}
	
	killstreakrules::killstreakStop( "sentinel", sentinel.originalTeam, sentinel.killstreak_id );
	
	if( isalive( sentinel ) )
		sentinel Kill();
}