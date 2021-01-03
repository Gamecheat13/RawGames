
#using scripts\shared\clientfield_shared;
#using scripts\shared\util_shared;
#using scripts\shared\audio_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\_hacker_tool;
#using scripts\shared\visionset_mgr_shared;
    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\_popups;
#using scripts\mp\_util;
#using scripts\shared\scoreevents_shared;
#using scripts\mp\killstreaks\_helicopter;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\shared\killstreaks_shared;
#using scripts\mp\teams\_teams;
#using scripts\shared\callbacks_shared;
#using scripts\mp\killstreaks\_airsupport;

                                            
                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           

#precache( "string", "KILLSTREAK_EARNED_HELICOPTER_GUNNER" );
#precache( "string", "KILLSTREAK_HELICOPTER_GUNNER_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_HELICOPTER_GUNNER_INBOUND" );
#precache( "eventstring", "mpl_killstreak_osprey_strt" );

#namespace helicopter_gunner;



	
	
function init()
{
	killstreaks::register( "helicopter_gunner", "helicopter_player_gunner", "killstreak_helicopter_player_gunner", "helicopter_used", &ActivateHeliGunner, true) ;
	killstreaks::register_strings( "helicopter_gunner", &"KILLSTREAK_EARNED_HELICOPTER_GUNNER", &"KILLSTREAK_HELICOPTER_GUNNER_NOT_AVAILABLE", &"KILLSTREAK_HELICOPTER_GUNNER_INBOUND" );
	killstreaks::register_dialog( "helicopter_gunner", "mpl_killstreak_osprey_strt", 15, 16, 102, 120, 102 );
	killstreaks::register_alt_weapon( "helicopter_gunner", "helicopter_gunner_turret_rockets" );
	killstreaks::register_alt_weapon( "helicopter_gunner", "helicopter_gunner_turret_primary" );
	killstreaks::set_team_kill_penalty_scale( "helicopter_gunner", level.teamKillReducedPenalty );
	killstreaks::devgui_scorestreak_command( "helicopter_gunner", "Debug Paths", "toggle scr_devHeliPathsDebugDraw 1 0");
	
	callback::on_connect( &OnPlayerConnect );
	callback::on_spawned( &UpdatePlayerState );
	callback::on_joined_team( &UpdatePlayerState );
	callback::on_joined_spectate( &UpdatePlayerState );
	callback::on_disconnect( &UpdatePlayerState );
	callback::on_player_killed( &UpdatePlayerState );
	
	visionset_mgr::register_info( "visionset", "helicopter_gunner", 1, 1, 1, true, &visionset_mgr::ramp_in_out_thread_per_player, false  );
		
	level thread WaitForGameEndThread();
	
	level.vtol = undefined;
}

function OnPlayerConnect()
{
	if( !isdefined( self.entNum ) )
	{
		self.entNum = self getEntityNumber();
	}
}

function UpdatePlayerState()
{
	player = self;
	UpdateAllKillstreakInventory();
}

function UpdateAllKillstreakInventory()
{
	foreach( player in level.players )
	{
		if ( isdefined( player.sessionstate ) && player.sessionstate == "playing" )
		{
			UpdateKillstreakInventory( player );
		}
	}
}
	
function UpdateKillstreakInventory( player )
{
	if( !isdefined( player ) )
		return;
	
	heli_team = undefined;
	if( isdefined( level.vtol ) && isdefined( level.vtol.owner ) && !level.vtol.shuttingDown && ( level.vtol.totalRocketHits < ( 4 ) ) )
		heli_team = level.vtol.owner.team;
	
	if( isdefined( heli_team ) && ( player.team == heli_team ) && ( GetFirstAvailableSeat( player ) != -1 ) )
	{
		if( !isdefined( level.vtol.usage[player.entNum] ) )
			player killstreaks::give( "helicopter_gunner", undefined, undefined, true, true );
	}
	else
	{
		if( isdefined( level.vtol ) ) // enemy vtol is in the air
			player killstreaks::take( "helicopter_gunner" );
	}
}

function ActivateHeliGunner( killstreakType )
{
	player = self;
	
	while( isdefined( level.vtol ) && level.vtol.shuttingdown )
	{
		if( !self killstreakrules::isKillstreakAllowed( "helicopter_gunner", self.team ) )
		{
			return false;
		}
	}
	if ( isdefined( level.vtol ) && level.vtol.owner.team != player.team )
	{
		if( !self killstreakrules::isKillstreakAllowed( "helicopter_gunner", self.team ) )
		{
			return false;
		}
	}
	
	isOwner = !isdefined( level.vtol );
	
	result = true;
	
	if( isOwner ) 
	{
		
		player util::freeze_player_controls( true );
		
		result = SpawnHeliGunner( self );
		
		player util::freeze_player_controls( false );
		
		if( level.gameEnded )
		{
			return true;	
		}
		
		if( !isdefined( result ) )
		{
			return false;
		}
	}
	else
	{
		player EnterHelicopter( false );
	}

	return result;
}

