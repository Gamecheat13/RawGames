#include common_scripts\utility;
#include maps\mp\_utility;

init()
{
	/#
	
	//Todo for Zombies
	if( SessionModeIsZombiesGame() )
	{
		for(;;)
		{
			updateDevSettingsZm();
			wait .5;
		}
		return;
	}
		
	if (GetDvar( "scr_showspawns") == "")
	{
		SetDvar("scr_showspawns", "0");
	}
	if (GetDvar( "scr_showstartspawns") == "")
	{
		SetDvar("scr_showstartspawns", "0");
	}
	if (GetDvar( "scr_botsHasPlayerWeapon") == "")
	{
		SetDvar("scr_botsHasPlayerWeapon", "0");
	}
	if (GetDvar( "scr_botsGrenadesOnly") == "")
	{
		SetDvar("scr_botsGrenadesOnly", "0");
	}
	if (GetDvar( "scr_botsSpecialGrenadesOnly") == "")
	{
		SetDvar("scr_botsSpecialGrenadesOnly", "0");
	}
	if (GetDvar( "scr_devHeliPathsDebugDraw") == "")
	{
		SetDvar("scr_devHeliPathsDebugDraw", "0");
	}
	if (GetDvar( "scr_devStrafeRunPathDebugDraw") == "")
	{
		SetDvar("scr_devStrafeRunPathDebugDraw", "0");
	}
	if (GetDvar( "scr_show_hq_spawns") == "")
	{
		SetDvar("scr_show_hq_spawns", "");
	}
	
	precacheModel("defaultactor");

	thread addTestClients();
	thread addEnemyHeli();
	thread addEnemyU2();
	thread addTestCarePackage();
	thread removeTestClients();
	thread watch_botsdvars();
	thread devHeliPathDebugDraw();
	thread devStrafeRunPathDebugDraw();
	thread maps\mp\gametypes\_dev_class::dev_cac_init();
	thread maps\mp\gametypes\_globallogic_score::setPlayerMomentumDebug();

	
	SetDvar( "scr_giveperk", "" );
	SetDvar( "scr_forceevent", "" );
	SetDvar( "scr_draw_triggers", "0" );

	// SRS 3/19/08: engagement distance debug dvar toggle watcher
	thread engagement_distance_debug_toggle();
	
	// give equipment through devgui
	thread equipment_dev_gui();
	
	// give grenades through devgui
	thread grenade_dev_gui();

	SetDvar( "debug_dynamic_ai_spawning", "0" );
	level.bot_overlay = false;
	level.bot_threat = false;
	level.bot_path = false;

	level.dem_spawns = [];
	
	if ( level.gametype == "dem" )
	{
		extra_spawns = [];
		extra_spawns[0] = "mp_dem_spawn_attacker_a";
		extra_spawns[1] = "mp_dem_spawn_attacker_b";
		extra_spawns[2] = "mp_dem_spawn_defender_a";
		extra_spawns[3] = "mp_dem_spawn_defender_b";

		for ( i = 0; i < extra_spawns.size; i++ )
		{
			points = GetEntArray( extra_spawns[i], "classname" );

			if ( IsDefined( points ) && points.size > 0 )
			{
				level.dem_spawns = ArrayCombine( level.dem_spawns, points, true, false );
			}
		}
	}
	
	thread onPlayerConnect();

	for(;;)
	{
		updateDevSettings();
		wait .5;
	}
	#/
}

onPlayerConnect()
{
/#
	for(;;)
	{
		level waittill ( "connecting", player );


		player thread watchAttachmentChange();
	}
#/
}

/#
updateHardpoints()
{
	keys = getarraykeys( level.killstreaks );
	for ( i = 0; i < keys.size; i++ )
	{
		if ( !IsDefined(level.killstreaks[keys[i]].devDvar) )
			continue;
			
		dvar = level.killstreaks[keys[i]].devDvar;
	
		if ( getdvarint(dvar) == 1 )
		{
			foreach ( player in level.players )
			{
				if ( IsDefined( level.usingMomentum ) && level.usingMomentum && IsDefined( level.usingScoreStreaks ) && level.usingScoreStreaks )
				{
					player maps\mp\killstreaks\_killstreaks::giveKillstreak( keys[i] );
				}
				else
				{
					if ( player is_bot() )
					{
						player.bot[ "killstreaks" ] = [];
						player.bot[ "killstreaks" ][0] = maps\mp\killstreaks\_killstreaks::getKillStreakMenuName( keys[i] );

						killstreakWeapon = maps\mp\killstreaks\_killstreaks::getKillstreakWeapon( keys[i] );
						player maps\mp\killstreaks\_killstreaks::giveKillstreakWeapon( killstreakWeapon, true );

						maps\mp\gametypes\_globallogic_score::_setPlayerMomentum( player, 2000 );
					}
					else
					{
						player maps\mp\killstreaks\_killstreaks::giveKillstreak( keys[i] );
					}
				}
			}
			setdvar( dvar, "0" );
		}
	}
}

warpAllToHost( team )
{
		host = getHostPlayer();
		
		players = GET_PLAYERS();
		origin = host.origin;

		nodes = GetNodesInRadius( origin, 128, 32, 128, "Path" );
		
		angles = host GetPlayerAngles();
		yaw	= ( 0.0, angles[1], 0.0 );

		forward = AnglesToForward( yaw );

		spawn_origin = origin + ( forward * 128 ) + ( 0, 0, 16 );

		if ( !BulletTracePassed( host GetEye(), spawn_origin, false, host ) )
		{
			spawn_origin = undefined;
		}

		for ( i = 0 ; i < players.size ; i++ )
		{
			if ( players[i] == host )
			{
				continue;
			}

			if ( IsDefined(team) )
			{
				if ( team == "enemies_host" && host.team == players[i].team )
					continue;
				if ( team == "friendlies_host" && host.team != players[i].team )
					continue;
			}

			if ( IsDefined( spawn_origin ) )
			{
				players[i] SetOrigin( spawn_origin );
			}
			else if ( nodes.size > 0 )
			{
				node = random( nodes );
				players[i] SetOrigin( node.origin );
			}
			else
			{
				players[i] SetOrigin( origin );
			}
			
		}
		SetDvar( "scr_playerwarp", "" );
}

updateDevSettingsZm()
{
	if( level.players.size > 0 )
	{
		if( GetDvar( "r_streamDumpDistance" ) == "3" )
		{
			if(!IsDefined(level.streamDumpTeamIndex))
			{
				level.streamDumpTeamIndex = 0;
			}
			else
			{
				level.streamDumpTeamIndex++;
			}

			numPoints = 0;
			spawnPoints = [];
			location = level.scr_zm_map_start_location;
			if ((location == "default" || location == "" ) && IsDefined(level.default_start_location))
			{
				location = level.default_start_location;
			}		
			match_string = level.scr_zm_ui_gametype + "_" + location;
			if( level.streamDumpTeamIndex < level.teams.size )
			{
				// zombies
				structs = getstructarray("initial_spawn", "script_noteworthy");
				if(IsDefined(structs))
				{
					foreach(struct in structs)			
					{
						if(IsDefined(struct.script_string) )
						{
							tokens = strtok(struct.script_string," ");
							foreach(token in tokens)
							{
								if(token == match_string )
								{
									spawnPoints[spawnPoints.size] =	struct;
								}
							}
						}
					
					}			
				}
				if(!IsDefined(spawnPoints) || spawnPoints.size == 0) // old method, failed new method.
				{
					spawnPoints = getstructarray("initial_spawn_points", "targetname");
				}
				if( IsDefined(spawnPoints) )
				{
					numPoints = spawnPoints.size;
				}
			}
			if( numPoints == 0 )
			{
				SetDvar("r_streamDumpDistance","0");
				level.streamDumpTeamIndex = -1;
			}
			else
			{
				averageOrigin = ( 0, 0, 0 );
				averageAngles = ( 0, 0, 0 );
				foreach( spawnpoint in spawnPoints )
				{
					averageOrigin += spawnpoint.origin / numPoints;
					averageAngles += spawnpoint.angles / numPoints;
					// averageOrigin = spawnpoint.origin;
					// averageAngles = spawnpoint.angles;
					// break;
				}
				level.players[0] SetPlayerAngles(averageAngles);
				level.players[0] SetOrigin(averageOrigin);
				wait(.05);
				SetDvar("r_streamDumpDistance","2");
			}
		}
	}	
}

