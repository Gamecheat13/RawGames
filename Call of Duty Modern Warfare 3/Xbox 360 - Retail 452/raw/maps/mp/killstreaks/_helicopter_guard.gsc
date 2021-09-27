#include maps\mp\_utility;
#include common_scripts\utility;

EMP_GRENADE_TIME = 3.5;

init()
{
	level.killStreakFuncs["littlebird_support"] = ::tryUseLBSupport;

	level.heliGuardSettings = [];

	level.heliGuardSettings[ "littlebird_support" ] = spawnStruct();
	level.heliGuardSettings[ "littlebird_support" ].timeOut =				60.0;	
	level.heliGuardSettings[ "littlebird_support" ].health =				999999; // keep it from dying anywhere in code	
	level.heliGuardSettings[ "littlebird_support" ].maxHealth =				2000; // this is what we check against for death	
	level.heliGuardSettings[ "littlebird_support" ].streakName =			"littlebird_support";
	level.heliGuardSettings[ "littlebird_support" ].vehicleInfo =			"attack_littlebird_mp";
	level.heliGuardSettings[ "littlebird_support" ].weaponInfo =			"littlebird_guard_minigun_mp";
	level.heliGuardSettings[ "littlebird_support" ].weaponModelLeft =		"vehicle_little_bird_minigun_left";
	level.heliGuardSettings[ "littlebird_support" ].weaponModelRight =		"vehicle_little_bird_minigun_right";
	level.heliGuardSettings[ "littlebird_support" ].weaponTagLeft =			"tag_minigun_attach_left";	
	level.heliGuardSettings[ "littlebird_support" ].weaponTagRight =		"tag_minigun_attach_right";	
	level.heliGuardSettings[ "littlebird_support" ].sentryMode =			"auto_nonai";	
	level.heliGuardSettings[ "littlebird_support" ].modelBase =				"vehicle_little_bird_armed";
	level.heliGuardSettings[ "littlebird_support" ].teamSplash =			"used_littlebird_support";	

	foreach ( heliInfo in level.heliGuardSettings )
	{
		PrecacheVehicle( heliInfo.vehicleInfo );
		PreCacheTurret( heliInfo.weaponInfo );
		PreCacheModel( heliInfo.weaponModelLeft );	
		PreCacheModel( heliInfo.weaponModelRight );	
		PreCacheModel( heliInfo.modelBase );	
	}

	lbSupport_setAirStartNodes();
	lbSupport_setAirNodeMesh();
	
/#
	SetDevDvarIfUninitialized( "scr_lbguard_timeout", 60.0 );
#/
}


tryUseLBSupport( lifeId ) // self == player
{
	heliGuardType = "littlebird_support";

	numIncomingVehicles = 1;
	if( isDefined( level.civilianJetFlyBy ) )
	{
		self iPrintLnBold( &"MP_CIVILIAN_AIR_TRAFFIC" );
		return false;
	}
	else if( self isUsingRemote() )
	{
		return false;
	}	
	else if( isDefined( level.littlebirdGuard ) || maps\mp\killstreaks\_helicopter::exceededMaxLittlebirds( heliGuardType ) )
	{
		self iPrintLnBold( &"MP_AIR_SPACE_TOO_CROWDED" );
		return false;	
	}
	else if ( !level.air_node_mesh.size )
	{
		self iPrintLnBold( &"MP_UNAVAILABLE_IN_LEVEL" );
		return false;		
	}
	else if( currentActiveVehicleCount() >= maxVehiclesAllowed() || level.fauxVehicleCount + numIncomingVehicles >= maxVehiclesAllowed() )
	{
		self iPrintLnBold( &"MP_TOO_MANY_VEHICLES" );
		return false;
	}		

	// increment the faux vehicle count before we spawn the vehicle so no other vehicles try to spawn
	incrementFauxVehicleCount();

	littleBird = createLBGuard( heliGuardType );
	if ( !isDefined( littleBird ) )
	{
		// decrement the faux vehicle count since this failed to spawn
		decrementFauxVehicleCount();

		return false;	
	}

	self thread startLBSupport( littleBird );
	
	level thread teamPlayerCardSplash( level.heliGuardSettings[ heliGuardType ].teamSplash, self, self.team );

	return true;
}


