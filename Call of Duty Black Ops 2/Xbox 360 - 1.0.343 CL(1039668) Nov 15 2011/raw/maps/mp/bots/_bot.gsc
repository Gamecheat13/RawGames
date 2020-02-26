#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	level.bot_offline = false;
	level.bot_weapon_ids = [];

/# 
	level thread bot_system_devgui_think();
#/
	
	if ( level.onlineGame && !GameModeIsMode( level.GAMEMODE_BASIC_TRAINING ) )
	{
		if( !level.console )
		{
			bot_spawner_Once();
		}
		return;
	}
	
	if ( !level.onlineGame )
	{
		if ( SessionModeIsSystemlink() )
		{
			return;
		}

		if ( level.gameType != "tdm" && level.gameType != "dm" )
		{
			return;
		}

		level.bot_offline = true;
	}
	
	// bots have already been spawned (happens on round changes)
	if ( IsDefined( game[ "bots_spawned" ] ) )
	{
		return;
	}

	if ( level.bot_offline )
	{
		humans = GetDvarInt( "splitscreen_playerCount" );
		bot_friends = GetDvarInt( "splitscreen_botFriends" );
		bot_enemies = GetDvarInt( "splitscreen_botEnemies" );
	}
	else
	{
		humans = GetDvarInt( "party_playerCount" );
		bot_friends = GetLocalProfileInt( "bot_friends" );
		bot_enemies = GetLocalProfileInt( "bot_enemies" );
	}

	// all humans playing
	if ( humans >= bot_friends + bot_enemies )
	{
		return;
	}

	level.autoassign = ::basic_training_auto_assign;
	level thread bot_kick_think();
	
	// calculate the number of friendly bots
	if ( level.teambased )
	{
		bot_num_friendly = bot_friends - humans;
		bot_num_friendly = clamp( bot_num_friendly, 0, bot_num_friendly );
	}
	else
	{
		bot_num_friendly = 0;
	}

	// calculate the number of enemy bots
	if ( level.teambased )
	{
		human_enemies = humans - bot_friends;
		human_enemies = clamp( human_enemies, 0, human_enemies );

		bot_num_enemy = bot_enemies - human_enemies;
	}
	else
	{
		bot_num_enemy = bot_enemies - humans + 1; /* + 1 for the host */
	}

	// sanity check
	if ( bot_num_enemy + bot_num_friendly <= 0 )
	{
			return;
	}
	
	bot_wait_for_host();
	player = GetHostPlayer();
		
	/#
		SetDvar( "sv_botsAllowMovement", "1" );
		SetDvar( "sv_botsPressAttackBtn", "1" );
		SetDvar( "sv_botsPressMeleeBtn", "1" );
		SetDvar( "sv_botsIgnoreHumans", "0" );
		SetDvar( "scr_botsHasPlayerWeapon", "0" );
		SetDvar( "scr_botsGrenadesOnly", "0" );
		SetDvar( "scr_botsSpecialGrenadesOnly", "0" );
		SetDvar( "scr_botsAllowKillstreaks", "1" );
	#/

	bot_set_difficulty();
	team = player.pers[ "team" ];
	game[ "bots_spawned" ] = 1;

	// spawn the enemies first
	spawned_bots = 0;

	equipment_weights = array( 0, 1, 1, 2, 2, 2, 2, 3, 3, 4 );
	can_use_equipment = random( equipment_weights );

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
		bot.equipment_enabled = false;

		if ( can_use_equipment > 0 )
		{
			bot.equipment_enabled = true;
			can_use_equipment--;
		}

		bot thread bot_spawn_think( getOtherTeam( team ) );
	}

	// friendlies
	spawned_bots = 0;
	can_use_equipment = random( equipment_weights );

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
		bot.equipment_enabled = false;

		if ( can_use_equipment > 0 )
		{
			bot.equipment_enabled = true;
			can_use_equipment--;
		}

		bot thread bot_spawn_think( team );
	}
}

basic_training_auto_assign()
{
	host = GetHostPlayer();

	if ( host == self )
	{
		self maps\mp\gametypes\_globallogic_ui::menuAutoAssign();
		return;
	}

	if ( self is_bot() )
	{
		if ( !level.teambased )
		{
			self maps\mp\gametypes\_globallogic_ui::menuAutoAssign();
		}

		if ( self.team != "spectator" )
		{
			return;
		}
	}

	bot_wait_for_host();
	host = GetHostPlayer();
	host_team = host.pers[ "team" ];

	player_counts = self maps\mp\teams\_teams::CountPlayers();

	if ( level.bot_offline )
	{
		friends = GetDvarInt( "splitscreen_botFriends" ) - player_counts[ host_team ];
	}
	else
	{
		friends = GetLocalProfileInt( "bot_friends" ) - player_counts[ host_team ];
	}

	if ( friends > 0 )
	{
		assignment = host_team;
	}
	else
	{
		assignment = getOtherTeam( host_team );
	}

	// remainder of this function is taken directly from _globallogic_ui::menuAutoAssign()
	self.pers["team"] = assignment;
	self.team = assignment;
	self.pers["class"] = undefined;
	self.class = undefined;
	self.pers["weapon"] = undefined;
	self.pers["savedmodel"] = undefined;

	self maps\mp\gametypes\_globallogic_ui::updateObjectiveText();

	if ( level.teamBased )
		self.sessionteam = assignment;
	else
	{
		self.sessionteam = "none";
		self.ffateam = assignment;
	}
	
	if ( !isAlive( self ) )
		self.statusicon = "hud_status_dead";
	
	self notify("joined_team");
	level notify( "joined_team" );
	self notify("end_respawn");
	
	if( isPregameGameStarted() )
	{
		pclass = self GetPregameClass();
		if( IsDefined( pclass ) )
		{
			self closeMenu();
			self closeInGameMenu();
			
			self.selectedClass = true;
			self [[level.class]](pclass);
			return;
		}
	}

	self maps\mp\gametypes\_globallogic_ui::beginClassChoice();	
	self SetClientScriptMainMenu( game[ "menu_class_" + self.pers["team"] ] );
}

bot_wait_for_host()
{
	host = GetHostPlayer();
		
	while ( !IsDefined( host ) )
	{
		wait( 0.05 );
		host = GetHostPlayer();
	}

	while ( !IsDefined( host.pers[ "team" ] ) )
	{
		wait( 0.05 );
	}
	
	while ( host.pers[ "team" ] != "allies" && host.pers[ "team" ] != "axis" )
	{
		wait( 0.05 );
	}
}

