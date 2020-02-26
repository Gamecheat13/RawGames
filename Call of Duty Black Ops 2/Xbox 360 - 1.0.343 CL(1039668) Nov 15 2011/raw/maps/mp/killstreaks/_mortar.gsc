#include maps\mp\_utility;
#include common_scripts\utility;
#include maps\mp\killstreaks\_airsupport;

init()
{
	// mortar danger area is the circle of radius mortarDangerMaxRadius 
	// stretched by a factor of mortarDangerOvalScale in the direction of the incoming mortar,
	// moved by mortarDangerForwardPush * mortarDangerMaxRadius in the same direction.
	
	// DEBUG DVARS
	// use scr_mortardebug to show the target areas on the ground
	// use missileDebugDraw to see the line the mortars take on the way in
	// use scr_mortarAngle to tweak the angle at which the mortars come in
	// use scr_mortarDistance to tweak the distance from where the mortars come in
	
	level.mortarSelectionCount = 3;
	level.mortarDangerMaxRadius = 300;
	level.mortarDangerMinRadius = 200;
	level.mortarSelectorRadius = 800;
	level.mortarDangerForwardPush = 1.5;
	level.mortarDangerOvalScale = 6.0;
	level.mortarCanonShellCount =  maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "mortarCanonShellCount" );
	level.mortarCanonCount = maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "mortarCanonCount" );
	level.mortarShellsInAir = 0;
	level.mortarMapRange = level.mortarDangerMinRadius * .3 + level.mortarDangerMaxRadius * .7;
	level.mortarDangerMaxRadiusSq = level.mortarDangerMaxRadius * level.mortarDangerMaxRadius;
	level.mortarDangerCenters = [];
	//level.mortarfx = loadfx ("weapon/mortar/fx_mortar_strike_dirt_mp");	

	//precacheShellshock("mortarblast_friendly");
	precacheShellshock("mortarblast_enemy");
	precacheLocationSelector( "map_mortar_selector" );

	// register the radar hardpoint
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "allowmortar" ) )
	{
		maps\mp\killstreaks\_killstreaks::registerKillstreak("mortar_mp", "mortar_mp", "killstreak_mortar", "mortar_used", ::useKillstreakMortar, true);
		maps\mp\killstreaks\_killstreaks::registerKillstreakStrings("mortar_mp", &"KILLSTREAK_EARNED_MORTAR", &"KILLSTREAK_MORTAR_NOT_AVAILABLE", &"KILLSTREAK_MORTAR_INBOUND");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDialog("mortar_mp", "mpl_killstreak_mortar", "kls_mortars_used", "","kls_mortars_enemy", "", "kls_mortars_ready");
		maps\mp\killstreaks\_killstreaks::registerKillstreakDevDvar("mortar_mp", "scr_givemortar");
	}
}

useKillstreakMortar(hardpointType)
{
	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false )
		return false;
		
	result = self selectMortarLocation( hardpointType );
	
	if ( !isDefined( result ) || !result )
		return false;
	
	return true;
}


// Will select the appropriate hud map icon to display for mortar
mortarWaiter()
{
	self endon ( "death" );
	self endon ( "disconnect" );

	while(1)
	{
		self waittill( "mortar_status_change", owner );
		// if mortarinProgess is either active or undefined, turn both icons invisible when undefined
		if( !isDefined(level.mortarInProgress) )
		{
			pos = ( 0, 0, 0 );
			clientNum = -1;
			if ( isdefined ( owner ) )
				clientNum = owner getEntityNumber();
			artilleryiconlocation( pos, 0, 0, 1, clientNum );
		}
	}
}

useMortar( positions )
{
	if ( self maps\mp\killstreaks\_killstreakrules::killstreakStart( "mortar_mp", self.team ) == false )
		return false;

	level.mortarInProgress = true;
	
	trace = bullettrace( self.origin + (0,0,10000), self.origin, false, undefined );


	for ( i = 0; i < level.mortarSelectionCount; i++ )
		positions[i] = (positions[i][0], positions[i][1], trace["position"][2] - 514);

	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "team", "allowHardpointStreakAfterDeath" ) )
	{
		ownerDeathCount = self.deathCount;
	}
	else
	{
		ownerDeathCount = self.pers["hardPointItemDeathCountmortar_mp"];
	}
	
	if (level.teambased)
		teamType = self.team;
	else
		teamType = "none";
	
	thread doMortar( positions, self, teamType, ownerDeathCount );
	return true;
}