createLBGuard( heliGuardType )
{
	closestStartNode = lbSupport_getClosestStartNode( self.origin );	
	if( IsDefined( closestStartNode.angles ) )
		startAng = closestStartNode.angles;
	else
		startAng = ( 0, 0, 0);

	flyHeight = self maps\mp\killstreaks\_airdrop::getFlyHeightOffset( self.origin );	
	
	closestNode = lbSupport_getClosestNode( self.origin );
	
	// TU0: we want to make sure we don't clip through geo
	closestNode = lbSupport_TU0_New_Incoming_Position( closestNode );

	forward = anglesToForward( self.angles );
	targetPos = ( closestNode.origin*(1,1,0) ) + ( (0,0,1)*flyHeight ) + ( forward * -100 );
	
	startPos = closestStartNode.origin;
	
	lb = spawnHelicopter( self, startPos, startAng, level.heliGuardSettings[ heliGuardType ].vehicleInfo, level.heliGuardSettings[ heliGuardType ].modelBase );
	if ( !isDefined( lb ) )
		return;
		
	lb maps\mp\killstreaks\_helicopter::addToLittleBirdList();
	lb thread maps\mp\killstreaks\_helicopter::removeFromLittleBirdListOnDeath();

	lb.health = level.heliGuardSettings[ heliGuardType ].health;
	lb.maxHealth = level.heliGuardSettings[ heliGuardType ].maxHealth;
	lb.damageTaken = 0; // how much damage has it taken

	lb.speed = 100;
	lb.followSpeed = 40;
	lb.owner = self;
	lb.team = self.team;
	lb SetMaxPitchRoll( 45, 45 );	
	lb Vehicle_SetSpeed( lb.speed, 100, 40 );
	lb SetYawSpeed( 120, 60 );
	lb setneargoalnotifydist( 512 );
	lb.killCount = 0;
	lb.heliType = "littlebird";
	lb.heliGuardType = "littlebird_support";
	lb.targettingRadius = 2000; // matches the maxRange on the turret gdt setting
	//lb ThermalDrawEnable();

	lb.targetPos = targetPos;
	lb.currentNode = closestNode;
	
	mgTurret = SpawnTurret( "misc_turret", lb.origin, level.heliGuardSettings[ heliGuardType ].weaponInfo );
	mgTurret LinkTo( lb, level.heliGuardSettings[ heliGuardType ].weaponTagLeft, (0,0,0), (0,0,0) );
	mgTurret SetModel( level.heliGuardSettings[ heliGuardType ].weaponModelLeft );
	mgTurret.angles = lb.angles; 
	mgTurret.owner = lb.owner;
	mgTurret.team = self.team;
	mgTurret makeTurretInoperable();
	mgTurret.vehicle = lb;	
	//mgTurret ThermalDrawEnable();
	
	lb.mgTurretLeft = mgTurret; 
	lb.mgTurretLeft SetDefaultDropPitch( 0 );
	
	killCamOrigin = ( lb.origin + ( ( AnglesToForward( lb.angles ) * -100 ) + ( AnglesToRight( lb.angles ) * -100 )  ) ) + ( 0, 0, 50 );
	mgTurret.killCamEnt = Spawn( "script_model", killCamOrigin );
	mgTurret.killCamEnt SetScriptMoverKillCam( "explosive" );
	mgTurret.killCamEnt LinkTo( lb, "tag_origin" );
	
	mgTurret = SpawnTurret( "misc_turret", lb.origin, level.heliGuardSettings[ heliGuardType ].weaponInfo );
	mgTurret LinkTo( lb, level.heliGuardSettings[ heliGuardType ].weaponTagRight, (0,0,0), (0,0,0) );
	mgTurret SetModel( level.heliGuardSettings[ heliGuardType ].weaponModelRight );
	mgTurret.angles = lb.angles; 
	mgTurret.owner = lb.owner;
	mgTurret.team = self.team;
	mgTurret makeTurretInoperable();
	mgTurret.vehicle = lb;	
	lb.mgTurretRight = mgTurret; 
	lb.mgTurretRight SetDefaultDropPitch( 0 );

	killCamOrigin = ( lb.origin + ( ( AnglesToForward( lb.angles ) * -100 ) + ( AnglesToRight( lb.angles ) * 100 )  ) ) + ( 0, 0, 50 );
	mgTurret.killCamEnt = Spawn( "script_model", killCamOrigin );
	mgTurret.killCamEnt SetScriptMoverKillCam( "explosive" );
	mgTurret.killCamEnt LinkTo( lb, "tag_origin" );

	if ( level.teamBased )
	{
		lb.mgTurretLeft setTurretTeam( self.team );
		lb.mgTurretRight setTurretTeam( self.team );
	}

	lb.mgTurretLeft SetMode( level.heliGuardSettings[ heliGuardType ].sentryMode );
	lb.mgTurretRight SetMode( level.heliGuardSettings[ heliGuardType ].sentryMode );
 	
	lb.mgTurretLeft SetSentryOwner( self );
	lb.mgTurretRight SetSentryOwner( self );
	
	lb.mgTurretLeft thread lbSupport_attackTargets();
	lb.mgTurretRight thread lbSupport_attackTargets();
	
	lb.attract_strength = 10000;
	lb.attract_range = 150;
	lb.attractor = Missile_CreateAttractorEnt( lb, lb.attract_strength, lb.attract_range );

	lb.hasDodged = false;
	lb.empGrenaded = false;

	lb thread lbSupport_handleDamage();
	lb thread lbSupport_watchDeath();
	lb thread lbSupport_watchTimeout();
	lb thread lbSupport_watchOwnerLoss();
	lb thread lbSupport_watchOwnerDamage();
	lb thread lbSupport_watchRoundEnd();
	lb thread lbSupport_lightFX();

	level.littlebirdGuard = lb;

	lb.owner maps\mp\_matchdata::logKillstreakEvent( level.heliGuardSettings[ lb.heliGuardType ].streakName, lb.targetPos );	

	return lb;
}

