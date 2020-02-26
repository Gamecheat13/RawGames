#include common_scripts\utility;
#include maps\mp\_utility;

#insert raw\maps\mp\bots\_bot.gsh;

init()
{
	level.bot_offline = !level.onlineGame;

	level.bot_primaries = [];
	level.bot_primaries[ level.bot_primaries.size ] = "xm8_dualoptic_mp";
	level.bot_primaries[ level.bot_primaries.size ] = "an94_steadyaim_mp";
	level.bot_primaries[ level.bot_primaries.size ] = "type95_reflex_mp";
	level.bot_primaries[ level.bot_primaries.size ] = "mk48_rangefinder_mp";
	level.bot_primaries[ level.bot_primaries.size ] = "lsat_fastads_mp";
	level.bot_primaries[ level.bot_primaries.size ] = "pdw57_grip_mp";
	level.bot_primaries[ level.bot_primaries.size ] = "evoskorpion_silencer_mp";
	level.bot_primaries[ level.bot_primaries.size ] = "svu_mp";
	level.bot_primaries[ level.bot_primaries.size ] = "saiga12_extclip_mp";
	level.bot_primaries[ level.bot_primaries.size ] = "870mcs_extbarrel_mp";
	
/# 
	level thread bot_system_devgui_think();
#/

	// bots have already been spawned (happens on round changes)
	if ( IsDefined( game[ "bots_spawned" ] ) )
	{
		return;
	}

	humans = GetDvarInt( "party_playerCount" );
	bot_friends = GetDvarInt( "bot_friends" );
	bot_enemies = GetDvarInt( "bot_enemies" );
	max_players = GetDvarInt( "party_maxPlayers" );
	isDedicatedBotSoak = GetDvarInt( "sv_botsoak" );

	if ( level.rankedMatch && bot_enemies && 0 == isDedicatedBotSoak )
	{
		bot_wait_for_host();
		bot_set_difficulty();
		bots = humans;
		
		if ( GetDvarInt( "party_autoteams" ) == 0 )
		{
			bots = 6;
			max_players = 12;
		}

		while( bots < max_players )
		{
			wait( 0.25 );
			bot = AddTestClient();

			if ( IsDefined( bot ) )
			{
				bot.pers[ "isBot" ] = true;
				bots++;

				bot thread bot_spawn_think( "allies" );
			}
		}

		game[ "bots_spawned" ] = 1;
		return;
	}
	else if ( level.rankedMatch )
	{
		return;
	}

	// all humans playing
	if ( humans >= max_players )
	{
		return;
	}
		
	// calculate the number of friendly bots
	if ( level.teambased )
	{
		bot_num_friendly = bot_friends;
		bot_num_friendly = clamp( bot_num_friendly, 0, max_players );
	}
	else
	{
		bot_num_friendly = 0;
	}

	// calculate the number of enemy bots
	bot_num_enemy = bot_enemies;
	bot_num_enemy  = clamp( bot_num_enemy, 0, max_players - bot_num_friendly );

	// sanity check
	if ( bot_num_enemy + bot_num_friendly <= 0 )
	{
		return;
	}

	bot_wait_for_host();
	player = GetHostPlayerForBots();
	
	bot_set_difficulty();
	team = player.pers[ "team" ];
	game[ "bots_spawned" ] = 1;
	level thread bot_kick_think();

	// spawn the enemies first
	spawned_bots = 0;

	while ( spawned_bots < bot_num_enemy )
	{
		wait( 0.25 );
		bot = AddTestClient();

		if ( !IsDefined( bot ) )
		{
			continue;
		}
					
		spawned_bots++;
		bot.pers[ "isBot" ] = true;

		bot thread bot_spawn_think( getEnemyTeamWithLowestPlayerCount( team ) );
	}

	// friendlies
	spawned_bots = 0;

	while ( spawned_bots < bot_num_friendly )
	{
		wait( 0.25 );
		bot = AddTestClient();

		if ( !IsDefined( bot ) )
		{
			continue;
		}
					
		spawned_bots++;
		bot.pers[ "isBot" ] = true;
		bot thread bot_spawn_think( team );
	}
}

getEnemyTeamWithLowestPlayerCount( player_team )
{
	count = 999999;
	enemy_team = player_team;
	
	foreach( team in level.teams )
	{
		if ( team == player_team )
			continue;
			
		if ( level.playerCount[team] < count )
		{
			enemy_team = team;
			count = level.playerCount[team];
		}
	}
	
	return enemy_team;
}

bot_wait_for_host()
{
	host = GetHostPlayerForBots();
		
	while ( !IsDefined( host ) )
	{
		wait( 0.05 );
		host = GetHostPlayerForBots();
	}

	while ( !IsDefined( host.team ) )
	{
		wait( 0.05 );
	}
	
	while ( !isdefined( level.teams[host.team] ) && host.team != "spectator" )
	{
		wait( 0.05 );
	}
}

bot_spawn_think( team )
{
	self endon( "disconnect" );

	while( !IsDefined( self.team ) )
	{
		wait .05;
	}

	if ( level.teambased )
	{
		self notify( "menuresponse", game["menu_team"], team );
		wait 0.5;
	}

	self bot_set_rank();

	while( 1 )
	{
		bot_choose_class();
		self waittill( "spawned_player" );
		wait ( 0.10 );
	}
}

bot_kick_think()
{
	for ( ;; )
	{
		level waittill( "bot_kicked", team );
		level thread bot_reconnect_bot( team );
	}
}

bot_choose_class()
{
	bot_classes = [];
	bot_classes[ bot_classes.size ] = "class_smg";
	bot_classes[ bot_classes.size ] = "class_cqb";	
	bot_classes[ bot_classes.size ] = "class_assault";
	bot_classes[ bot_classes.size ] = "class_lmg";
	bot_classes[ bot_classes.size ] = "class_sniper";
	bot_classes[ bot_classes.size ] = "custom0";
	bot_classes[ bot_classes.size ] = "custom1";
	bot_classes[ bot_classes.size ] = "custom2";
	bot_classes[ bot_classes.size ] = "custom3";
	bot_classes[ bot_classes.size ] = "custom4";

	self maps\mp\bots\_bot_loadout::bot_give_killstreaks();

	self notify( "menuresponse", "changeclass", random( bot_classes ) );
}

bot_spawn()
{
/#
	weapon = undefined;

	if ( GetDvarInt( "scr_botsHasPlayerWeapon" ) != 0 )
	{
		player = GetHostPlayer();
		weapon = player GetCurrentWeapon();
	}

	if ( GetDvar( "devgui_bot_weapon" ) != "" )
	{
		weapon = GetDvar( "devgui_bot_weapon" );
	}

	if ( IsDefined( weapon ) )
	{
		self maps\mp\gametypes\_weapons::detach_all_weapons();
		self TakeAllWeapons();
		self GiveWeapon( weapon );
		self SwitchToWeapon( weapon );
		self SetSpawnWeapon( weapon );

		self maps\mp\teams\_teams::set_player_model( self.team, weapon );
	}
#/

	if ( !IsDefined( self.bot ) )
	{
		self.bot = [];
	}

	if ( !IsDefined( self.bot[ "rank" ] ) )
	{
		self bot_set_rank();
	}

	self thread bot_main();

/#
	self thread bot_devgui_think();
#/
}

bot_get_loadout_primary()
{
	return random( level.bot_primaries );
}

bot_wakeup_think()
{
	self endon( "death" );
	self endon( "disconnect" );

	difficulty = bot_get_difficulty();
	interval = BOT_THINK_INTERVAL_SECS_MEDIUM;

	switch( difficulty )
	{
		case "easy":
			interval = BOT_THINK_INTERVAL_SECS_EASY;
		break;

		case "normal":
			interval = BOT_THINK_INTERVAL_SECS_MEDIUM;
		break;

		case "hard":
			interval = BOT_THINK_INTERVAL_SECS_HARD;
		break;

		case "fu":
			interval = BOT_THINK_INTERVAL_SECS_FU;
		break;
	}

	for ( ;; )
	{
		wait( interval );
		self notify( "wakeup" );
	}
}

bot_damage_think()
{
	self endon( "death" );
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, direction );
		self notify( "wakeup", damage, attacker, direction );
	}
}

