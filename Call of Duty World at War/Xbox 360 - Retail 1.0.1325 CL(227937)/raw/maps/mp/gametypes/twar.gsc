#include maps\mp\_utility;
#include maps\mp\_geometry;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\_music;

/*
	Tank War
	Objective: 	Capture the enemies starting point by "walking" the capture points
	Map ends:	When one team captures the other teams starting point, or time limit is reached
	Respawning:	No wait / Near teammates

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_twar_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of owned flags, teammates and 
			enemies at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.
			Optionally, give a spawnpoint a script_linkto to specify which flag it "belongs" to (see Flag Descriptors).

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Flags:
			classname       trigger_radius
			targetname      flag_primary or flag_secondary
			Flags that need to be captured to win. Primary flags take time to capture; secondary flags are instant.
		
		Flag Descriptors:
			classname       script_origin
			targetname      twar_flag_descriptor
			Place one flag descriptor close to each flag. Use the script_linkname and script_linkto properties to say which flags
			it can be considered "adjacent" to in the level. For instance, if players have a primary path from flag1 to flag2, and 
			from flag2 to flag3, flag2 would have a twar_flag_descriptor with these properties:
			script_linkname flag2
			script_linkto flag1 flag3
			
			Set scr_domdebug to 1 to see flag connections and what spawnpoints are considered connected to each flag.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "japanese";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.

		If using minefields or exploders:
			maps\mp\_load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["american_soldiertype"] = "normandy";
			game["german_soldiertype"] = "normandy";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				american_soldiertype	normandy
				british_soldiertype		normandy, africa
				russian_soldiertype		coats, padded
				german_soldiertype		normandy, africa, winterlight, winterdark
*/

/*QUAKED mp_twar_spawn (0.0 0.0 1.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_twar_spawn_axis_start (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_twar_spawn_allies_start (0.0 1.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	if(getdvar("mapname") == "mp_background")
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	// register twar spawn influencer callback
	level.callbackPlayerSpawnGenerateInfluencers = ::twarPlayerSpawnGenerateInfluencers;
	level.callbackPlayerSpawnGenerateSpawnPointEntityBaseScore = ::twarPlayerSpawnGenerateSpawnPointEntityBaseScore;

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 15, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 2, 0, 2 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 10 );
	maps\mp\gametypes\_globallogic::registerRoundSwitchDvar( level.gameType, 1, 0, 9 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 5, 0, 5 );
	
	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onSpawnSpectator = ::onSpawnSpectator;
	level.playerSpawnedCB = ::twar_playerSpawnedCB;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onTimeLimit = ::onTimeLimit;
	level.onRespawnDelay = ::getRespawnDelay;
	level.onRoundSwitch = ::onRoundSwitch;
	level.onTeamOutcomeNotify = ::onTeamOutcomeNotify;
	level.onEndGame = ::onEndGame;
	level.getTimeLimitDvarValue = ::getTimeLimitDvarValue;

	level.endGameOnScoreLimit = false;

	level.flagSetupComplete = false;

	if ( getdvar("twar_captureTime") == "" )
		setdvar("twar_captureTime", "40");

	level.captureTime = getdvarint("twar_captureTime");

	if ( getdvar("twar_spawnPointFacingAngle") == "" )
		setdvar("twar_spawnPointFacingAngle", "60");

	if ( getdvar("twar_captureAccelBonus") == "" )
		setdvar("twar_captureAccelBonus", "25");

	if ( getdvar("twar_captureAccelBonus") == "" )
		setdvar("twar_captureAccelBonus", "25");

	if ( getdvar("twar_secondaryInfluencerBonus") == "" )
		setdvar("twar_secondaryInfluencerBonus", "0.5");

	if ( getdvar("twar_neutralFlagLockTime") == "" )
		setdvar("twar_neutralFlagLockTime", "10");

	if ( getdvar("twar_finalFightTimeLimit") == "" )
		setdvar("twar_finalFightTimeLimit", "5");

	if ( getdvar("twar_finalFightFlagRespawnPenalty") == "" )
		setdvar("twar_finalFightFlagRespawnPenalty", "3");

	if ( getdvar("twar_momentumEnabled") == "" )
		setdvar("twar_momentumEnabled", "0");

	if ( getdvar("twar_momentumMax") == "" )
		setdvar("twar_momentumMax", "70");

	if ( getdvar("twar_momentumMaxMultiplier") == "" )
		setdvar("twar_momentumMaxMultiplier", "3");

	if ( getdvar("twar_momentumMultiplierBonus") == "" )
		setdvar("twar_momentumMultiplierBonus", "25");

	if ( getdvar("twar_momentumMultiplierBonusLimit") == "" )
		setdvar("twar_momentumMultiplierBonusLimit", "75");

	if ( getdvar("twar_momentumBlitzkriegTime") == "" )
		setdvar("twar_momentumBlitzkriegTime", "30");

	if ( getdvar("twar_momentumFlagCap") == "" )
		setdvar("twar_momentumFlagCap", "25");

	if ( getdvar("twar_momentumKillPlayer") == "" )
		setdvar("twar_momentumKillPlayer", "5");

	if ( getdvar("twar_momentumRadar") == "" )
		setdvar("twar_momentumRadar", "10");

	if ( getdvar("twar_momentumArtillery") == "" )
		setdvar("twar_momentumArtillery", "10");

	if ( getdvar("twar_momentumDogs") == "" )
		setdvar("twar_momentumDogs", "10");

	if ( getdvar("twar_showEnemyCount") == "" )
		setdvar("twar_showEnemyCount", "1");

	setDvar( "war_sb", "" );

	level.objectiveFX = "waypoint_objpoint";
	level.objectiveCompassFX = "objective";

	level.flagHudFX = [];
	level.flagHudFX["marines"] = "hudicon_american_war";
	level.flagHudFX["marines_neutral"] = "hudicon_american_war_grey";
	level.flagHudFX["japanese"] = "hudicon_japanese_war";
	level.flagHudFX["japanese_neutral"] = "hudicon_japanese_war_grey";
	level.flagHudFX["german"] = "hudicon_german_war";
	level.flagHudFX["german_neutral"] = "hudicon_german_war_grey";
	level.flagHudFX["russian"] = "hudicon_russian_war";
	level.flagHudFX["russian_neutral"] = "hudicon_russian_war_grey";
	level.flagHudFX["neutral"] = "hudicon_american_war_grey";

	level.hudImageSize = 32;
	level.hudImageSpacing = 8;
	level.hudImageIncrease = 10;

	game["dialog"]["gametype"] = "war";
	game["dialog"]["offense_obj"] = "capture_conpts";
	game["dialog"]["defense_obj"] = "capture_conpts";
	game["dialog"]["blitz_friendly"] = "blitz_cheer_friendly";
	game["dialog"]["blitz_enemy"] = "blitz_cheer_enemy";
	game["dialog"]["momentum_enemy"] = "moment_cheer_enemy";
	game["dialog"]["momentum_friendly"] = "moment_cheer_friendly";
	level.lastDialogTime = getTime();
	level.lastProgress = 0;
	level.isLastFlag = false;
}


onPrecacheGameType()
{
	precacheShader( level.objectiveFX );
	precacheShader( level.objectiveCompassFX );	

	game["flagmodels"] = [];
	game["flagmodels"]["neutral"] = "prop_flag_neutral";

	if ( game["allies"] == "marines" )
		game["flagmodels"]["allies"] = "prop_flag_american";
	else
		game["flagmodels"]["allies"] = "prop_flag_russian";
	
	if ( game["axis"] == "german" ) 
		game["flagmodels"]["axis"] = "prop_flag_german"; 
	else
		game["flagmodels"]["axis"] = "prop_flag_japanese";
	
	precacheModel( game["flagmodels"]["neutral"] );
	precacheModel( game["flagmodels"]["allies"] );
	precacheModel( game["flagmodels"]["axis"] );

	precacheShader( level.flagHudFX[game["allies"]] );
	precacheShader( level.flagHudFX[game["allies"] + "_neutral"] );
	precacheShader( level.flagHudFX[game["axis"]] );
	precacheShader( level.flagHudFX[game["axis"] + "_neutral"] );

	precacheShader( "progress_bar_fg_small" );
	precacheShader( "progress_bar_bg_small" );

	precacheShader( "hud_momentum" );
	precacheShader( "hud_momentum_bonus" );
	precacheShader( "hud_momentum_bonus_detail" );
	precacheShader( "hud_momentum_blitzkrieg" );
	precacheShader( "hud_momentum_notification_bonus" );
	precacheShader( "hud_momentum_notification_blitzkrieg" );

	precacheString( &"MENU_WAR_STATUS_NEUTRAL_COOK" );
	precacheString( &"MP_END_OF_REGULATION" );
	precacheString( &"MP_MOMENTUM" );
	precacheString( &"MP_MOMENTUM_DESC" );
	precacheString( &"MP_MOMENTUM_LOST" );
	precacheString( &"MP_MOMENTUM_LOST_DESC" );
	precacheString( &"MP_BLITZKRIEG" );
	precacheString( &"MP_BLITZKRIEG_DESC" );
	precacheString( &"MP_CAPTURING_FLAG" );
	precacheString( &"MP_ENEMY_FLAG_CAPTURED_BY" );
	precacheString( &"MP_NEUTRAL_FLAG_CAPTURED_BY" );
	precacheString( &"MP_FRIENDLY_FLAG_CAPTURED_BY" );
	precacheString( &"MENU_WAR_STATUS_CONTESTED" );
	precacheString( &"MENU_WAR_STATUS_TAKING" );
	precacheString( &"MENU_WAR_STATUS_TAKEN" );
	precacheString( &"MP_ONEFLAGWINS" );
	precacheString( &"MP_FINALFIGHT" );
	precacheString( &"MP_WAR_TEAM_RESPAWN_PENALTY" );
	precacheString( &"MP_WAR_OTHERTEAM_RESPAWN_PENALTY" );
	precacheString( &"MP_WAR_NO_RESPAWN_PENALTY" );
	precacheString( &"MP_WAR_TEAMS_WERE_EVEN" );
	precacheString( &"MP_WAR_TEAM_WAS_LEADING" );
	precacheString( &"MP_WAR_OTHERTEAM_WAS_LEADING" );
	
	if ( !isDefined( game["strings_menu"] )  )
		game["strings_menu"] = [];

	if( !isDefined( game["strings"]["war_callsign_a"] ) || !isDefined( game["strings_menu"]["war_callsign_a"] ) )
	{
		game["strings"]["war_callsign_a"] = &"MPUI_CALLSIGN_A";
		game["strings_menu"]["war_callsign_a"] = "@MPUI_CALLSIGN_A";
	}
	precacheString( game["strings"]["war_callsign_a"] );

	if( !isDefined( game["strings"]["war_callsign_b"] ) || !isDefined( game["strings_menu"]["war_callsign_b"] ) )
	{
		game["strings"]["war_callsign_b"] = &"MPUI_CALLSIGN_B";
		game["strings_menu"]["war_callsign_b"] = "@MPUI_CALLSIGN_B";
	}
	precacheString( game["strings"]["war_callsign_b"] );

	if( !isDefined( game["strings"]["war_callsign_c"] ) || !isDefined( game["strings_menu"]["war_callsign_c"] ) )
	{
		game["strings"]["war_callsign_c"] = &"MPUI_CALLSIGN_C";
		game["strings_menu"]["war_callsign_c"] = "@MPUI_CALLSIGN_C";
	}
	precacheString( game["strings"]["war_callsign_c"] );

	if( !isDefined( game["strings"]["war_callsign_d"] ) || !isDefined( game["strings_menu"]["war_callsign_d"] ) )
	{
		game["strings"]["war_callsign_d"] = &"MPUI_CALLSIGN_D";
		game["strings_menu"]["war_callsign_d"] = "@MPUI_CALLSIGN_D";
	}
	precacheString( game["strings"]["war_callsign_d"] );

	if( !isDefined( game["strings"]["war_callsign_e"] ) || !isDefined( game["strings_menu"]["war_callsign_e"] ) )
	{
		game["strings"]["war_callsign_e"] = &"MPUI_CALLSIGN_E";
		game["strings_menu"]["war_callsign_e"] = "@MPUI_CALLSIGN_E";
	}
	precacheString( game["strings"]["war_callsign_e"] );

	game["war_momentum"]["allies"] = 0;
	game["war_momentum"]["allies_multiplier"] = 1;
	game["war_momentum"]["allies_blitzkriegTime"] = 0;
	game["war_momentum"]["axis"] = 0;
	game["war_momentum"]["axis_multiplier"] = 1;
	game["war_momentum"]["axis_blitzkriegTime"] = 0;

	setDvar( "war_a", game["strings_menu"]["war_callsign_a"] );
	setDvar( "war_b", game["strings_menu"]["war_callsign_b"] );
	setDvar( "war_c", game["strings_menu"]["war_callsign_c"] );
	setDvar( "war_d", game["strings_menu"]["war_callsign_d"] );
	setDvar( "war_e", game["strings_menu"]["war_callsign_e"] );
}


onRoundSwitch()
{
	level.halftimeType = "finalfight";
	level.halftimeSubCaption = &"MP_ONEFLAGWINS";
}

getTimeLimitDvarValue()
{
	if ( level.inFinalFight )
	{
		return maps\mp\gametypes\_globallogic::getValueInRange( getDvarFloat( "twar_finalFightTimeLimit" ), 0, 1440 );
	}

	return maps\mp\gametypes\_globallogic::getValueInRange( getDvarFloat( level.timeLimitDvar ), level.timeLimitMin, level.timeLimitMax );
}

onOvertime()
{
	level endon ( "game_ended" );

	level.timeLimitOverride = true;

	timeLimit = int( getDvarFloat( "twar_finalFightTimeLimit" ) * 60 );

	if ( timeLimit == 0 )
	{
		setGameEndTime( 0 );
	}
	else
	{
		waitTime = 0;
		while ( waitTime < timeLimit )
		{
			waitTime += 1;
			setGameEndTime( getTime() + ( ( timeLimit - waitTime ) * 1000 ) );
	
			wait ( 1.0 );
		}
	
		onTimeLimit();
	}	
}


onStartGameType()
{
	// for backwards compatibility
	allow_dom_object_placement= false;
	
	if ( game["roundsplayed"] == 0 )
	{
		level.inFinalFight = false;
	}
	else
	{
		level.inFinalFight = true;
	}

	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_TWAR" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_TWAR" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_TWAR" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_TWAR" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_TWAR_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_TWAR_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_TWAR_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_TWAR_HINT" );

	setClientNameMode("auto_change");

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	
	/* ---------- spawn point setup */
	
	// start spawn points: prefer twar-specific, fallback are dom points
	spawn_axis_start_classname= "mp_twar_spawn_axis_start";
	spawn_allies_start_classname= "mp_twar_spawn_allies_start";
	level.spawn_axis_start= GetEntArray(spawn_axis_start_classname, "classname" );
	level.spawn_allies_start= GetEntArray(spawn_allies_start_classname, "classname" );
	if (level.spawn_axis_start.size==0 || level.spawn_allies_start.size==0)
	{
		spawn_axis_start_classname= "mp_dom_spawn_axis_start";
		spawn_allies_start_classname= "mp_dom_spawn_allies_start";
		level.spawn_axis_start= GetEntArray(spawn_axis_start_classname, "classname" );
		level.spawn_allies_start= GetEntArray(spawn_allies_start_classname, "classname" );
		allow_dom_object_placement= true;
	}
	
	// re-spawn points: prefer twar-specific, fallback are tdm points
	spawn_all_classname= "mp_twar_spawn";
	level.spawn_all= GetEntArray(spawn_all_classname, "classname");
	if (level.spawn_all.size==0)
	{
		spawn_all_classname= "mp_dom_spawn";
		level.spawn_all= GetEntArray(spawn_all_classname, "classname");
		allow_dom_object_placement= true;
	}
	
	// place spawn points
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints(spawn_allies_start_classname);
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints(spawn_axis_start_classname);
	maps\mp\gametypes\_spawnlogic::addSpawnPoints("allies", spawn_all_classname);
	maps\mp\gametypes\_spawnlogic::addSpawnPoints("axis", spawn_all_classname);
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();

	/* ---------- */
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	level.startPos["allies"] = level.spawn_allies_start[0].origin;
	level.startPos["axis"] = level.spawn_axis_start[0].origin;

	level.spawnDelay = [];
	level.spawnDelay["axis"] = 0;
	level.spawnDelay["allies"] = 0;

	flagBaseFX = [];
	flagBaseFX["marines"] = "misc/ui_flagbase_blue";
	flagBaseFX["japanese"] = "misc/ui_flagbase_red";
	flagBaseFX["german"] = "misc/ui_flagbase_gold";
	flagBaseFX["russian"] = "misc/ui_flagbase_orange";
	flagBaseFX["neutral"] = "misc/ui_flagbase_silver";
	
	level.flagBaseFXid = [];
	level.flagBaseFXid["allies"] = loadfx( flagBaseFX[ game["allies"] ] );
	level.flagBaseFXid["axis"] = loadfx( flagBaseFX[ game["axis"] ] );
	level.flagBaseFXid["neutral"] = loadfx( flagBaseFX["neutral"]  );
	level.flagBaseFXid["spectator"] = loadfx( flagBaseFX[ game["allies"] ] );
	
	allowed[0] = "twar";
	// @TODO: Remove this when all maps are using twar spawn points
	// if this map has been updated to include twar spawns, don't import any domination objects
	// otherwise, continue to use dom spawns
	if (allow_dom_object_placement)
	{
		allowed[1]= "dom";
	}
	maps\mp\gametypes\_gameobjects::main(allowed);

	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();

	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_75", 4 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_50", 3 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist_25", 2 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 1 );

	maps\mp\gametypes\_rank::registerScoreInfo( "capture", 15 );

	maps\mp\gametypes\_rank::registerScoreInfo( "defend", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "defend_assist", 1 );

	maps\mp\gametypes\_rank::registerScoreInfo( "assault", 5 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assault_assist", 1 );

	level.objpoint_alpha_default = 0.75;
		
	thread twarFlags();
	level thread onPlayerConnect();
}