lbSupport_lightFX()
{
	PlayFXOnTag( level.chopper_fx["light"]["left"], self, "tag_light_nose" );
	wait ( 0.05 );
	PlayFXOnTag( level.chopper_fx["light"]["belly"], self, "tag_light_belly" );
	wait ( 0.05 );
	PlayFXOnTag( level.chopper_fx["light"]["tail"], self, "tag_light_tail1" );
	wait ( 0.05 );
	PlayFXOnTag( level.chopper_fx["light"]["tail"], self, "tag_light_tail2" );
}


startLBSupport( littleBird ) // self == player
{			
	level endon( "game_ended" );
	littleBird endon( "death" );
	
	// look at the player
	littleBird SetLookAtEnt( self );
	
	//	go to pos
	littleBird setVehGoalPos( littleBird.targetPos );	
	littleBird waittill( "near_goal" );
	littleBird Vehicle_SetSpeed( littleBird.speed, 60, 30 );	
	littleBird waittill ( "goal" );	
	
	//	drop to target
	littleBird setVehGoalPos( littleBird.currentNode.origin, 1 );
	littleBird waittill ( "goal" );	
	
	//	begin following player	
	littleBird thread lbSupport_followPlayer();

	// dodge the first sam or lock-on attack
	littleBird thread maps\mp\killstreaks\_helicopter::handleIncomingSAM( ::lbSupport_watchSAMProximity );
	littleBird thread maps\mp\killstreaks\_helicopter::handleIncomingStinger( ::lbSupport_watchStingerProximity );
}


lbSupport_followPlayer() // self == lb
{
	level endon( "game_ended" );
	self endon( "death" );
	self endon( "leaving" );

	if( !IsDefined( self.owner ) )
	{
		self thread lbSupport_leave();
		return;
	}

	self.owner endon( "disconnect" );	
	self.owner endon( "joined_team" );
	self.owner endon( "joined_spectators" );
	
	self Vehicle_SetSpeed( self.followSpeed, 20, 20 );
	while( true )
	{
		if( IsDefined( self.owner ) && IsAlive( self.owner ) )
		{
			currentNode = lbSupport_getClosestLinkedNode( self.owner.origin );
			if( IsDefined( currentNode ) && currentNode != self.currentNode )
			{
				self.currentNode = currentNode;
				// don't thread because we want to waittill goal before we pick the next node
				lbSupport_moveToPlayer();
				continue;
			}
		}
		wait( 1 );
	}
}


lbSupport_moveToPlayer() // self == lb
{
	level endon( "game_ended" );
	self endon( "death" );
	self endon( "leaving" );
	self.owner endon( "death" );
	self.owner endon( "disconnect" );
	self.owner endon( "joined_team" );
	self.owner endon( "joined_spectators" );
	
	self notify( "lbSupport_moveToPlayer" );
	self endon( "lbSupport_moveToPlayer" );
	
	self.inTransit = true;
	self setVehGoalPos( self.currentNode.origin, 1 );
	self waittill ( "goal" );
	self.inTransit = false;
	self notify( "hit_goal" );		
}


//
//	state trackers
//


lbSupport_watchDeath()
{
	level endon( "game_ended" );
	self endon( "gone" );
	
	self waittill( "death" );
	
	self thread heliDestroyed();
}


lbSupport_watchTimeout()
{
	level endon ( "game_ended" );
	self endon( "death" );
	self.owner endon( "disconnect" );
	self.owner endon( "joined_team" );
	self.owner endon( "joined_spectators" );
		
	timeout = level.heliGuardSettings[ self.heliGuardType ].timeOut;
/#
	timeout = GetDvarFloat( "scr_lbguard_timeout" );
#/
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( timeout );
	
	self thread lbSupport_leave();
}


lbSupport_watchOwnerLoss()
{
	level endon ( "game_ended" );
	self endon( "death" );
	self endon( "leaving" );

	self.owner waittill_any( "disconnect", "joined_team", "joined_spectators" );	
		
	//	leave
	self thread lbSupport_leave();
}

lbSupport_watchOwnerDamage() // self == lb
{
	level endon ( "game_ended" );
	self endon( "death" );
	self endon( "leaving" );	
	self.owner endon( "disconnect" );
	self.owner endon( "joined_team" );
	self.owner endon( "joined_spectators" );

	while( true )
	{
		// if someone is attacking the owner, attack them
		self.owner waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath, modelName, tagName, partName, iDFlags, weapon );

		if( isPlayer( attacker ) )
		{					
			if( attacker != self.owner && 
				Distance2D( attacker.origin, self.origin ) <= self.targettingRadius && 
				!attacker _hasPerk( "specialty_blindeye" ) &&
				!( level.hardcoreMode && level.teamBased && attacker.team == self.team ) )
			{
				self SetLookAtEnt( attacker );
				self.mgTurretLeft SetTargetEntity( attacker );
				self.mgTurretRight SetTargetEntity( attacker );
			}
		}
	}		
}

