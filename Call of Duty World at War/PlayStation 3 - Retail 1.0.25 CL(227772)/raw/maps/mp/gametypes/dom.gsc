#include maps\mp\_utility;
#include maps\mp\_geometry;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_spawning;
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

/*QUAKED mp_dom_spawn (0.5 0.5 1.0) (-16 -16 0) (16 16 72)
Players spawn near their flags at one of these positions.*/

/*QUAKED mp_dom_spawn_axis_start (1.0 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_dom_spawn_allies_start (0.0 1.0 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

main()
{
	if(getdvar("mapname") == "mp_background")
		return;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	// register twar spawn influencer callback
	level.callbackPlayerSpawnGenerateInfluencers= ::domPlayerSpawnGenerateInfluencers;

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "dom", 30, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "dom", 300, 0, 1000 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( "dom", 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "dom", 0, 0, 10 );
	
	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onEndGame= ::onEndGame;

	game["dialog"]["gametype"] = "domination";
	game["dialog"]["offense_obj"] = "capture_objs";
	game["dialog"]["defense_obj"] = "capture_objs";
	level.lastDialogTime = 0;
}


onPrecacheGameType()
{
	precacheShader( "compass_waypoint_captureneutral" );
	precacheShader( "compass_waypoint_capture" );
	precacheShader( "compass_waypoint_defend" );
	precacheShader( "compass_waypoint_captureneutral_a" );
	precacheShader( "compass_waypoint_capture_a" );
	precacheShader( "compass_waypoint_defend_a" );
	precacheShader( "compass_waypoint_captureneutral_b" );
	precacheShader( "compass_waypoint_capture_b" );
	precacheShader( "compass_waypoint_defend_b" );
	precacheShader( "compass_waypoint_captureneutral_c" );
	precacheShader( "compass_waypoint_capture_c" );
	precacheShader( "compass_waypoint_defend_c" );
	precacheShader( "compass_waypoint_captureneutral_d" );
	precacheShader( "compass_waypoint_capture_d" );
	precacheShader( "compass_waypoint_defend_d" );
	precacheShader( "compass_waypoint_captureneutral_e" );
	precacheShader( "compass_waypoint_capture_e" );
	precacheShader( "compass_waypoint_defend_e" );

	precacheShader( "waypoint_captureneutral" );
	precacheShader( "waypoint_capture" );
	precacheShader( "waypoint_defend" );
	precacheShader( "waypoint_captureneutral_a" );
	precacheShader( "waypoint_capture_a" );
	precacheShader( "waypoint_defend_a" );
	precacheShader( "waypoint_captureneutral_b" );
	precacheShader( "waypoint_capture_b" );
	precacheShader( "waypoint_defend_b" );
	precacheShader( "waypoint_captureneutral_c" );
	precacheShader( "waypoint_capture_c" );
	precacheShader( "waypoint_defend_c" );
	precacheShader( "waypoint_captureneutral_d" );
	precacheShader( "waypoint_capture_d" );
	precacheShader( "waypoint_defend_d" );
	precacheShader( "waypoint_captureneutral_e" );
	precacheShader( "waypoint_capture_e" );
	precacheShader( "waypoint_defend_e" );
	
	flagBaseFX = [];
	flagBaseFX["marines"] = "misc/ui_flagbase_blue";
	flagBaseFX["japanese"] = "misc/ui_flagbase_red";
	flagBaseFX["german"] = "misc/ui_flagbase_gold";
	flagBaseFX["russian"] = "misc/ui_flagbase_orange";
	
	level.flagBaseFXid[ "allies" ] = loadfx( flagBaseFX[ game[ "allies" ] ] );
	level.flagBaseFXid[ "axis"   ] = loadfx( flagBaseFX[ game[ "axis"   ] ] );
}


onStartGameType()
{	
	maps\mp\gametypes\_globallogic::setObjectiveText( "allies", &"OBJECTIVES_DOM" );
	maps\mp\gametypes\_globallogic::setObjectiveText( "axis", &"OBJECTIVES_DOM" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_DOM" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_DOM" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "allies", &"OBJECTIVES_DOM_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( "axis", &"OBJECTIVES_DOM_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "allies", &"OBJECTIVES_DOM_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( "axis", &"OBJECTIVES_DOM_HINT" );

	setClientNameMode("auto_change");

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_dom_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_dom_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_dom_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_dom_spawn" );
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );
	
	level.spawn_all = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn" );
	level.spawn_axis_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn_axis_start" );
	level.spawn_allies_start = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn_allies_start" );
	
	level.startPos["allies"] = level.spawn_allies_start[0].origin;
	level.startPos["axis"] = level.spawn_axis_start[0].origin;
	
	allowed[0] = "dom";
//	allowed[1] = "hardpoint";
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
		
	thread domFlags();
	thread updateDomScores();	
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

onEndGame( winningTeam )
{
	for ( i = 0; i < level.domFlags.size; i++ )
	{
		level.domFlags[i] maps\mp\gametypes\_gameobjects::allowUse( "none" );
	}
}

domFlags()
{
	level.lastStatus["allies"] = 0;
	level.lastStatus["axis"] = 0;
	
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
	

	
	precacheString( &"MP_CAPTURING_FLAG" );
	precacheString( &"MP_LOSING_FLAG" );
	//precacheString( &"MP_LOSING_LAST_FLAG" );
	precacheString( &"MP_DOM_YOUR_FLAG_WAS_CAPTURED" );
	precacheString( &"MP_DOM_ENEMY_FLAG_CAPTURED" );
	precacheString( &"MP_DOM_NEUTRAL_FLAG_CAPTURED" );

	precacheString( &"MP_ENEMY_FLAG_CAPTURED_BY" );
	precacheString( &"MP_NEUTRAL_FLAG_CAPTURED_BY" );
	precacheString( &"MP_FRIENDLY_FLAG_CAPTURED_BY" );
	
	
	primaryFlags = getEntArray( "flag_primary", "targetname" );
	secondaryFlags = getEntArray( "flag_secondary", "targetname" );
	
	if ( (primaryFlags.size + secondaryFlags.size) < 2 )
	{
		printLn( "^1Not enough domination flags found in level!" );
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	
	level.flags = [];
	for ( index = 0; index < primaryFlags.size; index++ )
		level.flags[level.flags.size] = primaryFlags[index];
	
	for ( index = 0; index < secondaryFlags.size; index++ )
		level.flags[level.flags.size] = secondaryFlags[index];
	
	level.domFlags = [];
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

		domFlag = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", trigger, visuals, (0,0,100) );
		domFlag maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
		domFlag maps\mp\gametypes\_gameobjects::setUseTime( 10.0 );
		domFlag maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_FLAG" );
		label = domFlag maps\mp\gametypes\_gameobjects::getLabel();
		domFlag.label = label;
		domFlag maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" + label );
		domFlag maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" + label );
		domFlag maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_captureneutral" + label );
		domFlag maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_captureneutral" + label );
		domFlag maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		domFlag.onUse = ::onUse;
		domFlag.onBeginUse = ::onBeginUse;
		domFlag.onUseUpdate = ::onUseUpdate;
		domFlag.onEndUse = ::onEndUse;
		
		
		traceStart = visuals[0].origin + (0,0,32);
		traceEnd = visuals[0].origin + (0,0,-32);
		trace = bulletTrace( traceStart, traceEnd, false, undefined );
	
		upangles = vectorToAngles( trace["normal"] );
		domFlag.baseeffectforward = anglesToForward( upangles );
		domFlag.baseeffectright = anglesToRight( upangles );
		
		domFlag.baseeffectpos = trace["position"];
		
//		makeDvarServerInfo( "scr_obj" + label, "neutral" );
//		makeDvarServerInfo( "scr_obj" + label + "_flash", 0 );
//		setDvar( "scr_obj" + label, "neutral" );
//		setDvar( "scr_obj" + label + "_flash", 0 );

		// legacy spawn code support
		level.flags[index].useObj = domFlag;
		level.flags[index].adjflags = [];
		level.flags[index].nearbyspawns = [];
		
		domFlag.levelFlag = level.flags[index];
		
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
	
//	setDvar( level.scoreLimitDvar, level.domFlags.size );

	/#
	thread domDebug();
	#/
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

onBeginUse( player )
{
	ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	setDvar( "scr_obj" + self maps\mp\gametypes\_gameobjects::getLabel() + "_flash", 1 );	
	self.didStatusNotify = false;

	if ( ownerTeam == "neutral" )
	{
		
		if( getTime() - level.lastDialogTime > 10000 )
		{
			statusDialog( "securing"+self.label, player.pers["team"] );
			level.lastDialogTime = getTime();
		}
		self.objPoints[player.pers["team"]] thread maps\mp\gametypes\_objpoints::startFlashing();
		return;
	}
		
	if ( ownerTeam == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";

	self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::startFlashing();
	self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::startFlashing();
}


onUseUpdate( team, progress, change )
{
	if ( progress > 0.05 && change && !self.didStatusNotify )
	{
		ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
		if ( ownerTeam == "neutral" )
		{
			
			if( getTime() - level.lastDialogTime > 10000 )
			{
				statusDialog( "securing"+self.label, team );
				level.lastDialogTime = getTime();
			}
		}
		else
		{
			if( getTime() - level.lastDialogTime > 10000 )
			{
				statusDialog( "losing"+self.label, ownerTeam );
				statusDialog( "securing"+self.label, team );
				level.lastDialogTime = getTime();
			}
		}

		self.didStatusNotify = true;
	}
}


statusDialog( dialog, team )
{
	time = getTime();
	if ( getTime() < level.lastStatus[team] + 6000 )
		return;
		
	thread delayedLeaderDialog( dialog, team );
	level.lastStatus[team] = getTime();	
}


onEndUse( team, player, success )
{
	setDvar( "scr_obj" + self maps\mp\gametypes\_gameobjects::getLabel() + "_flash", 0 );

	self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::stopFlashing();
	self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::stopFlashing();
}


resetFlagBaseEffect()
{
	if ( isdefined( self.baseeffect ) )
		self.baseeffect delete();
	
	team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	
	if ( team != "axis" && team != "allies" )
		return;
	
	fxid = level.flagBaseFXid[ team ];

	self.baseeffect = spawnFx( fxid, self.baseeffectpos, self.baseeffectforward, self.baseeffectright );
	triggerFx( self.baseeffect );
}

onUse( player )
{
	team = player.pers["team"];
	oldTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	label = self maps\mp\gametypes\_gameobjects::getLabel();
	
	player logString( "flag captured: " + self.label );
	
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( team );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_capture" + label );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_capture" + label );
	self.visuals[0] setModel( game["flagmodels"][team] );
	setDvar( "scr_obj" + self maps\mp\gametypes\_gameobjects::getLabel(), team );	
	
	self resetFlagBaseEffect();
	
	level.useStartSpawns = false;
	
	assert( team != "neutral" );
	
	if ( oldTeam == "neutral" )
	{
		otherTeam = getOtherTeam( team );
		thread printAndSoundOnEveryone( team, otherTeam, &"MP_NEUTRAL_FLAG_CAPTURED_BY", &"MP_NEUTRAL_FLAG_CAPTURED_BY", "mp_war_objective_taken", undefined, player );
		
		thread playSoundOnPlayers( "mx_DOM_captured"+"_"+level.teamPrefix[team] );
		squadID = getplayersquadid( player );
		if( isDefined( squadID ) )
			maps\mp\gametypes\_globallogic::leaderDialog( "secured"+self.label, team, undefined, undefined, "squad_take", squadID );
		else
			statusDialog( "secured"+self.label, team );

		statusDialog( "enemy_has"+self.label, otherTeam );
	}
	else
	{
		thread printAndSoundOnEveryone( team, oldTeam, &"MP_ENEMY_FLAG_CAPTURED_BY", &"MP_FRIENDLY_FLAG_CAPTURED_BY", "mp_war_objective_taken", "mp_war_objective_lost", player );
		
//		thread delayedLeaderDialogBothTeams( "obj_lost", oldTeam, "obj_taken", team );

		thread playSoundOnPlayers( "mx_DOM_captured"+"_"+level.teamPrefix[team] );
		if ( getTeamFlagCount( team ) == level.flags.size )
		{

			statusDialog( "secure_all", team );
			statusDialog( "lost_all", oldTeam );
		}
		else
		{	
			squadID = getplayersquadid( player );
			if( isDefined( squadID ) )
				maps\mp\gametypes\_globallogic::leaderDialog( "secured"+self.label, team, undefined, undefined, "squad_take", squadID );
			else
				statusDialog( "secured"+self.label, team );

			statusDialog( "lost"+self.label, oldTeam );
		}
		
		level.bestSpawnFlag[ oldTeam ] = self.levelFlag;
	}

	self update_spawn_influencers( team );
	
	thread giveFlagCaptureXP( self.touchList[team] );
}

giveFlagCaptureXP( touchList )
{
	wait .05;
	maps\mp\gametypes\_globallogic::WaitTillSlowProcessAllowed();
	
	players = getArrayKeys( touchList );
	for ( index = 0; index < players.size; index++ )
	{
		touchList[players[index]].player thread [[level.onXPEvent]]( "capture" );
		maps\mp\gametypes\_globallogic::givePlayerScore( "capture", touchList[players[index]].player );
		touchList[players[index]].player setStatLBByName( "domination", 1,"points captured" );
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


updateDomScores()
{
	// disable score limit check to allow both axis and allies score to be processed
	level.endGameOnScoreLimit = false;

	while ( !level.gameEnded )
	{

		numFlags = getTeamFlagCount( "allies" );
		if ( numFlags )
			[[level._setTeamScore]]( "allies", [[level._getTeamScore]]( "allies" ) + numFlags );

		numFlags = getTeamFlagCount( "axis" );
		if ( numFlags )
			[[level._setTeamScore]]( "axis", [[level._getTeamScore]]( "axis" ) + numFlags );

		level.endGameOnScoreLimit = true;
		maps\mp\gametypes\_globallogic::checkScoreLimit();
		level.endGameOnScoreLimit = false;
		wait ( 5.0 );
	}
}


onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( self.touchTriggers.size && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
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



getTeamFlagCount( team )
{
	score = 0;
	for (i = 0; i < level.flags.size; i++) 
	{
		if ( level.domFlags[i] maps\mp\gametypes\_gameobjects::getOwnerTeam() == team )
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

flagSetup()
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
	spawnpoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_dom_spawn" );
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
		println("^1------------ Map Errors ------------");
		for(i = 0; i < maperrors.size; i++)
			println(maperrors[i]);
		println("^1------------------------------------");
		
		maps\mp\_utility::error("Map errors. See above");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		
		return;
	}
}

// spawning influencer generation callback
// return an array of influencer structs
// For domination, we automatically generate influencers around the flags you own
// With the middle one(s) being slightly stronger.
// Influencers are negative around inner flag(s) you do not own
domPlayerSpawnGenerateInfluencers(
	player_entity, // the player who wants to spawn
	spawn_influencers) // reference to an influencer array struct
{
	// domination: owned outer flag influencers
	dom_owned_outer_flag_influencer_score= level.spawnsystem.dom_owned_outer_flag_influencer_score;
	dom_owned_outer_flag_influencer_score_curve= level.spawnsystem.dom_owned_outer_flag_influencer_score_curve;
	dom_owned_outer_flag_influencer_radius= level.spawnsystem.dom_owned_outer_flag_influencer_radius;
	
	// domination: owned inner flag influencers
	dom_owned_inner_flag_influencer_score= level.spawnsystem.dom_owned_inner_flag_influencer_score;
	dom_owned_inner_flag_influencer_score_curve= level.spawnsystem.dom_owned_inner_flag_influencer_score_curve;
	dom_owned_inner_flag_influencer_radius= level.spawnsystem.dom_owned_inner_flag_influencer_radius;
	
	// domination: enemy flag influencers
	dom_enemy_flag_influencer_score= level.spawnsystem.dom_enemy_flag_influencer_score;
	dom_enemy_flag_influencer_score_curve= level.spawnsystem.dom_enemy_flag_influencer_score_curve;
	dom_enemy_flag_influencer_radius= level.spawnsystem.dom_enemy_flag_influencer_radius;
	
	// domination: un-owned inner flag influencers
	dom_unowned_inner_flag_influencer_score= level.spawnsystem.dom_unowned_inner_flag_influencer_score;
	dom_unowned_inner_flag_influencer_score_curve= level.spawnsystem.dom_unowned_inner_flag_influencer_score_curve;
	dom_unowned_inner_flag_influencer_radius= level.spawnsystem.dom_unowned_inner_flag_influencer_radius;
	
	for (flag_index= 0; flag_index<level.flags.size; flag_index++)
	{
		flag_entity= level.flags[flag_index];
		outer_flag= ((flag_index==0) || (flag_index==(level.flags.size-1)));
		flag_team= flag_entity GetFlagTeam();
		score= undefined;
		score_curve= undefined;
		radius= undefined;
		
		if (maps\mp\gametypes\_spawning::teams_have_enmity(player_entity.team, flag_team))
		{
			score= dom_enemy_flag_influencer_score;
			score_curve= dom_enemy_flag_influencer_score_curve;
			radius= dom_enemy_flag_influencer_radius;
		}
		else
		{
			if (outer_flag)
			{
				if (flag_team==player_entity.team)
				{
					score= dom_owned_outer_flag_influencer_score;
					score_curve= dom_owned_outer_flag_influencer_score_curve;
					radius= dom_owned_outer_flag_influencer_radius;
				}
				else // outer neutral flag
				{
					score= dom_unowned_inner_flag_influencer_score;
					score_curve= dom_unowned_inner_flag_influencer_score_curve;
					radius= dom_unowned_inner_flag_influencer_radius;
				}
			}
			else // inner flag
			{
				if (flag_team==player_entity.team)
				{
					score= dom_owned_inner_flag_influencer_score;
					score_curve= dom_owned_inner_flag_influencer_score_curve;
					radius= dom_owned_inner_flag_influencer_radius;
				}
				else // inner neutral flag
				{
					score= dom_unowned_inner_flag_influencer_score;
					score_curve= dom_unowned_inner_flag_influencer_score_curve;
					radius= dom_unowned_inner_flag_influencer_radius;
				}
			}
		}
		
		if (IsDefined(score) && IsDefined(score_curve) && IsDefined(radius))
		{
			spawn_influencers.a[spawn_influencers.a.size]= create_sphere_influencer(
				"game_mode", // type
				AnglesToForward(flag_entity.angles), // forward
				AnglesToUp(flag_entity.angles), // up
				flag_entity GetOrigin(), // origin
				score, // score
				score_curve, // score_curve
				radius // radius
				);
		}
	}
	
	return spawn_influencers;
}

createFlagSpawnInfluencers()
{
	// domination: owned outer flag influencers
	dom_owned_outer_flag_influencer_score= level.spawnsystem.dom_owned_outer_flag_influencer_score;
	dom_owned_outer_flag_influencer_score_curve= level.spawnsystem.dom_owned_outer_flag_influencer_score_curve;
	dom_owned_outer_flag_influencer_radius= level.spawnsystem.dom_owned_outer_flag_influencer_radius;
	
	// domination: owned inner flag influencers
	dom_owned_inner_flag_influencer_score= level.spawnsystem.dom_owned_inner_flag_influencer_score;
	dom_owned_inner_flag_influencer_score_curve= level.spawnsystem.dom_owned_inner_flag_influencer_score_curve;
	dom_owned_inner_flag_influencer_radius= level.spawnsystem.dom_owned_inner_flag_influencer_radius;
	
	// domination: enemy flag influencers
	dom_enemy_flag_influencer_score= level.spawnsystem.dom_enemy_flag_influencer_score;
	dom_enemy_flag_influencer_score_curve= level.spawnsystem.dom_enemy_flag_influencer_score_curve;
	dom_enemy_flag_influencer_radius= level.spawnsystem.dom_enemy_flag_influencer_radius;
	
	// domination: un-owned inner flag influencers
	dom_unowned_inner_flag_influencer_score= level.spawnsystem.dom_unowned_inner_flag_influencer_score;
	dom_unowned_inner_flag_influencer_score_curve= level.spawnsystem.dom_unowned_inner_flag_influencer_score_curve;
	dom_unowned_inner_flag_influencer_radius= level.spawnsystem.dom_unowned_inner_flag_influencer_radius;
	
	for (flag_index = 0; flag_index < level.flags.size; flag_index++)
	{
		if ( level.domFlags[flag_index] == self )
			break;
	}
	outer_flag= ((flag_index==0) || (flag_index==(level.flags.size-1)));
	
	if (outer_flag)
	{
		score= dom_owned_outer_flag_influencer_score;
		score_curve= dom_owned_outer_flag_influencer_score_curve;
		radius= dom_owned_outer_flag_influencer_radius;
	}
	else // inner flag
	{
		score= dom_owned_inner_flag_influencer_score;
		score_curve= dom_owned_inner_flag_influencer_score_curve;
		radius= dom_owned_inner_flag_influencer_radius;
	}
	
	// this affects both teams
	self.owned_flag_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 dom_owned_outer_flag_influencer_radius,
							 dom_owned_outer_flag_influencer_score,
							 0,
							 maps\mp\gametypes\_spawning::get_score_curve_index(dom_owned_outer_flag_influencer_score_curve) );
	
	self.neutral_flag_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 radius,
							 score,
							 0,
							 maps\mp\gametypes\_spawning::get_score_curve_index(score_curve) );
	
	self.enemy_flag_influencer = addsphereinfluencer( level.spawnsystem.eINFLUENCER_TYPE_GAME_MODE,
							 self.trigger.origin, 
							 dom_enemy_flag_influencer_radius,
							 dom_enemy_flag_influencer_score,
							 0,
							 maps\mp\gametypes\_spawning::get_score_curve_index(dom_enemy_flag_influencer_score_curve) );
	
	
	// default it to neutral
	self update_spawn_influencers("neutral");
}

update_spawn_influencers( team )
{
	assert(isdefined(self.neutral_flag_influencer));
	assert(isdefined(self.owned_flag_influencer));
	assert(isdefined(self.enemy_flag_influencer));
	
	if ( team == "neutral" )
	{
		enableinfluencer(self.neutral_flag_influencer, true);
		enableinfluencer(self.owned_flag_influencer, false);
		enableinfluencer(self.enemy_flag_influencer, false);
	}
	else
	{
		enableinfluencer(self.neutral_flag_influencer, false);
		enableinfluencer(self.owned_flag_influencer, true);
		enableinfluencer(self.enemy_flag_influencer, true);
	}
	
	if ( team == "allies" )
	{
		setinfluencerteammask(self.owned_flag_influencer, level.spawnsystem.iSPAWN_TEAMMASK_ALLIES );
		setinfluencerteammask(self.enemy_flag_influencer, level.spawnsystem.iSPAWN_TEAMMASK_AXIS );
	}
	else
	{
		setinfluencerteammask(self.owned_flag_influencer, level.spawnsystem.iSPAWN_TEAMMASK_AXIS );
		setinfluencerteammask(self.enemy_flag_influencer, level.spawnsystem.iSPAWN_TEAMMASK_ALLIES );
	}
	
}