bot_spawn_think( team )
{
	self endon( "disconnect" );

	while( !IsDefined( self.pers["team"] ) )
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
		self notify( "menuresponse", "changeclass", "class_smg" );
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

bot_reconnect_bot( team )
{
	wait( RandomIntRange( 3, 15 ) );

	bot = AddTestClient();

	if ( !IsDefined( bot ) )
	{
		return;
	}
					
	bot.pers[ "isBot" ] = true;
	bot.equipment_enabled = false;

	if ( cointoss() )
	{
		bot.equipment_enabled = true;
	}

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

	ranks = array_combine( human_ranks, bot_ranks );

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
	
	difficulty = GetLocalProfileInt( "bot_difficulty" );

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
		SetDvar( "sv_botMinDeathTime",		"250" );
		SetDvar( "sv_botMaxDeathTime",		"500" );
		SetDvar( "sv_botMinFireTime",		"100" );
		SetDvar( "sv_botMaxFireTime",		"300" );
		SetDvar( "sv_botYawSpeed",			"14" );
		SetDvar( "sv_botYawSpeedAds",		"14" );
		SetDvar( "sv_botPitchUp",			"-5" );
		SetDvar( "sv_botPitchDown",			"10" );
		SetDvar( "sv_botFov",				"160" );
		SetDvar( "sv_botMinAdsTime",		"3000" );
		SetDvar( "sv_botMaxAdsTime",		"5000" );
		SetDvar( "sv_botMinCrouchTime",		"100" );
		SetDvar( "sv_botMaxCrouchTime",		"400" );
		SetDvar( "sv_botTargetLeadBias",	"2" );
		SetDvar( "sv_botMinReactionTime",	"30" );
		SetDvar( "sv_botMaxReactionTime",	"100" );
		SetDvar( "sv_botStrafeChance",		"1" );
		SetDvar( "sv_botMinStrafeTime",		"3000" );
		SetDvar( "sv_botMaxStrafeTime",		"6000" );
		SetDvar( "scr_help_dist",			"512" );
		SetDvar( "sv_botAllowGrenades",		"1"	);
		SetDvar( "sv_botMinGrenadeTime",	"1500" );
		SetDvar( "sv_botMaxGrenadeTime",	"4000" );
		SetDvar( "sv_botSprintDistance",	"512"	);
		SetDvar( "sv_botMeleeDist",			"80" );
	}
	else if ( difficulty == "hard" )
	{
		SetDvar( "sv_botMinDeathTime",		"250" );
		SetDvar( "sv_botMaxDeathTime",		"500" );
		SetDvar( "sv_botMinFireTime",		"400" );
		SetDvar( "sv_botMaxFireTime",		"600" );
		SetDvar( "sv_botYawSpeed",			"8" );
		SetDvar( "sv_botYawSpeedAds",		"10" );
		SetDvar( "sv_botPitchUp",			"-5" );
		SetDvar( "sv_botPitchDown",			"10" );
		SetDvar( "sv_botFov",				"100" );
		SetDvar( "sv_botMinAdsTime",		"3000" );
		SetDvar( "sv_botMaxAdsTime",		"5000" );
		SetDvar( "sv_botMinCrouchTime",		"100" );
		SetDvar( "sv_botMaxCrouchTime",		"400" );
		SetDvar( "sv_botTargetLeadBias",	"2" );
		SetDvar( "sv_botMinReactionTime",	"400" );
		SetDvar( "sv_botMaxReactionTime",	"700" );
		SetDvar( "sv_botStrafeChance",		"0.9" );
		SetDvar( "sv_botMinStrafeTime",		"3000" );
		SetDvar( "sv_botMaxStrafeTime",		"6000" );
		SetDvar( "scr_help_dist",			"384" );
		SetDvar( "sv_botAllowGrenades",		"1"	);
		SetDvar( "sv_botMinGrenadeTime",	"1500" );
		SetDvar( "sv_botMaxGrenadeTime",	"4000" );
		SetDvar( "sv_botSprintDistance",	"512"	);
		SetDvar( "sv_botMeleeDist",			"80" );
	}
	else if ( difficulty == "easy" )
	{
		SetDvar( "sv_botMinDeathTime",		"1000" );
		SetDvar( "sv_botMaxDeathTime",		"2000" );
		SetDvar( "sv_botMinFireTime",		"900" );
		SetDvar( "sv_botMaxFireTime",		"1000" );
		SetDvar( "sv_botYawSpeed",			"2" );
		SetDvar( "sv_botYawSpeedAds",		"2.5" );
		SetDvar( "sv_botPitchUp",			"-20" );
		SetDvar( "sv_botPitchDown",			"40" );
		SetDvar( "sv_botFov",				"50" );
		SetDvar( "sv_botMinAdsTime",		"3000" );
		SetDvar( "sv_botMaxAdsTime",		"5000" );
		SetDvar( "sv_botMinCrouchTime",		"4000" );
		SetDvar( "sv_botMaxCrouchTime",		"6000" );
		SetDvar( "sv_botTargetLeadBias",	"8" );
		SetDvar( "sv_botMinReactionTime",	"1200" );
		SetDvar( "sv_botMaxReactionTime",	"1600" );
		SetDvar( "sv_botStrafeChance",		"0.1" );
		SetDvar( "sv_botMinStrafeTime",		"3000" );
		SetDvar( "sv_botMaxStrafeTime",		"6000" );
		SetDvar( "scr_help_dist",			"256" );
		SetDvar( "sv_botAllowGrenades",		"0"	);
		SetDvar( "sv_botSprintDistance",	"1024"	);
		SetDvar( "sv_botMeleeDist",			"40" );
	}
	else // 'normal' difficulty
	{
		SetDvar( "sv_botMinDeathTime",		"500" );
		SetDvar( "sv_botMaxDeathTime",		"1000" );
		SetDvar( "sv_botMinFireTime",		"600" );
		SetDvar( "sv_botMaxFireTime",		"800" );
		SetDvar( "sv_botYawSpeed",			"4" );
		SetDvar( "sv_botYawSpeedAds",		"5" );
		SetDvar( "sv_botPitchUp",			"-10" );
		SetDvar( "sv_botPitchDown",			"20" );
		SetDvar( "sv_botFov",				"70" );
		SetDvar( "sv_botMinAdsTime",		"3000" );
		SetDvar( "sv_botMaxAdsTime",		"5000" );
		SetDvar( "sv_botMinCrouchTime",		"2000" );
		SetDvar( "sv_botMaxCrouchTime",		"4000" );
		SetDvar( "sv_botTargetLeadBias",	"4" );
		SetDvar( "sv_botMinReactionTime",	"800" );
		SetDvar( "sv_botMaxReactionTime",	"1200" );
		SetDvar( "sv_botStrafeChance",		"0.6" );
		SetDvar( "sv_botMinStrafeTime",		"3000" );
		SetDvar( "sv_botMaxStrafeTime",		"6000" );
		SetDvar( "scr_help_dist",			"256" );
		SetDvar( "sv_botAllowGrenades",		"1"	);
		SetDvar( "sv_botMinGrenadeTime",	"1500" );
		SetDvar( "sv_botMaxGrenadeTime",	"4000" );
		SetDvar( "sv_botSprintDistance",	"512"	);
		SetDvar( "sv_botMeleeDist",			"80" );
	}

	if ( level.gameType == "oic" && difficulty == "fu" )
	{
		SetDvar( "sv_botMinReactionTime",		"400" );
		SetDvar( "sv_botMaxReactionTime",		"500" );
		SetDvar( "sv_botMinAdsTime",		"1000" );
		SetDvar( "sv_botMaxAdsTime",		"2000" );
	}

	if ( level.gameType == "oic" && ( difficulty == "hard" || difficulty == "fu" ) )
	{
		SetDvar( "sv_botSprintDistance",	"256" );
	}
}