bot_main()
{
	self endon( "death" );
	self endon( "disconnect" );

	self.goal_flag = undefined;
	self.bot[ "crouch_update" ] = 0;
	self.bot[ "killstreak_update" ] = 0;
	self.bot[ "lookat_update" ] = 0;
	self.bot[ "patrol_update" ] = 0;

	self.spawn_weapon = self GetCurrentWeapon();

	self thread bot_wakeup_think();
	self thread bot_damage_think();

	for ( ;; )
	{
		self waittill( "wakeup", damage, attacker, direction );

		if ( self IsRemoteControlling() )
		{
			continue;
		}

		// reload
		// use equipment
		// use riotshield
		// use killstreak
		// attack/hack equipment
		// attack airborne/vehicle entity
		// attack dog

		self maps\mp\bots\_bot_combat::bot_combat_think( damage, attacker, direction );

		self bot_crouch_update();
		self bot_killstreak_think();
		self bot_wander();

		switch( level.gameType )
		{
			case "conf":
				self maps\mp\bots\_bot_conf::bot_conf_think();
			break;	

			case "dom":
				self maps\mp\bots\_bot_dom::bot_dom_think();
			break;

			case "dem":
				self maps\mp\bots\_bot_dem::bot_dem_think();
			break;

			case "hq":
				self maps\mp\bots\_bot_hq::bot_hq_think();
			break;

			case "ctf":
				self maps\mp\bots\_bot_ctf::bot_ctf_think();
			break;

			case "hack":
				self bot_bwars_think();
			break;

			case "sd":
				self maps\mp\bots\_bot_sd::bot_sd_think();
			break;
			
			case "koth":
				self maps\mp\bots\_bot_koth::bot_koth_think();
			break;
				
		}
	}
}

bot_crouch_update()
{
	if ( GetTime() < self.bot[ "crouch_update" ] )
	{
		return;
	}

	if ( self IsMantling() || self IsOnLadder() || !self IsOnGround() )
	{
		return;
	}
			
	dist = self GetLookAheadDist();
	
	if ( dist > 0 )
	{
		dir = self GetLookaheadDir();
		assert( IsDefined( dir ) );

		dir = VectorScale( dir, dist );

		start = self.origin + ( 0, 0, 70 );
		end = start + dir;

		if ( dist >= 256 )
		{
			self.bot[ "crouch_update" ] = GetTime() + 1500;
		}

		if ( self GetStance() == "stand" )
		{
			if ( !BulletTracePassed( start, end, false, self ) )
			{
				self SetStance( "crouch" );
				self.bot[ "crouch_update" ] = GetTime() + 2500;
			}
		}
		else if ( self GetStance() == "crouch" )
		{
			if ( BulletTracePassed( start, end, false, self ) )
			{
				self SetStance( "stand" );
			}
		}
	}
}

bot_has_radar()
{
	if ( level.teambased )
	{
		return ( maps\mp\killstreaks\_radar::teamHasSpyplane( self.team ) || maps\mp\killstreaks\_radar::teamHasSatellite( self.team ) ); 
	}
	
	return ( is_true( self.hasSpyplane ) || is_true( self.hasSatellite ) );
}

bot_get_enemies( on_radar )
{
	if ( !IsDefined( on_radar ) )
	{
		on_radar = false;
	}
		
	enemies = [];

	foreach( teamKey, team in level.alivePlayers )
	{
		if ( level.teambased && teamKey == self.team )
			continue;
			
		foreach( player in team )
		{
			if ( player == self )
				continue;

/#
			if ( isdefined( player ) && player IsInMoveMode( "ufo", "noclip" ) )
			{
				continue;
			}
#/
	
			if ( on_radar )
			{
				if ( GetTime() - player.lastFireTime > 3000 && !maps\mp\bots\_bot::bot_has_radar() )
				{
					continue;
				}
			}
	
			enemies[ enemies.size ] = player;
		}
	}

	return enemies;
}

bot_get_friends()
{
	friends = [];

	if ( !level.teambased )
	{
		return friends;
	}

	foreach( player in level.alivePlayers[self.team] )
	{
		if ( player == self )
		{
			continue;
		}

	/#
		if ( player IsInMoveMode( "ufo", "noclip" ) )
		{
			continue;
		}
	#/

		friends[ friends.size ] = player;
	}

	return friends;
}

bot_friend_goal_in_radius( goal_name, origin, radius )
{
	count = 0;
	friends = bot_get_friends();

	foreach( friend in friends )
	{
		if ( friend is_bot() )
		{
			goal = friend GetGoal( goal_name );

			if ( IsDefined( goal ) && DistanceSquared( origin, goal ) < radius * radius )
			{
				count++;
			}
		}
	}

	return count;
}

bot_get_closest_enemy( origin, on_radar )
{
	enemies = self bot_get_enemies( on_radar );

	closest = undefined;
	distSq = 99999999;

	foreach( enemy in enemies )
	{
		d = DistanceSquared( origin, enemy.origin );

		if ( d < distSq )
		{
			closest = enemy;
			distSq = d;
		}
	}

	return closest;
}

bot_wander()
{
	goal = self GetGoal( "wander" );

	if ( IsDefined( goal ) )
	{
		if ( DistanceSquared( goal, self.origin ) > 256 * 256 )
		{
			return;
		}
	}

	if ( IsDefined( level.spawn_all ) && level.spawn_all.size > 0 )
	{
		spawns = get_array_of_closest( self.origin, level.spawn_all );
	}
	else if ( IsDefined( level.spawnpoints ) && level.spawnpoints.size > 0 )
	{
		spawns = get_array_of_closest( self.origin, level.spawnpoints );
	}
	else if ( IsDefined( level.spawn_start ) && level.spawn_start.size > 0 )
	{
		spawns = ArrayCombine( level.spawn_start[ "allies" ], level.spawn_start[ "axis" ], true, false );
		spawns = get_array_of_closest( self.origin, spawns );
	}
	else
	{
		return;
	}
	
	far = Int( spawns.size / 2 );
	far = RandomIntRange( far, spawns.size );

	self AddGoal( spawns[ far ].origin, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_LOW, "wander" );
}

bot_reconnect_bot( team )
{
	wait( RandomIntRange( 3, 15 ) );

	bot = AddTestClient();

	if ( !IsDefined( bot ) )
	{
		return;
	}
					
	bot.pers[ "isBot" ] = true;
	bot thread bot_spawn_think( team );
}

bot_set_rank()
{
	players = GET_PLAYERS();

	ranks = [];
	bot_ranks = [];
	human_ranks = [];

	if ( !IsDefined( self.bot ) )
	{
		self.bot = [];
	}
	
	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] == self )
			continue;
		
		if ( players[i] is_bot() && IsDefined( players[i].bot ) && IsDefined( players[i].bot[ "rank" ] ) )
		{
			bot_ranks[ bot_ranks.size ] = players[i].bot[ "rank" ];
		}
		else if ( !players[i] is_bot() && IsDefined( players[i].pers[ "rank" ] ) )
		{
			human_ranks[ human_ranks.size ] = players[i].pers[ "rank" ];
		}
	}

	if( !human_ranks.size )
		human_ranks[ human_ranks.size ] = 10;

	human_avg = array_average( human_ranks );

	while ( bot_ranks.size + human_ranks.size < 5 )
	{
		// add some random ranks for better random number distribution
		rank = human_avg + RandomIntRange( -10, 10 );
		human_ranks[ human_ranks.size ] = rank;
	}

	ranks = ArrayCombine( human_ranks, bot_ranks, true, false );

	avg = array_average( ranks );
	s = array_std_deviation( ranks, avg );
	
	rank = Int( random_normal_distribution( avg, s, 0, level.maxRank ) );

	self setRank( rank );
	self.bot[ "rank" ] = rank;
	self.pers[ "rank" ] = rank;

	self.pers[ "rankxp" ] = maps\mp\gametypes\_rank::getRankInfoMinXP( rank );

	if ( self.kills == 1 )
	{
		self.kills = 0;
		self.pers[ "bot_perk" ] = true;
	}
	else
	{
		self.pers[ "bot_perk" ] = false;
	}
}