lbSupport_watchRoundEnd()
{
	level endon ( "game_ended" );
	self endon( "death" );
	self endon( "leaving" );	
	self.owner endon( "disconnect" );
	self.owner endon( "joined_team" );
	self.owner endon( "joined_spectators" );	

	level waittill ( "round_end_finished" );

	//	leave
	self thread lbSupport_leave();
}

lbSupport_leave()
{
	self endon( "death" );
	self notify( "leaving" );
	level.littlebirdGuard = undefined;

	self ClearLookAtEnt();

	//	rise
	flyHeight = self maps\mp\killstreaks\_airdrop::getFlyHeightOffset( self.origin );	
	targetPos = self.origin + (0,0,flyHeight);
	self Vehicle_SetSpeed( self.speed, 60 );
	self SetMaxPitchRoll( 45, 180 );
	self setVehGoalPos( targetPos );
	self waittill ( "goal" );	
	
	//	leave
	targetPos = targetPos + anglesToForward( self.angles ) * 15000;
	// make sure it doesn't fly away backwards
	endEnt = Spawn( "script_origin", targetPos );
	if( IsDefined( endEnt ) )
	{
		self SetLookAtEnt( endEnt );
		endEnt thread wait_and_delete( 3.0 );
	}
	self setVehGoalPos( targetPos );
	self waittill ( "goal" );
	
	//	remove
	self notify( "gone" );	
	self removeLittlebird();
}

wait_and_delete( waitTime )
{
	self endon( "death" );
	level endon( "game_ended" );
	wait( waitTime );
	self delete();
}

//
//	Damage, death, and destruction
//

lbSupport_handleDamage() // self == lb
{
	self endon( "death" );
	level endon( "game_ended" );
	
	self SetCanDamage( true );

	while( true )
	{
		self waittill( "damage", damage, attacker, direction_vec, point, meansOfDeath, modelName, tagName, partName, iDFlags, weapon );

		// don't allow people to destroy things on their team if FF is off
		if ( !maps\mp\gametypes\_weapons::friendlyFireCheck( self.owner, attacker ) )
			continue;

		if ( !IsDefined( self ) )
			return;

		if ( isDefined( iDFlags ) && ( iDFlags & level.iDFLAGS_PENETRATION ) )
			self.wasDamagedFromBulletPenetration = true;

		self.wasDamaged = true;

		modifiedDamage = damage;
		
		if( IsPlayer( attacker ) )
		{					
			// attack the attacker
			if( attacker != self.owner && 
				Distance2D( attacker.origin, self.origin ) <= self.targettingRadius && 
				!attacker _hasPerk( "specialty_blindeye" ) &&
				!( level.hardcoreMode && level.teamBased && attacker.team == self.team ) )
			{
				self SetLookAtEnt( attacker );
				self.mgTurretLeft SetTargetEntity( attacker );
				self.mgTurretRight SetTargetEntity( attacker );
			}

			attacker maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "helicopter" );

			if( meansOfDeath == "MOD_RIFLE_BULLET" || meansOfDeath == "MOD_PISTOL_BULLET" )
			{
				if ( attacker _hasPerk( "specialty_armorpiercing" ) )
					modifiedDamage += damage * level.armorPiercingMod;
			}
		}
		
		// in case we are shooting from a remote position, like being in the osprey gunner shooting this
		if( IsDefined( attacker.owner ) && IsPlayer( attacker.owner ) )
		{
			attacker.owner maps\mp\gametypes\_damagefeedback::updateDamageFeedback( "helicopter" );
		}

		if( IsDefined( weapon ) )
		{
			switch( weapon )
			{
			case "ac130_105mm_mp":
			case "ac130_40mm_mp":
			case "stinger_mp":
			case "javelin_mp":
			case "remote_mortar_missile_mp":		
			case "remotemissile_projectile_mp":
				self.largeProjectileDamage = true;
				modifiedDamage = self.maxHealth + 1;
				break;

			case "sam_projectile_mp":
				self.largeProjectileDamage = true;		
				modifiedDamage = self.maxHealth * 0.25; // takes about 1 burst of sam rockets
				break;

			case "emp_grenade_mp":
				// NOTE: don't destroy helicopters with an emp grenade, it didn't look good in practice
				modifiedDamage = 0;
				self thread lbSupport_EMPGrenaded();
				break;

			case "osprey_player_minigun_mp":
				self.largeProjectileDamage = false;
				modifiedDamage *= 2; // since it's a larger caliber, make it hurt
				break;
			}
		}

		self.damageTaken += modifiedDamage;		
		
		if ( self.damageTaken >= self.maxHealth )
		{
			if ( isPlayer( attacker ) && ( !isDefined( self.owner ) || attacker != self.owner ) )
			{
				attacker notify( "destroyed_helicopter" );
				attacker notify( "destroyed_killstreak", weapon );
				thread teamPlayerCardSplash( "callout_destroyed_little_bird", attacker );			
				attacker thread maps\mp\gametypes\_rank::giveRankXP( "kill", 300, weapon, meansOfDeath );			
				attacker thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_DESTROYED_LITTLE_BIRD" );
				thread maps\mp\gametypes\_missions::vehicleKilled( self.owner, self, undefined, attacker, damage, meansOfDeath, weapon );		
			}

			if( IsDefined( self.owner ) )
				self.owner thread leaderDialogOnPlayer( "lbguard_destroyed" );

			self notify ( "death" );
			return;
		}
	}
}