bot_give_loadout()
{
	if ( !IsDefined( self.bot ) )
	{
		self.bot = [];
	}

	if ( !IsDefined( self.equipment_enabled ) )
	{
		self.equipment_enabled = false;
	}

/#
	if ( bot_should_clone_loadout() )
	{
		self bot_clone_loadout( level.dev_cac_player );
		return;
	}

	if ( GetDvar( "scr_help_dist" ) == "" )
	{
		SetDvar( "scr_help_dist", "256" );
	}

	if ( GetDvar( "scr_botsAllowKillstreaks" ) == "" )
	{
		SetDvar( "scr_botsAllowKillstreaks", "1" );
	}
#/

	if ( !IsDefined( self.bot[ "rank" ] ) )
	{
		self bot_set_rank();
	}

	self bot_get_cod_points();
	
	playerRenderOptions = self calcPlayerOptions( randomint(5), randomint(5) );
	self SetPlayerRenderOptions( int( playerRenderOptions ) );
	
	// calcWeaponOptions ( <camo> <lens> <reticle> <tag> <emblem> )
	weaponOptions = self calcWeaponOptions( randomint(5), 0, 0, 0, 0 );
	equipment = undefined;

	if ( GetDvarint( "scr_botsHasPlayerWeapon" ) )
	{
		player = maps\mp\_utility::GET_PLAYERS()[0];

		weapon = player GetCurrentWeapon();
		reference = bot_weapon_reference_from_weapon( weapon );

		self.bot[ "primary" ] = weapon;
		self GiveWeapon( weapon );
		self GiveStartAmmo( weapon );

		primarygrenade = player getcurrentoffhand();
		self.bot[ "primarygrenade" ] = primarygrenade;
		self GiveWeapon( primarygrenade );
		self GiveStartAmmo( primarygrenade );
		self SwitchToOffhand( self.bot[ "primarygrenade" ] ); 

		player_class = player.pers["class"];
		if( isSubstr( player_class, "CLASS_CUSTOM" ) )
		{
			specialgrenade = player.custom_class[player.class_num]["specialgrenades"];
		}
		else
		{
			specialgrenade = level.classGrenades[player_class]["secondary"]["type"];
		}
		self.bot[ "specialgrenade" ] = specialgrenade;
		self GiveWeapon( specialgrenade );
		self GiveStartAmmo( specialgrenade );
		self SetOffhandSecondaryClass( self.bot[ "specialgrenade" ] );

		if ( self.equipment_enabled && ( self.bot[ "rank" ] > 3 || level.bot_offline ) )
		{
			equipment = self bot_give_random_weapon( "equipment", 0 );
		}
	}
	else
	{
		reference = self bot_give_random_weapon( "primary", int( weaponOptions ) );
		self bot_give_random_weapon( "secondary", 0 );

		self bot_give_random_weapon( "primarygrenade", 0 );
		self SwitchToOffhand( self.bot[ "primarygrenade" ] ); 

		self bot_give_random_weapon( "specialgrenade", 0 );
		self SetOffhandSecondaryClass( self.bot[ "specialgrenade" ] );

		if ( self.equipment_enabled && ( self.bot[ "rank" ] > 3 || level.bot_offline ) )
		{
			equipment = self bot_give_random_weapon( "equipment", 0 );
		}
	}

	self.grenadeTypePrimary = self.bot[ "primarygrenade" ];
	self.grenadeTypePrimaryCount = self GetWeaponAmmoClip( self.bot[ "primarygrenade" ] );
	self.grenadeTypeSecondary = self.bot[ "specialgrenade" ];
	self.grenadeTypeSecondaryCount = self GetWeaponAmmoClip( self.bot[ "specialgrenade" ] );

	//self bot_give_killStreaks();

	self.pers[ "primaryWeapon" ] = reference;
	if ( GetDvarint( "sv_botsForceFragOnly" ) )
	{
		self TakeWeapon( self.bot[ "primary" ] );
		
		if ( IsDefined(self.bot[ "secondary" ] ) )
		{
			self TakeWeapon( self.bot[ "secondary" ] );
		}
		
		self TakeWeapon( self.bot[ "specialgrenade" ] );
	}
	else if ( GetDvarint( "sv_botsForceSpecialOnly" ) )
	{
		self TakeWeapon( self.bot[ "primary" ] );
		
		if ( IsDefined(self.bot[ "secondary" ] ) )
		{
			self TakeWeapon( self.bot[ "secondary" ] );
		}
		
		self TakeWeapon( self.bot[ "primarygrenade" ] );
	}
	else
	{
		self SetSpawnWeapon( self.bot[ "primary" ] );
	}


	self ClearPerks();

	for ( i = 0; i < level.maxSpecialties; i++ )
	{
		self.bot[ "specialty" + ( i + 1 ) ] = "perk_null";
	}

	self bot_give_random_armor();
	if ( GetDvarint( "scr_game_perks" ) != 0 )
	{
		//self bot_give_random_perk( "specialty1" );
		self bot_give_random_perk( "specialty2" );
		self bot_give_random_perk( "specialty3" );
	}

	self thread bot_revive_think();
	self thread bot_crate_think();
	self thread bot_crate_touch_think();
	self thread bot_turret_think();
	self thread bot_killstreak_think();
	self thread bot_dogs_think();
	self thread bot_talon_think();
	self thread bot_vehicle_think();
	self thread bot_wager_think();
	self thread bot_equipment_think( equipment );
	self thread bot_equipment_kill_think();
	self thread bot_radiation_think();

/#
	self thread bot_devgui_think();
#/
}

