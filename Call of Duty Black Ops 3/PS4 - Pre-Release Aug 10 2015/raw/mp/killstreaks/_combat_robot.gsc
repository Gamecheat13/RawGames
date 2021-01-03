#using scripts\codescripts\struct;

#using scripts\shared\ai_shared;
#using scripts\shared\ai_puppeteer_shared;
#using scripts\shared\callbacks_shared;
#using scripts\shared\clientfield_shared;
#using scripts\shared\flagsys_shared;
#using scripts\shared\killstreaks_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\ai\archetype_utility;
#using scripts\shared\ai\systems\gib;
#using scripts\shared\entityheadicons_shared;
#using scripts\shared\util_shared;
#using scripts\shared\vehicleriders_shared;
#using scripts\shared\weapons\_heatseekingmissile;

#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\killstreaks\_killstreak_bundles;
#using scripts\mp\killstreaks\_killstreak_detect;
#using scripts\mp\killstreaks\_killstreak_hacking;
#using scripts\mp\killstreaks\_killstreakrules;
#using scripts\mp\killstreaks\_killstreaks;
#using scripts\mp\killstreaks\_supplydrop;

  
                                                                                                  	  	                          	                                         	                     	                 	                                                                         	                       	                                                      	                                                      	                                                       	                                                                                                  	                                                           	                 	                                                                                                           	                	                                          	                                      	       	  	             	                                                     	                                                                             	                         	                                                                	                                                             	                                                             	                                                                                      	                                                         	                                                         	                                                               	                                                               	                                                   	                                                                	                                                     	                                                	                                                	                                                        	                                                                                                  	                                                                             	                                            	                                                                                    	                                          	                     	                                              	                                        	         	     
 
    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
           
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    

#namespace combat_robot;









// Tweaks to how the combat robot's body is thrown after exploding
	// Scales the initial velocity






	
#precache( "string", "KILLSTREAK_COMBAT_ROBOT_ESCORT_HINT" );
#precache( "string", "KILLSTREAK_COMBAT_ROBOT_GUARD_HINT" );
#precache( "string", "KILLSTREAK_COMBAT_ROBOT_INBOUND" );
#precache( "string", "KILLSTREAK_COMBAT_ROBOT_NOT_AVAILABLE" );
#precache( "string", "KILLSTREAK_COMBAT_ROBOT_HACKED" );
#precache( "string", "KILLSTREAK_COMBAT_ROBOT_PATROL_FAIL" );
#precache( "string", "KILLSTREAK_DESTROYED_COMBAT_ROBOT" );

#precache( "material", "t7_hud_ks_c54i_drop" );