selectMortarLocation( hardpointType )
{
	self beginLocationMortarSelection( "map_mortar_selector", level.mortarSelectorRadius );
	self.selectingLocation = true;

	self thread endSelectionThink();

	locations = [];
	for ( i = 0; i < level.mortarSelectionCount; i++ )
	{
		self waittill( "confirm_location", location );

		if ( !IsDefined( location ) )
		{
			// selection was cancelled
			return false;
		}

		locations[i] = location;
	}

	if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( hardpointType, self.team ) == false)
	{
		return false;
	}

	return self finishHardpointLocationUsage( locations, ::useMortar );
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
//		thread playsoundinspace( "mpl_kls_mortar_impact", bombPoint );
//		radiusMortarShellshock( bombPoint, 256, 8, 4);
//		maps\mp\killstreaks\_airsupport::losRadiusDamage( bombPoint + (0,0,16), 256, 300, 50, owner); // targetpos, radius, maxdamage, mindamage, player causing damage
//	}
//}

startMortarCanon(  owner, coord, yaw, distance, startRatio, ownerDeathCount )
{
	owner endon("disconnect");
	
	volleyCount = 1;
		
	numberFired = 3;
	
	fireSoundDelay = .3;
	
	requiredDeathCount = ownerDeathCount;
	
	level.mortarCanonShellCount =  maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "mortarCanonShellCount" );

	for( volley = 0; volley < volleyCount; volley++ )
	{		
		volleyCoord = randPointRadiusAway( coord, 0 );
		// plays fire sounds
		//iprintlnbold ("plays fire sound");
		thread doMortarFireSound ( numberFired, fireSoundDelay, volleyCoord, yaw, distance );

		for( shell = 0; shell < level.mortarCanonShellCount; shell++ )
		{
			strikePos = volleyCoord;
			level thread doMortarStrike( owner, requiredDeathCount, strikePos, yaw, distance, startRatio );
			timeBetweenShells = GetDvarFloatDefault( "scr_timeBetweenShells", 1.3 );
			timeBetweenShells = randomfloatrange( timeBetweenShells-0.2, timeBetweenShells+0.2);
			wait( timeBetweenShells );		
		}
	}
}


callMortarStrike( owner, coord, yaw, distance, startRatio, ownerDeathCount )
{	
	owner endon("disconnect");

	level.mortarDamagedEnts = [];
	level.mortarDamagedEntsCount = 0;
	level.mortarDamagedEntsIndex = 0;
	
	volleyCoord = coord;

	level.mortarKillcamModelCounts = 0;
	
	thread startMortarCanon( owner, coord, yaw , distance, startRatio, ownerDeathCount);
}

