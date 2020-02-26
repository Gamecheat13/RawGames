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
			game["axis"] = "opfor";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.

			game["attackers"] = "allies";
			game["defenders"] = "axis";
			This sets which team is attacking and which team is defending. Attackers plant the bombs. Defenders protect the targets.

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

		Exploder Effects:
			Setting script_noteworthy on a bombzone trigger to an exploder group can be used to trigger additional effects.
*/

/*QUAKED mp_sd_spawn_attacker (0.0 1.0 0.0) (-16 -16 0) (16 16 72)
Attacking players spawn randomly at one of these positions at the beginning of a round.*/

/*QUAKED mp_sd_spawn_defender (1.0 0.0 0.0) (-16 -16 0) (16 16 72)
Defending players spawn randomly at one of these positions at the beginning of a round.*/

main()
{
	if(getdvar("mapname") == "mp_background")
		return;
	
	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerRoundSwitchDvar( level.gameType, 3, 1, 9 );
	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 2, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 0, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 3, 0, 12 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 1, 0, 10 );

	level.teamBased = true;
	level.doPrematch = true;
	level.overrideTeamScore = true;
	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerKilled = ::onPlayerKilled;
	level.onDeadEvent = ::onDeadEvent;
	level.onOneLeftEvent = ::onOneLeftEvent;
	level.onTimeLimit = ::onTimeLimit;
}


onPrecacheGameType()
{
	game["bombmodelname"] = "mil_tntbomb_mp";
	game["bombmodelnameobj"] = "mil_tntbomb_mp";
	game["bomb_dropped_sound"] = "mp_war_objective_lost";
	game["bomb_recovered_sound"] = "mp_war_objective_taken";
	precacheModel(game["bombmodelname"]);
	precacheModel(game["bombmodelnameobj"]);

	precacheShader("waypoint_bomb");
	precacheShader("waypoint_bomb_headicon");
	precacheShader("inventory_tnt_large");
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

	precacheString( &"MP_THE_ENEMY" );
	precacheString( &"MP_YOUR_TEAM" );
	precacheString(&"MP_EXPLOSIVES_RECOVERED_BY");
	precacheString(&"MP_EXPLOSIVES_DROPPED_BY");
	precacheString(&"MP_EXPLOSIVES_PLANTED_BY");
	precacheString(&"MP_EXPLOSIVES_DEFUSED_BY");
	precacheString(&"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES");
	precacheString(&"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES");
	precacheString(&"MP_CANT_PLANT_WITHOUT_BOMB");	
	precacheString(&"MP_PLANTING_EXPLOSIVE");	
	precacheString(&"MP_DEFUSING_EXPLOSIVE");	
}


