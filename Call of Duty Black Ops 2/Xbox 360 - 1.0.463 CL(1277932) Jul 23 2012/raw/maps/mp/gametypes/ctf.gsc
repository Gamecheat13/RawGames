#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

#insert raw\maps\mp\_clientflags.gsh;

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

#define OBJECTIVE_FLAG_AT_BASE 0
#define OBJECTIVE_FLAG_AWAY 1

main()
{
	if(GetDvar( "mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	
	registerTimeLimit( 0, 1440 );
	registerRoundLimit( 0, 10 );
	registerRoundWinLimit( 0, 10 );
	registerRoundSwitch( 0, 9 );
	registerNumLives( 0, 10 );
	registerScoreLimit( 0, 5000 );

	level.scoreRoundBased = ( GetGametypeSetting( "roundscorecarry" ) == false );
	
	maps\mp\gametypes\_weapons::registerGrenadeLauncherDudDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_weapons::registerThrownGrenadeDudDvar( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_weapons::registerKillstreakDelay( level.gameType, 0, 0, 1440 );

	maps\mp\gametypes\_globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );

	// One flag wins the match
	if ( IsDefined( game["ctf_overtime"] ) && game["ctf_overtime"] == 1 )
	{
		registerScoreLimit( 1, 1 );
	}

	if ( GetDvar( "scr_ctf_spawnPointFacingAngle") == "" )
		SetDvar("scr_ctf_spawnPointFacingAngle", "60");

	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onRoundSwitch = ::onRoundSwitch;
	level.onRoundEndGame = ::onRoundEndGame;
	level.gamemodeSpawnDvars = ::ctf_gamemodeSpawnDvars;
	level.getTeamKillPenalty = ::ctf_getTeamKillPenalty;
	level.getTeamKillScore = ::ctf_getTeamKillScore;

	if ( !isdefined( game["ctf_teamscore"] ) )
	{
		game["ctf_teamscore"]["allies"] = 0;
		game["ctf_teamscore"]["axis"] = 0;
	}
	
	game["dialog"]["gametype"] = "ctf_start";
	game["dialog"]["gametype_hardcore"] = "hcctf_start";
	game["dialog"]["wetake_flag"] = "ctf_wetake";
	game["dialog"]["theytake_flag"] = "ctf_theytake";
	game["dialog"]["theydrop_flag"] = "ctf_theydrop";
	game["dialog"]["wedrop_flag"] = "ctf_wedrop";
	game["dialog"]["wereturn_flag"] = "ctf_wereturn";
	game["dialog"]["theyreturn_flag"] = "ctf_theyreturn";
	game["dialog"]["theycap_flag"] = "ctf_theycap";
	game["dialog"]["wecap_flag"] = "ctf_wecap";
	game["dialog"]["offense_obj"] = "cap_start";
	game["dialog"]["defense_obj"] = "cap_start";

	level.lastDialogTime = getTime();	

	level thread ctf_icon_hide();

	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "deaths", "captures", "returns" ); 
}

onPrecacheGameType()
{
	game["flag_dropped_sound"] = "mp_war_objective_lost";
	game["flag_recovered_sound"] = "mp_war_objective_taken";
	
	precacheModel( maps\mp\teams\_teams::getTeamFlagModel( "allies" ) );
	precacheModel( maps\mp\teams\_teams::getTeamFlagModel( "axis" ) );
	precacheModel( maps\mp\teams\_teams::getTeamFlagCarryModel( "allies" ) );
	precacheModel( maps\mp\teams\_teams::getTeamFlagCarryModel( "axis" ) );

	precacheShader( maps\mp\teams\_teams::getTeamFlagIcon( "allies" ) );
	precacheShader( maps\mp\teams\_teams::getTeamFlagIcon( "axis" ) );
	
	precacheString(&"MP_FLAG_TAKEN_BY");
	precacheString(&"MP_ENEMY_FLAG_TAKEN");
	precacheString(&"MP_FRIENDLY_FLAG_TAKEN");
	precacheString(&"MP_FLAG_CAPTURED_BY");
	precacheString(&"MP_ENEMY_FLAG_CAPTURED_BY");
	precacheString(&"MP_FLAG_RETURNED_BY");
	precacheString(&"MP_FLAG_RETURNED");
	precacheString(&"MP_ENEMY_FLAG_RETURNED");
	precacheString(&"MP_FRIENDLY_FLAG_RETURNED");
	precacheString(&"MP_YOUR_FLAG_RETURNING_IN");
	precacheString(&"MP_ENEMY_FLAG_RETURNING_IN");
	precacheString(&"MP_FRIENDLY_FLAG_DROPPED_BY");
	precacheString(&"MP_FRIENDLY_FLAG_DROPPED");
	precacheString(&"MP_ENEMY_FLAG_DROPPED");
	precacheString(&"MP_SUDDEN_DEATH");
	precacheString(&"MP_CAP_LIMIT_REACHED");
	precacheString(&"MP_CTF_CANT_CAPTURE_FLAG" );
	precacheString(&"MP_CTF_OVERTIME_WIN" );
	PrecacheString( &"allies_base" );
	PrecacheString( &"axis_base" );
	PrecacheString( &"allies_flag" );
	PrecacheString( &"axis_flag" );
	
	game["strings"]["score_limit_reached"] = &"MP_CAP_LIMIT_REACHED";

}

onStartGameType()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	/#
	setdebugsideswitch(game["switchedsides"]);
	#/
	
	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic_score::resetTeamScores();

	setObjectiveText( "allies", &"OBJECTIVES_CTF" );
	setObjectiveText( "axis", &"OBJECTIVES_CTF" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_CTF" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_CTF" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_CTF_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_CTF_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_CTF_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_CTF_HINT" );
			
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_ctf_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_ctf_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_ctf_spawn_allies" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_ctf_spawn_axis" );
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	level.spawn_axis = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_axis" );
	level.spawn_allies = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_ctf_spawn_allies" );

	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  maps\mp\gametypes\_spawnlogic::getSpawnpointArray("mp_ctf_spawn_" + team + "_start");
	}

	allowed[0] = "ctf";
	
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();

	thread updateGametypeDvars();
	
	thread ctf();
}

onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( level.roundScoreCarry == false ) 
	{
		[[level._setTeamScore]]( "allies", game["roundswon"]["allies"] );
		[[level._setTeamScore]]( "axis", game["roundswon"]["axis"] );
	}
	
	
	if( islastround() && level.roundScoreCarry == false )
	{
		// overtime! flipping a coin to see if we switch again
		// could figure out which rounds the "best" team did best on and then use that
		if (randomint(2) == 0)
		{
			game["switchedsides"] = !game["switchedsides"];
		}
		level.halftimeType = "overtime";

		// force this to be the last round
		level.forcedEnd = true;
		
		//First flag capture wins the match
		game["ctf_overtime"] = 1;
	}
	else
	{
		level.halftimeType = "halftime";
		game["switchedsides"] = !game["switchedsides"];
	}
}

onRoundEndGame( winningTeam )
{
	if ( level.roundScoreCarry == false ) 
	{
		foreach( team in level.teams )
		{
			[[level._setTeamScore]]( team, game["roundswon"][team] );
		}
	
		winner = maps\mp\gametypes\_globallogic::determineTeamWinnerByGameStat( "roundswon" );
	}
	else
	{
		winner = maps\mp\gametypes\_globallogic::determineTeamWinnerByTeamScore();
	}
	
	return winner;
}

onSpawnPlayerUnified()
{
	self.isFlagCarrier = false;
	self.flagCarried = undefined;
	self ClearClientFlag( CLIENT_FLAG_CTF_CARRIER );
	
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}

onSpawnPlayer(predictedSpawn)
{
	self.isFlagCarrier = false;
	self.flagCarried = undefined;
	self ClearClientFlag( CLIENT_FLAG_CTF_CARRIER );

	spawnteam = self.pers["team"];
	// TODO MTEAM - switched sides
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	if ( level.useStartSpawns )
	{
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_start[spawnteam]);
	}	
	else
	{
		if (spawnteam == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_axis);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam(level.spawn_allies);
	}

	assert( isDefined(spawnpoint) );

	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		self spawn( spawnPoint.origin, spawnPoint.angles, "ctf" );
	}
}