lbSupport_EMPGrenaded() // self == vehicle
{
	self notify( "lbSupport_EMPGrenaded" );
	self endon( "lbSupport_EMPGrenaded" );

	self endon( "death" );
	self.owner endon( "disconnect" );
	level endon( "game_ended" );

	self.empGrenaded = true;
	self.mgTurretRight notify( "stop_shooting" );
	self.mgTurretLeft notify( "stop_shooting" );
	// TU0: using the ims fx and not creating its own because we've already locked down ConfigStrings and it will shift them if we load fx in this file
	if( IsDefined( level._effect[ "ims_sensor_explode" ] ) )
	{
		PlayFXOnTag( getfx( "ims_sensor_explode" ), self.mgTurretRight, "tag_aim" );
		PlayFXOnTag( getfx( "ims_sensor_explode" ), self.mgTurretLeft, "tag_aim" );
	}

	wait( EMP_GRENADE_TIME );

	self.empGrenaded = false;
	self.mgTurretRight notify( "turretstatechange" );
	self.mgTurretLeft notify( "turretstatechange" );
}

heliDestroyed()
{
	level.littlebirdGuard = undefined;
	
	if (! isDefined(self) )
		return;
		
	self Vehicle_SetSpeed( 25, 5 );
	self thread lbSpin( RandomIntRange(180, 220) );
	
	wait( RandomFloatRange( .5, 1.5 ) );
	
	lbExplode();
}

lbExplode()
{
	forward = ( self.origin + ( 0, 0, 1 ) ) - self.origin;

	deathAngles = self getTagAngles( "tag_deathfx" );
	playFx( level.chopper_fx["explode"]["air_death"]["littlebird"], self getTagOrigin( "tag_deathfx" ), anglesToForward( deathAngles ), anglesToUp( deathAngles ) );
	
	self playSound( "cobra_helicopter_crash" );
	self notify ( "explode" );
	
	self removeLittlebird();
}

lbSpin( speed )
{
	self endon( "explode" );
	
	// tail explosion that caused the spinning
	playfxontag( level.chopper_fx["explode"]["medium"], self, "tail_rotor_jnt" );
 	self thread trail_fx( level.chopper_fx["smoke"]["trail"], "tail_rotor_jnt", "stop tail smoke" );
	
	self setyawspeed( speed, speed, speed );
	while ( isdefined( self ) )
	{
		self settargetyaw( self.angles[1]+(speed*0.9) );
		wait ( 1 );
	}
}

trail_fx( trail_fx, trail_tag, stop_notify )
{
	// only one instance allowed
	self notify( stop_notify );
	self endon( stop_notify );
	self endon( "death" );
		
	for ( ;; )
	{
		playfxontag( trail_fx, self, trail_tag );
		wait( 0.05 );
	}
}

removeLittlebird()
{	
	level.lbStrike = 0;
	
	if( IsDefined( self.mgTurretLeft ) )
	{
		if( IsDefined( self.mgTurretLeft.killCamEnt ) )
			self.mgTurretLeft.killCamEnt delete();
		self.mgTurretLeft delete();
	}	
	if( IsDefined( self.mgTurretRight ) )
	{
		if( IsDefined( self.mgTurretRight.killCamEnt ) )
			self.mgTurretRight.killCamEnt delete();
		self.mgTurretRight delete();
	}	

	if( IsDefined( self.marker ) )
		self.marker delete();

	// decrement the faux vehicle count right before it is deleted this way we know for sure it is gone
	decrementFauxVehicleCount();

	self delete();	
}