onTimeLimit()
{
	// reset the generic message bar so it does not persist past this game
	for ( index = 0; index < level.players.size; index++)
	{
		player = level.players[index];
		if ( IsDefined( player ) )
			player thread maps\mp\gametypes\_hud::showClientGenericMessageBar( undefined, undefined );
	}

	if ( !level.inFinalFight && 0 <= getDvarInt("twar_finalFightTimeLimit") )
	{
		thread maps\mp\gametypes\_globallogic::endGame( "endregulation", &"MP_END_OF_REGULATION" );

		alliesFlagCount = getTeamFlagCount( "allies" );
		switch ( alliesFlagCount )
		{
		case 0:
			game["war_spawndelay"]["allies"] = getDvarFloat("twar_finalFightFlagRespawnPenalty") * 2;
			break;

		case 1:
			game["war_spawndelay"]["allies"] = getDvarFloat("twar_finalFightFlagRespawnPenalty");
			break;

		default:
			game["war_spawndelay"]["allies"] = 0;
			break;
		}

		axisFlagCount = getTeamFlagCount( "axis" );
		switch ( axisFlagCount )
		{
		case 0:
			game["war_spawndelay"]["axis"] = getDvarFloat("twar_finalFightFlagRespawnPenalty") * 2;
			break;

		case 1:
			game["war_spawndelay"]["axis"] = getDvarFloat("twar_finalFightFlagRespawnPenalty");
			break;

		default:
			game["war_spawndelay"]["axis"] = 0;
			break;
		}
		
		game["war_momentum"]["allies"] = 0;
		game["war_momentum"]["allies_multiplier"] = 1;
		game["war_momentum"]["allies_blitzkriegTime"] = 0;
		game["war_momentum"]["axis"] = 0;
		game["war_momentum"]["axis_multiplier"] = 1;
		game["war_momentum"]["axis_blitzkriegTime"] = 0;
	}
	else
	{
		level.forcedEnd = true;
		
		// hacky but we want the updateWinLossStats call to go through
		level.roundLimit = 0;
		
		thread maps\mp\gametypes\_globallogic::endGame( "tie", game["strings"]["tie"] );
	}
}


onTeamOutcomeNotify( winner, isRound, endReasonText )
{
	self endon ( "disconnect" );
	self notify ( "reset_outcome" );

	team = self.pers["team"];
	if ( !isDefined( team ) || (team != "allies" && team != "axis") )
		team = "allies";

	// wait for notifies to finish
	while ( self.doingNotify )
		wait 0.05;

	self endon ( "reset_outcome" );
	
	if ( level.splitscreen )
	{
		titleSize = 2.0;
		textSize = 1.5;
		iconSize = 30;
		spacing = 10;
		font = "default";
	}
	else
	{
		titleSize = 3.0;
		textSize = 2.0;
		iconSize = 70;
		spacing = 20;
		font = "objective";
	}

	duration = 60000;

	outcomeTitle = createFontString( font, titleSize );
	outcomeTitle setPoint( "TOP", undefined, 0, 30 );
	outcomeTitle.glowAlpha = 1;
	outcomeTitle.hideWhenInMenu = false;
	outcomeTitle.archived = false;

	outcomeText = createFontString( font, 2.0 );
	outcomeText setParent( outcomeTitle );
	outcomeText setPoint( "TOP", "BOTTOM", 0, 0 );
	outcomeText.glowAlpha = 1;
	outcomeText.hideWhenInMenu = false;
	outcomeText.archived = false;
	
	if ( winner == "finalfight" || winner == "endregulation" )
	{
		outcomeTitle setText( &"MP_FINALFIGHT" );
		outcomeTitle.color = (1, 1, 1);
	}
	else if ( winner == "tie" )
	{
		if ( isRound )
			outcomeTitle setText( game["strings"]["round_draw"] );
		else
			outcomeTitle setText( game["strings"]["draw"] );
		outcomeTitle.color = (1, 1, 1);
	}
	else if ( isDefined( self.pers["team"] ) && winner == team )
	{
		if ( isRound )
			outcomeTitle setText( game["strings"]["round_win"] );
		else
			outcomeTitle setText( game["strings"]["victory"] );
		outcomeTitle.color = (0.6, 0.9, 0.6);
	}
	else
	{
		if ( isRound )
			outcomeTitle setText( game["strings"]["round_loss"] );
		else
			outcomeTitle setText( game["strings"]["defeat"] );
		outcomeTitle.color = (0.7, 0.3, 0.2);
	}
	
	outcomeText setText( endReasonText );
	
	outcomeTitle setPulseFX( 100, duration, 1000 );
	outcomeText setPulseFX( 100, duration, 1000 );

	teamIcon = undefined;
	upperMessageText = undefined;
	lowerMessageText = undefined;
	if ( winner == "finalfight" )
	{
		teamIcon = createIcon( game["icons"][team], iconSize, iconSize );
		teamIcon setParent( outcomeText );
		teamIcon setPoint( "TOP", "BOTTOM", 0, spacing );
		teamIcon.hideWhenInMenu = false;
		teamIcon.archived = false;
		teamIcon.alpha = 0;
		teamIcon fadeOverTime( 0.5 );
		teamIcon.alpha = 1;

		upperMessageText = createFontString( font, textSize );
		upperMessageText setParent( teamIcon );
		upperMessageText setPoint( "TOP", "BOTTOM", 0, spacing );
		upperMessageText.glowAlpha = 1;
		upperMessageText.hideWhenInMenu = false;
		upperMessageText.archived = false;
		upperMessageText setPulseFX( 100, duration, 1000 );

		lowerMessageText = createFontString( font, textSize );
		lowerMessageText setParent( upperMessageText );
		lowerMessageText setPoint( "TOP", "BOTTOM", 0, spacing );
		lowerMessageText.glowAlpha = 1;
		lowerMessageText.hideWhenInMenu = false;
		lowerMessageText.archived = false;
		lowerMessageText setPulseFX( 100, duration, 1000 );

		if ( getTeamScore( team ) < getTeamScore( level.otherTeam[team] ) )
		{
			upperMessageText setText( &"MP_WAR_OTHERTEAM_WAS_LEADING" );
			lowerMessageText setText( &"MP_WAR_TEAM_RESPAWN_PENALTY" );
		}
		else if ( getTeamScore( level.otherTeam[team] ) < getTeamScore( team ) )
		{
			upperMessageText setText( &"MP_WAR_TEAM_WAS_LEADING" );
			lowerMessageText setText( &"MP_WAR_OTHERTEAM_RESPAWN_PENALTY" );
		}
		else
		{
			upperMessageText setText( &"MP_WAR_TEAMS_WERE_EVEN" );
			lowerMessageText setText( &"MP_WAR_NO_RESPAWN_PENALTY" );
		}
	}

	matchBonus = undefined;
	if ( isDefined( self.matchBonus ) )
	{
		matchBonus = createFontString( font, 2.0 );
		matchBonus setParent( outcomeText );
		matchBonus setPoint( "TOP", "BOTTOM", 0, iconSize + (spacing * 3) );
		matchBonus.glowAlpha = 1;
		matchBonus.hideWhenInMenu = false;
		matchBonus.archived = false;
		matchBonus.label = game["strings"]["match_bonus"];
		matchBonus setValue( self.matchBonus );
	}
	
	self thread maps\mp\gametypes\_hud_message::resetTeamOutcomeNotify( outcomeTitle, outcomeText, teamIcon, undefined, upperMessageText, lowerMessageText, matchBonus );
}


getRespawnDelay()
{
	spawnDelay = undefined;

	self.lowerMessageOverride = undefined;
	
	if ( level.inFinalFight && game["war_spawndelay"][self.pers["team"]] )
	{
		spawnDelay = game["war_spawndelay"][self.pers["team"]];
	}

	return spawnDelay;
}

twar_sendDvarToAllPlayers( dvar, value, inc_count, time_inc )
{
	current_time_value = 0;
	for ( i = 0; i < level.players.size; i++ )
	{
		for ( players_this_inc = 0; players_this_inc < inc_count; players_this_inc++ )
		{
			level.players[i] thread twar_setClientDvar( dvar, value, current_time_value );
		}
		current_time_value += time_inc;
	}
}


twar_setClientDvar( dvar, value, time )
{
	if ( isdefined(time ) && time != 0 )
	{
		self endon("disconnect");
		wait(time);
	}
	
	self setClientDvar( dvar, value );
}

sendFlagCallsignDvar( label, dvar, time )
{
	if ( label == dvar )
	{
		time = 0;
	}
	
	self thread twar_setClientDvar( dvar, getDvar( dvar ), time );	// flag callsign
}

sendFlagCallsignDvars()
{
	contestedFlag = locate_contested_twar_flag();
	if ( isDefined ( contestedFlag ) && isDefined ( contestedFlag.useObj ) )
	{
		flaglabel = "war_" + contestedFlag.useObj.label;
	}
	else
	{
		flaglabel = "war_c";
	}
	
	self thread sendFlagCallsignDvar( flaglabel, "war_a", 0.2 );	// flag callsign
	self thread sendFlagCallsignDvar( flaglabel, "war_b", 0.4 );	// flag callsign
	self thread sendFlagCallsignDvar( flaglabel, "war_c", 0.6 );	// flag callsign
	self thread sendFlagCallsignDvar( flaglabel, "war_d", 0.8 );	// flag callsign
	self thread sendFlagCallsignDvar( flaglabel, "war_e", 1.0 );	// flag callsign
}

