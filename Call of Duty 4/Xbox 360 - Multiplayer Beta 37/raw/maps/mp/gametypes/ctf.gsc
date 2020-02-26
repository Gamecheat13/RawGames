#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Capture the Flag
	
	// ...etc...
*/

/*QUAKED mp_ctf_spawn_axis (0.75 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_ctf_spawn_allies (0.0 0.75 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_ctf_spawn_axis_start (1.0 0.0 0.5) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_ctf_spawn_allies_start (0.0 1.0 0.5) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 5, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 5, 0, 10000 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 2, 0, 10 );
	maps\mp\gametypes\_globallogic::registerRoundSwitchDvar( level.gameType, 1, 1, 9 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 10 );
	
	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onRoundSwitch = ::onRoundSwitch;
	
	if ( getdvar("scr_ctf_returntime") == "" )
		setdvar("scr_ctf_returntime", "30");
	level.flagReturnTime = getdvarint( "scr_ctf_returntime" );
}

onPrecacheGameType()
{
	precacheShader("compass_flag_american");
	precacheShader("compass_flag_neutral");
	precacheShader("objpoint_flag_american");

	precacheModel("prop_flag_neutral");
	precacheModel("prop_flag_neutral_carry");
	precacheModel("prop_flag_american");
	precacheModel("prop_flag_american_carry");
	precacheModel("prop_flag_opfor");
	precacheModel("prop_flag_opfor_carry");
	precacheModel("prop_flag_brit");
	precacheModel("prop_flag_brit_carry");
	precacheModel("prop_flag_russian");
	precacheModel("prop_flag_russian_carry");

	precacheString(&"MP_FLAG_TAKEN_BY");
	precacheString(&"MP_ENEMY_FLAG_TAKEN_BY");
	precacheString(&"MP_FLAG_CAPTURED_BY");
	precacheString(&"MP_ENEMY_FLAG_CAPTURED_BY");
	//precacheString(&"MP_FLAG_RETURNED_BY");
	precacheString(&"MP_FLAG_RETURNED");
	precacheString(&"MP_ENEMY_FLAG_RETURNED");
	precacheString(&"MP_YOUR_FLAG_RETURNING_IN");
	precacheString(&"MP_ENEMY_FLAG_RETURNING_IN");
	precacheString(&"MP_ENEMY_FLAG_DROPPED_BY");
}

onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	game["switchedsides"] = !game["switchedsides"];
}


onStartGameType()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	setClientNameMode("auto_change");
	
	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_CTF" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_CTF" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_CTF" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_CTF" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_CTF_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_CTF_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_CTF_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_CTF_HINT" );
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_ctf_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_ctf_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_ctf_spawn_allies" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_ctf_spawn_axis" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	thread maps\mp\gametypes\_dev::init();
	
	allowed[0] = "ctf";
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 10, &"MP_KILL" );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 10, &"MP_HEADSHOT" );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 2, &"MP_ASSIST" );
	
	maps\mp\gametypes\_rank::registerScoreInfo( "pickup", 10, &"" );
	maps\mp\gametypes\_rank::registerScoreInfo( "return", 5, &"" );
	maps\mp\gametypes\_rank::registerScoreInfo( "capture", 50, &"" );
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill_carrier", 10, &"" );
	
	maps\mp\gametypes\_rank::registerScoreInfo( "defend", 10, &"" );
	maps\mp\gametypes\_rank::registerScoreInfo( "defend_assist", 10, &"" );
	
	maps\mp\gametypes\_rank::registerScoreInfo( "assault", 20, &"" );
	maps\mp\gametypes\_rank::registerScoreInfo( "assault_assist", 4, &"" );
	
	if ( level.roundswitch == 1 && level.roundlimit == 2 )
	{
		if ( game["roundsplayed"] > 0 )
		{
			level.skipRoundEnd = true;
		}
		else
		{
			level.displayHalftimeText = true;
			level.displayRoundEndText = false;
		}
	}
	
	thread ctf();
}

onSpawnPlayer()
{
	self.usingObj = undefined;
	
	spawnteam = self.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );
	
	if ( level.inGracePeriod )
	{
		spawnPoints = getentarray("mp_ctf_spawn_" + spawnteam + "_start", "classname");		
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	self spawn( spawnPoint.origin, spawnPoint.angles );
}

ctf()
{
	if ( game["allies"] == "sas" )
	{
		level.flagModel["allies"] = "prop_flag_brit";
		level.icon2D["allies"] = "compass_flag_british";
		level.noFlagIcon2D["allies"] = "compass_noflag_british";
		level.noFlagIcon3D["allies"] = "objpoint_flag_x_british";
		//level.icon3D["allies"] = "objpoint_flag_british";
		level.carryFlag["allies"] = "prop_flag_brit_carry";
	}
	else
	{
		level.flagModel["allies"] = "prop_flag_american";
		level.icon2D["allies"] = "compass_flag_american";
		level.noFlagIcon2D["allies"] = "compass_noflag_american";
		level.noFlagIcon3D["allies"] = "objpoint_flag_x_american";
		//level.icon3D["allies"] = "objpoint_flag_american";
		level.carryFlag["allies"] = "prop_flag_american_carry";
	}
	
	if ( game["axis"] == "russian" )
	{
		level.flagModel["axis"] = "prop_flag_russian";
		level.icon2D["axis"] = "compass_flag_russian";
		level.noFlagIcon2D["axis"] = "compass_noflag_russian";
		level.noFlagIcon3D["axis"] = "objpoint_flag_x_russian";
		//level.icon3D["axis"] = "objpoint_flag_russian";
		level.carryFlag["axis"] = "prop_flag_russian_carry";
	}
	else
	{
		level.flagModel["axis"] = "prop_flag_opfor";
		level.icon2D["axis"] = "compass_flag_opfor";
		level.noFlagIcon2D["axis"] = "compass_noflag_opfor";
		level.noFlagIcon3D["axis"] = "objpoint_flag_x_opfor";
		//level.icon3D["axis"] = "objpoint_flag_opfor";
		level.carryFlag["axis"] = "prop_flag_opfor_carry";
	}
	
	level.iconCapture3D = "waypoint_capture";
	level.iconCapture2D = "compass_waypoint_capture";
	level.iconDefend3D = "waypoint_defend";
	level.iconDefend2D = "compass_waypoint_defend";
	level.iconTakenFriendly3D = "waypoint_taken_friendly";
	level.iconTakenEnemy3D = "waypoint_taken_enemy";
	level.iconTakenFriendly2D = "compass_waypoint_taken_friendly";
	level.iconTakenEnemy2D = "compass_waypoint_taken_enemy";
	
	//precacheShader( level.icon3D["allies"] );
	//precacheShader( level.icon3D["axis"] );
	precacheShader( level.noFlagIcon3D["allies"] );
	precacheShader( level.noFlagIcon3D["axis"] );

	precacheShader( level.icon2D["axis"] );
	precacheShader( level.icon2D["allies"] );
	precacheShader( level.noFlagIcon2D["allies"] );
	precacheShader( level.noFlagIcon2D["axis"] );

	precacheShader( level.iconCapture3D );
	precacheShader( level.iconDefend3D );

	precacheShader( level.iconCapture2D );
	precacheShader( level.iconDefend2D );

	precacheShader( level.iconTakenFriendly3D );
	precacheShader( level.iconTakenEnemy3D );
	precacheShader( level.iconTakenFriendly2D );
	precacheShader( level.iconTakenEnemy2D );

	level.teamFlags["allies"] = createTeamFlag( "allies" );
	level.teamFlags["axis"] = createTeamFlag( "axis" );

	level.capZones["allies"] = createCapZone( "allies" );
	level.capZones["axis"] = createCapZone( "axis" );
	
	createReturnMessageElems();
}


createReturnMessageElems()
{
	level.ReturnMessageElems = [];

	level.ReturnMessageElems["allies"]["axis"] = createServerTimer( "objective", 1.4, "allies" );
	level.ReturnMessageElems["allies"]["axis"] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
	level.ReturnMessageElems["allies"]["axis"].label = &"MP_ENEMY_FLAG_RETURNING_IN";
	level.ReturnMessageElems["allies"]["axis"].alpha = 0;
	level.ReturnMessageElems["allies"]["axis"].archived = false;
	level.ReturnMessageElems["allies"]["allies"] = createServerTimer( "objective", 1.4, "allies" );
	level.ReturnMessageElems["allies"]["allies"] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 20 );
	level.ReturnMessageElems["allies"]["allies"].label = &"MP_YOUR_FLAG_RETURNING_IN";
	level.ReturnMessageElems["allies"]["allies"].alpha = 0;
	level.ReturnMessageElems["allies"]["allies"].archived = false;

	level.ReturnMessageElems["axis"]["allies"] = createServerTimer( "objective", 1.4, "axis" );
	level.ReturnMessageElems["axis"]["allies"] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 0 );
	level.ReturnMessageElems["axis"]["allies"].label = &"MP_ENEMY_FLAG_RETURNING_IN";
	level.ReturnMessageElems["axis"]["allies"].alpha = 0;
	level.ReturnMessageElems["axis"]["allies"].archived = false;
	level.ReturnMessageElems["axis"]["axis"] = createServerTimer( "objective", 1.4, "axis" );
	level.ReturnMessageElems["axis"]["axis"] setPoint( "TOPRIGHT", "TOPRIGHT", 0, 20 );
	level.ReturnMessageElems["axis"]["axis"].label = &"MP_YOUR_FLAG_RETURNING_IN";
	level.ReturnMessageElems["axis"]["axis"].alpha = 0;
	level.ReturnMessageElems["axis"]["axis"].archived = false;
}

createTeamFlag( team )
{
	entityTeam = team;
	if ( game["switchedsides"] )
		entityTeam = getOtherTeam( entityTeam );
	
	trigger = getEnt( "ctf_trig_" + entityTeam, "targetname" );
	if ( !isDefined( trigger ) ) 
	{
		error( "No ctf_trig_" + entityTeam + " trigger found in map." );
		return;
	}
	visuals[0] = getEnt( "ctf_flag_" + entityTeam, "targetname" );
	if ( !isDefined( visuals[0] ) ) 
	{
		error( "No ctf_flag_" + entityTeam + " script_model found in map." );
		return;
	}
	
	visuals[0] setModel( level.flagModel[team] );
	
	teamFlag = maps\mp\gametypes\_gameobjects::createCarryObject( team, trigger, visuals, (0,0,85) );
	teamFlag maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	teamFlag maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	teamFlag maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconDefend2D );
	teamFlag maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	teamFlag maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );
	teamFlag maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
	teamFlag maps\mp\gametypes\_gameobjects::setCarryIcon( level.icon2D[team] );
	teamFlag.allowWeapons = true;
	teamFlag.onPickup = ::onPickup;
	teamFlag.onPickupFailed = ::onPickup;
	teamFlag.onDrop = ::onDrop;
	teamFlag.onReset = ::onReset;
	
	return teamFlag;
}

createCapZone( team )
{
	entityTeam = team;
	if ( game["switchedsides"] )
		entityTeam = getOtherTeam( entityTeam );

	trigger = getEnt( "ctf_zone_" + entityTeam, "targetname" );
	if ( !isDefined( trigger ) ) 
	{
		error("No ctf_zone_" + entityTeam + " trigger found in map.");
		return;
	}
	
	visuals = [];
	capZone = maps\mp\gametypes\_gameobjects::createUseObject( team, trigger, visuals, (0,0,85) );
	capZone maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	capZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	capZone maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconTakenFriendly2D );
	capZone maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconTakenFriendly3D );
	capZone maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconTakenEnemy2D );
	capZone maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconTakenEnemy3D );

	capZone maps\mp\gametypes\_gameobjects::setUseTime( 0 );
	capZone maps\mp\gametypes\_gameobjects::setKeyObject( level.teamFlags[ getOtherTeam( team ) ] );
	
	capZone.onUse = ::onUse;
	capZone.onCantUse = ::onCantUse;
	
	flagBaseFX = [];
	flagBaseFX["marines"] = "misc/ui_flagbase_silver";
	flagBaseFX["sas"    ] = "misc/ui_flagbase_black";
	flagBaseFX["russian"] = "misc/ui_flagbase_red";
	flagBaseFX["opfor"  ] = "misc/ui_flagbase_gold";
	
	traceStart = trigger.origin + (0,0,32);
	traceEnd = trigger.origin + (0,0,-32);
	trace = bulletTrace( traceStart, traceEnd, false, undefined );
	
	fx = flagBaseFX[ game[ team ] ];
	fxid = loadfx( fx );
	
	upangles = vectorToAngles( trace["normal"] );
	forward = anglesToForward( upangles );
	right = anglesToRight( upangles );
	
	effect = spawnFx( fxid, trace["position"], forward, right );
	triggerFx( effect );
	
	return capZone;
}

onPickup( player )
{
	team = player.pers["team"];

	if ( team == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";

	// return the flag
	if ( team == self maps\mp\gametypes\_gameobjects::getOwnerTeam() )
	{
		self notify("picked_up");
		self returnFlag();
		player logString( "flag returned" );
		
		printAndSoundOnEveryone( team, "none", &"MP_FLAG_RETURNED_BY", "", "mp_obj_returned", "", player.name );

		maps\mp\gametypes\_globallogic::givePlayerScore( "return", player );
		player thread [[level.onXPEvent]]( "return" );
	}
	else // picked up the flag
	{
		player attachFlag();
		
		self notify("picked_up");
		player logString( "flag taken" );
		
		level.capZones[otherTeam] maps\mp\gametypes\_gameobjects::allowUse( "none" );
		level.capZones[otherTeam] maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		
		self maps\mp\gametypes\_gameobjects::setVisibleTeam( "enemy" );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", undefined );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", undefined );
				
		printAndSoundOnEveryone( team, otherteam, &"MP_ENEMY_FLAG_TAKEN_BY", &"MP_FLAG_TAKEN_BY", "mp_obj_taken", "mp_enemy_obj_taken", player.name );

		maps\mp\gametypes\_globallogic::leaderDialog( "enemy_flag_taken", team );
		maps\mp\gametypes\_globallogic::leaderDialog( "flag_taken", otherteam );
		
		maps\mp\gametypes\_globallogic::givePlayerScore( "pickup", player );
		player thread [[level.onXPEvent]]( "pickup" );
	}
}

returnFlag()
{
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	otherTeam = level.otherTeam[team];
	
	level.capZones[team] maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	level.capZones[team] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );

	self maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	self maps\mp\gametypes\_gameobjects::returnHome();
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	
	printAndSoundOnEveryone( team, getOtherTeam( team ), &"MP_FLAG_RETURNED", &"MP_ENEMY_FLAG_RETURNED", "mp_obj_returned", "mp_obj_returned", "" );
	maps\mp\gametypes\_globallogic::leaderDialog( "enemy_flag_returned", otherteam );
	maps\mp\gametypes\_globallogic::leaderDialog( "flag_returned", team );	
}

returnFlagAfterTime( time )
{
	result = returnFlagHudElems( time );
	
	clearReturnFlagHudElems();
	
	if ( !isdefined( result ) ) // returnFlagHudElems hit an endon
		return;
	
	self returnFlag();
}

returnFlagHudElems( time )
{
	self endon("picked_up");
	level endon("game_ended");
	
	ownerteam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	assert( !level.ReturnMessageElems["axis"][ownerteam].alpha );
	level.ReturnMessageElems["axis"][ownerteam].alpha = 1;
	level.ReturnMessageElems["axis"][ownerteam] setTimer( time );
	
	assert( !level.ReturnMessageElems["allies"][ownerteam].alpha );
	level.ReturnMessageElems["allies"][ownerteam].alpha = 1;
	level.ReturnMessageElems["allies"][ownerteam] setTimer( time );
	
	wait time;
	
	return true;
}

clearReturnFlagHudElems()
{
	ownerteam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	level.ReturnMessageElems["allies"][ownerteam].alpha = 0;
	level.ReturnMessageElems["axis"][ownerteam].alpha = 0;
}

onDrop( player )
{
	team = level.otherTeam[self maps\mp\gametypes\_gameobjects::getOwnerTeam()];
	otherTeam = level.otherTeam[team];
	
	player logString( "flag dropped at: " + player.origin[0] + " " + player.origin[1] + " " + player.origin[2] );
	
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy",    level.iconCapture3D );
	self maps\mp\gametypes\_gameobjects::allowCarry( "any" );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	
	if ( isDefined( player ) )
	{
 		if ( isDefined( player.carryFlag ) )
			player detachFlag();
		
		printAndSoundOnEveryone( team, "none", &"MP_ENEMY_FLAG_DROPPED_BY", "", "mp_war_objective_lost", "", player.name );		
	}
	else
	{
		playSoundOnPlayers( "mp_war_objective_lost", team );
	}
	self thread returnFlagAfterTime( level.flagReturnTime );

	maps\mp\gametypes\_globallogic::leaderDialog( "enemy_flag_dropped", team );
	maps\mp\gametypes\_globallogic::leaderDialog( "flag_dropped", otherteam );	

}

onReset()
{
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();

	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
	level.capZones[team] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );

}

onUse( player )
{
	team = player.pers["team"];
	if ( team == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";

//	curScore = maps\mp\gametypes\_globallogic::_getTeamScore( team );	
//	maps\mp\gametypes\_globallogic::_setTeamScore( team, curScore + 100 );

	maps\mp\gametypes\_globallogic::leaderDialog( "enemy_flag_captured", team );
	maps\mp\gametypes\_globallogic::leaderDialog( "flag_captured", otherteam );	

	maps\mp\gametypes\_globallogic::givePlayerScore( "capture", player );
	player thread [[level.onXPEvent]]( "capture" );
	player logString( "flag captured" );

	//maps\mp\gametypes\_globallogic::giveTeamScore( "capture", team, player );
	[[level._setTeamScore]]( team, [[level._getTeamScore]]( team ) + 1 );
	
	printAndSoundOnEveryone( team, otherteam, &"MP_ENEMY_FLAG_CAPTURED_BY", &"MP_FLAG_CAPTURED_BY", "mp_obj_captured", "mp_enemy_obj_captured", player.name );

	if ( !level.splitScreen )
	{
		for ( index = 0; index < level.players.size; index++ )
		{
			tempPlayer = level.players[index];
			if ( tempPlayer.pers["team"] == team )
				tempPlayer thread maps\mp\gametypes\_hud_message::oldNotifyMessage( "Your team scored!", undefined, undefined, (0, 1, 0) );
			else if ( tempPlayer.pers["team"] == otherTeam )
				tempPlayer thread maps\mp\gametypes\_hud_message::oldNotifyMessage( "Enemy team scored!", undefined, undefined, (1, 0, 0) );
		}
	}

	level.teamFlags[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	level.teamFlags[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	level.teamFlags[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::returnHome();
	level.capZones[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::allowUse( "friendly" );

	if ( isDefined( player.carryFlag ) )
		player detachFlag();
}


onCantUse( player )
{
//	player iPrintLnBold( &"MP_CANT_PLANT_WITHOUT_BOMB" );
}


onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isDefined( self.carryFlag ) )
		return;

	if ( isDefined( attacker ) && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
	{
		attacker thread [[level.onXPEvent]]( "kill_carrier" );
		maps\mp\gametypes\_globallogic::givePlayerScore( "kill_carrier", attacker );
	}
	
	self detachFlag();
}


attachFlag()
{
	otherTeam = level.otherTeam[self.pers["team"]];
	
	self attach( level.carryFlag[otherTeam], "J_spine4", true );
	self.carryFlag = level.carryFlag[otherTeam];
}

detachFlag()
{
	self detach( self.carryFlag, "J_spine4" );
	self.carryFlag = undefined;
}
