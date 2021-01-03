#using scripts\codescripts\struct;
#using scripts\shared\ai_shared;
#using scripts\shared\ai_puppeteer_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\clientfield_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\flagsys_shared;

    	   	                                                                                                                         	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	                           	                               	                                	                                                              	                                                                                                              	                            	                                     	                                       	                                                               	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                      	                                                              	                                                          	                                   	                                   	                                                    	                                       

#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_supplydrop;

#using scripts\mp\gametypes\_globallogic_audio;
                                                                                                                                                                                                                                                                 	                                                                                     														            														           						                           														          														         														        														                      														                                                                                                                                           															      															                                                      	        	       	                	           
                                                                                                          	                                              	                       	                   	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                 	                                                           	                 	                                                   	                	                                          	                                          	       	  	              	                                                  	                                                                 	                                                                  	                                                         	                                                   	                                                   	                                                                             	                                                                	                                                             	                                                             	                                   	                                   	                                                    	                                                    	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                                 	                                            	                                                                                    	                                          	                       	                    
 

#namespace combat_robot;





	


#precache( "string", "KILLSTREAK_COMBAT_ROBOT_ESCORT_MODE" );
#precache( "string", "KILLSTREAK_COMBAT_ROBOT_GUARD_MODE" );
#precache( "string", "KILLSTREAK_COMBAT_ROBOT_INBOUND" );
#precache( "string", "KILLSTREAK_COMBAT_ROBOT_NOT_AVAILABLE" );

#precache( "material", "t7_cp_hud_obj_defend" );

function init()
{
	//killstreaks::register( COMBAT_ROBOT_MARKER_NAME, COMBAT_ROBOT_MARKER_NAME,  "killstreak_ai_tank_drop", "ai_tank_drop_used", &ActivateCombatRobot );
	//killstreaks::register_strings( COMBAT_ROBOT_MARKER_NAME, &"KILLSTREAK_EARNED_AI_TANK_DROP", &"KILLSTREAK_AI_TANK_NOT_AVAILABLE", &"KILLSTREAK_AI_TANK_INBOUND" );
	//killstreaks::register_dialog( COMBAT_ROBOT_MARKER_NAME, "mpl_killstreak_combat_robot", "kls_combat_robot_used", "","kls_combat_robot_enemy", "", "kls_combat_robot_ready" );
	
	killstreaks::register( "combat_robot", "combat_robot_drop", "killstreak_" + "combat_robot", "combat_robot" + "_used", &ActivateCombatRobot, true );
	killstreaks::register_alt_weapon( "combat_robot", "lmg_light_robot" );
	killstreaks::register_strings( "combat_robot", &"KILLSTREAK_COMBAT_ROBOT_EARNED", &"KILLSTREAK_COMBAT_ROBOT_NOT_AVAILABLE", &"KILLSTREAK_COMBAT_ROBOT_INBOUND" );
	killstreaks::register_dialog( "combat_robot", "mpl_killstreak_combat_robot", 2, 35, 93, 111, 93 );
	
	level thread _CleanupRobotCorpses();
}

function private _CalculateProjectedGuardPosition( player )
{
	// Find the closest navmesh position projected out from the reticle.
	forwardVector = VectorScale( AnglesToForward( player GetPlayerAngles() ), 4000 );
	guardPoint = BulletTrace( player GetEye(), player GetEye() + forwardVector, true, player );
	return GetClosestPointOnNavMesh( guardPoint["position"], 48 );
}

function private _CalculateRobotSpawnPosition( player )
{
	desiredSpawnPosition = AnglesToForward( player.angles ) *
		72 + player.origin;
	
	return GetClosestPointOnNavMesh( desiredSpawnPosition, 48 );
}

function private _CleanupRobotCorpses()
{
	corpseDeleteTime = 15000;

	while ( true )
	{
		deleteCorpses = [];
	
		foreach ( corpse in GetCorpseArray() )
		{
			if ( IsDefined( corpse.birthtime ) &&
				IsDefined( corpse.archetype ) &&
				corpse.archetype == "robot" &&
				( corpse.birthtime + corpseDeleteTime ) < GetTime() )
			{
				deleteCorpses[ deleteCorpses.size ] = corpse;
			}
		}
		
		for ( index = 0; index < deleteCorpses.size; index++ )
		{
			deleteCorpses[ index ] Delete();
		}
	
		wait ( corpseDeleteTime / 1000 ) / 2;
	}
}

