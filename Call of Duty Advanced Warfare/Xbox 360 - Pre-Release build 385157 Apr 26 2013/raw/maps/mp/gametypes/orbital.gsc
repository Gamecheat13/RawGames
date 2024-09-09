#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
#include maps\mp\gametypes\_orbital;
#include common_scripts\utility;
/*
	Orbital
	Objective: 	Score points for your team by eliminating players on the opposing team
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
		registerScoreLimitDvar( level.gameType, 200 );
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


initializeMatchRules()
{
	//	set common values
	setCommonRulesFromMatchRulesData();
	
	//	set everything else (private match options, default .cfg file values, and what normally is registered in the 'else' below)
	SetDynamicDvar( "scr_orbital_roundswitch", 0 );
	registerRoundSwitchDvar( "orbital", 0, 0, 9 );
	SetDynamicDvar( "scr_orbital_roundlimit", 1 );
	registerRoundLimitDvar( "orbital", 1 );		
	SetDynamicDvar( "scr_orbital_winlimit", 1 );
	registerWinLimitDvar( "orbital", 1 );			
	SetDynamicDvar( "scr_orbital_halftime", 0 );
	registerHalfTimeDvar( "orbital", 0 );
		
	SetDynamicDvar( "scr_orbital_promode", 0 );	
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

	setObjectiveText( "allies", &"OBJECTIVES_ORBITAL" );
	setObjectiveText( "axis", &"OBJECTIVES_ORBITAL" );
	
	if ( level.splitscreen )
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_ORBITAL" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_ORBITAL" );
	}
	else
	{
		setObjectiveScoreText( "allies", &"OBJECTIVES_ORBITAL_SCORE" );
		setObjectiveScoreText( "axis", &"OBJECTIVES_ORBITAL_SCORE" );
	}
	setObjectiveHintText( "allies", &"OBJECTIVES_ORBITAL_HINT" );
	setObjectiveHintText( "axis", &"OBJECTIVES_ORBITAL_HINT" );
	
	initSpawns();
	
	allowed[0] = level.gameType;
	allowed[1] = "airdrop_pallet";
	
	maps\mp\gametypes\_gameobjects::main(allowed);
	
	maps\mp\gametypes\_rank::registerScoreInfo( "kill", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "headshot", 50 );
	maps\mp\gametypes\_rank::registerScoreInfo( "assist", 10 );

	maps\mp\gametypes\_rank::registerScoreInfo( "pod_destroy", 200 );
	maps\mp\gametypes\_rank::registerScoreInfo( "pod_tick", 5 );
	
	thread orbital();
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


//Special onSpawnPlayer() for Orbital
onSpawnPlayer()
{
	//HACK: setting a "safe" place outside of mp_dome.map's playable area.
	temp_origin = (3000, 3000, 500);
	temp_spawn_loc = drop_to_ground(temp_origin);
	self SetOrigin(temp_spawn_loc);
	
	self thread spawnPlayerInOrbital();
}


spawnPlayerInOrbital()
{
    self waittill( "spawned_player" );
    
    //Showing the dropping player the friendly/enemy drop pods and trophies, friendly/enemy players.
    self thread maps\mp\gametypes\_orbital::showFriendlyPlayerIcons( self );
	//self thread maps\mp\gametypes\_orbital::showDropPodTrophyFx( self );
	self.isdropping = true;
	
    self thread maps\mp\gametypes\_orbital::spawnOrbital();

    self waittill_any(  "player_drop_pod_spawned", "player_spawned_at_drop_pod" );
    
    self.isdropping = undefined;
    
   // self maps\mp\gametypes\_orbital::destroyEnemyDropPodIcons();
	self maps\mp\gametypes\_orbital::destroyFriendlyPlayerIcons();
    
}


onNormalDeath( victim, attacker, lifeId )
{
	if ( game["state"] == "postgame" && game["teamScores"][attacker.team] > game["teamScores"][level.otherTeam[attacker.team]] )
		attacker.finalKill = true;
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


onPlayerKilled( eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration, lifeId )
{
	//The victim (self) has died, so notify("death") on the drop pod so that it will be destroyed.
	//if (IsDefined(self.drop_pod))			//Commenting this out because we are trying allow players to spawn back on their previously landed pod.
	//{
	//	self.drop_pod notify("death");
	//}
}


orbital()
{
	//Creating a struct for our drop pods.
	level.drop_pod = SpawnStruct();
	//A model asset for our drop pods.
	level.drop_pod.model = "drop_pod_test";
	//level.drop_pod.vehicleInfo = "drop_pod_test";
	//PreCacheModel( level.drop_pod.model );
	PreCacheModel( "drop_pod_test" );
	PreCacheShader( "hud_fofbox_hostile" );
	
	level.drop_pod_glow["friendly"] = LoadFX( "fx/misc/ui_drop_pod_friendly" );
	level.drop_pod_glow["enemy"] = LoadFX( "fx/misc/ui_drop_pod_enemy" );
	
	//precacheModel( level.drop_pod_glow["friendly"] );
	//precacheModel( level.drop_pod_glow["enemy"] );	
	
	level.drop_pod_trophyFX["friendly"] =  LoadFX( "fx/misc/ui_drop_pod_trophy_friendly" );
	level.drop_pod_trophyFX["enemy"] =  LoadFX( "fx/misc/ui_drop_pod_trophy_enemy" );
	
	level.drop_pod_volume_array = GetEntArray("drop_pod_volume", "targetname");
		
	/*
	//X, Y, Z
	map_origin = (-518, 181, -356);
	//Pitch, Yaw, Roll
	temp_angles = (0, 90, 0);
	
	//A drop pod.
	//(visuals[1] which you find in payload.gsc is for the drone's icon (notice how the origin is the same as the drone with added z)).
	//This visuals[] array is just used for storing the newly-spawned script_model. Let's try moving this to each player, such as level.players[0].drop_pod.
	visuals[0] = spawn("script_model", map_origin);
	visuals[0].angles = temp_angles;
	visuals[0] SetModel( level.drop_pod.model );
	visuals[0] Solid();
	visuals[0] SetCanDamage( true );
	visuals[0] SetCanRadiusDamage( true );
	visuals[0].health = 10;
	visuals[0].maxhealth = 10;
	//visuals[0] Show();		//Don't seem to need this because the model defaults to visible. If you wanted to hide it, you'd call Hide() here.
	*/
	
	//thread updateOrbitalScores();
}


/*
///ScriptDocBegin
Name: updateOrbitalScores( )
Summary: Awards Team Points for living drop pods.
Module: orbital
CallOn: N/A
Example: thread updateOrbitalScores();
SPMP: MP
///ScriptDocEnd
*/
updateOrbitalScores()
{
	level endon( "game_ended" );
	
	while (1)
	{
		//Giving team points for living drop pods.
		foreach (player in level.players)
		{
			if (IsDefined(player.drop_pod))
			{
				//Each drop pod awards 5 team points every 10 seconds.
				maps\mp\gametypes\_gamescore::giveTeamScoreForObjective( player.pers["team"], 5 );
				
				//The player's living drop pod awards the player 5 XP every 10 seconds. Note: this only rewards XP when there are enemies in the match.
				player thread maps\mp\gametypes\_rank::giveRankXP( "pod_tick", 5 );
				maps\mp\gametypes\_gamescore::givePlayerScore( "pod_tick", player );
			}
		}
		wait(10);
	}
}
