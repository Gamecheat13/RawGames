#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;

init()
{
	precacheItem( "radar_mp" );
	precacheItem( "dogs_mp" );
	precacheItem( "artillery_mp" );
	precacheItem( "squadcommand_mp" );	
	precacheShellshock("artilleryblast_friendly");
	precacheShellshock("artilleryblast_enemy");

	makeDvarServerInfo( "ui_radar_allies", 0 );
	makeDvarServerInfo( "ui_radar_axis", 0 );
	setDvar( "ui_radar_allies", 0 );
	setDvar( "ui_radar_axis", 0 );
	setDvar( "ui_radar_client", 0 );
	
	level.hardpointItems = [];
	priority = 0;
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "allowradar" ) )
	{
		level.hardpointItems["radar_mp"] = priority;
		priority++;
	}
	
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "allowartillery" ) )
	{
		level.hardpointItems["artillery_mp"] = priority;
		priority++;
	}
	
	if ( maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "allowdogs" ) )
	{
		level.hardpointItems["dogs_mp"] = priority;
		priority++;
	}

	level.hardpointHints["radar_mp"] = &"MP_EARNED_RADAR";
	level.hardpointHints["artillery_mp"] = &"MP_EARNED_ARTILLERY";
	level.hardpointHints["dogs_mp"] = &"MP_EARNED_DOGS";

	level.hardpointHints["radar_mp_not_available"] = &"MP_RADAR_NOT_AVAILABLE";
	level.hardpointHints["artillery_mp_not_available"] = &"MP_ARTILLERY_NOT_AVAILABLE";
	level.hardpointHints["dogs_mp_not_available"] = &"MP_DOGS_NOT_AVAILABLE";

	level.hardpointInforms["radar_mp"] = "mp_killstreak_radar";
	level.hardpointInforms["artillery_mp"] = "mp_killstreak_jet";
	level.hardpointInforms["dogs_mp"] = "mp_killstreak_dogs";

	maps\mp\gametypes\_rank::registerScoreInfo( "hardpoint", 10 );
	
	precacheString( level.hardpointHints["radar_mp"] );	
	precacheString( level.hardpointHints["artillery_mp"] );	
	precacheString( level.hardpointHints["dogs_mp"] );	
	precacheString( level.hardpointHints["radar_mp_not_available"] );	
	precacheString( level.hardpointHints["artillery_mp_not_available"] );	
	precacheString( level.hardpointHints["dogs_mp_not_available"] );	

	precacheString( &"MP_KILLSTREAK_N" );	

	precacheLocationSelector( "map_artillery_selector" );

	level.artilleryfx = loadfx ("weapon/artillery/fx_artillery_strike_dirt_mp");

	game["dialog"]["radar_online"] = "ourradaronline";
	game["dialog"]["radar_offline"] = "";
	game["dialog"]["enemy_radar_online"] = "enemyradar";
	game["dialog"]["enemy_radar_offline"] = "";
	game["dialog"]["artillery_inbound"] = "friendlyartillery";
	game["dialog"]["enemy_artillery_inbound"] = "enemyartillery";
	game["dialog"]["dogs_inbound"] = "friendlydogs";
	game["dialog"]["enemy_dogs_inbound"] = "enemydogs";

	game["dialog"]["radar_mp"] = "radar";
	game["dialog"]["artillery_mp"] = "artillery";
	game["dialog"]["dogs_mp"] = "dogsupport";

	// time interval between usage of dogs hardpoint
	if ( getdvar( "scr_dog_hardpoint_interval" ) != "" )
		level.dogsInterval = getdvarfloat( "scr_dog_hardpoint_interval" );
	else
	{
		setdvar( "scr_dog_hardpoint_interval" , 180 );
		level.dogsInterval = 180; // time between allowed uses of dogs
	}
	
	// artillery danger area is the circle of radius artilleryDangerMaxRadius 
	// stretched by a factor of artilleryDangerOvalScale in the direction of the incoming airstrike,
	// moved by artilleryDangerForwardPush * artilleryDangerMaxRadius in the same direction.
	// use scr_artillerydebug to visualize.
	
	level.artilleryDangerMaxRadius = 750;
	level.artilleryDangerMinRadius = 300;
	level.artilleryDangerForwardPush = 1.5;
	level.artilleryDangerOvalScale = 6.0;
	level.artilleryCanonShellCount =  maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "artilleryCanonShellCount" );
	level.artilleryCanonCount = maps\mp\gametypes\_tweakables::getTweakableValue( "hardpoint", "artilleryCanonCount" );
	level.artilleryShellsInAir = 0;

	level.artilleryMapRange = level.artilleryDangerMinRadius * .3 + level.artilleryDangerMaxRadius * .7;
	
	level.artilleryDangerMaxRadiusSq = level.artilleryDangerMaxRadius * level.artilleryDangerMaxRadius;
	
	level.artilleryDangerCenters = [];

	level.radarViewTime = 30; // time radar remains active

	level.numHardpointReservedObjectives = 0;
	level.radarTimers = [];
	level.radarTimers["allies"] = getTime();
	level.radarTimers["axis"] = getTime();
}


distance2d(a,b)
{
	return distance((a[0],a[1],0), (b[0],b[1],0));
}


teamHasRadar(team)
{
	return getTeamRadar(team);
}