bot_give_killstreaks()
{
	if ( IsDefined( self.killstreak ) && self.killstreak.size > 0 )
	{
		return;
	}

	self.killstreak = [];

	allowed_killstreaks = [];

	allowed_killstreaks[ 0 ] = "killstreak_spyplane";
	allowed_killstreaks[ 1 ] = "killstreak_supply_drop";
	allowed_killstreaks[ 2 ] = "killstreak_helicopter_comlink";

	if ( self.bot[ "rank" ] >= 9 || level.bot_offline )
	{
		allowed_killstreaks[ 3 ] = "killstreak_auto_turret_drop";
		allowed_killstreaks[ 4 ] = "killstreak_tow_turret_drop";
		allowed_killstreaks[ 5 ] = "killstreak_napalm";
		allowed_killstreaks[ 6 ] = "killstreak_counteruav";
		allowed_killstreaks[ 7 ] = "killstreak_mortar";
		allowed_killstreaks[ 8 ] = "killstreak_spyplane_direction";
		allowed_killstreaks[ 9 ] = "killstreak_airstrike";
		allowed_killstreaks[ 10 ] = "killstreak_dogs";
		allowed_killstreaks[ 11 ] = "killstreak_rcbomb";
	}

	used_levels = [];

	for ( i = 0; i < 3; i++ )
	{
		killstreak = random( allowed_killstreaks );
		allowed_killstreaks = array_remove( allowed_killstreaks, killstreak );

		ks_level = maps\mp\killstreaks\_killstreaks::GetKillstreakLevel( i, killstreak );

		if ( bot_killstreak_level_is_used( ks_level, used_levels ) )
		{
			i--;
			continue;
		}

		used_levels[ used_levels.size ] = ks_level;
		self.killstreak[ i ] = killstreak;
	}
}

bot_killstreak_level_is_used( ks_level, used_levels )
{
	if ( !IsDefined( ks_level ) )
	{
		return true;
	}

	for ( used = 0; used < used_levels.size; used++ )
	{
		if ( ks_level == used_levels[ used ] )
		{
			return true;
		}
	}

	return false;
}

bot_give_random_weapon( slot, weaponOptions )
{
	pixbeginevent( "bot_give_random_weapon" );
	rank = self.bot[ "rank" ];

	if ( level.bot_offline )
	{
		rank = level.maxRank;
	}

	if ( !IsDefined( level.bot_weapon_ids[ slot ] ) )
	{
		level.bot_weapon_ids[ slot ] = [];

		keys = GetArrayKeys( level.tbl_weaponIDs );

		for ( i = 0; i < keys.size; i++ )
		{
			key = keys[i];
			id = level.tbl_weaponIDs[ key ];

		if ( id[ "reference" ] == "weapon_null" )
			continue;

		if ( id[ "cost" ] == "-1" )
			continue;

			if ( id[ "slot" ] == slot )
			{
				level.bot_weapon_ids[ slot ][ level.bot_weapon_ids[ slot ].size ] = id;
			}
		}
	}

	if ( level.bot_weapon_ids[ slot ].size <= 0 )
	{
		return;
	}

	for ( tries = 0; ; tries++ )
	{
		id = random( level.bot_weapon_ids[ slot ] );

		if ( id[ "classified" ] != 0 )
		{
			if ( !bot_weapon_classified_unlocked( id, rank ) )
			{
				continue;
			}
		}

		if ( id[ "reference" ] == "hatchet" && RandomInt( 100 ) > 20 )
		{
			continue;
		}

		if ( id[ "reference" ] == "willy_pete" && RandomInt( 100 ) > 20 )
		{
			continue;
		}

		if ( id[ "reference" ] == "nightingale" && RandomInt( 100 ) > 20 )
		{
			continue;
		}

		if ( id[ "reference" ] == "claymore" && bot_get_difficulty() == "easy" )
		{
			continue;
		}

		if ( id[ "reference" ] == "scrambler" && bot_get_difficulty() == "easy" )
		{
			continue;
		}

		// dual-wield weapon
		if ( id[ "unlock_level" ] == "" && ( IsSubStr( id[ "reference" ], "dw" ) ) )
		{
			if ( !bot_weapon_dual_wield_unlocked( id[ "reference" ], rank ) )
			{
				continue; 
			}
		}

		unlock = Int( id[ "unlock_level" ] );

		if ( unlock > 3 && unlock > rank )
			continue;

		if ( slot == "equipment" )
		{
			if ( tries >= level.bot_weapon_ids[ slot ].size )
			{
				pixendevent();
				return undefined;
			}

			if ( !maps\mp\gametypes\_class::isEquipmentAllowed( id[ "reference" ] + "_mp" ) )
				continue;
		
			if ( id[ "reference" ] == "satchel_charge" )
				continue;
			
		cost = Int( id[ "cost" ] );

		if ( cost > self.bot[ "cod_points" ] )
			continue;

		self.bot[ "cod_points" ] = self.bot[ "cod_points" ] - cost;
		}

		if ( id[ "unlock_level" ] != "" && id[ "attachment" ] != "" && RandomFloatRange( 0, 1 ) < ( rank / level.maxRank ) )
		{
			base_weapon = bot_give_random_attachment( id[ "reference" ], id[ "attachment" ] );
		}
		else
		{
			base_weapon = id[ "reference" ];
		}

		weapon = base_weapon + "_mp";

		self.bot[ slot ] = weapon;
		self GiveWeapon( weapon, 0, weaponOptions );
		self GiveStartAmmo( weapon );
		pixendevent();
		return base_weapon;
	}

	pixendevent();
}

bot_weapon_dual_wield_unlocked( dw_weapon, rank )
{
	if ( RandomInt( 100 ) > 20 )
	{
		return false;
	}
	
	base_weapon = StrTok( dw_weapon, "dw" );

	if ( !IsDefined( base_weapon ) || base_weapon.size == 0 )
	{
		return false;
	}

	base_weapon = base_weapon[0];

	if ( !IsDefined( base_weapon ) || base_weapon == "" )
	{
		return false;
	}

	unlock = 999;
	
	for ( i = 0; i < level.tbl_weaponIDs.size; i++ )
	{
		id = level.tbl_weaponIDs[i];

		if ( !IsDefined( id ) )
		{
			continue;
		}

		if ( base_weapon == id[ "reference" ] )
		{
			if ( id[ "classified" ] != 0 )
			{
				if ( !bot_weapon_classified_unlocked( id, rank ) )
				{
					return false;
				}
			}
			
			unlock = Int( id[ "unlock_level" ] );
			break;
		}
	}

	return ( unlock <= rank );
}

bot_weapon_classified_unlocked( id, rank )
{
	unlock = 999;

	// to do: get this from a data source

	switch( id[ "group" ] )
	{
		case "weapon_pistol":
			unlock = 17;
			break;
		case "weapon_smg":
			unlock = 40;
			break;
		case "weapon_assault":
			unlock = 43;
			break;
		case "weapon_lmg":
			unlock = 20;
			break;
		case "weapon_sniper":
			unlock = 26;
			break;
		case "weapon_cqb":
			unlock = 23;
			break;
	}

	return ( unlock <= rank );
}

