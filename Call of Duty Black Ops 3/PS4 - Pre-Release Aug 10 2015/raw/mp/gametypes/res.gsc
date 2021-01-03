#using scripts\shared\callbacks_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hud_util_shared;
#using scripts\shared\math_shared;
#using scripts\shared\medals_shared;
#using scripts\shared\objpoints_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_defaults;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_util;
#using scripts\mp\teams\_teams;

/*
	Resistance
	Objective: 	Attacking team capture all the flags by touching them.
	Map ends:	When attacking team captures all the flags, or time limit is reached
	Respawning:	No wait / Near teammates

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_tdm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of owned flags, teammates and 
			enemies at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.
			Optionally, give a spawnpoint a script_linkto to specify which flag it "belongs" to (see Flag Descriptors).

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Flags:
			classname       trigger_radius
			targetname      res_flag_primary or flag_secondary
			Flags that need to be captured to win. Primary flags take time to capture; secondary flags are instant.
		
	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "nva";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.

		If using minefields or exploders:
			load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["soldiertypeset"] = "seals";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				soldiertypeset	seals
*/

/*QUAKED mp_res_spawn_axis (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_res_spawn_axis_a (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near the A flag at one of these positions.*/

/*QUAKED mp_res_spawn_allies_a (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near the A flag at one of these positions.*/

/*QUAKED mp_res_spawn_allies_b (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near the B flag at one of these positions.*/

/*QUAKED mp_res_spawn_allies_a (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near the A flag at one of these positions.*/

