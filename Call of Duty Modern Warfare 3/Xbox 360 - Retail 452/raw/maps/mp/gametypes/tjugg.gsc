#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

main()
{
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
		registerTimeLimitDvar( level.gameType, 10 );
		registerRoundLimitDvar( level.gameType, 1 );
		registerScoreLimitDvar( level.gameType, 7500 );
		registerWinLimitDvar( level.gameType, 1 );
		registerNumLivesDvar( level.gameType, 0 );
		registerHalfTimeDvar( level.gameType, 0 );
		
		level.matchRules_juggSwitchTime = 90; 		
		level.matchRules_damageMultiplier = 0;
		level.matchRules_vampirism = 0;
	}
	
	setSpecialLoadouts();
	
	level.teamBased = true;
	level.doPrematch = true;
	level.onPrecacheGametype = ::onPrecacheGametype;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onPlayerKilled = ::onPlayerKilled; 
	
	if ( level.matchRules_damageMultiplier || level.matchRules_vampirism )
		level.modifyPlayerDamage = maps\mp\gametypes\_damage::gamemodeModifyPlayerDamage;
}


initializeMatchRules()
{
	//	set common values
	setCommonRulesFromMatchRulesData();
	
	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	level.matchRules_juggSwitchTime = GetMatchRulesData( "tjuggData", "juggSwitchTime" );
	
	SetDynamicDvar( "scr_tjugg_roundswitch", 0 );
	registerRoundSwitchDvar( "tjugg", 0, 0, 9 );
	SetDynamicDvar( "scr_tjugg_roundlimit", 1 );
	registerRoundLimitDvar( "tjugg", 1 );		
	SetDynamicDvar( "scr_tjugg_winlimit", 1 );
	registerWinLimitDvar( "tjugg", 1 );			
	SetDynamicDvar( "scr_tjugg_halftime", 0 );
	registerHalfTimeDvar( "tjugg", 0 );
	
	//	Friendly Fire option is unavailable for Team Juggernaut, 
	//	but enabling hardcore mode sets friendly fire,
	//	unset it here
	SetDynamicDvar( "scr_team_fftype", 0 );
		
	SetDynamicDvar( "scr_tjugg_promode", 0 );	
}


onPrecacheGametype()
{
	precacheString( &"MP_JUGG_NEXT_JUGG_IN" );	
}


onStartGameType()
{
	setClientNameMode("auto_change");

	setObjectiveText( "allies", &"OBJECTIVES_TJUGG" );
	setObjectiveText( "axis", &"OBJECTIVES_TJUGG" );

	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_TJUGG" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_TJUGG" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_TJUGG_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_TJUGG_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_TJUGG_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_TJUGG_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_allies_start" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_tdm_spawn_axis_start" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "allies", "mp_tdm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( "axis", "mp_tdm_spawn" );	
	
	level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	maps\mp\gametypes\_rank::registerScoreInfo( "got_juggernaut", 250 );
	maps\mp\gametypes\_rank::registerScoreInfo( "kill_juggernaut", 250 );
	maps\mp\gametypes\_rank::registerScoreInfo( "kill_as_juggernaut", 100 );
	//maps\mp\gametypes\_rank::registerScoreInfo( "defend_juggernaut", 100 );
	maps\mp\gametypes\_rank::registerScoreInfo( "jugg_on_jugg", 400 );

	allowed[0] = "tjugg";
	maps\mp\gametypes\_gameobjects::main(allowed);

	level.QuickMessageToAll = true;	
	level.blockWeaponDrops = true;
	
	level.respawnOldJugg_fx = loadfx( "explosions/bouncing_betty_explosion" );
	
	level.jugg_available = [];
	level.jugg_available["axis"] = true;
	level.jugg_available["allies"] = true;
	
	level.jugg_attackers = [];
	level.jugg_attackers["axis"] = [];
	level.jugg_attackers["allies"] = [];
	
	level.jugg_currJugg = [];
	level.jugg_currJugg["axis"] = undefined;
	level.jugg_currJugg["allies"] = undefined;
	
	level.tjugg_timerDisplay = [];
	level.tjugg_timerDisplay["allies"] = createServerTimer( "objective", 1.4, "allies" );
	level.tjugg_timerDisplay["allies"] setPoint( "TOPLEFT", "TOPLEFT", 115, 5 );
	level.tjugg_timerDisplay["allies"].label = &"MP_JUGG_NEXT_JUGG_IN";
	level.tjugg_timerDisplay["allies"].alpha = 0;
	level.tjugg_timerDisplay["allies"].archived = false;
	level.tjugg_timerDisplay["allies"].hideWhenInMenu = true;
	
	level.tjugg_timerDisplay["axis"  ] = createServerTimer( "objective", 1.4, "axis" );
	level.tjugg_timerDisplay["axis"  ] setPoint( "TOPLEFT", "TOPLEFT", 115, 5 );
	level.tjugg_timerDisplay["axis"  ].label = &"MP_JUGG_NEXT_JUGG_IN";
	level.tjugg_timerDisplay["axis"  ].alpha = 0;
	level.tjugg_timerDisplay["axis"  ].archived = false;
	level.tjugg_timerDisplay["axis"  ].hideWhenInMenu = true;
	
	thread hideTimerDisplayOnGameEnd( level.tjugg_timerDisplay["allies"] );
	thread hideTimerDisplayOnGameEnd( level.tjugg_timerDisplay["axis"  ] );	
	
	level.favorCloseSpawnScalar = 5;
	
	level thread onPlayerConnect();	
}