updateDevSettings()
{
	show_spawns= GetDvarint( "scr_showspawns");
	show_start_spawns= GetDvarint( "scr_showstartspawns");
	
	player = getHostPlayer();

	if (show_spawns >= 1)
	{
		show_spawns= 1;
	}
	else
	{
		show_spawns= 0;
	}
	
	if (show_start_spawns >= 1)
	{
		show_start_spawns= 1;
	}
	else
	{
		show_start_spawns= 0;
	}
	
	if (!IsDefined(level.show_spawns) || level.show_spawns!=show_spawns)
	{
		level.show_spawns= show_spawns;
		SetDvar("scr_showspawns", level.show_spawns);

		if(level.show_spawns)
		{
			showSpawnpoints();
		}
		else
		{
			hideSpawnpoints();
		}
	}
	
	if (!IsDefined(level.show_start_spawns) || level.show_start_spawns!=show_start_spawns)
	{
		level.show_start_spawns= show_start_spawns;
		SetDvar("scr_showstartspawns", level.show_start_spawns);

		if(level.show_start_spawns)
		{
			showStartSpawnpoints();
		}
		else
		{
			hideStartSpawnpoints();
		}
	}

	updateMinimapSetting();
	
	if( level.players.size > 0 )
	{
		updateHardpoints();
		
		if ( GetDvar( "scr_playerwarp" ) == "host" )
		{
			warpAllToHost();
		}
		else if ( GetDvar( "scr_playerwarp" ) == "enemies_host" )
		{
			warpAllToHost(GetDvar( "scr_playerwarp" ));
		}
		else if ( GetDvar( "scr_playerwarp" ) == "friendlies_host" )
		{
			warpAllToHost(GetDvar( "scr_playerwarp" ));
		}
		else if ( GetDvar( "scr_playerwarp" ) == "next_start_spawn" )
		{
			players = GET_PLAYERS();
			SetDvar( "scr_playerwarp", "" );
			
			if ( !IsDefined( level.devgui_start_spawn_index ) ) 
			{
				level.devgui_start_spawn_index = 0;
			}

			player = getHostPlayer();
			spawns = level.spawn_start[player.pers["team"]];

			if ( !IsDefined( spawns ) || spawns.size <= 0 )
			{
				return;
			}

			for ( i = 0; i < players.size; i++ )
			{
				players[i] SetOrigin( spawns[ level.devgui_start_spawn_index ].origin );
				players[i] SetPlayerAngles( spawns[ level.devgui_start_spawn_index ].angles );
			}

			level.devgui_start_spawn_index++;

			if ( level.devgui_start_spawn_index >= spawns.size )
			{
				level.devgui_start_spawn_index = 0;
			}
		}
		else if ( GetDvar( "scr_playerwarp" ) == "prev_start_spawn" )
		{
			players = GET_PLAYERS();
			SetDvar( "scr_playerwarp", "" );
			
			if ( !IsDefined( level.devgui_start_spawn_index ) ) 
			{
				level.devgui_start_spawn_index = 0;
			}

			player = getHostPlayer();
			spawns = level.spawn_start[player.pers["team"]];

			if ( !IsDefined( spawns ) || spawns.size <= 0 )
			{
				return;
			}

			for ( i = 0; i < players.size; i++ )
			{
				players[i] SetOrigin( spawns[ level.devgui_start_spawn_index ].origin );
				players[i] SetPlayerAngles( spawns[ level.devgui_start_spawn_index ].angles );
			}

			level.devgui_start_spawn_index--;

			if ( level.devgui_start_spawn_index < 0 )
			{
				level.devgui_start_spawn_index = spawns.size - 1;
			}
		}
		else if ( GetDvar( "scr_playerwarp" ) == "next_spawn" )
		{
			players = GET_PLAYERS();
			SetDvar( "scr_playerwarp", "" );
			
			if ( !IsDefined( level.devgui_spawn_index ) ) 
			{
				level.devgui_spawn_index = 0;
			}

			spawns = level.spawnpoints;
			spawns = ArrayCombine( spawns, level.dem_spawns, true, false );

			if ( !IsDefined( spawns ) || spawns.size <= 0 )
			{
				return;
			}

			for ( i = 0; i < players.size; i++ )
			{
				players[i] SetOrigin( spawns[ level.devgui_spawn_index ].origin );
				players[i] SetPlayerAngles( spawns[ level.devgui_spawn_index ].angles );
			}

			level.devgui_spawn_index++;

			if ( level.devgui_spawn_index >= spawns.size )
			{
				level.devgui_spawn_index = 0;
			}
		}
		else if ( GetDvar( "scr_playerwarp" ) == "prev_spawn" )
		{
			players = GET_PLAYERS();
			SetDvar( "scr_playerwarp", "" );
			
			if ( !IsDefined( level.devgui_spawn_index ) ) 
			{
				level.devgui_spawn_index = 0;
			}

			spawns = level.spawnpoints;
			spawns = ArrayCombine( spawns, level.dem_spawns, true, false );

			if ( !IsDefined( spawns ) || spawns.size <= 0 )
			{
				return;
			}

			for ( i = 0; i < players.size; i++ )
			{
				players[i] SetOrigin( spawns[ level.devgui_spawn_index ].origin );
				players[i] SetPlayerAngles( spawns[ level.devgui_spawn_index ].angles );
			}

			level.devgui_spawn_index--;

			if ( level.devgui_spawn_index < 0 )
			{
				level.devgui_spawn_index = spawns.size - 1;
			}
		}
		else if ( GetDvar( "scr_devgui_spawn" ) != "" )
		{
			player = getHostPlayer();

			if ( !IsDefined( player.devgui_spawn_active ) )
			{
				player.devgui_spawn_active = false;
			}
			
			if ( !player.devgui_spawn_active )
			{
				iprintln( "Previous spawn bound to D-Pad Left" );
				iprintln( "Next spawn bound to D-Pad Right" );

				player.devgui_spawn_active = true;
				player thread devgui_spawn_think();
			}
			else
			{
				player notify( "devgui_spawn_think" );
				player.devgui_spawn_active = false;

				player SetActionSlot( 3, "altMode" );
				player SetActionSlot( 4, "nightvision" );
			}

			SetDvar( "scr_devgui_spawn", "" );
		}
		else if ( GetDvar( "scr_player_ammo" ) != "" )
		{
			players = GET_PLAYERS();

			if ( !IsDefined( level.devgui_unlimited_ammo ) )
			{
				level.devgui_unlimited_ammo = true;
			}
			else
			{
				level.devgui_unlimited_ammo = !level.devgui_unlimited_ammo;
			}

			if ( level.devgui_unlimited_ammo )
			{
				iprintln( "Giving unlimited ammo to all players" );
			}
			else
			{
				iprintln( "Stopping unlimited ammo for all players" );
			}

			for ( i = 0; i < players.size; i++ )
			{
				if ( level.devgui_unlimited_ammo )
				{
					players[i] thread devgui_unlimited_ammo();
				}
				else
				{
					players[i] notify( "devgui_unlimited_ammo" );
				}
			}

			SetDvar( "scr_player_ammo", "" );
		}
		else if ( GetDvar( "scr_player_momentum" ) != "" )
		{
			if ( !IsDefined( level.devgui_unlimited_momentum ) )
			{
				level.devgui_unlimited_momentum = true;
			}
			else
			{
				level.devgui_unlimited_momentum = !level.devgui_unlimited_momentum;
			}

			if ( level.devgui_unlimited_momentum )
			{
				iprintln( "Giving unlimited momentum to all players" );
				level thread devgui_unlimited_momentum();
			}
			else
			{
				iprintln( "Stopping unlimited momentum for all players" );
				level notify( "devgui_unlimited_momentum" );
			}

			SetDvar( "scr_player_momentum", "" );
		}
		else if ( GetDvar( "scr_player_zero_ammo" ) != "" )
		{
			players = GET_PLAYERS();

			for ( i = 0; i < players.size; i++ )
			{
				player = players[i];
				
				weapons = player GetWeaponsList();
				ArrayRemoveValue( weapons, "knife_mp" );
		
				for ( j = 0; j < weapons.size; j++ )
				{
					if ( weapons[j] == "none" )
						continue;

					player SetWeaponAmmoStock( weapons[j], 0 );
					player SetWeaponAmmoClip( weapons[j], 0 );
				}
			}

			SetDvar( "scr_player_zero_ammo", "" );
		}
		else if ( GetDvar( "scr_emp_jammed" ) != "" )
		{
			players = GET_PLAYERS();
			
			for ( i = 0; i < players.size; i++ )
			{
				player = players[i];
				
				if ( GetDvar( "scr_emp_jammed" ) == "0" )
				{
					player SetEMPJammed( false );
				}
				else
				{
					player SetEMPJammed( true );
				}
			}

			SetDvar( "scr_emp_jammed", "" );
		}
		else if ( GetDvar( "scr_round_pause" ) != "" )
		{
			if ( !level.timerStopped )
			{
				iprintln( "Pausing Round Timer" );
				maps\mp\gametypes\_globallogic_utils::pauseTimer();
			}
			else
			{
				iprintln( "Resuming Round Timer" );
				maps\mp\gametypes\_globallogic_utils::resumeTimer();
			}

			SetDvar( "scr_round_pause", "" );
		}
		else if ( GetDvar( "scr_round_end" ) != "" )
		{
			level maps\mp\gametypes\_globallogic::forceEnd();
			SetDvar( "scr_round_end", "" );
		}
		else if ( GetDvar( "scr_health_debug" ) != "" )
		{
			players = GET_PLAYERS();	
			host = getHostPlayer();

			if ( !IsDefined( host.devgui_health_debug ) )
			{
				host.devgui_health_debug = false;
			}

			if ( host.devgui_health_debug )
			{
				host.devgui_health_debug = false;

				for ( i = 0; i < players.size; i++ )
				{
					players[i] notify( "devgui_health_debug" );

					if ( IsDefined( players[i].debug_health_bar ) )
					{
						players[i].debug_health_bar destroy();
						players[i].debug_health_text destroy();
						players[i].debug_health_bar = undefined;
						players[i].debug_health_text = undefined;
					}
				}
			}
			else
			{
				host.devgui_health_debug = true;

				for ( i = 0; i < players.size; i++ )
				{
					players[i] thread devgui_health_debug();
				}
			}

			SetDvar( "scr_health_debug", "" );
		}
		else if ( GetDvar( "scr_show_hq_spawns" ) != "" )
		{
			if ( !IsDefined( level.devgui_show_hq ) )
			{
				level.devgui_show_hq = false;
			}
			
			if ( level.gameType == "koth" && IsDefined( level.radios ) )
			{
				if ( !level.devgui_show_hq )
				{
					for ( i = 0; i < level.radios.size; i++ )
					{
						color = ( 1, 0, 0 );
						level showOneSpawnPoint( level.radios[i], color, "hide_hq_points", 32, "hq_spawn" );
					}
				}
				else
				{
					level notify( "hide_hq_points" );
				}
				
				level.devgui_show_hq = !level.devgui_show_hq;
			}

			SetDvar( "scr_show_hq_spawns", "" );
		}

		if( GetDvar( "r_streamDumpDistance" ) == "3" )
		{
			if(!IsDefined(level.streamDumpTeamIndex))
			{
				level.streamDumpTeamIndex = 0;
			}
			else
			{
				level.streamDumpTeamIndex++;
			}

			numPoints = 0;
			if( level.streamDumpTeamIndex < level.teams.size )
			{
				teamName = GetArrayKeys(level.teams)[level.streamDumpTeamIndex];
				if( IsDefined(level.spawn_start[teamName]) )
				{
					numPoints = level.spawn_start[teamName].size;
				}
			}
			if( numPoints == 0 )
			{
				SetDvar("r_streamDumpDistance","0");
				level.streamDumpTeamIndex = -1;
			}
			else
			{
				averageOrigin = ( 0, 0, 0 );
				averageAngles = ( 0, 0, 0 );
				foreach( spawnpoint in level.spawn_start[teamName] )
				{
					averageOrigin += spawnpoint.origin / numPoints;
					averageAngles += spawnpoint.angles / numPoints;
					// averageOrigin = spawnpoint.origin;
					// averageAngles = spawnpoint.angles;
					// break;
				}
				level.players[0] SetPlayerAngles(averageAngles);
				level.players[0] SetOrigin(averageOrigin);
				wait(.05);
				SetDvar("r_streamDumpDistance","2");
			}
		}
	}
	if ( GetDvar( "scr_giveperk") == "0" )
	{
		players = GET_PLAYERS();

		iprintln( "Taking all perks from all players" );

		for ( i = 0; i < players.size; i++ )
		{
			players[i] ClearPerks();
		}

		SetDvar( "scr_giveperk", "" );
	}
	if ( GetDvar( "scr_giveperk") != "" )
	{
		perk = GetDvar( "scr_giveperk");
		specialties = StrTok( perk, "|" );

		players = GET_PLAYERS();

		iprintln( "Giving all players perk: '" + perk + "'" );

		for ( i = 0; i < players.size; i++ )
		{
			for( j = 0; j < specialties.size; j++ )
			{
				players[i] setPerk( specialties[ j ] );
				players[i].extraPerks[ specialties[ j ] ] = 1;
			}
			
		}
		SetDvar( "scr_giveperk", "" );
	}
	if ( GetDvar( "scr_forcegrenade" ) != "" )
	{
		force_grenade_throw( GetDvar( "scr_forcegrenade" ) );
		SetDvar( "scr_forcegrenade", "" );
	}
	if( GetDvar( "scr_forceevent" ) != "" )
	{
		event = GetDvar( "scr_forceevent" );
		player = getHostPlayer();
		forward = anglestoforward( player.angles );
		right = anglestoright( player.angles );
		if( event == "painfront" )
		{
			player DoDamage(1, player.origin+forward);
		}
		else if( event == "painback" )
		{
			player DoDamage(1, player.origin-forward);
		}
		else if( event == "painleft" )
		{
			player DoDamage(1, player.origin-right);
		}
		else if( event == "painright" )
		{
			player DoDamage(1, player.origin+right);
		}
		SetDvar( "scr_forceevent", "" );
	}
	if ( GetDvar( "scr_takeperk") != "" )
	{
		perk = GetDvar( "scr_takeperk");
		for ( i = 0; i < level.players.size; i++ )
		{
			level.players[i] unsetPerk( perk );
			level.players[i].extraPerks[ perk ] = undefined;
		}
		SetDvar( "scr_takeperk", "" );
	}
	
	if ( GetDvar( "scr_x_kills_y" ) != "" )
	{
		nameTokens = strTok( GetDvar( "scr_x_kills_y" ), " " );
		if ( nameTokens.size > 1 )
			thread xKillsY( nameTokens[0], nameTokens[1] );

		SetDvar( "scr_x_kills_y", "" );
	}

	if ( GetDvar( "scr_usedogs") != "" )
	{
		ownerName = GetDvar( "scr_usedogs" );
		SetDvar( "scr_usedogs", "" );

		owner = undefined;
		for ( index = 0; index < level.players.size; index++ )
		{
			if ( level.players[index].name == ownerName )
				owner = level.players[index];
		}
		
		if ( isDefined( owner ) )
			owner maps\mp\killstreaks\_killstreaks::triggerKillstreak( "dogs_mp" );
	}
	
	if ( GetDvar( "scr_set_level" ) != "" )
	{
		player.pers["rank"] = 0;
		player.pers["rankxp"] = 0;
		
		newRank = min( GetDvarint( "scr_set_level" ), 54 );
		newRank = max( newRank, 1 );

		SetDvar( "scr_set_level", "" );

		lastXp = 0;
		for ( index = 0; index <= newRank; index++ )		
		{
			newXp = maps\mp\gametypes\_rank::getRankInfoMinXP( index );
			player thread maps\mp\gametypes\_rank::giveRankXP( "kill", newXp - lastXp );
			lastXp = newXp;
			wait ( 0.25 );
			self notify ( "cancel_notify" );
		}
	}

	if ( GetDvar( "scr_givexp" ) != "" )
	{
		player thread maps\mp\gametypes\_rank::giveRankXP( "challenge", GetDvarint( "scr_givexp" ), true );
		
		SetDvar( "scr_givexp", "" );
	}

	if ( GetDvar( "scr_do_notify" ) != "" )
	{
		for ( i = 0; i < level.players.size; i++ )
			level.players[i] maps\mp\gametypes\_hud_message::oldNotifyMessage( GetDvar( "scr_do_notify" ), GetDvar( "scr_do_notify" ), game["icons"]["allies"] );
		
		announcement( GetDvar( "scr_do_notify" ), 0 );
		SetDvar( "scr_do_notify", "" );
	}	
	if ( GetDvar( "scr_entdebug" ) != "" )
	{
		ents = getEntArray();
		level.entArray = [];
		level.entCounts = [];
		level.entGroups = [];
		for ( index = 0; index < ents.size; index++ )
		{
			classname = ents[index].classname;
			if ( !isSubStr( classname, "_spawn" ) )
			{
				curEnt = ents[index];

				level.entArray[level.entArray.size] = curEnt;
				
				if ( !isDefined( level.entCounts[classname] ) )
					level.entCounts[classname] = 0;
			
				level.entCounts[classname]++;

				if ( !isDefined( level.entGroups[classname] ) )
					level.entGroups[classname] = [];
			
				level.entGroups[classname][level.entGroups[classname].size] = curEnt;
			}
		}
	}

	if( GetDvar( "debug_dynamic_ai_spawning" ) == "1" && !IsDefined( level.larry ) )
	{
		thread larry_thread();
	}
	else if ( GetDvar( "debug_dynamic_ai_spawning" ) == "0" )
	{
		level notify ( "kill_larry" );	
	}

	if ( level.bot_overlay == false && GetDvarint( "scr_bot_overlay" ) == 1 )
	{
		level thread bot_overlay_think();
		level.bot_overlay = true;
	}
	else if ( level.bot_overlay == true && GetDvarint( "scr_bot_overlay" ) == 0 )
	{
		level bot_overlay_stop();
		level.bot_overlay = false;
	}

	if ( level.bot_threat == false && GetDvarint( "scr_bot_threat" ) == 1 )
	{
		level thread bot_threat_think();
		level.bot_threat = true;
	}
	else if ( level.bot_threat == true && GetDvarint( "scr_bot_threat" ) == 0 )
	{
		level bot_threat_stop();
		level.bot_threat = false;
	}

	if ( level.bot_path == false && GetDvarint( "scr_bot_path" ) == 1 )
	{
		level thread bot_path_think();
		level.bot_path = true;
	}
	else if ( level.bot_path == true && GetDvarint( "scr_bot_path" ) == 0 )
	{
		level bot_path_stop();
		level.bot_path = false;
	}

	if ( !level.bot_overlay && !level.bot_threat && !level.bot_path )
	{
		level notify( "bot_dpad_terminate" );
	}
}


