#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include common_scripts\utility;
/*
	Confirmed Kill
	Objective: 	Score points for your team by eliminating players on the opposing team.
				Score bonus points for picking up dogtags from downed enemies.
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
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	registerTimeLimit( 0, 1440 );
	registerScoreLimit( 0, 50000 );
	registerRoundLimit( 0, 10 );
	registerRoundSwitch( 0, 9 );
	registerRoundWinLimit( 0, 10 );
	registerNumLives( 0, 10 );

	maps\mp\gametypes\_weapons::registerGrenadeLauncherDudDvar( level.gameType, 10, 0, 1440 );
	maps\mp\gametypes\_weapons::registerThrownGrenadeDudDvar( level.gameType, 0, 0, 1440 );
	maps\mp\gametypes\_weapons::registerKillstreakDelay( level.gameType, 0, 0, 1440 );

	maps\mp\gametypes\_globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );

	level.scoreRoundBased = true;
	level.teamBased = true;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.onRoundEndGame = ::onRoundEndGame;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onRoundSwitch = ::onRoundSwitch;
	level.overrideTeamScore = true;

//	if ( level.matchRules_damageMultiplier || level.matchRules_vampirism )
//		level.modifyPlayerDamage = maps\mp\gametypes\_damage::gamemodeModifyPlayerDamage;

	game["dialog"]["gametype"] = "kill_confirmed";
	game["dialog"]["gametype_hardcore"] = "kill_confirmed";
	game["dialog"]["offense_obj"] = "generic_boost";
	game["dialog"]["defense_obj"] = "generic_boost";
	
	level.conf_fx["vanish"] = loadFx( "maps/mp_maps/fx_mp_kill_confirmed_vanish" );
	
	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "deaths", "kdratio", "assists" ); 
}


onPrecacheGameType()
{
	precachemodel( "p6_dogtags" );
	precachemodel( "p6_dogtags_friend" );
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

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	

	foreach( team in level.teams )
	{
		setObjectiveText( team, &"OBJECTIVES_CONF" );
		setObjectiveHintText( team, &"OBJECTIVES_CONF_HINT" );
		
		if ( level.splitscreen )
		{
			setObjectiveScoreText( team, &"OBJECTIVES_CONF" );
		}
		else
		{
			setObjectiveScoreText( team, &"OBJECTIVES_CONF_SCORE" );
		}
		
		maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_" + team + "_start" );
		maps\mp\gametypes\_spawnlogic::addSpawnPoints( team, "mp_tdm_spawn" );
	}
			
	maps\mp\gametypes\_spawning::updateAllSpawnPoints();
	
	level.spawn_start = [];
	
	foreach( team in level.teams )
	{
		level.spawn_start[ team ] =  maps\mp\gametypes\_spawnlogic::getSpawnpointArray("mp_tdm_spawn_" + team + "_start");
	}

	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );	
	
	level.dogtags = [];
	
	allowed[0] = level.gameType;
	
	if ( !isOneRound() )
	{
		level.displayRoundEndText = true;
		if( isScoreRoundBased() )
		{
			maps\mp\gametypes\_globallogic_score::resetTeamScores();
		}
	}
	
	maps\mp\gametypes\_gameobjects::main(allowed);	
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration )
{
	if ( !isPlayer( attacker ) || attacker.team == self.team )
		return;
	
	//score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	//assert( isDefined( score ) );

	level thread spawnDogTags( self, attacker );

	//attacker maps\mp\gametypes\_globallogic_score::giveTeamScoreForObjective( attacker.team, score );
}


spawnDogTags( victim, attacker )
{
	if ( isDefined( level.dogtags[victim.entnum] ) )
	{
		PlayFx( level.conf_fx["vanish"], level.dogtags[victim.entnum].curOrigin );
		level.dogtags[victim.entnum] notify( "reset" );
	}
	else
	{
		visuals[0] = spawn( "script_model", (0,0,0) );
		visuals[0] setModel( "p6_dogtags" );
		visuals[1] = spawn( "script_model", (0,0,0) );
		visuals[1] setModel( "p6_dogtags_friend" );
		
		trigger = spawn( "trigger_radius", (0,0,0), 0, 32, 32 );
		
		level.dogtags[victim.entnum] = maps\mp\gametypes\_gameobjects::createUseObject( "any", trigger, visuals, (0,0,16) );
		
		//	we don't need these
		foreach( team in level.teams )
		{
			objective_delete( level.dogtags[victim.entnum].objID[team] );
			maps\mp\gametypes\_gameobjects::releaseObjID( level.dogtags[victim.entnum].objID[team] );
			maps\mp\gametypes\_objpoints::deleteObjPoint( level.dogtags[victim.entnum].objPoints[team] );
		}
		
		level.dogtags[victim.entnum] maps\mp\gametypes\_gameobjects::setUseTime( 0 );
		level.dogtags[victim.entnum].onUse = ::onUse;
		level.dogtags[victim.entnum].victim = victim;
		level.dogtags[victim.entnum].victimTeam = victim.team;
		
		level.dogtags[victim.entnum].objId = maps\mp\gametypes\_gameobjects::getNextObjID();	
		objective_add( level.dogtags[victim.entnum].objId, "invisible", (0,0,0) );
		objective_icon( level.dogtags[victim.entnum].objId, "waypoint_dogtags" );	
		
		level thread clearOnVictimDisconnect( victim );
		victim thread tagTeamUpdater( level.dogtags[victim.entnum] );
	}	
	
	pos = victim.origin + (0,0,14);
	level.dogtags[victim.entnum].curOrigin = pos;
	level.dogtags[victim.entnum].trigger.origin = pos;
	level.dogtags[victim.entnum].visuals[0].origin = pos;
	level.dogtags[victim.entnum].visuals[1].origin = pos;
	
	level.dogtags[victim.entnum] maps\mp\gametypes\_gameobjects::allowUse( "any" );	
			
	level.dogtags[victim.entnum].visuals[0] thread showToTeam( level.dogtags[victim.entnum], attacker.team );
	level.dogtags[victim.entnum].visuals[1] thread showToEnemyTeams( level.dogtags[victim.entnum], attacker.team );
	
	level.dogtags[victim.entnum].attacker = attacker;
	level.dogtags[victim.entnum].attackerTeam = attacker.team;
	//level.dogtags[victim.entnum] thread timeOut( victim );
	
	objective_position( level.dogtags[victim.entnum].objId, pos );
	objective_state( level.dogtags[victim.entnum].objId, "active" );
	Objective_SetInvisibleToAll( level.dogtags[victim.entnum].objId );
	Objective_SetVisibleToPlayer( level.dogtags[victim.entnum].objId, attacker );
	
	PlaySoundAtPosition( "mpl_killconfirm_tags_drop", pos );
	
	level.dogtags[victim.entnum] thread bounce();
	level notify( "dogtag_spawned" );
}


showToTeam( gameObject, team )
{
	gameObject endon( "death" );
	gameObject endon( "reset" );

	self hide();

	foreach ( player in level.players )
	{
		if( player.team == team )
			self ShowToPlayer( player );
	}

	for ( ;; )
	{
		level waittill ( "joined_team" );
		
		self hide();
		foreach ( player in level.players )
		{
			if ( player.team == team )
				self ShowToPlayer( player );
				
			if ( gameObject.victimTeam == player.team && player == gameObject.attacker )
				objective_state( gameObject.objId, "invisible" );
		}
	}	
}

showToEnemyTeams( gameObject, friend_team )
{
	gameObject endon( "death" );
	gameObject endon( "reset" );

	self hide();

	foreach ( player in level.players )
	{
		if( player.team != friend_team )
			self ShowToPlayer( player );
	}

	for ( ;; )
	{
		level waittill ( "joined_team" );
		
		self hide();
		foreach ( player in level.players )
		{
			if ( player.team != friend_team )
				self ShowToPlayer( player );
				
			if ( gameObject.victimTeam == player.team && player == gameObject.attacker )
				objective_state( gameObject.objId, "invisible" );
		}
	}	
}

onUse( player )
{	
	//	friendly pickup
	if ( player.team != self.attackerTeam )
	{
		self.trigger playSound( "mpl_killconfirm_tags_pickup" );
//		iprintlnbold("DENINED");
		player AddPlayerStat( "KILLSDENIED", 1 );
//		player maps\mp\gametypes\_persistence::statSetChild( "round", "denied", player.pers["denied"] );
			
		if ( self.victim == player )
		{
			event = "retrieve_own_tags";
			splash = &"SPLASHES_TAGS_RETRIEVED";
		}
		else
		{
			event = "kill_denied";
			splash = &"SPLASHES_KILL_DENIED";	
		}
		
		//	tell the attacker their kill was denied
//		if ( isDefined( self.attacker ) )
//			self.attacker thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_DENIED_KILL", (1,0.5,0.5) );
	}
	//	enemy pickup
	else
	{
		self.trigger playSound( "mpl_killconfirm_tags_pickup" );
//		iprintlnbold("CONFIRMED");
		event = "kill_confirmed";
		splash = &"SPLASHES_KILL_CONFIRMED";
		
		player AddPlayerStat( "KILLSCONFIRMED", 1 );
//		player maps\mp\gametypes\_persistence::statSetChild( "round", "confirmed", player.pers["confirmed"] );
		
		//	if not us, tell the attacker their kill was confirmed
		if ( self.attacker != player )
			self.attacker thread onPickup( event, splash );
		
		self.trigger playsoundtoplayer( ( "vox_" + game[ "voice" ][ player.team ] + "kill_confirm_00" ) , player);
		
		player maps\mp\gametypes\_globallogic_score::giveTeamScoreForObjective( player.team, 1 );			
	}	
		
	player thread onPickup( event, splash );
	
	//	do all this at the end now so the location doesn't change before playing the sound on the entity
	self resetTags();		
}


onPickup( event, splash )
{
	level endon( "game_ended" );
	self  endon( "disconnect" );
	
	while ( !isDefined( self.pers ) )
		wait( 0.05 );
	
	maps\mp\_scoreevents::processScoreEvent( event, self, undefined, undefined, true );
}


resetTags()
{
	self.attacker = undefined;
	self notify( "reset" );
	self.visuals[0] hide();
	self.visuals[1] hide();
	self.curOrigin = (0,0,1000);
	self.trigger.origin = (0,0,1000);
	self.visuals[0].origin = (0,0,1000);
	self.visuals[1].origin = (0,0,1000);
	self maps\mp\gametypes\_gameobjects::allowUse( "none" );	
	objective_state( self.objId, "invisible" );	
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
		self.visuals[1] moveTo( topPos, 0.5, 0.15, 0.15 );
		self.visuals[1] rotateYaw( 180, 0.5 );
		
		wait( 0.5 );
		
		self.visuals[0] moveTo( bottomPos, 0.5, 0.15, 0.15 );
		self.visuals[0] rotateYaw( 180, 0.5 );	
		self.visuals[1] moveTo( bottomPos, 0.5, 0.15, 0.15 );
		self.visuals[1] rotateYaw( 180, 0.5 );
		
		wait( 0.5 );		
	}
}


timeOut( victim )
{
	level  endon( "game_ended" );
	victim endon( "disconnect" );
	self notify( "timeout" );
	self endon( "timeout" );
	
	level maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( 30.0 );
	//wait( 30 );
	
	self.visuals[0] hide();
	self.visuals[1] hide();
	self.curOrigin = (0,0,1000);
	self.trigger.origin = (0,0,1000);
	self.visuals[0].origin = (0,0,1000);
	self.visuals[1].origin = (0,0,1000);
	self maps\mp\gametypes\_gameobjects::allowUse( "none" );			
}

tagTeamUpdater( tags )
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	
	while( true )
	{
		self waittill( "joined_team" );
		
		tags.victimTeam = self.team;
		tags resetTags();
	}
}


clearOnVictimDisconnect( victim )
{
	level endon( "game_ended" );	
	
	guid = victim.entnum;
	victim waittill( "disconnect" );
	
	if ( isDefined( level.dogtags[guid] ) )
	{
		//	block further use
		level.dogtags[guid] maps\mp\gametypes\_gameobjects::allowUse( "none" );
		
		//	tell the attacker their kill was denied
//		if ( isDefined( level.dogtags[guid].attacker ) )
//			level.dogtags[guid].attacker thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_DENIED_KILL", (1,0.5,0.5) );		
		
		//	play vanish effect, reset, and wait for reset to process
		PlayFx( level.conf_fx["vanish"], level.dogtags[guid].curOrigin );
		level.dogtags[guid] notify( "reset" );		
		wait( 0.05 );
		
		//	sanity check before removal
		if ( isDefined( level.dogtags[guid] ) )
		{
			//	delete objective and visuals
			objective_delete( level.dogtags[guid].objId );
			level.dogtags[guid].trigger delete();
			for ( i=0; i<level.dogtags[guid].visuals.size; i++ )
				level.dogtags[guid].visuals[i] delete();
			level.dogtags[guid] notify ( "deleted" );
			
			//	remove from list
			level.dogtags[guid] = undefined;		
		}	
	}	
}

initGametypeAwards()
{
	//maps\mp\_awards::initStatAward( "killsconfirmed",		0, maps\mp\_awards::highestWins );
}

onSpawnPlayerUnified()
{
	self.usingObj = undefined;
	
	if ( level.useStartSpawns && !level.inGracePeriod )
	{
		level.useStartSpawns = false;
	}
	
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}


onSpawnPlayer(predictedSpawn)
{
	pixbeginevent("TDM:onSpawnPlayer");
	self.usingObj = undefined;

	spawnteam = self.pers["team"];
	// TODO MTEAM - switched sides
	if ( game["switchedsides"] )
		spawnteam = getOtherTeam( spawnteam );

	
	if ( level.inGracePeriod )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn_" + spawnteam + "_start" );
		
		if ( !spawnPoints.size )
			spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_sab_spawn_" + spawnteam + "_start" );
			
		if ( !spawnPoints.size )
		{
			spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
		}
		else
		{
			spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
		}		
	}
	else
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( spawnteam );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnPoint.origin, spawnPoint.angles );
	}
	else
	{
		self spawn( spawnPoint.origin, spawnPoint.angles, "tdm" );
	}
	pixendevent();
}

onRoundSwitch()
{
	game["switchedsides"] = !game["switchedsides"];
}

onRoundEndGame( roundWinner )
{	
	return maps\mp\gametypes\_globallogic::determineTeamWinnerByGameStat( "roundswon" );
}
