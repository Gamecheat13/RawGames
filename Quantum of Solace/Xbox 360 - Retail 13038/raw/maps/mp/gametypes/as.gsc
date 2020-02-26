#include maps\mp\_utility;
#include maps\mp\gametypes\_hud_util;
/*
	Assassination
	Objective: 	Score points by eliminating other players or by staying alive as the VIP.  Kill the VIP to become the VIP.
				The VIP is armed with the "Golden Gun"
	Map ends:	When one player reaches the score limit, or time limit is reached.
	Respawning:	No wait / Away from other players

	Level requirements
	------------------
		Spawnpoints:
			classname		mp_dm_spawn
			All players spawn from these. The spawnpoint chosen is dependent on the current locations of enemies at the time of spawn.
			Players generally spawn away from enemies.

		Spectator Spawnpoints:
			classname		mp_global_intermission
			Spectators spawn from these and intermission is viewed from these positions.
			Atleast one is required, any more and they are randomly chosen between.

	Level script requirements
	-------------------------

	Optional level script settings
	------------------------------
*/

main()
{
	println("************************************************");
	println("*********** WELCOME TO ASSASSINATION ***********");
	println("************************************************");

	level.team_bond = "allies";
	level.team_terrorists = "axis";

	level.golden_gun_weapon = "golden_gun_mp_exp";
	level.golden_gun_model = "w_t_golden_gun";
	level.golden_gun_icon_head = "mp_golden_gun_hud";
	level.golden_gun_icon_compass = "compass_point_golden";
	level.golden_gun_fx = loadfx( "misc/surface_aware_metal" );
	level.golden_gun_glow = loadfx( "misc/action_awareness" );

	maps\mp\gametypes\_globallogic::init();
	maps\mp\gametypes\_callbacksetup::SetupCallbacks();
	maps\mp\gametypes\_globallogic::SetupCallbacks();

	maps\mp\gametypes\_globallogic::registerTimeLimitDvar( level.gameType, 8, 0, 1440 );
	maps\mp\gametypes\_globallogic::registerScoreLimitDvar( level.gameType, 100, 0, 500 );
	maps\mp\gametypes\_globallogic::registerRoundLimitDvar( level.gameType, 1, 0, 10 );
	maps\mp\gametypes\_globallogic::registerNumLivesDvar( level.gameType, 0, 0, 10 );

	thread updateGametypeDvars();

	level.useRoundLimitAsWinsPerTeam = false;

	level.onStartGameType = ::onStartGameType;
	level.onSpawnPlayer = ::onSpawnPlayer;
	level.onDeathOccurred = ::onDeathOccurred;
	level.onPlayerDisconnect = ::onPlayerDisconnect;
	//level.overrideTeam = ::overrideTeam;

	level.onPlayerScore = ::onPlayerScore;
	
	precacheHeadIcon( level.golden_gun_icon_head );
	precacheShader( level.golden_gun_icon_compass );
	precacheShellshock("flashbang");
	
	level.pointMultiplier = 10;
	
	maps\mp\gametypes\_globallogic::findMapCenter();
}


onStartGameType()
{
	setClientNameMode("auto_change");

	maps\mp\gametypes\_globallogic::setObjectiveText( level.team_bond, &"OBJECTIVES_AS" );
	maps\mp\gametypes\_globallogic::setObjectiveText( level.team_terrorists, &"OBJECTIVES_AS" );

	maps\mp\gametypes\_globallogic::setObjectiveMenuText( level.team_bond, "OBJECTIVES_AS" );
	maps\mp\gametypes\_globallogic::setObjectiveMenuText( level.team_terrorists, "OBJECTIVES_AS" );

	if ( level.splitscreen )
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( level.team_bond, &"OBJECTIVES_AS" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( level.team_terrorists, &"OBJECTIVES_AS" );
	}
	else
	{
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( level.team_bond, &"OBJECTIVES_AS_SCORE" );
		maps\mp\gametypes\_globallogic::setObjectiveScoreText( level.team_terrorists, &"OBJECTIVES_AS_SCORE" );
	}
	maps\mp\gametypes\_globallogic::setObjectiveHintText( level.team_bond, &"OBJECTIVES_AS_HINT" );
	maps\mp\gametypes\_globallogic::setObjectiveHintText( level.team_terrorists, &"OBJECTIVES_AS_HINT" );

	level.spawnMins = ( 0, 0, 0 );
	level.spawnMaxs = ( 0, 0, 0 );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( level.team_bond, "mp_dm_spawn" );
	maps\mp\gametypes\_spawnlogic::addSpawnPoints( level.team_terrorists, "mp_dm_spawn" );

	level.spawnpoints = getentarray("mp_dm_spawn", "classname");

	allowed[0] = "as";
	maps\mp\gametypes\_gameobjects::main(allowed);

	level.QuickMessageToAll = true;

	// golden gun
	trigger = getEnt( "as_golden_gun_pickup", "targetname" );
	if ( !isDefined( trigger ) )
	{
		maps\mp\_utility::error("Map does not appear to be setup for Assassination. No as_golden_gun_pickup trigger found in map.");
		return;
	}

	visuals[0] = spawn( "script_model", trigger.origin );
	visuals[0].angles = trigger.angles;
	visuals[0] setModel( level.golden_gun_model );

	level.golden_gun = maps\mp\gametypes\_gameobjects::createCarryObject( "any", trigger, visuals, false );

	level.golden_gun maps\mp\gametypes\_gameobjects::allowCarry( "any" );
	level.golden_gun maps\mp\gametypes\_gameobjects::setVisibleTeam( "friendly" );
	level.golden_gun maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.golden_gun_icon_compass );
	level.golden_gun maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.golden_gun_icon_compass );
	
	level.golden_gun maps\mp\gametypes\_gameobjects::enableObject();

	level.golden_gun.allowWeapons = true;
	level.golden_gun.onPickup = ::onGoldenGunPickup;
	level.golden_gun.onDrop = ::onGoldenGunDrop;

	level thread dropped_fx( trigger.origin );
}