function GetFirstAvailableSeat( player )
{
	if( isdefined( level.vtol ) && ( !level.vtol.shuttingDown ) && ( level.vtol.team == player.team ) && ( level.vtol.owner != player ) )
	{
		for( i = 0; i < ( 2 ); i++ )
		{
			if( !isdefined( level.vtol.assistants[i].occupant ) && !level.vtol.assistants[i].destroyed )
			{
				return i;
			}
		}
	}
	
	return -1;
}

function InitHelicopterSeat( index, destroyTag, destroyEvent )
{
	level.vtol.assistants[index] = SpawnStruct();
	assistant = level.vtol.assistants[index];
	
	assistant.occupant = undefined;
	assistant.destroyed = false;
	assistant.targetTag = destroyTag;
	assistant.destroyedEvent = destroyEvent;
	
	assistant.targetEnt = spawn( "script_model", ( 0, 0, 0 ) );
	assistant.targetEnt SetModel( "p7_dogtags_enemy" ); // hack to send ent to clients for targeting
	assistant.targetEnt LinkTo( level.vtol, assistant.targetTag, ( 0, 0, 0 ), ( 0, 0, 0 ) );
	assistant.targetEnt.team = level.vtol.team;
	Target_Set( assistant.targetEnt, ( 0, 0, 0 ) );
	Target_SetAllowHighSteering( assistant.targetEnt, true );
	assistant.targetEnt.parent = level.vtol;
}

function SpawnHeliGunner( owner )
{
	owner endon( "disconnect" );
	level endon( "game_ended" );
	
	if( !isdefined( level.heli_paths ) || !level.heli_paths.size )
	{
		/#println( "No helicopter paths found in map" );#/
		return false;
	}

	if( !isdefined( level.Heli_primary_path ) || !level.heli_primary_path.size )
	{
		/#println( "No primary helicopter path found in map" );#/
		return false;
	}

	if( !self killstreakrules::isKillstreakAllowed( "helicopter_gunner", self.team ) )
	{
		return false;
	}
	
	if( ( isdefined( self.isPlanting ) && self.isPlanting ) || ( isdefined( self.isDefusing ) && self.isDefusing ) || !self IsOnGround() || self util::isUsingRemote() || self IsWallRunning() || self IsPlayerSwimming() )
	{
	    //self iPrintLnBold( &"KILLSTREAK_CHOPPER_GUNNER_NOT_USABLE" );
		return false;
	}
	
	killstreak_id = self killstreakrules::killstreakStart( "helicopter_gunner", owner.team, undefined, true );
	if( killstreak_id == (-1) )
	{
		return false;
	}
	
	startNode = level.heli_primary_path[0];
	
	level.vtol = SpawnVehicle( "veh_bo3_mil_gunship_mp", startnode.origin, startnode.angles, "dynamic_spawn_ai" );
	level.vtol SetTeam( owner.team );
	level.vtol SetOwner( owner );
	level.vtol.killstreak_id = killstreak_id;
	level.vtol.destroyFunc = &DeleteHelicopterCallback;
	level.vtol.hardpointType = "helicopter_gunner";
	level.vtol clientfield::set( "enemyvehicle", 1 );
	level.vtol.team = owner.team;
	level.vtol.owner = owner;
	level.vtol.ownerEntNum = owner.entNum;
	level.vtol.playerMovedRecently = false;
	level.vtol.soundmod = "default_loud";
	level.vtol hacker_tool::registerwithhackertool(( 50 ), ( 10000 ) );
	
	level.vtol.assistants = [];
	level.vtol.usage = [];
	
	InitHelicopterSeat( 0, "tag_gunner_barrel1", "fan_right_destroyed" );
	InitHelicopterSeat( 1, "tag_gunner_barrel2", "fan_left_destroyed" );
	
	level.destructible_callbacks["turret_destroyed"] = &VTOLDestructibleCallback;
	level.destructible_callbacks["turret1_destroyed"] = &VTOLDestructibleCallback;
	level.destructible_callbacks["turret2_destroyed"] = &VTOLDestructibleCallback;
	
	level.vtol.shuttingDown = false;
	level.vtol thread PlayLockOnSoundsThread( owner, level.vtol );
	level.vtol spawning::create_entity_enemy_influencer( "helicopter", level.vtol.team );
	
	level.vtol thread heli_kill_monitor();

	level.vtol.maxhealth = ( 5000 );
	tableHealth = killstreaks::get_max_health( "helicopter_gunner" );
	
	if ( isdefined( tableHealth ) )
	{
		level.vtol.maxhealth = tableHealth;
	}	
	level.vtol.original_health = level.vtol.maxhealth;
	level.vtol.health = level.vtol.maxhealth;
	level.vtol.accum_damage = 0;
	
	level.vtol SetCanDamage( true );
	level.vtol thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile( "death" );
	level.vtol thread WatchMissilesThread();

	attack_nodes = GetEntArray( "heli_attack_area", "targetname" );
	if( attack_nodes.size )
	{
		level.vtol thread HelicopterThinkThread( startNode, attack_nodes );
		owner thread WatchLocationChangeThread( attack_nodes );
	}
	else
	{
		level.vtol thread helicopter::heli_fly( startNode, 0.0, "helicopter_gunner" );
	}
	
	
	
	level.vtol.totalRocketHits = 0;
	level.vtol.turretRocketHits = 0;
	level.vtol.targetEnt = undefined;
	//level.vtol.remoteMissileDamage = level.vtol.maxhealth + 1;
	
	level.vtol.overrideVehicleDamage = &HelicopterGunnerDamageOverride;	
	
	owner thread killstreaks::play_killstreak_start_dialog( "helicopter_gunner", owner.team );
	owner killstreaks::pick_pilot( "helicopter_gunner", 4 );
	owner killstreaks::play_pilot_dialog( "helicopter_gunner", 0, true );
	
	owner EnterHelicopter( true );
	
	level.vtol thread WaitForVTOLShutdownThread();
	level.vtol thread WaitForDeathThread();
	
	//level.vtol.owner thread debug_loop();
	
	return true;
}