onStartGameType()
{
	setClientNameMode( "manual_change" );

	level._effect["bombexplosion"] = loadfx("props/barrelexp");

	if ( isDefined( game["alt_count"] ) )
	{
		if ( ( game["alt_count"] >= level.roundswitch ) && ( game["alt_count"] < level.roundswitch*2 ) )
		{
			game["last_attackers"] = game["attackers"];
			game["last_defenders"] = game["defenders"];
			game["attackers"] = game["last_defenders"];
			game["defenders"] = game["last_attackers"];
		}
	}
	else
		game["alt_count"] = 0;

	if ( game["alt_count"] == level.roundswitch*2 )
		game["alt_count"] = 1;
	else
		game["alt_count"]++;

	maps\mp\gametypes\_globallogic::setObjectiveText( game["attackers"], &"OBJECTIVES_SD_ATTACKER" );
	maps\mp\gametypes\_globallogic::setObjectiveText( game["defenders"], &"OBJECTIVES_SD_DEFENDER" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_SD_ATTACKER" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_SD_DEFENDER" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( game["attackers"], &"OBJECTIVES_SD_ATTACKER_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( game["defenders"], &"OBJECTIVES_SD_DEFENDER_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( game["attackers"], &"OBJECTIVES_SD_ATTACKER_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( game["defenders"], &"OBJECTIVES_SD_DEFENDER_HINT" );

	spawn_attacker = getentarray("mp_sd_spawn_attacker", "classname");
	if(!spawn_attacker.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	spawn_defender = getentarray("mp_sd_spawn_defender", "classname");
	if(!spawn_defender.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	level.spawnpoints = [];
	for(i = 0; i < spawn_attacker.size; i++)
	{
		spawn_attacker[i] placeSpawnpoint();
		level.spawnpoints[level.spawnpoints.size] = spawn_attacker[i];
	}

	for(i = 0; i < spawn_defender.size; i++)
	{
		spawn_defender[i] placeSpawnpoint();
		level.spawnpoints[level.spawnpoints.size] = spawn_defender[i];
	}

	allowed[0] = "sd";
	allowed[1] = "bombzone";
	allowed[2] = "blocker";
	maps\mp\gametypes\_gameobjects::main(allowed);

	thread updateGametypeDvars();

	thread bombs();
}


onSpawnPlayer()
{
	if(self.pers["team"] == game["attackers"])
		spawnPointName = "mp_sd_spawn_attacker";
	else
		spawnPointName = "mp_sd_spawn_defender";

	spawnPoints = getEntArray( spawnPointName, "classname" );
	assert( spawnPoints.size );
	spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );

	self spawn( spawnpoint.origin, spawnpoint.angles );

	level notify ( "spawned_player" );
}


onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	// if all attackers are dead and we're just waiting for the bomb to be defused
	if ( level.bombPlanted && self.pers["team"] == game["attackers"] && !level.aliveCount[self.pers["team"]] )
	{
		// all attackers are dead so let them spectate however they want
		level.spectateOverride[game["attackers"]].spectatefree = 1;
		level.spectateOverride[game["attackers"]].spectateenemy = 1;
		// and let the dead defenders watch their friends try to defuse
		level.spectateOverride[game["defenders"]].spectatefree = 1;
		
		maps\mp\gametypes\_spectating::updateSpectateSettings();
	}
}


onDeadEvent( team )
{
	if ( level.bombExploded )
		return;
		
	if ( team == "all" )
	{
		if ( level.bombPlanted )
		{
			announcement( game["strings"][game["attackers"]+"_mission_accomplished"] );
			thread [[level.endGame]]( game["attackers"] );
		}
		else
		{
			announcement( game["strings"][game["attackers"]+"_eliminated"] );
			thread [[level.endGame]]( game["defenders"] );
		}
	}
	else if ( team == game["attackers"] )
	{
		if ( level.bombPlanted )
			return;

		announcement( game["strings"][game["attackers"]+"_eliminated"] );
		thread [[level.endGame]]( game["defenders"] );
	}
	else if ( team == game["defenders"] )
	{
		announcement( game["strings"][game["attackers"]+"_mission_accomplished"] );
		thread [[level.endGame]]( game["attackers"] );
	}
}


onOneLeftEvent( team )
{
	if ( team == game["attackers"] )
		warnLastAttacker();
}


onTimeLimit()
{
	if ( level.teamBased )
	{
		announcement( game["strings"][game["defenders"]+"_mission_accomplished"] );
		thread [[level.endGame]]( game["defenders"] );
	}
	else
	{
		thread [[level.endGame]]( undefined );
	}
}


warnLastAttacker()
{
	if ( isDefined( level.warnedLastAttacker ) )
		return;
		
	level.warnedLastAttacker = true;

	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if( isDefined( player.pers["team"] ) && player.pers["team"] == game["attackers"] && isdefined(player.pers["class"]) )
		{
			if( player.sessionstate == "playing" && !player.afk )
				break;
		}
	}
	assert(i != players.size); // assert we found the last remaining player
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
		if (self.health != self.maxhealth)
			fullHealthTime = 0;
		else
			fullHealthTime += interval;
		
		wait interval;
		
		if (self.health == self.maxhealth && fullHealthTime >= 3)
			break;
	}
	
	self iprintlnbold(&"MP_YOU_ARE_THE_ONLY_REMAINING_PLAYER");
}


updateGametypeDvars()
{
	level.plantTime = dvarFloatValue( "planttime", 2.5, 0, 20 );
	level.defuseTime = dvarFloatValue( "defusetime", 5, 0, 20 );
	level.bombTimer = dvarFloatValue( "bombtimer", 45, 10, 300 );
	level.multiBomb = dvarIntValue( "multibomb", 0, 0, 1 );
}


bombs()
{
	level.bombPlanted = false;
	level.bombDefused = false;
	level.bombExploded = false;

	trigger = getEnt( "sd_bomb_pickup_trig", "targetname" );
	if ( !isDefined( trigger ) )
	{
		maps\mp\_utility::error("No sd_bomb_pickup_trig trigger found in map.");
		return;
	}
	
	visuals[0] = getEnt( "sd_bomb", "targetname" );
	if ( !isDefined( visuals[0] ) )
	{
		maps\mp\_utility::error("No sd_bomb script_model found in map.");
		return;
	}
	
	if ( !level.multiBomb )
	{
		level.sdBomb = maps\mp\gametypes\_gameobjects::createCarryObject( game["attackers"], trigger, visuals );
		level.sdBomb maps\mp\gametypes\_gameobjects::allowCarry( "friendly" );
		level.sdBomb maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_bomb" );
		//level.sdBomb maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_bomb" );
		level.sdBomb maps\mp\gametypes\_gameobjects::setVisibleTeam( "friendly" );
		level.sdBomb maps\mp\gametypes\_gameobjects::setCarryIcon( "inventory_tnt_large" );
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
		visuals[0] = getEnt( bombZones[index].target, "targetname" );
		
		bombZone = maps\mp\gametypes\_gameobjects::createUseObject( game["defenders"], trigger, visuals );
		bombZone maps\mp\gametypes\_gameobjects::allowUse( "enemy" );
		bombZone maps\mp\gametypes\_gameobjects::setUseTime( level.plantTime );
		bombZone maps\mp\gametypes\_gameobjects::setUseText( &"MP_PLANTING_EXPLOSIVE" );
		bombZone maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_PLANT_EXPLOSIVES" );
		if ( !level.multiBomb )
			bombZone maps\mp\gametypes\_gameobjects::setKeyObject( level.sdBomb );
		label = bombZone maps\mp\gametypes\_gameobjects::getLabel();
		bombZone maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defend" + label );
		bombZone maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defend" + label );
		bombZone maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_target" + label );
		bombZone maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_target" + label );
		bombZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );
		bombZone.onUse = ::onUse;
		bombZone.onCantUse = ::onCantUse;

		level.bombZones[level.bombZones.size] = bombZone;
	}
}