function private _ConfigureRobot( robot, player )
{
	robot.owner = player;
	robot.properName = "";
	// Prevent the robot from being damaged based on a hurt trigger when being called in.
	robot.ignoreTriggerDamage = true;
	
	robot.empShutdownTime = ( 2000 );
	robot.minWalkDistance = 125;
	
	robot SetTeam( player.team );
	robot.team = player.team;
	robot SetEntityOwner( player );
	
	robot ai::set_behavior_attribute( "can_become_crawler", false );
	robot ai::set_behavior_attribute( "can_be_meleed", false );
	robot ai::set_behavior_attribute( "supports_super_sprint", true );
	robot ai::set_behavior_attribute( "traversals", "procedural" );
	
}

function private _CreateGuardMarker( robot, position )
{
	guardMarker = NewClientHudElem( robot.owner );
	guardMarker.x = position[0];
	guardMarker.y = position[1];
	guardMarker.z = position[2];
	guardMarker.alpha = 0.8;
	
	guardMarker SetShader( "t7_cp_hud_obj_defend", 6, 6 );
	guardMarker SetWayPoint( false );
	
	return guardMarker;
}

function private _DestroyGuardMarker( robot )
{
	if ( IsDefined( robot.guardMarker ) )
	{
		robot.guardMarker Destroy();
	}
}

function private _Escort( robot )
{
	robot endon( "death" );

	robot.escorting = true;
	robot.guarding = false;
	
	_DestroyGuardMarker( robot );
	
	robot ai::set_behavior_attribute( "move_mode", "escort" );
	
	//robot.owner iPrintLnBold( &"KILLSTREAK_COMBAT_ROBOT_ESCORT_MODE" );
	
	while ( robot.escorting )
	{
		if ( IsDefined( robot.owner ) && IsAlive( robot.owner ) )
		{
			lookAheadTime = 1.0;
			predicitedPosition =
				robot.owner.origin + VectorScale( robot.owner GetVelocity(), lookAheadTime );
		
			robot ai::set_behavior_attribute( "escort_position", predicitedPosition );
		}
		
		{wait(.05);};
	}
}

function private _GuardPosition( robot, position )
{
	robot endon( "death" );

	robot.goalradius = 1000;
	robot SetGoal( position );
	
	robot.escorting = false;
	robot.guarding = true;
	
	_DestroyGuardMarker( robot );
	
	robot.guardMarker = _CreateGuardMarker( robot, position );
	
	//robot.owner iPrintLnBold( &"KILLSTREAK_COMBAT_ROBOT_GUARD_MODE" );
	
	while ( robot.guarding )
	{
		if ( IsDefined( robot.enemy ) && IsAlive( robot.enemy ) && robot CanShootEnemy() )
		{
			if ( Distance2DSquared( robot.goalpos, robot.origin ) < ( (robot.goalradius) * (robot.goalradius) ) )
			{
				// Robot still within goalradius, continue pursuit.
				robot ai::set_behavior_attribute( "move_mode", "rusher" );
			}
			else
			{
				// Robot is outside goalradius, stop moving but continue shooting if possible.
				robot ai::set_behavior_attribute( "move_mode", "normal" );
			}
		}
		else
		{
			robot ai::set_behavior_attribute( "move_mode", "guard" );
		}
		
		wait 1;
	}
}

function _WatchModeSwap( robot, player )
{
	robot endon( "death" );
	
	nextSwitchTime = GetTime();
	
	timeUsed = 0;
	
	while ( true )
	{
		{wait(.05);};

		if ( nextSwitchTime <= GetTime() && player useButtonPressed() && IsAlive( player ) )
		{
			timeUsed += 0.05;
			if ( timeUsed <= 0.25 )
			{
				continue;
			}
			if ( ( isdefined( robot.guarding ) && robot.guarding ) )
			{
				robot.guarding = false;
				robot.escorting = true;
				
				player playsoundtoplayer ("uin_mp_combat_bot_escort", player);
				robot thread _Escort( robot );
				if( isdefined( robot.useTrigger ) )
					robot.useTrigger SetHintString( &"KILLSTREAK_COMBAT_ROBOT_GUARD_HINT" );
			}
			else
			{
				navGuardPosition = _CalculateProjectedGuardPosition( player );
				
				if ( IsDefined( navGuardPosition ) )
				{
					robot.guarding = true;
					robot.escorting = false;
					
					player playsoundtoplayer ("uin_mp_combat_bot_guard", player);
					robot thread _GuardPosition( robot, navGuardPosition );
					if( isdefined( robot.useTrigger ) )
						robot.useTrigger SetHintString( &"KILLSTREAK_COMBAT_ROBOT_ESCORT_HINT" );
				}
			}
			
			robot notify("bhtn_action_notify", "modeSwap");
			
			nextSwitchTime = GetTime() + 1000;
		}
		timeUsed = 0;
	}
}

