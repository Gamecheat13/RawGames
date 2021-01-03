#using scripts\shared\callbacks_shared;
#using scripts\shared\challenges_shared;
#using scripts\shared\demo_shared;
#using scripts\shared\gameobjects_shared;
#using scripts\shared\hostmigration_shared;
#using scripts\shared\math_shared;
#using scripts\shared\popups_shared;
#using scripts\shared\scoreevents_shared;
#using scripts\shared\sound_shared;
#using scripts\shared\util_shared;

    	   	                                                                                                                                         	                                	                                                                                                                                                                                                                                                                                                                                                                    	        	     	             	    	   	               	                                              	                                                           	                               	                     	                                                                                                           	                                                                 	                                                              	                                                                                                              	                            	                                     	                                       	                                                                                                              	   	                  	       	                                                    	                   	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                        	                                  	                                                                                        	           	                        	                                            	                                             	                                                   	                                                             	                                                         	                                                                    	                                                                                                                                                                                                    	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         	                                                              	                                                          	                                   	                                   	                                                    	                                       	                                           	     	                                                                                                                                                                                                                                                      	                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                     
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            	                           	                           	                                                                                                                                                                                                                                                            	                                                                                                                                                                                                                                                                                                                                                                                       

#using scripts\mp\gametypes\_globallogic;
#using scripts\mp\gametypes\_globallogic_audio;
#using scripts\mp\gametypes\_globallogic_score;
#using scripts\mp\gametypes\_globallogic_utils;
#using scripts\mp\gametypes\_hostmigration;
#using scripts\mp\gametypes\_spawning;
#using scripts\mp\gametypes\_spawnlogic;

#using scripts\mp\_challenges;
#using scripts\mp\_util;
#using scripts\mp\teams\_teams;