function WaitForGameEndThread()
{
	level waittill( "game_ended" );
	if( isdefined( level.vtol ) && isdefined( level.vtol.owner ))
		LeaveHelicopter( level.vtol.owner, true );
}

function WaitForDeathThread()
{
	helicopter = self;
	helicopter endon( "vtol_shutdown" );
	
	helicopter waittill( "death", attacker, mod, weapon );
	
	if ( isdefined( helicopter.owner ) )
	{
		helicopter.owner killstreaks::play_pilot_dialog( "helicopter_gunner", 2 );
		helicopter.owner killstreaks::play_taacom_dialog( "helicopter_gunner", 2 );
	}
	
	helicopter notify( "vtol_shutdown", attacker );
}

function WaitForVTOLShutdownThread()
{
	helicopter = self;
	helicopter waittill( "vtol_shutdown", attacker );
	
	if( isdefined( attacker ) )
	{
		LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_HELICOPTER_GUNNER", attacker.entnum );
	}
	
	if( isdefined( helicopter.targetEnt ) )
	{
		Target_Remove( helicopter.targetEnt );
		helicopter.targetEnt Delete();
		helicopter.targetEnt = undefined;
	}
	
	for( seatIndex = 0; seatIndex < ( 2 ); seatIndex++ )
	{
		assistant = level.vtol.assistants[seatIndex];
		if( isdefined( assistant.targetEnt ) )
		{
			Target_Remove( assistant.targetEnt );
			assistant.targetEnt Delete();
			assistant.targetEnt = undefined;
		}
	}	
	
	killstreakrules::killstreakStop( "helicopter_gunner", helicopter.team, helicopter.killstreak_id );
	
	LeaveHelicopter( level.vtol.owner, true );	
	
	level.vtol = undefined;
	
	helicopter delete();
}

function Spin()
{
	self endon( "explode" );
	speed = RandomIntRange( 180, 220 );
	self setyawspeed( speed, speed, speed );
	while ( isdefined( self ) )
	{
		self settargetyaw( self.angles[1]+(speed*0.9) );
		wait ( 1 );
	}
}

function Explode()
{
	forward = ( self.origin + ( 0, 0, 1 ) ) - self.origin;
	playfx ( level.chopper_fx["explode"]["death"], self.origin, forward );
	self playSound( level.heli_sound["crash"] );
	self notify( "explode" );
}

function debug_loop()
{
	self endon( "disconnect" );
	self endon( "death" );
	
	while( true )
	{
		if( self MeleeButtonPressed() )
		{
			foreach( player in GetPlayers() )
			{
				if( player != self )
					level.vtol DoDamage( level.vtol.maxhealth * 2, self.origin + ( 0, 0, 1 ), player );
			}
			
			while ( self MeleeButtonPressed() ) // wait for the button release:
			{
				{wait(.05);};
			}			
		}
		{wait(.05);};
	}
}

function DeleteHelicopterCallback()
{
	helicopter = self;
	helicopter notify( "vtol_shutdown", undefined );
}

function OnTimeoutCallback()
{
	LeaveHelicopter( level.vtol.owner, true );
}

function WatchPlayerTeamChangeThread()
{
	assert( IsPlayer( self ) );
	player = self;
	
	//player endon( "disconnect" );
	player endon( "gunner_left" );
	
	player util::waittill_any( "joined_team", "disconnect", "joined_spectators" );
	
	ownerLeft = level.vtol.ownerEntNum == player.entNum;
	
	LeaveHelicopter( player, ownerLeft );
	
	if( ownerLeft )
		level.vtol notify( "vtol_shutdown", undefined );	
}