function ActivateCombatRobot( hardpointType )
{
	player = self;
	team = self.team;
	
	if( !self supplydrop::isSupplyDropGrenadeAllowed( hardpointType ) )
	{
		return false;
	}

	killstreak_id = self killstreakrules::killstreakStart( hardpointType, team, false, false );
	if ( killstreak_id == -1 )
	{
		return false;
	}
	
	//player thread DrawTargetPositionThread();

	result = self supplydrop::useSupplyDropMarker( killstreak_id, true );
	
	// the marker is out but the chopper is yet to come
	self notify( "supply_drop_marker_done" );
	
	if ( !isdefined(result) || !result )
	{
		//if( !self.supplyGrenadeDeathDrop )
			killstreakrules::killstreakStop( hardpointType, team, killstreak_id );
		return false;
	}

	self killstreaks::play_killstreak_start_dialog( "combat_robot", self.team );	
	self killstreaks::pick_pilot( "combat_robot", 2 );
	
	return result;
}	

function DogTagCleanupThread( dogtag )
{
	player = self;
	player waittill( "supply_drop_marker_done" );
	player.selectingLocation = undefined;
	dogtag Delete();
}

function DrawTargetPositionThread()
{
	player = self;
	player endon( "supply_drop_marker_done" );
	
	
	player.selectingLocation = true;
	
	dogtag = spawn( "script_model", ( 0, 0, 0 ) );
	dogtag SetModel( "p7_dogtags_enemy" );
	player thread DogTagCleanupThread( dogtag );
	
	last_was_good = false;
	
	while( true )
	{
		forwardVector = VectorScale( AnglesToForward( player GetPlayerAngles() ), 4000 );
		results = BulletTrace( player GetEye(), player GetEye() + forwardVector, true, player );
		dogtag.origin = results["position"];
		
		if( IsPointOnMesh( dogtag.origin ) && IsAwayFromBoundary( dogtag.origin ) )
		{
			level.dogtag_origin = dogtag.origin;
			if( !last_was_good ) // this is lame, but should be good till we decide on how to show the good/bad markers
			{
			   	last_was_good = true;
				dogtag SetModel( "p6_dogtags" );
			}
		}
		else
		{
			level.dogtag_origin = undefined;
			if( last_was_good )
			{
			   	last_was_good = false;
				dogtag SetModel( "p7_dogtags_enemy" );
			}
		}
		
		{wait(.05);};
	}
}

function prolog()
{
	helicopter = self;
	player = helicopter.owner;
	
	spawnPosition = ( 0,0,0 );
	spawnAngles = ( 0,0,0 );
	
	combatRobot = SpawnActor(
						"spawner_bo3_robot_grunt_assault_mp",
						spawnPosition,
						spawnAngles,
						"",
						true );
	
	_ConfigureRobot( combatRobot, player );
	combatRobot thread _Escort( combatRobot );
	combatRobot thread _WatchModeSwap( combatRobot, player );

	combatRobot thread WatchCombatRobotShutdown();
	combatRobot thread WatchCombatRobotDeath();
	combatRobot thread killstreaks::WaitForTimeout( "combat_robot", ( 90000 ), &OnCombatRobotTimeout, "combat_robot_shutdown" );
	combatRobot thread WatchCombatRobotOwnerDisconnect( player );
	combatRobot thread sndWatchCombatRobotVoxNotifies();
	Target_Set( combatRobot, ( 0, 0, 0 ) );
	
	combatRobot.maxhealth = combatRobot.health;
	
	tableHealth = killstreaks::get_max_health( "combat_robot" );
	
	if ( isdefined( tableHealth ) )
	{
		combatRobot.maxhealth = tableHealth;
	}
	
	combatRobot.health = combatRobot.maxhealth;
	combatRobot.remoteMissileDamage = combatRobot.maxhealth + 1;
	combatRobot.rocketDamage = combatRobot.maxhealth / 2 + 1;
	combatRobot thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile("death");
	combatRobot clientfield::set( "enemyvehicle", 1 );
	
	AiUtility::AddAIOverrideDamageCallback( combatRobot, &combatRobotDamageOverride );	
	
	combatRobot vehicle::get_in( helicopter , "driver", true );		

	combatRobot thread WatchCombatRobotLanding();
	combatRobot thread sndWatchExit();
	combatRobot thread sndWatchLanding();
	combatRobot thread sndWatchActivate();
}