bot_give_random_attachment( weapon, attachments )
{
	/*
	cost = 500; // TODO: get this from data some day

	if ( cost > self.bot[ "cod_points" ] )
	{
		return ( weapon );
	}

	self.bot[ "cod_points" ] = self.bot[ "cod_points" ] - cost;
	*/
	
	attachments = StrTok( attachments, " " );
	attachments = array_remove( attachments, "dw" ); // dw weapon madness in the statstable

	if ( attachments.size <= 0 )
	{
		return ( weapon );
	}

	attachment = random( attachments );

	if ( attachment == "" )
	{
		return ( weapon );
	}

	return ( weapon + "_" + attachment );
}

bot_give_random_armor()
{
	self maps\mp\teams\_teams::set_player_model( self.pers[ "team" ], self.bot[ "primary" ] );
}

bot_give_random_perk( slot )
{
	for ( ;; )
	{
		id = random( level.perkList );
		id = level.tbl_PerkData[ id ];

		if ( id[ "reference" ] == "specialty_null" )
			continue;

		if ( id[ "slot" ] != slot )
			continue;

		cost = Int( id[ "cost" ] );

		if ( cost > self.bot[ "cod_points" ] )
			continue;

		self.bot[ "cod_points" ] = self.bot[ "cod_points" ] - cost;

		self.bot[ slot ] = id[ "reference_full" ];
		perks = StrTok( id[ "reference" ], "|" );
		
		for ( i = 0; i < perks.size; i++ )
		{
			self SetPerk( perks[i] );
		}

		return;
	}
}

bot_give_body_perk()
{
	reference_full = "";
	pro_cost = 3000; // to do: get this from a data source someday

	switch( self.cac_body_type )
	{
		case "camo_mp":
			reference_full = "perk_ghost";
			break;

		case "hardened_mp":
			reference_full = "perk_hardline";
			break;

		case "ordnance_disposal_mp":
			reference_full = "perk_flak_jacket";
			break;

		case "utility_mp":
			reference_full = "perk_scavenger";
			break;

		case "standard_mp":
		default:
			reference_full = "perk_lightweight";
			break;
	}

	if ( self.bot[ "cod_points" ] >= pro_cost )
	{
		self.bot[ "cod_points" ] = self.bot[ "cod_points" ] - pro_cost;
		reference_full = reference_full + "_pro";
	}

	id = bot_perk_from_reference_full( reference_full );

	if ( !IsDefined( id ) )
	{
		return;
	}

	self.bot[ "specialty1" ] = id[ "reference_full" ];
	perks = StrTok( id[ "reference" ], "|" );

	for ( i = 0; i < perks.size; i++ )
	{
		self SetPerk( perks[i] );
	}
}

bot_perk_from_reference_full( reference_full )
{
	keys = GetArrayKeys( level.tbl_PerkData );

	// start from the beginning of the array since our perk is most likely near the start
	for ( i = keys.size - 1; i >= 0; i-- )
	{
		key = keys[i];

		if ( level.tbl_PerkData[ key ][ "reference_full" ] == reference_full )
		{
			return level.tbl_PerkData[ key ];
		}
	}

	return undefined;
}

bot_weapon_reference_from_weapon( weapon )
{
	toks = StrTok( weapon, "_" );
	reference = toks[0];

	for ( i = 1; i < toks.size - 1; i++ )
	{
		reference = reference + "_" + toks[i];
	}

	return reference;
}

/#
bot_should_clone_loadout()
{
	return ( maps\mp\gametypes\_dev_class::dev_cac_player_valid() && level.dev_cac_player is_bot() );
}
#/

bot_get_cod_points()
{
	self.bot[ "cod_points" ] = 999999;
/*
	if ( level.bot_offline )
	{
		self.bot[ "cod_points" ] = 999999;
		return;
	}
	
	players = GET_PLAYERS();
	total_points = [];

	for ( i = 0; i < players.size; i++ )
	{
		if ( players[i] is_bot() )
		{
			continue;
		}

		total_points[ total_points.size ] = players[i].pers["currencyspent"] + players[i].pers["codpoints"];
	}
	
	if( !total_points.size )
		total_points[ total_points.size ] = 10000;

	point_average = array_average( total_points );
	self.bot[ "cod_points" ] = Int( point_average * RandomFloatRange( 0.6, 0.8 ) );
*/
}

bot_clone_loadout( player )
{
	// primary
	self.bot[ "primary" ] = player.bot[ "primary" ];
	self GiveWeapon( self.bot[ "primary" ] );
	self GiveStartAmmo( self.bot[ "primary" ] );
	self SetSpawnWeapon( self.bot[ "primary" ] );

	reference = bot_weapon_reference_from_weapon( self.bot[ "primary" ] );
	self.pers[ "primaryWeapon" ] = reference;

	// secondary
	self.bot[ "secondary" ] = player.bot[ "secondary" ];
	self GiveWeapon( self.bot[ "secondary" ] );
	self GiveStartAmmo( self.bot[ "secondary" ] );

	// grenades
	self.bot[ "primarygrenade" ] = player.bot[ "primarygrenade" ];
	self GiveWeapon( self.bot[ "primarygrenade" ] );
	self GiveStartAmmo( self.bot[ "primarygrenade" ] );
	self SwitchToOffhand( self.bot[ "primarygrenade" ] ); 

	self.bot[ "specialgrenade" ] = player.bot[ "specialgrenade" ];
	self GiveWeapon( self.bot[ "specialgrenade" ] );
	self GiveStartAmmo( self.bot[ "specialgrenade" ] );
	self SetOffhandSecondaryClass( self.bot[ "specialgrenade" ] );

	// armor
	self maps\mp\teams\_teams::set_player_model( self.pers[ "team" ], self.bot[ "primary" ] );
}

// returns true if the bot not engaged and doesn't have a script goal, false otherwise
bot_is_idle()
{
	if ( !IsDefined( self ) )
	{
		return false;
	}

	if ( !IsAlive( self ) )
	{
		return false;
	}

	if ( !self is_bot() )
	{
		return false;
	}

	if ( IsDefined( self.laststand ) && self.laststand == true )
	{
		return false;
	}

	if ( self HasScriptGoal() )
	{
		return false;
	}

	if ( IsDefined( self GetThreat() ) )
	{
		return false;
	}

	return true;
}