doAirstrike(origin, owner, team)
{
	num = 17 + randomint(3);
	
	level.artilleryInProgress = true;
	trace = bullettrace(origin, origin + (0,0,-10000), false, undefined);
	targetpos = trace["position"];
	
	yaw = getBestPlaneDirection( targetpos );
	
	if ( level.teambased )
	{
		players = level.players;
		if ( !level.hardcoreMode )
		{
			for(i = 0; i < players.size; i++)
			{
				if(isalive(players[i]) && (isdefined(players[i].pers["team"])) && (players[i].pers["team"] == team)) 
				{
					if ( pointIsInAirstrikeArea( players[i].origin, targetpos, yaw ) )
						players[i] iprintlnbold(&"MP_WAR_ARTILLERY_INBOUND_NEAR_YOUR_POSITION");
				}
			}
		}
		
		maps\mp\gametypes\_globallogic::leaderDialog( "artillery_inbound", team );
//		maps\mp\gametypes\_globallogic::leaderDialog( "enemy_artillery_inbound", level.otherTeam[team] );
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == team )
					player iprintln( &"MP_WAR_ARTILLERY_INBOUND", owner );
			}
		}
	}
	else
	{
		owner maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "artillery_inbound" );
		/*
		for ( i = 0; i < level.players.size; i++ )
		{
			if ( level.players[i] != owner && isDefined( level.players[i].team ) )
				level.players[i] maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "enemy_artillery_inbound" );
		}
		*/

		if ( !level.hardcoreMode )
		{
			if ( pointIsInAirstrikeArea( owner.origin, targetpos, yaw ) )
				owner iprintlnbold(&"MP_WAR_ARTILLERY_INBOUND_NEAR_YOUR_POSITION");
		}
	}
	
	wait 2;

	if ( !isDefined( owner ) )
	{
		level.artilleryInProgress = undefined;
		return;
	}
	
	owner notify ( "begin_artillery" );
	
	dangerCenter = spawnstruct();
	dangerCenter.origin = targetpos;
	dangerCenter.forward = anglesToForward( (0,yaw,0) );
	level.artilleryDangerCenters[ level.artilleryDangerCenters.size ] = dangerCenter;
	
	/# level thread debugArtilleryDangerCenters(); #/
	
	callAirStrike( owner, targetpos, yaw );
	
	wait 8.5;
	
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

	level.artilleryInProgress = undefined;
}


doArtillery(origin, owner, team, ownerDeathCount )
{
	level.artilleryInProgress = true;
	
	self notify( "artillery_status_change" );
	trace = bullettrace(origin, origin + (0,0,-10000), false, undefined);
	targetpos = trace["position"];
	
	// failsafe for mapholes.  This way they will at least see the artillery.
	if ( targetpos[2] < origin[2] - 9999 )
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
	artilleryiconlocation( targetpos, team, 1 );
	
	// Adjust targetpos by uncertainty radius
	uncertaintyRadiusMin = 0;
	uncertaintyRadiusMax = 10;
	targetpos = randPointRadiusAway(targetpos,RandomIntRange(uncertaintyRadiusMin,uncertaintyRadiusMax));
	
	// Find center of flak origins
	yaw = getBestFlakDirection( targetpos, team );
	direction = ( 0, yaw, 0 );
	// Adjust the distance to change the time from calling artillery to shell landing
	flakDistance = 10000;
	flakCenter = targetPos + vector_scale( anglestoforward( direction ), -1 * flakDistance );
	
	if ( level.teambased )
	{
		players = level.players;
		if ( !level.hardcoreMode )
		{
			for(i = 0; i < players.size; i++)
			{
				if(isalive(players[i]) && (isdefined(players[i].pers["team"])) && (players[i].pers["team"] == team)) 
				{
					if ( pointIsInArtilleryArea( players[i].origin, targetpos ) )
						players[i] iprintlnbold(&"MP_WAR_ARTILLERY_INBOUND_NEAR_YOUR_POSITION");
				}
			}
		}
		
		maps\mp\gametypes\_globallogic::leaderDialog( "artillery_inbound", team );
		maps\mp\gametypes\_globallogic::leaderDialog( "enemy_artillery_inbound", level.otherTeam[team] );
		thread maps\mp\gametypes\_battlechatter_mp::onKillstreakUsed( "artillery", level.otherTeam[team] );
		//Collin's Air Raid siren
		thread air_raid_audio();
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == team )
					player iprintln( &"MP_WAR_ARTILLERY_INBOUND", owner );
			}
		}
	}
	else
	{
		owner maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "artillery_inbound" );
		/*
		for ( i = 0; i < level.players.size; i++ )
		{
			if ( level.players[i] != owner && isDefined( level.players[i].team ) )
				level.players[i] maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "enemy_artillery_inbound" );
		}
		*/

		if ( !level.hardcoreMode )
		{
			if ( pointIsInArtilleryArea( owner.origin, targetpos ) )
				owner iprintlnbold(&"MP_WAR_ARTILLERY_INBOUND_NEAR_YOUR_POSITION");
		}
	}
	
//	wait 2;

	if ( !isDefined( owner ) )
	{
		level.artilleryInProgress = undefined;
		level.artilleryShellsInAir = undefined;
		
		self notify( "artillery_status_change" );
		return;
	}
	
	owner notify ( "begin_artillery" );
	
	dangerCenter = spawnstruct();
	dangerCenter.origin = targetpos;
	dangerCenter.forward = (0,0,0);
	level.artilleryDangerCenters[ level.artilleryDangerCenters.size ] = dangerCenter;
	danger_influencer_id = maps\mp\gametypes\_spawning::create_artillery_influencers( targetpos, level.artilleryDangerMaxRadius * 1.25);
	
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
	self notify( "artillery_status_change" );
}

