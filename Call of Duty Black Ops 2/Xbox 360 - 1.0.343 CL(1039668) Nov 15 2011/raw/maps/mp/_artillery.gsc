#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\_airsupport;

init()
{
	// artillery danger area is the circle of radius artilleryDangerMaxRadius 
	// stretched by a factor of artilleryDangerOvalScale in the direction of the incoming artillery,
	// moved by artilleryDangerForwardPush * artilleryDangerMaxRadius in the same direction.

	// DEBUG DVARS
	// use scr_artillerydebug to show the target areas on the ground
	// use missileDebugDraw to see the line the mortars take on the way in
	// use scr_artilleryAngle to tweak the angle at which the artillery comes in
	// use scr_artilleryDistance to tweak the distance from where the artillery comes in

	level.artilleryDangerMaxRadius = 750;
	level.artilleryDangerMinRadius = 300;
	level.artilleryDangerForwardPush = 1.5;
	level.artilleryDangerOvalScale = 6.0;
	level.artilleryCanonShellCount =  maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "artilleryCanonShellCount" );
	level.artilleryCanonCount = maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "artilleryCanonCount" );
	level.artilleryShellsInAir = 0;
	level.artilleryMapRange = level.artilleryDangerMinRadius * .3 + level.artilleryDangerMaxRadius * .7;
	level.artilleryDangerMaxRadiusSq = level.artilleryDangerMaxRadius * level.artilleryDangerMaxRadius;
	level.artilleryDangerCenters = [];
	//level.artilleryfx = loadfx ("weapon/artillery/fx_artillery_strike_dirt_mp");	
	
	//precacheShellshock("artilleryblast_friendly");
	//precacheShellshock("artilleryblast_enemy");
	//precacheLocationSelector( "map_artillery_selector" );

	// register the artillery hardpoint
	//if ( maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "allowartillery" ) )
	//{
	//	maps\mp\killstreaks\_killstreaks::registerKillstreak("artillery_mp", "artillery_mp","killstreak_artillery","artillery_used", ::useKillstreakArtillery);
	//	maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("artillery_mp", &"MP_EARNED_ARTILLERY", &"MP_ARTILLERY_NOT_AVAILABLE", &"MP_ARTILLERY_INBOUND" );
	//	maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("artillery_mp", "mpl_killstreak_artillery", "kls_artillery_used", "","kls_artillery_enemy", "", "kls_artillery_ready");
	//	maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("artillery_mp", "scr_giveartillery");
	//}

}

useKillstreakArtillery( hardpointType )
{
	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;
		
	result = self maps\mp\_artillery::selectArtilleryLocation( hardpointType );
	
	if ( !isDefined( result ) || !result )
		return false;

	return true;
}

// Will select the appropriate hud map icon to display for artillery
artilleryWaiter()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	while(1)
	{
		self waittill( "artillery_status_change", owner );
		// if artilleryinProgess is either active or undefined, turn both icons invisible when undefined
		if( !isDefined(level.artilleryInProgress) )
		{
			pos = ( 0, 0, 0 );
			clientNum = -1;
			if ( isdefined ( owner ) )
				clientNum = owner getEntityNumber();
			artilleryiconlocation( pos, 0, 0, 0, clientNum );
		}
	}
}

useArtillery( pos )
{
	if ( self maps\mp\killstreaks\_killstreakrules::killstreakStart( "artillery_mp", self.team ) == false )
		return false;

	level.artilleryInProgress = true;

	trace = bullettrace( self.origin + (0,0,10000), self.origin, false, undefined );
	pos = (pos[0], pos[1], trace["position"][2] - 514);

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "team", "allowHardpointStreakAfterDeath" ) )
	{
		ownerDeathCount = self.deathCount;
	}
	else
	{
		ownerDeathCount = self.pers["hardPointItemDeathCountartillery_mp"];
	}
	
	if (level.teambased)
		teamType = self.team;
	else
		teamType = "none";
		
	thread doArtillery( pos, self, teamType, ownerDeathCount );
	return true;
}

selectArtilleryLocation( hardpointType )
{
	self beginLocationArtillerySelection( "map_artillery_selector", level.artilleryDangerMaxRadius * 1.2 );
	self.selectingLocation = true;

	self thread endSelectionThink();

	self waittill( "confirm_location", location );

	if ( !IsDefined( location ) )
	{
		// selection was cancelled
		return false;
	}

	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
	{
		return false;
	}
	
	
	return self finishHardpointLocationUsage( location, ::useArtillery );
}