devgui_spawn_think()
{
	self notify( "devgui_spawn_think" );
	self endon( "devgui_spawn_think" );
	self endon( "disconnect" );

	dpad_left = false;
	dpad_right = false;

	for ( ;; )
	{
		self SetActionSlot( 3, "" );
		self SetActionSlot( 4, "" );

		if ( !dpad_left && self ButtonPressed( "DPAD_LEFT" ) )
		{
			SetDvar( "scr_playerwarp", "prev_spawn" );
			dpad_left = true;
		}
		else if ( !self ButtonPressed( "DPAD_LEFT" ) )
		{
			dpad_left = false;
		}

		if ( !dpad_right && self ButtonPressed( "DPAD_RIGHT" )  )
		{
			SetDvar( "scr_playerwarp", "next_spawn" );
			dpad_right = true;
		}
		else if ( !self ButtonPressed( "DPAD_RIGHT" ) )
		{
			dpad_right = false;
		}

		wait( 0.05 );
	}
}

devgui_unlimited_ammo()
{
	self notify( "devgui_unlimited_ammo" );
	self endon( "devgui_unlimited_ammo" );
	self endon( "disconnect" );

	for ( ;; )
	{
		wait( 0.1 );

		weapons = [];
		weapons[0] = self GetCurrentWeapon();
		weapons[1] = self GetCurrentOffhand();
		
		for ( i = 0; i < weapons.size; i++ )
		{
			if ( weapons[i] == "none" )
				continue;
			
			if ( maps\mp\killstreaks\_killstreaks::isKillstreakWeapon( weapons[i] ) )
				continue;
				
			self GiveMaxAmmo( weapons[i] );
		}
	}
}

devgui_unlimited_momentum()
{
	level notify( "devgui_unlimited_momentum" );
	level endon( "devgui_unlimited_momentum" );

	for ( ;; )
	{
		wait( 1 );

		players = GET_PLAYERS();

		foreach( player in players )
		{
			if ( !IsDefined( player ) )
			{
				continue;
			}

			if ( !IsAlive( player ) )
			{
				continue;
			}

			if ( player.sessionstate != "playing" )
			{
				continue;
			}

			maps\mp\gametypes\_globallogic_score::_setPlayerMomentum( player, 5000 );
		}
	}
}

devgui_health_debug()
{
	self notify( "devgui_health_debug" );
	self endon( "devgui_health_debug" );
	self endon( "disconnect" );
	
	x = 80;
	y = 40;

	self.debug_health_bar = NewClientHudElem( self );
	self.debug_health_bar.x = x + 80;
	self.debug_health_bar.y = y + 2;
	self.debug_health_bar.alignX = "left";
	self.debug_health_bar.alignY = "top";
	self.debug_health_bar.horzAlign = "fullscreen";
	self.debug_health_bar.vertAlign = "fullscreen";
	self.debug_health_bar.alpha = 1;
	self.debug_health_bar.foreground = 1;
	self.debug_health_bar setshader( "black", 1, 8 );

	self.debug_health_text = NewClientHudElem( self );
	self.debug_health_text.x = x + 80;
	self.debug_health_text.y = y;
	self.debug_health_text.alignX = "left";
	self.debug_health_text.alignY = "top";
	self.debug_health_text.horzAlign = "fullscreen";
	self.debug_health_text.vertAlign = "fullscreen";
	self.debug_health_text.alpha = 1;
	self.debug_health_text.fontScale = 1;
	self.debug_health_text.foreground = 1;
	
	for ( ;; )
	{
		wait ( 0.05 );

		width = self.health / self.maxhealth * 300;
		width = int( max( width, 1 ) );
		self.debug_health_bar setShader( "black", width, 8 );

		self.debug_health_text SetValue( self.health );
	}
}

giveExtraPerks()
{
	if ( !isdefined( self.extraPerks ) )
		return;
	
	perks = getArrayKeys( self.extraPerks );
	
	for ( i = 0; i < perks.size; i++ )
		self setPerk( perks[i] );
}

xKillsY( attackerName, victimName )
{
	attacker = undefined;
	victim = undefined;
	
	for ( index = 0; index < level.players.size; index++ )
	{
		if ( level.players[index].name == attackerName )
			attacker = level.players[index];
		else if ( level.players[index].name == victimName )
			victim = level.players[index];
	}
	
	if ( !isAlive( attacker ) || !isAlive( victim ) )
		return;
		
	victim thread [[level.callbackPlayerDamage]](
		attacker, // eInflictor The entity that causes the damage.(e.g. a turret)
		attacker, // eAttacker The entity that is attacking.
		1000, // iDamage Integer specifying the amount of damage done
		0, // iDFlags Integer specifying flags that are to be applied to the damage
		"MOD_RIFLE_BULLET", // sMeansOfDeath Integer specifying the method of death
		"none", // sWeapon The weapon number of the weapon used to inflict the damage
		(0,0,0), // vPoint The point the damage is from?
		(0,0,0), // vDir The direction of the damage
		"none", // sHitLoc The location of the hit
		0 // psOffsetTime The time offset for the damage
	);
}


updateMinimapSetting()
{	
	// use 0 for no required map aspect ratio.
	requiredMapAspectRatio = GetDvarfloat( "scr_requiredMapAspectRatio");
	
	if (!isdefined(level.minimapheight)) {
		SetDvar("scr_minimap_height", "0");
		level.minimapheight = 0;
	}
	minimapheight = GetDvarfloat( "scr_minimap_height");
	if (minimapheight != level.minimapheight)
	{
		if ( minimapheight <= 0 )
		{
			GetHostPlayer() CameraActivate( false );	
			level.minimapheight = minimapheight;
			level notify("end_draw_map_bounds");
		}
		
		if (minimapheight > 0)
		{
			level.minimapheight = minimapheight;
			
			players = GET_PLAYERS();
			if (players.size > 0)
			{
				player = getHostPlayer();
				
				corners = getentarray("minimap_corner", "targetname");
				if (corners.size == 2)
				{
					viewpos = (corners[0].origin + corners[1].origin);
					viewpos = (viewpos[0]*.5, viewpos[1]*.5, viewpos[2]*.5);

					level thread minimapWarn( corners );

					maxcorner = (corners[0].origin[0], corners[0].origin[1], viewpos[2]);
					mincorner = (corners[0].origin[0], corners[0].origin[1], viewpos[2]);
					if (corners[1].origin[0] > corners[0].origin[0])
						maxcorner = (corners[1].origin[0], maxcorner[1], maxcorner[2]);
					else
						mincorner = (corners[1].origin[0], mincorner[1], mincorner[2]);
					if (corners[1].origin[1] > corners[0].origin[1])
						maxcorner = (maxcorner[0], corners[1].origin[1], maxcorner[2]);
					else
						mincorner = (mincorner[0], corners[1].origin[1], mincorner[2]);
					
					viewpostocorner = maxcorner - viewpos;
					viewpos = (viewpos[0], viewpos[1], viewpos[2] + minimapheight);
					
					northvector = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
					eastvector = (northvector[1], 0 - northvector[0], 0);
					disttotop = vectordot(northvector, viewpostocorner);
					if (disttotop < 0)
						disttotop = 0 - disttotop;
					disttoside = vectordot(eastvector, viewpostocorner);
					if (disttoside < 0)
						disttoside = 0 - disttoside;
					
					// extend map bounds to meet the required aspect ratio
					if ( requiredMapAspectRatio > 0 )
					{
						mapAspectRatio = disttoside / disttotop;
						if ( mapAspectRatio < requiredMapAspectRatio )
						{
							incr = requiredMapAspectRatio / mapAspectRatio;
							disttoside *= incr;
							addvec = vecscale( eastvector, vectordot( eastvector, maxcorner - viewpos ) * (incr - 1) );
							mincorner -= addvec;
							maxcorner += addvec;
						}
						else
						{
							incr = mapAspectRatio / requiredMapAspectRatio;
							disttotop *= incr;
							addvec = vecscale( northvector, vectordot( northvector, maxcorner - viewpos ) * (incr - 1) );
							mincorner -= addvec;
							maxcorner += addvec;
						}
					}
					
					if ( level.console )
					{
						aspectratioguess = 16.0/9.0;
						// .8 would be .75 but it needs to be bigger because of safe area
						angleside = 2 * atan(disttoside * .8 / minimapheight);
						angletop = 2 * atan(disttotop * aspectratioguess * .8 / minimapheight);
					}
					else
					{
						aspectratioguess = 4.0/3.0;
						angleside = 2 * atan(disttoside / minimapheight);
						angletop = 2 * atan(disttotop * aspectratioguess / minimapheight);
					}
					if (angleside > angletop)
						angle = angleside;
					else
						angle = angletop;
					
					znear = minimapheight - 1000;
					if (znear < 16) znear = 16;
					if (znear > 10000) znear = 10000;
					
					player CameraSetPosition( viewpos, ( 90, getnorthyaw(), 0 ) );
					player CameraActivate( true );	

					player TakeAllWeapons();

					SetDvar( "cg_drawGun", 0 );
					SetDvar( "cg_draw2D", 0 );
					SetDvar( "cg_drawFPS", 0 );
					SetDvar( "fx_enable", 0 );
					SetDvar( "r_fog", 0 );
					SetDvar( "r_highLodDist", 0 ); // (turns off lods)
					SetDvar( "r_znear", znear ); // (reduces z-fighting)
					SetDvar( "r_lodscale", 0 );
					SetDvar( "r_lodScaleRigid", 0 );
					SetDvar( "cg_drawVersion", 0 );
					SetDvar( "sm_enable", 1 );
					SetDvar( "player_view_pitch_down", 90 );
					SetDvar( "player_view_pitch_up", 0 );
					SetDvar( "cg_fov", angle );
					SetDvar( "cg_fovMin", 1 );

					SetDvar( "debug_show_viewpos", "0" );
					
					// hide 3D icons
					if ( isdefined( level.objPoints ) )
					{
						for ( i = 0; i < level.objPointNames.size; i++ )
						{
							if ( isdefined( level.objPoints[level.objPointNames[i]] ) )
								level.objPoints[level.objPointNames[i]] destroy();
						}
						level.objPoints = [];
						level.objPointNames = [];
					}
					
					thread drawMiniMapBounds(viewpos, mincorner, maxcorner);
				}
				else
					println("^1Error: There are not exactly 2 \"minimap_corner\" entities in the level.");
			}
			else
				SetDvar("scr_minimap_height", "0");
		}
	}
}

vecscale(vec, scalar)
{
	return (vec[0]*scalar, vec[1]*scalar, vec[2]*scalar);
}