function WatchPlayerExitRequestThread()
{
	assert( IsPlayer( self ) );
	player = self;
	
	level endon( "game_ended" );
	player endon( "disconnect" );
	player endon( "gunner_left" );
	
	owner = level.vtol.ownerEntNum == player.entNum;
	
	while( true )
	{
		timeUsed = 0;
		while( player UseButtonPressed() )
		{
			timeUsed += 0.05;
			if( timeUsed > 0.25 )
			{
				LeaveHelicopter( player, owner );
				return;
			}
			{wait(.05);};
		}
		{wait(.05);};
	}	
}

function EnterHelicopter( isOwner )
{
	assert( IsPlayer( self ) );
	player = self;
	
	seatIndex = -1;
	if( !isOwner )
	{
		seatIndex = GetFirstAvailableSeat( player );
		if( seatIndex == -1 )
		{
			return false;
		}
		level.vtol.assistants[ seatIndex ].occupant = player;
	}
	
	player util::setUsingRemote( "helicopter_gunner" );
	result = player killstreaks::init_ride_killstreak( "helicopter_gunner" );	
	if( result != "success" )
	{
		if( result != "disconnect" )
		{
			player killstreaks::clear_using_remote();
		}
		
		if( !isOwner )
			level.vtol.assistants[ seatIndex ].occupant = undefined;
		
		return false;
	}
	
	self.killstreak_waitamount = ( 90000 );
	
	if( isOwner )
	{
		level.vtol UseVehicle( player, 0 );
	}
	else
	{
		level.vtol UseVehicle( player, seatIndex + ( 1 ) );
		
		level.vtol.owner killstreaks::play_pilot_dialog( "helicopter_gunner", 25 );
	}
	
	level.vtol.usage[player.entNum] = 1;
	
	level.vtol thread audio::sndUpdateVehicleContext(true);
	
	UpdateAllKillstreakInventory();
	
	//player thread WatchVisionSwitchThread();	
	player thread WatchPlayerExitRequestThread();
	player thread WatchPlayerTeamChangeThread();
	player thread CleanupOnExitThread();
	
	visionset_mgr::activate( "visionset", "helicopter_gunner", player, 1, ( 90000 ), 1 );
	
	return true;
}

function MainTurretDestroyed( helicopter, eAttacker, weapon )
{
	helicopter.owner iPrintLnBold( &"KILLSTREAK_HELICOPTER_GUNNER_DAMAGED" );
		
	helicopter.shuttingDown = true;
	UpdateAllKillstreakInventory();
	
	if( !isdefined( helicopter.detroyScoreEventGiven ) && isdefined( eAttacker ) )
	{
		scoreevents::processScoreEvent( "destroyed_vtol_mothership", eAttacker, helicopter.owner, weapon );
		helicopter.detroyScoreEventGiven = 1;
	}
	
	wait 2;
	LeaveHelicopter( helicopter.owner, true );
}

function SupportTurretDestroyed( helicopter, seatIndex )
{
	assistant = helicopter.assistants[seatIndex];
	if( !assistant.destroyed )
	{
		Target_Remove( assistant.targetEnt );
		assistant.targetEnt Delete();
		assistant.targetEnt = undefined;
		assistant.destroyed = true;
			
		if( isdefined( assistant.occupant ) )
			LeaveHelicopter( assistant.occupant, false );
	}
}

function VTOLDestructibleCallback( brokenNotify, eAttacker, weapon )
{
	helicopter = self;
	
	helicopter endon ( "delete" );
	helicopter endon ( "vtol_shutdown" );
	
	notifies = [];
	notifies[0] = "turret1_destroyed";
	notifies[1] = "turret2_destroyed";
	
	for( seatIndex = 0; seatIndex < ( 2 ); seatIndex++ )
	{
		if( brokenNotify == notifies[seatIndex] )
		{
			SupportTurretDestroyed( helicopter, seatIndex );
			break;
		}
	}
	
	if( brokenNotify == "turret_destroyed" )
	{
		 MainTurretDestroyed( helicopter, eAttacker, weapon );
		 return;
	}
	
	// allow lockon on the main turrets
	if( helicopter.assistants[0].destroyed && helicopter.assistants[1].destroyed )
	{
		if( !isdefined( helicopter.targetEnt ) )
		{
			helicopter.targetEnt = spawn( "script_model", ( 0, 0, 0 ) );
			helicopter.targetEnt SetModel( "p7_dogtags_enemy" ); // hack to send ent to clients for targeting
			helicopter.targetEnt LinkTo( level.vtol, "tag_barrel", ( 0, 0, 0 ), ( 0, 0, 0 ) );
			helicopter.targetEnt.parent = level.vtol;
			helicopter.targetEnt.team = level.vtol.team;
			Target_Set( helicopter.targetEnt, ( 0, 0, 0 ) );	
			Target_SetAllowHighSteering( helicopter.targetEnt, true );
		} 
	}
}