//callStrike_bomb( bombTime, coord, repeat, owner )
//{
//	accuracyRadius = 512;
//	
//	for( i = 0; i < repeat; i++ )
//	{
//		randVec = ( 0, randomint( 360 ), 0 );
//		bombPoint = coord + VectorScale( anglestoforward( randVec ), accuracyRadius );
//		
//		wait bombTime;
//		iprintlnbold("playsoundinspace");
//		thread playsoundinspace( "mpl_kls_artillery_impact", bombPoint );
//		radiusArtilleryShellshock( bombPoint, 512, 8, 4);
//		maps\mp\_airsupport::losRadiusDamage( bombPoint + (0,0,16), 768, 300, 50, owner); // targetpos, radius, maxdamage, mindamage, player causing damage
//	}
//}

startArtilleryCanon(  owner, coord, yaw, distance, initial_delay, ownerDeathCount)
{
	owner endon("disconnect");
	wait ( initial_delay );
	
	cannonAccuracyRadiusMin = 0;	 
	cannonAccuracyRadiusMax = 500; 
	shellAccuracyRadiusMin = 0;	 
	shellAccuracyRadiusMax = 520; 

	volleyCount = 1;
	volleyWaitMin = 1.2;
	volleyWaitMax = 1.6;
	shellWaitMin = 2;
	shellWaitMax = 4;

	requiredDeathCount = ownerDeathCount;
	
	for( volley = 0; volley < volleyCount; volley++ )
	{		
		volleyCoord = randPointRadiusAway( coord, randomfloatrange( cannonAccuracyRadiusMin, cannonAccuracyRadiusMax ) );

		for( shell = 0; shell < level.artilleryCanonShellCount; shell++ )
		{
			wait randomFloatRange( shellWaitMin, shellWaitMax );
			strikePos = randPointRadiusAway( volleyCoord, randomintrange( shellAccuracyRadiusMin, shellAccuracyRadiusMax ) );
			level thread doArtilleryStrike( owner, requiredDeathCount, strikePos, yaw, distance );
		}
		// Each volley gets closer to the target
		cannonAccuracyRadiusMin -= cannonAccuracyRadiusMin / (volleyCount - volley + 1);
		cannonAccuracyRadiusMax -= cannonAccuracyRadiusMax / (volleyCount - volley + 1);

		wait randomFloatRange( volleyWaitMin, volleyWaitMax );
	}
}


callArtilleryStrike( owner, coord, yaw, distance, ownerDeathCount )
{	
	owner endon("disconnect");

	level.artilleryDamagedEnts = [];
	level.artilleryDamagedEntsCount = 0;
	level.artilleryDamagedEntsIndex = 0;
	
	volleyCoord = coord;

	level.artilleryKillcamModelCounts = 0;
	
	minInitialDelay = 0;
	maxInitialDelay = 1;
	minDistanceRandom = -100;
	maxDistanceRandom = 100;
	minYawRandom = 1;
	maxYawRandom = 3;	
	thread startArtilleryCanon( owner, coord, yaw - RandomIntRange( minYawRandom, maxYawRandom ) , distance - RandomFloatRange( minDistanceRandom, maxDistanceRandom ), RandomFloatRange( minInitialDelay, maxInitialDelay ),ownerDeathCount);
	thread startArtilleryCanon( owner, coord, yaw, distance, RandomFloatRange( minInitialDelay, maxInitialDelay ),ownerDeathCount);
	thread startArtilleryCanon( owner, coord, yaw + RandomIntRange( minYawRandom, maxYawRandom ) , distance - RandomFloatRange( minDistanceRandom, maxDistanceRandom ), RandomFloatRange( minInitialDelay, maxInitialDelay ),ownerDeathCount);

}

