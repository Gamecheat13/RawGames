#include common_scripts\utility;
#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
// Rallypoints should be destroyed on leaving your team/getting killed
// Compass icons need to be looked at
// Doesn't seem to be setting angle on spawn so that you are facing your rallypoint

/*
	Search and Destroy
	Attackers objective: Bomb one of 2 positions
	Defenders objective: Defend these 2 positions / Defuse planted bombs
	Round ends:	When one team is eliminated, bomb explodes, bomb is defused, or roundlength time is reached
	Map ends:	When one team reaches the score limit, or time limit or round limit is reached
	Respawning:	Players remain dead for the round and will respawn at the beginning of the next round

	Level requirements
	------------------
		Allied Spawnpoints:
			classname		mp_sd_spawn_attacker
			Allied players spawn from these. Place at least 16 of these relatively close together.

		Axis Spawnpoints:
			classname		mp_sd_spawn_defender
			Axis players spawn from these. Place at least 16 of these relatively close together.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

		Bombzones:
			classname					trigger_multiple
			targetname					bombzone
			script_gameobjectname		bombzone
			script_bombmode_original	<if defined this bombzone will be used in the original bomb mode>
			script_bombmode_single		<if defined this bombzone will be used in the single bomb mode>
			script_bombmode_dual		<if defined this bombzone will be used in the dual bomb mode>
			script_team					Set to allies or axis. This is used to set which team a bombzone is used by in dual bomb mode.
			script_label				Set to A or B. This sets the letter shown on the compass in original mode.
			This is a volume of space in which the bomb can planted. Must contain an origin brush.

		Bomb:
			classname				trigger_lookat
			targetname				bombtrigger
			script_gameobjectname	bombzone
			This should be a 16x16 unit trigger with an origin brush placed so that it's center lies on the bottom plane of the trigger.
			Must be in the level somewhere. This is the trigger that is used when defusing a bomb.
			It gets moved to the position of the planted bomb model.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "marines";
			game["axis"] = "nva";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.

			game["attackers"] = "allies";
			game["defenders"] = "axis";
			This sets which team is attacking and which team is defending. Attackers plant the bombs. Defenders protect the targets.

		If using minefields or exploders:
			maps\mp\_load::main();

	Optional level script settings
	------------------------------
		Soldier Type and Variation:
			game["soldiertypeset"] = "seals";
			This sets what character models are used for each nationality on a particular map.

			Valid settings:
				soldiertypeset	seals

		Exploder Effects:
			Setting script_noteworthy on a bombzone trigger to an exploder group can be used to trigger additional effects.
*/

/*QUAKED mp_sd_spawn_attacker (0.0 1.0 0.0) (-16 -16 0) (16 16 72)
Attacking players spawn randomly at one of these positions at the beginning of a round.*/

/*QUAKED mp_sd_spawn_defender (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
Defending players spawn randomly at one of these positions at the beginning of a round.*/

#define CARRY_ICON_X 130
#define CARRY_ICON_Y -60
	
#define OBJECTIVE_FLAG_DEFUSED 0	
#define OBJECTIVE_FLAG_PLANTED 1