// this is different from the flares monitoring that the other helicopters do
// we want this to dodge the missiles if at all possible, making for a cool evasive manuever
lbSupport_watchSAMProximity( player, missileTeam, missileTarget, missileGroup ) // self == level
{
	level endon ( "game_ended" );
	missileTarget endon( "death" );

	for( i = 0; i < missileGroup.size; i++ )
	{
		if( IsDefined( missileGroup[ i ] ) && !missileTarget.hasDodged )
		{
			missileTarget.hasDodged = true;			

			newTarget = spawn( "script_origin", missileTarget.origin );
			newTarget.angles = missileTarget.angles;
			newTarget MoveGravity( AnglesToRight( missileGroup[ i ].angles ) * -1000, 0.05 );
			newTarget thread maps\mp\killstreaks\_helicopter::deleteAfterTime( 5.0 );

			for( j = 0; j < missileGroup.size; j++ )					
			{
				if( IsDefined( missileGroup[ j ] ) )
				{
					missileGroup[ j ] Missile_SetTargetEnt( newTarget );
				}
			}

			// dodge the incoming missiles
			dodgePoint = missileTarget.origin + ( AnglesToRight( missileGroup[ i ].angles ) * 200 );
			missileTarget Vehicle_SetSpeed( missileTarget.speed, 100, 40 );
			missileTarget SetVehGoalPos( dodgePoint, true );

			wait( 2.0 );
			missileTarget Vehicle_SetSpeed( missileTarget.followSpeed, 20, 20 );
			break;
		}	
	}
}

// this is different from the flares monitoring that the other helicopters do
// we want this to dodge the missiles if at all possible, making for a cool evasive manuever
lbSupport_watchStingerProximity( player, missileTeam, missileTarget ) // self == missile
{
	level endon ( "game_ended" );
	missileTarget endon( "death" );

	if( IsDefined( self ) && !missileTarget.hasDodged )
	{
		missileTarget.hasDodged = true;			

		newTarget = spawn( "script_origin", missileTarget.origin );
		newTarget.angles = missileTarget.angles;
		newTarget MoveGravity( AnglesToRight( self.angles ) * -1000, 0.05 );
		newTarget thread maps\mp\killstreaks\_helicopter::deleteAfterTime( 5.0 );

		self Missile_SetTargetEnt( newTarget );

		// dodge the incoming missiles
		dodgePoint = missileTarget.origin + ( AnglesToRight( self.angles ) * 200 );
		missileTarget Vehicle_SetSpeed( missileTarget.speed, 100, 40 );
		missileTarget SetVehGoalPos( dodgePoint, true );

		wait( 2.0 );
		missileTarget Vehicle_SetSpeed( missileTarget.followSpeed, 20, 20 );
	}	
}

//
//	node funcs
//

lbSupport_getClosestStartNode( pos )
{
	// gets the start node that is closest to the position passed in
	closestNode = undefined;
	closestDistance = 999999;

	foreach( loc in level.air_start_nodes )
	{ 	
		nodeDistance = distance( loc.origin, pos );
		if ( nodeDistance < closestDistance )
		{
			closestNode = loc;
			closestDistance = nodeDistance;
		}
	}

	return closestNode;
}

lbSupport_getClosestNode( pos )
{
	// gets the closest node to the position passed in, regardless of link
	closestNode = undefined;
	closestDistance = 999999;
	
	foreach( loc in level.air_node_mesh )
	{ 	
		nodeDistance = distance( loc.origin, pos );
		if ( nodeDistance < closestDistance )
		{
			closestNode = loc;
			closestDistance = nodeDistance;
		}
	}
	
	return closestNode;
}

lbSupport_getClosestLinkedNode( pos ) // self == lb
{
	// gets the linked node that is closest to the current position and moving towards the position passed in
	closestNode = undefined;
	totalDistance = Distance2D( self.currentNode.origin, pos );
	closestDistance = totalDistance;

	// loop through each neighbor and find the closest to the final goal
	foreach( loc in self.currentNode.neighbors )
	{ 	
		nodeDistance = Distance2D( loc.origin, pos );
		if ( nodeDistance < totalDistance && nodeDistance < closestDistance )
		{
			closestNode = loc;
			closestDistance = nodeDistance;
		}
	}

	return closestNode;
}

lbSupport_arrayContains( array, compare )
{
	if ( array.size <= 0 )
		return false;

	foreach ( member in array )
	{
		if ( member == compare )
			return true;
	}

	return false;
}


lbSupport_getLinkedStructs()
{
	array = [];

	if ( IsDefined( self.script_linkTo ) )
	{
		linknames = get_links();
		for ( i = 0; i < linknames.size; i++ )
		{
			ent = getstruct( linknames[ i ], "script_linkname" );
			if ( IsDefined( ent ) )
			{
				array[ array.size ] = ent;
			}
		}
	}

	return array;
}

lbSupport_setAirStartNodes()
{
	level.air_start_nodes = getstructarray( "chopper_boss_path_start", "targetname" );

	foreach( loc in level.air_start_nodes )
	{
		// Grab array of path loc refs that this loc links to
		loc.neighbors = loc lbSupport_getLinkedStructs();
	}	
}

