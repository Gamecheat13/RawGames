#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_airsupport;
#include maps\mp\gametypes\_battlechatter_mp;


init()
{
	level.strafeRunNumRockets = 4;
	level.strafeRunRocketDelay = 0.5;
	level.strafeRunGunLookahead = 4000;
	level.strafeRunGunOffset = -800;
	level.strafeRunGunRadius = 500;
	level.strafeRunExitUnits = 20000;
	level.strafeRunMaxStrafes = 4;
	level.strafeRunFlareDelay = 2;
	level.strafeRunShellShockDuration = 2.5;
	level.strafeRunShellShockRadius = 512;
	level.strafeRunKillsBeforeExit = 8;
	level.strafeRunNumKillcams = 5;

	level.strafeRunModel = "veh_t6_air_a10f";
	level.strafeRunModelEnemy = "veh_t6_air_a10f_alt";
	level.strafeRunVehicle = "vehicle_straferun_mp";
	level.strafeRunGunWeapon = "straferun_gun_mp";
	level.strafeRunGunSound = "wpn_a10_shot_loop_npc";
	level.strafeRunRocketWeapon = "straferun_rockets_mp";
	level.strafeRunRocketTags = [];
	level.strafeRunRocketTags[0] = "tag_rocket_left";
	level.strafeRunRocketTags[1] = "tag_rocket_right";
	level.strafeRunContrailFX = LoadFX( "vehicle/exhaust/fx_exhaust_a10_contrail" );
	level.strafeRunChaffFX = LoadFX( "weapon/straferun/fx_straferun_chaf" );
	level.strafeRunExplodeFX = LoadFX( "vehicle/vexplosion/fx_vexplode_helicopter_exp_mp" );
	level.strafeRunExplodeSound = "evt_helicopter_midair_exp";
	level.strafeRunShellShock = "straferun";
	
	PrecacheModel( level.strafeRunModel );
	PrecacheModel( level.strafeRunModelEnemy );
	PrecacheVehicle( level.strafeRunVehicle );
	PrecacheItem( level.strafeRunGunWeapon );
	PrecacheItem( level.strafeRunRocketWeapon );
	PrecacheShellShock( level.strafeRunShellShock );
	
	maps\mp\killstreaks\_killstreaks::registerKillstreak( "straferun_mp", "straferun_mp", "killstreak_straferun", "straferun_used", ::useKillstreakStrafeRun, true);
	maps\mp\killstreaks\_killstreaks::registerKillstreakStrings( "straferun_mp", &"MP_EARNED_STRAFERUN", &"KILLSTREAK_STRAFERUN_NOT_AVAILABLE", &"MP_WAR_STRAFERUN_INBOUND", &"MP_WAR_STRAFERUN_INBOUND_NEAR_YOUR_POSITION" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakDialog( "straferun_mp", "mpl_killstreak_straferun", "kls_straferun_used", "","kls_straferun_enemy", "", "kls_straferun_ready");
	maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar( "straferun_mp", "scr_givestraferun" );
	maps\mp\killstreaks\_killstreaks::registerKillstreakAltWeapon( "straferun_mp", level.strafeRunGunWeapon );
	maps\mp\killstreaks\_killstreaks::registerKillstreakAltWeapon( "straferun_mp", level.strafeRunRocketWeapon );

	// killcams are created on level start and live all game
	createKillcams( level.strafeRunNumKillcams, level.strafeRunNumRockets );
}

PlayPilotDialog( dialog )
{

	soundAlias = level.teamPrefix[self.team] + self.pilotVoiceNumber + "_" + dialog;
	
	if ( isDefined( self.owner ) )
	{
		if (self.owner.pilotisSpeaking)
		{
			while (self.owner.pilotisSpeaking)
			{
				wait (.2);
			}
		}
	}
	if ( isDefined( self.owner ) )
	{
		self.owner playLocalSound(soundAlias);
		self.owner.pilotisSpeaking = true;
		self.owner thread waitPlayBackTime( soundAlias ); 
		self.owner waittill_any( soundAlias, "death", "disconnect" );
		self.owner.pilotisSpeaking = false;
	}
	
	
}
	
useKillstreakStrafeRun( hardpointType )
{
	startNode = GetVehicleNode( "warthog_start", "targetname" );
	if ( !isDefined( startNode ) )
	{
/#		println( "ERROR: Strafe run vehicle spline not found!" );	#/
		return false;
	}
	
	killstreak_id = self maps\mp\killstreaks\_killstreakrules::killstreakStart( "straferun_mp", self.team, false, true );
	if ( killstreak_id == -1 )
	{
		return false;
	}
	

	// Spawn and setup vehicle
	plane = SpawnVehicle( level.strafeRunModel, "straferun", level.strafeRunVehicle, startNode.origin, (0,0,0) );
	plane SetVehicleTeam( self.team );
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
	plane.numFlares = 100;
	plane.soundMod = "straferun";
	plane SetDrawInfrared( true );
	self.straferunKills = 0;
	plane.bda = 0;
	self.pilotisSpeaking = false;	
	plane.pilotVoiceNumber = self.bcVoiceNumber + 1;
	if 	(plane.pilotVoiceNumber > 3) 
	{
		plane.pilotVoiceNumber = 0;
	}
	self maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "straferun_mp", self.pers["team"] );
	//play pilot dialog
	plane thread PilotDialogWait ("a10_used", 2.5);	


	// make targetable
	Target_Set( plane, (0,0,0) );
	Target_SetTurretAquire( plane, false );
	
	plane thread playContrail();
	
	// Setup vehicle weapons
	//plane setVehWeapon( level.strafeRunGunWeapon );
	plane.gunSoundEntity = Spawn( "script_model", plane GetTagOrigin( "tag_flash" ) );
	plane.gunSoundEntity LinkTo( plane, "tag_flash", (0,0,0), (0,0,0) );
	
	//plane.killCamEntities = level.strafeRunKillcams.strafes;
	
	plane resetKillcams();

	plane thread watchForOtherKillstreaks();
	plane thread watchForKills();
	plane thread doStrafeRuns();
	plane thread maps\mp\_vehicles::follow_path( startNode );
	plane thread maps\mp\_heatseekingmissile::MissileTarget_ProximityDetonateIncomingMissile("death");	
	plane thread watchForOwnerExit( self );

	return true;
}

