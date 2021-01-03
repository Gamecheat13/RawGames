#using scripts\codescripts\struct;

#using scripts\shared\challenges_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;
#using scripts\shared\weapons\_heatseekingmissile;
#using scripts\shared\weapons\_weaponobjects;
#using scripts\shared\weapons\_weapons;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\cp\gametypes\_battlechatter;
#using scripts\cp\gametypes\_weaponobjects;

#using scripts\cp\_challenges;
#using scripts\cp\_scoreevents;
#using scripts\cp\_util;
#using scripts\cp\_vehicle;
#using scripts\cp\killstreaks\_airsupport;
#using scripts\cp\killstreaks\_dogs;
#using scripts\cp\killstreaks\_killstreakrules;
#using scripts\cp\killstreaks\_killstreaks;


	
#precache( "string", "MP_EARNED_STRAFERUN" );
#precache( "string", "KILLSTREAK_STRAFERUN_NOT_AVAILABLE" );
#precache( "string", "MP_WAR_STRAFERUN_INBOUND" );
#precache( "string", "MP_WAR_STRAFERUN_INBOUND_NEAR_YOUR_POSITION" );
#precache( "string", "mpl_killstreak_straferun" );
#precache( "fx", "_t6/vehicle/exhaust/fx_exhaust_a10_contrail" );
#precache( "fx", "_t6/weapon/straferun/fx_straferun_chaf" );
#precache( "fx", "_t6/vehicle/vexplosion/fx_vexplode_vtol_mp" );

#namespace straferun;

function init()
{
	level.strafeRunNumRockets = 7;
	level.strafeRunRocketDelay = 0.35;
	level.strafeRunGunLookahead = 4000;
	level.strafeRunGunOffset = -800;
	level.strafeRunGunRadius = 500;
	level.strafeRunExitUnits = 20000;
	level.strafeRunMaxStrafes = 4;
	level.strafeRunFlareDelay = 2;
	level.strafeRunShellShockDuration = 2.5;
	level.strafeRunShellShockRadius = 512;
	level.strafeRunKillsBeforeExit = 10;

	level.strafeRunModel = "veh_t6_air_a10f";
	level.strafeRunModelEnemy = "veh_t6_air_a10f_alt";
	level.strafeRunVehicle = "vehicle_straferun_mp";
	level.strafeRunGunWeapon = GetWeapon( "straferun_gun" );
	level.strafeRunGunSound = "wpn_a10_shot_loop_npc";
	level.strafeRunRocketWeapon = GetWeapon( "straferun_rockets" );
	level.strafeRunRocketTags = [];
	level.strafeRunRocketTags[0] = "tag_rocket_left";
	level.strafeRunRocketTags[1] = "tag_rocket_right";
	level.strafeRunContrailFX = "_t6/vehicle/exhaust/fx_exhaust_a10_contrail";
	level.strafeRunChaffFX = "_t6/weapon/straferun/fx_straferun_chaf";
	level.strafeRunExplodeFX = "_t6/vehicle/vexplosion/fx_vexplode_vtol_mp";
	level.strafeRunExplodeSound = "evt_helicopter_midair_exp";
	level.strafeRunShellShock = "straferun";
	
	killstreaks::register( "straferun", "straferun", "killstreak_straferun", "straferun_used",&useKillstreakStrafeRun, true);
	killstreaks::register_strings( "straferun", &"MP_EARNED_STRAFERUN", &"KILLSTREAK_STRAFERUN_NOT_AVAILABLE", &"MP_WAR_STRAFERUN_INBOUND", &"MP_WAR_STRAFERUN_INBOUND_NEAR_YOUR_POSITION" );
	killstreaks::register_dialog( "straferun", "mpl_killstreak_straferun", "kls_straferun_used", "","kls_straferun_enemy", "", "kls_straferun_ready");
	killstreaks::register_dev_dvar( "straferun", "scr_givestraferun" );
	killstreaks::register_alt_weapon( "straferun", level.strafeRunGunWeapon.name );
	killstreaks::register_alt_weapon( "straferun", level.strafeRunRocketWeapon.name );
	killstreaks::set_team_kill_penalty_scale( "straferun", 0.0 );

}