main()
{
	if(GetDvar( "mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();
	
	registerRoundSwitch( 0, 9 );
	registerTimeLimit( 0, 1440 );
	registerScoreLimit( 0, 500 );
	registerRoundLimit( 0, 12 );
	registerRoundWinLimit( 0, 10 );
	registerNumLives( 0, 10 );
	
	maps\mp\gametypes\_weapons::registerGrenadeLauncherDudDvar( level.gameType, 15, 0, 1440 );
	maps\mp\gametypes\_weapons::registerThrownGrenadeDudDvar( level.gameType, 5, 0, 1440 );
	maps\mp\gametypes\_weapons::registerKillstreakDelay( level.gameType, 15, 0, 1440 );

	maps\mp\gametypes\_globallogic::registerFriendlyFireDelay( level.gameType, 15, 0, 1440 );

	level.teamBased = true;
	level.overrideTeamScore = true;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onSpawnPlayerUnified = ::onSpawnPlayerUnified;
	level.playerSpawnedCB = ::sd_playerSpawnedCB;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onDeadEvent = ::onDeadEvent;
	level.onOneLeftEvent = ::onOneLeftEvent;
	level.onTimeLimit = ::onTimeLimit;
	level.onRoundSwitch = ::onRoundSwitch;
	level.getTeamKillPenalty = ::sd_getTeamKillPenalty;
	level.getTeamKillScore = ::sd_getTeamKillScore;
	level.isKillBoosting = ::sd_isKillBoosting;
	
	level.endGameOnScoreLimit = false;
	
	game["dialog"]["gametype"] = "sd_start";
	game["dialog"]["gametype_hardcore"] = "hcsd_start";
	game["dialog"]["offense_obj"] = "destroy_start";
	game["dialog"]["defense_obj"] = "defend_start";
	game["dialog"]["sudden_death"] = "generic_boost";
	game["dialog"]["last_one"] = "encourage_last";	
	game["dialog"]["halftime"] = "sd_halftime";
	
	// Sets the scoreboard columns and determines with data is sent across the network
	setscoreboardcolumns( "score", "kills", "deaths", "plants", "defuses" ); 
}

onPrecacheGameType()
{
	//game["bombmodelname"] = "weapon_explosives";
	//game["bombmodelnameobj"] = "weapon_explosives";
	game["bomb_dropped_sound"] = "flag_drop_plr";
	game["bomb_recovered_sound"] = "flag_pickup_plr";
	//precacheModel(game["bombmodelname"]);
	//precacheModel(game["bombmodelnameobj"]);

	precacheShader("waypoint_bomb");
	precacheShader("hud_suitcase_bomb");
	precacheShader("waypoint_target");
	precacheShader("waypoint_target_a");
	precacheShader("waypoint_target_b");
	precacheShader("waypoint_defend");
	precacheShader("waypoint_defend_a");
	precacheShader("waypoint_defend_b");
	precacheShader("waypoint_defuse");
	precacheShader("waypoint_defuse_a");
	precacheShader("waypoint_defuse_b");
	precacheShader("compass_waypoint_target");
	precacheShader("compass_waypoint_target_a");
	precacheShader("compass_waypoint_target_b");
	precacheShader("compass_waypoint_defend");
	precacheShader("compass_waypoint_defend_a");
	precacheShader("compass_waypoint_defend_b");
	precacheShader("compass_waypoint_defuse");
	precacheShader("compass_waypoint_defuse_a");
	precacheShader("compass_waypoint_defuse_b");
	
	precacheString( &"MP_EXPLOSIVES_BLOWUP_BY" );
	precacheString( &"MP_EXPLOSIVES_RECOVERED_BY" );
	precacheString( &"MP_EXPLOSIVES_DROPPED_BY" );
	precacheString( &"MP_EXPLOSIVES_PLANTED_BY" );
	precacheString( &"MP_EXPLOSIVES_DEFUSED_BY" );
	precacheString( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
	precacheString( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	precacheString( &"MP_CANT_PLANT_WITHOUT_BOMB" );	
	precacheString( &"MP_PLANTING_EXPLOSIVE" );	
	precacheString( &"MP_DEFUSING_EXPLOSIVE" );	
}

sd_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, sWeapon )
{
	teamkill_penalty = maps\mp\gametypes\_globallogic_defaults::default_getTeamKillPenalty( eInflictor, attacker, sMeansOfDeath, sWeapon );

	if ( ( isdefined( self.isDefusing ) && self.isDefusing ) || ( isdefined( self.isPlanting ) && self.isPlanting ) )
	{
		teamkill_penalty = teamkill_penalty * level.teamKillPenaltyMultiplier;
	}
	
	return teamkill_penalty;
}

sd_getTeamKillScore( eInflictor, attacker, sMeansOfDeath, sWeapon )
{
	teamkill_score = maps\mp\gametypes\_rank::getScoreInfoValue( "team_kill" );
	
	if ( ( isdefined( self.isDefusing ) && self.isDefusing ) || ( isdefined( self.isPlanting ) && self.isPlanting ) )
	{
		teamkill_score = teamkill_score * level.teamKillScoreMultiplier;
	}
	
	return int(teamkill_score);
}


onRoundSwitch()
{
	if ( !isdefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( game["teamScores"]["allies"] == level.scorelimit - 1 && game["teamScores"]["axis"] == level.scorelimit - 1 )
	{
		// overtime! team that's ahead in kills gets to defend.
		aheadTeam = getBetterTeam();
		if ( aheadTeam != game["defenders"] )
		{
			game["switchedsides"] = !game["switchedsides"];
		}
		level.halftimeType = "overtime";
	}
	else
	{
		level.halftimeType = "halftime";
		game["switchedsides"] = !game["switchedsides"];
	}
}

getBetterTeam()
{
	kills["allies"] = 0;
	kills["axis"] = 0;
	deaths["allies"] = 0;
	deaths["axis"] = 0;
	
	for ( i = 0; i < level.players.size; i++ )
	{
		player = level.players[i];
		team = player.pers["team"];
		if ( isDefined( team ) && (team == "allies" || team == "axis") )
		{
			kills[ team ] += player.kills;
			deaths[ team ] += player.deaths;
		}
	}
	
	if ( kills["allies"] > kills["axis"] )
		return "allies";
	else if ( kills["axis"] > kills["allies"] )
		return "axis";
	
	// same number of kills

	if ( deaths["allies"] < deaths["axis"] )
		return "allies";
	else if ( deaths["axis"] < deaths["allies"] )
		return "axis";
	
	// same number of deaths
	
	if ( randomint(2) == 0 )
		return "allies";
	return "axis";
}

onStartGameType()
{	
	SetBombTimer( "A", 0 );
	SetMatchFlag( "bomb_timer_a", 0 );
	SetBombTimer( "B", 0 );
	SetMatchFlag( "bomb_timer_b", 0 );
	
	if ( !isDefined( game["switchedsides"] ) )
		game["switchedsides"] = false;
	
	if ( game["switchedsides"] )
	{
		oldAttackers = game["attackers"];
		oldDefenders = game["defenders"];
		game["attackers"] = oldDefenders;
		game["defenders"] = oldAttackers;
	}
	
	setClientNameMode( "manual_change" );
	
	game["strings"]["target_destroyed"] = &"MP_TARGET_DESTROYED";
	game["strings"]["bomb_defused"] = &"MP_BOMB_DEFUSED";
	
	precacheString( game["strings"]["target_destroyed"] );
	precacheString( game["strings"]["bomb_defused"] );

	level._effect["bombexplosion"] = loadfx("maps/mp_maps/fx_mp_exp_bomb");
	
	setObjectiveText( game["attackers"], &"OBJECTIVES_SD_ATTACKER" );
	setObjectiveText( game["defenders"], &"OBJECTIVES_SD_DEFENDER" );

	if ( level.splitscreen )
	{
		setObjectiveScoreText( game["attackers"], &"OBJECTIVES_SD_ATTACKER" );
		setObjectiveScoreText( game["defenders"], &"OBJECTIVES_SD_DEFENDER" );
	}
	else
	{
		setObjectiveScoreText( game["attackers"], &"OBJECTIVES_SD_ATTACKER_SCORE" );
		setObjectiveScoreText( game["defenders"], &"OBJECTIVES_SD_DEFENDER_SCORE" );
	}
	setObjectiveHintText( game["attackers"], &"OBJECTIVES_SD_ATTACKER_HINT" );
	setObjectiveHintText( game["defenders"], &"OBJECTIVES_SD_DEFENDER_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );	
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_sd_spawn_attacker" );
	maps\mp\gametypes\_spawnlogic::placeSpawnPoints( "mp_sd_spawn_defender" );
	
		level.mapCenter = maps\mp\gametypes\_spawnlogic::findBoxCenter( level.spawnMins, level.spawnMaxs );
	setMapCenter( level.mapCenter );

	spawnpoint = maps\mp\gametypes\_spawnlogic::getRandomIntermissionPoint();
	setDemoIntermissionPoint( spawnpoint.origin, spawnpoint.angles );
	
	allowed[0] = "sd";
	allowed[1] = "bombzone";
	allowed[2] = "blocker";
	maps\mp\gametypes\_gameobjects::main(allowed);

	// now that the game objects have been deleted place the influencers
	maps\mp\gametypes\_spawning::create_map_placed_influencers();

	level.spawn_start = [];
	
	level.spawn_start["axis"] = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_sd_spawn_defender" );
	level.spawn_start["allies"] = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( "mp_sd_spawn_attacker" );

	thread updateGametypeDvars();
	
	thread bombs();
}


onSpawnPlayerUnified()
{
	self.isPlanting = false;
	self.isDefusing = false;
	self.isBombCarrier = false;
	
	maps\mp\gametypes\_spawning::onSpawnPlayer_Unified();
}


onSpawnPlayer(predictedSpawn)
{
	if ( !predictedSpawn )
	{
		self.isPlanting = false;
		self.isDefusing = false;
		self.isBombCarrier = false;
	}

	if(self.pers["team"] == game["attackers"])
		spawnPointName = "mp_sd_spawn_attacker";
	else
		spawnPointName = "mp_sd_spawn_defender";

	spawnPoints = maps\mp\gametypes\_spawnlogic::getSpawnpointArray( spawnPointName );
	assert( spawnPoints.size );
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );

	if (predictedSpawn)
	{
		self predictSpawnPoint( spawnpoint.origin, spawnpoint.angles );
	}
	else
	{
		self spawn( spawnpoint.origin, spawnpoint.angles, "sd" );
	}
}


sd_playerSpawnedCB()
{
	level notify ( "spawned_player" );
}


onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	thread checkAllowSpectating();
	
	inBombZone = false;
	if (  !isdefined( sWeapon ) || !maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( sWeapon ) )
	{
		for ( index = 0; index < level.bombZones.size; index++ )
		{
			dist = Distance2d(self.origin, level.bombZones[index].curorigin);
			if ( dist < level.defaultOffenseRadius )
				inBombZone = true;
		}
		
		if ( inBombZone && isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] )
		{	
			if ( game["defenders"] == self.pers["team"] )
			{
				attacker maps\mp\_medals::offense( sWeapon );
				attacker AddPlayerStatWithGameType( "OFFENDS", 1 );
				self recordKillModifier("defending");
				maps\mp\_scoreevents::processScoreEvent( "killed_defender", attacker, self, sWeapon, true );
			}
			else
			{
				if( isdefined(attacker.pers["defends"]) )
				{
					attacker.pers["defends"]++;
					attacker.defends = attacker.pers["defends"];
				}

				attacker maps\mp\_medals::defense( sWeapon );
				attacker AddPlayerStatWithGameType( "DEFENDS", 1 );
				self recordKillModifier("assaulting");
				maps\mp\_scoreevents::processScoreEvent( "killed_attacker", attacker, self, sWeapon, true );
			}
		}
	}
	
	if ( isPlayer( attacker ) && attacker.pers["team"] != self.pers["team"] && isdefined( self.isBombCarrier ) && self.isBombCarrier == true )
	{
		attacker maps\mp\_challenges::killedBombCarrier();
		self recordKillModifier("carrying");
	}

	if( self.isPlanting == true )
		self recordKillModifier("planting");

	if( self.isDefusing == true )
		self recordKillModifier("defusing");
}


checkAllowSpectating()
{
	wait ( 0.05 );
	
	update = false;

	livesLeft = !(level.numLives && !self.pers["lives"]);

	if ( !level.aliveCount[ game["attackers"] ] && !livesLeft )
	{
		level.spectateOverride[game["attackers"]].allowEnemySpectate = 1;
		update = true;
	}
	if ( !level.aliveCount[ game["defenders"] ] && !livesLeft )
	{
		level.spectateOverride[game["defenders"]].allowEnemySpectate = 1;
		update = true;
	}
	if ( update )
		maps\mp\gametypes\_spectating::updateSpectateSettings();
}


sd_endGame( winningTeam, endReasonText )
{
	if ( isdefined( winningTeam ) )
		maps\mp\gametypes\_globallogic_score::giveTeamScoreForObjective( winningTeam, 1 );

	thread maps\mp\gametypes\_globallogic::endGame( winningTeam, endReasonText );
}

sd_endGameWithKillcam( winningTeam, endReasonText )
{
	level thread maps\mp\gametypes\_killcam::startLastKillcam();
	sd_endGame( winningTeam, endReasonText );
}


onDeadEvent( team )
{
	if ( level.bombExploded || level.bombDefused )
		return;
	
	if ( team == "all" )
	{
		if ( level.bombPlanted )
			sd_endGameWithKillcam( game["attackers"], game["strings"][game["defenders"]+"_eliminated"] );
		else
			sd_endGameWithKillcam( game["defenders"], game["strings"][game["attackers"]+"_eliminated"] );
	}
	else if ( team == game["attackers"] )
	{
		if ( level.bombPlanted )
			return;
		
		sd_endGameWithKillcam( game["defenders"], game["strings"][game["attackers"]+"_eliminated"] );
	}
	else if ( team == game["defenders"] )
	{
		sd_endGameWithKillcam( game["attackers"], game["strings"][game["defenders"]+"_eliminated"] );
	}
}


onOneLeftEvent( team )
{
	if ( level.bombExploded || level.bombDefused )
		return;
	
	//if ( team == game["attackers"] )
	warnLastPlayer( team );
}


onTimeLimit()
{
	if ( level.teamBased )
		sd_endGame( game["defenders"], game["strings"]["time_limit_reached"] );
	else
		sd_endGame( undefined, game["strings"]["time_limit_reached"] );
}


warnLastPlayer( team )
{
	if ( !isdefined( level.warnedLastPlayer ) )
		level.warnedLastPlayer = [];
	
	if ( isDefined( level.warnedLastPlayer[team] ) )
		return;
		
	level.warnedLastPlayer[team] = true;

	players = level.players;
	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( isDefined( player.pers["team"] ) && player.pers["team"] == team && isdefined( player.pers["class"] ) )
		{
			if ( player.sessionstate == "playing" && !player.afk )
				break;
		}
	}
	
	if ( i == players.size )
		return;
	
	players[i] thread giveLastAttackerWarning();
	

}


giveLastAttackerWarning()
{
	self endon("death");
	self endon("disconnect");
	
	fullHealthTime = 0;
	interval = .05;
	
	while(1)
	{
		if ( self.health != self.maxhealth )
			fullHealthTime = 0;
		else
			fullHealthTime += interval;
		
		wait interval;
		
		if (self.health == self.maxhealth && fullHealthTime >= 3)
			break;
	}

	self maps\mp\gametypes\_globallogic_audio::leaderDialogOnPlayer( "last_one" );
	self playlocalsound ("mus_last_stand");	
		
	self.lastManSD = true;
}


updateGametypeDvars()
{
	level.plantTime = GetGametypeSetting( "plantTime" );
	level.defuseTime = GetGametypeSetting( "defuseTime" );
	level.bombTimer = GetGametypeSetting( "bombTimer" );
	level.multiBomb = GetGametypeSetting( "multiBomb" );

	level.teamKillPenaltyMultiplier = GetGametypeSetting( "teamKillPenalty" );
	level.teamKillScoreMultiplier = GetGametypeSetting( "teamKillScore" );
	
	level.playerKillsMax = GetGametypeSetting( "playerKillsMax" );
	level.totalKillsMax = GetGametypeSetting( "totalKillsMax" );
}

bombs()
{
	level.bombPlanted = false;
	level.bombDefused = false;
	level.bombExploded = false;

	trigger = getEnt( "sd_bomb_pickup_trig", "targetname" );
	if ( !isDefined( trigger ) )
	{
		/#maps\mp\_utility::error("No sd_bomb_pickup_trig trigger found in map.");#/
		return;
	}
	
	visuals[0] = getEnt( "sd_bomb", "targetname" );
	if ( !isDefined( visuals[0] ) )
	{
		/#maps\mp\_utility::error("No sd_bomb script_model found in map.");#/
		return;
	}

	precacheModel( "prop_suitcase_bomb" );
	PrecacheString( &"bomb" );
	//visuals[0] setModel( "weapon_explosives" );
	
	if ( !level.multiBomb )
	{
		level.sdBomb = maps\mp\gametypes\_gameobjects::createCarryObject( game["attackers"], trigger, visuals, (0,0,32), &"bomb" );
		level.sdBomb maps\mp\gametypes\_gameobjects::allowCarry( "friendly" );
		level.sdBomb maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_bomb" );
		level.sdBomb maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_bomb" );
		level.sdBomb maps\mp\gametypes\_gameobjects::setVisibleTeam( "friendly" );
		level.sdBomb maps\mp\gametypes\_gameobjects::setCarryIcon( "hud_suitcase_bomb" );
		level.sdBomb.allowWeapons = true;
		level.sdBomb.onPickup = ::onPickup;
		level.sdBomb.onDrop = ::onDrop;
	}
	else
	{
		trigger delete();
		visuals[0] delete();
	}
	
	
	level.bombZones = [];
	
	bombZones = getEntArray( "bombzone", "targetname" );
	
	for ( index = 0; index < bombZones.size; index++ )
	{
		trigger = bombZones[index];
		visuals = getEntArray( bombZones[index].target, "targetname" );
		
		name = istring(trigger.script_label);
		PrecacheString( name );
		PrecacheString( istring("defuse"+trigger.script_label) );
		
		bombZone = maps\mp\gametypes\_gameobjects::createUseObject( game["defenders"], trigger, visuals, (0,0,64), name );
		bombZone maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
		bombZone maps\mp\gametypes\_gameobjects::setUseTime( level.plantTime );
		bombZone maps\mp\gametypes\_gameobjects::setUseText( &"MP_PLANTING_EXPLOSIVE" );
		bombZone maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
		if ( !level.multiBomb )
			bombZone maps\mp\gametypes\_gameobjects::setKeyObject( level.sdBomb );
		label = bombZone maps\mp\gametypes\_gameobjects::getLabel();
		bombZone.label = label;
		bombZone maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" + label );
		bombZone maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" + label );
		bombZone maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_target" + label );
		bombZone maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_target" + label );
		bombZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		bombZone.onBeginUse = ::onBeginUse;
		bombZone.onEndUse = ::onEndUse;
		bombZone.onUse = ::onUsePlantObject;
		bombZone.onCantUse = ::onCantUse;
		bombZone.useWeapon = "briefcase_bomb_mp";
		bombZone.visuals[0].killCamEnt = spawn( "script_model", bombZone.visuals[0].origin + (0,0,128) );
		if ( !level.multiBomb )
		bombZone.trigger SetInvisibleToAll();
		
		for ( i = 0; i < visuals.size; i++ )
		{
			if ( isDefined( visuals[i].script_exploder ) )
			{
				bombZone.exploderIndex = visuals[i].script_exploder;
				break;
			}
		}
		
		level.bombZones[level.bombZones.size] = bombZone;
		
		bombZone.bombDefuseTrig = getent( visuals[0].target, "targetname" );
		assert( isdefined( bombZone.bombDefuseTrig ) );
		bombZone.bombDefuseTrig.origin += (0,0,-10000);
		bombZone.bombDefuseTrig.label = label;
	}
	
	for ( index = 0; index < level.bombZones.size; index++ )
	{
		array = [];
		for ( otherindex = 0; otherindex < level.bombZones.size; otherindex++ )
		{
			if ( otherindex != index )
				array[ array.size ] = level.bombZones[otherindex];
		}
		level.bombZones[index].otherBombZones = array;
	}
}

onBeginUse( player )
{
	if ( self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		player playSound( "mpl_sd_bomb_defuse" );
		player.isDefusing = true;
		player thread maps\mp\gametypes\_battlechatter_mp::gametypeSpecificBattleChatter( "sd_enemyplant", player.pers["team"] );
		
		if ( isDefined( level.sdBombModel ) )
			level.sdBombModel hide();
	}
	else
	{
		player.isPlanting = true;
		player thread maps\mp\gametypes\_battlechatter_mp::gametypeSpecificBattleChatter( "sd_friendlyplant", player.pers["team"] );

		if ( level.multibomb )
		{
			for ( i = 0; i < self.otherBombZones.size; i++ )
			{
				self.otherBombZones[i] maps\mp\gametypes\_gameobjects::disableObject();
			}
		}
	}
		player playSound( "fly_bomb_raise_plr" );
}

onEndUse( team, player, result )
{
	if ( !IsDefined( player ) )
		return;
		
	player.isDefusing = false;
	player.isPlanting = false;
	player notify( "event_ended" );

	if ( self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		if ( isDefined( level.sdBombModel ) && !result )
		{
			level.sdBombModel show();
		}
	}
	else
	{
		if ( level.multibomb && !result )
		{
			for ( i = 0; i < self.otherBombZones.size; i++ )
			{
				self.otherBombZones[i] maps\mp\gametypes\_gameobjects::enableObject();
			}
		}
	}
}

onCantUse( player )
{
	player iPrintLnBold( &"MP_CANT_PLANT_WITHOUT_BOMB" );
}

onUsePlantObject( player )
{
	// planted the bomb
	if ( !self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		self maps\mp\gametypes\_gameobjects::setFlags( OBJECTIVE_FLAG_PLANTED );
		level thread bombPlanted( self, player );
		player logString( "bomb planted: " + self.label );
		
		// disable all bomb zones except this one
		for ( index = 0; index < level.bombZones.size; index++ )
		{
			if ( level.bombZones[index] == self )
				continue;
				
			level.bombZones[index] maps\mp\gametypes\_gameobjects::disableObject();
		}
		thread playSoundOnPlayers( "mus_sd_planted"+"_"+level.teamPostfix[player.pers["team"]] );
// removed plant audio until finalization of assest TODO : new plant sounds when assests are online		
//		player playSound( "mpl_sd_bomb_plant" );
		player notify ( "bomb_planted" );
		
		level thread maps\mp\_popups::DisplayTeamMessageToAll( &"MP_EXPLOSIVES_PLANTED_BY", player );

		if( isdefined(player.pers["plants"]) )
		{
			player.pers["plants"]++;
			player.plants = player.pers["plants"];
		}

		maps\mp\_demo::bookmark( "event", gettime(), player );
		player AddPlayerStatWithGameType( "PLANTS", 1 );
		
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "bomb_planted" );

		maps\mp\_scoreevents::processScoreEvent( "planted_bomb", player );
		player recordgameevent("plant");
	}
}

