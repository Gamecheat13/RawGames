#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;


//////////////////////////////////////////////
//
//	Initialization



//	add this back to common_mp_weapons.csv
//	nodamage rocket for visual only
//  weapon,mp/nodamage_rocket_mp


init()
{
	level.match_events_fx["smoke"] = loadFx( "fx/smoke/smoke_grenade_11sec_mp" );
	level.match_events_fx["tracer"] = loadFx( "fx/misc/tracer_incoming" );
	level.match_events_fx["explosion"] = loadFx( "fx/explosions/building_explosion_huge_gulag" );	
	
	
	//precacheItem( "nodamage_rocket_mp" );
	
	level.matchEvents["mortar"] = ::doMortar;
	level.matchEvents["smoke"] = ::doSmoke;
	level.matchEvents["airstrike"] = ::doAirstrike;
	level.matchEvents["pavelow"] = ::doPavelow;
	level.matchEvents["heli_insertion"] = ::doHeliInsertion;
	level.matchEvents["osprey_insertion"] = ::doOspreyInsertion;
	
	level.matchEventStarted = false;
	level thread onPlayerConnect();
}


onPlayerConnect()
{
	if ( level.prematchPeriod > 0 )
	{
		for ( ;; )
		{
			level waittill( "connected", player );
			//player thread onPlayerSpawned();
			//player thread doHeliInsertion();
		}
	}
}


onPlayerSpawned()
{
	self endon( "disconnect" );
	level endon( "matchevent_started" );
	//level.alliesInsertChopper endon ("stopLinking");
	
	self waittill( "spawned_player" );	

	if ( isDefined( level.alliesInsertChopper ) && !level.alliesInsertChopper.droppedOff && level.prematchPeriod > 0 && self.team == "allies") 
	{
 		self PlayerLinkTo( level.alliesInsertChopper );
 		level.alliesInsertChopper.linkedPlayers[level.alliesInsertChopper.linkedPlayers.size] = self;
	}
	else if ( isDefined( level.alliesInsertChopper ) && !level.alliesInsertChopper.droppedOff && level.prematchPeriod > 0 && self.team == "axis") 
	{
 		self PlayerLinkTo( level.axisInsertChopper );
 		level.axisInsertChopper.linkedPlayers[level.axisInsertChopper.linkedPlayers.size] = self;
	}
}

//////////////////////////////////////////////
//
//	Utilities


getMapCenter()
{
	if ( isDefined( level.mapCenter ) )
		return level.mapCenter;
	
	alliesStart = GetSpawnArray( "mp_tdm_spawn_allies_start");
	axisStart = GetSpawnArray( "mp_tdm_spawn_axis_start");		
	if ( isDefined( alliesStart ) && isDefined( alliesStart[0] ) && isDefined( axisStart ) && isDefined( axisStart[0] ) )
	{
		halfDist = Distance( alliesStart[0].origin, axisStart[0].origin ) / 2;
		dir = vectorToAngles( alliesStart[0].origin - axisStart[0].origin );
		dir = vectorNormalize( dir );
		return alliesStart[0].origin + dir*halfDist;
	}
	return (0,0,0);	
}


getStartSpawns()
{
	alliesStart = GetSpawnArray( "mp_tdm_spawn_allies_start");
	axisStart = GetSpawnArray( "mp_tdm_spawn_axis_start");	
	
	if ( isDefined( alliesStart ) && isDefined( alliesStart[0] ) && isDefined( axisStart ) && isDefined( axisStart[0] ) )
	{
		startSpawns = [];
		startSpawns["axis"] = axisStart;
		startSpawns["allies"] = alliesStart;
		
		return startSpawns;
	}
	else
		return undefined;
}


//////////////////////////////////////////////
//
//	Event - Heli Insertion

