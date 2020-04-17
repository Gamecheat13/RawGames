#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;

/*
	Bond Versus
	Bond's objective:	    Take out the terrorists
	Terrorists' objective:	Take out Bond
	Round ends:				After 2 minutes
	Map ends:				When everyone has had a chance to be Bond
	Respawning:				Yes

	Level requirements
	------------------
		Bond Spawnpoints:
			classname				mp_vs_spawn_bond
			Place at least 16 of these scattered around the perimeter of the map.

		Terrorist Operative Spawnpoints:
			classname				mp_vs_spawn_terrorist
			Place at least 16 of these relatively close together, in and around the enemy "base".

		Spectator Spawnpoints:
			classname				mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			At least one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------
		Team Definitions:
			game["allies"] = "bond";
			game["axis"] = "terrorists";
			This sets the nationalities of the teams. Allies can be american, british, or russian. Axis can be german.

		If using minefields or exploders:
			maps\mp\_load::main();

*/

/*QUAKED mp_vs_spawn_bond_start (0.0 0.0 0.5) (-16 -16 0) (16 16 72)
Bond spawns randomly at one of these positions at the beginning of a round.*/

/*QUAKED mp_vs_spawn_bond (0.0 0.0 0.5) (-16 -16 0) (16 16 72)
Bond spawns his second life as far from terrorists as possible, and out of line of sight if possible. */

/*QUAKED mp_vs_spawn_terrorist (0.5 0.0 0.0) (-16 -16 0) (16 16 72)
Terrorists spawn randomly at one of these positions at the beginning of a round.*/



main()
{
	precacheShader( "compassping_death" );

	println("************************************************");
	println("*********** WELCOME TO BOND VS *****************");
	println("************************************************");

	level.team_bond = "allies";
	level.team_terrorists = "axis";

	if( !isdefined(game["bond_count"]) )
	{
		game["bond_count"] = [];
	}

	if(getdvar("mapname") == "mp_background")
		return;

	level.points = [];
	level.points["terrorists_detonate_bomb"] = 5;
	level.points["bond_defuses_bomb"] = 10;
	level.points["bond_prevented_bomb"] = 10;

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gametype, 5, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gametype, 3, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gametype, 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerMinPlayersDvar( level.gametype, 2, 2, 8 );
	// No score limit
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gametype, 0, 0, 0 );

	// setDvar("scr_player_respawndelay",10);

	level.teamBased = true;
	level.doPrematch = true;
	level.overrideTeamScore = true;
	level.doClass = true;
	level.doHero = false;
	level.roundEndDelay = 7;
	level.roundLimit = 0;
	level.allowClassChange = true;
	level.useRoundLimitAsWinsPerTeam = false;

	level.overrideTeam = ::overrideTeam;

	level.onPrecacheGameType = ::onPrecacheGameType;
	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onPlayerDisconnect = ::onPlayerDisconnect;
	level.onTimeLimit = ::onTimeLimit;
	level.onDeadEvent = ::onDeadEvent;
	level.onPlayerKilled = ::onPlayerKilled;
	
	level.pointMultiplier = 25;

	maps\mp\gametypes\_globallogic::findMapCenter();

	// force the game closed to players trying to join the lobby
	/*
	if ( level.xboxlive )
		setdvar( "xblive_rankedmatch", 1 );
	*/
}

onPrecacheGameType()
{
	precacheShader("mp_icon_bomb_1");
	precacheShader("mp_icon_bomb_2");
	precacheShader("mp_icon_bomb_3");
	precacheShader("mp_icon_waypoint_defend_1");
	precacheShader("mp_icon_waypoint_defend_2");
	precacheShader("mp_icon_waypoint_defend_3");
	
	precacheShader("compass_point_num_1");
	precacheShader("compass_point_num_2");
	precacheShader("compass_point_num_3");
	//precacheShader("compass_point_mi6");

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
	precacheString(&"MP_ALLIES_BOMB_DEFUSED");
	precacheString(&"MPUI_BOND_LEFT");
	precacheString(&"MPUI_ONELIFE_BOND");
	precacheString(&"MPUI_ONELIFE_ORGANIZATION");
	precacheString(&"MPUI_LIVES_BOND");
	precacheString(&"MPUI_LIVES_ORGANIZATION");
	precacheString(&"MPUI_BOND_NO_SHOW");
	precacheString(&"MPUI_BOND_DEFUSE");

}