function init()
{
	killstreaks::register( "combat_robot", "combat_robot_marker", "killstreak_" + "combat_robot", "combat_robot" + "_used", &ActivateCombatRobot, undefined, true );
	killstreaks::register_alt_weapon( "combat_robot", "lmg_light_robot" );
	killstreaks::register_strings( "combat_robot", &"KILLSTREAK_COMBAT_ROBOT_EARNED", &"KILLSTREAK_COMBAT_ROBOT_NOT_AVAILABLE", &"KILLSTREAK_COMBAT_ROBOT_INBOUND", undefined,  &"KILLSTREAK_COMBAT_ROBOT_HACKED" );
	killstreaks::register_dialog( "combat_robot", "mpl_killstreak_combat_robot", "combatRobotDialogBundle", "combatRobotPilotDialogBundle", "friendlyCombatRobot", "enemyCombatRobot", "enemyCombatRobotMultiple", "friendlyCombatRobotHacked", "enemyCombatRobotHacked", "requestCombatRobot", "threatCombatRobot" );
	
	// TODO: Move to killstreak data
	level.killstreaks["inventory_combat_robot"].threatOnKill = true;
	level.killstreaks["combat_robot"].threatOnKill = true;
	
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

function ConfigureTeamPost( player, isHacked )
{
	robot = self;
	robot.properName = "";
	// Prevent the robot from being damaged based on a hurt trigger when being called in.
	robot.ignoreTriggerDamage = true;
	
	robot.empShutdownTime = ( 2000 );
	robot.minWalkDistance = 125;
	
	_ConfigureRobotTeam( robot, player, isHacked );
	
	robot ai::set_behavior_attribute( "can_become_crawler", false );
	robot ai::set_behavior_attribute( "can_be_meleed", false );
	robot ai::set_behavior_attribute( "can_initiateaivsaimelee", false );
	robot ai::set_behavior_attribute( "supports_super_sprint", true );
	robot ai::set_behavior_attribute( "traversals", "procedural" );
}

function private _ConfigureRobotTeam( robot, player, isHacked )
{
	if ( isHacked ) 
	{
		lightsState = 3;
	}
	else
	{
		lightsState = 0;
	}
	robot ai::set_behavior_attribute( "robot_lights", lightsState );
	robot thread WatchCombatRobotOwnerDisconnect( player );
	
	if ( !isdefined( robot.objective ) )
	{
		robot.objective = GetEquipmentHeadObjective( GetWeapon( "combat_robot_marker" ) );
	}
	
//	robot entityheadicons::destroyEntityHeadIcons();
//	robot entityheadicons::setEntityHeadIcon( player.pers["team"], player, (0,0,0), robot.objective );
	
	robot thread _WatchModeSwap( robot, player );
	robot thread _Underwater( robot );
}

	
function private _CreateGuardMarker( robot, position )
{
	guardMarker = NewClientHudElem( robot.owner );
	guardMarker.x = position[0];
	guardMarker.y = position[1];
	guardMarker.z = position[2] + 15;
	guardMarker.alpha = 0.8;
	
	guardMarker SetShader( "t7_hud_ks_c54i_drop", 12, 12 );
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

function private _Underwater( robot )
{
	robot endon( "death" );
	
	while ( true )
	{
		if ( ( robot.origin[2] + 72 / 2.0 ) <= GetWaterHeight( robot.origin ) )
		{
			robot ASMSetAnimationRate( 0.85 );
		}
		else
		{
			robot ASMSetAnimationRate( 1.0 );
		}
		
		wait 0.1;
	}
}

function private _Escort( robot )
{
	robot endon( "death" );

	robot.escorting = true;
	robot.guarding = false;
	
	_DestroyGuardMarker( robot );
	
	robot ai::set_behavior_attribute( "move_mode", "escort" );
		
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
	
	while ( true )
	{
		{wait(.05);};
		
		if( !isdefined( robot.useTrigger ) )
		   continue;
		   
		robot.useTrigger waittill( "trigger" );

		if ( nextSwitchTime <= GetTime() && IsAlive( player ) )
		{
			if ( ( isdefined( robot.guarding ) && robot.guarding ) )
			{
				robot.guarding = false;
				robot.escorting = true;
				
				player playsoundtoplayer( "uin_mp_combat_bot_escort", player );
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
					
					player playsoundtoplayer( "uin_mp_combat_bot_guard", player );
					robot thread _GuardPosition( robot, navGuardPosition );
					if( isdefined( robot.useTrigger ) )
						robot.useTrigger SetHintString( &"KILLSTREAK_COMBAT_ROBOT_ESCORT_HINT" );
				}
				else
				{
					player iPrintLnBold( &"KILLSTREAK_COMBAT_ROBOT_PATROL_FAIL" );
				}
			}
			
			robot notify("bhtn_action_notify", "modeSwap");
			
			nextSwitchTime = GetTime() + 1000;
		}
	}
}

function ActivateCombatRobot( killstreak )
{
	player = self;
	team = self.team;
	
	if( !self supplydrop::isSupplyDropGrenadeAllowed( killstreak ) )
	{
		return false;
	}

	killstreak_id = self killstreakrules::killstreakStart( killstreak, team, false, false );
	if ( killstreak_id == -1 )
	{
		return false;
	}
	
	context = SpawnStruct();
	context.prolog = &Prolog;
	context.epilog = &Epilog;
	
	context.hasFlares = 1;
	context.radius = level.killstreakCoreBundle.ksAirdropRobotRadius;
	context.isLocationGood = &supplydrop::IsLocationGood;
	context.objective = &"airdrop_combatrobot";	
	context.killstreakRef = killstreak;
	context.validLocationSound = level.killstreakCoreBundle.ksValidCombatRobotLocationSound;	
	context.vehiclename = "combat_robot_dropship";
	context.killstreak_id = killstreak_id;
	
	// This offset is specific to the exit vtol animation of the combat rider.
	context.dropOffset = (0, -120, 0);
	
	result = self supplydrop::useSupplyDropMarker( killstreak_id, context );
	
	if ( !isdefined(result) || !result )
	{
		killstreakrules::killstreakStop( killstreak, team, killstreak_id );
		return false;
	}

	self killstreaks::play_killstreak_start_dialog( "combat_robot", self.team, killstreak_id );	
	self killstreakrules::displayKillstreakStartTeamMessageToAll( "combat_robot" );
	
	return result;
}	


function DropKillThread()
{
	robot = self;
	robot endon( "death" );
	robot endon( "combat_robot_land" );

	while( true )
	{	
		robot supplydrop::is_touching_crate();
		robot supplydrop::is_clone_touching_crate();
		{wait(.05);};
	}
}

function WatchHelicopterDeath( context )
{
	helicopter = self;
	helicopter waittill( "death" );
	
	callback::callback( #"on_vehicle_killed" );
	
	if( isdefined( context.marker ) )
	{
		context.marker delete();
		context.marker = undefined;
		
		if( isdefined( context.markerFXHandle ) )
		{
			context.markerFXHandle delete();
			context.markerFXHandle = undefined;
		}
		supplydrop::DelDropLocation( context.killstreak_id );
	}		
}

function Prolog( context )
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

	combatRobot killstreaks::configure_team( "combat_robot", context.killstreak_id, player, "small_vehicle", undefined, &ConfigureTeamPost );
	combatRobot killstreak_hacking::enable_hacking( "combat_robot", undefined, &HackedCallbackPost );
	combatRobot thread _Escort( combatRobot );

	combatRobot thread WatchCombatRobotHelicopterHacked( helicopter );
	combatRobot thread WatchCombatRobotShutdown();
	combatRobot thread WatchCombatRobotDeath();
	combatRobot thread killstreaks::WaitForTimeout( "combat_robot", ( 90000 ), &OnCombatRobotTimeout, "combat_robot_shutdown" );
	combatRobot thread sndWatchCombatRobotVoxNotifies();
	
	helicopter thread WatchHelicopterDeath( context );
	
	killstreak_detect::killstreakTargetSet( combatRobot, ( 0, 0, 50 ) );
	
	combatRobot.maxhealth = combatRobot.health;
	
	tableHealth = killstreak_bundles::get_max_health( "combat_robot" );
	
	if ( isdefined( tableHealth ) )
	{
		combatRobot.maxhealth = tableHealth;
	}
	
	combatRobot.health = combatRobot.maxhealth;
	combatRobot.remoteMissileDamage = combatRobot.maxhealth + 1;
	combatRobot.rocketDamage = combatRobot.maxhealth / 2 + 1;
	combatRobot thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile("death");
	combatRobot clientfield::set( "enemyvehicle", 1 );
	combatRobot.soundmod = "drone_land";
	
	AiUtility::AddAIOverrideDamageCallback( combatRobot, &combatRobotDamageOverride );	
	
	combatRobot vehicle::get_in( helicopter , "driver", true );	

	combatRobot thread WatchCombatRobotLanding();
	combatRobot thread sndWatchExit();
	combatRobot thread sndWatchLanding();
	combatRobot thread sndWatchActivate();
	
	foreach( player in level.players )
	{
		combatRobot respectNotTargetedByRobotPerk( player );
	}
	
	callback::on_spawned( &respectNotTargetedByRobotPerk, combatRobot );
	context.robot = combatRobot;
}


function respectNotTargetedByRobotPerk( player )
{
	combatRobot = self;
	combatRobot setignoreent( player, player hasperk( "specialty_nottargetedbyrobot" ) );
}

function Epilog( context )
{
	helicopter = self;
	
	context.robot thread DropKillThread();
	thread CleanupThread( context );
	
	helicopter vehicle::unload( "all" );
}

function HackedCallbackPost( hacker )
{
	robot = self;
	robot ClearEnemy();
	robot SetupCombatRobotHintTrigger( hacker );	
}


function WatchCombatRobotHelicopterHacked( helicopter )
{
	robot = self;
	robot endon( "death" );
	robot endon( "killstreak_hacked" );
	robot endon( "combat_robot_land" );

	helicopter endon( "death" );

	helicopter waittill( "killstreak_hacked", hacker );

	if( robot flagsys::get( "in_vehicle" ) == false )
		return;
	
	robot [[ robot.killstreak_hackedCallback ]]( hacker );
}

function CleanupThread( context )
{
	robot = context.robot;
	while( isdefined( robot ) && isdefined( context.marker ) && ( robot flagsys::get( "in_vehicle" ) ) ) 
	{
		wait 1;
	}
	if( isdefined( context.marker ) )
	{
		context.marker delete();
		context.marker = undefined;
		
		if( isdefined( context.markerFXHandle ) )
		{
			context.markerFXHandle delete();
			context.markerFXHandle = undefined;
		}
		supplydrop::DelDropLocation( context.killstreak_id );
	}
}

function WatchCombatRobotDeath()
{
	combatRobot = self;
	combatRobot endon( "combat_robot_shutdown" );
	callback::remove_on_spawned( &respectNotTargetedByRobotPerk, combatRobot );
	combatRobot waittill( "death", attacker, type, weapon  );
	
	attacker = self [[ level.figure_out_attacker ]]( attacker );

	if ( IsPlayer( attacker ) )
	{
		scoreevents::processScoreEvent( "destroyed_combat_robot", attacker, combatRobot.owner, weapon );
		LUINotifyEvent( &"player_callout", 2, &"KILLSTREAK_DESTROYED_COMBAT_ROBOT", attacker.entnum );		
	}
	
	combatRobot killstreaks::play_destroyed_dialog_on_owner( "combat_robot", combatRobot.killstreak_id );
	
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
	
	robot notify( "combat_robot_land" );
	
	robot.ignoreTriggerDamage = false;
	
	v_on_navmesh = GetClosestPointOnNavMesh( robot.origin, 50, 20 );
	///#sphere( robot.origin, 5, ( 1, 0, 0 ), 1, true, 10, 200 );#/
	
	if ( isdefined ( v_on_navmesh ) )
	{
		player = robot.owner;
		
		robot SetupCombatRobotHintTrigger( player );
	}
	else
	{
		robot notify( "combat_robot_shutdown" );
	}
}

function SetupCombatRobotHintTrigger( player )
{
	robot = self;
	if ( isdefined( robot.useTrigger ) )
	{
		robot.useTrigger delete();
	}
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

function WatchCombatRobotOwnerDisconnect( player )
{
	combatRobot = self;
	combatRobot notify( "WatchCombatRobotOwnerDisconnect_singleton" );
	combatRobot endon( "WatchCombatRobotOwnerDisconnect_singleton" );
	combatRobot endon( "combat_robot_shutdown" );
	
	player util::waittill_any( "joined_team", "disconnect", "joined_spectators" );
	combatRobot notify( "combat_robot_shutdown" );
}

function private _corpseWatcher()
{
	archetype = self.archetype;
 	self waittill("actor_corpse", corpse);
 	corpse clientfield::set("arch_actor_fire_fx", 3);
}

function private _explodeRobot( combatRobot )
{
	combatRobot clientfield::set("arch_actor_fire_fx", 1);
	clientfield::set(
		"robot_mind_control_explosion", 1 );
	combatRobot thread _corpseWatcher();
	
	if ( RandomInt( 100 ) >= 50 )
		GibServerUtils::GibLeftArm( combatRobot );
	else
		GibServerUtils::GibRightArm( combatRobot );
	
	GibServerUtils::GibLegs( combatRobot );
	GibServerUtils::GibHead( combatRobot );
	
	velocity = combatRobot GetVelocity() * ( 1 / 8 );
	
	combatRobot StartRagdoll();
	combatRobot LaunchRagdoll(
		( velocity[0] + RandomFloatRange( -20, 20 ),
		velocity[1] + RandomFloatRange( -20, 20 ),
		RandomFloatRange( 60, 80 ) ),
		"j_mainroot" );
}

function OnCombatRobotTimeout()
{
	combatRobot = self;
	
	combatRobot killstreaks::play_pilot_dialog_on_owner( "timeout", "combat_robot" );
	
	_explodeRobot( combatRobot );
	
	params = level.killstreakBundle["combat_robot"];
	
	if( isdefined( params.ksExplosionFX ) )
	{
		PlayFXOnTag( params.ksExplosionFX, combatRobot, "tag_origin" );
	}
	Target_Remove( combatRobot );
	
	if(!isdefined(params.ksExplosionOuterRadius))params.ksExplosionOuterRadius=200; 
	if(!isdefined(params.ksExplosionInnerRadius))params.ksExplosionInnerRadius=1;
	if(!isdefined(params.ksExplosionOuterDamage))params.ksExplosionOuterDamage=25;
	if(!isdefined(params.ksExplosionInnerDamage))params.ksExplosionInnerDamage=350;
	if(!isdefined(params.ksExplosionMagnitude))params.ksExplosionMagnitude=1;
	
	PhysicsExplosionSphere( combatRobot.origin, 
	                       params.ksExplosionOuterRadius, 
	                       params.ksExplosionInnerRadius, 
	                       params.ksExplosionMagnitude,
	                       params.ksExplosionOuterDamage,
	                       params.ksExplosionInnerDamage );
	
	if( isdefined( combatRobot.owner ) )
	{
		RadiusDamage( combatRobot.origin, 
		             params.ksExplosionOuterRadius,
		             params.ksExplosionInnerDamage,
		             params.ksExplosionOuterDamage,
		             combatRobot.owner, 
		             "MOD_EXPLOSIVE" );	
		
		if( isdefined( params.ksExplosionRumble ) )
			combatRobot.owner PlayRumbleOnEntity( params.ksExplosionRumble );
	}
		
	wait( 0.2 );
	
	combatRobot notify( "combat_robot_shutdown" );
}

function WatchCombatRobotShutdown()
{
	combatRobot = self;
	combatRobotTeam = combatRobot.originalteam;
	combatRobotKillstreakId = combatRobot.killstreak_id;
	combatRobot waittill( "combat_robot_shutdown" );
	
	combatRobot playsound ("evt_combat_bot_mech_fail_explode");
	
	if( isdefined( combatRobot.useTrigger ) )
		combatRobot.useTrigger delete();
	
	_DestroyGuardMarker( combatRobot );
	
	killstreakrules::killstreakStop( "combat_robot", combatRobotTeam, combatRobotKillstreakId );
	
	if( isdefined( combatRobot ) )
	{
		if( Target_IsTarget( combatRobot ) )
			Target_Remove( combatRobot );
		if( !level.gameEnded ) // kill and do damage do nothing after game end
		{
			if( combatRobot flagsys::get( "in_vehicle" ) )
				combatRobot Unlink();
			combatRobot Kill();
		}
	}
}

function sndWatchCombatRobotVoxNotifies()
{
	combatRobot = self;
	combatRobot endon( "combat_robot_shutdown" );
	combatRobot endon( "death" );
	
	combatRobot PlaySoundOnTag( "vox_robot_chatter", "j_head" );
	
	while( 1 )
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
	
	if( ( sMeansOfDeath == "MOD_IMPACT" ) && ( weapon.rootWeapon == GetWeapon( "hero_bowlauncher" ) ) )
		iDamage = 0;
	else if( combatRobot flagsys::get( "in_vehicle" ) && ( sMeansOfDeath == "MOD_TRIGGER_HURT" ) ) // the dropship goes through hurt triggers sometimes
		iDamage = 0;
	else
		iDamage = killstreaks::OnDamagePerWeapon( "combat_robot", eAttacker, iDamage, iDFlags, sMeansOfDeath, weapon, self.maxhealth, undefined, self.maxhealth*0.4, undefined, 0, undefined, true, 1.0 );
	
	return iDamage;
}
