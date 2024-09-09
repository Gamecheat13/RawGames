#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Streak
	Objective: 	Score points for your team by eliminating players collecting there drops and cashing them in
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
			
			
	TODO:
	//tags go into a player count, when player dies count gets dropped unless suicide

	
	
	
*/

/*QUAKED mp_tdm_spawn (0.0 0.0 1.0) (-16 -16 0) (16 16 72)
Players spawn away from enemies and near their team at one of these positions.*/

/*QUAKED mp_tdm_spawn_axis_start (0.5 0.0 1.0) (-16 -16 0) (16 16 72)
Axis players spawn away from enemies and near their team at one of these positions at the start of a round.*/

/*QUAKED mp_tdm_spawn_allies_start (0.0 0.5 1.0) (-16 -16 0) (16 16 72)
Allied players spawn away from enemies and near their team at one of these positions at the start of a round.*/

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
		registerScoreLimitDvar( level.gameType, 7500 );
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
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onNormalDeath = ::onNormalDeath;
	level.onPlayerKilled = ::onPlayerKilled;//for non-normal deaths
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.cb_usedKillstreak = ::cb_usedKillstreak;
	
	if ( level.matchRules_damageMultiplier || level.matchRules_vampirism )
		level.modifyPlayerDamage = maps\mp\gametypes\_damage::gamemodeModifyPlayerDamage;

	game["dialog"]["gametype"] = "tm_death";
	
	if ( getDvarInt( "g_hardcore" ) )
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "camera_thirdPerson" ) )
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "scr_diehard" ) )
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];
	else if (getDvarInt( "scr_" + level.gameType + "_promode" ) )
		game["dialog"]["gametype"] = game["dialog"]["gametype"] + "_pro";
	
	game["strings"]["overtime_hint"] = &"MP_FIRST_BLOOD";
}

onPrecacheGameType()
{
	precachemodel( "prop_dogtags_friend" );
	precachemodel( "prop_dogtags_foe" );
	precacheshader( "waypoint_dogtags" );
	precacheShader( "skull_black_plain" );
}


initializeMatchRules()
{
	//	set common values
	setCommonRulesFromMatchRulesData();
	
	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	SetDynamicDvar( "scr_streak_roundswitch", 0 );
	registerRoundSwitchDvar( "streak", 0, 0, 9 );
	SetDynamicDvar( "scr_streak_roundlimit", 1 );
	registerRoundLimitDvar( "streak", 1 );		
	SetDynamicDvar( "scr_streak_winlimit", 1 );
	registerWinLimitDvar( "streak", 1 );			
	SetDynamicDvar( "scr_streak_halftime", 0 );
	registerHalfTimeDvar( "streak", 0 );
		
	SetDynamicDvar( "scr_streak_promode", 0 );	
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

	setObjectiveText( "allies", &"OBJECTIVES_WAR" );
	setObjectiveText( "axis", &"OBJECTIVES_WAR" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_WAR" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_WAR" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_WAR_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_WAR_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_WAR_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_WAR_HINT" );
	
	initSpawns();
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "kill_banked", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "kill_cashed", 100 );
	//maps\mp\gametypes\_rank::registerScoreInfo( "kill_denied", 50 );
	//maps\mp\gametypes\_rank::registerScoreInfo( "tags_retrieved", 250 );
	
	maps\mp\killstreaks\_killstreaks::registerAdrenalineInfo( "kill_pickup", 1);
	maps\mp\killstreaks\_killstreaks::registerAdrenalineInfo( "kill", 0);
	
	level.dogtags = [];
	
	allowed[0] = level.gameType;
	allowed[1] = "airdrop_pallet";
	
	maps\mp\gametypes\_gameobjects::main(allowed);	
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

onSpawnPlayer()
{
	//reset players kill bank back to zero after death
	self.killbank = 0;
	
	self setupHUD();
			
}


onNormalDeath( victim, attacker, lifeId )
{
	
	//Make sure they are always spawning one for themseleves
	for( i = 0; i < victim.killbank + 1; i++ )
	{
		if( i == 0 )
			level thread spawnKill( victim, true );
		else
			level thread spawnKill( victim );
	}
	
	score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	assert( isDefined( score ) );

	attacker maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( attacker.pers["team"], score );
	
	
	if ( game["state"] == "postgame" && game["teamScores"][attacker.team] > game["teamScores"][level.otherTeam[attacker.team]] )
		attacker.finalKill = true;
}

onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, killId )
{
	//remove the players killstreaks, going to not work very well for support and won't work for specialist
	self maps\mp\killstreaks\_killstreaks::clearKillstreaks();

}