function PlayPilotDialog( dialog )
{

	soundAlias = level.teamPrefix[self.team] + self.pilotVoiceNumber + "_" + dialog;
	
	if ( isdefined( self.owner ) )
	{
		if (self.owner.pilotisSpeaking)
		{
			while (self.owner.pilotisSpeaking)
			{
				wait (.2);
			}
		}
	}
	if ( isdefined( self.owner ) )
	{
		self.owner playLocalSound(soundAlias);
		self.owner.pilotisSpeaking = true;
		self.owner thread battlechatter::wait_playback_time( soundAlias ); 
		self.owner util::waittill_any( soundAlias, "death", "disconnect" );
		if ( isdefined( self.owner ) )
		{
			self.owner.pilotisSpeaking = false;
		}
	}
	
	
}
	
function useKillstreakStrafeRun( hardpointType )
{
	startNode = GetVehicleNode( "warthog_start", "targetname" );
	if ( !isdefined( startNode ) )
	{
/#		println( "ERROR: Strafe run vehicle spline not found!" );	#/
		return false;
	}
	
	killstreak_id = self killstreakrules::killstreakStart( "straferun", self.team, false, true );
	if ( killstreak_id == -1 )
	{
		return false;
	}
	

	// Spawn and setup vehicle
	plane = SpawnVehicle( level.strafeRunVehicle, startNode.origin, (0,0,0), "straferun" );
	plane.attackers = [];
	plane.attackerData = [];
	plane.attackerDamage = [];
	plane.flareAttackerDamage = [];
	plane SetTeam( self.team );
	plane SetEnemyModel( level.strafeRunModelEnemy );
	plane.team = self.team;
	plane MakeVehicleUnusable();
	plane thread cleanupOnDeath();
	plane.health = 999999;
	plane.maxhealth = 999999;
	plane SetOwner( self );
	plane.owner = self;
	plane.numStrafes = 0;
	plane.killstreak_id = killstreak_id;
	plane.numFlares = 2;
	plane.fx_flare = "_t6/weapon/straferun/fx_straferun_chaf";
	plane.soundMod = "straferun";
	plane SetDrawInfrared( true );
	self.straferunKills = 0;
	self.strafeRunbda = 0;
	self.pilotisSpeaking = false;	
	plane.pilotVoiceNumber = self.bcVoiceNumber + 1;
	if 	(plane.pilotVoiceNumber > 3) 
	{
		plane.pilotVoiceNumber = 0;
	}
	self killstreaks::play_killstreak_start_dialog( "straferun", self.pers["team"] );
	level.globalKillstreaksCalled++;
	self AddWeaponStat( GetWeapon( "straferun" ), "used", 1 );

	//play pilot dialog
	plane thread PilotDialogWait ("a10_used", 2.5);	


	// make targetable
	Target_Set( plane, (0,0,0) );
	Target_SetTurretAquire( plane, false );
	
	plane thread playContrail();
	
	// Setup vehicle weapons
	//plane setVehWeapon( level.strafeRunGunWeapon );
	plane.gunSoundEntity = spawn( "script_model", plane GetTagOrigin( "tag_flash" ) );
	plane.gunSoundEntity LinkTo( plane, "tag_flash", (0,0,0), (0,0,0) );
	
	//plane.killCamEntities = level.strafeRunKillcams.strafes;

	plane thread watchForOtherKillstreaks();
	plane thread watchForKills();
	plane thread watchdamage();
	plane thread doStrafeRuns();
	plane thread vehicle::follow_path( startNode );
	plane thread heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile("death");	
	plane thread watchForOwnerExit( self );

	return true;
}

function playContrail()
{
	self endon( "death" );
	
	wait( 0.1 );
	PlayFXOnTag( level.strafeRunContrailFX, self, "tag_origin" );
	self playloopsound ("veh_a10_engine_loop", 1);
}

function cleanupOnDeath()
{	
	self waittill( "death" );
	
	killstreakrules::killstreakStop( "straferun", self.team, self.killstreak_id );
	
	if( isdefined( self.gunSoundEntity ) )
	{
		self.gunSoundEntity StopLoopSound();
		self.gunSoundEntity Delete();
		self.gunSoundEntity = undefined;
	}
}