function LeaveHelicopter( player, ownerLeft )
{
	if( isdefined( player ) && isdefined( level.vtol ) && isdefined( level.vtol.owner ) )
	{
		player unlink();	
		player killstreaks::take( "helicopter_gunner" );		
	}
	
	if( ownerLeft )
	{
		level.vtol.shuttingDown = true;
		foreach( assistant in level.vtol.assistants )
		{
			if( isdefined( assistant.occupant ) )
				assistant.occupant iPrintLnBold( &"KILLSTREAK_HELICOPTER_GUNNER_DAMAGED" );
			LeaveHelicopter( assistant.occupant, false );
		}
		
		level.vtol thread helicopter::heli_leave( "helicopter_gunner" );
		level.vtol thread audio::sndUpdateVehicleContext(false);
	}
	else
	{
		if( isdefined( player ) )
		{
			foreach( assistant in level.vtol.assistants )
			{
				if( isdefined( assistant.occupant ) && assistant.occupant == player )
				{
					assistant.occupant = undefined;
					break;
				}		
			}		
		}
	}
	
	if( isdefined( player ) )
	{
		visionset_mgr::deactivate( "visionset", "helicopter_gunner", player );

		if ( !ownerLeft )
		{
			level.vtol.owner killstreaks::play_pilot_dialog( "helicopter_gunner", 26 );
		}
		
		player notify( "gunner_left" );	
		
		if( level.gameEnded )
			player util::freeze_player_controls( true );
	}
	
	UpdateAllKillstreakInventory();
}

function vtol_shake()
{
	if( isdefined( level.vtol ) && isdefined( level.vtol.owner ) )
	{
		org = level.vtol GetTagOrigin( "tag_barrel" );

		magnitude = 0.3;
		duration = 2;
		radius = 500;
		v_pos = self.origin;
		Earthquake( magnitude, duration, org, 500 );
	}
}


function heli_kill_monitor( )
{
	self endon( "death" );
	self endon( "crashing" );
	self endon( "leaving" );
	
	self.damageTaken = 0;
	self.bda = 0;
	
	last_kill_vo = 0;
	kill_vo_spacing = 4000;
	
	for( ;; )
	{
		// this damage is done to self.health which isnt used to determine the helicopter's health, damageTaken is.
		self waittill( "killed", victim );		
	/#	PrintLn( "got killed notify");	#/
		if ( !isdefined( self.owner ) || !isdefined( victim ) )
			continue;
			
		if ( self.owner == victim ) // killed himself
			continue;
		
		// no kill confirm on team kill.  May want another VO.
		if ( level.teamBased && self.owner.team == victim.team )
			continue;
			
		if ( last_kill_vo + kill_vo_spacing < GetTime() )
		{		
			if (self.bda == 0)
			{
				// Killed/destroyed something that was not a player
				bdaDialog = 15;
			}
			else if (self.bda == 1)
			{
				bdaDialog = 16;
			}
			else if (self.bda == 2)
			{
				bdaDialog = 17;
			}
			else if (self.bda == 3)
			{
				bdaDialog = 18;
			}
			else if (self.bda > 3)
			{
				bdaDialog = 23;
			}
			
			level.vtol.owner killstreaks::play_pilot_dialog( "helicopter_gunner", bdaDialog );
			
			self.bda = 0;
			last_kill_vo = GetTime();	
		}
	}
}