bot_get_difficulty()
{
	if ( level.bot_offline )
	{
		return GetDvar( "splitscreen_botDifficulty" );
	}
	
	difficulty = GetDvarInt( "bot_difficulty" );

	if ( difficulty == 0 )
	{
		return "easy";
	}
	else if ( difficulty == 1 )
	{
		return "normal";
	}
	else if ( difficulty == 2 )
	{
		return "hard";
	}
	else if ( difficulty == 3 )
	{
		return "fu";
	}

	return "normal";
}

bot_set_difficulty()
{
	difficulty = bot_get_difficulty();

	if ( difficulty == "fu" )
	{
		SetDvar( "bot_MinDeathTime",		"250" );
		SetDvar( "bot_MaxDeathTime",		"500" );
		SetDvar( "bot_MinFireTime",		"100" );
		SetDvar( "bot_MaxFireTime",		"300" );
		SetDvar( "bot_PitchUp",			"-5" );
		SetDvar( "bot_PitchDown",			"10" );
		SetDvar( "bot_Fov",				"160" );
		SetDvar( "bot_MinAdsTime",		"3000" );
		SetDvar( "bot_MaxAdsTime",		"5000" );
		SetDvar( "bot_MinCrouchTime",		"100" );
		SetDvar( "bot_MaxCrouchTime",		"400" );
		SetDvar( "bot_TargetLeadBias",	"2" );
		SetDvar( "bot_MinReactionTime",	"30" );
		SetDvar( "bot_MaxReactionTime",	"100" );
		SetDvar( "bot_StrafeChance",		"1" );
		SetDvar( "bot_MinStrafeTime",		"3000" );
		SetDvar( "bot_MaxStrafeTime",		"6000" );
		SetDvar( "scr_help_dist",			"512" );
		SetDvar( "bot_AllowGrenades",		"1"	);
		SetDvar( "bot_MinGrenadeTime",	"1500" );
		SetDvar( "bot_MaxGrenadeTime",	"4000" );
		SetDvar( "bot_MeleeDist",			"80" );
	}
	else if ( difficulty == "hard" )
	{
		SetDvar( "bot_MinDeathTime",		"250" );
		SetDvar( "bot_MaxDeathTime",		"500" );
		SetDvar( "bot_MinFireTime",		"400" );
		SetDvar( "bot_MaxFireTime",		"600" );
		SetDvar( "bot_PitchUp",			"-5" );
		SetDvar( "bot_PitchDown",			"10" );
		SetDvar( "bot_Fov",				"100" );
		SetDvar( "bot_MinAdsTime",		"3000" );
		SetDvar( "bot_MaxAdsTime",		"5000" );
		SetDvar( "bot_MinCrouchTime",		"100" );
		SetDvar( "bot_MaxCrouchTime",		"400" );
		SetDvar( "bot_TargetLeadBias",	"2" );
		SetDvar( "bot_MinReactionTime",	"400" );
		SetDvar( "bot_MaxReactionTime",	"700" );
		SetDvar( "bot_StrafeChance",		"0.9" );
		SetDvar( "bot_MinStrafeTime",		"3000" );
		SetDvar( "bot_MaxStrafeTime",		"6000" );
		SetDvar( "scr_help_dist",			"384" );
		SetDvar( "bot_AllowGrenades",		"1"	);
		SetDvar( "bot_MinGrenadeTime",	"1500" );
		SetDvar( "bot_MaxGrenadeTime",	"4000" );
		SetDvar( "bot_MeleeDist",			"80" );
	}
	else if ( difficulty == "easy" )
	{
		SetDvar( "bot_MinDeathTime",		"1000" );
		SetDvar( "bot_MaxDeathTime",		"2000" );
		SetDvar( "bot_MinFireTime",		"900" );
		SetDvar( "bot_MaxFireTime",		"1000" );
		SetDvar( "bot_PitchUp",			"-20" );
		SetDvar( "bot_PitchDown",			"40" );
		SetDvar( "bot_Fov",				"50" );
		SetDvar( "bot_MinAdsTime",		"3000" );
		SetDvar( "bot_MaxAdsTime",		"5000" );
		SetDvar( "bot_MinCrouchTime",		"4000" );
		SetDvar( "bot_MaxCrouchTime",		"6000" );
		SetDvar( "bot_TargetLeadBias",	"8" );
		SetDvar( "bot_MinReactionTime",	"1200" );
		SetDvar( "bot_MaxReactionTime",	"1600" );
		SetDvar( "bot_StrafeChance",		"0.1" );
		SetDvar( "bot_MinStrafeTime",		"3000" );
		SetDvar( "bot_MaxStrafeTime",		"6000" );
		SetDvar( "scr_help_dist",			"256" );
		SetDvar( "bot_AllowGrenades",		"0"	);
		SetDvar( "bot_MeleeDist",			"40" );
	}
	else // 'normal' difficulty
	{
		SetDvar( "bot_MinDeathTime",		"500" );
		SetDvar( "bot_MaxDeathTime",		"1000" );
		SetDvar( "bot_MinFireTime",		"600" );
		SetDvar( "bot_MaxFireTime",		"800" );
		SetDvar( "bot_PitchUp",			"-10" );
		SetDvar( "bot_PitchDown",			"20" );
		SetDvar( "bot_Fov",				"70" );
		SetDvar( "bot_MinAdsTime",		"3000" );
		SetDvar( "bot_MaxAdsTime",		"5000" );
		SetDvar( "bot_MinCrouchTime",		"2000" );
		SetDvar( "bot_MaxCrouchTime",		"4000" );
		SetDvar( "bot_TargetLeadBias",	"4" );
		SetDvar( "bot_MinReactionTime",	"800" );
		SetDvar( "bot_MaxReactionTime",	"1200" );
		SetDvar( "bot_StrafeChance",		"0.6" );
		SetDvar( "bot_MinStrafeTime",		"3000" );
		SetDvar( "bot_MaxStrafeTime",		"6000" );
		SetDvar( "scr_help_dist",			"256" );
		SetDvar( "bot_AllowGrenades",		"1"	);
		SetDvar( "bot_MinGrenadeTime",	"1500" );
		SetDvar( "bot_MaxGrenadeTime",	"4000" );
		SetDvar( "bot_MeleeDist",			"80" );
	}

	if ( level.gameType == "oic" && difficulty == "fu" )
	{
		SetDvar( "bot_MinReactionTime",		"400" );
		SetDvar( "bot_MaxReactionTime",		"500" );
		SetDvar( "bot_MinAdsTime",		"1000" );
		SetDvar( "bot_MaxAdsTime",		"2000" );
	}

	if ( level.gameType == "oic" && ( difficulty == "hard" || difficulty == "fu" ) )
	{
		SetDvar( "bot_SprintDistance",	"256" );
	}
}

bot_cry_for_help( attacker )
{
	if ( !level.teamBased )
	{
		return;
	}

	if ( level.teamBased && IsDefined( attacker.team ) )
	{
		if ( attacker.team == self.team )
		{
			return;
		}
	}
	
	if ( IsDefined( self.help_time ) && GetTime() - self.help_time < 1000 )
	{
		return;
	}
	
	self.help_time = GetTime();

	players = GET_PLAYERS();
	dist = GetDvarint( "scr_help_dist" );

	for ( i = 0; i < players.size; i++ )
	{
		player = players[i];

		if ( !player is_bot() )
		{
			continue;
		}

		if ( !IsAlive( player ) )
		{
			continue;
		}

		if ( player == self )
		{
			continue;
		}

		if ( player.team != self.team )
		{
			continue;
		}

		if ( DistanceSquared( self.origin, player.origin ) > dist * dist )
		{
			continue;
		}

		if ( RandomInt( 100 ) < 50 )
		{
			player thread bot_find_attacker( attacker );

			if ( RandomInt( 100 ) > 70 )
			{
				break;
			}
		}
	}
}

bot_find_attacker( attacker )
{
	self endon( "death" );
	self endon( "disconnect" );

	if ( !IsDefined( attacker ) || !IsAlive( attacker ) )
	{
		return;
	}

	if ( attacker.classname == "auto_turret" )
	{
		//self SetScriptEnemy( attacker );
		self thread turret_path_monitor( attacker );
		return;
	}

	dir = VectorNormalize( attacker.origin - self.origin );
	dir = VectorScale( dir, 128 );

	goal = self.origin + dir;
	goal = ( goal[0], goal[1], self.origin[2] + 50 );

	//DebugStar( goal, 100, ( 1, 0, 0 ) );

	//self SetScriptGoal( goal, 128 );

	wait( 1 );

	//self ClearScriptGoal();
}