bot_damage_callback( eAttacker, iDamage, sMeansOfDeath, sWeapon, eInflictor, sHitLoc )
{
	if ( !IsDefined( self ) || !IsAlive( self ) )
	{
		return;
	}
	
	if ( !self is_bot() )
	{
		return;
	}

	if ( sMeansOfDeath == "MOD_FALLING" || sMeansOfDeath == "MOD_SUICIDE" )
	{
		return;
	}

	if ( iDamage <= 0 )
	{
		return;
	}

	if ( !IsDefined( eInflictor ) && !IsDefined( eAttacker ) )
	{
		return;
	}

	if ( !IsDefined( eInflictor ) )
	{
		eInflictor = eAttacker;
	}

	if ( eInflictor.classname == "script_vehicle" )
	{
		// ignore vehicle entities (rc bomb, choppers)
		return;
	}

	if ( IsDefined( eInflictor.classname ) && eInflictor.classname == "auto_turret" )
	{
		eAttacker = eInflictor;
	}

	if ( IsDefined( eAttacker ) )
	{
		if ( level.teamBased && IsDefined( eAttacker.team ) )
		{
			if ( level.hardcoreMode && eAttacker.team == self.team )
			{
				if ( cointoss() && iDamage > 5 )
				{
				}
				else
				{
					return;
				}
			}
			else if ( eAttacker.team == self.team )
			{
				return;
			}
		}

		self bot_cry_for_help( eAttacker );
		self SetAttacker( eAttacker );
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
		self SetScriptEnemy( attacker );
		self thread turret_path_monitor( attacker );
		return;
	}

	dir = VectorNormalize( attacker.origin - self.origin );
	dir = VectorScale( dir, 128 );

	goal = self.origin + dir;
	goal = ( goal[0], goal[1], self.origin[2] + 50 );

	//DebugStar( goal, 100, ( 1, 0, 0 ) );

	self SetScriptGoal( goal, 128 );

	wait( 1 );

	self ClearScriptGoal();
}

bot_revive_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	if ( self bot_has_perk( "specialty_noname" ) )
	{
		self SetPerk( "specialty_killstreak" );
		self SetPerk( "specialty_fastreload" );
		self SetPerk( "specialty_fastads" );
		self SetPerk( "specialty_gpsjammer" );
	}

	if ( !level.teamBased )
	{
		return;
	}

	for ( ;; )
	{
		wait( randomintrange( 3, 5 ) );

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

			if ( player.team != self.team )
			{
				continue;
			}

			if ( !IsDefined( player.revivetrigger ) )
			{
				player.bots = 0;
				continue;
			}

			if ( !IsDefined( player.bots ) )
			{
				player.bots = 0;
			}

			if ( player.bots >= 1 )
			{
				continue;
			}

			if ( DistanceSquared( self.origin, player.origin ) < 2048 * 2048 )
			{
				self SetScriptGoal( player.origin, 32 );
				player.bots++;
				self waittill_any( "goal", "bad_path" );

				if ( IsDefined( player ) && IsDefined( player.revivetrigger ) && self IsTouching( player.revivetrigger ) )
				{
					self PressUseButton( GetDvarint( "revive_time_taken" ) + 1 );
					wait( GetDvarint( "revive_time_taken" ) + 1.5 );
				}

				self ClearScriptGoal();
				break;
			}
		}
	}
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

		if ( !self bot_is_idle() )
		{
			continue;
		}

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

		self SetScriptGoal( origin, 100 );
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

			self ClearScriptGoal();
			continue;
		}

		self SetScriptGoal( self.origin, 100 );

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

		self ClearScriptGoal();
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
			self SetScriptGoal( turret.origin, 32 );

			path = self waittill_any_return( "goal", "bad_path" );

			if ( path == "goal" )
			{
				hackTime = GetDvarfloat( "perk_disarmExplosiveTime" );
				self PressUseButton( hackTime + 0.5 );
				wait( hackTime + 0.5 );
				self ClearScriptGoal();
				continue;
			}
		}
		else if ( !facing )
		{
			self thread turret_path_monitor( turret );
			self SetScriptGoal( turret.origin, 64 );
			self waittill_any_return( "goal", "bad_path" );
			self ClearScriptGoal();
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

		self SetScriptEnemy( turret );
		turret waittill_any( "turret_carried", "turret_deactivated", "death" );
		self ClearScriptEnemy();
	}
}

bot_killstreak_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	myteam = self.pers[ "team" ];

	wait( 1 );

	for ( ;; )
	{
		wait( RandomIntRange( 3, 5 ) );

		if ( self IsRemoteControlling() )
		{
			continue;
		}

	/#
		if ( !GetDvarInt( "scr_botsAllowKillstreaks" ) )
		{
			continue;
		}
	#/

		weapons = self GetWeaponsList();
		weapons = array_randomize( weapons );

		foreach( weapon in weapons )
		{
			if ( isKillstreakWeapon( weapon ) )
			{
				break;
			}
		}

		if ( !IsDefined( weapon ) || weapon == "none" )
		{
			continue;
		}

		if ( !isKillstreakWeapon( weapon ) )
		{
			continue;
		}

		killstreak = maps\mp\killstreaks\_killstreaks::getKillstreakForWeapon( weapon );

		if ( ( weapon != self GetInventoryWeapon() ) && ( self.momentum < level.killstreaks[ killstreak ].momentumCost ) )
		{
			wait( RandomIntRange( 3, 5 ) );
			continue;
		}
				
		killstreak = maps\mp\killstreaks\_killstreaks::getKillStreakMenuName( killstreak );

		if ( !IsDefined( killstreak ) )
		{
			continue;
		}

/*
		id = self maps\mp\killstreaks\_killstreaks::getTopKillstreakUniqueId();

		if ( !self maps\mp\killstreaks\_killstreakrules::isKillstreakAllowed( weapon, myteam ) )
		{
			wait( 5 );
			continue;
		}
*/

		switch( killstreak )
		{
			case "killstreak_helicopter_comlink":
			case "killstreak_napalm":
			case "killstreak_airstrike":
				bot_killstreak_location( 1, weapon );
				break;

			case "killstreak_mortar":
			case "killstreak_planemortar":
				bot_killstreak_location( 3, weapon );
				break;

			case "killstreak_auto_turret_drop":
			case "killstreak_tow_turret_drop":
				self bot_use_supply_drop( weapon );
				break;

			case "killstreak_supply_drop":
				self bot_use_supply_drop( "supplydrop_mp" );
				break;

			case "killstreak_auto_turret":
			case "killstreak_tow_turret":
				self bot_turret_location( weapon );
				break;

			case "killstreak_rcbomb":
				if ( IsDefined( self GetThreat() ) )
				{
					continue;
				}

				if ( self GetLookaheadDist() < 128 )
				{
					continue;
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

				self SwitchToWeapon( weapon );
				self thread bot_rccar_think();
				break;

			case "killstreak_ai_tank_drop":
				self SwitchToWeapon( weapon );
				self waittill( "weapon_change_complete" );
				self PressAttackButton();
				break;

			case "killstreak_spyplane":
			case "killstreak_counteruav":
			case "killstreak_dogs":
			case "killstreak_spyplane_direction":
			default:
				self SwitchToWeapon( weapon );
				self waittill( "weapon_change" );
				break;
		}

		// crazy fail-safe
		wait( 0.05 );
		if ( self GetCurrentWeapon() == weapon )
		{
			self SwitchToWeapon( self.lastNonKillstreakWeapon );
		}
	}
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

		if ( !IsDefined( self.rcbomb ) )
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

			if ( bot_get_difficulty() == "easy" )
			{
				if ( DistanceSquared( self.rcbomb.origin, player.origin ) < 512 * 512 )
				{
					self PressAttackButton();
				}
			}
			else if ( DistanceSquared( self.rcbomb.origin, player.origin ) < 200 * 200 )
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

		if ( !IsDefined( self.rcbomb ) )
		{
			return;
		}

		if ( DistanceSquared( og_origin, self.rcbomb.origin ) < 16 * 16 )
		{
			wait( 2 );

			if ( !IsDefined( self.rcbomb ) )
			{
				return;
			}

			if ( DistanceSquared( og_origin, self.rcbomb.origin ) < 16 * 16 )
			{
				self PressAttackButton();
			}
		}

		og_origin = self.rcbomb.origin;
	}
}