getBestFlakDirection( hitpos, team )
{
	targetname = "artillery_"+team;
	spawns = getentarray(targetname,"targetname");
	
	if ( !isdefined(spawns) || spawns.size == 0 )
	{
		origins = get_random_artillery_origins();
	}
	else
	{
		origins = get_origin_array( spawns );
	}
	
	closest_dist = 99999999*99999999;
	closest_index = randomint(origins.size);
	negative_t = false;
	
	for ( i = 0; i < origins.size; i++)
	{
		result = closest_point_on_line_to_point( hitpos, level.mapcenter, origins[i] );
		
		// try to stay on the negative spawn side of the center of the map
		// this should mean that the artillery will have to cover the most distance
		// over the level and should look better in the kill cam
		if ( result.t > 0 && negative_t )
			continue;
			
		if ( result.distsqr < closest_dist || (!negative_t && result.t < 0 ) )
		{
			closest_dist = result.distsqr;
			closest_index = i;
			
			if ( result.t < 0 )
			{
				negative_t = true;
			}
		}
	}
	spot = origins[closest_index];
	
	// the direction is actually the line between the spawn and map center
	// not the spawn spot and the hit position.
  direction = level.mapcenter - spot ;
  
  angles = vectortoangles(direction);
  
  return angles[1];
} 

get_random_artillery_origins()
{
	// expanding prevents colinear points
	// and gives us some variation in narrow situations
	
	maxs = level.spawnMaxs + ( 1000, 1000, 0);
	mins = level.spawnMins - ( 1000, 1000, 0);

	origins = [];
	// determine the longest axis of the level
	x_length = abs( maxs[0] - mins[0] );
	y_length = abs( maxs[1] - mins[1]);

	major_axis = 0;
	minor_axis = 1;
	if ( y_length > x_length )
	{
		major_axis = 1;
		minor_axis = 0;
	}
	for ( i = 0; i < 3; i++ )
	{
		major_value = mins[major_axis] - randomfloatrange( mins[major_axis], level.mapcenter[major_axis]) * ( 2.0 );
		minor_value = randomfloatrange( mins[minor_axis], maxs[minor_axis]);
		 
		if ( major_axis == 0)
		{
			origins[origins.size] = ( major_value, minor_value, level.mapCenter[2] );
		}
		else
		{
			origins[origins.size] = ( minor_value, major_value, level.mapCenter[2] );
		}
		
		major_value = maxs[major_axis] + randomfloatrange( level.mapcenter[major_axis], maxs[major_axis]) * ( 2.0 );
		minor_value = randomfloatrange( mins[minor_axis], maxs[minor_axis]);
		 
		if ( major_axis == 0)
		{
			origins[origins.size] = ( major_value, minor_value, level.mapCenter[2] );
		}
		else
		{
			origins[origins.size] = ( minor_value, major_value, level.mapCenter[2] );
		}
	}
			
	return origins;
}


artilleryImpactEffects( )
{
	self endon("disconnect");
	self endon( "artillery_status_change" );

	while ( level.artilleryShellsInAir )
	{
		self waittill("projectile_impact", weapon, position, radius );
		
		if ( weapon == "artillery_mp" )
		{
			radiusArtilleryShellshock( position, radius * 1.1, 3, 1.5, self );
			maps\mp\gametypes\_shellshock::artillery_earthquake( position );
		}
	}
}

callStrike_artilleryBombEffect( spawnPoint, bombdir, velocity, owner, requiredDeathCount, distance )
{

 	bomb_velocity = VectorScale(anglestoforward(bombdir), velocity);
	bomb = owner launchbomb( "artillery_mp", spawnPoint, bomb_velocity );
	
	bomb.requiredDeathCount = requiredDeathCount;
	
	
	// TrajectoRy: time = distance / ( velocity * cos( angle ) )
	airTime = distance / ( velocity * cos( bombdir[0] ) );

	bomb thread referenceCounter();
	
	bombsite = spawnPoint + VectorScale( anglestoforward( (0,bombdir[1],0) ), distance );
	
	bomb thread debug_draw_bomb_path();
}


doArtilleryStrike( owner, requiredDeathCount, bombsite, yaw, distance )
{
	if ( !isDefined( owner ) ) 
		return;
		
	// Find firing position and play artillery firing sound
	fireAngle = ( 0, yaw, 0 );
	firePos = bombsite + VectorScale( anglestoforward( fireAngle ), -1 * distance );
//	thread playSoundinSpace( "artillery_launch", firePos );
	
//	firePos = (0,0,100);
//	distance = 200;
	
	// Pick angle to fire at / incoming angle (negative is up)
	pitch = getdvarfloat( "scr_artilleryAngle");
	if( pitch != 0 )
	{
		pitch *= -1;
	}
	else
	{
		pitch = -75;
	}

	pitch += randomintrange( -3, 3 );
	
	fireAngle += (pitch,0,0);

	// Find the firing velocity needed to hit the target
	//  distance = ( (velocity ^ 2) * sin( 2 * angle ) ) / gravity
	//	velocity = sqrt( (gravity*distance) / sin( 2 * angle ) )
	gravity = getdvarint( "bg_gravity" );
	velocity = sqrt( (gravity * distance) / sin( -2 * pitch ) );

//	thread playsoundinspace ("artillery_whistle", bombsite );
	thread callStrike_ArtilleryBombEffect( firePos, fireAngle, velocity, owner, requiredDeathCount, distance );
}