/#
debugArtilleryDangerCenters()
{
	level notify("debugArtilleryDangerCenters_thread");
	level endon("debugArtilleryDangerCenters_thread");
	
	if ( getdvar("scr_artillerydebug") != "1" && getdvar("scr_spawnpointdebug") == "0" )
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

getSingleArtilleryDanger( point, origin, forward )
{
	center = origin + level.artilleryDangerForwardPush * level.artilleryDangerMaxRadius * forward;
	
	diff = point - center;
	diff = (diff[0], diff[1], 0);
	
	forwardPart = vectorDot( diff, forward ) * forward;
	perpendicularPart = diff - forwardPart;
	
	circlePos = perpendicularPart + forwardPart / level.artilleryDangerOvalScale;
	
//	/#
//	if ( getdvar("scr_artillerydebug") == "1" )
//	{
//		thread airstrikeLine( center, center + perpendicularPart, (1,1,1), 30 );
//		thread airstrikeLine( center + perpendicularPart, center + circlePos, (1,1,1), 30 );
//		thread airstrikeLine( center + circlePos, point, (.5,.5,.5), 30 );
//	}
//	#/
	
	distsq = lengthSquared( circlePos );
	
	if ( distsq > level.artilleryDangerMaxRadius * level.artilleryDangerMaxRadius )
		return 0;
	
	if ( distsq < level.artilleryDangerMinRadius * level.artilleryDangerMinRadius )
		return 1;
	
	dist = sqrt( distsq );
	distFrac = (dist - level.artilleryDangerMinRadius) / (level.artilleryDangerMaxRadius - level.artilleryDangerMinRadius);
	
	assertEx( distFrac >= 0 && distFrac <= 1, distFrac );
	
	return 1 - distFrac;
}


pointIsInAirstrikeArea( point, targetpos, yaw )
{
	return distance2d( point, targetpos ) <= level.artilleryDangerMaxRadius * 1.25;
	// TODO
	//return getSingleArtilleryDanger( point, targetpos, yaw ) > 0;
}


pointIsInArtilleryArea( point, targetpos )
{
	return distance2d( point, targetpos ) <= level.artilleryDangerMaxRadius * 1.25;
}


losRadiusDamage(pos, radius, max, min, owner, eInflictor)
{
	ents = maps\mp\gametypes\_weapons::getDamageableEnts(pos, radius, true);

	for (i = 0; i < ents.size; i++)
	{
		if (ents[i].entity == self)
			continue;
		
		dist = distance(pos, ents[i].damageCenter);
		
		if ( ents[i].isPlayer )
		{
			// check if there is a path to this entity 130 units above his feet. if not, they're probably indoors
			indoors = !maps\mp\gametypes\_weapons::weaponDamageTracePassed( ents[i].entity.origin, ents[i].entity.origin + (0,0,130), 0, undefined );
			if ( !indoors )
			{
				indoors = !maps\mp\gametypes\_weapons::weaponDamageTracePassed( ents[i].entity.origin + (0,0,130), pos + (0,0,130 - 16), 0, undefined );
				if ( indoors )
				{
					// give them a distance advantage for being indoors.
					dist *= 4;
					if ( dist > radius )
						continue;
				}
			}
		}

		ents[i].damage = int(max + (min-max)*dist/radius);
		ents[i].pos = pos;
		ents[i].damageOwner = owner;
		ents[i].eInflictor = eInflictor;
		level.artilleryDamagedEnts[level.artilleryDamagedEntsCount] = ents[i];
		level.artilleryDamagedEntsCount++;
	}
	
	thread artilleryDamageEntsThread();
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
			
		if ( !ent.isPlayer || isAlive( ent.entity ) )
		{
			ent maps\mp\gametypes\_weapons::damageEnt(
				ent.eInflictor, // eInflictor = the entity that causes the damage (e.g. a shoebox)
				ent.damageOwner, // eAttacker = the player that is attacking
				ent.damage, // iDamage = the amount of damage to do
				"MOD_PROJECTILE_SPLASH", // sMeansOfDeath = string specifying the method of death (e.g. "MOD_PROJECTILE_SPLASH")
				"artillery_mp", // sWeapon = string specifying the weapon used (e.g. "mine_shoebox_mp")
				ent.pos, // damagepos = the position damage is coming from
				vectornormalize(ent.damageCenter - ent.pos) // damagedir = the direction damage is moving in
			);			

			level.artilleryDamagedEnts[level.artilleryDamagedEntsIndex] = undefined;
			
			if ( ent.isPlayer )
				wait ( 0.05 );
		}
		else
		{
			level.artilleryDamagedEnts[level.artilleryDamagedEntsIndex] = undefined;
		}
	}
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
//				if( owner.pers["team"] != players[i].pers["team"] || owner == players[i] )
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


artilleryShellshock(type, duration)
{
	if (isdefined(self.beingArtilleryShellshocked) && self.beingArtilleryShellshocked)
		return;
	self.beingArtilleryShellshocked = true;
	
	self shellshock(type, duration);
	wait(duration + 1);
	
	self.beingArtilleryShellshocked = false;
}


/#
airstrikeLine( start, end, color, duration )
{
	self endon("death");
	frames = duration * 20;
	for ( i = 0; i < frames; i++ )
	{
		line(start,end,color);
		wait .05;
	}
}


traceBomb()
{
	self endon("death");
	prevpos = self.origin;
	while(1)
	{
		thread airstrikeLine( prevpos, self.origin, (.5,1,0), 20 );
		prevpos = self.origin;
		wait .2;
	}
}
#/


doPlaneStrike( owner, requiredDeathCount, bombsite, startPoint, endPoint, bombTime, flyTime, direction )
{
	// plane spawning randomness = up to 125 units, biased towards 0
	// radius of bomb damage is 512

	if ( !isDefined( owner ) ) 
		return;
	
	startPathRandomness = 100;
	endPathRandomness = 150;
	
	pathStart = startPoint + ( (randomfloat(2) - 1)*startPathRandomness, (randomfloat(2) - 1)*startPathRandomness, 0 );
	pathEnd   = endPoint   + ( (randomfloat(2) - 1)*endPathRandomness  , (randomfloat(2) - 1)*endPathRandomness  , 0 );
	
	// Spawn the planes
	plane = spawnplane( owner, "script_model", pathStart );
	plane setModel( "vehicle_jap_airplane_zero_fly_player" );
	plane.angles = direction;
	
	forward = anglesToForward( direction );
	
	plane thread playPlaneFx();
	
	plane moveTo( pathEnd, flyTime, 0, 0 );
	
	/#
	if ( getdvar("scr_artillerydebug") == "1" )
		thread airstrikeLine( pathStart, pathEnd, (1,1,1), 10 );
	#/
	
	thread callStrike_planeSound( plane, bombsite );
	
	thread callStrike_bombEffect( plane, pathEnd, flyTime, bombTime - 1.0, owner, requiredDeathCount );
	
	// Delete the plane after its flyby
	wait flyTime;
	plane notify( "delete" );
	plane delete();
}


doArtilleryStrike( owner, requiredDeathCount, bombsite, yaw, distance )
{
	if ( !isDefined( owner ) ) 
		return;
		
	// Find firing position and play artillery firing sound
	fireAngle = ( 0, yaw, 0 );
	firePos = bombsite + vector_scale( anglestoforward( fireAngle ), -1 * distance );
//	thread playSoundinSpace( "artillery_launch", firePos );
	
//	firePos = (0,0,100);
//	distance = 200;
	
	// Pick angle to fire at / incoming angle (negative is up)
	pitch = getdvarfloat("scr_artilleryAngle");
	if( pitch != 0 )
	{
		pitch *= -1;
	}
	else
	{
		pitch = -60;
	}

	pitch += randomintrange( -3, 3 );
	
	fireAngle += (pitch,0,0);

	// Find the firing velocity needed to hit the target
	//  distance = ( (velocity ^ 2) * sin( 2 * angle ) ) / gravity
	//	velocity = sqrt( (gravity*distance) / sin( 2 * angle ) )
	gravity = GetDvarInt( "g_gravity" );
	velocity = sqrt( (gravity * distance) / sin( -2 * pitch ) );

//	thread playsoundinspace ("artillery_whistle", bombsite );
	thread callStrike_ArtilleryBombEffect( firePos, fireAngle, velocity, owner, requiredDeathCount, distance );
}


callStrike_bombEffect( plane, pathEnd, flyTime, launchTime, owner, requiredDeathCount )
{
	wait ( launchTime );
	
	plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	planedir = anglesToForward( plane.angles );
	
	bomb = spawnbomb( plane.origin, plane.angles );
	bomb moveGravity( vector_scale( anglestoforward( plane.angles ), 7000/1.5 ), 3.0 );
	
	bomb.ownerRequiredDeathCount = requiredDeathCount;
	
	killCamEnt = spawn( "script_model", plane.origin + (0,0,100) - planedir * 200 );
	bomb.killCamEnt = killCamEnt;
	killCamEnt.startTime = gettime();
	killCamEnt thread deleteAfterTime( 15.0 );
	killCamEnt.angles = planedir;
	killCamEnt moveTo( pathEnd + (0,0,100), flyTime, 0, 0 );
	
	/#
	if ( getdvar("scr_artillerydebug") == "1" )
		 bomb thread traceBomb();
	#/
	
	wait .4;
	killCamEnt moveTo( killCamEnt.origin + planedir * 4000, 1, 0, 0 );
	
	wait .45;
	killCamEnt moveTo( killCamEnt.origin + (planedir + (0,0,-.2)) * 3500, 2, 0, 0 );
	
	wait ( 0.15 );

	newBomb = spawn( "script_model", bomb.origin );
 	newBomb setModel( "tag_origin" );
  	newBomb.origin = bomb.origin;
  	newBomb.angles = bomb.angles;

	bomb setModel( "tag_origin" );
	wait (0.10);  // wait two server frames before playing fx
	
	bombOrigin = newBomb.origin;
	bombAngles = newBomb.angles;
	playfxontag( level.airstrikefx, newBomb, "tag_origin" );
	
	wait .05;
	killCamEnt moveTo( killCamEnt.origin + (planedir + (0,0,-.25)) * 2500, 2, 0, 0 );
	
	wait .25;
	killCamEnt moveTo( killCamEnt.origin + (planedir + (0,0,-.35)) * 2000, 2, 0, 0 );
	
	wait .2;
	killCamEnt moveTo( killCamEnt.origin + (planedir + (0,0,-.45)) * 1500, 2, 0, 0 );

	
	repeat = 12;
	minAngles = 5;
	maxAngles = 55;
	angleDiff = (maxAngles - minAngles) / repeat;
	
	hitpos = (0,0,0);
	
	for( i = 0; i < repeat; i++ )
	{
		traceDir = anglesToForward( bombAngles + (maxAngles-(angleDiff * i),randomInt( 10 )-5,0) );
		traceEnd = bombOrigin + vector_scale( traceDir, 10000 );
		trace = bulletTrace( bombOrigin, traceEnd, false, undefined );
		
		traceHit = trace["position"];
		hitpos += traceHit;
		
		/#
		if ( getdvar("scr_artillerydebug") == "1" )
			thread airstrikeLine( bombOrigin, traceHit, (1,0,0), 20 );
		#/
		
		thread losRadiusDamage( traceHit + (0,0,16), 512, 200, 30, owner, bomb ); // targetpos, radius, maxdamage, mindamage, player causing damage, entity that player used to cause damage
	
		if ( i%3 == 0 )
		{
			thread playsoundinspace( "artillery_impact", traceHit );
			playRumbleOnPosition( "artillery_rumble", traceHit );
			earthquake( 0.7, 0.75, traceHit, 1000 );
		}
		
		wait ( 0.05 );
	}
	
	hitpos = hitpos / repeat + (0,0,128);
	killCamEnt moveto( bomb.killCamEnt.origin * .35 + hitpos * .65, 1.5, 0, .5 );
	
	//wait ( 5.0 );
	wait ( 10.0 );
	newBomb delete();
	bomb delete();
}


callStrike_artilleryBombEffect( spawnPoint, bombdir, velocity, owner, requiredDeathCount, distance )
{

 	bomb_velocity = vectorscale(anglestoforward(bombdir), velocity);
	bomb = owner launchbomb( "artillery_mp", spawnPoint, bomb_velocity );
	
	bomb.requiredDeathCount = requiredDeathCount;
	
	
	// TrajectoRy: time = distance / ( velocity * cos( angle ) )
	airTime = distance / ( velocity * cos( bombdir[0] ) );

	bomb thread referenceCounter();
	
	bombsite = spawnPoint + vector_scale( anglestoforward( (0,bombdir[1],0) ), distance );
	
	/#
	if ( getdvar("scr_artillerydebug") == "1" )
		 bomb thread traceBomb();
	#/
}

referenceCounter()
{
	self waittill( "death" );
	
	level.artilleryShellsInAir = level.artilleryShellsInAir - 1;
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
			playRumbleOnPosition( "artillery_rumble", position );
			radiusArtilleryShellshock( position, radius * 1.1, 3, 1.5, self );
			earthquake( 0.7, 0.75, position, 1000 );
		}
	}
}