drawMiniMapBounds(viewpos, mincorner, maxcorner)
{
	level notify("end_draw_map_bounds");
	level endon("end_draw_map_bounds");
	
	viewheight = (viewpos[2] - maxcorner[2]);
	
	north = (cos(getnorthyaw()), sin(getnorthyaw()), 0);
	
	diaglen = length(mincorner - maxcorner);

	/*diagonal = maxcorner - mincorner;
	side = vecscale(north, vectordot(diagonal, north));
	
	origcorner0 = mincorner;
	origcorner1 = mincorner + side;
	origcorner2 = maxcorner;
	origcorner3 = maxcorner - side;*/
	
	mincorneroffset = (mincorner - viewpos);
	mincorneroffset = vectornormalize((mincorneroffset[0], mincorneroffset[1], 0));
	mincorner = mincorner + vecscale(mincorneroffset, diaglen * 1/800);
	maxcorneroffset = (maxcorner - viewpos);
	maxcorneroffset = vectornormalize((maxcorneroffset[0], maxcorneroffset[1], 0));
	maxcorner = maxcorner + vecscale(maxcorneroffset, diaglen * 1/800);
	
	diagonal = maxcorner - mincorner;
	side = vecscale(north, vectordot(diagonal, north));
	sidenorth = vecscale(north, abs(vectordot(diagonal, north)));
	
	corner0 = mincorner;
	corner1 = mincorner + side;
	corner2 = maxcorner;
	corner3 = maxcorner - side;
	
	toppos = vecscale(mincorner + maxcorner, .5) + vecscale(sidenorth, .51);
	textscale = diaglen * .003;
	
	while(1)
	{
		line(corner0, corner1);
		line(corner1, corner2);
		line(corner2, corner3);
		line(corner3, corner0);

		/*line(origcorner0, origcorner1, (1,0,0));
		line(origcorner1, origcorner2, (1,0,0));
		line(origcorner2, origcorner3, (1,0,0));
		line(origcorner3, origcorner0, (1,0,0));*/
		
		print3d(toppos, "This Side Up", (1,1,1), 1, textscale);
		
		wait .05;
	}
}

minimapWarn( corners )
{
	threshold = 10;
	
	width = Abs( corners[0].origin[0] - corners[1].origin[0] );
	width = Int( width );

	height = Abs( corners[0].origin[1] - corners[1].origin[1] );
	height = Int( height );

	if ( Abs( width - height ) > threshold )
	{
		for ( ;; )
		{
			iprintln( "^1Warning: Minimap corners do not form a square (width: " + width + " height: " + height + ")\n" );

			if ( height > width )
			{
				scale = height / width;
				iprintln( "^1Warning: The compass minimap might be scaled: " + scale + " units in height more than width\n" );
			}
			else
			{
				scale = width / height;
				iprintln( "^1Warning: The compass minimap might be scaled: " + scale + " units in width more than height\n" );
			}

			wait( 10 );
		}
	}
}

addTestClients()
{
	wait 5;

	for(;;)
	{
		if(GetDvarint( "scr_testclients") > 0)
			break;
		wait 1;
	}

//	for ( index = 1; index < 24; index++ )
//		kick( index );

	playSoundOnPlayers( "vox_kls_dav_spawn" );
	
	testclients = GetDvarint( "scr_testclients");
	SetDvar( "scr_testclients", 0 );
	for(i = 0; i < testclients; i++)
	{
		ent[i] = addtestclient();

		if (!isdefined(ent[i])) {
			println("Could not add test client");
			wait 1;
			continue;
		}
			
		ent[i].pers["isBot"] = true;
		ent[i] thread TestClient("autoassign");
		
		//wait 0.3;
	}

	thread addTestClients();
}

addEnemyHeli()
{
	wait 5;

	for(;;)
	{
		if(GetDvarint( "scr_spawnenemyheli") > 0)
			break;
		wait 1;
	}

	enemyheli = GetDvarint( "scr_spawnenemyheli");
	SetDvar( "scr_spawnenemyheli", 0 );

	team = "autoassign";
	player = getHostPlayer();
	if( IsDefined( player.pers["team"] ) )
	{
		team = GetOtherTeam( player.pers["team"] );
	}
	
	ent = getOrMakeBot(team);
	if( !isdefined( ent ) ) 
	{
		println("Could not add test client");
		wait 1;
		thread addEnemyHeli();
		return;
	}

	switch( enemyheli )
	{
	case 1:
		level.helilocation = ent.origin;
		ent thread maps\mp\killstreaks\_helicopter::useKillstreakHelicopter( "helicopter_comlink_mp" );
		wait(0.5);
		ent notify( "confirm_location", level.helilocation ); 
		break;
//	case 2:
//		ent thread maps\mp\killstreaks\_helicopter_player::useKillstreakHelicopterGunner( "helicopter_gunner_mp" );
//		break;
//	case 3:
//		ent thread maps\mp\killstreaks\_helicopter_player::useKillstreakHelicopterPlayer( "helicopter_player_firstperson_mp" );
//		break;
	}

	thread addEnemyHeli();
}

getOrMakeBot(team)
{
	for ( i = 0; i <level.players.size; i++ )
	{
		if ( level.players[i].team == team )
		{
			if ( IsDefined(level.players[i].pers["isBot"]) && level.players[i].pers["isBot"] )
			{
				return level.players[i];
			}
		}
	}
	
	ent = addtestclient();
	if( IsDefined( ent ) ) 
	{
		playSoundOnPlayers( "vox_kls_dav_spawn" );
		ent.pers["isBot"] = true;
		ent thread TestClient( team );
		wait(1);
	}
		
	return ent;
}

addEnemyU2()
{
	wait 5;

	for(;;)
	{
		if(GetDvarint( "scr_spawnenemyu2") > 0)
			break;
		wait 1;
	}

	type = GetDvarint( "scr_spawnenemyu2");
	SetDvar( "scr_spawnenemyu2", 0 );

	team = "autoassign";
	player = getHostPlayer();
	if( IsDefined( player.team ) )
	{
		team = GetOtherTeam( player.team );
	}

	ent = getOrMakeBot(team);

	if( !isdefined( ent ) ) 
	{
		println("Could not add test client");
		wait 1;
		thread addEnemyU2();
		return;
	}

	if ( type == 3 )
		ent thread maps\mp\killstreaks\_radar::useKillstreakSatellite( "radardirection_mp" );
	else if ( type == 2 )
		ent thread maps\mp\killstreaks\_radar::useKillstreakCounterUAV( "counteruav_mp" );
	else 
		ent thread maps\mp\killstreaks\_radar::useKillstreakRadar( "radar_mp" );

	thread addEnemyU2();
}

addTestCarePackage()
{
	wait 5;

	for(;;)
	{
		if(GetDvarint( "scr_givetestsupplydrop") > 0)
			break;
		wait 1;
	}

	supplydrop = GetDvarint( "scr_givetestsupplydrop");
	team = "autoassign";
	
	player = getHostPlayer();

	if( IsDefined( player.pers["team"] ) )
	{
		switch( supplydrop )
		{
		case 2: // enemy
			team = GetOtherTeam( player.pers["team"] );
			break;

		case 1: // ally
		default:
			team = player.pers["team"];
			break;
		}
	}

	SetDvar( "scr_givetestsupplydrop", 0 );
	ent = getOrMakeBot(team);
	if( !isdefined( ent ) ) 
	{
		println("Could not add test client");
		wait 1;
		thread addTestCarePackage();
		return;
	}

	ent maps\mp\killstreaks\_killstreakrules::killstreakStart( "supply_drop_mp", team );
	ent thread maps\mp\killstreaks\_supplydrop::heliDeliverCrate( ent.origin, "supplydrop_mp", ent, team );

	thread addTestCarePackage();
}

removeTestClients()
{
	wait 5;

	for(;;)
	{
		if(GetDvarint( "scr_testclientsremove") > 0)
			break;
		wait 1;
	}

	playSoundOnPlayers( "vox_kls_dav_kill" );
	
	removeType = GetDvarint( "scr_testclientsremove");
	
	SetDvar( "scr_testclientsremove", 0 );
	
	host = getHostPlayer();
	
	players = level.players;
	for(i = 0; i < players.size; i++)
	{
		if ( IsDefined(players[i].pers["isBot"]) && players[i].pers["isBot"] == true )
		{
			// remove friendlies
			if ( removeType == 2 && host.team != players[i].team )
				continue;
				
			// remove enemies
			if ( removeType == 3 && host.team == players[i].team )
				continue;
				
			Kick( players[i] GetEntityNumber( ) );
		}
	}
	
	thread removeTestClients();
}

TestClient(team) // self == test client
{
	self endon( "disconnect" );

	while(!isdefined(self.pers["team"]))
		wait .05;

	if ( level.teambased )
	{
		self notify("menuresponse", game["menu_team"], team);
		wait 0.5;
	}

	while( 1 )
	{
		self maps\mp\bots\_bot::bot_choose_class();
		self waittill( "spawned_player" );
		wait ( 0.10 );
	}
}

showOneSpawnPoint(
	spawn_point,
	color,
	notification,
	height,
	print)
{
	if ( !IsDefined( height ) || height <= 0 )
	{
		height = get_player_height();
	}

	if ( !IsDefined( print ) )
	{
		print = spawn_point.classname;
	}

	center = spawn_point.origin;
	forward = anglestoforward(spawn_point.angles);
	right = anglestoright(spawn_point.angles);

	forward = VectorScale(forward, 16);
	right = VectorScale(right, 16);

	a = center + forward - right;
	b = center + forward + right;
	c = center - forward + right;
	d = center - forward - right;
	
	thread lineUntilNotified(a, b, color, 0, notification);
	thread lineUntilNotified(b, c, color, 0, notification);
	thread lineUntilNotified(c, d, color, 0, notification);
	thread lineUntilNotified(d, a, color, 0, notification);

	thread lineUntilNotified(a, a + (0, 0, height), color, 0, notification);
	thread lineUntilNotified(b, b + (0, 0, height), color, 0, notification);
	thread lineUntilNotified(c, c + (0, 0, height), color, 0, notification);
	thread lineUntilNotified(d, d + (0, 0, height), color, 0, notification);

	a = a + (0, 0, height);
	b = b + (0, 0, height);
	c = c + (0, 0, height);
	d = d + (0, 0, height);
	
	thread lineUntilNotified(a, b, color, 0, notification);
	thread lineUntilNotified(b, c, color, 0, notification);
	thread lineUntilNotified(c, d, color, 0, notification);
	thread lineUntilNotified(d, a, color, 0, notification);

	center = center + (0, 0, height/2);
	arrow_forward = anglestoforward(spawn_point.angles);
	arrowhead_forward = anglestoforward(spawn_point.angles);
	arrowhead_right = anglestoright(spawn_point.angles);

	arrow_forward = VectorScale(arrow_forward, 32);
	arrowhead_forward = VectorScale(arrowhead_forward, 24);
	arrowhead_right = VectorScale(arrowhead_right, 8);
	
	a = center + arrow_forward;
	b = center + arrowhead_forward - arrowhead_right;
	c = center + arrowhead_forward + arrowhead_right;
	
	thread lineUntilNotified(center, a, color, 0, notification);
	thread lineUntilNotified(a, b, color, 0, notification);
	thread lineUntilNotified(a, c, color, 0, notification);

	thread print3DUntilNotified(spawn_point.origin + (0, 0, height), print, color, 1, 1, notification);
	
	return;
}

showSpawnpoints()
{
	if (IsDefined(level.spawnpoints))
	{
		// show standard spawn points
		color= (1, 1, 1);
		for (spawn_point_index= 0; spawn_point_index<level.spawnpoints.size; spawn_point_index++)
		{
			showOneSpawnPoint(level.spawnpoints[spawn_point_index], color, "hide_spawnpoints");
		}
	}

	for ( i = 0; i < level.dem_spawns.size; i++ )
	{
		color = ( 0, 1, 0 );
		showOneSpawnPoint( level.dem_spawns[i], color, "hide_spawnpoints" );
	}
	
	return;
}

hideSpawnpoints()
{
	level notify("hide_spawnpoints");
	
	return;
}

showStartSpawnpoints()
{
	if ( !level.teamBased )
	{
		return;
	}

	if ( !IsDefined( level.spawn_start ) )
	{
		return;
	}

	team_colors = [];
	team_colors["axis"] = (1,0,1); // magenta
	team_colors["allies"] = (0,1,1); // cyan
	team_colors["team3"] = (1,1,0); // yellow
	team_colors["team4"] = (0,1,0); // green
	team_colors["team5"] = (0,0,1); // blue
	team_colors["team6"] = (1,0.7,0); // orange
	team_colors["team7"] = (0.25,0.25,1.0); // dark cyan
	team_colors["team8"] = (0.88,0,1);	//purple

	foreach( team in level.teams )
	{
		color = team_colors[team];

		foreach( spawnpoint in level.spawn_start[team] )
		{
			showOneSpawnPoint(spawnpoint, color, "hide_startspawnpoints");
		}
	}
	
	return;
}

