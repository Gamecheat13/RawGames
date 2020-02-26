#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_killstreaks;
#include maps\mp\killstreaks\_airsupport;

init()
{
	precacheString( &"MP_CIVILIAN_AIR_TRAFFIC" );
	precacheString( &"MP_AIR_SPACE_TOO_CROWDED" );
	precacheVehicle( "heli_guard_mp" );
	precacheModel( "veh_iw_mh6_littlebird_mp" );
	
	precacheTurret( "littlebird_guard_minigun_mp" );
	precacheModel( "veh_iw_littlebird_minigun_left" );
	precacheModel( "veh_iw_littlebird_minigun_right" );

	//precacheHelicopter( "veh_iw_mh6_littlebird" );

	registerKillstreak("helicopter_guard_mp", "helicopter_guard_mp", "killstreak_helicopter_guard", "helicopter_used", ::tryUseheliGuardSupport, true);
	registerKillstreakAltWeapon( "helicopter_guard_mp", "littlebird_guard_minigun_mp" );
	registerKillstreakStrings("helicopter_guard_mp", &"KILLSTREAK_EARNED_HELICOPTER_GUARD", &"KILLSTREAK_HELICOPTER_GUARD_NOT_AVAILABLE", &"KILLSTREAK_HELICOPTER_GUARD_INBOUND");
	registerKillstreakDialog("helicopter_guard_mp", "mpl_killstreak_lbguard_strt", "kls_littlebird_used", "","kls_littlebird_enemy", "", "kls_littlebird_ready");
	registerKillstreakDevDvar("helicopter_guard_mp", "scr_givehelicopterguard");
	
/#
	set_dvar_float_if_unset( "scr_lbguard_timeout", 60.0 );
#/
}

#define PLAYER_HEIGHT_INCREASE  (0,0,50)
#define HELI_GUARD_FIRE_TIME 	0.2
#define HELI_GUARD_MIN_SHOTS 	40
#define HELI_GUARD_MAX_SHOTS 	80
#define HELI_GUARD_MIN_PAUSE 	1.0
#define HELI_GUARD_MAX_PAUSE 	2.0
#define HELI_GUARD_GUNNER	 	0

tryUseheliGuardSupport( lifeId ) // self == player
{
	if ( isDefined( level.civilianJetFlyBy ) )
	{
		self iPrintLnBold( &"MP_CIVILIAN_AIR_TRAFFIC" );
		return false;
	}

	if ( self IsRemoteControlling() )
	{
		return false;
	}	

	if ( !isDefined( level.heli_paths ) || level.heli_paths.size <= 0 )
	{
		self iPrintLnBold( &"MP_UNAVAILABLE_IN_LEVEL" );
		return false;		
	}

	if ( !self maps\mp\killstreaks\_killstreakrules::killstreakStart( "helicopter_guard_mp", self.team, false, true ) )
	{
		return false;
	}
	
	heliGuard = createHeliGuardSupport( lifeId );
	if ( !isDefined( heliGuard ) )
		return false;	

	self thread startHeliGuardSupport( heliGuard, lifeId );
	
	//level thread teamPlayerCardSplash( "used_littlebird_support", self, self.team );

	return true;
}