onSpawnPlayer()
{
	spawnPoints = maps\mp\gametypes\_spawnlogic::getTeamSpawnPoints( self.pers["team"] );
	spawnPoint = maps\mp\gametypes\_spawnlogic::getSpawnpoint_DM( spawnPoints );

	self spawn( spawnPoint.origin, spawnPoint.angles );
	self.dropWeaponOnDeath = false;

	self.headicon = "";
}


onPlayerScore( event, player, victim, sMeansOfDeath )
{
	if ( event == "golden_gun_pickup" )
	{
		player.pers["score"] += dvarIntValue( "points_golden_gun_pickup" );
	}
	else if ( event == "kill" )
	{
		vip = getVipPlayer();

		if ( IsDefined( vip ) && player == vip )
		{
			// vip kills player
			player.pers["score"] += dvarIntValue( "points_vip_kill" );
			player maps\mp\gametypes\_persistence_util::statAdd( "stats", "GOLDEN_GUN_KILLS", 1 );

			player playlocalsound( "goldengun_kill" );

			numGoldenGunKills = player maps\mp\gametypes\_persistence_util::statGet( "stats", "GOLDEN_GUN_KILLS" );
			println( "numGoldenGunKills = " + numGoldenGunKills );
				
			if( numGoldenGunKills >= 100 )
			{
				println( "giving achievement: 100_GOLDEN_GUN_KILLS" );
				player giveAchievement( "100_GOLDEN_GUN_KILLS" );
			}
		}
		else if ( IsDefined( vip ) && victim == vip )
		{
			// player kills vip player
			player.pers["score"] += dvarIntValue( "points_vip_death" );
		}
		else
		{
			// player kills non-vip player
			player.pers["score"] += dvarIntValue( "points_player_kill" );
		}
	}
}


onPlayerDisconnect()
{
	vip = getVipPlayer();
	
	if( IsDefined( vip ) && self == vip )
	{
		playSoundOnPlayers( "Tann_MP_41" );
		level.golden_gun maps\mp\gametypes\_gameobjects::returnHome();
		level thread dropped_fx( level.golden_gun.curOrigin );
	}
}


onGoldenGunDrop( player )
{
	assert( IsDefined( player ) );
	assert( IsDefined( player.name ) );

	iPrintLn( player, &"MPUI_DROPPED_GOLDEN_GUN" );
	player.sessionteam = "none";
	player.headicon = "";
	player playlocalsound( "goldengun_drop" );

	// hide carry object while the gun is falling to the ground
	level.golden_gun.visuals[0] hide();
	//level.golden_gun maps\mp\gametypes\_gameobjects::disableObject();

	assert( IsDefined( level.dropped ) );
	level.dropped waittill( "movedone" );

	// gun is on the ground, orient and show the carry object
	//level.golden_gun maps\mp\gametypes\_gameobjects::enableObject();

//	level.golden_gun maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", level.golden_gun_icon_compass );
//	level.golden_gun maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", level.golden_gun_icon_compass );

	level.golden_gun.visuals[0].origin = level.dropped.origin;
	level.golden_gun.visuals[0].angles = level.dropped.angles;
	level.golden_gun.trigger.origin = level.dropped.origin;
	
	level thread dropped_fx( level.dropped.origin );

	level.dropped delete();
	level.dropped = undefined;

	level.golden_gun.visuals[0] show();

	level thread doGoldenGunRespawn();
}