doHeliInsertion( teamHeli, axisPoint, alliesPoint )
{		
	spawnHeight = 1200;
	hoverOffset = 1200;
	leaveOffset = 1000;
	
	if( !isdefined( teamHeli ) )
		teamHeli = "both";
	
	if ( teamHeli == "axis" )
	{
		self thread insertaxisInsertChopper( axisPoint );
	}
	else if ( teamHeli == "allies" )
	{
		self thread insertalliesInsertChopper( alliesPoint );
	}
	else
	{
		self thread insertalliesInsertChopper( alliesPoint );
		self thread insertaxisInsertChopper( axisPoint );
	}
}

insertalliesInsertChopper( pointOverRide )
{
	startSpawns = getStartSpawns();
	spawnHeight = 1200;
	hoverOffset = 1200;
	leaveOffset = 1000;
	
	if ( !isDefined( pointOverRide ) )
		pointOverRide = startSpawns["allies"][0];
	
	//	allies chopper
	forward1 = AnglesToForward( startSpawns["allies"][0].angles ) * 300;
	up1 = AnglesToUp( startSpawns["allies"][0].angles ) * spawnHeight;
	right1 = AnglesToRight( startSpawns["allies"][0].angles ) * 3200;
	left1 = AnglesToRight( startSpawns["allies"][0].angles ) * -3200;		
	rightPos1 = startSpawns["allies"][0].origin+forward1+up1+right1;
	leftPos1 = startSpawns["allies"][0].origin+forward1+up1+left1;
	
	alliesInsertChopper = spawnHelicopter( self, rightPos1, startSpawns["allies"][0].angles, "pavelow_mp", "vehicle_pavelow" );	
	level.alliesInsertChopper = alliesInsertChopper;
	level.alliesInsertChopper.linkedPlayers = [];
	level.alliesInsertChopper.droppedOff = false;
	
	//	move to spawn position
	alliesInsertChopper Vehicle_SetSpeed( 50, 15 );
	alliesInsertChopper setVehGoalPos( startSpawns["allies"][0].origin + (0,0,hoverOffset/2), 1 );
	alliesInsertChopper waittill ( "goal" );
	
	// lower to drop off
	alliesInsertChopper setyawspeed( 0, 1, 1 );
	alliesInsertChopper setVehGoalPos( startSpawns["allies"][0].origin + (0,0,hoverOffset/6), 1 );
	alliesInsertChopper waittill ( "goal" );
	
	level.alliesInsertChopper.droppedOff = true;
	
	foreach( player in level.alliesInsertChopper.linkedPlayers )
	{
		player Unlink();
	}
	
	wait( 2 );
	
	alliesInsertChopper SetYawSpeed( 60, 40, 40, 0.3 );
	alliesInsertChopper setVehGoalPos( startSpawns["allies"][0].origin + (0,0,hoverOffset), 1 );
	alliesInsertChopper waittill ( "goal" );
	
	//	rise to leave
	
	alliesInsertChopper Vehicle_SetSpeed( 80, 60 );
	alliesInsertChopper setVehGoalPos( rightPos1+(0,0,leaveOffset)+right1*2, 1 );		
	
	alliesInsertChopper waittill ( "goal" );
	
	//	leave
	
	alliesInsertChopper Vehicle_SetSpeed( 120, 120 );
	alliesInsertChopper setVehGoalPos( rightPos1+(0,0,leaveOffset)+right1*2+forward1*-20, 1 );		
	
	alliesInsertChopper waittill ( "goal" );
	alliesInsertChopper delete();
}