updateGametypeDvars()
{
	level.idleFlagReturnTime = GetGametypeSetting( "idleFlagResetTime" );
	level.flagRespawnTime = GetGametypeSetting( "flagRespawnTime" );
	level.touchReturn = GetGametypeSetting( "touchReturn" );
	level.enemyCarrierVisible = GetGametypeSetting( "enemyCarrierVisible" );
	level.roundLimit = GetGametypeSetting( "roundLimit" );
	level.roundScoreCarry = GetGametypeSetting( "roundscorecarry" );
	
	level.teamKillPenaltyMultiplier = GetGametypeSetting( "teamKillPenalty" );
	level.teamKillScoreMultiplier = GetGametypeSetting( "teamKillScore" );

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
	// TODO MTEAM - switched sides
	if ( game["switchedsides"] )
		entityTeam = getOtherTeam( entityTeam );

	visuals[0] setModel( maps\mp\teams\_teams::getTeamFlagModel( entityTeam ) );
	visuals[0] SetTeam( entityTeam );

	flag = maps\mp\gametypes\_gameobjects::createCarryObject( entityTeam, trigger, visuals, (0,0,100), istring(entityTeam+"_flag") );
	flag maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	flag maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	flag maps\mp\gametypes\_gameobjects::setVisibleCarrierModel( maps\mp\teams\_teams::getTeamFlagCarryModel( entityTeam ) );
	flag maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconDefend2D );
	flag maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	flag maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );
	flag maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
	flag maps\mp\gametypes\_gameobjects::setCarryIcon( maps\mp\teams\_teams::getTeamFlagIcon( entityTeam ) );

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
	// TODO MTEAM - switched sides
	if ( game["switchedsides"] )
		entityTeam = getOtherTeam( entityTeam );

	flagZone = maps\mp\gametypes\_gameobjects::createUseObject( entityTeam, trigger, visuals, (0,0,100), istring(entityTeam+"_base") );
	flagZone maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	flagZone maps\mp\gametypes\_gameobjects::setUseTime( 0 );
	flagZone maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_FLAG" );
	flagZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "friendly" );

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
	
	flagZone createFlagSpawnInfluencer( entityTeam );
	
	return flagZone;
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
	
	level.iconCapture3D = "waypoint_grab_red";
	level.iconCapture2D = "waypoint_grab_red";
	level.iconDefend3D = "waypoint_defend_flag";
	level.iconDefend2D = "waypoint_defend_flag";
	level.iconDropped3D = "waypoint_defend_flag";
	level.iconDropped2D = "waypoint_defend_flag";
	level.iconReturn3D = "waypoint_return_flag";
	level.iconReturn2D = "waypoint_return_flag";
	level.iconBase3D = "waypoint_defend_flag";
	level.iconEscort3D = "waypoint_escort";
	level.iconEscort2D = "waypoint_escort";
	level.iconKill3D = "waypoint_kill";
	level.iconKill2D = "waypoint_kill";
	level.iconWaitForFlag3D = "waypoint_waitfor_flag";
	
	precacheShader( level.iconCapture3D );
	precacheShader( level.iconCapture2D );

	precacheShader( level.iconDefend3D );
	precacheShader( level.iconDefend2D );

	precacheShader( level.iconDropped3D );
	precacheShader( level.iconDropped2D );

	precacheShader( level.iconBase3D );

	precacheShader( level.iconReturn3D );
	precacheShader( level.iconReturn2D );

	precacheShader( level.iconEscort3D );
	precacheShader( level.iconEscort2D );

	precacheShader( level.iconKill3D );
	precacheShader( level.iconKill2D );

	precacheShader( level.iconWaitForFlag3D );

	level.flagBaseFXid = [];
	level.flagBaseFXid[ "allies" ] = loadfx( "misc/fx_ui_flagbase_" + game["allies"] );
	level.flagBaseFXid[ "axis"   ] = loadfx( "misc/fx_ui_flagbase_" + game["axis"] );

	flag_triggers = getEntArray( "ctf_flag_pickup_trig", "targetname" );
	if ( !isDefined( flag_triggers ) || flag_triggers.size != 2)
	{
		/#maps\mp\_utility::error("Not enough ctf_flag_pickup_trig triggers found in map.  Need two.");#/
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
		/#maps\mp\_utility::error("Not enough ctf_flag_zone_trig triggers found in map.  Need two.");#/
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

		facing_angle = GetDvarint( "scr_ctf_spawnPointFacingAngle");
		
		// the opposite team will want to face this point
		setspawnpointsbaseweight( getOtherTeamsMask(team), trigger.origin, facing_angle, level.spawnsystem.objective_facing_bonus);
	}
	
	// once all the flags have been registered with the game,
	// give each spawn point a baseline score for each objective flag,
	// based on whether or not player will be looking in the direction of that flag upon spawning
	//generate_baseline_spawn_point_scores();

	createReturnMessageElems();
}

//Runs each round, as function as restarted at the start of every round.
//Hides the flag status icons and the 2D and 3D icons from the player's view
ctf_icon_hide()
{
	level waittill ( "game_ended" );

	level.teamFlags["allies"] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	level.teamFlags["axis"] maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
}

removeInfluencers()
{
	if ( isDefined( self.spawn_influencer_enemy_carrier ) )
	{
		removeinfluencer( self.spawn_influencer_enemy_carrier );
		self.spawn_influencer_enemy_carrier = undefined;
	}
	if ( isDefined( self.spawn_influencer_friendly_carrier ) )
	{
		removeinfluencer( self.spawn_influencer_friendly_carrier );
		self.spawn_influencer_friendly_carrier = undefined;
	}
	if ( isDefined( self.spawn_influencer_dropped ) )
	{
		removeinfluencer( self.spawn_influencer_dropped );
		self.spawn_influencer_dropped = undefined;
	}
}