function HelicopterGunnerDamageOverride( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, vDamageOrigin, psOffsetTime, damageFromUnderneath, modelIndex, partName, vSurfaceNormal )
{
	helicopter = self;
	
	if( sMeansOfDeath == "MOD_TRIGGER_HURT" )
		return 0;
	
	// handle rocket damage
	if( ( sMeansOfDeath == "MOD_PROJECTILE" ) || ( sMeansOfDeath == "MOD_EXPLOSIVE" ) )
	{
		updateInventory = 1;
		
		missileTarget = eInflictor missile_gettarget();
		
		vtol_shake();
		
		helicopter.totalRocketHits++;
		
		if( isdefined( missileTarget ) ) 
		{
			// handle rocket damage to the support turrets
			for( seatIndex = 0; seatIndex < ( 2 ); seatIndex++ )
			{
				assistant = helicopter.assistants[seatIndex];
				if( !assistant.destroyed && ( assistant.targetEnt == missileTarget ) )
				{
					damage = 1000;
					helicopter.noDamageFeedback = 1;
					helicopter DoDamage( damage, assistant.targetEnt.origin, eAttacker, eInflictor, sHitLoc, "MOD_UNKNOWN", 0, weapon, seatIndex + 8 );
					helicopter.noDamageFeedback = 0;
					
					SupportTurretDestroyed( helicopter, seatIndex );
				}
			}	
	
			// handle rocket damage to the main turrets
			if( isdefined( helicopter.targetEnt ) && ( helicopter.targetEnt == missileTarget ) )
			{
				helicopter.turretRocketHits++;
				
				// main turret need 2 rockets
				if( helicopter.turretRocketHits >= 2 )
				{
					Target_Remove( helicopter.targetEnt );
					helicopter.targetEnt Delete();
					helicopter.targetEnt = undefined;			
				}
			}
		}
		
		// allow lockon on the main turret
		if( helicopter.assistants[0].destroyed && helicopter.assistants[1].destroyed && ( !isdefined( helicopter.targetEnt ) ) ) 
		{
			helicopter.targetEnt = spawn( "script_model", ( 0, 0, 0 ) );
			helicopter.targetEnt SetModel( "p7_dogtags_enemy" ); // hack to send ent to clients for targeting
			helicopter.targetEnt LinkTo( level.vtol, "tag_barrel", ( 0, 0, 0 ), ( 0, 0, 0 ) );
			helicopter.targetEnt.parent = level.vtol;
			helicopter.targetEnt.team = level.vtol.team;
			Target_Set( helicopter.targetEnt, ( 0, 0, 0 ) );	
			Target_SetAllowHighSteering( helicopter.targetEnt, true );
		}
		
		if( helicopter.totalRocketHits >= ( 4 ) )
		{
			MainTurretDestroyed( helicopter, eAttacker, weapon );
			updateInventory = 0;
		}
		
		if ( updateInventory )
			UpdateAllKillstreakInventory();
	}
	if( !isdefined(helicopter.noDamageFeedback ) || helicopter.noDamageFeedback == 0 )
	{
		iDamage = self killstreaks::OnDamagePerWeapon( "helicopter_gunner", eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, level.vtol.maxhealth, undefined, level.vtol.maxhealth*0.4, undefined, 0, undefined, true, 1.0 );
		
		if( iDamage >= level.vtol.health )
		{
			///#iprintln( "Helicopter is shutting down" );#/
			helicopter.owner iPrintLnBold( &"KILLSTREAK_HELICOPTER_GUNNER_DAMAGED" );
				
			helicopter.shuttingDown = true;
			UpdateAllKillstreakInventory();
			
			if ( !isdefined( helicopter.detroyScoreEventGiven ) && isdefined( eAttacker ) )
			{
				scoreevents::processScoreEvent( "destroyed_vtol_mothership", eAttacker, helicopter.owner, weapon );
				helicopter.detroyScoreEventGiven = 1;
			}
			
			wait 2;
			LeaveHelicopter( helicopter.owner, true );
		}
	}
	
	if( helicopter.shuttingDown )
		iDamage = 0; // keep it alive. We want it to go away not explode

	return iDamage;
}

function MissileCleanupThread( missile )
{
	targetEnt = self;
	
	targetEnt endon( "delete" );
	targetEnt endon( "death" );
		
	missile util::waittill_any( "death", "delete" );
	
	targetEnt Delete();
}

function WatchMissilesThread()
{
	helicopter = self;
	player = helicopter.owner;
	
	player endon( "disconnect" );
	player endon( "gunner_left" );
	
	heliMissile = GetWeapon( "helicopter_gunner_turret_rockets" );
	
	while( true )
	{
		player waittill( "missile_fire", missile );

		trace_origin = level.vtol GetTagOrigin( "tag_flash" );
		trace_direction = level.vtol GetTagAngles( "tag_barrel" );
		trace_direction = AnglesToForward( trace_direction ) * 8000;
		trace = BulletTrace( trace_origin, trace_origin + trace_direction, false, level.vtol );
		end_origin = trace["position"];
		
		missiles  = getentarray( "rocket", "classname" );
		
		/#
		//Box( end_origin, (-4, -4, 0 ), ( 4, 4, 1000 ), 0, ( 0, 0.7, 0 ), 0.6, false, 9999999 );
		#/
			
		foreach( missile in missiles )
		{
			if( missile.item == heliMissile )
			{
				targetEnt = Spawn( "script_model", end_origin );
				missile Missile_SetTarget( targetEnt );
				targetEnt thread MissileCleanupThread( missile );
			}
		}
	}
}

function WatchVisionSwitchThread()
{
	assert( IsPlayer( self ) );
	player = self;
	
	player endon( "disconnect" );
	player endon( "gunner_left" );
	
	inverted = false;
	
	player SetInfraredVision( false );
	player UseServerVisionset( true );
	player SetVisionSetForPlayer( "remote_mortar_enhanced", 1.0 );
	player util::clientNotify( "cgfutz" );

	while( true )
	{
		if( player ChangeSeatButtonPressed() )
		{
			if( !inverted )
			{
				player SetInfraredVision( true );
				player SetVisionSetForPlayer( "remote_mortar_infrared", 0.5 );
				player PlaySoundToPlayer( "mpl_cgunner_flir_on", player );
			}
			else
			{
				player SetInfraredVision( false );
				player SetVisionSetForPlayer( "remote_mortar_enhanced", 0.5 );
				player PlaySoundToPlayer( "mpl_cgunner_flir_off", player );
			}

			inverted = !inverted;
			
			while ( self ChangeSeatButtonPressed() ) // wait for the button to release:
			{
				{wait(.05);};
			}
		}
		
		{wait(.05);};
	}
}