lbSupport_setAirNodeMesh()
{
	level.air_node_mesh = getstructarray( "so_chopper_boss_path_struct", "script_noteworthy" );
	
	// TU0 Patch
	lbSupport_TU0_Raise_Positions();

	foreach( loc in level.air_node_mesh )
	{
		// Grab array of path loc refs that this loc links to
		loc.neighbors = loc lbSupport_getLinkedStructs();
		
		// Step through each loc in the map and if it
		// links to this loc, add it
		foreach( other_loc in level.air_node_mesh )
		{
			if ( loc == other_loc )
				continue;
			
			if ( !lbSupport_arrayContains( loc.neighbors, other_loc ) && lbSupport_arrayContains( other_loc lbSupport_getLinkedStructs(), loc ) )
				loc.neighbors[ loc.neighbors.size ] = other_loc;
		}
	}	
}

lbSupport_TU0_Raise_Positions()
{
	// TU0: special cases where we want to raise certain struct positions because they clip through geo
	switch( GetDvar( "mapname" ) )
	{
	case "mp_lambeth":
		// move these up 192 units
		positions_192 = [];
		positions_192[ positions_192.size ] = ( -291.1, 1587.3, 184 );
		positions_192[ positions_192.size ] = ( -947.1, 1859.3, 376 );
		positions_192[ positions_192.size ] = ( -1155.1, 1187.3, 344 );
		positions_192[ positions_192.size ] = ( -467.1, -316.7, 184 );
		positions_192[ positions_192.size ] = ( 956.9, 2931.3, 216 );
		positions_192[ positions_192.size ] = ( 2748.9, 963.3, 328 );
		positions_192[ positions_192.size ] = ( 2732.9, 83.3, 376 );
		
		// move these up 300 units
		positions_300 = [];
		positions_300[ positions_300.size ] = ( -1027.1, -1180.7, 312 );

		for( i = 0; i < level.air_node_mesh.size; i++ )
		{
			foreach( pos in positions_192 )
			{
				if( int( level.air_node_mesh[i].origin[0] ) == int( pos[0] ) && int( level.air_node_mesh[i].origin[1] ) == int( pos[1] ) && int( level.air_node_mesh[i].origin[2] ) == int( pos[2] ) )
				{
					level.air_node_mesh[i].origin += ( 0, 0, 192 );
					break;
				}
			}

			foreach( pos in positions_300 )
			{
				if( int( level.air_node_mesh[i].origin[0] ) == int( pos[0] ) && int( level.air_node_mesh[i].origin[1] ) == int( pos[1] ) && int( level.air_node_mesh[i].origin[2] ) == int( pos[2] ) )
				{
					level.air_node_mesh[i].origin += ( 0, 0, 300 );
					break;
				}
			}
		}
		break;
	
	case "mp_village":
		// move these up 180 units
		positions_200 = [];
		positions_200[ positions_200.size ] = ( 684.9, 2227.3, 680 );
		positions_200[ positions_200.size ] = ( 60.9, 1363.3, 728 );
		positions_200[ positions_200.size ] = ( 972.9, 163.3, 744 );
		positions_200[ positions_200.size ] = ( 1756.9, -444.7, 744 );
		positions_200[ positions_200.size ] = ( 412.9, 67.3, 680 );

		// move these up 250 units
		positions_250 = [];
		positions_250[ positions_250.size ] = ( 352, 800, 736 );
		positions_250[ positions_250.size ] = ( 1600, 352, 752 );

		// move these up 400 units
		positions_400 = [];
		positions_400[ positions_400.size ] = ( 1100.9, 1155.3, 632 );

		// completely change these positions
		positions_change1 = ( -1155.1, -1260.7, 1096 );

		for( i = 0; i < level.air_node_mesh.size; i++ )
		{
			foreach( pos in positions_200 )
			{
				if( int( level.air_node_mesh[i].origin[0] ) == int( pos[0] ) && int( level.air_node_mesh[i].origin[1] ) == int( pos[1] ) && int( level.air_node_mesh[i].origin[2] ) == int( pos[2] ) )
				{
					level.air_node_mesh[i].origin += ( 0, 0, 200 );
					break;
				}
			}

			foreach( pos in positions_250 )
			{
				if( int( level.air_node_mesh[i].origin[0] ) == int( pos[0] ) && int( level.air_node_mesh[i].origin[1] ) == int( pos[1] ) && int( level.air_node_mesh[i].origin[2] ) == int( pos[2] ) )
				{
					level.air_node_mesh[i].origin += ( 0, 0, 250 );
					break;
				}
			}

			foreach( pos in positions_400 )
			{
				if( int( level.air_node_mesh[i].origin[0] ) == int( pos[0] ) && int( level.air_node_mesh[i].origin[1] ) == int( pos[1] ) && int( level.air_node_mesh[i].origin[2] ) == int( pos[2] ) )
				{
					level.air_node_mesh[i].origin += ( 0, 0, 400 );
					break;
				}
			}

			if( int( level.air_node_mesh[i].origin[0] ) == int( positions_change1[0] ) && int( level.air_node_mesh[i].origin[1] ) == int( positions_change1[1] ) && int( level.air_node_mesh[i].origin[2] ) == int( positions_change1[2] ) )
			{
				level.air_node_mesh[i].origin = ( -1003, -1035, 986 );
				continue;
			}
		}
		break;

	case "mp_interchange":
		// move these up 100 units
		positions_100 = [];
		positions_100[ positions_100.size ] = ( -755.1, -1788.7, 360 );

		for( i = 0; i < level.air_node_mesh.size; i++ )
		{
			foreach( pos in positions_100 )
			{
				if( int( level.air_node_mesh[i].origin[0] ) == int( pos[0] ) && int( level.air_node_mesh[i].origin[1] ) == int( pos[1] ) && int( level.air_node_mesh[i].origin[2] ) == int( pos[2] ) )
				{
					level.air_node_mesh[i].origin += ( 0, 0, 100 );
					break;
				}
			}
		}
		break;

	default:
		break;
	}
}