onDrop( player )
{
	if ( isDefined( player ) )
	{
		player ClearClientFlag( CLIENT_FLAG_CTF_CARRIER );
	}

	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	otherTeam = getOtherTeam( team );
	
	bbPrint( "mpobjective", "gametime %d objtype %s team %s", gettime(), "ctf_flagdropped", team );

	self.visuals[0] SetClientFlag( CLIENT_FLAG_FLAG_AWAY );
	
	if ( level.touchReturn )
	{
		self maps\mp\gametypes\_gameobjects::allowCarry( "any" );
		level.flagHints[otherTeam] turn_off();
	}
		
	if ( isDefined( player ) )
	{
		printAndSoundOnEveryone( team, undefined, &"", undefined, "mp_war_objective_lost" );	

		level thread maps\mp\_popups::DisplayTeamMessageToTeam( &"MP_FRIENDLY_FLAG_DROPPED", player, team );
		level thread maps\mp\_popups::DisplayTeamMessageToTeam( &"MP_ENEMY_FLAG_DROPPED", player, otherTeam );
	}
	else
	{
		printAndSoundOnEveryone( team, undefined, &"", undefined, "mp_war_objective_lost" );		
	}
	
	if( getTime() - level.lastDialogTime > 1500 )
	{
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "wedrop_flag", otherTeam );
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "theydrop_flag", team );
		level.lastDialogTime = getTime();
	}

	if ( isDefined( player ) )
	 	player logString( team + " flag dropped" );
	else
	 	logString( team + " flag dropped" );

	if ( isDefined( player ) )
	{
		player playLocalSound("mpl_flag_drop_plr");
		//  Set MUSCSTATE to return to previous
		//player thread maps\mp\gametypes\_globallogic_audio::return_music_state_player();
	}


	maps\mp\gametypes\_globallogic_audio::play_2d_on_team( "mpl_flagdrop_sting_friend", otherTeam );
	maps\mp\gametypes\_globallogic_audio::play_2d_on_team( "mpl_flagdrop_sting_enemy", team );

	if ( level.touchReturn )
	{
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconReturn3D );
		self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconReturn2D );
	}
	else
	{
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDropped3D );
		self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconDropped2D );
	}	
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );

	thread maps\mp\_utility::playSoundOnPlayers( game["flag_dropped_sound"], game["attackers"] );

	self thread returnFlagAfterTimeMsg( level.idleFlagReturnTime );	
	
	// remove carrier influencers
	if ( isDefined( player ) )
	{
		self removeInfluencers();
	}
	else
	{	// influencers on the player have already been freed
		self.spawn_influencer_friendly_carrier = undefined;
		self.spawn_influencer_enemy_carrier = undefined;
	}
		
	
	// create new influencers on the flag
	ss = level.spawnsystem;
	player_team_mask = getTeamMask( otherTeam );	// this is the player that has the flag's team
	enemy_team_mask = getTeamMask( team );	// and his enemies

	if ( isDefined( player ) )
		flag_origin = player.origin;
	else
		flag_origin = self.curorigin;
	
	self.spawn_influencer_dropped = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 flag_origin, 
							 ss.ctf_dropped_influencer_radius,
							 ss.ctf_dropped_influencer_score,
							 player_team_mask|enemy_team_mask,
							 "ctf_flag_dropped,r,s",
							 maps\mp\gametypes\_spawning::get_score_curve_index(ss.ctf_dropped_influencer_score_curve),
							 level.idleFlagReturnTime,
							 self.trigger );
}