hideStartSpawnpoints()
{
	level notify("hide_startspawnpoints");
	
	return;
}

print3DUntilNotified(origin, text, color, alpha, scale, notification)
{
	level endon(notification);
	
	for(;;)
	{
		print3d(origin, text, color, alpha, scale);
		wait .05;
	}
}

lineUntilNotified(start, end, color, depthTest, notification)
{
	level endon(notification);
	
	for(;;)
	{
		line(start, end, color, depthTest);
		wait .05;
	}
}

// this controls the engagement distance debug stuff with a dvar
engagement_distance_debug_toggle()
{
	level endon( "kill_engage_dist_debug_toggle_watcher" );

	if( !IsDefined( GetDvarint( "debug_engage_dists") ) )
		SetDvar( "debug_engage_dists", "0" );
	
	lastState = GetDvarint( "debug_engage_dists" );

	while( 1 )
	{
		currentState = GetDvarint( "debug_engage_dists" );

		if( dvar_turned_on( currentState ) && !dvar_turned_on( lastState ) )
		{
			// turn it on
			weapon_engage_dists_init();
			thread debug_realtime_engage_dist();
			//thread debug_ai_engage_dist();

			lastState = currentState;
		}
		else if( !dvar_turned_on( currentState ) && dvar_turned_on( lastState ) )
		{
			// send notify to turn off threads
			level notify( "kill_all_engage_dist_debug" );

			lastState = currentState;
		}

		wait( 0.3 );
	}
}

dvar_turned_on( val )
{
	if( val <= 0 )
	{
		return false;
	}
	else
	{
		return true;
	}
}

engagement_distance_debug_init()
{
	// set up debug stuff
	level.debug_xPos = -50;
	level.debug_yPos = 250;
	level.debug_yInc = 18;

	level.debug_fontScale = 1.5;

	level.white = ( 1, 1, 1 );
	level.green = ( 0, 1, 0 );
	level.yellow = ( 1, 1, 0 );
	level.red = ( 1, 0, 0 );

	level.realtimeEngageDist = NewHudElem();
	level.realtimeEngageDist.alignX = "left";
	level.realtimeEngageDist.fontScale = level.debug_fontScale;
	level.realtimeEngageDist.x = level.debug_xPos;
	level.realtimeEngageDist.y = level.debug_yPos;
	level.realtimeEngageDist.color = level.white;
	level.realtimeEngageDist SetText( "Current Engagement Distance: " );

	xPos = level.debug_xPos + 207;

	level.realtimeEngageDist_value = NewHudElem();
	level.realtimeEngageDist_value.alignX = "left";
	level.realtimeEngageDist_value.fontScale = level.debug_fontScale;
	level.realtimeEngageDist_value.x = xPos;
	level.realtimeEngageDist_value.y = level.debug_yPos;
	level.realtimeEngageDist_value.color = level.white;
	level.realtimeEngageDist_value SetValue( 0 );

	xPos += 37;

	level.realtimeEngageDist_middle = NewHudElem();
	level.realtimeEngageDist_middle.alignX = "left";
	level.realtimeEngageDist_middle.fontScale = level.debug_fontScale;
	level.realtimeEngageDist_middle.x = xPos;
	level.realtimeEngageDist_middle.y = level.debug_yPos;
	level.realtimeEngageDist_middle.color = level.white;
	level.realtimeEngageDist_middle SetText( " units, SHORT/LONG by " );

	xPos += 105;

	level.realtimeEngageDist_offvalue = NewHudElem();
	level.realtimeEngageDist_offvalue.alignX = "left";
	level.realtimeEngageDist_offvalue.fontScale = level.debug_fontScale;
	level.realtimeEngageDist_offvalue.x = xPos;
	level.realtimeEngageDist_offvalue.y = level.debug_yPos;
	level.realtimeEngageDist_offvalue.color = level.white;
	level.realtimeEngageDist_offvalue SetValue( 0 );

	hudObjArray = [];
	hudObjArray[0] = level.realtimeEngageDist;
	hudObjArray[1] = level.realtimeEngageDist_value;
	hudObjArray[2] = level.realtimeEngageDist_middle;
	hudObjArray[3] = level.realtimeEngageDist_offvalue;

	return hudObjArray;
}

engage_dist_debug_hud_destroy( hudArray, killNotify )
{
	level waittill( killNotify );

	for( i = 0; i < hudArray.size; i++ )
	{
		hudArray[i] Destroy();
	}
}

weapon_engage_dists_init()
{
	level.engageDists = [];

	// first pass ok
	genericPistol = spawnstruct();
	genericPistol.engageDistMin = 125;
	genericPistol.engageDistOptimal = 225;
	genericPistol.engageDistMulligan = 50;  // range around the optimal value that is still optimal
	genericPistol.engageDistMax = 400;

	// first pass ok
	shotty = spawnstruct();
	shotty.engageDistMin = 50;
	shotty.engageDistOptimal = 200;
	shotty.engageDistMulligan = 75;
	shotty.engageDistMax = 350;

	// first pass ok
	genericSMG = spawnstruct();
	genericSMG.engageDistMin = 100;
	genericSMG.engageDistOptimal = 275;
	genericSMG.engageDistMulligan = 100;
	genericSMG.engageDistMax = 500;

	// first pass NEED TEST
	genericLMG = spawnstruct();
	genericLMG.engageDistMin = 325;
	genericLMG.engageDistOptimal = 550;
	genericLMG.engageDistMulligan = 150;
	genericLMG.engageDistMax = 850;

	// first pass ok
	genericRifleSA = spawnstruct();
	genericRifleSA.engageDistMin = 325;
	genericRifleSA.engageDistOptimal = 550;
	genericRifleSA.engageDistMulligan = 150;
	genericRifleSA.engageDistMax = 850;

	// first pass ok
	genericRifleBolt = spawnstruct();
	genericRifleBolt.engageDistMin = 350;
	genericRifleBolt.engageDistOptimal = 600;
	genericRifleBolt.engageDistMulligan = 150;
	genericRifleBolt.engageDistMax = 900;

	// first pass NEED TEST
	genericHMG = spawnstruct();
	genericHMG.engageDistMin = 390;
	genericHMG.engageDistOptimal = 600;
	genericHMG.engageDistMulligan = 100;
	genericHMG.engageDistMax = 900;

	// first pass ok
	genericSniper = spawnstruct();
	genericSniper.engageDistMin = 950;
	genericSniper.engageDistOptimal = 1700;
	genericSniper.engageDistMulligan = 300;
	genericSniper.engageDistMax = 3000;

	// Pistols
	engage_dists_add( "colt_mp", genericPistol );
	engage_dists_add( "nambu_mp", genericPistol );
	engage_dists_add( "tokarev_mp", genericPistol );
	engage_dists_add( "walther_mp", genericPistol );

	// SMGs
	engage_dists_add( "thompson_mp", genericSMG );
	engage_dists_add( "type100_smg_mp", genericSMG );
	engage_dists_add( "ppsh_mp", genericSMG );
	engage_dists_add( "mp40_mp", genericSMG );
	engage_dists_add( "stg44_mp", genericSMG );
	engage_dists_add( "sten_mp", genericSMG );
	engage_dists_add( "sten_silenced_mp", genericSMG );

	// shotgun
	engage_dists_add( "shotgun_mp", shotty );

	// LMGs
	engage_dists_add( "bar_mp", genericLMG );
	engage_dists_add( "bar_bipod_mp", genericLMG );
	engage_dists_add( "type99_lmg_mp", genericLMG );
	engage_dists_add( "type99_lmg_bipod_mp", genericLMG );
	engage_dists_add( "dp28_mp", genericLMG );
	engage_dists_add( "dp28_bipod_mp", genericLMG );
	engage_dists_add( "fg42_mp", genericLMG );
	engage_dists_add( "fg42_bipod_mp", genericLMG );
	engage_dists_add( "bren_mp", genericLMG );
	engage_dists_add( "bren_bipod_mp", genericLMG );

	// Rifles (semiautomatic)
	engage_dists_add( "m1garand_mp", genericRifleSA );
	engage_dists_add( "m1garand_bayonet_mp", genericRifleSA );
	engage_dists_add( "m1carbine_mp", genericRifleSA );
	engage_dists_add( "m1carbine_bayonet_mp", genericRifleSA );
	engage_dists_add( "svt40_mp", genericRifleSA );
	engage_dists_add( "gewehr43_mp", genericRifleSA );

	// Rifles (bolt-action)
	engage_dists_add( "springfield_mp", genericRifleBolt );
	engage_dists_add( "springfield_bayonet_mp", genericRifleBolt );
	engage_dists_add( "type99_rifle_mp", genericRifleBolt );
	engage_dists_add( "type99_rifle_bayonet_mp", genericRifleBolt );
	engage_dists_add( "mosin_rifle_mp", genericRifleBolt );
	engage_dists_add( "mosin_rifle_bayonet_mp", genericRifleBolt );
	engage_dists_add( "kar98k_mp", genericRifleBolt );
	engage_dists_add( "kar98k_bayonet_mp", genericRifleBolt );
	engage_dists_add( "lee_enfield_mp", genericRifleBolt );
	engage_dists_add( "lee_enfield_bayonet_mp", genericRifleBolt );

	// HMGs
	engage_dists_add( "30cal_mp", genericHMG );
	engage_dists_add( "30cal_bipod_mp", genericHMG );
	engage_dists_add( "mg42_mp", genericHMG );
	engage_dists_add( "mg42_bipod_mp", genericHMG );

	// Sniper Rifles
	engage_dists_add( "springfield_scoped_mp", genericSniper );
	engage_dists_add( "type99_rifle_scoped_mp", genericSniper );
	engage_dists_add( "mosin_rifle_scoped_mp", genericSniper );
	engage_dists_add( "kar98k_scoped_mp", genericSniper );
	engage_dists_add( "fg42_scoped_mp", genericSniper );
	engage_dists_add( "lee_enfield_scoped_mp", genericSniper );

	// start waiting for weapon changes
	level thread engage_dists_watcher();
}

engage_dists_add( weapontypeStr, values )
{
	level.engageDists[weapontypeStr] = values;
}

// returns a script_struct, or undefined, if the lookup failed
get_engage_dists( weapontypeStr )
{
	if( IsDefined( level.engageDists[weapontypeStr] ) )
	{
		return level.engageDists[weapontypeStr];
	}
	else
	{
		return undefined;
	}
}

// checks currently equipped weapon to make sure that engagement distance values are correct
engage_dists_watcher()
{
	level endon( "kill_all_engage_dist_debug" );
	level endon( "kill_engage_dists_watcher" );

	while( 1 )
	{
		player = getHostPlayer();
		playerWeapon = player GetCurrentWeapon();

		if( !IsDefined( player.lastweapon ) )
		{
			player.lastweapon = playerWeapon;
		}
		else
		{
			if( player.lastweapon == playerWeapon )
			{
				wait( 0.05 );
				continue;
			}
		}

		values = get_engage_dists( playerWeapon );

		if( IsDefined( values ) )
		{
			level.weaponEngageDistValues = values;
		}
		else
		{
			level.weaponEngageDistValues = undefined;
		}

		player.lastweapon = playerWeapon;

		wait( 0.05 );
	}
}