onStartGameType()
{
	game["allies"] = "bond";
	game["axis"] = "terrorists";

	setClientNameMode( "manual_change");

	level._effect["bombexplosion"] = loadfx("props/barrelexp");

	level.bond_lives = getDvarInt("scr_vs_numlives_bond");

	maps\mp\gametypes\_globallogic::setObjectiveText( level.team_bond, &"OBJECTIVES_VS_BOND" );
	maps\mp\gametypes\_globallogic::setObjectiveText( level.team_terrorists, &"OBJECTIVES_VS_TERRORISTS" );

	maps\mp\gametypes\_globallogic::setObjectiveMenuText( level.team_bond, "OBJECTIVES_VS_BOND" );
	maps\mp\gametypes\_globallogic::setObjectiveMenuText( level.team_terrorists, "OBJECTIVES_VS_TERRORISTS" );

	maps\mp\gametypes\_globallogic::setObjectiveHintText( level.team_bond, &"OBJECTIVES_VS_BOND_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( level.team_terrorists, &"OBJECTIVES_VS_TERRORISTS_HINT" );


	spawn_bond = getentarray("mp_vs_spawn_bond", "classname");
	if(!spawn_bond.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	spawn_terrorist = getentarray("mp_vs_spawn_terrorist", "classname");
	if(!spawn_terrorist.size)
	{
		maps\mp\gametypes\_callbacksetup::AbortLevel();
		return;
	}

	level.spawnpoints = [];
	for(i = 0; i < spawn_bond.size; i++)
	{
		spawn_bond[i] placeSpawnpoint();
		level.spawnpoints[level.spawnpoints.size] = spawn_bond[i];
	}

	for(i = 0; i < spawn_terrorist.size; i++)
	{
		spawn_terrorist[i] placeSpawnpoint();
		level.spawnpoints[level.spawnpoints.size] = spawn_terrorist[i];
	}

	allowed[0] = "vs";
	maps\mp\gametypes\_gameobjects::main(allowed);

	updateGametypeDvars();

	thread bombs();
}


overrideTeam()
{
	if(!isdefined(game["roundsplayed"]))
		game["roundsplayed"] = 0;

	//println("&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&* Override Team: " + self.name);
	
	if( !isdefined(game["bond_count"][self.name]) )
	{
		//println("&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&* Creating bound count entry: " + self.name);
		game["bond_count"][self.name] = 0;
		setDvar(level.roundLimitDvar, game["bond_count"].size);
	}

//	if( game["roundsplayed"] > 0 && !isdefined(game["bond_count"][self.name]) )
//		self.canSpawn = false;

	if( (game["state"] == "playing" || game["state"] == "countdown") 
		&& !isDefined(level.player_bond) 
		&& isdefined(game["bond_count"][self.name]) 
		&& !game["bond_count"][self.name] )
	{
		//println("&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&* Becoming Bond: " + self.name);
		level.player_bond = self;
		self.pers["team"] = level.team_bond;
		self.pers["class"] = "bond";
		self.pers["lives"] = level.bond_lives;
		self.isBond = true;
		self.pers["skin"] = "SKIN_HERO_ONE";
		game["bond_count"][self.name]++;
		self setPlayerType(6);	// hero_balanced
		self setclientdvar( "cg_disableCustomLoadouts", 0 );
	}
	else
	{
		//println("&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&* Becoming Terrorist: " + self.name);
		self.pers["team"] = level.team_terrorists;
		self.pers["class"] = "terrorist";
		self.pers["lives"] = 1;
		self.pers["skin"] = "SKIN_GENERIC_ONE";
		self.isBond = false;
		self setPlayerType(1);	// default_mp
		self setclientdvar( "cg_disableCustomLoadouts", 1 );
	}

	self clearPerks();

	maps\mp\gametypes\_class::setClass( self.pers["class"] );
	
	self maps\mp\gametypes\_globallogic::getDefaultLoadout();
}


onPlayerKilled(eInflictor, attacker, iDamage, sMeansOfDeath, sWeapon, vDir, sHitLoc, psOffsetTime, deathAnimDuration)
{
	if( self.pers["team"] == level.team_bond )
	{
		// 5 points for killing bond... unless you ARE bond
		if( attacker != self && attacker.classname != "worldspawn" )
		{
			score = maps\mp\gametypes\_globallogic::_getPlayerScore( attacker );
			score += 5;
			maps\mp\gametypes\_globallogic::_setPlayerScore( attacker, score );
			attacker maps\mp\gametypes\_persistence_util::statAdd( "stats", "BOND_KILLS", 1 );
			attackerBondKills = attacker maps\mp\gametypes\_persistence_util::statGet( "stats", "BOND_KILLS" );
			//if( attackerBondKills >= 10 )
			//{
			//	attacker giveAchievement( "KILLED_BOND_10_TIMES" );
			//}
		}
		playSoundOnPlayers( "bondisdead" );
	
		if( level.bond_lives != 0 )
		{
			level.bond_lives--;
			if( !level.bond_lives )
			{
				onDeadEvent(level.team_bond);
			}
		}
	}
	else if( self.pers["team"] == level.team_terrorists )
	{
		checkTerroristsDead();
	}
}


checkTerroristsDead(disconnectedPlayer)
{
	alldead = true;
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if( player.pers["team"] != level.team_terrorists )
			continue;

		if( isDefined(disconnectedPlayer) && player == disconnectedPlayer )
			continue;

		if( player.sessionstate == "spectator" )
			continue;

		alldead = false;
	}

	if( alldead )
	{
		onDeadEvent(level.team_terrorists);
	}
}


lowerMessageAnnounce(message, time)
{
	self endon("disconnect");
	self setLowerMessage(message);
	wait(time);
	self setLowerMessage("");
}


onSpawnPlayer()
{
	if( self.pers["team"] == level.team_bond )
	{
		if ( level.useStartSpawns ) {
			spawnPointName = "mp_vs_spawn_bond_start";
			spawnPoints = getEntArray( spawnPointName, "classname" );
			assert( spawnPoints.size );
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
		}
		else
		{
			spawnPointName = "mp_vs_spawn_bond";
			spawnPoints = getEntArray( spawnPointName, "classname" );
			assert( spawnPoints.size );
			spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_BondVS( spawnPoints );
		}
		
		self playlocalsound( "youarebond" );
	}
	else
	{
		spawnPointName = "mp_vs_spawn_terrorist";
		spawnPoints = getEntArray( spawnPointName, "classname" );
		assert( spawnPoints.size );
		spawnpoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_Random( spawnPoints );
	}


	self spawn( spawnpoint.origin, spawnpoint.angles );

	if( self.pers["team"] == level.team_bond )
	{
		thread showBondLives();
	}

	if( self.pers["team"] == level.team_terrorists )
	{
		self.dropWeaponOnDeath = false;
	}
}


onPlayerDisconnect()
{
	// check to see if Bond left
	if( IsDefined( level.player_bond ) && self == level.player_bond )
	{
		//println("&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&* Bond Leaving: " + self.name);
		announcement( &"MPUI_BOND_LEFT" );
		thread [[level.endGame]]( level.team_terrorists );
	}
	// check if a terrorist left who hasn't been Bond
	else if( IsDefined( game["bond_count"][self.name] ) && game["bond_count"][self.name] == 0 ) 
	{
		//println("&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&*&* Person who hasn't been bond is leaving: " + self.name);
		assert( self.pers["team"] == level.team_terrorists );

		// remove this guy from our game count
		game["bond_count"][self.name] = undefined;
		setDvar(level.roundLimitDvar, game["bond_count"].size);
	}

	checkTerroristsDead(self);
}

showBondLives()
{
	maps\mp\gametypes\_cinematic::waitForCinematic(self.pers["team"]);

	if( level.bond_lives == 1 )
	{
		self thread lowerMessageAnnounce( &"MPUI_ONELIFE_BOND", 3 );
		printOnTeam( &"MPUI_ONELIFE_ORGANIZATION", level.team_terrorists );
	}
	else
	{
		self thread lowerMessageAnnounce( &"MPUI_LIVES_BOND", 3 );
		printOnTeam( &"MPUI_LIVES_ORGANIZATION", level.team_terrorists );
	}
}

bondCheck()
{
	players = getEntArray( "player", "classname" );
	if( players.size == 1 )
		return;

	// check that a bond has been spawned.  if there isn't, then the round is over 
	// because everyone else must have already been bond
	if( !isDefined(level.player_bond) )
	{
		announcement( &"MPUI_BOND_NO_SHOW" );
		thread [[level.endGame]]( level.team_terrorists );
	}
}


onDeadEvent( team )
{
	if ( team == "all" )
	{
	}
	else if ( team == level.team_bond )
	{
		setTeamScore( level.team_terrorists, getTeamScore( level.team_terrorists ) );

		//playSoundOnPlayers("BVS_Terr_WIN_KIL", level.team_terrorists);	// Someone's just become a very rich man.
		//playSoundOnPlayers("BVS_Brit_LOSE_LOS", level.team_bond);		// I expect better from a double O
		playSoundOnPlayers( "Tann_MP_23" );
		setdvar( "g_roundEndReason", "bondeliminated" );

		//announcement( game["strings"]["bond_eliminated"] );
		thread [[level.endGame]]( level.team_terrorists );
	}
	else if ( team == level.team_terrorists )
	{
		setTeamScore( level.team_bond, getTeamScore( level.team_bond ) );
		giveTeamPoints( level.team_bond, level.points["bond_prevented_bomb"] );

		//playSoundOnPlayers("BVS_Brit_WIN_KIL", level.team_bond);		// They're all dead?  Not an elegant solution, but I suppose I can't complain.
		//playSoundOnPlayers("BVS_Terr_LOSE_SCL", level.team_terrorists);	// I British agent?  That's what it takes to disarm an entire squad?  We need warriors, not idiots
		playSoundOnPlayers( "Tann_MP_22" );
		setdvar( "g_roundEndReason", "orgeliminated" );

		if( isDefined(level.player_bond) )
		{
			level.player_bond giveAchievement( "WIN_AS_BOND" );
		}

		//announcement( game["strings"]["terrorists_eliminated"] );
		thread [[level.endGame]]( level.team_bond );
	}
}

onTimeLimit()
{
	team = level.team_bond;
	if( !level.bombDefused )
	{
		team = level.team_terrorists;
		giveTeamPoints( team, level.points["terrorists_detonate_bomb"] );

		//bombZones = getEntArray( "vs_bombzone", "targetname" );
		//thread explodeBomb( ( bombZones[0].origin[0], bombZones[0].origin[1], bombZones[0].origin[2] + 80 ) );

		bombCamera = getEntArray( "vs_endcamera", "targetname" );
		bombExplosion = getEntArray( "vs_endexplosions", "targetname" );
		thread explodeBomb( ( bombCamera[0].origin[0], bombCamera[0].origin[1], bombCamera[0].origin[2] ) , ( bombExplosion[0].origin[0], bombExplosion[0].origin[1], bombExplosion[0].origin[2] ) );

		//playSoundOnPlayers("BVS_Brit_LOSE_BMB", level.team_bond);		// You took too long, James.  And now lives have been lost.
		//playSoundOnPlayers("BVS_Terr_WIN_BMB", level.team_terrorists);	// If MI6 didn’t know you before, they do now.
	}
	else
	{
		team = level.team_bond;
		giveTeamPoints( team, level.points["bond_defuses_bomb"] );
		announcement( &"MPUI_BOND_DEFUSE" );
	}

	setdvar( "g_roundEndReason", "timelimit" );
	level.onTimeLimit = maps\mp\gametypes\_globallogic::blank;
	//wait(3.0);

	thread [[level.endGame]]( team );
}

// explode bomb
explodeBomb( origin , explosion )
{
	bombCamera = getEntArray( "vs_endcamera", "targetname" );
		
	camera = spawn( "script_origin", origin );
	camera setbroadcast();

	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		players[i] setcamera( camera );
		players[i] playlocalsound( "bombexplode" );
	}

	//target = ( origin[0] + 250, origin[1], origin[2] + 500 );
	//angles = vectortoangles( origin - target );

	//camera moveto( target, 5, 0, 5/4 );
	camera.angles = bombCamera[0].angles;

	wait(0.7);

	for( i = 0; i < 10; i++ )
	{
		x = randomfloatrange( -200.0, 200.0 );
		y = randomfloatrange( -200.0, 200.0 );

		//position = ( origin[0] + x, origin[1] + y, origin[2] );
		position = ( explosion[0] + x, explosion[1] + y, explosion[2] );

		sound = spawn( "script_origin", position );
		sound playsound( "bomb_explode_mp_vs" );

		playfx( level._effect["bombexplosion"], position );
				
		wait( randomfloatrange( 0.3, 1.0 ) );

		sound delete();
	}

	//wait( 2 );

	/*players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		players[i] setcamera();
	}*/

}