onPlayerConnect()
{
	while ( true )
	{
		level waittill( "connected", player );
		
		player.jugg_alligience = 0;	
	}	
}


getSpawnPoint()
{
	if ( level.inGracePeriod )
	{
		spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_tdm_spawn_" + self.pers["team"] + "_start" );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
	}
	else
	{
		level.favorCloseSpawnEnt = level.jugg_currJugg[self.pers["team"]];			
		
		spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
		spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_NearTeam( spawnPoints );
	}
	
	return spawnPoint;	
}


onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, lifeId )
{	
	//	do nothing here for change team suicide ( handled by resetJuggLoadoutOnChangeTeam() )
	if ( sMeansOfDeath == "MOD_SUICIDE" && sWeapon == "none" )
		return;
	
	victim = self;	
	if ( isDefined( attacker ) && isPlayer( attacker ) )
	{
		newJugg = false;
		giveJugg = false;
		juggKillJugg = false;
		killJugg = false;
		killAsJugg = false;
		defendJugg = false;
		score = 0;		
		
		if ( attacker == victim )
		{
			//	juggernaut suicide
			if ( isDefined( victim.isJuggModeJuggernaut ) )
				giveJugg = true;
		}
		else if ( attacker.team != victim.team )
		{
			score += maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
			
			//	juggernaut death
			if ( isDefined( victim.isJuggModeJuggernaut ) )
			{				
				giveJugg = true;					
				
				if ( isDefined( attacker.isJuggModeJuggernaut ) )
					// 	jugg on jugg,
					juggKillJugg = true;					
				else
					//	normal player on jugg,
					killJugg = true;	
			}			
			else 
			{				
				if ( isDefined( attacker.isJuggModeJuggernaut ) )
					//	regular kill as juggernaut
					killAsJugg = true;							
			}
				
			//	new juggernaut
			if ( level.jugg_available[attacker.team] )
				newJugg = true;
		}
		else if ( isDefined( victim.isJuggModeJuggernaut ) && attacker.team == victim.team )
		{
			//	friendly killed their own juggernaut (ff enabled)
			victim thread giveJuggLoadout();
			return;
		}
		
		//	attacker's team doesn't have a juggernaut yet, give it to the attacker
		if ( newJugg )
		{
			resetJugg( attacker );
		}

		//	victim was juggernaut, give it to victim's best teammate
		if ( giveJugg )
		{						
			//	look for players not using remotes first
			nextJugg = getBestTeammate( victim.team, false );
			
			//	if none, then include players using remotes
			if ( !isDefined( nextJugg ) )
				nextJugg = getBestTeammate( victim.team, true );				
			
			//	if not defined, then the jugg is the only one on the team, just give it back to them
			if ( !isDefined( nextJugg ) )	
				nextJugg = victim;
			resetJugg( nextJugg, victim );
		} 
		
		if ( newJugg || giveJugg )
		{
			playSoundOnPlayers( "mp_enemy_obj_captured" );
		}
						
		//	if not suicide and the attacker isn't the juggernaut, log brownie points for attacker team's juggernaut
		if ( attacker != victim && attacker.team != victim.team && !isDefined( attacker.isJuggModeJuggernaut ) )
		{		
			//	brownie points for killing anyone
			attacker.jugg_alligience += 50;
			//	extra brownie points for killing jug
			if ( killJugg )
				attacker.jugg_alligience += 100;
			//	extra brownie points for killing anyone who attacked the attacker's team juggernaut
			if ( isDefined( level.jugg_attackers[attacker.team][ victim.guid ] ) )
			{
				defendJugg = true;
				attacker.jugg_alligience += 100;
				level.jugg_attackers[attacker.team][ victim.guid ] = undefined;
			}
		}
		
		//	messaging
		if ( killJugg )
		{
			killJuggBonus = maps\mp\gametypes\_rank::getScoreInfoValue( "kill_juggernaut" );
			score += killJuggBonus;				
			attacker thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_KILLED_JUGGERNAUT" );
			maps\mp\gametypes\_gamescore::givePlayerScore( "kill_juggernaut", attacker, victim, true );
			attacker thread maps\mp\gametypes\_rank::giveRankXP( "kill_juggernaut" );			
		}
		else if ( juggKillJugg )
		{
			score += maps\mp\gametypes\_rank::getScoreInfoValue( "jugg_on_jugg" );
			attacker thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_JUGGERNAUT_KILL_JUGGERNAUT" );
			maps\mp\gametypes\_gamescore::givePlayerScore( "jugg_on_jugg", attacker, victim, true );
			attacker thread maps\mp\gametypes\_rank::giveRankXP( "jugg_on_jugg" );			
		}
		else if ( killAsJugg )
		{
			score += maps\mp\gametypes\_rank::getScoreInfoValue( "kill_as_juggernaut" );
			attacker thread maps\mp\gametypes\_rank::xpEventPopup( &"SPLASHES_JUGGERNAUT_KILL" );
			maps\mp\gametypes\_gamescore::givePlayerScore( "kill_as_juggernaut", attacker, victim, true );	
			attacker thread maps\mp\gametypes\_rank::giveRankXP( "kill_as_juggernaut" );		
		}
		
		//	scoring
		if ( score )
			attacker maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( attacker.pers["team"], score );
		
		//	final kill cam
		if ( attacker.team != victim.team && game["state"] == "postgame" && game["teamScores"][attacker.team] > game["teamScores"][level.otherTeam[attacker.team]] )
			attacker.finalKill = true;				
	}
	//	falling / environment damage 
	else if ( isDefined( victim.isJuggModeJuggernaut ) )
	{
		//	look for players not using remotes first
		nextJugg = getBestTeammate( victim.team, false );
		
		//	if none, then include players using remotes
		if ( !isDefined( nextJugg ) )
			nextJugg = getBestTeammate( victim.team, true );				
		
		//	if not defined, then the jugg is the only one on the team, just give it back to them
		if ( !isDefined( nextJugg ) )	
			nextJugg = victim;
		resetJugg( nextJugg, victim );		
	}					
}