createHeliGuardSupport( lifeId )
{
	hardpointType = "helicopter_guard_mp";
	closestStartNode = heliGuardSupport_getClosestStartNode( self.origin );	
	if( IsDefined( closestStartNode.angles ) )
		startAng = closestStartNode.angles;
	else
		startAng = ( 0, 0, 0);

	closestNode = heliGuardSupport_getClosestNode( self.origin );	
	flyHeight = max( self.origin[2] + 1600, getNoFlyZoneHeight( self.origin ) );
	forward = anglesToForward( self.angles );
	targetPos = ( self.origin*(1,1,0) ) + ( (0,0,1)*flyHeight ) + ( forward * -100 );
	
	startPos = closestStartNode.origin;
	
	heliGuard = spawnHelicopter( self, startPos, startAng, "heli_guard_mp" , "veh_iw_mh6_littlebird_mp" );
	if ( !isDefined( heliGuard ) )
		return;

	Target_Set( heliGuard, (0,0,0) );
		
	//heliGuard maps\mp\killstreaks\_helicopter::addToLittleBirdList();
	//heliGuard thread maps\mp\killstreaks\_helicopter::removeFromLittleBirdListOnDeath();

	heliGuard.speed = 100;
	heliGuard.followSpeed = 40;
	heliGuard setCanDamage( true );
	heliGuard.owner = self;
	heliGuard.team = self.team;
	heliGuard SetMaxPitchRoll( 45, 45 );	
	heliGuard SetSpeed( heliGuard.speed, 100, 40 );
	heliGuard SetYawSpeed( 120, 60 );
	heliGuard setneargoalnotifydist( 512 );
	
	heliGuard thread heliGuardSupport_attackTargets();
	
	heliGuard.killCount = 0;
	heliGuard.streakName = "littlebird_support";
	heliGuard.heliType = "littlebird";
	heliGuard.targettingRadius = 2000; // matches the maxRange on the turret gdt setting

	heliGuard.targetPos = targetPos;
	heliGuard.currentNode = closestNode;

	heliGuard.attract_strength = 10000;
	heliGuard.attract_range = 150;
	heliGuard.attractor = Missile_CreateAttractorEnt( heliGuard, heliGuard.attract_strength, heliGuard.attract_range );
	heliGuard.health = 999999; // keep it from dying anywhere in code
	heliGuard.maxHealth = 2000; // this is the health we'll check
	heliGuard.rocketDamageOneShot = heliGuard.maxhealth + 1;
	heliGuard.crashType = "explode";// just explode
	heliGuard.destroyFunc = ::lbExplode;
	heliGuard.targeting_delay = level.heli_targeting_delay;
	heliGuard.hasDodged = false;
	

	heliGuard thread maps\mp\killstreaks\_helicopter::heli_targeting( false, hardpointType );
	heliGuard thread maps\mp\killstreaks\_helicopter::heli_damage_monitor( hardpointType );
	heliGuard thread maps\mp\killstreaks\_helicopter::heli_kill_monitor( hardpointType );
	heliGuard thread maps\mp\killstreaks\_helicopter::heli_health(hardpointtype, self, "heli_timeup");	

	heliGuard thread heliGuardSupport_watchTimeout();
	heliGuard thread heliGuardSupport_watchOwnerLoss();
	heliGuard thread heliGuardSupport_watchOwnerDamage();
	heliGuard thread heliGuardSupport_watchRoundEnd();

	level.littlebirdGuard = heliGuard;

	return heliGuard;
}


startHeliGuardSupport( littleBird, lifeId ) // self == player
{			
	level endon( "game_ended" );
	littleBird endon( "death" );
	
	// look at the player
	littleBird SetLookAtEnt( self );
	
	//	go to pos
	littleBird setVehGoalPos( littleBird.targetPos, 1 );
	Target_SetTurretAquire( littleBird, false );

	littleBird waittill( "near_goal" );
	Target_SetTurretAquire( littleBird, true );
	littleBird SetSpeed( littleBird.speed, 60, 30 );	
	littleBird waittill ( "goal" );	
		
	//	begin following player	
	littleBird thread heliGuardSupport_followPlayer();

	// dodge the first sam attack
	//littleBird thread maps\mp\killstreaks\_helicopter::handleIncomingSAM( ::heliGuardSupport_watchSAMProximity );
}


heliGuardSupport_followPlayer() // self == heliGuard
{
	level endon( "game_ended" );
	self endon( "death" );
	self endon( "leaving" );

	if( !IsDefined( self.owner ) )
	{
		self thread heliGuardSupport_leave();
		return;
	}

	self.owner endon( "disconnect" );	
	self.owner endon( "joined_team" );
	self.owner endon( "joined_spectators" );
	
	self SetSpeed( self.followSpeed, 20, 20 );
	while( true )
	{
		if( IsDefined( self.owner ) && IsAlive( self.owner ) )
		{
			heliGuardSupport_moveToPlayer();
		}
		wait( 3 );
	}
}