bot_crate_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	myteam = self.pers[ "team" ];

	for ( ;; )
	{
		self wait_endon( randomintrange( 3, 5 ), "my_crate_landed" );

		crates = GetEntArray( "care_package", "script_noteworthy" );

		if ( crates.size == 0 )
		{
			continue;
		}

		crate = random( crates );

		if ( IsDefined( crate.droppingToGround ) )
		{
			continue;
		}

		if ( !IsDefined( crate.bots ) )
		{
			crate.bots = 0;
		}

		if ( crate.bots >= 1 )
		{
			continue;
		}

		if ( level.teambased && IsDefined( crate.owner ) && crate.owner != self )
		{
			if ( myteam == crate.owner.team )
			{
				if ( RandomInt( 100 ) > 30 )
				{
					continue;
				}
			}
		}

		if ( DistanceSquared( self.origin, crate.origin ) > 2048 * 2048 )
		{
			if ( !IsDefined( crate.owner ) )
			{
			continue;
		}

			if ( crate.owner != self )
			{
				continue;
			}
		}

		origin = ( crate.origin[0], crate.origin[1], crate.origin[2] + 12 );

		//self SetScriptGoal( origin, 100 );
		crate.bots++;
		self thread crate_path_monitor( crate );
		self thread crate_touch_monitor( crate );
		crate thread crate_death_monitor( self );

		path = self waittill_any_return( "goal", "bad_path" );

		if ( path == "bad_path" )
		{
			if ( IsDefined( crate ) )
			{
				crate.bots--;
			}

			//self ClearScriptGoal();
			continue;
		}

		//self SetScriptGoal( self.origin, 100 );

		if ( crate.owner == self )
		{
			self PressUseButton( level.crateOwnerUseTime / 1000 + 0.5 );
			wait( level.crateOwnerUseTime / 1000 + 0.5 );
		}
		else
		{
		self PressUseButton( level.crateNonOwnerUseTime / 1000 + 1 );
		wait( level.crateNonOwnerUseTime / 1000 + 1.5 );
		}

		//self ClearScriptGoal();
	}
}

crate_death_monitor( bot )
{
	self endon( "death" );

	bot waittill( "death" );
	self.bots--;
}

crate_path_monitor( crate )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "bad_path" );
	self endon( "goal" );

	crate waittill( "death" );
	self notify( "bad_path" );
}

crate_touch_monitor( crate )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "bad_path" );
	self endon( "goal" );

	radius = GetDvarFloat( "player_useRadius" );

	for ( ;; )
	{
		wait( 0.5 );

		if ( DistanceSquared( self.origin, crate.origin ) < radius * radius )
		{
			self notify( "goal" );
			return;
		}
	}
}

// ensure bots don't get stuck on crates for too long
bot_crate_touch_think()
{
	self endon( "death" );
	self endon( "disconnect" );

	radius = GetDvarFloat( "player_useRadius" );

	for ( ;; )
	{
		wait( 3 );

		if ( IsDefined( self GetThreat() ) )
		{
			continue;
		}

		if ( self UseButtonPressed() )
		{
			continue;
		}

		crates = GetEntArray( "care_package", "script_noteworthy" );

		for ( i = 0; i < crates.size; i++ )
		{
			crate = crates[i];

			if ( DistanceSquared( self.origin, crate.origin ) < radius * radius )
			{
				if ( crate.owner == self )
				{
					self PressUseButton( level.crateOwnerUseTime / 1000 + 0.5 );
				}
				else
				{
					self PressUseButton( level.crateNonOwnerUseTime / 1000 + 0.5 );
				}
			}
		}
	}
}

bot_turret_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	myteam = self.pers[ "team" ];

	if ( bot_get_difficulty() == "easy" )
	{
		return;
	}

	for ( ;; )
	{
		wait( 1 );

		turrets = GetEntArray( "auto_turret", "classname" );

		if ( turrets.size == 0 || IsDefined( self GetThreat() ) )
		{
			wait( randomintrange( 3, 5 ) );
			continue;
		}

		turret = Random( turrets );

		if ( IsDefined( turret.vehicle ) )
		{
			continue;
		}

		if ( turret.carried )
		{
			continue;
		}

		if ( turret.damageTaken >= turret.health )
		{
			continue;
		}

		if ( level.teambased && turret.team == myteam )
		{
			continue;
		}

		if ( IsDefined( turret.owner ) && turret.owner == self )
		{
			continue;
		}

		if ( !IsDefined( turret.bots ) )
		{
			turret.bots = 0;
		}

		if ( turret.bots >= 2 )
		{
			continue;
		}

		forward = AnglesToForward( turret.angles );
		forward = VectorNormalize( forward );

		delta = self.origin - turret.origin;
		delta = VectorNormalize( delta );
		
		dot = VectorDot( forward, delta );
		facing = true;

		if ( dot < 0.342 ) // cos 70 degrees
		{
			facing = false;
		}

		if ( turret.turrettype == "tow" )
		{
			facing = false;
		}

		if ( turret maps\mp\gametypes\_weaponobjects::isStunned() )
		{
			facing = false;
		}

		if ( facing && !BulletTracePassed( self.origin + ( 0, 0, 30 ), turret.origin + ( 0, 0, 15 ), false, turret ) )
		{
			continue;
		}

		turret.bots++;
		turret thread turret_death_monitor( self );

		if ( self HasPerk( "specialty_disarmexplosive" ) &&  !(self IsEMPJammed()) && !facing )
		{
			self thread turret_path_monitor( turret );
			//self SetScriptGoal( turret.origin, 32 );

			path = self waittill_any_return( "goal", "bad_path" );

			if ( path == "goal" )
			{
				hackTime = GetDvarfloat( "perk_disarmExplosiveTime" );
				self PressUseButton( hackTime + 0.5 );
				wait( hackTime + 0.5 );
				//self ClearScriptGoal();
				continue;
			}
		}
		else if ( !facing )
		{
			self thread turret_path_monitor( turret );
			//self SetScriptGoal( turret.origin, 64 );
			self waittill_any_return( "goal", "bad_path" );
			//self ClearScriptGoal();
		}

		if ( !IsDefined( turret ) )
		{
			continue;
		}

		if ( turret.carried )
		{
			continue;
		}

		if ( turret.damageTaken >= turret.health )
		{
			continue;
		}

		//self SetScriptEnemy( turret );
		turret waittill_any( "turret_carried", "turret_deactivated", "death" );
		//self ClearScriptEnemy();
	}
}

bot_killstreak_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	myteam = self.pers[ "team" ];

	if ( GetTime() < self.bot[ "killstreak_update" ] )
	{
		return;
	}

	if ( self IsRemoteControlling() )
	{
		return;
	}

	if ( self IsWeaponViewOnlyLinked() )
	{
		return;
	}

/#
	if ( !GetDvarInt( "scr_botsAllowKillstreaks" ) )
	{
		return;
	}
#/

	self.bot[ "killstreak_update" ] = GetTime() + 1000;
	weapons = self GetWeaponsList();
	ks_weapon = undefined;

	inventoryWeapon = self GetInventoryWeapon();
		
	foreach( weapon in weapons )
	{
		if ( self GetWeaponAmmoClip( weapon ) <= 0 && ( !isdefined( inventoryWeapon ) || weapon != inventoryWeapon ) )
		{
			continue;
		}
		
		if ( isKillstreakWeapon( weapon ) )
		{
			killstreak = maps\mp\killstreaks\_killstreaks::getKillstreakForWeapon( weapon );

			if ( self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( killstreak, self.team ) )
			{
				ks_weapon = weapon;
				break;
			}
		}
	}

	if ( !IsDefined( ks_weapon ) )
	{
		return;
	}

	killstreak = maps\mp\killstreaks\_killstreaks::getKillstreakForWeapon( ks_weapon );
	killstreak_ref = maps\mp\killstreaks\_killstreaks::getKillStreakMenuName( killstreak );

	if ( !IsDefined( killstreak_ref ) )
	{
		return;
	}

	switch( killstreak_ref )
	{
		case "killstreak_helicopter_comlink":
			bot_killstreak_location( 1, weapon );
		break;

		case "killstreak_planemortar":
			bot_killstreak_location( 3, weapon );
		break;

		case "killstreak_supply_drop":
		case "killstreak_ai_tank_drop":
		case "killstreak_minigun":
		case "killstreak_m32":
		case "killstreak_missile_drone":
			self bot_use_supply_drop( weapon );
		break;

		case "killstreak_auto_turret":
		case "killstreak_tow_turret":
		case "killstreak_microwave_turret":
			self bot_turret_location( weapon );
		break;

		case "killstreak_rcbomb":
		case "killstreak_qrdrone":
		case "killstreak_remote_missile":
		case "killstreak_remote_mortar":
		case "killstreak_helicopter_player_gunner":
			return;

		default:
			self SwitchToWeapon( weapon );
		break;
	}
}