lbSupport_TU0_New_Incoming_Position( node )
{
	// TU0: special cases where we want to go to another position when we start at the player's position because the position could be under geo
	switch( GetDvar( "mapname" ) )
	{
	case "mp_interchange":
		good_positions = [];
		bad_positions = [];

		good_positions[ bad_positions.size ][0] = ( 1340.9, 1299.3, 360 );
		good_positions[ bad_positions.size ][1] = ( 2220.9, 115.3, 408 );
		bad_positions[ bad_positions.size ] = ( 1884.9, 787.3, 312 );

		good_positions[ bad_positions.size ][0] = ( -755.1, -588.7, 728 );
		good_positions[ bad_positions.size ][1] = ( -2563.1, -1580.7, 1192 );
		bad_positions[ bad_positions.size ] = ( -1363.1, -1164.7, 472 );

		good_positions[ bad_positions.size ][0] = ( -35.1, -2492.7, 488 );
		good_positions[ bad_positions.size ][1] = ( 396.9, -1884.7, 696 );
		bad_positions[ bad_positions.size ] = ( -755.1, -1788.7, 360+100 ); // this one got bumped up 100 units in lbSupport_TU0_Raise_Positions()

		new_pos_index = ( RandomIntRange( 0, 100 ) > 50 );
		for( i = 0; i < bad_positions.size; i++ )
		{
			if( int( node.origin[0] ) == int( bad_positions[i][0] ) && int( node.origin[1] ) == int( bad_positions[i][1] ) && int( node.origin[2] ) == int( bad_positions[i][2] ) )
			{
				for( j = 0; j < level.air_node_mesh.size; j++ )
				{
					if( int( level.air_node_mesh[j].origin[0] ) == int( good_positions[i][ new_pos_index ][0] ) && int( level.air_node_mesh[j].origin[1] ) == int( good_positions[i][ new_pos_index ][1] ) && int( level.air_node_mesh[j].origin[2] ) == int( good_positions[i][ new_pos_index ][2] ) )
						return level.air_node_mesh[j];
				}
			}
		}
		break;

	default:
		break;
	}

	// if we've made it here then just send the same node back
	return node;
}

/* ============================
Turret Logic Functions
============================ */

lbSupport_attackTargets() // self == turret
{
	self.vehicle endon( "death" );
	level endon( "game_ended" );

	for ( ;; )
	{
		self waittill( "turretstatechange" );

		if ( self IsFiringTurret() && !self.vehicle.empGrenaded )
			self thread lbSupport_burstFireStart();
		else
			self thread lbSupport_burstFireStop();
	}
}

lbSupport_burstFireStart() // self == turret
{
	self.vehicle endon( "death" );
	self.vehicle endon( "leaving" );
	self endon( "stop_shooting" );
	level endon( "game_ended" );

	fireTime = 0.1;
	minShots = 40;
	maxShots = 80;
	minPause = 1.0;
	maxPause = 2.0;

	for ( ;; )
	{		
		numShots = RandomIntRange( minShots, maxShots + 1 );

		for ( i = 0; i < numShots; i++ )
		{
			targetEnt = self GetTurretTarget( false );
			if( IsDefined( targetEnt ) && 
				( !IsDefined( targetEnt.spawntime ) || ( gettime() - targetEnt.spawntime )/1000 > 5 ) && 
				( IsDefined( targetEnt.team ) && targetEnt.team != "spectator" ) &&
				isReallyAlive( targetEnt ) )
			{
				self.vehicle SetLookAtEnt( targetEnt );
				self ShootTurret();
			}

			wait ( fireTime );
		}

		wait ( RandomFloatRange( minPause, maxPause ) );
	}
}

lbSupport_burstFireStop() // self == turret
{
	self notify( "stop_shooting" );
	if( IsDefined( self.vehicle.owner ) )
		self.vehicle SetLookAtEnt( self.vehicle.owner );
}

/* ============================
END Turret Logic Functions
============================ */