/*QUAKED mp_res_spawn_allies (0.0 1.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_res_spawn_axis_start (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_res_spawn_allies_start (0.0 1.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

#precache( "material", "compass_waypoint_captureneutral" );
#precache( "material", "compass_waypoint_capture" );
#precache( "material", "compass_waypoint_defend" );
#precache( "material", "compass_waypoint_captureneutral_a" );
#precache( "material", "compass_waypoint_capture_a" );
#precache( "material", "compass_waypoint_defend_a" );
#precache( "material", "compass_waypoint_captureneutral_b" );
#precache( "material", "compass_waypoint_capture_b" );
#precache( "material", "compass_waypoint_defend_b" );
#precache( "material", "compass_waypoint_captureneutral_c" );
#precache( "material", "compass_waypoint_capture_c" );
#precache( "material", "compass_waypoint_defend_c" );

#precache( "string", "OBJECTIVES_RES_ATTACKER" );
#precache( "string", "OBJECTIVES_RES_DEFENDER" );
#precache( "string", "OBJECTIVES_RES_ATTACKER_SCORE" );
#precache( "string", "OBJECTIVES_RES_DEFENDER_SCORE" );
#precache( "string", "OBJECTIVES_RES_ATTACKER_HINT" );
#precache( "string", "OBJECTIVES_RES_DEFENDER_HINT" );
#precache( "string", "MP_TARGET_DESTROYED" );
#precache( "string", "MP_CONTROL_HQ" );
#precache( "string", "MP_CAPTURE_HQ" );
#precache( "string", "MP_DEFEND_HQ" );
#precache( "string", "MP_TIME_EXTENDED" );
#precache( "string", "MP_CAPTURING_FLAG" );
#precache( "string", "MP_LOSING_FLAG" );
#precache( "string", "MP_RES_YOUR_FLAG_WAS_CAPTURED" );
#precache( "string", "MP_RES_ENEMY_FLAG_CAPTURED" );
#precache( "string", "MP_RES_NEUTRAL_FLAG_CAPTURED" );
#precache( "string", "MP_ENEMY_FLAG_CAPTURED_BY" );
#precache( "string", "MP_NEUTRAL_FLAG_CAPTURED_BY" );
#precache( "string", "MP_FRIENDLY_FLAG_CAPTURED_BY" );
// purposefully using dom strings here as there is no need to duplicate
#precache( "string", "MP_DOM_FLAG_A_CAPTURED_BY" );	
#precache( "string", "MP_DOM_FLAG_B_CAPTURED_BY" );	
#precache( "string", "MP_DOM_FLAG_C_CAPTURED_BY" );	
#precache( "string", "MP_DOM_FLAG_D_CAPTURED_BY" );	
#precache( "string", "MP_DOM_FLAG_E_CAPTURED_BY" );
#precache( "string", "MP_HQ_AVAILABLE_IN" );
//#precache( "fx", "_t6/misc/fx_ui_flagbase_marines" );//TODO T7 - contact FX team to get proper replacement
//#precache( "fx", "_t6/misc/fx_ui_flagbase_seals" );
//#precache( "fx", "_t6/misc/fx_ui_flagbase_cdc" );//TODO T7 - contact FX team to get proper replacement
//#precache( "fx", "_t6/misc/fx_ui_flagbase_nva" );//TODO T7 - contact FX team to get proper replacement
//#precache( "fx", "_t6/misc/fx_ui_flagbase_pmc" );
//#precache( "fx", "_t6/misc/fx_ui_flagbase_cia" );//TODO T7 - contact FX team to get proper replacement
#precache( "objective", "_a" );	
#precache( "objective", "_b" );	

function main()
{
	globallogic::init();

	util::registerRoundSwitch( 0, 9 );
	util::registerTimeLimit( 0, 2.5 );
	util::registerScoreLimit( 0, 1000 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerNumLives( 0, 100 );

	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );
	
	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType =&onStartGameType;
	level.onRoundSwitch =&onRoundSwitch;
	level.onPlayerKilled =&onPlayerKilled;
	level.onPrecacheGameType =&onPrecacheGameType;
	level.onEndGame=&onEndGame;
	level.onRoundEndGame =&onRoundEndGame;
	level.onTimeLimit =&onTimeLimit;
	level.getTimeLimit =&getTimeLimit;

	gameobjects::register_allowed_gameobject( level.gameType );

	game["dialog"]["gametype"] = "res_start";
	game["dialog"]["gametype_hardcore"] = "hcres_start";
	game["dialog"]["offense_obj"] = "cap_start";
	game["dialog"]["defense_obj"] = "defend_start";
	level.lastDialogTime = 0;

	level.iconoffset = (0,0,100);

	// Sets the scoreboard columns and determines with data is sent across the network
	globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths" , "captures", "defends"); 
	
}


function onPrecacheGameType()
{
}


function onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( game["teamScores"]["allies"] == level.scorelimit - 1 && game["teamScores"]["axis"] == level.scorelimit - 1 )
	{
		// overtime! team that's ahead in kills gets to defend.
		aheadTeam = getBetterTeam();
		
		if ( aheadTeam != game["defenders"] )
		{
			game["switchedsides"] = !game["switchedsides"];
		}
		else
		{
			level.halftimeSubCaption = "";
		}
		level.halftimeType = "overtime";
	}
	else
	{
		level.halftimeType = "halftime";
		game["switchedsides"] = !game["switchedsides"];
	}
}

function getBetterTeam()
{
	kills["allies"] = 0;
	kills["axis"] = 0;
	deaths["allies"] = 0;
	deaths["axis"] = 0;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		team = player.pers["team"];
		if ( isdefined( team ) && (team == "allies" || team == "axis") )
		{
			kills[ team ] += player.kills;
			deaths[ team ] += player.deaths;
		}
	}
	
	if ( kills["allies"] > kills["axis"] )
		return "allies";
	else if ( kills["axis"] > kills["allies"] )
		return "axis";

	if ( deaths["allies"] < deaths["axis"] )
		return "allies";
	else if ( deaths["axis"] < deaths["allies"] )
		return "axis";
	
	if ( randomint(2) == 0 )
		return "allies";
	return "axis";
}

function onStartGameType()
{	
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}

	level.usingExtraTime = false;

	game["strings"]["flags_capped"] = &"MP_TARGET_DESTROYED";

	util::setObjectiveText( game["attackers"], &"OBJECTIVES_RES_ATTACKER" );
	util::setObjectiveText( game["defenders"], &"OBJECTIVES_RES_DEFENDER" );

	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_RES_ATTACKER" );
		util::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_RES_DEFENDER" );
	}
	else
	{
		util::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_RES_ATTACKER_SCORE" );
		util::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_RES_DEFENDER_SCORE" );
	}
	util::setObjectiveHintText( game["attackers"], &"OBJECTIVES_RES_ATTACKER_HINT" );
	util::setObjectiveHintText( game["defenders"], &"OBJECTIVES_RES_DEFENDER_HINT" );
	
	level.objectiveHintPrepareHQ = &"MP_CONTROL_HQ";
	level.objectiveHintCaptureHQ = &"MP_CAPTURE_HQ";
	level.objectiveHintDefendHQ = &"MP_DEFEND_HQ";
	
	level.flagBaseFXid = [];
	level.flagBaseFXid[ "allies" ] = "_t6/misc/fx_ui_flagbase_" + game["allies"];
	level.flagBaseFXid[ "axis"   ] = "_t6/misc/fx_ui_flagbase_" + game["axis"];

	setClientNameMode("auto_change");

	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	spawnlogic::place_spawn_points( "mp_res_spawn_allies_start" );
	spawnlogic::place_spawn_points( "mp_res_spawn_axis_start" );
	spawnlogic::add_spawn_points( "allies", "mp_res_spawn_allies" );
	spawnlogic::add_spawn_points( "axis", "mp_res_spawn_axis" );
	spawnlogic::add_spawn_points( "axis", "mp_res_spawn_axis_a" );
	spawnlogic::drop_spawn_points( "mp_res_spawn_allies_a" );
	spawning::updateAllSpawnPoints();
	
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
		
	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  spawnlogic::get_spawnpoint_array("mp_res_spawn_" + team + "_start");
	}
		
	hud_createFlagProgressBar();
	
	updateGametypeDvars();
	thread createTimerDisplay();
	
	thread resFlagsInit();
	
	level.overtime = false;
	overtime = false;

	if ( game["teamScores"]["allies"] == level.scorelimit - 1 && game["teamScores"]["axis"] == level.scorelimit - 1 )
		overtime = true;
		
	if ( overtime )
		spawnlogic::clear_spawn_points();			
		spawnlogic::add_spawn_points( "allies", "mp_res_spawn_allies_a" );
		spawnlogic::add_spawn_points( "axis", "mp_res_spawn_axis" );
		spawning::updateAllSpawnPoints();
		
	if ( overtime )
		setupNextFlag( int(level.resFlags.size / 3) );
	else
		setupNextFlag(0);
	
	level.overtime = overtime;
	
	if ( level.flagActivateDelay )
		updateObjectiveHintMessages( level.objectiveHintPrepareHQ, level.objectiveHintPrepareHQ );
	else
		updateObjectiveHintMessages( level.objectiveHintCaptureHQ, level.objectiveHintCaptureHQ );
}

function onEndGame( winningTeam )
{
	for ( i = 0; i < level.resFlags.size; i++ )
	{
		level.resFlags[i] gameobjects::allow_use( "none" );
	}
}

function onRoundEndGame( roundWinner )
{
	winner = globallogic::determineTeamWinnerByGameStat( "roundswon" );
	
	return winner;
}

function res_endGame( winningTeam, endReasonText )
{
	if ( isdefined( winningTeam ) && winningTeam != "tie" )
		globallogic_score::giveTeamScoreForObjective( winningTeam, 1 );
	
	thread globallogic::endGame( winningTeam, endReasonText );
}

function onTimeLimit()
{
	if ( level.overtime )
	{
		if ( isdefined ( level.resProgressTeam ) )
		{
			res_endGame( level.resProgressTeam, game["strings"]["time_limit_reached"] );
		}
		else
		{
			res_endGame( "tie", game["strings"]["time_limit_reached"] );
		}
	}
	else
	{
		res_endGame( game["defenders"], game["strings"]["time_limit_reached"] );
	}

}

function getTimeLimit()
{
	timeLimit = globallogic_defaults::default_getTimeLimit();
	if ( level.usingExtraTime )
	{
		flagCount = 0;
		
		if ( isdefined( level.currentFlag ) )
		{
			flagCount += level.currentFlag.orderIndex;
		}
		return timeLimit + level.extraTime * flagCount;
	}
	return timeLimit;
}

function updateGametypeDvars()
{
	level.flagCaptureTime = GetGametypeSetting( "captureTime" );
	level.flagDecayTime = GetGametypeSetting( "flagDecayTime" );
	level.flagActivateDelay = GetGametypeSetting( "objectiveSpawnTime" );
	level.flaginactiveresettime = GetGametypeSetting( "idleFlagResetTime" );
	level.flagInactiveDecay = GetGametypeSetting( "idleFlagDecay" );
	level.extraTime = GetGametypeSetting( "extraTime" );
	level.flagCaptureGracePeriod = GetGametypeSetting( "flagCaptureGracePeriod" );
	level.playerOffensiveMax = GetGametypeSetting( "maxPlayerOffensive" );
	level.playerDefensiveMax = GetGametypeSetting( "maxPlayerDefensive" );
}

function resFlagsInit()
{
	level.lastStatus["allies"] = 0;
	level.lastStatus["axis"] = 0;
	
	level.flagModel["allies"] = teams::get_flag_model( "allies" );
	level.flagModel["axis"] = teams::get_flag_model( "axis" );
	level.flagModel["neutral"] = teams::get_flag_model( "neutral" );

	primaryFlags = getEntArray( "res_flag_primary", "targetname" );
	
	if ( (primaryFlags.size) < 2 )
	{
		/#
		printLn( "^1Not enough Resistance flags found in level!" );
		#/
		callback::abort_level();
		return;
	}
	
	level.flags = [];
	for ( index = 0; index < primaryFlags.size; index++ )
		level.flags[level.flags.size] = primaryFlags[index];
	
	level.resFlags = [];
	for ( index = 0; index < level.flags.size; index++ )
	{
		trigger = level.flags[index];
		if ( isdefined( trigger.target ) )
		{
			visuals[0] = getEnt( trigger.target, "targetname" );
		}
		else
		{
			visuals[0] = spawn( "script_model", trigger.origin );
			visuals[0].angles = trigger.angles;
		}

		visuals[0] setModel( level.flagModel[game["defenders"]] );
			
		resFlag = gameobjects::create_use_object( game["defenders"], trigger, visuals, level.iconoffset );
		resFlag gameobjects::allow_use( "none" );
		resFlag gameobjects::set_use_time( level.flagCaptureTime );
		resFlag gameobjects::set_use_text( &"MP_CAPTURING_FLAG" );
		resFlag gameobjects::set_decay_time( level.flagDecayTime );
		label = resFlag gameobjects::get_label();	
		resFlag.label = label;
		resFlag gameobjects::set_model_visibility( false );
		resFlag.onUse =&onUse;
		resFlag.onBeginUse =&onBeginUse;
		resFlag.onUseUpdate =&onUseUpdate;
		resFlag.onUseClear =&onUseClear;
		resFlag.onEndUse =&onEndUse;
		resFlag.claimGracePeriod = level.flagCaptureGracePeriod;
		resFlag.decayProgress = level.flagInactiveDecay;
		
		traceStart = visuals[0].origin + (0,0,32);
		traceEnd = visuals[0].origin + (0,0,-32);
		trace = bulletTrace( traceStart, traceEnd, false, undefined );
	
		upangles = vectorToAngles( trace["normal"] );
		resFlag.baseeffectforward = anglesToForward( upangles );
		resFlag.baseeffectright = anglesToRight( upangles );
		
		resFlag.baseeffectpos = trace["position"];
		
		// legacy spawn code support
		level.flags[index].useObj = resFlag;
		level.flags[index].nearbyspawns = [];
		
		resFlag.levelFlag = level.flags[index];
		
		level.resFlags[level.resFlags.size] = resFlag;
	}
	
	sortFlags();
	
	// level.bestSpawnFlag is used as a last resort when the enemy holds all flags.
	level.bestSpawnFlag = [];
	level.bestSpawnFlag[ "allies" ] = getUnownedFlagNearestStart( "allies", undefined );
	level.bestSpawnFlag[ "axis" ] = getUnownedFlagNearestStart( "axis", level.bestSpawnFlag[ "allies" ] );
	
	for ( index = 0; index < level.resFlags.size; index++ )
	{
		level.resFlags[index] createFlagSpawnInfluencers();
	}
	
	
}

function sortFlags()
{
	flagOrder["_a"] = 0;
	flagOrder["_b"] = 1;
	flagOrder["_c"] = 2;
	flagOrder["_d"] = 3;
	flagOrder["_e"] = 4;
	
	for ( i = 0; i < level.resFlags.size; i++ )
	{
		 level.resFlags[i].orderIndex = flagOrder[level.resFlags[i].label];
		 assert(isdefined(level.resFlags[i].orderIndex));
	}
	
	for ( i = 1; i < level.resFlags.size; i++ )
	{
   for ( j = 0; j <level.resFlags.size - i; j++ ) 
   {
	   if ( level.resFlags[j].orderIndex > level.resFlags[j+1].orderIndex )
	   {
       temp = level.resFlags[j]; 
		   level.resFlags[j] = level.resFlags[j + 1]; 
		   level.resFlags[j + 1] = temp;
	   }
   }
  }
}

function setupNextFlag(flagIndex)
{
	prevFlagIndex = flagIndex - 1;
	
	if ( prevFlagIndex >= 0 )
	{
		thread hideFlag( prevFlagIndex );
	}
	
	if ( flagIndex < level.resFlags.size && !level.overtime )
	{
		thread showFlag( flagIndex );
	}
	else
	{
		globallogic_utils::resumeTimer();
		hud_hideFlagProgressBar();
	}
}

function createTimerDisplay()
{

	flagSpawningInStr = &"MP_HQ_AVAILABLE_IN";

	level.locationObjID = gameobjects::get_next_obj_id();
	level.timerDisplay = [];
	level.timerDisplay["allies"] = hud::createServerTimer( "objective", 1.4, "allies" );
	level.timerDisplay["allies"] hud::setPoint( "TOPCENTER", "TOPCENTER", 0, 0 );
	level.timerDisplay["allies"].label = flagSpawningInStr;
	level.timerDisplay["allies"].alpha = 0;
	level.timerDisplay["allies"].archived = false;
	level.timerDisplay["allies"].hideWhenInMenu = true;
	
	level.timerDisplay["axis"  ] = hud::createServerTimer( "objective", 1.4, "axis" );
	level.timerDisplay["axis"  ] hud::setPoint( "TOPCENTER", "TOPCENTER", 0, 0 );
	level.timerDisplay["axis"  ].label = flagSpawningInStr;
	level.timerDisplay["axis"  ].alpha = 0;
	level.timerDisplay["axis"  ].archived = false;
	level.timerDisplay["axis"  ].hideWhenInMenu = true;
	
	thread hideTimerDisplayOnGameEnd( level.timerDisplay["allies"] );
	thread hideTimerDisplayOnGameEnd( level.timerDisplay["axis"  ] );
}

function hideTimerDisplayOnGameEnd( timerDisplay )
{
	level waittill("game_ended");
	timerDisplay.alpha = 0;
}

function showFlag(flagIndex)
{
	assert( flagIndex < level.resFlags.size );
	resFlag = level.resFlags[flagIndex];
	label = resFlag.label;	
	
	resFlag gameobjects::set_visible_team( "any" );
	resFlag gameobjects::set_model_visibility( true );

	level.currentFlag = resFlag;

	if ( level.flagActivateDelay )
	{
		hud_hideFlagProgressBar();
		
		if ( level.PrematchPeriod > 0 && level.inPrematchPeriod == true )
    {
			level waittill("prematch_over");
    }
		
		nextObjPoint = objpoints::create( "objpoint_next_hq", resFlag.curOrigin + level.iconoffset, "all", "waypoint_targetneutral" );
		nextObjPoint setWayPoint( true, "waypoint_targetneutral" );
		objective_position( level.locationObjID, resFlag.curOrigin );
		objective_icon( level.locationObjID, "waypoint_targetneutral" );
		objective_state( level.locationObjID, "active" );

		updateObjectiveHintMessages( level.objectiveHintPrepareHQ, level.objectiveHintDefendHQ );
		
		flagSpawningInStr = &"MP_HQ_AVAILABLE_IN";
		level.timerDisplay["allies"].label = flagSpawningInStr;
		level.timerDisplay["allies"] setTimer( level.flagActivateDelay );
		level.timerDisplay["allies"].alpha = 1;
		level.timerDisplay["axis"  ].label = flagSpawningInStr;
		level.timerDisplay["axis"  ] setTimer( level.flagActivateDelay );
		level.timerDisplay["axis"  ].alpha = 1;

		wait level.flagActivateDelay;

		objpoints::delete( nextObjPoint );
		objective_state( level.locationObjID, "invisible" );
		globallogic_audio::leader_dialog( "hq_online" );

		hud_showFlagProgressBar();
	}
	
	level.timerDisplay["allies"].alpha = 0;
	level.timerDisplay["axis"  ].alpha = 0;
	
	resFlag gameobjects::set_2d_icon( "friendly", "compass_waypoint_defend" + label );
	resFlag gameobjects::set_3d_icon( "friendly", "waypoint_defend" + label );
	resFlag gameobjects::set_2d_icon( "enemy", "compass_waypoint_capture" + label );
	resFlag gameobjects::set_3d_icon( "enemy", "waypoint_capture" + label );
	
	if ( level.overtime )
	{
		resFlag gameobjects::allow_use( "enemy" );
		resFlag gameobjects::set_visible_team( "any" );
		resFlag gameobjects::set_owner_team( "neutral" );
		resFlag gameobjects::set_decay_time( level.flagCaptureTime );
	}
	else 
	{
		resFlag gameobjects::allow_use( "enemy" );
	}
	
	resFlag resetFlagBaseEffect();
	
}

function hideFlag( flagIndex )
{
	assert( flagIndex < level.resFlags.size );
	resFlag = level.resFlags[flagIndex];
	resFlag gameobjects::allow_use( "none" );
	resFlag gameobjects::set_visible_team( "none" );
	resFlag gameobjects::set_model_visibility( false );
	
}

function getUnownedFlagNearestStart( team, excludeFlag )
{
	best = undefined;
	bestdistsq = undefined;
	for ( i = 0; i < level.flags.size; i++ )
	{
		flag = level.flags[i];
		
		if ( flag getFlagTeam() != "neutral" )
			continue;
		
		distsq = distanceSquared( flag.origin, level.startPos[team] );
		if ( (!isdefined( excludeFlag ) || flag != excludeFlag) && (!isdefined( best ) || distsq < bestdistsq) )
		{
			bestdistsq = distsq;
			best = flag;
		}
	}
	return best;
}

function onBeginUse( player )
{
	ownerTeam = self gameobjects::get_owner_team();
	SetDvar( "scr_obj" + self gameobjects::get_label() + "_flash", 1 );	
	self.didStatusNotify = false;
	

	if ( ownerTeam == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";

	if ( ownerTeam == "neutral" )
	{
		
		if( getTime() - level.lastDialogTime > 5000 )
		{
			otherTeam = util::getOtherTeam( player.pers["team"] );
			statusDialog( "securing"+self.label, player.pers["team"] );
			//statusDialog( "losing"+self.label, otherTeam );
			level.lastDialogTime = getTime();
		}
		self.objPoints[player.pers["team"]] thread objpoints::start_flashing();
		return;
	}
		
	

	self.objPoints["allies"] thread objpoints::start_flashing();
	self.objPoints["axis"] thread objpoints::start_flashing();

}


function onUseUpdate( team, progress, change )
{
    if ( !isdefined( level.resProgress ) )
    {
        level.resProgress = progress;
    }

    if ( progress > 0.05 && change && !self.didStatusNotify )
    {
        ownerTeam = self gameobjects::get_owner_team();
        if( getTime() - level.lastDialogTime > 10000 )
        {
            statusDialog( "losing"+self.label, ownerTeam );
            statusDialog( "securing"+self.label, team );
            level.lastDialogTime = getTime();
        }

        self.didStatusNotify = true;
    }

    if ( level.resProgress < progress )
    {
        // pause timer
        globallogic_utils::pauseTimer();
        setGameEndTime( 0 );
        level.resProgressTeam = team;
    }
    else
    {
        // unpause the timer
        globallogic_utils::resumeTimer();
    }

    level.resProgress = progress;
    hud_setflagProgressBar( progress, team );


}


function onUseClear( )
{	
  globallogic_utils::resumeTimer();
	hud_setflagProgressBar( 0 );
}

function statusDialog( dialog, team )
{
	time = getTime();
	if ( getTime() < level.lastStatus[team] + 6000 )
		return;
		
	thread delayedLeaderDialog( dialog, team );
	level.lastStatus[team] = getTime();	
}


function onEndUse( team, player, success )
{
	SetDvar( "scr_obj" + self gameobjects::get_label() + "_flash", 0 );

	self.objPoints["allies"] thread objpoints::stop_flashing();
	self.objPoints["axis"] thread objpoints::stop_flashing();


}


function resetFlagBaseEffect()
{
	// once these get setup we never change them
	if ( isdefined( self.baseeffect ) )
		return;
	
	team = self gameobjects::get_owner_team();
	
	if ( team != "axis" && team != "allies" )
		return;
	
	fxid = level.flagBaseFXid[ team ];

	self.baseeffect = spawnFx( fxid, self.baseeffectpos, self.baseeffectforward, self.baseeffectright );
	triggerFx( self.baseeffect );
}

function onUse( player, team )
{
	team = player.pers["team"];
	oldTeam = self gameobjects::get_owner_team();
	label = self gameobjects::get_label();
	
	/#print( "flag captured: " + self.label );#/
	
	setupNextFlag(self.orderIndex + 1);
	
	if ( (self.orderIndex + 1) == level.resFlags.size || level.overtime )
	{
		setGameEndTime( 0 );
		wait 1;
		res_endGame( player.team, game["strings"]["flags_capped"] );
	}
	else
	{
	
		level.useStartSpawns = false;
		
		assert( team != "neutral" );
	
		if( [[level.getTimeLimit]]() > 0 && level.extraTime )
		{
			level.usingExtraTime = true;
			if ( !level.hardcoreMode )
				iPrintLn( &"MP_TIME_EXTENDED" );
		}
		
		spawnlogic::clear_spawn_points();			
		spawnlogic::add_spawn_points( "allies", "mp_res_spawn_allies" );
		spawnlogic::add_spawn_points( "axis", "mp_res_spawn_axis" );

		if ( label == "_a" )
			{
				spawnlogic::clear_spawn_points();			
				spawnlogic::add_spawn_points( "allies", "mp_res_spawn_allies_a" );
				spawnlogic::add_spawn_points( "axis", "mp_res_spawn_axis" );
			}
		else if ( label == "_b" )
			{
				spawnlogic::add_spawn_points( game["attackers"], "mp_res_spawn_allies_b" );
				spawnlogic::add_spawn_points( game["defenders"], "mp_res_spawn_axis" );
			}
		else
			{
				spawnlogic::add_spawn_points( "allies", "mp_res_spawn_allies_c" );
				spawnlogic::add_spawn_points( "allies", "mp_res_spawn_axis" );
			}
		
		spawning::updateAllSpawnPoints();

		string = &"";
		switch ( label ) 
		{
			case "_a":
			string = &"MP_DOM_FLAG_A_CAPTURED_BY";
			break;
			case "_b":
				string = &"MP_DOM_FLAG_B_CAPTURED_BY";
			break;
			case "_c":
				string = &"MP_DOM_FLAG_C_CAPTURED_BY";
			break;
			case "_d":
				string = &"MP_DOM_FLAG_D_CAPTURED_BY";
			break;
			case "_e":
				string = &"MP_DOM_FLAG_E_CAPTURED_BY";
			break;
			default:
			break;
		}
		assert ( string != &"" );
		
		// Copy touch list so there aren't any threading issues
		touchList = [];
		touchKeys = GetArrayKeys( self.touchList[team] );
		for ( i = 0 ; i < touchKeys.size ; i++ )
			touchList[touchKeys[i]] = self.touchList[team][touchKeys[i]];
		thread give_capture_credit( touchList, string );
	
		thread util::printAndSoundOnEveryone( team, oldTeam, &"", &"", "mp_war_objective_taken", "mp_war_objective_lost", "" );
		
		if ( getTeamFlagCount( team ) == level.flags.size )
		{
	
			statusDialog( "secure_all", team );
			statusDialog( "lost_all", oldTeam );
		}
		else
		{	
			statusDialog( "secured"+self.label, team );
	
			statusDialog( "lost"+self.label, oldTeam );
		}
		
		level.bestSpawnFlag[ oldTeam ] = self.levelFlag;
	
		self update_spawn_influencers( team );
	}
}


function give_capture_credit( touchList, string )
{
	wait .05;
	util::WaitTillSlowProcessAllowed();
	
	
	players = getArrayKeys( touchList );
	for ( i = 0; i < players.size; i++ )
	{
		player_from_touchlist = touchList[players[i]].player;

		//scoreevents::processScoreEvent( "position_secure", player_from_touchlist );
		player_from_touchlist RecordGameEvent("capture"); 
		if( isdefined(player_from_touchlist.pers["captures"]) )
		{
			player_from_touchlist.pers["captures"]++;
			player_from_touchlist.captures = player_from_touchlist.pers["captures"];
		}
		demo::bookmark( "event", gettime(), player_from_touchlist );
		player_from_touchlist AddPlayerStatWithGameType( "CAPTURES", 1 );

		level thread popups::DisplayTeamMessageToAll( string, player_from_touchlist );
	}
}

function delayedLeaderDialog( sound, team )
{
	wait .1;
	util::WaitTillSlowProcessAllowed();
	
	globallogic_audio::leader_dialog( sound, team );
}

function onScoreCloseMusic ()
{
	axisScore = [[level._getTeamScore]]( "axis" );
	alliedScore = [[level._getTeamScore]]( "allies" );
	scoreLimit = level.scoreLimit;
	scoreThreshold = scoreLimit * .1;
	scoreDif = abs(axisScore - alliedScore);
	scoreThresholdStart = abs(scoreLimit - scoreThreshold);
	scoreLimitCheck = scoreLimit - 10;
	
	if( !isdefined( level.playingActionMusic ) )
	    level.playingActionMusic = false;
	
	if (alliedScore > axisScore)
	{
		currentScore = alliedScore;
	}		
	else
	{
		currentScore = axisScore;
	}	
	if( GetDvarint( "debug_music" ) > 0 )
	{
		/#
			println ("Music System Resistance - scoreDif " + scoreDif);
			println ("Music System Resistance - axisScore " + axisScore);
			println ("Music System Resistance - alliedScore " + alliedScore);
			println ("Music System Resistance - scoreLimit " + scoreLimit);							
			println ("Music System Resistance - currentScore " + currentScore);
			println ("Music System Resistance - scoreThreshold " + scoreThreshold);								
			println ("Music System Resistance - scoreDif " + scoreDif);
			println ("Music System Resistance - scoreThresholdStart " + scoreThresholdStart);			
		#/					
	}
	if ( scoreDif <= scoreThreshold && scoreThresholdStart <= currentScore && (level.playingActionMusic != true))
	{
		//play some action music
		thread globallogic_audio::set_music_on_team( "timeOut" );
	}	
	else
	{
		return;
	}	
}	

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( self.touchTriggers.size && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
	{
		triggerIds = getArrayKeys( self.touchTriggers );
		ownerTeam = self.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		team = self.pers["team"];
		
		if ( team == ownerTeam )
		{
			if ( !isdefined( attacker.res_offends ) )
				attacker.res_offends = 0;
				
			attacker.res_offends++;
			
			if ( level.playerOffensiveMax >= attacker.res_offends )
			{
				attacker medals::offenseGlobalCount();
				attacker AddPlayerStatWithGameType( "OFFENDS", 1 );

				scoreevents::processScoreEvent( "killed_defender", attacker );
				self RecordKillModifier("defending");
			}
		}
		else
		{
			if ( !isdefined( attacker.res_defends ) )
				attacker.res_defends = 0;

			attacker.res_defends++;
			
			if ( level.playerDefensiveMax >= attacker.res_defends )
			{

				attacker medals::defenseGlobalCount();
				attacker AddPlayerStatWithGameType( "DEFENDS", 1 );

	
				if( isdefined(attacker.pers["defends"]) )
				{
					attacker.pers["defends"]++;
					attacker.defends = attacker.pers["defends"];
				}
	
				scoreevents::processScoreEvent( "killed_attacker", attacker, undefined, weapon );
				self RecordKillModifier("assaulting");
			}
		}
	}
}

function getTeamFlagCount( team )
{
	score = 0;
	for (i = 0; i < level.flags.size; i++) 
	{
		if ( level.resFlags[i] gameobjects::get_owner_team() == team )
			score++;
	}	
	return score;
}

function getFlagTeam()
{
	return self.useObj gameobjects::get_owner_team();
}

function updateObjectiveHintMessages( alliesObjective, axisObjective )
{
	game["strings"]["objective_hint_allies"] = alliesObjective;
	game["strings"]["objective_hint_axis"  ] = axisObjective;
}


function createFlagSpawnInfluencers()
{
	ss = level.spawnsystem;

	for (flag_index = 0; flag_index < level.flags.size; flag_index++)
	{
		if ( level.resFlags[flag_index] == self )
			break;
	}
	
	// Resistance: owned flag influencers
	self.owned_flag_influencer = self spawning::create_influencer( "res_friendly", self.trigger.origin, 0 );
	
	// Resistance: un-owned inner flag influencers
	self.neutral_flag_influencer = self spawning::create_influencer( "res_neutral", self.trigger.origin, 0 );
		
	// Resistance: enemy flag influencers
	self.enemy_flag_influencer = self spawning::create_influencer( "res_enemy", self.trigger.origin, 0 );
	
	
	// default it to neutral
	self update_spawn_influencers("neutral");
}

function update_spawn_influencers( team )
{
	assert(isdefined(self.neutral_flag_influencer));
	assert(isdefined(self.owned_flag_influencer));
	assert(isdefined(self.enemy_flag_influencer));
	
	if ( team == "neutral" )
	{
		EnableInfluencer(self.neutral_flag_influencer, true);
		EnableInfluencer(self.owned_flag_influencer, false);
		EnableInfluencer(self.enemy_flag_influencer, false);
	}
	else
	{
		EnableInfluencer(self.neutral_flag_influencer, false);
		EnableInfluencer(self.owned_flag_influencer, true);
		EnableInfluencer(self.enemy_flag_influencer, true);
	
		SetInfluencerTeammask(self.owned_flag_influencer, util::getTeamMask(team) );
		SetInfluencerTeammask(self.enemy_flag_influencer, util::getOtherTeamsMask(team) );	
	}
}

function hud_createFlagProgressBar()
{
	level.attackersCaptureProgressHUD = hud::createTeamProgressBar( game["attackers"] );
	level.defendersCaptureProgressHUD = hud::createTeamProgressBar( game["defenders"] );
	
	hud_hideFlagProgressBar();
}

function hud_hideFlagProgressBar()
{
	hud_setflagProgressBar( 0 );
	
	level.attackersCaptureProgressHUD hud::hideElem();
	level.defendersCaptureProgressHUD hud::hideElem();
}

function hud_showFlagProgressBar()
{
	level.attackersCaptureProgressHUD hud::showElem();
	level.defendersCaptureProgressHUD hud::showElem();
}

function hud_setflagProgressBar( value, cappingTeam )
{
	if ( value < 0.0 )
		value = 0.0;
	if ( value > 1.0 )
	  value = 1.0;
	  
	 if ( isdefined( cappingTeam ) ) 
	 {
		if ( cappingTeam == game["attackers"] )
		{
			level.attackersCaptureProgressHUD.bar.color = (255,255,255);
			level.defendersCaptureProgressHUD.bar.color = (255,0,0);
		}
		else
		{
			level.attackersCaptureProgressHUD.bar.color = (255,0,0);
			level.defendersCaptureProgressHUD.bar.color = (255,255,255);
		}
	}			  
	
	level.attackersCaptureProgressHUD hud::updateBar(value ); 
	level.defendersCaptureProgressHUD hud::updateBar(value ); 
}