onCantUse( player )
{
	player iPrintLnBold( &"MP_CANT_PLANT_WITHOUT_BOMB" );
}

onUse( player )
{
	// planted the bomb
	if ( !self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		if ( !level.multiBomb )
			self.keyObject maps\mp\gametypes\_gameobjects::disableObject();
		self maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
		self maps\mp\gametypes\_gameobjects::setUseTime( level.defuseTime );
		self maps\mp\gametypes\_gameobjects::setUseText( &"MP_DEFUSING_EXPLOSIVE" );
		self maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
		self maps\mp\gametypes\_gameobjects::setKeyObject( undefined );
		label = self maps\mp\gametypes\_gameobjects::getLabel();
		self maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_waypoint_defuse" + label );
		self maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_waypoint_defend" + label );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "waypoint_defuse" + label );
		self maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "waypoint_defend" + label );
		
		// disable all bomb zones except this one
		for ( index = 0; index < level.bombZones.size; index++ )
		{
			if ( level.bombZones[index] == self )
				continue;
				
			level.bombZones[index] maps\mp\gametypes\_gameobjects::disableObject();
		}
		
		player playSound( "mp_bomb_plant" );
		iPrintLnBold( &"MP_EXPLOSIVES_PLANTED_BY", player.name );
		level thread bombPlanted( self.visuals );
	}
	else // defused the bomb
	{
		// disable this bomb zone
		self maps\mp\gametypes\_gameobjects::disableObject();
		
		iPrintLnBold( &"MP_EXPLOSIVES_DEFUSED_BY", player.name );
		level thread bombDefused( self.visuals );
	}
}


onDrop( player )
{
	if ( isDefined( player ) && isDefined( player.name ) )
		printOnTeamArg( &"MP_EXPLOSIVES_DROPPED_BY", game["attackers"], player.name );
	else
		printOnTeamArg( &"MP_EXPLOSIVES_DROPPED_BY", game["attackers"], &"YOUR_TEAM" );
	
	maps\mp\_utility::playSoundOnPlayers( game["bomb_dropped_sound"], game["attackers"] );
}


onPickup( player )
{
	if ( isDefined( player ) && isDefined( player.name ) )
		printOnTeamArg( &"MP_EXPLOSIVES_RECOVERED_BY", game["attackers"], player.name );
	else
		printOnTeamArg( &"MP_EXPLOSIVES_RECOVERED_BY", game["attackers"], &"YOUR_TEAM" );
		
	maps\mp\_utility::playSoundOnPlayers( game["bomb_recovered_sound"], game["attackers"] );
}


onReset()
{
}


bombPlanted( objects )
{
	level.timerStopped = true;
	level.bombPlanted = true;

	level.bombClock = createServerTimer( "default", 1.5 );
	level.bombClock setPoint( "TOP", undefined, 0, 28 );
	level.bombClock.color = (1,0,0);
	level.bombClock setTenthsTimer( level.bombTimer );

	objects[0] playLoopSound( "bomb_tick" );

	wait level.bombTimer;
	
	objects[0] stopLoopSound();

	if ( level.gameEnded )
		return;
		
	level.bombExploded = true;
	
	for ( index = 0; index < level.bombZones.size; index++ )
		level.bombZones[index] maps\mp\gametypes\_gameobjects::disableObject();

	/*
	// trigger exploder if it exists
	if(isdefined(level.bombexploder))
		maps\mp\_utility::exploder(level.bombexploder);

	// explode bomb
	origin = self getorigin();
	range = 500;
	maxdamage = 2000;
	mindamage = 1000;

	//playfx(level._effect["bombexplosion"], origin);
	//radiusDamage(origin, range, maxdamage, mindamage);
	
	level.nukeExplosionOrigin = self.origin;
	thread nukeEffects();
	

	level thread maps\mp\_utility::playSoundOnPlayers("mp_announcer_objdest");
	
	//&"MP_ALLIES_MISSION_ACCOMPLISHED"
	
	level thread [[level.endGame]]( game["attackers"] );
	*/
	announcement( game["strings"][game["attackers"]+"_mission_accomplished"] );
	level thread [[level.endGame]]( game["attackers"] );
}


bombDefused( objects )
{
	objects[0] stopLoopSound();
	level.bombDefused = true;

	if ( isDefined( level.bombClock ) )
		level.bombClock destroyElem();

	announcement( game["strings"][game["defenders"]+"_mission_accomplished"] );
	level thread [[level.endGame]]( game["defenders"] );
}