function watchdamage()
{
	self endon( "death" );

	self.maxhealth = 999999;
	self.health = self.maxhealth;
	self.maxhealth = 1000;
	
	low_health = false;
	damage_taken = 0;

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, dir, point, mod, model, tag, part, weapon, flags );
		
		if( !isdefined( attacker ) || !isplayer( attacker ) )
			continue;
		
/#
		self.damage_debug = ( damage + " (" + weapon.name + ")" );
#/
		
		if ( mod == "MOD_PROJECTILE" || mod == "MOD_PROJECTILE_SPLASH" || mod == "MOD_EXPLOSIVE" )
		{
			damage += 1000;
		}	
			
		self.attacker = attacker;

		damage_taken += damage;

			
		if ( damage_taken >= 1000 )
		{
			self thread explode();
			if ( self.owner util::IsEnemyPlayer( attacker ) )
			{
				attacker challenges::addFlySwatterStat( weapon, self );
			}
			else
			{
				//Destroyed Friendly Killstreak 
			}

			return;
		}
	}
}

function watchForOtherKillstreaks()
{
	self endon( "death" );

	for ( ;; )
	{
		level waittill( "killstreak_started", hardpointType, teamName, attacker );
		if ( !isdefined ( self.owner ) ) 
		{
			self thread explode();
			return;
		}

		if ( hardpointType == "emp" )
		{
			if ( self.owner util::IsEnemyPlayer( attacker ) ) 
			{
				self thread explode();
				attacker challenges::addFlySwatterStat( hardpointType, self );
				return;
			}
		}
		else if ( hardpointType == "missile_swarm" )
		{
			if ( self.owner util::IsEnemyPlayer( attacker ) ) 
			{
				self.leaveNextTime = true;
			}
		}
	}
}

function watchForKills()
{
	self endon( "death" );
	
	for ( ;; )
	{
		self waittill( "killed", player );
		if ( IsPlayer( player ) )
		{
			//IPrintLnBold( "STRAFE RUN KILLED PLAYER\n" );
			
		}
		else
		{
			//IPrintLnBold( "STRAFE RUN KILLED SOMETHING ELSE\n" );
			//self.bda = self.bda + 1;
		}
	}
}

function watchForOwnerExit( owner )
{
	self endon( "death" );
	
	owner util::waittill_any( "disconnect", "joined_team", "joined_spectator");
	self.leaveNextTime = true;
}

function addStraferunKill()
{
	if ( !isdefined( self.straferunKills ) )
	{
		self.straferunKills = 0;
	}
	self.straferunKills++;	
}