bot_get_vehicle_entity()
{
	if ( self IsRemoteControlling() )
	{
		if ( IsDefined( self.rcbomb ) )
		{
			return self.rcbomb;
		}
		else if ( IsDefined( self.QRDrone ) )
		{
			return self.QRDrone;
		}
	}

	return undefined;
}

bot_rccar_think()
{
	self endon( "disconnect" );
	self endon( "rcbomb_done" );
	self endon( "weapon_object_destroyed" );
	level endon ( "game_ended" );

	wait( 2 );

	self thread bot_rccar_kill();

	for ( ;; )
	{
		wait( 0.5 );

		ent = self bot_get_vehicle_entity();

		if ( !IsDefined( ent ) )
		{
			return;
		}

		players = GET_PLAYERS();

		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];

			if ( player == self )
			{
				continue;
			}

			if ( !IsAlive( player ) )
			{
				continue;
			}

			if ( level.teamBased && player.team == self.team )
			{
				continue;
			}

		/#
			if ( player IsInMoveMode( "ufo", "noclip" ) )
			{
				continue;
			}
		#/

			if ( bot_get_difficulty() == "easy" )
			{
				if ( DistanceSquared( ent.origin, player.origin ) < 512 * 512 )
				{
					self PressAttackButton();
				}
			}
			else if ( DistanceSquared( ent.origin, player.origin ) < 200 * 200 )
			{
				self PressAttackButton();
			}
		}
	}
}

// failsafe for stuck cars
bot_rccar_kill()
{
	self endon( "disconnect" );
	self endon( "rcbomb_done" );
	self endon( "weapon_object_destroyed" );
	level endon ( "game_ended" );

	og_origin = self.origin;

	for ( ;; )
	{
		wait( 1 );

		ent = bot_get_vehicle_entity();

		if ( !IsDefined( ent ) )
		{
			return;
		}

		if ( DistanceSquared( og_origin, ent.origin ) < 16 * 16 )
		{
			wait( 2 );

			if ( !IsDefined( ent ) )
			{
				return;
			}

			if ( DistanceSquared( og_origin, ent.origin ) < 16 * 16 )
			{
				self PressAttackButton();
			}
		}

		og_origin = ent.origin;
	}
}

bot_turret_location( weapon )
{
	enemy = bot_get_closest_enemy( self.origin );

	if ( !IsDefined( enemy ) )
	{
		return;
	}

	forward = AnglesToForward( self GetPlayerAngles() );
	forward = VectorNormalize( forward );

	delta = enemy.origin - self.origin;
	delta = VectorNormalize( delta );

	dot = VectorDot( forward, delta );

	if ( dot < 0.707 )
	{
		return;
	}

	node = GetVisibleNode( self.origin, enemy.origin );

	if ( !IsDefined( node ) )
	{
		return;
	}

	if ( DistanceSquared( self.origin, node.origin ) < 512 * 512 )
	{
		return;
	}

	delta = node.origin - self.origin;
	delta = VectorNormalize( delta );

	dot = VectorDot( forward, delta );

	if ( dot < 0.707 )
	{
		return;
	}

	self thread weapon_switch_failsafe();
	self SwitchToWeapon( weapon );
	self waittill( "weapon_change_complete" );
	self freeze_player_controls( true );

	wait( 1 );
	self freeze_player_controls( false );
	bot_use_item( weapon );
	self SwitchToWeapon( self.lastNonKillstreakWeapon );
}

bot_use_supply_drop( weapon )
{
	if ( !self HasWeapon( weapon ) )
	{
		return;
	}

	if ( self GetLookaheadDist() < 96 )
	{
		return;
	}

	dir = self GetLookaheadDir();

	if ( !IsDefined( dir ) )
	{
		return;
	}

	dir = VectorToAngles( dir );

	if ( abs( dir[1] - self.angles[1] ) > 2 )
	{
		return;
	}

	yaw = ( 0, self.angles[1], 0 );
	dir = AnglesToForward( yaw );

	dir = VectorNormalize( dir );
	drop_point = self.origin + VectorScale( dir, 384 );
	//DebugStar( drop_point, 500, ( 1, 0, 0 ) );

	end = drop_point + ( 0, 0, 2048 );
	//DebugStar( end, 500, ( 1, 0, 0 ) );

	if ( !SightTracePassed( drop_point, end, false, undefined ) )
	{
		return;
	}

	if ( !SightTracePassed( self.origin, end, false, undefined ) )
	{
		return;
	}

	// is this point in mid-air?
	end = drop_point - ( 0, 0, 32 );
	//DebugStar( end, 500, ( 1, 0, 0 ) );
	if ( BulletTracePassed( drop_point, end, false, undefined ) )
	{
		wait_time = 0.1;
		return;
	}

	if ( self GetCurrentWeapon() != weapon )
	{
		self thread weapon_switch_failsafe();
		self SwitchToWeapon( weapon );
		self waittill( "weapon_change_complete" );
	}

	bot_use_item( weapon );
	self SwitchToWeapon( self.lastNonKillstreakWeapon );
}

bot_killstreak_location( num, weapon )
{
	if ( !self SwitchToWeapon( weapon ) )
	{
		return;
	}
	self waittill( "weapon_change" );
	self freeze_player_controls( true );

	wait_time = 1;
	while ( !IsDefined( self.selectingLocation ) || self.selectingLocation == false )
	{
		wait( 0.05 );
		wait_time -= 0.05;

		if ( wait_time <= 0 )
		{
			self freeze_player_controls( false );
			self SwitchToWeapon( self.lastNonKillstreakWeapon );
			return;
		}
	}

	wait( 2 );

	for ( i = 0; i < num; i++ )
	{
		enemies = bot_get_enemies();

		if ( enemies.size )
		{
			enemy = random( enemies );
			self notify( "confirm_location", enemy.origin, 0 );
		}

		wait( 0.25 );
	}

	self freeze_player_controls( false );
}

bot_hack_tank_get_goal_origin( tank )
{
	nodes = GetNodesInRadiusSorted( tank.origin, 256, 0, 64, "Path" );

	foreach( node in nodes )
	{
		dir = VectorNormalize( node.origin - tank.origin );
		dir = VectorScale( dir, 32 );

		goal = tank.origin + dir;

		if ( FindPath( self.origin, goal, false ) )
		{
			return goal;
		}
	}

	return undefined;
}

bot_hack_goal_pregame( tanks )
{
	foreach( tank in tanks )
	{
		if ( IsDefined( tank.owner ) )
		{
			continue;
		}

		if ( IsDefined( tank.team ) && tank.team == self.team )
		{
			continue;
		}

		goal = self bot_hack_tank_get_goal_origin( tank );

		if ( IsDefined( goal ) )
		{
			if ( self AddGoal( goal, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_NORMAL, "bwars" ) )
			{
				self.goal_flag = tank;
				return;
			}
		}
	}
}

bot_hack_at_goal()
{
	if ( self AtGoal( "bwars" ) )
	{
		return true;
	}

	if ( !IsDefined( self.goal_flag ) )
	{
		return false;
	}

	return ( IsDefined( self.goal_flag.trigger ) && self IsTouching( self.goal_flag.trigger ) );
}