playContrail()
{
	self endon( "death" );
	
	wait( 0.1 );
	PlayFXOnTag( level.strafeRunContrailFX, self, "tag_origin" );
	self playloopsound ("veh_a10_engine_loop", 1);
}

cleanupOnDeath()
{	
	self waittill( "death" );
	
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "straferun_mp", self.team, self.killstreak_id );
	
	if( IsDefined( self.gunSoundEntity ) )
	{
		self.gunSoundEntity StopLoopSound();
		self.gunSoundEntity Delete();
		self.gunSoundEntity = undefined;
	}
}

watchForOtherKillstreaks()
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

		if ( hardpointType == "emp_mp" )
		{
			if ( self.owner IsEnemyPlayer( attacker ) ) 
			{
				self thread explode();
				maps\mp\_scoreevents::processScoreEvent( "destroyed_strafe_run", attacker, self.owner, hardpointType );
				return;
			}
		}
		else if ( hardpointType == "missile_swarm_mp" )
		{
			if ( self.owner IsEnemyPlayer( attacker ) ) 
			{
				self.leaveNextTime = true;
			}
		}
	}
}

watchForKills()
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

watchForOwnerExit( owner )
{
	self endon( "death" );
	
	owner waittill_any( "disconnect", "joined_team", "joined_spectator");
	self.leaveNextTime = true;
}

addStraferunKill()
{
	if ( !isDefined( self.straferunKills ) )
	{
		self.straferunKills = 0;
	}
	self.straferunKills++;	
}