resetJugg( newJugg, oldJugg )
{
	//	clear old jugg
	if ( isDefined( oldJugg ) )
		oldJugg.isJuggModeJuggernaut = undefined;
	else
		level.jugg_available[newJugg.team] = false;		
	
	//	clear new jugg
	level.jugg_currJugg[newJugg.team] = undefined;
	level.tjugg_timerDisplay[newJugg.team].alpha = 0;
	level.jugg_attackers[newJugg.team] = [];
	
	//	clear teammate allegience for old jugg
	foreach ( player in level.players )
	{
		if ( player.team == newJugg.team )
			player.jugg_alligience = 0;		
	}
	
	//	set the new jugg	
	newJugg thread giveJuggLoadout();
}


giveJuggLoadout()
{
	//	wait till they've spawned if they're dead, or using remote
	if ( !isReallyAlive( self ) || self isUsingRemote() )
	{
		self endon( "disconnect" );
		self thread resetJuggLoadoutOnDisconnect( false );
		
		while( !isReallyAlive( self ) || self isUsingRemote() )
			wait( 0.05 );
			
		self notify( "end_resetJuggLoadoutOnDisconnect" ); 
	}		
	
	//	remove placement item if carrying
	if ( IsDefined( self.isCarrying ) && self.isCarrying == true )
	{
		self notify( "force_cancel_placement" );
		wait( 0.05 );
	}
	
	//	remove killstreak if active
	if ( self isJuggernaut() )
	{
		self notify( "lost_juggernaut" );
		wait( 0.05 );
	}
	
	//	set vars
	self.isJuggModeJuggernaut = true;
	level.jugg_currJugg[self.team] = self;
	
	//	set the gamemodeloadout for giveLoadout() to use	
	self.pers["gamemodeLoadout"] = level.tjugg_loadouts[self.pers["team"]];		
			
	//	set faux TI to respawn in place
	spawnPoint = spawn( "script_model", self.origin );
	spawnPoint.angles = self.angles;
	spawnPoint.playerSpawnPos = self.origin;
	spawnPoint.notTI = true;		
	self.setSpawnPoint = spawnPoint;
			
	//	spawnPlayer() calls giveLoadout() passing the player's class
	//	save their chosen class and override their current and last class 
	//	- both so killstreaks don't get reset
	//	- this is automatically set back to chosen class within giveLoadout()				
	self.gamemode_chosenClass = self.class;				
	self.pers["class"] = "gamemode";
	self.pers["lastClass"] = "gamemode";
	self.class = "gamemode";
	self.lastClass = "gamemode";		
		
	//	faux spawn
	self notify( "faux_spawn" );
	self.faux_spawn_stance = self getStance();
	self thread maps\mp\gametypes\_playerlogic::spawnPlayer( true );	
	
	//	bonus!
	gotJuggBonus = maps\mp\gametypes\_rank::getScoreInfoValue( "got_juggernaut" );				
	self thread maps\mp\gametypes\_hud_message::SplashNotify( "got_juggernaut", gotJuggBonus );
	maps\mp\gametypes\_gamescore::givePlayerScore( "got_juggernaut", self, undefined, true );
	
	//	watch disconnect/change team
	self thread resetJuggLoadoutOnDisconnect( true );
	self thread resetJuggLoadoutOnChangeTeam();
	
	//	watch teammates
	self thread rewardTeammateProximity();
	self thread logAttackers();
	
	//	watch timeout
	self thread nextJuggTimeout();
}