bot_bwars_think()
{
	if ( self bot_hack_at_goal() )
	{
		if ( !IsDefined( self.goal_flag ) )
		{
			self CancelGoal( "bwars" );
			self.goal_flag = undefined;
		}
		else
		{
			self SetStance( "crouch" );
			wait( 0.25 );
			self AddGoal( self.origin, 24, PRIORITY_URGENT, "bwars" );
			self PressUseButton( level.drone_hack_time + 1 );
			wait( level.drone_hack_time + 1 );
			self SetStance( "stand" );
			self CancelGoal( "bwars" );
			self.goal_flag = undefined;
		}
	}

	if ( !IsDefined( self.goal_flag ) )
	{
		tanks = GetEntArray( "talon", "targetname" );
		tanks = get_array_of_closest( self.origin, tanks );

		if ( !is_true( level.drones_spawned ) )
		{
			self bot_hack_goal_pregame( tanks );
		}
		else
		{
			foreach( tank in tanks )
			{
				if ( IsDefined( tank.owner ) && tank.owner == self )
				{
					continue;
				}

				if ( !IsDefined( tank.owner ) )
				{
					goal = self bot_hack_tank_get_goal_origin( tank );

					if ( IsDefined( goal ) )
					{
						if ( self AddGoal( goal, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_NORMAL, "bwars" ) )
						{
							self.goal_flag = tank;
							return;
						}
					}
				}

				if ( tank.isStunned && DistanceSquared( self.origin, tank.origin ) < 512 * 512 )
				{
					goal = self bot_hack_tank_get_goal_origin( tank );

					if ( IsDefined( goal ) )
					{
						if ( self AddGoal( goal, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_HIGH, "bwars" ) )
						{
							self.goal_flag = tank;
							return;
						}
					}
				}
			}

			if ( !bot_vehicle_weapon_ammo( "emp_grenade_mp" ) )
			{
				ammo = GetEntArray( "weapon_scavenger_item_hack_mp", "classname" );
				ammo = get_array_of_closest( self.origin, ammo );

				foreach( bag in ammo )
				{
					if ( FindPath( self.origin, bag.origin, false ) )
					{
						if ( self AddGoal( bag.origin, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_NORMAL, "bwars" ) )
						{
							self.goal_flag = bag;
							return;
						}
					}
				}

				return;
			}

			foreach( tank in tanks )
			{
				if ( IsDefined( tank.owner ) && tank.owner == self )
				{
					continue;
				}

				if ( tank.isStunned )
				{
					continue;
				}

				if ( self ThrowGrenade( "emp_grenade_mp", tank.origin ) )
				{
					self waittill( "grenade_fire" );

					goal = self bot_hack_tank_get_goal_origin( tank );

					if ( IsDefined( goal ) )
					{
						if ( self AddGoal( goal, BOT_DEFAULT_GOAL_RADIUS, PRIORITY_HIGH, "bwars" ) )
						{
							wait( 0.5 );
							return;
						}
					}
				}
			}
		}
	}
}

bot_dogs_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	myteam = self.pers[ "team" ];

	for ( ;; )
	{
		wait( 1 );

		dogs = maps\mp\killstreaks\_dogs::dog_manager_get_dogs();

		if ( dogs.size <= 0 )
		{
			level waittill( "called_in_the_dogs" );
			dogs = maps\mp\killstreaks\_dogs::dog_manager_get_dogs();
		}

		foreach ( dog in dogs )
		{
			if ( !IsAlive( dog ) )
			{
				continue;
			}

			if ( level.teamBased )
			{
				if ( dog.aiteam == myteam )
				{
					continue;
				}
			}

			if ( IsDefined( dog.script_owner ) && dog.script_owner == self )
			{
				continue;
			}

			if ( DistanceSquared( self.origin, dog.origin ) < ( 1024 * 1024 ) )
			{
				//self SetScriptEnemy( dog );
				break;
			}
		}
	}
}

bot_talon_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	myteam = self.pers[ "team" ];

	for ( ;; )
	{
		wait( 3 );

		tanks = GetEntArray( "talon", "targetname" );

		if ( tanks.size <= 0 )
		{
			continue;
		}

		foreach ( tank in tanks )
		{
			if ( !IsAlive( tanks ) )
			{
				continue;
			}

			if ( level.teamBased && tank.team == myteam )
			{
				continue;
			}

			if ( tank.owner == self )
			{
				continue;
			}

			if ( DistanceSquared( self.origin, tank.origin ) < ( 1024 * 1024 ) )
			{
				//self SetScriptEnemy( tank );
				break;
			}
		}
	}
}


bot_vehicle_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	if ( bot_get_difficulty() == "easy" )
	{
		return;
	}

	myteam = self.pers[ "team" ];

	for ( ;; )
	{
		wait( 1 );

		airborne_enemies = GetEntArray( "script_vehicle", "classname" );

		if ( !IsDefined( airborne_enemies ) || airborne_enemies.size <= 0 )
		{
			wait( RandomIntRange( 3, 5 ) );
			continue;
		}
		
		for ( i = 0; i < airborne_enemies.size; i++ )
		{
			enemy = airborne_enemies[i];

			if ( !IsDefined( enemy ) )
			{
				continue;
			}

			if ( !IsAlive( enemy ) )
			{
				continue;
			}

			if ( level.teamBased )
			{
				if ( enemy.team == myteam )
				{
					continue;
				}
			}

			if ( enemy.owner == self )
			{
				continue;
			}

			if ( !IsDefined( enemy.targetname ) || enemy.targetname != "rcbomb" )
			{
				if ( !self bot_vehicle_weapon() )
				{
					continue;
				}
			}

			if ( !BulletTracePassed( self.origin, enemy.origin, false, enemy ) )
			{
				continue;
			}

			//self SetScriptEnemy( enemy );
			self bot_vehicle_attack( enemy );
			//self ClearScriptEnemy();
			break;
		}
	}
}

bot_riotshield_think()
{
	self endon( "death" );
	self endon( "disconnect" );

	for ( ;; )
	{
		wait( RandomIntRange( 3, 5 ) );

		if ( !is_true( self.hasRiotShield ) )
		{
			continue;
		}

		if ( RandomInt( 100 ) < 20 || IsDefined( self GetThreat() ) )
		{
			self SwitchToWeapon( "riotshield_mp" );
			wait( RandomIntRange( 3, 5 ) );
			continue;
		}
		
		if ( cointoss() && !IsDefined( self GetThreat() ) && self GetCurrentWeapon() == "riotshield_mp" )
		{
			primaries = self GetWeaponsListPrimaries();

			foreach( weapon in primaries )
			{
				if ( weapon != "riotshield_mp" )
				{
					self SwitchToWeapon( weapon );
					break;
				}
			}
		}
	}
}

bot_vehicle_attack( enemy )
{
	wait_time = RandomIntRange( 7, 10 );

	for ( i = 0; i < wait_time; i++ )
	{
		wait( 1 );

		if ( !IsDefined( enemy ) )
		{
			return;
		}

		if ( !IsAlive( enemy ) )
		{
			return;
		}

		if ( !IsDefined( enemy.targetname ) || enemy.targetname != "rcbomb" )
		{
			if ( !self bot_vehicle_weapon() )
			{
				return;
			}
		}

		if ( !BulletTracePassed( self.origin, enemy.origin, false, enemy ) )
		{
			return;
		}
	}
}

bot_vehicle_weapon()
{
	weapons = [];
	weapons[0] = "smaw_mp";
	weapons[1] = "fhj18_mp";
	weapons[2] = "m202_flash_mp";
	weapons[3] = "minigun_mp";
	weapons[4] = "rpg_mp";

	for ( i = 0; i < weapons.size; i++ )
	{
		if ( self HasWeapon( weapons[i] ) && self bot_vehicle_weapon_ammo( weapons[i] ) > 0 )
		{
			return true;
		}
	}

	return false;
}

bot_vehicle_weapon_ammo( weapon )
{
	return ( self GetWeaponAmmoClip( weapon ) + self GetWeaponAmmoStock( weapon ) );
}

turret_path_monitor( turret )
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "bad_path" );
	//self endon( "goal" );

	turret waittill_any( "death", "hacked", "turret_deactivated" );

	//self ClearScriptGoal();
	//self ClearScriptEnemy();
}

turret_death_monitor( bot )
{
	self endon( "death" );

	bot waittill( "death" );
	self.bots--;
}