onUseDefuseObject( player )
{
	wait .05;
	
	self maps\mp\gametypes\_gameobjects::setFlags( OBJECTIVE_FLAG_DEFUSED );
	player notify ( "bomb_defused" );
	player logString( "bomb defused: " + self.label );
	bbPrint( "mpobjective", "gametime %d objtype %s label %s team %s", gettime(), "sd_bombdefuse", self.label, player.pers["team"] );
	level thread bombDefused();
	
	// disable this bomb zone
	self maps\mp\gametypes\_gameobjects::disableObject();
	
	level thread maps\mp\_popups::DisplayTeamMessageToAll( &"MP_EXPLOSIVES_DEFUSED_BY", player );

	if( isdefined(player.pers["defuses"]) )
	{
		player.pers["defuses"]++;
		player.defuses = player.pers["defuses"];
	}

	player AddPlayerStatWithGameType( "DEFUSES", 1 );
	maps\mp\_demo::bookmark( "event", gettime(), player );
	
	maps\mp\gametypes\_globallogic_audio::leaderDialog( "bomb_defused" );

	if ( isdefined( player.lastManSD ) && player.lastManSD == true )
	{
		maps\mp\_scoreevents::processScoreEvent( "defused_bomb_last_man_alive", player, undefined, undefined, true );
	}
	else
	{
		maps\mp\_scoreevents::processScoreEvent( "defused_bomb", player, undefined, undefined, true );
	}
	player recordgameevent("defuse");
}