spawnbomb( origin, angles )
{
	bomb = spawn( "script_model", origin );
	bomb.angles = angles;
	bomb setModel( "aircraft_bomb" ); // TODO: Get artillery model

	return bomb;
}

deleteAfterTime( time )
{
	self endon ( "death" );
	wait ( time );
	
	self delete();
}


drawLine( start, end, timeSlice, color )
{
	drawTime = int(timeSlice * 20);
	for( time = 0; time < drawTime; time++ )
	{
		line( start, end, (1,0,0),false, 1 );
		wait ( 0.05 );
	}
}


playPlaneFx()
{
	self endon ( "death" );

	//playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_right" );
	//playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_left" );
	//playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );
	//playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
}


getBestPlaneDirection( hitpos )
{
	if ( getdvarint("scr_airstrikebestangle") != 1 )
	{
		return randomfloat( 360 );
	}
	
	checkPitch = -25;
	
	numChecks = 15;
	
	startpos = hitpos + (0,0,64);
	
	bestangle = randomfloat( 360 );
	bestanglefrac = 0;
	
	fullTraceResults = [];
	
	for ( i = 0; i < numChecks; i++ )
	{
		yaw = ((i * 1.0 + randomfloat(1)) / numChecks) * 360.0;
		angle = (checkPitch, yaw + 180, 0);
		dir = anglesToForward( angle );
		
		endpos = startpos + dir * 1500;
		
		trace = bullettrace( startpos, endpos, false, undefined );
		
		/#
		if ( getdvar("scr_artillerydebug") == "1" )
			thread airstrikeLine( startpos, trace["position"], (1,1,0), 20 );
		#/
		
		if ( trace["fraction"] > bestanglefrac )
		{
			bestanglefrac = trace["fraction"];
			bestangle = yaw;
			
			if ( trace["fraction"] >= 1 )
				fullTraceResults[ fullTraceResults.size ] = yaw;
		}
		
		if ( i % 3 == 0 )
			wait .05;
	}
	
	if ( fullTraceResults.size > 0 )
		return fullTraceResults[ randomint( fullTraceResults.size ) ];
	
	return bestangle;
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

get_origin_array( from_array )
{
	origins = [];
	
	for ( i = 0; i < from_array.size; i++ )
	{
		origins[origins.size] = from_array[i].origin;
	}
	return origins;
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


callAirStrike( owner, coord, yaw )
{	
	// Get starting and ending point for the plane
	direction = ( 0, yaw, 0 );
	planeHalfDistance = 24000;
	planeBombExplodeDistance = 1500;
	planeFlyHeight = 850;
	planeFlySpeed = 7000;

	if ( isdefined( level.airstrikeHeightScale ) )
	{
		planeFlyHeight *= level.airstrikeHeightScale;
	}
	
	startPoint = coord + vector_scale( anglestoforward( direction ), -1 * planeHalfDistance );
	startPoint += ( 0, 0, planeFlyHeight );

	endPoint = coord + vector_scale( anglestoforward( direction ), planeHalfDistance );
	endPoint += ( 0, 0, planeFlyHeight );
	
	// Make the plane fly by
	d = length( startPoint - endPoint );
	flyTime = ( d / planeFlySpeed );
	
	// bomb explodes planeBombExplodeDistance after the plane passes the center
	d = abs( d/2 + planeBombExplodeDistance  );
	bombTime = ( d / planeFlySpeed );
	
	assert( flyTime > bombTime );
	
	owner endon("disconnect");
	
	requiredDeathCount = owner.deathCount;
	
	level.artilleryDamagedEnts = [];
	level.artilleryDamagedEntsCount = 0;
	level.artilleryDamagedEntsIndex = 0;
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(500)), endPoint+(0,0,randomInt(500)), bombTime, flyTime, direction );
	wait randomfloatrange( 1.5, 2.5 );
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction );
	wait randomfloatrange( 1.5, 2.5 );
	level thread doPlaneStrike( owner, requiredDeathCount, coord, startPoint+(0,0,randomInt(200)), endPoint+(0,0,randomInt(200)), bombTime, flyTime, direction );
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
	maxInitialDelay = 3;
	minDistanceRandom = -100;
	maxDistanceRandom = 100;
	minYawRandom = 1;
	maxYawRandom = 3;	
	thread startArtilleryCanon( owner, coord, yaw - RandomIntRange( minYawRandom, maxYawRandom ) , distance - RandomFloatRange( minDistanceRandom, maxDistanceRandom ), RandomFloatRange( minInitialDelay, maxInitialDelay ),ownerDeathCount);
	thread startArtilleryCanon( owner, coord, yaw, distance, RandomFloatRange( minInitialDelay, maxInitialDelay ),ownerDeathCount);
	thread startArtilleryCanon( owner, coord, yaw + RandomIntRange( minYawRandom, maxYawRandom ) , distance - RandomFloatRange( minDistanceRandom, maxDistanceRandom ), RandomFloatRange( minInitialDelay, maxInitialDelay ),ownerDeathCount);
}

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


