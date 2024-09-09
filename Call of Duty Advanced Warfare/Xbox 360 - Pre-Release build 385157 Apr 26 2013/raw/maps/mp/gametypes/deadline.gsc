#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Deadline
	Objective: 	Score points for your team by eliminating players on the opposing team. You are holding a bomb whose time is ticking. Kill other players to get more time.
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
		registerScoreLimitDvar( level.gameType, 500 );
		registerRoundLimitDvar( level.gameType, 1 );
		registerWinLimitDvar( level.gameType, 1 );
		registerNumLivesDvar( level.gameType, 0 );
		registerHalfTimeDvar( level.gameType, 0 );
		
		level.matchRules_damageMultiplier = 0;
		level.matchRules_vampirism = 0;
	}

	level.teamBased = true;
	level.onStartGameType = ::onStartGameType;
	level.getSpawnPoint = ::getSpawnPoint;
	level.onNormalDeath = ::onNormalDeath;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerKilled = ::onPlayerKilled;
	
	if ( level.matchRules_damageMultiplier || level.matchRules_vampirism )
		level.modifyPlayerDamage = maps\mp\gametypes\_damage::gamemodeModifyPlayerDamage;

	//game["dialog"]["gametype"] = "tm_death";
	
	if ( getDvarInt( "g_hardcore" ) )
		game["dialog"]["gametype"] = "hc_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "camera_thirdPerson" ) )
		game["dialog"]["gametype"] = "thirdp_" + game["dialog"]["gametype"];
	else if ( getDvarInt( "scr_diehard" ) )
		game["dialog"]["gametype"] = "dh_" + game["dialog"]["gametype"];
	else if (getDvarInt( "scr_" + level.gameType + "_promode" ) )
		game["dialog"]["gametype"] = game["dialog"]["gametype"] + "_pro";
	
	game["strings"]["overtime_hint"] = &"MP_FIRST_BLOOD";
	
	SetDvarIfUninitialized( "scr_deadline_initial_bomb_time", 30 );
	SetDvarIfUninitialized( "scr_deadline_award_bomb_time", 10 );
}


initializeMatchRules()
{
	//	set common values
	setCommonRulesFromMatchRulesData();
	
	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	SetDynamicDvar( "scr_deadline_roundswitch", 0 );
	registerRoundSwitchDvar( "deadline", 0, 0, 9 );
	SetDynamicDvar( "scr_deadline_roundlimit", 1 );
	registerRoundLimitDvar( "deadline", 1 );
	SetDynamicDvar( "scr_deadline_winlimit", 1 );
	registerWinLimitDvar( "deadline", 1 );
	SetDynamicDvar( "scr_deadline_halftime", 0 );
	registerHalfTimeDvar( "deadline", 0 );
	
	SetDynamicDvar( "scr_deadline_promode", 0 );
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

	setObjectiveText( "allies", &"OBJECTIVES_DEADLINE" );
	setObjectiveText( "axis", &"OBJECTIVES_DEADLINE" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_DEADLINE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_DEADLINE" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_DEADLINE_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_DEADLINE_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_DEADLINE_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_DEADLINE_HINT" );
	
	level._effect["bombexplosion"] = LoadFX("explosions/tanker_explosion");
	level._effect["bombstrobe"] = LoadFX( "vfx/test/test_light_red_strobe_02_oneshot" );
	
	initSpawns();

	allowed[0] = level.gameType;
	allowed[1] = "airdrop_pallet";
	
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	//thread updateGametypeDvars();
	//level.deadline_bomb_time = 40;
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
	self endon("death");
	self endon("disconnect");
	
	score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	assert( isDefined( score ) );

	attacker maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( attacker.pers["team"], score );
	
	if ( game["state"] == "postgame" && game["teamScores"][attacker.team] > game["teamScores"][level.otherTeam[attacker.team]] )
		attacker.finalKill = true;
	
	//Awarding the attacker extra time.
//	if (IsDefined(attacker.hud_clock) && IsAlive(attacker))
//	{
//		attacker thread maps\mp\gametypes\_hud_message::SplashNotify( "deadline_time_added", maps\mp\gametypes\_rank::getScoreInfoValue( "kill" ) );
//		attacker.bomb_clock += attacker.award_time;
//		attacker.hud_clock setTimer( attacker.bomb_clock );
//		if (attacker.bomb_clock >= 10)
//		{
//			attacker.hud_clock.color = (.8, .8, 0);
//		}
//	}
	//Awarding the attacker extra time for all attackers.
	foreach (attacker in self.attackers)
	{
		attacker endon("death");
		attacker endon("disconnect");
		
		attacker thread maps\mp\gametypes\_hud_message::SplashNotify( "deadline_time_added", maps\mp\gametypes\_rank::getScoreInfoValue( "kill" ) );
		attacker.bomb_clock += attacker.award_time;
		attacker.hud_clock setTimer( attacker.bomb_clock );
		if (attacker.bomb_clock >= 10)
		{
			attacker.hud_clock.color = (.8, .8, 0);
		}
	}
}


onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, killId)
{
//	if( IsPlayer( self ) )
//	{
//		self.hud_clock Destroy();
//	}
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


onSpawnPlayer()
{
	//Set this player's bomb timer
	self.bomb_clock = getDvarInt( "scr_deadline_initial_bomb_time", 30 );
	self.award_time = getDvarInt( "scr_deadline_award_bomb_time", 10 );

	self thread countdownPlayerBombClock();
	
	//Killing view kick.
	self SetViewKickScale(0);
	
	level notify ( "spawned_player" );
}


//updateGametypeDvars()
//{
//	level.deadline_bomb_time = dvarFloatValue( "deadline_bomb_time", 30, 15, 240 );
//}


/*
///ScriptDocBegin
Name: countdownPlayerBombClock( )
Summary: decrements the player's bomb clock and causes the player to explode when the clock hits zero.
Module: deadline
CallOn: a player
MandatoryArg: N/A
Example: player thread countdownPlayerBombClock();
SPMP: MP
///ScriptDocEnd
*/
countdownPlayerBombClock()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon("game_ended");
	
	gameFlagWait("prematch_done");
	
	//Destroy this player's hud_clock if she already has one.
	if( IsPlayer( self ) && IsDefined(self.hud_clock) )
	{
		self.hud_clock Destroy();
	}
	
	self.hud_clock = maps\mp\gametypes\_hud_util::createTimer("hudbig", 1.0);
	self.hud_clock setPoint( "CENTER", "CENTER", 0, 80 );
	self.hud_clock setTimer( self.bomb_clock );
	self.hud_clock.color = (.8, .8, 0);
	self.hud_clock.archived = false;
	self.hud_clock.foreground = true;
	
	//Bomb strobe light.
	self thread controlBombStrobe();
	self thread play3DTickingSound();
	
	while (self.bomb_clock > 0)
	{
		self.bomb_clock--;
		if (self.bomb_clock < 10)
		{
			self.hud_clock.color = (1.0, 0, 0);
		}
		wait(1.0);
	}
	
	if (self.bomb_clock <= 0)
	{
		//Boom!
		//MagicBullet("rpg_mp", self.origin, self.origin - (0, 0, 64), self);
		self thread deadlineBombExplosion();
	}
}