artilleryShellshock(type, duration)
{
	if (isdefined(self.beingArtilleryShellshocked) && self.beingArtilleryShellshocked)
		return;
	self.beingArtilleryShellshocked = true;
	
	self shellshock(type, duration);
	wait(duration + 1);
	
	self.beingArtilleryShellshocked = false;
}



radiusArtilleryShellshock(pos, radius, maxduration, minduration, owner )
{
	players = level.players;
	for (i = 0; i < players.size; i++)
	{
		if (!isalive(players[i]))
			continue;
		
		playerpos = players[i].origin + (0,0,32);
		dist = distance(pos, playerpos);
		if (dist < radius) 
		{
			duration = int(maxduration + (minduration-maxduration)*dist/radius);
			
			// if friendly fire is off, do not apply to teammates
//			if( isDefined( level.friendlyFireDisabled ) && level.friendlyFireDisabled )
//			{
//				if( owner.team != players[i].team || owner == players[i] )
//				{
//					players[i] thread artilleryShellshock("default", duration);
//				}
//			}
//			else
			{
				shock = "artilleryblast_enemy";
//				if ( level.teambased && isdefined(owner) && isplayer(owner) && owner.pers["tean
				players[i] thread artilleryShellshock(shock, duration);
			}
		}
	}
}

artilleryDamageEntsThread()
{
	self notify ( "artilleryDamageEntsThread" );
	self endon ( "artilleryDamageEntsThread" );

	for ( ; level.artilleryDamagedEntsIndex < level.artilleryDamagedEntsCount; level.artilleryDamagedEntsIndex++ )
	{
		if ( !isDefined( level.artilleryDamagedEnts[level.artilleryDamagedEntsIndex] ) )
			continue;

		ent = level.artilleryDamagedEnts[level.artilleryDamagedEntsIndex];
		
		if ( !isDefined( ent.entity ) )
			continue; 
			
		if ( ( !ent.isPlayer && !ent.isActor ) || isAlive( ent.entity ) )
		{
			ent maps\mp\gametypes\_weapons::damageEnt(
				ent.eInflictor, // eInflictor = the entity that causes the damage (e.g. a bouncing betty)
				ent.damageOwner, // eAttacker = the player that is attacking
				ent.damage, // iDamage = the amount of damage to do
				"MOD_PROJECTILE_SPLASH", // sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
				"artillery_mp", // sWeapon = string specifying the weapon used (e.g. "frag_grenade_mp")
				ent.pos, // damagepos = the position damage is coming from
				vectornormalize(ent.damageCenter - ent.pos) // damagedir = the direction damage is moving in
			);			

			level.artilleryDamagedEnts[level.artilleryDamagedEntsIndex] = undefined;
			
			if ( ent.isPlayer || ent.isActor )
				wait ( 0.05 );
		}
		else
		{
			level.artilleryDamagedEnts[level.artilleryDamagedEntsIndex] = undefined;
		}
	}
}

pointIsInArtilleryArea( point, targetpos )
{
	return distance2d( point, targetpos ) <= level.artilleryDangerMaxRadius * 1.25;
}


getSingleArtilleryDanger( point, origin, forward )
{
	center = origin + level.artilleryDangerForwardPush * level.artilleryDangerMaxRadius * forward;
	
	diff = point - center;
	diff = (diff[0], diff[1], 0);
	
	forwardPart = vectorDot( diff, forward ) * forward;
	perpendicularPart = diff - forwardPart;
	
	circlePos = perpendicularPart + forwardPart / level.artilleryDangerOvalScale;
	
	distsq = lengthSquared( circlePos );
	
	if ( distsq > level.artilleryDangerMaxRadius * level.artilleryDangerMaxRadius )
		return 0;
	
	if ( distsq < level.artilleryDangerMinRadius * level.artilleryDangerMinRadius )
		return 1;
	
	dist = sqrt( distsq );
	distFrac = (dist - level.artilleryDangerMinRadius) / (level.artilleryDangerMaxRadius - level.artilleryDangerMinRadius);
	
	assert( distFrac >= 0 && distFrac <= 1, distFrac );
	
	return 1 - distFrac;
}