getBestFlakDirection( hitpos, team )
{
	targetname = "mortar_"+team;
	spawns = getentarray(targetname,"targetname");
	
	if ( !isdefined(spawns) || spawns.size == 0 )
	{
		origins = get_random_mortar_origins();
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
		// this should mean that the mortar will have to cover the most distance
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

get_random_mortar_origins()
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


mortarImpactEffects( )
{
	self endon("disconnect");
	self endon( "mortar_status_change" );

	while ( level.mortarShellsInAir )
	{
		self waittill("projectile_impact", weapon, position, radius );
		
		if ( weapon == "mortar_mp" )
		{
			radiusMortarShellshock( position, radius * 1.1, 3, 1.5, self );
			maps\mp\gametypes\_shellshock::mortar_earthquake( position );
			
		}
	}
}

callStrike_mortarBombEffect( spawnPoint, bombdir, velocity, owner, requiredDeathCount, distance, ratio, pitch, yaw )
{
	pitch *= -1;
	gravity = GetDvarint( "bg_gravity" );
	
	// Trajectory: time = distance / ( velocity * cos( angle ) )
	airTime = distance / ( velocity * cos( pitch ) );
	timeElapsed = airtime * ratio;
	Vxo = cos ( pitch ) * velocity;
	Vyo = sin ( pitch ) * velocity;
		
	originalSpawn = spawnPoint;
		
	x = distance * ratio;
	// y = originalY + originalYVelocity * time + 1/2 * gravity * time ^ 2
	y = ( Vyo * timeElapsed ) - ( 0.5 * ( gravity * timeElapsed * timeElapsed ) );
	
	// y velocity effected by gravity
	// Vy = OriginalVy - gravity * time;
	Vy = Vyo - gravity * timeElapsed;
	// x velocity will not change
	Vx = Vxo;
	
	// V ^ 2 = Vx ^ 2 + Vy ^ 2
	V = sqrt ( Vx * Vx + Vy * Vy );
	
	theta = atan ( Vy / Vx );
	spawnPoint = ( spawnPoint[0] + ( cos( yaw ) * x ), spawnPoint[1] + ( sin( yaw ) * x ), spawnPoint[2] + y );
	fireAngle = ( 0, yaw, 0 );
	theta *= -1;
	fireAngle += (theta,0,0);
	
	bomb_velocity = VectorScale(anglestoforward(fireAngle), V);
	bomb = owner launchbomb( "mortar_mp", spawnPoint, bomb_velocity );

	timeToImpact = airTime - timeElapsed;
	
	lengthOfSound = GetDvarIntDefault( "scr_lengthOfMortarSound", 1.2 );
	incomingNum = randomint( 3 );
	if (incomingNum == 0)
	{
		lengthOfSound = 1.0;
	}
	if (incomingNum == 1)
	{
		lengthOfSound = .4;
	}
	if (incomingNum == 2)
	{
		lengthOfSound = .5;
	}
	else 
	{
		lengthOfSound = 1.3;	
	}
	alias = ("prj_mortar_incoming_0" + incomingNum);

	soundWaitTime = timeToImpact - lengthOfSound;
		
	soundbombsite = originalSpawn + VectorScale( anglestoforward( (0,yaw,0) ), distance );
	incoming_sound_ent = spawn( "script_origin", soundbombsite );
	
	incoming_sound_ent thread playSoundAfterTime( alias, soundWaitTime );


	bomb.requiredDeathCount = requiredDeathCount;
	bomb thread referenceCounter();
	bombsite = originalSpawn + VectorScale( anglestoforward( (0,yaw,0) ), distance );
	bomb thread debug_draw_bomb_path();
}

playSoundAfterTime( sound, time )
{
	//self endon("death");
	wait ( time );
	self thread checkPlayersTinitus ();	
	self playSound( sound );
	wait 2;
	self delete();
}


doMortarStrike( owner, requiredDeathCount, bombsite, yaw, distance, startRatio )
{
	if ( !isDefined( owner ) ) 
		return;
		
	// Find firing position and play mortar firing sound
	fireAngle = ( 0, yaw, 0 );
	firePos = bombsite + VectorScale( anglestoforward( fireAngle ), -1 * distance );
  //Play the fire sounds based on how many mortars are fired
  //thread doMortarFireSound ( 3, firePos, .04);
	
//	firePos = (0,0,100);
//	distance = 200;
	
	// Pick angle to fire at / incoming angle (negative is up)
	pitch = GetDvarfloat( "scr_mortarAngle");
	if( pitch != 0 )
	{
		pitch *= -1;
	}
	else
	{
		pitch = -75;
	}
	
	// Find the firing velocity needed to hit the target
	//  distance = ( (velocity ^ 2) * sin( 2 * angle ) ) / gravity
	//	velocity = sqrt( (gravity*distance) / sin( 2 * angle ) )
	gravity = GetDvarint( "bg_gravity" );
	velocity = sqrt( (gravity * distance) / sin( -2 * pitch ) );
	
	
	//thread playsoundinspace ("prj_mortar_incoming", bombsite );
	thread callStrike_mortarBombEffect( firePos, fireAngle, velocity, owner, requiredDeathCount, distance, startRatio, pitch, yaw );
}
doMortarFireSound ( shots, fireDelay, volleyCoord, yaw, distance )
{
	fireAngle = ( 0, yaw, 0 );
	firePos = volleyCoord + VectorScale( anglestoforward( fireAngle ), -1 * distance );
  //Play the fire sounds based on how many mortars are fired
  //thread doMortarFireSound ( 3, firePos, .04, anglestoforward, distance );
  
	for( i = 0; i < shots; i++ )
	{
		thread playSoundinSpace ("mpl_kls_mortar_launch", firePos, 3);
		//playsoundatposition ("mpl_kls_mortar_launch", firePos);
		wait ( fireDelay );
	}
}
	
mortarShellshock(type, duration)
{
	if (isdefined(self.beingMortarShellshocked) && self.beingMortarShellshocked)
		return;
	self.beingMortarShellshocked = true;
	
	self shellshock(type, duration);
	wait(duration + 1);
	
	self.beingMortarShellshocked = false;
}



radiusMortarShellshock(pos, radius, maxduration, minduration, owner )
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
//					players[i] thread mortarShellshock("default", duration);
//				}
//			}
//			else
			{
				shock = "mortarblast_enemy";
//				if ( level.teambased && isdefined(owner) && isplayer(owner) && owner.pers["tean
				players[i] thread mortarShellshock(shock, duration);
			}
		}
	}
}