onPickup( player )
{
	carrierKilledBy = self.carrierKilledBy;
	self.carrierKilledBy = undefined;
	if ( isdefined( self.spawn_influencer_dropped ) )
	{
		removeinfluencer( self.spawn_influencer_dropped );
		self.spawn_influencer_dropped = undefined;
	}

	player AddPlayerStatWithGameType( "PICKUPS", 1 );
	
	//maps\mp\_scoreevents::processScoreEvent( "flag_grab", player );
	
	if ( level.touchReturn )
	{
		self maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	}

	// always clear influencers. we'll create new ones if it's been picked up by an enemy.
	self removeInfluencers();

	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	otherTeam = getOtherTeam( team );

	self clearReturnFlagHudElems();		

	if ( isDefined( player ) && player.pers["team"] == team )
	{	
		self notify("picked_up");

		printAndSoundOnEveryone( team, undefined, &"", undefined, "mp_obj_returned" );
	
		if( isdefined(player.pers["returns"]) )
		{
			player.pers["returns"]++;
			player.returns = player.pers["returns"];
		}
		if ( isdefined(carrierKilledBy) && carrierKilledBy == player ) 
		{
			maps\mp\_scoreevents::processScoreEvent( "flag_carrier_kill_return_close", player, undefined, undefined, true );
		}
		else
		{
			maps\mp\_scoreevents::processScoreEvent( "flag_return", player, undefined, undefined, true );
		}
		maps\mp\_demo::bookmark( "event", gettime(), player );

		player AddPlayerStatWithGameType( "RETURNS", 1 );

		level thread maps\mp\_popups::DisplayTeamMessageToTeam( &"MP_FRIENDLY_FLAG_RETURNED", player, team );
		level thread maps\mp\_popups::DisplayTeamMessageToTeam( &"MP_ENEMY_FLAG_RETURNED", player, otherTeam );

		self.visuals[0] ClearClientFlag( CLIENT_FLAG_FLAG_AWAY );
		self maps\mp\gametypes\_gameobjects::setFlags( OBJECTIVE_FLAG_AT_BASE );
		
		bbPrint( "mpobjective", "gametime %d objtype %s team %s", gettime(), "ctf_flagreturn", team );
		player recordgameevent("return");	
		
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
		bbPrint( "mpobjective", "gametime %d objtype %s team %s", gettime(), "ctf_flagpickup", team );
		player recordgameevent("pickup");

		maps\mp\_scoreevents::processScoreEvent( "flag_grab", player, undefined, undefined, true );
		maps\mp\_demo::bookmark( "event", gettime(), player );
	
		printAndSoundOnEveryone( otherteam, undefined, &"", undefined, "mp_obj_taken", "mp_enemy_obj_taken" );

		level thread maps\mp\_popups::DisplayTeamMessageToTeam( &"MP_FRIENDLY_FLAG_TAKEN", player, team );
		level thread maps\mp\_popups::DisplayTeamMessageToTeam( &"MP_ENEMY_FLAG_TAKEN", player, otherTeam );

		if( getTime() - level.lastDialogTime > 1500 )
		{
			maps\mp\gametypes\_globallogic_audio::leaderDialog( "wetake_flag", otherTeam );

			maps\mp\gametypes\_globallogic_audio::leaderDialog( "theytake_flag", team );
			level.lastDialogTime = getTime();
		}
	
		player.isFlagCarrier = true;
		player.flagCarried = self;
		player playLocalSound("mpl_flag_pickup_plr");
		player SetClientFlag( CLIENT_FLAG_CTF_CARRIER );
		self maps\mp\gametypes\_gameobjects::setFlags( OBJECTIVE_FLAG_AWAY );
	
		maps\mp\gametypes\_globallogic_audio::play_2d_on_team( "mpl_flagget_sting_friend", otherTeam );
		maps\mp\gametypes\_globallogic_audio::play_2d_on_team( "mpl_flagget_sting_enemy", team );
		//thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "CTF_WE_TAKE", otherTeam, false, false, 5 );
		//thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "CTF_THEY_TAKE", team, false, false, 5 );
		//level thread OnPickupMusicState( player );
		
		if ( level.enemyCarrierVisible )
		{
			self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		}
		else
		{
			self maps\mp\gametypes\_gameobjects::setVisibleTeam( "enemy" );
		}

		self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconKill2D );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconKill3D );
		self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconEscort2D );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconEscort3D );

		player thread claim_trigger( level.flagHints[otherTeam] );
		
		update_hints();

		player logString( team + " flag taken" );
		
		ss = level.spawnsystem;
		player_team_mask = getTeamMask( otherTeam );	// this is the player that has the flag's team
		enemy_team_mask = getTeamMask( team );	// and his enemies
		
		self.spawn_influencer_enemy_carrier = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
								 player.origin, 
								 ss.ctf_enemy_carrier_influencer_radius,
								 ss.ctf_enemy_carrier_influencer_score,
								 enemy_team_mask,
								 "ctf_flag_enemy_carrier,r,s",
								 maps\mp\gametypes\_spawning::get_score_curve_index(ss.ctf_enemy_carrier_influencer_score_curve),
								 0,
								 player );

		self.spawn_influencer_friendly_carrier = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
								 player.origin, 
								 ss.ctf_friendly_carrier_influencer_radius,
								 ss.ctf_friendly_carrier_influencer_score,
								 player_team_mask,
								 "ctf_flag_friendly_carrier,r,s",
								 maps\mp\gametypes\_spawning::get_score_curve_index(ss.ctf_friendly_carrier_influencer_score_curve),
								 0,
								 player );
		
	}
	
}
OnPickupMusicState ( player )
{
	self endon( "disconnect" );
	self endon( "death" );
	
	// wait 6 seconds and see if the player still has the flag.
	wait (6);
	if (player.isFlagCarrier)
	{
		//Was the SUSPENSE state changes to ACTION - removed state CDC - 6/19/12
		//player thread maps\mp\gametypes\_globallogic_audio::set_music_on_player( "ACTION", false, false);
	}
}	
isHome()
{
	if ( isDefined( self.carrier ) )
		return false;

	if ( self.curOrigin != self.trigger.baseOrigin )
		return false;
		
	return true;
}