getArtilleryDanger( point )
{
	danger = 0;
	for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
	{
		origin = level.artilleryDangerCenters[i].origin;
		forward = level.artilleryDangerCenters[i].forward;
		
		danger += getSingleArtilleryDanger( point, origin, forward );
	}
	return danger;
}

/#
debugArtilleryDangerCenters()
{
	level notify("debugArtilleryDangerCenters_thread");
	level endon("debugArtilleryDangerCenters_thread");
	
	if ( getdvar( "scr_artillerydebug") != "1" && getdvar( "scr_spawnpointdebug") == "0" )
	{
		return;
	}
	
	while( level.artilleryDangerCenters.size > 0 )
	{
		for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
		{
			origin = level.artilleryDangerCenters[i].origin;
			forward = level.artilleryDangerCenters[i].forward;
			
			origin += forward * level.artilleryDangerForwardPush * level.artilleryDangerMaxRadius;
			
			previnnerpos = (0,0,0);
			prevouterpos = (0,0,0);
			for ( j = 0; j <= 40; j++ )
			{
				frac = (j * 1.0) / 40;
				angle = frac * 360;
				dir = anglesToForward((0,angle,0));
				forwardPart = vectordot( dir, forward ) * forward;
				perpendicularPart = dir - forwardPart;
				pos = forwardPart * level.artilleryDangerOvalScale + perpendicularPart;
				innerpos = pos * level.artilleryDangerMinRadius;
				innerpos += origin;
				outerpos = pos * level.artilleryDangerMaxRadius;
				outerpos += origin;
				
				if ( j > 0 )
				{
					line( innerpos, previnnerpos, (1, 0, 0) );
					line( outerpos, prevouterpos, (1,.5,.5) );
				}
				
				previnnerpos = innerpos;
				prevouterpos = outerpos;
			}
		}
		wait .05;
	}
}
#/


doArtillery(origin, owner, team, ownerDeathCount )
{	
	self notify( "artillery_status_change", owner );
	trace = bullettrace(origin, origin + (0,0,-1000), false, undefined);
	targetpos = trace["position"];
	
	// failsafe for mapholes.  This way they will at least see the artillery.
	if ( targetpos[2] < origin[2] - 999 )
	{
		if ( isdefined( owner ) )
		{
			targetpos = ( targetpos[0], targetpos[1], owner.origin[2]);
		}
		else
		{
			targetpos = ( targetpos[0], targetpos[1], 0);
		}		
	}
	
	clientNum = -1;
	if ( isdefined ( owner ) )
		clientNum = owner getEntityNumber();
	artilleryiconlocation( targetpos, team, 1, 0, clientNum );
	
	// Adjust targetpos by uncertainty radius
	uncertaintyRadiusMin = 0;
	uncertaintyRadiusMax = 10;
	targetpos = randPointRadiusAway(targetpos,RandomIntRange(uncertaintyRadiusMin,uncertaintyRadiusMax));
	
	// Find center of flak origins
	yaw = getBestFlakDirection( targetpos, team );
	direction = ( 0, yaw, 0 );
	// Adjust the distance to change the time from calling artillery to shell landing
	flakDistance = getdvarfloat( "scr_artilleryDistance");
	if( flakDistance == 0 )
	{
		flakDistance = 10000;
	}
	flakCenter = targetPos + VectorScale( anglestoforward( direction ), -1 * flakDistance );
	
	if ( level.teambased )
	{
		players = level.players;
		if ( !level.hardcoreMode )
		{
			for(i = 0; i < players.size; i++)
			{
				if(isalive(players[i]) && (isdefined(players[i].team)) && (players[i].team == team)) 
				{
					if ( pointIsInArtilleryArea( players[i].origin, targetpos ) )
						players[i] iprintlnbold(&"MP_WAR_ARTILLERY_INBOUND_NEAR_YOUR_POSITION");
				}
			}
		}
		
		thread maps\mp\gametypes\_battlechatter_mp::onKillstreakUsed( "artillery", level.otherTeam[team] );
		//Collin's Air Raid siren
		thread air_raid_audio();
		//for ( i = 0; i < level.players.size; i++ )
		//{
		//	player = level.players[i];
		//	playerteam = player.team;
		//	if ( isdefined( playerteam ) )
		//	{
		//		if ( playerteam == team )
		//			player iprintln( &"MP_WAR_ARTILLERY_INBOUND", owner );
		//	}
		//}
	}
	else
	{
		if ( !level.hardcoreMode )
		{
			if ( pointIsInArtilleryArea( owner.origin, targetpos ) )
				owner iprintlnbold(&"MP_WAR_ARTILLERY_INBOUND_NEAR_YOUR_POSITION");
		}
	}
	
	owner maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "artillery_mp", team );
	owner maps\mp\gametypes\_persistence::statAdd( "ARTILLERY_USED", 1, false );
	level.globalKillstreaksCalled++;
	self AddWeaponStat( "killstreak_artillery", "used", 1 );