onTimeLimit()
{
	level.finalKillCam_winner = "none";
	if ( game["status"] == "overtime" )
	{
		winner = "forfeit";
	}
	else if ( game["teamScores"]["allies"] == game["teamScores"]["axis"] )
	{
		winner = "overtime";
	}
	else if ( game["teamScores"]["axis"] > game["teamScores"]["allies"] )
	{
		level.finalKillCam_winner = "axis";
		winner = "axis";
	}
	else
	{
		level.finalKillCam_winner = "allies";
		winner = "allies";
	}
	
	thread maps\mp\gametypes\_gamelogic::endGame( winner, game["strings"]["time_limit_reached"] );
}


setupHUD()
{
	if( IsDefined( self.killbank_display ) )
	{
		self.killbank_display.count SetText( 0 );
		return;
	}
	
	self.killbank_display = SpawnStruct();
	if ( level.splitscreen )
	{
		self.killbank_display.icon = createIcon( "skull_black_plain", 33, 33 );
		self.killbank_display.icon setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", -50, -78 );
		self.killbank_display.icon.alpha = 0.75;
		
		self.killbank_display.count = createFontString( "default", 1 );
		self.killbank_display.count setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", -25, -78 );
		self.killbank_display.count SetText( 0 );
	}
	else
	{
		self.killbank_display.icon = createIcon( "skull_black_plain", 50, 50 );
		self.killbank_display.icon setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", -50, -65 );
		self.killbank_display.icon.alpha = 0.75;
		
		self.killbank_display.count = createFontString( "default", 1.5 );
		self.killbank_display.count setPoint( "BOTTOM RIGHT", "BOTTOM RIGHT", -71, -96 );
		self.killbank_display.count SetText( 0 );
	}	
}