returnFlag()
{
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	otherTeam = getOtherTeam(team);
	
	maps\mp\gametypes\_globallogic_audio::play_2d_on_team( "mpl_flagreturn_sting", team );
	maps\mp\gametypes\_globallogic_audio::play_2d_on_team( "mpl_flagreturn_sting", otherTeam );
	
	level.teamFlagZones[otherTeam] maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	level.teamFlagZones[otherTeam] maps\mp\gametypes\_gameobjects::setVisibleTeam( "friendly" );

	update_hints();
	
	if ( level.touchReturn )
	{
		self maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	}
	self maps\mp\gametypes\_gameobjects::returnHome();
	self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	//TODO: Add 2D Icons
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconDefend2D );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );	
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );
	
	if( getTime() - level.lastDialogTime > 1500 )
	{
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "wereturn_flag", team );
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "theyreturn_flag", otherTeam );
		level.lastDialogTime = getTime();
	}
}


onCapture( player )
{
	team = player.pers["team"];
	enemyTeam = getOtherTeam( team );
	
	playerTeamsFlag = level.teamFlags[team];
	
	if ( playerTeamsFlag maps\mp\gametypes\_gameobjects::isObjectAwayFromHome() )
	{
		return;
	}

	printAndSoundOnEveryone( team, undefined, &"", undefined, "mp_obj_captured", "mp_enemy_obj_captured" );
	bbPrint( "mpobjective", "gametime %d objtype %s team %s", gettime(), "ctf_flagcapture", enemyTeam ); // flag BELONGS to enemyTeam

	game["challenge"][team]["capturedFlag"] = true;
	
	if( isdefined(player.pers["captures"]) )
	{
		player.pers["captures"]++;
		player.captures = player.pers["captures"];
	}

	maps\mp\_demo::bookmark( "event", gettime(), player );
	player AddPlayerStatWithGameType( "CAPTURES", 1 );

	level thread maps\mp\_popups::DisplayTeamMessageToTeam( &"MP_ENEMY_FLAG_CAPTURED", player, team );
	level thread maps\mp\_popups::DisplayTeamMessageToTeam( &"MP_FRIENDLY_FLAG_CAPTURED", player, enemyTeam );
	
// Changing to Music system
	if( getTime() - level.lastDialogTime > 1500 )
	{
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "wecap_flag", team );
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "theycap_flag", enemyTeam );
		level.lastDialogTime = getTime();
	}

	maps\mp\gametypes\_globallogic_audio::play_2d_on_team( "mpl_flagcapture_sting_enemy", enemyTeam );
	maps\mp\gametypes\_globallogic_audio::play_2d_on_team( "mpl_flagcapture_sting_friend", team );
	//thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "CTF_WE_SCORE", team, false, false  );
	//thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "CTF_THEY_SCORE", enemyTeam, false, false  );
	
	player thread giveFlagCaptureXP( player );

	player logString( enemyTeam + " flag captured" );

	flag = player.carryObject;
	
	flag.dontAnnounceReturn = true;
	flag maps\mp\gametypes\_gameobjects::returnHome();
	flag.dontAnnounceReturn = undefined;
	
	otherTeam = getOtherTeam(team);
		level.teamFlags[otherTeam] maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
		level.teamFlags[otherTeam] maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		level.teamFlags[otherTeam] maps\mp\gametypes\_gameobjects::returnHome();
		level.teamFlagZones[otherTeam] maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	
	player.isFlagCarrier = false;
	player.flagCarried = undefined;
	player ClearClientFlag( CLIENT_FLAG_CTF_CARRIER );

	// execution will stop on this line on last flag cap of a level
	maps\mp\gametypes\_globallogic_score::giveTeamScoreForObjective( team, 1 );

	flag removeInfluencers();

	// last round in a best of match is one flag cap only
	if ( waslastround() )
	{
		ctf_endGame( team, &"MP_CTF_OVERTIME_WIN" );
	}
}

ctf_endGame( winningTeam, endReasonText )
{
	[[level._setTeamScore]]( "allies", game["roundswon"]["allies"] );
	[[level._setTeamScore]]( "axis", game["roundswon"]["axis"] );
	maps\mp\gametypes\_globallogic_score::giveTeamScoreForObjective( winningTeam, 1 );
	
	thread maps\mp\gametypes\_globallogic::endGame( winningTeam, endReasonText );
}

giveFlagCaptureXP( player )
{
	wait .05;
	maps\mp\_scoreevents::processScoreEvent( "flag_capture", player, undefined, undefined, true );
	player recordgameevent("capture");
}

onReset()
{	
	update_hints();

	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.iconDefend3D );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.iconDefend2D );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.iconCapture3D );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.iconCapture2D );
	
	if ( level.touchReturn )
	{
		self maps\mp\gametypes\_gameobjects::allowCarry( "enemy" );
	}

	level.teamFlagZones[team] maps\mp\gametypes\_gameobjects::setVisibleTeam( "friendly" );
	level.teamFlagZones[team] maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	
	self.visuals[0] ClearClientFlag( CLIENT_FLAG_FLAG_AWAY );
	self maps\mp\gametypes\_gameobjects::setFlags( OBJECTIVE_FLAG_AT_BASE );
	self clearReturnFlagHudElems();
}

