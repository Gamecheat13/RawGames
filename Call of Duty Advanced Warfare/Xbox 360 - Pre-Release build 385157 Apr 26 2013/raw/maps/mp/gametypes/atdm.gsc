#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Augmented Team Deathmatch
	Objective: 	Score points for your team by eliminating players on the opposing team. You are an augmented soldier of the future!
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
	
	//SetDvarIfUninitialized( "scr_deadline_initial_bomb_time", 30 );
	//SetDvarIfUninitialized( "scr_deadline_award_bomb_time", 10 );
	
	//Increase jump height.
	SetDvar("jump_height", 50);
	//SetDvar("aim_lockon_enabled", 0);
}


initializeMatchRules()
{
	//	set common values
	setCommonRulesFromMatchRulesData();
	
	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	SetDynamicDvar( "scr_atdm_roundswitch", 0 );
	registerRoundSwitchDvar( "atdm", 0, 0, 9 );
	SetDynamicDvar( "scr_atdm_roundlimit", 1 );
	registerRoundLimitDvar( "atdm", 1 );
	SetDynamicDvar( "scr_atdm_winlimit", 1 );
	registerWinLimitDvar( "atdm", 1 );
	SetDynamicDvar( "scr_atdm_halftime", 0 );
	registerHalfTimeDvar( "atdm", 0 );
	
	SetDynamicDvar( "scr_atdm_promode", 0 );
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

	setObjectiveText( "allies", &"OBJECTIVES_ATDM" );
	setObjectiveText( "axis", &"OBJECTIVES_ATDM" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_ATDM" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_ATDM" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_ATDM_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_ATDM_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_ATDM_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_ATDM_HINT" );
	
	initSpawns();
	
	allowed[0] = level.gameType;
	allowed[1] = "airdrop_pallet";
	
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	maps\mp\gametypes\_player_boost_jump_mp::playerBoostJumpPrecaching();
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
	score = maps\mp\gametypes\_rank::getScoreInfoValue( "kill" );
	assert( isDefined( score ) );

	attacker maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( attacker.pers["team"], score );
	
	if ( game["state"] == "postgame" && game["teamScores"][attacker.team] > game["teamScores"][level.otherTeam[attacker.team]] )
		attacker.finalKill = true;
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
	self SetViewKickScale(0);
	//TODO: self.health = 200;
	//TODO: self.maxhealth = 200;
	self.moveSpeedScaler = 1.1;
	self maps\mp\gametypes\_weapons::updateMoveSpeedScale();
	//self givePerk("specialty_stalker", false);
	//self givePerk("specialty_quickdraw", false);
	
	self thread maps\mp\gametypes\_player_boost_jump_mp::boost_jump_wrapper();
	
	//self thread crouchSlide();
	
	level notify ( "spawned_player" );
}


/*
///ScriptDocBegin
Name: crouchSlide()
Summary: When a player is sprinting and they hit the crouch/prone button, they will slide for a short distance.
Module: MP
CallOn: a player
MandatoryArg: <thruster_force> the vector you want to add to the player's velocity.
Example: level.player thread boost_jump();
SPMP: MP
///ScriptDocEnd
*/
//Call on player
//When the player presses crouch while sprinting, they will do a crouch slide.
crouchSlide()
{
	while (1)
	{
		if (self ButtonPressed("BUTTON_B"))
		{
			current_vel_vec = self GetVelocity();
			current_vel_magnitude = current_vel_vec[0] * current_vel_vec[0] + current_vel_vec[1] * current_vel_vec[1];
			if (current_vel_magnitude > 40000 && self IsOnGround())
			{
				//The player is moving fast (sprinting usually) and is on the ground.
				self thread doSlide(current_vel_vec);
			}
		}
		wait(0.05);
	}
}


doSlide(current_velocity)
{
	for (i = 0; i < 10; i++)
	{
		current_vel_vec = self GetVelocity();
		current_vel_magnitude = current_vel_vec[0] * current_vel_vec[0] + current_vel_vec[1] * current_vel_vec[1];
		if (self GetStance() == "prone" || current_vel_magnitude < 30000)
		{
			//If the player has gone prone or has slowed down (hit a wall or something), then go to the last iteration of the loop to stop the slide.
			i = 10;
		}
		self SetVelocity(current_velocity);
		wait(0.05);
	}
}