onPlayerConnect()
{
	for(;;)
	{
		level waittill ( "connecting", player );

		if ( isDefined( player ) )
		{
			player.hidingHudForNotify = false;
			player.touchingContestedFlag = false;

			player thread twar_setClientDvar( "war_sb", getDvar( "war_sb" ) );  // score bar
			player sendFlagCallsignDvars();
			
			// this will not create anything until the flags have been set up
			player hud_createPlayerFlagElems();
			
			player thread onTeamChange();
			player thread hideHudOnNotify();
			player thread hardpointMomentum();
			player updateHudIcons( false );
		}
	}
}

/*
=============
onTeamChange

Changes influencer teams when player changes teams
=============
*/
onTeamChange()
{
	self endon( "disconnect" );
	level endon ( "game_ended" );

	while(1)
	{
		self waittill ( "joined_team" );
		
		updateHudIcons( false );
		contestedFlag = locate_contested_twar_flag();
		if ( isDefined ( contestedFlag ) && isDefined ( contestedFlag.useObj ) )
		{
			// make sure the progress bar color gets updated
			self hud_beginUseHudFlagProgressBars( contestedFlag.useObj.claimTeam );
		}
		
		wait(0.05);
	}
}

clearPlayersTouchingFlag()
{
	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[i].touchingContestedFlag = false;
	}
}

hideHudOnNotify()
{
	self endon( "disconnect" );
	
	for(;;)
	{
		self waittill ( "notifyMessageBegin", notifyDuration );

		self hud_hideHudForPlayer();

		self.hidingHudForNotify = true;
		
		self hud_hideHudForPlayer();
		
		wait ( notifyDuration );

		if ( self.notifyQueue.size != 0 )
			continue;

		wait ( 1.0 );

		if ( !level.gameEnded )
		{
			self.hidingHudForNotify = false;

			contestedFlag = locate_contested_twar_flag();
			if ( isDefined ( contestedFlag ) && isDefined ( contestedFlag.useObj ) )
			{
				self hud_showHudForPlayer(contestedFlag.useObj);
				
				self updateHudProgressBar( contestedFlag.useObj );

				numAllies = contestedFlag.useObj.numTouching["allies"];
				numAxis = contestedFlag.useObj.numTouching["axis"];
				self updateHudPlayerCounts( contestedFlag.useObj,numAllies,numAxis );
			}
		}
	}
}


hardpointMomentum()
{
	self endon( "disconnect" );

	radarMomentum = getDvarInt("twar_momentumRadar");
	artilleryMomentum = getDvarInt("twar_momentumArtillery");
	dogsMomentum = getDvarInt("twar_momentumDogs");
	
	for(;;)
	{
		self waittill ( "hardpoint_used", hardpointType );

		amount = 1;
		switch( hardpointType )
		{
		case "radar_mp":
			amount = radarMomentum;
			break;

		case "artillery_mp":
			amount = artilleryMomentum;
			break;

		case "dogs_mp":
			amount = dogsMomentum;
			break;
		}

		updateMomentum( self.pers["team"], amount );
	}
}


isHidingHud()
{
	return self.hidingHudForNotify;
}


updateAllPlayersHudIcons(contested_flag)
{
	parent_elem_index = undefined;
	if ( isdefined( contested_flag ) )
	{
		parent_elem_index = level.flagOrder[contested_flag.label];
	}
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isDefined( player ) )
		{
			player thread threadedUpdateHudIcons( false, parent_elem_index, i * 0.05 );
		}
	}
}


hideAllPlayersHudIcons()
{
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isDefined( player ) )
		{
			player hud_hideHudForPlayer();
		}
	}
}

fadeInIconChild()
{
	self showElem();
	if ( self.elemType == "bar" || self.elemType == "bar_shader" )
	{
		self.bar.alpha = 0;
		self.bar fadeOverTime( 0.5 );
		self.bar.alpha = 0.75;

		self.barFrame.alpha = 0;
		self.barFrame fadeOverTime( 0.5 );
		self.barFrame.alpha = 0.75;
	}
	else
	{
		self.alpha = 0;
		self fadeOverTime( 0.5 );
		self.alpha = 0.75;
	}
}

fadeInIconElemAndChildren()
{
	self showElem();
	self.alpha = 0;
	self fadeOverTime( 0.5 );
	self.alpha = 0.75;

	for ( i = 0; i < self.children.size; i++ )
	{
		self.children[i] fadeInIconChild();
	}
}

fadeInIconElem()
{
	self showElem();
	self.alpha = 0;
	self fadeOverTime( 0.5 );
	self.alpha = 0.75;
}

fadeOutIconElemAndChildren()
{
	self hideElem();

	for ( i = 0; i < self.children.size; i++ )
	{
		self.children[i] hideElem();
	}
}

threadedUpdateHudIcons( hide, parent_elem_index, time )
{
	self endon("disconnect");
	wait(time);
	self updateHudIcons( hide );
	
	if ( isdefined(parent_elem_index) )
	{
		self hud_updateHudParentingForPlayer( parent_elem_index );
	}
}

updateHudIcons( hide )
{	
	prof_begin("TWAR: updateHudIcons");

	numColumns = level.flags.size;
	columnOffset = level.warHudColumnOffset;

	team = self.pers["team"];
	if ( !isdefined(team) || (team != "allies" && team != "axis") )
	{
		team = "allies";
	}

	y = level.hudImageSize + level.hudImageSpacing;
	
	for ( j = 0; j < numColumns; j++ )
	{
		flag = level.flags[j];
		useObj = flag.useObj;

		size = level.hudImageSize;
		x = columnOffset;
	
		teamShader = useObj.ownerTeam;
		if ( teamShader == "neutral" )
		{
			teamShader = game[team] + "_neutral";
			size += level.hudImageIncrease;
		}
		else
		{
			teamShader = game[teamShader];
		}

		self.warHudElems[j] setsize(size,size);
		self.warHudElems[j] setShader( level.flagHudFX[teamShader], size, size );

		if ( !hide && ( !level.inFinalFight || ( j == int( numColumns / 2 ) ) ) )
		{
			self.warHudElems[j] setPoint( "CENTER", "TOP", x, y );

			if ( self.warHudElems[j].hidden )
			{
				self.warHudElems[j] fadeInIconElem();
			}
		}
		else
		{
			self.warHudElems[j] fadeOutIconElemAndChildren();
		}

		columnOffset += ( level.hudImageSize + level.hudImageSpacing );
	}
	prof_end("TWAR: updateHudIcons");
}


updateHudProgressBar( flag ) 
{
	prof_begin("TWAR: updateHudProgressBar");
	
	if ( 	self isHidingHud() )
		return;

	if ( level.hardcoreMode )
	{
		return;
	}
	
	updateBar = false;
	if ( flag.claimTeam != "none" )
	{
		if ( flag.decayProgress && ( flag.curProgress > 0 ) )
		{
			updateBar = true;
		}
		else if ( flag.useTime && ( flag.numTouching[flag.claimTeam] != 0 ) )
		{
			updateBar = true;
		}
	}

	if ( updateBar )
	{
		self.waypointProgress updateBar( flag.curProgress / flag.useTime );
	}

	prof_end("TWAR: updateHudProgressBar");
}

updateAllPlayersHudPlayerProgressBars( flag )
{
	if ( level.hardcoreMode )
	{
		return;
	}

	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isDefined( player ) )
		{
			player updateHudProgressBar( flag );
		}
	}
}


updateAllPlayersHudPlayerCounts( flag )
{
	if ( level.hardcoreMode )
	{
		return;
	}

	self notify("updateAllPlayersHudPlayerCounts");
	self endon("updateAllPlayersHudPlayerCounts");
	waittillframeend;
	
	if ( flag.claimTeam != "none" )
	{
		numAllies = flag.numTouching["allies"];
		numAxis = flag.numTouching["axis"];
	}
	else
	{
		numAllies = 0;
		numAxis = 0;
	}
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isDefined( player ) )
		{
			player updateHudPlayerCounts( flag, numAllies, numAxis );
		}
	}
}


updateHudPlayerCounts( flag, numAllies, numAxis )
{
	if ( level.hardcoreMode )
	{
		return;
	}

	prof_begin("TWAR: updateHudPlayerCounts");

	isHidingHud = self isHidingHud();

	if ( level.hardcoreMode )
	{
		if ( !self.waypointAlliesTouching.hidden )
		{
			self.waypointAlliesTouching hideElem();
		}
		if ( !self.waypointAxisTouching.hidden )
		{
			self.waypointAxisTouching hideElem();
		}
		return;
	}
	
	if ( GetDvarInt("twar_showEnemyCount") == 0 )
	{
		if ( self.pers["team"] == "axis" )
		{
			numAllies = 0;
		}
		else
		{
			numAxis = 0;
		}
	}
	
	if ( numAllies != 0 )
	{
		if ( !level.gameEnded && !isHidingHud && self.waypointAlliesTouching.hidden)
		{
			self.waypointAlliesTouching showElem();
		}
		self.waypointAlliesTouching setvalue( numAllies );	
	}
	else if ( !self.waypointAlliesTouching.hidden )
	{
		self.waypointAlliesTouching hideElem();
	}

	if ( numAxis != 0  )
	{
		if ( !level.gameEnded && !isHidingHud && self.waypointAxisTouching.hidden)
		{
			self.waypointAxisTouching showElem();
		}
		self.waypointAxisTouching setvalue( numAxis );
	}
	else if ( !self.waypointAxisTouching.hidden )
	{
		self.waypointAxisTouching hideElem();
	}
	
	prof_end("TWAR: updateHudPlayerCounts");
}


updateHudMomentumForTeam( team )
{
	if ( getDvarInt("twar_momentumEnabled") == 0 )
		return;

	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		if ( isDefined( player ) && player.pers["team"] == team )
		{
			player updateHudMomentum();
		}
	}
}


createWarGameDataHudElem(  )
{
	iconElem = newClientHudElem( self );
	iconElem.elemType = "wargamedata";
	iconElem.x = 0;
	iconElem.y = 0;
	iconElem.width = 0;
	iconElem.height = 0;
	iconElem.xOffset = 0;
	iconElem.yOffset = 0;
	iconElem.children = [];
	iconElem setParent( level.uiParent );
	iconElem.hidden = true;

	iconElem setWarGameData( 0, 0, 0 );
	
	return iconElem;
}


updateHudMomentum()
{
	prof_begin("TWAR: updateHudMomentum");
	if ( getDvarInt("twar_momentumEnabled") == 0 )
		return;

	team = self.pers["team"];

	if ( team != "axis" && team != "allies" )
	{
		// @TODO: What do we display for spectators?
	}
	else
	{
		momentumMax = getDvarInt("twar_momentumMax");
		momentumMaxMultiplier = getDvarInt("twar_momentumMaxMultiplier");
		hud_momentum_progress = 1.0;
		
		if ( momentumMax > 0 )
		{
			hud_momentum_progress = game["war_momentum"][team] / momentumMax;
		}
		else
		{
			//###jasone $REVIEW from stefan: what is the right thing to do here?
			hud_momentum_progress = game["war_momentum"][team];
		}

		self.warGameDataHudElem setWarGameData( hud_momentum_progress, game["war_momentum"][team + "_multiplier"], game["war_momentum"][team + "_blitzkriegTime"] );
	}
	prof_end("TWAR: updateHudMomentum");
}


updateMomentum( team, amount )
{
	if ( getDvarInt("twar_momentumEnabled") == 0 )
		return;
	prof_begin("TWAR: updateMomentum");

	momentumMax = getDvarInt("twar_momentumMax");
	momentumMaxMultiplier = getDvarInt("twar_momentumMaxMultiplier");

	if ( amount != 0 && game["war_momentum"][team + "_multiplier"] == momentumMaxMultiplier )
		return; // dont let positive adjustments occur when blitzkrieg is counting down
	
	previousMultiplier = game["war_momentum"][team + "_multiplier"];

	if ( amount == 0 )
	{
		game["war_momentum"][team] = 0;
		game["war_momentum"][team + "_multiplier"] = 1;
	}
	else
	{
		game["war_momentum"][team] += amount;
	}

	if ( game["war_momentum"][team + "_multiplier"] < momentumMaxMultiplier )
	{
		while( ( momentumMax <= game["war_momentum"][team] ) && ( game["war_momentum"][team + "_multiplier"] < momentumMaxMultiplier ) )
		{
			game["war_momentum"][team + "_multiplier"]++;
			game["war_momentum"][team] = game["war_momentum"][team] - momentumMax;
		}

		if ( momentumMax < game["war_momentum"][team] )
			game["war_momentum"][team] = momentumMax;

		if ( game["war_momentum"][team + "_multiplier"] == momentumMaxMultiplier )
		{
			if ( team == "allies" )
				level thread alliesBlitzkriegCountdown();
			else
				level thread axisBlitzkriegCountdown();
		}

		// send any required player notifications, as long as game has not ended
		if ( !level.gameEnded &&
			previousMultiplier != game["war_momentum"][team + "_multiplier"] )
		{
			notifyData = spawnStruct();

			if ( previousMultiplier < game["war_momentum"][team + "_multiplier"] )
			{
				enemyTeam = getOtherTeam( team );
				if ( game["war_momentum"][team + "_multiplier"] == momentumMaxMultiplier )
				{
					notifyData.titleText = &"MP_BLITZKRIEG";
					notifyData.notifyText = &"MP_BLITZKRIEG_DESC";
					notifyData.iconName = "hud_momentum_notification_blitzkrieg";
					notifyData.iconWidth= 40;
					notifyData.iconHeight= 40;
					maps\mp\gametypes\_globallogic::leaderDialog( "blitz_friendly", team );

				}
				else
				{
					notifyData.titleText = &"MP_MOMENTUM";
					notifyData.notifyText = &"MP_MOMENTUM_DESC";
					notifyData.iconName = "hud_momentum_notification_bonus";
					notifyData.iconWidth= 32;
					notifyData.iconHeight= 32;
					maps\mp\gametypes\_globallogic::leaderDialog( "momentum_friendly", team );
				}
			}
			else if ( game["war_momentum"][team + "_multiplier"] == 1 )
			{
				notifyData.titleText = &"MP_MOMENTUM_LOST";
				notifyData.notifyText = &"MP_MOMENTUM_LOST_DESC";
			}
			
			for ( i = 0; i < level.players.size; i++ )
			{
				player = level.players[i];
				if ( isDefined( player ) && player.pers["team"] == team )
				{
					player maps\mp\gametypes\_hud_message::notifyMessage( notifyData );
				}
			}
		}
	}
	else
	{
		game["war_momentum"][team] = momentumMax;
	}

	updateHudMomentumForTeam( team );
	prof_end("TWAR: updateMomentum");
}