bot_wager_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	if ( !level.wagerMatch )
	{
		return;
	}

	for ( ;; )
	{
		wait( RandomIntRange( 3, 5 ) );

		if ( IsDefined( self.hasSpyplane ) && self.hasSpyplane == true )
		{
			players = GET_PLAYERS();
			players = array_randomize( players );
			player = undefined;
		
			for ( i = 0; i < players.size; i++ )
			{
				if ( !IsDefined( players[i] ) || !IsAlive( players[i] ) )
				{
					continue;
				}

				if ( players[i] == self )
				{
					continue;
				}

				if ( players[i].sessionstate != "playing" )
				{
					continue;
				}

				player = players[i];
				break;
			}

			if ( IsDefined( player ) )
			{
				//self SetScriptGoal( player.origin, 64 );
				self waittill_any( "goal", "bad_path" );
				//self ClearScriptGoal();
			}
		}
	}
}

bot_use_item( weapon )
{
	self PressAttackButton();
	wait( 0.5 );

	for ( i = 0; i < 10; i++ )
	{
		if ( self GetCurrentWeapon() == weapon || self GetCurrentWeapon() == "none" )
		{
			self PressAttackButton();
		}
		else
		{
			return;
		}

		wait( 0.5 );
	}
}

bot_equipment_think( weapon )
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	if ( !IsDefined( weapon ) )
	{
		return;
	}

	weapon = weapon + "_mp";

	for ( ;; )
	{
		wait( RandomIntRange( 1, 3 ) );

		if ( !self HasWeapon( weapon ) )
		{
			return;
		}

		if ( self._is_sprinting )
		{
			continue;
		}

		if ( weapon == "camera_spike_mp" )
		{
			if ( self GetLookaheadDist() < 384 )
			{
				continue;
			}

			view_angles = self GetPlayerAngles();

			if ( view_angles[0] < -5 )
			{
				continue;
			}
		}
		else
		{
			if ( self GetLookaheadDist() > 64 )
			{
				continue;
			}
		}

		dir = self GetLookaheadDir();

		if ( !IsDefined( dir ) )
		{
			continue;
		}

		dir = VectorToAngles( dir );

		if ( abs( dir[1] - self.angles[1] ) > 5 )
		{
			continue;
		}

		dir = VectorNormalize( AnglesToForward( self.angles ) );
		dir = VectorScale( dir, 32 );
		goal = self.origin + dir;

		//self SetScriptGoal( goal, 128 );
		self waittill_any( "goal", "bad_path" );

		if ( equipment_nearby( self.origin ) )
		{
			//self ClearScriptGoal();
			continue;
		}

		if ( self GetCurrentWeapon() != weapon )
		{
			self thread weapon_switch_failsafe();
			self SwitchToWeapon( weapon );
			self waittill( "weapon_change_complete" );
		}
		else
		{
			//self ClearScriptGoal();
			continue;
		}

		self bot_use_item( weapon );
		//self ClearScriptGoal();
		return;
	}
}

bot_equipment_kill_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	if ( bot_get_difficulty() == "easy" )
	{
		return;
	}

	myteam = self.pers[ "team" ];

	for ( ;; )
	{
		if ( self HasPerk( "specialty_showenemyequipment" ) )
		{
			wait( RandomIntRange( 2, 5 ) );
		}
		else
		{
			wait( RandomIntRange( 5, 7 ) );
		}

		grenades = GetEntArray( "grenade", "classname" );
		target = undefined;

		for ( i = 0; i < grenades.size; i++ )
		{
			item = grenades[i];

			if ( !IsDefined( item.name ) )
			{
				continue;
			}

			if ( !IsDefined( item.owner ) )
			{
				continue;
			}

			if ( level.teamBased && item.owner.team == myteam )
			{
				continue;
			}

			if ( item.owner == self )
			{
				continue;
			}

			if ( !IsWeaponEquipment( item.name ) )
			{
				continue;
			}

			if ( self HasPerk( "specialty_showenemyequipment" ) && DistanceSquared( item.origin, self.origin ) < 512 * 512 )
			{
				target = item;
				break;
			}

			if ( DistanceSquared( item.origin, self.origin ) < 256 * 256 )
			{
				target = item;
				break;
			}
		}

		if ( IsDefined( target ) )
		{
			if ( self HasPerk( "specialty_disarmexplosive" ) &&  !(self IsEMPJammed()) && target.name != "claymore_mp" && target.name != "bouncingbetty_mp")
			{
				//self SetScriptGoal( target.origin, 32 );
				path = self waittill_any_return( "goal", "bad_path" );

				if ( path == "goal" )
				{
					hackTime = GetDvarFloat( "perk_disarmExplosiveTime" );
					self PressUseButton( hackTime + 0.5 );
					wait( hackTime + 0.5 );
					//self ClearScriptGoal();
					continue;
				}
			}

			if ( IsDefined( target ) )
			{
				//self SetScriptEnemy( target );
				wait( RandomIntRange( 7, 10 ) );
				//self ClearScriptEnemy();
			}
		}
	}
}

equipment_nearby( origin )
{
	grenades = GetEntArray( "grenade", "classname" );

	for ( i = 0; i < grenades.size; i++ )
	{
		item = grenades[i];

		if ( !IsDefined( item.name ) )
		{
			continue;
		}

		if ( !IsWeaponEquipment( item.name ) )
		{
			continue;
		}

		if ( DistanceSquared( item.origin, origin ) < 128 * 128 )
		{
			return true;
		}
	}

	return false;
}

weapon_switch_failsafe()
{
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "weapon_change_complete" );

	wait( 10 );

	//self ClearScriptGoal();
	self notify( "weapon_change_complete" );
}

bot_debug_star( origin, seconds, color )
{
	/#
	if ( !IsDefined( seconds ) )
	{
		seconds = 1;
	}
	
	if ( !IsDefined( color ) )
	{
		color = ( 1, 0, 0 );
	}

	frames = 20 * seconds;
	DebugStar( origin, frames, color );
	#/
}

/#

bot_devgui_think()
{
	self endon( "death" );
	self endon( "disconnect" );

	SetDvar( "devgui_bot", "" );
	SetDvar( "scr_bot_follow", "0" );

	for ( ;; )
	{
		wait( 1 );

		reset = true;
		switch( GetDvar( "devgui_bot" ) )
		{
		case "crosshair":
			if ( GetDvarint( "scr_bot_follow" ) != 0 )
			{
				iprintln( "Bot following enabled" );
				self thread bot_crosshair_follow();
			}
			else
			{
				iprintln( "Bot following disabled" );
				self notify( "crosshair_follow_off" );
				SetDvar( "bot_AllowMovement", "0" );
				//self ClearScriptGoal();
			}
			break;

		case "laststand":
			SetDvar( "scr_forcelaststand", "1" );
			
			self SetPerk( "specialty_pistoldeath" );
			self SetPerk( "specialty_finalstand" );
			self DoDamage( self.health, self.origin );
			break;
						
		case "":
		default:
			reset = false;
			break;
		}

		if ( reset )
		{
			SetDvar( "devgui_bot", "" );
		}
	}
}

bot_system_devgui_think()
{
	SetDvar( "devgui_bot", "" );
	SetDvar( "devgui_bot_weapon", "" );

	for ( ;; )
	{
		wait( 1 );

		reset = true;
		switch( GetDvar( "devgui_bot" ) )
		{
		case "spawn_friendly":
			player = GetHostPlayer();
			team = player.team;

			devgui_bot_spawn( team );
			break;

		case "spawn_enemy":
			player = GetHostPlayer();
			team = getEnemyTeamWithLowestPlayerCount( player.team );

			devgui_bot_spawn( team );
			break;

		case "loadout":
		case "player_weapon":
			players = GET_PLAYERS();
			foreach( player in players )
			{
				if ( !player is_bot() )
				{
					continue;
				}

				host = GetHostPlayer();
				weapon = host GetCurrentWeapon();

				player maps\mp\gametypes\_weapons::detach_all_weapons();
				player TakeAllWeapons();
				player GiveWeapon( weapon );
				player SwitchToWeapon( weapon );
				player SetSpawnWeapon( weapon );

				player maps\mp\teams\_teams::set_player_model( player.team, weapon );
			}
			break;

		case "routes":
			devgui_debug_route();
			break;

		case "":
		default:
			reset = false;
			break;
		}

		if ( reset )
		{
			SetDvar( "devgui_bot", "" );
		}
	}
}