debug_realtime_engage_dist()
{
	level endon( "kill_all_engage_dist_debug" );
	level endon( "kill_realtime_engagement_distance_debug" );

	hudObjArray = engagement_distance_debug_init();
	level thread engage_dist_debug_hud_destroy( hudObjArray, "kill_all_engage_dist_debug" );

	level.debugRTEngageDistColor = level.green;

	player = getHostPlayer();

	while( 1 )
	{
		lastTracePos = ( 0, 0, 0 );

		// Trace to where the player is looking
		direction = player GetPlayerAngles();
		direction_vec = AnglesToForward( direction );
		eye = player GetEye();

		eye = ( eye[0], eye[1], eye[2] + 20 );

		trace = BulletTrace( eye, eye + VectorScale( direction_vec, 10000 ), true, player );
		tracePoint = trace["position"];
		traceNormal =  trace["normal"];
		traceDist = int( Distance( eye, tracePoint ) );  // just need an int, thanks

		if( tracePoint != lastTracePos )
		{
			lastTracePos = tracePoint;

			if( !IsDefined( level.weaponEngageDistValues ) )
			{
				hudobj_changecolor( hudObjArray, level.white );
				hudObjArray engagedist_hud_changetext( "nodata", tracedist );
			}
			else
			{
				// for convenience
				engageDistMin = level.weaponEngageDistValues.engageDistMin;
				engageDistOptimal = level.weaponEngageDistValues.engageDistOptimal;
				engageDistMulligan = level.weaponEngageDistValues.engageDistMulligan;
				engageDistMax = level.weaponEngageDistValues.engageDistMax;

				// if inside our engagement distance range...
				if( ( traceDist >= engageDistMin ) && ( traceDist <= engageDistMax ) )
				{
					// if in the optimal range...
					if( ( traceDist >= ( engageDistOptimal - engageDistMulligan ) )
						&& ( traceDist <= ( engageDistOptimal + engageDistMulligan ) ) )
					{
						hudObjArray engagedist_hud_changetext( "optimal", tracedist );
						hudobj_changecolor( hudObjArray, level.green );
					}
					else
					{
						hudObjArray engagedist_hud_changetext( "ok", tracedist );
						hudobj_changecolor( hudObjArray, level.yellow );
					}
				}
				else if( traceDist < engageDistMin )
				{
					hudobj_changecolor( hudObjArray, level.red );
					hudObjArray engagedist_hud_changetext( "short", tracedist );
				}
				else if( traceDist > engageDistMax )
				{
					hudobj_changecolor( hudObjArray, level.red );
					hudObjArray engagedist_hud_changetext( "long", tracedist );
				}
			}
		}

		// draw our trace spot
		// plot_circle_fortime(radius1,radius2,time,color,origin,normal)
		thread plot_circle_fortime( 1, 5, 0.05, level.debugRTEngageDistColor, tracePoint, traceNormal );
		thread plot_circle_fortime( 1, 1, 0.05, level.debugRTEngageDistColor, tracePoint, traceNormal );

		wait( 0.05 );
	}
}

hudobj_changecolor( hudObjArray, newcolor )
{
	for( i = 0; i < hudObjArray.size; i++ )
	{
		hudObj = hudObjArray[i];

		if( hudObj.color != newcolor )
		{
			hudObj.color = newcolor;
			level.debugRTEngageDistColor = newcolor;
		}
	}
}

// self = an array of hud objects
engagedist_hud_changetext( engageDistType, units )
{
	if( !IsDefined( level.lastDistType ) )
	{
		level.lastDistType = "none";
	}

	if( engageDistType == "optimal" )
	{
		self[1] SetValue( units );
		self[2] SetText( "units: OPTIMAL!" );
		self[3].alpha = 0;
	}
	else if( engageDistType == "ok" )
	{
		self[1] SetValue( units );
		self[2] SetText( "units: OK!" );
		self[3].alpha = 0;
	}
	else if( engageDistType == "short" )
	{
		amountUnder = level.weaponEngageDistValues.engageDistMin - units;
		self[1] SetValue( units );
		self[3] SetValue( amountUnder );
		self[3].alpha = 1;

		if( level.lastDistType != engageDistType )
		{
			self[2] SetText( "units: SHORT by " );
		}
	}
	else if( engageDistType == "long" )
	{
		amountOver = units - level.weaponEngageDistValues.engageDistMax;
		self[1] SetValue( units );
		self[3] SetValue( amountOver );
		self[3].alpha = 1;

		if( level.lastDistType != engageDistType )
		{
			self[2] SetText( "units: LONG by " );
		}
	}
	else if( engageDistType == "nodata" )
	{
		self[1] SetValue( units );
		self[2] SetText( " units: (NO CURRENT WEAPON VALUES)" );
		self[3].alpha = 0;
	}

	level.lastDistType = engageDistType;
}

// draws print3ds above enemy AI heads to show contact distances
/*
debug_ai_engage_dist()
{
	level endon( "kill_all_engage_dist_debug" );
	level endon( "kill_ai_engagement_distance_debug" );

	player = getHostPlayer();

	while( 1 )
	{
		axis = GetAIArray( "axis" );

		if( IsDefined( axis ) && axis.size > 0 )
		{	
			playerEye = player GetEye();

			for( i = 0; i < axis.size; i++ )
			{
				ai = axis[i];
				aiEye = ai GetEye();

				if( SightTracePassed( playerEye, aiEye, false, player ) )
				{
					dist = Distance( playerEye, aiEye );

					drawColor = level.white;
					drawString = "-";

					if( !IsDefined( level.weaponEngageDistValues ) )
					{
						drawColor = level.white;
					}
					else
					{
						// for convenience
						engageDistMin = level.weaponEngageDistValues.engageDistMin;
						engageDistOptimal = level.weaponEngageDistValues.engageDistOptimal;
						engageDistMulligan = level.weaponEngageDistValues.engageDistMulligan;
						engageDistMax = level.weaponEngageDistValues.engageDistMax;

						// if inside our engagement distance range...
						if( ( dist >= engageDistMin ) && ( dist <= engageDistMax ) )
						{
							// if in the optimal range...
							if( ( dist >= ( engageDistOptimal - engageDistMulligan ) )
								&& ( dist <= ( engageDistOptimal + engageDistMulligan ) ) )
							{
								drawColor = level.green;
								drawString = "RAD";
							}
							// else it's just ok
							else
							{
								drawColor = level.yellow;
								drawString = "MEH";
							}
						}
						else if( dist < engageDistMin )
						{
							drawColor = level.red;
							drawString = "BAD";
						}
						else if( dist > engageDistMax )
						{
							drawColor = level.red;
							drawString = "BAD";
						}
					}		

					scale = dist / 525;
					Print3d( ai.origin + ( 0, 0, 67 ), drawString, drawColor, 1, scale );
				}
			}
		}

		wait( 0.05 );
	}
}
*/

// draws a circle in script
plot_circle_fortime(radius1,radius2,time,color,origin,normal)
{
	if(!isdefined(color))
		color = (0,1,0);
	hangtime = .05;
	circleres = 6;
	hemires = circleres/2;
	circleinc = 360/circleres;
	circleres++;
	plotpoints = [];

	rad = 0.00;
	timer = gettime()+(time*1000);
	radius = radius1;

	while(gettime()<timer)
	{
		// radius = radius1+((radius2-radius1)*(1-((timer-gettime())/(time*1000))));
		radius = radius2;
		angletoplayer = vectortoangles(normal);
		for(i=0;i<circleres;i++)
		{
			plotpoints[plotpoints.size] = origin+VectorScale(anglestoforward((angletoplayer+(rad,90,0))),radius);
			rad+=circleinc;
		}
		maps\mp\_utility::plot_points(plotpoints,color[0],color[1],color[2],hangtime);
		plotpoints = [];
		wait hangtime;
	}
}


// -- end engagement distance debug --

larry_thread()
{

	SetDvar("bot_AllowMovement", "0");
	SetDvar("bot_PressAttackBtn", "0");
	SetDvar("bot_PressMeleeBtn", "0");

	level.larry = SpawnStruct();

	player = getHostPlayer();
	player thread larry_init( level.larry ); 

	// Cleanup hudelems, dummy models, etc.
	level waittill ( "kill_larry" );

	larry_hud_destroy( level.larry );

	if ( IsDefined( level.larry.model ) )
		level.larry.model delete();

	if ( IsDefined( level.larry.ai ) )
	{
		for ( i = 0; i < level.larry.ai.size; i++ )
		{
			kick( level.larry.ai[i] GetEntityNumber() );
		}
	}

	level.larry = undefined;
}

larry_init( larry )
{	
	level endon ( "kill_larry" );

	// HUD
	larry_hud_init( larry );

	// Model
	larry.model = spawn( "script_model", (0,0,0) );
	larry.model setmodel( "defaultactor" );

	// AI
	larry.ai = [];

	wait 0.1;

	for ( ;; )
	{
		wait (0.05);

		if ( larry.ai.size > 0 )
		{
			larry.model Hide();
			continue;
		}
		
		// Trace to where the player is looking
		direction = self getPlayerAngles();
		direction_vec = anglesToForward( direction );
		eye = self getEye();

		// offset 2 units on the Z to fix the bug where it would drop through the ground sometimes
		trace = bullettrace( eye, eye + VectorScale( direction_vec , 8000 ), 0, undefined );

		dist = distance (eye, trace["position"]);		
		position = eye + VectorScale( direction_vec , (dist - 64) );

		larry.model.origin = position;
		larry.model.angles = self.angles + ( 0, 180, 0 );

		if ( self UseButtonPressed() )
		{
			self larry_ai( larry );
						
			while ( self UseButtonPressed() )
				wait ( 0.05 );
		}
	}
}

larry_ai( larry )
{
	larry.ai[larry.ai.size] = AddTestClient();
	
	i = larry.ai.size - 1;
	larry.ai[i].pers["isBot"] = true;
	larry.ai[i] thread TestClient( "autoassign" );

	larry.ai[i] thread larry_ai_thread( larry, larry.model.origin, larry.model.angles );
	larry.ai[i] thread larry_ai_damage( larry );
	larry.ai[i] thread larry_ai_health( larry );
}

larry_ai_thread( larry, origin, angles )
{
	level endon( "kill_larry" );

	for ( ;; )
	{
		self waittill( "spawned_player" );

		//larry.clearTextMarker ClearAllTextAfterHudElem();

		larry.menu[larry.menu_health]	SetValue( self.health );
		larry.menu[larry.menu_damage]	SetText( "" );	
		larry.menu[larry.menu_range]	SetText( "" );	
		larry.menu[larry.menu_hitloc]	SetText( "" );	
		larry.menu[larry.menu_weapon]	SetText( "" );	
		larry.menu[larry.menu_perks]	SetText( "" );	

		self SetOrigin( origin );
		self SetPlayerAngles( angles );
		self ClearPerks();
	}
}

larry_ai_damage( larry )
{
	level endon( "kill_larry" );

	for ( ;; )
	{
		self waittill( "damage", damage, attacker, dir, point );		

		range = 0.0;

		player = getHostPlayer();
		if ( attacker == player )
		{
			eye = player GetEye();

			range = int( Distance( eye, point ) );
		}

		println( "eye : " + eye );
		println( "point : " + point );
		
		larry.menu[larry.menu_health]	SetValue( self.health );
		larry.menu[larry.menu_damage]	SetValue( damage );	
		larry.menu[larry.menu_range]	SetValue( range );	
		larry.menu[larry.menu_hitloc]	SetText( self.cac_debug_location );	
		larry.menu[larry.menu_weapon]	SetText( self.cac_debug_weapon );	
	}
}

larry_ai_health( larry )
{
	level endon( "kill_larry" );

	for ( ;; )
	{
		wait( 0.05 );

		larry.menu[larry.menu_health] SetValue( self.health );
	}
}

larry_hud_init( larry )
{
	x = -45;
	y = 275;
	menu_name = "larry_menu";

	larry.hud = new_hud( menu_name, undefined, x, y, 1 );
	larry.hud SetShader( "white", 135, 65 );
	larry.hud.alignX = "left";
	larry.hud.alignY = "top";
	larry.hud.sort = 10;
	larry.hud.alpha = 0.6;	
	larry.hud.color = ( 0.0, 0.0, 0.5 );

	larry.menu[0] = new_hud( menu_name, "Larry Health:",	x + 5, y + 10, 1 );
	larry.menu[1] = new_hud( menu_name, "Damage:",			x + 5, y + 20, 1 );
	larry.menu[2] = new_hud( menu_name, "Range:",			x + 5, y + 30, 1 );
	larry.menu[3] = new_hud( menu_name, "Hit Location:",	x + 5, y + 40, 1 );
	larry.menu[4] = new_hud( menu_name, "Weapon:",			x + 5, y + 50, 1 );

	larry.clearTextMarker = NewDebugHudElem();
	larry.clearTextMarker.alpha = 0;
	larry.clearTextMarker setText( "marker" );

	larry.menu_health	= larry.menu.size;
	larry.menu_damage	= larry.menu.size + 1;
	larry.menu_range	= larry.menu.size + 2;
	larry.menu_hitloc	= larry.menu.size + 3;
	larry.menu_weapon	= larry.menu.size + 4;
	larry.menu_perks	= larry.menu.size + 5;

	x_offset = 70;

	larry.menu[larry.menu_health]	= new_hud( menu_name, "", x + x_offset, y + 10, 1 );
	larry.menu[larry.menu_damage]	= new_hud( menu_name, "", x + x_offset, y + 20, 1 );
	larry.menu[larry.menu_range]	= new_hud( menu_name, "", x + x_offset, y + 30, 1 );
	larry.menu[larry.menu_hitloc]	= new_hud( menu_name, "", x + x_offset, y + 40, 1 );
	larry.menu[larry.menu_weapon]	= new_hud( menu_name, "", x + x_offset, y + 50, 1 );
	larry.menu[larry.menu_perks]	= new_hud( menu_name, "", x + x_offset, y + 60, 1 );
}