//	wait 2;

	if ( !isDefined( owner ) )
	{
		level.artilleryInProgress = undefined;
		level.artilleryShellsInAir = undefined;
		maps\mp\killstreaks\_killstreakrules::killstreakStop( "artillery_mp", team );
		
		self notify( "artillery_status_change", owner );
		return;
	}
	
	owner notify ( "begin_artillery" );
	
	dangerCenter = spawnstruct();
	dangerCenter.origin = targetpos;
	dangerCenter.forward = (0,0,0);
	level.artilleryDangerCenters[ level.artilleryDangerCenters.size ] = dangerCenter;
	danger_influencer_id = maps\mp\gametypes\_spawning::create_artillery_influencers( targetpos, -1 );	// -1 radius means use the dvar setting
	
	/# level thread debugArtilleryDangerCenters(); #/
	
	level.artilleryShellsInAir = level.artilleryCanonCount * level.artilleryCanonShellCount;
	owner thread artilleryImpactEffects( );
	callArtilleryStrike( owner, targetpos, yaw, flakDistance, ownerDeathCount );
	
	max_safety_wait = gettime() + 45000;
	while ( level.artilleryShellsInAir && gettime() < max_safety_wait)
	{
		wait(0.1);
	}
	
	found = false;
	newarray = [];
	for ( i = 0; i < level.artilleryDangerCenters.size; i++ )
	{
		if ( !found && level.artilleryDangerCenters[i].origin == targetpos )
		{
			found = true;
			continue;
		}
		
		newarray[ newarray.size ] = level.artilleryDangerCenters[i];
	}
	assert( found );
	assert( newarray.size == level.artilleryDangerCenters.size - 1 );
	level.artilleryDangerCenters = newarray;

	removeinfluencer( danger_influencer_id );
	
	level.artilleryInProgress = undefined;
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "artillery_mp", team );
	self notify( "artillery_status_change", owner );
}

referenceCounter()
{
	self waittill( "death" );
	
	level.artilleryShellsInAir = level.artilleryShellsInAir - 1;
}


randPointRadiusAway( origin, accuracyRadius )
{
	randVec = ( 0, randomint( 360 ), 0 );
	newPoint = origin + VectorScale( anglestoforward( randVec ), accuracyRadius );
	return newPoint;
}


get_origin_array( from_array )
{
	origins = [];
	
	for ( i = 0; i < from_array.size; i++ )
	{
		origins[origins.size] = from_array[i].origin;
	}
	return origins;
}


closest_point_on_line_to_point( Point, LineStart, LineEnd )
{
	result = spawnstruct();
	
	LineMagSqrd = lengthsquared(LineEnd - LineStart);
 
    t =	( ( ( Point[0] - LineStart[0] ) * ( LineEnd[0] - LineStart[0] ) ) +
				( ( Point[1] - LineStart[1] ) * ( LineEnd[1] - LineStart[1] ) ) +
				( ( Point[2] - LineStart[2] ) * ( LineEnd[2] - LineStart[2] ) ) ) /
				( LineMagSqrd );
 
 	result.t = t;

	start_x = LineStart[0] + t * ( LineEnd[0] - LineStart[0] );
	start_y = LineStart[1] + t * ( LineEnd[1] - LineStart[1] );
	start_z = LineStart[2] + t * ( LineEnd[2] - LineStart[2] );
		
	result.point = (start_x,start_y,start_z);
	result.distsqr = distancesquared( result.point, point );
	
	return result;
}


//AUDIO FUNCTIONS FROM COLLIN
air_raid_audio()
{
	air_raid_1 = getent( "air_raid_1", "targetname" );
	if(isdefined(air_raid_1))
	{
		air_raid_1 playsound("air_raid_a");
	}
}