alliesBlitzkriegCountdown()
{
	level endon ( "game_ended" );
	level endon ( "axis_captured_flag" );

	momentumMax = getDvarInt("twar_momentumMax");
	blitzkriegTime = getDvarInt("twar_momentumBlitzkriegTime");

	waitTime = 0.1;
	while ( waitTime < blitzkriegTime )
	{
		game["war_momentum"]["allies"] = int( momentumMax - ( momentumMax / blitzkriegTime ) * waitTime );
		game["war_momentum"]["allies_blitzkriegTime"] = int( blitzkriegTime - waitTime );

		updateHudMomentumForTeam( "allies" );

		waitTime += 0.25;
		wait ( 0.25 );
	}

	game["war_momentum"]["allies"] = 0;
	game["war_momentum"]["allies_multiplier"] -= 1;

	updateHudMomentumForTeam( "allies" );
}


axisBlitzkriegCountdown()
{
	level endon ( "game_ended" );
	level endon ( "allies_captured_flag" );

	momentumMax = getDvarInt("twar_momentumMax");
	blitzkriegTime = getDvarInt("twar_momentumBlitzkriegTime");

	waitTime = 0.1;
	while ( waitTime < blitzkriegTime )
	{
		game["war_momentum"]["axis"] = int( momentumMax - ( momentumMax / blitzkriegTime ) * waitTime );
		game["war_momentum"]["axis_blitzkriegTime"] = int( blitzkriegTime - waitTime );

		updateHudMomentumForTeam( "axis" );

		waitTime += 0.25;
		wait ( 0.25 );
	}

	game["war_momentum"]["axis"] = 0;
	game["war_momentum"]["axis_multiplier"] -= 1;

	updateHudMomentumForTeam( "axis" );
}


updateFlagStatusHudDvars( flag )
{
	prof_begin("TWAR: updateFlagStatusHudDvars");
	otherTeam = "axis";
	if ( isDefined( flag ) && flag.claimTeam == "axis" )
		otherTeam = "allies";

	if ( !isDefined( flag ) || flag.claimTeam == "none" || ( flag.numTouching[flag.claimTeam] == 0 && flag.numTouching[otherTeam] == 0 ) )
	{
		if ( getDvar( "war_sb" ) != "" )
		{
			setDvar( "war_sb", "" );
			twar_sendDvarToAllPlayers( "war_sb", "", 6, 0.1 );
		}
	}
	else
	{
		actualCaptureTeam = flag.claimTeam;
		captureAction = "_taking";

		if ( flag.numTouching[otherTeam] != 0 )
		{
			if ( flag.numTouching[flag.claimTeam] != 0 )
			{
				actualCaptureTeam = "contested";
			}
			else
			{
				actualCaptureTeam = otherTeam;
			}
		}

		dvarVal = "";
		if ( actualCaptureTeam == "allies" )
		{
			dvarVal = "a"+ flag.label;// "TEAM_ALLIES" + captureAction;
		}
		else if ( actualCaptureTeam == "axis" )
		{
			dvarVal = "x"+ flag.label; // "TEAM_AXIS" + captureAction;
		}
		else if ( actualCaptureTeam == "contested" )
		{
			dvarVal = "c"+ flag.label; //"contested";
		}

		if ( getDvar( "war_sb" ) != dvarVal )
		{
			setDvar( "war_sb", dvarVal );
			twar_sendDvarToAllPlayers( "war_sb", dvarVal, 6, 0.1 );
		}
	}
	prof_end("TWAR: updateFlagStatusHudDvars");
}


onSpawnPlayerUnified()
{
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}

onSpawnPlayer()
{
	spawnpoint = undefined;
	
	if ( !level.useStartSpawns )
	{
		flagsOwned = 0;
		enemyFlagsOwned = 0;
		myTeam = self.pers["team"];
		enemyTeam = getOtherTeam( myTeam );
		for ( i = 0; i < level.flags.size; i++ )
		{
			team = level.flags[i] getFlagTeam();
			if ( team == myTeam )
				flagsOwned++;
			else if ( team == enemyTeam )
				enemyFlagsOwned++;
		}
		
		if ( flagsOwned == level.flags.size )
		{
			// own all flags! pretend we don't own the last one we got, so enemies can spawn there
			enemyBestSpawnFlag = level.bestSpawnFlag[ getOtherTeam( self.pers["team"] ) ];
			
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, getSpawnsBoundingFlag( enemyBestSpawnFlag ) );
		}
		else if ( flagsOwned > 0 )
		{
			// spawn near any flag we own that's nearish something we can capture
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, getBoundaryFlagSpawns( myTeam ) );
		}
		else
		{
			// own no flags!
			bestFlag = undefined;
			if ( enemyFlagsOwned > 0 && enemyFlagsOwned < level.flags.size )
			{
				// there should be an unowned one to use
				bestFlag = getUnownedFlagNearestStart( myTeam );
			}
			if ( !isdefined( bestFlag ) )
			{
				// pretend we still own the last one we lost
				bestFlag = level.bestSpawnFlag[ self.pers["team"] ];
			}
			level.bestSpawnFlag[ self.pers["team"] ] = bestFlag;
			
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, bestFlag.nearbyspawns );
		}
	}
	
	if ( !isdefined( spawnpoint ) )
	{
		if (self.pers["team"] == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
	}
	
	//spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all );

	assert( isDefined(spawnpoint) );
	
	self spawn(spawnpoint.origin, spawnpoint.angles);
}


onSpawnSpectator( origin, angles )
{
//	self updateHudIcons( false );
	self updateHudMomentum();

	contestedFlag = locate_contested_twar_flag();
	if ( isDefined ( contestedFlag ) && isDefined ( contestedFlag.useObj ) )
	{
		self hud_showHudForPlayer(contestedFlag.useObj);
	}
	
	maps\mp\gametypes\_globallogic::default_onSpawnSpectator( origin, angles );
}

twar_playerSpawnedCB()
{
	self thread twar_threadedPlayerSpawnedCB();
}

twar_threadedPlayerSpawnedCB()
{
	self endon("disconnect");
	waittillframeend;
//	self updateHudIcons( false );
//	waittillframeend;
	self updateHudMomentum();
	waittillframeend;

	contestedFlag = locate_contested_twar_flag();
	if ( isDefined ( contestedFlag ) && isDefined ( contestedFlag.useObj ) )
	{
		self hud_showHudForPlayer(contestedFlag.useObj);
	}
}


twarFlags()
{
	level.lastStatus["allies"] = 0;
	level.lastStatus["axis"] = 0;

	refWrapper = spawn_array_struct();

	refWrapper.primaryFlags = getEntArray( "flag_primary_linked", "targetname" );
	refWrapper.descriptors = getentarray( "twar_flag_descriptor", "targetname" );

	refWrapper.maperrors = [];
	refWrapper.descriptorsByLinkname = [];

	// loop through the flag objects and find a corresponding descriptor object
	level.flags = [];
	for ( index = 0; index < refWrapper.primaryFlags.size; index++ )
	{
		closestdist = undefined;
		closestdesc = undefined;
		for (i = 0; i < refWrapper.descriptors.size; i++)
		{
			dist = distance(refWrapper.primaryFlags[index].origin, refWrapper.descriptors[i].origin);
			if (!isdefined(closestdist) || dist < closestdist) 
			{
				closestdist = dist;
				closestdesc = refWrapper.descriptors[i];
			}
		}

		if (!isdefined(closestdesc)) 
		{
			refWrapper.maperrors[refWrapper.maperrors.size] = "there is no twar_flag_descriptor in the map! see explanation in twar.gsc";
			break;
		}

		if (isdefined(closestdesc.flag)) 
		{
			refWrapper.maperrors[refWrapper.maperrors.size] = "twar_flag_descriptor with script_linkname \"" + closestdesc.script_linkname + "\" is nearby more than one flag; is there a unique descriptor near each flag?";
			continue;
		}

		level.flags[level.flags.size] = refWrapper.primaryFlags[index];
		level.flags[level.flags.size - 1].descriptor = closestdesc;
		closestdesc.flag = level.flags[level.flags.size - 1];
		refWrapper.descriptorsByLinkname[closestdesc.script_linkname] = closestdesc;
	}

	if ( ( level.flags.size != 3 ) && ( level.flags.size != 5 ) )
	{
		printMapErrors( refWrapper );
		printLn( "^1Incorrect number of flags found in level, only 3 or 5 flags is supported." );
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	level.flagOrder["_a"] = 0;
	level.flagOrder["_b"] = 1;
	level.flagOrder["_c"] = 2;
	level.flagOrder["_d"] = 3;
	level.flagOrder["_e"] = 4;
	sortFlags();
	
	// create use-objects for each found tank-war flag
	level.twarFlags = [];
	for ( index = 0; index < level.flags.size; index++ )
	{
		trigger = level.flags[index];
		if ( isDefined( trigger.target ) )
		{
			visuals[0] = getEnt( trigger.target, "targetname" );
		}
		else
		{
			visuals[0] = spawn( "script_model", trigger.origin );
			visuals[0].angles = trigger.angles;
		}

		visuals[0] setModel( game["flagmodels"]["neutral"] );

		useObjectMessage = "^1Creating a use object named " + trigger.descriptor.script_linkname;
		println(useObjectMessage);

		twarFlag = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", trigger, visuals, (0,0,100) );
		twarFlag maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
		twarFlag maps\mp\gametypes\_gameobjects::setUseTime( level.captureTime );
		twarFlag maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_FLAG" );
		label = twarFlag maps\mp\gametypes\_gameobjects::getLabel();
		twarFlag.label = label;
		twarFlag maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.objectiveCompassFX );
		twarFlag maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", level.objectiveFX );
		twarFlag maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.objectiveCompassFX );
		twarFlag maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", level.objectiveFX );
		twarFlag maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		twarFlag.decayProgress = true;
		twarFlag.onUse = ::onUse;
		twarFlag.onBeginUse = ::onBeginUse;
		twarFlag.onUseUpdate = ::onUseUpdate;
		twarFlag.onEndUse = ::onEndUse;
		twarFlag.onUpdateUseRate = ::onUpdateUseRate;
		twarFlag.onTouchUse = ::onTouchUse;
		twarFlag.onEndTouchUse = ::onEndTouchUse;

		twarFlag.objPoints["allies"].font = "default";
		twarFlag.objPoints["allies"].fontscale = 2.0;
		twarFlag.objPoints["allies"].fontstyle3d = "shadowedmore";
		twarFlag.objPoints["allies"].glowcolor = (1, 1, 1);
		twarFlag.objPoints["allies"].glowalpha = 1;
		twarFlag.objPoints["allies"].font3duseglowcolor = 1;
		twarFlag.objPoints["allies"].label = game["strings"]["war_callsign" + label];
		
		twarFlag.objPoints["axis"].font = "default";
		twarFlag.objPoints["axis"].fontscale = 2.0;
		twarFlag.objPoints["axis"].fontstyle3d = "shadowedmore";
		twarFlag.objPoints["axis"].glowcolor = (1, 1, 1);
		twarFlag.objPoints["axis"].glowalpha = 1;
		twarFlag.objPoints["axis"].font3duseglowcolor = 1;
		twarFlag.objPoints["axis"].label = game["strings"]["war_callsign" + label];
		
		traceStart = visuals[0].origin + (0,0,32);
		traceEnd = visuals[0].origin + (0,0,-32);
		trace = bulletTrace( traceStart, traceEnd, false, undefined );
	
		upangles = vectorToAngles( trace["normal"] );
		twarFlag.baseeffectforward = anglesToForward( upangles );
		twarFlag.baseeffectright = anglesToRight( upangles );
		
		twarFlag.baseeffectpos = trace["position"];
		
		// legacy spawn code support
		level.flags[index].useObj = twarFlag;
		level.flags[index].adjflags = [];
		level.flags[index].nearbyspawns = [];
		
		twarFlag.levelFlag = level.flags[index];
		
		level.twarFlags[level.twarFlags.size] = twarFlag;

		ownerTeam = "neutral";
		if(index < int(level.flags.size / 2))
		{
			ownerTeam = "allies";
		}
		else if(int(level.flags.size / 2) < index)
		{
			ownerTeam = "axis";
		}

		twarFlag setFlagOwner( ownerTeam );

		if ( ownerTeam == "neutral" )
		{
			updateFlagStatusHudDvars( twarFlag );
			twarFlag thread resetFlagBaseEffect( 0.1 );
		}
	}

	level.flagSetupComplete = true;
	
	hud_createPlayersFlagElems();
	
	// once all the flags have been registered with the game,
	// give each spawn point a baseline score for each objective flag,
	// based on whether or not player will be looking in the direction of that flag upon spawning
	if ( level.spawnsystem.script_based_influencer_system )
		generate_baseline_spawn_point_scores();
	
	// level.bestSpawnFlag is used as a last resort when the enemy holds all flags.
	level.bestSpawnFlag = [];
	level.bestSpawnFlag[ "allies" ] = getUnownedFlagNearestStart( "allies", undefined );
	level.bestSpawnFlag[ "axis" ] = getUnownedFlagNearestStart( "axis", level.bestSpawnFlag[ "allies" ] );

	flagSetup( refWrapper );

	/#
	thread domDebug();
	#/

	updateTwarScores();

	updateAllPlayersHudIcons();
	
	twar_update_spawn_influencers();
}