bot_turret_location( weapon )
{
	for ( ;; )
	{
		wait( 0.5 );

		if ( !self bot_is_idle() )
		{
			continue;
		}

		if ( self GetLookaheadDist() < 256 )
		{
			continue;
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

		yaw = ( 0, self.angles[1], 0 );
		dir = AnglesToForward( yaw );
		dir = VectorNormalize( dir );

		goal = self.origin + VectorScale( dir, 32 );

		if ( weapon == "autoturret_mp" && bot_get_difficulty() != "easy" )
		{
			eye = self.origin + ( 0, 0, 60 );
			goal = eye + VectorScale( dir, 1024 );

			if ( !SightTracePassed( self.origin, goal, false, undefined ) )
			{
				continue;
			}
		}

		if ( weapon == "auto_tow_mp" )
		{
			end = goal + ( 0, 0, 2048 );
		
			if ( !SightTracePassed( goal, end, false, undefined ) )
			{
				continue;
			}
		}

		self thread weapon_switch_failsafe();
		self SwitchToWeapon( weapon );
		self waittill( "weapon_change_complete" );
		self freeze_player_controls( true );

		wait( 1 );
		self freeze_player_controls( false );
		bot_use_item( weapon );
		self SwitchToWeapon( self.lastNonKillstreakWeapon );
		return;
	}
}

bot_use_supply_drop( weapon )
{
	wait_time = 1;

	for ( ;; )
	{
		wait( wait_time );
		wait_time = 1;

		if ( !self HasWeapon( weapon ) )
		{
			return;
		}

		if ( !self bot_is_idle() )
		{
			continue;
		}

		if ( self GetLookaheadDist() < 96 )
		{
			continue;
		}

		view_angles = self GetPlayerAngles();

		if ( view_angles[0] < 7 )
		{
			continue;
		}

		dir = self GetLookaheadDir();

		if ( !IsDefined( dir ) )
		{
			continue;
		}

		dir = VectorToAngles( dir );

		if ( abs( dir[1] - self.angles[1] ) > 2 )
		{
			continue;
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
			continue;
		}

		if ( !SightTracePassed( self.origin, end, false, undefined ) )
		{
			continue;
		}

		// is this point in mid-air?
		end = drop_point - ( 0, 0, 32 );
		//DebugStar( end, 500, ( 1, 0, 0 ) );
		if ( BulletTracePassed( drop_point, end, false, undefined ) )
		{
			wait_time = 0.1;
			continue;
		}

		goal = self.origin + VectorScale( dir, 64 );
		//DebugStar( goal, 500, ( 0, 1, 0 ) );

		self SetScriptGoal( goal, 128 );
		self waittill_any( "goal", "bad_path" );

		if ( self GetCurrentWeapon() != weapon )
		{
			self thread weapon_switch_failsafe();
			self SwitchToWeapon( weapon );
			self waittill( "weapon_change_complete" );
		}

		bot_use_item( weapon );
		self SwitchToWeapon( self.lastNonKillstreakWeapon );

		self wait_endon( RandomIntRange( 10, 15 ), "bot_crate_landed" );
		self ClearScriptGoal();

		self notify( "my_crate_landed" );

		return;
	}
}

bot_killstreak_location( num, weapon )
{
	self SwitchToWeapon( weapon );
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
	myteam = self.pers[ "team" ];

	for ( i = 0; i < num; i++ )
	{
		wait( 0.05 );
		player = Random( GET_PLAYERS() );

		if ( player.sessionstate != "playing" )
		{
			i--;
			continue;
		}

		if ( player == self )
		{
			i--;
			continue;
		}

		if ( level.teambased )
		{
			if ( myteam == player.team )
			{
				i--;
				continue;
			}
		}

		x = RandomIntRange( -512, 512 );
		y = RandomIntRange( -512, 512 );

		origin = player.origin;
		origin = origin + ( x, y, 0 );
		yaw = RandomIntRange( 0, 360 );

		wait( 0.25 );
		self notify( "confirm_location", origin, yaw );
	}

	self freeze_player_controls( false );
}

bot_dogs_think()
{
	self endon( "death" );
	self endon( "disconnect" );
	level endon ( "game_ended" );

	myteam = self.pers[ "team" ];

	if ( level.no_dogs )
	{
		return;
	}

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
				self SetScriptEnemy( dog );
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
				self SetScriptEnemy( tank );
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

		if ( !self bot_is_idle() )
		{
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

			self SetScriptEnemy( enemy );
			self bot_vehicle_attack( enemy );
			self ClearScriptEnemy();
			break;
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
	weapons[0] = "m72_law_mp";
	weapons[1] = "strela_mp";
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

	self ClearScriptGoal();
	self ClearScriptEnemy();
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
				self SetScriptGoal( player.origin, 64 );
				self waittill_any( "goal", "bad_path" );
				self ClearScriptGoal();
			}
		}
	}
}