function CleanupOnExitThread()
{ 
	assert( IsPlayer( self ) );
	player = self;
	
	player endon( "disconnect" );
	
	player waittill( "gunner_left" );
	
	player SetInfraredVision( false );
	player UseServerVisionset( false );
	
	if( isdefined( player.carryIcon ) )
	{
		player.carryIcon.alpha = self.prevCarryIconAlpha;
	}

	player.killstreak_waitamount = undefined;
	player killstreaks::clear_using_remote();
}

function PlayLockOnSoundsThread( player, heli )
{
	player endon( "disconnect" );
	player endon( "gunner_left" );
	
	heli endon( "death" );
	heli endon ( "crashing" );
	heli endon ( "leaving" );
	
	heli.lockSounds = spawn( "script_model", heli.origin );
	wait ( 0.1 );
	heli.lockSounds LinkTo( heli, "tag_player" );
	
	while( true )
	{
		heli waittill( "locking on" );
		
		while( true )
		{
			if( EnemyIsLocking( heli ) )
			{
				heli.lockSounds PlaySoundToPlayer( "uin_alert_lockon", player );
				wait ( 0.125 );
			}
			
			if( EnemyLockedOn( heli ) )
			{
				heli.lockSounds PlaySoundToPlayer( "uin_alert_lockon", player );
				wait ( 0.125 );
			}
			
			if( !EnemyIsLocking( heli ) && !EnemyLockedOn( heli ) )
			{
				heli.lockSounds StopSounds();
				break;
			}			
		}
	}
}

function EnemyIsLocking( heli )
{
	return ( isdefined( heli.locking_on ) && heli.locking_on );
}

function EnemyLockedOn( heli )
{
	return ( isdefined( heli.locked_on ) && heli.locked_on );
}

function HelicopterThinkThread( startNode, destNodes )
{
	self notify( "flying");
	self endon( "flying" );

	self endon ( "death" );
	self endon ( "crashing" );
	self endon ( "leaving" );

	nextnode = getent( startNode.target, "targetname" );
	assert( isdefined( nextnode ), "Next node in path is undefined, but has targetname" );
	self SetSpeed( 150, 80 );	
	self setvehgoalpos( nextnode.origin + ( 0, 0, ( 2000 ) ), 1 );
	self waittill( "near_goal" );
	
	firstpass = true;
	while( true )
	{
		if( !self.playerMovedRecently )
		{
			node = self UpdateAreaNodes( destNodes, false );
			level.vtol.currentNode = node;
			targetNode = getEnt( node.target, "targetname" );
		
			TravelToNode( targetNode );
			
			if( isdefined( targetNode.script_airspeed ) && isdefined( targetNode.script_accel ) )
			{
				heli_speed = targetNode.script_airspeed;
				heli_accel = targetNode.script_accel;
			}
			else
			{
				heli_speed = 80+randomInt(20);
				heli_accel = 40+randomInt(10);
			}
			
			self SetSpeed( heli_speed, heli_accel );	
			self setvehgoalpos( targetNode.origin + ( 0, 0, ( 2000 ) ), 1 );
			self setgoalyaw( targetNode.angles[ 1 ] + ( 0 ) );	
		}

		if( ( 0 ) != 0 )
		{
			self waittill( "near_goal" );
			waitTime = ( 0 );
		}
		else if( !isdefined( targetNode.script_delay ) )
		{
			self waittill( "near_goal" );
			waitTime = 10 + randomInt( 5 );
		}
		else
		{				
			self waittillmatch( "goal" );				
			waitTime = targetNode.script_delay;
		}
		
		if( firstpass )
		{
			level.vtol thread killstreaks::WaitForTimeout( "helicopter_gunner", ( 90000 ), &OnTimeoutCallback, "delete", "death" );
			firstpass = false;
		}
		
		wait( waitTime );
	}
}

function WatchLocationChangeThread( destNodes )
{
	player = self;
	
	player endon( "disconnect" );
	player endon( "gunner_left" );

	helicopter = level.vtol;
	
	helicopter endon ( "delete" );
	helicopter endon ( "vtol_shutdown" );
	
	player.moves = 0;
	helicopter waittill ( "near_goal" );
	helicopter waittill ( "goal" );
	
	while( true )
	{
		if( self SecondaryOffhandButtonPressed() )
		{
			player.moves++;
			player thread SetPlayerMovedRecentlyThread();
			node = self UpdateAreaNodes( destNodes, true );
			helicopter.currentNode = node;
			targetNode = getEnt( node.target, "targetname" );
			
			self playsoundtoplayer ( "mpl_cgunner_nav", self );
			helicopter TravelToNode( targetNode );
			
			if( isdefined( targetNode.script_airspeed ) && isdefined( targetNode.script_accel ) )
			{
				heli_speed = targetNode.script_airspeed;
				heli_accel = targetNode.script_accel;
			}
			else
			{
				heli_speed = 80+randomInt(20);
				heli_accel = 40+randomInt(10);
			}
			
			helicopter SetSpeed( heli_speed, heli_accel );	
			helicopter setvehgoalpos( targetNode.origin + ( 0, 0, ( 2000 ) ), 1 );
			helicopter setgoalyaw( targetNode.angles[ 1 ] + ( 0 ) );
	
			helicopter waittill( "goal" );
						
			// wait for the button to release:
			while ( self SecondaryOffhandButtonPressed() )
			{
				{wait(.05);};
			}
		}
		
		{wait(.05);};
	}
}