sortFlags()
{
	for ( i = 1; i < level.flags.size; i++ )
	{
       for ( j = 0; j < level.flags.size - i; j++ ) 
	   {
           if ( level.flagOrder[level.flags[j].script_label] > level.flagOrder[level.flags[j + 1].script_label] )
		   {
               temp = level.flags[j]; 
			   level.flags[j] = level.flags[j + 1]; 
			   level.flags[j + 1] = temp;
           }
       }
   }
}


getUnownedFlagNearestStart( team, excludeFlag )
{
	best = undefined;
	bestdistsq = undefined;
	for ( i = 0; i < level.flags.size; i++ )
	{
		flag = level.flags[i];
		
		if ( flag getFlagTeam() != "neutral" )
			continue;
		
		distsq = distanceSquared( flag.origin, level.startPos[team] );
		if ( (!isDefined( excludeFlag ) || flag != excludeFlag) && (!isdefined( best ) || distsq < bestdistsq) )
		{
			bestdistsq = distsq;
			best = flag;
		}
	}
	return best;
}

/#
domDebug()
{
	while(1)
	{
		if (getdvar("scr_domdebug") != "1") {
			wait 2;
			continue;
		}
		
		while(1)
		{
			if (getdvar("scr_domdebug") != "1")
				break;
			// show flag connections and each flag's spawnpoints
			for (i = 0; i < level.flags.size; i++) {
				for (j = 0; j < level.flags[i].adjflags.size; j++) {
					line(level.flags[i].origin, level.flags[i].adjflags[j].origin, (1,1,1));
				}
				
				for (j = 0; j < level.flags[i].nearbyspawns.size; j++) {
					line(level.flags[i].origin, level.flags[i].nearbyspawns[j].origin, (.2,.2,.6));
				}
				
				if ( level.flags[i] == level.bestSpawnFlag["allies"] )
					print3d( level.flags[i].origin, "allies best spawn flag" );
				if ( level.flags[i] == level.bestSpawnFlag["axis"] )
					print3d( level.flags[i].origin, "axis best spawn flag" );
			}
			wait .05;
		}
	}
}
#/

isTeamLastFlag( team, label )
{
	isLastFlag = false;
	if ( ( team == "axis" ) && ( level.flagOrder[label] == 0 ) && ( getTeamFlagCount( "allies" ) == 0 ) ) 
	{
		// this is the last flag axis needs to capture to win
		isLastFlag = true;
	}
	else if( ( team == "allies" ) && ( level.flagOrder[label] == ( level.twarFlags.size - 1 ) ) && ( getTeamFlagCount( "axis" ) == 0 ) )
	{
		// this is the last flag allies need to capture to win
		isLastFlag = true;
	}
	return isLastFlag;
}

onTouchUse(player)
{
//	ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
//	otherTeam = getOtherTeam( player.pers["team"] );

	if ( player.pers["team"] == self.claimTeam )
	{
		player hud_showProgressBarForPlayer( false );

		otherteam = getotherteam(player.pers["team"]);
		isLastFlag = isTeamLastFlag( player.pers["team"], self.label );
		isOtherTeamLastFlag = isTeamLastFlag( otherteam, self.label );;
		
	
		if ( isLastFlag )
		{
			player.capturingLastFlag = true;
		}
		else if ( !isOtherTeamLastFlag )
		{
			// if this is not the last flag the player can not get the war hero challenge
			player.lastCapKiller = false;
		}
	}
	
	if ( self.claimTeam != "none" )
	{
		// this is the contended flag but we are not the contenders
		// show the count anyways
		thread updateAllPlayersHudPlayerCounts( self );
		updateFlagStatusHudDvars( self );
	}
}

onEndTouchUse(player)
{
//	ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
//	otherTeam = getOtherTeam( player.pers["team"] );

	if ( player.pers["team"] == self.claimTeam )
	{
		player hud_showProgressBarForPlayer( true );
	}
	
//	if ( self.claimTeam != "none" )
	{
		// this is the contended flag but we are not the contenders
		// show the count anyways
		thread updateAllPlayersHudPlayerCounts( self );
		updateFlagStatusHudDvars( self );
	}
	
	player.capturingLastFlag = false;
}


onBeginUse( player )
{
	ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();

	otherTeam = getOtherTeam( player.pers["team"] );

	
	if ( !self maps\mp\gametypes\_gameobjects::useObjectLockedForTeam( player.pers["team"] ) )
	{
		self.didStatusNotify = false;
		
		self.touchingContestedFlag = true;
		
		if ( self.claimPlayer == player )
		{
			hud_beginUseHudFlagProgressBarsForPlayers( player.pers["team"] );
			hud_showProgressBarsForAllPlayers( true, player );
			hud_threadedShowPlayerCountForAllPlayers( self , true );
		}
		
		player hud_showProgressBarForPlayer( false );
		
		// CODER_MOD DROCHE
		// 07/14/08 War Hero challenge
		isLastFlag = isTeamLastFlag( player.pers["team"], self.label );

		if ( ownerTeam == "neutral" )
		{
			if( isLastFlag || level.inFinalFight )
			{
				setmusicstate( "MATCH_END" );
				level.isLastFlag = true;
				level.lastProgress = 0;
			}
			else
				level.isLastFlag = false;

			if( getTime() - level.lastDialogTime > 15000 )
			{
				statusDialog( "securing_flag", player.pers["team"] );
				statusDialog( "losing_flag", otherTeam );
				level.lastDialogTime = getTime();
			}
			//###stefan $REVIEW why does this early out?
			return;
		}
	}

	updateFlagStatusHudDvars( self );
}


onUseUpdate( team, progress, change )
{
	prof_begin("TWAR: onUseUpdate");
	if ( !self maps\mp\gametypes\_gameobjects::useObjectLockedForTeam( team ) )
	{
		if ( progress > 0.05 && change && !self.didStatusNotify )
		{
			ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
			
			if ( ownerTeam == "neutral" )
			{
				otherTeam = getOtherTeam( team );
				if( getTime() - level.lastDialogTime > 15000 )
				{
					statusDialog( "securing_flag", team );
					statusDialog( "losing_flag", otherTeam );
					level.lastDialogTime = getTime();
				}
			}
			else
			{
				if( getTime() - level.lastDialogTime > 15000 )
				{
					statusDialog( "losing_flag", ownerTeam );
					statusDialog( "securing_flag", team );
					level.lastDialogTime = getTime();
				}
			}

			self.didStatusNotify = true;
		}
	}

	if( progress < 0.05 && level.lastProgress > progress && level.isLastFlag )
		setmusicstate( "UNDERSCORE" );
		
	level.lastProgress = progress;

	updateAllPlayersHudPlayerProgressBars( self );

	if ( progress == 0 )
	{
		hud_showProgressBarsForAllPlayers( false );
		hud_threadedShowPlayerCountForAllPlayers( self , false );
	}
	prof_end("TWAR: onUseUpdate");
}


statusDialog( dialog, team, checkTime )
{
	time = getTime();
	if ( !isDefined( checkTime ) && getTime() < level.lastStatus[team] + 6000 )
		return;
		
	thread delayedLeaderDialog( dialog, team );
	level.lastStatus[team] = getTime();	
}


onEndUse( team, player, success )
{
	updateFlagStatusHudDvars( self );

	player.touchingContestedFlag = false;
	
	if ( self.claimTeam != "none" )
	{
		player hud_showProgressBarForPlayer( true );
	}
	
	thread updateAllPlayersHudPlayerCounts( self );
}


resetFlagBaseEffect(delay_time)
{
	if ( isdefined(delay_time) )
	{
		wait( delay_time );
	}
	
	if ( isdefined( self.baseeffect ) )
		self.baseeffect delete();
	
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	if ( team != "neutral" )
		return;
	
	fxid = level.flagBaseFXid[ team ];

	self.baseeffect = spawnFx( fxid, self.baseeffectpos, self.baseeffectforward, self.baseeffectright );
	triggerFx( self.baseeffect );
}


setFlagOwner( team )
{
	label = self maps\mp\gametypes\_gameobjects::getLabel();

	self maps\mp\gametypes\_gameobjects::setOwnerTeam( team );

	if ( team == "neutral" )
	{
		self maps\mp\gametypes\_gameobjects::allowUse( "none" );
		self maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );

		self thread flagNeutralTimer();
	}
	else
	{
		self maps\mp\gametypes\_gameobjects::allowUse( "none" );
		self maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	}

	self.visuals[0] setModel( game["flagmodels"][team] );
	setDvar( "scr_obj" + self maps\mp\gametypes\_gameobjects::getLabel(), team );	
	
	self resetFlagBaseEffect();
}


flagNeutralTimer()
{
	level endon ( "game_ended" );

	time = getDvarFloat( "twar_neutralFlagLockTime" );

	if ( time && level.flagSetupComplete )
	{
		for ( index = 0; index < level.players.size; index++)
		{
			player = level.players[index];
			
			if ( IsDefined( player ) )
			{
				player thread maps\mp\gametypes\_hud::showClientGenericMessageBar( time, "@MENU_WAR_STATUS_NEUTRAL_COOK" );
			}
		}

		setDvar( "scr_obj" + self maps\mp\gametypes\_gameobjects::getLabel() + "_flash", 1 );	

		self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::startFlashing();
		self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::startFlashing();

		wait ( time );

		self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::stopFlashing();
		self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::stopFlashing();

		setDvar( "scr_obj" + self maps\mp\gametypes\_gameobjects::getLabel() + "_flash", 0 );
	}

	self maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
}


onUse( player )
{
	prof_begin("TWAR: onUse");
	team = player.pers["team"];
	oldTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	label = self maps\mp\gametypes\_gameobjects::getLabel();
	
	player logString( "flag captured: " + self.label );
	
	self setFlagOwner( team );
	
	level.useStartSpawns = false;

	isLastFlag = false;
	
	flagChanging = false;
	nextFlag = undefined;
	
	if ( oldTeam == "neutral" )
	{
		otherTeam = getOtherTeam( team );
		thread printAndSoundOnEveryone( team, otherTeam, &"MP_NEUTRAL_FLAG_CAPTURED_BY", &"MP_NEUTRAL_FLAG_CAPTURED_BY", "mp_war_objective_taken", undefined, player );
		
		if( !level.inFinalFight )
		{
			if( !checkIfLastFlagCaptured( otherTeam ) )
			{
				thread playSoundOnPlayers( "mx_WAR_captured"+"_"+level.teamPrefix[team] );
				statusDialog( "secure_flag", team );
				statusDialog( "lost_flag", otherTeam );
			}
			
			if( checkIfLastFlag( otherTeam ) )
			{
				thread playSoundOnPlayers( "mx_WAR_captured"+"_"+level.teamPrefix[team] );
				statusDialog( "oneflag_enemy", team, "false" );
				statusDialog( "oneflag_friendly", otherTeam, "false" );
			}
		}
	}
	else
	{
		thread printAndSoundOnEveryone( team, oldTeam, &"MP_ENEMY_FLAG_CAPTURED_BY", &"MP_FRIENDLY_FLAG_CAPTURED_BY", "mp_war_objective_taken", "mp_war_objective_lost", player );

		if( !level.inFinalFight )
		{
			thread playSoundOnPlayers( "mx_WAR_captured"+"_"+level.teamPrefix[team] );
			if ( team != "neutral" )
			{
				if( !checkIfLastFlagCaptured( oldTeam ) )
					statusDialog( "secure_flag", team );
			}

			if ( oldTeam != "neutral" )
			{	
				if( !checkIfLastFlagCaptured( oldTeam ) )
					statusDialog( "lost_flag", oldTeam );
			
				level.bestSpawnFlag[ oldTeam ] = self.levelFlag;
			}

			otherTeam = getOtherTeam( team );
			if( checkIfLastFlag( otherTeam ) )
			{
				statusDialog( "oneflag_enemy", team, "false" );
				statusDialog( "oneflag_friendly", otherTeam, "false" );
			}
		}
	}

	if ( team != "neutral" )
	{
		level notify ( team + "_captured_flag" );

		if( ( level.flagOrder[self.label] == 0 ) && ( getTeamFlagCount( "allies" ) == 0 ) )
		{
			// this is the last flag axis needs to capture to win
			isLastFlag = true;
		}
		else if( ( level.flagOrder[self.label] == ( level.twarFlags.size - 1 ) ) && ( getTeamFlagCount( "axis" ) == 0 ) )
		{
			// this is the last flag allies need to capture to win
			isLastFlag = true;
		}
		else if ( level.inFinalFight )
		{
			isLastFlag = true;
		}

		thread giveFlagCaptureXP( self.touchList[team], isLastFlag );

		if( !isLastFlag )
		{
			updateMomentum( getOtherTeam( team ), 0 );

			updateMomentum( team, getDvarInt( "twar_momentumFlagCap" ) );

			if( team == "allies" )
				nextFlag = level.twarFlags[level.flagOrder[self.label] + 1];
			else
				nextFlag = level.twarFlags[level.flagOrder[self.label] - 1];

			nextFlag setFlagOwner( "neutral" );

			flagChanging = true;
		}
	}

	clearPlayersTouchingFlag();
	
	if( !isLastFlag )
	{
		updateFlagStatusHudDvars( undefined );
	
		// call this before updating HUD elements so that parented offsets are always set correctly
		updateAllPlayersHudIcons(nextFlag);
	
		if ( flagChanging )
		{		
			updateAllPlayersHudPlayerProgressBars( nextFlag );
		}
	}

	hud_hideProgressAndCountsForAllPlayers();
		
	
	updateTwarScores();
	
	twar_update_spawn_influencers();

	if ( level.inFinalFight || isLastFlag )
	{
		level.forcedEnd = true;

		winningReason = undefined;

		if ( team == "allies" )
		{
			winningReason = game["strings"]["allies_mission_accomplished"];
		}
		else
		{
			winningReason = game["strings"]["axis_mission_accomplished"];
		}

		// hacky but we want the updateWinLossStats call to go through
		level.roundLimit = 0;
		
		thread maps\mp\gametypes\_globallogic::endGame( team, winningReason );
	}
	prof_end("TWAR: onUse");
}