/*
	Domination
	Objective: 	Capture all the flags by touching them
	Map ends:	When one team captures all the flags, or time limit is reached
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
			targetname      flag_primary or flag_secondary
			Flags that need to be captured to win. Primary flags take time to capture; secondary flags are instant.
		
		Flag Descriptors:
			classname       script_origin
			targetname      flag_descriptor
			Place one flag descriptor close to each flag. Use the script_linkname and script_linkto properties to say which flags
			it can be considered "adjacent" to in the level. For instance, if players have a primary path from flag1 to flag2, and 
			from flag2 to flag3, flag2 would have a flag_descriptor with these properties:
			script_linkname flag2
			script_linkto flag1 flag3
			
			Set scr_domdebug to 1 to see flag connections and what spawnpoints are considered connected to each flag.

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

/*QUAKED mp_dom_spawn (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_flag_a (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_flag_b (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_flag_c (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_axis_start (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_dom_spawn_allies_start (0.0 1.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

#precache( "string", "OBJECTIVES_DOM" );
#precache( "string", "OBJECTIVES_DOM_SCORE" );
#precache( "string", "OBJECTIVES_DOM_HINT" );
#precache( "string", "MP_CAPTURING_FLAG" );
#precache( "string", "MP_LOSING_FLAG" );
#precache( "string", "MP_DOM_YOUR_FLAG_WAS_CAPTURED" );
#precache( "string", "MP_DOM_ENEMY_FLAG_CAPTURED" );
#precache( "string", "MP_DOM_NEUTRAL_FLAG_CAPTURED" );
#precache( "string", "MP_ENEMY_FLAG_CAPTURED_BY" );
#precache( "string", "MP_NEUTRAL_FLAG_CAPTURED_BY" );
#precache( "string", "MP_FRIENDLY_FLAG_CAPTURED_BY" );
#precache( "string", "MP_DOM_FLAG_A_CAPTURED_BY" );	
#precache( "string", "MP_DOM_FLAG_B_CAPTURED_BY" );	
#precache( "string", "MP_DOM_FLAG_C_CAPTURED_BY" );	
#precache( "string", "MP_DOM_FLAG_D_CAPTURED_BY" );	
#precache( "string", "MP_DOM_FLAG_E_CAPTURED_BY" );	
#precache( "fx", "ui/fx_ui_flagbase_blue" );
#precache( "fx", "ui/fx_ui_flagbase_orng" );
#precache( "fx", "ui/fx_ui_flagbase_wht" );
#precache( "objective", "dom_a" );	
#precache( "objective", "dom_b" );	
#precache( "objective", "dom_c" );	



function main()
{
	globallogic::init();

	util::registerTimeLimit( 0, 1440 );
	util::registerScoreLimit( 0, 2000 );
	util::registerRoundScoreLimit( 0, 2000 );
	util::registerRoundLimit( 0, 10 );
	util::registerRoundWinLimit( 0, 10 );
	util::registerRoundSwitch( 0, 9 );
	util::registerNumLives( 0, 100 );

	globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );
	
	level.scoreRoundWinBased = ( GetGametypeSetting( "cumulativeRoundScores" ) == false );
	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType =&onStartGameType;
	level.onPlayerKilled =&onPlayerKilled;
	level.onRoundSwitch =&onRoundSwitch;
	level.onPrecacheGameType =&onPrecacheGameType;
	level.onEndGame=&onEndGame;
	level.onRoundEndGame =&onRoundEndGame;
	
	gameobjects::register_allowed_gameobject( level.gameType );

	globallogic_audio::set_leader_gametype_dialog ( "startDomination", "hcStartDomination", "objCapture", "objCapture" );
	
	game["dialog"]["securing_a"] = "domFriendlySecuringA";
	game["dialog"]["securing_b"] = "domFriendlySecuringB";
	game["dialog"]["securing_c"] = "domFriendlySecuringC";
	
	game["dialog"]["secured_a"] = "domFriendlySecuredA";
	game["dialog"]["secured_b"] = "domFriendlySecuredB";
	game["dialog"]["secured_c"] = "domFriendlySecuredC";
	
	game["dialog"]["secured_all"] = "domFriendlySecuredAll";
	
	game["dialog"]["losing_a"] = "domEnemySecuringA";
	game["dialog"]["losing_b"] = "domEnemySecuringB";
	game["dialog"]["losing_c"] = "domEnemySecuringC";
	
	game["dialog"]["lost_a"] = "domEnemySecuredA";
	game["dialog"]["lost_b"] = "domEnemySecuredB";
	game["dialog"]["lost_c"] = "domEnemySecuredC";
	
	game["dialog"]["lost_all"] = "domEnemySecuredAll";
	
	game["dialog"]["enemy_a"] = "domEnemyHasA";
	game["dialog"]["enemy_b"] = "domEnemyHasB";
	game["dialog"]["enemy_c"] = "domEnemyHasC";

	game["dialogTime"] = [];
	game["dialogTime"]["securing_a"] = 0;
	game["dialogTime"]["securing_b"] = 0;
	game["dialogTime"]["securing_c"] = 0;
	game["dialogTime"]["losing_a"] = 0;
	game["dialogTime"]["losing_b"] = 0;
	game["dialogTime"]["losing_c"] = 0;
	
	// Sets the scoreboard columns and determines with data is sent across the network
	if ( !SessionModeIsSystemlink() && !SessionModeIsOnlineGame() && IsSplitScreen() )
		// local matches only show the first three columns
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "captures", "defends", "deaths" );
	else
		globallogic::setvisiblescoreboardcolumns( "score", "kills", "deaths" , "captures", "defends");
}


function onPrecacheGameType()
{
}


function onStartGameType()
{	
	util::setObjectiveText( "allies", &"OBJECTIVES_DOM" );
	util::setObjectiveText( "axis", &"OBJECTIVES_DOM" );
	
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}
	
	if ( level.splitscreen )
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_DOM" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_DOM" );
	}
	else
	{
		util::setObjectiveScoreText( "allies", &"OBJECTIVES_DOM_SCORE" );
		util::setObjectiveScoreText( "axis", &"OBJECTIVES_DOM_SCORE" );
	}
	util::setObjectiveHintText( "allies", &"OBJECTIVES_DOM_HINT" );
	util::setObjectiveHintText( "axis", &"OBJECTIVES_DOM_HINT" );
	
	level.flagBaseFXid = [];

//	level.flagBaseFXid[ "friendly" ] 	= "ui/fx_ui_flagbase_blue";
//	level.flagBaseFXid[ "enemy" ] 		= "ui/fx_ui_flagbase_orng";
//	level.flagBaseFXid[ "neutral" ] 	= "ui/fx_ui_flagbase_wht";

	setClientNameMode("auto_change");

	// now that the game objects have been deleted place the influencers
	spawning::create_map_placed_influencers();
	
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	spawnlogic::place_spawn_points( "mp_dom_spawn_allies_start" );
	spawnlogic::place_spawn_points( "mp_dom_spawn_axis_start" );
	
	
	level.mapCenter = math::find_box_center( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = spawnlogic::get_random_intermission_point();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	level.spawn_all = spawnlogic::get_spawnpoint_array( "mp_dom_spawn" );
	
	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  spawnlogic::get_spawnpoint_array("mp_dom_spawn_" + team + "_start");
	}

	flagSpawns = spawnlogic::get_spawnpoint_array( "mp_dom_spawn_flag_a" );
	//assert( flagSpawns.size > 0 );
	
	level.startPos["allies"] = level.spawn_start[ "allies" ][0].origin;
	level.startPos["axis"] = level.spawn_start[ "axis" ][0].origin;
	
			
	if ( !util::isOneRound() && level.scoreRoundWinBased )
	{
		globallogic_score::resetTeamScores();
	}
	
	level.spawnsystem.sideSwitching = 0;
	
	level thread watchForBFlagCap();
	updateGametypeDvars();
	thread domFlags();
	thread updateDomScores();
	level change_dom_spawns();
}

function onEndGame( winningTeam )
{
	for ( i = 0; i < level.domFlags.size; i++ )
	{
		domFlag = level.domFlags[i];
		domFlag gameobjects::allow_use( "none" );
		if ( isdefined( domFlag.singleOwner ) && domFlag.singleOwner == true )
		{
			team = domFlag gameobjects::get_owner_team();	
			label = domFlag gameobjects::get_label();
			challenges::holdFlagEntireMatch( team,  label );
		}
	}
}

function onRoundEndGame( roundWinner )
{
	if ( level.scoreRoundWinBased ) 
	{
		foreach( team in level.teams )
		{
			[[level._setTeamScore]]( team, game["roundswon"][team] );
		}
	
		winner = globallogic::determineTeamWinnerByGameStat( "roundswon" );
	}
	else
	{
		winner = globallogic::determineTeamWinnerByTeamScore();
	}
	
	return winner;
}

function updateGametypeDvars()
{
	level.flagCaptureTime = GetGametypeSetting( "captureTime" );
	level.playerCaptureLPM = GetGametypeSetting( "maxPlayerEventsPerMinute" );
	level.flagCaptureLPM = GetGametypeSetting( "maxObjectiveEventsPerMinute" );
	level.playerOffensiveMax = GetGametypeSetting( "maxPlayerOffensive" );
	level.playerDefensiveMax = GetGametypeSetting( "maxPlayerDefensive" );
	level.flagCanBeNeutralized = GetGametypeSetting( "flagCanBeNeutralized" );
}

function domFlags()
{
	level.lastStatus["allies"] = 0;
	level.lastStatus["axis"] = 0;
	
	level.flagModel["allies"] = "tag_origin"; // teams::get_flag_model( "allies" );
	level.flagModel["axis"] = "tag_origin"; // teams::get_flag_model( "axis" );
	level.flagModel["neutral"] = "tag_origin"; // teams::get_flag_model( "neutral" );

	primaryFlags = getEntArray( "flag_primary", "targetname" );
	
	if ( (primaryFlags.size) < 2 )
	{
	/#	printLn( "^1Not enough domination flags found in level!" );	#/
		callback::abort_level();
		return;
	}
	
	level.flags = [];
	foreach( dom_flag in primaryFlags )
	{
		if ( isdefined( dom_flag.target ) )
		{
			trigger = getEnt( dom_flag.target, "targetname" );
			
			if ( isDefined( trigger ) )
			{
				trigger.visual = dom_flag;
				trigger.script_label = dom_flag.script_label;
			}
			else
			{
			/#
			util::error("Trigger not available for flag " + dom_flag.script_label + " with targetname " + dom_flag.target);
			#/
			}
		}
		else
		{
			/#
			util::error("Trigger not available for flag " + dom_flag.script_label);
			#/
		}

		level.flags[level.flags.size] = trigger;
	}
	
	level.domFlags = [];
	foreach( trigger in level.flags )
	{
		trigger.visual setModel( level.flagModel["neutral"] );
		
		name = istring("dom" + trigger.visual.script_label);

		visuals = [];
		visuals[0] = trigger.visual;
		
		domFlag = gameobjects::create_use_object( "neutral", trigger, visuals, (0,0,0), name );
		domFlag gameobjects::allow_use( "enemy" );
		domFlag gameobjects::set_use_time( level.flagCaptureTime );
		domFlag gameobjects::set_use_text( &"MP_CAPTURING_FLAG" );
		label = domFlag gameobjects::get_label();	
		domFlag.label = label;
		domFlag.flagIndex = trigger.visual.script_index;
		domFlag gameobjects::set_visible_team( "any" );
		domFlag.onUse =&onUse;
		domFlag.onBeginUse =&onBeginUse;
		domFlag.onUseUpdate =&onUseUpdate;
		domFlag.onEndUse =&onEndUse;	
		domFlag.onUpdateUseRate =&onUpdateUseRate;	
		
		domFlag gameobjects::set_objective_entity( visuals[ 0 ] );
		domFlag gameobjects::set_owner_team( "neutral" );
		
		traceStart = visuals[0].origin + (0,0,32);
		traceEnd = visuals[0].origin + (0,0,-32);
		trace = bulletTrace( traceStart, traceEnd, false, undefined );
	
		upangles = vectorToAngles( trace["normal"] );
		domFlag.baseeffectforward = anglesToForward( upangles );
		domFlag.baseeffectright = anglesToRight( upangles );
		
		domFlag.baseeffectpos = trace["position"];

//		domFlag.friendlyBaseEffect = spawnFx( level.flagBaseFXid[ "friendly" ], domFlag.baseeffectpos, domFlag.baseeffectforward, domFlag.baseeffectright );
//		domFlag.enemyBaseEffect = spawnFx( level.flagBaseFXid[ "enemy" ], domFlag.baseeffectpos, domFlag.baseeffectforward, domFlag.baseeffectright );
//		domFlag.neutralBaseEffect = spawnFx( level.flagBaseFXid[ "neutral" ], domFlag.baseeffectpos, domFlag.baseeffectforward, domFlag.baseeffectright );
//	
//		triggerFx( domFlag.friendlyBaseEffect, 0.001 );
//		triggerFx( domFlag.enemyBaseEffect, 0.001 );
//		triggerFx( domFlag.neutralBaseEffect, 0.001 );

		domFlag resetFlagBaseEffect();
		
		// legacy spawn code support
		trigger.useObj = domFlag;
		trigger.adjflags = [];
		trigger.nearbyspawns = [];
		
		domFlag.levelFlag = trigger;
		
		level.domFlags[level.domFlags.size] = domFlag;
	}
	
	// level.bestSpawnFlag is used as a last resort when the enemy holds all flags.
	level.bestSpawnFlag = [];
	level.bestSpawnFlag[ "allies" ] = getUnownedFlagNearestStart( "allies", undefined );
	level.bestSpawnFlag[ "axis" ] = getUnownedFlagNearestStart( "axis", level.bestSpawnFlag[ "allies" ] );
	
	for ( index = 0; index < level.domFlags.size; index++ )
	{
		level.domFlags[index] createFlagSpawnInfluencers();
	}
	
	flagSetup();

	/#
	thread domDebug();
	#/
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

/#
function domDebug()
{
	while(1)
	{
		if (GetDvarString( "scr_domdebug") != "1") {
			wait 2;
			continue;
		}
		
		while(1)
		{
			if (GetDvarString( "scr_domdebug") != "1")
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

function onBeginUse( player )
{
	ownerTeam = self gameobjects::get_owner_team();
//	SetDvar( "scr_obj" + self gameobjects::get_label() + "_flash", 1 );	
	self.didStatusNotify = false;
	if ( ownerTeam == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";

	if ( ownerTeam == "neutral" )
	{
		otherTeam = util::getOtherTeam( player.pers["team"] );
		statusDialog( "securing"+self.label, player.pers["team"], "objective" + self.label );
//		self.objPoints[player.pers["team"]] thread objpoints::start_flashing();
		return;
	}
		
//	self.objPoints["allies"] thread objpoints::start_flashing();
//	self.objPoints["axis"] thread objpoints::start_flashing();
}

function onUseUpdate( team, progress, change )
{
	if ( progress > 0.05 && change && !self.didStatusNotify )
	{
		ownerTeam = self gameobjects::get_owner_team();
		if ( ownerTeam == "neutral" )
		{
			otherTeam = util::getOtherTeam( team );
			statusDialog( "securing"+self.label, team, "objective" + self.label );
			//statusDialog( "losing"+self.label, otherTeam, "objective" + self.label );
		}
		else
		{
			statusDialog( "losing"+self.label, ownerTeam, "objective" + self.label );
			statusDialog( "securing"+self.label, team, "objective" + self.label );
			globallogic_audio::flush_objective_dialog( "objective_all" );
		}

		self.didStatusNotify = true;
	}
	else if( level.flagCanBeNeutralized && ( progress > 0.49 ) && change && self.didStatusNotify )
	{
		ownerTeam = self gameobjects::get_owner_team();
		if ( ownerTeam != "neutral" )
		{
			self thread setFlagNeutral();
			statusDialog( "lost"+self.label, ownerTeam, "objective" + self.label );
			globallogic_audio::flush_objective_dialog( "objective_all" );
		}
	}
}

function setFlagNeutral()
{
	self notify("flag_neutral");
	
	self gameobjects::set_owner_team( "neutral" );
	self.visuals[0] SetModel( level.flagModel["neutral"] );
	
	self resetFlagBaseEffect();
}

function flushObjectiveFlagDialog()
{
	globallogic_audio::flush_objective_dialog( "objective_a" );
	globallogic_audio::flush_objective_dialog( "objective_b" );
	globallogic_audio::flush_objective_dialog( "objective_c" );
}

function statusDialog( dialog, team, objectiveKey )
{
	// Don't play some dialog over and over
	dialogTime = game["dialogTime"][dialog];
	if ( isdefined( dialogTime) )
	{
		time = GetTime();
		
		if ( dialogTime > time )
		{
			return;
		}
		
		game["dialogTime"][dialog] = time + 10000;
	}
	
	dialogKey = game["dialog"][dialog];
	
	if( isdefined( objectiveKey ) )
	{
		if( objectiveKey != "objective_all" )
		{
			dialogBufferKey = "domPointDialogBuffer";		
		}
	}
	
	globallogic_audio::leader_dialog( dialogKey, team, undefined, objectiveKey, undefined, dialogBufferKey );
}


function onEndUse( team, player, success )
{
	if ( !success )
	{
		globallogic_audio::flush_objective_dialog( "objective" + self.label );
	}
}


function resetFlagBaseEffect()
{
//	team = self gameobjects::get_owner_team();
//
//	if ( team == "neutral" )
//	{
//		self.friendlyBaseEffect Hide();
//		self.enemyBaseEffect Hide();
//		self.neutralBaseEffect Show();
//	}
//	else
//	{
//		self.friendlyBaseEffect Show();
//		self.enemyBaseEffect Show();
//		self.neutralBaseEffect Hide();
//	
//		otherTeam = util::getOtherTeam( team );
//	
//		self.friendlyBaseEffect HideFromTeam( otherTeam );
//		self.enemyBaseEffect HideFromTeam( team );
//	}
}

function onUse( player )
{
	level notify( "flag_captured" );
	team = player.pers["team"];
	oldTeam = self gameobjects::get_owner_team();
	label = self gameobjects::get_label();
	
	/#print( "flag captured: " + self.label );#/

	self gameobjects::set_owner_team( team );
	self.visuals[0] setModel( level.flagModel[team] );
	SetDvar( "scr_obj" + self gameobjects::get_label(), team );	
	
	self resetFlagBaseEffect();
	
	level.useStartSpawns = false;
	
	assert( team != "neutral" );

	isBFlag = false;
	string = &"";
	switch ( label ) 
	{
		case "_a":
		string = &"MP_DOM_FLAG_A_CAPTURED_BY";
		break;
		case "_b":
			string = &"MP_DOM_FLAG_B_CAPTURED_BY";
			isBFlag = true;
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
	thread give_capture_credit( touchList, string, oldTeam, isBFlag );

	bbPrint( "mpobjective", "gametime %d objtype %s label %s team %s playerx %d playery %d playerz %d", gettime(), "dom_capture", label, team, player.origin );

	if ( oldTeam == "neutral" )
	{
		self.singleOwner = true;
		otherTeam = util::getOtherTeam( team );
		thread util::printAndSoundOnEveryone( team, undefined, &"", undefined, "mp_war_objective_taken" );
		
		thread sound::play_on_players( "mus_dom_captured"+"_"+level.teamPostfix[team] );
		if ( getTeamFlagCount( team ) == level.flags.size )
		{
			statusDialog( "secured_all", team, "objective_all" );
			statusDialog( "lost_all", otherTeam, "objective_all" );
			flushObjectiveFlagDialog();
		}
		else
		{
			statusDialog( "secured"+self.label, team, "objective" + self.label );
			statusDialog( "enemy"+self.label, otherTeam, "objective" + self.label );
			globallogic_audio::flush_objective_dialog( "objective_all" );
			globallogic_audio::play_2d_on_team( "mpl_flagcapture_sting_enemy", otherTeam );
			globallogic_audio::play_2d_on_team( "mpl_flagcapture_sting_friend", team );			
		}
	}
	else
	{
		self.singleOwner = false;
		thread util::printAndSoundOnEveryone( team, oldTeam, &"", &"", "mp_war_objective_taken", "mp_war_objective_lost", "" );
		
//		thread sound::play_on_players( "mus_dom_captured"+"_"+level.teamPostfix[team] );
		if ( getTeamFlagCount( team ) == level.flags.size )
		{
			statusDialog( "secured_all", team, "objective_all" );
			statusDialog( "lost_all", oldTeam, "objective_all" );
			flushObjectiveFlagDialog();
		}
		else
		{	
			statusDialog( "secured"+self.label, team, "objective" + self.label );
			if( RandomInt(2) )
			{
				statusDialog( "lost"+self.label, oldTeam, "objective" + self.label );
			}
			else
			{
				statusDialog( "enemy"+self.label, oldTeam, "objective" + self.label );
			}
			globallogic_audio::flush_objective_dialog( "objective_all" );
			globallogic_audio::play_2d_on_team( "mpl_flagcapture_sting_enemy", oldTeam );
			globallogic_audio::play_2d_on_team( "mpl_flagcapture_sting_friend", team );					
		}
		
		level.bestSpawnFlag[ oldTeam ] = self.levelFlag;
	}

	if ( dominated_challenge_check() ) 
	{
		level thread totalDomination( team );
	}
	self update_spawn_influencers( team );
	level change_dom_spawns();
}

function totalDomination( team )
{
	level endon( "flag_captured" );
	level endon( "game_ended" );
	
	wait ( 180 );
	
	challenges::totalDomination( team );
}


function watchForBFlagCap()
{
	level endon( "game_ended" );
	level endon( "endWatchForBFlagCapAfterTime" );

	level thread endWatchForBFlagCapAfterTime( 60 );
	for (;;)
	{
		level waittill( "b_flag_captured", player );
		player challenges::capturedBFirstMinute();
	}
}

function endWatchForBFlagCapAfterTime( time )
{
	level endon( "game_ended" );
	wait( 60 );
	level notify( "endWatchForBFlagCapAfterTime" );
}

function give_capture_credit( touchList, string, lastOwnerTeam, isBFlag )
{
	time = getTime();
	wait .05;
	util::WaitTillSlowProcessAllowed();
	
	self updateCapsPerMinute(lastOwnerTeam);
	
	players = getArrayKeys( touchList );
	for ( i = 0; i < players.size; i++ )
	{
		player_from_touchlist = touchList[players[i]].player;
		player_from_touchlist updateCapsPerMinute(lastOwnerTeam);
		if ( !isScoreBoosting( player_from_touchlist, self ) )
		{
			player_from_touchlist challenges::capturedObjective( time );
			if (lastOwnerTeam == "neutral" )
			{
				if ( isBFlag )
				{
					scoreevents::processScoreEvent( "dom_point_neutral_b_secured", player_from_touchlist );
				}
				else
				{
					scoreevents::processScoreEvent( "dom_point_neutral_secured", player_from_touchlist );
				}
			}
			else
			{
				scoreevents::processScoreEvent( "dom_point_secured", player_from_touchlist );
			}
			
			player_from_touchlist RecordGameEvent("capture");
			if ( isBFlag )
			{
				level notify( "b_flag_captured", player_from_touchlist );
			}
			if( isdefined(player_from_touchlist.pers["captures"]) )
			{
				player_from_touchlist.pers["captures"]++;
				player_from_touchlist.captures = player_from_touchlist.pers["captures"];
			}
			demo::bookmark( "event", gettime(), player_from_touchlist );
			player_from_touchlist AddPlayerStatWithGameType( "CAPTURES", 1 );
		}
		else
		{
			/#
				player_from_touchlist IPrintlnBold( "GAMETYPE DEBUG: NOT GIVING YOU CAPTURE CREDIT AS BOOSTING PREVENTION" );
			#/
		}

		level thread popups::DisplayTeamMessageToAll( string, player_from_touchlist );
	}
}

function updateDomScores()
{
	//level.playingActionMusic = false;			

	while ( !level.gameEnded )
	{
		numOwnedFlags = 0;
		
		scoring_teams = [];
		
		numFlags = getTeamFlagCount( "allies" );
		numOwnedFlags += numFlags;
		if ( numFlags )
		{
			scoring_teams[scoring_teams.size] = "allies";
			globallogic_score::giveTeamScoreForObjective_DelayPostProcessing( "allies", numFlags );
		}

		numFlags = getTeamFlagCount( "axis" );
		numOwnedFlags += numFlags;
		if ( numFlags )
		{
			scoring_teams[scoring_teams.size] = "axis";
			globallogic_score::giveTeamScoreForObjective_DelayPostProcessing( "axis", numFlags );
		}

		if ( numOwnedFlags )
			globallogic_score::postProcessTeamScores( scoring_teams );

		onScoreCloseMusic();
		
		// end the game if people aren't playing
		timePassed = globallogic_utils::getTimePassed();
		if ( (((timePassed / 1000) > 120 && numOwnedFlags < 2) || ((timePassed / 1000) > 300 && numOwnedFlags < 3)) && ( GameModeIsMode( 0 ) ) )
		{
			thread globallogic::endGame( "tie", game["strings"]["time_limit_reached"] );
			return;
		}
		
		wait ( 5.0 );
		hostmigration::waitTillHostMigrationDone();
	}
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
	
	if( !isdefined( level.sndHalfway ) )
		level.sndHalfway = false;
	
	if (alliedScore > axisScore)
	{
		currentScore = alliedScore;
	}		
	else
	{
		currentScore = axisScore;
	}	
	/#
	if( GetDvarint( "debug_music" ) > 0 )
	{
			println ("Music System Domination - scoreDif " + scoreDif);
			println ("Music System Domination - axisScore " + axisScore);
			println ("Music System Domination - alliedScore " + alliedScore);
			println ("Music System Domination - scoreLimit " + scoreLimit);							
			println ("Music System Domination - currentScore " + currentScore);
			println ("Music System Domination - scoreThreshold " + scoreThreshold);								
			println ("Music System Domination - scoreDif " + scoreDif);
			println ("Music System Domination - scoreThresholdStart " + scoreThresholdStart);									
	}
	#/
	if ( scoreDif <= scoreThreshold && scoreThresholdStart <= currentScore && (level.playingActionMusic != true))
	{
		//play some action music
//		thread globallogic_audio::set_music_on_team( "timeOut" );
	}	

	halfwayScore = scoreLimit*.5;
	if( isdefined( level.roundScoreLimit ) )
	{
		halfwayScore = level.roundScoreLimit*.5;
		if( game[ "roundsplayed" ] == 1 )
		{
			halfwayScore += level.roundScoreLimit;
		}
	}
	
	if( ((axisScore >= halfwayScore) || (alliedScore >= halfwayScore)) && !level.sndHalfway )
	{
		
		level notify( "sndMusicHalfway" );
		level.sndHalfway = true;
	}
	
}	

function onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	game["switchedsides"] = !game["switchedsides"];

	if ( level.scoreRoundWinBased ) 
	{
		[[level._setTeamScore]]( "allies", game["roundswon"]["allies"] );
		[[level._setTeamScore]]( "axis", game["roundswon"]["axis"] );
	}
}

function onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, weapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( isdefined( attacker ) && isplayer( attacker ) )
	{
		scoreEventProcessed = false;
		if ( attacker.touchTriggers.size && attacker.pers["team"] != self.pers["team"] )
	    {
		    triggerIds = getArrayKeys( attacker.touchTriggers );
		    ownerTeam = attacker.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		    team = attacker.pers["team"];
		    if ( team != ownerTeam )
		    {
			    scoreevents::processScoreEvent( "kill_enemy_while_capping_dom", attacker, undefined, weapon );
			    scoreEventProcessed = true;
		    }
	    }
		
		for ( index = 0; index < level.flags.size; index++ )
		{
			flagTeam = "invalidTeam";
			inFlagZone = false;
			defendedFlag = false;
			offendedFlag = false;
	
			flagOrigin = level.flags[index].origin;
				
			level.defaultOffenseRadius = 300;
			dist = Distance2d(self.origin, flagOrigin);
			if ( dist < level.defaultOffenseRadius )
			{
				inFlagZone = true;
				if ( level.flags[index] getFlagTeam() == attacker.pers["team"] || level.flags[index] getFlagTeam() == "neutral" )
					defendedFlag = true;
				else
					offendedFlag = true;					
			}
			dist = Distance2d(attacker.origin, flagOrigin);
			if ( dist < level.defaultOffenseRadius )
			{
				inFlagZone = true;
				if ( level.flags[index] getFlagTeam() == attacker.pers["team"] || level.flags[index] getFlagTeam() == "neutral" )
					defendedFlag = true;
				else
					offendedFlag = true;					
			}

			if ( inFlagZone && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
			{	
				if ( offendedFlag )
				{
					if ( !isdefined( attacker.dom_defends ) )
					attacker.dom_defends = 0;

					attacker.dom_defends++;
					if ( level.playerDefensiveMax >= attacker.dom_defends )
					{
						attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
						if (!scoreeventprocessed)
						{
							scoreevents::processScoreEvent( "killed_defender", attacker, undefined, weapon );
						}
						self RecordKillModifier("defending");
						break;
					}
					else
					{
						/#
							attacker IPrintlnBold( "GAMETYPE DEBUG: NOT GIVING YOU DEFENSIVE CREDIT AS BOOSTING PREVENTION" );
						#/
					}
					

				}
				if ( defendedFlag )
				{
					if ( !isdefined( attacker.dom_offends ) )
						attacker.dom_offends = 0;
				
					attacker thread updateattackermultikills();
					
					attacker.dom_offends++;
					if ( level.playerOffensiveMax >= attacker.dom_offends )
					{
						attacker.pers["defends"]++;
						attacker.defends = attacker.pers["defends"];
						attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
						attacker RecordGameEvent("return");
						attacker challenges::killedZoneAttacker( weapon );
						if (!scoreeventprocessed)
						{
							scoreevents::processScoreEvent( "killed_attacker", attacker, undefined, weapon );
						}
						self RecordKillModifier("assaulting");
						break;
					}
					else
					{
						/#
							attacker IPrintlnBold( "GAMETYPE DEBUG: NOT GIVING YOU OFFENSIVE CREDIT AS BOOSTING PREVENTION" );
						#/
					}
				}
			}
		}
		   
	    if ( self.touchTriggers.size && attacker.pers["team"] != self.pers["team"] )
	    {
		    triggerIds = getArrayKeys( self.touchTriggers );
		    ownerTeam = self.touchTriggers[triggerIds[0]].useObj.ownerTeam;
		    team = self.pers["team"];
		    if ( team != ownerTeam )
		    {
		    	flag = self.touchTriggers[triggerIds[0]].useObj;
		    	if ( isdefined( flag.contested ) && flag.contested == true) 
		    	{
		    		attacker killWhileContesting( flag );
		    	}
		    }
	    }
	}
}

function killWhileContesting( flag )
{	
	self notify( "killWhileContesting" );
	self endon( "killWhileContesting" );
	self endon( "disconnect" );
	
	killTime = getTime();
	playerteam = self.pers["team"];
	if ( !isdefined ( self.clearEnemyCount ) )
	{
		self.clearEnemyCount = 0;
	}
	
	self.clearEnemyCount++;
	
	flag waittill( "contest_over" );

			
	if (playerteam != self.pers["team"] || ( isdefined( self.spawntime ) && ( killTime < self.spawntime ) ) )
	{
		self.clearEnemyCount = 0;
		return;
	}
	if ( flag.ownerTeam != playerteam && flag.ownerTeam != "neutral" )
	{
		self.clearEnemyCount = 0;
			return;	
	}
	
	if ( self.clearEnemyCount >= 2 && killTime + 200 > getTime() )
	{
		scoreevents::processScoreEvent( "clear_2_attackers", self );
	}
	self.clearEnemyCount = 0;
}


function updateattackermultikills()
{
	self endon ( "disconnect" );
	level endon ( "game_ended" );
	
	self notify ( "updateDomRecentKills" );
	self endon ( "updateDomRecentKills" );
	if ( !isdefined (self.recentDomAttackerKillCount) )
	{
		self.recentDomAttackerKillCount = 0;
	}
	self.recentDomAttackerKillCount++;

	wait ( 4.0 );


	if ( self.recentDomAttackerKillCount > 1 )
		self challenges::domAttackerMultiKill( self.recentDomAttackerKillCount );
	
	self.recentDomAttackerKillCount = 0;
}



function getTeamFlagCount( team )
{
	score = 0;
	for (i = 0; i < level.flags.size; i++) 
	{
		if ( level.domFlags[i] gameobjects::get_owner_team() == team )
			score++;
	}	
	return score;
}

function getFlagTeam()
{
	return self.useObj gameobjects::get_owner_team();
}

function getBoundaryFlags()
{
	// get all flags which are adjacent to flags that aren't owned by the same team
	bflags = [];
	for (i = 0; i < level.flags.size; i++)
	{
		for (j = 0; j < level.flags[i].adjflags.size; j++)
		{
			if (level.flags[i].useObj gameobjects::get_owner_team() != level.flags[i].adjflags[j].useObj gameobjects::get_owner_team() )
			{
				bflags[bflags.size] = level.flags[i];
				break;
			}
		}
	}
	
	return bflags;
}

function getBoundaryFlagSpawns(team)
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

function getSpawnsBoundingFlag( avoidflag )
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
function getOwnedAndBoundingFlagSpawns(team)
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
function getOwnedFlagSpawns(team)
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

function flagSetup()
{
	maperrors = [];
	descriptorsByLinkname = [];

	// (find each flag_descriptor object)
	descriptors = getentarray("flag_descriptor", "targetname");
	
	flags = level.flags;
	
	for (i = 0; i < level.domFlags.size; i++)
	{
		closestdist = undefined;
		closestdesc = undefined;
		for (j = 0; j < descriptors.size; j++)
		{
			dist = distance(flags[i].origin, descriptors[j].origin);
			if (!isdefined(closestdist) || dist < closestdist) {
				closestdist = dist;
				closestdesc = descriptors[j];
			}
		}
		
		if (!isdefined(closestdesc)) {
			maperrors[maperrors.size] = "there is no flag_descriptor in the map! see explanation in dom.gsc";
			break;
		}
		if (isdefined(closestdesc.flag)) {
			maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + closestdesc.script_linkname + "\" is nearby more than one flag; is there a unique descriptor near each flag?";
			continue;
		}
		flags[i].descriptor = closestdesc;
		closestdesc.flag = flags[i];
		descriptorsByLinkname[closestdesc.script_linkname] = closestdesc;
	}
	
	if (maperrors.size == 0)
	{
		// find adjacent flags
		for (i = 0; i < flags.size; i++)
		{
			if (isdefined(flags[i].descriptor.script_linkto))
				adjdescs = strtok(flags[i].descriptor.script_linkto, " ");
			else
				adjdescs = [];
			for (j = 0; j < adjdescs.size; j++)
			{
				otherdesc = descriptorsByLinkname[adjdescs[j]];
				if (!isdefined(otherdesc) || otherdesc.targetname != "flag_descriptor") {
					maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname + "\" linked to \"" + adjdescs[j] + "\" which does not exist as a script_linkname of any other entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
					continue;
				}
				adjflag = otherdesc.flag;
				if (adjflag == flags[i]) {
					maperrors[maperrors.size] = "flag_descriptor with script_linkname \"" + flags[i].descriptor.script_linkname + "\" linked to itself";
					continue;
				}
				flags[i].adjflags[flags[i].adjflags.size] = adjflag;
			}
		}
	}
	
	// assign each spawnpoint to nearest flag
	spawnpoints = spawnlogic::get_spawnpoint_array( "mp_dom_spawn" );
	for (i = 0; i < spawnpoints.size; i++)
	{
		if (isdefined(spawnpoints[i].script_linkto)) {
			desc = descriptorsByLinkname[spawnpoints[i].script_linkto];
			if (!isdefined(desc) || desc.targetname != "flag_descriptor") {
				maperrors[maperrors.size] = "Spawnpoint at " + spawnpoints[i].origin + "\" linked to \"" + spawnpoints[i].script_linkto + "\" which does not exist as a script_linkname of any entity with a targetname of flag_descriptor (or, if it does, that flag_descriptor has not been assigned to a flag)";
				continue;
			}
			nearestflag = desc.flag;
		}
		else {
			nearestflag = undefined;
			nearestdist = undefined;
			for (j = 0; j < flags.size; j++)
			{
				dist = distancesquared(flags[j].origin, spawnpoints[i].origin);
				if (!isdefined(nearestflag) || dist < nearestdist)
				{
					nearestflag = flags[j];
					nearestdist = dist;
				}
			}
		}
		nearestflag.nearbyspawns[nearestflag.nearbyspawns.size] = spawnpoints[i];
	}
	
	if (maperrors.size > 0)
	{
		/#
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");
		util::error("Map errors. See above");
		#/
		callback::abort_level();
		
		return;
	}
}

function createFlagSpawnInfluencers()
{
	ss = level.spawnsystem;

	for (flag_index = 0; flag_index < level.flags.size; flag_index++)
	{
		if ( level.domFlags[flag_index] == self )
			break;
	}
	
	// domination: owned flag influencers
	self.owned_flag_influencer = self spawning::create_influencer( "dom_friendly", self.trigger.origin, 0 );
	
	// domination: un-owned inner flag influencers
	self.neutral_flag_influencer = self spawning::create_influencer( "dom_neutral", self.trigger.origin, 0 );
		
	// domination: enemy flag influencers
	self.enemy_flag_influencer = self spawning::create_influencer( "dom_enemy", self.trigger.origin, 0 );
	
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
 
function addSpawnPointsForFlag( team, flag_team, flagSpawnName ) 
{ 
     // flag_team is the team that owns the flag
     // team is the team we are looking to add spawns for
     // we should add spawns for team only if the flag isn't owned by the enemy team (it may be neutral or owned by us)
     
     if ( game["switchedsides"] ) 
          team = util::getOtherTeam( team ); 

     otherTeam = util::getOtherTeam( team );
     
     if ( flag_team != otherTeam )
     {
          spawnlogic::add_spawn_points( team, flagSpawnName );
     }
}

//Changes what spawns are available to a team based on what Domination point they own
function change_dom_spawns()
{

	spawnlogic::clear_spawn_points();	
	spawnlogic::add_spawn_points( "allies", "mp_dom_spawn" );
	spawnlogic::add_spawn_points( "axis", "mp_dom_spawn" );
	
	//If one team owns all flags, we want to allow both teams to spawn anywhere
	flag_number = level.flags.size;
	if( dominated_check() )
	{
		for ( i = 0 ; i < flag_number ; i++ )
		{
			label = level.flags[i].useobj gameobjects::get_label();
			flagSpawnName = "mp_dom_spawn_flag" + label;
			spawnlogic::add_spawn_points( "allies", flagSpawnName );
			spawnlogic::add_spawn_points( "axis", flagSpawnName );
		}
	}
	else
	{
		for ( i = 0; i < flag_number; i++ )
		{
			//'getlabel' gives us the appropriate "_a" or "_b"
			label = level.flags[i].useobj gameobjects::get_label();
			flagSpawnName = "mp_dom_spawn_flag" + label;
			flag_team = level.flags[i] getFlagTeam();

			addSpawnPointsForFlag( "allies", flag_team, flagSpawnName );
			addSpawnPointsForFlag( "axis", flag_team, flagSpawnName );
		}
	}

	spawning::updateAllSpawnPoints();

}

function dominated_challenge_check()
{
	num_flags = level.flags.size;
	allied_flags = 0;
	axis_flags = 0;

	for ( i = 0 ; i < num_flags ; i++ )
	{
		flag_team = level.flags[i] getFlagTeam();

		if ( flag_team == "allies" )
		{
			allied_flags++;
		}
		else if ( flag_team == "axis" )
		{
			axis_flags++;
		}
		else
		{
			return false;
		}

		if ( ( allied_flags > 0 ) && ( axis_flags > 0 ) )
			return false;
	}

	return true;
}
//This function checks to see if one team owns all three flags
function dominated_check()
{
	num_flags = level.flags.size;
	allied_flags = 0;
	axis_flags = 0;

	for ( i = 0 ; i < num_flags ; i++ )
	{
		flag_team = level.flags[i] getFlagTeam();

		if ( flag_team == "allies" )
		{
			allied_flags++;
		}
		else if ( flag_team == "axis" )
		{
			axis_flags++;
		}
		
		if ( ( allied_flags > 0 ) && ( axis_flags > 0 ) )
			return false;
	}

	return true;
}

function updateCapsPerMinute(lastOwnerTeam)
{
	if ( !isdefined( self.capsPerMinute ) )
	{
		self.numCaps = 0;
		self.capsPerMinute = 0;
	}
	
	// not including neutral flags as part of the boosting prevention
	// to help with false positives at the start
	if ( lastOwnerTeam == "neutral" )
		return;
		
	self.numCaps++;
	
	minutesPassed = globallogic_utils::getTimePassed() / ( 60 * 1000 );
	
	// players use the actual time played
	if ( IsPlayer( self ) && isdefined(self.timePlayed["total"]) )
		minutesPassed = self.timePlayed["total"] / 60;
		
	self.capsPerMinute = self.numCaps / minutesPassed;
	if ( self.capsPerMinute > self.numCaps )
		self.capsPerMinute = self.numCaps;
}

function isScoreBoosting( player, flag )
{
	if ( !level.rankedMatch )
		return false;
		
	if ( player.capsPerMinute > level.playerCaptureLPM )
		return true;
			
	if ( flag.capsPerMinute > level.flagCaptureLPM )
	  return true;
	  
 return false;
}


function onUpdateUseRate()
{
	if ( !isdefined( self.contested ) ) 
	{
		self.contested = false;
	}

	numOther = gameobjects::get_num_touching_except_team( self.ownerTeam );
	numOwners = self.numTouching[self.claimTeam];
	
	previousState = self.contested;
	if ( numOther > 0 && numOwners > 0 ) 
	{
		self.contested = true;
	}
	else
	{
		if ( previousState == true )
		{
			self notify( "contest_over" );
		}
		self.contested = false;
	}
}