nextJuggTimeout()
{
	level endon( "game_ended" );
	self endon( "disconnect" );
	self endon( "death" );
	
	level.tjugg_timerDisplay[self.team].label = &"MP_JUGG_NEXT_JUGG_IN";
	level.tjugg_timerDisplay[self.team] setTimer( level.matchRules_juggSwitchTime );
	level.tjugg_timerDisplay[self.team].alpha = 1;
	
	maps\mp\gametypes\_hostmigration::waitLongDurationWithHostMigrationPause( level.matchRules_juggSwitchTime );
	
	level.tjugg_timerDisplay[self.team].alpha = 0;
	
	//	look for players not using remotes first
	newJugg = getBestTeammate( self.team, false );
	
	//	if none, then include players using remotes
	if ( !isDefined( newJugg ) )
		newJugg = getBestTeammate( self.team, true );		
			
	//	if not defined, then the jugg is the only one on the team, just give it back to them
	if ( !isDefined( newJugg ) )
		newJugg = self;
	
	playSoundOnPlayers( "mp_enemy_obj_captured" );
	resetJugg( newJugg, self );	
	
	//	respawn
	if ( newJugg != self )
		self thread respawnOldJugg();		
}


respawnOldJugg()
{
	level endon( "game_ended" );
	self  endon( "disconnect" );
	
	//	wait till they're out of remotes
	while ( !isReallyAlive( self ) || self isUsingRemote() )
		wait( 0.05 );
	
	//	remove placement item if carrying
	if ( IsDefined( self.isCarrying ) && self.isCarrying == true )
	{
		self notify( "force_cancel_placement" );
		wait( 0.05 );
	}	
	
	playFX( level.respawnOldJugg_fx, self.origin );
	self notify( "lost_juggernaut" );
	wait( 0.05 );
	self notify( "faux_spawn" );
	self.faux_spawn_stance = self getStance();
	self thread maps\mp\gametypes\_playerlogic::spawnPlayer( true );
}