onDrop( player )
{
	if ( !level.bombPlanted )
	{
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "bomb_lost", player.pers["team"] );
		if ( isDefined( player ) )
		 	player logString( "bomb dropped" );
		 else
		 	logString( "bomb dropped" );
	}

	player notify( "event_ended" );

	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_bomb" );
	
	maps\mp\_utility::playSoundOnPlayers( game["bomb_dropped_sound"], game["attackers"] );
}


onPickup( player )
{
	player.isBombCarrier = true;

	player recordgameevent("pickup"); 

	self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" );

	if ( !level.bombDefused )
	{
		if ( isDefined( player ) && isDefined( player.name ) )
		{
			player AddPlayerStatWithGameType( "PICKUPS", 1 );
		}
			
		//thread playSoundOnPlayers( "mus_sd_pickup"+"_"+level.teamPostfix[player.pers["team"]], player.pers["team"] );
		// New Music System
		team = self maps\mp\gametypes\_gameobjects::getOwnerTeam();
		otherTeam = getOtherTeam( team );
		thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "CTF_THEY_TAKE", otherTeam, false, false );
		thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "CTF_WE_TAKE", team, false, false );
		
		maps\mp\gametypes\_globallogic_audio::leaderDialog( "bomb_acquired", player.pers["team"] );
		player logString( "bomb taken" );
	}		
	maps\mp\_utility::playSoundOnPlayers( game["bomb_recovered_sound"], game["attackers"] );

	for ( i = 0; i < level.bombZones.size; i++ )
	{
		level.bombZones[i].trigger SetInvisibleToAll();
		level.bombZones[i].trigger SetVisibleToPlayer( player );
	}
}