checkIfLastFlag( team )
{
	if( getTeamFlagCount( team ) == 1 )
		return true;
	else
		return false;
}

checkIfLastFlagCaptured( team )
{
	if( getTeamFlagCount( team ) == 0 )
		return true;
	else
		return false;
}

// determines the useRate (see _gameobjects::useObjectProxThink) based on a percentage bonus
// if 0% is passed in it returns 1 (the amount 1 player accelerates a flag capture), for any
// other value it determines the difference in total time it takes to capture a flag and adds
// the bonus to determine the actual useRate.
getUseRate( accelPercent )
{
	result = 1;
	totalCaptureTime = level.captureTime * 1000;
	captureBonus = ( level.captureTime - ( level.captureTime * accelPercent ) ) * 50;
	if ( captureBonus > 0 )
	{
		result = ( totalCaptureTime / captureBonus ) / 20;
	}
	
	return result;
}


onUpdateUseRate()
{
	prof_begin("TWAR: onUpdateUseRate");
	if( self.useRate != 0 && (self.claimTeam == "axis" || self.claimTeam == "allies") )
	{
		otherTeam = getOtherTeam(self.claimTeam);

		claimTeamMomentumMultiplier = game["war_momentum"][self.claimTeam + "_multiplier"];

		otherTeamMomentumMultiplier = 0;
		if ( otherTeam == "axis" || otherTeam == "allies" )
			otherTeamMomentumMultiplier = game["war_momentum"][otherTeam + "_multiplier"];
		
		momentumMaxMultiplier = 0;
		momentumMultiplierBonus = 0;
		momentumMultiplierBonusLimit = 0;
		if ( getDvarInt("twar_momentumEnabled") != 0 )
		{
			momentumMaxMultiplier = getDvarInt( "twar_momentumMaxMultiplier" );
			momentumMultiplierBonus = getDvarInt( "twar_momentumMultiplierBonus" );
			momentumMultiplierBonusLimit = getDvarInt( "twar_momentumMultiplierBonusLimit" );
		}

		captureAccelBonus = getDvarInt("twar_captureAccelBonus");
		captureAccelLimit = getDvarInt("twar_captureAccelLimit");
		
		if ( self.decayProgress )
		{
			numClaimants = self.numTouching[self.claimTeam];

			numOther = 0;
			if ( otherTeam == "axis" || otherTeam == "allies" )
				numOther += self.numTouching[otherTeam];

			accelPercent = 0;
			momentumPercent = 0;

			if ( numClaimants && !numOther )
			{
				accelPercent = ( numClaimants - 1 ) * captureAccelBonus;

				if( captureAccelLimit < accelPercent )
					accelPercent = captureAccelLimit;

				if ( 1 < claimTeamMomentumMultiplier )
				{
					momentumPercent = claimTeamMomentumMultiplier * momentumMultiplierBonus;
					if ( momentumMultiplierBonusLimit < momentumPercent )
						momentumPercent = momentumMultiplierBonusLimit;
				}
			}
			else if ( !numClaimants && numOther )
			{
				accelPercent = numOther * captureAccelBonus;

				if( captureAccelLimit < accelPercent )
					accelPercent = captureAccelLimit;

				if ( 1 < otherTeamMomentumMultiplier )
				{
					momentumPercent = otherTeamMomentumMultiplier * momentumMultiplierBonus;
					if ( momentumMultiplierBonusLimit < momentumPercent )
						momentumPercent = momentumMultiplierBonusLimit;
				}
			}

			self.useRate = getUseRate( accelPercent * 0.01 ) * getUseRate( momentumPercent * 0.01 );
		}
		else
		{
			numClaimants = self.numTouching[self.claimTeam];

			accelPercent = ( numClaimants - 1 ) * captureAccelBonus;
			momentumPercent = 0;

			if( captureAccelLimit < accelPercent )
				accelPercent = captureAccelLimit;

			if ( 1 < claimTeamMomentumMultiplier )
			{
				momentumPercent = claimTeamMomentumMultiplier * momentumMultiplierBonus;
				if ( momentumMultiplierBonusLimit < momentumPercent )
					momentumPercent = momentumMultiplierBonusLimit;
			}

			self.useRate = getUseRate( accelPercent * 0.01 ) * getUseRate( momentumPercent * 0.01 );
		}
	}
	prof_end("TWAR: onUpdateUseRate");
}


giveFlagCaptureXP( touchList, isLastFlag )
{
	wait .05;
	maps\mp\gametypes\_globallogic::WaitTillSlowProcessAllowed();
	
	players = getArrayKeys( touchList );
	for ( index = 0; index < players.size; index++ )
	{
		player = touchList[players[index]].player;
		
		// Challenges
		if (player.lastcapkiller)
		{
			player maps\mp\gametypes\_missions::doMissionCallback( "warHero", player ); 
		}

		player thread [[level.onXPEvent]]( "capture" );
		maps\mp\gametypes\_globallogic::givePlayerScore( "capture", player );
		player setStatLBByName( "twar", 1, "flags captured");
	}
}


delayedLeaderDialog( sound, team )
{
	wait .1;
	maps\mp\gametypes\_globallogic::WaitTillSlowProcessAllowed();
	
	maps\mp\gametypes\_globallogic::leaderDialog( sound, team );
}


delayedLeaderDialogBothTeams( sound1, team1, sound2, team2 )
{
	wait .1;
	maps\mp\gametypes\_globallogic::WaitTillSlowProcessAllowed();
	
	maps\mp\gametypes\_globallogic::leaderDialogBothTeams( sound1, team1, sound2, team2 );
}


onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
	{
		updateMomentum( attacker.pers["team"], getDvarInt( "twar_momentumKillPlayer" ) );

		if ( self.touchTriggers.size )
		{
			triggerIds = getArrayKeys( self.touchTriggers );
			ownerTeam = self.touchTriggers[triggerIds[0]].useObj.ownerTeam;
			team = self.pers["team"];
			
			if ( team == ownerTeam )
			{
				attacker thread [[level.onXPEvent]]( "assault" );
				maps\mp\gametypes\_globallogic::givePlayerScore( "assault", attacker );
			}
			else
			{
				attacker thread [[level.onXPEvent]]( "defend" );
				maps\mp\gametypes\_globallogic::givePlayerScore( "defend", attacker );
			}
		}
	}
}


updateTwarScores()
{
	[[level._setTeamScore]]( "allies", getTeamFlagCount( "allies" ) );

	[[level._setTeamScore]]( "axis", getTeamFlagCount( "axis" ) );
}


getTeamFlagCount( team )
{
	score = 0;
	for (i = 0; i < level.flags.size; i++) 
	{
		if ( level.twarFlags[i] maps\mp\gametypes\_gameobjects::getOwnerTeam() == team )
			score++;
	}	
	return score;
}


getFlagTeam()
{
	return self.useObj maps\mp\gametypes\_gameobjects::getOwnerTeam();
}


getBoundaryFlags()
{
	// get all flags which are adjacent to flags that aren't owned by the same team
	bflags = [];
	for (i = 0; i < level.flags.size; i++)
	{
		for (j = 0; j < level.flags[i].adjflags.size; j++)
		{
			if (level.flags[i].useObj maps\mp\gametypes\_gameobjects::getOwnerTeam() != level.flags[i].adjflags[j].useObj maps\mp\gametypes\_gameobjects::getOwnerTeam() )
			{
				bflags[bflags.size] = level.flags[i];
				break;
			}
		}
	}
	
	return bflags;
}


getBoundaryFlagSpawns(team)
{
	spawns = [];
	
	bflags = getBoundaryFlags();
	for (i = 0; i < bflags.size; i++)
	{
		if (isdefined(team) && bflags[i] getFlagTeam() != team)
			continue;
		
		for (j = 0; j < bflags[i].nearbyspawns.size; j++)
			spawns[spawns.size] = bflags[i].nearbyspawns[j];
	}
	
	return spawns;
}


getSpawnsBoundingFlag( avoidflag )
{
	spawns = [];

	for (i = 0; i < level.flags.size; i++)
	{
		flag = level.flags[i];
		if ( flag == avoidflag )
			continue;
		
		isbounding = false;
		for (j = 0; j < flag.adjflags.size; j++)
		{
			if ( flag.adjflags[j] == avoidflag )
			{
				isbounding = true;
				break;
			}
		}
		
		if ( !isbounding )
			continue;
		
		for (j = 0; j < flag.nearbyspawns.size; j++)
			spawns[spawns.size] = flag.nearbyspawns[j];
	}
	
	return spawns;
}

// gets an array of all spawnpoints which are near flags that are
// owned by the given team, or that are adjacent to flags owned by the given team.
getOwnedAndBoundingFlagSpawns(team)
{
	spawns = [];

	for (i = 0; i < level.flags.size; i++)
	{
		if ( level.flags[i] getFlagTeam() == team )
		{
			// add spawns near this flag
			for (s = 0; s < level.flags[i].nearbyspawns.size; s++)
				spawns[spawns.size] = level.flags[i].nearbyspawns[s];
		}
		else
		{
			for (j = 0; j < level.flags[i].adjflags.size; j++)
			{
				if ( level.flags[i].adjflags[j] getFlagTeam() == team )
				{
					// add spawns near this flag
					for (s = 0; s < level.flags[i].nearbyspawns.size; s++)
						spawns[spawns.size] = level.flags[i].nearbyspawns[s];
					break;
				}
			}
		}
	}
	
	return spawns;
}

// gets an array of all spawnpoints which are near flags that are
// owned by the given team
getOwnedFlagSpawns(team)
{
	spawns = [];

	for (i = 0; i < level.flags.size; i++)
	{
		if ( level.flags[i] getFlagTeam() == team )
		{
			// add spawns near this flag
			for (s = 0; s < level.flags[i].nearbyspawns.size; s++)
				spawns[spawns.size] = level.flags[i].nearbyspawns[s];
		}
	}
	
	return spawns;
}

flagSetup( refWrapper )
{
	if ( refWrapper.maperrors.size == 0 )
	{
		// find adjacent flags
		for (i = 0; i < level.flags.size; i++)
		{
			if (isdefined(level.flags[i].descriptor.script_linkto))
			{
				adjdescs = strtok(level.flags[i].descriptor.script_linkto, " ");
			}
			else
			{
				adjdescs = [];
			}

			for (j = 0; j < adjdescs.size; j++)
			{
				otherdesc = refWrapper.descriptorsByLinkname[adjdescs[j]];
				if (!isdefined(otherdesc) || otherdesc.targetname != "twar_flag_descriptor") 
				{
					refWrapper.maperrors[refWrapper.maperrors.size] = "twar_flag_descriptor with script_linkname \"" + level.flags[i].descriptor.script_linkname + "\" linked to \"" + adjdescs[j] + "\" which does not exist as a script_linkname of any other entity with a targetname of twar_flag_descriptor (or, if it does, that twar_flag_descriptor has not been assigned to a flag)";
					continue;
				}
				adjflag = otherdesc.flag;
				if (adjflag == level.flags[i]) 
				{
					refWrapper.maperrors[refWrapper.maperrors.size] = "twar_flag_descriptor with script_linkname \"" + level.flags[i].descriptor.script_linkname + "\" linked to itself";
					continue;
				}
				level.flags[i].adjflags[level.flags[i].adjflags.size] = adjflag;
			}
		}
	}

	// assign each spawnpoint to nearest flag
	spawnpoints = getentarray("mp_dom_spawn", "classname");
	for (i = 0; i < spawnpoints.size; i++)
	{
		if (isdefined(spawnpoints[i].script_linkto)) 
		{
			desc = refWrapper.descriptorsByLinkname[spawnpoints[i].script_linkto];
			if (!isdefined(desc) || desc.targetname != "twar_flag_descriptor") 
			{
				refWrapper.maperrors[refWrapper.maperrors.size] = "Spawnpoint at " + spawnpoints[i].origin + "\" linked to \"" + spawnpoints[i].script_linkto + "\" which does not exist as a script_linkname of any entity with a targetname of twar_flag_descriptor (or, if it does, that twar_flag_descriptor has not been assigned to a flag)";
				continue;
			}
			nearestflag = desc.flag;
		}
		else 
		{
			nearestflag = undefined;
			nearestdist = undefined;
			for (j = 0; j < level.flags.size; j++)
			{
				dist = distancesquared(level.flags[j].origin, spawnpoints[i].origin);
				if (!isdefined(nearestflag) || dist < nearestdist)
				{
					nearestflag = level.flags[j];
					nearestdist = dist;
				}
			}
		}
		nearestflag.nearbyspawns[nearestflag.nearbyspawns.size] = spawnpoints[i];
	}
	
	printMapErrors( refWrapper );
}


