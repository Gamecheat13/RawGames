#include maps\mp\_utility;
#include common_scripts\utility;

init()
{
	level.strafeRunNumRockets = 4;
	level.strafeRunRocketDelay = 0.5;
	level.strafeRunGunLookahead = 2000;
	level.strafeRunGunRadius = 1000;
	level.strafeRunExitUnits = 10000;
	level.strafeRunMaxStrafes = 3;
	level.strafeRunFlareDelay = 7.5;
	level.strafeRunShellShockDuration = 2.5;
	level.strafeRunShellShockRadius = 512;
	
	level.strafeRunModel = "veh_iw_air_a10";
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
}

useKillstreakStrafeRun( hardpointType )
{
	startNode = GetVehicleNode( "warthog_start", "targetname" );
	if ( !isDefined( startNode ) )
	{
		println( "ERROR: Strafe run vehicle spline not found!" );
		return false;
	}
	
	if ( !self maps\mp\killstreaks\_killstreakrules::killstreakStart( "straferun_mp", self.team, false, true ) )
	{
		return false;
	}
	
	// Spawn and setup vehicle
	plane = SpawnVehicle( level.strafeRunModel, "straferun", level.strafeRunVehicle, startNode.origin, (0,0,0) );
	plane SetVehicleTeam( self.team );
	plane.team = self.team;
	plane MakeVehicleUnusable();
	plane thread cleanupOnDeath();
	plane.health = 999999;
	plane.maxhealth = 999999;
	plane SetOwner( self );
	plane.owner = self;
	plane.numStrafes = 0;
	
	plane thread playContrail();
	
	// Setup vehicle weapons
	plane setVehWeapon( level.strafeRunGunWeapon );
	plane.gunSoundEntity = Spawn( "script_model", plane GetTagOrigin( "tag_flash" ) );
	plane.gunSoundEntity LinkTo( plane, "tag_flash", (0,0,0), (0,0,0) );
	
	plane thread watchForOtherKillstreaks();
	plane thread watchForKills();
	plane thread doStrafeRuns();
	plane thread maps\mp\_vehicles::follow_path( startNode );

	return true;
}

playContrail()
{
	self endon( "death" );
	
	wait( 0.1 );
	PlayFXOnTag( level.strafeRunContrailFX, self, "tag_origin" );	
}

cleanupOnDeath()
{	
	self waittill( "death" );
	
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "straferun_mp", self.team );
	
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
		level waittill( "killstreak_started", hardpointType, teamName );
		if ( hardpointType == "emp_mp" )
		{
			if ( teamName != self.team )
			{
				self thread explode();
				return;
			}
		}
		else if ( hardpointType == "missile_swarm_mp" )
		{
			if ( teamName != self.team )
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
		/*if ( IsPlayer( player ) )
		{
			IPrintLnBold( "STRAFE RUN KILLED PLAYER\n" );
		}
		else
		{
			IPrintLnBold( "STRAFE RUN KILLED SOMETHING ELSE\n" );
		}*/
	}
}

doStrafeRuns()
{
	self endon( "death" );
	
	self thread fireFlares();
	
	for ( ;; )
	{
		self waittill( "noteworthy", noteworthy, noteworthyNode );
		if ( noteworthy == "strafe_start" )
		{
			if ( IsDefined( noteworthyNode ) && IsDefined( noteworthyNode.script_parameters ) )
			{
				self.strafeRunGunLookahead = float( noteworthyNode.script_parameters );
			}
			else
			{
				self.strafeRunGunLookahead = level.strafeRunGunLookahead;
			}
			self thread startStrafe();
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

startStrafe()
{
	self endon( "death" );
	self endon( "strafe_stop" );
	
	if ( IsDefined( self.strafing ) )
	{
		IPrintLnBold( "TRYING TO STRAFE WHEN ALREADY STRAFING!\n" );
		return;
	}
	self.strafing = true;
	
	// First strafe
	if ( self.numStrafes == 0 )
	{
		self firstStrafe();
	}
	
	self thread fireRockets();
	
//	self planeSounds( undefined, "evt_flyby_apex_2362", "evt_flyby_wash_2362", 2362 ); 
	
	weaponShootTime = WeaponFireTime( level.strafeRunGunWeapon );
	for ( ;; )
	{
		gunOrigin = self GetTagOrigin( "tag_flash" );
		forward = AnglesToForward( self.angles );
		forwardNoZ = VectorNormalize( (forward[0],forward[1],0) );
		right = VectorCross( forwardNoZ, (0,0,1) );
		attackStartVector = gunOrigin + VectorScale( forwardNoZ, self.strafeRunGunLookahead ) + VectorScale( right, RandomFloatRange( 0-level.strafeRunGunRadius, level.strafeRunGunRadius ) );
		trace = BulletTrace( attackStartVector, (attackStartVector[0],attackStartVector[1],-100000), false, self, false, true );
		self SetTurretTargetVec( trace["position"] );
		self FireWeapon( "tag_flash" );
		self.gunSoundEntity PlayLoopSound( level.strafeRunGunSound );
		self shellShockPlayers( trace["position"] );
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
			selectedTarget = targets[0];
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
			
			self.firedRocketTargets[self.firedRocketTargets.size] = target;
			targetOrigin = selectedTarget.origin;
		}
		rocket = MagicBullet( level.strafeRunRocketWeapon, self GetTagOrigin( rocketTag ), targetOrigin, self );
		rocket.killCamEnt = self;
		
		wait level.strafeRunRocketDelay;
	}
}

stopStrafe()
{
	self notify( "strafe_stop" );
	
	self.strafing = undefined;
	
	self thread fireFlares();
	
	self.gunSoundEntity StopLoopSound();
	self.gunSoundEntity playsound ("wpn_a10_shot_decay_npc");
	self.numStrafes++;
}

shouldLeaveMap()
{
	if ( IsDefined( self.leaveNextTime ) && self.leaveNextTime )
	{
		return true;
	}
	
	if ( self.numStrafes >= level.strafeRunMaxStrafes )
	{
		return true;
	}
	
	return false;
}

leaveMap()
{
	exitOrigin = self.origin + VectorScale( AnglesToForward( self.angles ), level.strafeRunExitUnits );
	
	/*self ClearTargetYaw();
	self ClearGoalYaw();*/
	self SetYawSpeed( 5, 999, 999 );
	self SetVehGoalPos( exitOrigin, 1 );
	
	wait 3;
	
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
	
	if ( player HasPerk( "specialty_nottargetedbyai" ) )
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
	
	return canTargetEntity( actor );
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
		
		dogs = maps\mp\killstreaks\_dogs::dog_manager_get_dogs();
		
		foreach( dog in dogs )
		{
			if ( self canTargetActor( dog ) )
			{
				targets[targets.size] = dog;
			}
		}
	}
	
	return targets;
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