function _ActivateCombatRobot()
{
	player = self;
	assert( IsPlayer( player ) );
	
	players = GetPlayers();
	enemy = player;
	foreach( pi in players )
	{
		if( pi.team != player.team )
		{
			enemy = pi;
			break;
		}
	}
	
	killstreak_id = enemy killstreakrules::killstreakStart( "combat_robot", enemy.team, undefined, false );
	if( killstreak_id == (-1) )
	{
		return false;
	}
	
	spawnPosition = _CalculateRobotSpawnPosition( enemy );
	
	if ( !IsDefined( spawnPosition ) )
	{
		return false;
	}
	
	enemy AddWeaponStat( GetWeapon( "combat_robot" ), "used", 1 );
	
	combatRobot = SpawnActor(
						"spawner_bo3_robot_grunt_assault_mp",
						spawnPosition,
						enemy.angles,
						"",
						true );
	
	_ConfigureRobot( combatRobot, enemy );
	combatRobot thread _GuardPosition( combatRobot, spawnPosition );
	combatRobot thread _WatchModeSwap( combatRobot, enemy );

	combatRobot thread WatchCombatRobotShutdown();
	combatRobot thread WatchCombatRobotDeath();
	combatRobot thread WatchCombatRobotOwnerDisconnect( enemy );
	Target_Set( combatRobot, ( 0, 0, 0 ) );
	
	combatRobot.maxhealth = 5000;
	combatRobot.health = combatRobot.maxhealth;
	combatRobot.remoteMissileDamage = combatRobot.maxhealth + 1;
	combatRobot.rocketDamage = combatRobot.maxhealth / 2 + 1;
	combatRobot thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile("death");
	combatRobot clientfield::set( "enemyvehicle", 1 );
	
	AiUtility::AddAIOverrideDamageCallback( combatRobot, &combatRobotDamageOverride );		
		
	return true;
}

function WatchCombatRobotDeath()
{
	combatRobot = self;
	combatRobot endon( "combat_robot_shutdown" );
	
	combatRobot waittill( "death", attacker, type, weapon  );
	
	if ( IsPlayer( attacker ) )
	{
		scoreevents::processScoreEvent( "destroyed_combat_robot", attacker, combatRobot.owner, weapon );
		LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_COMBAT_ROBOT", attacker.entnum );		
	}
	
	if( isdefined( combatRobot.owner) )
	{
		combatRobot.owner killstreaks::play_pilot_dialog( "combat_robot", 2 );
	}
	
	combatRobot notify( "combat_robot_shutdown" );
}

function WatchCombatRobotLanding()
{
	robot = self;
	robot endon( "death" );
	robot endon( "combat_robot_shutdown" );
	
	// wait for landing
	while( robot flagsys::get( "in_vehicle" ) )  
	{
		wait 1;
	}
	
	robot.ignoreTriggerDamage = false;
	
	v_on_navmesh = GetClosestPointOnNavMesh( robot.origin, 50, 20 );
	
	if ( isdefined ( v_on_navmesh ) )
	{
		player = robot.owner;
		
		objective = GetEquipmentHeadObjective( GetWeapon( "combat_robot_drop" ) );
		robot entityheadicons::setEntityHeadIcon( player.pers["team"], player, (0,0,0), objective );
	
		robot.useTrigger = spawn( "trigger_radius_use", player.origin, 32, 32 );
		robot.useTrigger EnableLinkTo();
		robot.useTrigger LinkTo( player );
		robot.useTrigger SetHintLowPriority( true );
		robot.useTrigger SetCursorHint( "HINT_NOICON" );
		robot.useTrigger SetHintString( &"KILLSTREAK_COMBAT_ROBOT_GUARD_HINT" );
		
		if( level.teamBased )
		{
			robot.useTrigger SetTeamForTrigger( player.team );
			robot.useTrigger.team = player.team;
		}
	
		player ClientClaimTrigger( robot.useTrigger );
		player.remoteControlTrigger = robot.useTrigger;
		robot.useTrigger.ClaimedBy = player;	
	}
	else
	{
		robot notify( "combat_robot_shutdown" );
	}
}