updateGametypeDvars()
{
	level.plantTime = dvarFloatValue( "arming_time", 10, 0, 60 );
	level.defuseTime = dvarFloatValue( "disarm_time", 3, 0, 60 );
	
	// This is probably not being used?
	level.bombTimer = dvarFloatValue( "fuse_length", 30, 10, 300 );

	/#
	// force to 0 for the nightly playtests
	setDvar( "scr_player_respawndelay", 0 );
	#/
}

giveTeamPoints( team, points )
{
	players = getEntArray( "player", "classname" );
	for( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if( isDefined( player.pers["team"] ) && (player.pers["team"] == team) )
		{
			score = maps\mp\gametypes\_globallogic::_getPlayerScore( player );
			score += points;
			maps\mp\gametypes\_globallogic::_setPlayerScore( player, score );
		}
	}

	setTeamScore( team, getTeamScore(team) + points );
}

bombs()
{
	level.bombName = "bomb_mp";
	level.bombDefused = false;
	level.bombsDefused = 0;
	level.bombExploded = false;
	level.bombsExploded = 0;

	precacheItem(level.bombName);

	level.bombZones = [];

	bombZones = getEntArray( "vs_bombzone", "targetname" );

	targetnum = -1;

	for ( index = 0; index < bombZones.size; index++ )
	{
		trigger = bombZones[index];
		visuals[0] = getEnt( bombZones[index].target, "targetname" );

		bombZone = maps\mp\gametypes\_gameobjects::createUseObject( level.team_bond, trigger, visuals );

		bombZone maps\mp\gametypes\_gameobjects::allowUse( "friendly" );
		bombZone maps\mp\gametypes\_gameobjects::setUseTime( level.defuseTime );
		bombZone maps\mp\gametypes\_gameobjects::setUseText( &"MP_DEFUSING_EXPLOSIVE" );
		bombZone maps\mp\gametypes\_gameobjects::setUseHintText( &"PLATFORM_HOLD_TO_DEFUSE_EXPLOSIVES" );
		bombZone maps\mp\gametypes\_gameobjects::setKeyObject( undefined );
		label = bombZone maps\mp\gametypes\_gameobjects::getLabel();
		if ( label == "_A" ) {
			label = "1";
		} else if ( label == "_B" ) {
			label = "2";
		} else if ( label == "_C" ) {
			label = "3";
		}
		bombZone maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", "compass_point_num_" + label );
		bombZone maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", "compass_point_num_" + label );
		bombZone maps\mp\gametypes\_gameobjects::set3DIcon( "friendly", "mp_icon_bomb_" + label );
		bombZone maps\mp\gametypes\_gameobjects::set3DIcon( "enemy", "mp_icon_waypoint_defend_" + label );
		bombZone maps\mp\gametypes\_gameobjects::setVisibleTeam( "any" );

		bombZone.onUse = ::onUseBomb;
		bombZone.onCantUse = ::onCantUseBomb;
		bombZone.onBeginUse = ::onBeginUseBomb;
		bombZone.onEndUse = ::onEndUseBomb;
		bombZone.bombTarget = getEnt( visuals[0].target, "targetname" );
		bombZone.bomb = true;

		if ( targetnum != -1 && level.bombZones.size != targetnum )
		{
			bombZone[index] maps\mp\gametypes\_gameobjects::disableObject();
		}
		level.bombZones[level.bombZones.size] = bombZone;
	}
}