insertaxisInsertChopper( pointOverRide )
{
	startSpawns = getStartSpawns();
	spawnHeight = 1200;
	hoverOffset = 1200;
	leaveOffset = 1000;
	
	//	axis chopper
	forward1 = AnglesToForward( startSpawns["axis"][0].angles ) * 300;
	up1 = AnglesToUp( startSpawns["axis"][0].angles ) * spawnHeight;
	right1 = AnglesToRight( startSpawns["axis"][0].angles ) * 3200;
	left1 = AnglesToRight( startSpawns["axis"][0].angles ) * -3200;		
	rightPos1 = startSpawns["axis"][0].origin+forward1+up1+right1;
	leftPos1 = startSpawns["axis"][0].origin+forward1+up1+left1;
	
	axisInsertChopper = spawnHelicopter( self, rightPos1, startSpawns["axis"][0].angles, "pavelow_mp", "vehicle_pavelow" );	
	level.axisInsertChopper = axisInsertChopper;
	level.axisInsertChopper.linkedPlayers = [];
	level.axisInsertChopper.droppedOff = false;
	
	//	move to spawn position
	axisInsertChopper Vehicle_SetSpeed( 50, 15 );
	axisInsertChopper setVehGoalPos( startSpawns["axis"][0].origin + (0,0,hoverOffset/2), 1 );
	axisInsertChopper waittill ( "goal" );
	
	// lower to drop off
	axisInsertChopper setyawspeed( 0, 1, 1 );
	axisInsertChopper setVehGoalPos( startSpawns["axis"][0].origin + (0,0,hoverOffset/6), 1 );
	axisInsertChopper waittill ( "goal" );
	
	level.axisInsertChopper.droppedOff = true;
	
	foreach( player in level.axisInsertChopper.linkedPlayers )
	{
		player Unlink();
	}
	
	wait( 2 );
	
	axisInsertChopper SetYawSpeed( 60, 40, 40, 0.3 );
	axisInsertChopper setVehGoalPos( startSpawns["axis"][0].origin + (0,0,hoverOffset), 1 );
	axisInsertChopper waittill ( "goal" );
	
	//	rise to leave
	axisInsertChopper Vehicle_SetSpeed( 80, 60 );
	axisInsertChopper setVehGoalPos( rightPos1+(0,0,leaveOffset)+right1*2, 1 );		
	
	axisInsertChopper waittill ( "goal" );
	
	//	leave
	axisInsertChopper Vehicle_SetSpeed( 120, 120 );
	axisInsertChopper setVehGoalPos( rightPos1+(0,0,leaveOffset)+right1*2+forward1*-20, 1 );		
	
	axisInsertChopper waittill ( "goal" );
	axisInsertChopper delete();
}


//////////////////////////////////////////////
//
//	Event - Mortar


doMortar()
{
	mapCenter = getMapCenter();	
	offset = 1;
	for ( i=0; i<5; i++ )
	{
		mortarTarget = mapCenter + ( RandomIntRange(100, 600)*offset, RandomIntRange(100, 600)*offset, 0 );
		
		traceData = BulletTrace( mortarTarget+(0,0,500), mortarTarget-(0,0,500), false );
		if ( isDefined( traceData["position"] ) )
		{			
			PlayFx( level.match_events_fx["tracer"], mortarTarget );
			thread playSoundinSpace( "fast_artillery_round", mortarTarget );
			
			wait( RandomFloatRange( 0.5, 1.5 ) );
			
			PlayFx( level.match_events_fx["explosion"], mortarTarget );
			PlayRumbleOnPosition( "grenade_rumble", mortarTarget );
			Earthquake( 1.0, 0.6, mortarTarget, 2000 );	
			thread playSoundinSpace( "exp_suitcase_bomb_main", mortarTarget );
			physicsExplosionSphere( mortarTarget + (0,0,30), 250, 125, 2 );
			
			offset *= -1;			
		}		
	}
}


//////////////////////////////////////////////
//
//	Event - Smoke


doSmoke()
{
	mapCenter = getMapCenter();	
	offset = 1;
	for ( i=0; i<3; i++ )
	{
		smokeTarget = mapCenter + ( RandomIntRange(100, 600)*offset, RandomIntRange(100, 600)*offset, 0 );		
		
		PlayFx( level.match_events_fx["smoke"], smokeTarget );			
		offset *= -1;	
		wait( 2 );
	}	
}


//////////////////////////////////////////////
//
//	Event - Airstrike


doAirstrike()
{
	level endon( "game_ended" );
	
	offset = 1;
	mapCenter = getMapCenter();
	for( i = 0; i < 3; i++ )
	{	
		strikeTarget = mapCenter + ( RandomIntRange(100, 600)*offset, RandomIntRange(100, 600)*offset, 0 );
		traceData = BulletTrace( strikeTarget+(0,0,500), strikeTarget-(0,0,500), false );
		if ( isDefined( traceData["position"] ) )
		{		
			thread doAirstrikeFlyBy( traceData["position"] );	
			offset *= -1;	
			wait ( randomIntRange( 2,4 ) );
		}
	}
}