mortarDamageEntsThread()
{
	self notify ( "mortarDamageEntsThread" );
	self endon ( "mortarDamageEntsThread" );

	for ( ; level.mortarDamagedEntsIndex < level.mortarDamagedEntsCount; level.mortarDamagedEntsIndex++ )
	{
		if ( !isDefined( level.mortarDamagedEnts[level.mortarDamagedEntsIndex] ) )
			continue;

		ent = level.mortarDamagedEnts[level.mortarDamagedEntsIndex];
		
		if ( !isDefined( ent.entity ) )
			continue; 
			
		if ( ( !ent.isPlayer && !ent.isActor ) || isAlive( ent.entity ) )
		{
			ent maps\mp\gametypes\_weapons::damageEnt(
				ent.eInflictor, // eInflictor = the entity that causes the damage (e.g. a bouncing betty)
				ent.damageOwner, // eAttacker = the player that is attacking
				ent.damage, // iDamage = the amount of damage to do
				"MOD_PROJECTILE_SPLASH", // sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
				"mortar_mp", // sWeapon = string specifying the weapon used (e.g. "frag_grenade_mp")
				ent.pos, // damagepos = the position damage is coming from
				vectornormalize(ent.damageCenter - ent.pos) // damagedir = the direction damage is moving in
			);			

			level.mortarDamagedEnts[level.mortarDamagedEntsIndex] = undefined;
			
			if ( ent.isPlayer || ent.isActor )
				wait ( 0.05 );
		}
		else
		{
			level.mortarDamagedEnts[level.mortarDamagedEntsIndex] = undefined;
		}
	}
}

pointIsInMortarArea( point, targetpos )
{
	return distance2d( point, targetpos ) <= level.mortarDangerMaxRadius * 1.25;
}


getSingleMortarDanger( point, origin, forward )
{
	center = origin + level.mortarDangerForwardPush * level.mortarDangerMaxRadius * forward;
	
	diff = point - center;
	diff = (diff[0], diff[1], 0);
	
	forwardPart = vectorDot( diff, forward ) * forward;
	perpendicularPart = diff - forwardPart;
	
	circlePos = perpendicularPart + forwardPart / level.mortarDangerOvalScale;
	
	distsq = lengthSquared( circlePos );
	
	if ( distsq > level.mortarDangerMaxRadius * level.mortarDangerMaxRadius )
		return 0;
	
	if ( distsq < level.mortarDangerMinRadius * level.mortarDangerMinRadius )
		return 1;
	
	dist = sqrt( distsq );
	distFrac = (dist - level.mortarDangerMinRadius) / (level.mortarDangerMaxRadius - level.mortarDangerMinRadius);
	
	assert( distFrac >= 0 && distFrac <= 1, distFrac );
	
	return 1 - distFrac;
}