heliGuardSupport_moveToPlayer() // self == heliGuard
{
	level endon( "game_ended" );
	self endon( "death" );
	self endon( "leaving" );
	self.owner endon( "death" );
	self.owner endon( "disconnect" );
	self.owner endon( "joined_team" );
	self.owner endon( "joined_spectators" );
	
	self notify( "heliGuardSupport_moveToPlayer" );
	self endon( "heliGuardSupport_moveToPlayer" );

	maxMeshHeight = self GetHeliHeightLockHeight( self.owner.origin );
	maxMeshHeight = max( maxMeshHeight, self.owner.origin[2] ); 
	height = getNoFlyZoneHeightCrossed( self.origin, self.owner.origin,  maxMeshHeight );
	upperHeight = max( self.origin[2], height );
	
	
	acquireUpperHeight = ( self.origin[0], self.origin[1], upperHeight );
	hoverOverPlayer = ( self.owner.origin[0], self.owner.origin[1], upperHeight );
	hoverCorrectHeight = ( self.owner.origin[0], self.owner.origin[1], height );
	
	
	self.inTransit = true;
	self setVehGoalPos( acquireUpperHeight, true ); 
	self waittill ( "goal" );
	
	self setVehGoalPos( hoverOverPlayer, true ); 
	self waittill ( "goal" );

	self setVehGoalPos( hoverCorrectHeight, true ); 
	self waittill ( "goal" );
	
	self.inTransit = false;
	self notify( "hit_goal" );		
}


//
//	state trackers
//



heliGuardSupport_watchTimeout()
{
	level endon ( "game_ended" );
	self endon( "death" );
	self.owner endon( "disconnect" );
	self.owner endon( "joined_team" );
	self.owner endon( "joined_spectators" );
		
	timeout = 60.0;
/#
	timeout = GetDvarFloat( "scr_lbguard_timeout" );
#/
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( timeout );
	
	self thread heliGuardSupport_leave();
}


heliGuardSupport_watchOwnerLoss()
{
	level endon ( "game_ended" );
	self endon( "death" );
	self endon( "leaving" );

	self.owner waittill_any( "disconnect", "joined_team", "joined_spectators" );	
		
	//	leave
	self thread heliGuardSupport_leave();
}

heliGuardSupport_watchOwnerDamage() // self == heliGuard
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
			if( attacker != self.owner && Distance2D( attacker.origin, self.origin ) <= self.targettingRadius && !attacker HasPerk( "specialty_nottargetedbyai" ) )
			{
				self SetLookAtEnt( attacker );
				self setGunnerTargetEnt( attacker, PLAYER_HEIGHT_INCREASE, HELI_GUARD_GUNNER );
				self setturrettargetent( attacker, PLAYER_HEIGHT_INCREASE );
			}
		}
	}		
}

heliGuardSupport_watchRoundEnd()
{
	level endon ( "game_ended" );
	self endon( "death" );
	self endon( "leaving" );	
	self.owner endon( "disconnect" );
	self.owner endon( "joined_team" );
	self.owner endon( "joined_spectators" );	

	level waittill ( "round_end_finished" );

	//	leave
	self thread heliGuardSupport_leave();
}

heliGuardSupport_leave()
{
	self endon( "death" );
	self notify( "leaving" );
	level.littlebirdGuard = undefined;

	self cleargunnertarget(HELI_GUARD_GUNNER);
	self clearturrettarget();

	//	rise
	self ClearLookAtEnt();
	flyHeight = getNoFlyZoneHeight( self.origin );
	targetPos = self.origin + (0,0,flyHeight);
	self SetSpeed( self.speed, 60 );
	self SetMaxPitchRoll( 45, 180 );
	self setVehGoalPos( targetPos );
	self waittill ( "goal" );	
	
	//	leave
	targetPos = targetPos + anglesToForward( self.angles ) * 15000;
	self setVehGoalPos( targetPos );
	self waittill ( "goal" );
	
	//	remove
	self notify( "gone" );	
	self removeLittlebird();
}