doAirstrikeFlyBy( strikeTarget )
{
	randSpawn = randomInt( level.spawnPoints.size - 1 );
	targetPos = level.spawnPoints[randSpawn].origin * (1,1,0);
	
	backDist = 8000;
	forwardDist = 8000;
	heightEnt = GetEnt( "airstrikeheight", "targetname" );
	
	upVector = (0, 0, heightEnt.origin[2] + randomIntRange(-100, 600) );
	
	forward = AnglesToForward( (0,randomInt(45),0) );
	
	startpos = targetPos + upVector + forward * backDist * -1;
	endPos = targetPos + upVector + forward * forwardDist;
	
	plane2StartPos = startpos + ( randomIntRange(400,500), randomIntRange(400,500), randomIntRange(200,300) );
	plane2EndPos = endPos + ( randomIntRange(400,500), randomIntRange(400,500), randomIntRange(200,300) );
	
	plane = spawnplane( self, "script_model", startpos );
	plane2 = spawnplane( self, "script_model", plane2StartPos );
	
	if ( cointoss() )
	{
		plane setModel( "vehicle_av8b_harrier_jet_mp" );
		plane2 setModel( "vehicle_av8b_harrier_jet_mp" );
	}
	else
	{
		plane setModel( "vehicle_av8b_harrier_jet_opfor_mp" );
		plane2 setModel( "vehicle_av8b_harrier_jet_opfor_mp" );
	}
	
	plane.angles = vectorToAngles( endPos-startPos );
	plane playloopsound( "veh_mig29_dist_loop" );
	plane thread playPlaneFx();
	
	plane2.angles = vectorToAngles( endPos-plane2StartPos );
	plane2 playloopsound( "veh_mig29_dist_loop" );
	plane2 thread playPlaneFx();
	
	length = distance(startPos, endPos);
	plane moveTo( endPos * 2, length/2000, 0, 0 );
	wait( randomFloatRange( .25, .5 ) );
	plane2 moveTo( plane2EndPos * 2, length/2000, 0, 0 );
	
	//MagicBullet( "nodamage_rocket_mp", plane.origin, strikeTarget );
	
	wait( length/2000 );
	plane delete();
	plane2 delete();	
}

playPlaneFx()
{
	self endon ( "death" );

	wait( 0.5);
	playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_right" );
	wait( 0.5);
	playfxontag( level.fx_airstrike_afterburner, self, "tag_engine_left" );
	wait( 0.5);
	playfxontag( level.fx_airstrike_contrail, self, "tag_right_wingtip" );
	wait( 0.5);
	playfxontag( level.fx_airstrike_contrail, self, "tag_left_wingtip" );
}


//////////////////////////////////////////////
//
//	Event - Pavelow


doPavelow()
{
	mapCenter = getMapCenter();
	traceData = BulletTrace( mapCenter+(0,0,500), mapCenter-(0,0,500), false );
	if ( isDefined( traceData["position"] ) )
	{
		if ( cointoss() )
			vehicleModel = "vehicle_pavelow";
		else
			vehicleModel = "vehicle_pavelow_opfor";		
		chopper = spawnHelicopter( self, traceData["position"]+(0,0,1000), (0,0,0), "pavelow_mp", vehicleModel );		
		if ( !isDefined( chopper ) )
			return;
		
		chopper.team = self.pers["team"];
		chopper.heli_type = level.heli_types[ vehicleModel ];
		chopper thread [[ level.lightFxFunc[ level.heli_types[ vehicleModel ] ] ]]();
		chopper.zOffset = (0,0,chopper getTagOrigin( "tag_origin" )[2] - chopper getTagOrigin( "tag_ground" )[2]);	
		
		wait( 1 );
		
		playFxOnTag( level.chopper_fx["damage"]["on_fire"], chopper, "tag_engine_left" );
		chopper thread maps\mp\killstreaks\_helicopter::heli_crash();		
	}
}