onEndGame( winningTeam )
{
	if ( isdefined(level.twarFlags) )
	{
		for ( i = 0; i < level.twarFlags.size; i++ )
		{
			level.twarFlags[i] maps\mp\gametypes\_gameobjects::allowUse( "none" );
		}
	}

	// reset the generic message bar so it does not persist past this game
	for ( index = 0; index < level.players.size; index++)
	{
		player = level.players[index];
		if ( IsDefined( player ) )
			player thread maps\mp\gametypes\_hud::showClientGenericMessageBar( undefined, undefined );
	}

	hideAllPlayersHudIcons();
}


printMapErrors( refWrapper )
{
	if ( refWrapper.mapErrors.size > 0 )
	{
		println( "^1------------ Map Errors ------------" );
		for( i = 0; i < refWrapper.mapErrors.size; i++ )
		{
			println( refWrapper.mapErrors[i] );
		}
		println( "^1------------------------------------" );
		
		maps\mp\_utility::error( "Map errors. See above" );
		maps\mp\gametypes\_callbacksetup::AbortLevel();
	}
}

// give each spawn point a baseline score for each objective flag,
// based on whether or not player will be looking in the direction of that flag upon spawning
generate_baseline_spawn_point_scores()
{
	k_maximum_spawn_to_flag_view_angle_degrees= 30.0;
	k_visible_spawn_score= level.spawnsystem.objective_facing_bonus;
	k_not_visible_spawn_score= 0.0;
	
//	prof_begin("TWAR: generate_baseline_spawn_point_scores");
	// for each flag, give every spawn point entity a baseline score for each war flag
	for (team_index= 0; team_index< level.teams.size; team_index++ )
	{
		team_name= level.teams[team_index];
		
		// only care about active teams
		if (team_name=="axis" || team_name=="allies")
		{
			spawn_point_entities_s= maps\mp\gametypes\_spawning::gatherSpawnEntities(team_name);
			
			for (spawn_point_index= 0; spawn_point_index<spawn_point_entities_s.a.size; spawn_point_index++)
			{
				spawn_point_entity= spawn_point_entities_s.a[spawn_point_index];
				
				// if we haven't already evaluated this spawn point against the flags, do so now
				if (!IsDefined(spawn_point_entity.flag_desirability))
				{
					spawn_point_origin= spawn_point_entity GetOrigin();
					spawn_point_facing= AnglesToForward(spawn_point_entity GetAngles());
					
					// score spawn point for each flag based on visibility of flag from the spawn facing angles
					spawn_point_entity.flag_desirability= [];
					for (flag_index= 0; flag_index<level.flags.size; flag_index++)
					{
						flag_origin= level.flags[flag_index] GetOrigin();
						
						spawn_point_to_flag= vector3d_from_points(spawn_point_origin, flag_origin);
						spawn_to_flag_view_angle_degrees= vector3d_angle_between(spawn_point_facing, spawn_point_to_flag);
						
						if (Abs(spawn_to_flag_view_angle_degrees)<=k_maximum_spawn_to_flag_view_angle_degrees)
						{
							spawn_point_entity.flag_desirability[flag_index]= k_visible_spawn_score;
						}
						else
						{
							spawn_point_entity.flag_desirability[flag_index]= k_not_visible_spawn_score;
						}
					}
				}
			}
		}
	}
//	prof_end("TWAR: generate_baseline_spawn_point_scores");

	return;
}

//float
// returns a score based on the visibility of the contested flag
// from this spawn point's angles (see generate_baseline_spawn_point_scores())
twarPlayerSpawnGenerateSpawnPointEntityBaseScore(
	player_entity,
	spawn_point_entity)
{
	score= 0.0;
	
	if (IsDefined(spawn_point_entity.flag_desirability))
	{
		contested_flag_index= locate_contested_twar_flag_index();
		
		if (0<=contested_flag_index && contested_flag_index<=spawn_point_entity.flag_desirability.size)
		{
			score= spawn_point_entity.flag_desirability[contested_flag_index];
		}
	}
	
	return score;
}

//string
twar_flag_index_to_script_flag(
	flag_index)
{
	script_flag= undefined;
	
	switch (flag_index)
	{
		case 0: script_flag= "flag1"; break;
		case 1: script_flag= "flag2"; break;
		case 2: script_flag= "flag3"; break;
		case 3: script_flag= "flag4"; break;
		case 4: script_flag= "flag5"; break;
		default: script_flag= ""; break;
	}
	
	return script_flag;
}

//int[]
twar_generate_non_enemy_flag_indices(
	player_team)
{
	flag_indices= [];
	
	for (flag_index= 0; flag_index<level.flags.size; flag_index++)
	{
		if (!maps\mp\gametypes\_spawning::teams_have_enmity(player_team, (level.flags[flag_index] GetFlagTeam())))
		{
			flag_indices[flag_indices.size]= flag_index;
		}
	}
	
	return flag_indices;
}

activate_designer_placed_spawn_influencers_for_flag(
	spawn_influencers,
	flag_index,
	flag_team,
	score)
{
	objective_proximity_bonus= level.spawnsystem.twar_linked_flag_near_objective_bonus;
	placed_influencers= GetEntArray("mp_uspawn_influencer", "classname");
	script_flag= twar_flag_index_to_script_flag(flag_index);
	contested_flag= locate_contested_twar_flag();
	closest_influencer_to_objective_index= -1;
	
	if (IsDefined(contested_flag))
	{
		// find the linked influencer which is closest to the next objective, and give it a bonus
		flag_origin= contested_flag GetOrigin();
		closest_distance_squared= 1000000000000.0;
		for (influencer_index= 0; influencer_index<placed_influencers.size; influencer_index++)
		{
			influencer_entity= placed_influencers[influencer_index];
			
			influencer_origin= influencer_entity GetOrigin();
			distance_squared= point3d_distance_squared(flag_origin, influencer_origin);
			
			if (IsDefined(influencer_entity.script_gameobjectname) &&
				IsDefined(influencer_entity.script_team) &&
				IsDefined(influencer_entity.script_twar_flag) &&
				influencer_entity.script_gameobjectname=="twar" &&
				influencer_entity.script_team==flag_team &&
				influencer_entity.script_twar_flag==script_flag &&
				distance_squared<closest_distance_squared)
			{
				closest_distance_squared= distance_squared;
				closest_influencer_to_objective_index= influencer_index;
			}
		}
	}
	
	
	// turn on all influencers which are activated by ownership of this flag
	for (influencer_index= 0; influencer_index<placed_influencers.size; influencer_index++)
	{
		influencer_entity= placed_influencers[influencer_index];
		
		if (IsDefined(influencer_entity.script_gameobjectname) &&
			IsDefined(influencer_entity.script_team) &&
			IsDefined(influencer_entity.script_twar_flag) &&
			influencer_entity.script_gameobjectname=="twar" &&
			influencer_entity.script_team==flag_team &&
			influencer_entity.script_twar_flag==script_flag)
		{
			influencer_score= score;
			if (influencer_index==closest_influencer_to_objective_index)
			{
				influencer_score+= objective_proximity_bonus;
			}
			maps\mp\gametypes\_spawning::generate_designer_placed_spawn_influencer(spawn_influencers, influencer_entity, "twar:"+script_flag+":"+flag_team, influencer_score);
		}
	}

	return;
}

twar_is_valid_influencer_for_flag( influencer_entity, flag_team, script_flag)
{
	if ( !IsDefined(influencer_entity.script_gameobjectname) || influencer_entity.script_gameobjectname != "twar" )
		return false;

	if ( !IsDefined(influencer_entity.script_team) || influencer_entity.script_team != flag_team )
		return false;
	
	if ( !IsDefined(influencer_entity.script_twar_flag) || influencer_entity.script_twar_flag != script_flag )
		return false;
	
	return true;
}

twar_create_designer_placed_spawn_influencers_for_flag(
	placed_influencers,
	flag_index,
	flag_team,
	score)
{
	objective_proximity_bonus= level.spawnsystem.twar_linked_flag_near_objective_bonus;
	script_flag= twar_flag_index_to_script_flag(flag_index);
	contested_flag= locate_contested_twar_flag();
	closest_influencer_to_objective_index= -1;
	second_closest_influencer_to_objective_index= -1;
	
	if (IsDefined(contested_flag))
	{
		// find the linked influencer which is closest to the next objective, and give it a bonus
		flag_origin= contested_flag GetOrigin();
		closest_distance_squared= 1000000000000.0;
		second_closest_distance_squared= 1000000000000.0;
		for (influencer_index= 0; influencer_index<placed_influencers.size; influencer_index++)
		{
			influencer_entity= placed_influencers[influencer_index];
			
			if ( !twar_is_valid_influencer_for_flag( influencer_entity, flag_team, script_flag ) )
				continue;
			
			influencer_origin= influencer_entity GetOrigin();
			distance_squared= point3d_distance_squared(flag_origin, influencer_origin);
			
			if ( distance_squared < closest_distance_squared )
			{
				if ( closest_distance_squared < second_closest_distance_squared )
				{
					second_closest_distance_squared = closest_distance_squared;
					second_closest_influencer_to_objective_index = closest_influencer_to_objective_index;
				}
				
				closest_distance_squared = distance_squared;
				closest_influencer_to_objective_index = influencer_index;
			}
			else if ( distance_squared < second_closest_distance_squared )
			{
				second_closest_distance_squared = distance_squared;
				second_closest_influencer_to_objective_index = influencer_index;
			}
		}
	}
	
	secondary_influencer_bonus_percent = getdvarfloat("twar_secondaryInfluencerBonus");
	
	// turn on all influencers which are activated by ownership of this flag
	for (influencer_index= 0; influencer_index<placed_influencers.size; influencer_index++)
	{
		influencer_entity= placed_influencers[influencer_index];
		
		if ( !twar_is_valid_influencer_for_flag( influencer_entity, flag_team, script_flag ) )
			continue;

		influencer_score = score;
		if (influencer_index == closest_influencer_to_objective_index)
		{
			influencer_score += objective_proximity_bonus;
		}
		if (influencer_index == second_closest_influencer_to_objective_index && 0 != secondary_influencer_bonus_percent )
		{
			influencer_score += objective_proximity_bonus * secondary_influencer_bonus_percent;
		}
		
		level.twar_influencers[level.twar_influencers.size] = maps\mp\gametypes\_spawning::create_map_placed_influencer(influencer_entity, influencer_score);
	}

	return;
}

// this should be called when ever the contested flag changes
twar_update_spawn_influencers()
{
	// this will be all teams
	team_mask = 0;
	clearspawnpointsbaseweight( team_mask );

	twar_remove_spawn_influencers();
	twar_create_spawn_influencers();
	
}

twar_create_spawn_influencers()
{
	if ( !isdefined( level.twar_influencers ) )
	{
		level.twar_influencers = [];
	}
	
	placed_influencers = GetEntArray("mp_uspawn_influencer", "classname");
	
	if ( placed_influencers.size == 0)
		return;
		
	twar_create_spawn_influencers_for_team( "allies", placed_influencers );
	twar_create_spawn_influencers_for_team( "axis", placed_influencers );

	// generate contested flag spawn influencer
	contested_flag = locate_contested_twar_flag();
	if (IsDefined(contested_flag))
	{
		level.twar_influencers[level.twar_influencers.size] = twar_create_contested_objective_influencer(contested_flag);
		//level.twar_influencers[level.twar_influencers.size] = twar_create_contested_objective_positive_influencer(contested_flag);

		// this will be all teams
		team_mask = 0;
		
		// set the spawn points that face the flag to favorable
		setspawnpointsbaseweight( team_mask, contested_flag.origin, getdvarint("twar_spawnPointFacingAngle"), level.spawnsystem.objective_facing_bonus);
	}
}

twar_create_spawn_influencers_for_team( team, placed_influencers )
{
	linked_influencer_score= level.spawnsystem.twar_linked_flag_influencer_score;
	score_falloff_percentage= level.spawnsystem.twar_linked_flag_influencer_score_falloff_percentage;

	team_flag_indices = twar_generate_non_enemy_flag_indices(team);

	if ( team_flag_indices.size > 0 )
	{
		if ((level.flags[0] GetFlagTeam())== team)
		{
			// forward-most flag is the last one in the array
			for (flag_index= team_flag_indices.size-1; flag_index>=0; flag_index--)
			{
				twar_create_designer_placed_spawn_influencers_for_flag(
					placed_influencers,
					team_flag_indices[flag_index],
					team,
					linked_influencer_score);
					
				linked_influencer_score -= (score_falloff_percentage * linked_influencer_score);
			}
		}
		else
		{
			// forward-most flag is the first one in the array
			for (flag_index= 0; flag_index<team_flag_indices.size; flag_index++)
			{
				twar_create_designer_placed_spawn_influencers_for_flag(
					placed_influencers,
					team_flag_indices[flag_index],
					team,
					linked_influencer_score);
					
				linked_influencer_score -= (score_falloff_percentage * linked_influencer_score);
			}
		}
	}
}

twar_create_contested_objective_influencer( flag_entity )
{
	// war: contested flag influencer (negative influencer generated programatically around the presently contested flag)
	// want players to spawn near objective, but not on top of it
	// so, use a very large, but weak, inverse-linear influencer
	spawn_twar_contested_flag_influencer_score= level.spawnsystem.twar_contested_flag_influencer_score;
	spawn_twar_contested_flag_influencer_score_curve= level.spawnsystem.twar_contested_flag_influencer_score_curve;
	spawn_twar_contested_flag_influencer_radius= level.spawnsystem.twar_contested_flag_influencer_radius;
	
	// this affects both teams
	return addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 flag_entity GetOrigin(), 
							 spawn_twar_contested_flag_influencer_radius,
							 spawn_twar_contested_flag_influencer_score,
							 0,
							 maps\mp\gametypes\_spawning::get_score_curve_index(spawn_twar_contested_flag_influencer_score_curve) );

}