onCantUseBomb( player )
{
	player iPrintLnBold( &"MP_CANT_PLANT_WITHOUT_BOMB" );
}

onBeginUseBomb( player )
{
	// planting the bomb
	if ( !self maps\mp\gametypes\_gameobjects::isFriendlyTeam( player.pers["team"] ) )
	{
		player SetAnimScriptEvent("bombplant");
	}
	else // defusing the bomb
	{
		//player SetAnimScriptEvent("bombdefuse");
		player playlocalsound( "bombdefuse" );
	}
}

onEndUseBomb( player, result )
{
	//player ClearAnimScriptEvent();
}

onUseBomb( player )
{
	// disable this bomb zone
	self maps\mp\gametypes\_gameobjects::disableObject();

	iPrintLnBold( &"MP_EXPLOSIVES_DEFUSED_BY", player.name );
	player giveAchievement( "PLAYER_DEFUSED_BOMB" );

	playSoundOnPlayers( "bombdefuse_success" );
	playSoundOnPlayers( "Tann_MP_35" );

	giveTeamPoints( level.team_bond, level.points["bond_defuses_bomb"] );
	
	level thread bombDefused( self );
}

bombDefused( objects )
{
	level.bombsDefused++;
	if ( level.bombsDefused >= 2 )
	{
		level.bombDefused = true;

		//announcement( game["strings"][level.team_bond+"_bomb_defused"] );
		setdvar( "g_roundEndReason", "bombdefused" );
		level notify ("defused");

		//giveTeamPoints( level.team_bond, level.points["bond_defuses_bomb"] );

		//playSoundOnPlayers("BVS_Brit_WIN_DFS", level.team_bond);		// Ticklish business, defusing bombs.  I wasn't aware you were so good at it.
		//playSoundOnPlayers("BVS_Terr_LOSE_DFS", level.team_terrorists);	// You've failed! Bond has disarmed our bomb.

		if( isDefined(level.player_bond) )
		{
			level.player_bond giveAchievement( "WIN_AS_BOND" );
		}

		level thread [[level.endGame]]( level.team_bond );
	}
}
