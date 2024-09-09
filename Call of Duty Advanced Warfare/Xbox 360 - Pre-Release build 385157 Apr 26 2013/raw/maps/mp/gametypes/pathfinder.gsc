#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
/*
	Pathfinder
	Objective: 	Score points for your team by collecting dog tags.
	Map ends:	When one team reaches the score limit, or time limit is reached
	Respawning:	No wait / Near teammates

	Level requirementss
	------------------
		Spawnpoints:
			classname		mp_tdm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of teammates and enemies
			at the time of spawn. Players generally spawn behind their teammates relative to the direction of enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.
*/


main()
{
	if(getdvar("mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	if ( isUsingMatchRulesData() )
	{
		level.initializeMatchRules = ::initializeMatchRules;
		[[level.initializeMatchRules]]();
		level thread reInitializeMatchRulesOnMigration();			
	}
	else
	{
		registerRoundSwitchDvar( level.gameType, 0, 0, 9 );
		registerTimeLimitDvar( level.gameType, 10 );
		registerScoreLimitDvar( level.gameType, 65 );
		registerRoundLimitDvar( level.gameType, 1 );
		registerWinLimitDvar( level.gameType, 1 );
		registerNumLivesDvar( level.gameType, 0 );
		registerHalfTimeDvar( level.gameType, 0 );
		
		level.matchRules_damageMultiplier = 0;
		level.matchRules_vampirism = 0;	
	}

	level.teamBased = true;
	level.initGametypeAwards = ::initGametypeAwards;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onNormalDeath = ::onNormalDeath;
	level.onPrecacheGameType = ::onPrecacheGameType;
	
	if ( level.matchRules_damageMultiplier || level.matchRules_vampirism )
		level.modifyPlayerDamage = maps\mp\gametypes\_damage::gamemodeModifyPlayerDamage;

	game["dialog"]["gametype"] = "pathfinder";
	
	level.conf_fx["vanish"] = loadFx( "fx/impacts/small_snowhit" );
	
	SetDvarIfUninitialized( "scr_pathfinder_pickup_respawn_time", 60 );
}


initializeMatchRules()
{
	//	set common values
	setCommonRulesFromMatchRulesData();
	
	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	SetDynamicDvar( "scr_pathfinder_roundswitch", 0 );
	registerRoundSwitchDvar( "pathfinder", 0, 0, 9 );
	SetDynamicDvar( "scr_pathfinder_roundlimit", 1 );
	registerRoundLimitDvar( "pathfinder", 1 );		
	SetDynamicDvar( "scr_pathfinder_winlimit", 1 );
	registerWinLimitDvar( "pathfinder", 1 );			
	SetDynamicDvar( "scr_pathfinder_halftime", 0 );
	registerHalfTimeDvar( "pathfinder", 0 );
		
	SetDynamicDvar( "scr_pathfinder_promode", 0 );	
}


onPrecacheGameType()
{
	precachemodel( "prop_dogtags_friend" );
	precachemodel( "prop_dogtags_foe" );
	precacheshader( "waypoint_dogtags" );
}


onStartGameType()
{
	setClientNameMode("auto_change");

	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;

	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}

	setObjectiveText( "allies", &"OBJECTIVES_PATHFINDER" );
	setObjectiveText( "axis", &"OBJECTIVES_PATHFINDER" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_PATHFINDER" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_PATHFINDER" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_PATHFINDER_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_PATHFINDER_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_PATHFINDER_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_PATHFINDER_HINT" );
	
	initSpawns();
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "kill_confirmed", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "kill_denied", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "tags_retrieved", 250 );
	
	level.dogtags = [];
	
	allowed[0] = level.gameType;
	
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	thread spawnPathfinderPickups();
	//thread setPickupLocationIcons();
}

initSpawns()
{
	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_tdm_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::addStartSpawnPoints( "mp_tdm_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );	
}


getSpawnPoint()
{
	spawnteam = self.pers["team"];
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	if ( level.inGracePeriod )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn_" + spawnteam + "_start" );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	return spawnPoint;
}


onNormalDeath( victim, attacker, lifeId )
{
	//score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	//assert( isDefined( score ) );

	//level thread spawnDogTags( victim, attacker );

	//attacker maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( attacker.pers["team"], score );
	
	if ( game["state"] == "postgame" && game["teamScores"][attacker.team] > game["teamScores"][level.otherTeam[attacker.team]] )
		attacker.finalKill = true;
}


/*
///ScriptDocBegin
Name: spawnPathfinderPickups()
Summary: at the beginning of a match, create all of the Pathfinder pickups at the locations of all script_origins with targetname = "pathfinder_pickup".
Module: pathfinder
CallOn: N/A
MandatoryArg:
Example: thread spawnPathfinderPickups();
SPMP: MP
///ScriptDocEnd
*/
spawnPathfinderPickups()
{
	//Common pickups
	level.pathfinder_pickups_common = GetEntArray("pathfinder_pickup_common", "targetname");
	foreach (pickup in level.pathfinder_pickups_common)
	{
		pickup.visuals[0] = spawn("script_model", pickup.origin);
		pickup.visuals[0] SetModel("prop_dogtags_misc");
		pickup.trigger = spawn("trigger_radius", pickup.origin, 0, 32, 32);
		pickup.useobject = maps\mp\gametypes\_gameobjects::createUseObject("any", pickup.trigger, pickup.visuals, (0,0,16));
		pickup.useobject.isHidden = false;
		
		//	we don't need these
		_objective_delete( pickup.useobject.objIDAllies );
		_objective_delete( pickup.useobject.objIDAxis );
		maps\mp\gametypes\_objpoints::deleteObjPoint( pickup.useobject.objPoints["allies"] );
		maps\mp\gametypes\_objpoints::deleteObjPoint( pickup.useobject.objPoints["axis"] );
		
		pickup.useobject maps\mp\gametypes\_gameobjects::setUseTime( 0 );
		pickup.useobject.onUse = ::onUseCommon;
		
		pickup.useobject.objId = maps\mp\gametypes\_gameobjects::getNextObjID();
		objective_add( pickup.useobject.objId, "invisible", (0,0,0) );
		objective_icon( pickup.useobject.objId, "waypoint_dogtags" );
		
		pickup.useobject maps\mp\gametypes\_gameobjects::allowUse( "any" );
		
		pickup.useobject.curOrigin = pickup.origin;
		
		objective_state( pickup.useobject.objId, "invisible" );
		objective_position( pickup.useobject.objId, pickup.origin );
		
		pickup.useobject thread bounce();
		
		pickup.useobject thread timed_reshow();
	}
	
	//Special pickups
	level.pathfinder_pickups_special = GetEntArray("pathfinder_pickup_special", "targetname");
	foreach (pickup in level.pathfinder_pickups_special)
	{
		pickup.visuals[0] = spawn("script_model", pickup.origin);
		pickup.visuals[0] SetModel("prop_dogtags_friend");
		pickup.trigger = spawn("trigger_radius", pickup.origin, 0, 32, 32);
		pickup.useobject = maps\mp\gametypes\_gameobjects::createUseObject("any", pickup.trigger, pickup.visuals, (0,0,16));
		pickup.useobject.isHidden = false;
		
		//	we don't need these
		_objective_delete( pickup.useobject.objIDAllies );
		_objective_delete( pickup.useobject.objIDAxis );
		maps\mp\gametypes\_objpoints::deleteObjPoint( pickup.useobject.objPoints["allies"] );
		maps\mp\gametypes\_objpoints::deleteObjPoint( pickup.useobject.objPoints["axis"] );
		
		pickup.useobject maps\mp\gametypes\_gameobjects::setUseTime( 0 );
		pickup.useobject.onUse = ::onUseSpecial;
		
		pickup.useobject.objId = maps\mp\gametypes\_gameobjects::getNextObjID();
		objective_add( pickup.useobject.objId, "invisible", (0,0,0) );
		objective_icon( pickup.useobject.objId, "waypoint_dogtags" );
		
		pickup.useobject maps\mp\gametypes\_gameobjects::allowUse( "any" );
		
		pickup.useobject.curOrigin = pickup.origin;
		
		objective_state( pickup.useobject.objId, "invisible" );
		objective_position( pickup.useobject.objId, pickup.origin );
		
		pickup.useobject thread bounce();
		
		pickup.useobject thread timed_reshow();
	}
	
	//Rare pickups
	level.pathfinder_pickups_rare = GetEntArray("pathfinder_pickup_rare", "targetname");
	foreach (pickup in level.pathfinder_pickups_rare)
	{
		pickup.visuals[0] = spawn("script_model", pickup.origin);
		pickup.visuals[0] SetModel("prop_dogtags_foe");
		pickup.trigger = spawn("trigger_radius", pickup.origin, 0, 32, 32);
		pickup.useobject = maps\mp\gametypes\_gameobjects::createUseObject("any", pickup.trigger, pickup.visuals, (0,0,16));
		pickup.useobject.isHidden = false;
		
		//	we don't need these
		_objective_delete( pickup.useobject.objIDAllies );
		_objective_delete( pickup.useobject.objIDAxis );
		maps\mp\gametypes\_objpoints::deleteObjPoint( pickup.useobject.objPoints["allies"] );
		maps\mp\gametypes\_objpoints::deleteObjPoint( pickup.useobject.objPoints["axis"] );
		
		pickup.useobject maps\mp\gametypes\_gameobjects::setUseTime( 0 );
		pickup.useobject.onUse = ::onUseRare;
		
		pickup.useobject.objId = maps\mp\gametypes\_gameobjects::getNextObjID();
		objective_add( pickup.useobject.objId, "invisible", (0,0,0) );
		objective_icon( pickup.useobject.objId, "waypoint_dogtags" );
		
		pickup.useobject maps\mp\gametypes\_gameobjects::allowUse( "any" );
		
		pickup.useobject.curOrigin = pickup.origin;
		
		objective_state( pickup.useobject.objId, "invisible" );
		objective_position( pickup.useobject.objId, pickup.origin );
		
		pickup.useobject thread bounce();
		
		pickup.useobject thread timed_reshow();
	}
}


/*
///ScriptDocBegin
Name: setPickupLocationIcons()
Summary: at the beginning of a match, add headicons for Pathfinder pickup locations.
Module: pathfinder
CallOn: N/A
MandatoryArg:
Example: thread setPickupLocationIcons();
SPMP: MP
///ScriptDocEnd
*/
setPickupLocationIcons()
{
	level.locationA = GetEnt("location_a", "targetname");
	level.locationA maps\mp\_entityheadIcons::setHeadIcon( "allies", "waypoint_capture_a", (0, 0, 24), 14, 14, undefined, undefined, undefined, undefined, undefined, false );
	level.locationA maps\mp\_entityheadIcons::setHeadIcon( "axis", "waypoint_capture_a", (0, 0, 24), 14, 14, undefined, undefined, undefined, undefined, undefined, false );
	
	level.locationB = GetEnt("location_b", "targetname");
	level.locationB maps\mp\_entityheadIcons::setHeadIcon( "allies", "waypoint_capture_b", (0, 0, 24), 14, 14, undefined, undefined, undefined, undefined, undefined, false );
	level.locationB maps\mp\_entityheadIcons::setHeadIcon( "axis", "waypoint_capture_b", (0, 0, 24), 14, 14, undefined, undefined, undefined, undefined, undefined, false );
	
	level.locationC = GetEnt("location_c", "targetname");
	level.locationC maps\mp\_entityheadIcons::setHeadIcon( "allies", "waypoint_capture_c", (0, 0, 24), 14, 14, undefined, undefined, undefined, undefined, undefined, false );
	level.locationC maps\mp\_entityheadIcons::setHeadIcon( "axis", "waypoint_capture_c", (0, 0, 24), 14, 14, undefined, undefined, undefined, undefined, undefined, false );
}


onUseCommon(player)
{
	self.trigger playSound( "mp_killconfirm_tags_pickup" );
	
	event = "kill_confirmed";
	splash = &"SPLASHES_PATHFINDER_PICKUP_COMMON";
	
	player incPlayerStat( "killsconfirmed", 1 );
	player incPersStat( "confirmed", 1 );
	player maps\mp\gametypes\_persistence::statSetChild( "round", "confirmed", player.pers["confirmed"] );
	
	//self.trigger playsoundtoplayer( (game[ "voice" ][ player.team ] + "kill_confirmed") , player);
	
	player maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( player.pers["team"], 1 );
	
	player thread onPickup( event, splash, "callout_pf_pickup_common" );
	
	self.visuals[0] Hide();
	self.isHidden = true;
	
	self maps\mp\gametypes\_gameobjects::allowUse( "none" );
	objective_state( self.objId, "invisible" );
}


onUseSpecial(player)
{
	self.trigger playSound( "mp_killconfirm_tags_pickup" );
	
	event = "kill_confirmed";
	splash = &"SPLASHES_PATHFINDER_PICKUP_SPECIAL";
	
	player incPlayerStat( "killsconfirmed", 1 );
	player incPersStat( "confirmed", 1 );
	player maps\mp\gametypes\_persistence::statSetChild( "round", "confirmed", player.pers["confirmed"] );
	
	//self.trigger playsoundtoplayer( (game[ "voice" ][ player.team ] + "kill_confirmed") , player);
	
	player maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( player.pers["team"], 3 );
	
	player thread onPickup( event, splash, "callout_pf_pickup_special" );
	
	self.visuals[0] Hide();
	self.isHidden = true;
	
	self maps\mp\gametypes\_gameobjects::allowUse( "none" );
	objective_state( self.objId, "invisible" );
}


onUseRare(player)
{
	self.trigger playSound( "mp_killconfirm_tags_pickup" );
	
	event = "kill_confirmed";
	splash = &"SPLASHES_PATHFINDER_PICKUP_RARE";
	
	player incPlayerStat( "killsconfirmed", 1 );
	player incPersStat( "confirmed", 1 );
	player maps\mp\gametypes\_persistence::statSetChild( "round", "confirmed", player.pers["confirmed"] );
	
	//self.trigger playsoundtoplayer( (game[ "voice" ][ player.team ] + "kill_confirmed") , player);
	
	player maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( player.pers["team"], 15 );
	
	player thread onPickup( event, splash, "callout_pf_pickup_rare" );
	
	self.visuals[0] Hide();
	self.isHidden = true;
	
	self maps\mp\gametypes\_gameobjects::allowUse( "none" );
	objective_state( self.objId, "invisible" );
}


onPickup( event, splash, text )
{
	level endon( "game_ended" );
	self  endon( "disconnect" );
	
	while ( !isDefined( self.pers ) )
		wait( 0.05 );
	
	self thread maps\mp\gametypes\_rank::xpEventPopup( splash );
	//self thread maps\mp\gametypes\_hud_message::SplashNotify( text, maps\mp\gametypes\_rank::getScoreInfoValue( "kill_confirmed" ) );
	maps\mp\gametypes\_gamescore::givePlayerScore( event, self, undefined, true );
	self thread maps\mp\gametypes\_rank::giveRankXP( event );
}


bounce()
{
	level endon( "game_ended" );
	self endon( "reset" );	
	
	bottomPos = self.curOrigin;
	topPos = self.curOrigin + (0,0,12);
	
	while( true )
	{
		self.visuals[0] moveTo( topPos, 0.5, 0.15, 0.15 );
		self.visuals[0] rotateYaw( 180, 0.5 );
		
		wait( 0.5 );
		
		self.visuals[0] moveTo( bottomPos, 0.5, 0.15, 0.15 );
		self.visuals[0] rotateYaw( 180, 0.5 );
		
		wait( 0.5 );		
	}
}


/*
///ScriptDocBegin
Name: timed_reshow()
Summary: reshow a pickup's useobject after several seconds.
Module: orbital
CallOn: a pickup's useobject
MandatoryArg: N/A
Example: pickup.useobject thread timed_reshow();
SPMP: MP
///ScriptDocEnd
*/
timed_reshow()
{
	level endon("game_ended");
	while (1)
	{
		if (self.isHidden == true)
		{
			self.isHidden = false;
			respawn_time = getDvarInt( "scr_pathfinder_pickup_respawn_time", 60 );
			wait(respawn_time);
			self.visuals[0] Show();
			self maps\mp\gametypes\_gameobjects::allowUse( "any" );
			//objective_state( self.objId, "active" );
		}
		wait(0.05);
	}
}


initGametypeAwards()
{
	//maps\mp\_awards::initStatAward( "killsconfirmed",		0, maps\mp\_awards::highestWins );
}