onReset()
{

}

bombPlantedMusicDelay()
{
	level endon ("bomb_defused");
	//wait for 30 seconds until explosion
	
	time = (level.bombtimer - 30);
/#
	if( GetDvarint( "debug_music" ) > 0 )
	{		
		println ("Music System - waiting to set TIME_OUT: " + time );
	}
#/
	if (time > 1)
	{
		wait (time);
		thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "TIME_OUT", "both" );	
	}
}	

bombPlanted( destroyedObj, player )
{
	maps\mp\gametypes\_globallogic_utils::pauseTimer();
	level.bombPlanted = true;
	team = player.pers["team"];
	
	destroyedObj.visuals[0] thread maps\mp\gametypes\_globallogic_utils::playTickingSound( "mpl_sab_ui_suitcasebomb_timer" );
	//Play suspense music
	level thread bombPlantedMusicDelay();

	//thread maps\mp\gametypes\_globallogic_audio::actionMusicSet();					
	
	level.tickingObject = destroyedObj.visuals[0];

	level.timeLimitOverride = true;
	setGameEndTime( int( gettime() + (level.bombTimer * 1000) ) );
	
	label = destroyedObj maps\mp\gametypes\_gameobjects::getLabel();
	SetMatchFlag( "bomb_timer"+label, 1 );
	if ( label == "_a" )
	{
		SetBombTimer( "A", int( gettime() + level.bombTimer * 1000 ) );
	}
	else
	{
		SetBombTimer( "B", int( gettime() + level.bombTimer * 1000 ) );
	}
	
	bbPrint( "mpobjective", "gametime %d objtype %s label %s team %s", gettime(), "sd_bombplant", label, team );

	if ( !level.multiBomb )
	{
		level.sdBomb maps\mp\gametypes\_gameobjects::allowCarry( "none" );
		level.sdBomb maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
		level.sdBomb maps\mp\gametypes\_gameobjects::setDropped();
		level.sdBombModel = level.sdBomb.visuals[0];
	}
	else
	{
		
		for ( index = 0; index < level.players.size; index++ )
		{
			if ( isDefined( level.players[index].carryIcon ) )
				level.players[index].carryIcon destroyElem();
		}

		trace = bulletTrace( player.origin + (0,0,20), player.origin - (0,0,2000), false, player );
		
		tempAngle = randomfloat( 360 );
		forward = (cos( tempAngle ), sin( tempAngle ), 0);
		forward = vectornormalize( forward - VectorScale( trace["normal"], vectordot( forward, trace["normal"] ) ) );
		dropAngles = vectortoangles( forward );
		
		level.sdBombModel = spawn( "script_model", trace["position"] );
		level.sdBombModel.angles = dropAngles;
		level.sdBombModel setModel( "prop_suitcase_bomb" );
	}
	destroyedObj maps\mp\gametypes\_gameobjects::allowUse( "none" );
	destroyedObj maps\mp\gametypes\_gameobjects::setVisibleTeam( "none" );
	/*
	destroyedObj maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", undefined );
	destroyedObj maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", undefined );
	destroyedObj maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", undefined );
	destroyedObj maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", undefined );
	*/
	label = destroyedObj maps\mp\gametypes\_gameobjects::getLabel();
	
	// create a new object to defuse with.
	trigger = destroyedObj.bombDefuseTrig;
	trigger.origin = level.sdBombModel.origin;
	visuals = [];
	defuseObject = maps\mp\gametypes\_gameobjects::createUseObject( game["defenders"], trigger, visuals, (0,0,32), istring("defuse"+label) );
	defuseObject maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
	defuseObject maps\mp\gametypes\_gameobjects::setUseTime( level.defuseTime );
	defuseObject maps\mp\gametypes\_gameobjects::setUseText( &"MP_DEFUSING_EXPLOSIVE" );
	defuseObject maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
	defuseObject maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
	defuseObject maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defuse" + label );
	defuseObject maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_defend" + label );
	defuseObject maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defuse" + label );
	defuseObject maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_defend" + label );
	defuseObject maps\mp\gametypes\_gameobjects::setFlags( OBJECTIVE_FLAG_PLANTED );
	defuseObject.label = label;
	defuseObject.onBeginUse = ::onBeginUse;
	defuseObject.onEndUse = ::onEndUse;
	defuseObject.onUse = ::onUseDefuseObject;
	defuseObject.useWeapon = "briefcase_bomb_defuse_mp";
	
	player.isBombCarrier = false;
	
	BombTimerWait();
	SetBombTimer( "A", 0 );
	SetBombTimer( "B", 0 );
	SetMatchFlag( "bomb_timer_a", 0 );
	SetMatchFlag( "bomb_timer_b", 0 );
	
	destroyedObj.visuals[0] maps\mp\gametypes\_globallogic_utils::stopTickingSound();
	
	if ( level.gameEnded || level.bombDefused )
		return;
	
	level.bombExploded = true;
	
	bbPrint( "mpobjective", "gametime %d objtype %s label %s team %s", gettime(), "sd_bombexplode", label, team );
	
	explosionOrigin = level.sdBombModel.origin+(0,0,12);
	level.sdBombModel hide();
	
	if ( isdefined( player ) )
	{
		destroyedObj.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20, player, "MOD_EXPLOSIVE", "briefcase_bomb_mp" );
		level thread maps\mp\_popups::DisplayTeamMessageToAll( &"MP_EXPLOSIVES_BLOWUP_BY", player );
		maps\mp\_scoreevents::processScoreEvent( "bomb_detonated", player );
		player AddPlayerStatWithGameType( "DESTRUCTIONS", 1 );
		player recordgameevent("destroy");
	}
	else
		destroyedObj.visuals[0] radiusDamage( explosionOrigin, 512, 200, 20, undefined, "MOD_EXPLOSIVE", "briefcase_bomb_mp" );
	
	rot = randomfloat(360);
	explosionEffect = spawnFx( level._effect["bombexplosion"], explosionOrigin + (0,0,50), (0,0,1), (cos(rot),sin(rot),0) );
	triggerFx( explosionEffect );
	
	thread playSoundinSpace( "mpl_sd_exp_suitcase_bomb_main", explosionOrigin );
	//thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "SILENT", "both" );	
	
	if ( isDefined( destroyedObj.exploderIndex ) )
		exploder( destroyedObj.exploderIndex );
	
	for ( index = 0; index < level.bombZones.size; index++ )
		level.bombZones[index] maps\mp\gametypes\_gameobjects::disableObject();
	defuseObject maps\mp\gametypes\_gameobjects::disableObject();
	
	setGameEndTime( 0 );
	
	wait 3;
	
	sd_endGame( game["attackers"], game["strings"]["target_destroyed"] );
}