getOtherFlag( flag )
{
	if ( flag == level.flags[0] )
	 	return level.flags[1];
	 	
	return level.flags[0];
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if (  isdefined( attacker ) && isplayer( attacker ) && ( !isdefined( sWeapon ) || !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( sWeapon ) ) )
	{
		for ( index = 0; index < level.flags.size; index++ )
		{
			flagTeam = "invalidTeam";
			inFlagZone = false;
			defendedFlag = false;
			offendedFlag = false;

			flagCarrier = level.flags[index].carrier;
			if ( isdefined( flagCarrier ) )
			{
				flagOrigin = level.flags[index].carrier.origin;
				isCarried = true;

				if ( isPlayer( attacker ) && ( attacker.pers["team"] != self.pers["team"] ) ) 
				{
					if ( isdefined( level.flags[index].carrier.attackerData ) ) 
					{	
						if ( level.flags[index].carrier != attacker ) 
						{
							if ( isdefined( level.flags[index].carrier.attackerData[self.clientid] ) ) 
							{
								maps\mp\_scoreevents::processScoreEvent( "rescue_flag_carrier", attacker, undefined, sWeapon, true );
							}
						}
					}
				}
			}
			else 
			{
				flagOrigin = level.flags[index].curorigin;
				isCarried = false;
			}
				
			dist = Distance2d(self.origin, flagOrigin);
			if ( dist < level.defaultOffenseRadius )
			{
				inFlagZone = true;
				if ( level.flags[index].ownerteam == attacker.pers["team"] )
					defendedFlag = true;
				else
					offendedFlag = true;					
			}
			dist = Distance2d(attacker.origin, flagOrigin);
			if ( dist < level.defaultOffenseRadius )
			{
				inFlagZone = true;
				if ( level.flags[index].ownerteam == attacker.pers["team"] )
					defendedFlag = true;
				else
					offendedFlag = true;					
			}
			
			
			if ( inFlagZone && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
			{	
				if ( defendedFlag )
				{
					attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
	
					if ( isDefined( self.isFlagCarrier ) && self.isFlagCarrier )
					{
						maps\mp\_scoreevents::processScoreEvent( "kill_flag_carrier", attacker, undefined, sWeapon, true );
					}
					else
					{
						maps\mp\_scoreevents::processScoreEvent( "killed_attacker", attacker, undefined, sWeapon, true );
					}
	
					self recordKillModifier("assaulting");
				}
				if ( offendedFlag )
				{
					attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
					if ( isCarried == true ) 
					{
						if ( isdefined ( flagCarrier ) && attacker == flagCarrier ) 
						{
							maps\mp\_scoreevents::processScoreEvent( "killed_enemy_while_carrying_flag", attacker, undefined, sWeapon, true );
						}
						else
						{
							maps\mp\_scoreevents::processScoreEvent( "defend_flag_carrier", attacker, undefined, sWeapon, true );
						}
					}
					else
					{
						maps\mp\_scoreevents::processScoreEvent( "killed_defender", attacker, undefined, sWeapon, true );
					}
					self recordKillModifier("defending");
				}
			}
		}
	}

	if ( !isDefined( self.isFlagCarrier ) || !self.isFlagCarrier )
		return;

	if ( isDefined( attacker ) && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
	{
		if ( isdefined ( self.flagCarried ) ) 
		{
			for ( index = 0; index < level.flags.size; index++ )
			{
				currentFlag = level.flags[index];
				if ( currentFlag.ownerteam == self.team ) 
				{
					if ( currentFlag.curOrigin == currentFlag.trigger.baseOrigin )
					{
						dist = Distance2d(self.origin, currentFlag.curOrigin );
						if ( dist < level.defaultOffenseRadius )
						{	
							self.flagCarried.carrierKilledBy = attacker;
							break;
						}
					}
				}
			}
		}
		
		attacker recordgameevent("kill_carrier");	
		attacker thread maps\mp\_challenges::killedFlagCarrier();
		self recordKillModifier("carrying");
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

	self notify("returnFlagAfterTimeMsg");
	self endon("returnFlagAfterTimeMsg");
	
	result = returnFlagHudElems( time );
	
	self removeInfluencers();
	self clearReturnFlagHudElems();
	
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

createFlagSpawnInfluencer( entityTeam )
{
	// ctf: influencer around friendly base
	ctf_friendly_base_influencer_score= level.spawnsystem.ctf_friendly_base_influencer_score;
	ctf_friendly_base_influencer_score_curve= level.spawnsystem.ctf_friendly_base_influencer_score_curve;
	ctf_friendly_base_influencer_radius= level.spawnsystem.ctf_friendly_base_influencer_radius;
	
	// ctf: influencer around enemy base
	ctf_enemy_base_influencer_score= level.spawnsystem.ctf_enemy_base_influencer_score;
	ctf_enemy_base_influencer_score_curve= level.spawnsystem.ctf_enemy_base_influencer_score_curve;
	ctf_enemy_base_influencer_radius= level.spawnsystem.ctf_enemy_base_influencer_radius;
	
	otherteam = getotherteam(entityTeam);
	team_mask = getTeamMask( entityTeam );
	other_team_mask = getTeamMask( otherteam );
	
	self.spawn_influencer_friendly = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 ctf_friendly_base_influencer_radius,
							 ctf_friendly_base_influencer_score,
							 team_mask,
							 "ctf_friendly_base,r,s",
							 maps\mp\gametypes\_spawning::get_score_curve_index(ctf_friendly_base_influencer_score_curve) );

	self.spawn_influencer_enemy = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 ctf_enemy_base_influencer_radius,
							 ctf_enemy_base_influencer_score,
							 other_team_mask,
							 "ctf_enemy_base,r,s",
							 maps\mp\gametypes\_spawning::get_score_curve_index(ctf_enemy_base_influencer_score_curve) );
}

ctf_gamemodeSpawnDvars(reset_dvars)
{
	ss = level.spawnsystem;

	// ctf: influencer around friendly base
	ss.ctf_friendly_base_influencer_score =	set_dvar_float_if_unset("scr_spawn_ctf_friendly_base_influencer_score", "0", reset_dvars);
	ss.ctf_friendly_base_influencer_score_curve =	set_dvar_if_unset("scr_spawn_ctf_friendly_base_influencer_score_curve", "constant", reset_dvars);
	ss.ctf_friendly_base_influencer_radius =	set_dvar_float_if_unset("scr_spawn_ctf_friendly_base_influencer_radius", "" + 15.0*get_player_height(), reset_dvars);

	// ctf: influencer around enemy base
	ss.ctf_enemy_base_influencer_score =	set_dvar_float_if_unset("scr_spawn_ctf_enemy_base_influencer_score", "-500", reset_dvars);
	ss.ctf_enemy_base_influencer_score_curve =	set_dvar_if_unset("scr_spawn_ctf_enemy_base_influencer_score_curve", "constant", reset_dvars);
	ss.ctf_enemy_base_influencer_radius =	set_dvar_float_if_unset("scr_spawn_ctf_enemy_base_influencer_radius", "" + 15.0*get_player_height(), reset_dvars);
	
	// ctf: negative influencer around carrier
	ss.ctf_enemy_carrier_influencer_score =	set_dvar_float_if_unset("scr_spawn_ctf_enemy_carrier_influencer_score", "0", reset_dvars);
	ss.ctf_enemy_carrier_influencer_score_curve =	set_dvar_if_unset("scr_spawn_ctf_enemy_carrier_influencer_score_curve", "constant", reset_dvars);
	ss.ctf_enemy_carrier_influencer_radius =	set_dvar_float_if_unset("scr_spawn_ctf_enemy_carrier_influencer_radius", "" + 10.0*get_player_height(), reset_dvars);
	
	ss.ctf_friendly_carrier_influencer_score =	set_dvar_float_if_unset("scr_spawn_ctf_friendly_carrier_influencer_score", "0", reset_dvars);
	ss.ctf_friendly_carrier_influencer_score_curve =	set_dvar_if_unset("scr_spawn_ctf_friendly_carrier_influencer_score_curve", "constant", reset_dvars);
	ss.ctf_friendly_carrier_influencer_radius =	set_dvar_float_if_unset("scr_spawn_ctf_friendly_carrier_influencer_radius", "" + 8.0*get_player_height(), reset_dvars);
	
	ss.ctf_dropped_influencer_score =	set_dvar_float_if_unset("scr_spawn_ctf_dropped_influencer_score", "0", reset_dvars);
	ss.ctf_dropped_influencer_score_curve =	set_dvar_if_unset("scr_spawn_ctf_dropped_influencer_score_curve", "constant", reset_dvars);
	ss.ctf_dropped_influencer_radius =	set_dvar_float_if_unset("scr_spawn_ctf_dropped_influencer_radius", "" + 10.0*get_player_height(), reset_dvars);
}

ctf_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, sWeapon )
{
	teamkill_penalty = maps\mp\gametypes\_globallogic_defaults::default_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, sWeapon );

	if ( ( isdefined( self.isFlagCarrier ) && self.isFlagCarrier ) )
	{
		teamkill_penalty = teamkill_penalty * level.teamKillPenaltyMultiplier;
	}
	
	return teamkill_penalty;
}

ctf_getTeamKillScore( eInflictor, attacker, sMeansOfDeath, sWeapon )
{
	teamkill_score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	
	if ( ( isdefined( self.isFlagCarrier ) && self.isFlagCarrier ) )
	{
		teamkill_score = teamkill_score * level.teamKillScoreMultiplier;
	}
	
	return int(teamkill_score);
}