callStrike_bomb( bombTime, coord, repeat, owner )
{
	accuracyRadius = 512;
	
	for( i = 0; i < repeat; i++ )
	{
		randVec = ( 0, randomint( 360 ), 0 );
		bombPoint = coord + vector_scale( anglestoforward( randVec ), accuracyRadius );
		
		wait bombTime;
		
		thread playsoundinspace( "artillery_impact", bombPoint );
		radiusArtilleryShellshock( bombPoint, 512, 8, 4);
		losRadiusDamage( bombPoint + (0,0,16), 768, 300, 50, owner); // targetpos, radius, maxdamage, mindamage, player causing damage
	}
}


randPointRadiusAway( origin, accuracyRadius )
{
	randVec = ( 0, randomint( 360 ), 0 );
	newPoint = origin + vector_scale( anglestoforward( randVec ), accuracyRadius );
	return newPoint;
}


flat_origin(org)
{
	rorg = (org[0],org[1],0);
	return rorg;

}


flat_angle(angle)
{
	rangle = (0,angle[1],0);
	return rangle;
}


targetisclose(other, target)
{
	infront = targetisinfront(other, target);
	if(infront)
		dir = 1;
	else
		dir = -1;
	a = flat_origin(other.origin);
	b = a+vector_scale(anglestoforward(flat_angle(other.angles)), (dir*100000));
	point = pointOnSegmentNearestToPoint(a,b, target);
	dist = distance(a,point);
	if (dist < 3000)
		return true;
	else
		return false;
}