BombTimerWait()
{
	level endon("game_ended");
	level endon("bomb_defused");
	maps\mp\gametypes\_hostmigration::waitLongDurationWithGameEndTimeUpdate( level.bombTimer );
}

bombDefused()
{
	level.tickingObject maps\mp\gametypes\_globallogic_utils::stopTickingSound();
	level.bombDefused = true;
	SetBombTimer( "A", 0 );
	SetBombTimer( "B", 0 );
	SetMatchFlag( "bomb_timer_a", 0 );
	SetMatchFlag( "bomb_timer_b", 0 );
	
	level notify("bomb_defused");
	thread maps\mp\gametypes\_globallogic_audio::set_music_on_team( "SILENT", "both" );		
	
	wait 1.5;
	
	setGameEndTime( 0 );
	
	sd_endGame( game["defenders"], game["strings"]["bomb_defused"] );
}

sd_isKillBoosting()
{
	roundsPlayed = maps\mp\_utility::getRoundsPlayed();

	if ( level.playerKillsMax == 0 )
		return false;
		
	if ( game["totalKills"] > ( level.totalKillsMax * (roundsPlayed + 1) ) )
		return true;
		
	if ( self.kills > ( level.playerKillsMax * (roundsPlayed + 1)) )
		return true;
		
	if ( level.teambased && (self.team == "allies" || self.team == "axis" ))
	{
		if ( game["totalKillsTeam"][self.team] > ( level.playerKillsMax * (roundsPlayed + 1)) )
			return true;
	}
	
	return false;
}