heliDestroyed()
{
	level.littlebirdGuard = undefined;
	
	if (! isDefined(self) )
		return;
		
	self SetSpeed( 25, 5 );
	self thread lbSpin( RandomIntRange(180, 220) );
	
	wait( RandomFloatRange( .5, 1.5 ) );
	
	lbExplode();
}

lbExplode()
{
	forward = ( self.origin + ( 0, 0, 1 ) ) - self.origin;

	deathAngles = self getTagAngles( "tag_deathfx" );
	playFx( level.chopper_fx["explode"]["death"], self getTagOrigin( "tag_deathfx" ), anglesToForward( deathAngles ), anglesToUp( deathAngles ) );
	
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
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "helicopter_guard_mp", self.team );
	
	if( IsDefined( self.marker ) )
		self.marker delete();
	
	self delete();
}

// this is different from the flares monitoring that the other helicopters do
// we want this to dodge the missiles if at all possible, making for a cool evasive manuever
heliGuardSupport_watchSAMProximity( player, missileTeam, missileTarget, missileGroup ) // self == level
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
			//newTarget thread maps\mp\killstreaks\_helicopter::deleteAfterTime( 5.0 );

			for( j = 0; j < missileGroup.size; j++ )					
			{
				if( IsDefined( missileGroup[ j ] ) )
				{
					missileGroup[ j ] SetTargetEntity( newTarget );
				}
			}

			// dodge the incoming missiles
			dodgePoint = missileTarget.origin + ( AnglesToRight( missileGroup[ i ].angles ) * 200 );
			missileTarget SetSpeed( missileTarget.speed, 100, 40 );
			missileTarget SetVehGoalPos( dodgePoint, true );

			wait( 2.0 );
			missileTarget SetSpeed( missileTarget.followSpeed, 20, 20 );
			break;
		}	
	}
}

//
//	node funcs
//

heliGuardSupport_getClosestStartNode( pos )
{
	// gets the start node that is closest to the position passed in
	closestNode = undefined;
	closestDistance = 999999;

	foreach( path in level.heli_paths )
	{
		foreach( loc in path )
		{ 	
			nodeDistance = distance( loc.origin, pos );
			if ( nodeDistance < closestDistance )
			{
				closestNode = loc;
				closestDistance = nodeDistance;
			}
		}
	}

	return closestNode;
}