//////////////////////////////////////////////
//
//	Event - Osprey Insertion


doOspreyInsertion()
{
	startSpawns = getStartSpawns();	
	if ( isDefined( startSpawns ) )
	{	
		spawnHeight = 200;
		hoverOffset = 200;
		leaveOffset = 1000;
		
		//	allies osprey
		
		forward1 = AnglesToForward( startSpawns["allies"][0].angles ) * 300;
		up1 = AnglesToUp( startSpawns["allies"][0].angles ) * spawnHeight;
		pos1 = startSpawns["allies"][0].origin+forward1+up1;		
		airShip1 = spawnHelicopter( self, pos1, startSpawns["allies"][0].angles, "osprey_minigun_mp", "vehicle_v22_osprey_body_mp" );					
		
		//	axis osprey
		
		forward2 = AnglesToForward( startSpawns["axis"][0].angles ) * 300;
		up2 = AnglesToUp( startSpawns["axis"][0].angles ) * spawnHeight;
		pos2 = startSpawns["axis"][0].origin+forward2+up2;		
		airShip2 = spawnHelicopter( self, pos2, startSpawns["axis"][0].angles, "osprey_minigun_mp", "vehicle_v22_osprey_body_mp" );				
		
		//	rise to hover
		
		airship1 thread maps\mp\killstreaks\_escortairdrop::airShipPitchPropsUp();
		airship2 thread maps\mp\killstreaks\_escortairdrop::airShipPitchPropsUp();		
		airShip1 thread maps\mp\killstreaks\_escortairdrop::airShipPitchHatchDown();
		airShip2 thread maps\mp\killstreaks\_escortairdrop::airShipPitchHatchDown();		
		
		airShip1 Vehicle_SetSpeed( 20, 10 );
		airShip1 SetYawSpeed( 3, 3, 3, 0.3 );
		airShip1 setVehGoalPos( pos1+(0,0,hoverOffset), 1 );	
		
		airShip2 Vehicle_SetSpeed( 20, 10 );
		airShip2 SetYawSpeed( 3, 3, 3, 0.3 );
		airShip2 setVehGoalPos( pos2+(0,0,hoverOffset), 1 );				
		
		airShip1 waittill ( "goal" );
		
		airShip1 thread maps\mp\killstreaks\_escortairdrop::airShipPitchHatchUp();
		airShip2 thread maps\mp\killstreaks\_escortairdrop::airShipPitchHatchUp();
		
		wait( 2 );
		
		//	rise to leave
		
		airShip1 Vehicle_SetSpeed( 80, 60 );
		airShip1 SetYawSpeed( 30, 15, 15, 0.3 );
		airShip1 setVehGoalPos( pos1+(0,0,leaveOffset), 1 );	
		
		airShip2 Vehicle_SetSpeed( 80, 60 );
		airShip2 SetYawSpeed( 30, 15, 15, 0.3 );
		airShip2 setVehGoalPos( pos2+(0,0,leaveOffset), 1 );	
		
		airShip1 waittill ( "goal" );
		
		//	leave		
		
		airship1 thread maps\mp\killstreaks\_escortairdrop::airShipPitchPropsDown();
		airship2 thread maps\mp\killstreaks\_escortairdrop::airShipPitchPropsDown();
		
		airShip1 Vehicle_SetSpeed( 120, 120 );
		airShip1 SetYawSpeed( 100, 100, 40, 0.3 );
		airShip1 setVehGoalPos( pos1+(0,0,leaveOffset)+forward1*-20, 1 );	
		
		airShip2 Vehicle_SetSpeed( 120, 120 );
		airShip2 SetYawSpeed( 100, 100, 40, 0.3 );
		airShip2 setVehGoalPos( pos2+(0,0,leaveOffset)+forward2*-20, 1 );		
		
		airShip1 waittill ( "goal" );
		
		airShip1 delete();	
		airShip2 delete();				
	}	
}