rewardTeammateProximity()
{
	level endon( "game_ended" );
	self endon( "death" );
	self endon( "disconnect" );
	
	while ( true )
	{
		wait( 1.0 );
		
		foreach ( player in level.players )
		{
			if ( isReallyAlive( player ) && !player isUsingRemote() && player != self && player.team == self.team && distanceSquared( player.origin, self.origin ) < 48400 )
				player.jugg_alligience += 25;
		}
	}	
}


logAttackers()
{
	level endon( "game_ended" );
	self endon( "death" );
	self endon( "disconnect" );
	
	while( true )
	{
		self waittill( "damage", amount, attacker );
		
		if ( isPlayer( attacker ) && attacker.team != self.team )
		{
			if ( !isDefined( level.jugg_attackers[self.team][ attacker.guid ] ) )
				level.jugg_attackers[self.team][ attacker.guid ] = true;
		}		
	}
}


resetJuggLoadoutOnDisconnect( endonDeath )
{
	level endon( "game_ended" );
	if ( endonDeath )
		self endon( "death" );
	else
		self endon( "end_resetJuggLoadoutOnDisconnect" );
	
	team = self.team;	
	self waittill( "disconnect" );

	//	look for players not using remotes first
	newJugg = getBestTeammate( team, false );
	
	//	if none found, include players using remotes
	if ( !isDefined( newJugg ) )
		newJugg = getBestTeammate( team, true );
		
	//	give them jugg
	if ( isDefined( newJugg ) )
	{
		playSoundOnPlayers( "mp_enemy_obj_captured" );
		resetJugg( newJugg );	
	}
	//	otherwise clear jugg vars so new jugg can be created if anyone joins or changes team
	else
	{
		level.jugg_available[team] = true;		
		level.jugg_currJugg[team] = undefined;
		level.tjugg_timerDisplay[team].alpha = 0;
		level.jugg_attackers[team] = [];
		foreach ( player in level.players )
		{
			if ( player.team == team )
				player.jugg_alligience = 0;		
		}		
	}
}


resetJuggLoadoutOnChangeTeam()
{
	level endon( "game_ended" );
	self  endon( "disconnect" );
	
	team = self.team;
	
	self waittill_any( "joined_team", "joined_spectators" );
	
	//	clear jugg
	self.isJuggModeJuggernaut = undefined;
	
	//	look for players not using remotes first
	newJugg = getBestTeammate( team, false );
	
	//	if none found, include players using remotes
	if ( !isDefined( newJugg ) )
		newJugg = getBestTeammate( team, true );
		
	//	give them jugg
	if ( isDefined( newJugg ) )
	{
		playSoundOnPlayers( "mp_enemy_obj_captured" );
		resetJugg( newJugg );	
	}
	//	otherwise clear jugg vars so new jugg can be created if anyone joins or changes team
	else
	{
		level.jugg_available[team] = true;		
		level.jugg_currJugg[team] = undefined;
		level.tjugg_timerDisplay[team].alpha = 0;
		level.jugg_attackers[team] = [];
		foreach ( player in level.players )
		{
			if ( player.team == team )
				player.jugg_alligience = 0;		
		}		
	}
}


getBestTeammate( team, allowRemote )
{
	bestTeammate = undefined;
	bestAlligience = -1;
	
	foreach ( player in level.players )
	{
		if ( ( allowRemote || !player isUsingRemote() ) && 
		     player != self && player.team == team && player.jugg_alligience > bestAlligience )
		{
			bestTeammate = player;
			bestAlligience = player.jugg_alligience;
		}	
	}
	
	return bestTeammate;
}


hideTimerDisplayOnGameEnd( timerDisplay )
{
	level waittill("game_ended");
	timerDisplay.alpha = 0;
}