larry_hud_destroy( larry )
{
	if ( IsDefined( larry.hud ) )
	{
		larry.hud Destroy();

		for ( i = 0; i < larry.menu.size; i++ )
		{
			larry.menu[i] Destroy();
		}

		//larry.clearTextMarker ClearAllTextAfterHudElem();
		larry.clearTextMarker Destroy();
	}
}

new_hud( hud_name, msg, x, y, scale )
{
	if( !IsDefined( level.hud_array ) )
	{
		level.hud_array = [];
	}

	if( !IsDefined( level.hud_array[hud_name] ) )
	{
		level.hud_array[hud_name] = [];
	}

	hud = set_hudelem( msg, x, y, scale );
	level.hud_array[hud_name][level.hud_array[hud_name].size] = hud;
	return hud;
}

//------------------------------------------------------//
// set_hudelem( [text], x, y, [scale], [alpha] )		//
//		Actually creates the hudelem					//
//------------------------------------------------------//
// self		- n/a										//
// text		- The text to be displayed					//
// x		- Sets the x position of the hudelem		//
// y		- Sets the y position of the hudelem		//
// scale	- Sets the scale of the hudelem				//
// alpha	- Sets the alpha of the hudelem				//
//------------------------------------------------------//
set_hudelem( text, x, y, scale, alpha, sort, debug_hudelem )
{
		if( !IsDefined( alpha ) )
		{
			alpha = 1;
		}

		if( !IsDefined( scale ) )
		{
			scale = 1;
		}

		if( !IsDefined( sort ) )
		{
			sort = 20;
		}

		hud = NewDebugHudElem();
		hud.debug_hudelem = true;
		
		hud.location = 0;
		hud.alignX = "left";
		hud.alignY = "middle";
		hud.foreground = 1;
		hud.fontScale = scale;
		hud.sort = sort;
		hud.alpha = alpha;
		hud.x = x;
		hud.y = y;
		hud.og_scale = scale;

		if( IsDefined( text ) )
		{
			hud SetText( text );
		}

		return hud;
}

watch_botsdvars()
{
	hasplayerweaponprev = GetDvarint( "scr_botsHasPlayerWeapon" );
	grenadesonlyprev = GetDvarint( "scr_botsGrenadesOnly" );
	secondarygrenadesonlyprev = GetDvarint( "scr_botsSpecialGrenadesOnly" );
	while(true)
	{
		if( hasplayerweaponprev != GetDvarint( "scr_botsHasPlayerWeapon") )
		{
			hasplayerweaponprev = GetDvarint( "scr_botsHasPlayerWeapon" );
			if( hasplayerweaponprev )
			{
				IPrintLnBold( "LARRY has player weapon: ON" );
			}
			else
			{
				IPrintLnBold( "LARRY has player weapon: OFF" );
			}
		}	
		
		if( grenadesonlyprev != GetDvarint( "scr_botsGrenadesOnly") )
		{
			grenadesonlyprev = GetDvarint( "scr_botsGrenadesOnly" );
			if( grenadesonlyprev )
			{
				IPrintLnBold( "LARRY using grenades only: ON" );
			}
			else
			{
				IPrintLnBold( "LARRY using grenades only: OFF" );
			}
		}	
		
		if( secondarygrenadesonlyprev != GetDvarint( "scr_botsSpecialGrenadesOnly") )
		{
			secondarygrenadesonlyprev = GetDvarint( "scr_botsSpecialGrenadesOnly" );
			if( secondarygrenadesonlyprev )
			{
				IPrintLnBold( "LARRY using secondary grenades only: ON" );
			}
			else
			{
				IPrintLnBold( "LARRY using secondary grenades only: OFF" );
			}
		}	

		wait(1.0);
	}
}

// -- end dynamic AI spawning --
getAttachmentChangeModifierButton()
{
	return "BUTTON_X";
}

watchAttachmentChange()
{
	self endon( "disconnect" );

	clientNum = self getEntityNumber();
	if ( clientNum != 0 )
		return;
		
	dpad_left = false;
	dpad_right = false;
	dpad_up = false;
	dpad_down = false;
	lstick_down = false;

	dpad_modifier_button = getAttachmentChangeModifierButton();
	
	for ( ;; )
	{
		if ( self ButtonPressed( dpad_modifier_button ) )
		{
			if ( !dpad_left && self ButtonPressed( "DPAD_LEFT" ) )
			{
				self giveweaponnextattachment( "muzzle" );
				dpad_left = true;
				self thread print_weapon_name();
			}
			if ( !dpad_right && self ButtonPressed( "DPAD_RIGHT" ) )
			{
				self giveweaponnextattachment( "trigger" );
				dpad_right = true;
				self thread print_weapon_name();
			}
			if ( !dpad_up && self ButtonPressed( "DPAD_UP" ) )
			{
				self giveweaponnextattachment( "top" );
				dpad_up = true;
				self thread print_weapon_name();
			}
			if ( !dpad_down && self ButtonPressed( "DPAD_DOWN" ) )
			{
				self giveweaponnextattachment( "bottom" );
				dpad_down = true;
				self thread print_weapon_name();
			}
			if ( !lstick_down && self ButtonPressed( "BUTTON_LSTICK" ) )
			{
				self giveweaponnextattachment( "gunperk" );
				lstick_down = true;
				self thread print_weapon_name();
			}
		}
		if ( !self ButtonPressed( "DPAD_LEFT" ) )
		{
			dpad_left = false;
		}
		if ( !self ButtonPressed( "DPAD_RIGHT" ) )
		{
			dpad_right = false;
		}
		if ( !self ButtonPressed( "DPAD_UP" ) )
		{
			dpad_up = false;
		}
		if ( !self ButtonPressed( "DPAD_DOWN" ) )
		{
			dpad_down = false;
		}
		if ( !self ButtonPressed( "BUTTON_LSTICK" ) )
		{
			lstick_down = false;
		}
		
		wait(0.05);
	}
}

print_weapon_name() // self == player
{
	self notify( "print_weapon_name");
	self endon( "print_weapon_name");
	
	wait(0.2);
	
	if ( self IsSwitchingWeapons() )
	{
		self waittill( "weapon_change_complete", weapon_name );
		fail_safe = 0;
		while( weapon_name == "none" )
		{
			self waittill( "weapon_change_complete", weapon_name );
			wait(0.05);
			fail_safe++;
			if( fail_safe > 120 )
			{
				break;
			}
		}
	}
	else
	{
		weapon_name = self getcurrentweapon();
	}
	printWeaponName = GetDvarIntDefault( "scr_print_weapon_name", 1 );
	if ( printWeaponName ) 
		IPrintLnBold( weapon_name );
}

set_equipment_list()
{
	if (isdefined( level.dev_equipment ))
		return;
	
	level.dev_equipment = [];

	//array starts at '1' because I need the first element to empty as GetDvarInt() returns zero if it's undefined.
	level.dev_equipment[1] = "acoustic_sensor_mp";
	level.dev_equipment[2] = "camera_spike_mp";
	level.dev_equipment[3] = "claymore_mp";
	level.dev_equipment[4] = "satchel_charge_mp";
	level.dev_equipment[5] = "scrambler_mp";
	level.dev_equipment[6] = "tactical_insertion_mp";
	level.dev_equipment[7] = "bouncingbetty_mp";
	level.dev_equipment[8] = "trophy_system_mp";
	level.dev_equipment[9] = "pda_hack_mp";
}

set_grenade_list()
{
	if (isdefined( level.dev_grenade ))
		return;
	
	level.dev_grenade = [];

	//array starts at '1' because I need the first element to empty as GetDvarInt() returns zero if it's undefined.
	level.dev_grenade[1] = "frag_grenade_mp";
	level.dev_grenade[2] = "sticky_grenade_mp";
	level.dev_grenade[3] = "hatchet_mp";
	level.dev_grenade[4] = "willy_pete_mp";
	level.dev_grenade[5] = "proximity_grenade_mp";
	level.dev_grenade[6] = "flash_grenade_mp";
	level.dev_grenade[7] = "concussion_grenade_mp";
	level.dev_grenade[8] = "nightingale_mp";
	level.dev_grenade[9] = "emp_grenade_mp";
	level.dev_grenade[10] = "sensor_grenade_mp";
}

take_all_grenades_and_equipment( player )
{
	for (i=0; i<level.dev_equipment.size; i++)
	{
		player TakeWeapon( level.dev_equipment[i+1] );
	}
	for (i=0; i<level.dev_grenade.size; i++)
	{
		player TakeWeapon( level.dev_grenade[i+1] );
	}
}
	
equipment_dev_gui()
{
	set_equipment_list();
	set_grenade_list();
	
	//Init my dvar
	SetDvar("scr_give_equipment", "");

	while(1)
	{
		wait(0.5);

		//Grab my dvar every .5 seconds in the form of an int
		devgui_int = GetDvarint( "scr_give_equipment");

		//"" returns as zero with GetDvarInt
		if(devgui_int != 0)
		{
			for( i = 0; i < level.players.size; i++ )
			{
				take_all_grenades_and_equipment( level.players[i] );
				level.players[i] GiveWeapon( level.dev_equipment[devgui_int] );
				//level.players[i] SetActionSlot( 1, "weapon", equipment[devgui_int] );
			}
			SetDvar("scr_give_equipment", "0");
		}
	}
}

grenade_dev_gui()
{
	set_equipment_list();
	set_grenade_list();

	//Init my dvar
	SetDvar("scr_give_grenade", "");

	while(1)
	{
		wait(0.5);

		//Grab my dvar every .5 seconds in the form of an int
		devgui_int = GetDvarint( "scr_give_grenade");

		//"" returns as zero with GetDvarInt
		if(devgui_int != 0)
		{
			for( i = 0; i < level.players.size; i++ )
			{
				take_all_grenades_and_equipment( level.players[i] );
				level.players[i] GiveWeapon( level.dev_grenade[devgui_int] );
			}
			SetDvar("scr_give_grenade", "0");
		}
	}
}

force_grenade_throw( weapon )
{
	SetDvar( "bot_AllowMovement", "0" ); 
	SetDvar( "bot_PressAttackBtn", "0" ); 
	SetDvar( "bot_PressMeleeBtn", "0" ); 
	SetDvar( "scr_botsAllowKillstreaks", "0" ); 

	host = GetHostPlayer();

	if( !IsDefined( host.team ) )
	{
		iprintln( "Unable to determine host player team" );
		return;
	}

	bot = getOrMakeBot( GetOtherTeam( host.team ) );

	if( !IsDefined( bot ) ) 
	{
		iprintln( "Could not add test client" );
		return;
	}

	angles = host GetPlayerAngles();
	angles = ( 0, angles[1], 0 );

	dir = AnglesToForward( angles );
	dir = VectorNormalize( dir );

	origin = host GetEye() + VectorScale( dir, 256 );
	velocity = VectorScale( dir, -1024 );
	
	grenade = bot MagicGrenade( Weapon, origin, velocity );
	grenade SetTeam( bot.team );
	grenade SetOwner( bot );
}

bot_dpad_think()
{
	level notify( "bot_dpad_stop" );
	level endon( "bot_dpad_stop" );
	level endon( "bot_dpad_terminate" );

	if ( !IsDefined( level.bot_index ) )
	{
		level.bot_index = 0;
	}
		
	host = GetHostPlayer();

	while ( !IsDefined( host ) )
	{
		wait( 0.5 );
		host = GetHostPlayer();
		level.bot_index = 0;
	}

	dpad_left = false;
	dpad_right = false;

	for ( ;; )
	{
		wait( 0.05 );
		host SetActionSlot( 3, "" );
		host SetActionSlot( 4, "" );

		players = GET_PLAYERS();
		max = players.size;

		if ( !dpad_left && host ButtonPressed( "DPAD_LEFT" ) )
		{
			level.bot_index--;

			if ( level.bot_index < 0 )
			{
				level.bot_index = max - 1;
			}

			if ( !players[ level.bot_index ] is_bot() )
			{
				continue;
			}
			
			dpad_left = true;
		}
		else if ( !host ButtonPressed( "DPAD_LEFT" ) )
		{
			dpad_left = false;
		}

		if ( !dpad_right && host ButtonPressed( "DPAD_RIGHT" )  )
		{
			level.bot_index++;

			if ( level.bot_index >= max )
			{
				level.bot_index = 0;
			}

			if ( !players[ level.bot_index ] is_bot() )
			{
				continue;
			}

			dpad_right = true;
		}
		else if ( !host ButtonPressed( "DPAD_RIGHT" ) )
		{
			dpad_right = false;
		}

		level notify( "bot_index_changed" );
	}
}