function WatchCombatRobotOwnerDisconnect( player )
{
	combatRobot = self;
	combatRobot endon( "combat_robot_shutdown" );
	
	player util::waittill_any( "joined_team", "disconnect", "joined_spectators" );
	combatRobot notify( "combat_robot_shutdown" );
}

function OnCombatRobotTimeout()
{
	combatRobot = self;
	
	if( isdefined( combatRobot.owner) )
	{
		combatRobot.owner killstreaks::play_pilot_dialog( "combat_robot", 5 );
	}
	
	combatRobot notify( "combat_robot_shutdown" );
}

function WatchCombatRobotShutdown()
{
	combatRobot = self;
	combatRobotTeam = combatRobot.team;
	combatRobotKillstreakId = combatRobot.killstreak_id;
	combatRobot waittill( "combat_robot_shutdown" );
	
	combatRobot playsound ("evt_combat_bot_mech_fail");
	
	if( isdefined( combatRobot.useTrigger ) )
		combatRobot.useTrigger delete();
	
	_DestroyGuardMarker( combatRobot );
	
	killstreakrules::killstreakStop( "combat_robot", combatRobotTeam, combatRobotKillstreakId );
	
	if( isdefined( combatRobot ) )
	{
		Target_Remove( combatRobot );
		if( !level.gameEnded ) // kill and do damage do nothing after game end
			combatRobot Kill();
	}
}

function sndWatchCombatRobotVoxNotifies()
{
	combatRobot = self;
	combatRobot endon( "combat_robot_shutdown" );
	combatRobot endon( "death" );
	
	combatRobot PlaySoundOnTag( "vox_robot_chatter", "j_head" );
	
	while(1)
	{
		soundAlias = undefined;
		combatRobot waittill("bhtn_action_notify", notify_string);
		
		switch( notify_string )
		{
			case "charge":
			case "attack_melee":
			case "attack_kill":
			case "modeSwap":
				soundAlias = "vox_robot_chatter";
				break;
		}
		
		if( isdefined( soundAlias ) )
		{
			combatRobot PlaySoundOnTag( soundAlias, "j_head" );
			wait(1.2);
		}
	}
}
function sndWatchExit()
{
	combatRobot = self;
	combatRobot endon( "combat_robot_shutdown" );
	combatRobot endon( "death" );
	
	combatRobot waittill( "exiting_vehicle" );
	
	combatRobot playsound( "veh_vtol_supply_robot_launch" );
}
function sndWatchLanding()
{
	combatRobot = self;
	combatRobot endon( "combat_robot_shutdown" );
	combatRobot endon( "death" );
	
	combatRobot waittill( "falling", falltime );
	
	wait_time = falltime - .5;
	
	if ( wait_time > 0 )
		wait( wait_time );
	
	combatRobot playsound( "veh_vtol_supply_robot_land" );
}
function sndWatchActivate()
{
	combatRobot = self;
	combatRobot endon( "combat_robot_shutdown" );
	combatRobot endon( "death" );
	
	combatRobot waittill( "landing" );
	wait(.1);
	combatRobot playsound( "veh_vtol_supply_robot_activate" );
}

function combatRobotDamageOverride( eInflictor, eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, vPoint, vDir, sHitLoc, psOffsetTime, boneIndex, modelIndex )
{
	combatRobot = self;
	if( combatRobot flagsys::get( "in_vehicle" ) && ( sMeansOfDeath == "MOD_TRIGGER_HURT" ) ) // the dropship goes through hurt triggers sometimes
		iDamage = 0;
	else
		iDamage = killstreaks::OnDamagePerWeapon( "combat_robot", eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, self.maxhealth, undefined, self.maxhealth*0.4, undefined, 0, undefined, true, 1.0 );
	
	return iDamage;
}