bot_crosshair_follow()
{
	self notify( "crosshair_follow_off" );
	self endon( "death" );
	self endon( "disconnect" );
	self endon( "crosshair_follow_off" );
	
	for ( ;; )
	{
		wait( 1 );
		SetDvar( "bot_AllowMovement", "1" );
		SetDvar( "bot_IgnoreHumans", "1" );
		SetDvar( "bot_ForceStand", "1" );
	
		// Trace to where the player is looking
		player = GetHostPlayerForBots();
		direction = player GetPlayerAngles();
		direction_vec = AnglesToForward( direction );
		eye = player GetEye();

		scale = 8000;
		direction_vec = ( direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale );
		trace = bullettrace( eye, eye + direction_vec, 0, undefined );

		origin = trace[ "position" ] + ( 0, 0, 0 );

		if ( DistanceSquared( self.origin, origin ) > 128 * 128 )
		{
			//self ClearScriptGoal();
			//self SetScriptGoal( origin, 32 );
		}
	}
}

bot_debug_patrol( node1, node2 )
{
	self endon( "death" );
	self endon( "debug_patrol" );

	for( ;; )
	{
		self AddGoal( node1, 24, PRIORITY_URGENT, "debug_route" );
		self waittill( "debug_route" );

		self AddGoal( node2, 24, PRIORITY_URGENT, "debug_route" );
		self waittill( "debug_route" );
	}
}

devgui_debug_route()
{
	iprintln( "Choose nodes with 'A' or press 'B' to cancel" );
	nodes = maps\mp\gametypes\_dev::dev_get_node_pair();

	if ( !IsDefined( nodes ) )
	{
		iprintln( "Route Debug Cancelled" );
		return;
	}

	iprintln( "Sending bots to chosen nodes" );

	players = GET_PLAYERS();
	foreach( player in players )
	{
		if ( !player is_bot() )
		{
			continue;
		}

		player notify( "debug_patrol" );
		player thread bot_debug_patrol( nodes[0], nodes[1] );
	}
}

#/

bot_spawner_Once()
{
	if ( !GetDvarint( "scr_bots_managed_spawn" ) )
	{
		SetDvar( "scr_bots_managed_spawn", 0 );
	}
	
	if ( !GetDvarint( "scr_bots_managed_all" ) )
	{
		SetDvar( "scr_bots_managed_all", 0 );
	}
	
	if ( !GetDvarint( "scr_bots_managed_axis" ) )
	{
		SetDvar( "scr_bots_managed_axis", 0 );
	}
	
	if ( !GetDvarint( "scr_bots_managed_allied" ) )
	{
		SetDvar( "scr_bots_managed_allied", 0 );
	}
	
	if ( GetDvar( "scr_bot_difficulty" ) == "" )
	{
		SetDvar( "scr_bot_difficulty", "normal" );
	}
	
	bot_set_difficulty();	
	
/#
		SetDvar( "bot_AllowMovement", "1" );
		SetDvar( "bot_PressAttackBtn", "1" );
		SetDvar( "bot_PressMeleeBtn", "1" );
		SetDvar( "bot_IgnoreHumans", "0" );
		SetDvar( "scr_botsHasPlayerWeapon", "0" );
		SetDvar( "scr_botsGrenadesOnly", "0" );
		SetDvar( "scr_botsSpecialGrenadesOnly", "0" );
#/
	
	level thread bot_spawner_think();
}

get_smallest_team( playerCounts )
{
	smallest_count = 0;
	smallest_team = undefined;
	foreach( team, count in playerCounts )
	{
		if ( !isdefined( smallest_team ) )
		{
			smallest_team = team;
			smallest_count = count;
			continue;
		}
		
		if ( count < smallest_count )
		{
			smallest_team = team;
			smallest_count = count;
		}
	}
	
	return smallest_team;
}

get_required_bot_counts()
{
	botCounts = [];
	
	num = GetDvarint( "scr_bots_managed_all" );

	num_teams = level.teams.size;
	
	if ( num > 0 )
	{
		total_assigned = 0;
		foreach( team in level.teams )
		{
			botCounts[team] = Floor( num / num_teams );
			total_assigned += botCounts[team];
		}
		
		if ( num - total_assigned > 0 )
		{
			playerCounts = self maps\mp\teams\_teams::CountPlayers();
			while ( num - total_assigned > 0 )
			{
				total_assigned++;
				team = get_smallest_team( playerCounts );
				playerCounts[team]++;
				botCounts[team]++;
			}
		}
	}
	else
	{
		// TODO MTEAM - Do we need to add a variable for each team?
		botCounts["axis"] = GetDvarint( "scr_bots_managed_axis" );
		botCounts["allies"] = GetDvarint( "scr_bots_managed_allies" );
		botCounts["team3"] = GetDvarint( "scr_bots_managed_team3" );
	}
	
	return botCounts;
}

adjustTeamBotCount( team, difference )
{
	if ( difference == 0 )
		return;
		
	if( difference < 0 )
	{
/#
	PrintLn("Updating bots kick " + team + ": " + difference );
#/			
		players = level.players;
		for ( i = 0; i < players.size && difference >= 0; i++ )
		{
			player = players[i];
			
			if( !IsDefined( player.pers[ "isBot" ] ) )
				continue;
			
			if( team == player.team )
			{
				kick( player getEntityNumber() );
				difference = difference + 1;
				wait(0.25);
			}
		}				
	}
	else // if( difference < 0 )
	{
/#
		PrintLn("Updating bots add " + team + ": " + difference );
#/			
		for( ; difference > 0; difference = difference - 1 )
		{
			wait( 0.25 );
			bot = AddTestClient();
	
			if ( !IsDefined( bot ) )
			{
				continue;
			}
						
			bot.pers[ "isBot" ] = true;
			bot thread bot_spawn_think( team );
		} // while ( spawned_bots < difference )
	} // else // if( difference < 0 )
}

bot_spawner_think()
{
	level endon ( "game_ended" );
	
	wait( 0.5 );	

	for( ;; )
	{		
		wait 10.0;
		
		if ( game["state"] == "postgame" )
			return;
			
		if( !GetDvarint( "scr_bots_managed_spawn" ) )
			continue;
			
		humans = 0;

		players = level.players;			
		for ( i = 0; i < players.size; i++ )
		{
			player = players[i];
			
			if( player is_bot() )
				continue;
			
			humans++;
			break;
		}
		
/#
		PrintLn("Updating bots count per team\n");
#/
		if( !humans )
		{
			// kick all bots if no humans left
			players = level.players;
			for ( i = 0; i < players.size; i++ )
			{
				player = players[i];
				
				if( !IsDefined( player.pers[ "isBot" ] ) )
					continue;
				
				kick( player getEntityNumber() );
				wait(0.25);
			}
		}
		
		if( !IsDefined( level.botsCount ) )
			continue;
	
		required_bot_counts = get_required_bot_counts();
		
		foreach( team in level.teams )
		{
			difference =  required_bot_counts[team] - level.botCount[team];
			adjustTeamBotCount( team, difference );
		}
	} // for( ;; )
}

/#
devgui_bot_spawn( team )
{
	player = GetHostPlayer();

	// Trace to where the player is looking
	direction = player GetPlayerAngles();
	direction_vec = AnglesToForward( direction );
	eye = player GetEye();

	scale = 8000;
	direction_vec = ( direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale );
	trace = bullettrace( eye, eye + direction_vec, 0, undefined );

	direction_vec = player.origin - trace["position"];
	direction = VectorToAngles( direction_vec );
	
	bot = AddTestClient();

	if ( !IsDefined( bot ) )
	{
		println( "Could not add test client" );
		return;
	}
			
	bot.pers["isBot"] = true;
	bot thread bot_spawn_think( team );

	yaw = direction[1];
	bot thread devgui_bot_spawn_think( trace[ "position" ], yaw );
}

devgui_bot_spawn_think( origin, yaw )
{
	self endon( "disconnect" );

	for ( ;; )
	{
		self waittill( "spawned_player" );
		self SetOrigin( origin );

		angles = ( 0, yaw, 0 );
		self SetPlayerAngles( angles );
	}
}
#/