heliGuardSupport_getClosestNode( pos )
{
	// gets the closest node to the position passed in, regardless of link
	closestNode = undefined;
	closestDistance = 999999;

	foreach( loc in level.heli_loop_paths )
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

heli_path_debug()
{
	foreach( path in level.heli_paths )
	{
		foreach( loc in path )
		{
			prev = loc;
			target = loc.target;
			
			while ( IsDefined( target ) )
			{
				target = GetEnt( target, "targetname" );
				Line( prev.origin, target.origin, ( 1, 0, 0 ), 1, false, 50000 );
				DebugStar( prev.origin, 50000, ( 0, 1, 0 ) );

				prev = target;
				target = prev.target;
			}
		}
	}

	foreach( loc in level.heli_loop_paths )
	{
		prev = loc;
		target = loc.target;
		first = loc;

		while ( IsDefined( target ) )
		{
			target = GetEnt( target, "targetname" );

			Line( prev.origin, target.origin, ( 0, 1, 0 ), 1, false, 50000 );
			DebugStar( prev.origin, 50000, ( 1, 0, 0 ) );

			prev = target;
			target = prev.target;

			if ( prev == first )
			{
				break;
			}
		}
	}
}

heliGuardSupport_getClosestLinkedNode( pos ) // self == heliGuard
{
	// gets the linked node that is closest to the current position and moving towards the position passed in
	closestNode = undefined;
	totalDistance = Distance2D( self.currentNode.origin, pos );
	closestDistance = totalDistance;

	target = self.currentNode.target;

	while( IsDefined( target ) )
	{
		nextNode = GetEnt( target, "targetname" );

		if ( nextNode == self.currentNode )
		{
			break;
		}

		nodeDistance = Distance2D( nextNode.origin, pos );
		if ( nodeDistance < totalDistance && nodeDistance < closestDistance )
		{
			closestNode = nextNode;
			closestDistance = nodeDistance;
		}

		target = nextNode.target;
	}

	return closestNode;
}

heliGuardSupport_arrayContains( array, compare )
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


heliGuardSupport_getLinkedStructs()
{
	array = [];
/*
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
*/
	return array;
}

heliGuardSupport_setAirStartNodes()
{
	level.air_start_nodes = getstructarray( "chopper_boss_path_start", "targetname" );

	foreach( loc in level.air_start_nodes )
	{
		// Grab array of path loc refs that this loc links to
		loc.neighbors = loc heliGuardSupport_getLinkedStructs();
	}	
}

heliGuardSupport_setAirNodeMesh()
{
	level.air_node_mesh = getstructarray( "so_chopper_boss_path_struct", "script_noteworthy" );
	
	foreach( loc in level.air_node_mesh )
	{
		// Grab array of path loc refs that this loc links to
		loc.neighbors = loc heliGuardSupport_getLinkedStructs();
		
		// Step through each loc in the map and if it
		// links to this loc, add it
		foreach( other_loc in level.air_node_mesh )
		{
			if ( loc == other_loc )
				continue;
			
			if ( !heliGuardSupport_arrayContains( loc.neighbors, other_loc ) && heliGuardSupport_arrayContains( other_loc heliGuardSupport_getLinkedStructs(), loc ) )
				loc.neighbors[ loc.neighbors.size ] = other_loc;
		}
	}	
}

/* ============================
Turret Logic Functions
============================ */

heliGuardSupport_attackTargets() // self == turret
{
	self endon( "death" );
	level endon( "game_ended" );
	self endon( "leaving" );

	for (;;)
	{
		self heliGuardSupport_fireStart();
	}
}

heliGuardSupport_fireStart() // self == turret
{
	self endon( "death" );
	self endon( "leaving" );
	self endon( "stop_shooting" );
	level endon( "game_ended" );

	for ( ;; )
	{		
		numShots = RandomIntRange( HELI_GUARD_MIN_SHOTS, HELI_GUARD_MAX_SHOTS + 1 );

		if ( !isdefined( self.primaryTarget ) ) 
		{
			self waittill( "primary acquired");
		}

		if ( IsDefined( self.primaryTarget ) )
		{
			targetEnt = self.primaryTarget;
			self thread heliGuardSupport_fireStop( targetEnt );
			
			self SetLookAtEnt( targetEnt );
			
			self setturrettargetent( targetEnt, PLAYER_HEIGHT_INCREASE );
			self waittill( "turret_on_target" );
			self setGunnerTargetEnt( targetEnt, PLAYER_HEIGHT_INCREASE, HELI_GUARD_GUNNER );
			
			for ( i = 0; i < numShots; i++ )
			{
				self fireGunnerWeapon( HELI_GUARD_GUNNER, self );
				self fireweapon();
				wait ( HELI_GUARD_FIRE_TIME );
			}
		}
		
		self clearturrettarget();
		self cleargunnertarget(HELI_GUARD_GUNNER);
		wait ( RandomFloatRange( HELI_GUARD_MIN_PAUSE, HELI_GUARD_MAX_PAUSE ) );
	}
}

heliGuardSupport_fireStop( targetEnt ) // self == turret
{
	self endon( "death" );
	self endon( "leaving" );
	self notify( "heli_guard_target_death_watcher" );
	self endon( "heli_guard_target_death_watcher" );

	targetEnt waittill_any( "death", "disconnect" );

	self notify( "stop_shooting" );
	self.primaryTarget = undefined;
	self SetLookAtEnt( self.owner );
	self cleargunnertarget(HELI_GUARD_GUNNER);
	self clearturrettarget();
}

/* ============================
END Turret Logic Functions
============================ */