/*
///ScriptDocBegin
Name: deadlineBombExplosion()
Summary: Creates an explosion with damage, VFX, rumble, earthquake and sound.
Module: deadline
CallOn: a player
MandatoryArg: N/A
Example: player thread deadlineBombExplosion();
SPMP: MP
///ScriptDocEnd
*/
deadlineBombExplosion()
{
	//Kill the player.
	self thread maps\mp\gametypes\_damage::finishPlayerDamageWrapper(self, self, 999999, 0, "MOD_SUICIDE", "bomb_site_mp", self.origin, self.origin, "none", 0, 0);
	
	//Create explosion.
	RadiusDamage(self.origin + (0, 0, 8), 550, 200, 10, self, "MOD_EXPLOSIVE", "bomb_site_mp");
	rot = RandomFloat(360);
	explosionEffect = spawnFx( level._effect["bombexplosion"], self.origin + (0,0,50));//, (0,0,1), (cos(rot),sin(rot),0) );
	triggerFx( explosionEffect );
	PlayRumbleOnPosition( "grenade_rumble", self.origin );
	earthquake( 0.25, 1.0, self.origin, 1000 );
	thread playSoundinSpace( "exp_suitcase_bomb_main", self.origin );
	wait(10);
	explosionEffect Delete();
}


/*
///ScriptDocBegin
Name: bombStrobePulse()
Summary: Creates a strobe Fx on a player, triggers it, and deletes it.
Module: deadline
CallOn: a player
MandatoryArg: N/A
Example: player thread bombStrobePulse();
SPMP: MP
///ScriptDocEnd
*/
bombStrobePulse()
{
	strobePulse = spawnFx(level._effect["bombstrobe"], self.origin + (0, 0, 50));
	TriggerFX(strobePulse);
	strobePulse Hide();			//Hide from everyone.
	foreach (player in level.players)
	{
		if (player != self)
		{
			strobePulse ShowToPlayer(player);
		}
	}
	wait(1);
	strobePulse Delete();
}


/*
///ScriptDocBegin
Name: controlBombStrobe()
Summary: uses bombStrobePulse() at different frequencies depending on how much time a player has on her bomb clock.
Module: deadline
CallOn: a player
MandatoryArg: N/A
Example: player thread controlBombStrobe();
SPMP: MP
///ScriptDocEnd
*/
controlBombStrobe()
{
	self endon( "death" );
	self endon( "disconnect" );
	//self endon ( "joined_team" );
	//self endon ( "joined_spectators" );
	
	while (1)
	{
		if (self.bomb_clock < 2)
		{
			self thread bombStrobePulse();
			wait(0.2);
		}
		else if (self.bomb_clock < 5)
		{
			self thread bombStrobePulse();
			wait(0.5);
		}
		else if (self.bomb_clock < 10)
		{
			self thread bombStrobePulse();
			wait(1);
		}
		else
		{
			wait(0.05);
		}
	}
}


/*
///ScriptDocBegin
Name: play3DTickingSound()
Summary: plays a 3D ticking sound on a player at different frequencies based on how close to zero a player's bomb clock is.
Module: deadline
CallOn: a player
MandatoryArg: N/A
Example: player thread play3DTickingSound();
SPMP: MP
///ScriptDocEnd
*/
play3DTickingSound()
{
	self endon( "death" );
	self endon( "disconnect" );
	//self endon ( "joined_team" );
	//self endon ( "joined_spectators" );
	
	level endon("game_ended");
	
	while(1)
	{
		if (self.bomb_clock < 2)
		{
			thread playSoundinSpace( "mp_suitcasebomb_timer_3d", self.origin );
			//self PlaySoundToPlayer("ui_mp_suitcasebomb_timer", self);
			wait(0.2);
		}
		else if ( self.bomb_clock < 5 )
		{
			thread playSoundinSpace( "mp_suitcasebomb_timer_3d", self.origin );
			//self PlaySoundToPlayer("ui_mp_suitcasebomb_timer", self);
			wait(0.5);
		}
		else if ( self.bomb_clock < 10 )
		{
			thread playSoundinSpace( "mp_suitcasebomb_timer_3d", self.origin );
			//self PlaySoundToPlayer("ui_mp_suitcasebomb_timer", self);
			wait(1.0);
		}
		else
		{
			wait(0.05);
		}
		maps\mp\gametypes\_hostmigration::waitTillHostMigrationDone();
	}
}