targetisinfront(other, target)
{
	forwardvec = anglestoforward(flat_angle(other.angles));
	normalvec = vectorNormalize(flat_origin(target)-other.origin);
	dot = vectordot(forwardvec,normalvec); 
	if(dot > 0)
		return true;
	else
		return false;
}


delete_on_death (ent)
{
	ent endon ("death");
	self waittill ("death");
	if (isdefined (ent))
		ent delete();
}


play_loop_sound_on_entity(alias, offset)
{
	org = spawn ("script_origin",(0,0,0));
	org endon ("death");
	thread delete_on_death (org);
	if (isdefined (offset))
	{
		org.origin = self.origin + offset;
		org.angles = self.angles;
		org linkto (self);
	}
	else
	{
		org.origin = self.origin;
		org.angles = self.angles;
		org linkto (self);
	}
//	org endon ("death");
	org playloopsound (alias);
//	println ("playing loop sound ", alias," on entity at origin ", self.origin, " at ORIGIN ", org.origin);
	self waittill ("stop sound" + alias);
//	org stoploopsound (alias);
	org delete();
}


callStrike_planeSound( plane, bombsite )
{
	plane endon("death");
	
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	while( !targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_close_loop" );
	while( targetisinfront( plane, bombsite ) )
		wait .05;
	wait .5;
	//plane thread play_sound_in_space( "veh_mig29_sonic_boom" );
	while( targetisclose( plane, bombsite ) )
		wait .05;
	plane notify ( "stop sound" + "veh_mig29_close_loop" );
	plane thread play_loop_sound_on_entity( "veh_mig29_dist_loop" );
	plane waittill( "delete" );
	plane notify ( "stop sound" + "veh_mig29_dist_loop" );
}


playSoundinSpace (alias, origin, master)
{
	org = spawn ("script_origin",(0,0,1));
	if (!isdefined (origin))
		origin = self.origin;
	org.origin = origin;
	if (isdefined(master) && master)
		org playsoundasmaster (alias);
	else
		org playsound (alias);
	wait ( 10.0 );
	org delete();
}


giveHardpointItemForStreak()
{
	streak = self.cur_kill_streak;
	
	if ( streak < 3 )
		return;

	if ( !getDvarInt( "scr_game_forceradar" ) )
	{
		if ( streak == 3 )
			self giveHardpoint( "radar_mp", streak );
		else if ( streak == 5 )
			self giveHardpoint( "artillery_mp", streak );
		else if ( streak == 7 )
			self giveHardpoint( "dogs_mp", streak );
//		else if ( streak == 10 )
//			self giveHardpoint( "kamikaze_mp", streak );
		else if ( streak >= 10 )
		{
			if ( (streak % 5) == 0 )
				self streakNotify( streak );
		}
	}
	else
	{
		if ( streak == 3 )
		{
			self giveHardpoint( "artillery_mp", streak );
		}
		else if ( streak == 5 )
		{
			self giveHardpoint( "dogs_mp", streak );
		}
//		else if ( streak == 15 )
//		{
//			self giveHardpoint( "kamikaze_mp", streak );
//		}
		else if ( streak >= 10 )
		{
			if ( (streak % 5) == 0 )
				self streakNotify( streak );
		}
	}
}


streakNotify( streakVal )
{
	self endon("disconnect");

	// wait until any challenges have been processed
	self waittill( "playerKilledChallengesProcessed" );
	wait .05;
	
	notifyData = spawnStruct();
	notifyData.titleLabel = &"MP_KILLSTREAK_N";
	notifyData.titleText = streakVal;
	
	self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
	
	iprintln( &"RANK_KILL_STREAK_N", self, streakVal );
}


giveHardpoint( hardpointType, streak )
{
	self endon("disconnect");
	level endon( "game_ended" );
	
	had_to_delay = false;
	
	if ( isDefined( self.selectingLocation ) && hasHardpointItemEquipped( ) )
	{
		self waittill( "stop_location_selection" );
		had_to_delay = true;
	}
	
	if ( self maps\mp\gametypes\_hardpoints::giveHardpointItem( hardpointType ) )
	{
		self thread hardpointNotify( hardpointType, streak, had_to_delay );
	}
}


hardpointNotify( hardpointType, streakVal, challenge_wait )
{
	self endon("disconnect");
	
	if ( !isdefined(challenge_wait) || challenge_wait == false )
	{
		// wait until any challenges have been processed
		self waittill( "playerKilledChallengesProcessed" );
	}
	
	wait .05;
	
	notifyData = spawnStruct();
	notifyData.titleLabel = &"MP_KILLSTREAK_N";
	notifyData.titleText = streakVal;
	notifyData.notifyText = level.hardpointHints[hardpointType];
	notifyData.sound = level.hardpointInforms[hardpointType];
	notifyData.leaderSound = hardpointType;
	
	self maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
}

hasHardpointItemEquipped( )
{
	currentWeapon = self getCurrentWeapon();

	if ( currentWeapon == "radar_mp" || currentWeapon == "artillery_mp" || currentWeapon == "dogs_mp" )
		return true;
		
	return false;
}

giveHardpointItem( hardpointType, do_not_update_death_count )
{
	if ( level.gameEnded )
		return;
		
	if ( getdvar( "scr_game_hardpoints" ) != "" && getdvarint( "scr_game_hardpoints" ) == 0 )
		return false;
		
	if ( isDefined( self.selectingLocation ) && hasHardpointItemEquipped( ) )
		return false;

	if ( !isDefined( level.hardpointItems[hardpointType] ) )
		return false;

//	if ( (!isDefined( level.heli_paths ) || !level.heli_paths.size) && hardpointType == "helicopter_mp" )
//		return false;

	if ( isDefined( self.pers["hardPointItem"] ) )
	{
		if ( level.hardpointItems[hardpointType] < level.hardpointItems[self.pers["hardPointItem"]] )
			return false;
	}
	
	self giveWeapon( hardpointType );
	self giveMaxAmmo( hardpointType );
	self setActionSlot( 4, "weapon", hardpointType );
	self.pers["hardPointItem"] = hardpointType;	
	
	if ( !isdefined( do_not_update_death_count ) || do_not_update_death_count != false )
	{
		self.pers["hardPointItemDeathCount"+hardpointType] = self.deathCount;
	}	
	
	return true;
}

// for debug
takeHardpointItem( hardpointType )
{
	if ( level.gameEnded )
		return;
		
	if ( getdvar( "scr_game_hardpoints" ) != "" && getdvarint( "scr_game_hardpoints" ) == 0 )
		return false;
		
	if ( isDefined( self.selectingLocation ) )
		return false;

	if ( !isDefined( level.hardpointItems[hardpointType] ) )
		return false;

//	if ( (!isDefined( level.heli_paths ) || !level.heli_paths.size) && hardpointType == "helicopter_mp" )
//		return false;

	if ( isDefined( self.pers["hardPointItem"] ) )
	{
		if ( self.pers["hardPointItem"] != hardpointType )
			return false;
	}
	
	self takeWeapon( hardpointType );
	self setActionSlot( 4, "" );
	self.pers["hardPointItem"] = "";	
	self.pers["hardPointItemDeathCount"+hardpointType] = 0;	
	
	return true;
}

upgradeHardpointItem()
{
	if ( isDefined( self.selectingLocation ) )
		return;
	
	if ( !level.hardpointItems.size )
		return;

	hardpointType = getNextHardpointItem( self.pers["hardPointItem"] );

	if ( isDefined( self.pers["hardPointItem"] ) && level.hardpointItems[hardpointType] < level.hardpointItems[self.pers["hardPointItem"]] )
		return;
	
	self giveWeapon( hardpointType );
	self giveMaxAmmo( hardpointType );
	self setActionSlot( 4, "weapon", hardpointType );
	self.pers["hardPointItem"] = hardpointType;
	self.pers["hardPointItemDeathCount"+hardpointType] = self.deathCount;
	
	self thread maps\mp\gametypes\_hud_message::hintMessage( level.hardpointHints[hardpointType] );
}


getNextHardpointItem( hardpointType )
{
	hardpoints = getArrayKeys( level.hardpointItems );
	
	if ( !isDefined( hardpointType ) )
		return hardpoints[hardpoints.size-1];
	
	for ( index = hardpoints.size-1; index >= 0; index-- )
	{
		if ( hardpoints[index] != hardpointType )
			continue;
			
		if ( index != 0 )
			return hardpoints[index-1];
		else
			return hardpoints[index];
	}
}

giveOwnedHardpointItem()
{
	if ( isDefined( self.pers["hardPointItem"] ) )
		self giveHardpointItem( self.pers["hardPointItem"], false );
}

hardpointItemWaiter()
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon ( "death_or_disconnect" );
	lastWeapon = self getCurrentWeapon();
	
	self giveOwnedHardpointItem();
	
	for ( ;; )
	{
		self waittill( "weapon_change" );
		
		currentWeapon = self getCurrentWeapon();

		switch( currentWeapon )
		{
			case "radar_mp":
			case "artillery_mp":
			case "dogs_mp":
//			case "kamikaze_mp":
				if ( self triggerHardpoint( currentWeapon ) )
				{	
					logString( "hardpoint: " + currentWeapon );
					
					self thread maps\mp\gametypes\_missions::useHardpoint( self.pers["hardPointItem"] );
					self thread [[level.onXPEvent]]( "hardpoint" );
					
					self takeWeapon( currentWeapon );
					self setActionSlot( 4, "" );
//					self.pers["hardPointItemDeathCount"+self.pers["hardPointItem"]] = 0;
					self.pers["hardPointItem"] = undefined;
				}
				
				if ( lastWeapon != "none" )
					self switchToWeapon( lastWeapon );
				break;
			case "none":
				break;	
			default:
				lastWeapon = self getCurrentWeapon();
				break;
		}
	}
}