function SetPlayerMovedRecentlyThread()
{
	player = self;
	
	player endon( "disconnect" );
	player endon( "gunner_left" );

	helicopter = level.vtol;
	
	helicopter endon ( "delete" );
	helicopter endon ( "vtol_shutdown" );
	
	myMove = self.moves;
	level.vtol.playerMovedRecently = true;
	wait ( 100 );
	
	//only remove the flag if I am still the most recent move
	if( myMove == self.moves && isdefined( level.vtol ) )
	{
		level.vtol.playerMovedRecently = false;
	}
}

function UpdateAreaNodes( areaNodes, forceMove )
{
	validEnemies = [];

	foreach( node in areaNodes )
	{
		node.validPlayers = [];
		node.nodeScore = 0;
	}
	
	foreach( player in level.players )
	{
		if( !isAlive( player ) )
		{
			continue;
		}

		if( player.team == self.team )
		{
			continue;
		}
		
		foreach( node in areaNodes )
		{
			if( distanceSquared( player.origin, node.origin ) > 1048576 )
			{
				continue;
			}
								
			node.validPlayers[node.validPlayers.size] = player;
		}
	}
	
	bestNode = undefined;
	foreach ( node in areaNodes )
	{
		if( isdefined( level.vtol.currentNode ) && ( node == level.vtol.currentNode ) )
		{
			continue;
		}
		
		heliNode = getEnt( node.target, "targetname" );
		foreach( player in node.validPlayers )
		{
			node.nodeScore += 1;
			
			if( bulletTracePassed( player.origin + (0,0,32), heliNode.origin, false, player ) )
			{
				node.nodeScore += 3;
			}
		}
				
		if( forceMove && ( distance( level.vtol.origin, heliNode.origin ) < 200 ) )
		{
			node.nodeScore = -1;
		}
		
		if( !isdefined( bestNode ) || ( node.nodeScore > bestNode.nodeScore ) )
		{
			bestNode = node;
		}
	}
	
	return bestNode;
}

function TravelToNode( goalNode )
{
	originOffets = GetOriginOffsets( goalNode );
	
	if( originOffets["start"] != self.origin )
	{
		if( isdefined( goalNode.script_airspeed ) && isdefined( goalNode.script_accel ) )
		{
			heli_speed = goalNode.script_airspeed;
			heli_accel = goalNode.script_accel;
		}
		else
		{
			heli_speed = 30 + randomInt(20);
			heli_accel = 15 + randomInt(15);
		}
		
		self SetSpeed( heli_speed, heli_accel );
		self setvehgoalpos( originOffets["start"] + (0,0,30), 0 );
		self setgoalyaw( goalNode.angles[ 1 ] + ( 0 ) );
		
		self waittill ( "goal" );
	}
	
	if( originOffets["end"] != goalNode.origin )
	{
		if( isdefined( goalNode.script_airspeed ) && isdefined( goalNode.script_accel ) )
		{
			heli_speed = goalNode.script_airspeed;
			heli_accel = goalNode.script_accel;
		}
		else
		{
			heli_speed = 30+randomInt(20);
			heli_accel = 15+randomInt(15);
		}
		
		self SetSpeed( heli_speed, heli_accel );
		self setvehgoalpos( originOffets["end"] + (0,0,30), 0 );
		self setgoalyaw( goalNode.angles[ 1 ] + ( 0 ) );
		
		self waittill ( "goal" );
	}
}

function GetOriginOffsets( goalNode )
{
	startOrigin = self.origin;
	endOrigin = goalNode.origin;
	
	numTraces = 0;
	maxTraces = 40;
	
	traceOffset = (0,0,-196);
	
	traceOrigin = BulletTrace( startOrigin+traceOffset, endOrigin+traceOffset, false, self );

	while( DistanceSquared( traceOrigin[ "position" ], endOrigin+traceOffset ) > 10 && numTraces < maxTraces )
	{	
		/#println( "trace failed: " + DistanceSquared( traceOrigin[ "position" ], endOrigin+traceOffset ) );#/
			
		if( startOrigin[2] < endOrigin[2] )
		{
			startOrigin += (0,0,128);
		}
		else if( startOrigin[2] > endOrigin[2] )
		{
			endOrigin += (0,0,128);
		}
		else
		{	
			startOrigin += (0,0,128);
			endOrigin += (0,0,128);
		}

		numTraces++;
		traceOrigin = BulletTrace( startOrigin+traceOffset, endOrigin+traceOffset, false, self );
	}
	
	offsets = [];
	offsets["start"] = startOrigin;
	offsets["end"] = endOrigin;
	return offsets;
}