spawnKill( victim, no_offset )
{
	visuals[0] = spawn( "script_model", (0,0,0) );
	visuals[0] setModel( "prop_dogtags_foe" );

	trigger = spawn( "trigger_radius", (0,0,0), 0, 32, 32 );
	
	killid = level.dogtags.size;
	
	level.dogtags[ killid ] = maps\mp\gametypes\_gameobjects::createUseObject( "any", trigger, visuals, (0,0,16) );
	
	//	we don't need these
	_objective_delete( level.dogtags[killid].objIDAllies );
	_objective_delete( level.dogtags[killid].objIDAxis );		
	maps\mp\gametypes\_objpoints::deleteObjPoint( level.dogtags[killid].objPoints["allies"] );
	maps\mp\gametypes\_objpoints::deleteObjPoint( level.dogtags[killid].objPoints["axis"] );		
	
	level.dogtags[killid] maps\mp\gametypes\_gameobjects::setUseTime( 0 );
	level.dogtags[killid].onUse = ::onUse;
	
	level.dogtags[killid].objId = maps\mp\gametypes\_gameobjects::getNextObjID();	
	objective_add( level.dogtags[killid].objId, "invisible", (0,0,0) );
	objective_icon( level.dogtags[killid].objId, "waypoint_dogtags" );	

	if( IsDefined( no_offset ) )
		pos = victim.origin + ( 0, 0, 14 );
	else
		pos = victim.origin + ( RandomIntRange( 0, 65 ), RandomIntRange( 0, 65 ), 14 );
	level.dogtags[killid].curOrigin = pos;
	level.dogtags[killid].trigger.origin = pos;
	level.dogtags[killid].visuals[0].origin = pos;
	
	level.dogtags[killid] maps\mp\gametypes\_gameobjects::allowUse( "any" );	
			
	objective_position( level.dogtags[killid].objId, pos );
	objective_state( level.dogtags[killid].objId, "active" );
 
	playSoundAtPos( pos, "mp_killconfirm_tags_drop" );
	
	level.dogtags[killid] thread bounce();
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


onUse( player )
{		
	event = "kill_banked";
	splash = "KILL BANKED";
	
	self.trigger playSound( "mp_killconfirm_tags_pickup" );
	
	player.killbank ++;
	player.killbank_display.count SetText( player.killbank );
	
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
	
	self thread maps\mp\killstreaks\_killstreaks::giveAdrenaline( "kill_pickup" );
	self thread maps\mp\gametypes\_rank::xpEventPopup( splash );
	maps\mp\gametypes\_gamescore::givePlayerScore( event, self, undefined, true );
	self thread maps\mp\gametypes\_rank::giveRankXP( event );

}


cb_usedKillstreak( streakName, isGimme )
{
	if( isdefined( isGimme ) && isGimme == 1 )
		return;
	
	kill_streak_cost = maps\mp\killstreaks\_killstreaks::getStreakCost( streakName );
	
	self.killbank = self.killbank - kill_streak_cost;						//updating players kill bank so they don't drop the kills they cashed in
	
	self.killbank_display.count SetText( self.killbank ); 					//update the killbank display
	
	new_adrenaline = self.killbank;											//using killbank rather than adrenaline because adrenaline resets after reaching max streak cost.
	
	self maps\mp\killstreaks\_killstreaks::clearKillstreaks(); 				//clear all of the players killstreaks
	self maps\mp\killstreaks\_killstreaks::setAdrenaline( new_adrenaline ); //set new adrenaline
	
	foreach ( streak in self.killstreaks )
	{
		temp = streak;
		streakVal = maps\mp\killstreaks\_killstreaks::getStreakCost( streak );
		
		if ( streakVal > self.adrenaline )
			break;
		
		if ( self.previousAdrenaline < streakVal && self.adrenaline >= streakVal )
		{
			//self maps\mp\killstreaks\_killstreaks::checkStreakReward();  			//force refresh of what killstreaks the player should have.
			self maps\mp\killstreaks\_killstreaks::earnKillstreak( streak, streakVal ); 
			self.previousAdrenaline = streakVal;
		}
	}
	
	/*
	self maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( self.pers["team"], kill_streak_cost );	
	
	event = "kill_cashed";
	splash = "KILLS CASHED";
	
	self thread maps\mp\gametypes\_rank::xpEventPopup( splash );
	
	for( i = 1; i < kill_streak_cost; i++ )
	{
		maps\mp\gametypes\_gamescore::givePlayerScore( event, self, undefined, true );
		self thread maps\mp\gametypes\_rank::giveRankXP( event );
	}
	
	*/
}

resetTags()
{
	self notify( "reset" );
	
	self.trigger delete();
	self.visuals[0] delete();
	Objective_Delete( self.objID );
	self notify ( "deleted" );
	                 
	  /*               
	self.attacker = undefined;
	self notify( "reset" );
	self.visuals[0] hide();
	//self.visuals[1] hide();
	self.curOrigin = (0,0,1000);
	self.trigger.origin = (0,0,1000);
	self.visuals[0].origin = (0,0,1000);
	//self.visuals[1].origin = (0,0,1000);
	self maps\mp\gametypes\_gameobjects::allowUse( "none" );	
	objective_state( self.objId, "invisible" );	
	*/
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
		//self.visuals[1] moveTo( topPos, 0.5, 0.15, 0.15 );
		//self.visuals[1] rotateYaw( 180, 0.5 );
		
		wait( 0.5 );
		
		self.visuals[0] moveTo( bottomPos, 0.5, 0.15, 0.15 );
		self.visuals[0] rotateYaw( 180, 0.5 );	
		//self.visuals[1] moveTo( bottomPos, 0.5, 0.15, 0.15 );
		//self.visuals[1] rotateYaw( 180, 0.5 );
		
		wait( 0.5 );		
	}
}

tagTeamUpdater( tags )
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	
	while( true )
	{
		self waittill( "joined_team" );
		
		tags.victimTeam = self.pers["team"];
		tags resetTags();
	}
}


clearOnVictimDisconnect( victim )
{
	level endon( "game_ended" );	
	
	guid = victim.guid;
	victim waittill( "disconnect" );
	
	if ( isDefined( level.dogtags[guid] ) )
	{
		//	block further use
		level.dogtags[guid] maps\mp\gametypes\_gameobjects::allowUse( "none" );
		
		//	tell the attacker their kill was denied
		if ( isDefined( level.dogtags[guid].attacker ) )
			level.dogtags[guid].attacker thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_DENIED_KILL", (1,0.5,0.5) );		
		
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