// Will select the appropriate hud map icon to display for artillery
artilleryWaiter()
{
	//self endon ( "death" );
	//self endon ( "disconnect" );
	self endon ( "death_or_disconnect" );

	while(1)
	{
		self waittill( "artillery_status_change" );
		// if artilleryinProgess is either active or undefined, turn both icons invisible when undefined
		if( !isDefined(level.artilleryInProgress) )
		{
			pos = ( 0, 0, 0 );
			artilleryiconlocation( pos, 0, 0 );
		}
	}
}

triggerHardPoint( hardpointType )
{
	if ( hardpointType == "radar_mp" )
	{
		self thread useRadarItem();

		self.pers["uav_used"]++;
	}
	else if ( hardpointType == "artillery_mp" )
	{
		if ( isDefined( level.artilleryInProgress ) )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;
		}
			
		result = self selectArtilleryLocation();
		
		if ( !isDefined( result ) || !result )
			return false;

		self.pers["artillery_used"]++;
	}
	else if ( hardpointType == "dogs_mp" )
	{
		if ( isDefined( level.dogs ) )
		{
			self iPrintLnBold( level.hardpointHints[hardpointType+"_not_available"] );
			return false;
		}
		
		team = self.pers["team"];
		otherTeam = level.otherTeam[team];
		
		if ( level.teambased )
		{
			maps\mp\gametypes\_globallogic::leaderDialog( "dogs_inbound", team );
			maps\mp\gametypes\_globallogic::leaderDialog( "enemy_dogs_inbound", otherTeam );
			thread maps\mp\gametypes\_battlechatter_mp::onKillstreakUsed( "dogs", otherTeam );
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				playerteam = player.pers["team"];
				if ( isdefined( playerteam ) )
				{
					if ( playerteam == team )
						player iprintln( &"MP_DOGS_INBOUND", self );
				}
			}
		}
		else
		{
			self maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "dogs_inbound" );
			selfarray = [];
			selfarray[0] = self;
			maps\mp\gametypes\_globallogic::leaderDialog( "enemy_dogs_inbound", undefined, undefined, selfarray );
		}
		
		if ( maps\mp\gametypes\_tweakables::getTweakableValue( "team", "allowHardpointStreakAfterDeath" ) )
		{
			ownerDeathCount = self.deathCount;
		}
		else
		{
			ownerDeathCount = self.pers["hardPointItemDeathCount" + hardpointType];
		}
		
		self thread maps\mp\_dogs::dog_manager_spawn_dogs( team, otherTeam, ownerDeathCount );

		self.pers["dogs_used"]++;
	}

	self notify( "hardpoint_used", hardpointType );
	

	return true;
}