onGoldenGunPickup( player )
{
	assert( IsDefined( player ) );
	assert( IsDefined( player.name ) );

	iPrintLn( player, &"MPUI_GOTTA_GOLDEN_GUN" );
	player.sessionteam = level.team_terrorists;

//	level.golden_gun maps\mp\gametypes\_gameobjects::set2DIcon( "friendly", undefined );
//	level.golden_gun maps\mp\gametypes\_gameobjects::set2DIcon( "enemy", undefined );

	player.headicon = level.golden_gun_icon_head;
	
	maps\mp\gametypes\_globallogic::givePlayerScore( "golden_gun_pickup", player, undefined, undefined );

	player playlocalsound( "pickup_goldengun" );
	player giveGoldenGun();

	for (i = 0; i < level.players.size; i++)
	{
		if ( !isdefined( level.players[i] ) )
			continue;
		flashplayer = level.players[i];

		if ( flashplayer == player )
			continue;

		if ( flashplayer.sessionstate != "playing" )
			continue;

		dist = distance( flashplayer.origin, player.origin );

		if ( dist > 768 )
			continue;

		forwardvec = anglestoforward( flashplayer.angles );
		normalvec = vectorNormalize( player.origin - flashplayer.origin );
		vecdot = vectordot(forwardvec,normalvec);
		if (vecdot < cos(45))	//it's within the players FOV so try a trace now
			continue;
					
		losExists = bullettracepassed(flashplayer.origin + (0,0,50), player.origin + (0,0,50), false, undefined);
		if ( !losExists )
			continue;

		flashplayer shellshock( "flashbang", 2.5 );
		flashplayer playlocalsound( "explo_grenade_flashbang" );
	}

	level notify( "golden_gun_pickup" );
}

doGoldenGunRespawn()
{
	level endon( "golden_gun_pickup" );

	seconds = dvarIntValue( "seconds_golden_gun_respawn" );

	if ( seconds <= 0 )
	{
		return;
	}

	wait( seconds );

	level notify( "golden_gun_respawn" );

	level.golden_gun maps\mp\gametypes\_gameobjects::returnHome();
	level thread dropped_fx( level.golden_gun.curOrigin );

	playSoundOnPlayers( "Tann_MP_41" );
	playSoundOnPlayers( "goldengun_respawn" );
}

onDeathOccurred( victim, attacker )
{
	vip = getVipPlayer();
	
	if ( IsDefined( vip ) && vip == victim )
	{
		// vip died
		assert( !IsDefined( level.dropped ) );
		level.dropped = self dropItem( level.golden_gun_weapon );
		assert( IsDefined( level.dropped ) );
	}
	else if ( IsDefined( vip ) && vip == attacker )
	{
		// vip killed someone
	}
	else
	{
		// player killed another player
	}
}

overrideTeam()
{
	// assign team randomly
	if( randomInt( 2 ) == 0 )
	{
		self.pers["team"] = level.team_bond;
		self.pers["class"] = "bond";
		self.pers["skin"] = "SKIN_HERO_ONE";
		self setPlayerType( 1 );	// default_mp
	}
	else
	{
		self.pers["team"] = level.team_terrorists;
		self.pers["class"] = "terrorist";
		self.pers["skin"] = "SKIN_GENERIC_ONE";
		self setPlayerType( 1 );	// default_mp
	}
}

updateGametypeDvars()
{
	// player kills non-vip player
	dvarIntValue( "points_player_kill", 1 );

	// player kills rival player
	//dvarIntValue( "points_rival_kill", 0 );

	// vip kills player
	dvarIntValue( "points_vip_kill", 6 );

	// player kills vip player
	dvarIntValue( "points_vip_death", 2 );

	// points for picking up the golden gun
	dvarIntValue( "points_golden_gun_pickup", 1 );

	// number of seconds until the golden gun respawns
	dvarIntValue( "seconds_golden_gun_respawn", 20 );
}

giveGoldenGun()
{
	assert( IsPlayer( self ) );
	assert( IsAlive( self ) );

	self TakeAllWeapons();

	self GiveWeapon( level.golden_gun_weapon );
	self GiveMaxAmmo( level.golden_gun_weapon );

	self SwitchToWeapon( level.golden_gun_weapon );

	self.pers["weapon"] = level.golden_gun_weapon;
}

getVipPlayer()
{
	if ( IsDefined( level.golden_gun.carrier ) )
	{
		players = getentarray( "player", "classname" );

		for ( i = 0; i < players.size; i++ )
		{
			if ( level.golden_gun.carrier == players[i] )
			{
				return players[i];
			}
		}
	}

	return undefined;
}

dropped_fx( origin )
{
	level endon( "golden_gun_pickup" );
	level endon( "golden_gun_respawn" );
	
	// one time fx
	playfx( level.golden_gun_fx, origin );

	for (;;)
	{
		wait( 2.5 );
		playfx( level.golden_gun_glow, origin );
	}
	
}
