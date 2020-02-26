#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
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
			game["axis"] = "opfor";
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

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( "dom", 30, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( "dom", 300, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( "dom", 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( "dom", 0, 0, 10 );

	level.teamBased = true;
	level.doPrematch = true;
	level.overrideTeamScore = true;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;

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
}


onStartGameType()
{	
	thread maps\mp\gametypes\_hardpoints::init();

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

	level.spawnpoints = [];
	level.spawn_all = getentarray("mp_dom_spawn", "classname");
	if(!level.spawn_all.size)
	{
		iprintln("No mp_dom_spawn spawnpoints in level!");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	for(i = 0; i < level.spawn_all.size; i++)
		level.spawnpoints[level.spawnpoints.size] = level.spawn_all[i];
		
	level.spawn_axis_start = getentarray("mp_dom_spawn_axis_start", "classname");
	if(!level.spawn_axis_start.size)
	{
		iprintln("No mp_dom_spawn_axis_start spawnpoints in level!");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	for(i = 0; i < level.spawn_axis_start.size; i++)
		level.spawnpoints[level.spawnpoints.size] = level.spawn_axis_start[i];
	
	level.spawn_allies_start = getentarray("mp_dom_spawn_allies_start", "classname");
	if(!level.spawn_allies_start.size)
	{
		iprintln("No mp_dom_spawn_allies_start spawnpoints in level!");
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}
	for(i = 0; i < level.spawn_allies_start.size; i++)
		level.spawnpoints[level.spawnpoints.size] = level.spawn_allies_start[i];


	for(i = 0; i < level.spawnpoints.size; i++)
		level.spawnpoints[i] placeSpawnpoint();


	allowed[0] = "dom";
//	allowed[1] = "hardpoint";
	maps\mp\gametypes\_gameobjects::main(allowed);

	level.suppressHardpoint3DIcons = true;
	
	thread domFlags();
	thread updateDomScores();
	
	thread updateGametypeDvars();
	
//	if ( level.scorelimit > 1 )
//		thread maps\mp\gametypes\_hud_teamscore::setEnemyScoreFlashFrac( ((level.scorelimit - 1) / level.scorelimit) - 0.01 ); 
}


onSpawnPlayer()
{
	/*ownsflag = false;
	for ( i = 0; i < level.flags.size; i++ )
	{
		if ( level.flags[i] getFlagTeam() == self.pers["team"] )
		{
			ownsflag = true;
			break;
		}
	}*/
	
	if ( level.useStartSpawns )
	{
		if (self.pers["team"] == "axis")
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_axis_start);
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random(level.spawn_allies_start);
	}
	else
	{
		/*hasfriendlies = false;
		
		if ( self.pers["team"] == "axis" && level.axisplayers.size > 0 )
			hasfriendlies = true;
		else {
			assert(self.pers["team"] == "allies");
			if ( level.alliesplayers.size > 0 )
				hasfriendlies = true;
		}
		
		if ( hasfriendlies )
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, getOwnedAndBoundingFlagSpawns( self.pers["team"] ), true );
		else
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all, getOwnedFlagSpawns( self.pers["team"] ), true );
		*/
		
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( level.spawn_all );
	}

	assert( isDefined(spawnpoint) );
	
	self spawn(spawnpoint.origin, spawnpoint.angles);
}


updateGametypeDvars()
{
}



domFlags()
{
	level.progressBars = [];
	level.teamBars = [];
	level.teamBarTexts = [];
	
	game["flagmodels"] = [];
	game["flagmodels"]["neutral"] = "prop_flag_neutral";
	game["flagmodels"]["allies"] = "prop_flag_american";
	game["flagmodels"]["axis"] = "prop_flag_opfor";
	
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
	precacheString( &"MP_THE_ENEMY" );
	precacheString( &"MP_YOUR_TEAM" );
	

	primaryFlags = getEntArray( "flag_primary", "targetname" );
	secondaryFlags = getEntArray( "flag_secondary", "targetname" );
	
	if ( (primaryFlags.size + secondaryFlags.size) == 0 )
	{
		printLn( "^1No domination flags found in level!" );
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

		domFlag = maps\mp\gametypes\_gameobjects::createUseObject( "neutral", trigger, visuals, (0,0,72) );
		domFlag maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
		domFlag maps\mp\gametypes\_gameobjects::setUseTime( 10.0 );
		domFlag maps\mp\gametypes\_gameobjects::setUseText( &"MP_CAPTURING_FLAG" );
		label = domFlag maps\mp\gametypes\_gameobjects::getLabel();
		domFlag maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" + label );
		domFlag maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" + label );
		domFlag maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_captureneutral" + label );
		domFlag maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_captureneutral" + label );
		domFlag maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		domFlag.onUse = ::onUse;
		domFlag.onBeginUse = ::onBeginUse;
		domFlag.onEndUse = ::onEndUse;

		// legacy spawn code support
		level.flags[index].useObj = domFlag;
		level.flags[index].adjflags = [];
		level.flags[index].nearbyspawns = [];

		level.domFlags[level.domFlags.size] = domFlag;
	}
	
	//flagSetup(); // disabled for now because it's broken and we want to try something else for a while
	
//	setDvar( level.scoreLimitDvar, level.domFlags.size );

	/#
	thread domDebug();
	#/
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
			}
			wait .05;
		}
	}
}
#/