RadarAcquiredPrintAndSound( team, otherteam, callingPlayer, numseconds )
{
	soundFriendly = game["voice"][team]      + game["dialog"]["radar_online"];
	soundEnemy    = game["voice"][otherteam] + game["dialog"]["enemy_radar_online"];
	
	if ( level.splitscreen )
	{
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == team )
					player iprintln( &"MP_WAR_RADAR_ACQUIRED", callingPlayer, numseconds );
				else if ( playerteam == otherteam )
					player iprintln( &"MP_WAR_RADAR_ACQUIRED_ENEMY", numseconds  );
			}
		}
		assert( level.splitscreen );
	
		level.players[0] playLocalSound( soundFriendly );
	}
	else
	{
		//Reduce spam of Radar calls, but ensure the player that called in allways hears it
		if( getTime() - level.radarTimers[team] > 30000 )
		{
			maps\mp\gametypes\_globallogic::leaderDialog( "radar_online", team );
			maps\mp\gametypes\_globallogic::leaderDialog( "enemy_radar_online", otherTeam );
			level.radarTimers[team] = getTime();
		}
		else
		{
			callingPlayer maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "radar_online", team );
		}
		thread maps\mp\gametypes\_battlechatter_mp::onKillstreakUsed( "recon", otherTeam );
		for ( i = 0; i < level.players.size; i++ )
		{
			player = level.players[i];
			playerteam = player.pers["team"];
			if ( isdefined( playerteam ) )
			{
				if ( playerteam == team )
					player iprintln( &"MP_WAR_RADAR_ACQUIRED", callingPlayer, numseconds );
				else if ( playerteam == otherteam )
					player iprintln( &"MP_WAR_RADAR_ACQUIRED_ENEMY", numseconds  );
			}
		}
	}
}


useRadarItem()
{
	team = self.pers["team"];
	otherteam = "axis";
	if (team == "axis")
		otherteam = "allies";
	
	assert( isdefined( level.players ) );
	
	if ( level.teambased )
	{
		RadarAcquiredPrintAndSound( team, otherteam, self, level.radarViewTime );

		level notify( "radar_timer_kill_" + team );
		self thread useTeamRadar( team, otherteam );
	}
	else
	{
		self maps\mp\gametypes\_globallogic::leaderDialogOnPlayer( "radar_online" );
		self iprintln( &"MP_WAR_RADAR_ACQUIRED", self, level.radarViewTime );
		
		self notify("radar_timer_kill");
		self thread usePlayerRadar();
	}
}


useTeamRadar( team, otherteam )
{
	level endon("game_ended");
	level endon("radar_timer_kill_" + team);
	
	setTeamRadarWrapper( team, true );
	
	wait level.radarViewTime;
	
	setTeamRadarWrapper( team, false );
	
	printAndSoundOnEveryone( team, otherteam, &"MP_WAR_RADAR_EXPIRED", &"MP_WAR_RADAR_EXPIRED_ENEMY", undefined, undefined, "" );
}


usePlayerRadar( team, otherteam )
{
	level endon("game_ended");
	self endon("radar_timer_kill");
	self endon("disconnect");
	
	self.hasRadar = true;
	self setClientDvar( "ui_radar_client", 1 );
	
	wait level.radarViewTime;
	
	self.hasRadar = false;
	self setClientDvar( "ui_radar_client", 0 );
	
	self iprintln( &"MP_WAR_RADAR_EXPIRED" );
}


setTeamRadarWrapper( team, value )
{
	setTeamRadar( team, value );
	
	dvarval = 0;
	if ( value )
		dvarval = 1;
	setDvar( "ui_radar_" + team, dvarval );
	
	level notify( "radar_status_change", team );
}

selectArtilleryLocation()
{
	self beginLocationSelection( "map_artillery_selector", level.artilleryDangerMaxRadius * 1.2 );
	self.selectingLocation = true;

	self thread endSelectionOn( "cancel_location" );
	self thread endSelectionOn( "death" );
	self thread endSelectionOn( "disconnect" );
	self thread endSelectionOn( "used" );
	self thread endSelectionOnGameEnd();

	self endon( "stop_location_selection" );
	self waittill( "confirm_location", location );

	if ( isDefined( level.artilleryInProgress ) )
	{
		self iPrintLnBold( level.hardpointHints["artillery_mp_not_available"] );
		self thread stopHardpointLocationSelection( false );
		return false;
	}

	self thread finishHardpointLocationUsage( location, ::useArtillery );
	return true;
}


finishHardpointLocationUsage( location, usedCallback )
{
	self notify( "used" );
	wait ( 0.05 );
	self thread stopHardpointLocationSelection( false );
	self thread [[usedCallback]]( location );
	return true;
}


endSelectionOn( waitfor )
{
	self endon( "stop_location_selection" );
	
	self waittill( waitfor );

	self thread stopHardpointLocationSelection( (waitfor == "disconnect") );
}


endSelectionOnGameEnd()
{
	self endon( "stop_location_selection" );
	
	level waittill( "game_ended" );
	
	self thread stopHardpointLocationSelection( false );
}


stopHardpointLocationSelection( disconnected )
{
	if ( !disconnected )
	{
		self endLocationSelection();
		self.selectingLocation = undefined;
	}
	self notify( "stop_location_selection" );
}

useArtillery( pos )
{
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
	
	thread doArtillery( pos, self, self.pers["team"], ownerDeathCount );
	//thread doAirstrike( pos, self, self.pers["team"] );
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