getMortarDanger( point )
{
	danger = 0;
	for ( i = 0; i < level.mortarDangerCenters.size; i++ )
	{
		origin = level.mortarDangerCenters[i].origin;
		forward = level.mortarDangerCenters[i].forward;
		
		danger += getSingleMortarDanger( point, origin, forward );
	}
	return danger;
}

/#
debugMortarDangerCenters()
{
	level notify("debugMortarDangerCenters_thread");
	level endon("debugMortarDangerCenters_thread");
	
	if ( GetDvar( "scr_mortardebug") != "1" && GetDvar( "scr_spawnpointdebug") == "0" )
	{
		return;
	}
	
	while( level.mortarDangerCenters.size > 0 )
	{
		for ( i = 0; i < level.mortarDangerCenters.size; i++ )
		{
			origin = level.mortarDangerCenters[i].origin;
			forward = level.mortarDangerCenters[i].forward;
			
			origin += forward * level.mortarDangerForwardPush * level.mortarDangerMaxRadius;
			
			previnnerpos = (0,0,0);
			prevouterpos = (0,0,0);
			for ( j = 0; j <= 40; j++ )
			{
				frac = (j * 1.0) / 40;
				angle = frac * 360;
				dir = anglesToForward((0,angle,0));
				forwardPart = vectordot( dir, forward ) * forward;
				perpendicularPart = dir - forwardPart;
				pos = forwardPart * level.mortarDangerOvalScale + perpendicularPart;
				innerpos = pos * level.mortarDangerMinRadius;
				innerpos += origin;
				outerpos = pos * level.mortarDangerMaxRadius;
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


doMortar(origins, owner, team, ownerDeathCount )
{	
	self notify( "mortar_status_change", owner );
	yaws = [];
	targetPos = [];
	danger_influencer_id = [];
	
	flakDistance = GetDvarfloat( "scr_mortarDistance");
	if( flakDistance == 0 )
	{
		flakDistance = 6000;
	}

	for ( currentMortar = 0; currentMortar < level.mortarSelectionCount; currentMortar++ )
	{
		trace = bullettrace(origins[currentMortar], origins[currentMortar] + (0,0,-1000), false, undefined);
		targetpos[currentMortar] = trace["position"];
		
		// failsafe for mapholes.  This way they will at least see the mortar.
		if ( targetpos[currentMortar][2] < origins[currentMortar][2] - 999 )
		{
			if ( isdefined( owner ) )
			{
				targetpos[currentMortar] = ( targetpos[currentMortar][0], targetpos[currentMortar][1], owner.origin[2]);
			}
			else
			{
				targetpos[currentMortar] = ( targetpos[currentMortar][0], targetpos[currentMortar][1], 0);
			}		
		}
		
		// Find center of flak origins
		yaws[currentMortar] = getBestFlakDirection( targetpos[currentMortar], team );
		direction = ( 0, yaws[currentMortar], 0 );

		// Adjust the distance to change the time from calling mortar to shell landing
		flakCenter = targetPos[currentMortar] + VectorScale( anglestoforward( direction ), -1 * flakDistance );
		
		if ( level.teambased )
		{
			players = level.players;
			if ( !level.hardcoreMode )
			{
				for(i = 0; i < players.size; i++)
				{
					if(isalive(players[i]) && (isdefined(players[i].team)) && (players[i].team == team)) 
					{
						if ( pointIsInMortarArea( players[i].origin, targetpos[currentMortar] ) )
							players[i] DisplayGameModeMessage(&"MP_WAR_MORTAR_INBOUND_NEAR_YOUR_POSITION", "uin_alert_slideout" );
					}
				}
			}
		}
		else
		{
			if ( !level.hardcoreMode )
			{
				if ( pointIsInMortarArea( owner.origin, targetpos[currentMortar] ) )
					owner DisplayGameModeMessage(&"MP_WAR_MORTAR_INBOUND_NEAR_YOUR_POSITION", "uin_alert_slideout");
			}
		}
	}

	owner maps\mp\killstreaks\_killstreaks::playKillstreakStartDialog( "mortar_mp", team );
	owner AddPlayerStat( "MORTAR_USED", 1 );
	level.globalKillstreaksCalled++;
	self AddWeaponStat( "mortar_mp", "used", 1 );

//	wait 2;

	if ( !isDefined( owner ) )
	{
		level.mortarInProgress = undefined;
		maps\mp\killstreaks\_killstreakrules::killstreakStop( "mortar_mp", team ); 
		level.mortarShellsInAir = undefined;
		
		self notify( "mortar_status_change", owner );
		return;
	}
	
	owner notify ( "begin_mortar" );

	for ( currentMortar = 0; currentMortar < level.mortarSelectionCount; currentMortar++ )
	{
		dangerCenter = spawnstruct();
		dangerCenter.origin = targetpos[currentMortar];
		dangerCenter.forward = (0,0,0);
		level.mortarDangerCenters[ level.mortarDangerCenters.size ] = dangerCenter;
		danger_influencer_id[currentMortar] = maps\mp\gametypes\_spawning::create_artillery_influencers( targetpos[currentMortar], level.mortarDangerMaxRadius * 3.0 );
	}

	/# level thread debugMortarDangerCenters(); #/
	
	//level.mortarCanonCount = maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "mortarCanonCount" );
	level.mortarCanonShellCount =  maps\mp\gametypes\_tweakables::getTweakableValue( "killstreak", "mortarCanonShellCount" );
	
	level.mortarShellsInAir = level.mortarCanonCount * level.mortarCanonShellCount;
	owner thread mortarImpactEffects( );
	
	startRatio = GetDvarFloatDefault( "scr_mortarStartRatio", 0.3 );
	
	clientNum = -1;
		
	if ( isdefined ( owner ) )
		clientNum = owner getEntityNumber();

	for ( currentMortar = 0; currentMortar < level.mortarSelectionCount; currentMortar++ )
	{
		//currentStartRatio = startRatio / ( currentMortar + 1 );
		artilleryiconlocation( targetpos[currentMortar], team, 1, 1, clientNum );
		callMortarStrike( owner, targetpos[currentMortar], yaws[currentMortar], flakDistance, startRatio, ownerDeathCount );
		timeBetweenMortars = GetDvarFloatDefault( "scr_timeBetweenMortars", 2.5 );
		wait( timeBetweenMortars );
	}
	
	max_safety_wait = gettime() + 10000;
	while ( level.mortarShellsInAir && gettime() < max_safety_wait)
	{
		wait(0.1);
	}

	newarray = [];
	found = false;
	previousSize = level.mortarDangerCenters.size;
	for ( currentMortar = 0; currentMortar < level.mortarSelectionCount; currentMortar++ )
	{	
		found = false;
		for ( i = 0; i < level.mortarDangerCenters.size; i++ )
		{
			if ( level.mortarDangerCenters[i].origin == targetpos[currentMortar] )
			{
				level.mortarDangerCenters[i] = level.mortarDangerCenters[level.mortarDangerCenters.size - 1];
				level.mortarDangerCenters[level.mortarDangerCenters.size - 1] = undefined;
			}
		}
	}
	
	assert ( level.mortarDangerCenters.size == previousSize - level.mortarSelectionCount );

	for ( currentMortar = 0; currentMortar < level.mortarSelectionCount; currentMortar++ )
	{
		removeinfluencer( danger_influencer_id[currentMortar] );	
	}

	level.mortarInProgress = undefined;
	maps\mp\killstreaks\_killstreakrules::killstreakStop( "mortar_mp", team ); 
	self notify( "mortar_status_change", owner );
}

referenceCounter()
{
	self waittill( "death" );
	
	level.mortarShellsInAir = level.mortarShellsInAir - 1;
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
air_raid_audio()
{
	air_raid_1 = getent( "air_raid_1", "targetname" );
	if(isdefined(air_raid_1))
	{
		air_raid_1 playsound("air_raid_a");
	}
}
checkPlayersTinitus ()
{
  players = GET_PLAYERS();
 
  for ( i = 0; i < players.size; i++ )
	{
		area = 800 * 800;
		if (isdefined (self))
		{
		if ( DistanceSquared( self.origin, players[i].origin ) < area )		
			{
				players[i] playlocalsound("mpl_kls_exlpo_tinitus");	
			}
		}			
	}	
}