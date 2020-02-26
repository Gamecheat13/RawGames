#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Sabotage
	
	// ...etc...
*/

/*QUAKED mp_sab_spawn_axis (0.75 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_sab_spawn_allies (0.0 0.75 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_sab_spawn_axis_start (1.0 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_sab_spawn_allies_start (0.0 1.0 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	if(getdvar("mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 30, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 0, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 10 );

	level.teamBased = true;
	level.doPrematch = true;
	level.overrideTeamScore = true;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
}

onPrecacheGameType()
{
	game["bomb_dropped_sound"] = "mp_war_objective_lost";
	game["bomb_recovered_sound"] = "mp_war_objective_taken";
	
	precacheShader("waypoint_bomb");
	precacheShader("waypoint_bomb_headicon");
	precacheShader("waypoint_defend");
	precacheShader("waypoint_defuse");
	precacheShader("waypoint_target");
	precacheShader("compass_waypoint_bomb");
	precacheShader("compass_waypoint_defend");
	precacheShader("compass_waypoint_defuse");
	precacheShader("compass_waypoint_target");
	precacheShader("inventory_tnt_large");
	precacheShader("objective");
	precacheShader("hudStopwatch");
	precacheShader("hudstopwatchneedle");
	
	precacheString( &"MP_THE_ENEMY" );
	precacheString( &"MP_YOUR_TEAM" );
	precacheString(&"MP_EXPLOSIVES_RECOVERED_BY");
	precacheString(&"MP_EXPLOSIVES_DROPPED_BY");
	precacheString(&"MP_EXPLOSIVES_PLANTED_BY");
	precacheString(&"MP_EXPLOSIVES_DEFUSED_BY");
	precacheString(&"MP_YOU_HAVE_RECOVERED_THE_BOMB");
	precacheString(&"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES");
	precacheString(&"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES");
	precacheString(&"MP_PLANTING_EXPLOSIVE");
	precacheString(&"MP_DEFUSING_EXPLOSIVE");

	precacheString(&"MP_0MIN");
	precacheString(&"MP_1MIN");
	precacheString(&"MP_2MIN");
	precacheString(&"MP_3MIN");
	precacheString(&"MP_4MIN");
	precacheString(&"MP_5MIN");

	precacheString(&"MP_0MIN_0SEC");
	precacheString(&"MP_1MIN_0SEC");
	precacheString(&"MP_2MIN_0SEC");
	precacheString(&"MP_3MIN_0SEC");
	precacheString(&"MP_4MIN_0SEC");
	precacheString(&"MP_5MIN_0SEC");
	
	game["mins"] = [];
	game["mins"][0] = &"MP_0MIN";
	game["mins"][1] = &"MP_1MIN";
	game["mins"][2] = &"MP_2MIN";
	game["mins"][3] = &"MP_3MIN";
	game["mins"][4] = &"MP_4MIN";
	game["mins"][5] = &"MP_5MIN";

	game["mins_secs"] = [];
	game["mins_secs"][0] = &"MP_0MIN_0SEC";
	game["mins_secs"][1] = &"MP_1MIN_0SEC";
	game["mins_secs"][2] = &"MP_2MIN_0SEC";
	game["mins_secs"][3] = &"MP_3MIN_0SEC";
	game["mins_secs"][4] = &"MP_4MIN_0SEC";
	game["mins_secs"][5] = &"MP_5MIN_0SEC";
}


onStartGameType()
{
	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_SAB" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_SAB" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_SAB" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_SAB" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_SAB_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_SAB_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_SAB_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_SAB_HINT" );

	spawn_axis = getentarray("mp_sab_spawn_axis", "classname");
	if(!spawn_axis.size)
	{
		maps\mp\_utility::error("No mp_sab_spawn_axis spawnpoints found in map.");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	spawn_allies = getentarray("mp_sab_spawn_allies", "classname");
	if(!spawn_allies.size)
	{
		maps\mp\_utility::error("No mp_sab_spawn_allies spawnpoints found in map.");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	level.spawnpoints = [];
	level.spawn_axis = getentarray("mp_sab_spawn_axis", "classname");
	if(!level.spawn_axis.size)
	{
		iprintln("No mp_sab_spawn_axis spawnpoints in level!");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	for(i = 0; i < level.spawn_axis.size; i++)
		level.spawnpoints[level.spawnpoints.size] = level.spawn_axis[i];

	level.spawn_allies = getentarray("mp_sab_spawn_allies", "classname");
	if(!level.spawn_allies.size)
	{
		iprintln("No mp_sab_spawn_allies spawnpoints in level!");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	for(i = 0; i < level.spawn_allies.size; i++)
		level.spawnpoints[level.spawnpoints.size] = level.spawn_allies[i];
		
	level.spawn_axis_start = getentarray("mp_sab_spawn_axis_start", "classname");
	if(!level.spawn_axis_start.size)
	{
		iprintln("No mp_sab_spawn_axis_start spawnpoints in level!");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	for(i = 0; i < level.spawn_axis_start.size; i++)
		level.spawnpoints[level.spawnpoints.size] = level.spawn_axis_start[i];
	
	level.spawn_allies_start = getentarray("mp_sab_spawn_allies_start", "classname");
	if(!level.spawn_allies_start.size)
	{
		iprintln("No mp_sab_spawn_allies_start spawnpoints in level!");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	for(i = 0; i < level.spawn_allies_start.size; i++)
		level.spawnpoints[level.spawnpoints.size] = level.spawn_allies_start[i];


	for(i = 0; i < level.spawnpoints.size; i++)
		level.spawnpoints[i] placeSpawnpoint();


	thread maps\mp\gametypes\_dev::init();

	allowed[0] = "sab";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	thread updateGametypeDvars();
	
	level.suppressHardpoint3DIcons = true;
	
	thread sabotage();
}


onSpawnPlayer()
{
	if ( level.useStartSpawns )
	{
		if (self.pers["team"] == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
	}	
	else
	{
		if (self.pers["team"] == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_axis);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_allies);
	}

	assert( isDefined(spawnpoint) );

	self spawn( spawnpoint.origin, spawnpoint.angles );
}


updateGametypeDvars()
{
	level.plantTime = dvarFloatValue( "planttime", 5, 0, 20 );
	level.defuseTime = dvarFloatValue( "defusetime", 5, 0, 20 );
	level.bombTimer = dvarFloatValue( "bombtimer", 45, 10, 300 );
	level.hotPotato = dvarIntValue( "hotpotato", 0, 0, 1 );
}


sabotage()
{
	level.bombPlanted = false;
		
	level.suppressHardpoint3DIcons = true;
	
	level._effect["bombexplosion"] = loadfx("props/barrelexp");

	trigger = getEnt( "sab_bomb_pickup_trig", "targetname" );
	if ( !isDefined( trigger ) ) 
	{
		error( "No sab_bomb_pickup_trig trigger found in map." );
		return;
	}

	visuals[0] = getEnt( "sab_bomb", "targetname" );
	if ( !isDefined( visuals[0] ) ) 
	{
		error( "No sab_bomb script_model found in map." );
		return;
	}
	
	level.sabBomb = maps\mp\gametypes\_gameobjects::createCarryObject( "neutral", trigger, visuals );
	level.sabBomb maps\mp\gametypes\_gameobjects::allowCarry( "any" );
	level.sabBomb maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_bomb" );
	level.sabBomb maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_bomb" );
	level.sabBomb maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_bomb" );
	//level.sabBomb maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_bomb" );
	level.sabBomb maps\mp\gametypes\_gameobjects::setCarryIcon( "inventory_tnt_large" );
	level.sabBomb maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	level.sabBomb.onPickup = ::onPickup;
	level.sabBomb.onDrop = ::onDrop;


	if ( !isDefined( getEnt( "sab_bomb_axis", "targetname" ) ) ) 
	{
		error("No sab_bomb_axis trigger found in map.");
		return;
	}
	if ( !isDefined( getEnt( "sab_bomb_allies", "targetname" ) ) )
	{
		error("No sab_bomb_allies trigger found in map.");
		return;
	}

	level.bombZones["allies"] = createBombZone( "allies", getEnt( "sab_bomb_allies", "targetname" ) );
	level.bombZones["axis"] = createBombZone( "axis", getEnt( "sab_bomb_axis", "targetname" ) );
}


createBombZone( team, trigger )
{
	visuals = getEntArray( trigger.target, "targetname" );
	
	bombZone = maps\mp\gametypes\_gameobjects::createUseObject( team, trigger, visuals );
	bombZone maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
	bombZone maps\mp\gametypes\_gameobjects::setUseTime( level.plantTime );
	bombZone maps\mp\gametypes\_gameobjects::setUseText( &"MP_PLANTING_EXPLOSIVE" );
	bombZone maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
	bombZone maps\mp\gametypes\_gameobjects::setKeyObject( level.sabBomb );
	bombZone maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" );
	bombZone maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );
	bombZone maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_target" );
	bombZone maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_target" );
	bombZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	bombZone.onUse = ::onUse;
	bombZone.onCantUse = ::onCantUse;
	
	return bombZone;
}


onPickup( player )
{
	level notify ( "bomb_picked_up" );
	
	level.useStartSpawns = false;
	
	team = player.pers["team"];

	if ( team == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";

	player iPrintLnBold( &"MP_YOU_HAVE_RECOVERED_THE_BOMB" );

	// recovered the bomb before abandonment timer elapsed
	if ( team == self maps\mp\gametypes\_gameobjects::getOwnerTeam() )
	{
		printOnTeamArg( &"MP_EXPLOSIVES_RECOVERED_BY", team, player.name );
		playSoundOnPlayers( game["bomb_recovered_sound"], team );
	}
	else
	{
		printOnTeamArg( &"MP_EXPLOSIVES_RECOVERED_BY", team, player.name );
		printOnTeamArg( &"MP_EXPLOSIVES_RECOVERED_BY", otherTeam, &"MP_THE_ENEMY" );
		playSoundOnPlayers( game["bomb_recovered_sound"] );
	}
	
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( team );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "friendly" );
	
	level.bombZones[team] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	level.bombZones[otherTeam] maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
}


onDrop( player )
{
	if ( isDefined( player ) && isDefined( player.name ) )
		printOnTeamArg( &"MP_EXPLOSIVES_DROPPED_BY", self maps\mp\gametypes\_gameobjects::getOwnerTeam(), player.name );
	else
		printOnTeamArg( &"MP_EXPLOSIVES_DROPPED_BY", self maps\mp\gametypes\_gameobjects::getOwnerTeam(), &"MP_YOUR_TEAM" );

	playSoundOnPlayers( game["bomb_dropped_sound"], self maps\mp\gametypes\_gameobjects::getOwnerTeam() );

	thread abandonmentThink( 7.0 );
}


abandonmentThink( delay )
{
	level endon ( "bomb_picked_up" );
	
	wait ( delay );

	if ( isDefined( self.carrier ) )
		return;

	if ( self maps\mp\gametypes\_gameobjects::getOwnerTeam() == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";

	printOnTeamArg( &"MP_EXPLOSIVES_DROPPED_BY", otherTeam, &"MP_THE_ENEMY" );
	playSoundOnPlayers( game["bomb_dropped_sound"], otherTeam );

	self maps\mp\gametypes\_gameobjects::setOwnerTeam( "neutral" );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	level.bombZones["allies"] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	level.bombZones["axis"] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );		
}


onUse( player )
{
	// planted the bomb
	if ( !self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		self.keyObject maps\mp\gametypes\_gameobjects::disableObject();
		self maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
		self maps\mp\gametypes\_gameobjects::setUseTime( level.defuseTime );
		self maps\mp\gametypes\_gameobjects::setUseText( &"MP_DEFUSING_EXPLOSIVE" );
		self maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
		self maps\mp\gametypes\_gameobjects::setKeyObject( undefined );
		self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defuse" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defuse" );
		self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_defend" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_defend" );
		self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		
		player playSound( "mp_bomb_plant" );
		iPrintLnBold( &"MP_EXPLOSIVES_PLANTED_BY", player.name );
		level thread bombPlanted( self, player.pers["team"] );
	}
	else // defused the bomb
	{
		self maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
		self maps\mp\gametypes\_gameobjects::setUseTime( level.plantTime );
		self maps\mp\gametypes\_gameobjects::setUseText( &"MP_PLANTING_EXPLOSIVE" );
		self maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
		self maps\mp\gametypes\_gameobjects::setKeyObject( level.sabBomb );
		self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );
		self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_target" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_target" );
		self maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
		
		level.sabBomb maps\mp\gametypes\_gameobjects::setPickedUp( player );
		
		iPrintLnBold( &"MP_EXPLOSIVES_DEFUSED_BY", player.name );
		level thread bombDefused( self );
	}	
}


onCantUse( player )
{
	player iPrintLnBold( &"MP_CANT_PLANT_WITHOUT_BOMB" );
}


bombPlanted( object, team )
{
	level.timerStopped = true;
	level.bombPlanted = true;

	if ( isDefined( level.bombClock ) )
		level.bombClock destroyElem();

	level.bombClock = createServerTimer( "default", 1.5 );
	level.bombClock setPoint( "TOP", undefined, 0, 28 );
	level.bombClock.color = (1,0,0);
	level.bombClock setTenthsTimer( level.bombTimer );
	
	/*
	if ( !isDefined( level.bombClock ) )
	{
		level.bombClock = createServerDTimer( 128, 32 );
		level.bombClock setPoint( "TOP" );
	}
	*/
		
	object.visuals[0] playLoopSound( "bomb_tick" );


	timePassed = 0;
	while ( level.bombPlanted && (timePassed / 1000) < level.bombTimer )
	{
//		level.bombClock setDTimerTime( int( level.bombTimer * 1000 ) - timePassed );
		timePassed += 100;
		wait ( 0.1 );
	}

	object.visuals[0] stopLoopSound();
	
	if ( (timePassed / 1000) < level.bombTimer )
	{
		if ( level.hotPotato )
		{
			level.bombTimer -= (timePassed / 1000);
			
			mins = int( level.bombTimer / 60 );
			secs = level.bombTimer - (mins * 60);
			
			if ( secs < 10 )
				level.bombClock.label = game["mins_secs"][mins];
			else
				level.bombClock.label = game["mins"][mins];

			level.bombClock setValue( secs );
		}
		else
		{
			level.bombClock destroyElem();
		}
		return;
	}
	
	announcement( game["strings"][team+"_mission_accomplished"] );

	level.bombZones["allies"] maps\mp\gametypes\_gameobjects::disableObject();
	level.bombZones["axis"] maps\mp\gametypes\_gameobjects::disableObject();

	playfx( level._effect["bombexplosion"], object.visuals[0].origin );
	radiusDamage( object.visuals[0].origin, 500, 2000, 1000 );

	level thread [[level.endGame]]( team );

	/*
	// trigger exploder if it exists
	if(isdefined(level.bombexploder))
		maps\mp\_utility::exploder(level.bombexploder);

	// explode bomb
	origin = self getorigin();
	range = 500;
	maxdamage = 2000;
	mindamage = 1000;

	
	level.nukeExplosionOrigin = self.origin;
	thread nukeEffects();
	

	level thread maps\mp\_utility::playSoundOnPlayers("mp_announcer_objdest");
	
	//&"MP_ALLIES_MISSION_ACCOMPLISHED"
	
	level thread [[level.endGame]]( game["attackers"] );
	*/
}


bombDefused( object )
{
	level.timerStopped = false;
	level.bombPlanted = false;
}