doStrafeRuns()
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
			self.strafeRunGunLookahead = getDvarIntDefault( #"scr_straferunlookahead", level.strafeRunGunLookahead ); 
			self.strafeRunGunRadius = getDvarIntDefault( #"scr_straferunradius", level.strafeRunGunRadius ); ;
			self.strafeRunGunOffset = getDvarIntDefault( #"scr_straferunoffset", level.strafeRunGunOffset ); ;
#/
			
			if ( IsDefined( noteworthyNode ) )
			{
				if ( IsDefined( noteworthyNode.script_parameters ) )
				{
					self.strafeRunGunLookahead = float( noteworthyNode.script_parameters );
				}
				
				if ( IsDefined( noteworthyNode.script_radius ) )
				{
					self.strafeRunGunRadius = float( noteworthyNode.script_radius );
				}
					
				if ( IsDefined( noteworthyNode.script_float ) )
				{
					self.strafeRunGunOffset = float( noteworthyNode.script_float );
				}
			}
			if ( IsDefined( self.owner ) )
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

fireFlares()
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
		
		chaff_fx thread DeleteAfterTimeThread( level.strafeRunFlareDelay );
		
		wait( level.strafeRunFlareDelay );
	}
}

startStrafe(  )
{
	self endon( "death" );
	self endon( "strafe_stop" );
	
	if ( IsDefined( self.strafing ) )
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
	
	self thread startStrafeKillcams();

//	self planeSounds( undefined, "evt_flyby_apex_2362", "evt_flyby_wash_2362", 2362 ); 

	count = 0;
	weaponShootTime = WeaponFireTime( level.strafeRunGunWeapon );
	for ( ;; )
	{
		gunOrigin = self GetTagOrigin( "tag_flash" );
		gunOrigin += ( 0, 0, self.strafeRunGunOffset );
		forward = AnglesToForward( self.angles );
		forwardNoZ = VectorNormalize( (forward[0],forward[1],0) );
		right = VectorCross( forwardNoZ, (0,0,1) );
		perfectAttackStartVector = gunOrigin + VectorScale( forwardNoZ, self.strafeRunGunLookahead );
		attackStartVector = perfectAttackStartVector + VectorScale( right, RandomFloatRange( 0-self.strafeRunGunRadius, self.strafeRunGunRadius ) );

		trace = BulletTrace( attackStartVector, (attackStartVector[0],attackStartVector[1],-500), false, self, false, true );
		self SetTurretTargetVec( trace["position"] );
		self FireWeapon( "tag_flash" );
		self.gunSoundEntity PlayLoopSound( level.strafeRunGunSound );
		self shellShockPlayers( trace["position"] );
		
/#
		if (  getDvarIntDefault( #"scr_devStrafeRunBulletsDebugDraw", 0 ) )
		{
			time = 300;
			debug_line( attackStartVector, trace["position"] - ( 0,0,20 ), (1,0,0), time, false );
			if( count % 30 == 0 )
			{
				trace = BulletTrace( perfectAttackStartVector, (perfectAttackStartVector[0],perfectAttackStartVector[1],-100000), false, self, false, true );
				debug_line( trace["position"] + ( 0,0,20 ), trace["position"] - ( 0,0,20 ), (0,0,1), time, false );
			}
		}
#/
		count++;
		wait weaponShootTime;
	}
	
}

firstStrafe()
{
	/*Target_Set( self );
	Target_SetTurretAquire( self, true );*/
}

fireRockets()
{
	self notify( "firing_rockets" );
	
	self endon( "death" );
	self endon( "strafe_stop" );
	self endon( "firing_rockets" );
	self.owner endon( "disconnect" );
	
	self.firedRocketTargets = [];
	
	for ( rocketIndex = 0 ; rocketIndex < level.strafeRunNumRockets ; rocketIndex++ )
	{
		rocketTag = level.strafeRunRocketTags[rocketIndex%level.strafeRunRocketTags.size];
		
		// If possible, choose the highest priority target we haven't already fired a rocket at, otherwise just choose the highest priority target
		targets = getValidTargets();
		rocketOrigin = self GetTagOrigin( rocketTag );
		targetOrigin = rocketOrigin + anglesToForward( self.angles ) * 10000;
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
		
		rocket = MagicBullet( level.strafeRunRocketWeapon, self GetTagOrigin( rocketTag ), targetOrigin, self.owner );
		rocket.soundMod = "straferun";
	
		rocket thread attachKillcamToRocket( level.strafeRunKillcams.rockets[rocketIndex], targetOrigin );
		
/#
		if ( getDvarIntDefault( #"scr_devStrafeRunKillcamsDebugDraw", 0 ) )
			rocket thread debug_draw_bomb_path( undefined, (0,0.5,0), 400 );
#/

		wait level.strafeRunRocketDelay;
	}
}

stopStrafe()
{
	self notify( "strafe_stop" );
	
	self.strafing = undefined;
	
	// after the strafe run is done reset the killcams for the next strafe
	self thread resetKillcams( 3 );

	self ClearTurretTarget();
	
	//self thread fireFlares();

	//TODO Add the negative BDA lines after they are recorded.
	if (self.bda == 0)
	{
		bdaDialog = "kls_killn";
	}
	if (self.bda == 1)
	{
		bdaDialog = "kls_kill1";
	}
	if (self.bda == 2)
	{
		bdaDialog = "kls_kill2";
	}
	if (self.bda == 3)
	{
		bdaDialog = "kls_kill3";
	}
	if (self.bda > 3)
	{
		bdaDialog = "kls_killm";
	}	
	
	if (IsDefined(bdaDialog))
	{
		//play pilot dialog
		self thread PilotDialogWait( bdaDialog, 3.5 );	
	}
	
	self.bda = 0;
		
	self.gunSoundEntity StopLoopSound();
	self.gunSoundEntity playsound ("wpn_a10_shot_decay_npc");
	self.numStrafes++;
}

PilotDialogWait( Dialog, time )
{
	self endon( "death" );
	if (IsDefined(time))
	{
		wait time;
	}
	
	PlayPilotDialog( Dialog );
}

shouldLeaveMap()
{
	if ( IsDefined( self.leaveNextTime ) && self.leaveNextTime )
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

leaveMap()
{
	self unlinkKillcams();
	
	exitOrigin = self.origin + VectorScale( AnglesToForward( self.angles ), level.strafeRunExitUnits );
	
	/*self ClearTargetYaw();
	self ClearGoalYaw();*/
	self SetYawSpeed( 5, 999, 999 );
	self SetVehGoalPos( exitOrigin, 1 );
	
	wait 5;
	
	self Delete();
}

explode()
{
	self endon( "delete" );

	forward = ( self.origin + ( 0, 0, 100 ) ) - self.origin;
	PlayFX( level.strafeRunExplodeFX, self.origin, forward );
	
	// play heli explosion sound
	self PlaySound( level.strafeRunExplodeSound );
	
	wait( 0.1 );
	
	self Delete();
}

canTargetEntity( entity )
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

canTargetPlayer( player )
{
	if ( !IsAlive( player ) || player.sessionstate != "playing" )
	{
		return false;
	}
	
	if ( player == self.owner )
	{
		return false;
	}

	if ( player canTargetPlayerWithSpecialty() == false ) 
	{
		return false;
	}
	
	if ( !IsDefined( player.team ) )
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
	
	if ( IsDefined( player.spawntime ) && ( GetTime() - player.spawntime )/1000 <= level.heli_target_spawnprotection )
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

canTargetActor( actor )
{
	if ( !IsDefined( actor ) )
	{
		return false;
	}
	
	if ( level.teamBased && ( actor.aiteam == self.team ) )
	{
		return false;
	}
	
	if ( IsDefined( actor.script_owner ) && self.owner == actor.script_owner )
	{
		return false;
	}
	
	if ( !targetInFrontOfPlane( actor ) )
	{
		return false;	
	}
	
	return canTargetEntity( actor );
}

targetInFrontOfPlane( target )
{
	forward_dir = AnglesToForward(self.angles);
	target_delta = VectorNormalize( target.origin - self.origin );
	dot = VectorDot( forward_dir, target_delta );
	
	// 60 degrees
	if ( dot < 0.5 )
		return true;
		
	return true;
}

getValidTargets()
{
	targets = [];
	foreach( player in level.players )
	{
		if ( self canTargetPlayer( player ) )
		{
			if( IsDefined( player ) )
				targets[targets.size] = player;
		}
		
	}
	
	dogs = maps\mp\killstreaks\_dogs::dog_manager_get_dogs();
	
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

deadReconTargetOrigin( rocket_start, target )
{
	target_velocity = target GetVelocity();
	
	// would be nice to get this from the gdt.
	missile_speed = 7000;
	
	target_delta = target.origin - rocket_start;
	
	target_dist = Length( target_delta );
	
	time_to_target = target_dist / missile_speed;
	
	return target.origin + target_velocity * time_to_target;
}

shellShockPlayers( origin )
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
		
		if ( !IsDefined( player.team ) )
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

strafeRunShellShock()
{
	self endon( "disconnect" );
	
	if ( IsDefined( self.beingStrafeRunShellShocked ) && self.beingStrafeRunShellShocked )
	{
		return;
	}
	
	self.beingStrafeRunShellShocked = true;
	
	self ShellShock( level.strafeRunShellShock, level.strafeRunShellShockDuration );
	wait( level.strafeRunShellShockDuration + 1 );
	
	self.beingStrafeRunShellShocked = false;
}

createKillcams( numKillcams, numRockets )
{
	// killcams are only created once per level
	if ( !isdefined(level.strafeRunKillcams) )
	{
		level.strafeRunKillcams = SpawnStruct();
		
		level.strafeRunKillcams.rockets = [];
		for ( i = 0; i < numRockets; i++ )
		{
			level.strafeRunKillcams.rockets[level.strafeRunKillcams.rockets.size] = createKillcamEnt( );
		}
		
		level.strafeRunKillcams.strafes = [];
		for ( i = 0; i < numKillcams; i++ )
		{
			level.strafeRunKillcams.strafes[level.strafeRunKillcams.strafes.size] = createKillcamEnt( );
/#
		if ( getDvarIntDefault( #"scr_devStrafeRunKillcamsDebugDraw", 0 ) )
			level.strafeRunKillcams.strafes[i] thread debug_draw_bomb_path( undefined, (0,0,0.5), 200 );
#/	
		}
	}
	
}

resetKillcams( time )
{
	if ( isdefined( time ) )
		wait( time );
		
	for ( i = 0; i < level.strafeRunKillcams.rockets.size; i++ )
	{
		level.strafeRunKillcams.rockets[i] resetKillcamEnt( self );
	}
	
	for ( i = 0; i < level.strafeRunKillcams.strafes.size; i++ )
	{
		level.strafeRunKillcams.strafes[i] resetKillcamEnt( self );
	}
}

unlinkKillcams()
{
	for ( i = 0; i < level.strafeRunKillcams.rockets.size; i++ )
	{
		level.strafeRunKillcams.rockets[i] unlink();
	}
	
	for ( i = 0; i < level.strafeRunKillcams.strafes.size; i++ )
	{
		level.strafeRunKillcams.strafes[i] unlink();
	}
}

createKillcamEnt()
{
	killCamEnt = spawn( "script_model", (0,0,0)  );
	//killCamEnt thread deleteWhenParentDies( self );
	
	killCamEnt SetFOVForKillcam( 25 );
	
	return killCamEnt;
}

resetKillcamEnt( parent )
{
	self notify( "reset" );
	
	offset_x = getDvarIntDefault( #"scr_killcamplaneoffsetx", -1200 );
	offset_y = getDvarIntDefault( #"scr_killcamplaneoffsety", 0 );
	offset_z = getDvarIntDefault( #"scr_killcamplaneoffsetz", 120 );
	
	self linkto( parent, "tag_origin", (offset_x, offset_y, offset_z), (0,0,0) );
	self thread unlinkWhenParentDies( parent );
}

deleteWhenParentDies( parent )
{
	parent waittill("death");
	
	self delete();
}

unlinkWhenParentDies( parent )
{
	self endon("reset");
	self endon("unlink");
	
	parent waittill("death");
	
	self unlink();
}

attachKillcamToRocket( killCamEnt, targetOrigin )
{
	offset_x = getDvarIntDefault( #"scr_killcamrocketoffsetx", 500 );
	offset_y = getDvarIntDefault( #"scr_killcamrocketoffsety", 20 );
	offset_z = getDvarIntDefault( #"scr_killcamrocketoffsetz", 20 );

	self.killCamEnt = killCamEnt;

	forward = VectorScale( AnglesToForward( self.angles ), offset_x );
	right = VectorScale( AnglesToRight( self.angles ), offset_y );
	up = VectorScale( AnglesToUp( self.angles ), offset_z );
	
	speed = length( self getvelocity() );
	
	rocket_delta = targetOrigin - self.origin;
	rocket_normal = VectorNormalize( rocket_delta );
	
	traceTarget = BulletTrace( self.origin, targetOrigin, false, self );
	if ( isDefined(traceTarget) )
	{
		camera_target = traceTarget["position"] - VectorScale( rocket_normal, offset_x ) + right + up;
	}
	else
	{
		camera_target = targetOrigin - VectorScale( rocket_normal, offset_x ) + right + up;
	}
	rocket_delta_dist = length( camera_target - self.origin );
	rocket_time = rocket_delta_dist / speed;

	time = 0.1;
	
	killCamEnt unlink();
	killCamEnt.angles = (0,0,0);
	
	killCamEnt MoveTo( self.origin + right + up, time, 0, 0 );
	killCamEnt waittill( "movedone" );	

	decel = 0;
	if ( decel > rocket_time )
		decel = rocket_time;
	
	killCamEnt MoveTo( camera_target, rocket_time, 0, decel );

	//killCamEnt linkto( self, "tag_origin", forward + right + up , (0,0,0) );
}

getLookaheadOrigin( previous_origin, next_origin, lookAhead )
{
	delta = next_origin - previous_origin;
	forwardNoZ = VectorNormalize( (delta[0],delta[1],0) );
	origin = next_origin + VectorScale( forwardNoZ, lookAhead );
	return origin;
}

strafeKillcam( parent, node, distance )
{
	parent endon("death");
	self endon( "reset" ); 
	
	// let the plane start firing
	wait (0.05);
	
	self notify( "unlink" );
	self Unlink();
	self.angles = (0,0,0);
	
	accel_time = 0.2;
	speed = 20000;
	
	start_height_offset = -800;
	stop_height = level.mapCenter[2] - 500;

	start_origin_struct = getOriginAlongStrafePath( node, self.origin, distance );
	start_origin = start_origin_struct.origin;
	node = start_origin_struct.node;
	
	previous_origin = self.origin;
	
	start_origin = getLookaheadOrigin( previous_origin, start_origin, parent.strafeRunGunLookahead + 1000);
	
	trace = BulletTrace( (start_origin[0], start_origin[1], start_origin[2] + start_height_offset), (start_origin[0], start_origin[1], stop_height), false, parent, false, true );
	
	pathHeight = trace["position"][2];
	
	self killcamMoveto( trace["position"], speed, accel_time, pathHeight );
	
	speed = 500;

	while( isdefined(node) )
	{
		previous_origin = node.origin;
		node = GetVehicleNode( node.target, "targetname" );
	
		start_origin = getLookaheadOrigin( previous_origin, node.origin, parent.strafeRunGunLookahead + 1000 );
	
		trace = BulletTrace( (start_origin[0], start_origin[1], start_origin[2] + start_height_offset), (start_origin[0], start_origin[1], stop_height), false, parent, false, true );
		self killcamMoveto( trace["position"], speed, 0, pathHeight );
	}
}

killcamMoveto( goal, speed, accel, pathHeight )
{
	self endon( "reset" ); 
	
	height_offset = RandomIntRange(350,450);
	origin = (goal[0], goal[1], goal[2] + height_offset );
	dist = Distance( origin, self.origin );
	time = dist / speed ;
	
	if ( accel > time )
		accel = time;
	
	self MoveTo( origin, time, accel, 0 );
	self waittill( "movedone" );	
}

startStrafeKillcams()
{
	node = GetVehicleNode( self.currentNode.target, "targetname" );
	strafe_dist = getStrafeDistance(node);
	
	strafe_increment = strafe_dist / (level.strafeRunKillcams.strafes.size + 1); 
	current_dist = 10; // so we dont get a zero length delta on first point
	
	for ( i = 0; i < level.strafeRunKillcams.strafes.size; i++ )
	{
		level.strafeRunKillcams.strafes[i] thread strafeKillcam( self, node, current_dist );
		current_dist += strafe_increment;
		//wait( 0.5 );
	}
}

getStrafeDistance(node)
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

getOriginAlongStrafePath(node, start_origin, distance_along)
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