bot_use_item( weapon )
{
	self PressAttackButton();
	wait( 0.5 );

	for ( i = 0; i < 5; i++ )
	{
		if ( self GetCurrentWeapon() == weapon || self GetCurrentWeapon() == "none" )
		{
			self PressAttackButton();
		}

		wait( 0.25 );
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

		if ( !self bot_is_idle() )
		{
			continue;
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

		self SetScriptGoal( goal, 128 );
		self waittill_any( "goal", "bad_path" );

		if ( equipment_nearby( self.origin ) )
		{
			self ClearScriptGoal();
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
			self ClearScriptGoal();
			continue;
		}

		self bot_use_item( weapon );
		self ClearScriptGoal();
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

		if ( !self bot_is_idle() )
		{
			continue;
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
			if ( self HasPerk( "specialty_disarmexplosive" ) &&  !(self IsEMPJammed()) && target.name != "claymore_mp" )
			{
				self SetScriptGoal( target.origin, 32 );
				path = self waittill_any_return( "goal", "bad_path" );

				if ( path == "goal" )
				{
					hackTime = GetDvarFloat( "perk_disarmExplosiveTime" );
					self PressUseButton( hackTime + 0.5 );
					wait( hackTime + 0.5 );
					self ClearScriptGoal();
					continue;
				}
			}

			self SetScriptEnemy( target );
			wait( RandomIntRange( 7, 10 ) );
			self ClearScriptEnemy();
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

	self ClearScriptGoal();
	self notify( "weapon_change_complete" );
}

bot_has_perk( perk )
{
	return false;
}

bot_radiation_think()
{
	self endon( "death" );
	self endon( "disconnect" );

	if ( level.script != "mp_radiation" )
	{
		return;
	}

	if ( level.wagerMatch )
	{
		return;
	}

	origins = [];
	origins[0] = ( 813, 5, 267 );
	origins[1] = ( -811, 30, 363 );

	for ( ;; )
	{
		wait( RandomIntRange( 5, 10 ) );

		origin = random( origins );

		if ( DistanceSquared( self.origin, origin ) < 256 * 256 )
		{
			self SetScriptGoal( origin, 32 );

			event = self waittill_any_return( "goal", "bad_path" );

			if ( event == "goal" )
			{
				self PressUseButton( 3 );
				wait( 3 );
				self ClearScriptGoal();
				wait( RandomIntRange( 5, 10 ) );
			}
		}
	}
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
				SetDvar( "sv_botsAllowMovement", "0" );
				self ClearScriptGoal();
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
			team = getOtherTeam( player.team );

			devgui_bot_spawn( team );
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
		SetDvar( "sv_botsAllowMovement", "1" );
		SetDvar( "sv_botsIgnoreHumans", "1" );
		SetDvar( "sv_botsForceStand", "1" );
	
		// Trace to where the player is looking
		player = GetHostPlayer();
		direction = player GetPlayerAngles();
		direction_vec = AnglesToForward( direction );
		eye = player GetEye();

		scale = 8000;
		direction_vec = ( direction_vec[0] * scale, direction_vec[1] * scale, direction_vec[2] * scale );
		trace = bullettrace( eye, eye + direction_vec, 0, undefined );

		origin = trace[ "position" ] + ( 0, 0, 0 );

		if ( DistanceSquared( self.origin, origin ) > 128 * 128 )
		{
			self ClearScriptGoal();
			self SetScriptGoal( origin, 32 );
		}
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
		SetDvar( "sv_botsAllowMovement", "1" );
		SetDvar( "sv_botsPressAttackBtn", "1" );
		SetDvar( "sv_botsPressMeleeBtn", "1" );
		SetDvar( "sv_botsIgnoreHumans", "0" );
		SetDvar( "scr_botsHasPlayerWeapon", "0" );
		SetDvar( "scr_botsGrenadesOnly", "0" );
		SetDvar( "scr_botsSpecialGrenadesOnly", "0" );
#/
	
	level thread bot_spawner_think();
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
		countAllies = 0;
		countAxis = 0;
		
		if( IsDefined( level.botsCount["axis"] ) )
			countAxis = level.botsCount["axis"];
	
		if( IsDefined( level.botsCount["allies"] ) )			
			countAllies = level.botsCount["allies"];
			
		num = GetDvarint( "scr_bots_managed_all" );
	
		if ( num > 0 )
		{
			axis_num = Ceil( num / 2 );
			allies_num = Floor( num / 2 );
		}
		else
		{
			axis_num = GetDvarint( "scr_bots_managed_axis" );
			allies_num = GetDvarint( "scr_bots_managed_allies" );
		}
		
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
		
		// got humans so add or remove bots as needed
		// positive = add ---- negative = kick
		differenceAxis = axis_num - countAxis; 
		differenceAllies = allies_num - countAllies;
		
		if( differenceAxis == 0 && differenceAllies == 0 )
		{
			continue;
		}
		
		
		if( differenceAxis < 0 )
		{
/#
		PrintLn("Updating bots kick axis: " + differenceAxis );
#/			
			players = level.players;
			for ( i = 0; i < players.size; i++ )
			{
				if( differenceAxis >= 0 )
					break;
	
				player = players[i];
				
				if( !IsDefined( player.pers[ "isBot" ] ) )
					continue;
				
				if( "axis" == player.team )
				{
					kick( player getEntityNumber() );
					differenceAxis = differenceAxis + 1;
					wait(0.25);
				}
			}	// for ( i = 0; i < players.size; i++ )				
		}
		else // if( differenceAxis < 0 )
		{
/#
			PrintLn("Updating bots add axis: " + differenceAxis );
#/			
			for( ; differenceAxis > 0; differenceAxis = differenceAxis - 1 )
			{
				wait( 0.25 );
				bot = AddTestClient();
		
				if ( !IsDefined( bot ) )
				{
					continue;
				}
							
				bot.pers[ "isBot" ] = true;
				bot.equipment_enabled = false;
				bot thread bot_spawn_think( "axis" );
			} // while ( spawned_bots < differenceAxis )
		} // else // if( differenceAxis < 0 )
		
		if( differenceAllies < 0 )
		{
/#
			PrintLn("Updating bots kick allies: " + differenceAllies );
#/	
			players = level.players;
			for ( i = 0; i < players.size; i++ )
			{
				if( differenceAllies >= 0 )
					break;
	
				player = players[i];
				
				if( !IsDefined( player.pers[ "isBot" ] ) )
					continue;
				
				if( "allies" == player.team )
				{
					kick( player getEntityNumber() );
					differenceAllies = differenceAllies + 1;
					wait(0.25);
				}				
			} // for ( i = 0; i < players.size; i++ )
		}
		else // if( differenceAllies < 0 )
		{
/#
			PrintLn("Updating bots add allies: " + differenceAllies );
#/			
			for( ; differenceAllies > 0; differenceAllies = differenceAllies - 1 )
			{
				wait( 0.25 );
				bot = AddTestClient();
		
				if ( !IsDefined( bot ) )
				{
					continue;
				}
							
				bot.pers[ "isBot" ] = true;
				bot.equipment_enabled = false;
				bot thread bot_spawn_think( "allies" );
			}	// while ( spawned_bots < differenceAllies )		
		} // else // if( differenceAllies < 0 )
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
	bot.equipment_enabled = false;
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