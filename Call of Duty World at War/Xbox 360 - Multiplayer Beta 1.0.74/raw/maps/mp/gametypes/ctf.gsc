#include maps\mp\_utility;
#include maps\mp\_geometry;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_spawning;
#include maps\mp\_music;

/*
	CTF
	
	Level requirements
	------------------
		Allied Spawnpoints:
			classname		mp_sd_spawn_attacker
			Allied players spawn from these. Place at least 16 of these relatively close together.

		Axis Spawnpoints:
			classname		mp_sd_spawn_defender
			Axis players spawn from these. Place at least 16 of these relatively close together.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Flag:
			classname				trigger_multiple
			targetname				flagtrigger
			script_gameobjectname	ctf
			script_label				Set to name of flag. This sets the letter shown on the compass in original mode.
			script_team					Set to allies or axis. This is used to set which team a flag is used by.
			This should be a 16x16 unit trigger with an origin brush placed so that it's center lies on the bottom plane of the trigger.
			Must be in the level somewhere. This is the trigger that is used to represent a flag.
			It gets moved to the position of the planted bomb model.
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
	if(getdvar("mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	
	// register ctf spawn influencer callback
	level.callbackPlayerSpawnGenerateInfluencers= ::ctfPlayerSpawnGenerateInfluencers;
	level.callbackPlayerSpawnGenerateSpawnPointEntityBaseScore = ::ctfPlayerSpawnGenerateSpawnPointEntityBaseScore;

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 15, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 5, 0, 5000 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 2, 0, 10 );
	maps\mp\gametypes\_globallogic::registerRoundSwitchDvar( level.gameType, 1, 0, 9 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 10 );

	if ( getdvar("scr_ctf_spawnPointFacingAngle") == "" )
		setdvar("scr_ctf_spawnPointFacingAngle", "60");

	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onRoundSwitch = ::onRoundSwitch;
//	level.onScoreLimit = ::onScoreLimit;
	level.onRoundEndGame = ::onRoundEndGame;
	level.onEndGame = ::onEndGame;
	level.onTeamOutcomeNotify = ::onTeamOutcomeNotify;

//	level.endGameOnScoreLimit = false;
	level.scoreLimitIsPerRound = true;
	
	if ( !isdefined( game["ctf_teamscore"] ) )
	{
		game["ctf_teamscore"]["allies"] = 0;
		game["ctf_teamscore"]["axis"] = 0;
	}

	game["dialog"]["gametype"] = "ctf";
	game["dialog"]["wetake_flag"] = "wetake_flag";
	game["dialog"]["theytake_flag"] = "theytake_flag";
	game["dialog"]["theydrop_flag"] = "theydrop_flag";
	game["dialog"]["wedrop_flag"] = "wedrop_flag";
	game["dialog"]["wereturn_flag"] = "wereturn_flag";
	game["dialog"]["theyreturn_flag"] = "theyreturn_flag";
	game["dialog"]["theycap_flag"] = "theycap_flag";
	game["dialog"]["wecap_flag"] = "wecap_flag";
	game["dialog"]["offense_obj"] = "ctf_boost";
	game["dialog"]["defense_obj"] = "ctf_boost";

	level.lastDialogTime = getTime();
}

onPrecacheGameType()
{
	game["flag_dropped_sound"] = "mp_war_objective_lost";
	game["flag_recovered_sound"] = "mp_war_objective_taken";
	
	game["flagmodels"] = [];
	game["carry_flagmodels"] = [];
	game["carry_icon"] = [];
	game["waypoints_flag"] = [];
	game["waypoints_base"] = [];
	game["compass_waypoint_flag"] = [];
	game["compass_waypoint_base"] = [];

	if ( game["allies"] == "marines" )
	{
		game["flagmodels"]["allies"] = "prop_flag_american";
		game["carry_flagmodels"]["allies"] = "prop_flag_american_carry";
		game["waypoints_flag"]["allies"] = "waypoint_flag_american";
		game["waypoints_base"]["allies"] = "waypoint_flag_x_american";
		game["compass_waypoint_flag"]["allies"] = "compass_flag_american";
		game["compass_waypoint_base"]["allies"] = "compass_noflag_american";
		game["carry_icon"]["allies"] = "hudicon_american_ctf_flag_carry";
	}
	else
	{
		game["flagmodels"]["allies"] = "prop_flag_russian";
		game["carry_flagmodels"]["allies"] = "prop_flag_russian_carry";
		game["waypoints_flag"]["allies"] = "waypoint_flag_russian";
		game["waypoints_base"]["allies"] = "waypoint_flag_x_russian";
		game["compass_waypoint_flag"]["allies"] = "compass_flag_russian";
		game["compass_waypoint_base"]["allies"] = "compass_noflag_russian";
		game["carry_icon"]["allies"] = "hudicon_russian_ctf_flag_carry";
	}
	
	if ( game["axis"] == "german" ) 
	{
		game["flagmodels"]["axis"] = "prop_flag_german";
		game["carry_flagmodels"]["axis"] = "prop_flag_german_carry";
		game["waypoints_flag"]["axis"] = "waypoint_flag_german";
		game["waypoints_base"]["axis"] = "waypoint_flag_x_german";
		game["compass_waypoint_flag"]["axis"] = "compass_flag_german";
		game["compass_waypoint_base"]["axis"] = "compass_noflag_german";
		game["carry_icon"]["axis"] = "hudicon_german_ctf_flag_carry";
	}
	else
	{
		game["flagmodels"]["axis"] = "prop_flag_japanese";
		game["carry_flagmodels"]["axis"] = "prop_flag_japanese_carry";
		game["waypoints_flag"]["axis"] = "waypoint_flag_japanese";
		game["waypoints_base"]["axis"] = "waypoint_flag_x_japanese";
		game["compass_waypoint_flag"]["axis"] = "compass_flag_japanese";
		game["compass_waypoint_base"]["axis"] = "compass_noflag_japanese";
		game["carry_icon"]["axis"] = "hudicon_japanese_ctf_flag_carry";
	}
	
	precacheModel( game["flagmodels"]["allies"] );
	precacheModel( game["flagmodels"]["axis"] );
	precacheModel( game["carry_flagmodels"]["allies"] );
	precacheModel( game["carry_flagmodels"]["axis"] );

	precacheShader( game["waypoints_flag"]["allies"] );
	precacheShader( game["waypoints_base"]["allies"] );
	precacheShader( game["compass_waypoint_flag"]["allies"] );
	precacheShader( game["compass_waypoint_base"]["allies"] );
	precacheShader( game["carry_icon"]["allies"] );
	
	precacheShader( game["waypoints_flag"]["axis"] );
	precacheShader( game["waypoints_base"]["axis"] );
	precacheShader( game["compass_waypoint_flag"]["axis"] );
	precacheShader( game["compass_waypoint_base"]["axis"] );
	precacheShader( game["carry_icon"]["axis"] );
	
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
	precacheString(&"MP_SUDDEN_DEATH");
	precacheString(&"MP_CAP_LIMIT_REACHED");
	precacheString(&"MP_CTF_CANT_CAPTURE_FLAG" );
	
	game["strings"]["score_limit_reached"] = &"MP_CAP_LIMIT_REACHED";

}

onStartGameType()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	setClientNameMode("auto_change");

	ctf_setTeamScore( "allies", 0 );
	ctf_setTeamScore( "axis", 0 );

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
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	level.spawn_axis = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_axis" );
	level.spawn_allies = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_allies" );
	level.spawn_axis_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_axis_start" );
	level.spawn_allies_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_allies_start" );

	maps\mp\gametypes\_rank::registerScoreInfo( "capture", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defend", 10 );
	maps\mp\gametypes\_rank::registerScoreInfo( "kill_carrier", 10 );

	allowed[0] = "ctf";
	
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();

	thread updateGametypeDvars();
	
	thread ctf();
}

ctf_setTeamScore( team, teamScore )
{
	if ( teamScore == game["teamScores"][team] )
		return;

	game["teamScores"][team] = teamScore;
	
	maps\mp\gametypes\_globallogic::updateTeamScores( team );
}

onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	game["switchedsides"] = !game["switchedsides"];
}

onScoreLimit()
{
	if ( maps\mp\gametypes\_globallogic::hitRoundLimit())
	{
		level.endGameOnScoreLimit = true;
		maps\mp\gametypes\_globallogic::default_onScoreLimit();
		return;
	}	
	
	winner = undefined;
	
	if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
		winner = "tie";
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		winner = "axis";
	else
		winner = "allies";
	logString( "scorelimit, win: " + winner + ", allies: " + game["teamScores"]["allies"] + ", axis: " + game["teamScores"]["axis"] );
	
	makeDvarServerInfo( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	setDvar( "ui_text_endreason", game["strings"]["score_limit_reached"] );
	
	thread maps\mp\gametypes\_globallogic::endGame( winner, game["strings"]["score_limit_reached"] );
}

onEndGame( winningTeam )
{
	game["ctf_teamscore"]["allies"] += maps\mp\gametypes\_globallogic::_getTeamScore( "allies");
	game["ctf_teamscore"]["axis"] += maps\mp\gametypes\_globallogic::_getTeamScore( "axis");
}

onRoundEndGame( winningTeam )
{
	ctf_setTeamScore( "allies", game["ctf_teamscore"]["allies"] );
	ctf_setTeamScore( "axis", game["ctf_teamscore"]["axis"] );
	
	if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
		winner = "tie";
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
		winner = "axis";
	else
		winner = "allies";

	// make sure stats get reported
	maps\mp\gametypes\_globallogic::updateWinLossStats( winner );
	
	return winner;
}

// using this to set the halftime scores to be the total scores if there is more then
// one round per half
// this happens per player but after the first player the ctf_setTeamScore
// should not do anything
onTeamOutcomeNotify( switchtype, isRound, endReasonText )
{
	if ( switchtype == "halftime" || switchtype == "intermission")
	{
		ctf_setTeamScore( "allies", game["ctf_teamscore"]["allies"] );
		ctf_setTeamScore( "axis", game["ctf_teamscore"]["axis"] );
	}
	
	maps\mp\gametypes\_hud_message::teamOutcomeNotify( switchtype, isRound, endReasonText );
}

onSpawnPlayerUnified()
{
	self.isFlagCarrier = false;
	
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}

onSpawnPlayer()
{
	self.isFlagCarrier = false;

	spawnteam = self.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	if ( level.useStartSpawns )
	{
		if (spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
	}	
	else
	{
		if (spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_axis);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_allies);
	}

	assert( isDefined(spawnpoint) );

	self spawn( spawnPoint.origin, spawnPoint.angles );
}

updateGametypeDvars()
{
	level.idleFlagReturnTime = dvarFloatValue( "idleflagreturntime", 30, 0, 120 );
	level.flagRespawnTime = dvarIntValue( "flagrespawntime", 0, 0, 120 );
	level.touchReturn = dvarIntValue( "touchreturn", 0, 0, 1 );
	level.enemyCarrierVisible = dvarIntValue( "enemycarriervisible", 0, 0, 2 );
	
	// do not allow both a idleFlagReturnTime of forever and no touch return
	// at the same time otherwise the game is unplayable
	if ( level.idleFlagReturnTime == 0 && level.touchReturn == 0)
	{
		level.touchReturn = 1;
	}
}

createFlag( trigger )
{		
	if ( isDefined( trigger.target ) )
	{
		visuals[0] = getEnt( trigger.target, "targetname" );
	}
	else
	{
		visuals[0] = spawn( "script_model", trigger.origin );
		visuals[0].angles = trigger.angles;
	}

	entityTeam = trigger.script_team;
	if ( game["switchedsides"] )
		entityTeam = getOtherTeam( entityTeam );

	visuals[0] setModel( game["flagmodels"][entityTeam] );

	flag = maps\mp\gametypes\_gameobjects::createCarryObject( entityTeam, trigger, visuals, (0,0,100) );
	flag maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	flag maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	flag maps\mp\gametypes\_gameobjects::setVisibleCarrierModel( game["carry_flagmodels"][entityTeam] );
//		flag maps\mp\gametypes\_gameobjects::setCarryIcon( game["carry_icon"][entityTeam] );
	flag maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconDefend2D );
	flag maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	flag maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );
	flag maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
	flag maps\mp\gametypes\_gameobjects::setCarryIcon( game["compass_waypoint_flag"][entityTeam] );

	if ( level.enemyCarrierVisible == 2 )
	{
		flag.objIDPingFriendly = true;
	}
	flag.allowWeapons = true;
	flag.onPickup = ::onPickup;
	flag.onPickupFailed = ::onPickup;
	flag.onDrop = ::onDrop;
	flag.onReset = ::onReset;
			
	if ( level.idleFlagReturnTime > 0 )
	{
		flag.autoResetTime = level.idleFlagReturnTime;
	}
	else
	{
		flag.autoResetTime = undefined;
	}		
	
	return flag;
}

createFlagZone( trigger )
{
	visuals = [];
	
	entityTeam = trigger.script_team;
	if ( game["switchedsides"] )
		entityTeam = getOtherTeam( entityTeam );

	flagZone = maps\mp\gametypes\_gameobjects::createUseObject( entityTeam, trigger, visuals, (0,0,100) );
	flagZone maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	flagZone maps\mp\gametypes\_gameobjects::setUseTime( 0 );
	flagZone maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_FLAG" );
	//flagZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	flagZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	flagZone maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconTakenFriendly2D );
	flagZone maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconTakenFriendly3D );
	flagZone maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconTakenEnemy2D );
	flagZone maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconTakenEnemy3D );

	enemyTeam = getOtherTeam( entityTeam );
	flagZone maps\mp\gametypes\_gameobjects::setKeyObject( level.teamFlags[enemyTeam] );
	flagZone.onUse = ::onCapture;
	
	flag = level.teamFlags[entityTeam];
	flag.flagBase = flagZone;
	flagZone.flag = flag;
	
	traceStart = trigger.origin + (0,0,32);
	traceEnd = trigger.origin + (0,0,-32);
	trace = bulletTrace( traceStart, traceEnd, false, undefined );

	upangles = vectorToAngles( trace["normal"] );
	flagZone.baseeffectforward = anglesToForward( upangles );
	flagZone.baseeffectright = anglesToRight( upangles );
	
	flagZone.baseeffectpos = trace["position"];
	
	flagZone thread resetFlagBaseEffect();
	
	flagZone createFlagSpawnInfluencer();
	
	return flagZone;
//		flag resetIcons();
}

createFlagHint( team, origin )
{
	radius = 128;
	height = 64;
	
	trigger = spawn("trigger_radius", origin, 0, radius, height);
	trigger setHintString( &"MP_CTF_CANT_CAPTURE_FLAG" );
	trigger setcursorhint("HINT_NOICON");
	trigger.original_origin = origin;
	
	trigger turn_off();
	
	return trigger;
}

ctf()
{
	level.flags = [];
	level.teamFlags = [];
	level.flagZones = [];
	level.teamFlagZones = [];
	
	level.iconCapture3D = "waypoint_capture";
	level.iconCapture2D = "compass_waypoint_capture";
	level.iconDefend3D = "waypoint_defend";
	level.iconDefend2D = "compass_waypoint_defend";
	level.iconTakenFriendly3D = "waypoint_taken_friendly";
	level.iconTakenEnemy3D = "waypoint_taken_enemy";
	level.iconTakenFriendly2D = "compass_waypoint_taken_friendly";
	level.iconTakenEnemy2D = "compass_waypoint_taken_enemy";
	level.iconDropped3D = "waypoint_defend";
	level.iconCarrier3D = "waypoint_flag_yellow";
	level.iconEnemyCarrier3D = "waypoint_kill";
	level.iconReturn3D = "waypoint_return";
	level.iconBase3D = "waypoint_capture";
	
	precacheShader( level.iconCapture3D );
	precacheShader( level.iconDefend3D );

	precacheShader( level.iconCapture2D );
	precacheShader( level.iconDefend2D );

	precacheShader( level.iconTakenFriendly3D );
	precacheShader( level.iconTakenEnemy3D );
	precacheShader( level.iconTakenFriendly2D );
	precacheShader( level.iconTakenEnemy2D );
	precacheShader( level.iconDropped3D );
	precacheShader( level.iconCarrier3D );
	precacheShader( level.iconReturn3D );
	precacheShader( level.iconBase3D );
	precacheShader( level.iconEnemyCarrier3D );

	flagBaseFX = [];
	flagBaseFX["marines"] = "misc/ui_flagbase_blue";
	flagBaseFX["japanese"] = "misc/ui_flagbase_red";
	flagBaseFX["german"] = "misc/ui_flagbase_gold";
	flagBaseFX["russian"] = "misc/ui_flagbase_orange";
	
	level.flagBaseFXid[ "allies" ] = loadfx( flagBaseFX[ game[ "allies" ] ] );
	level.flagBaseFXid[ "axis"   ] = loadfx( flagBaseFX[ game[ "axis"   ] ] );

	flag_triggers = getEntArray( "ctf_flag_pickup_trig", "targetname" );
	if ( !isDefined( flag_triggers ) || flag_triggers.size != 2)
	{
		maps\mp\_utility::error("Not enough ctf_flag_pickup_trig triggers found in map.  Need two.");
		return;
	}

	for ( index = 0; index < flag_triggers.size; index++ )
	{
		trigger = flag_triggers[index];
		
		flag = createFlag( trigger );
		
		team = flag maps\mp\gametypes\_gameobjects::getOwnerTeam();
		level.flags[level.flags.size] = flag;
		level.teamFlags[team] = flag;
		
	}

	flag_zones = getEntArray( "ctf_flag_zone_trig", "targetname" );
	if ( !isDefined( flag_zones ) || flag_zones.size != 2)
	{
		maps\mp\_utility::error("Not enough ctf_flag_zone_trig triggers found in map.  Need two.");
		return;
	}

	for ( index = 0; index < flag_zones.size; index++ )
	{
		trigger = flag_zones[index];
		
		flagZone = createFlagZone( trigger );

		team = flagZone maps\mp\gametypes\_gameobjects::getOwnerTeam();
		level.flagZones[level.flagZones.size] = flagZone;		
		level.teamFlagZones[team] = flagZone;		

		level.flagHints[team] = createFlagHint( team, trigger.origin );		

		facing_angle = getdvarint("scr_ctf_spawnPointFacingAngle");
		
		// the opposite team will want to face this point
		if ( team == "axis" )
		{
			setspawnpointsbaseweight( level.spawnsystem.iSPAWN_TEAMMASK_ALLIES, trigger.origin, facing_angle, level.spawnsystem.objective_facing_bonus);
		}
		else
		{
			setspawnpointsbaseweight( level.spawnsystem.iSPAWN_TEAMMASK_AXIS, trigger.origin, facing_angle, level.spawnsystem.objective_facing_bonus);
		}
	}
	
	// once all the flags have been registered with the game,
	// give each spawn point a baseline score for each objective flag,
	// based on whether or not player will be looking in the direction of that flag upon spawning
	//generate_baseline_spawn_point_scores();

	createReturnMessageElems();
}

ctf_endGame( winningTeam, endReasonText )
{
	if ( isdefined( winningTeam ) )
		[[level._setTeamScore]]( winningTeam, [[level._getTeamScore]]( winningTeam ) + 1 );
	
	thread maps\mp\gametypes\_globallogic::endGame( winningTeam, endReasonText );
}

onTimeLimit()
{
	if ( level.teamBased )
		ctf_endGame( game["defenders"], game["strings"]["time_limit_reached"] );
	else
		ctf_endGame( undefined, game["strings"]["time_limit_reached"] );
}

onDrop( player )
{
	player.isFlagCarrier = false;
	player deleteBaseIcon();

	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	otherTeam = getOtherTeam( team );
	
	if ( level.touchReturn )
	{
		self maps\mp\gametypes\_gameobjects::allowCarry( "any" );
		level.flagHints[otherTeam] turn_off();
	}
		
	printAndSoundOnEveryone( team, "none", &"MP_ENEMY_FLAG_DROPPED_BY", "", "mp_war_objective_lost", "", player );		


	if( getTime() - level.lastDialogTime > 10000 )
	{
		maps\mp\gametypes\_globallogic::leaderDialog( "wedrop_flag", otherTeam );
		maps\mp\gametypes\_globallogic::leaderDialog( "theydrop_flag", team );
		level.lastDialogTime = getTime();
	}

	if ( isDefined( player ) )
	 	player logString( team + " flag dropped" );
	else
	 	logString( team + " flag dropped" );

//	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );

	if ( level.touchReturn )
	{
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconReturn3D );
	}
	else
	{
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDropped3D );
	}	
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy",    level.iconCapture3D );
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );

	thread maps\mp\_utility::playSoundOnPlayers( game["flag_dropped_sound"], game["attackers"] );

	self thread returnFlagAfterTimeMsg( level.idleFlagReturnTime );
}


onPickup( player )
{
	if ( level.touchReturn )
	{
		self maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	}

	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	otherTeam = getOtherTeam( team );
	if ( isDefined( player ) && player.pers["team"] == team )
	{	
		player setStatLBByName( "CTF_Flags", 1, "Returned");
	
		self notify("picked_up");

		printAndSoundOnEveryone( team, "none", &"MP_FLAG_RETURNED_BY", "", "mp_obj_returned", "", player );

		clearReturnFlagHudElems();
		
		// want to return the flag here
		self returnFlag();
		self maps\mp\gametypes\_gameobjects::returnHome();
		if ( isDefined( player ) )
		 	player logString( team + " flag returned" );
		 else
		 	logString( team + " flag returned" );
		return;
	}
	else
	{
		printAndSoundOnEveryone( otherteam, team, &"MP_ENEMY_FLAG_TAKEN_BY", &"MP_FLAG_TAKEN_BY", "mp_obj_taken", "mp_enemy_obj_taken", player );

		player setStatLBByName( "CTF_Flags", 1, "Picked Up");
		
		if( getTime() - level.lastDialogTime > 10000 )
		{
			//check if we want to do the squad line
			squadID = getplayersquadid( player );
			if( isDefined( squadID ) )
				maps\mp\gametypes\_globallogic::leaderDialog( "wetake_flag", otherTeam, undefined, undefined, "squad_take", squadID );
			else
				maps\mp\gametypes\_globallogic::leaderDialog( "wetake_flag", otherTeam );

			maps\mp\gametypes\_globallogic::leaderDialog( "theytake_flag", team );
			level.lastDialogTime = getTime();
		}
	
		player.isFlagCarrier = true;
	
		if ( level.enemyCarrierVisible )
		{
			self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		}
		else
		{
			self maps\mp\gametypes\_gameobjects::setVisibleTeam( "enemy" );
		}
		self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCarrier3D );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconEnemyCarrier3D );
		
		player thread claim_trigger( level.flagHints[otherTeam] );
		
		player setupBaseIcon();
		player updateBaseIcon();
		
		update_hints();

		player logString( team + " flag taken" );
	}
	
}

returnFlag()
{
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	otherTeam = level.otherTeam[team];
	
	level.teamFlagZones[otherTeam] maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	level.teamFlagZones[otherTeam] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );

	update_hints();
	
	if ( level.touchReturn )
	{
		self maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	}
	self maps\mp\gametypes\_gameobjects::returnHome();
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );	
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );	
	
	
	if( getTime() - level.lastDialogTime > 10000 )
	{
		maps\mp\gametypes\_globallogic::leaderDialog( "wereturn_flag", team );
		maps\mp\gametypes\_globallogic::leaderDialog( "theyreturn_flag", otherTeam );
		level.lastDialogTime = getTime();
	}
}


onCapture( player )
{
	team = player.pers["team"];
	enemyTeam = getOtherTeam( team );
	
	playerTeamsFlag = level.teamFlags[team];
	
	// is players team flag away from base?
	if ( playerTeamsFlag maps\mp\gametypes\_gameobjects::isObjectAwayFromHome() && level.touchReturn )
	{
		return;
	}

	printAndSoundOnEveryone( team, enemyTeam, &"MP_ENEMY_FLAG_CAPTURED_BY", &"MP_FLAG_CAPTURED_BY", "mp_obj_captured", "mp_enemy_obj_captured", player );

	thread playSoundOnPlayers( "mx_CTF_score"+"_"+level.teamPrefix[team] );
	if( getTime() - level.lastDialogTime > 10000 )
	{
		maps\mp\gametypes\_globallogic::leaderDialog( "wecap_flag", team );
		maps\mp\gametypes\_globallogic::leaderDialog( "theycap_flag", enemyTeam );
		level.lastDialogTime = getTime();
	}

	
	player setStatLBByName( "CTF_Flags", 1, "Captured");
	
	player logString( enemyTeam + " flag captured" );
	
	flag = player.carryObject;
	
	flag.dontAnnounceReturn = true;
	flag maps\mp\gametypes\_gameobjects::returnHome();
	flag.dontAnnounceReturn = undefined;
	
	level.teamFlags[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	level.teamFlags[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	level.teamFlags[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::returnHome();
	level.teamFlagZones[level.otherTeam[team]] maps\mp\gametypes\_gameobjects::allowUse( "friendly" );

	player.isFlagCarrier = false;
	player deleteBaseIcon();

	[[level._setTeamScore]]( team, [[level._getTeamScore]]( team ) + 1 );

	if( game["teamScores"]["allies"] == level.scoreLimit - 1 || game["teamScores"]["axis"] == level.scoreLimit - 1 )
		setMusicState( "MATCH_END" );

	thread giveFlagCaptureXP( player );
}

giveFlagCaptureXP( player )
{
	wait .05;
	player thread [[level.onXPEvent]]( "capture" );
	maps\mp\gametypes\_globallogic::givePlayerScore( "capture", player );
}

onReset()
{	
	update_hints();

	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
	level.teamFlagZones[team] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	level.teamFlagZones[team] maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
}

getOtherFlag( flag )
{
	if ( flag == level.flags[0] )
	 	return level.flags[1];
	 	
	return level.flags[0];
}

// give each spawn point a baseline score for each objective flag,
// based on whether or not player will be looking in the direction of that flag upon spawning
generate_baseline_spawn_point_scores()
{
	k_maximum_spawn_to_flag_view_angle_degrees= 30.0;
	k_visible_spawn_score= level.spawnsystem.objective_facing_bonus;
	k_not_visible_spawn_score= 0.0;
	
	// for each flag, give every spawn point entity a baseline score for each ctf flag
	spawn_point_collection= [];
	spawn_point_collection[spawn_point_collection.size]= maps\mp\gametypes\_spawning::gatherSpawnEntities(level.teams[spawn_point_collection.size]);
	spawn_point_collection[spawn_point_collection.size]= maps\mp\gametypes\_spawning::gatherSpawnEntities(level.teams[spawn_point_collection.size]);
	
	for (collection_index= 0; collection_index<spawn_point_collection.size; collection_index++)
	{
		for (spawn_point_index= 0; spawn_point_index<spawn_point_collection[collection_index].a.size; spawn_point_index++)
		{
			spawn_point_entity= spawn_point_collection[collection_index].a[spawn_point_index];
			spawn_point_entity.flag_desirability= [];
			spawn_point_origin= spawn_point_entity GetOrigin();
			spawn_point_facing= AnglesToForward(spawn_point_entity GetAngles());
			
			// score spawn point for each flag based on visibility of flag from the spawn facing angles
			// for each flag, give every spawn point entity a baseline score for each ctf flag
			for (flag_index= 0; flag_index<level.flagZones.size; flag_index++)
			{
				flag_team= level.flagZones[flag_index] maps\mp\gametypes\_gameobjects::GetOwnerTeam();
				flag_origin= level.flagZones[flag_index].trigger GetOrigin();
				spawn_point_to_flag= vector3d_from_points(spawn_point_origin, flag_origin);
				spawn_to_flag_view_angle_degrees= vector3d_angle_between(spawn_point_facing, spawn_point_to_flag);
				
				if (Abs(spawn_to_flag_view_angle_degrees)<=k_maximum_spawn_to_flag_view_angle_degrees)
				{
					spawn_point_entity.flag_desirability[flag_team]= k_visible_spawn_score;
				}
				else
				{
					spawn_point_entity.flag_desirability[flag_team]= k_not_visible_spawn_score;
				}
			}
		}
	}
	
	return;
}

//float
// returns a score based on the visibility of the target flag
// from this spawn point's angles (see generate_baseline_spawn_point_scores())
ctfPlayerSpawnGenerateSpawnPointEntityBaseScore(
	player_entity,
	spawn_point_entity)
{
	score= 0.0;
	
	if (IsDefined(spawn_point_entity.flag_desirability))
	{
		// in CTF, spawn points are placed for a specific team
		// so, based on what ever team the input spawn point belongs to,
		// the target flag team must be the 'other' team
		spawn_team=  player_entity.pers["team"];
		target_flag_team= GetOtherTeam(spawn_team);
		
		if (IsDefined(spawn_point_entity.flag_desirability) &&
			IsDefined(spawn_point_entity.flag_desirability[target_flag_team]))
		{
			score= spawn_point_entity.flag_desirability[target_flag_team];
		}
	}
	
	return score;
}

// spawning influencer generation callback
// return an array of influencer structs
ctfPlayerSpawnGenerateInfluencers(
	player_entity, // the player who wants to spawn
	spawn_influencers) // reference to an influencer array struct
{
	spawnteam = player_entity.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	// ctf: influencer around friendly base
	ctf_friendly_base_influencer_score= level.spawnsystem.ctf_friendly_base_influencer_score;
	ctf_friendly_base_influencer_score_curve= level.spawnsystem.ctf_friendly_base_influencer_score_curve;
	ctf_friendly_base_influencer_radius= level.spawnsystem.ctf_friendly_base_influencer_radius;
	
	// ctf: influencer around enemy base
	ctf_enemy_base_influencer_score= level.spawnsystem.ctf_enemy_base_influencer_score;
	ctf_enemy_base_influencer_score_curve= level.spawnsystem.ctf_enemy_base_influencer_score_curve;
	ctf_enemy_base_influencer_radius= level.spawnsystem.ctf_enemy_base_influencer_radius;
	
	// ctf: negative influencer around carrier
	ctf_carrier_influencer_score= level.spawnsystem.ctf_carrier_influencer_score;
	ctf_carrier_influencer_score_curve= level.spawnsystem.ctf_carrier_influencer_score_curve;
	ctf_carrier_influencer_radius= level.spawnsystem.ctf_carrier_influencer_radius;
	
	// create influencers around bases
	for (flag_zone_index= 0; flag_zone_index<level.flagZones.size; flag_zone_index++)
	{
		flag_zone= level.flagZones[flag_zone_index];
		flag_zone_team= flag_zone maps\mp\gametypes\_gameobjects::getOwnerTeam();
		flag_zone_trigger= flag_zone.trigger;
		flag_zone_origin= flag_zone_trigger GetOrigin();
		
		if (maps\mp\gametypes\_spawning::teams_have_enmity(spawnteam, flag_zone_team))
		{
			score= ctf_enemy_base_influencer_score;
			score_curve= ctf_enemy_base_influencer_score_curve;
			radius= ctf_enemy_base_influencer_radius;
		}
		else
		{
			score= ctf_friendly_base_influencer_score;
			score_curve= ctf_friendly_base_influencer_score_curve;
			radius= ctf_friendly_base_influencer_radius;
		}
		
		spawn_influencers.a[spawn_influencers.a.size]= create_sphere_influencer(
			"game_mode", // type
			( 1.0, 0.0, 0.0 ), // forward
			( 0.0, 0.0, 1.0 ), // up
			flag_zone_origin, // origin
			score, // score
			score_curve, // score_curve
			radius); // radius,
	}
	
	// create influencer around carriers
	if (IsDefined(level.flags))
	{
		for (flag_index= 0; flag_index<level.flags.size; flag_index++)
		{
			flag= level.flags[flag_index];
			
			if (IsDefined(flag.carrier))
			{
				carrier_angles= flag.carrier GetAngles();
				carrier_position= flag.carrier GetOrigin();
				
				spawn_influencers.a[spawn_influencers.a.size]= create_sphere_influencer(
					"game_mode", // type
					AnglesToForward(carrier_angles), // forward
					AnglesToUp(carrier_angles), // up
					carrier_position, // origin
					ctf_carrier_influencer_score, // score
					ctf_carrier_influencer_score_curve, // score_curve
					ctf_carrier_influencer_radius); // radius
			}
		}
	}
	
	return spawn_influencers;
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isDefined( self.isFlagCarrier ) || !self.isFlagCarrier )
		return;

	if ( isDefined( attacker ) && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
	{
		attacker thread [[level.onXPEvent]]( "kill_carrier" );
		maps\mp\gametypes\_globallogic::givePlayerScore( "kill_carrier", attacker );
	}
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

returnFlagAfterTimeMsg( time )
{
	if ( level.touchReturn )
		return;
		
	result = returnFlagHudElems( time );
	
	clearReturnFlagHudElems();
	
	if ( !isdefined( result ) ) // returnFlagHudElems hit an endon
		return;
	
//	self returnFlag();
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
	
	if( time <= 0 )
		return false;
	else
		wait time;
	
	return true;
}

clearReturnFlagHudElems()
{
	ownerteam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	level.ReturnMessageElems["allies"][ownerteam].alpha = 0;
	level.ReturnMessageElems["axis"][ownerteam].alpha = 0;
}

resetFlagBaseEffect()
{
	// dont spawn first frame
	wait (0.1);
	
	if ( isdefined( self.baseeffect ) )
		self.baseeffect delete();
	
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	if ( team != "axis" && team != "allies" )
		return;
	
	fxid = level.flagBaseFXid[ team ];

	self.baseeffect = spawnFx( fxid, self.baseeffectpos, self.baseeffectforward, self.baseeffectright );
	
	triggerFx( self.baseeffect );
}

turn_on()
{
	if ( level.hardcoreMode )
		return;
		
	self.origin = self.original_origin;
}

turn_off()
{
	self.origin = ( self.original_origin[0], self.original_origin[1], self.original_origin[2] - 10000);
}

update_hints()
{
	allied_flag = level.teamFlags["allies"];
	axis_flag = level.teamFlags["axis"];

	if ( isdefined(allied_flag.carrier) )
		allied_flag.carrier updateBaseIcon();
			
	if ( isdefined(axis_flag.carrier) )
		axis_flag.carrier updateBaseIcon();
			
	if ( !level.touchReturn )
		return;

	if ( isdefined(allied_flag.carrier) && axis_flag maps\mp\gametypes\_gameobjects::isObjectAwayFromHome() )
	{
		level.flagHints["axis"] turn_on();		
	}
	else
	{
		level.flagHints["axis"] turn_off();
	}		
	
	if ( isdefined(axis_flag.carrier) && allied_flag maps\mp\gametypes\_gameobjects::isObjectAwayFromHome() )
	{
		level.flagHints["allies"] turn_on();		
	}
	else
	{
		level.flagHints["allies"] turn_off();
	}		
}

claim_trigger( trigger )
{
	self endon("disconnect");
	self ClientClaimTrigger( trigger );
	
	self waittill("drop_object");
	self ClientReleaseTrigger( trigger );
}

setupBaseIcon()
{
	zone = level.teamFlagZones[self.pers["team"]];
	self.ctfBaseIcon = newClientHudElem( self );
	self.ctfBaseIcon.x = zone.trigger.origin[0];
	self.ctfBaseIcon.y = zone.trigger.origin[1];
	self.ctfBaseIcon.z = zone.trigger.origin[2] + 100;
	self.ctfBaseIcon.alpha = 1; // needs to be solid to obscure flag icon
	self.ctfBaseIcon.baseAlpha = 1;
	self.ctfBaseIcon.awayAlpha = 0.35;
	self.ctfBaseIcon.archived = true;
	self.ctfBaseIcon setShader( level.iconBase3D, level.objPointSize, level.objPointSize );
	self.ctfBaseIcon setWaypoint( true, level.iconBase3D );
	self.ctfBaseIcon.sort = 1; // make sure it sorts on top of the flag icon
}

deleteBaseIcon()
{
	self.ctfBaseIcon destroy();
	self.ctfBaseIcon = undefined;
}

updateBaseIcon()
{
	team = self.pers["team"];
	otherteam = getotherteam(team);
	
	flag = level.teamFlags[team];
	
	visible = false;
	if ( flag maps\mp\gametypes\_gameobjects::isObjectAwayFromHome() )
	{
		visible = true;
	}
	
	updateBaseIconVisibility( visible );
}

updateBaseIconVisibility( visible )
{
	// can hit here if a friendly team touches flag to return
	if ( !isdefined(self.ctfBaseIcon) )
		return;
		
	if ( visible )
	{
		self.ctfBaseIcon.alpha = self.ctfBaseIcon.awayAlpha;
		self.ctfBaseIcon.isShown = true;
	}
	else
	{
		self.ctfBaseIcon.alpha = self.ctfBaseIcon.baseAlpha;
		self.ctfBaseIcon.isShown = true;
	}
}

createFlagSpawnInfluencer()
{
	// ctf: influencer around friendly base
	ctf_friendly_base_influencer_score= level.spawnsystem.ctf_friendly_base_influencer_score;
	ctf_friendly_base_influencer_score_curve= level.spawnsystem.ctf_friendly_base_influencer_score_curve;
	ctf_friendly_base_influencer_radius= level.spawnsystem.ctf_friendly_base_influencer_radius;
	
	// ctf: influencer around enemy base
	ctf_enemy_base_influencer_score= level.spawnsystem.ctf_enemy_base_influencer_score;
	ctf_enemy_base_influencer_score_curve= level.spawnsystem.ctf_enemy_base_influencer_score_curve;
	ctf_enemy_base_influencer_radius= level.spawnsystem.ctf_enemy_base_influencer_radius;
	
	entityTeam = self.trigger.script_team;
	otherteam = getotherteam(entityTeam);
	team_mask = get_team_mask( entityTeam );
	other_team_mask = get_team_mask( otherteam );
	
	self.spawn_influencer_friendly = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 ctf_friendly_base_influencer_radius,
							 ctf_friendly_base_influencer_score,
							 team_mask,
							 maps\mp\gametypes\_spawning::get_score_curve_index(ctf_friendly_base_influencer_score_curve) );

	self.spawn_influencer_enemy = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 ctf_enemy_base_influencer_radius,
							 ctf_enemy_base_influencer_score,
							 other_team_mask,
							 maps\mp\gametypes\_spawning::get_score_curve_index(ctf_enemy_base_influencer_score_curve) );
}