onBeginUse( player )
{
	ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();

	if ( ownerTeam == "neutral" )
	{
		self.objPoints[player.pers["team"]] thread maps\mp\gametypes\_objpoints::startFlashing();
		return;
	}
		
	if ( ownerTeam == "allies" )
		otherTeam = "axis";
	else
		otherTeam = "allies";
	
	/*if ( getTeamFlagCount( ownerTeam ) == 1 && getTeamFlagCount( otherTeam ) == (level.domFlags.size - 1) )
	{
		level.teamBars[ownerTeam] = createTeamProgressBar( ownerTeam );
		level.teamBarTexts[ownerTeam] = createTeamProgressBarText( ownerTeam );
		level.teamBarTexts[ownerTeam] setText( &"MP_LOSING_LAST_FLAG" );
		level.teamBars[ownerTeam] thread updateBarUse( self );
	}*/

	self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::startFlashing();
	self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::startFlashing();
}


/*updateBarUse( object )
{
	self endon ( "death" );
	
	self.lastUseRate = -1;
	for( ;; )
	{
		if ( self.lastUseRate != object.useRate )
		{
			self updateBar( 1 - (object.curProgress / object.useTime), -1 * (1000 / object.useTime) * object.useRate );
//			self updateBar( object.curProgress / object.useTime , (1000 / object.useTime) * object.useRate );
			self.lastUseRate = object.useRate;
		}
		wait ( 0.05 );
	}
}*/


onEndUse( player, success )
{
	ownerTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();

	if ( ownerTeam == "neutral" )
	{
		self.objPoints[player.pers["team"]] thread maps\mp\gametypes\_objpoints::stopFlashing();
		return;
	}
		
	if ( isDefined( level.teamBars[ownerTeam] ) )
		level.teamBars[ownerTeam] destroyElem();

	if ( isDefined( level.teamBarTexts[ownerTeam] ) )
		level.teamBarTexts[ownerTeam] destroyElem();

	self.objPoints["allies"] thread maps\mp\gametypes\_objpoints::stopFlashing();
	self.objPoints["axis"] thread maps\mp\gametypes\_objpoints::stopFlashing();
}


onUse( player )
{
	team = player.pers["team"];
	oldTeam = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
	label = self maps\mp\gametypes\_gameobjects::getLabel();
	
	self maps\mp\gametypes\_gameobjects::setOwnerTeam( team );
	self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_capture" + label );
	self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_capture" + label );
	self.visuals[0] setModel( game["flagmodels"][team] );

	level.useStartSpawns = false;

	if ( oldTeam != "neutral" )
	{
		thread printOnTeamArg( &"MP_FRIENDLY_FLAG_CAPTURED_BY", oldTeam, player.name );
		thread playSoundOnPlayers( "mp_war_objective_lost", oldTeam );
//		[[level._setTeamScore]]( oldTeam, getTeamFlagCount( oldTeam ) );
	}

	if ( team != "neutral" )
	{
		if ( oldTeam == "neutral" )
		{
			thread printOnTeamArg( &"MP_NEUTRAL_FLAG_CAPTURED_BY", oldTeam, player.name );
			thread printOnTeamArg( &"MP_NEUTRAL_FLAG_CAPTURED_BY", team, player.name );
		}
		else
		{
			thread printOnTeamArg( &"MP_ENEMY_FLAG_CAPTURED_BY", team, player.name );
		}

		thread playSoundOnPlayers( "mp_war_objective_taken", team );
//		[[level._setTeamScore]]( team, getTeamFlagCount( team ) );

		if ( isDefined( level.teamBars[team] ) )
			level.teamBars[team] destroyElem();
	
		if ( isDefined( level.teamBarTexts[team] ) )
			level.teamBarTexts[team] destroyElem();
	}
}


updateDomScores()
{
	while ( !level.gameEnded )
	{
		numFlags = getTeamFlagCount( "allies" );
		if ( numFlags )
			[[level._setTeamScore]]( "allies", [[level._getTeamScore]]( "allies" ) + numFlags );
			
		numFlags = getTeamFlagCount( "axis" );
		if ( numFlags )
			[[level._setTeamScore]]( "axis", [[level._getTeamScore]]( "axis" ) + numFlags );
			
		wait ( 5.0 );
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
	spawnpoints = getentarray("mp_dom_spawn", "classname");
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