twar_create_contested_objective_positive_influencer( flag_entity )
{
	// war: contested flag influencer (negative influencer generated programatically around the presently contested flag)
	// want players to spawn near objective, but not on top of it
	// so, use a very large, but weak, inverse-linear influencer
	spawn_twar_contested_flag_influencer_score= level.spawnsystem.twar_contested_flag_positive_influencer_score;
	spawn_twar_contested_flag_influencer_score_curve= level.spawnsystem.twar_contested_flag_positive_influencer_score_curve;
	spawn_twar_contested_flag_influencer_radius= level.spawnsystem.twar_contested_flag_positive_influencer_radius;
	
	// this affects both teams
	return addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 flag_entity GetOrigin(), 
							 spawn_twar_contested_flag_influencer_radius,
							 spawn_twar_contested_flag_influencer_score,
							 0,
							 maps\mp\gametypes\_spawning::get_score_curve_index(spawn_twar_contested_flag_influencer_score_curve) );

}

twar_remove_spawn_influencers()
{
	if ( !isdefined( level.twar_influencers ) )
	{
		return;
	}
	
	for ( i = 0; i < level.twar_influencers.size; i++ )
	{
		removeinfluencer( level.twar_influencers[i] );
	}
	
	level.twar_influencers = [];
}

// spawning influencer generation callback
// return an array of influencer structs
twarPlayerSpawnGenerateInfluencers(
	player_entity, // the player who wants to spawn
	spawn_influencers) // reference to an influencer array struct
{
	placed_influencers= GetEntArray("mp_uspawn_influencer", "classname");
	
	if (placed_influencers.size>0)
	{
		team_flag_indices= twar_generate_non_enemy_flag_indices(player_entity.team);
		
		// for all non-enemy held flags, activate placed influencers for our team
		if (team_flag_indices.size>0)
		{
			linked_influencer_score= level.spawnsystem.twar_linked_flag_influencer_score;
			score_falloff_percentage= level.spawnsystem.twar_linked_flag_influencer_score_falloff_percentage;
			
			if ((level.flags[0] GetFlagTeam())==player_entity.team)
			{
				// forward-most flag is the last one in the array
				for (flag_index= team_flag_indices.size-1; flag_index>=0; flag_index--)
				{
					activate_designer_placed_spawn_influencers_for_flag(
						spawn_influencers,
						team_flag_indices[flag_index],
						player_entity.team,
						linked_influencer_score);
					linked_influencer_score-= (score_falloff_percentage*linked_influencer_score);
				}
			}
			else
			{
				// forward-most flag is the first one in the array
				for (flag_index= 0; flag_index<team_flag_indices.size; flag_index++)
				{
					activate_designer_placed_spawn_influencers_for_flag(
						spawn_influencers,
						team_flag_indices[flag_index],
						player_entity.team,
						linked_influencer_score);
					linked_influencer_score-= (score_falloff_percentage*linked_influencer_score);
				}
			}
		}
	}
	
	// generate contested flag spawn influencer
	contested_flag= locate_contested_twar_flag();
	if (IsDefined(contested_flag))
	{
		spawn_influencers.a[spawn_influencers.a.size]= create_twar_contested_objective_influencer(contested_flag);
	}
	
	return spawn_influencers;
}

// entity
locate_contested_twar_flag()
{
	flag_entity= undefined;
	
	for (flag_index=0; flag_index<level.flags.size; flag_index++)
	{
		flag_team= level.flags[flag_index] GetFlagTeam();
		if (flag_team=="neutral")
		{
			flag_entity= level.flags[flag_index];
			break;
		}
	}
	
	return flag_entity;
}

//int
locate_contested_twar_flag_index()
{
	for (flag_index=0; flag_index<level.flags.size; flag_index++)
	{
		flag_team= level.flags[flag_index] GetFlagTeam();
		if (flag_team=="neutral")
		{
			return flag_index;
		}
	}
	
	return -1;
}

create_twar_contested_objective_influencer(
	flag_entity)
{
	// war: contested flag influencer (negative influencer generated programatically around the presently contested flag)
	// want players to spawn near objective, but not on top of it
	// so, use a very large, but weak, inverse-linear influencer
	spawn_twar_contested_flag_influencer_score= level.spawnsystem.twar_contested_flag_influencer_score;
	spawn_twar_contested_flag_influencer_score_curve= level.spawnsystem.twar_contested_flag_influencer_score_curve;
	spawn_twar_contested_flag_influencer_radius= level.spawnsystem.twar_contested_flag_influencer_radius;
	
	return maps\mp\gametypes\_spawning::create_sphere_influencer(
		"game_mode", // type
		AnglesToForward(flag_entity.angles), // forward
		AnglesToUp(flag_entity.angles), // up
		flag_entity GetOrigin(), // origin
		spawn_twar_contested_flag_influencer_score, // score
		spawn_twar_contested_flag_influencer_score_curve, // score_curve
		spawn_twar_contested_flag_influencer_radius // radius
		);
}

hud_beginUseHudFlagProgressBarsForPlayers( captureTeam )
{
	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[i] hud_beginUseHudFlagProgressBars( captureTeam );
	}
}

hud_beginUseHudFlagProgressBars( captureTeam )
{
	if ( self.pers["team"] == captureTeam )
		self.waypointProgress.bar.color = ( 1, 1, 1 );
	else
		self.waypointProgress.bar.color = ( 1, 0, 0 );
}

hud_createPlayerFlagElems()
{
	if ( !isdefined(level.flagSetupComplete) || level.flagSetupComplete == false )
	{
		return;
	}
	
	if ( isdefined( self.flagElemsCreated ) )
		return;
		
	self hud_createPlayerFlagIcons();
	self hud_createPlayerFlagProgressBar();
	self hud_createPlayerFlagCapCount();

	if ( !isDefined( self.warGameDataHudElem ) )
	{
		self.warGameDataHudElem = createWarGameDataHudElem();
	}

	self hud_hideHudForPlayer();
	
	self.flagElemsCreated = true;
	
	flag = locate_contested_twar_flag();
	
	if ( !isdefined(flag) )
		return;

	self hud_updateHudParentingForPlayer(level.flagOrder[flag.useObj.label]);
}

hud_createPlayersFlagElems()
{
	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[i] hud_createPlayerFlagElems();
	}
	
	flag = locate_contested_twar_flag();
	if ( isdefined(flag) )
	{
		flag = flag.useObj;
	}
	updateAllPlayersHudIcons(flag);
}

hud_getDefaultOwnerTeam( index )
{
	ownerTeam = "neutral";
	if(index < int(level.flags.size / 2))
	{
		ownerTeam = "allies";
	}
	else if(int(level.flags.size / 2) < index)
	{
		ownerTeam = "axis";
	}
	
	return ownerTeam;
}

hud_createPlayerFlagIcons()
{
	if ( !isDefined ( self.warHudElems ) )
	{
		self.warHudElems = [];

		numColumns = level.flags.size;
		level.warHudColumnOffset = ( ( int( numColumns / 2 ) * level.hudImageSize ) + ( int( ( numColumns - 1 ) / 2 ) * level.hudImageSpacing ) ) * -1;
	
		x = level.warHudColumnOffset;
		y = level.hudImageSize + level.hudImageSpacing;
	
		team = self.pers["team"];
		if ( !isdefined(team) || team != "axis" )
		{
			team = "allies";
		}
		columnOffset = level.warHudColumnOffset;
		
		for ( column = 0; column < numColumns; column++ )
		{
			size = level.hudImageSize;
			x = columnOffset;
		
			teamShader = hud_getDefaultOwnerTeam(column);
			if ( teamShader == "neutral" )
			{
				teamShader = game[team] + "_neutral";
				size += level.hudImageIncrease;
			}
			else
			{
				teamShader = game[teamShader];
			}

			self.warHudElems[column] = createIcon( level.flagHudFX[teamShader], size, size );
		
			if ( !level.inFinalFight || ( column == int( numColumns / 2 ) ) )
			{
				self.warHudElems[column] setPoint( "CENTER", "TOP", x, y );
			}

			columnOffset += ( level.hudImageSize + level.hudImageSpacing );
		}
	}
}

hud_createPlayerFlagProgressBar()
{
	if ( !isDefined( self.waypointProgress ) )
	{
		self.waypointProgress = createBar( ( 1, 1, 1 ), level.hudImageSize, level.hudImageSpacing + 1 );
	}
}

hud_createPlayerFlagCapCount()
{
	if ( !isDefined( self.waypointAlliesTouching ) )
	{
		self.waypointAlliesTouching = createFontString( "default", 1.8 );
	}
	if ( !isDefined( self.waypointAxisTouching ) )
	{
		self.waypointAxisTouching = createFontString( "default", 1.8 );
	}

}

hud_updateHudParentingForAllPlayers()
{
	flag = locate_contested_twar_flag();
	
	if ( !isdefined(flag) )
		return;
		
	parent_elem_index = level.flagOrder[flag.useObj.label];
	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[i] hud_updateHudParentingForPlayer(parent_elem_index);
	}
}

hud_updateHudParentingForPlayer( parent_elem_index )
{
	if ( level.hardcoreMode )
		return;

	parentElem = self.warHudElems[parent_elem_index];
	if ( self.waypointAlliesTouching.parent != parentElem )
	{
		if ( isDefined( self.waypointAlliesTouching.parent ) )
			self.waypointAlliesTouching.parent removeChild( self.waypointAlliesTouching );

		parentElem addChild( self.waypointAlliesTouching );
		self.waypointAlliesTouching setParent( parentElem );
		self.waypointAlliesTouching setPoint( "CENTER", "BOTTOM", ( int(level.hudImageSize / 2) + int(level.hudImageSpacing / 2) ) * -1,  int(level.hudImageSpacing / 2) * -1 );
	}

	if ( self.waypointAxisTouching.parent != parentElem )
	{
		if ( isDefined( self.waypointAxisTouching.parent ) )
			self.waypointAxisTouching.parent removeChild( self.waypointAxisTouching );

		parentElem addChild( self.waypointAxisTouching );
		self.waypointAxisTouching setParent( parentElem );
		self.waypointAxisTouching setPoint( "CENTER", "BOTTOM", ( int(level.hudImageSize / 2) + int(level.hudImageSpacing / 2) ),  int(level.hudImageSpacing / 2) * -1 );
	}
	
	if ( self.waypointProgress.parent != parentElem )
	{
		if ( isDefined( self.waypointProgress.parent ) )
			self.waypointProgress.parent removeChild( self.waypointProgress );

		parentElem addChild( self.waypointProgress );
		self.waypointProgress setParent( parentElem );
		self.waypointProgress setPoint( "CENTER", "BOTTOM", 0, level.hudImageSpacing );
	}
}

hud_hideHudForPlayer()
{
	self.waypointProgress hideElem();
	self.waypointAlliesTouching hideElem();
	self.waypointAxisTouching hideElem();

	numColumns = level.flags.size;
	for ( column = 0; column < numColumns; column++ )
	{
		self.warHudElems[column] fadeOutIconElemAndChildren();		
	}
}

hud_showHudForPlayer( contested_flag )
{
	if ( !level.flagSetupComplete )
	{
		return;
	}
	
	if ( self isHidingHud() )
		return;
	
	team = self.pers["team"];
	
	// only show these if a flag is being capped
	if ( contested_flag.claimTeam != "none"  && !level.hardcoreMode)
	{
		self.waypointProgress showElem();
	
		hud_showPlayerCountForPlayer( contested_flag, true );
	}
	
	numColumns = level.flags.size;
	for ( column = 0; column < numColumns; column++ )
	{
		if ( !level.inFinalFight || ( column == int( numColumns / 2 ) ) )
		{
			self.warHudElems[column] 	fadeInIconElem();	
		}
	}
}

hud_showProgressBarForPlayer( enabled )
{
	if ( enabled && !(self isHidingHud()) && !level.hardcoreMode )
	{
		self.waypointProgress showElem();
	}
	else
		self.waypointProgress hideElem();
}

hud_showProgressBarsForAllPlayers( enabled, exclude )
{
	if ( level.hardcoreMode )
		return;

	for ( i = 0; i < level.players.size; i++ )
	{
		if ( !isdefined( level.players[i] ) )
			continue;
				
		if ( isdefined( exclude ) && level.players[i] ==  exclude )
			continue;
		
		level.players[i] hud_showProgressBarForPlayer(  enabled );
	}
}

hud_hideProgressAndCountsForAllPlayers()
{
	for ( i = 0; i < level.players.size; i++ )
	{
		if ( !isdefined( level.players[i] ) )
			continue;
				
		level.players[i] hud_showProgressBarForPlayer(  false );
		level.players[i] hud_showPlayerCountForPlayer(  undefined, false );
	}
}

hud_showHudElem( enabled )
{
	if ( enabled )
	{
		self showElem();
		self.alpha = 0.75;
	}
	else
	{
		self hideElem();
	}
}

hud_showPlayerCountForPlayer( contested_flag, enabled )
{
	if ( enabled )
	{
		if ( level.hardcoreMode )
			return;

		enabled = ( !(self isHidingHud()) );
		numallies =	contested_flag.numTouching["allies"];
		numaxis =	contested_flag.numTouching["axis"];
	}
	else
	{
		numallies =	0;
		numaxis = 0;
	}
	
	self.waypointAlliesTouching hud_showHudElem( enabled && ( numallies > 0 ) );
	self.waypointAxisTouching hud_showHudElem( enabled && ( numaxis > 0 ) );
}

hud_showPlayerCountForAllPlayers( contested_flag, enabled )
{
	for ( i = 0; i < level.players.size; i++ )
	{
		level.players[i] hud_showPlayerCountForPlayer( contested_flag, enabled );
	}
}

hud_threadedShowPlayerCountForAllPlayers( contested_flag, enabled )
{
	self notify("end show players");
	self endon("end show players");
	
	wait(0.05);
	
	hud_showPlayerCountForAllPlayers( contested_flag, enabled );
}