bot_overlay_think()
{
	level endon( "bot_overlay_stop" );

	level thread bot_dpad_think(); 

	iprintln( "Previous Bot bound to D-Pad Left" );
	iprintln( "Next Bot bound to D-Pad Right" );

	for ( ;; )
	{
		if ( GetDvarInt( "bot_Debug" ) != level.bot_index )
		{
			SetDvar( "bot_Debug", level.bot_index );
		}

		level waittill( "bot_index_changed" );
	}
}

bot_threat_think()
{
	level endon( "bot_threat_stop" );

	level thread bot_dpad_think(); 

	iprintln( "Previous Bot bound to D-Pad Left" );
	iprintln( "Next Bot bound to D-Pad Right" );

	for ( ;; )
	{
		if ( GetDvarInt( "bot_DebugThreat" ) != level.bot_index )
		{
			SetDvar( "bot_DebugThreat", level.bot_index );
		}

		level waittill( "bot_index_changed" );
	}
}

bot_path_think()
{
	level endon( "bot_path_stop" );

	level thread bot_dpad_think(); 

	iprintln( "Previous Bot bound to D-Pad Left" );
	iprintln( "Next Bot bound to D-Pad Right" );

	for ( ;; )
	{
		if ( GetDvarInt( "bot_DebugPaths" ) != level.bot_index )
		{
			SetDvar( "bot_DebugPaths", level.bot_index );
		}

		level waittill( "bot_index_changed" );
	}
}

bot_overlay_stop()
{
	level notify( "bot_overlay_stop" );
	SetDvar( "bot_Debug", "-1" );
}

bot_path_stop()
{
	level notify( "bot_path_stop" );
	SetDvar( "bot_DebugPaths", "-1" );
}

bot_threat_stop()
{
	level notify( "bot_threat_stop" );
	SetDvar( "bot_DebugThreat", "-1" );
}

devStrafeRunPathDebugDraw()
{
	white =	( 1, 1, 1 );
	red =	( 1, 0, 0 );
	green = ( 0, 1, 0 );
	blue =	( 0, 0, 1 );
	violet = ( 0.4, 0, 0.6 );

	maxDrawTime = 10;
	drawTime = maxDrawTime;
	originTextOffset = ( 0, 0, -50 );

	endonMsg = "devStopStrafeRunPathDebugDraw";

	while( true )
	{
		if( GetDvarInt( "scr_devStrafeRunPathDebugDraw" ) > 0 )
		{
			nodes = [];
			end = false;
			node = GetVehicleNode( "warthog_start", "targetname" );

			if ( !IsDefined( node ) )
			{
				println( "No strafe run path found" );
				SetDvar( "scr_devStrafeRunPathDebugDraw", "0" );
				continue;
			}

			while( IsDefined( node.target ) )
			{
				new_node = GetVehicleNode( node.target, "targetname" );

				// check for a cyclic connection
				foreach( n in nodes )
				{
					if ( n == new_node )
					{
						end = true;
					}
				}

				textScale = 30;
				if( drawTime == maxDrawTime )
					node thread drawPathSegment( new_node, violet, violet, 1, textScale, originTextOffset, drawTime, endonMsg );

				if( IsDefined( node.script_noteworthy ) )
				{
					textScale = 10;
					switch( node.script_noteworthy )
					{
					case "strafe_start":
						textColor = green;
						textAlpha = 1;
						break;
					case "strafe_stop":
						textColor = red;
						textAlpha = 1;
						break;
					case "strafe_leave":
						textColor = white;
						textAlpha = 1;
						break;
					}

					switch( node.script_noteworthy )
					{
					case "strafe_start":
					case "strafe_stop":
					case "strafe_leave":
						// only call this thread every N time
//						if( drawTime == maxDrawTime )
//							node thread drawPath( textColor, white, textAlpha, textScale, originTextOffset, drawTime, endonMsg );

						sides = 10;
						radius = 100;
						
						if( drawTime == maxDrawTime )
							sphere( node.origin, radius, textColor, textAlpha, true, sides, drawTime * 1000 );
						
						node drawOriginLines();
						node drawNoteWorthyText( textColor, textAlpha, textScale );
						break;
					}
				}
				
				if ( end )
				{
					break;
				}

				nodes[ nodes.size ] = new_node;
				node = new_node;
			}

			drawTime -= 0.05;
			if( drawTime < 0 )
				drawTime = maxDrawTime;

			wait( 0.05 );
		}
		else
		{
			wait( 1 );
		}
	}
}

devHeliPathDebugDraw()
{
	white =	( 1, 1, 1 );
	red =	( 1, 0, 0 );
	green = ( 0, 1, 0 );
	blue =	( 0, 0, 1 );

	textColor = white;
	textAlpha = 1;
	textScale = 1;

	maxDrawTime = 10;
	drawTime = maxDrawTime;
	
	originTextOffset = ( 0, 0, -50 );

	endonMsg = "devStopHeliPathsDebugDraw";

	while( true )
	{
		if( GetDvarInt( "scr_devHeliPathsDebugDraw" ) > 0 )
		{
			// get all script_models, script_origins, what ever else is a script mover, and show them
			script_origins = GetEntArray( "script_origin", "classname" );

			foreach( ent in script_origins )
			{
				if( IsDefined( ent.targetname ) )
				{
					switch( ent.targetname )
					{
					case "heli_start":
						textColor = blue;
						textAlpha = 1;
						textScale = 3;
						break;
					case "heli_loop_start":
						textColor = green;
						textAlpha = 1;
						textScale = 3;
						break;
					case "heli_attack_area":
						textColor = red;
						textAlpha = 1;
						textScale = 3;
						break;
					case "heli_leave":
						textColor = white;
						textAlpha = 1;
						textScale = 3;
						break;
					}

					switch( ent.targetname )
					{
					case "heli_start":
					case "heli_loop_start":
					case "heli_attack_area":
					case "heli_leave":
						// only call this thread every N time
						if( drawTime == maxDrawTime )
							ent thread drawPath( textColor, white, textAlpha, textScale, originTextOffset, drawTime, endonMsg );

						ent drawOriginLines();
						ent drawTargetNameText( textColor, textAlpha, textScale );
						ent drawOriginText( textColor, textAlpha, textScale, originTextOffset );
						break;
					}
				}
			}
			
			drawTime -= 0.05;
			if( drawTime < 0 )
				drawTime = maxDrawTime;
		}
		
		if( GetDvarInt( "scr_devHeliPathsDebugDraw" ) == 0 )
		{
			level notify( endonMsg );
			drawTime = maxDrawTime;
			wait( 1 );
		}

		wait 0.05;
	}
}

drawOriginLines()
{
	red =	( 1, 0, 0 );
	green = ( 0, 1, 0 );
	blue =	( 0, 0, 1 );

	Line( self.origin, self.origin + ( AnglesToForward( self.angles ) * 10 ), red );
	Line( self.origin, self.origin + ( AnglesToRight( self.angles ) * 10 ), green );
	Line( self.origin, self.origin + ( AnglesToUp( self.angles ) * 10 ), blue );
}

drawTargetNameText( textColor, textAlpha, textScale, textOffset )
{
	if( !IsDefined( textOffset ) )
		textOffset = ( 0, 0, 0 );
	Print3d( self.origin + textOffset, self.targetname, textColor, textAlpha, textScale );
}

drawNoteWorthyText( textColor, textAlpha, textScale, textOffset )
{
	if( !IsDefined( textOffset ) )
		textOffset = ( 0, 0, 0 );
	Print3d( self.origin + textOffset, self.script_noteworthy, textColor, textAlpha, textScale );
}

drawOriginText( textColor, textAlpha, textScale, textOffset )
{
	if( !IsDefined( textOffset ) )
		textOffset = ( 0, 0, 0 );
	originString = "(" + self.origin[0] + ", " + self.origin[1] + ", " + self.origin[2] + ")";
	Print3d( self.origin + textOffset, originString, textColor, textAlpha, textScale );
}

drawSpeedAccelText( textColor, textAlpha, textScale, textOffset )
{
	if( IsDefined( self.script_airspeed ) )
		Print3d( self.origin + ( 0, 0, textOffset[2] * 2 ), "script_airspeed:" + self.script_airspeed, textColor, textAlpha, textScale );
	if( IsDefined( self.script_accel ) )
		Print3d( self.origin + ( 0, 0, textOffset[2] * 3 ), "script_accel:" + self.script_accel, textColor, textAlpha, textScale );
}

drawPath( lineColor, textColor, textAlpha, textScale, textOffset, drawTime, endonMsg ) // self == starting node
{
	level endon( endonMsg );

	// draw lines from origin to origin until there is no target
	ent = self;
	entFirstTarget = ent.targetname;

	while( IsDefined( ent.target ) )
	{
		entTarget = GetEnt( ent.target, "targetname" );
		ent thread drawPathSegment( entTarget, lineColor, textColor, textAlpha, textScale, textOffset, drawTime, endonMsg );

		// store the first target because we have the loop nodes that will always have a target
		if( ent.targetname == "heli_loop_start" )
			entFirstTarget = ent.target;
		else if( ent.target == entFirstTarget )
			break;

		ent = entTarget;
		wait( 0.05 );
	}
}

drawPathSegment( entTarget, lineColor, textColor, textAlpha, textScale, textOffset, drawTime, endonMsg )
{
	level endon( endonMsg );

	// draw the line for a certain amount of time
	while( drawTime > 0 )
	{
		if ( IsDefined( self.targetname ) && self.targetname == "warthog_start" )
		{
			Print3d( self.origin + textOffset, self.targetname, textColor, textAlpha, textScale );
		}
				
		Line( self.origin, entTarget.origin, lineColor );


		self drawSpeedAccelText( textColor, textAlpha, textScale, textOffset );
		drawTime -= 0.05;
		wait( 0.05 );
	}
}

get_lookat_origin( player )
{
	angles = player GetPlayerAngles();
	forward = AnglesToForward( angles );
	dir = VectorScale( forward, 8000 );

	eye = player GetEye();
	trace = BulletTrace( eye, eye + dir, 0, undefined );

	return trace[ "position" ];
}

draw_pathnode( node, color )
{
	if ( !IsDefined( color ) )
	{
		color = ( 1, 0, 1 );
	}

	Box( node.origin, ( -16, -16, 0 ), ( 16, 16, 16 ), 0, color, 1, false, 1 );
}

draw_pathnode_think( node, color )
{
	level endon( "draw_pathnode_stop" );

	for ( ;; )
	{
		draw_pathnode( node, color );
		wait( 0.05 );
	}
}

draw_pathnodes_stop()
{
	wait( 5 );
	level notify( "draw_pathnode_stop" );
}

node_get( player )
{
	for ( ;; )
	{
		wait( 0.05 );

		origin = get_lookat_origin( player );
		node = GetNearestNode( origin );

		if ( !IsDefined( node ) )
		{
			continue;
		}

		if ( player ButtonPressed( "BUTTON_A" ) )
		{
			return node;
		}
		else if ( player ButtonPressed( "BUTTON_B" ) )
		{
			return undefined;
		}

		if ( node.type == "Path" )
		{
			draw_pathnode( node, ( 1, 0, 1 ) );
		}
		else
		{
			draw_pathnode( node, ( 0.85, 0.85, 0.10 ) );
		}
	}
}

dev_get_node_pair()
{
	player = GetHostPlayer();

	start = undefined;

	while ( !IsDefined( start ) )
	{
		start = node_get( player );

		if ( player ButtonPressed( "BUTTON_B" ) )
		{
			level notify( "draw_pathnode_stop" );
			return undefined;
		}
	}

	level thread draw_pathnode_think( start, ( 0, 1, 0 ) );

	while ( player ButtonPressed( "BUTTON_A" ) )
	{
		wait( 0.05 );
	}

	end = undefined;

	while ( !IsDefined( end ) )
	{
		end = node_get( player );

		if ( player ButtonPressed( "BUTTON_B" ) )
		{
			level notify( "draw_pathnode_stop" );
			return undefined;
		}
	}

	level thread draw_pathnode_think( end, ( 0, 1, 0 ) );
	level thread draw_pathnodes_stop();

	array = [];
	array[0] = start;
	array[1] = end;

	return array;
}

#/