function doStrafeRuns()
{
	self endon( "death" );
	
	//self thread fireFlares();
	
	for ( ;; )
	{
		self waittill( "noteworthy", noteworthy, noteworthyNode );
		if ( noteworthy == "strafe_start" )
		{
			self.strafeRunGunLookahead = level.strafeRunGunLookahead;
			self.strafeRunGunRadius = level.strafeRunGunRadius;
			self.strafeRunGunOffset = level.strafeRunGunOffset;
			
/#
			self.strafeRunGunLookahead = GetDvarInt( #"scr_straferunlookahead", level.strafeRunGunLookahead ); 
			self.strafeRunGunRadius = GetDvarInt( #"scr_straferunradius", level.strafeRunGunRadius ); ;
			self.strafeRunGunOffset = GetDvarInt( #"scr_straferunoffset", level.strafeRunGunOffset ); ;
#/
			
			if ( isdefined( noteworthyNode ) )
			{
				if ( isdefined( noteworthyNode.script_parameters ) )
				{
					self.strafeRunGunLookahead = float( noteworthyNode.script_parameters );
				}
				
				if ( isdefined( noteworthyNode.script_radius ) )
				{
					self.strafeRunGunRadius = float( noteworthyNode.script_radius );
				}
					
				if ( isdefined( noteworthyNode.script_float ) )
				{
					self.strafeRunGunOffset = float( noteworthyNode.script_float );
				}
			}
			if ( isdefined( self.owner ) )
			{
				self thread startStrafe( );
			}
		}
		else if ( noteworthy == "strafe_stop" )
		{
			self stopStrafe();
		
		}
		else if ( noteworthy == "strafe_leave" )
		{
	
			if ( self shouldLeaveMap() )
			{
				self thread leaveMap();
				//play pilot dialog
				self thread PilotDialogWait( "a10_leave", 5 );					
			}
			else
			{
				//play pilot dialog
				self thread PilotDialogWait( "a10_strafe", 3 );	
			}
		}
	}
}

function fireFlares()
{
	self endon( "death" );
	self endon( "strafe_start" );
	
	wait( 0.1 );
	
	for ( ;; )
	{
		chaff_fx = spawn( "script_model", self.origin );
		chaff_fx.angles = (0,180,0);
		chaff_fx SetModel( "tag_origin" );
		chaff_fx LinkTo( self , "tag_origin", (0,0,0), (0,0,0) );
		
		wait( 0.1 );
		
		PlayFXOnTag( level.strafeRunChaffFX, chaff_fx, "tag_origin" );
		chaff_fx playsound ("wpn_a10_drop_chaff");
		
		chaff_fx thread util::deleteAfterTimeThread( level.strafeRunFlareDelay );
		
		wait( level.strafeRunFlareDelay );
	}
}

function startStrafe(  )
{
	self endon( "death" );
	self endon( "strafe_stop" );
	
	if ( isdefined( self.strafing ) )
	{
		IPrintLnBold( "TRYING TO STRAFE WHEN ALREADY STRAFING!\n" );
		return;
	}
	self.strafing = true;

	//PlayPilotDialog("kls_hit");	
	self thread PilotDialogWait ("kls_hit", 3.5);
	
	// First strafe
	if ( self.numStrafes == 0 )
	{
		self firstStrafe();
	}
	
	self thread fireRockets();

//	self planeSounds( undefined, "evt_flyby_apex_2362", "evt_flyby_wash_2362", 2362 ); 

	count = 0;
	weaponShootTime = level.strafeRunGunWeapon.fireTime;
	for ( ;; )
	{
		gunOrigin = self GetTagOrigin( "tag_flash" );
		gunOrigin += ( 0, 0, self.strafeRunGunOffset );
		forward = AnglesToForward( self.angles );
		forwardNoZ = VectorNormalize( (forward[0],forward[1],0) );
		right = weaponobjects::vectorcross( forwardNoZ, (0,0,1) );
		perfectAttackStartVector = gunOrigin + VectorScale( forwardNoZ, self.strafeRunGunLookahead );
		attackStartVector = perfectAttackStartVector + VectorScale( right, RandomFloatRange( 0-self.strafeRunGunRadius, self.strafeRunGunRadius ) );

		trace = BulletTrace( attackStartVector, (attackStartVector[0],attackStartVector[1],-500), false, self, false, true );
		self SetTurretTargetVec( trace["position"] );
		self FireWeapon();
		self.gunSoundEntity PlayLoopSound( level.strafeRunGunSound );
		self shellShockPlayers( trace["position"] );
		
/#
		if (  GetDvarInt( #"scr_devStrafeRunBulletsDebugDraw", 0 ) )
		{
			time = 300;
			airsupport::debug_line( attackStartVector, trace["position"] - ( 0,0,20 ), (1,0,0), time, false );
			if( count % 30 == 0 )
			{
				trace = BulletTrace( perfectAttackStartVector, (perfectAttackStartVector[0],perfectAttackStartVector[1],-100000), false, self, false, true );
				airsupport::debug_line( trace["position"] + ( 0,0,20 ), trace["position"] - ( 0,0,20 ), (0,0,1), time, false );
			}
		}
#/
		count++;
		wait weaponShootTime;
	}
	
}

function firstStrafe()
{
	/*Target_Set( self );
	Target_SetTurretAquire( self, true );*/
}

function fireRockets()
{
	self notify( "firing_rockets" );
	
	self endon( "death" );
	self endon( "strafe_stop" );
	self endon( "firing_rockets" );
	self.owner endon( "disconnect" );
	
	forward = anglesToForward( self.angles );
	
	self.firedRocketTargets = [];
	
	for ( rocketIndex = 0 ; rocketIndex < level.strafeRunNumRockets ; rocketIndex++ )
	{
		rocketTag = level.strafeRunRocketTags[rocketIndex%level.strafeRunRocketTags.size];
		
		// If possible, choose the highest priority target we haven't already fired a rocket at, otherwise just choose the highest priority target
		targets = getValidTargets();
		rocketOrigin = self GetTagOrigin( rocketTag );
		targetOrigin = rocketOrigin + forward * 10000;
		if ( targets.size > 0 )
		{
			selectedTarget = undefined;
			foreach( target in targets )
			{
				alreadyAttacked = false;
				foreach( oldTarget in self.firedRocketTargets )
				{
					if ( oldTarget == target )
					{
						alreadyAttacked = true;
						break;
					}
				}
				if ( !alreadyAttacked )
				{
					selectedTarget = target;
					break;
				}
			}
			
			if ( isdefined( selectedTarget ) )
			{
				self.firedRocketTargets[self.firedRocketTargets.size] = selectedTarget;
	
				// do dead reconing on the target
				targetOrigin = deadReconTargetOrigin( rocketOrigin, selectedTarget );
			}
		}
		
		rocketOrigin = self GetTagOrigin( rocketTag );
		
		rocket = MagicBullet( level.strafeRunRocketWeapon, rocketOrigin, rocketOrigin + forward, self.owner );
		if ( isdefined( selectedTarget ) )
		{
			rocket missile_settarget( selectedTarget, (0,0,0) );
		}
		rocket.soundMod = "straferun";

		wait level.strafeRunRocketDelay;
	}
}

function stopStrafe()
{
	self notify( "strafe_stop" );
	
	self.strafing = undefined;

	self ClearTurretTarget();
	owner = self.owner;
	//self thread fireFlares();

	//TODO Add the negative BDA lines after they are recorded.
	if (owner.strafeRunbda == 0)
	{
		bdaDialog = "kls_killn";
	}
	if (owner.strafeRunbda == 1)
	{
		bdaDialog = "kls_kill1";
	}
	if (owner.strafeRunbda == 2)
	{
		bdaDialog = "kls_kill2";
	}
	if (owner.strafeRunbda == 3)
	{
		bdaDialog = "kls_kill3";
	}
	if (owner.strafeRunbda > 3)
	{
		bdaDialog = "kls_killm";
	}	
	
	if (isdefined(bdaDialog))
	{
		//play pilot dialog
		self thread PilotDialogWait( bdaDialog, 3.5 );	
	}
	
	owner.strafeRunbda = 0;
	self.gunSoundEntity StopLoopSound();
	self.gunSoundEntity playsound ("wpn_a10_shot_decay_npc");
	self.numStrafes++;
}

function PilotDialogWait( Dialog, time )
{
	self endon( "death" );
	if (isdefined(time))
	{
		wait time;
	}
	
	PlayPilotDialog( Dialog );
}

function shouldLeaveMap()
{
	if ( isdefined( self.leaveNextTime ) && self.leaveNextTime )
	{
		return true;
		
		//PlayPilotDialog("a10_used");		
	
	}
	
	if ( self.numStrafes >= level.strafeRunMaxStrafes )
	{
		return true;
	}
	
	if (self.owner.straferunKills >= level.strafeRunKillsBeforeExit )
	{
		return true;	
	}
	
	return false;
}

function leaveMap()
{
	
	exitOrigin = self.origin + VectorScale( AnglesToForward( self.angles ), level.strafeRunExitUnits );
	
	/*self ClearTargetYaw();
	self ClearGoalYaw();*/
	self SetYawSpeed( 5, 999, 999 );
	self SetVehGoalPos( exitOrigin, 1 );
	
	wait 5;
	if ( isdefined ( self ) )
	{
		self Delete();
	}
}

function explode()
{
	self endon( "delete" );

	forward = ( self.origin + ( 0, 0, 100 ) ) - self.origin;
	PlayFX( level.strafeRunExplodeFX, self.origin, forward );
	
	// play heli explosion sound
	self PlaySound( level.strafeRunExplodeSound );
	
	wait( 0.1 );
	
	if ( IsDefined( self ) )
	{
		self Delete();
	}
}

function canTargetEntity( entity )
{
	/*if ( distance( entity.origin, self.origin ) > level.heli_visual_range )
	{
		return false;
	}*/
	
	heli_centroid = self.origin + ( 0, 0, -160 );
	heli_forward_norm = anglestoforward( self.angles );
	heli_turret_point = heli_centroid + 144*heli_forward_norm;
	
	visible_amount = entity sightConeTrace( heli_turret_point, self );
	
	if ( visible_amount < level.heli_target_recognition )
	{
		return false;
	}
	
	return true;
}

function canTargetPlayer( player )
{
	if ( !IsAlive( player ) || player.sessionstate != "playing" )
	{
		return false;
	}
	
	if ( player == self.owner )
	{
		return false;
	}

	if ( player airsupport::canTargetPlayerWithSpecialty() == false ) 
	{
		return false;
	}
	
	if ( !isdefined( player.team ) )
	{
		return false;
	}
	
	if ( level.teamBased && player.team == self.team )
	{
		return false;
	}
	
	if ( player.team == "spectator" )
	{
		return false;
	}
	
	if ( isdefined( player.spawntime ) && ( GetTime() - player.spawntime )/1000 <= level.heli_target_spawnprotection )
	{
		return false;
	}
		
	if ( !targetInFrontOfPlane( player ) )
	{
		return false;	
	}
	
	if ( player IsInMoveMode( "noclip" ))
	{
		return false;	
	}
	
	return canTargetEntity( player );
}

function canTargetActor( actor )
{
	if ( !isdefined( actor ) )
	{
		return false;
	}
	
	if ( level.teamBased && ( actor.team == self.team ) )
	{
		return false;
	}
	
	if ( isdefined( actor.script_owner ) && self.owner == actor.script_owner )
	{
		return false;
	}
	
	if ( !targetInFrontOfPlane( actor ) )
	{
		return false;	
	}
	
	return canTargetEntity( actor );
}

function targetInFrontOfPlane( target )
{
	forward_dir = AnglesToForward(self.angles);
	target_delta = VectorNormalize( target.origin - self.origin );
	dot = VectorDot( forward_dir, target_delta );
	
	// 60 degrees
	if ( dot < 0.5 )
		return true;
		
	return true;
}

function getValidTargets()
{
	targets = [];
	foreach( player in level.players )
	{
		if ( self canTargetPlayer( player ) )
		{
			if( isdefined( player ) )
				targets[targets.size] = player;
		}
		
	}
	
	dogs = dogs::dog_manager_get_dogs();
	
	foreach( dog in dogs )
	{
		if ( self canTargetActor( dog ) )
		{
			targets[targets.size] = dog;
		}
	}
	
	tanks = GetEntArray( "talon", "targetname" );
	
	foreach( tank in tanks )
	{
		if ( self canTargetActor( tank ) )
		{
			targets[targets.size] = tank;
		}
	}
	
	return targets;
}

function deadReconTargetOrigin( rocket_start, target )
{
	target_velocity = target GetVelocity();
	
	// would be nice to get this from the gdt.
	missile_speed = 7000;
	
	target_delta = target.origin - rocket_start;
	
	target_dist = Length( target_delta );
	
	time_to_target = target_dist / missile_speed;
	
	return target.origin + target_velocity * time_to_target;
}

function shellShockPlayers( origin )
{
	foreach( player in level.players )
	{
		if ( !IsAlive( player ) )
		{
			continue;
		}
		
		if ( player == self.owner )
		{
			continue;
		}
		
		if ( !isdefined( player.team ) )
		{
			continue;
		}
		
		if ( level.teamBased && player.team == self.team )
		{
			continue;
		}
		
		if ( DistanceSquared( player.origin, origin ) <= level.strafeRunShellShockRadius * level.strafeRunShellShockRadius )
		{
			player thread strafeRunShellShock();
		}
	}
}

function strafeRunShellShock()
{
	self endon( "disconnect" );
	
	if ( isdefined( self.beingStrafeRunShellShocked ) && self.beingStrafeRunShellShocked )
	{
		return;
	}
	
	self.beingStrafeRunShellShocked = true;
	
	self ShellShock( level.strafeRunShellShock, level.strafeRunShellShockDuration );
	wait( level.strafeRunShellShockDuration + 1 );
	
	self.beingStrafeRunShellShocked = false;
}

function deleteWhenParentDies( parent )
{
	parent waittill("death");
	
	self delete();
}

function unlinkWhenParentDies( parent )
{
	self endon("reset");
	self endon("unlink");
	
	parent waittill("death");
	
	self unlink();
}

function unlinkWhenClose( selectedTarget, targetOrigin, plane )
{
	plane endon( "death" );
	self notify( "unlink_when_close" );
	self endon( "unlink_when_close" );
	
	distSqr = 1000 * 1000;
	
	while ( 1 )
	{
		if ( isdefined( selectedTarget ) )
		{
			if ( DistanceSquared( self.origin, selectedTarget.origin ) < distSqr )
			{
				self unlink();
				self.angles = (0,0,0);		
				return;	
			}
		}
		else
		{
			if ( DistanceSquared( self.origin, targetOrigin ) < distSqr )
			{
				self unlink();
				self.angles = (0,0,0);		
				return;	
			}
		}
		wait( 0.1 );
	}
}

function getLookaheadOrigin( previous_origin, next_origin, lookAhead )
{
	delta = next_origin - previous_origin;
	forwardNoZ = VectorNormalize( (delta[0],delta[1],0) );
	origin = next_origin + VectorScale( forwardNoZ, lookAhead );
	return origin;
}

function getStrafeDistance(node)
{
	previous_node = node;
	next_node = GetVehicleNode( previous_node.target, "targetname" );

	dist = 0;
	
	//dist = Distance( ( self.origin[0], self.origin[1], 0 ), ( node.origin[0], node.origin[1], 0 ) );
	
	while ( (!isdefined(previous_node.script_noteworthy) || previous_node.script_noteworthy != "strafe_stop") && next_node != node )
	{
		dist += Distance( (previous_node.origin[0], previous_node.origin[1], 0) , ( next_node.origin[0], next_node.origin[1], 0 ) );

		previous_node = next_node;
		next_node = GetVehicleNode( previous_node.target, "targetname" );
	}
	
	return dist;
}

function getOriginAlongStrafePath(node, start_origin, distance_along)
{
	origin_node = SpawnStruct();
	
//	previous_node = node;
//	next_node = GetVehicleNode( previous_node.target, "targetname" );

//	seg_dist = Distance( (previous_node.origin[0], previous_node.origin[1], 0) , ( next_node.origin[0], next_node.origin[1], 0 ) );

	seg_dist = Distance( (start_origin[0], start_origin[1], 0) , ( node.origin[0], node.origin[1], 0 ) );
	
	dist = 0;
	
	if ( (dist + seg_dist) > distance_along )
	{
		forwardVec = VectorNormalize(  ( node.origin[0], node.origin[1], 0 ) - (start_origin[0], start_origin[1], 0) );
		origin_node.origin = start_origin + forwardVec * ( distance_along - dist );
		origin_node.node = node;
		return origin_node;
	}
	
	dist = seg_dist;
	
	previous_node = node;
	next_node = GetVehicleNode( previous_node.target, "targetname" );

	while ( (!isdefined(previous_node.script_noteworthy) || previous_node.script_noteworthy != "strafe_stop") && next_node != node )
	{
		seg_dist = Distance( (previous_node.origin[0], previous_node.origin[1], 0) , ( next_node.origin[0], next_node.origin[1], 0 ) );
	
		if ( (dist + seg_dist) > distance_along )
		{
			forwardVec = VectorNormalize( next_node.origin - previous_node.origin );
			origin_node.origin = previous_node.origin + forwardVec * ( distance_along - dist );
			origin_node.node = previous_node;
			return origin_node;
		}
		
		dist += seg_dist;
		previous_node = next_node;
		next_node = GetVehicleNode( previous_node.target, "targetname" );
	}
}