setSpecialLoadouts()
{
	//	axis jugg
	if ( isUsingMatchRulesData() && GetMatchRulesData( "defaultClasses", "axis", 5, "class", "inUse" ) )
	{
		level.tjugg_loadouts["axis"] = getMatchRulesSpecialClass( "axis", 5 );	
		level.tjugg_loadouts["axis"]["loadoutJuggernaut"] = 1;
	}
	else
	{
		//	no killstreaks defined for special classes
		level.tjugg_loadouts["axis"]["loadoutPrimary"] = "iw5_scar";
		level.tjugg_loadouts["axis"]["loadoutPrimaryAttachment"] = "none";
		level.tjugg_loadouts["axis"]["loadoutPrimaryAttachment2"] = "none";
		level.tjugg_loadouts["axis"]["loadoutPrimaryBuff"] = "specialty_bulletpenetration";
		level.tjugg_loadouts["axis"]["loadoutPrimaryCamo"] = "none";
		level.tjugg_loadouts["axis"]["loadoutPrimaryReticle"] = "none";
		
		level.tjugg_loadouts["axis"]["loadoutSecondary"] = "rpg";
		level.tjugg_loadouts["axis"]["loadoutSecondaryAttachment"] = "none";
		level.tjugg_loadouts["axis"]["loadoutSecondaryAttachment2"] = "none";
		level.tjugg_loadouts["axis"]["loadoutSecondaryBuff"] = "specialty_null";
		level.tjugg_loadouts["axis"]["loadoutSecondaryCamo"] = "none";
		level.tjugg_loadouts["axis"]["loadoutSecondaryReticle"] = "none";
		
		level.tjugg_loadouts["axis"]["loadoutEquipment"] = "frag_grenade_mp";
		level.tjugg_loadouts["axis"]["loadoutOffhand"] = "smoke_grenade_mp";
		
		level.tjugg_loadouts["axis"]["loadoutPerk1"] = "specialty_scavenger";
		level.tjugg_loadouts["axis"]["loadoutPerk2"] = "_specialty_blastshield";
		level.tjugg_loadouts["axis"]["loadoutPerk3"] = "specialty_bulletaccuracy";
		
		level.tjugg_loadouts["axis"]["loadoutDeathstreak"] = "specialty_null";	
		level.tjugg_loadouts["axis"]["loadoutJuggernaut"] = 1;
	}
	
	//	allies jugg
	if ( isUsingMatchRulesData() && GetMatchRulesData( "defaultClasses", "allies", 5, "class", "inUse" ) )
	{
		level.tjugg_loadouts["allies"] = getMatchRulesSpecialClass( "allies", 5 );
		level.tjugg_loadouts["allies"]["loadoutJuggernaut"] = 1;		
	}
	else
	{
		//	no killstreaks defined for special classes
		level.tjugg_loadouts["allies"]["loadoutPrimary"] = "iw5_scar";
		level.tjugg_loadouts["allies"]["loadoutPrimaryAttachment"] = "none";
		level.tjugg_loadouts["allies"]["loadoutPrimaryAttachment2"] = "none";
		level.tjugg_loadouts["allies"]["loadoutPrimaryBuff"] = "specialty_bulletpenetration";
		level.tjugg_loadouts["allies"]["loadoutPrimaryCamo"] = "none";
		level.tjugg_loadouts["allies"]["loadoutPrimaryReticle"] = "none";
		
		level.tjugg_loadouts["allies"]["loadoutSecondary"] = "rpg";
		level.tjugg_loadouts["allies"]["loadoutSecondaryAttachment"] = "none";
		level.tjugg_loadouts["allies"]["loadoutSecondaryAttachment2"] = "none";
		level.tjugg_loadouts["allies"]["loadoutSecondaryBuff"] = "specialty_null";
		level.tjugg_loadouts["allies"]["loadoutSecondaryCamo"] = "none";
		level.tjugg_loadouts["allies"]["loadoutSecondaryReticle"] = "none";
		
		level.tjugg_loadouts["allies"]["loadoutEquipment"] = "frag_grenade_mp";
		level.tjugg_loadouts["allies"]["loadoutOffhand"] = "smoke_grenade_mp";
		
		level.tjugg_loadouts["allies"]["loadoutPerk1"] = "specialty_scavenger";
		level.tjugg_loadouts["allies"]["loadoutPerk2"] = "_specialty_blastshield";
		level.tjugg_loadouts["allies"]["loadoutPerk3"] = "specialty_bulletaccuracy";
		
		level.tjugg_loadouts["allies"]["loadoutDeathstreak"] = "specialty_null";
		level.tjugg_loadouts["allies"]["loadoutJuggernaut"] = 1;			
	}		
}
